Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1719606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=kGkGZjGk
Received: by kanga.kvack.org (Postfix)
	id A18346B05C1; Fri,  6 Nov 2026 21:30:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF8B6B05C2; Fri,  6 Nov 2026 21:30:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C756B05C3; Fri,  6 Nov 2026 21:30:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F46E6B05C1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:30:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30CB514029B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:30:11 +0000 (UTC)
X-FDA: 85406743422.10.1D68E96
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5B85FA0003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:30:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kGkGZjGk;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rk2LQoLYWw0mFOLNx1z1W3nO6yp8GrtwTIj/Q1DWuIQ=;
	b=Hbqu8XVclAR4W5LW2qJqEaSmfohfKJZLkaZ8WUnIO8JZaIFy+WITgbaJHoCzGxgcOyfdj0
	UZx75E/YgNUjj4CPRgOmdQnMp98zhGHDPL18FYSneWQdoeXu0a+TY9zwTj/1C74vAGyBkq
	5PG4Kp5z0+aWASxHQ8zi09WuHl0EfFY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kGkGZjGk;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018609;
	b=08HsfxJMMVeEP53B2yKXvHjVyuj9V+9c5OtwF9NzL+8F6CdxWPsgIS8yxyPi69hk1oXp/D
	+bE3pyiPa4aiwosRo1EGAfLDRJu7pgJ6VraipnMovRI/l6dz1lT4JU/rrIhEgHiE690tFj
	2uZTmP0xiIwxZF/U5wM5Fs/xiwATcSw=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3282db206d3so2683704eec.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018608; x=1794623408; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rk2LQoLYWw0mFOLNx1z1W3nO6yp8GrtwTIj/Q1DWuIQ=;
        b=kGkGZjGkgPZoUHMk/sKfMAzJnvvDPi8JzuLAKqBbfvzE8ZVfD8U1x4fUIHpBObw/n3
         mrvKEhvddzw86A17xBwUVwWZYTm86tpYD/h3bdfAKsvIcTmgmHjH9Yd8SV8svg5gHX0E
         q7FRHjPggwoDUQ9eHhYP93AE4bkiTDw6KyjllOxua3XHv2ZopkCYpTlmrpuRHhnB6RhN
         I0TOf5+CnnpDfbtU2LDJHjoePv8L0PZQCd5jrlUC2CNzvDKg6sO5PYKQUAnzIb+AQGbt
         LH8kVzJa0Hs4boCppcgfs/XykEfS4XPxGxPeDx/NGMlZO463RvSXOImNkHOsPCc3tETX
         sMtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018608; x=1794623408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rk2LQoLYWw0mFOLNx1z1W3nO6yp8GrtwTIj/Q1DWuIQ=;
        b=aI5ae3C9ibDKWvBIohZzXOGaqF20G5IDsyezzXy33A3g6DNzdstUsmXoEmKNIF9ZOz
         5IpoBoi+cBepM1YGbMEFZdMthJvZ/2hVOQ3DPWmJqQz0tGli4swizAs7Mqd98j5DguPq
         XfJR+USVYOZF/95ZgiPpGHK2ooq18PPmtivFn3S/nwwgfstJSvfSJCM9vSkcln46yIXA
         mC7ND3/0d74Ipl7f95e8Gqyxpkf19uDwFQZ3CoNFhGw8PNcyYvpQB9RE1/nRC7/7Xj5x
         IXe81qQDwR91lmO8WFbNRmLprbunavGQcoE+BXlkgQKoYmagz2tpTAeyex+veISZSm3n
         jo0w==
X-Forwarded-Encrypted: i=1; AL+hErFlGHE+u0WrNnKWNjvdCdmW/MHG2SmCDsv6jW6IlGBWoLOt4r5eW6Kk5eDHC6279AVmMJtdQivRiQ==@kvack.org
X-Gm-Message-State: APuU4Z+lE89inW08Ryfq9OqlpeTlR5jK2WuYw0z44hTv3jZDSRFy4vdb
	bPI2q/rhPtynDiM83Uff/gsxZEUXmP/pM7lWlJref+oDXhPWL4XlehuXC0J53aFPlkg=
X-Gm-Gg: AYBFou21sIdo/QCv8cxPSpXY6qMmJ0Ha6sW6fnvuRLwoxOV/2QMgyUnR/oOygEVlRPl
	YV++wnB1pikyc7GrO8SPlbROxWaF80uhEjpOmddNX1rYm/J8XlG+l9Qd5gQSUKLYmKXko1miyvl
	yiSgndCd/tk79NtkP15R6o9KTqmjewz31IOqdwTnE1a+n1D6/2aMe9x9tf+CBRSP8Du12nLnONb
	rwu9dJwSzap/yDe3dtWItpmhfXqFVcjXwmyrfSSHustRruMsc2j1AuB78EoBMZtzWxSL6Bp6j3N
	165/ihYHQfb7Fr39pRDu17QelW1Mh/PynHnzOfeGl+qaIZQr+4z5vj3MtJaWQZOyC7TSMOoiMEX
	T2xG5WJkiEDsL4LrG4/I1c7ATIcG1IE5982hpByMRMgHM4VeTWI0KOyMGY5Ge7KEm+KjxCouI3D
	7rawkVgMIiua9HHhU61kAoEdGUu/wk2Qx2tWSUWJa7JyolWVXR9dbG6L/h/gFEbN+9Hfn20b8kC
	RDHLoDKbM3B8CDGWRXOPRvnja9RHHpnkWl0aDsUk96XK37YE16JxgP/FP/5vAaTdhI9Z4cgiSo5
	gz2xlffIlUaQ61RWMZWJe/wzIFS35SKzQ5O9REl09cXxGK85SMKeKBjUulBU
X-Received: by 2002:a05:7300:dd06:b0:36d:b933:675c with SMTP id 5a478bee46e88-36f75b1f6b4mr6307886eec.17.1794018607721;
        Fri, 06 Nov 2026 18:30:07 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.30.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:30:07 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 10/13] mm: hugetlb_vmemmap: make vmemmap optimization folio-oriented
Date: Sat,  7 Nov 2026 10:27:53 +0800
Message-ID: <20261107022756.77731-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ins1a7wztztxccpkru9twnabm3rcxaw7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5B85FA0003
X-HE-Tag: 1794018609-820579
X-HE-Meta: U2FsdGVkX19fmDJq6Yiw7OINvKqym8Tj3bdvYGcgvzvxCRzwRIUEXo1zAVLP9XYV58rUYqoDNNBSe7RiBf5aIBDoAC4eGQHx85VFUKLfX2fa3dYeYhDeJSDVX3ZpGaKx2xNc5ERjmqO9BkhOW2I5xttt0nY7agIFIXgQWXFZ0tZTUGSqgm0aA1CLTOx9V+Q4ZJpLMQTDLKptGloEIhPpTLxjyg0lSGTbCg8JvgiPvADIE0nHhWNoX7KIQztsWHWU8bHlZESQDqlRmuuaOAQcZozDihZu1kzKaua3vXVbCYa/TgAptjY3Jhz2En4y22sq8h4Swx6BrLw5okP5RwykSrUUZMDAlPZKt6jMLFhw/Zxg8lY3as828BNAKFksve7Wh3fM/UZJxYtha/63iNFUeoCILHpw0A4ATzGiJJ6Z2PmViceB/jbjznfgKDMxtrcNWhxuhWyStWqAOfUxDs9ki2kIM+5UJmYFYVoyRBNLZSBdCZSP4472Dx0ZNq2dXbjEtKUrnMX6PXP4fOzbh2FZIOY7+9/Q5vs8hkD9agrHQAkOBDMKnjtUIJaHbBSgKU8m9KqsSPI/luFqcevXnUZ4rXl8M7xpgoBTKQJ5mXNsW6dX29UUWTWWmyr2eFPcccKLAdFErXhEO+/cHi3DVpPubnIGJKq21nWJEHW6qUY/zXuy9/6yiJ1iB1DxjUKSTdw9GRVcfGz0He7tbS6TQNOQr9ZESBctoo6Bcz+1UzWX29CtK/Lr4JECx8EMmWjDu1GQpU0c6VZgCYrItqEtzC7TPlLeOTqLF2VDH1MtKFN77w0YHAW5TfW7bAHPFLlTt+VefjY9Rjam5IRlx68yGjsZ3gZex+MhV6H0/oRGk454OkHUKun9PROau2B94hUR+pvdwDP8XJVKkwCaVKEW0QRwcYRZocgV2Qai9tyzEnvRPDJcMgVhJObxA/5qjf1jeIeKT0qN8Mjz334Gab34HfD
 c5f1xAXk
 9pBo/z8llW52ZpRVjx41qdQAfYYhvyMZ5nOXIs2hr+HFMPFl6k3299ChFEFm1hfR9NKPlvjWG8DcDxGz6BQzY08SJFn9tiHDvf3f2H7erkJpTR7EXuVdYdhIGQKQSQQwMmT19by/H/iok9IfIF8dc3UU+Zo1qfhm3+1vmHadBjyQXSTRs/tUKltBqfpDQzZLtNjYQHSFxF3RuhyAkhcU5Mpt8GD5R35BVPP6i0jHvIXBqJPtoqegxloV591sbfHTMSCEhD6xW5JzalkC8R26P/cpMqMQf4FYbjhGlFP4rcTLiWgrtSbxnjFOb5eLcMK/rnWBspFCvlUom8t/pwlruYvo7Bzjx3ZuU0Fqxs9/jbvon3gg+9e/EYY7I3MH9ub1Cx1ki6nu5MOaPCazJED2OOFrWB7SaSVaS5r79JHYg6OFzcME6E8luz75TbpBLnQt4tedb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Vmemmap optimization operates on one folio at a time, but the current
interface exposes a raw address range and requires the HugeTLB caller to
prepare part of the operation.  This splits the common mechanism across
layers and obscures its natural unit of work.

Make the folio the unit of vmemmap optimization and move the common
mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
eligibility and state in the caller while making the remapping code
applicable to any eligible folio.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
v4:
- Pass the caller-selected allocation mask through
  vmemmap_optimize_folio()
- Collect Reviewed-by from Oscar Salvador
- Collect Tested-by from Andrew Morton

v3:
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 68 +++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 35 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 6c248e8fbdde..148bd27bb327 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -233,6 +233,11 @@ static struct page *vmemmap_dup_page_from_list(const struct page *src,
 	return dst;
 }
 
+static inline unsigned long folio_vmemmap_size(const struct folio *folio)
+{
+	return folio_nr_pages(folio) * sizeof(struct page);
+}
+
 static inline struct page *folio_vmemmap_shared_tail_page(const struct folio *folio)
 {
 	return vmemmap_shared_tail_page(folio_order(folio), folio_zone(folio));
@@ -302,28 +307,42 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
 }
 
 /**
- * vmemmap_remap_free - remap a vmemmap range and collect old backing pages
- * @start:	start address of the vmemmap virtual address range that we want
- *		to remap.
- * @end:	end address of the vmemmap virtual address range that we want to
- *		remap.
- * @vmemmap_pages: input/output list whose first entry supplies the new backing
- *		page for @start; replaced backing pages are added to the list for
- *		the caller to free.
- * @flags:	modifications to vmemmap_remap_walk flags
+ * vmemmap_optimize_folio - optimize the vmemmap backing of a folio
+ * @folio:	folio whose vmemmap pages should be optimized.
+ * @vmemmap_pages: list holding replacement pages for the remap and displaced
+ *		backing pages for the caller to free.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Remap @folio's vmemmap so optimizable entries point at the shared tail page
+ * while non-optimizable entries are copied into replacement pages. Caller is
+ * responsible for freeing the pages left on the @vmemmap_pages list, even on
+ * failure.
  *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_free(unsigned long start, unsigned long end,
+static int vmemmap_optimize_folio(const struct folio *folio,
 		struct list_head *vmemmap_pages, unsigned long flags)
 {
-	int ret;
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
+	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN;
+	int ret, nid = folio_nid(folio);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_optimize_pte,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
 	};
 
+	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
+
+	if (!vmemmap_optimizable_order(folio_order(folio)))
+		return -EOPNOTSUPP;
+
+	ret = alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES,
+				      nid, gfp_mask);
+	if (ret)
+		return ret;
+
 	ret = vmemmap_remap_range(start, end, &walk);
 	if (!ret || !walk.nr_walked)
 		return ret;
@@ -490,17 +509,12 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct list_head *vmemmap_pages,
 					    unsigned long flags)
 {
-	unsigned long vmemmap_start, vmemmap_end;
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN;
-	int nid, ret = 0;
+	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
 
 	if (!vmemmap_should_optimize_folio(h, folio))
-		return ret;
-
-	nid = folio_nid(folio);
+		return 0;
 
 	/*
 	 * Very Subtle
@@ -514,23 +528,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 * the TLB and clear the flag below.
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
-
-	ret = alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES,
-				      nid, gfp_mask);
-	if (ret)
-		goto out;
-
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	/*
-	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end).
-	 * Add pages previously mapping the range to vmemmap_pages list so that
-	 * they can be freed by the caller.
-	 */
-	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
-				 vmemmap_pages, flags);
-out:
+	ret = vmemmap_optimize_folio(folio, vmemmap_pages, flags);
 	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 
-- 
2.54.0


