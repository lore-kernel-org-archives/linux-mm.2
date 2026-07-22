Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D2BC44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01EDC6B00C6; Wed, 22 Jul 2026 19:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11D56B00C8; Wed, 22 Jul 2026 19:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E00A26B00C9; Wed, 22 Jul 2026 19:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF6266B00C6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:48:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4718C402A4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:48:16 +0000 (UTC)
X-FDA: 85018053792.13.9AC076D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4ABFB140003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:48:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H8ms7azd;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784764094;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+62LWzdWTpveBYDpjXgBrG1SuZbFcuZ8nGzgHOUuWFY=;
	b=bdwzKT9CBqQ+2PbBc3shMi50FNPYMFF6a8zYm+WNcatnX+xN9CtF8P9LERSjtihfGjA0fv
	EkGQbqR0PbuodTPS4Bfrez3EqwqNjHArytUkehOTIkas3Yvsf/vqFt7qVPGlo+zCz+Xig1
	BiAcEtRL6zF2LNkzCsToP7W+ZmJgu1w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H8ms7azd;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784764094;
	b=nXCb1EwJyHFrYiLhrC0azIf1yZUHyC6lQ3LL7fvYnoAXxk4UtcH1TPOoXYs/+fwyof94vg
	U3MVYp9XcV9QV5yb8SvcrAWTu792f0ADRfrOwG78TyHS17jIcCGBagKS8Odfef2w7lVxJp
	ahjuM8vzL6dFhxkj3pTuq8ZyFltbkiM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B0C4450A0;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08804C2BCFF;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=6/kMJwdQl/TqCpTYlCewyDf5fd6mj5P5o/GrXeUXOXQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=H8ms7azd8/HQ5RN3MfbnfPoRlWed2T0o6iRmz6iFwuDEwzZbiHQEERWCy15nejg7W
	 D7UYxa5nPIPcxre9UMbeD42BSP3GA40bTII3rliiNQW/SdvbsI8G3tj99arLhMbgF9
	 mNYmyjWEG4KlC2j0X+320mRNOvAyWKy/IZXrRqfP2iJfrBhgt7a4u19AzCFnoj7gF2
	 z3W4QyiChA0TJO+T/xNSZxUvyitvV/lyOTubwbaU0+K34+rXWC6EiA8WTBGXPSBNQ4
	 4niAVgUbJLOdWbOBppwOmth3vioaP0oqdEk06oVXPIyYpa9vtwxPh5owsF/uph+1a7
	 CV+lTvb/vVsyg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AB8C4453D;
	Wed, 22 Jul 2026 23:41:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:12 -0700
Subject: [PATCH v4 04/16] mm: hugetlb: Remove unused
 mem_cgroup_charge_hugetlb function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-4-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=2865;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=+gjdnJUXRCMSVp+BWhjDe3KtAs27/6SLSiAQUKfU/dw=;
 b=kqwcwPC/GCxB/BUQtS9LtL+7g51a/az0dlTIwy29hV9Q3jlMV9rROOA/Qw2WWy3T+Z0ixUMuD
 ibAIP93u5+dB/8Db6AodxtWs1Ks5khIBrdF7HEQh5/cBr57/m87R30e
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4ABFB140003
X-Stat-Signature: 7mz4afxnw7hmuipt3k6uzk7em4mqzgjp
X-HE-Tag: 1784764094-963685
X-HE-Meta: U2FsdGVkX19G+FNnfOazoBFzQ2wPdBZwG/zdiRWGjs7an8gGMFqP9zhJFueuA/1VBy6UTkm3FXf1Yv1AxP8vxzkPwb5HpTSGulmlHT7GSSM/dsj+p1wVWAl5M/K3i9Ey4PnZDwCUTlzGKhn8fEU5h95O6mVbqi0gSP12l9FU0+cyUdAFlbSxLwFXzTjiwvIFDiG/kfaz1AiV6Z7rmpnAwxykMf4dSspWgmFKAW80aK9rZuVA99wb+EUCsVW+s2T45mlOGtxxo+5caBR8MNzqV+tm2ERVA2KpOLevWacCmEXIJk71VVUAPByXL/EK1uJzHukfj+Ft0uD8q2LLFEaaBvuL8bDkMFZd619b69F+VPndgeAXXa8ipxONCyW3owRHueIheOq2XLVQqBocK+3pyXh0Rd00s2gugDZJpVa0IWrybYvuVzOmcDNSK2N0HVpnAXyqvL/tGbOJysgkkbhbGypDo7DR1+VxtK6TK3hVn9EEbjgZuskeDhjvVAX+JjIBgvvfp1fp3cr83nsb1mlsLon4RCXitvz3+i2vbasCmOQ/HT9LKdCBGxTUcdmrcDIN8fAnBU+pqpEbrwiOaWP/URpqP0/Lze1tbZDl4vOmnbozoaMe3sCyc99naBD5y5Dx/RtvKokLM7qKlVjghSv8hPCrojR1nS3M2ehmzzHYn30n2stsRpNe8LraDnNLN3OJOy+3qMggugXQgd+NUCdrlDAzmWAWRLTRRKFlZ6V/5vULYPfbhjU+FN+hCgbocazyWoFL8ikPZoMcQQf4g9WxOvgmbltxGeEQp401r6a6aJg+v6vAlX5TXF2a5jBxLS5pZFy0/3Xd+m8KHEik6WkM8j6g1Xodti8uFJFfr+46InzG+3XPA0A0JxUGHTXJYA/7fFMn05nnKxQN1yPrAZS82qmeMp+MaEsZj3PvoElyskiwDAzDYxqJ9P8AiQKofbrjM0SYA3oRqF7GIRKv1SJ
 ONbXqqB3
 b8/EH/uO+gy1ccuPgUX7xMPJfvAHDhGcXhURTp88LTchGtw6pKT3PSm01xQOJtFUHTnCKBE9dDXaXYRW2hGaFpfLGFP71AEJVmG5vaw+bHE5ZjSzbsiBBmTY57+Tb6st14tWLhvW7706+H9I9sSuIa6GRIIXOlZRTHYNF4tvs0IgZiCSnHGk1Hau/AuE5qCu7iQBdDrYZQXcXgFRr+Rbx/15kYbBHPRIXi5ggkCeYlZo8b1PgD3pfGMswj0fEOKngzi8srWpCytaIuxcf6yZRYo30ny0NZVf3wyu8aqVAmlPujWEgxmcpJXavo7T5tgmFWeZBWZArBydrGRZNMjSFg9z7Om+94ydc/sp4woyuOUK4sNfz6otGMLblsVPJ+VQ9QHvuGswd0zgWGzUUbOWnCJe1eq/xj0NJv2yge7/Dp1PopVtIkMB04LPVbTQObL1hommDPpDxf/KkwPebDEdgP8iA7anLpq/i3OMUbbCyigEdJRWcAeUTdT+2CEX/gRk4CahXUPSVJt77GKHNizzYxkzUVdZ/1pGSb4P8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Now that the alloc_hugetlb_folio path has been successfully migrated to
the new try-commit-cancel memcg charging protocol, the old
mem_cgroup_charge_hugetlb function and its associated header and
static inline declarations are completely unused. Remove them to clean
up the memory controller's codebase.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/memcontrol.h |  6 ------
 mm/memcontrol.c            | 34 ----------------------------------
 2 files changed, 40 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 2c3e2c62f4176..3bdf35dc2d88f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -641,7 +641,6 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
-int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
 int mem_cgroup_hugetlb_try_charge(unsigned int nr_pages, gfp_t gfp,
 				  struct mem_cgroup **memcg_p,
 				  struct obj_cgroup **objcg_p);
@@ -1133,11 +1132,6 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 
 static inline int mem_cgroup_charge(struct folio *folio,
 		struct mm_struct *mm, gfp_t gfp)
-{
-	return 0;
-}
-
-static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
 {
         return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0beee5c0ce93b..6764ff041c196 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5146,40 +5146,6 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
 	return ret;
 }
 
-/**
- * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
- * @folio: folio being charged
- * @gfp: reclaim mode
- *
- * This function is called when allocating a huge page folio, after the page has
- * already been obtained and charged to the appropriate hugetlb cgroup
- * controller (if it is enabled).
- *
- * Returns ENOMEM if the memcg is already full.
- * Returns 0 if either the charge was successful, or if we skip the charging.
- */
-int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
-{
-	struct mem_cgroup *memcg = get_mem_cgroup_from_current();
-	int ret = 0;
-
-	/*
-	 * Even memcg does not account for hugetlb, we still want to update
-	 * system-level stats via lruvec_stat_mod_folio. Return 0, and skip
-	 * charging the memcg.
-	 */
-	if (mem_cgroup_disabled() || !memcg_accounts_hugetlb() ||
-		!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		goto out;
-
-	if (charge_memcg(folio, memcg, gfp))
-		ret = -ENOMEM;
-
-out:
-	mem_cgroup_put(memcg);
-	return ret;
-}
-
 /**
  * mem_cgroup_hugetlb_try_charge - Try to charge the memcg for a hugetlb folio
  * @nr_pages: number of base pages to charge

-- 
2.55.0.229.g6434b31f56-goog



