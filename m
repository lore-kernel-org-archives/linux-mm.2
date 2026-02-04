Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDDABEA7944
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CA556B0005; Wed,  4 Feb 2026 16:37:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A7D6B0096; Wed,  4 Feb 2026 16:37:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180646B0098; Wed,  4 Feb 2026 16:37:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 068476B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:37:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4A8716034F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:37:44 +0000 (UTC)
X-FDA: 84408086448.01.6C6C0FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1A4BF40013
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:37:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YgMET0/C";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770241063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Q/c3GBlIXfULOsiQe/JOzlqxHlHPgw6dVhGEUCtCDI=;
	b=OMa6VDwuqEDNVYaq0eyXywaYKsqa6lm8ZWu5bTUYXNdJ1Z64eESzmo0J9J+gUKtD1lr3ra
	Ooe6m5uXY/j9OnVkvTiCDPJe5DmQS7M2/u2FPAv/I8LHcT/TsoTE7nqZmTaRkFM42St4KM
	HpTKdme3fvUGTCIMm0taG0nz6pMoHYg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YgMET0/C";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770241063; a=rsa-sha256;
	cv=none;
	b=KVGLm9TuQLe+lvNgmlHVodvVK3rcPRbwXH4EBn8Mo4kyJyWM/2iBKnM5MU/x2D2UY8xxmk
	b3Mnowpl1Yxp4bGt9SMCHeyKie0sHCDpFvbl/8RIa35v6z1bZEkNDXEpnsFaO0fzE8PhGw
	6fV5wo9pdves++dbC3ZbNtESfq1BZdE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C48A403C3;
	Wed,  4 Feb 2026 21:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF91C4CEF7;
	Wed,  4 Feb 2026 21:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770241061;
	bh=mgZ1A8T3ZA0g2gF5yLq+cN/Jw+cZKs+yhh7skTClPeI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YgMET0/CiuVpQ5LvghzJOXjXrETaUrYGVTwC9GGMh37vtMLn2kef49FDCa49/eviN
	 efQ7sYK0S4qNUa0yzsI31OyBp8IEb1r0T5VNrM+NNgeJ+KvIF43eGVSKdCpwOANNmV
	 XF2fvbGq4NxF8xadpA6y2n+DWBXMBOS6Soa5F8PzbDgttvqgALuKbxDtbvqweno5sA
	 cgtuL0hig5MrU2ffSLoteKB+YUl45SC5n/4Ty4YFjCOyLK6lxr7Z0E9c6bmJTyX29R
	 ZwzZcrd+OaIw16BDJ30NwNcPK6RvkzmEmu6FY3AMIskbEuuEds6jty/lwbXbldoI6X
	 R4hy0nNnMHnLA==
Message-ID: <1bfc9e64-2961-4d2c-a6c3-fb123f66e6cc@kernel.org>
Date: Wed, 4 Feb 2026 22:37:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
To: Zi Yan <ziy@nvidia.com>, =?UTF-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>
Cc: linux-mm@kvack.org, linmiaohe@huawei.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
 <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
 <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
 <61BBEF63-20D6-4671-B7F7-F015D49B2080@nvidia.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <61BBEF63-20D6-4671-B7F7-F015D49B2080@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: zcs35i79j3mim1x6praummfff9qmdkhw
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A4BF40013
X-HE-Tag: 1770241062-58588
X-HE-Meta: U2FsdGVkX1/AsshfZOVBxcvMyTQvhUHGuBFmHi0BZ6hZVRgCe8c0FcaRpGm5gvCpDLTp0XsIEqcsJ+D7ROAVNOELKVXOKp1sKmqNd1YaLNjz7GyWQi1pv9o1Zs8BGKStLohHjSkAEVFKmWyT27wabhG4aVEmp0myaHI8OAwUl/7PUcXwwiR0GqGOeITxxI04EtEo0E/R4+y3QssOlhM9gkOnd5UI2PoVXdqoGIombuFue5Zcg5VUhlE+vKiuvNHJBpzWqV6xBPFgLoOtbt3c/QY2Nwfr3kopDBdZxMlxko4Y9aXMqZ01i63Rfv8alJWiiM0R5FRieUaWhoVSUK5XADLnUXO5WxJe7OxgkM1B5D3BntOJ91q0dVE3KQsu7w9dJQbRmv7NTFP09u2t5yJ9tzoBkWUeggrB5/Pt79Hi1Cnc06XOswVRphmwGnS+5kLHafOk91afF4WShxuImgBujYQizaynuiqh82hwId2TW4nZe7CdPwJooCW9ufozvT6HSbEcsSIRazhFP4ZdnrUQVLPDfS2Chj6pUkhCvzRW/z+68qwirnqKAP8w0/dgTJz+uM9q7y+FEafEV7HWP5blhh5WPrNfkB0upsyH3q2Rlq7+3pjl8TlviJsCB1Vs2zn3Q6atmdcBq7iwX8rp9tXDCNSdnNItlU0PNDcOa3nh9OzCqW/gVavoTFoi3oe+nRerBRAHfBi1Zc4tRl6tH1m6g//I2i6HWnh002BpBhdO94H0j9AlS5rQROtQ6HHlmM2HBdrnf6fAKgFKzTZaMR1IAJPXrk4q3TuN6EkssZgOHSq+LO6IT83+0aOUWRkuymOm/aZaSwoTI95n4gqPCJi7szkzwCPPawEHFKFBXMQcZxZkzZ3h9EEeq1t9WT7hgCgt2+u0WPAGNluPb7FOX2UFAXL15UEz5W4q8VmguN96vRicipqmr7Qpmqdslm9gxHAx+jSvorpISpZIEXmm0l1
 PPnmgTzx
 iH7eJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 22:08, Zi Yan wrote:
> On 4 Feb 2026, at 14:18, David Hildenbrand (arm) wrote:
> 
>> On 2/4/26 18:41, Zi Yan wrote:
>>>
>>>
>>> More details:
>>> later at sg_vma_fault(), the driver just handles a page fault by supplying
>>> a subpage from a pre-allocated compound page[3]. We then get a large folio
>>> without !CONFIG_TRANSPARENT_HUGEPAGE.
>>
>> We can identify such non-folio (but compound) things by looking at PG_large_rmappable IIRC.
> 
> OK, back to the issue. The patch below should fix the issue?
> 
> Hi 是参差,
> 
> Can you test it?
> 
>  From fa4a900e027a0c7365a9f786840943990d5da971 Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Wed, 4 Feb 2026 16:04:19 -0500
> Subject: [PATCH] mm/memory_failure: reject unsupported non-folio compound page
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/memory-failure.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 825c706ac576..4ed903de9a0e 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2440,9 +2440,12 @@ int memory_failure(unsigned long pfn, int flags)
> 
>   	folio = page_folio(p);
> 
> -	/* filter pages that are protected from hwpoison test by users */
> +	/*
> +	 * filter pages that are protected from hwpoison test by users
> +	 * or unsupported non folio compound pages
> +	 */
>   	folio_lock(folio);
> -	if (hwpoison_filter(p)) {
> +	if (hwpoison_filter(p) || !folio_test_large_rmappable(folio)) {

I think you have to test for folio_test_large() before testing 
folio_test_large_rmappable().

-- 
Cheers,

David

