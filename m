Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 537A0CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 05:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6C58E001C; Tue, 30 Sep 2025 01:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE118E0002; Tue, 30 Sep 2025 01:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4158E001C; Tue, 30 Sep 2025 01:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9FE8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:59:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 304BB8795B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:59:29 +0000 (UTC)
X-FDA: 83944864458.11.AD81B03
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 557741C000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:59:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QyT3Gw4C;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759211967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bj30sQDVRkZpxPh0yEwciSjpXqkKKqMqk3AWrRPDElU=;
	b=aEsVVfhkwC5H6QdqcmONhLVhLaLuNzryKbvAIK68/DqBdZpYHBRX2bbzbPUcuCQMyrZwsY
	MvrbQBeZ3SvrwwK4WlxMjZbGr34hq5OGCK267Wvc4xVoQcN5LCJgxjtGbbd3r93tLOGo9u
	J+psc6DVridMo7W/SFozjig6i861ynA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QyT3Gw4C;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759211967; a=rsa-sha256;
	cv=none;
	b=MVPPm1cLpQv5G/uNiY/GpfIoh8CmRfVNZzZ5xCLOl908KUZom905dbV/swXEmrH2GW97Dv
	H/9lcDCivWH6I1aUZcZPILCGih1cMUZqm9tpFWB9eXwjzGDjiRxHgTRPD9jj1nIjK8AUTU
	QXxOaz06FWh5vldau8FdoJ/Do7WpvYM=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2681660d604so52257005ad.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759211966; x=1759816766; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bj30sQDVRkZpxPh0yEwciSjpXqkKKqMqk3AWrRPDElU=;
        b=QyT3Gw4C5133tYO0KuRD7xm7vbBrnM2z5eqJFWzEwQAUnb88edL6aNTmdUdULOwbTL
         812gjE6VsUtC5s5OVFuEMW7SZNVSL0NndB3wOxNGj6IW+GfrtwJHCu7PHBeHEYFfZnSJ
         vsy37Iu9TDvG4NmRBADYrcpIYjbLT1fGV+mkGEDQD3WLOhuzvnxH5YfnFwPBhiXww2mW
         Mv7IBTZ6ElNZMhZKMBC4EaDcwWhOH9FeGITZwLYbgb+EfpL21ppUGD6rowcD3jhGg24l
         49qKlGN6k3WMUXKoheTqhCIhPFkWDaCkWJ7bapap3yVom7g7xtvPZ/onZbgp4kdXKX5r
         luVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759211966; x=1759816766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bj30sQDVRkZpxPh0yEwciSjpXqkKKqMqk3AWrRPDElU=;
        b=azQBKgC5zj4xamX/FkgAZGWdjqRAvgU7Hpz6GRe3ntPFKjzVOUg0GqnF1yk14fZ5aR
         WBTZ5p2Rnqw/GOS87kfkVfzwyaIFSuUMPZQwIaAGmfpMDBPQ8FhgsqJ0uhJVRp0AjWeO
         fUgn9YCaOArUIRYqcjl4ihGdypTZJHRVxiisof3lfzr/VVYYEKkQOMBXiNYzEs4q4ADl
         PFXQjBapPtW9AXF6rXMbfouJvbOMWxN9UJfkqBCLZ/ocwovBqJZl9OiGeIBrM49Z3gIr
         l+wfxqdD2VASzMYrR7nW/OrjouwT1pdckdhQMBjLoIJGgi/H2ppXxitiVZfceOJ3M2gR
         jnzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDEmKPUGWki6XrvNStqm8g3XF3qQmusWzXuE3NRCidJ46eUEZ5aLM5FWL4X6bjoatht/lcrQwOHA==@kvack.org
X-Gm-Message-State: AOJu0YyMbeOgubiGzYdM7N1UHiIcjJalHoPfKE4ToUo7grTQ2iusTg0H
	M+mpG57jJUqob7HE8BDm0mpT+UAE6hYw3VOwXyaaZfea88Frk599ie7Y
X-Gm-Gg: ASbGnctY/dBOJJkzAP4meXzr5szJRHQRRfO2kZUU5ixFQpkYsx9ZNmYfmAk9WkSkLet
	N1uu/aBcOhKxal+a5a6I+Won9u0gQxwsn+NuyWUrNMDqkSrZ1K43h0NDjsGPZz90x6m80B4qpSZ
	QhuS/7CtjieRNtB6yFUrorAZycqdd1j9yZRIIHcsWeFI4cpufJrDoVnpxta4DnrXGLHw3Z3zDcX
	rl7TofBRQjn22lJ5i7tXQW5EfO3v+0xm0l9qx+Tm57kttYP1mP+Inw0F+kNJHQbVO8c8EB58+VX
	GwPFk/Ay2Z96uhSLAtwg2gfMw9X0M7nne+MDbPU+rjxgDMg27kCfmPaqqVB+LssSbViv9A7XWjQ
	8q7bVbsTiP3V5C+Bn90JvNTaAQ1eo1BSb6BQ3Ak1KrbmdyaxArayMnuEkWVt+4SJ3RCXtroriA2
	nh8oVNE/yTQf38aSlIx1OhT7w8oalVetLcgymWrw==
X-Google-Smtp-Source: AGHT+IEmo2u/7V63Fa+4aKjEO7zXO6V10zopA5XEUoYxrgliFdmiMUfOOebvAfkXMDqtGOOwYbddwQ==
X-Received: by 2002:a17:902:fc86:b0:269:8407:5ae3 with SMTP id d9443c01a7336-27ed4a60923mr250920865ad.54.1759211966029;
        Mon, 29 Sep 2025 22:59:26 -0700 (PDT)
Received: from localhost.localdomain ([61.171.228.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43b8sm148834065ad.9.2025.09.29.22.59.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 22:59:25 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v9 mm-new 04/11] mm: thp: decouple THP allocation between swap and page fault paths
Date: Tue, 30 Sep 2025 13:58:19 +0800
Message-Id: <20250930055826.9810-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250930055826.9810-1-laoar.shao@gmail.com>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 557741C000A
X-Stat-Signature: ytgzx3tytmdef3u9wt4z454bb5bwojxo
X-HE-Tag: 1759211967-42960
X-HE-Meta: U2FsdGVkX18eTiZSVK6gZEf56xTl8KuOXpd6laLqfvsN0XgWX15SusoFYbL0PvZfHSpm52nFMOThk68kxbCubXaxKNCMyCRzrAyCRiFlklbkyCccCv+ff4Oz6XcxNOlYOE+oPIg0aq5FQmW9RDnS6rL8FhR+7s3JZ5+0Gdb33rEH8R39XVZe0/bSh5Qwm74J+EisjySsz20CPYTOXirEHM6t2olX9s4xshdZAA5ryNYXByjyTJh+08zyU4vfzRI7h9/I551PNA2IF/7eXaEnZAR93rlGbz2I6q4vZdcjZS+Y7lu7iUKw0KKyJCTqqGhz/9ULbanyCrfj+z47Pmja3cutQM8bEsTgEg1KUCtopZQTdbKAEbqeYT0/aFks1jmfLcRKENCOCDjxsYMQtQvGii2zp1Acrj0JoB8WybDFtOMf1rjUAUhRDX8R0BJimbuAls1PnVGWxsSsbnNL1EEuwMZsVTeKYfdmqrAIbwc6Dk6o2rscG17ZYyYqmeueFCrFp1+/8ocqy8KVGwj3Tw8q76FrfYJzJpd8fu5ZkjjVwoZuixlast4OrWXrDrLqmYuztJuedXlVAZOCQfa+rGROSLq1nVn0yzoYRjE+1mdgd85K3erwmODQcCj1QYOhVYchzjYOfcUEV4qnn8GzznkMX4KiueXdZLlF8Mp0OPqYyVXUDmKodn7hTqa4ucKH1gZC4Akf5WgJLP7xYnN+NcoREo8bKBL4xVon3OW+FdDrUWLnQxM18i0xgOAl15DlPOA+MS6wQupMYUsnFH4XbYRm+aOHXDUO6Q6H5HLTAnPqhKSRW93CodGOysHhU+yRgJ7BbY4oGDJMT/+QyDv8SByF9qJyEk5q1rHmG6Qojenwr0g6NtvXOHSkNr0mGL0dhqQeBEnN7DbFKKVeGHZAZV4juWNi3tUrS4HRMVXYo1hF51ufLHjcl1+8ZXaCi9mj7wpyPhOog+QtdUBHmjY47Px
 DktTBMZB
 3oTltdfw+NZIOkio/KWw3T2BD0qqG3EYxwGLHhU928BY9GvS/n4VS74NCzPVZEpX2aqZr4NMGw7GxLKtVR43vnwEg4IVlRr2AAS3MC5VK/NeC9VLHxoSFQMi6KDjR30hVfSCVebAtQpo5Npp6KPMxrezscCp8QNHlEDNd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new BPF capability enables finer-grained THP policy decisions by
introducing separate handling for swap faults versus normal page faults.

As highlighted by Barry:

  We’ve observed that swapping in large folios can lead to more
  swap thrashing for some workloads- e.g. kernel build. Consequently,
  some workloads might prefer swapping in smaller folios than those
  allocated by alloc_anon_folio().

While prtcl() could potentially be extended to leverage this new policy,
doing so would require modifications to the uAPI.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>
---
 include/linux/huge_mm.h | 3 ++-
 mm/huge_memory.c        | 2 +-
 mm/memory.c             | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 02055cc93bfe..9b9dfe646daa 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -97,9 +97,10 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
 
 enum tva_type {
 	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
-	TVA_PAGEFAULT,		/* Serving a page fault. */
+	TVA_PAGEFAULT,		/* Serving a non-swap page fault. */
 	TVA_KHUGEPAGED,		/* Khugepaged collapse. */
 	TVA_FORCED_COLLAPSE,	/* Forced collapse (e.g. MADV_COLLAPSE). */
+	TVA_SWAP_PAGEFAULT,	/* serving a swap page fault. */
 };
 
 #define thp_vma_allowable_order(vma, type, order) \
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1ac476fe6dc5..08372dfcb41a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -102,7 +102,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 unsigned long orders)
 {
 	const bool smaps = type == TVA_SMAPS;
-	const bool in_pf = type == TVA_PAGEFAULT;
+	const bool in_pf = (type == TVA_PAGEFAULT || type == TVA_SWAP_PAGEFAULT);
 	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
 	unsigned long supported_orders;
 	vm_flags_t vm_flags = vma->vm_flags;
diff --git a/mm/memory.c b/mm/memory.c
index cd04e4894725..58ea0f93f79e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4558,7 +4558,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
 	 */
-	orders = thp_vma_allowable_orders(vma, TVA_PAGEFAULT,
+	orders = thp_vma_allowable_orders(vma, TVA_SWAP_PAGEFAULT,
 					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
-- 
2.47.3


