Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFAFC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 03:32:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADCD6B007B; Thu, 24 Jul 2025 23:32:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85E26B0088; Thu, 24 Jul 2025 23:32:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9B3B6B008A; Thu, 24 Jul 2025 23:32:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C75E86B007B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:32:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F474B9730
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:32:16 +0000 (UTC)
X-FDA: 83701363872.17.1E1C4C5
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9662B40003
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:32:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753414334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bw2SZw5/Ms3tHeVEGzW/C+hWWbbqLcyE6Cs/OMpx/xg=;
	b=cIUEdhD2QAVhOgWiH3W1XbwNjrax6RrRjbLsl7TUEXB94r70KWxoA/EeOIlq+FavP9Rlui
	n/WLubCYbAJn+XfK5/zcWJjBm7+VKjlI9ve22hRAiCuAB/ylmvTJTBWolYxb+41w94F1+b
	QKozuWhJx7efo05G4oywxyXCNEgjqkU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753414334; a=rsa-sha256;
	cv=none;
	b=ALxwWvERMy3WlJX/gG/yCID9LuWkLtWBcEb0sibqjYrv2O8BCW7KzvMB7zT+EdqLvhUnA0
	s094TAicuAVcpP3JnNxGbwcA4tWUiLrobK4O4ha8C/XsqkcE8mgf8UIY6viHUdTi4R7N7f
	y2qitkeKCqERogdducielPqMI2aSvak=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bpCzk1pnkz2FbPc;
	Fri, 25 Jul 2025 11:29:54 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 595CD140295;
	Fri, 25 Jul 2025 11:32:09 +0800 (CST)
Received: from huawei.com (10.175.124.71) by kwepemo200002.china.huawei.com
 (7.202.195.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 25 Jul
 2025 11:32:08 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <tujinjiang@huawei.com>
CC: <akpm@linux-foundation.org>, <andrii@kernel.org>, <avagin@gmail.com>,
	<baolin.wang@linux.alibaba.com>, <brahmajit.xyz@gmail.com>,
	<catalin.marinas@arm.com>, <christophe.leroy@csgroup.eu>, <david@redhat.com>,
	<dev.jain@arm.com>, <hughd@google.com>, <joern@logfs.org>,
	<linux-mm@kvack.org>, <lorenzo.stoakes@oracle.com>, <mhocko@suse.com>,
	<rientjes@google.com>, <ryan.roberts@arm.com>, <superman.xpt@gmail.com>,
	<thiago.bauermann@linaro.org>, <wangkefeng.wang@huawei.com>
Subject: [PATCH] mm/memory-failure: hold PTL in hwpoison_hugetlb_range
Date: Fri, 25 Jul 2025 11:31:12 +0800
Message-ID: <20250725033112.2690158-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724090958.455887-1-tujinjiang@huawei.com>
References: <20250724090958.455887-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.71]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspam-User: 
X-Rspamd-Queue-Id: 9662B40003
X-Rspamd-Server: rspam06
X-Stat-Signature: yfribmebqc45bobgexiu64p6dw38r6qp
X-HE-Tag: 1753414333-201624
X-HE-Meta: U2FsdGVkX1+KIPe1JXF9JMZpGQj84ZMQ2pYgSitDWPUtsQomno7WFMLQefC2bZqVoSzsE16ixp48YC4xXpTYPxzGc86ZFWbN6/TufkUoFveJPeGUePFnCeG1SPigBub//5EUq8OxwRdrpwu1zlCXCMgM1cfGRyklzgeZcOMnM3EVScOUyLRHoFBsGgqfVUoWyzGBMuDQC8ZxjP0R/YcbVhmQX2bsW+uUpesq5bkEbBbuI4Csx+JC0v4Jv2oR1rMiZ1/pX/G4g1Z5bxcwHHNNT4t1TIE4UtC7t559uFVSw3XlXaN/haXUSYOoGmI11ng29ml6kEfIwGl7DuXjImo/w/QOxR0hpOKYr1iQcseWTiiRMdVaoFzGuAlQgW6yWLz3880BGBhk5LvQ6XQui1SuG9toHZ871glK26XBKiUUYt0XgHFqG8jzGWQ29X/9xAWME9TbbBiJTGyrgmcVOQ1AvrxFagjkCGtPBPzt+t6CGDp9rQXOIoAojM8ORiKgF2+4jHUEJo39q2cebYw5RtD7BM6Q9JnQa5J7Mi/YnwP5A2BqIubebMEgmJrPqgHktCNHStfn8gZg/LQKir5qRDPCpCPx3aYQLuNAKOdRAVhjh2wYdnKOXXaI3wvFj01yNDou3I94RmLGHASh8Gg0IPbeygCtwPyZN6TIzswzXElOkpDQKVo6v2+lYpxL5J7RreRuvr6bxA3JARiA4+S1yqmLSA1HMZMg71oDBqTGloNbswAfunJp5fO4WeGJBimss3j0ex+NtiBXtsI7/9rYJqE29EXyJU6dv7vb9ZzW1EG7Hf0opIX2IyPtNXdPYgPpv+t60slHgeUZiH2sKte5iO8lx4YSBmmoLmCMKE3Hiir2h0Vf101KI6F1FPZoptR8bPSrrW1vAS5GPc3tNvw7P2pikNvdmz9xoSpUaBB+TCGi1O+3RMx+Q9Y8KjRb7YWddrrjhK2ftIp2zJ0gDI1p0Vr
 lhuqXcO1
 OKi1ubcVtJ1BoDXVGLu2qysaVALtDEOlLYgTsWr9nb2BNTCe/YxB8fWvWDwDVNebzw2kX+HtoK1N4vANvJT/qThs+2iX30C/REb11WFN30W8PxMGcS001e1a128LybTGNfZuWYHZyjcfoj3i7kMsUIWrfs89CzFonyvH9vUoCjS8Lm99JPCzdobIjGirrbtjnwWQYJmuXF7pf5j/Z1oYDJvwRu+tcVSWJEJjxMjEdpL9TCmsSYzDlOGagEgywQlE33qCYTGwkBug2o9vx80qAivvMmoTSOwiM4Q3E8moCqNB+3pQQ8Gzj+RvGHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hold PTL in hwpoison_hugetlb_range() to avoid operating on stale page, as
hwpoison_pte_range() have done.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 mm/memory-failure.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b91a33fb6c69..0ad3d55d1d09 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -837,11 +837,17 @@ static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
 			    struct mm_walk *walk)
 {
 	struct hwpoison_walk *hwp = walk->private;
-	pte_t pte = huge_ptep_get(walk->mm, addr, ptep);
 	struct hstate *h = hstate_vma(walk->vma);
+	spinlock_t *ptl;
+	pte_t pte;
+	int ret;
 
-	return check_hwpoisoned_entry(pte, addr, huge_page_shift(h),
-				      hwp->pfn, &hwp->tk);
+	ptl = huge_pte_lock(h, walk->mm, ptep);
+	pte = huge_ptep_get(walk->mm, addr, ptep);
+	ret = check_hwpoisoned_entry(pte, addr, huge_page_shift(h),
+					hwp->pfn, &hwp->tk);
+	spin_unlock(ptl);
+	return ret;
 }
 #else
 #define hwpoison_hugetlb_range	NULL
-- 
2.43.0


