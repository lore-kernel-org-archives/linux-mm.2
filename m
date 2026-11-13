Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 204B7606A339
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JdHX5lHv
Received: by kanga.kvack.org (Postfix)
	id 9024E6B05C6; Fri, 13 Nov 2026 16:26:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E2B6B05C7; Fri, 13 Nov 2026 16:26:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6F76B05CA; Fri, 13 Nov 2026 16:26:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 383AF6B05C7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:26:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9810680156
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:41 +0000 (UTC)
X-FDA: 85431380202.06.799E0BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 843DB100005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JdHX5lHv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605199;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7SXTfTYuGz/k0372PRCBUnT3oCcPkvMRjviGYp1DMZE=;
	b=nRm58HjQZjOD7lrLwSb/PoUWbMa7/Yf3cZQ1karMH6OBvlnBKvaqVJs7FPuQuVA6/pqqoj
	W30OkBNiV8L2eEV3iF56439MJb840V/foEqycB14Sp8aZ8UHwqelEipILYPpMyxaIAxNIJ
	knnBjUkzYhN0SRI1ORNP1qf+E+6Si14=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JdHX5lHv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794605199;
	b=Icl86rVaKdR4Cw0a9pyy2sJeGKWlZfbRFz8yK2dpkauRFzmNt2zUSFaBd1nNRftLIuC+4G
	k/DelwXJYm9QD7AI/loK8Wq+g+ZiHv62cvgCngjFovCDX/lAGA0fAvsyvwqETYq23dhOj8
	Lde/JI4HGrREjXXKl9JlwLRW+Sd/Jxk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F3E6A6343F;
	Fri, 13 Nov 2026 21:26:38 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794605198;
	b=N6UpFfDmghc7dxkZAWR9umdFWCWbhlgYF0HP0XCiRJ/ugGp5RpKuFIyMt7Ehpwug1fPD
	 tHkPo1rfEP7DXjkIRAwiEOlOu2OLgoo//bSa9NY9lUeZBQwh9qGpLaztvWyO808b3b8eC
	 XwlLEJgMmArpWJqCAfqwJxs9ydXJqdPREhbOLaWyPj2Xt5sNOnwqEiYVE2OhHRJLTW9dr
	 Gy4uxyOCXPQONGNNH07Gowh5VhfDMMb3IwfS1j0GmjgwW/vPg30DCo5a3ozQfJyvesKxx
	 u8O1NU1ZtFMscWuDfU561oJYpcwsofZWa6gCPKM1Zpu3OJE6JK4WgU7P3NIA6zH8VTw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794605198;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7SXTfTYuGz/k0372PRCBUnT3oCcPkvMRjviGYp1DMZE=;
	b=FrDjOBjpQTPMnHm7YTgqUQ+/DFx+UaCJFyhtODekjvha7HlcisdI5Inv+m8/pHfsQRyP
	 CVJrW+1iyd9E3zAE+MEw5nIE3r5OgQNwU4O9NhEYSK3HpMOsnQzuu0y/VOuhhq3wYbP5o
	 6QWI1snt2Qj0/8LjByedKqdmN2nTnSCSgUM3eFyYYkLhgKvcjvjYaphUfp2g2CuWisjNv
	 wJ70Uv6EyRzUbvujunOFXR3IbKSaFWa5K7Fmyyqn/MsP92N2RDfqofDSVXiEN3nEZyw4Q
	 noseg2Hc7ZXS2qFP1yKSrnJQqPRidveGbGs9+2Czjz5zFn+zyZ7jRVE8w1TzdU/jCNQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 083061F00925;
	Fri, 13 Nov 2026 21:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605198;
	bh=7SXTfTYuGz/k0372PRCBUnT3oCcPkvMRjviGYp1DMZE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=JdHX5lHvhJPflC8T6XnF9LEc4FniRm8lc7T44e/uUkmcFXxaC9+Bz4+Hb4OLzhPiL
	 aCK+gr0hoz1IqdYAsioG2a0g0oY04scqTP8Nkrbo5gLdzhNSyxG8/1JcvcE9WWGJgR
	 BoVE5a78WQb4U+L6xToFsjsdX6uQM/IriPB3zLgJ9HkeF4ss45RQi0DBJAEH+/KL57
	 BJiuTKhmF7hkvnGInhBk0JHVhBH9Ob1h7Gf+A/Tjc73u02uug1YbqvlI7qnJ1+8D8h
	 U8Ot9e2lmQYnFg4mcAqFsmaiRTRAWgQRvt/yCfKomHI7KSt7wybx96CtaxlWhplDqX
	 6LwAJofIIGs9g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7794D49B2A;
	Fri, 13 Nov 2026 21:26:36 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 14 Nov 2026 05:26:23 +0800
Subject: [PATCH RFC 7/8] mm/huge_memory: walk the after-split anon folios
 in reverse order
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261114-swap-thp-split-v1-7-dfa8d4fa448d@tencent.com>
References: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
In-Reply-To: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794605194; l=2204;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=b73U95HEn/sFMHZHf5dLhjLZSLi/GMxez+2xE4t43Nc=;
 b=70EsV5Uha41PjuPYxhWxWFvxuyMQ0o4A1mtGI917jUBg/etMrn8S6YMm7q+tJXy9XsBoKFNy5
 KgC9YTrm+YIDDLdn2hg/4O0StaQTY/e7i5dpk8foYPEWf6bNteg3Zi7
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 843DB100005
X-Stat-Signature: wcbp61r6yy6aica7tkypmdicu1m48q38
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794605199-715560
X-HE-Meta: U2FsdGVkX19sPC1RaBbpOF/7TbVIRMWwrJpumSxyyq0y+jVUdXj5/2hIzg0yA4csNzURWHHmNKEw0fAHU+b6LTbBdoymJuHG8uyR+c2dpOmA99LTEtuI76KMMq49xRARari9QwcyLx4PJx9mWyzCdRB3YLexAKP1yKSkroukaUFqmA7Nodl8+cNsohKjfoKG1uRVskFqXXnkj5njlqVrdzA7pjf86Y9z9WXKEN2OOq9/DbbM3Hqu1oj31bW8QRyEGc8oDaQskmWtkGmGswsQwA8N+zTywrasGXH3FnKjXhxrX9UuwwXtw5norfTTo/YI6Cvi0AsopKHiP3Qlrp7X3lTE6elw5JxSqzoaIse0pC5TAMfiGOHUh6ZfCyPnHFAvWywewtD5yYlT/mLB+Y3ksBMo/vz93vd+xW22mouWtGwKDlBYWJCy94EE+loIcvdqQNUwK7uzm7n5Pu2ysrEYoM6c/yxXn0nxXad11xC26njvIkZwa6mhNGmfk3kQrBqRS6GCWbujLWaJcxnYRNDz/cH2ZK4yS88eHRFStGVgfF5i9WbIipL9A2WcEvAwGRYIGuJt8SwKT04lI69lsCaWd2QbZHHQCEILcgORLUyN+yz+EOLZEtiNKzD6FbsqUakiKPpodMIKCOs2HN3tNO3JwCR0pAR/0RspLaFQWN5rJNjMNWVCNCQBf876E+Jv31qtw3umuKH6JXA3MGckqyjnFaAPB5aMNVDVdYAAwQCBmRKCB+oDHakpO0sVC+mdImRpx9aCR71Zth6NLUQbBbQ3XZCe4sFaOXgdvjgOUHFOS2SC2UvGGmZ6tO8f6IBjoXTE14lTrLU5edqG137pP+0JCYydX3JLs3MWeLr7iVA4DfGcyYrEFVe/T73rEnLf4nP7APBQyecOaCt0Tw04oaKdNNbLdl6H0ewd9zA8iO8Gml6uRfJm82Ad1+Zzf4skutOcmCx8lgU4ZLc9zN8rPkh
 a/5R6pGO
 lk+zXCDYJd6dMeC1SPlHY8nRzbgrBCSzY3ABoXsucdF9CZzbfxp4ImBzZl4JF1lapg6ctXNXBez6OlMObSxktbCG9ZwbRycOvRnOmehZs3NG/mRUsK9OtG0G3JHUdxIByiRO2WASGMefHXlXc6QXB6PssaCSQJXCu4w13PEA7tpg76weRSjfuBVJtHc6J2FN54KJytXEvyd8biaLuabqgohDRJaSgCqj4l9Vh965+MVDHi5J6KEbMxawQGiL/CsTu9JYlDeB6jOEjjw8Mui83pvRjsdrp0JQOo1T7uOmP7ncqka0R1kzxLfhFBwmtZlTRhcO5TskvyKLZXsA/nmh8yME7SaLazby1i/SNCVksy/6xy2MxCPk7Et4mArPOj+wexIZONGtQh8aNKM5+TFchXOQUc3KyROagg25WdICGAfYdDySad/1baRYziibLQ3YKWabDNM01XU+WhtpeUf++TPDV6CbU0J3vS0v8prWC9vbuuhAGBCXjqrerayL/4tyeOmzsvp0uRrUTBjI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Just like the file folio, walk the after-split range with folio_prev()
so the pieces are queued in ascending reclaim order where the forward
walk left them descending, and the cached "next" goes away. All of its
users either expects an ascending or do not care.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e16b93318613..2ff201a5e5f3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4076,7 +4076,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
 	const int old_order = folio_order(folio);
-	struct folio *new_folio, *next;
+	struct folio *new_folio;
 	struct anon_vma *anon_vma = NULL;
 	enum ttu_flags ttu_flags = 0;
 	struct lruvec *lruvec;
@@ -4137,15 +4137,15 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	ret = __split_frozen_folio(folio, new_order, split_at, NULL, split_type);
 
 	/*
-	 * Unfreeze the after-split folios and put them back to the right
-	 * place. Keep the head @folio frozen until the end: sub entries
-	 * in swap cache must be updated first, so a concurrent
-	 * swap_cache_get_folio() cannot return the head folio for a sub
-	 * entry (folio_try_get() will fail on the head @folio until unfreeze).
+	 * Unfreeze the after-split folios and put them back, keeping @folio
+	 * frozen until every sub entry in the swap cache is repointed, so
+	 * that a racing swap_cache_get_folio() cannot folio_try_get() the
+	 * head.  Backward is also the reclaim order: the pieces queue just
+	 * before @folio on the LRU, or at the tail of @list, both drained
+	 * from the tail.
 	 */
-	for (new_folio = folio_next(folio); new_folio != end_folio;
-	     new_folio = next) {
-		next = folio_next(new_folio);
+	for (new_folio = folio_prev(end_folio); new_folio != folio;
+	     new_folio = folio_prev(new_folio)) {
 		zone_device_private_split_cb(folio, new_folio);
 		folio_ref_unfreeze(new_folio,
 				   folio_swapcache_ref_count(new_folio) + 1);

-- 
2.56.1



