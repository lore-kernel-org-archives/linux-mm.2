Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D4FE6816B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 11:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE26A6B0005; Tue, 17 Feb 2026 06:27:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90376B0089; Tue, 17 Feb 2026 06:27:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8EC56B008A; Tue, 17 Feb 2026 06:27:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C28EC6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 06:27:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B4148DA63
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:27:58 +0000 (UTC)
X-FDA: 84453724236.12.891056A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8DEF160006
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:27:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eWgr0jx9;
	spf=none (imf08.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771327676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=stb0z7knForfhqJYkYuHTJ6w3kMgucRX9hnQ4DntjkI=;
	b=zyC1xNNqzt8+9miTp1cxeszX4HYYUO7ReAwWDmCbCOxir7c6qdBv1Tvjlos4Wa3x3o6bcf
	jAYc+qibRRKF2SoWze7Eoe01gdGF+8DzWAMPMV961Db5L3YlcY1Iq01LB+UcyS1JkrmgdL
	8kuVvwbM+sha57HcmAQQDg2DLT1i6/c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eWgr0jx9;
	spf=none (imf08.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771327676; a=rsa-sha256;
	cv=none;
	b=eePMNj8ko5Vjtj2dXoBUYxBFF3Ze1NmN1Ppm+EW0xjjEf6odAVAlc5Es9hb/3B3Bd1CKx1
	HKH7nMfgougKk+HO+22rx/aEidxaTNznSAXcOR5yFVGHmxWJ2is0EAIL7uqZyTfmzd7p8g
	0PUCnmaoET0E5Tf/zoyrI1gREDmSg2w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=stb0z7knForfhqJYkYuHTJ6w3kMgucRX9hnQ4DntjkI=; b=eWgr0jx95zdtgddw/APUJ2QAvn
	3M7U1Z4NmdgpLCD8admb1ymds/+cFBkUjg0lH1PRJq3NvfT5Gflve7TyOktCfkZ1JYap3Q9sKMFWY
	R78ugf2T929QxlR7hLomjGQk7i1MZH3fR5PQB94Ur93i0hsvPRSH7H+CQiVjinLHfuLaljW6Ld6+j
	H52D05iQzGtQsEfK3cG0fWD+H25qyma62GuWpV36ryh5N1nvyoQY5HLZvjRwM0TieBbNm+RZG6WvW
	ZEqy5xDZRWJHov7eO1Y0IsCmNaM78YALUmNtSW9JtB5qA41dJ/QEe4+R7kkdCI6RP16x/0V0ZYi1W
	e+LbKFEA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsJF8-00000004Li2-0mRV;
	Tue, 17 Feb 2026 11:27:50 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 00EF3300CDE; Tue, 17 Feb 2026 12:09:11 +0100 (CET)
Date: Tue, 17 Feb 2026 12:09:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
References: <2026021311-shorten-veal-532c@gregkh>
 <aY9HD7nH5A-DtgmR@tardis.local>
 <2026021326-stark-coastline-c5bc@gregkh>
 <aY9PBfx3RRV7rXZ5@tardis.local>
 <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com>
 <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com>
 <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZRHJ7pSzOHruPA2@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D8DEF160006
X-Rspamd-Server: rspam02
X-Stat-Signature: 5acbqpszt5sep5nqqfun6ikx6uikig3p
X-HE-Tag: 1771327675-296983
X-HE-Meta: U2FsdGVkX1/IZvm3knUKqr51WJoCAQIArgRX1qRHBiSYTjHtlJQUJSc2krXl9P73rNamO8Jx9vNvhAtUTVFdsH9fzFfgSqVHGVrCguaSiSCpotnmFTMO7RQxR5jmt3r8GdyVpXuqtWWIfu6Fr0zqeoMeTiL8cxu/JHNjBqSeofaaNkNrwSadnjRQwQHkk50KE+1lstLUQv7QV6mXDBbejVzzDazJZfDgUNvEKaUo6tFgIfnXQhNVIDQO2a/cLJVsYfxqsej7O7zRCB+xqgghDM6oEmvOz0aUD9rH2ZpGDhag56E7sac54X2Kui+5ZY7wVMia4+ufbg2ZEQgSIRB86VPmaBx3+Tp01APkk9X6euYKqi1AqgZxPvZ9bpP27Vda26+HPBV/6eTsc+UUmkEBTWXsSayfACQPB6SvvcD8NECAJSfCs4Q/UxJ5o0k7i4T/MnIPdMrr5SJA/2Wqv2hspbktds24Zt7gmJ0+Z9rNK5xdzThAWxAV8ZUhMRXf8qerHzqkM0O4CAAFo6bl/ZVSmmczh22qOrDx/hx5hr5zxabFFmNOAVCiY6ZJAfUnEINu+8STVfdCwZAbA4zmha6Lg7i+oDEkx1tpYfsWfO/Hrt3a5ZsThfnlvsKyKoE0XM2x+BdyqgG94nl14UXQHEsHl7qAv1UMPnDO6mcX+dWyXXUlwzsiNtgPHr0XH0HYpYL/sYCNA5bBft1YfIlDP/box50C1S0xFOfWoiwKeCqf5bkhhMhOlthyihCr/d5OpJ8IEg79rS4+mPCfAHcga+YD/5nXfM2+HvODJYvBNSKRoq6zB3DrXjgsu5vvBEZrWXcApg2CIFwC0Xs4zmkwMYw1zPFsqS2EjTdn9ZaEMGn9bRK6Rmjs1OvRhx74lqSuWPbUyny67Rl03c2VBr5iWPQoiuJS+SeVU1yjd3ZkX/Zd7JUyJNpD9WyvUTKMtkZPO784DvWPMuSwHwWSjTVmuZJ
 eIBKgX5u
 mYVuiWCDnTbraEOZWuB2uC5XcGV0cWwUZ1g5qgMfGcOFtEnxdeQa1nE5nubLQoAhSDeHfwoaA9/cS+Q+Xll6VjVCo+oAMee34+jq7bzHtqi+y3bDdTF8ajm/0LGE5PEHlbrDyGUrvTe4FczVoilhyPX9wuB5Xbph147RBM71e1a85u/c9yLkpq0gP66nJ92E4vi6GIG6PySzJZVT0IhZY6a1N7NBoLDeQYK4TCDNXbP5c/BKdGAKiFsfRVItcaT0cq7H+gkjAlA1L5MvVIYdTj/WJdwzCHHyOe+I5C4jTChfb/aCWX+jit9n33Pem+JgdVcxHguPpFWBDy/o5qHMSpMVMWtmHXp+cVNWyv1cPRmD1hRt7aZXuWCtXqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:47:03AM +0000, Alice Ryhl wrote:

> > Stop using atomic for this. Is not atomic.
> > 
> > Key here is volatile, that indicates value can change outside of scope
> > and thus re-load is not valid. And I know C language people hates
> > volatile, but there it is.
> 
> Well, don't complain to me about this. I sent a patch to add READ_ONCE()/
> WRITE_ONCE() impls for Rust and was told to just use atomics instead,
> see: https://lwn.net/Articles/1053142/

*groan*

> > > 	// OK!
> > > 	unsigned long *a, b;
> > > 	b = READ_ONCE(a);
> > > 	if is_valid(b) {
> > > 	    // do stuff
> > > 	}
> > > 
> > > Now consider the following code:
> > > 
> > > 	// Is this ok?
> > > 	unsigned long *a, b;
> > > 	memcpy(a, &b, sizeof(unsigned long));
> > > 	if is_valid(b) {
> > > 	    // do stuff
> > > 	}
> > 
> > Why the hell would you want to write that? But sure. I think similar but
> > less weird example would be with structures, where value copies end up
> > being similar to memcpy.
> 
> I mean sure, let's say that it was a structure or whatever instead of a
> long. The point is that the general pattern of memcpy, then checking the
> bytes you copied, then use the bytes you copied, is potentially
> susceptible to this exacty optimization.

> > And in that case, you can still use volatile and compiler must not do
> > silly.
> 
> What you mean by "volatile" here is the same as what this patch means
> when it says "per-byte atomic". If you agree that a "volatile memcpy"
> would be a good idea to use in this scenario, then it sounds like you
> agree with the patch except for its naming / terminology.

  struct foo {
    int a, b;
  };

  struct foo *ptr, val;

  val = *(volatile struct foo *)ptr;

why would we need a an explicit new memcpy for this?

> > So I'm still not exactly sure why this is a problem all of a sudden?
> 
> I mean, this is for `struct page` specifically. If you have the struct
> page for a page that might also be mapped into a userspace vma, then the
> way to perform a "copy_from_user" operation is to:
> 
> 1. kmap_local_page()
> 2. memcpy()
> 3. kunmap_local()
> 
> Correct me if I'm wrong, but my understanding is that on 64-bit systems,
> kmap/kunmap are usually complete no-ops since you have enough address
> space to simply map all pages into the kernel's address space. Not even
> a barrier - just a `static inline` with an empty body.

That is all correct -- however that cannot be all you do.

Any shared memory will involved memory barriers of a sort. You cannot
just memcpy() and think you're done.

So yeah, on x86_64 those 1,2,3 are insufficient to inhibit the re-load,
but nobody should ever just do 1,2,3 and think job-done. There must
always be more.

If it is a ring-buffer like thing, you get:

         *   if (LOAD ->data_tail) {            LOAD ->data_head
         *                      (A)             smp_rmb()       (C)
         *      STORE $data                     LOAD $data
         *      smp_wmb()       (B)             smp_mb()        (D)
         *      STORE ->data_head               STORE ->data_tail
         *   }

if it is a seqlock like thing you get that.

If it is DMA, you need dma fences.

And the moment you use any of that, the re-load goes out the window.


