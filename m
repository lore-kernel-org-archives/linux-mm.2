Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BBA6CCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E813D8E0018; Tue, 30 Sep 2025 06:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58648E0002; Tue, 30 Sep 2025 06:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F828E0018; Tue, 30 Sep 2025 06:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB18E8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:15:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CD551DC071
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:15:44 +0000 (UTC)
X-FDA: 83945510208.17.9558AA3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1765040016
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:15:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bO8Tu9wE;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759227342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=up1u54019EwCdgrq8WsvONApl5nFadyrMlaO7LoTmxw=;
	b=bQqaC9mFG1Ma1DYOSMpV3Q3S/5IzS6ixxcvlTc81o791wTve8KKPmub8dkN0nCpXTcd+CU
	wmt24QFQmU0BZ0C9sqvW5Miv7ld+pnGPB7zYESSjjN/J0f1LGRjbgkVVnD7dwgJijnwm6r
	+zayNQutllUkh4jenyevQxmFnAJ+4Xs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759227342; a=rsa-sha256;
	cv=none;
	b=raiQys7PnV5fSmFVTyMm5JqhXJqEigxMewNOhoKoUWuoYBEz6R9pcVpkqvmOZY7bZJGOUu
	vUTeWn9JKYuKQUplfOSKikW75AIW2XopaMizB4in/eidoHwR1upq9xmRvkMkvLbkwb/DyS
	iCjYu/wW1qj8d5ifZnQdQTXpU9OZovw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bO8Tu9wE;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759227341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=up1u54019EwCdgrq8WsvONApl5nFadyrMlaO7LoTmxw=;
	b=bO8Tu9wE9FcpOtU4wsZfyc3/t7DEKrJ2nHJmXdwR4xp6izGHIhLpFxot80c9kcAB2bHVif
	TZs6kqQur8e348qY7R6x5/kINk2OSCvQc1xBjshDI7Q1+PsSaonLY9oQNJKmTIa/KlymrO
	m4vCRSKIPaVDD1kOYKwepUg63oupcGM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-ni94QUdEP0GnPvrtez_mpQ-1; Tue, 30 Sep 2025 06:15:38 -0400
X-MC-Unique: ni94QUdEP0GnPvrtez_mpQ-1
X-Mimecast-MFC-AGG-ID: ni94QUdEP0GnPvrtez_mpQ_1759227337
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e2c11b94cso39922805e9.3
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:15:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759227337; x=1759832137;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=up1u54019EwCdgrq8WsvONApl5nFadyrMlaO7LoTmxw=;
        b=aIzN5QWyF39nCikHuLaGSxoZr7zl3JLHNGQh1gp8E9n/A4F512zRHs+4gL2SFCzZjE
         khLnZYS37dH9P5glasS9V+1G26gPNoeIntuq48C2+oEhMeANGxgjXdOumWovIJ9fd16S
         IKbGQkoQChzKSSF8He+eZlGx3/r2DsS3QJ6EzPgxXlVuzbgN2CXuN1wPTn9IoqnBdTTP
         DO4zbV7q2J9dJE+YFxYpf169Ef5j06g1SYaFajv3A3pt05sKcbbZTZQkZjb0nPDJ7H0n
         sl9XdMX32DQRl+69GaH5uUzgCm5RiYrdbOQ6iehQVtpE0ufgqZ+FIGaa05r5G4G4Yik5
         LRkA==
X-Forwarded-Encrypted: i=1; AJvYcCWAqjR0A6hivbnYcAS4qxEDbj4MYeS/fY1yOmgFGssQnysHkfrfB//ZfGlUvvlGywIf480Xu3zXhw==@kvack.org
X-Gm-Message-State: AOJu0YySytm5oDWAjWQ5ErT16K63wCZAdwbvKV2hPiMhGpAMaY4jx5po
	wvyY9Mk9aN9Wag0mAU4a8WD8LDCx1EoLujg8dh6CdUb2dUm8/SkiKtuCgYEPx97o7h3V8Aj29H4
	80gUx9ZBgALVk/iy0MCtuD7WXPvuz/jGVV4gw5Ki0dKveo0IzteHv
X-Gm-Gg: ASbGncs8KhWFijfYJt+CSWOOxiYb9NWykFOuNFNzyY7LyGwhY6bPC+K5yfuzR8p07s1
	SFzJB/7kTsrNRNnVeOWukZAinJEkucLfCv1kLIczZ+iR2he1v/N6V0Q7OOGDXUJZGI2DUS87meM
	iL57hDGgmrg4LlswH74gqgO4og2impbk3Vx4hKmIFFSOuam4sQQnB1toUprVxgjzBHad24qImOA
	Nc56DZQmXynpsDB1NkUgoATYsltOJd3uSh55kYFo8mO/E2UKIsfXbqbUzFWF2VuJeUSaVfMCEpi
	oCYCWY7dVtAMxRcEaAMS+nGHfHEOalx1NonqdMIomWoko2ZYa8os7toUO4+zfPD34d/9aK8377g
	VMX4cGtIg
X-Received: by 2002:a05:6000:2486:b0:3ea:6680:8f97 with SMTP id ffacd0b85a97d-40e42502e25mr17688659f8f.2.1759227336982;
        Tue, 30 Sep 2025 03:15:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFG77s9vV9w/KajwZ1DRGqWXlJ8pYe1J96XT1VYmKTmNf9Vm3/kAUG+BhBEnFwuFGMu8QGSA==
X-Received: by 2002:a05:6000:2486:b0:3ea:6680:8f97 with SMTP id ffacd0b85a97d-40e42502e25mr17688642f8f.2.1759227336516;
        Tue, 30 Sep 2025 03:15:36 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc6cf3835sm22210266f8f.46.2025.09.30.03.15.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 03:15:36 -0700 (PDT)
Message-ID: <4a4321e2-53bb-4fe5-988b-5b5eb57a855b@redhat.com>
Date: Tue, 30 Sep 2025 12:15:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/8] mm: cma: add __cma_release()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
 <20250918132000.1951232-7-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250918132000.1951232-7-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3AV2sWchX5m34j0bWa2p3VtkmOEdax4QH4FmeNeP-HE_1759227337
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1765040016
X-Stat-Signature: 3drz38y63zrek6xpu7dcagoa7h9reyry
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759227341-92971
X-HE-Meta: U2FsdGVkX18xp4zKrcgp9mu+6tVSNCRiOSsPT5AdoaWzhXbu9wc9/ppYMMQetI2VJ3PHgVoTt/CplyH0D7S6UeAJZJM0mOsij++rgG5sQ5YbA1MnjRzq1KZUIzfTYAjJE5EH2QA0vlkAWYVMPvjiAx4G7avkpLVFWGDLFLjGr9Ti+j1rWPUyeP1sI33XVDtbGv3XCOHd3v2DSgiyQ7EPo37VDW/LPbfHp4lTfuLWkNMMqZUEzlmArBSFMuHjfuO1JKjeYZX0xG+8vx+Xcd6ZHVu3jOErB47rgALo5FLnVp1mwEM7ch5476LU+dpO2AFZu2C9zF/bNZTYemNtmvlAqqEqyBGr0JxZI3Mlusqal/iAXC+/cw1+dvhTcY0Yn4V4uWfGZNH44thZ9GetPtTK4/rO74Tu3kS0ENXiJAbcthkVjF8t0T46avqMcuGfvihcnH4ffx3J3X605OcRqnFX14IBZZ+NtFkHlRJHpq890keHUza32IosZfMsfGsbSeBNKzYNUA9a/s5MdBIWqgxrqNP7bOFXL0SRwkolvFxKlZ2NazKzHfbslSRyMZC/Y/82syXzk6WBKojuK7b29h5QAeweHlmlvDWF2UfZreUR18Eted/UN9pMZBwEP3p946VW0Ag3sL5TzIdg1n7aENqdIF5K9AgKylS0AjfN1jL19tiXyOJ3LrQIrdcYx0fMGrY2AkzTzCLG/pLQ3XrkHL+omwTBJ3x4/0bk/kiKIIugqBngLJ6lwMQLiv+UQk8Rw53UDZXxsgVM+fvPe6NWdV+MFrOUu2sI1WAo510zOS5ed3fngLTL3ctNo769e9S/+wlAVlpC95m2lihngIcuHIDLQdt/9Gn8kPpeeYD9Z6Oad6YPencvBSsij6HqQRpW98M7KcsUF7ivx+x4QdznhI1DR75UoNkHYafnVc9Kx4U0pMI8nInneeOPb1XTWzjMFLFZ0F97JA1jQNkyvBZUP0J
 nkSOMIyz
 Cc3t2LlbbpmSezb9sth0oqd3dX5gqJDHAQr0i/XlbTGuq1ij7n/Ro3dKhYMxHmAwKtgq5R6TvahrbOwUQ0tJKOXt7J+ab2rdXQwi5jYW/8W83Pn2ziHZZkYTXjrk60pLffMq763TPjlAUs/1hLxWE5zscmqBrleGdDYTsqb9/l1aT5rwOW4QEpmF5AphVlqJLN5Cx62MKwzY/r2LX+Kdi4PBvbMISzqsFi/H2vQUNvofY1Us9XFlZuxtfxNDbAQxLjJNmm/EhSIzs4wlzs1hzcHZPNUaAtzmr71mIYhDgjW1euCQM+JPIE5sy0IaleR3TbGlzbb9O8AKpJHMC420kf7CJUBvy0DVGFJwcq2R6REOaImxkr7y+ClP3xIuZg+VM5wo7gqW/BjWvZk4yk0h4mNROC8eHHQVOdRsnXwHjZECMwSDX4EdQiXSnNHeLOWBWjwa18IHGsHoNvpS1DO1by2LJnFoT/pEw0zEG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 15:19, Kefeng Wang wrote:
> Kill cma_pages_valid() which only used in cma_release(), also
> cleanup code duplication between cma pages valid checking and
> cma memrange finding, add __cma_release() helper to prepare for
> the upcoming frozen page release.
> 
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   include/linux/cma.h |  1 -
>   mm/cma.c            | 57 ++++++++++++---------------------------------
>   2 files changed, 15 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 62d9c1cf6326..e5745d2aec55 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -49,7 +49,6 @@ extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
>   					struct cma **res_cma);
>   extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
>   			      bool no_warn);
> -extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
>   extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
>   
>   extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
> diff --git a/mm/cma.c b/mm/cma.c
> index 813e6dc7b095..2af8c5bc58dd 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -942,34 +942,36 @@ struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
>   	return page ? page_folio(page) : NULL;
>   }
>   
> -bool cma_pages_valid(struct cma *cma, const struct page *pages,
> -		     unsigned long count)
> +static bool __cma_release(struct cma *cma, const struct page *pages,
> +			  unsigned long count)
>   {
>   	unsigned long pfn, end;
>   	int r;
>   	struct cma_memrange *cmr;
> -	bool ret;
> +
> +	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
>   
>   	if (!cma || !pages || count > cma->count)
>   		return false;
>   
>   	pfn = page_to_pfn(pages);
> -	ret = false;
>   
>   	for (r = 0; r < cma->nranges; r++) {
>   		cmr = &cma->ranges[r];
>   		end = cmr->base_pfn + cmr->count;
> -		if (pfn >= cmr->base_pfn && pfn < end) {
> -			ret = pfn + count <= end;
> +		if (pfn >= cmr->base_pfn && pfn < end && pfn + count <= end)

Are you afraid of overflows here, or why can't it simply be

	if (pfn >= cmr->base_pfn && pfn + count <= end)

But I wonder if we want to keep here

	if (pfn >= cmr->base_pfn && pfn < end)
	
And VM_WARN if the area does not completely fit into the range. See below.


>   			break;
> -		}
>   	}
>   
> -	if (!ret)
> -		pr_debug("%s(page %p, count %lu)\n",
> -				__func__, (void *)pages, count);
> +	if (r == cma->nranges)
> +		return false;

Would we want to warn one way or the other in that case? Is it valid 
that someone tries to free a wrong range?

Note that the original code had this pr_debug() in case no range for the 
start pfn was found (IIUC, it's confusing) and this  VM_BUG_ON(end_pfn > 
cmr->base_pfn + cmr->count) in case a range was found but it would not 
completely match the

You're not discussing that behavioral change in the changelog, and I 
think we would want to keep some sanity checks, likely in a 
VM_WARN_ON_ONCE() form.


-- 
Cheers

David / dhildenb


