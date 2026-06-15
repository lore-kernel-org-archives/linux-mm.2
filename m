Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9800CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 10:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60476B0005; Mon, 15 Jun 2026 06:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B118A6B008A; Mon, 15 Jun 2026 06:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A274C6B008C; Mon, 15 Jun 2026 06:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 924066B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:54:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E4CE1C45BE
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 10:54:44 +0000 (UTC)
X-FDA: 84881838888.28.E0503DA
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 57638140003
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 10:54:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bAhttd3I;
	spf=pass (imf26.hostedemail.com: domain of 38NkvaggKCLskbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=38NkvaggKCLskbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781520882;
	b=7LmIp40uI+/5955HUju9Vt02tMnQIXdsoe/K0CPtD8QnuEll+mp2rZDkz/ac/DXJVBjurx
	HSskxvCObfIonUlpBrZqGAUYrP2ZHZvwMlN4vT0ThKG0/0MkEs1xd8W2GAx/3JRlAQybaM
	nWKMmfmuPlXYWy2n786o5UZXFfOoOzI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bAhttd3I;
	spf=pass (imf26.hostedemail.com: domain of 38NkvaggKCLskbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=38NkvaggKCLskbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781520882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eobnSkbfcthpGZ3uSiACB77vsJPzjUfl3qO5CZCMbzQ=;
	b=lFdarjylczU4oD+kpJQ38zl+Gefe/iMnUoKbOLjzl5x/iDnIQKSF/j1AIddrLU047/6x+6
	RfoLEJIuZx69pvMTwivrt/N6EH3vVYdDPzA41EyD+yfTrL8fYoiWqaWzUrRExuBl3LzW8u
	AKgaUbS3AsxozddydoEJ/3Ppg7VjnN8=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490a767b782so19527315e9.2
        for <linux-mm@kvack.org>; Mon, 15 Jun 2026 03:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781520880; x=1782125680; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eobnSkbfcthpGZ3uSiACB77vsJPzjUfl3qO5CZCMbzQ=;
        b=bAhttd3Ijl5596Z8G+8MU5pJL0NEavqvAKqkSGZyimcaMJhp4x4DkHwNS/d6QL3iAc
         P4k+IdWwDIvSP3j1Q2Ai+tJ56otIz839V7x9EsDkbF6uQ2eoA3Xz6ZSmeC2bU06iSQw0
         /SEWxlyxfwjCdDaFAQ1gFjjdgOmm15yD+63PDVid61gVdmP2YW7mTlIFlk4zm379iD7o
         3alhEBe5m45kyzv4h/OIqfOlf+ebb6e0FIdrS6HCcd5Sg3HwbyjUUqfGKtHdvESsCDPM
         ZUgL7ZT6lnpffYS7jzhJ8/LzFS9ILVrg5jOEDpH12CCvN9wpEZ7daZqsC+zsS1UIyOML
         VoJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781520880; x=1782125680;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eobnSkbfcthpGZ3uSiACB77vsJPzjUfl3qO5CZCMbzQ=;
        b=lBPKchr2ouVKVm7a8rWse+DtvWmoUlVQHDgQbdASIVYkTh6YIHgtYp8Iz9JQAB64Al
         vOsgMa/arvRGqLSchMICaRIc+ClkbozKPa+Rh9+A4btro3J/Q4cYcYMrgqziH/HN4vrN
         KDHfJpcliiaoxnClNA7LxDXIjCS0uVhgd9xV2YrR1RcA7tOLgoCQVeVTVWTzRXLdmE5f
         ybqXG4i1fLiPwBeA4Q6ui3HfMxlqe3LmL0R4PLTX336m/knPypUpfbeQDE8gjIS4mgTN
         lCwRutZAeruv7HXSBcBScoerz6qAVNw9bdXTVIaojngmApVLN7AuNXEFeITSFSYQqczK
         1U+w==
X-Forwarded-Encrypted: i=1; AFNElJ9jYWWOtam6ka5ss8+5CyVWhZjQTQNmyeQETUT8Gs6x8rf8tl8cX08Fn9rZCbcFXklr8BbOdh+dTQ==@kvack.org
X-Gm-Message-State: AOJu0YxuiLxnn+EwVr5fKMN+7WNtAXjB67oEzjuuSBnt5HCOT5LA5EvJ
	TQzZyaUZprT8t7ll5FS1H2CAH3xBOrT6kV+wVBQxXpp7SurgLPTSYvKtSL+VOfQX4Js/9UFEPVi
	ohheJ6gWTVpkdLg==
X-Received: from wmbhj26.prod.google.com ([2002:a05:600c:529a:b0:490:b6fd:4e2])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c059:10b0:490:cf76:dea4 with SMTP id 5b1f17b1804b1-490ec4bfa54mr128265285e9.2.1781520880063;
 Mon, 15 Jun 2026 03:54:40 -0700 (PDT)
Date: Mon, 15 Jun 2026 10:54:34 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAOnZL2oC/32NQQ6CMBBFr0JmbU1boSor72FYtDCUSYQ2HUI0p
 He3cgCX7+f/93dgTIQMbbVDwo2YwlJAnyroJ7t4FDQUBi21kUZp4ccoIjLTTGzX0hZONzdbO9e gG6DsYsKR3ofz2RWeiNeQPsfFpn7pP9umhBL3i0En61LD68OH4F947sMMXc75C/U0Ab+zAAAA
X-Change-Id: 20260612-gfp-pessimisation-b258a4bb5ebd
X-Mailer: b4 0.14.3
Message-ID: <20260615-gfp-pessimisation-v2-1-65f1319e6818@google.com>
Subject: [PATCH v2] mm/page_alloc: drop flag-conversion "optimisation"
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57638140003
X-Rspam-User: 
X-Stat-Signature: 8xtxqkym5khmyc7rpwsb4onxqi6skk59
X-HE-Tag: 1781520882-695708
X-HE-Meta: U2FsdGVkX1/F+pm0g2TfxI5Dysjp5mtdXm9kRQEMx6K4wqBiCAsLiBo8ejy1GHRwy2SkIBZ4+xM/RC4I4K8lQ2/HcqW1iXsBq71mavMBSzg0m+T89DVODOhoAaqC7tPzjctvuMtda9DnO3PvCngKcOkEoIBbdYpkY5kJb0Zu6UoiLMUYjX2pwIKNiO0qt3kh4MFy8pLFavXn+5wTh8J168hEz1R2YRehuwp3OZU6pRsDUndjlAzX6c7XWxrHn/wicbcPwTUOZxE2JtxhKLPYWIYx202wcOju9twmNEW/G2ipHNUz+5ax7EO142cx3KpaLagabqtQRpZ8SHrj8o+7tDAITJCsdStmtLBQPNNxd8MyeplYZRz2JA4u1P++vxvru0drUvMR2IeS2TylEbIRfktkZA/eR2SkCC+YQcsK64vqzgtnz/m5y0XKCW36I6mtRIblUOw5JaS0sH4VVCTxNKju6MwtFmNAryoRBFlWWP4MHueXle2RtCEE9uC/uQMLU7h2jFN7um5JU+JOB2PnE3zvksu5GWpshH9fEgQQT5ai1lWmqy9md8jrYwQgSW1WG+T83G+OPQvpDbeAw0PQ9ug8ZAPzQCp9QUk9kSc9uel8Ih2PGvMPLbj8whcyalaGZHc1qDCtblQDxoBsqWU79CumfZuZAXD8rCoKNItUHq4DWT9Q8ddZqzFfZrIiYOB22xKJW22QNS4/lLxklKnHtSrhUzN043X0hhJeaMKL/mgOGXIx0UNnUXQo+HdcgSnCw2H6gm0eOPc6S8I+j5UBdQaYUvfOZBebCr43zU4pFj/DgLbx28QLm0xr2lDdVH0QH5Ydho84ssVxyYBFbkvi5K9OJJiUF9u3sYTtKdtbbYjJcbLevllpdMIcC1jBoh401GZhmrz32yYrcxDCZSwZfdhCwMp+o2ESRBwjttlTbvtZWCIkdI3MMi2EA2vT5jN1b7fL3QCj0AwyzWszLDf
 bG7vOkpq
 p/j5k1oon7ipoCNHN9ZWFr6kFHxPYTabizOnopgganvjutgae7I9aSwpNvDVPgNhdT7KqdSEb3tmXn6/9r3gyc4SC8f5IX3INyY0Lccf7mLQLZFtou6vKplMuGuVHL20bxoLmgS2rv2H98NJBjWApGWD0MRM0GCH0z7hOk7VDjcnSpoxn0hAINRxWujTGSLBZQYnxI4FoERuLzmtg1ViT4lFOFHnHX00+xLiKH2mZ6GVZlvSja/ddiF6JrA9qQv3DednL4XAf8Tr8FzF4zhJ0OmELkGbZozkcmgOl0RNNqoXQnrBFcgCNTdbqiD3RdadIt++gYHCORai76QucGo4PKnA6UeD5G96sY8oJVeXwO6G0EcNBLZlRsLHV/YPj990jBmy4l36XzWZieK2wK/ZrIrtwds0TQDs6IwMIBsNpIvCWMwqDbw+X7qj28/meyu0MfsUbuspVHwOg9utBnWhlrRMGxfSc6uZfNR6HWqPsqT8DVs3NXFs0OTepZPxKsCiV74wmejgsk2tBlzduPYTxUlW+HyMlhJpoA3l1vvEPp7USAN7sSu0+U66O0y87gfyE6XUqoOCLoVg/z8mCQvBBPzGUGNU2578ldRDVd6C1cDsgp9KVD/ESABzUMBoCZ1r2pj9WCVklDWg38jLC8BzQEnYxh3h3LT4GCpXK7/PxGwjHqEQPNlNXbEBpqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This code uses flag equivalences to try to optimise conversion from
GFP_ to ALLOC_ but there's no clear reason to believe it makes things
faster. Even if it gets rid of conditional branches, it just trades them
for a data dependency.

CPUs are pretty good at conditional branches. But, in my GCC x86 build
it doesn't look like there are any branches anyway, the compiler found
some conditional instruction tricks. (Caveat: This was extracted &
annotated by Gemini AI, I did not actually read the disasm myself)

Old code:

        ae50:    8b 04 24                 mov    (%rsp),%eax           # Load gfp_mask
        ...
        ae5d:    41 89 c4                 mov    %eax,%r12d
        ae64:    41 81 e4 20 08 00 00     and    $0x820,%r12d          # Mask both flags at once
        ...
        ae6f:    44 89 e1                 mov    %r12d,%ecx
        ae77:    83 c9 40                 or     $0x40,%ecx            # OR with ALLOC_CPUSET (0x40)
        ae7a:    89 4c 24 60              mov    %ecx,0x60(%rsp)       # Store to alloc_flags

New code:

  For  __GFP_HIGH  ( 0x20 ):
  It uses the Carry Flag (via  sbb ) to conditionally add  0x20  to the base  0x40  ( ALLOC_CPUSET ) flag:

        ae63:    83 e0 20                 and    $0x20,%eax            # Test __GFP_HIGH
        ...
        ae6a:    83 f8 01                 cmp    $0x1,%eax             # Set carry flag if 0
        ae6f:    45 19 e4                 sbb    %r12d,%r12d           # %r12d = (gfp & 0x20) ? 0 : -1
        ae80:    41 83 e4 e0              and    $0xffffffe0,%r12d     # %r12d = (gfp & 0x20) ? 0 : -32
        ae87:    41 83 c4 60              add    $0x60,%r12d           # %r12d = (gfp & 0x20) ? 0x60 : 0x40

  For  __GFP_KSWAPD_RECLAIM  ( 0x800 ):
  It uses a conditional move ( cmov ) later in the function to set the  ALLOC_KSWAPD  ( 0x800 ) bit:

        ae72:    25 00 08 00 00           and    $0x800,%eax           # Test __GFP_KSWAPD_RECLAIM
        ae77:    89 44 24 30              mov    %eax,0x30(%rsp)       # Store result
        ...
        af2c:    80 cf 08                 or     $0x8,%bh              # Set ALLOC_KSWAPD (0x800) in temp reg
        af2f:    45 85 c9                 test   %r9d,%r9d             # Check if __GFP_KSWAPD_RECLAIM was set
        af32:    0f 44 d8                 cmove  %eax,%ebx             # If not, revert to flags without it

Testing with a modified version[0] of lib/free_pages_test.c (adding
printks with timing)...

[0] https://github.com/bjackman/aethelred/blob/2ccdc84ef087c2a631914f58e106e99e19bd3b98/page-alloc-test/page-alloc-test.c

Old results from a Sapphire Rapids consumer CPU:

[   67.157118] page_alloc_test: Testing with GFP_KERNEL
[   67.157122] page_alloc_test: Starting 1,000,000 allocations...
[   70.704446] page_alloc_test: Completed. Time: 3543002 us (Avg: 3543.00 ns per alloc+free loop)
[   70.704456] page_alloc_test: Testing with GFP_KERNEL | __GFP_COMP
[   70.704460] page_alloc_test: Starting 1,000,000 allocations...
[   70.944672] page_alloc_test: Completed. Time: 239980 us (Avg: 239.98 ns per alloc+free loop)
[   70.944675] page_alloc_test: Test completed

New results:

[   70.079015] page_alloc_test: Testing with GFP_KERNEL
[   70.079020] page_alloc_test: Starting 1,000,000 allocations...
[   73.669396] page_alloc_test: Completed. Time: 3586954 us (Avg: 3586.95 ns per alloc+free loop)
[   73.669402] page_alloc_test: Testing with GFP_KERNEL | __GFP_COMP
[   73.669405] page_alloc_test: Starting 1,000,000 allocations...
[   73.905084] page_alloc_test: Completed. Time: 235496 us (Avg: 235.49 ns per alloc+free loop)
[   73.905086] page_alloc_test: Test completed

Seems like a wash.

So, drop the flag value coupling here and let the compiler and CPU do
their job. Superscalar CPUs are pretty neat after all.

(Used AI for the disasm but the rest is all manual).

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Changes in v2:
- Updated alloc_flags_nofragment() too.
- Link to v1: https://lore.kernel.org/r/20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com
---
 mm/page_alloc.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f5..0111cdbdb5321 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3739,13 +3739,10 @@ static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 static inline unsigned int
 alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
 {
-	unsigned int alloc_flags;
+	unsigned int alloc_flags = 0;
 
-	/*
-	 * __GFP_KSWAPD_RECLAIM is assumed to be the same as ALLOC_KSWAPD
-	 * to save a branch.
-	 */
-	alloc_flags = (__force int) (gfp_mask & __GFP_KSWAPD_RECLAIM);
+	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
+		alloc_flags |= ALLOC_KSWAPD;
 
 	if (defrag_mode) {
 		alloc_flags |= ALLOC_NOFRAGMENT;
@@ -4478,22 +4475,16 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 {
 	unsigned int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 
-	/*
-	 * __GFP_HIGH is assumed to be the same as ALLOC_MIN_RESERVE
-	 * and __GFP_KSWAPD_RECLAIM is assumed to be the same as ALLOC_KSWAPD
-	 * to save two branches.
-	 */
-	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_MIN_RESERVE);
-	BUILD_BUG_ON(__GFP_KSWAPD_RECLAIM != (__force gfp_t) ALLOC_KSWAPD);
-
 	/*
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
 	 * set both ALLOC_NON_BLOCK and ALLOC_MIN_RESERVE(__GFP_HIGH).
 	 */
-	alloc_flags |= (__force int)
-		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
+	if (gfp_mask & __GFP_HIGH)
+		alloc_flags |= ALLOC_MIN_RESERVE;
+	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
+		alloc_flags |= ALLOC_KSWAPD;
 
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
 		/*

---
base-commit: ca2351ac6da277a470d4fcf122b53267e02b2716
change-id: 20260612-gfp-pessimisation-b258a4bb5ebd

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


