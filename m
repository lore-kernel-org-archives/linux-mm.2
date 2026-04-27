Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0448EFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B25B6B00A1; Mon, 27 Apr 2026 14:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660846B00A2; Mon, 27 Apr 2026 14:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54DAF6B00A3; Mon, 27 Apr 2026 14:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE786B00A1
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1263C12E4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:32 +0000 (UTC)
X-FDA: 84705118344.04.CB13DD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 94D30120007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LwzQdNsz;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313250;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+v6n4otO1yVl+PqebASqAA8ydBgJilz0YdLBFBfOaEY=;
	b=LscSIxx9qyekMZaEF4jsy7LQZGy1xAjYqHTJCW65FCMi344V8MlHGBRG54grEvqfvVrO+U
	N6OaTAzOHfqj0TvOOfG/xZuYkRa9A0QyrXHEWWTo2gI92tAD9xl6yeDpGOYFtLWFAsMB/s
	SMg4fHanXbbXw/eVZdAUaR5opnQINPs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LwzQdNsz;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313250; a=rsa-sha256;
	cv=none;
	b=muYXQoX/NXjM0YL7aNnJxAHNqANSks5QcauVAM3AysSSoP1JnQk6TTKRFEScYVkTRKLk0A
	lzk7YQFq9m9asMJFpA5xOfGRBqylj/MhURNQYzbezn5W421nmskuHvhHKAw8vPJbB/KSIi
	PLKYk49RY5NTgt0FqBSe/M85ZBFxdwQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C170544759;
	Mon, 27 Apr 2026 18:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0600C4DE01;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313220;
	bh=sXAj14EE+Y6fcBwNhkAfFMLO/N6XGozNJ2a53+EUB28=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LwzQdNszgApHjndc4uf/XtSyXXCtvtxz5VxWGtRNgUI8kkm9G26Hqv/Q2YeFh7Fqq
	 gCX8ZTVpdAnM3dzqQgeHYVKxZ1P3XxqUdhlo3dkwCxrx1Xg4yMMIiC6CFlxjssecdu
	 7dAY1coxIYLO+0LPmxZRzp15NAXFoKwgklPJTtpJCD3Hbr1qD4XdgbbXWsum40O9iA
	 kna1FMztSXc8Zgs927+/cOaAQAxvpyPQFpdFeRx41nNq2n+vEDup1zMK9P4UaistaU
	 enaUbH33yfSRj9CQOlL6sJwtNcV/sscQi6z9ilH+N89UebTBJSanvWfX1VDFkaHRIx
	 TeCQWkzm5QUQw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B9AFF8860;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:07:05 +0800
Subject: [PATCH v7 14/15] mm/vmscan: remove sc->unqueued_dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-14-02fabb92dc43@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=1092;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=nYfNvdV9CEi02RTXoIeJTz6Ua3OVwuJC4SglYki/XDU=;
 b=ymQtFeT3iVPi0UYmSf84OL3PLltMC+dD/RNFaNXKtoh8vcDiFERF6hhVpYQ7u4jhPRG38S25S
 XkVONkI9iGKAMo+/vc31PW17puEG7cruJSdfIWRNYsLpn1bIsSOWqAa
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94D30120007
X-Stat-Signature: 4c66fzxxo5dzf1ccmu8zxqszkt9qpt6z
X-HE-Tag: 1777313250-595129
X-HE-Meta: U2FsdGVkX19Rn34qpHV19KV2uHVcK4tu0SUXRTO6V9lbSJinhu7VhJAnTbBJYttawnCN8uXKydZF7xzsWXODDxVrJBB9EL4B1rQGYJ94ee3caRjYv+nqRkBqJW0TMH4gjjgGlLeNJ9ITKj8Bp4Cob7DfJ+uDVc7qy9BZcI/rpoyB13k/yrbGmHW+SE2E6Dc7nbGCXL1yt8yz6sc9wVmEpYkM3UGmh3zTUpm8tAwojAnGm7qn1gfXui0iOLnRoxY67QLv92abQsh9FYwip8KrnbwfU0ynreSlGO/pYzEnQn6cXJYtTOzTXqPxoCJKAAHpbzge2Y1AqObmVmN9V65W+MSNEDHOS9K+Mqg53gj901KylEs6pnhMzyvNPPxUNWjDQ9cXy/A7QCUlW9DmbyfN6oj+BC69wmGOOzTKoImNWZGTGWZxNu6veM5R2CvK4Mie6OZhGTHuDjnQtSFEGOHvlgY7ukYhMaHnWPAqr65QDP/fQgcJ9YW21s2ZwOYemRpMdvxOC3TmOBBMZtiiktWiqmmGKI3jZg/uWQ14R9GkmzXa1hQe9wosZGXkKRZjLPu9ZfQS0FtR77i29VUsb6/VgvoGgmIxdZ97gRCMJaQhrpFqNfPHulatEYBpQ3rpi5w+nrdIu9znvsPj+XtLSx9tlt0uyXvQyc2TZDiVoaXdyhiB1/fl9ZjimYIJd4HMzKU0ABuGls8NMQVqSkASeoX6nGxcDWqHRugWD/x6ZKbg/iHgk0qt8/vy13mX2Taq1RaLCv+zH1AXbhpXR/g6qh9dbcoQav2v12HWBmNMe8HxttFIxYVeo4YgaYBNrDPvtxM8vp0vSAyngjpxBVdfFI/b9zixc/RAwkqh6pFURTHuvwRQG5SLdxP4pVNAIu7DywL0aE/6JUWmsHBvQyngGl7JmfHNJ0aclnhZJ0SJFWn4MawPQ7FTvOPNun5Mwl7y2/lbpGH9vL3upMCwxaugivz
 EQiuEr1E
 0XO98W+TxltHDqZJPvL5dL65cZh2+LU6HZ/6ZaJqgzyJW38q7zIHbtxxnvVGMWDyxEMX/H8EtR1fJ1iIpwfzJ/qjFFEvnqpjwyxtKTmHfDVNS/JpyzSs3aWOA7fdcl9L1wb0FtdOil5Ma2d9Us7m3swr7Q7j3Me4vD3AS5pL719xO1dCiCnry+CIZSdz0dGaP8SMsrnTw8X0YfMybDqB5qxzsoxmmH1TNHwVh7Yq/BWL1juuVWaN2p6O9vsFDWAEd7VpKaSHUMt2ZZzolj3TiRx5/UDUat5mVxu28pWiawIj9qubweW2BHAaJ7tEH8zRyYBfFNWFGSrXb2co8CaeAJNMkZ2SmyS8MVSPj2b1eNtsH8ktr5a95/7fCd3rek+tymViR+hmwF7SFRI0vzw7wDxoHHpoAFckY3/MKxqcSkJ9WjkJ80lNWDFKui70YgfemiuIJ2TQHSz6WgmGbEvxiiyeMrCLPeY5WESpo/mh7TvcD1wwn2qQKtxYL0IpXxIwQi5fdQ+FFz2XhI9hC9N8AQGoVoxvbQ5yQpA+9l786dKhKz6CgyDhDHROzUtDxt97CgGnO10I+05yQ5VBM7cMDHFIq7h1nXZOxOtDBrmjetdvhGVs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No one is using it now, just remove it.

Suggested-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a071f7444232..902ca52ca381 100644
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
2.54.0



