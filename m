Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D735606A882
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fZQnASml
Received: by kanga.kvack.org (Postfix)
	id DBAED6B05C4; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67016B05C9; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69336B05C7; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 766E66B05C5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEE148083C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
X-FDA: 85438492818.09.7D084BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5055020002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fZQnASml;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kDNeq0YIzH6aqgKl3Y8N9odneRfo3uo0UcuJ/hi1Pw=;
	b=vmNu2iwnZ613b2QIch/RHZg4BH2Z+8WUhug87B8TDH6YBv4DbZ75sTVRmPiP+nA3ATre+g
	wthK8QsNf9RLsNnl8E181fRFX4uYhQrga/eg8CRk2X0QKIMEQVqmtaA/SCwZia7VqxEAHx
	E/JHwAn4E9Voql3WhRCjIJBkjgbI2fw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774548;
	b=Cp0Zah7kgGLbpYblK5Kd/wyV+WrFtH00HHC0mv53AoJxNRC8L8yyKxZvMqhA5BTcnKjXID
	DRvAI1Je1hQXJNdJd8f26dnENP4QTBZ3RkETjmRc0BUa1FcOM3rItS/tVRyWIirqL7k0Ds
	OKiyVFEXoa2MC74L7UwtVQyLQhuBNPE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fZQnASml;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9925A45A8A;
	Sun, 15 Nov 2026 20:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571991F000D0;
	Sun, 15 Nov 2026 20:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774547;
	bh=5kDNeq0YIzH6aqgKl3Y8N9odneRfo3uo0UcuJ/hi1Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZQnASml0Lbv9oQ91AVKMKsLm51A6Ek6efXwaBqXBmtQP9KMVxl6V/FCJ/asSYFjZ
	 V3gepos+fk3RlT5awLjHCbR1C/MTe8l4nhuS5x0gxzSwqXf+kZn6UhIyXY93jCfUIL
	 /2rZwsxtO0FMLV0u4yUp8rbyZHgw2h6zNFJexIFZ4/KrCS+3zUf1IBb7HF/lunCFCX
	 S3dFDvwc6ZRirLgKRBsCSSb4eU3oEGBgGSErNjYfflHCGSWn2JTjM/MoCUrjCuBJOC
	 6mvK1EbnaVDF/7Tr3J6u+ADUDn6D36lyTL1RxM3kuv9zbRv5geJ5NxE8zRuvsEY8PZ
	 aN+PHK9TFxQGQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 15/27] mm/damon/sysfs: add filter_report_type file under probe filter directory
Date: Sun, 15 Nov 2026 12:28:33 -0800
Message-ID: <20261115202849.99134-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qw3ey16ufqxhydtkns1zdp74it79dip8
X-Rspamd-Queue-Id: 5055020002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794774548-193753
X-HE-Meta: U2FsdGVkX1+gSvs8/HtVHy3Sd93ENVrU1sKyjCovDDMpH7ySoqqEak98B4jjCj7s7KiKryVMSvJJH2glQbx6+vp2iGHQHAmy46Or1woG04tHfRFq2aYKV91fhHRzQyMAL8RkovUpJ7PZViOas9cTIzSrKQG+ajS12Aw8czCaIdTp1w5Rba9pADmUgV8NNvfpJl4pDW14yKSTuZqaGu8DF9dt6cRNZR/BWhBXln1VUky12G6p51HqQyxwC6kzq4ZNvr3LtfazQREy1GpQmfu41uN6kJakknUmhZQZi+xcUpMd905faim6+cCyS666njqt8XprapS74rh5ARfroEitfecfmzcpHMBYLNTW5lXVMmDCM+fCRK7WKDe4IQk9WpVD9wYOVpdJU09U2EQJx8Y36UXQ5n8UjZN8Pl4CQB2NX0IAclkBHyiEbUlwfWKt5Fc3rcLjNn9iHzsB18pjj7rlT5Hltr70Sy0OEbeUDb9rdQ6CpzbrgmCvO+QMuaVhDrwIq1qsz2FHyAm6042tkgeIZDdaRsOs7I4+jNbE6iY6+d4o2Mii5s5lzgL6xieccSUIZMzimYi0PXlpmOF/mlJjOHntCEGI54RlRDgBJsoktGR6lr0z05JanQMS+xVmqGYgNEF/lWtBHhweQBaanSBYdSr/o8A51vjp3mCyEpP6pR/fZGhMZFvBdGkVXiAuGXH+nhA0qZSoiMkUvbVSrgvCQwFfN1tzwPkQbG1hdtHA7cnMZZnpiaTkwlhgoJ+uqXocvc0yXsFbWmwmjWGr38ndZaPkPByELCYWbwgm1wIzLpEbYEoJVH3vTx0x0n5scaIomF7jEplTz56Uu44yjm6RYqSEVRlNPqMsJ5YNZrUIE1svjgaLSBVKaY8Rp23jJgAPaeVeG7IyxWxs9Y2OrHYokeaTNS3bKiN6lb7KfsEMv0WcGSfhOz9gzWWJEVb/sH6UcCB3bbWc3GrDGM7HSmr
 gHRAlsSW
 ZOWsWe/kvtXevHZhnU80HQrrffMVjdzU3IHLt5+nw+L3nnh9lxKIt0E0aTqkAyAOsMhaYemlAPGb7vhVg6PUr6zbZrGez9Vjtw59dHJF4pZruYbDzLrhubjauWADYj33cfbI3J3qXPH4Gqvsorqct54oqRGjG/uqfEBjW0x6TdASS0sapmj6neTLHc1twyHx5g6+Zm4I+CZ24x0mD90F6ulRfeKoLmzkgGuVNbH3tmulOJsNyqPqxpeWWeXM6TYzorQzjjkPeReRau+eyOV4aSGR1jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a sysfs file, filter_report_type, under probe filter directory.  It
receives damon_report_type from the user.  Reuse
damon_sysfs_report_type_name struct for user keyword matching.  Move the
definition instead of forward declaration, as the code change is small
enough at this stage.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 61 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 9 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 7cdbe2fedf7d8..ca971cf1dcf6d 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -977,6 +977,7 @@ struct damon_sysfs_filter {
 	char *path;
 	unsigned long range_min;
 	unsigned long range_max;
+	enum damon_report_type report_type;
 };
 
 static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
@@ -1175,6 +1176,53 @@ static ssize_t max_store(struct kobject *kobj,
 	return err ? err : count;
 }
 
+struct damon_sysfs_report_type_name {
+	enum damon_report_type type;
+	char *name;
+};
+
+static const struct damon_sysfs_report_type_name
+damon_sysfs_report_type_names[] = {
+};
+
+static ssize_t filter_report_type_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_report_type_names); i++) {
+		const struct damon_sysfs_report_type_name *type_name;
+
+		type_name = &damon_sysfs_report_type_names[i];
+		if (type_name->type == filter->report_type)
+			return sysfs_emit(buf, "%s\n", type_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t filter_report_type_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_report_type_names); i++) {
+		const struct damon_sysfs_report_type_name *type_name;
+
+		type_name = &damon_sysfs_report_type_names[i];
+		if (sysfs_streq(buf, type_name->name)) {
+			filter->report_type = type_name->type;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
 static void damon_sysfs_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_filter *filter = container_of(kobj,
@@ -1202,6 +1250,9 @@ static struct kobj_attribute damon_sysfs_filter_min_attr =
 static struct kobj_attribute damon_sysfs_filter_max_attr =
 		__ATTR_RW_MODE(max, 0600);
 
+static struct kobj_attribute damon_sysfs_filter_filter_report_type_attr =
+		__ATTR_RW_MODE(filter_report_type, 0600);
+
 static struct attribute *damon_sysfs_filter_attrs[] = {
 	&damon_sysfs_filter_type_attr.attr,
 	&damon_sysfs_filter_matching_attr.attr,
@@ -1209,6 +1260,7 @@ static struct attribute *damon_sysfs_filter_attrs[] = {
 	&damon_sysfs_filter_path_attr.attr,
 	&damon_sysfs_filter_min_attr.attr,
 	&damon_sysfs_filter_max_attr.attr,
+	&damon_sysfs_filter_filter_report_type_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filter);
@@ -2992,15 +3044,6 @@ static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_producer);
 }
 
-struct damon_sysfs_report_type_name {
-	enum damon_report_type type;
-	char *name;
-};
-
-static const struct damon_sysfs_report_type_name
-damon_sysfs_report_type_names[] = {
-};
-
 static ssize_t report_type_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
-- 
2.47.3

