Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29047C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7A76B008A; Mon, 31 Aug 2026 05:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3689D6B009D; Mon, 31 Aug 2026 05:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27FBD6B009E; Mon, 31 Aug 2026 05:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F27A56B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:49:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B6311A03E4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:49:37 +0000 (UTC)
X-FDA: 85161092394.09.5BA146E
Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 83950180002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:49:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nZTmAivR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788169775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WpUTaYUo8NvjfAjWzrJ89AEQkaKdbwDPkg6VPiVl/9Q=;
	b=Kits/wU1uz1WCOK2icvNpDd4GDvqQ+NpT2Utvi8+HTPaRxwopOnDn94PJCbN2huaEc6RW1
	pI7e52lVH9n8KI+VKQpPDt+pZ45/YCh4KPciGtHHVHZCn0EzPjiH/5w2irgdmfUfNALXQR
	kwbl/adm688k02xQknWRE+1kTQBeuwA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nZTmAivR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788169775;
	b=BZuxS0mC4e5L3KIdb1Wsib/jtgwYDntDLvEs41+ikQTe+hyIoAUoQlRyJ90jJ0G4QsxI/a
	bsTk67VvUW76O63J4FLovt0jBQCtDURoFIu7a69OvDSOD6hEru7ZXuSCHsxoypf7yzwgKf
	Obb5/aRXCigLdhugFsUEY7isC2Cq9x0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2tQ8kc8Ed0EXiv4AJfetOVW4cPn5i1WpwfCATVSfhG4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788169774; v=1; x=1788774574;
 b=nZTmAivROI3QPvbKgW9/X3P9Pf+1p0Rev/SDbZe0poBfQAduPE1xFqHi8hAnzDmWV0REKtYQ
 k6o8dj/v6rzyZ973prNFiUjEYsSbFvLRpfM54hON91zkFfScvHr9rqsYKYKx7t12ii/NWXpIto6
 aDBNYfU9BdFsyEa7gBifzylg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id dc3f19ad1b3d1efa;
	Mon, 31 Aug 2026 09:49:34 +0000
X-Mizu-Trace-ID: dc3f19ad1b3d1efa
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 01/11] mm/sparse-vmemmap: introduce
 CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <0e1c3bb8-49a4-479e-adb3-17c21261d409@linux.dev>
Date: Mon, 31 Aug 2026 17:49:16 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9BB960A5-E8C8-4094-BD28-87FE483AB680@linux.dev>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
 <20260831075342.57563-2-songmuchun@bytedance.com>
 <0e1c3bb8-49a4-479e-adb3-17c21261d409@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ifmuqhfakkxcu4m59faecbqje7ucc58c
X-Rspamd-Queue-Id: 83950180002
X-HE-Tag: 1788169775-246795
X-HE-Meta: U2FsdGVkX18Jr4trtqOb3+4xe4lhAyi3INPvS8ie93lOqFY4nQhvtNfJeYE7Mf2mCq9KX71fmopx4LHKQNUMTcl5rNa8nUNirJrmoHtFw2PghPGkPWwqgnkqFwNLmE6V3j3T4LPr10tItosT57gpVi0XgZM8VZFzsfMNfBC3/i3rZ02R3V45GerTlbcINVYTuYBZhq/YrT2OCefwykHkMssOTbP80uzRjtYGYQczvRg3RNqxZhUqNNRPnUGsEa8JAqmF/4tLveDKhRKOzJM1/dJA4+CeoZCbJMoZ15ztuM6sZ+rOljikjQ8HUvU0TZFb/spEfLvT5RAeZCB4CIWy5/QmQJ9vc8sojQobz777dvVvTvrc5vPc2+vJ7fgwRLFWjT3w1Kevl89E2sZqaGD1egYM52jpvS/36oGQ9VrNNbaOqQ3dMJNFzwQ8jljvGbH3M4wuCklrV3T53vLBH4vaosv/956ZcEdnXXs8fMIWXy3F75c7bUPKs8OU1OKLqyas7WJe6a85+1q5m+ccE4NsJpbTZSWeRdWiv0q2e2uAdWfjv4WCoUUcI1S7E7/ZI55c5oB9Nx3vIJBfwvNQBaAq6vu6DmE3Wx6FT/7TuTkIIBJfm1RtpKNk4/1QhKdvJBhWDRuPaR+6V2zs/cqgWuoC1HU1DQw/cBlOlKfmo4y4aWjjwPBDOLQwY9DmhwR2SClyXTxYw/CpCKS4mUQTh2CGMlNv+Khd/Biuhjwga40kfiW8kDBEqzhB8cnIbeiE9VFqav76OWN5+t2AhKE6e0sFVVF5J414YiQcahT3o+eDhzC06mEvMe04ffwtUhnvcToeEHFl5B2rqIkvukYg/z2APsMaBrl2ICe+drPoUreKzLU1iwS4AOuT9hUxXirSfdjln50IAAXet5El0ktvkmIszUkBORaW3ihCwVx0TJ3gJKVnJ+88ZjtGEugBwmUk0i3YITjOTDnsKx/me7aXSGA
 L6K9v7vu
 7OkVlw68ETKmn3YUkAONjhprkwXtYcdPTLmb0x2OtxizGSn3In/5Ibp55cKd4N/NI2VGTNimFElKV841StTOSQD3QraXIhPbxaAkGmS86pzm6n2c09+deLJ9IqtIdOSLvaoqLdgkvyxRHaQwFRf3rVY59AIDrft3LRi46zdC4yubcUL7sH7Oil/ZLMHGEkg/WKVuVziyTXGzUl/ppAPEI+lxtU03bo81wtaIzIQGbVjHSg99rW7xsJdvtE3rxDSAFTW7hKC0WlOKXVDA6zhLy0fUqLqqbHOdzAAZF60gWe+b4Mmp3pt8LMUXZ18216xj4LUPW/0wxd/c+SbHOPADx0RCIpL/+xrf8n2/GR7fnNc5imMSXX3Pd+zIt5INABw1x56w3oLVpsYRIyaM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 31, 2026, at 17:44, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
>=20
>=20
> On 8/31/26 3:53 PM, Muchun Song wrote:
>> The section-based vmemmap optimization infrastructure is still =
guarded by
>> CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, but it also can be used by =
device
>> DAX. Introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION as a common =
config
>> for the shared infrastructure.
>> Select the new option from HUGETLB_PAGE_OPTIMIZE_VMEMMAP and from
>> DEV_DAX when the architecture opts in to DAX vmemmap optimization, =
and
>> use it to guard the generic sparse-vmemmap state and helpers.
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>>  arch/x86/entry/vdso/vdso32/fake_32bit_build.h |  2 +-
>>  drivers/dax/Kconfig                           |  1 +
>>  fs/Kconfig                                    |  1 +
>>  include/linux/mm.h                            |  3 +++
>>  include/linux/mmzone.h                        | 13 +++++++------
>>  include/linux/page-flags.h                    |  5 ++---
>>  mm/Kconfig                                    |  3 +++
>>  mm/sparse.h                                   |  4 ++--
>>  8 files changed, 20 insertions(+), 12 deletions(-)
>> diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h =
b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
>> index bc3e549795c3..5f8424eade2b 100644
>> --- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
>> +++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
>> @@ -11,7 +11,7 @@
>>  #undef CONFIG_PGTABLE_LEVELS
>>  #undef CONFIG_ILLEGAL_POINTER_VALUE
>>  #undef CONFIG_SPARSEMEM_VMEMMAP
>> -#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>> +#undef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
>>  #undef CONFIG_NR_CPUS
>>  #undef CONFIG_PARAVIRT_XXL
>>  diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
>> index 602f9a0839a9..85ad4c135cdd 100644
>> --- a/drivers/dax/Kconfig
>> +++ b/drivers/dax/Kconfig
>> @@ -8,6 +8,7 @@ if DAX
>>  config DEV_DAX
>>   tristate "Device DAX: direct access mapping device"
>>   depends on TRANSPARENT_HUGEPAGE
>> + select SPARSEMEM_VMEMMAP_OPTIMIZATION if =
ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
>>   help
>>     Support raw access to differentiated (persistence, bandwidth,
>>     latency...) memory via an mmap(2) capable character
>> diff --git a/fs/Kconfig b/fs/Kconfig
>> index d1c210c6508f..9b32ce79cc80 100644
>> --- a/fs/Kconfig
>> +++ b/fs/Kconfig
>> @@ -278,6 +278,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>>   def_bool HUGETLB_PAGE
>>   depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
>>   depends on SPARSEMEM_VMEMMAP
>> + select SPARSEMEM_VMEMMAP_OPTIMIZATION
>>    config HUGETLB_PMD_PAGE_TABLE_SHARING
>>   def_bool HUGETLB_PAGE
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index a9fbe26536f4..edadd7549b72 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -5188,6 +5188,9 @@ static inline bool =
__vmemmap_can_optimize(struct vmem_altmap *altmap,
>>   	unsigned long nr_pages;
>>   	unsigned long nr_vmemmap_pages;
>> + 	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
>> + 		return false;
>> +
>>   	if (!pgmap || !is_power_of_2(sizeof(struct page)))
>>   		return false;
>>  diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index c9ae7991a8b2..e9b54ea0eff0 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -102,9 +102,9 @@
>>   *
>>   * HVO which is only active if the size of struct page is a power of =
2.
>>   */
>> -#define MAX_FOLIO_VMEMMAP_ALIGN \
>> - 	(IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) && \
>> -  	is_power_of_2(sizeof(struct page)) ? \
>> +#define MAX_FOLIO_VMEMMAP_ALIGN \
>> + 	(IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION) && \
>> +  	is_power_of_2(sizeof(struct page)) ? \
>>    	MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
>>    /* The number of retained vmemmap pages with HVO enabled. */
>> @@ -116,7 +116,8 @@
>>  #define __VMEMMAP_OPTIMIZATION_NR_ORDERS \
>>   (MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
>>  #define VMEMMAP_OPTIMIZATION_NR_ORDERS \
>> - 	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? =
__VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
>> + 	((__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 && \
>> +   	IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION)) ? =
__VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
>>    enum migratetype {
>>   MIGRATE_UNMOVABLE,
>> @@ -1155,7 +1156,7 @@ struct zone {
>>   	/* Zone statistics */
>>   	atomic_long_t vm_stat[NR_VM_ZONE_STAT_ITEMS];
>>   	atomic_long_t vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
>> -#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>> +#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
>>   	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
>>  #endif
>>  } ____cacheline_internodealigned_in_smp;
>> @@ -2019,7 +2020,7 @@ struct mem_section {
>>   	unsigned long section_mem_map;
>>     	struct mem_section_usage *usage;
>> -#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>> +#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
>>   	/*
>>   	 * Normally, sections hold regular (order-0) pages. However, for
>>   	 * sections with HVO enabled, this tracks the compound page =
order
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index ae2ebaed6d4d..de3c06062bc6 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -208,14 +208,13 @@ enum pageflags {
>>  static __always_inline bool compound_info_has_mask(void)
>>  {
>>   	/*
>> - 	 * Limit mask usage to HugeTLB vmemmap optimization (HVO) where =
it
>> - 	 * makes a difference.
>> + 	 * Limit mask usage to HVO where it makes a difference.
>>   	 *
>>   	 * The approach with mask would work in the wider set of =
conditions,
>>   	 * but it requires validating that struct pages are naturally =
aligned
>>   	 * for all orders up to the MAX_FOLIO_ORDER, which can be =
tricky.
>>   	 */
>> - 	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
>> + 	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
>>   		return false;
>>     	return is_power_of_2(sizeof(struct page));
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index c1ddf59c0d71..b5f8372cd164 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -461,6 +461,9 @@ config SPARSEMEM_VMEMMAP
>>     pfn_to_page and page_to_pfn operations.  This is the most
>>     efficient option when sufficient kernel resources are available.
>>  +config SPARSEMEM_VMEMMAP_OPTIMIZATION
>> + bool
>=20
> As sashiko was concerned about [1], it seems we need to add
>=20
>        depends on SPARSEMEM_VMEMMAP
>=20
> here.

You are right. Besides that, we also need DEV_DAX to depend on
ZONE_DEVICE explicitly.

>=20
> Apart from that, LGTM. With this fix included:
>=20
> Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks.

>=20
> Thanks,
> Qi
>=20
> [1]. =
https://sashiko.dev/#/patchset/20260831075342.57563-1-songmuchun%40bytedan=
ce.com
>=20
>> +
>>  #
>>  # Select this config option from the architecture Kconfig, if it is =
preferred
>>  # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
>> diff --git a/mm/sparse.h b/mm/sparse.h
>> index 049272aba84e..b408d15baf7b 100644
>> --- a/mm/sparse.h
>> +++ b/mm/sparse.h
>> @@ -10,7 +10,7 @@
>>    #include <linux/mmzone.h>
>>  -#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>> +#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
>>  static inline unsigned int section_order(const struct mem_section =
*section)
>>  {
>>   	return section->order;
>> @@ -72,7 +72,7 @@ static inline bool vmemmap_optimizable_pfn(unsigned =
long pfn)
>>    static inline bool vmemmap_optimizable_order(unsigned int order)
>>  {
>> - 	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
>> + 	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
>>   		return false;
>>     	if (!is_power_of_2(sizeof(struct page)))



