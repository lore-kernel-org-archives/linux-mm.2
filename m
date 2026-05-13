Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FAE6CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA1F6B00B7; Wed, 13 May 2026 09:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1BC6B00B9; Wed, 13 May 2026 09:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0756B00BA; Wed, 13 May 2026 09:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7AE76B00B7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:09:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B26EC207D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:15 +0000 (UTC)
X-FDA: 84762427470.04.A5A8315
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 73351A0007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=h3mFB3Qe;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXUIDcJ+Gk/7y1fx1IgYV+5y2e2wzxCiGEVbnTW1zss=;
	b=Eyp9Dd+kO4E5e3wzMO6UJm6ocscWfMGq84tzXD8/xErBZtn20uT/KtMBtgXj3oTMHkTQsN
	EGMHTqDGACriMaz0Xo+QlSzGWDja14WFmAMdcDvZbXUhF4gy6txyDmihamwX/f3gHqa+HG
	2NsyZHdKTX0u+BF+hDc8ksaBHiYnu9I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=h3mFB3Qe;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677753; a=rsa-sha256;
	cv=none;
	b=Uo0+mNSnExMaJy7NWLQaSFp9m51vdFPhi6DF2DRqMGI7nLr8W2l3QXeCcGZ4P/jxFsjdyj
	F+X1R0sfN++Gjefo3/s20/TnzlccJRMeBSoGSZxDaNP6jH4sSh2IXprfuouTgi6fxPxEuW
	F8ueQbZ1M6YxxeyElZ6cRH6z90iVf4w=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ba928852a5so44864175ad.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677752; x=1779282552; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QXUIDcJ+Gk/7y1fx1IgYV+5y2e2wzxCiGEVbnTW1zss=;
        b=h3mFB3QeHwhPWvq6MsI3XcCDLidOw+r7NIZ0naJZYj9beGF4upxd8CobbUu7VspMHN
         MTwdoomKD+5ZvCDcftT5zbiVYUBiBQGof0MnQ6GLEE+N3qJVykpn8tnsztvffeR3rDvR
         Wm9vwcBLZ1a7ox4c4PjWLv3R7ucs1O5u6pufOzdWDPCgBP/C33NMIed/Phez7fJAOyf9
         epEVF08yo65Jv/x1IH2wCABQIMWzB9B7bNxPcTsgoysVwcm8xVKqmGq4polGsBhA4Fjn
         rthpqu9hUGA4FSGT8hA2SPuq6PNikDDemQKegZDinNx8yTLARWgi2xcH2NibYCAMf2en
         CP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677752; x=1779282552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QXUIDcJ+Gk/7y1fx1IgYV+5y2e2wzxCiGEVbnTW1zss=;
        b=Esj/oWROLZmn2FZXQhDrUE0org5NJ8lTFrE2cD93CJBHc3keaySKn+D+Tsesf3k0xg
         Okob7EasUfhyVQFMe1JxZk1TjsqOBSvWALeBGgcpiMQDdiRbCrmi48XoLe1R+KwmZcAH
         2dtdhsnsEEDkoko1W9eVK5yoIi3Q2cqk35SeSr6mfhX+yB5qR/UGz8J0QmiIgUdbKyK/
         +DiiYP5273v6iqAbSYz3nDhmSNqVlLMUVWtpNr78H4cuA64N+hPTnCP3eq2gEdDrKO3P
         KzLMi+OjO2J5D8UC1/RQ79ww0bSWCaYNN5yiVi4V4DYL5I7ShRxZFmUV64BfSdoWTooo
         r5ow==
X-Forwarded-Encrypted: i=1; AFNElJ/sGC1fpJ6k5C9taR7GeFq2nIWcwHImuG2wLLkp6M5VzEtS+t21eYoSPmY0fOZlz/lAmaEKDNyEoA==@kvack.org
X-Gm-Message-State: AOJu0Yz2BHPdk4kCL5XWVJwWXpVQFQ94nzBD8kU4kBHa3iA5+Q9fF8s1
	OIfC7zm4G3FCfzjBNQ1kqMz9oDDGbUNHUVgkMqIOVciXx3Y6z4Wz+JYpQ/q36UgcACg=
X-Gm-Gg: Acq92OFGyDsvsI+0+ZkXJEldopxAz35va8soDxYQPCkHIOO59H15LSBdI84ksSFIKBR
	JB1LNx20m0ddUlw/7qQz3Xg2lkumKGZAcZPDRPlNdR2yhjJYsl5jxHxF6e7fNV1kITQpxZqZfFb
	gUuZIHYt+gkSh34/hMIC+qBQpYjqq542R/vySXPq2DvejREbWeKC45pkmf+2SRiz8/wuD3eVL08
	V/paMmU3iSwf1E5k0nKRUAN8z2PFH53V+vG/V2D8PnOqFzDAu0wMbJA2q3XcWTaMJ1R7HZ1tiIm
	Yw1EV57uIMlGz/S9UHhCBaVfae+VCcZQ3fZeeHXp2GUi9KO0v7J4G+vwEP4Y0aL6ZncAhCUpRpr
	KU2e0IFuLF0HAdGroxRmnkwhiejfLl3Aq40jMGkOBU9vFw0JAHyV5PjZOI4p5GasteTWhemmEid
	3tiCxX7P61t97fdiUv9GPiZobNzxolxUMfvDcn69izzv9+UqDMhhJtcjEjvm4=
X-Received: by 2002:a17:902:7d88:b0:2ae:54b2:27c7 with SMTP id d9443c01a7336-2bd2772c78bmr26046865ad.39.1778677752045;
        Wed, 13 May 2026 06:09:12 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.09.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:09:11 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 18/69] mm/hugetlb: Remove unused bootmem cma field
Date: Wed, 13 May 2026 21:04:46 +0800
Message-ID: <20260513130542.35604-19-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8tffiuo7kt4nre8yn7dnx4wp879qnkg4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 73351A0007
X-Rspam-User: 
X-HE-Tag: 1778677753-214992
X-HE-Meta: U2FsdGVkX19iME8zjyZqZ5KoN31c+MD4bi6EhBwJBagokdOItfw05o1pufMxMDy6GMsHIfu5h6H4NloiQ+O+5jRviLwqxuW05cDwCGxffAeLRArKcx+klnsScnx+DQzMYCIOu/6adytfMJp+/aStAcUFgTQeEmgBeLTq1z0r+gJmjfrx7qfW0eO6/ErPNxf1V0ZcVioFCuAbGX/dm18qLe46FbbLBcHX52/crI2o4oCy52T5Blf2qqiiRH0TjfCELp1LqhuGC9RzWOr5a4eUQzKsEa6sagORQEuUmDaNUUwLnOxe28+FiqhtZoH8GOmxBqff/SULqM/sr5Ei81yIAPwyUNc/AIaUbHkVSUjl7j35USFGPQK+JpC3XxzUW51VgdxDgNKGgGyCTw8Amoo5r3o6uUx4YdTx8XyKBkZYHjgNqTkOi2tPtyTirKQBieYL2/2QlgFeF63rMDP6Dq+1A1QHfnp8DbTgcG+h/C//flHmnrkXVTI4GXPLqiZHKPCIhbaX/D2THhOKqn+6tQ/B7XLp1ObrdCTCdQK2jRK9kubf/Ii6/E8bppT2ml1moaww08C9ZCCMkWSawwRbOCahuDMIPohmmgNS5KAw2/kAjTqKP1xAq3S6gqWPZAmdcH/rzRo2V+34LOu9zyqnTA1gTfnm5co5XsIv+cA4j2O4xy1ZoFjckhi8GlFUx9f5Z4D5lICwzDk2XHvmpv+7AMBnO+AhylJLwcfA1bnqvaFKa4VzMfJtwAsZ5uS2NCqNsM8FBHxoMDv8w8OKLDh66WEaj0TMO6HmS7+/ZJDtzBGJhFz1hmRf80EilyrSwi4klJxGnpBzqM8qA+QUMjj8NCX3HM+lc9VMT9vBqGTl45n8ey/3gcrcmVBWUPXKMZc6oyKs8ahYuECPivPi0HuEEkcagxtowOznDILDm1UanNOgTf20YgN/DZ+uXKcHEoBoTv5Oe3YbL2kp1JUbd8c6608
 qe77aa8I
 CXsPn+3Iv4mw6aannv4OdM+LVe7eDw8/RxH4k781clqXmBDXqTnJnnhclE4pVbtYBH1I3XR0T85u0jNJB7ei+FiPNKmIOcssH4l1OIMZaGNQZJ377y5tCp5/JJlBtiJC4T8NBasxkMTbgfMJx9mOYun5Ql6k5ExCtKKrLCC5i6rUJ3OFVjYda3+mKjbRugcG+9IKWB+7lWAICTmuHtlH493Tv50MwmRuHG20Qbv44NtOYkHylGREHKAGFnij9Txl+bNIXFGmsLREtQLKVFXA9iXY68nDk5GaqNkz+d7Y2YcjQtbb8GA2Qqpf5M5VoW9I5ArqrZXQC0176GxS/LJm4EawODA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct huge_bootmem_page no longer needs to keep the CMA pointer. The
bootmem path only needs to remember whether a huge page came from CMA,
which is already encoded in the flags field.

Set HUGE_BOOTMEM_CMA when the page is allocated and drop the unused cma
field together with the redundant assignments.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/hugetlb.h |  1 -
 mm/hugetlb.c            |  5 +----
 mm/hugetlb_cma.c        | 27 ++++++++++-----------------
 3 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index ece4e6a4a4c6..fd901bb3630c 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -694,7 +694,6 @@ struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
 	unsigned long flags;
-	struct cma *cma;
 };
 
 #define HUGE_BOOTMEM_HVO		0x0001
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dcf8e09ec6be..1f0a0e31d624 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3093,10 +3093,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	 */
 	INIT_LIST_HEAD(&m->list);
 	m->hstate = h;
-	if (!hugetlb_early_cma(h)) {
-		m->cma = NULL;
-		m->flags = 0;
-	}
+	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
 
 	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
 	if (!hugetlb_early_cma(h) &&
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 6b5c2aec4449..fbe5ed7ffaa7 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -65,26 +65,19 @@ hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 
 	cma = hugetlb_cma[nid];
 	m = cma_reserve_early(cma, huge_page_size(h));
-	if (!m) {
-		if (node_exact)
-			return NULL;
+	if (m || node_exact)
+		return m;
 
-		for_each_node_mask(node, hugetlb_bootmem_nodes) {
-			cma = hugetlb_cma[node];
-			if (!cma || node == nid)
-				continue;
-			m = cma_reserve_early(cma, huge_page_size(h));
-			if (m)
-				break;
-		}
-	}
-
-	if (m) {
-		m->flags = HUGE_BOOTMEM_CMA;
-		m->cma = cma;
+	for_each_node_mask(node, hugetlb_bootmem_nodes) {
+		cma = hugetlb_cma[node];
+		if (!cma || node == nid)
+			continue;
+		m = cma_reserve_early(cma, huge_page_size(h));
+		if (m)
+			return m;
 	}
 
-	return m;
+	return NULL;
 }
 
 static int __init cmdline_parse_hugetlb_cma(char *p)
-- 
2.54.0


