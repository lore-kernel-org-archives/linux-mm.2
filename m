Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED40BC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 04:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18E36B0092; Wed, 16 Sep 2026 00:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA9D6B0093; Wed, 16 Sep 2026 00:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE09D6B0095; Wed, 16 Sep 2026 00:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C17246B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:32:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28BF6A05E7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:32:10 +0000 (UTC)
X-FDA: 85218353220.23.75B8842
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf19.hostedemail.com (Postfix) with ESMTP id AC49F1A0002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:32:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cy9B60DI;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cy9B60DI;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789533128;
	b=oUEOud5TN01ghXCN1Xjn26uhbql94S6GCGk0Qv6rILs5CzQo5qlOAnPK1bmAntbrd4ZqUn
	FhZlLiFVCAYCVjV/pqoeoTG/d+GUoNS6InMuMTygAQa3z7gGskOpbaB8LIqF26U2SY5Mae
	ChgY9Wk7NFZFChO1ZdNGPPzAlCEeflE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789533128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9/c1adfgjsb6FPiBJvtl+eZyAKDB2RVDhOXA+txTUiE=;
	b=bUiuUd3McchpzVrVdNcO0WseUUC6ObNjicJ1PmeUntag7ID033WSoRlwtIqCoV4cLEOoxl
	3aEacNc8x1nGd9Y48BuGNVNJNQARGGYGxu7gcEi7qaM+Tl16IeSi3orna9DYHhgye16wuQ
	WGSmWoxrnjyFJ8vQk+KCBG5J9EQSjqI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9/c1adfgjsb6FPiBJvtl+eZyAKDB2RVDhOXA+txTUiE=;
	b=cy9B60DI9e7Tx5o6K0/09mdhPmmyJxW2rmYoKTkHRTS4Om/7hNoRWqxht14HzJ1taoeXRG37m
	4iM/hzabtj3ff7KFPctdqg/wO39bfBCP4azFnSyr0y/0CmMvUn+N2FG4ERDTl+Ysqre/A4JBQUa
	euiJOmBBExhe0ciyRjEzask=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hl5Kk2yZNz1cyPY;
	Wed, 16 Sep 2026 12:20:58 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 47A2C40578;
	Wed, 16 Sep 2026 12:31:56 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 16 Sep
 2026 12:31:55 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Zi Yan
	<ziy@nvidia.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH mm-new v3] mm: mincore: use per-vma lock during page table walk
Date: Wed, 16 Sep 2026 12:31:52 +0800
Message-ID: <20260916043153.2631696-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspam-User: 
X-Rspamd-Queue-Id: AC49F1A0002
X-Stat-Signature: yqzupkpxi4opwhrex4opkwparhnztwsu
X-Rspamd-Server: rspam01
X-HE-Tag: 1789533125-167316
X-HE-Meta: U2FsdGVkX181XuA9gb+JEfyGG/dM2owqe0HHm7DTrnBjlebCGg5AkriXhb+lzDDKCH7n7e3QaWFgwUBPPIOGL2lH32omtpftgdAZGN3V+ApBI+45d0YUNd6Bmyphvr4bq1UjFhn2IL3f2sP0elI+HfBDzObamZ/c3bcfWsWumFEGzY0SgvJY6bnt3nR6dWKjzVxKiy9VZiCO2Bre9Rj6N7K70Y83RU9h7R2mZhemWfBsmorUgPqbhTaphpbMxNkcYe3r8TnZPUlWqjTsT0pK5OUDJY+7uTE30Eiv9p8iEUEa9kF5+dhQvJEPoBc04vVumnIL/73H+tBTqmR6eJ9mTFCFnZZYpn2Uh/HXp9vQGz9k6xR0SAoOqjv1V/rWB2MTZEi3jNBELI8KWRWOXd85maBDPzK0A46yS8gUKCYfC68r12nYBgSdTFuReYvvftHBZDt5JhNT9mh3jJEbqlmf7qWMJLyc46/xlJkFdtSluHs43pwtiQiclO0I+Z66dYalZUvP9LIU9gt3cvQnYdVtvjOC/To368EMxC4cuTApUaTGFuXBNkLA5e0gPeBTYRtrCU7oTzym3SGptWCF2lmGBS35tdQYo4VQ5yeSWza/5EcJeTDt/3sMX/iT4pjMYE33mAvGlAdW/zw6AlGf3cY58RNhjlumuLluajJ8tvi0XegPDzh/KOwi6hg9lBqysom9rkZsEh6ZEjHgBYafrTg4TOFSVVZbyARa9tkdC5UvZdVHcwct7rFZJ7ZIUp+1kirZsqD8WLtymmUCXyeMoEnIwXB/V4Nz2UKNOthf9kLSjTgChIYE16Lfzp+wYhsoLdQjM3cHn5mnYumj2XCxoZ2/6h5PWSsX/vK04zRSZULBdkN5Ny8LgKYW+yNO70joSFcbukO/50kdM350muUFTNGxJYta59e2BuDwMErpQ/7NUYI4tRMDskqjGBuzgwq1WBkMEGLRqrdxCJOCdOd/qBY
 IWuHeK5q
 OwZJu3OaVJfH00jSdMmkEOEYb/JwJdpWzXWxe61nCGbi9hD9psfmLF/8ovjEgNe+OYx9Y860AVbFHV9XDUGhOO+Hk2w63I12UK+xK5jtBSobEpYrmtbgz48yAWrMbVt0SfXJLpYx2U8jzNDRpFg/tP9VBCRZmfs9qxAMlA2wV0eSEVOMuE/8sr91LAWfdBQreXuaUFGoRuxr3C/Mzn9gf2VqsF+HUn7uvK5TTOEM/P+SOtglx2M6londUaOGujFrQ5m/CBAgogXYJL0WlynjH2qpw9Cv9ikobd82vlNNbOmHPTYgWSmSMa2ZD8robYn4cfpfy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_mincore() performs a read-only, per-VMA residency query,
making it a good candidate for per-VMA locking. Convert it
to acquire the per-VMA lock, thereby reducing contention on
the per-MM mmap_lock.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
v3:
- add vma_assert_locked, update changelog/comment, per David
- Add RB 
v2, (RESEND):
- using new vma_start_read_unlocked() API, suggestted by Pedro Falcato
v1:
- https://lore.kernel.org/linux-mm/20260701144047.3786939-2-wangkefeng.wang@huawei.com/

 mm/mincore.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index c086836bc4bc..0fe50f8a7e62 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -235,24 +235,22 @@ static const struct mm_walk_ops mincore_walk_ops = {
 	.pmd_entry		= mincore_pte_range,
 	.pte_hole		= mincore_unmapped_range,
 	.hugetlb_entry		= mincore_hugetlb,
-	.walk_lock		= PGWALK_RDLOCK,
+	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
 };
 
 /*
  * Do a chunk of "sys_mincore()". We've already checked
- * all the arguments, we hold the mmap semaphore: we should
+ * all the arguments, we hold the VMA read lock: we should
  * just return the amount of info we're asked for.
  */
-static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
+static long do_mincore(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pages, unsigned char *vec)
 {
-	struct vm_area_struct *vma;
-	unsigned long end;
+	unsigned long end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 	int err;
 
-	vma = vma_lookup(current->mm, addr);
-	if (!vma)
-		return -ENOMEM;
-	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
+	vma_assert_locked(vma);
+
 	if (!can_do_mincore(vma)) {
 		unsigned long pages = DIV_ROUND_UP(end - addr, PAGE_SIZE);
 		memset(vec, 1, pages);
@@ -319,13 +317,20 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
 
 	retval = 0;
 	while (pages) {
+		struct vm_area_struct *vma;
+
+		vma = vma_start_read_unlocked(current->mm, start);
+		if (!vma) {
+			retval = -ENOMEM;
+			break;
+		}
+
 		/*
 		 * Do at most PAGE_SIZE entries per iteration, due to
 		 * the temporary buffer size.
 		 */
-		mmap_read_lock(current->mm);
-		retval = do_mincore(start, min(pages, PAGE_SIZE), tmp);
-		mmap_read_unlock(current->mm);
+		retval = do_mincore(vma, start, min(pages, PAGE_SIZE), tmp);
+		vma_end_read(vma);
 
 		if (retval <= 0)
 			break;
-- 
2.55.0


