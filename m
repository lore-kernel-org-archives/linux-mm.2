Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ABC5C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9ED6B0186; Tue,  1 Sep 2026 09:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC05C6B0188; Tue,  1 Sep 2026 09:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961656B018D; Tue,  1 Sep 2026 09:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68F276B0186
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2950C0411
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:19 +0000 (UTC)
X-FDA: 85165264758.12.A914BF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6B6CE140011
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=amygPIRt;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpyWxBrGaST77vm6YyG0Qbwcf9E6DAqPTZr9W1qgAUU=;
	b=VVTqg+MFiRRX14QpX4jn08FuC5XsICnu0G+e58/y4mmNKJq/QYH5R7B6YFdqQb09QD5q0K
	PrI6+cKs0JaMLzsfJUtRpClv9FzbzG1269Uwi1d1dy/KDtz2yF1/85+Jr1p5Sc1pLbWqfR
	FdeUAFbECAmSHBt9XwJc2KOfzwJO470=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269118;
	b=uAAf9D5OT/MdFLEnlcJtRgYq+7Lw7YtSLd3kATqzsjyhOEtO5bC6h5K04EkmlVoB7/L76f
	sWWErTYG/l7XV3xjQEg7v7L5a9GLti0bK/tv23cqS8q327LElK6Ent6F3AVrkFgIuJtA4H
	GqjT4+CjIUYDBxr8qZuRZfL/e98ubeU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=amygPIRt;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0599760A56;
	Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CE11F00ACA;
	Tue,  1 Sep 2026 13:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269117;
	bh=OpyWxBrGaST77vm6YyG0Qbwcf9E6DAqPTZr9W1qgAUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=amygPIRtCamOEChxFe6EU72WlaHv1AGk8cE4BcJs/D2pvz4gG8DnhfNrZGQ79M9hf
	 EPeISk5p3+OwZvXTqEFE9jS9dPAebeYlaXnIOiyoHJT9/3DLiOZTHgYYOroAg8cn7G
	 zs1/7WCgJ5KltZFn2wgvgvLE1jjmexlDohrEAAcme7h3v3XOGGAzt86m6bpA5iBzpn
	 KRqt+F+AYR7GbCSzzsag3rWWV6c1TO289VU7RqcLKUZrH9dZ/hb7jGCBkbWz5rHnTo
	 CzOg7xc13ImIL22vADZuFPfif8AUhihNp2z/gT3AyLV5vWlMnRYoR8EgbUXmABRjrx
	 yWEW+C6tpRZmA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 08/17] mm/damon/paddr: support damon_prep
Date: Tue,  1 Sep 2026 06:24:55 -0700
Message-ID: <20260901132506.99243-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B6CE140011
X-Stat-Signature: mc7fm3mb5ue5q7874qaqjebb3j813isx
X-HE-Tag: 1788269118-329488
X-HE-Meta: U2FsdGVkX1/DNlnDZc1i3BcYBhwv2wxD06vnof4cc61nPun2iLvXRM7iVexs2/71L2w0Hazy4YpulqhZNz9bfgBxYWtwZofRFyvZ4X6Yv94W3O+87N0jhvLxUe1eDPSbasecw4o7izVkSlSNpUwpFM3UJau2rO0FvxIkdWGaMUblkJhwu0hkgBWZqddv0ippVarn04+4W5UNYxc13L6aRoRvL1kJSFI3l58Zv4PnVFzEr0JBo+EZ/J1PsRtv0n8zuxnfd86AffVHOtHrUid2cI++Rj5raY4iRoBe3FMQcmWQzNute24FITZovdXtq9Hr03QpHniqFcDq5DOlNBUW2CRHgcjO4yW6mNm7tWv6zqYEFg14ug/Wzw3pZ0G2Er7nI5PZVPj+doztahbejXFSsZ3G00/Up1wU9O2/wTbmUQoVUieozQBQVlATOoQpQH7lr6zYv9fPm46PhSPLHixrzqY/5c5Z2KDf/aWNuF/RzqVazODZPPuLyvSxFueC3I9w3jIyCwgkds6xw7wkDrIod2th5n7nb/6Bf2lSU2lj9FU7CygDyDip1Q6yPObSYxIPcmlvRORwB0AjZtOGFFUNQEz1THNuHo+dvf8ttvPCGILMj4n5g4KbMxT+Z3uW3CAJD3jbt4fvkKSM8O8GuVK5ZSno1Wij/Nqh25i12qKPBFMnwF1sedcLCbYZGv02feGr5gbmjVaIe5zrGErJWSUmKG+K7xqrp0Za8tvbxf1RFCJOQxiuPW1ms+Jn5T+uOhzSnE6JWV5X46bsEpxKvlokJLmE77kETGK8o6DwPE4jEKS1C1PtoqIEJ1rNFCGODAXZF0wGixIJe5IASiT/afgWO8H0U68cuHVZC6byc4zrrI9Ud64ho1UpcC9UKkeXQo3Qi++Gs1JMxeGHONUiRBF3Lwm2+0BogA2gcJme39T1CPsGf88F/S1yWUaWpBUhls8JhbWZersn1lh124yGb0g
 m2fFQkcI
 cwO/Sd0TE+SmX8lyH06bNddgc358XtCbO8njxLRKluNPdiYX6BWOc5cPN4X6nvQ3b5zpVC/ggy780xpBxt49qyKjWsHF0MYRw+BxxVI4QFGOj4qNaePSvCLq0LGpZ/R+q24anA6EI6hIVgXIPtwYxWT+82Wb+qz1ZhD1t/lzH47acwWHlZ/rK6OTydJ+IaI1Gv1+vkHJwN1t7EguZIRSrEWuk5TBJrC2s1IPJgR4tZpblrp/PVMUkp4Z2jMc70sLgTql1QUxxtt2MpboLa1u7cjVyag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement damon_operations->prep_probes() callback.  Support the only
existing prep action, DAMON_PREP_SET_PGIDLE in a way similar to what it
was doing for the access check preparation: unset page table accessed
bits and set PG_Idle flag.  Reuse the function for the access check
preparation.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 6f756f8493894..c1e7d7a4f40df 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -105,6 +105,40 @@ static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
 	return max_nr_accesses;
 }
 
+static void damon_pa_prep_probes_region(struct damon_region *r,
+		struct damon_probe *probe, struct damon_ctx *ctx)
+{
+	struct damon_prep *p;
+
+	damon_for_each_prep(p, probe) {
+		switch (p->action) {
+		case DAMON_PREP_SET_PGIDLE:
+			damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr,
+						ctx->addr_unit));
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void damon_pa_prep_probes(struct damon_ctx *ctx, bool set_samples)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_probe *p;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region(r, t) {
+			if (set_samples)
+				r->sampling_addr = damon_rand(ctx, r->ar.start,
+						r->ar.end);
+			damon_for_each_probe(p, ctx)
+				damon_pa_prep_probes_region(r, p, ctx);
+		}
+	}
+}
+
 static bool damon_pa_filter_match(struct damon_filter *filter,
 		struct folio *folio)
 {
@@ -448,6 +482,7 @@ static int __init damon_pa_initcall(void)
 		.update = NULL,
 		.prepare_access_checks = damon_pa_prepare_access_checks,
 		.check_accesses = damon_pa_check_accesses,
+		.prep_probes = damon_pa_prep_probes,
 		.apply_probes = damon_pa_apply_probes,
 		.target_valid = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
-- 
2.47.3

