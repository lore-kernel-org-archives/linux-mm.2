Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93A8BFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D67D6B0099; Mon, 27 Apr 2026 11:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0872F6B009B; Mon, 27 Apr 2026 11:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F072A6B009D; Mon, 27 Apr 2026 11:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E120E6B0099
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:21:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1CE1E8E25C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:43 +0000 (UTC)
X-FDA: 84704677806.17.E60A784
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 57E1E12000B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iYrNgWHp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3PTrI49ovdbyNFpEK781z99KMvNW4lbp6jy6ZAGKzs=;
	b=Sk7zt04NBj4hC8CHaJ5+gvv8nlH50VygBD4QFJ28DAcC5gLdMc3Lps1n0Arc1WsydM/Txd
	+lZk6+zSmK7S9YaKklCyGmEL0EwF3QPwrx57C6SA6AE2t62rHGigiaA0HHnyR1fCPk4tDF
	CmmEtrRrI1p8AJUVd/KRxCTHw3BxUPw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302761; a=rsa-sha256;
	cv=none;
	b=NKmouzFsIG/pEwsEKA3s2Y5KyMi4XzVyBWResm0TzDS5ufR/Vt6yjxN708c8Yv2IBC64hs
	LbEcISqUjOYN8umQcn9NlnBJDDgBy3ZEbRDGHxD6kn16d3PTugQl6MIN1zeKuB+l46LhsX
	c5/Q57KzB6IrQHVOcZYIzZ/i+Gkreqg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iYrNgWHp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C522360181;
	Mon, 27 Apr 2026 15:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657DBC2BCB5;
	Mon, 27 Apr 2026 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777302760;
	bh=2dcPQ5utp96tpuaw38bt8ZePM4bNlSedzhIzyfTdfgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYrNgWHp5tLzOz/3aqLuMzSn23KTXvrapVoPTw/yBJZ9qbPiEl2mHbD2/7KAcG5yY
	 OtNwvMV/Fwcq57a0D/j1GsDkRO11Pu8gYvB/B9ZWsulVGKEZSRTY/bUwXRmkiq0huD
	 H3hXg2S6vvUgJr3xopSpNwdarO45CgJMaYTDukmpkKOrfPhs+yjrQH0/56+zA9Gawn
	 RU9BVYhxxSdiR/5sVumDvNc/n4cgDnasEYDKuKPdAmdTRKx3UxAuvDXtsKvFoNRVbf
	 Hhiga0luIB/6LHOYBajYCmFXXIC7Ojxb3Cu7sUdsRddsS7JXNn+auf6f8CPBCFe1TX
	 J1ME36DrUTvTQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 02/10] mm/damon/sysfs: add pause file under context dir
Date: Mon, 27 Apr 2026 08:12:21 -0700
Message-ID: <20260427151231.113429-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427151231.113429-1-sj@kernel.org>
References: <20260427151231.113429-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 57E1E12000B
X-Rspamd-Server: rspam04
X-Stat-Signature: 6478s4gehc6zp3g8i6gpokmbbu66w4tq
X-HE-Tag: 1777302761-432870
X-HE-Meta: U2FsdGVkX1+0IOSoMkUUuzgqflVE4PXH0ckR7jgsMzGH9BTgMNC8jFE2+1a9jSL62d/sA59C29mRfPFqM8CnL10knuBjJvUCRSgnwwJbC02tSnOsDG0EQWbGxOpuJwuVlhc4bquAwUNK0CohVljwG74R3qyA4APHkXaaHOVSgLFeEmnNcOmP4L6NKFV7YR85ESHA7zYn9n53hOZuMKfvTs9d38ocvmbjDRzX+ELuUPjPlcJv5mmKhyK9BBeMHGFOp8HGrlWrhCtQfnzi/+8N+nG9+2MLMDIinXKJZKffphWaMyv3M26hdrQqbD/SOF/+WITxh556tsHca155I6spLQQJ2DrkCU7MdV/zLHqnwzvz73Oi9P1zbMc/D2IbxMEi90Edx3uGX9Z8QbiiE6rMAxGZZrm3oIKto3TV28P406fpq0l/swf8KBt5bb13oRyChI8EYsOKFKSDVUu5Pv9ITmo2ag/vpoejph+hZcbFZvAU4sWUxXmD3uY/BUUkkJFh5C8VvAeELsKbsEZAKAjEk/KoLPBrYx9v0pCam1yNgjP2ySCZSF9gq/fRzb+saDGRoeFglvOg+qWndzs1zPdE7eiUYFl3qAZ2N6GbE1eyuMm7sq9s/VwdOmJ/A6VcL/xiUwpb0F9dX7MYUs9t6V5t5LSk7flARlAop/7+t8C1KMOi0kG1KLKfCRkRKrkfrDRbmg1ndpP2YxWopKNB5bLbHALXii5bDkr7HgWDKj/TvXk3YF6rbAmFQE6BeyGb8VvzQ0766ELQuSg74m4Rmvx9gPCnlvgnzBiCrPhXDCuG5wH38gH/vjrRgbo2NhqK7bJSnLuf34ESEBlWG7r/tXiG0VlaaDquIgNYunDPYmOVnLDyCBA3amhhqahIkvPiU2QFVc5rawiVmtlWoD061U9llrONoIgiQv1WxCdxHwKDQdEutRiGaeDAXBUKKZOl74KNJvJHxO+vcNPpUrEWMXy
 V9D7cFPG
 8o5BwKhee9hCBjmMYGOo5r1KSXv47+3+aKtvJBLceo/9i3eKLf/GlykSVkjSCW3mW25o9QxLIXOdWZj9h2dBHVFoRl766+AAxNef759SwZGew80HUCL0V6eEIhUi1XQtSY7fzwbEVPj3kcDctLNpYQel6M05W2PvWu9/ol8KyuHtsPcvK9zN0Ks//tzch2ESt6fxk
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
index eefa959aa30ae..d5863cc33d230 100644
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

