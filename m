Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C795D109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F566B010E; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF5A6B010F; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C086B0111; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 575F76B010F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1179E8BF71
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:56 +0000 (UTC)
X-FDA: 84570868872.24.3963A00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 564D7C0009
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RB/sw3oy";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jamaEM6c685pSq/jY5dcQbyQ+dKO0m4HiqvsG5FiBWA=;
	b=xoIDfT9YEI/idlLIMLXoK0Z4JDIda4L852T6//ewWHLBKHlw/UuaX1Qy7uIWtJsxID6w5Y
	Xa63VFtPwZ1UR+At2PeAU6BUr9V6i38xRR8CpQWheETjyljMMwC7jCl4bFmdfajFx+IShh
	236FosaJ7wr20j8wjaF+S5LGYNrpIG8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RB/sw3oy";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116834; a=rsa-sha256;
	cv=none;
	b=lYLoUH04e22ic5xZbBhJT3kOeRU9Yayp1HPfqaW9XvBzNZAVgXdObLKABvMKAWIhJ8U1jG
	7rR/hfEgfgy2p7DENi4qQME6TBwXfx1vmZ5XOevURQIg7mYBRmoRKkLWQEZsfB08fJgIaQ
	AEcSAcf0fXQnXoSr8OaxYgQQP0eaq84=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 78F7C44035;
	Sat, 21 Mar 2026 18:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B22DC2BCB0;
	Sat, 21 Mar 2026 18:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116833;
	bh=4uaA+eem3fKB2uPWGLGeH18mf1wXB30aEUf0eMGJT00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RB/sw3oyJZzZe3oe/2j/45aVwyCuxSLgJi3y2xBXmpajajlFV/N42xDccH6B0Bics
	 Utq+GYHtiuQYm+upce6/8fcjzApMvsgXe48QnxS0W2+Z6WqzQoHyhuXmnk5WyH6Spq
	 nsPOT/XnwG5uzG2gAm9xAU1xXg0n9yNYKvF8OFba9jeqaG+hPb6ZdeuEg80ax++8DG
	 KFKSqFNzOUpd9qBIM59v+IP/fTKW1AzwEEdQD9F45whiSPJexdhRMaUH3lxAAJpnYL
	 NP8b7MsG6RhGe5oBzMN1hUUf+nfrIf1N4v62mqVR6UY31boEFpEe8lS3gm33ooKi9V
	 XPON7qvYMTf2g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/10] mm/damon/sysfs: add pause file under context dir
Date: Sat, 21 Mar 2026 11:13:32 -0700
Message-ID: <20260321181343.93971-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321181343.93971-1-sj@kernel.org>
References: <20260321181343.93971-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 564D7C0009
X-Stat-Signature: 8q7r33irbaq88mjnaes5bxrqakc98ni6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774116834-959236
X-HE-Meta: U2FsdGVkX18XAnutDPyPkflJLznM81jWsrUGi8+Y2OKpwi40w/DHMBfoEh09Ua/8SLKrkeTGEzyaMQL3jcaq2qYNcebK7OyeIzSnfRY2m6Eo9GHng+r4eXGZ/57fzgkWq3kg75gEtOeNEPxM3fKpcC5XcEylGMntbwO8LCzg+5ezi3WZlFkpkqkW3bKs6m2glQakt8NtCrntfAbW6iF3sD9kqrb5yQsma9TsIa/trArJm8DtvA62cFwUbdob3q+6QEpvnytLA/exnwAy5uhZ3zdm3In+sN7uG9eDtSiUey7St2MgHG2Ylef8Gz/oCGBPVd+Ynr9znBL6a8Vdy56gYIKtjw0S7Vng0dZL60axrChuK0tUywApTqwp1iylRVlp1jzfb6ECSSTKQUz8TbQ1sPdBrYO6W9NtQ/DDoN22YW4HeeMUryRKDT6gt0V+VY+oVXYdE2knKdNrAKxlNzvDPQURcnC6laa/jQLKYoQwO7W0LAdOjbM2LdyF/BAW4ivh89sA9tFpe0Kb8z9ZSlacFXHKeLeNH7BjcFpYBEtZvYOEqENPCsz2oY/0M02n244HTRqQzJoGyKU5mJl+nTHW3GwFmFrODPwhmKFHQa01HIae3/4Gj+P03eEUsBMRXLBRQFC5IHuRjP/EYV2r4gTccIPKgGg8arHCrEAHFyNCjhXIHlEGCyIwR1lqp1meHKrvoBSqjx7YauSu/1WQdplNOgt0mEuizBbTD2LD2xDKCQjurwtqUKsvrl067+vTTGJSHGUJaSQAo09BG4kU3OA1UxYOZ8eXA+tL7wFDnqrHikgjkAp+/D+gTOceFyk9VENZsu+18K898P1rcKpM6Xfo8ZS39xb8r0qzbp3e3eYigTiMdcADvB3vUdOoAnMbsQqGDPWo5gBdqD18LpuJkNsIftuB4dmoxV9v6LATYS+FHU87Cpm0C4866Q==
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

