Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26BA606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fAtHMJCT
Received: by kanga.kvack.org (Postfix)
	id 3B4586B05CF; Tue,  3 Nov 2026 11:25:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392C56B05D1; Tue,  3 Nov 2026 11:25:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254406B05D2; Tue,  3 Nov 2026 11:25:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4A236B05CF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:25:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4EF901A02DD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:52 +0000 (UTC)
X-FDA: 85394334144.01.7DA932A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0896A180003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fAtHMJCT;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793723150;
	b=C3RMV3i3fbPHLZM3B1qbIeQ0xwkudmZZbwDWPt56kzUqzY3NaQV+AQF00jjWQZ85ntoBmw
	mTsyRIq6bMew1hBaZ3/G2SVIvRyJ1jEjKrb/tLxK0kEwpHdKjTW6iB3EQnyIesClLAgm1N
	Ah10BLxPfGRJJZrNc0wXljEcksENhZM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723150;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YrvLenOfUjR4xjaCoygKbKHPvPlEFGRZPhOnPcpMtlI=;
	b=OUYnyTdgA/jkUTF9+l+Y7rG6KonOWL4GNtOBbVRp1qcN7894OJ8ij8MYIuTF9YtzNDCpbo
	TarV81IxxOCmI+3JxUUOuWL2OjGxBd+dG4TtAu1CcBrD+qWk4fmxfHkfXs3rcG4kjM7LNN
	n5DxoQiL8PqdcKAsTt9ti5fCDnJ1ujc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fAtHMJCT;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5942943875;
	Tue,  3 Nov 2026 16:25:49 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793723149;
	b=nOLT4jsZ0ggSgMevBeG/YvkQOz8HSWtgfgZ/q8UG4XOPBhYgkw5scqnoXk/BcW48nC44
	 iYgV21K7qeVSjcryxa1bPgNzUOfY301WzdHCSafGHAnGhQoR+xdrO2xicgqOQszDOebgc
	 DrFosH177DYw7zV1RA9qRPdrjzXTo0iuGCjkLORBdVQy23ncWeuPkY881N+lYHrmb5810
	 kXvCXmOaLr7Qkx9gnU4uK0x5UJYiuNOvVhRxiOh9DkhTd2Jp8EYuNvZ3HBbltfFLdVmc4
	 WvgBr5PWQC2LvCyV8j/cXvS9CDyT1/zAqQvgVqIcCkOlaplZGwdk6LidqcWmr4SnHxQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793723149;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=YrvLenOfUjR4xjaCoygKbKHPvPlEFGRZPhOnPcpMtlI=;
	b=jv2er5w6TZfQGMpEfpTzoHVRUroo+jyOzxCbHNYQD5gW2e8Zz4c6usGzKrfRAonlQOkF
	 XD1+n4UcZ291YiIO1tAYYaVAn5oGby1eVN64QRplw5xYUSIqwDCq0czMhOd2ZQFhkyxiY
	 71iBKY3VftqflDpjW1EPeynyaz6AlG5bfEMZJNKF4GoE+KFfoSdt5sJ/R9FP0lfS9auB2
	 xVqOofUxstEkrLkFa65oMrxsMJGupFWBmJn1KBSfoCIKSEIx6vwLM1QwK8jO/txHJrLKI
	 r3Y/xJQcKzbU35hSS1qrbCVMPdPn2pBybPPtLTuqg42jUcsuULfmTWZjVGyITu0VtWg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C8D6D1F00A02;
	Tue,  3 Nov 2026 16:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723149;
	bh=YrvLenOfUjR4xjaCoygKbKHPvPlEFGRZPhOnPcpMtlI=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=fAtHMJCT1hpoD6RUCO03ORkfT3COYww7VWDwzMTSBEl+iIFeRXcdpHqWer+Yor2/7
	 EdAEeA2RmhwZB+oLTmC6VGpig+BPy5PPu/71eEv31nPi4v8dT7bWFI0bfmcy8NBGrX
	 CNf/qhCnWTcPEu+oEV3cwpGncnpbTet4SOOC5QSRZGvJU2gpLhETZ++qZtO5t5Uygq
	 RB8Od3xXbbDf34el6f8h3VZpTJOlVJTZRlmJYS11Yfebt8Wc/Lo3je6Jv9PMXNyGYw
	 Ls4ug+YW6iyB8vNO4Cp2lyg8iKGJNtOwhm+iuygETU5Kv2EqjCYx2iw0ttfAn9vyZ2
	 GgSH8pkpeKCDA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 24C9C46A22;
	Tue,  3 Nov 2026 16:25:47 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v4 0/3] mm, swap: keep hibernation swap slots out of the
 swap cache
Date: Wed, 04 Nov 2026 00:25:44 +0800
Message-Id: <20261104-swap-hibernation-slots-v4-0-0ba9393609e1@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWNwQ6CMBAFf8Xs2ZK2KIIn/8NwKLCFIrakW1BC+
 HcLHieZN28FQm+Q4H5aweNsyDgb4XI+Qd0p2yIzTWSQXGZC8JTRR42sMxV6q0KUGQ0uELsWOpM
 3nTVFoyGOR4/afI/ws/wzTVWPddhru9EZCs4vx/Oc7t5xwnMhRColLxKZxyTPmWCLm2zbTzYZl
 X89hhaT2r2h3LbtB0oV1c7BAAAA
X-Change-ID: 20261103-swap-hibernation-slots-59f627f6d9df
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Jianyue Wu <wujianyue000@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793723146; l=4307;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=R6H98dXtxG2Z2jromolKwbcKkJz42BJ5UcLj3L7np7k=;
 b=pCZlUKbzxhlgH5oldMolUwrYC95wl6NeIpN6alMrW4KT/RIxnUUNta7Gs+Bq63C1qEybExxRQ
 wheQielJf2iCXKl+H4uQiHjhNWxIfXv6K9pghFGGSHvvMktsqklSeWq
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: o5chuwf9rcq5kmf3zk5eecinjae3huru
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0896A180003
X-HE-Tag: 1793723149-354265
X-HE-Meta: U2FsdGVkX18TMWlmQMJcXxBtj30iRUK0fJaX7K/gLf45m6qyEn4hlhPWgRMjrpISmF8F7d0MUPMOl8iG7o0+WnrZXj70FD2D5lYTeeTzG17fBSefdxdwn22gIGCG6SwnNMvGaky+qZ4F4TVAyVD+Ud3/+j85/k/dOyJ1FurrnsRdpvrkupPo0N1LOMg14NDT3GE9+xrg33DX87voujnL2Shj0ZnNfCd6ciM7/e0d1etza8MniZuahm9H1S5xZXozG93GmioSbYriR+rjXtRTO5yvAkqxd+xDHFH46DPJF11rybWoPmGBzk/VtGsGorm61tXCkDx5gzlvswh2bfC1sbyaV4iX1GnyZyMab7GNotEUWSYnwVd/saVLl+NQKULY4AB8aWPmFYDjfSEJiID3cpauq7n6owKgnt0zazYQjJ4ZhRMjLbLBj2DCDqPeMt6tb98mKbJaW68Himi7dDEzLOmRSumELbtJgo+M5xIbUDVkCFGc76h1oD6A2N4/ALEScf8m6+Tq8/hgBbf6bYxr3yj30yFewEhADKrUWZLM6wZP0uN2vUtgf1I7xlQvVh+MAAGvXUVdU+X1KmCTNhq6j/MB/fbfK5d4mLwvpOgX8Eurv39Nkh0hIJRjpCYnuFVagPUKeN6vc7PbY2c2/7aWfU7Gj7IAqbZKKGFzSlrNVzi0XwMgnQR0E3spi4PhVGOFsf/vxRBqGjCpxOlkvWZSu/mAGWAgZdE+0rwKif5hJJqypqs5iazTKeLF3PohxAcg2XzqaSEY57rHUy+YOqcV1XiAu44L9rJGFA9hKeqYG4ykhyylM/9PEvqpzK5iMzHN/KxJ7poGuT3qOYG9DHo4QNOabxbilxn6qksyE8N25WySvPRkpG5tXMFfADthy9VlSTZBbRFsiP805TxUEJKXedhVsFNWduK6hX6vsrq9HGkfHZbcgfYwkOFsu6sxiFejy441KSmiFVtp84s4GGJ
 6hHOXIm5
 UF/en9HIto1iWOFRN5oVm9T6QhGiLOVf+IUQQfO2GizZ6LIXVglItzIKocM1e9sJQb2onvWd7lwJY5ulDWqgVwMqa+YG8rxWZB+jiqkbSOpZfN4BptvHscqTdtxe9SETUdOAZ/odvrYJlfDZmLqjQrxB4sg8C4IWJtvIEDeDgTvJETsem0QpjgudkgD83quT5eIXPxJeiVBQlpRKDakM6xv1oIbqehnhhbLN0L8SXipU2m2LXODuPgY3tP4STAIPNlACvrjTPyfhDvEeUMjp54OdzOUZZd+MFWhPG1Af8qc8Rxahm5KAjKyPoAd/9JV000xz+pv398Stobj3NpizXgVQayRpn60AqDgMu7JDQVFmJFViIRnmMgZ1KYabBfeHuiM3ez+7N8vGZzcgvVyiWiCZOLOLlZgCxn4PfyuCzLN/cpgrXzE97wdV0Yekbu7lyFKZmB6xt+qU//4E2yqT0jYzkYft6ltaOhIBTNKQWWPmOvVSKrbgycP8kavHXcZVgN+dYxbW23b6RkIOog/SL37FqIHI4yBkT3s2DEKFfxIXPyBh+pPgQ+It9UDPlYxBHsO5i4ykIkI4oTxHTxtAEfzhWp/rjehuqcrBzfDoa+Xyhtx5hqHp0GaKP20h2tlOASbjQwmUgvgLM1ZLLAXygOM17UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The original series is sent by YoungJun, now with a few nits fixed,
rebased and re-send, dropping already merged one. Especially recently
there is LLM code inspecting suggesting patch 1/3 of this resent is
needed as it avoids reading into bad slots.

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

That one is fixed in v3 1/4, which is upstream as commit 10d9012e83ef
("mm, swap: don't free a hibernation slot that is in the swap cache")
already.

What is left removes the cause.  Readahead should not touch these slots at
all, so patch 1 lets only swapped out slots into the swap cache, which also
puts back a bad slot check the swap cache rework dropped, patch 2 gives
hibernation slots their own swap table entry type so that check covers them
too, and patch 3 drops the guard and the reclaim in
swap_free_hibernation_slot(), since no such folio can exist any more.

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

                                unpatched   fix only   this series
  hibernation slots allocated       2732       2732         2732
  readahead landed on the slot      2731       2731         2731
  admitted to the swap cache        2731       2731            0
  reclaim found the folio              0       2731            -
  slot left unfreed                    0          0            0
  VM_WARN in the free path          2731          0            0

The VM_WARN is the existing assertion in __swap_cluster_free_entries(),
not something the debug patch adds.

Changes in v4:
- Drop the hibernation slot free fix, it is upstream since v7.3
  (10d9012e83ef).  This revision is the three follow-ups only
- Rename the swap table layout entry to HIB and reword its doc, pointed out
  in the v3 review
- Rebased onto mm-unstable
- Link to v3: https://patch.msgid.link/20260811132209.2862708-1-youngjun.park@lge.com

v3: https://lore.kernel.org/20260811132209.2862708-1-youngjun.park@lge.com
v2: https://lore.kernel.org/linux-mm/20260809144559.2104856-1-youngjun.park@lge.com/
v1: https://lore.kernel.org/linux-mm/20260806190636.446205-1-youngjun.park@lge.com/

Signed-off-by: Kairui Song <kasong@tencent.com>
---
Youngjun Park (3):
      mm, swap: only allow swapped-out slots into the swap cache
      mm, swap: give hibernation swap slots their own swap table entry type
      mm, swap: drop the swap cache guard and reclaim in swap_free_hibernation_slot()

 mm/swap_state.c | 11 ++++++++---
 mm/swap_table.h | 14 ++++++++++++++
 mm/swapfile.c   | 25 ++++++++-----------------
 3 files changed, 30 insertions(+), 20 deletions(-)
---
base-commit: 0ea6dc8c4a2192227ec25768625686b8fcd5cb09
change-id: 20261103-swap-hibernation-slots-59f627f6d9df

Best regards,
--  
Kairui Song <kasong@tencent.com>



