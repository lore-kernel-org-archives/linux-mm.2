Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B734606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dcgzic/K
Received: by kanga.kvack.org (Postfix)
	id 769A66B05BE; Mon, 23 Nov 2026 00:36:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3966B05BF; Mon, 23 Nov 2026 00:36:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BEFF6B05C0; Mon, 23 Nov 2026 00:36:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1936B05BE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:36:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E2691207CF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:43 +0000 (UTC)
X-FDA: 85465274286.10.7CF23CE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 63C021C0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="dcgzic/K";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412201;
	b=XjUPSJRcP2Nq2hO0qkEN1zsWqT520DajYrQmrXb1fCeKwFEGwiKz+0taTj6Al/MA+m/Wr/
	Px+gcw1lDb8qBaaHSa2vf6OcKashqgyCSWyUfNG28mOF3zGqoiyhK1+l90r0/d1YvDuWxp
	T4cjKGQtWkQTH/eF4f48UNbwYBqslAw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUjYvdoIb968vY0QthHbYQXechaclxheH3yCYvSZ0ZQ=;
	b=obk1m83XO15M/uwOn1jmKEFxJU54uXb4mnxLdOKxU+CCZXvn8APiDE0giULZIF6jx79ayY
	5x0chEBDa7Uk6CpgK+pZYDVS0eFt+AUqtaGVidQka9+CNG5YssqWuS+kubB1Pup49RdkZT
	LqSUsvssH9YQBfjuh18hdquUMEm6Rpc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="dcgzic/K";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A73EF1476;
	Sun, 22 Nov 2026 21:36:37 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DA5BD3F632;
	Sun, 22 Nov 2026 21:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795412200; bh=IBmvKWvz4Pi5PFNU3QrM0to99E0OH0aenhAz6i1fbPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcgzic/KSqzBNVLwj+WXmqT3Z8ztMdmhbYbzUhdz2qgfATnBfQH3iJhcNOqyuqjcD
	 Le3/65UjJWwgkFkdx2VtwyJmTi93PfVslj93qC1xWYj1qL/kwbsImfpw5iaR4/O0gD
	 V76DikuQv9l4HTqZ5bwnzMlVJOf/rszY65VeSsYw=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
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
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v5 6/8] mm/internal: add set_softleaf_ptes
Date: Mon, 23 Nov 2026 05:35:40 +0000
Message-ID: <20261123053543.295467-7-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123053543.295467-1-dev.jain@arm.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63C021C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: tj44s4ug66fz3xj7ywecw1mqf55ju98t
X-HE-Tag: 1795412201-872137
X-HE-Meta: U2FsdGVkX18uIx3NrEciQ/QzG6MbMKUSKYBx7b2O7+rRWnVfSxJbU4efa5NF3KqBPymQKqzCnHpts2G0stgyvVrrU2UAt8Wadf2zJvnDZoE3lRS23W4S0WsvmKRgUWF0nRXrRRC41RaQi3OS8uwL2JXp/57Ush+B5pQ1aFpCu78PLt+egUleOE9q5iIQD1GHZ+jn4UPJ4xxQXl5SWQ5demx0zOOuVWKOGWBUUl0DU0HCJ9Dsjic1xn9zZTgTkp32RZSXCoFYmiAMqi6Kfts6cyh5pRpWDlk3NxAJR/dTJHf8fD9kNT7yIOhY23F04dD5FsNHBbA0mjOeW3NT3daT0b/9Hlh9bltwSQS/W++vmIZEEBYcW6pmrN6T0kslAd8auu/FP9xi1xrQoF3NMmqLa+2q9jGMDmrXe5TNprBOEAaCr+m00t9l439TYCoQ+FR7Ssa8P947XW+gT3y4z7yb8f/kKX+M7/FDMNliTtAEAY42ZBZ04CWVtfagJ5NZC6wKM/qw9ZCeXYbaAg05v9RIqESProhGwcnQiTLA3bhxeCNPTw+e4syu9YyZc4EdiTbeOGsLoxfZdAQ7PZIxdpSM6m8qefP7snj+bhhq+r6fHi9QhG9hxn5Cw8lBV7uOBNQKHrpcwtqDQ7+UdW5XJR7yCbKr3K1TDKXWr4m61Rv5vqMwKzUi+JWwZZx7YbvLeEJhCU2FcbZsU74Wrj7MFp890M69haM0bX/OFmpPq4yK0qyMazFIC+LqlnP+rCVC8YtMNlk5FMzVkFsNOqGGdW8CEy8wAFSrppYJRKg9mQu28HpcZUn9kwpS441uj7IL02Sdn4gfgXRZSk+ci171JBSrjBkGYDbq6NWl7hAlfA9kzi0VPuRdGj9co/H4/HVwuUvNKm4sLhCKxe0FUCFIyheAljMensJzTCbKiEpRZ52/MsW8u72YyxjlAUjZ/b0t3Vv278Tz/zU8ETL22n9fFSc
 uzyAMYyY
 R4iGkFysuJgjFTVNVTaFkTlOOekz0zWdFbpUUhfaGNh44G4CMmD21PmoRnXajDoS8R6QNX9fbGWCUBdEZMm+DI1MRZOqGQhoo6XOOo87XvslkePygK3KXimpPsO4ST6iqiJs/k+fMNdOOQBjpQY+VJGkHWmRrrw5ImkVfSkZaQyGbgsNOtMxnwXlyUgXYyPPQjn5siZ6kOkyqmubWKXkKMavsmX7f76GYJy6OTiIBw9gJRbUZ+lm9T7j/J/ujW0VSjqC6qPtGI0hW2vxl0P6ANJ4a6YiNAaFu2KEuHnu2dWD+xYMxkuZF78eWag2d8oZ1zo25ILBfien0cVHEc3KKPjo29NLF51G0/k7TybutPd1F9V6YO+W3BskXV5ypHIVYL+h0bIhsd6zpkQ9GqtoJESVD0cb4qsHqIkbk4rKOK5AEmtUU7NJqlZl3PKH19Uuuo/eW+xgTWXbzs2Aat4HL9180KQ==
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
index ae0c37ee3406..e72f9571617b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -519,6 +519,39 @@ static inline pte_t pte_next_softleaf_offset(pte_t pte)
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


