Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3CE8FC72CA
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0AB76B008C; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F306B0092; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9A76B0096; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 542276B0092
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5C9DBE023
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:45 +0000 (UTC)
X-FDA: 84578887050.12.97B3D6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E0880180010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n2jOlGxK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774307743; a=rsa-sha256;
	cv=none;
	b=v/zQme773KlXTfPIUvqYyVAvw2pHisBGYbpk5zHz3VTh0oP3vaLqGekNvT/O1XfEuVYsWa
	F/HM3B4T1Wb2RHD3GJ4Z+PHyooGrI6X0+FM+5wypCNEAbTziy/eX2DxXFrvNW1Jf643VnJ
	/ZrdCR8zeWt4jbZbC9FqfQlOF8Q3p/o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n2jOlGxK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774307743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jamaEM6c685pSq/jY5dcQbyQ+dKO0m4HiqvsG5FiBWA=;
	b=OmtmA1c5HU3iLCA+ureSy2bNLjg4kGw3MHaVqJxffLrwBGLv7dH4fnjnOhjc5cDVUsmGCb
	3jXDcsA7Z8jBICbZDq0Kk+pTANFSU7lEsHB9TnKaTKXrkd1Ml1AZWir1kafJaIo9Tc/+Xk
	BblY20MmzmB5STzOB61Fp9cK4hOOJQA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A98D60128;
	Mon, 23 Mar 2026 23:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FB6C2BCB6;
	Mon, 23 Mar 2026 23:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774307743;
	bh=4uaA+eem3fKB2uPWGLGeH18mf1wXB30aEUf0eMGJT00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2jOlGxKZnItSh90/CHwHf/3n40YsKYeI9L/w7x5ASEzPnbBBSCpFKdwahiYgoVeO
	 xvqprGtmJD4jplV0wQSYLyL7jEFiGAvX8V832u8sVPSvnARMhUY023Nu/ls/MHlPZf
	 dt4o6t9+fTL4hXy1fm0pSNWIimu6iRrL79/YtqdWxViOExCq40k5Yt/kUwc9hLVdeC
	 WiuxaHWn5HQ3iING4xC5x89Wn7jnK53PZPg6OmGpq9BXywTInLRjTFCo7g0jNApELO
	 YA2mGnLf6Z1SuTzWoFU3/3If7etKf/7aHS4Kz1mTUfC8QtH0lGuEe3Uce4AmcvT3f6
	 joe+9vz2UYS4Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 02/10] mm/damon/sysfs: add pause file under context dir
Date: Mon, 23 Mar 2026 16:15:27 -0700
Message-ID: <20260323231538.84452-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323231538.84452-1-sj@kernel.org>
References: <20260323231538.84452-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o9mfdmgo3njpgwufqbp1wgobuamhfkmh
X-Rspamd-Queue-Id: E0880180010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774307743-1008
X-HE-Meta: U2FsdGVkX19fEjguUpTUhScVcwenRdyeHPbv6xNw78n42i8R7OII9BVTDahCq4GCFjkF2zwO4VR3yIvVkO9lbvu/59zY0lIVkCDLJO+n3s4a9vw+3+nSR7EuMJZ5tmclmYlLZ22QxGi4QYBMgpv2E6xBZakWVdrdPvSU865Jn1qaoMrNd0W/OYTiC81Wrkp/8QjLx30NkQSY0/LrKGIGx2XMHarjwk/YbAANRsKHrVRK6eaQ1m6XC/YAyR4sui9aDKl3ztoigPMjkUAOVP9Ztpw23gHbaOCoIIMT8VxOwA/sqrdVC1DscYlmxblKHdhPLjb6EOyyOxoj7mIh+IwWjvp+F6MaGc5PAw8N+lLyZX/hMQpCvTWkKYYRL13T2XqsfuDBadpHUyYqvYWkItqyCk3iX+oysep0HwR6mqpOupnOnPNJx4QNGa0lYUUpo6NdI9EPvMY39lSslzsRkGJKnfc87cPvnCGCRByWAkd0dVk0bOk+46GWiOd4Nbeiio9jdaXDjdQ+I9w5PPRMU6n1n4cl3v1CEimOgNtNSpfKWEP71nHhV6+U7uxpXYphjzTl195/GcioayETHXWfXUOtNMS1rT4xFrjRQqUSwjnQI6mISIxdx7DJUczXoyf7jfGEHNRS/pmici3ROw4Z+X+piFAXue+CwU3e9riBrO78Rqrt7a+LpC1I1Wa9V+bQ2zTDQ9SyCqkhZE0EMghOUyDpTD5E+UyXFhtwLuTSKhjrOZLLTl12rSUQ0uDTXMQ2N11gxwkPh92NJAYzJ8KWceIH09hNAlXFXPe/GX0pmK3HpRfmtXDzrtHK4le7rjfiA1KgTIgCqdqUVRovEBraYG3T6KEway3ytEscHavVAtPontMQhrl/FMFP0JPZ8pZ7NG92M9se8b+IBQrFrpfWafXgEUS97u6dI/kZUBHyX+MY8KTqwcjGIE4yihEmOtq07Vo1C39BEI93E4mXTbEVJtz
 HZKkHc6g
 cI2+02ZOdWGuBFvMvuX/U6cOTc315Gik7mo9jd0vwxzyncGtOhvhUv729yBpnvZ2XySwEKwPA+KBa92VcQRWze1GgNljHJ1qvCLGmQ/pZj+57QU+3qNG0PKLR3ounJP7BJzmwvfpSBnb5FCzTbAPA4AaO2k5HQT7TUVW+3vrtD2Y/m1UH0avClDJ92jArYX6WohtDpEFwmkEslJtXfhsk4uHPp4af/0/TnJOP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add pause DAMON sysfs file under the context directory.  It exposes the
damon_ctx->pause API parameter to the users so that they can use the
pause/resume feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6a44a2f3d8fc9..51893abd09472 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -866,6 +866,7 @@ struct damon_sysfs_context {
 	struct damon_sysfs_attrs *attrs;
 	struct damon_sysfs_targets *targets;
 	struct damon_sysfs_schemes *schemes;
+	bool pause;
 };
 
 static struct damon_sysfs_context *damon_sysfs_context_alloc(
@@ -878,6 +879,7 @@ static struct damon_sysfs_context *damon_sysfs_context_alloc(
 	context->kobj = (struct kobject){};
 	context->ops_id = ops_id;
 	context->addr_unit = 1;
+	context->pause = false;
 	return context;
 }
 
@@ -1053,6 +1055,30 @@ static ssize_t addr_unit_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t pause_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_context *context = container_of(kobj,
+			struct damon_sysfs_context, kobj);
+
+	return sysfs_emit(buf, "%c\n", context->pause ? 'Y' : 'N');
+}
+
+static ssize_t pause_store(struct kobject *kobj, struct kobj_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct damon_sysfs_context *context = container_of(kobj,
+			struct damon_sysfs_context, kobj);
+	bool pause;
+	int err = kstrtobool(buf, &pause);
+
+	if (err)
+		return err;
+	context->pause = pause;
+	return count;
+}
+
+
 static void damon_sysfs_context_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_context, kobj));
@@ -1067,10 +1093,14 @@ static struct kobj_attribute damon_sysfs_context_operations_attr =
 static struct kobj_attribute damon_sysfs_context_addr_unit_attr =
 		__ATTR_RW_MODE(addr_unit, 0600);
 
+static struct kobj_attribute damon_sysfs_context_pause_attr =
+		__ATTR_RW_MODE(pause, 0600);
+
 static struct attribute *damon_sysfs_context_attrs[] = {
 	&damon_sysfs_context_avail_operations_attr.attr,
 	&damon_sysfs_context_operations_attr.attr,
 	&damon_sysfs_context_addr_unit_attr.attr,
+	&damon_sysfs_context_pause_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_context);
@@ -1470,6 +1500,7 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
 		ctx->min_region_sz = max(
 				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
+	ctx->pause = sys_ctx->pause;
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
-- 
2.47.3

