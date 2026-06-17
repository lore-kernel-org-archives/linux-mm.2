Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC26ECD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 04:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D0F6B0088; Wed, 17 Jun 2026 00:38:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A339F6B008A; Wed, 17 Jun 2026 00:38:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971A06B008C; Wed, 17 Jun 2026 00:38:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C77B6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 00:38:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ECF261C1A3D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:38:16 +0000 (UTC)
X-FDA: 84888147792.29.E110B4F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 059E480003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:38:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jSX+kpzd;
	spf=pass (imf30.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781671095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZk7D+ivMxt9ZF3nKyDzrGddw1Qvn0Tco2RSdjIvfNY=;
	b=5F+su5hKVOsEjA82+dFRlx7d2isGOdAmAVI4NcOaALGuIRNb9gg+jHgJHMqWSw28f10O57
	X+2HODYWA4P75l6nUuFd/TBMQwgOG5HsTGVyDODHVIap0fzjoewur6ZNiz4aPXLB/uzBWv
	3UrNKwO2Mmj0B1onjBeqTwXzpr9Lf3o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jSX+kpzd;
	spf=pass (imf30.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781671095;
	b=2ueJGtLSeA+2fSNR9uINC711lToKnRen3Jm2uf5V7BOADsdFB9mf++rZu9sk5NOcNfp+Ws
	XOfSKJEEiY2LGB6C+UFFqp64jPqGkJ4h0VggmeoLYLwrxPoqoJPFu0EHhUUBb2E29OCStL
	FBU/HVxa8fyMvMWEgtgCM3EzsVsaRwo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=wZk7D+ivMxt9ZF3nKyDzrGddw1Qvn0Tco2RSdjIvfNY=; b=jSX+kpzdrZtnNDIskjSTsizwTZ
	Cj6hwX6PJcXqKeNMpOTd67r9mv5UQdqNjn32xGHBaGgcj3CEUe7kcmYretduKkNmxX3tyXezHvlsF
	yvbPyPBGQ9TGo+efO3ax70Kibg2nQyy+wZoC8COw968zlSx5OAB2/5uLKBRTVSEf0XSAjnMvL7+Jh
	c8av7dNx9rAwsXeHGzpiGqWgB5qY48c/vPjR42BOzbRv/Pfa0lTa4aujxn1/UsxnwbHBElM3tzlhD
	Syvbr2p7ko1BvzF6oqNM6bkn6IxSxZU+ZWvxn/Q1n8Im3ZnFaytqL31U1QM0pF+1y3GSt5E0DkqBB
	w39hQvag==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZi2W-0000000Gc3w-1uAw;
	Wed, 17 Jun 2026 04:38:12 +0000
Message-ID: <79c90e12-c157-4d91-a7a4-54225d876d56@infradead.org>
Date: Tue, 16 Jun 2026 21:38:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: recognize @GFP parameter as optional in kernel-doc
To: Harry Yoo <harry@kernel.org>, linux-kernel@vger.kernel.org
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 stable@vger.kernel.org, "kees@kernel.org" <kees@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>
References: <20260616193929.2394119-1-rdunlap@infradead.org>
 <48840fb6-8c33-4e4a-9951-aa603576357e@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <48840fb6-8c33-4e4a-9951-aa603576357e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 059E480003
X-Stat-Signature: ergwanobfzq7ahwwamhjpfwe9we1me4s
X-Rspam-User: 
X-HE-Tag: 1781671093-927879
X-HE-Meta: U2FsdGVkX18xtNzw1VdLMKQa5/Iwbvn12y+GeHova/I2qxo6z7fucRlmN1d15LqLokx5mphSiAAHp1sL8S7sUG2E6KuVRQJkNulexW3ULxMLvYqkD3bP3OKKHItXFwUpSN5wbCnlZrYRg+h64lx0R+qjaHQZeSUq2iqWp3PKpVfW0nCSUmYjqh3J6jSyrsWtDcKYwE332W201ONAstfXUhpyrXPz4uu8jEJsCQpqLpaK+vGw89Ey3jeKGjbYlHFoGWzvKUQHV3DW8/2EJtRjkessUo+xrGZImf04OPXKNvxVvZK8NhzKDaOZp/sh87Fpx31JAKTxe3Pfg7Hposr6ZePpOPr+aX0YAAlJ6Vz9oBH6NLAT49jqGue5/9aA2g7tp6Ofgc4Cprrn53tJgX/9QJCOAo5jNStzIbKC/ucP/wmvAYCMZWq4b1F99jdpOec1UsaNT2IiToMO5WLAlb5D/ic8ZtSWmkduF1Hv/Pf3uiqtMr0YMr8YJaP4vqfEYQURxmOh26+uea+UnQZn2cY9UdZsK39/97gxDrccvGuEDo4aTovtoxXfeGuBcZLAgA6uDRDrgisHbP+PXpPFgMrlb9IzFAFpNzwpHlp24Vspub6V7z/4JR7SGdiRi4oZOV79Rou7sabGE5brfPIO1U08RIGYS4xlK/8gz3vzID5pDAQTbSyjq0RTI+777EwFJNSavvCTjp92ImkQqCP306e1kouOKIxzjUmaPPeeP0Jk97EqJKzbg+EHZe7jOUxcJ0Dw4v5LpkKR7rNOuvX5180jSjbBST7/vKKOs1ic/J+NpVjg7VQ91n9QfjF3C9lGgmA1LMHAdo0qkkezezb9vJO+yP/z1skHRl36xvKOWBJMSHxSSg8PnGHBVc48nU6TdZKHaM4mHzRiL+8vH0k4xhI6SpEFMSocBOGq62rkYVxCS/Qf4WP01umIF1DXYLALZGGNvwJhmvS+/Sa6JKGjVbK
 1WVHy8VA
 MV9dqduEHKJmeiya8aY5oXl584Hes/E0TWfWKyEPtGNurUadHO+WBpQzKKko2PHLhVbDzuv2s0SJVInFcOZaZ9BXlCmarcwP/EgWrdtTQlvJGqiS5gSu/b0NV0y4gmE1fvLnTbXPA1CXRHDEBYJRpDcBHHwtB+JJsy0o0pgwq4468sOOw92ZseIiE2grd9EO78OhJ6dVVeYIonHTnfi7ShzguDIsyq3B/46g0hKJihs1ZQNZYB4jj3DyvRU+oNCh6lJJmlNz+41eY0z0yuaDdtaAWoQKfj4cI7Vuz1POV9rNdtbcTQQWzvhpMDFzGJD6EO4bLJ4Wlpsdz2fZkpusqeVk6QSC+i9HHVzPe/cZ0LMtFQV5XRgficA8RWgglOVHlNmSNRr5fG3mgkjtFTjlEwPuNziGFrnLa0q/p+jrLsQJ/XD34p7ceaToPwL5gYb36paK9ejkLvb2JVxpsK/60Gcl1aiqzQpLzvhTLO9bIRpJQeMEGKc0eYTNfU1ghahyN8XIlpyvWSKAwgzoHGqAorEhjYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/16/26 8:25 PM, Harry Yoo wrote:
> [+Cc Kees and Jonathan]
> 
> On 6/17/26 4:39 AM, Randy Dunlap wrote:
>> Since the @GFP parameter in kmalloc_obj() etc. is now optional, change
>> the kernel-doc to indicate that it is optional. This avoids kernel-doc
>> warnings:
>>
>> WARNING: include/linux/slab.h:1101 Excess function parameter 'GFP' description in 'kmalloc_obj'
>> WARNING: include/linux/slab.h:1113 Excess function parameter 'GFP' description in 'kmalloc_objs'
>> WARNING: include/linux/slab.h:1128 Excess function parameter 'GFP' description in 'kmalloc_flex'
>>
>> Fixes: e19e1b480ac7 ("add default_gfp() helper macro and use it in the new *alloc_obj() helpers")
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> ---
> 
> I think there is no better way to specify an optional parameter, so:
> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> By the way, the doc should probably say that it is GFP_KERNEL when it is
> not specified?

How about (in general):

 * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified)

?
>> Cc: Vlastimil Babka <vbabka@kernel.org>
>> Cc: Harry Yoo <harry@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-mm@kvack.org
>> Cc: stable@vger.kernel.org
>>
>>  include/linux/slab.h |    6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> --- linux-next-20260615.orig/include/linux/slab.h
>> +++ linux-next-20260615/include/linux/slab.h
>> @@ -1094,7 +1094,7 @@ void *kmalloc_nolock(size_t size, gfp_t
>>  /**
>>   * kmalloc_obj - Allocate a single instance of the given type
>>   * @VAR_OR_TYPE: Variable or type to allocate.
>> - * @GFP: GFP flags for the allocation.
>> + * @...: GFP flags for the allocation.
>>   *
>>   * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or NULL
>>   * on failure.
>> @@ -1106,7 +1106,7 @@ void *kmalloc_nolock(size_t size, gfp_t
>>   * kmalloc_objs - Allocate an array of the given type
>>   * @VAR_OR_TYPE: Variable or type to allocate an array of.
>>   * @COUNT: How many elements in the array.
>> - * @GFP: GFP flags for the allocation.
>> + * @...: GFP flags for the allocation.
>>   *
>>   * Returns: newly allocated pointer to array of @VAR_OR_TYPE on success,
>>   * or NULL on failure.
>> @@ -1119,7 +1119,7 @@ void *kmalloc_nolock(size_t size, gfp_t
>>   * @VAR_OR_TYPE: Variable or type to allocate (with its flex array).
>>   * @FAM: The name of the flexible array member of the structure.
>>   * @COUNT: How many flexible array member elements are desired.
>> - * @GFP: GFP flags for the allocation.
>> + * @...: GFP flags for the allocation.
>>   *
>>   * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL on
>>   * failure. If @FAM has been annotated with __counted_by(), the allocation
> 

-- 
~Randy


