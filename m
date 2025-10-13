Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 249B2CCD18E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:53:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A19B8E0061; Mon, 13 Oct 2025 11:53:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779468E0009; Mon, 13 Oct 2025 11:53:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F988E0061; Mon, 13 Oct 2025 11:53:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57CBD8E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:53:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DF1813AB69
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:53:56 +0000 (UTC)
X-FDA: 83993536872.03.2C18F20
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 89B6B1A0013
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:53:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dUyG07T3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760370833; a=rsa-sha256;
	cv=none;
	b=Aao4TaRVBISNKpn2+ZKOvk0VA3XvmpC9SAHgOsa8zQG8XN5tCZW9O8ooeVXdeLrwaIm/pQ
	RBISAPMdJMsKKV29K6gNSoedEpw1lqpmwlS7PHjMc/Osq+utCtIeD3AWxZjpjylQcO83IJ
	+TCTk4A1arRqOLHJ8Hakmyt0IGbIZ4s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dUyG07T3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760370833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9LwG1eSGGWxhUZDRcwO/KGVPbw9N7GqNPkIFWf+bnw=;
	b=z7njioIA31XYMRDpF2YRbweWNk6pTqUdZv2RcxSmfbsG66yqRWB3CJJ+M6PGZYPUWSaukj
	8gNYseybZ4mNQsSO3Kd/nAUoEaLDbY20c5Qw0UNTUeffw3G7UjAbTM8GRoqTi6ty8Y5anH
	kHby7fLD0UqyLiNVxZrpvb3GlfqjbOY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760370832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c9LwG1eSGGWxhUZDRcwO/KGVPbw9N7GqNPkIFWf+bnw=;
	b=dUyG07T3SVjVkL6EYwftUbTEt9yPB+62cLwUJXbYQZbcfzneLOOw69jxBYA1li2xz6ZLX1
	DdMWnxTZuxG5m7TccuBL/FqPtK5tSAeAVrFYhUdUO9K8b/C4I/+eCyIIJxSS+2T1vaTi63
	6TPMJ7G5MCS+BZa4jsON12H8GDVTpfU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-sULU9Ej1MW6ruZsu60_2Sw-1; Mon, 13 Oct 2025 11:53:49 -0400
X-MC-Unique: sULU9Ej1MW6ruZsu60_2Sw-1
X-Mimecast-MFC-AGG-ID: sULU9Ej1MW6ruZsu60_2Sw_1760370829
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e3dcb36a1so35145085e9.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:53:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760370828; x=1760975628;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c9LwG1eSGGWxhUZDRcwO/KGVPbw9N7GqNPkIFWf+bnw=;
        b=daoRGfnuuf9ztFVEABV+Q1Ggq/gondqwtr4gjrYMFTLnC5MWtLRnJB8LNc40OTbtGN
         JDZXGwlQeJqICnXAjWJvrRzzrw94vapQB6bxC1/cUEVQN7pOJKPz1cEc/Fb0Uwy/GYrU
         uAapNmad2bOWMIjx3LyzVCj1qhRCOvMFr6vHM/gnnbW03Fv26i0+pk85RJUY5xXRFR0B
         Gmqjq8dEMsGPlUrJO0maiPqn3zWulpluWR162VYrj1NBvd/GT70S4hjgtRgKiz5KUdy7
         hD8CGqr9exGQzSZfo+OI1eC8AJvVpi0BgWVXFXhccwnzkxQQ6HqoU+Fq6TiK26SUBOHU
         8HkA==
X-Forwarded-Encrypted: i=1; AJvYcCV69oq9ssb30VHaEXNGbYKZmoVUGZsiY6v1KsWx7GMw/METDCjImLzZMbE0WzyAtbWic1L3vUNZRg==@kvack.org
X-Gm-Message-State: AOJu0Yy/QL4/ga2HeNYZdwirsoVeI7LZYFw2k3Ty/ODBpy+dApKP6uVg
	391P5sjmPV+RNbZ/MoMiBhKxFHw4ioNFIW7+5PeAjUB0xj26rmz3aIiYjxF0CryCcSNsPe7lXSx
	yMkJU4DBzuOjbtLKPv8WWHCl9ES+N6rfxHAlgvcpU7EVlHvAkZQyP
X-Gm-Gg: ASbGncuRHxYbyn9ePMNedvSauile3L8lxAQ+EySy/6tb5NxzkvNK0otKfIINYNC3htX
	90vmGCF9+lksdY41PZVraJv9oEtcxPqQcQQyUmz0DXQKCtZlMHObifZe+sD4F9pbarZPLLBQvRH
	aivYK8R9V9BBxz6JATKEfwvA/geq6CEoMyv2PkOWWEcn1Z9+H1NVnRLzNDBeIl3smBkeTV847hw
	2oqukaPKlLbwcZqGqezbVQhth7fPl6j8oPIuUD9KMqT/Fpr8ZuYN6sYMNxFPWnsB8MEkYnRGgCz
	sL1F02NfrJKC/WLRKqjPGQhuQTj3sHM9icU79Hk2QgxTk8g1xrfjoargjHjHCW0bbE175iXAbgy
	aDT0=
X-Received: by 2002:a05:600c:a402:b0:46e:4705:4958 with SMTP id 5b1f17b1804b1-46fa9b9a362mr131264815e9.30.1760370828577;
        Mon, 13 Oct 2025 08:53:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlGb6vjpz2CNA8/ap8VTMpZB8KMhmPmX3lHWI5VpV0SCt7knZDOR0bRfNLMsW5bSn2GIzFlg==
X-Received: by 2002:a05:600c:a402:b0:46e:4705:4958 with SMTP id 5b1f17b1804b1-46fa9b9a362mr131264605e9.30.1760370828192;
        Mon, 13 Oct 2025 08:53:48 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb489accbsm219125495e9.14.2025.10.13.08.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 08:53:47 -0700 (PDT)
Message-ID: <93d00bb0-8aa7-4f52-b9ba-ef777ec191dc@redhat.com>
Date: Mon, 13 Oct 2025 17:53:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: mprotect: avoid unnecessary struct page accessing
 if pte_protnone()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-3-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251013121536.2373249-3-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cPIvV3JbeTRZxVkkJqI9s7T1crYjrOAEwALq9Seh0BE_1760370829
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 59mwze48q4dbjnroi9d8ooxx4d9pfdqq
X-Rspamd-Queue-Id: 89B6B1A0013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760370833-254006
X-HE-Meta: U2FsdGVkX19umFt8l6egmd+loemIV2xUK/t02LYkmsgmeLdMg9Ibq2fyoF+5Qctez/4vQQXHyROALnxJ5xsdOfRgzrSbGmAH7xeAixdHI9AhTvNNrFXIAYCDukz6lEtA9AT+faLzICewB8/I+50X5h86lOfXFK09TLvr1skftrFvalghNuRbOwgMubiSsvr1EQNFftkRjpm3hXQ+OY5xvO/2TMWi/insRPrjPnZQ3aPez3Fz87Nj+kx/UjpwN72OfIXHSuuC7mn9cfcSuJRAWu2BqVMYAKjMTrHCyz0Ns0/lg4n/cM4iKNb9b/kcwGXj8b/BtVb/vFw6CJbM0hLvX1xHl/HR41AN1Ik7jYgBqxIL9JgCaQV0MsxphY7TXfQBTKovt30ZFfQT4pIITyel7K9e6dVBjobizl6/pxjyBYOuHnbGHFdXF9pxjaFEPb8zGaQWJe2FT7z5IbEGTF30NUrEqcHN6zUKTaxrvCXhBZjNkZVocVjav3fD08SyHpaWK699b5m8tNp5Wz3yCbMEaOTfajJtd2a5p26wMAvopLamhbzswox69kCqm5z3/adXYeRC+vmLr4oSpnRWO9hOB7Hpcf5TsxICNQbx8IOe0c1wvGQ2gCMIyaROD69MmdPWuu6L2X7P0LJ7/v125/xmq/2hoKeuIVUuubrIS5uxRREyIB3PGmgVefVnAjKBXHl41bR87ugJYc7/gXSYcKywHhAUfyhHYKOtPnbl09L/TvcWuPtfbjJMZODzssUPotjUyFOG9tqHWg9tS3yPYQy9e1t/7E3i/Zy8U0Dyrg8s5Ln6WZ9NO9gMj+67u3RU+hd/LcaLo8nHFjmRZA4XRUERVHj6HaAqCRwBjsBZSds1SwP6oO5rhg7yrM9q2IK8N762aickMV1SXO9xuC7qNCCCmKGSQCtsayVR3enGNi9tibRyk49CoZmxKInmQmSgj9RBrEyykzdaikVXkoRjkvE
 57ImURVS
 JkCqj+Maw1PlK6SxmGq7ckKyrmZE2sbTxcSRxBzhsYUAWZDvJIaugFNC5bmrHuM41fZ0MZnu9KWcJBq3nZCgdbkOtNXEtm+3/IMpYr3QPA7NGgnhuQj7fTUXdUbYljvZeO9naPvhZDCx3LFGdTvj9UDNhRfCsy4be1IuWQVk3MLGPcQXvmQum/H546c/gc+K6/2x/MdU1o9kNZWz3GYn/F6FFc9uuHyNbbWI83HxKdZZOs6R077N2twAwr5vWrquPx0af5OoQc7ij6TcHBjnr020yoTaISAxS0/sPrUwJa8KvPgsVf4XMZ8GSbYtzn4qEYbmgxrZvfWyUu0W/Id/oyrxNWB4NWj48VJrbsUsCZvIAuhH0SK0C3HGh+jpQukINDEpAkUs982BsxnHXmeiQzA4QzF1VGxESUKtS3r3H0K+h720AeFsGVjWC+1sSohx5n79R182NYcDolpFNFeILpn1dmBzHn2JXQYSpgJyzRHMLbBMKvUwTOJCpyOQHc7AjIgInugNsHjnqOaXeEf6ieWOO79hj0CDuhDnNGJpiK9jhv8DT7bDH1Esqrii/ebO3oyZVhMHvcHJxQjk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 14:15, Kefeng Wang wrote:
> If the pte_protnone() is true, we could avoid unnecessary struct page
> accessing and reduce cache footprint when scanning page tables for prot
> numa, the performance test of pmbench memory accessing benchmark
> should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
> footprint when scanning page tables").
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   mm/mprotect.c | 21 +++++++++++----------
>   1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 51a28781de9d..0f31c09c1726 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -118,18 +118,13 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>   	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>   }
>   
> -static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
> -			   pte_t oldpte, pte_t *pte, int target_node,
> -			   struct folio *folio)
> +static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
> +		struct folio *folio)
>   {
>   	bool ret = true;
>   	bool toptier;
>   	int nid;
>   
> -	/* Avoid TLB flush if possible */
> -	if (pte_protnone(oldpte))
> -		goto skip;
> -
>   	if (!folio)
>   		goto skip;
>   
> @@ -307,17 +302,23 @@ static long change_pte_range(struct mmu_gather *tlb,
>   			struct page *page;
>   			pte_t ptent;
>   
> +			/*
> +			 * Avoid TLB flush if possible and unnecessary struct
> +			 * page accessing when prot numa.
> +			 */

I think we should just simplify to

"/* Already in the desired state. */"

or sth. like that. No need to mention the struct-page implementation 
details in this comment. Also, I don't think there is a need to mention 
the TLB flush when it's really in the desired state already.


> +			if (prot_numa && pte_protnone(oldpte))
> +				continue;
> +
>   			page = vm_normal_page(vma, addr, oldpte);
>   			if (page)
>   				folio = page_folio(page);

I could have sworn we discussed that while fixing the prot_numa_skip() 
fallout.

-- 
Cheers

David / dhildenb


