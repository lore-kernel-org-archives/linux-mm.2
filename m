Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E6B6CFD316
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81A86B002F; Sun, 23 Nov 2025 13:43:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77D76B0031; Sun, 23 Nov 2025 13:43:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F916B0030; Sun, 23 Nov 2025 13:43:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 968FD6B002E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:43:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 685071DF367
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:47 +0000 (UTC)
X-FDA: 84142745694.17.543A464
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C2DBDC000A
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EWcxawcm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923425; a=rsa-sha256;
	cv=none;
	b=H2i9O+Hz1Yx0hAhWNmUzzX8zTpM9zRXg7rk7oXpj5v04j32aamFPQ3FoKkN5FYE1fQxKPL
	637vcIevPQI75NkzCJxKnbEz820oTCHAN31kJb3DckRR1NfrkWqEMxEVKRxambLnJyop79
	/yHKTmSkv9jKI4DwM4rVuEmUfHRQzBM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EWcxawcm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8VCk5S8JV4435FWdvIR+XY5OFbDXnynCLFFAX6EBRY=;
	b=Sh5shKb7rjPNnguY3L3OkhFzvgTP+Zga7QRbfOnEE7/U8O3zmWeZrCdRUrq5BjO57J+N5O
	gt3iYc7pKi33IvVVlNs8Ystd/dnNoisJWkcITTMcI3wa1NsMOBB24K/NlBqVUpDIc06Mr3
	K2gjxQM4D+9sadfzHD5SjOfzvbYGGI0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D19B2440AE;
	Sun, 23 Nov 2025 18:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98571C19422;
	Sun, 23 Nov 2025 18:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763923424;
	bh=flHCn1jzwJYbHp6Nyj2GAUs2tIfp0Jhpc5MXnsDhPc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWcxawcm3Wldt4q2Fk+N/iVtuR2wUJd4gie6Gwzx0wakwV72c2gYTNBoOY9FUhvXQ
	 8Mu3ZswD/pPPtgFMiCsEH9649+sKKLO7GguUAVZVLV8828LgjhI91u5ySL9IgQyySv
	 llMTWbih/na/Q/hlRpkYmE+dDbe4GVxyb+XSuqEcLWadebqsTtsheGIYeCGoeDXUrD
	 5hOpw9cBW7yESLVi2uxKTcCrE6zcpSYNDxkAsAU1JEvZyR1jVhy2NNLJd6dsD0Mqwt
	 dTEzcxzfhflNWP0FX1+XDXN6OW86t9yIVdoO6naM+m5ZzIQOImWSxpVKopwt/ifhv9
	 fPynkYljdoN3g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 02/12] mm/damon/sysfs-schemes: introduce nr_snapshots damos stat file
Date: Sun, 23 Nov 2025 10:43:16 -0800
Message-ID: <20251123184329.85287-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251123184329.85287-1-sj@kernel.org>
References: <20251123184329.85287-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C2DBDC000A
X-Rspamd-Server: rspam07
X-Stat-Signature: ct3uzdgu3nst1kgai8k4j8j681p87ae5
X-Rspam-User: 
X-HE-Tag: 1763923425-272966
X-HE-Meta: U2FsdGVkX1+IBeqG/Uh3EPhKXj4rUw4KQtOkSZm1WwJLyfTqHmveGUL0/gFyTrkkg5sR6G2G0yOuNb+Y2WS5AfbgJ/q7MuatLXdboOfmduRaAoqlM3usGSqO5yMWSWihM66BJo8lY2wEPsVdGK9nY2eu68J4LWo3XCWVfEI0dFFL5LjeZoiiHzb06HJCZbnJWMDwWUQtly0Sprkj0HyrzH6/3ioeHoFLbtnhLxTcTQxQsUqjSTYwheSDuUl6t0u7KP/5llcX/JddefcdegFSX4+9+yOFoKVVW1ECewOc5z2sNowgJT+CgwOXCvYPMUczlQhhNZeGuWHfMz/K3rG4Rk1q9ToV2Lz42r4z56eSRdrTrsr5CUcMcZ9vsI8MLx1eHy1aC46zrFuFgljijDjowLYVDin1RxQ/uhaYAmIyQPTuSQ+CUj+A2Gj6JZ8d1dtDkXLiYmcWWdtWYiUFPmnWEgZKjQ8JtRlTDgPAV/4YzzsbY0Wrry3OudRG5hPT6LdS81Wm2527eLPinZYNzgah/J8Z5Kd9pEpbpA+jsaRnIoDXLrD37Wn1jF1V8qDMr+4LNhkuDFeMrnNgr1X3acnaiK3oU/HzD//xFutsPDnAS9LEhRdxL7RBkGgMVp7aZcszb4suTI4uOm48c+u6XlIEHcoICkd1QTul0AU1lRmgWjBApLbpIdbAWnsqVLkGDnpC+kV/yVtfsDnB+9Fxr9E22vRBZ5Zvnq9Ie7RZKGjFd4WORy4EjJAX7LfNA2kUkMkpu+JvVgYeJ5Ht1XQNU/lM/iwXLlqFdcWGAV4mclgxh5zUP0y5sWrJwIBur+IzkV2fzGQC9899Iw/QBWrP8MqU7odclYVU9CPCRMPywgbYpLb0anxUhiCtqAOfREgISeHEMnyqwaUpQLWB3oYYtlfO5GXGsAy/ZXGMCq53VBcJ12dOQ6KWM8F84ScgXMTW3ab0a1E+4bHCtI1JbIq724u
 05vND2QF
 FsqFVBqztAPKXk0zbvl/2p+4XRkZfPMAcWMrjqopobe8tsppFEmkL+WDDUPtmIQN4nIG0titmS72IqHjTjtjvHyuVoE6D5FIbLSlPELen+PjvmzwunBtJTnyY2TBRo7hZm9x5bCjKN/G3KkI7T3W+Y1qc2f4BwF2TQOcbcg1fml+J7whpb56iq3v3HP5VHs9ag88Za65uzgX0AbNgmid9UOWN9jo8iD9ZAHjpQjAqV76PQiDKAmVmcA26VQgjzRpjvJbaIEuPxaeaIvdoZid0exAfsw==
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
index 30d20f5b3192..4d25469f957f 100644
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
@@ -2761,6 +2775,7 @@ void damon_sysfs_schemes_update_stats(
 		sysfs_stats->sz_ops_filter_passed =
 			scheme->stat.sz_ops_filter_passed;
 		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
+		sysfs_stats->nr_snapshots = scheme->stat.nr_snapshots;
 	}
 }
 
-- 
2.47.3

