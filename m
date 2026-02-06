Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA8A9EE6B69
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1EED6B0096; Fri,  6 Feb 2026 16:43:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECCFC6B0098; Fri,  6 Feb 2026 16:43:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD86B6B0099; Fri,  6 Feb 2026 16:43:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9DE86B0096
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:43:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 386A0C177E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:43:29 +0000 (UTC)
X-FDA: 84415358538.30.F71940C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A49081A0008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:43:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U4NlRDtD;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770414207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUrAd8iGiJWWzJk+XvDmhDYDR3i/4tUUap99IjGkiK0=;
	b=y7J9/ZyIBTQ1U1cU6MRckJY4t6QzVQuvo1THotoqf34iUGcuqVK6vdjY1F09uNNxshsAHs
	+eQ6o/7F4Y4RwSPcPHbzn1X2dfhMtTB/tDGZWj3ulGuEVJ2KIWOe91yijYJ2c4p/tZY1GX
	2kOUr5fpF+YOzx5nVoW1wdCjDkXgKe0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U4NlRDtD;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770414207; a=rsa-sha256;
	cv=none;
	b=YWdxoNwL8X0UMHlZwXoOYXc2ExE/hmyz8guzJKJGCyBHIt40tHYoa89Y9Bes5qzNYCV2q2
	OVeGHPQ7bF6vk+QcR7Z6QuIc8ofQAbOucj7qa1PSQdQ6lKoJJdNpzFWwYsmJHKS8tkrC2y
	+wVdi1biitHqr1B8wPgll0e5NFaGN94=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A69560137;
	Fri,  6 Feb 2026 21:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42824C116C6;
	Fri,  6 Feb 2026 21:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770414206;
	bh=NgQfAJHzVJF3x25o6e0VGnyxpkVMB6vbImUYVyuSsxg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=U4NlRDtD9s/gTCacHwCXha31viLPKHOqvB4N2P+g+m2Kx77f5fR+S/sxo/+JbRPCf
	 XXd0vMBthXZhVQl/zLrF6lsQbz7wy883crvpo4sYtOwyknqWxhlFv9hlOQ2Nba6iyc
	 ccwJnQT7dPFQ8hIF3nzPQ7NKcrkLxEfkga3OgAW1Z7BWlep5Plsprdl0nZYKlpajsX
	 I5XgfNVdu7F65TL9j3L5dlRj4vjXOBUKijb/D5tL0x4/rktMS4AHYlop8dcG4E1pit
	 s/j5l2MW40kZk7UR9OL8Q476vIaYDPDXo+yOxxmT+71ldU1iRkHhsrA6QDMAlje0uF
	 IlbLXySC7+xSg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Tamir Duberstein
 <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor
 <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 11/11] rust: xarray: add preload API
In-Reply-To: <20260206-xarray-entry-send-v2-11-91c41673fd30@kernel.org>
References: <20260206-xarray-entry-send-v2-0-91c41673fd30@kernel.org>
 <20260206-xarray-entry-send-v2-11-91c41673fd30@kernel.org>
Date: Fri, 06 Feb 2026 22:43:14 +0100
Message-ID: <874intpmz1.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: q1mz9db4xwx9n9yz6z1u3g663bb8ggbp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A49081A0008
X-HE-Tag: 1770414207-557525
X-HE-Meta: U2FsdGVkX1/0cyocC1L62e/yPIWJoaowJT3ylJXg3h9ESbJ7eIhRjCaZjvO/OykPVIFuY5L6D/sUtSi53c29XrA205Kd/siJA9OkW8hs9DZCs/77dzKP3XddSS+aWHexasGvQNqmNryPCYzUCBaYRbsor6gcFibKa38zyMQ9HyD6C997x3wUnR0OsqM3KCr/7osSTYn7Lid/7PgpYcy1Lieot7bsuRD0BY+1jwexpHB9ZDnzwnvgzhR0N/adT1fhkxhf+Uk8WTnpiefSyCtkzaDPUi8KoN61ME7KrStIj/pPDQHJIn8lgNFY4vfbzjQG74o9wPeCXSzTmOOQBUdZ8d05H88nVtBpesLJxtCj++uBmMyNLGlEhsv/xzsrLPxHBG2x1Hbkk2NlM+ilQqRNF3U/kWcQ2DeiioFfD5NdlMPn0979z2r9oRqnAjtenXLMo2QtrnT6npHvSDeV0dBEVi3Xw+0qptkklBUvJcvjNh/2x2Xfrua9h74of3/kFbaFUjsxzoNxCGNY7Boz0vuZ+5VUEhoP6i+SyXwAJj/aeRhEz9BNPeMI3uLM/uFXXSRhdVJMoXgr3AIb3zlGEzJ+sCGIV6qSpUZvIUGzxgPJ4kc9RSljIjKFA5qKKz33TExdKmnkWY/Lj0rofVfDL38aXjfPCBkTNAqRdUeEz+KvcQLkpIt7TYToSODsz9cJN86JjH7T1eRTy6D6UH0ZBVSTYBuie14IiekOXn6ssTUbZtmruxig/6zRQpFKggYkfalrHyXnv1xtny8fd4vT0YFS/SzhG8uFc572UNZpY26IJghOmdHuKjufZ97BRRbJ7qGvbdIEyUEAH8Ttt6UrG30L6eBZ94MDUsMK5p5t5NhxLbyjMUWmQ8GbknW8swRmf/WGbMUk9GVoSQdZ2QZsPh3b+TkUhs5IVijXNtvbcx7bHYTrXRo6xEx+jPZl8QHVZTReGgMtg/C2wRN8t000Rn6
 asJZKzz1
 ILGZDkRmITqsARFBr7ipd60+Jj9MaXrYopDfvQnJqJJaiQeA3SFkoRwxsoYltjHko8/YzDauMJ3fwPcAoPgJkxg6pXPYmVXC/TnypiUT00lugt5Js/YI+A4/XvVuL/1D68/EnqKn6PQZLkQTZowSRCk3pQF+gO+xkXTpYxNlmS4dIL1f8AeCpYZlMaMIBVkpRr9Hpz6efZYcvJzojWxeB2sqyzfBHoWa6kgd4YgL6RGA277fljjSLL32hfxShqFDeWqIgsZVXMo7cSC/y5nB19b2E1J42dNoKMemMDLbbxD1rxIcBRy7m6ML+wjEE5bnJiqc+m8PiFRWybp3x2alWJcRf8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andreas Hindborg <a.hindborg@kernel.org> writes:

> Add a preload API that allows preallocating memory for XArray
> insertions. This enables insertions to proceed without allocation
> failures in contexts where memory allocation is not desirable, such as
> in atomic contexts or where reliability is critical.
>
> The API includes:
>
> - `XArrayPreloadBuffer` for managing a pool of preallocated nodes.
> - `XArrayPreloadNode` representing a single preallocated node.
> - Integration with the entry API, allowing `VacantEntry::insert` and
>   `VacantEntry::insert_entry` to accept an optional preload buffer.
> - A new `Guard::insert_entry` method for inserting with preload support.
>
> The implementation uses a circular buffer to efficiently manage
> preallocated nodes. When an insertion would fail due to ENOMEM, the
> XArray state API automatically consumes a preallocated node from the
> buffer if available.
>
> Export `radix_tree_node_ctor` from C to enable Rust code to work with the
> radix tree node cache.
>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

I somehow managed to not include this last bit of detail:

commit 09bdfa18f6f879eb42df2e032ad5224eed29eb25
Author: Andreas Hindborg <a.hindborg@kernel.org>
Date:   Fri Feb 6 22:38:09 2026 +0100

    radix-tree: enable sheaf suppport for kmem_cache
    
    The rust null block driver plans to rely on preloading xarray nodes from the
    radix_tree_node_cachep kmem_cache.
    
    Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index b642f2775e89c..ddd67ce672f5c 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1599,10 +1599,16 @@ void __init radix_tree_init(void)
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


Best regards,
Andreas Hindborg



