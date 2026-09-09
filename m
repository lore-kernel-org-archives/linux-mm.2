Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02BCCC88E41
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5FA6B00A3; Wed,  9 Sep 2026 10:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B859D6B00A5; Wed,  9 Sep 2026 10:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46B76B00A4; Wed,  9 Sep 2026 10:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2AA6B00A2
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:04:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A807FA40EC
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:04:18 +0000 (UTC)
X-FDA: 85194393396.11.DF8B56A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1416040009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:04:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bZV5HI9n;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962657;
	b=rRyu2yevu+RcaVgB8EPHGFRoFcN0+yplQ9HBENVOyu9p3/GNqstd+bMrquXP6rAQnWol7s
	xb2fvhBlmu9XJO/FbSUErAh6dqGwpUZsd2r3q8YahyOLM6+BxDTXAuMGWynZSDX6/VJlf5
	FbMBlG2SGcZE2EwqvVkA7qui903VicY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bZV5HI9n;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEjB5+SmYpe1jV4B6kvt1MmnXfzrPfDtBLhTiuYoc8Q=;
	b=WPi1v7TC3LLhj92PgvSTLNBaXmHSMXeGbACBad0FhA3sxKMd7YAKPzmTcwxopjeOVn0cRq
	lFFKAmDsR6/cfVCLODR3ODUs7Kcs1Rz6WTTvtr6rmRc2nqJLSuOGkDS0wwkLLpA43QJ9uO
	/4Kas+fHzwIbFy/wzpDqL0PnUMLc6T0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BDC26022D;
	Wed,  9 Sep 2026 14:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C98E1F00A3E;
	Wed,  9 Sep 2026 14:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962656;
	bh=jEjB5+SmYpe1jV4B6kvt1MmnXfzrPfDtBLhTiuYoc8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZV5HI9ni1qoer7WyAzgqHcmDNXDCkP6yMaAYv82nIdNvytJfea+tswZdYH/n1kO3
	 xH7HiXbus+CJ24iXvAlS7zz0lwENIoJbFTO+7k8wHFv0svv2VFMyngh0Tua+XCQtpB
	 5MUrRIVoRkGncsFxs8GUMJy3gm0VfYD50LMM4KPxP9foxpkK2dCzb9KzieqYur3UTl
	 XPZ00hyL15YOnYCbN9O6hw2aKEafU+JExRoW8OiygrC51XPE5g2gM35psx4KhXauEz
	 q6Vsff2H6UqTxk+kbF0srjTUBtktHrEQJtd1lL1q2FnsG9HARhT4ubEgpeHNoePYL5
	 NZMGkA26dKDDg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH REPOST 1/5] mm/damon/vaddr: support prep_probes
Date: Wed,  9 Sep 2026 07:04:03 -0700
Message-ID: <20260909140408.104699-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909140408.104699-1-sj@kernel.org>
References: <20260909140408.104699-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1416040009
X-Rspam-User: 
X-Stat-Signature: rsbkw7pqw9xtkefjaxibg3ifcku1kkmx
X-HE-Tag: 1788962656-167991
X-HE-Meta: U2FsdGVkX19ZmOlpIz90Sg7hZK+VB6svydESeAexGTGZXIEhRSexY2hHqO6WjyCUxqjQJyReL86/HCSCLJCtvxFaO4WyRZ5r9F00rAwGl9MC8oaAwy3p8V8H4zJtOyflPTm869i+cXqa2EGCxwCxQ3L0c0sWvCuUbN6bwwpLX8ZeojRf9PBMj/1ERwamdau1GV6dqhzMq6dFlt+xU8BKHet35GB/KYKBUr90LPOgK107SfxuHzT3NzzqohVYCP07+mlxsPoeKtzNLlvyiUX3tSJKWrjnGtrm/0U8FvQeHDtE8UW7Cly+SUkc1w+oHemX9BUvEj4nKfvn4Sv23NVWIJt/9qF/YEWHb1DzGYbkG9jY0sXqjIGEaFtNwFQx+FLyN4/r/1u+ITvq5UWabBrxu3+hz4G2UWT9JL2HPt9b8vfoxCvh0itBbCPinzlrPOW634a2TSL+xVNSNy6+APXEsP90Y8YUslurspzZ0OBw6IecGHlK4WPFppbUisF929MnjuAi6IKOu8asSAXcKFfBs9OE97qLQiJX2dIi3Dm279tpD6P3fzm3yByTcYuPNOUqt1P2LOrwrP2/inQZhWrtRh9WhkdkOCUd+pFgz7AZUP+GMjH+aw5Xp48E7st3G3xdVBKrp4tBtFErk9uXyLiNkxf4Zo300fhf+umUsQawLNquBh+3H7pF3Idv0bhCQ3fqCCIG73ZIhNgeXkc97rG9eKUIVy9/9uvDvtUfpEIltfucLno2NJ2MsNfm6hI3523xPv5HLA7aHngGqbiCIUAhzyn7pupDGYIuq9mtf4+49yjJsldVKbv9d3iuJi5vL67LXs7+wQbSr7fDSTZTWzoSc0krD1Vt3lH4IIt3RzvEoIY7CRJuZQY1Q8P/WLyAZercEsb6R0DN3bFAL16rd182ua7TYwH1PGm3iYm03ZZp0vfLIam6S4icaD+MC5peEzAviP7Vv6fAu+kX7mi2Bju
 CEzszndm
 DWcD256uL7kV9nm22fW3M4CrFcgi3r9GSF7Yvm5FxiSt8hJhesV8EOwyMseN9S8LhpxLx3rS+2eTlOzCXvbbqktRfh02F0bU2BPESijppDDkNKpi3+POUw8WsbEL6FkMcGpfU/ezslKGEBkXIRoFiMhwYeuboAKPTiyJr4bXHjKBU4soyTLXHcFlOSY184gjSCB/W9sE1BgQnI7fj+VD5iMtl9ctWF749T9fKv/MLqUi8A8L4n826pZTIO+y+qNyb940/ChjyPPgpzRVACM44Op4Iag==
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

