Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C09F2FC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 15:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6E906B0093; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4C4D6B0095; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02006B008A; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A0276B008C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33AFE1E750
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:41 +0000 (UTC)
X-FDA: 84574154322.11.3EEF923
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7F2701C000C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mcWBUA0v;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774195059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jamaEM6c685pSq/jY5dcQbyQ+dKO0m4HiqvsG5FiBWA=;
	b=pL7+XVdZ/9l8f+jru3ian0Zo7ga2Y5390yLqCt4s/U7G3qye9b8FPaC4xJ9jom/uDgtoWF
	as9sl2Klp5jJLNtjBtVrT7+3JcoCr30/fBW2PUy2mZZl1sWHG+BqjAAmw8sTV5KJKlicBH
	HZRBUvZCRmJz7ROWTacbVE2uSiNmUFQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mcWBUA0v;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774195059; a=rsa-sha256;
	cv=none;
	b=UvcTWV6A3b8qfzmbQ2x5XaPn3rFIWFw6sB89cwzymYWQXA5ydMsbYC3qD6CbcWFncuyV6f
	2H59yoUb1h2GMIi+6CeBnnrDOXcR7tm8PiWq0vFS7Lt5pQKKL/+nvlb7wiNQtfjmmyfdnp
	Sam4c9jYF8v59/EmFEBUBTUskU61Ago=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7677F4442D;
	Sun, 22 Mar 2026 15:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45132C2BCB7;
	Sun, 22 Mar 2026 15:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774195058;
	bh=4uaA+eem3fKB2uPWGLGeH18mf1wXB30aEUf0eMGJT00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcWBUA0v1S+nQq/xWMdSkunC1QXnJA9K5/R6qIdXOda8x4pe3Qw65DmIG1X0zFdb8
	 ECow1YHbNKW6fBpHW0z2V26PgttJJ5a+ZJmp/H4V/V07WmvIiIUDw2h6RM5/o8XbBd
	 7VJy4tMFPEX/VVf3WiWYeUchdUHmSigjbglemysSLFuOETdvGejrow3zouTXLiiZi+
	 9hFyFeIucYjVYph+ndoYqvE8mt74zqts4HKe/7Zk/dEltm/J2pvDEma0RMjMEzC5kz
	 NuhQEBTjEkqqrLd9vyib2/WKQL7YljFbtmvzzg1fRwD06Bg9bfsq7wEGN8kDU5F28i
	 Wn5luw/D2CKrQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 02/10] mm/damon/sysfs: add pause file under context dir
Date: Sun, 22 Mar 2026 08:57:16 -0700
Message-ID: <20260322155728.81434-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322155728.81434-1-sj@kernel.org>
References: <20260322155728.81434-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F2701C000C
X-Rspamd-Server: rspam07
X-Stat-Signature: jh9mg6wh7nbe4diwsu8ebrydrnk4ingx
X-Rspam-User: 
X-HE-Tag: 1774195059-830239
X-HE-Meta: U2FsdGVkX19rDXzDbCBMLb/H0pxXzjqG8YBxLefMrPdIz57oAyAk1GbDAZ5lylx8dUEWJWQoJ2Kp5WEC4f0jyKp9ZqYxowiu8t+SfGlEksGmGY3cGVQUmc0K8gsdBk6J2DR1ym1LlcAkZq9/gWMd4WHmuc+jRo1NK+0hK7En6hZVQ/i++KXzp0zO4XZCaAHvOh+zNeQ/o5CThuZ+1hav5MOyMBR7nOUMn0E9itfRERn6VaDnz4OkBx7aMGwzERUIh8xuAThrvpfrSsnMJnAbdqpyXVm6K3Yq8VcMQ1LmivjVbypC4qJxANEZXqxzrEb+ADfMXr/sBxeVQ+st82Zy+pknBhthmLpV8BG7BpakGuLBS6qx+mCd6kzP1eT94CXzQ+EDKalzxemMe1FNZt5xayse36sXiG/nK7U7j47YdtupuLfJGWGwYZRiMzt6VunGZNS1FFvAklcOTAvNoLBeVSdeVU13kUEA2QHd2CHW+VyeKYEQ2R5PgLAs5RbyISLONH8pTPjph4g1i3WChydm4U7B8jyBS3Y409H4FPopfLX8tsGecOVWz13xgfr3IYITkn1LfxCaNv8737zM1VnUkK29kDgz0GI9ZfQTx5hGR5Xp6V00YwqerQJDJ5if8QsWCP2tykHAoXs+aeGSzLNkBsvSnX6s/8utdTnn+W2fZfCdRubNM4yE+5PvtTztU59iMVqSrtPUAs1yHZa/a2priF7Q/W3vLWnkbeu1EYrCRir0M3NDBJL+dDnKnviNE98WbMS9K05Dq8qv4M9d4u3QNi7I4zAR0OIyen7/YvVSvJai4Anz1822wOq9y0+lqHRXJVblkFU+xCoaFJZWQzAuv8JTA+/qZVPqeb5Z6Plq6UZzJ6ZS1mbHalwL5dn78DHLKh6uIcXiplEuS8GG3TEho0W59C2iwkIWV9CabxODOsPaiu+MPoSep3IRMygSllEnGSg3652CcN60y169Qpo
 63o8teWQ
 4S7zDIm8tQM+neOIiECUtAarzxqz30mbTlLoRDTLqOthU04gEJh2CfWFkjPinNDSjAJaINXTTNxTEpSHIqYJlxqDrf8SemGR2f87j7Aokya3Mj1NFFQtRho+ZT8XnZgGgSOokoJRoGx1mYJRpEQGl5AF2KsxCNLYiLsD7D8htCfmMBJydDNBBlYYddiwvP0s0ebK/NMI/G1xIrbU6zEVuSj/ABIvRgDuzbSoW3iZgNtVBu3k=
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

