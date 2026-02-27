Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45B79FD531B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 09:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CA4C6B00A6; Fri, 27 Feb 2026 04:45:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 460156B00AB; Fri, 27 Feb 2026 04:45:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3346B00A7; Fri, 27 Feb 2026 04:45:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E02836B00A9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:45:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 848BBBA388
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:45:07 +0000 (UTC)
X-FDA: 84489753054.30.B74BF5D
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 021F01C000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:45:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tE+uxmJY;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772185505; a=rsa-sha256;
	cv=none;
	b=NcAo6QqEFy009WXCoebCi9s70S13E1dyLkFo7N6DFeWabtL83VkCCsb4edSlMfESgHUZxV
	ioC5IwYAgYZgsWSf2SrfTrC5hFvXGpxEjFz9FyEssnCdtiW0mQsMUFiz0TFWtjEWalcgu9
	EVDj46/XGROTJjvk37H0BHcaT635yUU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tE+uxmJY;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772185505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z89VjCPOsBTAMzdOkBmmkyGLdD2D9prjOEPgmVbdWLg=;
	b=tm1tki5Rzwp1ZnlSa8DbeZXdlxTgZ/W0da6F4zsNywjtYS8tazlxznCwVaoA2r3KYYJap/
	4qSi0VQPpUwCYdMOIiQafOOqeMk3nlO8LPyb40TJnHxMZEoNsC/j8bOLLv3axkRYItWkDK
	s8RulqH4wsVG5yRUfoOEg/wjgRx0Xpg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772185501; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Z89VjCPOsBTAMzdOkBmmkyGLdD2D9prjOEPgmVbdWLg=;
	b=tE+uxmJYnVji7dwpZpIaaBQudwujNlrNedXqQkp+ukhpwAHd4qaEByBvx+yZ/iZy5Y6WYJg0IJ3tUuOb5k34Or7p0qbDP93XHvNkYLGVLzUkcCbOFHZhrrZlHUQQ5/70VQlJlxhpr8CmUCgaGrhsm8Eb9QNLL3LC2stIq40ZULA=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wzu12vf_1772185499 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Feb 2026 17:44:59 +0800
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
Subject: [PATCH v2 6/6] arm64: mm: implement the architecture-specific test_and_clear_young_ptes()
Date: Fri, 27 Feb 2026 17:44:40 +0800
Message-ID: <5d9298b94607b2bf4f1f92ea29a4c96217c5bcc1.1772185080.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
References: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 021F01C000F
X-Stat-Signature: z6taj8wc1djftrk3hwp59sanmsydfuj6
X-Rspam-User: 
X-HE-Tag: 1772185504-893904
X-HE-Meta: U2FsdGVkX1820bFfA86UPp1bcKem/o/lJiZeOr1DMgX44twTxyFtiMQDrOejxyYGFOPLSmzAMs6bo4w3Sn9RoWGvbOMNqu2es/8jyf2YY6Bsv2dxQWGxTA0FwrFXlWAUkllgounABUlDJBgftPKm1fKpcIepke5KSZlWRgnajRtWVn5gRbSvpd+MGMbgAqfcW7LY1Vfv8mWRBgFVpDItNqr8h+gR5V6oz8pDjSBkmIN/VloBWtls5ACUos066Drp919oLELUDags0I/h8QwhHX8qo2o4hPEaWQ/0iA+8r4Z8QjOt3UHn7bgZ52Y47sr/bo51lgkg3lo/pV06OmzVVsxrREr1g8fMe/igvWg1QBmXNgBiSIXCEwAY7wPPm/gfkXu/iWJ64xNVTe8zzcBFeScfsfHZAN5RNMihvj5gmMOqy+Q6Pfo3UMAb7jqqduXZ7kd7V79FpdH4P1Vb/m9SUG84z7is6B1weg0awXo3HGpleBk9clBb1G0XKsboCr3KlokkaNhocU2fJ6buvWCsC1Aj7rqhq/tbzjOnihFdJY9FP3gxhsFPkzsX8sLAPxhaEc3oBQ93cqJME5NHVLj1CTdzHEOxLxRmFW7tzI01ezkJ2AW2kem9h3tkUd/3YWRI9chuwScximNtUCwCWmtAeR5f2IEvIF6w1lZjtmybocINHwifZ6Osq1HyLH9j8eys8UxqmDAdO7y3FHuXBB0uO5MDa9Ul+bW8QNRAfu9TwdnDnSqJfPZCHINvDzMUCWYQfBPBY0+5qORRAWwUB40q+SxJdRgh3+2GldxRs0yZknQVkG1FJV2YKczk0toBRRdq5d3EzQfJNlmBFTeEZK/5UYeACc9NYRacgyqww2gJ6lcVoYg/aP1z0xb7qPP1pU83IYyWlNGXW+iwvslJ4AJMPyY50xq3BD9JFqBcBrtSSZ0CCiZJIRwcWmpXQY8jsUIcPD2jkTa4aWUuHCbP7zw
 5d+c1s36
 EvpXEOwqz6NJKvQm78qwEOAhWxiBUKCAhUWfrrTfYK2HprbAmCIfUlFKh9IMn1qr4S+SdC9En3swu8k4JgbMw55L7+J9KP/3JLFovPrxG7Xf3Go5DM76AVY7mH0kca+/U1llTKF2VDrswL+8+nVkweSsG8mXqIgF7K4VA2H35mF7hudDzlyMRfrrpMBQTP2uql4PHwnPpLV42MYbAQgv8kHuEjuZIoFCN5irku8aNESps8+9DVgNJI89mgsdyrP4KYkn26somXFRUbYwFiutmRQQfAanNeMDtHZrW/p9EgdJ+F/ibYVwuPyfz3ayWEOZl1KYnwvbSV6rmy/qQK9gAzyXHMM5xDvq3rMbDTyDCg5GBQDw=
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


