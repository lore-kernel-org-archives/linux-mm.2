Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F86410BA435
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023206B0095; Fri, 27 Mar 2026 04:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F160B6B009F; Fri, 27 Mar 2026 04:14:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04DE6B00A3; Fri, 27 Mar 2026 04:14:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C96CE6B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:14:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E78228D15A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:14:58 +0000 (UTC)
X-FDA: 84591132276.30.36065A4
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0F6CC4000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:14:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qUqcA5RC;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qUqcA5RC;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774599297; a=rsa-sha256;
	cv=none;
	b=XrSW9ud8CugWNm/v2AsyO3Cc68Td1hNXhVC+khVC70v/8kVLyutAEVL8VzIgRkF/FQwSW3
	BchT8H4EH4d1EpSNqOGa3PadN9NAtSWLU8z8MRqfpaWTO28wR5lVstFomewwZ++s0fUK9l
	SsFiVdvNn2lIr2Bx66KRAJuC8A4X6PA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774599297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdX9mVgGs0Nkzsg6oIXtp9RiOtkTaiCl0p3MKd6jISU=;
	b=594/YXVxxtXR5IK+CXu55fxTV+kY0YLo+aT0IcGr8nZnHjsSnwhpqf63+Q4VOmtWkLC44q
	A3kAUBGK1Bv/rummr5pDsg0eDl3UqXnkxhkNJZi1SsHu4PNdMw8ApQszt+K4K4Ghipm/Ij
	zklC8J91kcaDLY8f/djpceq4+09YYE8=
Message-ID: <772e1ce6-6dda-4b73-9c9d-ff04a383f07e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774599295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kdX9mVgGs0Nkzsg6oIXtp9RiOtkTaiCl0p3MKd6jISU=;
	b=qUqcA5RCMiYHU72GZ7xO63U6oCVbMuxwt8m+xIoh4kjnZ5JcgTPax8dNmzJv5GtweiTbMy
	jSKdRWs4kqQyitlPr+sUELIrCo69EwJfUNo1ZDgs8E6eq05cFpKX2Edfz26sI89h1yIn32
	UlGCRR0e3Apzw5oEaMf594g8EygTscU=
Date: Fri, 27 Mar 2026 16:14:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260326140554.191996-1-hao.ge@linux.dev>
 <20260326181145.35b559956a45b0efdc9c0450@linux-foundation.org>
 <CAJuCfpHddCffwF6uid_nW8sMAMpJcOiB62BCeGEtoiDYY6rP4g@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpHddCffwF6uid_nW8sMAMpJcOiB62BCeGEtoiDYY6rP4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0F6CC4000B
X-Stat-Signature: oygcud44df3uzu1pxnedebjnoaafjjx9
X-Rspam-User: 
X-HE-Tag: 1774599296-463011
X-HE-Meta: U2FsdGVkX1+Mx/O/rPC9btOgOsEY9Nn0Pr+aCBuLuTmmTURP1YNCuDFkLmpS1pwP4KjPjGT5YzCNNqBG22/E9hiXJ6SBcXrhNC5RESjHhwUSh5jd0mFAUp+mBoa2Mc5l1LxE9+fJ7/suD3n2zsOCA3gu0hfCHdYmqapi4wp4DYAkp6RdxlG+7lZPlWXPBMgD6ksa54mSyJ5mCGmKhOCnWnloPRHDFdXSdcQxQ2S0hWCyHNViSlAiFJRp9REo6Kb5V4Pz1UKmLdHESD7BicBIH0ovbZAAd11Q6Qpkez3mQQRyI+xtnszdR3MWfN1la/UZU7i1B5o+SU59y3OhKYOgAzUDXQXmOVdyjB0BNaZIgXqAbCn9qF/kuHPM95U3jU+e9gnKV3QLPo/R6KMqZJzvhryWUy9R65Ob/X5AP+BDHMyEIpzq3P89IIPKteWik9iidlz8bDBwbmeJdzconh2OpchVvmoJEbXOo+i4/k/IoKXROdOvzMbGpc7dWdATSvkEjC89nqYe7wH8D2f9Ktq6vMzqFgPlIFOsy5ZU9iGZnWhdzwYZJvRKNE7rp7hj88CM/lmJk+j0QMGPAa8MbH3cA9VZXnj2fa+MnDEJWLnpqPSCAA1xw+P9MUVtbXrlasRTJTK3nU5Nu8IhpzSKXDEqF3IS5LsTPdBt+CQ50tKSMpzvW5TSLwXbz7v2i0tAQVRiq8mzt58X8pcS3+0PhKtguOBiOHL23dWvMQQ8K7JRJKw6mADh+dFgxHnpoQ2PwPigxb3QVHN9OyRDq1DPBikgi6UudfIufkSbQOWTSimAogfv8X2+q4h3dYQef5Uc5ujT0CEqkOkSElyXdMxKAbIsMO6vA6ZFtRBNIbl0KS2Hf1BUS3gEIt9Jxib+f/Zk9WmAvaQKbiDmVef4jjpwv78KxOwHKBzKZrfYWdNxNP7hYG7bI77XXHjuEWaU0E7hOYj0fVZ2b2UkVBr1ckljfY1
 QjecE9UU
 zb34uhIyg0VxNJ4rTGvsQjm/8yXfTCJGAUfzmVX7etmg60yE0Ny58fqlLYlWPvgPAEOoyB/0/3dPwRkk2c+s+mY02QteqXXYzeH4CwsvH/KN4rqjCIt8jIbjYAZT9WmpJ2216hESQm28lQoGoap8C4tdEJyW4NDpgw+tMF0IijMKjz16wEnM02X3kSKM2WpeTCVwWWD1lKvmDwJYMyFT1yA1OPNUq38lejus8JfVXFCpru7A/ZyTnk0YTNqiJS4cH/82RlHsXUwipl880tqLOi7m5EWbV4nNRdeS86yU6nnI5wAAP4zDFBRPCdRbBAXGiLF7yxv1jlAJqmgo8tR9a0DenEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren


On 2026/3/27 09:19, Suren Baghdasaryan wrote:
> On Thu, Mar 26, 2026 at 6:11 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Thu, 26 Mar 2026 22:05:54 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>>
>>> Due to initialization ordering, page_ext is allocated and initialized
>>> relatively late during boot. Some pages have already been allocated
>>> and freed before page_ext becomes available, leaving their codetag
>>> uninitialized.
>>>
>>> A clear example is in init_section_page_ext(): alloc_page_ext() calls
>>> kmemleak_alloc(). If the slab cache has no free objects, it falls back
>>> to the buddy allocator to allocate memory. However, at this point page_ext
>>> is not yet fully initialized, so these newly allocated pages have no
>>> codetag set. These pages may later be reclaimed by KASAN, which causes
>>> the warning to trigger when they are freed because their codetag ref is
>>> still empty.
>>>
>>> Use a global array to track pages allocated before page_ext is fully
>>> initialized. The array size is fixed at 8192 entries, and will emit
>>> a warning if this limit is exceeded. When page_ext initialization
>>> completes, set their codetag to empty to avoid warnings when they
>>> are freed later.
>>>
>> Thanks.  I'll queue this for review and test.
>>
>> But where will I queue it?
> I don't think it's extra urgent. It is visible only when debugging
> with CONFIG_MEM_ALLOC_PROFILING_DEBUG.
>
>>> Fixes: 93d5440ece3c ("alloc_tag: uninline code gated by mem_alloc_profiling_key in page allocator")
> Hmm. I'm not sure that's the right patch. Technically the problem
> exists once we introduced CONFIG_MEM_ALLOC_PROFILING_DEBUG. I'll
> double-check.


I believe this should be Fixes: dcfe378c81f72 ("lib: introduce support 
for page allocation tagging").

Earlier I thought backporting this commit here would be quite involved,

but after further consideration, this is indeed the commit being fixed.


>> A year ago, so a cc:stable might be needed.
>>
>>> +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
>> otoh, it appears that the bug only hits with
>> CONFIG_MEM_ALLOC_PROFILING_DEBUG=y?  If so, I'll add that (important)
>> info to the changelog.
> Correct, it affects only CONFIG_MEM_ALLOC_PROFILING_DEBUG=y and only
> if !mem_profiling_compressed.
>
>> Do people use CONFIG_MEM_ALLOC_PROFILING_DEBUG much?  Is a backport
>> really needed?
> IMO backport would be good.
>
>> Either way, it seems that this isn't a very urgent issue so I'm
>> inclined to add it to the 7.1-rc1 pile, perhaps with a cc:stable.
>>
>> Please all share your thoughts with me, thanks.
> I'm reviewing and testing the patch and there is a race and a couple
> of smaller issues. I'll post a reply later today.

Thank you so much for your kind help! I really appreciate it.

Thanks

Hao


