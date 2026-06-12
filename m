Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A812CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E17D46B0005; Fri, 12 Jun 2026 06:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC80A6B0088; Fri, 12 Jun 2026 06:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB6B36B008C; Fri, 12 Jun 2026 06:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6DFA6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:15:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CDC81C3AB1
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:15:31 +0000 (UTC)
X-FDA: 84870853662.28.26F62DC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id B132BC0003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:15:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=REpdeJ1W;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781259329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9oL9t7aTdvBdwHJhOiFeypombt3sG9Uz8AxyHsXUhg=;
	b=d0e7P/p6Grj5APOCH+cPpLnmEzP4syTCbfv/7zW91fMG5PnGnv2r4BWSM9PMf4An92L9T4
	SNkJGSxmbykv/BR6921JyLIY4xxR+Tqc4VAvi/Bpd9QtaLBtz7VUdaEhWA7NAW3lPt684n
	rp2SaTIBfeMotaPa1eFtrjaYTxLFjGU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=REpdeJ1W;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781259329;
	b=ijw7Mr0CT1SqBQ/R3AP0QweFAEc6ppIaQTBkPbJrjcX4m2c5762W4E3LxtdvwsjF79u86D
	wuYPiz09dVfocZkxlLOgY3aJnkKsl5M5FIdn4hDDiZ0r9Hnsw8hsaR+aefbP3aKHMIo+b/
	DszNMNaaJqNbSGdTQOiEttyUoG8+AQo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781259328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i9oL9t7aTdvBdwHJhOiFeypombt3sG9Uz8AxyHsXUhg=;
	b=REpdeJ1WnECOjsQxYxaxfsW3mZKHydE6jE+LMHZeryNUEzISMkbs5A/UunsFvriQ0FP6b7
	Ct/1QrlRp+hPm2CWtcYv9JNBYR3N+XLWYkh+Ek8WgJUuP0fuH3Y7uZZzb4Jvin5KI0yPTQ
	dh33GSrnEoXVuswyP+eOTY/i6Ze6dY0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-nDvJYiQrNcq2mSUZMhCrUA-1; Fri, 12 Jun 2026 06:15:27 -0400
X-MC-Unique: nDvJYiQrNcq2mSUZMhCrUA-1
X-Mimecast-MFC-AGG-ID: nDvJYiQrNcq2mSUZMhCrUA_1781259326
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490afe64f26so3841185e9.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:15:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781259326; x=1781864126;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i9oL9t7aTdvBdwHJhOiFeypombt3sG9Uz8AxyHsXUhg=;
        b=J14yKNPYtmxIVqieyb+6m+jz35AAiwJVXMjdyF7h7PGgXPYJSnofzOEL2/VPUc78zt
         732PTYWi12H8oO4oQDsMRNeSWNIQ2tSIx7324GTBhgAaYTQtVtI5UmvZd2w1rbrPqUTS
         rfi95BxEISMAAofvUGL8Hvih3wBxE6dzdkKzUlXkpGe5fJ64efou9rv2DZBB1U+8FuNe
         sueDPtrUqEcx07Pd1w9H8e+XXIQ8Fy4UYul3wQBlocNpZ6kXF+jPY30f03XWa7KTtPEx
         RIaTzb0LjYNc3AjbMXngAZCmc913OKsi1BR70vdZaMwOcpucAvCm8TJK00N5YqAA8E4L
         00PA==
X-Forwarded-Encrypted: i=1; AFNElJ9lUGpSS7TP1bPexPD3HRxiwOZ39hI3tx2lo6Xgab3gB2cqcHfB/zIMyZS4FQrdBEW2s7+7S0NO3g==@kvack.org
X-Gm-Message-State: AOJu0YzuKuRcf1hpnaBl9Zm/RC38WnPwt1PE2Y2W9Mq1uoRTDkStwvEL
	CAScZUXafNMT/CJuJdKVKXeRqPBb9Cc4fVx/N3IQZ7N4dZR8zg+ZP5e71nXKM/gvAZikn9Kw/6a
	OvjeZYsOBXKqmFwWmAJnWCBuDWS1usgKmVCyuFicfyctolwfSOIEF
X-Gm-Gg: Acq92OGHtnjd8sIY9cfQJgd0BtnjPUA7FsEJ3XZ1GHa/HtuJDO1q9zbDBaMXpS2imYS
	RYqCsdHQi2PZKtcEqFPgq4SHuSfkL5+lWEVaPz5xapYBOTgDfCt/ehu5Z/4tuYOe2yae4sD8zX9
	PP/is5Z9SZ4Hz6GjekL62A/TR02dt/KmczuOSMpYtY6kUL7zAIQvLVJOgQZpmGZoi0EZhfIP4l3
	O+DNWyq2QfTpS/xb3NkTk7/eZVsnBCA3alb4o+YSQt0Jw5ay+FsJOXW/1DBIfQMhbSWW5lSd3vn
	VEphAWcS3PvB76LNQZDjy75IcqCAlZSD2skI5P9aBKNucgtFdb85JTnQwi/gDUdqyY3AsJEZpbE
	SM7pqRNpuxeQIDYF0NT3adlQpUrp90/VsgksGF50a6Xyt9V6i+WZm+ZEy/ZsX2Pca
X-Received: by 2002:a05:600c:5954:b0:490:3d3d:805a with SMTP id 5b1f17b1804b1-490ea9dbeacmr20508575e9.12.1781259325659;
        Fri, 12 Jun 2026 03:15:25 -0700 (PDT)
X-Received: by 2002:a05:600c:5954:b0:490:3d3d:805a with SMTP id 5b1f17b1804b1-490ea9dbeacmr20508265e9.12.1781259325147;
        Fri, 12 Jun 2026 03:15:25 -0700 (PDT)
Received: from [172.31.99.182] (91.red-83-48-118.staticip.rima-tde.net. [83.48.118.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f309sm4952894f8f.14.2026.06.12.03.15.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 03:15:24 -0700 (PDT)
Message-ID: <5eba8380-6fbc-4c0d-b267-cd39c24ffeea@redhat.com>
Date: Fri, 12 Jun 2026 04:16:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 02/11] mm: khugepaged: generalize collapse_file()
 for shmem mTHP support
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
 <1274846e121e74f8db53950bec64f8f1938f2ec9.1781083630.git.baolin.wang@linux.alibaba.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <1274846e121e74f8db53950bec64f8f1938f2ec9.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Cz2cnNfeqT24WW6tqvRMgzjviX4vdloWEJZKxZ2AfPg_1781259326
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: gaiwem5tdwpnq737gufc3wdptcgbp7dw
X-Rspamd-Queue-Id: B132BC0003
X-HE-Tag: 1781259328-142940
X-HE-Meta: U2FsdGVkX1/l5+ffnTNv8rQubBzDHDQzY5af7KZB2krP6smsmpMZ7ZQEtPezUulf4sIawayVVGgm/GkLcxwBNW1ryOiGGiRpYv07A7bjNg6oMkbcInc4cvsZ34r3tFGJP+AK0j/dokNLA4JBuDY54GH4DabJdClhzwDGcnIUj7SZhLZnXsjKY3lGJ6x0l9Cta3LLLf/o0EoWbUni7Jp99XDDk8CZJ/Z4BVQ8HBFahbOJ0Q8PVPoZ/PiRaJOA9QR+vsHKy26jn8QwISzsTO1DsDCxgZWwqoM2ncdjdYzb4k7dSu29QA1cUPbVSVXkKI1J39P4KFUVsUSVtBEIL8cRpgQY38Bh8ACbAaXIUio7hnztYYE8u1x0C00Z4pPMzIjjtjaoAr1O4esAUEPLjMOzd304uPRdVM3/p07a1cpy6ImeY2Ejxf5S4urXD0JE/jdlDzHiBqH/13esKD2qkbA8mtn8VxcHDmaIz3Og+DvjqH5UZ+Wv/UVOgg6MnCdJox6K9+YywqB9e17R2+HhJnXBMfiDXWWGxboWq9lsD9meMy6t8ptatTQiycWxIFpLVihTxVwm3QSGVzIq3vQ7fJJBBAgA76uDeR1LlwTzaZSBu6vlc2K6icbqWXkTWJZBqB+uJpa9YHCz4zRJ7xulexlSrtbXfYoYXRwMVimk88GsvookQ6IYtdsOIvBRmOd0U+H1fOpv9LIps5CrlCwUCSvaahH6wbt+1N2AXADV7R3YwKOLtN8tE8d3dHNS3Unr9jpTzSH6LGHlTMJi5bJiKroqZ/PAUUmUHs0fPc+BVzeQY8HxEPiqp5pGWChrhkrdmzE9A2Y6OK4V9nO7O9QPqDydIj5sBPcZ6h/LYu56dWq4UhqQB2MU0MbLbHljKGKKt8weka/+oaRrTThL+jYLMIWDIo5rHiTLl/ZEAyhHIkE8vJZ6js69cbueEBWWmuANvu7QubdsGs+BKzFHkXDOFCM
 p0C7UL2k
 Tqnwlxa2TEAJCmMNEI41pal8slcpgO7DQPGMcDWEWOoCreM8Cuik4uCQ2liBMCw6ti70mcc1G3oFt6B9nlJbZKEYkhQNOEEFPUbHkF04YhlBpD7wPnuHGmhMgpKAmvjBhGZdwg26cPO6Tv8JNR4/KExPe0ZJn4YLSJaCGKBojPE1dUKyywpgRky2IytOPHQKOlaJXt8/egpeXuD2EHIDtlAxk0n3yw+zkEpCUFdfIVwp+vWYvIKPA1QPWLAy05Jc9FTZh6g4OdY5JZEozF9W26Oou5oSibizVdjWbeU7NY/8VcyCGBZ0sQd5H0OZZfBOZFenx0xSpzgL0JuSdh14WmNpXgE70pYavPdCOad2UKWovKBJON3nZ1Irocr9mq6U2Q5SkSF1AJBK3KbskdS/WOXfKIpZPZXjnjPRVJcTjiBEFJygm34wa/zF1+vSrZSo8UbwtTTXZmgDbtpDCFOR0lx2kq07VDipQrqnEVtbSxtJGSdS7O+wwgLruTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/10/26 4:29 AM, Baolin Wang wrote:
> Generalize the order of the collapse_file() function to support future
> shmem mTHP collapse.
> 
> No functional changes in this patch.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/khugepaged.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 631459172e19..4adc8c6de062 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2214,6 +2214,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>   * @file: file that collapse on
>   * @start: collapse start address
>   * @cc: collapse context and scratchpad
> + * @order: folio order being collapsed to
>   *
>   * Basic scheme is simple, details are more complex:
>   *  - allocate and lock a new huge page;
> @@ -2232,15 +2233,17 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>   *    + unlock and free huge page;
>   */
>  static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> -		struct file *file, pgoff_t start, struct collapse_control *cc)
> +		struct file *file, pgoff_t start, struct collapse_control *cc,
> +		int order)
>  {
> -	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
> +	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
>  	struct address_space *mapping = file->f_mapping;
> +	const unsigned long nr_pages = 1UL << order;
>  	struct page *dst;
>  	struct folio *folio, *tmp, *new_folio;
> -	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
> +	pgoff_t index = 0, end = start + nr_pages;
>  	LIST_HEAD(pagelist);
> -	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
> +	XA_STATE_ORDER(xas, &mapping->i_pages, start, order);
>  	enum scan_result result = SCAN_SUCCEED;
>  	int nr_none = 0;
>  	bool is_shmem = shmem_file(file);
> @@ -2252,9 +2255,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	 * mapping, the shmem check can be removed.
>  	 */
>  	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
> -	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
> +	VM_WARN_ON_ONCE(start & (nr_pages - 1));
>  
> -	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
> +	result = alloc_charge_folio(&new_folio, mm, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out;
>  
> @@ -2591,12 +2594,12 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	}
>  
>  	if (is_shmem) {
> -		lruvec_stat_mod_folio(new_folio, NR_SHMEM, HPAGE_PMD_NR);
> +		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_pages);
>  		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);

Is this a accounting bug? (not your changes) but

lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);

If this stat is in THPs why are we iterating it by 512? shouldnt it just be +- 1


>  	} else {
>  		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);

Same here.

>  	}
> -	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
> +	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_pages);
>  
>  	/*
>  	 * Mark new_folio as uptodate before inserting it into the
> @@ -2604,14 +2607,14 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	 * unwritten page.
>  	 */
>  	folio_mark_uptodate(new_folio);
> -	folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
> +	folio_ref_add(new_folio, nr_pages - 1);
>  
>  	if (is_shmem)
>  		folio_mark_dirty(new_folio);
>  	folio_add_lru(new_folio);
>  
>  	/* Join all the small entries into a single multi-index entry. */
> -	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
> +	xas_set_order(&xas, start, order);
>  	xas_store(&xas, new_folio);
>  	WARN_ON_ONCE(xas_error(&xas));
>  	xas_unlock_irq(&xas);
> @@ -2666,7 +2669,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	folio_put(new_folio);
>  out:
>  	VM_BUG_ON(!list_empty(&pagelist));
> -	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
> +	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, nr_pages, result);

Although the tracepoint has nr_pages, order may be nice too like I did with the
anon tracing.

Once I refactor, and understand file collapse a little better ill be able to
comment on if youre missing anything in this function, but nothing sticks out at
the moment.

>  	return result;
>  }
>  
> @@ -2769,7 +2772,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  			result = SCAN_EXCEED_NONE_PTE;
>  			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>  		} else {
> -			result = collapse_file(mm, addr, file, start, cc);
> +			result = collapse_file(mm, addr, file, start, cc, HPAGE_PMD_ORDER);
>  		}
>  	}
>  


