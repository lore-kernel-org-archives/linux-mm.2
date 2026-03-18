Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB3061088E72
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18856B03D3; Wed, 18 Mar 2026 23:40:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9AB6B03D4; Wed, 18 Mar 2026 23:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF336B03D5; Wed, 18 Mar 2026 23:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAAAC6B03D3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:40:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7599AB83BA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:40:45 +0000 (UTC)
X-FDA: 84561410850.22.2B89B91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 859A64000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:40:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DajjYW/h";
	spf=pass (imf04.hostedemail.com: domain of devnull+lenohou.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+lenohou.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773891643;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mvbxuCVcNHhb161TTK0Bf5tkTVaHIr1Z6/mIVRL6g4A=;
	b=klP7U/S0Fn6zFQkjRqYRL/iPP7XiZeuvMMvs8zFwmshlxO11Bs46GOL51OqV8m7FJQNuu+
	iCOiX0yMP7SRoMEf8qrdIo0XLXwSgHj4WwyWi6836ygViubl5pFy7sT2F9ewyB5vsfJMa4
	ObJFIE72yXXJfEteLfhH84lTw8jr3tU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DajjYW/h";
	spf=pass (imf04.hostedemail.com: domain of devnull+lenohou.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+lenohou.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773891643; a=rsa-sha256;
	cv=none;
	b=1iMGdACthNi/oys2qs4TKxrUAhpl2uBqFARsecHvxifr3SrMPa5crlTAD3+Ao8KQxt/ids
	rl1KO9sZsoKzDjmIGl2gaPqzZXywO++vTntQhIeChnw/0WNnm4kf29xU4kqYuWXST4niBU
	IRDJBEgFT8m/Xhoqh49wedVenXIC7us=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BFF696011F;
	Thu, 19 Mar 2026 03:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69FD9C19425;
	Thu, 19 Mar 2026 03:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773891642;
	bh=p/qRor5us3060ICqNaQ7p+NyrpAIj3GVSiIE9ZWRDDc=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=DajjYW/hQ39VwyEP4K4FV3/ZjuwLeL87iUOBfzlqPyw3afN9qW7HGlRFqy5zv0RUO
	 GnkB2DgXBVTF+G0M6w34Y5Sl8HumHlKqyad2j8RosfuGU9H4eAi9Dz3Jk8FozCogZw
	 4oe1wWnzFvrWu4YjfU89iCx9vxCpFfpRzz2OHMVDJtOqZm73J9C0WrBNtylashVDAR
	 QmjlcjIsXCgWHmp8Dq40iSoSyRnMk+Z0V7BnD4GdX1rkND0gh+W7S4aE47Uzk1UX8d
	 HGVtCDKi1zHljBW7MJ1KU9Ey9560uKdl2JfipIx0Azyuiudd1gTib49f4UkwMX8cC2
	 0DGMqOtptbPuw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595991088E72;
	Thu, 19 Mar 2026 03:40:42 +0000 (UTC)
From: Leno Hou via B4 Relay <devnull+lenohou.gmail.com@kernel.org>
Date: Thu, 19 Mar 2026 00:30:49 +0800
Subject: [PATCH v5] mm/mglru: fix cgroup OOM during MGLRU state switching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260319-b4-switch-mglru-v2-v5-1-8898491e5f17@gmail.com>
X-B4-Tracking: v=1; b=H4sIADjTumkC/23PTQ6CMBCG4auQrh3TP0px5T2Mi1oLbQLUtFA1h
 rtbSIwsWH6LefLOB0UTnInoVHxQMMlF54c8ykOBtFVDa8Dd80YUU4EZIXDjEJ9u1Bb6tgsTJAr
 yVlOhMJOcNSgfPoJp3GtFL9e8m+B7GG0w6k9RKokgGMtjhSsg0JnBWz+d21657qh9v0DWxdGH9
 xqX2ML9OsReR2KAQUsutKkVZZRstKUj8S0hdwmeW0j+p9I1E2V93xLzPH8Bok+YEzABAAA=
X-Change-ID: 20260311-b4-switch-mglru-v2-8b926a03843f
To: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Jialing Wang <wjl.linux@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>, 
 Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Leno Hou <lenohou@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773851452; l=14857;
 i=lenohou@gmail.com; s=20260311; h=from:subject:message-id;
 bh=TLPt/0i1sWIWcKvLTdksOuKDUIfUQlHVK1Pa5MMrgBE=;
 b=Wzfs9TTqMuRlgNLPLgZRpuPXp74bz3HFrosZeepfoUy4lKKbt4SXpiFDBLUIr2p3DJFiiDi05
 4tgUzkPV5XrDC80l41KZ7MvGiiPGs9mZVc38sVNwQYzpCUFGo2VYUYy
X-Developer-Key: i=lenohou@gmail.com; a=ed25519;
 pk=8AVHXYurzu1kOGjk9rwvxovwSCynBkv2QAcOvSIe1rw=
X-Endpoint-Received: by B4 Relay for lenohou@gmail.com/20260311 with
 auth_id=674
X-Original-From: Leno Hou <lenohou@gmail.com>
Reply-To: lenohou@gmail.com
X-Rspamd-Queue-Id: 859A64000C
X-Stat-Signature: s1ezre8c5i56e9e7x9rie8nn1ue8xx1y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773891643-869395
X-HE-Meta: U2FsdGVkX1/l1s6L3vX8dgHuuwPVpPbgIyTFH+xyLrPb9SGVmEejWjBMRmuefWRFUllOEVHGjViQQOMDPPEB8LxSX8IEdBw+DOO4Desq15B7hQ2WJiCYsRDeUAtaVnWLXnmGcRSfTCCAuylkamZFlf1nKHbSntl/YiLXpCFJE1RJY8SVKhfVnXYIwbqZuBY0Z6/1GKpiOFxVMLuh7Ieu5Vq7t2LEQdWDd9+Wma4ssRdAc8M+6RWFpd6NEjV6m9ue9DqRGl9Yj7abgo0+YhBgdrb6zIyPksx5ZYeeGp+4YEaTeKEBqIOPUrnWaRCl3/FyyoOLchonSGwP+otC05SqBMEzqq5fTfiX+DRQVALK05zCs+qyYPdtTfTrgnBgQW5kDDp4ndmKg2UNJmCdnCtv3G8lav39LenDaaBG9WLQcAOz9Pry4U8q/nn/ISiznVqh9dghPIN2ZtNgUqOtwkeLbyuFmjArJWKCuPyl4F3oTDGiJxSUqOAcGlLlR9dBMsB5sRaKFAS7FUJFE7UxlV8Bd32VvUKhMwDuXkB1ZKVIGRNVSa3J9O2t1lKP/zOeoZsqczaDl6EVE/9QyXeFb7VT23oOpM/mmCXCzEWCRV2q45ZSnn9GT2HzUbexChBD7zaWG2TZfSWs7rcBoNtYbuMOWl92sHWPRQxKfQb39wCbqVIagdDsex8+zBVyxdEoTXfosHtbMg3Mq1e+v1D767EQ3/nmrSj9i3Hg+LLAhch+btpBOiElw9CCkUUkIUjpilRaSV0cd107p4lGBzjC8zXCDjJ4HK2FyXWzOpr7eNqxwG0hrNn2KxOUi2anKzNbK+XmyIzxa36rqLAWlx39Z49Suz3ylv/iWI4Mk32TQxOva6EP2hAZOuqOT9MayQejmr3sOSiZjsp/01ktcw6813YZAG9K9QmPxSn8KKYVnfAJTnhcSExluKhoVP5RnFb1hjVTBO/ns7Ia+OlIzZCPGoU
 kvP/TM/d
 9MAE8xmCxQc7Ro22sYV5Hu4AqWjp9laAD9E9fvkL7pKuzeh4Wt1NTS2aDvkziuOu7MXYrPgz+2Kr9O4sGZLLQuaaM0llV7D/tFrsST3Dh8zXYKIHzyAc6ZjvcPEG4B7TuOoII5+H94MiOryMBYz8FRKKh0JqF1WZ7tsZ5DjWQPpTp8Ts56YCeeSUbC2em0teOCZG2gVd3P5PtKJdIVZLs/+SsfEhrRf5eKGdETodPmQnNKdpg2zyGNAx0G+MK+5IECDOXQIGZku1j6V2KMne9bS+hkGiYbkZv1IgoYtyRoONlMwlZSWSNsogjNjpxqYFuSiNt32opqUHxlqlVzmwKsfSszPIRfz3APduLDaoxCwDn1Nx+uBcImRu4bF00iVkChUrcSX92zfu/8QkQhZPJGkSrxn9Bks1T1dhQvO4VajiS+1q5glH06t0RwdRm3uJW1D5R/rFTMNc7ci62EmlrdEgNavfURQ2lcObV7hpBKIU83xCBxTvRgG4ucAq45QvkaTIPidMfvGM/I8GGpLuaoSd+Py6qUZiCAb4AgHfT/7OJFI+uti8ocjLuW46Ic5cIhz8NNppKfz1jIywqG405CZrdmWyUf7FxKoLsoGLQZKFUzxKYTLQE9UGrhAdAnmQZC4Qnthx23UqFS4+yrVxoQm0SmUoexdrl3uWUflcylWCq6IoM2bVtJcTMB+hBIV9gpLgZUbR0odsjF6MtzpzadIuv4DeI0Jmqivu6mys8JAQLQaem3WxUpl7WtsO0Y01hbFX71cYtp2XEscqJtUUoXG5Or01+mIKBd2gX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leno Hou <lenohou@gmail.com>

When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
condition exists between the state switching and the memory reclaim path.
This can lead to unexpected cgroup OOM kills, even when plenty of
reclaimable memory is available.

Problem Description
==================
The issue arises from a "reclaim vacuum" during the transition.

1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enabled to
   false before the pages are drained from MGLRU lists back to traditional
   LRU lists.
2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as false
   and skip the MGLRU path.
3. However, these pages might not have reached the traditional LRU lists
   yet, or the changes are not yet visible to all CPUs due to a lack
   of synchronization.
4. get_scan_count() subsequently finds traditional LRU lists empty,
   concludes there is no reclaimable memory, and triggers an OOM kill.

A similar race can occur during enablement, where the reclaimer sees the
new state but the MGLRU lists haven't been populated via fill_evictable()
yet.

Solution
========
Introduce a 'switching' state (`lru_switch`) to bridge the transition.
When transitioning, the system enters this intermediate state where
the reclaimer is forced to attempt both MGLRU and traditional reclaim
paths sequentially. This ensures that folios remain visible to at least
one reclaim mechanism until the transition is fully materialized across
all CPUs.

Changes
=======
v5:
 - Rename lru_gen_draining to lru_gen_switching; lru_drain_core to
   lru_switch
 - Add more documentation for folio_referenced_one
 - Keep folio_check_references unchanged

v4:
 - Fix Sashiko.dev's AI CodeReview comments
 - Remove the patch maintain workingset refault context across
 - Remove folio_lru_gen(folio) != -1 which involved in v2 patch

v3:
 - Rebase onto mm-new branch for queue testing
 - Don't look around while draining
 - Fix Barry Song's comment

v2:
- Replace with a static branch `lru_drain_core` to track the transition
  state.
- Ensures all LRU helpers correctly identify page state by checking
  folio_lru_gen(folio) != -1 instead of relying solely on global flags.
- Maintain workingset refault context across MGLRU state transitions
- Fix build error when CONFIG_LRU_GEN is disabled.

v1:
- Use smp_store_release() and smp_load_acquire() to ensure the visibility
  of 'enabled' and 'draining' flags across CPUs.
- Modify shrink_lruvec() to allow a "joint reclaim" period. If an lruvec
  is in the 'draining' state, the reclaimer will attempt to scan MGLRU
  lists first, and then fall through to traditional LRU lists instead
  of returning early. This ensures that folios are visible to at least
  one reclaim path at any given time.

Race & Mitigation
================
A race window exists between checking the 'draining' state and performing
the actual list operations. For instance, a reclaimer might observe the
draining state as false just before it changes, leading to a suboptimal
reclaim path decision.

However, this impact is effectively mitigated by the kernel's reclaim
retry mechanism (e.g., in do_try_to_free_pages). If a reclaimer pass fails
to find eligible folios due to a state transition race, subsequent retries
in the loop will observe the updated state and correctly direct the scan
to the appropriate LRU lists. This ensures the transient inconsistency
does not escalate into a terminal OOM kill.

This effectively reduce the race window that previously triggered OOMs
under high memory pressure.

This fix has been verified on v7.0.0-rc1; dynamic toggling of MGLRU
functions correctly without triggering unexpected OOM kills.

To: Andrew Morton <akpm@linux-foundation.org>
To: Axel Rasmussen <axelrasmussen@google.com>
To: Yuanchu Xie <yuanchu@google.com>
To: Wei Xu <weixugc@google.com>
To: Barry Song <21cnbao@gmail.com>
To: Jialing Wang <wjl.linux@gmail.com>
To: Yafang Shao <laoar.shao@gmail.com>
To: Yu Zhao <yuzhao@google.com>
To: Kairui Song <ryncsn@gmail.com>
To: Bingfang Guo <bfguo@icloud.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Leno Hou <lenohou@gmail.com>
---
When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
condition exists between the state switching and the memory reclaim path.
This can lead to unexpected cgroup OOM kills, even when plenty of
reclaimable memory is available.

Problem Description 
==================
The issue arises from a "reclaim vacuum" during the transition.

1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enabled to
   false before the pages are drained from MGLRU lists back to traditional
   LRU lists.
2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as false
   and skip the MGLRU path.
3. However, these pages might not have reached the traditional LRU lists
   yet, or the changes are not yet visible to all CPUs due to a lack
   of synchronization.
4. get_scan_count() subsequently finds traditional LRU lists empty,
   concludes there is no reclaimable memory, and triggers an OOM kill.

A similar race can occur during enablement, where the reclaimer sees the
new state but the MGLRU lists haven't been populated via fill_evictable()
yet.

Solution 
========
Introduce a 'switching' state (`lru_switch`) to bridge the transition.
When transitioning, the system enters this intermediate state where
the reclaimer is forced to attempt both MGLRU and traditional reclaim
paths sequentially. This ensures that folios remain visible to at least
one reclaim mechanism until the transition is fully materialized across
all CPUs.

Changes 
=======
v5:
 - Rename lru_gen_draining to lru_gen_switching; lru_drain_core to
   lru_switch
 - Add more documentation for folio_referenced_one
 - Keep folio_check_references unchanged
v4:
 - Fix Sashiko.dev's AI CodeReview comments
 - Remove the patch maintain workingset refault context across
 - Remove folio_lru_gen(folio) != -1 which involved in v2 patch

v3:
 - Rebase onto mm-new branch for queue testing 
 - Don't look around while draining 
 - Fix Barry Song's comment

v2: 
- Replace with a static branch `lru_drain_core` to track the transition
  state.
- Ensures all LRU helpers correctly identify page state by checking
  folio_lru_gen(folio) != -1 instead of relying solely on global flags.
- Maintain workingset refault context across MGLRU state transitions 
- Fix build error when CONFIG_LRU_GEN is disabled.

v1: 
- Use smp_store_release() and smp_load_acquire() to ensure the visibility
  of 'enabled' and 'draining' flags across CPUs.
- Modify shrink_lruvec() to allow a "joint reclaim" period. If an lruvec 
  is in the 'draining' state, the reclaimer will attempt to scan MGLRU
  lists first, and then fall through to traditional LRU lists instead
  of returning early. This ensures that folios are visible to at least
  one reclaim path at any given time.

Race & Mitigation 
================
A race window exists between checking the 'draining' state and performing
the actual list operations. For instance, a reclaimer might observe the
draining state as false just before it changes, leading to a suboptimal
reclaim path decision.

However, this impact is effectively mitigated by the kernel's reclaim
retry mechanism (e.g., in do_try_to_free_pages). If a reclaimer pass fails
to find eligible folios due to a state transition race, subsequent retries
in the loop will observe the updated state and correctly direct the scan
to the appropriate LRU lists. This ensures the transient inconsistency
does not escalate into a terminal OOM kill.

This effectively reduce the race window that previously triggered OOMs
under high memory pressure.

This fix has been verified on v7.0.0-rc1; dynamic toggling of MGLRU
functions correctly without triggering unexpected OOM kills.

Reproduction 
===========

The issue was consistently reproduced on v6.1.157 and v6.18.3 using a
high-pressure memory cgroup (v1) environment.

Reproduction steps: 
1. Create a 16GB memcg and populate it with 10GB file cache (5GB active)
   and 8GB active anonymous memory.
2. Toggle MGLRU state while performing new memory allocations to force
   direct reclaim.

Reproduction script 
===================

```bash

MGLRU_FILE="/sys/kernel/mm/lru_gen/enabled"
CGROUP_PATH="/sys/fs/cgroup/memory/memcg_oom_test"

switch_mglru() {
    local orig_val=$(cat "$MGLRU_FILE")
    if [[ "$orig_val" != "0x0000" ]]; then
        echo n > "$MGLRU_FILE" &
    else
        echo y > "$MGLRU_FILE" &
    fi
}

mkdir -p "$CGROUP_PATH"
echo $((16 * 1024 * 1024 * 1024)) > "$CGROUP_PATH/memory.limit_in_bytes"
echo $$ > "$CGROUP_PATH/cgroup.procs"

dd if=/dev/urandom of=/tmp/test_file bs=1M count=10240
dd if=/tmp/test_file of=/dev/null bs=1M # Warm up cache

stress-ng --vm 1 --vm-bytes 8G --vm-keep -t 600 &
sleep 5

switch_mglru
stress-ng --vm 1 --vm-bytes 2G --vm-populate --timeout 5s || \
echo "OOM Triggered"

grep oom_kill "$CGROUP_PATH/memory.oom_control"
```
---
Changes in v5:
- Rename lru_gen_draining to lru_gen_switching; lru_drain_core to
   lru_switch
- Add more documentation for folio_referenced_one
- Keep folio_check_references unchanged
- Link to v4: https://lore.kernel.org/r/20260318-b4-switch-mglru-v2-v4-1-1b927c93659d@gmail.com

Changes in v4:
- Fix Sashiko.dev's AI CodeReview comments
  Link: https://sashiko.dev/#/patchset/20260316-b4-switch-mglru-v2-v3-0-c846ce9a2321%40gmail.com 
- Remove the patch maintain workingset refault context across
- Remove folio_lru_gen(folio) != -1 which involved in v2 patch
- Link to v3: https://lore.kernel.org/r/20260316-b4-switch-mglru-v2-v3-0-c846ce9a2321@gmail.com
---
 include/linux/mm_inline.h | 11 +++++++++++
 mm/rmap.c                 |  7 ++++++-
 mm/vmscan.c               | 33 ++++++++++++++++++++++++---------
 3 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ad50688d89db..760e6e923fc5 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -102,6 +102,12 @@ static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
 
 #ifdef CONFIG_LRU_GEN
 
+static inline bool lru_gen_switching(void)
+{
+	DECLARE_STATIC_KEY_FALSE(lru_switch);
+
+	return static_branch_unlikely(&lru_switch);
+}
 #ifdef CONFIG_LRU_GEN_ENABLED
 static inline bool lru_gen_enabled(void)
 {
@@ -316,6 +322,11 @@ static inline bool lru_gen_enabled(void)
 	return false;
 }
 
+static inline bool lru_gen_switching(void)
+{
+	return false;
+}
+
 static inline bool lru_gen_in_fault(void)
 {
 	return false;
diff --git a/mm/rmap.c b/mm/rmap.c
index 6398d7eef393..b5e43b41f958 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -966,7 +966,12 @@ static bool folio_referenced_one(struct folio *folio,
 			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
 		}
 
-		if (lru_gen_enabled() && pvmw.pte) {
+		/*
+		 * When LRU is switching, we don’t know where the surrounding folios
+		 * are. —they could be on active/inactive lists or on MGLRU. So the
+		 * simplest approach is to disable this look-around optimization.
+		 */
+		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte) {
 			if (lru_gen_look_around(&pvmw, nr))
 				referenced++;
 		} else if (pvmw.pte) {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33287ba4a500..605cae534bf8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -886,7 +886,7 @@ static enum folio_references folio_check_references(struct folio *folio,
 	if (referenced_ptes == -1)
 		return FOLIOREF_KEEP;
 
-	if (lru_gen_enabled()) {
+	if (lru_gen_enabled() && !lru_gen_switching()) {
 		if (!referenced_ptes)
 			return FOLIOREF_RECLAIM;
 
@@ -2286,7 +2286,7 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 	unsigned long file;
 	struct lruvec *target_lruvec;
 
-	if (lru_gen_enabled())
+	if (lru_gen_enabled() && !lru_gen_switching())
 		return;
 
 	target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
@@ -2625,6 +2625,7 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
 
 #ifdef CONFIG_LRU_GEN
 
+DEFINE_STATIC_KEY_FALSE(lru_switch);
 #ifdef CONFIG_LRU_GEN_ENABLED
 DEFINE_STATIC_KEY_ARRAY_TRUE(lru_gen_caps, NR_LRU_GEN_CAPS);
 #define get_cap(cap)	static_branch_likely(&lru_gen_caps[cap])
@@ -5318,6 +5319,8 @@ static void lru_gen_change_state(bool enabled)
 	if (enabled == lru_gen_enabled())
 		goto unlock;
 
+	static_branch_enable_cpuslocked(&lru_switch);
+
 	if (enabled)
 		static_branch_enable_cpuslocked(&lru_gen_caps[LRU_GEN_CORE]);
 	else
@@ -5348,6 +5351,9 @@ static void lru_gen_change_state(bool enabled)
 
 		cond_resched();
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+
+	static_branch_disable_cpuslocked(&lru_switch);
+
 unlock:
 	mutex_unlock(&state_mutex);
 	put_online_mems();
@@ -5920,9 +5926,12 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	bool proportional_reclaim;
 	struct blk_plug plug;
 
-	if (lru_gen_enabled() && !root_reclaim(sc)) {
+	if ((lru_gen_enabled() || lru_gen_switching()) && !root_reclaim(sc)) {
 		lru_gen_shrink_lruvec(lruvec, sc);
-		return;
+
+		if (!lru_gen_switching())
+			return;
+
 	}
 
 	get_scan_count(lruvec, sc, nr);
@@ -6182,10 +6191,13 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	struct lruvec *target_lruvec;
 	bool reclaimable = false;
 
-	if (lru_gen_enabled() && root_reclaim(sc)) {
+	if ((lru_gen_enabled() || lru_gen_switching()) && root_reclaim(sc)) {
 		memset(&sc->nr, 0, sizeof(sc->nr));
 		lru_gen_shrink_node(pgdat, sc);
-		return;
+
+		if (!lru_gen_switching())
+			return;
+
 	}
 
 	target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
@@ -6455,7 +6467,7 @@ static void snapshot_refaults(struct mem_cgroup *target_memcg, pg_data_t *pgdat)
 	struct lruvec *target_lruvec;
 	unsigned long refaults;
 
-	if (lru_gen_enabled())
+	if (lru_gen_enabled() && !lru_gen_switching())
 		return;
 
 	target_lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
@@ -6845,9 +6857,12 @@ static void kswapd_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
-	if (lru_gen_enabled()) {
+	if (lru_gen_enabled() || lru_gen_switching()) {
 		lru_gen_age_node(pgdat, sc);
-		return;
+
+		if (!lru_gen_switching())
+			return;
+
 	}
 
 	lruvec = mem_cgroup_lruvec(NULL, pgdat);

---
base-commit: 39849a55738542a4cdef8394095ccfa98530e250
change-id: 20260311-b4-switch-mglru-v2-8b926a03843f

Best regards,
-- 
Leno Hou <lenohou@gmail.com>



