Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E82E7C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61776B0107; Mon, 29 Jun 2026 10:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12356B0109; Mon, 29 Jun 2026 10:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52076B010A; Mon, 29 Jun 2026 10:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0FFC6B0107
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:44:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CE1C4013B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:44:43 +0000 (UTC)
X-FDA: 84933221646.17.2C16710
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C55218000F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:44:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTWtaIYq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744281;
	b=x3t+cCe1ovW5DecRN4PPIZqX9I6fdePEuLjPrIWtUIh+YOMwc4pRIto6a9eTWD88Cyh3IO
	iA/xHNH8poyTUvZuIO/dhLkfNfEwwSpSZoRXGxh5Zw+xRTDzsDMJ2GDq4UMRHqvjOCRrR+
	Euq3KpSbRrpjQv16zBTYlgh963/z8DM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kd7LVRXhQqayNdQaCsVNZXfiEHFjU+l0jmqRhEGwXDg=;
	b=F8GYhxX2K3AXzubq2FdmRqJ+6gpdjgwXgsQSqK5NvVKn2jH/d6u8yP1RHy5RV/x+WXp2hT
	bgxhJicnmp2n9R3lmfpcvwmY8HfvWuvnM9CHMBRb9lCjOlxXZELL5tRYVKKuvD8ZjGOUJo
	cCgwGB9aRJ9FAFb2T9RUyEohQeuGNlo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTWtaIYq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37F246001D;
	Mon, 29 Jun 2026 14:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899B81F000E9;
	Mon, 29 Jun 2026 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744280;
	bh=Kd7LVRXhQqayNdQaCsVNZXfiEHFjU+l0jmqRhEGwXDg=;
	h=From:To:Cc:Subject:Date;
	b=UTWtaIYqyHgFCVTDkmRR45eFK42+RqOpV3re+1jd3KS79Sp3M4K+ZiuhLtRWwk4Qd
	 aKQQ4R64rEd1TknW7eV9p2gTLWNyu8HNDkFcmJBgd9GAswNC+k3Abvi/CT04uPMo3W
	 y9XPNuUtXgGJS1wAa21xEzVk74TnJF/xlocVKLgMmlJj0fPy92WQks7zyLoyi5rZKh
	 tEytiM2ItM1+2pDQ61EVDjhU2U9R2yYj3Raz06K99THaxdRX5q/1Nc2+CgLwNzodLF
	 09z9r9CEQledrfb5WAADN0HHUR58VtjRIe+kaXBhy91tA07FATCiBppXicTlXYg5dx
	 eLQGxjrn8AsOA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH v3] samples/damon/mtier: fail early if address range parameters are invalid
Date: Mon, 29 Jun 2026 07:44:31 -0700
Message-ID: <20260629144432.133962-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C55218000F
X-Rspam-User: 
X-Stat-Signature: sp7qsj14yokz9t4xbfowhgyh4sbybfbs
X-HE-Tag: 1782744281-434296
X-HE-Meta: U2FsdGVkX1/0h6oge0QmEsGkF311sPhdAL3N7qg53N5etxcIeYSiQZIi4/PSbeqG8vpZF8jJ6gcg/2PW3n+a1voY9u4M1gVJ8UhbM3N/S4tNB4AyXseQT0F2yHa3HCn2A0qVxrbgyGR7LOJ/V2cBxig2KModrMm19t/ORxFIBqTSRHTQb0f8cmryx08JKUQJkp/Kiifnuz3NtfZbcBOokG5w2JXtdVKWo69YMFOWS6jH1hZbryhvZysdKNc76DS1i8kvSOaqLpVS3EfRghHlYm32CNilL6cMI7QBkYlePLuLWz/7z7V2ugKebs2uWQf8UGb89LHvtP2Y6NXodENRqlF2XHIk7OctdgpxVNsjchX9ayX4m6nBdSe3VHU+LI+55C6sqaDbrMbJBu0VwimYeBXoNHWRSb2YhqZdj0jB7uFD7L2QFifpzhJe30VBhqo6pzBRYybu77PoVLAwF3vKL7SFoAdmPGPnLhdhK/UuoXg17SeZBM8TxFjZqnO60tK3WLL6WfsLJFS7bXxm952ewlGAV9qdYmQF4GRyiv8vsLVymQ1xc3TtLw5DbJFHbsTq90Zd8tpDto2Z6Sy6ALBttVLJDCDT15gC4ajfwbXBD5v1aFMl1sw+oCAcPGAIUL3ONG7svFg0h00/kuQucHebZW/LtnhzFLk8nfLJ7wX0eGAeZLbXjrCbl5B41ozu/zKvlVShQXGojdZwJuFtKLlhuobsW6ANbha9y+B3/wRCkozi0o7OC8lux2aTqzjQRp8vyy5YYFvn5CgGImPOWIQ9BE8l1l55O88m1ZIVX1AYxwQK22yo3SJrZLkF+4Gv651s8+TB8p3zV04sAuu9laco+99wJ+J/Toeqb8hsiSPcWW3eRCeAvD04LI4zAeEK1i74ytxd9+NSZxUFedv3FGX8d6L8q9Nek4xklQuvi+3Ly2dPCwAav7RdQWBevxNdiVYgBOgSfn9/DzhhLTFq6kE
 Jt71qiry
 aSQdUfw8o4RMi53W84KPaTPSzcP6QGshEEuJKYWvnY1ibW1y+rDlwIKIB4O7wJkW10Nnd1KdzhbbZruzjEvr7qnZGWlZyqts5v+fjywDAxdfghT2P6GxHHhkWJaLYRJHXrmhlCYlc/0WLIADsEZdAK6xPUXURROAo9G8gcqI+IVni+1oLt+6/CtTymLj8wD8px0KACkTdueXeDuRvjqxxqrWYOW58IYwPDEh15j7t2oosnI85sKR2ZRe+jHih6X037JqU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zenghui Yu <yuzenghui@huawei.com>

The comment on top of `struct damon_region` clearly says that

    For any use case, @ar should be non-zero positive size.

which is now verified in damon_verify_new_region() if the kernel is built
with DAMON_DEBUG_SANITY.

The WARN_ONCE() can be triggered if the mtier sample module is enabled
before node{0,1}_{start,end}_addr have been properly initialized, which is
obviously not good.

 ------------[ cut here ]------------
 start 0 >= end 0
 WARNING: mm/damon/core.c:217 at damon_new_region+0xf4/0x118, CPU#59: bash/341468
 Call trace:
  damon_new_region+0xf4/0x118 (P)
  damon_set_regions+0xfc/0x3c0
  damon_sample_mtier_build_ctx+0xe8/0x3a8
  damon_sample_mtier_start+0x1c/0x90
  damon_sample_mtier_enable_store+0x98/0xb0
  param_attr_store+0xb4/0x128
  module_attr_store+0x2c/0x50
  sysfs_kf_write+0x58/0x90
  kernfs_fop_write_iter+0x16c/0x238
  vfs_write+0x2c0/0x370
  ksys_write+0x74/0x118
  __arm64_sys_write+0x24/0x38
  invoke_syscall+0xa8/0x118
  el0_svc_common.constprop.0+0x48/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x54/0x370
  el0t_64_sync_handler+0xa0/0xe8
  el0t_64_sync+0x1ac/0x1b0
 ---[ end trace 0000000000000000 ]---

Note that the same issue can happen if detect_node_addresses is true, and
node 0 or 1 is memoryless. Fix it together by checking the validity of
parameters right before damon_new_region() and fail early if they're
invalid.

Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v2
- v2: https://lore.kernel.org/20260609064653.1829-1-yuzenghui@huawei.com
- Collect R-b: from SJ.
- Add Fixes: and Cc: stable@.
- Rebase to latest mm-new.
Changes from v1
- v1: https://lore.kernel.org/20260608111534.264-1-yuzenghui@huawei.com
- take into account the detect_node_addresses case (Sashiko)
- based on mm-new (SJ)

This is a fix Cc-ing stable@.  Nonetheless, because it is for a sample
module, not necessarily "super hot".  7.3 should also be a reasonable
target, like the other sample module fixes [1].

[1] https://lore.kernel.org/20260629132641.159851-1-sj@kernel.org

 samples/damon/mtier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index faaaaa12e6206..e567f4edd80ea 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -120,6 +120,9 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 		addr.end = promote ? node1_end_addr : node0_end_addr;
 	}
 
+	if (addr.start >= addr.end)
+		goto free_out;
+
 	range.start = addr.start;
 	range.end = addr.end;
 

base-commit: c1922f6a1a8b9a120b46051c3c5e3b81b4b75d92
-- 
2.47.3

