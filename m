Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D959CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E0426B00CD; Tue,  2 Jun 2026 06:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890306B00CE; Tue,  2 Jun 2026 06:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77FF46B00D0; Tue,  2 Jun 2026 06:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 638E76B00CD
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:12:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FBA8A0899
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:03 +0000 (UTC)
X-FDA: 84834556926.13.4BFCB50
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4DEC214000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UGQuTa6h;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395121;
	b=VnvfyQ9JabNyxviY+GfyYikIHPfbQhzob2uaAt2b7r1eE4KFOqDLiMzR9SKA+WJeAfvy1i
	VN8y55gwC526lomKRP0JAPTvB46T9FMro78qWyB1Vlc3/kRKIGS3K55wvouXxFSW3ijzRG
	ZI1EYiKgG4hcX5talvuO91huXdb339U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UGQuTa6h;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VWUO3+cl7MWVyS5m22bSK5o78fH+CF71Q5m4ETc4a2A=;
	b=zueAkUeCIsAZt7eNeTl/fPnxgxCjdCgMPjwSRc2hWQFMybH8c0X7qn6k5uvskBUAV32gQN
	pl1HGNwVgX8nuxKWRax9UnfoR9AfOxb3bDLWBRym8gdkLF3GXwcOKXzVO2rYrOuSv+fV03
	+MiJZSs10vFvwio0Pz1wZFcS+z8eCSg=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c8585c51f1fso1171201a12.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395120; x=1780999920; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VWUO3+cl7MWVyS5m22bSK5o78fH+CF71Q5m4ETc4a2A=;
        b=UGQuTa6hDdeOAjqs6V8lX6Eg87jPuOgtYWDkceI5Ro6rM2jn6+6w84gBX4owTrJWMD
         pw7pGSAoBHsRMYn2xWt2uuc5Y7aeQ9xxw6Z1mRoCp0RKVikwpopYYJE+5zWoBZZN3N2i
         afN0qqt2BfwSPHlpQsr66+t07jNPt/EtuIgVH5yjqKsOczaIQd31BJbKlamqKZ7DED0L
         m8su36eac/xMINukt74WGKDp0O8nLCLRobAJAnuYamcFQorM8zyrRII+JPWt8bY5VTHW
         IAJHCIPh0js1UmF+FVFnpSkgSypG3oqWHhPDclSpVzpwbKezkmnXxY9eMqB47OCGLHzN
         u9yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395120; x=1780999920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VWUO3+cl7MWVyS5m22bSK5o78fH+CF71Q5m4ETc4a2A=;
        b=DXzxeuirD0lGKxU2WYQJg2vfa0dBvej44ykk/sNbAr5IK/AEjBp7541FwnpW4k/vSE
         bV7uU4F8ajAaqqzpuCYnNu0eZ5QBZ/5sOk2FuCCYX0O2iwfMeTQ+2AaA/bjNgFRPH4WW
         Q1SN/k9RIB9fcDAXqzxdBmSy8fLlWVz/aYEMpW857AdSlsPICuOQv5cuIJiB+1Hy6K47
         z7E2l9J6Ap1Tldib1fiaip4Zsaz+kTy/W2D+flMgFfNl/c676RAGHNdeQF34i0VGfHZj
         EVDmrs5yMIvQbwRaTbo3zEngUeSRLDbuZoQCkqzi//spECLbAn+4w8dI2ZKMFQasLECp
         pYLw==
X-Forwarded-Encrypted: i=1; AFNElJ9CrXgkA9SXpyZD5W392DVmA5jm+2DvPEuHMthsRVgEMNtOEa3ETW3ApmGPuDoI7QGssrmEa7TZlA==@kvack.org
X-Gm-Message-State: AOJu0Yy5mNzZEwxjB7LMpEQkAuuWDyYzmKFjv47KBzX5D//u3I4jPrhm
	vcwxet46WoA3dqk7jXKz8hNl0v+jPN36kQAmGbbQAjXQcFQMDhssaRVfUJ8Ny6wYImo=
X-Gm-Gg: Acq92OHAoajoGTkJAm7+S5GEKggbaC45x7zit+2QGWXBs9xo+3baPHwyc4H6dYNwlWk
	hpFo4CG7qjJ/P4ixoMFcgmNKwcJ5wamw/vYb3MqepXOo+egWLIsSaDWwbVTwi9pDNG91JHmGSxs
	CspTKfh68nDxvcvlQzMSsFxYZGojsxgO2HIG95ig3gDLH7azmDvieFjuVkzt9NDYK1JFxAJgCXs
	9PY9abE85Xybxc+wo7DrBAMFKsdav7TqbMLgH+ylOWeFQFSNCHsUQQhj7faf24P7bfGObRyB/km
	DWT/LDRaitvX0sW7KcQ1Y2YUGFl3CKbqLj7DKCEgHIsg+rDXxrtpkZi6k4m5rxAPSjByVo3SMom
	+UuN1r8j2frREOTSzfzQ/BufvF1yqS/XGjxnWnliwnJjxnysgFQ1u0Q/O6pMlsNqG9UccRfuSxL
	8og4nxpF1+Z+Njt4WUHpeVApFCgFRZlHAuCc3yi1U9ej0Pc+RRgc5CAg8=
X-Received: by 2002:a05:6a20:c79a:b0:3b4:613f:90b1 with SMTP id adf61e73a8af0-3b478a4a8ffmr3176243637.16.1780395116512;
        Tue, 02 Jun 2026 03:11:56 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:11:55 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 12/19] mm/hugetlb_cma: Validate hugetlb CMA range by zone at reserve time
Date: Tue,  2 Jun 2026 18:10:32 +0800
Message-ID: <20260602101039.1867613-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4DEC214000D
X-Rspam-User: 
X-Stat-Signature: wabnor9p9f8x3q9see7sm1y1bx3ksai5
X-HE-Tag: 1780395121-725318
X-HE-Meta: U2FsdGVkX1/E4Tf5RAU0vrG7tCn7xOzrj8Wuo6bvwPKRATCfiisB1J5ZVSlFOEW6LQye4T8txP+yOvk0quKTMXes6d9AnFrzlz13CioeC+DdXhT94hPferIppHORu3JRIe/f8MCYdVqWNjpJbxy588dfhai1cLzui0LEO1ZELkGVh/gbTxPPycTEm8MVABdslxULS58/nFUbtaHBLZPbfcKsZHWfeRqF8kOnqYyw2sbZ0jJf68oXB/PLZNI+p8uX/d5aZnLsykEiWw5VIQ39SZlQdHTqb4ZmHARmtmRupQcICpqWGESV3HwcX1g4vdrqBfjoCByq6ahmo7mx+yAzxax09KE0PvVjx2tUxWuYYSmQoOhR/dpi2saqDxpP+7IoB5lTNa5yI5AqShn9/+OO+V35eDXU+ltGlNbW4QR+4fdO1xDxDo7IA8iivyYI7Kaj+ATmFyTpGXB4i/q5dI/iXP8Xy6j3Z2sBhOqYWkyl8dNiObGQQUXRvmKAsQsIowU57vaIcf7n9tfnNjy81dgQQxbsdPHRANdv4qzEF9pa5LDdDWMTIzimkkg2msHN9Wdw6i5B7NWDgAot3IJGA+zgK8Ghzf9/P39CV6oscEYi5Qce08lD4dZ5BmAejs2Bv7F94MimJiVaX7x+Wd8z2x1Nt4xpdW18VwTbksZGybv5wfoLaFc0mq1dl8rl4tHjEsF87aAC9v2w/u/Kmu60zZ1Xa4DhN1xMx8UMiouAxKcT5NP18HvhElskHiILhUe2GXVusP2V28xK20SFYtkLXaUn3lLNuBE9DqxzI8SmPwe6uGDxoKD+khFbc0wqjSvSLU5uyC3ZLCmI2xr1FkOPMOLl/C7V4ceYbZgjSRaEYbQyk9l3Z/XrFAP7fD+hiaGqj2vcABp1oT2O1sWdq1WGlvFQ28IsUb5Rkn+4CCN7CBfSpVL6tzUM5vxUsB4z+7nSmN2+xmuvMn/3bM8vx4n0urF
 dqHenMmV
 TGmtmhAzo/PrYnfhN453FT64ZBY8vgN84lOCxkLbu8xGj+zNDEddA5FtunPDR9jgM12PI8G+PjNYac/VrMfyuSDgLlgG0gZVLmeujUK9you2sDOx6uOVZ4J0+RWbACbJaUQoL3oZY7x+oeyNB2w3cIDem7l80vzpOgyX9GAfqU/yajXmyH/YnSO3Az9KTCmSZC2T8Y1F1ROrZRvn7Easo6OWkeN4sfdJL03+I0O5SFyEP40Eaws0//NRaoQPgxtmrtKPYCBFEwjeKSY4JYZ1DCTj6IUKJXrC3SRy339f5IEWXmvUOQutoWvHSxpM7VHuQ2v5sW9BPyjc3vol2YggcHqrPsxPNKrPKH/tpoI0Q62V03jEdnJ9yJBloFI6Svplv1XbAbHFOkPYhijWgnymZ9WBPs11d8uGEYKVPISYk3NQhizWGc3INYGvqnkifA58SU+ZM3XOe7CBzk6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hugetlb CMA allocation currently has to cope with CMA areas that span
multiple zones.

Validate the reserved CMA range up front in hugetlb_cma_reserve() so
later hugetlb CMA allocations can assume a zone-consistent area.

Also drop the pfn_valid() check from cma_validate_zones(). mem_section
is not fully initialized at this point, so the check can trigger false
warnings. Keep the sanity check in cma_activate_area() instead.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@suse.de>
---
v2->v3:
- collect Reviewed-by from Oscar Salvador
---
 mm/cma.c         | 3 ++-
 mm/hugetlb_cma.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index a13ce4999b39..31073738f2ac 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -126,7 +126,6 @@ bool cma_validate_zones(struct cma *cma)
 		 * to be in the same zone. Simplify by forcing the entire
 		 * CMA resv range to be in the same zone.
 		 */
-		WARN_ON_ONCE(!pfn_valid(base_pfn));
 		if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count)) {
 			set_bit(CMA_ZONES_INVALID, &cma->flags);
 			return false;
@@ -165,6 +164,8 @@ static void __init cma_activate_area(struct cma *cma)
 			bitmap_set(cmr->bitmap, 0, bitmap_count);
 		}
 
+		WARN_ON_ONCE(!pfn_valid(cmr->base_pfn));
+
 		for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 39344d6c78d8..ce999391cc14 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -231,9 +231,11 @@ void __init hugetlb_cma_reserve(void)
 		res = cma_declare_contiguous_multi(size, gigantic_page_size,
 					HUGETLB_PAGE_ORDER, name,
 					&hugetlb_cma[nid], nid);
-		if (res) {
-			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
+		if (res || !cma_validate_zones(hugetlb_cma[nid])) {
+			pr_warn("hugetlb_cma: %s: err %d, node %d\n",
+				res ? "reservation failed" : "reserved area spans zones",
 				res, nid);
+			hugetlb_cma[nid] = NULL;
 			continue;
 		}
 
-- 
2.54.0


