Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C899C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4156B00A0; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13E296B00A1; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9E76B009E; Sat, 25 Jul 2026 17:02:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B28496B0098
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FD331403BA
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:40 +0000 (UTC)
X-FDA: 85028522880.23.68977ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 726B440005
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zh2Tq3rz;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJj1wPDvg7DvY7LzgO/Bh4Zqj5IQYFAr5WffY+jOQ6A=;
	b=kd23AEQgk8Q2jv5HJgxnwMCWxzvGkWNk/WDay18JB1WQ6wZmgpV3To0lKi37OKwZS4H8zv
	Kp1snwLJMeLstrCUGwLgFBtVfLlspMsr2M33dtej9V1QQ0PXiSRsND9dvzpwTGXMY8qKaL
	NBFbO/BvQ7UD2ZFUKDiL/gJwxGO2AKA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zh2Tq3rz;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013358;
	b=RdBpz6Jt4q/KZX0b7PZ18Kj704XbMfM2wS1lneyu7HROxTBBjQ+HBL6sXuQHKsUfWInntH
	cX2wqZy9vjySgIy/q1IXIbVP15kD6Httd2lTQsf8CmLU7/jlIgVBoFFdfCrsv2wmnwWoUH
	SJi32AOUto4l+d6DZ+QMi7eDwvw3jzE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 839A840B61;
	Sat, 25 Jul 2026 21:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409271F000E9;
	Sat, 25 Jul 2026 21:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013357;
	bh=wJj1wPDvg7DvY7LzgO/Bh4Zqj5IQYFAr5WffY+jOQ6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zh2Tq3rz/06YoVGt4cPFRGuDjLH7APG0ktpHglvXaI3J9iLvEGGSB7CIIVjw2o2+H
	 Vao9eN+dElnkP9QdIUVeCe3cHhw3vwioQH7kJ6v6TWJ3uC2pTaVPdb5VF8/BtFGTce
	 nlPrabnb2QJaQOi2EXASiO8upMyWzlIELo14xOVc9OpbUB6FRc7jkrWHYRkBSwBa/D
	 X/4gbFXU0OwzXhQtoofXWJfJ7nO3oWXxvbsz7qaYnRXlOqx2awip2aXZPOMGzobcHN
	 c3lsnGSCb++sEwfGJcaG0Hso25MMtmP3HQ2SdcZ3S8DTbighWfZElSGzZ5Y7NALNFt
	 ZXUDP1qzyZA2w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 08/17] mm/damon/paddr: support damon_prep
Date: Sat, 25 Jul 2026 14:02:12 -0700
Message-ID: <20260725210225.129944-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 726B440005
X-Stat-Signature: kh1zbf4jc6yfqd5b3kn5g7mypn884x6i
X-HE-Tag: 1785013358-352256
X-HE-Meta: U2FsdGVkX19AvXP/LFG9Ap3mWyIvmL6KVLjt9DuN7SBRIkyqhRO4zWEkaj6HOHPKIgVrn3ChQv3QRD7kJhbY20k31GZ/2EzhCgpu/e34d9WiuVfCYC8Zb7P83IAcIGPBmZgznqrf8leUMeki7hftoGOawBrJ22bBBX7VTFvHEJzuXcBU2ZsbdIcGV1p71gFUh4F8nKYze3uAMBvqFeTOUA1woxkwh4sPQ4bwPLMfUciE1rm5uUJsmYj01COrwe2wpimarVrJWzpRBa0RwfsKZ4mB6BTRFJVbbVMgjYNUJ9XsDpdNYhB57qsB4XGldc18UBtcAV/Unr2Hd/4YC//tMjHKsDGooHvQZ2dFKUqVE19AqUs8/KATZOTOv5zBOk+ALnXE2sytLHFLzEdHSqRvzNE4Gj81c0GupvPWmUrbLLYVVxI9qlf702kyXSOJ1Ss7fzmiifjB5dfzHeyF2b043f6A9ZRNLthrKTAdJXi308hhZtAPK9d9qfPrDZ08xBJ/7t7Ezc2K0TYf7IUzjXUtX4+u0LTmx9qRc20K393GdFyaTexCGvsNOOxR8pBPF1tHZB5VPeUWls8uMn/TPzvRI9nRu9m9yQHZKxUqaaG8Hra+Y5fqV6PJmjEkqESmJ4dIHUHaZq6u36NwdPvRK3P5/KxEH/Wazbf3hYfZfDIfLddIKNs//6xeFR4Duhl9lLFCPRqGqpBgGOW85ez07wNnKDiLYlieFONauktm9zAiGSvxnen2lQW74srZE6TnMxtdH6aNq63F+0bw3LGOTI4QjHFIhT3rP/qMZKpqZ1ZVmBb4fr78wiUTyIt9w1ijLE59I4JUPcfIEDHnoqwRkoighPd83/sk3DlUZo8GYfTMMDlh1SN1e9kDs/XihnCXOT+G69KpfWku92iNlWDuhWuvUbdBagHFEzb5fm11/7Hw2WQ+/d/X5Ni8zv/cihDlPpsS9im9imdsWUcIrlJsqSw
 P7CErjEJ
 MHJYYXlPVt4JlKTuPxY8futrSXFCk8Whv5UNgdtia5vLhYmV2wJibpMP/BEryfFWQPbXXmpTTcQvmKGgJeBvCFMkjoOw8nhMhIp5KqqFgENN+/rgBhhRxbYjt4F3mJT/EPzXf94QAAaAvsNlfIFAZuD2HUybzsT0tXkKGXbp/mMVoCqPu4MlUJ9mGDrlSQFsYLk4tmiQcTZNs2/4BfsauUsHTcMGUZLK44QdHRDCrhE9kQR5nhDQIUGEgNxYDDG4q2I1yU5D5Nm3UnrqBIX6e95by/g==
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
index 199de1463fa06..8d8fcd1369e56 100644
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
@@ -446,6 +480,7 @@ static int __init damon_pa_initcall(void)
 		.update = NULL,
 		.prepare_access_checks = damon_pa_prepare_access_checks,
 		.check_accesses = damon_pa_check_accesses,
+		.prep_probes = damon_pa_prep_probes,
 		.apply_probes = damon_pa_apply_probes,
 		.target_valid = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
-- 
2.47.3

