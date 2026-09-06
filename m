Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 209C2C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 07:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782FC6B0088; Sun,  6 Sep 2026 03:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7332E6B008A; Sun,  6 Sep 2026 03:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624946B008C; Sun,  6 Sep 2026 03:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BAFA6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 03:47:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B775DC0472
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 07:47:28 +0000 (UTC)
X-FDA: 85182557376.01.40390F2
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id BBF89140004
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 07:47:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VnqvUZ6v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788680846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DTW8rfxRTuzQ7sC9TwGZDi4dZwe0Eh2shs5D/k7Yn2w=;
	b=AwSI3i0kKtk+OnuSJiku09Q7MeXHWcDX89KBrJYPRsY6NrgqZiybQATiRgc40UXqNU7CGU
	9gjLYteiipzpmAbInzCcU60Iyo9ujsICdnaP+KJyMXc4D6iaO0hK31yBOht3GXTAgEx7m+
	6wwNtzf2udiD072xM1dzaZWdfQ0ygOw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VnqvUZ6v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788680846;
	b=dQJk0in3LH6XcSUoHAgW2BScVAFDnP5rwbpUYOguGGBUnCfSRS1sCiSA3/tBi6NXAhQW6Z
	hr/SZplTAfQPvHT+ZYDj7nx/3d1nezoceOA+abkt3MZLfQN/wmg98wU5Fdf0akBw+af/rS
	gmuRxiqQL8CfORV9u6XypINyu7HOCVQ=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d01663d816so16912215ad.1
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 00:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788680845; x=1789285645; darn=kvack.org;
        h=cc:to:references:in-reply-to:content-transfer-encoding:content-type
         :mime-version:message-id:date:subject:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DTW8rfxRTuzQ7sC9TwGZDi4dZwe0Eh2shs5D/k7Yn2w=;
        b=VnqvUZ6vSGQLdP+gkgqOafE+yAmehs4UVpa8ygAzYLdk1A+d/xpmMUIXl4Aa+B9fL8
         l9YpTKDb9wxO6Ja5eQFbNAk4ZbcLsGyUIaZOKsOXdXvSGrQH4SgH21bRSJZxCS5td6t+
         i9jAb0U+FYbQzAzyAt9VVTrhn32GYr/ogS7mLx6DqKkl92bpk4ZKo9CAr4Ywn9VyPi90
         DP2sYFg7y39B/McYZH5ALMfbXTcLFREa6+1iUX4W5ciVNU1cZ9GzFXu2GUNF+UwjuKfj
         MCPsu58CBkOjucYm4LkHxjpUM4+v+jkMsDUU3R+CwTzb/GnlaHbSk83DRJzTlZC5DCPc
         I2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788680845; x=1789285645;
        h=cc:to:references:in-reply-to:content-transfer-encoding:content-type
         :mime-version:message-id:date:subject:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DTW8rfxRTuzQ7sC9TwGZDi4dZwe0Eh2shs5D/k7Yn2w=;
        b=kanP7a97YJrepQGW49Y/R6C1b3Xf+LoAz5kG2rg81QmbgJytU50dlDhoDe2s9Zazw5
         mggjIh07GTp7GEJsqJpZFzXpZO4oMaoVxCAYBvEA20tjm8rpKVflgR6rXL1WYZvEwQMs
         IyZB9IYY9W2KWsiXh6eBhwxK3Mdi+DmB0hWpjxXUW0Tp68I4dKTwb351xDOn2SMCjESf
         UVE6X8WhwYml8yW/eoaau5QKRLzw71dBwNt5T+skBsDc4KN1dkTjNwy9oeajDWnTACKZ
         qnl33zqsIukIOE8x7S2bK/eckWV6U99+KItyFgDuJ/rdKhn9nE5CrJIgIn6nMgfggaFc
         ivSg==
X-Forwarded-Encrypted: i=1; AKwUvBwyn5qeUr/wwsJOD2jrTZytzXLStqtLg6L/uT/pqXabY9ahCx/DeN4zjarxkZnsyiBLsr/34G02Rw==@kvack.org
X-Gm-Message-State: AFuF++n0fVk++15zHrPK2WHvKOXqA6uUBS5nEgrvoG+Vw4I6Vm/LBbji
	H+PN6gbzG4YRzI0rQV/pMy4CXOvEjoQeeNnkO16izHXHeKXE8/6f3ucs
X-Gm-Gg: AYBFou3KeqQF/5KoQtWN06XcUYfD/byjEK0+uCfGpd7krRrn2PLC1Eq8YCqRs/hLDTc
	JvuK/ebrUzZwLepQY0gP87+0FmgFhI3Xi+WCQ7pgQAUR99RjAcmtbPdbinBXz8DgHT6ce1/WukV
	XSNKFT7PqOO+Lf4RUDLqQM4BlObxdJbwhaJO7q1//VAP0yStUCyPA6pnJHJ9/FuqxwGFWB05Fwa
	PdtCsPxM+Kk4y5PgvQ1AgQCr2dNUTpR23nTmtyUlpkrQ3gLadh/oiR9kieAEbCb3Wl5QZDpxOXI
	VNHBAByVv78T3k+J0IHTJW1jP85eRCHB2a9/ZB41/qL5/ER7TRrfcOoZkstX19YoL6tROsfzwAN
	RL6245Jxqm9D9+7tkj/VsMmlHEsKqaIfrnpcmcTPQc9iIPMgtwtEsMqtNgl8S3bzLel6B6+ZxWR
	ZXZZpk/9J7mujB3BpN6jXZCrbb5RnL0Npw+lF/qYSgqGVLgeVeQo479hreR9Ys3/3ut4me/aGU4
	bwXyO+21GrzABimROM+fip9WW9vz/TQLSdYiXYva47tVHUGZA==
X-Received: by 2002:a17:90b:54c3:b0:398:d6e8:f84e with SMTP id 98e67ed59e1d1-39b2612ecebmr26738023a91.9.1788680845337;
        Sun, 06 Sep 2026 00:47:25 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08d0d7e8sm21138905a91.16.2026.09.06.00.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 00:47:24 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH v6 0/3] mm/zswap: shrink zswap_entry via a pool id
Date: Sun, 06 Sep 2026 15:47:16 +0800
Message-Id: <20260906-shrink_zswap_entry_v6-v6-0-ac4cf61565fb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIQanWoC/x3NQQ6CMBQE0KuQrqX5VKngynsYQpryga/SkhaKS
 Li7leWbZGY25tERenZLNuYwkCdrIuQpYbpXpsOUmmgmQEgoQaa+d2Re9dcvaqzRTG6tg0yxOTf
 ZRZcAWctid3TY0ufYfVTRPfnJuvW4Cfk/ZdoGdDy7FkUuCpFJ3tHEl/lJyqwzAsC9GxS9ubYDq
 /Z9/wEVj+WXqwAAAA==
In-Reply-To: <cover.1788528216.git.wujianyue000@gmail.com>
References: <cover.1788528216.git.wujianyue000@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1788680840; l=4938;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=KbN3asJSK+TTbGnv/VcqthRURzav8YC1jBQtgcwSjJM=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QH0cx7afb7EwRu47MyXKggWSjW8ssjR2L1qEb8101sNb/2zGGDS2pVRPumkcDgn331N2SAc3boT
 +RAUTfHD8yAM=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Stat-Signature: yrdgaprfi5zyq796be5gdsfj1i9f3cae
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BBF89140004
X-Rspam-User: 
X-HE-Tag: 1788680846-824305
X-HE-Meta: U2FsdGVkX194Iav+ztiT4x6IdiTi1Ulk8Gd5BonV8o5D5S0mk+jN1LrbRIO/E8ufopYwifj8RKsozPy9xoutgk5Eyer8aBkuo+XQlp+W7wbWuSuwXJPVDEK+lCeCrgOZr8By0E8C0QnLNtIOk2FYMqRSFKv23ipCxdIHxXcv0EiUnIqIA64X3xdLcI4jmx77UuV7TIFuLJTAc4sOZCv7y2Nck0lXFYBAtFlgDXj1PpHIA64OSsdBrpvMkbM322vW6BswT29EPyhAOuqPZNik8kI83kKbeVYiUuavtbMa0Jqm209lneEMQLV8rKyk4vPRvBbz/WILRUK+GBjnuY3OcLiZKXJqhLlyXcqZ8VyodNzUo4K2N1QxcmOxNAwhy7pSOg9qp9KV6bfKCSoYsMkDOlzRgyCjdeTbra4UrZToe1cLTcq0TfzKPJo1c0+M8WUQpp0roIPtzSoPfO+gnxF35ebeM/1NVO84CJzLJAksdCIqsNRZ4uYg1K2EL1ml9coYEDRWGQ7fut1BTIvaozx2tmlID3K9CdDbYYwec8QESSn/2cxu+/kt4PfandkYochoE0pFUUcPEyLbzN7ZU6jOo06MvB3WJ6/ypGArT4j+gNHRA+Ovlwig8GyPbfJGHz/tp0LwxJpEYiKpmJCIet8fTxAms9FrGMwYGtc6s+/8gfLyAR0pNf6loRkbdHxTtG2O1n/0yx3Vu1DhRAQcsB/rszriNZh0N9ABuZwStenRgy4jBvnmuKf1Uv9HnX/mnpAMyvYfjJE2dA2ins/Jw2CqergEbV0gYrbpLnx5TiBp0ad1YHyngdQDAGVTSPgHIpRYL1gTl5zjEncQH47aj+GH5SXHzY25onYRthhW5RrbRg+y5+PAyeskwRTfo+RIJ5KB7w7irrKHCco2FLSmpn9Z6RjYtHmu4fu8ejfFtD/Zq1ougw8GEqEuPY5guMbNFdGEk4Yg2NdHZi82cGQcOmH
 ndNhuHvI
 a1p578p/AbfUi1/dsFbyFODAc5oTrlFw8oCbJNcdmz42FidMPAboWYB7nmzkiHfNTQpWJrroycNJfFGziwPeWTw8ilpvGoeF4pW9OPrHu6KfJArmgySed49xU2/21sJHHfBV4cLbpnEz4H31mZP3FoIKHA0GhEr38Ylpr2R03hhk/0Ou/zn+eh3GJcQUkRUTwwYjSVNdbtMnjcwnddm7v3fY8bU5LsZ7jd5paE+zAefkB0+M6qL6KB+MqmP/xvL781iUXQexZgOZS30dZAGxjci7+fojt/IEcmaopFSbjE+xzWpn5ikb/QHVYLJ0evG0Y4Sere7haGpM5t+G7f78MgWQVkVubtkinPEZopas/ELJWQGqFdvVAxXky/nEELv4LX31t0/jUKbCZSk86bP7JVS0FAWNC7CI+LZJgPFID3rHlIVD7bgriXyAQEmNklUUE3VASPKw9bSALWIcuJUULc+T+skZSz63ZlGbJVku2FB4RGQbc0cSasURML8ef1hdFUiZrhIOnE5XlVcrGqysUeDCE0N2UaUsP/8Xth4AZ08dpBWBmzaoHVzmwP+OgrEbmOfbkiz1EtZiYzRmmndLcFCBSnQTEVDyyw2mkyMgOF3vhT/CuQlAau632W3AJ5zGunBCa6uKN1A2t0PQUu3z6pkKpLaPwqaFZSwp6
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
switches.  A list cannot look a pool up by id.  An allocating xarray
can, which lets each zswap_entry store a u8 instead of a pointer.

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
     pointer.  The u8 fits in padding after the bool referenced field.

On 64-bit that shrinks the entry from 56 to 48 bytes, which fits 73 to
85 objects in a 4K slab (~2MiB of metadata saved per 1GiB of data held
in zswap).

The 255-id cap counts every pool still in the xarray.  Switching
compressor kills the old pool, but that pool stays in the table until
its last entry drops the pool's ref, so a draining pool still occupies
an id.  The id is reused only after xa_erase.  Switching back to a
compressor whose pool is still in the table resurrects it instead of
allocating a new id.  If every id is occupied, creating a pool for
another compressor fails and the switch is rejected.

Pool table locking: xa_for_each() walks and the current-pool pointer
use an explicit rcu_read_lock(), because xa_for_each()'s own RCU does
not span the loop body.  xa_load() takes RCU around the lookup itself,
so zswap_entry_pool() needs no extra rcu_read_lock().  The returned
pool stays valid because a live entry pins it via percpu_ref, so the
id cannot be reused under it.  xa_lock is taken only in xa_alloc_bh()
and xa_erase_bh().

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

This series is based on akpm/mm-unstable as of 2026-09-05
(d118502628f8).

To: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
To: Chengming Zhou <chengming.zhou@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Changes since v5:
  - Use xa_erase_bh() and move queue_rcu_work() out of xa_lock() in
    __zswap_pool_empty().
  - Drop the redundant rcu_read_lock() around zswap_entry_pool(). xa_load()
    already takes RCU and a live entry pins its pool via percpu_ref.
  - Replace xa_lock() protected pool walks with RCU. xa_lock() is now only for
    xa_alloc_bh() and xa_erase_bh().
  - Drop zswap_pool_current(), it only read the current pool under xa_lock(),
    which this path no longer takes.
  - Add a comment in zswap_total_pages() on why the outer rcu_read_lock()
    remains (xa_for_each()'s RCU does not span the loop body).
  - Rebase onto akpm/mm-unstable d118502628f8.

Link: https://lore.kernel.org/all/cover.1788528216.git.wujianyue000@gmail.com/
Link: https://lore.kernel.org/all/20260830114731.8322-1-wujianyue000@gmail.com/
Link: https://lore.kernel.org/all/20260815-shrink_zswap_entry_0815_v2-v3-3-0171bd86a667@gmail.com/
Link: https://lore.kernel.org/all/20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com/
Link: https://lore.kernel.org/all/20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com/
---
Jianyue Wu (3):
      mm/zswap: release retired pools via queue_rcu_work() instead of synchronize_rcu()
      mm/zswap: replace the zswap_pools list with an allocating xarray
      mm/zswap: reference the pool by id to shrink struct zswap_entry

 mm/zswap.c | 171 ++++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 101 insertions(+), 70 deletions(-)
---
base-commit: d118502628f8b673be9023db8bdf878f64a7ed45
change-id: 20260906-shrink_zswap_entry_v6-ed3d14c9001f

Best regards,
-- 
Jianyue Wu <wujianyue000@gmail.com>


