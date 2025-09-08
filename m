Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB061CAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE208E0005; Mon,  8 Sep 2025 08:11:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E578E0003; Mon,  8 Sep 2025 08:11:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C564C8E0005; Mon,  8 Sep 2025 08:11:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD5378E0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:11:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14D5214012E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:11:53 +0000 (UTC)
X-FDA: 83865969306.25.974FD4C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id AC7D9A0006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:11:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BD2nANK/";
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757333510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2jdiX8cmz33Wge7GjULKTSlElQOy4rRPNl1+9C4dPY8=;
	b=WEr+ePy05EBCrhzBuslqCHwpc4v7Y6XSy1qVmLJH7ESVQW9oeTDV0NVc+xJbIu7ku57gdH
	/gdFFZy/WJ3c+JUstaSsz5qGtk1lLa81J+cBJ4U/TtW8gBRUjTVevTSsiZreUT2QxL18Q3
	XIamRcnHPQEbzeFYaSS+VyIz7t/oh2I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757333510; a=rsa-sha256;
	cv=none;
	b=kxTYJgj3jYkJJ5bDFsZVIJRZQ/gogSoLMPxNhoDO7jP3k8C9p2/cIHxBuaf4TsehGCgY60
	x+W9vLmtez2g4joiRosMsBYdV+rGDZ/FSub1diGl5ANbvptNK7e5kadVVMrNj9A+CTY8ob
	ciK26KyIeT9N5Df/4/hEnIdlz6fupE4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BD2nANK/";
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757333510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2jdiX8cmz33Wge7GjULKTSlElQOy4rRPNl1+9C4dPY8=;
	b=BD2nANK/Z/abuaE9R2k3id1lWvIEwB4A0qTIpPco9wIqGSxLOxzDqc7FaA9xd9Qfw/sQ0D
	Hi/nCm95iG2mUvG7ncgtWFy5g16fMOwzbqWrNBPDWLU8Q3f+6ZrfwFuxF6+mPGKt+ikilW
	RR9kzKUUw+Wu6DlFV5eOqhb1NySCN8A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-PUSZOkIwNQKNMjpFlqHssg-1; Mon, 08 Sep 2025 08:11:48 -0400
X-MC-Unique: PUSZOkIwNQKNMjpFlqHssg-1
X-Mimecast-MFC-AGG-ID: PUSZOkIwNQKNMjpFlqHssg_1757333508
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45cb5dbda9cso27056815e9.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 05:11:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757333507; x=1757938307;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2jdiX8cmz33Wge7GjULKTSlElQOy4rRPNl1+9C4dPY8=;
        b=b5SjCHjeWXBPA4ITI6fViJzXyew5ZzOLQ2Eu1N6KmdIQ8jlIR25ne22IKz82Gkrkbi
         zFmCSrnufTsGU2BcMHqef+9G93vPWcuyQF2AsioDM9elkoUGrYIyQS6juJENLZ9g9G8A
         wUy5rwnPR20WRB9Mrup4y/ePcfNEdjgNcubc9Ymy3i1sWEb5jBRKoBR+ZrG8pjNcV752
         BisnvVCBl/HA9MdtsFUMI/fxz6GjWU4Dpt38wizwiY08jj/rJgu12mZ6ROUIVk83ZBVT
         jXDJFPV5dvaCMvgcEKx/IBd3TN2SNf3wTItg1DXm9y/k+1ca+X6sjqSB4t/A+CJHZISx
         clQw==
X-Forwarded-Encrypted: i=1; AJvYcCXA6yXe12ClERzCpfSacRC9fP65fhsqivboMB99xs/PXC7INPQ8CsSsiA99J2DjjFqXjiVdARt7bA==@kvack.org
X-Gm-Message-State: AOJu0Yx1eigGFdzS0sT41BD1LHWiXZLQxx0R35ASYYODeiJCLMy2XrrQ
	3nnemG/TDb0paNbmWid+tO9nAjiMPep8VgFwAcs/XIZwTQlWw4QnGgYsowS9FAn9rrGVp70MjDo
	0NobtUNhw0yA2h8ubmRlHECd3X5yMDbqt4Bqta5RMQRBM5Z0KVFLz
X-Gm-Gg: ASbGncuBdelIv6CY6VC4eIQ1CqLjU1Mrz5JzBOpcRCe6iL6JBSmMUNlpQB2XjSOT4lg
	FXCRtxuY9FDCpb0BBVUsfeAFtsT3hacEesTeq0ojLClkQkc9UhHRBEltWp4jMTdT+Cga+WpwTZJ
	EzdfYURyYtY/zP9/ugKiZsPWMhXc/Nt4NM8YGk5zq3H+/79fAs7nMaSrPpcpLyXPy3aNIHrOcyO
	ShVuDQ06SipfIATWwiG1YkTJCw3xstCEyMFt9pioMYoVmCRs70n06W2ymdkQzo7pfjhNoDkLSyY
	HpeVhc6VA/1BzvEuSrcK8tUA7McDKkmr+8uz6NVB0OIvaMdPwrYPDTYJQxljieBtfuJho01T69S
	eo61DRvDz4oKiC9Tu+T7s900GVOBDd0WLgnUiy85o0xq1X41VuwJu9L72Rj+lGoNn
X-Received: by 2002:a05:600c:a47:b0:45b:6275:42cc with SMTP id 5b1f17b1804b1-45dddeefa72mr65846385e9.28.1757333507671;
        Mon, 08 Sep 2025 05:11:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFaf4eOc85QPP9D7Vpk6e+Udi31BlmbPwrs+IAuKckaQTcUAkvKTJbOWZ69fZd37sZP1st7g==
X-Received: by 2002:a05:600c:a47:b0:45b:6275:42cc with SMTP id 5b1f17b1804b1-45dddeefa72mr65845955e9.28.1757333507230;
        Mon, 08 Sep 2025 05:11:47 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45de15de2b7sm82239365e9.14.2025.09.08.05.11.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 05:11:46 -0700 (PDT)
Message-ID: <bd8338cf-6723-46ef-9043-3ced8be56e62@redhat.com>
Date: Mon, 8 Sep 2025 14:11:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/15] mm, swap: check page poison flag after locking
 it
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-5-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250905191357.78298-5-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hyHJz1CZXiTBxM1cAweh1jBpHr1v4z0-42LPsKV4ta0_1757333508
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC7D9A0006
X-Stat-Signature: s5zmu8tu1eeu7bj9b4xqg5qkbmprxyt1
X-Rspam-User: 
X-HE-Tag: 1757333510-372934
X-HE-Meta: U2FsdGVkX19ClUnQRHXOK9oPa+UfUYj862YnZrXPnbxYjq5rubtI9w1NwiKnPHpxNMXVlP1rkB+LCT+QjYmyXvxyK1wjc1niU4QLqMuMGQq0SZcJ/T+K5VB3gvRXTZV7dxAd3345ns2RGhP4GWjxIsr9CKtc+SCn8Xb0NLnQTB93sHtqpe+cwXgE275PVU4zM3m296fCaE55IlpkX8rCM5jZwgOs9dPGVnbGkvRjnnq5zjhhX9XPvItmKm1zB2BDdiNMUYLP1UOYI5NjuuUEDNvBp85Equy+S8I4IL8uXFcYFdu8tyEB12fZe+/5OJK/NgdybMq1q3HXVjim3sFdxOSTbnbwnhckEtXCLh0pVcCsdY59zAcKsHLesJfGQ+/GmMuGlEopdEktaDjuaYkvPJsR14ziuXN6hp/DFf0d1a2btdkEEm+7ar35qP0Bnm2ac9JZXmkkNJVjyAsk6dgOainnKbG3UsGYkNO1kKa6EPIkM57e2uiKAxaBUq95EELhqYQm2SU7J6Z6rMXS3nACDxIIO92RV4tV43zWKGyVow8fAP7MNY4fJaH6ZNat/GCEPyjKShvfvPsmpLqz17UuC6dMCa2gD4qZ5xiwITDNQriCa3IQd0Q7Fw4I+LUzgs5e9Je17QA9vu0ZFtwbCHL+5PtXdpW6CM6NvqF5qOX3XSbC4/B6Jyh+QEYGbNHE+j6KG1tCG74ZtBGTbBENkzdJLmmf9LZHmkLKMRa+8MaGaRTkFmoEqVUsmGvWIr52psbioomrEvqhpo5AzZxmbWC1AmhqYD+MAdjRkiGEOX6o2esNh2j8RfNs80C221wAjReS8mxbSiYEYmxwkzqa8AWZzT+9ExFoNgJhCHbgHaZXXhKQyrp08zXV0IY6afBb+X1NYIhlfPoUhuOmefphIRrYcvuj2Xpj/lc1dQjPwBwrZp9A0OLXbUub4YMgR87IwICesAvB64+jQPIt1DVUGJ1
 EQ7SkyaB
 ydDr/yCdcUVECfRNkb8BDHozrmJxXqfEI/lbwGTKxaTkNmAdYlB448rjD+d1q7VXxfM7wBYpKWX5Tl6fMaa1kvkF0NY4hsMLBzWVCVzeNDqwfA8f0K4OWuz3w73uSza85IrMwG7lw0Ul7PLDOuYwoX5R5Gj7bSbnNB1uFuGUAeZvCHLHq3mPhBCnq7w1HbWBFVgNtWPmGlkTjYh0+xHKVeaRzkJy9+K0PcbHj/c0MbKuFd+uwDqFLPA4Ou/hAHhW1hWRXkk1Wr6FARjjz5sRWEn/933NF6zcX80W4g1cTCCCKQYdlD2z7T2ezhAgpIMDv2DPfPjExl9z4hy24ZUT52L5DThm9sJIMm1EfRS/HXkkb1TxZ6jYthZHdVsOYNjwppsa1XSrq2HaK+jN2FZJqBw3ONaRvCS8mduHD7s8GhRbAI5Q1ZdveDK/Unwd5m7aVsuhoBuR0l2twues=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 21:13, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Instead of checking the poison flag only in the fast swap cache lookup
> path, always check the poison flags after locking a swap cache folio.
> 
> There are two reasons to do so.
> 
> The folio is unstable and could be removed from the swap cache anytime,
> so it's totally possible that the folio is no longer the backing folio
> of a swap entry, and could be an irrelevant poisoned folio. We might
> mistakenly kill a faulting process.
> 
> And it's totally possible or even common for the slow swap in path
> (swapin_readahead) to bring in a cached folio. The cache folio could be
> poisoned, too. Only checking the poison flag in the fast path will miss
> such folios.
> 
> The race window is tiny, so it's very unlikely to happen, though.
> While at it, also add a unlikely prefix.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/memory.c | 22 +++++++++++-----------
>   1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 10ef528a5f44..94a5928e8ace 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4661,10 +4661,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>   		goto out;
>   
>   	folio = swap_cache_get_folio(entry);
> -	if (folio) {
> +	if (folio)
>   		swap_update_readahead(folio, vma, vmf->address);
> -		page = folio_file_page(folio, swp_offset(entry));
> -	}
>   	swapcache = folio;
>   
>   	if (!folio) {
> @@ -4735,20 +4733,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>   		ret = VM_FAULT_MAJOR;
>   		count_vm_event(PGMAJFAULT);
>   		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
> -		page = folio_file_page(folio, swp_offset(entry));
> -	} else if (PageHWPoison(page)) {
> -		/*
> -		 * hwpoisoned dirty swapcache pages are kept for killing
> -		 * owner processes (which may be unknown at hwpoison time)
> -		 */
> -		ret = VM_FAULT_HWPOISON;
> -		goto out_release;
>   	}
>   
>   	ret |= folio_lock_or_retry(folio, vmf);
>   	if (ret & VM_FAULT_RETRY)
>   		goto out_release;
>   
> +	page = folio_file_page(folio, swp_offset(entry));
>   	if (swapcache) {
>   		/*
>   		 * Make sure folio_free_swap() or swapoff did not release the
> @@ -4761,6 +4752,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>   			     page_swap_entry(page).val != entry.val))
>   			goto out_page;
>   
> +		if (unlikely(PageHWPoison(page))) {
> +			/*
> +			 * hwpoisoned dirty swapcache pages are kept for killing
> +			 * owner processes (which may be unknown at hwpoison time)
> +			 */
> +			ret = VM_FAULT_HWPOISON;
> +			goto out_page;
> +		}
> +
>   		/*
>   		 * KSM sometimes has to copy on read faults, for example, if
>   		 * folio->index of non-ksm folios would be nonlinear inside the

LGTM, but I was wondering whether we just want to check that even when 
we just allocated a fresh folio for simplicity. The check is cheap ...


-- 
Cheers

David / dhildenb


