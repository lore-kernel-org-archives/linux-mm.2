Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC6DF8A175
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 13:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4BA6B0089; Thu, 16 Apr 2026 09:29:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465C56B008A; Thu, 16 Apr 2026 09:29:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CFA6B008C; Thu, 16 Apr 2026 09:29:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 281E46B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:29:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB2CE5AC8D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:29:02 +0000 (UTC)
X-FDA: 84664499724.14.8D04A22
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id EABA6140012
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:29:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KHHbyrwh;
	spf=pass (imf23.hostedemail.com: domain of 3GuTgaQUKCLsfmwfshpphmf.dpnmjovy-nnlwbdl.psh@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3GuTgaQUKCLsfmwfshpphmf.dpnmjovy-nnlwbdl.psh@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776346141; a=rsa-sha256;
	cv=none;
	b=itFBeGv2GN3j8gTefP8r690QzTo/2dY+RWa2CUAkH6buH0RXANlaE06C3IAJeif8CuZLwo
	JaBevoEex2mxwJXViZLB0jTRS3LTulxri29KKbva+cPbn1wkOFL3D01q3jvU65NG6+t5XM
	WH7C+CVZ64hg2ozzATQIliWu6AFLE9s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KHHbyrwh;
	spf=pass (imf23.hostedemail.com: domain of 3GuTgaQUKCLsfmwfshpphmf.dpnmjovy-nnlwbdl.psh@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3GuTgaQUKCLsfmwfshpphmf.dpnmjovy-nnlwbdl.psh@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776346141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sXyay+WHlh8f8CqBFyXL5GTNWYbapDVN1nCV3X7TprM=;
	b=B6sdYVAeCe8x4fY5aKWPxnjz5itwSVmG8lZdcF1T0/jK0WBece7US2jAjIje2xfIKKDkV+
	55GCDTpnMzULK/wOTHQcwjWLF1W9XYdzgkq3+5gHwB73lLZ7egIJnhnKTeKo/09aEIZDCo
	YA3+6oXzs5dqt6EF1DotcwJ+AWzlcVk=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so66761905e9.3
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776346139; x=1776950939; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sXyay+WHlh8f8CqBFyXL5GTNWYbapDVN1nCV3X7TprM=;
        b=KHHbyrwhFwdedRtctl/PxXYiim8aKLHy0Qiwi9c4ZSKSpQouLnVah1z3OLYyTSNMnW
         /GNWtvP4xkQrOoZWVEyZrZv+xkTE4YBpN62kk+tRI39Q2e4RwUo66kjHN0qLGInc9H+1
         /T3QflW777keIMc/lFMg4FlOEXV5miHVpfnuhHnca/id2/ShXDcVW6sXX4aihavoajhe
         Jo58O15aTA9WuFaVujdFH2h18FjvS+zbwKq6ETreGlnf9eei323Q00W/JhKWJInbY9/N
         i0VctTVhYA+IGs/ACfWxZKEJuT3sf1d3/f/Ll4yjFtd9Ty9fi8APwhghzn0s03/WZqR0
         nh6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776346139; x=1776950939;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sXyay+WHlh8f8CqBFyXL5GTNWYbapDVN1nCV3X7TprM=;
        b=Pe/aDhtBkBI7Ve3lI3G/P1xxgJ/32+HnpTigJY9vVYh77fq8KI39jUMVvuj2e2BZMm
         oZVLBp5OnlN4yzVu0FOT+Nxrn9aReE2zuHw3rU9Wrn7rVuNcF1Zcs1bx7I8jHBvEsTcK
         6RjUbMaoqFrwDdwGVHb4aNHOvV5TAks8G+pY6R81NMcOp4kaYuXSv5gJL9kWfdKVEmWf
         rPmGrVACRoQPcfxbCFAT32ile71G8plRv1UuGlbJaBiwwLVInAJ/4ogPWgf/Q8zqNwL0
         VKtSkiuasGFePPsj3LlsLgth+Vg00g92agYm8Y5a0QsHcpLKlJeMhYz3B5IYRiar3nbp
         I9CQ==
X-Forwarded-Encrypted: i=1; AFNElJ/xLCUtgdwrRfT9un+r9H5U2keLSXyYo7rGcroXIzzvJ3ftqEwgMEId38zGvgVop53GBz5bdWbTQg==@kvack.org
X-Gm-Message-State: AOJu0YxcTd3rMtDw84cDXsRLN39a/Ypd8ka+69Xg5EaBPfE5gU08/PFj
	TN4KwAGXJvn0RqTnlbRcC8Q6X9zgbIx57haiwC+lVShLiDYm+Vrejb4fWAfDnmS882G5VezERkk
	4Lw==
X-Received: from wmtm7.prod.google.com ([2002:a05:600c:c4b7:b0:488:a6d9:e91a])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:45c6:b0:488:a797:f0ac
 with SMTP id 5b1f17b1804b1-488d6ac2226mr319528795e9.28.1776346138934; Thu, 16
 Apr 2026 06:28:58 -0700 (PDT)
Date: Thu, 16 Apr 2026 15:25:07 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc1.513.gad8abe7a5a-goog
Message-ID: <20260416132837.3787694-1-elver@google.com>
Subject: [PATCH] slub: fix data loss and overflow in krealloc()
From: Marco Elver <elver@google.com>
To: elver@google.com, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: EABA6140012
X-Stat-Signature: ssrnseij8dgxjqzxtp99msbo7rf5kg9o
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776346140-425858
X-HE-Meta: U2FsdGVkX1/IC/MeT4jTQaq/GKpqqi4JhjNdsqUedMKeFj624Dci365JaJjN/dr0i6MeEFs10LoQH+FQFGi5/8YFhK9dQgBtTqE1rYpY1aKycQcRA8510ovJ0JzufCux0S7WTojl2Z1L9cnRQemtADi02gtFWQsErGlANl0J9fqC2uCGJRv/mBEkYlQcxH4L4YuIIEjAOOFFfp6W0bxkH5AGUkrFBPs81GCmzdJnCxfiev5iJYG60dpCH2lCKpGCPzdxFevEKSOkaATf9euKBmHD/brQ7Vc2XYNn7MfwQZIm4tmJUaNibGuZqvP48J/xlM873Xx+8PxIUa4mPTxGvVf/g/6VPifFEPvtA2BjoqBbrh6Pmnqr/hv9W7p5OIrOO2IMVJsuSvI+BEZdkn+LLQIzoBzX9r6MoB1uIlzmv5O4vLBGEObB/r/mqQJpnAvQ4r5C3kWw9CE4qtdikT10+d7Gw8vl/z9aNEE0ML4LFNdJzLh32TRst55PEj6wfvnWKAaYJFQ+2rBVHHXfDmHZoGZsXClMlDZsnXEtx4eRMyeredPGO417X25DEt+kWzBgQb8FQAPyLzIHlpAYc0L3ZhUXlDCFSbeaqXXoJryUB4dqVjn1S55XWkbBoENpfRJLxuzhZo0P1KP1B5s7mDk/qs/vNFDKcQa5lDN91SsvSBWQEtmRSsrZRY3V7NvMW5jM2EgZewr06s6wVdcGdH4TAo35+rUWUa1PkKbxafH90CsJrskCPacDPzZcPskhdgEDg7+GCjwYSHGIOKIo3C2kHpP6BBoayl+HA0KyS+QYCE46M6E/kyYfbJwLELEh0nWh2l8hRFzzS32DQFS4zHkndfdPQiRbhxASZLpAzjSX/aJvzJ0LQ0GMvJmxDaWY/qcvEByloQEK6OHFA5oG/+4zQ3vVtohWEoNQ7L2D30U9NKox1nQxaJ4UUG4rauRD2eyy3/Qi0ePtvutiRwxtd87
 bydR10GL
 1KcsUZojJrj/7mOLgUXrBoK1TiBPf0P+u0ziE7xqkieMAGmhyxZT5pWY3GYbB5UCraRFTNKIBWPfG0TjfnG8ABMXJ70o2hPAuSA2SVpFhwlCgN1WWT//8E2iXFi2INjXNR2Iq9/+rwR7NAKYqe2NPNyPT5PbovlWh7giLbFLKUtDhJ0EIIw4YsYiRAfbz2Tbmf2LyrxzwailC6ZWStOT4bQCWn/LRMtuz6N/u7PBQsRoeOYV2aiUUSS1MGN1xbZHRUMXXhA+1iN5I/4gfOywIeFiFJfAuNEvE1v/vg+lzEHZjiPoxa6A3fZ0RuCsxXD63j5jFUHLhTLT/5X9AwMt+l/3Ccxv8yeGAeb+DE8BtYX0olb2poxE4zym5XU7tajwfs5lV0snwI8lj+A74YpDGCuuTvj7WSiG8Bg+2HErqS61xJP4Pzl8zY4SwCBP1KND8NBc/Zq3oSqDhRA9Gy13DMWgeKUPiaymqSKivCSyi/gnROeNuly+091Rub2OzqVJ1kykR80pBQFxXDEafBkfyd6aAtRFW0orDX5lRZ+dA+LlJWkfXCMfVrDFzUexXFxKUNuXe2rLP65S12eAyAiQ0qzIHqdjbKiR59ojl7unPRHbcZ0yfyxQl7whj9bMvFc9Bm8aIvA5TPwaXsL6S7yx9nbbvMcs0lqbquiQ3hO0Y3nN5ENDMu9pCq/0pRdL3VfA2ytT6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2cd8231796b5 ("mm/slub: allow to set node and align in
k[v]realloc") introduced the ability to force a reallocation if the
original object does not satisfy new alignment or NUMA node, even when
the object is being shrunk.

This introduced two bugs in the reallocation fallback path:

1. Data loss during NUMA migration: The jump to 'alloc_new' happens
   before 'ks' and 'orig_size' are initialized. As a result, the
   memcpy() in the 'alloc_new' block would copy 0 bytes into the new
   allocation.

2. Buffer overflow during shrinking: When shrinking an object while
   forcing a new alignment, 'new_size' is smaller than the old size.
   However, the memcpy() used the old size ('orig_size ?: ks'), leading
   to an out-of-bounds write.

The same overflow bug exists in the kvrealloc() fallback path, where the
old bucket size ksize(p) is copied into the new buffer without being
bounded by the new size.

A simple reproducer:

	// e.g. add to lkdtm as KREALLOC_SHRINK_OVERFLOW
	while (1) {
		void *p = kmalloc(128, GFP_KERNEL);
		p = krealloc_node_align(p, 64, 256, GFP_KERNEL, NUMA_NO_NODE);
		kfree(p);
	}

demonstrates the issue:

  ==================================================================
  BUG: KFENCE: out-of-bounds write in memcpy_orig+0x68/0x130

  Out-of-bounds write at 0xffff8883ad757038 (120B right of kfence-#47):
   memcpy_orig+0x68/0x130
   krealloc_node_align_noprof+0x1c8/0x340
   lkdtm_KREALLOC_SHRINK_OVERFLOW+0x8c/0xc0 [lkdtm]
   lkdtm_do_action+0x3a/0x60 [lkdtm]
   ...

  kfence-#47: 0xffff8883ad756fc0-0xffff8883ad756fff, size=64, cache=kmalloc-64

  allocated by task 316 on cpu 7 at 97.680481s (0.021813s ago):
   krealloc_node_align_noprof+0x19c/0x340
   lkdtm_KREALLOC_SHRINK_OVERFLOW+0x8c/0xc0 [lkdtm]
   lkdtm_do_action+0x3a/0x60 [lkdtm]
   ...
  ==================================================================

Fix it by moving the old size calculation to the top of __do_krealloc()
and bounding all copy lengths by the new allocation size.

Fixes: 2cd8231796b5 ("mm/slub: allow to set node and align in k[v]realloc")
Cc: <stable@vger.kernel.org>
Reported-by: https://sashiko.dev/#/patchset/20260415143735.2974230-1-elver%40google.com
Signed-off-by: Marco Elver <elver@google.com>
---
 mm/slub.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 92362eeb13e5..161079ac5ba1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6645,16 +6645,6 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
 	if (!kasan_check_byte(p))
 		return NULL;
 
-	/*
-	 * If reallocation is not necessary (e. g. the new size is less
-	 * than the current allocated size), the current allocation will be
-	 * preserved unless __GFP_THISNODE is set. In the latter case a new
-	 * allocation on the requested node will be attempted.
-	 */
-	if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
-		     nid != page_to_nid(virt_to_page(p)))
-		goto alloc_new;
-
 	if (is_kfence_address(p)) {
 		ks = orig_size = kfence_ksize(p);
 	} else {
@@ -6673,6 +6663,16 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
 		}
 	}
 
+	/*
+	 * If reallocation is not necessary (e. g. the new size is less
+	 * than the current allocated size), the current allocation will be
+	 * preserved unless __GFP_THISNODE is set. In the latter case a new
+	 * allocation on the requested node will be attempted.
+	 */
+	if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
+		     nid != page_to_nid(virt_to_page(p)))
+		goto alloc_new;
+
 	/* If the old object doesn't fit, allocate a bigger one */
 	if (new_size > ks)
 		goto alloc_new;
@@ -6707,7 +6707,7 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
 	if (ret && p) {
 		/* Disable KASAN checks as the object's redzone is accessed. */
 		kasan_disable_current();
-		memcpy(ret, kasan_reset_tag(p), orig_size ?: ks);
+		memcpy(ret, kasan_reset_tag(p), min(new_size, (size_t)(orig_size ?: ks)));
 		kasan_enable_current();
 	}
 
@@ -6941,7 +6941,7 @@ void *kvrealloc_node_align_noprof(const void *p, size_t size, unsigned long alig
 		if (p) {
 			/* We already know that `p` is not a vmalloc address. */
 			kasan_disable_current();
-			memcpy(n, kasan_reset_tag(p), ksize(p));
+			memcpy(n, kasan_reset_tag(p), min(size, ksize(p)));
 			kasan_enable_current();
 
 			kfree(p);
-- 
2.54.0.rc1.513.gad8abe7a5a-goog

