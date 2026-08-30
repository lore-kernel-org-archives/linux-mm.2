Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29BC9C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 11:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88E1F6B0088; Sun, 30 Aug 2026 07:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8173B6B008A; Sun, 30 Aug 2026 07:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705A16B008C; Sun, 30 Aug 2026 07:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 426A56B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:47:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B908DA02B3
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:47:44 +0000 (UTC)
X-FDA: 85157761248.19.323A39B
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1658BA0005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:47:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pRVRES48;
	spf=pass (imf15.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788090463;
	b=V1PBDoLnRixbympomGtHMSILm6SLhuJfc7Ayr3r5KI5zaCL6C9uT+fAkc2f7yOvl/9jsdG
	nPbHICxqqU01/ZA3nrt8LwirZiPlhh7c6UU0pFjJRtnn98l+93VgVJLiidi2pAordSICB1
	v49H0xEYRZygU/fDVru/TET7y+cb5Ko=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788090463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hEcSXHEg8tyfxyhWOxmAF9EFu/jiyVD3VTzwPGOzoO4=;
	b=ayO03iA/XBUNf+Zc8+sWPF+ztay96rVdyjDmmD4tsRGjk2IAmGjIw0hD+n6jfUM9/fyPBh
	PqEBjXlcXDcsMhu6V7TndT/R6PvscpC2TdRApQ5DmjSk5KM+dSuc1F3a6WyUNCmfgfEQf1
	S1UGZFBLLYiEatQUY8oVo5lM0oWlWKk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pRVRES48;
	spf=pass (imf15.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8557c3f270eso1721508b3a.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788090462; x=1788695262; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hEcSXHEg8tyfxyhWOxmAF9EFu/jiyVD3VTzwPGOzoO4=;
        b=pRVRES48lvmqr2pacNffR+x4hsTsDs1eIxV9ho02PI2OHI3DPmRZuo3D/+goSLqhI4
         56gDdMEXwkg7UlEDnP9P/316F2jgsg+7tcNQLDyx8mUVwkFOJdzz6W7NvlWtAIc5znKF
         tCHC3i9yIzsCEmQnjFuvHPabixEjfsQNkDrvNRB4zCuTT994oGRlDtuSnJlnDqBOlHy3
         3etl5Z6g4E+P4p2YNq98v9Wf2f9LoC1ZnTnDt/kr97so7iCX9T7YumJjiKzwYezNVkIK
         h/kEE2myyXPdGebsDMmq/rwV27qB9XVYHHk06Vh+Ef8qyHxBGZIfpDAu0AQsI2pKIT2d
         LKxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788090462; x=1788695262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hEcSXHEg8tyfxyhWOxmAF9EFu/jiyVD3VTzwPGOzoO4=;
        b=cR7W3E+TNbbsmkBQtyHRePsmZ6WkyzVO5LMDyUMoVkoe7bwDbJTz6X7sSRZUOkqvYT
         pnf/tDL5feFgbHESXR3pRjt4fvTCV4EL3rRkF6jrnZGKFHiMZgNBOEDQyqF5FLSs0mTi
         yvWYkCTgcQuUa5WrLV06Xmw5T8/mwMVV8T9f029DSMO/rRqO60rfb92iMFdNjWB4eUAB
         qF2AXUgYkbCv6rMPfA8HvgD/HXvudn3XzWTZGliLTRxmteMJcpzijeim2vYwLhCWAHTV
         pTAKNpCkLP1yqNl9kkAxqyIH3Vgg2HCVxdURFHxl5F7Xa0CMzbkJGquZuaj/U2+8/zC0
         QSJA==
X-Forwarded-Encrypted: i=1; AHgh+RqMo2xqSBR78W8fIiY30fEcWnMBgQQWlf/OcCuoNe4q1TR3mxv5EmArk0kd0dWtSU1cSXUBbKtblQ==@kvack.org
X-Gm-Message-State: AFuF++nwuJZz2lBbny4DMDHe/a3CQnkUGwz5a15f9I/mvyNQx9rJHsgX
	gtGGRmLnzenm4QjFND49DHFYIIfs6znqOvHqnw0p2lbaU51Hu91wObj0
X-Gm-Gg: AR+sD1399+pYGTvsG738ZfaMoGmHy1HoUZTPmKRzTm5FqYM8RWmw5I4h3oQ9j7ld1cE
	tYQMNiKteBhK89mHxlMGkXdcWihSBpi3pMj3k9Lq3bXoviGNyony77ond14sRy1NUIdep0wClzM
	2RyjXLZ2KScO6BvtznIRAr80H927Men35QPrRyja1HHpgAh7pcRIfG+d2vparoXWDTF2VBEUU4A
	+nxp/0AH2p5SAEXphjwh5GD6cayIF6GTo4Vy8Wa49nIwYA7YhYodaadB6gS5o22a7EwnanRnmPp
	jOOtI4k56HRe9ND50yWHgrL9bimRZxWxQ3lfDPowqeIX2uBIn7i5HRNAESTZ8oANU0vJP5nZhP8
	lppbPL/FI4o8k4fE5jTfJZW0GOPZNunsV+rLbktz7lgD2woPI4ZrIDCir/BWZz2KwuCiGWEIGsD
	eaOY0ecj5Bpzm2E/iz4aKeS1DsRBCxh51RxzHwtO55aBaS5tCQZ0F1hL4tM+5gOjgH2/nkbabJ6
	9lp5ANJOP5zLNORUEwBl4WEyBKsqBIZAaqLsrE=
X-Received: by 2002:a05:6a00:21cf:b0:857:73e2:910a with SMTP id d2e1a72fcca58-85773e29338mr16243231b3a.26.1788090461814;
        Sun, 30 Aug 2026 04:47:41 -0700 (PDT)
Received: from NV-J4GCB44.nvidia.com ([2409:8929:a7b:121:d0e3:2a32:8ea7:5ade])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a397c0a7sm2395264b3a.49.2026.08.30.04.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 04:47:41 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 0/3] mm/zswap: shrink zswap_entry via a fixed pool index
Date: Sun, 30 Aug 2026 19:47:28 +0800
Message-ID: <20260830114731.8322-1-wujianyue000@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1658BA0005
X-Stat-Signature: c88dawwfxs9sptmrturkdnju6fjze7of
X-HE-Tag: 1788090462-316850
X-HE-Meta: U2FsdGVkX19WQnPthTnkkzSYYjIg1/ZGr4uXxseGMBg8YKe5GBewlLwnpiEffFHGcztFXJ3WU8Z35U4TDHkhVoMfxFpa+qEowNv8QxrhcrYGMRtMfKwb2sBzyiTvVcGTMGfop/YpHPSTUegOMmzl2yOZspVid3paZgkL4NQOhoTDJ9CFF/TeF6MF4Glgk/XGVGvoE7wgpMaw0yWlGUWcfaOGYjx3GoynaTeM37XueUUiag69Mu2gmZJjG7PUcQ4OQtYxwWubJNhwm7HW3Jl68BHHLK8tCIfm7RMefUdmMBqaoq/Y2O6Q4a85Wx9NwFdMeDAqmbNI0q8srKwRUbPTpeaXsYKQgF/gh0beZPHCTXkq8W/QBUolq/zmM92mwYAc8rf1bB4iDidme6QCQEzpgmPpMDlps9q3DExLdiMTuKlh2tYSEW8T/Wp7ew9qq7Mq07slfyVyfjSdTeqCVywsoT9QFDJbmbQ6BcBkJyPKXDgBDxyIr4+cVyyM8UGdvLulFlneJNsG7smAGqlDeh59E2iF6T+jbbyFyqtCZR9d1jKJpJFeYMkMFUXRXQ2YzUSnHK36+4taXXpR5kU8Sf+vXdVSCdDItaLiBDINph7RrwlqRH5zVKr/PvvVlr/x142gs1iWEssOSuGkXsnQDf4RzSaRD0kl5jTyveaiUuMSSTdNN0t5uLYG5Pz+xISxC4abSg9i42eV6zsk9WYGV09HLBcujFla7otkkKwbbZKzRSBb/kp+xfHhldJO9daSp+xFH2Fak5v3Qwjz5habr0uH2ZwVEg4jpo3bRtWI6lbzh+Pkraxwwu0D6T3FqngD6Sdo80IRo0piWUhgWLDnoWdthKtQaQB5lWVCyDnVlyUAv87zxYmdT5QqhLoi1nqF7TFIwVBNJ2YIpjPPtQQApOOHrENAk3j13H7Rc4fux1jx5LNrWEtKjeeURwZ65nzSnUF8adVILF1GwYupuZTWDyA
 8di0RUIM
 FcmlHTa12jo/62q96kTtLpdT3qe+PHgeLQNp0wrC5p9EJ/rxRgWe64KQMCFyret1yghE+8hu45OXxSQshXuxETTUWPyPlPmlFsXcnCKBbd7QsIOm6RD2TB9uZEm9n3y8vzKiRZ1qa4TcnBLJ4QWdCXwOH0zKKRqASCyvHDCN33bKW0r9qai1hUYHZMBiY8uIIssD1a3OCE3gI0UTuiNnLmahSYTpYuh30co1KSMRKBZMcJXrfy0SNELX/8x+mf6Su6daKQayPEnpQgD4OCEj8L2dcT5csczc4Pc77x/UkqfjFSBI6NBSIqY+PAKQZZjz0+JTyW1udI9Cz+cploZBzwmy2n9/j8TWyu9Uu1ezEz7KizTCQXQZ3wHsqykN09fDhZuWJB7rfHwuuWcMQNKB1zw1wxmvunI6CdUWuwqZM+8mV39u9TrWtWeVW0eYtLeKPcX6/Nqu7CqGIXYNVElHbD8krH9lZHEkC6rLR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every stored page has a struct zswap_entry, so its size is pure per-page
overhead.  On x86_64 it is currently 56 bytes, of which 8 bytes are a
pointer to the owning zswap_pool.

Only a handful of pools are ever live: a new pool is created only when
the compressor is (re)set, and pools are reused across compressor
switches.  That makes a per-entry pool pointer more expensive than it
needs to be, and the RCU list that currently tracks pools is more
machinery than this needs once each pool already has a stable slot.

This series:

  1. Releases retired pools with queue_rcu_work() instead of
     synchronize_rcu() so the last put no longer blocks on an RCU grace
     period.
  2. Replaces the zswap_pools list with a fixed ZSWAP_MAX_POOLS (16)
     array and a separate RCU-protected current-pool pointer, giving
     each pool a stable slot index.  Slot 0 is left unused, and pool
     creation publishes the fully constructed pool directly into a free
     slot.
  3. Stores that u8 slot index in each zswap_entry instead of the pool
     pointer.  The u8 fits in padding after the bool referenced field,
     so the entry shrinks from 56 to 48 bytes on x86_64 (~2MiB of
     metadata saved per 1GiB of data held in zswap).

Runtime compressor switching is preserved, but the fixed array now
bounds the number of simultaneously live distinct compressor pools to 15
(slot 0 is reserved).  If all usable slots are full, creating a pool for
another compressor fails and the compressor switch is rejected.

Benchmark (x86_64, compressor=lzo, MADV_PAGEOUT store + fault-in load):

  - zswap_entry object_size: 56 -> 48 bytes
  - e2e store+load median latency: no measurable regression vs baseline
    at matched stored_delta

The extra cost per store/free/decompress is one array-index load
instead of a pointer dereference.  With a single (or few) live pool(s)
that does not show up against (de)compression.

Testing
=======

- sizeof_check: 56 -> 48 bytes on x86_64
- Boot with DEBUG_ATOMIC_SLEEP + lockdep/PROVE_RCU + KASAN:
  zswap store/load and compressor switch (retire + reuse) pass

This series is based on akpm/mm-unstable as of 2026-08-30
(42d64d4fef83).

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Changes since RFC v3:
  - Retire pools with queue_rcu_work() instead of call_rcu().
  - Queue the deferred RCU release work on system_percpu_wq.
  - Use rcu_dereference_check() with entry->pool_idx != 0 in
    zswap_entry_pool() instead of rcu_dereference_protected().
  - Simplify pool-slot publishing after confirming compressor parameter
    updates are serialized by the module parameter lock.

Link: https://lore.kernel.org/all/20260815-shrink_zswap_entry_0815_v2-v3-3-0171bd86a667@gmail.com/
Link: https://lore.kernel.org/all/20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com/
Link: https://lore.kernel.org/all/20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com/

Jianyue Wu (3):
  mm/zswap: release retired pools via queue_rcu_work() instead of
    synchronize_rcu()
  mm/zswap: replace the zswap_pools list with a fixed pools array
  mm/zswap: reference the pool by index to shrink struct zswap_entry

 mm/zswap.c | 140 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 101 insertions(+), 39 deletions(-)


base-commit: 42d64d4fef83a241c919c8693fdf0a21b2cb6061
-- 
2.43.0


