Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B87C2D6AAF8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F876B0089; Thu,  2 Apr 2026 14:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D993E6B0092; Thu,  2 Apr 2026 14:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3116B008A; Thu,  2 Apr 2026 14:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B87D6B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 531901A08D6
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:44 +0000 (UTC)
X-FDA: 84614514768.15.7E7E750
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D275A0014
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cm6w2Vkg;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156022;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCzLAsSX2GQU1MRNujv3p/UgbJKRssTgW5qIxleWezI=;
	b=IYxfpJ+jGviCObxZs7kkekmTcTZ/r6BoHbF3+6bmbdLJzzokmHcA9nMn6429ijDS585GYm
	Cf3LTd7/futOeB3uunjTvp8QkBDAdgqQop10xtTRgkjz3PNI5m37t5dJRNX6qm2Qut/Qwd
	I5rSxBZ56eDwtRfsszT6L83HNdHJy0Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cm6w2Vkg;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156022; a=rsa-sha256;
	cv=none;
	b=y1CDhP7/glFs4g+JquMBaQYQu0Zr2W7kJ51dBSjCryEi98vKo+Bn5aD+0hYg0TuS/8eGZO
	LpFVLq6ta+p3LhTM46a+F8x+6bKdrB/a/uqjQKwA7ikrtnDngo0ordM++9ibKRXuWh+C1b
	sD5ZUN8Aj0J7V8yb7an77s05fQ9zERk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC1566012A;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89325C2BCB7;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156021;
	bh=x2iJwRWxsNWZo0hiLp3oKxL+smbwMKj3xOseviAzoms=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cm6w2Vkgwa6C6VFPcS5n7ghuj6S0F2SG01gFw/0eROrsBejbSW8GizVCkoY6qZDaQ
	 qHqzY4K3eNx8IFJSQ+1G8Yi3HoEKLyD2qTKIEkid7DXCNHQMIWKr3kEme6nOohpumH
	 a7k7zaxJUw7tQAmYXtJFWJsSVHcoKbzrZO3AkA7AnxLojm2GfS3bRpVfyJj2MSB3eA
	 WWJyacKDXfRYzT+56QnKqQSXq4HViQX9cXZ7/+E09yzSkGVpfneo1krdTEf/PMO+zb
	 tFOPfaoohPb17JsRvg8XLZS2GiUSlUrJ012SuYtsWCJdufuNEr99vDD72t2Xt2kxA7
	 tFAt4TaHnjbCg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECF8D6AAF9;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:32 +0800
Subject: [PATCH v3 06/14] mm/mglru: use a smaller batch for reclaim
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-6-a285efd6ff91@tencent.com>
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
In-Reply-To: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=994;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=QDWywh4OipGEfwenRADOn5rGg3c0b7fQ30+q0TRFWgY=;
 b=mZJyHWd8S2PbDZMX7PzME79oAFtxlbgMKsejQcQCfPstJyIfIcrT1wcurlc9jyTtCfzVeYrht
 Mb68Bn3exRTB6hO4s+5WGWGxGEfgELP3IjZa3HSB+PX+CC7TnGDarI5
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D275A0014
X-Stat-Signature: jrhnoog1gmpxw6xoq6iz9gcuqtndrpoh
X-Rspam-User: 
X-HE-Tag: 1775156022-254730
X-HE-Meta: U2FsdGVkX18IKkAQDzM2c4tOgC+IZDNK/lYffEhqLuTmOKASJxe+7dDLiscDG2nVBqEB3lfBPxNXk8vyJWZda/+UtPvpwbh/ttMriOF9LkyoGWbQ02/Awl2A5xuQL41+jNmH8SO/NtAOxRqGc7Dm+3TZOv0U3U9EKP/tm4jeUHNRL2Q1aLe79twTUi3aoFJd8C1VcbtuaM2WGLJ4N/UgjWKM9L41PwVR8CaEOPorN3a+cPYRBmtJ+X+FKwM/WmymEUGN019zsZqgb3YGYe0/Lt0vaSOvZUHFB2HnLhrtsXR+Z0Jw2x2TvtQY2UyYzJN2rQbK4RcnqnPlqRK9s9kl8xfdH2yNbtmWK2oFPtqHoUOVlazcXaeTM58pc4+BMkY3fm9LhbVYaiqI1UiHgmsbzkCHCo8mtovNuYp9iCnmibcVUobVnIXTrE7OOhhLs7my0I8KVFUiuU4phvoeFLB1Kr4pBMtY0OVPDdSOgkbbk0Xxdy+HseJbg5ZJA3r8A9mH4NSP49eSG3eCzsTsUL3OnEUyxCeLPfGRSnPfsBViX1I9eaFPvvf4avqD62wWaXxfqPfMgx+PEJFUC8fgSsmc+GdBrgAqzcS9qZerP+tfJVc5OsQLSmM3XZU5bauVpkHFBkcIovGJ0tkYE/dCrw4Wrt+cyDQeaZhiBGsZOcYEHcKIDf1Ge6rFti97jaltlNaDFTQ5ZFEytu53A/gsnihwVRBbdzyN97mVSETIYx9CvNRm6cYTfG8CfeiToJB5sXFMNYBh4xhOL+5UC0FVc9S20G2a4txY/n3Xda0HNTBO4RsrUiLWHVl8UXZ77YuL88NAouEw0q83NDKLzTQT+tIuEZs56/RRd4uqLnP7kOcGC0c2RtC36Zy7E7fo+onajd0mkrad01iI5XfRK+BY9UChgY9xU4Xss24p69MeM6RS5BaQ0vI8P2x2w8qPlHD1cXppNbp0YzHMwjoi5fGwNWi
 TSvOKJx3
 slGmvrTFv0LQJjXuYW259wf5yYbHbbK35dU4kJF1PV4u5lI/thku3r7K6VtH9TppeHVxf0wjFvEIFfo9rkoYjG920YDlHUB9KBtHkhIz3T80DKqRoaXI/nrxnnokr6wtITlD3UjDAuGyPnjSI+iWEZA/Agg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

With a fixed number to reclaim calculated at the beginning, making each
following step smaller should reduce the lock contention and avoid
over-aggressive reclaim of folios, as it will abort earlier when the
number of folios to be reclaimed is reached.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 643f9fc10214..9c28afb0219c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5008,7 +5008,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			break;
 		}
 
-		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;

-- 
2.53.0



