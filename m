Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA851C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122C86B0115; Thu, 24 Jul 2025 05:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACD76B0113; Thu, 24 Jul 2025 05:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2F46B0107; Thu, 24 Jul 2025 05:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D49FF6B0107
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:11:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9FAD71DA2A7
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:11:00 +0000 (UTC)
X-FDA: 83698588680.07.47B5923
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf12.hostedemail.com (Postfix) with ESMTP id 657D34000E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:10:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753348258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UZfi3XxD6j1BmfqCFpkrzrN2or5JtHDQe6+xizsdfIs=;
	b=O/gJBIxXdUTtcvuldaxUfKx/GX4YdOUFuYe+YE8QYmpg0sWpmxRdaRB1WCkRlydrBdq1gP
	bhEgCUtCprQy5wxbx8hCWumY2Z7M3NseQko9oNPa+64cXGWm/50n9YWtaSP3q3WUOaw2R/
	dt+p/LoMrwNvvmOwr/WlrLVd38z7oJg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753348258; a=rsa-sha256;
	cv=none;
	b=0v1UGHeQvXvWAPDNBZkH+jM3bWbkCbhMu/B8cfR1xDWhhuqvaiqum/QUvHBaEk3eyE62BF
	Ita2ANZZoSfRYrXQkWHHbBWW/2ecWg0wFGRtajhu3yIkXNrxw/TRnqcouiQMbhXtGwkik5
	xXP2vuq5nORxXJwBJRKKFEhopqEeJMM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bnlZQ3K3pztSkG;
	Thu, 24 Jul 2025 17:09:50 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 4648D18007F;
	Thu, 24 Jul 2025 17:10:54 +0800 (CST)
Received: from huawei.com (10.175.124.71) by kwepemo200002.china.huawei.com
 (7.202.195.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 24 Jul
 2025 17:10:53 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>, <dev.jain@arm.com>,
	<catalin.marinas@arm.com>, <lorenzo.stoakes@oracle.com>,
	<thiago.bauermann@linaro.org>, <superman.xpt@gmail.com>,
	<christophe.leroy@csgroup.eu>, <brahmajit.xyz@gmail.com>,
	<andrii@kernel.org>, <avagin@gmail.com>, <baolin.wang@linux.alibaba.com>,
	<ryan.roberts@arm.com>, <hughd@google.com>, <rientjes@google.com>,
	<mhocko@suse.com>, <joern@logfs.org>
CC: <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 1/3] mm/smaps: fix race between smaps_hugetlb_range and migration
Date: Thu, 24 Jul 2025 17:09:56 +0800
Message-ID: <20250724090958.455887-2-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724090958.455887-1-tujinjiang@huawei.com>
References: <20250724090958.455887-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.71]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Queue-Id: 657D34000E
X-Stat-Signature: 1tuu4848kfmwi55qim3g6q57znua7ako
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753348258-300180
X-HE-Meta: U2FsdGVkX1+UkyuKlnEsPVVk28UoGE2snlr5WLDqnj4zgBusq7usmNIoCbHWAGWGmqeqH8tkkyjI2xvbi1XNV1eeTdb2RRyqzWmZyE0mTI3DjLGXzcMs2pKizUr/70Ag+p1YQnzk/+Ovuttv8Naxcjn0Wb4zeyPoU6ZUWiDk5rUgV7VL2zsXPi7aBDUCnzrBQFpek8vuELpVLMLiOCt2Y11OZDSrnxojXQ77ofbXmRQvaP5EcWMTD40n1t+WjO/wxkMsdI3Tczd0iRKwODiDZ3bi8pT+1OdHyyS0b+EK4Lpucrn8sjDfZhHDAQ4cDtLo/lgi7COiNj7BlCw7IIaXCz63lKZaX/90maeVvK8jpuCQE0OuJO4zxwEQnsFIvT05PwSC+akEnjQQUJ7iCwDmzkyp58XEOQbJQQJLDDUDRIj0u5QRM/QwLopzpPoqNv+OAulV7JjCNNNbj0QAef/aobDXnbzyp5AwxRIQqWSQR1WpRlhVy1xn+alL4Za5wdwd3vEKAyEGyrNZY9ADZFFsSsQwJd0ThJWaQl4eVzNeFmX7/b46oyTexqYxOkGqpMbTqRWwIAes7jQSwFgg/v1O++bKZoereG1LccAGNioSNR/pmivthgYCPKyVq7aaEtiWO5h1uYR8glWTFnIp3EgtL1X6PIEZH3wjpqyGdnW158kSMJ+QUd0rlVG7wyHMm/ykmYPNrBTBsAy2Dn4Rq3Vzrf797mT2SEdQJPWsGnCGi72uB3u88+0rN2bIFMvo3EoSbMB8SN/BKMsfzug3aqHSSwns2Shp9p+z5Ucku/ZX3LZncqwXYC5WKoSDIq2M3nzPffYvTPx+Vk+pkkJx/KOBNLloOdjAr1sj1Qlo7sE6SijV2YyU3HBz16oyVMMT+ehuwk5jd9eqnCysGOHPfL0FPFTlOiE9h3Ts7j12G0xBcfWmtGYZS+onEkQmIlNIhfShNSCL0d8GlUjbkJk9V0V
 8XUPN/G+
 npXwQ38zZu+H6LBf/rC7vZlvpHdZFbMwVBYbIyL9aP+t2L3N4mCCTmL0M/AWufk0fT/Eot+Ju5YQfMNI0jpk59C55PNuLHNfuxFKxDqytGomtMnukAMxJ79qs0J/pSTuKBZEbequF9Ivv8YPKZ/jHwmo2UPv8SGqf7l1Rudwrk5ewUqPh0MoOmpz8cojEJ7i65R2DQNqv9jhe2NaDowQUi5sMJZgqkILoMI5BuhZNTfomf+JDMAqyE7ca1Muo0ss4zAl0bxx/2JcJ9F6Ne389LSTrbGsuA82E5DCrlTyKdnl1m0qJn0+Wx/gsUFusCLd5JhJ7yJRXCS+Uc65wfbl4W583x3mvE1kBatNQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

smaps_hugetlb_range() handles the pte without holdling ptl, and may be
concurrenct with migration, leaing to BUG_ON in pfn_swap_entry_to_page().
The race is as follows.

smaps_hugetlb_range              migrate_pages
  huge_ptep_get
                                   remove_migration_ptes
				   folio_unlock
  pfn_swap_entry_folio
    BUG_ON

To fix it, hold ptl lock in smaps_hugetlb_range().

Fixes: 25ee01a2fca0 ("mm: hugetlb: proc: add hugetlb-related fields to /proc/PID/smaps")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 fs/proc/task_mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 751479eb128f..0102ab3aaec1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1020,10 +1020,13 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	pte_t ptent = huge_ptep_get(walk->mm, addr, pte);
 	struct folio *folio = NULL;
 	bool present = false;
+	spinlock_t *ptl;
+	pte_t ptent;
 
+	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, pte);
+	ptent = huge_ptep_get(walk->mm, addr, pte);
 	if (pte_present(ptent)) {
 		folio = page_folio(pte_page(ptent));
 		present = true;
@@ -1042,6 +1045,7 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 		else
 			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
 	}
+	spin_unlock(ptl);
 	return 0;
 }
 #else
-- 
2.43.0


