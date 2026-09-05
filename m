Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A991EC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 20:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C066B00A7; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCBAC6B00AA; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8766B009F; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FDA36B00A5
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1630120403
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:26:46 +0000 (UTC)
X-FDA: 85180842012.01.A8FCCC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6A03020002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:26:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aX53b0wQ;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788640005;
	b=xA95jH3c7bimum7Ph7C28EWGmf+cqm98bPGYr29/SDdrRm/xzgnuUmILnsjbhfaagCX+CP
	rp3sXm2LtjIH9Cebsi0iaOie2Z430q5XwkLgu+bcY2d/EAQAKIm3VxlhT49zoYsb/KGo4Y
	UWobcTOYmg7Ntj5Cr6Hv3DSIuoE+SJY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788640005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEjB5+SmYpe1jV4B6kvt1MmnXfzrPfDtBLhTiuYoc8Q=;
	b=DKyJxVTVZfejP8WNaDupAODi6rAZWKL51biCQ2c6MT27KLtSURzhbQf37wfHBZ5Rd2Zz65
	8NbQs9xI7PWl9HVanDJ9gPqtTUZmlhuEGgMTtS71z3L1bynU2S9o1falZcmhrlybVONfJG
	y4uwxh2LfDZqCNNZosv8GZCNKH5q7/k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aX53b0wQ;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBFF642E9C;
	Sat,  5 Sep 2026 20:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF641F00A3E;
	Sat,  5 Sep 2026 20:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788640003;
	bh=jEjB5+SmYpe1jV4B6kvt1MmnXfzrPfDtBLhTiuYoc8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aX53b0wQlWmkYH33AjzoghCYSwYeNkKyLh2Cp0TVS8FyKpcH1FzAdekysPBs664Pr
	 Z+xxdn25A/jB8F3TT0bdqFB9LSVjOtrfTy6XrImNMNCZ6IpoazR68QQKItXFw1jy2T
	 DYNy39vjaVZY3RrVHkcXknODXSG7EnrDOEfO4dZw8joN8MCIExapAX7a/CzVw5/cwi
	 BEuttzVFQN6eRUtWmbdB7BmWTUKMUbHaBUKHfsMEf7cN2RN7s7ZeByqk4o3APXbG6j
	 +io0Su9wnO0j99Mao0ugtSJidQZ2JCMHWyQg9VX/TAGQKSKsKB+rEFoCCJp5QMLyS5
	 ge4yG90ZNSZaQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/5] mm/damon/vaddr: support prep_probes
Date: Sat,  5 Sep 2026 13:26:23 -0700
Message-ID: <20260905202634.88102-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260905202634.88102-1-sj@kernel.org>
References: <20260905202634.88102-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6A03020002
X-Stat-Signature: h8i1uzznd63digty5mwndn5pktozu7hb
X-HE-Tag: 1788640005-615791
X-HE-Meta: U2FsdGVkX1+a5kg0f/KVf8uE8KJ1BdZJak71jKvPu0MmcynwMZPBXkQtGgC4KJwr/0w3RHzvID+YYj9hethqDjOJktbvJeIZXOJaobUfmrgF3vM7pjLu6gasDyPETRfgqU85pLuOQAE7Y1pKszgP0VRwCsU0Oybz0g78sfCM6+4N9kURu13S3M/9/zaFScLTX5eUXv9Q0R8cugi7aJ2EiKL1szgisreym+XpOU1tVxz0hHw1nGuAkUM9IKCAeK6p0WwjEATAQ0wKXbs+VxbSsSWfvZvv8tEgNykBVgDnKdo65sr29rstraf2eP2p15uioJhBgTCw3v4WUw48iUAO7pOvUgVc0CCe+j4VVFAujz/yDyW2ktaWn4czJ7utBUy82ZW8kiVINb9WtHmLsLyG0WryWoRPgNti0seIOhcskzuRmMPUuAA+vYSYnPq0345rzzMHCjSuVYriPHefdmn0LY3KAxYRTAR1J2PO+jgXLdGPWVJF64Vxdvc8VFefAwxqkhZbPH+/pEpQBVaRA0aDdmn+eza9tBKbcwdCAo1/rM5oVZWxjXyHtmHmdis5FgluQgnwvax992Fu2GNBvNQHDmZmH6hCoHmnT5ewa7iQUZ+BYEwAHcixnaZhOh+sWKtnz6oTIiGr99uJNaZYchLnYerr/d2IZgDQ2tkwFgbMQBYH90PfnCBBlECcHlrFHSs5MTbVS8AbpECOZjk1WdsrULnJy7Ywl6oOTGwzL+g6H6EjyFCfIrX778IWh+/Gsq8BS4iEBeYoKmm6FTrB0C6i61eljK/VuldRDW8kLF0ZW9+vmYoVCWqY4kS0YfM778nE2AyOGMVQP+4UQWfWp2IDNI6YzOFFqtKPRmrPUdXnockohuHRi+szeQSsy7dIZoAqgaPpcCOcerIh5B38XPeudhraegyHQlfYyoG35DZ0jgykFoDFmZQaujVS36yoW0lL44ry+JlJEueY5Zx1pps
 M/JhwMXR
 DxJ5+mdUOry5PRNnwUaU8JTa4ADx0fdvBkEkS1PcAwg+K+x/r/J3EXDheIPX8hqiREvtNygdcNcr/bzJDaetWZrB0x/OHXNCDxLdCBWMThcWyGVEdtBtzo5G5W17xChGLlrOglE4+/rZpHd5As1fWTPWNwdAAG8LnKpqroJ1YTnbgqnBVTisewVuIlGzY/aQimlQr5R7Dzd13o++E26a6FIWf4r6Y++cXE4vR0EZMzlWrY3MdTwby6bM68m1FoLAaWSNLMqgztO+5IPFrmTrCSoB8ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON virtual address space operation set (vaddr) is not supporting
prep_probes.  Add the support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index af9e1b82454cc..20f4784f17817 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -483,6 +483,45 @@ static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
 	return max_nr_accesses;
 }
 
+static void damon_va_prep_probe_region(struct damon_ctx *ctx,
+		struct mm_struct *mm, struct damon_region *r,
+		struct damon_probe *probe)
+{
+	struct damon_prep *p;
+
+	damon_for_each_prep(p, probe) {
+		switch (p->action) {
+		case DAMON_PREP_SET_PGIDLE:
+			damon_va_mkold(mm, r->sampling_addr);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void damon_va_prep_probes(struct damon_ctx *ctx, bool set_samples)
+{
+	struct damon_target *t;
+	struct mm_struct *mm;
+	struct damon_region *r;
+	struct damon_probe *p;
+
+	damon_for_each_target(t, ctx) {
+		mm = damon_get_mm(t);
+		if (!mm)
+			continue;
+		damon_for_each_region(r, t) {
+			if (set_samples)
+				r->sampling_addr = damon_rand(ctx, r->ar.start,
+						r->ar.end);
+			damon_for_each_probe(p, ctx)
+				damon_va_prep_probe_region(ctx, mm, r, p);
+		}
+		mmput(mm);
+	}
+}
+
 static bool damos_va_filter_young_match(struct damos_filter *filter,
 		struct folio *folio, struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, pmd_t *pmdp)
@@ -911,6 +950,7 @@ static int __init damon_va_initcall(void)
 		.update = damon_va_update,
 		.prepare_access_checks = damon_va_prepare_access_checks,
 		.check_accesses = damon_va_check_accesses,
+		.prep_probes = damon_va_prep_probes,
 		.target_valid = damon_va_target_valid,
 		.cleanup_target = damon_va_cleanup_target,
 		.apply_scheme = damon_va_apply_scheme,
-- 
2.47.3

