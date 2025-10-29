Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9337ACCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A0C8E0078; Wed, 29 Oct 2025 10:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3CD38E0045; Wed, 29 Oct 2025 10:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04BD8E0078; Wed, 29 Oct 2025 10:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C86538E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:45:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB89F160746
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:45:22 +0000 (UTC)
X-FDA: 84051424884.29.6A578F2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1F922C0005
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:45:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Zrm4m/PH";
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761749120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8B4g45kp6nicUbsj93IKXnwrHXTFyUlyH0y3Ghhzkk=;
	b=0R+ITTaWaHRdj9m5lY8UOs/n0NW9uiQItzk5ZRS8Ey4t9L4XbSWHjVoTYbndt3BfiNszbZ
	xGh7/l1NokXhqNDkW0I25hKTXSEovPq2DrGsb+MAUoq3Q449XQf6v1xZc10qWBYUcqx1vq
	/Sjh1Nf4MrPp5Bef1va4JBG5wM+qVkg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Zrm4m/PH";
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761749120; a=rsa-sha256;
	cv=none;
	b=kEpl4J4UodiZq9jpQvX+mIjLUXgRbwSQJkCQC1GZnxjp4j+B4rebcjAw0r/9K2sn9k8Txa
	u6tmSbWTA1QitXgYBvq+/ZasDhtKDKiFWkiyVsRlavUeG/psEcOp2ELU1V9Lt2YvgY1AKr
	8LVAqayIbRUfDeYgZdfxbQHqLRifi7A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761749119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U8B4g45kp6nicUbsj93IKXnwrHXTFyUlyH0y3Ghhzkk=;
	b=Zrm4m/PHyo36ssZn1s7GGfuyBabAZHbawRyKVFrf0dIf1EXFOYSDuwmUbwLixWazNJx4F0
	BtL73w8UwJ62Ev2FdSbdvo+qtqucyvex5no6rOHOw6MyD5I1Gw3KNLgC3in0JZwrkGyv0Q
	+5wVerCLWRqesj2pHmAg14kYltFGM/I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-xhAkKlYfO82I0LIHXHLWAA-1; Wed, 29 Oct 2025 10:45:18 -0400
X-MC-Unique: xhAkKlYfO82I0LIHXHLWAA-1
X-Mimecast-MFC-AGG-ID: xhAkKlYfO82I0LIHXHLWAA_1761749117
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-428567f67c5so4291414f8f.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:45:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761749117; x=1762353917;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U8B4g45kp6nicUbsj93IKXnwrHXTFyUlyH0y3Ghhzkk=;
        b=A9oC204lPuFcL2jqWT2v9iV5hRy9cmUAdjNpyn+CB0OuwDS6xF3BHgawQclulbbuY/
         1dF1easg+HeU7ObRrU7nvK/TLEp5/Jm9yiy0InyQR/LP0ryuZKU9SCcAd2rRAV03qNyc
         1QZlyVV+q1UUrgl5to7KlDKU2HGW8S7vWTlp6LM8pvXtf+vUy0vvk0q2BXjT88ytJerN
         USeCzhbzTJPGolsAVkSc9QsyiRC7JiETrJn5MnN2Fy7NP5mTIe6l7GuJmLVZPgPltbV0
         5FIoX0A++Ld6l5V+fJ99nBVx+koHJGRoecY8igYRDn1RmZrAuk8uuO/d1j0OhSaVrB6j
         IJuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUx/MwzbUBRZWlnpVpFxIisagdHIOQkahqz3BzqLtP6Jb2idzwk4gv1m7UiqLeBs2TU3/txhWvSMQ==@kvack.org
X-Gm-Message-State: AOJu0YzYdmFkWU5vxTTRIuRANOdHMKdgE++li8vAHONvyNVuUT9MTABu
	1rsEkj946t7KaKdXUimttm0FvPDFpweefeUKN7qVFLzQf8nDqP5ti0DxQYaNvz/XBtJ8Wea86/D
	WL1dehb+Tzlxxff5+EGILjsiI03BYONjDqmChpiA4pSpNF1vICxQs
X-Gm-Gg: ASbGncub133tsX3eFjATxmgzlb6uHn8zVudxRZjduhM6ilwerz1QnNGLJc5Jm3Awkyu
	IdBsY23gD153RHDZ6cgfLZf6XEYp2vhDJb8d3Rz92N9BAEzNM1BMHAFlSYlK6PUpBmce2ZHmGph
	qZUWzkplv1vO3rVrFjHnHhyhF+8H3K8tlI5hRwvQK2NtvF0jWnWYxg5rkUG5NQYLPGPlMkkphb/
	pfjAsph+sKCtsjasJGVyvuGK9IQKRxfAya2c2+vjCYGUfhZb7CfUqN/xQruo2qd/8EyThwfs5Ub
	4mRZoe93g268QUd6Ja3fQ50d8Ipd0e2Qe/vN+PtbPJpO/CjlxqZ7xcN5vbpiWs89pjS6KyTAcLL
	+VVAD15dVRpBVi8PjJZPnHQ==
X-Received: by 2002:a05:6000:1a8a:b0:429:9197:5b31 with SMTP id ffacd0b85a97d-429aefcaa88mr2902484f8f.53.1761749116802;
        Wed, 29 Oct 2025 07:45:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxd2TGV6BAsL1K32rrif55rVqRiYFEJwT8e1K7hi0Pnz4IHJEgWL6tCAfAxRD2v1FARSiHDQ==
X-Received: by 2002:a05:6000:1a8a:b0:429:9197:5b31 with SMTP id ffacd0b85a97d-429aefcaa88mr2902456f8f.53.1761749116239;
        Wed, 29 Oct 2025 07:45:16 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952d5768sm27419982f8f.24.2025.10.29.07.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 07:45:15 -0700 (PDT)
Message-ID: <85604399-40a8-4d13-809d-e5492e74a988@redhat.com>
Date: Wed, 29 Oct 2025 15:45:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ksm: perform a range-walk in break_ksm
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251028131945.26445-1-pedrodemargomes@gmail.com>
 <20251028131945.26445-3-pedrodemargomes@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251028131945.26445-3-pedrodemargomes@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UTJrN0uIXxlvNEFNnBSWDnvcflzq43ACNBw2sJNV0nY_1761749117
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jcaxcdt854ibg45pxuj3tidmh73gz3di
X-Rspamd-Queue-Id: 1F922C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761749119-469384
X-HE-Meta: U2FsdGVkX19uzEz+pBTChelay5KNAQvP0WfOXO8IZa3toVKTg3pDtNF5nD/B/aPr97vQVQHdhEoBWKIeSRunaxNqS4jU6f5WsvGYRr+H3RciJB9e/jx6EV5JnnWJ0KZlIiYRNKasWnltgeLzh3iSBVmrTVkSquNnE9YDFP6weKhm5bMscveKPaaYKYnC1BTYjHmOjO8ZxTKXlHB62RMM2uRn57BaQtDnVJrXoKfSRPF6Nc1taWrqWmPM18EEYabQfI/BKozF5OJAnzsHLQ8Glt1uvvlUC8Hfl2doGTc0/fGkEK8OpREJPv+Jo8d6SirurNIj7WJcqJeAvn4rZM9JauWQCtnqJEvSN+5TTGe9UTARaSJ6VM34Q52TNKZBYTg++rzejnr2+7zd1iZn5h8LZ6MK49fzk0T0tc15XBC0cu5JfAZO0VxK9jiqFowfhgNU4sM1h7NCqhWrcZiXrj14VP6CLCB/g7U9w5AVvglitGt060RvCm+Xaq5hLLLbXPr7cHV1cliHnYYjzaiWAKVMs0t3PX4W3CJjwRXXJaNgmln2s2zIpZZt/g6Tz121eno5TXoFp1G0XB4AWtxCVyuLesrZxhhsa/P1C0UN8zBpHUmINa7OkDJEOhmYXQjWXnjCUz+mjKVCjKVNf24+u6K6U4N0cW+9t/Z1UaH4Yy0orbk0jDxN23FTfnFWYT7YOPhR2XbeSzJcApoBF3QiimgE0oca9CIMYC1xG19/sVMgtPzbTM1n73VW/Zv1x4Te7K5JJ2AlqfKRNv5+8lyZIYHTK2s0JgoIkd9yKqwAdu/VUjHqt3K9zRRBefiaR5Qb+pqBzUGeu+WAeFbfsiC5I3M5KbS3OfQ84j9HLW7V6sf8iKGUi/BY1SBq8flHI5KUdXCuXtd03ZrN9qMuCsvmrJCf/H/B5QFADbgGacqY9hPANcBOInaz3Nd+1iHbke3rKHv1CSAcbsDA4dYMdEbkZSp
 BlZPihcJ
 ko8Gegr5aEADS1crAFkeIkKPIhei5HzNY+KPOTjxXny2+HpwoTzrBLmD95qhdQFAxcCx+lapicBd6jxp9MFRszeRyAcbqKDmPebMJ8+poo1E2LQ+bPyrG+GokWpDxe2d5vbhjb0kErbKm+ijmrkN5nmvJ/dzBFw73WtDBLwY1G/CGsX0ncAyZwbRAUw8UGmzq1BWtaNlB6BJX+QAkyZfuWkfMUn7eSmdZxcseV1WMQxaZVSWqfdI3neduXQ0vufA6B8dvedtY+VuZmz/tCUEGt/MaKMs2r7ydySWcRmRdIhfwyDSG41/JIg4FSK7yUcxzD2ZrUGpfL1Plxw2G5pJgpTuAurbTIAElsiiQ4SeVAVH2/0kkxv+Gqs4Pji5ZdKP+t0J+heLY2la2BH6fJCiFW5AzaBjKCEZjPe6XkK0jAClNPITWsIt5qvcJOg9XDfdrQfQqK+asCVxwfI7Xvd8q4WcdIUOKi/OYncngp051StiqRy7snPZeECuNp8DtfUC/YCYptGuU2igXBCHqErpvDLyGWBMgy8x195GP6vGHfWVxF4O+T2SgaInSa3kiPLmuO17825Xd2JgiOe+yTNIkk0qiALV/yyPpPQxu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.10.25 14:19, Pedro Demarchi Gomes wrote:
> Make break_ksm() receive an address range and change
> break_ksm_pmd_entry() to perform a range-walk and return the address of
> the first ksm page found.
> 
> This change allows break_ksm() to skip unmapped regions instead of
> iterating every page address. When unmerging large sparse VMAs, this
> significantly reduces runtime, as confirmed by benchmark test (see
> cover letter).

Instead of referencing the cover letter, directly include the data here.

> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---
>   mm/ksm.c | 88 +++++++++++++++++++++++++++++++-------------------------
>   1 file changed, 49 insertions(+), 39 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 2a9a7fd4c777..1d1ef0554c7c 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -607,34 +607,54 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
>   	return atomic_read(&mm->mm_users) == 0;
>   }
>   
> -static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
> +struct break_ksm_arg {
> +	unsigned long addr;
> +};

You can avoid that by simply passing a pointer to addr.

> +
> +static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
>   			struct mm_walk *walk)
>   {
> -	struct page *page = NULL;
> +	struct page *page;
>   	spinlock_t *ptl;
> -	pte_t *pte;
> -	pte_t ptent;
> -	int ret;
> +	pte_t *start_ptep = NULL, *ptep, pte;

Is there a need to initialize start_ptep?

> +	int ret = 0;
> +	struct mm_struct *mm = walk->mm;
> +	struct break_ksm_arg *private = (struct break_ksm_arg *) walk->private;

Prefer reverse xmas tree:

struct break_ksm_arg *private = (struct break_ksm_arg *) walk->private;
struct mm_struct *mm = walk->mm;
...

With the break_ksm_arg simplification you'd had

unsigned long *found_addr = (unsigned long *)walk->private;


>   
> -	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> -	if (!pte)
> +	if (ksm_test_exit(walk->mm))
>   		return 0;
> -	ptent = ptep_get(pte);
> -	if (pte_present(ptent)) {
> -		page = vm_normal_page(walk->vma, addr, ptent);
> -	} else if (!pte_none(ptent)) {
> -		swp_entry_t entry = pte_to_swp_entry(ptent);
>   
> -		/*
> -		 * As KSM pages remain KSM pages until freed, no need to wait
> -		 * here for migration to end.
> -		 */
> -		if (is_migration_entry(entry))
> -			page = pfn_swap_entry_to_page(entry);
> +	if (signal_pending(current))
> +		return -ERESTARTSYS;

I assume that's not a problem for the other callsites that wouldn't 
check this before.

> +
> +	start_ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> +	if (!start_ptep)
> +		return 0;
> +
> +	for (ptep = start_ptep; addr < end; ptep++, addr += PAGE_SIZE) {

Best to declare pte and folio (see last mail) here in the loop:

	pte_t pte = ptep_get(ptep);
	struct folio *folio = NULL;

> +		pte = ptep_get(ptep);
> +		page = NULL;
> +		if (pte_present(pte)) {
> +			page = vm_normal_page(walk->vma, addr, pte);
> +		} else if (!pte_none(pte)) {
> +			swp_entry_t entry = pte_to_swp_entry(pte);
> +
> +			/*
> +			 * As KSM pages remain KSM pages until freed, no need to wait
> +			 * here for migration to end.
> +			 */
> +			if (is_migration_entry(entry))
> +				page = pfn_swap_entry_to_page(entry);
> +		}
> +		/* return 1 if the page is an normal ksm page or KSM-placed zero page */
> +		ret = (page && folio_test_ksm(page_folio(page))) || is_ksm_zero_pte(pte);
> +		if (ret) {
> +			private->addr = addr;
> +			goto out_unlock;
> +		}

I suggest you call "ret" "found" instead.

>   	}
> -	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
> -	ret = (page && folio_test_ksm(page_folio(page))) || is_ksm_zero_pte(ptent);
> -	pte_unmap_unlock(pte, ptl);
> +out_unlock:
> +	pte_unmap_unlock(ptep, ptl);
>   	return ret;
>   }
>   
> @@ -661,9 +681,11 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
>    * of the process that owns 'vma'.  We also do not want to enforce
>    * protection keys here anyway.
>    */
> -static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
> +static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
> +		unsigned long end, bool lock_vma)
>   {
>   	vm_fault_t ret = 0;
> +	struct break_ksm_arg break_ksm_arg;
>   	const struct mm_walk_ops *ops = lock_vma ?
>   				&break_ksm_lock_vma_ops : &break_ksm_ops;
>   
> @@ -671,11 +693,10 @@ static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_v
>   		int ksm_page;
>   
>   		cond_resched();
> -		ksm_page = walk_page_range_vma(vma, addr, addr + 1, ops, NULL);
> -		if (WARN_ON_ONCE(ksm_page < 0))
> +		ksm_page = walk_page_range_vma(vma, addr, end, ops, &break_ksm_arg);
> +		if (ksm_page <= 0)
>   			return ksm_page;
> -		if (!ksm_page)
> -			return 0;
> +		addr = break_ksm_arg.addr;
>   		ret = handle_mm_fault(vma, addr,
>   				      FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
>   				      NULL);
> @@ -761,7 +782,7 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
>   	mmap_read_lock(mm);
>   	vma = find_mergeable_vma(mm, addr);
>   	if (vma)
> -		break_ksm(vma, addr, false);
> +		break_ksm(vma, addr, addr + 1, false);

Better to use addr + PAGE_SIZE

-- 
Cheers

David / dhildenb


