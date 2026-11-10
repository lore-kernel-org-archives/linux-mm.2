Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 763F2606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iIdpfMby
Received: by kanga.kvack.org (Postfix)
	id 8DCA76B05C7; Tue, 10 Nov 2026 13:01:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88BF16B05C8; Tue, 10 Nov 2026 13:01:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 754C76B05C9; Tue, 10 Nov 2026 13:01:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3886B05C7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:01:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8803F1C448E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:01:45 +0000 (UTC)
X-FDA: 85419977370.25.B523931
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 88DA0140010
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:01:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iIdpfMby;
	spf=pass (imf23.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333703;
	b=EPsyOZaUx7jMbkBIqK2Crp4ia4XrG+qMxQwV4zyBRPLAgAPxk2pBNbadnec3ucJy77szTI
	XYzoxq0wM3QDhXunOM/me/hLKl2KENrqAW1YygR1xWDHrZZXRqY6gT4rfaECFnIMs3yNup
	pOmaFcE/S2H3HmII7NkjPs84kVAgwOY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iIdpfMby;
	spf=pass (imf23.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffkUJwZ8UkROiknRJlX9e5EvFD6tviWkRuBKEdkUb64=;
	b=kosIBx7OJQnmaMHd4thdXRc8GGAWiKF6iULdtk4E2I2BuzJtk6s2Ss5rwCk01FVs1lYi2+
	B9BmrkI5EX3TsMKo5Z4+0p9I1Bwhir/XK74BzBcY6upwMp28fcwUmuPTE0+unVvAAkVDRY
	PVzEKyEnlKyttgIE4/l+p9T3bn95zYU=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-18818daa3e7so701170c88.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333702; x=1794938502; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ffkUJwZ8UkROiknRJlX9e5EvFD6tviWkRuBKEdkUb64=;
        b=iIdpfMby67owsOUtcSVtAA+R9qKDe/lNn+wRDCYy3lQA0n9Nxj+zanwN3p+1UBTqpp
         4jTUJASxj9Om9uqLpmiM4bPRNQNpBu9t6HUrmLn96LBoessX68rQ6mzgvRnipvzHNVig
         ni1qlCuRXC0l1NpymBMu6XOw4sSThJL+b2cbC34V6lUlEc40MChGHmILBWKQG67EDRSQ
         w9A+aMUvNF+bhvIc+DKDJiEodscOeXuQkvIoJG/I5OFuCCadSc8c0OZUPNvZz/Yrven9
         iXywebkP31O2E4FOYZRoOs50x0YULYuO+n4WBWKMb2CbgHJfon0jobmIT/sE1cESurzk
         WwnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333702; x=1794938502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ffkUJwZ8UkROiknRJlX9e5EvFD6tviWkRuBKEdkUb64=;
        b=D07oYOJeW9+uzTRXNOZ0/C8ipoKsXR8NGzJkePovfQdijI24Lqk5v55H7OPmPcaMxV
         4sjMjuOyr0jx6gp4dnqZI2sy9V8Bv4SlImScTiO/rSd0kEp3m1xJw5iUwJQ+mk0wYmtu
         1klcWy+oikRjpRbC6i8bO+HAUbuVvTtNJNxesKck3iWaN59MSK5akM6CMxBHhk7CEP1I
         3CLhdKCxyOkYlJxs2f4zKR7aCUAw8MjxFquLlHA6X6/nc5xerqvmXwjHUIjc8OPmN26M
         Mp/wmrUbc56BwI6Vi6cVhopNKEqyOVyRjPR5hmZ5kRFMCqcTWaGNui1mGhaIEGY0XG89
         uu5A==
X-Forwarded-Encrypted: i=1; AL+hErGKmNs8BX/nTRKzFHhyadZdFlCovTFxspQeKfUSK+e6mf083o288DIjgjUAVnTzJ5lbLf6ORFCAjg==@kvack.org
X-Gm-Message-State: APuU4Z/wWB5AOqKTw9AJnEKvRRq4jdCMpYJQQyXqz+DPWT7gQAr15lpT
	RGZ99Zwx7P8QDKHuaXiRfXLaaAN1S3TNDzHu21EPJQ9hVu/tgjez4LHI
X-Gm-Gg: AYBFou27KNJYU8aZn1qFrUYNtdBryx44UOaj5gsmcGPxDBcpwC0YtwsuPKHGY9ZzlX1
	P00MUR4UMGDd70nXe7GqGjJcOlm/dyV4rynH2x0H0SNeaTVGv8TAqFDcHVc6Ehw3t69wyON0Fg7
	hahemuvgAJ1N0y6X8v+GrxjzQUYeJU2UOLTdrY63OnG+azeUeuhh4g+8qLxf6MuZZM5D74HmQxR
	8Hum+uQI+hToTizzgj3b28ROD1aSLbGm/Pvdgay5NvIIzS5g6wJHNHmlQM53gDbnT2LRmzhY9L/
	fCmrzAelKsavBkWeTAjjWdoj2/OtX3u08mOV1reRmWZJUqFetVUu7cTVOTFjizu215LqE2S8BCX
	9wpyqZYwuSEwangKSJG/RUhZgcf9FRFqyRvIdVQHwegH7rV7w05i0E7aiwSSqKOda9EOnPJfEly
	GiklLd1+TCnCAWYJdHrt3oEfsVl2z1ILiX/Pgnl3CkSlyzuj62jC9fN3J9PtwOhexCBs7dtqJ2B
	OZm94S44nrcENDtoME3zYDr5p/bkwSowz+b8ghS/rP9LTI64FUMNe+hHO8jRoJww7aynIDKoXS4
	6l7cKMc17QfiVvggUktaGyBnQ5x40XKtMCUlhHDZh2bTZrjm0UHBGiqdWk8=
X-Received: by 2002:a05:701b:42cd:10b0:1b2:de00:9bc2 with SMTP id a92af1059eb24-1b3bef25cb9mr282228c88.12.1794333701814;
        Tue, 10 Nov 2026 10:01:41 -0800 (PST)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b4b90csm7624260c88.14.2026.11.10.10.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:01:41 -0800 (PST)
From: Yin Tirui <yintirui@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com
Cc: ljs@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	nico.pache@linux.dev,
	usama.arif@linux.dev,
	liam@infradead.org,
	kas@kernel.org,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	yintirui@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH RFC v2 9/9] mm/huge_memory: unify the migration and device private PTE loops
Date: Wed, 11 Nov 2026 01:59:24 +0800
Message-Id: <20261110175924.2945538-10-yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110175924.2945538-1-yintirui@gmail.com>
References: <20261110175924.2945538-1-yintirui@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 88DA0140010
X-Stat-Signature: nizyrojfjzw4xsm5errxdtgs3gau7zcz
X-Rspam-User: 
X-HE-Tag: 1794333703-146500
X-HE-Meta: U2FsdGVkX181nljzYunxq8Zrn/eyEVrLdEcR8YOowQ+wlLKfGNxDYwFsTDlZZzunRqiSWihc4AfylNbBWDTlm1wxieeEAsNluomQPSsLN7bZ/C+uxeLp6DM0TteZb+ug6C4AYv7OjivBueex6rRiV5kGv9HNq0eK2E5U5J8pwOyPNcA1/NzzjF443V/6caeCMBuf4ATc9PF1Wgig50rsPc43fIGvEiHfVIBBWPFmf7Fm3yXBPgy7g00Kd5LCdscQjqzoqVLL6ksE0RHRp6Y3Qtmrzi11p2IbZvzAGLOZ5JzGkytZfvINxhO9vVF8Bj30yTwWJQ5Bam/G4QacO0zsTDNFNZHHpeyWMcPFnOfizX06wO3MpGgE4SRcXfnDLj8j8mI/uCejp/3avgR3Asjd8+OnNp9LuSl/ZPj51Eye0Zq5VQAhK5y02fEQO+JdQ+kkaqbNop5tqwNYU1n9U4NIoPbXVL0JN0yZYMnTrtqFEOIQXS3MAbWZgGL9PHVJQbBse2dEe/+rlRPkg8A6ZB4TuIdzlClmRRWs+swSzExT5Wyj89S19GgtEAT2njI1Fy2F6srLqVxLWSin449WBCl7T4zBIab3EpioBXAr4bUHg88EsI+yrWEfHfOJO9EnyPnxBc79dPyB2+e/FcV6hUsqRORZimBp/pTY5R1dJ7XzMLDgvEcDifq4tzz2ppLCOukq+qzumBOFFiwAePAK20TbMAz6e1mZaS/Qk/sS8/wUBFVhylxoftQ+PVhaq1J4JRzT/j+Jv/un3OGEIxtROy7LhZQAiFLsphf1hIW6QVolKHlVDr5NlGLLTppx5hiPTayCmW+AD38UVgFFZSPw5zpXLerv/sVpMNUavqPFGQzx2GmenG3FSZf+EZIQnq2w5PFsvYP7yVVcGYGs3FFSZEZdIAGojeTdxAIkGzuj2vAIcwOPoJBkE1vTnwvkEmhn5S+GZDKPngnfoNiKmf+Oeo8
 PlPFnrot
 9q/OCUNWho4QYf4kDBl5qhk4/dllDgbB4S3jJRfXursomtXMkuDwy10my4bXlMCoWA37z/KyafsovqMQvJOpewuXoO2pYL0NjT0uGViOUk1JXq0IlIRCA/jU6NX5MkuiXbtR01HPAB99wCUpq4mN5Qo3LX4VcJRlzC0ZSMkkRpxoKd9mSktoPf12OBnKYuMaWwGhm1nCdT09wpoFkrWVmAXE4RXY6Lqy5sj74OsXxnvsFeqI0XKYi3KVHllGvNT+G1JQAQKXHcUvi387hRiytv0PbF6dpxWuL1i0DwIihTkgG+i++n7StQFYMYXUgkqHrt1aWxtTXrVeIIBretuj8udk0UFDp/TKlUv3ClFjhfndqkKGTY+GQksNu2dYfkfhLWW9K2wuMfF5PWX6c2NJ0+fgnvpcl218gaDC67KTIbgxZ7HHMWXr0ye6h4wi10fG0gE1T8gfnLLX6y70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 5eaf8a87f1ba..04571a6dec6c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3290,6 +3290,42 @@ static bool split_huge_pmd_anon_rmap(const struct split_pmd_state *state,
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
@@ -3326,53 +3362,14 @@ static void split_huge_pmd_to_ptes(struct vm_area_struct *vma,
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
-			 * Young and dirty bits are not propagated via swp_entry
-			 */
-			entry = swp_entry_to_pte(swp_entry);
 			if (state->soft_dirty)
 				entry = pte_swp_mksoft_dirty(entry);
 			if (state->uffd)
-- 
2.34.1


