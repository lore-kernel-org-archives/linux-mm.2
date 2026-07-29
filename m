Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCE27C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01016B00FC; Wed, 29 Jul 2026 10:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6886B010B; Wed, 29 Jul 2026 10:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13A16B010D; Wed, 29 Jul 2026 10:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91CD56B00FC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:44:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9EFE0140673
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:05:56 +0000 (UTC)
X-FDA: 85041534312.25.E0ABB7F
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf24.hostedemail.com (Postfix) with ESMTP id BD8DF180002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:05:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=c92r8y0o;
	spf=pass (imf24.hostedemail.com: domain of yujiacheng3@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yujiacheng3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785323154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKnSp+DAhepZLZpNrbELj6U71g3n9QSJp5+YuUnoIlk=;
	b=UoLRkPtEmuXtrQXHz+R0SB3IoEAS9m3Yh7LAT/mBDsXyoAGDNrB8FBTCaHmIoat08O3JT0
	fp7sdG5fDSonN/SxV+zQj8DQi1mI/SakjR/K9815ac7mxGy2Pes+53pZN5U7UsIaSgE+lP
	FlsLike3OSRWGwtJHRBKbj8RPvaIMiA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785323154;
	b=30znYw1TJK2DgSwDBt836qpFUw0VhXhIxWjiUYVMMJSFVDJ3o4YPx5gJWtllhUpBY5QlMo
	Fgj0RyEpdlS/1chF6PBo+HNCSEP4pt4WtW31C4SwmLn0aX5rcKfwlzRUpekbgC1DBYjRHq
	jetK88tChxBiNqxUGMNiKadjIPzZoRE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=c92r8y0o;
	spf=pass (imf24.hostedemail.com: domain of yujiacheng3@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yujiacheng3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nKnSp+DAhepZLZpNrbELj6U71g3n9QSJp5+YuUnoIlk=;
	b=c92r8y0oks28LUVaE8I3DeK2DPSlyXBBjKnIfUW5m26IpsN5vYP0mft+dBDozRHlvA0xjJyox
	9jVw4trpwSCF6tYYCLLGbScwmDIa/h0EYEuyOTGGawOdfih5+jnl5/V57c4ujiq3+py3eyKvFvs
	LI4luROKv0lKZ5lGXDwlPA8=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4h98QT35jKzLlXD;
	Wed, 29 Jul 2026 18:56:17 +0800 (CST)
Received: from whupemo500009.china.huawei.com (unknown [7.152.184.116])
	by mail.maildlp.com (Postfix) with ESMTPS id 7505040586;
	Wed, 29 Jul 2026 19:05:44 +0800 (CST)
Received: from localhost (10.50.87.202) by whupemo500009.china.huawei.com
 (7.152.184.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 29 Jul
 2026 19:05:43 +0800
From: Jiacheng Yu <yujiacheng3@huawei.com>
To: <akpm@linux-foundation.org>
CC: <hughd@google.com>, <baolin.wang@linux.alibaba.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <liuyongqiang13@huawei.com>,
	<brauner@kernel.org>, Jiacheng Yu <yujiacheng3@huawei.com>
Subject: [PATCH] mm/shmem: drop redundant casts in shmem_evict_inode() pr_warn
Date: Wed, 29 Jul 2026 12:12:00 +0000
Message-ID: <20260729121201.776566-1-yujiacheng3@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260728124919.c023a7f9b8be446bb785ec82@linux-foundation.org>
References: <20260728124919.c023a7f9b8be446bb785ec82@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.202]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemo500009.china.huawei.com (7.152.184.116)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BD8DF180002
X-Stat-Signature: gx3rjnhd77u91khw9e41ctgqjh41quu3
X-Rspam-User: 
X-HE-Tag: 1785323151-338561
X-HE-Meta: U2FsdGVkX19WKjnfmCP2RLRdDB07l4i79tP9fyaKPTJWlqJK51mSjf0vW2EWjsWyg2ExvDheCTfcM5RaquTdN6JLrjlYVECtdXin5ii0e+99uZWrIwE2rB6g4DVHd2iu5bn1rVMLmZDTVZqEsRLB34uVru09CbaEcainCuYz4rZ9MvJQu/IwpzfNN+QNmMV7CeJtFPZkGzUbK9fuXyQYvPHHpCAw/54tA1QabQ+ZFfvmXS7TarM2zz1Sa5qW/ZhSxbmOn3mzT5kZLt2RvALugWFlcUWPGSbfP+g52ylCiaYhdY094QSsX4AvcfGkjgTDyRwYe5WEAbtq5KUw9R+PqntWKykq/7iuzwdcsFgPT/8rvNbjFdeZXZHVV98oSfHZo7kMODG4MiGwof2ZCsQSS3GW4VT7BIqsZ93RKrgSUXpXXlQI/KAVQLblQ5Ej+o+vxdPDZiaXYSHFqK0y0puI8kz5p30e88eM18KvIM2t/3t/MVZmCNhv7aLejOZFlhSnN10IJh3gPG+me0F2OFdQ6DYfK0Aq1PupLk/UULLkyAPjBq/PNtBS1qgBK1dI7ekjqLdSBzRI29JptmV0pbkVSvm2TRAy06O2z0sBcBsL5VKO40X5+7i6zTVIT3CxAMbZ36UK22KH7KNcfJnXKQpX1wUWj22pZ6TST+6JAq7Gk/hBmJvfCP2PXkvYf9xvewdgme4Bjp39CKwSsXznOEN45GSrPO6p43J6yS2ok+bhhDI4YcEfI4OC3QZ58H1Hy4ksq3uoH0EowMa+33HYddYBdn6k0JWoMz5lXZov/2GsYe+tKSJ2A2yBIuw4GkMWthETDwoC4G4qkKNOxle6f8LC9P3ZESVQePgsVyy1zjMXHd8FG2ORIVwJX6W9c+6+4olshDNkg1ePdMmqUAr2NZ/1D5LnQuGE5XUk37GDRasgGB5FSZ/XPA61z4j9jdn2e6Ha0MAW/8akn7jh5hU4cMH
 mt+dgoQ4
 jOt0IR2DzA8lXIJ1B13rmxfjA9D1L7JWIoyFcfwOvX5WoqbY9WV1yM/XYRWQL/CAUplJeukcmPzzrF6jkVsgUzueb+vVTV2h7xT/oTv5RyPcXpJXt/Zcuy6MbMxoOEJJhgRWoAdQB1nL7ib430UhLoBm+mvugWasLwbpPFmgxlUULHVg1tdOAe2q1Uj2GaxB2nmJ9XSrRAHChoX/A67uS4VLcmI7rXo+SpxKddqNhAO225VxgXfq4E1qgY1UWhm13HSuSsVFVanDMvF5L7wP10TBdGOXBp7ZD7+RYsRnsDPl0tJiNDdTCW9FD8ug/yT0ILdWmBvTH6hS3hpq73jFrw65YK6cpD4OS8XCnXk9GLHjbS2g6TQA8SJy2X5Ec9Ej5nYxl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

blkcnt_t and i_ino are u64, %llu matches both directly, so drop the casts.

Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
---

On Tue, 28 Jul 2026 Andrew Morton wrote:

> I don't think the i_ino cast is needed?
>
> blkcnt_t was possibly 32-bit a long time ago but
> afaict it's now unconditionally u64.

yes -- i_ino is u64 since 0b2600f81cef ("treewide: change inode->i_ino
from unsigned long to u64"), and blkcnt_t is unconditionally u64,
so both casts can go.

 mm/shmem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 223484cdc8f2..96cf73c906df 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1430,8 +1430,7 @@ static void shmem_evict_inode(struct inode *inode)
 	shmem_free_inode(inode->i_sb, freed);
 	if (inode->i_blocks)
 		pr_warn("%s: ino=%llu i_blocks=%llu alloced=%lu swapped=%lu nrpages=%lu\n",
-			__func__, (unsigned long long)inode->i_ino,
-			(unsigned long long)inode->i_blocks,
+			__func__, inode->i_ino, inode->i_blocks,
 			info->alloced, info->swapped, inode->i_mapping->nrpages);
 	clear_inode(inode);
 #ifdef CONFIG_TMPFS_QUOTA
-- 
2.34.1


