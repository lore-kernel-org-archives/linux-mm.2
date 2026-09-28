Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B89DCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA6876B0093; Mon, 28 Sep 2026 05:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30626B0096; Mon, 28 Sep 2026 05:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF74B6B0098; Mon, 28 Sep 2026 05:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98A516B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:33:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 26A6412014D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:33:59 +0000 (UTC)
X-FDA: 85262659398.21.511821E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 82DED1C0005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:33:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AtC4+M7z;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790588037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vdshcv/mUOg+wTQtdfCd8vXc9tZN4VpaqOf6VvBPPR8=;
	b=JyV29Lx5XdkL1Qp1F9ALJe3LaIEBRAwZ4oZpZw3iHhG4+Mkx2WxnyLya5kVbYGfFvmwmK1
	DG+WR3Km2zsuN87UZBX+INqylNrsuDMaGdfyNUD8Vu61/MfKXDYw3K7ky95G5lemmonQzt
	KKygdwp12hqGFNPSwubsoYJu8pWor3Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790588037;
	b=Gp9pRNLQl2CIb3tFe+O6o766pJH5xDjKMHT2t5j1+h5Lh0/dS9vDZaorHpHpory0uWsmqy
	IkjTcktpLD5Ie73tyEGAOz3t1xCWLKkip8vJ+iL1T+GCCnf0881MIBXnfFlPojsevPphgY
	pH0dew/EVyHG5JvUYq5A+FBrKgfnabM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AtC4+M7z;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D5A1743E60;
	Mon, 28 Sep 2026 09:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514851F0089B;
	Mon, 28 Sep 2026 09:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790588036;
	bh=Vdshcv/mUOg+wTQtdfCd8vXc9tZN4VpaqOf6VvBPPR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AtC4+M7zHV2yA+gAd+4igAmWzhN4V4krSxJl4WnFeNhxrkN/UAxpqVHngri3Vrabf
	 ms7scbQpDtdazOuOShWLh2ZBgjrQYPPkBUKTIPf/3ld75olMrPHSHZ2TPmkbfXvewK
	 US0dGIxRTWamajgrBMhHm/XxP7lqWx5CCvFZcRWP+DICwYZu6DcSa/+hYfxFQPAJkx
	 XHh94smJ7FCOcGQcvtqRHQF5nB8bsXg5kY4f1+Dp5J1os9W7H6ZaGOZkmA6UNVhg3q
	 szJeNq4vhBPfP47mMoii4/5lz18BPWeLVzqmiknEwgnJZHHdQRtk8ez2xF4ocaXt6r
	 INMPwLKO92Pgw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 3/8] mm/damon/sysfs-schemes: support quota goal complement flag
Date: Mon, 28 Sep 2026 02:33:35 -0700
Message-ID: <20260928093342.16584-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928093342.16584-1-sj@kernel.org>
References: <20260928093342.16584-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 82DED1C0005
X-Stat-Signature: oyxetaapzrsyabt134emrqkzjoqpgssb
X-HE-Tag: 1790588037-246674
X-HE-Meta: U2FsdGVkX1/Hm7XAat/1FsSsv/TyJj+5QszAPEXN4rob7Zn3qUuwyTJL66IQNsNim4dX0gt1a4dSOXIyQF8GL2uSIotLKopEE1Ge8eS7Qla/J2696K5zz1avwrYLc/nN1R3GTRWH467JtZWzFCwG7ZNvwdf5l92YUYHtKRwKceBNzZOnqJMyjIbV+9BVgNydzmW5ioox1GLk0zZMUpkjet0qmcKdTmPlu5OPnlA8XJj2l64RTMlfw+b8waTIIYkbNxbhKRcoxTne6LhCB0LESbJ6we2pn8J/BDmuj8XFCojO8/qv1QGVe/tXFdeR2uk2B7D4BzAa4HBcQbL+5DS+sWn8Zv3lGDqu1QwwOky3KEaEXO4apunF0ioGavRxcJXXiuHEposvGT8lKwMu4kzJB4LX+PaKsHUHlKQolJXt44yVAhNmB3j46Q/hgLF3/jA7kMEcUo+f6nyhgmCweoRVMUqhXAxepnAuEHDv1UutxEp5pCj9tYMcQLw/qq5mX9bmoX8cu1czE8I46Sv8nFTpbzUPB8Zrr6rb4DFKiaFJmIdzNE7NH3eLtRmPe8rEenDIvYtR2mIW11Y+wxzh39itl8n3PCtmZ15GfiZ+8jsVp1oZF1t3NPPd4sLPIohLgOe+RXfdHJjlUOvO2R8b3G/3/t2M/KHTQZuxI/fRPHVHbVvSU/I2BHN2+V3NUPljwqo7rB7dKqa9B/sWc27iVZzhAySB42hfVaNym+d6eA6Jy3a9HymcQ5T5bEiXW9GLiN2b6Iny34+P+q6llF1ApURjjqn+N6kQLUK56bpmOU4WDkSE0s/u4TsmWMmlSn6tbT6ONzz2aEpVGO1mgwQB/wetnd3IdAvPspEO7wtqfPnauQaGJNP22P2QopFxs1sszMBPi2GKlqcsmfqRU5/VgUdaw42C6jM5SaWlakHnm3BXB9bAT4+1r3DD9K3U8F8BB38IB26KWAU3+4djFWGyCj5
 DygCtAjn
 dhageWXiz+seVL34tL31WWlN4Wm0R86WpfK6M56N52v5//76Lqq5JVHv1E07utW104WEsWahKj6FoltrsKAyWNwOBZGrm4BuG8PMas5UFZdyEe8LYN+KAovRZBGPTzRqLZtvITb9JyVbNgmmlJ+lT3HQPx+7xAbEDYwmdq9EYRXjXqA9/7/bApoeJH2KcqFtAsUg6an0TOxWlUsYzAv0e1PR1SYLldf1CHbXb2XF+ZWKrv48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new sysfs file, complement, under the quota goal directory.  It
works for setting and getting the quota goal metric complement flag
value.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 06af417bc9a2..8f083611741f 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1220,6 +1220,7 @@ static const struct kobj_type damon_sysfs_watermarks_ktype = {
 struct damos_sysfs_quota_goal {
 	struct kobject kobj;
 	enum damos_quota_goal_metric metric;
+	bool complement;
 	unsigned long target_value;
 	unsigned long current_value;
 	int nid;
@@ -1316,6 +1317,30 @@ static ssize_t target_metric_store(struct kobject *kobj,
 	return -EINVAL;
 }
 
+static ssize_t complement_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+
+	return sysfs_emit(buf, "%c\n", goal->complement ? 'Y' : 'N');
+}
+
+static ssize_t complement_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+	bool complement;
+	int err = kstrtobool(buf, &complement);
+
+	if (err)
+		return err;
+
+	goal->complement = complement;
+	return count;
+}
+
 static ssize_t target_value_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -1424,6 +1449,9 @@ static void damos_sysfs_quota_goal_release(struct kobject *kobj)
 static struct kobj_attribute damos_sysfs_quota_goal_target_metric_attr =
 		__ATTR_RW_MODE(target_metric, 0600);
 
+static struct kobj_attribute damos_sysfs_quota_goal_complement_attr =
+		__ATTR_RW_MODE(complement, 0600);
+
 static struct kobj_attribute damos_sysfs_quota_goal_target_value_attr =
 		__ATTR_RW_MODE(target_value, 0600);
 
@@ -1438,6 +1466,7 @@ static struct kobj_attribute damos_sysfs_quota_goal_path_attr =
 
 static struct attribute *damos_sysfs_quota_goal_attrs[] = {
 	&damos_sysfs_quota_goal_target_metric_attr.attr,
+	&damos_sysfs_quota_goal_complement_attr.attr,
 	&damos_sysfs_quota_goal_target_value_attr.attr,
 	&damos_sysfs_quota_goal_current_value_attr.attr,
 	&damos_sysfs_quota_goal_nid_attr.attr,
@@ -2869,7 +2898,8 @@ static int damos_sysfs_add_quota_score(
 		if (!sysfs_goal->target_value)
 			continue;
 
-		goal = damos_new_quota_goal(sysfs_goal->metric, false,
+		goal = damos_new_quota_goal(sysfs_goal->metric,
+				sysfs_goal->complement,
 				sysfs_goal->target_value);
 		if (!goal)
 			return -ENOMEM;
-- 
2.47.3

