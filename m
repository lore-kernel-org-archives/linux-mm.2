Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B27CC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19916B009D; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FC76B009F; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BC26B00A1; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65DC16B009D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BFADB1602CF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:56 +0000 (UTC)
X-FDA: 85036864752.16.F5E8C54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 226F8C0004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pj/NT0VQ";
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34zeToEcXZjVDUJjZzX0H1OFs/41PDBV/Dxu9mrmuxs=;
	b=xcFsTzBegfMUehwjcsJKh608uZYOgCHxp7d3OGlmf28zhP7Hb/XWwmp8QtGEPQGmE4V8BM
	YNDClqtAAp/6fRzIJm1fevt6IeFtACyo9rp8kwWVcCWJWp3Ra7iOM3DTyQEIIzMHHgopOg
	xpmi0WZ6l6MumnOdQkc8Gg+tKo+OEsU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211975;
	b=EsdVhyGPBPU3kYq9HtDWnha5nc4XitHm2XJzJQYLYBIGV/7szoZeyKudgv6MXX17JfLH0B
	8H1JS1JY1Yh5O8HJWrdnRUUcPdXj/V3mPKeBhgjBDJEX99GWg3pkL4t1WNDAZ8OnW8RRjo
	ymdenthJsCepcplyL7v3IJHUOunNpHc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pj/NT0VQ";
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48D9443E7E;
	Tue, 28 Jul 2026 04:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038261F00ACF;
	Tue, 28 Jul 2026 04:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211974;
	bh=34zeToEcXZjVDUJjZzX0H1OFs/41PDBV/Dxu9mrmuxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pj/NT0VQ9StLnnZ68P50TpeKNheICw1ZRF2QuEPytucxqIgGHaQOe7TzRRXEkIerM
	 15IRmV+UN7wf1/BOpkBofFhsSEodjjtK/RuLwfm6s+0KBaK3E8larGsBivRsZAfCx/
	 c+gky2rzM6GP/84E0CS+zoEILIjHKVR5xTzxAGZ2iLh0J1eFqocoWvnbBLBqDByRec
	 IznvRME+KQ9LLKGasIsIRIkxXsuB4mGBBZmvgmIn895JXTqca6Rmg/XfRdkZ6veY9N
	 4tLXzM90rsjWfYII5UJIc0iBdgp8U5B+05T7FDmrLM1WXqL2spMviaJUwsDycXkf1N
	 YH2nlvIVZUTQQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 06/17] mm/damon/core: commit preps
Date: Mon, 27 Jul 2026 21:12:27 -0700
Message-ID: <20260728041242.187380-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 74utud8zoqu544zqic3zk6wp56pk1mia
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 226F8C0004
X-HE-Tag: 1785211974-895413
X-HE-Meta: U2FsdGVkX1+zOlmpGvvnF59QFQr+Ye4uizrXT8Y3RN0DjXgJNmD2n4LpC1L1OKAZZwzhhtnQKeU+5dhkhd4D5Wp2s2pVNEbXjdpjpFsYkGbWXcEKzVImvqzhvpvxUc/z3WPfiGtbr9fUbvEqpP4w1RtMA1CviafuUWtJgrHpW0VprnSnduBNTm/czvd1RwiiIxaaJfj8/dC4uQPMBZOc0BCeUyoPbBr7Pp4HqAKcz96xkbBnsZt5YJxG64mDyrsyHHj6vw5KZPRtHUtv4lNY8hNkOq/KR33yYzvCul4oMNn4AV8rPd86N351CYnikAceOL+WnV5I2lat3hGi5XHwrkAkSc3s5p59wDe5md23LxQlBXHEVGi9VpKpGdrf3nYf8fFQEE1bmQPUppu2mvCCDb9rWdlc8O96QhpRZjYK+kMNf7wwHN9j6lwO1P/JW5g8LFS3d17T62sgGmK4D92nSZBiqwp5f6NBAi+bSK/y2Bv06KGSPfl4MHpvZLydpw2xejA7fARzsPicMfIJ3IbETtiyBbKg1d+hucYxpZ0/v0lBYvFTkZ6HwR1xcfua0Y03n2FIy4pzfabBynZpgcrMcUfG+9jm6rb8hiXwjM0x5pgLNQHMVokXtmxo1Wrgjm4JlXwtDIbMdvz6oIDNzq+Bdad9EUPrPI2/QZSJVyzixIQJ9HGxtSNRBe6WxG2g878/TGkICYAvzZrIVQKK6qNqHQVsIlwq7oqQE0vq30I0gw+i7jW1YszAusiA0SyoTJJafYm4pBFbwK5AE871LO3eh8HTyvsBYZHFWgiVDmH/IayVdFMFOLnsnNEX//lD+roYmyzrjHZbfN9f4b3c4QgKWRoLyQ3lYn5cuPersg7XS7S+rXTI+uoKOiy31S56pogw3RNZzjKQ33ERzXiyGs/7vswXld5EeRpnwQbE0upsAGuFy+e9cHtNGxxIPueyEotvHeSJPwbMxalMcmscgZC
 7xxIYzpM
 h4Wps36jO0UJKgm/lWHhk9fn2+2aCurEv9HHs0L5I/8XEg4/Cr/eFpiqw7AzYfUdLEmK0mXhuYkJUOooJ87dLcnZYebzxusnSuMFqN6kKsbcRK3FOxccPV+Qcg8DUlUl09NQjh3NmId47CrTuWI+B0rg1ltuz1v/imehP/SwfOvRBe89P6OATJAFTBRgetgggqxilFY4vGOpB+LGUKyGEK0lQsp4/Qfa3kPScrh8q+RqWGF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_probes() is ignoring damon_prep.  Commit the prep actions,
too.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e8b5e6e43f9d4..01715648f6e0c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -128,11 +128,34 @@ void damon_add_prep(struct damon_probe *p, struct damon_prep *prep)
 	list_add_tail(&prep->list, &p->preps);
 }
 
+static void damon_del_prep(struct damon_prep *p)
+{
+	list_del(&p->list);
+}
+
 static void damon_free_prep(struct damon_prep *p)
 {
 	kfree(p);
 }
 
+static void damon_destroy_prep(struct damon_prep *p)
+{
+	damon_del_prep(p);
+	damon_free_prep(p);
+}
+
+static struct damon_prep *damon_nth_prep(int n, struct damon_probe *p)
+{
+	struct damon_prep *prep;
+	int i = 0;
+
+	damon_for_each_prep(prep, p) {
+		if (i++ == n)
+			return prep;
+	}
+	return NULL;
+}
+
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow)
 {
@@ -1687,6 +1710,36 @@ static int damon_commit_targets(
 	return err;
 }
 
+static void damon_commit_prep(struct damon_prep *dst, struct damon_prep *src)
+{
+	dst->action = src->action;
+}
+
+static int damon_commit_preps(struct damon_probe *dst, struct damon_probe *src)
+{
+	struct damon_prep *dst_prep, *next, *src_prep, *new_prep;
+	int i = 0, j = 0;
+
+	damon_for_each_prep_safe(dst_prep, next, dst) {
+		src_prep = damon_nth_prep(i++, src);
+		if (src_prep)
+			damon_commit_prep(dst_prep, src_prep);
+		else
+			damon_destroy_prep(dst_prep);
+	}
+
+	damon_for_each_prep_safe(src_prep, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_prep = damon_new_prep(src_prep->action);
+		if (!new_prep)
+			return -ENOMEM;
+		damon_add_prep(dst, new_prep);
+	}
+	return 0;
+}
+
 static void damon_commit_filter(struct damon_filter *dst,
 		struct damon_filter *src)
 {
@@ -1745,6 +1798,9 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 		src_probe = damon_nth_probe(i++, src);
 		if (src_probe) {
 			dst_probe->weight = src_probe->weight;
+			err = damon_commit_preps(dst_probe, src_probe);
+			if (err)
+				return err;
 			err = damon_commit_filters(dst_probe, src_probe);
 			if (err)
 				return err;
@@ -1762,6 +1818,9 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 			return -ENOMEM;
 		damon_add_probe(dst, new_probe);
 		new_probe->weight = src_probe->weight;
+		err = damon_commit_preps(new_probe, src_probe);
+		if (err)
+			return err;
 		err = damon_commit_filters(new_probe, src_probe);
 		if (err)
 			return err;
-- 
2.47.3

