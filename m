Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AF9AD7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068196B00A0; Fri, 19 Dec 2025 14:45:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29F36B00A1; Fri, 19 Dec 2025 14:45:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C656B00A2; Fri, 19 Dec 2025 14:45:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF0226B00A0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:45:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92215C06DC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:02 +0000 (UTC)
X-FDA: 84237248844.15.4D7CCAB
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	by imf03.hostedemail.com (Postfix) with ESMTP id CA4582000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bBv7VNuJ;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQJyY+YwzPf31Qkf8bV4s78sdugXZ68Qh1NEIv2FxjE=;
	b=pKymTGluJHVXeokBPks6Hm24310MY4Agquk4BumiFk59KzJmKuIG2zYe5ZnupaZLnR8lqX
	ACHTaD8e5lfQemd8V3GPpRQypgIq7hWYzc12IO14hDKL975c14k0i8xcmaNoH1KEXpr9to
	b7d0VjbCOlYys0uFeihU/j+i/6vUtkE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bBv7VNuJ;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173500; a=rsa-sha256;
	cv=none;
	b=3Ytd/ZCR8eDco0M5seNbXbsf3SZB8ERe+kaKwjj6Gfmls9V1yBoZEK7nv4hXZ74U2WZY5Y
	ikvT5wkx2PhdKGaldpBhvry/Oc0BRQ9jBWnrPum3UvM7iNge2dqSKIVY0XiAN5iQCuSmJf
	GjIe+2y45CRXI0DCzy8ghKl5qhiyTd4=
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2a110548cdeso29466095ad.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173500; x=1766778300; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UQJyY+YwzPf31Qkf8bV4s78sdugXZ68Qh1NEIv2FxjE=;
        b=bBv7VNuJlx5pely7FvnsP71BthoYR/Ih4oX0BxbNZ+Vr16RIBqnN4u/1J02ntdHr5m
         e1iXiuaduFGFeMcK4EZ+WInOYgUwS7PpsjhA8dBvZzpjhPqVvnd7nRDw6utFazSBDkAr
         lT/Uk3/if0jQ9qJuq00yiuwltbOESfzPc7TxhgI3uyH2ZSG/pQFVGVfYJdB/EaHppAP8
         crDncWMDrShEJn8/Lkw9zKgdxR+91IQ8V/HXiDNqb5FrTbaLEHsGlvmcIsETlSYNOd0N
         MlyymX8P5auIFhvX6ZhTSRioqNLNqk7Mn+GwEuy2JcSpd+02HpxfWakAZ6j5Xolew4FA
         /jLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173500; x=1766778300;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UQJyY+YwzPf31Qkf8bV4s78sdugXZ68Qh1NEIv2FxjE=;
        b=bQIyvxXgxn+TZzVecs7hPnBgdYOdLk0n/DNVwG0kcJlMfCJvO1kzZrMjgTI2KVSj5s
         BXTzGdVRdy1y/WSn9aop7cmD/9OklaH5ZuH+23JTfndltH1RArAvvl+BnwfPrsWz+v9/
         vIXoAWdQPKEzhI2kEFf3kGXCfVU3m46alJ/sNsoVQcBrDo9mEyTI2F0LiS4Vm7u5lf+1
         MDF7olrrTHLM//ytPtnoNsLcUya63Kiw35xgtVBXbntylvueaqPpSju6e6WEOBDo45TJ
         Hr9h2pAKAgbTos/+7ENGblkEIDZJgJCJLVH31dtxACK22fVUZdHyQXCFHYzVtumrIoL/
         QrIw==
X-Gm-Message-State: AOJu0YzP/wsq/V2lEOtQaCLSzOv0Nd1/K7F2GDL2Myp98hlrPDmOG2x8
	MMN1R32crRsHgEK947O34Q1zqMaOtKcVakrv16/JLmlmPpv1m7GtiQZl
X-Gm-Gg: AY/fxX5kP6OVELN4mhPi6zKMpf/Y2iMrmEdhobI+H6wUGKUNjO1X/6kjacxASpNu7op
	pajnsoM+LK3ZqGRlZa8D+wzSn4NWEVgGn7NKJku7LLiQCMuT6150ovEftcbxnb64wWLneCuw7Wy
	xayrDE87bxXHO1ze+P2gtUpFDc5DdPwldw4Qlu0dDK5pqRBK0n0xN+MsMsakNP85Q+AMGYvUp67
	Zz8PjtHREaE/MZgOMAAc0dycu5GGtyIz+j5ef4t+fDKAYRovbdCiIxVlY4i3vrSvIr/6/htvLcU
	ghSOG2DyWUy+IIHcoMQ7AlKPHdg1c2UIilQRO9zVRA9U+2pZ8Tj+SxI+w/t/D3VJoVr0mgmlLIY
	VHyFhSoO6G4qTLaZ4SkL7EygPRbvoe/blSKZuqAkj3P1F8hoN5mVQHWWkvxoX5e+f97Md775BiU
	tfRCaH9WiUV2GyYRlJkFnqcW48yVN4WxmNumg37CFGouR1wjDV30/z
X-Google-Smtp-Source: AGHT+IH4rLRYlF7Km2RzwFxpEBaS9iEraO/JHNRLyy3vZ6hSoMKZ8Zwoy5C5IS/BflnOo3E1stDXrQ==
X-Received: by 2002:a17:903:41ca:b0:295:195:23b6 with SMTP id d9443c01a7336-2a2f2a498b6mr37288195ad.55.1766173499635;
        Fri, 19 Dec 2025 11:44:59 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:44:59 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:38 +0800
Subject: [PATCH v5 09/19] mm, swap: swap entry of a bad slot should not be
 considered as swapped out
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-9-8862a265a033@tencent.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=3162;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Pi+TZAZwSWqdPEL23QFn7UOFD8uz8uW5toM/dBbdtuY=;
 b=7X9ok+JvnqWP43fxlMkDbdw05cri4rXNBYcpPfdaDU3Jd01+oq+VhQ1HNeq7aAxdnhRTb+c9w
 hEygOuc5yh9Dp3Ng8N4obllx+7crEibum2iJMVnJOstaDg8l3FV456u
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CA4582000A
X-Stat-Signature: qaoznduyy1hq3pa7teuhtsk4ietn5qna
X-HE-Tag: 1766173500-958560
X-HE-Meta: U2FsdGVkX19EosjrsjUaOdKaNMmH9hxCtoThPTHXa8xm+N7S61K34aAYk/Un9v/WcytZXLP2AdgdPxlxRAzbbcq3JX2muj0hCooGtNQGfy49MXmi8vpKHCjWuBrrbeMYs706vRbE1Ym3UmB+ENpDhJzM9Z62yv0+rsjjMAI+r8GdXO1ItL9EoLAHiEv842V1M07IqDLtK6U7GhIkQONXRlE1wQ5hdIw0Ddj1gVB95q+W1qufMpjLrG0addYyk1LbGkQLERSArb8qOxzssbY/2FmPx3lnLYFsQsAU1i4vDAoJ3/ZXH9Lj7c6klV94u/mApIvQkafqq0+Jl/obQhVrk/81XFEbja6TwTYkY3y4XCwl76xFedIJQzBPN/yZHBGaQ1fznNeg3AgjzEm9VwM5KAExtM3wrw1kWOOugIVBUYv0YIMOAlP62i69pGKj5mZzrzJ2iaV2yEWITfPANrI3tpjavyFn6/R7k0IVpxx/tUln/VIiwOdkFAK4vyjO8K7jNmqCrg7PDOxMp9O/wqD1SHne9k71xnE0C/OKUMDSo98GUYL+E/jMtprySA4IkruTkfA9+ia6Bx8qTMLJoS28Di9O40KLNJF3hY5x8KVKXdnuan5mALY4wo5eMh7uAYabI+W1ADO0hbiDaVMVcTz6YKDRL5ZJkgFmQYBdmlTlJ8HtSSCUxP/ky0mIsYBdjgQt+T4mpMWkvdhx2GO9YNLuq6Bo1KuDeU8gSMluMWh/QMkBqcG/52TFlowrtJkBexCJDwZRcKXcD8M5bwyfYj1+NoPhHKIlUMnxiGfC7F47O3unDhxyjyvDQccl/A59Aa6VKZTAEutlDgCBXN3w0H0Xwwdnjd6kbN7EvXrjLyglT6x3gHoYo1NijgwZTrqecrLJ+F+HbES1ZoTtJX4ekgx8utghlFYPz0qVhyHHIp3mfV12fTd5L97i6gTWj2lePE5O26Nyt6TSkkFk5CHKJgK
 OPVmZyP/
 5JwLyhbrqRFZZ/jmqhBJRUOtpE5l3dzw9nEXhtU14hXkDBWl1BFfGw1JteOdEzyhBUwfkRNrLWU47LTZojCnSBUm7eO/PVfncyjPdYYKmvD8SwOVSW2LZu0nIYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

When checking if a swap entry is swapped out, we simply check if the
bitwise result of the count value is larger than 0. But SWAP_MAP_BAD
will also be considered as a swao count value larger than 0.

SWAP_MAP_BAD being considered as a count value larger than 0 is useful
for the swap allocator: they will be seen as a used slot, so the
allocator will skip them. But for the swapped out check, this
isn't correct.

There is currently no observable issue. The swapped out check is only
useful for readahead and folio swapped-out status check. For readahead,
the swap cache layer will abort upon checking and updating the swap map.
For the folio swapped out status check, the swap allocator will never
allocate an entry of bad slots to folio, so that part is fine too. The
worst that could happen now is redundant allocation/freeing of folios
and waste CPU time.

This also makes it easier to get rid of swap map checking and update
during folio insertion in the swap cache layer.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c |  2 +-
 mm/swapfile.c   | 17 +++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 8c429dc33ca9..b7a36c18082f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -527,7 +527,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 	if (folio)
 		return folio;
 
-	/* Skip allocation for unused swap slot for readahead path. */
+	/* Skip allocation for unused and bad swap slot for readahead. */
 	if (!swap_entry_swapped(si, entry))
 		return NULL;
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index e23287c06f1c..6d2ee1af0477 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1766,10 +1766,10 @@ int __swap_count(swp_entry_t entry)
 	return swap_count(si->swap_map[offset]);
 }
 
-/*
- * How many references to @entry are currently swapped out?
- * This does not give an exact answer when swap count is continued,
- * but does include the high COUNT_CONTINUED flag to allow for that.
+/**
+ * swap_entry_swapped - Check if the swap entry is swapped.
+ * @si: the swap device.
+ * @entry: the swap entry.
  */
 bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
 {
@@ -1780,7 +1780,8 @@ bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
 	ci = swap_cluster_lock(si, offset);
 	count = swap_count(si->swap_map[offset]);
 	swap_cluster_unlock(ci);
-	return !!count;
+
+	return count && count != SWAP_MAP_BAD;
 }
 
 /*
@@ -3677,10 +3678,10 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 		count = si->swap_map[offset + i];
 
 		/*
-		 * swapin_readahead() doesn't check if a swap entry is valid, so the
-		 * swap entry could be SWAP_MAP_BAD. Check here with lock held.
+		 * For swapin out, allocator never allocates bad slots. for
+		 * swapin, readahead is guarded by swap_entry_swapped.
 		 */
-		if (unlikely(swap_count(count) == SWAP_MAP_BAD)) {
+		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD)) {
 			err = -ENOENT;
 			goto unlock_out;
 		}

-- 
2.52.0


