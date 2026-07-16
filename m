Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12B50C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 21:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B65E6B00B0; Thu, 16 Jul 2026 17:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065FF6B00B3; Thu, 16 Jul 2026 17:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBEA06B00B4; Thu, 16 Jul 2026 17:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE73C6B00B0
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:32:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A85412031D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:32:03 +0000 (UTC)
X-FDA: 84995937726.28.D65A7E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7C865C0002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:32:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GYgZQmvm;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784237521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4TmiXyJvQ92TKxUnkF2EBAbSx4BVAEx8E3qvkE5M06w=;
	b=nqa+fOrizgSqMZLoy84ShFA52p6lS+EueIULhLNecrFI4ckPrTgr5J3fHXwvG9v+a+BRUg
	sCUQ9BM30J/HnkArt6C6fen8ZE9+cakd0yX5Fgfu+7aH9MAyE9GZJ3NJ/DeicqnaQ2JxpY
	ztzIiy+dT2pYMJFBJiW3YvsUUc+e2LI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GYgZQmvm;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784237521;
	b=EBt9eTka1bxwLAZ0Msnp3NVohSnS97Q7Ee7JN6Frx1yi6W4HlNTUWHhT4gqbyStei8jtFt
	E5L03ep64ezKDcUPnxuO1mTHzIXOWqPJSyJqWoRJxxG1vFy85KWt8/bCoyjNK4rK6bg5kD
	Cf1NXbmb9BBHkiriGwsDWAIKHzUltUg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C888342D81;
	Thu, 16 Jul 2026 21:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECAE1F00A3A;
	Thu, 16 Jul 2026 21:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784237520;
	bh=4TmiXyJvQ92TKxUnkF2EBAbSx4BVAEx8E3qvkE5M06w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GYgZQmvmtJSCVwlxmpjDgZpiPmaoPOUEQojBo7h8SSWNVzSGj11N/GUGKOHB/4X7E
	 xjyPpfeJfxld/9aBWN4fwcoHpUX+rynA8+i1bnLjwmsTf1Dn3tQf0ldvNMYAOJ3T+g
	 ZYr19KOkbGbG3bwcoR43r0vZOR9u/ENab3upSYP1tLsLhaU5z9woe4i3Vv9e1ZRora
	 iZW4tyHUfHzthiX+ve4ZGiM+50GiUG9l/3ow+618/ct2YyCbuNXjqRtNyjwymX+5oS
	 /kTxJlA8i/wPaUpCmiRfbpO4XiuFMRJncNBkmpIftb1iLfatGaI/pp2BbHa+qq1gny
	 p6Jb+93YStcmQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 16 Jul 2026 22:31:14 +0100
Subject: [PATCH mm-hotfixes v4 3/4] mm/ptdump: always stabilise against
 page table freeing using init_mm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-series-vmap-race-fix-v4-3-8c108c4317df@kernel.org>
References: <20260716-series-vmap-race-fix-v4-0-8c108c4317df@kernel.org>
In-Reply-To: <20260716-series-vmap-race-fix-v4-0-8c108c4317df@kernel.org>
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
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIifdeK1H72/9qooXMh7OxZvidbk/uXLSj4tneKLMPTC
 Ya+NpmbOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARTkFGhjPp5b9fLnBdf+/V
 qrsRtnMETV8qZqkLlsdxxuhvz93xRISR4YmPyWsx52chzOyJO2bXi16zvJtqLaHdqDpniUxxyfd
 4bgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C865C0002
X-Stat-Signature: 84iowu4ywakc4m7mrxd5hxh6u9fniuyj
X-HE-Tag: 1784237521-391760
X-HE-Meta: U2FsdGVkX18KwGXVOGxOYkfFc1mtDYm9M7glHYcl6FkSmA37z86IoEAdcjL4eBLJQSYigkPmcB+O9JpDp2LybptLRYoo18wXXVFBeuCCuQDWIyL85a+w4WDhlbvapuHzww3l9Vukstv/QUHaozij4YJS9bo50r9G6LKqJlSaqP5nJ4LlAyGQ1dRdS/b0bvDfrIOmJnWR58fJjDdDO+k2K9WI73soxcHKUxGv+8NIdM5VliXJ+xZPizliKFLD8n8robY5QId/ZE6XKMGNVBKivsYso4A0/yV+Vhu2Z4+a0xC3VJ+ctbKotCFpmasFJsMTKCkIfpOO7o6n4YziGPVHl6x62dVd1DRSj1MQBaxT9sNmMGTnsJYSiOevynmxUkPtEG51kWmak1MXJYgmC0VUwHxkr3D6rvmlDy9rAApIjnsRjl7UwpRbuUGO4ak596sIh48lvoND4LNRzUGva8aHjsz4tRRMFeew8iCWucXlr7QlhgR9asTdC3dSzfgBrHKm1JHjoKxzw8b2DvhTxoKkwwnOuroUbcwoe+vNEKFgu+/3JnPfpfMqn93shPmu9tu6NQDAsy20wNCA/JGfsFq7mlwL8khIWFnoE/bCvqq0dRI8MZ0ZqbWuUZEfO/pUjdb9mShTArfFrOSzG6n5ona8hdYaQZSdh7cFmya0IMHZ0HWIroslH9QtYr/pjLJnV1JDTczCYkRrI7AygLgC03UuH0gopuIGwKHyinTwi6nHtfSHDI1IPLfjdXkDIoDbB7yOqF1QBjs19oeBc2kW2+kagRvAqLG4t3D3BXJ1QxJQ3tmkdBk2IYiNQu53+trvWGQuqnKe3WPaPVWkjeD+8WobfTIyzPVCyAI1aiAZ5aW0E9brEAMz9NRfkzUgq4UnWgy57FJ2OyviNa0OdEivPuzacEcKXuswer8m97r0YWL1QyUrlittS6y+2+fD/F7R6H/8CpF6wqx15bxLlYJAjGx
 WDL5RiLc
 vS0d5zY362S8O7asTvphtT5ZAmySVFqiGTjrNb/lS2I/EcQShC0gGIAwz0kIoMjS0oXah5eNaF9MZTPjGXDpBB7qSH1NK6UVF43sbv/9kqLrGLgM9CqYqpPdXimZ+uAicKoLDk8no0L6MlwY4PaoyygVCEnVmB8IrH4Zit0vV/KaFiZVuvPa0kxlrkGfJMTqZJgI2CRiZD4XeeA95SQlY3/A87a0kTcN3LXbJ5gZ15IiCbaA2vYeev6v4bxLFd/RH/qrQT+WDSGdSde2zB5N/VTtYwNrT0IhvIjjhZKx6t9quGg8=
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


