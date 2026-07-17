Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14E97C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F22776B00D9; Fri, 17 Jul 2026 13:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF83F6B00DA; Fri, 17 Jul 2026 13:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35E56B00DB; Fri, 17 Jul 2026 13:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB5D56B00D9
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:31:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49CFB16019D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:31:19 +0000 (UTC)
X-FDA: 84998959878.21.9C27326
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 74AAC1C000E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:31:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j7PegHdq;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309477;
	b=T7JZ8//2F97KPYjUYvi/lXSsn0Yi4o2GieB3qZNxfAYFmnXx7GtF4AJ1wjBC13TL/N+wKb
	nw94st/QqpX6sn+VtjvVTWff6zF4mQkO/gTYMT+aqaZkCbGxKTYLMWFFxv8ZrwxONMjnHM
	EgzKjOiih7N0J5Dvykybk9pT84KvEac=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j7PegHdq;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4TmiXyJvQ92TKxUnkF2EBAbSx4BVAEx8E3qvkE5M06w=;
	b=f72K1etEqG6WuO37cMgyrE5WZh6Gtj4w31F1+aJob3djAwsAp+s8H5uopmGtHuYCSsWAj4
	mddfp0ecI2eVXKSbbJTrl18/B91Kew241T8Val4zBYZO3uab0x3E2RJnoIYk1ikH5QTB8/
	gUNhPOzk6iSgturXOSTmCc1wDsfn350=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7D16414C3;
	Fri, 17 Jul 2026 17:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E8F1F000E9;
	Fri, 17 Jul 2026 17:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309476;
	bh=4TmiXyJvQ92TKxUnkF2EBAbSx4BVAEx8E3qvkE5M06w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=j7PegHdq1OFesFoUaayKABXnDJpVNSvSPDwYaiVx8/2g+pwbNCJ3ZfJja6eAtQZ8p
	 cIyc+DGp8cE1mY5T3MVxHeoEgCBsIQO/nHC6nOlsBe2FoOyLceFjBJ0vPPfhsUb9SM
	 5m/5O+dZndx9pKSDw52Ga8CFym1IitqeHcVgrB3OBwnEfcA6QcwjBgRM++V4FQwvYi
	 aOZwa7704A9u7bk3CoW7eomhkOF0zM5mBg5cz6qywFa0Ar92EAzklWTyarUQg4dv7m
	 BSQW/EW4hzjEqX2YoDLXo5uYFzkwDvt0LRfUvjOsP2TYV3cvXr7QKgDnltalcad/JW
	 +Q9P+xVsQPKwA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 18:30:10 +0100
Subject: [PATCH mm-hotfixes v5 4/5] mm/ptdump: always stabilise against
 page table freeing using init_mm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-series-vmap-race-fix-v5-4-606a0ac6d3e5@kernel.org>
References: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
In-Reply-To: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
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
 linux-arm-kernel@lists.infradead.org, "Denis V. Lunev" <den@virtuozzo.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3325; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VITXU838ytmI5wjkeVjJjzJ76fi6Ga2j8Ljay/OkRtw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKi0rZ/XWP6/n/eThWz4m8aOyLm1Qpq9ujrr9sb/v3mt
 bR522oudJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAih+MYfjHL3hNP3Nvg+Jtp
 1eU2vcCDZsmnLsjIzVir+DA4257NqJnhf4l0GpOQ+mypRYdmc1x2ZFwq37jKX7A5avOxL9Nz3lU
 KMQAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 74AAC1C000E
X-Stat-Signature: odaodhgkpqpwbgmo6fiq89pi7r9hj7ik
X-HE-Tag: 1784309477-323921
X-HE-Meta: U2FsdGVkX1+J3a2Yk9YAxpJxdLbP95w5/i/60keFBckbQh83JKXnsENYueB75xJ5Q77crqAaV3rdJPrfXQrcFYdzzMJGneSAIeVgqJRylx3sVxr8tyLzgYnJalx+ficrG5h+mvmavRATUMexnE/3hCFm+quat4zygbzVlBB7DaidQLZ87dwEtKEYHXoJm7/PardmTqPuh7X2T9sSsi07ni2PnOz7RprO/4KqU7KH7BgLX/oxrT4sVbfjSVm62/XsZutMOh9l/NXMUuPE32rXNC9vUYN9g4EYQhfxtI3+APfWyiaxS9wRWaUS7+7ZD0ARSOv9fcA/vV+HV8xsJ8mRxYEGzqMMlsO5fFiSAzekt6m1NsO+uTYfGIGsHLfhWY5D4LMnbrxnpcSDo+zNalhG6cpkS8ZHct3GPnaBMxoLOP+v7WrYwDRCjhVYW8l1mRiH/PaxHDBO6fXtaatRHfyN+1iRfMp/Nhmv2fuOHASvgwsc5saBl/f6dOGlsFH43BANelbJ1izPhCDbl/Y0LPPx00Pk5+Gs09jEi9MFsTxnpM5FB/SdElUovl00wB/pvO5JGEIp1inuJFfHIBYu/BHoS5DClFYb9onOZhQDeGVGOuPCd08pNeFBnoUMxmhe//d8J3XWAp8/Oh73CfiPoMiYkJ28TlG2fZvnNBLUGRppP4GLiNqvlOipzlmTUW22DY2t8MR39KH77GQiiXg07QmIsy2YAYjEk21V9R9fLqNwhK7WEK9XfyHr98F2UZPptoK4mGSxIi0pJLQRQneWL6rpQnPYEFfh6PqeDM5cu7HcQ5atUWhtS0fOQHGPRx9IrknDogbeAYEKVkxJju3rJ7YjCcn05M4QhZnc+7r4UCLkIoFU2EGzx5Mu+d8K4ZOGbyXW2mn/67sKYCUFrQGS1ebE7B/Bo9K3+3uNFJ9RntJVntx3ZmRkEHZjNBgSD1KqqVUh9ri9J5BCArI/n3s9pz7
 4rRQ7lyP
 kGcX/D0sE0f0aiUEywJoKfbIcWyOlL/Yy+Mo+kdBRxzatPdAozk0obVuqYgjCI+DpwVzLyLv0XtCi4K2LKFgeU0C5OBnICl5WTCEDH6lRDe0FGl6Qby+S4t6Vp/sFNfpSaQ/wBo9+sFnLAS8y70aqcoMCxJA9M9LYoHBpZnn6bKhO9zM41uwrfSEsltu2MBENzZ2Lawrm7k6WTcialeRuyBAQ5NCE2dPdfKLK8kR+/VY/itk18I6QsebKn7zkTmNVK7UPp9ytYFcOcn9P22WeubkHXU/SwulIl/YydNr2eElxSvQ=
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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


