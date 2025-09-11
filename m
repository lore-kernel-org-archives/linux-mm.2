Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C9DCCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 13:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC328E000C; Thu, 11 Sep 2025 09:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C9A8E0001; Thu, 11 Sep 2025 09:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAA3C8E000C; Thu, 11 Sep 2025 09:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B6F328E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:09:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B863C02E6
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:09:17 +0000 (UTC)
X-FDA: 83877000354.15.7F89EDB
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf11.hostedemail.com (Postfix) with ESMTP id EB02B40013
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:09:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757596155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=8kBUjibU5GTdAAhUvM2oLx/x2rKUrbb/rWEG1X+3uuw=;
	b=qT7KWZ9apfisemhgmN8TQF+xqCKeOxU2JBD3r8e75qFH6jGUkdwhjQ/rK7Kra0dWUy2zmR
	LWzYcBTcWQ/gds8akZjZ/FmdfFKZPr73QnxsK66oDiMIY/vFpdsM+qMBCNxvHMyl/0r5kM
	WC05v9R4roZmV96e+XyPFxsMxhEzTeI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757596155; a=rsa-sha256;
	cv=none;
	b=GIZNfh3KocOteu/QNTe9ci+w9WtuVUPlDrWwuQNRfZGwcqYFN+gWEE/knaXDeWrC6LPxge
	++J+Jzd3V7kUgPfKmR3gI3RQM+6FxZ0UcoW7Tn9YLx3EYpmy3LPprz5ufCH+W68qSXSbMo
	uPMinI/yNtP3zmXxm+akCbjzFXcSqlI=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cMySg2y1Nz2CfyN;
	Thu, 11 Sep 2025 21:04:35 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 18C321400CB;
	Thu, 11 Sep 2025 21:09:08 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 11 Sep
 2025 21:09:07 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@redhat.com>,
	<akpm@linux-foundation.org>, <mike.kravetz@oracle.com>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [PATCH] mm/hugetlb: fix folio is still mapped when deleted
Date: Thu, 11 Sep 2025 21:08:48 +0800
Message-ID: <20250911130848.4087211-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EB02B40013
X-Stat-Signature: bcge3e89jw1od7sz9ksg971jtf5du86k
X-HE-Tag: 1757596154-567699
X-HE-Meta: U2FsdGVkX19KAyUWJh6ov+2tN6js8NB4873yI5zBBDq9G2rineKcGWmFda1/QPZiUaI9WgZVvHK2u24o0OV4i0uv6pE0hlZUznaN815W4okmLXS1a1VoK8CLEJEnoOcabX5Lk7B3gosCj7a96vnbGtQnBoojcGL4DsLfyN30idlTCxIclZi8aDc+bpOsJD1VhOWwpXKs8eXdLuKOZr6vMg9c342lwDAamtsbQCandqqzroV/FEWwtVF0/Ob0+WuhvGfZNEXJWiVPBrHTwHP0l5Z3CyqWub+g4zYGoQdGBX6DF3cqORk/R118CFKc0V+VLJZRFBNJTPotxT7SjRa+hskwNgsY5cSzn0jFVLgtpeLH3CmzUOeNeBaIZ4xYLazL9uF5S7ue/+ciDUnyffgk3/Ddc3HbkEV9gdXoShyY5Z12etuuS1aGbns5px27tNZQhuFHL3Le6kIJljoCdZQ6LS+wo/nKqnANRJS0abw0NzelDyN3jkuUU5DOA4HAub11HQ6Pcxzv2+UNbnOtGFGkeZCzaAnwgyltJQ9+rSZPV40EeL7wJz8g8oUEyWS1AiD1N0ymVyw32YXwqgvSElT4amgZolFQ+cx45boHMZJX7zGNg5/9pZOzhZL/GPgCyGvZFoSZdHmmNrZEBSHvEca3mCLExftaJLi5htOiZNvwheSqTTyeWh6Q9jMK/0/REhMQ/AO18EZbP/+AJLdCzCDV3Wxoz32pzPehs7TFaXKi+1ZSTyVfdh516OsmOedWUeC8yNOkPfoYZVI9LCzXg5R+RgGen99xQ4rEHpUovqw66YhfPm027mK8O2Uv9nqJE5TxZfQ4VzvPp2OMAXflBBxP/SPUC7EANxEcKJhZPBgkWaNE/QM+ctSpnvJXBLP68MSbEB5QUz0S+UlovlnZCuunsViSm1HU8y1Hzd0r6mVVnwaUExGBlj36Ry6E8Z+5wvJxvuN9DuxAFsNDKPKtgzD
 s0ELg7f3
 BDFBveHRbvmH7CMzW3yPVj8NwBS3V9FTQ+b0n1T/j+ErGzVemk6BWs9RMtKTUJ5KhwAC561Oat5ZIZvxzKMkWgvchQLWc7i53V1n2/DwWOct2uuP5G2c7FgOAYaSRJWpAPL6KWx6rcakjZXiAuZVLNb1FUpK/5xucX2el2Z8D7DBGmQD6O4sW6ytwFTP1TSVXVldS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Migration may be raced with fallocating hole. remove_inode_single_folio
will unmap the folio if the folio is still mapped. However, it's called
without folio lock. If the folio is migrated and the mapped pte has been
converted to migration entry, folio_mapped() returns false, and won't
unmap it. Due to extra refcount held by remove_inode_single_folio,
migration fails, restores migration entry to normal pte, and the folio
is mapped again. As a result, we triggered BUG in filemap_unaccount_folio.

The log is as follows:
 BUG: Bad page cache in process hugetlb  pfn:156c00
 page: refcount:515 mapcount:0 mapping:0000000099fef6e1 index:0x0 pfn:0x156c00
 head: order:9 mapcount:1 entire_mapcount:1 nr_pages_mapped:0 pincount:0
 aops:hugetlbfs_aops ino:dcc dentry name(?):"my_hugepage_file"
 flags: 0x17ffffc00000c1(locked|waiters|head|node=0|zone=2|lastcpupid=0x1fffff)
 page_type: f4(hugetlb)
 page dumped because: still mapped when deleted
 CPU: 1 UID: 0 PID: 395 Comm: hugetlb Not tainted 6.17.0-rc5-00044-g7aac71907bde-dirty #484 NONE
 Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
 Call Trace:
  <TASK>
  dump_stack_lvl+0x4f/0x70
  filemap_unaccount_folio+0xc4/0x1c0
  __filemap_remove_folio+0x38/0x1c0
  filemap_remove_folio+0x41/0xd0
  remove_inode_hugepages+0x142/0x250
  hugetlbfs_fallocate+0x471/0x5a0
  vfs_fallocate+0x149/0x380

Hold folio lock before checking if the folio is mapped to avold race with
migration.

Fixes: 4aae8d1c051e ("mm/hugetlbfs: unmap pages if page fault raced with hole punch")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 fs/hugetlbfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 09d4baef29cf..d21865d0178a 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -521,10 +521,10 @@ static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
 	 * the fault mutex.  The mutex will prevent faults
 	 * until we finish removing the folio.
 	 */
+	folio_lock(folio);
 	if (unlikely(folio_mapped(folio)))
 		hugetlb_unmap_file_folio(h, mapping, folio, index);
 
-	folio_lock(folio);
 	/*
 	 * We must remove the folio from page cache before removing
 	 * the region/ reserve map (hugetlb_unreserve_pages).  In
-- 
2.43.0


