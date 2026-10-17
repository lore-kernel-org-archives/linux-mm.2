Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 772DFCCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 17:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676346B008A; Sat, 17 Oct 2026 13:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626FA6B008C; Sat, 17 Oct 2026 13:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CD56B0092; Sat, 17 Oct 2026 13:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5326B008A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 13:57:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D92CC0242
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 17:57:25 +0000 (UTC)
X-FDA: 85332875250.16.37C75A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3DDFC2000E
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 17:57:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="uvHF/VwL";
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792259843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vtx+65y7QTGULn7fm4HfmV0OLS9IPk81AvNxPjWvnAg=;
	b=BO6iV4QDbe2CpFK4OSgaCbyCMtBfdbdMzt6f00LqIZcbIMydp32R/th0+SUDdakDLPMB+8
	Td8SrGD3iQb7M5JPVxmkA3iFwTc7eanyctOndbBseWVQl2De9PFG4mwbasLaXwaaVVH3sw
	Ld4bZnggrJVoxsdlgrmFBRtlnrSuDNE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792259843;
	b=6lt01FoU9ZpwDKp5cBlx7Bztjjwrw3745/H9D8Qq1DTFloxdhQEzrSx6OA71Oau/2hWxT1
	Qe4hPeAE6iuNxa9zTaWg+jS/0umIMtQ+x0ze+CQPdldusXv/rk4vdHGBFhjLyPPdSne1da
	WHECMD238MUZJhWhPdAQE+kfnly+f20=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="uvHF/VwL";
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EFA660AB5;
	Sat, 17 Oct 2026 17:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35471F000C5;
	Sat, 17 Oct 2026 17:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792259841;
	bh=Vtx+65y7QTGULn7fm4HfmV0OLS9IPk81AvNxPjWvnAg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uvHF/VwLv8dVwjABFGOGu7YX5E6f4mpYaxGdV6A4uI1XwYGCY2g8SEOWe/+RFZfPa
	 OLPILKZvlDh3dI/Ao7vW26/E/1WcHDm8UeK1ac8LmJf4vFGPQkmEBRYeDq1W32KNRx
	 LQra22rpuge0dXttY1x2zi9k/LJtHVeOOBQQSayI=
Date: Sat, 17 Oct 2026 10:57:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?B?6rmA7KKF7ZiB?= <malhyuk97@gmail.com>
Cc: xueyuan.chen21@gmail.com, david@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] mm/huge_memory: lazyfree THP PMD restore races
 zap_pmd_range
Message-Id: <20261017105721.994b4c0e57bb96b4345e6da5@linux-foundation.org>
In-Reply-To: <CADQRuqv1akf67+qe+DHbfEM-nPtEjLNzz8BWBRtBVZ8VVqKubA@mail.gmail.com>
References: <CADQRuqv1akf67+qe+DHbfEM-nPtEjLNzz8BWBRtBVZ8VVqKubA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DDFC2000E
X-Rspamd-Server: rspam08
X-Stat-Signature: j64gbbexeqp536eedwc8tanszdj8p8zb
X-HE-Tag: 1792259843-246830
X-HE-Meta: U2FsdGVkX1/hQmjS2v/ovq4PSL+63FNMCzPbIyZZyZlC/YISGJmXC/WyqBZ3A2HzWxhFlX7nVciyuGh6BOByTXrZwhBRBBHEI411pFFm/kga6OqKRXXnXFuQLBNOux586IAfwLLQSmYfFKsVEje5M/PhhlWECd7I525UCb85JXJMaCA2HUT3dEIGOFzFhhSRIR2eQj+8UCvGLD5d30XJQMnTlIzK6xOZMSM32oF8jqq4bH9SDsIcizbd1TOLDXBbBJduXlxc2/HkWixqaSsbVHH/nWHGJlmzDec8QZMyUpSa/972SFtNHa/VAMDGBD6+CCu8U4ons/RxuG91vjOl69QDjyaxNpqKeu6FRYDxLyNzFpybkm6cARhVLWfTLzT4za2KKyLo87Hin/GwokYFnwoIr0OlgFUefqxtYnwoNjKG99w6Oet015xx/eaWtZtKDzCr3YaAlor5aO54nmzuwLDwcGlW4Ix4FDIH0y6RylNyDSQjoNaMZ0T/G/amz6INTh1QCUZTg/isQWrLkszWcf/38vJmTpfksZkmdYJQTn8eR6pnNCe7MZNKuh05lFZ6OPZISBAkxDtUqgmhTPHe5/2qxuiSlzqRmmG8B90/pr2RT5n9nKaCTfZeEix322AwNA3QZxAgPvhTmQbI4PofZ2Xskn41vgoFwlsgW525259eDePxvYShD2l5YemmuhwTHWYLllNabYQGMIdRD2jqyhLOItyQkiCI96ysARDH6IUGStS9CkoOLx/dCQkCyR06mM0ONBvNi/fcodz3owc2GFMN/99NJLeCED9AwJ31QRZpYTDhDJaELaSEiUY7fHbVMixF9PaLNqG4OIKcka3Ysa4dJp3Dn+wJWF67rRYlmUUXVKOE41SdYO7PzE8XnQ1An7KpH0ZvHo95rDgMRI+t5RFIvToCAt2NZiJwZUJCkm/ENed6yZmsd1I7oFjRHsO07XM+1ylDpm5P6/UQ6k2
 6zSK1igx
 E5+P/9Cd/wQDkhewOChYRXtjiD7I/TdP6w4xBWKN3jgOSvCFaBC9gJZRD8NP0vLGdhB9tWrcK7VpA6+LjarsZQfA2Ry0rYZMR6BRjBBjLqkLseknENU4b9ARkkA7y1aZMrYt/kqV4cyEGi0veesZNdUMKujduyfZsm11nepQokGroPp4ILDrkPUoor1JIzBHA7SPn1PfGKyR9dqPWkkNj/H02tNziyezP1En/74/O1TfYPfqR9+/07/2uifsgwsaRtZI0tA04GwFwOIHIH4FMhYuOi5pPSh6EEJAKpjIyw6MQjZq5LmTtgd4SQSWmWpMECw8nzDOkg9aTu29MVsURHdcuakhAHyp0Coa687l6vWj+V5ivKepqBQh05fXCwp1cUUcdKj99USVTv408x4pXoAbeOxx27aLM6s6kFZR4Ji3nCphWAQnDtqLnpgrX8DkZI8tYMsNO2e6S0bvyToubi325Ex+NImGH0E9CcSXdHSVr1aLLVJ4LeFSrvpQ+Cw4L5gjwnqg2cYV+W9BEcbMAYx+OryKlHIiALRyNQ0QoKS+0rcYHFQ+iWDx5jDixKDSNyDt7drNix8wuOERF37gZtTLc43RMjBVvdYzVRz0ffui1nY9uZ5b6KYuSYykDbKcCm9tju/hlg4zcrHtPPz1JEr8pmE725ruC+3TC/AVXKCaITSV/HAGf4qTDJ89S44Lgc+90ZAHfNviDcMia1PXpKE8Lhu5odCdYKqguBlYmjGpjQOWcp0vJWqjsMoYZHay+qj3S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 17 Oct 2026 12:05:49 -0500 김종혁 <malhyuk97@gmail.com> wrote:

> On Sat, Oct 17, 2026, Xueyuan wrote:
> > This bug should be fixed by:
> >
> >
> https://www.google.com/url?q=https://lore.kernel.org/linux-mm/20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com/&source=gmail&ust=1792343148969000&sa=E
> >
> > It is already in mm-unstable. Your reproducer would be a good test for it.
> 
> Thanks, that looks like the same race, and I should have checked
> mm-unstable before writing rather than only the released trees. Sorry
> for the duplicate.
> 
> I would be glad to test it. The reproducer runs unprivileged and gives
> the KASAN report in 30 s to 5 min on a 6.12.112 KASAN build, 6 of 7
> five-minute boots, so a before and after on the same guest should be a
> reasonably clear signal, and I can leave it running longer than that if
> you want more confidence in the negative.
> 
> https://www.google.com/url?q=http://lore.kernel.org&source=gmail&ust=1792343148969000&sa=E
> is refusing my requests from this network, so I cannot
> pull the patch from the archive. Could you point me at a tree and
> branch to fetch it from, or send it inline? Either is fine. I will
> report back with the two runs.

Thanks.   Here it is:

From: Zi Yan <ziy@nvidia.com>
Subject: mm/rmap: don't discard lazyfree THPs at PMD level
Date: Mon, 12 Oct 2026 22:20:16 -0400

__discard_anon_folio_pmd_locked() clears a lazyfree THP's PMD before it
determines whether the folio can be discarded, and restores it if the
folio is dirty or has extra references.  It is done under only the PMD
lock and the anon_vma read lock inside try_to_unmap_one() and no mmap lock
is held.  The temporarily none PMD causes UAF.

A parallel munmap() or mremap() is supposed to serialize with it on the
PMD lock, but zap_pmd_range() (called by munmap()) and move_page_tables()
(called by mremap()) do not take the lock when they see the temporarily
none PMD and skip the PMD.  There is no more page table walk after the
none PMD is restored:

- munmap(): free_pgtables() waits in unlink_anon_vmas() for the anon_vma
  lock, then free_pmd_range() drops the restored PMD as bad without
  removing the rmap, so the folio keeps a stale mapcount.

- whole-VMA MREMAP_DONTUNMAP: dontunmap_complete() unlinks the source VMA
  from its anon_vma while the restored PMD still maps the folio.

- plain mremap(): the THP is not moved but unmapped, so the THP's data is
  lost.

In the first two cases, the folio stays mapped, but no VMA that maps it is
linked to its anon_vma.  When the anon_vma is freed, it is still reachable
when one rmap walks the folio.  Racing lazyfree reclaim against
MREMAP_DONTUNMAP as an unprivileged user reproduces a KASAN use-after-free
in folio_lock_anon_vma_read() as reported in the Closes link.

One solution is to use an invalidated PMD instead of a cleared one until
the discard is committed, but it needs arch fixes first.
1. GUP-fast still follows an invalidated PMD on riscv, LoongArch and s390.
2. sparc64 miscounts thp_pte_count when an invalidated PMD is set again or
   cleared.

To keep the fix simple for backport, stop discarding lazyfree THPs at PMD
level instead. try_to_unmap_one() splits the PMD and discards the folio at
PTE level.

unmap_huge_pmd_locked() and __discard_anon_folio_pmd_locked() are left in
place, unused, to minimize this fix for backport and the invalidated PMD
approach is planned as a follow-up series to use them again.

Link: https://lore.kernel.org/20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com
Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_folio_list()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kyle Zeng <kylebot@openai.com>
Closes: https://lore.kernel.org/r/20261009165214.40212-2-kylebot@openai.com
Reviewed-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Assisted-by: LLM
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/rmap.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/rmap.c~mm-rmap-dont-discard-lazyfree-thps-at-pmd-level
+++ a/mm/rmap.c
@@ -2275,17 +2275,6 @@ static bool try_to_unmap_one(struct foli
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_lazyfree(folio)) {
-				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
-					goto walk_done;
-				/*
-				 * unmap_huge_pmd_locked has either already marked
-				 * the folio as swap-backed or decided to retain it
-				 * due to GUP or speculative references.
-				 */
-				goto walk_abort;
-			}
-
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
 				 * We temporarily have to drop the PTL and
_


