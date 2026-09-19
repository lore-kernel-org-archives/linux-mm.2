Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8C1C982DE
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 01:14:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8713E6B00EF; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808ED6B00F0; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E87A6B00F0; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 330066B00EC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E18B1C08EE
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:11 +0000 (UTC)
X-FDA: 85228740702.18.F044117
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id AC69280003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m1PGPwZE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789780449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdugPBiHc8ArlRBJbW3eu//HjQmVTaFB93kqP3fmOG8=;
	b=B37KHo/vOA8QsEJj6zehW1dRiwXc6Hx7rSlE9f/Fsk8ZrtFQctRZKT9FAKm21Xlf/zcCAR
	LlHYqJhEMX2nWW1ARF+TVJX10UcbIR9zwaLYCDJqBo/oIj8vLpJCdvELJ4ILbzTl462X1m
	VzUNkaNFe2F+l9wwfmniar5SauifY+I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789780449;
	b=foYxOjTB6ShhYYHQdtq+Qc+TT2xB25VboGrX+stKw/wioOssS10QIMD/JzM5uWKEzk/Uev
	AG0BU7fLGnmbucrNJWIExcTHyEN1qPKD3l7Q3hx8Hngp8f4Gjtq+mulVWNZtHRXsOMNE3t
	ud0JktMjZ0qMPA1NLuTTbNyE0NOqZ9I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m1PGPwZE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EDCC60A62;
	Sat, 19 Sep 2026 01:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D451F1F00899;
	Sat, 19 Sep 2026 01:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789780449;
	bh=mdugPBiHc8ArlRBJbW3eu//HjQmVTaFB93kqP3fmOG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1PGPwZEpabQVLOrfZZd3ej07IScuWuGfXtuYHxYWPlsNF3z869jz4W4qtpuUQIsQ
	 5iGCfCYCn+2sQh5aMVJDThYTZODMNFrfueep8QO8ICFhlhEdmHUqfWOsHzuSNKPNL5
	 OpkWNUenuEdsReDoGbN0m6sqXNzALZ/c/7IBO4AOh4kbaJd86z+b7LhE0NymKHTDHK
	 CfuJS39ia67mzBbf7q8uCXGB14l0RHvTWZQYBXMlFfAmsXoAJnPE97A4NJOlgCil2A
	 LVQ2Im4GmNYIaKI7KD92/R3lSYZYio+Yx534nm72kXHDoSYcLz4SUOO14evjxd6CEY
	 BrQiRVy58YoiQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 3/7] mm/damon/sysfs-schemes: support quota goal complement flag
Date: Fri, 18 Sep 2026 18:13:52 -0700
Message-ID: <20260919011359.88921-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919011359.88921-1-sj@kernel.org>
References: <20260919011359.88921-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AC69280003
X-Stat-Signature: dheka68obwpgty5qp6cims38sa4ih13u
X-HE-Tag: 1789780449-532721
X-HE-Meta: U2FsdGVkX1+K+5hk+U0q7GEWw4UM1n69apeoZcYfyMK1hjU2RIJGwe1c0k45dZkUpUqfqdRQwZsbj2JSjYnFCfIwJSx0BJkEB4Ghgpdd9f3j1dcWSoWcgkd4BmTBYrTcBTqINH+bVxQ69TpFuy8KLpVX6O7xfDq+vdf+iMuMUBQ2YEffM/uHMX0eByEwG+9fkp7Mc68dqv8bL/zPBGuWPawrNMVx70j4gwo9GDulirOkOz6znUzWBHdUvbqAtdl6WjXhzUOQShKPkTqP1v+HTM9Ja09OJOA0lLI1vP8aqpr40EMkPv6y6IrU/KXlfMRkSmkfGTo9lKptm1xNCHD14ux7S7BghTejvop2bIVV2R23MJ9qR35PFX/i3a6R5yNtEQP6+D2RvDpZ1z9XslI7dWaFNcUzjengpWr15nimbWz5VmcMps/kHqsX0YqqT+eqyD8tJc/H0JkhasuP0qmW3Umsg/JPhKWhi1lPiHQEdVdSj+0T/v7fwjxxPeTAIlK8n/LBI7muMcMPac8bgMlQdKfk934YEpcPrqJWGgsg941S3MOrpXtZ2xDXSbG9qMd767o5Jkzf0X7hhPhKljKu9wVj8MPe+sUEHQPLSFMsNVpXT8SrmScziTwxtphlYibDP/EpmM+vr0jTRVVyPHobZnYqOe8OqAuNtqtleKpQbi/H+pm12FnCu7qdUzJqngD3ryqLnD+DbGHtLOFk+CdM8qkHY4oyYlEDO6EnFyM61aZOK3c2NPQfjIf4+g9LSmEkVnrJQM4I0zSWaodqiwXl8Z8y0EsqglUs2j1iTwaBP5dyWbJDqC8eLVy5Y+5G3TBYwQGGxfSvavJ97Tui4FEi+JbYhR4+h7CtE+pcNy2lhv2nXKhSE0QrV9lExhVzdUmhNUV8sjv5rwUymfHsdYq9b3dTqPr/JSDtAcQAghC9BdUUCEAz2Ny6wZse/gn0hgVdtpgYepC4Fyd4Xkqca8w
 8Y24Ud/Z
 78/bjh6w5Tu9I8r/Vkeso5A8ba5G0/F41EFLRMDiNbZr5qDBomVsXbdRly7VXQJDz0upXT8uLB0cktRLy8nIt5XPJ0sAmKbmAu6Xbg7w5X08Oh/OWfPwuJnKsG04WqnHx3VSvO+DNvJD+hSH3z+hT2xA9WYihwyb+SxWIhyjp3DHsZewCPTUPprcuemmBEZnm0NKNt5QvET24XoneFTPnyxbbKgbEACPAA5IX/55tguqDbzg=
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

