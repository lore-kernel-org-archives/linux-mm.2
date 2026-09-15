Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B2FCC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8570F6B0096; Tue, 15 Sep 2026 10:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB1B6B0098; Tue, 15 Sep 2026 10:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659F66B009B; Tue, 15 Sep 2026 10:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 329C56B0096
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:34:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DBA3A0428
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:10 +0000 (UTC)
X-FDA: 85216241460.22.B84061B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1DB2380008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MS7nR5t2;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789482849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5VdpOGRYXrXyCrSePa8puxBW/6Uq97itYKIwT0a6WQ=;
	b=ACLLYEAeDu6dFJLc78C46OzeOICdWZti9FqQBIlxH6S6ptxWRcNBCG8VTIHLOSK4DymfKW
	aB6k5kbYsK/lVC2rBYd6jTyQ6ntrfd5MAyJ+sgfv1jTefZ2uNVyYEGNfqcuUuc1P38sKuL
	DToP776HZEhhAWnAnXGqD+AOZXFL/eA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MS7nR5t2;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789482849;
	b=KrtaAXg5ldvy1jV2BPx9uA5yDmBIlFw7TJVqaGEswXvcpw4ulTPvwQHVvR0JECMr2k74n+
	Ad8XtPKVSaKRrzT9Men7ATTwiWs9gN0cj8VsZ9PD9Oj3+pG5ymtuKm0XlsmnXePfoYwV50
	VO7eTmQYUVPlB6g52O+hNPqe4iSPFZQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AEBE160142;
	Tue, 15 Sep 2026 14:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFE81F0089B;
	Tue, 15 Sep 2026 14:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482848;
	bh=g5VdpOGRYXrXyCrSePa8puxBW/6Uq97itYKIwT0a6WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MS7nR5t2sK3dn3WFELBnQbMSl5v710rVTzQ9QYNt/Gje0Cq41caE7zg2z6zSDF4od
	 G/F8ZIeSUqPMAyiLuCsGT/m/loqW4TQxFq0N05UjUBLGCsbauHKfxSRSeLB7gnZM+o
	 UU3aavsIHZKJ8E0IFAXV0Vr1HnyHK2/Ywbju4iUe4QZ+srTCO5wmrO2f8Aqu5alcmA
	 4z7moXaTsmn/4kUdnJ1W0puO8ofGBA78ttcFziv9RSD5h0DD4XvaZtHT83DhfAfsdW
	 4qOmmabgVJ21Sv5IpdntekX/4/CtEYCw7Hbyk0a2OYKfKY89ijAAdZ2/SRhi1odUKt
	 DIolL5YLS/hTg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/8] mm/damon/sysfs: add min,max files under probe filter directory
Date: Tue, 15 Sep 2026 07:33:53 -0700
Message-ID: <20260915143359.91472-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915143359.91472-1-sj@kernel.org>
References: <20260915143359.91472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: p8994r19irptkogb8m3awqypqde677qp
X-Rspamd-Queue-Id: 1DB2380008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789482848-92678
X-HE-Meta: U2FsdGVkX1+0ncY8jjPjfmxE8+HWHmvdeiILJtjkkLyeDWZWny/6dQsyHPpQ3XX0V0KABKHn0sth1A5bkp1R3A9quPOLvQIKleOfBwC9og2Vbb052C9RbR7VE6R/GLEC9JwvWUXsLwcOVQLKJ1yMW71rmVfwtyAwWj+4yKtCJqNaPdOkZ6ANy1wAZTILBA+2J1GDCsSBQOojQbz2Gp7PkN/OntKriWdHCmgpv+pd6UYBbSxSkCIHQyhgJAIzZI6H5UTHbyq4JD56Q/RIIh2bw0dpG+ISOTUcto8mmhSJf+0vF0RMeIJYWKUZoMnuUvrtiprhJdN8xA57KWvJwnumvg9GBiGV8Lg2Jr8a71NYdpbXp0vFI6I38YsUYOuywc1H8TmPZuB5oOgeLUWnr+elPi0xsa85fat/s0QTw+DgRBy2HdoqsvB5Ld71C5micnHB82rOyPNeLYQ6Ch6UGkfMuZE8qbWIhKkgt1u8G8Pd9pVmjBg08GicpMyEGrGAxEdgHoBYUi68DGwO6uzCKzskwCWf7M6yHNvp9rFUjXkVb+sGlL/PV0OtvqNQ+u25/SipU6ZMUhJSNSsIcEoG8FvaYq9FlA37N1dNLkmDTQoAqaLGvoaJ06CU3Dj3VXB+JufUSsipCCo4LIbgMDeHd4L0T0asXjQIB2OUXm5wY1pDdqELCEtwcVvmPex1M9n0PCNrg6LuhGXrStrf3SOn3GXL8b2kWTe3V7x45wq9CZPrF0cviXo/BvgHoCYvbK2JiSlDOpvMoqefazKOXhcm50t3aWeA2UelUmd5TKM1i6+qUDltg+QpzHO0p2wc3OFreIaJR/jRMUrcePvWMwg+x83EUWKu9DaglaYma2KS1gawUwGjeEUWap7LGTiEr+661XE45o4H9P+5U7yEy0i4kh3u9JY+MGZby6gbLpaVzzq+x6vngqZZr1E1D/4WKkGkN1XuDEtHQE/9YXDRJFexlxq
 ygunt8rn
 rs+qbhT2NEDDMjIA1nOzjs55HDPmJmZoaMRxUP1TH4kgJ2TZkgXK/e7TxXnaWgUQa279KMXBqd7L0C1gcEP1Hn9sm6DjYrS3uSu+n2pe2vDPHnOboqbMxI8wtQTkOixCsnMg2LWAVT+XmNz4pBXT8dnWWZ44L49lTaFk6hREjhy3Nbo1H46xaK6efKh2J7mnQ7taz/2pMHSZTjfyYKNdCWb8pZ7F5zGpG08FIzloqs2xywb3eUXTeREvJv85VVS4IS4xMzc7pGNSzK2QHL5oS4BzVcDKtsrMfEtvmkNBu2nb5+bLh3m4uczRhb1T+ysB+9s5X
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

