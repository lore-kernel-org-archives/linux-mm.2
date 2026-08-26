Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB50BC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 02:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A176B0088; Tue, 25 Aug 2026 22:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3986B008A; Tue, 25 Aug 2026 22:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2D16B008C; Tue, 25 Aug 2026 22:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5D76B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 22:38:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5ABB140242
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:38:30 +0000 (UTC)
X-FDA: 85141861980.15.1EBA3D6
Received: from mta1.migadu.com (out-113.mta1.migadu.com [95.215.58.113])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8AE971C0003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:38:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BKNkuZZ2;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.113 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787711908;
	b=OajhzxT5FEoRVbHECNC+R6mCwDid+e3ipRZ/yCL7z+f55P3fQ8GByAt/M0+HlHw9OdDj0K
	44W9sw4dgWrF0r8maJ+pWTh3VKgHU+el/o7jkXjLrzYAmuJV4vV29dyrRzDQmAargpftJ1
	bA2l7dJyO2VzikZ/kxapEfQKsVt1oQ8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BKNkuZZ2;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.113 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787711908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wRwQJnazfOz2roh8/soDzOfSf1ptvbu/Ml3MFQAF9dE=;
	b=jlC3no3MXJiIlDy+Nms/akybfwfWGHuvm3KVAfRYFSwcGsgtAGrVZ9CpwqOBGIxagxZduQ
	vNQA8RXjeHOr2mZnrPyYTuuAgS4MgMfvySvr7JNRTEy9bpbd6gg7tuLk0P8+yLzYSnaOO5
	eGDTLnGMu8fSQLJkJJDto0SL29a5oTg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iaJbOqWwU7swmIOu9Nbpfo0jDj4KZx3LS8pZAlWsWV8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787711907; v=1; x=1788316707;
 b=BKNkuZZ2uzuJpmj4ptcyqwXtJcV0xmF9zKMoW8cwAtdbydxMNvciQDNIwfLCvAv1vwVBX/lb
 nUDdzB9XpsinJH+ek/jgLxZOBFfIf8HUdGHMIaU1oT1kA40oylWr4mom46JkJVsMPDF3DzjpdmF
 75N+GDljm3vHFKFzmNNSO1rg=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (114.251.196.90)
	by mta10.migadu.com with ESMTPS id 56a300c3813559b4;
	Wed, 26 Aug 2026 02:38:27 +0000
X-Mizu-Trace-ID: 56a300c3813559b4
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v5 10/17] mm/hugetlb: switch HugeTLB to section-based
 vmemmap optimization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <83d8d1f2-6ca2-4c72-a494-23ce07bb4181@linux.dev>
Date: Wed, 26 Aug 2026 10:38:08 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C06EECC2-9025-49D8-91ED-EC58685398C4@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-11-songmuchun@bytedance.com>
 <83d8d1f2-6ca2-4c72-a494-23ce07bb4181@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8AE971C0003
X-Stat-Signature: kt7zibfwex3rwx8z9jew6zhqibse1xx8
X-Rspam-User: 
X-HE-Tag: 1787711908-857969
X-HE-Meta: U2FsdGVkX1+DL36ioDMBT8IcjQ/sYbyzo6uPxYkZCztlAzjKtv0nHZrGQSsqRGzgFjM9+cJ4vhny/nuKsZSWyCOzy91PHgsTPjN7fpfGIFN/mpqKb1+g8qVFmpcOs8fWvmwPlDmxvEG1EiiLZ6cgolvbWD/jr5pPd9v2XtIakwllMGuNQWYPLD3VqSfN+Dr3fv62oKuXlSt0XbJhkIGrq7/NAojS0OUDqV05xEGDjOrVxRQk5I796HJZE8zzzoee6vZEpKhfB6oE06ZfCxexU3p1UVZOH7DBEyihp07v4oCxvU8JWRDRcMs5FlhIT7t8dy2q3N1D7PnMSJRKb0oST3lwzdkhRL/L2RKJHt/E+R4GA3p4SduuVxVHcQFRluiMBblw3wuy9iiBR1iDEOy4+NBUPP85voxt/rSdrECRfk14/7b6C7gyOZe+PB9ejQ9SoJM+dQJGR2js9CJVsuOMOPRXSKiazurjGrBSgpW6MsgRDv0tfZmYsRrCu67HDS76cT2sySxrWCYOuzSrXoKVY6JLDKqNTYK4Bi7Ru09okZyBScVRh1jQhlqDhz6pMy6aZjACqLv5Jw3xusItJNiS7NZ9zrolMFwyCJyiynIjPYqUS5S6y9HDkNFKew5ZKI2eVmneXtLI3fajj/0Wix3X2Hl059ExMEqjqrouz1ZQzJ5MMyQnZOEurSIRf2KIOPpOPvyEsyREHTGux7+ca2B5k9/zchYyy0TRq8m1gwXm/drcCnjE7ufFnRRSDorIdUAvCVCbkTvVQehIhstxS9wLEltp00MkiQvs3dazXIaHUM4wOcBFdBcQznfhAyfiQJGI3K0wiuDpfW4IGAh3d2x/BCos5lxOAujr2NhLasXId3BIeM1gCjJu8VTd74ODnM0EDR5S4fhOUfQO7cHNV2P2sf+TzhJXN4T7LAImFYAm7V0Sn8Kxb5irly9SAHIh2MiszvK9hBWME7+vqmty23J
 Jo+pYwcq
 P83/2nsU6+z/eAhiKxQhBWhxo7QapitWFm7kgvgXAthiYEvZ6kGKx7y4vuTW9EJZxSp9uFj2rhLpEvuwdmy4nzsdjbIk3XUNWAGYeS9v8Ljmh8mymy8UKKcuY0bPe/lIJZg3f5y2KW71IT7I7BYGVesANmfHabTvKKrXHPBw+KbDU/AOjuBP6odQ9pzU/ndqBj7+6akRACRcIGxnA0W7B2r/OdrXSj9agwhBXf7a8QAEfwWaUQ4yckf8rPe1VVtL91XoM5XXco5jJbY2WpcmTvR2aXH74pTU+ntfG1anxZ9mOAmTOPiQO8Td/cK19l7qybEq4W/3Y8A7xzDrKG9j+1VPkw8rH92dmIBjzd5mUOFJJxokJWtGI/6DnFbJzXurN5FR4H+pOr79P7RQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 25, 2026, at 21:12, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
>=20
>=20
> On 8/25/26 4:46 PM, Muchun Song wrote:
>> HugeTLB bootmem vmemmap optimization still carries its own early =
setup
>> path, including pre-populating optimized mappings before the generic
>> sparse-vmemmap code runs.
>> Now that the section-based vmemmap optimization can derive HugeTLB
>> vmemmap deduplication from section metadata, HugeTLB only needs to =
mark
>> the bootmem huge page range with the appropriate order. The generic
>> sparse-vmemmap population path can then allocate and map the shared =
tail
>> vmemmap pages without any HugeTLB-specific early population code.
>> Do that by setting the section order when a bootmem huge page is
>> allocated and dropping the dedicated pre-HVO helpers and related
>> special-casing.
>> This removes duplicate early setup logic and switches HugeTLB to the
>> section-based vmemmap optimization path.
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>> v3:
>> - Use the order-based helper for the bootmem vmemmap-optimized check
>> v2:
>> - Collect Acked-by from Mike Rapoport
>> ---
>>  include/linux/hugetlb.h |  1 -
>>  include/linux/mm.h      |  3 --
>>  mm/hugetlb.c            | 30 ++------------
>>  mm/hugetlb_vmemmap.c    | 90 =
+++--------------------------------------
>>  mm/hugetlb_vmemmap.h    | 14 +++----
>>  mm/sparse-vmemmap.c     | 31 --------------
>>  mm/sparse.h             | 27 +++++++++++++
>>  7 files changed, 42 insertions(+), 154 deletions(-)
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 16c4c4caa126..fe28f98e1b22 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -171,7 +171,6 @@ struct address_space =
*hugetlb_folio_mapping_lock_write(struct folio *folio);
>>    extern int movable_gigantic_pages __read_mostly;
>>  extern int sysctl_hugetlb_shm_group __read_mostly;
>> -extern struct list_head huge_boot_pages[MAX_NUMNODES];
>>    void hugetlb_bootmem_struct_page_init(void);
>>  void hugetlb_bootmem_alloc(void);
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index dd09c438fa23..441bd39eab73 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -5159,9 +5159,6 @@ int vmemmap_populate_hugepages(unsigned long =
start, unsigned long end,
>>          int node, struct vmem_altmap *altmap);
>>  int vmemmap_populate(unsigned long start, unsigned long end, int =
node,
>>   struct vmem_altmap *altmap);
>> -int vmemmap_populate_hvo(unsigned long start, unsigned long end,
>> -  unsigned int order, struct zone *zone,
>> -  unsigned long headsize);
>>  void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, =
int node,
>>     unsigned long headsize);
>>  void vmemmap_populate_print_last(void);
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 04e6c4244cd6..fbb0c83bea79 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -52,6 +52,7 @@
>>  #include "hugetlb_cma.h"
>>  #include "hugetlb_internal.h"
>>  #include "mm_init.h"
>> +#include "sparse.h"
>>  #include <linux/page-isolation.h>
>>    int hugetlb_max_hstate __read_mostly;
>> @@ -59,7 +60,7 @@ unsigned int default_hstate_idx;
>>  struct hstate hstates[HUGE_MAX_HSTATE];
>>    __initdata nodemask_t hugetlb_bootmem_nodes;
>> -__initdata struct list_head huge_boot_pages[MAX_NUMNODES];
>> +static struct list_head huge_boot_pages[MAX_NUMNODES] __initdata;
>> /*
>>  * Due to ordering constraints across the init code for various
>> @@ -3139,6 +3140,7 @@ static bool __init =
alloc_bootmem_huge_page(struct hstate *h, int nid)
>>   	} else {
>>   		list_add_tail(&m->list, &huge_boot_pages[nid]);
>>   		m->flags |=3D HUGE_BOOTMEM_ZONES_VALID;
>> + 		hugetlb_vmemmap_optimize_bootmem_page(m);
>>   		/*
>>   		 * Only initialize the head struct page in =
memmap_init_reserved_pages,
>>   		 * rest of the struct pages will be initialized by the =
HugeTLB
>> @@ -3299,6 +3301,7 @@ static void __init =
gather_bootmem_prealloc_node(unsigned long nid)
>>   	 * this folio.
>>   	 */
>>   	folio_set_hugetlb_vmemmap_optimized(folio);
>> + 	section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), =
0);
>=20
> So section->order is only used during initialization. Is it ever
> accessed later at runtime? If not, can we just skip zeroing it out?

You have keenly noticed a detail. This was actually done deliberately,
because in patch 14, HUGE_BOOTMEM_HVO was removed and replaced with=20
section->order. The ->order field may store a value that is less than
VMEMMAP_OPTIMIZATION_MIN_ORDER, so clearing it to 0 here is to prevent
potential issues with this memory region during the hotplug/hotremove
process in the future (in my future series).

However, is there also a way to avoid clearing it to 0? There is. We
could add an extra check in hugetlb_vmemmap_optimize_bootmem_page to
only call section_set_order_range when the current hstate->order is
greater than or equal to VMEMMAP_OPTIMIZATION_MIN_ORDER. I just feel
that this would add a bit more code. And then during the boot phase,
doing one extra zeroing-out doesn't introduce much overhead anyway.
Therefore, I chose the simpler implementation approach.

Muchun,
Thanks.=

