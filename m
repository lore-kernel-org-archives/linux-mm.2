Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEBBDC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9B16B00E2; Mon, 21 Sep 2026 03:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C13A6B00E3; Mon, 21 Sep 2026 03:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188CE6B00E4; Mon, 21 Sep 2026 03:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7E496B00E2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:58:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8ABED1C2C0B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:25 +0000 (UTC)
X-FDA: 85237016970.04.520CF8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C698040008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l5l6xMLr;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789977503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYCJwCjTojZoMSg1K1fjM/5lK8uQavHZIHSOSFY3WTI=;
	b=OFiWsj7vxfYjjfiRXHxDTyougHYNapoWle6yGtUBfFKCcC2udHQ3sTmZNsiY7OYZImxuuJ
	xtTh9PC5410cnJYGYITM620754GkoS+WKLrNPpWiXBpDK2zkQ8DO4e07C1s1SX8DYfW6ZU
	tZkPZYvYnnbDjUywqpj/fwiK0lHNFw0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l5l6xMLr;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789977503;
	b=KKsaQU+wFEDIisDKXYJSWQa8Xo7zffz4xtPtiJl43nUaH4kTfaFGPxtZ5O3BPyTJTu5vyX
	/MRDYj3BzonNTFBo1jjtmjLLU6A6AxIvNjhCLgcm5fIPepZU5/MCltr+MmQuBwJ4vGHEx9
	g+CrXuW1B/GCQ37f0Ll+SSWWCaKznMQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E522244FF5;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30A71F0092B;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789977500;
	bh=NYCJwCjTojZoMSg1K1fjM/5lK8uQavHZIHSOSFY3WTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5l6xMLr+mdsyD4v9Exth0ro3zP53iCdhEmLvIqv/LW76z/hhaaHJOsgHfnUWXIZ+
	 GrnzjyQXahhr94V3EyvWJwwhX4xXN55NzWW4lpD/CtK0uRf6PfPC8XxSzxp0FfCpnt
	 xyz9yUy+4l5YMv/tWafJttCsw3tx+I6jyPbWuVjkH1/6SRaQvoLbO715gjAw1Ze8Wx
	 bH6sLPxEJTj6YROx4jOtMDMQy9vbJTxIY2/KuP9pFMtgx4qmMFjUmfodEasuIIfQMM
	 6mWXurW0lopmPAjxJnZxWvYuLY8bAis2OPiOKTuxS/9u3qCpxQleshG2Gnp44ctCqm
	 Zuw0hGkOFp+0g==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	netdev@vger.kernel.org,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 7/7] net: skb: isolate skb data area allocations into a separate bucket
Date: Mon, 21 Sep 2026 00:58:18 -0700
Message-Id: <20260921075820.1718334-7-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921075811.too.775-kees@kernel.org>
References: <20260921075811.too.775-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3388; i=kees@kernel.org; h=from:subject; bh=YbmMITYuL1x/iTXXiiC6TtrZwPTf+P8ee7ihm7zXbV8=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkbHs96Od9twi4pFTetfSFhyZfmVrMo1B9ll3bbeJ/t7 pcFHYp2HaUsDGJcDLJiiixBdu5xLh5v28Pd5yrCzGFlAhnCwMUpABPZZc7wv3rT2r5XJVMCz6wK vqIT9T/GlW9Rd9/7p/57/rs+yFdZ/I/hf3DgwrXRchzeZREev01/vRJKDn01aQmLgKWqcFv/nrn H+QE=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C698040008
X-Stat-Signature: 79my7gkzgi5uy4bn7tcc4p54jhky7qz9
X-Rspam-User: 
X-HE-Tag: 1789977503-671192
X-HE-Meta: U2FsdGVkX1+AElXwCacjhVjAyFYF4nNC/bgshDQ2tkW9i0cECEo1MZbC/wjyccGPtmn3b0ipg/UXeqtpfGKhkaB4uOUpVhzIjnyC990m9gIWveslI9D2e/ZHi5gr+FSo8wUgR5zGzqOQ7V0JLQsWUZuSxYmn4IeUSQaDhmjFFdiC9mzYE7uVkVgJgwEDq3m1sADwfM550jsGI6h7W+v4EYSqOLkDfHldML49O9IXo8Ac5BNd8TChlhYUU5AeZQa7OMEgPHlar5dvIvdLevUPNztHtrpUiW+ndGRwfBrND9jClCdnU4kV/voOMJSrkbkTH/JrOAoEnpWGweyCrYF3Q459go5tZ6rN9yRNLSYq8ww7ZuNIbHdfL8sLxL74vWH7cb8rvEvE080IZ5+mxup+xq6hvYPJk/tDj6iEAoA36Y4f0Vxfk9vqfMcByTXWRz71wF4GHGNfUY+FPH1LU/x+08Qy32D+dtidRx0ZqMxAfhnc1iiEcz/K1w4F+4v6K/HyOWZSJ5Q7PQnzxFXStdCK6LcuGs+r4UZJDfm+6f5zgPoIpyfZVvl/K3fSAxZRpCKzKtpUVjdT74cNc4DJh1Q2S1scvbzQm5ptAp1HoTAgR5R4NOr5djTxS1XUP6mb7Si1dygW7VhNYtERO8y56RoKLKfs2Ob8zLhlWpkr7LizuJQIlaFMWkIAUj50VNL7WPFDfrrq063lMJpF1nIINl9oKYJnaGIkEhLc8vJKnYozn+0PwZHriQwGpm5D/OWtgkBcSHABYGZMVRYRck25zmysSpdXQ30FNuNnJ2bt3Iu9C37TisTVlcdtv5KjDObL+JEJDTeuTUiaHt1iYWLv7qm9TqnM84v6sKsyIaKihb26S3QKA7jgKQ+Kv8U4v7ulnrYXiju1hg6s9m3KfGq0WWfPuoP3BnC2RFnCOeuG8DUFNXfSfqaPCGJM5jVFsEqol3B065lxITbauBt0IA2slxi
 gxRaD1bV
 LThrsqOFZNd+ARnmjEBMVn0JpwJqiKOEDnKovOuUJEFMYcX5yGadiaJ7a9DnUlxnTP4pAGay2aANh4pcBnTkbAEwG/w4XaW1bqT6edqGXO+cOIRM1dki2ZhGKTfs0xV2HQgvo3dAeFebJYvqV6qKYDqHyMGW9vE5vXB1ensB8OPGCKv4H0rSOtKY5Z0xY4AY7hoG2ZdQEEPLQV5b6HRzXCv8nrAjuTd9sMNgp8jWFVcr5Zf5itgSqtPcHPqvJ5Psq+ykYsuS1TOuDciAz76SoG2w5RQIGu3kOurzNKL80lXXHGOnjrXm/oknzujJCM13pv1tPFC5QJT1pWm1sXI86SrzkUuPnWRT6ZcAIcrflVpK80RNtJBmMR3hpCkzFK+iOjkGbiYMEYNiT98yLdW/DhAD93Ga9v/htWfDF3KwYOgQWqe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pedro Falcato <pfalcato@suse.de>

SKB data area allocations (as done from alloc_skb()) use kmalloc().
These allocations can be variably sized and their contents can be more
or less controlled from userspace, which makes them useful for attackers
that want to overwrite a use-after-free'd object from the same kmalloc slab
(which often just requires the sizes to roughly match into the same kmalloc
bucket). [0] is an easy example of an exploit that uses netlink skb
allocation to target another similarly-sized accidentally freed object.

While other mitigations like CONFIG_RANDOM_KMALLOC_CACHES exist, these are
probabilistic. Use the existing kmem buckets API to further isolate these
allocations in a guaranteed fashion, when CONFIG_SLAB_BUCKETS=y.

Ask for the accounted kmalloc type as well as the normal one. AF_UNIX
sets sk_allocation to GFP_KERNEL_ACCOUNT, so without it every AF_UNIX
skb data area would fall back to the general caches, and those are the
ones most worth isolating. GFP_DMA is left to fall back, being passed to
an skb allocator only by rare devices.

Link: https://github.com/google/security-research/blob/master/pocs/linux/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jason Xing <kerneljasonxing@gmail.com>
Cc: <netdev@vger.kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: <linux-hardening@vger.kernel.org>
---
 net/core/skbuff.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 966af3beed94..865eed3c57d1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -586,6 +586,8 @@ struct sk_buff *napi_build_skb(void *data, unsigned int frag_size)
 }
 EXPORT_SYMBOL(napi_build_skb);
 
+static kmem_buckets *skb_data_buckets __ro_after_init;
+
 static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
 {
 	if (!gfp_pfmemalloc_allowed(flags))
@@ -593,7 +595,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
 	if (!obj_size)
 		return kmem_cache_alloc_node(net_hotdata.skb_small_head_cache,
 					     flags, node);
-	return kmalloc_node_track_caller(obj_size, flags, node);
+	return kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
+						    flags, node);
 }
 
 /*
@@ -634,7 +637,7 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 	 * Try a regular allocation, when that fails and we're not entitled
 	 * to the reserves, fail.
 	 */
-	obj = kmalloc_node_track_caller(obj_size,
+	obj = kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
 					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
 					node);
 	if (likely(obj))
@@ -5235,6 +5238,10 @@ void __init skb_init(void)
 						0,
 						SKB_SMALL_HEAD_HEADROOM,
 						NULL);
+	skb_data_buckets = kmem_buckets_create_types("skb_data", SLAB_PANIC, 0,
+						     INT_MAX, NULL,
+						     BIT(KMEM_BUCKET_NORMAL) |
+						     BIT(KMEM_BUCKET_CGROUP));
 	skb_extensions_init();
 }
 
-- 
2.34.1


