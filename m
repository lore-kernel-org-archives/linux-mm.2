Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87415C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69DF86B007B; Tue, 11 Aug 2026 09:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674B66B008C; Tue, 11 Aug 2026 09:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0E96B0092; Tue, 11 Aug 2026 09:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 377616B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:22:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE79FC040D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:22:18 +0000 (UTC)
X-FDA: 85089052356.11.B78DB51
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf19.hostedemail.com (Postfix) with ESMTP id 26AC81A0003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:22:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786454537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=h2bAH1uCXoiqNn8MSa1/7sIiiMw7LPDGGCt4rZ+vW3c=;
	b=upe2fxKToKZxDzX7MxewGW4CunrjLkhw0zu9jWuP5cEkmp3HJrE7b2wD8AzSVffe7GJZyH
	kbjZxApLZt/qtsP2FOkf8+t5WivtZZ93toa6qT8kiI57tr0vmMP8hP4djwc0lpLtrkf5oo
	zOrk24NYX91oNcDH0X+cFaWJxECSlGA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786454537;
	b=a8TuYUYb5XfFtIoJ2akVtP5+CPqIgbD7GV2r3aKmU7ulrDJ7XVhnTB5J1a+i93Vgw+k0sF
	XmjS0u4fXtMBmq8XWFZ9X/XiZZI4C+nPte3N42YPxXxRHXzI7IT2gUoXMykWc9qZAPWaK8
	VkvSVvpkJAeI/OTEu9dbdQKRoyPQygA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 11 Aug 2026 22:22:11 +0900
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
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Youngjun Park <youngjun.park@lge.com>
Subject: [PATCH v3 0/4] mm, swap: keep hibernation swap slots out of the swap cache
Date: Tue, 11 Aug 2026 22:22:05 +0900
Message-Id: <20260811132209.2862708-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ti4k4kj97y3mgbdzirdmdcm5585tiri3
X-Rspamd-Queue-Id: 26AC81A0003
X-HE-Tag: 1786454535-759212
X-HE-Meta: U2FsdGVkX18tYeXAp9RTI8cXY8gAEGrm5M06izw2dzYOTKeryapVLqNXYR3tYEkzf8AmONWGHIXC1hzyXoJwmwq0h5MttVYRRE3/dJhd0URndQraXyLkyLSTawGtkcNCxySugU3wHtoA0RCN51ldGBKZY9Yx9T6D7J1Jcw0PqcTWLf15t/9QznpP8S3CQsGXXXEm7TPSUWUGC+X6ogvKTxcXxD4fv5t2f8b15dKvTQ8QuVszKjXxoGWhL8RGbl9MhaupOj2hMnjZldcagf2FfQ1cWyYIh0eycf7ZMF8qZvhRmx0LsnBnxnwW3QQzityLitKtGUHVie+5sIwS6NiS0w1ydiyx8xYzOllIRCdzb5ZR5H7KUjCkD6JJZk2hjsthR75J2iinuu15SL8xlFklbAwoL9u4+Skb1IdWYfJ0MVWngzzeTRpB2RGZwJqBFJnqzhmNAiZWMZK8WC4cGHHd8ohLbId/kBd8bcwTjO64F9qJk55VEJo0q9yI9nft8wyrOw6nFAx/ymsUzS3deffwtYTqYDs3uh1Zz1BMs36VjKZhmPWNz5xbeSFrcyPk5K9cSZ1+x1rwVJh+0u9WCHUJUOnK1/pDfnOgsyy4xSfUNvI0DXFYykS4yTO7FAJ4PCw4S83QxoPuz0gkyVZI+ofxX6JdERsygc2ThRInzX3Qmg9evtj0lEyqZ4bFsl44vKUTKxpUlx5azD8NKqrMrNy5uROJJRZeRedtFhFLstkuokKcQpoUtOvCU0oYskt04Lt23VpzhUCbtrhlIRPw2neOgX8Oq79PoYXnT68NuKIhDTnoEZfHhY3kwCMuWmsmpuHeAWqGE+DX3jz7SwVuH3VzC67T7C3g/W3izk6+3U4i5MUAY4jMDcngFHKY9AxGWAc4ejArRKAv1dQy4b+qmIHm2e1+h07le3UDrgbenUlk5TVdrxU78v3sfpqJC4/g5P/iw0V8Z7qh6kaDeIuJLuO
 H6Xjrcqx
 d/QhuYFj7FsSD+JhcdPBhYs+KdNzS18c+K3vjUy4Otr+O/mD2k5gZjCRdxMtyu90H2S5xhcwPANr6ziF7VIlBSwsERAXoqrC15CIq35+xxvdENnaoB78O+ctkwZ5BeaZEEsQzcl5r9PsD633iPk5vhmLqDA9DkWXtA84wazOl3O4vPAf7H0XPs7V9yQ==
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

v2: https://lore.kernel.org/linux-mm/20260809144559.2104856-1-youngjun.park@lge.com/
v1: https://lore.kernel.org/linux-mm/20260806190636.446205-1-youngjun.park@lge.com/

Changes since v2:

- Give the large folio walk in __swap_cache_add_check() the same shadow
  test, pointed at by the AI review Andrew linked.  No bad slot can be
  in that range, but a slot freed and then taken by hibernation could
  trip the countable assertion there
- Picked up Kairui's ack on patch 2, given before the walk change
- Rebased onto mm-new

Youngjun Park (4):
  mm, swap: don't free a hibernation slot that is in the swap cache
  mm, swap: only allow swapped-out slots into the swap cache
  mm, swap: give hibernation swap slots their own swap table entry type
  mm, swap: drop the swap cache guard and reclaim in
    swap_free_hibernation_slot()

 mm/swap_state.c | 11 ++++++++---
 mm/swap_table.h | 13 +++++++++++++
 mm/swapfile.c   | 16 +++++++---------
 3 files changed, 28 insertions(+), 12 deletions(-)


base-commit: 480a31230b426efb005b6e71a14ef80f405f18b6
-- 
2.48.1


