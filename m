Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE0F3CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 03:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1428E0007; Wed,  1 Oct 2025 23:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378998E0002; Wed,  1 Oct 2025 23:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E988E0007; Wed,  1 Oct 2025 23:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13E408E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 23:17:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A57A7140314
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:17:48 +0000 (UTC)
X-FDA: 83951714616.30.34A6C24
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9B38AC0006
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:17:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wvo80clQ;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759375066;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukIjXlnpeq1rHbLV2IaXOhdHQVb6iKLF8mmZ545G2bI=;
	b=PF7jUPPegH+7Um9eQo/nAGSnXfPtri+Nk8azxovp+gbaNuWLrq/+RyilKhjwL685THJypI
	vyptqKli7dHcrXX0bAAhn8WwiOylGojLM1LI0Pqtx2vls7pniIcKYUlxIi+on+QG9+Ewnw
	rpRVOdlCU1HN8XzDaeG2qu2uKN3diMQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wvo80clQ;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759375066; a=rsa-sha256;
	cv=none;
	b=5sN2eIA4zsGWe+E4MppkHSF3TQjjKuispcqaUDYFg3gNWdnNX//v3qeqANJRwmH4Iv9tBz
	78yf1KqFBn2EZ7OigF8OWqyieNJE9hcK9YsvJ1r8UUMMb/XlLzAb8sECsr7+c+fHXDbvRT
	R5bYxu6+lJ9tjX/nSoPq2Tnpi9kbH/4=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b3b27b50090so110122766b.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 20:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759375065; x=1759979865; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukIjXlnpeq1rHbLV2IaXOhdHQVb6iKLF8mmZ545G2bI=;
        b=Wvo80clQyn6VJT5CzN2BQl5I2+OeNvdesnTmJd05soQt69ZiYbx8hyI55FtI8QwFBN
         3T7NmRnmZSBVWIFTykZkIE3r320A1e6TKGR8El/cLLEoe2DQNWhwdU6tlFiYfiS/hO90
         SnfS3jEci0UXhGZHLEQX+63THcJ1CCt9jbtrdYq/5ZBlxWmnNGHpk8YIIC2QUb/ch1+X
         xW/eGYXTSiu2Dq/EjGl06YbK3qKHwTmRraahBgKxkQFqLRIdiKXJ3OwcNvuwMI+xiQBB
         +u1syST4c2b1r2EdxFwYMXOxNSZnkEGwuXEIxA16MY7Cwsp2PXQM+0Yw32FqUqPaDYz2
         v3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759375065; x=1759979865;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ukIjXlnpeq1rHbLV2IaXOhdHQVb6iKLF8mmZ545G2bI=;
        b=OFwrXPGr+73G9UHxSt63hA+3+eT6gru7DxL+wZMXNZSWT3UEjFzNBVmCfdjY7JbQGk
         L8rntOeq5PcChWvpr4BhvmX8qT2aX3CAt72D5NC7qC0bCNRapnduvhstGljo18tz3sbp
         lAAy+iM9l7sriR79c2HCV1M/KVo0e0f3rRg/j5bHtgTrxfXXCS2IkFm3NMxeX9kewbyC
         +8csm6I1IJULDtPRlbe+plKdIUXWi2fD8WYiuSd6g/jVlLAaNQRpQV5VNQCrARkPrTcN
         e68nSlIHaJnKU6AyZ9/MMbxFKdBz/0bA1ZUP3PZXHT4oH1G6Ucpt9ZLg2sWzSb4WuGOx
         fxEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmG8EZzvHOPwFG7cUCI964G8uNaaBuxYMaPbwQDzInTOQuF9WWdfb7APf7zYfmvUnJRJP/obxDug==@kvack.org
X-Gm-Message-State: AOJu0YzmLhSnLYolMUiYpuW0qu8lkCT1u7XB343adi7lJNiUS04eG9UY
	MAKm2idqj/0aVENyRJlafM6m6wexjZatmAv4lX6/2YLRIe7zNMJN8/QL
X-Gm-Gg: ASbGncvJWZseStdtwUaJyh5jyAyRojbdtjzPaCATcUK8h2SPGnZz8G+9OUUV00O/oC2
	O3q796qEvqT7ANhRB8pmcdkzxlvVfteA3tWGeJ2JhYT7zB7m9x/vKsic5MID6VYEOHtX9vx4tm6
	iYacyM1XHpMlsK64ww5DBSojE55f7KwpIEpLgToGOt2BVI6I4WwnxiTa3OMWS8nMAblkbmI69sE
	w7R1JLGB9Kgozg2iDQpHNvYYeSYBeEqnR7u+u2niHYi/GhWp5ac0+m+ps967+J9epKeB1currEF
	a5zhPtGghPFpwdV+s8UCz/Qgz6cxAr7bz3sBh0KarfcEn3Z6kCbli44IfgBaFdH63UKszEwvUKU
	inSKQfHhuExKqTrR7bmpfXh4SmL5t9AX3YE5SghuvvLY4ECPxgmKRLfDF9bsE
X-Google-Smtp-Source: AGHT+IGz5qdn7Z8WqPdcaSzQRnRcwjhB2iTUbVl5Nl2cC+78S079TdI9YWxGEdwKvxX3OhBhqheR9g==
X-Received: by 2002:a17:906:7314:b0:b3f:b7ca:26c5 with SMTP id a640c23a62f3a-b46e68103bbmr711840066b.59.1759375064743;
        Wed, 01 Oct 2025 20:17:44 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486a173b4csm101736166b.86.2025.10.01.20.17.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 20:17:44 -0700 (PDT)
Date: Thu, 2 Oct 2025 03:17:43 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, wangkefeng.wang@huawei.com, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Message-ID: <20251002031743.4anbofbyym5tlwrt@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
 <20251002014604.d2ryohvtrdfn7mvf@master>
 <fa3f9e82-c6c8-43f2-803f-b8bb0fe56f37@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa3f9e82-c6c8-43f2-803f-b8bb0fe56f37@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 9B38AC0006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ohr8jei47a1wqz4dkwfjopmcohcsb8bd
X-HE-Tag: 1759375066-951191
X-HE-Meta: U2FsdGVkX1+slSVChiueCd/v1nx4nSl8BeJVhNrl0e/jdEEufnfBTwaglSoveaRwE0YAFoD/BzsmAr4wU8a5dT29AJXEzzJ/KnpWjStW++ndLcyCIkR2Sd/eboGOdfSBEEytwyfI3Bg+PwliEjh4Od2I8NB0lGAgnT2x8PpS02PwzffKE7mTT3hyihdej6KRmQS9WZbOS/rWjlYL5BEPYYzlBNwPVasoZrknD2F1iScskZXBn7KYB2kLA2Vu/edO1nbagBVjSKGQ4tDlGqopdqZPWTReCiq0P0K2JZdCMZcn2/sJV1G/Z3kOTQS9XpoewQnaj0VXhj0r7iFccDjLhlCZURa4cnvNUoPL7fVIf7BQB4A6JwEQKU/6DxbrvH/DgK9VS2OhxUu/+R2vtRbFQ0jdHeMe8w9qF0zf81SPzomsd3CmVA9tAwndNfEEF03ezvNAQgccNvEo3VhTMkbt4Fgs1aF/xA11WPoxulY6MLIzgDKK/lDOzvUDSuyuCRMaSIPsujX8RV6h6kY42nocPOtbr2Ttct5i0EwGKJhdZp012B0GkyirEz01nQJZtP7Beh4EOvKIkVaz/NAbm4NlzeciehG5ydYs60M3lIg2CS32GqfWuTKMVTBWL1fyqk40NvEP+3hudQlVwpDZ7XilcioLcEi/xIUSDbbQrvjaelBRcsqHyhR0mt3BwQWWrXjBj0vP6S9pIhIRImAUkNp12DB7rfF4N/4rLf6QGMxY33Cr50406zEAYlLzSTXN4LpXzYILybO/cpvWGFFkj2qzqbFyo7moPz/dtPwgm4L4OR0NMpnooRJQNHDT08qqrkpMo221vS79PSVImUyOcJIAshZV4chbVcxA6f6FSXR5S5q8BM99IrOjdpLhyLCWg2S7kSZ78Y96P01ZbfkuMqOLdyTjdgh6aeXisuZmWzPjRcIUiPjywy5Wt8en0m3P/os6ISdmyog6P4+zQbVoTLr
 23KDoyCU
 k2UbT3C7xQtwTN4Jfm4+ITK68s5C9v1oKl4Er2xqKoi60TvlWrqPoX2n7CKXzxqc1axp/4uv/6okqJTHbMlZJZCYFtu2lYtiQhsWh33AM9waFWOrmAO2MBWmq6HI4yT/l6lWlr36OOIRTZ+PUOmR/QBzdoiX8ROOnyFPGRk6xYG8MjsPcUQWVR3IEznrQAQ+hgo3zxourR2DxO0Q8sP5iLiMAbEqhWEEiW8byCdLQn0fMFde45smvVQlGIy1cbKsLZKdRUsrSgZUY29sY4csdPZlWVlx8RdWh2a7rkb+W4weOIzH/Q4FvZSZP+fvSkBgc3rdegufx+zsUktn2VQWFgiLTAQEON+qCWbhee3CMygz3FVmEW3sD6AzR4iiNQTBQ4oIaJ0scAmCnMeCf/o0cV6tp0dfK0NVe89pwdwI4Y07HVMsbcFIDexg/NZRZp8oT+LsieS1fDcYPYG6X8S28yZDtfh3uL1YB8QyrPJ4dafARwSuTka5jmCj7vA1LNU/jkBLe1iVlu3ZcGEbkyC8NAmySJ2g/cHBgAlRd1ireklIiCyl75GyHgqsMJonwndbUOo0uGt/KHSbisHzEHhXbK8E5mBdCp3D9VD8Aunc9ONHCNLT0y0yKUXxgABnK1L+XJF3VzJTOZ3DeAFg2sNfza8Y+cgXkEe8pQuhMvAZs05yW4z/LpZBh1GnWtFqbUgz/oKCpSYkRXR43Q4UBWRRNc9fC0ioqDyzLfV//vkHWs6eOfVE7ksxyLnPwrZgEohTnlFbnQhjK9zV/8CLy3ei4iFkIA1zdlqzSF6IJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 10:31:53AM +0800, Lance Yang wrote:
>
>
>On 2025/10/2 09:46, Wei Yang wrote:
>> On Thu, Oct 02, 2025 at 01:38:25AM +0000, Wei Yang wrote:
>> > We add pmd folio into ds_queue on the first page fault in
>> > __do_huge_pmd_anonymous_page(), so that we can split it in case of
>> > memory pressure. This should be the same for a pmd folio during wp
>> > page fault.
>> > 
>> > Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
>> > to add it to ds_queue, which means system may not reclaim enough memory
>> > in case of memory pressure even the pmd folio is under used.
>> > 
>> > Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
>> > folio installation consistent.
>> > 
>> 
>> Since we move deferred_split_folio() into map_anon_folio_pmd(), I am thinking
>> about whether we can consolidate the process in collapse_huge_page().
>> 
>> Use map_anon_folio_pmd() in collapse_huge_page(), but skip those statistic
>> adjustment.
>
>Yeah, that's a good idea :)
>
>We could add a simple bool is_fault parameter to map_anon_folio_pmd()
>to control the statistics.
>
>The fault paths would call it with true, and the collapse paths could
>then call it with false.
>
>Something like this:
>
>```
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 1b81680b4225..9924180a4a56 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -1218,7 +1218,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct
>vm_area_struct *vma,
> }
>
> static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
>-		struct vm_area_struct *vma, unsigned long haddr)
>+		struct vm_area_struct *vma, unsigned long haddr, bool is_fault)
> {
> 	pmd_t entry;
>
>@@ -1228,10 +1228,15 @@ static void map_anon_folio_pmd(struct folio *folio,
>pmd_t *pmd,
> 	folio_add_lru_vma(folio, vma);
> 	set_pmd_at(vma->vm_mm, haddr, pmd, entry);
> 	update_mmu_cache_pmd(vma, haddr, pmd);
>-	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>-	count_vm_event(THP_FAULT_ALLOC);
>-	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>-	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>+
>+	if (is_fault) {
>+		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>+		count_vm_event(THP_FAULT_ALLOC);
>+		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>+		count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>+	}
>+
>+	deferred_split_folio(folio, false);
> }
>
> static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index d0957648db19..2eddd5a60e48 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1227,17 +1227,10 @@ static int collapse_huge_page(struct mm_struct *mm,
>unsigned long address,
> 	__folio_mark_uptodate(folio);
> 	pgtable = pmd_pgtable(_pmd);
>
>-	_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
>-	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
>-
> 	spin_lock(pmd_ptl);
> 	BUG_ON(!pmd_none(*pmd));
>-	folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
>-	folio_add_lru_vma(folio, vma);
> 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
>-	set_pmd_at(mm, address, pmd, _pmd);
>-	update_mmu_cache_pmd(vma, address, pmd);
>-	deferred_split_folio(folio, false);
>+	map_anon_folio_pmd(folio, pmd, vma, address, false);
> 	spin_unlock(pmd_ptl);
>
> 	folio = NULL;
>```
>
>Untested, though.
>

This is the same as I thought.

Will prepare a patch for it.


-- 
Wei Yang
Help you, Help me

