Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD685606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P/uP0SPS
Received: by kanga.kvack.org (Postfix)
	id DE82D6B075D; Tue, 24 Nov 2026 10:36:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24E56B075C; Tue, 24 Nov 2026 10:36:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39086B075F; Tue, 24 Nov 2026 10:36:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99F786B075B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:50 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 836C7A8831
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:49 +0000 (UTC)
X-FDA: 85470415338.18.4C2EACA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D6DE1180009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/uP0SPS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534608;
	b=E2YA8P9cI5rrUadaXPm5LTeY/u1SIrijYsf4IWvhkSHL7c3LhbTFpYoHIbsDAJrlD8ay/4
	/aFxOJrIpHlCx6MrltyfLp0EPZJEX00ym5bnSi++Di7DTaSeK6vagYs+PMPQO3VTXZXoMz
	Qq9QuM3vOuMr9gJ0uUsT6o+D1XJKMlE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qirt3ZX0FbMTabmEssD6ikj1DbvFkhAbJB6fB/k07m4=;
	b=uEgvk0SlB2UbQRQ1bv/X7wTnjIOCIhuXXfMwUYVDXfjJRTNzSODwZTzHzeuerHIk5Vt+m0
	f0BVXHD9X29DuifJN3s00E8Du2sZwC35Y42JuFEFQYTpFlgHJR9UXSWMmy721SsO/Gcvz4
	1q5RE7MZfxxASQGL0U2RR3fVaK6GvGE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/uP0SPS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3196A4378D;
	Tue, 24 Nov 2026 15:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75131F000C0;
	Tue, 24 Nov 2026 15:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534607;
	bh=qirt3ZX0FbMTabmEssD6ikj1DbvFkhAbJB6fB/k07m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/uP0SPSZYWh7cqUQXUP7KpPGGqYnsyVXKKi2eQAuYb4D5GjN9ztBQY/GvbAoMVlT
	 M9pSuMOZdnpndkGM3fWw/PAdtsOHGG+4UXRhXJAWwcIchbrtNFWqCTXknC7HBj+s7g
	 z3FV0j5X13yaQRhqXR2mN+QP8EHjY1lJnvLQAFDsZUeEpnTS5yVH+XxrJsGp5xLl08
	 70gYEtlI/QS/b1AQyP+OSEJxQxx0AnB8ItZJqdelTKJU5RcbbIwLg8fkSwfYTJeSMI
	 QuEFf2mhk+b2RuQlS1FZD6/h3zQ489ema1FpjGZk5G9ydaP626dmVT597Ue7Gqocli
	 iHV2LnLkNq63g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 04/27] mm/damon/sysfs: add admin/reports/ directory
Date: Tue, 24 Nov 2026 07:36:10 -0800
Message-ID: <20261124153636.91854-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D6DE1180009
X-Stat-Signature: 6jwdn8ysz9p8hc96m89bqy4mrzspezmz
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795534607-304564
X-HE-Meta: U2FsdGVkX1/WxV9CUm2e5dm2h/pq4fI6iq5Ny9Rpnmu4aiEhtDctEUBXS3TZ1131SChYLQaC+wazprwvY1FcEuhvfsSIdUhAaJZh+82BwS+8WlxVI7KFj+TV5NKfY20zIQjKytbwm5beO3DrfyeENbrA/J+hVLyq4HdUIWfeJNIGHLENsP5wf34tCSoYXM/yvpgfxmQ2bT3WJkwS9Fao0RUjFgFKwvE3IHFf33SRe/xSBhcn8NPgxPSizecJbK2qrSINizJ/RdAkEgzcD0y2HvRB5+lg4yO3iEaJXQH9ZZ5cX3cmUf70uClGzXX8VXOZKHkIBUv/CZ2S9SO53vDrCd7hQHruzZmmI263ZEdbt5quUGvCWru8gcgL0QeW9A71MHYtu1P7VW39EVmfthpBeBkYfXL8BEwqOpL3tZNYQDzpjWL9hdZj56yg4ORBCY6rwFHI977T82ZqQxM+duJQ/YKgaflZt8M5eemWQrmByK5ani2j6Tsj4WndHgoOPVo6u9w4AuvhUoT5jm3K9Dx1zUZ61ro/mgnoF75e7R305pVCurXO7YNv3zGGVgJSFyuLEuqPOLycfHmW0d90pD25fAdBPEmIyAkbDiKvSXKl4uvyEBGKseOvtZUztyO3Ix0yheKmtxCkC8/UF+meOCK5NAVAwpxji5rfWsRSklidCIcTJatISZGstvOaZAIwWXJycwWO/6oVQxBD0CZO2nr1RIhIG4/wxDXcr6wr22F8iaWjHfkH4ahZwLdTZ1ymZIiZdVR9Lx6XyAQb84dhheWYPnUdyNgUQrLKO+yPjdyHn6i4RmXWx5gUDmXi7TSMixtjDgBiBe3ooZjVgAWKUGH1SOKVfrKMyIG+BDV4BK3NwnV5eZGYl+lFkFHJW5QNOUhaAheJJpZHGKjKoLdb22Hipo1lmtmr4rATkLhUHP0HskJD+8IYuKtQOnBAQWAXfUmA+2AbQS/7QpxN46VjqxD
 YTi4cnfw
 TFA0fAbmsHmcmdd2jFqIWYxnTrEt/9wZKd9dOZX2S+yI0E5etWWJXMo2x0TGKuvJCEWyiOd6x4mCFf0wvpbH7qJW+TTrY9PQP022F0YSi6ZZJ8EgZybV8moas+a7WbvxY2eHdSj1RUvEsxPRs7+6rwdQauCAao6szuBNv3iNnStRX5h+PAMCZE7+HJ3mh58gHhgxaP7aDGBl7M2jodNnjB+X5XV4M0Uvx7x2YyCts/5ZvBvfClSDyPAcfcVK0w93apq8fY1lDOfVTrl22SW/1V+GOSn6DWcU2jBYRW5t+2Y2Pb5aUhGTE5R7yiDcG5xlv/j5RRPMSiTwOZ4jKd/6L1VDmNm8s2a6clQtMBED0DCtXzKr5bPShlSfnV2TlqvWhbHOpl2ybmrS0zfZUQDUNmTLhMYcJnpxWtKonEfW29vBEgQ4SQeN3YvWl65ERWfLoJaIJzXIUkrDyBePvgXDCi4gWQUIzR/Z6bJ+czUC9IkfyHMJ1m1lFN3fZzxjRd3563f0t2zXtLLKKJPEenXFUOkBv3YwbprnC16SrxKFyl/wxF4mej5MR+496qQ==
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

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
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

