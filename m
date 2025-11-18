Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37352CEE351
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 20:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709676B0089; Tue, 18 Nov 2025 15:36:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA1F6B008C; Tue, 18 Nov 2025 15:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8E76B00A2; Tue, 18 Nov 2025 15:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43DF76B0089
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:36:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5D871601EA
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:36:12 +0000 (UTC)
X-FDA: 84124884984.25.12D77B9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id C7DEE1C000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:36:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dQYjUwS0;
	spf=none (imf18.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763498171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ne+SHPq+6VfT3qkrqy+bvDWVXNhMCjamVWYxqPzmM0=;
	b=yJXi+5sHy8To+0Lytjc/6DGbH0kXGvgl87hVs1EXAy0HxGYzzORcnogxL1fcrFm+n51D/+
	c8dwR/ILeptIXlxMoJTtscoBggPOYcJa5rSgUTf11y1S6MXrjGufIEEgXM4jqcSmWmch+i
	ikrnm9fn4YOLwSFKV28B7Yp4ji46cqw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dQYjUwS0;
	spf=none (imf18.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763498171; a=rsa-sha256;
	cv=none;
	b=gnWFGbrZa6KxCa2LBd9HaPCWKBh3q03tpnR7XdaNi+quL3nS4VEBpk1a5m/GAOkIKNYRn/
	lVfITE/C4IpSLmvky15ViCK335CqStcjIUxhbqxLsaS3YIK21K3bU7qXHuCVrp+IcQHvHH
	eN0BYICHYB0Que91vRhrJgBTUWI6ft8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=8ne+SHPq+6VfT3qkrqy+bvDWVXNhMCjamVWYxqPzmM0=; b=dQYjUwS0F/eF5JFHzulMGPE7/R
	Nsv3HHQLChzccVJNLthlJVWge4zFzSRLsLVQQ37whooTxdTj1bcsEA6UpxPEvPMvM1NZPz1by65We
	WivCwDtXzheyVYkA9qVxWQ+QNJ2IgFKH1oFKL5FWHaFORTBwG5GCR23W0MYZdCeZh+TqcEwT3BIJs
	pAfRj/aTKtsRa0rydgsDjGuvnO3v7F4yYBZbJK3QWFrdkK/S+9TKmdaVtFpBEnRuE7jurKaILpvSk
	PQbASaYi5nvrMq9E7lf4ng4/y60qkhks4T/rc0Cu711O6g/vAAy0ZQOhJgxQsBvaAGS86NJm7xsVA
	/GIt6h3Q==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLSQb-0000000G1y8-01Pb;
	Tue, 18 Nov 2025 20:35:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A093D30029E; Tue, 18 Nov 2025 21:35:51 +0100 (CET)
Date: Tue, 18 Nov 2025 21:35:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Maciej =?iso-8859-1?Q?Wiecz=F3r-Retman?= <m.wieczorretman@pm.me>
Cc: xin@zytor.com, kaleshsingh@google.com, kbingham@kernel.org,
	akpm@linux-foundation.org, nathan@kernel.org,
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de,
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com,
	kees@kernel.org, baohua@kernel.org, vbabka@suse.cz,
	justinstitt@google.com, wangkefeng.wang@huawei.com,
	leitao@debian.org, jan.kiszka@siemens.com,
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com,
	ubizjak@gmail.com, ada.coupriediaz@arm.com,
	nick.desaulniers+lkml@gmail.com, ojeda@kernel.org,
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com,
	glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com,
	jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com,
	dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com,
	yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com,
	samuel.holland@sifive.com, vincenzo.frascino@arm.com,
	bigeasy@linutronix.de, surenb@google.com, ardb@kernel.org,
	Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com,
	kas@kernel.org, tglx@linutronix.de, mingo@redhat.com,
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com,
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org,
	rppt@kernel.org, will@kernel.org, luto@kernel.org,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 15/18] x86/kasan: Handle UD1 for inline KASAN reports
Message-ID: <20251118203551.GQ3245006@noisy.programming.kicks-ass.net>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
 <8b0daaf83752528418bf2dd8d08906c37fa31f69.1761763681.git.m.wieczorretman@pm.me>
 <20251111102719.GH278048@noisy.programming.kicks-ass.net>
 <a4vtlaxadmqod44sriwf2b6cf5fzzvngl6f5s2vg6ziebahjtv@yctbqspkdn2b>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4vtlaxadmqod44sriwf2b6cf5fzzvngl6f5s2vg6ziebahjtv@yctbqspkdn2b>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C7DEE1C000D
X-Stat-Signature: 5ys4jgihgtr1zx4gddeuspppikizcfcs
X-Rspam-User: 
X-HE-Tag: 1763498170-428858
X-HE-Meta: U2FsdGVkX19C2T30QVMT1Z3pz/wIAq+r2BJmSI4sQi8Ue6hhHc3PZBSFYYXgkLCym2wit4UgM4EBCU3Drh/MK8/7fXvDLgCPR+seOOvtT9OMgOX/579q28eiA6uTAFZJRL9L/FYPTnGx3Zq7l61CJ19CZKazqk/38X+rb1Pk0+LqxOWOlb+WtTpOaSLJExzwjRfRTQlUs2icjZb5sChlglKAk0L3vfTCOP6zYYelbl1Hqno1GQKopawFuJ1PxVDEfJhzRcJF6LtIbSINhbP+HZzL5JN89vmt1lDIu9jiYflap/A7CR3aLvCQRMWoKHnf53mVqpo8C7Wsd83CLcFtPUakKkNWoAGaTxSy2FCHAzRO3dBkgLKr3AIt+Pw5W3i5rBJf9oA8FVz5ndikTVvlb55ssRw+nNYVKcJ7k0QWOe3nuVT0xk/H5rMdIT4BvN83c80ie+DcFP3oXuGZcnB9PJ6pIBx/Vy6APf3adwmMAuZ2/MBTn1WU2ZnRKMi9NpaH7YjO0nF0PxcL7cTHTX3F2CH82H9zy1iLw7L63XBhrOUuNs4Fdwiyrwuahk4/eTeGe8cOtTmtFMLQlfWhrtF8CchieaUzNIdvNJw7GadfZvRHvpEjqelYjLj6G7f1yNfEg8+un3WdNY1Us9U52rFSCWrJYQ00bGGCIasYKU0NZCEo4s2Ko0GDYHbkfulcW+Oj1LO3GGdsiSHn/rnyVdCuVOevjig23dDWZnbqODzHsP1QOsrLMPmr7UP2MDxxy0xDbpVrDFcWP1BaEp4hFGrl3dQAQONQ/EuWgBoOCJ6QSbtNqhDjnGfbufLl0OdA8hjAY3hMtyV9esfftVjiklu8tHxDVBQwsjFqmEgg14upZQlfwM7ontvHlzQpa2+SfDJWI8GCVw+CBfmOx0xS2Pix0xe3A51ionovMAJZCW4pYQROeKStbRZQg7k9HgWfeMWBuCCu/qacHJ5Jtx1fqC7
 7Z8XNciw
 f9NxW4Bhkqt13RKRhQuI34A5jMk/fSdr90lpQ4Npn8AE8C82TTchmNDsK9rto0FJ9o05p5Jirik0uPpXwI+GizjUOvI9AgUfbWONQPa1OIz+a3a8RydYGU8XpMY+xrWSrhNKd2Nvc4orpOkj7p1d0QLzVwFSJtm8t6+fgEZyVTUBNjGxD0CfD38C8onsmLCRYGZFGf5hbXV7yv44Me969DUyix8zbBtI7Wl2+NC1CPqTFB6rJsNJZHZyjLdUTxQ7OKbqy7PK9LcHDlzS8U4SBh90DB8QXJHD6C1LLFmIG8nIXfyqrV5jxxzn8bg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 09:47:20AM +0000, Maciej Wieczór-Retman wrote:

> >> +void kasan_inline_handler(struct pt_regs *regs)
> >> +{
> >> +	int metadata = regs->cx;
> >> +	u64 addr = regs->di;
> >> +	u64 pc = regs->ip;
> >> +	bool recover = metadata & KASAN_ECX_RECOVER;
> >> +	bool write = metadata & KASAN_ECX_WRITE;
> >> +	size_t size = KASAN_ECX_SIZE(metadata);
> >> +
> >> +	if (user_mode(regs))
> >> +		return;
> >> +
> >> +	if (!kasan_report((void *)addr, size, write, pc))
> >> +		return;
> >> +
> >> +	kasan_die_unless_recover(recover, "Oops - KASAN", regs, metadata, die);
> >> +}
> >
> >I'm confused. Going by the ARM64 code, the meta-data is constant per
> >site -- it is encoded in the break immediate.
> >
> >And I suggested you do the same on x86 by using the single byte
> >displacement instruction encoding.
> >
> >	ud1	0xFF(%ecx), %ecx
> >
> >Also, we don't have to use a fixed register for the address, you can do:
> >
> >	ud1	0xFF(%ecx), %reg
> >
> >and have %reg tell us what register the address is in.
> >
> >Then you can recover the meta-data from the displacement immediate and
> >the address from whatever register is denoted.
> >
> >This avoids the 'callsite' from having to clobber cx and move the address
> >into di.
> >
> >What you have here will work, and I don't suppose we care about code
> >density with KASAN much, but it could've been so much better :/
> 
> Thanks for checking the patch out, maybe I got too focused on just
> getting clang to work. You're right, I'll try using the displacement
> encoding.
> 
> I was attempting a few different encodings because clang was fussy about
> putting data where I wanted it. The one in the patch worked fine and I
> thought it'd be consistent with the form that UBSan uses. But yeah, I'll
> work on it more.
> 
> I'll also go and rebase my series onto your WARN() hackery one since
> there are a lot of changes to traps.c.

Thanks!

