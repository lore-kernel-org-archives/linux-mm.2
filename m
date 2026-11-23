Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D7B606A687
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KluVWlhA
Received: by kanga.kvack.org (Postfix)
	id 9DE136B05B1; Mon, 23 Nov 2026 14:55:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986FC6B05B4; Mon, 23 Nov 2026 14:55:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F096B05B5; Mon, 23 Nov 2026 14:55:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3336B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:55:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 439121A0634
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:55:06 +0000 (UTC)
X-FDA: 85467437412.29.4DFBAAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 08E321C0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:55:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KluVWlhA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+samridh.modal.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+samridh.modal.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795463704;
	b=0BCuznyr8/5DhVgq3LhnvDiMGsokvfuTy+j1b77CRj25gXCNb297DFzqApMBEgvJrcxUZZ
	Q8vaGUnnfqMEu838f8C3fArpqigs04/Q146P7HaKcUuSB3MhWvmTv2DLAMRHykqQZZ6yIJ
	L1evZDlbBge8UhrUnK8sVblk5r1mwJE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463704;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eWUWFxVepb4D7hTC4wy3oVHuVPV1UHqMcMs5ZrhqlbE=;
	b=LNSwe33kYzXtHXFh4MDxN77x4hPsRHCExOee+w842ySuupTcdmv9d5WXI9siZRQPsgM3Xl
	a+CjG7hPNaQp2HE+/OCZITsI7oqXmqr1PYwp1/ZfcGbV2Y2QlLGlsVoUzwCZU6bbSWj/RY
	PDUbYqpoTHORx+8kwRtmRT/Ap5oSzEA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KluVWlhA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+samridh.modal.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+samridh.modal.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E29644739;
	Mon, 23 Nov 2026 19:55:03 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795463703;
	b=Ib5fAJYkC586pQSoDqTDZmDSGEyL9KBZvH9P9MbAzaEO04wO6sfq8BkQAVjmajMjd7Az
	 h/k5Y0wEpVlwhmFVN37e5EBlmEHdOTTImqt5mfOOJWvHQW4rCbHogdHIzMKBoIBMrCo8R
	 /BMg/qWs0adPP/oO19/f1Z1pq29/qfqeI/JTshxhoc+/UWxUil/bUlE68V+6HPtZQoacg
	 vEwEhmfv3YXB8NQl8d1MpoD88bxyKQYs7W0XK0BKEeS/K7ZKyZ2077DO7Y2wX2jy//NoS
	 NLm+gaYyOez/c1VsWPUMkcT4I3HRAaJLjiTwhELGUnYqZVJKkqT54idlsK5gkPNJwFw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795463703;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=eWUWFxVepb4D7hTC4wy3oVHuVPV1UHqMcMs5ZrhqlbE=;
	b=obuUhf3FQPAdswF6ylECJl3G48il9QFsU8rCTElrIXaz5T152a+hI++PfiJNN4uIYr7Q
	 LO3AsS3bxgUw8zD+h/eIbmF+AiNVekvgP5tjjO0MjPcoE/lmBv6ryqClYaODCSa71jpsa
	 Esfi7HZDGE9cZskrKEwQHaofipKSZJiOMfMXWwDxN3oLYKE6PKHMBsuZQOdUN8xPFwfNS
	 08VfGO063F7iIxjPo6iUK+yXxJZ7iPcZAyBHZ/wTsnlNAfluuQQoDfG/4Ywz5nk9/yv1V
	 suYDONCezbFoolj1B6iBsKpLpVTWQ1P1258Mlpcf0I6Kyjz51firKQdqfGdKX9UM2Nw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DE28E1F000C0;
	Mon, 23 Nov 2026 19:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795463703;
	bh=eWUWFxVepb4D7hTC4wy3oVHuVPV1UHqMcMs5ZrhqlbE=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=KluVWlhA9PZj/fVzWKTiqnlx7wIXhomQipoWkrPf2eBiKRkxC1WNc4nlNoqppEsyB
	 oCHh+y80SkS6y4k9qJWxzkufsxJeq276QuE088p2zF3bhfJUGpuEMykhyL9XT/rjs/
	 mxBoyClKXcdz8WYercEtfXftR/OzBUs+lX9xJn8GpkaGQAyj5nhU+plE9U+Li7h8Uk
	 Jc+oQO5E8LUuZ24kXviolICUn5dfc453y1GJbLPrsNz2r5FotdPw1UITse+EOFeCMc
	 TtPq6a0luO4ICrW6tvjFreIpHIOzHMV+E3OBtz7Y7vcghTdEjXg1CQ1iTBfhHuuQjO
	 dDVkQ1Rc1Hv5A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3BE8F4C684;
	Mon, 23 Nov 2026 19:54:51 +0000 (UTC)
From: Samridh via B4 Relay <devnull+samridh.modal.com@kernel.org>
Date: Mon, 23 Nov 2026 19:54:44 +0000
Subject: [PATCH v3] mm/shmem: avoid zeroing new folios twice with
 init_on_alloc=1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261123-samridh-shmem-send-v3-1-afc6a40bc187@modal.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/32NQQ7CIBBFr9KwFlOmsaWuvIdxQWEQjBQDlWia3
 l2omy6MmdVL/rw3k4jBYiTHaiYBk43WjxmaXUWkEeMVqVWZCdTQMsY6GoULVhkajUNHI46K9lq
 B4tAw5Ejy4yOgtq9Ver58OT6HG8qpmMrC2Dj58F6riZXd30BiNN/A+07rQwuqPzmvxH0vvSMlk
 GCr4D8VkBUaUNRs0JJ1fKtYluUDWdpTfAkBAAA=
X-Change-ID: 20261117-samridh-shmem-send-9fd2d8231e8e
To: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Samridh <samridh@modal.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795463691; l=2736;
 i=samridh@modal.com; s=20261117; h=from:subject:message-id;
 bh=cB/X49bEfE/YxcJEqpPRK906snRfTv9QZQXwDDpM5iE=;
 b=X7wVMmGKz2duhlMnJ04dtKau0IR8o6b1Ll9s74xW0fdxBH9twRT/0YfQ2a17/8K0DQ5WSQwi+
 YgdAKfD3sxwDryqlYQJ+siJqBn8QdQwCWuav/MgO5qy373b6KQmohSj
X-Developer-Key: i=samridh@modal.com; a=ed25519;
 pk=+V5ZaIpEMOLG1b2MsSHY0Nm20lIADx5ia//FZeuqVgk=
X-Endpoint-Received: by B4 Relay for samridh@modal.com/20261117 with
 auth_id=1554
X-Original-From: Samridh <samridh@modal.com>
Reply-To: samridh@modal.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 08E321C0005
X-Stat-Signature: otqeqndw4z77b7oaudxb8zu3pgyjfcen
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795463703-247650
X-HE-Meta: U2FsdGVkX1/zpZN7jUI98GiZfIDEwLaBbS+7nwQZrFhmR9CgQcX9wzHrm6bh4tmca71uIaUUm45a2owffIjugcwncJhOSVn1m+V9b/4tr+HtA0WNhCh2fB9w8oGQ5I+wbhoMxmoUbWg5zwR8lGhlj5RM2jlr/IMilTrX65RzDLW3NCYpjh7pD0YxvBSNIXPk+4KjgCTPmbtMJe0joOrlH/M+IMKsCGS5lpGyxsOyA7W3d8OQFsUkFMeqyI0UHnkoir5daDxyipsu5Ioo6iu/4Qno8FZ3udg/fxGkVLR9aBxS0iIcJdhg1vUoxTv3TIjOWqqvQ8Tk2xJ0iOMZfL1LZzynOl6NwWqRG8Glwt8Ey3dAoz6RFOvsFFusEb/KMzTs2pcTqRHYsL4+7BX/UkrUDQ+Uc3s24+HSot8Z0eWeLDENye787KT1JFQ3kRpyGYZVlGneB1LL/lRrg77yw+A3+4Ai9NG4IdQeOha6eHuCPxRKUOtfC3cCq8Bp6ZuTzkM96mjL57NsjdfrQZJOUvMbeoA4QlH0KQ70fTQXqdStUQyiV9MFh67Q4hLGpgUTcJMsDoJaWHAxNUlhqJoTB/GW44FVDVnQZ4sMBzpLEZlINdP0P48rbcsqOL2KKxbAjNAlIZLS2Q35N9sNE4NeToZqk+QLyd1QClifSIcyJ0Ts7MyBUr+4sdx3+HRfCgIHsaQSkw4wJDDx/XLLzZr3MyvJoU3EFFKcicpEdyfKx/Fk0EWOhH8+kjOUJS2HYU3cOhR0ay1luhYdWwRNzJxWbumqidPviQjC3urM64bIW/0Ms0QPHJ6IXPR7nT2sZJs/TfE8vuEvPQ4DHCYzECAguDl4xsTLXgkW2iWqMMDS+6PWiDo7ozVyOq05ZyY+S5a7bniui04qHg+efKOwRSBmTDYvo4RQpFu3h693sOydixlMQMNySx4E8z2EzkZkdiTj2lg06Lchn3XAGdm6gtnqvok
 9JQzrNOR
 WHDnTxVdT25sZdQuRjoKp4TeXBrmA5evEprvuwhrcJZAKcEVbDECwAetgK6jz/wHnaxOuwkMD+tds+EBpNsgTn9nukGabEFY4mEdRVZoLZ54xa7SHa4Ks93NpcUydNsuk/HCNMoF1Eq9Ihxg/OOgkBxvKpIKJo/Z/gjEEEE3RZe+6//kLEfSI33BexIqTid3qHxGsmrG+T9nAGdpCs1NO8/K4PYcpltQqj/lfV55w8LGVAjq9oyXATIElfXmsmbGhA4Dss82C0Nk+gelQnzPZPW1prXkep8UGoIYYCtoHl3LBkBWp2hzghJeKIOTspVZEV2rDmJIqintljJRDKgL75yTlRz+Rbe3eH6u7H7RsxzNVAp2zN57amiN2lKhCFX02S3rk4uyIENEG6sBets/9/tsPTp87zTmwE2gV4qIrtOh4sRhlW33qa40sJMCahEtzmc5jIKsqs/4XMhwo1PoUrw7hyHObT0bYkG91z30I2mDXW5fZpnYHXSpvUHPDy1fe2khOAm0yLvhmWdCg1kMUqRoGOxxEEKTf03Hgqm0+yh14Rpp7BF4lAOBBjIWwtB3VhjBT7s78rfNSo/v76MunIt+z3b7VyK0lYGwbYJK9mXQtfYt3Cmr1WTGXIr6RZIz0p30jsACQzUFYG4gY4GKn5TzpeBlpqiuJVwi1JuRo8bgbooCg/0Vz7T7IXs0RmWsgZ1UHDDUGKFJipw7dNXKJbsBBudcyo51mxavONlMgPeKzbc/nTFftbQKGhS0qhY3PP/cDppDrlO9PpX6FQHjWVy67nXMCbYNTbGPbttqHYA0EWxKy9m5YbFlmZRH4fCRbH7mxdN4AF4ji4GKuwpl4N7l5jykbQHoQPvOiL5f50BGrKF/MCYZ6JUY1N1WC+Qblh4xV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Samridh <samridh@modal.com>

shmem_get_folio_gfp() clears a new folio before marking it uptodate.
With init_on_alloc=1 the page allocator has already zeroed it, so the
folio ends up being zeroed twice.

Skip the clear for a folio that was just allocated when
user_alloc_needs_zeroing() says it is not needed, like anonymous memory
does. Folios that are already in the page cache but not uptodate, such
as those left by fallocate(), are still cleared, and so is every folio
on CPUs with cache aliasing.

Time to write one byte to each page of a new 4 GiB memfd mapping, with
shmem_enabled=always and init_on_alloc=1 (median of 24 runs on 6.18.55,
x86_64 VMs):

                  before   after
  Xeon 6975P-C    0.625s   0.420s
  EPYC 9R14       0.216s   0.160s

With 4K folios the times change by 3% or less, and init_on_alloc=0 is
not affected. We found this while running gVisor, which keeps sandbox
memory in a memfd.

I wrote this patch with help from an AI coding assistant (Claude Code),
then reviewed and tested it.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Samridh <samridh@modal.com>
---
Tested on 6.18.55 with this change backported, on Intel and AMD x86_64
VMs, and build-tested on mm/core for-next. A simple test fills memory
with data, frees it, and then checks that new memfd pages read as zero,
with MADV_HUGEPAGE and MADV_NOHUGEPAGE on the fault and fallocate paths.
It passes on both machines with init_on_alloc=1.
---
Changes in v3:
- Move flush_dcache_folio() into the clear branch (David).
- Link to v2: https://patch.msgid.link/20261118-samridh-shmem-send-v2-1-f2ea01bfc178@modal.com

Changes in v2:
- Use user_alloc_needs_zeroing() instead of __GFP_ZERO (Baolin).
- Link to v1: https://patch.msgid.link/20261117-samridh-shmem-send-v1-1-1b897ff562d9@modal.com
---
 mm/shmem.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index c769d0bc7df9..0ab3b9146141 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2810,9 +2810,12 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	if (sgp != SGP_WRITE && !folio_test_uptodate(folio)) {
 		long i, n = folio_nr_pages(folio);
 
-		for (i = 0; i < n; i++)
-			clear_highpage(folio_page(folio, i));
-		flush_dcache_folio(folio);
+		/* init_on_alloc already zeroed a new folio. */
+		if (!alloced || user_alloc_needs_zeroing()) {
+			for (i = 0; i < n; i++)
+				clear_highpage(folio_page(folio, i));
+			flush_dcache_folio(folio);
+		}
 		folio_mark_uptodate(folio);
 	}
 

---
base-commit: f7d95bf74091373fad7273db4557df9b5a902335
change-id: 20261117-samridh-shmem-send-9fd2d8231e8e

Best regards,
--  
Samridh <samridh@modal.com>



