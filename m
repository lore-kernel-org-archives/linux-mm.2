Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6DE6D6CFC4
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918E26B03B3; Thu, 22 Jan 2026 23:57:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A676B03B5; Thu, 22 Jan 2026 23:57:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C156B03B6; Thu, 22 Jan 2026 23:57:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 518686B03B3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:57:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2C1913A085
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:57:46 +0000 (UTC)
X-FDA: 84362020932.29.DBBF9FB
Received: from mail-yw1-f196.google.com (mail-yw1-f196.google.com [209.85.128.196])
	by imf06.hostedemail.com (Postfix) with ESMTP id 28733180005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:57:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FRNcCEFv;
	spf=pass (imf06.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.196 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769144265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0i7a7403YgQyMlpi7E1tGdpNbWRUN7COl/lkLxdLS4=;
	b=wyXWe96i6v2TpmrCwKWyCGTIIDKy64HqFpCDIRqpncpqn96Kl037LLhr6Z0bwnGxM58KUv
	2+p6D+oEe1whrKA+Vy77iJEMYvSchHJHrc2QGGHCfAEDhRGlMXS/cbTJL+wPpib5mXaF7Z
	Xw+/xNoM5mfmOz4XM14mIS3+0Fsxdrc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769144265; a=rsa-sha256;
	cv=none;
	b=shCTP0zLHCloWC4WMR47/DRwgxhyUEHfsU2+J2Rj7oLV5NOCF/fgsmRXoaSnmxNrumiTyU
	gcccrtmi1of1pW7PdHjlLI6EDOoax7d3BcbpqGVj1gC5G8i3fAqV59EAurTQJUnsBXky5S
	zdI1LU2T+wT16MNddFKL/X6DMSk/WZ4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FRNcCEFv;
	spf=pass (imf06.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.196 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f196.google.com with SMTP id 00721157ae682-78fb5764382so18751587b3.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769144264; x=1769749064; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K0i7a7403YgQyMlpi7E1tGdpNbWRUN7COl/lkLxdLS4=;
        b=FRNcCEFv9PkTGPce5VDe21HgRJMnix9DMXeV9hvOtT0bfkU80WxGdusbCs37w9/tyt
         4mmRY0tJsoc8pfLTfBN7CYp/sVlKRray7Yg2Ln9HOJjBb6dVx2fWd3MVnfNkpw8Aq6eo
         XsH3Y6MxrvenSYDaxBfXuuNgWoN38QbnXZHVjzj7ogPEW5j0SaS/dJqxOSaG03RDgS+j
         gD+Exfxbek7K8VBe1kV3Bz1QnTFVBZJmzMrZ4fXwj7SxTDy3Sw27N4CJC13nd8cvtlPW
         m2iMyURvkh3aX4R3i0/b/2kp3pm9uwnuuwlZaEwadFf+6yHbgzohnMm2XNxSuDUytje4
         DSqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769144264; x=1769749064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K0i7a7403YgQyMlpi7E1tGdpNbWRUN7COl/lkLxdLS4=;
        b=Q7cDszqqP44V5y3LBfvdwQSPTmu0i+wOt6HOdqoqv4z+4MBvZ86+V/YfY37dsT05+o
         DN3Wmk8LugFD2XrCdPsrKTt8tPposapJyg0GynWtKDNNk1w8D5bF0HzFDcc6czQlGuvN
         FbuuARK660Rg/i0bYFe16HrBVe9TAmLtcmH/R2vZtTuQd0WtMdqz54UD8+kkBwnx079S
         Tt2Nv4+mX01S4oXhFLvYy/Txm2LbEqbw8tG+pATl/x6+P9rYEiuIsOoicbcckZ3lLRQN
         BOmR0AV3ze0PC5bOdLGk3cDrDQIT4p0wXoq0YoH9ex85vNlRBQFMbujtUWvP1RABPixr
         Pdsg==
X-Forwarded-Encrypted: i=1; AJvYcCXt+3cG/If2LU/qiPnfzgiOPiUeEZQCApSCuAEQoRxx9vRKF0H5Eebp2k254VZN2MysytQkOymltA==@kvack.org
X-Gm-Message-State: AOJu0Yx01I1TxXSyuQhyN1/C5PgndFqHWJgIN3sFx1mm4aemgzMiNqXf
	Up8JPnXm2aST+uVH9dJsaLfcFWjlwebOhAaa/+etaeb5QCSyCZJIKes=
X-Gm-Gg: AZuq6aJi2c8DNMNY0YLQYmBD/0V/Epp+pkP6zxcHOEvPGyiRJbeplR2ySo3JBCBpxaj
	ZpltRNdlW2rJY7hVmgx5hNAnVuWqzrwEA4lQJKrw5TAUsveMJbRssnzqD8AI2nzv/Ro1Yr6bDWT
	/Xomrile7Z8uXOxxSSHXha5Joj14h9cHzS6+HKo2gVvW0Ee9qVlzPgqK42lG5ZQ4BF29Vzb4zKy
	ye374lTgkAurewPa21nXswJpO3v88g8NrKKyd1FR0mezKStACnBIb0p7NRCOYgsoWt2tPxmwl6w
	pc23dQSmalcmML0oWs+YLMZJhLIse/XJQ6+El/lD3c3Drp+mtquj7pxweNp3Xre6dnxIbzBjI5a
	A6ntu50KVhCqOD6MoMOadiPvU88YXmHGfvNYN+bO8/2mo0u3KdGL5vSpTQ0XnvqS+/qz1YIggVz
	A5GOc504DKQYTooXygqFxnkfOIC7fNJx9AGZAc2tUpOEqx0Wp8BXeAWFaR3yYWfQ==
X-Received: by 2002:a05:690c:ed6:b0:787:b5ac:68e4 with SMTP id 00721157ae682-79440b4d2cbmr136867b3.48.1769144264173;
        Thu, 22 Jan 2026 20:57:44 -0800 (PST)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7943af14163sm6332217b3.7.2026.01.22.20.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 20:57:43 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [RFC PATCH 2/5] mm/damon: add get_goal_metric() op and PA provider
Date: Thu, 22 Jan 2026 20:57:25 -0800
Message-ID: <20260123045733.6954-3-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260123045733.6954-1-ravis.opensrc@gmail.com>
References: <20260123045733.6954-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 28733180005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 7q85jrgu9cmta98jiqi3xa85w3t5fqas
X-HE-Tag: 1769144264-683452
X-HE-Meta: U2FsdGVkX18yOnlIoURi7QCaxkoeFCw+s1mKyUTBJN8gDRw0ieK9R46z11iD5oVyHPxAo55rBgwOOI0eY9ldbtCp0/gVqDt79emfmk1PUPiDviDwiyyY1zfwOfC45zvL3GyCGQmLCXo5/wrjeHqqlOBQM9lm6j6fgBnppLqBXDspTN7lxd+aIbJeTvPDjZnX0BZ6jXrtjoyiUPKZV0JBLqYg4bU6G3VC3iFRphm24Tm/C7p+HhfCXgg04XKGy+3MR97I+7L5R1CWmSoQqLVcfJGs5MmMijiv8ePwnVA+3iEyQVIyUhO1l77b4ACRW1C81UxqRFSdQW1kDSWsvZzl4G+YTu6bTZ55hwd0+2/jh4v05VeXOX4eTlQWZ347w7VMZiVn++KK4xd62p8He7hPcYQLgdgJAWdqYB8brrYoV3mfHo1vd99Ll3RODGWVyfC+nESwghk8TgFbx+s60jFNId6bpSecp/e4tIcfXHuTHs8Yr+1tC15GuTPduOJtBSYeOEnvXcku4Kzgxsf3kunCvfjzUTgwydPNFhoFIkXdEc8SmuJRrLMX9s7+Lz6LsWTatUvna08fiXsIR1/5nwaPB5yj8MlQAHhVn/Ho270r6CcTXLlkVBj7qhoHU1kcRCHzEq8TbuRKMmVgKbaRQwDyF6ya0wvJ4L+c7KvjEi6PTFuTBCevQVfZ95jNIqeNQs6Oqp38aIXVwvlhzM9WsyOa4DInbYvjiZRok7MFnh3wfirsfYmBQojeuAENtfw/b8qXK8c7x+O4AUzrqhhxGP4liNyJkUQVVfr5jgb6RXJYf45JNn6UJVuQwPFCqGMCiEOfQfvuMVEL5FYgGpqOY87sVi1xbv9H+7u4THdIJPL2TIuJltyWKJzXfzXtiRidZ4JGqM85kKJgTGY5oikEH4UngZBi7nP+jrlK5XuCmMwL9TPNhbDU7GlkX6GXWcM+41XvBfaAd5bT2OZmFjMXZSE
 Hi0hBc1u
 ieqRNtK+KvG3J/PDKwTUWwboY0/MnoFgSqHjxjirDOJveqB70gVnzU3HqXAlV0lwssesOZNFhlT1kDKJGYuogp7vkpvHFULKOdaUPTCKExUYxyyiDWkjhWiBL4PlHDbIGCGg+nkl8WC65DkdMl1CTJpJ8bJwL2xG2n4T6tsdRyEvsA88pln8Xt9fO7zNrN2HYOxbkbIfrjcXHNqLPFbJH+acJa2ixNQky7v4r1XF9Pqp0Vh1d8GTcCcaK2T3lSox4N3c1pwR9vqVZP/03wkF5182CAmMr6uKdQFj7G+uIMLFKFBp3ckEF32iutvsmcoI1ERviQBPY8Ol8jDbryvU9KQeHalaUkrYbvVu+bsDugqZKge3+5c6VmHWusbygCIUB3MmSXl2ImIiGsieKCiontGMmTXGDXvqyX8JiIWn9Z6otjgpnwfbY1cixoz1uFau1Npft7y0zPuCFUOjHAV67w5C72DgkI6+8FRZo8vUdMEQIYSHx67ZGTjItsSQfX3uPArXcQiJUnC2g0rKmbcvW+/ukYqLok2s65xZb5R/agHH9oSfOJxD1csfiLkiX9fIeQhg6qELZ1jSyhBUAaO08QTsk9Iv0hKKDXS13RuM7HJ+n7rvgaCi0SL1FxwM+B9pg1XuZKUuGH7CkmU5OGmc+epb+34oRFzlGUnKqLJFCmg79EYBqDdbuzLnbd1RpHo12zx2z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce an optional damon_operations callback `get_goal_metric()`
that lets ops providers compute goal metrics requiring address-space
knowledge.

Provide a PA implementation that handles DAMOS_QUOTA_NODE_SYS_BP by
iterating the monitored PFN regions and attributing bytes to the
goal's nid.

Core remains generic and asks ops only when needed.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h |  3 +++
 mm/damon/paddr.c      | 58 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index ec5ed1a217fc..67233898c27c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -649,6 +649,9 @@ struct damon_operations {
 	bool (*target_valid)(struct damon_target *t);
 	void (*cleanup_target)(struct damon_target *t);
 	void (*cleanup)(struct damon_ctx *context);
+	unsigned long (*get_goal_metric)(struct damon_ctx *ctx,
+				struct damos *scheme,
+				const struct damos_quota_goal *goal);
 };
 
 /*
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 07a8aead439e..30e4e5663dcb 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -14,6 +14,8 @@
 #include <linux/swap.h>
 #include <linux/memory-tiers.h>
 #include <linux/mm_inline.h>
+#include <linux/mm.h>
+#include <linux/mmzone.h>
 
 #include "../internal.h"
 #include "ops-common.h"
@@ -148,6 +150,48 @@ static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
 	return false;
 }
 
+/* System total RAM in bytes (denominator for bp computation) */
+static unsigned long damon_pa_totalram_bytes(void)
+{
+	return (unsigned long)totalram_pages() << PAGE_SHIFT;
+}
+
+/*
+ * Compute node-scoped system bp for PA contexts:
+ *   bp = (bytes attributed to goal->nid across monitored PA regions) /
+ *        (system total bytes) * 10000
+ */
+static unsigned long damon_pa_get_node_sys_bp(struct damon_ctx *ctx,
+					      struct damos *scheme,
+					      const struct damos_quota_goal *goal)
+{
+	int nid = goal ? goal->nid : -1;
+	unsigned long node_bytes = 0;
+	unsigned long total_bytes = damon_pa_totalram_bytes();
+	struct damon_target *t;
+	struct damon_region *r;
+
+	if (nid < 0 || !total_bytes)
+		return 0;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region(r, t) {
+			unsigned long start_pfn = r->ar.start >> PAGE_SHIFT;
+			unsigned long end_pfn   = r->ar.end   >> PAGE_SHIFT;
+			unsigned long pfn;
+
+			for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+				if (!pfn_valid(pfn))
+					continue;
+				if (page_to_nid(pfn_to_page(pfn)) == nid)
+					node_bytes += PAGE_SIZE;
+			}
+		}
+	}
+
+	return div64_u64((u64)node_bytes * 10000ULL, total_bytes);
+}
+
 static unsigned long damon_pa_pageout(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
@@ -344,6 +388,19 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 	return 0;
 }
 
+/* Generic goal-metric provider for PA */
+static unsigned long damon_pa_get_goal_metric(struct damon_ctx *ctx,
+					       struct damos *scheme,
+					       const struct damos_quota_goal *goal)
+{
+	switch (goal ? goal->metric : -1) {
+	case DAMOS_QUOTA_NODE_SYS_BP:
+		return damon_pa_get_node_sys_bp(ctx, scheme, goal);
+	default:
+		return 0;
+	}
+}
+
 static int damon_pa_scheme_score(struct damon_ctx *context,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme)
@@ -378,6 +435,7 @@ static int __init damon_pa_initcall(void)
 		.cleanup = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
 		.get_scheme_score = damon_pa_scheme_score,
+		.get_goal_metric = damon_pa_get_goal_metric,
 	};
 
 	return damon_register_ops(&ops);
-- 
2.43.0


