Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA39ECD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B39C6B00C6; Tue,  2 Jun 2026 06:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163846B00C9; Tue,  2 Jun 2026 06:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C0A6B00CA; Tue,  2 Jun 2026 06:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0F4F6B00C6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:11:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1B88A089F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:42 +0000 (UTC)
X-FDA: 84834556044.05.CC9A235
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id D38C51C0002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZrG1Njzq;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxbi5h4Z+JKwQ2t0bJ1zO9+zcXybTFpZA7Fr3QeLXFU=;
	b=WtDwNoE9Zh07WgHXBJ2cYa58ViIwUhQGebBD3aB8CsrK2XpECb4EXlm0Kh+FRwPUe9/ZjU
	3k7tc5a2yONfJpHeInrVcqDTmwAVacc2+idOLdrCkexjy4MOmWstehZG+meuiftEL4vexO
	lTFElxd86jZVB087ttN8De4ryNVhsWc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZrG1Njzq;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395100;
	b=vVymqO+RYBU7hnOpcTYsabauOytBIwknei+VW1fl4bVJ+R6/mnETWt6AruFTQ8kcT8VdD8
	mMv27XfwLmgXcVFY6tt+0j1VtKmmu0gjU5Ek9AEaenM1auXKfKRIAFLIXs2Uo4YP4ibEJy
	DrPz6QMfiHVPWLq5LILR+hx5gMuoyZY=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8419ab3a297so3539994b3a.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395100; x=1780999900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sxbi5h4Z+JKwQ2t0bJ1zO9+zcXybTFpZA7Fr3QeLXFU=;
        b=ZrG1Njzqcicmm7nZskhaHkL9TkxT1pFKq5ltO9Q6WQNAbCB6xhPfipO9+Yz4OITrCJ
         etU5vQUhzJtrueJcDTaWc23I1Hn8ikQ7YscnlRG7yb4tRCvo6JVW3+gmXEWAIl7bsCa7
         B2aSi2VC8PoEFSEizWLM039ELr5O9BfBY1LjjyuLugZnPcizWrBWdwPOTp92EheIKgxh
         2XvbWfo2wLXaKLMnlnHtuHr64bmIPaCaO2r7SZDTTz+qifwUQxR+Ec7aOZ0M/g/Hx/ve
         PCSuVJQ75nleWKNtfT79nArEgCwKGjigCFnbLqgDrMPphDl21CPSYpyGL+F5FgR+l37D
         onHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395100; x=1780999900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sxbi5h4Z+JKwQ2t0bJ1zO9+zcXybTFpZA7Fr3QeLXFU=;
        b=pPM32jHNhw5vRUQU36Vm7QDXOVXYMM7s7nykKcaQnVgR1OYkr78Bzn4VkuiO4OsfaJ
         XqWJmGQqvtLorUd1/0opUoC0Fp75OvsMdFuyHeUP1DfznLxD+20thTROQr0O5g/6uTON
         QJDtIBXCdxk7eCX/I6TXPxTf55A63/XrYKvJsju0Ye6wJEuFulnKylefytNwBQMC+x+L
         q4/+13QH7EzbywNqC2zddM7NqUOn2nlQfcDxgXKc38O11qcKQm1heQwcsuVXwpI2IxU3
         4G1lgJLZwQ9Cc1/JKJYg2LKKjBHVV13xV1mNei1SDPmtIapsHqlM7+pY7d+M++WJQmqM
         BY0g==
X-Forwarded-Encrypted: i=1; AFNElJ//sBWOUOMj4081BlsD5l0Zea/DXomyzBLGodZjPWON8Y/OobU5cPLkeN06jrnvW+gjCYqT74S5KA==@kvack.org
X-Gm-Message-State: AOJu0Yz0PEifh+eENgaCKCptQXW+lqM8f8iN+ATIgvfyW+QZAFVSu9Pu
	L100xBNLC9sIxOZfm3WE/kyVDlSJLDbi3lJeVq9L+soqNRBKQ9zJ1uxSn2L/FPedPdU=
X-Gm-Gg: Acq92OGfvnQOjlzmB7zipVHst0i88gUuyi2g5kSLeZU0syqobx9Hfi83ZCt5RLClXPk
	vXj2pbLa5Ma0+4W8rkIGNkixiCnSTnZKOkvmb6vLCr4RhIlRwd0HtNn4xFalZ78A4w/i/5LXXlm
	DJLmcfUKokSJ0gyysWqfSjpASJjuEEzI6tKP2TsvwxT5LOHe9KZa6umTAk7Uwv3LI8IQype/iCs
	sAWMXE67wcX1Szm8mlHWt+PAeGFQc8Q23jMycdSh0elGTkBfDK3KyxdsstzesLvHITvRpELAUSX
	yLX5cllRpkbgMFE+vfYCVtnjFWpqecFf4Qesz7IjaISbj7m/0CTNS/s45Z/uLxxCpwpd4fP3o6w
	LNSyAYQId3oKXLXSDefEiecCHdzMx4zZi0QE8c47rqGB4LRpzOOz7qnugtDappN/NG6ZtngEYx0
	kukfy7DuIE6yLzFAV6jGgpmWnF99nhHlLhjBOmH04G+fPhlJLvmNhXxUI=
X-Received: by 2002:a05:6a00:1741:b0:842:6004:3fb9 with SMTP id d2e1a72fcca58-84260044470mr5719945b3a.25.1780395099558;
        Tue, 02 Jun 2026 03:11:39 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:11:39 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>
Subject: [PATCH v3 09/19] mm/mm_init: Defer hugetlb reservation until after zone initialization
Date: Tue,  2 Jun 2026 18:10:29 +0800
Message-ID: <20260602101039.1867613-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D38C51C0002
X-Rspam-User: 
X-Stat-Signature: 99m8x8r3aezewysr5izeyfuy5fk8d1a9
X-Rspamd-Server: rspam09
X-HE-Tag: 1780395100-659611
X-HE-Meta: U2FsdGVkX18/3GeONxtPrN4B7nHRn3kZGrV0sdOpWMSwIkfVM+4bv40ZViLG0vfYKmmd6DBAiId8WG1+k+fwccqUSoA2YKBk3rl20iiLw/bNlEs9wWxPjmWTe9NC4zn2g+WQR+nrYDXupaX8LisdxNs6nMesU2m28cvLFyBXBNfDHaMTMf6odboDiL1ewyt6nyv36byzBwpAiS5r3OFRnbBc/YH/FeDLbtsXESoLvzqxZlph+Z5/ccFdFpCep1Qjl6kCvYVSgLZbUXg9sr19PwD9uYe4Z2M3X5K5LgZYbXsz40FjTpUX8o43lVya8OSLmVheas46aHi4X5LdInk2VQMgc7pDdM71iJ4t/r6N787bcjfwGjaeohD/i2xlyBM/FcsHPwq+t5k8xtk/4BD9KrP97sigft3biJa83YqhS6m3dx55oL8RXMgDaUl4IuhbdyqAmD8SR/YrA5nfFp4LbrY2tU0wv39ZbbXpQpOEmUyny0bHs62o5u0kTxU8QDsZo/RbGxZaNxS3ZH17dwCpAenLgsQEYlCAwZK699pOI5u7xCLdmwg6NXRYMm4De0WwczQxio/fuPnhkTRjbXFeI0vUpP4RmIGTzkh2YkzIeEHCtI6GSTVfX+8JeqgnFTDAf1A/sbiyC9bgRLL1ihMNpitlj3CgVp1Njpkwbf1NVqCdhIFQQSZhtj305qPm/iW7cay35QfwrtmxRPRuu5YAFc7+ybdecxWYVpjSOMPqTgLOI/6PBxAPnuYoepFqZM/Yxz4nNAarCoboxv0AIyCPXtypBNYkAg5zF0AhqFJQc328kZDtnZimQpBxO5zGBI08EBbATJxFMBUKQlrPMWJeI+MX9m42DEbH4jxC7YKd7EYg23mEY0QdtFRAefz7nrf5tx3kGAwu8V9uKOh5k6rIV4Qtv/h2jedA4RFn0/41bteYigpRJDNF6Fi8cXUIsc1uuSqMa+kaKq5oMC8RBUW
 oHhbRgC2
 qKMoO7UgQEGIRZDJrGQWh0Brc1KnOZbl1p0UeSCZYdKMPGrqyMRYfd/7sph5ydQJ0wb3nHMEH6GRp4QcYkcBwTe1N9ilfKzvzgFI7nIlVWIDx46DQPd6o9nDDl5iPg5ms3dEeZnN/QjpdtdiIOTE6s05xHf17RVDSN2eNvhUfFaxUAWLkyH8bKr3mJQIR8Fp5SupuAn38znfYUWydy/ZwTU0o6mCPXAVAHeBe+RTxjVIX0lsPAhdx1k1/JZlkUs/qV3Y8uhvW4DZeq9sbfSrgk4dnGRVGQ6QjujUUr2ZkWtD8Q0xVf7VaPSkp3DDleU4dkG0y/ddAEw98qbk/1yr9+k3rzw/UCou76aH8XDZCnfIhkXqd6s6tDNmYoLyltXF4ntQkKCC4aY940PJCChl1Qp3l0b2vCxZyRaZKbvNvD5g72tbp8QLUTjW7hwvkZfU0uKBdXAudzPqfLSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_cma_reserve() and hugetlb_bootmem_alloc() currently run before
free_area_init(), so HugeTLB reservation happens before zone state is
initialized.

Move the reservation step after free_area_init() so the relevant zone
information is available before HugeTLB reserves memory. This is needed
for later hugetlb changes that validate boot-time HugeTLB reservations
against zone boundaries.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
---
v2->v3:
- collect Reviewed-by from Mike Rapoport
- collect Reviewed-by from Oscar Salvador
---
 mm/mm_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f349a6f34139..4601e5d659eb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2691,11 +2691,11 @@ void __init mm_core_init_early(void)
 {
 	int nid;
 
+	free_area_init();
+
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
-	free_area_init();
-
 	sparse_init();
 	for_each_node_state(nid, N_MEMORY)
 		sparse_vmemmap_init_nid_late(nid);
-- 
2.54.0


