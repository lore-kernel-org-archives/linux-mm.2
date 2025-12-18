Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5EFDD6E2CA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 19:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299D96B0088; Thu, 18 Dec 2025 14:09:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2710F6B0089; Thu, 18 Dec 2025 14:09:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17CC06B008A; Thu, 18 Dec 2025 14:09:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 055D76B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:09:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7DC5135E66
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:09:14 +0000 (UTC)
X-FDA: 84233529828.15.BBE98CF
Received: from mail-qt1-f194.google.com (mail-qt1-f194.google.com [209.85.160.194])
	by imf06.hostedemail.com (Postfix) with ESMTP id 12320180018
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:09:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=L8esBLq+;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.194 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766084953; a=rsa-sha256;
	cv=none;
	b=nUmHCbVvGwsRl7wjQFthsxyYywrTmxoabjH8UU+u9sOGHPbl4V3yF4IFJL0+NzW5TADWnL
	KsoGEOVtOu8dzoSZZ/dzwsQATzrH9aCKfyNybjAfJ7zrNK/ukNl0RNTT10HkeD7wPXQFeA
	yDCZhk+eYzi2riDTWnoLhaf2292y7xU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=L8esBLq+;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.194 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766084953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sr6t72F2/YlZspjAm+Hn5mEEflMBkP4wvzoax87pPvk=;
	b=77vEh81G8fZolEZo2jDgbVONK+QDlzlP7VNWawz3vEGNQkrcT6PWOzSh/R8zTatohEtBS4
	EMZakhqaKeabZSt19C1Fmp7vXRFf19oVqN0885zjdOFO6+moTVeuZ+2Jdxqelejj508geu
	f07bZRsSji1GKjl+EEnqv9glSbYJ9n4=
Received: by mail-qt1-f194.google.com with SMTP id d75a77b69052e-4ee328b8e38so9687621cf.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766084952; x=1766689752; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sr6t72F2/YlZspjAm+Hn5mEEflMBkP4wvzoax87pPvk=;
        b=L8esBLq+cKb2tSmUYg/hvc0Lw0L1M4jz7jXTLnTbB0OHHLjw1R7RCYy0BAivUS+8TC
         XEMmQfIkpI3ZYQvShvhrZpmr+Jkzu+lNYthL3hCfZsc5ACtA/I9brOo5ds9IeEmA5coE
         s6wQLfux1jVqamKEUFLJtUdaRJs2Z8AKJyeDfAC+2CRFzUud7bBRtXNJ1Vsjw2+HZx3a
         /EIcnNIpxAWchpB0feEd8T/bQUQOy/ynhsUO1cK6Op35LhclM0Jm8bSbALW/t94Qm6af
         4KOESEbXO78S68AoWoZLKrHNWwqrpI058MiddOB1zYT1NxYPmXviycKYINUCMy2WYEWZ
         dJow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766084952; x=1766689752;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sr6t72F2/YlZspjAm+Hn5mEEflMBkP4wvzoax87pPvk=;
        b=pyjVkS9eHKex5idsFEheA30raUYeTcIksHE0A6XbwvkRrR4pdczjoLOJZrJrWf1MDR
         aLFZkMKrLlkfUL4P3niPBxqucqeC8N3qr+7WKb8Dj5qcVby0mODU0dMk4liZ1rK2pqFK
         Qp0AB0ERNKfV/Xb6WyUw6e/SMCsygZ/Tz5VFId8nwXn3w+TaLJmp+fLq5WB2qp50VGc0
         1gZMp9k6y52WA+fIMP0kjjKgqIjk+Dfkn8Bo6T5FBQpPDYf7iVnDo2S494RH3hMqtcF/
         Sed8rSnR6Zm7Z8FvkxXDTRymtyBJJym06/2rObsT/xCBdsyFMFYM/1VYlZczrSDV+Efy
         EY/A==
X-Gm-Message-State: AOJu0YypR5AwttkicXSZdSTuLyiMegQUMagPgYfiAv4KbgtnpcsiKGTt
	yl5S5gj5ZeTIoEvK/8IZl3D3NMizTZNmTwemnuKw2AYqnmmNSCy8I6hqR66EGH7psIyCEshXvIp
	Dgoj/
X-Gm-Gg: AY/fxX5UBPyWwly6yl7UG3RDrME5AOrZMyNtny0UHk9F8gkzPzbuz4ZkWwZxF49sp1D
	qQTUcIUzW+bwnoFSxrsL8wgCj/eT46NRSRbXNrkl2LS7ad+r1Mi9QRhbRApovaqIiQldjztv8sD
	KrjTZO3ShpR4Fq2cfIfE343whdd2udnMsQxOuCBqVceu0YZ7ldDnE4LPHeIhOIpaZjdxYkC3OHm
	XWO9QI4K+myYZWZqCOkV3OS41GyNGLUe6151njYMFVYaMDB49qzck/4IpJZhxl7QnPqXMS1jIOw
	f9Pec0/y8aBwfwSRgzozRUtFM4fNxI57XsWPh5EwxwPHh4nNENSpi8lJ9eLQJ3wrAXssFTq9X5a
	FbrMwHUBh5Mr4BaT7OKZGSe/b89F77aDT1Z0BRBHj7SFVlc+KoP7mP+MiO4cDXYF7T7+W+ZbzEK
	E6ZI9s9GouhAlCsPgnYCA09IXv0mVjIvLrW+mUGP9eZl4xa2XeemU5pBIeSKIQghwJ6ghrIhqem
	+g=
X-Google-Smtp-Source: AGHT+IE2kdBu3P33xwfz1hi6O4x5R3FYIFiXDMr78ahQNaJ9YkXrvKTYMyxchFx9IfZwSWBKWgVahg==
X-Received: by 2002:ac8:5714:0:b0:4ed:b06b:d67d with SMTP id d75a77b69052e-4f4abd79a65mr3935091cf.45.1766084951597;
        Thu, 18 Dec 2025 11:09:11 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac532d08sm382601cf.6.2025.12.18.11.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 11:09:11 -0800 (PST)
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
	richard.weiyang@gmail.com,
	osalvador@suse.de,
	rientjes@google.com,
	david@redhat.com,
	joshua.hahnjy@gmail.com,
	fvdl@google.com
Subject: [PATCH v5] page_alloc: allow migration of smaller hugepages during contig_alloc
Date: Thu, 18 Dec 2025 14:08:31 -0500
Message-ID: <20251218190832.1319797-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 12320180018
X-Rspamd-Server: rspam03
X-Stat-Signature: iwwpk3ai9cg3mm18dft1zweys31i5nia
X-Rspam-User: 
X-HE-Tag: 1766084952-686620
X-HE-Meta: U2FsdGVkX18yaYxNZnyu6RmIcMJY1S7xY38UlO9jyIqIHM69hkIqD5haev7W4oJuwVEUamFOVPuu8YxX3NvCpmeMk69iQ/mgK9mPXOSxzEaE7MEN6hfrKCGN8gVsXzmHtimFK+h0BZjfk2Fv6BtlBZOmlJkGNtKscghOEBvdIfFvm25nw3QafFAClRBtqDBbKh2T3g6ZUo5cYEes5lNxrP6kASP5cPtG3qr+gg3sSoBg2+eAdao7foBbWOFaWk4xEhbA3uVZZX7AtJ7H78SQOkrF9gyA83sQNh7svMZdPsEJPbHXEDb9BvsN7Wf9byZfENFWd8mp+lHcwolPPbP/cofWNL64UMmWVrGb2y80RnfDsQzbbd1zI/gJn3NmypKXmwuInvuj4bkL7ehJBQB9wmylYXJnzMCQs8Z7PImrqvrT2f1im5ZdkPcp2SjWNwo22fvjmFYTysLQvwtwTycP9kzRvcKOurYHFQugwROvz5W/nbYNxJvoIZzOt3wPQfbN+aiMVhFIpPEjrmP6NuPq0Lo34DPO8EbeRyX89SVMi1n3hDr56+YuqGAf1sIQiDVml9IxHvx04H0v5WtsFpX5MFWyLMieqw15QvT6eyVoBbhS7uSQ/nrgj4hpMzp1D2DYx/UVC3gTj33pldJvrCUNVcvPaR2GDazRiFQj9V/RCAPBoJr9DnMOeJAFXwxThHL+gkndZZKRDbmpAQjM49TtfDrGlrzpDQR54dhClPPCd7FbM6XsgEdVyCqOCwAECQUCd5oMm7aFxAD/eLUYuWujNNu5nAjjZ4BGtt04MTaDcr4AgSuOM1FqmYGNPSOs2haeyIQE2ZMKYz7LnBCe7MdN1vXVUw/RsDlBwl7rdWvB3W8NMe/zAU0HBtr5pWeWnmiGve4PQir57fll+9/4u/8YyQQ5XxWdO3lAcoorlalQofyO71bzTYlzyQ6hYOKATF83aqihrKjbTtXkurFSksV
 xFTR/txi
 hrSrQcni3XR5QHTnTIRzh53xmsGUwThr7I8sM7JpYBw4D+knJith3Tog/McAusYYOWWwyXvY6z4CKClrrdtNQdvtKO2UZS+H/6jJ0fq0fizD44l3OPjO9qRguHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We presently skip regions with hugepages entirely when trying to do
contiguous page allocation.  This will cause otherwise-movable
2MB HugeTLB pages to be considered unmovable, and will make 1GB
hugepages allocation less reliable on systems utilizing both.

Commit 4d73ba5fa710 ("mm: page_alloc: skip regions with hugetlbfs pages
when allocating 1G pages") skipped all HugePage containing regions
because it can cause significant delays in 1G allocation (as HugeTLB
migrations may fail for a number of reasons).

Instead, if hugepage migration is enabled, consider regions with
hugepages smaller than the target contiguous allocation request
as valid targets for allocation.

We optimize for the existing behavior by searching for non-hugetlb
regions in a first pass, then retrying the search to include hugetlb
only on failure.  This allows the existing fast-path to remain the
default case with a slow-path fallback to increase reliability.

isolate_migrate_pages_block() has similar hugetlb filter logic, and
the hugetlb code does a migratable check in folio_isolate_hugetlb()
during isolation.  The code servicing the allocation and migration
already supports this exact use case (it's just unreachable).

To test, allocate a bunch of 2MB HugeTLB pages (in this case 48GB)
and then attempt to allocate some 1G HugeTLB pages (in this case 4GB)
(Scale to your machine's memory capacity).

echo 24576 > .../hugepages-2048kB/nr_hugepages
echo 4 > .../hugepages-1048576kB/nr_hugepages

Prior to this patch, the 1GB page allocation can fail if no contiguous
1GB pages remain.  After this patch, the kernel will try to move 2MB
pages and successfully allocate the 1GB pages (assuming overall
sufficient memory is available). Also tested this while a program had
the 2MB reservations mapped, and the 1GB reservation still succeeds.

folio_alloc_gigantic() is the primary user of alloc_contig_pages(),
other users are debug or init-time allocations and largely unaffected.
- ppc/memtrace is a debugfs interface
- x86/tdx memory allocation occurs once on module-init
- kfence/core happens once on module (late) init
- THP uses it in debug_vm_pgtable_alloc_huge_page at __init time

Suggested-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/linux-mm/6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com/
Signed-off-by: Gregory Price <gourry@gourry.net>
---
v5: add fast-path/slow-path mechanism to retain current performance
    dropped tags as this changes the behavior of the patch
    most of the logic otherwise remains the same.

 mm/page_alloc.c | 44 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 822e05f1a964..3ddad1fca924 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7083,7 +7083,7 @@ static int __alloc_contig_pages(unsigned long start_pfn,
 }
 
 static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
-				   unsigned long nr_pages)
+				   unsigned long nr_pages, bool search_hugetlb)
 {
 	unsigned long i, end_pfn = start_pfn + nr_pages;
 	struct page *page;
@@ -7099,8 +7099,30 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 		if (PageReserved(page))
 			return false;
 
-		if (PageHuge(page))
-			return false;
+		/*
+		 * Only consider ranges containing hugepages if those pages are
+		 * smaller than the requested contiguous region.  e.g.:
+		 *     Move 2MB pages to free up a 1GB range.
+		 *     Don't move 1GB pages to free up a 2MB range.
+		 *
+		 * This makes contiguous allocation more reliable if multiple
+		 * hugepage sizes are used without causing needless movement.
+		 */
+		if (PageHuge(page)) {
+			unsigned int order;
+
+			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
+				return false;
+
+			if (!search_hugetlb)
+				return false;
+
+			page = compound_head(page);
+			order = compound_order(page);
+			if ((order >= MAX_FOLIO_ORDER) ||
+			    (nr_pages <= (1 << order)))
+				return false;
+		}
 	}
 	return true;
 }
@@ -7143,7 +7165,9 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 	struct zonelist *zonelist;
 	struct zone *zone;
 	struct zoneref *z;
+	bool hugetlb = false;
 
+retry:
 	zonelist = node_zonelist(nid, gfp_mask);
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(gfp_mask), nodemask) {
@@ -7151,7 +7175,8 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 
 		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
 		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
-			if (pfn_range_valid_contig(zone, pfn, nr_pages)) {
+			if (pfn_range_valid_contig(zone, pfn, nr_pages,
+						   hugetlb)) {
 				/*
 				 * We release the zone lock here because
 				 * alloc_contig_range() will also lock the zone
@@ -7170,6 +7195,17 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
+	/*
+	 * If we failed, retry the search, but treat regions with HugeTLB pages
+	 * as valid targets.  This retains fast-allocations on first pass
+	 * without trying to migrate HugeTLB pages (which may fail). On the
+	 * second pass, we will try moving HugeTLB pages when those pages are
+	 * smaller than the requested contiguous region size.
+	 */
+	if (!hugetlb && IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION)) {
+		hugetlb = true;
+		goto retry;
+	}
 	return NULL;
 }
 #endif /* CONFIG_CONTIG_ALLOC */
-- 
2.52.0


