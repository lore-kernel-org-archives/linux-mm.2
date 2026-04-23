Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55649FDEE39
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3056B009D; Thu, 23 Apr 2026 13:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08AA26B0096; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA1E6B009B; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B69A36B0096
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 721368B283
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:35 +0000 (UTC)
X-FDA: 84690542790.29.F497BCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 68F8740008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EYhq30Bl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966213; a=rsa-sha256;
	cv=none;
	b=BiRP1iXF1rbDw0G6Ie9VoBs0PbTNxKMJIN+u+O/x+beMNGO9YqpK/DkNGedhb232Ijfe/E
	LTGVyhKyMclcXLf5H/sJ36vkEHunOm261ZlgWBxiQy2q9dRQm2cgKFLi/WkBQc5wD9WpLR
	YAyIx+zotqzrwVUz+Txn5aW20ICG1vM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EYhq30Bl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966213;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxPDmJW4UR6uj2Z+mL0H0xBRO5WgRnlTeydYxQ4lNpA=;
	b=OGNxyb1WhKWTGFODgTNzenB/FFzFNbWsvrWd7fqQZe1Y91Eip4s80qG1dkiaKmcwstOdVv
	pmBPWqBnzXTkDFJDvEnS8saFNP82DldPZapk5+dDYPsS/kybHIQw1rXCFxhnMG1HLOU1u1
	P/QHNnHymeqE+8m7d65QqcTw48Tzl2I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E56ED44738;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B64A2C4AF10;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966211;
	bh=TarTl6ss+WmakAmq/MEKfFw+4eMYx5IBwqNdGa1iTjc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EYhq30Blaf4wXhaFic3nUgXcsilVKDLb0N8Eo22DJMfiiXsct9heT0zSkf+DmnF05
	 xtZfnbt3aKwkWzqzb/oi058//w5HE6tlUH3K1bkOuze9Y6lOeyva1TeadoGE2zpbyI
	 kQ1pvUwWri6lrRLBENdnLNqA1l0R1ZFTjX+j7k016oevwlEpFZTF8baa1usY4tZmM/
	 B6broJ972nljKwA8Bg5dum7mpG/nCY7EizaxofAhb/KVwnKhEp1kLLJcobtPth0+4m
	 qXoP5D/GM9ZsYR4jPlNGEeH/2S8RVpuw1154Q5ENX6EswVQqXx3mXe+XF7BUsq+Rms
	 RmNu87e6wJ/dA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFB9FDEE38;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:17 +0800
Subject: [PATCH v6 06/14] mm/mglru: use a smaller batch for reclaim
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-6-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
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
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=1039;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=prfg9m1Tu1GJeQ+RnyeWNB/GqbsjUBEqoBx+SgrJxbQ=;
 b=B0GUvgdLw6/QZUwnQrWQy2s99KbNhkSnfjCf1YfCPiMj/KomlU67xWV6/QY/zn21EX/wIU9Ri
 VkWjytzHo3yAfpYlKd2Rl6bn07KLo3k1PfW76Vw88jHwqKrwlJuD/6I
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam10
X-Stat-Signature: 15eujrg5zptou8iwzyadyco56j1rh13x
X-Rspam-User: 
X-Rspamd-Queue-Id: 68F8740008
X-HE-Tag: 1776966213-35262
X-HE-Meta: U2FsdGVkX18pxq8URQ2dF+e4pAzwRyZRJ2d63y3eRLOShbMyhvGemZqUHIWCaAP0EgSZW4/DvywI97+TkJXpTFJOoF6QB0EJ252K74wSIxVxkb2B3LAdJCXTSCf3pxYTvleloe42FfTM9OpvnB2mzFmDhYkvhQjxiJPQf7nbd8vA9JHp237O/+/yrCmjA9TUzPi5KFA/cT60+OYksuURK6EgrBXE9noCJQ5z7Vov5P04kumUBmHMDnjFyn7ABtnYg5GumAUj3DXX8xHj6j/WRrlB77WevyAFUCpBuum86ifAY4AfBQ4J0xFO69lhvnYfR454ddsOaskbgWDH1mYW1OdxhISIqL813BKQLBGNkRtTRuh1VIZNNgscE9Ny06gG6FwYmeOtklw7+8FLBdZ+zETQNeMTgMrzL/3A6o3tAPyGan22r+ZeyfP8G5m2ISQORvJAnEcM+UbJmnwI3n6dotwnuJC1pSuQzFC8WgCfKRCsXTDGDKVEBzYMmHbpYLoq2Azi2UCAIwjngSHQ56fiNiB1C2DGeYtlaNcWrkDwsYiDACB1SLjEOOrYYXi8EFE9hDG4Z5nDMwalp0NNYKm+xkYbP+HW11Sbs0qUBECHKH0YxeTQ+ITDoDGVAu6mtrZPnF5OUdKI2U9oKjntdgkSNmBRTcjz2VYkmFNC8v8e7+2LKuwxtq91KFa88waEGVLrA4to3JyfH64piSxgA5Gzz/ykuRKLSVugG5/gE3GHrZ8BofkxB5qsXpOxRU8X6xq7IrelL5Zzw9Ji3U4r7Y6lzsQY4louGWsqAyXihv2tfyyVQ1EsOrCN4fz4XwsoVjs3VL6ngUeAr1HdDtTxx8NbHcTVk9fxteTKYXqvXG/owd82nyXluePGqJ/g4G4iSapoWahO65LgoSjJ86gBGNSsmqcleQWFsr92kfoXTZoZYao1CvIMOGEMfWsWc7sQcQ38DV5AjoNH4PZVn+Youac
 9ZT0r7rY
 EJ8cv0d7fKKyD2tM/NL/F/ePIAiax0v3eCnnfzKhCPXygCLJoR7847EbnGrlzy0QcQT+py+YvavV1yrk1+949EHI05e9iblpeyDDF3kTOuyDZFggAweRnR4SEVZXUH0tcllAD3Ttr3767kzo2dGpcG5gS5oeO8g66kpJLeA/xlwiiPER2oq3q0hnkjjSiaJ3V0e/+3xDXggqfiG0VzFIT3W13kGYaDZPTHnoJM/bb5DcpzRhyybPsTeB4IAw5ozG5FImZVoPTa3wCINFALDHpmUcefErEGDIARmvWAb0ZX4nIJvUiTZCSg+3LESPiXrmbmgfSb+rBKiV6pytWPcEjin/GY+6cB2metKRxODYikyYWily8mWJF2RM+KbJ6Yqyc0aqBntPeMp1enT3TQvyYwfzxf4lk/VZM8rB5QiPdL88+G39qZm0UFf3NlifVdD7KDeoM6BgMgojjTXANZoWh8v1wzwAqheCOxfxetBng080RuI8o5DHAnjza2MjU0O1mEb0v1BxfAeHWoVYOUsic0roPliUaDRO1YcdTTlgGoRtjqHyv3IwmUNMo34ZxfyjRmRLG
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
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f021dd1b84f8..f6ee7ccf4e81 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5006,7 +5006,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			break;
 		}
 
-		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;

-- 
2.54.0



