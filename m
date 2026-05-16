Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF54BCD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51FA36B0093; Sat, 16 May 2026 14:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CFF96B0095; Sat, 16 May 2026 14:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4606B0096; Sat, 16 May 2026 14:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14FF56B0093
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2C15C1AD0
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:28 +0000 (UTC)
X-FDA: 84774140976.03.CB14AC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 00C8440005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qOtip+Gl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbLTta+n/2B7cSCaNQVixe7WPpk1eixLe5YXsr8Icso=;
	b=QXLH7IBejiB9jtFZ5mQdFRajwGUNEvQdLlSfZgx0+gOzbG6LqBTACN9l4+d+MQmhFaSOZS
	/+wSz31YTRMgaoqFX155Vu88PLraNn3TGYb76aiKdv4z7lXeMgFZIfvUvHqP4UKoKUDOd+
	YzaYt0MeZs3WwLyZeN37TqqSoYhwpro=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956647; a=rsa-sha256;
	cv=none;
	b=rACapmZ/KAR+3OqH/vF42UR9rrXTuvnitoDY75rQYt2D6fIABcfE5c4KLgk/sN2kQ+dGoQ
	mpOD8dcx9kh4pyMO6r9H3b8Ol5vUirx0ArmKHgCFafAWrk9vorWtAg0orNvpDyPrXz5DUn
	davewvrH0oVtxRIScSjwQIaO7Lr0Fro=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qOtip+Gl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 099DE44521;
	Sat, 16 May 2026 18:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC68EC19425;
	Sat, 16 May 2026 18:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956645;
	bh=V8jJ5epB+GwJSdNuM2GEIbS33YAdZRISnffFQmMwTmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOtip+GlGcL7t+EwZKaXQLCFr3xqYaw6Nr7cnKzQx8xYPrpM/kcr0/SKrhOoXdd9R
	 qSMDoMVaNhIafdwL9hQJrS2zuOmif8M8x0fijdEbOY7uHc4EC3sviPgpdH0ykggxqs
	 +yxzhUe0GAp2cQJZZWbiKoVMvirqkmOUSX3Qb3oDUTE+ua49rpCaGet76F/D9HWseD
	 zrF5N2YeDxjXzagdJku/llY3r7HYFozKsbuktx5eghFwgg9GWK6yRQuitFw4XNbnE+
	 x+Y/kJHVQ2D5e+Jq2aut+xzkdzjruvzrH0XmudSYlbNRd3kI62G8oQHwqjKNlS3UZ2
	 Vqdh2U+rmb4dg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 04/28] mm/damon/core: commit probes
Date: Sat, 16 May 2026 11:36:45 -0700
Message-ID: <20260516183712.81393-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 00C8440005
X-Stat-Signature: j1n7y3bf8atzdxrca9aoz3qto1iejuke
X-Rspam-User: 
X-HE-Tag: 1778956646-547059
X-HE-Meta: U2FsdGVkX1/2RWswVhoH6cV4Mrbu2dG8old73R/kKmO29GTeym5uj30hMUGzvqsrltFfVVTInK2jbS+UHeTY/F1P0MY8EJ0YEck3E2r+vsEsvnwQ6IO5mHo9zhILUSVeccae9JeWcSMUd9sg6W4rTChC++mdOqWVHdtT35qXCAvrymEprQ1Peh5fEzCyV3FGTRCSfaGmZlIpo5mz6HP5NhdKiG4vSH25LwtlxUUTI1qmCCJA18Ob5/cO2FedPB6IIYUPVLQoU4nQy87BKm9K8WGY+0laugxu4BFpfxzIsTF+wMZwZTXcmrOnO251uSL/h9OZSDpNG8gkZxl4z0wDUQsTmAdFibSEuPiuxAcDw188jqP4Y5G70WtOYzcY4sw7Nt0uoRWicCmzBeXQRtWjjTUvqSd5KaeBtm/Gv9DlYbRpLN8Myz3ZJpdVY95hc3m0EzFfjjISq7hVn3kCpbVJJrJc5woqGfJoWKnsxbSl6ArlSUr6ZJ0fJ96erivZF5kUZ2LxvrHDJJqUZXndZztZxH1uUZPV5t79azgvvgM9Va12ulnp7rL6J5aLAxmpTksZP/K0yQWrRxOVLqsH712EBOEtvFxixzXllJFzcXPNpoQXQHxD0fa4ZHKkg25Ey7nYUkis1Ga+omYhcJfy5+iAW3gL2rTrDSli9NHwDDNvoVI6Pt75kz7m5uYnsYbrHNH0nZW0uIwxy5ybbw6xrYbDGVVdpElSm3Qsyu9FfuyqkXfeSRF79LDnUyOH4ISRjQZSFiwnuLJYxKlrzZfUz7o5BKn5gYE78HIqgn/Irk0uU8VhU6K8Q81zAji2i074IN8ev6UNae/+eU76g2lNNkQU0M5V6Qc1HttOUV03ELrTkpjozacRH4qs74Pvc3f/uVOPRax+FKbbqyX4s+CiOIsrycOwWsiKM8IlfBB2rY4uYCqmkVKuCZtmrL9MxicJ0+f5/cWu8GiGtWuq4rX/KVd
 okg5qyFv
 rSiOoiiNtNKif1zyvG5vcT8wi8B9uuUmY+b/iaJ+bUw3hjF4d/SPkqOqsKJqRbwqPlDarNXPGwzXEG+8hOubcf9V/sXQ3xYbCJYe3VV7xX8XGBytY2Jy/E5N9Vy6nPAeJJ3vRixPGmQ1BfbsWTx4UwH6fbQZluIa2RHett9jcqrqywr8QENfN6dBpxRWkygNUkTHmNZSRyGULryO9kE/devEel5qSV6CqbabpWJMjh6cBfYg=
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
index 44943d654dcce..15f2795a1156f 100644
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
@@ -1378,6 +1413,72 @@ static int damon_commit_targets(
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
@@ -1418,6 +1519,9 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 			return err;
 	}
 	dst->ops = src->ops;
+	err = damon_commit_probes(dst, src);
+	if (err)
+		return err;
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
 
-- 
2.47.3

