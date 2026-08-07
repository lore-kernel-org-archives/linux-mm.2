Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8EFEC5ACD1
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6786B009B; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6136B009E; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8463B6B009B; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF466B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 033F2A015C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:52 +0000 (UTC)
X-FDA: 85075735626.21.C003453
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0CC954000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPG83SXJ;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137471;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iFABcOPzr+evhVHn8/r13qylbMu391so6r1v53Rh+MQ=;
	b=r8zVUTRTiI9/r/A7lwRr7YxVucAZqd8gn7rewJUYZeTpnztqzk4WVziO4bp9DaRmv1YXtq
	4RQpq40YdHH9gMkSCjzAHeLlwkIjlcLksR6s2mYGVvqjCtviVY77Z3yCoLeNfIpZxPAjzJ
	uFKtKe1nBzbVx3gm/nRIn9xn3GuD2nA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137471;
	b=cgBygS54LYKhdz9MWJhEiJdKO65LNXlbVAtblD5CPzDwPheFWlipmlIYGpzl44hbJnWsxT
	4fTH+O10OocMvvbEBxOv5sEaYx050bTTQxxSDqti2pwZQk3ZBvdCKP4vHwMIO0Tivc+G7I
	cPqqyXkOU8IOJWo6PvKpmeu8JYUrKDs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPG83SXJ;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DAF8643CBC;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1854C2BCC7;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137469;
	bh=qiYRZIqnSPHS9cwgme1xDdC4tc2BYZzhqH5XAMzhg60=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=TPG83SXJyY62J7+O3ulzYdAYqN1o7/SgLj7PKS05WPeGwfSMjeBxPdHzOeWKGgOjM
	 Ur1Opvd9Of4mFW5onfsTUdLSfexttD2AiCUFWGKgUHlKSaiyUZBWeL1twUnOjLBOTC
	 AIqZpLrE5rp0eAjIYJu8Tw/TmwdePmWbpgI6jIF6Jryu1IARn8UlX052CI4iIHTxoj
	 1ZBdsSMqBUXQp9TGp3G19PqawHUOfFgIvQYrwetc+oEN2U1s8KXNWusHdNzbLhp2Ny
	 O2SdHsR51XH6Td3z7lE4nEIjp11V+yKCoUBmOftvM0Z/C9FcxV0F2uxOr/mHle+bhH
	 NFxKpGiVbSUYA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8196BC5AC7A;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 08 Aug 2026 05:17:02 +0800
Subject: [PATCH RFC 01/13] mm/swap: fix off-by-one in swap cache replace
 sanity check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-swap-thp-cleanup-v1-1-689939a7ccc3@tencent.com>
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
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
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=1310;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=UvgIby0zG1FXH2X6ElUOn6PPzkRRWckpaZUTxQTZz5M=;
 b=Wh+7tf7JuTm0ygd9gFN7krWlLeYMCMlu6zdCeV4nbLXG9ujVY1uzJTuI7Ek7dUydurWjMJF0f
 lHMeliNanqoDYX3fO/JGiBouhbrGtkSbJlVhkvVTm3ESFyRcKI0lCgh
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 0CC954000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3ddg6gsurwbmms1ewzo3yqgz81a31ah9
X-HE-Tag: 1786137470-641157
X-HE-Meta: U2FsdGVkX19fsu9rb9oGneuYHKKMuU46VSA+2Q6U2GoasSXOI9DlFm0us/1UQxU0HyXetWRR1G7UNcW9yaBODh+t79in1wmnqVhR/zz3bZSIfI2A/o6Q6oMalRGgtmQPixlpU7IKOUCJn711R76fPilKSEZNnCiO6IZod0TIDRjV/KO773YgaglMFNZ4gId9HoG0KYXpIvnINBjZtvCxmpSC8WpnVhL4MNwL5vq73dfUsKMKRMR6z0DQwQvWY55NqHCri+P28Mvp7f3apvkOb7yYqhthPWu3txnsawcwg9gsm1CBqXKQfg1LiEZemgTuo9SO+xFbcrSWP/2RYv4hny4xdOdKAIL4j+N+eh5J7ACpb8lxKhgqqaql4ACwPEe4cwCRZPjlF9eYBa0xLUgzh0mihrzDtfx3TYyqVhopICiJ01fDIdqGPmfCIdxryMH99YfrMCexzvwByxeNbNtwg/mDcd69576paEDdmy6w9NvWcIaLBcWJSI0MgY/LpN3xDD8YHM57aAFck4U3R1VEEFlikDDzrwpPrZPaonrpNYkGGWq1mw+mvCQ/4D9ikZybyPOV0nAsLDMrjehvLnInsIRINEtbe5UVNanGM/K6L0aw2ZY4b5wYv1akeutZQGermG/dScPjoy5sTQI+cnJNG2/mqoUp3Py/y0IWOubngU0G3h+5bjmat/6ErF9oaRK89nEGvNoiYaQz3GeF4M/NgNxv48RkMMGDGIbf9NNqSL1J1TcWeoBwOJw45XU0lGPanv6AtW3Qr4OrItmwMjr8KdWTR3sBueBRDGnW1bbY/YZNYVJWpMNHoJmvWuS4d7n4emu4QVbWVGceRDp5ZGsSDpwkQPa9on3kM8Ai8IaVaVo6apsea8G+b9sus7TpUGO+T6AWDe48qKjpiJyfi1Ua6VzOecAHnYNJ56r9ESgoE8JyJQaTbF2kL1DPNDdXCW8vulWEQSufE4Q+qIZJeWZ
 69MS4Bgw
 Sg1GiZQfF+HjNqPk5jRgHUkS6i6A9EL1QCXI0Gg2KfyUJCS2rmW2joCxomMBoLhXFlmTxX3KVHcQZwBfHz9ZOEe8xwQn8U/KvY68QwnidvQ6ckSejYB/CC7ouXZB2rnzy0Esv1OiX1h0ncAEHnotj8n6uJYerhTnrveyFlCPvtcIfO57mOnb0ATAjgCdI+3HBTQdkxUOjA/Kd0F6wzxgrw4zCNmBuqRLKFwPU6FLYhF4uWCn/MSJEsQxmOJOfHX+fOgXWgJA5hns+7cCFp+3SbcY8f4vZ1U+MSn2wBYTTy7NwZ1apIm54/OvmPmV0fCsO53WLVAOlv4Ylhd3+xSGFLTPshNzQ+w0X6U07V2uFhVnfnMpZTRc4pWHlhBx0IB2LRBw7UR9KT7IvCL0YpqNxTL3tNA==
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
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5be825911e64..f1405e5b813e 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -388,8 +388,9 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
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



