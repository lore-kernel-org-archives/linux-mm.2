Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0E4DC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40E2B6B0093; Fri, 18 Sep 2026 10:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372E06B0095; Fri, 18 Sep 2026 10:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC5E6B0096; Fri, 18 Sep 2026 10:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 000E46B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:28:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C2781C2F36
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:39 +0000 (UTC)
X-FDA: 85227113958.12.472D109
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E344240004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CcmwbUsz;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789741717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdugPBiHc8ArlRBJbW3eu//HjQmVTaFB93kqP3fmOG8=;
	b=hwLUn3CvnQioFESkB/5T9txiNKHgRGn4YltoTgFcdzs/iUDZSwLgutOJ0wkgvCF0sT0f1J
	HWWh0xc2Jdv5Lil9W7C6opxN6A+D47s45NwCfZkC795pwVVc0q5I5mgSRWEndK9jyNAB1Z
	3/cSioRN1ySTaUMd8uz4675wlgcpdug=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789741717;
	b=1AYdk+WDeTMBp/gknnMIAj9oX+K5EXrUYoqF/JCdVfXLOCpGCdd4gY0D1CJPBjbQGjFu9N
	aCUnfOKa1OlFpKl1KR1a3QEmO2ExyJV67Dh78cor6gtfBuyq0HkRiv12k8x7bd8i8zkvyt
	TKap5FTMYrRNs8kg6qfuc+Q/sarCMUc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CcmwbUsz;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B89D3602CC;
	Fri, 18 Sep 2026 14:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D3C1F0089B;
	Fri, 18 Sep 2026 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789741716;
	bh=mdugPBiHc8ArlRBJbW3eu//HjQmVTaFB93kqP3fmOG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcmwbUszFWpBfQa1iQ2t21vlxzKgrEOnkDWYeuu/C2mXRSzEFyAUbBViytuXt+N83
	 mcvTXeJnZ0S4vTwLZ94shlAVPFgKS8Tgbsv1c7/O40ixcxwZ+H3yVPh3jBlitnMSOi
	 kavYPgIxBPBFBZg35FJCGj8W0ze0edZx2+tRS2wi03cPhu2fQw/CK4uz6YxFkYTDfV
	 xH3hcJ+EnjQd2jbsvJhoAUTue8m/YSb4Ve7yAhrulsaJJaLbOAvSgHWWgTrUsmJ4HS
	 NmR/BcidKZnpmR7XKZ6JkP8nnTnELMjKdwzwtaSXhj84MSNtK7ZENSM0HFfavTv/mC
	 huZj73M295NDQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/7] mm/damon/sysfs-schemes: support quota goal complement flag
Date: Fri, 18 Sep 2026 07:28:22 -0700
Message-ID: <20260918142827.85303-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918142827.85303-1-sj@kernel.org>
References: <20260918142827.85303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bpfyixrwqrryyce79d7c9ugfmeiyxfr1
X-Rspamd-Queue-Id: E344240004
X-HE-Tag: 1789741717-403512
X-HE-Meta: U2FsdGVkX19YMpQfASVReAwDygkNDSeeoXr+lAiJYXbQwFPvmN8+sa94A9O8kAyX3Ou3zwJCjzSMFvTa1mssxXq0IURHT9Sr6PI7NY8XY0rIQouZWAEnmW5a2TpCj+7xn8IF4UNCFn576TgKtzFTk6HR0vy8v/Qnls6L5jYY644lzeKn1pvDEqr7GNfYQevkxUvLur+snGqlKndU2ECspDcRAS0citSuko+W6nCJijbPuBVzscLbfNmzaWJvo5ELyc7eSeRVeTNl5G3u4U1vP3kzBqY/G78zm0gmvuLBAh8gNXwydx45UAL5XwVu2UmN4TnQTj/Mk0Ga7hwHwly60T31j3nCL+iqC8h94kqVpd0TlbPzY2rTZvRmsaYYIY6er1Zjh9CJmtWk/6OW6voty8MeT3QVH1vzUYjl2SPa3ezza/XhGkLxJvZLhnUSZBscJf4xic3txiql6pz20MSx00iqz1p26O13DWJs2/+0LW978Giuhb+dNH842xUggufpc4CH3chmnA8j9K8GpyAqjbbDMxoVL6wrMmd6x6I0iPdG0MKbrJQfkwMCUe9rkzp+4WCAVylbBQZAL4n7nw7ZiB6Uard9hQqsDALmkTHZu4yTDOfpUzrkQjg634LddPTzeAZFRiQBy6ekt5aLeSTZjYPbrCzrd5QmfJqtOc1poroklYdFOrvchmos5tBEQbzU/o1Vy7N56WKSB2XWitsZDaB4QU7bOyNZfuStdrKitwRlFOvh9j9dU0hFz+WcG9uy7aQwe1Vhh1cDkNybIEAXgajI1A3XIgUlL3vHiDEZPGVCspvVc7jKuWYpg75uBqZIwqe6XSL7Q97ZL73nrbqi8pUisH67sWsnhqP0u21D3+4VdIBa8myWMkNB6yiX4BYioFUpmMDeBqLCTs1O6fyVPiQgkRh/VztdloLdMovXEBNRhj5OnsAuJ4d+TnbZ13vSuG6ahTkRu4kPa1kOg13
 gHj0eAx1
 eNdXqR5cWAfHrTXmJmmuOYvQNGr5DCdhLeCNPDEaEieHibq4VDvfxbDMqjcEz6AGXKXR7n95umm1LEwmbxAgDVCVJ21Zcn1BGb0l6EFzgfAW1YmZ56Pk+R8KE38OSQe3hZgywxCOzWO7tq3A8b7WhqUcmv6dM/EyjfppL4DXY5Whek/IkcFl+tZ8hxR9SnneZqP4+B1T5Odyy1NnXsb3ePuk6whhOk85D4jnchfFDQ/2Z+6c=
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
index 06af417bc9a2f..8f083611741fd 100644
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

