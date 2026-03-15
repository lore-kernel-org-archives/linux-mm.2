Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58D66F30288
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 21:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2AD26B00A7; Sun, 15 Mar 2026 17:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94BD6B00AA; Sun, 15 Mar 2026 17:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69626B00A9; Sun, 15 Mar 2026 17:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 420026B00A5
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:00:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F05371D543
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:25 +0000 (UTC)
X-FDA: 84549515610.10.651E300
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5AC9C1C000A
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dYUjacPb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773608424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJFiBrIf0gyRsWlV7xJZ7XFBv1X3MK5SwY/M9DxCZM8=;
	b=rB8R5Zi1ZGYwpIdJwvZIB7mSId8frXklXEICv/XWqrI1xXDJyCtiuARBS0fOjJj6Gn7xJO
	C9MD9vrEyeaQmPKHVEJSimgp0/XS+ucImObKNAXhvWo74D+OhVmTBC5dVA8sTPMoNGHI0+
	iSxtexKWRgUVn0e0UkvO6t5+0+49lhg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dYUjacPb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773608424; a=rsa-sha256;
	cv=none;
	b=50X2+J9SwMBHjzKQbXqGqaxu3z5XLOVk6PVjqEy++QbCksG/YLA2F+u1rIfhVJJpuiOvjX
	30x04KfO2bcQWUNZLmrNsy4PLieRoFPD5TWmqlbXwWiRTiYFT5fbVJ6lniuDbsAEHaUGce
	3YSrSlnc/sJgdypcwgUChA72KGvaPKQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A5A0361841;
	Sun, 15 Mar 2026 21:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621B9C2BCAF;
	Sun, 15 Mar 2026 21:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773608423;
	bh=RJ+licMFiBy5Dj4RMj3fE1urGObz4KRM5FWga+atVco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYUjacPbZZ/tHdeR4OPPRLF5Z2QcyEOaEeTGWM2oJ7nYrOPKap0koFyiotrZXwILb
	 7u7zHxR1nef6GALCZ/w3zkkdT3KNbwoxicynfl797ksVEQfx0iXlToZZ+qPsIyGdco
	 gem+LalKmO6ZYTqEkMsTm6jLr2mWZSCRG/JR3bQkP0annKIEYSRJeme69wlBp3JJlu
	 2jxqZ8g/tF2iYzOwuZ3NYZUwtFIaifMZCLKltuvx687FL1ns7SvgBHiuPVycndn4vD
	 /gjuld0e3Pu7zUrKVkN3dci6syDmqkw8vwH2SuaMtDR9jDIO9CqaJ/EHG7T0Lj7jck
	 3kp5/o67gFw9g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 02/10] mm/damon/sysfs: add pause file under context dir
Date: Sun, 15 Mar 2026 14:00:01 -0700
Message-ID: <20260315210012.94846-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315210012.94846-1-sj@kernel.org>
References: <20260315210012.94846-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5AC9C1C000A
X-Stat-Signature: npck9twpe8hiyoj5zcusp9g7ais3nqr6
X-Rspam-User: 
X-HE-Tag: 1773608424-118606
X-HE-Meta: U2FsdGVkX18K5o2xW2xVEcLtf6G1Z3Ii/MDTyMg7oRmB2LyGuf10e9KSz3N2bRXJoEb06ofyqup7BdUOLx9zI6q4rUN6gD9XSKyB4VDINiudHC3auGUhksxS5hjOslh1nuvd2Kv45JfESA4v6g6Iejb0O2HU7cT68nate90y/LbaWeUGuoYoK0tVX16B5F1f0vQGPifaQ8BP61qm5ovOYXMVCbwmDMQR6QlS3xmsIcHCqACcWr3HYCB/fDKND7lXzBL0kKbX0fiO8qhLdSM3qaI6p9nQTyKcbhr98oa3nVDLnJHcH276Z0MIBDS5L8ZoglI7vcm/OEcofYHy3GWaZ6dUhcBq06O1Fgi2h2PIkPXtqPKJXZAxwHuUGKqdD/DwAyJkW9rYP1/UDHXJmoFfoYHPf+I5mnmUF5DPigBvhRw1lwqXBVylIfIjvqfcRTxcHuOnGDtma20RmG8MJg85xb0Sl0x56uK3+HZWe2Tmib87Yn7S/dnUAyVodZ6h6y3CZuBU3ZvZzrtunnDWe5Gr9OqFpNIXNTPeen+1klMjglNONkk80ycOcnSwwsx1mF9Gi+V0R4GJfIOcmriQCeGTxrQOJNXeZ8HmcM7Q0jyJpBsyK9GQ0/qzHDhcs85dGw18l1pinKm7emnQHhflKlrfSERoW6KEZNRzWKH0caZSmQQx22vbQYa9i8QEfu9lX5OTg9I/uHUC82i3QpFPQfOfRO+bTfyqC2LSMvUictZUkCBK9jPV1v4puEXqwIkRNQ7zE/xR16hb2SkY6Vn3oGooYyHuQwdRMb1DoLKS3SwUFlHHCemFn4Ix006sa7qyi/+KgAMUw3w/pJLpQb4vaWskJbLl0msHUtEs8E8pK17IE2OfZ8kbm2j57I5bHNFH8Oyw4Dn2hVJfNPaqDM9J1g5908P6fYgSCWzbICyRYw8ZWAbJSkEECVfzmP5fmU/SXgMi1gFOxPLoYYZrdZqlynv
 cODtmWIx
 bjZ+wV7+JFgOjG3ulBG4Oo0lpkYMwPz4/3JKr0Oa/+BHpSlKmoApYU9Ee1/x4ZXloM7VESbLfypPEJfpn/VBChOOq+WtmUABfUoHzyQoD6UUV08yZDNyi4u9UC4W3JIXEW1+m5/1HGL/+TV74CgazhkkxbHiQBMOQ5ra06GEOS3lCPRrB+yCGtbwqr/eB4s8vTi7qaNahP+PKdKZyC7ncbKhK4zsFTZ2MuWmU
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
 mm/damon/sysfs.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 576d1ddd736bf..4cbb8b9aaba3c 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -866,6 +866,7 @@ struct damon_sysfs_context {
 	struct damon_sysfs_attrs *attrs;
 	struct damon_sysfs_targets *targets;
 	struct damon_sysfs_schemes *schemes;
+	bool pause;
 };
 
 static struct damon_sysfs_context *damon_sysfs_context_alloc(
@@ -1053,6 +1054,30 @@ static ssize_t addr_unit_store(struct kobject *kobj,
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
@@ -1067,10 +1092,14 @@ static struct kobj_attribute damon_sysfs_context_operations_attr =
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
@@ -1470,6 +1499,7 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
 		ctx->min_region_sz = max(
 				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
+	ctx->pause = sys_ctx->pause;
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
-- 
2.47.3

