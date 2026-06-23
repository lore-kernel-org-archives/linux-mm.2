Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DBA2CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 12:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F35F6B0092; Tue, 23 Jun 2026 08:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A48F6B0093; Tue, 23 Jun 2026 08:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0934B6B0095; Tue, 23 Jun 2026 08:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC7C16B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:57:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55BAD1C588E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:57:51 +0000 (UTC)
X-FDA: 84911179542.04.DE3F850
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 96EDA40008
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:57:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eJOOzQXm;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782219469;
	b=rn69ifdc3cvT3roA3c3Y/OCdmJ2qv2c+MwrqxZ/XToIaZDfdOWjSBMvEnuZxrff/i+sJ5n
	ZKGfpdZHeT4H84k7erW8sOJTwcD1iKn5fl9vS86rDCEOXOCX/TSvRnNfI0cG0DdR+tMfn0
	cJMqBL0JPj0+0xW2G/RtTcjGG6wshiQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782219469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9BoWW32ag7TMCt+JYJXiHEkQGRR8O0K68AY3rN/vgtE=;
	b=bUliE2u+dbsjYaekxWCAFKD0v6ZTSj+WFNjCzpy2fw/kdqSgikXV7XEJRQe7LKOIBCGJD0
	stdQaOwh+EmwbsHTaf4FJqmGK4K8SmGSjKAFyyU3/iTo9Wx1IefwO+NX6IUDQu0hQFwCJY
	vwNVwfIlI44dQ4AT2GsrwmNbL5LJ0AA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eJOOzQXm;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDBA61A25;
	Tue, 23 Jun 2026 05:57:43 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 847373F632;
	Tue, 23 Jun 2026 05:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782219468; bh=eMg9F/xqCrVT+AB0waVn//uqW7SETlXSJS0RCebrHew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJOOzQXmgJSLiT61SaG2LjLNZLUitWzRxA1muWKM2EZSCE1df8lSz2OlcmfAMzU0j
	 4lvgi0vA/p9GzX7OQfEWjgXikDCkEBFtEFFlDYWprEoGNukqOssZe0jDrPZZV93Dmu
	 ahRGPh8P/8+Jr+tfxIgZCraGbJVMKQ/9nLDfJYBc=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	liam@infradead.org,
	ljs@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org
Subject: [PATCH 2/2] mm/mprotect: drop 'sub' from batching context
Date: Tue, 23 Jun 2026 12:57:22 +0000
Message-ID: <20260623125723.2503832-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623125723.2503832-1-dev.jain@arm.com>
References: <20260623125723.2503832-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 96EDA40008
X-Stat-Signature: 1556is5dsfjtkad44ohhouu3qf6ftk1d
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782219469-575624
X-HE-Meta: U2FsdGVkX1+RRO6VOSPRf52L0luHESeQR+sroS7e/1RWGT7kXep4HUXuZLR0+nLjwCAROPnv2xgEksicHzov0rcd2TpnY0TTVls4zBD3aUtKWIAUp1wC7A6xTx+U/sw7jECUvn4O/jqj8ymJRQB3aRJMPlsKEji/Wau7YTQySy57/nc3NUxO0GZLwMAphl2D7uTV28U9s3UK3FR5o286+Mka8k6G4PbOfTIgKBDR977sv6QBdTiB+Rct0Jny3XrMz3zeYEmq2sT8AA44ebbaQ+acp4XOvZ65/oLBTdUAnXoenJ59xn4D/h7X2SMb3eyqZlX3WaG7+HjDrn3crTH0Bowh4L7HCb8hezZ4DTmRkA2knMvak4jh0xxVCXbHpTbpnZI/409eRt5c7Vt37d786jiZHiyqlJCKcMXalC8V8BvIdgyWFAf+BpIAAtEUMbVUvYxEGEhqsrT7zf8QKbeVRpQOBiZfqhr+0slqs+Mn8lqaXdj7H1exUnresbXuZtm0PkLNe33zimT/GR5JENCP3SXqP5SSwso//vW0h/2KMdsoYqy5naCdS2yuXiOm5rtu5/ICibMNgNSr4B88qjEnXToksTCLsaUvY8EW5kn0bR1DVW50p6P8Bjjfuukdfw1F/CxmJ52Lv02I0iAqgDa53LaWAnhuNRIMSkxNgxtBufr4oEf9As0i/YG/EtjKeGAyrja+FQ2QOi3R6LfvYGELu/K6pYPU+pfXJJYQhLirUYbgQ+pijUSkcfXIyrZ6Xmb8fbndC7Hhgh/oS6gdFWxbo0Rl947a0/DY/02yTIsyLk3AmcdMdUh82vm9/vWPYmY8iZFtxogY+n2OfF0CsLDWQPzf39z8nGPCFDhE4BgGsNPDJiRQX9ZUvuocwOOpprc2G/1SGkTlqS9AV/QqKAmvGjO7Dorm9sRzL1f6KvzZUnP4Ht6FPGBEXm29GrDqjNa1v4yD1xONZqgxdabL5lk
 grf+6b/r
 0VRGeC0nrwJviFplQwN8DZYA+tDAUTHPrakSH+g+lnfrqpEH+G/Zacfr6v/SO7CvjZ9QxMI/Zt1tUVUKEEv/8tB03oXELvRDW52swPOJnyVCqffLzZ2nt3PETk7jvqzaqH+Rp35qdhTLBIGhuDS/7jPVZEEowCax4Js1ciL7zRKK9rzK5cqPkRk0XCpzLcCJVOVr4V1mo3I/tgehfqNZ4fQvMYDnLQOUBDkuXAsJSCiP5nhSWDqTY28GbYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shorten the name of page_anon_exclusive_sub_batch by dropping the
"sub-batch" context - the function itself doesn't need this context.
Similarly, drop "sub" from sub_batch_idx, it is unnecessary and the
usage is clear enough.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/mprotect.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9cbf932b028cf..c0f5ab74bee23 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -143,7 +143,7 @@ static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
  * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
  * that the ptes point to consecutive pages of the same anon large folio.
  */
-static __always_inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
+static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
 		struct page *first_page, bool expected_anon_exclusive)
 {
 	int idx;
@@ -174,16 +174,16 @@ static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
 	bool expected_anon_exclusive;
-	int sub_batch_idx = 0;
+	int batch_idx = 0;
 	int len;
 
 	while (nr_ptes) {
-		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
-		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
+		expected_anon_exclusive = PageAnonExclusive(first_page + batch_idx);
+		len = page_anon_exclusive_batch(batch_idx, nr_ptes,
 					first_page, expected_anon_exclusive);
 		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
-				       sub_batch_idx, expected_anon_exclusive, tlb);
-		sub_batch_idx += len;
+				       batch_idx, expected_anon_exclusive, tlb);
+		batch_idx += len;
 		nr_ptes -= len;
 	}
 }
-- 
2.43.0


