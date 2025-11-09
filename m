Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA247CCFA18
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 02:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B5B8E0010; Sat,  8 Nov 2025 21:18:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE27E8E0003; Sat,  8 Nov 2025 21:18:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F818E0010; Sat,  8 Nov 2025 21:18:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE61B8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 21:18:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2886A12CCC1
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:18:40 +0000 (UTC)
X-FDA: 84089460000.11.C8B79A6
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7BCDC80003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:18:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762654718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=l60kYt+8FjoRJlX2ZrgTqxoUK+pmJ5OW2JhYei+hkGY=;
	b=vpaCbKlAPIahFh9Zo4VgAby3ee9MNX0e80KkGNrXei5P9UocpOv5p6Idotzq186bI1mxDB
	Gw2ASb4jGut6Um7vru4nhapKMMKbGWc+gNkfcNztrdi+w2dOnE/qU58bTf1fCui3l5HsS1
	Q0b9c200+8S1o3ZZyxKsxHG2H5A4c5E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762654718; a=rsa-sha256;
	cv=none;
	b=JCH5cVtB0Vce9SU6b7yugvyuYNNtamvNlfXtSWPztrLKQ33ltA9ewU3yFZP8KFI0+UeE2S
	zB4DKPyGHPoMalxSokjd5SknViRM8JiKvwsmxYQLwfufvVURId0BzFpPHjo3EkjdxjoXFP
	judtA69qEvrRoJxtWQBP1qgEEJMXN9U=
Received: from loongson.cn (unknown [223.64.68.45])
	by gateway (Coremail) with SMTP id _____8Dx_9P2+Q9pgtcgAA--.1039S3;
	Sun, 09 Nov 2025 10:18:30 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.68.45])
	by front1 (Coremail) with SMTP id qMiowJBx38Py+Q9p8C0sAQ--.3584S2;
	Sun, 09 Nov 2025 10:18:29 +0800 (CST)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Vishal Moola <vishal.moola@gmail.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH V2] mm: Remove unnecessary __GFP_HIGHMEM in __p*d_alloc_one_*()
Date: Sun,  9 Nov 2025 10:18:17 +0800
Message-ID: <20251109021817.346181-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBx38Py+Q9p8C0sAQ--.3584S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7uw1fGryUXF4rKr1xAr43urX_yoW8Cry8pF
	s7C3y8X398GFyfWa10yan7Cr17tw45GFW2yF42gFy5Z3W3tw1xGFyDtrW7ZFZrZFZ5ZFW5
	Wrsxta9xAF1avrcCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j1WlkUUUUU=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7BCDC80003
X-Stat-Signature: 7tea1ez4tzqky7deutfuzp9muap7ba9z
X-Rspam-User: 
X-HE-Tag: 1762654717-640535
X-HE-Meta: U2FsdGVkX19rWrYFyqiouFuHCRulUV3VV5rTxXqAULxr70k4dN6puEN6gqa4Ii9A1W+jZFyfnOe2ClIS1JVV8mDOKx7fGNRzjLcYAKuRH+TuzxCadnkHWUP0kdD/LuwVEew/uoElDx/D1iV/zFjJFv+2bNQmumEr44Gg9CJ63TQzZreHFU3e8ZSgh2W0fTAc0WlV+By32yk7J5rM49w+HVUKGO/ABQowfut7GcZIZaS+YuypYAMarmB6SgrNYc9OzRgfWo4voIG3Ci8Kjyt1DBO72byPoCsoysNuH483/FPy6VXF1mTWETukV5sddiV0TOj7e9gOC6urzPrqhSTligg7Coj20oRNS7p+sOq2NJN/T2GiNf6Dq2GkUVreAYMDBJDZFE0IrGjpWksEebd5Wk4XHD4Y8E9qG8RVBZfK1md97UeIHtwXe6ld/czj3+3oZbGuPCQP91wZdHk4TMV/Mz8wnnGuLUKWZ4LEu4baz1q/Bew4FrEDjVSIlgMatHnxLddDcaL1sDq8fxtWcENToSamKFprM2YufXyuU3NAh6JFw2962RIW8zpRh4NCJWMz85KuXfFoPY8ECp848vHuwSDGN0FBIRDQF5sP3DFF5E9XLVzgNZZJKU+yJK2HP9iPu1HXdF1kc0jSghPYg8y0ZJgzG1WAtepiZ6QWHtCFH5kgE0bUJI9n+uNCECckCt7vUpQyLuuxY3yilPC8MZsBClRC2T1pOWoCRTMwgWNqge7gLok+CrOEWcaIbCwNpkPUbfTqIQ0l9OrXYFp2wePXBpuUOTp6UGYIu6m7mCs4yQEDoTHt3Kpihbk28v2BHVykKJVeDikdTKZtZcseQQEwWJjv+AJe+NtEGbKP66uIxOJF+qff5arjWtHPYk3ritvdpjppqSHtj00mI6DuVqjHytcKMPRb/dDn1mfnzEwPO0TgVm2kOIctNPQsp/3XQ2YvAh54FO52MPCVbPxo1CU
 qohKyPZf
 Eb9e+EJ3AMOACijvMP4XNjKzNOkUELVaZwg+TSDW6IPnR7eBpQF86qWh9YtNjUN32PNXnfrc5m0+fRWCv4jOiIv79qgZf+9H0jJM/akJ6lB8FlDViDuPFjmRR/AuLT4GVNfxFgKf83uTIJfgSBeVo0YViktEd2O8ILvX2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER. These two macros are defined
as follows:

 #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
 #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)

There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
explicitly.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
V2: Change the subject line as Vishal suggested.

 include/asm-generic/pgalloc.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 3c8ec3bfea44..706e87b43b19 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -18,8 +18,7 @@
  */
 static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
 {
-	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL &
-			~__GFP_HIGHMEM, 0);
+	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL, 0);
 
 	if (!ptdesc)
 		return NULL;
@@ -172,7 +171,6 @@ static inline pud_t *__pud_alloc_one_noprof(struct mm_struct *mm, unsigned long
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	gfp &= ~__GFP_HIGHMEM;
 
 	ptdesc = pagetable_alloc_noprof(gfp, 0);
 	if (!ptdesc)
@@ -226,7 +224,6 @@ static inline p4d_t *__p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	gfp &= ~__GFP_HIGHMEM;
 
 	ptdesc = pagetable_alloc_noprof(gfp, 0);
 	if (!ptdesc)
@@ -270,7 +267,6 @@ static inline pgd_t *__pgd_alloc_noprof(struct mm_struct *mm, unsigned int order
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	gfp &= ~__GFP_HIGHMEM;
 
 	ptdesc = pagetable_alloc_noprof(gfp, order);
 	if (!ptdesc)
-- 
2.47.3


