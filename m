Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30EEFC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432836B0188; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3D26B018D; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AABE6B019E; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0B4A6B0188
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BACAA416E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:20 +0000 (UTC)
X-FDA: 85165264800.23.688B606
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id D26262000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n2/FGnLg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4M/9i3il9+uoX/0hvXXuMXtTWxZNwDv4ttKnUbtHPw=;
	b=SyDOg4xv65nXUonAv9KL6ZQfLkBXu5n80ExxQbHUJrQvpgbmYESQWaK2nGRL57rvZGWwuk
	xE5tMTJe1iw2QNjwwwQS03S+2TBCP6OxnFkZdgaRNL1W2XCOCHKDBN/GB9ufgNMhkPBCAd
	GrxTUs0gzrpH7KP9CHxmLtQUdsaxHck=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n2/FGnLg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269118;
	b=bf1amj5r6+ScUQD7bWC8AixzJtb0RnPxEFSPG7VKTxbmOUNiEdUX71BxhYPzg54kzs+n+M
	5pz3mIkr2ob9FzkUUMnKa7sLUXrgADz5jalwZ3EgABSE1/PwQ4z66zhTQ5alRqPNX3sbMP
	VhsuM54ByTIAOH74vLLZObMaAeFoKcE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F4F241A1F;
	Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58A61F00ACF;
	Tue,  1 Sep 2026 13:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269118;
	bh=x4M/9i3il9+uoX/0hvXXuMXtTWxZNwDv4ttKnUbtHPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2/FGnLgDgXTvCYFjErpYKblPGIZZk4Ju9X7ymZOtgi264KCJLbw4odBjGDwwMOf5
	 0sGBvLV7uzFzTsVyj3aWTWT46keqxGfdpioiETdT//Iw48QHsCyITNoCLZd4Id9Dbv
	 usywHVX69XXYJXpcRrPVoRgX1dat7OIhbORjsuwPJz/D6qi4yrEVJ6zqoA7jNolN9T
	 YCcQcIiilwLSN5xXzc/dfKbrfNtH5E2EBExh5XJzXNYgkSTYyo3Z7CovAxYB3ynWzr
	 aOKZhvAx0g0xOrOYdrCgPrknX3DXw0Qh8XN46JqcJ7aO6qDCYqiLlRbS3pGvNsysLr
	 cRiI6E3yjzTOQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 09/17] mm/damon/sysfs: implement preps directory
Date: Tue,  1 Sep 2026 06:24:56 -0700
Message-ID: <20260901132506.99243-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D26262000A
X-Stat-Signature: 63orn71yz11kibuozz3i7kpyjc51y1wb
X-Rspam-User: 
X-HE-Tag: 1788269118-318448
X-HE-Meta: U2FsdGVkX19ImiX/VREIyB4k5kzfAK+AyTisUl245zredCZBcFXy+98D4mL42IBt9omGvY3UT+vh4M+ququ9qw1HQWtz26+TQL85VLAc/2gCdV5N3mDE1FXpJuhiUeKcmhGp0gEDtz0k5obLpG9urQI70u9AFRG3wj+eyJkAI4OUNj5hsR1v3LdRb99cOpcG5/wimIlcB9HhUCYX+cfr7C/WC/sOMg6mcfSXETp1tgNgsnRJF4x0z42sz6JaIbY7tU2hIQBX12ciP8sdv9og3Hw71ux1InByfRw6jS8kvzeJYwkUQTl7oRjsIHmSaxwjEJdiHeHf2UnrKLHOM7/e/B3vcVtubUowa8rlbgQJzREJseO/Bv4Qm8Qr+Ef3t175gKSXEyoj15mNBXxCCrhukxgETtzKtRjlFnW3jwMGRc8xTRfyEB3umICoDAXUjvVQRJlqYsrsgMXP5JslTJs83vr+QN9SKi1vtyk05swdoqG5BCNBw5xh0MgITka8VOKmAAVXXyQ9IhO8xr0OaB0c0VzAJEUoq+kurABOcAAmsqcpkIJ0YonLktG62JHGTd1PbGizxaT3Yqw6vxndnCV39EQh7/K8Pauu3jBEO8v/OoV539fi8w0/js4xR3Bc5YtKbr09sU8XAJxhGvb36R8WPT/8r7UjRO3+22eONSfJ10G7OQBmVAbJZpmRQyIOuGgHEdN1y3mMhlet3vvVt/9koL7rJV/9KSePXcqKlKNa8lmORJ1TkGTAcUftZCHHqkBFG8IHm2K/0h/6meleWHE4facSuvGxnhCp2xlUAib8Erh3aTYm//gCMfnxv27GHEj/Q7PxJJ57CcBfwEw1W7vCKWxtOv5ppCfsOaSLlDkkR1KnKRkHX99H+mety8VrVOzMw6via5158BNS2Kj4iqJNw/7QZ2vTyq995OStdF6DfXGzE8O0rJ8fnOZXc8YLdvjzWl+L6p4bIOQJqlC5ZVz
 SNwhhjuI
 DtVUb7mli1lERG1txMwZ3A54AUP64fVoQzoSKRx9f3vhW6x93V7g3tQXeFSqlftd8D9fepcg1AJO8M210T7cv3fIoKLSsNf3jYEgd7kC+vtv1PDyrmAbSfGHMrqQ5/pJT+phz1XN0oT8FHz7/aVZA0SsfahnTDz7IWaprm5LZNao8364Du2MRazbqq3qHAksFtRKplFYW1JNlpYsuuanhmi7HKyK3YrlFzdd8PRDlSZ/0LzY=
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
index 3593bf9c7b7aa..09641257d3a89 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -749,6 +749,35 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
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
@@ -1069,6 +1098,7 @@ static const struct kobj_type damon_sysfs_filters_ktype = {
 struct damon_sysfs_probe {
 	struct kobject kobj;
 	unsigned int weight;
+	struct damon_sysfs_preps *preps;
 	struct damon_sysfs_filters *filters;
 };
 
@@ -1079,25 +1109,48 @@ static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
 
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

