Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9CD606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CXKLwLOT
Received: by kanga.kvack.org (Postfix)
	id 8DF486B0771; Tue, 24 Nov 2026 10:36:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6A76B0773; Tue, 24 Nov 2026 10:36:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F45B6B0774; Tue, 24 Nov 2026 10:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD5C6B0771
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3EC1FC0C02
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:58 +0000 (UTC)
X-FDA: 85470415716.01.3F233FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 95A4B100006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXKLwLOT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534616;
	b=GodostTfgSShwDgGriAa+pjhzdUVmAQsikZE7k2Yti3V+k7yqLU9VBd8ugQiQ9cYkQMmh3
	dtu1wmMXQqlHFqd+Q7nQgTsTMAzdK+h8luq1F5AC0RbCD/5U09zsOIGVUhH3yTyaelV+pH
	P8XCDIF9+6WltuL6EnCmnf5dMNk4Cn8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ev01uXrsK+5BPeS58A2Wm9kvysKqjK5H8CmDZBBMICs=;
	b=t3MZf12dL3QgbXsre4ESymQTryWW+sLwbUNuaRTUldFlxaNYU2MYvaUjwVBXyXD6P8KOZc
	NstOMmNruMoW61449HJxY5tZTLs30fzffAoyUEbr0DYH0B3NeR5EnZgrkCaMJBCzP+aQZv
	72L0SJhlNg1LqvCniN9fdDbpI7AmtRg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXKLwLOT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2ABF66243F;
	Tue, 24 Nov 2026 15:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4520C1F000C0;
	Tue, 24 Nov 2026 15:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534615;
	bh=ev01uXrsK+5BPeS58A2Wm9kvysKqjK5H8CmDZBBMICs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXKLwLOTnkbtXvzsB/W9j2qzLQC2WWtBFDvNnVZXkcpnzWbgSFQvj53IwkApTm8as
	 ylSfb1OSjpdK8y3daUrvKrmjWBLZBWVF/QNXjtd7R9wiX360sUhNbGe0+1xksyvHUD
	 tnhlcXm6b6LVQE1VQajibUFYOOV2kl/3mcWJEHLzVqfrHOD+rrpG36itQPDjiVd0Eo
	 xHwx1OJgIun5UAukHk1XWJQ8hW71aHFOr4racF93+ZrO8hYGhpLRwAY65ijBzyW+KD
	 h5Jdyqdhl7/XNzVPuNIfL7+PRzFzY74xTNHlPuIoQWSujRoQfyNL66Fu/siKVDOnIa
	 Rw+J7LI3mOW6g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 15/27] mm/damon/sysfs: add filter_report_type file under probe filter directory
Date: Tue, 24 Nov 2026 07:36:21 -0800
Message-ID: <20261124153636.91854-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 95A4B100006
X-Stat-Signature: gtyo7m3miau8fitw39xjupg9sjzimu38
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795534616-557703
X-HE-Meta: U2FsdGVkX1+kUVoyAs55j/xfmAI341x8SeU5gatXIdjzjQpgRVu3ErUkB1aZBxvokSyfw7CRw//HPWj+pWtNesbH5n2zcVtRz5kXlty6BPrLfrn5cQskiv7q/oCURQqSGElgIdjyX4tGzbaL2p/vAOykKhBF1QDB52vV5dqCVy/JLmnC5FOujr4CAZe6nNFsdeJY+vsZ73O7zSAN0O67PAFo9gHBfaZ3aI0WSeW2bqixUXmKvEPdnlLZwWAgTSQ7X8Z4NSe6061HXcvsMuVQcX1qVG3KvLw6/HjK+msv4rx4d2Of1e+XTmZ8WIpQ8VHyuWGK+LyUu4HPJJEVfwWjW5jvFxPdQvfN76sTCdakHxAYeSXbJ4iPYtCO7BVLevlI0Cq4Xy2BGxQoeQ2fIaqKztke8j4jBtl814f5oY8ybIF+AGjzGMRJay8hqrDZWXBeKD+8kN+FcEvAbcLxAflr2FxBhELvtPgfJwjA3rR4Mp5mXCrurQq2bTeEfg6nKABR1jUewVnsI9SDLG8r4lk6kHnC4hjtZnnqhjeOOXmqXowtmcIKFUduaFPoeP9QVLXfgci2iKOAQaoOrVoGmvRTCd4XYk0kn27gzBg4BunTsatWRUh6OF+EYeR+DWaINMO73kDZB12fcoUAP0e8jJ8nVyoezlxyRHXgncX8AeGxmWSTe+jfziApLIUxhTL3E/SbZfskB0H1B1irE03qeUj+yJ0AZgroGRzSpoNJs0E8ahoeRChUytsqEp3uJ6+9YnsDQ/destS3C/uQ1WxwLq6yRPJZLzjHQajdwXe+YIqJi9pFAFbacRl/66mW2+XFKrGiSbbkXfC05bEosTvXHVI29fdCYMm77vGpBQjFNaOwdbzoljPocQGXoVpmIpmZyJKL8qFRs5YsFj9eDIlBM1UtQtRPLbys88PcUKhk47TmODdJvYRMDRqR0jICqkSwBV8kTrAPYLtDSIHErueDvnV
 qti7szRe
 fR1ql2kMywGOm0pu05rYfGNoUufOdUirb3VpXE2uO0PU2OMV5pC7uv6rNaQPFJe6onD7SbwC+RQCSilFbketwrEtaQndSkU3jJ0dXabG08X0yQqnh9kQFr8I9tm2Tj//ZavK/OE+yze+EeWCMDdgjIiAFPMYCOPXMj2ExUqxWvkKnAoJdnL7hRUHXSol0I8pG7dlczw0qw0l2F6/Yao+22MBPntLfMpWl0rImuG44s70Kqs2LnKnbNL/TiAIg5l+k6p1oliQSDKgI36fEgbkQ2yT4yHn0TC/DTY53lUYOw0N4RCvN5yMNaJSC4ZfLUVYNxPZe5tUTp95OF70XrQkenOCfR8Vezjg7+6UMiTvl5zm3cPD3bt8ENqtekrvmvW8Sebp0wnMbUnH3uUWFawdaq+Us7gtJcHEskRI8cmFVet0Z6dgLpqeo3nob7MvbdKpGRhCbI2VIVPDuMzoBvrvvRXAVY4FfZEDWVnOXmG5ToUBiXrmktVsFUVKERMvNdUDuGAbxgoUv7eiweChMc9KdAxG3PQMWaSANomWIkrRSLnp79fZkeEiLi1XPSp2j1bNg2Qn7vG8Be9dSgNd+NC/qcB90nmtAcNuyGiZn
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

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
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

