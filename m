Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F4A3C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62FF86B00B5; Tue,  1 Sep 2026 01:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608076B00B7; Tue,  1 Sep 2026 01:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D736B00BA; Tue,  1 Sep 2026 01:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1646B00B5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:44:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A28BC1C17DA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:57 +0000 (UTC)
X-FDA: 85164104634.01.EF8BD9A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1EF8E180006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nBLhpdqq;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788241496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYQyAR9UvTgHuuAwBoojtHKW8eWTyw2NnaY668YZoEo=;
	b=PzdJf02R/3yBx1YP2ACXAiAb2uyCca35xXQ6wMfBYWxw+ecGRqQcJcXY043pOY4RoASEkN
	FuoQkr57VI3bBKdcxDlxjQgc/dp3AqD2ghMMVRLVsrWf5XNkMm9tFtUrqubbbQ7rdgX/jI
	ATloL00PPuQF6SDV1/4CAS8k8IhH1Qc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nBLhpdqq;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788241496;
	b=vnZJQoA/seafKOBrLH+nqVUHkUCaq3uXTLk0rV7mkl4aKTUA+Bu6h7HAuG5sYhx0HEad2B
	ESDNDFirU9anoDx/nwMkis/c8TkT/wJ8sEBK/rKQ+GFpUDmneINo2RbJ5hAEVy6fqYwl/H
	tCWd1URW6acTFQs93iJlZ1Exh12cjOc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DA081756;
	Mon, 31 Aug 2026 22:44:51 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 559553F85F;
	Mon, 31 Aug 2026 22:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788241495; bh=MUViQSYFM/j8MeFADam1qMeEw2VDwtqRRIgpPPWeUZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBLhpdqqTeiLBsehoAgcnw5ytfBWyQ0xm+6HJxkFcOWigjKxlOo00ljikMwNN901B
	 cAROJ+KOhN61lBJivqsFVGsiHbEwUTULpVkJC3sQZ+/EcGS2ohMeraBMHRgGU5LuPz
	 eXikSx8j70m4MiV72hE6xi7jYl9SlkGSd/YPikoI=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 6/8] mm/internal: add set_softleaf_ptes
Date: Tue,  1 Sep 2026 05:43:53 +0000
Message-ID: <20260901054358.4049095-7-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901054358.4049095-1-dev.jain@arm.com>
References: <20260901054358.4049095-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5ep9fzdmbh3poewuttxmgrbzxwjm8ftt
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1EF8E180006
X-Rspam-User: 
X-HE-Tag: 1788241495-275375
X-HE-Meta: U2FsdGVkX19c5jK5SK5OoPwzZ8m2t9ZtvISybKSIWiq9TVG8YcAY4QnuJehPiMj+HNsBaiKyj0Ke77abXEQMXLZ6FEnyGQ2xt967arkMmLp5lvrLGVnfVnhuDIby5UlErnxmLvWFeOjZGMuZvReFizYL6+fQEHOWHN2p9QyIhlBcOyy0EheGXO34uZwrr7upsANmeg0Kwxw3L2TGxf0DverIC7TTZ4on9yo4GlE9rrKurWaTTJGL7o7uNvE0B2rg7FIFkIUK7clpDT7kH6tigI71MuGoXfv2dYQL6FZEaNezUycPaMmEXSMBzbYG1zLWDiyZQAiwCOBwmu315lSEZea3KT2nv88uFsJkdm1950Sn7ZAXg1A3QjDutm80Z8DWd8rJ1v1Rgug5tpe//5vf5PLKEEbI4yki7adcn3jFxEhT2lub7guTomf8D681n3Ts79A8vMS4KMs861a/JXNtq80o9vl9KK2GXE1YzwacxsbjciOZoUkiOmjvHlvpyczRC6ltqQrq/7yL0G9n5IZjapGhIZ02/9msz2r+XIIfia6tCx7GcYybjU+gnsJiPqryFemBFsjzOAQwgGrkqz9r1616NiFhuxmeN+BUpr5MdjgmeshsYmDbgI5wNcOxofYqvXyLd2PibqjjXGwVjsmAtWIO5Cmo81ZO9BFNFcrJ4lXmCyJtRcKzWruFLoyLNngRoy2jzY4gEZmSPspVywjWSEudrVk1vfHIbSbj0R4rsAAfeQgOTwKLp1qrSk2YDRu+nRA9KEW0AsMN6nwTcBDDYfp9utJlG4/HQ3wtc8WxuJibMPXPIP6C84Ff1NRUShp/xBm/uC1LtGSGhrTpo3OIpygXoq84LVbAAohXNwgHY6/Ijj+pwOpUFDo71g6EHiT39vbu97xy4WyctirbkCREe5LxBUEEsOkBdUONohva/woiAQcFTR8a+wWgaRljhe7G/6glDchS2TT4pKU5RyY
 hMjAOwFW
 q8AddkYNoSB36l0rsMjlXLcb9Cb8JwKp/wI4GOPhuHefrfdY2VupHcIZE2QpUqHmct/8HIbkkoZy9tLVS59xTI9fpXZSK9nlQ64iSsrPn05GiQbE50PhALnIhxezCAndwgBw38kIwzYxjrcouZENFhmc3+7rX9eETFKpz0EOASgvBU9nRpEco8vc7w8qvw+iPp77s9VsJJ3jd1d7G78cCo3JatTDP3LyQJEyzWs/oBPDTg7c+nWx8mSuEhNWxZuTk/A0CYec7u1Au2pe8wa5gBIHj9WoY4y2c3FZp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we have a helper called set_ptes() which is used to set
consecutive present ptes in the pgtables. To do the same operation but
to set "consecutive" nonpresent (softleaf) ptes, add set_softleaf_ptes().

The softleaves which have a notion of consecutivity is swap softleaf,
and those grouped by softeaf_has_pfn(). The latter is trivial; future
code can convert present ptes pointing to the same large folio to
swap softleaves with consecutive offsets using this helper.

The other case is softleaf markers. They do not have a notion of a swap
offset or PFN, so future code can use set_softleaf_ptes() to store
multiple (same) markers on the ptes.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/internal.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index cfea888366d58..41cf8b9607e31 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -507,6 +507,39 @@ static inline pte_t pte_next_softleaf_offset(pte_t pte)
 	return pte_move_softleaf_offset(pte, 1);
 }
 
+/**
+ * set_softleaf_ptes - Set consecutive softleaf PTEs.
+ * @mm: Address space the PTEs belong to.
+ * @addr: Address of the first PTE.
+ * @ptep: Page table pointer for the first PTE.
+ * @pte: PTE to set for the first entry.
+ * @nr: Number of PTEs to set.
+ *
+ * Install @nr softleaf PTEs, advancing @pte when its softleaf entry
+ * represents consecutive offsets. Swap entries advance through swap offsets,
+ * PFN softleaf entries advance through PFNs (encoded by swap offset), and
+ * marker entries are repeated unchanged.
+ */
+static inline void set_softleaf_ptes(struct mm_struct *mm, unsigned long addr,
+		pte_t *ptep, pte_t pte, unsigned long nr)
+{
+	softleaf_t entry;
+	bool advance;
+
+	entry = softleaf_from_pte(pte);
+	advance = softleaf_is_swap(entry) || softleaf_has_pfn(entry);
+
+	for (;;) {
+		set_pte_at(mm, addr, ptep, pte);
+		if (--nr == 0)
+			break;
+		if (advance)
+			pte = pte_next_softleaf_offset(pte);
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+}
+
 /**
  * swap_pte_batch - detect a PTE batch for a set of contiguous swap entries
  * @start_ptep: Page table pointer for the first entry.
-- 
2.43.0


