Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D8A1C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 11:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35116B009D; Fri, 10 Jul 2026 07:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4F36B009E; Fri, 10 Jul 2026 07:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6DA6B009F; Fri, 10 Jul 2026 07:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 644416B009D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:16:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F13BC1C8917
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:16:36 +0000 (UTC)
X-FDA: 84972613992.11.C248CB5
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	by imf05.hostedemail.com (Postfix) with ESMTP id CE7DB100004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:16:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="v 2a0onb";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Fd7fOGXI;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783682195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tb1TbPSaUoa6sJMUNmBbUyB1nWkk1Ze1A2pnXDJ9wE=;
	b=1iv3cX02ort1n2aiwMhLUGr9hOwuHlf1e6kbBD2caDGCC1LwmSzLQ9sKTsT1Ak62KPGSMl
	KfLGU+xrPdpf+62aIE61M2OvGz8FfmGGZS5FaHz7qGAlrIIEmUEEdXAuEkn8ZGKiEjvRDT
	TAbFLLNEplToikG02SDeO9BepfuBEGM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="v 2a0onb";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Fd7fOGXI;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783682195;
	b=CVUfEoSfonhXzQv4FnErJ1gT0RNTtqG3Peb8MgZ1a/YkrE6eJuQMXTLjwLRmzAm9jOI63O
	MRIUnLfYDR0PqOhQa0z0V9tgylyQ1b+CEugqXrAcjyGa+V9H69VpFiTCYJ503C+WU3ye9q
	JJ3FLpes85SEVq3LVZdUftbqr+wBh7k=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 23DFBEC0188;
	Fri, 10 Jul 2026 07:16:34 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 10 Jul 2026 07:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783682194; x=
	1783768594; bh=4tb1TbPSaUoa6sJMUNmBbUyB1nWkk1Ze1A2pnXDJ9wE=; b=v
	2a0onbczSxWXCdSNA9gDWK6mA6QLrB0u++a8sk2DAxNLuYcsCAIqdFcnvpCSBGwP
	rdSNsYnd+CVw1Ab/ICHBwLCL0mlUBH/evfD8LPtZUt9lc8MMMNz/4dcC+XwtQwON
	+W+lZXCEIu+76P0q5V2BHhq7wv4DSVNeFv/qv632XNOgnRJybA+uQV4KnqZ17jTM
	LtHkXrRfLZ2Q8EgkcmBjalrZggxwoyeyMnYaw5uuyxEbABah5ru3Q5wGtJUGmZ5L
	5PuZx2mp1PV5wGv+GfvdX4593CFA16111KHmbmQavoN1vYtBlA2tk5CguPMG9oDr
	u4ldValR+YPJDyTiV3x1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783682194; x=1783768594; bh=4tb1TbPSaUoa6sJMUNmBbUyB1nWkk1Ze1A2
	pnXDJ9wE=; b=Fd7fOGXIy3wsIZLrPehHfxyB04kU+OZHYzR6P+xDzQ0dS6j7bqC
	lbSUh5IVmF9jlGx+bnPWlX4VxiWgmE0sc5zMekEMQFuKDyLHSYET3lv75JDzCDm6
	flfQZb3li5Q+5t8B3+d16DQaH305o3bA4Ks6cmNCVcGRoawMX6h3apoY2yuvRNrh
	nHKSsGfnR63SqRx9l8YQyuEk1csG5i8JCfdcyAhNv27r25mIVgbUm8hiCHOPwYz5
	uJCBh6uty8F4J/QwE6lnmUjoX96uGgswfUi5CVyV4uFvx/l7Up82c2PKEYyr7JtE
	o6M7uaRPJCh2pMVw5X+ptFC2xnukNkZZyZA==
X-ME-Sender: <xms:kdRQakngPCrrdSo8WoYSmEXCzBkQdZmwLUKIBxBMjmwQeSdzehhp-w>
    <xme:kdRQakTLWtDb6VlIa454LKBJMW9PzxLnFVEiAayMmQV1W_3kEODPbd7iO0DWTjizy
    vJAIB1W_-WEAx2757U5S7lfpFBynq5Vo26tZQHXkEJ8M-YnM6Y76I8>
X-ME-Received: <xmr:kdRQajWg_mzCAtqsUcMHrtBnWjyg4gI8yubfhpFRI1W7sG6Zxc7ekw5D50MsCg>
X-ME-Proxy-Cause: dmFkZTF2MPfeCgygTMonQ8pNXszxYLscEiX/yYk9qDNEnAkEfaw/jWYIaZIjxTGhuWNQMu
    uQmKzr1L8gH5hZu/zzEMkRXJojpn1LIyiXBKb/aDLsQ/XQp9wXOg+HnlPGwwPgLVDdS5fE
    vjC72m2o57IYwvoGp9u2GdP8Tn6cz13rxMkdyQtTs94Kdakp4o28HlcC+Vnpfmhy/l9jUw
    OeNynW723YEGoKvA1NnXgZxUbjOvoyVbR+32EUZ/5cFLduShKRhxed7lOPw6ghzcxil4bS
    YuznSvFPs2Vx8JiGAPkE3B2aPgFbZWPaWmRPsYuao81R86UC74pn5ifxxDBWuSf0l1AGZw
    TIXUfUroOsF12fa6WVoqLBxoVTA95O/bNdyssyNVVfH0dpKHh80hYqXZ8u63RUJ79FYtEV
    pLMBApb78ssX6LtVgm+Z/HbC2/JJl3mC+LHP9IkfzVweBmxghJ2VI2BWjyuRVoZ9uJANni
    PKrHz2kSd1ejVkjAO4ANTqI2fHa+01dtbWi9CS/3alleeX3TFwsrBWfDbQcOQc2Xv4m9/R
    nowMhaRx3mBuG0S5I62yXSa7DDt8LxqM/eNXzELYnZzPSdDo4HZrAw0rqtTlkBQFGhltmu
    LY8HicYe/mDeFvQ8kPGsq8SKhjL/AjrGImqpFDRZbixT1y9aYjvc59jmq51A
X-ME-Proxy: <xmx:kdRQaoK7AUt5zIMHxeazcw0y2r2cF7-oT7Rfl6fajtw_sRgMisWEpA>
    <xmx:kdRQaj3bsYl94qwhaEXPJe5BNkVXOO6Wz7KrWgx7RuoThv1keqMRNQ>
    <xmx:kdRQalIoZJ7onmUorXejruMPGncK8pPD473iilMkJz_dgT4EeF4qFw>
    <xmx:kdRQauiulBD5tR4zDHfuk2KnxLiDuzlMIi3fszgmPy7E_kFBsqmXJQ>
    <xmx:ktRQaggtvmELJaiowKwD4JcbA2iN5tS4uHcDXGHSmzCFdq4i8o0rNP_4>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Jul 2026 07:16:33 -0400 (EDT)
Date: Fri, 10 Jul 2026 12:16:32 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Hao Zhang <hao_zhang_kdev@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: thp: unlock i_mmap before releasing split folios
Message-ID: <alDSekC_5t-29vJS@thinkstation>
References: <20260710071344.GA106129@zh-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710071344.GA106129@zh-pc>
X-Stat-Signature: y7oi8u6paa8tckrm75hfhyumcitm1b6y
X-Rspamd-Queue-Id: CE7DB100004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783682194-821732
X-HE-Meta: U2FsdGVkX1+xjyckDmEHU+x9TEdUkc8FrUYa7Q5PWLknRO54FepC92O+dUVgqzJZL1C9har+VhU804evtebLHV5ZxXgYFQJlQhbPfgp3qIhquXYJz6/66Oif/dHdTKsFyQSwuCafwwrfHbhmSvWoDdkYy73qnoCuYFMbsK0+F7Y+LlbqXYLESiyd1gtHwrQACuO0VIP98GjlARUnZoB0AVqwNvD8ZdulzssjEwydvm8UVa1AyxZhmu0PLGaa6obFCaUYSe51Y42KUZ9vGw4MqHo+17k1uluNL7NuPAAnZmLaO2uBixE9NLMx5A4AqA/Wp1pl082J1Py2qXuKdwOAs1ldvRaOs7mMcPNmQuhnrLeLKnDYK9JuDC/9deQqmTIvvcREQBmFEqIn5Dcq0P3xkhstw9ZZqyw2bcheocwSFDBPZQrs1DdysctXzMSR3rMsTWX25mU0h7WATmzKAMwMLg0wWdKoRDW4Hm/n3kKWBOkd2lCmf8MKBjKTTWQcl/YgXbA6H4ZZd+YZgHrhNWR9mY9n/i4yTIMmyEoudsHOSQFYiVMJEC6h5GOstSV/kDZoLYJfkYlOPh4pUjc3mx2uJZFEOPiaL8mAKj3MiIAJarX0fJOkVCMgWxUhRPIpTR5pqOvKz/vIN0cENp0UerzQ+L6PnYDw0PvV1FZD0H8aHlL4SUBAEgBJ0jwRVQnLWpIvSGOkEsYEu3ztP3iuX+SdmuueqV2KkjPKUxjNLIo1prIKyYR70zhcAYM/LGe1YeAsLge5Rim/p3TQweL42rYI4CIFrpnuryPXBv70P8WgwZ34moz/Sk+XDev2hlJRdIEDCZ5gQoGSKwXSRY2GTt7Xump0FwFfBwlSbpnc3EyqeNY05JiSoO5mwv9b6j1PMZ72DbULtlz4TzdNub/PVF0+38ah94A1LjKAUCQ2qp86SN7L+uB5WFgEzljzzCZoDwtebU9CNrBAeCT2J7+MbvC
 mWtazXVS
 mEppGo/U+gazd/lnxogci7YOgA8kJPrB/yUeyrbKwteCIhBNWDBLcToy1mVBOIzpSYVe0iBG4JsPVcvaAkG9jLXiwswFcEroNUdLEhoD8AAHhneqDCZ7r1wYrk7qhG95GgSxY637PzBfCtp4GubDRDPPwpFUf68j8CGkfgOOn03hANotf1z+6jYyoKivijIJ7in7at3aeVq2fu86Orl54xPSErX5q2MSVJt4v/OoiyhZTA4XWz/nKSYLGitDrOHeahevyBxUUHhi3hueYC9zgVvOwY9GBx8muzzg6wAdPewGspDhJ1lRwoGNb8CYb6tXNXdRivP7jelzDzbyNn4ElP5IQsVTPnoJa/fYCIZEM/JVPaUu73VhY1fvJCFVVdwH7pH9N5QP8Zsu6d5UQIMIEG914sDcqgbr7xWVaihnm/XXNz/sMkkDPwJO1pXp45uJaRYwyiA7dkQhSysiPJ128a8PArnMrKlfv0tNGm3OncRk5E6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:13:44PM +0800, Hao Zhang wrote:
> From: Hao Zhang <zhanghao1@kylinos.cn>
> Date: Thu, 9 Jul 2026 16:30:00 +0800
> 
> __folio_split() takes mapping->i_mmap_rwsem while unmapping and
> splitting a file-backed large folio. The lock is currently released
> only after the split folios that are not returned locked to the caller
> have been unlocked and put.
> 
> That leaves a lifetime hole. Once the split folios are unlocked and
> their references are dropped, inode eviction can make progress through
> the final page-cache truncation path. After the folios are removed from
> the page cache and the last inode reference is dropped, the inode that
> embeds the address_space can be freed after an RCU grace period. A later
> i_mmap_unlock_read(mapping) then dereferences mapping->i_mmap_rwsem
> from freed memory.
> 
> A possible race is:
> 
>   CPU0                                    CPU1
>   __folio_split()
>     i_mmap_lock_read(mapping)
>     ...
>     remap_page()
>     folio_unlock(new_folio)
>     free_folio_and_swap_cache(new_folio)
>                                           evict inode
>                                           truncate_inode_pages_final()
>                                           destroy_inode()
>                                           call_rcu()
>                                           RCU callback frees inode
>     i_mmap_unlock_read(mapping)
> 
> Release mapping->i_mmap_rwsem after the page-cache and reverse-mapping
> work has completed, but before unlocking and putting any of the split
> folios. Clear the local mapping pointer after the early unlock so the
> common exit path does not unlock it a second time.

I don't buy this analysis. We still have the lock_at page which is locked
and still in the page cache. Inode eviction cannot complete past
truncate_inode_pages_final() until it is unlocked, which only happens
after __folio_split() has released i_mmap_rwsem.

One possible path how this can be hit is if lock_at ends up in an
after-split folio beyond EOF and __folio_freeze_and_split_unmapped()
removes it from the page cache. Note the drop loop starts at
folio_next(folio), so this requires splitting at a tail page (e.g.
memory-failure) racing with truncate.

But that's not what your analysis claims. Please share the actual crash
reports. Let's get to the bottom of the situation before changing the
code.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

