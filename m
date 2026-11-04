Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B947E606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QxPL261t
Received: by kanga.kvack.org (Postfix)
	id 1EC2B6B05B2; Wed,  4 Nov 2026 01:18:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176976B05B3; Wed,  4 Nov 2026 01:18:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B336B05B4; Wed,  4 Nov 2026 01:18:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CAD536B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:18:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 608D5C0655
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:18:01 +0000 (UTC)
X-FDA: 85396431162.20.CD32565
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C43D2160003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:17:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QxPL261t;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793773079;
	b=5Uceb1KdVYeRCgOtXktyYgU/utul8pg5viYpBnFCyIeNc0Skm7MFmxyPVriSBjkbCb7ylR
	+C8sJW0KZ4qiZHK0Mxd4PED2/h0J5kBPLtQHAJ/yyFBKwz+r70UR7OY8nTkbhGm2b1usME
	jlY4uoWeyh85ClLj7D+kkwQ/xYUJ8+U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QxPL261t;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793773079;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzRz0mWVu4wXP01ly7b7+gfO1U+HljkH+loKYdoDA+Y=;
	b=ydDt4uD1ncKt6iUKkq7MbxJCGSQx8nAfkQgO0Ap+7Cq8s//wJ23ZtNJtJfgB8RjRd0sDOu
	U0L8hcavyw6H2zU9LUqWO0f58OyV6aETyPKjln0eS2AG7ToqYXmO5WoKS3tVa3HLt2woxD
	lDiEijweCGE3PGPixCXVCHQO4fO35Xk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22041601F6;
	Wed,  4 Nov 2026 06:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E204F1F000C1;
	Wed,  4 Nov 2026 06:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793773078;
	bh=KzRz0mWVu4wXP01ly7b7+gfO1U+HljkH+loKYdoDA+Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QxPL261tfgN71EeYGn9wxGTO+7F7xwxREMzTTfaCc+lw1jsv93bppOiSf6UJTQsFK
	 Z5vR0aXEeelAWTxuaFMULwgeulpj8bdAOjJaOEZKf+HcMBrnLJyyAHO+4WwBSm9Ej5
	 qz4mgNO/3Yfs4JsvlB9Zpbx/vtx9l5cGCLZp5U+Vzj+j4/ndUSS6cvyifS5kaAqNWT
	 aBjbkcLiwsvVyYRBHT0bi1dILTDloKP5DQo7KgQRC8FbnOm2T5mzH/ACMgDTWeFhBp
	 5ef267A/XnYuEFUfRABED374bD+Y7/W+k0Cf3l0XqaiK3DN0dKH+fZnBz1cwuyPLEj
	 0ZEPzzJ+TCZQA==
Message-ID: <sashiko-outbox-196742@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 04/12] mm/hmm: do the plumbing for HMM to
 participate in migration
Reply-To: sashiko-reviews@lists.linux.dev
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, "David
 Hildenbrand" <david@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Leon
 Romanovsky" <leonro@nvidia.com>, "Alistair Popple" <apopple@nvidia.com>, "Balbir
 Singh" <balbirs@nvidia.com>, "Zi Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@suse.cz>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Lyude Paul" <lyude@redhat.com>, "Danilo
 Krummrich" <dakr@kernel.org>
In-Reply-To: <20261103061629.972669-5-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <20261103061629.972669-5-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 06:17:57 +0000
X-Stat-Signature: r4jmro8uyw1p31kwiomjy939f8yp76wx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C43D2160003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793773079-413671
X-HE-Meta: U2FsdGVkX1/ab5EGwvERMf54tnpiE3V5KlAZ0jvx7gJgZzga/GhLAU3KAfnXTgTh/AcSNtXCuGyBjqlKBX9QYmqQSJO2E1HeEkN44xJRuHqWZ+Ds5GtbePiKv9gKTbNhNU7P8Xzk2ZnGRgvJbDNuzNC9Yt44D0XQFnqpz8VosnuZOFcbJAZYu/Q4bFPF0oGsC9uBy4KZlo7t9cWwfKuGGh63soFniELbyYCNX9SHGwKAfIr3JP29g1gAZTVkjwzSrk58VlhfPC98FyMyNxecfyJSo76+J8eW4EAIS2vEeqir7wwgB3WZ68SkAwXE+LVBnAptuxfpShIELE9JU3El9fHP5XAcybzm5WuwNcuDljDadu6dxHueh2qx4cTDIO2NK3Y7AupXsXcPx9kOAXDRRo5g021U8UYkImNSKvbrUehVYVwBzhNiNmpWrj8qZR2VIKrpSrkLQZ3Qqxy+U4EBPe/iG5dfxOyjmWpBN+WIY1Q0FzrbMkwn7GmI9CRT5AdXRQRnH0AQSTO3qxdnoj4vgyu7SJfTmRhUCQ4ZDjk7h5W2gjwsknwSgQ9in8QHFElrYEk0YzJD5mgOWoNY7rGjEia1AEl0OdBY6gvPUFftzh9khfkx/NmJdUAF5r3H7y8Xc6Cu0dTCYyiXiQmSYgorskZMrGoFVcp+Weh3JrdbOsjTX63ev1pYxE4U1v01Nc8Tp7tfyvtGdYlwOHw81Kw3J9nPvHbYNs0oL/GFaxlbG18w88qCLNYwt5r3D25caWinwEnyIKTbMQgwWqWO6GR8gezXTFccIwMYXVJZE6XXOG/qPngV9K6APCo87CAkjdRYON+zB+dZ64dKal9cNr1PsPQj0kkwpnnJo0UqmY+WfhoNj/lPDbGYRTZsiwKwgnVDhPyx1T7TivsBjp3SrZQnSC7Z+YO09P9AdEm6TOJAkTi6qSBbNLBpKAu0yqV7Dz0ClfTXWDY2yFb7ra47di4
 yjzvSFjL
 MWiVZx4Lkoa5szuB3eWE85fTVn5KK0ugOFLWPX8asZFRtczCM22RHv9ttc3No60SDmotXz1GfZFObAjXaWJsUH/WWYYRU3DBDALf1tCL2DAY9bhF1gi6HZFG8To8hjzOAiKBqutGVMeXAlvym1/3cGQ6wEbNa2Rp0HnPO/e7rqjlUyEQquCApexuwemBOB7QUUKHQIyActdxJefKWNJpODD3qQxJk+1M+v1gMFG74N+fffpNesA99hE8Y52J3vVa/GV+zrIONZGmOBRqrMf0YxhOVMqi1JbBz8G7XW2IBmR1GVrxP7wweUYetxP9n4X5EPByf9cxJo+e+hwaU0u7kjErL1zRkN9R9B6BIxLQqD/GAs1uYFgjDtI3Brgn0vHM9wYNNfufjLmNL6H1h7bLDbAnHQqihY7hSy7ccaHjFvUUW+LAl0ANxpc+jKdgJyvYQoprVglEUvRnjB1I1FS0cBdwvMCYlvM4EJ4TFF719wOmOag+aioHTi0Is4vGHFVUEjs2iGEvAVZl7wlZauL8K2QjIIuG5KPT3REx5g8qyB8eGQBIn8RzQLgARYTXTzPP00pp0HTQ62CAyJ8C+zSc54kGeJOZTx9sN6D4uIFlpVQ25dgk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/hmm: hmm_vma_walk_pmd() skips remaining PTEs on folio split f=
ailure
--

commit 467255657c2d81a197c74dccb6095cef3e48051a
Author: Mika Penttil=C3=A4 <mpenttil@redhat.com>

mm/hmm: do the plumbing for HMM to participate in migration

This commit prepares hmm_range_fault() and the HMM pagewalk callbacks for
migration collection by adding PMD and PTE locking during the walk and wiri=
ng
in the migration preparation hooks.

> diff --git a/mm/hmm.c b/mm/hmm.c
> index 9220e6648636d..854d2c090b20c 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c

[ ... ]

> @@ -532,24 +739,65 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  	 * recover.
>  	 */
>  	if (pmd_bad(pmd)) {
> -		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
> +		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns_start, npages, 0))
>  			return -EFAULT;
> -		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  	}
> =20
> -	ptep =3D pte_offset_map(pmdp, addr);
> -	if (!ptep)
> +	if (minfo) {
> +		ptep =3D pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
> +		if (ptep)
> +			hmm_vma_walk->ptelocked =3D true;
> +	} else {
> +		ptep =3D pte_offset_map(pmdp, addr);
> +	}
> +	if (!ptep) {
> +		addr =3D start;
>  		goto again;
> +	}
> +
>  	for (; addr < end; addr +=3D PAGE_SIZE, ptep++, hmm_pfns++) {
> -		int r;
> =20
>  		r =3D hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
>  		if (r) {
> -			/* hmm_vma_handle_pte() did pte_unmap() */
> +			/* hmm_vma_handle_pte() did pte_unmap() / pte_unmap_unlock */
> +			if (unmapped)
> +				flush_tlb_range(walk->vma, start, addr);
>  			return r;
>  		}
> +
> +		r =3D hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns,=
 &unmapped);
> +		if (r =3D=3D -EAGAIN) {
> +			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
> +			if (unmapped) {
> +				flush_tlb_range(walk->vma, start, addr);
> +				unmapped =3D false;
> +			}
> +			goto again;
> +		}
> +		if (r) {
> +			/*
> +			 * Splitting the folio failed; migrate_vma_split_folio()
> +			 * already dropped the PTE lock. Don't migrate the rest
> +			 * of the pmd range; addr keeps its valid pfn.
> +			 */
> +			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
> +			if (unmapped)
> +				flush_tlb_range(walk->vma, start, addr);
> +			return 0;
> +		}

[Severity: Medium]
As reported by Sashiko on v16 [1], when hmm_vma_handle_migrate_prepare()
returns a non-zero error other than -EAGAIN in hmm_vma_walk_pmd() (such as
when migrate_vma_split_folio() fails to split a PTE-mapped large folio in
the subsequent patch "mm/hmm: migrate collection in HMM pagewalk - pte
level"), does returning 0 here leave the remaining entries in
[addr + PAGE_SIZE, end) completely unprocessed?

At the start of a migrating walk, hmm_range_fault_locked() clears
range->hmm_pfns[]:

mm/hmm.c:hmm_range_fault_locked() {
	...
	if (hmm_select_migrate(range)) {
		WARN_ON_ONCE(range->pfn_flags_mask);
		WARN_ON_ONCE(range->dev_private_owner !=3D
			     range->migrate->pgmap_owner);
		memset(range->hmm_pfns, 0,
		       ((range->end - range->start) >> PAGE_SHIFT) *
		       sizeof(*range->hmm_pfns));
	}
	...
}

While the current address addr already ran hmm_vma_handle_pte() and keeps i=
ts
valid PFN, returning 0 directly from the PTE loop terminates processing for
the rest of the PMD range [addr + PAGE_SIZE, end) while reporting success to
walk_page_range().

Consequently, for any addresses in [addr + PAGE_SIZE, end), neither
hmm_vma_handle_pte() nor hmm_vma_handle_migrate_prepare() is called.
Independent migratable pages in that remainder are not collected, unmapped =
or
read-only PTEs are not faulted in even when HMM_PFN_REQ_FAULT is requested,
and hmm_range_fault() can return 0 with those range->hmm_pfns[] entries sti=
ll
zeroed and lacking HMM_PFN_VALID.

[1] https://lore.kernel.org/r/20261021060506.2377545-5-mpenttil@redhat.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103061629.9726=
69-1-mpenttil@redhat.com?part=3D4

