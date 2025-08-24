Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89B0BCA0EE4
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 01:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518506B009A; Sat, 23 Aug 2025 21:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0366B00A1; Sat, 23 Aug 2025 21:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D506B00A2; Sat, 23 Aug 2025 21:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 330D16B009A
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 21:37:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B35BF1A07B1
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 01:37:52 +0000 (UTC)
X-FDA: 83809939584.01.D837668
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id C24BEA0006
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 01:37:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XfIa1Bam;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755999470;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6UBZPF5YbhnRufm437C0PF5qAjXN/Uh/I6Zgp8tz2Ts=;
	b=rg8qsbNHZwlx1V2NZbF9lEDRSiCv2Fc+5pXn4owX9SNMtWAwuHqCDcF4z/h1tA2T2378Z/
	rYpGHbU0c6MLxELePMxx8ikdSz0Ei2nbiDc7qc5D7MYMix++a+Y/PPQpMPUhxVBQ+RBD70
	q59Zg9zAPc4OJ84TVxmWqGVYEyA0ehU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XfIa1Bam;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755999470; a=rsa-sha256;
	cv=none;
	b=ibSWRQuPWw1rVE78Cj3ttd0J3bJWWI5s2vlKl2usKC0lg1rcFS2qh3j78gGH6ayDUr0bGW
	KfIQxSW3MgiUbcj1/nwTJh41nTEbDk3XfVjeGjdfye7cbeKdgvhfv5gJ0vkT9rf9ZcuTXv
	fTEvzFJhe9Ci3Yt81l8zF6dDnDmYu3I=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-61c266e81caso1740997a12.3
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 18:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755999469; x=1756604269; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6UBZPF5YbhnRufm437C0PF5qAjXN/Uh/I6Zgp8tz2Ts=;
        b=XfIa1BamUglntw2cHDPYuTcKtOXbNekaE5B1B3x7vydeBQE4QtHfae3avSh503PUnZ
         s0W/3tMZv/v1MeaN6JcORyUNyANr25GlrfkMD5wKIBsFtQPNnKLUdOxVvTDvCAffU1V4
         OP98pXjIEjLMivLlo6qUuEUyHkZ3XPDdBvcHS+riJmTWObLyDcXtsq8rrfOSiX8bID27
         +EOkUe8zIuYBhiDulIDxM7XDvULPMFdlPVdHQxGhFNFh8mBjUYusxzBM4Kvfe81KTOQg
         0X/qJN/R1Jbdyr2CHgI7GUWtQWD1JV75Uif3VmqukYELlqEhcSQE+dLG+JGy1pmTs+j5
         /Tig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755999469; x=1756604269;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6UBZPF5YbhnRufm437C0PF5qAjXN/Uh/I6Zgp8tz2Ts=;
        b=f8xicxKAw7jiwi/YwItmvkBW1nTWBBMmqIXK0wp5uPQA8/osqmDhrKJTGmJ2lb3hLk
         oKRBkpV3QtjJ/l9se5BmXprQ1ju7mIzIqtr+W+7XztlYCVOnGIMVgJdjxu6ZajzaVQ8e
         RvPozOcFEh3XGOUZjYmOarYvW7rPvE+K7f9Eso+OYpsP+lkWaUf6O86lcE02KVufc3RN
         6owzhgJBD+hGeb/OKOzcw8Z+NMwC3+/w8yow2e4oop/h9oAyHifkRk1fNXuqQrDEda0p
         wj46jIrmff38QwLyVCx+nCJReCJ7sX8Ui/nkjTo+tQhUEjhmdtkEEAZKrP3M72DH86AQ
         /v2Q==
X-Gm-Message-State: AOJu0Yzqw5YKCqgdB/urjA9/9vZMGn4Uz8mGSxAXh7UMtP4MHWy1fuXK
	zFbIaFPmoP6xMlEIoNHpzp26xjg4XevqBErB7QWVyDX3qyNEq85gvq7J
X-Gm-Gg: ASbGncvaBIMUTJdyR/y+22C2qfw7gdCmPVQjfQhXwKVtcVhJbU2jRbIW3Wgm8Pjkvgh
	tYwZhCaHLfECQU7KuWZTxkl3BiXA2TmGiDZL1hoWjm1gElt5jqw7ffZ8r5aaCp8vFhb2x4wq0xf
	tpwNVXfevEXB6stoml35GYjMocEhpUUPunsYoiNbCTTlqRB7ij8boXV1LYZjkTzLTY/xrSzBxzv
	nVVGZtzOdQvVqD/lw+yJgXOJDEUeyUstiwol1iu828k57AlMMFSBydsP//yQxtpJ6b3fdK2u9Ej
	8IEZVXXb68+EyPBqxMn2/4FnrvkwmpMQjSNWQ0DMn5QE86mDxUJdZUALE6lyWWACU1/sNmFmq+1
	CooJo7qLiBJkBKxAhUjb81OsETQ==
X-Google-Smtp-Source: AGHT+IHxdAZXliDg4Pz7o7ZUiSoOONIAXZLqOCQdY0hkLH1p+jqAseH5s/K0XVWooeUz0LaIMhIjAQ==
X-Received: by 2002:a05:6402:5057:b0:61a:8c7c:a1f4 with SMTP id 4fb4d7f45d1cf-61c1b48f5e9mr5913145a12.11.1755999468866;
        Sat, 23 Aug 2025 18:37:48 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61c3174f4d4sm2476072a12.54.2025.08.23.18.37.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Aug 2025 18:37:47 -0700 (PDT)
Date: Sun, 24 Aug 2025 01:37:46 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
	rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
	baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
	sunnanyong@huawei.com, vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
	kirill.shutemov@linux.intel.com, aarcange@redhat.com,
	raquini@redhat.com, anshuman.khandual@arm.com,
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
	jglisse@google.com, surenb@google.com, zokeefe@google.com,
	hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
	rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 03/13] khugepaged: generalize hugepage_vma_revalidate
 for mTHP support
Message-ID: <20250824013746.bvsz3vajjj2kphrl@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-4-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819134205.622806-4-npache@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: gab4ezyshixoeczjwemsrgr7a64qgtco
X-Rspam-User: 
X-Rspamd-Queue-Id: C24BEA0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1755999470-29440
X-HE-Meta: U2FsdGVkX1+cSS2MYqU6P3IHilikqSnhuvKCOTHuGicR5klvkeOS3n05Cox7LeflwShY0kcFcxz1EeBB96cGRSYAXulJHoeCw7nyhijj+blI0FWAxjGbo44/aG6YBEzIINr+maWQjSd8am3mXJpeRnX8hfWALfjWc1PwlBDr3URN866UtNLLNhc+mVZuwJRKJLaIDqWyUNLw7Cl6gJLecnMsJUR4uK/8753MXD1OUW6kfxvbroRXmlDVU+erCTMbgbM6DRK5yX3PPh5cfhpw0k9X5F3YsCkfL8NHBT+gEywuf0TW8dDAeK9uKkIDHMOneYC0p5m1uI5y8+9cDJ02e3fXGzitEgXlweX4oTf4gSRsX3gq8bMwf9eiZbwelsLiNfUnoHzV62jYS2nMyvM9ku5KgKemx/diKW4e9fOclVSf6hhzZxVeN9V1dj+R5eWTkmLL8qeH0QBSDeKwfYUCt8AblujtdRIBG60lvE2hwbG22RDUrHXcZROljvUZuE36g9CtwKjAwJ3POXW5+BpldPolbDfWY9Dx3pxRvURH84+e+DD97h7oBCH9gt0aiO4Ksqd69BAEjDssb8CIuBZ5hKHdBr8DbWfgKzuNBZ+Q4U6QPKzTHchr+fWDGiS0OiarpGJq8rIXxjjRT+sjDOTchLntlE7bbEWPqrQw79c92iwQ+zGaaEsQzfcu0sd3M48IVBVtLE0XwZpScx57pqaOAMlTBGYgrBcMqxeLuzfzb4m56Z2zO1ptdPlqm/6c6kfd83jUGqt+iTHZjcibjGpu83TFrd9ATewi4/0y4nrgVD+jyFmI8qi+WXhhMz+ErThBQCI7mvebJtz673pigqfR4e6rYh3hCBFCaoJmU1BDHEGQK+EHMaY/rl3BBqgpOY5l/qMzr4Vods6chK31WYK9SeFf+F0R7Ve7HROHU0sqjJDDLLMV9LCzD1shNNFH+DzeueqAt7Sr9Jee4LmNgwi
 H4Xxj/ZJ
 X9H521LDkh9VfuKrqELLJUnkSGMY2QaYbqLvaM0uDGWaTA4CnIPXi08piOeIMFtHi2732XBw3HO/PpFIWoO4quWzVrQrnmbSCn0i2x0cIBtDX0LjGcq8QGSQuPsSUGRYbFkUAwQvSw3Mk/nTrkvbQjrAPHMFK+Z7fU3jVlRKO/vJLbe+s3K/3I7sAtecQ0iw2elqNDJz32CdwHjTsmVRr+ILq7IHwpXwp4BxRi200I5B8bMQs90qKLwx9CwWs4VVZ9LJHOixn9D8L4EcyEdqH2aYB7ZZ+1FW0boXSnxxaNjkXhClpkDqmIXsT5LCL61xfhVli8bE8aXz0asnzxsyA4seI4wp9/85lLOqmvpI2Z2Det1vxM4kAPFzkjiESMGwgatb4ROhcB9ggh3RjUjdBeeStEq/IhUu3U6+rb4dGBXJ3iOA7V5XI338jESpgG2Q5bsrwSZr2juIpZc06pLgjPHS6SMq1Uqvf7w1vkilY0HwzXZtXja9JJpw+BCEVnEY+ALXp2GylG8vSch3CX+EAXcw34CRyDbH3NzpalKz/fTYzBaqCkroehEL05MNEtmSd4pdEye+S69teJ/RugqKj4k9fvHLxIyf0RqOy0DKKfMDj1qAvjNZo9Av5aWPRDknWQVip9XtfDWW7jEaRIrFVL4/1Z7Wd5kWnkV7A6nOCw2h1qSO36iFI+O6FRiac4EhRyWB70Gd5H6DWECy692nod7z00jyhNBE9tCKY4JTexe8F7z7dYhEzCdCWIr4Px8wfSEMgUYzfB1+xs78xVVx1uRDKe/RhsBs3y/ovEygjEpnN1jV2X4IC49k8ivNPXdaFryHV6RqQofVJN0MvDHdFtgsLXj2I/Pe+6kn0lou+2U1MDkfbKtCbLRwz6PTvNRXN4tlecGAWx75M1Qg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Nico

Some nit below.

On Tue, Aug 19, 2025 at 07:41:55AM -0600, Nico Pache wrote:
>For khugepaged to support different mTHP orders, we must generalize this
>to check if the PMD is not shared by another VMA and the order is enabled.
>
>To ensure madvise_collapse can support working on mTHP orders without the
>PMD order enabled, we need to convert hugepage_vma_revalidate to take a
>bitmap of orders.
>
>No functional change in this patch.
>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Co-developed-by: Dev Jain <dev.jain@arm.com>
>Signed-off-by: Dev Jain <dev.jain@arm.com>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---
> mm/khugepaged.c | 13 ++++++++-----
> 1 file changed, 8 insertions(+), 5 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index b7b98aebb670..2d192ec961d2 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c

There is a comment above this function, which says "revalidate vma before
taking mmap_lock".

I am afraid it is "after taking mmap_lock"? or "after taking mmap_lock again"?

>@@ -917,7 +917,7 @@ static int collapse_find_target_node(struct collapse_control *cc)
> static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
> 				   bool expect_anon,
> 				   struct vm_area_struct **vmap,
>-				   struct collapse_control *cc)
>+				   struct collapse_control *cc, unsigned long orders)
> {
> 	struct vm_area_struct *vma;
> 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
>@@ -930,9 +930,10 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
> 	if (!vma)
> 		return SCAN_VMA_NULL;
> 
>+	/* Always check the PMD order to insure its not shared by another VMA */
> 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
> 		return SCAN_ADDRESS_RANGE;
>-	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
>+	if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, orders))
> 		return SCAN_VMA_CHECK;
> 	/*
> 	 * Anon VMA expected, the address may be unmapped then

Below is a comment, "thp_vma_allowable_order may return".

Since you use thp_vma_allowable_orders, maybe we need to change the comment
too.

>@@ -1134,7 +1135,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> 		goto out_nolock;
> 
> 	mmap_read_lock(mm);
>-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
>+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
>+					 BIT(HPAGE_PMD_ORDER));
> 	if (result != SCAN_SUCCEED) {
> 		mmap_read_unlock(mm);
> 		goto out_nolock;
>@@ -1168,7 +1170,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> 	 * mmap_lock.
> 	 */
> 	mmap_write_lock(mm);
>-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
>+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
>+					 BIT(HPAGE_PMD_ORDER));
> 	if (result != SCAN_SUCCEED)
> 		goto out_up_write;
> 	/* check if the pmd is still valid */
>@@ -2807,7 +2810,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> 			mmap_read_lock(mm);
> 			mmap_locked = true;
> 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
>-							 cc);
>+							 cc, BIT(HPAGE_PMD_ORDER));
> 			if (result  != SCAN_SUCCEED) {
> 				last_fail = result;
> 				goto out_nolock;
>-- 
>2.50.1
>

-- 
Wei Yang
Help you, Help me

