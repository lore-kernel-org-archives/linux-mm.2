Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7913CC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49E9B6B0093; Wed, 23 Sep 2026 17:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4012E6B0095; Wed, 23 Sep 2026 17:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31B9C6B0096; Wed, 23 Sep 2026 17:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05A006B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:10:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE0DD1A012F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:52 +0000 (UTC)
X-FDA: 85246271544.08.F4A769A
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf24.hostedemail.com (Postfix) with ESMTP id 32E87180008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ULud0k4C;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790197851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/Ioh0E0wp4TmybDNX/mkYZyZ5cUYapYs7dOai2tJpk=;
	b=jj0MGVcZAqBVeqQ0GfxEHgP4DF3IcEyJ+gc24ucqy9HH4vPJr5X4M17CuEBaZM1R74+cuQ
	HA8IpuX93Ip9wLTHbjK1S+sOEP6Ixre2n57YSaxh0GVTlh6itABrHQOCUcDJbtau8oUGJ+
	EHGecvK1llRB4J+m3x7sdPIG1fKojII=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ULud0k4C;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790197851;
	b=ZHVhmxPLNhJeEBS91mNtb/XsZkmeoKbTAqwxfT5wNys8oI6yvtEdVLRZwhle0G/zSDvyaI
	sQ6fI9l4RVgPE0+c+GvEnZYaaiFsEMsx8YviZYnYVaHG2GmdwLPnoLcB+AVEmjrFtIzmhl
	uSe1LiY9UbWwFlZ+f6O4qkLw1a/UqDY=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939109fafd7so105134985a.2
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790197850; x=1790802650; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C/Ioh0E0wp4TmybDNX/mkYZyZ5cUYapYs7dOai2tJpk=;
        b=ULud0k4C5zG0Klr5VSDsbzpQKYYtcM9CrSp+QoNo8xjdvZK/sklxLK06fbVz3poTt3
         t1PEv20s1Q/7zejOSvhxLsqnynn+6C4O76tnipCIvKe3RW2SP32TvrDAnscchFzrMZYe
         7Tkzjr/d9BmXzktnyULzx0RgDpgrlEd49z8VRB7RRZWnXBZSskTuQS1oAPrp4Gr00vYP
         etHNLxzplrRSNvFlFDeOhDLjFiVkh9own036MuHwDhstBWJ7chv1Jrbk+BnXei9MEh07
         vO7z1f9tganVPI5nuwpg6cMgr3G7iotlwhVrGX3//PaXSwrdoa8dVJzjLQ7RTs9ygHIn
         yfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790197850; x=1790802650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C/Ioh0E0wp4TmybDNX/mkYZyZ5cUYapYs7dOai2tJpk=;
        b=sRsBO6e4x74qF6a18Wf4CThP5pPOw3G4sCxJG57P9toFByQ6HfHpOflTufKBOnMRLV
         EUyOI1PtGlt9JnWPB2Nw5HGOXXyJ1Sl6S4zLnp9JtadCuNRkhBh4Owg+uxNwLrb6sOw0
         etorqzlVNSNDMNSbwBcvLVvNyJqTZvoPU32b/BYvESHG1w6qPMXBWasj/QXGIHWw7sTU
         pHDhMeTWCw34xE2sXeSZWBas5xqARtQSWfwiQj/+/vqaMb9DIjQYa9NX0Ut12RAL3GDy
         1WosjvXGIZB84iYAF9bDtnBdys7sgLsYEqS1x+Jj3FWL9+chyashROaW/GHvH9ckOGWS
         3jDA==
X-Gm-Message-State: AFuF++krYp7sPg1tj4J0il2exkn+Qi3J364J4oVUQ1RPukduNK0nTfOQ
	fuXPUfLhrledmfLk7hLo7gtqt4H3+oE4PM0GSX63cpjNTEkYz897ypbZIY0ESGEq+pOHUEpRSjO
	0rmQxlNY=
X-Gm-Gg: AYBFou2GPh2TBtigNMUBaR+ouWNzGhmIx566ty47z8TfFqgBtpNlkikvypdJgUgPbB3
	ikxoDk7wAWGld6FUltmIgHAH0xHb0Tv/mOzJA1c2XgzIdfpzgOx+6c6QDlpwXaSUzJBCtkZKnCS
	qQB+GpCpZHeM+/YPLS2ME2rSxQ77uq7IRZu46A878uksds3uedTSwxGgG9a8Rth/Co7XQnWUdkt
	urewqQh10GkQ2tnPtU62vww4/W5b+59zYROQzYg27wlKKJXtVwBVZq1OIgrNbQWo6APCU2zfay+
	1GH0XiAfSut4M9Q6z+/Orzx5HrrAs3YOdUq0zlzuuWlHFXEftwzd34fnKm/EzA2ZHYwjiVqs2XV
	u9sXXOaXUEzb5I03QriJdAIswDdAEL4QYqzwv0v5wwO1zutWc8SGB3uWyEkIB1Hb72nuPPBWtIA
	lmyLuF/po+K9Y9D698j4FndbfC8SBJiSieqo5as6oh3BHwtrgxwgAhOUmhN0YU01iC8990DbZHM
	7cSM0D46ImdPXQWxPtt2iMUOqwJDj47Xh+/3fRESE2JDiyldBk/us2mGBI6eA==
X-Received: by 2002:a05:620a:2690:b0:939:b55a:3c7 with SMTP id af79cd13be357-93c344ef4famr76423385a.41.1790197850184;
        Wed, 23 Sep 2026 14:10:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2485926esm305893085a.19.2026.09.23.14.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 14:10:49 -0700 (PDT)
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
	hannes@cmpxchg.org,
	Brendan Jackman <brendan.jackman@google.com>
Subject: [RFC PATCH 4/6] mm/mempolicy: plumb alloc_flags through folio allocation
Date: Wed, 23 Sep 2026 17:10:38 -0400
Message-ID: <20260923211041.3127588-5-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923211041.3127588-1-gourry@gourry.net>
References: <20260923211041.3127588-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: obr3hziisbhb4ggjt767kfw97gxype7w
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 32E87180008
X-HE-Tag: 1790197851-468904
X-HE-Meta: U2FsdGVkX199CjydQ5DklnWgNjrZ6pRkMZ2XyatUZ6szp4H74/scByxxcXhUqTlPvkKIFN0RPCDrO1DtKWYO7Sm0VkOMw0Qt0strfURA5KDe5PPsrZjIxZ+LGYlp8rFMzPTubokoC0a+tqkd2U26KDLalZllvwzXplYuViJF2PmwRqECyeuc0+fiC8zoS7aBo8eSu/O7A3ueXILjkIXehByRsDPK0e66/TLCuicGGbAdRESTKnXCXnq/FCLiC/nxnckUCcaPbnbjFnmwMuygqnEO7yog7fjjA4+6+lr2Kc7dK1w+aO/QTNewL6LG+J6iKfFCJhLu/1gZc4UUyuhJ12eqQPNhXg0WTRFKQ4gfXCaH05xDbw/9QyeS1AG6GIvN19PY9nyGjlDnxHg6v0zMoiK81XRU5cENObkX97cXkmADGuWVRPXANjHThuRsWLYUAQyNv9ulD3xgd7hrHcYHecj0sjEw8PPwqNHhmRi1am/2fcLGnj53bXf1UmEoRRlSRv/SjTkPKLLB9Se4L6kWpTsEvKRw8px1pCQTZBWhEWpFMG8b21/ivenEZ6NciMBwZ8NSdhJL4Km6aofrn8+fmkD0dqOkwSRNJZONeOTD36fwFu4pXl1wWhKRf6NKuyHWR0PlTAWUdK2s64eZfiUcb4tzU2JPPpVHV3gJO678Dpn2pe4X515xs/rLGs9Kq9/TvfPw53UGD+morGSq2O7G1FaHFmhHvBAvKcrKdEk34i5xx6lifl22Nb0NvD6M43rD5VZWGg6slORnaYfGUewWyEFdHTaWgv+umxA4RQKyc8queNZujcqxySl5EYlMSSvWu/nEwX0Y+UWy6A8Wc1o1AveQTr6qKhWOBxcWBVezBX50eJsEapVuhMs8TAX8BBeZUcf1XN37UHmokyeHxy5JNX/h27F+P2Skk/hF2whE4KvqNh7sTrwCIlGMzyMlfVvz+NxeBvBdJMzxcvAMPX5
 S9+zsxN7
 bDx4t0dWVMh//WVn38X2HwOqx+gvUukj3h/K8LslmVHuhq719M6B2HLvtCOHkXXbdXUWRCQD9FWvtktvHEbpanN5i20vjlUgt6wLMJt1kW7IBB00XQwXDSfVlbTPt+CMX4AaVWF0/4CJfOBBZt1brEKPG0RScIyxLmlr/vEkTdFwXcF8JXXdSFTbtK0mAxCx2gRowLPUqJ/rCPUP/6T2MzVZ++4v0gHUxopvBIp5d1pjScFY7X5j4EDU9cRgiPwb1vp1el89M5tCV0NBBhHTAM4i2vGrjQ7YAYVDevwFZZN6OboXedUSK5YBCv9BJbZOVXXUaOWRH2wSZVRDhxgrDMocq+gKx4HoujHYWdgctOfVjtMKJEjd0mnFEjBghwlAyqlYjSQ+r1KZvfXZZlyQ7l73I1S21v+1CVLgb2SCEppnnaiFX4rtPx0gy5GVWqpzN4ltL3apY0gd3nDuJe+yxWmR9kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Brendan Jackman <brendan.jackman@google.com>

The NUMA policy allocation paths hard-code ALLOC_DEFAULT before reaching
the page allocator.

Add an alloc_flags argument to the MM-internal policy allocator and carry
it through preferred-many, huge-page, and general policy allocation paths.
Keep the public mempolicy folio interface as an ALLOC_DEFAULT wrapper.

Task policy selection is not safe in every interrupt context, so non-task
ALLOC_NOLOCK requests bypass it and use the supplied preferred node
directly.

No existing caller behavior is changed.

Link: https://lore.kernel.org/r/20260726-page_alloc-unmapped-v3-25-6f5729aa9832@google.com
Signed-off-by: Brendan Jackman <brendan.jackman@google.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/mempolicy.c | 44 ++++++++++++++++++++++++++++++++------------
 mm/mempolicy.h | 28 ++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 12 deletions(-)
 create mode 100644 mm/mempolicy.h

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4c0b8ff1a7e6..2c01699081b7 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -120,6 +120,7 @@
 #include <linux/memory.h>
 
 #include "internal.h"
+#include "mempolicy.h"
 #include "page_alloc.h"
 
 /* Internal flags */
@@ -2437,7 +2438,8 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
 }
 
 static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
-						int nid, nodemask_t *nodemask)
+						int nid, nodemask_t *nodemask,
+						unsigned int alloc_flags)
 {
 	struct page *page;
 	gfp_t preferred_gfp;
@@ -2451,10 +2453,10 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
 	preferred_gfp = gfp | __GFP_NOWARN;
 	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask,
-					   ALLOC_DEFAULT);
+					   alloc_flags);
 	if (!page)
 		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL,
-						   ALLOC_DEFAULT);
+						   alloc_flags);
 
 	return page;
 }
@@ -2466,11 +2468,13 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
  * @pol: Pointer to the NUMA mempolicy.
  * @ilx: Index for interleave mempolicy (also distinguishes alloc_pages()).
  * @nid: Preferred node (usually numa_node_id() but @mpol may override it).
+ * @alloc_flags: ALLOC_* flags.
  *
  * Return: The page on success or NULL if allocation fails.
  */
 static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
-		struct mempolicy *pol, pgoff_t ilx, int nid)
+		struct mempolicy *pol, pgoff_t ilx, int nid,
+		unsigned int alloc_flags)
 {
 	nodemask_t *nodemask;
 	struct page *page;
@@ -2478,7 +2482,8 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
 
 	if (pol->mode == MPOL_PREFERRED_MANY)
-		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
+		return alloc_pages_preferred_many(gfp, order, nid, nodemask,
+					  alloc_flags);
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
@@ -2502,7 +2507,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 			 */
 			page = __alloc_frozen_pages_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
-				nid, NULL, ALLOC_DEFAULT);
+				nid, NULL, alloc_flags);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2514,7 +2519,8 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
-	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, ALLOC_DEFAULT);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask,
+					   alloc_flags);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
@@ -2530,11 +2536,18 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 	return page;
 }
 
-struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
-		struct mempolicy *pol, pgoff_t ilx, int nid)
+struct folio *__folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid,
+		unsigned int alloc_flags)
 {
-	struct page *page = alloc_pages_mpol(gfp | __GFP_COMP, order, pol,
-			ilx, nid);
+	struct page *page;
+
+	if (unlikely((alloc_flags & ALLOC_NOLOCK) && !in_task()))
+		return __folio_alloc_flags_noprof(gfp, order, nid, NULL,
+						 alloc_flags);
+
+	page = alloc_pages_mpol(gfp | __GFP_COMP, order, pol, ilx, nid,
+				alloc_flags);
 	if (!page)
 		return NULL;
 
@@ -2542,6 +2555,13 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 	return page_rmappable_folio(page);
 }
 
+struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid)
+{
+	return __folio_alloc_mpol_noprof(gfp, order, pol, ilx, nid,
+					 ALLOC_DEFAULT);
+}
+
 /**
  * vma_alloc_folio - Allocate a folio for a VMA.
  * @gfp: GFP flags.
@@ -2586,7 +2606,7 @@ struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
 		pol = get_task_policy(current);
 
 	return alloc_pages_mpol(gfp, order, pol, NO_INTERLEAVE_INDEX,
-				       numa_node_id());
+			       numa_node_id(), ALLOC_DEFAULT);
 }
 
 /**
diff --git a/mm/mempolicy.h b/mm/mempolicy.h
new file mode 100644
index 000000000000..8d2c07868f6e
--- /dev/null
+++ b/mm/mempolicy.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * mm-internal API for mempolicy.c. Public API lives in
+ * include/linux/mempolicy.h.
+ */
+#ifndef __MM_MEMPOLICY_H
+#define __MM_MEMPOLICY_H
+
+#include <linux/gfp.h>
+#include <linux/mempolicy.h>
+
+#include "page_alloc.h"
+
+#ifdef CONFIG_NUMA
+struct folio *__folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid,
+		unsigned int alloc_flags);
+#else
+static inline struct folio *__folio_alloc_mpol_noprof(gfp_t gfp,
+		unsigned int order, struct mempolicy *pol, pgoff_t ilx, int nid,
+		unsigned int alloc_flags)
+{
+	return __folio_alloc_flags_noprof(gfp, order, numa_node_id(), NULL,
+					 alloc_flags);
+}
+#endif
+
+#endif
-- 
2.55.0


