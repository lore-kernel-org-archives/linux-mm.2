Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B44D1C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 13:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61F66B0099; Thu, 24 Sep 2026 09:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A416B009B; Thu, 24 Sep 2026 09:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4FDB6B009D; Thu, 24 Sep 2026 09:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8810D6B0099
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:12:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D83280200
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:12:16 +0000 (UTC)
X-FDA: 85248694272.22.902D425
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6E0CCA0004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:12:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XGt0CeCZ;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790255534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYb57EjGmrAjRTv0wPln83hYJ0U6JaIwjdkM/PwUg9w=;
	b=wJaUcKcBf32RoP+LJqAHJY/Ja8bCJsqb7O0osyvHzCD0vAacDbzRP8T4Jj9O9lZW85u4Xl
	E/Kl5HfMWTtjyhLOILAR9g2Q3OT/qpkE3zO4Ai7aZbkHwJsSktQCiBniNAT6o4IKMm/jFu
	ELGm9IIGv4JQJjkrJCTygOP1ZljDtq0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790255534;
	b=nxdAfrM0gn7+vew/Emx+HFFyqqm3CSJGu7K5eKmVxD7tPptkO2+Afywm3rmbgiotLFYmwc
	pv07b0ZkV0PRWlXKZGtay4+BlFYV0wibtoy0tf97YtWEOuM7ldI7djo8+0JQl8hklH6o8M
	Kg21P1oiZwVYURR9TdSqvYo5V+9GxnY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XGt0CeCZ;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30BFB1BCB;
	Thu, 24 Sep 2026 06:12:10 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 906783F86F;
	Thu, 24 Sep 2026 06:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790255533; bh=SdgJCddjPp7/Mvalka61vw2zQLeW42ALZN0qZGzm4do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGt0CeCZXa84341ORqXF1Qk53S9zQuTR0fAfx2PSczJ/Sfzz5uIjthi3J94axjDk6
	 GMjtt4emAlgBb0XiCPUbJwHR3xR6FaetJXSRzB8mtYD19DrZkM312UGHrqy+hykZYb
	 +2EeSHa7InZYwv+F6wTirMo5P72UNRg18QhSkUu4=
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
Subject: [PATCH v3 6/9] mm/internal: add set_softleaf_ptes
Date: Thu, 24 Sep 2026 13:09:34 +0000
Message-ID: <20260924131106.1730494-7-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924131106.1730494-1-dev.jain@arm.com>
References: <20260924131106.1730494-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jwysexoqnohhwxext1p97ogpiobsg1op
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6E0CCA0004
X-HE-Tag: 1790255534-435317
X-HE-Meta: U2FsdGVkX1/DhPt9uTO/a0D0fB0aL7xhrgZW4qyB/iLzO4P8tdu6mH6Bv6HIyercrH9LGHTCprrEn/aQCaVmNoJHu8NOeVGGXvY2AFiEqGQ/U9dqctmWyfvMXm//OGOMZDjPOLo7eL3o10koprRHpjSTfhX+z/7zs2LbrBT20m0utFsLdFm52YBA31ZXfvjJXy/ouLlQducS6VdCsVdSyO7doR1x4uTRDH9L86hlaaN9ZtgWc6dYQXmH80oxTmpKfcfdyy1AyJYYvBdku/cmnB9RiJm1YRKwZL83LQRgDQYZ4B0yFjVdOLSLTYKXFiFSPrFRU7UB07yVT2l++m6J9crTy5e2bb5U7LDvjcH88I8/Cg6LTmuBs2RkPe6gcfFji8Ba4FsxfC8l2ioEHRZAvLkyCl74MhAnGPUBbSAmsEduOkWU94l2APa3vfag5c4MI2QOPgmlSIq+PgiKtdtZ1UdgOnEN1mVCWEI5da2YiGlFuDvGCayxT4Nl5fBMtmEinYlvdcY+v+5IVRNwylGr9gS7z96rSY48nYeCztu4cmzVwPKgalJYFKRMTTitD7Krtl/Dz822RyonraNOpb8W0p7lf+Esrt0E0kPsrnlg5rfaT2MTqLy0pdnfHpwrg1W8D0u1H4UEHVfAvU2iYZ51AW8z6YSZT7S/KF/tAJVNlAt6u0rM0oROry4QRtrtosdWJ3XlZ2pkyw7YDRKqRbbDrPA1R91DsgegPXmOeY7y0sdZjErKa/e0jOcRTpn9KaOz7umRcPIfcsZQa7N54v9jw1ychDexqr7gVZrCjkadpZwjCARHN5maHTZ8lrvtUu/TidGit9b1/CNje41oBv3JnCI6uQzeGBXTYi0xVFSLrogxSB1TktUHjJS0ZmI52AABwbwyDwUrBMyek6VRiZgbDq30TkJZvS8CYogUfT5IomQvoU9UuAb5/XRrPQFHF8eS1Hf6ZbNd9ByubBPyqd5
 5l1nET0d
 OhgKkamUpmuS9buCYKpYi929OqBcBMWxqAILFFQAr+lfwpVCUj4gCTA3efdcnZ6j1UACgxH3pMtgDBVSsize5KyYb0mfgAPbq8ZGBXycBKSY0n3QEGlj2DInoE/LUEiI5EWogLFH6g1924dWBvZ7wSqucjP3PQZT3Vzis5u+mEeathzDL1MltxwuI4/52FQuwyqhedhvapVxv4Eoo/u4vP6tb8VkgtwoPptGKU6mnC5Kz7tULJ30Juvixunw+C1IlSOT+DvEJuLnT9qEylBkyXT2MoxKgvIqst5Ap8QEEq3vNakDqLyiONsP+KDWQwUsDXT7I
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

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/internal.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index b8ec379b90bb0..0ffc9565c3273 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -508,6 +508,39 @@ static inline pte_t pte_next_softleaf_offset(pte_t pte)
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


