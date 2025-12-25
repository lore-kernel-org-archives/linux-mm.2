Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AFB2E7AD4B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 23:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38F2C6B0088; Thu, 25 Dec 2025 18:21:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312996B0089; Thu, 25 Dec 2025 18:21:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E396B008A; Thu, 25 Dec 2025 18:21:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E91F6B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 18:21:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8049713B458
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:21:27 +0000 (UTC)
X-FDA: 84259567014.23.02C6DF2
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf19.hostedemail.com (Postfix) with ESMTP id CBEB71A000A
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:21:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T3DbFzf8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766704885; a=rsa-sha256;
	cv=none;
	b=55ZgmmGvQY7Tc9Yua3YcdkPQl9SWJIr+1idKan9k5TzKolUFQ6WftS1GKwrebsz/gHDpTV
	U+EzhUBzKfjPJjQRGcqBMdhePvD2dhwZRbx4q6GQ7nEyTocOWOtp4mDc08LJuS/6nEBtCR
	Vxl05hHG+k8hZrKyxH02KamburUlEjQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T3DbFzf8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766704885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=m0+YWofsDRKAY2wjZda60s9Ihl0H8j0NHCydLBoURug=;
	b=VUf5rYeK7RkpC2HURYiLIL2DZy+zCKqWcCzxGhGyYt3WeaRf/rL5ReC7R1WC6OMx3afHQK
	iWE+lN6K+/lCSRkaoMzOK0LVWYQJIQ8e8QkpiMiYT7BEMDucR+PEgPx/LnfjeL/XBF66nG
	AyNlvrLWAGWpYdJYjvgByR8UPEJ/Hic=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766704882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=m0+YWofsDRKAY2wjZda60s9Ihl0H8j0NHCydLBoURug=;
	b=T3DbFzf8WZWoorj9f/pU6jPkPq5wKy1MmWb4lP3AcYeNNbID9uitveOp11zE6SDET7Qp/C
	zOvbd/uWs0Q+ifzX1cOS6jExDNhaDTgv+yOFLikLHtcZS9DXehIgavanWYuwcPELPltyOq
	7aiCehycTAj+UPz9eeoocAffxRFCBKE=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] memcg: separate private and public ID namespaces
Date: Thu, 25 Dec 2025 15:21:08 -0800
Message-ID: <20251225232116.294540-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CBEB71A000A
X-Stat-Signature: 7q35dgb6xuct1kmrggiwjeay5krkb49c
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766704884-310016
X-HE-Meta: U2FsdGVkX1+dRCDhafgqRgCzzbHJB4EccZx23XbCj2Fxw3cx/3q72KIV21dn0ln92fFpYi+KlSqkh/bR+tGJYotH1FHfVybXwtfxc11n2xFI/2OpIjEbodUBbngPavffHwy2sadQlfFAIIMeFnoeae8FIbbE7jEcTJD6o5CjIsjW55xOpobeCl2hDfKHU4HgbN3Gh9237P1hQBOWC+pZ9xzy2/QHE3X+xmAdF67Y3GwRL5UvZn8AhLT+zenGfSB3gdKwOVSBDCKq9063zqwhwLVRjNzROITWrBEnCKkp2RvBeqza/m4SYqTNDHR6CZM2YqYg/wQaRyO6jfs6VKT9fTQ+Rl1U4IHIPE4x7tgM0HrokYYrIrWk1CY7ulcaqcYCnl2mTjNBQN2RQDhIJhSrVPW0zUUr8XNy468L1cVMy9ZDZR5BIzUJviHiNbVmXxnaoZXPgyH1d2o0JTWkKgeJnRGWb4U4693vbEMi4tge2r6q7Cdj6gtwcvkUodw7eG1/M+S+oBVs4wgph6w+Abz5Skffr7DDL/DAK0fCVMsPjCaTT3l7aSDBmuiIhobNRKtJXvZq8b/1tjy8dcz+Mo7FuQ7LvPBwKNXr2gYs1+2KEGCFdZZ1toWOZBaSGne6NJM6kasTC5H5INmbL8tTXakDIHaMrOZ4At1faAcYyDXAoFEJNYBNIIBd5+dWweNU0jroGXe2MGpQetboMInUQMYm87jmzZtRYZTbVJ6f3gKdQCaG+2EAjGWJxwAvCIYm4l0N2ByWj32n3PJrzhXFB6UKwfA5+B+3tvcULB7JrU054Da/VNdRdl7SGVLhNCXLz58mC6HKzVuwc0IbBEiSs4p9QG5aJGZOca4XIS6dMyc3BYOeKQ1vydI5IAqbYqsXgZuHbsw0KUvPh582BiScHlme4OXzeL0NO0cu/NtDLl9J23dr0ZBkglRawQ1gRoetIxTDtNDPdMgiORHPPWSq19G
 irLy0B1s
 S8G1OVfS1/kqh0NrviZriOKfEGOkmjtNH71H4BhNaYElo6M6PCJS5SQ35dsj+nSGc3vLWLJWQV6LqtyjzVIHRT1lZGsOIS0VezhJWWAp3rKcYxtCgVOtrIX+l74s8OidUS5jKRagNCTDEqqSI96ICwlJo9oPk+Uchz9E/fh52g9hIhYR+SYrEMLJEPL+vMnTkozt82DDuVR6csl3RPJuVWGjHUfce5M7MoVBy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory cgroup subsystem maintains a private ID infrastructure that
is decoupled from the cgroup IDs. This private ID system exists because
some kernel objects (like swap entries and shadow entries in the
workingset code) can outlive the cgroup they were associated with.
The motivation is best described in commit 73f576c04b941 ("mm:
memcontrol: fix cgroup creation failure after many small jobs").

Unfortunately, some in-kernel users (DAMON, LRU gen debugfs interface,
shrinker debugfs) started exposing these private IDs to userspace.
This is problematic because:

1. The private IDs are internal implementation details that could change
2. Userspace already has access to cgroup IDs through the cgroup
   filesystem
3. Using different ID namespaces in different interfaces is confusing

This series cleans up the memcg ID infrastructure by:

1. Explicitly marking the private ID APIs with "private" in their names
   to make it clear they are for internal use only (swap/workingset)

2. Making the public cgroup ID APIs (mem_cgroup_id/mem_cgroup_get_from_id)
   unconditionally available

3. Converting DAMON, LRU gen, and shrinker debugfs interfaces to use
   the public cgroup IDs instead of the private IDs

4. Removing the now-unused wrapper functions and renaming the public
   APIs for clarity

After this series:
- mem_cgroup_private_id() / mem_cgroup_from_private_id() are used for
  internal kernel objects that outlive their cgroup (swap, workingset)
- mem_cgroup_id() / mem_cgroup_get_from_id() return the public cgroup ID
  (from cgroup_id()) for use in userspace-facing interfaces

Note: please apply this series after the patch at
https://lore.kernel.org/20251225002904.139543-1-shakeel.butt@linux.dev/

Shakeel Butt (8):
  memcg: introduce private id API for in-kernel users
  memcg: expose mem_cgroup_ino() and mem_cgroup_get_from_ino()
    unconditionally
  memcg: mem_cgroup_get_from_ino() returns NULL on error
  memcg: use cgroup_id() instead of cgroup_ino() for memcg ID
  mm/damon: use cgroup ID instead of private memcg ID
  mm/vmscan: use cgroup ID instead of private memcg ID in lru_gen
    interface
  memcg: remove unused mem_cgroup_id() and mem_cgroup_from_id()
  memcg: rename mem_cgroup_ino() to mem_cgroup_id()

 include/linux/damon.h      |  4 +--
 include/linux/memcontrol.h | 26 +++++++----------
 mm/damon/core.c            |  7 ++---
 mm/damon/sysfs-schemes.c   |  6 ++--
 mm/list_lru.c              |  2 +-
 mm/memcontrol-v1.c         |  6 ++--
 mm/memcontrol-v1.h         |  4 +--
 mm/memcontrol.c            | 60 ++++++++++++++++++--------------------
 mm/shrinker_debug.c        | 13 +++++----
 mm/vmscan.c                | 17 ++++-------
 mm/workingset.c            |  8 ++---
 11 files changed, 68 insertions(+), 85 deletions(-)

--
2.47.3


