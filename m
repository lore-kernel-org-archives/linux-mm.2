Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFD0AFDEE38
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8BB6B0096; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659E86B00A1; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B876B0096; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA9EB6B009F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8EC9C1B7B34
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:37 +0000 (UTC)
X-FDA: 84690542874.11.DA6F7EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 838EE100007
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZcGSnu1K;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966215;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiAJPeA5Bm1c2E5LPOPlyeRw/dIy3KRccOgHURmtV08=;
	b=ASbvV9NO02KW2FhCDiXrTNYDzsbo9zVg9OJRmVDW4AnnB2E4oiq//EAPiNBdEJ5hUGvGS1
	/Tq6IR7dWDXGMW3S976NmsQ5briVLDarSCvrGH12q11opkRF/VxHkDvqY8+g5cL4GAxX2U
	JpZO7/IwXGVCsk7yY6G1eIbE9qry49A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966215; a=rsa-sha256;
	cv=none;
	b=LdN9TB+M4aK09Ofmh9g2q2WbNSPUOtmo4cFaa7p6eRIRgnOUSztWLrmVE2ON0KhIlmbskM
	ofDfGy3wZ/G4VnzXpqN2EdWVv6rvzhPLNvJdaP+3pxgzT5z9BdSaP7xc/maRYWCPlXJqUH
	GDocSJ4uOSFKHTEbWz+LKOIkrRzFknM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZcGSnu1K;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 152294474D;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D86A9C2BCF7;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966211;
	bh=UfFnZDwx0HT6FyicEDwiV3SBywyLcuEJDUUBu5liQ2I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZcGSnu1KEwo9flVZ9fCXs052WEMjFRsvT/5B7icAkPUoNVgwFb+fepUH6IHG883yZ
	 dTtY1gpZA20o4cIdbN3KpFWbhwSvFpaAULOfTJvTH4HtBdbk7nxuFC9B5J4kl+oN08
	 D/jzQ5HfHjo5DWE0/IJMcweAINEyLClRvBEEo1+RtLmFO/X+8/rNYi8ytgDNSV9E0z
	 y+JdvTer1jVeUEGFN4MMG+KxazpMN/DsAbqh/y6fPeePKwu8RFqE/I+GmOYCdF7DMv
	 wMCrp2iEJr+ntkorY+Ar4s/PA2Fvs/+N3fwPn68Ac/ERDi6j08d7P30iQtgGTanTWw
	 /Y2Wo3+2cn/ww==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCACDFDEE35;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:19 +0800
Subject: [PATCH v6 08/14] mm/mglru: remove redundant swap constrained check
 upon isolation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-8-a57622d770c3@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=1860;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=H32ZZapu03Wi2OjXgn3aDMeoOd5F0TNj/288sMNJO1w=;
 b=MzmrT40vt0TkDPM/Ul2yLwYIcHAQ2t681GbOMYx98ZYwLoXXD9v+qCfrk0+ZSLglzQH3UlMcI
 QB7/oot0OF8AigWrOTEEPNWs0NPKEsbBj4z5R2NO/gW/oFCCuZqoZp5
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 8enjdz59f55ug5rzsrc7ysgm5h6eyu7q
X-Rspam-User: 
X-Rspamd-Queue-Id: 838EE100007
X-Rspamd-Server: rspam05
X-HE-Tag: 1776966215-785336
X-HE-Meta: U2FsdGVkX1/5Vflu4A1ptgrRBaDZRZwFfp4cFTfCAIylXfmHVBwUijFiZIY6I3DMwDE4Tr/3d3qsHcUh+eYrFAOxBsy9d9O/I7/TOsv0HAT1NI4is9whgSi642jNsjt4WTJvIFIvj7HCHC0aQvJsNP2rCW3UfhWtSWW1no0ioVRp80fWrZ4BrWPp0B9ClNAvVHclKeeE8vLjB6XweV0JjZ5AiUuDUC3hy8DQ9V3fWXJKfyMtKD/5xoyRPczm0TV1AR4+4oopB82K773JmUUngGBp04zMFL1SnuSxBdqxQjThYuhfTH8xYincF5wgI0NuCVFb6NFFtTz+UxfEQ4L5mF5ZaeDzS8z5ACSCg2TxygQSY65HFG1D55hQAx0CmaQqYKKa0HlZa19IpJCpPq0HqWHwi2a2bIoXMpE0SF7xsi9yUwdrHKZ3qtHWA1a4rgsD4Wa3F+tF8YXb5fxrBCQAouaSgn0aphQKSkXCHzHPwsfPdB2QLjOIO/uExe7410CofR1htdPrPKW4TWWO/3czOxft3feZaN3jmUuwDGwj8Mn8UrzmOK6H4D91qQZsDr4YSyiA9wgJVzoipbvyXUOmGwY73HN7goZfltRkCV1fMZeIAoHN1IE99fDW6eqTQVgVB+NQXzJrTBL/bniNMTNx4rhfQRAbim5EbNci/eWAtNT/5fGXOd6VKaKdQoIdi7XG+VqLoD4JRziamBlUqzqKIUcCLPiJbf2ZefDC19O+V5zI05JyMPs47OC8/zXjNzMFb5nuJCQmMTvSoRRlyaJsG7pLLx3+iDdAospilcPYTQftpY4CIV/Sb5lco3PzvKilEcLeRPDPpQ3c2595mIUSxcLXkOElYYEPp1DA3s6Pm41AZjIRh7XlYR27vAo+PfbXwrK/A+zZx43io0kdUETLAatZHhwBx0cSTbWSfpyMUDUQM3KBbsSXRgEqDlGwYig4Puc+AuB78UGb+l2kKuE
 z0pz8M/8
 a3KiVTFIgly4PnskzOGzpLegqVQDnuRoVlusQS4M9rE4uUxBHhS2IEwqKszD/hYWFG6gJPt4VS9+d0SPYpNLBUo/STnZCvm71he90pZfRyq8LiOF7BmV4zXhXrv8o0C+mNzmJx7O4ixJj1CDy/eeym9G87xZxwGQmzbG4wrPFYk6L438xRJBTzLM0uQANFn0dKbSyzYM78RSVJ2zTbJ19AAOMkatKbdaV6CUEGNFASi8yHHRyUxQIdwdm8qqdNHlySsk4EfRYKf+0FKYel/DDE5X0l9CyxNuIRWpDqQFgav/n30UKNDAuflEi1NzGIaaSyhJ+GfC1vA2/aeI99Xh/GU48PM5RHx1WHP0YuqAQMUubmIiKb4fIGxABQ5VgMH6gHb2k6KN66fexS8yYVTxq5LAA2gyRs1el8ZyKTPyiX9lssdjYiliiNTUEKOt4Qvywek8Kb9SVb374IiTcFZLeMEyMgVobNNb0FFbIumXl5RVIGoqGUNWpplJ7VJoSYFdN6kvj27VByEtvyebsuxaiAWvMd7+kj310gQFeU1MSv1kVs7u3Eug7MlizQvkMz6rysj9Y
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
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 084c6ea8910c..35e3352a53e3 100644
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
2.54.0



