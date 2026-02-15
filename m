Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F25DFEF5878
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 11:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C326B0088; Sun, 15 Feb 2026 06:15:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19196B0092; Sun, 15 Feb 2026 06:15:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6B46B008C; Sun, 15 Feb 2026 06:15:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95C9B6B0088
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 06:15:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2CDF713BFCE
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 11:15:12 +0000 (UTC)
X-FDA: 84446434464.28.D823194
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 02AB51C0006
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 11:15:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bZFLGBXX;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771154110;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZg6GMzs3WMf84aCC52BTGXW6QylJVxLmnP6Bc6UPmY=;
	b=v9t3nKDqIzZff44vQOVzi6Znx46D6h1g5GBBVnqC9MrhFxxOeOCedN9+3JhxWHm/XvjU5Y
	1/suGiY86BahF6QuJSQsVOClcygG9YTiglh+bPTMMJdAcKWu/OWcQ/NGJ81BGUgYoMIdiW
	6ikV641ZDLM4ESZK8JFTyKDpBkUha8A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bZFLGBXX;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771154110; a=rsa-sha256;
	cv=none;
	b=Auo1uXCUbK+use8Wk7zdlIOr62gHdQpFhoT3BWTiNW0aDHevMtkcK0wLlwOQwhDgIbZk9d
	m4aMk/wmEM16qRTkQHu+OUUeYbmoZ8XP2LC4fpTslyWQ3uRn6PVtIlvxGEv3Pz7leo/GKC
	qHs9MaBi9OOEbJc1xnfFmFBnJSXQhls=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 124F94450E;
	Sun, 15 Feb 2026 11:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFDECC2BCAF;
	Sun, 15 Feb 2026 11:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771154108;
	bh=fMI3NMBEUVDZUALv7eftcVJYCPV2kGHURWijC9u+i6E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bZFLGBXXVj5aCmzNntR+TglAS+Z2wBCtWgkxyYgpPwAjYIYK2rxoZKQpLtPRq05+J
	 rlMYG7FKZJbPBPyUX+Um7z9sjbwfK2T+ksmiiWZX5Ny6S1bhsUrcKKr8pA/+Uzt3gh
	 SfB11RbCwxhRyPum/39VG7U4lv1uDHJleLSnNmOAlC8XI8Av//QqFZq4PihKsAiHWl
	 6edYgFAdtO/QrsTz7Yj+gljyzxCQ7c0Ccixj+tarwovgx+mA1gRMu9Sd4mspfu6+Vt
	 SVxfe8GYh2TVskwFEuF/LT6NGzUQs+jZpUOW/SSerJDkoUFymi9Mt9aibF7+QgPr1S
	 xZqbfBH2QvLnw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F54EF5878;
	Sun, 15 Feb 2026 11:15:08 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 15 Feb 2026 19:15:06 +0800
Subject: [PATCH v2 2/2] mm, swap: merge common convention and simplify
 allocation helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260215-hibernate-perf-v2-2-cf28c75b04b7@tencent.com>
References: <20260215-hibernate-perf-v2-0-cf28c75b04b7@tencent.com>
In-Reply-To: <20260215-hibernate-perf-v2-0-cf28c75b04b7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Carsten Grohmann <carstengrohmann@gmx.de>, linux-kernel@vger.kernel.org, 
 "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771154107; l=2624;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=xURGM+JYZwNNO3bCJVyq5yzC/yV0T9iWCnyE/4unSbc=;
 b=v0kDF8xUvccP2/HLrDh7NblfN20PPLULlZ/UaTwGJmcAFIkoTwUkR3GCJ4hwIO83OUbYDANJX
 fyqBaABYJMsCxqAW0utUZT9l2/ES8XKqAAT9u0t+5kR8IaQS9UKM/iN
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 02AB51C0006
X-Stat-Signature: qnzgft14etpk7p9jpijxur56pi7biwde
X-Rspam-User: 
X-HE-Tag: 1771154109-514424
X-HE-Meta: U2FsdGVkX19wK8qQTeooJ1nu/Qvn7uWuX7c+Hq4Dz78PEOOWZixKSA8tu2POilDwYgPb+9xHh3io9JqVzFaRiwrPif8CT/yHLfAQfSbugy20m2Vvz1SMZi712Lhj+9p9yFva5WXI4z78O1pgvml1M7hosEfTlc2oi6DNPAEJkUdcrEnE3Cfd1lieEvg+auO9RFx+D3qFTsq+FN+oK7T4ijbfssjdNvGlK5bcNYxBaykKOoAujv0fEYGTfxri0ctmLgLbEH81YapnxwPxYyB6yAZ7L8jVvTWKlfsY1vJoiv3qCJIFkky0sqPESlAcXNCAoShhxh021HEafhT0qq/40L6h5xYC+GWfEqcXbYLY71ZDN2opB1j0tdujyV0Zji4i/z8W6VzKjydCWVqjcrm8WEp2fjGKXwomEo35K3JQB4xhUqRv55LxFd1gG7RWeqpu3ZLlC659QcY6eQvJyOhZZgGKbuvK/HSRkG8CWABRG1NrfeGftk94gWzdo82iiKnJYGiAYzM1a5hisM7qBbe/YVmsQGEj6nPa1H3jtV95vzRB1rAT6DnGc6DEE4zhinu2ggnjMjcIq2FR0wrv13uDW7ME87QCZmAKuqGXzuYJYJPB4rM7WDi90j1pC2ugnFPhC3BppyJnLB0hnx7T30hPKpJKyypKVYiXPCuqLE8n6pImgWI4QIhgBhSj4vJxvhcGsD3JBw4qf7M7JPBxQ+A3hx9KJgx315lZCp7YmnTRpk+OLYs1CTLAxlkpzJDquUTeUQ7Cj2XQPZcFH2ohDxex6RWFgNHygvmpwH0MiV6aL7ak2pMqA/XU3qe6JltIdIwzSM5XduIhZkYQz2LGUQ0s8LQiRjAyhB85M1pjxy9a0KuoNuNs2eDNIvXWDgMwHo2Na6hrndnAIUbdaupysBwck4+BDJP7RYt7b6scU4Tr0BQ5og41jqR9+FvwethJzkuo144otUwp0e4/+5Lnal3
 et6nFjiW
 HopXGJ20RGl9RnjDIAe6rIsitRD4ZpocJ046NED3hB++CfTKgSssDsRrOJ4agy+kDZ/t2R0hsdNIdCl8oFE7NZIdxyusJzzBC2P6oStqdwSfXSx2UkyHLKMaLu9oGXqj7uftsSwqIsifseK9Kj9NhzU43VcwJ1Vc0UO1Es5XVvSwaHvozIA/r1orMp9nqLchXKXn9lGLQ5dIaTLOGEllj2UsC+GZYF2xjNtRmwgqswazyf9pTS/z+oYIAIcqtJBadBSmnCsaqPeJ3KruCASVS7jCq5bHUZhqtudwKCP3BEmnyfsxGRi/EMyNQ0Fbe/fuL4s94iKF0SJzK3glsTsJx4yJWmU0qEvDO2Bpf0pnfZzaxmdu9MQlBRRbxhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Almost all callers of the cluster scan helper require the: lock -> check
usefulness/emptiness check -> allocate -> unlock routine. So merge them
into the same helper to simplify the code.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index bcac10d96fb5..03cc0ff4dc8c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -923,11 +923,14 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	bool need_reclaim, ret, usable;
 
 	lockdep_assert_held(&ci->lock);
-	VM_WARN_ON(!cluster_is_usable(ci, order));
 
-	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
+	if (!cluster_is_usable(ci, order) || end < nr_pages ||
+	    ci->count + nr_pages > SWAPFILE_CLUSTER)
 		goto out;
 
+	if (cluster_is_empty(ci))
+		offset = cluster_offset(si, ci);
+
 	for (end -= nr_pages; offset <= end; offset += nr_pages) {
 		need_reclaim = false;
 		if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
@@ -1060,14 +1063,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto new_cluster;
 
 		ci = swap_cluster_lock(si, offset);
-		/* Cluster could have been used by another order */
-		if (cluster_is_usable(ci, order)) {
-			if (cluster_is_empty(ci))
-				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, folio, offset);
-		} else {
-			swap_cluster_unlock(ci);
-		}
+		found = alloc_swap_scan_cluster(si, ci, folio, offset);
 		if (found)
 			goto done;
 	}
@@ -1332,14 +1328,7 @@ static bool swap_alloc_fast(struct folio *folio)
 		return false;
 
 	ci = swap_cluster_lock(si, offset);
-	if (cluster_is_usable(ci, order)) {
-		if (cluster_is_empty(ci))
-			offset = cluster_offset(si, ci);
-		alloc_swap_scan_cluster(si, ci, folio, offset);
-	} else {
-		swap_cluster_unlock(ci);
-	}
-
+	alloc_swap_scan_cluster(si, ci, folio, offset);
 	put_swap_device(si);
 	return folio_test_swapcache(folio);
 }
@@ -1945,10 +1934,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 		pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
 		if (pcp_si == si && pcp_offset) {
 			ci = swap_cluster_lock(si, pcp_offset);
-			if (cluster_is_usable(ci, 0))
-				offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
-			else
-				swap_cluster_unlock(ci);
+			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
 		}
 		if (!offset)
 			offset = cluster_alloc_swap_entry(si, NULL);

-- 
2.52.0



