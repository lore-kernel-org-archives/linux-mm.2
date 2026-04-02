Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0345D6AAFA
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 339EA6B009D; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29BE26B00A2; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7336B009D; Thu,  2 Apr 2026 14:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C32A76B0093
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A5FD1A08C2
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:47 +0000 (UTC)
X-FDA: 84614514894.06.B29ADE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8DD50140006
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YyGJbVsL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156025;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lv2Izha2cJpb74u9c4/nWh93mg3nSEINQfciSTI2WdU=;
	b=BX+3mIG0LczSSQ98XjcagxP0FnQZiYOqBWCmNud5Vw7wgf1nqU86AH2bS7JtyDp8pk2oRs
	AwSsVuxl7B4pp2g4ZjTydAGAmO8zLcsr4h5p0iUbcZPhKEQ7n4GJEQMJRfAKKUpIdskw9b
	BAAQzLicV92veVaTYVc7U1/hwL6MaXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156025; a=rsa-sha256;
	cv=none;
	b=DWIBV+J0nQm2/Xb1HiujDtnKvf0KBmwjLbUYza/nM3eLkrGTq35s/XJiJLn/KoDf02x5OQ
	p+VC8puLp19kN3qKhW2z31d8x97dF2NeLOdf3NOjeMZPE20ZMKKlTXlTS/8yKgkE7qFyv2
	wNGCv7vZtm+4xK7nMw+OH4rhvkbiwcg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YyGJbVsL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E7A1A444B0;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7302C2BCB3;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156021;
	bh=IYAPEgDe1ZC9FL2VLGQGQRai548GZydVegIAQogLakg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YyGJbVsLOaqsX7/m/sGgyQr/+58MOXeZj/9YxYzF7+zfKLiv6pCWbSqT2V48oBCNh
	 jHozI9+s9ZjvnMbuX89YD7cIEJlf4p41nw52ppWQyEnAa+xssAiDjYCQ2nWE3C6w0J
	 7xcDsqdRVbMV8EibxJ0Sb9GPxv2NuBiTEZf/Fe5Sn7DVhTQnWAlepGo+I7PpgmzbGQ
	 JrtL19GUk91Ke2JkXCjn57o2FbO7qNBUCFDu+YfRIY149vacCjlRb1rm9S+Fnpcyxm
	 J93BMkcdriWIoITyFhmoRUjBgZ8X422SkmtO++nJ/LNSDTg2LZm5M2NRk7iHsDK/iK
	 OVviwYmLXhBsQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A40F3D6AAF8;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:34 +0800
Subject: [PATCH v3 08/14] mm/mglru: remove redundant swap constrained check
 upon isolation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-8-a285efd6ff91@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=1646;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=1TfqZLNVczjhCnyip5hVhPMQqwJr5jWsOeWwr3Bdzvk=;
 b=ilTesXd1t2BD/bIF52H2EsuropqcuewGrWOmfkHjdaL8AkqD8RL1vxH2/gVtcW3I8zauOsvna
 tPUt+JQZf7PAtOK5rLkTU8LnR4Kn4yJVmFGtH21QztflnbfWDQspOoQ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 8DD50140006
X-Stat-Signature: pwmuwoga7aec5bxum5o81gec1qgom1gg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775156025-204807
X-HE-Meta: U2FsdGVkX1+WEw4T4SO06yKjPFF5zcAQVT+VYkIerLLciw7d7sgjfDmR7P0pU4o21Ac/3ONXjF8PjuzdvWkcX6m2c6xy1UBhFhkclFIyuSiQbrmCZ25ya7RolouCRcloFE2J5oiPDesZTTI7RXGpVAPQP6HIALpE/9vcSEns1Ed4jJXbfyN6sQu7+W9HapBKFumre+yQ3l2rARFBSN8kr8li9voo8Ex3DVK2E+vxu9ejlCpMKS0W64C7eOoePg9EQAnAf6cy4HpGP/Ez6TXtu5mdAlUvIK5qBmyW1cNEP4KjTYJqRrZetz0i/KmWOOdL/VK2XwslvVuopKNVymQhbpNJgqH6aArHRAxTJj+dy9f3746eQ0lgriktF31ScwqRDgv+mYv7feoyzgU/P3nsTd+R1RvwPMK4frdnpKedXcijiSftJa/gIpscX8/ddkmJy6tiW+rGHWa9YrKuWdEsG/PuWDhTYo35IifGaO6ahQEYHH8pAMcP4rwVwCOrvG8pEJcfg6oLFs1nx/4U4iiR0DsG+1ovZKK7IHsCHGvtuy1b/BRNdyblgVqIqutJhfloVa6B5AZu5ABLcPoADCRgPiENngAOuZtrF04hYJYB4TwlFYQztjNbjrF3XgmL8pn+2n9sP2VjOXgBtMRhPsSA7+RhcThItEsG0WymFzqdOqzUd4AYtm240IAAVuqv766EbKd1M+iedEmzwu/I1vVpyGRU+MaxAHHY10vEHMpUd6OOdrXhwJjaTM4CsPYQ2XMK8eMIEyUE1CiPYmo7HXt5rNlG4o1Owgbxf89YbaFpcK9puFcWr8hri/keT7+zSbyZdTv2QiCICxIXA52xuCkz2tzrDn8EO5nasndlLDiCs84eimYaVcA/QVgH2/nW4XmDwlbBLMpjHRJS22oub2+45JWaC/6huHK+/AupGjV+fj/KTkfsfqtzX9L+tD0FoVWw2sC90m9KrWkdVvcjglh
 IxQzoAbN
 AtSWPU9QxMVgGCCbvJTwPk9YprIULFjDZCl9F/q9d9gC6twxJncLXTrRiOD91Q1mOokz6D+9Jcf7zCJGsfktuOx2xHulbjy8RFWnpbF+QuWTrj1bYMTBy27fLgGgiaaFIYE63eJRyhyBd5Ra1ooOFiumDfGiLliVHRpQQzL5QapwU4pqmC32rKeQrRX83e/ZAyF7NGlEqMDjzr27rIqjH5sTz+aOIcA9Rkhtu76JXYEgatQa862dQbpx/B43UelAaNyptisVkpvpKrasdfWPoIG8p47Gwr11mQdivq4LDeludSb5nqbsk/ekH2xOA1X/GyyMkBcJYiyDoyRKD+lzUmO3G4FjVemQw7iZSmBhKRAwlv+GhazNwN+iukU3Bgkwt21Sk2SIGMr9r9qsFOz+rhK/qp4vicnQfnNAwQo8y0YyswzQe8Dq3M0uhGORM39oa/C/X
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b3371877762a..9f4512a4d35f 100644
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



