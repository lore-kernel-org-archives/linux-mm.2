Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A506606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V0IPem1m
Received: by kanga.kvack.org (Postfix)
	id DA3DD6B05C8; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30CB6B05C6; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46FF6B05CB; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0736B05C6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C0B01A061C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
X-FDA: 85446641238.03.06D8D6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 941A8140005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V0IPem1m;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5v3TNUEUyGkIhCVZhl1qQoqUnXYUnCoqLwCawYZ32A=;
	b=iU49MlFbBC4W1Do01NAni6dhi/k5Qb0Gfb9DssOPImu+Bhzyzw1zRF0ZOnjS1EhGk8rAki
	9EV/wzgjukTaWMOJuV2pwYWlzyYuY2WKqucg83iG0xA7nIqRGQr+SBs8EgS1Qnzota25HL
	z62aOoV7q50YcwWFlkXAnvvn9+34H/g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968557;
	b=sGtS50/uLjK6ZwU7Zak+FrOqhtH2ziGPgEun8vsdSF5Oh/42Yzrye9rAffjYAsSzCP48g/
	XJhlWwzRzX1llf1VAf1rBGww2pKZwoauch7z0t7kcIfeO6WKYXdd6JxMMhhZ/jqiVeo35+
	o5Trzw32snbvz1urehahzCWVDSokDCo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V0IPem1m;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7185F61F17;
	Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2113C1F0089E;
	Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968557;
	bh=L5v3TNUEUyGkIhCVZhl1qQoqUnXYUnCoqLwCawYZ32A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0IPem1mBDKRz8TiosCk09YG40S9in5HFFUBLvrEX7fIGBZ3+oV8p9GtLaEGla9JK
	 v7TXkUYWW3G/q9KS3Lpyr3Shz2AfXLCgvTmHvyyI7rY+nCtV9IZwj+SQ7CmxHvdHgq
	 mucNlomL4RsDtDFDG/tZYHVPgLkgFSP42zHBS5v32PnvQkupDLFEXzhiS76Z0tNXfj
	 gEudUfHjaWA/nOm/3AJhZu0xnPST6s4uG7NoxORf4qLk0Fj9tuGor/v3dejsYfXUOw
	 z9Vs46Sz78rFszSZr0lvChKAOf+gSVEYyiVCmG0RVNE26m0ErfpJfiQHQ3uM7XohY7
	 hOkDWDMIjlyKQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 14/27] mm/damon/paddr: support REPORT_MADE type probe filter
Date: Tue, 17 Nov 2026 18:22:09 -0800
Message-ID: <20261118022225.100659-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 941A8140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5tk38hecn8ijj1k4yki96pcjfjr8otft
X-HE-Tag: 1794968557-182265
X-HE-Meta: U2FsdGVkX1/OHnHJuQqI4cVd/SRTBAXjQRCMJevzSOzpLlDnKDgYKz4eHBGTQRmat+ueFxBy12Tvgj7odko+vu8Cys2JYvw65pJxGmrmGIbqGysX/wd1n5F4icCPq+5DXrO7f5mHZoijViTN7LV1z1gDX3usGfBcuzMHIpzugPoxoAYsEgfRDhwy+qZFDBDKqqDVopqWm8AR/Hj/gFjT2WqqjynVh1sxZVv6Ber5xYNukV26E9KAr1NTr24K2u8MRd11Ews2P8DYAwiNNahhm7wGsM/gckHJkioRD+uq5JzHrZg1UAYKpDdUO1JJsw6LVgXQKqxW/zyJyh3aFxgAWOgecfN4jnWVIoE1mjFmrhWzuEpn1RPON8NfGRfBiVXTBvmXZhRx+UWgNfYeajJ6qOvX7D004z0asKdAzxCzn817Kdo1wrLn1yZ37rP13uTKdhWvF4VfPh1TUtH16yt7lMSl+7UP7aoolkjnPbXG6i5uin4lxTQxqaEDLMvEeb5HVir/FIA8Uva18QWqGpEgjefXLpCJnljxyPtDJA06q/frtpObttg9DaCtZPPge9HNqDm5//4iTk2lqFPN3jWB1erwyXdm1b2/kczeJt6MK6SGSOttVSYSMxwCa9DyllCXVVDqrWrek85KgRDTpSHNs4/Ue/cSJ3JHH+nbaAYe+ezlDkM0aCDcTmzbz9raa0Aap6A1Jf0S5P1hCXFiT299DFOfBQEQmGc7xRJXUWNBF8PXiM035nvYppRQxvm3aCeZN9PNZHCAe+6kTfGR4bIKGEk9ATuVLuzHt3hyb4h4nTAg7UKF7NT9/ZaZo6uyPu/jJ2mHq1orxRMk+Vqg66jov+/Qi30ZkIQS6i6ATsuK8ecFx0tW4Foo35oHiwhGWCAnfhVZNPdT2P7erZE0Jg8upIy2I2klGzbgwCv27Sl1fPWZADjxNjJZqAs74+Exi3Xa/ShT7PH11x02MdeHJeb
 Z0vl6ApT
 s6FpkzBoE+s3gLHemY+02mzSKH6SBNnHyLhN+QAu3uMUignnA/i6Otb0VfYlt403H4yl5fsdL8vBfq4B6oeHp+Kh/BeM6/zKNmCMdhXbXC0n9sR4sfSnCquW2D0pjXLJnkwNajEGBD8OXK6RpoDP/EoEwu7TSNYyEV59J8wJyNZn9SE2sPf53n5DW1JUWy/Izg1CW+LSYD3dT1ODGTwbozOvFwS0yOhLGD2MbJQ+olvTl5GjLczNoATtTB3IJ6KgOy4F83CGNeUnsFifNH2eecBtPCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a support of DAMON_FILTER_TYPE_REPORT_MADE type probe filter to the
physical address space operation set.  Use the DAMON core API function,
damon_report_exist() for the core report search functionality.  Set the
time range as the last sampling interval.  Pass damon_ctx to the filter
matching function for getting the sampling interval.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index e89cb14ee17be..4003ae914f1a2 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -140,9 +140,10 @@ static void damon_pa_prep_probes(struct damon_ctx *ctx, bool set_samples)
 }
 
 static bool damon_pa_filter_match(struct damon_filter *filter,
-		struct folio *folio)
+		struct folio *folio, phys_addr_t pa, struct damon_ctx *ctx)
 {
 	bool matched = false;
+	struct damon_addr_range addr_range;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
@@ -157,19 +158,27 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		else
 			matched = damon_folio_young(folio) == false;
 		break;
+	case DAMON_FILTER_TYPE_REPORT_MADE:
+		addr_range.start = pa;
+		addr_range.end = pa + 1;
+		matched = damon_report_exist(filter->report_type, &addr_range,
+				jiffies -
+				usecs_to_jiffies(ctx->attrs.sample_interval));
+		break;
 	default:
 		return damon_ops_filter_match(filter, folio);
 	}
 	return matched == filter->matching;
 }
 
-static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p)
+static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p,
+		phys_addr_t pa, struct damon_ctx *ctx)
 {
 	struct damon_filter *f;
 	bool pass = true;
 
 	damon_for_each_filter(f, p) {
-		if (damon_pa_filter_match(f, folio)) {
+		if (damon_pa_filter_match(f, folio, pa, ctx)) {
 			pass = f->allow;
 			break;
 		}
@@ -199,7 +208,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
 			damon_for_each_probe(p, ctx) {
-				if (damon_pa_filter_pass(folio, p))
+				if (damon_pa_filter_pass(folio, p, pa, ctx))
 					r->probe_hits[i]++;
 				i++;
 			}
-- 
2.47.3

