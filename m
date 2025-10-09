Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEC9ACCD188
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 09:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581E88E0072; Thu,  9 Oct 2025 05:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532668E0002; Thu,  9 Oct 2025 05:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46FCC8E0072; Thu,  9 Oct 2025 05:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 383D48E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 05:37:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AAFA2B5383
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:37:29 +0000 (UTC)
X-FDA: 83978073018.15.AA55FAB
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0A70DA0016
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:37:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UtZRCyCK;
	spf=pass (imf25.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760002648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=h1VdD661PFCksQ/jZehnN/o3cope4Mou/GGCneQlrGM=;
	b=3nkW99TXwQ8P4jEIHzHfsGoxaXLb8Ujocibd2jlPDjJl8eSe4FBcXa46BALRwE6xYzwpwg
	AF23z7ewwwywCEKxpyWJQiUdsbr14mpnGaz2mcgHIf7d7UdrN5XTDzDPf7DGjBQybaT+Lq
	vgHRx+L1hZYLj3fRr3royeGgulxqOLQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UtZRCyCK;
	spf=pass (imf25.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760002648; a=rsa-sha256;
	cv=none;
	b=2deYU2tp0b0P2D2y1l9hZVYqn/+vh4kZ2OwTU2sh9e7QvyfX0XAC5Xg4Tsk+pzgiz4rLbC
	ImmMb7La3/oaSIHlccO8JwCphS8Wdl54vSvS75OVRBxZ4jYH3K7RG+CQ0R3sQha2aEbwWE
	xWlf+l1ZC7NWUuy9zulUumNjpJyTVlA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760002644; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=h1VdD661PFCksQ/jZehnN/o3cope4Mou/GGCneQlrGM=;
	b=UtZRCyCK6DNj7COGMUkai++zGCvBHD/RZYvqr52usI8j4qWQjCcz9I+eF6FK+BQFq3uxKjDPTRlF/K09AUaQl3H2Ta6BM62bV9y6JH5de5/kUewBwT/cCuOp8rCMw3KET/9j0pYKt6mJSu9TkUR5XJjqpTP8m03bLgZiWhJw+qY=
Received: from L-G4162440-1116.localdomain(mailfrom:yadong.qi@linux.alibaba.com fp:SMTPD_---0WplFjgI_1760002641 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 17:37:23 +0800
From: Yadong Qi <yadong.qi@linux.alibaba.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ying.huang@linux.alibaba.com
Cc: Yadong Qi <yadong.qi@linux.alibaba.com>
Subject: [PATCH v3] mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned
Date: Thu,  9 Oct 2025 17:37:06 +0800
Message-Id: <20251009093707.868-1-yadong.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A70DA0016
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6ckeo7sjqwfmf9iuxeyhzymwaxk37hb8
X-HE-Tag: 1760002646-814979
X-HE-Meta: U2FsdGVkX18obnoKpJ86OONOhH/7mLoEZL6sAzjWYbSj9F128BzK0inID6lXjVGcZKsIxzbaolJ3flq8YzpRzcIpd+WDme+mKzAZcKWAWSoRuRzXqijPDrGSgzndozs5wRL1H4Dx9fA9R2aaGjHUYWjqpptoOiL0rNrtacHw0Xf+KBQhkTkoi/pUiZmgXZzc4tCSIi9NUVr+0WRVHWClkBuHI1TRYnQhQdkY7PMu3llXPB/IfloxfL2DLWa8MXFXuFUQwEMECEd+XOXBeXX4j4rFC27a+vCYs70MSbYJpQmXMySzMcz5iNwozWQE/lcbVAsqVHSGukXJ/ITwG3gMwbs58K4zFOqU0UwEkovchbaPoLszJG+vc7HnnYpBsNHH0IH2dZaP1a6tE4dVc+IIUtjeoZeGbodIbHFpD2U3E8xkSvvmNDuahVPuGlwk7l1FoZEQfOEp/kyeYRY9ks1hrq4kztiJPL+6nyGfPuytX6g5p/R0w4Y1ZMEEsjIROuUaV8N7GjokQznQ8Sh4Roq7MHsfp3C1ho+NsIN5nvzgKjY1W6lhxmLgmylfkbkqTSROsLIOyXVh8VSwWec3T0Fm4b9nqnrwPXt+mYqcrn/y4nJu3Cw9GrvZ5T1ayRkMpuful9gPd9ai0BFVfp0dLXkHT8Pr0+6Q1HeErb2iF47p7khbMNSkqvcdyKf8RJ4JInNKCFyYQ4ZjL1exhDM9jWplsybx03gY80w//gTfTmDN1/NZL/HQNgCly+iQA231pbwurmX39VnV0q6TMc5YwpjWbj2DiBfu4PdIM30jr94zYCgvMkHcYq2olF6GY3dincKiw/OATEtNyJz5iUWyJOFmulu647pqjH76DXbH/OYR6IMcuEfKcxZIVKk7yNEzjej4PeC2oktjtCXQVCFjVV2DoLRnCQ7qm0Gv+l9pfwAYhJsjfRluy3FMeCHPsmciiO1uh4324E1hSvGejj1dMNy
 KlnJ3DTK
 xa+6I6j17nyUjISa29GkNgND4532puenIZNlogoPy8r18bvcM9pYyaxhObpSiZcBzdxQaASL54SEKyZ8N3rUn2BGq4PtU4AY7yeagpKa/o0TdrRr5Xtwg/qJfGH0YeaC7PF0aLnj4JisyVbEiizWl6rtON1e9n5zh1DqhXHtqV1AAjRyF1NylL73uKQSbSH4oSiymk1oLZg3u5GpieMEz5LfjlD2+fknWA5ys+lw0phLo5KK6zt927lyNnsAUYYXj0xX2EcK5L6/FW3NMqz1eVPTl2CLbX1sSQoofjeNIAoms4Qs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mm/vmalloc.c, the function vmap_pte_range() assumes that the
mapping size is aligned to PAGE_SIZE. If this assumption is
violated, the loop will become infinite because the termination
condition (`addr != end`) will never be met. This can lead to
overwriting other VA ranges and/or random pages physically follow
the page table.

It's the caller's responsibility to ensure that the mapping size
is aligned to PAGE_SIZE. However, the memory corruption is hard
to root cause. To identify the programming error in the caller
easier, check whether the mapping size is PAGE_SIZE aligned with
WARN_ON().

Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
---
v2 -> v3:
  * change error code from ENOMEM to EINVAL
  * modify callers of vmap_pte_range to handle return code
v1 -> v2:
  * Use WARN_ON instead of BUG_ON
---
 mm/vmalloc.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5edd536ba9d2..1fa52f203795 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -100,6 +100,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	struct page *page;
 	unsigned long size = PAGE_SIZE;
 
+	if (WARN_ON(!PAGE_ALIGNED(end - addr)))
+		return -EINVAL;
+
 	pfn = phys_addr >> PAGE_SHIFT;
 	pte = pte_alloc_kernel_track(pmd, addr, mask);
 	if (!pte)
@@ -167,6 +170,7 @@ static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 {
 	pmd_t *pmd;
 	unsigned long next;
+	int err;
 
 	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
 	if (!pmd)
@@ -180,10 +184,11 @@ static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 			continue;
 		}
 
-		if (vmap_pte_range(pmd, addr, next, phys_addr, prot, max_page_shift, mask))
-			return -ENOMEM;
+		err = vmap_pte_range(pmd, addr, next, phys_addr, prot, max_page_shift, mask);
+		if (err)
+			break;
 	} while (pmd++, phys_addr += (next - addr), addr = next, addr != end);
-	return 0;
+	return err;
 }
 
 static int vmap_try_huge_pud(pud_t *pud, unsigned long addr, unsigned long end,
@@ -217,6 +222,7 @@ static int vmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 {
 	pud_t *pud;
 	unsigned long next;
+	int err;
 
 	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
 	if (!pud)
@@ -230,11 +236,11 @@ static int vmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 			continue;
 		}
 
-		if (vmap_pmd_range(pud, addr, next, phys_addr, prot,
-					max_page_shift, mask))
-			return -ENOMEM;
+		err = vmap_pmd_range(pud, addr, next, phys_addr, prot, max_page_shift, mask);
+		if (err)
+			break;
 	} while (pud++, phys_addr += (next - addr), addr = next, addr != end);
-	return 0;
+	return err;
 }
 
 static int vmap_try_huge_p4d(p4d_t *p4d, unsigned long addr, unsigned long end,
@@ -268,6 +274,7 @@ static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 {
 	p4d_t *p4d;
 	unsigned long next;
+	int err;
 
 	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
 	if (!p4d)
@@ -281,11 +288,11 @@ static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 			continue;
 		}
 
-		if (vmap_pud_range(p4d, addr, next, phys_addr, prot,
-					max_page_shift, mask))
-			return -ENOMEM;
+		err = vmap_pud_range(p4d, addr, next, phys_addr, prot, max_page_shift, mask);
+		if (err)
+			break;
 	} while (p4d++, phys_addr += (next - addr), addr = next, addr != end);
-	return 0;
+	return err;
 }
 
 static int vmap_range_noflush(unsigned long addr, unsigned long end,
-- 
2.43.5


