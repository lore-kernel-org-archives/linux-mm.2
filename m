Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A033C53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27FE56B00AA; Sun, 26 Jul 2026 18:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F096B00AC; Sun, 26 Jul 2026 18:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E106B00AD; Sun, 26 Jul 2026 18:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 85BB76B00AA
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F316FC0573
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:52 +0000 (UTC)
X-FDA: 85032356304.13.2F984B6
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf07.hostedemail.com (Postfix) with ESMTP id 57FD840004
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EjirzIRq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 39YhmaggKCPolcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=39YhmaggKCPolcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7SCIRKoUCtKEBd3N+ZVZRVrBd5TKGm6OYIjsu4T5vE=;
	b=cpDAoJyPq/or5NS/eE253YTA+NboGlx+KL89qv9dwHhGuHeKxCn42RDr77OMAROEXtcYqZ
	h+QfJOF5QpF46+CtBZSdO/8ggQ4Nx3LLsWVuJsrV2NTk7IX7fyPZSyoqQmZ9SMiLj7i1F6
	yWKOyG4zhh0b3gxAhBzYbgkuRKtR4Ug=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EjirzIRq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 39YhmaggKCPolcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=39YhmaggKCPolcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104631;
	b=7AOMTkHQWaL9sDMwXxLKQaAOvVskocSY3TCDRevYrL9044oJHOyM8DBfNI7VYrH05Canft
	mrZnYUAVTIp7C4Ch44jIr14mjgGmWjyODxki42sELAHFFE7c+VI2y8BUGOg5pdDLVmGL5k
	hRTDoW0zKOlqycGkPiaXTwSTDRWZUks=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4954b1c6310so19836685e9.0
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104630; x=1785709430; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q7SCIRKoUCtKEBd3N+ZVZRVrBd5TKGm6OYIjsu4T5vE=;
        b=EjirzIRqrrVxnvfe1u/x+EC8uDbMTBK5ReiNhAs60LAAnC/iH0kCZUVMuC7oTNYxCk
         nZ2ZagZL+6Ewjz2q8i3bmEvSAZ94Ppu7ZhbySyhjIgBb9vScAYRxGOCMRMcrsePjCthZ
         lJFuZ/RAZzGaICPDRxP3BQYmxsEEQbUVDsFAUuWKvAmfzCJ0Syow10kcns9t78nCze9s
         96S85H6T4ACuvjXLKUnm84+ASI3Sv+Ymvvh4RlXBeIm627XVzhrvKO4ioCoTJitJ1Cu1
         ZfocVG0mJWTgNG6Ta78S7d2atBoGBjV+MVnYcS+RxTJf7eb7AptAJR9BfoDdszkeObpV
         KfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104630; x=1785709430;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q7SCIRKoUCtKEBd3N+ZVZRVrBd5TKGm6OYIjsu4T5vE=;
        b=clF+8wBwhwKjKrlT8THk38DS31W89NZqq/nIqqdyYOQ0WXdvVcPWulSC5B/u1U5jvF
         c7CdHyuFf0huBgiu3w4NtEUN0ChiLqwdqDag+xvjNVVTbulKTG/3yhkdZyHColemsnJ4
         djC9CBDYOQbMAHoDk/HlvPK/RuJ5nk+VjaetzqVjOT2ij17vL8kVh4HdROUpPoESJQ1Q
         Apd/odq+aohpOgfcbG0Xtx7Fw3GWniivAyBbk/oLApijSnLHgKi8sGcaX4BWhnYoEDoY
         EC6l6R2xYCN/0jF13zEnqkLcCCAZA8eB0Qi30va6zdsDb5qoG4H1JEzQorNOQ627hrOD
         0+7w==
X-Gm-Message-State: AOJu0YxItqheO+9epQElJDvbryddGImVVYhV850Zk5vUF+nWW69Ckbp6
	cx6hqe0HXKMsRYkpYXvAgMJgTOXSUMZrRwD4k/vzvec7RlikCT3guT6g7z1vgiwGJ4NU7261+kE
	ksERilIF7/EcPWQ==
X-Received: from wmbjq22.prod.google.com ([2002:a05:600c:55d6:b0:490:e19b:c5ab])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4595:b0:495:3a21:4e5d with SMTP id 5b1f17b1804b1-496b56f461dmr76997775e9.0.1785104629845;
 Sun, 26 Jul 2026 15:23:49 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:52 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-19-6f5729aa9832@google.com>
Subject: [PATCH v3 19/26] mm/page_alloc: rename ALLOC_NON_BLOCK back to _HARDER
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57FD840004
X-Rspam-User: 
X-Stat-Signature: eqiytonye6z6mnom156r43smn9upck99
X-HE-Tag: 1785104631-801302
X-HE-Meta: U2FsdGVkX1+mjKQLnbmtbhXDG9K6ntgmWVJqgpr6b9I9dhnwSIDqC/1y+22ZxXm/3/0tQ9eVo0LHWN074cro6pDnVp/ImFFf9bQ06d174FCjBHmdyZS92cwJapnLo5wo1vqVdRvaApveJ0PaibvsZYbPR8gOj5pN8dNY+RscEmEV7rZDCkAdpeUxftFWsSNtGl7EH2g8229h3nIdYqCoM+zIcV4feh/2T7WODNaGCIFE+7cUe6glztZZuQSYHftpEDLuuQ4RIiDENMUGHuegRzfa3S86ru3bTf26Uq8BgG035t+GCvm8k2Ja/THKTRUoiruWG0RqVhUda3l3GT9tCSAMISQYujkDrxPy7J3/UPPH5z1Y9S4EnauMnFXCEZFUOAYdK21XErqyz6/Eowobh56IdxJf7WIaN3Y8Zf+UU37ELYSKOgp3DS9T4n7wC7nI/e4JpoeTTp4DYne+jJ98l6NMipuMQGGoH3qUmpw3geRaZ1ZI8uc2Og9u26Zv/F8IxYs+PCPWjkcH1m6iFFPhGCVb/IvYV/5hYji8yNwjbNDRVPOnTDx+oWyQESBLRbc8nZNw6lrSgkPBzLLKjsTtR0ueHHhYEjT2jZ5Ef1MuAkItf9zqEc9htLNs+Jd34u716E50QOxMX9B+ys0PpYbGI0g9dX9jtc0XI0GN6H9nb+Y9dHABTJ17BfrjDnxTU7ubkxNAFA7YgbD4AXGSjwXJxnwpFTWGoCXbeo5ilOTQ97l/AD96UDJhesNR2KyD1HogCBgA473IV+xxRn9I35+TLkNnl/lZNCyKEW45lgT7YbhEBhwWBofNlCLEU7tnpYrvsLwcd01GhSqWPvClRvYd7b0BH0WUkDO0yQBIBeNh4k/Zc397/Pklzo4O5o3JK+dhuukoXJq6sYtYKh838+/WLO4K20n8u5PX7uQXTnOnZbqPdmR0BO4eckB+fg0+g90t8Qcu11wMDr8gczHYWN6
 aVx+AsyI
 iieHf1UaySunKWb8UvwQ7XqvnaklHXCoSzzfumKCf2NP1qtVmgCNqTkfNNUyPo7SNXAUpq7Lljj8s+TMaKvyn25CRmyIli7h0HR7pcFgmapr4ldHCZJYobnJC91mj68HKuPdyuIq75TVkrIa5/N4kRQ2v7pv/eZuYzZdI8DAA/bJzN3WrzOveOMpTRrUdwG2auQBYIhL3tZKHRtqqx8W7w/COWd4QLiRBMob7DKx/w70ACwjDHy8CHbRuWBYxawWDuRVGPfqlP7twZrbcffih0m9mwjlJFJf/B0JwEPMkiQp2+aQr4gln7tLKm67b9QplXY4q3FBtibH5/QMEPocVvIPBe73qBKBZh8wGnSuttdruxSI3D3ZneK23R5g2WtUo+qilBxjXHsmchbkBgRr8RuMyCMBR7QSjnzkRPcogcSuPjSa1XCyqrVPKa26wRggaN6IKB5XcraAC/vA++0N4rMazGNdqk0gXa9V6GWHfnutNZdg7Gu4hErQVMTMPfxbZB6yGKGxalJFiuW3ghh+D+yDkqi46WNL7+TawgB3oE9hYpMhidq/erBJ1zyae8NX9OClAspuVm/Xbzji1xHE4/D3AEKVOFW4fX+PR55CVo3c8pXhIlrbuMx1EEERYH/vNBbgcCg0fQQZ8VrY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
non-blocking allocations accesses reserves") renamed ALLOC_HARDER to
ALLOC_NON_BLOCK because the former is "a vague description".

However, vagueness is accurate here, this is a vague flag. It is not set
for __GFP_NOMEMALLOC. It doesn't really mean "allocate without blocking"
but rather "allow dipping into atomic reserves, _because_ of the need
not to block".

A later commit will need an alloc flag that really means "don't block
here", so go back to the flag's old name and update the commentary
to try and give it a slightly clearer meaning.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 8 ++++----
 mm/page_alloc.h | 9 +++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 30ba61c20209c..fb522a09f2e60 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3431,7 +3431,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * reserves as failing now is worse than failing a
 			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
 				page = __rmqueue_smallest(zone, order, ft_high);
 
 			if (!page) {
@@ -3811,7 +3811,7 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			 * or (GFP_KERNEL & ~__GFP_DIRECT_RECLAIM) do not get
 			 * access to the min reserve.
 			 */
-			if (alloc_flags & ALLOC_NON_BLOCK)
+			if (alloc_flags & ALLOC_HARDER)
 				min -= min / 4;
 		}
 
@@ -4733,7 +4733,7 @@ alloc_flags_nonblocking(gfp_t gfp_mask, unsigned int order)
 	if (gfp_mask & __GFP_NOMEMALLOC)
 		return 0;
 
-	alloc_flags |= ALLOC_NON_BLOCK;
+	alloc_flags |= ALLOC_HARDER;
 
 	if (order > 0 && (gfp_mask & __GFP_HIGH))
 		alloc_flags |= ALLOC_HIGHATOMIC;
@@ -4750,7 +4750,7 @@ alloc_flags_slowpath(gfp_t gfp_mask, unsigned int order)
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_NON_BLOCK and ALLOC_MIN_RESERVE(__GFP_HIGH).
+	 * set both ALLOC_HARDER and ALLOC_MIN_RESERVE(__GFP_HIGH).
 	 */
 	if (gfp_mask & __GFP_HIGH)
 		alloc_flags |= ALLOC_MIN_RESERVE;
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index fac8e5304bb03..2307b173a459f 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -32,9 +32,10 @@
 #define ALLOC_OOM		ALLOC_NO_WATERMARKS
 #endif
 
-#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
-				       * to 25% of the min watermark or
-				       * 62.5% if __GFP_HIGH is set.
+#define ALLOC_HARDER		 0x10 /* Because the caller cannot block,
+				       * allow access to 25% of the min
+				       * watermark or 62.5% if __GFP_HIGH is
+				       * set.
 				       */
 #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
 				       * of the min watermark.
@@ -76,7 +77,7 @@
 #endif
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 /*
  * Structure for holding the mostly immutable allocation parameters passed

-- 
2.54.0


