Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8375AD3B7E1
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385AB6B0011; Mon,  8 Dec 2025 01:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30ED56B0012; Mon,  8 Dec 2025 01:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02AA66B0022; Mon,  8 Dec 2025 01:30:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E550C6B0011
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92E378B0B9
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:03 +0000 (UTC)
X-FDA: 84195328686.16.FA07ED0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D2A912000C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IuqerH5f;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9vecSTLpff8QcgIS4MxcklQVaYko6IuWg36jjr2NDbM=;
	b=fUXExLkIwby/to0HlELsfFU4qCRgzxw1AU735q3W51GlFmVlROWEmWXL0xUaTKXZM/SD99
	XJx/DZiahG6KparVCjZR1Ct0ejvicMlu15bhj1P64U4Qf2SgHMCvqwxDO5FlPzYrZSUxhL
	T2wBV/M2exaaRI9wvMM3WKAyCvlV/iE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IuqerH5f;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175402; a=rsa-sha256;
	cv=none;
	b=VuoN83fWQCaLx5lJHZ0sMCgnvsNA4GRCml5fPGspDGFTqLP1LIMjkvEsPn7E44XaQFWM5w
	8HVBU0knuCL9DFTp/1Opm9wiiAuWe8aXQJNVB9ud/AW2NVUs3f/4AuMzY6a8QQV1zGSfLH
	yIaNDRuqMNwT7Tb5/0ojG5ukKg9f/VM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A88744392;
	Mon,  8 Dec 2025 06:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF121C116B1;
	Mon,  8 Dec 2025 06:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175400;
	bh=PIidHNr/VkcFOE2gAHJhxadKF2Da7aKAwZ3oDyJGFRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuqerH5fST4Q0MUSx48O3pCSTGmeM3CXG4UcARZdiFmwDCgxJavXxf9W6niH2Szya
	 a8KPStk1sjhHmlrO0kQVZDKgYRHZunmYcAQWbHNDyJbQfm8/u19camQsfCvZ3afmI2
	 VrqZrkoV3ZACOyz6cJPSEsg5la75dOzdubY1oPlXdVew1BCuKgAdMScP21JtOPSr0N
	 OxSlhXvLB/ArTSA2EzEKEsYmYQRCCWcgDb0CK4mGC75BdfG2LCR4irNdou/5NyIP1m
	 jSj6M2gUsqa/dgoV7MF6rACA1e/d6T7wbVuf9GYDowCI9c56sNUNWf5U9yoZiW5/nV
	 YNhgaPPwSUMwg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 08/37] mm/damon/sysfs: implement monitoring_attrs/sample/ dir
Date: Sun,  7 Dec 2025 22:29:12 -0800
Message-ID: <20251208062943.68824-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6amjadkk36kqqsxmcswaz9yee35xj9xz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2A912000C
X-HE-Tag: 1765175401-125423
X-HE-Meta: U2FsdGVkX1/zBLvVtY7z4GlafZCNQQCIo3UReZK3fcIYLnQ7T+gyFqTd+XaNnX8SvKDNHfHdst8pLJGYHhjbv+yNOUko/B9VxYqsm0atwsd/gfWRKiqFPGup/ps6u+qODtG22Ict1WjsMvbswiBNerYX7J7/02jN1w87LQn0WEBj5kMrsVtXXVlJYPy1Jfkkt/O2Ue1jKkm4Q8VLsvItRJ7YjHZqS3qfKS0bkL7U3dRiJAVCtgfv3UGIYKxMj3jIIWVoVdxt64crF1L1e1ZDlxI/d8eidckS57twUfOjZYLR2LHg7II+QhTRdDGIIg/fFQw6dhGdM1lBCZjfDZ0+55zZksqic20obEbU/W/gIS3RsKTk1x65ie91VZ+PUzRzrlBJDMkmLTAC//gezlfL2XMqEeKmK55WkofU8TmHJ1FpCFAgqVJ9V5tJSY1OUWZzRL7BSPDoz2sHU3HNxqUNp8Ru/3EwKNjMQPGUY0HBzdYDesp7QXVRxxWfXjwXjg+cxjtp9UUiBuHrre3V5hBSLsZNjgdezv871qrdDJVr28ApyHTQUQgxBcEwLZDUn/FDHSh/kSHzvKRRW7ILFTebyfBP/kufYMjthYbD2lH/ozDkRdJXqdwb3gWV9AD4znAGDAZDtfwjuJ8X8pWep/1c9Vgp3yTrTCTT7hXcGyL64mspJAHCiF57+yWLJS/VA4r1ItmB/a50VWJxxRdjqijgxR549mdYiwHq2oXRBdrV45dr/K3GK48VQngXpRsIk4xjLk0SUnIWgCdul2nOQQWTzIwsWLKdOippzIMxxNUy9K9eA12QjR7VESfEnTndCrhN2H+GB0pM0ZoIPjVsJXqtWL5Unmy2/87GRkr1C+7BUYnLE6ZcrDKPciDTSrBHQXvh8PFlu+4xH4FaDxoF1W4JaYr919UwfpAzQRPg4c+yiPbiJ1hBE9K0EbOdkHeORU5W8dK1FoRq13OZnsLZf6G
 +2UBPD55
 Gpdk53VRyW1oJK0VCWhWN5Wx82RX/AVYRttvesuGtxGYC/RZPIJuTTKfYqTmzv0gDHlXw6o53tlNbXbOzZPFN3Q/jcG2IAtFg4XTYdcbWNR1oyafjRnixKleUXdpHzW3+Y7SRGgBCHWNF+nG9ZhWyZSWTz9T2Qwnfhx72Cw/8h4pr0hdR683KXj4EvwTnnkTMOOTB1MYKyQFx/uzent7ScUeOGBRXgsUAtxDPBEuSiMzR6HovkVgKxoKgTf6ont6S9Ma+9AMZhM6t2/URxTdaePfrgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sysfs directory for letting DAMON ABI users control what access
sampling primitives to use, among page table Accessed bit and page fault
events.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e2bd2d7becdd..851e8c0dc989 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -749,6 +749,41 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * sample directory
+ */
+
+struct damon_sysfs_sample {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_sample *damon_sysfs_sample_alloc(void)
+{
+	struct damon_sysfs_sample *sample = kmalloc(
+			sizeof(*sample), GFP_KERNEL);
+
+	if (!sample)
+		return NULL;
+	sample->kobj = (struct kobject){};
+	return sample;
+}
+
+static void damon_sysfs_sample_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_sample, kobj));
+}
+
+static struct attribute *damon_sysfs_sample_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_sample);
+
+static const struct kobj_type damon_sysfs_sample_ktype = {
+	.release = damon_sysfs_sample_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_sample_groups,
+};
+
 /*
  * monitoring_attrs directory
  */
@@ -757,6 +792,7 @@ struct damon_sysfs_attrs {
 	struct kobject kobj;
 	struct damon_sysfs_intervals *intervals;
 	struct damon_sysfs_ul_range *nr_regions_range;
+	struct damon_sysfs_sample *sample;
 };
 
 static struct damon_sysfs_attrs *damon_sysfs_attrs_alloc(void)
@@ -773,6 +809,7 @@ static int damon_sysfs_attrs_add_dirs(struct damon_sysfs_attrs *attrs)
 {
 	struct damon_sysfs_intervals *intervals;
 	struct damon_sysfs_ul_range *nr_regions_range;
+	struct damon_sysfs_sample *sample;
 	int err;
 
 	intervals = damon_sysfs_intervals_alloc(5000, 100000, 60000000);
@@ -801,8 +838,23 @@ static int damon_sysfs_attrs_add_dirs(struct damon_sysfs_attrs *attrs)
 	if (err)
 		goto put_nr_regions_intervals_out;
 	attrs->nr_regions_range = nr_regions_range;
+
+	sample = damon_sysfs_sample_alloc();
+	if (!sample) {
+		err = -ENOMEM;
+		goto put_nr_regions_intervals_out;
+	}
+	err = kobject_init_and_add(&sample->kobj,
+			&damon_sysfs_sample_ktype, &attrs->kobj,
+			"sample");
+	if (err)
+		goto put_sample_out;
+	attrs->sample = sample;
 	return 0;
 
+put_sample_out:
+	kobject_put(&sample->kobj);
+	attrs->sample = NULL;
 put_nr_regions_intervals_out:
 	kobject_put(&nr_regions_range->kobj);
 	attrs->nr_regions_range = NULL;
@@ -817,6 +869,7 @@ static void damon_sysfs_attrs_rm_dirs(struct damon_sysfs_attrs *attrs)
 	kobject_put(&attrs->nr_regions_range->kobj);
 	damon_sysfs_intervals_rm_dirs(attrs->intervals);
 	kobject_put(&attrs->intervals->kobj);
+	kobject_put(&attrs->sample->kobj);
 }
 
 static void damon_sysfs_attrs_release(struct kobject *kobj)
-- 
2.47.3

