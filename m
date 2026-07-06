Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFDF0C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FE96B00E6; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F082B6B00E8; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6C06B00E9; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD7226B00E6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E664120445
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:26 +0000 (UTC)
X-FDA: 84958559532.27.D5FD236
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 989794000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f9svTGJb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsWIFasK6BNqNQpHNrMhe6JldAnQbV9yCA0uK0R+9K8=;
	b=UlnvuiPGYoRL1FcdI70s214h0qYegixjq7Jp3sHAH0OSkHegFAdOpa0dScSA1oQOaB4evr
	xNUAcN1wsdSscJaehRH229ELJ8IH611R6zLCzuGz6eSgNQyNDqQV0z0U5AtM/oBuDJ8c+h
	1gFkNwhT0sHVDJv5sqS+FMaUH9RzxzQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f9svTGJb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347564;
	b=Xo4vPHJc5RQJGjojEX49vpA9ZFu0GdG2sXfQ5Fd2MArYc0JdikPViSEKrVfHijaxdDLpiw
	7PGh2saYu78reRYeXlv5cnAIRJ/0A/Y4fmkmc8545+cx6KW/mqi6v3DEm/UvFlFqsxszeM
	/vj4P/ufV/gvcM+f/SDCd7uLTh06mBw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 356D661834;
	Mon,  6 Jul 2026 14:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5491F00ACA;
	Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347563;
	bh=nsWIFasK6BNqNQpHNrMhe6JldAnQbV9yCA0uK0R+9K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9svTGJbnVJcSUT4h68oxYRFlse/+YbGSa20JhHmiJhsEfXyiO7Krpzx8LcppGdoV
	 UzITVCFqS3fBvGG6pb6n4kf89YbPB3hMIcvnQfmbgnxQIBDf0YftLW4wAHX+6M5XXB
	 KVcWO6Va0Er6E+K/g+g2Y9NjQCJQOpvMNsyoih7Y+g62Ezt5vpdUrYlBjVG3D9VZok
	 Kuf2HikcuKCs1NMn8S2MYA4hQexqjupRVMejurkCoF7agnElLjKjy2JEASBsoh44Xr
	 3oYZ34zbjSPv77Rxb9afeWexuytFUtcClcC+MlruNd0pt+uF1lICwmfnqdVmue4xfd
	 WQj6yZXWC4xiA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 11/16] mm/damon/core: get merge threshold from probe hits when weights are set
Date: Mon,  6 Jul 2026 07:19:05 -0700
Message-ID: <20260706141912.88445-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 989794000D
X-Stat-Signature: rk1hqntw88obdr7ghoppnq988zefbuc1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783347564-261158
X-HE-Meta: U2FsdGVkX19yEArXurMjNFNvTof/5eljMyK0DsH7Y2k9R+iIzSt7FaL4L7T0mgCiKYadjaDPB7XkN6X/2Ev8jGUF9rr7nj1VY1WSlNX3z3zJ9u/BYwQnOjPH8FS4uFvky7Lza3ensWu92xTQUpfidsetEuGprei3dLloeoE7mUnOu4vxqEXABtFxA1wbNXGCv9UAQfXTdCwsyX1lAGvPo6yEgteXIxpOoHJMiIFmWWQDJD/oQTKuGflNn1DzY3Q91KD96t9p3EK+RpgcD7qEeDjjmg+FYIPq/eT6oauzWqo9S/vjUkz7RI/Q7Xf1E7ddxmIH3cKNK4UhqVgTHFrXBxqmpIUcKxO9V+jZGZY2aYYWFZhjRdqpARelxw4Lda07qGMojWnX75Zaov5/j7KsdYi+9CXoyQDGjBqquMF6lC4cxAqeIo1qrQaeox5pcxQ5F3ECO0NTgPFnFB1WnOWj6gitEpxl4c5YCPzci9XrW0bMVNcAVaMqSrCmwwJ7ChVvZbCjE57S3d28NJBRCtaGiA8iNaqBE9iHzpxQdv9Adt//FSkVDZuK+Dll+9NBTrQZ5utDeF9AmD6dGXNHgpXZ4uylbvPJ6kjeyMImRG1a7TZCh2gBq6nQI5lj1Quj4n4HymeZveE4e35xt6HtRNbuw2cPAE+TTiKVpL3yS+TUgfeC1kpEfuDG37yAc+3sruHCbjfzAlpfsWb6736CH9Fib/EBTFE/gXnryKwE+d8xzoirVnQCSZQAnI1KxgVK7kpwHIJLdA3oODXLMPrtJ1LBVPpRglRx5O6anr+sov5nvj+72/jK856BgLtMKV0OTi8Q36sU4MWLxUecV9vhGkfSQ2nfrXYP9GR8Mq/YZacnqS8PCYvgaLXFTHDBRb/KN80WM9sYGhQy8SScCcdvvQ0cC2FhpUM5ivAHZE3p1YCEhsmYdh1a6POFinyIt6+QZZcEpKgzAgMSkqq8JkQBpIM
 YB+Plgi7
 vQ4hDl9yFuUNDlCNMLJbA2Ih53dWBXXqaBjn+jWwvetwRzZTUqsb6HcsMcf8AHeZ+XM1LDwaTtQUdjCJVNkJPa62St5E670Mkv5fGYXDsPWsDwCGyv+moZbNdjNSq5z6pv02XjDlagYs/v2aTLDX1rR22cJBX83vPvIEzqOdD4wW4bLWjcF5qh/AcvsqfPchTu2jqPR+AdoITdlStA4j2iliMTWQUh/3COSp9TUsGLndw4K0=
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
index a7ca69ea8e565..83db073c74e2b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3714,7 +3714,8 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
-		unsigned int max_merge_score = 0;
+		unsigned int max_merge_score = 0, max_wsum;
+		bool get_max_wsum;
 
 		if (kdamond_wait_activation(ctx))
 			break;
@@ -3727,9 +3728,18 @@ static int kdamond_fn(void *data)
 
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

