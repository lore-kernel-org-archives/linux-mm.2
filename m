Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AC23D1A61A
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 13:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84C096B0088; Fri,  9 Jan 2026 08:07:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CFD56B0089; Fri,  9 Jan 2026 08:07:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1AB6B008A; Fri,  9 Jan 2026 08:07:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8FC6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:07:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0869FBAE37
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:07:05 +0000 (UTC)
X-FDA: 84312450810.01.3243530
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3940AC0008
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:07:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767964023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6M6S2V9hKywkfT+wbmVWWko9S8WTPsC+i25HW/je+LE=;
	b=zFAUVIq3oT3u3h4wSgQlO/RXN4u+ekR69PH7/Kyeevq6DzGUmd5D+9nBuXu7kjpBcZnaCY
	TY30fc0uNjDc1Y8fre8b9DvkwbnBEQ2y632AzUspMnLdLF8g08L6bpPDbGC6E6GOdpftoO
	BAsltaWkFmUvpgwelCDDQUR67rxE0bw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767964023; a=rsa-sha256;
	cv=none;
	b=g9/Ps4jGwMaP/jbBCOvdtunXpRgmhZ6S8kok643DXJZzHZSan0dQjIWMxgG6TN40E4+ym7
	nfBOhVr1bamT5/vZbWt1bsLjus5fI9edpsqWRahfGehxAMEvMwBz3gKL9XQIbqcLUO42k1
	h7x96wJ9rVf1bApqpOVywczsbEMEx6E=
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32BC75ACA9;
	Fri,  9 Jan 2026 13:06:58 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf13.hostedemail.com (Postfix) with ESMTPA id A03A520010;
	Fri,  9 Jan 2026 13:06:44 +0000 (UTC)
Date: Fri, 9 Jan 2026 08:07:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Marco Elver <elver@google.com>, Bart Van Assche <bvanassche@acm.org>,
 Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>,
 Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, "David S.
 Miller" <davem@davemloft.net>, Luc Van Oostenryck
 <luc.vanoostenryck@gmail.com>, Chris Li <sparse@chrisli.org>, "Paul E.
 McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>,
 Arnd Bergmann <arnd@arndb.de>, Dmitry Vyukov <dvyukov@google.com>, Eric
 Dumazet <edumazet@google.com>, Frederic Weisbecker <frederic@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, Jann Horn
 <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, Johannes Berg
 <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, Josh Triplett
 <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, Kees Cook
 <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn
 <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda
 <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Tetsuo Handa
 <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>,
 Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman
 Long <longman@redhat.com>, kasan-dev@googlegroups.com,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
 llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v5 10/36] locking/mutex: Support Clang's context
 analysis
Message-ID: <20260109080715.0a390f6b@gandalf.local.home>
In-Reply-To: <20260109060249.GA5259@lst.de>
References: <20251219154418.3592607-1-elver@google.com>
	<20251219154418.3592607-11-elver@google.com>
	<57062131-e79e-42c2-aa0b-8f931cb8cac2@acm.org>
	<aWA9P3_oI7JFTdkC@elver.google.com>
	<20260109060249.GA5259@lst.de>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/Yuy/xlEJ4FchBK8FGPRyEzpxFlfJw7cM=
X-HE-Meta: U2FsdGVkX1/mK5KxM694kU63Rdn/iZMuRkOJbrkqpBY9gVZfABZTPJnGV+GXEC41f1CraOV8yVb8JwE6ex2vbV4aoxOT3VLKLF5Thmk+n9vBrpyyHnFtGdrkM3exSJJfO3l1oVR97XyrKK8Hkfj/5sdmmAH04zSgJDoYobVhPLcJaqT68Q0XdWN9PbI1sOsFrspcL2fHNGmrmo/p6rwpjlSypMilSM5I5ewwgNFo1hyODxJhs+YqTtFErumcaYRIY1tmmRLhIj0JwjIBTskcyNNIQY/Qv4I7CCtQ3inbL2pdKc5Mrj40SiW4O33CrPwJHtQvEPJd1GEXqrywF3gfPLCE0T+XQaZa
X-Stat-Signature: 5xymhh8pz4wy83zfy434cojkg5jknfmr
X-Rspam-User: 
X-Rspamd-Queue-Id: 3940AC0008
X-HE-Tag-Orig: 1767964004-230449
X-Rspamd-Server: rspam08
X-HE-Tag: 1767964023-999665
X-HE-Meta: U2FsdGVkX1+jEvtskwYAODMQ5p2jxVNGJ4eSj8M+dXMTeMa28cjjuz+nOiCuFrF8XWfFFANTuY6GibTuMzN8g8Ktsj1JDohBMhsb5OLgU8sz78ZbuLLZ2xE7830eQGqzFUuaRqPYk76OBwmlB6OfIBjQN0ROIklO5JVWzyZj8CTm9/06QYTtMa3sDau7GAanasQA/ZTatBuC61HTVQUh7p13Mwg0BV6cI2Xf9FzOU4mNdnvKbNeySGie39RPLabWDqcus98wZ/lyD2XY47HzxtWH74flurAbz8Akbw22oOuV44HlfJS+EfMuPr7rtqBkh9t/vDzRb5dHUYnPvJdswpkKaZk2v+tFoBjZ9qlutXOzi9iCRFTNPnHKxuzeHxmNSYxc282ILkYl8HSIadOmArlz7CBFfug6aSMm7vuyn3mtFmwqKuZnw9ddHk7qT134cqOwJRzGfhRx2JJo9AmAvMSXToTHDW8OmpYhCecDSUYSn5uE94ab/x2+A6tN8bv/GW9Y5hxfDNMdxrmYMXhxGjEIPzLxDbPbRXjZVKikoSzrlLaERQb+UYlNGE62GZt2SGpvf3lgpOXbdeprjEtuJywx+rLzUTAmfjlPB2mI1qXKa3sYcipLyEBT+5vrPLcN6O62oycSPIeAe9niuDUBddrshAPDJgl2OQLXGs/0rqFSQv+kCB/QPuB8IZP7VnP+uNERWhLMGptGFU7SWeufRWBU5C2VN/BHbpNtHjUJSs5X5q8f6Xnn1cwdXQXKM7aUq9JqO7txxxM2yJ11EaQY5kEtcrwA5SsIw2l4lleRJBh2+Dp6Q0bxo4NBYVWGwBjbrpGTX03HnFlziw/p3Ep8LoocAGpxxmSGEO2hk0BnBJ0v1FeLd/uflmNMwnHTkigOTqsNb4YooLn888kVIE4oBPnRWcdqeEv5XN+uJeQ5tkJicmC7MKGDbvFp5l4Rw8GK76Y4iSAeZnPOuqNHKXP
 67wwUPNt
 uHcJhAn/hEagcaMqKC2OZssfpzhtaUBwckgoC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 9 Jan 2026 07:02:49 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Jan 09, 2026 at 12:26:55AM +0100, Marco Elver wrote:
> > Probably the most idiomatic option is to just factor out construction.
> > Clearly separating complex object construction from use also helps
> > readability regardless, esp. where concurrency is involved. We could
> > document such advice somewhere.  
> 
> Initializing and locking a mutex (or spinlock, or other primitive) is a
> not too unusual pattern, often used when inserting an object into a
> hash table or other lookup data structure.  So supporting it without
> creating pointless wrapper functions would be really useful.  One thing
> that would be nice to have and probably help here is to have lock
> initializers that create the lock in a held state.

Right. If tooling can't handle a simple pattern of initializing a lock than
taking it, that's a hard show stopper of adding that tooling.

-- Steve

