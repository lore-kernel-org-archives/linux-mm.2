Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B2D3C79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 18:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00706B008C; Sun,  6 Sep 2026 14:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8736B0095; Sun,  6 Sep 2026 14:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14B36B0092; Sun,  6 Sep 2026 14:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEB786B008C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:44:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DAB4A481A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:44:27 +0000 (UTC)
X-FDA: 85184212974.30.79A05C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A48AA1A0008
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:44:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j8NOewHF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788720265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEjB5+SmYpe1jV4B6kvt1MmnXfzrPfDtBLhTiuYoc8Q=;
	b=mevP5i5ZC94L4BOyqGBa3ctLlaEPRhZKWf0hLLPYTrGPvqOGoXp82wD5ggIvlv2yMr1eEY
	+N9bJwZGH/2m1JfkPyx8mA+GuNArF3Y/B38POzRZ6SI4sU2ooSaE5Wt0ZK/Q23yZb8uNt0
	txTBYvyGtrPbB//EMa5B4xL+pXd3Fbk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788720265;
	b=gCkBslNdaV3Spxg6tehdm2eHDjHFaOpJHmIR6nSg5gGTLA5AjOYEs+/CUH+K0ny4/e3mdV
	OUGbi3+U+mLKwv6OVohGqxk3lDUqm2K6tbHAWF21LTgkEHlvWRVQwG4rOecZRBvpB4Y7ls
	FT4jM6vwO9Hzqq4OYnBP0Z/oHpes6Zc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j8NOewHF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 426A660236;
	Sun,  6 Sep 2026 18:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F101F00A3E;
	Sun,  6 Sep 2026 18:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788720264;
	bh=jEjB5+SmYpe1jV4B6kvt1MmnXfzrPfDtBLhTiuYoc8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8NOewHFOLvGTEYMvInpqpNqWqgOutYCTrLtaJbMOQ0c6Kv+ulJX47s6aHjniDJf9
	 hGqEzySajML7VpB2LxEjY0rzYfF12PeIlBHsUtP98bth/cQDA4wWWVwrMQyXiD5+0n
	 JX/PwHr0OxVKphCAsnkjA8tFlrgC495L3qwcvg/mbvaoFQn6dE03iv10sHABYB/Pia
	 K7F2zp2RB9QZ/RrBHzvMp33QplPQHAOdtqMaAZmxz1DDmsKLcjot7sq9F5+xSBu21/
	 Jp7VEdAd8VWKYYkOaxiRjHyqPQJSEuvAwDE8bTECGzJCLPkQFXZbNQpPu9dYQzL411
	 OsnjI61STtyCg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/5] mm/damon/vaddr: support prep_probes
Date: Sun,  6 Sep 2026 11:44:11 -0700
Message-ID: <20260906184417.96621-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906184417.96621-1-sj@kernel.org>
References: <20260906184417.96621-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A48AA1A0008
X-Stat-Signature: 1twnwzby79msik4g6nojgmxeou7fn4r4
X-Rspam-User: 
X-HE-Tag: 1788720265-628287
X-HE-Meta: U2FsdGVkX1+lnjQG5rQ8itI8eZsL0Huvy50MPA7OgDe8+pIuiCZ58vsuK+4nJDdxTp/q3zkfZGldjdFgwA6KTM5DVk9DzPyCwG+5rmuFRzkcGB4n6Klhl7svIaG3mHmV+8+W5ZvFsO+nUTUFvvgCq1mhjFFvL0lZTv0/pnjtT26sOYmQEquJggAW1BWJexZiHztol7XZCFDKiP6ghNIswf/WJqz+wzU5OxJCI/3QH+sFdCibxxFGx99Qx7NTe3rn2SusJjVLy9MMEnBDK8e6iTEwckUlhURT0CgyQmJ+DGIzOu8L0SQiCuj9ksKzRIiMtglmfx9ZMHol+hErAnyWdA+02XWjedAxXZ0wGrOH3uO+ZB7xncXkFsrxW+cAXI6wSqdwsmAzgRiaUoSHmfuDQZOovllHCv09a8FDaTp1NGr+WQ8yTUq72W04+z4URMV7bnLZc/jylccGPonqxhA7y2q/GKYwWyOXmGoic5LRJnd0D+D0exXdXYLz0aKCGz73PBUhZazgqvkPHn4qrLuOuQPQA0/ycV7st5BldYijFXSWZeXNY/Yj1NMf+hJEqJUFb68Bu+msvHjpnkmxzgrUEJyoDS+Dg/de5RHLk3sUoS1/HReN+e1TGhlt8/VfApwiuV7HKdwag6LTaVkl++zeZF0UjpYkUN3e+nFDx2XUulTnngQD4URJVFN8rQQnS4WheOUqrPwt22Ypw963FcaFCr+GOi4uSrsyVyQaCwZz3Om6T8V0ZdaN+GU/puS7lRA0ZEqoGwNEup4qZn3NPv6e8r0RG4Qb2RpfGhfQMZENIqi3PK0sGcStXCeYvhclFOKd6xI+hRZ+mdeeYql4OEuzpDxu+FfFfTRJ2EuQ7NzyALvDffvxQ7gpTMqiGaIyVlHF7cBU3VnBp0rp9aNjPwq6HnG3kEMZJRhZEHqRspBzXa8lwPOqg3O2ZlfvfN+i6ndUUzVedFgWD+xO8zuJzpn
 WU2ygIKu
 zqUKuh1GGQQr0tLW6VRD3+2jpu6f3kxdm/n/P3JFQuvIOUvADlsGinDS3kIRTscQ3Nm8Uv2UXIrm8yiewE8NcEYSACWS9LTQi1jwbIhUg6RJ/ObNjfBZkiehzUIyW8g5+i+LY3uRUQmpvtvLfqkdQ2X7Zy6jBuu2DoLfbdDzj8KB9/oIVQcuiOvak2xxdFW4UAKMVOrWypv9IIH7eSZ9GXZDffGTMGZd35gCiQ2LuMn2JCFxq+MOBKh9unGFMwZPyKAY182HTHV+1q0MGnsY4I3AMjA==
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

