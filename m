Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C31ACD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421356B0092; Thu, 14 May 2026 20:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3844E6B0093; Thu, 14 May 2026 20:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B1E6B0095; Thu, 14 May 2026 20:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED62A6B0092
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5C5712066A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:49 +0000 (UTC)
X-FDA: 84767809098.19.075F451
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 10DF640002
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DEag+6Bh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805888; a=rsa-sha256;
	cv=none;
	b=fk8+tOkiNt8DX3/zoPS10liMu1H2GBQVIz6xxlK+eL8+gfp0oJkoBZ0YIUcdoh90cOMJhQ
	4jatewopptwsBtq9AkWazpwC3WkFLgdMhXXJvt0tc4LqhznVF3njBXhWUhDIyXiQyoOUzD
	26hUWWuQ5s1FUEhZdLCyupfWtXL8vSs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DEag+6Bh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbLTta+n/2B7cSCaNQVixe7WPpk1eixLe5YXsr8Icso=;
	b=cAqIAm1GYAu/z2z1+3fWstlY1/of2AQbKCvFOfTBnyU2SCV8iN7aFE2vQ2K5vIgeFWUYUD
	O0JJoPyUMLITbl3LOBDxexP+SO2K59uHDgKercoJMQEW9HDZqTZipZbQhTA1UkwVdi9OR6
	dtIA9i1rrpzGWa+14PFc7Cc8I/QWJBc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 947566132B;
	Fri, 15 May 2026 00:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9C6C2BCC7;
	Fri, 15 May 2026 00:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805887;
	bh=V8jJ5epB+GwJSdNuM2GEIbS33YAdZRISnffFQmMwTmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEag+6BhvYJSw028G0t8O1d7yqMVKyRpjB5E1/J++lmoTA6dpKdJ7GA+oy55g7Uzt
	 P36DjO9aKIfGSOHQO02aTSTwlbYPGqdIb4o27ZP35TqAqYVrYqZzKVvBlJdGoqUouj
	 djw/KLj7Pz0GEzKb3FEUMg6jRShh4QzrXGCybNfyAg7Y/ON5A73IUmyQT6n1+9zaTt
	 8JPHmzr2j3QxMqfiDVY7XK6N10BiSiAbTPFLIQD0SWxxKjMgIbE+V6hYxPF8rwyomp
	 NyfMWJz8PEejdzfsE31a6iVkn8H2mTkEOfsWTKT7T4ZphdoDaTXREaS7Zl464B8sil
	 Fk3x1WDrDjGlg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 04/28] mm/damon/core: commit probes
Date: Thu, 14 May 2026 17:44:05 -0700
Message-ID: <20260515004433.128933-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oqhq9xwc9hzbqqqgh39bssampt697xfs
X-Rspam-User: 
X-Rspamd-Queue-Id: 10DF640002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778805887-114531
X-HE-Meta: U2FsdGVkX1/uB9sCidxk2UMxoQt8Iq+8vox0Hc9pQPPlWqgtHkO6Wbruh5FLJ05lFqWN67vQ5R7fLbeiw31ZVhTUNxG25mHJV+Qh00//YlCg8FqQvcnLOraCffyWOiQ9FYeqO9kEbyRM9jIH+plB4eUT8Ve8bUtWzJIiMcHtSmYBa44ucATbayFVvmkYZBZs/JpmXzr5JWJiFZDMSkAVVgU8sNMLKNtH7MnXi74sZ2RYgiwjegknVHlt4t5UShAPFn3ELGumFfJDgXY6JXX9OxF1WPiXAuJ3q+9jsPx0Ya2+/59xOcat2LktIwgQtAelV6AoQBc3PxOl+QvsTKXX/Pe9n4dLdXnlJ91KtkaUnhuXj6XDTMGMVPJ2YvbQo20HrSMvi5WHUlgqBFVgNpcDZDQF9KRX90lOInMnQabigOFXh+kfriyDNbdGZlbThqG29Lr8k01gA589qyCxSyGxVLdJmiHq4EZut1Y8a5bM1PuyeChz3gYiFlH5gYQIVGSO6WyBz7os4b0FLhqTdhB//TLUn2Oi2uUxpCpgky5FeMLAWLz/odrMJxjw9Co8i1pbJVHeLL+GKi1RdxExg57ZO0ntxya3UZgtSXJvx3lQI+/4QQo3qYC113fQi/uV7zMHDH0UqayiLMb8VXFrc2Xhze529RZqWGa+BzLl0sRiqQfQkhlnXXlvPVG167nVaucX+4P71o3ioqkhkT8eLF0NVI1ytQIzmObijdT652KTFjy64SnyhwNKtSFBUkA/D+B6eqGmJwp5J0gi5n9Wt57a6ZioZ16c9vjdBHe5sAtJ6OqNHfyNh+GGnk8FBAlHnmFejaFq649vU6bVFOEbeR3AbINTLw51WQrWC9/ws2m13kwyk+t2JUkDQ62kRLyC2R1KwRZD3zkKH2Sk8zeqELbrIj8pGrSak6lr1KC0JIEwMAa2yVp+V14QlleBPkLvz/BKCn4lKTHLvusRVWu8gci
 4gRPIw/x
 tIo5B5Je1oeC7xXKyBbySNdsyYXYSQTAEcFjnpXBoSpkpObeG9t9LZbDx3anmYYJOf8bd1w0sitYpPeWM8USxveHz9/pu4PEEBG9y0iCd9PKK7rzM8YlNj4Kp33VtgVnUAEt5TEL/Mq7PjtJnJtiL6k+J4SfS1aVSUmLB5dj1vAwqK0QbKPttSBTwvKo9QaJ4ZtgpP1yP1MjWgd5HE85zrxobt9mU6sHoJTsBv4RI5GXAD+c=
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

