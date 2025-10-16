Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ED74CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 08:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C957A8E000D; Thu, 16 Oct 2025 04:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6C898E0002; Thu, 16 Oct 2025 04:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B822A8E000D; Thu, 16 Oct 2025 04:04:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2C268E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:04:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FB3657688
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:04:45 +0000 (UTC)
X-FDA: 84003240930.09.B677A24
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3429E1C000C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:04:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C+NpQegL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760601883; a=rsa-sha256;
	cv=none;
	b=RrAkoSrH5LEILqZpRwRnwDTkBb4kG1VUZ9sxs4I6hWHKLR1D600jAVg1iEFK89DjQucsXQ
	SGpXrwiGKWtxmWEAzggi47iqRs4siX29rpQdT6myEtp9Deh+5yZ1xaWv7NTsyNSbYvjVDj
	slnhYKLsAYJvJkIsZnS5ZZXrY40mB3E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C+NpQegL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760601883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WhaMXl7ngky6iJb1e+4r/WIi98orfSc+fr92rHFY2Q=;
	b=NGINR+Pzjj0HI1u5M0Aa7uzi6Z4FVNIEVkfIG9tE3v/0a2Q6ikveDo3r+Qf4202ePYXXSi
	WZxqraHvfaAK7Oy5HjENr+z4EcPcVYXKTUirtTv0tK2pqIKBpT6rFGwP0/49gF+ZF7xlu6
	FTvGAohtdlSCN6RvAxtVQ2gAo5TujAc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760601882; x=1792137882;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ffNPg05OO9ZQ+iVrLLpApjwzhDydYcOe6ZOBkwVV7T0=;
  b=C+NpQegLb/Qr47lXtHw7rK1DNLbyOox5DNWRibweCVlwnfxDS8tRd6JB
   /G9t9Ll4PARttCSPMj72pOszfScHj6XeWwEPn3j6yGrjIpGTcUB3OLuIS
   IKNkHguN0vlCrrZkfLOISAWNuGSDmgRC4r+w9KHV5S+ppns0f05l5si4A
   7eUU40Z4ozE1SIN1Q6ssBFnT0hy5+bhNNdc8HuBwhuOy0Asxs0WCeaMHT
   AOIdYxg99nHcOsB9xDlicyHBMqf2OAw+9bTmA81cTTc/XE9/DMXP8wYAG
   uvZMiMz8Cs0TuVnVyUha2WiNSWjx7ksXRzScVzDwc/MLuTl8UBb8Hi5XT
   w==;
X-CSE-ConnectionGUID: 1wsjxGlKQOW1bxvkSm7ZKA==
X-CSE-MsgGUID: XBfcFMxAQoOkubDfm2ktvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="62830275"
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="62830275"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 01:04:38 -0700
X-CSE-ConnectionGUID: cA4TqZ1TSxyq3V7qZWSmMQ==
X-CSE-MsgGUID: I4mYOUFQTfaDa93MhgX5nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="187674419"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 01:04:29 -0700
Message-ID: <8cdb459f-f7d1-4ca0-a6a0-5c83d5092cd8@linux.intel.com>
Date: Thu, 16 Oct 2025 16:00:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: Fix stale IOTLB entries for kernel address space
To: Dave Hansen <dave.hansen@intel.com>,
 syzbot ci <syzbot+cid009622971eb4566@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, apopple@nvidia.com, bp@alien8.de,
 dave.hansen@linux.intel.com, david@redhat.com, iommu@lists.linux.dev,
 jannh@google.com, jean-philippe@linaro.org, jgg@nvidia.com, joro@8bytes.org,
 kevin.tian@intel.com, liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, luto@kernel.org,
 mhocko@kernel.org, mingo@redhat.com, peterz@infradead.org,
 robin.murphy@arm.com, rppt@kernel.org, security@kernel.org,
 stable@vger.kernel.org, tglx@linutronix.de, urezki@gmail.com,
 vasant.hegde@amd.com, vbabka@suse.cz, will@kernel.org, willy@infradead.org,
 x86@kernel.org, yi1.lai@intel.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <68eeb99e.050a0220.91a22.0220.GAE@google.com>
 <89146527-3f41-4f1e-8511-0d06e169c09e@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <89146527-3f41-4f1e-8511-0d06e169c09e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3429E1C000C
X-Stat-Signature: c6siuziuaxe75z53gg7oc8s8ghxrh5sp
X-HE-Tag: 1760601882-239743
X-HE-Meta: U2FsdGVkX1/lem4bPeIZVGW71R7PMCuCzFjMs6izD+6soWwAxOvVq5HrVuKxReES5bHNfH3dzMkpqxp5Y1qnmpLhGVH+4KlgupMY3fz/c4nS7VpH0ocWYA4zeyOrpgl49NZoJRYz8xyqeZ/F7P4kOYu0Jz23vxkESQWrf2B2cy8majSWr+WlS3X66Gnoc0jFPAdHZiflAhu/IsIebF9VjDbRhptMaZxY5HFqY0sWu/NhFK/7bOXo4QyXXzmErjJPYK2EHCoOrpJqrlbPB9mIWsHtWRaDrbiEXg+uFWr1nZaUnPN8RCZVyoGadxBOTeWah0FoC6FRSatZfK7ThY3waoeA6rXxa+Yw6SfysJSG6ISENLBbFvHBB74u1lgXF0f6WTp4/34VhFr0nh3ScSYfeXOmfMgTF0slcKLJI8XFfLRZcxSHz0zq98NFg1u5693R0i8JQYaBWcp+2fpkXgW3Ss+ug4RHIWN2Xxa7iGCdslw69NXT0O+GivTzKvukefTyXe93w/pqcTUcKb6NB36ma3KCu212X0TaX+W7eC+KqEkdUaVdXMR/1YS4mJQ4w+MMX+YzdY8kJE61orae9zPdbDJIVy3FXGzqu6OAUk31RDCOcTFMq2rPvV13K0K0azYiXa+SZLNShjfEACmk5V5J4G6H+Sz0FTJjLX5oy17bOt9jTkrGJcdvlQpvVlzrvaByVOMWjIqp736uoTreaDL0/2oGCAPvcnpL1bJz3SPzEUsD1zuRydE1M4988bC/oWtgmfg8TmFtq/80dWPJN5d1A5mzzcCVNjWuwcI6waqBwrBqTc1FHySmPwIV53DmO2a3gU1sWB6k4/PmRjcyj4bh3i1q6jH0C2GnmDkYz3W8zgWN6gw37oiBFspWiW69zvk8datJDHbbrsirZ++rqzJULicz6dWB1xbZs3glJeY0S0UOrXaEZPQ9imvIAUv8wTnBpVkHx7RciB1h3UlT7Uk
 5zRGKUaH
 dK1YBSZnIE4P9NQbKWPgU1IpOKnVmrFBRQlH1cpB72eVqnLASuH8iGWqy5Dmb9LdgQWr57WyOTjn/KmJYtP3cPzLI2UiOY703opTf6NYqhzDNQoRFF9yi9dOASi005b3qt75mEEjE59Xz8Z041P2eYNlda7KdJl8xK04porISxjbArFP8x7pzICCneQogYd/HTFROoTC/IEbwVwssGvii40oFcPWBk8VpDq+DwVVcym+b9wqm6CPjfyLQ5EmWSsxeVFMX0zWsmiG11dwo7didjzQqU4ULDViv8PEvBfA3y96AjnY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/25 00:25, Dave Hansen wrote:
> Here's the part that confuses me:
> 
> On 10/14/25 13:59, syzbot ci wrote:
>> page last free pid 5965 tgid 5964 stack trace:
>>   reset_page_owner include/linux/page_owner.h:25 [inline]
>>   free_pages_prepare mm/page_alloc.c:1394 [inline]
>>   __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2906
>>   pmd_free_pte_page+0xa1/0xc0 arch/x86/mm/pgtable.c:783
>>   vmap_try_huge_pmd mm/vmalloc.c:158 [inline]
> ...
> 
> So, vmap_try_huge_pmd() did a pmd_free_pte_page(). Yet, somehow, the PMD
> stuck around so that it *could* be used after being freed. It _looks_
> like pmd_free_pte_page() freed the page, returned 0, and made
> vmap_try_huge_pmd() return early, skipping the pmd pmd_set_huge().
> 
> But I don't know how that could possibly happen.

The reported issue is only related to this patch:

- [PATCH v6 3/7] x86/mm: Use 'ptdesc' when freeing PMD pages

It appears that the pmd_ptdesc() helper can't be used directly here in
this patch. pmd_ptdesc() retrieves the page table page that the PMD
entry resides in:

static inline struct page *pmd_pgtable_page(pmd_t *pmd)
{
         unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
         return virt_to_page((void *)((unsigned long) pmd & mask));
}

static inline struct ptdesc *pmd_ptdesc(pmd_t *pmd)
{
         return page_ptdesc(pmd_pgtable_page(pmd));
}

while, in this patch, we need the page descriptor that a pmd entry
points to. Perhaps we should roll back to the previous approach used in
v5?

I'm sorry that I didn't discover this during my development testing.
Fortunately, I can reproduce it stably on my development machine now.

Thanks,
baolu

