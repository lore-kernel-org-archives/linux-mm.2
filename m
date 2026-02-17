Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C345E9A040
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6654D6B0098; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585BC6B0093; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407466B0099; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA8D6B0093
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D51C0B604F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:54 +0000 (UTC)
X-FDA: 84455031948.01.2FC82FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id CC8A94000B
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rc93IAwz;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358813;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JGNo+Sd70GZMeHH2mnOCfSSz8Ds55rkedfDCKEQ7LpI=;
	b=qeY2iSciH+vYB6YMWAadGJOAlBkb3sdjf/40B845LVqYaqrN2skJaWsx3A1Vs5sbxEtS6O
	BFHR4fLRTFy+zYWEJSnJUENnE/GuahI6kBDbL1GW2nbkGOoR7oCGqeiHhNhidm0CXfqOMi
	7zIvAcvw05MbROzr2JeUY/LuL3hdgHY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rc93IAwz;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358813; a=rsa-sha256;
	cv=none;
	b=SjlPK+oz+7V+3wwwj6QxsNwxT2TCJMsQOzwK9TaqhrrFtJi8yI1gCyYc4uNyeUIAlz0r0Y
	EacpY3TehsPOc5AoJzw2xHSjvkKcZTgcxkZD4nCJNz8IlEIiDkW53l4eeRME9KvEcoDntJ
	lwJhH4tRTJ0sJBeQzeLlOq0oirUTtsg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AEDD244560;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8191EC2BC87;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771358809;
	bh=DehS9hTU793eie5l6tXoAIZr7SXja9yJwWlHHmA0Ahw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rc93IAwz3CIvEnaYF33A0YKpNSMZkQBQhsYNWhNFb6/OYtR3ELePrzfffPcSIeDMI
	 d7+PPBqgWleL8F2oOvuYZHFAhR0KYP6TaLMm6x4afTLxtthXUk8MAbCwx7WS1ATcHW
	 XglSWLfdw9FGwqDbCddIHI4QJQnQKafB67iHbU4RohFxeucxaM+DHdyECEf5ULr6I2
	 nbcuTqGB6EnzN+UYv5wbzUdTA/effu7HYTZbRbb5DbrwMIK26wlmUeTl155gzckIWL
	 isOJtjg58vkCzKkG2v+6z9Hvx6h22XyaabLBMheuE0vxpW9iVTKsYoeITi8eobYzR1
	 Ie0w5StLHxIRg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA61E9A041;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Feb 2026 04:06:35 +0800
Subject: [PATCH v3 10/12] mm, swap: no need to truncate the scan border
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260218-swap-table-p3-v3-10-f4e34be021a7@tencent.com>
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771358806; l=1640;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=2+MOtDCYClcDw9TcgcSvHJeMem5KxDman/aSTNPnNu0=;
 b=JiApyFqhVexB0R2dK8YJdP7PMRcUBDYnG3jDQt7pwNUkIz80Oj0pUtxXTadmSQ1fbZjU9Abnv
 mDDgUzSRT8SCBo98cAzB0tTSBiD8cJzIXZ2lZ/iV5LkjyBVp6V5TlwY
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: CC8A94000B
X-Stat-Signature: f9k6u1uruyqmj3retz5mgyskk49kufti
X-HE-Tag: 1771358812-420663
X-HE-Meta: U2FsdGVkX1+Rdb53Tb3WjYP7whwzBGG8Obu6P2T8JShSgevASL1gkwZVuMYyVrE/dqoiTIv+R7jR9+2zhbVkrS1Xqdc0RrOU5dXZPhPyXmmZnu2Jrv4NGy1E+IxYlFCXrQmuU75dmbkgZpp5/1X6XokNWB8+eV/zQKe6eXbsxYykw7MOSKZyhhd0yMkzmdyXFCa3hSqBpox3jWRej3Nb6bhyBytMF1vPnGASAsp79BfxoK2SP9iaiLkwLkdsxEP8ikLKfDh89YMua5LQJ8jSe1uBmPMkUEKe6jJrgO6uZQwamraiMen2Fwc3e3V0ahleIH7oZQfAfQYtKDXb+CrBVb2hgcUG+Hemgkp5fJOPRfKiKARF7GupiamLUScoLUpLUy0Sr7ql6j4QBBwY3i7pKU6JVtemLEStA1lQ+2XWqAbB/fvPJ5mVG44k27H7JMr6+UZjGZGUV52EbZ92J9bmLl7YFBLb7HxVrRjLEGXv6EE9I6tVrZeAEzry90fW7w2rUx/Fp40etMvcMKTDunJN7P2t4LGHhpWa5qb03vFZJjE+YFFlZonBhF40z2o5jrpm0qtnwEVKzCu6cxgfI9NxSy8ISNHmaSbUmxeKwhMHx5wl/R9bbagT598ZBnJTWv2zClXNfrOD5fMmqgH2goZhyIDRj9YwJOLvx7xgi4cJnze9T6iWuT8GDFlMKmpJENsKaJC7cw5wgZjQvuC24mzk8kzPOE+/Wx9vPMdJBudq8mn+Thi1dEhQwyE5AAOQpDcEccbBGbOJsvgGifxONkGeUadZ0i+IZgUgIKymkRIuXWcWncaUZRkO8yeBawDeGo91aRVFavQ2idYsb8L/SHLE4Wlffm2X8qpX0WWh0B712DL7ofTQ/Y4kkQVmn9R80tMheTvam2kGox6IFxtyaYVgxyd9q/Q7W2wHN04zJDr0R6nIK8Rmx2syRN0uhqTqQF3DqKZsFgqtIdkUuu4qRWi
 DdzSn+Rq
 siwUyiHOTr2gIxSPgpYuQPRC4i1A8IPhObx0VrSt5VW6chQs7WdObP26qG1BDrFzjT1d1AoGebOeLtit1SEfUOxTWy9JrbYqkiysMfJVTywlLiVQ1QaEDZnIcervRMkGr7ickyx9qg/lhkZ8+JN0Hmv2ykr2dvC0U66fpUndluKJGA0bHk+a19NlrY05SOz6M8PAxP2JPWkM9EV4aHFHyw03YAGH25wi3d+FH7939fy+dS9zEk3WQrNoALepBJKLxL+5Lu4Fu72UsiTPyUNuHG+zL2FXyNy6bpINaQF0ZOHY+fXsEFLTir8+9XJqu7sLxZAAWevv4HCpfno9MH1l6PjagiWtGa5S1HMYA4I8+PVLY0SVGCKJd1QKpWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

swap_map had a static flexible size, so the last cluster won't be fully
covered, hence the allocator needs to check the scan border to avoid
OOB. But the swap table has a fixed-sized swap table for each cluster,
and the slots beyond the device size are marked as bad slots. The
allocator can simply scan all slots as usual, and any bad slots will be
skipped.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h     | 2 +-
 mm/swapfile.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 0a91e21e92b1..cc410b94e91a 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -85,7 +85,7 @@ static inline struct swap_cluster_info *__swap_offset_to_cluster(
 		struct swap_info_struct *si, pgoff_t offset)
 {
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
-	VM_WARN_ON_ONCE(offset >= si->max);
+	VM_WARN_ON_ONCE(offset >= roundup(si->max, SWAPFILE_CLUSTER));
 	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
 }
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 801d8092be51..df2b88c6c67b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -945,8 +945,8 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
-	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
+	unsigned long end = start + SWAPFILE_CLUSTER;
 	unsigned int nr_pages = 1 << order;
 	bool need_reclaim, ret, usable;
 

-- 
2.52.0



