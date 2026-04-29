Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7E57FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 297D66B00A4; Wed, 29 Apr 2026 14:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26EE36B00A6; Wed, 29 Apr 2026 14:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185896B00A7; Wed, 29 Apr 2026 14:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 073A86B00A4
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:22:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2D271B9514
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:22:19 +0000 (UTC)
X-FDA: 84712413198.22.4875C4F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 95F4B10000D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:22:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KJVieBw/";
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777486937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gY7VJIEyO/W3nZC3qbRdfDIZ/AzOw1XW+8RhXie+zvE=;
	b=vAebDKc2fOcFVSGAGS13PPzX/+D1yVL2RRUJQIliG9OfaJ96RrQjOpXhiogtfOblM917W0
	wSa+CdG22izyhkHxPMaKSzaNgrJew9yRpy8mcQlZC5B8LtO7TUfIaS0GRsZfHbP13uy/pM
	+CfdTNvRDJHhlms+FYcTqCYHvTHMCK8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KJVieBw/";
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777486937; a=rsa-sha256;
	cv=none;
	b=yPUFMcC3DCQ5dWBzG96DcNDbo6ImH6YcuPWLx0jsywijqWjo925ACyfrsmqGgdEfx1YC2V
	TibLPFQuIEZ4rv76vSe4akoAXvtJpChaw+bwpl47YodFrunQxS94S60oZ2iaK+H0ht7waH
	MBF/P6MvIS7EDMbLW75X6n1i2LidiPA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777486936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gY7VJIEyO/W3nZC3qbRdfDIZ/AzOw1XW+8RhXie+zvE=;
	b=KJVieBw/5qist8RVzb/PSTWyoI7pq8oA4bnVtkRx5bQ6i8F47LD/RWwjbjFO/vJxsPXWVE
	pgbi8h1vrbvcQhVIvu2JfF0IP6RgPE+73mo4W18EZEn4JWac9O9SCX0LftHIoFZEJVamNM
	+fBJjzQ6ugRu+sayA0F0sxYr4cbONh0=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-yumLprCvODaeN5hSJH7Jsw-1; Wed, 29 Apr 2026 14:22:15 -0400
X-MC-Unique: yumLprCvODaeN5hSJH7Jsw-1
X-Mimecast-MFC-AGG-ID: yumLprCvODaeN5hSJH7Jsw_1777486935
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-65079af1ee9so81470d50.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:22:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777486935; x=1778091735;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gY7VJIEyO/W3nZC3qbRdfDIZ/AzOw1XW+8RhXie+zvE=;
        b=EA918WfhCWIyCVpAZbmIUqfGpa+4Hba5VmDTbHlJrzHrH3OCi9MT6hwO0T7A2oCz3u
         0cZW6M5FND7s5OjS88wgw9IWGWtVkP283j3pUu10zaQk9l55Eh8E7TGOaI6xuyMwapgt
         ZJRUzfP3ywgHMfaWWtNr3vwajdW37CIVtCjakYj8NtJ235Ucfnh0F4fuVyLS/uu+5wfE
         q4v3dh1g02+e/pdsCpxaz/CL90VUx/3O3AjbNnr5646LLjgSy4gxy+gZiijQ7QrWpw12
         7AF6Wq31pO1xyNLbj4Kee7UB+OrjCFti6wfDdJDZcg5BCqd8T/gRzJBHrAuvYCl6+Qdp
         seGw==
X-Forwarded-Encrypted: i=1; AFNElJ/yArG3Z+Lcg6BjtL6UvCoPHGKVytv4YFLFnl/xx5eZPYbTL1TypghB5yKYKgHQeVVGHGnE5pbHCQ==@kvack.org
X-Gm-Message-State: AOJu0Yyyz493O7AP0C+fNbfiisD5hBD9fSJSM5DEAOXw/yTH5xECgomu
	bIgVmY6FJkgwzCgU1xW2I1XcndjSnKH2Nm9sJWL2YWj8c28/nIgxZPv54Wj1I9bUQL+9nimV+6y
	i1oUrWtP1lhFOlI7bdQwu1INiEToqb/SnzI9YzN8zhxxKOJ1sYEMuv9esyMZoPtM0Jxp+UpUrnt
	fi421fq5E+l5MYPSWe2JcBfdkJF6w=
X-Gm-Gg: AeBDietgII5FlQbOsH+GTbakpcL0aZw2Lh2CgSl/TSfCGO6xNrGrP86G4B3CKRdomL9
	xUpRXFpQYiAJGDI4mb6bUo2y3jXkX9kNb0WrDqx6HLnRnVxVV4586gNjBZ/oK0XxciVP2oVi9U0
	MiepfCVeOrWmcdkfPiqBcrjQMU6HKkW82CYwE5nj0EkWHqM15uHcQcSfinBd6qNZlasLKX0ZL8+
	6DXjIo02B6RwPg5/+tatMg9FfO7BUby3Hai9VDs01Z+rI4kmhg=
X-Received: by 2002:a05:690e:4808:b0:653:1b1c:1df5 with SMTP id 956f58d0204a3-65bfb618207mr3992070d50.22.1777486934827;
        Wed, 29 Apr 2026 11:22:14 -0700 (PDT)
X-Received: by 2002:a05:690e:4808:b0:653:1b1c:1df5 with SMTP id
 956f58d0204a3-65bfb618207mr3992031d50.22.1777486934364; Wed, 29 Apr 2026
 11:22:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260419185750.260784-1-npache@redhat.com> <20260419185750.260784-10-npache@redhat.com>
 <5564e170-d052-4445-9914-70bfd852d3b1@kernel.org>
In-Reply-To: <5564e170-d052-4445-9914-70bfd852d3b1@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Apr 2026 12:22:21 -0600
X-Gm-Features: AVHnY4L3X4jVTb8LgOcxKjQeysiycYOCHFfdu1rzktXVmJtNDEVN92iFQ6rxy7s
Message-ID: <CAA1CXcAuD0EfrNro0VGupeMQTXMLzutfQAdP942YbQ0AJQA5_g@mail.gmail.com>
Subject: Re: [PATCH 7.2 v16 09/13] mm/khugepaged: introduce
 collapse_allowable_orders helper function
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, ljs@kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xmUWnsif0gaoV4pEh-3m_SV6Y7VI1qwz2xxBRTq7x8Y_1777486935
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: x7dtbe7muhanforcntccn74g9qhdi7ix
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95F4B10000D
X-Rspam-User: 
X-HE-Tag: 1777486937-240725
X-HE-Meta: U2FsdGVkX1+RQHhTHAQY6o/FXylNdGz1fEz6tMAvUGGnnUfzg1E+Uj/9c7Vp2NpwtGETvm9iv7CrND8kr8bAXPkcni4/6VbvdeDez81zzYjyfIS1RtBeFVsVYo9F3g/hj8X0ZMVIzkMLmH4nXKJJ3q+lq4xrymyNtEg54unTB/MDd6lp+3IBLCk2XRzWWW/2v6y0Dre8JL3rfUeR5fuRYnQm6/XIYztV28HIjx2hjAIWbKbyCnO4lwlnl3foS4riojsGWi2KtmWCwXTMj2Fls9Dvy8PXdOpLxhOcVqAAk+nQf9aOd9ZDKfYecNOZsmFUapkLwK9QY90PmmQ6WDsYKmJh51XDBWSHp8pqgAhvEUIBSCN7tKzf418TcI7lOm8j/ZqUc0rXHs5wPnZjqYi7WWukj2G+KCRUsfCaIl0RPDNAMGuOCIMXDqmd5FhcWO5QQV2ygiGzWCHr2s5MoBnu+B4pJukJj/ExX2Er969b+zyvme4qZgw7YAYtwpiwjA4V6Vpf3vUXxtGYBpt43NkzKQDCpP4Th+vS6vcAgxofzILHFAx59BfmxelhfRCWHlad/MbSd58rppgPObONEaL9wRd/rFNgHrVd0COk0Ng7/WVZsptN4MyZ4B7ELPlYLBhmGbBqpHE5N6h8le/Djd/NbzkoSJOSHKr65puaBziL4OYNGTWyiDt4JS2hisQS05I1StKzU0EpSiR41bsZL8cubzWyklyMG2JOs+bMXfooKcZr81eISFd/hABgDaVGJjyrKtfzwEoDRZFUndDrJ7PHVq+GJ615yuu4tSURENSO4BcMr3QoXkOFXTUwkOTptLXEKzXaf/UV7ND8tjQy0eVoURTonAnlyYx6CW3nI+ovCMzApsoqArVMFLxazB+FVp5XQX6NXcYGGzeoxYgk/+OeVXkzYVKtXkU6WNCIW8Eys1fNI118DDDZe+mdVtBxtiffAekSuZ2EMv2fe5uQd45
 nxdttCHg
 58NoXiorKTzya8h7up6kwuAnPgZhS6GKMjY7Xz8CHs8Rcxk7HwcsohMv0rWMp39zlJGavAPcc/TgYVh4/PCldndBJUFW9pqBK51kZomfQyeAQe0eQCCGa3O14erWmHSKjUnkqMhlg0d0CBH/ufeUjVy7dE6B99TTvMZ04T0MLNCe14MhlsZR7VUD/vuHf3+1t2ItqM40pnfRimXFTfXCOJ8AuzUwOoMFx9DF03ItGyifnIoUDlgI/i3mFTYS47bWWu0M+1cDt0nYm2kpa732D4KjO4J3cwkEswNnLOrVazCpVzRDg5Z/ARZwbgZGWxlC7588/AL6I3nQJSD95RFL9qYg9WihSxtHA3UMxCSaKyC2kARuVmRe2y6yN+ZwkcPqrd/HaNFlveDxSzOsOgC+cX1P+j6X0fPQG8bPt2/8gojTPX9OTKGYISixaByKSqgHGEthiu52EnpIIS7jfmdwvrqehoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 2:24 PM, David Hildenbrand (Arm) wrote:
> On 4/19/26 20:57, Nico Pache wrote:
>> Add collapse_allowable_orders() to generalize THP order eligibility. The
>> function determines which THP orders are permitted based on collapse
>> context (khugepaged vs madv_collapse).
>>
>> This consolidates collapse configuration logic and provides a clean
>> interface for future mTHP collapse support where the orders may be
>> different.
>>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>
>
> [...]
>
>>      cc = kmalloc_obj(*cc);
>> diff --git a/mm/vma.c b/mm/vma.c
>> index 377321b48734..c0398fb597b3 100644
>> --- a/mm/vma.c
>> +++ b/mm/vma.c
>> @@ -989,7 +989,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
>>              goto abort;
>>
>>      vma_set_flags_mask(vmg->target, sticky_flags);
>> -    khugepaged_enter_vma(vmg->target, vmg->vm_flags);
>> +    khugepaged_enter_vma(vmg->target);
>>      vmg->state = VMA_MERGE_SUCCESS;
>>      return vmg->target;
>>
>> @@ -1110,7 +1110,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
>>       * following VMA if we have VMAs on both sides.
>>       */
>>      if (vmg->target && !vma_expand(vmg)) {
>> -            khugepaged_enter_vma(vmg->target, vmg->vm_flags);
>> +            khugepaged_enter_vma(vmg->target);
>>              vmg->state = VMA_MERGE_SUCCESS;
>>              return vmg->target;
>>      }
>> @@ -2589,7 +2589,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
>>       * call covers the non-merge case.
>>       */
>>      if (!vma_is_anonymous(vma))
>> -            khugepaged_enter_vma(vma, map->vm_flags);
>> +            khugepaged_enter_vma(vma);
>>      *vmap = vma;
>
> Are you sure that in all cases, vma->vm_flags already corresponds to
> vmg->vm_flags / map->vm_flags?

I reviewed most of them and nothing stuck out, but I can go over them
again. Lorenzo may also have more insight into this as he is more
familiar and has been working on this stuff.

@lorenzo?

>
>
> That's a change that makes this patch unnecessary hard to follow, in particular,
> because it's not documented in the patch description.

Thats really weird I could have sworn I did update this description...
There was a lot of changes this round, so it was hard to keep track of
everything. Sorry.

>
> If you think the change is fine, you should better move that into a separate
> cleanup patch where you only drop the flags parameter from  khugepaged_enter_vma().

Yeah thats a better idea. Ill separate it out, thank you for the reviews :)

>


