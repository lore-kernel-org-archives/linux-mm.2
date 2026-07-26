Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 186D5C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDAA46B0099; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2326B009D; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2BE86B009B; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64E416B0098
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF3361C0C6A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:48 +0000 (UTC)
X-FDA: 85031640456.06.D2A6DDD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4B764C0002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CIoSfqxj;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdtqE3eR/Bua/rulOOI8NT/gdSWbQwN4dD7fIeQTAXA=;
	b=7aFRAOhJ7IPRocJwZIoCSQLC7VciHVFQ/DJbIrRxyhTZZ2A4oXL7qGqjzfI7biSfJkvWJO
	qeWT7q/aOBYuTOBCSm/uK59SggkWJ6yUmWMBexBGURRx1zVtLyPHweaPmyEAt0EvrbUbI4
	iXFUXnWNLqPVnM908oHB6lhwioKpNXU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CIoSfqxj;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087587;
	b=Lkr9M7SOfqCO31MSArpHc62tkOy7uYRv0s+rggF4Dkm1u0eGqVlgtq8iGdgFb73rGUjYG2
	TS5Byoffsb9wOjKuVxD1R7zRvlzq2oZwby00T7c9MtN0v+tej5NSiPzTgVlVixBuvkNO+C
	Z/3UDjPbcZ/l4amh/uCKBclYvXAFf7k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FB0443986;
	Sun, 26 Jul 2026 17:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CE11F00A3F;
	Sun, 26 Jul 2026 17:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087586;
	bh=SdtqE3eR/Bua/rulOOI8NT/gdSWbQwN4dD7fIeQTAXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIoSfqxjUBinYECNqaAKPTCwdPb+mcPBFKnd5kHpoo2YLqD8O7DrgrG5Phm0SLDmN
	 d9LQi7tf4ZdPtxBaHtqCcOgH7uwF+Ejd7hM+yJfze4qZ0me0JhzvOYHw0SROOLDcVF
	 gwEpYxjpmh0167DzrwGZNxN4J6l8xbEvGM7db3kLtNSOuEMB2ZbBfjKeGjkWTkQiLg
	 e1refQyyjSLXG51R8XX7I6loRef500CjeYdFEv0Hkxk55uYXwrLmiAlvgQ/+bNWzQH
	 AT3cbcTH7CxXtKiUYp+S0mZO//fhBw6jNpAGBbPq7yve8X2f8PVP2aYRPgXiwZtwVZ
	 Wv3iNVvIgfXQg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 06/17] mm/damon/core: commit preps
Date: Sun, 26 Jul 2026 10:39:22 -0700
Message-ID: <20260726173935.94046-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B764C0002
X-Rspamd-Server: rspam01
X-Stat-Signature: jguo16h3sot7acui1ww11z1k49xpac3q
X-HE-Tag: 1785087587-340617
X-HE-Meta: U2FsdGVkX1+P6TRnNBcJNLis8BkM3NiGhZ/KD6iavABZIOUapPd5ysNyz5YA3qLjKVD6il5G7oSbH4ouml4bsnjZW02YQT4hsI60zHZ+A8xgR7c7BccZ4dcQw//AjWC8EDviLWfrWZKnTugJ/KG09E5ZSbMoMZmY9PLoHur/C7RG6XPYdHAFqNog97s65jVG4eb5rLLiIlm+PPtDCTesom6ME+40JNKVy63c5xH4tQGCmNVAxkkqVcgtyo1RKxALg7lyQrepNq0iEEUq3LtYTe+BACDyh3XY/XwsspWw2/FMdx3thMCL5UR9AnU7x2ueu6S6q7skrswJm+QEsSsNgOVXxGx1HUXTC+vJ95fO+BKYT26XHNk/csTnSxQttDqwssP6xo6sjC7+/McD+EoO5TcsxSIoUBm33fjD97jsSU5tJAJ3gsoAeirLTYyw5HYMhYZJ6M8yHVUYWTevHY71QaAQ8SIEBeDp6g7K0JSn+Ulvk86DIECxlltwhJ1qcJbUbaQSPNwpW2WhOmnlx4/aEQ+dg8HVkTe2Rr7AfwZLlPqot2HM4jH1x6sKkQ1LFsDmHiq3rbKgoQvtNDUDyP2w2b+Q5Q8kj8lB1iYfIHIK8LAUANOiDqiYBH0iKU5VFbBG+ftvHf5CSNpNrOt4HZ+cJTMsiHMABFjnahkthWWD8/w0e5+qhHqU/fzVTU+eUsF3wP83G4mlDH2wrmDtWMssF49FHmxVkZ9QMQdN696ICRxeyBZ+Lr3seiBufOmRY4HGEBtFvw0uXt0k94smskUG+HJcaya9allVOa501zLky05rH68dWyBp5+uC+aT3GpPSEVNkafiWWWuva3d6H5PPTdnUvPSgW+oKV4hrrU9VNTSq/tzvsEkMRoRewTzt+2GGNFUXI6tHnwNdEoqewwhOsFfK1TRZOQvTQ9rWWubDNlwcXThk9zT3KfkWzDQylNEAh6qR4Q7mnjVk4w61Qst
 3I0+ahvR
 p8khNVm93N7sgHOQ1kpvEwEDAywk0jaQJluuLwnDZdDE5SZaaM4RK10xxh+gCfTzPHVL2ZPsbVdl7Ivn5GhZlqLg2hYjo8N5/XU22vtb5jqiW/DgNjEpX1VOmR1rWytpub8oOpcT8psdzRR7ZYNIUxVaT5AIOPc4yoFDuQt9fl7kIS//kdWkTQ4ad1jtkA7pXuJwEGNrvSEilCL2D67Gv5ByvPfuodrZ0NbnuCaLW3MAZXrY=
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

