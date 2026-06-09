Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F36CD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD986B0093; Tue,  9 Jun 2026 09:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4F66B0095; Tue,  9 Jun 2026 09:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EACD6B0096; Tue,  9 Jun 2026 09:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E8306B0093
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:19:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8178164AD8
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:19:11 +0000 (UTC)
X-FDA: 84860430102.08.2757DEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DD76BA0016
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:19:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CUcPk5Rw;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781011150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NnZ0duiGqqSU2Bwh0xKBDnW2FZFfJqlmJyAUHz28ADk=;
	b=2MQAvSG3/NwCpqr2KFlmq+lmd3iG1J027cVNOkEBRsARFJ3tRFhG7qAhWyqngBmNzYX978
	ZiZ6mY+yZHsHzCc+0wi3Q2exoQ/FRc59eCzV9wyOs2BktPRBG4kdBS12b/zZbUA0r7Yl6C
	zolUiXsZ9jy8L/s6RAIJV4tINkNRfco=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781011150;
	b=ljTJ/Rk6QHUmahwS3PtlwVUqVC/NdhP5d3s1dMToOkBlWHPe4cuOcX/cAe4ua9JZ9X3LQN
	ddxoUvJ9mDO7R3N4ytrKItMXSHGUhHUDSAm+Y9udDCHI+ZFkTbmUecgM9SjzTM5kH9GWwM
	4BEtMUH2EquZU0RRuWpGFFcQ5s3Etn0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CUcPk5Rw;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 246B7417DC;
	Tue,  9 Jun 2026 13:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FE21F00898;
	Tue,  9 Jun 2026 13:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781011149;
	bh=NnZ0duiGqqSU2Bwh0xKBDnW2FZFfJqlmJyAUHz28ADk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CUcPk5RwgSjLuZG+PyNC5kTVeN95SlpPTiWTlSTT9b3gEIQT4swjLQm6UF72uyxTa
	 GrilAyuTemrd6wVh5b9dW/E/YPfzos28g01NO74kArRIF1+OasSmCGrCCtnqr+H6w7
	 hKmmSorxTyEZPkjMvYEN8ggFvkbQaG6dZ1IdQ8yIX1eRGlntADGRIs0QkxemuT/5iA
	 hju8t3Gmdoy5eBqRMI7PHozDzu57qcKGU0E6eTMZpzrUW0RomBYvIeBi/mnLPoXTes
	 CRTiAYbLXRoQgM1szEgsPyeXjoqWuYmuyIsU3wXYsB2xXGAeqf1UrZr8IjbtJExKDU
	 Jr6on92SiuQxA==
Message-ID: <c9500789-5a27-4348-84b6-a787230edebf@kernel.org>
Date: Tue, 9 Jun 2026 15:19:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix memory leak when
 kobject_init_and_add() fails
To: ranxiaokai627@163.com, akpm@linux-foundation.org, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ran Xiaokai <ran.xiaokai@zte.com.cn>
References: <20260609131249.89288-1-ranxiaokai627@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260609131249.89288-1-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DD76BA0016
X-Rspam-User: 
X-Stat-Signature: pyohsubd9rx3t5x4483ma7nkf6cc3r4p
X-Rspamd-Server: rspam08
X-HE-Tag: 1781011149-516978
X-HE-Meta: U2FsdGVkX1957D4MEw4cp2E3QoZZMOwguAKalACHe6fYxisYS5GzHfEZ8hukcncZDMMu0mfdk7GP6TOciajVWhL3AyBd29oRa3hY5qWuYb/G3qo5xo3ndlAtr/qjXjzcS27k9OoMG61hbU4HLv95fCe7AKUR9CBqe2AtRaIRiQtOtcQ/hjPwDpFdG5NX1LxIEr9+ACIDCtQbbwVPw6oRVX0MU08kiSuLh91ixZ/N46pciI5a9TaCCXtWlIh4yjotR4NaERvvQPp7imMBZvM3vRW73DnheT5LIFp+by8PPDDx0NlTylOKyoHz6YXNe0PoJCzVjOw+2LdUOLpHC0IxEk53sQXHjwlWWtPaCpQz/LluNyFtsZG9UDhaLnQ2j5fp1KCtxlYBoWCJu9xo1OU2wt04D4hyEEQawAwAVUvKDb59Q2wLn+R7svYob7N7XChuIqx5wRWSMrybLNlkGh91HnrsSExDOeZ4nAX3xITpUDlholj7CedoWOmORxcXmWK2qepxdI1DjgcAIinGHzMoZGWa3U+71G0qhRNn6sFdQ9Ya2Z8Suukd/3U6qVw6aJ7d+K+cRXFBrz41TVMuD1Vt/S45hdeZwzHJxmTKL/Vqg90/tueaaZF39zzgEcRph7eaOL7ZDLzS3v/hx5Ibx1rNVrXipSIklDateAohTPc8bxiSrX7eBBC0YZHM/LuX0wqx3d+XcFJRS5MZjDCIpEFKgT8c+heHttJoFOU4oph/oArb4TFLshwHYV1ZUFBdTZ2eFVeLYbrJU9oOeDIL2kPmo7N4HVxclXygU2xsNyUo3DWd3Vhwo5zhkbAstgUsOfSSn9b/8SBh1HDSkpS0QqCMAG/T+6VePC50n9VpJ+yPdp2TWrVJ6mO2oamQqFk4Qmz+88neSFf0zzIM0R7GTCRRsaKzqPXxWUpXA494caBlw2DiGEbY2OUO0yOsDMlQHG7gA7lNYFZrKbdGjVbA6Me
 woYvHf3p
 azmxn5X/15CpIqMXGxYtuXvg+0LQtdxDEH4I2R20ofLprJ3ehGc1P+UQanlvl1MWg3pynfz2j+KYgSc35IGmIUD0ZegahJZBHh6MYuNlZyqSOcTmV59EWlzJngEfhnY5nQm4huLJObaKmNKzMg0YmEUZVtfQ0ddKDFGDpel/wKbuSDmul9qNBLvjfpqPxSpB3nxKrjHlgwdldsFWlwbBrIOUaf4z3v1JBGQDHqPk3hf1pM2fH48T//vp4Tv4+BDV1M50OoeNtthpX82d2DEgc1eOm7lbbsWni1oqvjRgyDrJ8zDe7K4JU2WGhmcxvEjjB41itMPcm1F/BkfFsaGZ5tALGcGn4iaWRF6JCrM6WWBnx7ddK9VGjq+e58g3h9rN4Y0MBRD3xBPB+zRqi0Y14+Yoh2khWS7jLCeGn7KTdAi/UXAuS1rrf0F2z3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 15:12, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> As documented in the comments for kobject_init_and_add():
> 
> "If this function returns an error, kobject_put() must be called to
> properly clean up the memory associated with the object.  This is the
> same type of error handling after a call to kobject_add() and kobject
> lifetime rules are the same here."
> 
> This is because kobject_init_and_add() may have already allocated memory
> internally for the kobject name (kobj->name), and leaving the refcount
> at 1 prevents its release callback from being triggered.
> 
> Fixes: 3485b88390b0a ("mm: thp: introduce multi-size THP sysfs interface")
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---
>  mm/huge_memory.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 653f2dc03403..601750dbe79f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -790,11 +790,8 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
>  
>  	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
>  				   "hugepages-%lukB", size);
> -	if (ret) {
> -		kfree(thpsize);
> -		goto err;
> -	}
> -
> +	if (ret)
> +		goto err_put;
>  
>  	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
>  	if (ret)

This looks a lot like:

https://lore.kernel.org/all/20260411062152.2092967-1-lgs201920130244@gmail.com/

-- 
Cheers,

David

