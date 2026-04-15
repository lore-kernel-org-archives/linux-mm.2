Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D4EEFA0C49
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBDAE6B0092; Wed, 15 Apr 2026 04:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6ACE6B0093; Wed, 15 Apr 2026 04:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81416B0095; Wed, 15 Apr 2026 04:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 930746B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:23:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 345DC58A8F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:23:18 +0000 (UTC)
X-FDA: 84660100476.08.5BC664A
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf23.hostedemail.com (Postfix) with ESMTP id CB271140002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:23:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=itlSL3vv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776241396; a=rsa-sha256;
	cv=none;
	b=WfOLlBv9T/Q1zml7n9X52UWDsxJuMVHwRprfwlZCfdMhx6w+Pu8dKYA+YZWMQB3OX1cZZf
	LRb89CnMwbD41NNFj7NBfCpY01aeZe8tchjKjQMKqZBmLQIyRM4O+bo+lq37xqg/+aIAjI
	CgO3sZvurwG8qgjczc2HmwqbrtmRiRc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=itlSL3vv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776241396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=A8Fw4KmSyuAbOiS3O+gulAryWNIqUKLF+xq8nrDzkhw=;
	b=SA0r+9W+pduw38noi1fG9m2Jh5kUI2AbijJp7MzYrkBWKRtm/nm4AaVuzMwUCpj40Plj1f
	dZjyVUm1ut17DhF0MM+wTaW+iPWd6k6C436yXTGiiaq2Y5n9hj0zAUvKtbvo+UrHuuo2Kw
	zpewESOn0d1yK3OYUQ1G032H+Jr0e3M=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776241388; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=A8Fw4KmSyuAbOiS3O+gulAryWNIqUKLF+xq8nrDzkhw=;
	b=itlSL3vv6rT2TYzHYNjun1V6fFjACIOvUqPsHmxyr+6lAHY79SlGTpTDrr8ZTmxxzqL17KECLivpmhuyFVATwXYarc5YTtGqQbHn1QyWy9oVJvB1aDgmtcwMoHK1gB9MJK1IQplRDqGMfAj83wMfjL+1IbI4Mx5rXSkQB0Zl0q8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X13xQlN_1776241386;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X13xQlN_1776241386 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 16:23:07 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com
Cc: willy@infradead.org,
	ziy@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm: shmem: don't set large-order range for internal shmem mount
Date: Wed, 15 Apr 2026 16:22:53 +0800
Message-ID: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CB271140002
X-Stat-Signature: g7dy76n1hj9xtkifxswkhabyiar6gtqj
X-Rspam-User: 
X-HE-Tag: 1776241392-419530
X-HE-Meta: U2FsdGVkX1/CsKcfVHotPHRim/MsfQOzcc0HTbdLQlgyZ2uviHPKfunPYxRjSYGSZDo8zVdY/gEHPkO5HYcFkpLKqRcprXw9RmBFlZibDQ9zkrlwT7gZdfOCpF5ZjZsEDd6qyGFbB+tcRnfn8hwGHabj4bIOeTLP8gqcBh6sxUPr5P7VMb1rYf601GPQSyiCCiATbiDW84BxbQWz0AbEbStc34U7zxThfm20ksF8LubmTMDJkiM0M2O0uXE97IN4SX4Du2gFZ0VchJ496GBa6jQR5DiZtSYkmxFkAJqdeJGluF39USi9y2TJ0lx1HjWSjVxHMtdpEamYoNJNzAgf0dUxPm+EhxYkjFOvxMmUhBzMhVEIm6+p6wzbtcGS4DotbPhgG9s43kyIwGXcvCKBMMA9STm+RoGQqxbpA4i7QgGlO7WBCfI5Er5mGnudNv8Lqhlq+TKCKVQOzHhXWq46qpeSRvHeYF7Uj2CQ2ugJkPchfEbLlDmZGJ1LgTGZzCkkfLSxzLjp6s6NzBsJkYlibRqciWrP7IyJP+tpHc3gD7qsQbVY7NNRhvKgnZJkTYcuoboqSScN27PhApKywWznqzlGGqeSx1OrAtfH1d+DlVxO4b/F3BrsdV9dQgGWznkZ6MxYC6DicLw1eAvw+eUbMHFm5rv8VM/v7sMXxcp83vpwUQunpmIBRyGD8V2pJ7g7x76PB09PfLbszcOLx3+rW2jNZv4XtBdUL6+NwXjAKlY4kthHj6eE/1kQQmZWyHhGazHHOJoQi6NAB7tD7RHSXM9UbP23MWQ/g5pHUTF7ttiiM3FaqTX/pnTY44l2sRj0qvMRdZFyHNG+iqiUrJWuc1A4Sm146SgPWBodGbu5S1pzO9Xm/q57S6nfnpUMUhBMA8YAwhQ9RrsetwsJBkYgxhvBKevq1/TrtQ+dWRbVZNAOrL+HKzyMsDXPmmFhLhOqol7WY/RQJb3+FYx89Zj
 +Zz5oOYc
 KLBxKFAz9My3dIi9c+q1LrS1NLB/Na9EpvUGZKgnjLisA/Oscow+ky+rvASJ5y1DNj+52xRLJqIHo1LbX6LESgmvbiOl9ZpxPuqx87DsOD5v8vGkqLMJ1z3dTfXGXct7kABP8Zvv6fptTzjXHXFBWsAvbO3m0rFXeH8IZDhTdFl8BWWmWMRK3OdpEyQq7Hczzn8uiUM/SOPpFR/z1RegWfxuT1whEGb7X+yglaol2QPrsdPaxDAhk0L2iLAZB5H+lKWC3XGWW4iTcJVme2g2xkpaNOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Anonymous shmem large order allocations are dynamically controlled via the
global THP sysfs knob (/sys/kernel/mm/transparent_hugepage/shmem_enabled)
and the per-size mTHP knobs (/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/shmem_enabled).

Therefore, anonymous shmem uses shmem_allowable_huge_orders() to check
which large orders are allowed, rather than relying on mapping_max_folio_order().
Moreover, mapping_max_folio_order() is intended to control large order
allocations only for tmpfs mounts. Clarify this by not setting a large-order
range for internal shmem mount (e.g. anonymous shmem), to avoid confusion,
as discussed in the previous thread[1].

[1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from v1:
 - Update the comments and commit message, per Lance.
---
 mm/shmem.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 4ecefe02881d..568e1baee90d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3088,8 +3088,16 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	if (sbinfo->noswap)
 		mapping_set_unevictable(inode->i_mapping);
 
-	/* Don't consider 'deny' for emergencies and 'force' for testing */
-	if (sbinfo->huge)
+	/*
+	 * Only set the large order range for tmpfs mounts. The large order
+	 * selection for the internal shmem mount is configured dynamically
+	 * via the 'shmem_enabled' interfaces, so there is no need to set a
+	 * large order range for the internal shmem mount's mapping.
+	 *
+	 * Note: Don't consider 'deny' for emergencies and 'force' for
+	 * testing.
+	 */
+	if (sbinfo->huge && !(sb->s_flags & SB_KERNMOUNT))
 		mapping_set_large_folios(inode->i_mapping);
 
 	switch (mode & S_IFMT) {
-- 
2.47.3


