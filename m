Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9693DC5DF7F
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71BA6B08B0; Tue, 18 Aug 2026 00:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B229B6B08B4; Tue, 18 Aug 2026 00:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12386B08B6; Tue, 18 Aug 2026 00:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7296B08B0
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:00:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7A941A0AAF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:00:51 +0000 (UTC)
X-FDA: 85113039102.17.5D9A25A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id B550F80005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:00:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Nm9wKCIr;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787025650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JBldtpHBDgaNn5UCzD5QqxCVKi38f4fFGgLWcwhAWyo=;
	b=ZKSM/Hjb3ahA24eXSwnmBvo7jwYgmJk4Lcr5RcrmjjM/rt5QLvkHm9gQFj00gRB4zAE/19
	0tEEfMvrpYt5sOyccjFSnR660Ry8eG0DxDTu0r6Kx/fgx3rWM7Xlz6sQ1zxHHIcLae21Tw
	Rvyol+wTRB94u6gEs9pWBc70snYmwlA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787025650;
	b=ytbA8/ada8qjb3k2opuKqZt6BS8Ndke7yMfLlb9AEeeDKgaTsDjiwbjwOuxx6dLyRD1bGt
	eO686WRUczVnRwBGNN+9yGnnVkqL50LOc9z1COIW//cC/aZV49Ev4KeQYoU4B0+nqGmGz1
	Av/3vBpUqf/IzdDMHdQu7iRENPBygZw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Nm9wKCIr;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6A7D1713;
	Mon, 17 Aug 2026 21:00:44 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09A313F66F;
	Mon, 17 Aug 2026 21:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787025648; bh=ttb24YxqPfvdlZDv4/6sPaZz7dp5RDI+R8A7FcbdkQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nm9wKCIrKirdGI7EsjFmNpzvktBxen3s+Y8bQddcn8JS5ntzJoAry+6wo+3u4vhyn
	 M7CRYhYAvk1FZnrpGWYeR2L9tvn1Sn/4mF9BXA7BiP3Pw3dmPL/RpL6VcCsRFudXyN
	 14LSMlFlRUiV28bQxOW5lFnD7s8QFTIgvbWS0vko=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [RFC V3 1/8] mm: Make ptrval_to_str() generally available
Date: Tue, 18 Aug 2026 09:30:34 +0530
Message-ID: <20260818040041.1891769-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818040041.1891769-1-anshuman.khandual@arm.com>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fxzwkqa3pnrknjahpwaowub11m3q1z73
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B550F80005
X-HE-Tag: 1787025649-767579
X-HE-Meta: U2FsdGVkX18Kk+cq4JqLAWpVm/fjkxzXsLCrFUfHSvjx89++uxoskDe5lGzbOEQKsU3EpAvx2uhf3M+C0O0rKyWIvtwZG3JA1lOd3G+Z1FdFIdcybG8zh68gZeoT3469hb364p/pS1qIj7YJCNi9QDtZVVFy0ob5s47gVVFkpcwgIhrFUNszPkuE1Gk24HyuSj63KQfPs1Vkhj+o30s2RHbvmQr0KpftbXxaIFlX6hve65su8Jgi+9pt0mbAoOx1BZuWrL7p0Jo7HPWdgN0fW2i90/XDCnZTXYAxNgIzgYas8vFMWJdSKm2pt51DguPViYyU+OY6E9eQDHpUxd+0m29zsnN1Szsn8zxb4VKNe4sp7NMXOR10zD+RWq+7NiOPomVH9O7I8trc4II/POuZ9G+iAPSakhyydllQ3GIqVIdbZKXZUKK2uLDu0309an/9a05qBcBCq8xMQMqiBku5boW25M8Y7PRNrNQQvqIMYbBT2eSP7HkpHddlHw4JZO8mT3kDqf8p16OAulp9wPzEbFCvclbOAeabycG1/DEqvyX57IoWk0uQ9duLxFqEkq+lrE8kbv/TAscEr+AXAjbHQ8HfA0oABVnEDQGiYsqzMp0omi/wx/OtpHugdEZ39T018Bl3NEul3EBiqR74r1tniD0SAfNK9An/Y1o7zuVgCwJl4aq5dAlYOQuKkzaLVFbeuj/xxpCyli5icli3GphOahZ4thWb7sK4PKXcvESy9YUd2Dvs2vpaYwJntadJ3UZFHWdlIPlR/6IoELDqhWhWhNqeC+Xh7OQPKemDFhMkfNO39Es9j4P9Tcl/TrHzp8MzUzrDCuoXo5vzg02g9Ujjf1f5YyiHWrzpX6oxNEnKA2HASCSj7/LN7r8gYSUlUxhHY83EGyJFQ4poyPUbg+92yEnOLAw3hHdeARsBsV7LMzTIZK/PUEReglkvqWK51HkxN6SPYnWUKqkkXK6SZu7
 BLHauLoP
 gYorC1DZXEszPO+k4jwL3AGDr13X24DxqbxtYUaIFsFunm3rSvfXqcLUsqeEMyvC6SxI+iOuAFfmmfGQ5BANcARFuN49ZNkgpUBFDGoVgGRSJidWavCvnPAhqkvb5eGA6NvrGN9XEIRKtZRe3HlplKYHMPlW9BTo87s/f9XZpyozglJ33DXkXs7IO74iTbXUUxWLVUWqZ+vDdU4NvSUHtZoQDEGYcBgQmtE+CHS95+yzMNAjn0BVf/KdFE8HlgXekhxipKwMI3eE9PV5U2RScZ2V299OWFlf63/VcBvaKvAmH0PXwSMNiwn0l8PdAUI0haS+O/6uOJS+RVE+sWrDB+QpwVNPchRJFDbOqj9jY4Vi34bXWArWtVKeOcFdm1W/x+MUIO7PWBtXbGEu4FQQl12nPKHJpCrNFrEmPgDzItkwJFDgQuaO4MTQKFz8Co6L+AdlTEj3VQfS/VVPTHO1IRDckJwcFLWzS6OyJmx0EHaTBm9cVWDrCU7ZBSjyBrlcuDl9a8I3Ar37N65zUdErNeHlp4GaMx421uUmsAWscS/Hn6SrqVI8TM94sPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move ptrval_to_str() inside a header thus making the helper more generally
available for new users which are being added later. While here, also move
another related string size macro PTVAL_STR_MAX inside the header as well.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 include/linux/mm_types.h | 15 +++++++++++++++
 mm/memory.c              | 16 ++--------------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..a5b514e55dd7 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -2001,4 +2001,19 @@ static inline unsigned long mmf_init_legacy_flags(unsigned long flags)
 	return flags & MMF_INIT_LEGACY_MASK;
 }
 
+void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size);
+
+#define ptval_to_str(buf, val)								\
+	do {										\
+		auto __val = (val);							\
+											\
+		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
+	} while (0)
+
+#if defined(__SIZEOF_INT128__)
+#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
+#else
+#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
+#endif
+
 #endif /* _LINUX_MM_TYPES_H */
diff --git a/mm/memory.c b/mm/memory.c
index 01893720b6d8..752fc04ef8ac 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -46,6 +46,7 @@
 #include <linux/sched/numa_balancing.h>
 #include <linux/sched/task.h>
 #include <linux/hugetlb.h>
+#include <linux/mm_types.h>
 #include <linux/mman.h>
 #include <linux/swap.h>
 #include <linux/highmem.h>
@@ -519,7 +520,7 @@ static bool is_bad_page_map_ratelimited(void)
 	return false;
 }
 
-static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
+void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
 {
 	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
 		snprintf(buf, buf_size, "overflow");
@@ -546,19 +547,6 @@ static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry
 	}
 }
 
-#define ptval_to_str(buf, val)								\
-	do {										\
-		auto __val = (val);							\
-											\
-		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
-	} while (0)
-
-#if defined(__SIZEOF_INT128__)
-#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
-#else
-#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
-#endif
-
 static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
 {
 	char pgd_str[PTVAL_STR_MAX];
-- 
2.43.0


