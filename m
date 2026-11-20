Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E544D606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M7xirJuz
Received: by kanga.kvack.org (Postfix)
	id 055A26B05B4; Fri, 20 Nov 2026 08:11:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006B16B05B5; Fri, 20 Nov 2026 08:11:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F356B05B6; Fri, 20 Nov 2026 08:11:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEAF46B05B4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:11:20 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D9E7160F3D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:20 +0000 (UTC)
X-FDA: 85455533520.12.1DC3E0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7D134100007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M7xirJuz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180278;
	b=8Wwawjgt6CRbLmHk9G5YKheejju/Emz7RTkIiA0aOpqz4d4C0Q0LQmBk36IVING4cKFuAq
	W/+rHj4P35o1gT/sFHaTwaWqJuVEF+pY6Wf8GqxMI9llqvq5zgWxESNNhF8ftesnnGNhEY
	Q23UlXHMWDCBXtu/e6oDhMbS4TfHJkU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=160vS2fUgreh2TfeX5DPq7qpDcpzIYMArC2L5k9SgNM=;
	b=gXDgjA0bH8WjyQbsgdp/ishf3Nxc+ua8mN2SS3qS4a2Wzc8jKmWg2FLj1WAyO1xpW/C4wu
	x3RUhFQde8boNoxwgKb9MwoBnzvOyIqq8uzaLIeFuK7+467x572eIx3FHjGK01JsEKPn3j
	sW71jXuoEA45eLWXjH1VeaBFugU9TWo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M7xirJuz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D52DF436E1;
	Fri, 20 Nov 2026 13:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870821F000D1;
	Fri, 20 Nov 2026 13:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180277;
	bh=160vS2fUgreh2TfeX5DPq7qpDcpzIYMArC2L5k9SgNM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M7xirJuzZ5oA1ievdq2Z5HJpO6zfZY8Vw1LWWiCMZdvJk/yYJe2E2wKKVkEcq81lk
	 DuBKaDKs21me7ZGk7j8C3eg5ljwN6ZOd0D+8uwY3w8ydLP0VpV2YLX1tOQlczuTdzb
	 jKb+LcI/ahZRDzBRBh+zGEK3TxK3SImtVsiU91gekIHoWWSpew/rwPhhwKahaz6CBE
	 v9wFrdYVDjhtX+woHg+UPtEC2T18Ww1kwjH+pnqrnTMhODEdWtdV7sz0zYznBZ99qw
	 YXv/efGovJMjhpYknIeuFdbyl1rE09jfcK1lm68QB9nVHR2cCf+IJaj3Y6Ud8h1AJE
	 OQxra4ITNG/0g==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 14:10:21 +0100
Subject: [PATCH v6 10/12] xarray, radix-tree: enable sheaf support for
 kmem_cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-xarray-entry-send-v6-10-1f69d7385f70@kernel.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
In-Reply-To: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1241; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=P1Sxf06ssHf1MjkVVG32ZjziE2PXVu4nAet8QXuksZM=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrAEbMHxjoltvdoQ0tnj6l/F1QLYjH67WwokRyZ
 IPDAfggC2aJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawBGzAAKCRD6UCkIqsW9
 0E8XD/9pK5/gJYEgpSSdAhk3TcyQDq0CZSln331F2mWlr10c7EDtGcbOulbVg/kz2SfZvICcVgI
 MHr8SAG80LFTcTObqyfDSBTIgObduDMWcjvY21tTHQ7/bX5yuDgC3WaM5Azgv/1Ed9LYe0O4ENl
 GcNvLaalgFYpOVTbSvSW2kkaN8KdG7OYlNKVNZDRgXCMOqHk4ClSGLTEHflEsWI+gNwEjmUvc+1
 mS3KdZ9DmYoyX+341dMNha8x467GMeCne5W0RpoccYNwFdKz6efyAMFz/afNEqrKp8TidJeHCs9
 EVV8298HN+uhQkygODyeybv2J9HQK4XnY76FT4hNNOuMzFW0VPRme4uhFadlur/JJy67eeU552u
 FkoJNgiYsYogxMVIKA8V1tKxc1STFGR12biLiwAPSwBje4XjowtDL3Lbe6SEVQFWzBATQkquxvp
 2gbRoi8uEzErLbsW7Zi2NJoHUFgY6dVQ978GdKcZwhgynsHP9nqJ6A0ILiNARmm5JfQEkMJb7P1
 QKAeTQFTSLQFqD+kCsrO42jvkL9fqFlBEWBs/cYS5KZtBzMiG9kAVs16EqdMU7PufpP8o2RHC7A
 7njqjDReZdsSjqnogRpCbfar51tJc2bhyE9AtoDUyP1z30RESpXUAMEu4fhdRdhnuVpGT80J8Ch
 0MiOVM5xFufz+KA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 7D134100007
X-Stat-Signature: 6aachh1ax4b5a6kcpkorh9c6bkhdrrc5
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795180278-461132
X-HE-Meta: U2FsdGVkX1/N6RhfOkPqU5+3APvrg1abwqOoepAzgLS1uUCiq2yingKlmEB7ezcyNdd135UUF3lssN3nHjg/AmUNi59u8Xu3IlnAiqu3NQcM+Uxbjisd8P2Xh9jEeENhaDi7H8fvhI6KizT+CkulzbYAfcriKEPKyzeq9m5aNF8XJ13tVvuSj8sn6F+w1LaGUjVZCWVqh8FLgPafACDr2tUQMcYPeXSNDN3FDcUbx+1iX6mqQMB+9YUKw48wFOWFoqkmdCQLkY7TX3bkLthBgJHHlSfCiInHqyRNNKcaDMCptfafbFUuh/PwYK+HoN4Hm7yL2gky+tV+Dllv/ROKIH9rlEgenFT3TjffZ4+76YevSpu9Ebu1xra4UIwIi4asfLIoNHcVoL4oQuG3y08CUpbUKuqGyAvM2DHhyRMvfGRda1yZa06xph92ruz8nQZEhx5Nu9Ekkug/dln3RQFHBAmbzJVsHfKKJvIHXUwKdkMz4QDS1NcdhQg7HgzP3g6MVYAVs/lh+6D72lkck1nSJZzTtIIgjYMwGrP7BaPq4iwTZSrLYwEmlHdE8ye9ew6F3xPnG6Pq4wC2tM3wS2ZqDwr6rooJX5z0iDrPQ12ATbFfBed8rtFijA+Kt4BAx4Ws96KJz5qAKTpg62nd9aXxI8WLo0GyjUIkqmXSWUiDMBHzoTdmWfexI3lNbCnuNCpz1NDPTFd7KDHQGP509d+Eedrb5nwAxZBOu5v8wL/Uba6CLcpufqaU7vt4YRN48KCiCNyhiWflm0TUxNg9Uw05/9dVQSd7gJ8sIilW3tq581XuRCq+f0GqwEqITP9Jl7HyV32eCWYilG+VNv6gLqRrv2ZkJbGWlA6i+IGjFBJC50o640h27Dkh7LT+h1Q/7Uvc75dRpnVxDUm+igjV97G2C2la9boqjmP+QBjEdtRxMQc7hF1dVbR0i7Dd6mTyyCmaHXGbt1y9f0efcTuxwd1
 Rl5y/GUx
 x2pGqp68aIMJd72G6VImvSPXqDNCQR4xRME6bxCBMpExo38dGSyxuRBh+Cppq+L1Qk10ON3+CtLzwvTjUwkmgfREqzIF0orSIM/B1TfmmiDfJE8rka459FfVHJzN9STTZ0PuEQnk6ubfCkfprrnZHj3f7yVi+WW6ucLsN9wlJBAaB88ZjLZhemqYeCjLzvj8aqyPWTgVFZjOfwUpBKwlISoZWYD29aY2Z5nCeldiN4Egg6UgwBi2pNfnKhs3dRTO5KSlhdkSQFiplftDZzX3FL1s4ozFcjOIw93aHVStbijrb5zcg/aSJGTolz89dBePPUKAatxgnjjtxPEkqs30962ZMbN8oQg92iWxlqlS0IVG0EGhm+jgkmU2d9DxW6TOu8YIorGu52N8RDiorZ59ZSO53lB+7lUg1J3rgg2I2lqkDEuhGCNSpXzjGspJZC13SINArmIgHbaoUCvwVKEam/JtNPHpDoa06/VhyHbZmCXJ7TH5ai/pwQKK2tzHsoEq6om4/Q4fJ5MhdV46MI9JC7B+Cp1kxnp0w2QInpdB5AkhTPqk3NP3qzEZTto4I92euwp8aNUAE7pDH2L8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The rust null block driver plans to rely on preloading xarray nodes from
the radix_tree_node_cachep kmem_cache.

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 lib/radix-tree.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 976b9bd02a1b..1cf0012b15ad 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1598,10 +1598,16 @@ void __init radix_tree_init(void)
 	BUILD_BUG_ON(RADIX_TREE_MAX_TAGS + __GFP_BITS_SHIFT > 32);
 	BUILD_BUG_ON(ROOT_IS_IDR & ~GFP_ZONEMASK);
 	BUILD_BUG_ON(XA_CHUNK_SIZE > 255);
-	radix_tree_node_cachep = kmem_cache_create("radix_tree_node",
-			sizeof(struct radix_tree_node), 0,
-			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
-			radix_tree_node_ctor);
+
+	struct kmem_cache_args args = {
+		.ctor = radix_tree_node_ctor,
+		.sheaf_capacity = 64,
+	};
+
+	radix_tree_node_cachep = kmem_cache_create(
+		"radix_tree_node", sizeof(struct radix_tree_node), &args,
+		SLAB_PANIC | SLAB_RECLAIM_ACCOUNT);
+
 	ret = cpuhp_setup_state_nocalls(CPUHP_RADIX_DEAD, "lib/radix:dead",
 					NULL, radix_tree_cpu_dead);
 	WARN_ON(ret < 0);

-- 
2.54.0



