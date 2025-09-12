Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95EDBCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 07:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C630D8E0008; Fri, 12 Sep 2025 03:42:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C136D8E0001; Fri, 12 Sep 2025 03:42:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B507E8E0008; Fri, 12 Sep 2025 03:42:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A65068E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:42:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3439086F03
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:42:09 +0000 (UTC)
X-FDA: 83879804778.28.52C3533
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7228C40003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:42:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757662927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=GlmP2nWQh64R8U217Dl7XmUg2v+K1kdUzyCgxMJjx2g=;
	b=fKfH2ypNpc1oxrMLFAoS+o4mbxQ7L+rFxq23YZHtk1Wn7k70ZiexDoK4By0YzKNQnElIUE
	dKhZzJA4UKGAOCNPzAlWqR/htRM8NwuLWlggCZj/A2bVztxtYOeXbcSMMcZIVk9/Iki9+Y
	v+6SWZP7tIDccgzG58IZlUfGYNPSxXA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757662927; a=rsa-sha256;
	cv=none;
	b=aU/bLzZOTCQhdsZ8ShLN/n+gbUL1JqBZsJuXb27EbRL9IadKsNu+eoNvHg97iRKH5nZoWB
	DWBQaWtV7zvS0X29n91r5uGBCCsMZfOWg08v7iwqv1MKFYgUguWe9m0MSB/hWmmyXY7tAb
	AqJG9eHlve6Oq/aaNaojOUhb2NcgTAM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cNRFl4LCTz14N32;
	Fri, 12 Sep 2025 15:41:47 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id AD996180B53;
	Fri, 12 Sep 2025 15:42:01 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 12 Sep
 2025 15:42:01 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <willy@infradead.org>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<david@redhat.com>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [PATCH v2] mm/hugetlb: fix folio is still mapped when deleted
Date: Fri, 12 Sep 2025 15:41:39 +0800
Message-ID: <20250912074139.3575005-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: 8wk94tny7pwchn1qpubxwja55qxf7wae
X-Rspam-User: 
X-Rspamd-Queue-Id: 7228C40003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757662926-493463
X-HE-Meta: U2FsdGVkX1/0lTDTctsVSToqbu+yqgxmLi9ktezQdUaFAXhe97mM7aLJzwfDls67QAKxJASZlbJJP3BSLF6hxKq01M04VHW3sAoK+eP/39gTCWqFj9HBXb9oD2d+7rplLZHeVesB7DmDIVYI+C8AezanyWyq24A4gEPQBqNaKFJRmFvyxetcD6uuGqo4ap6Z1MZW8d6Ug0tYwHuotWcKBSN3v0pgrNNSekNdimZl+vFO4lw/GxYFYdNU8U/wrOC2DvcNgJYkQHvAyzw5TPAGSGScG/Omuwbode3bUNynY3lmGhhfstciimd2/UKQk3IasBUayfSOElmqlXwpFIQONLCt+dVXbb30/AI5etyLrEGJHlM8DnjOWcqsDcmR7yxWy5/Yn/63YcnC7EOuaYmf8jssWyTKpS2s+FBuqHfRKxxxsBdPTubT+Go/MQqRBUrchD/1/gO2/9g6bOWpLi4ry6xniyGj6xXc4ZQe9DrnJSeJDsgdpFDdYbCoYuugE0kQmb6IGp7iONPFFrShKITPQleEuPWB96V2oEm6UXSPCbM9EBmCDX7zdrhi6hGGD96D65IXF5TpqW8kC2q0jFC535EzPw3Ct7aENhcCTIyYnHtK9ayp14gDoBdK+6+Wd2HpQD24Dex69nQ2bc0rH2f9dhVKRPAWsqaF92OYlMQVOf9OGZfLHe+pCT1ly/iTqbzG7gPvehoplec7pnPDoDg+RGGOQ/83SrnsieDUEdp2eNKqG3TOesrzbFQ4fMwHZkLyUFYN22UgVFh55Ccz0riyBmv8OEuNseL4oLd6dtbGG7DWRKwDAYG61NyBiSFjw4nQV2hEld5h13Tn+MFPdmcZ09gyhtU94gTIITxe+MX8hsMX3d8b+xFf+his91DNiwFXX5JDw9mCNXKYIExceYS2JBlHOUCzPffxkcNsgReaVooOzseY6QPDGUArvDs4McDuAFYPXl/tuUKlfhBAgjG
 5kJ8m916
 dCmZ4zl2sxn1RsHdasSF520kC/F3e/65l97Mhjo+8xjSWQxpQHxsLJGaAEB+d3x4dZX10k19/8l+Pv/IfTNjwCTOCwSro7sxgARZ2p/7+0ivjzJwZ3YzHQ7/n8dimClfJRcR+Tn6Xg+IX31R6yi4Cwfd/ukrBD77KCtWQfLq42GXcw4LPo3XwpcLJbmafYhmSBZkZ
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
v2:
 * update comment.

 fs/hugetlbfs/inode.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 09d4baef29cf..be4be99304bc 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -517,14 +517,16 @@ static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
 
 	/*
 	 * If folio is mapped, it was faulted in after being
-	 * unmapped in caller.  Unmap (again) while holding
-	 * the fault mutex.  The mutex will prevent faults
-	 * until we finish removing the folio.
+	 * unmapped in caller or hugetlb_vmdelete_list() skips
+	 * unmapping it due to fail to grab lock.  Unmap (again)
+	 * while holding the fault mutex.  The mutex will prevent
+	 * faults until we finish removing the folio.  Hold folio
+	 * lock to guarantee no concurrent migration.
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


