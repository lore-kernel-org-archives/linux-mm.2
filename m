Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35BFACD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E176B009F; Thu, 30 Apr 2026 16:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6F16B00A0; Thu, 30 Apr 2026 16:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F18136B00A1; Thu, 30 Apr 2026 16:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC9CD6B009F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57B40C0309
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:01 +0000 (UTC)
X-FDA: 84716346162.14.6820296
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id AE412A0002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=FTCpTDcS;
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v47cF74dZcIPIzFPnA8W//wetS30xYd0Bvj0t+6vliw=;
	b=4xr95y49QJDdOtbM9fbm7bVaut8+9WFHd4zSTZq7vXteHxJ2kkZUYAzmgahnpWq2dlPd9F
	MV7WNQMWy8R274w6pAdH1RuWXJNKdyXQ8GYQAPiGIKePzh+K49zWlW7L4rbWGqu5ka4AqH
	IOBVuQyUOeZijx8KU5AwAS2fVXppSfc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=FTCpTDcS;
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580579; a=rsa-sha256;
	cv=none;
	b=fw+82Zbog1NCrlLUYbQ1vLmKQx/IzsX+fOYEja/vYJECqzzNRxH/m19Yxhp/jIXIMNCcjR
	+bKQqPaiIyLlHIzp5+x6U3OrI+WwnhAFE7A/O9TOAFubnnS2uHP9qLBjcGD/jqpCNfmPU2
	ItBbJ+uIG6sgulwwx9MeujQ3TuIWPe0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=v47cF74dZcIPIzFPnA8W//wetS30xYd0Bvj0t+6vliw=; b=FTCpTDcSquZJXHFMchV/sXJVpj
	J01op1ryDh4hbdMVXN54Ml5lASwZpQt1v5siSuGYXiEgeVD+jAn2j3TpsA0ymaB3ZfjjT0GRHxRKF
	55Q+ihj/Ejj/sqeXuGka2k60UuX53qTDHArCRNzBpPRzsnD88ajzeg0Dno0zcV6yxYG9q92BlhPdZ
	/SzszxGbBQdtGmEZ3SHMm8J04+GkCWXLXe0QHprkCqCI8h7bgE/tfvt6TlkXMPg5VPORwmTTU66On
	NYySBTrsWJLb/rkmek4oeJx2Xs5tetm7FFVyt+Vrfnrb0917dsSIzpbMXBVL/jgNUPN7514PkVbkG
	bvZU/gHQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-1Fql;
	Thu, 30 Apr 2026 16:22:41 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 33/45] mm: page_alloc: refuse to taint clean SPBs for atomic NORETRY callers
Date: Thu, 30 Apr 2026 16:21:02 -0400
Message-ID: <20260430202233.111010-34-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AE412A0002
X-Rspamd-Server: rspam06
X-Stat-Signature: i75y3pdpecoj7u6jq5jqx93uybkahwdq
X-HE-Tag: 1777580579-857595
X-HE-Meta: U2FsdGVkX1/dCQiTs+Rzb/5e4Zu7GpXNXEa6L/U6YP2qOwbGkMVdnNNgL7scLM03954zt9B6ZulU0F4zp8bTvkHpE/C+X1WOhMmjwHNAR56Cs2FwsmgmSeaxxFky86mA9ZR4B1mDZ7QubCEHL1jwoAQtTcVftm9mEYOkTNIe5oXh+GQ7zt8uPh4sawPvK8wSnJRtdNBO5c2HxikV5auncX7i5laGH8bAMwlhq9UaPHkRCdXEFJ8alXehExqTLm5+956yVqadPdm5ilBYnzR+UZIy4vnBB62MSGkHDGmVU0ilvds7nd9WEJHc6gKhQ5Ad8y0WeEIemyKSABMp0F/F6laazodUTEvV/ZeDTbMEAmY3eBAUr2V+tIs7xCUYvvT+4y+oI+tYM3Kf+VWzeNtjMrlEb34nXdHZL+jcpdy2t/rPVq5j/WlwUCgNYIPC9xLm3T5oxR5eQr7QSg8xHa217viFhceRZQ0y6hrm/omeDuSxgu5v4JSpqpwmPUhw7zf7SoJU5lrr6uG5y/yhPTxh84XlYCQ5NJqPzNS+Qvp7VMJLhL0Rts0T+TdQPrujdiXSKw5Zrdklrc+/xi6Vf+LPoBjCpZ8fF2vfU8ZXjQpqzXZO3fWPG9OHLynHhcm3MTZXU8ViTtMCWUPxXNAPdD+s2emK+M99bM6VQlqv5Zm87uVNsd2w18dDoG5sG/qzo2fzvK9hatsI6Z4yBxS9VjDc/9en6zD0cR9Rr/nfmXuy3p9EkqcaLN2iyAhXX8yC/PHcS+g7mhGXXYTGOUwIecqELKGxDCv0fopN410a913e9QJemfCiFRJTDzadl/YIFZUAPZIWE4R3qQJQGGmKZwnCoWud6I0Rg1xVp7/fSS1RYloNZKiVAAvoHJC5Q0Sbu/wGXSYnWXvczZ9CcRFj35ytYq59YfB2p5JV859gEfJ8focgfaUiN/1fbSDo9wZDzXJ18L0vFIPJBpRmkagEUOK
 4a6rBSOj
 TC7taHgpM1pllWbueFx0MUET87F/MLCWtceQ2vanmWHRYC3Ru7qLTp09nPrUXd/exS68M/LIdP0YxO8xPNFTqh0MxuJ4EvxPMlQgz+xUIMDZABoNwhhom88lVzNr6Ujw9aCjNy7b+92bECHNfMleeuIcOiw6083wzkeU6UaKu5GOcIYGkujGgkEMIL1Ob8h9Ph8woQu8U9SnEMyDoupbsqPKA3UdsIvIrrCGNU/vtxjyNLmG0nqMPEobFHENTC5Cauz8260Sm2MEDYWLG0WlY9XR2EyS/UGDs0f8Z4LbNUfF/5RhXsB20hEAcB64MH3BVVkjyAp20NyWUccTv/E/LCh6u6WcZBBrFQpAqZxe42WixKyMqC0bpbg6WsrxNErk6sJSoC4KdYcSt75DOt+HStHYIJPOeTZsSjQel
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

get_page_from_freelist's atomic-allocation retry logic progressively
relaxes ALLOC_NOFRAGMENT to give atomic allocs every chance: first add
ALLOC_NOFRAG_TAINTED_OK (allow steal from tainted), then drop
ALLOC_NOFRAGMENT entirely (allow tainting clean SPBs). The intent is
that atomic allocations have no slowpath escape and need extra room to
succeed.

For callers that pass __GFP_NORETRY, this tradeoff is wrong. The
NORETRY contract is "I have a fallback; don't go to extreme lengths."
Network skb_page_frag_refill, slab high-order allocations, and similar
hot-path callers all use NORETRY exactly so the allocator can return
NULL and let the caller's own fallback (smaller frag, lower-order
slab, etc.) take over. Tainting a clean superpageblock to satisfy
such a request is a lasting cost — the SPB stays tainted for the
remainder of the workload's lifetime, blocking 1 GiB hugepage
allocation from that region — that outlives the single allocation
that triggered it.

Skip the relaxation steps for NORETRY callers and return NULL
immediately. Their fallback path absorbs the failure cleanly.

Observed on a 247 GB devvm running the page-superblock
v18 series: an atomic order-3 alloc from
swapper context (PCP refill, gfp=0x152820 = __GFP_HIGH |
__GFP_KSWAPD_RECLAIM | __GFP_NOWARN | __GFP_NORETRY | __GFP_COMP |
__GFP_HARDWALL) tainted a fresh clean SPB at boot+~90 min despite
ALLOC_NOFRAGMENT being set, because the atomic-retry path stripped
the flag. The caller had a NORETRY-fallback ready; the taint was
gratuitous.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ff7755ef2b79..e8d6d5b47f63 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5895,9 +5895,20 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	 * first: allow steal/claim from tainted SPBs only. This avoids
 	 * tainting clean SPBs while still finding pages in tainted ones.
 	 * Only drop NOFRAGMENT entirely if that also fails.
+	 *
+	 * Exception: callers that explicitly opted into failure with
+	 * __GFP_NORETRY have a fallback path of their own (a smaller
+	 * order, a different cache, returning NULL from a best-effort
+	 * cache refill, etc.). Tainting a clean superpageblock is a
+	 * lasting cost that outlives this allocation; it is not justified
+	 * to absorb it just to satisfy a caller that already has a
+	 * cheaper escape hatch. Return NULL and let the caller's fallback
+	 * run instead.
 	 */
 	if (no_fallback && !defrag_mode &&
 	    !(gfp_mask & __GFP_DIRECT_RECLAIM)) {
+		if (gfp_mask & __GFP_NORETRY)
+			return NULL;
 		if (!(alloc_flags & ALLOC_NOFRAG_TAINTED_OK)) {
 			alloc_flags |= ALLOC_NOFRAG_TAINTED_OK;
 			goto retry;
-- 
2.52.0


