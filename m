Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B7DAC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2436B00C1; Tue, 14 Jul 2026 13:25:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362A26B00C3; Tue, 14 Jul 2026 13:25:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22A956B00C6; Tue, 14 Jul 2026 13:25:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D15636B00C1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:25:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 20AC81A0496
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:25:09 +0000 (UTC)
X-FDA: 84988057938.26.8460414
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 555C7140009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:25:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OJlvXF9S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784049907;
	b=KeAQ724ahSoyQH2HXSInkKfoViqbiJhR4V0jVLQR6pbcRNWvgai3k29coRVrW7wRY1SNMs
	Ycw4SjX8lkc7571/LB/t3kiPK/G+psMrS4vWu3U1F1HvtSTPk7sKGkAwxBtg/4/YugeyCM
	cWzPYHKMaXn1qyqsAWrPUgMVONfnijI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OJlvXF9S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784049907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7c4JIh+xXXzUf3RuGROVnJmdpEMXk82+j8IbVgKDa6Q=;
	b=NgI17kW+XsguBuvhcQu0CSqQI8ekOyuMvaW39kL+VQqBL4LjEpXhSnVKJSeKsShdLFjLC9
	XlHbQe4cX7m1nzuDCv+TyN1ZkcT/KTeBHEIrQ5UuRI+W5ki//iMfumF4ajJzDA13vxXSGf
	t+0tV9OG8FfV7SkHaOSFLwrBClCYX5E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E82AB601D9;
	Tue, 14 Jul 2026 17:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C221F000E9;
	Tue, 14 Jul 2026 17:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784049906;
	bh=7c4JIh+xXXzUf3RuGROVnJmdpEMXk82+j8IbVgKDa6Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OJlvXF9SDCYElXNumMqDXpyahca0HdWzyR4wK5diDEgqmbgJmZxbHSAmgZtsY66mJ
	 bxTgooysHMBrODx4u6eF8rwqriH74jqLi5TwDCa9BpCVWGUCoSreK/wp529S6l3A6W
	 JhsYCDV9C3rAa/ohqxc71Us0gLNQ8pn64J+rWkVgaiqooJHhXOaOJbJKLgxdEqY6t6
	 GnXC5B5wxHArdwF528qzs2ZmhWbkBl+6NoR29hMloLREUfslmoJi9qiPBpP78dWK9z
	 DQoD+2SamlgwqAqBjDfeB3EAsBSoyHc1Qh0CQKrfheXphhSAYkNR62Rh4avwgei7KB
	 MVtvAV6CyT3Uw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Tue, 14 Jul 2026 18:24:25 +0100
Subject: [PATCH mm-hotfixes v3 3/4] mm/ptdump: always stabilise against
 page table freeing using init_mm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-series-vmap-race-fix-v3-3-b812eccfa0f9@kernel.org>
References: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
In-Reply-To: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: David Carlier <devnexen@gmail.com>, ljs@kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3218; i=ljs@kernel.org;
 h=from:subject:message-id; bh=+da+wQab4iV0i+3djD3hSaZE5QbecH6NvEFAGihVKmE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLCCs5J7kqZej7tJJ/tEu1Z3zYd/lkiw+B3/oJ83J5XP
 brVjMFfO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRC7MY/pn16AjX77hp7Hdo
 +83gjqAb2f+WTop+GxJcrPMq0i7PeQEjw+FrCicDTl1s5Kz61Wepp/mPj/uT7MLn01UuO61Z+5/
 nADcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 555C7140009
X-Rspam-User: 
X-Stat-Signature: 73uncsnxpxt75ji9rpawmut5a51mgzi4
X-Rspamd-Server: rspam03
X-HE-Tag: 1784049907-744463
X-HE-Meta: U2FsdGVkX19ExGZKJyMVbHp+0M2eyp5NZen/6D7Kl6AYhA2NIf2F/+w4Vw2VAMkAJ1RrknoxEiUH5pwsYZgSEq7Yx/1WL5wy2+1W2Iw9BnCj8TMm6Nqc738OZ4O+jXwA8tceVHTnTBKBS+brJyINbWn117q6u1lI6Wjnvypaku1QU1pzlMrr1A/6VT0usKFjlxB0QHz5K0ZeFZ3G99UdTGJCSu4plgEM+s4AAFFr6w3EvUNM1GGUgQHvzpz4HCEQSYm99YTdu0aP5GkADUR1GmhzZHmuVwHssaiFIx9cyKoQEJA4ChVOBnujNGy5FfcPVH508XynYlzfaiqCbNaGxGmhZJGeoxeufGxxVrO3AOgz2X8u2CtkkrSa+OQj2wi472JEMelpjaz1NQvJAd7SSVOK0JpjxVTWPh4YYVcpLA8i1PBFtKG8P/3sW5sRcJJpmYj6kUVcdPrDH2dq21nIhQ3ClloH6ySxPD0hiJe0EN6f0Egccwl4h0uo20DyrHXY2jKfjxs9Ey/iGz0Pd2NmtQfn0EmmqHzSqHNYFqMetpRl1brUGJeAuB3fsktGJdeFbcH8YizkDUS1pfL7ZQHSSsyuLGGTtTcvprzfRRi30xtLLHUB4tciNsoLxIj8AXHPGLUd//4prLujTcbu5L0vXLyKcQeeMfJcm2+dhi11ZaWyPi8gtvCqeUkJa+ZehB50htXKsjih0RcB/MooLaZSuLlICGaw1dH3xPC/9xYp6+ME5d1slzByVXSB2y9px9Eg9hTVRPnMdb38v/gc850gsd2dERWEkFBtW+gRC3ol8kazRE2O2QI9xIixqOkpGk+Oa1Bg5nOtylagYEnu57nG969j9BvrE0IQwCn7zAJbyoZk2tSCkZdADa09DaOpPjZMp5U6xHWDieZXUrwYL0v9hRNWJfiyJUSsy/TBVdZzOpx9vz8vhlEBfLFYnEUZoY+bIYeu4OuicvkEymRS1La
 uIeIFKk0
 hNbrNfvoAuJYqR7C9SpjB3bbkXWois9TjukUWsF0qs1igorA/cyHCsr8/XX7Eaxeu1w2eLJ7HOjqbYtrqOV/c7UrHdSLturb5GkSc/hEUBPsSTNZN0bFL8UF9HAkO7HlJVgy5/4Un807+pdkmKwXQTz926vUd7KoV3JFVoMuKCTy+nwqN8sZvBWbnjh1D2iVC2Zq42qz8fj10Sx0NuYRjGKuFNv1hDIMnwRXKgr2LXLeznPXlulC5+RKeSYI4nn51mEqLPDTSeshKPFbcKp8Wd8KEd5MiZeImAIy/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previous commits have established the invariant that kernel page table
freeing is performed while an mmap read lock on init_mm is held, which
fixes races between ptdump and kernel page table freeing over init_mm.

However, x86 and arm64 can perform a ptdump over an mm other than init_mm
via ptdump_walk_pgd() and since kernel memory ranges are shared across
non-kernel mm's, this means that the race still exists for these cases.

Fix this by acquiring a nested mmap write lock for init_mm in
ptdump_walk_pgd().

This is safe as we take this after mmap write locking the mm, and nothing
acquires the init_mm lock first before locking an arbitrary mm, so no
deadlock is possible.

Also update walk_page_range_debug() to assert that init_mm is write locked,
add a comment explaining why and remove some redundant code, and eliminate
the unnecessary and confusing invocation of walk_kernel_page_table_range().

We can safely remove the non-NULL check for walk.mm, as the mmap lock
asserts would NULL pointer deref if it was (and of course no callers do
this).

The first point at which ptdump can race kernel page table freeing is
commit b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page
table"), so we target this in the Fixes tag.

Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/pagewalk.c | 14 +++++++++-----
 mm/ptdump.c   |  7 +++++++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index bbcfd68d0907..5d87c632a255 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -702,12 +702,16 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 	 * to account for page table freeing on vmap huge page mapping.
 	 */
 	mmap_assert_write_locked(mm);
+	/*
+	 * x86, arm64 ptdump allow walks of efi mm's and x86 ptdump allows walks
+	 * of arbitrary mm's.
+	 *
+	 * However, they both must also hold the init_mm lock to account for
+	 * concurrent kernel page table freeing.
+	 */
+	mmap_assert_write_locked(&init_mm);
 
-	/* For convenience, we allow traversal of kernel mappings. */
-	if (mm == &init_mm)
-		return walk_kernel_page_table_range(start, end, ops,
-						    pgd, private);
-	if (start >= end || !walk.mm)
+	if (start >= end)
 		return -EINVAL;
 	if (!check_ops_safe(ops))
 		return -EINVAL;
diff --git a/mm/ptdump.c b/mm/ptdump.c
index 973020000096..5851096e6f65 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -178,11 +178,18 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
 
 	get_online_mems();
 	mmap_write_lock(mm);
+	/* To stabilise kernel page tables we must hold the init_mm lock too. */
+	if (mm != &init_mm)
+		mmap_write_lock_nested(&init_mm, SINGLE_DEPTH_NESTING);
+
 	while (range->start != range->end) {
 		walk_page_range_debug(mm, range->start, range->end,
 				      &ptdump_ops, pgd, st);
 		range++;
 	}
+
+	if (mm != &init_mm)
+		mmap_write_unlock(&init_mm);
 	mmap_write_unlock(mm);
 	put_online_mems();
 

-- 
2.55.0


