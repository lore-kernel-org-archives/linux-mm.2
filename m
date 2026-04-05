Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D23EEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27CD6B00AA; Sun,  5 Apr 2026 08:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFFCA6B00AC; Sun,  5 Apr 2026 08:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16066B00AD; Sun,  5 Apr 2026 08:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9259A6B00AA
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:54:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5601813BFA9
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:51 +0000 (UTC)
X-FDA: 84624496782.12.E304A1B
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 76231180004
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=h52CVtc3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HEw5DKlzSRjrYp6HmZ+C9u13Pw0NEEG+M3MgilG+TeA=;
	b=QkxA5VkdsVyVAoFgyxVul2CKFvDZ1He08dlV99YLBryqoZDAv1aDvYBQ+tZzg5vIBI4Qu9
	HyjMFhAojJEV/7Ihpf3glsiwZHGXk3oi4xKCcjP38TCcmPfvAVyXn8CbtZ4HfpJmpZpa0n
	tjjRhDmfvz/NPRUokUMSIMcnGLrmkUI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393689; a=rsa-sha256;
	cv=none;
	b=z2ycpCMoix18e67wiOw3+JBihLIbWK8mxgZEoNCKVf0odaLTMtOjRgnHL+8k7zLpkOmvwb
	l7sU3NROOZOBKtFPxwOLYlzo4JAyv94/MjcbIFzk44FRnJx6tMWeZ1NEwIRWSF0QkknXIb
	/XwgNwRxr5OeeKcQgfigQaPoYDKMeIw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=h52CVtc3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-358e3cc5e7eso1522235a91.0
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393688; x=1775998488; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HEw5DKlzSRjrYp6HmZ+C9u13Pw0NEEG+M3MgilG+TeA=;
        b=h52CVtc32XrKvyAtJpgwz4LStxRXFYEUGBmVBo0rBA4DoJAcUMxVHV+n2VrtWAQGaF
         bs8e9Pbc/RQ/dZarviFy++jY5wEuGf2UcJNB/xE8UvYT/cL5H4ZwMPNRDSqET/N/D/dV
         b9If42HH3HHZ0tYsYI3wt6P9thi6ZBTTee/Aujq4zInqjsu2y4QaQYGJGFd117nHaF0k
         m2HBL2Oi6X2MjM30DkE2/CR4TN/jqDuNGwc1LcO08GS4Fgf4PBGbNT4vHsHfyCKgyeui
         yc4jnPo9pEAUHOuew+baQqptIaTgipOYkpi+j/W8JIHhBddzPifSfilncsO36ChuwFTB
         SBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393688; x=1775998488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HEw5DKlzSRjrYp6HmZ+C9u13Pw0NEEG+M3MgilG+TeA=;
        b=S4UbZYU3dG9lQzGVhZ3oezvM1zAIvNG6JlxOKqBfklbyVBZs13k3zctKhW6JehRyR9
         mqSJXMmCJY0a4vJRdaM5k9ZHonLqlzvjplw+xkDWVxWy9Y09uhqyP3Q29G69YMJT8yVV
         /APOkPC3mGbD46Qc2NPzkNuDLLn7QA6GXrq7VNwQr6oj6PyJtIoeINOHvgPocFFA/aCf
         Q4Ti9ChMTytI4CM75e1LBDaehUbR8sod2SvPywNq7TWUZiUL9BrVrrhv9Gqoiqh/tA1E
         Rq40qHPziUilwUy3FtTfyQJk9V+D2moY+EFKEmuRztQEf80bnQTh+bc6mjfxkWnkc4K8
         UC2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWd8mnObLBukDNM8Sj0mulT84j47tWgVcxZEzrRya0QzHGV3kVkrdlLxUj0ewDPqVqULm2XU1SMUA==@kvack.org
X-Gm-Message-State: AOJu0Yxa5WP51zyZFpr66NkS/t7WbMbCvP9fVWGLgd0JtOiceoQdK7qK
	EyX4cpH+UhzZL+QMBkFEWiclqybFQyiCW4+39OYLB8d+M1qRq0MHgdsic6HaftsIDgc=
X-Gm-Gg: AeBDievlLpvzAeeDIHzGWfUaITAlLx3PAl2fhXHrbUb0SNr+VZHBrMyleL8t9kfhe8D
	sOXv4Fv1Fu8R3aWlJ1XUFB8TBSdOuJnnLa/XsRLt4ykhXVSeDTEFxrmNfSHEd9t8Ih/tQpODGC1
	v8ti6RTTMSNFaWmeXgfpZ/xOPqQ+oG4fcjtW94Mu62QobBg0DoN4vpHzum0486f13tqJfFwmMJx
	a/BskX1imkm+z34l9UZ5svfB0Nec+HohEHW33vHZsz5Jm9fX/gKaEmCa86qfWs6cIVig8NccH8w
	IJS/cXnnLS1EmGkHOIiCSPleQVvKtUe1oBtST2rDEl4t8F7AVzuxnrUcKy/jmTlzJn2XarWThyR
	k4yyWtRPJD6/YvCek+Xyd0KAxRrFd8OVarE2EA3qceVtZ+64HeqXSucxP+K4ArbTOrHo0ZD+y01
	O2WnHcWPu+I8/zywgMEjRp3YthP9zImnHeXTIdwo3k3Qo=
X-Received: by 2002:a17:90b:4cca:b0:35c:29ba:bf92 with SMTP id 98e67ed59e1d1-35de6811cedmr8847254a91.5.1775393688240;
        Sun, 05 Apr 2026 05:54:48 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:54:47 -0700 (PDT)
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
Subject: [PATCH 13/49] mm: integrate sparse_vmemmap_init_nid_late() into sparse_init_nid()
Date: Sun,  5 Apr 2026 20:52:04 +0800
Message-Id: <20260405125240.2558577-14-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 76231180004
X-Stat-Signature: pardoq5pd68m7i3ccfzpbab196z5jnth
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775393689-885795
X-HE-Meta: U2FsdGVkX1+ewnz5rZYdFoJfK4Q3vzeBTXlC+l5Huniqx2zt85iVsLiLg0lTiU8mNE1tYJnBzBaE9qpPT1Fdp7073TTEdtebCSvpuoMTSD1MFxILpEgQhShMRB+fSEJaIOdLwBhPZf3DIM1MnLMpOFy1MYDCoyZ+6g1pWgWu/wO/IRHRaoWeeAGg23QCvCn8Ve3ImwP9+mPfpJbZLzJISfjyfTZeUtJLu40U/yUgMxacOreGqzm2nRt/yyB3IA5hVWf9y2EHqvG4EZiCCh/87um5JmumC40ppZTsuB8ZIyX1DnFHyUrI2zSsLUn7KQAGqeZMRnSqXKRongM3ZFMLTD07z5mOb+51Ceg41YXUBbYKD0UcTfsHACX0h7HTxHFBt3oSPnKsKwcJ/q58KDgZ/LpiBa1j0BMVU15Etwty800+z6TKkYKrZqZlXYfqVd0fsomF/NICkzYr5uvQUnC/VHajtKYkuKfwUxGMhzD8trbf6qoqIQ/TEzXNZVmaV6mpBCtKk2DiljNNYEMbuXamdh7sEVRaDZD+lMIiDXIB0q+H332dW0/CUXSvw31nf09gVWRwXJj041uoZEOyE3qwTuxmTTsV36j+F1PLIwrUsqKprly+TDOPzlCHeUr00jMhty9oK8ov82g+U28b21Jz6v1ub0ibcEcQPNwXFEeoDkamsaGj2VYepragok4L5Wb5vfRSQ8ROo0wRjxLEdramhcAEpmIDv6VQ3vOOCzYmbLiI38ry1jJk6zpCvJV/ND6vudkhCzRVxDdqvfQi9nUv5qHrBcKsw6zK3ttxhojDAHqCkJ07w/Kc+fyu3UPNw/6/mSDn0NpZuV32GplLksfkKg8Rq2HlCWUFrPW7s93YzbiaKrRHBm01n6wgs7T6zPbJMHRPGiSnKgm2ce+6E2Mq4yKYBTMJp2CicCu+GQBm5+rUPVyHFyMPZT2MhEtNedU0DjLYl8LucCpFE4OD6Nb
 Gn9cFnfw
 xFd2cFp7XfC63scLMW3K0Jl8VjVmeuDOEQutd5Nkb2OC3cwyw0h7/WSjwCpXmfW/AUCwrK7M7i7xsyru0w9NIiZcmxXKw2fmKGmAVWeJ8hH27rJ/SyBXDh8vBTHsWfZM3/u9/wN+rVFRfR6IJza4ZJRIXRhSzN7ibUvzpWkb4oOrumrdtLVcuDPimCneAffoWOVrvoUlTyCsHK27iBw0svp1DzvOpgprkWpZZ4s729m9z/QKlsCgPtqjSRG8hC9r9a7sQ/ba3clxByW+/36EZ8ohayzmdwIFPNO7idsSm2OhY00yUzboNuvpO2hYlHGjopEE3qlRmZ1kmW8vKB1tCcChYcM1fechgC3CEB2S8R8l52TM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the call to sparse_vmemmap_init_nid_late() from mm_core_init_early()
into sparse_init_nid().

Since sparse_init() has been deferred until after zone initialization,
the zone data structures are now available during sparse_init(). This
satisfies the requirements of sparse_vmemmap_init_nid_late(), allowing
it to be moved safely.

This change unifies the vmemmap initialization steps by placing both
sparse_vmemmap_init_nid_early() and sparse_vmemmap_init_nid_late()
within the sparse memory initialization logic, making the code structure
clearer.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 4 ----
 mm/sparse.c  | 2 ++
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 64363f35ad0d..7a710fcbe3c8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2664,15 +2664,11 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
-	int nid;
-
 	free_area_init();
 	/* Zone data structures are available from here. */
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 	sparse_init();
-	for_each_node_state(nid, N_MEMORY)
-		sparse_vmemmap_init_nid_late(nid);
 	memmap_init();
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 5fe0a7e66775..d940b973df66 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -383,6 +383,8 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 	}
 	sparse_usage_fini();
 	sparse_buffer_fini();
+
+	sparse_vmemmap_init_nid_late(nid);
 }
 
 /*
-- 
2.20.1


