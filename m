Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2175D606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 03:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GvzQxD16
Received: by kanga.kvack.org (Postfix)
	id 17ACE6B05B1; Fri, 13 Nov 2026 22:42:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B3A6B05B2; Fri, 13 Nov 2026 22:42:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 019F86B05B3; Fri, 13 Nov 2026 22:42:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6DC46B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:42:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37B47120312
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:42:24 +0000 (UTC)
X-FDA: 85432327008.11.E99E083
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8554640003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:42:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GvzQxD16;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794627742;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nwf+2HzG6UFYF360JXkXKKC5JYP9E4OBQl343RFiCKc=;
	b=6/tXw65znsVX07srsF+C7VZ2Ys9Ct+kcUf4KfgrnOiLirXWo0c/cmLAJKUNmiG81zZr3hM
	pSjBPnLadmmkfzcAFpXg4cfQ/aAzqPNJD/GngekK8c4ssI8vRwRTPdpYXw27f6EDcEmTgh
	mNCr96MbgQVB3uxRCOglU932TxZISyE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794627742;
	b=pwA4o0p/1xzx6plDiCgVnB72chFKQalLBzeT49W4PPajbk1CZhsfmyF9NN0qAMqYFkg2Bl
	xhRpGNaRPvScCffv9WKKPmpipbVoLA7FSA1RCMUsSmjpiG+w6+6a101b+VnO7rP7T2mzIG
	3I3E32qcbCT/pL+KFvBwpQXc1ydC2m8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GvzQxD16;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 255DD43AF7;
	Sat, 14 Nov 2026 03:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DBD1F000C4;
	Sat, 14 Nov 2026 03:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794627741;
	bh=Nwf+2HzG6UFYF360JXkXKKC5JYP9E4OBQl343RFiCKc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GvzQxD16iSkE16ur3k6IBhdS9dm6zEJmPLQmY+fZWOtgXXCVW/iuujtB4WL+JhnrJ
	 s6RDADc4OhHs0PriXmwX+78dcqYRRzskGlhqUOo9iEirGO0M6kd6OTbhCgZu6riU10
	 JrhxA5tmtdPSMk1AZBum9pRhFuFoTVsCdOk2LA/btM9mymXmPBt8O+zR7MS/5SxR44
	 ItSNcxyc/fgmGNCuMmrTzHerEDzxZnolDlIZRwj/sVAo39Vzt9ahCRniGOxTxZ18Tb
	 x8YvHxuQ7Ts7tJO7fMjxtkrihSS3X21WpmS9KANIXN/z/o2/6RZYPlmz15EC5dy00X
	 JN7CSD7Eo/RcQ==
Message-ID: <sashiko-outbox-214123@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261113084953.412919-2-baoquan.he@linux.dev>
References: <20261113084953.412919-1-baoquan.he@linux.dev>
 <20261113084953.412919-2-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 03:42:19 +0000
X-Stat-Signature: nbghyoy16arwxq4kobrw3g55edqs865t
X-Rspamd-Queue-Id: 8554640003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794627742-569353
X-HE-Meta: U2FsdGVkX1/nR0UU9v5khXlOGVHK+MNuyLAwkT+NSIDXW/2Sn1cCQiAmA211pWWOTDJ9ZlHwMU9fctoSuCfGd+W74y2Fc9WfBJLQZoc2sUEeAuapWwPe+/oFD4Z169tRmByEFBoQYSEt1RND3cwQcIeBEPls+p5YGFOMyh9gWLKZ2Ayx/yEnA/SMOer2Ld4N11oi8Mpe5JLBD2myCLVJ/je0TzEPSeOLyQXvPInUjw89JN09Y2cAh+TKhHfylTbLQ3eYlf4RvoVeX7viwW6aasMnaOxhDfwCAv7AGeVoJBbp11SLRTZOpoi8sCKj8CPQ9tKZk3gMDMbax482WsipzND3bdEv/4KLZasDvJdEhaP8EJvE8HquOkUkcnnOs3DDAjWRDzWssloilLGwtgycFk5EMYVbFpS2vvCSce+3NlHvW8r91ojayifljalXpsJ+mdMoZSz0oNFjDjV77qTn5ARkx4sgr/gbbz55AA6+QYHudzkwe8OUcbftwS/Y3P2IyidKNELBsDTFpx10DGRavrAzVrA9Z3e8GEZI7WJQ8RBNVXotdXeLu8al0tlpb0hnYhb+QgD1NVnE5urjJUDEzpbC8v9d64+ag91Qvpsl763WxKq/SJcsIgdWiMz/IEnQsKjh05xSskBCAKkGe737MZoiYYm+8SnHDNF5sGJC9aL01hveyoYcdIgYAyLVaGgM49DbdmCRSDs75lgCl/EXD21YbwDFmnF+nnkHV9ViLWXdFl7tkb6vSf3clAvFL5AfjRFgK8IjOF6TJtGMS1aQTNLNUgz6wy+cw1Ni3sUyeRua2y+n7RRQ/YTID1OWrjBFgnxd4x1yqAp50WBEHmFhJ7Uy3CRsa4zYXpiaQ+DG/CeISpcmFh0d+lIe0qWF6vos0ZpyL4zBDwg0z6h9dpqsz4OFTCS3+dhm1YWpluBN+NGe+WXf4KHT0Ui/Bh0iufbI6lG+rd9JPnMQoGSWgBU
 jKpgFafD
 t1vmctzjhnmKLFaqHPjWeapR+1LTrItAL5+DaWOChgNFLbColjwpVEiaClBEQYH2VC//xQCVzvW8HFJPKxRgdm0bZSjNSSJMtf9FngH1WsoDv4wd3ADMay4XpaiYSKk93R9qJY2J1SovS/bimH4vySjD5IeBf2WrC61zIQRyMoIZJSK+3SjdbThGH7sV/AKNqxT3gAZGLkI24MWU+tKecUP/lu1Sq5aLOyHp/EOm1YX6+oci87hlHfBPEx0adOv2oasg5Jk1IHnQoim5XoiyLpJcZIbhhRGbpCxIsj4Io2OwKq/cdltptH/2i1veAuBb3h8cCyQ7Uw1B7Otm352SGsnrQPMkqJWYunw7Q8pWHMnPFG1+af+1Vvf7q0fLiCFR/qn0VS01kG0HxndkL4Hqe8MyJLffMjnlVbKO97LEI63SPJxaqJVVHMCBqUD0cfgzv9HV6hRYssnKd99aXaHKRcVJVuEIHVnSt/ziGtS3CJ1JVpo2UXox+1rgzpRv6GCWT+rxpZKYWGMj7BZ38BWVe2DxF2kKpiAff8m/S9F3B9EqDw+fXgudwLRR0EW2QikFf1qSn5abg2/riAMEE/auYhtPLGmsjOj0bkvWy5CTY6a5pCVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm/mglru: get_pte_pfn() and get_pmd_pfn() skip non-young
  entries in walk stats
- [Medium] mm/mglru: walk_pte_range() undercounts MM_LEAF_ASSOCIATED on
  large folios
- [Low] mm/mglru: mm_vmscan_lru_gen_walk tracepoint defined outside
  CONFIG_LRU_GEN
--

commit b5309c24549f959bf1eb3e88053e43540b30ee90
Author: Baoquan He <hebaoquan@kylinos.cn>

mm/mglru: add MM_WALK_EMPTY stats and tracepoint

This commit adds per-walk statistics and a tracepoint to track MGLRU aging
page-table walks that find no folios belonging to the target lruvec.

> diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
> index 9dafdb5bd3ce8..2b268fd0f89e8 100644
> --- a/mm/trace_vmscan.h
> +++ b/mm/trace_vmscan.h
> @@ -763,6 +763,34 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
>  		__entry->nid,
>  		__print_symbolic(__entry->reason, kswapd_clear_hopeless_reason_ops))
>  );
> +TRACE_EVENT(mm_vmscan_lru_gen_walk,
> +
> +	TP_PROTO(int nid, unsigned long seq, int leaf_total,
> +		 int leaf_associated, bool empty),

[Severity: Low]
Should mm_vmscan_lru_gen_walk be placed inside the #ifdef CONFIG_LRU_GEN
block alongside mm_mglru_scan_folios and mm_mglru_aging?  Its only caller in
try_to_inc_max_seq() is built under CONFIG_LRU_GEN, so defining it here
generates unused tracepoint code and tracefs entries when CONFIG_LRU_GEN is
disabled.

[ ... ]

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 25a224746c36d..6034bae03dc21 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3582,6 +3582,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned lon=
g start, unsigned long end,
>  		if (!folio)
>  			continue;
> =20
> +		walk->mm_stats[MM_LEAF_ASSOCIATED]++;
> +
>  		if (folio_test_large(folio)) {
>  			const unsigned int max_nr =3D (end - addr) >> PAGE_SHIFT;

[Severity: Medium]
Does walk_pte_range() undercount MM_LEAF_ASSOCIATED when a large folio spans
a batch of contiguous PTEs?

When folio_test_large(folio) is true, folio_pte_batch_flags() sets nr to the
number of batched PTEs and adds nr - 1 to walk->mm_stats[MM_LEAF_TOTAL] and
nr to walk->mm_stats[MM_LEAF_YOUNG], before the loop advances by nr entries:

mm/vmscan.c:walk_pte_range() {
    ...
		if (folio_test_large(folio)) {
			const unsigned int max_nr =3D (end - addr) >> PAGE_SHIFT;

			nr =3D folio_pte_batch_flags(folio, NULL, cur_pte, &ptent,
						   max_nr, FPB_MERGE_YOUNG_DIRTY);
			total +=3D nr - 1;
			walk->mm_stats[MM_LEAF_TOTAL] +=3D nr - 1;
		}
    ...
		young +=3D nr;
		walk->mm_stats[MM_LEAF_YOUNG] +=3D nr;
	}

Because MM_LEAF_ASSOCIATED is only incremented by 1 before the batch size is
computed, the remaining nr - 1 PTEs in the batch are not counted, and
MM_LEAF_YOUNG can end up larger than MM_LEAF_ASSOCIATED.

[ ... ]

> @@ -4158,8 +4162,28 @@ static bool try_to_inc_max_seq(struct lruvec *lruv=
ec, unsigned long seq,
> =20
>  	do {
>  		success =3D iterate_mm_list(walk, &mm);
> -		if (mm)
> +		if (mm) {
> +			bool empty =3D false;
> +
>  			walk_mm(mm, walk);
> +			/*
> +			 * A walk that traversed page tables but found no folio
> +			 * belonging to this lruvec (node+memcg) is pure waste.
> +			 */
> +			if (walk->mm_stats[MM_LEAF_TOTAL]) {
> +				walk->mm_stats[MM_WALK_TOTAL]++;
> +				if (walk->mm_stats[MM_LEAF_ASSOCIATED] =3D=3D 0) {
> +					walk->mm_stats[MM_WALK_EMPTY]++;
> +					walk->mm_stats[MM_LEAF_EMPTY_WALKS] +=3D
> +						walk->mm_stats[MM_LEAF_TOTAL];
> +					empty =3D true;
> +				}
> +			}
> +			trace_mm_vmscan_lru_gen_walk(
> +					lruvec_pgdat(lruvec)->node_id, walk->seq,
> +					walk->mm_stats[MM_LEAF_TOTAL],
> +					walk->mm_stats[MM_LEAF_ASSOCIATED], empty);
> +		}
>  	} while (mm);

[Severity: Medium]
Does this count a walk as empty whenever an mm has folios in this lruvec
whose PTEs and PMDs are all non-young?

In walk_pte_range() and walk_pmd_range_locked(), MM_LEAF_ASSOCIATED is
incremented only after get_pte_pfn() or get_pmd_pfn() succeeds, but both
helpers reject non-young entries up front when the mm has no MMU notifiers:

mm/vmscan.c:get_pte_pfn() {
    ...
	if (!pte_young(pte) && !mm_has_notifiers(vma->vm_mm))
		return -1;

As a result, non-young leaf entries mapping folios in this lruvec are never
counted in MM_LEAF_ASSOCIATED, and any walk over an mm whose mapped folios =
in
this lruvec are all cold has MM_LEAF_ASSOCIATED =3D=3D 0 and is recorded in
MM_WALK_EMPTY, MM_LEAF_EMPTY_WALKS, and trace_mm_vmscan_lru_gen_walk() with
empty=3D1.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113084953.4129=
19-1-baoquan.he@linux.dev?part=3D1

