Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D2CC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 06:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DF186B0096; Tue, 11 Aug 2026 02:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190436B0098; Tue, 11 Aug 2026 02:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6896B0099; Tue, 11 Aug 2026 02:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2BAC6B0096
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:27:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6DD75A0396
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:27:07 +0000 (UTC)
X-FDA: 85088006094.03.EB8ED0E
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6188940003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:27:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VE5GBcds;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786429625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxJWDyxnGI+pS1Y8WxElKGtctTUBqjkdYEbNdD3fHnM=;
	b=jVOhbdOpDHJBGMwXNlJVYCt988iHuxAtKYOopgUOxkSHM4iIIpS5MViqlIoRm3WueRYPar
	xkuYB7DwNLIC1+6qytfe69i1m5s6kCq62P+KtSRM8VyY/KGcODhyEy1GObELocHy3WQ7a+
	uOX2iHAgba4xafvrMXxLWSP7abjf8qo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VE5GBcds;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786429625;
	b=24h186MJdPUIrhHIww/zARj5um4vzr3BbwUcYmhcO+1Foana7ZE+kjRbPQPYZGKROV7YEB
	YMVgoZ80yRBzV0/8ok02rwL+/bhFVx/cWn0CUcqQyT7HkpYJ4jPKcOH6VowHiToI6fr07b
	wDh6ZhszBonQJ5uWbxKjIzlT3WqiuFo=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786429623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oxJWDyxnGI+pS1Y8WxElKGtctTUBqjkdYEbNdD3fHnM=;
	b=VE5GBcdseZ1oTlJ/CAIJgJTKnQZSN4ytRo5DrWjtP2w6ZVytJYAw3Bx8HnksPJxgs3uHJH
	IsE2pNMNtnCkJDh8gzZjarDw43M29FzUUE2oBz+bluTTScOXC4ecLWedmPTYTQAJ5nfy9J
	Ed8rSqYvtc1eR1l5bynm9hqrvRTPG6s=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v6] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <7bdocyansemdfl2lugkmazjo6xytdunv4ujtabxjzeip3h4qbw@6nsaenwowryh>
Date: Tue, 11 Aug 2026 14:26:44 +0800
Cc: Sourav Panda <souravpanda@google.com>,
 osalvador@suse.de,
 akpm@linux-foundation.org,
 usama.arif@linux.dev,
 shakeel.butt@linux.dev,
 wangkefeng.wang@huawei.com,
 david@kernel.org,
 surenb@google.com,
 fvdl@google.com,
 gthelen@google.com,
 hannes@cmpxchg.org,
 riel@surriel.com,
 sj@kernel.org,
 vbabka@suse.cz,
 mhocko@suse.com,
 bjackman@google.com,
 zi.yan@sent.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <02941826-584C-4914-9700-1C75ACBE4D24@linux.dev>
References: <20260810230844.3778931-1-souravpanda@google.com>
 <15EAC670-AA9F-4361-985C-F8ED2C322CF9@linux.dev>
 <7bdocyansemdfl2lugkmazjo6xytdunv4ujtabxjzeip3h4qbw@6nsaenwowryh>
To: Anshuman Khandual <anshuman.khandual@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6188940003
X-Stat-Signature: jqpoabfawgo3d9i88b3mdw1qr186pbei
X-Rspam-User: 
X-HE-Tag: 1786429625-528201
X-HE-Meta: U2FsdGVkX18JlypBmHVqd4+5cRZxIomwFW+FwJyGJsl9oT9stC/3KdAd4Q0+suCSd1ULQ4Aa1T8OZI+53MkJAvLfOfsrQb9jk+/lsugqZ5zhVmJRRvtoNQbiI2J5ADzVWSA18Qft9Rg+Fqwo+fdHBER8OXnExsgxJFO75qr3XmfH7W1xaSBHAncKFh0q1W1iVD12/E+mzE6imx+2sSvwEUT2cX2IMTRcHrKmbN4sIKwWn0N/dy8GI9wEjr7GrmAfxNAL+qpPlCf4hKugUrgxlDU4QHU1vBpB/V/LRym4F1DZIOKD/pxv0x7abnNO4dmipVk43bQwrcd8JGwpJ9TN8LQ1Mw0fhwgqJuBGIYIhNzS3l/2gP0cmg94Ze4G+XS+GNvp8Pq+F0ic9GGLR158f7K0hg/mwUGkEHTlmx1O6WVvZKIor+HGlGAl0I9Zps7M1+tiRp8D7Uxi5On3AU6cKTFNPWo7fb9GG51emrPpOulZyeThZuV1VcGSe+DUYHSngMqFUGyTMyNRH56kBV52qKkoxdUA1rEoi/wZv881mfyVrYjIZPFoYmz8r0qvD4pcSpvBuHixqQHUHtaz1fx/p/AEZiSPtz82ijezq6d44eOO/NhL/w5lqHDNOTTkVaxxeLrJnEuPx47lwuKbByNhfc85+Z5QLSy4PK91IyEhRO8FjQsiZqpObDd+n70ZIxpZiLlXJOFoIScOg/KJwd0rfd2a/bI+AAdpuUY7Y5Yd1IZQdXprczNII2A59ABFQPhWK8L4HzTKdpo6oNX9ureQGMFaZVhHkxUsO6CLDimQJcW6xB8LFHG3eVOhQfPUlDo4RB8N15GpjBYOTwh5PnaWZGcNgv1DnP6skRipDpXg2zebfBFd4vDuWapfLU5IdtEjHMJq3gj6Ka6UXwIbtbXjb9mZJiVqBa3eEZ/MR6M8VzwE4XkopE/6/oU5uOCKqiqKsQz2Q+8+Iyzqg/QgIWtl
 TlWEP3Gq
 ztYkC9J5QOy+EhygGa7rK3aygTj8m17mUwgwyWvBiJ9lIcYMkXbDeusDHQCTY7FXJYQon3yxxdSMIEIvaOfWDudyNqWoJvRb80wtznsudT7TK5BrGnu9/t212KPWDbhhMW2u9NQWmvDv582PcJz3fuOc3WkupmZSMFXt4tWDYoNCM/7fgQ4Uae2eFaUOImXFpQy0N4NuqMIZwXQfpqc1UZRxpR6pJzS8FQbQJDrll47MuoV0o/YlrQkk6mQWspNai1FZETrRIKnRnUGO4dAtMGLwwHZ9/s2Agl78SAbNySj5w5PzI1Vy9Qb78d6pnPEQE65bxMhIXqQT9qkJTt3jRFi+ivgVH5KS1EPTaXeIIgQC0o2a6/+jKtmEKxuC+J9Dkwj3LBkElzK/XKCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 11, 2026, at 13:26, Anshuman Khandual =
<anshuman.khandual@arm.com> wrote:
>=20
> On Tue, Aug 11, 2026 at 10:48:31AM +0800, Muchun Song wrote:
>>=20
>>=20
>>> On Aug 11, 2026, at 07:08, Sourav Panda <souravpanda@google.com> =
wrote:
>>>=20
>>> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
>>> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
>>> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
>>> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
>>> alloc_gigantic_frozen_folio().
>>>=20
>>> Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
>>> allocation on hugetlb_cma[nid] without verifying if nid is included =
in
>>> the caller's nodemask. Adding a node_isset(nid, *nodemask) check =
ensures
>>> the initial preferred node allocation honors the memory policy / =
nodemask.
>>>=20
>>> However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask =
in
>>> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
>>> leading to a null pointer dereference kernel panic when nodemask is =
NULL.
>>>=20
>>> Fix this by checking if nodemask is NULL in
>>> hugetlb_cma_alloc_frozen_folio() and defaulting it to
>>> cpuset_current_mems_allowed. Enclose the allocation attempts within
>>> the cpuset seqcount retry loop so that if the cpuset changes =
concurrently
>>> during allocation, the attempts are retried using the updated =
nodemask.
>>> This ensures that the initial node check and fallback loop safely =
honor
>>> the task's cpuset without violating cpuset constraints or causing =
NULL
>>> pointer dereferences or unexpected allocation failures.
>>>=20
>>> =46rom a userspace perspective, this bug allows an unprivileged user =
to
>>> crash the kernel (trigger a panic) by requesting a gigantic hugepage
>>> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
>>> configured on a subset of NUMA nodes.
>>>=20
>>> This can be reproduced by booting a VM with two NUMA nodes, =
restricting
>>> CMA to Node 1 (e.g., hugetlb_cma=3D1:1G default_hugepagesz=3D1G
>>> hugepagesz=3D1G hugepages=3D0), and running a program that allocates =
a
>>> 1GB hugepage area without reserving, restricts allocation to Node 0
>>> using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
>>>=20
>>> void *ptr =3D mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
>>>                  MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
>>>                  MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
>>> unsigned long nodemask =3D 1; /* Node 0 */
>>> mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
>>>       sizeof(nodemask) * 8, 0);
>>> memset(ptr, 0, 1UL << 30); /* Trigger fault */
>>>=20
>>> This results in a NULL pointer dereference:
>>>=20
>>> BUG: kernel NULL pointer dereference, address: 0000000000000000
>>> #PF: supervisor read access in kernel mode
>>> #PF: error_code(0x0000) - not-present page
>>> Oops: Oops: 0000 [#1] SMP NOPTI
>>> RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
>>> Call Trace:
>>>  <TASK>
>>>  only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
>>>  alloc_surplus_hugetlb_folio+0x6d/0x100
>>>  alloc_hugetlb_folio+0x3c5/0x660
>>>  hugetlb_no_page+0x3d9/0x650
>>>=20
>>> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic =
hugepages")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Sourav Panda <souravpanda@google.com>
>>> ---
>>> Changes in v6:
>>> - Enclosed the CMA allocation attempts within the cpuset seqcount =
retry loop,
>>> retrying allocation upon cpuset mems_allowed updates to prevent =
unexpected
>>> allocation failures as suggested by Muchun Song.
>>> - v5: =
https://lore.kernel.org/linux-mm/20260809043250.2917406-1-souravpanda@goog=
le.com/
>>> - v4: =
https://lore.kernel.org/linux-mm/20260726072935.3513996-1-souravpanda@goog=
le.com/
>>> - v3: =
https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@googl=
e.com/
>>> - v2: =
https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@goog=
le.com/
>>> - v1: =
https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@googl=
e.com/
>>>=20
>>> mm/hugetlb_cma.c | 23 ++++++++++++++++++-----
>>> 1 file changed, 18 insertions(+), 5 deletions(-)
>>>=20
>>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>>> index 39344d6c78d8..9debf033d4fd 100644
>>> --- a/mm/hugetlb_cma.c
>>> +++ b/mm/hugetlb_cma.c
>>> @@ -3,6 +3,7 @@
>>> #include <linux/mm.h>
>>> #include <linux/cma.h>
>>> #include <linux/compiler.h>
>>> +#include <linux/cpuset.h>
>>> #include <linux/mm_inline.h>
>>>=20
>>> #include <asm/page.h>
>>> @@ -30,15 +31,27 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
>>> int node;
>>> struct folio *folio;
>>> struct page *page =3D NULL;
>>> +  const nodemask_t *nmask;
>>> +  nodemask_t local_node_mask;
>>> +  unsigned int cpuset_mems_cookie;
>>>=20
>>> if (!hugetlb_cma_size)
>>> return NULL;
>>>=20
>>> -  if (hugetlb_cma[nid])
>>> + retry_cpuset:
>>> +  if (!nodemask) {
>>> +  cpuset_mems_cookie =3D read_mems_allowed_begin();
>>> +  local_node_mask =3D cpuset_current_mems_allowed;
>>> +  nmask =3D &local_node_mask;
>>=20
>> I don't think we need a local_node_mask, nmask =3D =
&cpuset_current_mems_allowed
>> is enough. nodemask_t could be a huge array, so it might consume a =
lot of memory
>> on the stack. I don't think we need to do that unless we see a clear =
necessity.
>=20
> But does not local_node_mask capture current snapshot for =
cpuset_current_mems_allowed
> after first taking a reference via read_mems_allowed_begin() which =
ensures that nmask
> has a constant value there after. Otherwise nmask could just change =
value by the time
> it actually gets used.

However, this value can change while you are copying it, so a snapshot =
itself is not
a consistent value. Right?

>=20
>>=20
>> Otherwise, LGTM.
>>=20
>> Thanks.
>>=20
>>> +  } else {
>>> +  nmask =3D nodemask;
>>> +  }
>>> +
>>> +  if (hugetlb_cma[nid] && node_isset(nid, *nmask))
>>> page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], order);
>>>=20
>>> if (!page && !(gfp_mask & __GFP_THISNODE)) {
>>> -  for_each_node_mask(node, *nodemask) {
>>> +  for_each_node_mask(node, *nmask) {
>>> if (node =3D=3D nid || !hugetlb_cma[node])
>>> continue;
>>>=20
>>> @@ -48,8 +61,12 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
>>> }
>>> }
>>>=20
>>> -  if (!page)
>>> +  if (!page) {
>>> +  if (!nodemask &&
>>> +      unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
>>> +  goto retry_cpuset;
>>> return NULL;
>>> +  }
>>>=20
>>> folio =3D page_folio(page);
>>> folio_set_hugetlb_cma(folio);
>>> --=20
>>> 2.55.0



