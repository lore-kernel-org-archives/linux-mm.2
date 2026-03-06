Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD2CF5140A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 06:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B0F6B0093; Fri,  6 Mar 2026 01:44:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702E06B0096; Fri,  6 Mar 2026 01:44:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5072A6B0093; Fri,  6 Mar 2026 01:44:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DE4B6B0093
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:44:14 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2A96140447
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:13 +0000 (UTC)
X-FDA: 84514698786.03.003730A
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf14.hostedemail.com (Postfix) with ESMTP id CDB6510000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dyfGYWBw;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772779452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z89VjCPOsBTAMzdOkBmmkyGLdD2D9prjOEPgmVbdWLg=;
	b=bEM+lI8TuO3Hd7MWHKCEJESf+gmf3Rn0GnVmheRq3GuoKU8uipmGR/6nj22jwku5cUzc58
	KFKO0V7OUEBTrT8ooULaPPW+m4tKEOgU09cmPHwG2FNEQU/ZjfKq4erqgOQoYVSJbxn5uv
	9lSBJbIJfSAq63PCWIQrPUMmmuhkn/k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772779452; a=rsa-sha256;
	cv=none;
	b=44h7ll8CFI8016XNGbUGq5ZEGbSMvDnfY2WsxgK6Qkz87zRM1Jlz8d9K6kNMvW4j9D3muR
	QC/u//bha3i6/aLQ6vS5Vb9g+uf+CY4zVSZuhOucVq4mE4PwRFSKgnhwcpSQ8JFMhclHvt
	nwa1f2rbgi3SvRICxrqJc5BIqjGBUHo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dyfGYWBw;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772779448; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Z89VjCPOsBTAMzdOkBmmkyGLdD2D9prjOEPgmVbdWLg=;
	b=dyfGYWBwyoyZtwUZ4U2cLl5qD9OtWSqwQBBO21hiA+9bw9yPdi4O1xLbI1E3pyA+9yXN80nbU6+qjJVJRBOljs6eCkfbuEefIfzlomYpc/Itpbi1Gqd4RBsCQxbTxSgeW7CfEBstJokKp8exak0U2YbRVeTgEg8AcnZMQdIE0uk=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-MLT6U_1772779446 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Mar 2026 14:44:07 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/6] arm64: mm: implement the architecture-specific test_and_clear_young_ptes()
Date: Fri,  6 Mar 2026 14:43:42 +0800
Message-ID: <7f891d42a720cc2e57862f3b79e4f774404f313c.1772778858.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xxt1a4id74pokwcp374mtotxsidwbazo
X-Rspam-User: 
X-Rspamd-Queue-Id: CDB6510000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1772779451-677881
X-HE-Meta: U2FsdGVkX18ut1GlK8XBjWdVWfQmsFqqHc3ICjwZ8l+8TYlgSWHaYlHsnidhFe673B0rX+jNdaQuvM65nilQKSZvyCkaiG3wTNBI6C14ykayhM8WPzWKfDvw852PCCvsiIjIEL6fV5C9opGpOhI9+t9xTbKTxfjkunZOljNAX7xPKTQzouFrYGUlXh0X5aw8ah8RWFwb0Dxudpk/8LOFy4EMeMaBH3tPbBHRbW2vBnbhji35D5L0riITzAwARp6fqYrgTyo0wLoTDgivghqNXTNUDmLXsrHOj1s4aorhZYC3KZ+Mex41zA7KKGLVVZqMRIz6G7DqV9NjG3j482QFnbwmlWs97yzCC3tyrHGONVCYwo6adLkCvDqZI5RamXYqSSOgBp33kxJHPRLgD+aK6vT4T22uGzRVWlgbvmbZLxscIVG396M9tibZUF6VQxHofGDUUIGIA2HvM1esq1dfCMNcGL/DCUx7+9++a/hNlUZXRn4o6jRvmfnwlxBgFRbg+FkkBNVuo1Hohs57EMa76VvMJ++83fRJk0MQtKBeUssj5cL5I9w0/IiY2TnBLp8NHdNE111uZ4EhatyyCNXWItjZPEh2Fg/VPi3nFZCaDENl0lwZUwXDclNfHfs7xHfU6XjWUx7iyeXwLmRYxoPo8IF+4OEYJJeXsl/GqkEAfVIC1QATOolMQj719gbOjqhx9cT/Mot8bZvvY+16WXMUE9z2xLS/4q9tYaYzLa0rJm+qlR32qWyJEE5ojcXCRph/OqJQRaEUfV+J8dASwGpRRM4rBgO9Knx4iXdNgXtXJ8zFW50856tAyeoeqJfg27BkG2DlSDs0t5Fzj59Re2RY6iZ/gfWZIyO1UY343qOaUdtc88KsHECp6uhVoSLsj8YeaIR08iP7Yve6R7Ylzzkv5xMsBJsnQeeqJGQ8/Xk3LxjVHHP6YLTTxHutO9IawEermx3sbyjZgTRqbrJcG5y
 F+sRi9j1
 9hkMPuJTlw1GPaGRs2iDIPAv2TGRVOLJuscvjjzTHKNuFVs4nuOpmDEL/Anl/cAWtz4/7dmEdWAcLPe7XyqugbvTMAaN52sgkgxn6oi6kQ9YLs5+RZ/ndslZsD5OkKXEPrjX9oWQGDU3hHKmVMP5MUbr+mrACULrqnxClytfSfu08Wb9wt8MhTtPwAaa1sszBj4fHGagVbwauWelNIyTSJxuZA9UwLX8lrumlswCpp6Lc8x89IzqTJv3TJFZl9po0HbsyG8GspuhPOTtZNccShAopsLY/kWhFKN4CW5Et7pYZWfWyAnfgmS3VJs08FWH0/0RNG33fxzEOc26wWzMOXzCQf5yz74NsbXqnzt20LI2c0eI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the Arm64 architecture-specific test_and_clear_young_ptes() to enable
batched checking of young flags, improving performance during large folio
reclamation when MGLRU is enabled.

While we're at it, simplify ptep_test_and_clear_young() by calling
test_and_clear_young_ptes(). Since callers guarantee that PTEs are present
before calling these functions, we can use pte_cont() to check the CONT_PTE
flag instead of pte_valid_cont().

Performance testing:
Enable MGLRU, then allocate 10G clean file-backed folios by mmap() in a memory
cgroup, and try to reclaim 8G file-backed folios via the memory.reclaim interface.
I can observe 60%+ performance improvement on my Arm64 32-core server (and about
15% improvement on my X86 machine).

W/o patchset:
real	0m0.470s
user	0m0.000s
sys	0m0.470s

W/ patchset:
real	0m0.180s
user	0m0.001s
sys	0m0.179s

Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/include/asm/pgtable.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index aa4b13da6371..ab451d20e4c5 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1812,16 +1812,22 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	return __ptep_get_and_clear(mm, addr, ptep);
 }
 
+#define test_and_clear_young_ptes test_and_clear_young_ptes
+static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep,
+					    unsigned int nr)
+{
+	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
+		return __ptep_test_and_clear_young(vma, addr, ptep);
+
+	return contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
+}
+
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep)
 {
-	pte_t orig_pte = __ptep_get(ptep);
-
-	if (likely(!pte_valid_cont(orig_pte)))
-		return __ptep_test_and_clear_young(vma, addr, ptep);
-
-	return contpte_test_and_clear_young_ptes(vma, addr, ptep, 1);
+	return test_and_clear_young_ptes(vma, addr, ptep, 1);
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-- 
2.47.3


