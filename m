Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B83F1C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 04:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24AB66B0092; Wed, 26 Aug 2026 00:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222616B0095; Wed, 26 Aug 2026 00:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138416B0096; Wed, 26 Aug 2026 00:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E465C6B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 00:44:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8C0A160270
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:43:59 +0000 (UTC)
X-FDA: 85142178198.16.F44C43B
Received: from mta1.migadu.com (out-217.mta1.migadu.com [95.215.58.217])
	by imf09.hostedemail.com (Postfix) with ESMTP id A9A95140006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:43:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N1F7ELc5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.217 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787719438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2bvytAuvGYEqs9efhtRsLXdWhJiexRreJOmqm0VjtU=;
	b=Op8WQLzVLxm3rGkF6yH7Au71+17kCnn6+joVqJ3glydu3Q7YiZhJHt13+Cir9Z6wMt+VyF
	M4jeMtLd1srOJ+TdMQXhp+W578SG5v2Ou9KAZKG/O/DwDCR4Vv5q4rn7pzi6lV65nKdS7U
	p0usp7t5f9Ag7DE0hbXqmlvbohXtV4I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N1F7ELc5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.217 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787719438;
	b=r0OAeuXPiglze4XLUAwSgvHBskgf5oQY2rZQXGmnEGy8P+5CvXM7XMfZaiRdUKU+Fb9KaM
	mxyM0+J72tHqrEMTp4G89Zn5/WtyX6XKFAlCNbBaC+Vk94FoO6nyHPR25zI4VWRNV5zlfr
	mXEftS3TGGZocTP/bDvKudyvgXpoQ2k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cvAC78os6bsdbW8XgBgcHaxo7gGIY2XAK7sGylBvEnc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787719436; v=1; x=1788324236;
 b=N1F7ELc5rDkuwft/4qHqUCi2YMlDHT8cTnKDePPYTtoOmiaUJI9pTqi0MoY5zq852F+pnxBn
 2uutfKIll2VbInhLzNRj7/b9ae5dYxwGlaC3/W9pPO6oXZ9kSpibcYAquBx1P2S6hbx4hqwNeIS
 bvspPNtns6RSmomGa09gy0XE=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id d945f1d31c09ef98;
	Wed, 26 Aug 2026 04:43:55 +0000
X-Mizu-Trace-ID: d945f1d31c09ef98
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: pedrodemargomes@gmail.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-stable] mm/khugepaged: avoid unnecessary checking for swap entries when collapsing a mTHP
Date: Wed, 26 Aug 2026 12:43:50 +0800
Message-Id: <20260826044350.24284-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260825192433.3185880-1-pedrodemargomes@gmail.com>
References: <20260825192433.3185880-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 947wc96nownmiuwjpcnsa9o8hyxdd5tt
X-Rspamd-Queue-Id: A9A95140006
X-HE-Tag: 1787719437-14427
X-HE-Meta: U2FsdGVkX1889OAStm32mhj9sND9O79dcrYyWndjj+nSkBRuWm7Iarfpck82rIMiJe1Jsk27//bsthnBriD9ST7tZeJ9RUCLwgxV1xJO3f1CL9DfqIG9RjgG9yfuuSuXF6xKeyV45rRwxqzrW0VOWFV8JGIsXPG144vhXUXT3Xim8KFH2yzXsdItrvAxOhsLE4WxdWUyqLkV4DdN2AQxxR3nhF/83YZqVyGyTt+EjyCE2i132S58xbMVVy0oeVVwW9TycMDhoOj7aU5LiAHULAAmwM5RyUt9PMtDUFw8JPBh0c4JADrBWz5tLawjsD+1HOv/iP0lGr3hhuCm+C6CZ5+6inMNz4hYyI6VizTHMnuTw+sUPYaB99gbYxAh54NIVUByJoCLYjMS90sSGMD68C6LjHW3PzaUNdk9NcjG46YdAvsXpkDDbciKJIOaq0u2gHaNIPl6HFgz5lTR7mVOZR0GfH/BTTY8T8CkbaKl4VGmAu06nQjimS6j+o7Rxq8TkrkUfuK60kMtsQLlkzyhwXDxlT8AkNm6xX2ZZdFqlYMc58KStOOkpxa/PvjuT5qoA6g9NbJJmb1h9ppZVZGm/UfObHRJl3yFZlmANI0QqmC3gU+IMqiCK7e26UqMLPMdKX7SgFG29gnNskDxm7WRXQd6i+DxCFtDq3ulJfxBQ+OE1RLSlFnHLsU3JXgEfQwExPZWBBIi4m+gctag6rnmEL12Gy74wivNRxtFEGdHRry7OuwsmyMzbuH7as5mx2WQWbu8ET2MNBZxGrU8tpE86RhxXTD6u4BwbZlXmHqug75fUHh1RGftwQXdOG9ycgFe+xQ/71qI/mlk0x0OG551vbbZaaOGhkiqoZcgmldA2DSi4nrlSgyb1JSz4ZKf3lIgKGVqEby0sxPN3JZk0qxpkbUzZP+sLobzilUCGR5kpacUzV1PiUJ0Jk3xJ01Y80+7TSadUlpKXIo2HbwW4fb
 JvOPj99L
 gG1xD48KZldkItlVhSNTTkBfvZjsVB2W2rlXTaRH1/vtDAKMdF3FaADwkaqFSUTRV9RDryrOiPUb+iZYAtT8TaMALNVBnpnmHUfvLhIFJZF4unX5DsdipJhwEXxB9pd3uUKZ52fnoOn+EEyzeVjArW7mlT//gOW8JlyjUAYZ7x/YtjViz71Qw/HA7P6tTcXJjM2Z11L5q4CdhwATM/UnkOQhl4/yQsDeaBIxMvXSvBvNdAY2g8wVFjLQQAcRuNRZZjrPIF8dZQ+uBuOrzNyNMnvQbWH8gZo7hN7R9Xon1ROmIUEjlxwkB4VbEtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Aug 25, 2026 at 04:24:33PM -0300, Pedro Demarchi Gomes wrote:
>mthp_collapse() tries to swap in PTEs when collapsing a mTHP if there are any
>swap PTEs in the PMD range, even if none of those swap PTEs are
>actually part of the mTHP's range.
>
>Track swap PTEs in cc->mthp_unmapped_ptes so that mthp_collapse() can
>tell whether the mTHP's own range contains a swap PTE, and skip the
>swapin check when it doesn't.
>
>Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
>---

Yeah, the code itself is fine, but ...

Any numbers showing how much the extra scan costs? khugepaged is already
quite a mess and badly needs some cleanup. TBH, another bitmap + more
bookkeeping doesn't feel worth it unless the win is pretty clear :)

> mm/khugepaged.c | 29 +++++++++++++++++++----------
> 1 file changed, 19 insertions(+), 10 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 11ff98d55c76..38596172f7dc 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -117,6 +117,9 @@ struct collapse_control {
> 
> 	/* Each bit represents a single occupied (!none/zero) page. */
> 	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
>+
>+	/* Each bit represents a single not present and not none/zero pte. */
>+	DECLARE_BITMAP(mthp_unmapped_ptes, MAX_PTRS_PER_PTE);

BTW, the comment is a bit of a mouthful :)

How about "Each bit represents a non-present, non-none PTE." ?

Cheers, Lance

[...]

