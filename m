Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F92C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70DC36B00A1; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE526B00A2; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585B06B00A4; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 121FA6B00A1
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C2621402EE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:05 +0000 (UTC)
X-FDA: 84970969650.14.9574DA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0CBBD40006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QSfwDQr5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wWo/baeB/+xecwr1CR8NpXyICuKLRcYoU7QPq7PEYE0=;
	b=frYzb3spV0p8dLR54uPcGOr1OptecdYJFCHeAi9YwCqLSZNleC3IoVj/q+JN9qN/d2Q9wQ
	oiaXBKzfmOnF8rLCP7A4pr0EGlFpaOJ8gO40ejMXZ8qd2ySF2JgbDYeJyjuncetrRysrMs
	9qyjKwp7lHNgV08GQa5jb2XO+n2mh+8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QSfwDQr5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643044;
	b=uc42gzN90M96lLfZ+g4cz01Ld9Wul9YIIrgh6UPzwyDTZpl34n6J9cvZMAQFJDQEcuI6FR
	iWcaXfzeowgqX4n0ZmwrP7zDupk/Z1s3Iu44QxtXK3UV1hQxgZSV+KWHLBly/LvLHa95UM
	1Ag1z+01wQuDpRdXatnD2o7uStc17w8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D58A4512B;
	Fri, 10 Jul 2026 00:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF5C1F00ACF;
	Fri, 10 Jul 2026 00:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643043;
	bh=wWo/baeB/+xecwr1CR8NpXyICuKLRcYoU7QPq7PEYE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSfwDQr53AV4/EKb/wGJwj/MufwDBv/yIio9QP/m2187gi7PhPTnD/jorMa9hkoPZ
	 kNDtSw643ahP8tjf5m5KSTtf9s1Ig1OEIe0C11EX91NuFhtF6Go9eQVxNY3+lMnemS
	 68s6UE0Kt15qf0cHOtg0AwDyiQba5SJ94qpcu7i+2hskvDOu1v5grnUFqpV+uhiagP
	 TxAlldIBOWILdk1yJooULBJcPTMr74S2HNPvcpEe7nBZBe7pHBNx+ChQpNWfpk2xvf
	 O2bvs3i15bzIy9c3TyF7CVoJLovHu5EKBCgIgaGAwrXJY9n676bnBPXPaeIy2mgh5N
	 zWpAur5V9iveA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 14/19] mm/damon/core: get merge threshold from probe hits when weights are set
Date: Thu,  9 Jul 2026 17:23:40 -0700
Message-ID: <20260710002349.111414-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0CBBD40006
X-Stat-Signature: ufgcpm4bbscw41tj7jwqn1ozwyeffsfp
X-HE-Tag: 1783643043-650569
X-HE-Meta: U2FsdGVkX18gok2CzuPWb2ECb8XXc132oc2DAHe+P0EqEMvhGzBHDoGgcGZtFJktPIvcwKnPwRwT49DV1fwFXgYzqyclZSf//7sWOIf7gqV28KF1nESeuI0xP+e+bYXu+vDZeafPBt9UItYfd+4rqwbdXVs4/gxejb0M8/4BZNumm3OlJEmq5Bzp/fXfGe6Nm+blL5BP4jCZX9MTyjJoFOXHQNDJVFcGQVyleSYbpr/AFNBEK4W44RgP/qyriHCvR/KCn7+PgxRKy0Oe1KSqY1BZUZteA+P3Gmaw3oJvOkU8aridlDAP2fN/1O9n9PBerGsll+bT/QxxpC6+5HuihRolvNpyyAuZRw+EQBsYae5cY/1yHeOsSu6bGlBtBNjh1Udm59W3Ms5tFyI6CJcNIxDW55VRdiYdxd29oM8c4EpCUiam2P0/D9727AdrakGE/7yU2+eAIDT14XUSTdPerlDbBcH/Bp6Sck+bMM8SwK334ZCocLDwbk1h1ij2jG7rPGi4Wed10c0b5VrROl0rVdhCoNlrzrzW8IodGWnxFGN4h9l55jU8CZV9QQiT/olMWtZz2Fvs9tS97oIVrlA78mRePuGp//unPO0WsbXgDAIxSWrf6vkEQlIqFuc/UsRN/68LREsRl0V5g4GLFspPoiN1mvvH4uCB9HSS0/JEp/VYGeGG+SvmY+mzQXVRyxmOh0ModVySO4sxeYMsR4b87cRkDE5NOSWnUHu5b5rkpGEknNBRsh+HJaFVsttYdi99ypZaZFt+Ze26RzlABBeuDnG/BbQbjdoOZg7nMkqsi+EiCyikCKCcfIjEgsnN0DHkSOdLZjtGNS9Ef2dWI9ZYognyKqSkLNkW6DranSkvgd9OGfJ6i1NMgQHdjpBkjUyTlKXsqyUynIAavxKsPbtQrth+sttCGv6pl0Q7VChyPGfIh+q0Ghv/P5VDRsKqfmrfNN6b8JxKrQYm1PvZMbz
 aHdLiVuN
 ESKJBc0FBMofVPgFJfhAHUZpJbOGgGE0hwlYwdizwVlpqJw3E1WIeblEtjvrZ9qkuFYOzGaTCoQDU7gB/9/w50xBlgkMfOCWhIiptGXv8MPU23WuCS3nB7vzyIrUY4q9GYlOUH4rdsmi3AaTffuV+kPi9MEbpYuZhEj0s9XJmiL4AUNPJ9INPYpJwXMcT9yaVq5iYeh5oSeoOL8LoWUdUjMGvlE4h5kvpf5nGhUCI/V7dwm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, DAMON merges regions based on their probe
hits weighted sum.  But the merge threshold is calculated based on the
access frequency.  Update it to retrieve the maximum probe hits weighted
sum in the snapshot from apply_probes() ops callback, and generate the
threshold based on it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f7782c69037da..91964336ce31e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3763,7 +3763,8 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
-		unsigned int max_merge_score = 0;
+		unsigned int max_merge_score = 0, max_wsum;
+		bool get_max_wsum;
 
 		if (kdamond_wait_activation(ctx))
 			break;
@@ -3776,9 +3777,18 @@ static int kdamond_fn(void *data)
 
 		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_merge_score = ctx->ops.check_accesses(ctx);
-		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx, access_check_disabled,
-					false);
+		if (ctx->ops.apply_probes) {
+			if (time_after_eq(ctx->passed_sample_intervals,
+						next_aggregation_sis) &&
+					access_check_disabled)
+				get_max_wsum = true;
+			else
+				get_max_wsum = false;
+			max_wsum = ctx->ops.apply_probes(ctx,
+					access_check_disabled, get_max_wsum);
+			if (get_max_wsum)
+				max_merge_score = max_wsum;
+		}
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

