Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10416606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 08:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M6VCOzUx
Received: by kanga.kvack.org (Postfix)
	id 2CB146B00EF; Sat, 21 Nov 2026 03:59:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A4E6B05B1; Sat, 21 Nov 2026 03:59:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191476B05B2; Sat, 21 Nov 2026 03:59:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF38F6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 03:59:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5780414039E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:59:07 +0000 (UTC)
X-FDA: 85458526734.24.156910A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8E0B820003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:59:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M6VCOzUx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795251545;
	b=bEYktgMUBOEQ4/uOqPlyD7JyPAaEEM+HctMBBHTcSnETrd6P1sHl7rcy/XSdSbl4gJLhFg
	AspasVcwZJToU1+VrC3Y75uluyJnrg8w7L3szA5XudmNUcl9KZ/QMP8KNsA20e885isB2z
	JRWTEgl5CybaHn8qHiFVPXvD/BYIcJU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795251545;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4/TDtF5zLzUdykayQx0IjDmobABYk7840SHkgT56FsE=;
	b=zi/AjsMtvoHhUDbsw0x9V2ZSr1wgS6nuF/w5OExz8sJQaEz2exEzUALf8WHif95cgUK8ya
	BSLk27tUjPLXPmuQBtlqd36Nxyzwsrq9elR5ejP42CImjCljH5scpwrXJwz9HHxwnRSSvY
	nq37ko5tDlVg79Xa7zHho98koeH2VkI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M6VCOzUx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E069C4371F;
	Sat, 21 Nov 2026 08:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B891F000C0;
	Sat, 21 Nov 2026 08:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795251543;
	bh=4/TDtF5zLzUdykayQx0IjDmobABYk7840SHkgT56FsE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M6VCOzUxsYfKrm/ayET3YgfwBRfrqzRVuIARfa5e60fJXdSaX6r4tfwv5cgpAAx5O
	 73UhXNUP3SN7kxMQLDTS5euRk/kBTlzOd2ZXLKDsrH/3f0BNmMaIGh5etlQROW0Da5
	 2EjmY4DoxP2djoU4kiJBGTXNqqoH5fUJt/JXfXW5hUqzPzkHE+URHTDvqcv38kmgTY
	 sJG51mdX+zXJ/evW/qB6RykFkObMVKhydMyMEYkB3MGraB4KqL4v6sQr4dEdmEpWAi
	 w3uSmft8myq+FeTWZLca74LuN7vpWvxGDKmo5D2p4hGTURV6RrMluZTZ+Nea7bdvNA
	 svPpPjI291nVA==
Message-ID: <sashiko-outbox-226848@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baolin.wang@linux.alibaba.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261120085806.781225-2-baoquan.he@linux.dev>
References: <20261120085806.781225-1-baoquan.he@linux.dev>
 <20261120085806.781225-2-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 08:59:02 +0000
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8E0B820003
X-Stat-Signature: 33qnt1tt1gxochjkpoydb3cytpaa1bkc
X-HE-Tag: 1795251545-271891
X-HE-Meta: U2FsdGVkX19fJ5D/eAGdoHBB8h83Ow30jE/tMrcM11QauZnOAJxhZxIoXal+O8Kq7HMpDCEmx8xrCaBMRnjTTdVHlqdALXpzDw0PGlhWt3BsE042XHOUzQurw7+MvN8c+rULnsG5zwHafJ/GAPRee+kIA07FXgMkQ37FXTgOyfeexYm5Y+scspvIHI3WO+E8n/Iqx1IAarBE8u/FH5prAGhiGwmsiLRTcP2ehqMvBu00ugJM7Yl5qtc/qKb7G/aYPI0u9kbF3jvcV2MMXDctZ9g+iklFXe9HWtGjuIUY5LZyFuCaeqHBSBnex38fieufU7lYkqT/zM8Pqw+iuS0IvkbXMdLDn+RE/voZC/eYhiVM91wHiVDuJoWkaMHXLfu0dpdaa0t+EYpYuM1Zf5vushQ1/kqI4QupFIrKUIu7Qd9nNBBWDJYkoUH1KaSkoLqVQb6b+jimhuKUqG8H8ajOKGPyaqOP08hSU55BrWpfZNR5DwnjkUtPVQdJEYHVgFQMt/qZRjX2nWmQOe9R5y+w/xHbzII9oWyQx3MsdOvcauNKMuIzOJzVFHawAH/qKnxSr6Kc7uyGhggL9oLrHuFRs3eG9MLU0sukxcmb9WmUG/Sh/pbfowh5mUbLUWbMEcvKkiP3EmNAt8/mhglOedk3SCGbY/15CLKQgI4UzgBvkWmefYD1cB5NIX2W/HD8F05kRQHmrt+TWQTXU2l0fGh7h9Tx4/3ZmpX4/SiaGDf28rgQm/ZpDmyhIydfl81xdcngyXKtaEY5tCKq/3S9lCV920cDvH9wu+yt5o1FEDDa4WFKzSgiNCPSeGIuDEU/VocIS+HXv4jtQ6auNZZxHwJaRkTXaNstkeBZLlLtua28iRlBoM1PRGkWa6OfdVfLPE0GlkUwfHNn94qen4ralajcJEl7p0hobEFIjBBi4lRqsN/+sTazMR+V4wJFYKwmGLJAry+6oQZtqSHkr4AauBy
 6jLX9m6M
 4MWQX3d0RH6njlfZRrXqWY0UxUdjOFcHu0iuIt0tFIowDajWofZKC+CP9c0Eb+PYVn2+TsxFoo6DPGYy1A+OG1lvUzYQ0009/K5MxxlTmXuEkE8LAnb25KhZ353TZ0cMAtTkYvXzbQB/Hzq7pUDauqJuMsy3SXEjThw8lOMv9gs5ypeyw8hOWxVzEWI/2dlCoj/Zail5FQX7oHjjy5Fv6m/J770RLbszW3tTYxuoGQ+FMrjo7MGd23+10DP2lmLJbI3ZayxlSPRAn8mV4SmvIvOxmHMsKFo8SM9wRQTM5Zjfk43ka4vx9LmJA4xt9iFsFBi5EITUFn7JRwmbd1EL47GnLEU9OP5dgR4MFwrRO5pYAqJGECAjkndB0cPlDi4XJr/m7y/DupwNMWxNywarNYrP0JR8qqL3Qqz4hh9x732deDa+UuA0CNDwO2UX2IWwN/fdhSi77afaxrAzao0Sfay24eVEIoRHi4jSH6A/Be/DfDlSBFCRKj9k1KjjK7uh6TNJ6uRYi/zsYTCSyUGKlvr/h25ubIxYNl0dcQ58GhWgwgOJkj72hQU1FmjW1az/nd1rNTPcZGeTGpMlSlQrA/iGEqtq96vTB5K8YA4wpCSSzbQ+Jlf4cqjFPVYiu8XyE9spk3q7bv9JwbjwUS4cbmIYbQPYm6RE220HwWJPURSCHEayh5mPoTvQ015gRZiVdgpBAm681YBEskE93G0CYSIokLNNvCPK7b11BLOxX7IuiucFSaYPZfm/nJcp5FGw5NfJ9c8QrYbuFfGWEABQjK/zkAjw1mVo5QYgGf3tk51D+OOX9yDnEMgIcECEv0fELd6+qz2f2GrDYnd2gGMZwAd2JzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/mglru: inconsistent MM_LEAF_ASSOCIATED accounting across
  mm_has_notifiers()
--

commit 4f0dadfe0435dfb7f058c5e9c459aef67be5dff2
Author: Baoquan He <hebaoquan@kylinos.cn>

mm/mglru: add MM_WALK_EMPTY stats and tracepoint

This commit adds MGLRU aging statistics (MM_LEAF_ASSOCIATED,
MM_WALK_TOTAL, MM_WALK_EMPTY, and MM_LEAF_EMPTY_WALKS) and the
mm_vmscan_lru_gen_walk tracepoint to track page-table walks that find no
matching folios in the target lruvec.

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 6a2ad0cff7951..902f4877fd0cb 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -579,6 +579,10 @@ enum {
>  	MM_LEAF_YOUNG,		/* young leaf entries */
>  	MM_NONLEAF_FOUND,	/* non-leaf entries found in Bloom filters */
>  	MM_NONLEAF_ADDED,	/* non-leaf entries added to Bloom filters */
> +	MM_LEAF_ASSOCIATED,	/* young leaf entries whose folio is in this lruvec=
 */
> +	MM_WALK_TOTAL,		/* page-table walks completed */
> +	MM_WALK_EMPTY,		/* walks that found nothing young for this lruvec */
> +	MM_LEAF_EMPTY_WALKS,	/* leaf entries scanned during empty walks */
>  	NR_MM_STATS
>  };
> =20
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bc7579d47f9b4..36e0946bf2cc4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3584,6 +3584,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned lon=
g start, unsigned long end,
>  		if (!folio)
>  			continue;
> =20
> +		walk->mm_stats[MM_LEAF_ASSOCIATED]++;
> +
>  		if (folio_test_large(folio)) {
>  			const unsigned int max_nr =3D (end - addr) >> PAGE_SHIFT;
> =20
> @@ -3591,6 +3593,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned lon=
g start, unsigned long end,
>  						   max_nr, FPB_MERGE_YOUNG_DIRTY);
>  			total +=3D nr - 1;
>  			walk->mm_stats[MM_LEAF_TOTAL] +=3D nr - 1;
> +			walk->mm_stats[MM_LEAF_ASSOCIATED] +=3D nr - 1;
>  		}
> =20
>  		if (!test_and_clear_young_ptes_notify(args->vma, addr, cur_pte, nr))
> @@ -3682,6 +3685,8 @@ static void walk_pmd_range_locked(pud_t *pud, unsig=
ned long addr, struct vm_area
>  		if (!folio)
>  			goto next;
> =20
> +		walk->mm_stats[MM_LEAF_ASSOCIATED]++;
> +
>  		if (!pmdp_test_and_clear_young_notify(vma, addr, pmd + i))
>  			goto next;
> =20

[Severity: Medium]
Does MM_LEAF_ASSOCIATED count all leaf entries belonging to the target
lruvec (as described in the commit message), or only young leaf entries
in the target lruvec (as described in the header comments)?

In walk_pte_range() and walk_pmd_range_locked(), get_pte_pfn() and
get_pmd_pfn() filter out non-young entries before get_pfn_folio() is
reached whenever !mm_has_notifiers(vma->vm_mm):

mm/vmscan.c:get_pte_pfn() {
	...
	if (!pte_young(pte) && !mm_has_notifiers(vma->vm_mm))
		return -1;
	...
}

When !mm_has_notifiers(vma->vm_mm), every entry that reaches
get_pfn_folio(pfn, memcg, pgdat) is already young, so MM_LEAF_ASSOCIATED
is identical to MM_LEAF_YOUNG (which also only counts young entries after
get_pfn_folio() verifies the folio belongs to this lruvec), and an mm
with old folios in the lruvec is still counted as MM_WALK_EMPTY.

Conversely, when mm_has_notifiers(vma->vm_mm) is true (such as KVM
guests), get_pte_pfn() and get_pmd_pfn() let non-young entries through so
secondary MMU notifiers can be checked by
test_and_clear_young_ptes_notify() and pmdp_test_and_clear_young_notify().
Because MM_LEAF_ASSOCIATED is incremented before those notify calls, it
counts both old and young entries when mm_has_notifiers(vma->vm_mm) is
true, giving MM_LEAF_ASSOCIATED and MM_WALK_EMPTY different meanings
depending on whether the mm has MMU notifiers registered.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120085806.7812=
25-1-baoquan.he@linux.dev?part=3D1

