Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1607CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 21:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DE248E00B1; Thu,  9 Oct 2025 17:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867B88E0002; Thu,  9 Oct 2025 17:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4BE8E00B1; Thu,  9 Oct 2025 17:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6403A8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:20:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3923046A1B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:55 +0000 (UTC)
X-FDA: 83979845670.09.A1FDCA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9715C10000D
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F4s7+kv8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760044853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RNU0Z1gXN555yaj/FCQFe78utr8NmTahzs6cVbvl5E0=;
	b=vQQjARJ0hpL/JY1c2CmFSY8cPy7mtWKz2q7RYorI4cMTnW7bScZp64KFMXpvmvytN6Y7Kn
	ItHgiV771IsfUnnYMYEpytdug7mV0nWMecRLvbGO0pjzjMYkeObN+rg47cEWArQfWdFblJ
	RY3UlwAtU4xRd8ASXttIqO99n0go2CE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760044853; a=rsa-sha256;
	cv=none;
	b=OvbItV0nrbXk2LYCvSjYtyLikew/NL7pn24fBZNgXjJxaNLVifBQ6yrN9fFsxrhZuKcXAC
	ZBVM62t+kz9Ky5tn8+06KCFFhMCnRDI+4NB2Rrks5fTD7T7sGMUVJXOJaW1OpBKetmpWFn
	7gIcRgvp/f/wBc+YFbmjmCHHX4K4eQo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F4s7+kv8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0E7040880;
	Thu,  9 Oct 2025 21:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5466AC116B1;
	Thu,  9 Oct 2025 21:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760044852;
	bh=lWuxWajqY0wRfIc7Y8gXn7A3jSIMXiwp/Agt3iLR4VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4s7+kv8TSItrEO/33Tty5z6jdTawVF4XjHqmKPEv748eygzP5rt46knLZjDqjSNq
	 9CjXV+5I0EkFy+mj/YSUJ1pMEdbw3hbijefv3pyYfmQ2lRT/mKomhuGb7keuaOLVnG
	 gEZX/KgthWsRjb+91b3zKHQbCfi/3Z+rq1wwEmCZb2f/dMOjqwX8vDf8Lq7I1SbbBN
	 nr3kHS+RcLRNnx95v/Uq15OAQrK34oPCVAAPCdsnFpRUvHo/M9KaLWDJa2i9skPz7H
	 slvKE12ysSoF2MAoOeX3vv1bH4kFDtlw12H6lQkeoAUt6X4VN0ZPG5bXmSQfD0O83Y
	 I7RyBduEJ9g2g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 04/10] mm/damon/sysfs-schemes: implement path file under quota goal directory
Date: Thu,  9 Oct 2025 14:20:36 -0700
Message-Id: <20251009212042.60084-5-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251009212042.60084-1-sj@kernel.org>
References: <20251009212042.60084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9715C10000D
X-Rspamd-Server: rspam02
X-Stat-Signature: 539mn9aeoqyt81u8p5xer9g1pnbcq5xs
X-HE-Tag: 1760044853-415199
X-HE-Meta: U2FsdGVkX1+eJrtaRIELBocEFMvI55BwtOBIkrJyjyIMEaUaY+Te0iLemBvQZuEDA7IPZ+Uk4AFA6KKkbc9uZQ4ggnRG2GBBPJHoiyTu5L8+0XL+dWYW2LtMvh9Dk871QEfm7FDyo8ifkrOAb89w55ZxmR1H7DEfUF12TFOf3AExSoElFISNUjaCoyaT6W26qjRcpl3ENvCX9CIyshujJVH9EkmF+5LjIpOAd0YndihqnuhF4nXrc3+ivRyLGPi/RQhsCTW5Lb7ePOr/ouDYbjr+eClgI4r2ugjHjDn5eG3NKY4tH4O+emUGTn2iAU7JqzSS8wi+BgkrJAmKBROJZLhIKfRX8iQeFFAJfdA+O3meg/XlffezbbXVI4k/SWCmZnxgwlBHW4NIUjvJZweIylLLJuCA1wGb8sRfyGmpV5ReOnSYn0380UfFjie90y1zxFCD+MqJ6uaZdr/hosRzc6kmctxiAA+QNfQ/LqMiYU5JKvCt90W6In6Bn4KQIZ3p6EoXICSAcRIvoqiH998qsD7CqH+khrP3ATkCxBUzuZ2feqH8zocIVl+L6Cq6H/tk9zfacsg2eSAwTnedAFCXHcVOQirniW/qtnF/gCRsDQvkKgLJLWd9tkybzcfHpSTLm/fGob1MQlJREKZTgqrmssI5Vd46sm6v1CXPzFt9m6AcytIr79ynF7oRH8y18k0G6h9TJuzzeDQKBC88Ci23cHQNX+KCfO83Ma3MZdYd1DAiSmGViSY2oQbMWw/1TTMtpZkLsbx9THtKs4oaJmpj/dO/G+DmrI+xVwVhztqXKWfpa/K57yrP9b1xRLHkTVOznXJo8xge+MXfQ6g5mNYhmg2EmW5y6ZcB/WLaQSoio6N5tfOzuuziODv4oqES4wdTx10BK7L7qCiODtCeoZM8RqHhuqIu3FewjkVf4vycA88rWqF6oSkz2WgZNVyjQ3hVMgCIOhdPdUl4AJdfCJg
 +ZojLGVu
 06kuxhrF6ge2SeSZ5RwMibDIxlVrrunwklNA8a+5niecvfEwwY+TWS4trWEe6aGcKkyCvKGU97QSLILQLaRW0XxbY3WjfDTlMSRqPTDc4/6HDH16+y86OvhjrecyO3qhN0bS65f9v9f0jaiF9Y/yJxME7GlpQJwRrog+HD+6PKMchDZwcnWPc10pNBbpjFWR0kDG2CtsOcBOIa8VwWUPJRzWbDf0jbzEji0RgzVIo2HjrBS+H4HZHrR3yUwN+uz3DbdDKubCT+JYMOsA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a DAMOS sysfs file for specifying the cgroup of the interest for
DAMOS_QUOTA_NODE_MEMCG_USED_BP.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 6536f16006c9..2c440a2b80e6 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -999,6 +999,7 @@ struct damos_sysfs_quota_goal {
 	unsigned long target_value;
 	unsigned long current_value;
 	int nid;
+	char *path;
 };
 
 static struct damos_sysfs_quota_goal *damos_sysfs_quota_goal_alloc(void)
@@ -1128,10 +1129,39 @@ static ssize_t nid_store(struct kobject *kobj,
 	return err ? err : count;
 }
 
+static ssize_t path_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+
+	return sysfs_emit(buf, "%s\n", goal->path ? goal->path : "");
+}
+
+static ssize_t path_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+	char *path = kmalloc_array(size_add(count, 1), sizeof(*path),
+				   GFP_KERNEL);
+
+	if (!path)
+		return -ENOMEM;
+
+	strscpy(path, buf, count + 1);
+	kfree(goal->path);
+	goal->path = path;
+	return count;
+}
+
 static void damos_sysfs_quota_goal_release(struct kobject *kobj)
 {
-	/* or, notify this release to the feed callback */
-	kfree(container_of(kobj, struct damos_sysfs_quota_goal, kobj));
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+
+	kfree(goal->path);
+	kfree(goal);
 }
 
 static struct kobj_attribute damos_sysfs_quota_goal_target_metric_attr =
@@ -1146,11 +1176,15 @@ static struct kobj_attribute damos_sysfs_quota_goal_current_value_attr =
 static struct kobj_attribute damos_sysfs_quota_goal_nid_attr =
 		__ATTR_RW_MODE(nid, 0600);
 
+static struct kobj_attribute damos_sysfs_quota_goal_path_attr =
+		__ATTR_RW_MODE(path, 0600);
+
 static struct attribute *damos_sysfs_quota_goal_attrs[] = {
 	&damos_sysfs_quota_goal_target_metric_attr.attr,
 	&damos_sysfs_quota_goal_target_value_attr.attr,
 	&damos_sysfs_quota_goal_current_value_attr.attr,
 	&damos_sysfs_quota_goal_nid_attr.attr,
+	&damos_sysfs_quota_goal_path_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damos_sysfs_quota_goal);
-- 
2.39.5

