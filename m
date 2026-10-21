Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 264E5606A335
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EM4SfxUP
Received: by kanga.kvack.org (Postfix)
	id 98EEB6B06D6; Wed, 21 Oct 2026 07:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967026B06D9; Wed, 21 Oct 2026 07:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833886B06D6; Wed, 21 Oct 2026 07:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58CCB6B06D6
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:47:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB70E1C2CEB
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:32 +0000 (UTC)
X-FDA: 85346458344.04.DD370EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2FDBD20002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EM4SfxUP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2+QlAU91iW8vdzYP4e+NTj6CSrh8UAuZujBTeOhXewQ=;
	b=4Xk0zL8S1P0tAjgG6EvX/+eTLyXKyx69WroNN4qwEECL370FCKZ5C1/QJjWwR77/tVlRPs
	DAOVEDbIZy8sp8KgnP1TBI2scahUgPnNcoKxHprldwUvs/OXP/kRhF3EeTloane2A3Ixdb
	NK6iJuyX08xb98vTLyckxKKqsq0tnCU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EM4SfxUP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583251;
	b=OjjE8EizJV0l6eO4bQTXrlsqpwIIH07N0aaemy3PyFzFqWTx/cYEwwu9+oZqjPPmg6ayIu
	ZSytL1RSqH+zjW8MKwqGAtg+Lmcjgli2ZR4wgFllO5MTFzZFWSKD7HS/dk8w0Ldo/oLRNM
	1k1IzEJ3TkNmNzX4m1FHPEqyk0Z3RpE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71A7D414D8;
	Wed, 21 Oct 2026 11:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292601F000CC;
	Wed, 21 Oct 2026 11:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583250;
	bh=2+QlAU91iW8vdzYP4e+NTj6CSrh8UAuZujBTeOhXewQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EM4SfxUPPQhjHei94lxELC53m1/3Tey35zwsz45f/BJ1R1p36Hpki+CNSGunclV7W
	 UD2+EtUoltIuBI57uWe98SrZTZf6/Sovk7sIsCTapAaEg8DXnYz2U1EA5KsilVKJ7z
	 X+2GwxmWwyPah0+6/VsIp3ExsBw2WLp1lGo0vU8F2uVLGf3S3LFa5sxHjo5Adbv16C
	 qII1+JmEE66LoxGxKk1fdI8+lkG6xD0OjgXk8n8pn+8wxHI7tliLPE4i9eGFFeqPyr
	 JCQAIANeNsNIAgD6Xk5MrUCfYdVwxqWwScDRgeCXSSxVHgkDL2DbnDj0yrW+QbHbEd
	 0yHdDF+XGttyA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:43 +0100
Subject: [PATCH slab/for-next 02/14] lib/maple_tree: specify
 SLAB_MAY_ACCOUNT for maple_node cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-2-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 2FDBD20002
X-Stat-Signature: wawjcsiigqx3gb7tffoyam8apzsjnsdk
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792583251-947079
X-HE-Meta: U2FsdGVkX19EZ4GDvQjK6lh6EZHD3Fss+E7cR4F4LOnS3/zSj7mkgZnkCaWMqLNwWK69xr+FK+ZUQnhk9cNwnubJWscxpkx5HApXB5cVueFVmOhPSC89FJc587q3sxQ/RQhFNhb1B6DsnyyhTYqNIT45vGI/iCEQbDsLmwfaSjt8qeMmkF6N0ZgLetOHBTnHzkQSgbxMQ3nYM+raLhHj2A1GuDpecGVF88ywmyFdoLFGnvm+hxp0SJDsZRtfPEJHXB4NCoFmNy3Kvdy3nltcbVCqk+UqM6gQXiSlCdoIy92dOGL5tFJN1RnRAny73AkvNGlVf6q790hJRv5ur+Og0EIvXPra2uLKefPHBcojjN0LAW75pCO/zmYC6b97GtCHzbO3cDMrCD+kNVtadYerZPIKFxsFMHbQdmGKaTlKBWbMRc5BAGPY4yNp0GvjcOrj26eq/8SrClrIJ5yczk+vwBsS+g9APe8+Q7BRgipF9nN7LETW0OkSNZqoLeWgARfz7+h9oL7wmQH6GAT3UCq6sLMFxvoDu2uYNmhv+mt9yEOypygBY+lYuBF/sagFh/j5F4uTeY+n6QOgTBG1OLyFFCjufo/YeihVCF3pnvCOCrbJq0XJZlKZSb/1X1GVTHVfTQc4nU7MzKN0oe2f55hRmW3rWDaA2A0pfcebbXDZOB9xx50EUNs09A9jcBPbBfUIurnwsDvl6Uk7BE5HO4EtJoRQ771uvULV58jBC7lt8Pxx5L4orxy3Gki8U0LlEi/tJEoq9hypiG7bjlkPQLx4oneU2dIoct45AmAYZyP2aCHT0PrVlreAzxeFWr2moGW94IO25fxoT6lHN8Kmnbeny+8vHIWOSnOrxIMmr0OT12500tgJZuOJJ5LRoNwyvpfnVXM+Cv/ks5bD666jOT7Y7p5BZntTep2YDeoa6o45jFjJ8bdK9XshCCyBlQEGHlBIEwqPPoC//wwVhNj4zur
 2efcK4AJ
 qC2qa/qZhUlT84FfF+zlHrna+QC07BDrBOZUVDsSsvEUoTmGfHYjclCKO1Dw7MfsUm4NJi7AvcHmvjCxje949DSmbhFG6OnWmoKvImze3dKX5mFz60+GDjVP2aez1M3nW1s2osk+Pqmx5iBnNYPswLzWbSQcyS4d0CObHStexLe/WmvnRiJNkiBi+Lt2RF1tY9zWTkAYz84r9pGTUwnldTVuD9Qo9CM5u5Qk4LsCt8u1nGfCQEMs2ftguUws6XF80W/ZfcJAMpbop4v3ufJylupFpPxhWb8mAOB0wH5FkR3Pc0fbb246v3yeG2teB/l5g5PId1LBcgYHOHzZ4w8z6rgW+ZP75JadqPiNeeSGyGYB7xd85bv0B9av++bxsUPiAXjHIab+olyEmmPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Maple tree users can pass accounted gfp flags down to node allocations
(e.g. arm64 KVM's smccc_filter uses GFP_KERNEL_ACCOUNT). Specify
SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path: mtree_insert_range(GFP_KERNEL_ACCOUNT) -> mas_nomem()
  -> mas_alloc_nodes() -> kmem_cache_alloc(maple_node_cache)

Assisted-by: LLM
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: maple-tree@lists.infradead.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1aba6cced713..e4794b31e5bf 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5790,7 +5790,7 @@ void __init maple_tree_init(void)
 
 	maple_node_cache = kmem_cache_create("maple_node",
 			sizeof(struct maple_node), &args,
-			SLAB_PANIC);
+			SLAB_PANIC | SLAB_MAY_ACCOUNT);
 }
 
 /**

-- 
2.54.0


