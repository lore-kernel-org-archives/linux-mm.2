Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A9A7FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DDD06B0098; Mon, 27 Apr 2026 14:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4ED6B0099; Mon, 27 Apr 2026 14:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C6D6B009B; Mon, 27 Apr 2026 14:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0C686B0098
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5475140264
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:10 +0000 (UTC)
X-FDA: 84705117420.01.6717353
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id CAD8D140008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B7Orrjcp;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313228;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGc0LkWkELRZP//1w4568h2LE+4jLl6QeB9Mj7SMl18=;
	b=3pGPvrVeP4NHwDtSjS68ZHYsIU9Ej8Krh7er770aKB6wNjAAA5NQNBg3RkSmOn0CJu0Dov
	/PVCEFtI3QElzf83ZJ68q7N90mJG9TQUCR1/HYrK0uy/KI6IObMQ01PsCupG3uExvnNnBR
	UB6+6x0u1lWVhFFjS4H1NiqI9Wsh1eE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B7Orrjcp;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313228; a=rsa-sha256;
	cv=none;
	b=fXRe7txWR7EgbdoQMo/vZFFBF/IuQf3GP6+RDnHu34aBJCCiRvq/ILP3fJZI/lOxuQtVhp
	YriAZNC+sNpSNBq+Yy+bFcvg6raUGgWFE9tx3z3xGjz+FVwdbqs2XqtmABoEBkonJlsaSu
	CgxnfchRyVU7LQghQ8WvBSN09U0zpcM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A97261843;
	Mon, 27 Apr 2026 18:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C4ECC4DDFB;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313220;
	bh=kmvumb0PGIIBcHlg6/hochvDVLMcvKAdlTkAkPkvOBM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=B7OrrjcpGvn39NWAoXBKJRoZ2J5TfqgKaK45aSA+SPslYxPxj9tsY7XC2wBYlloKf
	 HXg5Q8PvoY7UMhWA1jLuzwcwaXW3yGwV+UG/5Dcx9ieHRRkpp/6BZfitvEfhk6w6Bp
	 bgdCmbDxYcjLPtocar/W3qSGPDE7lB/MDBonus4h9OQUnHnYMdyTE79snwuBZQ8yFJ
	 fzdSQd137BMIJRV6rcP2vWoKQcUPptwQELhK+zDbVURO40ynd0KKQPKrOXkZw2BnZa
	 ihZOMykUj7lblAak04jH8nvfQBv544C3O4N89IenmKp7ypCIZIZEfUVFFOXSVmIXP7
	 hbGneh8BzEJyQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9336CFF886D;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:07:04 +0800
Subject: [PATCH v7 13/15] mm/vmscan: remove sc->file_taken
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-13-02fabb92dc43@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=1018;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=9c7VfboiDatsWWazTVjLAi/CqFbpKc1QmkcqxwyMdzA=;
 b=X7lkAO3FySIMO8Ir2SgVmPCmLlS03OhHuBnFLWiLfH9TXS5FnfC4TIDCkRKFWCR6uUEz+MA28
 qtDKliaN/SyAqUO1bJzHN6YDr9WsQ07RwN/t/2dmsEDV49tzrMpmKeD
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CAD8D140008
X-Stat-Signature: iwrhda8dubum13gqosk81ebiedfnnu9i
X-HE-Tag: 1777313228-570998
X-HE-Meta: U2FsdGVkX1/VudQC0M29Bnh/F60TNePJXTjBgmXrv9xVsK2UhkA3BnCXlYDCiZHVojw/ttFQgDPbydmPGuVrJt2u+eP0kY/0/UeFGZ5ToGlmZtV/tLovsJ4yOM0ALDkly2g6hOKaCAhcPw5Q7sePrlROg6Yy5OWiWx0PosMPWe1dGNXGQHErXh7uFqtDGw9blcABDmML+mOPhHfFux51RVqkNJyAmfOrZjgdsFB5xKMv/qHgIY+uP1+2JybX1GQKFlKhTEYAwJl+fp131hQZUIxwWVbhKlpeAUFYeXfDtwsIASIYFLbW36LdYDKvyEYwxEBK7h2W3BsjFEq1QZ+JXve4tenQpncyOC4PqpikMylzODyJzG6zNmZQeEs3Ru3smJa8ttje7BCI+u0YGtvblOTf3+jsd9Ybas5t8ixy0BnChp002LC9iQiKX++JW6NN/dr6tyQsygZ2SSQkDn8WajfOcLh5ic0NxxHgpO2Ef7mwTYUOftALCE7FSZP7bVstt+PCU8w2K9viXaYVdc2V1J/ZyySDuTphb17WayI0iwhU+5S28SgaGHM4EBKdQUzo6DoL3TsUEBi8zsFgn4vWbsNtDRwgew+3Gro/LfVfX2APFh6uSLRh2HTM23fBd89oszLOzw7NlS6ScwSwtrscZa0bgELPTQ9ogFKJJhkyfytnn46tBsGqC9gCBJh7EQbyq6Y4BC+BygpEnbtcMj2Qi9vmcDfjWy+a47hTIpZTvfc13f+h1t10SmWDrCVHb3oTfo1HCwXnKIlf7aIzm2JzzSjrLVcoULvMTHbqmsWGOk++F2nn9sWcJGAfMtpMGRsmkWlwXfFK9HRJ64E9X+WUkw77VKs/eO+7g8kl+AsA8Ovh/BLd0gh+wipGuoki8HTNHAGDmBRAekR6jY7FI9WzbJxrdh+iHRxbMv0ZKAKVHXMK6AxJx7+8Exo7gcMWuW/0X/3S2cSO9dLW6i+ID4a
 o2WW70jS
 98XFQbKhMz5MlaKknvZYE9zzN1z0NMwrn6erSDmcXPhP6+0qodz2M0VwNZcXRXikXvnc2EcD5FL+nLzX3BADhgINtopzS6XhbrWk2iYov5H6QmYTcEOo/+gHYxOkqKTNWgPoQoUJQnhcBnPrRsc68FCi2zqlk415xOr8X1AsuaikrD5l5lZ+1VJA0CHhr/RNKXl1Ijf/+6Fvg9tVdQCE9dJob5gwJP+eDMiuH/R6v+a6RQTMkKJwCS7o1wHXywynqdTzfXTC8afoZPeiUG7H9PZzqklY/u7CmqsPagcBLN+Y///LyFxrX/i+brwtWTn9VKkTqu107oUtPqNA/e6NXjauQgw/C2jxW3V8BXJxL7DFm3NM03dHPRkp9PsGu952K1Wqz70fQm0VBSsGIINXMEc3gAV8RSQEQ6fOC0jYmF7tkeGGyK9xF6EqOEZstyjyf/6XtS+OduQDWGo555Ol/m/8u0bP6pTPnwcr2t3lF9IwKqIcuPbrZQkR3oJtPygcoQmURX1dcz6uNfBx2eRcrMdSc9fnizGXpCvP4bHTt3cSepkMV8sPcUBOkg2QrTupevDWkes72tf6axtVN6vpeEBOBqQ==
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
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index eb7eb2ed1830..a071f7444232 100644
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
2.54.0



