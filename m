Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BADFA606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GZYfrw51
Received: by kanga.kvack.org (Postfix)
	id D47B76B05BE; Sun, 15 Nov 2026 09:40:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F3E6B05BF; Sun, 15 Nov 2026 09:40:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D156B05C0; Sun, 15 Nov 2026 09:40:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A517F6B05BE
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:40:12 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32D52160775
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:40:12 +0000 (UTC)
X-FDA: 85437613464.17.C4E4E26
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6BC4320005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:40:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GZYfrw51;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794753610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJ6uaivQ8BwLLrJ0jFx1dkl7pROSrcgg9xW8jLyRpLQ=;
	b=CO24rtTkjIf82N/x1p92abIpOG7TopUMee5ajrjWiBaTm8nblpu7zFpKFq2NCweimKU4B4
	jZiW3dzGO7DxxckPkjYYTdq/xSKB6vbArVbk9VDqKaOiDzMlchJ4feIUZ5VR8nURvYJUot
	s4wU8ZstnCwHabVNylCl7d+qGZCGLrc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794753610;
	b=Vyk/LZj3YJW9jB5UTFjZNPM7TxQUqk513H8vPPiWZVQzOFsSPH4X047qnSZv+Oz0rd972q
	fNTs0JttC4MYfL3VbArG3o4/8XiHAAQ4BoBVqAlgIDWn7AeL2DWpA5O5ctAvIyJdKrVD2C
	ZjJ9y6j/Ej/7NF6e7LW5VwlFpG19KbU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GZYfrw51;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B9321476;
	Sun, 15 Nov 2026 06:40:06 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C89E13F85F;
	Sun, 15 Nov 2026 06:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794753609; bh=pLgKf4mawFqqvvE6RCmjujIRPi4np4jf4M8uyT2QPys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZYfrw51urDn166LlLx+/pYfMV08jB7U+8n3cqNCRyna+srdZI7M8UD1BkjM4jBP1
	 4AqDTGF7839HkxoPfKxgkcgxEzn0joIGu2JpiYhSoDR9EGjFQm8D8z5inkacRLK/pn
	 So1uiume8SR5ut3NLofJIy6gCEcViN5twc1FFnEs=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
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
	anshuman.khandual@arm.com,
	geert@linux-m68k.org,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v4 6/9] mm/internal: add set_softleaf_ptes
Date: Sun, 15 Nov 2026 14:39:01 +0000
Message-ID: <20261115143905.3045084-7-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115143905.3045084-1-dev.jain@arm.com>
References: <20261115143905.3045084-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: kyu5jzet8s78kgnrihmug83itsy9ajnz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6BC4320005
X-Rspam-User: 
X-HE-Tag: 1794753610-873075
X-HE-Meta: U2FsdGVkX1+MyGM0qsC/PbQVrirfy+n5MYUlpWArLQ+Z/13IV98ddxokcafj3R+FnVJSwZ/B9gOMQ17NvgbMuD6tQ4GiQD81lkSolcgaVagxiznzAM6J2G+sDYGuFJWRBQd/8pJiv7Sgu2g7Rt6TJ1PahjE1f5Tpr4c9Vt1exRykMm+WHFHDy1CN/fvl/23LafP/bN9/J28PoX0JvPYnKLpJjmi8JRgajFNxLsVtgweT7DyLZdgsh4pTE9xFQ0ARhOxfyJ53byYA5SH+1kiMC01ciKDMOX0Qt3o2oAxhjkvmJ7O6QWv58feYKVZkhKatjeQufEEM+59Z8UlDK0fpO1XR9EV7pUqhmcFLG73TGPSKZZxmAgrmbPWdXFaJ9/tVw6XMTJ09nN9v7oB4kSiUQap9qVacTugCA9Ro45cdfNvyEKy/PlFhFNQk1t4sar10G63/mgZh6Vp6sR0lvNgyVHAKm7m7H/+u/QBVpvp74bkoqyRHva+TuWDULP0QIpNIpXIDJnyiVy8dS0dXoebiYk2n5PXAfF79x8JroSz1MDK4I1I7X6SpBK7k57t1NjyTqm6P6mwtpk9GdYJo6giewCaYovUjptSTypzM6Z4fLluzVbJofJtVW2xnTA2wTT452nxb1Qnzpbpqqj35eOI+LhBt8Ag7vpTXtc1BkeFTUxRCWHa9394nHjqVfsxY+wsg2CMd/WqAsXL+CBGQtTCOsHcrD1vCKriDAmYJWOFXMqFeXzxda/GPriyLJbY6vVbFAvbniGIu0uwnzQMaR57sdw454/zzLLuZlPae5J5GV8kDF7XK0J5VahOl7q2KafLFa6ywpcDpnaD6ar7SiQkmSfhhVC3oe1DcEaAVCqx/2LRx9IC9nj99EOfSFaOJMpv7gQ6PTw0emkSmy8RxudfRvMbBK9JxEKP8h/E8fX8nKpwDD6blLnhAaHiBzI5kjyHh6Q8lAzENLtQX7PYqRbU
 LvhEcB+f
 /qd1ReIYftAp4G7Tf5DPTorkU95gYBk6d0Dgl5pYwOGMLj8RAikO8Xz2m6GOUQzRJcv6iYYYgA6uqVC3KjR4CETQuH3Jyp/GwKxrSMt4GSg4yp3IKXttRHKkGyP0U+DidcaWJ2tIRkjpUaESAlMpkshf7DkUJfdBjeWkAvhRKBijQzCcYT/m3xuXxNjN433zFwWJPfeTevCdJyYIcKz1NircgkPN440gX7GrnH9kPKRnbq+p7dqKrhlEdej0S9xDqonVnyhroTaugunCFb/MAh1aQtILMjOjTYBeLKUqe/HR/waLmSdPas1CrEB7CjWAV585+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/internal.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index eaada62a86590..c7f330db6a2e5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -512,6 +512,39 @@ static inline pte_t pte_next_softleaf_offset(pte_t pte)
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


