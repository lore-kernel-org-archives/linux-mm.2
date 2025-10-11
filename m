Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D503CCD183
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 06:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DBB28E0035; Sat, 11 Oct 2025 02:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98A888E000E; Sat, 11 Oct 2025 02:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0878E0035; Sat, 11 Oct 2025 02:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 775528E000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 02:30:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0933CC055A
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 06:30:35 +0000 (UTC)
X-FDA: 83984859630.16.CA96E1C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf08.hostedemail.com (Postfix) with ESMTP id C1DBD160006
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 06:30:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KlZ3fPib;
	spf=pass (imf08.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760164232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCxpy90P/aXymTR+8lrsDCRYM9btfhKuXlW7Y96vB6I=;
	b=i+F54jjR938oS3eR9sfPSxXzbk1q6DNK1MtB86w3/ZJuK/n7p7o2V4RkrXcWkwPcG9XEtM
	Jux781JHGBqGyCyE+6Fs0fTvZHFZ0rfX71MpWA3TRUt4MhVhvBIw1MxdOjt+hKWPl6CEqs
	dxmt+Cd3OytNVImL9W0uPJp0MihvFo0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KlZ3fPib;
	spf=pass (imf08.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760164233; a=rsa-sha256;
	cv=none;
	b=HdyFw3GxKmApKkpEsexLOIPPgnsLn+dx/w/eGlplrR6N3+RrItAZ946+puPt/JZnhvUyjp
	5c+RtHQ/21SY9L3WMcmMz/NHhUKq9KoazyEtLq3GyBu9AIxMTvpd8MfvOaRR26s0oPErFp
	PN2e1rX9mbo5I9SBjdEPpPl8Pmp6EqQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760164233; x=1791700233;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=864487Lbses3g7FYfEk5gBAA1Q+2nTEqyXpo9mwJjwM=;
  b=KlZ3fPibvjP7Ixt+esQFdd3jIuDFu8eOXyN7plWYigXU0T36ew505skt
   NPauY8frIRxmdSO5cCBTHIXUbEUAUdp5Q1K/cezXBHuHWjasC+I12x7NA
   2WZciLGMT2NZs0vkzCwkaQWoZ1589TShSwLCEJVtIba4JN8nRvTzV91d+
   feT9v3qSwU85n2fcRMz7EgfNjBcE0ceiiR+2kAlOHSRdUo/uEGzcMbmKd
   sEs9f2i5hxJElqRBvJ4OJtXlOsko/Tu1JOOVGnsxsIJzY7/zh62oJ7OT1
   nJtDc6UUqWMBdyx/qQon2nw9vKoyE/nLqKqBH88aGYQ0pysxKpEWgpY4Q
   Q==;
X-CSE-ConnectionGUID: LQAicygySZeB9sGxYmEQWQ==
X-CSE-MsgGUID: MuQrLs7sRkOAjsFWa4DrDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62295790"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62295790"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 23:30:32 -0700
X-CSE-ConnectionGUID: lPvOecqbQc6xhQki/BPBGg==
X-CSE-MsgGUID: AgL/RN86S3CGZ7GQ+tjQxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="180389437"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 23:30:26 -0700
Message-ID: <ce126bc8-7672-4071-96b5-9652e736175b@linux.intel.com>
Date: Sat, 11 Oct 2025 14:26:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/8] x86/mm: Use 'ptdesc' when freeing PMD pages
To: Dave Hansen <dave.hansen@intel.com>, David Hildenbrand
 <david@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-4-baolu.lu@linux.intel.com>
 <9648e990-18e0-4aed-8110-b02f4b45aa47@redhat.com>
 <e4c0c578-50e9-4e65-8e7f-7a6d995b22e0@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <e4c0c578-50e9-4e65-8e7f-7a6d995b22e0@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1DBD160006
X-Stat-Signature: kfa9sjpsmgebkbi9rhqhu4b6rw98bf8t
X-Rspam-User: 
X-HE-Tag: 1760164232-598667
X-HE-Meta: U2FsdGVkX18t9AXKp4mNXZra/thGeaHJR0RyNQ+NK+CroyuC1rWfTh6vS+VBv3lYaqLQkGfqmXZJLnEVgHjQ78nTdLNkwTaQbhKMe5TvMcT7K4KPW6zqSzH1VNXX+Zs+kILzPAoS0VkY8yLgNV4LmVM+V3gGoMzqWhhvPynf/0oXYElN8KyXp+gopv7cdioPflqC07dVehYnPrbTccZMRuLmGZXiWTNm95IkbyNK8w/o1YM0RfdlQ9voPRviA0tef8rAQWLJqBtNXS5tMWjtBXWyBPo1xBHPP06zWSOEtTxosqyILiB6wq4iEReePqQ7IQVP66HNAuhELQWEO2+9t2J2b9iWSCJEXVaLJbKu8m/7rxb0OzJLXdaYYqFOFd9WBPZn/t/yQINkh82XX8K7+qLnCskgufLRBOGjrM8WqqusziJvm0t4ilfAjny8m86PTm5Fns02EWmGNwx1Yy3D/05/BKD20ZHgxqQWIR/0WJkjcPuPZ+tzrTRJK3MzozZrHwdiCpirTGKwGfiRuiOJrlQI5kJKU/wlWR/YXfCcYqOMi2zvHfpxwAdsuCTECiEGQEUSh6ojLr3g0pxz+5R1NM3aExr51bOQMQqS4bqWP7EDtWdRWg9T7n01fCcWgvtjsftn+rt5DU3VkyUDRrVufSyQ39AONacR89vpm54zoQ13C6nQMlwus2TpoJl8PR3uJfKQSOyA5pJDTxg1bplABticB/tC9ffFcj41e6quSaGVFNpgDcKQD+QrxPyFKcrGZji7zQzjs3UcZ3nCO5ZcKZj+P4E+HHa140FD5ETcajnDueOEAv/SQ7plaDTGtRkiWE65JBC4cbR/jHhm921KBBtyCoUxNptEGZwdSb8/oWKbaTBaABaArCOiZMGf0RfM/AFe5q8NJJvJaM122oVp1fM9IaUSaXURJEocpDauWTpabQJWp0o6EeSODj9gHIrBdnvciVcX5hiFs9ftmKf
 n3YJWihR
 xjS3P3HxTpYSPqtzCLngogHll7PZpe2oxEB5RWu9AZi4em4KyCmjPVGUDE7lbLiBgeIu4e91zBYW2p/pp86HUEhoAtzbTqTkVxjQAiUkZS2cPs+QK+fWyKoCjB4RIkj5N9n3FNllp02P7xwD0pJb2JS4MsB2lBOz+5bV4gtRmcK6Vx5GBto2kLmFfKK+iax9e+qPSWZ26bIbHckNr8DJliySbmg+rEE7P1Fpho23vtGs1aQ2YcksYzjl+YktCPgK7sHiT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/25 03:31, Dave Hansen wrote:
> On 10/9/25 12:25, David Hildenbrand wrote:
>>>
>>> @@ -750,8 +750,8 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
>>>          for (i = 0; i < PTRS_PER_PMD; i++) {
>>>            if (!pmd_none(pmd_sv[i])) {
>>> -            pte = (pte_t *)pmd_page_vaddr(pmd_sv[i]);
>>> -            pte_free_kernel(&init_mm, pte);
>>> +            pt = page_ptdesc(pmd_page(pmd_sv[i]));
>>> +            pagetable_dtor_free(pt);
>>
>> There is pmd_ptdesc() which does
>>
>>      page_ptdesc(pmd_pgtable_page(pmd));
>>
>> It's buried in a
>>
>>      #if defined(CONFIG_SPLIT_PMD_PTLOCKS)
>>
>> Can't we just make that always available so we can use it here?
> 
> Yes, that looks like a good idea. I never noticed pmd_ptdesc() when I
> was writing this for sure.

I updated the patch like this,

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6a0bb7fc3148..a0850dc6878e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3203,8 +3203,6 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct 
*mm, pmd_t *pmd,
         ((unlikely(pmd_none(*(pmd))) && __pte_alloc_kernel(pmd))? \
                 NULL: pte_offset_kernel(pmd, address))

-#if defined(CONFIG_SPLIT_PMD_PTLOCKS)
-
  static inline struct page *pmd_pgtable_page(pmd_t *pmd)
  {
         unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
@@ -3216,6 +3214,8 @@ static inline struct ptdesc *pmd_ptdesc(pmd_t *pmd)
         return page_ptdesc(pmd_pgtable_page(pmd));
  }

+#if defined(CONFIG_SPLIT_PMD_PTLOCKS)
+
  static inline spinlock_t *pmd_lockptr(struct mm_struct *mm, pmd_t *pmd)
  {
         return ptlock_ptr(pmd_ptdesc(pmd));
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index ddf248c3ee7d..c830ccbc2fd8 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -729,7 +729,7 @@ int pmd_clear_huge(pmd_t *pmd)
  int pud_free_pmd_page(pud_t *pud, unsigned long addr)
  {
         pmd_t *pmd, *pmd_sv;
-       pte_t *pte;
+       struct ptdesc *pt;
         int i;

         pmd = pud_pgtable(*pud);
@@ -750,8 +750,8 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)

         for (i = 0; i < PTRS_PER_PMD; i++) {
                 if (!pmd_none(pmd_sv[i])) {
-                       pte = (pte_t *)pmd_page_vaddr(pmd_sv[i]);
-                       pte_free_kernel(&init_mm, pte);
+                       pt = pmd_ptdesc(&pmd_sv[i]);
+                       pagetable_dtor_free(pt);
                 }
         }

@@ -772,15 +772,15 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
   */
  int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
  {
-       pte_t *pte;
+       struct ptdesc *pt;

-       pte = (pte_t *)pmd_page_vaddr(*pmd);
+       pt = pmd_ptdesc(pmd);
         pmd_clear(pmd);

         /* INVLPG to clear all paging-structure caches */
         flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);

-       pte_free_kernel(&init_mm, pte);
+       pagetable_dtor_free(pt);

         return 1;
  }

Thanks,
baolu

