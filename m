Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C8EDCD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C9B6B0096; Sat, 16 May 2026 14:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CFCD6B0098; Sat, 16 May 2026 14:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322A46B0099; Sat, 16 May 2026 14:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 18B9A6B0096
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF9E81C1063
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:29 +0000 (UTC)
X-FDA: 84774141018.04.05176A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5288D10000B
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X3w8+4T1;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pD0aCH718D8N6CRD68JCiYCt+Hm7I+DNlMUsp0Npyo=;
	b=TxX7kigrZ+BTFnRKjAtX3/Nw28u/zeyUQN8xEQAhHLqx9mtEDz6ObpDX/JlJ+s/bX2xNjt
	k/gF7p+kLW3U276XTNnhwK5zQbO0wlJbMkoXimGp7amyn7L19y0rMu0lEgAczU8y3f1zj/
	tq0ryrpPbVhfngZ3oIBdLZkGvThOFaw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X3w8+4T1;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956648; a=rsa-sha256;
	cv=none;
	b=An4qaPcYUho2oefwKZPhBPkcsu4wef5JrlacKfI/gpX3BYElmT7cnX9fKR/7r1d515jTN9
	/8Dz/XJ+M3jXbl09IWQrZvZILs6InZWByYaySS2MuxoTRZp/Sly7P4OkhF1E3mlzOCQ3oA
	oMuSLfn1RT+KbgFA94lkHaIlYCZk1gs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 57C904454E;
	Sat, 16 May 2026 18:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127B2C2BCC7;
	Sat, 16 May 2026 18:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956647;
	bh=YUEUEwyNL9PReREavu4cR4f44O9YYFDKrNpJr/Ooyz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3w8+4T1W3iNDJnRNOsh+A55B+RcmvuWDBMe5TonS+ne5qofWDudjhSrVuME5OyFz
	 Qs7KPBG5AuG8LmcJIx4LNnGVkWApeaRCiu6NLQfZhZGzHuC4aDM8GsBxzH7BeKBR0d
	 6agISdRkDPWbMlCHnNGHaDHp6hIi6cD28HI3LDRc/OjY6uDOVz79woxAaROzms4/P5
	 XotRF9QgDLkJ+u36QxqffkICMVbvQ3/EWp/IYbaGPT6lqxCuJQ60cCtWKhm+Tl+lwp
	 D3QgnGfvuwTQetjowQg4J9O0tvyKea5Dp944AUHWu8ercaFSi7zNUqm84Njbxd9RvJ
	 8AOd0eKYx6Hgw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 08/28] mm/damon/paddr: support data attributes monitoring
Date: Sat, 16 May 2026 11:36:49 -0700
Message-ID: <20260516183712.81393-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5288D10000B
X-Stat-Signature: zxxwht1bj1j439wg7498k9bcr8z7u4za
X-HE-Tag: 1778956648-872814
X-HE-Meta: U2FsdGVkX19kfVikgdnzD8TWzwONzsyk92cIPLzPBZsn2kIS/YT/vSufqUl3MTD+gQBvqdyU83H0x80T9bklVCFI5Uk6yUbh2FDqU9FHhaEuMmwQmvBoJNpkP4uMc3M+ty6zBY4OckwisCTS6+E1oEDYzXXZwTrFmBYAQcUi6Josb2UeVVXusmg2vUReoN1BRaz1QpeWDLkYqukCFObAyLrjOTGZZM5Hq3cvkfYCSMvNZ+pGyzFdCxaLPk+Q0wai8g05cAzpea5kkclLkF62woOq4twABNNeelo+zoApe4tbB3720ua/wmhIMOJpo7nlhAO5AwKaAq+X04NCtr73aswB2o3G6CmNctVT7VGUht/buTnEmNH8EpCYaT4+vau4XK+8BaAGMxX2h5FfWvKWt0jONCMmY2wRnuo/t5kjpulqPMYv4zUpde8++Xq7Y+uxnUFI3YbQUA2WctZLbBQASiHYvNmV3rzzTZrr3C4uUDOuUDsPo1mjfZsAHAj0KYeoQoehcNRS+th+GreX2BmcIrXvHxVgZry49mKLI54+2Iz+uWWrs76DMNuzKFsy6P1StWQJZ5k5Zsm7BSlFitG2SHlg+OdtyXSH86HuZRg38gmES9wUGqbO2qX8+JReHiYxrfNlk1rF+Mipc/mU87aIzh8nF0VmhY7rLX9KLhkz6WPIjaCAk1qbDDPHnWREsS0q/KHKha44Pm46VzT4m7JFA7Rds2Lh2EzkqjZDBNBpnUbiq/9SOsgbasZHB+Wf/ITO5emaYlK+kENBdmYA9+F5/O2522bFOsKeuZqm+2Bv+r2/zq7+LlM+7jMyPw+qTdGmjvWVUyk+NW3Cxb0ggDRJsVtWRCuT0MNXKDQ7HJJFxXPSE5djybD/X3Wb5onm62LTbPYauDcZCUDbv0pNav564yvYuylVwZKmotOH3IYrMp7J0GMIiQ8aEqV6lCSW+Y+8DaJFnbmQj7RUMmmOf/U
 kBnnKbOR
 1zBA26KcO64C31I9Ojbu6JtLa6Ihz/XOuVPbTX2Ap0qbcvNxbEfsPTDERd+Wb/Sev72TETChXouj1AoL4UqOK29GemhY0WDg06PY3qx3iHjM8yg74xYCNNsi9Xprv1qA756n7yasqtJ8qd1jOkZbj4CwU5pxKWI0maFwW0P6DYnuSD8ioReRwlH8mxsogLnIZg5Dqm1+sUPkVZuH2N4XZuAFFiB3ItBnd3lZdj9rJePJ+NNo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement and register damon_operations->apply_probes() callback to
support data attributes monitoring.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5cdcc5037cbc1..81780b05c175e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -120,6 +120,67 @@ static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
 	return max_nr_accesses;
 }
 
+static bool damon_pa_filter_match(struct damon_filter *filter,
+		struct folio *folio)
+{
+	bool matched = false;
+
+	switch (filter->type) {
+	case DAMON_FILTER_TYPE_ANON:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		matched = folio_test_anon(folio);
+		break;
+	default:
+		break;
+	}
+	return matched == filter->matching;
+}
+
+static bool damon_pa_filter_pass(phys_addr_t pa, struct folio *folio,
+		struct damon_probe *p)
+{
+	struct damon_filter *f;
+	bool pass = true;
+
+	damon_for_each_filter(f, p) {
+		if (damon_pa_filter_match(f, folio)) {
+			pass = f->allow;
+			break;
+		}
+		pass = !f->allow;
+	}
+	return pass;
+}
+
+static void damon_pa_apply_probes(struct damon_ctx *ctx)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_probe *p;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region(r, t) {
+			int i = 0;
+			phys_addr_t pa;
+			struct folio *folio;
+
+			pa = damon_pa_phys_addr(r->sampling_addr,
+					ctx->addr_unit);
+			folio = damon_get_folio(PHYS_PFN(pa));
+			damon_for_each_probe(p, ctx) {
+				if (damon_pa_filter_pass(pa, folio, p))
+					r->probe_hits[i]++;
+				i++;
+			}
+			if (folio)
+				folio_put(folio);
+		}
+	}
+}
+
 /*
  * damos_pa_filter_out - Return true if the page should be filtered out.
  */
@@ -371,6 +432,7 @@ static int __init damon_pa_initcall(void)
 		.update = NULL,
 		.prepare_access_checks = damon_pa_prepare_access_checks,
 		.check_accesses = damon_pa_check_accesses,
+		.apply_probes = damon_pa_apply_probes,
 		.target_valid = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
 		.get_scheme_score = damon_pa_scheme_score,
-- 
2.47.3

