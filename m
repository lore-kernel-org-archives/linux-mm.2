Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DEEACCD19F
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 17:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39AD98E0009; Mon, 20 Oct 2025 13:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34B3A8E0002; Mon, 20 Oct 2025 13:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23A618E0009; Mon, 20 Oct 2025 13:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EFAF8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:06:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0A25858A5
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:06:26 +0000 (UTC)
X-FDA: 84019121172.27.529FC5B
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 25FEB14000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:06:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RnwjisSU;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760979985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TFkTuuRQXlkMnnPltH8vwxRb+c44/fonOE7Lw0HeD9g=;
	b=AJsRui36fRv0xeQw64F9elmwrEc78V/TBp6kqwZZHKK9gknkSgezLiDdKKRbkqYQagMeuC
	wD3qmZ/+MBtitzR1KKtOje82HlEYXTn3VYgqXt2hNQ24UsE14MtjO36trhcDZ9r2xK9dFx
	t82iOPMgKE5nGtJjDDRPPazxLDAFCIw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760979985; a=rsa-sha256;
	cv=none;
	b=O1+HRyAo24yCMHNeoPHWc+EQX4S/aZcMHWVv+/PhRZGOfOxWYGg7rBEXVr8c9ikSqdBrvF
	XAuJKaus26I3qlR87NHo4+ESi7BQSeisr/YK8LrgjreYGiq9Mzu4cUqqd+Lfa05A3GGCRn
	x6CEjtMVM9tjY5Wvl0HtXwsOvpd8DBU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RnwjisSU;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-88ed6837e2eso1023066785a.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760979984; x=1761584784; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TFkTuuRQXlkMnnPltH8vwxRb+c44/fonOE7Lw0HeD9g=;
        b=RnwjisSUr33gg/AEUHJHLzGue5sWRuUQKxitIuAqqJ0Rc5E4OZNte3OLlLMoH04cle
         ouoXUenFsCJC+HstWbcK5tjXDmKttuUEFxV3WmHjOV1Dd+d2VuLEG+uoKczDCgVvj6zA
         qdO8fxd1XDTQKyib03rKZzpgkXl0x06murxsVh1UstO7GOHRmDgF01uw7qszlBy4Sfxs
         2Wm7h7oDWTRs7CQm43ZQxWukNjdcVtyZio+yrEQ3r/iPfQL8gYxDAfvte1z/AE6K3RLp
         1s7ZMuuRqdv+j3TzCqyXc5gvZXFKh1pG57mNYUF1fPD/1UiDSGVUxCjt7QAzO6OIMXtg
         NO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760979984; x=1761584784;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TFkTuuRQXlkMnnPltH8vwxRb+c44/fonOE7Lw0HeD9g=;
        b=DaebBFwWB1Y7Et55EvxQ7k6ACRLSgxhUDGbz73WYPQLB427bWk0nf4Zgcsev4IcgcF
         YKC5LA+akeCcPaqzYMW2/hFgupJR9z0FBEIOyh8Jx4DG4UWXPo/9QR77jyLu7JtfPwwX
         37ZJZ238XD+bqdOWm/4IkTYKtietp10jwDR3HfUPOi30lbVDQ1P4YPaCPVBUl/Hos7SY
         sslkwz2fGHPl1V4Sf+KhFo9e8PE5JB1aKhjnkBNZUNFn3YOIvyvtIvkkT5dfDk1HRKKx
         Fi9l23ZYfTM5Bb3FNpEfoGwmwDwt/ahrqkxQHh95iExIlbjksbqBcrzVEfm4hi4n8/8I
         5Utw==
X-Gm-Message-State: AOJu0Yz9xmDFTlKkBweDAaqJWaZ4WOWfCrvx6tNOkzrkPbXfasWQtV8h
	cXo/RhY1qPrpDo4W43PgUVdnlTa3pTj39/arK0xc/59YgjB6V+gZmJklLYP8kXVQQ/L4bd/OMvx
	C9HP+
X-Gm-Gg: ASbGncsUxzbZqtjQRQhyVM1HLeyeaAIJ4UTLiv8jQLfM4mlCHu8p1WHHhC7xovULgwq
	O8LFNMbuFGyKxxxE8VRWgKCa927MHrANaKHMfzI3rmeRLM1Uvg8n0l8OdWtOiESFj05frzxR7wH
	UxQHy7/exSXABglqE4B975AlLFdr7mAvfGYoL+/SeuLviEo1+ZWoKX40KKuD3hw0u11vzfLjNZr
	VOwN8yDGHelIHJDVmBIzlUfwF+FQjwyKkLxmRQXyblXyBIs/P8VTnUwoc1ZaTX1ZQEbu22tlmfj
	HkixT7a7CZNIGgK5IjsctXB6dodcOYAMhQLcErQ5ndV9b1wPTjPbdFqbhJxRa9ioh9y0w3bgLOK
	1d3ckP8flrXj6P6+HrfKXsHUeQ+r++WD1WPlP2KlS0+lRPejDxFMeILrOfRl+uwjMn9Druh4jO+
	AZQJTAIGLKWjkvwUdSvEEMSyB78eBaVeKDqMroDgCg5muptnQQ22/Qzxk3L335hsdhCRr1hkyCB
	A37aN61PcdROQ==
X-Google-Smtp-Source: AGHT+IENyRFurSh+wbWbcVaHpRj7awwAJlh3XPUSrVwGppDU+1z9lIbBic1IDJdMet9PvI80YFT/dQ==
X-Received: by 2002:a05:620a:2586:b0:85a:3d7c:3ca1 with SMTP id af79cd13be357-89070115929mr1639543685a.45.1760979983803;
        Mon, 20 Oct 2025 10:06:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-891cefba919sm593806085a.32.2025.10.20.10.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 10:06:23 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	David Hildenbrand <david@redhat.com>
Subject: [RFC PATCH] page_alloc: allow migration of smaller hugepages during contig_alloc.
Date: Mon, 20 Oct 2025 13:06:15 -0400
Message-ID: <20251020170615.1000819-1-gourry@gourry.net>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: br1o6m797fnt54yqxgobofobx9eodo6z
X-Rspam-User: 
X-Rspamd-Queue-Id: 25FEB14000E
X-HE-Tag: 1760979984-469290
X-HE-Meta: U2FsdGVkX189pQtGuknXsxrx4F51yBo9qZnxyct8VbtIo96Sq2U8aR4ipyGYwCAsK9XjkVS0Eb8wvgpEDJ42C+CGPFXipAqGG93qkgyY+f7Hz+WAjJ/lHbsCHx1nuXZ2ObdiSP48/gHNKwAGoNfyq1LC6rOy1jPHp7VIM60mIATWAM08sj6pAh5KOObjDnwWnbf1k7czAIVtq8k1OB+oVcb1L9uSYFhdA6FdsOqee7waYFSneahwgifrPxNMCNaPJI0+dsT+530McFHGcAkkk2yVD5GV1EQ7CNTfX1zBhAYk6H0WoVPaF4+nXb7MiCEojxQlB1tknTuqsAKike3e09+VPxkPxbITdXP1CWubFqXTQesDY5+UjO0nuOOKNWQxbUR3vXiFjPcV1YD5R6KwXsNuXEL9OMOLcd2uBwwIUdSKDLwVrOFs1fs9IwGjvtAI1K8d5YWiulcEh8xKblaQVIPwuViSIpm3TSnHYlcVTe6qglsTnAD0Ojo9fEIoX5Uzjnd+GWjcWoNwQ7WEltK5c1nD6nHYnuITrTi2YEP39iXKMjA92+3yoOJ8YWNoze5KMWue4P00x41mRHRRQcHNRsgcOpgdw9evZhorLTU2GdZBAVeYCgfSFhuQBkWAf6C2ykQv/C3SMHPUaGBhY8a68ZywJuHPj0QfcUfNwLwGOufk+Nht514MQXd64WAqxmR2r/aGw6g6u3AoT+O3U4uET+kfWbbDiR1P+10sZZx4ibLLgpW7ccIxTux8ekXH96D5p4FjJ5e2ktQ1vxNKkhMsTsIgfLYVDGSEsk9WQDdYrYudJafMu0eexJud5CZa37m0Z6SAuh83z2lkI0h0zfvZLfj4P8Oi/RFx1nbFDDkvnRMRZIUx1GS9h5QY11sx0l8v44eJKSoU5QCsP4wG+ihPiOSm5wHCieUkRyQ/GvXuCXA0JHhtXFPosxLmrPZgIUFzmVryR1iXplJ45f/mklm
 igk2vx/l
 a0CZg7DDh3YsaRl3a3LiXp3BXcaM8klDGoJ/aOQRmf2qsqRV6c/lTd700W7jM9DH1XR/zBKmHQphNXfKIJDQgpdjmE3yyKw510ojCuDFr1aUUvuqq/6luFUmymkjfW5buq3R1u4EqE/5DC/E1VxHCnlKegRCThsNEURz+2FDD/qQOCkmo3Gw25XgtpjkUteGaCGaqQPkKkxqMK57rSG6Y1PqqZA/UajrfX/RwLmpIQifDnF7yP8SJMNiHUj+BCr06j42qSqOqQH50d7K8abxYEAa/+cKto+BvNNmts9CpuR59uEHXRMpja6dPsQK1UwOTNKhWd+/KZhK32+MG9ZvegFBB611j780Wz7GXfVJXhe+bnljO77xe+nxP4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We presently skip regions with hugepages entirely when trying to do
contiguous page allocation.  Instead, if hugepage migration is enabled,
consider regions with hugepages smaller than the target contiguous
allocation request as valid targets for allocation.

Compaction `isolate_migrate_pages_block()` already expects requests
with hugepages to originate from alloc_contig, and hugetlb code also
does a migratable check when isolating in `folio_isolate_hugetlb()`.

We add the migration check here to avoid calling compaction on a
region if we know migration is not possible at all.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23..e0760eafe032 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7048,8 +7048,14 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 		if (PageReserved(page))
 			return false;
 
-		if (PageHuge(page))
-			return false;
+		if (PageHuge(page)) {
+			struct folio *folio = page_folio(page);
+
+			/* Don't consider moving same size/larger pages */
+			if (!folio_test_hugetlb_migratable(folio) ||
+			    (1 << folio_order(folio) >= nr_pages))
+				return false;
+		}
 	}
 	return true;
 }
-- 
2.51.0


