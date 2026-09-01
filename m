Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF88C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69156B00EE; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF256B00F5; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CEDA6B00F6; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1E66B00F0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9DCAB1602B3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:30 +0000 (UTC)
X-FDA: 85163927100.30.909E9C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 14FAF20002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mdDh3UTq;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237269;
	b=urWu520mihrXwQC2hQD2zjdEZaxsN38ndj8xBO2qz7Jl3e1Hx0WkHnUA4V4Yuqrjr1e8my
	SMJ+KUgddBPfZ0jyXBGhszOu9q51JdbyKZAy72UiH4tne1PqmEKPmQZcvLU0qv+MjlXYAU
	Bm959txtvVncBNFFCT0qxpmsFsMvgqc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mdDh3UTq;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpyWxBrGaST77vm6YyG0Qbwcf9E6DAqPTZr9W1qgAUU=;
	b=CZ1cc89ky/xFFDm+4izO8d95fV7uilTjZvt7reaVhICUZNCWjUFhXD5rNSsWwHAiXVp2+m
	OvUDYme6gelCWMO9+48In+b/93N0DnKfQtgIfbc9EzdDBOdZ5f/BbSV0WhgtAwHQmQttTi
	CIwoTXUw3xClx+qu7tuHdASorzPk+uw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7436602C5;
	Tue,  1 Sep 2026 04:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382991F00ACA;
	Tue,  1 Sep 2026 04:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237268;
	bh=OpyWxBrGaST77vm6YyG0Qbwcf9E6DAqPTZr9W1qgAUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdDh3UTqfrDhR7uBGv/FI05EnOJmHfyawvr+M1N0YN28ZIXhcm6e4UmmUvwN6/sIS
	 RK79G41zR+Gqh0QpHT9MGwojDAmVH6kMk3iOnupR9pMbwVG+HgkOEEQLOtRrZDhO6r
	 aVes3UwJfL8tWIEdfx5Cs02LfPJqS5XjJj34WvuIUOJfFIUfP1U/q7MGpO1NJu+8CB
	 2ozfeuYy2ZIZj/CGgtz9erURMlYZGsZQWF7B6yXb5avGCnrvjtBW55UjP7N8Z6hPdO
	 vurrv/20EULnHR1IHl5KqzYnWGgcwe1DHyi9t+cXx98zAi3wU4ENrsBS35FebqHjr5
	 +Q/IOKB2YsiRA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/17] mm/damon/paddr: support damon_prep
Date: Mon, 31 Aug 2026 21:34:04 -0700
Message-ID: <20260901043417.2165-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 14FAF20002
X-Stat-Signature: sjnee9irufg1wyxm663tfjabboef3358
X-HE-Tag: 1788237268-205512
X-HE-Meta: U2FsdGVkX1+1v1PxM4Il+B+IPgOtmyauJFCeRk1zfQ309ufhJ18xjkX0ODXyM5nCu3U3PApJV4lyc1pTcHZyB85wGRcVgxWYdS9VDewqJiqJWhxTWJXIFWOMLF7JS9jwUv67L4sQTQIqkiBp7Dsr9863JMXkshTyrxLIXoi+IZ5f1kh1LD65dlpIjYoj+TQ8Df6td15Pl5hJxjNV8G8uyk6cBJrtg6Vt5OctJxJtXOFrHQeJq/MrKuOUxMnxqTlFI1SuW/hoJtq46tGfZA/7jlIYMNDnMa633nCPm30NyyFRrEAiD69SSsJU0JfUc7ac6WxBk0fZJYuh8uAWpDXZ+BwDbDKeVbpHZ8IURYVJp1RASSQuP1NjX/TkY7djXIeKdcQcVxXzqzoHwG5yduZn7zkYGjrakhXNVPeRex0zvNmAIZw7J2eAXYs4jg9cjuBZUxrGW8pOEX5qjCfkvy7xTnAzf2jabxC8PRb+llh/uYzO7PZSXF3GWGvkZo3ODf2mrdGQqf16IVH99YiNZ/sbsgetGugragf9io85eM4bFeqZLcJlgdqgrf5FBkPaGwnNDkM3vpV7hvXndMlcCu22gabQBBaNtZj/HeBCl23i1SWBdCsg+yI3DVQy7DmCgl/QYDfxAEP7J+BECRxKoL1lchbPpOg/RhL2cLO0OVxITn+7zH7lRUEnhT7MT1BK9GOMBit//9VmAuGIF6t+yaMMdvnrkkwaD/fGIeuQm+lS2IurvnSu6+gjkm+1PRe0tVJv75WWgygDguRIHqMnKgnWBxQ5afz4b7JopRHS8Odpuk/7uq8n8+DiL9l7r30Lt7xrYH0JXiuOcpfTBioJdG5NC15qqdnjzwJhGFtSON4+9VmTbTHnz93zBAXNbvcMx5PEsCDgI6R39qOjfyxz68eq8j7fWxBtg/v6omL2HfzmUnRWOiqM8MDGaEAj2LXOsdc6qs1nIZAQ2/g0pxeizvX
 0v003Ue+
 ORCB1G92xCEaXTfzRpQqlGlqtRpoDzepuOi5DHXOlMscz70q3nsOfceE/+w6EyYZHEPFuccRCPgOgkSZtDzxVhBAydrdNAeUveUluRctaFxzs1Jy/F52cgziRlE4b/8zPFfKhsow+sEEyBFl/PNJdv9x004LDLhpfNJwkq6q1p9UFrjlJVjcr7iLT1+o0fuAU/q4CM+A/nIvMEJH/Gg8wlLnMrk1ITVXvN1+xtP8dSQgwjkcj62j2a0lY+ZPb0bMjTFEdMQlbS2IuiJ+RCh4zjf4Awg==
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

