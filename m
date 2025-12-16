Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A61ECD5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8396B0096; Tue, 16 Dec 2025 03:01:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A889E6B0099; Tue, 16 Dec 2025 03:01:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836686B009B; Tue, 16 Dec 2025 03:01:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E88F6B0096
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:01:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A4708AB8E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:48 +0000 (UTC)
X-FDA: 84224590296.06.2ED6D7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8307A40006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PtTftagF;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w9FR9bAtxPIBddrbTMzGervBBN5P0aXhW3B+U9kjHs8=;
	b=FSAbVOTjip/jlhDShwcUsW3VOjOfDShFcKea5F8dLdNY5vUtkZZi/Sp9lRJXSTTxtJkkVf
	Ydrhtv+pHSYCMx4v5WRvG0eJB7+HztzYp/g60TJxPt110Cr68TGS/HNxTnlCW8OEzGtuwy
	iGk0jpAuwb5g6ZDayGQLDqAmaMWdifE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PtTftagF;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872106; a=rsa-sha256;
	cv=none;
	b=H3BRqGzJH5BYANLIsIflX58iM8PDAGomzVDv9YddWmNfMf/Yi4T5PqkmDyPoDwXYDcImfI
	FuHCFrSUxkcT5PmR1N+h9f9MOPupJXBSBJISU93lWZDnTsY7YivjfmSv1Fh1i7z8J6MGKr
	Xo2uHlbkgPAn4ooD/4t9GTIiIXfSo2g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A87174404A;
	Tue, 16 Dec 2025 08:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93556C4CEF1;
	Tue, 16 Dec 2025 08:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872105;
	bh=EheTKTWNwlESlsGw3Z3YuTZbvfPyPa97pgV7/l/okj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtTftagFA6aDpibycmhBVk+mdFNBF0N5kixw4SIegT3Uk5eNoeKz8vtoXLTeZ+k5Y
	 klim1SnBtXXcyu0Twva67/CC+W9QK62Wgr4GNAzIdXXYEyMs/PZJfgy8IWrQZFAJ46
	 0eMnkH/nNRMGP9ES+CbFoWPT3emcFnpQbYxhrAv2ZtJQEV94SoLrON3OZvBbfx0aW9
	 3RUrK3v3UmPVb2/CBmWsjbb0QCE5MMaSES9M1SuUYJ9j0iBTkgKewWprEEYRdZun69
	 jdDoAIXYASZoWgGp7N90a0A6Jzq4sC2NNV5Amy2gF4jCEA/o2ewXfbWob1ebCJczjM
	 svBhe6cSBUouA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/12] mm/damon/sysfs-schemes: introduce nr_snapshots damos stat file
Date: Tue, 16 Dec 2025 00:01:15 -0800
Message-ID: <20251216080128.42991-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216080128.42991-1-sj@kernel.org>
References: <20251216080128.42991-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8307A40006
X-Stat-Signature: 44y5nbb4336tiwr35ck94m9ca3iht57w
X-HE-Tag: 1765872106-463723
X-HE-Meta: U2FsdGVkX19srsWhmJhkFkTDOQmUnxv0g2lIG2q/j0u6uxl0jpz39Twf7r8wu4k919EKoAg3S/tQccJO/t0TvvDp0PQU60S900VVhagI1YN42mNGWcPq2jMGCDUTO7P9C9r5M6KT/raXGeEYzDC67MIvhYH+oRuiTd5yQf1+FZECYoa/tBd3B03hS+dYdoTz4tGZ0D1HBM86s8aLLv11bXGC8UZVta3Upi+FjZy+JxLNUZnjGExEKrphOqyI3FCJL/YP8n8Pqs73uFymnaJs/ZAyBM76Bw8FtJp+aO9t6DMBZzixfvf5eDT37qN0cp8J9VWuvU2OkemfGDeqP9koDf0Sp014lbECSlC7bXknXHaeaxV7pWRmtCnHFxMguxJGNrfnyXbSF5HVfJsLqCB5IfL13+a+uDxfHf0Ff44gl2pNj/SYh7bRWFkXeici3y3L3Bh2B5ORjB8+XD74Qgvr+uZBYtAeYiZTSt+YjRaVnFknz0PYLegeomtRCb19ZMHU81zQjY0Krs0orDFISN3Jt+NgZwo1nhiXcfLwR7w/k8UTt0naz6HzvSYlUnTrCOS3gOyRDFYmQWnPXIs5dmlHfnn9h2vQLvW8IXSqf2YrCw44p6G7Fj752oAG6ZkNDMzoFwVii36FmdLqQklK8rXX8ZZoVv2pCPksCQUoZKLqH3iANDLo3GWV6gsjfgaTvjuTAnEAjSV9/890XZRUB63rf4C740R2aOiwIFqoub9XXS/6DNDAwxfoGtCmnfM7YAKZ8d6DeNTZigBi1gr8J596iKJK8T90BEqaLY90UfcEx8/BD/oBUqMB9qVwciQj7Eyu7ioM++GLeBheqQDA9Xt64AhMVjio/OkZkRzIVlqdzFmdaor8D04F5KekcAr37CEqvfQsVlRzpsG9UIPAtBQXlR9kdFTj+aQKC/Av/mxVLjQmayq3+I4xtoamnHYGAidCQKTq1MvjnhfxIBRN2Yn
 rL5uWDhx
 oAsYwxxTeoZK5qn6hCJGPt2mOwKjSMJyED3tKB8P4vDa5aVIJpdgX8FeAwe+ymAUex+s6kFxxx4gt52h6YlOibNhJLo8/PfLpg24b3xpQs6JdyRvixVCFoFIC4lmwleshBfKwrgSkt3SPpla1/6TC/lcyDlga5vVi0clZjZDsw9zdb+0/Zf3H6oqWJ2tEyFG7GHKo4pP5e5oeo0n5gi2CvGdb08QO0HEV4qcsrG6RSgAKnNQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON sysfs interface file for exposing the newly added
DAMOS stat, nr_snapshots.  The file has the name same to the stat name
(nr_snapshots) and placed under the damos stat sysfs directory.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index a71059e65d34..a1f555e1125a 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -204,6 +204,7 @@ struct damon_sysfs_stats {
 	unsigned long sz_applied;
 	unsigned long sz_ops_filter_passed;
 	unsigned long qt_exceeds;
+	unsigned long nr_snapshots;
 };
 
 static struct damon_sysfs_stats *damon_sysfs_stats_alloc(void)
@@ -265,6 +266,15 @@ static ssize_t qt_exceeds_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%lu\n", stats->qt_exceeds);
 }
 
+static ssize_t nr_snapshots_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->nr_snapshots);
+}
+
 static void damon_sysfs_stats_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_stats, kobj));
@@ -288,6 +298,9 @@ static struct kobj_attribute damon_sysfs_stats_sz_ops_filter_passed_attr =
 static struct kobj_attribute damon_sysfs_stats_qt_exceeds_attr =
 		__ATTR_RO_MODE(qt_exceeds, 0400);
 
+static struct kobj_attribute damon_sysfs_stats_nr_snapshots_attr =
+		__ATTR_RO_MODE(nr_snapshots, 0400);
+
 static struct attribute *damon_sysfs_stats_attrs[] = {
 	&damon_sysfs_stats_nr_tried_attr.attr,
 	&damon_sysfs_stats_sz_tried_attr.attr,
@@ -295,6 +308,7 @@ static struct attribute *damon_sysfs_stats_attrs[] = {
 	&damon_sysfs_stats_sz_applied_attr.attr,
 	&damon_sysfs_stats_sz_ops_filter_passed_attr.attr,
 	&damon_sysfs_stats_qt_exceeds_attr.attr,
+	&damon_sysfs_stats_nr_snapshots_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_stats);
@@ -2760,6 +2774,7 @@ void damon_sysfs_schemes_update_stats(
 		sysfs_stats->sz_ops_filter_passed =
 			scheme->stat.sz_ops_filter_passed;
 		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
+		sysfs_stats->nr_snapshots = scheme->stat.nr_snapshots;
 	}
 }
 
-- 
2.47.3

