Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61ECD606A332
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=aHvbE8tV
Received: by kanga.kvack.org (Postfix)
	id 7F20A6B05C1; Sun,  1 Nov 2026 22:27:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A24C6B05C2; Sun,  1 Nov 2026 22:27:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643386B05C3; Sun,  1 Nov 2026 22:27:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5C96B05C1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:27:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 954D080AE9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:27:07 +0000 (UTC)
X-FDA: 85388742894.15.1799057
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id CDA0840004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:27:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aHvbE8tV;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793590025;
	b=nzFS/mqKIVkOJEHuzfKyVSGyAUEw8dmU1oiEALxHwCYmz0iFPEgphnwNFfvNy1FxP59rzp
	77LSptgWJBQbFDI6etbVaOVCvzJf0BMWcgAKNmT/JVAV1nK29GX1IkeO5VP/bSln/Pxcrx
	d3dJ+Ke71olb2nXsZIcjE47egA/4Y18=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aHvbE8tV;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793590025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wR4QS9sf5aXAy1p2aA62dnVU7cHMfl/lsPn7zq5mVb0=;
	b=JzAROG1dyKhGzt7Fa/66fekNA3lFGLkZH3Ba5qYrzKCfTXbTAtUyBeSbnuzkx5Ga1Isxgp
	QhMc5l+gEVTXr9+DScGeioBmcA1/ARtmVopO76tutnLdnr6D7PW+XzzlQi0LyUvxRKOCOC
	hIhAdqqFJC9AR51UZLQ/JaRvgvW/+mQ=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ae702d28c4so1093521a91.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 19:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793590025; x=1794194825; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wR4QS9sf5aXAy1p2aA62dnVU7cHMfl/lsPn7zq5mVb0=;
        b=aHvbE8tVx2bzOt0uvEzeFEKe16gHLP5QqhyuK9c0+BVn4duIohmnIkgHtdS8Ib+HkD
         3Xq0H2x7pCFsY29TJJMPOcD6MAy4ncT76jhbDwnp0grPcxugfvzDXSExnTz9K3sNLqjZ
         4tQl8SHNAYtaWDZg3om2NdYWMRh0lnVrXpCeK12h4Poj3PfBMooMdVZeTITKMj+y5lCm
         iJGFs3mKC0EFTjxY2N855eisisE0a5Nr+LJMEFgHv/w7cUQjRT3D/HgUg+q8hnk4JqDp
         MIDH4jFhBsu5wg/XDDP2t9HQFG3j+2QP3CWrCK2HveD4R/bySMIBDPX3SX1pE/ZnkuBD
         I/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793590025; x=1794194825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wR4QS9sf5aXAy1p2aA62dnVU7cHMfl/lsPn7zq5mVb0=;
        b=YuXeHXcK8sar1LMp7sq9oAjETnMgV0W2/yw7fwq8wVFt3am/Sxy+OAQ1VjZSpBHnoQ
         2T8ClJqbnzDoHeQ8lCyAeQh5v1GSQtOOt22fo8Rca2KWKyMON3s1+gqePmVCBtjlJTjB
         zH2vSDkYdpMhbhjGtbRod+0vW973s9qQXWKK7yCQ9ql9kgcurga0D7lH7G+MrBbET7mn
         4SpnLYpst32lxDO6WAgkuaAQYkm+YoyCgnKZGyknq57VeeiNQXkApO8R166FEtwhda5p
         MAgKtax02EBh1su/aEthzQHKlQTRXud28v6GaEE/x/JkG5CNu1bDfo2BBxjOmCHu7iFs
         1MFg==
X-Forwarded-Encrypted: i=1; AKwUvBwn4Pe127ZkzTpzsc9V1pcwoXGYS0LVnLgGSl0AKuKzbaywEv4JoVZfa+NQjw665NWy+rzMjERwww==@kvack.org
X-Gm-Message-State: APuU4Z9uY6YCbNnf/fwWmXMjPFn0VcglctdDjjK0TCADYgdUu6J9d3wA
	83/0HGsXM0mRPc7F87ZipuVmpQgBLeLwpOGJjh4eXpLs+R3hq3Fx0Pbx1+JMnx7DRJY=
X-Gm-Gg: AYBFou3xpsEviSuqE+cn+K+49coT30akRuP+RYLJcuuZWkO0A5WMdn2Rp5CI3IRE6zP
	PRQdHROyyrq7vJk+e4hppdYnzTQXZlGsgPfgUWnlvqPgl53DrqaHKnXgTChgh7EmgRRIU7TiiqV
	asUuZaE0FR3k0JJ5Sf14YAuuI8dhuvzy8yeTOMXHpPxKtt4ECs1Rgjl2w1SDkA+VlayZgbXlKPJ
	26cB2M91XSvIh2AbWD0xyNTeKznH5NFiZITMLYmGRVFqCLFz/Gj5DTZIVkvjt9/P4mCGznr4cH+
	8QQyQmJUyHeZtue3K0TTTVda9b0vkHt87nBZVVtoujpyhmRr2cPC/UW98unzrAoN1p5upqKKsYz
	KTHW3jMfBWoCEFbO6jsNIebmnv1P9qFdCA2FfeeeRa1HLRC/iZFOoYKJZOFTQVSzLyxqvjabVc+
	oa0UCwmgBsMW8rUPiL8Xe8kf+6lmkB8xV/Ap9YkwEtmYHcB2DaJfCyWIE4ID+H48kcwdBJVUBt8
	3SiI1/1i7d5EXPF0XcSxuZiM1t9ifH5sDvZZEsJEJCDIx7b9xukI6f2Sa5p69Nloju7A/NrleND
	yhJWPotLaEyGOL0oqxJ3vFsvIwgQqGe6LjGqLEHRqy+UH3BQdg==
X-Received: by 2002:a17:90b:4ccc:b0:3a8:32f2:f4a5 with SMTP id 98e67ed59e1d1-3ae898385aemr7458530a91.53.1793590024278;
        Sun, 01 Nov 2026 19:27:04 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845984absm12303317a91.10.2026.11.01.19.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:27:03 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 11/12] mm: hugetlb_vmemmap: unify vmemmap range restoration
Date: Mon,  2 Nov 2026 11:25:24 +0800
Message-ID: <20261102032525.3597743-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102032525.3597743-1-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7spnmncuwfeumqcgp384gu73zg1h6giy
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CDA0840004
X-Rspam-User: 
X-HE-Tag: 1793590025-333964
X-HE-Meta: U2FsdGVkX1/nIp20ToW96HC0v6zqp6FAs2fSWRgMYDVs6KAq0wZ+QLDmLYQQC0A2v/pzyniNt4djBxh1jvjTA4jNvtGkuFlvNlP29G7dtKgyp2PtnD88U5VL5Mp9npgt6DuykTnriBZpSM0Ac25zfmh357jQ3cWZFWiyuapLg02EOIAcrKwN7mPrRsjW+EvQDbVc5s0VMCSltvWEu95Z5PNtz6DJ2ZIZzv300YOSwYA3CxfgYKf/Nw7jWrf/3/n71l0MNICAPfuvDwFFHYw9ck7SaJsbIs5pV6mUW+OExC6ho8zdv8Hs+n0M/0eZVc6jvx0tofbefHid6lcub46z8fP2FZa7LcWOidwsvFw4ApxAk0KPhYo6S8Mr3A5Ba8CW6gdKyQ80tpGlwk2G0x+fHuuEnHb+kKTGq3/y5Sjr/EngY9DCgkJfCpbDdoWchN3RW1s6jIcnKYB0FGVdXWxKeEzCPzwWBlkAkmUl4dqSqKj1xAnvJgtI+GgHvXzVYw7sl3BjypWBjnwjOeazd7eU+FVSn6bBzpJUAzhgtVLNT0TyAbXx4d56fZzQtAuZ3xkxO7+c+VdGfnoxQACmNqKQS3ZMt5h9Qduk1eDaU3XCgrccZJ9FX1Wzn9UhDEMQ/wwWSwFHCl0ppYojHBgXYCbFY9u3GwKU0j2ipf+706UKrBYRggtDaL9KW23+uTPcu15Zw8WWZte5J7dPxLo+Xu9YXuv50Bs6qXAQq4+85q/Djg2d9IqLZZMTsz52Fl9aHAtFhn6EvD5pPsbKMyAsXHpsN2ZiAOAJghv6KHNxvT0N0ekSDQpBU7x47RZ9HtVEwazM1uzrBwEhzNst9ZnwLBFwWJ8SpniV34Uk0mWDtmH08uYcC59HJwelbqvJZhPD93b50G75+mUdfaRhEdlUrAASqqO9xL635f+iBA8PPf0Y4ztoVfYaqIcO50KB+Ca7HLay7oogjw2219N7Ki9tP7U
 AiY9miL6
 6KKsjv/ykcpCIygaGA4jMFYl5NswSInp1rocO1/vgUwEXgJX1N9/gOMkcZuGlMzuU6FnW1empglCVsKsV9yjCyud9c3ehA+27Lv0OKZ0nHNtZNFmH9rKUCD7AWh59at1AHr/ZThrBRjxpoJygJwzcSKcwyBa1PF116L+310wZ2wDeLxcse6EutA61M8jOsDiyrhCqf6HosdgsGyQUMdKu+ofrU8GO0YaK2lIb51OEE7Xg7KM9jXTvVC4Timrlfk+SyPmpeE06fmWxZPYL1yh1EIJRixmE2MSeF/3zp85pYeRG/PTP+0UqZQnnR78NLmw+94UWOzStY3gvqDAyH5ABsnnoHMvuolqDrAmQvlKrHwCd4XDqsZh47WBeBwo9yOnDxnzwmHuahz6wFB/VGB4+1TIDu8ynN2rV3PgrSoR0XjwfeJfpm4Rvw6714kJOdpt1St4T
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
---
v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 465a907620ab..370e604c8056 100644
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
@@ -345,19 +357,7 @@ static int vmemmap_optimize_folio(const struct folio *folio,
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
@@ -379,17 +379,12 @@ static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 	int nid = folio_nid(folio);
 	unsigned long start = (unsigned long)folio_page(folio, 0);
 	unsigned long end = start + folio_vmemmap_size(folio);
-	struct vmemmap_remap_walk walk = {
-		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_pages	= &vmemmap_pages,
-		.flags		= flags,
-	};
 
 	start += VMEMMAP_OPTIMIZATION_SIZE;
 	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
 		return -ENOMEM;
 
-	return vmemmap_remap_range(start, end, &walk);
+	return vmemmap_restore_range(start, end, &vmemmap_pages, flags);
 }
 
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
-- 
2.54.0


