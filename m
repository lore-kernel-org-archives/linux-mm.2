Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3ED5FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5E56B0098; Mon, 27 Apr 2026 11:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 256AA6B0099; Mon, 27 Apr 2026 11:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 145A06B009B; Mon, 27 Apr 2026 11:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F21E66B0098
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:43:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D02EBA21E1
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:48 +0000 (UTC)
X-FDA: 84704735976.11.35F7B0A
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id B2032C001B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ns5QLczp;
	spf=pass (imf10.hostedemail.com: domain of 3UILvaQgKCGkHYKI+NPaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3UILvaQgKCGkHYKI+NPaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmP6R09Q9nWqYYDZQR+Duu/8tNuRQcuIH0M5Nuu7R3A=;
	b=sZnnYiuRqOoWPeL/1RZEgihGYREs8/dglv+wr6X/g6RJG2aWnK/qunTs0aNbt+DDzHDaUJ
	426n9IW6styjChMdGZFLzmCYEM3b4SmmSNHXNiO/4qcETXDF7N36LxFcn+nAdPbCzGOep1
	JkHcUJGp0e7RprF5Uw8K5/ahaAEPOW4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ns5QLczp;
	spf=pass (imf10.hostedemail.com: domain of 3UILvaQgKCGkHYKI+NPaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3UILvaQgKCGkHYKI+NPaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304146; a=rsa-sha256;
	cv=none;
	b=YgA3X1Jdow2mixKDuQHyOyukDAJFY/4UyBONfwcT5BdapkzDLOegUIQePQ9BNGTruwn/lt
	xD8/W0AIYw5ucNeuzx8LwTxnE9ubT+kjGaEuVvDdmHvxFuHgTFKwrwmVDReL0DFs0kxikp
	IXc5DdCnLgiWn3nGS1yznNE8GBHClns=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488bd1ee9e7so91794735e9.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304145; x=1777908945; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pmP6R09Q9nWqYYDZQR+Duu/8tNuRQcuIH0M5Nuu7R3A=;
        b=Ns5QLczpfDJRpwEA2G2Ec/3BdKLF02u8R54G5Wy+uKvQ0V7lWfumX1fiE7dTTJaPmG
         PBSH3oyIdB8dw/CIcGxgCuxjB4dd64hL+oNGuqLNbEf4llMNrMSsxapZWdkbD+f7BWV1
         oF7PSsY+ADOBVl0h8OvWMkAcvWYTxW+LbEAHIdIbzl1vJXZt6JBnBn/304HbEOYPmN3d
         g6t6FnxVvemsQxnwNGjbLotUEhrVF7Z8KLu5ki/F3TGFjd4Y42MFb0FTvLJmdwHW7PBU
         KRAqpPcYj/sud5gItGabDmI72yyDhsqK1yUTFoJ+kHyKbPDbO/wZTIS6J89KjiZDlLAi
         hFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304145; x=1777908945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pmP6R09Q9nWqYYDZQR+Duu/8tNuRQcuIH0M5Nuu7R3A=;
        b=GEGyeXsKVSOBs6XmVwkhNRx5mUDQx4a/KZ6v0NadwGYwYMBVeP7AHJ51Bf4jbyqTlP
         j8Ap/Z4IX4yryGjG/+4txErlaODh2AVQpsY0fc2tYaenrJ59W1oB2IFa9EZLZbrFicCk
         SJSjkIfE9Mu1eR9PgtilZ3wrGF7Tkkp+XvGTc15NaGyDwPJnv1OcJETsMCgxqthMFsYS
         o0+DeG57zENy7HB819mg7BNzwJuw36oGEELyg16KVJw+EO4eal1SOb2uTVcOKcXMS/GW
         N1ex6OQx3w6c4aJtnZNfemoHChc1I34SMzrBzWGoaVbVOyGxinef8CLy/SSqiz8tACrU
         imSA==
X-Forwarded-Encrypted: i=1; AFNElJ9iNTifrIURLw64wI8V1F5U0omC9OxpH1xJeMj/aPrAj8hs+sXfHJvJq9KzXc7yuKpzuXn8nEZHZg==@kvack.org
X-Gm-Message-State: AOJu0YwNeSrWXnDgUCrJja6HIFjw3i9DQDjpoU3iL5DCSSplD1xAf61x
	RTbKELL9aM/zJ1176IkVpZ4gNZsUMe4TvqcQ1DDEzQgyZTJovT/3Oud9QbfGiQnWI8B9x4T+qw=
	=
X-Received: from wmqo21.prod.google.com ([2002:a05:600c:4fd5:b0:486:7a8:4f4e])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:190f:b0:48a:6315:da26
 with SMTP id 5b1f17b1804b1-48a6315da72mr216539215e9.26.1777304144872; Mon, 27
 Apr 2026 08:35:44 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:27 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1971; i=ardb@kernel.org;
 h=from:subject; bh=TaqiODuFtOBPeOY7+zirlhCAHHbOKzDzJrx2Uvu6+0U=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN9E4fzFC72tqPtWjWHA8yaWU1Y72S85i48K/X2HmNcy
 pIdrxM7SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwETSPjIybPkSXFT9mmXt+wyr
 Tw3/otuqXJ56eLXKyPRt3vTriPK1hYwM5w6/Xlfbco49iWf7XsYt/4uijGorz1hflb/6oC80o/Y yDwA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-27-ardb+git@google.com>
Subject: [PATCH v4 10/15] arm64: Move fixmap page tables to end of kernel image
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ntfxhpq6z44d74txfebpnd3h5jm6hqy1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B2032C001B
X-Rspam-User: 
X-HE-Tag: 1777304146-497559
X-HE-Meta: U2FsdGVkX1/TGjPRrcWINirSHzWJmDKicmByCPpwNefcP8jMKI40t1oBnsu2657CedhOn7PapUE0vEl/Cti1ePlVNmT1XX0xgeQvfRIhbBjqsvLVEQ6sxV2HDtJfxGaTYsDXwRrf4GG08S+uZGBDx6pjYhUvQkm6cld4kawwNQSwkSkDytFy22C3k8kVLZYYUWqYQTTLzyisz8vxzka1VzImjTXCfwV63WkE5hUFngy41h/Js5expdSgDebBZ9vv4vfUN9CU9gO9898Uugmg4BqsrPQaWerG/PZDERz6HUzCkkSr6lO7Xi3LQnO2qR5mAGyZoRYeReWwet3s15Lvix9kGCes/b/ZRkEB0gOArWGtp5AS15WH3ZDaW+0UyusypZSd8uZ0/6S/0Si4F5rrSrbN/6zmkLQ9HJjGCXoR5aCXJN+XV7rq0eE4JXV60Tc/t9vBjXNBccXjzYB98JYPhKVHT+GrtjSUrCZPXosjIo4+TAo7AQyd8X4AjjKP9Zj9IaYeN4TQVl90y88LgSUaU8uLuQBV6uGccHCUbNY9AzceunIM0BV9REXx3pbAtbtnwQj0qwwJLuO8O7OL0tdq+grWei7lTIIroGB8LswoYbOpkFjVuLahiszvAEjIKO/5jJxQl4ccpfL1zKdGKVeAimhQzp++HnWkNuAgTOsF8FCTeNOEHRzgv1HR04e1SVza4oseDMggl9/iA2LOaZ87312TUzyUaa4mLdKZGgsX4YcrL87orsil7TJvG++4ZHxvdj8/aDZyNq34fH0ZFsRjMRL0R+XYFJX5L8C0BsmYFmbjsJH50KAaxqh3mhY0G3Hf+wk3h7deL1cxALZY20q+SXuu1z1q+HDP8mqdVozgYE1LhSh1IBrLO8QP8+hGz44FMIS0BulXWBP4+cuKkEttviwQJvld1m5WFdt3bFmc6WJ1cK6qJyf6aoIAxwmK5ly5KsZzwh/jz9U5zdHgBqm
 SRQeHlTu
 6PdbhpPunUafAL4t1SVtGXzPtxIXwEXTBfgi2LLLF3JQEVn+Z+C+jXZkWSwojrADk93DZoByh0jr6WEmZ4sp9d8a9eJd68RJTjkHdCO+KgCga+HmCcdVZUHzZIH+xyEXEEeJx2Y4ldtgbm22GVDQ9jTXQEGnjuqZqPj4H6TtGHtQE+jhoR8QVUQ20jKpxlVhetjJ3amdmfU24iP4MtdT99FUvhSRAeAY3MScvQi4RnXqXdYvgRUUNaEPye5HNY5O42r7efoivrU/XrCH1us08kP4QiYxYG49W6LPSrBOrkciEIcaFDzTupRcrK1GW3avk3rODBSRv9Hch1Yjg7bSJbnFkQl7gD7OO4LSIgkOGn/zdO1ZvJHpBWehu9cfTrBh1KhGHSiXk8jRjo8x8fQf5TxPoiNPoAzOafNRS6Z0Rzhauy+uUMqN9b2yEKUQjRZwcwascjM1WaF/SlFOVQ1fwsoBHbVrwHhLEw7+w9C/9PFNlBgg/EpLI7jSTNybs87PZY0RbUvfqHUv0EwGnOA5SIgg6x2V0ADrybXmdy9Kp1QIQRB7FQSjqJFUxJAGJ4J6VpTBtj7OHfjFunT0XY6rqP1RHXpnPFlWgauFqsMXAoWA8RhtadsRm3tUAITGu43PB+EkqRuvIos6UUzfmeeBBJInsSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Move the fixmap page tables out of the BSS section, and place them at
the end of the image, right before the init_pg_dir section where some of
the other statically allocated page tables live.

These page tables are currently the only data objects in vmlinux that
are meant to be accessed via the kernel image's linear alias, and so
placing them together allows the remainder of the data/bss section to be
remapped read-only or unmapped entirely.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/kernel/vmlinux.lds.S | 5 +++++
 arch/arm64/mm/fixmap.c          | 7 ++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index e1ac876200a3..2dca18574619 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -353,6 +353,11 @@ SECTIONS
 	__pi___bss_start = __bss_start;
 
 	. = ALIGN(PAGE_SIZE);
+	.fixmap_pgdir : {
+		__fixmap_pgdir_start = .;
+		*(.fixmap_bss)
+	}
+
 	__pi_init_pg_dir = .;
 	. += INIT_DIR_SIZE;
 	__pi_init_pg_end = .;
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index c5c5425791da..b649ea1a46e4 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -31,9 +31,10 @@ static_assert(NR_BM_PMD_TABLES == 1);
 
 #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
 
-static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __page_aligned_bss;
-static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss __maybe_unused;
-static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss __maybe_unused;
+#define __fixmap_bss	__section(".fixmap_bss") __aligned(PAGE_SIZE)
+static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __fixmap_bss;
+static pmd_t bm_pmd[PTRS_PER_PMD] __fixmap_bss __maybe_unused;
+static pud_t bm_pud[PTRS_PER_PUD] __fixmap_bss __maybe_unused;
 
 static inline pte_t *fixmap_pte(unsigned long addr)
 {
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


