Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 025D8C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C896B00A1; Mon, 14 Sep 2026 10:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FCF86B00A2; Mon, 14 Sep 2026 10:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A3E96B00A3; Mon, 14 Sep 2026 10:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19CD06B00A2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8EA0840123
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:45:00 +0000 (UTC)
X-FDA: 85212639960.10.E608BF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 02079140007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:44:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4iahjXy;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5VdpOGRYXrXyCrSePa8puxBW/6Uq97itYKIwT0a6WQ=;
	b=R6AyUK+TNnAQpyBmjZdpLIQ5v3gexCsgPWD+pB10Nkes8SSFzgiccuDFnq6JtSk5FXWSIL
	L3nrZZ25nEAbq/TLFsmd07DT8DnHtWivvxfsFFeVyO0NEqkaI7r9EfqWvi8eunSortsfvw
	x3PnEchWWd8WBC2+MdKniATYdTbHyYs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4iahjXy;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397099;
	b=cO/7srKGVap4y6YGDdAxDOr/gVfL59PfwgjLN8Amz5s3YbaC0DZ8pKh5yu/VXfEDAutVUV
	2WVLE7GOf28QQ+Xe42WAz4u8rKd1x53IcQqUUIhuxbzyJScYL1vH7hRANQ/CZvbT+Vygcc
	56TBWQh+cTnjNuWTg4bfP7mY4OLs2F8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4160601F0;
	Mon, 14 Sep 2026 14:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781721F00899;
	Mon, 14 Sep 2026 14:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397097;
	bh=g5VdpOGRYXrXyCrSePa8puxBW/6Uq97itYKIwT0a6WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m4iahjXyKxDMVE3wELxBdszq4agcrPcyFP5EbQ/RmcJB08EJ5e3E49CmKd/nAQoCo
	 NJ//gER7BKj0jOtb9qSGgBUHhqxxlGdrImsYr+wp1YMe4lHXj0io9F4fHtef5hci5r
	 vv4J/oe2VL4JFhCo4blpB9ajzfxyYmUTVqbQnTxTGhNobg/Ea3D+okAc9Jv+DH+LMJ
	 FzB+DAsaCY2nuD9oSEJ7HSmdhehzRw5BJxX0cMTbsolbeK1obEfaIBUb9W07T7lcPg
	 dANi5Z2mKebfhaH25fEXhU4lyOFvlwyPQNAEd8Ie9joepaVZ4ptLUTTImaLWytBcbX
	 kKwHhQjivXQqw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 4/8] mm/damon/sysfs: add min,max files under probe filter directory
Date: Mon, 14 Sep 2026 07:44:41 -0700
Message-ID: <20260914144448.93732-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914144448.93732-1-sj@kernel.org>
References: <20260914144448.93732-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6kwxohcyys4aattznnffymmtkcqxdq5n
X-Rspamd-Queue-Id: 02079140007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789397098-698625
X-HE-Meta: U2FsdGVkX1/ttEiqYZV1G9fDgTUwncbf7+8H1UDGALHF2d2IBJHgl8I9a+FWVyxdFwH3CVJ3sGyzNmvSZHVhvdsdW8yPXJv2WdoYOkoeVllkBfhpD7k5+XPlnUsywHKC18YRdaYXOWmK2LzDNLUYr7O1xg/9RkkCsLBt1q/U4exJ19diWWf73ipfM3nA9LEXOc1aA8Gx1R341nZpbtr5xAbCoxH+42TeWTtys/nsTac67xHshBh2gPOYjwAa/8bcv5TtgFjtDfum3hTw6sXYLGAgXEhneFcCv0BRFvh3m2jal3tS3zDUbQUuAINXTKHMCRw6r8D0R9UnFAyixTrSKk+Yzo9YbojcJvkGVZgcLAHeiU2E/4LHJ4Vy6rXtPxPAQss55LrO0nMvGhOb7h6z8dBmoNaGOvRVoKgle28vzABujoX0nvspclDdnqzoCY0/s2A23uXOY+YU2dBqFgYVUvZx7K/thyVWQ4SyuEu66ejrgLjnL7Piq4X0ZeickjstpQwReUYu5L2Wn9t3YQPupq259g6HyWYreRheytsF1Cad0OQYVpRhNRbaoagJ2v99wk9JAC1lfksKZ6Lsl5jUkb7UPJnrXO17b9hGw6+9HMCCelJRk0tQ+nmI4aD2eOqxX5laS+TScbLBpSVwmbYJ5s2YGTUCj/80/am19UCT90afCFxja5e14T7CtNbIaJMwLIVTCeH5+UVNFIEtBLRIXMq+NTYMaSWIVuD5vjhxEBunXnQ81bLMcRx8MKr5LQY6GLCBfLmJwznstgEupgnzqJLv8k5lo1XyvQgZ4AIphTnvB769Uk49dwQXgxdU3H0oytnqK+Yu4TcXIhdoDoupJKHyzcaoQNPJ/PfYbmtzPxtFDDtZTTEsPzkBitrt6OHsOwV7wOZm03uNljtjKYthvPvtOpXFBXDhksm51yVY6MpuDsVIZjojonS3P5MMMYDiueDVa+a2zAtcZ1ixlXI
 RDoBG49x
 Goq14j4lSzQhtvjr2xJwbw5o6LyHXt84pm9vI8dvz1A3hBSpGtmI3or1MkNsPoP8Hpi28YKG52ACSt5eqjfCafJhq6IOLi0h/BYXCGLzQdPOXqOziuyv298IYGtMlTDmNwYknQ2OQG+OMYfpoGpPGvCwFsc7+5g/4y9IX0vE4Lp9QTaL/HZDzftr0XzaZKKLnSKMM0npSb+j73BWtA4jgckiiy//vN1U1Gt3GhGxAEBNWWbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In future, DAMON sysfs interface will support data attribute probe
filter types that have range arguments like the newly added
hugepage_size type filter.  To prepare such supports, add two new DAMON
sysfs files, min and max, under the probe filter directory.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 51fa506c879b0..8e8d89b8ed981 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -975,6 +975,8 @@ struct damon_sysfs_filter {
 	bool matching;
 	bool allow;
 	char *path;
+	unsigned long range_min;
+	unsigned long range_max;
 };
 
 static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
@@ -1127,6 +1129,44 @@ static ssize_t path_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t min_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+
+	return sysfs_emit(buf, "%lu\n", filter->range_min);
+}
+
+static ssize_t min_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int err = kstrtoul(buf, 0, &filter->range_min);
+
+	return err ? err : count;
+}
+
+static ssize_t max_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+
+	return sysfs_emit(buf, "%lu\n", filter->range_max);
+}
+
+static ssize_t max_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int err = kstrtoul(buf, 0, &filter->range_max);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_filter *filter = container_of(kobj,
@@ -1148,11 +1188,19 @@ static struct kobj_attribute damon_sysfs_filter_allow_attr =
 static struct kobj_attribute damon_sysfs_filter_path_attr =
 		__ATTR_RW_MODE(path, 0600);
 
+static struct kobj_attribute damon_sysfs_filter_min_attr =
+		__ATTR_RW_MODE(min, 0600);
+
+static struct kobj_attribute damon_sysfs_filter_max_attr =
+		__ATTR_RW_MODE(max, 0600);
+
 static struct attribute *damon_sysfs_filter_attrs[] = {
 	&damon_sysfs_filter_type_attr.attr,
 	&damon_sysfs_filter_matching_attr.attr,
 	&damon_sysfs_filter_allow_attr.attr,
 	&damon_sysfs_filter_path_attr.attr,
+	&damon_sysfs_filter_min_attr.attr,
+	&damon_sysfs_filter_max_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filter);
-- 
2.47.3

