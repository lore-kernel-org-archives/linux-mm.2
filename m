Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA5D10F3DF9
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6914D6B00A0; Sat, 28 Mar 2026 15:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6619C6B00A6; Sat, 28 Mar 2026 15:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32E366B00A0; Sat, 28 Mar 2026 15:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6576B00A3
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:52:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C73B9E0403
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:37 +0000 (UTC)
X-FDA: 84596519154.13.61255EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D256640003
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P4Ebp3Kj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727555;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4JeOJ1lrjC1EFtmQbLbsPFRrUYC85CNNtrIPcwqg334=;
	b=FroeLlJOjT7DWJK9Wm94S//lz6A2emx/xmIWpq9rDV6grXOQSwoqeikZimFUxE5MAeO8DH
	zg6Ho19+kfqXcPEuxYw4h6GUlxVtNWJBo2LKrE5MzkMAcdiGBUFSFvZqHxkEisXxUZtNOR
	Y5Q39Kw0iq9K5+qviWtbDGUePfITkHw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774727555; a=rsa-sha256;
	cv=none;
	b=a2Q0BkNSNIsD5Qj1XetyKSTYtXv/+Y7u0McyLKwMEZ44fQXyVZVBenqsIGvEeOeQSq0zEk
	+7Hlme02iQEBGQIzww60o/SVjmJXhRaj85BRUYJ5pi5pUHcu01zfFbOAMo+/nhVkjbNiCc
	cbpdlawYzD3qzu5C671LIPdLCY+DQS0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P4Ebp3Kj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1056144703;
	Sat, 28 Mar 2026 19:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1339C2BCB1;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774727551;
	bh=GEmZonv36+Qup1ubevJ6ZlRq/DuzmmPuCUY205VEyyw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=P4Ebp3KjPFXrAb2qxb9JmL/MPOFdaswcuwIgEuT82iZqx54CAfgC5QMX1RSZagfrK
	 O4coN0GTuIRj+l9QCrKVTTFBRzfBjeGl9Wra42dNfA2Ly4cKgnaTS0dwokFL7HLru6
	 xIs1/NCHyXg1lU41UexqftQcgYTtKsDZL6841Q4gNJkMThNjnvnWivXgBYCeRkByqd
	 bPb2TjhmKSQ4+wGGlGuUnpJTY4m5dOu8FG3EHBTZ377Szgw2CF7jFtBzSHomhjqhYj
	 X4nMgJGfltS/Gjvzn/F1KzcnUK025KQVjb0F4DNOnvwDewpx85hI9DALmCDYEGN1Xj
	 2xROk4D/3ofLQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BD410F3DF8;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 29 Mar 2026 03:52:37 +0800
Subject: [PATCH v2 11/12] mm/vmscan: remove sc->unqueued_dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260329-mglru-reclaim-v2-11-b53a3678513c@tencent.com>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
In-Reply-To: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
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
X-Mailer: b4 0.15.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774727549; l=878;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=1kSyn/NqM3RpP1g8xDeKI3xdQvt+WcrXpJEY2B2ekAo=;
 b=pbHhbdpkvvczwQ5CESey5xOFg1O3oJ3xHcw35gtP/OVyrgupgxyhl/28WVkmMpYTUjW19AL91
 d8jSmspgQXvDKVixNgocxeclptPx0D7LmkzT6Lh8rGckdL4+7Hj85in
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: D256640003
X-Stat-Signature: j4oajsyhfu33bcdrm1hfeomfkpifc9g7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774727555-330733
X-HE-Meta: U2FsdGVkX1++Ja/d3vmu/BXYUfaNZpAABagpys0sCjZ+8riicwGxtPVJlB0Zt3UxjcejogiX4VbwEdYdJzUVFWy2TwDcGaISOpotuhsZI7rBv5faBUQZ1hftVNhMzAgadEmXrI2hvfcAvVS20SyN/TjL2h8mSmn/BG0JxiHTghr/ERsP+gPx+vNs9J3FKGPslljJOo4vq0g9L5GyHHNWAhP0IQXCT2W/vDnufL3Mctrn3EaEqb09u16I1njfZvskQA8G2aBkH1wUl0LEtbkR97RFQ4PLQXxaQ/7If1ww4Nc1hZOCmOgbwqW2w5yNmrZoMtDWsCE1BeJzh+DIzv0x6++iKCewr2CeF/NmJf47I116b1OyQ0Hut9ry28wG7IPt+A1xT1YBSWXzeGc14toeiCKQPyArK1Bx/Y3Ls8Wv/LfISizvOxNNu9e2vf9o8DGNfY9spCyQwXkeSkGlhmnUQ4E4qZJ6oJqbe2hBTMjivZRsflgrCRgRfckcZzxRvyY9bTtx5G6BKtAPQG+5UfLZtYBQi+JWmVVGftYSF9XIyj1c/zQZK3CgAyHsGDsU6rx+loizO9FI3uom9Dsdy8BgXNceKRU/oWFHnfcPlgOXAw9Se78epkrC6Drl6WQCSJXKyD5uoobLiyVIgFRbrjeVsWGg88P+xi+28LoHNVvF/jc8WBm2ym218yNabtPE8uC3Dcpa3VO6XfMp8lKytSQWxw3guwRhk9aEQ9QsNEbbS9is8Y/4qA99k+h/fsOoKlliMJA3NWAfhIuHeqe4qcYR6Y75OqwJHtmE+JMgTKNdqsnmBFVuJWPffvWeWbwR093YhaEPoeHRf5yRdo3dJhrc5nTXzYy7pZfK0KF4ZUl7dHDJiWgr2RNyjwnAXtELYIsDHpdj6Hfilb4eM7/M7IJwYPLQHLFfDD9Cf8mAXy9v+h2oUFh8nrLlXyliMCHlWOjB4PiPRyJ9BPIroCj+P6n
 t1fujUqZ
 /fNK9XwTdcHOVNJmyRbHZJPiakcINoPieMi8vHKGOQqa3/Z/1SVuCsHbmAqyDwFEAM9SaljbGKwvlNSN5KGyiNA5XloYr9epNLLOmoFKvXxIQFM747Ugriu+RbwQmgaN8ldM9FvWVArzyCYQheCZQZNKWBCKMcTyj9pc8UapiFc/LlSNzRlHAbIMp47+etxFOCQjrguBvAUmp1bCCS164FxcGjpUVCasdputZuSC3dg24QrHeq285XDP3NYRFe8qiNokI9ZjDyOqdKWZuj7y3mPcarTJDsj3p939i/FKeos2hQSsjClVnFKlcVSeN4rBB5bUqVwukAdGmu5kJ7OUOynW2WrNDGyljAUYpPfg+cZ3ZGqZ7qsavNApOx+/xdR+FPyLu5wttkjMTQnLFrWjS62nSmqdpVfRS4h2PLdVBX6XEuzMGnSSpoJfE4T0H++F5O/QsMbMZwwRrIoi6QsotRHYscKbPgmMkBv+Er8ysRHogiRlRRbXPIFcHEIWIs9cbzFsXk0j6gUKx1GZhoqmx7n7PbA1aaDtzmun3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No one is using it now, just remove it.

Suggested-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 603be5ef3ef2..1783da54ada1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -169,7 +169,6 @@ struct scan_control {
 
 	struct {
 		unsigned int dirty;
-		unsigned int unqueued_dirty;
 		unsigned int congested;
 		unsigned int writeback;
 		unsigned int immediate;
@@ -2035,7 +2034,6 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	sc->nr.dirty += stat.nr_dirty;
 	sc->nr.congested += stat.nr_congested;
-	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
 	sc->nr.taken += nr_taken;

-- 
2.53.0



