Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F0CDF31E26
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA966B008C; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12DF76B0092; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3976B0093; Thu,  9 Apr 2026 10:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD0006B008C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:22:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A298BAA3E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:01 +0000 (UTC)
X-FDA: 84639231642.10.C6DA75F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EA54F140004
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:21:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lUuANX1y;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eXvdSW5zPhZVvhbBUe21YR4ZXv7EJNoiQn7cpzUUXrk=;
	b=4+hUWSDJv2BajbFLtNyN3ufVlOQwqV2Hu58GoTcc1pGcKoKuJk60NxfBckBfvP3FyP8Bx3
	Vhrz049yhMyjeW3awZAPDkKk46VUqOa9z5pUNFQGpJY+JOe2Wdsu4vqf873N5spmoMvUAX
	IChKFlb0zzFiWUMwF5jX665YqKPWj5w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lUuANX1y;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744520; a=rsa-sha256;
	cv=none;
	b=fBo4/78Vn4DDKtd8eKHt25JoBeJCkNH0QOlheSHRmp9OWz9/rzxfwicwS+REzizi8zEpvN
	UYYJ/3MkObB5Ilw1wnJ1kUfAAXshnLHEc+vfQrBXStGCaQ5DPPBtRm2v4bUV3GGJf0nS1b
	uD8vVZHxdm7/M4PgS5UCQ7Wjwf8jws4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B97B44552;
	Thu,  9 Apr 2026 14:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CC6C4CEF7;
	Thu,  9 Apr 2026 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744518;
	bh=F/M9rB5L2tN6LoRT9CXC/JolkzvZc5e3+oNuxF0asr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUuANX1yzKuXdAUEGvZuwhRVRAnJcP7DD+EwoCbI5QOBLaH6vgyQjY0tPfLeo6A1z
	 mLWmc0yVMIMVdV6KGItV0gxOFqSJ9DoG1aqlsDBIoDqU5fJpMrXH4mdVE24nAaNv1p
	 wxQlQX9BAKg6YNCV7QVfNmnfSc5TgpSmd5JHfsQ4WRtKCbmxY5Nv08sfQ5Axw5sSzz
	 vByLAu6gMWFocxSt6kNabl/b75O0Ay+3tK7+vqc0j842EIMl1gxGS3SbM3DT07HGo1
	 TlX/fCaSiiz9YwBPiZ1WQVjhmzT5SzLwQ+83ERfuyvcyR7eGVpniCEhhz3RHk5lHPZ
	 Mtrnby5cNxhtg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 04/11] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
Date: Thu,  9 Apr 2026 07:21:39 -0700
Message-ID: <20260409142148.60652-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409142148.60652-1-sj@kernel.org>
References: <20260409142148.60652-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EA54F140004
X-Stat-Signature: widh54mxaaqwdodjk76ykymkekpdcwwn
X-Rspamd-Server: rspam06
X-HE-Tag: 1775744519-738509
X-HE-Meta: U2FsdGVkX19Mgskjo/pjjHUSDpafV9tRteAfr5V+yrLoWbyAc//zk34WXCry2TEKeD/CNpyD5/NrVUN38m3BpoHWA+UoKJeRQnbSunE41kMlIoUckojxvZC5o+H+0rA/3o9h6+ITvIDkMWYLi18lbBO5HakJdu7gbRbZA2hEaiDK5EAKydSsrRatsRKifqsDL8jI2BmhbSYX6fte4gKdXI4RfUKILM2+UWjAC0RTGX7gkyc3THktj3eYHlF6yhmAbeelfh0JrCnx7jqPkvz1zNQ0eJPmdQFVlkAqCi9ISpOPjJlTDMKVtc/ssguXMT2qWnPqNlgWDCl7Vl8G++Q74hhJIGrzFXctUAYdq5nEBW2ApdjBI5NTu20gUikMgqX3Yd20nsevs4fCCs/P7363/ag14lK4HmNzTxi2H0WG01DSAb7k1uU+mQS9H6BfiZr4QwlgWkIrbLHfNfstFJgP+gCwVJOfFB6hYAIyQtdEPUnGxTUkH0rYug7ruNIgktmp7F0gtJz6zmY3HZZQm6SWfR8Cyk9sPogENzV72orlspgiCq5eZxLKmkRpMbH2tpLx2xK9+zufOqYwl+MHxVhgM5CpMEfsszTvXZTCIglU/oOfutEdyHDJNNsrys+l5CgvNZ14jJ41QXcY50vhIOTn2PGG+ESyP2AkBOGBJue/9YpsjE2vtBhkDebdt1sYGRPAs8qSL29nfzEvCuWBg2lrnj/65DX+Xyn82KZrEeoRRBW6VIzqGA05IYYjGEiazNqeNpmniYi03xTUwbOqjlrNnQRHK3w6Fj/CVTW0Ur3Lm0/UeSMSRhyz+T40QAiybEAtKTb2yvTWHWAryuD1XaXvGTX59G++SuSHP9H3Qwu9J9gYlezFdej1tyAXTGULnOQ41smbO+BEpSV7eGs/X3tre1kLB7Gqsfa8sv+6eaUxpfcABdaVTpsGkxPTHQX288s3Al/v2rn1cORjRyYDw0X
 RpqOBwgW
 QZAnsgFZ5jQYKKIAbdrNhU1MLddZY6KlckDLCFBnawgZ4HCpKgWROVGTRANk9tjOADj4QOd9MkWDc8CTMOI+yyxsUkhWHtTN/Mi5EYv4QvrjNs3a1lZJZ/PIvzny+poO3JT8YcZFyBYSUwgKUbNv63LyoU6UQhtjJvnGLgAlGLd9k2XHVT4vebD7PB2kNUk7+tRb4EiICDeVgIhkbgeRG0gUmYeXkB7N8BbVmqIyDkzADCARyNODgwq2OIke+TftE5yb+sqRjzHrec8kVaWJQNTpSYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the user-space ABI for the DAMOS action failed region
quota-charge ratio setup.  For this, add two new sysfs files under the
DAMON sysfs interface for DAMOS quotas.  Names of the files are
fail_charge_num and fail_charge_denom, and work for reading and setting
the numerator and denominator of the failed regions charge ratio.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 54 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 5186966dafb35..d5bfba79f105f 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1489,6 +1489,8 @@ struct damon_sysfs_quotas {
 	unsigned long reset_interval_ms;
 	unsigned long effective_sz;	/* Effective size quota in bytes */
 	enum damos_quota_goal_tuner goal_tuner;
+	unsigned int fail_charge_num;
+	unsigned int fail_charge_denom;
 };
 
 static struct damon_sysfs_quotas *damon_sysfs_quotas_alloc(void)
@@ -1663,6 +1665,48 @@ static ssize_t goal_tuner_store(struct kobject *kobj,
 	return -EINVAL;
 }
 
+static ssize_t fail_charge_num_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+
+	return sysfs_emit(buf, "%u\n", quotas->fail_charge_num);
+}
+
+static ssize_t fail_charge_num_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int err = kstrtouint(buf, 0, &quotas->fail_charge_num);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t fail_charge_denom_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+
+	return sysfs_emit(buf, "%u\n", quotas->fail_charge_denom);
+}
+
+static ssize_t fail_charge_denom_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int err = kstrtouint(buf, 0, &quotas->fail_charge_denom);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
 static void damon_sysfs_quotas_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_quotas, kobj));
@@ -1683,12 +1727,20 @@ static struct kobj_attribute damon_sysfs_quotas_effective_bytes_attr =
 static struct kobj_attribute damon_sysfs_quotas_goal_tuner_attr =
 		__ATTR_RW_MODE(goal_tuner, 0600);
 
+static struct kobj_attribute damon_sysfs_quotas_fail_charge_num_attr =
+		__ATTR_RW_MODE(fail_charge_num, 0600);
+
+static struct kobj_attribute damon_sysfs_quotas_fail_charge_denom_attr =
+		__ATTR_RW_MODE(fail_charge_denom, 0600);
+
 static struct attribute *damon_sysfs_quotas_attrs[] = {
 	&damon_sysfs_quotas_ms_attr.attr,
 	&damon_sysfs_quotas_sz_attr.attr,
 	&damon_sysfs_quotas_reset_interval_ms_attr.attr,
 	&damon_sysfs_quotas_effective_bytes_attr.attr,
 	&damon_sysfs_quotas_goal_tuner_attr.attr,
+	&damon_sysfs_quotas_fail_charge_num_attr.attr,
+	&damon_sysfs_quotas_fail_charge_denom_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_quotas);
@@ -2776,6 +2828,8 @@ static struct damos *damon_sysfs_mk_scheme(
 		.weight_nr_accesses = sysfs_weights->nr_accesses,
 		.weight_age = sysfs_weights->age,
 		.goal_tuner = sysfs_quotas->goal_tuner,
+		.fail_charge_num = sysfs_quotas->fail_charge_num,
+		.fail_charge_denom = sysfs_quotas->fail_charge_denom,
 	};
 	struct damos_watermarks wmarks = {
 		.metric = sysfs_wmarks->metric,
-- 
2.47.3

