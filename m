Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF2ECC98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 13:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175816B0092; Thu, 24 Sep 2026 09:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D356B0093; Thu, 24 Sep 2026 09:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062D36B0095; Thu, 24 Sep 2026 09:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D84CF6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:11:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78BE51A0357
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:11:50 +0000 (UTC)
X-FDA: 85248693180.10.296922E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id B7037160007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:11:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="XWlR09P/";
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790255508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4AejWdLT11tQG77hkj0RJL8pHjy9KTSxYvvZ2nvOy3w=;
	b=0o8RfB882Zrxrl8dcMq86NP8ENvawJ/zEtyEnMBCnX1jhEIRSvvIVPg5+01+ksLqLLwJZm
	4e9ijI5WbFA0lcSrjw4irZl5Vxhat3iWoVQCTFwi7GH/itl+YNZFG/6xdCw7R+J0UXJRiK
	q7DgF/6ZmbsptLj/XijdmJWznZHbyj4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="XWlR09P/";
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790255508;
	b=AWb/dj2ljQs3YRUkRJGE6XREr4kyTPEtH/au+v50ktBK4JvK9xUsaWJAXtbWWgI/ikuIGz
	i30HVPw298phcYz5RWlFbGBmqcRT5l6CQJ9fDa3zCtMBfRQqDJEqeWo+zuq/Ly+UP3T1n6
	0DCRbd2DMQnxWX65+dwKsP+WqaMeQ94=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38E9B175D;
	Thu, 24 Sep 2026 06:11:44 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 92ADC3F86F;
	Thu, 24 Sep 2026 06:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790255507; bh=t0y4o1rliThr4hhOhNaBbuyJQwol8ZLmJ5nvLciVyts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWlR09P/WJPRcS6Dm9gpe+RbtWMIfPap7pd5WOSclV/6JI/76RijBjK25b3/9uKqd
	 fTLOU5ZWceR9RaKhVrIRYgPg2Z4GkwSYS1zpwFKBMdP5WMLd9dpuwm5sR5qxxqp4gz
	 x06F0kOnPKOd/0/Qsdd9EwEk5xAb65psn5+oPEj0=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
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
	jgg@ziepe.ca,
	thuth@redhat.com,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 3/9] mm: move anon-exclusive batch helper to rmap.h
Date: Thu, 24 Sep 2026 13:09:31 +0000
Message-ID: <20260924131106.1730494-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924131106.1730494-1-dev.jain@arm.com>
References: <20260924131106.1730494-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B7037160007
X-Stat-Signature: 7c3mkhxoocjyc13uk1pz3kd5n7bfhcdc
X-Rspam-User: 
X-HE-Tag: 1790255508-490648
X-HE-Meta: U2FsdGVkX18NbaXeSwL7VAlZBDqFCQSCO8sdZcRuyHn9WmIpOOatNrhOg3ychrlA4Eo0RY4hplrQ4I6mp23Wvn8C6uISWsITmqkZXmKC1eFTUzq/e5sZzs1bV6qvv+Ah0YLP37Te7cF8fPODwvINYY1+Gh8DMYAU7FpH9l+eZMIZYVY8R7i8Le4ycIVhVEqjWSxCEZUTu5Gextj/5MJKhS28sCHj/m006zoC8Abn2NTiuCik+xwPwQj7rD+cP5kusUGSL82fobDQ4AHoHxsQCMEHIip/lM12DNybwoGbl+q1SX9dBpUDvL/dvk9q8ihTMuo3R1R9v2cRXNIbHwprRQw0VWjBcp9bkFGFBy9qu1+vKgAAcBERD0bMLDulydi5AjYnRscREK0qDZY1de+s7ByXvKS3cWGeasqbWDpUeAh8RRySA9Y1vHAciTPOq8Z+Yv8UPT0dsQLFKdNp56N8Ox+z2HpZzj7XYLTW909DzHMXVEBlzmOC9S40RjLoJMJxLAGARQk1wAkOmoP7olU8cQcvqaTWhhsNDlEPIjCx6gVf+t25A18UvnPuWWDiZl3DMJS4AfRp0g4ePT9DrSuan6hQOZEDtegF/KzIGF2f9tV9mkYnS/Jd5pDB2FsTlvCiS9ggCPbxHtiQ5ftowLYcdT2apKuZ1PEtGH20AWuIicE6xRnOO0ySqOneK8Q6sHAW4hNZ0ChAR3F08LIy3m502pvZdfgoanBB9T1n+JkT7i3tqMaA7w4MGqlbgmHhV8SsqKkZuIKLebb6MM3mjzLFGhxqWT19vCeTTCP1pAGtp/5ZgLUCKEYwFhNY6RJ20O2+WIzy2c6GCw83xbv/+FFutDnx9lI8ielZeOo5/bVtfhC4lldqclYmXBLVEigzkRYKuVZTj6MdH16ZWG7hnBXyfJRDaPOVECSXsoBePE3XlkkLKn/RcdUP8CD2lcVqh5MIu7UG0g/RM4qtxoyZbj9
 IfkigRvE
 QQzdfxVvVb6xTR4133/gdJCgF/R8nZKYEGGU+ZOCichcyrGN0f0e46I+XVViM4NwcUaCuRM0lkace5/ShSygzKHok9PcqKkJNaWZrV2YMKlYwSjNVYYbckZWcWDpAYAbF0b0M6n8VvIUbm+KCJWWV6S3JquMzCkVsKocButcO9tH6TOh6qzQYvnW9K5p6tOosG2TALG48X4AFytNgfdiwmCIiCsvSO8ESaZlDq++A1YK2NIGIhBqgpHK2HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for optimizing large folio unmapping, we need to reuse
the page_anon_exclusive_batch helper in rmap.c and rmap.h and obey the
existing use in mprotect.c .

Therefore, move it from mprotect.c to rmap.h.

While at it, change return type, start_idx and max_len to unsigned long
type for future proofing against THP support at >= PUD level. Also
shorten expected_anon_exclusive -> anon_exclusive.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/rmap.h | 17 +++++++++++++++++
 mm/mprotect.c        | 18 +-----------------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 74cca0e3c7264..62ef511a6175a 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -106,6 +106,23 @@ enum ttu_flags {
 
 #ifdef CONFIG_MMU
 
+/*
+ * Get max length of consecutive PTEs pointing to PageAnonExclusive() pages or
+ * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
+ * that the PTEs point to consecutive pages of the same anon large folio.
+ */
+static __always_inline unsigned long page_anon_exclusive_batch(unsigned long start_idx,
+		unsigned long max_len, struct page *first_page, bool anon_exclusive)
+{
+	unsigned long idx;
+
+	for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
+		if (anon_exclusive != PageAnonExclusive(first_page + idx))
+			break;
+	}
+	return idx - start_idx;
+}
+
 void anon_vma_init(void);	/* create anon_vma_cachep */
 
 #ifdef CONFIG_MM_ID
diff --git a/mm/mprotect.c b/mm/mprotect.c
index a1b6d29bf0390..cb996dbd0e525 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -30,6 +30,7 @@
 #include <linux/mm_inline.h>
 #include <linux/pgtable.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/rmap.h>
 #include <uapi/linux/mman.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
@@ -138,23 +139,6 @@ static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
 		tlb_flush_pte_range(tlb, addr, nr_ptes * PAGE_SIZE);
 }
 
-/*
- * Get max length of consecutive ptes pointing to PageAnonExclusive() pages or
- * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
- * that the ptes point to consecutive pages of the same anon large folio.
- */
-static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
-		struct page *first_page, bool expected_anon_exclusive)
-{
-	int idx;
-
-	for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
-		if (expected_anon_exclusive != PageAnonExclusive(first_page + idx))
-			break;
-	}
-	return idx - start_idx;
-}
-
 /*
  * This function is a result of trying our very best to retain the
  * "avoid the write-fault handler" optimization. In can_change_pte_writable(),
-- 
2.43.0


