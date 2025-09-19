Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D12DCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 441068E0002; Fri, 19 Sep 2025 10:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1B58E0001; Fri, 19 Sep 2025 10:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307F18E0002; Fri, 19 Sep 2025 10:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BB7B8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:08:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC83013B924
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:08:13 +0000 (UTC)
X-FDA: 83906179266.19.F830377
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9FB32180006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:08:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758290892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uw1h0zqyCJ+MrI70fVNHHLekDspDIQEV+NKvDauH29Q=;
	b=SrN8Gd7NROkjwXj3ntNetxLCf1KiKFgHG/VJwC7c53wDqF33TRr60NdhkmBIR0FDKxejCs
	LTlJ4bBTSNx5u4Bd2nEhI4iFEiHshDEZyueCqWNRQezEh5fINDkpdVwfpu5WcdzRCDiiL6
	1ZaAV9ZgXCByz23QBUWN2qpr2XK9kFI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758290892; a=rsa-sha256;
	cv=none;
	b=7wtvmtATAG7ItkIk144WFMd1eYiMN2YlWi4B0YLouP//7sD7spRz3L/S89sKnBB9sUXXiw
	NyCa6goJUvF8kZyq0n1t/r6GDiXdkSN7fFl5xx+P2nguJ3yTafoXoBXHXnFEbr9ZElox+m
	RgtkDssggghy4lhKrX8vpul9mpyVq0M=
Received: by verein.lst.de (Postfix, from userid 2407)
	id BBAB368AA6; Fri, 19 Sep 2025 16:08:03 +0200 (CEST)
Date: Fri, 19 Sep 2025 16:08:03 +0200
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
Message-ID: <20250919140803.GA23745@lst.de>
References: <20250918140451.1289454-1-elver@google.com> <20250918141511.GA30263@lst.de> <20250918174555.GA3366400@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918174555.GA3366400@ax162>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 9FB32180006
X-Stat-Signature: yikepc8euujt56rbyzrd4wd964ncdfej
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758290891-849781
X-HE-Meta: U2FsdGVkX1/oiR79HIR1uRgWmcczH4Cg6K/TfJoQmTwrYiK4fogqufCJVb09Jc1Ol9a6C/x56lu159emw9gSq1b81V6Ol7s2tnbFoff7n2pHe6cvc9zWARu0FqBOXt3IFZrlIeT64Le8D+yE8LAuCUlQ6MZbOzZ102Xtw2Nb8pxGSy21f+gbtcQQaM68iuQZJEZvKniWnCirQuB5BHnH5npKduWvBkep3cGdNTpILW/3hX8TXuJH1/hTb9etxFOi0jFMN1WysukhFENk6ot49jkUwmrggKztEECv3mY7maqgzG3yybz9EoPBeOTqK3cbvdB2chobqSbakUcLlAVjQoqFJ20JVpSkuC959H31OJdQTDDcTfoL2FdeoCnom0eOz5sj0aXcnkjk+0BPyerm59Rufl7odvq0XvfPfuDkpceJFVvYNFUb6tggkDtg0pks3ZSVZFrDskLKbAVw4rdRVnQje44bZk1tNI77n/uGp/27q69xAFq+tWIobKd7Kw02b9TCLPwMX2X2TSZVGreXaIKUtcrbaEDJmR6uYuOkJi55kGWpa0VkeuJ7eBP6FPQ0V0xHxOFAK2ttv2lp6XWFDZhhXxmKlkjNiWoXrxgU/9KcpAhf7swNa8s+Zawqsl04M/snIMdJkOEkN+nbBzWdWK6g7GiTjbDXRfjsDC8imx9jiWV1B7OBa3N6nTPf0DWTs8G4uc4QEYB9i0UEExKptryL6uCbbqqLt4IcxTNblByE88aTKskXKak4oyFP0g48tbNSYEAhDqdqCI0eyFk6QLmkcQ+MRnZw0Oy5v6qhFQwzAF4B3FJ3lVP0Z7Ol21PiHHtlYuyjmZOHZVCswi8nHzk9Oa1HlLkRJ42xpXrJbZu77N9TmcUnAI9FtJEhKU4z3jCirG58RA3wmlbuferzv0lKvtXtgf4DtdF3jmjWe0fpTQM1vDZC04/ue8E9Ys006GMM1lhtnd95SZ0Li2P
 JQI0GwKn
 V5Ag8P/yBnwi+xTtGFeiyzBE7NgVYnmgk6pUT1JO68qirIfZEEmWLG1s/tWQh/+YLeBBOUjJDjkURbppV4VMcPvyltA508srxhsChvhchekDReYdTCRrq0q4qiCep2f0uPzBuBC7x2x4/XKxLVuupgQlNYREIZGR+NuoEqO575W6G85KdQAlPNcO8Pw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 10:45:55AM -0700, Nathan Chancellor wrote:
> On Thu, Sep 18, 2025 at 04:15:11PM +0200, Christoph Hellwig wrote:
> > On Thu, Sep 18, 2025 at 03:59:11PM +0200, Marco Elver wrote:
> > > A Clang version that supports `-Wthread-safety-pointer` and the new
> > > alias-analysis of capability pointers is required (from this version
> > > onwards):
> > > 
> > > 	https://github.com/llvm/llvm-project/commit/b4c98fcbe1504841203e610c351a3227f36c92a4 [3]
> > 
> > There's no chance to make say x86 pre-built binaries for that available?
> 
> I can use my existing kernel.org LLVM [1] build infrastructure to
> generate prebuilt x86 binaries. Just give me a bit to build and upload
> them. You may not be the only developer or maintainer who may want to
> play with this.

That did work, thanks.

I started to play around with that.  For the nvme code adding the
annotations was very simply, and I also started adding trivial
__guarded_by which instantly found issues.

For XFS it was a lot more work and I still see tons of compiler
warnings, which I'm not entirely sure how to address.  Right now I
see three major classes:

1) locks held over loop iterations like:

fs/xfs/xfs_extent_busy.c:573:26: warning: expecting spinlock 'xfs_group_hold(busyp->group)..xg_busy_extents->eb_lock' to be held at start of each loop [-Wthread-safety-analysis]
  573 |                 struct xfs_group        *xg = xfs_group_hold(busyp->group);
      |                                               ^
fs/xfs/xfs_extent_busy.c:577:3: note: spinlock acquired here
  577 |                 spin_lock(&eb->eb_lock);
      |                 ^

This is perfectly find code and needs some annotations, but I can't find
any good example.

2) Locks on returned objects, which can be NULL.  I.e., something
like crossover of __acquire_ret and __cond_acquires

3) Wrappers that take multiple locks conditionally

We have helpers that take different locks in the same object based on the
arguments like xfs_ilock() or those that take the same lock and a variable
number of objects like xfs_dqlockn based on input and sorting.  The
first are just historic and we might want to kill them, but the
sorting of objects to acquire locks in order thing is a pattern in
various places including the VFS, so we'll need some way to annotate it.

