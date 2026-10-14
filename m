Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8723ACC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864C26B0088; Wed, 14 Oct 2026 04:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816436B008A; Wed, 14 Oct 2026 04:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72BAE6B008C; Wed, 14 Oct 2026 04:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51D816B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:38:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D65061A0482
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:38:02 +0000 (UTC)
X-FDA: 85320579204.15.06174CE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2A6281C0006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:38:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YW+O5SxZ;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791967081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpfbp7+09VSVLT2brzHvfoYrBS7F6mk+5majLqh1Ny0=;
	b=EcnPlINd7wcRBkUj29cYWfPLZ3FEgOgK+++JXYKJUu+GUDSRACHQZAlQ114yrrmj2at2vd
	v7JVKxCrdygR9BqWl0t9weqymFyMPJNxrI5GEWAG4GIppprHuqm97BGGH8lpBUyR+xf8qn
	RLRvxkBlclpWcEyXc4pdT8pHoCPelOQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YW+O5SxZ;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791967081;
	b=zJVmBVKqGEothObESHhxTn49df8DJQy+2CzwST4hSc+p/HDCUaaViHFpcVkn+gIAzPHC5L
	NjlU6rzIhMSq7wEjhTTUGizmKG9echKO9XJhe0EnUN+SOHQlI244jNB7iDEhtXOQxN2jsk
	PCSwybZEhd7Q4LN1i0C1k8hshlitSGg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0BC551596;
	Wed, 14 Oct 2026 01:37:57 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C018B3F7B4;
	Wed, 14 Oct 2026 01:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791967080; bh=Lvh1ebzqQWLVy/QzryOeVmDqirZlakF61dyc2OgQxSQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YW+O5SxZcPWoxb2kG3EQpKGLvC8F36KUBW01MWK6X9q57dGo6HKRHPLgvQ6s2VAKU
	 P1X7INSncDesFr7A7sT/tuUyrkfiKfCdFHG5ahDf+NUh+8hSrgfzD92ECUDiEdb2lH
	 w1XLvv7Z80od/QksxuojE4SaYRCMTIxQkcYwlU3g=
Message-ID: <498336e2-8a48-4cd4-80fd-b3da571ded12@arm.com>
Date: Wed, 14 Oct 2026 14:07:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/10] mm/vmalloc: extract vm_shift() to consolidate
 mapping shift selection
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 baohua@kernel.org, chleroy@kernel.org, david@kernel.org,
 jiangwen6@xiaomi.com, leo.yan@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
 ryan.roberts@arm.com
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
 <20261002090947.869220-9-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261002090947.869220-9-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2A6281C0006
X-Stat-Signature: anx5joat5xqnoo68oyorkkdm6aq7yxei
X-HE-Tag: 1791967081-503693
X-HE-Meta: U2FsdGVkX18BTrTnDynjGdJLJPnR+jEE1Uh9snebFAuuxXqkI46TTSH0hSG5/c5Mby0NhBZPYNx25f8rlout+bR4kqaCX2uOJdkqG67KRXZGVtKV050ZgUrrI7Z0eOjW8MxUWnDkADD9AoZitE+8fY/zh+GMeqdii6NYtUo3deAjU3w8l/kQc2yyNyYWTu+ont9BwFq7z45dVd5C8lvPWEgkgIBYrgMabxGxRSgqC7kzanw9RfTy8ZKrDMnP4sFTMFBdI7ai6fEh5HjkqAAFy1vfvhhhwoPlohG9iyeORPvmTwQifVVt3oMBGANWZVGLLkmlRHWMCLD4RrxTh0TtnwZ1Rujwr+0Z3csNdNZX7SCeRzmrn4OpLVB3Hd0vw7fthgmlUadq8mnk+XCdducGLqre3E5Qsd+wFCUo/s8LXGHjcutkrYnxGyf5aaWghlDFow6DEqW4zoyvt/pRfAu82agT9nuGJQzof0JS59Bca4MzXpVyWNzNn7MyBlXllzm+Z9TOCHbv32KkpvfMA0iId0wo1BIlysoIEPaHgJrM1DQLdZ+085nGbjY2VIUk39bBsC/Uqbe/rQBE6kL+xr0cDAl7FvAFChEKer807FLooY8/gvlbgqba3Iq+65W22WOHiyL0o+f/+aC7iYlbQY9oG+rgS8sDVYZE9hivvJfqpDpMCbNLPZ9SOdEoig4pq/HlJkp3rL+ifYHk1eOku/dYANC/FLywF7f8h+B/OlZqW5nsigNZ2OXDuY2S/dRc/CcnKcOpdvCbZmKYXuMLV+FFX72Xldrx2ixnGzSFVNYfTl04LJ6jfrzcXaJtBSExLgrLIHIX2JO0iAmqYEIVf8FK0OqI4uHpcnTCPqB3zJzmtztnqAX5nkUl7kiUp0AC+zR/tzHa0sYagK7eB63MhCJXKjAtq3jiyHNYx5tVRZQvF0NtEdUkF/fE+zKwFP7NuXixTkFv+QilFz8Sqr11UPH
 E12drEPk
 bmyHZmX2deThnZKVCUxIiKOrPbVROblvkZez5p73CzuUO1aaSZswECXmIl5PnAbPSJElj0Ic8hiLzSFzXkt4uzQsBnZvSM86Y46EZfLbfzJX3Bq0K71eyJIqmpuoWcqQApP/EDSRiAqpjUvKdjVPqMy8ReUS4D9176jmdS/KZYwSeYlWYUTjctAd2D2DGORjaeKBiG12pj7ghgNMbiIAOp86gvr/TabD2u7pFr10eopeddqD+d2YmB9QTIAaxCZFYlgRYUHUB8X7vxTtpx5QvsKRXGr4dQneiUPBeGosqzdo4DgN2qM7a/ITH4TAGxl9MojIlHNY2DE2ySV5wHw7uux0wUgCG1Owcjcp5tWxQ7vlELvKF9Jig60mleyU+BgBceBdUoObOADLw2m6bS19domBJd7ugIGBgNXWAVToKLAhe9L2vqVeQojn31lmroiPNNfU1iKbHKTpR8J+O1tqa0Y4/dQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/10/26 2:39 pm, Wen Jiang wrote:
> Extract the vmalloc mapping shift selection from
> __vmalloc_node_range_noprof() into vm_shift(), preparing for reuse by the
> vmap batching path.
> 
> No functional change.
> 
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/vmalloc.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 99bd22c086bf8..aae6141aaebf5 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3568,6 +3568,14 @@ void vunmap(const void *addr)
>  }
>  EXPORT_SYMBOL(vunmap);
>  
> +static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
> +{
> +	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
> +		return PMD_SHIFT;
> +
> +	return arch_vmap_pte_supported_shift(size);
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -4079,11 +4087,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  		 * supporting them.
>  		 */
>  
> -		if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
> -			shift = PMD_SHIFT;
> -		else
> -			shift = arch_vmap_pte_supported_shift(size);
> -
> +		shift = vm_shift(prot, size);
>  		align = max(original_align, 1UL << shift);
>  	}
>  


