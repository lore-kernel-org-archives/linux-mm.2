Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4043B606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=V9zBsTf6
Received: by kanga.kvack.org (Postfix)
	id 33A226B05C3; Fri,  6 Nov 2026 21:30:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EB2E6B05C4; Fri,  6 Nov 2026 21:30:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B39A6B05C5; Fri,  6 Nov 2026 21:30:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9B176B05C3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:30:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20494C025C
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:30:21 +0000 (UTC)
X-FDA: 85406743842.28.18D8356
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4FF74100008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:30:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=V9zBsTf6;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzWys7rD2mzog2Av+jcuYf8OXU66Yvf4rDiAeaSLNnU=;
	b=I0CqX7vISxNKNoU6MiRtbO4OhV1bi5mmNPO4o08jlOekVPIGevDDiV2M1wijnxd9oc7Ees
	BwvUC7icQDBbC1of3LgcZleOt4ARVbC/iikQ5C7iILLEgGY+qZZfTX4TFkQZRFGtvGBVnI
	gFY09x9CB2M8YpQjeBrr3+ta3Z4p2Gk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=V9zBsTf6;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018619;
	b=st7vqMFN9oato87Yotp0yaIowdqzXBVO3QR7zmDdb/pcHvcPJaIo+v+21ooeVFt/nj8X13
	14CfPyZM+tj8G+ncldR6F2lXSTBgTYLiHlrqk4cz3uSVzjoh9GGF7tD5XjjwBHVEoJK8SM
	agl4BXXMwUXZTAQPz5WQE6hFbPJvv2k=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-37071c0f42aso1569267eec.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018618; x=1794623418; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tzWys7rD2mzog2Av+jcuYf8OXU66Yvf4rDiAeaSLNnU=;
        b=V9zBsTf6K5juwYCxXV0wdtldAZ/j2va4v8f4h9f2ev2g2EQ7DZHVXRZosacJgF1l6T
         AHJJB6kth7DIUSeRt6dx6BXePc3ax781AvfdQNC/GikLaLfFy9RoXqxRKCrLkz7MSqLu
         Ln9hzR8LwtbdaReXvBDAe1eCf1tMTivgpqGiGgg2e7yHU+pfFfqfn2kKWwXbzc9cuGYm
         n9UJOo0zZtk5hK5OZQn5DDeg+Xh2vCQnzzLZVmp+xPgFy8sKEPExDIG6vNskiSzG6EDp
         mpIiZZgFU6UiYes5tED1MAZplpmCroOcdUkpfCwt22Jn1rPEyhqtmdXnbowIbQwCNoSl
         Ql1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018618; x=1794623418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tzWys7rD2mzog2Av+jcuYf8OXU66Yvf4rDiAeaSLNnU=;
        b=gL5CvKQeg06lX8hHAXy39Wtj/5nOUwFSlbh6FNUJRRflPi79WxknUT2u7VHtNehGaN
         WtVUbnDXTQk6m13A4JfhDoikRB0jcY6Bi/Ds5WfqFA8ugh3tU8MimE8cW2mLB4IWPoH8
         kSyOr0fD1pJjJ/sfhhrk0jEu20twCcE+zT8uwgudJwXFqXFjIAP3MHZs0f+ETp6IfMa1
         +t6Dgwl+MSWDIBaaAi6KlYtMHeS4GcEhQSW5+lKqPTRrDouyNnORGEpVaB+UWwgWgksl
         GURFfT2T1KplLYU34CXuNs0MOOXwCesBExi+t6xnTsriQAEm0ZFUNtFd1rkhiuSYVoe3
         tn0Q==
X-Forwarded-Encrypted: i=1; AKwUvByduGwqz/cIbXfVDhC1pNR1gh/4KiJDzaG9TKCb45+19W3FxSvRzKVDJnDEVP/AcU6hYYrV6dyhog==@kvack.org
X-Gm-Message-State: APuU4Z9tjeuxqVlgehWfXPwE6bFexKGFogjNlZkyTMMMsejr24DBTweY
	UT3QCfB2zHalcd53kEMnqA2xvfp6bBMC3JR2zZWETRXSjrrN6q11LR5vW95QPOzdGuY=
X-Gm-Gg: AYBFou1Z2YjDThUhw345/tazintolBye9yZgo4RjnS0kKeqK+eAEneDzSo7DjFe8YVc
	IHSdEocWE1J5veXikGeas9/wNjE/F2MtBWhWVSiXb3ui1+zpNFN4ZLiie3WqmRfacyuVOdFuTdO
	lEXJ6/Cy9RP0lUXtAOx8rcEr9qvaLmnK3EgUvZQosTvsLwzKPXztdCpXWvmZQ2X2cy5ZJsfXjk1
	PhLsAi0t2Qcrl0z2fFV3cTcrRZQ4JtcboLuMICtWdbM2xzl5B58cxg1CgS1VHvKkCah1t169leW
	XENExSf7fyi9xBG3MBcHCNJV7U7fGGJTAewd1As2Gn5yVXkmRN2ufTPHEFeaO32C9n/gFv6tUOM
	/fpgJygpa5Rr2dVGaQ1AAhnAjtmDXfL/QuYG8KClbA8fHvxH8m87VsGOgeJdwOVLCLniXVvJTAB
	ZgSOYiygfH1GqhDSgemasHQwVTdVM1/3d8INSMHK006xv0p5/FgqcMeVt41bcPf6tfwwK2Uom+Z
	qbT33bwt5hGfJwMm3q/ITwo4NF/vtJfLCAA1Ak0hb82dqvJKIfa95TGIypLnQNewA+Z8ZPQes9B
	1gkvTsvhT8PYR6XcueNBVSyaWo0HRc9N7YzK4benZBwnDhL8jayKRJRvqmtT
X-Received: by 2002:a05:693c:68c3:b0:36a:32ac:ad89 with SMTP id 5a478bee46e88-36f722e7fd7mr6072905eec.2.1794018617901;
        Fri, 06 Nov 2026 18:30:17 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.30.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:30:17 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 12/13] mm: hugetlb_vmemmap: unify vmemmap range restoration
Date: Sat,  7 Nov 2026 10:27:55 +0800
Message-ID: <20261107022756.77731-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wije1ne6spcym8cpndzaj3791ddmuq3i
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4FF74100008
X-HE-Tag: 1794018619-525542
X-HE-Meta: U2FsdGVkX1++CoqxatLR4EDu6nXkhxF0RbeBHSnMmccRG4nCw3TrJBQPfZui/f+9CaIQ1bBqWhwkEXuLwlBweMuvHeTXCA5JTYn7rZ/D3Ww2xrxR/OX6etWbAlyfX24EZfnpxSb0ceaeVtZvFoCGhOA3o2XbSG6IAVBdMyGY+hR2dGG1V3w9tSZLmIHxqbptaNFNheaxhflnhSU4I+v4JRBuAvXE20Ne5bB8Ai/JixetWzhiYaqlxhK7rM2vULHGwpXOiyHV+IkJOttTZqm6WM6iDIaHg/Ig5qJ1dJ08nuuCs6Ixw1TECiTO8cXvvSnbOW3hWAgGMcnCeLkdRhz0Sb9xbH2ZX5/4PrCRWOYyleQJ5JbyBG6349srXYaBDSteNEaEPi8COn4LjwXHVUUVc9iVMZTm3Mg9Pqb0Q9z0Yted/THanCg14Hs2oSX91hOJ6ggBrlW2DHUbBSkb3F8UUEOSxXq2ZYp3OMAjDcRHDjI2/MVP2fLpBE2CAuAo43CMx73JW6BvCaXvNqNUxwRENp9gtcYY0awZf5wO8MwGVLn7AfaWgDWG38w3dxzU9MOcHyfpfGNF2mroYJ+ijO1QWXvo0UmWAKRE+8ETuNiweEr/akS6aUvPq9cJsBG5TtobVPn5wNo5JuhaYAaUZWU+IQPCwdOKnC59IvPZYDsMnOeIZ8kjXG502IsqbZUMuMVxKYHpoWH4CcVv05BZ+Ijq9p/BJ1tzpZi59BFukTKrmhiq+SJCvbqCyEoPgCHNUgw4YkFD4zydK9YCwplNK0p4AF8PjJPBrH3ql4uKPFircjncfrW1Ld9XXnMF/X5DCDaIVZsyTV+BbgQLRNnkRYdw3T+0I7Ncu7naHWXpsf80gR+JToWYs1uuVjUDjzdlpwq4NyAQT39Q2c6lyyutB24m7Pi+Nhhz8YJA1hYs5iBv22k9pAvuyrmLtac7T4Y9BalG0tHjB6uF3eACJpKewMo
 Tp7MBcsX
 rSq8sfpeyvL4vOTUd1iXlI7TWCZ57WJ8wJhUCCBmSF+eheK15offIYL6yP0K7r3FLjIGNPYhEi+9d64avX98uSKczIpkGYEZ4Q8wI1tT82u0Bdo3uRjEOSBTFfC06qWdtC9bLEzESR9hmvlJc/xy4J7IOihtDmXFj1CWKf/iqpF8l8BeNJq9LqXim5yyphCWW8tR8x4RSnsUFx6rylm+N+JY1PBc445kdzazX6A40rZuVs2v6AlUkN4O2LP/5BuIuyRSA+coBE2Tle89+NWCAG1pNX0IYmfjKdIAH2PlaZZ/bw7ZySwdjJSP0/VmPhEeE1Dkl0VqTPe2zfeWxxZ202ZimtFWsCK8w6E0bipgKTOhhwbVGrRqoRiAQTi6Gv6eoqpEhqe2aa+tUmroIMCxgcyfeYOrTt3/dtLCQQrC4Y218sxkIdXWkGpR5NMqQdntAEm7o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Restoring an optimized folio and rolling back a partial optimization
both restore a vmemmap range, but the operation is currently implemented
separately in each path.

Use a single range-restoration path for both cases, making rollback an
explicit bounded form of normal restoration.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
v4:
- Collect Reviewed-by from Oscar Salvador
- Collect Tested-by from Andrew Morton

v3:
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 359e53302a67..b8c10671d53b 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -287,6 +287,18 @@ static int vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 	return 0;
 }
 
+static inline int vmemmap_restore_range(unsigned long start, unsigned long end,
+		struct list_head *vmemmap_pages, unsigned long flags)
+{
+	struct vmemmap_remap_walk walk = {
+		.remap_pte	= vmemmap_restore_pte,
+		.vmemmap_pages	= vmemmap_pages,
+		.flags		= flags,
+	};
+
+	return vmemmap_remap_range(start, end, &walk);
+}
+
 /**
  * vmemmap_remap_split - split the vmemmap virtual address range [@start, @end)
  *                      backing PMDs of the directmap into PTEs
@@ -348,19 +360,7 @@ static int vmemmap_optimize_folio(const struct folio *folio,
 		return ret;
 
 	end = start + walk.nr_walked * PAGE_SIZE;
-
-	/*
-	 * vmemmap_pages contains pages from the previous vmemmap_remap_range()
-	 * call which failed.  These are pages which were removed from
-	 * the vmemmap. They will be restored in the following call.
-	 */
-	walk = (struct vmemmap_remap_walk) {
-		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_pages	= vmemmap_pages,
-		.flags		= 0,
-	};
-
-	vmemmap_remap_range(start, end, &walk);
+	vmemmap_restore_range(start, end, vmemmap_pages, 0);
 
 	return ret;
 }
@@ -382,11 +382,6 @@ static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 	unsigned long end = start + folio_vmemmap_size(folio);
 	int ret, nid = folio_nid(folio);
 	LIST_HEAD(vmemmap_pages);
-	struct vmemmap_remap_walk walk = {
-		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_pages	= &vmemmap_pages,
-		.flags		= flags,
-	};
 
 	start += VMEMMAP_OPTIMIZATION_SIZE;
 	ret = alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE,
@@ -394,7 +389,7 @@ static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 	if (ret)
 		return ret;
 
-	return vmemmap_remap_range(start, end, &walk);
+	return vmemmap_restore_range(start, end, &vmemmap_pages, flags);
 }
 
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
-- 
2.54.0


