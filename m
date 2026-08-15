Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10E6AC5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 10:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9D416B0343; Sat, 15 Aug 2026 06:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74486B07BD; Sat, 15 Aug 2026 06:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C637A6B07BF; Sat, 15 Aug 2026 06:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 911BB6B0343
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:42:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05DA41A034E
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:42:20 +0000 (UTC)
X-FDA: 85103164440.28.377682A
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf16.hostedemail.com (Postfix) with ESMTP id 647B3180002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:42:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KLT12/HI";
	spf=pass (imf16.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786790538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QL+D2ZnVKPwk1r1lVr8tcXF6AdrhIQ8WvVtGFSKnTdo=;
	b=H9QCDr1n9j1/prwrbhZ1F1PYrOtoKjvPxqlruLlEV06tgoGeL/ENtXPUKoPvK1NqXQ97Mc
	aadhW+MapbM50krh9oWF0t+2wXNSZiJp59hnPagMC0cyT9BX/+DbMi+g6ImMD0cMTduaTV
	RuwhadN97hw9i4pukSadX5P8Q9DNmmA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786790538;
	b=pLH7hszo+B1mRLCBHBI1NnnBEIX8WyYYfnquqMGNfJEpkT8rzTJWaxckArCDkOpPKcfyG2
	iAFlgE0Z1MIR4iKbrddHeVo+WUiTSBDQW4THzeP1kLemUYfHyBemv2PKxB5nIRybmD5svv
	9jjEf+IY8J6Kv+4Vx/BTd1h9I7VqVi0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KLT12/HI";
	spf=pass (imf16.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f1.google.com with SMTP id d9443c01a7336-2cb3f5bb19aso9350335ad.1
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 03:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786790537; x=1787395337; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:date:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QL+D2ZnVKPwk1r1lVr8tcXF6AdrhIQ8WvVtGFSKnTdo=;
        b=KLT12/HI+THKMNm7r2F4povf6BdXg6B5SquehwmdJzI6PDuhfhYyZz+9qml9Tz/heH
         Jr+57cAv0GzGoQCqRAwqM8gN0FqRssGlTh4/xwmm2k8bs9gmhoqHr+O0QwPmBRxZ7Gk6
         G3TDcaRLx1/de7Qx9lmhxGwiKm3kgbTx8dfaT9IIn6shR65YDYNrHLGMYhjheilzxwG1
         1MshDfUvuj4So2Zs0rHi1KiwE5DlmplUwyD9uRPqc79/wPIsHlOqa7QKyaGgx7PlS4l3
         3ocxkRp2Sg5UH/rkI+Pj/xgnysT698QfI1LDpGauVLKS+h+YI7Y+PN5+8BHWhs9eq8gb
         T6iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786790537; x=1787395337;
        h=content-type:mime-version:message-id:subject:cc:to:date:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QL+D2ZnVKPwk1r1lVr8tcXF6AdrhIQ8WvVtGFSKnTdo=;
        b=U2dkZwgC4MUC8HDExGZBvZO5ekK609SS4TVdIsqBIxFNB71nj4hpyEvFB4dK86j7Rh
         O8wbvrRyVL5tefjTok2TVJkeVIYN1CLeX1AZiyp1/rPXu14ELQBCMS0TGKqMUPbIDz2o
         H0iegnmz608cA9YG2958McYcrvfup6o4yXF8t8OZANdSQ+hmXkrGMnrebqjMOXcsz+q8
         p2odEM+R0s7mC548hKl/tEWNe/dIt7dAoXlKMoCfwmczM7JCwyfh2UsgxA+tBDEeLR7A
         V/pSYWNd1nJ4NaI97LYIQaiqpJyE9PIcSDQYTQ+TC0TfRH60lB89Syd0PtNZDFVTRPxD
         QxCQ==
X-Gm-Message-State: AOJu0YwYPoyyFBz7aGSD3iiBcXyDSPmQ7hRnfXJcK5NFTJAyN8xzNNqD
	5js1qIBTpLGiD3QhXktwHwnUiT/Cx57skUOMDb3zRBZNdhH2r8Xok42C
X-Gm-Gg: AR+sD13OR+54dzP0dUx2qWCGzzZSPCFUApo85tsvQrdNH9LmuplVFhg2AahucfUk+BJ
	hcFAngm/8mURs1f4RAObA9lRqexyNVl+HFQBS9Rcju8E8STNhdqF+SGI3Mgmt8kfG4L+MZm6/Ly
	lqPJRM6XPjBYc6bwYENPTwJGCFHvp0uJExN6R2fsXno9kWbaHhm+eSAMXla8xxcGDVyYEjA4ymF
	NBA0Qawu9iobl5L1ezXiXnVPntRYr04a4s1MkpUWU6ol8qK5Y5lH5N6q04tUGe9xPIrByNniB8G
	Yyp1GKR61iszad27KZ5E4hQCLPhFCm6MJsAcSv4LeZ+facQFR90oKEPRqnZ1Pv6bRJzvYo5oqcM
	+la95bi+HtCarZ3Y14Scx+xNDB7Zch1P7AmuegZbfB99nrEGZSnjhWxuVJpMif/3o/BSA7oZk94
	+GQGxg+W4NgvlRA7y/qz643GSM0y+FmnljeOFAgCQc54R+613vXdhx
X-Received: by 2002:a05:6a20:ce43:b0:3b4:7eb0:47aa with SMTP id adf61e73a8af0-3cc71d19146mr15675813637.25.1786790537029;
        Sat, 15 Aug 2026 03:42:17 -0700 (PDT)
Received: from 192.168.1.2 ([157.85.198.7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1413889bca5sm25944351c88.12.2026.08.15.03.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 03:42:16 -0700 (PDT)
From: Foxie Flakey <foxieflakey@gmail.com>
X-Google-Original-From: Foxie Flakey <foxie@gmail.com>
Date: Sat, 15 Aug 2026 17:42:12 +0700 (WIB)
To: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
Message-ID: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: ht5wcauu5d3errc3toarzhw5j77mjmxb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 647B3180002
X-HE-Tag: 1786790538-103144
X-HE-Meta: U2FsdGVkX18EGTQBkU/7JSeYt5GfofR1MCfY+bMK+uElp0l4Mpglep7eaUgBlIyyK0oIizxeT6PXGAMzDhED9E44k2nfvQFpaRZK1qHlJRahOmFwfuS7EdFSA14iT1EMKhorEYuI78p7CuL52URfozFMb+vaub2ttN/OEw2eFP32rRmIe8UsZ8iJRGz8STGo+i/9QJMad9pM186Ck9Tdkub5IZ60Kr2HuD98qxxasKvFm2YRJNUaCQkp+9SOPTPjjSb4QghZZJt/NPFO+FpB1YzLwg5ypd8O84r0wUv3s1c0dFGOokYt32bRLgWE37TwjdpSQbhNE8fA0mpTpkcboO3QNt/xrCmkvrAWTkBb4WecuizBk9HfQqwTUzOfDIAHkjPEyMs+ODlCi7ekVm3HC1tAN3krsQnSXgSqyabqG8ZI8ugXI4M1wSwdBPBDGNG2i4U+8UwtRQ8B3Wxup71DnKJOtir7iLX62UkPe0yQAGSMAzRmEydFeLud1zUniNaJbyVzFfwgLZ9BHicwh6FiTMS096jtxdElhLrRxe4Ec7C4IwRQzEO7AVCv/VxwQWKvWmRmwGpGi0hdH+W/ov/uzfc4WHGRUPB2JXkCeOS7AIF5qz6b9/VxoLCPra6WS3F2Q8jukqx+TRZNIxgBpEC8S/7dy2Xw0Jck/lZ569o5qkfFR3QBo19An3l5LfJuaEQJUCpOtoz2MXGbXMVlGyWuHyjOeoiNpwNZTEPcV2FfvhBwDQMIONb1Bv+z1GSKmJCO0R8aqU+YRvR+/9wX1egRIP1sbyh4OaG1D+Hqc5VIZXZoLGuc5+9UoqQ3yGSImtiiHUTwoO8cHQojB/LPZ09RgYH+L/Y7ZO5A5c58az0QW9ryin3wgMTDyqzX6/BdQE99Jy2d42oAAXdroGbrhb4Qro4JM1HN7XBN9vQ7zL3W5ff/blBJztZn2p3U+9ORJt4Y5bbmk+4pd6rMIa54dKu
 7JE9nR0m
 dJUSo/PzAn38KtK40Ji0LYhaLFPGlMdJ4SWvUW8HXgfR2J71rk88IS+3D5m0mdzgBQIb5mxqvZVG6ROIqI0J7+mAEjgW1eK6abyfNx4qBdNQnjrBOz2L/tZL4Zv015YfYQrojD4NyiNJ0uNrAUtLwyqGqW2pd55JknENL9eBP2T0aMi8elE77p90C9XD9BWy1DAXCHuN1kgKt5Jwl+yJdjJbDVnkljFNrTJXleUbaMNka3l7YKFpCj+AN9vkR8IHU1ktr4+UdaGpw/fe27cuGx7GTlbMcTAeRaR7Cl8MZ285+gqwNNZ5ZgpG/kX6BQbeaETKgZQe5wq7JzJeorP60pRDKJpEdyMDSmmwRz/2V0Fay+cY/6vIHL8Z0Dq6BrfP8NDbr0lW3enxloia4t+RZ6bsQMrHPI9EHDowFLze8qoEXrWA8TKH/D300Sy5EUb0uX5hS5yfWRUrs7I2XuFxC72vNsW8yFackBqMtJT/dswic/NlzFrDBkoi225iv5oo6dAExaPSGmIRP/x4Y7ht+ALPzgkIhOK+v/9fuZ+m10W6i8TqDGmDKWr8aFa+ylQcoo57lDlXQEzphf95snCREciHQIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


An fix for edge case can occur if move_pages_ptes return -EAGAIN, later
when checked and it is EAGAIN, outer loop would retry again on same page
and succeeded but the err isn't reset so the outer loop would think need
to retry again so it goes back again and move pages again. On third attempt
move_pages_ptes will fail because it already moved and returns an error
that is not EAGAIN when outer loop checks again it sees non EAGAIN so it
dont retry and break out of loop. When loop is terminated it did not update
the "moved" variable from successful 2nd iteration.

That behaviour manifested into this at userspace

Source:      [ .. unmapped  .. ][ .. mapped    ..]
Destination: [ .. mapped    .. ][ .. unmapped  ..]
                          ^     ^
                          \     Kernel moved this far in actuality
                           What is reported to userspace on struct
                           uffdio_move's move field

When the previous behaviour is
Source:      [ .. unmapped  .. ][ .. mapped    ..]
Destination: [ .. mapped    .. ][ .. unmapped  ..]
                                ^
                                Reported to user space via uffdio_move's
                                move field

Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>
---
 mm/userfaultfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index c3adedaaf7d5..595e7e232f90 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2069,10 +2069,12 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 			ret = move_pages_ptes(mm, dst_pmd, src_pmd,
 					      dst_vma, src_vma, dst_addr,
 					      src_addr, src_end - src_addr, mode);
-			if (ret < 0)
+			if (ret < 0) {
 				err = ret;
-			else
+			} else {
+				err = 0;
 				step_size = ret;
+			}
 		}

 		cond_resched();

base-commit: 62cc90241548d5570ee68e01aaba6506964e9811
-- 
2.55.0


