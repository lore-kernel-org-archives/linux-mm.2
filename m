Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68120606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 04:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c/nlyu/A
Received: by kanga.kvack.org (Postfix)
	id 8E88D6B05B1; Sun, 22 Nov 2026 23:08:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0076B05B3; Sun, 22 Nov 2026 23:08:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6216B05B4; Sun, 22 Nov 2026 23:08:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6216B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:08:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 703A81C4196
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:45 +0000 (UTC)
X-FDA: 85465052610.19.B09BDC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C23EC16000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c/nlyu/A";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795406924;
	b=Vk3NkREPpxU0UQ6a/TEnxMpeRcpV0CC5GDQkQzZ2eP3p1AfB1l5ysHCvFUtq0COZIfGgxq
	8sHoI9VnPKWCBq1yoF4PSha8mgaAhwIwszkS4wOFlYIMILhOG9jmoUSehyXWXyq2COelVq
	2HT62FuAdXfn7xZteM6hU/XvFbgEmUc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795406924;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KbHiK+tbKc8z4+9rDwZXQpbe/TdyUqeeeLM5uBamUDs=;
	b=yc0ORaW91OoqxkUjiMvv//W94alrZeB7GqQBEWenqefnzBSvxUpcEe2wxgDL33Ay04cRKy
	w9ma1k17CrMAei5g0i847KpylflqPIxR4cHzkTv4rehS9ifcxw86Lw8Q8v2QXCGb3sPoJ4
	KqQqSlt2NPZAZVoLSslj1w5ykBFenw4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c/nlyu/A";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6B5540996;
	Mon, 23 Nov 2026 04:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73101F000C6;
	Mon, 23 Nov 2026 04:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795406922;
	bh=KbHiK+tbKc8z4+9rDwZXQpbe/TdyUqeeeLM5uBamUDs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c/nlyu/Aen8sZQm4PZZSwkmoYsgobvfov9qVxOc05xv7J1QPtwLPIPqkX9Mr0pGa0
	 xqh4pEdw/yES0eDesmHqJnBZmiPLpx9mniTdlpR42Ctb1+dvVRaMHv8RQTOBzBATNT
	 t6z0f6g62qFMd6fH0Av8TAjcFsDr7Mcunw/EhJ8pEw91VOglx71WJngQtW3OOue393
	 VccffgOLSIFpR46e30q8yxQTBMY6pogZyp++mDuyw3mC3RHhqxUklSMp9jV1v7O1t0
	 9SoCRpYUYZJ8bLF/ASSfVidvzx8jXIXWhHQJdo2Nkv+NynSjVCLT6HE7H+LVnJCynw
	 xOCljZBsmyp0g==
Message-ID: <sashiko-outbox-228631@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/19] hugetlb_vmemmap: Always flush TLB if needed
 upon PTE remapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Houghton" <jthoughton@google.com>, "Will Deacon" <will@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "Linu
 Cherian" <linu.cherian@arm.com>, "Mark Rutland" <mark.rutland@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Nanyong
 Sun" <sunnanyong@huawei.com>, "Yu Zhao" <yuzhao@google.com>, "Frank van der
 Linden" <fvdl@google.com>, "David Rientjes" <rientjes@google.com>, linux-mm@kvack.org
In-Reply-To: <20261122184453.2668189-3-jthoughton@google.com>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-3-jthoughton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 04:08:41 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C23EC16000A
X-Stat-Signature: 48x5prjs3mgndfx8b854dueah4i8p8jm
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795406923-782630
X-HE-Meta: U2FsdGVkX19F2Fah8X9z7apVLmVs4p85+Rg56AjrmrpP4d5t+zj+MQNNmX9eJRIuclLz7TOev5ZJ1hnfGdGRRzacActqoZ1nxFmT3UPRAEpYHOOEu/IjvLDD+VA7dXrgHVU5MnHV09kMjUowWNLWWiPMbRl/DNiEQbgWLF+F3GqyVUotpjpz9XfQVjFC4yXa9Y03yBNkxeK68KwposbIrl4a1HN1PFog6lYEELEQ0bHqWINmjGbNTXKhFw410hKN3s3WCQrqQ36ckmvWZii6tJGFlcPL30w82A1trgma0E4pM7Mefxxn9/1WYhA34Ojw3aN2MZYh7/vRVrav4deTjf258hBuzHvspHZq9OCQT/13kgO1a7XvRNxHkwDbinMfJjWvu6seLdpfR2INX05eq2DtyJYMJCxCY2ACCCRr6s5HdFggJv9KqMfyOSuCNL22GKcuGf6bPmQBRdof5dbpAikZcuyIAdCwNeovTHglu4gXwfeVVDBNc9KoRK+59SvP6CKvSjA1Za6PmTAW9Ff/xtoFCU8qw2wKDKuuIkGwmCG4TJaN3GhsQEZQMgjvNRkGqHUehl2rePjduy4H2rRY+A3vCm5FKzSsf1C3S9zwMC3M4O0pd0+3C7dR7KlthBoDSCxG72m/uicVDFvdi8J8QVcXLq3Z9ZbdXY8GCkLVVxRZGqJ3iWNAxdHa5tOqnDp+FJ9182sO3r/rFQ7CmuMWLnqe6Qo3Iwwj5JyREkFM39c8UnpZ/B+/t+74ML1g4zuLioE73HEUOyih6HDm4rteFAEoIxJaLbj7t5INWXl4+tE4H5Gldz1hYQJjfrXQ/bFMkSBBpHr/T2gQn2DfxjijA0Tif1srS/SxSbxcvYxnL/lBhnRCBIfRg/PYTwDMOQmvhL0fm1DaAxKx4oeYM4o8CLG6KSNN9TWq7nL5V5zThOHk0eGicZT19IlEB/NCgYT6gJkdFspVDbdonUNlV8V
 aV9Cn4oW
 HZ3KUiX+wFF4AbxtLDcF6At+clQMJN+dNyY0ySaD2IgwOT0xdaxpCpyHlLz2XtObi5mNpdsq3O/q0IK95ZDguHeQe1E4w100HkpcHomgDNRo4TKBgj6O4zMHw6E18jEkc2aCFuDxHtIrL10uM5PwuiNuD2YBqemOr0dmUFFt4rpn8jP+JllDb4OURDKOOZkNJF0vb192yrF5nsBYyHjnp7Rs2q9w6x+sKDAmUNGEuMUNnqgmk9tMbx9r9JJF+/hms1XmYAA/bFmbZba0hNEVQ73BkVmhNMXxA/+Uh3x0BwWzTRsqkqDo9gn3dwrgcQcNxVnMRlauiX+tUKngWCsgzTIyhfXFI0w0rLZ6MXTm5flQOng/HXKJTs24geJf+g8HRHXUH6yDjvIjCVLtFuLsx+idOTNu+GQ6hu7QG22mTermqPh3BvbQJ8ZdvuXD0ft2Uhm558qd/ygGnbYqrA5iJ+3canogdJkWwOA0//v4xG7YjiBVJiLBsmPiTqmIZw3xl7Sse4O02Hfh5kFCaTj84qJCi+ruxZt6VTf8oa7/TTrzNAcs2avHxOKJihYNs8NZS7JTncmKS0ih0SSKvJAsPhJ1VDypJhesKK/cMub5Dubm1RsZHYVSwLs5AFIBnD3uxEj/RwoYr78xguIJO7A6sYAUbb66jUL+Zdc34sOTjtO+mjcMBqVvoyTZn733cq1mms+sSjhCrM8175eI3JCHuemJLB0bWDsJ/hArlXv0Dbx2Whh36TYvbufISFyD4VakpCJoRjtMN/fRkzQEFKTbyHsxTLld1YI5JbBFULYJSPOuncxi+XYd4sK1ezWYlmgcN9W0CKbTDQk1ZyqZbbZItIrU/okQuOjJU1zTy2uA42bP8xrnA8s55d7U0IdZhHMriwVfe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] mm/hugetlb_vmemmap: unnecessary TLB flush in
  vmemmap_remap_range() on error
- [Medium] mm/hugetlb_vmemmap: partial HVO state retained in
  vmemmap_remap_range()
--

commit ec5d75eb023f87eb7c8518a7fd62d721c52bb9db
Author: James Houghton <jthoughton@google.com>

hugetlb_vmemmap: Always flush TLB if needed upon PTE remapping

This commit removes the early return on error in vmemmap_remap_range() so
that flush_tlb_kernel_range() still runs when walk_kernel_page_table_range_=
lockless()
returns a non-zero error code.

> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 09b9fd83c1985..7be08c68c2f18 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -163,13 +163,11 @@ static int vmemmap_remap_range(unsigned long start,=
 unsigned long end,
> =20
>  	ret =3D walk_kernel_page_table_range_lockless(start, end, &vmemmap_rema=
p_ops,
>  						    NULL, walk);
> -	if (ret)
> -		return ret;
> =20
>  	if (walk->remap_pte && !(walk->flags & VMEMMAP_DEFER_TLB_FLUSH))
>  		flush_tlb_kernel_range(start, end);
> =20
> -	return 0;
> +	return ret;
>  }

[Severity: Medium]
Does this issue an unnecessary broadcast TLB flush across [start, end)
when walk_kernel_page_table_range_lockless() fails with walk->nr_walked =3D=
=3D 0?

With memory_hotplug.memmap_on_memory enabled, every runtime single-folio
allocation via alloc_fresh_hugetlb_folio() -> hugetlb_vmemmap_optimize_foli=
o()
hits PageVmemmapSelfHosted() in vmemmap_pmd_entry() and returns -ENOTSUPP
on the first PMD with walk.nr_walked =3D=3D 0, triggering a full
flush_tlb_kernel_range(start, end) despite modifying no PTEs.  When a walk
fails partway through with walk->nr_walked > 0, this also flushes the full
[start, end) range rather than [start, start + walk->nr_walked * PAGE_SIZE),
and vmemmap_optimize_folio() immediately flushes that prefix a second time
via vmemmap_restore_range().

Should the flush be gated on walk->nr_walked > 0 and bounded to
start + walk->nr_walked * PAGE_SIZE?

[Severity: Medium]
As reported by Muchun Song on v2 [1], does this change and the follow-up
patches in the series still retain partially optimized vmemmap states
instead of preserving all-or-nothing HVO semantics?

Later patches in this series (commit "hugetlb_vmemmap: Leave pages partially
HVOed upon restore failure" and commit "arm64: Implement
try_update_vmemmap_pte using the AF trick") cap cmpxchg retries in
try_update_vmemmap_pte() and leave folios in a partially optimized state
(VMEMMAP_REMAP_INCOMPLETE) on failure, which the subsystem maintainer asked
to avoid by not bounding the cmpxchg retry loop.

[1] https://lore.kernel.org/r/B8A44041-1516-4405-976D-534AA2412A49@linux.dev

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122184453.2668=
189-1-jthoughton@google.com?part=3D2

