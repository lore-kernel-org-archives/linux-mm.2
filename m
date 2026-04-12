Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A514E937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1A5B6B00A0; Sun, 12 Apr 2026 12:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7FB6B00A3; Sun, 12 Apr 2026 12:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05366B00A0; Sun, 12 Apr 2026 12:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 821C36B00A0
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F07C140BFE
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:26 +0000 (UTC)
X-FDA: 84650487012.08.1CE14FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 458FA40009
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kXS/Dlwa";
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kXS/Dlwa";
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012504; a=rsa-sha256;
	cv=none;
	b=RciJB3+qQb/wp4nHIfbEFkD00fM83sTMrDrU9hcKoc2WKHyY/1sl+yrHLfItYCLql0gNgr
	CLUKebUuNbt/+sQBqkKVhYAKEfjQbk8bbp1lM3/Uy+MnOfmDnH3cVrqERhgFodwoLSGI8b
	nB0rv0ETPdDxNyogtaJ+//0WZncUqS4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012504;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pT7kpnxIPrrVkIGY44NeaYwRw7pZfBx4mz9EpGYCMTA=;
	b=SFPtkF85SB7ob6Zn9v3n+/lYB8UwCX+EBItCdvD6Z/bYBg+2up45PrC3+yqoP+VVQTtcoq
	20EpqeJeD1ZffhNhYsEVd4atPGaen4hpFAnjWoZ9gJTpH/nnQoLEk2EZ8q7gkIr5vs+hqf
	nTmA7QtX1dwXmUVSiArNf4Ntt/FiypE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B69C544709;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D48CC2BCF4;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012500;
	bh=0ogG1jMyQN2qhbr+HuVe+uUiHh4hF43M9AOehbS6L/w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kXS/DlwaLpCvGRHvqGjzI+5PcPqqzA9F3uJah00fz7NeMsl04VptobPVp/3JwmoJd
	 J9ShtR5PKoFCTgmACX4kK+9nfwoqN2YQR3UV9xYoy2dwJg4NySEAbWTFFO3Vrq1CRT
	 +Awp/FG2Tt7iHl4Lp4u6XYKClzzhMLR3BpRB3zDLdRH0J3MvzJ9guMoO/UKzfp2TMw
	 ORNq1bmQJjyyS1RneatW4nVvermghQ119f1+avtolgEr8N9HYitsqWy9vJWUoIPQCq
	 VPxMoex9nKZ/IQDiFdur4mt9IpIzWZP5xiFBH+d5gKLWsdjXrlSLx3zGRaut7que42
	 xhfZd7+sF94Cg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6521EE937EF;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 13 Apr 2026 00:48:26 +0800
Subject: [PATCH v5 12/14] mm/vmscan: remove sc->file_taken
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-mglru-reclaim-v5-12-8eaeacbddc44@tencent.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776012497; l=963;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=o7IfWpYvb69FfM+6QHpHKLjSXJdMZ8mmLPd6WDSOdzk=;
 b=XwU6oycFtzzEXn83BtJbfuUKeK0+9X4XcCrwsedeyEG5UJ98PBWfmDNuZobUdvF3wfmMTDfSR
 j2rLk6jQdGACPZ3qZuO0VUVi5jXV2Zf7n3kLENeT1FB/oXzyRSnfY4y
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 458FA40009
X-Stat-Signature: hwoarc5dbejho7g74kzyiii6co9uxj5h
X-Rspam-User: 
X-HE-Tag: 1776012504-101134
X-HE-Meta: U2FsdGVkX18+KJQvegUwa5NFkv2Jh271yFsWattv8o0hawG9Q6l0ydPiItZOLgMHtFpSrOxdMdpRTWzYemyvGZnRVi1UlfjEXC5y8QAS+2aQoaSSYgcq9LFt9GysDGD3+d0WEH62wiZcSWp0BrE5yUn2vTqYPnRG3IdK4fwVWYuLDSMoFkkKAqoh9NNddkdBqmVvVohrWGJsDH6kwtRVebTmLuaA1S0UnozdmaYlA2+HQeT71J6gILfwre0txr6QaFd/30w1f4Cv9hFUoDA2HsfZDhrDdpgIZG9m10UfL/W0WLEGPKmEaMbxPrJ4Alewxa4nEi9FKOLIZO5FWxVb5rblxaSxlQr5xJH+q0ok2N4i++nXVK7ybZYtMK7Dl8sPxA0y5+dONEwIKix4ecYa5ZBu+1pQaQDaLYnecLCdBeZeZsLs1Y9pfv4plVqnr2M436UVB0VCd6R3rgTyOduPLnKxRsdoTUzhHI977xHboJQoe0B1RePUDjAG11M5g9d9x2fOoPsRXfD7DecylYv8MN1o3Gp4CWJqNDhtEQisaAZOuP8ehecfQEH3EuFUNfc99UVicmiqRqIBZERm6sS2w+WfuWgAihXrKUE40jkKWv6zxBveehr0ql5lTl8BQkOtI7qHwQFO8GOGPm876Wkt7d2RL6N8L9g0rPbta3X28Nr8maGXSv2+x9dtpZZi/lOAx6anrVyqJAEqmAts3/tnh8dMc1WzZ0wbN3Jk2rGfnLKTsJCWzrIf8/8JqLn2EmxIVa5xxHjr4KzhJRmUJp1oJabjMbVciDqu4Lmwfxq5bI1lcNCycrs+r6SiKyLBvyWr/UyWTbAXo5j5qibRScZCJgm4WsRKokp7Y3DEY5KVdu6YLaDGFcfr1UQJy5ha0137B0Tt6ZXWpjtJVTpQqbhG6dADi7Ol5Cep0PhEUDYCBD+ZNB4pMhOKAkbnaHZzlj0NvDF7IbnxXPCgxitpbaH
 zFjhx/aL
 NnzwCMluVHXaQuURLJTOCsWR6T2v7NX2ABIDq3byG3f3CCze+owpN9o/DqGq/8CVtYN9/+DyaSbA2hUJY0cOhHSE48DpUXXE20oLj1HI2kUiFpeX3nGjYEqvpzstFGxjF3ZOPjwTp57zppWpVBVzW92dco85J9HNdjCRwGhfcxBQfIcweFD+BAaUdoiyOcTRDZlMglNFdvN9Sc3rjjD6AGdnBkMpDBtgOntZY7XyYvIne8BxOv29nMqWf+cCaPgqlmaWkXIgz8kFJs6LZpP6RmkU95wgL40nmTmzvMzcYqlWy6Wexwzi5TKsPpsMmGv7k0MRSzbnQlROPPYonwD4IZtpm/Px/o5YuE1cefYBKCUUHMHrdBXKZokevsUtGcBgIMbPj6E6zwOarpz5UnToWPflIKRCOSnrCj0BQTj+DFfCW3AFMRmU5e/EavGUKmku3Xrn+l789pWsb5/wi8trSPPgv8LHp2TdEBKA48cINg6Wf5Bdo0np19IwwYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No one is using it now, just remove it.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3f6ba34fcd24..b0b66c03d4dc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -173,7 +173,6 @@ struct scan_control {
 		unsigned int congested;
 		unsigned int writeback;
 		unsigned int immediate;
-		unsigned int file_taken;
 		unsigned int taken;
 	} nr;
 
@@ -2040,8 +2039,6 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
 	sc->nr.taken += nr_taken;
-	if (file)
-		sc->nr.file_taken += nr_taken;
 
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			nr_scanned, nr_reclaimed, &stat, sc->priority, file);

-- 
2.53.0



