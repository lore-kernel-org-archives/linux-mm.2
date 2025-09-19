Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7056DCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5598E0003; Fri, 19 Sep 2025 10:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AACDF8E0001; Fri, 19 Sep 2025 10:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9678E0003; Fri, 19 Sep 2025 10:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8CDC68E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:10:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D30D13A1E0
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:10:04 +0000 (UTC)
X-FDA: 83906183928.29.BAF7AB1
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6F29540012
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:10:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758291002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/+B9KGJ885tcqcRdpYW7pcueEG9ta0QWlanF7bRjaUs=;
	b=hIeRae8Iz/W24TMlSIeqDWM/92GuVoYgOTmuqU27J5qe6BKYSmXuZ8Zx7/JS7umlZbSIc0
	jW4zL8Rkm2Bk0oTo8we0X3HFT5n2XiKsjoL/e8WrXK0paR+aHRq0FdPzICK8lVVuqgWFNX
	XpjIXKG+j6bHXcoi4+ZC1qqawif9tEA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758291002; a=rsa-sha256;
	cv=none;
	b=zQw2URD8BB7O7DZ3YBA2ftoo8/SgEP7Qk1dh6SStOLYK1SGu6CqZlMlvKxoaiFAHLdtQOW
	5FBcFx8XNsUR2DO5DXTJ+evuW+g8kVobMXIdrX8om8Ngwb42u2lfTWihFfB7J+T9vdVk7h
	Q57sXxhDhtzfD5BWS5q7PP2HqXNao1M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 990AB68AA6; Fri, 19 Sep 2025 16:09:54 +0200 (CEST)
Date: Fri, 19 Sep 2025 16:09:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Marco Elver <elver@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Bill Wendling <morbo@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
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
	linux-sparse@vger.kernel.org, llvm@lists.linux.dev,
	rcu@vger.kernel.org
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and
 Locking-Analysis
Message-ID: <20250919140954.GA24160@lst.de>
References: <20250918140451.1289454-1-elver@google.com> <20250918141511.GA30263@lst.de> <20250918174555.GA3366400@ax162> <20250919140803.GA23745@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919140803.GA23745@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: m4igam8xkr6untr7edogstcrpu5657aa
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F29540012
X-Rspamd-Server: rspam10
X-HE-Tag: 1758291002-206149
X-HE-Meta: U2FsdGVkX1+ZMEh3ztHlcZ2wXPSSg9Anpg0Qn9THM2njT4hZ4lc694h0adRJX7/zyNXOo3OiI5jzuiiKQbmjnYdga6ylOz5fGJr1DCXSmWGwCrjzMP/XbZN5FJJyPJb87pgFwzKyKNP8wCly/25mh+jK/Kqq6W8t5N25Hlbla8pv3nVMpOdZONou0GH4dr7pUWPxZtziNDjOebnR7WjnTv63K+0isrIc96NQRDbRP2B2zYo+m1vvlna9ZTPyvt+1nUBF5TGxRXkvccJOjFdI+TeRQC0ykCmSgvJki33lyVBda1vM0cFPEq2fjJjyRO417HOtxrylmeGHbiOBJgzUwgV35XyBk2TYk8VEaN9QW3tbcfmBRzORnbJXGZr86shYNbzxJVE/c9ubr/u37LGMeMYwp0ifYOauGNbPD7CQqHfTv0vJrRIHLpZJbEVe8P/striya/uQDJyIOk9/ajOj48+QEZA0tYvtQRgeIyhc0G8OGFZqtsukIlK4FTlGw0IEILdpMF0mA8v/d6xCuANh51k1Aj5PK2DIdJdncpQq1igqc1yj11HuZLojdeqgQlVARWA24o1hTcRD2xdMzRKe3ZWLwGNFnCq2I/RAlG63Yaa0EJVZ7iZGDk6f1QNSgPeVX2Ew6lK6CWKdLXROtc3iq/sbRMTPhMde/ZZxkM9BZ5KMm3BqZRYNHSTxVg1peilQLInsTF7dRQVUHxPddRjpn5ZZiD9MGUW/p81UHswa/o+WDeH5tdQvypdz+Ax/nf9QBAaH773nD6Bvoz6FCpy4fmsJnCYymyWrxrqWcAXCSXDnI+i9aovS4ntIAE79qcPua7UoALr66GEvb/2Yq0em6oPmZ9e+mK5lq2cTwPalX2csaKMO+Y/EDnj5Y8Ho4ydSTsoAQPxMt1h3eXtUsS5YBy9rCUYNDH3vWp36fwXi3ah0pt5sWX4h1LqNvEV2Lrz1j73BR/IrYOgmigLm3o+
 zxqSfIP9
 vHV9TsgW0zDLoHx2ZOAr4ePamh0vyUCN8VSqlG5J2EgRv4qEwNxoQquHh6KP+LR/KQpY1Te+8AzYIt6SZJXlECkdr3rs0vdA1hTihBo+hsze9isvKzo3L06ggoEh3/1aZ3+8Pakve8NKuBXxp6DUUoZsTMvsH6rFKQQtCk/FSlky6WrDXw8+OlpRxdpyA+JRHZ5LaPXY2mVpDrzlkrxjG9M91UnBt5Ik3TtAA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 04:08:03PM +0200, Christoph Hellwig wrote:
> I started to play around with that.  For the nvme code adding the
> annotations was very simply, and I also started adding trivial
> __guarded_by which instantly found issues.
> 
> For XFS it was a lot more work and I still see tons of compiler
> warnings, which I'm not entirely sure how to address.  Right now I
> see three major classes:

And in case anyone cares, here are my patches for that:

https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/cap-analysis

git://git.infradead.org/users/hch/misc.git cap-analysis

