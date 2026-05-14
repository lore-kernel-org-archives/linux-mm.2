Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF316CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD38A6B0093; Thu, 14 May 2026 10:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85C26B0096; Thu, 14 May 2026 10:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE876B0099; Thu, 14 May 2026 10:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 988EC6B0096
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D74C402D7
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:22 +0000 (UTC)
X-FDA: 84766207764.13.2A8EC5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8C973140022
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HQJNRZb2;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qEscwrNOdzu6oYO6SHyp2t3bg4C47DzpGWWecYRMDPM=;
	b=XVEnJVtjDLZRfyv79uiLcS5Q4PcNllNI12ahotIS6umHYRcJKUL6qkTFEhSL0gLAlt4qnF
	S0UvPG8B27TaGKyocRQf0RxGtQt5qT5FXcHwDzwTy30Eq6fXCGFbc0fKZWWnQmers98QCy
	AfMGf5+cd690dQ1YF4aDMR6O01LN/Fo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HQJNRZb2;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767760; a=rsa-sha256;
	cv=none;
	b=7myuytCl+dd6NG+wdM2qG+m6nRs7+hARnZ2jDBGJLxZf9IYbnuRqqVmfo+Qvj47z23gLTe
	hhMtAFgYDI4GKIw9NWXgeKyp5yif8ZNGyzDGppGVK+KNMJxTfF55tXcRF81mnrjYD92G20
	wwN3ePTNix5vGyAn2aA5IlyBxniLZFE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BAD6840AA4;
	Thu, 14 May 2026 14:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CEDC2BCB8;
	Thu, 14 May 2026 14:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767759;
	bh=OKhmfytBqX/7un5Obh/JeNbzocTBgyUdokH+J+a21+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQJNRZb2LOhOv9MPrBaSH/vW/xNDxG+H8KWs/SDxYfn26FuLEnsevq0zDgYrAE8U+
	 iXjI9FYG/P93w+0KYdjlDTZ9NMaE5yUU5eBxp9wBtB9LMwL+lCAAZHCtTkS6KFgHeu
	 0djGWX+qRnF3J02UQ/c7OJ8H/atqta/+LVrf6gIqLwe495LyEVrgAifAS3mp5ymayR
	 KCepoPo1wbTtHDmFDPs4uw8WqcZEnv9oOFbxf5Rf1pQIURZpy8yRoP0v8XL73DlwwS
	 K3SdOYLHT9c2paeEjU0/AEP+sIfYUGbHCW950rPjFJTJSmGbjGdbeEttoKcNBsG9ZQ
	 +gH2uUCwW5tLA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 04/28] mm/damon/core: commit probes
Date: Thu, 14 May 2026 07:08:37 -0700
Message-ID: <20260514140904.119781-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8C973140022
X-Stat-Signature: mdrwiokm3x8rmjpfr6nbm11heuyrgpfd
X-HE-Tag: 1778767760-113123
X-HE-Meta: U2FsdGVkX1+WsrZsGE3w0z7DralLq5Nt2vHIuuDxWXSeib3pvDNvMxXntWV4BxoF96VaNaQYFF9JOHwrP64N3MeNXbYhPGcn2eIx3cfspouQODpLJ5jvjppgKnI0ycu+o+OmO8xGhP0oPJ/k1NUhEKEHfDvKCixitm3Xy19o9c3si71GCcFWMRbIN3hjA3wsIWmIM3QeyRYq0PToBWv159OIQAsP1midul8PlDovL6bLIjnZT00GK2+YlZaB5TQ04Y964IyAWOCUdmIC1mEnzT9UEgIABAsl9UYQx8Xp/Hbi/SWljryM/WzOpoiPfrLFutAw4jXRn84pzaEDKSmdfSWDXsumHx+RUotBVypHacWw6GfV9RFNt6XcubRGfWIq9PWWWm9le7A7cf1gyuODNHxUD77LBN2Kzdze7hxQ0M5AjDIrm+pQS69yuh86FTMyUTIm/W/wlbxfS5IE7SR9u9Hxw8xEBY3xFZ3MH1k7arP01xhSNNmHlEV0u+6j4iJDRtRBqy8q1pBbkqOAY+rrAzNhvh+3HoTUIx3dTOKkvMt+fd2NNn8Xl8Z17U2fq5FhRhoUp86aNUsi26tyVaQpon4QVKRefMPUNvlgcBauwZ5NFTVZPXbyBPRYMn8Gj6I0fL3laZmn5Aru9SmLmBChm1GynQeHl1pc2Sh1hmibg/TNbkVLKugYNYjWYSNDNMhzjdwXzqcPrmzT7Drm+fJZWjIMywokiOvTNRq6C6+apiRbL9iU55ubjCC82jLOdWkl/aMvGmQE4xsPHR8IxMyTg59WCdn0sLXinNKGQsnCM6TY5AL0HFuKC/EaBNNL8vrBvbMSbAnmSSMQjcT1pA1DGrjUFibPOiwiBZ2bj8BbIKn+spHydAWG6bE5xcAzVbmfGMuqyQAOMttogWM5gRmEfHuoefJ9m7lEt2EqnpoHXN5kXhQJh2oezqeGpdsSmpSWHqdTK8Ezz7y2u0DnBoL
 Fsikj/dl
 kT+sdG/nkojd1PZjx0mdbHD96+BYF/LCs8T3KYABQdoWkBus7wbtOqeLjeIHPo0tA98TiUWcPpJxjeOxYCDFlKAew9wVCCxOvzpNWyjJxQ1lSfIgjgdzlTzgUb/2Sb4iz1j4MIyBm+L+HmCj/Be78tfm32/tbURL6GnhrB+MBeL2NLbroJOx1NH+EY2Q5JupYCRarrQ9xPihIQYZ3qx08JqSqUoTMMDtah0ys2OArBpvfgZ8=
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
index d01417955a3b4..240cae1420c12 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -133,11 +133,34 @@ void damon_add_filter(struct damon_probe *p, struct damon_filter *f)
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
@@ -175,6 +198,18 @@ static void damon_destroy_probe(struct damon_probe *p)
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
@@ -1386,6 +1421,72 @@ static int damon_commit_targets(
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
@@ -1442,6 +1543,9 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
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

