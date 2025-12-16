Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48281D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7146B00A5; Tue, 16 Dec 2025 03:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A25B6B00A7; Tue, 16 Dec 2025 03:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062886B00A8; Tue, 16 Dec 2025 03:01:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0C546B00A5
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:01:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A77711A0560
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:58 +0000 (UTC)
X-FDA: 84224590716.05.09C26D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 14C27A000E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mRkUz/Iu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872117; a=rsa-sha256;
	cv=none;
	b=31ruybToPS64rDFea7cNz+evNL0H9ncZpS1hKlQMe0Aq4PVY/47JvbIgOLefmdOMpNSxhD
	0w7IazUoR+C1IFVUr8WppHS2K3gNTKXjhhGw8XVVqILp1lNomzlyQ0ewRCzACmmBaac4ia
	UP2NvxiWAHV2rVPnTUsGmERquGADb8I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mRkUz/Iu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYsAhv/I+jCQQ+h6X0z4WaQd53AlOs6Psy7NBte/xlM=;
	b=w0sDj6WaKuw928DG88OIdhiAWu2OMnjXj0USpd2paDHAFNCUgjBdornDJPpW9eq0Ybd1Dv
	zkWtG6sY8wtr06WRqxyIgpwFTd2RFDF9jBm/4WhRpk9eH5xiYoA2+yeBmgZfBh0pIsbr7Q
	hYE2Gd0eZxkXQno3djebfJ6lz0HkWpY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C61060188;
	Tue, 16 Dec 2025 08:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5C8C16AAE;
	Tue, 16 Dec 2025 08:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872116;
	bh=YYITYdIQPy/1vLOJqdtXYhiVVrg/s7bBHX4J5y9ZA3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRkUz/Iu/Pl0hqM6pdMSVBXMftjfKuqsByDORaWV2AND1xZ6h/4+982YgmU6QcQuH
	 g8jWIwjrT5Qkj4wjpk2dbujwRmExzpzk8QN8m4za8sWTXuPO2LawEe+71nJN9ihOAT
	 g8jWDOsAPshhen7ToCNMs7VnJ2HR+ZQ4GPiuYnuYYwnF8P2NCaKDQ7pg+LYmVmFWsc
	 Ch0p24kb89fzx8wpSlmPSt2NJ5wmQv/FUWpi4l2wlIVhS3w4rspfTcN8eLD5l9EQpR
	 Q8m79U5A3IM2M4ghD6qg7pg1Zf7Lv+KPTKrahpM2Oa9hvmacmPTWHslwU0QCSzD0H7
	 IkRNx9I1T0sag==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/12] mm/damon/sysfs-schemes: implement max_nr_snapshots file
Date: Tue, 16 Dec 2025 00:01:21 -0800
Message-ID: <20251216080128.42991-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216080128.42991-1-sj@kernel.org>
References: <20251216080128.42991-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 14C27A000E
X-Stat-Signature: gs1sdau3tzm6eugkbd6epy81o3otg1bk
X-Rspam-User: 
X-HE-Tag: 1765872116-64261
X-HE-Meta: U2FsdGVkX1+M7U8hus2+XyMezcqKNznDkuG/rbH0nxS+EJfzNo6jXx8nZ8SVlGDdLfpxNYpVggBlR3MJwiMCL5Np75tcMkpTTmV8bzLcV2EMHGjrVZUP+x7GMb7ir1ZZcEzKngeAkc43/bRjdXQVnjlhFQ/jfG20r0Zd00CiZSHKTtGGrKOxt1nOM0XAgUXnIesAtPet52h6yaZ6mbfEHQIYIjb44zHCAHp7h2SMWpo/CJJYXiPlgYBjI5l0aicDTrSRMoGcLbUQNgnJ972NNBq7tQjzEEAs3f6YgKTX2qSM2ny7erUNUZfcMIpK3uWtnQHZ0LyKS87Ud0dgjQDCRtIIaphIEnTTimvyw0MSk+jOMe5JnAEXh9caIhs9pLSJIMGpDmt4CjHNNx6ZuKrRG3hYmg+Ejm/8p+6DFFFzq3L90dN1T8F+5/wvQh0eiyX8oZJUAtTCYGDKnznSRLeC3WWWBMjlTqp/dkkc3+JGd/oslGkDuHTC9HJX3IuvRLVYIPtvaZ02LM21WuT3XnQYxkpJMxvlidgXNedE0MFieQHaqceuuD9j5KkPIhNWKadKPFKD1r48HKyfh47Qy/L8jNUVkI1H1YO/5kvUZRMUbL4RIs0kegJ8ZUajTqBguCVTEiXVsfHx26H2DapTJSDv+09CuKDC8Hunw2LkJ5rmCgiM40TekipAVaASSgs/Q85ICfP01gIAbfhh1lhvL1l63GUp74JtxkDXFdUCKe1ncenq4AU+mdEHlKTycWkA1evakzB60RiWOh6tvGJsSUNKyfhnvDRj3s5mTHYM5LQ0D/xR2jTZ62unDUvff+d3LlR9oc7j9nVrAd/OH8wSTZzyfF1v7rxjysuuHwfYkRTvD6yX9yAF+TM44YQH1PZtovp330+cSD8AtEJs7y190FkOWm1sehAkyRysxE0o/cLNJv5WdcgZTrRYMpGCLsuaQimClvxgZ6/nB/835uCASHH
 HTe2xqy2
 aBa84AGjMtUScXXCZ58eTAAuVMNCLWYUdK0MRa7CNRN4Do35J1nJglm3blDjAo611nE5tn7JlQMJNFT1RyvYVYhli3RIARez6e56dcv8RYejmjpCOWK29Oc2TcYSuFWp8jebVddKt807Zk43CWW+3z9OgM82rGZ/dJHQgPW3XdqzWULXbE44jP284kJ4hO+TzxRr2xwFBPwwE7H3XFXMiQfhKWWwWWdtIgFfmWauD5eiQ4llRs+o4YaBq9vKEvzv71oRQRJrhmcMDc+ozivJUREI/RbrYBQfRyiMzUjGtdCVQgboUQNDdf5UxOQ==
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
index a1f555e1125a..e198234f0763 100644
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
@@ -2730,6 +2757,7 @@ static struct damos *damon_sysfs_mk_scheme(
 		damon_destroy_scheme(scheme);
 		return NULL;
 	}
+	scheme->max_nr_snapshots = sysfs_scheme->stats->max_nr_snapshots;
 	return scheme;
 }
 
-- 
2.47.3

