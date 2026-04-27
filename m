Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FB37FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6316B008C; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0A3E6B0099; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748E96B008C; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0C46B0098
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDBB04027A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:08 +0000 (UTC)
X-FDA: 84705117336.12.A5747BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C60FD14000F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MEuLA6HU;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313226;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUow/GEaa88KukMNDL5O+flussyKx00nAf3JTNGmABY=;
	b=H3PxQJLzu22GUUAopXGRLfpfvr64Jp5Q09760DMKgm14YATOWMnmPfU7t7tVhZbTEil85R
	UM0T+MKO6daZtc2kKRvi9tBtddPR2KgdpT5eB4VriQ5N0ceT97dOxC7asivuP9BmCSt18e
	zQOwFWDRi6CYJyT5FQUA1fKFPikq8wo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313226; a=rsa-sha256;
	cv=none;
	b=Gfi8kfeP1qDxSp1ZOc/56Tz/ulwK474vOS/lsEvZhNHgwLJEcpdjCEYoWQ9QjN74rETcwm
	OOjtQeZuqM/yNnidE/KAvz18q7e3SVBKHIMoYYuHo+1OI1hjQo7rlEaGgygEBfgYBQKkKe
	UuhB5KLqE6YYE6fXbOkMGf0qN/PFjcE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MEuLA6HU;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AEE461330;
	Mon, 27 Apr 2026 18:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22D93C4AF49;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313220;
	bh=ZfS24WSAF5BaTElfUTuRXGGO0zKEsVChuXuWM96dvwE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MEuLA6HUYZXObFY9Naw8Q8ooiuidv4TF1l3tpKPY92AkNAstaHUXz1Vntf7NK6+zc
	 LLbklRBnM3G7sbCVkXd1W6Lb7d75WOkFOqwhoFVSkecECetHSD9z4Y3LBGl447SKMA
	 JnKB/DAteT47EcGWF5H30TeFMijh+F5Y+w8QfA19dC/xEKwxlKCrKsajnBc1jligpq
	 hqS8i35hmE2U3trYzLScd+MW/ATlzhQ+F9+6AZq0UzsDNbcS9Jhl+IrEuKLBWhlBcd
	 NspUeQMTwINfr6zMeDZOQw4tIhu6oyN1+Jd2smk/697wgWqvB6/qWJavzRhpCap+Cc
	 pBU11XNlDY+hg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B19CFF8860;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:07:00 +0800
Subject: [PATCH v7 09/15] mm/mglru: remove redundant swap constrained check
 upon isolation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-9-02fabb92dc43@tencent.com>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=1862;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=3kVEaa+69q2QQdWMI3d9+Nc1UFdcO1MQkSA+3AlCcvY=;
 b=G0qlbP8TdGe9GvyLqb1tlEmx425wLBr5K4r5niqGUlo9Pwy5K0n28djEMUxQFw2UmH4bI6Tn4
 IONoSmPMaMfDBaJ3v78FFlusOvvvbq0AlGOER8YZb3XgTRX1ViCR3xB
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C60FD14000F
X-Rspam-User: 
X-Stat-Signature: nddgdq8fmbk33dbai4xioesh9979df4h
X-HE-Tag: 1777313226-410509
X-HE-Meta: U2FsdGVkX1/JtboGKkEzeDN0P+4GghqjgIA3O8yuiCGXI1weUP2EEgDpOpbVDT3BY63R9zguzwDz8of+5lxamJBofdHigOU0OLrIzeRUmjH1AP4OxVqtxS5JFzhsarGkgnH6VCtgaUMECBBdJ0ZWjJ1aBNjgKSW5pr9qZARXk69IfvHWv4BJ0ARHeMdMuGLX1Ff2aVlfKFEDu7TGBKEk87tl8jqKtkCNfCy0mJPEqeMBk/IoVUAYQAtUdXYo5pWfED384Vw5DDWoX57VM/vY4YR7xHjMSxDUprPI1zHG+Y1HHHwgcbpxonB9ujec9T4gYx8eV1D+KVJUe5xHMFcOrpo0TfXnbioxQZrW1Zp29FpPWaUC8+3bOzFlyFq+q+lRNIjrEYaPlw4yHImZCxPk5ymBPA4Kw8FBw7F0AWhwL7MMUVqMuMDHctKo6Ni9LqDAggOY1yqAgl1r/JVnQ2YZolsqF5Z436omgEqAleop7Y7S+KVcBXOwSBMnfvSzeK3B82ajyx0/eWuEdns5fog3aW/eE9gzMKXIw0cYxsT9epGJxtBMTCyB+KdVQMGL0qt9vNh6q9ttYxOpt+SQADCNuib2kN8tof6xgfdIl+E/ILFP/Bv6u9uxPBEqrSAZ5CH4a/bwcNpIBLSX7VIkok9oZnSM0ETnDKcvC49nz9n/bZ5SrC3CzbeM19ydV+eW5NzukysW4NDhnbl2DmTfbhWvvQxy7c2QF+ZDSX5NpB62tO6bJ5UsGheapAaLmHFn6T4Q7I3wWDYeZfxFzXdt9pQsezavxg9z0Wxklz6DAsCThpouEaczLs3EhmgvH10sXQR23J66SMZB6GqoaScuQwP/Ln2HUeqP5j+czBmIfcCKo9G4gL4xL3xnPy1Guln2pI5N5s2B6p+1KG68MwjrGt4f9WNebqvK5lbAkIK7RdG5Hk9fa4kwmjWersE3JXBP0rqlO2D5J+bv+0KPw36ht+V
 SNIX8i8V
 Sgklp5CH8bWbmUwkzHVC+05h2YWnm4HkanApWwcMq9BuXPezeCFVvczOdZW8X68iT0FjILb/+PSOWx2UbEmxeEdtKan9G/oVy0W4SFJ4pU+3ZrMP/qu6Q6vHJ05j5XZ2hUskpP+8+M+MAHMN7LRHLbMbRLKX3I8Hh8F6jIypWn2gk4ETHLfcjxfzfnBJKeZ5gUA2lwWpBvvyj8P4vdZQDP801JIy9wv3ZQ8JZPGK8XfS2kXLEnxPxuF6rkXlJqZ9e/T23VIhKhW4X3ZtBCYsv0bRJqopg9GWOPXREi39joaNXMm/R7l5e4KwAPG+y5ZQx7enL0giK6Zdbjf/SuwqlEYGnkHKU/WilJJZFad9i2u3LMzSNNBb25HLUWyhYEIw1QMIWQdHV7bUw1AWFxWNmdvKUE8qtXbu4f0UepIlske9VWKRUgFwVQvbCQqnlhyRvtqt/oQuumO+tx+sq6lXkxx0cd7IPcEpe5rfhMk/n/PZaDLLRhSqwkTeAeJL7yKzZauKuFv9JySTU2dZ+v8baHTg5nArsGwJ2X2tfMZmbhwVT/8lwYeBha1k25I5dGJ/YTDPr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Remove the swap-constrained early reject check upon isolation.  This check
is a micro optimization when swap IO is not allowed, so folios are
rejected early.  But it is redundant and overly broad since
shrink_folio_list() already handles all these cases with proper
granularity.

Notably, this check wrongly rejected lazyfree folios, and it doesn't cover
all rejection cases.  shrink_folio_list() uses may_enter_fs(), which
distinguishes non-SWP_FS_OPS devices from filesystem-backed swap and does
all the checks after folio is locked, so flags like swap cache are stable.

This check also covers dirty file folios, which are not a problem now
since sort_folio() already bumps dirty file folios to the next generation,
but causes trouble for unifying dirty folio writeback handling.

And there should be no performance impact from removing it.  We may have
lost a micro optimization, but unblocked lazyfree reclaim for NOIO
contexts, which is not a common case in the first place.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 42ccc6eb0748..ea86297b604c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4650,12 +4650,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 {
 	bool success;
 
-	/* swap constrained */
-	if (!(sc->gfp_mask & __GFP_IO) &&
-	    (folio_test_dirty(folio) ||
-	     (folio_test_anon(folio) && !folio_test_swapcache(folio))))
-		return false;
-
 	/* raced with release_pages() */
 	if (!folio_try_get(folio))
 		return false;

-- 
2.54.0



