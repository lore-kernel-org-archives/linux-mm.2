Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B5C6E937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B836B008A; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9E16B0099; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92F26B0098; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94A066B0093
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6010A1A0C00
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:23 +0000 (UTC)
X-FDA: 84650486886.05.99F73EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 709E98000F
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mYy687BH;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012501;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIrefV8q2eNxvlEu7dePablFgoA6gcB8ko21beuCTMc=;
	b=fBqETk5eDR3cR9fYWXoS/DqtFGAV/5L+wy23YFJhHPPVNIlJT4EVMxu6YAhJZmRTIDns3H
	RhwcBGGmnZLXsQIzh3cWEvyKm0rc7l9TGZWGYnRnnRexx6vjJpWDbOO6lgce6CIoGnZH6N
	cWY48VaLQHBnNin+t5tPmtTJ1t19cUY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012501; a=rsa-sha256;
	cv=none;
	b=j8OGWdL2TKwoYB2azDjkS8f0nJa8ALE4WwKgCBY5jGPCGAu7MU9l4sFTwbVxkC0NYFOs7u
	X0qJdzPL/GbLrABwJlFc9OWreRiDinKeEgaSdX7vZn+6JOdJjz3ceek3Jpft/wP3+j5wnR
	QS2blIPM/ykwXiB7IUfuj43qHJyWlKs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mYy687BH;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 935DC6133B;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2BE1EC32782;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012500;
	bh=wr+hcSLPsR0JuxYVFW5Y7utpTZ/YZawl7DSSuajsq8o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mYy687BH1F0ueUspoQ/h32t9dNYUtRyjC1wRovjKhePzwbRLzKvlWZZABBZ8nfdK6
	 gLHML5J0qtpIJrsvGhQqjgvSbeZLIuO4IMUTu8LxAUlB0jEtHeY4VYfruO3EFQd/ZR
	 UVgn8DNaXQgBGw4tgrmFq3T6HPwNi+/g+M4+Fc92/kRsmj28n9R6UqZz47mlVoTwuT
	 xe8lUIIX5KGbiIMKuB9PnCwPMLiFc7oUkmnKWMI+b7vc2irUjPzRqmgRD25AggmA87
	 KQxPc/W7Os1o22Lq4VvIamZC2xFsf/Gffw9io9MN6gPvrM7bMZheyX6Ve7p/AHno2C
	 x9JifYCsVl1RQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A00E937F2;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 13 Apr 2026 00:48:22 +0800
Subject: [PATCH v5 08/14] mm/mglru: remove redundant swap constrained check
 upon isolation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-mglru-reclaim-v5-8-8eaeacbddc44@tencent.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776012497; l=1702;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=MVC92Hy0dj5HALuLJgtd87f2adt8BuCL8uRItTw3vYU=;
 b=BdHwbQIBiS2i+6n+htUoGzfEswBTxEHOZJMTtoq75+ktgZsKvBSPgTLapV7ybRUpnA283Yuie
 ZlIaTuOtMNsDqzFxCpq1BrikWK5mt3l0WkfIiceQmkSfLAl43zkKJiP
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam12
X-Stat-Signature: a5bg3uczjypu6mh3q4m1zxswn4ynjzzw
X-Rspamd-Queue-Id: 709E98000F
X-Rspam-User: 
X-HE-Tag: 1776012501-375642
X-HE-Meta: U2FsdGVkX19DJtys+6fmgrC1aJDwQ9LYwwN6WdiLxKts+jBAg/AydlJnnfkkLT0LElcQqllj4vPpGcIjLvodqIJYELTOzNeB+3rD8debKu0X/QTrN2kPjS2akROGtbuO3pcOR3/pL3mR4hwZQtnZy6dadTDSafelPP/+GAxEwrSo0JtgrsCMAgp96ztgtftC+1yw6kryf90ddat5Xeq4AY19oK1lkO/YWbqnH+KglbmMmkEyJJv+q2O61TGVGCDn7J86aHCKjmW0b0lKZ1iQE7DZHnjrjLzUCKEEOs8XvVQ/kMeVAViEGL57A8Zf5HCYtamyxmNiBCEMmU1Zo+N0VZIHuAiUKknCM3Zdo6AXkxP/rHFcT+b0Nj3yeKCf9ADey+2Y9rGROf6ADxOFnPhXjAsLNfxgVLyxb9k6lxUvf/TSAVgG1TeXrbSi1EEpqe6xFlnj9JNtqGpLXfI8l/7UEnSv+N4qYLE4Cn01+ijDL3A1pMFx4FXPbhTPWhyLe2DeHpiTwhvR2R71sRw14nzjelFub3WBjb5PP0eFpxs54MgFAvkQzG/VJSpR4WpUNNH/mEcYaxGXbllTrHF/Ucc7OcQ/Sr+vrH64az5h97lolaH8hKtLHvGXNTXIlBhX7zZeJqv9j6gaH36Ry8ED9BenKZTBK0jBaOlEiyTJDxCCxIystSbf4C5VNkMpmq8+btIjGKEzG4Jg2n9mNklDiGmfq9vMip0AsxoWsWyhWbKyxj0Rn9hqmm3rl4MpK4H2zRrvkmbI19LaBiwnANmXmxjOicT6C+sHzaxVxhs7EAItU2W1nzWidvCnhC6DJV7MOYr+x3ASV8h2DYVs2b+xRAakOSc5060QFZcVdi+tYd81q1ZlAO2ao5bKL3nou4KSGE+hR9HJ+NAQmItFZ6w0S1uRFAXi0JIlH75ABkiDzqxWkpTLoMXADZfbgYZfpJKtlE1KYekTRYutfqG6O+E4hej
 ImE+h+dv
 ZQUVORvmYfVFeUIOyFH6MhuFui9EHV3eafns6ZuyYx0FhUWHOvEJgMUoU3fA7NCts28NHcvVX+NBF8TKSdKgEV9F1XdVLdtGU8lZbgz1/IMXZ1gBvuUkvsOS/x2nl0JdoYw/YAEkL+Lp0ME0WWAjmLpOvG7V+dkifAed9S6S7Yd7NTbVTqSgnevzmcdGgjbW8pQa3vUJXyAZVENMhrqKqAqLosfznmK5XyvS5jI6rnxfKkl+DlvOs6baYwTTipaJeiYT+84F3L02FJGZ5Xs9dQ4tW1flyQaqjQfKcVnkr8CU8I3sBgbDfsR4vtl4GcCUTpbempdYI2FaxZCqTkTsdQPrJf6hxb9GGL3WqKD6+C7LFnWrbQ+0xTnc/d1VYA/AO0iAQvJLTq6uGTD5DsbMCa3uahZZ3YjnZ9TuLLQIU8VnEkqtX6P5GHImdFsry85x1tKmxGJzLfwshg00Dl9MuRY8fx0+4ZoD2uKf87FwPHYEznIttyzUH6Gf/rA==
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
index 5ae6bd967b17..965d8905a4fe 100644
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



