Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33291D0E6C8
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 11:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647396B0030; Tue, 25 Nov 2025 06:09:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CECE6B0031; Tue, 25 Nov 2025 06:09:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BFDD6B0032; Tue, 25 Nov 2025 06:09:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B3746B0030
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 06:09:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E81DC160853
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:09:31 +0000 (UTC)
X-FDA: 84148858542.28.DDD339F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 32EC6A0003
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:09:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IL+MewD2;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764068970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zcZ/0x2QC5aZSYY0Wx/FbaySR5n1WpjcQwAP9quH9Oc=;
	b=n4nBn49m2ySkPvWn1reyOuszaGjSSq27aIdnvc2w2iizcQCO1YuRsRCIdgVmTxPCr7FzkY
	MNI5J9AlbW3mg5se2Vn1iO2A+IwtUS+mlzftkZ+Eecr89NShESdZyuRiDuqTTDHf9SXFKo
	2bnS9M4PR8T7Bbxj70mGeeNuQept5Zo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764068970; a=rsa-sha256;
	cv=none;
	b=Ee/CeCMObTLoE2w5eo1GN3uISJ500k3UcK0x5rzql7Zv1xFkr6FBeBOodmhRM+Mgf6awir
	v2T1cr2XrJhDD3es1Lr0SssCWx+6gUYLqvuFCZqtpJnjYZuMgDDjcBsYQ80xdomZt8hPXq
	ewbSgox96eSTxlIHObUYHMb4u9xHh0U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IL+MewD2;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1F8C43F8C;
	Tue, 25 Nov 2025 11:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BE5C4CEF1;
	Tue, 25 Nov 2025 11:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764068968;
	bh=MS5FYY77YbUK+JnTC70ZJhGSJBc/kCi9Z+1XsOTG/hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IL+MewD2vccgFyCl83IBplNj7nZAp3OmlK7ap4lcO9Suh408qb8kBRDwhD5hR77RJ
	 +lJioiWjhFZV9M3k2xrBWD+cNXir5DaHSn8KUwDQI59e1wlH4qjQ8fWgHTPemittIP
	 D2OILvVd+b33cfmj6H9JM+GrqAHFwbwb1brsJvFD3FtCexu+X6CneRzKUu4lNqGbzf
	 gzQd7SF319Io0kg6PDxH01y/r/LU5PcgGarQC5XC2XMP0izIOex/YiQbIzBPDr+o+f
	 fkCvr7RRA9+2uTEs3gcNgqi1tgO9VkXfDc3G7ePKncGs7Tfd7ynmcuFGu/Igw95F3R
	 qSzXObEyFSLKQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kho: fix restoring of contiguous ranges of order-0 pages
Date: Tue, 25 Nov 2025 13:09:17 +0200
Message-ID: <20251125110917.843744-3-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251125110917.843744-1-rppt@kernel.org>
References: <20251125110917.843744-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 32EC6A0003
X-Stat-Signature: 5nreseh7wz7x3x6pydqz5tfk9i7pkfuc
X-HE-Tag: 1764068969-541136
X-HE-Meta: U2FsdGVkX19oM1cr3c+v5HU+/y5cPPhdtxFFvk9/K8iZ1wdAT/dJzxv2ErubcVrOPyrCYEovfJKayfmkYjBebCVCCv81AT+40BS5RpZckdB1CxiX3WYgNSgMdmnKx3VMv7ptaTpEnaZ3brDHnF7B1jjWjk53HeDE9Kf2lPSeAzr9JUVSt9x1wL2fre2OJE0AU3izbG1jJEtAtLO4s6olrZ3dkeRHwqcBZC1GH/ITmXzIJuAlNVVy/BRB+a9lMp3pVBBbZJ9XX26uJjRGGXkmvdqrJMoPnNMJ8dAoIL8x+4bCtHC5rL4vr7YHri6s1KFBUDPcsPeRMJuSXR0iwF4pINQ+e1ubbFJfN48cYJpV6e1WWRk+L4HabmFgVcfVlILgMUT2GSZnjru/O/AMnJWJ62svRZobbCQHsbXPxWCYhjhyZADl3+ja3c9HmEGUq9/MBxeqKMqHai1MfMHdNitHW4W6grlU04Dr/M2VcB7fNdJR6oUPbSNNdRQGQiw+C8AoC0OZNJ6nEEyOqobjrcarhL1yMMB5Q3YpKRhHovPRs/Z7YGbjHBeTaFaYeapeUhgTEP9jRh8uIeM9/MyLjpAg9jRs8nIKz9dRI2T+dWnrE2bRFcDl//GRVppAcVgowAOrVQPH2q89d2lMan3b9zXhxNvCsZmpK1JhrFxrnQUJ39onE6E2JPshBJ9LJWPHgwhkIkxzWgV4PUqCsecVf05WucG8bmMQAgAZqQyZ0i7wvv1HoC4+OJmErwJl/S/9MvWgRvJW+dSt4GDL3uNa5zXf3HYoJ2PuTek3EzDbEuTHQJCrBOv6VSip4/RH2oJslSspT95oWirsayG/dRvNHgZe65w9UBlIUiRv1pztKs7L7l0QWVBlUzqvp8ZHxv3tMjEiAkXV+3hEoMAHhgGpo8UG76aihyNxDPtccWkWFmsXpKC6O1LLXtO/ejPYVAcwKZzWm03LuOSg9OtDHw7CVd2
 pDdA74k+
 Ef1vLkWRv6ghb8223CT8JSlyIr35cIZRj/PoFhzcC3TwiCEaEhZSIFLoim9w6GEILNhB2x2649wp/oJXBftuCdXQd2gpp2eTNX/V4GFcNMMvTWD5/Bg5QRRl5/0KgMK+Ej6dBFazpPX6TiqvUf2yTNXf9KKjpyqzeLQAzR9eBF+gIMgttwUOTHsCNeQPExRXJgRgSuVO+VVDgL4frjV3CxvOnpTPWdf2z2w5cp9H/IK6Cyk8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When contiguous ranges of order-0 pages are restored, kho_restore_page()
calls prep_compound_page() with the first page in the range and order as
parameters and then kho_restore_pages() calls split_page() to make sure all
pages in the range are order-0.

However, since split_page() is not intended to split compound pages and
with VM_DEBUG enabled it will trigger a VM_BUG_ON_PAGE().

Update kho_restore_page() so that it will use prep_compound_page() when it
restores a folio and make sure it properly sets page count for both large
folios and ranges of order-0 pages.

Reported-by: Pratyush Yadav <pratyush@kernel.org>
Fixes: a667300bd53f ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index e64ee87fa62a..61d17ed1f423 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -219,11 +219,11 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 	return 0;
 }
 
-static struct page *kho_restore_page(phys_addr_t phys)
+static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
+	unsigned int nr_pages, ref_cnt;
 	union kho_page_info info;
-	unsigned int nr_pages;
 
 	if (!page)
 		return NULL;
@@ -243,11 +243,16 @@ static struct page *kho_restore_page(phys_addr_t phys)
 	/* Head page gets refcount of 1. */
 	set_page_count(page, 1);
 
-	/* For higher order folios, tail pages get a page count of zero. */
+	/*
+	 * For higher order folios, tail pages get a page count of zero.
+	 * For physically contiguous order-0 pages every pages gets a page
+	 * count of 1
+	 */
+	ref_cnt = is_folio ? 0 : 1;
 	for (unsigned int i = 1; i < nr_pages; i++)
-		set_page_count(page + i, 0);
+		set_page_count(page + i, ref_cnt);
 
-	if (info.order > 0)
+	if (is_folio && info.order)
 		prep_compound_page(page, info.order);
 
 	adjust_managed_page_count(page, nr_pages);
@@ -262,7 +267,7 @@ static struct page *kho_restore_page(phys_addr_t phys)
  */
 struct folio *kho_restore_folio(phys_addr_t phys)
 {
-	struct page *page = kho_restore_page(phys);
+	struct page *page = kho_restore_page(phys, true);
 
 	return page ? page_folio(page) : NULL;
 }
@@ -287,11 +292,10 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages)
 	while (pfn < end_pfn) {
 		const unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-		struct page *page = kho_restore_page(PFN_PHYS(pfn));
+		struct page *page = kho_restore_page(PFN_PHYS(pfn), false);
 
 		if (!page)
 			return NULL;
-		split_page(page, order);
 		pfn += 1 << order;
 	}
 
-- 
2.50.1


