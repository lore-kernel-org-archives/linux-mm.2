Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A45B1C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A526B0095; Tue,  8 Sep 2026 08:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3D016B009E; Tue,  8 Sep 2026 08:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52DC6B009F; Tue,  8 Sep 2026 08:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C41DA6B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DC4412057B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:20 +0000 (UTC)
X-FDA: 85190580720.16.DACD482
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf26.hostedemail.com (Postfix) with ESMTP id 40BAB140007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B C6RTcg";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MGv3A5vu;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hGlkwJH8rpVYNSw9dyCZihy+2pP4J7uKRwXxgbT84Y=;
	b=SomTOq+EIFf6zQS6oCgSUlm0zAuVMGXWE5m1R8raZwBdWhnweq4uY5IMi+4LGO6twew8mH
	8kfMO0OOgc31ilhblNyqzB655ZPJdbnY0pR4T/iQbdhLZ75b5XFNWfMTfFoKxTbQhZG9KG
	YoVOGReItsLfYkSogTlzBcAkixn9tyM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871878;
	b=NAqyYt67n6yjk6MhnF58GFC83s2g3At0M3bzSPJy60tVhPgLSStOY0+4Nzl56pQ8t53Ui3
	L2qMGasrLmCZRVDjpi89rPFg/HROj9soK1wOw8PXVUKF/NoHPcZoF3OxnsQ18y5Rl+Js3/
	zNAwYuCDmu3DDMwDuaxdNYpP7jtv8II=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B C6RTcg";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MGv3A5vu;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id BB4C2EC010E;
	Tue,  8 Sep 2026 08:51:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Tue, 08 Sep 2026 08:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871877; x=
	1788958277; bh=2hGlkwJH8rpVYNSw9dyCZihy+2pP4J7uKRwXxgbT84Y=; b=B
	C6RTcgvMZ+j0dLw/pV7afe7NzIFUram5k9kDBc2+D+gPWYmiYNXopP+2DxEgnUwz
	gmhL7JexHkSVLlTIvvAcfadHibeRFg9WvS+ryO6dGwybP5WKipfSr4Fqn2vXa98X
	wX7dxut8kVUfnu4y1iZ1Tw5zhQ2EdTph5SbKC1g0a3nFH5YUkKxCfxxaFTvD0i2I
	4HFnJZXtIdvyybWadFDE6CkwsjK51eWdHosLUjfOkq0YKNdAzL3AJvHx4+S9rW/2
	vG9NtMZm5D2NqwyLXrYuLObaLK2QWJ+6u8BPereNdrHQWy2p6KM8QcV2vg5WZMOp
	9XtHH38QyEyns8o/aSb7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871877; x=1788958277; bh=2
	hGlkwJH8rpVYNSw9dyCZihy+2pP4J7uKRwXxgbT84Y=; b=MGv3A5vuwwT/kKvXV
	ryQ/URKE2Xq1OvDZwW5m6ZtNn6p1Hkx0Qh21kxJKPlYKDStgjdcsv/U/xZ0+PJcV
	UD3ToQAdesS4T1mrlF9n4IYvrfmcC/2qnOl2wPGosVfr7J9izvNHQGcesoDRNhAn
	69CeOjmSj7PhO+733sEIpCVyYp1O/EQitK7XDY8KX0z/Avsd/QMvGDW8w2EUKFU6
	fRpyLl6rBlwQUZb9htZaGVDMfrBmlzdjY+0MwrK+5UWqDORV3z9QG/XdseZNQNA6
	DMBHj+ZvyOoh16dPdfak4vHMFr8o4KsPhSd2e96aZDT6kbVwkK3JMo8ho63rg7p1
	IUgAQ==
X-ME-Sender: <xms:xQSgarVe8zCoZRLAVjd6i67gnnc_jPaoVhzw1tis775NIP6dxA311A>
    <xme:xQSgar-J1i2a11Qt9LeixGXaGdLUBHJZqus23_RYuoy1e6_RqiA-eLuhB9E-MJiHT
    5OyyLacB24uMEwiqvgATfmvaaFIuvmh6RGetrntp48vtrFS-ZNqWyl2>
X-ME-Received: <xmr:xQSgapmY8gx1aMdK9CL97173s60X9ivphiZ0poWXGjI424TGkW-crTIrEec>
X-ME-Proxy-Cause: dmFkZTFCT83ts3xpHDuUgDdlzQtELcoAknrXBpsFepmdcEBLccwduWOOVyAuau0VlYvm49
    objBvbnGefvuHsKXiB+MOl7qErn3M4/Q7Z72R+asBFni+WG6jRYqPjjJBv1F7ovmfnEZp3
    uEJcbLADGcdxsWcYxdWct2wwV9KQaoOTpGWM7Il7/oKOILrVOp7MvqHbWAXdA0mgRBniUZ
    2M+Su4Zoe9zFbzekNirjNltohahTSfzaLbYZTkGXD/hRQ+ajqkABo2HdEn2GJrc7g0w4Iu
    PhTUexE0AKZ4j2dsA7W9i19VnbZvZZgTTujH64lpg2nDW6KlKK63jDlRsrLETwVfJ8WCYT
    c+1thOoDewX31NDRvXFN4FzlTNJbNXxIxXZjZXhV04JGtGEMASGQE13zj3ov8UNJ4DV03c
    hgGHVSPpLeKSwMrclFT227P9uZgw/zASFm8T7kNC8oysJSwF7oz7DhskUil4s7vgqC0Ujg
    sbzjWvYrlaiDWtwWvVOPU4KY1M4TkgM2w/RNXl+09lrdc5Lm8OZVr28UpHrx4IPp2zJwYw
    2Z6Z7FSPOdzUAx59/gI6YMrK/Lw5o55EpppddSmm8GWtF8Sk9hdqmGAGS+v9WjvJH2+eLN
    SOezize9leW/aI5FS2JtPvjb54u8YUaB5Lf/aK4j4I3ZC08E9OcMVz/o8gRw
X-ME-Proxy: <xmx:xQSgauKgzsRJVCgZoYjxvoe_ofuwQfSW9p7ApsuZ03rKt4TMqL_z8g>
    <xmx:xQSganr1rgb9A6AuSyjtofSnrKWxPNSE1DcO6dbbGzWn2E6tCFTF0A>
    <xmx:xQSgajSAkWUonf1kYAFJBZBHi7BO39zLyMPtoJCiYH8J9F2UeNA4_g>
    <xmx:xQSgai74A-TeTaEHqm6Mz8iAgwBAM5o21wHE7JipeJKNP4oK9Rh-VA>
    <xmx:xQSgaoJ3rWE2efYo1GEW-RVOULv-AnV8HtcarO-f49ElWVHMthMMSR9_>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:16 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 03/19] selftests/mm: scale khugepaged's collapse wait with the PMD size
Date: Tue,  8 Sep 2026 13:50:49 +0100
Message-ID: <20260908125105.1510704-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rtdqnzpxuiaenmjrd45bnqcgr5tzezqa
X-Rspam-User: 
X-Rspamd-Queue-Id: 40BAB140007
X-Rspamd-Server: rspam03
X-HE-Tag: 1788871878-244046
X-HE-Meta: U2FsdGVkX185XP+GQArj5j7PptqTZBvTUJblDjRn4EQkL5O9gZ5TXyGgVcw+B532F+djw9vrM2Ca0cXE7v5A6s7DJjiylD84e8aKqdyI5xCs0yBg8T6qNOo+UdRmSUyY2YyMNaH2MSPfDNK1eWtWHRgcQ36FpsHcrj/wQR8/cf4/odjjDVdQ2Jz8vJmGByXZIft39qZBMcSjWdMlNxcSmYTKTB98LY/XODAKuLVmyDhMXhOR8trjqzNFMNByGhPvsF50IXZF5P09aZp3lxbn07k9f7YdlRDVpHTh/6Q1L/ofMn5QefHG4FuPj+hQOSE1Q66oznyvoWZ4D4e9LfDmEVYGXw2phCPeiNJkmvcKagctC9TIspRCzVF0KTZe3TKEdjT8XMqFcZYaVMfAFJXxPjuDyHlNSyaNBuRhnF/8uG76LTQNVuvn/pYoCmHybTjTOT/xxIpW3hA8TMlDfyaN2fNfYbH0Inxj13qKjYY3pHexo2JXZFoRvQB2zLoyZBqO1ljeSdLmYvQPJ1C22ImnJHkJcb8V/7AfPkdOgFVcLAmWqtOymuVjIpHSPsJcGs+8PrZv2d5T2PLFJRfiKcV0uQLUWZ3XD8H5zOV/P2e5L30WSDNsVrZE8NewQQllfND1+MoYhJfLl7yMmXrAIhv+cbwC/tQC9GqjtLMBbvnNFDcovY7RPTzT4NVhG2Re3w8P3279+YXM1+WGqg68OHaQRsrU8OULHMbUUr8+HyxZk2wNJH/uBQ2jCK+NLVBrM1rLTh+SDQhMRPEDrfDK0xNw9w/U7VYO6/TjYVqTmQQWkC5aaN6iOX3d8dSHA8te8tAluvoTHrWsTAhIRAt/b0WllgCGupacLgJESidiuhxp6vM/avJl4ajidjuL9QiJhtvoZAtIXzZ4d5aqDl/6dyj8ktpRzYiQ7nGpfpPNh3LOInZ18PHm0aDL+6wez9RHSXuVuP4A2BqAHqSitAry/r9
 IXQAzLD9
 WXmq8QuQBpzfrL88b11iVIFDUU8cdIWj+KUCO22Zduv5V6m+3X6PMy+PSfPOozgN8IkpcotrJJQNMqT4oMEq46KfXyV7y6mIprBQZDugRaH7CDn9OkzITvX8+KUKleBwAsscOeQpIqkDUejQbgtWY5WSk1jTMX6a5QaHdozCq6DFoQ0e7/tuKlBONChI5smzkwgEWVk3ebTkKwwsLqsxxV4plvmYcKrZ/LJpt7wrX/C47srfookMjEV9J90I9usxPtqYRTMCLUiRZ7TjPVdExzHuYFITARWfQxGndOCoJw2s2WQOZuJlDw//EqMaPuvV30ljpFPQk3G+gHtKqB/ORJxeK5k9qbDykJAwZtHT/mZyanaaksYWzvsbVyMxaon9C44FUwwNV06Tk1ELOa9/Qv8HjvR48yC8oIAijFTX4rjPz7k35REFK8MmFrvhNcDiOphqWbZMCVJHqO7USpESvG1MxxX0oR/4VPCQrsdauQNUx1xXZhJUj4XRaoL65d+G2P36l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

wait_for_scan() gives every case the same three seconds, whatever the huge
page costs to build.  collapse_full() asks for four of them: 8M at a 2M
PMD, but 2G at a 512M PMD -- arm64 with 64K base pages.  Three seconds is
thin at that size, and the case has reported a failure for a collapse that
was still going.

The timeout is a ceiling on a poll loop, not a sleep: the loop stops as
soon as ops->check_huge() sees the collapse, or as soon as full_scans has
advanced by two.  Raising it costs a passing case nothing.  Across 80 runs
of collapse_full() on arm64 with 64K pages the wait was half a second in
73 of them, with a tail to two seconds.

Keep three seconds as the floor and add a second per 128M collapsed.  A 2M
PMD is unchanged, so x86-64 is too; a 512M PMD gets 19 seconds.

On arm64 with 64K pages a passing ./khugepaged all:anon takes 49 seconds
under TCG before and after this change.

Assisted-by: LLM
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 1ca7c6978571..48e0040d53b4 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -556,8 +556,11 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
 		int nr_hpages, int collap_order, struct mem_ops *ops)
 {
 	unsigned long hpage_size = page_size << collap_order;
-	int full_scans;
-	int timeout = 6; /* 3 seconds */
+	unsigned long bytes = (unsigned long)nr_hpages * hpage_size;
+	int timeout, full_scans;
+
+	/* Half-second ticks: three seconds floor, plus a second per 128M */
+	timeout = 6 + 2 * (bytes / (128UL << 20));
 
 	/* Sanity check */
 	if (!ops->check_huge(p, len, 0, hpage_size))
-- 
2.54.0


