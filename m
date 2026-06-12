Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACAC1CD98D9
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2076B0005; Fri, 12 Jun 2026 06:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92746B0088; Fri, 12 Jun 2026 06:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D81CE6B008C; Fri, 12 Jun 2026 06:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C62166B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:21:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6CD9B16577D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:21:12 +0000 (UTC)
X-FDA: 84870867984.30.591DFE4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id CE4F640007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:21:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=disWk0I7;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781259670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JGyKIDivNLUz5KIM2/WPEeXj86ogPPDaiz1Q78T2QNk=;
	b=kVD1wEUCm8eQG9JE9wrZQuj4blL2H0aExXWXeLQWPFmIEJWK5YPUKbEtZ2lNPJzW2kvQME
	TEQ9ZYTm81BoEPpBUG5bROxpY0uWf+/i7UCc6N/ZO1N0TKgh4xXD0OVAhPBqM1M+ZKQH35
	slmXy0kD3rVQMaruXOzB+jO01IFhqe0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=disWk0I7;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781259670;
	b=RuUna9X7nqo6XqU+WugYvNLqK+3ctfrWAoo08nMXyk/pZe7Rn569L1jb5nD9MLr326CEAe
	Fjnj7lJwoxKhxF0EhhkW0UNE4cXw6TbZvK8ZOuLPJVwMjg1txT5lDN9JUYKbc3d4XM0Zoi
	zvkxeJhoQwkYtTIOIKOKZlZq5+rqic0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781259669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JGyKIDivNLUz5KIM2/WPEeXj86ogPPDaiz1Q78T2QNk=;
	b=disWk0I7/FoRu0YM8hFj3tkiATBI7oOO5Xs+OCOpHXY7Ldes9aj4mUNgb9y659+xWmfoTW
	yqPH/4Gfd7YtxOZ1inwO6DhuzUB9hIYknl4s4UcCNZJQhv3vws8SAM+eoxNmAtQqlrlRH0
	bsgjgTHKkyy3gaQDlPBeC3L0q3fNShg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-xtOqfJXpMTqp6dJ9lnDU9A-1; Fri, 12 Jun 2026 06:21:08 -0400
X-MC-Unique: xtOqfJXpMTqp6dJ9lnDU9A-1
X-Mimecast-MFC-AGG-ID: xtOqfJXpMTqp6dJ9lnDU9A_1781259667
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4601c9b630fso408987f8f.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:21:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781259667; x=1781864467;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JGyKIDivNLUz5KIM2/WPEeXj86ogPPDaiz1Q78T2QNk=;
        b=Wxw3co/uqeJHm5sFSApYdAnUvhqtO2ujpL20biRULqjuTbrAbT9CZ3h2Mnpbu2Gq76
         nxvwG2iIz208v53wQlVriDzFdzUFOa9UUEU/Y81wyaR5rxK9fzxaA1LyLCr+mLbsU7W3
         4st2LL58zyovthZi3rtUkjRR7CV2srgPF3mfALqXftHRvtEgnVLhsvcvqIiJDCLdT+bH
         xXqbXmtIb5QMy5xYQxte0WzIYcNyklWOlxcyS9HcBAJDckRzP6+0mAd3NNzI48tAA59t
         aDTeCrSQjOLathT1hmjaGTz4V2E6WSWrMQQXiQVTLHXhmnx9/0fT8hzj7U5qUEmcpC+/
         OgRA==
X-Forwarded-Encrypted: i=1; AFNElJ+h93x9Fp1sc3qMEOIvtCIMp2+7F+CAzzPh7kYqVZq1D5fHiGWAZ5aS11unyNgngKl2dR3ulNLS/Q==@kvack.org
X-Gm-Message-State: AOJu0Yx1nNfGyab/pchr6yGpD3WAY6HKGexbenGNSafty8KcOvHSTPFD
	0myz7KeKk2HNQQ0Wm3kRLD2vSPBb1jtoi954Ufq6arNDC13FI8n0tWFT4pHCiaCjjPiTFs/nwyB
	qf0bl7qhK/ECu/Lwm0mGNeNzeIWQ9hc8zHfp74bmUN4yi+vFHhqRj
X-Gm-Gg: Acq92OFm+sljPZJxMXJ8scToyIdTjPEt9vCaOPbgOhNNqzzI4KLjxOMGJmp8ux9pJ+b
	EAclinJ7EFjAt08Wv+AW42/SdXkCHxXo47ZhsW6BC82d4XJmS5vh0fe9i7JxrtMmM2cgv0AEJIy
	88CKsvUNJo2/qjXOlIArpF+LE8N7Dekt5RuBUmj9qwkZzcDrD+3Gn6TK6tFcfAp47I8uJ2szbku
	XKatJyA1NjY1lUsAg/PbGngyfvw+2hrpMG3N877whFfCqrCLkQug7if0H3jkhppZbaEsyDixDqY
	P7HTGWtEnd49T0RO7UZLfi/QcxfGpFHzfh/3qFMULoOnSE3pQx4FhPWDCcXrl4FnSWAlxrc6xx4
	O4T0yya8kfyUrYVswPWpkAtDYePuDvmoPEdFoy6pm4Nyj0n3amrmEQXRWsuFSdJmV
X-Received: by 2002:a05:600c:314a:b0:490:bcc1:4edb with SMTP id 5b1f17b1804b1-490ec504eb5mr24369595e9.27.1781259666859;
        Fri, 12 Jun 2026 03:21:06 -0700 (PDT)
X-Received: by 2002:a05:600c:314a:b0:490:bcc1:4edb with SMTP id 5b1f17b1804b1-490ec504eb5mr24368835e9.27.1781259666305;
        Fri, 12 Jun 2026 03:21:06 -0700 (PDT)
Received: from [172.31.99.182] (91.red-83-48-118.staticip.rima-tde.net. [83.48.118.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea7c871dsm61873325e9.5.2026.06.12.03.21.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 03:21:05 -0700 (PDT)
Message-ID: <443feb66-94ab-458e-8cd8-0ad440d0d067@redhat.com>
Date: Fri, 12 Jun 2026 04:22:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 04/11] mm: khugepaged: add shmem mTHP collapse
 support
To: Lance Yang <lance.yang@linux.dev>, baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <3895c09794739bbfae99d9e021ffacf8a51fb8e2.1781083630.git.baolin.wang@linux.alibaba.com>
 <20260610124416.46522-1-lance.yang@linux.dev>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260610124416.46522-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7PCMdD_Qm0MjsBbqvjOIMhylBzEVaZh7noI_RwzeFGg_1781259667
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CE4F640007
X-Stat-Signature: do871k7y4dbwjxoxyd4x1ise67tos5b6
X-Rspam-User: 
X-HE-Tag: 1781259669-988000
X-HE-Meta: U2FsdGVkX18ZSHySjvv2aaYDeaAAZ7ybsRaGEbcOz0rg+jjlZcDKnll8M/eHoJ3eQJc+cR9EsyE64pCuizDTC2dNSeRdjo86rPo+cEZuMCAjWuWdnWMjE4D047GfaKTlr1Sv5HizmyLi+4MakzhrjOaYZArMIhaMML0MUsAisBm3VIzqVGcjSRqmU832A2abRELfsRLQAVZSIzOAw/YfyGcyzeaPZfZQDxa3+5qPSgwAKpS20VIUo4BDHUN+ivCLnatnOGfS1GbNUeiYtNFop5dUV8QSd0ExnLLW4X82C7uEUGAa876TdW+oWYg3ySaWR7YDZpO2XKI9+y1iP13E0rurcCVTFry1JWpmhcoaUKnbOmU+D9I0MZhYsmGuaInDPO7SLHNepgo9NbZSZLtXVPpclWvN8tUoOhLd/S4uGRDfP0pMVj+UNqyXEhAxAQSQUIycUHWAMwFtNyTMq62F61GNBNK7fM17q6FsZE0lAc3CykwOmh+0l1OaGey+Kge5G/k9xbC5n0oZ/ZyZXndbPftA6z+oHrVF9Wx9u883Q/uznChwZ5se8GcCRaUSNwoXkSWb36fL2v1g98+CjBaH+v7Q2D60agKIgYdxAd8T0X1MydpH3wVNsBrMxRMIM/5TdT24fVz6t77k7I5tPKbVQcMINw1f7CSxwB9udsCAPqoZ7KqFwLQT8zNnLV/xs47nX6ZPwNwARfeVgL1V4PSzb/kHVLvo//zzk3W+xPPJLmt5AQYc7hlNizefQ3ZRCTKLkVM8jTiCwG1xGWer3vQ5JY0SUvfp2YcxNCnMqlI90W24n7lpOzipFFa8ifcjRMoBR64DpR2h7o+1coiS0JzNKaD+FNIxAiJ6LX3NGU8htnE8N2h2uayrx6I33HeJxN9PF5rNmbmoa6N7dVaE80WXRBuoTILgOvH0mTcD+NvA5N7tplaVybFJY0iqKPE8AkfnJ9X1PMz8qTW1TEWWokI
 ZKEsJ2gE
 L/jWXJ78+oAuHU1DNH/r6/6DmraP2wrWbsnhDViUp8X5QVs+DEY96mu/TW7QshT0tP047NxN3ul+W37ulBNUIPO/Zxa1buHKDIfcCOUcUxF0QR/POowu7NdpGbh+ntpca5NV9P+0ZkrNGcDhhVw8X7WWPn4FJjqWGAimm2MXnxQTKwXi2MBszAz7jjNk9811WbZOZkKY5MScYXJxxFVuWbatrDPZvLdJSOq4m+HL2ln1ZXLdyN+SST3avAC9psmsrqK5qQCk1w6mmWl//FwtDDhvDJuTWh+eyXfBZdvsY59CvfmTOVXv9Zaet0yf3v70X4/4nMxUCXLwa3t101o2/fG7fCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/10/26 6:44 AM, Lance Yang wrote:
> 
> On Wed, Jun 10, 2026 at 06:29:12PM +0800, Baolin Wang wrote:
> [...]
>> @@ -1512,8 +1517,12 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>> 			enum scan_result ret;
>>
>> 			collapse_address = address + offset * PAGE_SIZE;
>> -			ret = collapse_huge_page(mm, collapse_address, referenced,
>> -						 unmapped, cc, order);
>> +			if (file)
>> +				ret = collapse_file(mm, collapse_address, file,
>> +						start + offset, cc, order);
>> +			else
>> +				ret = collapse_huge_page(mm, collapse_address,
>> +						referenced, unmapped, cc, order);
>>
>> 			switch (ret) {
>> 			/* Cases where we continue to next collapse candidate */
>> @@ -1521,6 +1530,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>> 				collapsed += nr_ptes;
>> 				fallthrough;
>> 			case SCAN_PTE_MAPPED_HUGEPAGE:
> 
> Looks like SCAN_PTE_MAPPED_HUGEPAGE from collapse_file() get lost for
> the PMD-order case.

This is kinda my fault... I reused the enum PTE_MAPPED_HUGEPAGE (which was only
really used in file collapse) when reporting that a collapse attempts is smaller
or equal to the current order of the folio.

if (!is_pmd_order(order) && folio_order(folio) >= order) {

I will change that in my follow up to use its own (or a different enum).

> 
> Previously, collapse_file() returned it straight back to
> collapse_single_pmd(), so we would run try_collapse_pte_mapped_thp().
> 
> Now it hits mthp_collapse() fitst, and that case just goes to
> next_offset ...
> 
>> +			case SCAN_PAGE_COMPOUND:
>> 				goto next_offset;
>> 			/* Cases where lower orders might still succeed */
>> 			case SCAN_ALLOC_HUGE_PAGE_FAIL:
> [...]
> 
> Cheers, Lance
> 


