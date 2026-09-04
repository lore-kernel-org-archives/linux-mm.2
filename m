Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633C1C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 13:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0521A6B0088; Fri,  4 Sep 2026 09:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3E896B008A; Fri,  4 Sep 2026 09:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53396B008C; Fri,  4 Sep 2026 09:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC9AE6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:25:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD8B0808E6
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:25:10 +0000 (UTC)
X-FDA: 85176150780.17.B20100D
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 03C6018000F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:25:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GEJXJFRE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788528309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CP/vbJtIF948iniYIw2bTcvHalRSWj3A4FS22l6l3aQ=;
	b=uBe23XYhEz/I9yuyAW1BBkBje1WYJ3tfTWjutMFAYUOcNHkxcZszFpbWeKSdk8TvD5NXuG
	KiR5v+Bk8JY6PoW7ayIeGZb9yAu+WER5sMuqdCntikImMol5vyDarcrWNuTRwc6a6IAufj
	PvBqHkMye6Swtje3Tzu3Tdt3Fqik9pQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GEJXJFRE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788528309;
	b=ekcAG5MTOvNZvJkh5OZeCmQIxxsy27frrqZtr56JmioYZIS+Sa4ykc7kcFz+jRiXPLilhG
	fewvkDGMzIKzweqSDJPMNVl7iPM5YfSDW8dHsgYLkohqo63ZsnjHHJlyus1VwbgbZX4sUD
	EYhzzYq1V/6yJ5O5O+vkYx5gmxXeoVM=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8534d507f59so1127282b3a.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 06:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788528308; x=1789133108; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CP/vbJtIF948iniYIw2bTcvHalRSWj3A4FS22l6l3aQ=;
        b=GEJXJFREu8mg2VwJEWP0fsn4DIR3PMHodEUWekDlGJrdS64Hs9Aof7RqAk1Lc9WNii
         1iEYtACrwjTpt0iC1+PcXSUgVdF3JeS7RsuqYyQdqy6aRGtprwqbd78nDBtFaEoVVobm
         Y4PKoKzGs8/XW+YyHBYpZ4MjG+seY0b+sOgJpjl0Hh/Wwmseu3otSU0/Z6CG/SrEiFEe
         d56h3L8oCrobEHG47FZNnlbYf20GMv9f5oDkrFIvH/nLbXYn0m1OEocYbpxyfMWhNL7l
         BJ+YeBthVq8ZJswT7UuKvHxclboQxrSMaqaz7RowD9u0QFJgpGwPgodJQfaiNRwESqMc
         aMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788528308; x=1789133108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CP/vbJtIF948iniYIw2bTcvHalRSWj3A4FS22l6l3aQ=;
        b=KsTaO4FUw/INXu+lbaaVqyg0Dqjo64EpKAbok4fEEfFiYg+HX+WzAS2ayIs3cw35CY
         n1JOyHgTP7i/064LSQroG0zb6Rj9eLhO3tMkeuEoksnqJC3WfmxAhzlo+ceLeeiOcVi6
         DUhwnwCdv8eL8xQ8CYxvTe9KxaKgUakVhWxdUSQDS9//iTg8gLQl/0fkrA7tbz1T3k4J
         fbJHVnl2MI6284l2JxTuucX7pZO8dNMYKzf08LISaQ1Sb2bhzNqF7wQkP2FCXypbuksw
         gZgNzBgKVNK+Z0lO0J4IzW7/LejBp7+q2Kk8hyqW4qV9h2PW0rLTSh0SyzommdqDfvZ4
         K8iQ==
X-Forwarded-Encrypted: i=1; AKwUvBzTrPPtE0n3OFJu37DhaTGjXjbvuZiD4UW8w2wm37NN28tXen6T9oDyWNIAjaAlmdBwBQD+p5q3RQ==@kvack.org
X-Gm-Message-State: AFuF++mjES/q3kX5nirb30y80sZ6bqNa6GTfqd2zdvdjtMO8SGDiuwWb
	uGAlFV/T7IXnuqxwbY9v/vRcKep1kfxzkL5mDXUiOs6P5BJlHAsAT4hmWzvIh4wn
X-Gm-Gg: AYBFou0AlFGKmvpephjkoVIdI/vGzbDAeh8BaK1FbwhxhVCrYEJptCT0+1ejyJDn7Bl
	LoKwCHoWrFBiASaFVOaFt0VuXwJ9nfKrJX4z18SpTYl1e2HYdsE+AtY4FWJ8jFq6h/BQi7z8T2l
	SqmAdpRRv1sQykbzwx4YVju2unTso05lKKzwr56Wcx56BB60iSreGZaPMReGKG2/bB3+5jPdyBq
	243h5MJbh5T6S9wR8W0sps2/0Z2nVnBKjwxqDdASJVjUtC+Jx34U8LbprJxCuNZxKe8OZsJDRsP
	OHiYUFPctuQdjB7scfDvxxMjbTMEH3TyG2B3CZaZ+q7g/txHRFmHbfYD3jajTbcf1R8kwK9WCK5
	nXK/tYeGQ4UVhq4iTvuJoDkFEgROuBgTEWr84bozUhaMCsydeHmFv/IML5WyDOq0cfqa8O0ZzBa
	UCG+KYhY0+rqM8iRtChSA1BOYPkwoMd7PgxlxUC2ZDgStD1bI57/wyDif+EYH1+eP6ZgMRZ6b9r
	3s022pw9UGuElt0oy6N4uBDLOlqNnGrGB2zHQ==
X-Received: by 2002:a05:6a00:2d0a:b0:851:b03a:fcb with SMTP id d2e1a72fcca58-86169b6bda4mr7057801b3a.14.1788528307602;
        Fri, 04 Sep 2026 06:25:07 -0700 (PDT)
Received: from NV-J4GCB44.nvidia.com ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152c2a52asm1147302b3a.30.2026.09.04.06.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 06:25:06 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/3] mm/zswap: shrink zswap_entry via a pool id
Date: Fri,  4 Sep 2026 21:24:53 +0800
Message-ID: <cover.1788528216.git.wujianyue000@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260830114731.8322-1-wujianyue000@gmail.com>
References: <20260830114731.8322-1-wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: arcsdc53ruwf6eat45hzrbszn48m3dxk
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 03C6018000F
X-Rspam-User: 
X-HE-Tag: 1788528308-261777
X-HE-Meta: U2FsdGVkX18WLdZPCp51iY9H5m2PezWqKXkDGCgrmnHNWUWQXuN5rbgQkUntLBN/EF9/nx4rBI271G4SuRNM/oyi5Xa1pMeY+oD5gOLFDKccIkGRvQRZ5G2UewirU2GV23FVmTv/qzdmrcgH7ovF392h+cXdZG0Xz2eQpVG7N0bGNFJ/3Ds3eNQNewX76Hb56SPUjsCC0IgUH9sy9aOzSrKh0okLNt4QwJ0eBmXGYUH5sakCznAbwxU4kykzKZ0119bmE/eFEjFynoj/bynr2zx13eQxEh6XNmKXlrw09TzSvnUNuk+hCeXvkTQXO8wkhnnpNXcE4muT7zQku3BYaRSSIITZOckyk83MVZ+dy/3cB6BF3F9u95HhKfwrN9XJqy8TpDKzmtbAy0Y6QxPmXXAxUhB3oNwgrBaRN6qS/BOuAczKroSsOc/dDBW9djqqQa+rWabsns2p1fQWcOGvN2oD+8U+IOn94jvWHkMuZ1dkYp8mHd4DTA6FFRYz0R88gU9GEYm6tX4dHthCcPgE9xjNb2EFqlPaF8cK7Pxbj0N8t3jGq5598Le+Yw+EzEno1E9mErknQYWCRQB4+zTnPxi5saN4JLDCs89Tn0TMgcEioiBEe5neWiAvQETetC4IYubw7eNxv0KMraJbn5A2KydrXrvWfok/EhHMKtttbsDa90+CvWJDUxi1cGZdYdknETkBZUUXJqO7uqHlze+X2zkv93SBYyxwiA2fqZslBRqbbYyQKr5z38RNxg1fXxTpGjYZVxc12qtDSe8vuwI9s7VaKXsRvV1WL8ePzRQbZA14hu8unMmFue+VjVmaqBUtTNK3T872m/fH1LBrE8NiU92hgsMG69+bj+uIWAMtix8kSR/qzjw0vHWOApUhwN2ftuwLjPTlm7l2//UjGicve2RjwfyD8C1lo/MtUKpnNvvuXOIhvo6XO5sA7ROtuidfXnS13T8Srz2teEmVU8t
 tPB6wdP8
 sJowQRTAp1JxryqW3m+NZQhgsv/PGufNkA5sTOzUnszEaNxLmngKp1ZEPS2kweid4vnoMBHwsVXkHH4hUOcHENwn9zVzg9E6LphC3NqSDAMgGvUdthHn2K0HBvs6Vn2G7Cg3FKg/bO1A/L9JdRwSeM8JLDJCNPa76BkxxLzp5k196jVIAKy4Ka4QMCgb8luw1yK8KyKU2w7CCUIaRkAN0uOGksgkCDz8ytYrOmFeWAzxY79/p0GsXRMTZXy+b7ozf7KkgCGjn9OhqGETI34jZVoUHSR/IcEfxNgMnwgMrriycgWntWVn2S3cJxlEeZpXxKqHeUE8Wk1Ks1I2JeRySK0I3HpiKiB70tfqsbGC/WoYt1/ReJ1Pchiq6mBuwhuZFweNuw9C6raHYb1D1P5joR5qoz0XCt5YEJHCdfDXpCtoz8ELJVPx5TRRtfDqYDrMQEVKAun9yt7VCqPlCZ+HkCM0TUw0mQ/nzSxlJMmtsKgUOWUsMWrBCsOIhNUOgM+X1qwwFZaj/xksSkbGp4/CgH9ReSe/puhJ+oaR0P1KKGYz4hldPvMyfSUJPcF7EqgBSgtWxkF9glHED2kwPqfFPcdpaB0f4jVTpHuQnFxdVDW5LOWxZKQR7PJUtOw0uMobcUBJjFuTpzFNGHl2v/fZGSHs/gQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every stored page has a struct zswap_entry, so its size is pure per-page
overhead.  On 64-bit it is currently 56 bytes, of which 8 bytes are a
pointer to the owning zswap_pool.

Only a handful of pools are ever live: a new pool is created only when
the compressor is (re)set, and pools are reused across compressor
switches.  That makes a per-entry pool pointer more expensive than it
needs to be, and the RCU list that currently tracks pools is more
machinery than this needs once each pool already has a stable id.

This series:

  1. Releases retired pools with queue_rcu_work() instead of a worker
     calling synchronize_rcu(), so the release worker no longer blocks
     on an RCU grace period.
  2. Replaces the zswap_pools list with an allocating xarray
     (XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH) and a separate RCU-protected
     current-pool pointer, giving each pool a stable small id.  Ids
     start at 1.  The reserved id 0 is never allocated, so looking it
     up resolves to NULL.  The table grows as needed up to 255 live
     pools (u8 pool_idx), not a fixed slot array.
  3. Stores that u8 pool id in each zswap_entry instead of the pool
     pointer.  The u8 fits in padding after the bool referenced field,
     so the entry shrinks from 56 to 48 bytes on 64-bit (~2MiB of
     metadata saved per 1GiB of data held in zswap).

Runtime compressor switching is preserved.  Pool ids are bounded to
1..255 because struct zswap_entry stores the id in a u8.  The cap
counts every id still in the xarray, including a killed pool that still
has entries.  Ids are reused when a pool is erased.  Switching back to
a compressor that still has a pool in the xarray resurrects it rather
than allocating a new id.  If all usable ids are full, creating a pool
for another compressor fails and the compressor switch is rejected.

On 64-bit, struct zswap_entry is 56 -> 48 bytes, which fits 73 -> 85
objects in a 4K slab.

Benchmark (x86_64, compressor=lzo, MADV_PAGEOUT store + fault-in load):

  - e2e store+load median latency: no measurable regression vs baseline
    at matched stored_delta

Each store, free, and decompress looks up the pool with xa_load()
instead of following a pointer.  With only a handful of live pools the
xarray walk is short.

Testing
=======

- Boot with DEBUG_ATOMIC_SLEEP + lockdep/PROVE_RCU + KASAN:
  zswap store/load, shrinker writeback, and compressor switch
  (retire, then switch back to resurrect) pass

This series is based on akpm/mm-unstable as of 2026-09-04
(20cab322c95c).

To: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
To: Chengming Zhou <chengming.zhou@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Changes since RFC v4:
  - Replace the RCU pool list with an allocating xarray
    (XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH) and a separate RCU-protected
    current-pool pointer.
  - Resolve entry->pool_idx with xa_load() under rcu_read_lock().
  - Write pool_idx before the entry is stored in the swap tree, so a
    lookup cannot see a stale pool_idx left over from slab reuse.
  - Retire pools with queue_rcu_work() on system_percpu_wq.
  - Drop the RFC tag.

Link: https://lore.kernel.org/all/20260830114731.8322-1-wujianyue000@gmail.com/
Link: https://lore.kernel.org/all/20260815-shrink_zswap_entry_0815_v2-v3-3-0171bd86a667@gmail.com/
Link: https://lore.kernel.org/all/20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com/
Link: https://lore.kernel.org/all/20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com/

---
Jianyue Wu (3):
  mm/zswap: release retired pools via queue_rcu_work() instead of
    synchronize_rcu()
  mm/zswap: replace the zswap_pools list with an allocating xarray
  mm/zswap: reference the pool by id to shrink struct zswap_entry

 mm/zswap.c | 144 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 97 insertions(+), 47 deletions(-)


base-commit: 20cab322c95cea0327215bb81a05df69336032dd
-- 
2.43.0


