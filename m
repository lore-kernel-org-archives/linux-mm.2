Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A994C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2186B00AE; Thu, 23 Jul 2026 11:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761FE6B00B0; Thu, 23 Jul 2026 11:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5186B00B1; Thu, 23 Jul 2026 11:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 389FA6B00AE
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:17:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD3ACC0524
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:17:34 +0000 (UTC)
X-FDA: 85020395628.14.54D1765
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id F1E811C0006
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:17:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=keE8qT7v;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784819853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4TmiXyJvQ92TKxUnkF2EBAbSx4BVAEx8E3qvkE5M06w=;
	b=i3Y5XTK5PgADrjIs4NNy0Ihi+MbOYuoMUlYBQgXyPESzq1ZDlCXBxoLhecPSkLZimXa51z
	o99qhVlRfDpxE9caTXmwn4kCbKYQxci0PTqXuP/I4/05nfiGiQ1K9nuHtnZVsDU1L3mDWG
	jqI1K69eWFngC6M52GGqm3AIz4cdXTc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=keE8qT7v;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784819853;
	b=JOo8Iq5Z3Lc9QlLR3mxBxAg6O7NL8lula2mFPwU0QFyScJAy4ZcYBSSLEF8lHIpYXAcT6S
	2xnz3Dtjy7T5aBfepO/IZlnKieoL0nQWBccusZmHDYfQAart78Vxk72FlwXRj0XKz7cFGQ
	ZfloiaNQQZ3ZBWMte4MPUz6KU0Unu00=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B3A260A91;
	Thu, 23 Jul 2026 15:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCFB1F000E9;
	Thu, 23 Jul 2026 15:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784819852;
	bh=4TmiXyJvQ92TKxUnkF2EBAbSx4BVAEx8E3qvkE5M06w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=keE8qT7vBTXkbMs26asTsL8pW67WGqXgwzV1Ac5f45Fk6q+/p0+JWXxKODKzKG2ED
	 DZgmEz0u7tnsHrqOJVLTUrY6Qc9if4n1X3ZkO2XIPXZyfpazO1aHpvfk4le7g7Kb9U
	 J3ZwgKTuEoAtiz+bAz/60D8uKMNeX+k1NhBe5UfZimuno6656dW8Qyjs7P+2lJh4qj
	 gPCAEud3BZEadvF4O9II4RK6a8GfKCB4CRik21ABhe2MO0v5DtfVsiKGx0Jpqc+zox
	 xUMBc7WDk1jje3vkntaNN9cecPbAVoijItvVKYQn0OQjnUDlxqTfyiUahPWon6/hGP
	 u9MfyDp+58GEQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 23 Jul 2026 16:16:34 +0100
Subject: [PATCH mm-hotfixes v6 4/5] mm/ptdump: always stabilise against
 page table freeing using init_mm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-series-vmap-race-fix-v6-4-8cc77dcc0018@kernel.org>
References: <20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org>
In-Reply-To: <20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org>
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
 "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3325; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VITXU838ytmI5wjkeVjJjzJ76fi6Ga2j8Ljay/OkRtw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKSDGJXXL3g06vGuumGcyFrSqK5zkz7B84HBAO1XojWL
 UqxWvS8o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABPx28/I8LtPcvGmhtd7xKYe
 yuPN0LVhOPaq5/kH15cfy7JcGZiLwhj+cHu+7FFcyTpljrjO661+H5q0Q74szbw//Uuwtii/t4c
 iCwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F1E811C0006
X-Stat-Signature: egoqkwqec938zsy94qdkyxumtg9og4fw
X-HE-Tag: 1784819852-369155
X-HE-Meta: U2FsdGVkX19/DyDErwE8g6o5ydRalfGSQu+J7Dk6DENPuk4JZ1lQFN2AXfXQBVpSUTVN/zr3YmokiLNMo8otF7CKDg0x63iZOewU7JUHw5CFzUheI/0oUwUMDzGHHk50VTyYvgtRffbVemXvprGi/RDEdINmyGSFOlU2P8rKoxCAxeZBTZUYMdiEFHeA30OxNXiemtcF0Ufh0LHBFtZLlXmi85jgHssnKQnrn+sJM6EsMD/th+uMC7k3X9YRjZWRyEaeal1OjTZqJbg8s2mgp/LgMm9yt2BBOj5KF6IkuQEKt4xgYyLQRtUKpfqoM0ZlsWCS06mUO8uDJIG6QuuRQtq34pLxzVrOTCDVCY7+YTyo80vw9hd9VJwlI+7M9s/1d8dO7k1SGm/ULcJEaB3FtO/VCAXEZQfydGDqh9r8dL3sCt5cO0y6twsls7AShoSvf4a1oehmxUs93hIqlmkTmEOspz2frpKjJ/z7oT8iFF3wWIwP52LCbWIeu4rK180eBlLvlEwojDlAEkZ1oXc5S4+7aCCxQxoAXGOBrQAZjglI6RoxbM4bJcA5VOIAqLCJMDV45CeIRUTqWaMZwOuNGTLWnmraJbjG3tpOcEqndC5Lv0kebShn5XNzoLaD2KU40qvxFRYqR7F5IcgK+Dc/HfZs/rCdMTx6G3BRR81PF7i1RFsNUPxf6xW+62qsEFlPVDcnp50Vp++M0fexYY1rFhs4LCz2icKlGWQV5YJTe42IjXIOVpEzpl/Rn2BZdUiZAd1bQMCRwBqqs+k7TWTEHf/2WYStgVYzn+hzB5XKRh5y5S59j1xsXHBXKA4M8KnwJK3/6WieKL8XdccufpRnuqyaZ2QrAY70OsYklOofby66Ey7GihG2Paa2GUCSCmyPUOn0h9fwFK67TGlnFStSS301PC+yYHyWKKl1wpBtwEs6jQtSVt/XUSaeIvctQfiMW+Iq91hXMI8JOiideWh
 PnzjICxq
 38a+iZ2FQ6mrBgPB1Z7qOrT50M/9ehKEZxzj6TTo7cAdIj65eV8xT7CgOTWY/7fWgbMdRg97bt+/QXt3RehWmcYjEiN2L8T7DeVKBtpUGrvFVCNwVxHrqnUqPW3z2pVK+6u4Zi789vNdVMf1N97p5CEZ+567WPIfEnF4CdHty7zo+93QEiAfXPnl8TOz9OkTqonkAjmuEaQ1a4Tm2AddFFN0oR3YW9bBwu+TfFctK4ay9ydiGDLU8se68CZ43zJw8Rh5UAwqN5N6lFTzsfD/1K13oe7Jga+Qgngoz
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


