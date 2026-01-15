Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73170D4661F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB446B00F3; Thu, 15 Jan 2026 15:43:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB5B6B00F9; Thu, 15 Jan 2026 15:43:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB74F6B00FB; Thu, 15 Jan 2026 15:43:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC606B00F3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:43:04 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C3AB1AE393
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:43:04 +0000 (UTC)
X-FDA: 84335372688.30.0E5E1C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4CBD92000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:43:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s0wkhBtk;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768509782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGnp4bLOtbNq2W1vMSHnZZVS+E2zIQ0dQXqRvBiSkAg=;
	b=6IuublmihNj1rb7aX7qihT5nxasYIQpEqQK+0KKGLhMy3KF91+xB6ts27v+5GLZzevbqz/
	NflnCG0oyxkF+YoCqg55X8YNjDKe3a9Wy7G49bmBJwfbahXtDiFL36xyYCZnklgYIufj4S
	fEg9ocJ3095N9HnT1WuG7ZV8tYs1pqo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s0wkhBtk;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768509782; a=rsa-sha256;
	cv=none;
	b=GrIwuILfwSu3OUfMif8PNLVlG6rrm4Ctuwkq/x+JLB6OxlJHcndutefJlrO6uaFhp5724F
	LIR7je0xR1YSsk0d33PkWgrBB+R+SdPBrXWvp0VJdIQPx6JO4OO66srQz1atkAUQF7sU3R
	Mm0YS1C5c0awiqcS5jNpBZK3hPeiyAM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3144F40C2C;
	Thu, 15 Jan 2026 20:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC162C116D0;
	Thu, 15 Jan 2026 20:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768509781;
	bh=rkmrkZwHKI0uV2MWHOCpMDsFAeLDcI5WrDtYy1nryic=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s0wkhBtk4VGsRPniO41iS5y+tOHZKaU/pyhnV9vlCXwkyybOGkxEE9xhXTjeMLRfq
	 CzuO+72zB6AexagGD/kmCTK41V/uh68LOwXzMjvs1iIMq3SWonYYkAOeLnZ8xBCHeB
	 neZ4aK1kjg62sTc/j/1+ZC09vOTyG3dXDpjNbGUqSH5S8chtlP2q+rVRPdvoj3JWfk
	 d4mjj9G0lRtcrq5wmBSDmngeO0JfZwhmyc14JtG/kgL6/QAv8gMyu7dXV834sdjm9M
	 APQDeFmx/SWdZXay0FH4yOj80IwBNSIm2fCvmv76OtosdeLpmwsgrLSnQqH8u227dw
	 Z5jgbrN7Oxxig==
Message-ID: <671528cf-6fe8-464d-8028-ecd5822f9053@kernel.org>
Date: Thu, 15 Jan 2026 21:42:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: Jiaqi Yan <jiaqiyan@google.com>, jackmanb@google.com, hannes@cmpxchg.org,
 linmiaohe@huawei.com, ziy@nvidia.com, harry.yoo@oracle.com,
 willy@infradead.org
Cc: nao.horiguchi@gmail.com, lorenzo.stoakes@oracle.com,
 william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de,
 muchun.song@linux.dev, rientjes@google.com, duenwen@google.com,
 jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com
References: <20260112004923.888429-1-jiaqiyan@google.com>
 <20260112004923.888429-3-jiaqiyan@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260112004923.888429-3-jiaqiyan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 4nud8uk41mi19u4aui9t41jgmbsy4foh
X-Rspamd-Queue-Id: 4CBD92000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768509782-362566
X-HE-Meta: U2FsdGVkX19yPA3pJ+2HlbjXJf3AbDAPXrrO1iCA1ZzgNisoHt+zLhtFeM9NAX9rWHT+t/FYqwj80wou7zImfUUcmMIIKmWTsstgmX/cLP6mNmpaunZZQYYbmbX5SPJiMZu/nIOaql9ELnqZHasGGl8v4gAga+f76i2pWky9Xq/QVo5EXCxJthHDOF6JOWLx8Gaqkt4fpmai+BVFCETaNojpTyiInFVBXvxs1P4YTFXO5/yNcIMGix60elNMrc7pF99ye0F/JykV7JVj6o9VzQ5L5FXa/JdOiNUL6qPMFXRLRm+TobHrPrdb5W4Oor3/ou06oH9Bcj+zYWkN0px0xOnVvv6gks9pGrT16OsjNjF0dp79P1a45Hu4ayStNcrrCLzkCNlMMmvABptQ0HIo69amruiO843/9RKXrFeu5mqYrG2QjzEo6JyzqtcGXw5l8GFfwgAd3QjgH4NocmL6rVcsVLmNEDvKNg0xEDG1dUPJV2/CuN7owwMvZC11cn1nObrrjJZgLjPj5pXmBI8mRhRoWr6YYuYu2W0v4pm5UOFjlw4m/Kk6NsWllFEKsi4FN/jORGy3owOuvb3R6EXsCAXeKpj2Hl4mJUtECvDKTlvRZTlopyV4CIzMere4bPJ2F7k9vZXxrZe+hr63f1VU32YURRFX2L1WfKJPF0ZNMXRlVRAzD1FWbkcByKXoA0p0Yjaabj30unImNoEfcsUTYlpwd0yyXVrx34FXs+OfC4YiOD7PolUV3UvDHXHnttBXukdwxOLLdrS8NwzSUKHQWaccpbufORmyFNIEB8ShJ5EH3WBoek075LBucf8RS+B56+C0CtmHYRnc/NxLqrDJo6cS2wvXEVewPNLjSz8fI7/h9m4j+Tbd7bDctL966awVZpMIJTAkxhav0dCv9VOup8rO7skc6bciMDGCGJ8N6nkxV/ktmB4tuXFJRuKF1LeXUjJ0e964275BBWaBfsN
 4r9hIrXI
 ztYnKvyOPQ04aA6AN1V6OSYWx5Qi27Sp7BYtcGABvvPHtwdFMoayPmYuEHo205hgScMHOEi8HvBXaHEmkstZnK73CJLWszmHwXfnmRGXswhJ1BhGB5y/CnMXJT0+ICcjzVkAiwjcogFZFolzxpltZ1q0KfLfkUcHw6x0QN/XFsMuB/bpkNHCklbMdv46kmB/GsQEntxJe0JGhf/+NvzmHpWTDf9WQCc585Fioh6CVn5Dg/sxCRxnZN3kNGAYF2s11CGzFQpj2FalZOqNxFBxA+8VeuN8Hhvasln32AAGIz64Yc9YO4znQ3TAs975uzI1mf/TlSXmMWBfH9pj67HZ6WKwW3iFBGHqObtL7ESAvHnyQmcogvtYU4RycVlF+P3qvck3P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 01:49, Jiaqi Yan wrote:
> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
> becomes non-HugeTLB, and it is released to buddy allocator
> as a high-order folio, e.g. a folio that contains 262144 pages
> if the folio was a 1G HugeTLB hugepage.
> 
> This is problematic if the HugeTLB hugepage contained HWPoison
> subpages. In that case, since buddy allocator does not check
> HWPoison for non-zero-order folio, the raw HWPoison page can
> be given out with its buddy page and be re-used by either
> kernel or userspace.


Do we really have to have all that complexity in free_frozen_pages().

Can't we hook into __update_and_free_hugetlb_folio() and just free the 
chunks there?

> 
> Memory failure recovery (MFR) in kernel does attempt to take
> raw HWPoison page off buddy allocator after
> dissolve_free_hugetlb_folio(). However, there is always a time
> window between dissolve_free_hugetlb_folio() frees a HWPoison
> high-order folio to buddy allocator and MFR takes HWPoison
> raw page off buddy allocator.

I wonder whether marking the pageblock as isolated before freeing it 
could work?

In that case, nobody will be able to allocate the page before we 
un-isolate it.

Just a thought: but when you are dealing with a possible race, you can 
avoid that race by prohibiting the intermediate allocation from 
happening in the first place.


Also, this is a lot of complexity. Was this issue already hit in the 
past or is it purely theoretical?

-- 
Cheers

David

