Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C251CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 05:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E3A8E0005; Mon, 20 Oct 2025 01:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E49C8E0002; Mon, 20 Oct 2025 01:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4928E0005; Mon, 20 Oct 2025 01:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3568E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 01:38:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8028E11A844
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:38:21 +0000 (UTC)
X-FDA: 84017387202.06.387B8BC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf20.hostedemail.com (Postfix) with ESMTP id B4D2F1C0003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:38:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cReZxwaj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760938699; a=rsa-sha256;
	cv=none;
	b=m12Kwfy/udUDl0cvRvK0xwPJIF5EJqASo330b0hez0apmqmABbpNoqCkiLhYwlCC8RqL4D
	NfMD8KcPnPikhm1E720nzQkPwDRWtprSo1u1kCnpVNB0PhiV//G8eUjWmaxsPKE9mS8HEt
	igTXmkaPlgCSc8RcBsfHpOBr9kRfjx8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cReZxwaj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760938699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+T4HiC8T5Xao5e9CPsuaqFg4i3G6+1YBt+zAGdvVws=;
	b=3cVhUUSqDQhy4z7wldYNNXKketj32wBknYEhNovOyKHqEv9ebFj4OE0tlKMPLUnT2V7BQZ
	/vlKrFYgq6in97L0nwZwJno1BqiMt3Mo5C3wbvkBPfiX/oRK4CnBalODs3gthqdeSxtUB5
	sGX2E4hsrr9hKufC012qJ16AseLw0eI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760938699; x=1792474699;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=34fldmSOk8nJAh4latVatdAliKdxeQL60mo7ncKT1OA=;
  b=cReZxwaj29gsrAw0kIA1CtxPBoRd0r09aWgVG/Ko+qGMsnx+Zw0npjqT
   HwGaZWf+ke4ippv02WffKV4U9crfdxZqPbZO1Wp2t79LJAzP4QOGTyWKR
   RXNKh1Yc/uGNSNxDOUNX9crfgoBKOej45HPbRaJuLasGNczhl5WujsZhr
   vYqgfVAqyty2gL0UmhdKmk9oWyI913OUsMmNt1wjpDLwLGd6XdqstI/3e
   WCGZ5R5No4qlNwSPpVmzhEksccX/bwjY/obTfHfC8uBeFjZtu6lKhlFEh
   GPcIw0UqwPpom8Hd5zBgcXxV188jEnZ42upr6IfRhazS/18ikUogkHYLh
   Q==;
X-CSE-ConnectionGUID: UP7A4EcnQRCbZ1AEjweVuQ==
X-CSE-MsgGUID: HV+DT29RQpWRM1u5k6b8Ug==
X-IronPort-AV: E=McAfee;i="6800,10657,11587"; a="65668766"
X-IronPort-AV: E=Sophos;i="6.19,242,1754982000"; 
   d="scan'208";a="65668766"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2025 22:38:17 -0700
X-CSE-ConnectionGUID: 3+CThLmvSO6V5/F4GDCApA==
X-CSE-MsgGUID: RsoVDXakTFCTuMkAqrRqsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,242,1754982000"; 
   d="scan'208";a="214214521"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2025 22:38:11 -0700
Message-ID: <13d660ea-9bff-47dc-9cd7-ae74869edc5a@linux.intel.com>
Date: Mon, 20 Oct 2025 13:34:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: Fix stale IOTLB entries for kernel address space
To: David Hildenbrand <david@redhat.com>, Dave Hansen
 <dave.hansen@intel.com>,
 syzbot ci <syzbot+cid009622971eb4566@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, apopple@nvidia.com, bp@alien8.de,
 dave.hansen@linux.intel.com, iommu@lists.linux.dev, jannh@google.com,
 jean-philippe@linaro.org, jgg@nvidia.com, joro@8bytes.org,
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
 <8cdb459f-f7d1-4ca0-a6a0-5c83d5092cd8@linux.intel.com>
 <d1a6c65c-6518-4227-8ec3-f2af4f7724ad@redhat.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <d1a6c65c-6518-4227-8ec3-f2af4f7724ad@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B4D2F1C0003
X-Stat-Signature: 7jnxqs3fbj7nrhzda18jp5k1f9u1go1j
X-HE-Tag: 1760938698-660241
X-HE-Meta: U2FsdGVkX1/3SOIVRzzOyPuCnSCbRqdWj8S84dLmrUKaAHODvACNpg0NR94XfZs7onwsdX0RR3KvSvioMUWsa3ETg27Gvu8VT7+sGj7u8yo6brKJlwGtE3HdH0neJznTMeHmomzJRiJV+D93yqwaVpBgec7j62YFT5CGc5mhayd2Kl2oxORCHB5mkp+Z7OfDM0hYNVuNiH2+srkr8geXhbv4CYw8qHh7lhZQzuKu8ID729mOeWsRQt6Z+FfeAQ774YM5Fp2fNki8uS+JQvVCCKDQqoVdfIToSYG0Zpmj0zz/utG3Rwkrcul3+rirgowxOlYHILS72xNPdLEuuaD46E0hcZz762nD68+GX939qkAU8ldV6qUQiovuDFkb6H7KAdvZgXsIJxxZMvO/36FZ5ov7LoGKa3ixiS2Al7+bQohjZpuZ8DoYLe0v9nMFyKNVnIzB9Q/l1ZHOYqUfbYULK0vY+sqVz+4nOnSOVTKUqujeV8pUqbvSZzxB0UAKBaG4B1vdABylaZ++nzbUEAXpXn4R5qXehlCBtNCkoYhfiacd3V0jRqxnDFOsl6Ts0slZU35id5DBsdL3bRBRE2w2BvAJtU0o9X77JN0uIqrinGKJ0Di94U8i3ZVJSTisglBibo64MQwSurowCL+awzE5eF4QpaKwgX0SHn03cdG6cXs73nPo/tgINj6b6NzAhycgWufh/gRX8Yybk5H2ayg8wqWwI0AJqPorrW9qJtjJ6iwYQ+lqKtAZ1NF1do4BQaQWtR8cTp54NAmR1SPjsShlNw22n66NIzIp1cxrQOUFPZ9kSY/cfD0QgS+olJb89Dc5HTTtF+m9xq26c7ZJfSuboN/x55UCABvG2WDIFgojJI6j6eE3hx7KOEYXeQo1TLb5dc2vfJextjDhMThkLI8mm/uK72ntvO2xdGYf/abQaXETBIYhztYO8AgilG4nkYNiL1FeMwSQOLo/MnbeFyD
 G5H7NGnI
 hVy7+EggKAqKtBJq9BnETAQbH0is+Nt4BAYOZDOOt9r/dwlHxn6SqsAR+FaVsIfICHSHEyhL4xgCMDTov86U82o5BNt1JdKUOgjIAon2nmR1xzQjieUTJMS42K84KnCvwvWw3HEhE3mhd9E7MgZns38GXwvfO9wosyd1hg4/PYqTvMqyf3277wznw0NORvoRBn24o9aCwEFwI/DruslJJS4VQCumSY32FeOe6D1jaeIXyIjS6ro9EUKwBay5/soQjLD2pRilt4f/bP1xk1kct1o3NV9jce/2tfyNqi+s5ep9yrFmEkuigykgsfE4oJNzgnqbZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/18/25 01:10, David Hildenbrand wrote:
> On 16.10.25 10:00, Baolu Lu wrote:
>> On 10/16/25 00:25, Dave Hansen wrote:
>>> Here's the part that confuses me:
>>>
>>> On 10/14/25 13:59, syzbot ci wrote:
>>>> page last free pid 5965 tgid 5964 stack trace:
>>>>    reset_page_owner include/linux/page_owner.h:25 [inline]
>>>>    free_pages_prepare mm/page_alloc.c:1394 [inline]
>>>>    __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2906
>>>>    pmd_free_pte_page+0xa1/0xc0 arch/x86/mm/pgtable.c:783
>>>>    vmap_try_huge_pmd mm/vmalloc.c:158 [inline]
>>> ...
>>>
>>> So, vmap_try_huge_pmd() did a pmd_free_pte_page(). Yet, somehow, the PMD
>>> stuck around so that it *could* be used after being freed. It _looks_
>>> like pmd_free_pte_page() freed the page, returned 0, and made
>>> vmap_try_huge_pmd() return early, skipping the pmd pmd_set_huge().
>>>
>>> But I don't know how that could possibly happen.
>>
>> The reported issue is only related to this patch:
>>
>> - [PATCH v6 3/7] x86/mm: Use 'ptdesc' when freeing PMD pages
>>
>> It appears that the pmd_ptdesc() helper can't be used directly here in
>> this patch. pmd_ptdesc() retrieves the page table page that the PMD
>> entry resides in:
>>
>> static inline struct page *pmd_pgtable_page(pmd_t *pmd)
>> {
>>           unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
>>           return virt_to_page((void *)((unsigned long) pmd & mask));
>> }
>>
>> static inline struct ptdesc *pmd_ptdesc(pmd_t *pmd)
>> {
>>           return page_ptdesc(pmd_pgtable_page(pmd));
>> }
>>
>> while, in this patch, we need the page descriptor that a pmd entry
>> points to.
> 
> Ah. But that's just pointing at a leaf page table, right?

Yes, that points to a leaf page table.

These two helpers are called in vmap_try_huge_pmd/pud() to clean up the
low-level page tables and make room for pmd/pud_set_huge(). The huge
page entry case shouldn't go through these paths; otherwise, the code is
already broken.

Thanks,
baolu

