Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9412B606C42D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C3GgOZyM
Received: by kanga.kvack.org (Postfix)
	id 3A4796B05BA; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C2D6B05BE; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC5B6B05BC; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D94DD6B05BB
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 641F1A07E8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
X-FDA: 85438492692.09.9D5CD24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C6E6940004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3GgOZyM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0fbCgdlmQEcNgh0aS+DhL0N4RVPNO26toOvZeF/1e4=;
	b=vkIWqcpTpVpCn1gF0EWjRrCOD4Po009zCFBnauggh81niZNxLKDG7cAik/zIunmVVcfo05
	o3x25FjkppDD/Vk1PvENY7+V3Zq32xpgwwSz62AzatAzcxt6fJL5+EmR2sFzWmuqg9UmDG
	76Df7p3XuiNuEt9CYhUmdEfB5yLb0+M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3GgOZyM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774544;
	b=PASUCIAVG7WoidmXxEf6qRqSEHM7TZCJfZlW/5tBTbjFIv8E+GYlbtCjRJdHBSuI6bp98u
	yX8imS+nmCz1WueZo4j6RBgr4cS6bKyjNaX5dZutP8UjBfxPCPjqU63VIPoF7X5+CP7UR6
	8iT62QZTIBEIIvUV7VFX5pNiMJwQ17g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B073611B2;
	Sun, 15 Nov 2026 20:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B4E1F000CC;
	Sun, 15 Nov 2026 20:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774544;
	bh=K0fbCgdlmQEcNgh0aS+DhL0N4RVPNO26toOvZeF/1e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C3GgOZyMP6N/oz6lt2qijgoWYHq37lYMDfbWcrg8BxhsUdjpLKjmXAMrxXBz6Xp6x
	 xGUxbmFLIaObe0nNMftjAuDBS4Ep4RpRwFk42FryRNh0gU6y8vz5iJ1eJ6nT+CulGk
	 aXkwsj8ewU4uEfEiUzfU0ksPfudeom5F5+QB2Z+6I1Zf6+i/PTLTY7rcFj1+DW0BXV
	 2Abt5l8UB9HMr6JYDhhiGpSL5enKDSSNe1lA7Sec+Hr29VYf8/RKdipLeXMNgB/gir
	 JqjFUc+3dmzc0V6yQ+/xpZQJ4p3VvTYmhkhemoBirSes1iXCCRd2OBQR16DBL6MtCB
	 pXZP1r+kLK72A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 05/27] mm/damon/sysfs: add reports/producers/ directory
Date: Sun, 15 Nov 2026 12:28:23 -0800
Message-ID: <20261115202849.99134-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C6E6940004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: d1t71ajkfxm8be1hwes4po77qmnfzkfi
X-HE-Tag: 1794774544-937567
X-HE-Meta: U2FsdGVkX1/qf8wZN2oNQ/iD2Vq3+IpyPnXCPs0DuPKmhkhbcPfWS8DjMeSv6wrC4NGbxjI8N5NEoiQJVK8N3N+mLN52QNeLzMqrKQqqngGGTxfaIJ1vzL6bx/LTQJL4pTkCeVnEbMdBm1lD4DSwF659nYbQm8gIKQqMmNGQ8gI5ZAhE2Ty2jfFNULSPtNvJEmIuVI5dmDMpzCU4jjBACH7PxMdc8e+rJAat/MRpK4rk/n6vytmXx4vwcKck5Mcj4OYRdBTyJHiDrcaokzPh7BYKFmiktVWDlfW4tHJEc3qrlMIGdA+Iei7dblxQ22FsRSoLNNHNhNXx9OuF6xvATuPcEphWZsPw4K3y4zQuWUlZzEYo2ua/WmqUWeIiZ03/GXm8JkBEvWN3gT6cV1BgioYuI6YA1kmCoMeYxw1lIEB01uQplUdD2Dbp4rAD2+FKS4g56/oRJ+FzYCFHy7lDBjBo0gpJ2o5o8YYU6PZo+WWrn7Npa+0y/mQhbzriTWN8y96edllDxopoSveVTaHLNsOTPmDFu0rw2bvFh6ZBoaeOnEPQ28pq2UJ5bXRIGMTqRvxWPwT1rjblLnIMU9KltK2YHxRYk6S3yfsmH3nQLr8HuKF1ndfr5ojZRA76VJzPVP2ymDt/8Ss/97G1U5/atCIP7qDvTj4zpeXqEXerJNZj/I6jsaQ16PleHfygZaTrMwxhIRtBK2Nn+SiziZJpawRr/2HJL4tcPn9HU1lkbZkhnXYaRA1N3+8QUPmHXusc6QKR8E6VWS8vJ3W1wvQ1T6tVOcgCKKClZqpM2NS3JQ2SqFpD0TkbKopP5VYTiqL7GEpv2/ZiobDkVVHhWwUEvYfb9+CebEN2citGOv3jSAFeJRCGQD7cA3ai157TVtF7tQs7s54TG+ESGzw2Uu8B8C4BmCqUKlNM/tYwZhKAYKsl8ik9KNf0kKN7IEfbQvrGzJeof4I/D4eLYdpfhan
 jEFgv+Tq
 2dajpH1TztFXvvmlnamQg3VERNTtVIwX49uFydoc/42zEM0v0j+kE2x3nO8EgtBRs49rI0DJ4aUG4hrpBlFeOmxFqL0adatYBOefy9jMUJz2DIna+WcSKYsDGGCRu0N7dCqNvAHcb4pvlN7yG4G0eBdic7jJWY/pvC7NY572NBLYuDz+DF5xpwpZ3ns9kYSg5itgdYQsRdCOjFtTi6F8a3C/oX1wvMSj19d3fKYzUq/dmMuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a new sysfs directory, producers/, under reports/ directory.  It is
a placeholder for files that will be used for controlling DAMON report
producers.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 76850a4b5b5a7..75701ed662222 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2979,10 +2979,38 @@ static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 	.default_groups = damon_sysfs_kdamonds_groups,
 };
 
+/* producers dir */
+
+struct damon_sysfs_producers {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_producers *damon_sysfs_producers_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_producers);
+}
+
+static void damon_sysfs_producers_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_producers, kobj));
+}
+
+static struct attribute *damon_sysfs_producers_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_producers);
+
+static const struct kobj_type damon_sysfs_producers_ktype = {
+	.release = damon_sysfs_producers_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_producers_groups,
+};
+
 /* reports dir */
 
 struct damon_sysfs_reports {
 	struct kobject kobj;
+	struct damon_sysfs_producers *producers;
 };
 
 static struct damon_sysfs_reports *damon_sysfs_reports_alloc(void)
@@ -2992,7 +3020,25 @@ static struct damon_sysfs_reports *damon_sysfs_reports_alloc(void)
 
 static int damon_sysfs_reports_add_dirs(struct damon_sysfs_reports *reports)
 {
-	return 0;
+	struct damon_sysfs_producers *producers;
+	int err;
+
+	producers = damon_sysfs_producers_alloc();
+	if (!producers)
+		return -ENOMEM;
+	reports->producers = producers;
+
+	err = kobject_init_and_add(&producers->kobj,
+			&damon_sysfs_producers_ktype, &reports->kobj,
+			"producers");
+	if (err)
+		goto put_producers_out;
+	return err;
+
+put_producers_out:
+	kobject_put(&producers->kobj);
+	reports->producers = NULL;
+	return err;
 }
 
 static void damon_sysfs_reports_release(struct kobject *kobj)
-- 
2.47.3

