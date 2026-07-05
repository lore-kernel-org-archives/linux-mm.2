Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53197C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8639B6B00A7; Sun,  5 Jul 2026 16:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814FB6B00A9; Sun,  5 Jul 2026 16:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72AA76B00AA; Sun,  5 Jul 2026 16:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34D1A6B00A7
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:57:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97DD91C0E81
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:58 +0000 (UTC)
X-FDA: 84955935036.19.A97D049
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 15EC740002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WwVyRiW5;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CerPQCpLVt90M0nUjHgPSrY+HHMTa8twt+lmeeO7V1s=;
	b=o1E7Pbqe/GCWr8gvY8Cx65RJPZ6GU7NX47qDxY8iZcX0zWJEGQIqGHsk5E4XlGj1fiTJxn
	5IDddZIN10wIYKDqSWjlB/faHpbB1NrnW7NoFRm/h6/Fgel1FN++3XGPGyadB6laIXBNbY
	0VKvvhA20IWGJKlre12EMFgfOQjoOU4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285077;
	b=634nO4YKYePC5vSOs4iOBSxJi2lbl9fAEFrxImyKuhcn00YrKZSa7zDiBf67JTqJaVarz7
	fToro4bsgxuDy4RedtLJp0JXGgpBuYihT2vxtF12FP+mozaFdNBsA9FiHVHkkrH/bDq9Kl
	Jrwe7caQp7DnTQR+kEllzYOWebssUeY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WwVyRiW5;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A37BA6138A;
	Sun,  5 Jul 2026 20:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143901F00A3E;
	Sun,  5 Jul 2026 20:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285076;
	bh=CerPQCpLVt90M0nUjHgPSrY+HHMTa8twt+lmeeO7V1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WwVyRiW5rsxPwlJh+5kk4V454aIQaLqpXiurpK0plRnh7GJjP/XZhNTwbEGWOOF7p
	 /whtAWXYP81oJriugLVSbpDNK5IkxKJ1Ejg5rP9f0M5y997hRuFcRXDcViyiMmbNwq
	 /06vsutBypmFJl2M9qnhwkeaRIJ4HaB9gsygso1AHWyBWv2so+irzL9xuiUrvgrg/q
	 3/u5efHoT/MFfuflgTHEIIKR0OOsq1GC2x51NFPCQ9KwpNUzI1vh9tNkopNR6j8nCZ
	 wDygJEbkgAaR8w5hG8/bGK6fuyCFNiEsxJkHgQGbICCRqLIeTjiCwz8/k3B9jKrXR4
	 vCwt6LGRMvLYg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 08/16] mm/damon/core: disable access monitoring when probe weights are set
Date: Sun,  5 Jul 2026 13:57:30 -0700
Message-ID: <20260705205743.98656-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 15EC740002
X-Stat-Signature: gbfm6iiwsbgnho5err7nk53ne7d9qc64
X-HE-Tag: 1783285076-720719
X-HE-Meta: U2FsdGVkX19RNKhlnb82VRAoHU6EYzA02f48Mez0OuBTrBAFQofq8c21SI+Lb9zK7e7tdVw64YSrxkcDraqpNVmWhBsyetJ4tda8Lgbj0GLhtPRALRZRrz/YeQrJAj2+7gelJadlsxqe6OnkJfnNqKu5SrED1lPdjn44DijFxHGYaTl/ZKtOWwws5wng65VkAzMS1WeEG1Jgxn+9b+rM51hnMDhHcgTRYojR4UcGrKMCZLheXOLlATIQkISrra6sfoCXHy+0RHRlovpkDiWufOlHKOIepKdhLiwTYufHZBwYZoTrShfK1sNuCRi8uBlTBU7ok0d2OCAvdhqXrQjcrC0qZoeCznNC67L9P65+u+eUvCm2NEgCCNm4JfaIQl2hW8VKS4xf/6CmOMcaGU1LArVPS3g928xN5HPQN0GpqT3gAwBrKIiXelHGU5P+uq6o3jXE2kPRki3kq71fQvi6X/q5JgdB6HiuPgT+U/7FFg2Vms8kBqUNdpm+RmZRpOvtNGnzAWWpv8yaP7/8Tha5iD6nmZcjpcOA8nOIiD0Gwc+qsBd7rS2QbI+TuiJs2BzsCG3gTQD9W/BXhnWZIfTK66e1aNZzXDBNZO741iun7D7B49SjWYHfqGtpWMOj0vpIkicf9Ud8BBUmfx4g0ieh5aywJVU3TwrJJOsVW4hQhw/5EULbhCWKl+EoO/XS63YUWleD2876zZGtvlufkeX1zuGPNnyUGY/NxYEt1ShMQg2dgvBrDwTjQSFFj/pj2CGCcbAQ7nDcqws7iwBSVVLkxYzS6uaOh189rLfWHcd0GrE/1ObtMNmndbTN9cPDxTdghA4rcnoshblhIi/zU6gcMQuoCQoP14E/UjMIoIKPG/vWM2GyBxFpO0FgCY9NRmL4VumhG9zctK7hRR/C+7H1FhAhq6ds+i404/LrwyRHv35ShOz76OwFjpJMKNM1adydRvw4i6VEueReGC5Vxzz
 ijKoX2Me
 //Gr9GTmbP3bYtenKRCaQHGrfCkjt7lii4LfTWQnkgCD8ByEmAxgIb91EDG+REI8bxKpXYA6h9VH19GcHiIcJPSTsMGNGsJVUAfTVylclb2QDgfYCN69Zei5kUe/u8bSgVH3sot64kaL4HqWHVWCP5I3LMlHHt82Fjq2+uavBd9U4PWqMtlwS0vX/fxXwQmvrsFcRiB3r2z+Y7BI3yoIy0Pwy++yWIayzqkrSI3dVtOdY7sw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When users set probe weights, they are interested in the data
attributes.  Not necessarily they are interested in data access
patterns.  Disable the data access monitoring in the case.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9bb884ab135ec..ad0f28469e633 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3714,17 +3714,18 @@ static int kdamond_fn(void *data)
 		unsigned long next_aggregation_sis = ctx->next_aggregation_sis;
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
+		bool access_check_disabled = damon_has_probe_weights(ctx);
 
 		if (kdamond_wait_activation(ctx))
 			break;
 
-		if (ctx->ops.prepare_access_checks)
+		if (!access_check_disabled && ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
 
-		if (ctx->ops.check_accesses)
+		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
 			ctx->ops.apply_probes(ctx, false, false);
-- 
2.47.3

