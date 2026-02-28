Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5870FEE4F2
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 16:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9D6D6B0088; Sat, 28 Feb 2026 11:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75366B0089; Sat, 28 Feb 2026 11:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973D16B008A; Sat, 28 Feb 2026 11:10:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84D656B0088
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 11:10:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 05A611C017
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 16:10:18 +0000 (UTC)
X-FDA: 84494352516.21.9CA77C8
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id 44746140002
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 16:10:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gjZIqbyC;
	spf=pass (imf23.hostedemail.com: domain of lenohou@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772295016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MmNLVdGchA1yBtCPglJZ3Pu9g12dPbvz5wu2t4UwJbM=;
	b=ywCqJBcXFLyq01MjFNHsQFFNipymQssk4A/Lgze/jZWzXxoaLFU5sgzVV+hNZ36aM8pFQk
	v7liYliRDE46gipzeXPTpxgSplQv7SvD6lQICL+d225TTUzoksmIJuwv0cUXCjle2GcNIw
	Q121+C2QAY5WkgBj/2zdAAhNgY92icE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gjZIqbyC;
	spf=pass (imf23.hostedemail.com: domain of lenohou@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772295016; a=rsa-sha256;
	cv=none;
	b=UkRW16cS6plKAhKk9nEnyYktQlpDvaGic2gSLOBrkKTmhbJTxbRkJcCIO8LWN5tSXXGTQb
	dodgR7t8sygR936mPrChzqB/u1LEwot/c2haQJJH3JPRHHFVt+Pjtv8j+7bTrEfGyuZVAS
	y+7uwVFt6bSXI7GM7N5Utb74JsEqHzQ=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-823c56765fdso1603872b3a.1
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 08:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772295014; x=1772899814; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MmNLVdGchA1yBtCPglJZ3Pu9g12dPbvz5wu2t4UwJbM=;
        b=gjZIqbyCpu7DPD8DkAjCJE+B6zMquTezmxuILpJjzg45MFtSg9a5CBmDApjScoChpk
         RazhvhOk6ICcF2E1vh0hv1Ol+3jqpuBgA03sPt1dFns7aNibMluSr6TlSzkFTSt4PGhp
         cdJEXXS1CRWyz3pVx7JN2lxWfkAH+Tqgr8CXJT9jjMaOZQ4m4rl5K1dgH97otsdKBxvf
         wxOOv0YB7uW0cD7EGOTNILLz4uGqDMmSXaAnTX4FM4RmqBHnhJYl+XC+vN3yIk/hbHwN
         yw7YCQU38wXRNjlmp/F3DvGm+1LHoaU+RaO3WW1EMtW5nMul5qrvA3DOfjRGyMnz7ZXN
         s10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772295014; x=1772899814;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MmNLVdGchA1yBtCPglJZ3Pu9g12dPbvz5wu2t4UwJbM=;
        b=jaGhTowJ/eaPAsbJ3Jw6cJp55UoScjZg9LNq00rlWcPLao6w7Cd2YrufcuofOXcuQR
         hkT2VG64e+J2ydxchZMjT6Z5XsQaa05Z/4TAw1pA3o5YN86+0hPLSlOgtbp9ii/luheG
         uAcBzCxk+os9Vq9YyH1UqIoA30834GBmC0rvJ9v3v9ZB5uA3fSNeoD7cZzRgnx+Mnicy
         /eQE1IO7LgjaQOKvOhepP2oq3vEKtkKpQsfD0SYx7UJjjy7q4Ldjd2DB6FVFgOMJjEyR
         W+LY1cr4j5F0CqRaRDl/Xe9/Mq2uD9a19loImgI953StbjXsnjZ0/Nr1bJ2+ap+bkTI7
         K85w==
X-Gm-Message-State: AOJu0YzvMbE8MnllNaaEwO8paqD1X/stmZ0dxj0db76YJqijwNFtxXFD
	F+3YT9PgS0M5QKp2tLQqAxBIysa3zQPK/1IYKhX2yxif8o81mCIkXsWxdDVgMdvuoYt7i8oT
X-Gm-Gg: ATEYQzzDuccEp1vwRzjQM/o3MSabtUNH34eIk846T7q4ukSjLhb6zbYdsqg7sndk2no
	Txf+2zwQiiAYpbuooC1FRrHV0S9C5BxBa6ono1NeVlQmxYwkIas+Tq+jDXMz+PPetVT8ovs2412
	sLSp/jQ4uoobgWhuiMPLnJReLtut50j2pSmMli1kRO4QMNIGqbWzZsVsQWMpo/aZtZJKTmHNdVN
	vqPjIKY8d7SKiauQi1U4lUfMzr0N1J7BUTsuUWKHd3CaEzw1TfH7DTC3Re0phByreAecbzmx2RS
	3ORAypJL6ARVwpX+XbzvqFX61LQJ/gYS57mwTfFOJBxERefszGWsUzy+krKENmwPjXasGslfA17
	vhooD8I/25ZUcVkmTPfyj7xo/aZe/LqPzLVVJtQypPkF0qNdHvZEmbeW29A/Mec3e0jz0K7XQFJ
	d7v8MinJhCxZplD0FmAde8r+QrB5t1JRSUlA+ZI+tdwojkQdwtMo5iG9h+yHg=
X-Received: by 2002:a05:6a00:2e86:b0:827:2792:e40e with SMTP id d2e1a72fcca58-8274d9505cemr6761749b3a.26.1772295014111;
        Sat, 28 Feb 2026 08:10:14 -0800 (PST)
Received: from localhost ([124.79.56.150])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-8273a05c0b0sm8192679b3a.61.2026.02.28.08.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Feb 2026 08:10:13 -0800 (PST)
From: Leno Hou <lenohou@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Leno Hou <lenohou@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Barry Song <21cnbao@gmail.com>,
	Jialing Wang <wjl.linux@gmail.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	Yu Zhao <yuzhao@google.com>
Subject: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
Date: Sun,  1 Mar 2026 00:10:08 +0800
Message-ID: <20260228161008.707-1-lenohou@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 44746140002
X-Stat-Signature: uo1qmborzthi5py5c3j6nqtdiggy1p8r
X-Rspam-User: 
X-HE-Tag: 1772295016-983957
X-HE-Meta: U2FsdGVkX19nCMnIqyscMm66qK2H9lPWEq5MfG6FeYqD0rAiVVMDRLPs6Iht9nP2uiGhdhrFG6931Xi8/8ke+u0vpi/k3Ei9zWx0rXbEpSuyep/LKplewbTE0n1ZEYjvP9mmCMS5rUsAYPtDxeCP6k2OCxp39HtJmQIx79LIp5deHrOx2cWBpq/4ovURQRMvK/07En4xEOGNVaAFu3FQCNmYQO8CYrm7NfdnU4CBV7/OjyOazR+YZQzZteSy0LIj1063issw4ICJDL8Gqxf+MxHhug/u2iNwNx48yT3oG/4gDabTOJhauWmVcTleRW3JIx7HVD1Hzis5wE//X8pWd+qv7aIvLHFlcenny2RYskAcHlb0ENbaeeX05QUV30ehtq3SfUaFoI8S9BmCbSaeTqAEtn+naH6eXFwux37xqKq/QZnWZREYhl81dSY9KuAI40I5JYMU730UvVAcpq3ch87dILSpJjU9Sh228s+nwQEMYuHYnThrn6Sbt5RPqbE4pWkq9oevlfRsVI7M9NlOzkCF72uVptm/cqdHAwpEBaT49JatxDj3u4sGgAizxz0nqXwIvPwzy7TaML362nms/gAhtW27bwFmQxR7nuz0jff2ANy5jzzMFzFxeXASjGSkqsKHcHWYTG+cIIEravjZQ9pB/o1wzMECm4bN4PIgSBIULCLf99/Y6Y9ub3f8zCN0OA8zDvR0K86VPypg4xzhXzkQLT7HA30oZ0E2nL5TrnswPRt0Fiu+O19YSEmzauw4+/MmSx0BQ7HsBxS9TD6Bm4xcldnIZsU/8aXPdEc8Y+VHQ4ocfr+05qI2VN3cHYnIo0EdX1GZMqN6QlzIhQtzWZyG9DDzu0w08UIvGEXHUuPcXy0yJl2cdYmuVLsuaco32YvLIq+qQZ5QBedLUTtLRMJWrkXZjbtMeXwgSC5sqpDgqq7nVhlymFA6uGy0a71P1t8G2I0pdH+l47MESds
 vx6Tso3G
 CQEBvar7dggb4Ew/px6ClfrX1UeYA8x6XGjiH8AApmIT75vCcqKnstSGPu/SCZJK8GN8FEByYOdDaBVkkMbhHxXwhAOhfoemV7Ukubzm/SwBbw80CxvvA2mI0FPddTjKmoChavMOq7sq8ToVowlEvbDQsMXZWwFdHE5LJNJN9GFe4tyYN0fDGQ3Yc73HqD04dE2+MN43Igf1uLB5Oc7fHApMack+13okiMu3coZZIvZ1PHdYbpIDjIMMEQlIdhsmc79AmUUcnS8OAeSg0MmBJ0LuFYDr0b8chpgIVLqLuRFvz76P3+upbgupdmyCjuZRLLTBXEg1IiHljMvDvJDdgMPeXpyRH8tkseE2sbeI81ilADg9OrzrBX+5dAPUjMCwhO9JFsLxBRf9qm37yXAMjAzhhvMIQgLUAShWMnUyDlu77oZlPcDfG2eWIvZPNzKRm0ppv7wwIjvMIg8uTi9ZO7+YQKuTpV7wwB6jZ+aAVyiGH8z3NQd0bLGoTgHoap3KlbAVkFHcsIiO9Fyk5E221va3Gd4Ksr/AnUx1SnJGVPOsf4AUlpnFj7eSOs1CLLD00LTXjEX5uh0quP2BFeHALMVz6K8QTPMJtivyU598cHCoqeTjBRuYSvw9b30vKrWRgNbbqDhzeztAPe02rQjFLWJzZcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
condition exists between the state switching and the memory reclaim
path. This can lead to unexpected cgroup OOM kills, even when plenty of
reclaimable memory is available.

*** Problem Description ***

The issue arises from a "reclaim vacuum" during the transition:

1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enabled to
   false before the pages are drained from MGLRU lists back to
   traditional LRU lists.
2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as false
   and skip the MGLRU path.
3. However, these pages might not have reached the traditional LRU lists
   yet, or the changes are not yet visible to all CPUs due to a lack of
   synchronization.
4. get_scan_count() subsequently finds traditional LRU lists empty,
   concludes there is no reclaimable memory, and triggers an OOM kill.

A similar race can occur during enablement, where the reclaimer sees
the new state but the MGLRU lists haven't been populated via
fill_evictable() yet.

*** Solution ***

Introduce a 'draining' state to bridge the gap during transitions:

- Use smp_store_release() and smp_load_acquire() to ensure the visibility
  of 'enabled' and 'draining' flags across CPUs.
- Modify shrink_lruvec() to allow a "joint reclaim" period. If an lruvec
  is in the 'draining' state, the reclaimer will attempt to scan MGLRU
  lists first, and then fall through to traditional LRU lists instead
  of returning early. This ensures that folios are visible to at least
  one reclaim path at any given time.

*** Reproduction ***

The issue was consistently reproduced on v6.1.157 and v6.18.3 using
a high-pressure memory cgroup (v1) environment.

Reproduction steps:
1. Create a 16GB memcg and populate it with 10GB file cache (5GB active)
   and 8GB active anonymous memory.
2. Toggle MGLRU state while performing new memory allocations to force
   direct reclaim.

Reproduction script:
---
#!/bin/bash
# Fixed reproduction for memcg OOM during MGLRU toggle
set -euo pipefail

MGLRU_FILE="/sys/kernel/mm/lru_gen/enabled"
CGROUP_PATH="/sys/fs/cgroup/memory/memcg_oom_test"

# Switch MGLRU dynamically in the background
switch_mglru() {
    local orig_val=$(cat "$MGLRU_FILE")
    if [[ "$orig_val" != "0x0000" ]]; then
        echo n > "$MGLRU_FILE" &
    else
        echo y > "$MGLRU_FILE" &
    fi
}

# Setup 16G memcg
mkdir -p "$CGROUP_PATH"
echo $((16 * 1024 * 1024 * 1024)) > "$CGROUP_PATH/memory.limit_in_bytes"
echo $$ > "$CGROUP_PATH/cgroup.procs"

# 1. Build memory pressure (File + Anon)
dd if=/dev/urandom of=/tmp/test_file bs=1M count=10240
dd if=/tmp/test_file of=/dev/null bs=1M # Warm up cache

stress-ng --vm 1 --vm-bytes 8G --vm-keep -t 600 &
sleep 5

# 2. Trigger switch and concurrent allocation
switch_mglru
stress-ng --vm 1 --vm-bytes 2G --vm-populate --timeout 5s || echo "OOM Triggered"

# Check OOM counter
grep oom_kill "$CGROUP_PATH/memory.oom_control"
---

Signed-off-by: Leno Hou <lenohou@gmail.com>

---
To: linux-mm@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Jialing Wang <wjl.linux@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
---
 include/linux/mmzone.h |  2 ++
 mm/vmscan.c            | 14 +++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7fb7331c5725..0648ce91dbc6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -509,6 +509,8 @@ struct lru_gen_folio {
 	atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
 	/* whether the multi-gen LRU is enabled */
 	bool enabled;
+	/* whether the multi-gen LRU is draining to LRU */
+	bool draining;
 	/* the memcg generation this lru_gen_folio belongs to */
 	u8 gen;
 	/* the list segment this lru_gen_folio belongs to */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 06071995dacc..629a00681163 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5222,7 +5222,8 @@ static void lru_gen_change_state(bool enabled)
 			VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 			VM_WARN_ON_ONCE(!state_is_valid(lruvec));
 
-			lruvec->lrugen.enabled = enabled;
+			smp_store_release(&lruvec->lrugen.enabled, enabled);
+			smp_store_release(&lruvec->lrugen.draining, true);
 
 			while (!(enabled ? fill_evictable(lruvec) : drain_evictable(lruvec))) {
 				spin_unlock_irq(&lruvec->lru_lock);
@@ -5230,6 +5231,8 @@ static void lru_gen_change_state(bool enabled)
 				spin_lock_irq(&lruvec->lru_lock);
 			}
 
+			smp_store_release(&lruvec->lrugen.draining, false);
+
 			spin_unlock_irq(&lruvec->lru_lock);
 		}
 
@@ -5813,10 +5816,15 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	bool proportional_reclaim;
 	struct blk_plug plug;
+	bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
+	bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
 
-	if (lru_gen_enabled() && !root_reclaim(sc)) {
+	if (lrugen_enabled || lru_draining && !root_reclaim(sc)) {
 		lru_gen_shrink_lruvec(lruvec, sc);
-		return;
+
+		if (!lru_draining)
+			return;
+
 	}
 
 	get_scan_count(lruvec, sc, nr);
-- 
2.52.0


