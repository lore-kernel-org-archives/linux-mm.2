Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC77FCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34E0A8E0078; Fri, 17 Oct 2025 10:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D98C8E003B; Fri, 17 Oct 2025 10:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19FE18E0078; Fri, 17 Oct 2025 10:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F41FC8E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:51:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86A62160128
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:51:10 +0000 (UTC)
X-FDA: 84007893900.04.79876E0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2483C40018
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:51:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B+D771gu;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760712668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7C9hu553OGC0Get+n5WL3qvSp6zoZqo26CwVK8246I=;
	b=0aGuS0ZBQ0pp5X++qjMPjAvxOaEhH2WQ7D4aqS8wxG60JvKt0hWveA3Zy/wgXYI6ny74oM
	TrdUa4z4rFlsNuQ/pqNDhkmcDjRZ6N3PCBoW0OqUm7UIvPhD/UgQ3Fkib4zyPQC80O7RDx
	rJbQPpE6iYoz2Kgolpo04VNe71mdlzE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760712668; a=rsa-sha256;
	cv=none;
	b=O6ij+4znkJ+YFwfmq+QgfoLuo94sq1HdpW/mtZGKR5IHhyu3yNNeeT49I5dc+0u35CAyCz
	ivHi+CYsP188N3IyBqmkU+Xk8sb+0jyPxZqdNyeRi+bIt8NSm4doq9ZCDAY9D5g1DrV8xl
	/QCMqlVVjknOVw8PXnq3hRRGlaPS2Bk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B+D771gu;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760712667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B7C9hu553OGC0Get+n5WL3qvSp6zoZqo26CwVK8246I=;
	b=B+D771guKx8/DAgl0h1Hc9jj4JWocBKnFTeEzXVl242DTXn3B8mVf0bh/5zETjvsRuxgfh
	sflhWgp+LWgbsESbySmJgC4vE7vmsa6sbFwqwFo7RUfmRr9PT1gmEzjy7udaj38tuiP5+y
	VGQ8t32/HMdMSFH4U8a7ZjSGuBj76FU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-vbarVrxxPTePHOUibVjTFQ-1; Fri, 17 Oct 2025 10:51:04 -0400
X-MC-Unique: vbarVrxxPTePHOUibVjTFQ-1
X-Mimecast-MFC-AGG-ID: vbarVrxxPTePHOUibVjTFQ_1760712663
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f924ae2a89so2656105f8f.3
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:51:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760712663; x=1761317463;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B7C9hu553OGC0Get+n5WL3qvSp6zoZqo26CwVK8246I=;
        b=D1+IIth+MwjLYq9ZVem3/eKkuXB4an5UlJSU5vK276Hj8Bar/CILpm0suVCO6ZHpG3
         wvXRqBdBjg/LMHTj0iZLfK/5FFAYFjyvSJTTFCN9rg5xT3U/0ZiVx4TZFQwPT3sBUEby
         cjIhByT+nIHW1DSW/vNzuLp1jLtewYM+wa4vvTRbfVfqexaz/yjuRqw8z8quLigeFIII
         a3oq+FBKTkIJnLtQ/nXGgBGFPwyl1dnAP3sp8Ooimfspgsx+qrPVo4y1RhN/4kfjtK6h
         eWKlYpjf01N78Hq7TOCDrstrY/TjjZ6+BbM5i03D8SDMupWJwBvnO2KgvCYhfVwrn1lZ
         XBfg==
X-Forwarded-Encrypted: i=1; AJvYcCUiolVYrKJcHuQ+HvIQcApTU4vshf/6ZWfhni+0fvxhOOvcWXV+KirdYa/C0G+ro7zB0M2rtcHV5w==@kvack.org
X-Gm-Message-State: AOJu0YwNhIfcsHyY+dZNU3jGSYt/ooANel8IVHnVKRnB34dOWH8rQkU3
	8tSaWU6CgQHAkICFGI7ZoesoAHx9dn3Z6OyUJY9bOdyiFYa3wS5RRfdMYfZm+iJJnCv22xylBYe
	CngOYAqwCEzqWzK6MqFg+AwfQG9R6q1OloBf7tzG7Srm6FfN7srfH
X-Gm-Gg: ASbGncsjm0qayPvVDe/gsGnDkeT5q21ULBQXoMLToT/P00jsog99aJhm1YL3RxBQgB7
	3OaYu9sd/15FLEm66tXXISjEEX/MFdTHrsx7UHJnErOLiJWj/4vXTkJNCE0aZmC+QYrJWuLwYn/
	MPC0jSdZZdZkKB5uRAqgPUCGFfkYhQYKFXh0ayUqaUpyrVE+ZAXjfZxoGF9nWfy5gsMw6tigw5G
	lFBooWH4Iju0D3oP/24b78inxFE+M2oG4swkCcwrAhc4W8bTTUqQGY9yDWfts+bzSpH7VFFnfnB
	nESZwFuiWSI9ZVnsdJJLWnu0ft4EPHhJ1feEbM0J6BVOYgh9BCdOcl7xepLIoK/THoMpBW5NRUd
	tdbiRDG9mL7o/S9fHTFDa7wFc4gJ8bhEqnXzJfM89D1wA+VkwoQYBNSkevaSzTsliz5w++yZesZ
	47pcd0pbIwxsdH89yJSRLJGLF+VJU=
X-Received: by 2002:a05:6000:4024:b0:3e9:a1cb:ea8f with SMTP id ffacd0b85a97d-42704da3924mr2740537f8f.52.1760712662805;
        Fri, 17 Oct 2025 07:51:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfNQMBiLauvPSM0faAjKqEzpbvcxmljg9bBT34eftkoiDWS2pQ9K9WkhYw53TR88fYTwa3Fw==
X-Received: by 2002:a05:6000:4024:b0:3e9:a1cb:ea8f with SMTP id ffacd0b85a97d-42704da3924mr2740519f8f.52.1760712662311;
        Fri, 17 Oct 2025 07:51:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42709e48963sm1964395f8f.23.2025.10.17.07.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 07:51:01 -0700 (PDT)
Message-ID: <1937040d-5e70-4d9a-b77a-261bf0f4994e@redhat.com>
Date: Fri, 17 Oct 2025 16:51:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: guard is_zero_pfn() calls
 with pte_present()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Wei Yang <richard.weiyang@gmail.com>
References: <20251017093847.36436-1-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251017093847.36436-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EguQEr_APqDtIoYH-rge05TnapqjkGABOlXZVEvj_rc_1760712663
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: g98y1j9jbp71xi8a6pwzt4uod9i43r4e
X-Rspam-User: 
X-Rspamd-Queue-Id: 2483C40018
X-HE-Tag: 1760712667-942530
X-HE-Meta: U2FsdGVkX18C5TeJVyB1azwqqnj1iBNaqHtgJaE05N/fohn2RgefWCN8REir1AD3mIOqR0Rgdp8KYzNu+WPMWnUs6WYKtqPwaVJ/pTw0vSbXaTa9n+MOWWGCcSxIXTCZL6AyRdnySF8IWpA1x9rnrndAytLutEFcg2ugKPeun0S8LcSlXxsiBALz14e+lbPjTgGP/q86E3jxPZD8l6cvodSPzXRF2ZoRZp4q2rRX9E5krS4J3FKEfvH4IrNdrHpijJog1h64cCmQ26iGyabxibwUBNJSHMPFErn0M6OM7/+2dDBRcUASmB5AftFa8jaY+u3pLfT44i8XgjMcKpog+aY/rSp8//k8fJhbfEcHssmIPRkVUGHmIk0WT1Ih2YfGaYlYis8mnfeDaf+V464ys8Y1039PeRWRxhBYAz3C3IAyqPmb0VxVK9KJrLTCrm4nRDCL2Bi2oJhmE3Ro230K/olpW0InW2745M1MLtb37WzPxy8BpBtU4Y62gMksiIh8JS310yKvkv+UrWn1nw9bQqdXRf7lvsbnuSaSw30ueWJ7I6jUOgTvQorEcpKKnXuwZm15g4n9C1Ii1t0V3XgkvjVnQlbh4cjZQzxCUU9DvIUGWVwHMqXHRc5WqC976F4Gzfl8DYh3TYusHxxruKzeQ9Uy6UD3toIIQGXlPb41XF652e8GKsCfFcnxwQhx/yNPGy/AOib7UIZ17xbZ+w02kJAcQ2OUfLXYuXxgSJ7FipgLqHUCOZ1CHh9oWfOnAcYsrIt8S99no8NDoafqosLyxsoEN/9uZWCTENJesao3GflQ0EITmxO3lCtwTmKBPeS28ximCyKhwIklSRAZ1HgxtxwVtlOfIIOGlbOd4FgsM8O/vV++/Bl47GW6aAPg98zI3fp+bnNVDUpbUOOqjKrGq/LqsmNxMRFRiAihPOVosl+ALCF4REOLGMhlsKjXIZvGUeIIK/7FPVmV72a3oBf
 RSr6jMF9
 6KR6St+kb56Hy6bvhKMAWV5WUfu2FHRs02TMA4brDFGh1uE+/Oh7vhpe9twKSKDZdljPAk4J3eGhz4KQiQXT9jWi2QNGfHLH+rJzJTbpPwMLAMRPMvGS6IOXPq5yGweFhk3qJMarCBzWcfSVmMELpg7kV/wTZWcEvddtX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.10.25 11:38, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> A non-present entry, like a swap PTE, contains completely different data
> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
> non-present entry, it will spit out a junk PFN.
> 
> What if that junk PFN happens to match the zeropage's PFN by sheer
> chance? While really unlikely, this would be really bad if it did.
> 
> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
> in khugepaged.c are properly guarded by a pte_present() check.
> 
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> Applies against commit 0f22abd9096e in mm-new.
> 
> v1 -> v2:
>   - Collect Reviewed-by from Dev, Wei and Baolin - thanks!
>   - Reduce a level of indentation (per Dev)
>   - https://lore.kernel.org/linux-mm/20251016033643.10848-1-lance.yang@linux.dev/
> 
>   mm/khugepaged.c | 29 ++++++++++++++++-------------
>   1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d635d821f611..648d9335de00 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>   		pte_t pteval = ptep_get(_pte);
>   		unsigned long pfn;
>   
> -		if (pte_none(pteval))
> +		if (!pte_present(pteval))
>   			continue;


Isn't it rather that if we would ever get a !pte_none() && 
!pte_present() here, something would be deeply flawed?

I'd much rather spell that out and do here

VM_WARN_ON_ONCE(!pte_present(pteval));

keeping the original check.


>   		pfn = pte_pfn(pteval);
>   		if (is_zero_pfn(pfn))
> @@ -690,17 +690,18 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>   	     address += nr_ptes * PAGE_SIZE) {
>   		nr_ptes = 1;
>   		pteval = ptep_get(_pte);
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +		if (pte_none(pteval) ||
> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {

This now seems to be a common pattern now :)


Should we have a simple helper

static inline void pte_none_or_zero(pte_t pte)
{
	if (pte_none(pte))
		return true;
	return pte_present(pte) && is_zero_pfn(pte_pfn(pte)
}

initially maybe local to this file?


-- 
Cheers

David / dhildenb


