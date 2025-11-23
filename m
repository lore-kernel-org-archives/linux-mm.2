Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0577CFD316
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1A166B0062; Sun, 23 Nov 2025 13:43:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB206B007B; Sun, 23 Nov 2025 13:43:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD6A6B008A; Sun, 23 Nov 2025 13:43:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5D2406B0092
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:43:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25AE01A016F
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:49 +0000 (UTC)
X-FDA: 84142745778.30.7D10576
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 92B2D4000F
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m7HxFeCa;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQEeSYq65OdK8LHkAx40lJg0TCRNXFMFVm1+DJXuVcc=;
	b=XQzfJ1NunM0uHH0ug9dqComnUvQ27/sDzFETWyrmQM19w7dS8qmj1bpsjDlsybmWky4QkK
	501dV3MppkQRgVNJWu6twhNiI9m0twblIiavgItoE58yboGN6q9CsK8cNuJUrpeBeU8Kqj
	W6BSxqSLp+znxbTS6obLlFkwTmZIRv8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923427; a=rsa-sha256;
	cv=none;
	b=7Z6LH8YDfPbbZxuEAbxJ6WHKbM/F4NXsespNhMLru9P+lu9qbLX6+04VgWmLqVCN778wJl
	jt0ARCchSyYR+jwH3O9x+n9HWcRWJYmxqt/4QIyxvN7YXzRzd8PVjMsVcnx3I/Y/e/dsjI
	7Cus0FXGx2xjZlDw1XOundr0LJtrBYo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m7HxFeCa;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 120C660161;
	Sun, 23 Nov 2025 18:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958BEC113D0;
	Sun, 23 Nov 2025 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763923426;
	bh=awU53/r/mJ37dlq+2AaGq1embqTuZiSy+X46MMp0c/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7HxFeCaHrBTLlTWG8+buUOpiNnqvfr0i+qXOsXwg+vop3y7kwEJQ2OrS2h0If4kx
	 LG/3OQGqYdfncWiqVsxIwLJ4NE2sse7JGbHCGI7ITXUuUA00gZa41WhGZXiicESW6N
	 zwZumy7ARMNi9Qj3MCrGCtzb6Ol1vErJ61JfrW2cTiOVxeazUKkN91ulqhnWBFnB1R
	 YHvVlbsP7Oy7//APJxss1XHJ6b/b3Wjr/uODztVxRbn1ZtT63Ikps0Naf8jK/UKgNM
	 6JStTtSwTRvU/oi+7ma4d4L6MgNHKctk13+N+z58m8EY0cu8iJbG0PubO+4aIIDUtC
	 q+GOYSwrAPOhg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 08/12] mm/damon/sysfs-schemes: implement max_nr_snapshots file
Date: Sun, 23 Nov 2025 10:43:22 -0800
Message-ID: <20251123184329.85287-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251123184329.85287-1-sj@kernel.org>
References: <20251123184329.85287-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 92B2D4000F
X-Stat-Signature: rinarbzn1p5mocx6dtbmxsynarmac4d8
X-HE-Tag: 1763923427-374782
X-HE-Meta: U2FsdGVkX1+VKn5hIHx8h8cPYJmOtdBzmodc+Itc6Dk923AmgPHP54fyu2ICx15CbxIsSdkar5RAaJhKj4daVXiOnDCKt8PQbO7CNRMWvHPLvO40fo6QPfJ5pV18jUtI15cl/mRXDRBFVQWdyKGYvy2AGUPtuXD6Mz+9yHdA5dcarIXFLrDhucdSWKjq4PsQps8vK/Z1qJ+99l1+Qa8L9nakheINb9VGBHeLjyR3U36HqEN1WjX+uuvagn7XAK4p/Yc2Jt8YwVuODfUpWI0qL4WJlsdz7PjfyLs3EwstEUg+ClSrzXaFkHU60ie0tBgyqVpV2R8a5oZ5GN4QTHoHWy4cac9/XhMkt7gjpX4lqQk/yWOB/Lw7wUUjkY2HLVwzkeaYgqC5EA6bjhr0TiYKn1chVgGOeQluw5PTVAQBYQRnUg2w686EAnQms0t1ohr3ZmsZmJmA/HqVfCwEYJBC5/4AziPwJBLFy8ZNRPAcZxtWrkQg0AdOQvAMVmvAbR5O8iEspn/PtEb877REMj5++Leiowluu7ChKO680s7h5WVwVld+qsA6CWqLnm3o507YHff169ZBufGGlg+3OGlBP6IWBJRWrV+s/ofj9esqWgDhGx6wDpZx/nBRu8MIdyceDPEuGLizD/jhvmhJ8tLe54zSoNJ/vexHY+jD8GDgXQUbVqtQUxGq2bEv1T+tLJXk1SFD8fj6NrcFUGs40ZNOu+P+SEwoSfbQrKK39OiHVxXx4j+qEHtl2F3a3bGs7vgjazmh59enEOWxFL3xU5+bU1kYm0glHdjZGCmCrtBEr/uR9mi88ugF3jWrsqADVzKitqZ3ILr68f4XQ1QnyvZk/Ai4dyuC5twjXTwAqehtiFr1XsDzr//Z2zAM0/bBBawp6F6dyIVxwsqZjbTYBBggWZIDlkIzxzRmVALRDMXdC6AgmwYO1qfOjqO1barfmUCH/fSwcyziPH7IGuMsS6i
 S8BMV7bJ
 Mq4SfqSmmEjuScbG17Ol3vY4zHImpJCxCqvqidlQvI4b7qI/En6B5XzgLRrH0dKAmf/33P+NihkXozn/wf3wsRRoZivc1jrAvRb2LQwa/3WM728GSFO+m6io4kmY66kVyspGc13YSBrpAdIauHl11LNEMqPxTKnbCLEePJ/2tuLfMmVwT7tU6ul6JcS0xYc9MfudlrCvUp0X12JQYX+Nxpuh2mkGSL9gQ/XngXjTHxJN2U46Hf6LVOTarHG/9W5KhWUWulof2lDeWo6p557WvTs0NnxX5DCdC178rQlk/mir9B2e0bufXgTWHGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new DAMON sysfs file for setting and getting the newly introduced
per-DAMON-snapshot level DAMOS deactivation control parameter,
max_nr_snapshots.  The file has a name same to the parameter and placed
under the damos stat directory.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 4d25469f957f..bf1b637d4342 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -205,6 +205,7 @@ struct damon_sysfs_stats {
 	unsigned long sz_ops_filter_passed;
 	unsigned long qt_exceeds;
 	unsigned long nr_snapshots;
+	unsigned long max_nr_snapshots;
 };
 
 static struct damon_sysfs_stats *damon_sysfs_stats_alloc(void)
@@ -275,6 +276,28 @@ static ssize_t nr_snapshots_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%lu\n", stats->nr_snapshots);
 }
 
+static ssize_t max_nr_snapshots_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->max_nr_snapshots);
+}
+
+static ssize_t max_nr_snapshots_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+	unsigned long max_nr_snapshots, err = kstrtoul(buf, 0, &max_nr_snapshots);
+
+	if (err)
+		return err;
+	stats->max_nr_snapshots = max_nr_snapshots;
+	return count;
+}
+
 static void damon_sysfs_stats_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_stats, kobj));
@@ -301,6 +324,9 @@ static struct kobj_attribute damon_sysfs_stats_qt_exceeds_attr =
 static struct kobj_attribute damon_sysfs_stats_nr_snapshots_attr =
 		__ATTR_RO_MODE(nr_snapshots, 0400);
 
+static struct kobj_attribute damon_sysfs_stats_max_nr_snapshots_attr =
+		__ATTR_RW_MODE(max_nr_snapshots, 0600);
+
 static struct attribute *damon_sysfs_stats_attrs[] = {
 	&damon_sysfs_stats_nr_tried_attr.attr,
 	&damon_sysfs_stats_sz_tried_attr.attr,
@@ -309,6 +335,7 @@ static struct attribute *damon_sysfs_stats_attrs[] = {
 	&damon_sysfs_stats_sz_ops_filter_passed_attr.attr,
 	&damon_sysfs_stats_qt_exceeds_attr.attr,
 	&damon_sysfs_stats_nr_snapshots_attr.attr,
+	&damon_sysfs_stats_max_nr_snapshots_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_stats);
@@ -2731,6 +2758,7 @@ static struct damos *damon_sysfs_mk_scheme(
 		damon_destroy_scheme(scheme);
 		return NULL;
 	}
+	scheme->max_nr_snapshots = sysfs_scheme->stats->max_nr_snapshots;
 	return scheme;
 }
 
-- 
2.47.3

