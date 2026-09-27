Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7132C9833E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 12:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B19C6B0093; Sun, 27 Sep 2026 08:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93BF06B0095; Sun, 27 Sep 2026 08:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DCB76B0096; Sun, 27 Sep 2026 08:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC816B0093
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:05:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D81E2A0A47
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:05:52 +0000 (UTC)
X-FDA: 85259413344.14.16D0CCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 42FD940005
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:05:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B41n/2Un";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790510751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vdshcv/mUOg+wTQtdfCd8vXc9tZN4VpaqOf6VvBPPR8=;
	b=YzU1cl2KqwlP69xGEM8GJtH/3BmEcWPvpc2HMmG4Pa5f7JGw/CgZK9mUYDqCMnc9cRZGB/
	mDeXzXnM9Ek9JAAQ8OmPi1rt05ujhqoZy8bOT+BOhmsy0HgVYvtcHQB8OsitK9rnx+b5j5
	0DVRLa8Sm6DPWmIg7sn7sjetIYxwAK0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B41n/2Un";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790510751;
	b=3vy9mJMi6Fh71Cbs5AuEqdtS0k9V1uavawlSD02imXXx+Wt1OHnzhz6AsqomphYJYRbXZL
	v9wAR3dLq0jYFJPEwXMiTOTYZstjTxedzfUclFFf2KfDx/OWVU9UrQFNBISBua6KYqK3hZ
	PwUgMYTTB6m2vBCKqOkgmxq44M2O0ls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA09A60AAE;
	Sun, 27 Sep 2026 12:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1876D1F0089A;
	Sun, 27 Sep 2026 12:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790510750;
	bh=Vdshcv/mUOg+wTQtdfCd8vXc9tZN4VpaqOf6VvBPPR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B41n/2Unc9a6Pk/lnd5/fPIKAtj2AbHv1bjkX/IBG1vWxEugiJwc+hUw1s0wvezH9
	 uc0XOKzYZk7hTBPKo3+yBBu3WeAmQhHFdxyXapVZDGI2dW8bI3ThrY9l6jYCatavKv
	 zhh9kRQ2jRKxtTPpnWRCd6jP3SGLLsmXA96ddiX/NZepA+quvotd/Jk3TAb5rX0e+J
	 z0laur6Y8B9KezX1cX5sHlaAsRczKQ8JIm6LfmMbo5XGWAQfgymAVwwbWs8htg60+E
	 YxLLh91uqMvUqlpf/bf8FC1fBNWoPRXmhrfpDtxkuxFpdUKdhq7b34VWohvCInYd9P
	 emUSMb+DclfTQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 3/7] mm/damon/sysfs-schemes: support quota goal complement flag
Date: Sun, 27 Sep 2026 05:05:27 -0700
Message-ID: <20260927120533.50484-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927120533.50484-1-sj@kernel.org>
References: <20260927120533.50484-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 42FD940005
X-Stat-Signature: spmdru3e3na66ho3oqaog7juy5rwpo4k
X-HE-Tag: 1790510751-594206
X-HE-Meta: U2FsdGVkX198BzB3V2zOpyK8b8OzcUQeJpNo3WP2QATklux+YOPvrI8L8l2lmgwGMjP/AUSQkjY0BYEkV8w/9FEAliZfT4M4Le98EJcf4u6WUOWurPawqJHd4GycfBC0G7pEvrS4PVGUVD8prlR4yy/peYcc26eCfoSwQ6CCyWqAXYCmg9sE0g8b8sMJJ3j1eW5KNI1hWFubRsO/oY44m0Dl6bAMNQWnNi0Mb1ZYT6LWhbYw6v/pyTAdJhQDfdAC4b7peWRsSnfBIkpXSJhHKGWzMWUavEAr5navkdes+86Agl1CTKPUUe0igxWTfKBO4+IKxKZMOinOMOhZG0OqIAeppMeWOJmW86BmktgqDLJXqKeyQPfGiH8x1spMr0j+rx8LmEl9uks1Hp6XgZV/7EhgB/ddo6OaTPtalk4HIUqVqoXD2GiZqv9RE9IRFRYssEKTMmjJRyhS+rxXhZJgPVD2XCSnQJ9sZkoS75+gzxs+E6DB+vV03ceEzLzvL1r8o5WV9Ck0ODFRhiASQi9sJyu9wmEMNAKr3+uEKjZpDrAeKgKcRMPgnzGZa4hcqnNFEmRq3/pBwOn6P410VxxfTPGw9MZYNedmmQJvk0ScOjyGRYhfGISk6GGdt+q4kLiG1SDagwB5dNOlMOeGnOtx10D13J4CkfS+sBpQ0X6YzyR8d5Bb329DfanLHL5imCC/m6gzQw39VP7xK02OwcWVp0GtZ134pDv3spnX8Lek+4OF0B5DFcsgxZAX4O5K0nGTuFoGMBu0UPPf2pBV3mve9Va6djArO2GLjyyzFjhxv2kNALkaqDKVVrYZI33Lwoe8YSm+WE30tqILRb/0fXP9yr7ViITsS1DJN875wWnK5Ip6FPYIGdlHBdJ4tZejRN6A9HgpVaFzG0GEEFHfTz1nNed7gXq8N2APVBqkIGV+VzV4a67QEPzpNJ21W1SJaZnQK/vZ0cqtTabCBn1r2jq
 2idp0Jdo
 V2H4XKArq5UeN5SfjfK56fgGTdmiLOSZZPhL/VCgW+TwO7gAejAEcKWN5rwVyp7+2gCkGK88ASFNXK5PMrldjnAa2w0bM+U7WGHBnjb1YPqtRoLjfReW6WwwwX9uGXl4kLiK1hZLax9aqs3gobgQQJ1wCLXhzTL2yWOEqo6RxTq4ZuCp0zO6RRYqWBCUHjRNr8b8lXO3XBSjM4NoBDR8+B2zXpd5/ZvU+ZQlGUp77oTjuN4E=
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

