Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FECC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A8B6B009E; Mon,  6 Jul 2026 02:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B316B009F; Mon,  6 Jul 2026 02:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61A86B00A0; Mon,  6 Jul 2026 02:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7894A6B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:18:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3E78C1277
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:18:30 +0000 (UTC)
X-FDA: 84957347580.16.412482E
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 16916140003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:18:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qedUTxBs;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZ6xgAdYKS8O1X/lOii7G38Nbi208QlwMN5ZwaD1TsA=;
	b=m95IUN77xtb69mss2zSJLg+2sJu4bnNC0JsalIMrAP6MC2jRxTQSvyyxPsr287IH33hdPR
	RdeJHa3bwO+m4ZCtjQaV0fnL0fF1f9GMbjtkw8D8UvhnJVVVXnc5km8g1eOkENCVsytEUh
	lbVEPAZVAo+S202OpnIdT92qRkR46bY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qedUTxBs;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318709;
	b=SE1Awlxn+GHWDipqrxP5ZHVldxyrLt6uEgbra7S8tMBdqn7YKgbEy1mbmfTDUNdiq4wYrL
	vwAsGmwRuuogDGyWPdg7TM7taqqruqa2gVL4a6YpecYYq/nOcHN+Nvs7u6PnxSeAzWRomw
	HYDDYwy0Y1ZPvMoHnd5ETcRFnZVcE/c=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783318707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QZ6xgAdYKS8O1X/lOii7G38Nbi208QlwMN5ZwaD1TsA=;
	b=qedUTxBsENU1qehZ7iaKg/Xctt7LvcJZpNxSlesJ/mwYWyigCbtelsI3ODOXTSQijg7W+C
	u0h4kD1mO0sPrwBZ+VN2xZHG8w5hqGQe4MXUTgyijOzuNs/WZcXWAB1n7lXGoyKPAkfb6h
	hWL2Nbx3uEedRhexwrQfwhUT+jd1av0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3] mm/hugetlb: Fix null nodemask in
 alloc_fresh_hugetlb_folio
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260705175119.440599-1-souravpanda@google.com>
Date: Mon, 6 Jul 2026 14:17:39 +0800
Cc: osalvador@suse.de,
 akpm@linux-foundation.org,
 david@kernel.org,
 surenb@google.com,
 fvdl@google.com,
 gthelen@google.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B8DC1E3C-24B1-4608-86B1-5F12B2FF4DBE@linux.dev>
References: <20260705175119.440599-1-souravpanda@google.com>
To: Sourav Panda <souravpanda@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 16916140003
X-Stat-Signature: ebuybz7r7paqjwdxxm5bksfrqmty7mz4
X-HE-Tag: 1783318708-981640
X-HE-Meta: U2FsdGVkX1/9Ne+mzaRNP/dSsU3te1PY0yU4xmhiFrwVIxlzrHiEwjqlNL0H+eWw/q4geKOY0hS1FKNu4dqcgJijgpRnyo4kUoJvBpxKfwXYJxwyamDdXlWlXAHHYMfMR8on4YWlUw8aNu6+VR6MrQYANvetc/Rr3V20cpandNPeC+O9MIWJApTJw4lVj9V1grJnGC5VqBsuqQA5+uN3PbLezSObH0XOEXC8EfXa8vgKuAsBV7xlF/ynKUtJ6WJNqLOmgUI7rwW+tO18i2qDIAoAIZpFDVNjpvNBS3eOTpdG/aQr7ipR6bAh8y7TlqZ+AxzBVGZKY2lJ76kXxPR08LAy/+4KDir57EANNO/LiyzPRjwNcDJJYXP2U1wCX0ej+jYwdtsdYCrV6r9FrZ964KzOLKEwR95u9RzcgfKCQbu7akr724gzu5P1+Wl7XnS/XDOMfxzEU/+vbAYKAyM6DZqeo57tHADtrBEQdb21ZjfHRwu101nkrnSkkM6SbW5dOCR+pEJCC6TAmVYCADk0QbTSYa/WHdVF3YYHaY4HE+b+c8wHxoCW5qcbfuhRehskHKXGBDwWBWKLazs5KwfrN3aoBBRGaQcxlm0K9ECBhI8iYZmqjRIDpim3nMWNxqIQisKMz1PWtJvBknpnCX4yxtDIt7G4cU/Jh9NIxaUgZqF7ZF7L7rLwJVbTcfqvIkiYJyVqCF5ACDsD6+yn7+72Izw9EdFtJ7g7LnBTY8xBK/uk6JZx6l97LCLPkhKh8n3caan4/HK2m2xleBSX75ZPOTv5RFzP2J4AGBVDWtiiQ/zIPr8Qzk+V8a9RiPcP1q2fPWLODc90u+VLwLXGcdyM/4JWnT0nXWPn+BesMRWdpCP0A4oWjQGCsPGKiCI0AJHJNETqq0vG87S6dIzuOH4AVqj06nBmm5Yizu4WoTwBWtdV10IYGHiS3Hm2oI14VxTvPIDjjdYXXYKzRRfn5HX
 MEjNDgGP
 M5gboec8IZSB809JxzdwoRDCFEpHd/IGoQ7Q8MrFmyDYTpdHY4N/K/bO2Qrjr1EbRwoP6J0PeP4h2EHCbSxaPPDRXUS37QZOv58ow53d5uoliDYZsdC/q2pjF1PgQl3otZiEIdk9jVwAF5t2lIXxdrpfGX1g5oKhT7fE8dOmJWskzjEhC9P8KqtJh/1Z+vlfQFmx9Cuj99t97xgRw0np9XVjq8Lcv3AhAlrD0XCoIDG4B7qOP280bYEOEWpI8k+RUQNx+Or+cgx/k6PRWcEkLe4vWN1XQDPee1cdodwMBD7JCsptmJ5iMlpSyzxTQXhuRnYYZVQMn66UA8Io=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 6, 2026, at 01:51, Sourav Panda <souravpanda@google.com> wrote:
>=20
> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() which =
blindly
> dereferences it in for_each_node_mask(), leading to a null pointer
> dereference.
>=20
> Similarly, if the CMA allocation fails, the fallback
> alloc_contig_frozen_pages() is also called with a NULL nodemask,
> which may cause issues.
>=20
> Fix this by explicitly checking if nodemask is NULL in
> alloc_fresh_hugetlb_folio() and defaulting to
> cpuset_current_mems_allowed. This ensures that both the CMA and
> contiguous allocators receive a valid nodemask safely using a seqcount
> loop to prevent torn reads.
>=20
> =46rom a userspace perspective, this bug allows an unprivileged user =
to
> crash the kernel (trigger a panic) by requesting a gigantic hugepage
> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> configured on a subset of NUMA nodes.
>=20
> This can be reproduced by booting a VM with two NUMA nodes, =
restricting
> CMA to Node 1 (e.g., hugetlb_cma=3D1:1G default_hugepagesz=3D1G =
hugepagesz=3D1G
> hugepages=3D0), and running a program that allocates a 1GB hugepage =
area
> without reserving, restricts allocation to Node 0 using mbind() with
> MPOL_PREFERRED_MANY, and triggers a page fault:
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
> Additionally, this patch adds a missing node_isset(nid, *nodemask) =
check
> in hugetlb_cma_alloc_frozen_folio() to ensure the initial node =
allocation
> attempt respects the memory policy.
>=20
> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic =
hugepages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sourav Panda <souravpanda@google.com>
> ---
> Changes in v3:
> - Condensed the reproducer and QEMU setup from v1 discussion into a =
readable summary per Andrew Morton.
> - Safely read cpuset_current_mems_allowed using a seqcount loop to =
prevent torn reads.
> - v2: =
https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@goog=
le.com/
> - v1: =
https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@googl=
e.com/
> mm/hugetlb.c     | 12 ++++++++++++
> mm/hugetlb_cma.c |  2 +-
> 2 files changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835..ee67ea29c003 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1864,6 +1864,18 @@ static struct folio =
*alloc_fresh_hugetlb_folio(struct hstate *h,
> gfp_t gfp_mask, int nid, nodemask_t *nmask)
> {
> 	struct folio *folio;
> + 	nodemask_t local_node_mask;
> +
> + 	if (!nmask) {
> + 		unsigned int cpuset_mems_cookie;
> +
> + 		do {
> + 			cpuset_mems_cookie =3D =
read_mems_allowed_begin();
> + 			local_node_mask =3D cpuset_current_mems_allowed;
> + 		} while (read_mems_allowed_retry(cpuset_mems_cookie));
> +
> + 		nmask =3D &local_node_mask;
> + 	}

As Andrew pointed it out, it is not helpful to prevent any =
false-positive
allocation failures. We need something like the following:

  seq =3D read_mems_allowed_begin();

  alloc_nodemask =3D nodemask;
  if (cpusets_enabled() && !alloc_nodemask)
        alloc_nodemask =3D &cpuset_current_mems_allowed;

  for_each_node_mask(node, alloc_nodemask) {
        if (cpusets_enabled() && nodemask &&
            !cpuset_zone_allowed(zone, gfp_mask))
                continue;

        ...
  }

  if (!page && read_mems_allowed_retry(seq))
        goto retry;


After further consideration, I believe we only need to fix
alloc_gigantic_frozen_folio(), as alloc_buddy_frozen_folio() already
handles the NULL nodemask properly via prepare_alloc_pages().

To address the issue in alloc_gigantic_frozen_folio(), we have two
potential options:

- Option 1: Fix it directly within alloc_gigantic_frozen_folio().
  This would centrally cover both of its underlying allocation paths:
  hugetlb_cma_alloc_frozen_folio() and alloc_contig_frozen_pages().

- Option 2: Fix hugetlb_cma_alloc_frozen_folio() and =
alloc_contig_frozen_pages()
  separately. The rationale here is that since the buddy allocator
  already handles this case internally, and alloc_contig_frozen_pages()
  is also a low-level allocator, it would be better to keep their =
behaviors
  consistent.

Both approaches are viable from my perspective. I'm CCing more MM =
maintainers
and reviewers to gather your insights and decide on the best path =
forward.

Muchun,
Thanks.

>=20
> 	folio =3D only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, =
nmask, NULL);
> 	if (folio)
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index 39344d6c78d8..79dbd0baafa3 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -34,7 +34,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
> 	if (!hugetlb_cma_size)
> 		return NULL;
>=20
> - 	if (hugetlb_cma[nid])
> + 	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> 		page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], =
order);
>=20
> 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
> --=20
> 2.55.0.rc0.799.gd6f94ed593-goog
>=20


