Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91BEACA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D783C6B00B2; Tue, 29 Sep 2026 04:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28B16B00B5; Tue, 29 Sep 2026 04:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17A86B00B4; Tue, 29 Sep 2026 04:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB146B00B2
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:01:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F8CF140420
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:28 +0000 (UTC)
X-FDA: 85266055056.08.EA93859
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8B59E4000B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MbeWfGyy;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vdshcv/mUOg+wTQtdfCd8vXc9tZN4VpaqOf6VvBPPR8=;
	b=qQBuNkY4hlPOGsmbXnLs/hVYDVOC37Lo54eiICiSptKyFWHwK5OHVTGkBWGTG7diridUjH
	iqoIXhBaimW6nwClWxXIMNGo5sO/TAPO0lhi2w0GIFAm29Tg7BkASbx9j1BkT/PRroP185
	9QxgXvfOpkpPgHcxA3ggGs4eb0AS5HU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MbeWfGyy;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668886;
	b=mYOulodCLHz9bN0u0ABCtwwtO69h/AHgBDmMI2KkbzDZtKP/+CT9+vdfDYdO04NIOl6gkH
	HLz2C91zcpkLmuv9cOfo95zCBE+aqxB+kP0F8Jlz773Ylh7zYhfe8lKJUJs3vhDzMAuQeo
	GQnkVxEf+gXtqfct4Riec0CMF873opU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C1A560A64;
	Tue, 29 Sep 2026 08:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD281F00893;
	Tue, 29 Sep 2026 08:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790668885;
	bh=Vdshcv/mUOg+wTQtdfCd8vXc9tZN4VpaqOf6VvBPPR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbeWfGyyGVmf9Nwf+IvIw+7uPBJ5WZ3hZKD+wZS01OSH2JFpEdz2T/OjeifbJziMt
	 im7QZ0pbfZCGkC4b88De+PFnUHo/1CFrCDJLjv0ORG0zkjE7nAwykPsZUpv4N7Yt6y
	 n1HqT0OjZu45FJbHiaYVPjutqRavasHqfu++cDGfwM/icx2udQSYkj+gFIaFVWnXP/
	 mb/REndkaF+QmMry9REVASASgrN7NQV5dMrWVOIl9UX024koN5ytSxXG+nfMjTN4t7
	 RbS97UkPfSWJ3sfrDMZLSqfsQhyZqxNj4R678BaCIMhVD9LoSmIzLF3nAfrqILoUoX
	 SbTAbLhR2hH7w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] mm/damon/sysfs-schemes: support quota goal complement flag
Date: Tue, 29 Sep 2026 01:01:06 -0700
Message-ID: <20260929080113.41708-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929080113.41708-1-sj@kernel.org>
References: <20260929080113.41708-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8B59E4000B
X-Stat-Signature: ppm3aaxgeb4jmwmd1fznfoh6n5rtkyhn
X-Rspam-User: 
X-HE-Tag: 1790668886-368349
X-HE-Meta: U2FsdGVkX1/UldACcvVC5ZVjVcCaQ4W1QVS821Qa6mtBdtNK2tZUmS5Wid5VdO/1rwdkK5PBJf5I+7c4WGRujDmm0ohghidk341xY9TzPEisnf9MIb1m9baa4mCfra3qx2aYArKDOxzanCc++HV5Bx+xSHr+fX019JGYZ6Y8tbuiDj0Zr4pxshtbdxWJPTuh/aUv/ITQ6RjDQPS9cC3FsJKg2nRbfy66hfD/EtcNzPdyfWSXgRhnTA9kJ2nJA6tcC9eUCEurV/HOijZzYkJ81jb1nB8wNqE697O5Qy1ZqASn0K41V76R3//efsLBKRijnJwMHwkyjQcIoOPirRt+Y66+/4qkJjYgD6Sro7npHFIu3/tLcHq7DC4IvNvl6lZl1M1+zT6+z8ysYrYTyx0tyPfIKbrwvfYPdppuJxhITUQOl/oTDTiZ2s44SZ3a1cqqklOlXkQVUa1FRw+kFz4M8nnSvIfN4Rh/YhI0fumgebFnC/sfHvsy7xErBkj7/HEMjLR139z/nJBtPpJlTDGhcdgqNs9mPRKrgRZTtxivDDTBROotpI3HVo9+QFLpst1+Y88exDIbB+xRwKaoHBaujkgIxaCvGboyHyke1A6o7ZL6wJ+ATSTiexNdudaXEKRGbxdBjDpYvCeQfigLGCD5l+NFRPG2H6kzaZWjGXhGn0NQxnK7awX4oSWZv0KnXC6mOu5nq2rWuTpyzshArEFEXCun5z0CfBryZZ8GrTV/M42ZFWxb2vZ1oV1W8Fc4np9CLzNLOsdvlxM0LUeuNlc5GnQvQIzwaxVg/3RE4T9hnpdvrovyQ1/j0QcnTneEDEs05CjpE+UhnBhMy+n4QQ7eGoJRV4elWOf8Wa/2TJD76KIsamjxwmKhk7n31T+fcUrorMiUV+lN4MCz1zQhFA/2KD0N8AxvZ+ZlEv2krGD/s0I3FLmX5S31ECiBhduDuqCHR2BUoWWrLUO8y6f9/rD
 o0RtgZXs
 VcXoO7VK7Rp5e16BU7Sh1HWdTLCMylvzZ8/PwtXWhr3t8kgTZz3Haq0qdMWLD+9fXCstZ3It8n0zQJb5ukM5Z/1v9zKDae0pwZG9Yp8icFqso2/62KtRYlzOsRPz4SLMszuvVqHP0iKCpHFWGxvt6MGEDAVXrr6pNYX9PfmsuHTsTRFMwgrXBZeIH0+HHh3dac3lFGO1Aj5YbSas0tSVYAqqUIK1Y2DVIo1SgFD7NhUX6BgY=
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

