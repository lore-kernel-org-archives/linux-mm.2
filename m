Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5714E6816B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 12:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28FB16B0005; Tue, 17 Feb 2026 07:09:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213366B0089; Tue, 17 Feb 2026 07:09:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1204B6B008A; Tue, 17 Feb 2026 07:09:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F1B1F6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 07:09:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99208C0317
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:09:29 +0000 (UTC)
X-FDA: 84453828858.16.295DCE6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id A8D68180004
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:09:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MPK6KMf3;
	spf=none (imf16.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771330168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvEel49cPhINkQJB/RYDPEN8+H/iihzi1tok5yGSLhs=;
	b=naa3BI7dtJo0B7jQz7xVl7Ejde57sl/tfm2FrTKflAs9kmnHkxT3gTBmY39rZsBb4FiL4g
	ftTHTFWLX4at3PyyZsKgqizfgMV9wDT/9NTotLHLs62ORv3nmGOlpSqWVyzu1px+EwQlLa
	Ww3dArUtDazTM+fbSl5pGbThZdxK518=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MPK6KMf3;
	spf=none (imf16.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771330168; a=rsa-sha256;
	cv=none;
	b=64waTfOrMDzTM5c4vJAe5ezlxCmdhKoad8uRUBOMOYKGxzkqEDoggg+i5tFRFcpc3/exfA
	SsZLq7YChVOP/EQO3yeIat2yuU0dVipSDfYHkEPGHjFL92XsPAY/6QqWzDbeUDiwB7F02n
	xIIAQz8HH7F38R7POv0OXR7Q56hzffQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jvEel49cPhINkQJB/RYDPEN8+H/iihzi1tok5yGSLhs=; b=MPK6KMf36rUidU04wIkIULJNkg
	wqfIh9NiF7oktdP1GXOI/kSLqJYeeTM8tAdPyi71S6scD5YbFxDGnqgRgsG8FCrKCC8poe38JdCv2
	wMGitaH2wkK4d27o7e6W1eQExGw86oRXWFavKBmnDwM95FGy/nHOw+C2hTJlmjSLUdammh7BoPVFm
	6PK87giPV/6yXnfLE9uLoKD8QLJCPy7wpHp0Ff8qpBG9I9/+5VQP3rnTD5a2+jKsqSTnXR4YWLONE
	tjLSEQ9xEohl721UoPz6qpFS5wh5lmnUr81+KfMv3thlMGdIloPTd3g6n/QyuDU0cbLA3aucMRTA7
	rLSvBBSw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsJtJ-00000004OTv-2d0U;
	Tue, 17 Feb 2026 12:09:21 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 77B5A300CDE; Tue, 17 Feb 2026 13:09:20 +0100 (CET)
Date: Tue, 17 Feb 2026 13:09:20 +0100
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
Message-ID: <20260217120920.GZ1395266@noisy.programming.kicks-ass.net>
References: <2026021326-stark-coastline-c5bc@gregkh>
 <aY9PBfx3RRV7rXZ5@tardis.local>
 <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com>
 <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com>
 <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com>
 <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <aZRWOIPThLfIZ1Ph@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZRWOIPThLfIZ1Ph@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A8D68180004
X-Stat-Signature: 5ngpt4rhpsojmapme897z9nrfuu46bsq
X-HE-Tag: 1771330167-236327
X-HE-Meta: U2FsdGVkX19iPzVt+VAL9h3GpDmb5fwthgZRvsR9rAxS53zDmoUd0XYVB8zxJlDT7nKtHuzkvKQGSb3kCncLMayBjtXpVw5jWzrLa58T3bCYihFYslp7a7hohnG/ZocWLctLRIwuDLt+KpFnE9JJd9ihHUlUplqGkkoHqGbSkq1iYhE/I3ViQKM83CHWpFqiLMAAoCn4d0vBBINwWU7VZZ/FWTmZMDVZNyiJUAcdxxz7UtuYpt/08/4QBDTy/8Er1XvDXmXLErj0jQVRlaYJAVZU4JABP6l4Y7KkAj+j2FditasFEUkDbymleZoIJn4ye9BNRQ7M6tFvsfcvjmxu0TSY7yIl68lbjeoFDAwAa2uw29FrW79X39cbqJP5MA5UROhY4VPd8Geox2nXeUT/TGTe9TyibDRRdeAImysLwHfBv6UlQt9YSsGpKJdnOqodOZck5U9lmbBbke9ERO6lq9Kwl07HjfkXZk/ew8PfJMNY+dYkZhGeZRkPehKZvrin9hCZd9//8A59DbI8snKdHCKR995yj57QqtqVTQI6bHPdGI2S4RuHDC0oWszol/KUNWmAiN+yxJedAERz1Mkp3ZEWDputV55Br9iTjEoVfACyxPL1tPDH0f1tPqKm8mlz5mcLjoIHbPjQMAuzrEW/1YSrLqrgukxA0+7M/mYDm+4gmN7zqU+yrHfRrGJKM13RgwZgCSjd2UE2IB25OmRIzNLsorOOtgdV3ZDAUG9rqhW8gKv0mIOL+7vNttXiYA+SbKrAM6NT46LRgly4oycw9LaFHvPY0Uvj77F6jD8TG5CXyEsCNVOP+RjhYmfsIvYUY6/sHrntuxCNj8Y0mPfMjhY76C92fh3Qt6l3aJ7j05qdDLPPI696MdcDWxwtOjFOfDhSH4E1wkKRs+dsFc1n7i7hSr9HPxwLcfid1a31lXJfuDjUdHmFPfdAB1vC05Po+G6wuKau4hypMIzw1ek
 ByKd1Nos
 y6aIENDpgjHq0BCx6o7lIKJ52/vc9KZ/1wFDF7TR1C1jY1UjAwh1WuK9D8NtDxyWkE4v/GVARrwUYJXpJHAsarPFIVWik7Z+gEe9EY2eOcnwzoOf905IwrxqPyuMQJBMGK8LzTBUVswRgP6McgcbGu2xolrxZeywNwyz/S01WKHVn0u216NDkx+VRTAdcrkqeRTmru6GlYGW1ManYPm0jfYc5ZJllkYcBZmmWU8VCaL34EAHxC7yXsuv92u0xQSlIE/E2hydX38KcNM5n1+ML/GzK1tDQWj036OPf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 11:51:20AM +0000, Alice Ryhl wrote:

> In my experience with dealing with `struct page` that is mapped into a
> vma, you need memcpy because the struct might be split across two
> different pages in the vma. The pages are adjacent in userspace's
> address space, but not necessarily adjacent from the kernel's POV.
> 
> So you might end up with something that looks like this:
> 
> struct foo val;
> void *ptr1 = kmap_local_page(p1);
> void *ptr2 = kmap_local_page(p2);
> memcpy(ptr1 + offset, val, PAGE_SIZE - offset);
> memcpy(ptr2, val + offset, sizeof(struct foo) - (PAGE_SIZE - offset));
> kunmap_local(ptr2);
> kunmap_local(ptr1);

  barrier();

> if (is_valid(&val)) {
>     // use val
> }
> 
> This exact thing happens in Binder. It has to be a memcpy.

Sure, but then stick that one barrier() in and you're good.


> I don't know how Andreas is using this, but the usage pattern I'm
> familiar with for `struct page` from my work on Binder is this one:
> 
> 1. memcpy into the page
> 2. return from ioctl
> 3. userspace reads from vma
> 
> or
> 
> 1. userspace writes to vma
> 2. call ioctl
> 3. kernel reads from page
> 
> which needs no barriers whatsoever. There is nothing to prevent this
> kind of optimization in this kind of code, so an evil userspace could
> trigger TOCTOU bugs in the kernel that are not present in the source
> code if the code was optimized like I described.

Then stick in barrier().


