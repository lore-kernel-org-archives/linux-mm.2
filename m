Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B45BE909AE
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 15:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AD3D6B0089; Tue, 17 Feb 2026 10:48:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098C46B008A; Tue, 17 Feb 2026 10:48:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDD3E6B008C; Tue, 17 Feb 2026 10:48:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBF916B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:48:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0003B6D26
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:48:09 +0000 (UTC)
X-FDA: 84454379898.15.03BA490
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 639DC140011
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:48:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WLDa+1rH;
	spf=none (imf09.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771343288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHYH87P+PfmJ9W0AOfrm++kpPQ5b8kEilmzfcpLvcPo=;
	b=OgnS+NtO32/RL0CKpbQeeTM9zPk4b/f8OiN+oqYzZa8Vr6Mrk5gw0/rwi8id6nUAMyIsW6
	R3k6TwxSDBZn0t/PVp4oAKNT/HQBIpFywxZTv3TwS10GDvSydfmO4rL7VJ82t1stBDM3yV
	9Da0E2JTTjdAteOa04dH41ZYNVBMcE4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771343288; a=rsa-sha256;
	cv=none;
	b=7tjVxhByOUicRdhchQ4T83lHhAP3za/USM0KUC+MPRuUU/0cBNFFEoZ/MRLoCbmWgV+knz
	jM/HdzZlSoNJhsebKb6DgNBB1ckj137ZCiCpDA2gQMgtdwNC3iFFsUa3VFST5uYrs9k6Bn
	8aOLQMGx5u1j7qdqMkEA3iapHl95B1k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WLDa+1rH;
	spf=none (imf09.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dHYH87P+PfmJ9W0AOfrm++kpPQ5b8kEilmzfcpLvcPo=; b=WLDa+1rHjaSpGUe58q+VPZtPRa
	c2V1E3q0mG1Yp/Rv5t/0FB+N7ZlmnR+gk/eYxrzLGW4HMoB4OzRjuti9QshUH+JY6/B+BZ0x4R9Ct
	srdHexh7JnidKmu42uckLVWj/QIIwe/BayGb/Vro5ikoe3VWXgtB02C1mpQ/7DOdzXIeJ/zPzJl95
	DQKBo5bE8ace0kZDQH0mSFH+LGMBnVo1sV5+IF5L75x506ifJSOdwVTEsp/pIV/s4iLF9wmjwyEBh
	0i3Bt3mP3teVIiEL73SoWH5wwc2gFx9hmDz1uekfrOsP1oJmfZxDpXSjCwzOxOL6EQuf4zzM5UvuY
	RcgdhaQw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsNIv-00000004cPF-327V;
	Tue, 17 Feb 2026 15:48:01 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6413130315A; Tue, 17 Feb 2026 16:48:00 +0100 (CET)
Date: Tue, 17 Feb 2026 16:48:00 +0100
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
Message-ID: <20260217154800.GY2995752@noisy.programming.kicks-ass.net>
References: <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com>
 <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com>
 <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com>
 <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <aZRWOIPThLfIZ1Ph@google.com>
 <20260217120920.GZ1395266@noisy.programming.kicks-ass.net>
 <aZRokyTqsd_RwdkK@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZRokyTqsd_RwdkK@google.com>
X-Rspamd-Queue-Id: 639DC140011
X-Stat-Signature: hm8hxxtrmsbzhos36trfw537qwecsoqq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771343287-329022
X-HE-Meta: U2FsdGVkX1+YSmV7lv2vQUQ6uXZpMKaFYxic9qtBiVjukeyqc8IyoQvnBfmz6heKioat3i2JiFE0e0kA2YXU+jSKd/kqVaoxvFT/1DLhEnYlou4znzH2hwmBFCRN1PMifUG1Q5T6f+tMTSWHvpdeutK1rjK50kzoq10Wg83mjhV65WJ4rzimRsjM2gwK43+Ek4Vj6lR+nhQZOEaBVMT4SSvc41IBgFHDlFj4sI0zIXc1ul47vyw1B0uxqzFmcGNbRSOm03B9qv3vRRscy/t25ju8ORXOCKf3g9EMuHQtALe+OaJ3+A0msY2vDR7MGlKVit4brrTp8hWeloOOIGl3307Q2thnT+Kw6dEZ+K/tOAYt3l1L5j37ra9h3+6yNDgKWcg0d2pJX3bUWe4LnJMeEpvtUPUv9bFiuOTKb3pLX5+G745ujk/eSpavMbLgjMSd6JUfVZqQnywARR1J9IprM0Wr5PRRqGgr1WYbnk34W9Lyx39uQ0t0qH9nMJcK16jBqjjDxoIKgYrquG/4bvD2jpbJArjYCljBb3HBcUgbMcPwXyEPca/ERsyg6F+dp+ujgtYYJbcxvgJhJIeDAEVFz3Q5gA1YvjCI0qepYWMRrmdqCdeSDdAjZjDPj6ZcClFQluPJO/ozcxlG6w+MpSGINgarUVBk8syWacdsS+cEtPYjHByhgfV5qI9ERNOljGoVLyzEHKFnU4by2xhIuM768ntDnXBj9UzddgQ9XC+xanYr9uOGvM8/AtOaDYuRNDsU2/qrklFoYdY0zq6SVAQUISYPj0ClPNN55DiOFTsIzmapDKirsOxV4Kz30zB3z2lBzuDaOX6flvB1hGNBDYPU3ie9+bm9+TRACaKjYvmvrYUyWSAD931MOKHfnNkuE/aeB25T8jyfyU29tNdmLHQ1TqjIeZUIGB3I4v192trj3CD3GhysaNdfyKOlxCotpHyb7yyKKX69PXOeXnWBFQS
 Yoipmkl5
 UFpO7Sx4sgp7fTpqrDI/hk8vqwhMxdrzMY4t1LXqCAIOCDxAkeGI6pootYFzuzheEkDJhQ2ymg2Ptc5lhyTg3bph1m1eLjWa5mqxhpgFg5TQvv62m/oILR/BQ7Du56zQfqGY48x0EqxLg48VQCSDfpBjTebalmoXjUSfPDE3VNC4EzQtnjJ8SfMWUN2JTX/EdIm/8Nz+s55lH2O65fX3w+NiTq4Z+XvW1whVDV3QKsgeFDu6W2a38ioDvhBZ0KPbNo7x1dsCUMLoKrFVI4bSOiOcwtEoMjp/6lgLD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 01:09:39PM +0000, Alice Ryhl wrote:
> On Tue, Feb 17, 2026 at 01:09:20PM +0100, Peter Zijlstra wrote:
> > On Tue, Feb 17, 2026 at 11:51:20AM +0000, Alice Ryhl wrote:
> > 
> > > In my experience with dealing with `struct page` that is mapped into a
> > > vma, you need memcpy because the struct might be split across two
> > > different pages in the vma. The pages are adjacent in userspace's
> > > address space, but not necessarily adjacent from the kernel's POV.
> > > 
> > > So you might end up with something that looks like this:
> > > 
> > > struct foo val;
> > > void *ptr1 = kmap_local_page(p1);
> > > void *ptr2 = kmap_local_page(p2);
> > > memcpy(ptr1 + offset, val, PAGE_SIZE - offset);
> > > memcpy(ptr2, val + offset, sizeof(struct foo) - (PAGE_SIZE - offset));
> > > kunmap_local(ptr2);
> > > kunmap_local(ptr1);
> > 
> >   barrier();
> > 
> > > if (is_valid(&val)) {
> > >     // use val
> > > }
> > > 
> > > This exact thing happens in Binder. It has to be a memcpy.
> > 
> > Sure, but then stick that one barrier() in and you're good.
> 
> Are we really good? Consider this code:
> 
> 	bool is_valid(struct foo *val)
> 	{
> 		// for the sake of example
> 		return val->my_field != 0;
> 	}
> 
> 	struct foo val;
> 
> 	void *ptr = kmap_local_page(p1);
> 	memcpy(ptr, val, sizeof(struct foo));
> 	kunmap_local(p);
> 	barrier();
> 	if (is_valid(&val)) {
> 	    // use val
> 	}
> 
> optimize it into this first:
> 
> 	struct foo val;
> 	int my_field_copy;
> 
> 	void *ptr = kmap_local_page(p1);
> 	memcpy(ptr, val, sizeof(struct foo));
> 	my_field_copy = val->my_field;
> 	kunmap_local(p);
> 	barrier();
> 	if (my_field_copy != 0) {
> 	    // use val
> 	}
> 
> then optimize it into:
> 
> 	struct foo val;
> 	int my_field_copy;
> 
> 	void *ptr = kmap_local_page(p1);
> 	memcpy(ptr, val, sizeof(struct foo));
> 	my_field_copy = ((struct foo *) ptr)->my_field;
> 	kunmap_local(p);
> 	barrier();
> 	if (my_field_copy != 0) {
> 	    // use val
> 	}

I don;t think this is allowed. You're lifting the load over the
barrier(), that is invalid.

So the initial version is:

	ptr = kmap_local_page()
	memcpy(ptr, val, sizeof(val))
	kunmap_local(ptr);

	barrier()

	if (val.field)
	  // do stuff

So the 'val.field' load is after the barrier(); and it must stay there,
because the barrier() just told the compiler that all of memory changed
-- this is what barrier() does.



