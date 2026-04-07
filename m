Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB0ACFEEF31
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD4C66B009E; Tue,  7 Apr 2026 08:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86376B009F; Tue,  7 Apr 2026 08:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D95A6B00A1; Tue,  7 Apr 2026 08:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 703756B009E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:04:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27A138C42E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:59 +0000 (UTC)
X-FDA: 84631628718.08.9C66599
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 46865140008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HA+4Mqqq;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563497; a=rsa-sha256;
	cv=none;
	b=ahKUsLnDOrlVwaDqxEHg4vyppv1NDVAJ218+xl+2NhwJAE7E7XMCyDni3yP2GWtZjtXf7H
	y/LqP/8xC9RuMWQEBd871ZldnFLkq/Q+JRSN3219lwjxJ+U4qPOJWrZvh6lBBmWQs9omfq
	QPl5hxwGp1vkUQAwiV3WZEAzLoGBkJs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563497;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgqcBHF6LxT0MiDmwn6lY4cmVcd95j3AOlUfL6/GUM4=;
	b=aOsaxndjwpeW7/oEADEAMRKmB5etbDasSaJM8YQOcRuKMVsHRz2KrQkzMWpcQ43wcWYMFa
	DJQhlufjYLjcJV1lmOVhuI2CCJGGbcTFGVmo0877KcuBvlNMJCxEq4+taJ6Pi9jAR9LBH2
	cUhzmlNIqVe0Y85FGHb1S797L4Wub3g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HA+4Mqqq;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5547844714;
	Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28AB4C2BCB3;
	Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563492;
	bh=h3uvopwmL9Qlq/BEScjVbnTEMlwAjzwawTwVaOSJmaM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HA+4MqqqW51v1k586Bpo2dmnwn1QeVavBzI3FrwaSYZhFbXHkIDMfZNynxpzBsMG0
	 8L/4eYTEzJNLQYx8GGzVoupwi+ON8VM2kcT7C5TnIkBjHo8Ixdl3SOFZjrvceo3WJU
	 8X2DG8u4gJjm2wNSCLBrjunGUUAWsZibazvjLU+T8QuqaXqTF6z6/PIDBFfhAzjYZi
	 erk4K8/jDkGwSun/mt9ky/126Ukfy4hcdEfJioprIvKwh71EVy51O56uRAhLoegRG0
	 IWc/tW+Pi+Yyh10MFddoa2klcuhQG4cFgnWPgl1nuyknZht5NRysiGJNn7S3/XOLwC
	 R6HjV/dxyzm8g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20028FEEF31;
	Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:42 +0800
Subject: [PATCH v4 13/14] mm/vmscan: remove sc->unqueued_dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-13-98cf3dc69519@tencent.com>
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
In-Reply-To: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563488; l=992;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=t+bQPV8ryOa6wU3HDSh3IxJFeyluNIIGXhr4Th0dCWo=;
 b=aqzmwJTLY2I7PnriB7WIAsUemHYaspYAC1yP/aEKvmzBGOSdWoucf8WWE46goAMxBMbR9FnRc
 9nOVTD2uH7gDqcrMRLcfdeOtWdebjdvYyXUN4ygqlQTmySFOCVQkyfE
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 46865140008
X-Stat-Signature: nscxo8yor6cae6dkqyc3s316oq8cjcos
X-HE-Tag: 1775563497-440822
X-HE-Meta: U2FsdGVkX1+s9u4w3Pv9K0txPZwdEDoUZVOxkzlRj3UNy69MdsykMXfVwn7cDwK6CnQPBdJFuMvr+nRa5adekkQAU3yrukMk448fkluWBX9U1xixlG6DwkvjgJdPqhFaICm+wFj4kSj8uZEoy+nDtY1mT0s2RajAPixfpx5+s4xjKqK2xNcOZJyRtZJ0JEB3jZWhUZ96DyymcpWJ3YVj+D8qyEzCYKcBd41u5pjBvLPKMMPfyE3ZXVNw/5l4hBs1SuM19HLPNsep9sgzSq4MeqNfmJMooRyNZA4RS1FGicOSPmGecxFZYQh9qzsrVS0YbkoX8Xsh60NWgVFWLqGY7N7OYtO8dwS40o0/e6dCEJ+bNZEzqpVjGfPF2UckWT5tuRgyGTU0LxdMt9miRNbvqLa1GUTz1rijlOu4iudxS0NmbXP9lvqF3tXahZjU9+E1pi01Y/3tCtKUEl5qFBECOw1mC0OZmtfGrHWBuymM3Tka3fZAaRv834gFYDlEvNCFJaNRAeMHBCYFIZ4CH/rnZi7wJDKfOELQVHlDBISDHVSVT59xA/hyC27lgDBfA7LMbMR9HhYf22RCoT0h/rULFN3D+U8hltN+GOMyAJDOWEpz2WZZIWVYFB+Fu6ZKl9bd0+MWnXPmPHXTqcQCNHxPi40zGzhp/jeWhik7bJECBl88c+ItcRwJAZObnSaBvjkBdBGJNZilzGkNoMO0xDuv8CiJ6jyLWUrxregLBUcwsWAhPxZrwtn0sAJnKs5cSjGcqAd5DIWuBTPpMBv1ZTWkT8fiKZuXzVysbfRIIOpyXUDFqxX1lroLlGIPpG5hijAEHkuXUSUanc7bK/AnfY8gWbST2A/e5CigLnHYtBeV4DtBic8lb+in7PAFjfSaK7H14BR44+y8Yrpq7Wanw6iVwvvvMG8iA8QfUx1l6ik/xCM+d7OH5JDRpA7WOjkwphxfDn/TXTDSqa6pfzBuPy1
 N1u24MMg
 i2aAF+w6TLnYDc82KFtn3LVj+4H+CDEzQuUvl0DcQjSIxYmDssMaISptvMQtdKguHh8ijnZaCNbiE9AOWQrqfKk5mqHQsS/gRkZhpUvyM3RF1eomX/eEx8IP/rQyaJl+ogYDFl95nzvX9uRjGzQao+XXai74K+jICHUl0l7iRkOMbrDwfpUfDlxFA1rK+slhh6sVaGzuigJ3NwRw=
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
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 79e8a8e6555c..cea6df51dcff 100644
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



