Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9408CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BCFF8E001F; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777998E005A; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35EA38E005D; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E570B8E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:27:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACDCB584C7
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:17 +0000 (UTC)
X-FDA: 84008892114.21.8A52DA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id F218D40004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iVRtgB+Z;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760736436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8uMQ/zFRfKcPIET/2cfwTNkRW5xUbH1XyCH1mJ0giU=;
	b=DE4jVoxLFnCoXSiXvlIp8KQsAxExCkQZzcD8iWowNr04lALqIAYKlL1TAL0Jp2NcIDP/yi
	VzXCyeFfnwMg5DeF75nz3/WPuWV5nH0VhhFA8/RGihxefLhitYG3X6g94jnclAfxzvATwE
	B8N5PsyhNQItPez/j6BlTr+Ni7rWS1s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iVRtgB+Z;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760736436; a=rsa-sha256;
	cv=none;
	b=gixHeoWnwfpKWv+RZvNLNxw1f8XfX+E893TSXPBTEFPwKCQNDAKc8HBa3m5IxMZWWll/DY
	0aOQyLpUiH+hFoPqEPw0tEq7Bze8pyISnWfkItjgWpgG/jlsS72DaZtChR86kdJHdHi9oF
	XBtuf9ahJHqMQ/YgN9zwQ96JCtnbDfc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EECF64BAA4;
	Fri, 17 Oct 2025 21:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF333C116D0;
	Fri, 17 Oct 2025 21:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760736434;
	bh=hA+t8CYRK0aSyhr9UylseKV/5BFcvUF8pBgfXixXY6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVRtgB+ZiN4XfZsXsPLqj8yZhnIbqlQOLd2cgR5NKUfC0oQjnbpwIZZ/sFpRaaNpU
	 ImLNc7urtvZEttLUPx5rz3Dpa1Pw9nHvgZpOcLRG2vvhY7wvE/qT7cZJtaxnDs2j6c
	 FvgP1ZCyGkp0N1tRP96OQU0qYNSMKbhlsHGR1/5UO69FgkP6oMQ1UrCGaJzWQUmX7a
	 7cqNMb7TcykikRA9VWs8l+7FjUXarRT6aPKAL3F9GldVQOZ4wJJvohn/WCi6s450qX
	 LNsNVSOv4+zFHPPWl6jcrnLq9WfGxK7E8zeHeqZeeH3YohIkanM3Oe59m3nvzlxm6H
	 gMd3pR4QJQkUA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/10] mm/damon/sysfs-schemes: implement path file under quota goal directory
Date: Fri, 17 Oct 2025 14:26:56 -0700
Message-ID: <20251017212706.183502-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017212706.183502-1-sj@kernel.org>
References: <20251017212706.183502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F218D40004
X-Stat-Signature: cps5t6ak6ya4di1shm61wmqtb1au8wyk
X-Rspam-User: 
X-HE-Tag: 1760736435-501083
X-HE-Meta: U2FsdGVkX1+nFp2sy+giYyXx0wX0dY+Pbu7Sa1/+WCxdIO+CeGL8n+45Fuv74NGvP3eL2XwFerPzDZA8e40yGdlVchOrNoTvjrmkQxCQp29texqXhChGsFrkl/hkWlPXnxhq7dXtF8zwxbA2c7e3UywjnYU1IsK0KoS6FwlxzqXOqq+6IVawN1rH0fvtWy1LNFN73uV4EzzF9kLxSxwFgrHk2Y+5HffFwcyylQvyqu1eWzxCf2f6yEh5yqH1bEDSnYKyhQuDhRmCDdGBiDccP9qJK1M1K0pY98jK9NQcWNVrAxMBcWTs++CM6XqYbaq0oDsmHDiWAeXJRggDOwCgx2nSWVoDmxXzE8S++A7/dVV6LoQ9MLAl6QrvoHstB2l6dftOFe5TRGEEfcKWajHj/PSqDaisv/NRHY1EU8gYLnyDrM67HDgIg9EFJAegfXzZx4GnwaBn1cornKRnBUrYTJBv2prCwBKaxsoJDAHiwttRqZLQ7hGEl5+ASnuSQHCpTdjcT+aSGSxn9+D2aX/qvYxtslFTa/NSd5FPTeRDTTRY6ISiEet17zPhNZbOEOVC0CUkdGL10tIefHiBO10FqcbjkIpvKcCl8ccULadNltCS+agjH4VdM+8El3JmauvqrX+vyo0b7yBLQ83qfNLL5hxGpll58dJtg+TSYuNqfNyYmmcec0jOt0KnMftuzaNQgirEyC9tUMUhc2jkQGhwxSoxrOT55cOROX9z7U/hXsHpqR9artwt2pcelxAF3jpt1ivs5NnTTgmWAHC7tY/2EKxbBhURzY5rvuml15SCvjS2TvUyqrvk+Lkd2ZcB/2B0JHajK9mwtvTE39CE0pUZAyS9lS3QCV55TK6DwRmZ71El8gaytD1HwBsZC3j2FnessZagqchY7bU9gjMdmE45kMEkCZo9Q/W6PDQJgVPGVRnKTGZ8gKQVR4mPXvWe0AK4Xxhjk0o49LCDF04Fp5Z
 tjfvvemE
 gaRj1xP0coksJIWXaCpJvGD4QNnXJSMzXMvtZPvWLXnJpBBqoWtK+5UPjtoqqCZLcP+CD7Usd4rDtSZ594dG8p0gKuHF2u2V6fp10yYP2nQFbpnCoVNhKCIkUmn2w3CoWJ+OZCtMbjsWQIluelpisd4nW4PoKHb/yqIJ/fI/o4kR9kfCYSqIjITk16f4uXmwteNed
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a DAMOS sysfs file for specifying the cgroup of the interest for
DAMOS_QUOTA_NODE_MEMCG_USED_BP.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 6536f16006c9..2c440a2b80e6 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -999,6 +999,7 @@ struct damos_sysfs_quota_goal {
 	unsigned long target_value;
 	unsigned long current_value;
 	int nid;
+	char *path;
 };
 
 static struct damos_sysfs_quota_goal *damos_sysfs_quota_goal_alloc(void)
@@ -1128,10 +1129,39 @@ static ssize_t nid_store(struct kobject *kobj,
 	return err ? err : count;
 }
 
+static ssize_t path_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+
+	return sysfs_emit(buf, "%s\n", goal->path ? goal->path : "");
+}
+
+static ssize_t path_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+	char *path = kmalloc_array(size_add(count, 1), sizeof(*path),
+				   GFP_KERNEL);
+
+	if (!path)
+		return -ENOMEM;
+
+	strscpy(path, buf, count + 1);
+	kfree(goal->path);
+	goal->path = path;
+	return count;
+}
+
 static void damos_sysfs_quota_goal_release(struct kobject *kobj)
 {
-	/* or, notify this release to the feed callback */
-	kfree(container_of(kobj, struct damos_sysfs_quota_goal, kobj));
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+
+	kfree(goal->path);
+	kfree(goal);
 }
 
 static struct kobj_attribute damos_sysfs_quota_goal_target_metric_attr =
@@ -1146,11 +1176,15 @@ static struct kobj_attribute damos_sysfs_quota_goal_current_value_attr =
 static struct kobj_attribute damos_sysfs_quota_goal_nid_attr =
 		__ATTR_RW_MODE(nid, 0600);
 
+static struct kobj_attribute damos_sysfs_quota_goal_path_attr =
+		__ATTR_RW_MODE(path, 0600);
+
 static struct attribute *damos_sysfs_quota_goal_attrs[] = {
 	&damos_sysfs_quota_goal_target_metric_attr.attr,
 	&damos_sysfs_quota_goal_target_value_attr.attr,
 	&damos_sysfs_quota_goal_current_value_attr.attr,
 	&damos_sysfs_quota_goal_nid_attr.attr,
+	&damos_sysfs_quota_goal_path_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damos_sysfs_quota_goal);
-- 
2.47.3

