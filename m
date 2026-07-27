Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30602C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D3F6B00A0; Mon, 27 Jul 2026 10:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D0E6B00A9; Mon, 27 Jul 2026 10:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C3F6B00B6; Mon, 27 Jul 2026 10:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 928E46B00A0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19CF0C06DE
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:38 +0000 (UTC)
X-FDA: 85034812716.11.D72DACD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 667C9C000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IBV8y34e;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=13a3CodocCqwLWlDgXNYIFBHG2zYKkhYJH1FGDvZacQ=;
	b=4OB3RfQmpLexZnGVIMzJBenyMsczr7u5+uRsj0Imu9o5/2eMbCyB0kkATDinpct81AWHWj
	bYm8DG7YjS0km1YoGqe/5ySJoIMW11+vMV7y8+dTnqL0LdQ0VUyjeL8RsdDl0Uuzz6jWHk
	VVVxTtzrKnUst1IkKUuX/aWdWyUF/4Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IBV8y34e;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163116;
	b=eVvqXmZx98zZL+R5UMMEYKQq/pK6AH8Z48v1vFvzZJ4y1e+b3IAR53MQ62pBVXadK2lZtN
	CvU9IW0Sbmfdg2JbWhymfYQm1um0BVWrRWdXSIzA7/QmGvvjiVUUHEu3WGv+Q91BigID7w
	rfHblAPiOpul2gPqHCKebrNNrOg5Y7g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D288F43048;
	Mon, 27 Jul 2026 14:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8902F1F00A3E;
	Mon, 27 Jul 2026 14:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163115;
	bh=13a3CodocCqwLWlDgXNYIFBHG2zYKkhYJH1FGDvZacQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IBV8y34e1SDFTcYNSUGv2W/gy5aR2qxgPVmN0IiUlAfAidFrq+qr5oASeAHKZdfwb
	 IaI8C2oqNJPuO5DBlCwYJUPwt4ejg5nNuisqu4eDyO+RSE3HdRGBicG614qV4m+bII
	 5IIbNFGozteg5zkljCJPPZoJnTLZk2HqhNtd1mzIF8oJXKHmHr4/myz5PaP2IUXT48
	 5ilfIDRj7/wuoqlCBaz3hIyqUPC0VzJ9VKsVVkC4sxqcQb5+jxGFJri15reNTRm31K
	 ISa9r0aUT+1HngwrdYk5T8uCcrBnOcuWk83Gwp5JgLTA5b+Rbeu8KZzkPiaObMUP1z
	 n+lHpN5btcWhQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 09/17] mm/damon/sysfs: implement preps directory
Date: Mon, 27 Jul 2026 07:38:18 -0700
Message-ID: <20260727143829.86236-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 667C9C000C
X-Rspamd-Server: rspam01
X-Stat-Signature: fktddp4gm7hecducp3hjmdgdusbt9sem
X-HE-Tag: 1785163116-9056
X-HE-Meta: U2FsdGVkX18vWedpiGAlhe145x+XoSRIgyFXriDeOWfSuBDWdAvcscSKLCIsemYxkD7N0rzIUWo4urE5NxB0S53ktOwTZZ+Kp16G8nmaJrYpDyY9PoB/9d/7tD3RCU8Pvw2cXo+AzhdHV3kbmmsC2NJDznuGXcUcU4JrX3+RV2RVDmruqa1WOW48k0RujPSnEkSh1FqFwnYTad9RNhWbZJIGgWzGDDTNQQArCFrkV1Q5KrnKIdTifkqrprj3qozSN9NZkWhIzC0cYjugpJB4/uLou6aUvS93xebXPUaih91Vd4LmjDHURPXKTSTtjmSLXpmgtPeyGDl6RBOxutkhHFTmBhv6JuwSfoPEzyBwm1THYAwAg5K4CHC6PDL7PNjxnPnirUYyBtkx1zngTPgGF4sAGeRdEQFWQVJhfAws0YS11tjxWwmJb82T0ACPg5QxZBL4RadxHsOJU7R1qH3OEWaqk5MAVpAuFjL0bcxzr/LnMq+m5+ONXrgm4O09wvup2iJt/5syj3vnkOEq3mJDn2DieWW4WOKWHCYt9MfwEMscaoJbGGOooN4LUyFV2bRHjabTTySxGTcnZpsdQfyQdpqtQrNUSNPa2LQnwWJRNHiVt0t8UAXjbNx/pZBkl3+Yhu4WAZ/6EmA4dbeSp3Dx+A/ZeNeVNF9EKJwSXw3hCVWLRNYFae618CksLzqEUbtvj0E/HZWd35Nng0ew02nENwK/deRjWPQdGH1OsZ7sYAgaiM7zSSM2GuDw7CooN9HpYMzTOpM1uxi99bNa8tJ3uh+vDV70dGxAtv5lvxMkOe44ay7qzswQXBp33CBqed19LG788G8r8P9VzkpwJuE9NI+9tedDkM8tqgj9+GHvTshBOgbpZjpnT/W39sqPOIvyRTeXgpmooPLCLKTcNPNlNnOBXk8PWuijVsIeyRnnOJs8/Eshv01QDaT+TsLr4n69x6XyqrCVs5bXjCk0IZX
 mbf192qP
 zTAt+Z9cWZB7sc7BJAzpELHJlt2to2C6IVVW7rwxwfItRNGAakXwlXIQX5WzRqvEjtDSyNAo4TuJcyBMGIA4Rv3aJC+eISXqBoC6VFPABN3T0KaD2aAfDiMdQGtUlYJMQq1DDVXN2Psk+9mQgDLlxZxxQYo5ojCRi590uJ8lon+ykgIOdQR6fx/83eGZGam9XK68hYUruL+0TsEZjBuKrnnexVl1ni0j/3KYdQSiHnLNSc9k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a sysfs directory named 'preps' under the probe directory.  It
will be evolved to be used for specifying probe preps.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 65 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 59 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 376c6ecbd4bf3..e33070d2cbcc6 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -750,6 +750,35 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * preps directory
+ */
+
+struct damon_sysfs_preps {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_preps);
+}
+
+static void damon_sysfs_preps_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_preps, kobj));
+}
+
+static struct attribute *damon_sysfs_preps_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_preps);
+
+static const struct kobj_type damon_sysfs_preps_ktype = {
+	.release = damon_sysfs_preps_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_preps_groups,
+};
+
 /*
  * filter directory
  */
@@ -1070,6 +1099,7 @@ static const struct kobj_type damon_sysfs_filters_ktype = {
 struct damon_sysfs_probe {
 	struct kobject kobj;
 	unsigned int weight;
+	struct damon_sysfs_preps *preps;
 	struct damon_sysfs_filters *filters;
 };
 
@@ -1080,25 +1110,48 @@ static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
 
 static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 {
+	struct damon_sysfs_preps *preps;
 	struct damon_sysfs_filters *filters;
 	int err;
 
-	filters = damon_sysfs_filters_alloc();
-	if (!filters)
+	preps = damon_sysfs_preps_alloc();
+	if (!preps)
 		return -ENOMEM;
+	probe->preps = preps;
+
+	err = kobject_init_and_add(&preps->kobj, &damon_sysfs_preps_ktype,
+			&probe->kobj, "preps");
+	if (err)
+		goto put_preps_out;
+
+	filters = damon_sysfs_filters_alloc();
+	if (!filters) {
+		err = -ENOMEM;
+		goto del_preps_out;
+	}
 	probe->filters = filters;
 
 	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
 			&probe->kobj, "filters");
-	if (err) {
-		kobject_put(&filters->kobj);
-		probe->filters = NULL;
-	}
+	if (err)
+		goto put_filters_out;
+	return err;
+
+put_filters_out:
+	kobject_put(&filters->kobj);
+	probe->filters = NULL;
+del_preps_out:
+	kobject_del(&preps->kobj);
+put_preps_out:
+	kobject_put(&preps->kobj);
+	probe->preps = NULL;
 	return err;
 }
 
 static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
+	if (probe->preps)
+		kobject_put(&probe->preps->kobj);
 	if (probe->filters) {
 		damon_sysfs_filters_rm_dirs(probe->filters);
 		kobject_put(&probe->filters->kobj);
-- 
2.47.3

