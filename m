Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CBD9C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8669E6B00B7; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED9A6B00B8; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F29A6B00B9; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 309276B00B7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A857912074A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:38 +0000 (UTC)
X-FDA: 85034812716.19.4CC237B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 167EE4000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kc5OoafC;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tov/Fab7A1jZyZTBVWD58q3Qyx5bqxY7CJkvmEqGIwo=;
	b=GlH7yobCL5acpLctT2SWjztElFKWzQCwxSWrTb+gHM3aYjtmucEqD7Wxt/ECC7EX5ERKMG
	Xe4VDgRxCWkJcIDRwd4dRzN04pF73w2zGzikukZWZ6A2kgE9EksGwjIPCct2dejrSLotls
	wFp+PZdnPbN+mbr1IRI+Vz/chNexb3c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kc5OoafC;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163117;
	b=YVSqZCzICkl1OTEw3V5hCVAhtP1QtXWWkq6wXDt2N/aETcAuwU3+A33arGi4L6yMYu+JZ8
	KS9Xa8ZcWE1JvAgui/rdq50CL2NACycaBpfuf7cATP+/4n2t8hjv3XPdeaA7PMDgMaCwgH
	OlKnE3khBqdF6acgceDkqbmTKDG9DsU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A39FA60A64;
	Mon, 27 Jul 2026 14:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363151F000E9;
	Mon, 27 Jul 2026 14:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163116;
	bh=Tov/Fab7A1jZyZTBVWD58q3Qyx5bqxY7CJkvmEqGIwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kc5OoafC0HBnbwusF3F2tLjAjZIAQ617eir2LikWBQf7pkQFXdyQe8crPMT6XJfOZ
	 o7G47I6wrq0f4CqGxQkD9WmeqqbNPp2U5cLafYXEh6Q3HzcSHvMDKUM7cZ+2VvKjpv
	 9qtz3vEHbYtny70kMBiqG5zG9VdcjLe6/meVpnRcOY67hzF6a+Aq7TlRQXmKKGdPF3
	 B5kjWUwZyDQsjX3fHVmb/0FxuydLSKHZpvCfQztzNY1RTgm2XP9q19HBtcmd5RbkB/
	 a5enDuHVq2MVuC8xx3qECAj7G2WxV/YRsbl/Lb/zs6gw14ELGrFzudFWqci4Xh6xJY
	 +vBFaVaCzlOzQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 11/17] mm/damon/sysfs: create directories for nr_preps writes
Date: Mon, 27 Jul 2026 07:38:20 -0700
Message-ID: <20260727143829.86236-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 167EE4000D
X-Rspam-User: 
X-Stat-Signature: mnsb61gb5rio464n67b714a6ywai93wi
X-Rspamd-Server: rspam04
X-HE-Tag: 1785163116-280531
X-HE-Meta: U2FsdGVkX19L2/7RAyuYTRL05wKVBzirCP3Tq2YYapcsuLpLQoEsWM0W6Y79aGMd9Zofv2dGGskxm0YLlP/LjDRLVGlyT4Lw2z6MRlx1yYZ3LnIdF5OdgPsSItTGFGD29MxFNbRtHdx80iRiLMEL/VXhI5jdPHRmi8faG0IV22C+cGnnbvmHmJ37UbsZxD2ueRtSAXOiwDYZUW4WL02sIoQVr/TXYaIRdkBjdstfpxHkqXwoGowaZg2Rhqm0qTp3/cRMptcOzl5jhpStjGYRGD83SDvnlnHOxRl1fxj4yTS75I52H5Id+Hla40AIfnfUdzUbvxgD7fQGFAlrKxqPmhFZ5/V59AzKZyc6mLX7gyV3B8p+zr0ObAmntcvVNXsuOx3+1Z2vK1Glg4EVZSUkR+M1bD2T3GZulbGK7LWEd2nJTtUj72+dSLT33pptPYHoczfDbwuTta0OEPTytamC1hhrGV5czjGoCLrlnCmsf1G2nasFrk/khbsnQFFd5EUcZMg9Ewuq3f67YkBr7I9IGwkl0Vo2DdW3GEenK2YYS6DA7j0ZLJC0OOza0zdA9+j/RQpPM99nGKq/t09biTAVIWLVP9jEjrNqVurTCh3Usb6Qnhc5U2JpasZlEqw42EMvnT8x08O80NN37uZj0uuv9CuIx9rXekW6FHqjlk8AtiGf2ksoXZVPBZTMumjAJaBKuMPZD3+7bmIm2o9cn55cQaTYn+Z+YUXYkBnFp6dpkeqENPNVaSAow07PR5A3OxNKAVOTzfPNQ4b4LSX3jSvlq+P6wRd/puDCcqQD4YT+lgNlD7eDb3q77SSXYNrAIlO/8Sdx+kbkkkVxKgUiSoHpLKEkKvoP3FLnMx28ctgFVll3negSW7z61Ag3a+QlhWZtKVO00E9gst1kPFPv0ARxMnefjAmzSJuUqJfEDb4FbVEYrNLFWijCnygTd8e2fqgcLrJ9cJmSI0pf/ouxUaw
 rVbokJtE
 o8csJDZ1ozxbLoLeIv6gQuNn/U7QALNy0oRL25TCAJr0SH4w4V7fg/SU4Q0II+nOjMaCVXocv6gHvSvy2Zltssyac4N0NFc9+CC4ESt2WrFgd4uDA9ruOguuC3oeqYea+8oaVOzslXnmd5l6kncpsgsLAjF0tHta4Tn3AHL3NLZDwVoC3TX86mpV/9a5v0RetL6KdMPQrZhwmNAhJLfmjYLqib5dvlghojZswpjAeWQ98q+sxSH+4XGnWUv1zOgvDKr84xlgZ8BmSFoFPfo0r97Ju8KS9+4Z3vJjSOmV47WrHF4nUUDbfDnufGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement nr_preps write action to actually create subdirectories of the
number.  Each of the directory will be evolved to represent each probe
preparation action.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6d3ed80fb2eb1..2ec33280a7a83 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -750,12 +750,50 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * prep directory
+ */
+
+struct damon_sysfs_prep {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
+{
+	struct damon_sysfs_prep *prep;
+
+	prep = kzalloc_obj(struct damon_sysfs_prep);
+	if (!prep)
+		return prep;
+	return prep;
+}
+
+static void damon_sysfs_prep_release(struct kobject *kobj)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+
+	kfree(prep);
+}
+
+static struct attribute *damon_sysfs_prep_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_prep);
+
+static const struct kobj_type damon_sysfs_prep_ktype = {
+	.release = damon_sysfs_prep_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_prep_groups,
+};
+
 /*
  * preps directory
  */
 
 struct damon_sysfs_preps {
 	struct kobject kobj;
+	struct damon_sysfs_prep **preps_arr;
 	int nr;
 };
 
@@ -766,13 +804,53 @@ static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
 
 static void damon_sysfs_preps_rm_dirs(struct damon_sysfs_preps *preps)
 {
+	struct damon_sysfs_prep **preps_arr = preps->preps_arr;
+	int i;
+
+	for (i = 0; i < preps->nr; i++) {
+		kobject_del(&preps_arr[i]->kobj);
+		kobject_put(&preps_arr[i]->kobj);
+	}
 	preps->nr = 0;
+	kfree(preps_arr);
+	preps->preps_arr = NULL;
 }
 
 static int damon_sysfs_preps_add_dirs(struct damon_sysfs_preps *preps,
 		int nr_preps)
 {
-	preps->nr = nr_preps;
+	struct damon_sysfs_prep **preps_arr, *prep;
+	int err, i;
+
+	damon_sysfs_preps_rm_dirs(preps);
+	if (!nr_preps)
+		return 0;
+
+	preps_arr = kmalloc_objs(*preps_arr, nr_preps,
+				   GFP_KERNEL | __GFP_NOWARN);
+	if (!preps_arr)
+		return -ENOMEM;
+	preps->preps_arr = preps_arr;
+
+	for (i = 0; i < nr_preps; i++) {
+		prep = damon_sysfs_prep_alloc();
+		if (!prep) {
+			damon_sysfs_preps_rm_dirs(preps);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&prep->kobj,
+				&damon_sysfs_prep_ktype, &preps->kobj, "%d",
+				i);
+		if (err) {
+			kobject_put(&prep->kobj);
+			damon_sysfs_preps_rm_dirs(preps);
+			return err;
+		}
+
+		preps_arr[i] = prep;
+		preps->nr++;
+	}
 	return 0;
 }
 
-- 
2.47.3

