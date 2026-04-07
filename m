Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C26CFEEF2E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D08D6B0098; Tue,  7 Apr 2026 08:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359AF6B0096; Tue,  7 Apr 2026 08:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C1B6B0096; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C08DD6B009F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 901D61A07C2
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:57 +0000 (UTC)
X-FDA: 84631628634.14.90D3E19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F49EC0014
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iiH+fePD;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563495; a=rsa-sha256;
	cv=none;
	b=Et1643k6GkNjqdBLsbjOfuMEOWumYBd/tU3oDpbpJy7JR6qFE+RaxP61W6oTySLlWEVA7d
	2S9TIq6Q5MDxFmmbmBpVMyrTZfhPyr9Ycx7oKwVRcpntvBWYvDk3ieSOvSAndQ0qHkTuPA
	kkgoJdr/4+Yd+wfAsKnPQWPrTcU50D4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563495;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNPY+EAOb6op6HjmrP3yASUn1z8McQ51bPpAKDdSxIc=;
	b=AFJdEm2zbCSdtudPLYHiVD7GoxMw8PLL+6dawRCAYqmJoZKA25/yRIGyc2Z8z2YRzh42r0
	LkjLxGSiXg9wJM1odHzhwp2CI4+xId5nTJc0Sui4UTpjFHQeUZX3Evxx8Gel5W091pxWAQ
	sd21FButgM9rY3j45IdFL1/G10dmKSo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iiH+fePD;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C88D1444E7;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A69F3C116C6;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563491;
	bh=gNOhspKKafM6N0nXsURc+vN/1RxmMZiW5gmwmDvQBOw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iiH+fePD64yyIbRKkiRtSPKf7bhZKcpcSn/J/KyJX3HCqU/dR6BYmsbXxkvWML898
	 l1DcQX8pOJ6d9M321s4jYeGXDa66sWtJ1j84GTGbA1OwfgGaWZoGlwkb+iI6W+BHJT
	 fAN5s7vjxF95PhGCwKP8loRjw2lqtKyYD17BBQtdsnCBlSS/f5QOACKRf/K4+DvMz4
	 E28yIT0f/bYUw1/Zmm0L+kl8GjsMJVL1dbEjGQG0nRKsHRE1zhLP8WFV9vADnl459C
	 bloKAtm/S/SDvUgRimElySGzXU6Jl4YUtlX7rJfHgV7XMJjo63bJ6bZazscl1ICL8J
	 scuRnGeW5SfLw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB51FEEF2E;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:37 +0800
Subject: [PATCH v4 08/14] mm/mglru: remove redundant swap constrained check
 upon isolation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-8-98cf3dc69519@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563488; l=1702;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=8QqmWYtnuzAwnHJdOy0QH3VxtrTCFfqleHPzwbmrh6I=;
 b=stnnipVCUvw5BM7Mfht/5ngS1C8fGqnhMtTfZsYkGl8C0WNG+0YMdtA71/LikKDgWLCLJxycr
 bjc6an7gbItCc7yQxHD4KcETzXtC3O8lTBBkFIwLIik3waNSiVls8jo
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5F49EC0014
X-Stat-Signature: e3e8tardksg8zdddtsth88incq36oe3a
X-HE-Tag: 1775563495-64200
X-HE-Meta: U2FsdGVkX18Py5FXCJXvkv7V+vRfbr0rEhwloV+OxBj4Q0ea990Cj3QRMSDvv9JSnzTLakzRVimIVpk3bnFddc3Bswjpmqr0j9VAU7fuRBbsmbltFcq4/askwmoTAibflxelNiYFyMTNg4okiPEscYpbCvDjpliMzhrx6BE7xooUFX/5Ma1uB+/us0ddVuFhfm9ahFfWsrApsxABGEVEi50MYSe7EGRcPiNzLznbMJbpoWe3gvhvkxYhAZrGkC6iTehvI4EOPU2Iua75HAPvFlBKNfCo6hmTbUNH+ebZUKmmOYwj2omsu2jGuPxPRV7jqUt8iPGhVUI0AoYf7/b3lsTa9hXIAJFdTv5ekwRAQEB6/tW+ZgcQzv5pTye9LewMALUX4u9NGAey6fC2vUIuwxKLFd5P4uHyYGIFbqaWYNmz6JGXoqmahsF0LUeWK/yurz+L+Qx+Gjo0EWTSQEZ+3PDY08yB491u38DW3LKc4qR5XnIFAZ6YW6St0dX3pPVyU2/mcSUSJX6TUAVDG9DS7d4uZIoptSiTht0yf9nDToeYhQbCtt2nG6axIxD1g/5VvKiIAb9MBUKSgfLdWd2yZfNvkIcAJ+WUGYluq8W/ozJawfQezPEaKcu9q7obN+o/e8jUhPBRjqSXDYD+ngz2Ht6ei8XpGLybV26owXotcV3Azl/TtXoE6itrI2+OSjPtT9Tw34PbKU5Qry82fsmZnBmJyrjovy5WSYglGUdHUaDCfU6E9pkAmdQ3gF5pCbd/UJhjwn4qCTkirlP3Dy3R5VueYNA5tDJ+HJrHVEo/Fnc7gFtvxFsEMV0NRuUeHdBT/YhCYHI1dNb3KyEyFvnS0hk90ezNmNr+6gXE5eWJhEWH39izk2f02q28QoloTNISzHDHch3XbLp5k0ZkL1uqnkCmhRI7pNYBMY60LLlfOMsFsHH86bV62dD5ZwC4i+Rrtk1VgjWIBZCzWh6oQ1S
 X4jHNGVd
 m0/mQv5seMkk8kVIDQEzuQtTKTtin/mBjhk1WNF8JV/B1nHaTLxSH35ylTRnViJTJom5B1ndb5HHlVEvkZRCYMyRuacEEeYSEh/yB9UtiNXfGLxmsAFoEsVFda5f7IpM+3MZrSfidyjZURHTYzMCMEjReU1ZogCsDnUP6kBTicMDehvyghdIebeEb4QkGN4NuG+16AUzoGlUW81kUl35JWLPrjBM7zY5358ftm+wFWyrv6FTqaTx4K/rd3OB5hlVgcLE+U9BQxfKYnudcQoPzLcv8temwANbXGPFUiqt0JFIdTz5twAzBLLML0KkcXEyU5nsZ5NfaUATm24sgB/gZLaB2LPpumW1L+RVz6DB+asWdc5u9MrjbN4tCi6WvLabFvnhhNojywxGKMDfiW0T+NDCRy6cr0mhG31b16eRS6VoSwqFKXD4g/LcOmSy3ybEOLK1HNCVhYr6PTiGsawtnKRqmWknaMnPd+OFMFWlO0Z5fVeSXOGJ3M7h8HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Remove the swap-constrained early reject check upon isolation. This
check is a micro optimization when swap IO is not allowed, so folios are
rejected early. But it is redundant and overly broad since
shrink_folio_list() already handles all these cases with proper
granularity.

Notably, this check wrongly rejected lazyfree folios, and it doesn't
cover all rejection cases. shrink_folio_list() uses may_enter_fs(),
which distinguishes non-SWP_FS_OPS devices from filesystem-backed swap
and does all the checks after folio is locked, so flags like swap cache
are stable.

This check also covers dirty file folios, which are not a problem now
since sort_folio() already bumps dirty file folios to the next
generation, but causes trouble for unifying dirty folio writeback
handling.

And there should be no performance impact from removing it. We may have
lost a micro optimization, but unblocked lazyfree reclaim for NOIO
contexts, which is not a common case in the first place.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 354c6fef3c42..b60cb579c15c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4650,12 +4650,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 {
 	bool success;
 
-	/* swap constrained */
-	if (!(sc->gfp_mask & __GFP_IO) &&
-	    (folio_test_dirty(folio) ||
-	     (folio_test_anon(folio) && !folio_test_swapcache(folio))))
-		return false;
-
 	/* raced with release_pages() */
 	if (!folio_try_get(folio))
 		return false;

-- 
2.53.0



