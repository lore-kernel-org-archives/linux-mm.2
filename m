Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7418C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 02:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A842A6B008A; Sun,  9 Aug 2026 22:27:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A347A6B008C; Sun,  9 Aug 2026 22:27:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FBEA6B0092; Sun,  9 Aug 2026 22:27:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 535476B008A
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 22:27:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C33E58036D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 02:27:06 +0000 (UTC)
X-FDA: 85083772452.20.0B95CC3
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7AC93C0002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 02:27:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Fcbo87zu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786328825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z66FNj1Gk/lVU2/TFM20u7dHoZyCIxI/2tZTiSwFfZA=;
	b=N7X5au+aTp9EYU141wNmljKRpVM6/33eEiLNsLC2Ez5QS3rrEAAwEssltmXjHGh60mNrz2
	cOTEo7Jq/hXy4RaXBqyq5+V3aESz0Q2YzVY+So4XIB9CI9zw7lhEyesWLeP1ShhwZjKXSS
	6i7NMDzrrN4+FdVKCyyBL5grE6iqlK8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Fcbo87zu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786328825;
	b=pYp+4RUtnQqHC/qd7Bk7zT4jMeaWfmImoPKvXCGxoNt8bWATdDdKex4B5yKnPMUGqsvr7S
	6JE2EMU+XXBm69x3AuRjyJabQOYEYi4HblBbMy2rDgfCGQM2X88gFK/e3SSpFv3pRU6iOl
	R5bMmJI73qcguQ8z/eRmJWeV6+vJows=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786328820; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=Z66FNj1Gk/lVU2/TFM20u7dHoZyCIxI/2tZTiSwFfZA=;
	b=Fcbo87zueVnNvUrfc5okifsihZkVMNw/tkGdI1KKfWnPJgmmD12noS7x/0O95SUrItCorya2Yy9W8hUKSx9dax3LKCCv1qGFnZpOMTrfnOEamJyAqLXQ0yXvbtDXhj/E4VSfTajYXs7IGsWshhh5Mk3bvNMomhCtZN9qPhk332M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0X8c5z5d_1786328789;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X8c5z5d_1786328789 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 10 Aug 2026 10:26:58 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org,  dri-devel@lists.freedesktop.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@kernel.org>,
  Lorenzo Stoakes <ljs@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  "Liam R . Howlett" <liam@infradead.org>,
  Nico Pache <nico.pache@linux.dev>,  Ryan Roberts <ryan.roberts@arm.com>,
  Dev Jain <dev.jain@arm.com>,  Barry Song <baohua@kernel.org>,  Lance Yang
 <lance.yang@linux.dev>,  Usama Arif <usama.arif@linux.dev>,  Joshua Hahn
 <joshua.hahnjy@gmail.com>,  Rakie Kim <rakie.kim@sk.com>,  Byungchul Park
 <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,  Alistair Popple
 <apopple@nvidia.com>,  Balbir Singh <balbirs@nvidia.com>,  Maarten
 Lankhorst <maarten.lankhorst@linux.intel.com>,  Maxime Ripard
 <mripard@kernel.org>,  Thomas Zimmermann <tzimmermann@suse.de>,  David
 Airlie <airlied@gmail.com>,  Simona Vetter <simona@ffwll.ch>,  Thomas
 =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,  Francois
 Dugast
 <francois.dugast@intel.com>,  stable@vger.kernel.org
Subject: Re: [PATCH v3 3/6] mm/migrate_device: Fix THP splitting of a CPU
 faulted device private folio
In-Reply-To: <20260805231041.3791771-4-matthew.brost@intel.com> (Matthew
	Brost's message of "Wed, 5 Aug 2026 16:10:38 -0700")
References: <20260805231041.3791771-1-matthew.brost@intel.com>
	<20260805231041.3791771-4-matthew.brost@intel.com>
Date: Mon, 10 Aug 2026 10:26:27 +0800
Message-ID: <87ik5in224.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7AC93C0002
X-Stat-Signature: xg1ikxs8483tr6dkh5c4f1kx3jhg1apd
X-Rspam-User: 
X-HE-Tag: 1786328823-442368
X-HE-Meta: U2FsdGVkX18fZnxqIwsidH1FGtllYrpoVxsLJyjJOElZOJLJspoXWNzxswKxiGbtjLDrfMOKk11Dm812cHnN5wp3+DczG1vNMtlEb1ENhl4MWAU4f++E+ovAHCToVei51elGw7fsw1KJxW5405uLfgZuxw55AXDshcG4B9/uhwZSkVquhspIXHkCDA0FNyY2RP6WNuE2s/scOrgz7L+TFRtu8tvzlR+f0JS6U6Vnsbs/Y/Lc2pUv/PkaQnsqwHt+E2eNSNsrc7lDE8qFCyUWDI40x9nxeegsBmHhR2sv/zcKcyC2G1urM+AWnOwCUm5lEg4g6rIYPD1ojbWM7tqoF5UR9ezNNmrNnFxMu8OqihzusmVifZwbJVvHcaoTfbaC75jKpjo9SpG8uCTcky68gyK3UjGrYWtg0PeAV7v0wGW8hdGnlqplCYMj4x9BqGO/g/fP3lqz5fU9Mw8CV/mORem3b+OzEvmBUNdWhRU1KFSbRHdiOU0RfWyoU5tBr3a2dbCrP4MGCoPgIpj/D0sx1nLcE75phqdey+PUUqg9jHWeBnNfP5dhRJVs7Ce7g5LE5eTtGde7aInaz51e4dg0z5MT1JIuaSdmDW3JAN+6oUVWwkD1dWgV072yUNumUaPbOMrfc8QCK4X4B83hSojR9lABhf8tXRIdyH09XUfE656hWtLhZFaVCrstRsVU9okXnrLUR68/PLg3+aHGqPOGyyH21TIfneH+OWF5qoVqmtUam/JI6MDUIoju5KlzLnrrcYdl3Emhb40yu//kVHMLkF6KFeXqRKHK9b6HJ2H+XBMvPKBNzcSGFSAXfZz/XJeefhUbl/1+3C+Ki56yYUOICteoD2ICnSMnDFOW7vFzuT8ZQogyqLs84PIfCG6PxZw/euWG43ChRQ3W0OQNelP61kNNzNraKtKAz9sqljVDf3UX+SQUxERdWqKgj/n0sgpYlwNxVy/NGUGiSD6bZKK
 j1dLXE0x
 q3ja2XIL/fq5LhgMYvgA2yvfDc3CiZ/oMwl3ZETy3I1wXYd1ky9XrZPbDU/kyt1WG+JrTgB1IWfw2ioRlb7czu/ht3upHSbx9xN7hdkWyguMa6vVCR0E0gvqzQ2DxHS84nViiOsrpeFQGgCUD5dk5VzAEHcxxGVbaH0JdBLEt8pr1PK9DmbTHqv5xH9fh1Wcv6K8dP2jEW+aSbjMcXYe6fkoaEKXKY1CikQPQzttMNv+iZ4GPkq6aj9H8LdMr/utYbjeh4SvhTtwuYCKAVFsKYFaUtu8HUjE89N1z3Y/xA96dkNmd8uxGeSONvjFs2iylGjVYTLLulZ3OJwiQArNsJvG3GGQpbMR9NNzZSMwMSehLjchq3vF4WLp3tFkGtHyVwHpiw2lUJrbZuPZzSJGIyBazqsNS0ELnYvvf3lX6HeQe0ka35HhqHIl5z7KPcl/ui/s/tGz0eXVQxqZu4CEtgN+0MTJSl9tyUH/Io24al6R3fSq5he6mKR13Cm4kMDB6b3+V3HcQiaBNnW+E2H5YVJzRkp+UYwr4FL5Dd/19CvBDqULjZzpQGwfRCt0Q7IueUS3mqa9tUO0D/AUxzQ1NwmTgcWl8J2Tjn+JBKwamNqTxCjtTDOhzwYgaeXCSOwZfKYZOqaln5TooSZa9EW+qJzS49Xwo47skCwdf4+PZs9cuWlQ1bdo5quh0tEysf9q5jCx92HI8h9QoVd54lCeRIGBWTwJAYgD0xrxmUB2N9x4KsH+BntqI0IGZV47IyvG4a7zpZ3zjOBZpXRdiidq5jhdfvce5iWbXk4z+Nej0gDp/Dj741Y2zEdiCXkR42vPPbT4d08M4R01hWSI6FwKKyM/VbuxxW84bhYNKHVVDWAxPVn3kkD0VdF7dlk4qm8ymFUqt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Matthew,

Matthew Brost <matthew.brost@intel.com> writes:

> When a CPU faults on a device private PMD and the device driver can only
> allocate order-0 destination folios, __migrate_device_pages() has to
> split the source THP via migrate_vma_split_unmapped_folio(). That path
> is broken in two independent ways when the fault is what triggered the
> migration.
>
> First, the split never succeeds. At the point folio_split_unmapped() is
> called the folio carries two references beyond the ones it is
> entitled to:
>
>   1 - taken by do_huge_pmd_device_private() for the duration of the
>       ->migrate_to_ram() callback
>   2 - taken by migrate_vma_collect_huge_pmd() when the folio was
>       collected
>
> (the mapping reference having been dropped by set_pmd_migration_entry()).
>
> folio_split_unmapped() requires folio_expected_ref_count(folio) =3D=3D
> folio_ref_count(folio) - 1, i.e. it tolerates exactly one caller
> reference. With both of the above held the check sees 2 against an
> expected 0 and returns -EAGAIN, so the migration is abandoned and the
> CPU fault makes no progress.
>
> The PTE-based split path does not have this problem:
> migrate_vma_split_folio() is called before any collect reference is
> taken and explicitly skips folio_get() for the fault folio, so the fault
> reference is the single caller reference the split expects.
>
> Fix it by dropping the fault reference across the split and re-taking it
> afterwards. do_huge_pmd_device_private() derives the fault page from the
> PMD entry, so it is always the head page of the folio and always ends up
> in the head folio of an uniform split to order 0; re-taking the
> reference on the folio therefore puts it back exactly where
> do_huge_pmd_device_private() will release it. The folio cannot be freed
> while the reference is dropped because the collect reference is still
> held.
>
> Second, the folio is split globally but the page tables were demoted
> only locally:
>
> 	split_huge_pmd_address(migrate->vma, addr, true);
> 	ret =3D folio_split_unmapped(folio, 0);
>
> migrate_device_unmap() unmaps via try_to_migrate(folio, 0), deliberately
> without TTU_SPLIT_HUGE_PMD, so every VMA that PMD maps the folio is left
> holding a PMD sized migration entry. A folio that was PMD mapped in more
> than one VMA -- after fork(), for example -- therefore keeps huge
> migration entries in all the other VMAs while only migrate->vma is
> demoted.
>
> folio_split_unmapped() does not notice: the folio is fully unmapped, so
> it only looks at the refcount and happily splits to order 0. The other
> VMAs are then left pointing a huge PMD at an order-0 folio, and
> migrate_vma_finalize() -> remove_migration_ptes() walks into it:
>
>   page dumped because: VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
>                                        !folio_test_pmd_mappable(folio))
>   kernel BUG at mm/migrate.c:368!
>   RIP: 0010:remove_migration_pte+0x56a/0x9b0
>   Call Trace:
>    rmap_walk_anon+0xfc/0x260
>    remove_migration_ptes+0x79/0xb0
>    __migrate_device_finalize+0x113/0x290
>    __drm_pagemap_migrate_to_ram+0x278/0x360 [drm_gpusvm_helper]
>    drm_pagemap_migrate_to_ram+0x5c/0x80 [drm_gpusvm_helper]
>    do_huge_pmd_device_private+0x160/0x280

Which is the branch your patchset based on?  I found that
drm_pagemap_migrate_populate_ram_pfn() in mm-everything-2026-08-08-07-08
still don't support fallback to single pages if THP allocation fails as
in the following comments,

	/* TODO: Support fallback to single pages if THP allocation fails */


> Without CONFIG_DEBUG_VM the VM_BUG_ON_FOLIO() is compiled out and
> remove_migration_pmd() installs a huge PMD pointing at an order-0 page
> instead, along with add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR). The
> victim mm then maps 2MB of address space onto a single 4K page, which
> shows up later as bad rss-counter state, leaked page tables and page
> allocator freelist corruption in unrelated processes.
>
> Note this second problem was latent before the refcount fix above: the
> split always failed, and the failed attempt left migrate->vma demoted,
> so the retried fault took the PTE path, where __folio_split() unmaps
> with TTU_SPLIT_HUGE_PMD and demotes every VMA.
>
> Fix it by walking the rmap and demoting every PMD sized migration entry
> mapping the folio before splitting it. Demote with freeze =3D false: entry
> creation in __split_huge_pmd_locked() is dispatched on
> pmd_is_migration_entry(), not on freeze, so a migration PMD becomes PTE
> sized migration entries either way, and freeze only controls a trailing
> put_page(). With freeze =3D false there is no refcount change at all,
> which makes the demotion idempotent across N VMAs.
>
> rmap_walk_control.anon_lock is deliberately left unset:
> folio_lock_anon_vma_read() depends on folio_mapped(), and the folio is
> already fully unmapped here. This mirrors remove_migration_ptes().
>
> Finally, refuse the split for a folio that is not anonymous. The rmap
> walk would otherwise reach a file backed VMA, where
> split_huge_pmd_address() zaps the PMD instead of demoting it.
>
> Fixes: 4265d67e405a ("mm/migrate_device: add THP splitting during migrati=
on")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Nico Pache <nico.pache@linux.dev>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Assisted-by: GitHub_Copilot:claude-opus-5
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> ---
>  mm/migrate_device.c | 98 ++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 89 insertions(+), 9 deletions(-)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index ae9027421b80..ae17bd516d24 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -899,22 +899,104 @@ static int migrate_vma_insert_huge_pmd_page(struct=
 migrate_vma *migrate,
>  	return 0;
>  }
>=20=20
> +static bool migrate_vma_split_pmd_one(struct folio *folio,
> +				      struct vm_area_struct *vma,
> +				      unsigned long addr, void *arg)
> +{
> +	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, PVMW_SYNC | PVMW_MIGRATIO=
N);
> +
> +	while (page_vma_mapped_walk(&pvmw)) {
> +		if (pvmw.pte)
> +			continue;
> +
> +		addr =3D pvmw.address;
> +		page_vma_mapped_walk_done(&pvmw);
> +
> +		/*
> +		 * Demote with freeze =3D false: the PMD already holds a
> +		 * migration entry, so __split_huge_pmd_locked() creates PTE
> +		 * sized migration entries from it and leaves the refcount
> +		 * alone. There is at most one PMD mapping @folio per VMA, so
> +		 * stop the walk here.
> +		 */
> +		split_huge_pmd_address(vma, addr, false);
> +		break;
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * Demote every PMD sized migration entry that maps @folio to PTE sized =
ones.
> + *
> + * migrate_device_unmap() unmaps with try_to_migrate(folio, 0), i.e. wit=
hout
> + * TTU_SPLIT_HUGE_PMD, so a folio that was PMD mapped in several VMAs --=
 after
> + * fork(), for instance -- ends up with a PMD sized migration entry in e=
very one
> + * of them. folio_split_unmapped() below does not care, it only looks at=
 the
> + * refcount, so splitting the folio without demoting all of those first =
would
> + * leave the other VMAs pointing a huge PMD at what is now an order-0 fo=
lio.
> + * remove_migration_ptes() trips over that in migrate_vma_finalize().
> + */
> +static void migrate_vma_split_pmd_mappings(struct folio *folio)
> +{
> +	struct rmap_walk_control rwc =3D {
> +		.rmap_one =3D migrate_vma_split_pmd_one,
> +	};
> +
> +	/*
> +	 * Do not pass .anon_lock: folio_lock_anon_vma_read() requires
> +	 * folio_mapped(), and @folio is already fully unmapped here.
> +	 */
> +	rmap_walk(folio, &rwc);
> +}
> +
>  static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
> -					    unsigned long idx, unsigned long addr,
> +					    unsigned long idx,
>  					    struct folio *folio)
>  {
>  	unsigned long i;
>  	unsigned long pfn;
>  	unsigned long flags;
> +	bool fault_folio;
>  	int ret =3D 0;
>=20=20
>  	/*
> -	 * take a reference, since split_huge_pmd_address() with freeze =3D true
> -	 * drops a reference at the end.
> +	 * migrate_vma_split_pmd_mappings() walks the rmap, and
> +	 * split_huge_pmd_address() zaps rather than demotes a PMD in a VMA that
> +	 * is not anonymous. migrate_vma_collect_huge_pmd() does not check the
> +	 * VMA type, so a file THP can reach here; the rest of the migrate_vma()
> +	 * machinery only supports anonymous memory anyway.
>  	 */
> -	folio_get(folio);
> -	split_huge_pmd_address(migrate->vma, addr, true);
> +	if (!folio_test_anon(folio))
> +		return -EINVAL;
> +
> +	/*
> +	 * A CPU fault on a device private PMD holds an extra reference on the
> +	 * folio, taken by do_huge_pmd_device_private(). folio_split_unmapped()
> +	 * only tolerates a single caller reference, so the split would always
> +	 * fail with -EAGAIN while this fault reference is held.
> +	 *
> +	 * do_huge_pmd_device_private() derives the fault page from the PMD
> +	 * entry, so it is always the head page of @folio, and therefore always
> +	 * ends up in the head folio after an uniform split to order 0. Drop
> +	 * the reference across the split and re-take it on the head folio
> +	 * afterwards, leaving the reference exactly where it is expected to be
> +	 * released.
> +	 *
> +	 * The folio cannot go away while the reference is dropped: the
> +	 * reference taken by migrate_vma_collect_huge_pmd() is still held.
> +	 */
> +	fault_folio =3D migrate->fault_page &&
> +		page_folio(migrate->fault_page) =3D=3D folio;
> +
> +	migrate_vma_split_pmd_mappings(folio);
> +
> +	if (fault_folio)
> +		folio_put(folio);
>  	ret =3D folio_split_unmapped(folio, 0);
> +	if (fault_folio)
> +		folio_get(folio);
> +

Is it better to pass "extra_cnt" to folio_split_unmapped()?  This
follows the coding style of the other migrate functions better, like
that in __migrate_device_pages().

>  	if (ret)
>  		return ret;
>  	migrate->src[idx] &=3D ~MIGRATE_PFN_COMPOUND;
> @@ -935,7 +1017,7 @@ static int migrate_vma_insert_huge_pmd_page(struct m=
igrate_vma *migrate,
>  }
>=20=20
>  static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
> -					    unsigned long idx, unsigned long addr,
> +					    unsigned long idx,
>  					    struct folio *folio)
>  {
>  	return 0;
> @@ -1103,7 +1185,6 @@ static void __migrate_device_pages(unsigned long *s=
rc_pfns,
>  	struct mmu_notifier_range range;
>  	unsigned long i, j;
>  	bool notified =3D false;
> -	unsigned long addr;
>=20=20
>  	for (i =3D 0; i < npages; ) {
>  		struct page *newpage =3D migrate_pfn_to_page(dst_pfns[i]);
> @@ -1177,8 +1258,7 @@ static void __migrate_device_pages(unsigned long *s=
rc_pfns,
>  					goto next;
>  				}
>  				nr =3D 1 << folio_order(folio);
> -				addr =3D migrate->start + i * PAGE_SIZE;
> -				if (migrate_vma_split_unmapped_folio(migrate, i, addr, folio)) {
> +				if (migrate_vma_split_unmapped_folio(migrate, i, folio)) {
>  					src_pfns[i] &=3D ~(MIGRATE_PFN_MIGRATE |
>  							 MIGRATE_PFN_COMPOUND);
>  					goto next;

---
Best Regards,
Huang, Ying

