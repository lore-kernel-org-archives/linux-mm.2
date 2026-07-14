Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3E8BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 491766B0098; Tue, 14 Jul 2026 00:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4693B6B009B; Tue, 14 Jul 2026 00:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2220D6B009E; Tue, 14 Jul 2026 00:34:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D43306B009D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:34:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F0A9120271
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:48 +0000 (UTC)
X-FDA: 84986116656.09.6ED048C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A69D0140009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mod0YMvx;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784003686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UrQWXD0bifnsUsYgqcN+mYTdFMuNVs+95dSBQVBP0NI=;
	b=JqS4T8avlQ5Z51SlEQy93K7oYmWlINX4gdsMk+Myveb1vD3iVorpI4zuCFMhYcwdStP7eq
	x41rPcwWRKn5381ZL1pBJ9A1NDt4F576C18bqKDpOhQly/Yi8cnJM8pTl+rF44NPiv2nDy
	TH/2rKDeOAYA3DvbYaVOp8PLOJ+WeSM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mod0YMvx;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784003686;
	b=U7SF18+eUX9aG1YkpcOoKvTdzRnnl10sCHhZqU9II2D+muwy1xkpPHBeSShERpd5OQY0nJ
	kUm/kKETk6c9R/CC1Pb9VKBSWPBAoVQvG69u7euWGVuBsWlrd736FlNoPYKBlDyhwGrQwX
	ZdXyAof/X3ImoK3299xycWUJ9bZqQ6c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F81C43CAB;
	Tue, 14 Jul 2026 04:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF2B1F00A3E;
	Tue, 14 Jul 2026 04:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784003685;
	bh=UrQWXD0bifnsUsYgqcN+mYTdFMuNVs+95dSBQVBP0NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mod0YMvxWwnNieAilRhZlXa4fBY4k1B/jJ17n9UWCbmMi8tkIdmEXYbLd0hemF6zl
	 HxM2L6kryfF9ldwH07+K0/KgPRPkPiFUU4xuZSIjEvAdK6Bs5vjTA7Xn8GTtV0jaPr
	 +wJAGhSpxF0iREV3CuCo/s5JHxuGknG0grRFJYdh+PhcuKRCWH1G2c35vfT7cDjGgs
	 2jl5pUDv6kjRvSOtroA90n4qKz3x1JOGpv/XLQpTaDf8vvvzFR+/ANK7xoSGHWHfJh
	 j7DJ2TUof92FhIrcYDeuWCrxBfjHJ3b2irKbJ1dI384MzRF7eA8pui8BffCThCxpJ9
	 lLO8+QNGPv66g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 09/10] mm/damon/sysfs: do not directly access damon_ctx->ops
Date: Mon, 13 Jul 2026 21:34:35 -0700
Message-ID: <20260714043437.95811-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714043437.95811-1-sj@kernel.org>
References: <20260714043437.95811-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: awgf6kr5kj98wcw9ufough7n4kc89uzm
X-Rspamd-Queue-Id: A69D0140009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784003686-901429
X-HE-Meta: U2FsdGVkX18xOMuYGferW0yDvSXura/7O6oGVu3Waw1+iqw/CmUi+9PboD9gHohh0TylCp87+rFfoygZtyD9C3t8pjEa6MT7POlRBt2jjZ7hk1EdpyxCq8WSKmfFnt5VqLv0qRMIW0mWAS2SS9eQgL5hv8VRYTl6Iw3mvCJ03pzADJgZpmAN+k9iCkIonv2Vo7Iw0FiT1y2A2JT2AelyIACfr/QaisV8YYe7uBt1IOHVlGEO6d7px9fR7VPMt/BAl8vxKuz9X0N4MRSyEXCQ1FsYTm0Tj1scAuMEwv1xPCyuG4bD7eorlYyy/tGpWoxnoXLXgf6auyCa4XYDvVpEHsNt0slvJZZ6HTguD24WhDxrhtfn30vp1NEjRlxt8NFwPZtHg0+4LsEMlPkcpjWcynldD9jwU2YJPvT5Yywzt4YS1K7R1QtDH+gurK+gJBtuodVrdz5yL3ncjv7ohv97AKI6Ra18iDP8QCJCOaZI70hfXsz7bjvtM7XT453hskB3zanE5FFG0UURCSV2UmlLQwXEkojWQ6AYQKWfTycTxCxTivgR5FXGbKCEyZU6BHn9mtS6VIKQ8xAtFMNWNjPiLrZ2RATVu7P7HF7TFf/q0LAs7+OuuMu8qgfTMSMfNUZisUxhh+/Cj/WvuqwE+NHs47ghhCfozZt2x/3ykg4QFKLuHeV7i/kwboXgi8U/pB+DwnFChZPCjMQNX5iu6v/e3uhxM9I47qA+7/TcmMN638YZAMO6gOuLwrsSnQ6IGFljzk6QtrBXTjhG8q2+y7pybb4HDZA2KF4qbzXnv3uTqLTEetskZZJ75cg7isdIJwFNfB+zNpexgsK2isjhSwPdgnkhazfB8I8tI9zODpQXGQUtxzN4NME449tKCHYkBCPZiJu7MyYgsVBmaWeSOJWTPwNF3IV2QcdC4sXXh1002wl7/wENm4HL/YTg3gyQ5Mw9qq8jhmEvJLy5He7UpIk
 dOVJiXRt
 7gaAx7SPR0XRShoBto93+7Ev0k2rK3klXZEVbwEvHBM//CZnrf3mQDYxSKcwiQxOjY9Q+aJ+OE98mNL0QjudZr8VyjjdOFTvk7J6dtdc6xqB9ZqicISAC3WBCzzu2jUWCD4TFckB7EnnZQsmRLKwUFHqN1lWxLzajAtwwk6AsKMqgDT1kW21VJZD4VOnYyNelkPngZV7wZM759RYtVf//EfPCfS5QKRZAjpzlLTrijSwdv+nQ/DpI/3H5u1dA3ROmYZxxSnMWJvOkTm7V/GrA9wpeyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_ctx->ops field is intended to be used by only the DAMON core
layer.  DAMON_SYSFS is directly reading the field to find if it is for
physical address monitoring, though.  Use the API function for the
purpose, damon_target_has_pid(), instead.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 60a1a9e4ada34..228ceb4df5f97 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2051,7 +2051,7 @@ static int damon_sysfs_add_targets(struct damon_ctx *ctx,
 	int i, err;
 
 	/* Multiple physical address space monitoring targets makes no sense */
-	if (ctx->ops.id == DAMON_OPS_PADDR && sysfs_targets->nr > 1)
+	if (!damon_target_has_pid(ctx) && sysfs_targets->nr > 1)
 		return -EINVAL;
 
 	for (i = 0; i < sysfs_targets->nr; i++) {
-- 
2.47.3

