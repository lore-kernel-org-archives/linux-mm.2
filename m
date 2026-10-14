Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5632CC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 06:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12CD6B0088; Wed, 14 Oct 2026 02:27:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5616B008A; Wed, 14 Oct 2026 02:27:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9FC6B008C; Wed, 14 Oct 2026 02:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DE9C6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:27:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1BD2D12044F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:27:28 +0000 (UTC)
X-FDA: 85320250176.10.E0B87E8
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3290720009
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:27:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U5WQBKp+;
	spf=pass (imf03.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791959246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nA0Tq6TsyCuuH3RRXnooXAd6RrQa+o73yVVwUSKY6AA=;
	b=wShCMH00e2adUWQNkHZG2dZCGyHVajz1bdw1VD+8dWerHyc98tRjkrEPfSZzwo5YlwKKxt
	QgebHxfLZ7JGAb/6qF6TlNESSwgm4ka8RyYllSINantlEKoMN9JztZVnS3AzD0W+H3BbT3
	K6o+KrF+isTDqSslhr0J8fMVIxiNmGE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U5WQBKp+;
	spf=pass (imf03.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791959246;
	b=VSCtegLDPWPb2G5K8Fp5pAlwQrCv8rxxwEjcC70RRrxP3ov7JvL9vjILqR4epHEhC6aZrB
	kY1kqZ5EZbdyohA6VUNSZ2xMPB9JwAteME7Y8Wb7Yzs0IAmdQM0NF4ueQmEYy3TzLM3ftG
	yJbxaAIKU9ISdVSvuy9Qrnikn9ULx5g=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791959239; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=nA0Tq6TsyCuuH3RRXnooXAd6RrQa+o73yVVwUSKY6AA=;
	b=U5WQBKp+ptqKFtG9k5ENjEB2UuK64LKEeSKV8b/ycvsMpRO5kPJRoNfttoirzeDCJMPA6Zi7QWTY/jWHo3Z2MueTU7xP4+fwMgTNXl3uyKVH0/8tEWsS2d2oFkXXGCAPCtMnqkQZ4iRpl+L1ZVGLe/CBrcHC7pYL/CUpjb2T5xU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0XCo6Yfx_1791959228;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XCo6Yfx_1791959228 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Oct 2026 14:27:18 +0800
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
Subject: [PATCH] ipc/shm: fix RSS accounting for hugetlb shared memory
Date: Wed, 14 Oct 2026 14:27:05 +0800
Message-ID: <20261014062705.1997201-1-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3290720009
X-Rspam-User: 
X-Stat-Signature: yagkn5sho3rn15w5agy361nuk1mu794r
X-HE-Tag: 1791959243-844609
X-HE-Meta: U2FsdGVkX18C0/mQCByaSa97eiX9cKXcjUdyPWYexm8sgPGq48evH8cxK0tvBcJzvb6AoMvHM7Agk1KPP/c4a/ZTVVADlBdkSD67/PeuVqQLNBeWCch6S9AbAZX99NwNyxdK1d/QcL9d1I+cbJqebAkzKp6J/CCiZsWygJPU4V94uOFqUf9rWPUbiRUM+Ke98kLHy+Gi+gaLlol8Egklst8jg10rhgSWYn3dv9t0NSIHirY9st+EsRldpFoH7KgGrTzDTbylq0DSDEwRv/x3UTAguGIhmc0m5TmFx7/hzoviQpABGje6/5hMkgAp0QHaFQbIBkTvGkqJ7ZMg8zQsDsQqlL8wk76ich3AW3zMcB+eJFAUvLx9jARbDdyhEfmsErIo0hNSNwzxNngw+Z3+u2TFuciqVj7T9w/Xuv549HPBmdXg+BFyVhZLFcPts2ht7uhfgT1Q/nkMNruwFQXUPGjesqNg5DlIAjs6pOnkAslP7I+yJWHYXpAA3hHxuQTXv7BIWOe8+aNkw3ny5Hv9b0srCsdPJtVOgcf0Pm0fp6im8hCMEei88WT7n94+OeARLf6rk3BGRzfOMrNHYZ7p4MIJKLWIaQa7VDPyGswGbhiUGrZgvEoxl6TMB3jqdWP/TRHyNW+g84IOwfICo54l/s5LrbF/ZlVz8mvLGwugH3MsCaa9vWWMFkWmnilqxoLP595t8FL+1wwbclRYMgOdpDXEdJAIZy8EmMTwL5c5PVV/Wi5HsffYJyZP5HzcMCPREPDxaVZinRrwgwCAKGQVB4HuDqQMEd+SN3JNy49heEu34k60fUX4G3Z3ULdZSlHyQYlDwgnwLX42wIbvaRqDB0BghMzfh6u/n9ij9JrffCwRaKYQqNyM4nc07pyvG5XAXfY+Mu87nxJvPbInMSU/vpLnIwYE1RnQDiXxok173hz7Fk0CiYsCvsOOmQrA39vyFE5qWjQU1xOrwaCIkHK
 ID9WrEwr
 ptSXMPRP3fXwA7mcxQL0G9IiEx4v3mAn76kwJhaFxN0Qz7a0OWORs4uRWIo6EazIhTJ7Xh2omNJE72V0FL9j2Qgbr8SC/Hzu/IMQH/3MpR0kPBR6dFzvL0QkOETvW51OBecliwcYzfFKP49AcMc5yWos6UU/RoWDBLPn5KN8VdmN11LlDNvYm9HTk4xHeXXKGSwSFCbCoWw438vJrkRadWnzZ4BjjY1UYPcQ7Cjzis9Zd4AWmz7vdodJNa55ptm2jIgU2
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

Use mapping->nrpages directly and remove the unused hstate variable.

Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>

---
 ipc/shm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 25190965c9a50..5ed2beef0f1d2 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -943,8 +943,7 @@ static void shm_add_rss_swap(struct shmid_kernel *shp,
 
 	if (is_file_hugepages(shp->shm_file)) {
 		struct address_space *mapping = inode->i_mapping;
-		struct hstate *h = hstate_file(shp->shm_file);
-		*rss_add += pages_per_huge_page(h) * mapping->nrpages;
+		*rss_add += mapping->nrpages;
 	} else {
 #ifdef CONFIG_SHMEM
 		struct shmem_inode_info *info = SHMEM_I(inode);
-- 
2.43.5


