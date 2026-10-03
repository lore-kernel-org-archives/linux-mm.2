Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A6BCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49D16B00B1; Fri,  2 Oct 2026 20:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A202D6B00B2; Fri,  2 Oct 2026 20:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911206B00B3; Fri,  2 Oct 2026 20:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 661606B00B1
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06FABA78C4
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:53 +0000 (UTC)
X-FDA: 85279412106.29.9997439
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf07.hostedemail.com (Postfix) with ESMTP id 595F740002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a4Zlh6RB;
	spf=pass (imf07.hostedemail.com: domain of 3nUrAagoKCJA3D18E01D8708805y.w86527EH-664Fuw4.8B0@flex--jthoughton.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3nUrAagoKCJA3D18E01D8708805y.w86527EH-664Fuw4.8B0@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCgjHn2mz/yCHbbXpM7X3kmHNH/eC22IJjKzJWGDoHY=;
	b=RfdkhFuCYRXRllWrItoisRl95HLr4kdV+Y2t6UfTcQ9pCyQeYPnapcqomcLqEuudZHd6v3
	gEZpJnkZ2QFckiQOpZPKC09I70/Sx/DicAbLNShFgjzuICJ9tgdmkytvkmRhd9QZBU5xaR
	k/svDIuf6KyYiVve92Ukd2V0a2BK8Bc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986911;
	b=5F3IA8GadtmQkp1yGPZ1qAUw+f5F9Vr/4QW8/0jq4m/Zd9FiocdTfiFC2MUxBTm2bA6Ulg
	zOGbxXRDk8oMQIzQp4EJcP/g6HY4H2lBIda8eOCEY50tEbb55RW1Uswuww/ZDHg7sYvLvr
	0BRBUivsj0o4FUUu841NCFhPCI31g0U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a4Zlh6RB;
	spf=pass (imf07.hostedemail.com: domain of 3nUrAagoKCJA3D18E01D8708805y.w86527EH-664Fuw4.8B0@flex--jthoughton.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3nUrAagoKCJA3D18E01D8708805y.w86527EH-664Fuw4.8B0@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39de4a68f7cso332739a91.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986910; x=1791591710; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tCgjHn2mz/yCHbbXpM7X3kmHNH/eC22IJjKzJWGDoHY=;
        b=a4Zlh6RBzcw47N72M3Udnbj2Fh0wV4Q674c/2nicowhhuwHAe7pxNYhtjEgjV1ozW9
         thMKK+YUKaiHZjz4Rg6sV74bjQxrYXI8VM7GXHuM89VA26B2F8Sud89XfqlskfoeWs7l
         EreWroyxoGHv+6E5YmYeW0LNXQmiFfURopgYPnlMtj97oLIGJntnpz7fRQ74XpI/jS2X
         pSM8WRW1GUsxIAD1jt6O5o4G8dFj1Q7AoxyojolsHoHfOFoaBc1R2Wnt1gPaRzsjAywQ
         UUmZkwoqxZlQnA39RqtQ6WgVJzJsO8hH4LfSH22ebpRDeVv0SMIuCE5lWtTBV85Nzf6P
         Ht0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986910; x=1791591710;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tCgjHn2mz/yCHbbXpM7X3kmHNH/eC22IJjKzJWGDoHY=;
        b=TVgg2fH5rClLemBPJrPBLjSBLd160kJuWFSV89m1XGSANgcgNOTL5cSYpjwsWp21/a
         uAnlKXIzlwEJKazmOgDoueh2jOmyi7swZ9LjttCEiioEGml2pkowD8vu6CEzVbzilzFm
         paVxxPz/OcyIXmuIic0sUmXYKdTECzLBlTh8Oirv3uxQbFDqH6gcg0gHWwr6B9FLqHEs
         Sx7jDIvi8Kn+2x7oTY1LW+Bc+8x6QVM2nx8kHR92zPAlHXc2skwGV7lwHLQzF8ItiZn6
         89vjpfJj+KJkEUqWpDZ6KlRH7wq+vpsvpwtGGztlxNruWG/PFb9IoCvCIB98w52vlBlM
         Tefg==
X-Forwarded-Encrypted: i=1; AKwUvByFXmIwFqr17bheT90h+S9Z8f09HEp6D8G/++AlWE0MVMdDI9EY/6QjrPeFUzEiAsgmWrDo/n25zw==@kvack.org
X-Gm-Message-State: AFq9FYIgNs9/so/vzcNU4LenC/SJe1ZgKpYjFbbw4XjENAd01i6umu/Y
	uyZy+40OPVcu5Xhu3YdcJixU2thXnLRf2frvuMBVJ9S2exstxBS2cC4q4etNyriOjkPItFVAYyg
	a00w1lPnwyeRUmUq+njAHSg==
X-Received: from pjbmv17.prod.google.com ([2002:a17:90b:1991:b0:3a6:f87a:f3e4])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:33cc:b0:3a2:bb45:d37b with SMTP id 98e67ed59e1d1-3a6ceb00093mr2158482a91.25.1790986909781;
 Fri, 02 Oct 2026 17:21:49 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:20 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-18-jthoughton@google.com>
Subject: [PATCH v2 17/20 DO-NOT-MERGE] arm64: Implement try_populate_vmemmap_pmd
 using AF trick
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 595F740002
X-Stat-Signature: ehkpfgztxy9wybp8f961aod86ayk1a6c
X-Rspam-User: 
X-HE-Tag: 1790986911-806829
X-HE-Meta: U2FsdGVkX18eOoRKczS+rW4vUB6sDj++UiqsyJEhJFs3a5okCDlHq908rwSuMoB556ENMIf0ZUgdYqIDobE5kmI8GLWUH/oRg+XjSrT5Si7d0LiRm4HcYH204P4nhZq9I5SoxWsBN5ooSS+17GBRTGdX0m7Gewh6mITxs6vFMs+nyyBQlQshwi8CrcdTz2uBZspYNUH/yMaBrXLYt0i0SKIM8NeCdgTbJ9d9AbbaN4KrI9DTAwZT8MXbOJAt4PohUBtoCqnhbdnflsKtE4sgFpLOEOUEg1sWWRz/qIizfPXm6/CxmZzPG+ir/rY1Q//abpAX2DPyZkJIdUApRRe7eXQuByGArTqD99qE0Zjoe0PXILjn01hiJzAdWHpK5rI0JLGeIPkhtQydy2ru2wMHEjcS981zsfRdjizZ9uzafDNeGyIlat/mkWbLwSrbaDxAKPt2gLlozEAFf2gX/o5AFt0xyF+vEyMsDhjFDYJfrz3ELjA0VxUyVt0nDKNDb3d1Uec7feFYL5FWVhK0pVuZwO4TTyo8zvDSwTTvkk4te4f9iN0eSx6U64xzkZASqkxxqKkcjaSkbv7Dg5pphVX0F0u0Q10I4DhbeS8VghSel8rWP9QLJul6y0pQc5G8t4tApWWie2WzqGXlluT4ks0Zbg2ZGZqIz4JJcJHwWdcPsOmES5CoFC6T8QEJfOKtWXKoijJ/cuADpX9dVITtgqjM0yca3S1wZBqYAsskhUpH5m4TdFZxFPDxyUuIqVk1IV+AhVXAVHR1XzinTbJNJeWFWFsTSGE5rHREQSxyMMVbLAefyh/b6Z1ndC6PM4xD9yJlvd1I+lcEgirterse3U9bQNszySdxTcLSCDEFSZX9UrEnGeECWc3t92tKOr9JZUrAv//bmvi65Ti1vMxcHXsIszdG1HOpRpSsObonWUgbfijSxgbmHP9DFBnP/j/USDefEMULGhk3kFt5iGMSSA0
 evuFZQ5r
 lACR2rqQoH2/5MTXKLDgzh27UcKbAxcgq8jY/l2yYsU6zSzMMJZg7XEUYEQvBk+MAnsgAVxci/IFl7GsioY5yj1NBG+Jw5VWs/rA5PsHlP7Tk22GbU2FmpCWdPl7cjedwElPAUEoMI8vKzrz50HCCVUzQ7f0xoG/D4ytl/C4RjvHtk0pyUatHbldPfmSIw0u8td3+OxFMvPiATmz49iMUv+bzArqZjf+2XrQEZxqhnEWvpFUQu5LTxOjo64SIVgUEd4C6Za1aVoFCYJM+BlwHK9G683PdADZRY5OvZY6s2CTnAM1f0LbejnyHMkOpk80DUPy1VmjLP6ElJ5tSRt12A5LQqB6sQS8MUmfU92S1mEkhgBoZnYLy5Erj83nHzzgIcBaWfXOR6ye/sEJrmy6c8ASLcowNWK75BlcUC1iiTjD3eOUjROAIBn1jWIrPZThGJqnx64xQ3a/A6Y2xbouShl5ELhoh3Ex9mP4TrHKrN0bNlFYahjiiDj4WTQso4/Hq/FcKU8JcE9oArcZ8J5IAncdzOCwPZEb1oTzaGofA0TGH/Qp606PWXDqeYWF7PCp7uaW+QaSIgLopMIvRTh3XQfpVECZixrUMfPE3duR6tRvqioJ7r0/2IcmA/5iw6+98IOhNrLgHCjMol4BwgyK+cJGV5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This routine is to be used for updating in-use, leaf-level PMDs in the
vmemmap without introducing a window where vmemmap accesses might fault.

Implementing this on arm64 requires some care: use the same access flag
trick that is used for vmemmap PTE updates. HAFT is not needed and the
TLB flushing routine remains identical, as we are not overwriting a
non-leaf PMD.

For systems that support BBML3, there is no need to use the AF
trick.

Signed-off-by: James Houghton <jthoughton@google.com>
---
This patch is the main questionable piece of this "DO-NOT-MERGE" part of
the series. It's unclear if the Arm ARM truly requires hardware
implementations not to cache anything about AF=0 Block translations.
---
 arch/arm64/include/asm/pgalloc.h | 51 ++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 0263329fb7b3..7e304f01ce6d 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -124,9 +124,54 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
 static inline int try_populate_vmemmap_pmd(unsigned long addr, pmd_t *pmdp,
 					   pte_t *pgtable)
 {
-	/* BBLM3 is required. Its presence has been checked. */
-	pmd_populate_kernel(&init_mm, pmdp, pgtable);
-	return 0;
+	const int max_attempts = 16;
+	int attempts = 0;
+	pmd_t old_pmd, new_pmd;
+
+	if (!system_supports_bbm_through_af())
+		return -EOPNOTSUPP;
+
+	if (system_supports_bbml3()) {
+		/*
+		 * BBML3 allows block->table transitions if the PTEs underneath
+		 * do not conflict with existing, potentially cached
+		 * translations.
+		 */
+		pmd_populate_kernel(&init_mm, pmdp, pgtable);
+		return 0;
+	}
+
+	new_pmd = __pmd(__phys_to_pmd_val(__pa(pgtable)) |
+			PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_UXN);
+
+	old_pmd = pmdp_get(pmdp);
+
+	do {
+		if (WARN_ON_ONCE(!pmd_valid(old_pmd)))
+			return -EINVAL;
+
+		if (WARN_ON_ONCE(!pmd_leaf(old_pmd)))
+			return -EINVAL;
+
+		/* We should never get a contiguous PMD here. */
+		if (WARN_ON_ONCE(pmd_cont(old_pmd)))
+			return -EINVAL;
+
+		if (pmd_young(old_pmd)) {
+			/* __ptep_clear_young() returns the overwritten PTE */
+			old_pmd = pte_pmd(pte_mkold(__ptep_clear_young((pte_t *)pmdp)));
+
+			flush_tlb_kernel_range(addr, addr + PMD_SIZE);
+		}
+	/*
+	 * Translations without AF cannot be cached, so we can replace
+	 * them without BBM.
+	 */
+	} while (!try_cmpxchg_relaxed(&pmd_val(*pmdp), &pmd_val(old_pmd),
+				      pmd_val(new_pmd)) &&
+		 ++attempts < max_attempts);
+
+	return attempts == max_attempts ? -EAGAIN : 0;
 }
 
 #endif
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


