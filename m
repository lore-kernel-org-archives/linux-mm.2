Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6293FFF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447C96B0093; Sun, 26 Apr 2026 16:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0F16B0095; Sun, 26 Apr 2026 16:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FCD16B0096; Sun, 26 Apr 2026 16:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB2F6B0093
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B48FB14057D
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:38 +0000 (UTC)
X-FDA: 84701905596.09.D377258
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0896A18000B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SDQJoe1N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rG2SQvHixMcNE7r5UJnouCduRtenhJYwYWgmKcI2nVU=;
	b=UaNoZM9SQsAKxjFzFSkQc62mdjeRcu1tX19KKLNk5ypeLXgXK/S7ZSmZx0OlV1uMzT+2QJ
	LITzqhUzstevFCojIpMF0oQVE88RFJplNZYpiGHONIKUsfhwHWCNDmRianOmCFui8u2ZQY
	4DKWSP2862btR/R47P+d5wqR6I8IJqw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236757; a=rsa-sha256;
	cv=none;
	b=vpjs0GqhszL0IjdcqfFyTOkkWWNevMiROTX5Yft+8ENOIRs1IYNJUyWISnf2IwKV/Rgd5G
	1JAkB/Xpt7mWmrUp7gj/yiOoWedD2MANutGkAQtgGQyvCc/1UvgCwZw/8U3V+pyuli/HUg
	vfz1MMzbpRGons4Wr98CbDC7m4Htpv8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SDQJoe1N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 35A9144598;
	Sun, 26 Apr 2026 20:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB8BC2BCB6;
	Sun, 26 Apr 2026 20:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236756;
	bh=o22ugjrNFWbpUtXu+ccYCDc/5RGuMV8QTJSNQEdoQzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDQJoe1NFwHYqANaMOcCpJgaKxKqgUOOQFcaHK+dQDBzj62M2kqwbRu7YI4QitFf3
	 63l7CpBP7+tA7bhepE122ngllyQHBSstJ78Zg9v5v+3soPmmbQTQlNDix+guqzZIwO
	 Tmq70z1SV+5T0Co9FVYXpvu3PCfrX3gM6V1vC44viR2SjLBat6ZSBv+FiAlPojytMQ
	 /OlnA1g1WkSBbENnbAiR+tdtHyCneE+SiVkYq9wGTlIESAmfOPC5Si3jb69Dudw5AA
	 vxnw91V5zasqUR/fp6yDLfWZGDnvbwSQHMG1sEQZ18zpODH7bUp+FkBb87McGC7RDu
	 r8rKzWNedcTeA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 04/19] mm/damon/core: commit probes
Date: Sun, 26 Apr 2026 13:52:05 -0700
Message-ID: <20260426205222.93895-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0896A18000B
X-Stat-Signature: k5jeyfzit1ywadj51to43r99rwigfnhd
X-Rspam-User: 
X-HE-Tag: 1777236756-5186
X-HE-Meta: U2FsdGVkX19x1m44v3JkN0b9NcvDvDGGVVxmBqq7h//hRY0FOs6J/JB5qOENXQqjcouOo9SzwR7RzzRSTKV4ZutQXb4zEP1uwZ+yWOetJ68JNgFF1crRO8yoDM9NH4X9tmoQwXG804hojRJxSA3fzdl/bo2MPa0vXNISJHRv/I5Dz7Zi+DsoNjtklr9MeuyEIivPdGDdApDqNvZNtiVU/vOCGR2XqTkASE/vCw5GNlDrLqC9urwMDc37kLHH7C0DqD3D/7HgehTvI+9FEl822CwCPjHRT3K3AxB9REQJmHvbd2d5N7QFVEW8KvALzw3h5BdZG1uVzn5YJXuT0nVVipUBiNCLP6o72QqiVcNtQrrWEejz4M63X1Qgl1uOUYKcM7R5Jq0otd7DWnTb2dA0WUt64m7vS548Y5+8gFeCidLCu1Q2ChWyk52JkiQaHzvR/u5XOchi4LtqIQfgCTglDfv2DquVfML9/kHAMGcqgO7GbrikGIDgaCeClgy9ctAxOFSMCmY/bD7ynZQPaYLOj+b0yeGxdxw3pJy4ZGi6CvT6kJ3+DDPPfGuig7m60oso85v7stXlzjt5Oq+aMFbjsr/qi5h12qwR1SJ5NvCrNYgaa7mYdUr0y9NKDa3QzF3BJcrEyS72mF8NPSYPApmQOvXhZi8Z8y623XWvcLhVKenmpGaH1SCosyOp0Zm5HIQn++H5plD6Afz/2D4OIms6TCgh/WRiouljGpH/sUa2WQGFJhe+5raRSXwrk133ahK1KwIX3E1H7BjeJh2ejjNZi7wA22cVkqcJzLD2eRu0/Wc0x11JDxc9ElQZwKOhpxxJQ+FQn+vnJmaoPzmD/+avfKNa3kOujsIieFh/V7N8VEU/KKiQ6dPUTcXLic5hEJNGPQ5udcbiNbqbHwjYf6/zFlnlKXp/ECKBr0XEFcsUNPjIq6CStolTr/B/5Tlij6SHAKU+SDuTbkxATGG/fzA
 CMcieHNb
 sIvaPle0rnbF57VrdYyQ6NgeyC4QizQ3h9BSv3rUH1g/kgwXsuAjn0eSQ92mYejndU3hcQ7iZGxyyqtlb/yPTW2ncDTl0H7hrHMy6zkNtLNMlCjKFL/wKWNz4i+2M2B5E9L1CAOuH37HyiVRDg8iguUZAul76KDyPeAzAvB/4M9hv7Qu50ua4K5QufVDQxwZS22G48zopLUmPacVjVy6PYm1e3R8gBqOoDaS8XXaMPOuzieE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update damon_commit_ctx() to commit installed data probes, too.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 170abba8fdf2a..2ab1d6dd47da4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -129,11 +129,34 @@ void damon_add_filter(struct damon_probe *p, struct damon_filter *f)
 	list_add_tail(&f->list, &p->filters);
 }
 
+static void damon_del_filter(struct damon_filter *f)
+{
+	list_del(&f->list);
+}
+
 static void damon_free_filter(struct damon_filter *f)
 {
 	kfree(f);
 }
 
+static void damon_destroy_filter(struct damon_filter *f)
+{
+	damon_del_filter(f);
+	damon_free_filter(f);
+}
+
+static struct damon_filter *damon_nth_filter(int n, struct damon_probe *p)
+{
+	struct damon_filter *f;
+	int i = 0;
+
+	damon_for_each_filter(f, p) {
+		if (i++ == n)
+			return f;
+	}
+	return NULL;
+}
+
 struct damon_probe *damon_new_probe(void)
 {
 	struct damon_probe *p;
@@ -171,6 +194,18 @@ static void damon_destroy_probe(struct damon_probe *p)
 	damon_free_probe(p);
 }
 
+static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
+{
+	struct damon_probe *p;
+	int i = 0;
+
+	damon_for_each_probe(p, ctx) {
+		if (i++ == n)
+			return p;
+	}
+	return NULL;
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_new_region(unsigned long start, unsigned long end)
 {
@@ -1412,6 +1447,72 @@ static int damon_commit_targets(
 	return 0;
 }
 
+static void damon_commit_filter(struct damon_filter *dst,
+		struct damon_filter *src)
+{
+	dst->type = src->type;
+	dst->matching = src->matching;
+	dst->allow = src->allow;
+}
+
+static int damon_commit_filters(struct damon_probe *dst,
+		struct damon_probe *src)
+{
+	struct damon_filter *dst_filter, *next, *src_filter, *new_filter;
+	int i = 0, j = 0;
+
+	damon_for_each_filter_safe(dst_filter, next, dst) {
+		src_filter = damon_nth_filter(i++, src);
+		if (src_filter)
+			damon_commit_filter(dst_filter, src_filter);
+		else
+			damon_destroy_filter(dst_filter);
+	}
+
+	damon_for_each_filter_safe(src_filter, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_filter = damon_new_filter(src_filter->type,
+				src_filter->matching, src_filter->allow);
+		if (!new_filter)
+			return -ENOMEM;
+		damon_add_filter(dst, new_filter);
+	}
+	return 0;
+}
+
+static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
+{
+	struct damon_probe *dst_probe, *next, *src_probe, *new_probe;
+	int i = 0, j = 0, err;
+
+	damon_for_each_probe_safe(dst_probe, next, dst) {
+		src_probe = damon_nth_probe(i++, src);
+		if (src_probe) {
+			err = damon_commit_filters(dst_probe, src_probe);
+			if (err)
+				return err;
+		} else {
+			damon_destroy_probe(dst_probe);
+		}
+	}
+
+	damon_for_each_probe_safe(src_probe, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_probe = damon_new_probe();
+		if (!new_probe)
+			return -ENOMEM;
+		damon_add_probe(dst, new_probe);
+		err = damon_commit_filters(new_probe, src_probe);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 /**
  * damon_commit_ctx() - Commit parameters of a DAMON context to another.
  * @dst:	The commit destination DAMON context.
@@ -1453,6 +1554,9 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	}
 	dst->pause = src->pause;
 	dst->ops = src->ops;
+	err = damon_commit_probes(dst, src);
+	if (err)
+		return err;
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
 
-- 
2.47.3

