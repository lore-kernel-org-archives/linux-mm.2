Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55604606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=is8O74Ej
Received: by kanga.kvack.org (Postfix)
	id 5F45F6B0AD3; Wed, 25 Nov 2026 16:38:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CB136B0AD5; Wed, 25 Nov 2026 16:38:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2456B0AD6; Wed, 25 Nov 2026 16:38:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 282F76B0AD3
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:38:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAEA11A0134
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:38:40 +0000 (UTC)
X-FDA: 85474956000.28.65F54B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 282E51C0004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:38:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=is8O74Ej;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642719;
	b=3dWz//jbUqsjBRHaSu1Q3K9h7pBjT3C2IqBkZkzHUmCUahCNGCbvITS3F5oPcUbTd6cGjZ
	mUoNa5CiwxcMgmazvimhTrz6JpyDGOCJcSKqLG0AW0bTnuOHbcdhb0z8LRDblEYWd5Z1UD
	XJkotbQr3MLcC64xyzUiSEMI1BBq080=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edFT5hb7xjn/PmmUrKwEm0LfMfvsHMsiCYhbvf3yyqA=;
	b=pI9VgqMLggE3Is2tosRmEptdV9s4O9G7DWmYWlgZt1hqyVFIsfukxn9zhXRKvObY5HS8az
	gERLXLeIiF94jKmoL3nA6GN/mQ6z+y5ogaQPMydPCKaQJjhYqEZ5AzXUqD/QdB2ogteRGp
	vso5r6c0AWEyiSDhzQaFtr6cGjHk4nI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=is8O74Ej;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABCC160230;
	Wed, 25 Nov 2026 21:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBA51F000ED;
	Wed, 25 Nov 2026 21:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642718;
	bh=edFT5hb7xjn/PmmUrKwEm0LfMfvsHMsiCYhbvf3yyqA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=is8O74Ej2wtiPv4G2N+/RGjZcUAlBFILhSIqRGQMFWzYYC/Xwn74wXBmESeED+3j6
	 Z/XGPrik8sp9GNGhqXNGMXRAmdpxSdLqZFQHzcfjAGwmCR5HAhvbOvdSGdqkGYux3C
	 sF5ndMMZhwRe+4gwybrcNgdDINeb1nSlcV5iruPlkuOyOZeCHU8d1COGO8014KpiNz
	 2P83n2rVN3KX1ouEtD2fgAUrIGZdk0tik/jY66o24MXIzAQphukJU4pbEwjkUXsqYg
	 ZyhB9VIPUvTCiFm2NGLp3pKF0HsPXF+FZYV/QrRF67Rq9pbNgtNuJEeID8iGUFbuZU
	 Z9/799ssKH+3A==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:06 +0000
Subject: [PATCH slab/for-next v2 05/14] net: skbuff: specify
 SLAB_MAY_ACCOUNT for skbuff_head_cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-5-7c680f02a734@kernel.org>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
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
 Andrew Ballance <andrewjballance@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Amir Goldstein <amir73il@gmail.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Eric Dumazet <edumazet@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>, 
 Willem de Bruijn <willemb@google.com>, 
 Mina Almasry <almasrymina@google.com>, 
 =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 282E51C0004
X-Stat-Signature: eogr9wqta3yy7jwttiq5qne9fke5pqxw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795642718-708394
X-HE-Meta: U2FsdGVkX1/Jm6T/k7mMNC7Mwk/V50hxoN/su5LGxpCn5bt+ynttkbSrdiDZxOrFG2bX0+pOwb2PBgREc+sT4d5T/GX2Iox0fQyjtvGFJHghUe1dFdiqWIfKy5yfq1P1CjPZYviraGLOb6R1XvSsIFU2pf7tgZlZf0JT6RUfmyX0ZtAd+SWN+LcqI8tDStDo5QfkjSVst5TnadxfME+BbmtPnIEiInpjMXPaSBeCX9t5H1alNK7g9oIbzaTbHMpnfjlaPiyaF0CRzQYM/zuFDHpzcJZ936kZLVjJtoM3iWqmQDhkYT6u+WR+42IhAwb/U8+4BQr1gRPS3hq0KZnwMugl3SQ3bCZUwdzEgCLWU6hKHf8Qp+b7mYkOh+U46/mNkYLR4l6pyyqvOR38AuHtgt8CMPAMFOdT1/F4q6zSuHIe12Ii4HSlYSAL04ZXel9u072OZwUxn297uqQptPl3KVsbQ+M7INlLRIINQVY6DOh4GxJ3CvOc3OT4RMouHM2UOCqBE4sOqxBzXo++5jZ77tWao4e2vtKu50ClfpaTw7U6f3UD6e7GI+xBRPpgFDnH3g260BL2WEp/7uh9KKK6ueDXVYSQw3HcBTzVQFN6+QjY+hvZ8MWhhYqvTUlCyQX5JYKAjXcWDjV4tU5wwAEO2RoACaNvY6qMexTJqcU1D1LBcr9n/JyAOPggKNE6BCSQjZPU3BN0J+IHxVBdfdd5kjPhUSk7EQH1KSRQ5aMkOejSv6Yx0rGhkzq1WjEb4/Mzm6kGFjDpJEs30JnK17tRJxpl2cWsaRBSihPVvjwyMBhC7AI4laSsea1pyTnuqtXTYpheeD9N32LeljUtCxX4MTm+OzHpM+ECInHSBElj4X1joSjwK3Rgx236q5zlwsKZvmKDqBaijQx98bFKruakguZwAeI75T7SLjBR+XBKPAEWc5rccX8JAmoayqr8NzRMGYlXEnkic8FR7rHa0kH
 wAlhV+qk
 ZIxSCfXdJj2+2rk34X0Lp7Cf5jKhMYBgHRPlVuCChEwvyUzgifYWN3xz4qn0HYt/SnOWQOohNHqIUfpFVv5PF15P2bdLY3UhEAmdylJKgrdKFBuHoT9BUh5qoiRuYRgDx3FlLnq9Piqa+f7//Qh+3WvUmTiloVxZUlWM4tREf/pjmKSLTlolK+BneMg3fyi8kVqOjmSBBjT9GVmAfNFzqPezPGoDY7RjuTFjrMT+I5a5MiBfgrtX9v7yWABebyOLlG85FE3h8TOEVBmsOzCOT5Cvknaucs1QLIsD35QS0rhlPkVLIpiglGzECxVWGc6e/6xCak9KtN6f3HdJ0nJVCIWtLBu2hXaL3LBNis6eW+KNk0CwZefwIltugL+ctDRioRmPLB7CL3UgksPqtYPSQ41xX4S0qGM5oejWdaljFGCwvGUk+wqm4aiInVMZOlq0Q92x3W3nTGubwarsrZpch0e8pqfbwSKCQ6oMWPN7nSsUWekDxAL/2yUN8c2KUTtqw5pVUqnPgirxTV1SHnVYjBeRc+lc13uX7M+euKJ/RntM2loycBmt5L53qSBYVkwkaP+/gd2/cnqWplIghMSTiAM8NYal9FByhhuVso7QPXM/VnwQdzzdCXv4dXPtXlh/Lb0lHGBlFpIic/nEnRoITiFOOyyM+Yp6Lzf3H
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
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1ac1e327ac4c..91c076f32fcb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5313,7 +5313,7 @@ void __init skb_init(void)
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


