Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE859CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 14:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09156B0096; Fri, 12 Jun 2026 10:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9976B0098; Fri, 12 Jun 2026 10:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCF706B0099; Fri, 12 Jun 2026 10:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE13D6B0096
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:15:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 589CDA0128
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:15:54 +0000 (UTC)
X-FDA: 84871459428.08.3CF6E7D
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7385180004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:15:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TsOrCF7G;
	spf=pass (imf30.hostedemail.com: domain of 3lRQsaggKCMYvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3lRQsaggKCMYvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781273752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3aqjAT0fRHYdS66UFRNsM8EkSHwMJb62tgtmp8RP6ZI=;
	b=B3Pn7UPl9QIfDtYzNkAJTTtmXfIKRZUZl6lDKyhXK3sRBYYO/POL2+7flyGF1vwN4mw1rC
	ioBr8LuSivKtG9qPWMz18Jwt3QaJZAPXIUvClf/0JabxkIRsuHSBtIQ9QtWaFHPQtmVkpl
	cgoCIrul/EOc/LLKETQL2pGYXM1d0/M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781273752;
	b=umEcS/dWe7wQsB4rmdMtRTTtFAQS9UJg3VDyT4EskqFSS2y8VqTeYwtQ9/W97VhyDRGW57
	ewubb0TYhQck/61lhKNvJ01falq8JMH/Gi+Vt5d56u4vcL/OJ7MZB2i4nnP8dXE+gJxyC4
	RPcjwCkM60PwxLZCCv5ARCG/Z+YslQo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TsOrCF7G;
	spf=pass (imf30.hostedemail.com: domain of 3lRQsaggKCMYvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3lRQsaggKCMYvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-45ef616db45so815159f8f.2
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781273751; x=1781878551; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3aqjAT0fRHYdS66UFRNsM8EkSHwMJb62tgtmp8RP6ZI=;
        b=TsOrCF7Gg3NCMVAino21MhyxMTgkT2ZQAK9BK9CGs0LEgdrAU2NS6iyhdTX7E3iNvl
         1/tG0qLchOugQ38ii08BOdObObBX7HznWp8kCx/bSOHj7X28I9wpB2Qe5zF/hm8/rEzq
         D4S4DYllrFmnL4YNQQMQISosMl8FD+g8xlvHKnZibXpb7h75e9UL3Lg6IgK53D/JyyQC
         6IbZyryNkBl/Upq+IhgiphwAG3tJ5Hba9/DNTp4lEN017lnlFAt9PJOuDbJuTVxdRabp
         xUMyb1TcZZe9oYzBr/+H9aUV5JEDFkbWO7z3f4tbiMM0zs6Z2O+DH/o8jni2gZemQnlx
         JpJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781273751; x=1781878551;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3aqjAT0fRHYdS66UFRNsM8EkSHwMJb62tgtmp8RP6ZI=;
        b=bfwBzgVsJIvbGXoWHjFqRp3yVu9NjgdFgJxUYrtabcvHxXyNDVRgtwT84RnHHBsiqz
         iqdwMMxEOHfzCFQZBmJJpdXxMxOBS/dYBdSOfRRM+qMM5iTOo1meVqNTrfvpG9NubFy1
         H6He4Tr/RIjhJ2eAD+t5rgpQSHxdEgmPjfx/KzfSFLGZBmNUaxn75VhLVqog97iyUZZA
         HZtUIhDadT83/ASa6aXLBwnxO1Lw3wk7ehbf21BXPurvDTH3n+tRtH+hrkW/02jtN2ph
         RAN5kh71t6N29LsG6mX72M8NUs0KiL3KGsbIYa2Qn7JegzXqb8/yVL9HIbBNl+6urxBl
         9UDw==
X-Forwarded-Encrypted: i=1; AFNElJ/8NJGpE2eRRS24qlZIm9eqHXkxVjkNfkLz9LS1yOySrB661WRK/TiXjFo4Ne9toYuSTEcKkVnhiA==@kvack.org
X-Gm-Message-State: AOJu0Yx3I3VtZNuRmrClAhujglTOc7daedAuBGcq21O1qpWWUnsEWIqg
	vqYzcB5uUhFS96uD3ipRnk4NhGUjiHlYy8+4OXsO349NIhZMX8ttSF5VuA5pltav4yNsarlF7zS
	NZ31DhwWEZE+Fcw==
X-Received: from wmpe36.prod.google.com ([2002:a05:600c:4ba4:b0:490:1b6b:9818])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3586:b0:490:c024:2ec8 with SMTP id 5b1f17b1804b1-490ec339ec0mr48700225e9.0.1781273749232;
 Fri, 12 Jun 2026 07:15:49 -0700 (PDT)
Date: Fri, 12 Jun 2026 14:15:44 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAJAULGoC/x2MQQqAMAzAviI9O3BFRfyKeFi1ag/qWEUE2d8tH
 gNJXlBOwgp98ULiW1TOw8CXBUxbOFZ2MhsDVthWrUe3LtFFVpVdNFxmO8KmCzVRwzSDdTHxIs/ /HMacP0vTMpljAAAA
X-Change-Id: 20260612-gfp-pessimisation-b258a4bb5ebd
X-Mailer: b4 0.14.3
Message-ID: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
Subject: [PATCH] mm/page_alloc: drop flag-conversion "optimisation"
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 7385180004
X-Rspam-User: 
X-Stat-Signature: 3zkn16hhpcebjgfhhpmrrp65cit4hnq1
X-Rspamd-Server: rspam08
X-HE-Tag: 1781273752-435181
X-HE-Meta: U2FsdGVkX19FYkTPQkugbX3a6jHLEttjSTD+3yG9O400kPdQvB048NNoeQFokmy5uIGsmWgX1eoVlRsRjw/76cHEzFldsHQfMQG0PzjolzRghidY+pI+ojlM6mAmuKBWTTdtHZwvVXo/ImOR7vD+2nJ1jNcbgDl27QA/HyzBzJwEqj2x5/iMez6sdou7b8nVO5lBGcjTk2kxEeOHI43y5nBTQ3LQyEi+qlczPpWjuLUdc4D6Z0Po0JoZOMrleMC80ZrYJB0mXeffTSkZeP/Fig2DxdwAaHePLG8gyWzFlioRKM1sF7k5ECBPMoIlDtzNd0+QB9y9pjv9Zvt4xGB6xZbyYmkF8UuG0F5B70fLG5uMuEY0h5UV3OCNKp0EoOjUu7Py3mqoGQQlFw/tz+wdbjN603QaaVLwQQ9NsjAEJcW1BBUNDtAN6UHdq80ryU6GRZPX1UsZYWp1Vc3ml8dsu4RiIIsp5Hfo2I2eaCV31ucUVp8oVjBDvUUKojv8elwZpVTaxQ5MuAxTmJJfCWLnsKP+eKI54i+6PtJb1Ze/CzxpYommb7jzZ2bW34c62yx1hJguBBhRjWP1vbRIONdR4vTHvyKmywMvSkw9QZ8EdJs62wZKBUnmTvQWM3eJB1VJlyBinPMUAr6q9LanX3AjMKcaqQJqrQk3FT5n6vvvSwX0joaDlC28a+CaI2JKMiRGiBcQAwrQjV/YXoA4XJ+Tety2Sx/uzgh/HmDCBm66YCOJZysKRtrF/RoIF/qKnSfPZ8XD7Z2cdmkfc8WmjTXic0Wn4B7UR3lk0gDMjFYqui1erRsPi3bKcoO9Sw+d1HXiGjUOOF/0+yQgaCk2pHIdYTZ7SDe8A5dgmAtU72cDcT6XckoP7SgzB2/iaPG2SOMCApyJUvRoR1mxs2hyXy3EX0i3SE+hRCS+31k4zVYaFxLU31O48BzBcYV4Q1bvVoLSy2EPr2SFVj+2tvmq+Rn
 bGUL98Av
 KA25D9NAT60LBWLJ0/Ftdq5Hoqe+p3BlfvhqVTPim6RJECu89qHP21JGuwwP/sgTOH2ymnpTFdtitGrce1sTQ44zh+3CV4deUZr91KCJxjfqqk8E+cbDSIkYN4jf01vKZHn6uO6KvPY9mnLynmMvRea6rfd7E7/f8TcWccCYqnv7379850EyIvTSTB3N5bqvsxArfXY7t4E15Qlf8JaY2WHkZLPl+yw+T05UMg8Z5dEKpttV1NTf7zzlmRLCnQUlY1UdezPxjMnXqvieRxR+1D5lccpYGKRGNvfVA3qgnFBjSjrPw7xTTNSG4CEjK/7uEoQvMYCeLBTy/TuN8eOWSJLc9OY/Ur8qhwF2s3nqHe6l/SZUsa3y1bb2c70z3Uh1uoPx72owhf4iCcGxESsD2zpDWyiHaZ2jYcVUAgeSTPaqArJPUuH1OZXorzTaK4VCyXG8VtRwNf7asiG6uoVO72z829jmlLrIiVxoFfwBgaSYcfYmqSXfWdryD/R/g1Oj4xIAfPUAC//5JJAW+6HLJcBqKbhCZjyiMMJ6UNfAxlNV34T1ZDPlFAdOPLJMqmDt99r/6j1S0Ybx+oWrvfwHoFBiTdwsTmO23AfELp0Ei+UqKVg79QD0lwPgqtjJ2kIXXuVyiCBtk1bvkFm7gIpNWOQC3j8qTjjQdJyIf
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
 mm/page_alloc.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f5..9e1949ea13a6d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4478,22 +4478,16 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
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


