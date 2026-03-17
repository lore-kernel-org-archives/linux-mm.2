Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99DFFEDA14
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8BFE6B00A5; Tue, 17 Mar 2026 15:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5776B00A8; Tue, 17 Mar 2026 15:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B126B00A6; Tue, 17 Mar 2026 15:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFBF46B00A2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF21EB616E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:50 +0000 (UTC)
X-FDA: 84556499580.21.64FC6E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BC1D21C000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lVVwEmJM;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773774708;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRmNwkNCP32rxmhd/ipdTNqGZeEg+GVkJjzDKjZ80RM=;
	b=5CUecp6OkU4Qh0fyv7oe/kx9ft8yWov4aLYSEMuVcQZtaz3Q65hEEjinSDXLQJ4sIKMUiS
	Zds8zeF5pJgK8DRBRa8ljSJg/A8YkiCZ8W6c9q+YIF8Ur7V+XSkNIsmv+GsncUJ4d07Rud
	ze87EORWRIcA4HnnlQRgPF/507i6v44=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lVVwEmJM;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773774708; a=rsa-sha256;
	cv=none;
	b=S8T5A6pSR/4pFyWG4vy0dRjQfgTGR4kpPx6GAljUxYOfjRHxzujMbL/llX+pdIeq0cfJYk
	gFYaEWcb83Xc3yBgy90zJuC1bUrC2IPZQ7PpnCRBeEiCiri5hnuoRWLqLJlAsFtcNyN7NW
	DPtoRTTU7gWQNupGdVWF1w3w/BqUGic=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DC8E44521;
	Tue, 17 Mar 2026 19:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7976C2BCFD;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773774707;
	bh=GcFHhw9QC57xarnRrtoQMA1XXdy9vkzhEI8StrL+fNk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lVVwEmJMjJ7eCRNC6OVcvoG1Jz/PzAaQmkZjy7QZgYZ2AjNYiyq3erdmZ57XbK3sY
	 pKKiUiuKHdnaHidKGVTMmhVtIzheprsvdlUbSiFu6OmTpVp0MNh0XGD0tUamN4l4LV
	 /JDJAb2O2qdLv3UWTy8jXOTQEkh9Jzm59kdwO1Rs8HdZABEe3umplsSSOaWOAGph4n
	 sCQJhA84K9Z7BsK57jbVN4AGaQtA4zvA3jfgikxue5gRPVCI4ddx///EOk68s4Ljmz
	 pab5T6i7mQ+r4Hwm+1a9Sz4O0wPJ8QNO8tELmMpKJKQrci2P2yxc8W3gFWxAh+i6iN
	 7YDfEmkTz/2YA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE41DFEDA11;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Mar 2026 03:09:04 +0800
Subject: [PATCH 8/8] mm/vmscan: remove sc->file_taken
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260318-mglru-reclaim-v1-8-2c46f9eb0508@tencent.com>
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
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
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773774704; l=849;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=gt8iOF2lvqV45jaXpQMK2rEjBoErbZaKLWKtqx1d/6o=;
 b=VXG4thCFCMpSII8Hv+Bkr5Er7SJWju2DheTxxcMlkv7dJns19gawBoIDz/wORmr1SKPFwXJ/w
 eI4rWv77eyxDt517edy9GAbSGCFxILfmwCOlkcTjfLjMo5Gj1DWjxs4
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC1D21C000B
X-Stat-Signature: 71szptbnnghbqb78nmxwsy5hawtampkx
X-Rspam-User: 
X-HE-Tag: 1773774708-602189
X-HE-Meta: U2FsdGVkX19AcGDzyfgcz97afhJCY7sk7gfNAWX2nbmZlNiTaQhbf4pZt2YVuOIT3sizv1banxP9wvtp3IkRTgQ7R+B+dbsY972j7LsWLioly3P98xxM6lu/Lcn+vMomJYb7Cs6bZjKDzEsLuN0dmd+mmr5acm9X0xuYBBhTBgXOwCmL8rOEDo82RHN12+Wl68dv8tp+jhLqNUCGS6CRA8GKVUSbGy+YeyuIEut4KDwHwlS76S+uJjC1UEhWS8nQOFRRYFhBc6DnyWKkne+x4kSYpmXJGwn+enXfRQ87hyDM/OjF/EEzHngh6xiX6JTRc2XrnBckuGe683XcyhUI/71hEFw8IA4yQTAtKG/2W0SlLvHihBQKH4BlG4ApQvyVYSSCIJkrzfurkiIoYQh0nxpwLgNFk9IQfEzKJ47M7EDl+aVYkxhayuPm+LrjkonfQMAAE94HIbLJe+yhj0GkrlbhH1xpyFounWya73wFyG9seu763GaKCHTlybMxSBiptyh020I+51+jiKM77m1nmGpvGjRDZmNhLnHeyMsZpTNqvqkaUgESvfAy70XKWsZkSztjyDYT8ihbVZEy1XBdaDQ1+uID08wArLySMDlAbVBk4rKgFsXqga5cnQpqEWXGCLH5DYSir9UlwgMzXtp4hhjuJgrwyBz2fChezbSGTLX2iUTtdGwATozd8ik2xUS4WoeJsZp0uqLvH8WPRZS4gM2OnYZAmul37Z9bZE9byENdFBc5N8RFh9/s1comjN7m1rpHC+W1VMS8JZbdiRwCxb57Xw6eRYSJBY0YzifnRoq8+WC+zbB7SburIAtk3Osehb2MjccJPmFUU4BRf9wZy4WgZ/rDRFtqv0F7fx4ANt+J0ObTAMm/essO57Ofj/m8CGu8hWhLreAc4rQi390ku4M+Ig6xI5iHn5uZXacTef5FlwA3e58cTIOx6fvaDXZ7p/5dhCBHyOLRKSb48Ez
 b91qegMP
 GVkrxjBZXYF+stnj2lW/l1gtdGP6SQuNu9tWeDStZ3oh6bJi5w/0RT3+K0iJaOxF3QgySCD5VEgBzFrLbtkx1g6al/sHasBQCJbuFAVNJGDnK0+UTLBF1T9gnsZ/NE2PYa0PZ68D3U6QkYDc8dqKkrNSeQA+/bAEMhEC53V0FPvU58TUnclm59KJag3y791PZLe079DQ4Omf7D7MkbN8wzlvEbiDK7BUtVwtd4RyAndvqmYhM1RVMAtZV71RfmcSDBKgL2VS1r7+tMEsywUrlMDMT5IldNKF9NtmEslv0S0mkLLZS/q53UBNLdScUMcbj0VQbJXualbDBIR6meRnp7sj+eSOn40go2vlAyQDCOX6tEnWSJQL06H14IBa66Fb1GXKm+J3FRolNaP8BNeWugPO5eq/jpWqlQn73E3wlCXozLUeJdndvWvbn7DBXMWOQ+h1Oxe/Il7W1GxJXZpIJjL/ZWJWDmA80dg4XFoDhg0b7qPIgq07Y+CsmZtspdSmzgiu5W38kNyFDiMY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No one is using it now, just remove it.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e11d0f1a8b68..b95c9fc17edf 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -174,7 +174,6 @@ struct scan_control {
 		unsigned int congested;
 		unsigned int writeback;
 		unsigned int immediate;
-		unsigned int file_taken;
 		unsigned int taken;
 	} nr;
 
@@ -2041,8 +2040,6 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
 	sc->nr.taken += nr_taken;
-	if (file)
-		sc->nr.file_taken += nr_taken;
 
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			nr_scanned, nr_reclaimed, &stat, sc->priority, file);

-- 
2.53.0



