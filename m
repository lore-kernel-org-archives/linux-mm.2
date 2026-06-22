Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E88BCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0B96B008C; Mon, 22 Jun 2026 10:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B9446B00A7; Mon, 22 Jun 2026 10:44:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6A66B00AA; Mon, 22 Jun 2026 10:44:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D93EF6B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:44:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42FA7A019A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:44:35 +0000 (UTC)
X-FDA: 84907819710.16.789C8C0
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf16.hostedemail.com (Postfix) with ESMTP id AD49D180011
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:44:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VOl8Ph1D;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782139473;
	b=aRV/J1UlgRy0gTqW6B86OOuxExHtuVnvZgxYGZOlMQGDUouRut51eojktw+Gl11pQxVJ+h
	lBqxjQqCgrMlnW7qBsLy1xbFRz5TIV5zc8JkQx0EDY8uixXUKrwseQkfb2CnQPj75ewkx1
	BqCahy8kx9sy0sobFOmnAeVNHG1cI/w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VOl8Ph1D;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782139473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5GpC/58OIjPW5VUdg3/lmsNA+ApTm9doUWXBLX0N1fY=;
	b=NepjDCmmPVJywbiepbRDPw7SsWYPcSVRHX1YcD6TCm6U/eUBIgSGPOO1yjHwUZ32AB5Kad
	FkjE8bKfisl3Qn5TtCjjnulPa+ULZLQMQK8AZAl1q833Q/RMp+wB3CQ7u8hV9L0Rgie7Ue
	f73aiROJKPvs2c0wjGrRGhyu2wFvoGQ=
Message-ID: <bae77c2d-117e-4344-91cd-ab9d5293c605@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782139469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5GpC/58OIjPW5VUdg3/lmsNA+ApTm9doUWXBLX0N1fY=;
	b=VOl8Ph1DZdilhTcZXNLqhnjlYI0B8CCAfUVYmd3MpweWipJrtmwv69CSLaXG8x4/kLUavF
	H6C+4GX180ccjbkalabMfKh56X8K0O8Hw583aKpWsxh6SBM5pNzVuGB3dPWEiw7+x+y5GI
	xHaSBW/3/LoztTgGrTbJDIPbRRav/HE=
Date: Mon, 22 Jun 2026 22:44:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check before
 return device-private pmd
To: Lorenzo Stoakes <ljs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 sj@kernel.org, ziy@nvidia.com, balbirs@nvidia.com, linux-mm@kvack.org,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260622130651.23359-1-richard.weiyang@gmail.com>
 <ajk0N3Aekapljaoh@lucifer>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ajk0N3Aekapljaoh@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ewdh5n99meycpqppytc8zgn79wcoyim7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AD49D180011
X-HE-Tag: 1782139471-897962
X-HE-Meta: U2FsdGVkX1+In3CPVe2MklznwhJuHyJgger9oCRMd+WNAAA4WgdYXl4wIwtgbuuJxO8/BdCaZGbqTT2HkySgsCorBuJZnsdaQt5L/xVjiqgwuu5eS/i/7Df/ZBkAZuA3UeRcQLF1P8C3lwCojzu81gISIinS+9urLuk7SU9UlATASmQCk9uh058JvpyBMnOmV4sN3UwBELWdjpJgrr7dDYqhu2cbUrJHWyIRiiDl6G7LLN+GCMDGT7qxuDIN/IwwykMeI6hfMepI8boOvzQbCeE/risP3d69288634Q05g/dPXF/ID2FzgD1KUaHpKYmvKrd4APVJOtbGUjQhcitDAiT6nnfQRzjBu834GuwUAzXGObeXNk3sYjyjfT+os05DGvLQyJyJjRm8Q4ccp5uthDCq0nMDCP20npCvXl5CsaUVb9/jeK4Ei0xA/JhqUVeZyqzGuLjqK4yqclpV29PY3jPTWRQRyDDt74unFSGUTVqyZkiUjW3DW3kTsZBDWOy0/kUuvOszA86nceKYnJCiTATwDDOzDAslxjtg08L9kPjEllXTCH8sM8ZFRKhVFhXVaKYiRsU70oQY7aCpWmL/atfCwymixOdvAAwqco3x+yUou0HEg08Vswyf+QnlQPlMCllANSqCLtQUsc/YIFKHwmQmUAWY5eU4zvSVIbedoVjoaSxP/vfdYxIcA7uaHVh+veiU7fnDIjZc4XmzEAxZL70tY/VVRM0Zgy6F1Z2VjHBW96+aK3gE+NsfoyvqPJJ41NxARTBdmRIQqzWVPShSeeMkZvDvokFkLMpSurDi76c8/L4Xv0PZL+J2iNrGnyVuK4FcTn0qifdt+Kyf+cWLsIricFGQ1CZ9M7utCv2YD9lxBGD4tKsxoSOBYcFhX2lPcvf/mfpaJK/3a8tsp/UVkP6ah67OKwdhUSg86mp14w1lubjF+Hb+iWugq4HAJvx+20yOwaJw1Vo/IhgnYc
 +IBaPvIO
 xSd3bwxojrFhMxIPkL/2oUZs4F0F2X4bCE5I8mH9GS64zSSndzb4uW6kt6jYCaJw3UfVfCdBUO7K9jl3VQX/JNvfGyOrPe7XLGM18kNoefrtzzDt9QJLHsTz5leBTbI/qawQEdaKlPrKwDMTMHVEhN20LQUgk3B3JqOJPpGbzL/0mrrBrTAXvUL0O/dDduQL96ox8WTgU2TKcaY4RR/Lt0ibItCDghL37kTUYFbUph9TmkJqVMBssS2osM6RdAjY3LKM4pX1Wx6xStltbfrNVh0k3vf730HpykulOZeKmh+pFSzRoGurn5Io/lVaCZrbJ7KDCMSHPPTq8sj/qd7AMfG87ABAe5EXrN5Pq/kqOSFecMUC14E5a8ZYGYb8+0GtZq459
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/22 21:46, Lorenzo Stoakes wrote:
> +cc Lance, linux-kernel

Thanks for the cc.

[...]

> 
> ----8<----
>  From e6a3c1c782714ed831c4d46a14bb99226423bf59 Mon Sep 17 00:00:00 2001
> From: Wei Yang <richard.weiyang@gmail.com>
> Date: Mon, 22 Jun 2026 13:06:51 +0000
> Subject: [PATCH] refactored
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>   mm/page_vma_mapped.c | 20 +++++++++++++++-----
>   1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index 2ccbabfb2cc1..17dff8aab9f9 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>   			/* THP pmd was split under us: handle on pte level */
>   			spin_unlock(pvmw->ptl);
>   			pvmw->ptl = NULL;
> -		} else if (!pmd_present(pmde)) {
> -			const softleaf_t entry = softleaf_from_pmd(pmde);
> +		} else if (pmd_is_device_private_entry(pmde)) {
> +			softleaf_t entry;
> +
> +			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> +			pmde = *pvmw->pmd;
> +			entry = softleaf_from_pmd(pmde);
> 
> -			if (softleaf_is_device_private(entry)) {
> -				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> +			if (likely(softleaf_is_device_private(entry))) {
> +				if (pvmw->flags & PVMW_MIGRATION)
> +					return not_found(pvmw);
> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
> +					return not_found(pvmw);
>   				return true;
>   			}
> -
> +			/* device-private pmd was split under us: handle on pte level */
> +			spin_unlock(pvmw->ptl);
> +			pvmw->ptl = NULL;
> +		} else if (!pmd_present(pmde)) {
>   			if ((pvmw->flags & PVMW_SYNC) &&
>   			    thp_vma_suitable_order(vma, pvmw->address,
>   						   PMD_ORDER) &&
> --
> 2.54.0

Cool, looks way cleaner :) Nothing jumped out at me :)

Cheers, Lance

