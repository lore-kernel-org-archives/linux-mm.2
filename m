Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633D1C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0AE6B008A; Wed, 23 Sep 2026 17:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5EAE6B008C; Wed, 23 Sep 2026 17:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3E326B0092; Wed, 23 Sep 2026 17:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF346B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:10:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 31077A3B6A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:48 +0000 (UTC)
X-FDA: 85246271376.25.7939AA0
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf28.hostedemail.com (Postfix) with ESMTP id 73951C0006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lIyayarO;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.141 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790197846;
	b=v7Mfyhtulqcp47IMxOIXay9JWUo2yVsSxKeD3PxYW9YYU4iEFoO/leZEo+iLgI2P2B8G4m
	gpjA8p3vtwPOVeX5M+WUcnpdmrBa+1VrfgsyAcSU2pGWm2+apRMhUgoFtjHI4Y3wMf9km8
	K2pM0eqJUAavV8QZU+YdzoJSfPbQqws=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lIyayarO;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.141 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790197846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zePS8k8rZkvT//tsMfFKaNJkinJJhgZrZUtUQPvClt0=;
	b=Sd16MY9nEa1yqdAuR0p2XIK/erpXE11jPBA50sJ8OZDRU0VKq+yXG1IJXfs785Olz/2Usx
	Z6zPoRsJ15Ul4BkwJLFQOOApvBMn7JdYrKE7FGv+FlqnEiV5CTAOUzeyThbLkho183rpQL
	fQJYV33+hQx4uR/VF32cCXwQP0K68WU=
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d43db0c16so21222297b3.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790197845; x=1790802645; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zePS8k8rZkvT//tsMfFKaNJkinJJhgZrZUtUQPvClt0=;
        b=lIyayarOn733DpCsUXEAtLbKFE1lx3YT2bSHBwMyK5MXMVoHmqlVsiMIHxg86aWe5H
         byrU2Q1APZfWfCpHBHDi7nER7caaMcbLQ6ZZMtkdHPzP6TGp3MajpX02kimLlwLCZpko
         uWqW4Y0KLkLvUUIM6DcNpeyhVqdLdhUBdhF89KGN5EVYzVhd/A9LxiEDUcck05fykUgq
         QuY2UsdphqhfQM2V9KsnE4403r0TXq1ugDIeqOPRdWw9bFWAHUS8ojvCQQFVZhpNV/jp
         e0Cp1clPj8nfBOkZf82nEhILSsRNcVPZMC2SOYi+i0lDD8Qa17hbMiKqTMAtLWYIwFfD
         ZOJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790197845; x=1790802645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zePS8k8rZkvT//tsMfFKaNJkinJJhgZrZUtUQPvClt0=;
        b=0QlSOVD/EwLnQ5W023rysd6hl63T5le9Fw12DAIpndbltcj0+Qh3LIuQgNyOLr8BGX
         lygSuk7phCyHcuAxxy+zDx31MIgC5m9PWY2vK2xJAD5vG8uNpWewvS8OPOlW/xdlPtPl
         gE6D/It8B/cqQXsGD+DgLyS/IHYjmVtom9kPY9dGiESLTjNaEV7qNfOyUkyRi3taSqc+
         ytu6XP7xAQRsDYtPTCs86leFPElpevIrodX4QbV8evBrOpVoHj8ky4SvtOvPZ/saCDww
         MLDymw/ylgsxZsldUmwKmtNMYV56TjbC/swoFa5TS8B7rkzj5a4GTg+Toq+zFChnB83c
         hUwA==
X-Gm-Message-State: AFuF++kMWaIyn7wmUQCw0EocBf4zUObC/m+Dfkvp9Dmy+9UZb1LFLPni
	Uem70iRfzrPDDTna8w6rysGBX1HKMn9nDx64HgQk/driVkGSqU8+ahg/W1FRikH2xGDlamBXwxK
	DtzDpROc=
X-Gm-Gg: AYBFou0Xp+9LVGxifvh4eJ7ev+B9Q/RH3aWdWbOwEmMoa9G0pQFE5et80leS3Y0Pe9d
	IWhTefdychwIMwaI6ZQL9WMydKOqafYI4QSCowlxzXDUBR9rqUiNM4SjIABzdBYR3ZikfeO85J/
	B6b9V/NTlusB9gqGlGRO6JL6kKg6BED0Ywz1O50r0yFgPLe2hcu2DaUEN6FjgurhDJEzUxCF90r
	JlR8wrwbmloyIdB1yrIHHdJaP1pVvamLdmzJWrYqn5AsfCr6EcF/PwgrgqIvUGsSDE90mVWsa5v
	wYqPWOn4IGCUw3y1J9hj8YzN6uR5Mk2pi1sDY4T2lXFNqb8vcqpX5xXM6b16lfS8diAdpz84Mvk
	3OaB7g69ZCYMmMqBylXXoXkriUpLM83au89r/i9N9T3oEEuQZ7S+NfySJlriIiaeVYfsOt0WeWi
	72xCVygc9Ykhj6nNKovoFoQX3BlmyEUm7XHFml4/8fBCfGFc2R5FUZPU5RF5a7ELtRl5x4kxf/i
	3TSs/FpuxNRA9GN7/NRldxBojjRZpaPDkiKGTzfFEH3Fy/DcgKDvteWu/yp
X-Received: by 2002:a05:690c:6610:b0:873:17c9:b054 with SMTP id 00721157ae682-8a648505a0dmr2839327b3.21.1790197845286;
        Wed, 23 Sep 2026 14:10:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2485926esm305893085a.19.2026.09.23.14.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 14:10:44 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org
Subject: [RFC PATCH 1/6] mm/page_alloc: clarify bulk allocator flag scope
Date: Wed, 23 Sep 2026 17:10:35 -0400
Message-ID: <20260923211041.3127588-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923211041.3127588-1-gourry@gourry.net>
References: <20260923211041.3127588-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: y9kcmaafie8imp4x5nobepnjzq7epwou
X-Rspam-User: 
X-Rspamd-Queue-Id: 73951C0006
X-HE-Tag: 1790197846-724875
X-HE-Meta: U2FsdGVkX198fiG7B2GLR9Y2lQNnh+Wyu0Ob+TlGJyMfwmSu/UdYBwrg2XmtUC/6oXk5bZykZw6P8Vuh02xsPIQ9qr4EST5WZ+wLDbqYufHtUENHaVCG8P0Y3OHio/Z5ndxNEaJq4ZPXErUMjchuVeo78mcq54p1zPXl4mwu+Cko8SoMMwzrMjtsKKMQdqh85K5oFwjZzANOj+G14d0aXoTTLR0pkSiKSyNvRFLV60YIMsrfV9Qwxz9/MhMM6a5lhbIigqRKJgyUiTui8RwYtvuCnqR/OFfEQ4tPfpZT1Yl4+FxsttFn+vq3kxL5S5rHlNQuaOxCElMZyMz8U7+dzUbQy8iDh5nP7WtEJEmFyYzEPF1CFwtNj2ktw9t+TePUo8T0I2ldcMmS7uEk6vp7GkUghVJoO0Dzpfvau25kseei8S3XbHO7TWdHFhaO2mfJFMQ9xmnN5sUOVrA0m9UoSKZga1y++W/0FlAHOU1/6wXyE8X2Cn7lkQPXrkr+qdweFA+EZfRLIY2a4Q5I2JBsydj8ws56VCqs5EjF+/4X67AAQrXC06KoDBC2wHEGnCvA+EUwF5cZJOKD9q4EYsF2akqz/aG8milcJdYsMyC4QM+IZbzxHqiUQqPMH2kG14hX5eDXYm9QkzbAqJF2hp98TwRYYgZ53szf7qV+oitOb1lTf4NcvLV4z+rrXKcsmVQgoYhrx0lSpPxMZiR6jdC++wgoDa0EWVgx0+DphwEX15iQDaLYEm0xW5B9LYMfhcJaDby8fRbVMuk6LgwZQiDKV03uqXj7Jv8O33I1F99pcwzX8Fhr8zC+hoAR/SYjaB5oSE3dI2fUbIsKI9H11VY9fW29ubX4Nq3p3hSdl7TBYpZjwcy/IMNcMq55H9MWT0yExYKq4c+AbYWE7MO7k3hBZrBccIFEVrsLS2D8U2/q3ZahcfDAaMUWY87xQ8LaJ8tmaX5Sb4n/DmJrOIjrknV
 qTgpkYM2
 JQTC71FeLY1No5A2T+rNNBerh2fBinYcFo4L53mJFVSZATDSFowvZNh49f5OTAMNOKZ2skY9CiMo6g40h6cmxsp5uMmRvamElmXciNZhpZ4e4pk2y0ob9IYQDyJ2NrVAka+yapkJQJtsZGLrl7roZSQKq0qtEodllm3KcDnJBoQCUBHyUFVIhJiNaeUuWVG27roFRsNYhbV3TjBZuTyH40/NWeoTRXy+j7GOiQsBDsh22SbBBYvT8Bc3BqchRHbka482sUJLLHx4ERFoUtsDqZWzA9TW4K+NIlt5RGu6IMvND//l2QZ7nN5AK4tJnJVozTVKyJYbD2qqchvDqgveWwB9rxk1HUaro2jzW0H7kCElEvoMsiBXQ6Uw5cMkK73FKEHBH5BQbhm7CxZ4Z21fD19zm6xw6NPJLkZSsdp79KBhb7zA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_pages_bulk_noprof() uses its local alloc_flags for fast-path
watermark, cpuset, and CMA decisions. These are distinct from the
allocator behavior flags stored in alloc_context.

Rename the local variable to fastpath_alloc_flags.

No change in functionality.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 07e03c7c7771..728dd1a36f0f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5169,7 +5169,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
 	struct alloc_context ac;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int fastpath_alloc_flags = ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
 
 	/*
@@ -5210,7 +5210,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
 	gfp = current_gfp_context(gfp);
-	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
+	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp,
+				 &fastpath_alloc_flags))
 		goto out;
 
 	/* Find an allowed local zone that meets the low watermark. */
@@ -5218,7 +5219,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
-		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
+		if (cpusets_enabled() && (fastpath_alloc_flags & ALLOC_CPUSET) &&
 		    !__cpuset_zone_allowed(zone, gfp)) {
 			continue;
 		}
@@ -5228,16 +5229,17 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			goto failed;
 		}
 
-		cond_accept_memory(zone, 0, alloc_flags);
+		cond_accept_memory(zone, 0, fastpath_alloc_flags);
 retry_this_zone:
-		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
+		mark = wmark_pages(zone, fastpath_alloc_flags & ALLOC_WMARK_MASK) +
+		       nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
 				zonelist_zone_idx(ac.preferred_zoneref),
-				alloc_flags, gfp)) {
+				fastpath_alloc_flags, gfp)) {
 			break;
 		}
 
-		if (cond_accept_memory(zone, 0, alloc_flags))
+		if (cond_accept_memory(zone, 0, fastpath_alloc_flags))
 			goto retry_this_zone;
 
 		/* Try again if zone has deferred pages */
@@ -5269,8 +5271,9 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			continue;
 		}
 
-		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
-								pcp, pcp_list);
+		page = __rmqueue_pcplist(zone, 0, ac.migratetype,
+					 fastpath_alloc_flags, pcp,
+					 pcp_list);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
-- 
2.55.0


