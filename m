Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FF8CD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22236B0005; Fri,  5 Jun 2026 04:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3076B0088; Fri,  5 Jun 2026 04:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2146B008A; Fri,  5 Jun 2026 04:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7DDF6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:43:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66B00A0453
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:43:08 +0000 (UTC)
X-FDA: 84845219256.30.2B6C86F
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 98D4140003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:43:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gr4wIq9c;
	spf=pass (imf04.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780648986;
	b=uQYB2rTczlNWiUG+dPW0LTxnU/9SSMDDuywco0naKoV7HeoDufvxWeYkNB51X/63ElC4BY
	9cNBKtEoIWXXNpLjU4Yjj1lsWobRzwzjfTbNFxAfpG50xmXzbuhxdF/jK5z6MurXmQ98rK
	2finGySjQWiwL+xgHisQCi3YVGCqgz4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gr4wIq9c;
	spf=pass (imf04.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780648986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Uu2aS+uKGdtdYwfqjUd0y2UwAmJFu2eezsVO6MOi2Y4=;
	b=mMUibc4GQRIsCRTTC0KHkZQesZKA/q6MB1mEGxS78Im5GKrX/zRKs6xW3YhYrks9VKr2P2
	vmzqTTRfClBMbzHKH0ktXQPkI7xY7dVNcrWwsdMSGbFcL8curSEHlD7RjljbQMfJ9zW2OL
	SVmmYmoRPD7EineBT+syVKtAf6JwBeY=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-36b8e1760ccso1023423a91.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 01:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780648985; x=1781253785; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Uu2aS+uKGdtdYwfqjUd0y2UwAmJFu2eezsVO6MOi2Y4=;
        b=gr4wIq9cwe3S6lI7mRJRDRlInDuGXJvvWit9fhqVOmwjNe/HfInhmGpXOqqP2QsXJf
         HZx+E2+M5ytt5txLT9Yft2s7Vcihh+zRsz1pJEFwnaU7AwYD6WLUWBGd0eKTXX9Q82SJ
         mosSaJKgSnfGY7YJkdRFzxWEwuaHNX03IAkjcFccStDbn86XvMJ5VcX1PcO7ndNzCAzi
         +YEjTuQVHXD8W47gUTK2M11Pe+nSbRJS+VT6rvV53Ob6iMXSzXdrTa76FCxeP2+AU+uu
         owjeGi0RaQvYGg/m2iUvY1+/F+m+6M/etjlfdK25VG//xrAYPeb84dTVAGOSsvfebwzY
         h2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780648985; x=1781253785;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uu2aS+uKGdtdYwfqjUd0y2UwAmJFu2eezsVO6MOi2Y4=;
        b=DLdC2EeIccDg4TjjP6B1lLrmbdz0NOF6bBrd02bRd7/2vgexvcitvaiUjTQbr4suH3
         SAo4RKgyiOxG5c+WF79vmPmnLRTzTyUF532kssy8pUvDIHOi7Hv00HgT33GEd9mKzGxy
         km2lfeFcmwatZrYGJzRl1XU2n1L0V5zbxwtYzbvLM9JiDWfHTEedcbPWXktMIdUDSAE4
         o08cTMs9DXBV3Ccc05CekQFDHaCt6pW2hjwRvcrhRO/FfENsBBg3kMhWh3s59xHUu6ZL
         nRMCZTzpg3NYHwgLKm9YoG+ZB+Z3XmgPj4wYGVhoHC9+tt4axz4guNc/iWae6VrwlwwX
         nusA==
X-Forwarded-Encrypted: i=1; AFNElJ85ADTRK5mBQhX2qpHRqggg8g43Bj3QL69oY7qQac6z9lExYNMADE7wyo+GGHk1wY8x+Kids84FGw==@kvack.org
X-Gm-Message-State: AOJu0Yz4sQZ7HVBa6TBl1Ft0RlTNMZTNOcWW4qHz+2FXZOh0ju4IK82L
	fyqeqha7CDFVQXb4DdJQbOFRpU2716l8WInduzXgG78HiXOsTseqfV6U
X-Gm-Gg: Acq92OFE9WXjjlW7CLI5w/ipSWy+ssemyBFr25rC2J8pLfBpUErwghTM8kEqeohg/U3
	DCGPbgolcY7inqvySY85Wrodt2Lb2y/MbrHO8pe8YBqSOiDDY8ljwaN2in4iahRQ4VJBhsn+SuN
	onyg6TgF6sFJWS2gmcn9M54bhK1/FQ4Yk2EjnaWBLIJQKieyMup2L3kPwDLVFvEDUIEzessqfrO
	Z+hMdzqj5dC/qzU41S49FD4CEbsLcjY1026wmxsKu8DryYm9vGn9cZh6b384l7AVQLANdm5tUJQ
	zIQ8rUTqh2ARrFv1URC3qJF6aZoyv5V/NcV//JUYrAXD4lK0aOiHv1p8bOkUC4bjjGg7kwbGQ5z
	0+M78E1ThlcCLivRZIAf1QiLM9DJmetSljG/VNmZ/rTRW7R0M4VaFCpSRQBEn0sejKZytLoN72U
	19yYg1SGT+kYnDz4hpuqYwYfuzyMD+t6d8K60T1fpNqahV83t8ArXBJVHQ40P5
X-Received: by 2002:a17:90b:2810:b0:366:2e1f:393 with SMTP id 98e67ed59e1d1-370f038831dmr2621326a91.21.1780648985426;
        Fri, 05 Jun 2026 01:43:05 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3712fcb2607sm926632a91.0.2026.06.05.01.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 01:43:05 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [PATCH v3 0/4] mm/zsmalloc: reduce lock contention in zs_free()
Date: Fri,  5 Jun 2026 16:42:38 +0800
Message-Id: <20260605084242.1549811-1-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 98D4140003
X-Stat-Signature: o3km5aqsfdg5kkz3betmpy11n66rh4de
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780648986-942962
X-HE-Meta: U2FsdGVkX19jutoExV/3P0hKyK1Eltuy9smmnJ6fQf5QlGWCJ+PhB+DUTP/wSfWsfKWBn5wSIctmr8EYUrejR/srVexsy1KQbMeG5v296yClex3mG6bMmf7WSAhue25F+y20Gjj1UTqirAd0GUag0ZtMg2mC5g1SB7OsyCDf3nevP9J5smww0tG9oQ50zMTSUEDXVtQ5VVnY5Czr5LD1B24F23ACCX1gLBmFxQPv8CVQBDrMNt3Wltt2d9hF+6o6x/NRPej+KaSdYELh4+MsqpFHlcfsOTwle+DXNWVsEEjVQJAsfLzLqfZTV++BOG/8oHDDURmKBCQO7RRTn6iAkLipK5hvmdgmim7w1/hv4eTpZ4fCYQWx5QZ1Zc0rokj88AraWn+iC1QJpxDv4zHc9p93/X2Dt61KphE+MZ7nfAT/puVbrW+8PKHX698QV6oNTAoGMiktOii0S84uHT7tKh+WJAgw+fgm81P3bYDqon27OQak62/6s8/Pv3Wc6C3sl8bQfKrOcgu1LbDmTOg+LPY4+HkTE0ZX8hivatbJhvPRGOoOs4jPFof/84VbDqX1f/yMKMvNJ2F16W5ExEU0P5QeM8P5zt7KIs5wrv6os10A/e8Ulobz0hLT/RDCkEUR7zwyr7pVJ+ZD+xqRg1xjUfTCBS/vlCfU5PDvwikp2m+yMpHtAGSz0+/Fu+C9qyJ1atGdvib6GRa17XVnzOyuG/HbA04mpDR9+1yz5ObegB/tU4ycWqrZ5iDo62qlUNZWPRua3r8STa8ZxxDfh4Lp7884LuXr90CSUWjZqbCEImynfrRL91mLu3H6yRlCqcSDNEMFG1iuee2jZ/JbaGUbRn1u0FrWr2wQKkurKb8rJMAHcRT0XIn5e57cRvOVA71IbUkIQ4KzUiWePg0Jud5KzKLRYYsK7pZzExuY1s+0gsjwEVx/cmiCn4/jhZnNvnxMD6gHhMn8QHSIcMQ3wYp
 ta9J5jux
 FNsBNTUAdUzGx3FnyTk4+D5pKYStyn3FjwpI69mDbFSdeCN4JinMwWCvY8RkiqyFjJNRbnB70REzqhrNdNeAOO3xUp/PsO22wKoT7aNHEjaxZUpGX0DbX1uAzjEtcnBLhAOtP/BYmW0ovVBkIb1Qo6KVbNP1YZsFH9Ua0G/KIhX3BXwRcSONVLmsAGL3tFJqClLZcnpFpi8pQBZsPMis4xmYljzp/AXFoNc3qzRUQnBL4LbpBU/TMpBxwON4C+qp2PzmK8XlJ9W3lldENjkbkw4TG5kXALa9eG9MiXPU8mlqNxEjZBhaY6jFNijXPYmz5IhL43JMn2bAHc8w4dDPVQ9seFcAr36EQPMVZcojfr4vypILIczDmJ1AS5Sd76SHFKM0snNpv3+o4KdBXNDWrl+MDwpzhM2uJRPtHLjb1WoB1QmJoJmD+67w85cf8YgIzJ+SxmToqsX0vQZEa+M4BDdNex45nKs40czjOvVgLncrgslntv3yAJ46kZLP0mf7N52QVqR7+P5/42ID2gDEL4uhEAepuj+8RgeLgvN/l0j2NPcyQiGeGio3giIUHJI9fLgC3L9sWk8PiGG+E9iXuhdUxD1ZWYCLpQsLu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenchao Hao <haowenchao@xiaomi.com>

This series reduces lock contention in zs_free(), which dominates the
unmap path under memory pressure on Android (LMK kills) and on x86
servers running zswap-heavy workloads.

The current zs_free() takes pool->lock (rwlock, read side) just to
look up the size_class for a handle, then takes class->lock and holds
it across __free_zspage() which can call into the buddy allocator and
acquire zone->lock.  Two costs follow:

  * pool->lock reader-counter cacheline bouncing among concurrent
    zs_free() callers.
  * class->lock held across folio_put(), so any zone->lock wait
    fans out to every other zs_free() on the same class.

The series tackles both:

  Patch 1: encode size_class index into obj alongside PFN and obj_idx,
           so zs_free() can locate the class without pool->lock.
  Patch 2: drop pool->lock from zs_free() on 64-bit; 32-bit unchanged.
  Patch 3: move zspage page-freeing out of class->lock.
  Patch 4: document the three free_zspage helper variants that result
           from the split in patch 3.

Performance results:

Test: each process independently mmap 256MB, write data, madvise
MADV_PAGEOUT to swap out via zram (lzo-rle), then concurrent munmap.

Raspberry Pi 4B (4-core ARM64 Cortex-A72):

  mode        Base       Patched     Speedup
  single      59.0ms     56.0ms      1.05x
  multi 2p    94.6ms     66.7ms      1.42x
  multi 4p    202.9ms    110.6ms     1.83x

x86 (20-core Intel i7-12700, 16 concurrent processes):

  mode        Base       Patched     Speedup
  single      11.7ms     9.8ms       1.19x
  multi 2p    24.1ms     17.2ms      1.40x
  multi 4p    63.0ms     45.3ms      1.39x

[1] https://lore.kernel.org/linux-mm/20260508061910.3882831-1-haowenchao@xiaomi.com/
[2] https://lore.kernel.org/linux-mm/20260527115930.3138213-1-haowenchao@xiaomi.com/

Changes since v2:
- 3/4: drop likely() hint and tidy up else-branch braces, per review
  nits from Nhat Pham and Joshua Hahn.
- 4/4 (new): document free_zspage helper variants in a single comment
  block, per Nhat Pham.
- Pick up Reviewed-by tags from Nhat Pham (1/4, 2/4, 3/4) and
  Joshua Hahn (3/4).
- Fix patch 1/4 and 2/4 From: to match Signed-off-by, per Barry Song.

Changes since v1:
- Rename obj-encoding macros for clarity.
- Make 32-bit / 64-bit handling transparent at call sites
  (no #ifdef in callers).
- Extract a helper to keep zs_free() unified.


Wenchao Hao (3):
  mm/zsmalloc: encode class index in obj value for lockless class lookup
  mm/zsmalloc: drop pool->lock from zs_free on 64-bit systems
  mm/zsmalloc: document free_zspage helper variants

Xueyuan Chen (1):
  mm/zsmalloc: drop class lock before freeing zspage

 mm/zsmalloc.c | 191 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 159 insertions(+), 32 deletions(-)

-- 
2.34.1


