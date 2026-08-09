Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D538FC5AC80
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 06:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB0E6B0110; Sun,  9 Aug 2026 02:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55BA16B0111; Sun,  9 Aug 2026 02:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44AA06B0112; Sun,  9 Aug 2026 02:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18D266B0110
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:58:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A625804E4
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 06:58:35 +0000 (UTC)
X-FDA: 85080827790.13.714253B
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id 267EEC0007
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 06:58:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hDVT6Afz;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786258713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0j/swSolXVaTQw8w321V40RuywVBDgJIsmDnGmUow5k=;
	b=eMXD548WQ/cn0r5IDmb7M2QzYGof+6aW8Cv72pXTqX/UMxwUL0s8JGgj4UZGdlfGimSriE
	yyIoUj7voABR9SQQsXVk+zOKUw5Ao80AZ52dvtkTlRL1YWh+jkOrMaHg5kGLJ01njOhYlf
	gFvavRvW2WbbEdC7NUt4LFfVsaIJGrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786258713;
	b=3YKYBNUPJjaReC1Sh3wsaFjXJyMNsZEhJRykAHK4WTWGkS5PCeZENjzYdmPEkATuKZPnp5
	pr8KfUNFCdJ/iZLjBai5Gu5VN3stfU5PhPXVSySBDcOO6qdwE0oN94smi0a3zp0wBro/Qv
	V7jfWML8AnMibkaT1eRqedcoiqCn9fk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hDVT6Afz;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786258710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0j/swSolXVaTQw8w321V40RuywVBDgJIsmDnGmUow5k=;
	b=hDVT6AfzzkGKoH9FrofNnkex2iCiT023RMAmLMoZnZgLcyo1A2VqyOySD1Uf/S+DgTF1xu
	WZ9BaNOYi6/JR3Jcxoe9xKmzowyy+uBci2BxOh7HJ0gGU4JQlhI7pkUs048Y5ueyxTKSO6
	oyU1c59wl/GWuPDFFtXet4cGDQGmYw0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v5] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260809043250.2917406-1-souravpanda@google.com>
Date: Sun, 9 Aug 2026 14:58:12 +0800
Cc: osalvador@suse.de,
 akpm@linux-foundation.org,
 usama.arif@linux.dev,
 shakeel.butt@linux.dev,
 wangkefeng.wang@huawei.com,
 anshuman.khandual@arm.com,
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
Message-Id: <E2FFA328-21B3-4E3D-8CB9-5638B4CB545B@linux.dev>
References: <20260809043250.2917406-1-souravpanda@google.com>
To: Sourav Panda <souravpanda@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 267EEC0007
X-Rspam-User: 
X-Stat-Signature: o3ie7md6htagteuz41wpguqexx4ytdns
X-HE-Tag: 1786258713-486449
X-HE-Meta: U2FsdGVkX19H5bG3RfHmDepryoTXZ4Uww8Zd5FHpOfzU9idQdPOVOk/raOWNLD7/5mmG8qnxGyv8Ja8sgW4tJjvZbnHEC0t4muwNKtc8Dsi+OVXmKqFGh9xWbAXXKxwsZM8g1+VpPKeXZjVAPAlv40DkwJCbh+emZLn5KcQAdqbSbIfQ5rSsFVFwWmsUDwFeRzcTuCH4ZXoUojc423ViWENHvTDLLNzMLgL6vTtKaJdcgDXl5ZqfZqyJllCYfmB++jl17/Th5gEj39Ja0z70FL6OgE9ESUZSc97Pi9qbGHpHtGhubXhzPpMm/NhSwsaIVWS94BWp5hlv6ollaKghHxQbyMU5rF5iP5lC6shviFwAXYb3Hw/OXPkoqT4N2LMClagDnyqzLK+wy0DzVdGeWWbuPDe1ejC7df6c0llx++nOuLDCX9aN7q0CG89I71pJP1BnTSWWUiPPzeqdqE4qPHGVaQeUljMqrP+caLIvERu09mYevXKL5QK6GKZQn79whhcK4xCoYdrMmhZiq8/O0nwpCsC4AGIb3qHuGrVp7HM1uSC7/t0EeVuOQTq+OpFvhU1BxuyMc4Jpyitzx2XUrbnQ4zgwX8+u8jJl+XENIUkl5uCrNYQtiA/ePo7BT2sHwGEt2M9PDOqff5k5LlsE4uCfAIks5Q9jTDjsHuSMX7zqBHQ6kRD0RumW4ef1a84KmvAxZrGu2qY4MHiMMszi60cQW95YF3ZyNXjMU+CMY4lDyhiZ3UVYWdQpi1yQnZMDDOdtQp1xNMajeZCSQpqt4nj0KtNZzEhqY0Si0euH8TdTaE0dLv9i8kfPu4YVC+EV9WSp4JstkvIgn9emJb6d9LEXnxJJXvKuWmk/zW3bqPSV+Lpt4UXaBa5m7lCP41hCPjCEAqJG2PEaLVugpMn3YX2NNEduBcgz9WZMfTvzsCwWcYbtlLp9l07n7bfSu6JZPtsSEP0J6DkopYl9A+2
 TlfeJ5MH
 /Prgc5exemV9OOder4QTNrwdosbqPV8Imikhz34zBMUK9OlVCIx9hmF2cU85B3MiVbn646QMmZbFGKbJX2fFMVzfv/lsLFTTo9AhO8cL1/I7+YNY8T1Xm0XsokdZnvrWrEsmtpm52soRi3gA0OZ4v3vm3BWKbDwSX+dA33HhNRJhIFLkCRKHNYLfWw98JNLBdy6C+gUB5FPQJAOOBR4mDTOkG3VBlvNla9EWVUolrrd1QhceWtZMcBqKPEONXOmKveWTGwgaMWVaEM5CoQvd3f5JIkXGyNLsebaby2BYf2uXJ/tLM8rxJ/vXlh8H1sv94URBNzGdVkSH8y3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 9, 2026, at 12:32, Sourav Panda <souravpanda@google.com> wrote:
>=20
> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> alloc_gigantic_frozen_folio().
>=20
> Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
> allocation on hugetlb_cma[nid] without verifying if nid is included in
> the caller's nodemask. Adding a node_isset(nid, *nodemask) check =
ensures
> the initial preferred node allocation honors the memory policy / =
nodemask.
>=20
> However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask in
> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> leading to a null pointer dereference kernel panic when nodemask is =
NULL.
>=20
> Fix this by checking if nodemask is NULL in
> hugetlb_cma_alloc_frozen_folio() and defaulting it to
> cpuset_current_mems_allowed (safely read using a seqcount retry loop).
> This ensures that the initial node check and fallback loop safely =
honor
> the task's cpuset without violating cpuset constraints or causing NULL
> pointer dereferences.
>=20
> =46rom a userspace perspective, this bug allows an unprivileged user =
to
> crash the kernel (trigger a panic) by requesting a gigantic hugepage
> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> configured on a subset of NUMA nodes.
>=20
> This can be reproduced by booting a VM with two NUMA nodes, =
restricting
> CMA to Node 1 (e.g., hugetlb_cma=3D1:1G default_hugepagesz=3D1G
> hugepagesz=3D1G hugepages=3D0), and running a program that allocates a
> 1GB hugepage area without reserving, restricts allocation to Node 0
> using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
>=20
>  void *ptr =3D mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
>                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
>                   MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
>  unsigned long nodemask =3D 1; /* Node 0 */
>  mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
>        sizeof(nodemask) * 8, 0);
>  memset(ptr, 0, 1UL << 30); /* Trigger fault */
>=20
> This results in a NULL pointer dereference:
>=20
>  BUG: kernel NULL pointer dereference, address: 0000000000000000
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  Oops: Oops: 0000 [#1] SMP NOPTI
>  RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
>  Call Trace:
>   <TASK>
>   only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
>   alloc_surplus_hugetlb_folio+0x6d/0x100
>   alloc_hugetlb_folio+0x3c5/0x660
>   hugetlb_no_page+0x3d9/0x650
>=20
> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic =
hugepages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sourav Panda <souravpanda@google.com>
> ---
> Changes in v5:
> - Replaced defaulting nodemask to &node_states[N_MEMORY] with safely =
reading
>  cpuset_current_mems_allowed using a seqcount retry loop, ensuring =
fallback
>  allocations comply with task hardwall cpusets as suggested by Usama =
Arif.
> - v4: =
https://lore.kernel.org/linux-mm/20260726072935.3513996-1-souravpanda@goog=
le.com/
> - v3: =
https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@googl=
e.com/
> - v2: =
https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@goog=
le.com/
> - v1: =
https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@googl=
e.com/
>=20
> mm/hugetlb_cma.c | 15 ++++++++++++++-
> 1 file changed, 14 insertions(+), 1 deletion(-)
>=20
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index 39344d6c78d8..3ae9347078e9 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -3,6 +3,7 @@
> #include <linux/mm.h>
> #include <linux/cma.h>
> #include <linux/compiler.h>
> +#include <linux/cpuset.h>
> #include <linux/mm_inline.h>
>=20
> #include <asm/page.h>
> @@ -30,11 +31,23 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
> 	int node;
> 	struct folio *folio;
> 	struct page *page =3D NULL;
> + 	nodemask_t local_node_mask;
>=20
> 	if (!hugetlb_cma_size)
> 		return NULL;
>=20
> - 	if (hugetlb_cma[nid])
> + 	if (!nodemask) {
> + 		unsigned int cpuset_mems_cookie;
> +
> + 		do {
> + 			cpuset_mems_cookie =3D =
read_mems_allowed_begin();
> + 			local_node_mask =3D cpuset_current_mems_allowed;

I think it only makes sense to move cma_alloc_frozen_compound() inside =
the
loop. Otherwise, during subsequent memory allocations, we could still =
face
unexpected allocation failures.

Muchun,
Thanks.

> + 		} while (read_mems_allowed_retry(cpuset_mems_cookie));
> +
> + 		nodemask =3D &local_node_mask;
> + 	}
> +
> + 	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> 		page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], =
order);
>=20
> 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
> --=20
> 2.55.0


