Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2055EF01828
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 832506B0093; Fri,  6 Mar 2026 06:51:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8D36B0095; Fri,  6 Mar 2026 06:51:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 746F06B0096; Fri,  6 Mar 2026 06:51:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66A726B0093
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:51:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C30A1404FD
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:51:16 +0000 (UTC)
X-FDA: 84515472552.30.258E2CB
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 628BF80002
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:51:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772797874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RNh0x4tpZzD1u1hwingNW1pNlgdQTcBfZpyW0WlOdo0=;
	b=sfAnNIxIxFGBMApH41gEDvPWir9Rwip74TwNsSIZgxWhxF3tHCaRdDlLQ7JWbyLMY0RcEQ
	re3KjFXJXIcc4n7LjWEOn8kIL8AhbNdcsvxq7D6Fw+QA1MkNUewLk3ynDp38nGcqYAZuRk
	EAYfWk5dYNgud69WA78hvvI8TA4rGaQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772797874; a=rsa-sha256;
	cv=none;
	b=8cK88ZW7ODmh1e6H8/KEbj3xCJ8a7DxbZ2ymDidKvGME1J98dsGGW5ObgDl7H0awgSvNQ7
	7v6m1Og5qOY4E1mmA1iA+INulBv+7KCHHCzJeeGDxzv+TzzxsW/duxpfACW/v7lD5D4LJq
	TsisWYfpafl7Po9mANNo9WRD1qzLg/E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH 2/2] mm/swap: add lockdep for si->global_cluster_lock in swap_cluster_alloc_table()
Date: Fri,  6 Mar 2026 19:50:37 +0800
Message-ID: <faa574174c297bd870bc7202feef9e7e41ec7d98.1772797581.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1772797581.git.zhuhui@kylinos.cn>
References: <cover.1772797581.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 628BF80002
X-Stat-Signature: bk9kz7cbeeer9fuyfgud9jd7d93z7kn8
X-HE-Tag: 1772797874-860460
X-HE-Meta: U2FsdGVkX19rN755f3ygES7ztqsmOtdDj6cq/hYqIGA67iimrXwJSChoQcOHwWs7C4lFARK5zJbNUxnHx2YfLYsJh3vHxiEkzfgOCkQA74cSXBzC7UOcSNuhn7b1PeVNy3GNox1GvLD5rdFj2CQjFkhIByJ/bmdHw/iNmv96z2ucNvncUa3Cp2xtEa7RWjKUfeF5nG8UiePRohAxEqbMPxkDFltLEdZUYvo64sKfpVdvUHzmgLsPWSKWEdikZEuIxQdX0t4kS+rZz3B9d1K/+++slZddKaqezKn4WBYkFMXIhRlOpYHRQ2b7LZsWC8XHqFw+IbawQwcJ6y4QOhscWLu9vG3T5I3dsl2Ij8yruhpAQpNYJSv5eOmivniSUPaY5Uvnz43h8Gb+Brhd1bbGwDMoHgDmMwusyQtUwydtBAxnV61QIxZ4nqpxcK9b08q7dwfyYW3/L/ReJoE2S4NUpVH5H1aYMM3Q4FmtaNIQqeM5gEDZq5Rs4IHCFm1Nc4HyvdZUci+TWsmjXBjrC5/Fo2FMyqhvSHDzRQT4ZMUALmcN6XtGKx0e9zA90UBVktv1AIY5+uurQ9vMxAsNk6ddmr4WDbNhl1yZeI1i5AAu8lyzn6RS6CFyxxEmNpNprLBwaoTJDUoOFoHXvBSP0HZ5w4NHWCcje1T37Hll8U4Dds6vRhWrNk0W2s0hd5LLrud3l/d3JnNq/r8iP2Fad+Ext/Aoy097+8wcyxk2ewhoqHiU3bUBoWI8PEnA0GTCOaqkNt8KsmBrNzRo90eCC0G6+eS41mvEsY7AXQX9lQqXgV28u21tTs5+FE9iRyZT10dTBpXGlTYGld4p8U8RQ1odfPxQA10iZFLh5kC4ruvMHM6f6S7RGFqgh2TuKmiuTvqI6syNwjPK33Hvq5HhUaS8oFjnPOUm4Px8XucjbmfhGpJKW2IJ/SoCP5TgO3vcL8u5jbjGfFmVK6Dd6JDWbvV
 3uZLHQ6/
 RhC7xHjfX7W5xjp0cAI4ACvWikS2xxVRkT1SrDr+arzL+2RD3PsRGNVf6nSBQrB9grGb3Zb8pIs9SPvd8A9MLMAgiKtVHmm1j3Ck5u9JorwGZGFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add a lockdep_assert_held(&si->global_cluster_lock) in
swap_cluster_alloc_table() for non-SWP_SOLIDSTATE devices.

The function already requires the caller to hold both ci->lock
and percpu_swap_cluster.lock.
And it also necessitates si->global_cluster_lock when the device is not
SWP_SOLIDSTATE.
Adding this assertion ensures locking consistency and helps catch
potential synchronization issues during development.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/swapfile.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2e8717f84ba3..1400a1585033 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -477,6 +477,8 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	 * Swap allocator uses percpu clusters and holds the local lock.
 	 */
 	lockdep_assert_held(&ci->lock);
+	if (!(si->flags & SWP_SOLIDSTATE))
+		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
 
 	/* The cluster must be free and was just isolated from the free list. */
-- 
2.43.0


