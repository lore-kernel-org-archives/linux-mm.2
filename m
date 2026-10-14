Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A40CBCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54B46B0092; Wed, 14 Oct 2026 04:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05F76B0095; Wed, 14 Oct 2026 04:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4B86B0098; Wed, 14 Oct 2026 04:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 853F16B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:22:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 015A512046D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:22:37 +0000 (UTC)
X-FDA: 85320540396.07.1327BFB
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf30.hostedemail.com (Postfix) with ESMTP id B92DC80006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:22:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KYMeI4Iy;
	spf=pass (imf30.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791966156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9whjSmFeVrtGFJkwGOlXSWXEQUcqRKBWx6oJqixE8N0=;
	b=K+XxQ6eJF/4rCoLeGGG+34lx1fWVartRRFo9VOdpxCEBcCNu3HH0k49gTpRtFLMD2CA77a
	I0YHPe9fMgncLmdd/rDXTTfMkUV4kuXexM880pTm0DB/YQEdxk5R9Fan5IWOGtxkzxrU+j
	WISqqtT/kIjYDw54T1ccaFzsT94B5XI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791966156;
	b=CXEwfehcmwFeO0F2L3TsiNTBBVUEr9JFTC0x5OTB7fCzd3tCJU/eHpNZc6ihlbtwl2YekO
	sSMH1xEU4bSoQNvSi4cyJUxYv4Fx0JUK2qTdGS3RIRgMdiv0EhiIVaXHWTsk6rjoSm4ctY
	srHjY+igpzkb17jCPLUff+u1FH8/VY0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KYMeI4Iy;
	spf=pass (imf30.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791966152; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=9whjSmFeVrtGFJkwGOlXSWXEQUcqRKBWx6oJqixE8N0=;
	b=KYMeI4Iya8UqBihadkUPGAtLWzOuQokGOAp2me3UQQyvIM1daBjIIb4NhCEBDYFw2G7vqQKpJStDevYwPhpB6L4a7JhZ8si/4HqRkdWOW5ANr39Qk1XP+jbAvgiwq584ZZgorGnBzsBWOW/DMnfmld1xeUj4ZdyIv/jMzKjJUNI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0XCoX3b3_1791966139;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XCoX3b3_1791966139 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Oct 2026 16:22:31 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dan Carpenter <error27@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Weilin Tong <tongweilin@linux.alibaba.com>
Subject: [PATCH v2] ipc/shm: fix RSS accounting for hugetlb shared memory
Date: Wed, 14 Oct 2026 16:22:18 +0800
Message-ID: <20261014082218.2236088-1-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B92DC80006
X-Rspam-User: 
X-Stat-Signature: 8g6ce34wqype45mkh5t5be3fcgy7zznh
X-HE-Tag: 1791966154-486545
X-HE-Meta: U2FsdGVkX1/PisUxN3ixG8kFnja0zPecsSGemseRUSsDeiR/AIohVL4VbpylxhSSYaLird/HTHXDVXirAhJVpigE+x/mPQgziK3qAd38fiXYmYrGHLOi+zCiJfCXAUE63qwvNkd9LYEzl2/rxxnuHV/VpmkZlf0oJekAucwUpEmkVWhoGCRJ+xYOqXNR8rhgjv9966D9RN3YSeNSs6p+sOddWlBKsH81EA7BS/07c1nCFM+D7xQ1vjuXrHBuyJoclc1wnByNHWOqpaao3JFwm/glfUYavDAoAbefcuzSKu9osxyYAW/40ah9o2ToiE7qmjeVYLwikc9fvpWwFwyXRhk0h4L3Tpx1yjH2AIVwSjXM0STbYY432slocvM3jVfkJEK//WsY/6TsEhiKajcYcws5mkiX78JK/d5ueqJ0o9Mb5l+jt4W35J0pKI0dW0zsZGxXv/0KjHM4B7IfT0LEYO3kPGWWUHjh7o47crDY37+j2aRnbQRIkNyZPmnMmFd+DV7JQsXDM55ltEVMd7BeME5Nq37y70aBXZ+NXB818eJuUaGU5qiS7v1FLYStblLiBtUbIXQw45JPy29iskWlv95OWrRORGsVhm5KofIF1/1aBC3yXG6orqfUHg5UWvpRjlELk/FFwm4KjAVh5AY2ZZ69u2maYGc0uq3fppY+bSUaGhiQmBUSFCm3ZTSauzNxuuq4WbiW7ALOFxMO/0ibdSir63b9YEMTfhM05KKu/nP8mvspht2vuHheymf6uC9IAUCmtOEFwZY26fFpauytrKHQQxizq65ao0UPgPfqSTJL85Byn6VHuU8uv95ne3w0cEynAhOEDMdg9uzeTVdF32N8h7hKyyj0NbOPhQHHYh4GedgVXJmIzHjp9/zsdn8GY18PwsSS2fjKKIr5GB/n9+EKKoz3OulfA1vY+umqGSC9FOswZOW/xCbs7zeCjFciTBUk5qpMuWcGeuPe13B
 IFEX32vC
 lPMol+VN53oW7+UqcVbZUrlVw35BaNq8HZGYlLwRD5NGpOxqo4uutGVZpln1pplf8p3MfdJDw+svAZmWSowifVlTpaR+2TcLegb6vHDDW+7Wk59ZOjYlwGGR6+xH9axQh384gpd6sQxWRdcYBZFGSRoN7pXAVhRd66rnwpls/uh+rI2v1bAYKbhK8iJxMs1Cig7QDve+0aDGGnHRqzmugDl0lu9r27doVHi94dFFZep1dPAuhgMlTLZla9P8gOZsLUJtdm+f+wtEfICd5OD6Y8dq9iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in
filemap.c") changed mapping->nrpages to count base pages for hugetlb
folios. However, shm_add_rss_swap() still multiplies it by
pages_per_huge_page(), overcounting RSS in both SHM_INFO and
/proc/sysvipc/shm.

Use mapping->nrpages for RSS accounting across all backing types, and
account swap only for non-hugetlb shmem. Use READ_ONCE() for both counters
instead of info->lock, which does not protect nrpages and cannot provide
a consistent snapshot.

Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
Suggested-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
---
Changes in v2 (suggested by Muchun Song):
- Share RSS accounting across all backing types, leaving only swap
  accounting conditional on CONFIG_SHMEM and non-hugetlb files.
- Replace info->lock with READ_ONCE() for both counters.

v1: https://lore.kernel.org/linux-mm/82f099d8-e46d-481e-bba5-95bff118ffbb@linux.alibaba.com/T/#mf511e253ce84ad64a9b7fcfe7bff51bc7ed23f12

 ipc/shm.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index bb1a721..6862f68 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -936,26 +936,11 @@ static inline unsigned long copy_shminfo_to_user(void __user *buf, struct shminf
 static void shm_add_rss_swap(struct shmid_kernel *shp,
 	unsigned long *rss_add, unsigned long *swp_add)
 {
-	struct inode *inode;
+	struct inode *inode = file_inode(shp->shm_file);
 
-	inode = file_inode(shp->shm_file);
-
-	if (is_file_hugepages(shp->shm_file)) {
-		struct address_space *mapping = inode->i_mapping;
-		struct hstate *h = hstate_file(shp->shm_file);
-		*rss_add += pages_per_huge_page(h) * mapping->nrpages;
-	} else {
-#ifdef CONFIG_SHMEM
-		struct shmem_inode_info *info = SHMEM_I(inode);
-
-		spin_lock_irq(&info->lock);
-		*rss_add += inode->i_mapping->nrpages;
-		*swp_add += info->swapped;
-		spin_unlock_irq(&info->lock);
-#else
-		*rss_add += inode->i_mapping->nrpages;
-#endif
-	}
+	*rss_add += READ_ONCE(inode->i_mapping->nrpages);
+	if (IS_ENABLED(CONFIG_SHMEM) && !is_file_hugepages(shp->shm_file))
+		*swp_add += READ_ONCE(SHMEM_I(inode)->swapped);
 }
 
 /*
-- 
2.39.3 (Apple Git-146)


