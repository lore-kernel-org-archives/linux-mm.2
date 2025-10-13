Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D0DBCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 10:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6795B8E002D; Mon, 13 Oct 2025 06:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602D98E0007; Mon, 13 Oct 2025 06:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3588E002D; Mon, 13 Oct 2025 06:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA3C8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 06:16:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A476119A59
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:16:56 +0000 (UTC)
X-FDA: 83992687632.19.1483920
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id CB0F34000E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:16:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iKslxATp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760350614; a=rsa-sha256;
	cv=none;
	b=qO08ufDOpLsEpwcrQNPvuTk2gWFwCKVwL38deS22W136wLi3nl0gOd8IWMgd6YjU543c0o
	CyX0V8EwkjAHSUd7YLjoGhhS7va+gh4/wbPoKr2UH+1qAEoEsFyKcLlc3LhsTG2xQt/bsK
	yPCkgXdoNPR6lpw+4iItWUGYUqnzJ44=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iKslxATp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760350614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QCAxtY3LQTIn8FngImj0LqZJY45nq8RXCAx12F/vMUM=;
	b=1hGOIx33AazWHiOM78u6zpDCfIgycw93uVVOzvmdm2b/eDDiLzMwAjxoqAeIHs/pDCbnW5
	feRwmC6BDZt4IqXE9GF8AM2IqsKZ/4D2t5o4WfduEeu8+aCsxf68S5wLZ3oVz+DGns/Htx
	S6bu1jT3XeWgD7rd2wLD9fENF2VwVvE=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-27c369f8986so36995035ad.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760350614; x=1760955414; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QCAxtY3LQTIn8FngImj0LqZJY45nq8RXCAx12F/vMUM=;
        b=iKslxATpwk4axW0WfYGaWfsUqLj8+jR9Xfi1F8MZnYwTHExF09gYGNJ8ee3PxIvaWu
         wzA+5iMW2bXDlqfvstgR7BqHQCl7KDPubE/sElxbs5npfLfdCuEBYJNkDSa5ZGDhsAtU
         G1CZtAo8Jpm25YUGdIOz6p1AocH/lTcIJ6HM34AWhtDc8QVJ7WSQZ7YhkNH00xNmMXQP
         oUFZ0NJJyuUKiVHLhPsKS8K8MgLFh2VlZ6RYEUF/P1yjySxqv6lS8BkfFO1Hi83SbA3Y
         qtkuPEYVGJUna9XzXEAnX9MqM6iSmBg4DYysCbYnHKcCXWh2pCCKsMRQVKFGorHE5pQZ
         mBWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760350614; x=1760955414;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QCAxtY3LQTIn8FngImj0LqZJY45nq8RXCAx12F/vMUM=;
        b=ChV0o3YPyI+dZSmcf5NIeJcGnbyN7FC0bxVJ5c3bqYrNiSWbwU2pKVOACsja0oqvmU
         R6AYYJbT1pcrBks+s3BRXKK4r8hxhUlbQ4VEh7rjhjZDMDsETw6uFbe7ic4YBK5UbHML
         sklqCRHZv71ura0FAPx7qdi+RffDg+HXGGP+wqshUoxvHgVhGBhn7W2dnG+Tcx6KodDs
         6zbw1JKCyoRF+HJgkOdHE6N6X50jUQtZ6WL5/kGGgWfD0WZASTtv/SvE5qEx1B/CfIUM
         JEe1lJZlcfep1j23CZVxTK9iXD4ywBZ3sLuQuwHvnArKxtssy0VmhqOQONUKkXB89z85
         33sQ==
X-Forwarded-Encrypted: i=1; AJvYcCVu9xolT4zExmTzm7vU987P00jd4/9H339uK4sbzBGxiyDbdTngOM5zX69MMwpMUiEgg8DP2ctbRg==@kvack.org
X-Gm-Message-State: AOJu0YySLOR+2Nj+EbIQ9wnQ4lxUpl89ZnDdlWbWlip8Y/UDkIZMo3nZ
	kk8bJ/22dYAWUZjUBnpzHkdauUnDg8byFsUH1D6ZwwfQKEVQsyUG6w9Y
X-Gm-Gg: ASbGncvhP5l0UWtvgT2tIMOc6PBq4UPx85cF+cdKfHFHKUcR8yuESVJlSTK65cEWZj5
	HC1AOpEnIRirvFlPgtPU/7JKKoqRdwylad8GI7MH1pkZm9uoYGAE2oUBur2WnQtEAmTogZdzMx4
	k/hLsl0vrj0n4RY77QUv7fm+kl8+Pd0FXhsWTZn1rcCYy6rs0qLSeQb08kJgbfl239dnL4GPSwQ
	XhUbrlGwMVT8e0mUBIQrnGRgclW63HVfJdLGEEmSWKQ3ft4klvR45GjbpQvTHjTJ6Efe1dqXEm2
	lII7LX40/Q/sTsHFOVD8TqnTtp0PqiK0l4/2RxbWTAFXnvjrXK6hUkzEAdmzqwrquVGWSJm3laR
	eLKQCT+JTk/NpO4gsVWGH3lYb4jKPUOz8yOZPJv2o8Plyfit/7BWge+t/yT9wArm2hHqNz/b1+u
	XQo4rhQMa/ApTrOg==
X-Google-Smtp-Source: AGHT+IFb3Ekfpe+r+fIcV18hbbrZ8FmIGYR048P5P8oY5j/nrUewcp8bX6QuZ1UX5R5SzFd5k4dKnQ==
X-Received: by 2002:a17:903:138a:b0:268:b8a:5a26 with SMTP id d9443c01a7336-2902741cd15mr272716115ad.54.1760350613434;
        Mon, 13 Oct 2025 03:16:53 -0700 (PDT)
Received: from Barrys-MBP.hub ([47.72.128.212])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29040e02648sm95556355ad.116.2025.10.13.03.16.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Oct 2025 03:16:52 -0700 (PDT)
From: Barry Song <21cnbao@gmail.com>
To: netdev@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Barry Song <v-songbaohua@oppo.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Huacai Zhou <zhouhuacai@oppo.com>
Subject: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
Date: Mon, 13 Oct 2025 18:16:36 +0800
Message-Id: <20251013101636.69220-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CB0F34000E
X-Stat-Signature: p8zdzbk1ayc8ggfocmt5jpcpb7nwnp7z
X-HE-Tag: 1760350614-210367
X-HE-Meta: U2FsdGVkX19gZFAEbe2rLFbVhih6uteoJGwtRBf0dwaf4N1NYYuMJOTQklVBmfHhjj2EFPrSHcpez/nTAE0Z74HS6zfqY9HI7tNyojwTFIA69VOi+4hbPf+Fp3UCHZnEruqqmvHUjKdgfsFqRFhwK/q5KjI+E/pM7r2viGl9pF+Nf1jaEPwg7itaP2LCXssFTymu3LPRF7+RNaC282rqrr2eEJ96Z1KUrD4Cc4IS2ti5xn89bbRgWNGn8pek8/3AMJAWJHM1QDcKZ9i7G44MVTCGpFB1G4GUA3ePk2SSUFMPFYbhr57FUNWcwswhBk9+t4Zu7GMvBJZVnrZ4xWTDxoFPwM7OIV3UTQEACKLMXex0CLGOfWIQRi3AuD0tZHLJmoxQQ+McbqYcV+hfGmK3LKHXdTTVwGsbzYSrevDFy44o0xix0PZn2KHE/8aCik0n2krUQuiBRGiUe5AOw5DWsk1ffUsIWKP8+Kdu3WHK7rVNTI5guOPINELlw01hx3kNLZ6ue7aPFQJD+ie2DtDX0IsrONwoz9QBlT99ScJbq4AlkAuuImL8h+l4iogBZ/aoQFqMkkIWnNmCljMVfmgkC4h5bhAUc4Bpr3ISe/9zWiKroXXvNKc8ye//QhLKAj0bJU8gqm00rXAfFtVYiiJt2bRkP0gtMxLvVtUkfAYflg3WeKrJaQpuYEPSIarfPGjyJnPSsPZQcmQIhK6EfWLQsFJOx1GOXfRTr5eu0WgHSX2ta38adP0fgKQB+/bUWaybnwScZ8Os3HWjiseqZyydrOQ/iS8oaQdQ6R1xr3TGowvreIdjSrhGXpjP7nBu5ruoowJQpBdg1fYAN9UZJK69MQyZOtq/eO2hHG/c+N+OyZzXumwjpL7INFDgLTmulZPSMYL58NGru5CtnnJMXTDLWGg/82hWHWXEC+3vy3gbtWd7vec3jSuK/bIr9y7DNWw3PkcOoHwt4whOHB+tPZ+
 tg8W33//
 rHwAD1IszlG7s3lhGWa5u/kwpUCoP+pRvL3fpAX1ZjA7rDB/1lhKMUsyQg6CvGa9fw+mtsdi5hAyLi70fNBGebgI3thb8aVxz1WjQ4fpqK4GcPny/cmXZkuOZVXEYYU4RPuxHLPABg+mjv/lf6dDuY+i/3TRlk/c+gHlKoBh79o8OG85UGqz1MI4R5FkAQ/Lap+WY5W6kvG6ZO3I3pd9KRpY+6G4qe9m7h/9ZGDx/RiEV96z1mfalN8GDIehB2Bk+LL1OxA7QO2FPJyGHlIVGRbFXcmKubAa6jRsn8XTbUJoc2PHheGRfxY95o729B7M33ioZU4Og6l8LZeddgPzHE9Cg5WHRVXQCCn6PyaYeewhjh7c6Iav/3MkTO3eJUp9XBVVNefff6ZLJpKPkuL4/DgY88q6M/d8Q2P2+iNRsofiaJDzmNDLuH9hQXK/ugpsaSb9GRP4zKN1B1dfLGB0yrCNE4OkGt0QYNhep57iIxGfrLIxWZ30Lad9zQdB8R+cgOnvLwKY3Ux0RqiTkt11ErTD4Ud8u0LnOTjeOTD04zBcJRm745j/AvRSJ0olGmFi4wApYcSPXXiVzHUeVnS92gsS0F4QhYcfhcBpnZBm3E7qglxVg33zK+ht9BB0kdwr5ilco+l2wNRg/d0gpO3CHMfmRhnyTbxG9zHtLuceB0biN9I+BsjV6xTGej3EA++f7axn/yYXZ1Xs5MMQf74kLDmbtDpc6BA21/abbOaBNbX5jyezhy9A9FPKEVxACVW786HBQa05SDx0CPWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Barry Song <v-songbaohua@oppo.com>

On phones, we have observed significant phone heating when running apps
with high network bandwidth. This is caused by the network stack frequently
waking kswapd for order-3 allocations. As a result, memory reclamation becomes
constantly active, even though plenty of memory is still available for network
allocations which can fall back to order-0.

Commit ce27ec60648d ("net: add high_order_alloc_disable sysctl/static key")
introduced high_order_alloc_disable for the transmit (TX) path
(skb_page_frag_refill()) to mitigate some memory reclamation issues,
allowing the TX path to fall back to order-0 immediately, while leaving the
receive (RX) path (__page_frag_cache_refill()) unaffected. Users are
generally unaware of the sysctl and cannot easily adjust it for specific use
cases. Enabling high_order_alloc_disable also completely disables the
benefit of order-3 allocations. Additionally, the sysctl does not apply to the
RX path.

An alternative approach is to disable kswapd for these frequent
allocations and provide best-effort order-3 service for both TX and RX paths,
while removing the sysctl entirely.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Cc: Huacai Zhou <zhouhuacai@oppo.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
---
 Documentation/admin-guide/sysctl/net.rst | 12 ------------
 include/net/sock.h                       |  1 -
 mm/page_frag_cache.c                     |  2 +-
 net/core/sock.c                          |  8 ++------
 net/core/sysctl_net_core.c               |  7 -------
 5 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 2ef50828aff1..b903bbae239c 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -415,18 +415,6 @@ GRO has decided not to coalesce, it is placed on a per-NAPI list. This
 list is then passed to the stack when the number of segments reaches the
 gro_normal_batch limit.
 
-high_order_alloc_disable
-------------------------
-
-By default the allocator for page frags tries to use high order pages (order-3
-on x86). While the default behavior gives good results in most cases, some users
-might have hit a contention in page allocations/freeing. This was especially
-true on older kernels (< 5.14) when high-order pages were not stored on per-cpu
-lists. This allows to opt-in for order-0 allocation instead but is now mostly of
-historical importance.
-
-Default: 0
-
 2. /proc/sys/net/unix - Parameters for Unix domain sockets
 ----------------------------------------------------------
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 60bcb13f045c..62306c1095d5 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -3011,7 +3011,6 @@ extern __u32 sysctl_wmem_default;
 extern __u32 sysctl_rmem_default;
 
 #define SKB_FRAG_PAGE_ORDER	get_order(32768)
-DECLARE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
 
 static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
 {
diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
index d2423f30577e..dd36114dd16f 100644
--- a/mm/page_frag_cache.c
+++ b/mm/page_frag_cache.c
@@ -54,7 +54,7 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
 	gfp_t gfp = gfp_mask;
 
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
-	gfp_mask = (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_COMP |
+	gfp_mask = (gfp_mask & ~__GFP_RECLAIM) |  __GFP_COMP |
 		   __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
 	page = __alloc_pages(gfp_mask, PAGE_FRAG_CACHE_MAX_ORDER,
 			     numa_mem_id(), NULL);
diff --git a/net/core/sock.c b/net/core/sock.c
index dc03d4b5909a..1fa1e9177d86 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3085,8 +3085,6 @@ static void sk_leave_memory_pressure(struct sock *sk)
 	}
 }
 
-DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
-
 /**
  * skb_page_frag_refill - check that a page_frag contains enough room
  * @sz: minimum size of the fragment we want to get
@@ -3110,10 +3108,8 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
 	}
 
 	pfrag->offset = 0;
-	if (SKB_FRAG_PAGE_ORDER &&
-	    !static_branch_unlikely(&net_high_order_alloc_disable_key)) {
-		/* Avoid direct reclaim but allow kswapd to wake */
-		pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
+	if (SKB_FRAG_PAGE_ORDER) {
+		pfrag->page = alloc_pages((gfp & ~__GFP_RECLAIM) |
 					  __GFP_COMP | __GFP_NOWARN |
 					  __GFP_NORETRY,
 					  SKB_FRAG_PAGE_ORDER);
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 8cf04b57ade1..181f6532beb8 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -599,13 +599,6 @@ static struct ctl_table net_core_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_THREE,
 	},
-	{
-		.procname	= "high_order_alloc_disable",
-		.data		= &net_high_order_alloc_disable_key.key,
-		.maxlen         = sizeof(net_high_order_alloc_disable_key),
-		.mode		= 0644,
-		.proc_handler	= proc_do_static_key,
-	},
 	{
 		.procname	= "gro_normal_batch",
 		.data		= &net_hotdata.gro_normal_batch,
-- 
2.39.3 (Apple Git-146)


