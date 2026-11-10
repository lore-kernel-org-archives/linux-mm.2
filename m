Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D08606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cPHzWgN3
Received: by kanga.kvack.org (Postfix)
	id 0264D6B05BD; Tue, 10 Nov 2026 13:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18AD6B05BE; Tue, 10 Nov 2026 13:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E077A6B05BF; Tue, 10 Nov 2026 13:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A89266B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:00:24 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45B19160A17
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:00:24 +0000 (UTC)
X-FDA: 85419973968.10.4518E54
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5503B1C0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:00:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cPHzWgN3;
	spf=pass (imf20.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVpFL1WODwRfenr4aX6VwfzwxpQDJQNEZFl93DOugG4=;
	b=1PpkFrPSwHtX1cjlT2vukdo3KwXpZV61wCZpfxWuC9oMrzWP6eySosLtsrVxRKSR0ptyiP
	6kLit08eobS1KR7YKRTZtHT9c+umYgYQcU+za0Zsp08t78+g3E59Ivirstaj32lzPcXh1J
	/SxV2Is5y8D1i01YiFPBxFIDmlf0pVo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333622;
	b=mYunWnJmn9oPtntPr0cc74WNba1Ctrul6WrR6N64JuRauuOxOVZURIzbmR3ozEHR5qaWfQ
	8IWllFzqhoyZYZ8pjPPF/EZqOOyuP8VVesM398VeszIj1vj9GdrMOaofD0Mg/fFdbvEUxR
	OBda3BLg2okmk/oF1lIJX7kk/vA9Lzc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cPHzWgN3;
	spf=pass (imf20.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1a2761c69fbso3616206c88.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333621; x=1794938421; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fVpFL1WODwRfenr4aX6VwfzwxpQDJQNEZFl93DOugG4=;
        b=cPHzWgN3ktMQ6AiZTJZ2erugAvPAXy/s6+lDmYfiqXsUmo0LQBB4fgD44YQyIrHNCm
         jsI05vxU2XfRqx5V+aleZbipzb0kD+TzMUZ2IfDIIvUslR2Gz473+eclBM8wBCTSmR/L
         oMzb1lysst/MnYENoafx3rmsCTUkbDGAbDz3E0Yp7Dwn7KBgYxlwrS487k4T+ZjFN2sI
         VyYptRkWtOT537vsuhK8j7poHbHBKdvWCXLmehrNYxxf1Ii/OZm59AEhQhWr/Ooeikud
         o7QygE6tipD9T+9oyPRetytqxuUUOV3PksO69wAbw78C7Nou0q15DtKKwWFxHp+kG5v3
         Uabg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333621; x=1794938421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fVpFL1WODwRfenr4aX6VwfzwxpQDJQNEZFl93DOugG4=;
        b=s/hfCp8xlJUBhqyH+bE5/8fZk6Bq6/9/V6NhTDuUF/z+Cj4erdtHdXpN78NFj4DNBf
         VfnfKVdEBhhfkCpO2YjK4OFAcO+MIswv1r2ILFmWkS5OOtHY+spwgt46uun+oNLCyisZ
         8xOt5tTAcB5ZS6KGqv4TIz73oSgKi29ancoZNSxg0JHelptmWRfGVDPhm3QMaqfzPjFa
         kGk2NKw7rlt1VDbPvQnfZ3JXzAn1Kar5kssfueBqmKDnM2WpEs1Tr73U4nk7EI1KmUO+
         5QRzqibWqQBecYoKaxejRtuTlRs27j+MGpIWVy8peLhQqOSWlF1odTXdLz9zzFyxaB26
         UW6A==
X-Forwarded-Encrypted: i=1; AL+hErFanKexTMi3Ml923AZXd6qd0wkdlrd6jFmwctZdaI/kxwiCHQaPGkvinN7OzkcfaZzNNM9pacwjrA==@kvack.org
X-Gm-Message-State: APuU4Z8InJSBAZBMDKjLotNlq7soxeL1VnCCMtiiQC5MU1FUMsIuqtHR
	NSs0Kp1Utg1a0oNra1pdmNgpu0XIxvp+yinmL1nMT3iLph4MTam3f/8C
X-Gm-Gg: AYBFou1t1lc6O6V4T60tcMpsd7QNcOMyTX5GOTHZ0Yab17O2is7K6mJ+V4qwDyWIeIW
	jovNlD2ecGnlIJ4RoEA7rQZYhKh9hQsNi7h/oLACJE52xsQGZbVhFEzKV2dDt4U5Wq6pd2yfp6Z
	25jBVYifEoxstajjz0YIyNM5UOANQnWgXiwWiCnrHpIlxqJ53QNH5FiUTqb78FYnCYe3+jajp1g
	Ef+no026LT5UIjipA7bizr10TAFN8VCQDezhNEQNSf5OgtT9a4HGMRuwAlllSc3HeJCW5Bjw3qE
	68LbnWjEAFVHMg8PbT/AtufQnnuAV6BYjkW58C820A0BUcDxFzE9NkXYN02ilWgZvVEz1hzM9Sp
	5vrYPqr29KeTqKy90S2c7dQgXbvHWr2NM50doB+TFaQPLxFo1VC8iNabVGF6zN7g6CWHd+zi6IP
	t06RZr3+lAP9SzYRg/lMdG6eEY7oqe1aR0/UjV+X1lm7Znjxuf2gJ7pEAw7w6NhVGWQblXWiHWX
	eFJysn1WJVEi9lmvwvF/Wn2kBwI52XV8XpBOcXOnEQHCLqtr5Gh3CGljpVEFFQ0G6/BatzF9uRP
	D/Z8r7yRKXJ48z0dNDIf8nnW8e908Hh95debxTBviiSjLcxTT9E8QyRate4=
X-Received: by 2002:a05:7022:170a:b0:1b2:533f:622f with SMTP id a92af1059eb24-1b3b605af2cmr4401995c88.12.1794333620939;
        Tue, 10 Nov 2026 10:00:20 -0800 (PST)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b4b90csm7624260c88.14.2026.11.10.10.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:00:20 -0800 (PST)
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
Subject: [PATCH RFC v2 3/9] mm/huge_memory: add and use unmap_huge_pmd_entry()
Date: Wed, 11 Nov 2026 01:59:18 +0800
Message-Id: <20261110175924.2945538-4-yintirui@gmail.com>
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
X-Rspamd-Server: rspam09
X-Stat-Signature: 493da643tf4crsxww7m3bzjtzepbojb5
X-Rspamd-Queue-Id: 5503B1C0009
X-Rspam-User: 
X-HE-Tag: 1794333622-865028
X-HE-Meta: U2FsdGVkX19X8OzrobD7cc6pPPfz8vctlSHZYpvLS5ucU83uqkOTgzrnbXSHy0AXrSUJo9QzQSnVp3wWO5/5E4xRuYiHJY3RHc7J9LA5YV52y5jrB1PywT3rj/i+ojcXdJW7I2cxoL32GOGIN0i1sYJ0k2bFbx/JCXdNghimHoOl60PPXfrinTcd3ofWVnHSwgwrT8wGEWpdXCjuT/oDTWt6iAruEYS8ZF3EvqW/aWHvHE5KjD3cmF79mdkQs4DFH+GBu/ZziTWV6kBYFden42lkM/4D6r+mfDoFxkx58pvtPtrga/xAXHiXyglpRJDykXDM+2WFDOxDN256Kzy8ldGCs/Rq9kzi1M5xqN9K1++ouWDlQbjyxxcnOSycQ1Lfl9J2ZJOM3qvcIzFGYwbGJkijatdV6CYKFRWueudpQ8Gf/wwpu+2s17XZZFa2e1o4RyO1l6XtaPkmig4Eljm0Y14aMFixnvnTsgdofiActj7wpbHhN+RAw585zlSUgu7EzNNaPHw6tF947j5wB7NJ4lU+vk+4P5+sNEV9WgOe8htQ6c8K6zjhYDaYLSG5uI9MyLVJz8Ofj+HjDHmy3yo8hGORIfVKC2ubWgKIjqqkk7kJ5Amrb8VUPI3IatUfN0nXRXUiG+yS9C3txi5SB6bFiUuOJD6nKqNbbo+qpDsQbD9JpJPlcu+eCresNRftAMgWsGYMexDorwWlhnH/vdQztgq1FBAE9NJW1ebYWUFO8vUmN+CcPgvs46u22WLct654luw0q46yGxmvrOXlYxwS/zMto0ERHLYRPoO9rf6nR4Qf/zBz93NPp1s9PbReeM8heffP8hXsmh367ZSJ3NcZn6hWIUpi+W1vwuaKGIxe0Nu15XfH/hZFM4Imsb1uZtMnrf9F4Z9SiW2E8r5THP95kF4zNjbYJGk7dUspBShCP4qI8vgpeJHEiOW/jK3hqC1+DDTedgrdZ1GB3A/8Byw
 3rDQQozr
 Sy7Kd+qCEtWojIhYwp+Kp+IpwEbE4zgxzZtGvniA2RvAVtxq0luUGJyeCfqgL8JNrvP4S0rSwAb/JwyTaVXOhXlfsz3mQoGjobPpDwqF0F2XbT4Za6IPrlVlEJ+eq7isIzErBb5GWNyDOGzDhO7hl6GM7ugHW/Zl8xmLrIBxzyfTTORdgN6pkp3E1TtVxs5YsCzcFC9zafumy8A9wehyPlFl3XKr3NsArSQJbLdRzEjRHK0lERfSh2bJScIPdc1Imma3ZsUUiVHhLkdyPwWCd73hYoLXSJef+9AjtfiAM5KcyhCg6GaM9AjmE+0sEkMgMZWvN0Wp2FmJSFdfPb8bSf/pdFcITTtmKy//UeH4fihSIZ3DQj1N+GVG3BqdDvrs2uB96R4C9aEQZIZ8TX+4fctGHzeq+J+ZjiIm64QzvNuiKquMcVrOyeOmGD3/w1zGnkTU4Cf/Aj9X/4hg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Only a huge PMD entry mapping an anonymous folio is split. Everything else
is unmapped and comes back on the next fault. Put that in
unmap_huge_pmd_entry().

Old and new differ only for a device private entry in a non-anonymous VMA,
which nothing in the tree can produce.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 84 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 56 insertions(+), 28 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dbcacc7b1374..85813114fde1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3193,6 +3193,52 @@ static bool huge_zero_pmd_can_split(struct vm_area_struct *vma, pmd_t pmdval)
 	return is_huge_zero_pmd(pmdval) && vma_is_anonymous(vma);
 }
 
+/**
+ * unmap_huge_pmd_entry() - Unmap a huge PMD entry rather than splitting it.
+ * @vma: The VMA @pmd belongs to.
+ * @haddr: The PMD-aligned address @pmd maps.
+ * @pmd: Pointer to the huge PMD entry.
+ * @folio: The folio @pmd describes, or NULL if it describes none.
+ * @is_present: Is @pmd a present entry rather than a softleaf entry?
+ *
+ * Only anonymous folios are rebuilt at PTE level when a huge PMD entry is
+ * split. Everything else is unmapped here and faulted back in on the next
+ * access.
+ */
+static void unmap_huge_pmd_entry(struct vm_area_struct *vma,
+		unsigned long haddr, pmd_t *pmd, struct folio *folio,
+		bool is_present)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	pmd_t old_pmd;
+
+	old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
+	/*
+	 * We are going to unmap this huge page. So
+	 * just go ahead and zap it
+	 */
+	if (arch_needs_pgtable_deposit())
+		zap_deposited_table(mm, pmd);
+
+	if (!folio)
+		return;
+
+	if (is_present) {
+		struct page *page = pmd_page(old_pmd);
+
+		if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
+			folio_mark_dirty(folio);
+		if (!folio_test_referenced(folio) && pmd_young(old_pmd))
+			folio_set_referenced(folio);
+		folio_remove_rmap_pmd(folio, page, vma);
+	}
+
+	add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
+
+	if (is_present)
+		folio_put(folio);
+}
+
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long haddr, bool freeze)
 {
@@ -3232,34 +3278,16 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 
 	if (!vma_is_anonymous(vma)) {
-		old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
-		/*
-		 * We are going to unmap this huge page. So
-		 * just go ahead and zap it
-		 */
-		if (arch_needs_pgtable_deposit())
-			zap_deposited_table(mm, pmd);
-		if (!vma_is_mm_managed(vma))
-			return;
-		if (unlikely(pmd_is_migration_entry(old_pmd))) {
-			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
-
-			folio = softleaf_to_folio(old_entry);
-		} else if (is_huge_zero_pmd(old_pmd)) {
-			return;
-		} else {
-			page = pmd_page(old_pmd);
-			folio = page_folio(page);
-			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
-				folio_mark_dirty(folio);
-			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
-				folio_set_referenced(folio);
-			folio_remove_rmap_pmd(folio, page, vma);
-			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
-			folio_put(folio);
-			return;
-		}
-		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
+		const bool is_present = pmd_present(old_pmd);
+
+		if (!vma_is_mm_managed(vma) || is_huge_zero_pmd(old_pmd))
+			folio = NULL;
+		else if (is_present)
+			folio = page_folio(pmd_page(old_pmd));
+		else
+			folio = softleaf_to_folio(softleaf_from_pmd(old_pmd));
+
+		unmap_huge_pmd_entry(vma, haddr, pmd, folio, is_present);
 		return;
 	}
 
-- 
2.34.1


