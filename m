Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B96E9C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1356B00A1; Mon,  6 Jul 2026 07:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9622B6B00A2; Mon,  6 Jul 2026 07:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82BC86B00A3; Mon,  6 Jul 2026 07:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45A176B00A1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:05:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA35F1A03B2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:05:32 +0000 (UTC)
X-FDA: 84958070904.09.740763E
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id BB4C314000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:05:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VHL9KSSG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783335931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70JWofOLlMgrve9aDAgHG0zmj2dWsVDmKKX/VA1fyUA=;
	b=a7H9fto7fDY60P14rS+mdxuTJuSa/3NrNH+jUewemvAyJtFmMk7YqCNt+DzKg4bYatbKgU
	6FCx5vpj1lrYz98/yYLbFDEtfg9uotTgQgUzdmTxkGnj5XViygrCWu2wfqBuNIc22clTcz
	d2lYpSAeH1Hu/NsFOKQ+wVKPtaCnZmE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VHL9KSSG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783335931;
	b=OscKOI7VAwm/lWVSJB8CHC1qWTUAlkeFjRsOn5bWvcxsL8ZkcrzHJFMfNNV9XipkKUC/G5
	e7uinJXfn3YgF1qDHeOHA703y2AfZk/DzmNtc6XKshS+qslpeS8A0FDnWcDpqCup0iTYk+
	+LYFDp1PnaXbjm8BrCaFR6yC6WpKhyw=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783335928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=70JWofOLlMgrve9aDAgHG0zmj2dWsVDmKKX/VA1fyUA=;
	b=VHL9KSSGqlxRYaGJQc9uy9oiC4xOSCeQUo/nl+CaMphFOPWNd+lQJukSEIALJfU39/njtD
	8RLuOFpl7fzzo9dgm8IwummIQjaga+zPxFmOc/m/pSGd+HghXQrb6mhFAvSvUvMOFTzAMN
	710fjORCfQjp3SJnNqGIg+QRTJFGbS8=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v4 01/19] mm/hugetlb: Fix boot panic with CONFIG_DEBUG_VM
 and HVO bootmem pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <b4b200da-f510-4fe2-95ac-c63e4467c4bd@google.com>
Date: Mon, 6 Jul 2026 19:04:50 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org,
 Mike Kravetz <mike.kravetz@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BBE64A39-448D-4235-8090-74C57947FE35@linux.dev>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
 <20260612035903.2468601-2-songmuchun@bytedance.com>
 <b4b200da-f510-4fe2-95ac-c63e4467c4bd@google.com>
To: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BB4C314000A
X-Stat-Signature: z4kx8z9qgp9rhd5ba9bn8eccepptu4ud
X-HE-Tag: 1783335930-193140
X-HE-Meta: U2FsdGVkX1/TY/hb/rNTlJw8LcO4Fdcppwvs8iTFOMmtnBJ+kzOwglweEyqb3spLatEbuA88fqbQMnP+1Xgv3mk3wAUr/q7EuEtvaznvQdwJaL4utpg9liwUipkLkNztFO573k5V5NLc5/Tlfej4U31EjSYUVu8a9YyPGagHfa+c6qqKJxHrDITpluZeQ00ODD6dwI/4v/z18SQ8lJB8FcYYNHi/Aqlv9FIpE15uaOCLTR9SF40SQfoOLizzBSRSKHI5v5Ht1ajRXZCubFmqg53QXrUJqWPcOGRofDj3iAOWFi+pZk2PDXCXugFdr2vG5vcgdPlv2wEWvGszyP1sGV4HejHCgWnwSlbKx210ysRWTmJaMcUSabK7Ylac1QhaCiRy5PJpqkHbZbNLkZAKxrCVhTKkp4/zpphC8BZ3XwAExcXkG4wwG6jy9OWIC73OETkxERu7Ka4x2/43PinJu4jIvXiMAfPg5T+I3f/GsInNXqGwDxJcrloBchVK+vjMBDpColMIbz2D3YwOATa3dXlT7b4iPdixqZlq/FL9YDb2R109/LldjYzITRkl4A83P3FLpTz1vqcALb9o+45DV4hy5W8KFVtrSUhgDgPj92+/angoeeQMroZ/P8QnjFzElSBtJE1bqw0RnjfN/JF71Wm2RO6aapm7Xhz9ndNrIcSwZrtju0WUU1nJUXf00ckpkWRP4qfjdMYvvOH4H4drAb8c4ggpcuj6Uksb2E9i1xkdlB9Qo/kpgv6wOeRPOENcFfV2my7k0878wEuZEkWcHBZ3jC3AUkgde/wisczHDQZ4l3OjJ0ZpSNKntXXVTuX3uWAq73ZRtWPty+NlBXO/4Q4183dCjQaDlQAaM0Ntme16BA9Ohx6R/MV5mToGYqK1drKhZhyePnRudme2uBFzR6IldXNIABBm/543/fZACIOX4UIy21JqZ5+ZplLjM43RlLh5qUi4VRuTGQzRaEE
 XMUnDhjl
 cF9iif341E7QTtsomYeZuSXCupXj+W5Q2aTeKEcwu/uSMlr4V/2A7BmkmkapYzyplXnSODE6q4/65UH7Og2uYmQ4vtKuWrAvyo7AHKSRrvRHtjWytF2bxe3TUa0kGrAwvkaMhNxu7YqYUvioSq+pGIl4Sqq4tbKH53/jcUD65BXqcjkrQFETYEy4BsYr8lEgwH9Gf+c7Q3EZ3rn/y2cysRm1IKqAhCSOsumMoppuAW0u7k4U9m/05/zqZC6jsRPgk/m5qaWRlEx4JXYw+CKvTHw0fYGtjrI1WOmmDtnBN07Q19RMNKGolfOsEUh5bu6lgGzRPm0EmcyeAa/54yTIH4x2ggv+z3LuaHL8WgBKFSkllz9471IBaP1AFKnfkmbfefLYDdLylgkscStCubUU930ToEAkM/svoNoTUf5jIylV1+Qg38zr0Ga3zjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 6, 2026, at 18:07, Micha=C5=82 C=C5=82api=C5=84ski =
<mclapinski@google.com> wrote:
>=20
> On 6/12/26 5:58 AM, Muchun Song wrote:
>> Commit 622026e87c40 ("mm/hugetlb: remove fake head pages") switched
>> HVO to reuse per-zone shared tail pages from zone->vmemmap_tails[].
>> Those shared tail pages were initialized in hugetlb_vmemmap_init(), =
but
>> bootmem HugeTLB folios are prepared earlier from =
gather_bootmem_prealloc().
>> With hugetlb_free_vmemmap=3Don, prep_and_add_bootmem_folios() can =
access
>> pageblock flags on bootmem HugeTLB pages whose mirrored tail struct =
pages
>> already point to the shared tail page. On CONFIG_DEBUG_VM kernels,
>> get_pfnblock_bitmap_bitidx() then dereferences the =
still-uninitialized
>> shared tail page and can panic during boot.
>> Initialize zone->vmemmap_tails[] from gather_bootmem_prealloc(), =
before
>> bootmem HugeTLB folios are processed, and drop the later =
initialization
>> from hugetlb_vmemmap_init().
>> This bug only affects CONFIG_DEBUG_VM kernels, where the relevant
>> assertion is evaluated.
>> Fixes: 622026e87c40 ("mm/hugetlb: remove fake head pages")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Oscar Salvador <osalvador@suse.de>
>> ---
>>  mm/hugetlb.c         | 25 +++++++++++++++++++++++++
>>  mm/hugetlb_vmemmap.c | 17 -----------------
>>  mm/sparse-vmemmap.c  |  2 +-
>>  3 files changed, 26 insertions(+), 18 deletions(-)
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 571212b80835..cd55524c7e30 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3365,6 +3365,31 @@ static void __init =
gather_bootmem_prealloc(void)
>>   .max_threads =3D num_node_state(N_MEMORY),
>>   .numa_aware =3D true,
>>   };
>> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>> + struct zone *zone;
>> +
>> + for_each_zone(zone) {
>> + for (int i =3D 0; i < NR_VMEMMAP_TAILS; i++) {
>> + struct page *tail, *p;
>> + unsigned int order;
>> +
>> + tail =3D zone->vmemmap_tails[i];
>> + if (!tail)
>> + continue;
>> +
>> + order =3D i + VMEMMAP_TAIL_MIN_ORDER;
>> + p =3D page_to_virt(tail);
>> + /*
>> + * prep_and_add_bootmem_folios() can access pageblock
>> + * flags on bootmem HugeTLB pages, so initialize the
>> + * shared tail struct pages here before bootmem folios
>> + * start using them.
>> + */
>> + for (int j =3D 0; j < PAGE_SIZE / sizeof(struct page); j++)
>> + init_compound_tail(p + j, NULL, order, zone);
>> + }
>> + }
>> +#endif
>=20
> I think it would be better if this was located in mm/hugetlb_vmemmap.c =
as a separate function.

This is actually just temporary. I already have another patch [1] that
completely removes this code later on. So, to avoid having to update
the entire patchset unnecessarily, I figured it's best to just leave
it as is for now, as it's not a major issue..

[1] =
https://lore.kernel.org/all/20260702093821.2740183-10-songmuchun@bytedance=
.com/

>=20
>>     padata_do_multithreaded(&job);
>>  }
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index 133b46dfb09f..c713c0d2593a 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -870,27 +870,10 @@ static const struct ctl_table =
hugetlb_vmemmap_sysctls[] =3D {
>>  static int __init hugetlb_vmemmap_init(void)
>>  {
>>   const struct hstate *h;
>> - struct zone *zone;
>>     /* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct =
pages */
>>   BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
>>  - for_each_zone(zone) {
>> - for (int i =3D 0; i < NR_VMEMMAP_TAILS; i++) {
>> - struct page *tail, *p;
>> - unsigned int order;
>> -
>> - tail =3D zone->vmemmap_tails[i];
>> - if (!tail)
>> - continue;
>> -
>> - order =3D i + VMEMMAP_TAIL_MIN_ORDER;
>> - p =3D page_to_virt(tail);
>> - for (int j =3D 0; j < PAGE_SIZE / sizeof(struct page); j++)
>> - init_compound_tail(p + j, NULL, order, zone);
>> - }
>> - }
>> -
>>   for_each_hstate(h) {
>>   if (hugetlb_vmemmap_optimizable(h)) {
>>   register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 99e2be39671b..bb23fb3077a3 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -342,7 +342,7 @@ static __meminit struct page =
*vmemmap_get_tail(unsigned int order, struct zone *
>>   *
>>   * Any initialization done here will be overwritten by =
memmap_init().
>>   *
>> - * hugetlb_vmemmap_init() will take care of initialization after
>> + * gather_bootmem_prealloc() will take care of initialization after
>>   * memmap_init().
>>   */
>> =20
>=20
> It gets the job done.
>=20
> Tested-by: Michal Clapinski <mclapinski@google.com>
> Reviewed-by: Michal Clapinski <mclapinski@google.com>

Really thanks for your test.

Muchun,
Thanks.


