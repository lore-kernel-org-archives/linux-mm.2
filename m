Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 974C3D3B7E1
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5C4E6B0012; Mon,  8 Dec 2025 01:30:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0DA16B0023; Mon,  8 Dec 2025 01:30:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4AF26B0024; Mon,  8 Dec 2025 01:30:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C22526B0012
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D74F13BF06
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:05 +0000 (UTC)
X-FDA: 84195328770.26.B230EFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E492C20005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIXLTVp7;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P/GatQzawiRVOwDD76ziPTwekmn8Gf3vA0FAXj3N8q0=;
	b=dUtWZBFZFBfhU5I9s/hcURFnRQjOaYye9c+Fw03Nc2iyQPTChIafj8Ghq1MdNxndqmFJfj
	hmh3NocU+/Gg2Uk6M9s25jHvYPldie5T+8x3Qb0AHlX/VQ0ES5sW6gyXosgpiwcLp5noAo
	6GNI8D/qEQuz+iaYUd3cNcbE9DmwtTk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIXLTVp7;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175404; a=rsa-sha256;
	cv=none;
	b=ZVpljVXBT3mXMxrRQJyt8Aca5Xaa2haSivIL2124jhO6OBMOnlI9o0gpQzoFi3n2IkqhDZ
	VvWpusbRmXWPCJiVzEE0iWFvozzaqkz+h3Cizq1P0IfRCAv0urwnFljhcREVeiaK2/4cY6
	TcJG8UGLiLPo89vnNd78wNpfUI9BThA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA3CE40571;
	Mon,  8 Dec 2025 06:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F03BC113D0;
	Mon,  8 Dec 2025 06:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175403;
	bh=HqSr2dVJCwPH4hyJgJqnf3m06RGc89x094A8SJ4rv+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIXLTVp7/6bmfAS4G3mn84o+NgRZe3aM4W/0ATsBaPJzAgWfWNp65xQP4uEu1kdg0
	 eUpGG6eFBBMNmeW6wAd++++tZOEbSTTNVxLqwrcCzUz2kidF6/9WUWaaielwjVdNp+
	 Gro5lJ8x5IxhUltkdEspo/9xmJMmARN5eKNuJg5S7gzqrXqqyRgfyPrWQOcmDn3z9S
	 EO5af6uaHfyA2E1iz6nDyGmklI35B/a+ZnsuEFhxUgcb2IJHmEEz7O/YtuNKHy75fI
	 3lCfVjr1NBlLNIXLR6AgKS+mlyr8jVC77Z96iJCPNPTSRALlrP2uIiv4ITYocQ5lVF
	 p/+ec5asC+fsA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 10/37] mm/damon/sysfs: connect primitives directory with core
Date: Sun,  7 Dec 2025 22:29:14 -0800
Message-ID: <20251208062943.68824-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tktsnsgjo83xio6jo5utpeasjhwyqoas
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E492C20005
X-HE-Tag: 1765175403-517617
X-HE-Meta: U2FsdGVkX18TUZgw6n+IYkJI2pmMraZh/pLImGvjf0wTvrA2slIbevMkj6A70eQcDVUjCNfCBzAA6YJVSSOvpN+Je1kvlhZ9+5WzajGt4vj4mkqEUdzkkcGhlqHxmXXUhTS3z0yb1pdBJhGf5O9uPMhQGr2pjywS3iyjYBI03CJnDXKBkotvw3ycMD0m4G3gbKDpge5Rq1IEVGuLOCUOq/0hYfMljNVscD4Wv7LZAGETv2u/kp6IkZRu8jBQrwDKXedBjz988zeo0hyWcN4jCyq6ERYVqYmYZDd31T36z+2NjVjLTIgyiaLG8QmmLAh9elq+G1sT31j63Y+3IWHb+wSyQVDHoJBEjfP7kP9luPfWmdR+fMd0FrqPTXVXGf7LyKFX5AncU/G/ADqtZrZE/QUS8n2eu4K53vSf9tf5o3un9+Zdt+yyHgZLML8Q07ekz36OjzwSeM6FQl1dtN5VR1mo3CQ4Ul5Rq4/xVry4eDbzy14mWRWJ9EjYA1CGOynVqajPws9NrSr75ERy5cWEDKBQpPnHsdGCLD83QQfdpmZxRf8KrgilyV4HTakiWn/TuHMJDx28pnXE6ESSezNl4BFx/YhYF52iiG5s9WtAHEL6tqCsKgNOcHOECmxcx14KhPwV22hUGVG8PfD0Xzfa05uMRufa7MOIylbko/Zb/bc6KrxPtaZBoym6KKjCGBV3EPyAUxNOtpRC070X3G8ZwaOrOn+haOl8xEs2Bv+VDzFAzkfa003b9hviqCTJlFjZemc/m3zGR1KkPr9mCjAnqNjU6g/2UDth266Tl5IkG8+EdT8a4hp2RUQHSkdc0BAC4Z6fh+PdmnZtkjGfanU5HpbXPYd9KfAv0jTdqKCisjptQnQ4pnRXbwnPzbGxJQFu0ehtxVjNItf+F2OOp44BTG7OnUR4JdiBEwotfk6/PfIN7pv+A09BwlmNiFzkydy8yRZ/Yaxak2vLCGpJ3Gd
 dmgeKNaQ
 bCWEiX8vByDgTNEEB97RYJ74uRG1xLpYad6eEAVHwDJPjE5nXhnRtlfnNkTyGIuRd4CsH3pOHtl6d7nqtHNy5EJsDoyE5Y9yEiS/yGsPrRPXZLQomwgfznCVCah4s3vSuZ/1brFHtEeeFoQkj2y+Aee+Rh6pndg8qThHLwPKqw8CmRGgCBgAnMb9CbPnnRUrWllJcVwYt4cMl++cGOykQTRzsP3MuksoFHkaSz5dmch2V6K8s7BewTT4uEACfpbhGMLqZ1ZgdyqKxDJM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The monitoring_attrs/sample/primitives/ directory is not connected with
the core layer.  Make the connection.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 14478fd79953..16d58cde03e8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1640,6 +1640,17 @@ static inline bool damon_sysfs_kdamond_running(
 		damon_is_running(kdamond->damon_ctx);
 }
 
+static int damon_sysfs_set_sample_control(
+		struct damon_sample_control *control,
+		struct damon_sysfs_sample *sysfs_sample)
+{
+	control->primitives_enabled.page_table =
+		sysfs_sample->primitives->page_table;
+	control->primitives_enabled.page_fault =
+		sysfs_sample->primitives->page_fault;
+	return 0;
+}
+
 static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 		struct damon_sysfs_context *sys_ctx)
 {
@@ -1654,6 +1665,10 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 		ctx->min_sz_region = max(
 				DAMON_MIN_REGION / sys_ctx->addr_unit, 1);
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
+	if (err)
+		return err;
+	err = damon_sysfs_set_sample_control(&ctx->sample_control,
+			sys_ctx->attrs->sample);
 	if (err)
 		return err;
 	err = damon_sysfs_add_targets(ctx, sys_ctx->targets);
-- 
2.47.3

