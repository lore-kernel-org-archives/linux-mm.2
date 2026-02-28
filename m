Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6EB5FEE4F0
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 21:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEE3C6B0005; Sat, 28 Feb 2026 16:28:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9BD06B0089; Sat, 28 Feb 2026 16:28:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9AEA6B008A; Sat, 28 Feb 2026 16:28:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B87AC6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 16:28:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F2EE1388F8
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 21:28:49 +0000 (UTC)
X-FDA: 84495155178.08.9C8C947
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6B8C140003
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 21:28:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hYWmmY2G;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772314127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZxZ2bJyypDd9ZV8NErVwlj1440hZcAv4s/39SJRyHk=;
	b=5gH0V8oo+At3942cJDCsvwENauH/e7RcyOLGXbQMMoBx99ymXJx1YhzWrCYysur8NDqRP8
	nx/r5edf46aZztuPIqQages6QV3/XLA74TFCfiV2ULECXUXt8ZsAZYj9ZneVd1G+d+0U9t
	7npePBi4F3gCb1M7vHYIj6dyOHrJEtE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hYWmmY2G;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772314127; a=rsa-sha256;
	cv=none;
	b=1Jrvwy0F+B/sJ1+xWNMUgzmnlEEO0uiUXAfsyTJoWGWbhe6vsMSE1jqgEWoXOlm/SpOyIC
	VT3wHbFSejedJQE/h7QXMCCjGXJndmR7mJyRd5OIdspi6sL6TaihOlaGN/4yoG/6V62LAj
	5HkI1igArinERZZfYzQ5MrydwipVkIE=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-358ed90bcefso1823533a91.2
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 13:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772314126; x=1772918926; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yZxZ2bJyypDd9ZV8NErVwlj1440hZcAv4s/39SJRyHk=;
        b=hYWmmY2GJif86fi9FP1K+AmNxqkV/P6vuUXpTQusMVD/71CIbz74+wwdUAUreDVCVW
         qtfY0X1lzqtH5rcSaXcXgaOu/wm3cPyuzCD/2oNe+Yj8CXbuGm1I1l6otbTzGwUcsEbR
         G82ooSgPkftwalJ+qtSEVdC+LH+U+GuMojb1H3apRwOL3GPEAu9W9Ez+G6p4hCOi1rF4
         ov++7XG6LwToDCdAog7qd0U9Hp0rNxoaI0dm1h9f0/aVKQ4CV3/UVDiRJOKTvuO8DvLT
         7TNMoRjZi2j4HkLQ3PkAUhv9FCl3IUoy8cIJamWqiI3t2Ca1E/9VoKq9k5T/dFVOQHYC
         q6CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772314126; x=1772918926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yZxZ2bJyypDd9ZV8NErVwlj1440hZcAv4s/39SJRyHk=;
        b=T6GXo8pFsbuv/oobzHQU/HvS4WE7byxhV+HfJ2HyMd2kU+RJ5W4KsXSY7g43v75b/n
         gg8j0srgbn6rfpjmHNTkgBd06cgucKma6YYnQFOnYXAPdz39BVRFZO1mE3jNkPaW6/hu
         uFuy/+U9zUJK6SXC7XL66bauLuuMfAWeXjOUZMF/Pdl7qqA04ERhWwpTDM3shCqiH+4o
         01eRnlWh+LDgfhZJrbL85+VZIPRaIG8K/OWFX304ncueywwh5BQQN4+vBRUoBxbHNpWo
         GtmLvtNjO2v7f0sQhsE6pyQtYKbmkowHSFlN0b2Uh2ixVVITUnKfcKLuRbO8rCkGNYTF
         cb6w==
X-Forwarded-Encrypted: i=1; AJvYcCWIr+xLGE4Df1fC45D2SEaZ7BrMIqwC93pdU/VZ3Yo5mhp9BqDrip/3ryThJNaq6WcoyOiVpS7JHA==@kvack.org
X-Gm-Message-State: AOJu0YwkliYBTMMYkFjfBSpGlQRMVg7YroV4yRsgiy69XKzD2ve9ub+y
	1H/+acSBpSNCmacvzNfcvqIpkYKSt4vs5JGD6Sv9ltLauPYWV3NxUQp9
X-Gm-Gg: ATEYQzyhD1HRb7/rpz1BSvxcIde29BoZ1IQl2hlA8uVbEOfXdCjudcYSmHWWegthXcf
	9MYIQs+k5a2PrROpEqrI3l5zEmtqbmqsoSKl3qA5bzZ7j5kF8G/hmwRxM53Z2nSXVFFExEenjft
	PpP5kL9zlY9EdPmZfvtg9GcCxcwpcI0jYgD/UOaGQ5AdeKjsy9KIb0qPkN5AVSVQ1VCzLqYni9B
	aie6NaBFm1qyKNU2Zxm9CYO0bmr1LKC/0y//wQd9D+Dl7lWBBIif1TG9IlbgJnDdI31N1J7wCaT
	7SDDzMbvyw9X2+Y7+2aMPbzY7VIQFHovyVWQqZlZqFNp9vNJ/yfdcSTM2b7MkYbWkyN4xcbBmlL
	QrWLQ9mthyTfm2QqsxTfnvCFJBrhjdvnStqSTEtvx/uzfKgaqY9LdeZ9UGLMoQv91WBnhKQ+fpw
	9SijEpyRI4kzxlZi9WrHsLrk4QlK46aCyqN9xKMHTaE0nnXJU=
X-Received: by 2002:a17:90b:1f8f:b0:34c:99d6:175d with SMTP id 98e67ed59e1d1-35965c3b00bmr6653438a91.2.1772314126074;
        Sat, 28 Feb 2026 13:28:46 -0800 (PST)
Received: from Barrys-MBP.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3591349c87bsm6656961a91.2.2026.02.28.13.28.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Feb 2026 13:28:45 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: lenohou@gmail.com
Cc: 21cnbao@gmail.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	laoar.shao@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	weixugc@google.com,
	wjl.linux@gmail.com,
	yuanchu@google.com,
	yuzhao@google.com
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
Date: Sun,  1 Mar 2026 05:28:37 +0800
Message-Id: <20260228212837.59661-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260228161008.707-1-lenohou@gmail.com>
References: <20260228161008.707-1-lenohou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6B8C140003
X-Stat-Signature: fifojzwkfaw4buisdahb1ijrkp4z8w3j
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772314127-511381
X-HE-Meta: U2FsdGVkX1/hMZa7DrObRKpDC5LWxxJxJN70bWJ61HNFADhIzh0HIiUkHrM8e7wnX20nxWynJ/emzMQP6nBf21G5d5ZY/DlswdwZsbzVH7RnvI3p6OmX+mbWDrbAR/5a7IIXQDjhLgIQQLD/xxfzI+u5ziR9PxN7wsGj9rpzj/l0hNwfVV+1qGd1gjNQn8Z5KSYqXqMREu5z7XFNSKEGIHl4fQdyEX1mDmcvL1JnHmsWgrYYJk0h5b1m94g6JkZ9A5lF4b9rsIVzO306nf6KQSDa3XTFvgsKpNXQRq8+lKVZDbXovzaOyKxtzN2h4O/EQ/o5dNtROVjc4VAQB2llCAyyS3UW7nC8q4FLb6AZf1ubh7NQALb2AIPdeHD2qF4NfCBlXXbgMu8dPliAAzuH76/REPlD7oumoati1IKRmA3Mxtulm4wbmInPK52JWke4FIw3/8PeS149FD4t3fInX1Oyn5WqTm9qanccGmM6WBWgn4QwCpX2m+uqUaP9lVmoUgpShUUuZfqe7m7wHRykT2LhBBAghDX4VkHzeqdCO61NYUMFVZ7eBIoztnF/AUCpBpfqUkfZOINz7NRx/0Uk1nu9Y4wWbFFG7mXqkXF9j2cM3zeAfQN1pW4mLFwdm8cln+OZtC2VU8AQqUZaUUfphLtwwJ5COnO0P31oNh9vitEXpchYRT3dxnxEDYr0ARVbTbLCYEwCH5cwKsz4G8M52VODN2ALgsD0XoB2hebKUpbAkkYqeyKP5MTttpx0jtBFbeQOQAC5ObVWGaSxgSSHeIYt084+cKxnblR88TOCQNW9Ul80cpU5pIW+nAwQrwOuvR9T+841B0wdfItRiANEIKiMw/mjDkvrbZOEdcWVF+ECyvXzVFWprUMUZF56y9AfdL57vjF6RxieYJmuKFGP9DCx04IUSlsOrS6/AdqeZVx69yizVWvD4CT8tF2gO/tvnNtTPKInAFJE+2RjVCN
 Q/lZGyxp
 y3OgfgvrTOVbnshIyBLMOmXuOKPS8svNZFsACFSoFFdnuIOMZCgh31yRL7Db41C2bG/qq1FGSopFbJPyJK3OucuwcZerSnlLSkXILHhHVkJEm9/Zelx2+O5rtzvNK8EeI/SOKzOeB/YA5d1psciw59JvogOicMM9/8TvcMPkO8jqMLlQKggX94GQ9jSlJdm0sxd5qfuFXtSAxlgZIAzlYrCfE1bVnXzh8YnKHvOzWVXYuZPIxjrwAcTelkrOX9prroS3NcLhnKaR5ODUKmtwTxPl5xAvhQ9U8dhHsYEpOgxBeinphqDlV8ZURZpef3UEBBhTiWmc6nd/gz72CMGp2ONvJHx+O02+oFkSkgQ2cuX0Umgqazqt6+R4tFKe67kFoZOYf+dPIYBIefrZtJblhsV/mHzKGcoR6H3k87A0NJE2IdrexQXVzHjPgna/N0zBVbjCdQgliI6Hf37Zzf2LsR8oh5KjRhUw4ua77GFemcVCmfwR5nmBIBTabQnOK1vMKuNhI8rI1N+iFSLjxugt4qN2SDP7x4y+kiHMoIiohL7Ua+eL9XOrEEKmFMa5DnKiWPbP1jkp1Olvx8ZMzLv+q+pA/Zk6gWe1v6knV4XJNb57aNcoan2CDyTRb/Lc77VNuSCbAF/IVDALm/7HBb53Dk0VR/QbQtl94P6/U9IxMvY4TCMH2FDaUhjqlVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 1, 2026 at 12:10 AM Leno Hou <lenohou@gmail.com> wrote:
>
> When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
> condition exists between the state switching and the memory reclaim
> path. This can lead to unexpected cgroup OOM kills, even when plenty of
> reclaimable memory is available.
>
> *** Problem Description ***
>
> The issue arises from a "reclaim vacuum" during the transition:
>
> 1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enabled to
>    false before the pages are drained from MGLRU lists back to
>    traditional LRU lists.
> 2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as false
>    and skip the MGLRU path.
> 3. However, these pages might not have reached the traditional LRU lists
>    yet, or the changes are not yet visible to all CPUs due to a lack of
>    synchronization.
> 4. get_scan_count() subsequently finds traditional LRU lists empty,
>    concludes there is no reclaimable memory, and triggers an OOM kill.
>
> A similar race can occur during enablement, where the reclaimer sees
> the new state but the MGLRU lists haven't been populated via
> fill_evictable() yet.
>
> *** Solution ***
>
> Introduce a 'draining' state to bridge the gap during transitions:
>
> - Use smp_store_release() and smp_load_acquire() to ensure the visibility
>   of 'enabled' and 'draining' flags across CPUs.
> - Modify shrink_lruvec() to allow a "joint reclaim" period. If an lruvec
>   is in the 'draining' state, the reclaimer will attempt to scan MGLRU
>   lists first, and then fall through to traditional LRU lists instead
>   of returning early. This ensures that folios are visible to at least
>   one reclaim path at any given time.
>
> *** Reproduction ***
>
> The issue was consistently reproduced on v6.1.157 and v6.18.3 using
> a high-pressure memory cgroup (v1) environment.
>
> Reproduction steps:
> 1. Create a 16GB memcg and populate it with 10GB file cache (5GB active)
>    and 8GB active anonymous memory.
> 2. Toggle MGLRU state while performing new memory allocations to force
>    direct reclaim.
>
> Reproduction script:
> ---
> #!/bin/bash
> # Fixed reproduction for memcg OOM during MGLRU toggle
> set -euo pipefail
>
> MGLRU_FILE="/sys/kernel/mm/lru_gen/enabled"
> CGROUP_PATH="/sys/fs/cgroup/memory/memcg_oom_test"
>
> # Switch MGLRU dynamically in the background
> switch_mglru() {
>     local orig_val=$(cat "$MGLRU_FILE")
>     if [[ "$orig_val" != "0x0000" ]]; then
>         echo n > "$MGLRU_FILE" &
>     else
>         echo y > "$MGLRU_FILE" &
>     fi
> }
>
> # Setup 16G memcg
> mkdir -p "$CGROUP_PATH"
> echo $((16 * 1024 * 1024 * 1024)) > "$CGROUP_PATH/memory.limit_in_bytes"
> echo $$ > "$CGROUP_PATH/cgroup.procs"
>
> # 1. Build memory pressure (File + Anon)
> dd if=/dev/urandom of=/tmp/test_file bs=1M count=10240
> dd if=/tmp/test_file of=/dev/null bs=1M # Warm up cache
>
> stress-ng --vm 1 --vm-bytes 8G --vm-keep -t 600 &
> sleep 5
>
> # 2. Trigger switch and concurrent allocation
> switch_mglru
> stress-ng --vm 1 --vm-bytes 2G --vm-populate --timeout 5s || echo "OOM Triggered"
>
> # Check OOM counter
> grep oom_kill "$CGROUP_PATH/memory.oom_control"
> ---
>
> Signed-off-by: Leno Hou <lenohou@gmail.com>
>
> ---
> To: linux-mm@kvack.org
> To: linux-kernel@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Wei Xu <weixugc@google.com>
> Cc: Barry Song <21cnbao@gmail.com>
> Cc: Jialing Wang <wjl.linux@gmail.com>
> Cc: Yafang Shao <laoar.shao@gmail.com>
> Cc: Yu Zhao <yuzhao@google.com>
> ---
>  include/linux/mmzone.h |  2 ++
>  mm/vmscan.c            | 14 +++++++++++---
>  2 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7fb7331c5725..0648ce91dbc6 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -509,6 +509,8 @@ struct lru_gen_folio {
>         atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
>         /* whether the multi-gen LRU is enabled */
>         bool enabled;
> +       /* whether the multi-gen LRU is draining to LRU */
> +       bool draining;
>         /* the memcg generation this lru_gen_folio belongs to */
>         u8 gen;
>         /* the list segment this lru_gen_folio belongs to */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 06071995dacc..629a00681163 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5222,7 +5222,8 @@ static void lru_gen_change_state(bool enabled)
>                         VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
>                         VM_WARN_ON_ONCE(!state_is_valid(lruvec));
>
> -                       lruvec->lrugen.enabled = enabled;
> +                       smp_store_release(&lruvec->lrugen.enabled, enabled);
> +                       smp_store_release(&lruvec->lrugen.draining, true);
>
>                         while (!(enabled ? fill_evictable(lruvec) : drain_evictable(lruvec))) {
>                                 spin_unlock_irq(&lruvec->lru_lock);
> @@ -5230,6 +5231,8 @@ static void lru_gen_change_state(bool enabled)
>                                 spin_lock_irq(&lruvec->lru_lock);
>                         }
>
> +                       smp_store_release(&lruvec->lrugen.draining, false);
> +
>                         spin_unlock_irq(&lruvec->lru_lock);
>                 }
>
> @@ -5813,10 +5816,15 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>         unsigned long nr_to_reclaim = sc->nr_to_reclaim;
>         bool proportional_reclaim;
>         struct blk_plug plug;
> +       bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
> +       bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
>
> -       if (lru_gen_enabled() && !root_reclaim(sc)) {
> +       if (lrugen_enabled || lru_draining && !root_reclaim(sc)) {
>                 lru_gen_shrink_lruvec(lruvec, sc);
> -               return;

Is it possible to simply wait for draining to finish instead of performing
an lru_gen/lru shrink while lru_gen is being disabled or enabled?

Performing a shrink in an intermediate state may still involve a lot of
uncertainty, depending on how far the shrink has progressed and how much
remains in each side’s LRU？

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3e51190a55e4..ba306e986050 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -509,6 +509,8 @@ struct lru_gen_folio {
 	atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
 	/* whether the multi-gen LRU is enabled */
 	bool enabled;
+	/* whether the multi-gen LRU is switching from/to active/inactive LRU */
+	bool switching;
 	/* the memcg generation this lru_gen_folio belongs to */
 	u8 gen;
 	/* the list segment this lru_gen_folio belongs to */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..60fc611067c7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5196,6 +5196,7 @@ static void lru_gen_change_state(bool enabled)
 			VM_WARN_ON_ONCE(!state_is_valid(lruvec));
 
 			lruvec->lrugen.enabled = enabled;
+			smp_store_release(&lruvec->lrugen.switching, true);
 
 			while (!(enabled ? fill_evictable(lruvec) : drain_evictable(lruvec))) {
 				spin_unlock_irq(&lruvec->lru_lock);
@@ -5203,6 +5204,8 @@ static void lru_gen_change_state(bool enabled)
 				spin_lock_irq(&lruvec->lru_lock);
 			}
 
+			smp_store_release(&lruvec->lrugen.switching, false);
+
 			spin_unlock_irq(&lruvec->lru_lock);
 		}
 
@@ -5780,6 +5783,10 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	bool proportional_reclaim;
 	struct blk_plug plug;
 
+#ifdef CONFIG_LRU_GEN
+	while (smp_load_acquire(&lruvec->lrugen.switching))
+		schedule_timeout_uninterruptible(HZ/100);
+#endif
 	if (lru_gen_enabled() && !root_reclaim(sc)) {
 		lru_gen_shrink_lruvec(lruvec, sc);
 		return;
-- 

> +
> +               if (!lru_draining)
> +                       return;
> +
>         }
>
>         get_scan_count(lruvec, sc, nr);
> --
> 2.52.0
>

Thanks
Barry

