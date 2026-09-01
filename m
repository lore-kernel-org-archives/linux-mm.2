Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9FA8C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619036B0092; Tue,  1 Sep 2026 02:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CA676B0096; Tue,  1 Sep 2026 02:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8826B009F; Tue,  1 Sep 2026 02:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2780D6B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:55:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A45131A02C3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:55:09 +0000 (UTC)
X-FDA: 85164281538.09.22BBA1D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id D0B1440003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:55:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DA90OAk6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788245708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8DKxHX0ZMrbGN0igWT+gZcjJs4LnZ44sJG8G/14viw=;
	b=7WyV072apnULmxj0Qss2j8Xmd4rI3qGsp7oiESb4FQ+zoF6BSTxSNSAOg5SsJbbMCB3g0p
	LvhXhuwTslkjb2d6QVyj1pfe7pIC0iyXVQW5wXtIzVHTHxWKcKCw73mRNgVKBLMdZ7yvLG
	t8yPFgD2he9n0wWIyR8dNU3ioNyI9Z8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DA90OAk6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788245708;
	b=K7GielfEZxAkTg3qb43Om9WPw65NH/cVFokgm+PXuBBJ3heRxNkElYxkjg94cssnzQAf+5
	cpe55NBnxFoGKgAAzWyiApKlaeX8WkEAWlX0nPayD+GM3jZ51bBCQtkhji6EV+gR1VeDIG
	6dT64tw37tOqrVku1JfA31U9pBaREA0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59E721AED;
	Mon, 31 Aug 2026 23:55:03 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F83C3F85F;
	Mon, 31 Aug 2026 23:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788245707; bh=2hzv/NqRxDU4SWdVB7ecExnD8ZoMIIlhEra3AsMGD9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DA90OAk6s7/d4f58uVk/xDIOuXs7qXRsRUqf64Mwqa1i2VsbAZOrj5nZNc8g/zTwm
	 S9hjBOZlCgnRHyb86ea8deaMVTDR9vfmTC6fytQTUp3tNlv2H/usJ2b9+X0/5yK+3I
	 zJljC9GrQ1xoaNT62eeLSvKdSRUbbB/tS89uYr/0=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] arm64/mm: Standardize printing for pgtable entries
Date: Tue,  1 Sep 2026 12:24:54 +0530
Message-ID: <20260901065454.1906343-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901065454.1906343-1-anshuman.khandual@arm.com>
References: <20260901065454.1906343-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pm19rh5rmz1j6f8dj4odittaazoqq4p5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D0B1440003
X-Rspam-User: 
X-HE-Tag: 1788245707-429051
X-HE-Meta: U2FsdGVkX1/x+bJ4+hDHvGfaC7ChIJuGUn1rxz7a2geDXJrMuyp2F5c8eCSfMvOkF5Mi2zXpm2CYcGui3lAnIh+2SxX0o+xoDSN5auLCknWAozpNAE+obdnzPKH7wH6paSRcNhLpP+fnzgUvBxVlohT+TqaeBAE3gPgYyup+JwHiDwvONvQMkhmk8iAYkD1NpX5zRkzIF9IDjCjRRgvumV1YMD49C1uwxdc9UgrYn/gtial6m7DAZznF+Qj9+sV37B0hw3hivHgeFOmWS8PJ931ieGLoWpq4aes27HnxTc5VOmlVEelD04leaKyQvTXm1DJzWoOfXCM83nvnne1ewuJPb6Fxqd8QaD0jPzAuMhk2/orORmT5Z24HSy7JZb5W9SBU18co19D7AkJBF3hUBe+NXGzzkQv2aIpax9uboVINlgOwZhu00mkGK4Z+5FjcUSx9d/8dRtiLNm8d/RUJyIM9ngjv0tNHU46f/OAg/D6KdjW43Mauk8AS4n/6ibtCzyndwzcMXUfOf9KSm1XFBE2w6pVfz1aWKkun1lVgxQXI5CqLe1aRgITcIBK90OZYAlevF+hqYQ/ezT9M6Hoqt7BVn/l8JRKPxvtNcPJnKhfmEpkdqxT8r/HmiFupmpjXsFHD0deU6lXaQCZjiGfRagnjJx5fcs04cX+gTl44/CKrbhrKn3TCAxTp6zB4RqRerHadw179knn9BFuJ1aNBFNE5Hoac0zLwbX+DN7AjSpS25mSj9MfaXwtO8oKi4uMTQtGeW1Qp4h9Srru6g9eIKmoab4px0pagVD0KpHM9nrqJN8vCgt5RWHNxkKadxxyjClUaHgE/TsD52PvtI+qq0Vw94ibY2UCWL2N/cpDRID+WgRknkU9R1FQHtUEoQZU9XYjkwGFpLGwRQ+5ipq7is4kno5Wn6XfzOzwjs9mVAEXRftJTfvVzLODmYQOddsam5EM4E8mw8NwTHraulwS
 WdWiYgMX
 j6XSqU7KrR4QSZDC4868mMExhTtdGacGr+F26Ejpqj9jgD0toPaKDI8G2dP2vWYGpeWAfsvjHz35SiYlEJPb3QPBLUaONz9e5y281POiV2TScrWIyC3dSSSYwtbjHB7D616BJjqO40I+5d8afAUdAhpfdzciQZqIrsS7S2q1BGM8uOh7XyO1826f+lzXahKNfbpk2OV4xfydQn+iJPHt3vmuqkRFRM+S2WKP4DcYgjlZtvom84V18PGAS4fT6bdrTxWlvqVehCnx91YvXtpr+IqB3S4nVx9PnVpl4LpaYuhS5tie8obUe67HBEjtaAX53a5SdRLBac5jQiTxbuPfeMxdKx59NxtRy76XgG/xFrXFqVfjWg66GsWo3tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Standardize printing for pgtable entries using recently introduced generic
helper ptval_bytes_to_hex_str() in core MM which automatically enables 128
bits entries when added later.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/mm/fault.c | 20 +++++++++++++++-----
 arch/arm64/mm/mmu.c   | 16 ++++++++++------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0b52557652be..c75bab3c2f4b 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -130,6 +130,11 @@ static inline unsigned long mm_to_pgd_phys(struct mm_struct *mm)
  */
 static void show_pte(unsigned long addr)
 {
+	char pgd_str[PTVAL_STR_MAX];
+	char p4d_str[PTVAL_STR_MAX];
+	char pud_str[PTVAL_STR_MAX];
+	char pmd_str[PTVAL_STR_MAX];
+	char pte_str[PTVAL_STR_MAX];
 	struct mm_struct *mm;
 	pgd_t *pgdp;
 	pgd_t pgd;
@@ -156,7 +161,8 @@ static void show_pte(unsigned long addr)
 		 vabits_actual, mm_to_pgd_phys(mm));
 	pgdp = pgd_offset(mm, addr);
 	pgd = READ_ONCE(*pgdp);
-	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
+	ptval_to_str(pgd_str, pgd_val(pgd));
+	pr_alert("[%016lx] pgd=%s", addr, pgd_str);
 
 	do {
 		p4d_t *p4dp, p4d;
@@ -169,19 +175,22 @@ static void show_pte(unsigned long addr)
 
 		p4dp = p4d_offset(pgdp, addr);
 		p4d = READ_ONCE(*p4dp);
-		pr_cont(", p4d=%016llx", p4d_val(p4d));
+		ptval_to_str(p4d_str, p4d_val(p4d));
+		pr_cont(", p4d=%s", p4d_str);
 		if (p4d_none(p4d) || p4d_bad(p4d))
 			break;
 
 		pudp = pud_offset(p4dp, addr);
 		pud = READ_ONCE(*pudp);
-		pr_cont(", pud=%016llx", pud_val(pud));
+		ptval_to_str(pud_str, pud_val(pud));
+		pr_cont(", pud=%s", pud_str);
 		if (pud_none(pud) || pud_bad(pud))
 			break;
 
 		pmdp = pmd_offset(pudp, addr);
 		pmd = READ_ONCE(*pmdp);
-		pr_cont(", pmd=%016llx", pmd_val(pmd));
+		ptval_to_str(pmd_str, pmd_val(pmd));
+		pr_cont(", pmd=%s", pmd_str);
 		if (pmd_none(pmd) || pmd_bad(pmd))
 			break;
 
@@ -190,7 +199,8 @@ static void show_pte(unsigned long addr)
 			break;
 
 		pte = __ptep_get(ptep);
-		pr_cont(", pte=%016llx", pte_val(pte));
+		ptval_to_str(pte_str, pte_val(pte));
+		pr_cont(", pte=%s", pte_str);
 		pte_unmap(ptep);
 	} while(0);
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e9c66d26bc0a..b5de4095d650 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2410,6 +2410,8 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
  */
 void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 {
+	char pte_str_old[PTVAL_STR_MAX];
+	char pte_str[PTVAL_STR_MAX];
 	pte_t old_pte;
 
 	if (!IS_ENABLED(CONFIG_DEBUG_VM))
@@ -2427,14 +2429,16 @@ void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 	 * (__ptep_set_access_flags safely changes valid ptes without going
 	 * through an invalid entry).
 	 */
+	ptval_to_str(pte_str, pte_val(pte));
+	ptval_to_str(pte_str_old, pte_val(old_pte));
 	VM_WARN_ONCE(!pte_young(pte),
-		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy access flag clearing: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
-		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy dirty state clearing: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
-		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: unsafe attribute change: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 }
 #endif
-- 
2.43.0


