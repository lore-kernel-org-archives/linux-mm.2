Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38286C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E12A6B00AC; Fri, 28 Aug 2026 14:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B116B00AD; Fri, 28 Aug 2026 14:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332AD6B00AE; Fri, 28 Aug 2026 14:38:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A52A6B00AC
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:38:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 920BF1A0529
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:38:20 +0000 (UTC)
X-FDA: 85151538360.16.3B47031
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id C70C41C0003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:38:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FO4NSRub;
	spf=pass (imf18.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3nAcDLCkfTKlmodmQ0boAx10KLIo6Vy0ud2mfcvPW0=;
	b=vUpuiX/XmPY4wN8sOOC2o2OoTeEkBPThaq1TA3lt0isIh8CVb2VtOPun0apsKtwlSKSVjs
	8mi393Zqo0zLFpsFA4xcow0RthXtXXd2SuPnO/7ULyRIU+0O9+FC4oTfZtbmJq/1orFcQU
	XVVcaBr4jBz4upGwzRCqBaZF1r1aEI8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FO4NSRub;
	spf=pass (imf18.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942298;
	b=69sGLXmq4EzAir4ZDfdGTY5Ggu6VpXJcBry8t/FWRAVEG/ZfDz+XAHPwXsBTeMkXyfsPsl
	h6vwZ4iAYRSQanRzJKLhaamAhbRbRQvrneC7PIPG3nmLb+PtfcQQZl19FrqUUgH1umrje0
	4kBafcRXdWb3cU65ho3Wjw5dRNqJLls=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-853f8c34ba4so1832332b3a.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787942298; x=1788547098; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v3nAcDLCkfTKlmodmQ0boAx10KLIo6Vy0ud2mfcvPW0=;
        b=FO4NSRubSMZq35u+VoT5xAEoF072LiBeGHf04fT36sihWfXgj69E4guV16uKTJ9pfs
         ///8G9HsqhqxOIGRtXpifn6ZtCQ4Lcg8wR0metokpMVK4XgAFePdoeL1vH1OA73cnrck
         /4/at0Xe8+Av9vcmI2yo6ij/zXHCFT2RXSRZKk7VR/vFwfCJj5yZZ0/WK0ylPPEzzZD2
         Nve0EmeOjDkua90EPg3ZdgyFK02n1+b7l695pFGvDaxOJfid2iZ4qp9AOqlM+M7l+Her
         FYrCDfuyg2c/JyAfbsc1HTVPsO2s6/v0Rmta5Pl8G88Gmw62Tdl1l6L6tJ9TdD/lEybQ
         QsEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787942298; x=1788547098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v3nAcDLCkfTKlmodmQ0boAx10KLIo6Vy0ud2mfcvPW0=;
        b=da3hDi0simAxukaq2Z+RJEvPHirF6TVkFk5mvVrzd/LN6jTl6U1jeOitRFI5FeoEo6
         BpfOBzvKsw0PBXLw1j61nP/DM6VZgV+aeoVH7iG3y4Cb46PSeAsxUmXJ+O5HRm7maafR
         wWn/ACbL1gCgs/8jzvgxyl6z5+bhnqH9BchDh933KkH11TLfuKrLJ8p32hkj4f0Eu2U3
         zjSTrl8ncP65w9IvBoaVeYL3tnPfLdCdOGFzufgmjWzSqHRuN93wKvyVTyXdCHisM2Tf
         hQZ7uiNvkiDZVY0ouw20SmlaIxBc+CVLBSfw3lbgIyX1ZbR/Zk2uqnYvmyxkPbCqBqcb
         3+Vg==
X-Forwarded-Encrypted: i=1; AHgh+RqAwhYn4fGVufK0oci93Z1mFx6aUd900w+QnZTGaCzvIfHXe9rYLhJbhpR6B9EwmQq1nRviIPi5ow==@kvack.org
X-Gm-Message-State: AFuF++lMJa0jkDkcxZ+KzXr73ZXneAmaPpqUWKW1ZYQ09efFq8dVIa5R
	rTBhDZeSPU7zN2xs/1IotSX8HBMcyfkGl7jbEiEeTC+Zx1PTXZ3zDigf
X-Gm-Gg: AR+sD10c/8T7KMC6dL9wCWjJ6XBwRTvP4v9ApLYi1HHBGC0kZQtkvS9NiaWoabAsPSc
	MBP3xZJRucyFnxJ6CmcIIw4rzxX9uCL7jLWs2sp4Agldwvxi+d4+j/67MW7O8JB9m3C3JF9WyHZ
	qwEOxOtRjS/2AQbaC3J4ZwlhNwq2nKRPvoviyqkq8XBhm4Qld+CLKNrP0notz1lrOlDOXqB9pKl
	fKoavmUOAp4jgQOCHRKzWKbgH2BeuSU+kgmiaUWEjwWMxNZ0GfTuQxcSkV4Gx2YQ/ESCw/G1Pkx
	pJJn9SZcMYXjg6mLtme79g8QZJXp1aJnIgSRkXpZcPXQZHXAO3a9L2ICt3/Gh1rUzq93Th9b21a
	F7oVLGAtveqZUC3LYP4LWYU78IM2/jV4YP8MVSyogOsX/156+LA55qsGNO0CKullZyrQHkZjs9s
	2jKnzO7xLeYe9aZ0g/YGe48cuGdJF4LfKPdSeBuA/Tdp9fp9ijxRzE4g0OLR36PXaKVcBfHBjCZ
	qjR4dc8GZ5sd5fsVA==
X-Received: by 2002:aa7:88c1:0:b0:857:726d:2708 with SMTP id d2e1a72fcca58-857726d2e5amr2500397b3a.20.1787942297709;
        Fri, 28 Aug 2026 11:38:17 -0700 (PDT)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a2ea6fa3sm844230b3a.37.2026.08.28.11.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 11:38:17 -0700 (PDT)
From: Yin Tirui <yintirui@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	linux-kernel@vger.kernel.org,
	Yin Tirui <yintirui@gmail.com>
Subject: [PATCH RFC 9/9] mm/huge_memory: unify the migration and device private PTE loops
Date: Sat, 29 Aug 2026 02:33:19 +0800
Message-Id: <23d7c10efec57be848fd158f786473aa3b2f6e5c.1787941780.git.yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1787941780.git.yintirui@gmail.com>
References: <cover.1787941780.git.yintirui@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1tpqshmjte3gyczmhxrimywjnbd69h41
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C70C41C0003
X-Rspam-User: 
X-HE-Tag: 1787942298-914752
X-HE-Meta: U2FsdGVkX18aPtgtApia+D0PVuMWFTAwyFAfaeUcmRHgjirOpN4+FIe88Ld6drC6XWsvazRkTJ3nGZPugkYW4dUY6DXHUwuCKgbxcZ3qvH5rU9hsEcYpHmiCK4EF4vK3xht0OulD4RKa4hT2IehA67wuyxHREYydV2fCAwOVVeaMS8lLo3yV3bBp4FadCOkSwXdaQArnBhKHapnwG/ARH+dyuwL111fj34P9zPCR0EkMnJUj86rtHkZNetnS5pY1H+k/YoLMczU3Y2AqX2tRTnkP8XSnqBtbcSAbYG9ABbUZjXIDAcECRVwhbpkeoIDUFMbiIhjYvDpRAz0h4RFYHJh7q7c12kqB56pSC9xdbpTpgv51T0A31BAPh2Mz3gXtFPqZKf1BhpWF6qGoH4GhqqBVQ1CqWwyUPTsDSrOWpgvkMVDVOzuMMRNySoa5p4aftzSXQMMObWmDeDwTEShewQloSIGiqUWl6gy26tFpiYq7UZj9w9KZi101yK2BjQdUJ8oy+ZM1O1wnTRRBn5wa0prG1sIXVHzwVDQI7RInvQc5atEcZJN8sKzv5dNcmJ1wYVLCKn3HzufEZYp4cGam2OQzqzxehP3GwsuFnbDZx9QXZyhoKRuQFqwm0fk9FPJDJFH9coWz0S8LlHtGfaxgUr1ib6Ff68KngZg6tM2ljqWbVHngRl8Fj7m3YZ1aKkHanqIOISItfSsqk05D3v+XP/346mLrAHKd33rwdpOAoJvabW7nK+wCZFE1Gfj2PT4//ft8PI8YQTE3n2tKUaT2GK9dTeflGm9FWIp7fCjsNLxVWy3r5WuyaaD3bZmzv7ckaKPNf6+xMaPULvijb1fpOuCqNrfiWmgb2vA3OvW81piGdKNqrQfDGE5oBf8WRyoKxdGZfRhTeMjZ/kVJ+w6D3DAB0YV9g13s+euhnYtGLJ2a3ZJ/DNCPcnYhei/q4AOQjxGrm/SO1LYiFcB/axG
 zsPfmpGF
 c4ezh4Z/x3y5EOlMMxX7DVqcH8RdKqs3VBH6q9JcU4dG7cCgL6FhMpKgzTwGmwYcM/5TsY0y4pgjs4fvN+pVtspDE4CKxP0ma8kkVl29qgy9YO4YLhl+4exPt6LWGyEoGSXauE1sXDteQeJZN2jjo7lZr1XjMygRBAb6r9+eI5nyiqPOah4TH55b/NzLqP1Sk1dyueqQ9RTBmLJQ0+3K2MAzKbplPC+ugFMsYT4j5Gmw08cXUjHt01opQbs58KRKk14VhA6zvYnIZvynmQMuGfOw1tDoNTX10qFD7/rhAuzme8HdD45nlxexFDvayluG847Bun5iStsX0gGgeJdUaHOv04Yny55swRbKOvzI99ZVwjiFp7klbdedXEXDQNRfGEcW2HC7ImjRPxWsUwfhuJBKJ6V54D281A329kNkfBDuLVq886hsJ5klY/NDIyUUg4azQ8DTBdU8lC4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When splitting a huge PMD into non-present PTEs, one loop installs
migration entries while the other installs device private entries. They
differ only in the leaf entry they build. Build the entry in
split_pmd_make_softleaf() and use one loop.

Freezing still installs migration entries even for a device private
mapping, as before.

No functional change intended.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 89 +++++++++++++++++++++++-------------------------
 1 file changed, 43 insertions(+), 46 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fdb751a1e525..8e0fd11da3d7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3245,6 +3245,42 @@ static bool split_huge_pmd_anon_rmap(const struct split_pmd_state *state,
 	return false;
 }
 
+/*
+ * Build the leaf entry for the PTE entry describing @pfn, for a huge PMD entry
+ * which is not restored as a present mapping.
+ */
+static softleaf_t split_pmd_make_softleaf(const struct split_pmd_state *state,
+					  unsigned long pfn)
+{
+	softleaf_t entry;
+
+	if (state->is_device_private && !state->freeze) {
+		/*
+		 * anon_exclusive was already propagated to the pages backing
+		 * the PTE entries by split_huge_pmd_anon_rmap(), and accessed
+		 * and dirty bits are not propagated via device private
+		 * entries.
+		 */
+		if (state->write)
+			return make_writable_device_private_entry(pfn);
+		return make_readable_device_private_entry(pfn);
+	}
+
+	if (state->write)
+		entry = make_writable_migration_entry(pfn);
+	else if (state->anon_exclusive)
+		entry = make_readable_exclusive_migration_entry(pfn);
+	else
+		entry = make_readable_migration_entry(pfn);
+
+	if (state->young)
+		entry = make_migration_entry_young(entry);
+	if (state->dirty)
+		entry = make_migration_entry_dirty(entry);
+
+	return entry;
+}
+
 /*
  * Replace an anonymous huge PMD entry with a page table mapping the same
  * folio at PTE granularity.
@@ -3281,53 +3317,14 @@ static void split_huge_pmd_to_ptes(struct vm_area_struct *vma,
 	 * Note that NUMA hinting access restrictions are not transferred to
 	 * avoid any possibility of altering permissions across VMAs.
 	 */
-	if (state->freeze ||
-	    (!state->is_present && !state->is_device_private)) {
-		pte_t entry;
-		swp_entry_t swp_entry;
-
-		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
-			if (state->write)
-				swp_entry = make_writable_migration_entry(
-							page_to_pfn(page + i));
-			else if (state->anon_exclusive)
-				swp_entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page + i));
-			else
-				swp_entry = make_readable_migration_entry(
-							page_to_pfn(page + i));
-			if (state->young)
-				swp_entry = make_migration_entry_young(swp_entry);
-			if (state->dirty)
-				swp_entry = make_migration_entry_dirty(swp_entry);
-			entry = swp_entry_to_pte(swp_entry);
-			if (state->soft_dirty)
-				entry = pte_swp_mksoft_dirty(entry);
-			if (state->uffd)
-				entry = pte_swp_mkuffd(entry);
-			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
-			set_pte_at(mm, addr, pte + i, entry);
-		}
-	} else if (state->is_device_private) {
-		pte_t entry;
-		swp_entry_t swp_entry;
+	if (state->freeze || !state->is_present) {
+		for (i = 0, addr = haddr; i < HPAGE_PMD_NR;
+		     i++, addr += PAGE_SIZE) {
+			const unsigned long pfn = page_to_pfn(page + i);
+			const softleaf_t leaf =
+				split_pmd_make_softleaf(state, pfn);
+			pte_t entry = softleaf_to_pte(leaf);
 
-		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
-			/*
-			 * anon_exclusive was already propagated to the relevant
-			 * pages corresponding to the pte entries when freeze
-			 * is false.
-			 */
-			if (state->write)
-				swp_entry = make_writable_device_private_entry(
-							page_to_pfn(page + i));
-			else
-				swp_entry = make_readable_device_private_entry(
-							page_to_pfn(page + i));
-			/*
-			 * Young and dirty bits are not progated via swp_entry
-			 */
-			entry = swp_entry_to_pte(swp_entry);
 			if (state->soft_dirty)
 				entry = pte_swp_mksoft_dirty(entry);
 			if (state->uffd)
-- 
2.34.1


