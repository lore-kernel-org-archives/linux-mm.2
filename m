Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A73CC5AD4E
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 14:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A11E6B008C; Sun,  9 Aug 2026 10:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450E96B0092; Sun,  9 Aug 2026 10:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33F426B0093; Sun,  9 Aug 2026 10:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E643B6B008C
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 10:46:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D388BA2732
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:46:34 +0000 (UTC)
X-FDA: 85082007108.13.0A91EB0
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf19.hostedemail.com (Postfix) with ESMTP id D2D8F1A0006
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:46:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786286793;
	b=XoUXq8ZYTnCcNMW6xyaoCsfFFP4161sOkQND31DKYAvxaoc6l8Rojvy3JlL2fYpd3I9VgE
	e5v799myKG1iH3gMyH1PqjVZ0TuP/fW3GZYgEpiGvVyhLBKK6PX9lcTTza/5Whpq4BC40m
	iTx5u232eKpjRv99Bo6llgtTAQeD6gs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786286793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=D7avGwiC0/xG51DkkcLpP79yGEWfx5LYeHR9qotbsoE=;
	b=206ZQH6eUyZ9JR/G+HqspbVBIfVwKWaKthdagkfVvU3EdLuAAcQ38/aV91KYePEUfAR6kB
	fnPZHg+QFSQGt/m60LpO+yJLdx9gbz659PKtE8RFs8TP4RTh4j88cL2lMUXD+8+Yz202Wr
	J9f703ClkJ8iQBOXnldZEnQOYctZxCY=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 9 Aug 2026 23:46:27 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Jianyue Wu <wujianyue000@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] mm, swap: keep hibernation swap slots out of the swap cache
Date: Sun,  9 Aug 2026 23:45:55 +0900
Message-Id: <20260809144559.2104856-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D2D8F1A0006
X-Stat-Signature: rq7jc8ihoknf1j6gdwsoq5jqgg4oqi6n
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786286791-71186
X-HE-Meta: U2FsdGVkX1+sStWX7DafDQZQrtSMU2CZQKdCDXloImwDdaJ2zpI8AyDj1Tn/1GGpw6yCKDtM7jVX/9zOlaycph9jGjfUdUFgA3KZa98Fv6xr7ik+lRYsmxoYua88b1KcSHpuFIeNGkEIFlhHxzrmRNyN263KMhuZPJSvDBto24jNZBb8Ryeb+TbWPnkcSVOlm3jav9G91wqlVU/ozpZx93zy5sX9vJ/uJ1JraX99gtmLkdwoMvcTRA0QHEz1c9B2k1+i4e1bPGc1PMq2Bb27gdjBVI3gK4DI+btpIhoveg/uwHn82G7zlf0Jdgt+OO7GNsUkY3yoHhAl9SCdvRKUsz00hl2IAmpruh4opoQx+3SnuKkRNEvRrXPGMRKuAQ3vEGl6cvLTCZTLYCpUgkNf8C1u9/TFA+tHA8ETBYOw85B3qFgwQ/pFGuQVFbNVKr2Fr6+9no+7Pkmr5GcxwrP8UxPWkGkXiFfAJQNT9Sw3WA27inWVBPjigNNYygsII/LVon0wvqXYavVpgyOAa4sp/Boc0Bxo+FEzQB421mmXUofcKtvxXruGuc5cGmgEh6dZvKeYqqrM5MdjsWHun4/DPncS7BXYAXR92lDVmalBaKZDIXidMH/KbvA5Sj4+I99LlpmaOi9xgF/cmu8N9qzTBNA+3lfkrRUmt4DHxywfUHa1+VvO+QCBZGyCdfdR4ysSR/DoBFZr9EcyHfLJA9lTuJBGoiVNDrHKmoSPYER8X/1OKSqiwKL4KywHdoYUKfDzpqcK125dbd3xSeHTk619DJPWvcuL0YvnK9YF0yzBwRfK7lSsVGW8CO4scTy4vAvhQauRYsTXkgBM9ESXf8NHks4XteImWeVI0JwJXAnOLtA/Brj1uH58lO6uyDfZtPqVWKvboviW3/jwVGZlZDwQW6J7IgRITcOkHZ082aaczjJaDeCxiKn1U3hpA0qhjBqaJg+WrFEb9PVA+srTPKQ
 LT3wW8sy
 RcRv5suRyJjdfL2Ym78CGNaqvpLGubt9cnECXQLa711UNO/4UCaTbW3dtcWFJorkCp3tQlTIFvBSJFn2VVESUsvckil9nfxJ0FnHewhpvIpsPVPc6beuG+5moZrwNNrpYvgbt03OyKSrkuON3CYNsd6akT0A5zZ270E9OXICOTxKiDXG292zL/G9quw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cluster readahead walks a raw page_cluster sized window of offsets around
the faulting entry.  A hibernation slot looks like an ordinary swapped out
slot, so __swap_cache_add_check() lets it in.  Readahead reads the offset
off the device into a folio and puts that folio in the swap table where the
hibernation entry was.  This has been possible for a long time.  It only
wasted a folio and a read.

That changed with commit 0d6af9bcf383 ("mm, swap: use the swap table to
track the swap count").  A slot with a folio in the swap cache should only
be freed when the folio leaves the cache.  swap_put_entries_cluster() still
does that, but the conversion left swap_free_hibernation_slot() freeing the
slot either way.  Nothing points at the folio after that, and when reclaim
drops it later, it writes to the table entry at the old offset, which
someone else may own by then.

Patch 1 is the fix and the only patch for stable.  It puts the missing
check back, so both free paths behave the same again.

The rest removes the cause.  Readahead should not touch these slots at all,
so patch 2 lets only swapped out slots into the swap cache, which also puts
back a bad slot check the swap cache rework dropped, patch 3 gives
hibernation slots their own swap table entry type so that check covers them
too, and patch 4 drops the guard and the reclaim, since no such folio can
exist any more.

For any of this a task has to hold hibernation slots while the system is
still running.  The in kernel path does not, it allocates, writes and frees
the slots with everything frozen.  Userspace hibernation is different.  The
process writing the image is not frozen, and SNAPSHOT_ALLOC_SWAP_PAGE does
not check that anything is frozen.  The swap device must also not be
SWP_SYNCHRONOUS_IO, or swapin takes the direct path and never reaches
cluster readahead.

Tested with a debug patch generated by AI that counts hibernation slots
through the swap cache paths.  virtio-blk swap, page-cluster 3,
SNAPSHOT_ALLOC_SWAP_PAGE interleaved with MADV_PAGEOUT of a shmem region
so the hibernation slots land in the readahead windows.

                                unpatched   +patch 1   patches 1-4
  hibernation slots allocated       2732       2732         2732
  readahead landed on the slot      2731       2731         2731
  admitted to the swap cache        2731       2731            0
  reclaim found the folio              0       2731            -
  slot left unfreed                    0          0            0
  VM_WARN in the free path          2731          0            0

The VM_WARN is the existing assertion in __swap_cluster_free_entries(),
not something the debug patch adds.

v1: https://lore.kernel.org/linux-mm/20260806190636.446205-1-youngjun.park@lge.com/

Changes since v1:

- Cc stable and Kairui's ack on patch 1
- Reordered, the swap cache check is now patch 2, so the hibernation type
  is turned away from the commit that adds it
- Patch 2 gained a Fixes tag, the bad slot half is a regression.  No
  stable Cc, that commit is only in v7.2-rc
- SWP_TB_HIB keeps its count field at 0 (Kairui)

Youngjun Park (4):
  mm, swap: don't free a hibernation slot that is in the swap cache
  mm, swap: give hibernation swap slots their own swap table entry type
  mm, swap: only allow swapped-out slots into the swap cache
  mm, swap: drop the swap cache guard and reclaim in
    swap_free_hibernation_slot()

 mm/swap_state.c |  9 +++++++--
 mm/swap_table.h | 13 +++++++++++++
 mm/swapfile.c   | 16 +++++++---------
 3 files changed, 27 insertions(+), 11 deletions(-)


base-commit: 0b53bff4fa05ff0d3ffbd3d3bb10fae69dfab498
-- 
2.48.1


