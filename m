Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71424C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 10:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 339B96B0092; Sun, 12 Jul 2026 06:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3112D6B0093; Sun, 12 Jul 2026 06:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8CE6B0095; Sun, 12 Jul 2026 06:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D11F86B0092
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 06:44:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D77F14087B
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:44:39 +0000 (UTC)
X-FDA: 84979791078.18.F57AD94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A987840004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:44:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Omw7G4Fg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783853077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrk8vC+Ve+FQgyHSJEFAxaMx0g8ZadKX9MusPiIExkE=;
	b=2pKCQFJef03qgHHuHCBSJel7CquRKs7Oj+kQPsz+8gMxg1x3cbhqCyeFoiQQRc/NMtM66r
	XLBnSWzHGSItWIYuEV5xISnZcUMkNplH1QvF3PQMCxxg0eEWsFolQKanRnIya3N5OkE7pY
	RiUullQYwJcQVWzMaTB2kDm7waTlJ30=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Omw7G4Fg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783853077;
	b=ji/Bc2ZEWQwN+rV4oScwvPk2+whhX6IVu5Ck7ZWEn1Cx0TZdjKxBAuuSNR8QhlBE8IewgJ
	S+4fiwbGiMFNYBmjV1BYZZ7x+TSSQygOLmb9JmvXFEP67DFViCoKVoteuq33pKYtGyn4Xc
	g/uLl75uhzDClDr4+iBT0asQ3mRihsk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47451600AA;
	Sun, 12 Jul 2026 10:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F781F00A3A;
	Sun, 12 Jul 2026 10:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783853077;
	bh=nrk8vC+Ve+FQgyHSJEFAxaMx0g8ZadKX9MusPiIExkE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Omw7G4FgNZYcZEmrx511ChY6T9zMUkEWv+kAbym3JjUrya1Ou8V/rBt5Kef5Y7zYC
	 53+LYE4FKKsaE+qXpZWHu9nunSk9FGUVcxUDkahaqAQEXZSPDVd98i7drMhzaHWP2a
	 RPkASOS+rmfEXYteYtuCZMoA83Jqwo2NEGTNo2xnKmIALLwHG+Jbrg1e/MHlOnR/JC
	 meTFrDK0xcA+0UC47jl+ixZ4bNZ3Uer2PUPO8gfA1enw0fTLJBnVbL+9aUNBKGqNei
	 ZLlkOFBJs7UCBRnreuH5WVcET8q4FiCYohUpl9FUxY6V6Ejbfr+rQqt6KgIcjYj1fH
	 rACwlkoNj+0Ig==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Sun, 12 Jul 2026 11:42:26 +0100
Subject: [PATCH mm-hotfixes v2 3/4] mm/ptdump: always stabilise against
 page table freeing using init_mm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260712-series-vmap-race-fix-v2-3-ad134cc3a12a@kernel.org>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
In-Reply-To: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3713; i=ljs@kernel.org;
 h=from:subject:message-id; bh=wPiaIn6Wg5e3GQRwvp54WRABlKxC65yqG85hBilGX1E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKC8z9MUr22dUnwgTM3Wrcan9b9lrw17t3yC79mtJow6
 feuMeBU7ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBE+LgYGfpan6zcqfjrdp5G
 fef1L7Mjl5o0GN48fZebk+PG7VNz9EUZGXayf+xZ9H+hSuQB0ZL2MPnuKyz3DYyPTH3w3i3KS++
 iPQsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: A987840004
X-Stat-Signature: ad58as7y45jg9wi6qd9d1si4rybdncne
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783853077-888309
X-HE-Meta: U2FsdGVkX1+cipPVmBkiAP+F8Kp6es/dd3aIJnffyEZVbSil1rvtLDJwvnm+/IFoFshWq6EaA7MOXBQoPfQ5yrBOKtG2ihOpWjCZfGlMR7fHMl4ed5uSZ1i26RGPHiXuTv6kBfCJmibojfnfzOuk14opb0IGk6AMTK0sNtOE/DnTeyeqJS8vgNu1GqpZqr1KPxFQ6anSUz13HUayfQVQJ5FV7P9/9Lr0fXSB164aTflyB3bThn9L2UHD50AlG5BXSyIbbq+kT82sO3kNx5Zh4F1xKAj/qdkbY5P7Cbn7wCmk/PykJ/oTPpLyT+AArvqJsWDMiKjMOd65Z7U6SsyDkCzJsvhR1rbjmKWI9tneZ4JEwDlIp6pdWd57e80U4ylpAIhdtit7IkdxyLRNOE27HkzavZCaoQnPgs4TYgdtUvhkJXXCX07DZy3ZlCcnxgG+HrNa6CeN0vZPZy4aq066pCKky1AbWlA9UpML2o7gyCWY3D1/wd3ldBBZ074cMZLgfTKuPcEchDGeSfZtvo1/hE0VJyPCY9dV9/bUrCzPyJNoPKIisPO2JvX3+iIxH57tI0l8us3B7ULnhw604PuzRuBWlbNs5MI397c2R2mrDHhQwiC+u3tULRfJKZXvjqvW2cP9ydjWpcPn6H6OU05SuTarD7DRp9b4gQzAPG0m9+SYRraVd63ZM12CGEWKLqGDeroW4jK0kqLmuEQ6fwXlyoNUBrgIcQ4/qPyoBc3+ZEdMT/uXEbF60L0ajUY9BM32AfuODN+hI5Ydoxo3cZpWxz6lGjfGidcLiObNnJTlXJv3XoqTYF50CsATjEYBLG/yG17FaVv7XTtzXY19/Q28m0I8AyojxmGLmNSJY9rCTEmOUtisxRh8oISk9cj4yc8zC0XVrwDQD9EXZiGNuQ62mudQLDz699qC4/JFt0ZigrSPdgtyWehNm55XP+smwsZZyFq5PvUosxTGGowbp1W
 F0jIeE+J
 Z9FBwyc1GmEWZ1jlV4QkXOzJmvqei7aTF+fHQUYGQRPtOL/HZXmhmVwCaqhzlUQO78s0mg6VeseRuHnry7HH/TCqkro1IJj0NSLMu6bAw11tyehdwixGrW+h1MX95s+N76BBQH/0YoUfG+7yE0FMSol6hLAQn1Eam+bK0nnuWd4UHY/vYkwMKBOtkYuzK2GZM4eaF1FRnsIPu2iNAf2kbNOikMwB/8lKJgZJoV52btz7STYv1u7DlALZXris4iJCe24sgnBjXKORMU6tTGru5efbChDhAbsNWsQSn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

x86 and arm64 invoke ptdump_walk_pgd() with non-init_mm mm whilst still
walking kernel page table ranges.

For x86 this is done in ptdump_curknl_show() and ptdump_efi_show(), the
first passing current->mm, and the second passing efi_mm (we reach kernel
mappings that init_mm protects for current->mm due to x86 cloning shared
kernel page tables for arbitrary mm's).

arm64 does so via ptdump_debugfs_register(), configured by efi_ptdump_info
for efi ranges against efi_mm.

The init_mm mmap lock is used to stabilise page table freeing against
ptdump, so take a nested lock on init_mm to ensure that we are correctly
stabilised.

We take this after mmap write locking the non-init_mm mm. Nothing acquires
the init_mm lock first before locking an arbitrary mm, so no deadlock is
possible.

The preceding patches in this series updated the two cases which can cause
races with ptdump in init_mm ranges - vmap and x86 CPA huge page promotion.

For arm64, commit fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump")
already provides exclusion against init_mm for the vmap case, which this
patch also pairs with.

The first point at which ptdump can race kernel page table freeing is
commit b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page
table"), so we target this in the Fixes tag.

Also update walk_page_range_debug() to assert that init_mm is write locked,
add a comment explaining why and remove some redundant code.

We do not need to check for walk.mm being non-NULL, as the mmap lock
asserts would NULL pointer deref if it was (and of course no callers do
this).

The rest of this code is exactly as it would be if invoking
walk_kernel_page_table_range(), only now it's far clearer that that's the
case.

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


