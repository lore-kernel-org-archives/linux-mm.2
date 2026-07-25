Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F329EC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4BB96B0096; Sat, 25 Jul 2026 17:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC696B0098; Sat, 25 Jul 2026 17:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C390C6B0099; Sat, 25 Jul 2026 17:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86C936B0096
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09ECF1A03BE
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:39 +0000 (UTC)
X-FDA: 85028522838.17.4689012
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 83FC240002
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bb5caqvb;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdtqE3eR/Bua/rulOOI8NT/gdSWbQwN4dD7fIeQTAXA=;
	b=ztOcdNw9ROn5Sz3YiCp4lqS7xlCiUuN9yNee8iPuQMLHHqy/YxS7B1KuNhxIYiY2bfn+4k
	xiZfGGk92iAvoHLZj01Nsgl6pbiDgj0qpeisPyFWp9MErxkPyKn/HyaHMwTrOjP7DtzwUA
	ZvHNDJrq6CX1QpAhU0x9gvvNmlnMKe0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bb5caqvb;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013357;
	b=wXx/mk91WtnabVBiZlMKJG+8yYO3+V94Bz+jfmdODtbquqGre3cV6ZDl/IyVIoXiOQeow+
	OifVFmNfj56vkZ4XCdYGFuWsESjiVpvaEOFYbJhbDtxJK+XTkrneWFlsRmqyMNdcA8+Tvs
	siws77o4KafeztVc1DHIX2T35VtT0og=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 223C460AA4;
	Sat, 25 Jul 2026 21:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F27C1F00A3D;
	Sat, 25 Jul 2026 21:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013356;
	bh=SdtqE3eR/Bua/rulOOI8NT/gdSWbQwN4dD7fIeQTAXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bb5caqvbHTRWjD6+KqdsFkIoeWHz41IT88yOdjSWGzGZFaGmWnosSUw88TTQZhMN0
	 P0zlXq9/LnKrlpLbhfrcgYQs4pYxeBp9k4btPtP3G6t598XXJYF7YGW1BsExOA0/+v
	 dyD69RIUM/qtWHPSHLAGHSdvSU05YuK/cLwI4lCYUTtQ0CgNloZfISqr90T+8Oe6o0
	 ryDO9xwR1XHq/kFFCWGF9BbgAR1O7E1vCB0i3Jwpwn75BbLhURgTXqSQr/+9VqaoiE
	 L9oo1fEZhuyObTvAY3H9OF6/X8LYQJvtdTqLq0a5551o5QO+P2IE6Sz/opyaAhJQnh
	 /9GxvqoAHIN5A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 06/17] mm/damon/core: commit preps
Date: Sat, 25 Jul 2026 14:02:10 -0700
Message-ID: <20260725210225.129944-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 83FC240002
X-Stat-Signature: mjurduqa5oohx5axnua1zee59eutwdu9
X-HE-Tag: 1785013357-107861
X-HE-Meta: U2FsdGVkX19sceWxm4Aq6eQJCtuvAOclA53Ss6MOqP5vNBXNWoO+5d7P7sK/7s/Lv+JrZhabMWL/pWEuB3u4vc6H+OfJc0ZUCsoKKl9HuzBrzYrOaakOnXGW9sCalrdnvSW4rBtGgR95G1GDyY6wUAghvVlRHnT3JLduoieQCSqVD4KCCyoAdZVE+PtlU1sMMQRESmUW808O/BNW3GzZmeGJZk4beL1jZP/6n5MD5SNiTz18dlfqHfPsoRJnXC14uLlx2lBFdUZBmJypaHMc1ztsXq2VroJliLOGTL9mXZGH9M4LdpNhGgYjB4kira+DyxQNF3i+ZD7Mo1WDrFHkKb049Et2r5lz/Ap2xJme7A8EL/WWb2BAI0fJL2CTaxzD/Ye6wfKfbeZGQZA9OWVb4ppUy+DN8NAL1rXry52KVjDSdi06bEpenXbbXqbJbbidAQK8CqG7JmB9QxH8lAJkFVkIx8gbQB8O5rWAite1NMCvnk6flZsxdeuK8HZYUjVwPZS2J6cdkVSLQu/EA9NcxSghjaZdwXO2a+iAqu6tKKo9uGqAHkkzAb86sSiUVpvgKFbiluKDo5UTwVT2LCZurgW6nED9R1t1/4rwFnAiyyJQs3xU5e57aslS3fh2wjHsLSSnrMetdPN/o1SOYCv6TfV4ot5eXLWB9d1xVY+x61V68UpvzN56PMDD/oaOPPqfFALlcNFNhu2NCphgPxrZQ/ugme8LIcSYi6tDDQ3DBCKPZLXlJj9Scs87XT1kNPpU9ZFOdDO2tU1l/5xma4a0xDtCdhajzk8yQou9CMXAnPhS53wHbvKCFcTYQ43UA26gi5Nn/LDburvxbQGRbGe7Rfm7+Iwoj/z0lR2wCI7Qbbu51Nw5Nrfn6MS6GsmlI998cjQYwWuaRlk2D2vOc113oWkNBo9ADkDgvKCfr1QuETxJUFVpFdM1nJiYSCCXJR/TASaagnX4dnSY0DZrvJx
 Xswo6iZN
 V2avhTUVPIGXJ/XNnAkd1QwnDLV/g73kLZztP7+LH+b3BKZzSbomRy+q9sstil3IzrwgU+Lqj1PwYottg8989V5ydLExJl3VuXPDmQMl1xqNUe2pepXVUK7bsY0JrkSPZrP0zu0VcP1fvj8MceGgn9UQFUV7nDp1we4op0877L7b7f5PwX3xJdmYxc9xXrQPpGe9HuAZ8uxXuJZjN8NZQVx7L16Nldal3d7fQ+cEn/IqtO2Y=
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
index bda61f9ec0266..c74dee56efee8 100644
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
@@ -1694,6 +1717,36 @@ static int damon_commit_targets(
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
@@ -1752,6 +1805,9 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 		src_probe = damon_nth_probe(i++, src);
 		if (src_probe) {
 			dst_probe->weight = src_probe->weight;
+			err = damon_commit_preps(dst_probe, src_probe);
+			if (err)
+				return err;
 			err = damon_commit_filters(dst_probe, src_probe);
 			if (err)
 				return err;
@@ -1769,6 +1825,9 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
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

