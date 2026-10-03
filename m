Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5803DCA5FE6
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58146B0098; Sat,  3 Oct 2026 17:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C716B0099; Sat,  3 Oct 2026 17:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF74C6B009B; Sat,  3 Oct 2026 17:08:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45E016B0098
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:08:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90AAB1609EE
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:33 +0000 (UTC)
X-FDA: 85282553706.21.0AEB2A3
Received: from mail-yx2-f9.google.com (mail-yx2-f9.google.com [74.125.224.137])
	by imf03.hostedemail.com (Postfix) with ESMTP id AD2882000D
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FjsogRh3;
	spf=pass (imf03.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.137 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791061711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fqUlY6qim2cHCeufDeEuXDmVUcy77BBS09bM8HasmY=;
	b=ItDqV75zyojWOhisZI26bUEadtPs1kUVmu+4EVG/75zqa/lRNA8rSBh8ZtFow4Veud3zP8
	Tt3Y913b9zCtxE6LtfoWmeQWyhJ2qk9GfJvRJ9lqk0WExr/GKfNoVBgSzLEwT3FdE+OccD
	vbGXQreSAUU0NQIprR0gov7ipXDN+jE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791061711;
	b=d+HlU0YEUKzrc12BPoQCHq74VAz3eSMh2HJ99+wQGqdsz695IZIuDkzxln7x5tg7xCkMXo
	sbtFmjFK0fMTbzXxWEclxUh+JzXfFDgUGlG9Wo2o+2+k3mJSiNH5fOMu5WP2bK39Gn//Lp
	eZ2+I6wpQJdhn0+83yZk90H++I8flAM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FjsogRh3;
	spf=pass (imf03.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.137 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx2-f9.google.com with SMTP id 00721157ae682-8a242f44e2eso973727b3.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791061711; x=1791666511; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2fqUlY6qim2cHCeufDeEuXDmVUcy77BBS09bM8HasmY=;
        b=FjsogRh3eQ1FpEH5ADIsu5PIG5WedVHitXNiXIJrgD+j+vTT7KbaK3IZ3Nw5v7cofp
         kVJhxZOoCeko4QV8xWsyrdbWPbtSKuKWQU5eYgLZzSrUJwFznHOH0obOgx559ndk5zBm
         GEGeDuV7EvROC1i4oV87aeuePSWCaBY94VWeFkg0TH9EuU1PzbwEC+OPh+kAm6n98uTQ
         HQfc/+TED2LWN4o6u9tHtkt4dLK0DiIQVTP9WK94I2+OUfdVBckHqyl9Rk8DM9uOmAEV
         D1UBFEA4yYZBhbJ8VGuexOI/ehTTx7Dqn2uzdzac0pz7UEXEvmgelhKGcFyqipmiheo6
         h0RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791061711; x=1791666511;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2fqUlY6qim2cHCeufDeEuXDmVUcy77BBS09bM8HasmY=;
        b=l0MWqU/Igm/gHku8znMH18ZxEddrlinLynqW0TdUs3607aYqhpHrHFNWfEeIpHPY9E
         pg+Mvos/dnMf3TV+qjlr4d0KxwecL/LXIRCRFZed5gG2nIk+yckGWm7PcHh03w7Wdisz
         xCeKIgK0DCU5jtpmDGVMMQ925oXJE6vRCDmR2+zJnGpRvbWlqTuJ/a/nQt35yc0Z+PE2
         2y/fvj/+2N0HOQp7towsQuLRC2lQ9MDjdW4EddqxHpJZccjUeJv/oasVPzvsOA7QBM4w
         pIt874fx8RxTzks2Xb8FH0lVPQg9r7NDdk2nDHQcn59ZGexgccfU5UX3x7O1SXWnUXOs
         hCzQ==
X-Forwarded-Encrypted: i=1; AKwUvBzqLKNpiQaBQhomQSP3vvU2YGpm7Est9K02HctAZoN6jQ2g2zV6fmrm9Ki5nrhbQ5yoeXEiaOjaHQ==@kvack.org
X-Gm-Message-State: AFq9FYKcCdZUzW/6TvOCDJxExVPqRaYa9FsDr+dT9tH/3ZzOfIhOFlGN
	mvRRciW8r16ROKsLAfM2Pjuct4sZxj/Go6MqGmy0MtPUbnpGRPMj99sD0QC/j/l0WQ==
X-Gm-Gg: AYBFou2n6pa5PIAXHfinPDKaa15MI0w71o7r2eXtiGDodxV54nu7VuTOjbihTGQSt6Y
	dIu/cZoINK2IPtgHgJhTdpy1vv3caj3jMai0+CLPMnFtKLvGPAWj5gR5l6WWw4Sk0eS34raxEGg
	Hg+XimMLsPffU4kyw2oaGDOEOZDPiEeVZycEnSEk/VuObF6P81IcoTKOflHWo0g+GgCbblM/3Mi
	0Gl4+6cAYX+Wfqm6Gn5QssEDxDCwVtI7uo0uOgwgiYwyL0r6VnKfoVR0XChba5UE9vhAPlO/4KO
	YuXyHV0JAG0MIwu4k2buwcCfSTfxwakn+g8/3yQVatbwrigsRjhk1u00sKuyljoBRsQai4eHp7y
	LmSu5BCp3UKUCJVMKb5xeR15FJ5rW0UqtJsMYQO2cIXkQvCwqL/ZqtCQduwoWraxK/9aoftv0Oi
	huVCJlSTNKL03tVJZ1geSX1/Dafy6uyuG+NMQEM/mDySX2y3zB+UoU/YgSJNO1oooGHJsIQG2wT
	Hw0y3MUIdHWeGOqrSoQAb9MKfrGN4q+jZmv+vkl9qnakjCAH44YZVccFZSMcb9P4DMbbqOZHraj
	WKmIYww/wqqXIkPWdD2MDVdZ1Aey7HzRjQ==
X-Received: by 2002:a05:690c:e3ed:b0:873:17c9:afca with SMTP id 00721157ae682-8ae94c981a5mr12007377b3.29.1791061710890;
        Sat, 03 Oct 2026 14:08:30 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:550f:9551:5468:60f1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8af0d179d3bsm743537b3.40.2026.10.03.14.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 14:08:30 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sat, 03 Oct 2026 14:07:57 -0700
Subject: [RFC PATCH v3 4/9] mm/damon/ops-common: use probe-weighted score
 when probe weights are set
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-4-0f00417b41bc@gmail.com>
References: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
In-Reply-To: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, 
 Wei Xu <weixugc@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
 Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
 Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
 Kunwu Chan <kunwu.chan@linux.dev>, 
 Ravi Jonnalagadda <ravis.opensrc@gmail.com>, 
 Jonathan Cameron <jic23@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Stat-Signature: orw3a73k3n4gx9dbxik3mxatcj8fwdp6
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AD2882000D
X-HE-Tag: 1791061711-664191
X-HE-Meta: U2FsdGVkX19cE+BZeKhjxy+DORC3sS843+DtrahbdQTCuYdbfPLMsW5ecGLnzGB6YOEbqULjM+UrDaAcxj4Lp3mVlrdvRETN8hEgwiwMY8PQS5G6DhcLknm7zy7h8+DECehSXmQ641PQSkh929xx1E0utaFCiDVoCRQdiSzlVAyoXhpAjXROsRx8m7uQ2/GWqG+vsIpjaGkAyq2u2EnNmMMtvjLtiJw51e1AcYRDlWIDWlvS89YnIaw+pi1/I4dPy5Caz5UFrs2Im2qvN3kiyE+aBDUHKMszcfvW2lyTzvY9qMT2Tc7KZWpzM1YbkS4mnQ8L84112YKEKnpM3We3/ExPTkVKYD4YrBZyTgKR3qaWrZyg8Hb6u1pGwdUrsY8u8ziX0Xc4NJihrmR8HHAoWcm1m8d6Nc0YsgRorEXCfwoUraYQPHy2XkGME61QC9YOX2cWpnuWFxdLIv6g5i3sLDtyEpeVRwO4+N4BQdeyOYYfopMNP17n96gAOxbwEGm2Z8dnalQFB7uAG+HNVq6RR8cNgD/hjt4XYIrWJrtyc4Ff5dQSnkKj+1Y20aeri+WGN72ZPnsr8qOBm+f9qcXlYNGb4QIqq6d26IIPADl/EdEosdOLkUf66YpXDjB2xEZ9Te1v3Xn9FAuNSHw0jE2J3U8V2vYQfevDBtTPw21LqgVGduvb/vCmKLiigk23KhKQRe/Wk1iJNYW/AgsIgwK8RQGqjUilmqrZKIQVLrvtKgjxqCEpCdjcD9jnX/fMyqoknacDm3uZ4kMJrSYrF43iBEFBAfUyZi6LuWKjPrA3WWCKe0wdiIchiqewKP3i7O2L7nhH9gfBhD2dKcPwAD3J0BZUwiRpaAqKmx6zJ9QwBHkAGvizqDoM/+khyZFnyvOrjP8fA0R6DCfEhqTH8m9myt4av1yiCXWyycXk2g8fFI9/aCJwvbsknn0obXHX/c9oG40z9XzPcowWulqRls+
 l+jEzUj9
 bD6UbLJjcGg4tOc1/Hst9hjbeBQ/nksnDlMuwLgzybi3BhKB7euq7JyrrdFrCYA7h6t7jolrey1hJVuQKtQYNx8bd3Z/r21rqHVFEdMf1KlmojTALvBPFi5ZynzsA/VaK1DWpdSbv81L+Y3rbiG2mSRdaDHbeN4pHpZiM33Kzxsmzj8bLQdh+VfFWTfmOgcyWmjFhmct5zzRneCFt/X2vWxs9OWEFv8ABnMVXZqGUWfAwlwH0WIC1I8+I1XadbmKAaElA9LHpxiT7QV1UKg36Dc6hEgFh2pnU7XITmVlO8fEHWc4WybgVEeT/YOCBt/J3uf3PNphVzP0QX7m1+6Ghfy9QUzupjle1x1gshHuzg9wOTeg/ml21J5JYUx2wStgd+DvIeWsH6MtRT8GH7ejcLWShqzYl+UiAViZ87JWHJ3aCmUQFVuHhkTtOQ7PufvxmkLlyKvyLweqHR1Za8raNsvmv2VBr7zrQyHC/TP7XqF8ATUGYnBoYluIpjbikSPmf3/wq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are configured (damon_has_probe_weights()), use
damon_probe_hits_wsum() for the frequency subscore in damon_hot_score()
instead of damon_nr_accesses_mvsum().  This routes hardware event counts
from a perf-event probe into the tiering decision.

When no probe weights are set the frequency subscore comes from
nr_accesses_mvsum, so page-table-only monitoring scores from the
page-table access rate.

Export damon_has_probe_weights() so ops-common.c can call it without a
static dependency on core.c internals.

Guard against integer overflow: clamp the probe-weighted subscore to
DAMON_MAX_SUBSCORE via min_t after the mult_frac scaling so a large
weighted-hit sum cannot overflow the subscore range.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       |  2 +-
 mm/damon/ops-common.c | 21 ++++++++++++++++++---
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 217299aa6c03..d7baa6a58d3d 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1306,6 +1306,7 @@ unsigned int damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx);
 unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx);
+bool damon_has_probe_weights(struct damon_ctx *c);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4fd1db12bc49..6a90cf465d40 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -351,7 +351,7 @@ static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
 	return NULL;
 }
 
-static bool damon_has_probe_weights(struct damon_ctx *c)
+bool damon_has_probe_weights(struct damon_ctx *c)
 {
 	struct damon_probe *p;
 
diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 2f3bf86a221b..8cc6bc440153 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -172,9 +172,24 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 	unsigned int age_weight = s->quota.weight_age;
 	int hotness;
 
-	freq_subscore = mult_frac(damon_nr_accesses_mvsum(r, c),
-			DAMON_MAX_SUBSCORE,
-			damon_nr_samples_per_aggr(&c->attrs));
+	if (damon_has_probe_weights(c)) {
+		unsigned int wsum = damon_probe_hits_wsum(r, false, true, c);
+
+		/*
+		 * Route perf-event hardware event counts into the score.
+		 * Clamp to DAMON_MAX_SUBSCORE so a large weighted-hit sum
+		 * cannot overflow the subscore range.
+		 */
+		freq_subscore = min_t(int,
+				mult_frac(wsum, DAMON_MAX_SUBSCORE,
+					/* +1 guards divide-by-zero: samples-per-aggr can be 0 */
+					damon_nr_samples_per_aggr(&c->attrs) + 1),
+				DAMON_MAX_SUBSCORE);
+	} else {
+		freq_subscore = mult_frac(damon_nr_accesses_mvsum(r, c),
+				DAMON_MAX_SUBSCORE,
+				damon_nr_samples_per_aggr(&c->attrs));
+	}
 
 	age_in_sec = div_u64((u64)r->age * c->attrs.aggr_interval,
 			     USEC_PER_SEC);

-- 
Git-157)


