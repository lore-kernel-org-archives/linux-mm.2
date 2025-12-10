Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C3AD3C928
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 16:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37F7D6B0006; Wed, 10 Dec 2025 11:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356886B0008; Wed, 10 Dec 2025 11:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C8C6B000A; Wed, 10 Dec 2025 11:37:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 163AA6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 11:37:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99CEB134ACF
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:37:25 +0000 (UTC)
X-FDA: 84204116850.26.74137AA
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf21.hostedemail.com (Postfix) with ESMTP id 185CD1C0013
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:37:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="BYu/J6AO";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765384644; a=rsa-sha256;
	cv=none;
	b=okcbSRh6fDYuGK0vUMYMc+0WbXvwV6lg/GiBa2rVAWueORbWrdtUFBiLCQffUkNbIwZt4z
	5SKks0xgAPjqRikmRyYfER46ZsVgHGEQI4u6pia8PMsCotdZZg0qcqQj99VH19WC9KP63q
	2VioSLLPUJi2ancqb9bEIpAT3LBwyII=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="BYu/J6AO";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765384644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgo0gn00i5ezpmur+oazSYFqerNtpx0n/NmNjZb+ZMg=;
	b=nT9oo5rXmBO0QLt0bT12/GOGn+TME9m2tJAQfQ1RuUgGEQWwrQJrn+YXMQ7K8ngqGg1KEd
	DjNwid9bBOGqaBr4MHEmMoeQik4q3pNsJ2b7Xhs+tW2UznRrKO8zKrvnBZndOLGnqEkCbs
	f66nJxOi/QRTFA4+HcawEGTZYitaGVg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kgo0gn00i5ezpmur+oazSYFqerNtpx0n/NmNjZb+ZMg=; b=BYu/J6AOcF2tcc1KVJ32FxlxHU
	bU3jWS69I/gzoL5rBfMEk59+8SQbX3m1TlSNJJBxfMpkoI1KbFOV27y7QMVenzPHs2zsO9Sf9JDR/
	0uQ3VHyBkDCTe/IxD+Z6b87X+qxa2kKTWHsibvBOBaekXJ6QPk+VCsTlrEk0LXs6LqwXPIzUtPCHi
	DgQm6ujZfpSwd9uSbFR7ePLCGitwY5+n8wyOncj7wceU19MDKcL1WcIIAVXEvXl9cAjIOPG8mYxWw
	6JMAH/tcx3NXcdb2kiwaVULI21AwrcK3vWCo8+YKj4qPCyLpmW/tbyigfGqh1WkZkRrZSQx7w1fJ+
	QH9+jTew==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTMJz-0000000DbAQ-3Ck2;
	Wed, 10 Dec 2025 15:41:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A3513300566; Wed, 10 Dec 2025 17:37:00 +0100 (CET)
Date: Wed, 10 Dec 2025 17:37:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marco Elver <elver@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v4 00/35] Compiler-Based Context- and Locking-Analysis
Message-ID: <20251210163700.GN3707837@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <aTmdSMuP0LUAdfO_@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTmdSMuP0LUAdfO_@elver.google.com>
X-Rspamd-Queue-Id: 185CD1C0013
X-Stat-Signature: nz49umptf96ispiij71aj1xqrez5zrih
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765384642-948823
X-HE-Meta: U2FsdGVkX1/PtSrkRbuRs9TIQqHyyGDlSd7tNEUFvj8bYQ377MtjEq8iSIQuJXANL92+dcPJwjzRUwhRAXciclxuVyuAgDTN9qp2rfEkHo/on+HanO/AzYgr8YrUCCJGTLzUgVQGAFrtmdVNck/5e7c1eoescEoFWaxat0phza1hi30CzedF0CbTsipbAnfkTlC2E5VBH+0SgkIAVSsamlQyHtTPQri5z7eHQR/8E59PulKwD0mPxiRSjLLQlW4LTfjpN5AfI066jpwa7LIZb3aCQOzzQ5BCLeI1+XKWd1PfejtUbYikTKXwqHHze5nzsHyzcuKQJrgQS6VkSSU5/maIcqT9TRHLSRYsoJZpLrtc3Wf9RTlflonB0R5PUIt1irQKlGO/MhMxbZ2xO8WEvAmBYC/BcYYFXUdjjgE5vXI248erPRMhzFJ2A36z6BrPyl4T/opw0kbfiLKr4ESqaphiPl4/Df6ZWHpcbS3X+j4b7UavS1PrU6TBU9OU3YcZpe58gP+dWkWLFaGJOaMp3pLctf8HGdLFGf/qWzRmquxhamNyVx9HUxlgTQTxM5KRVmfSAP9475g0WSh7oO6jZPtHUpVkeXmKNoCsnJydq5uGbV7JqiFBMpbt6sfIQD4Wevg2YZP/F3eZ84XPVxtzfXqBjD6n86scr7rpR0KSi1nGf5Qyy1T8lpoOj+bvV+dQhpiJdhJJ0kMrl3UzPflmsalkE7kAC8YQw4McBdklDytoB43W+foF+lU3t3aduHVYw/DrSlGy17TpuIUsQZ79jUuWPFr5tiqLzewnCpqPhD7YpDgXCumcNV7AFHe1wtKHV9kU46TarIzbxHtWcWxAzTdop/Josp2hnJ9bnNLowhBEHFXhCejWbtUBmrSalvO/ncMzfuJ2GSkLsJn3OM3vBIcLQSnZnh/uckum4zrCt7dZ0Rjcmh92ocbW1QvIfLYtfiMpJuETqxwemKhJexL
 7w6coDIU
 DsChVRsaXVif5A+09ihFgoiBXVquoIrxer5POTwK3ECnQMNFaiP36rdsC28J2xE9Cqbu9D79xQ3vnx1scVpx3WQUb1c0mutOd1LI+EdN/ap+sOKqpUTfJIMg2Rja10zZMf8xbZK8FPFhdVvLU6bzybtnfhdv1R2LWeT/fv8sYGhFkA7Cx8CdEi0mmXBp9/mfi+nOMo5CyU/mcGjofp9vxPjQYLSRnsO4zhrySyZClLMSc5iXBNRJ+TT3ZhGbn3ZsBmCHg5hKHod2mGVRpIwd36BvqA417R9FFaJxUpF7vVkK3ekp/3aXU0AGI2cMLemf+sRE7c+AOpU3BqddZM6oJ0pN24RYcdrqpSr7cArftwZUPY8w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 05:18:16PM +0100, Marco Elver wrote:
> All,
> 
> On Thu, Nov 20, 2025 at 03:49PM +0100, Marco Elver wrote:
> > Context Analysis is a language extension, which enables statically
> > checking that required contexts are active (or inactive) by acquiring
> > and releasing user-definable "context guards". An obvious application is
> > lock-safety checking for the kernel's various synchronization primitives
> > (each of which represents a "context guard"), and checking that locking
> > rules are not violated.
> [...] 
> > A Clang version that supports `-Wthread-safety-pointer` and the new
> > alias-analysis of context-guard pointers is required (from this version
> > onwards):
> > 
> > 	https://github.com/llvm/llvm-project/commit/7ccb5c08f0685d4787f12c3224a72f0650c5865e
> > 
> > The minimum required release version will be Clang 22.
> > 
> > This series is also available at this Git tree:
> > 
> > 	https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/log/?h=ctx-analysis/dev
> [...] 
> 
> I realize that I sent this series at the end of the last release cycle,
> and now we're in the merge window, along with LPC going on -- so it
> wasn't the best timing (however, it might be something to discuss at
> LPC, too :-) .. I'm attending virtually, however :-/).
> 
> How to proceed?

Ah, I knew I was forgetting something :/ I'll try and have a peek at
this series this week.

