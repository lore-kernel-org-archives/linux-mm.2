Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B3A9CAC5B0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 02:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595308E0007; Sat,  4 Oct 2025 22:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56CFF8E0002; Sat,  4 Oct 2025 22:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA288E0007; Sat,  4 Oct 2025 22:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 395B98E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 22:55:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3A85C029D
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 02:55:48 +0000 (UTC)
X-FDA: 83962545576.14.5526D4A
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id B20F3100006
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 02:55:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UEQdsG6p;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759632946;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8BCNZ0lNV57EM+z6vT49MVV36oUuaBZsQgPJ0ih96g=;
	b=JYyCz0sF8IKTP6Edei0mpGDHpLwOudlPti4wKFE9mG16EXd8PMPZLVc03KNs2UwLOa1utY
	zlPOKtu4ZGqF/SqZl/vpe2+kR2Lgx26YxtXrMkYD7RFs6QdnzhXJqWjZ5e1bRmvNJ2UDuj
	nExRTIQo2IOcFeh3MrrEdrWUForgedE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759632946; a=rsa-sha256;
	cv=none;
	b=S7nbrBg8DoSnhvJWe4VQKM/8eS0yYvBABR3AgvWxlu16Urahw206c4C6lb8BZ8tA6GIR3+
	sE6zqdPqK+zCUe2XW0GtsmsJbY+XAcgFhH/7pNOL6MG+0/PO04R72lTqEPHqQyEcxx+IEv
	MK+5k5WfZkpfAMh62qR/wzO6LiU+Lzg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UEQdsG6p;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-634cef434beso8324671a12.1
        for <linux-mm@kvack.org>; Sat, 04 Oct 2025 19:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759632945; x=1760237745; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8BCNZ0lNV57EM+z6vT49MVV36oUuaBZsQgPJ0ih96g=;
        b=UEQdsG6pEZ/Jwb12WehezC+7lsC40K+R67JA73ofJZv29e2w8ULU3b43Yn9Acr5zQR
         X/pTyJxpCYaa+zu1IEdUAR1PpokS6GLIUMgR05WSLf9MymQRlCpUmvysVW7zm6Q+/GT/
         qHK1IAmOF1TblqKf/d6hhB43H47GgH/I7baECSuHQ8hs7ACJyGRi0EySAhU5jefQBnki
         GiHh/VmO55ssK9zqRX4zBJmLIdDsSpZpeO/idGplCh4WBjA1hC4M5MNeYekD+iwupHLf
         QaN6HxfzD38UXU9zl++3oJKVj3lVKFIvd8DtRlZwEJUdYkTMs+DWTVBgwI9m1H7NKGuq
         pZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759632945; x=1760237745;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D8BCNZ0lNV57EM+z6vT49MVV36oUuaBZsQgPJ0ih96g=;
        b=qcEHzdoorLUcCr3g5O+0z7x8zAMr07z0p4yGo4Xu3HPI4rcKhXV0WkME5jnx3cXFPX
         WMsyEhTelNcCHzt71PRXrCDLbi8TTpSz1ClwohUyXpdvFb9LR3ap/IpPKM9kRn7rduTq
         DhhPn8P8onGo+iNRuSge+MXWuNr8HQYFEROHGzUj+dpDFIDwPPyynfKhLv7tgvtN5Ybh
         vJU3joOKYYtsYJsVpWNbv5r6RImwJf0HyzUGo86wfh0sLaDYjMFvxCglTHmqNKhjihhJ
         FYCEoELj6gkFKS8EtFCDaaSZ5E6hYrjP/pqp1EsH2gzd1+vu/8/J/CpwaAoKBFvmpRsg
         gXWA==
X-Forwarded-Encrypted: i=1; AJvYcCXK7sK0sPQvWbmLWpbPcSwruDbLoOMExrFhZZinf3AS+n1nL9BywCcl8Eappez6SefK9lTk/w5cCg==@kvack.org
X-Gm-Message-State: AOJu0Yyajs08b5brDiMKbeMZcJSKiQkD5qVlFK0vgiruOrC5sDTo4Mfc
	4/EtvyXZM+aqnp5gCGqXF7RnHjbYgmQgGJsPa7AiqmBZaSuoUONcmJni
X-Gm-Gg: ASbGnctEoMEKV4OrG/N8hUMJ6Gu0WfM16HiUYXtD14FkidStlEUCrqqtkB607JqG/zR
	JG5kV6C+k3X6/Tui49Z06wrYC9ilNGiZ+ZuPhhf1e3qqWt+/moAKtUIn2MxSMDpL34oq/aAU/oO
	VvdVR5aaNeQnPNGGAOzXZJ8YEeU2xtAAVEWpiQDPVsKmZSEhlzj1zjC4AGChAYx8VbMntk1R0b6
	ubqssPNq8xSiA983nGfjlQuSpClwyewQp1/R0W3xibD93TWIvf1Y4qEHUMzsCOcQkdHsIZBPyyb
	HZTI/dyhuCXDjK1WEGGdD0A94KyROhXXUKVZjkMRTS5k7qCbd72yOByOsMConnacILuCyVmubyl
	L0+eBpVRsgiSFQ5GyuHgpD6vQMtqeYCMk1YeFRqIhQNskVUJe6mfcv4VE
X-Google-Smtp-Source: AGHT+IF4EJMW6MRY8RIO9e+n0hGlTNQW9SFLJJn+e/FP/UQUZFcLmdhdqGU2p+LdUMLECjEFc1ZvPA==
X-Received: by 2002:a17:907:728f:b0:b37:3d20:f35c with SMTP id a640c23a62f3a-b49c1974d9dmr951749566b.12.1759632944560;
        Sat, 04 Oct 2025 19:55:44 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486970b0c7sm854975666b.57.2025.10.04.19.55.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 Oct 2025 19:55:44 -0700 (PDT)
Date: Sun, 5 Oct 2025 02:55:43 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: use map_anon_folio_pmd() in
 collapse_huge_page()
Message-ID: <20251005025543.wumnymjkerg3srxq@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251004092523.28989-1-richard.weiyang@gmail.com>
 <aOHOaYG6gjnfrsmR@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOHOaYG6gjnfrsmR@casper.infradead.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B20F3100006
X-Stat-Signature: 1pzuga5x436cer4rhh69udwcxn8c89e9
X-Rspam-User: 
X-HE-Tag: 1759632946-279592
X-HE-Meta: U2FsdGVkX1+s8DBKAba4mdgD6qpj9e+42td/i+Bm9IVjxJcMPrHUyuc9ljOFIoF/8Wc3WKzuikO62QIxjiCMQSP3aNGmmAj8xTWJAoqZd6eY45w765TE+tJESmYg0tBis2qQ8XxmVHxPSSHwyM9I7NJREYCkbI+4yj/8lfCsUVgrSUYjz+jcsf19ZyHNwRPKnlvqQQlbKfhIO4LKC2UUiPNPoitl+o4Y62l8Kiwh+rmF4zslydq3dejGT3oGM4e/mQ/fJWk2GzzDC29MOrxfqmntIJClhpzs2A9mGSDfPIWpbvE5+rUPn05usCWSkXaJRv0DUEJrgMoWWyFcCr+P6MYXwxh6lSfBYi9E2unjo9Q/YG2zoHxbwcxfcq33tFzvgHKbmCfRHfqI1jSFF9uLbGMuAkLYt1b5juzCiflMsx929lKDGxm00mF5KfkFmoBiQ5ettjvLqimoOszNrcWnmnw7364mMTj1t28bqj7sIa/Nk36s7rPkI1Ubs2bti+yBo4wiYxF27PdprEnpmDgBlLBmH4q4Q8nIrQ2BYkkPs/9tQS3oseoP41DlYwb84GZl0K0VMrhjfdpuv+SOwQKZWu85DEi/SykfkFCpF73/Co7OA2+OKhNxwkrNZpxg5hSDFj7GfrZbr4rRAZv7QrUJd+EzlraIcX5h9efuah7k7xto5KAyXhmicE25WW3AgdxYI/3jCk57vX0hu/vISJh2o9e+oBvFe9jSbmmKf39WLSgMfMv5JPkEtaLmZCbJIFwzYN0CB0Z1bbldl06/qhzarDUSEOxy83HDXkeQ3OD2D80ZnO3dVq8dpGT2l6KSrcB8CjaE1BO8a0MjMc8cJTZdS3/U/Rq+avnj6e021Jxc8eqH+ljm6PchUKEG/SW4VIbEy6NHQYre1Rnq2HRxnoRQ/DCnNjbG8RN/+0f3sIuVDsSiL5V0TTXDQ9jitBSMJs7vK9lliQfOm7fXh/Ukm37
 wOxCZ4bp
 8tx1I1fVm+qJTAsILbCfMO1gPQFbDiBsBaz67DpRc+eQnLI0GdsSIjCn4dhSmI3WoO+wbTaXjqtElCPPVNLbwOfJwkfveurA+N8OXE4kSZl314A+PYg0bc6VMzSlaZgdgdRgqtrbOMaqd5lT4Ah7S1SdwAsmZvymHZ1d/ieIiFRbdPmBUwjxCsq1mbhmBekz7KLL+jPQFXnvcz0+MZAZvvflccGinAV37yZtajdBMqO8pdrbA4poAroaf/bbG3I1L1Cf0o5VNt/LLg/UhX8ixPGHwRGl3HQiwQPwv+rTeD8cixPIgUeD0Kf5r8vQMHhC4mwlPLeqgK9pmqrEnqxkpsn4YjOTt4HFGwVZNLW7Rto8ZVnfS/xhIcW8ftE3+KhBP9jSorQwVDWgmETM3NujjXz/1Yt8vqLPGMZnVjpReF1Hlktmk2IirdBQQ0EziYrxhxEAPGMp8CqXTzsPgor/8UTbvN19Z7I4/emff6cPSs1SseFoxi9zoXJWozDq2M4Bed5lbiFqqusTg152g/ygPYZKro2j2DFsSl2Xd/7bysGKqUIT75TYCGSWgjx/bi41eKGSikLhLyjK2ytrJA+wNvprNjS4cFLcQwrneiq6X6LcjG9SFjyBb4X5N57vuutzstfvS3rsW4UpQsii8V43YBFWj0+THs6+KMi4ZftZ943nZ2mwmFDsCZ+C/sl1gUcqgY7qLBjsXM/Rnlduz21/0VKRXylGyc8CITHqGkUQ0UIrFFDt8cIVl3pe8HX/WhibQaNpU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 05, 2025 at 02:48:25AM +0100, Matthew Wilcox wrote:
>On Sat, Oct 04, 2025 at 09:25:23AM +0000, Wei Yang wrote:
>> +void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
>> +		struct vm_area_struct *vma, unsigned long haddr, bool in_pf);
>
>It's generally a bad idea to have a 'bool' flag like this because it's
>not immediately obvious in the callers what 'true' means.
>
>> -static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
>> -		struct vm_area_struct *vma, unsigned long haddr)
>> +void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
>> +		struct vm_area_struct *vma, unsigned long haddr, bool in_pf)
>>  {
>>  	pmd_t entry;
>>  
>> @@ -1228,11 +1228,13 @@ static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
>>  	folio_add_lru_vma(folio, vma);
>>  	set_pmd_at(vma->vm_mm, haddr, pmd, entry);
>>  	update_mmu_cache_pmd(vma, haddr, pmd);
>> -	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>> -	count_vm_event(THP_FAULT_ALLOC);
>> -	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>> -	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>>  	deferred_split_folio(folio, false);
>> +	if (in_pf) {
>> +		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>> +		count_vm_event(THP_FAULT_ALLOC);
>> +		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>> +		count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>> +	}
>>  }
>
>And it's really not necessary here.  There's probably better naming
>available, but a good pattern to follow here would be:
>
>void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
>		struct vm_area_struct *vma, unsigned long haddr)
>{
>...
>}
>
>static void map_anon_folio_pmd_pf(struct folio *folio, pmd_t *pmd,
>		struct vm_area_struct *vma, unsigned long haddr)
>{
>	map_anon_folio_pmd_nopf(folio, pmd, vma, haddr);
>	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>	count_vm_event(THP_FAULT_ALLOC);
>	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>}

Thanks for the comment.

Will adjust it.

-- 
Wei Yang
Help you, Help me

