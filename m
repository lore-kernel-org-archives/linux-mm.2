Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A722CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D45B6B00B3; Thu, 14 May 2026 10:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4358D6B00B1; Thu, 14 May 2026 10:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23AE96B00B2; Thu, 14 May 2026 10:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEA5A6B00AE
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3786C2117
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:29 +0000 (UTC)
X-FDA: 84766208058.06.4875CA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 01DB81C0007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JD5MmN9N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8yd0YW2MfhryPbHNrmR7FjDXKN1/tNV3/vxI6crJIBA=;
	b=Xp53tXFceGgBorBfN68ezoQmMgBj+1R2tV14ceoRbP+dv8YbnvUwmpqodKzGUsi8rjg45a
	O8/IDaWvgH/7ElOUCRtXe44yB8731mudKBSW7clt/nhbUSR4IKUq+JUmoLtA+myz1qIx1B
	A4+sQZbxyldM1fx33WWAGBeJMjSiGbE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767768; a=rsa-sha256;
	cv=none;
	b=gl6+xK9UZNN7IsQAqlQVYOGTLVj+2FTmHNKO+vPcznub9SY5bv7bc/S+FNFH8LfhH5CF7Q
	u3ANdqfYcqEmoEGcpel3qC66pC+SGNAm7ErhnkXC+pKhKdqn694dh0jLJR6N07SBuqR8HZ
	2zQrnuThJ3FAQ21lK9JLcslMjeIxFcU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JD5MmN9N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A9386013B;
	Thu, 14 May 2026 14:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0743EC2BCF7;
	Thu, 14 May 2026 14:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767767;
	bh=GgqkpGLzfY3SpgNfpQk0ztstdYxBESX4HneypEejd9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JD5MmN9NqvxSm1HWcET41QGb1GURGyLzoR0skUvSbJmPiEzw54mcxRdxsitUPlgHQ
	 W/n5JDH0gyA6wEhyYHJAzBW+Sc9Bt727+7r6q/PtJmQh2fI1i0Gj2rqWdF/zDqpbtD
	 yJVKNjGSTu2QIIs/PGaqurRg5Uo5ZzKnTj7N9y2U8Y5jhTdjijKDujsNzGx4iBVFlg
	 lxFBaiWdn9+hNzm9iVE9/WCCfgWRPCa+qkbxur/8HWJng6O48I0Oi2xgIZF0db9cwk
	 qQlJqtAWzKZxTBPC+LJ0L9RKCw7EUdRX7NXX7fQ7tIaEYg4VYFh/uDClsUg4tXrjzY
	 0qylZbQ3Jqkcw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 24/28] mm/damon/sysfs: add filters/<F>/path file
Date: Thu, 14 May 2026 07:08:57 -0700
Message-ID: <20260514140904.119781-25-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 01DB81C0007
X-Stat-Signature: pges4xsakzj9qtm9ip7hoqkk3tc8fqzc
X-Rspam-User: 
X-HE-Tag: 1778767767-507871
X-HE-Meta: U2FsdGVkX1+mzCf7+bBJWwGqjAJpaC1GYvFmhm+RpEG4I+1Xlu/ZY4jDCuVWmCJk05iBV55w5R1MZGP7NuCfKvqTuXjZbkhWPi064bk3/B4rMrndytEoShj7YJCb0E5utbRb3sMzcfY6K8cuuk6LsR6YUVx2l82KYZUwCTe23LeWCICG1MJ+g8NyRIslz8f9ba6s6L85kXoTemusqI+au5tKFWpxPF/wYzp6NviVcBTy5dLxleOPDiUJnwENX4+K5OnqLL+DpOOO43ZExei2aLLhCevwE6lQfARtNVy05U8bmwFhP3quR2Ow7L3eu2oiifcRqRZaNm1Fo0O1U2HJCktqF6Dknh/tNJ5it7siIACRfjXda2YPywA8791ztmZhQtu3/SgmkCuE7lObGBLMd19hg5k2tw6/tCozrWI2yi2ngfBtAnfhfdEdMEoHN3LPTp6McpAPHHAfZcNMonl5FpJCYES7/0GaxjpUTcZ5m/ETzsppyhyYM2nefGh9K1SmQL+Jyf0h5+SfLHhYzf0KaDn0Z4Y0CBrN2ihM27eKIEeaedjZw1kjR8L+cNpsALWBwJbSEaISBSfCi9E5Gh9qUxAm2P0+HN7vWfEyX7Ql9gAPGMiJvWs8at+dsyLbqCWVcwt0Naqj/ebj6ZFix6wS2azo+oPCe33OVKq95rYN8dXE3I73N/SOVO7K6SVw6eaf3UrybCd9k+3id40NFCoxO15ZdrizBSnoDHeQA936GfhRCvijW4aRKxNmwwnf710CcmVNNxH7PM7CDYKGoe1ncqxQsTb2Ouv/G7JtQ52rEf4fBbnaoPrJEBpK8PDjq8LXLtTdG+BytqaMBfMuuoiuNQainU7w7qS5SsstvgQuOTH/XbKPhoI2cTmJ1IJzRDXDDd6MjfayAVm/aPrQjJYNvz+YOgsVcu4TCrRFuS4bT4k9PWCWFj2qIR4sQvy/rCqTh1pPUn9FJk4af89wGfN
 Yokj9BXd
 7KIUMFVpFxSIyrrH19SXVWjFSEgfypAq/jahkYaNtQBj5jKTPopfy3yYuQJCQ4VZDfaApHh6H73VJKPNdK//qlMpxvAs4fghJxeVaMG7s7TMbgNhQpt4iMIlCcGrcTk5El7jROMTOAkBlhodDmipuz86xtkswC7IsP57aKjFCTEs90cqeWyPDFUqO5grVKK+BgL8+yUjDDS36UFPsusAUKegakRAh9wGKkZ4k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON sysfs file for letting users setup the target
memory cgroup of the belonging memory cgroup attribute monitoring.  The
file is named 'filter', located under the probe filter directory.  Users
can set the target memory cgroup by writing the path to the memory
cgroup from the cgroup mount point to the file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e4dbf85feadc2..2b68e1a7de451 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -756,6 +756,7 @@ struct damon_sysfs_filter {
 	enum damon_filter_type type;
 	bool matching;
 	bool allow;
+	char *path;
 };
 
 static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
@@ -774,6 +775,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_ANON,
 		.name = "anon",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_MEMCG,
+		.name = "memcg",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -862,11 +867,46 @@ static ssize_t allow_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t path_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int len;
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	len = sysfs_emit(buf, "%s\n", filter->path ? filter->path : "");
+	mutex_unlock(&damon_sysfs_lock);
+	return len;
+}
+
+static ssize_t path_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	char *path = kmalloc_objs(*path, size_add(count, 1));
+
+	if (!path)
+		return -ENOMEM;
+	strscpy(path, buf, size_add(count, 1));
+	if (!mutex_trylock(&damon_sysfs_lock)) {
+		kfree(path);
+		return -EBUSY;
+	}
+	kfree(filter->path);
+	filter->path = path;
+	mutex_unlock(&damon_sysfs_lock);
+	return count;
+}
+
 static void damon_sysfs_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_filter *filter = container_of(kobj,
 			struct damon_sysfs_filter, kobj);
 
+	kfree(filter->path);
 	kfree(filter);
 }
 
@@ -879,10 +919,14 @@ static struct kobj_attribute damon_sysfs_filter_matching_attr =
 static struct kobj_attribute damon_sysfs_filter_allow_attr =
 		__ATTR_RW_MODE(allow, 0600);
 
+static struct kobj_attribute damon_sysfs_filter_path_attr =
+		__ATTR_RW_MODE(path, 0600);
+
 static struct attribute *damon_sysfs_filter_attrs[] = {
 	&damon_sysfs_filter_type_attr.attr,
 	&damon_sysfs_filter_matching_attr.attr,
 	&damon_sysfs_filter_allow_attr.attr,
+	&damon_sysfs_filter_path_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filter);
-- 
2.47.3

