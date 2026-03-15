Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 803CBD58B37
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 05:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D1E6B0125; Mon, 16 Mar 2026 01:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14BA26B0127; Mon, 16 Mar 2026 01:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060E56B0128; Mon, 16 Mar 2026 01:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E77766B0125
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 01:56:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A894EC42CE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:56:52 +0000 (UTC)
X-FDA: 84550867464.24.163C049
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 892961C0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:56:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PqR1E+sO;
	spf=pass (imf18.hostedemail.com: domain of devnull+lenohou.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+lenohou.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773640610;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UMmpvtuTeXKkH5EXkNxVqreHij7QkjcX2WajQsEkVcs=;
	b=fn6gIoWKC3tQOA1/xy+V6g7fhUSZT9tZveWIe/ocbyzkm2Zf+PWhBfaY+fDb/ah6vUadxu
	4WZQ8mp7vEOaaDFe0HIUpAwM4xeGs5uNYeNDyzADmyFZmE4bDOHUA3ami37R+U5lNM+EsH
	JNWzkNSRYzVk0F88VKEW8oUZI9meECU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PqR1E+sO;
	spf=pass (imf18.hostedemail.com: domain of devnull+lenohou.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+lenohou.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773640610; a=rsa-sha256;
	cv=none;
	b=YByXRJ2FbIx3v7cQH6mPdIBQFRBuod4IgXRA0BLuzmFZxKA/e60QC3Gsfuh89nA+BRGiSE
	cmQGYIx3Cy1MpHIea/7gTk5V1qTbjLRxrPbxInEbpcqB+YTSmu+NsFnKCNqfQharp7dwOI
	l0RCFWqIeGaaAkZgGyT/sPYxsZofXGg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 565A940A82;
	Mon, 16 Mar 2026 05:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 299B6C19425;
	Mon, 16 Mar 2026 05:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773640609;
	bh=XLc+CXHr5szARKA5uOkl7B+FTZea7sdEx94SmPTWyQE=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=PqR1E+sOk2MdNEjHpg6arZlCOp7XJEE92/Uw3omcWCCx4Xr5gOxgDMipnzJO4xZjs
	 vvY7dKoBf9m7wEwuPbxg7ETMbfQEGqP+bOwmI4LU+mCpsIN3WCWHDJdUsZ2L02gB08
	 bOqv+rrBoYUo7SuzFCjy6ARwhALjtaewcDgDq1v7CJUh3a4cKara5duYYjT37BZ9gA
	 qZ0ZrzyEyGMG06LePJ6w9lUOqljAd+iSVh9k48gUuJUvGyoejq4ETklSLp6eQtVP2K
	 dZk84dkV8ofbTYavOA0MJ1O1AHuzMLJJYz0Ykorr3VQyEmERWU3BK7ue9GT66Wyyo6
	 cYT2a/sPiGn2g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BBBF30273;
	Mon, 16 Mar 2026 05:56:49 +0000 (UTC)
From: Leno Hou via B4 Relay <devnull+lenohou.gmail.com@kernel.org>
Subject: [PATCH v3 0/2] mm/mglru: fix cgroup OOM during MGLRU state
 switching
Date: Mon, 16 Mar 2026 02:18:27 +0800
Message-Id: <20260316-b4-switch-mglru-v2-v3-0-c846ce9a2321@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPP3tmkC/0XMTQ6CMBBA4auQWTukPwSqK+9hXJQ60EkoJS2gC
 eHuNm5cfov3DsiUmDLcqgMS7Zw5zgX6UoHzdh4J+VUMSqhWaCmxbzC/eXUewzilDXeFpr+q1gp
 tGj1ACZdEA39+08ezeEgx4OoT2f9KKSNbKYSpO9GhxInm6ON2H4PlqXYxwHl+AWC50MKdAAAA
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773598759; l=5184;
 i=lenohou@gmail.com; s=20260311; h=from:subject:message-id;
 bh=XLc+CXHr5szARKA5uOkl7B+FTZea7sdEx94SmPTWyQE=;
 b=Cvua+Hm4bluAud07M5yJ1O5z7mD/0RYWVModAydGh/0qCqMD0PTAKQKUXoEOA1ZLkM3slOfGi
 i1kFmORzItHCvtOI0VIHkF8UzKws99rkuncJg4vcMlOqO2vvNR/kcOY
X-Developer-Key: i=lenohou@gmail.com; a=ed25519;
 pk=8AVHXYurzu1kOGjk9rwvxovwSCynBkv2QAcOvSIe1rw=
X-Endpoint-Received: by B4 Relay for lenohou@gmail.com/20260311 with
 auth_id=674
X-Original-From: Leno Hou <lenohou@gmail.com>
Reply-To: lenohou@gmail.com
X-Rspamd-Queue-Id: 892961C0005
X-Stat-Signature: xxd6gdjomm65bit581wj5poaa8ohgtgw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773640610-544204
X-HE-Meta: U2FsdGVkX18VDgThkZ7+iGfzqSk2fI3H4VPCiB2I0beaZqsAa1AKlb014iomLJTShlVQ4ksnTcOONwepYqLkCH895O9Vo/t93cql41SqgswU7r8ullXPjWI5P0LrsmiGRGCA8ru/93z4bfAsSLoopa4ycFea9uMX4ajqx8h1lwAB4ZDvh8DaUAgcxJferoA4wIMASwgbVW2aBMPkfsQflevIrWsqHanJ3Ryj5fAAcUqcNOQPgzJy4G9vRJJuezeIgxX1puuU+O2a6u+bqHqnN+TmySpy5HHs5fX/Cn0NWib903HtbW6fOT0os1/v43odUHpnRWAP3M/a/ie3WPOZDwNMO7qc+s9nEMgOTk8nSVXeTtk2AYRMqR0vM7QCY0wV0PNmEu2jJQ8npLUiHM8wHnQcpIi48c4URn4dG1O/9abLQc4obCHF+PpllewVLFCoxCw/wDmyc30uhDOvGs7PX1W0F1xxIHSDEr+DnEuOZSSlbvAt6dKQGxsDO38QF4PRFlb68rx9gcGYCu4xIr7q3GiwXGZOgr7RGSD0nPLWKwu3Ufi3HXw81d175FSs1jFrq51GHk9gHCD3oNv90xy2DRDdjSzmUuIJrVBT6MvR2DsShAvfCS1m7yeRiURzwQ+FewxCk+uyKA1WZFip1zcuJpy+571388ULgqpFOdXssO8CXnx7X07kIKWrsvOfxvswZKb84FdDEYosBgAlL5KUH/t01yvP7dpKb8plusCgYQRlv9QOuRSNIflUREuzEPRtr1YZJWFM+zxXObENtvgibNp+x8cfmWDH6wT7jG71mpPjyi7liHVCbyNTvGbTeX6dIZH2ZRw6gM+NXRZ0XgzpDVESDTjlYhTnf/oMEL4il6eg4e4sDBsGG1XNYxhrdoaasBUfLF7Q/Jh3/TVtU9MyQECB75Fxvd+JBFEK58VhslCoKDYaE4uZ/U2Wn3CBugyZgkHgAhplZ3TbW/+Vyl1
 alIA1v47
 /Tg+Xi7tmf8t9GugzjjHYTkb8pWnUM7URI2lo1ivqZRGdQvqCLraB8mLNYnV3X4ioGftJ8OGOJ+3dejuQeXIVRQblCRbrHmjzG+s6+KTevpTWUiPLy/Jqccqhi8zi21zrOlRXghERIkkewNvIbzV+A/Qx0+WChXtR/wgqw9a4QyxxT9QkiFS+6v33hIqCG2umayP6SkA8XnhkGv/t9bpswB8Tq4D1isVBsfcJfLbh72uPe5Dtl96GSvUQ3nD4CvA01tWMxQfs6MtFuZsgq9YwNnW/x63rrKG5dKYvpXKH7+jbDAY42/YtZ+va1PzBw4huF4bEL+XnrhRu0drYywk1JkXZx/526UyIG/g8Q4PdEzeUoFwayG6+Nis9JXUiYLrB2pYKt2leZKpgEpOG2y2xnP2wLsWyu/JZoZU9KGernewVw9XiFgM/0Tq+IIqqbGFQ5hknIsgnOyiqdHTkkXo5Y+FMqSAdbV9DsjceDzrzL2rKLPwqBPBIe3Jub5dKm8BdiEzQ5CwT/xLEdsU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Introduce a 'draining' state (`lru_drain_core`) to bridge the transition.
When transitioning, the system enters this intermediate state where
the reclaimer is forced to attempt both MGLRU and traditional reclaim
paths sequentially. This ensures that folios remain visible to at least
one reclaim mechanism until the transition is fully materialized across
all CPUs.

Changes 
=======

v3:
 - Rebase onto mm-new branch for queue testing 
 - Don't look around while draining 
 - Fix Barry Song's comment

v2: 
- Repalce with a static branch `lru_drain_core` to track the transition
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

Signed-off-by: Leno Hou <lenohou@gmail.com>
---
Leno Hou (2):
      mm/mglru: fix cgroup OOM during MGLRU state switching
      mm/mglru: maintain workingset refault context across state transitions

 include/linux/mm_inline.h | 16 ++++++++++++++
 include/linux/swap.h      |  2 +-
 mm/rmap.c                 |  2 +-
 mm/swap.c                 | 15 +++++++------
 mm/vmscan.c               | 55 +++++++++++++++++++++++++++++++++++------------
 mm/workingset.c           | 22 +++++++++++++------
 6 files changed, 83 insertions(+), 29 deletions(-)
---
base-commit: c5a81ff6071bcf42531426e6336b5cc424df6e3d
change-id: 20260311-b4-switch-mglru-v2-8b926a03843f

Best regards,
-- 
Leno Hou <lenohou@gmail.com>



