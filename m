Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FEE4C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4888B6B0096; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4687E6B0099; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D146B009B; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CF226B0096
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71893A0563
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:49 +0000 (UTC)
X-FDA: 85031640498.16.5B13F66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E5BC6140004
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T7PUDJOP;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJj1wPDvg7DvY7LzgO/Bh4Zqj5IQYFAr5WffY+jOQ6A=;
	b=4P4MvaIkvBUyLJNid+Xyz+PQBqrim/tc6rCGDkgzES7w2iteKXFFnCKqQziYbqVKoWg2w+
	BBx/j1MRBmfRAbrCzXuN1ttI09KPx1x2sV45MQMxdcA78Hvl4XaQF7Ku8wron0tUJpeuVp
	jOCuzCSyPr1WKu0/rNOyAjf+QtBMaBw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087588;
	b=768oUNsn8m0fcp/UPwL1Vdiv350QyP/RmQEZk0XHJNB5Bm5zE1uz6KK8AILisB1iriaOFn
	Ci3JQ4hc86JcrJKHNUlZ7U0E8AdzRdnyjY2pda6h6rgDlHo3FAQ+/ed6ytTikcl6t4MAMy
	ZIu3PNNW6LITQeIqHUJBI/gDh/Hwe6M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T7PUDJOP;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39AD84514B;
	Sun, 26 Jul 2026 17:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E884E1F00A3E;
	Sun, 26 Jul 2026 17:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087587;
	bh=wJj1wPDvg7DvY7LzgO/Bh4Zqj5IQYFAr5WffY+jOQ6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7PUDJOPeIDeUK+HaqTOd3FPl/rJkFOhMFaRxejyXN6pbuQqV3u0zK+2L8+k8G5ux
	 O5bF0ihEEAAmDxld9JxBVP8mhKuzCiLeEqVnW6l9B1ZDsY5xblGfzQtMV3WQGWxVaf
	 CnPKCM+5ctSmQxDiM/AnVwVHuDS4Mfthom5nNPZe0NqUeyAHxBIWgJzKZN5cBoqvcc
	 e9bqAniSXti0h181UMT/WvW1gLyy4/eOTKL4Sunn/kwcuR5Ky+6gKaX+639tKqG6wY
	 HiVaqSVumuYFUkb7oYhzk/e54RWxTlRBi2IHRBfUV6oymiWPkgFXMx8yeNMZy/Udmp
	 KocTzjidqb0QA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 08/17] mm/damon/paddr: support damon_prep
Date: Sun, 26 Jul 2026 10:39:24 -0700
Message-ID: <20260726173935.94046-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6aud4h3xfoc4aimbztbmhcm67th5544q
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5BC6140004
X-HE-Tag: 1785087587-181489
X-HE-Meta: U2FsdGVkX1+2ZwQvPSaSgNubtZZNJ8v8FM9NRqMeppEeKShfLZXcsrU4osXJtU5XxBsNrHxovtff/VKXG8Ue61q9saRzVoOiM+OwG/Z5joixlq1M1hgSF+76thhj54x2IIdSB+V5qCx5e7UTTi6jO23hUeRZvZpFvbn5YUJz1ePm6ONhYQvrROzkF2QkXthu35m4FVFgucB4/nfv+zD6b5jRYmIi9LxonFx+Ct/XRwOsbEEYSyaW4rZ3g/ropwCBg24enLyefx145PTb+riJEU+vZsF6IZWN2ExNRHnP0X4VyH2YVc5KjD9aed+m/bClDK84gsvaugRhJKTlrSLOH/CCMrlan+ymY1YZ9UDmjHpSLc40UnYx9voXtE9M9K9BF2sV2Wz6zM4Mb4eZ/LAl+8EqD+LVV/pyCWALp28DCz2wfybjcopT0MSDFDmMA3OIKzjkLDxd12P3MxklNIQ1pU95Yn5Jjj0Jcs4M1udazOZaXRTS9BO9rJvdGH0q8krtX8MsCTS3Jtn7SaAaHdf2Ab71EZbJuOHYm8qxry9JDbCvLolAB1cslNtHlRmJxZ3AJEOz15pXR4LUvM7wSAbwCrA4hkWujqv1En9/qJO1QKX50yGHSTyCuVdr/GXUCk/pesQvoxlWwyJN9MtOXak2Gq095w+dbl8VFEu45uN0GLQm5Qu/O5mFeZw4VWy4WHa0cu/UcJYrPzI4mrKUaAIU8wkezyalS6N5Iu+LYy70NJ5VrUxkjW0ZCrXq/olt1/wtWugWEmIUcJZTNH43QarffiRxZE/36jX+wJEiKDwwJBEhEhQEJA+ivDfwqepaahC/rUruiI8RyLCbb8pqP0nZAX10sxY2S6H+UJs51HKZ7cuc5gMCwZ0SeOBvcfvAWBItRqkLSV3928PlKoSmMLwGdU7rIxztlvMKEftj2Q+xYpzbgnzi1ZgVGMT2V+EQO8UOA/wLhRepGLxeWO3Zxwx
 Mu3axwPo
 TilnEC3vdBI+ysk2XFdp8yYTzicZrWjak/KbBxodZGB2RqbN+WjIJWXO/cfTK9k1AMiNoulIsYbAys4wgWqcH1DjE/lpNNj4VJwfI1j/KS6OR3eviDqrdbaBEwx/P7/JYRXCa6laKjq/tFoLNyklV+r6vgd4dZkw6DdCR0goLI/N/F1tq7fcXMb/44ff+XIDRqF0AR7fFTZ72RLXgtwhqDW47u+oWbP3X2ux1MwSfDUhJaZv3JfgSNmy8AzA0k850Tr1qkZ1rIhMkcF70oryB75YdFg==
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

