Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 361EAEEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1736B00A6; Sun,  5 Apr 2026 08:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979026B00A8; Sun,  5 Apr 2026 08:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F546B00A9; Sun,  5 Apr 2026 08:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5AE6B00A6
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:54:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D082C3348
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:38 +0000 (UTC)
X-FDA: 84624496236.07.E0059D2
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 50EE62000C
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Wr7yOEUw;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuz46CNuL6O0+N77LBKvrgQNIe8WIqaWxa3OjXOrUz0=;
	b=ORC5GepFBRUJ5rXITwy1aBkPH9pwLm9ZWvSfs0SFdEqmT1Q4nRSrQ+gDnv7MIyXv51Uwrf
	h5fQVOHtUIxhYF/QX40NOac5kQSY0mvDlFQOAOpFxf1ZP0KP8B278AH8++yEy71JyImTSQ
	BNkDZT++QBnDvREyV8vtwDOiSTRIduI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393676; a=rsa-sha256;
	cv=none;
	b=fdwuQt7hvXK0LfqVUB4Slhr62D8cfmZ5FjYPH9A2SYJIy/7etwC2ox9dzujYmMgYzNf/6/
	neRlmZiABlYdFNkC9WuiDgBW9g8r/ASAPeHlwj4k3ATbWpDVnR8nUbBqzMOBSGaj4lz1NJ
	d6ud5zVLjaCY7Wsp+UbKEKhw4FSLHjA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Wr7yOEUw;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35c238f1063so1899010a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393675; x=1775998475; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kuz46CNuL6O0+N77LBKvrgQNIe8WIqaWxa3OjXOrUz0=;
        b=Wr7yOEUwGqJ1aspzpjkyMO6Xb9tTnXmHosOYo2xg7GPGzv+RhVod22jOMZ9TfzTxpD
         3PBUFbGie5RJqbL2nU5dS1/lmJIgZAi0AhjPi/nUlZUvv066QPwtUhW5E40b9LbebqtV
         FlCN9J/7o4wbNZnhsI28oSF2IlYd/Dgwlq4O1tQNot5tqMV+NQQiRFSsIGBlr1bKA+YF
         FdgqKfx3fY8lJmLY+dyWZ91kgyvf3c+KOxOZHKHQCdx5gY5HpYFnA1TJd3EXeQt8mW4M
         8BKkp4O3TDhCe07YPxZNaNoBjx/rvTAQArMB8WShGgUW3oWBKJKaj20k8ZD1u3gGitIt
         Xiuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393675; x=1775998475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kuz46CNuL6O0+N77LBKvrgQNIe8WIqaWxa3OjXOrUz0=;
        b=qqS4mQ2/QFXJVVrA+w5OtlHXGRXHGQmH4Drl8e2fm4yeFgGDK3fgRIeljkFF8w2GGg
         A6417o8e72ULJJ7HrGpKxE+CLVsEEhCNOFuMj3Z3KUkVZIvtKuZqVhonQevMojRt5wrx
         ZsTHWR5PNDQg3s1EHQvvndyW4yuGfXkmn7rsXoEFWXk3+G5SNseLxFPaZT+CeeNvXVtx
         WOu2lCL9c4u/RlQ6J9XXuojvcYV38aoroHDJ2erq9EDLLBkf1ILHEUrE6W0z8EuJMiHN
         R/BiWgcha8zkribnWm47O5roig2dGeNavYv/XQ5gGKslz73Nb1eUox4Lydthaaiz75Yf
         +glQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYs/1TV6TNxJ7SsY66inKIoVZl+ECRg+yk9vTOYkB5iYKVKsmLaYUWIz9+u7pK0aHzG3VIyy+xeQ==@kvack.org
X-Gm-Message-State: AOJu0YwWqxSfVxHQvcz9r/P/vPysSDTqzUhp498mbgpjUCyU8BCTwYO0
	6naQuoVZyLDEo97iDsoFS+n94tzSPXZ90HEbUu8WNiHpiDrZVoVzOz8mogyeQQbucPw=
X-Gm-Gg: AeBDiesl1ftQAQfk0lH51zkX7hh0RpheDqsB0NwYUjt6codeUvIJ25F9ZlUCFEM5EEX
	lrOivznrgYrnlemfIpY7OI1AF+E3RAxL930zk8TxB3dWoPbT4KlAfQnw+PHiZMCTHwRZNBSULMu
	RBmP4toJacYikUl0O3kEe8UjEbQLphG3x6Yxyo83YJCCgg2SK/NZDPune947+IzhuDeHHsCJ4e9
	YLJo/upxivJvinu03zAJGBbA7Z9T6vyPnIjXTUn/S5zEx0aMoo7Hwg/TNZJ/HLIwXpJ0Ipe6xH1
	lEnf90XttQzHTW7UnoP45a0QCK1yxg11eZaOFgAyC82JmmTJZPrAnq/GUmXdBPkPGq79Oc/XosF
	A3t4WJfaG0/263T0wuiipSX3MTbSxD8fTdDcDBxgOZLJB+RIPkjyWL20cI9QyBeB6SmKWYZ1Mcr
	SC0OkI+3FSLHoWFoEKPL15Xogt75DnN+KLEdwpnxhkzZk=
X-Received: by 2002:a17:90b:48d0:b0:35c:a8f:5c5f with SMTP id 98e67ed59e1d1-35de68655bdmr8575177a91.8.1775393675104;
        Sun, 05 Apr 2026 05:54:35 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:54:34 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 11/49] mm: defer sparse_init() until after zone initialization
Date: Sun,  5 Apr 2026 20:52:02 +0800
Message-Id: <20260405125240.2558577-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ac67hts8z5phtzazwe5htzjmddwh3ped
X-Rspamd-Queue-Id: 50EE62000C
X-Rspam-User: 
X-HE-Tag: 1775393676-658896
X-HE-Meta: U2FsdGVkX19UCN+gzkhrNjw9kH2TLV6P3UZyMNPKUAO6VGk6eSsO13hegi+qbnkcebZgb5aNlVAJjEABu2lOe3VdCJ7EKYFFWTOQTg2mGEkivXJrtqokS1GQtaBr24rnyoDlv3dJ8KPDj2hgjqbZiEEkMDsHNiu6KhJxD9sWUhShL56YZ7fCiJa8QE5NiXHTT5qtbGRALmAtNmL7D7I04WQnbNmXRcr0rzqwKQ+Li4oxLwgTfQD3rDqJGcfUb0efZ7KJbnUfexvVELETHLOtwt/jxV+bmrbjEAXUkMP0ZdrkferunIzIop/WLmBdx5YZI40yLVvaJg28Z3vt6m6DY9aGlnkiahb/+3wXoU0tf4nXQ0UTEA0HS7ZX5QzaGpCwPIj/eGTV/Py8Foc2XV+njp8GMQsR/7H4IPx2YKrbYffFAAFRkkU0EDlK4e7uT5cJE2bOBmU54z8yF2yTM2iKpBgLIF7emKIiLZpfTVikaYLQcEHSv3z+Z8bvnsjDoRTzfmAZgzavvBjANqFul2By568bXkKP0A8SYUneLhXGU5TZnrKbdlm2LqH/jjw4bvCBHoQd7Q9OxYWrSkX2vkqAm8u2yhQ4J0Qld2UD1t1aYHvl+ZGsIK53p1CVwdi/YU7FevQZLpep2yZm6CKnXzgZzvrAAqRtKD4+8PTs8jqD1VFmDeFKbZurNQ78FxNcqI+okhfHKB2Ddm83fpvEUUCGu1fG2SfxrEx/2zBvxRvZ1ICqZ97NROZEmYOTSYbGSvIPcl3MY6yqUYgNgetzAZRdpgl2KvTvos0SG+tcxDJF4Xf/iMU3hGfSOlXMCgo+3EZj+y+AxJQSbblQQFmO0KsICIV24QGKvYXc0+vY2fVBZq9YPyFpr/6lVZQL+0QW6SEQX+k2nlKMdbpfZXrOq/0dpjePaDa6/Il7GIEFNNw7Pns/n5f8fiz7L6umKGTTsmrmT8qWILrGUo8aMyIYhnq
 EVrPagjw
 0UaV0IqFtgX0nMu+G04Y8BVatRREQ7zcRser9nbCI4LHe7Alhh8EmTwJ9p23gZ1O+1p4ZUMz+HOrYNUvL2xN34ujPb4l6ZKhlRFXz4eV4cNC1V5jobysjLlDjKZXbnovMY7O/1eb8WaUa2/4+0kbyOiB/sS25sLGZuhWM1vVBd8IXPEw7TVyC4AVzV8I6Rw+BluwBxV47mR0cPRS6xKIMJTmIZa/0eVXOxXEuV3fQSNkhCVRkPkPshl9Y0CfA57t2/AVltOP7rgnPdMKaeZZdNkrMjNPUqh7pazThpYJtDw36elIPhPB3uTJw2uX9PAdibSQefF/mqoU1Jt0d9vXpauLMjboaR1KNGHPxTg7g/ZlHWk4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

According to the comment of free_area_init(), its main goal is to
initialise all pg_data_t and zone data. However, sparse_init() and
memmap_init() are aimed at allocating vmemmap pages and initializing
struct page respectively, which differs from the goal of free_area_init().
Therefore, it is reasonable to move them out of free_area_init().

Call sparse_init() after free_area_init() to guarantee that zone data
structures are available when sparse_init() executes. This change is a
prerequisite for integrating vmemmap initialization steps and allows
sparse_init() to safely access zone information if needed (e.g. HVO case).

Also, move hugetlb reservation functions (hugetlb_cma_reserve() and
hugetlb_bootmem_alloc()) to be after free_area_init(). This allows
hugetlb reservation to access zone information to ensure that contiguous
pages are not allocated across zone boundaries, which simplifies the
hugetlb code. So this is a preparation for subsequent changes.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 15 ++++++++-------
 mm/sparse.c  |  3 ---
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5ca4503e7622..72604d02a853 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1807,7 +1807,6 @@ static void __init free_area_init(void)
 	bool descending;
 
 	arch_zone_limits_init(max_zone_pfn);
-	sparse_init();
 
 	start_pfn = PHYS_PFN(memblock_start_of_DRAM());
 	descending = arch_has_descending_max_zone_pfns();
@@ -1896,11 +1895,7 @@ static void __init free_area_init(void)
 		}
 	}
 
-	for_each_node_state(nid, N_MEMORY)
-		sparse_vmemmap_init_nid_late(nid);
-
 	calc_nr_kernel_pages();
-	memmap_init();
 
 	/* disable hash distribution for systems with a single node */
 	fixup_hashdist();
@@ -2669,10 +2664,16 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
-	hugetlb_cma_reserve();
-	hugetlb_bootmem_alloc();
+	int nid;
 
 	free_area_init();
+	/* Zone data structures are available from here. */
+	hugetlb_cma_reserve();
+	hugetlb_bootmem_alloc();
+	sparse_init();
+	for_each_node_state(nid, N_MEMORY)
+		sparse_vmemmap_init_nid_late(nid);
+	memmap_init();
 }
 
 /*
diff --git a/mm/sparse.c b/mm/sparse.c
index c7f91dc2e5b5..5fe0a7e66775 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -406,9 +406,6 @@ void __init sparse_init(void)
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
-	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
-	set_pageblock_order();
-
 	for_each_present_section_nr(pnum_begin + 1, pnum_end) {
 		int nid = sparse_early_nid(__nr_to_section(pnum_end));
 
-- 
2.20.1


