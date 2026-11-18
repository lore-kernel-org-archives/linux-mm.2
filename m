Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8269C606A333
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RIt4nj4E
Received: by kanga.kvack.org (Postfix)
	id 8A4346B05BC; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DA306B05C1; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D746B05BD; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2620D6B05BE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64E39A064D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:36 +0000 (UTC)
X-FDA: 85446641112.25.C990D0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id BAFC7A0002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RIt4nj4E;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968554;
	b=iiWfZyHQ7vAbPg4Mk9MX9CDcOcRFW2SiBGNqpB7AnWIwHnbLjCapKUDFKXZwLMuhyXePZx
	XhgFMcX4Fy46She/nCq24eD9J688pIwdby7g+qBwfIXXKfu7afZnuujCo2NuiDhZzIP7Gf
	CLSouBaro69eHL/2lEmejwlK1y4UbBg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RIt4nj4E;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5c6monTkHFptnJUFGVWxm0WfYIjXGBI118GDWY/b424=;
	b=RDsIXI4Z5d7dMqMlu1QUlU5MEX60gPdnV6G/txDG3wmSuNZcueVqVRkAZb+v9j+AV1XYrA
	LTAadmtyd2sywulK2d/U2fxSuPx9roFCgPXUuYR+DbypHLFDu2YjyhEbeXNXCOXzwqu8hr
	Pt711GdM2Igtvn53eb0CA+ko4ghTnDs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22FA045B75;
	Wed, 18 Nov 2026 02:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9831F000CB;
	Wed, 18 Nov 2026 02:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968554;
	bh=5c6monTkHFptnJUFGVWxm0WfYIjXGBI118GDWY/b424=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIt4nj4E8yhNZYSrWL7LUfPh0eTnD5O0HrQDKf9hNsDD1Exo7ima8se/J3MpMxKBm
	 3S3Txs6RYRWZ+2XD3QChjua8POhdgfHnHdHFaqi2+tLCxkeheiTq9LH2zM5onggHSs
	 rDc69DOH5/HhAnmjYYozmN9buXJPYGeRzXu00ohYahiFM0xM/QYqJvoiRdQKx3cBsP
	 UbzkItuNhYVWxDG/LxZGzqHX8q7hrRw8hhFpIatfpG95oaFXB3FAnWbhLGqXbVZ/Jj
	 /MhGM270sygx5zKjbvhGGI7WgXh4CuEOz2rfZgA0r1cHP/MhcH0t7MdeeHLlXOUS8h
	 DfvTyr9UvTQMg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 04/27] mm/damon/sysfs: add admin/reports/ directory
Date: Tue, 17 Nov 2026 18:21:59 -0800
Message-ID: <20261118022225.100659-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BAFC7A0002
X-Stat-Signature: d9k97hryqt7mq4zcfsytz6d6t9dzkrbo
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794968554-372130
X-HE-Meta: U2FsdGVkX1+QuHHbPBBprrg2x6hNDyq+FFyLOzM2nVOcDq8bEuw+oSo0A5/ZEP9s7HyTpAJMbcjm6bKY1f9NoymIVKNN/MTuD7x4cWA1xjZUTkmEZjXPEl7w7uURzffb6uA0frEe/adFzGxvipM5ayZjzgMC003Q90KJDu+pW8RkmJE4cdxHU5DfZscC9dWXNUn7wKC6eMVnbHsaaKJzburax6DCusm4z8VUlL1rBq9B/ZS4GhOt3MSPSJq/GXIXHIY9Y865DsmzV6Wlaf+BUqoCZWHuXZ+7RAlrLpMGTjQyCGBPTIcvD81W4DVKdiV9s9zPKpH9T1u82MNQUc80qwKaC6Bv8E7suSpzqhy5/O8RZScRj9jS8keCv0hvrXF/etGQTeRzQ4ZWWiORRM214UIv3fEJiadxuMuBdGwjA/FFg1u1sTezwPmIOlKsOAV3a6u4DbygnZFk4izTlrcfRoSvc/a4Dmm5dAOd7w0HbYOWY92wDBUd2m28QUtG6ITFK5Xrptk7ClYjQFRXvcMu04G0T1FOMdRB6lOnLuQv4Og/yJx3FNGNRwoicLRS63HWLrMn3/8uF8wd/gIDF3QhY5A1RU4YDiQ3v9ySAbPNBym2PcAubwJmmMjonM4Hjt4pDYIcHEjuNldSEju5Jxflb1blEoZIM77Px1ohiqF5J0ke6+8V0P83XH4/YaO8RjYMRV5mj4kHXMf8fQZGt9LvJk7zpQw607pc4ZAJWOfBeojx++Y6J+ZMeIIoBgyn14d7NnPl77G/I0bElSifbHvY0O89S4npSRt1SEo+DeLJUB08R/h3gry7decrhOKb54rli+6JhZwQJjXCzirZcu6kIS5KyqiVMwzmkKAzVjcuUgH2Kwv0/ost03Ii85fOLwgloVICn9ahoQL4vgiwLGso7v3lgzDvdyJcKwUrIZtYGRCEntCm4iJRYWKYQUMbHLS7pv7sFN8Iew2/YTWgUBn
 Dg+KwZNp
 ubwIw10QiwZ895NOKXOYH1NWs4Lg5jGHCWOwP89daV64Wf5D9ulmDiJTfUlnIqY9aeB9filI57U5sx2K9FjTtq3L7Icy6Jvu00f933npvZdE1jK6n/aGPwxE3EEFzP/24VzDpLutZ9fZY3sshLDVrklT4ZnHcNxyhTB+bjznd1DGj7AWXGQDxDuumEY6r+6iV5Ukp2n9F4jcSf2sU6XBoybvgaONJIMY2p4Q18JiccaSpYnA=
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

