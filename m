Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E35FC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874DF6B0106; Thu, 24 Jul 2025 05:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825B56B0107; Thu, 24 Jul 2025 05:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714856B010A; Thu, 24 Jul 2025 05:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 582046B0106
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:11:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 030C310C8F0
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:10:59 +0000 (UTC)
X-FDA: 83698588680.24.1205A15
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id AD8331C0012
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:10:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753348258; a=rsa-sha256;
	cv=none;
	b=PLjDaEq2uiLt0pGpf4eg8xrRbw2+FySPTDcIzWmKQigGBkONSdj3vrNYgDR8n8kuNNfZdB
	dI3Q/p9+jKWjqTwD6/Wz1LO35Df3Gf/5GsJTF3a2YtlLaTcubDAKAbh6Bxax0lsqZbep1Z
	xycRyx+9RRNZtVdOCNsEFv5Rk8frS/w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753348258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=WhckuD81659CKdZm1Tv+i2Am5y87e86udCDZlr8nEp8=;
	b=qFGamSm6dAzI8FpIE/FwouWcgCq3QY/p5hrjgVwvZ8bDmiDM/r5yQszShugnQefaTCRoEK
	Fe9G/UtqB7aUpJMhCSVieK+38OYSl9RxXj88eEekZ4MTs7COId1nvIk24WTc9K2Y8mwTQQ
	iDNr8opU/oOdET5TL/fOrOj92B0bf20=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bnlVp3VWGzGq1k;
	Thu, 24 Jul 2025 17:06:42 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 4C63518007F;
	Thu, 24 Jul 2025 17:10:53 +0800 (CST)
Received: from huawei.com (10.175.124.71) by kwepemo200002.china.huawei.com
 (7.202.195.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 24 Jul
 2025 17:10:52 +0800
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
Subject: [PATCH v2 0/3] hold PTL for several .hugetlb_entry callbacks
Date: Thu, 24 Jul 2025 17:09:55 +0800
Message-ID: <20250724090958.455887-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.71]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Stat-Signature: iiko1y5weknqwyhxu8aoueji7qu1g1rr
X-Rspam-User: 
X-Rspamd-Queue-Id: AD8331C0012
X-Rspamd-Server: rspam02
X-HE-Tag: 1753348257-432477
X-HE-Meta: U2FsdGVkX18vao30RYvRrjs24gkhdAMQq4UkZfRt1emc6x/GOM4+T1m7qnSLI89g78RbPFS0cS82lmNPFLjm7ivl87zR8o4ltCNeNoJzI6xXXcVZYKlWn89GZYeue6En+LQhRMsEJGk4MM9iVf3GurQjDojZLiqp5vqMV6Sh8EZBHCffEzTNdnEWQtDiIzlkvmW5ktHNZqDwPuJwIlMnxzQ+Rtu6w30YHILh05ErQ/x0fxF1mW02f/81ocjF7KJ2vveNe3jfHzdjCMWySPJd8xQf7DpAgajXL3Nycj9cjNtxmLV5hOF0LnzBDMnv9BO3LRSaV5bAC90ScoMTfe6Z9rifs2uyYMy1risPko3DM+n4n77hsnGc42DZYH1xn6rlc36Fsdur7Pcd5jJPhwPDUgpv6Lcl0HIbYX474BKINat9VxegWEa74uI0VT7kUcuennila4u1QCarS+Lo5ov/7Au8d0Dpj1iSgr1aimGx/5SszGw015YTLKtFudn2TphYq2b8lIfbSwl8qVWxN/5GQeIK0ciJ7DxJne4c4XPIepSKcUKvrhFjGvLZfVjw7DBDa9lhK1kIVjnqzx34mRVXZ5a6drOiS8Tmulon+UUUcNrvgg3jmP5KpGVo/wWKxiZYi52P6kzHxTVbOm7Xz42ON0nfnM+WJmihb6sTybELuN1rRid52ZCkrWraZcBjDxUs5Rt7xMGoolZA5LjsdToO+poobYNkmgfgUoOYOfurCk3zpr/iz0cACh+RZ1spHVNjrwgmXBfRBw5iagbwRMaSHsI+8g5pG4Psi6Sm6xbDvhnRk+QVDf1RFe/nSTgkq4ml+ghr+hMydjhGc2GXHHnDWE3vyERg1Fe6/iVa7eNEFh0d+RTU7hB37GyIFx+9gWRF3Ax4psvCZWkIMGLDZV5m2ErlSKjaaXNODtlPKsPOhbo3KN7U4/X2Udbc22Jp5cvY3o9ggX0aueKgtq9v6gD
 ilQRtxrp
 HM1LuRPwo8Oc93LFvMt56mZ1N8chaJ0+slaphFF9TzYgubdg5TMsrDczNNvkiTWF8url6xAuFJRryud8VBmUiGZ7M77DP97ZKxMO5LXNc6Q0+HwoIOWcAKbab5xXAIFPc0IUNVw27quvwvDrFh9bIbpWjfYRCZ4MSnmU5dmxu0y5hyvoLLfwGnkf4qEQlZWZlwAh27PALcAff2kpi/rPZRSArDYJCnCrZ2RkL96DK+Vj+lBARkFRysELtJp1+aqvsk+mKikYMBgKvGgpYMzeFwesWECfHcsGTURoHAZXF0FLqD2PQ6Wbz4Eg2fb3DziMKcLHeUSnEJKMPZIhkzPpixAbIKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog since v1:
 * update the subject pacth #1
 * add patch #2 and #3 to hold PTL for some other .hugetlb_entry callbacks

Patch #1 fixes a race between smaps_hugetlb_range() and migration by holding
PTL in smaps_hugetlb_range().

To avoid operating on stale pages, add PTL for several .hugetlb_entry
callbacks too. We don't hold PTL in __s390_enable_skey_hugetlb() and
prot_none_hugetlb_entry(), since the mmap write lock is held. We don't
hold PTL in hwpoison_hugetlb_range() too, since it only reads the pte and
doesn't operate the page.

Jinjiang Tu (3):
  mm/smaps: fix race between smaps_hugetlb_range and migration
  fs/proc/task_mmu: hold PTL in pagemap_hugetlb_range and
    gather_hugetlb_stats
  mm/mincore: hold PTL in mincore_hugetlb

 fs/proc/task_mmu.c | 20 ++++++++++++++++----
 mm/mincore.c       |  3 +++
 2 files changed, 19 insertions(+), 4 deletions(-)

-- 
2.43.0


