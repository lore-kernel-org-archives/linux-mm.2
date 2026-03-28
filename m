Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35D8C10F3DFA
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59FB96B00A2; Sat, 28 Mar 2026 15:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550916B00A4; Sat, 28 Mar 2026 15:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C2C6B00A2; Sat, 28 Mar 2026 15:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F12B16B00A5
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:52:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C56B31B714C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:37 +0000 (UTC)
X-FDA: 84596519154.12.5EB402E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B6FF7180003
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lzNngJ+m;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774727555; a=rsa-sha256;
	cv=none;
	b=GKsIokyH65VuYKpPIoKB6gVi3oqy+T3x1n/mPF3obHa65df+iv2J2yLifUQzFsJMnw/6q7
	DF+KEHeRBr/rfcTuO5vHqZzLB+tmJVDHgbiUV6kELVAZxefrrPpgq/NZpRjrMP3vKPcJ7E
	S50hfn0gLOaaSMQpl6DDRNeW6zh3vmo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727555;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FwzsuXE3iVEarkIDKcs8hSgbNwKO/tYW21nfZl/gHd8=;
	b=mvz0BvwZ0z3DYuBDsv2OPRF6RfEuABmHHEmKhHm4RpgDMFAAX76lISXr3DiwwUNg3waZSY
	te7QqEE9LocY19zMtlMQMLzC39TMb8GHf2g24ya55JCN9M8erj4rO3q5YQtJwmByZC+Udh
	IWuqOA76YTetWIeCIF/qk1yu5UbAKrs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lzNngJ+m;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F0267446C7;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE78EC2BCB3;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774727551;
	bh=z6gS7rKOYjVzbEw8wf/lZ7iZ7DzeY0whFy2eh0BxXLY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lzNngJ+mDis5EgPE/V5eP/miv/V7mNPBQSSESlPTAy3PKl4z2L/ZGY59yTmir9FgH
	 CO/NaCZQf0sLFMmCHcS9hDNc45z6H2LFohdQKIZ0+iDiHs06qVcQetXeRFLv5Cvh/A
	 XsKnOWfRABVD6nBGvvf4MbpJq2huI/s9nK17ZGFJESfk3gfsCH4BHaOZ+gimTgp2Yf
	 ZI1MADuKRGEOT/dZDP/t6L536dOJdv1fDQDuL43ZPTo4HkRCOc6yNoF9RpT07kTEnE
	 dnUveYbZt5H7ELcaVe0AfgtiZggOuzII//erAE9hVKpr/5BFOPGADmW1aPcRvrYuUJ
	 SsTxuF+KPy/3A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C628710F3DFA;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 29 Mar 2026 03:52:36 +0800
Subject: [PATCH v2 10/12] mm/vmscan: remove sc->file_taken
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260329-mglru-reclaim-v2-10-b53a3678513c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774727549; l=905;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=aelGzWH2zsHZbTrxyqLN4+nv11pcaWeLxFVtgV+ftPo=;
 b=GvaKf9oyuKhc9X4//LD/1G6jd+FGtlDR546f8id2d4VM/aBpTHzNIPHKhR5I1S+6UggcSsLOX
 ze2lI36K4nBAWGetOofPr3IVsiY9IPmHyYl4eb+cgsQxPyV/VKmWt+3
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B6FF7180003
X-Stat-Signature: yemh86z4g3e114xcagbffu1cynicp7wb
X-HE-Tag: 1774727555-289535
X-HE-Meta: U2FsdGVkX19CiWm+I2uGpSitQV3617xkdaCpcoAz4VEQYrZa7fzdI5b0THBdgPdOu2tfOmOt9EAy9/IXZ8AWvCkTSkNDDr4NXaYOHVGYo1htg0/YLF4UN3IzaYpHXYkHl1ixGrR1bnaEZyQB1fVgxUARwP7dmmcSu31Y1++WKbvTULjl7mjsEPZeoZXFop8OB70ZFiN8+ezpVoMmjx5UodXdUU2uWHsGVL7XLPKo3LPbN9e8h6om+RzXvKJWu1ZRadtvXdbt9Cx3DXyk7eJ9BkY0C+fzJKsDAo4tjjROlhmSBh0yHfYGMnZD0Wpx4WOSpotLVJPHBYXnOCVKDP1t66OYgNhdSXEagu8nIcDa7ZZow6/nT6L8E8isK79e3wUBBXi+UiUtQELqnWjVoCHW+tB4lVJzc76srUS+jEFpAwSvutLST9b26lwaPmfikHMntCCNVsP7f2fU3a1pD/q1z7x3pqtwNwTEMbq32Ptvh3UCauqbIOg5u7ESoUueHuTEnwkz804JX4hNCsIU+aNpoiPGWBY5o5NVewuuj3vUQkZZa7AeeEg+V9QCTKFx6SBRZMrnFpk+3RrNGV+uag969Cysn4xYYBQAmszafml6fQkd5U/bNloBjH02PTi4jFK6Ozh0gm4OOUYp6MWo6766UV8SMXgCLrLR1AhRMXsY2+ZPbnIWxosIoBu7EduDUcGXSHhgHLNCa1U8HFUptSLGbb07c3NLLlYqzV0OM8X5dR4Vl4InCa/xzioyr71qvpP+7O2Ryc6QNy0zJJY+0rn3U5w/AioxMn9rL9dtrwuruI6VSvJWWiT+k5dHatlupJcHdsjWeOQ8/JX66dZ9zWJdE2998Z7R2nm+Vp4oMrqUpW4D9cdTyhadVXrVBfreD22K6BpmmAbRI5qUWwnICCLJI2BWT9SsbanEQgnXIlP7X9BfNG7l3C+nZZFYf2DK+c4hN3xBeq04S9QimYopKjn
 YOjDg+E7
 j0bfoMROgnHq2mJCIuv3NzzALEfeq43qVEtwMuzplcuYmxTLQBgfMt0hQJwCg9JUJNeg3x9etD+0mrRQdX3iS5/AY9pckDGtfrHuhMK5EkyWm3AdEIH1j3y8m8mb+TOFpvx0YAH1z3nouIDEQJaLqWJ9Smd5k8+kjqpUHeJ13ILH1OIbIN/GiBLZQBq+3645wSan8QNjP/VtHe3FhdyqwgBpnHuU30u9ZFLWcI8O+cLKdKGhfCor2jiINUiMvSSYJg6Zo30qd5qbt+R6FHpve5CrW2FWiAP6hiZ3rc2RkYfu4tNGBpQTbvZznX/Ws3A7YBNW8RlvxnAUdyFFokY8bSznbhEX0xcPFF+l4faxivfAgvw6tTndSFPC395IsVAvL/yzPhSuy9QnmShdWv3yPWs9Orw8v5Emg6IJcbQEYIEROI5oIw7xmpFX3fT2eZTTd0Av+knhatxYRuqlfPSWscFuAskmBRiqdBFt8HhcNmGyvyIH0sl9BOnzryuP7wVdRhnqvd9R01XomKk8asbDkGg+XU7Rdh9o0gnli
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No one is using it now, just remove it.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 07667649c5e2..603be5ef3ef2 100644
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



