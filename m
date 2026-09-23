Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97503C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CF676B009E; Wed, 23 Sep 2026 06:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6FC6B009F; Wed, 23 Sep 2026 06:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3D16B00A0; Wed, 23 Sep 2026 06:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10C866B009E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:15:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E756806BA
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:10 +0000 (UTC)
X-FDA: 85244619180.03.78E32C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id EC072C0005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ezQ/1aZF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790158509;
	b=1Gbkz5uRdRh5j/5AC6qn/9WqRyo77kqaMrvcKRnbWKK7dCkqUOiV7oYrVcZ9cxjxtcZkYy
	KJJvgrtp+fubF9shLM+x5BPR8mDomU1QGLmxnLHT9jQJ5JEP3zSqMluPn3nCekT6HS12dj
	ui34gCJUuUFu7hRvdcH5+1oWjyI3S5c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ezQ/1aZF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vdshcv/mUOg+wTQtdfCd8vXc9tZN4VpaqOf6VvBPPR8=;
	b=51NHByuQXwfbig/LeygGjS6gNOAMzpQdqg4afAIQVCarZffs7frDFvg5f0NAVZWq/4iRG0
	aj6v159SYddlw9w9/pqtC0TkGFYjyRGH2ueV4oX5gHi0rysHzBDhqNY2usNsQAHfaz0ra1
	OBh2tl/Fs+qlWQRl+UQiSQ/GBixD/Qk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3187843F9F;
	Wed, 23 Sep 2026 10:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B861F00899;
	Wed, 23 Sep 2026 10:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790158508;
	bh=Vdshcv/mUOg+wTQtdfCd8vXc9tZN4VpaqOf6VvBPPR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezQ/1aZFalTx1tc4WE5blL0sFdIGueOVa2fVvXYtcl4tnQjsZpVE6/3DZmYKpS2j2
	 AlOsmVC0ztXMRHfdOqVCQ8wFy0oPhA5HjanbrKDHGLeFksOIhhjkMMYORRYruvDDr/
	 W5jQERYzL4cgj7JwdZHzJZH3ClcEkANRBYkgLxJQdDqJCE6s8WlDLeQIefj1PKvNdl
	 2xH1mhb8R9SBg/8JMX0nQlKK7xxkvVeEYg7eyi8Rol1rAgGmwXcj7X+3td7qmPefuI
	 2yr1fbxck3+wxbv4y4bWR2lP0BI7N521e8EIOPO1qmBHEgJ7RftGcOigq+Q0nKW+Ik
	 O2lWBP2mnZiyA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 3/7] mm/damon/sysfs-schemes: support quota goal complement flag
Date: Wed, 23 Sep 2026 03:14:48 -0700
Message-ID: <20260923101454.5748-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260923101454.5748-1-sj@kernel.org>
References: <20260923101454.5748-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 49zeyu7utwbjd55sh6o4goyye4wnp489
X-Rspam-User: 
X-Rspamd-Queue-Id: EC072C0005
X-HE-Tag: 1790158508-1802
X-HE-Meta: U2FsdGVkX1/rI6UE8O33+6XGYYlaacTXwRLkwz03Jk3xQgux0qVFvQePJbhY0iC2l/RPrNfPNEzZ7O8dQe4NoIZxnkLnrxe3C1ussd8cjaYEpfdlcMHTMtoxKdF6LC82LKxeAOgSGQv9ZLnFOgVk9zwBOQOPPVPWsU5QjKw3Etzw1fn09fK01M4B1wF1mYoWtrDFFJ5VwWfRHM1i+DLw4RpWwZChwoCKR9N5cdCldczpPZCb5PbkHNNI3NOUq8oZKu1jySH9eQs6gJVIIAWwWgTPZ9o+aykH3wQ5BSHO0X9vEZjeXucw2znlS2eeAsObav4bz8a7sH7zvVgFZYExD8SMBOIRFqz49C+bpC8IbBiqXA9yfeCDAQJ6tBGpTyx1hoeclTwVA/MsYYzNeMacwhmXD/hfQZfnHdd6+YUqjtqFC1MTG9jTG5tP440f5ZfusFP980QKoDOd9/IDoIEqFkEKqsyyFmVbguJKL5P+nX/amIfFBGLT7sTGFA5hJciADNyBX6BCFmhBwfhAXekrN8yeZHMcYc5ocnA/2a+U5XBswpG0rb+YUH8KThnF639ukTSi/7ZfgJa5NHVp94ClTwO4BzuzLTdsWE3w8CrhuBm3qdlw0YsvKI4ijwjHBGbpAqwMTlOD+fnTNMuAgclGNPbtBhzCudEwnD5ED7r1lQb3eNGUcdHQejG+I0fAR30R6HGnsOymGdynvNTsGUzR7vHcvICX3stms9/y8O5TnTjd0ePHgrDTMsIilvvPC9DRSXafFW4XTMN70k0bcst39FtwGvKOxJAOqQCzDhsi/zZ3JisJabJInN+Yh1KpdaTYO83i3djiz3S7j27pzWSbZRJsmD8//2uuQKdcE5fjrGsuxonWMwp0INy/mLQL2q0JwFeFYvcuxKycmHpDVPANa/FDb6VTP+LcHeK7jLW4fY4jkLSdXgPusb7D+x6EyvNvA1kzhkS4FdI4yRwDw/D
 4OvOU3Kf
 NYylKCm2w7URxAgMG5b/5k591i0qc+5jcfnb3gE9QBqasQ7jJ8OxJ+nQ91Ak3F7p5lhFC1jk/BKOiXywhNa/EF5gh8QOp0+R6AiBpAva9QwgdP2Ej4jWO9nAVfD50b7T423j9OuWNMRuLSZv4JbyDOQS8SJ3KocGjkYRyfrbiiD463LYFXKcrqPEHRlpq+8sEDNSpg7/Cna6nmJ9iCx+cH3wVYLoCjo80x49BTP26oOue73I=
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

