Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 376CBC5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373306B0098; Thu,  6 Aug 2026 15:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3238F6B009F; Thu,  6 Aug 2026 15:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261C26B00A3; Thu,  6 Aug 2026 15:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 094416B0098
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:32:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93D37A0F20
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:32:33 +0000 (UTC)
X-FDA: 85071841386.13.D930CB1
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4F7CC8000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:32:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786044752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=XLlN1ovzTjhAxFTGUf8Dk3R8hkqV+QyGLVCYzczqdq8=;
	b=SzTExUjQ3gOHZoQQUqkL2ylGePh74o8qttK4wnylVJSQrg/qM3AvZCPIgq3yPTO6L2+V9B
	XtXm9jhm4Hyp97YegVstSaW24hj0nwtskukdvfJqO5+6W01I0/2c0S+s2e6Vs2zlfS6ZIt
	q8chN0D02t8vWJeEKs9LJUdWXWqo14s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786044752;
	b=OzBGYrN4X66zCT/U3VhMrhudFMr3Q4qCk11N4QJuRHwY8d9acDmnLxyKp7d2X57r0jErL6
	v8QgSzn6G6odskDfTSmA8UDzKD6InhVjsWROM580MnN/x6N4Wcv2xaT2p/gz/s0h+/mrWB
	jIN0P73mrdq7aC0979IdMZ/2J/lOirM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 7 Aug 2026 04:32:28 +0900
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
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] mm/swap: skip empty clusters in the swapoff scan
Date: Fri,  7 Aug 2026 04:32:26 +0900
Message-Id: <20260806193228.458685-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F7CC8000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ohtyu6oig8yojin76ruf3hnamoap3naj
X-HE-Tag: 1786044751-363793
X-HE-Meta: U2FsdGVkX19mer7MjFte56EROTfU1LvkHT1xhAUdV5VhWdSwgi9Uwcr3A+yF2h1BYgoYPvUUx6wpKJqodY7/RjY+/RG2rP9KBB81xmlLm1N238hh2pwqfMxr+hbcYsFCZu8ltLx612O53uJoGhZyZJHl0Zgg5cfHpkRdP21BybHeThSw1SYpu0z8IzPfcDlqC6Zl7w5ykrdcGBvtz57xhQix8OBsZe6OGE8uHNPvCZIdJ6B1/mRjTpfqSfXOqevccnmaCSoDrZWmmBTxOnal/yLV2r1rfhCMdUtOlKwSzbLpA8lxSAzPD+xuiQbGR7GCeap1MizUJrCtTxDlEpOasPdEklwJFffRJfrboz9mY7/n6HVVduFqlXN6Bmtog0sA6NudHrBH3yStCvSPjepA2jzsX1cK3k0ftGEd0j/Csg1gX9R2hilfceKSxe1lEq15efpTrYzf7M4DZRb3Ilj7YFqn3GgXlxKHAlJ8WjqZIzsAOYolDTS8d6scQA/wZfcmUgGHKo9itJrm+c8kYisFNKxuJie2fu7jfaYGQ7RYnQhEIsYOGwntHj6Pd7NyD1Dfu6waQvnmzv6hKeXIqLf57RDlDYUVa2n3J1BgV6VM9zTMKUgkuRerwFNmKfVCQSJ0jX5jQetR0zpXtzAsvVg2l/ivUiypSwux9h3GLl1j+e314okJR3ZHCOjTVPFNAn7zQ2AqtigduGBQx8QyjMAkTpmH4/f+gkPpYu+CviuwdIzsKu9PfMTJpZAU4BLF6z0gL1SKs2MfiID6ULT/VZsfEVN8OptWpQpWN7vM4n/medho2p8ARwm8v7ouo6uSr+MUM5b+Lxj3NwWJSCecEydw56ns8TrjIYxTRKfQ6UuMJgYu4JD2gMN5/ZKJbd7e4hf00Vnfhl8mekaVACYhGW40aoXJaVIK0y41bw3+jfgAoWGI3gJl4F34PMd4OABwj2cKV4/9BJke6MnYmBggv7h
 v6+/SPgm
 1ntwig0L5hg5E9uTw1VGWAoOm0CtBZCuLGLHhYsio3rcF+dkj4aKYHF9pK0iTE3uK0smblVqX32VQym/AZccg7obLCbEA3RtDrllbB3BpVEbHeNdgOOQty6SYx7y1ILCzwEQSbHR/2kWDgRtIy+t+ztYK+nCidqND1WRQRruMpGE1x/e7qWVi4wgqbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

find_next_to_unuse() walks a swap device one offset at a time.  Slot
state now lives in a per cluster swap table, so patch 2 dismisses an
empty cluster with one counter read instead of SWAPFILE_CLUSTER table
reads.

Patch 1 is an unrelated one line comment fix noticed on the way.

A debug test confirmed the skip path runs, and swapoff completed
under load with no DEBUG_VM or lockdep splats.

Changes in v3:
- 2/2: clamp the scan end with min_t() so it stops at si->max, rather
  than running into the masked tail of the last cluster, which drops the
  need to explain why walking that tail was safe (Barry)
- 2/2: compute ci_off only where it is used
- 1/2, 2/2: pick up Barry's Reviewed-by
- Rebased on mm-new
- Link to v2: https://lore.kernel.org/r/20260805141146.127776-1-youngjun.park@lge.com

Changes in v2:
- 1/2: reword the comment to "array, one entry per cluster", dropping
  the redundant "on every device" (Barry)
- 1/2: pick up Kairui's Acked-by
- 2/2: drop the min(), the swap table is always SWAPFILE_CLUSTER entries
  and swapon() masks the tail past si->max as bad (Kairui)
- 2/2: mark the unlocked ci->count read with READ_ONCE() for KCSAN
  instead of cluster_is_empty(), whose other callers hold ci->lock
  (Kairui)
- 2/2: expand the commit message to cover both of the above
- Rebased on mm-new
- Link to v1: https://lore.kernel.org/r/20260728155907.391820-1-youngjun.park@lge.com

Youngjun Park (2):
  mm/swap: fix stale comment on swap_info_struct::cluster_info
  mm/swap: scan by cluster in find_next_to_unuse()

 include/linux/swap.h |  2 +-
 mm/swapfile.c        | 43 ++++++++++++++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 14 deletions(-)


base-commit: 1fb556c523f6c18b43b1f52fb366f61c9963ce06
-- 
2.48.1


