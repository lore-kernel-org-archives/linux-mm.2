Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A892BCAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 08:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29798E0016; Tue, 23 Sep 2025 04:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02818E0001; Tue, 23 Sep 2025 04:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E170A8E0016; Tue, 23 Sep 2025 04:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CEF698E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:15:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 460DB85DE4
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:07:01 +0000 (UTC)
X-FDA: 83919784242.16.2BCB3C6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id BEB25140004
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:06:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hiavnzk+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758614818; a=rsa-sha256;
	cv=none;
	b=q6g3gXozeM1unH6kzsZ/6qmnae4W8Zp5xjUSOkcP2XBa5q7o/WmQd3UocsgKoYA6fA+ldg
	XpdMbbR6KoGEdeRAPYSnmyuGtsNrxv6uPuYOQuboke1oa4eIMSGLMcMvr7E7GfJwRsUfZQ
	O1iXl3pHBlpS0HMeqiAeGzlhsRwWI/M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hiavnzk+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758614818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oC5YbJTUl5o3B/drvPPjgzi8/zGrudS5oO2LRTa23v4=;
	b=YVICZJ6hR1lT73bY8GQb+DqumS7WJrR/PubRYywj2qBDFSf7qnqy1vVxWrZO1q/8y+4Oq7
	R0cLnwGBMtp2gM0yrD9TjpHpFKzBzskqOxUWSA2dD3Up62exwx2Wmu8P8Wz7wU2/dCbVb7
	hOKXRPtxqC37GeAbd3mLOfqra2veIEc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758614818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oC5YbJTUl5o3B/drvPPjgzi8/zGrudS5oO2LRTa23v4=;
	b=hiavnzk+094OlNlgp3keV4KmoQw+QClSrnUJYcaA/cnUyCDMcjrwTDBCAwrSPQKtB0R6cD
	uHVG+uS7XXumwZ70kLtOYgcxQ6dB+wDHFBC97fRmrr14DuYOjxt2pLbMvccEaIe3HOllmf
	TSifX9czAdIqqvSs82Y+2Zf5cgquAOA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-_tYRh6_SO-WG5LPPF9PMaA-1; Tue, 23 Sep 2025 04:06:56 -0400
X-MC-Unique: _tYRh6_SO-WG5LPPF9PMaA-1
X-Mimecast-MFC-AGG-ID: _tYRh6_SO-WG5LPPF9PMaA_1758614815
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4612d068c47so36892525e9.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:06:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758614815; x=1759219615;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oC5YbJTUl5o3B/drvPPjgzi8/zGrudS5oO2LRTa23v4=;
        b=ObgR5V9otektrHRn81Ylx0ZbP0HyTWPgBWWMrBMZSJOIN5/d1iITtX8pVfyWnaQO2a
         hhj4/V7StangIVEOEUd4+Nzq46IX0vKlv5g3LhLaKvYeVssDAv3tNauTNU8Yo+hWY8Ij
         lie3NdI2TVDImdHIhanDbyoAryRLmizYqf+6N1mgR582of26NgTqCnrHUazQdbE6vAIX
         JfP+eotOl/wiTxBr5Ff9MZQ/MautfsJ1V09DAsLhF1BARjoHqibeQCmMXnFEGsO6C7FN
         Bx/a8NmgWnksi9nC/smMvwGBKMOb5+WIMxRna2Jjwm7SKWOO53DFH5+84JVU/8FJiXSE
         PEGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHfhjN4cxZMh6GphjusTx1Uo+A+AGKtHJKvMHkYgC/ZtJvLjl2oP2lBkzgL+OkT6hql9PIPiG5TQ==@kvack.org
X-Gm-Message-State: AOJu0YyuE0BPUp6iEPkvn7/gemakXXp3VAhDNfTJUV7pjq4OALb3hhph
	qVrewJpmZQ3+k1ZzsUPZQBPWDaSOfCOV1GVz2VU4K/iJYLbW6kwH9qQZueYW6C+TONrTP6l91QX
	tKwfWd9pyfC++CrvwkhTZjzeUuA2pE7Z2PCuySwCi6ILiBDGK3yd8
X-Gm-Gg: ASbGncuPu3w8pbjJ1Piws98TU57qb22S051a56VqnDmS6ZxNijWXSlJyWqYAg+Rrsl2
	1tDffmq7V5CxE3VN1s6exFkyn6dPggm7qhaZ2z3xAHSSDmYQUtVv16AUw5AidlwpPUYzuu+ewaW
	0EFHXdWWJHrRu7cvUIlJp5GlzzAfgdyzDwgslhe5o9kGy7H0lYYYKoazVgFObDReDCgrxHI+0vk
	Fcaeo5sXgsOei5KvfgJ31ZAkFFThMMmn+W7fMZAk7rF4UEE2+CS5lYBH5ZKcpqQQaA7wVBf44AM
	DeFcOVn74SlXLBjigykwF+H8SlQp1qvKXgy+GvPRxkbQe7axqOTs5zqhtn6Id46bB1PRX8w=
X-Received: by 2002:a05:600c:8b35:b0:46e:19f8:88d3 with SMTP id 5b1f17b1804b1-46e1daacc3emr13706005e9.22.1758614814734;
        Tue, 23 Sep 2025 01:06:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpV5l2qp0v75m1A9iNXqDVbwnvdopxtyZaLoVTR/ccyKImNZPFhi4VTpOcRMLz+xHn9ktuqw==
X-Received: by 2002:a05:600c:8b35:b0:46e:19f8:88d3 with SMTP id 5b1f17b1804b1-46e1daacc3emr13705635e9.22.1758614814281;
        Tue, 23 Sep 2025 01:06:54 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1fd57.dip0.t-ipconnect.de. [79.241.253.87])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e20a3a3a3sm9448595e9.19.2025.09.23.01.06.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 01:06:53 -0700 (PDT)
Message-ID: <6626d497-4c27-4263-9be1-1c05d2672019@redhat.com>
Date: Tue, 23 Sep 2025 10:06:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/16] mm/highmem: introduce clear_user_highpages()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-12-ankur.a.arora@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250917152418.4077386-12-ankur.a.arora@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 66qL_spcP_nFbZjsoua2CirJNrtI6_HIxrVdDLj-SaE_1758614815
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BEB25140004
X-Stat-Signature: sw9rjb69693qktp7oppjkueujrj97xej
X-Rspam-User: 
X-HE-Tag: 1758614818-458427
X-HE-Meta: U2FsdGVkX18xLoJ3uZwLfB+b0s9G3YS5RysFG54NyfzsXali8YnS8W3dC+YSHcIlw3T4hOlOWNFtLavjxR+8Mkt3awzWN7Tqh4ZDwAOwSNODKJHq/noqDdaPWw0aABGFBdDV0yx0kuD5QMUqZp1Ku6aACNQIxj+okHAnlnDHSpkZ8LWI6u2ak2OFYB87B/8nUJ/mQlSRAPlNLXtIdEJe4h83Jo9xm3/Hg+q9LhTwUw6q2lPKF9/8Mjp/FI2mnH6FcU5+BFRDOfaYHz6q+lsfTtKbiGl6MTaotJidSOwTxhJhOT8Afm+ghcS7X9sBPtKDkklbpjpiqwNwhnTPhkIytxT3yGnT8ysQ9hxEcS9ZVJKKuRWGlNPPpzm44Zgo0bVCuQMhR6IkZM3U35fQ+fBHYOTd01x1iUR4bYGACX1GSREoRJee4dAKhO6RNSX3fkgsV7rAmcnBJeQ8pGjZFtSDvy1YKPcnKO0ORAbJeC9HQpFY/55So2ZZmI4OJMWgD0WmItPlwnglZ/YtRyWv4D0ow6CdZ45r4oRziNT3REzRF0MyglWsPPS2c3ljIIxM4G2s+3F082gGpse6X/HX0z42pFKS8LFEiplq4TpqlffyHB3Kztq3/GURObtnHqcWVkUHh4QVnjybRirD28sC5uJeLjnVSgb7R4byuDTto9xeaaZ5iwcZBDBCC4UUbJ8liSuGUu3rYTmXfMZhHyfUupuqsQvOfs09gbgTlPCfWT6odl9YfvsHJ1xAL4a0zvkIFghOC9ehmlpaRdYsNf8EKKrPu0e02rtCZVdAEhCOthvadhvnBQch1DO16JGYJKhi1JeTGuHGNC6+uk+Tiho8XJKYwcJ8T6XG3uI+YFXY8ffp/bo/dtcyoVB1rCgwbc122IwvIeLjdP3XsXYYZYaOt7AIekZv2aX74oz2ivCVB49Wtb5ssqOjKT64sM568qHTdMzdVlBv87e4B5Ksk6PFl3A
 aULHHNy9
 yt3Ji1PnkgkLPRuy9ooqEDKNm2Thd2GznogTT7WUH4rAr8SQCkGz1jwQiYHVavU3zDmWZgUHLXi2vP576WHOEpRdSNpiBX95IlT+yUXkZff8mc29JjPm6AG2XBPJ5PHLz3aHDfQme0pLr+OkjoDVCMyPswOwUj1fri5XSt8fgA2HSV+7DlfWjU4j/8CueOJjedTQqbw7L5mC6nZscGujQ2roDA7mmQHA/UbE18ISCEvnRyr/nbchkPel7FrdtiVeWj5qEhhYgVxj92NOIUGSm7mA37YBcit7ka4G3Hnc20/AdaQycdIB5y8FrWqsPZbCwtwwVftxN9Cb6+9S04nFkT7yEx7BIHqafF+BLLAvis5I3VxUPszDcgc5OwDihKeHCFkwU3mYUzxDDtmHmz6MQdL9C/k2RJzfujvT+XEuAvur1ToemrxL4ty0lrbKP5FOPyr6rel7exXCodvUbPyLjVY3rz86x+5mZ5Aw85S3tuqCBbPo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.09.25 17:24, Ankur Arora wrote:
> Define clear_user_highpages() which clears pages sequentially using
> the single page variant.
> 
> With !CONFIG_HIGHMEM, pages are contiguous so use the range clearing
> primitive clear_user_pages().
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>   include/linux/highmem.h | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index 6234f316468c..ed609987e24d 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -207,6 +207,24 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
>   }
>   #endif
>   
> +#ifndef clear_user_highpages

Maybe we can add a simple kernel doc that points at the doc of clear_user_pages,
but makes it clear that this for pages that might reside in highmem.

> +static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
> +					unsigned int npages)
> +{
> +	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
> +		clear_user_pages(base, vaddr, page, npages);

Single line should work

		clear_user_pages(page_address(page), vaddr, page, npages);

> +		return;
> +	}
> +
> +	do {
> +		clear_user_highpage(page, vaddr);
> +		vaddr += PAGE_SIZE;
> +		page++;
> +	} while (--npages);
> +}
> +#endif
> +
>   #ifndef vma_alloc_zeroed_movable_folio
>   /**
>    * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.


-- 
Cheers

David / dhildenb


