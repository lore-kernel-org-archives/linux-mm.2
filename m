Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BCE6104C00D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 12:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CE526B0092; Wed, 11 Mar 2026 08:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0767A6B0005; Wed, 11 Mar 2026 08:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E665A6B0095; Wed, 11 Mar 2026 08:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE1AA6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:09:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6FC881A01A1
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:09:48 +0000 (UTC)
X-FDA: 84533663256.11.3BC8F4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C165100002
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:09:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YvjImFbJ;
	spf=pass (imf14.hostedemail.com: domain of devnull+lenohou.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+lenohou.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773230986;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZJCDOhtzXFhptXheVaul6ODtiWIF1BTENIqvZkKjNUA=;
	b=wsMNAQxYPq1qU3QvsK7utJIuvQZ6tC0UYs63Y8p/EhG/FcnNRzYceJ/CxAPal3rN9SrfKb
	XEHqTStMwO5Kb5fBMSIn6dGunXWBAbQJKXZQuSjHzzae8TJiApSVA4fItM1wV0imxknThM
	UOVtIeiWI4dbZSETBL8cAcX8ecOJecM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773230986; a=rsa-sha256;
	cv=none;
	b=nghX97c4TZuWAHtAz6T9H+M1CwU9Ws+1WqK0vBiIDmlc8YOTFzjk5yJIOgi+VAihMFKKom
	07UqakZD7+oXW9uh613UlTXwaXkSPZnDtyBcfXUx+yAy6oqbO2tsgnkM1rBA8DY+JCwk5w
	IbIUyJWtQciU0+pahSiUEQR+iqydP3Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YvjImFbJ;
	spf=pass (imf14.hostedemail.com: domain of devnull+lenohou.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+lenohou.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 14DD143B8B;
	Wed, 11 Mar 2026 12:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCE1BC4CEF7;
	Wed, 11 Mar 2026 12:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773230984;
	bh=i6se0oZRXKFtnBz68nKbLYLaOr8ZsBgTi4bTAsYKR+g=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=YvjImFbJhWFSG7LGq6VhHLtSXyLXPMqKKL1oG8esqPRSWy0ELikcRWESIj1GB2GZL
	 diEN+PHboh9vwH5XVf3ap1vxU5dPYLFBDHN8o4OnbT2GX/8a4ZfkZ1iSfTrvw33agL
	 csCX2Sj4KWSwuDvlSn1NL81jI1+vwDb6N3sr725u3r0MrvkK/UrWDw1sE4rAPZxXSs
	 n7iBPx6hifgv76BLV04iShOXC1jthJFHCpHSJz7UKHNEGEoRlpppUikSY5Uvj64iiz
	 9Yz92F1P3P+vZibF7Ie8pUYly2uR4T1w00nK9fiTM/UL26gOWqeUNEOuzo2qDlLqpp
	 OHOqhQ4miuSCQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C673E104C00D;
	Wed, 11 Mar 2026 12:09:44 +0000 (UTC)
From: Leno Hou via B4 Relay <devnull+lenohou.gmail.com@kernel.org>
Subject: [PATCH v2 0/2] mm/mglru: fix cgroup OOM during MGLRU state
 switching
Date: Wed, 11 Mar 2026 20:09:41 +0800
Message-Id: <20260311-b4-switch-mglru-v2-v2-0-080cb9321463@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIVbsWkC/0XMQQ6CMBBA0auQWTukHQhUV97DuCg40EkoJS2gC
 eHuNm5cvsX/BySOwgluxQGRd0kS5gy6FNA7O4+M8soGUtSoSmvsakxvWXuHfpzihjuh6a7UWFW
 Zuhogh0vkQT6/6eOZPcTgcXWR7X9FZHSjlTJlq1rUOPEcXNjuo7cylX3wcJ5ffswa350AAAA=
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773230982; l=4299;
 i=lenohou@gmail.com; s=20260311; h=from:subject:message-id;
 bh=i6se0oZRXKFtnBz68nKbLYLaOr8ZsBgTi4bTAsYKR+g=;
 b=ho3bW5vUlOrRO0GDbulfWdvRJRo9/EGG7KO4DMxo6UEspNVPpB+6jNaXyszijvKaJJhZZGCdD
 +ak1JLtjAe1CC8E4+oP2ZnFUU3HO5YqHJ4BG/onrLyCS80RLnItCeo4
X-Developer-Key: i=lenohou@gmail.com; a=ed25519;
 pk=8AVHXYurzu1kOGjk9rwvxovwSCynBkv2QAcOvSIe1rw=
X-Endpoint-Received: by B4 Relay for lenohou@gmail.com/20260311 with
 auth_id=674
X-Original-From: Leno Hou <lenohou@gmail.com>
Reply-To: lenohou@gmail.com
X-Rspam-User: 
X-Stat-Signature: uitz9wob6f7dn143fabbncrcjou5w5ox
X-Rspamd-Queue-Id: 5C165100002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773230986-995546
X-HE-Meta: U2FsdGVkX1/VX55lnHBgkGTeESJ4d2wpsjMgGs2pnoQ38GiAXgz9uHSSHqaMM2TK4HzSIfYfJOCHB4i2csGfFhn5C8yM5Tbi8mNbEWBdr2I61K+TfUnQePI1Rfw6XQbTFZJRq5uQuRNaCw1a35Gchec7Zyf8qhzhNpWdY82HcpYhJNAR2rsxP5yy4YcSJxx0UYsFFMRuAhvvihf72HFAsdHYGMlDrCpJha+39k058o/FtrkI+yE+H738EHg38JdDzZyGdMFAoVgIXXezpMcls+1lJ44uxXFghG5DxCKHtwX1SuC99HYI0UUqlfBZK9ZZdEEE7FYu2UEwly2SrZAr3EPVTGIBrMi3mZADLi9dI7n74NHKjdOw+djOLog7EqPq4Mfmv1VTv279tZtcjXssH49kBxaom/CyEgovrJqYCc3kalRsbluOAPkXywF/NX32fo/30XZwYOExvFpInnzRcXV4LEWbcfEVOp/zdW3xIFZAJlr0+t6L7PBfKAWghw3oqjuLgHF48YbsbKBFYa6gt1gSgG3nyQBbxNvIHR+JXWcIRpL2B279wWp7W5qKhQl6knWmFbYTKOxqMPUANyDk3vh/MoyCwuBIyvh7zrLRuDMSI+CYOthOfImLkMBI0DuwP5NMvYLIIB7H7z2VLur0iaTdfCvvmkv7u7YdcMpcdsTO9yXK8PCJhfv2kPtdmJ1OBNVSZIiJmSGijCa6tOTn9dISss6ALpUpQwsahhUwp8Hj509D0R7Fkorwzq6L/TeN3q9lt4k3ssJkpGMMzb0WrqxeyrS+m2ARHo94HBDSJYi2Dpsv4Py0qIX8WcAwDlTqImMuvKvnWp7Esczj/PFYkg4Aqzv8MboHIXyTC0izdcnRU3gLBAvebbboKyqQhQ2BSMlp0xE0vQFipZ6jmdFkmkSI8MvAk+vCC5UGY57wyLo/n3FxAehx56XAoP5GbaJHFwbRxNOabbBeEFhhsKJ
 06GZSkL7
 mYSCoiDIqsrLVSf7Ije455tjh0SHAEwDV9MUQngtcLG2JYcFH36x4uqGkzSUk6VUb55i2/DvNFejrU/HLFUNikcSitdfSppwRmT820cXULL97ghVHERij/z3+EWq7zVI4mzVNmXuokMcAfsxiEEtFbTDgUzZbCdcsaEBn6ZR1z/gAAayr0/NFcaAfbhk1+FequWC3IcjoHoF+PnQxq1qnmWF9hnGcyKFnjKIa9T4NN9O0RbrQ7Ug6LNAXpTY31YahZeo0xOoIlY6gA3GNyehSAb3iURBIkwFDcUPIJqaxs1IDd3daeEFnnctS1ba+6TMHk9rgOVfDbPbxxxHZg7Rkr5mU+arylL+n8zBgLclDG3SVX3mVCp/wFQKhmvXW2ivgOMRjlDT5rfWtdYlmJZvx5KanFaH4tk/Y5pXZjZ4+u6I7PQLpGPNG3hnKIh8FpVYObeQYNBbTFKyg1T3GnANkeM+ABXM6BbqF8iz/b0eaVXcfhXvOdb/hybcSZ8TFYWepzj8wHrrdamcEvDk=
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

Problem Description
==================

The issue arises from a "reclaim vacuum" during the transition.

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

Solution
========

Introduce a 'draining' state (`lru_drain_core`) to bridge the
transition. When transitioning, the system enters this intermediate state
where the reclaimer is forced to attempt both MGLRU and traditional reclaim
paths sequentially. This ensures that folios remain visible to at least
one reclaim mechanism until the transition is fully materialized across all
CPUs.

Changes
=======

v2:
- Repalce with a static branch `lru_drain_core` to track the transition state.
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

This effectively eliminates the race window that previously triggered OOMs
under high memory pressure.

Reproduction
===========

The issue was consistently reproduced on v6.1.157 and v6.18.3 using
a high-pressure memory cgroup (v1) environment.

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
stress-ng --vm 1 --vm-bytes 2G --vm-populate --timeout 5s || echo "OOM Triggered"

grep oom_kill "$CGROUP_PATH/memory.oom_control"
```

Signed-off-by: Leno Hou <lenohou@gmail.com>
---
Leno Hou (2):
      mm/mglru: fix cgroup OOM during MGLRU state switching
      mm/mglru: maintain workingset refault context across state transitions

 include/linux/mm_inline.h |  5 +++++
 mm/rmap.c                 |  2 +-
 mm/swap.c                 | 14 ++++++++------
 mm/vmscan.c               | 49 ++++++++++++++++++++++++++++++++++++++---------
 mm/workingset.c           | 19 ++++++++++++------
 5 files changed, 67 insertions(+), 22 deletions(-)
---
base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
change-id: 20260311-b4-switch-mglru-v2-8b926a03843f

Best regards,
-- 
Leno Hou <lenohou@gmail.com>



