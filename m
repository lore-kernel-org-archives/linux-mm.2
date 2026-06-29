Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D93A9C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6F9D6B0092; Mon, 29 Jun 2026 07:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46826B0093; Mon, 29 Jun 2026 07:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5CAC6B0095; Mon, 29 Jun 2026 07:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75E306B0092
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:21:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 014A8A068B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:03 +0000 (UTC)
X-FDA: 84932708448.14.702B3B3
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3492720006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RKDIQvr2;
	spf=pass (imf13.hostedemail.com: domain of 3HFVCaggKCCkOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3HFVCaggKCCkOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782732062;
	b=RQmTItckNsDC5PKYq35HQbGb5NfBNLwkJ6kLFJkwXAYbocWzOMQwdrEcH9ZW+ztBIm2bKh
	H5635qdiM1W/jMlr3xRuuSpLqxlGyqeR7ny/lGHEWY8RPJA3IDrvI2HryHr45HGYrqeIMQ
	6Z0cJsDVxQTbrrd+lGgGlrqKu6JvZXY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782732062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mbDCXnvOe0PS+9eULlKq61NFwxP69D7MKsKlxC6XXmI=;
	b=m5KXEuEeplnR8pCV6zIikIvDa+SzlsMjtqMfHuSPEcBjiUWTL64FRvc/TddLB7fEY3qvbC
	W4hRh6Kx4u4lhh9W44wcDfWpyQ54CXSUS4tBXO3y28cveP6RAxxDhAmKCSpRaymOq7YPyT
	f6zwlcbU1//ayOpj6/hzCaE7vNI2Zwo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RKDIQvr2;
	spf=pass (imf13.hostedemail.com: domain of 3HFVCaggKCCkOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3HFVCaggKCCkOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso26382345e9.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782732060; x=1783336860; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mbDCXnvOe0PS+9eULlKq61NFwxP69D7MKsKlxC6XXmI=;
        b=RKDIQvr2fKSTgstmW1iga2+j4WuRSWubZQw6J4vFlEkMu/jnR8E7OqZ1BASJ6jSinQ
         +7Tf96SimqV8/9jFf4ML7UYC/kZJEhHsEOfBt/L0j8V1fo0T03IvtuuNneJC4TNTOzyf
         OJS4PobsijJhp3UtqFgGyvLVpVa5o+aSkKpPqUziWwcGBuiFV2NArOe8ipAmHs/IgI+E
         BIzy0GTG1uiG9EMsmFNXa7eXajezgp8ZZv0H7yS+miWX8458MzPVcBkk5lMR7bLGysHT
         8yQKymhAGFnQaUSeD3DfkalBeYzg3XqHcBpke+11sXzzPlwRIqFimKd7JbeOZQWQmyz8
         nQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782732060; x=1783336860;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mbDCXnvOe0PS+9eULlKq61NFwxP69D7MKsKlxC6XXmI=;
        b=Xygq611Pheq6om+M+cKd9u6/CuJzYfybq1H3sAq/u9C3SXfDozkZGZ20oyukRTj5bo
         t7CzOrkKnu8J+ukcd32zllEYdP1yqt/hFAzLLpgQQv6Lzkp0kagr25qIQpnt8ByOyE6C
         54xPggh/vQV817jFpHTOSzy1pW3tPw7DE+LPJeNf5XIYvZ+DuBfFjKBxTaMLyQMOcyY2
         JmETRJOfof245iw+reG8/tUUHbFYExX9TvMaY93emsDHbRrOHHxSgnA+1HOcBUOpPB/8
         88RG9maFSZ1/+c9QGsNYdtS7wQcQdLFRFbOmbVfo5PjJcQy/3O93WWXz8YaKrkqSgcd8
         K8UQ==
X-Forwarded-Encrypted: i=1; AFNElJ9guVwItiEv3ysF0ePlhntJAqNYeuH2CJevsOYn02edqiqrjdCvieFB/NFsgJk/slfhi1CnNaPVaA==@kvack.org
X-Gm-Message-State: AOJu0YxSlrINZC6FZ8MiOs6IJHn3Wh3vPC2u6i/6v1Hg6FaMdqYsG5sQ
	8wDEmaMrnEW6WzmhGg4kJQYao9WWKQJpxt/ct0Qfwd7ssud+sUW8wHrN8bWq4nvxRnGRBVwqlMV
	Q0Xgrg9c4eCV3eQ==
X-Received: from wmnj20.prod.google.com ([2002:a05:600c:754:b0:493:b691:8628])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:e54a:20b0:492:6093:8837 with SMTP id 5b1f17b1804b1-4926689a4d1mr175771275e9.34.1782732060367;
 Mon, 29 Jun 2026 04:21:00 -0700 (PDT)
Date: Mon, 29 Jun 2026 11:20:49 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIABBVQmoC/33NsQ6CMBAG4FchN1tDC63o5CCrg47GgcIBlwglL
 Wk0hHe36aSJcfzv/vtuAYeW0MEhWcCiJ0dmDEFsEqj7auyQURMyiFSoVHHBunZiEzpHA7lqDm2
 mhSyqXGuJuoFwN1ls6RnNG1zKa3k+wT3Me3Kzsa/4yvO4/aN6zjjbZwp1moca7o6dMd0Dt7UZI ufFJyF/ESIQSrY843tUBS++iHVd30YGlHX+AAAA
X-Change-Id: 20260612-gfp-pessimisation-b258a4bb5ebd
X-Mailer: b4 0.15.2
Message-ID: <20260629-gfp-pessimisation-v2-1-311ece6a8637@google.com>
Subject: [PATCH RESEND v2] mm/page_alloc: drop flag-conversion "optimisation"
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3492720006
X-Stat-Signature: kqsi1cju3ono8jpgo1awdmskuy8izuqh
X-HE-Tag: 1782732062-875293
X-HE-Meta: U2FsdGVkX1+NktxZGC/RzemBezyrwMftj+xpNl5xs252XRYfhuu0YUO3NmjewyB1mXPRLccwKnWgU9KbYpvVFam1Rqj+mCbsGgGoAISOyriPHqukeZTZXuCzkEYGpizg+kiAAL/aGtZE/J3OA/tFS0MPZNKBOPcysvsd6gdDcqC3cTyMsb13Zbl5EM/XrWVlRx2mkBYAOKyRJwyLIDhnL8B8/tAdH9MBnpufebAIAyji4YdL9Ws8kjBio9DuFw31a5Qw21dthdqRHCRxTX+gBaH+MI3+z/Sw9g2AH1D8PxmWmhe+De0KYg+cnsXgJvlh79Fva1Fi/ijevsiz3w+z8rd5B+PF00j+H4VDsSZm0JM6biyZa6aPGsh2i7gn2evar+lNrgGQM1KLlduQ0KOTG08pcTuaqsQiM5n/Zo4nxFiNh+u+If4vwQKl/wP5XBT+PidR3Ja6tdWBUH3NBVushEP70Gsmfv7/Z3JrjmaywIy1mJONEAf+ZkeOHsKC4NJgNK0DpX7q+VMJlYzNNZnljZNvA/NOEgqCg2ywlZ5YeHJLsbA2iQUkuEkDM80Ubt2gzKSvbMAl3CtvHQxW7RxuvdRCVMDks9/rmQ9PK0ff5/PrcwQ1cHG0Cco64jpzXiP64wepO9s1IelnqSD8Uc7q8b1B4brqB3DosLZdjzzmE8f8g0Aehqfv+OWlYgMBEqljliJF3YETrTjJygI+yUUjZ5HrDrw6oO22ifohumbxtRBWT76B+lIJqXABmFeG3xlk8+yOGq1qzSqMBnKb9on+FswbNKDWNjkepRwRsARvbaVOwAuCTjzULfC1xqPLuFdlLkJWOxEIlPpL5PSXYZ1VTVwKUyF6UJ7DwPifezAYXZClGRkc4TCAMgbkzD9+4j1LcY0c+GLQeEzNkqE782ud7n2ByRAh6TgSyBeY0yzQG4HH4gRJQif/GLfwX9k9b49BXuHYYCIw0fibX+SxfOU
 7UT99SFF
 G3/Mk8RhI9WVsZAmvRsRHegYMeIr5AwMx7ARtKwD4PdmeeUcTRZLmNIsx2iVoHPzlsQ/v/hDFIQSmTAsinfVhi/4x/0eriGZTc9FjD6zhSz0Lx+Yru5KjBisihCqUDsIs6BHkS7RppYx1jbqoGsWyCyN68D1Xq3FdsXVkIBN3UjB4G2y360qRsNUadZblJmGYpM8NjQnl1cjGYe11+OrDNnTTsX/T8yeuBd9eETjTPJMa5dfYdnBBVHI2Fb+kFdjCO9vldr6BeNAQ2/Uz/2x5W+DYt7RLFrdsSOWV2OIrK44oQ7k6WL1LTF+vRfwy2E70NdBCpcNEPTW3WRbKSjo8TIJuc+bJA0C0y0NQd+7Uu7dSyuxRye9CWmEPwPzNF6GuKWesMGhyuxUTIt22MhH7/gh6J6J7ByVHfK+aJv57J1+3Lt4dVmnA2tMBzhQNjVkt4sp4zeq3Gvb3nMnqMau76AOx4SFMnH1sDf7Gq5+5yjOsZSIagafgcusbwYOJbhlvLpT5xil11U4NBwaFXxuTT7oaLWGASNWNvkhJNoQhzsa0PVxr1UbX+HivvzrLAwSoYRj6p2sJ6MkUPrOZNXN/Fx527snUcZSV5o3UX3SqdQ+XNwb+ScS86PP1zFUN/Y/7zC/kLeLKyGpg6F4PqTtPnU1LL8wczXqN09CIN74qXd9D7AQxyMZgpGxyy7X+YFAQuOAUQxM9in4AxcH0YvSVrPEGlrb2ntVvf224qBxrwoUh1WToHENoa3yRaRcqENHlSTuGPkmWAQLxKCZ1G3mztfmsJ4J1kEFilpuU4z0OwPMWomumXCZyfkMAAZlXusj4htRLngi+slDIpcxy2rH63gsiIooSQp22yklOUyjd+W++DVz7pcyjExXBd27ZwrxCdslmoK5jeIl6OBS5/swnNvkIuCNfb9XiMDTdjCBKmksNhOdMVsgdO7ol/ap/hrPSALU1t4i4E6e2CB9ZJsrvhPsqCk9E
 Lz2JWRiX
 hLqJJ9zzPV6PCTEeeNLQrU5iBHbZR2vE
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

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Resending as my prior v2 was during the "quiet period". Note I have
added the Reviewed-by/Acked-by tags without bumping the revision, since
nothing else about the patch or commit message has changed. Please let
me know if that's annoying.
---
Changes in v2:
- Updated alloc_flags_nofragment() too.
- Link to v1: https://lore.kernel.org/r/20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com

To: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Brendan Jackman <jackmanb@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/page_alloc.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f87e8c0a0c367..d60053a3ffe4d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3742,13 +3742,10 @@ static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
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
@@ -4504,22 +4501,16 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
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
 
 	alloc_flags |= gfp_to_alloc_flags_nonblocking(gfp_mask, order);
 

---
base-commit: fe61612214b618072b4ea3f5065a81296df6dd75
change-id: 20260612-gfp-pessimisation-b258a4bb5ebd

Best regards,
--  
Brendan Jackman <jackmanb@google.com>


