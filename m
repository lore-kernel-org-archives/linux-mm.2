Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78F6FCCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C327E8E00C1; Thu,  9 Oct 2025 21:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A268E0002; Thu,  9 Oct 2025 21:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B476E8E00C1; Thu,  9 Oct 2025 21:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A3C1A8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:44:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45796C0159
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:44:01 +0000 (UTC)
X-FDA: 83980508682.26.54391D9
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf21.hostedemail.com (Postfix) with ESMTP id 89BD11C0006
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:43:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="d6W/loWQ";
	spf=pass (imf21.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760060639; a=rsa-sha256;
	cv=none;
	b=7XqJDEk1iDJUgS8uaibwrW/G2wShiHwjEwHrRAo25nvwKT+a6qvCpa8+qfOsHipD1MJF+I
	VXo2QH1YzP0ztaMa43oz8JHg4a8R1m7SyE9gaAnWcGLnjzlDx+npiZ0Kbou4msSnVL3Nag
	nYlB11MnzQQ3maO0szZIOkiRjSJVcfc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="d6W/loWQ";
	spf=pass (imf21.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760060639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PQochvWsXGlGnlw3hP2OYE3dNubTNWRaSV2n1gL8K3M=;
	b=nWYMrRIGUbcSNqWL/NMIXG+8ueJRoXr3NLvOzi6VKK+hZs4OrvnCvQAf8QydI2UpXHR1qz
	7sIbMl8FsIaQRsrsTcvW2EVcfI8HxzIRIxGiyWxNbn4jIsK/EsLmo6AxKCvLAwrR0dZgJz
	63I1RElJoLFaMafJOPyNDG4g7P34gSY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760060635; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=PQochvWsXGlGnlw3hP2OYE3dNubTNWRaSV2n1gL8K3M=;
	b=d6W/loWQcCeJu33pTCmT6XR95ScNiNyYtn47O/zTnXBd7+pfs1E+lbOkowKNutgdDuRnfbTGLH+cv8R5fQJUhQ1FQRcPo1cSBLolGJD5i8kLOT3jpXwHg5+GGdh8tDHWikYtc1fpSdwQH24Ea/AH58fyQ32DVrfHa6MlkQdCZzk=
Received: from L-G4162440-1116.localdomain(mailfrom:yadong.qi@linux.alibaba.com fp:SMTPD_---0WprD.43_1760060633 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Oct 2025 09:43:54 +0800
From: Yadong Qi <yadong.qi@linux.alibaba.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ying.huang@linux.alibaba.com
Cc: Yadong Qi <yadong.qi@linux.alibaba.com>
Subject: [PATCH v4] mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned
Date: Fri, 10 Oct 2025 09:43:11 +0800
Message-Id: <20251010014311.1689-1-yadong.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: j4ep3ewacmox7e4z1tdiwgi37bks91s6
X-Rspamd-Queue-Id: 89BD11C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1760060638-372560
X-HE-Meta: U2FsdGVkX1/hSGqgRTYs6vs5/zzDVniLSt05s/nhI8w4wGoY1SAqkj9t25GobhjXMno0Fg1XD0bq++RqF5kecKkC8o3JIiGDRX6lSY3xw8La1Ag1hX49tsQS2wi4C4VKnGs+Ufh/XUfEpsKHMMUdwQ+PUX6UsV4Ifx3c8qm2p+B7yy4wZIF+405WpklYSCInnIdqV1GHa7QgNKzB5PVKqcT55+8zbFonDTr0t5G2Kbd2W6DNk1gI586bBndxUTyOK724nMqE/oSfzDA6imu19yhN8dfwkEJYaQAkc/TX5L2gIUnnrSrrjFhy7wzooo84Mjo1/0af0VVY0FEpqIRzpqOT8g1lx/1rQ97zveWWkyRKo9OFIgDtUd+BrLKNDsRzlw4pEo/gbsmv+/Vg108fLGvwRaK20G7Jd5F0kEmsLv3KpDLKZY6LDFhSFuodmaez7pUx9eM4Tw64OQ/KlSnAOsfM0Mo+HovybUlgx13nqWDyC7nAl1KaqlCFAZcRdPldhWSikT+BiMhuDaJecPXtTD/ThkWUVut7FdAYxupwUkau4ZDa1TSkWJqFdAnL2XpU9Tm8g0poDjYqhRSSeuCCG0JQTxnieR0ZzeOK8v+RdMQntXlzR/ZfL4X1jfdj3rbw2+bVvKs9UtVnxGMQzpbd5PyE+q2g22a+jHi5UseadMu3JyBzxvSekCLfVCQDsYjdQoHnU+FsvOscgZtxtgxG4pTzpNMn2XbYEdmOZb5ed0s20YGmPkot3R2OY4rd+FfqdjgWszPZXw3rtai0V3PaWff5NlczktVHfbsCiUL+GcTwEg7TVL/BXc/qa0Dt/TBgvEZ4Deb7ZGR4b4VrT1wPrD4yfGhrLvXurFLo5zZZad8B6aYS+aewHAcENY1YhWpbZnmzXG8QOfM6W+1/74PHRDC1RYDrjoDmmj9UyMkl+yOea2RXSJaAcbaNxowqnQUUEoSfffncdRnqaHZ8kFh
 VeFWu2QL
 Hi+7DggqnrmEq5MFjl+jbrEhCS15xblQNv8U+TRywo4+mk2N1vYBKPqEdvlq4UqwOqVuHoDRvGDXwKkxrmv9NlJUl0xag0dC40PvIurtzOHR2em9nLhEULwPlI2jUla8pm7V0GMkSZ4bai/9eTsbjaRopojS1SjSlxnU3Ii4zuevFfce3FJm4GLSanLX3eIS5FAKCv3cebtAUi1PJ/XrS7JyR4nSJNe6rpYbwscUoRr5Z6zx0dI7rBQMYK2F9PX993vkdxbHQOR3FBDIoerO7ZuB72vcIBK3Ac3l5p/ife+y6BKg=
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
WARN_ON_ONCE().

Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
---
v3 -> v4:
  * replace WARN_ON with WARN_ON_ONCE
v2 -> v3:
  * change error code from ENOMEM to EINVAL
  * modify callers of vmap_pte_range to handle return code
v1 -> v2:
  * Use WARN_ON instead of BUG_ON
---
 mm/vmalloc.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5edd536ba9d2..c0213118a75e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -100,6 +100,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	struct page *page;
 	unsigned long size = PAGE_SIZE;
 
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
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


