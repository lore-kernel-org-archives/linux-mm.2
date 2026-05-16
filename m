Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 362FACD4F48
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52AF6B00A1; Sat, 16 May 2026 14:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8BD6B00A3; Sat, 16 May 2026 14:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1326B00A6; Sat, 16 May 2026 14:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A0006B00A1
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A36C1203C2
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:32 +0000 (UTC)
X-FDA: 84774141144.19.C3664F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7430AC0004
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dgk4pAO0;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E8G666n4mgr93QupHeQiNq8oqEH0a+bRie8FVSuwjD8=;
	b=n4/LkquMo/ruc99Nu27xAoLHqoIGanmiMIKoBIkW1QvPW/j70MbLI8bCSnyisohuI4/J1y
	17nfnQeFMRgaAUpMW1b4GOpwWAaB2fINm0W8AlX+W87LKJMIesYw4OQLyHKHQz7qyIQmh6
	Vq15oBJPicY+KognHVD2X5dwOWZtGgo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956650; a=rsa-sha256;
	cv=none;
	b=pILReHu+Rn9bmnaSo6tzaQTeg2tqkzEz8HKitCJw3QQP8ea0IJKhJnREjRqkNfcWn1RcoG
	XAWU+l43kwkSvnrNcDlY9/YJ3o3kVvOlQ0a8ugW8605ih0vIkwJWCtwRS8x0KYTJSHK4Gw
	nQSoSUu4Ap31TT0qncL51OJicFqk6uo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dgk4pAO0;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A2C0445EA;
	Sat, 16 May 2026 18:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24A1C2BCC9;
	Sat, 16 May 2026 18:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956650;
	bh=Q1zGK+j0zRxUsiCpVVG1d65SmG54MWL9Bnun2Pc3YCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgk4pAO0Tio/zVHiiJjeEDVPmohekNsu4jCaZFUkcKxwAiGeUCS1LpoSmZ4K20a6A
	 vpmNETg0uEdXEsXiYlnkL+rrO6MuwEEZEG4jxUJgynoP1fuPD4ECVSuLHD47nKUg/i
	 4r7I8zlWfuN+xrAOVIFRsQcAVIabQ+5JNmdR8lNdtbj9nmj9dyy9o4hnPMa1T0Z7wP
	 p9BAHwg8XMp2Q+P76ecbC8o6P4ozTkETV3F8vOF8PeWPCJaqCROYFU2Hkz+sRP8jQ+
	 sFEE8JOlEp7M2bVfgGzRI2KV9wHL/Q4mVsmINqp9bD+8ztFv+SnoLd9vpHnXUmhdPb
	 jhkec0cKpP9yw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 16/28] mm/damon/sysfs-schemes: implement probe dir
Date: Sat, 16 May 2026 11:36:57 -0700
Message-ID: <20260516183712.81393-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7430AC0004
X-Rspam-User: 
X-Stat-Signature: jo1qzczgaihnsd1edh63mxfkhs564zjm
X-HE-Tag: 1778956650-999095
X-HE-Meta: U2FsdGVkX19Gcl2TIy+KQD+G53jpoyPTZJNKv1x60W5IF0dLoc9V5JX+U5GFZykI1nm22gMBMmMrb9add9V0DNqs4urM0MJZfhIfxUOqSWOdyTzZpe/X/9WRC3E9ni+IOiThSkhxoRVhYjX7yAz52HfyiLbQ40Ywc9C/S3/LgJhVWJfAgDPgqdASDvbkvZAV18trVzaSjzMLsCi3oDGTzqg321Lpj6r50Lgztr+5UqjMYylfDuJk6zWkiBNqFLwDhdMQox6WHVyS7r0y0GHSgqcPO53KNhlXPI7MY8uvYupZjyv7wsTtHM2yaLyLJXc9c8Lb3g+S0tTCSZCl3S1KE1zSGKgT5Fq+D04usirWdVPtqDDX3CbTtwoLVqznNgrHTtwVIucSQCxC05I2aFEskQ6h7gKtKVWsBFbLMm98ZzQ0uK9lFJHrFA+t8Rs0dPqpJuVLgqCuLIEeQTsbSIpl/CTeR4j1ZuEmyGKnv/MqyXTsym9N2+3LkFLa5ifrPpoU3G8yi115JUi3eyIypod94MSfZaOt8uTCakPxJh3CCkr4TfKCydMwFl+xFwdB56Gbp9Etdgj1DG1GqBx5stUk/jHueCHNUI081u3Z0CRBjeZ+6+RxMeoedGA6/B+5twqRaD4/d7Cx4sr3Zl44BdcudDDqyWLpumwO+yd4qTp/mo0qPPx16eFfJ1oPIJsRbHk5dVqG5s79P+khEwhdN0SgNBklVhKymn+2npR9nVdTiLSD2+ApbHzrsFEkaGDgeiPeLXT3Yhq0XdpwVR5cu8LyqXD8IX3D4EArsP3yqTSV8ndIA3/dvkqvMhSPEG9EuZaX1t03PfrZTI2uC2c8O3ZIIG3DKpPOnth1DKcMjks+qYZa6JRGhY5Q0O3cNoJ2zFtKtrBbJ6MSMze6sEnQY5DRiLOMnIf1TcPsMEqRyprZ1zVLt8zrvPsQRJUBvQ6P52R9gI8sibQNGBa+KfdjeZU
 QEbrmxpX
 fCgtfRxse9gfmOvGS7DhyIajf809CFI//MKp6rb0356oX7NJ2Uwiaa8xnGnQP2kKsLjkr2p51ikwHwfWo3mWQsJiSS1+W6SacjlAzJ8HFuIIiqNCvIwEXoEOwKL1f5VCVcQQWr2XPt9clElXpaGpy4m0pDgWIsw/PFVJUgmpxv+7ciEYYPO/kWOFLfMWCmpjvs4v1lSfV4dz12CvPGNaw9ucBKbykx5NnoPHO9wpgOFHM/C0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement sysfs directory for showing per-probe hits count of each
region.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 101 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 95 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 8998df5bdc5c8..c8123c62bbd48 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -10,12 +10,40 @@
 
 #include "sysfs-common.h"
 
+/*
+ * probe directory
+ */
+
+struct damos_sysfs_probe {
+	struct kobject kobj;
+};
+
+static struct damos_sysfs_probe *damos_sysfs_probe_alloc(void)
+{
+	return kzalloc_obj(struct damos_sysfs_probe);
+}
+
+static void damos_sysfs_probe_release(struct kobject *kobj)
+{
+	struct damos_sysfs_probe *probe = container_of(kobj,
+			struct damos_sysfs_probe, kobj);
+
+	kfree(probe);
+}
+
+static const struct kobj_type damos_sysfs_probe_ktype = {
+	.release = damos_sysfs_probe_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+};
+
 /*
  * probes directory
  */
 
 struct damos_sysfs_probes {
 	struct kobject kobj;
+	struct damos_sysfs_probe **probes_arr;
+	int nr;
 };
 
 static struct damos_sysfs_probes *damos_sysfs_probes_alloc(void)
@@ -23,6 +51,60 @@ static struct damos_sysfs_probes *damos_sysfs_probes_alloc(void)
 	return kzalloc_obj(struct damos_sysfs_probes);
 }
 
+static void damos_sysfs_probes_rm_dirs(struct damos_sysfs_probes *probes)
+{
+	struct damos_sysfs_probe **probes_arr = probes->probes_arr;
+	int i;
+
+	for (i = 0; i < probes->nr; i++)
+		kobject_put(&probes_arr[i]->kobj);
+	probes->nr = 0;
+	kfree(probes_arr);
+	probes->probes_arr = NULL;
+}
+
+static int damos_sysfs_probes_add_dirs(struct damos_sysfs_probes *probes,
+		struct damon_ctx *ctx)
+{
+	struct damon_probe *probe;
+	struct damos_sysfs_probe **probes_arr;
+	int i = 0;
+
+	damon_for_each_probe(probe, ctx)
+		i++;
+
+	if (!i)
+		return 0;
+
+	probes_arr = kmalloc_objs(*probes_arr, i);
+	if (!probes_arr)
+		return -ENOMEM;
+	probes->probes_arr = probes_arr;
+
+	i = 0;
+	damon_for_each_probe(probe, ctx) {
+		struct damos_sysfs_probe *sys_probe;
+		int err;
+
+		sys_probe = damos_sysfs_probe_alloc();
+		if (!sys_probe) {
+			damos_sysfs_probes_rm_dirs(probes);
+			return -ENOMEM;
+		}
+		err = kobject_init_and_add(&sys_probe->kobj,
+				&damos_sysfs_probe_ktype, &probes->kobj, "%d",
+				i);
+		if (err) {
+			kobject_put(&sys_probe->kobj);
+			damos_sysfs_probes_rm_dirs(probes);
+			return err;
+		}
+		probes_arr[i++] = sys_probe;
+		probes->nr++;
+	}
+	return 0;
+}
+
 static void damos_sysfs_probes_release(struct kobject *kobj)
 {
 	struct damos_sysfs_probes *probes = container_of(kobj,
@@ -67,7 +149,8 @@ static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
 }
 
 static int damos_sysfs_region_add_dirs(
-		struct damon_sysfs_scheme_region *region)
+		struct damon_sysfs_scheme_region *region,
+		struct damon_ctx *ctx)
 {
 	struct damos_sysfs_probes *probes = damos_sysfs_probes_alloc();
 	int err;
@@ -76,18 +159,24 @@ static int damos_sysfs_region_add_dirs(
 		return -ENOMEM;
 	err = kobject_init_and_add(&probes->kobj, &damos_sysfs_probes_ktype,
 			&region->kobj, "probes");
-	if (err) {
-		kobject_put(&probes->kobj);
-		return err;
-	}
+	if (err)
+		goto fail;
+	err = damos_sysfs_probes_add_dirs(probes, ctx);
+	if (err)
+		goto fail;
 
 	region->probes = probes;
 	return 0;
+
+fail:
+	kobject_put(&probes->kobj);
+	return err;
 }
 
 static void damos_sysfs_region_rm_dirs(
 		struct damon_sysfs_scheme_region *region)
 {
+	damos_sysfs_probes_rm_dirs(region->probes);
 	kobject_put(&region->probes->kobj);
 }
 
@@ -2986,7 +3075,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 				&sysfs_regions->kobj, "%d",
 				sysfs_regions->nr_regions++))
 		goto out;
-	if (damos_sysfs_region_add_dirs(region))
+	if (damos_sysfs_region_add_dirs(region, ctx))
 		goto out;
 
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
-- 
2.47.3

