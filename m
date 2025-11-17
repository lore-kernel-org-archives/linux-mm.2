Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C2CCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 22:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4FB68E0014; Mon, 17 Nov 2025 17:47:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9158F8E0002; Mon, 17 Nov 2025 17:47:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82BF48E0014; Mon, 17 Nov 2025 17:47:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 717FD8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:47:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B081B6FE2
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:47:21 +0000 (UTC)
X-FDA: 84121586682.08.275F5F2
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8064FC0010
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:47:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hPNYX5Gd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 39qUbaQsKCAEbdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=39qUbaQsKCAEbdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763419639; a=rsa-sha256;
	cv=none;
	b=ycbhpesrlWvXYh9Bb3cAVhlHp7eN5buCgvgrIs+7VTx7WgrQ0PmEuaLp4I+wgNjo3xJfpI
	3yGuD8FKRm0SLBqYDhA7VrekdLd/AXGO+ebb0YafeZe3JTRzfQipCb9Qr2s9rdO5zVD/4Y
	m2x54irPcO7ihk+onhvZYQX5w/LwrKs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hPNYX5Gd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 39qUbaQsKCAEbdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=39qUbaQsKCAEbdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763419639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgOprM20p142HerI0wr78gS0iVMLCiuLJeQSKJuE034=;
	b=Ns0nQJDwedv5z7SVx5sVW0oSU3T2DisPffGGE3PUhTLXzwzCuxtt3oZMWlGUbRCK+0qRu6
	yWliV6chSGpYOV1YBdznG2zjCjD8gIt81KnGAEcLbdVWEDlFBObqgC3QlRFC0yx4jokFLm
	pKu9xVIX20PXJmPog8gKFxVz2qjX00c=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b6b194cf71so6335812b3a.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763419638; x=1764024438; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IgOprM20p142HerI0wr78gS0iVMLCiuLJeQSKJuE034=;
        b=hPNYX5GdSl45epO7fmXIlCYehEMZRQ1huaGb2B5yV8NddFw0K0jVbpDACZ1nCHhgL/
         IQ6PzFYcBeV30fXKccGNyHqUhXhYD3CSmb9zghgKBH+4w0aGv+OdPcy+hC0jb6Gycews
         kgOx3VastraQNa6B3Ohqfsn6+3uTuLcDMG/49MQ5yCLVrDNX8vxpoMmGctAvcvlg+HsP
         VmPlmOSIP4G4+31H0OAAJX5ISBRHEHRXuneHgQfxUIy+kj/Y9xFa5O15R4B9CJGQrJa7
         lO+KOKNyDliPQHdFpnbm5QgkCm3G0IaD2o6It6m6ROnLYGJLGl4uUftcSKSHfWk9jjYX
         8XaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763419638; x=1764024438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IgOprM20p142HerI0wr78gS0iVMLCiuLJeQSKJuE034=;
        b=jjS2+mJ52p9p2NN71Ddwyj17S/DsqzYiAXD0D/3MjQN+QNPKnQ4uZAWQvDkDJtp/oZ
         YQS+xqDib6+NCcsjufkpqOOYIiSIjzGUVDkkkl5EJk2g7feLumF/c/wVGBaqlgPgZAjN
         HllKxfgZx84zeEnBoiSBjZCis3G2py4G35BOJpXxKDwQ1Xiv668MnX6Z0ee7A3RkuHDk
         4J0kekz1YM8sQHa367Gp5AsDan0h+ZrjXdFsidZMyCl4azm6cGz22t//ztZ/B/9+7hfa
         +HiIKOy8ofaJhz4T9RS0w6dNuyiLFYIpEkR7UKBdRDfTpsh+NotCi1MIf7Qu2BYoIuVO
         SoVw==
X-Forwarded-Encrypted: i=1; AJvYcCXZjIL74wJbvHiQO+pooh8uGaU9SeNexmh0mcudBPWyAO3minAlCQ+Afe0g2YYfAVo07DaFygAbOQ==@kvack.org
X-Gm-Message-State: AOJu0YzuT1L7AqooNK7LjIwPFN8rPHgX1fVy7T0Z7k803uiwyTnJfAAP
	PoKsirsplL5plDEPeZ73+XASTt5fTNnA+V/g8xSGPl8NT7QNUCud2eiitKSx6jdHa2CncxBaReh
	CGHYhXOAasLGHOvAwcwqiAiRzUg==
X-Google-Smtp-Source: AGHT+IFt4bVWCbvV/lEzgpQt0fY3yUVaqZMHxZy+py5k3Obvyp7sDCutsUiYmrIPPvg3OqxNSYChRny0dADI/4XOEw==
X-Received: from pgcz6.prod.google.com ([2002:a63:7e06:0:b0:bbe:55e3:6800])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a10a:b0:344:97a7:8c5c with SMTP id adf61e73a8af0-35ba2692141mr16860636637.48.1763419638413;
 Mon, 17 Nov 2025 14:47:18 -0800 (PST)
Date: Mon, 17 Nov 2025 14:46:59 -0800
In-Reply-To: <20251117224701.1279139-1-ackerleytng@google.com>
Mime-Version: 1.0
References: <20251117224701.1279139-1-ackerleytng@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117224701.1279139-3-ackerleytng@google.com>
Subject: [RFC PATCH 2/4] XArray: Update xas_split_alloc() to allocate enough
 nodes to split large entries
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8064FC0010
X-Stat-Signature: n1mpcwkk7yhiq3ib75cqd3554n1uzajs
X-HE-Tag: 1763419639-382389
X-HE-Meta: U2FsdGVkX1/uVBbq6T4gU/N8RY0tY2tM/lvQPDRDA9INAcSdJ18k/GGsqIjIgj7HPVR96MgfeuzMUbMLddrpeFifQyomgX7TAqFhZTxHU/bnjsB01FRxX5QNe5uK1e4kuCgG+hP9gmVHHc7mPNvKDFkxFwVazj6JzRZ25Q2uB4qnowSbgYDrRR3gHgq16Az35FTRP7/5Gfv2hotCZgLPq//4GyPbKfFVFgNhvZFqj675XnpXrDTGw+zs8E9luyFQbvnUwO7SL0ansYSsW1hQZw9WGG5tRinfRJ3VUkgvC1UHJkZHCAzc3h4GNdLAPN415s5VNDW4u6vz5aOIKegmsqIdp0gLQMFaznACuGnUpNXnAKwmIsyE+z7JEcS7uSYoIKDBhP9lNseb1Q0SNjrafbo5Gv8yeCHyOciTFAVljwq/CSe7xmczVhetXxNmVcgLZ4fPsMp56qw2yzZ5Ipm66N705VMH0Al4qgGGlo7uHjNRciPq5ysRR8qKa8d7yPaRuISWmAI8lllfwzriEIYHeTq2aNhDAf6JZRwJZz7jYNfjYpC8AFRmFPI3Tf0rwxjrgYxTc5ENMv2ZpU0lsRygpVatz/08ACBw7Op2jWen5ut8SEf4HWIe6ISJMxm5dyuOdPhvU3gn947aHwDMTXMcSbFdlB3U6PnszTsmZWQpXYGcSaqi7F2dJ9bStzs5cO4CXRbepZJ5O3F0BgrR7n0MOTXBAJIM9QQrs4MmPR504RzsRkE4qIRb1qkTKZ6a0MEZ6lnaV/mGBM5rddNJZwleZNLvpKrHqjGQ1VokdxOH9U3TJaL65s9eMHIsbcoNjL9uHpVwcPZJPOTSHWNOrI9RWKQHiXUujHJREwBDK2+dSvWvWQz3TU4jvtG2WQOyL7gfi+q291QCGlI7fKRwaawCIKbkRG0c+GQdkeJhQz/umtNj0GhxGe3edSEYBOpeZAeedfHXjtFSNicbo9lIIlT
 C6/pjPKn
 5ntbBeP1JD1iVmdHTaoRk2/1Z9SVVWgXNKJho3fZgKIRJN0pWzlDeP2HVm6NzQ+auWYKyhK2vSA50Z44NcBiHbMKaLyteFBtRhjfDOUBQP7uJGazcua4tc0DjuM4bWavbResJgQPytkHn0GfyOIR70R2M0b4bRg4u0S9yJwoltb2L5skiR1Bo9c02et+46cOnJgXliQJDC7pAKnARR5o1qOcrV0Tq+nvIjRwgEQxvsQ6NhgVAHWv7DqWrzZhzwGs6YwG6Box3Yz+fBRI/fXJTOYz4ljoXKlgU+1FJ+pgEeLVgGSKvOUpERW56iQj/ZlCuWF0667ofrgV3xjq4NnysGbKcxo+E+FN3/rjqRaDwWH62xYBcJVep5s7fUoqVl8+2T5XSxlts8MYmWTdLfc9DAiF99QcuK9QFps/+lUIlm9wgGAtWnt5/YMwUYS0F5nMHmwP3hHVpxhptg1gK97Bo7BZTFyrI8FZJTIhV4WKMSoGS9n5RQPYZdhAdc092P8yK4LkRIh7LS1nYW1SsIKwWH9SXUr/ChNRIGJSJgJ0olIV38u1aVDZVRKKtzYqUXIaFDRohM1m6owMh50APOhwidwXpOMP2Th7vstmb82is/E62Pp2b51X3Z5Bbag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The xas_split_alloc() function was previously limited in its ability to
handle splits for large entries, specifically those requiring the XArray's
height to increase by more than one level. It contained a WARN_ON for such
cases and only allocated nodes for a single level of the tree.

Introduce a new helper function, __xas_alloc_nodes(), to centralize the
node allocation logic.

Update xas_split_alloc() to determine the total number of nodes required
across all new levels, then use __xas_alloc_nodes() to allocate them.

This change removes the previous limitation and allows xas_split_alloc() to
allocate enough nodes to support splitting for arbitrarily large entries.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 lib/xarray.c | 52 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/lib/xarray.c b/lib/xarray.c
index 636edcf014f1..b7c44a75bb03 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1028,6 +1028,27 @@ static void __xas_init_node_for_split(struct xa_state *xas,
 	}
 }

+static void __xas_alloc_nodes(struct xa_state *xas, unsigned int num_nodes, gfp_t gfp)
+{
+	struct xa_node *node;
+	unsigned int i;
+
+	for (i = 0; i < num_nodes; ++i) {
+		node = kmem_cache_alloc_lru(radix_tree_node_cachep, xas->xa_lru, gfp);
+		if (!node)
+			goto nomem;
+
+		RCU_INIT_POINTER(node->parent, xas->xa_alloc);
+		xas->xa_alloc = node;
+	}
+
+	return;
+
+nomem:
+	xas_destroy(xas);
+	xas_set_err(xas, -ENOMEM);
+}
+
 /**
  * xas_split_alloc() - Allocate memory for splitting an entry.
  * @xas: XArray operation state.
@@ -1046,28 +1067,27 @@ void xas_split_alloc(struct xa_state *xas, void *entry, unsigned int order,
 		gfp_t gfp)
 {
 	unsigned int sibs = (1 << (order % XA_CHUNK_SHIFT)) - 1;
+	unsigned int shift = order - (order % XA_CHUNK_SHIFT);
+	unsigned int level_nodes;
+	unsigned int nodes = 0;

-	/* XXX: no support for splitting really large entries yet */
-	if (WARN_ON(xas->xa_shift + 2 * XA_CHUNK_SHIFT <= order))
-		goto nomem;
-	if (xas->xa_shift + XA_CHUNK_SHIFT > order)
+	if (shift <= xas->xa_shift)
 		return;

-	do {
-		struct xa_node *node;
+	shift -= XA_CHUNK_SHIFT;

-		node = kmem_cache_alloc_lru(radix_tree_node_cachep, xas->xa_lru, gfp);
-		if (!node)
-			goto nomem;
+	level_nodes = sibs + 1;
+	for (;;) {
+		nodes += level_nodes;

-		RCU_INIT_POINTER(node->parent, xas->xa_alloc);
-		xas->xa_alloc = node;
-	} while (sibs-- > 0);
+		if (shift == xas->xa_shift)
+			break;

-	return;
-nomem:
-	xas_destroy(xas);
-	xas_set_err(xas, -ENOMEM);
+		nodes *= XA_CHUNK_SIZE;
+		shift -= XA_CHUNK_SHIFT;
+	}
+
+	__xas_alloc_nodes(xas, nodes, gfp);
 }
 EXPORT_SYMBOL_GPL(xas_split_alloc);

--
2.52.0.rc1.455.g30608eb744-goog

