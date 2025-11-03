Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96F44CCFA05
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 11:02:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D652A8E0054; Mon,  3 Nov 2025 06:02:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3CBF8E002A; Mon,  3 Nov 2025 06:02:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79EA8E0054; Mon,  3 Nov 2025 06:02:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5E918E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 06:02:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7CE04BCDA4
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:02:10 +0000 (UTC)
X-FDA: 84069006420.01.0F2EE5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DCD2AA001B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:02:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zq8xyZaP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762167729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xWMY2o/E6UUoBWEdth9HC7Z4P93bqA/6qPGz/knPr7E=;
	b=pSopmfCfeiP3qpl1/wCj7TciTjpD+qdHjafhCexYyGwIz0esOyMbuKIruihmrejD3ACeGc
	8cKotrYwLPmzUb8Q5ZwUO3vAty+EcntO7Se2ZiEMLZgadHGa+IWTZH9h/kvnqRNdcX0Sxq
	hjSttvjoEZGJHLE5AekxU9aaKQatfTk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762167729; a=rsa-sha256;
	cv=none;
	b=izXIfVpz/siDTDzFRWyxdkZfrh4bp2UZJZY/yBPqiq9ZrZb5MdKa8Lggao6ieDK20yBhO/
	teuPI6tTGF9x4OBVZHtjbo/8SCb9FOEdKF0xIs81RsUz677Walbj1mCQZ6LVdQ5D9mVTIp
	23Cc+POqL9YYYi4YaWfscwOrokeOF2E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zq8xyZaP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DFC5041AE6;
	Mon,  3 Nov 2025 11:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742AAC4CEE7;
	Mon,  3 Nov 2025 11:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762167727;
	bh=dBEGE7Q2FKfgjAlIXnLQQ3kv27gx1kpdPQtSwVZaBLg=;
	h=From:To:Cc:Subject:Date:From;
	b=Zq8xyZaPRCiSAPW57VhpsgAiTBwBqP6XkDgxOvn5vZzA1sYnqgh0RK5mD5wnjGYGK
	 Hu0MC0hbd6ILJ24QPsYjK8AvwJlo6q3ygStghGvD32c6OmXG8C5HjncIMB9PZpxato
	 J4d2LnumJHSpZbzkzdQ0c+4R7sixgMQU/dRonIMHaL5Em2sFwnlppVzwgrIZhsXuG3
	 Og0dec424Y3aGwlYl0f+1ns2Q6LnPqADoaWiu6OjG0zo0fVswYDtBIWirBCBfuYtW2
	 Ex22L8WzhNXm3fHjLOWEViWi8YdGBaF1JvcxixiNfx8swlRvyHsquMloLFfUCHjitS
	 seAV/qWGeefQg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kho: fix out-of-bounds access of vmalloc chunk
Date: Mon,  3 Nov 2025 12:01:57 +0100
Message-ID: <20251103110159.8399-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DCD2AA001B
X-Rspamd-Server: rspam02
X-Stat-Signature: 4jfqphf3ejc3ibh8oe3ifj4rfz5rnod3
X-HE-Tag: 1762167728-930676
X-HE-Meta: U2FsdGVkX1/NL9w1uaos/CILr4UU5Mpl5E87+icmundefSre7DRdXEpsjJK5z4a7F1bxnoG6G1ctBFj2KusxxXuvPg6AdrISC0rCyY6NSHbAyrUB5uyPmpBrU8/X4IxQSa925aLx3hVlgFSGsio8UhQGFIMDt7YAuWV/FOG4C/UBkFqi8miYuLPnv8/rHY4bFFadsLtT+mqzSzV79rG2dd0VxQNduNgdNnFHd9uzCsisAF7QSt8t6b/+sSYM1F5AVUpGFnn+eOBD7hj13b5TrEB5P/VbgE/C9Dux+HdowwwEqj3SQxEkDLHMGRenX5hvsWIvFaG4BKaywUvdd4cvOz2SkD9rHxPnvHCe5o3gcEaICEuFXs+68S/vPu6Wp36x0d8QtzhMbrdgyPRJNKBEfW2stBjyCeNUxD1t2VmFWUx1EtFVMxN3fCW/DT3xt3mxYdVkx1mn5InFbWslQ9jki+Z7/9Dn5hP5OX25VvtWB2N7QHD9EIFoRj/4JhY28UZ5adZ2mDyuMZZyvhzECyxtZTfbdj4h76Btp+cPuTOL3gaRdeWSkgOBrMuO6FIF95pCauBlZlq4Og8rXyJlMQBNzKDrDnruW6ovijxz435dniBUCwN8/aZs6j+ndIea+bmCNjuaHH4GuTOA6INN8R/HcwJrGq2LZh3pbGX93glgMl/MwaHyhkp3CH8bd30JGHVpNvXm9GYaT9Zx9mI5zXRcZ8+1laJ809c+hTjXdivPTCBriRUDjjQSzo6zwlBCfN81p13RMvUDX5PABID+Xmk5aPGdbx0yE61WesbYeD7IdcSHVD/EQfWhv1bZ8tKIe8OV49zQrCLV6GNedgNJ9+vwoc4M5HUa2mFIFnl2anqyCqTmk9HT7BgNHYpIZm4UWvQP/a9wT8CWZH8hRaX2X/AemiPwF2mq/der32HBQ2fOqdaozDy8Wb1kSLRarFVEoxzvGNfa9yGRbkWtDYrZvzB
 l0R3iwvG
 CNHFYV1+ngvaxRBMdaupEzwUlDgHGaiT7LGUL2vqugdRGfWknPAfGtBwWw18NVHuiXVa4yX/jcpKrrr41WRZ+xauRAphTmaXwinmHOhDMW5iX/aFoXl9Qdq4E9E8+jJJ0KEVfqONabfTuFtWyqdxd1oYjdnqCA/RQ/MjWXdX68s53BdFMOnsB32xoF6YuZOVmi/EDou4kJhWzJSQV5MbvTWzyTq5tSIZHirttI5V1zuYIMT8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The list of pages in a vmalloc chunk is NULL-terminated. So when looping
through the pages in a vmalloc chunk, both kho_restore_vmalloc() and
kho_vmalloc_unpreserve_chunk() rightly make sure to stop when
encountering a NULL page. But when the chunk is full, the loops do not
stop and go past the bounds of chunk->phys, resulting in out-of-bounds
memory access, and possibly the restoration or unpreservation of an
invalid page.

Fix this by making sure the processing of chunk stops at the end of the
array.

Fixes: a667300bd53f2 ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---

Notes:
    Commit 89a3ecca49ee8 ("kho: make sure page being restored is actually
    from KHO") was quite helpful in catching this since kho_restore_page()
    errored out due to missing magic number, instead of "restoring" a random
    page and causing errors at other random places.

 kernel/kexec_handover.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 76f0940fb4856..cc5aaa738bc50 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -869,7 +869,7 @@ static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk)
 
 	__kho_unpreserve(track, pfn, pfn + 1);
 
-	for (int i = 0; chunk->phys[i]; i++) {
+	for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
 		pfn = PHYS_PFN(chunk->phys[i]);
 		__kho_unpreserve(track, pfn, pfn + 1);
 	}
@@ -992,7 +992,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 	while (chunk) {
 		struct page *page;
 
-		for (int i = 0; chunk->phys[i]; i++) {
+		for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
 			phys_addr_t phys = chunk->phys[i];
 
 			if (idx + contig_pages > total_pages)

base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
-- 
2.47.3


