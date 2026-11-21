Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96A1606A330
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M2Z1lxAE
Received: by kanga.kvack.org (Postfix)
	id C5B106B05B4; Sat, 21 Nov 2026 16:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96A46B05B5; Sat, 21 Nov 2026 16:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E87F6B05B6; Sat, 21 Nov 2026 16:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 552B36B05B4
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B54BF405A8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:24 +0000 (UTC)
X-FDA: 85460344368.27.A6187C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 24C8E140005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M2Z1lxAE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294823;
	b=Gdsojn/XdZkbitEqJZEFFgzxPaGcBUx3yqqdFiC1uiDLYkqXqTN5DKsjwxRrp4gBy0NbuS
	jBBbQGy5K3dXQAA72OltCTWwwNaj7vpY+7hARgA9B76U9i7nTB8VXIGUFnkN3Cd0zWlaeU
	AjLgwzo4D49pFPz9cJgM/lJieYBk9ag=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5c6monTkHFptnJUFGVWxm0WfYIjXGBI118GDWY/b424=;
	b=00D3ryFsy7lVoxWJhzlDWLEINdYb7YoWFXqe6xCyszV+5YkrvbH5mbYnp1Ie1vCY/VbBEm
	oCHNhh7uv9Wvh/YqqY++5HVGM4K8bLiTPczG2qxqrFU6fv1C+3Y/7LdHoPbL9co01YYdex
	FMQDyVO8z4oSAIRP+i2n8AElPdAOzb8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M2Z1lxAE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBF0C61CE5;
	Sat, 21 Nov 2026 21:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712761F000D3;
	Sat, 21 Nov 2026 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294822;
	bh=5c6monTkHFptnJUFGVWxm0WfYIjXGBI118GDWY/b424=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2Z1lxAEzydCKqSs3ZpORGFow7SsTZ3C1Qoq52359vyMJ5unfjscNLzdGdnYpMOz/
	 c58HUK6WUNkwGM+ELO+luxPVA3Cx09KoUY5f5gwcstuscEW/lduJvekVzyiin8VdNv
	 S5pL8oLVnuB1A/rW3cv5imBbDs6OmAVeBJWKpfowsAnytdsuDKK/ca8efgUvxBe+Yk
	 i9BrImICBg3BvpbZsv++9hh/zQ1HdpeBAnxWhItbwW6AMFx/U9fbTIJiJZlY5kNcjM
	 XBlGFL79MiURXpvXBwctqAet9B+SpYoCON7sjShyFGSvdCGjVZPT1t0K/YE6IRU27I
	 54CQYdgxBPrnQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 04/27] mm/damon/sysfs: add admin/reports/ directory
Date: Sat, 21 Nov 2026 12:59:48 -0800
Message-ID: <20261121210013.130397-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 24C8E140005
X-Stat-Signature: ougwbo6t1ei4gajkrhnmnq4jd74xifhc
X-HE-Tag: 1795294823-802391
X-HE-Meta: U2FsdGVkX19nv3cpAJMws7ZbfnWROMrvTTkubKVX2HWed/W9aWRd2+gKiXJkPSt3o56ArH0U1Ml+pgsaeA2YI7jrrtPpSiz9pM0UhpQrN3OyFJQrOYiOxJXTWSrXEKISGA48Jr2UiI11+JABS5/CfDJIx5XDZQu8z/kA3xGT32syvT55jP7RjdiJtaZJxDnMWaPB1n5UGcwBK2HwVhckV/MGUjNBEMxS+Nv50725zQWexYFi057NJCnI48DhznDDzYN7AM3QdJF7OKZCubqbfUeD+PFsewTclEwysDuEvmrpCZ7AD5qUO1o2VedL+n0e5/7ODkRZAbgwkGI0jSpT4gK12I/dwdlTEvQECOWt6lcaukZcapfj+WFtUDfleROGN/UUu5E4lPa+3Q3vcJA4BFycZcnXixZ0m38NXGLUfuHfF602vGKWo3NG5lzRBHDhuuC2jk3aGGjU3Z6xlZ4um2jTUNl3nov2e/UB1qHP5l3y3VjbecVFr+UpE/67DFfsBv9WZmWM6OcQ3eEH70JsZQJFU2aUHrSq2yjQludt+wQtVZQKo3Glou6u5b0ysUxLyG4LROpOwqqSfuCK2Iw6xXqIeEc7iZvq8nqQz7w4jG5EvecD1FTPo8rMg4h34k5McxUtU5FQAeOGsYNctLv8sumscUuFOb0zF+locyPB8TTEFG9oZxKrkxexC9LIJWVitejrkNjIJ/q1Ci/8C2TADABgwNwz8I+vA21UvnZQKBYhUSMnMIeD2L+AqDRrf2Yf63bA6BnvVFDOKPISSvC/yQvXXyckd5pxy7oNlMXLTkUp95++vinmgd8vP6xTpuO4Kr9605mcFDMMpPE+F0Vz1v1CmQgomr5vkpiTEGPMGDDlBHPOMbY0orIULqovkiKJt/HTY5cdI4PVc3riB9zXbKvAFEujx2sCB82e8sc9zCHrdsy9ytYuWSea/fVrcBAsBJhyluoPpl0op+Wp9vX
 lViSbUn3
 u8VBmy0bCWzZ7JNqZ79mZcYxiefwDFtehGavIEozC2HhAlnycalivF3OpRP77NOZsYoe8ylzlG7nbDHwLwN81YxykIGV0szU1Z7RCJYHDwr5r4XD0goweW7bUTMjRnPgLtK6C0AU89TiS3OhQShk402BYXcNKelWO66eCVhuGK324hrqSKRUATQsc2qtwuEK/HhzsON3prM9PJ9uvB8W2wrf9Abtzk/kCOIF/4K5lL3Y4L0Mw4xA9vkLmfxoJBVScHwQZS2lF9h26o5NIBr4JvgAlIajtYYppkhr0CisLx57BN6x68gl4rqRdk2J8J0WkwsQ4Y7miryseuVKB7UrCDaEH0IEHNg6hZTeCqEQNC2mrylfJkCy9/WezQki97j9NNxs8gdFTbBaphiDs1yURcYxTKIWypwSImugMCqdZBgBwiqLIQZf6+0ydMC+IaKyUoxvWZBQ6nVxiuVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a new sysfs directory, reports/, as a place holder for sysfs files
that will be used for controlling the data attribute report system.  Put
the directory under the admin/ directory, next to kdamonds/ directory.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 63 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 779c98205a94b..76850a4b5b5a7 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2979,6 +2979,38 @@ static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 	.default_groups = damon_sysfs_kdamonds_groups,
 };
 
+/* reports dir */
+
+struct damon_sysfs_reports {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_reports *damon_sysfs_reports_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_reports);
+}
+
+static int damon_sysfs_reports_add_dirs(struct damon_sysfs_reports *reports)
+{
+	return 0;
+}
+
+static void damon_sysfs_reports_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_reports, kobj));
+}
+
+static struct attribute *damon_sysfs_reports_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_reports);
+
+static const struct kobj_type damon_sysfs_reports_ktype = {
+	.release = damon_sysfs_reports_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_reports_groups,
+};
+
 /*
  * damon user interface directory
  */
@@ -2986,6 +3018,7 @@ static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 struct damon_sysfs_ui_dir {
 	struct kobject kobj;
 	struct damon_sysfs_kdamonds *kdamonds;
+	struct damon_sysfs_reports *reports;
 };
 
 static struct damon_sysfs_ui_dir *damon_sysfs_ui_dir_alloc(void)
@@ -2996,6 +3029,7 @@ static struct damon_sysfs_ui_dir *damon_sysfs_ui_dir_alloc(void)
 static int damon_sysfs_ui_dir_add_dirs(struct damon_sysfs_ui_dir *ui_dir)
 {
 	struct damon_sysfs_kdamonds *kdamonds;
+	struct damon_sysfs_reports *reports;
 	int err;
 
 	kdamonds = damon_sysfs_kdamonds_alloc();
@@ -3005,11 +3039,32 @@ static int damon_sysfs_ui_dir_add_dirs(struct damon_sysfs_ui_dir *ui_dir)
 	err = kobject_init_and_add(&kdamonds->kobj,
 			&damon_sysfs_kdamonds_ktype, &ui_dir->kobj,
 			"kdamonds");
-	if (err) {
-		kobject_put(&kdamonds->kobj);
-		return err;
-	}
+	if (err)
+		goto put_kdamonds_out;
 	ui_dir->kdamonds = kdamonds;
+
+	reports = damon_sysfs_reports_alloc();
+	if (!reports) {
+		err = -ENOMEM;
+		goto put_kdamonds_out;
+	}
+	ui_dir->reports = reports;
+
+	err = kobject_init_and_add(&reports->kobj, &damon_sysfs_reports_ktype,
+			&ui_dir->kobj, "reports");
+	if (err)
+		goto put_reports_out;
+	err = damon_sysfs_reports_add_dirs(reports);
+	if (err)
+		goto put_reports_out;
+	return err;
+
+put_reports_out:
+	kobject_put(&reports->kobj);
+	ui_dir->reports = NULL;
+put_kdamonds_out:
+	kobject_put(&kdamonds->kobj);
+	ui_dir->kdamonds = NULL;
 	return err;
 }
 
-- 
2.47.3

