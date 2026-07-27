Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61767C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641CB6B0095; Mon, 27 Jul 2026 10:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618626B00A0; Mon, 27 Jul 2026 10:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0DA6B00A1; Mon, 27 Jul 2026 10:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 243626B00A0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC5018075D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:37 +0000 (UTC)
X-FDA: 85034812674.09.7822C2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 30AD21C000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EplgybDG;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLFzt3EcCEm4IM9i5M5f2Ly9bLRqeWPD/3m4Jo0md2U=;
	b=g6NWuXZKm0hDdkIBrT7gQ2kzgOMs/ts8Sz/+H+ZO+Wo+C2YojEZbU2kmEJVSHJ4E/urm/S
	pJYxpnfg4G24slieYEnGZMO/QW5KaUik9AnzDUa9OhBByDtBCXZB11z4WOBM7iZGvTRKI7
	tSdewG6945xo3sHMYpaeLk5Zaawexqk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163116;
	b=P/vwZDzv56qIZe6lHtJAHylbuBKJHQil0NKj19f8zhZYzRj+luPpQxhaxyeOJkt1QPwdQz
	iQEn9X8XyebacjKtV4pOwHra2nmzAsEWREx6TL/IPoaw0BpEtnCc7VJVqh3B5FJaZQ3JNC
	+LM8He4e/+v6KsCuY1ORDw71xpJjVCo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EplgybDG;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FE274044C;
	Mon, 27 Jul 2026 14:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A051F00ACF;
	Mon, 27 Jul 2026 14:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163115;
	bh=dLFzt3EcCEm4IM9i5M5f2Ly9bLRqeWPD/3m4Jo0md2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EplgybDG2pjc7qULp8NAbQU4eO6g01ccQc6WIq6Wsvc3TpeY8z8eRZEHz8VAMw09L
	 CzXyuS7nU4FT6414bVzvUqJuWb5q8XedVv7flNhuaq7VR+FHtpR52LdZkHg1+lDuJr
	 IFZjjTnPqcJ1+DMwgNL9T3RJE45r/PRA40VWywnOxE8l8KW+oszHGih4M4kIS23zxz
	 nWEQWwy2FhGoftMh8NfH7ia1zCK4/uTgbtJazAGHyUZOJ0cF0aoJAsF0G2Pi1Xulx/
	 mMqo9Kq4zT4XQDXfP5zkjE2NJ69td7ShaQz0A4mCJ7kMueJBsPbMyq7Rho0siOnGLN
	 5W6IaRYF2GnUg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 08/17] mm/damon/paddr: support damon_prep
Date: Mon, 27 Jul 2026 07:38:17 -0700
Message-ID: <20260727143829.86236-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 30AD21C000A
X-Stat-Signature: 871qx5q5kr8xybksk4u7xf9p8biitexu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785163116-997500
X-HE-Meta: U2FsdGVkX19XsUyqyTuZa5+A+Y3stx20RYYctConS8ZZvEyN9bC/1bYk80PlcrQJfpltM5rZgIPFE1ddKtpzEJplNFlZzbWSSyifwC83tgk5IFVGfRp8Kvi+RlJ5DvUg7bsVmEYhhDiESLGOZkKvxiMHDoGu1EAS0psKsDTjqQWPKC0QFciuuZPPSNMEcaXP1AIGfssHdvyYFfBTjanosKtr7OPjDo++W4R7iuXGWxUJDIkLv1EpIH9CzYAlUBoszVx1JrmajDTBdJJ/xUaNs+N6QXttv9w4iGNDeyHNXi2qz3gekyumz3Ok9zDjv0oKEhvYQch6uNzi6HxFRKHi+p0VPL9RJ/k/vgNC77LsdDOYg4Ax/2/rBvmTEjnSVdlbTgbs+YP2p4fZ1sDjzTheTv/iy3H0DycxIpSe35dBVztfzM/VRqIHSxBnzGCxke8ZW07S6DRKIRO80JCO4HllqyoaAUYuPcQQ6sObJYUEuP+casWx9lyw2qGYaOImxbNOTFRsfex04/XptBbeyEqvRcOirwSRQGGmixrlpl3D23TQG4kDWb/WJE57MrwKGLm11LGvEbljRESOBiNZVtFyWCL4+7aA1D7brruhw8ZvRSf6+5GirWKFbyFKaSJEI0HM04RLkhi6yVuD0K/F3YGqvvvkVS+d1FpbIFgwxokBRb5pxmXn9tP0lpVY0l88Mff/pniAUEVP5i/bMnccSnxlBk60lZJAJH5k/Ohh5qO/VZWUZ0hRAK3u5US6LYqOSvlbF4zsaGr4SbMmOTi8GtqO6vpPsFPpK3oUiJNMrDNj6KTkyuN3GBj1QZAVfalMLK6eHhZLm5Q6LWwiCrk0osaIa7bdGBR7rAxR4CjKn2dRwg2xVlB6Lxu6His+gkZIsA0JRrgJxYh8eg0Ya/qARIBSEYadfhfEIsrbF7Dy07te74Qi6numFS7cF4ZSjRBEgjoAU11PCfWxe24+IkTdqfb
 731NO9LW
 Fk6wAtESxVL/ay5f7Z+NDsMKZvMfG3Hse5w8MFUBDbnyCSIwDYpOhPRspZiSm2jOSvWdq9TQHAu5RQd+pUmaqJShAMWPO809KqudML1e7Fk1BAVzo4V4iJmbvJsmKW6wuj7szPpOhYGb8N/pXO00zmdxrw13oR3ffMie9IjGcmmxnaLHaDmgCdwVMCcXZSHXuoAltDEHLMlNrm4HveoxJ2Ns+JYs3iv2OCLx63n0OeoEzILELpm6SRpVrvFQbYZ10L1ADxd9WAxDyRWyksIiOincnjw==
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
index 5b307dcbb2a50..8fb71183b76c0 100644
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

