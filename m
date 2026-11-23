Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A9D606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MRWuZwnF
Received: by kanga.kvack.org (Postfix)
	id 188666B05B5; Mon, 23 Nov 2026 10:13:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137B16B05B6; Mon, 23 Nov 2026 10:13:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40966B05B9; Mon, 23 Nov 2026 10:13:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA3016B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:13:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34B91A0960
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:21 +0000 (UTC)
X-FDA: 85466727402.29.01FF479
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7E15112000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRWuZwnF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446799;
	b=tig3yLcdvWOrB9BRDpmI3EYSR7atF9MjPRBoyQ85KYvlFpX8lE29RrrW8LMn6OcblWw/T6
	PGxgeU2m6AXGAL5oMLz0ku6gpEB/g9ZOtp/xY8Nlj4SFw4+FBpeN30d6r2Z+Acr1A/LNZH
	8Z/q6Ecyw5DLbDG/qCglW4Y+ndYSnr8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=anjosQojPpSKjTyo8SLgcPgFtc0uahan+Zt7aVToU38=;
	b=T5XFq5jDoc4Mbj5r5XXIIqRBe1Wm9Uzca8ikeYe6Gp2plURvWa+LSb8fspbx7wjxd/Su2c
	N9YWsABQLW7WGEYnyE6HfrzGaJ7lEjg1Vp3EeJnqZcJTqz6DY4bnDua/jAouGK2OGJYltP
	xGCIlyE1aeL2oWOpFV+bpT+zp0aHgH4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRWuZwnF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BBDA0455DD;
	Mon, 23 Nov 2026 15:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DDB1F000CF;
	Mon, 23 Nov 2026 15:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446798;
	bh=anjosQojPpSKjTyo8SLgcPgFtc0uahan+Zt7aVToU38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRWuZwnFp2IuTCwJQlojIFBselaE+wLkhBNw7MTxxWkaUeaC4Y6mgpwUktV8eHTkW
	 mQcRtI54HYMqYnwhpmRgUCR4oHZ1wiqpJac+InR6hHPfA4EX2ghjRVCBIdn3j7pMq9
	 qB3nH5rMptWTsXmZqDC8ipsQH5DcRaGoMMuHbzQqHdBUbfeZ0WAxt7TYuO4Rlr564v
	 d7x4nJujLqm5OeJINa2F6JVazCkEw28epGpe96oXVDWytJu70diek7SD6MXXy9bNSo
	 GbU9/AEEsN4X3Gg+9RjTWSn7FIi2cBP6YQpWhgtzGWBoWOamalfJxa7yMPatGcRz5a
	 LPmovK9P2Zx2Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mattathias Pinchover <mattathias.pinchover@uber.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH v3 2/6] mm/damon/sysfs-schemes: add sz_ops_filter_passed_last file
Date: Mon, 23 Nov 2026 07:13:03 -0800
Message-ID: <20261123151309.82675-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123151309.82675-1-sj@kernel.org>
References: <20261123151309.82675-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ekh5owfagdqm49huwbq8gnw949tht6e7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E15112000D
X-Rspam-User:
X-HE-Tag: 1795446799-685718
X-HE-Meta: U2FsdGVkX1/kA6CZVE4zo+0+HEuXmbViTHOAvyd+pw91WO6Nxexm5wtqeD12uTHD6Hn3UtbEayXozpr3YPflNXzrqlmTsEnAzUquYxYWflV5m80oqkRG2NJpPd6R9rELdPK6P/lw4CJlN0SGWkONrj8KNwA7Ag4DjxUrQjkjlcSKYwZ1qAiik5UKbk+KeG8Wuu/dFTnC9wiAsXV+UjAvEjD2Fn2UtivehpcH9eSGXP2f/C98TpOTZNY2RrbuMIUHwbs4JGC5YRfBYSN2q15l2VPAWCwo9QtmPjBiIQ3Sqqc+B0NM1DeyBlFEXb8gcgdtEJtzN2P4wieJWiQJMtwv8Q3/vErlttfEc7B8DbKKQLbBV+tAozjjNzd1A3cO8jYqqJ383sjdGz7YZTGlCp8YC7qPExqMJ9IhBTBB3jOY1HzaFPgE5M6GrAo0RF5B5H9TuZv74aBNfF1/NXZjTs6uPDhYDpjERyWCDalEG1SflibrCRcwF5IpHEUo2WdqDmg8QDNa4z8fKgwZZHb2BFs9wTZabwG5wd4ivIMbwS9AbXRGDstgVTLzqI6uw4pCeB4xu/pl7/A+LhQng8TLHOeqhAMAYjOcmZ/il2C2937y3ij7xR+AokrV8j0HSZPhq0JkCjJNGisNDEWCw5W1iO1xIsujJZ1z265YIf210bf3MmoQvBjxpQssvzYGhE52Zz0fIZs1ly9vLthcM54AXMBL61Yt9UewKI4eM/ybvS99IvR+o+AlvAPMPi8GUEc1QiZpLwU4gYI8ZhFyWrJSBGFkCrwuesWWaNkB03EWdb+IYIKAGR/STMBv0xyU2/M9bIzhu3eO21LOQlYu21PEbMrvBWPnmU4Kqtv6eplVhvIFWKgFuiT68kbdSRn0WnQt5Z50f8wwLOSixZeSphhyBje4H9+bCWUAf6u8btVwEFxObHQyrGyiJe47b0jjjRvI99nH/XxHUMGK4k0UEacAkmE
 ETFvI5Z2
 5zJIIwGy5PElcSA0/w1AMZvTC/UZ3BwSnfsrIcxVD86amGR2FukT/Z8NxgEVi1mMxZFhkniZRy8Gb2CMgkm1XXxg+KvikzDLnctYS7wHXomyP1wlYY+IGnRyB0525bvVlixtQWs8bvcmEXOYJZqRF1LrM+W4Th8Y4opGoVs6XDAjEJMfTBi+N4xDYOuEkVljQa5zNxwQiNzMxzFni+83ky3A7txaaI/HDg0jiQqlErt3/FcCGRBhTBa2EuJy37jLV1rIiRk6USaYGUZ1xtRxLNjFv+Lhpq5l4n22LSZEwGTUmIbKK9xBixky+PjVYnG3rMOWdsWKABO53e6RC0Q3kpCSzHNKv9vjpDLAh0QDZ48yXIChSXl9PYlO3NckbyY++b+A4CtoIMCCBXdp0283m4IVfUY90XVnnZRpQZDIJZnJBW/1XhBAQ1WfhqCF2y2WFuIset8PjEWbntYOh8DRJj9TYvJjO9d/Be128i2mdxVAeChR96zUrpXZnvgUCzRkMpC9TCCWLMNq7ElJ/i3P8zJocTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

Introduce a new DAMON sysfs interface file for exposing the newly added
DAMOS stat, sz_ops_filter_passed_last.  The file has the same
name as the stat and is placed under the DAMOS stats directory.  Like
other stats files, it is updated when the stats are refreshed via
refresh_ms or the update_schemes_stats command.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 230987efac3ac..750f70f0c31be 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -370,6 +370,7 @@ struct damon_sysfs_stats {
 	unsigned long nr_applied;
 	unsigned long sz_applied;
 	unsigned long sz_ops_filter_passed;
+	unsigned long sz_ops_filter_passed_last;
 	unsigned long qt_exceeds;
 	unsigned long nr_snapshots;
 	unsigned long max_nr_snapshots;
@@ -425,6 +426,15 @@ static ssize_t sz_ops_filter_passed_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%lu\n", stats->sz_ops_filter_passed);
 }
 
+static ssize_t sz_ops_filter_passed_last_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->sz_ops_filter_passed_last);
+}
+
 static ssize_t qt_exceeds_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -485,6 +495,9 @@ static struct kobj_attribute damon_sysfs_stats_sz_applied_attr =
 static struct kobj_attribute damon_sysfs_stats_sz_ops_filter_passed_attr =
 		__ATTR_RO_MODE(sz_ops_filter_passed, 0400);
 
+static struct kobj_attribute damon_sysfs_stats_sz_ops_filter_passed_last_attr =
+		__ATTR_RO_MODE(sz_ops_filter_passed_last, 0400);
+
 static struct kobj_attribute damon_sysfs_stats_qt_exceeds_attr =
 		__ATTR_RO_MODE(qt_exceeds, 0400);
 
@@ -500,6 +513,7 @@ static struct attribute *damon_sysfs_stats_attrs[] = {
 	&damon_sysfs_stats_nr_applied_attr.attr,
 	&damon_sysfs_stats_sz_applied_attr.attr,
 	&damon_sysfs_stats_sz_ops_filter_passed_attr.attr,
+	&damon_sysfs_stats_sz_ops_filter_passed_last_attr.attr,
 	&damon_sysfs_stats_qt_exceeds_attr.attr,
 	&damon_sysfs_stats_nr_snapshots_attr.attr,
 	&damon_sysfs_stats_max_nr_snapshots_attr.attr,
@@ -3130,6 +3144,8 @@ void damon_sysfs_schemes_update_stats(
 		sysfs_stats->sz_applied = scheme->stat.sz_applied;
 		sysfs_stats->sz_ops_filter_passed =
 			scheme->stat.sz_ops_filter_passed;
+		sysfs_stats->sz_ops_filter_passed_last =
+			scheme->stat.sz_ops_filter_passed_last;
 		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
 		sysfs_stats->nr_snapshots = scheme->stat.nr_snapshots;
 	}
-- 
2.47.3

