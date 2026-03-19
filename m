Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FB671088E7E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 661B96B03DF; Thu, 19 Mar 2026 01:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611FA6B03E0; Thu, 19 Mar 2026 01:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527B56B03E1; Thu, 19 Mar 2026 01:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 454E36B03DF
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:22:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA9CC1A0185
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:09 +0000 (UTC)
X-FDA: 84561666378.24.40F2CFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7CBDA140002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R3xmC6P6;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773897728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bs7y7h/LIA/thCuFbueKaj/4BQ0qjGHk6O4IsHQaU9Q=;
	b=StTpsz6kjgDtt2gPZhChOF8pl0fB4lIsHWR6/f0sMh9Z3CYuiKrD917H8rvrMGtmvNNObu
	xWSezk+c+UAG8uChBAcf/CPbK6vPGcAubPBz3HgI7+oJrbqv5oSgX2ZuElNwmRi6/EwUAJ
	2ibgGuoQ28TPqTMIl2VG0EVMbmBcgzs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R3xmC6P6;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773897728; a=rsa-sha256;
	cv=none;
	b=DD3z/R4fljpR5nfcjSgtr5WCv5q+/d0K5/L65aXWzRReh5ACwX3kT9KD5BiIyHitD4UM2w
	pf/sw7kwS+RhvhqQFd7LEm542dmRZpN9rreIGwD/z4mq2uceNqy4d/2+bK5ETGmnJcDW3b
	NkygtuKbX6v6o6NkAQrzKS9Qozzb1Hg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D323D60128;
	Thu, 19 Mar 2026 05:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751ACC2BCB0;
	Thu, 19 Mar 2026 05:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773897727;
	bh=MqEq3gnpER/1i109FUnzNmYJCrHCG/6rdnfY8eFpkpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3xmC6P6OTHd+Fs+mCFy/jqh14jFnG3Fl4q5rjQ2c2rio5VNHnB87XL87/U51kLyb
	 nFxYMDbfULAUqYw2HCA0U5ebdHOsRLEGimnW1d3dRsf0aQvqJKcmjXTsWzbyC0UdZL
	 ldsFPoY6Vnvy4iSeU99JIFEyvIHPWWcNQFSR7Ggl5DrON5/LtpuxRE8s5isI+kj2O4
	 ev/yAh9ObnSHMXiFlOGBHnC7Byd1MmL4+Bad4KiO1KiR+tfqXBufseSbcauIon5KD5
	 yWruBU376m3NO9oWFKi5nzwtHZxkEll6vXNu65GvcUTYv6ZomuH5sqP1XCqr134E6l
	 bUvoUggz7NKWg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 02/10] mm/damon/sysfs: add pause file under context dir
Date: Wed, 18 Mar 2026 22:21:45 -0700
Message-ID: <20260319052157.99433-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-1-sj@kernel.org>
References: <20260319052157.99433-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7CBDA140002
X-Stat-Signature: wxzff9doxjyxm3oykpkfddqayexczcih
X-Rspam-User: 
X-HE-Tag: 1773897728-747128
X-HE-Meta: U2FsdGVkX18Au8WwDe54ZiRO5l9Ruit1Nrqooo7ViWe2jhLJWBv0jKqoJHnHWwFxaHKkBS7U2Mbykc1cczM/YUCRSfm9AjpTzkwZaNPwOVOuRcocG4hWHPVQATLnn40C21JG8BWDteKihfeY5EreDM8smm97NFWlUHv5WVk2mPUikzo590WB4zrtxiIHenQdQKcgqpB1aNGOCZaNtLBluSpBj9ahPxQCthWQJnGti8BDnUj0Dkv+w1In0KXHcI/FX+0hlRsbsZDxEArBV15ztRgpkzesTG7Lz7kVc9V+lOGFftUQ/6R52mZ+VFnQOsSicY7OwngZRi69KUnSqKDCy9epHbVOAObBFWl5xL3Cspcl5EI3JqplOswnndXJnz1h40Y1DMIzX8NojlmQspxGwm0ZazxnVw8ywRs7H68LHKjXiSLJFqHwj2M0qOSn6eIcL/HGoiNb11w5bhWWHbM52YT3sf57kApx14YgyV/4eZRGeLdiiSQN9znHJ+d4LDlRm+FNIvrogBpmmvMdON9e5+y5dlgghO0LtUhpmgH9Kf7vy5xb/Gw3FMDSmlYSI+yr0dtgJnkendjSv9g1o4NSAM4gCqKiXPeICjSLhRvlKqRG7iwqQ4vmeW6/Bfom9DK/hkqGaccggN5z9vDsQ4p3TkfsESHWuFTpiME58SRH0oRKDiJW3nZJetbLJ7qHKkYEg+cgOGLPzBzy9YxnHhyZJsTy6RvCOXntv5syEFpCiuV3vgDDdm8+ToN5Bky8CPFcrD7hi4o/vUFCxdosABZYymhYfgYuFBFuapiEp/xVXrWs8Acn8aULAYxvL8d8f4IzbP1AcdPQQ54JF8TDuIWGlf4Rn6uqyxdaH/IRguGkLGK4wNGnHImZTBZGdXFIe9gCMtZE2V3g+QM=
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
index 576d1ddd736bf..7bd42dd8c4a73 100644
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

