Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CCBDCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 05:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B52A16B00A0; Tue, 29 Sep 2026 01:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2A046B00A1; Tue, 29 Sep 2026 01:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40036B00A2; Tue, 29 Sep 2026 01:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83E0F6B00A0
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:33:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E54F4040D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:33:54 +0000 (UTC)
X-FDA: 85265683188.03.73FD87A
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 49E8740004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:33:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="hC1J97/2";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790660032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mw8H//cBUjqDniGMsK1MLuH6vPH2dGolHqesV1qp9nQ=;
	b=m1ubDOwVN20xlWGGuKA8vbPTmzUX66MOK1eUW0hH9ijaQXVF1/1G5IMWCCoiVOlMh6zfny
	2fd6t/dVWYjFvkQXRk181qoXE/AV0EZskFWuB9I8dgEuFQ5NKIAXFQ0hZFxAumn3xiEOVN
	8AnOJk10tIrdcgOiNY4xN7Psc+yeOhA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="hC1J97/2";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790660032;
	b=yE5yRClWflysEJC4P5jSwG70fsPx7KgQ73Ab7jjkRV6NIk6yZBlmzxRotJCr0grmm7TE3d
	3dzEYzEW7WmE4e8ZgvI1wNBUXXWh4MXKeUMSPnauW55J1y5ySxUwcRTYbjENhjfP6yt9aO
	NWZgqqgWJBDXnhmsPpEMOV3uNk1jFfU=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2dd1dcdcf95so2777155ad.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790660031; x=1791264831; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mw8H//cBUjqDniGMsK1MLuH6vPH2dGolHqesV1qp9nQ=;
        b=hC1J97/2R/AfoMdq+SZyqTz8Dcq33xu7hrWElKMhpjig7mlnGGP47gvXsu88LkoWzR
         3/B2YgJcvDYYWcKJ6nHUBcPe6B0jzEVDG1ErgLbfzF3j9GwLxnCFvv2isy4jcCeSe2kr
         b3gThZM3rWe2uVvfj3+wGXQmp63yltQpmHEe48yPXYbuE5dDauGA3NjkHuWKRDdzSYsd
         dy4KpScSGOw4OuIKM+elFJmK5pHA19csCv/xLMoKHE9zyXbDzHvPGVawz3FezFFd25fs
         nPKSsX8pVpbha9+IFgfoPL+RTAEhtyRwHLtGS2N0MunbnZRLB3yusYAnFG5MjSQerETf
         rklQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790660031; x=1791264831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mw8H//cBUjqDniGMsK1MLuH6vPH2dGolHqesV1qp9nQ=;
        b=T/nT2XyMIiwCyBBMVHuIm6geuMiFlX4umNiYqSy4ttS2z2FST+ZEmq9ae6kgUGsgI2
         tIhaSTD1C4ogak6uXYH/e+PNbjvtp0NQCmP8JGz1V3CeJEMtfhMx/WT+vNKtfKCTUb73
         ckzkTKSQ45YIB5YiEQ3uIu6n/cK0lPr92SsL69WmFL9vizQVt8nx9OssdFSyTXajjjff
         OHAvR0hfiYa5SuvMIIRJXK0g3JjIUVgZy7fesEAMkVcSqkgDC/moNr+W6JAJqpB6TlRH
         MqKO0sT3NbwuXFrWGtmiQQIe4dL4Akf9QFwvFk9zFr/Q9Qr4Qhotgw/nNqniV7BDixzd
         h8Sw==
X-Forwarded-Encrypted: i=1; AKwUvBzwt2OOpCvNaMT7GRBP9naEaUEHyZnGccxxJw/RXpH/zFFRprJS/dUwC/VdEdKmNOTJILOSecOQXQ==@kvack.org
X-Gm-Message-State: AFq9FYKnni16a5gYNiA6C1XIsxZ+dBHuYdzdk5q4ZDWhSYmHKF3JQ2t+
	DvZWvYL20NlXMOaxRR2GO/fhnKiFF4sV/jbOHQzWVSkk5fBhioIsq6e1zveMRJK8t9c=
X-Gm-Gg: AYBFou1iugqtq3Q91fPX+Wlft0RdxO94FS6bGUG22d4H7WAYT/VhY7yXUqxjU0z97/u
	7aNY4ia8c6f7i2EC2cZLj5qhO1JmimXocPKPeZ1gL0oG10oyiOH3VB+J1+fOyi263ao0dMTgYQ2
	62K/uZ+K4IvszEL8ic+mU7HQzRlTfqY58n49xNAguGx0kQctOFTltZSYOum+3WfqOT+EfvIc9zV
	fgjKws4nVqM0V1EW8bEmJ1PilmBHab0cEfElOqkenCentlKfoSWiXKQ8kyG1XzxR+EYkolVz0ee
	TzFCV2QhVUuZzWrZF5E9kNXLdyZV7wxtO0ferznUlwBTo3gpzdEXt5NxB4Vr4BfxVegnXY0XrgF
	hG+aiEiNAWyHkN6IPxEXyezgfIGJiBvM6QOCD/Eq7dsk4NyEEJt3Np6RxCQ6PHjjY0Z4lB0rpTr
	iq3QfXJ/mVfk20B9rUofzMZihMAi3JbweZEvzUXoWurIYvx9Y/MgmmLfEwLzuHglUE6AOLMKJGg
	t7QhCfmevqVrCFqY3M=
X-Received: by 2002:a17:902:f54a:b0:2df:3eaf:582f with SMTP id d9443c01a7336-2e2c49d6095mr8936165ad.32.1790660030889;
        Mon, 28 Sep 2026 22:33:50 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9142bafesm49251765ad.51.2026.09.28.22.33.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 22:33:50 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v3 5/6] mm/sparse-vmemmap: open-code vmemmap_populate_address()
Date: Tue, 29 Sep 2026 13:32:30 +0800
Message-ID: <20260929053231.66085-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260929053231.66085-1-songmuchun@bytedance.com>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w7p1965zo7s95t3z5bf9yguehf89i1r9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49E8740004
X-HE-Tag: 1790660032-306389
X-HE-Meta: U2FsdGVkX1/VD6lOCXnddFQ2Of0ylQ9W46Kpn+7hnd6c6wJ2YVKjkcwr1YH/TGRHhgGwih61TC0EfJ0oIaI8IzVu5c/sTBiaDXNYeIultlVqzmeUVZzsZWZ19JxcNk7xWBeN6DkXMojQ/HUWEoy3/mQOLauIRI/qljgTxgSElTGvDJn46B+qejpu/d+Y3Bh91ZCoY2Wt7JQ8CUJFDznVWsODkqCputyAdCsuge9M3yfCN9dO2apiDB+R4QXh/M2GLqFVGX4sicmv3jkpQ2NlCC+YPQHyRmuJQ5tUXuMrHimrTt5531g5fXddorW7y7dC1AbNMufGTRjC2/tz5hmKC7Rxi5vR5T80uIau79MC5r6Vli/vN4yGs3hSFcwvl0NhHUtf/0mPw/YOrDhOT6QJh8bjaPDtVVQXz7LNAbLd70tqtCZq5d58XD3OgfLe2HHJozwm+VvRf3EEn6PapjwKxsPwASSrKwjQ2Vyg2yliOQccXcfXTuKrDphME0ODigXYfJIyfVuM6lZAe5jt1jtWF/FCPfDMDAsfG1LD+RUFxmEhaqiWeVn/ewt/NWx2tTS5woQwHzlrFYLB7WGqQ/hiiCI4Me0cTOo7qEluzxfxbowgQ56yhRosYMnkkbZWS3QU963Zx7uM1cW2OJoQK4EJQsV4nwAFLyVaJhgwjCiiRDduBQ0YOl64nFLo8uuNgZWlZT4VHjumaD1KGHvEL2PeDAa/mf8/kc+0DmPavCacAWlYXS+uNbFNxdJLvT1AKDTdxxSmoMZntgRFavSGwffSRj0ymDCVIkFvNf+ppc/K3QOi1SkvErg9znKJIISb7IXGaW/sBlGAt59P6bjGIwMuyU/CBvQ5AnpdBEE4qS26uoFiPeFTop3o2ddkNrFJh8/KwbUyB467uBVQQ+iFLr3t1NVRFX/Byaw6+2/Z2yrrFIGttlZYE/CpvCm0/uXp1b4ogD3qIebf2eA+qVbnSJd
 VFCtnR7g
 AA60LqQkra4z4OeLFCheCivHy7cTELXjw7Nb4iWlb0YaUWIHq+LNkM1L9qhjH+E6wHZjbmSb6pFlZIRlac7MgnjKOhJ0wthsTfJRR7CeJYt+FUvpaLgt7gr9rWKBhJWRAekSHS+MdJfgBzlCVZmbZCt3K96jvWj/5MC2+2llHtoIh/IpbsxaIX6gRTilVIrrTuhHqftNFzqJhr763FtPx6vnq20nsZwVnlom9EpQ+qCqOvQoZsYGoKm7hTExE6eqGAxeh4uEhX58xss7BRspGZ+Ti1uOoTA4d+WlwcELA6aSijfvjxkmVqHwfyPrJQOOJhG6/dwyKVwddG1ygbS2HEL76oqsFnDJssa5xk0NmkEGfrBClWGHFp6Pt/ilK0eKYleyLR4o9umrxNuYIUeXOp+xJjeaWnwLi7hKUWZVA/uXwz9MkxdECMIxK2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_populate_address() no longer has any callers that need the
returned PTE.  Its only remaining user, vmemmap_populate_range(), only
checks whether population succeeded.

Open-code vmemmap_populate_address() directly in
vmemmap_populate_basepages(), remove the now-redundant range helper,
and return -ENOMEM directly on failure.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 54 ++++++++++++++-------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 5fd2df2b516f..9a58323dd628 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -348,8 +348,8 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 	return pgd;
 }
 
-static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-						  struct vmem_altmap *altmap)
+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -357,48 +357,28 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd_t *pmd;
 	pte_t *pte;
 
-	pgd = vmemmap_pgd_populate(addr, node);
-	if (!pgd)
-		return NULL;
-	p4d = vmemmap_p4d_populate(pgd, addr, node);
-	if (!p4d)
-		return NULL;
-	pud = vmemmap_pud_populate(p4d, addr, node);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_populate(pud, addr, node);
-	if (!pmd)
-		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
-	if (!pte)
-		return NULL;
-	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-	return pte;
-}
-
-static int __meminit vmemmap_populate_range(unsigned long start,
-					    unsigned long end, int node,
-					    struct vmem_altmap *altmap)
-{
-	unsigned long addr = start;
-	pte_t *pte;
-
-	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap);
+	for (unsigned long addr = start; addr < end; addr += PAGE_SIZE) {
+		pgd = vmemmap_pgd_populate(addr, node);
+		if (!pgd)
+			return -ENOMEM;
+		p4d = vmemmap_p4d_populate(pgd, addr, node);
+		if (!p4d)
+			return -ENOMEM;
+		pud = vmemmap_pud_populate(p4d, addr, node);
+		if (!pud)
+			return -ENOMEM;
+		pmd = vmemmap_pmd_populate(pud, addr, node);
+		if (!pmd)
+			return -ENOMEM;
+		pte = vmemmap_pte_populate(pmd, addr, node, altmap);
 		if (!pte)
 			return -ENOMEM;
+		vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 	}
 
 	return 0;
 }
 
-int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap)
-{
-	return vmemmap_populate_range(start, end, node, altmap);
-}
-
 /*
  * Write protect the mirrored tail page structs for HVO. This will be
  * called from the hugetlb code when gathering and initializing the
-- 
2.54.0


