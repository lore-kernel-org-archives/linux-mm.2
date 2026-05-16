Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0AA5CD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC29D6B00AC; Sat, 16 May 2026 14:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA9A6B00AD; Sat, 16 May 2026 14:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852146B00AF; Sat, 16 May 2026 14:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 652496B00AD
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32A0B1C02A5
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:36 +0000 (UTC)
X-FDA: 84774141312.06.C67B4B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id AA13614000E
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fyMPxbky;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956654; a=rsa-sha256;
	cv=none;
	b=ab90pO/0dxj/Y8alseioBqJpSXcgsRbKZ7BVaZTd/3q00JCmazVHo0p0Dv+RiL9Dmy6kJL
	33BxURDl1jJIxukXZToFtzlhDR//f/MmcroSyes22sJKwGDveR7xXZkGAT95/5wJUJHKlT
	DW4kOSmCgld2bag6yQwh8IYrsGiXp+M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fyMPxbky;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0c6c4l5FplDP4Y5l40erAT/xesUNrlGZAof6YhS9THI=;
	b=girDMQjNZN83Jmdu6V7AikTLBOeAhrFz+c6uqc72bn6/A8ZiY98MGMOpmn47+xYjBsbBfG
	hKCZSU48uDZ1cdd4fJdeSGXM9iUbTUzgahivO3AbTvU1kO5palQxR+BSVNeU7GXuI9cMMF
	1YAhrbAClfCUW/b+Q/wVeYprGb1tfDE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 46D0F60210;
	Sat, 16 May 2026 18:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD42AC19425;
	Sat, 16 May 2026 18:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956654;
	bh=tDrZwwwBJNmUwPRaRB5h2nj7rIVewmnnPdFzESzb/3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyMPxbkyE3jwDn8+alcqAvbygDtzlIldCESN+H++74MEQT9AEKEtEcvqMR9AFYugI
	 XxPX3L9MlhlkHhA5si/Ayb9/wd7emxSkNRbpOKOZd3Jx6fcbfWGCxn5NdcSKp2Ci6n
	 oP1NZ4RSpjidYjt4dhtn7Bsp8z9VAsBosThF2cchU/M1Tn3CG8uwfBccv5APmdRuRL
	 5vY76D7dAe3ClIl24EQnB2Up1/qvX+C63xjFfXL83aTK2nfwwqdnyG+dDT9uLunmM/
	 S3LulO3rpnW+7amTGKXmyRSnR4sywkTpAsR3Ijqd+lB1+O2CKd1Ucm1Z8pu54Anwmo
	 GgBIAVHzq8kLw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 24/28] mm/damon/sysfs: add filters/<F>/path file
Date: Sat, 16 May 2026 11:37:05 -0700
Message-ID: <20260516183712.81393-25-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s65bc5158fh9r5ciz8em1i9hj47a8ufw
X-Rspam-User: 
X-Rspamd-Queue-Id: AA13614000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1778956654-224454
X-HE-Meta: U2FsdGVkX1+EPYvuyl65KIaPe+sJN+8/FlYkGsJMcJv1E64B9qpBhvalJYORb0H3SVvFzAq7DcNiLmn+ZVZIdlTnRzZiAtwlkw/h8XDsLTFHFeJrbiKmFTuIen0Oe5zyRKiEIF8WVRTUppeupUWTv+Ga68JBRfkt+e6DdtZs/P4BDRvNr21ZN1CvODUjGY6D0q1tGjRdFciR9Gew95Dm4QojEFtmajXgTdDdomlgGYo/owj3P7ZparBHTUb7JpNH5WkQThIAzfjkQaS7jn56qtoa4yHDZ5FzFTH2FF6tC8czZ52rxRNo4WTJG+IYpJpLm/YlR4puZGshrFQBbSpRGI4ZHa6EffgHoxXOKV4Krw1xYVPexx11MbhJCzVTSHhvK3tQDXCqjFU6C+lmUASbp7hi0zbdcwg7caLVx0WzH7p0qmlF7Z+806JVHC/+G7hSPeTS9hOQogpI2bnNKwvMPLbyhvELwAmwcD9XeKmCvSEtiRun0m0aYaD+vG9G01otgoc5Vdh0WFReijcBNPESEryUuOSqH/myw4KkHzXNadj1Z2ZJWE5aMHmsOyTerFCxE22+dqHO9diZdAdOvJVCPbokYeWVkU0bS1HohvggxrcbpvNp/R5v5P8uFZGYw/qGGhpzJYGmo7PFkNA7FgqddvK7Gu+Y9itx3CjdpIARRnmJQ85/tQYfvdax54abhC8rRVmS6dnOdiNVHfoIh+oV5sMy80cWUodKtfbl8paacZMZ1sB27LKdjupyd70KZQ+yoEKoxukpQVXxGk74JpKQwTAW0Lx9aYwBj7IpSyjRV3xAQs4LvpROgmTKX21oGQtHC8OTpnE86ll781ICNFjRUHoWVzwyx74qqlzPLxiDpzOAZ0OWiHzcDVhNdfAx2bIfGq1N/DUngEPMPw6v0gDzxQSuhpTQmPttXZjrV04ws2yr9tf2Ex+T+m2JkMtaZRiGAwctWxjS1eNWAjKk6us
 EBZyDrqy
 OBrlSlL+Iaj/KP+crRrNf1bf7HqHjPjDfHq2RL3V6FhacROH5NLNuajt44SyEI3aP9gKWGbM+OxaFC8GB5HP3wa2SgIyhM4m9ogb+0sjl4h28xDW9nLd46PzAsQQDDvr6IJC9CY8puvJ2edyKPGP9KEilkTAlDAQ/rGVMakuMh/3Wx2FbiU+A1GU0wgJwRCJ+NXGz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON sysfs file for letting users setup the target
memory cgroup of the belonging memory cgroup attribute monitoring.  The
file is named 'path', located under the probe filter directory.  Users
can set the target memory cgroup by writing the path to the memory
cgroup from the cgroup mount point to the file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index f1b7d79386866..2df1d670ee77d 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -756,6 +756,7 @@ struct damon_sysfs_filter {
 	enum damon_filter_type type;
 	bool matching;
 	bool allow;
+	char *path;
 };
 
 static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
@@ -774,6 +775,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_ANON,
 		.name = "anon",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_MEMCG,
+		.name = "memcg",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -862,11 +867,46 @@ static ssize_t allow_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t path_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int len;
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	len = sysfs_emit(buf, "%s\n", filter->path ? filter->path : "");
+	mutex_unlock(&damon_sysfs_lock);
+	return len;
+}
+
+static ssize_t path_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	char *path = kmalloc_objs(*path, size_add(count, 1));
+
+	if (!path)
+		return -ENOMEM;
+	strscpy(path, buf, size_add(count, 1));
+	if (!mutex_trylock(&damon_sysfs_lock)) {
+		kfree(path);
+		return -EBUSY;
+	}
+	kfree(filter->path);
+	filter->path = path;
+	mutex_unlock(&damon_sysfs_lock);
+	return count;
+}
+
 static void damon_sysfs_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_filter *filter = container_of(kobj,
 			struct damon_sysfs_filter, kobj);
 
+	kfree(filter->path);
 	kfree(filter);
 }
 
@@ -879,10 +919,14 @@ static struct kobj_attribute damon_sysfs_filter_matching_attr =
 static struct kobj_attribute damon_sysfs_filter_allow_attr =
 		__ATTR_RW_MODE(allow, 0600);
 
+static struct kobj_attribute damon_sysfs_filter_path_attr =
+		__ATTR_RW_MODE(path, 0600);
+
 static struct attribute *damon_sysfs_filter_attrs[] = {
 	&damon_sysfs_filter_type_attr.attr,
 	&damon_sysfs_filter_matching_attr.attr,
 	&damon_sysfs_filter_allow_attr.attr,
+	&damon_sysfs_filter_path_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filter);
-- 
2.47.3

