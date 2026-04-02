Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16C1AD6AAF8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1996B009F; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5B56B00A0; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE606B009E; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EA40A6B009F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3FCF1608AD
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:47 +0000 (UTC)
X-FDA: 84614514894.25.B15EF22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9D2E31C0002
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jandxikq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156025;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VCV5Ar+Pt/Ss8FbwqdLzqHZtnoadYuqkYfOR6mYP7hc=;
	b=OoPtQExXZXUsdvxCBwTvyKCC8keSZiPvwAOmKnVh6TfGEb6+BrrNpTtyuH8A/LqaY/Ubii
	cdoA4z2y84nQJUNExe60gzD4D+KOMKZ1CxPPeiIgfS+cnYoDIu7pUaFfN4MVbxSb9+x68N
	AnBs1QoBieihYeppi8u915vpwa/b6ZU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156025; a=rsa-sha256;
	cv=none;
	b=iAvaW7iQ0RxTshjthsoQtV9VGU8pQnk0COPND8TP1FW1edXGMKObIpUG8gsKWRTeB2uGJW
	Q2/0ot9o1cOow/uy5165xPElpLnpS+OOF2pNYrArPRCCDpn4srhLc8/RjjKoITPT8CiGZG
	GcJUlVou23HO13jmgWXnHgFo1ZGIqU0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jandxikq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B4ED44515;
	Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05CEDC2BCB1;
	Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156022;
	bh=kEHU1oiTi4HOuZjIN0Q3QHaLoeVjFYQ12m4ZGtyl71I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Jandxikq2N/GzPM+KNbXoqxQPADghjlIqCb855Yxo/T9eqVPi8eTJb76D0Nm5MpdT
	 b35I0ghny1YqOL7F+EbOVZm9OGE90EK0H52nryBKb5racpcKR0PD9kDgOquK0cFHBW
	 47Ju22ag43rWGHSle58AOp+HpJL98m4v5CUjvp+s2YHnCgmltGKuFD3yYEpCF7MvHr
	 4StoM6E/ADDB0myKhDCK96nzbjuouz/3omiHvrL7q6iRjdlbuYWPUj1ISTU6AWCBKG
	 +yLUXmu4S2qb5zYjbU9p8aRAe89ENUq9e7ajJ33EpLV1BHIzjWV+9hqyerKTS3tXBW
	 /LUjFfe/REQFw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6B2D6AAFD;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:38 +0800
Subject: [PATCH v3 12/14] mm/vmscan: remove sc->file_taken
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-12-a285efd6ff91@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=963;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=s/6eR1HUxQEtsk5vzGAFWPh5At357cjt43p3hyv6mmA=;
 b=69e68elfhQU+7zXdXP8fyodqmAoT8tWrsi2kngdIzTsXBRzTSINE7eOycRLPyVfpDkK6T+Xow
 fxVTwyWSWdoA6Z+4Ep21Xzj0dhxYn0FdFagt3ywo9vhonHYxo8ayx4B
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 9D2E31C0002
X-Stat-Signature: 1d98w4ndt971hwznzfc9ft164ico9rni
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775156025-655708
X-HE-Meta: U2FsdGVkX1+fjjGMgi0+9IN75UqMdgPnyL8T+1eDgnlQN4tASURGBGHHBFUAWqxscbzgK4NM6L+a+nFC9sakuySwmZK7Z+vmC6wQ4qIt85b7K+k5f9pTTBYJRCpMIfihe2EfHHKJUwxrKygkVZxHd79y6/rhb7neEQVocsDcSr4nz/UYsIkCpLeREiDdYTebT0Qep0Rkbf8fvRuO9dzKPu9CS/hlo5+mP725tf2MV8tY2e/JS47ByykyxN7w1PTgtaW/8fQVl/K3lvhdsf7VHeUuwMbpsRQBkgWLQRYR0SUbGQqlTByAXIq26eHKUPi1J/4QoxSwLAMLyTKvvBIEvL0m3JIsgcJmsTkLC7I9/1r61XF81fbLumjrjRyl7Hm5IwFQQsutmEYm6phG12l3FBQx54MshY6lJqgXo39XdWgUYt238wHJbYGXeruHmk6vGsCVj9GLwma4HYksrABKFph34Z8zOVsN35pH6FQqpJCMn4WiGm/bERJvBYyL/YeJGbfmMIwgdZvnVGwc0FKbjK5VzO9it6pNs3nRiOBhDJ/o6Kzqo7N0yW83GdH4tLo7+BEOtmV2Hi1mmXBRQl8SHvyAu+s4pg8C1Uf6EHozAiBGMiRWtbo8OkuLIHx3CCSUP/tRXBGr4yAbySw91RpqhC3yybRzUn1uhur1rz1x9vkly8EyHb1JO0UxaCWq7zVrUjHORpjQQ7mHxFv3djFtxBTVNKSH5izpy2+9zG+WJojPc0upJjyy3xJV2OOeFSguGIFntPvvdTV/alMSPLnaPSV0Q+fYbXEMv585WfKBH2gp77zyyKzcQ1yBLy4YSGcZD5ow9j6ES2bwMxZZlTDGF+0fDUlfAVycU0udBbLL8vXOGFFxLJp8wOGS68BxzcnaVMX+lBawgZyD0p5ae+L4zm2PwlyxixkTsk9vVn0M/TsOV2IxHnueqUpb0Zza+bepLaToZYAcgCs+V+v17PC
 bvntHBkl
 f20Xi4kJLFBZQFQPYoA83PVzpmSeIAkjpnm79JUyqHfhIWMTodR6Qfc0So01yzTJhuvhEcdjGADobOnz165bw3O9ncP8wPF0ySRMYKGlj+OLUNW+lbUW/OVlt7iE5UH9OXRm68U9sOOiCFjgoEUi9XkppjCjGoXLEMnsXllKYHZOtlLJh7iqW9hKqLGZ9s+QxbKgnimw+Di1jxOEj+t3xd9iRqAFFArroDFgYnsxsYka5V/dW3EYzRFRK71kwtEtvByLYr2aYKheS3nVzntpeaSl3o1DCYXgWInC73P/IGBuobkcpp5lXSUntJKjpyck6LbRe2ZNvpOrjdPQ/6GYkyJvMj8WTk0SjRSkLfZIBvKjrFhQn76uHoWHE4++M9Gv1nYFfNBCtTP5TPphfUA8FAAmDygVvBs535y0STIf+H/+omw8B7dABQ2AzfIdko4/gO8EqBY5VNIj2jVkqCQzzSb5JsUJb5DrQNNLcWoBSN3OI0bT46VW2PO8ZVQ==
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
index 9bd0a3b94855..e4f27fd22422 100644
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



