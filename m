Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B866CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 22:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622C48E013C; Tue, 14 Oct 2025 18:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FAED8E0090; Tue, 14 Oct 2025 18:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510338E013C; Tue, 14 Oct 2025 18:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 351EA8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 18:04:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCE9111B261
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:04:48 +0000 (UTC)
X-FDA: 83998100256.19.F69147E
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id DFC6E140007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:04:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IaAGkm4V;
	spf=pass (imf09.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760479486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=em9G7k50/YoPb9HbweOv7zMBAXiBoWznZJD05Jcou8E=;
	b=zq506ysDR9F1f+sEMoQ1h8nIOwB6vc7IxuX36hXb6fwFC8ghVIAcsUrDJAhhcPjyb+QCRb
	tFJbdBrjfblJEAGbkB4pdNhtqqxUydvAUKBV+5X8qzz6ALA1+BOibn2iPwimJNt5AQL/1v
	tbf9UQPCMNz1dCcS5jACJmFu3cDSTsA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IaAGkm4V;
	spf=pass (imf09.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760479486; a=rsa-sha256;
	cv=none;
	b=ar33sYgOGtlSHkMoo3vn1olsQC+9KHXw/UUkCgNLDwd2MKYKU3e3TCwVlsLOtlvhbzkPu+
	cBsK/8p/vhA6w8N++FZCb5ek7rV4YD6WMKn9KPe3viMsCK1uZMitTeVDh2zxoMxQgEainr
	3JIxFIo1E6hNJUsszyZ8mZ0AoLHBxMQ=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b57bf560703so3811960a12.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760479486; x=1761084286; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=em9G7k50/YoPb9HbweOv7zMBAXiBoWznZJD05Jcou8E=;
        b=IaAGkm4ViCHZk546lMRtU3s9ygDksz9CQ6isuiVidoUw6BgDxdKwtdgYn6dIKpnFpw
         JxQ9rFPG3tBtbQ2fZMujwe3nzSpQSM2+KlL4XGrMuu6+CNLPd+mgkEFHDY0DaM8jQhz/
         +2Ew0j2+QBEjmh0yHJS0axlWt7VtJDVUZEgeVA31MhkKqQI4K90lcAjoNhliEtqsp75R
         hYDrMK0VhKyNRjLzUN1X/+3jTYjuMgR/BYeK9rL4gY5fey/TUBd+fe1+E/8elI2AR/cz
         vKewLEzoMjXl+edn6ELnrIiLV9n50klQ+Ytls63wISACo7uJseH2Gqfa3h5dyqMtwte/
         7KrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760479486; x=1761084286;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=em9G7k50/YoPb9HbweOv7zMBAXiBoWznZJD05Jcou8E=;
        b=Q4F+i/DFFwnQrYRp1YYmpNNc+r+PeHRGlVl2dz77/RjC/gAPbcxZ4ZEU6IAM75vjVX
         pkUupQR32G6eMKCE6IDpsQ91cey0Ekq7zsi8tMm+B1JLnAW/Ra5PKs9m0UQ+6viz6z5r
         v96c58lkYMrMp72FVkYdFhLkC/yobhYyigiddlzyY3582BJCv3J294kSx0AIZUUqDg6j
         GSeHHf3SSsRp0p4CHnDFq6WJUlccBHJlpfNSOGl1SuBtazy3KiRk66e8TxwNDonJfCKs
         VnDMuoEyLbO7Ifyhe9NCCVijq98aTCOfLBChs6IQwI+ofbI+X95hapa8+Is568EmyOwP
         DFQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxzUFMdR+iJbCFyvmTF3hwy54IXNq2hjNXXZKOf08XOjz5VW25SELnvf/GbBjZiKFuQkITU2q7BQ==@kvack.org
X-Gm-Message-State: AOJu0Yz9sQdjl/IWV1pjwCESBxcDxnDu/kaGwck6YWygPim5RufsHuc3
	rRQg/+Uzluj/CcGuNXZV9RaJ8n7cYVOufLTuaKVzZn4aPd6DI4/0sl8p
X-Gm-Gg: ASbGncs1cdHB7szU3/3nO2XDY0cwoUZbDEJp7irm3oZm5qDhF97XtojkVzq/OXJwerH
	GU7+sAd1M9m8DqBucWgX5Ehs4VAHWAM8Hp5hxKdHsYYiZhuVTiG8TEmRTB085++MxFbwe9Z71Cr
	sNf3pMttjqQMsfv9r0bUvABJrGZ/gtM1DaooS+pIoULve+XtJw4RnBGEJOdz0ZhuW6RyAkVCvdo
	BnCwwFmNlDfrYzbVDGZYHtVn4NteTFJi6gnuQQsx5IppIwm3Tnmho6YEY4yQKVWLr4k1IDC2JOH
	PbXjxxcPveA248/VPtXFU8ASwRRIqGK5yAmw1+a+jmubvaTlIlcvXsBIeVbRziT81zHiq2EGBJ7
	S33jAJODF7Z+858O4FbWK5WTfvUZVLSLMDQ+CtfReEMAlKWYsOa6DpupJbdbj+HsRTX7Ng5wqPw
	lMH6dBf5ay74/4eV3MrO0d
X-Google-Smtp-Source: AGHT+IFkpy/T9xOcAh37FUeV77inYRWjgwBQGuYQSlksDCArTvA7VvnPknld6pHnbM60IY3q2F64IQ==
X-Received: by 2002:a17:902:e78f:b0:277:71e6:b04d with SMTP id d9443c01a7336-2902735691cmr341952385ad.3.1760479485597;
        Tue, 14 Oct 2025 15:04:45 -0700 (PDT)
Received: from ?IPV6:2804:14c:5fc8:8033:858f:c73d:3967:699f? ([2804:14c:5fc8:8033:858f:c73d:3967:699f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de6c7bsm174749665ad.3.2025.10.14.15.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 15:04:45 -0700 (PDT)
Message-ID: <be137610-65a7-4402-86d8-3d169e3ac064@gmail.com>
Date: Tue, 14 Oct 2025 18:57:54 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: Re: [PATCH v2] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251014151126.87589-1-pedrodemargomes@gmail.com>
 <77b69bcb-6df0-4c3a-bb7c-a003fd51d292@redhat.com>
Content-Language: en-US
In-Reply-To: <77b69bcb-6df0-4c3a-bb7c-a003fd51d292@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DFC6E140007
X-Stat-Signature: d9faqb658cirg19c4xfwqn4woxduogca
X-Rspam-User: 
X-HE-Tag: 1760479486-943582
X-HE-Meta: U2FsdGVkX1/RbD9k8dULyDF4ikzsMhPMLhUY+HMNHKd3AxqPq9rjZNN4mcIB75+D6FikxZk7aRHXs14caenqOJxrZhuLQ3llXMjoNHO/gk75GQWQJOscH3W57fPG8/Pb6P1sTSS9cCanckjkyctTsCpOiUpWx63JQ3yaptr4fsTZWCBOqSdYhzt0FrSrzzcbPAeSHQ/rEdJeEuFu7dcUVzrvbE3lE/F6i2fstC88TkI9Ft/MLhwzSScZH/SIRUC+cr8alHrgfwmviNYbz2VLYamljE0fx6tKs0sbz36uAiJ5fWFz1sSAeXp5MeRm9d+LnJwAhGlwtubpLL3kwJk/W/SpUBprEf7glIZJIj81Z+BRRrBND/HmBq6xpprEwDqBPyrztztufHYm1/CXqOXYQW78R59OabGu4orM7pLYCbocRWmUWXlk2ejkD1vMfvkRCp02mC9nTKGHgUOHPJWw7XYHo7opXqi2Q3FNOJHP6zo7iOoO+3VZJo8pmYw2sQTPNpiA+C6vNgZDn1sAVuWjF6lkRac3TQT1lznZz8F/wgs34W5grhgpQ195bnUXp4erZQGHzFXDEqz5y3ArF+lYsW5EY0FygLBF+gXuJaA204ZzstQdKutMxYsfs2ph52tGQ54LbVozOx4fBZoY80XLbdbNRbJKSXVBJpDW9TJlWnPK1Sh/Ft23VZiP5KyaUhkaUMH8xETLPzYDxb1QAHJbr6AmpmwkqZnFcKWcdVsuSMexxg/7hYiS4UYiz109Mva0/cAA6o7Sm4QbtELOZ1CxMtTp7ZBc9y+q6o1JWkKqRpVrTZudw2IP70eoWiP8IfqcPuQltRq65fwOgBHvq9GHgUMkio4HLgmRUGya+DP6BWl5zaIop9v2BdC6DTsFCAukKo1kddMNR7B2EO6FVF/EB68jyk1npKbxxdLY7HNDNZa50I6ppxFcwrvuXBknwT07u7NawldT+UdOz9LfSCf
 drDyXf4c
 qam7T7nloHrHxzyOE7LjnfVcAKPv0CPt3VxWNNx4FSTdn2cfnPdLrIW0H9er37Zh8BjY5ZPPRJdIlVaXwlXMzD5Qhu5bpRrRJXhsB8pwe44/xAeRBPwZYKDTs7KTrTwaDWepARdM3CLvLJPzo/7bMSo2bLJA65OkBEImXAPkW8HavMO5hHWvxwnSX7j+S+DJzmz3ahaaJ4xVGzyiN8HV7zXkdc1hQVlyVQ3GFxP8DnvcRDyN6/jKEbWHveOCwt8qh7+hELlJnDKBW3eoz0NPliu+BUnQ29XBT/ei3BvNeM4uBo62u8z7CkfgKLZ6ihdjejjM0ro0s2i6A7/vKW6nnNDx86c1cXlGPDMHpeV+wx9n3gCLLvWhrO03BPKajtStbC3pFJQYB9/7t2TxT7Qh0tTBSP1IsO2DJ4pwq8jXLwbEO90wgjgoM/Y9HUYuosimOPpPZZP69wc8YZfWr6wwZkVE8HZaZ4c8VxusNDKzUxIYtUg1uRs4liV2Qbn4BjjPvM3pH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/14/25 12:59, David Hildenbrand wrote:
> On 14.10.25 17:11, Pedro Demarchi Gomes wrote:
>> Currently, scan_get_next_rmap_item() walks every page address in a VMA
>> to locate mergeable pages. This becomes highly inefficient when scanning
>> large virtual memory areas that contain mostly unmapped regions.
>>
>> This patch replaces the per-address lookup with a range walk using
>> walk_page_range(). The range walker allows KSM to skip over entire
>> unmapped holes in a VMA, avoiding unnecessary lookups.
>> This problem was previously discussed in [1].
>>
>> Changes since v1 [2]:
>> - Use pmd_entry to walk page range
>> - Use cond_resched inside pmd_entry()
>> - walk_page_range returns page+folio
>>
>> [1] https://lore.kernel.org/linux- 
>> mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
>> [2] https://lore.kernel.org/linux-mm/20251014055828.124522-1- 
>> pedrodemargomes@gmail.com/
>>
>> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
>> ---
> 
> [...]
> 
>> +
>> +static int ksm_pmd_entry(pmd_t *pmd, unsigned long addr,
>> +                unsigned long end, struct mm_walk *walk)
>> +{
>> +    struct mm_struct *mm = walk->mm;
>> +    struct vm_area_struct *vma = walk->vma;
>> +    struct ksm_walk_private *private = (struct ksm_walk_private *) 
>> walk->private;
>> +    struct folio *folio;
>> +    pte_t *start_pte, *pte, ptent;
>> +    spinlock_t *ptl;
>> +    int ret = 0;
>> +
>> +    start_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
>> +    if (!start_pte) {
>> +        ksm_scan.address = end;
>> +        return 0;
>> +    }
> 
> Please take more time to understand the details. If there is a THP there 
> you actually have to find the relevant page.
> 

Ok

>> +
>> +    for (; addr < end; pte++, addr += PAGE_SIZE) {
>> +        ptent = ptep_get(pte);
>> +        struct page *page = vm_normal_page(vma, addr, ptent);
>> +        ksm_scan.address = addr;
> 
> Updating that value from in here is a bit nasty. I wonder if you should 
> rather make the function also return the address of the found page as well.
> 
> In the caller, if we don't find any page, there is no need to update the
> address from this function I guess. We iterated the complete MM space in 
> that case.
> 

Ok

>> +
>> +        if (ksm_test_exit(mm)) {
>> +            ret = 1;
>> +            break;
>> +        }
>> +
>> +        if (!page)
>> +            continue;
>> +
>> +        folio = page_folio(page);
>> +        if (folio_is_zone_device(folio) || !folio_test_anon(folio))
>> +            continue;
>> +
>> +        ret = 1;
>> +        folio_get(folio);
>> +        private->page = page;
>> +        private->folio = folio;
>> +        private->vma = vma;
>> +        break;
>> +    }
>> +    pte_unmap_unlock(start_pte, ptl);
>> +
>> +    cond_resched();
>> +    return ret;
>> +}
>> +
>> +struct mm_walk_ops walk_ops = {
>> +    .pmd_entry = ksm_pmd_entry,
>> +    .test_walk = ksm_walk_test,
>> +    .walk_lock = PGWALK_RDLOCK,
>> +};
>> +
>>   static struct ksm_rmap_item *scan_get_next_rmap_item(struct page 
>> **page)
>>   {
>>       struct mm_struct *mm;
>>       struct ksm_mm_slot *mm_slot;
>>       struct mm_slot *slot;
>> -    struct vm_area_struct *vma;
>>       struct ksm_rmap_item *rmap_item;
>> -    struct vma_iterator vmi;
>>       int nid;
>>       if (list_empty(&ksm_mm_head.slot.mm_node))
>> @@ -2527,64 +2595,40 @@ static struct ksm_rmap_item 
>> *scan_get_next_rmap_item(struct page **page)
>>       slot = &mm_slot->slot;
>>       mm = slot->mm;
>> -    vma_iter_init(&vmi, mm, ksm_scan.address);
>>       mmap_read_lock(mm);
>>       if (ksm_test_exit(mm))
>>           goto no_vmas;
>> -    for_each_vma(vmi, vma) {
>> -        if (!(vma->vm_flags & VM_MERGEABLE))
>> -            continue;
>> -        if (ksm_scan.address < vma->vm_start)
>> -            ksm_scan.address = vma->vm_start;
>> -        if (!vma->anon_vma)
>> -            ksm_scan.address = vma->vm_end;
>> -
>> -        while (ksm_scan.address < vma->vm_end) {
>> -            struct page *tmp_page = NULL;
>> -            struct folio_walk fw;
>> -            struct folio *folio;
>> +get_page:
>> +    struct ksm_walk_private walk_private = {
>> +        .page = NULL,
>> +        .folio = NULL,
>> +        .vma = NULL
>> +    };
>> -            if (ksm_test_exit(mm))
>> -                break;
>> +    walk_page_range(mm, ksm_scan.address, -1, &walk_ops, (void *) 
>> &walk_private);
>> +    if (walk_private.page) {
>> +        flush_anon_page(walk_private.vma, walk_private.page, 
>> ksm_scan.address);
>> +        flush_dcache_page(walk_private.page);
> 
> Keep working on the folio please.
> 

Ok

>> +        rmap_item = get_next_rmap_item(mm_slot,
>> +            ksm_scan.rmap_list, ksm_scan.address);
>> +        if (rmap_item) {
>> +            ksm_scan.rmap_list =
>> +                    &rmap_item->rmap_list;
>> -            folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
>> -            if (folio) {
>> -                if (!folio_is_zone_device(folio) &&
>> -                     folio_test_anon(folio)) {
>> -                    folio_get(folio);
>> -                    tmp_page = fw.page;
>> -                }
>> -                folio_walk_end(&fw, vma);
>> +            ksm_scan.address += PAGE_SIZE;
>> +            if (should_skip_rmap_item(walk_private.folio, rmap_item)) {
>> +                folio_put(walk_private.folio);
>> +                goto get_page;
> 
> Can you make that a while() loop to avoid the label?
> 

Ok, I will make this corrections and send a v3. Thanks!



