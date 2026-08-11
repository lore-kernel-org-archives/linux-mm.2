Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A86E1C5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 02:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B9A6B007B; Mon, 10 Aug 2026 22:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64C046B008A; Mon, 10 Aug 2026 22:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53B8D6B008C; Mon, 10 Aug 2026 22:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 228456B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:49:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A67C01C0BF0
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:48:56 +0000 (UTC)
X-FDA: 85087456272.07.B86772E
Received: from out-181.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4BCDCC0009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:48:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZQSuEH8O;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786416535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZhHjo3aIwixazs38WpONPdhAQWYBalHyX4mnm9h4mLg=;
	b=dwOe/eWD4SZGL7ToKXljxdws82n1JCbb6KJw/x9yr7vx94k2J7i67hk7ZPC9OJIAEgoz7u
	UKaDkjGbfq55LrbWgfTp6J5IUnOYTSZmGdZXdA42IM69yQqZM1W2GP+tqR0AM8IPQ4DGCV
	dJT3UT1IiFNbb3Q8BCnqI4q9phk4CVc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786416535;
	b=g7bdKpd5UXysgviNDHe6VhFVJ957UhVMs+sf+AUqefatwRqc0d5p2/QJZ3gA8NlbLu8ulU
	B0Ig6UUwLhsOkkMG1DaqIQV9y05+orkrlab4huBZ5h4zpyOFdjXRnocyIGBIbqmHfWMOqL
	N6R83H6wReBky5d3k36HsRvtzlTXRWg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZQSuEH8O;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786416532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZhHjo3aIwixazs38WpONPdhAQWYBalHyX4mnm9h4mLg=;
	b=ZQSuEH8OMzSl9+vo5G7FZYxMvdPLWoizh5Q/APLwfiqTR//gsSmDE/j2IwSnqSHtQxh5G7
	g4/LuySrHj6GvQMxJaE4+ccI+7lVXUwdTNkXhGf5l5oV/vKbm9/QPLYo32tn2bTW/JNJm9
	tXqq547o0NdEvY14OFAEZtWOkbBNnK8=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v6] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260810230844.3778931-1-souravpanda@google.com>
Date: Tue, 11 Aug 2026 10:48:31 +0800
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
Message-Id: <15EAC670-AA9F-4361-985C-F8ED2C322CF9@linux.dev>
References: <20260810230844.3778931-1-souravpanda@google.com>
To: Sourav Panda <souravpanda@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4BCDCC0009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: p6bjjwis843qce5azjufqhpsmj4ac5oh
X-HE-Tag: 1786416534-659389
X-HE-Meta: U2FsdGVkX19Wvs7fShHln24ayfo9MCOAS73c/lH5VTGCzpcyHxFdlVBEKP6RiAW586r6+utkuhQ8eO5JEo6sm5M1jdaf5M1c5tilG3A5lAv3hflCpKiQUmvd0mbmqmfDooAmg+e3TApb66FEAoDlrNjAxzazujN7cxwwQwFH1YyKVxxkO9DjaG3aFRKUzKxE1JJUpa65XWpVvhHVlAX/NrDT1WPDJpz+T8liksF89SqUE/4lGbFslzEAQQW3UFln2t9XYEiizDJP/50eN+t6ZYUz2wKv57M10klADplcwJ60bAE+L4ocO0/3WA3tPesnm7bAJjRoqoOXaQB3F3S5d/w/7/MAi4K7AJ4NmLV/eMHHwWrPRMcAbiL7cvuTX7qu79pFlLuX+NmVz18W7TN8bnyO229RzluzR75LW2sNG7Hqj/z+9dz0Bn/wjqDSH70dQe9xdyCWZxOA0a7gR8cLt2s73c278T8RLnvb/KRkxAKlufAXeCLGAKD2Jp7CKRFwb5RE0vfN+m7gTbnkmKEj6jAkf2dwIqgcExc3GXyDheqXbJjlo1Tpc8K64S7CM5h51lDNBJKveArMvfrDdi/sJVBGjJvCF4TPlF/SKbsZ3gsBnld4xDmVbQiTGD4qfCAwsbF60e1zpQ2GWiqCxsijwcwy11g8uCuLM5ZMiAXYmE9yQ/Ye8FV+6mMNZepPcn6Is024aOTH4pvZagI016gZgyOKXH4USw9zxF017Mv+eGXvlBxqhm90O3PgDIDDwB4KNkdmzSxbUQBlkAZRDcmGtqVKYydCmUEhvfYCmostYkTjQZ4iDBJBXvp0tOdfB5Gagpu9anpjp5KBwowqmavQuxT585gEbIClPi0h9fL8l4HTbUr5nU7ThzZB43BoGjXDuoTl4Y09edcU9K2w2BQ58tSiT034/6ziqjyMcE6IiXihixEHPZeTpsB/rzgTxDewN4ekmzWRFhf3rekwd0v
 XAPoUkGn
 TJ2aqFF4gphbC0ZrGiXbvRk3Xjz1ZciL1GoyLsBM10es9o3MVAUfvEn6HKWf34p2jt+LBLaZc/sg/Q4BStb4F8tBq5k62A4N+8LiZTm6Qw+5LRXlV7/HaxNwqK5/N2qUlbvGInZfGnOYjhonx+REs69hFDc/LQIIugJppsgurg7aD8VtngZHkSTPXPGykdAgDDiYWrGyqgkO4RNqP2xgVDVlOLLMZ4WqlDOcz9H92uWiIennKt4J6s5fvAQCDNLFnglXV7ZXeTyv867574jY+ARsyhIxBmKO8DUpZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 11, 2026, at 07:08, Sourav Panda <souravpanda@google.com> =
wrote:
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
> cpuset_current_mems_allowed. Enclose the allocation attempts within
> the cpuset seqcount retry loop so that if the cpuset changes =
concurrently
> during allocation, the attempts are retried using the updated =
nodemask.
> This ensures that the initial node check and fallback loop safely =
honor
> the task's cpuset without violating cpuset constraints or causing NULL
> pointer dereferences or unexpected allocation failures.
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
> Changes in v6:
> - Enclosed the CMA allocation attempts within the cpuset seqcount =
retry loop,
>  retrying allocation upon cpuset mems_allowed updates to prevent =
unexpected
>  allocation failures as suggested by Muchun Song.
> - v5: =
https://lore.kernel.org/linux-mm/20260809043250.2917406-1-souravpanda@goog=
le.com/
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
> mm/hugetlb_cma.c | 23 ++++++++++++++++++-----
> 1 file changed, 18 insertions(+), 5 deletions(-)
>=20
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index 39344d6c78d8..9debf033d4fd 100644
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
> @@ -30,15 +31,27 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
> 	int node;
> 	struct folio *folio;
> 	struct page *page =3D NULL;
> + 	const nodemask_t *nmask;
> + 	nodemask_t local_node_mask;
> + 	unsigned int cpuset_mems_cookie;
>=20
> 	if (!hugetlb_cma_size)
> 		return NULL;
>=20
> - 	if (hugetlb_cma[nid])
> +		retry_cpuset:
> + 	if (!nodemask) {
> + 		cpuset_mems_cookie =3D read_mems_allowed_begin();
> + 		local_node_mask =3D cpuset_current_mems_allowed;
> + 		nmask =3D &local_node_mask;

I don't think we need a local_node_mask, nmask =3D =
&cpuset_current_mems_allowed
is enough. nodemask_t could be a huge array, so it might consume a lot =
of memory
on the stack. I don't think we need to do that unless we see a clear =
necessity.

Otherwise, LGTM.

Thanks.

> + 	} else {
> + 		nmask =3D nodemask;
> + 	}
> +
> + 	if (hugetlb_cma[nid] && node_isset(nid, *nmask))
> 		page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], =
order);
>=20
> 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
> - 	for_each_node_mask(node, *nodemask) {
> + 	for_each_node_mask(node, *nmask) {
> 		if (node =3D=3D nid || !hugetlb_cma[node])
> 			continue;
>=20
> @@ -48,8 +61,12 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
> 		}
> 	}
>=20
> - 	if (!page)
> + 	if (!page) {
> + 		if (!nodemask &&
> + 		    =
unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
> + 			goto retry_cpuset;
> 		return NULL;
> + 	}
>=20
> 	folio =3D page_folio(page);
> 	folio_set_hugetlb_cma(folio);
> --=20
> 2.55.0


