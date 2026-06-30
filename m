Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD13C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C8E06B00B7; Tue, 30 Jun 2026 15:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 152686B00B8; Tue, 30 Jun 2026 15:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E456B00B9; Tue, 30 Jun 2026 15:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC7016B00B7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 069C5120609
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:15 +0000 (UTC)
X-FDA: 84937517070.29.F2A2A22
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8159910000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="xbP9/VeK";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846553;
	b=aCYDvxedsOpaLmAhaNlrSVMe+ojkmcro21ItwksMNSeydiN6OLU0v+Q5H9wUFE6KPWck9/
	6Kal+kOzdExQBJD4kjYyNvRaKAwRIQUoLdW1EstGVGlo6MGbDo3YMoeKz1GX798KlfBiZ/
	cn/3zHinY7RSzWcrd1hAciEyBIdJ75I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVdDh/i0Qoj61MXqfLH5G8oTfqVJrR+R2Vzd+OLqy/Y=;
	b=7/B1EK8+e4n29sLAYgpUjDuzyO1ebatcmPmMbn4FAal+SvRt9tYDvb/jarD90McYjc3USZ
	VexdZRGpieS5M9ZX69/1z8O4C25maPWxBKIwbCHDJV4DgpBGkYrR9+GY7rGHEhxBbPFw41
	YD6mJ0NKe24iAR5B4J37kbqjVTC38x4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="xbP9/VeK";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UVdDh/i0Qoj61MXqfLH5G8oTfqVJrR+R2Vzd+OLqy/Y=; b=xbP9/VeK8Yg5UT2PWkYOw1eEHV
	MVGGeVY38zzh5iUeC8rnd0qGODrAW5BQ9ysV8TIvuHihzHvjDnV/ewRRi5AO8iLudyc4wTCjGOyDK
	nPfOFUZwqAclgJfw/ina/4EyzU6jE6pTTBAjQJXQsgkbt79zPBCmRps96NfWHFcWYasIUC96G+fvj
	CmsmW933crq/+nS2VOtcLBCZAKO0lwyPI1TqlOscpwjoeoFaLH7FSnStA4c4TvYRM6gXpxUw+5yHa
	lKICN5vXvx9QT/chF0c/28qETvjcF2dBuIsnj+xbiIo9rk0Jy8eHUtRLz8LQmrhKdRy3Zm1rkUj6b
	hLVgum8A==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpY-0000000060B-1fHT;
	Tue, 30 Jun 2026 19:09:12 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v2 14/19] maple_tree: WARN_ON_ONCE when allocations fail
Date: Tue, 30 Jun 2026 15:08:38 -0400
Message-ID: <20260630190843.3563858-15-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8159910000C
X-Rspam-User: 
X-Stat-Signature: xqwdxs3xtaxo3635wfyy9c3zdq6y4wfe
X-HE-Tag: 1782846553-278343
X-HE-Meta: U2FsdGVkX1+unZ7QXneq75wi7DyEuRbkosZ+yAcBjiWLTfwhvXN+q+LRwPKvw9WPeWBt+RFOCGCC6NxN+dV48yUlR4meMSJM/EQ/TtaX4Y/DGc74y9TaMo44+Pm7v2w+tx06VSerBUn/lLFWK9bdyC0bkzsXC+SnE4EeovYAU9qxgBXhYVAufIaCKlX/onTByoUpYhkthj8foU02DgjLKrZ1ufTqxUHgPd/g9qxe4LM7WDOUtD6HhliHiO7xAIMP85MwmO2feeuryfvg+VmyI7Fsyk5GKBqrb7bC18zhSnpDOhQGiZPLGV3Jlp45PAfAc3gYmizFmJvyeinfKy6zgNxiZv+wBO33O4jvQKG+yn/1uCGT8lBp+B7xanW/iHUW6VEclyek7vgWDBvQj9lnksmpp6r+CqdeRrekypp1fRE5r/Nku0TcUb8UBdE8J4R0Hji2dB/s7SvKoPKbyPUyJW2xkFUR4IqB4/FtLr/lVrPadWax962b+j+KbMiKrlSxtUZaVtKXrqfao2JrRny9myfxjN5zw6sZ4lI8oFrfSAdoXT1Yxq/QrQc7AJrlZTub5CiSLPnN7NlvgXSGj0niNSsSH/VF9v77+pJWLpap70LQzyvvO+xrJtqlCweH9yLLgGjEogAJmCkAKAv4QIKbGqzNd6NsqkctoVrVpPVmHIsRynSup1jO3OHcoGnf0XqjmN2mpoEswCmZACxAe36Zbbs5CfAwi5yX8BpQuYjv16zYgI0feHHlTBpupydAZgM1vns3rfKuSHYfyKwEDkTh+548TtfFGc+7My7bTg8YzGNokfWv1uFar38yPT6O97vSVq37GeocjUIcSuUGDBPnUWozk5/J3xfReB09hDkceTxowbQPtUrUo667GPQOKlou57zbL8IaIj4Hi7dzHBD/PzPtPpCrLDnOwtv/rtths34oIpLcAPbrDY4syh4b0YjuzOxx3+siV+ujvZTMsWk
 mFR3mZO4
 H6+mapZ8gnny+A9dilP++4r5zG4cT/BbpBjHrsiywMQZ2U2yisy0085H9XB7M65ajB/Zf+B/oNhlAiseKABFi0wFSSzGGXHQ+/+pQuK2v2G2g0Rh6csV6VPwiSS3M8TJd9lrz2kyiqQ9c9Pnr1ScDDFuqIWWDGA48yWgHoyO7xVIP9cSkD+rBI2STTVKPu6EzBi7xO1y6j7Eu9w2DHELhk1a1Z9HMjFqEayzY0EecXLs5YzRxU6ALNowhJOa9w5h4km1Ooo3PTNVn8W+9akh29iNMT95iTnmq45/dkgTCLKTtgd7oxR/zhQsj2LFlnoA70PlQR44I3qjDMOQQ1qscTlqcIrzBWw+egmVZMiW9+AxzjddHUQmrFvREFA3DDGkJN5EA91pwRXMMS14PPFdqEjSbs2+ZOr1OGwXhRLwd4wk6f78SvqyP8gaLyJNh6o2uCzLaKna7FFZRniU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allocations should never fail in the circumstances that are expected to
occur.  Add checks in the code to ensure the circumstances are correctly
set up by the user and warn if they are not.

Also add a warning on failure to allocate, which should never happen.

Cc: Rik van Riel <riel@surriel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 15e8081f61808..afe65ff0f8a6f 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5720,6 +5720,10 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	if (likely(mas->node != MA_ERROR(-ENOMEM)))
 		return false;
 
+	/* Allocations can fail, don't do this. */
+	WARN_ON_ONCE(!gfpflags_allow_blocking(gfp) &&
+		     mt_external_lock(mas->tree));
+
 	if (gfpflags_allow_blocking(gfp) && !mt_external_lock(mas->tree)) {
 		mtree_unlock(mas->tree);
 		mas_alloc_nodes(mas, gfp);
@@ -5730,9 +5734,12 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 
 	/*
 	 * Return false on zero forward progress.  Partial allocations are kept
-	 * so the retry path will attempt to get the rest.
+	 * so the retry path will attempt to get the rest.  The failure should
+	 * not happen as we try our best to reclaim.  The user would need an
+	 * external lock with a non-blocking gfp in a low memory situation -
+	 * which would have triggered the first warning in this function.
 	 */
-	if (!mas->sheaf && !mas->alloc)
+	if (WARN_ON_ONCE(!mas->sheaf && !mas->alloc))
 		return false;
 
 	mas_reset(mas);
-- 
2.47.3


