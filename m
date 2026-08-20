Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D8BC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E305A6B0095; Thu, 20 Aug 2026 14:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCEF26B00A0; Thu, 20 Aug 2026 14:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAB466B009B; Thu, 20 Aug 2026 14:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 819676B0092
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11E3A401E3
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:31 +0000 (UTC)
X-FDA: 85122551262.18.D0BBA2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 147B62000D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tkTxKnZQ;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252129;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9Fhv+FbZeGc+bAxM8KKbzJ7XhP1GndZ7Q9oZ8Jtq8A=;
	b=zUqsSCCHiMZBXG+8Jf+SdZIRjLPk5vW8Jl/SYVR4PW/zumzdQ2x1eIw6Wn6Uju/S3xOkqH
	/3MGkZT5/qhe+PFc47cgCLZNXguwDvn/5BvYIRcjhTK/rd1IiouIRQ6XUozHPLcA6dSjmx
	x5N8kYzrgbzZBGwl+7rbrmXDg+O4VYg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252129;
	b=Bi0YB5XiAvHljEA+KT9oCuYYJWDrjKXMIFRRWjFJFNTsiFMtc0ykvCz243vP2qLNuWlMVA
	XTTZzyJCutyqJMvy21Ulx8hLGwjYFNSmKsBJ5NSlS8ZpM3tYaxcg0hY+rmYNGETeWPP6hE
	6mPvOxStppreMunBKd+z8k3qK3erS6M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tkTxKnZQ;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5208440B2;
	Thu, 20 Aug 2026 18:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D297C2BCF7;
	Thu, 20 Aug 2026 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252127;
	bh=2OHip8UwlIqXDOB8Lnk3JZ3NJ7DAj/dnNPtoVJTO4mk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tkTxKnZQF8ks7KpBRo/MSTUbj6DR4NVRFhBZkahAQi+MrMC6YhGwBqNI9q7Sf0BCP
	 P5GPN9yk+lO8Ia1f50sw/8BQw0HSQ8U4w7gRTvLOe89vquxpSDvwGGYQ4sb7F3T2uv
	 cuOwh/4VDy8lxxdtMgJU3NEcQkqo81qyyLD1xYJMpRK40Y/MEtD0n+VGUY3+a8ATD0
	 a99L9HU2Cj/ZTSdqc51Z+mJ0ZHLI8E8gEt7vMkTvMQiLDBQ/QajiBngNCtRGjm2Xg/
	 mjZKnQsM8uEOQGulIvWlwlbN6RKsdZcXoic0yRhqolwdpkf9WZ457tcdIPGMkJVfgL
	 6fxnGgvmJJXBQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1D2C5DF86;
	Thu, 20 Aug 2026 18:55:27 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:14 +0800
Subject: [PATCH v3 01/18] mm/swap: fix off-by-one in swap cache replace
 sanity check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-1-9b43f5163238@tencent.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=1345;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=tJZfyDImR2TdvWcvOQ8ef1+tGYyooD8eF/fUtRm/Q0c=;
 b=d9mOmsd320+dGuqxQHJsrYoXje+bUDhlcIpN8BhavuVVPbwWGCjmKk9zse0A0fLzPDfLEPK/O
 7Yzv7bhliBuD4WqFvIcWLzhYCDddbFGyKNtToThkIKT1wICanBZz9yb
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: a9ipfjqxdheii4wxm6s1nje4twp1oaom
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 147B62000D
X-HE-Tag: 1787252128-212006
X-HE-Meta: U2FsdGVkX1837SvcTREr1kSO7s88qqr+lsEFdO5fFghNL0Pg/QVjWBhcTyFGDk1XtnE11E4hJE7CmbfCemZdzQnZyl5GdBrAXHzgTLMG5TlcSDx7WrdgUov6SBTwOmBz350hYSXkWf3tumndwHenjzR5RSxpeQv9sHW2n3cR5WoSc1gOKPeXHpi68cy6zOpp6pHaHidgq3WlZD0lQ5df8Qny6rxbseQF7ANBVxFBx5pgbm0cHfu1e36ZiFVMCppKFMPAdLvoB02/u+pzLiFg/74BIN7A/0hOy7Lf3uqfouws405u+JrrB7b/fIIeSpux1KNuxxcSGgWtrCHpg9UGqX4Z59XcAf6jZTNKX1l5WFYl5gxVL1Sgu43vCTy15Vu1F2c73vf4sUa9gGL9DoMDS0HvGraiJiecSTz5LvRtIjZXce2F225clxP4dl1/49YPxofappVLmPyRl2M0k02iLUsohl3PdVuJ2D5nPxrsHFN6qyiRB3rvo0LnRkEdbTUjVOIcZ+JQfZAGiIUJ8kSNaYKEAQuNeSOX2+tl6Ilgh7DbH9aZ/UGCySoKumy9YiJcP7FeJnMvHMi95vwfmVt7TxGauIUnc1jjqqvnNl6BeMnPJQviq9Jr/lyat19EqLXWCri0X0jbXAf5W0S+f/8yCmPRgXe5umtN+n2TIit4kGXaKpgpuFyCvptLufvCmGFnHRk+iUs6jvstx9VcHEJe0iBAin+Nuec4B084mFXgs7eYobAZGml4ow0FaGzgRFOvNlGc5coaOBKIqPpYROz7w8x+t1FhGMEx9dPdBNDr6AwDTesVKFrUxCM+s6m/FFpDQBjapi+11aJUpU4+q6RcThNHiS/yVhdZ1oOcLTXBEvW17F7WRBvSPS2hbwpcW3ofxHu/bOQ5A+sxCQ06yuFrNo81bCZCQR/UL++bct62N8IMmJDYywrOJ8bTNti9kdCx5p8XtsoQ+qd8mwDKQxd
 I3kwUPUz
 +fk9EmUxtpFw7Zl653Ac0RkVa4fnu4INUW54kQ4GETXPISZk1SzYJgedFAvRdHY9wsj9Yr6+KHmP1XVwktMcX1QtDUXHTfyxEiuqsHuZUaVV8em6f6DSnpqlcPfkv4KEc8YLNVP1KnIVbjOXEbU+tz5R9Xq/tFNZHQPYcoMgAdUQVthIHXCXyFHxcXkAO6Vpez9CFu8S6TszSEIwrv5xIe6HD07EYI92nFpQ4IoB0baSIW4Sob13UPiCK1JPpVwkJ2cSxpOKnn/llc6mZj5KfWZeHxF44uJltLAHxaJluD800AnLX89CIIpwamyVhbSwafaFYcmScQQUVM/tpNdUxyu2yzGU4rAyfzloqH7V8HF1uUADciMy0XnBDCE4lVvzzwurk3M+ja1q2eKcn/stIR9VQsU2aXl9MP97dYFB+SI1E2eo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The DEBUG_VM sanity check in __swap_cache_replace_folio() iterates
the old folio's range with "while (ci_off++ < ci_end)", so the loop
body runs on the already-incremented offset: the first entry is
skipped and one entry past the range is read.  For a folio split
that entry belongs to the first after-split folio and was just
repointed by the replacement loop above, so the check would warn
spuriously whenever sub-folio orders differ from the head folio's,
as non-uniform swapcache splits now do.

Use the same do-while pattern as the replacement loop.

Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index b76eb3d876fd..59a577f685b5 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -389,8 +389,9 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 	    folio_order(old) != folio_order(new)) {
 		ci_off = swp_cluster_offset(old->swap);
 		ci_end = ci_off + folio_nr_pages(old);
-		while (ci_off++ < ci_end)
+		do {
 			WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) != old);
+		} while (++ci_off < ci_end);
 	}
 }
 

-- 
2.55.0



