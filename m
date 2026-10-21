Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939FE60A2638
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ER9CSkf+
Received: by kanga.kvack.org (Postfix)
	id 76C006B06DC; Wed, 21 Oct 2026 07:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7437C6B06DE; Wed, 21 Oct 2026 07:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4866B06DF; Wed, 21 Oct 2026 07:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37C7B6B06DC
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:47:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27EF540509
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:44 +0000 (UTC)
X-FDA: 85346458848.26.0D6AD1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7FEA8C000B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ER9CSkf+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ko/uOWW9MmVDlyLdxGJWgtr/ksS4XAjHrpz+xNjK37M=;
	b=Vv3lLpMllTsDyV3jwEA2a2BsYG34Qhj9Q69nf6grVpaHbcpOVF1yCCb+S3LuOXdveP8Tii
	4a+27KjmcfNKPaK7n1aDVVRu4HyneA9kQ784Rq9JDha2DdkGswJxwcyG6F8gJzL7/3yYH+
	S64nc2SHQh8R4XmaVtcmDkt56vijwDA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ER9CSkf+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583262;
	b=GGhxJbqqMllNDDRqGNtnEswPAgUerR0K6qvPrZfBWazl2Tex8E0CAYeyrU4iA0dSS6RyZJ
	+uC0hO1Ap/r0o9S51NOm8F/7eipBfqlVSfD2QLjSjxHxHROWHG+63DdT1BxBa6tq5wz8jt
	2XNI3Jqw+nccWy6aSjvwwcZ/eEboXIs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2099260210;
	Wed, 21 Oct 2026 11:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E051F000C6;
	Wed, 21 Oct 2026 11:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583261;
	bh=ko/uOWW9MmVDlyLdxGJWgtr/ksS4XAjHrpz+xNjK37M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ER9CSkf+A5Vu8PQAVZYvXDfMfptAvyV2alH2rkS0jPl0vXqowyTHG01tf/DX1Zo+V
	 RAKWvHyE8bi0yWDTE2/+wB9lWEHhYwd3DypUKdNADqC8PX6TRpaxLAMJS7R2VofTud
	 G01klTdk3Yxe0aiws3DBE97AIR6LeNpoeY+5tfr20hxJ3nzZIOBdewXHTMXNOX7wfp
	 Z+BwSD40lJ891nYzcdORZl47QWDeaPN2cmxJTuWI5Q3l6NodgV8Z7VGpusEHEEHtF7
	 37ZQ4ONsmkm0o8paXV25QXRVmMgMcWHHcsqDB+U6oR5dobE7ZzAxFmXQxfa0tfKnNw
	 Xq1vtwpJAaAMA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:46 +0100
Subject: [PATCH slab/for-next 05/14] net: skbuff: specify SLAB_MAY_ACCOUNT
 for skbuff_head_cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-5-096800aa3330@kernel.org>
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
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>, 
 Willem de Bruijn <willemb@google.com>, 
 Mina Almasry <almasrymina@google.com>, 
 =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 7FEA8C000B
X-Stat-Signature: pysypu84ery8quho1reupw3uy1ec5o5n
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792583262-494106
X-HE-Meta: U2FsdGVkX1+Nt2xNU8ufaa9CoNbc9zfHHmgacpBoACK0es/lKLFxQmkygy6d5SsaRl9576TnPwwin7/HEYfrftZ8Hxe1/ewbVJlQtgqgnx0WO4deBPGmwy0eJuUqG4MS8SgNvbGfkkJWTLWMNvhh69bvKWuXeydFgfzjsIhYnB0YRDuCeZEfcZXii7bV4nh/2Emxubav6rzoyUKGK7F4BZHAjKbzVTNSbvITRlbq9Y5lnG/5yEJv94DJCyrxfnfRlI6VIRV5BPUG4AJhYH//84iktal36Ku/V9+5Gd6B593Tt/+bSG8DBxO1QOHvupQTjMemTIXyCrCVyeirnihppW5NBV6GSEuHcTxSnI5zrQ0iI5f1DDR065yqRMZ1h5JgjCiDvaRyEudaG6q8bcbcKVZMju3jVWULAQNIjEPN0Q2PxS4vgzfIvfodI8gAyJd6ZRGFM9ieH/NnBZITN7azEUUkbSiyDK/hfTopzNzFhigkSLhN5DRuHbjsW+6pyh3AoC/cHATRbFWuAOCoMOOLNxl4a8sd/ZQHdTvhg+ctQHhmmo4A8jNRtPmvmNa+exaHo8zy43jXhjpcagUYLfQlhNuLTOPDcunYrETy2A2BpitkBwJSASsvH9H+Ryoc+MRulGVB8QwH5V25TUGFjAtR93JYjSNccynHJ/wPLRV2GJrSdtZJlL4hJjpkQbxW9hmHrdfAhO6+y7f9/39MoSZqxoJdhpE0GFfqURamfeTVzbfapXHEv6IcDEsK+pRcF/VW0iwl4/KL8vKk6JdpDz4wQ50lgX8ZH2bPyZ+5h62w3W8EkUaB66VViIFLcCvmUf9MhqcF38bKqPCzjx1+EpfpDR9WAy8RpALTuAL0X6WVJeQDrjEsL4h16VxlgJi7mm7V+nzFZaPy27QwCp6F2diF6v78FXvPu+HZKKAjVUgrPKcjvMkkmfkmbuEd/Zn8oaulk3jgmjDyqWDHLn3oc8z
 aNvDRuFB
 ug5wC0ycJsunCWxieQ7/qzr9pE4hwUIR93UAgjWAKGlZtLYu7AyOvMbpbhhFtJ/VngHqkgOq14ywuKVSNiHI0YhGhUNSyljQwtrxAqmum1kdwIyeVzqX7soqKCJ2snsYHyimGu92wFak4EFRv6kWTkEKgu2W4nJu2zo8ocNT84A+5XEOdLl1iD7cwXvwKsLV/pF8Xb3krk0zuHhEVbSC/6Db7a4NplgvkuQk7xI3qDmJIuHxJ2tTIeqTeKGKn+80KjmrgTY7N7y0niSxf2rutHy9/vT8xu1vRm1b9STtaKtiesZlgCsydbqPmI+k9TeXxPs61QxrU5teaBp3l4p0YoTdT3MEDV8pMXME7F20QSjasYmZydL0d39tw39dgolnrt99Ph7JJJT6C8AzqvGSVU8zub6sn5d06Airdo7piRa+Wjq7rSDQp2KBS6YJLI6m6uuJu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

AF_UNIX sets sk->sk_allocation to GFP_KERNEL_ACCOUNT, so skbs can be
allocated from skbuff_head_cache with __GFP_ACCOUNT. Specify
SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path: unix_dgram_sendmsg() -> sock_alloc_send_pskb(sk->sk_allocation)
  -> alloc_skb_with_frags() -> __alloc_skb()
  -> kmem_cache_alloc_node(skbuff_head_cache)

Assisted-by: LLM
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Jason Xing <kerneljasonxing@gmail.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: "Björn Töpel" <bjorn@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netdev@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 966af3beed94..34ebbaf04fc7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5213,7 +5213,7 @@ void __init skb_init(void)
 					      sizeof(struct sk_buff),
 					      0,
 					      SLAB_HWCACHE_ALIGN|SLAB_PANIC|
-						FLAG_SKB_NO_MERGE,
+						SLAB_MAY_ACCOUNT|FLAG_SKB_NO_MERGE,
 					      offsetof(struct sk_buff, cb),
 					      sizeof_field(struct sk_buff, cb),
 					      NULL);

-- 
2.54.0


