Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60AC0CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66766B00A4; Mon,  8 Jun 2026 04:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16336B00A7; Mon,  8 Jun 2026 04:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5FC6B00A4; Mon,  8 Jun 2026 04:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 984996B00A4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:35:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F6051C1FF0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:35:51 +0000 (UTC)
X-FDA: 84856087302.21.4700FA1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 05C3AA0012
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:35:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hpeYwwGc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OcVo+/Lds4YxddLi3UfNSteOvi0JEMISiAqD3/N1YSI=;
	b=5Iq1yPadT/ZKx2RCnsLD2sPoEN7jQ6nk4fCilJRle8tS1ork2dWcF3OuY5ExTdBx+gvDCx
	NBdJ4HZoZF3vIGqumaDc8KCgpTAF4DGfL3lIogKF5qxBiZ2E1Wj3XogZQ9SzVDIzmPLyoL
	WDU2mcZvOKG+xfFqRBAo39ZlL8kZBpk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hpeYwwGc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907749;
	b=ojTtDcJjAvEH8WFbmFB/tfLR0ibqrqUh5MA1OCR3QNTQxCMtd7Fut7ggnnk/Qg3bULb9ZK
	eywx7q59ymq0TJqQx4Eqx6wgwOEcNMVMjW7pigPnGnvX3TzKl9Y9sN1UzqNpinnQYm7BBo
	BFnMKJI8KS/cjhXarRVwhOS3t0pJmss=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OcVo+/Lds4YxddLi3UfNSteOvi0JEMISiAqD3/N1YSI=;
	b=hpeYwwGc9ConMo6FOonUN3q8Il2cDluC4hjMzTcBfXuewJ1dalKg8zrnc5ZmlTYfggyStA
	/bICoJc6DqctO+LaThqo/gXcAE6XbaRdfUjOvNprwSbXSuCPcNilGcrwgIAOup54oTG0e5
	u1cfnou7AzgLAvh/tB0OimEEBf5wLmE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-t4FXEHm1MFK0CWlvylKHLQ-1; Mon, 08 Jun 2026 04:35:46 -0400
X-MC-Unique: t4FXEHm1MFK0CWlvylKHLQ-1
X-Mimecast-MFC-AGG-ID: t4FXEHm1MFK0CWlvylKHLQ_1780907745
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4601102c30dso2289204f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:35:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907745; x=1781512545;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OcVo+/Lds4YxddLi3UfNSteOvi0JEMISiAqD3/N1YSI=;
        b=c/vzfG/B2fvT4FVcA9M1hNTBzpN5FemeLFCdDVM0Y2fZXmQxMz+YdOXyYhaINlVgeQ
         uKmvZIDANDOudBSNV2xM7o932T2HKPM34B3fwoeyudj3aXNbRqL6xJGs2OrqqhBBupWw
         APRZ//uys6Bug4Cdv2+XwdSwAVsYXVHXoAgYtdz47DaB8wKmyTdDmQ8GaLF+uvYopcj2
         Bv7aqIkyKz4qwPdoJvhR2NDVA2sdQZtrXvY2f8Kj2zHmhRlouRD127i88bnRuylTcWlb
         SvhFG10CFpi6h7Zq5A3tff6tVcsrfIv2H/QVbDqd6v2GlI7ylMgwwUUvL2UD7ISj7UtQ
         g73w==
X-Forwarded-Encrypted: i=1; AFNElJ+hhI5JEQD83rqPuP0+sNV+FgVmnDQrmepEgG12wJmK3yqPdJt5I7/amaCNen9v0Jq1OQ29UjTtcw==@kvack.org
X-Gm-Message-State: AOJu0YwRVACUlVfM6A88Xr7mb+iF5PN6MD3ke53JW9m8N3XA2pOSbxg6
	FK73HuVuzYkZl4kFkg1fmx0YJ5SajkJYy6ote5zxcb7YJ4V4eXKzmgRK+VznwrMOt19lqzKrMds
	QCgXlP7Y0XmF3ezLbzOfz1UcS7oXYWh1CJjCFttGzp/KDu2AwmO4+
X-Gm-Gg: Acq92OEXlig8oMdXzlditfNNcQa7Oo7PuQfFoXmEkrQwC4k7a3349MfauMQb8cs4Ahz
	aSjc9X0PvHdcmndm/vqqHncvn5mxf78BvHd1oCKwmKu/Q7ByUu95rgs5ba9V74htM/W/mrIrK47
	ODwRaJGjw3i89D/d/ZgRSFaWe9huPk+7DPwypU7mlqfIKiwEsys813H/6t7B2l5gImXJavHQlB7
	g25/kG9QeUbEea3f4NvgqvK76UNLE5BZhlFqusu5ufIvgj4pxp7B+a4yPxVDyvdxkPVO9xXAhcs
	NqBusDORusathtKwVA+1Bo25jmURLqmxp5LYjSHKdOflj4I/FoPDfaJNXCnHz0ZD4x1Z6Ebvpmw
	SUPgMrNviEkoupi7UKUObxfY=
X-Received: by 2002:a05:600c:e548:10b0:490:cf76:dea4 with SMTP id 5b1f17b1804b1-490cf76dec2mr27271175e9.2.1780907744715;
        Mon, 08 Jun 2026 01:35:44 -0700 (PDT)
X-Received: by 2002:a05:600c:e548:10b0:490:cf76:dea4 with SMTP id 5b1f17b1804b1-490cf76dec2mr27270255e9.2.1780907744100;
        Mon, 08 Jun 2026 01:35:44 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dc577sm50742305f8f.3.2026.06.08.01.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:35:43 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:35:29 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v10 08/37] mm: add alloc_contig_frozen_pages_user for
 cache-friendly zeroing
Message-ID: <f2036f596f17f66fb55b74a5fd85e8b7ab51876d.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l7Ek2SEzkMSPF4zUA1bp9Ki71w0DVF-eSt3Lsmwwo5o_1780907745
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 05C3AA0012
X-Rspam-User: 
X-Stat-Signature: i3yqasnyfxeiyns3wh3smrzxikt6dopd
X-Rspamd-Server: rspam09
X-HE-Tag: 1780907748-833755
X-HE-Meta: U2FsdGVkX19bjXhL9h6hw+GzCCFFm6/TYWxDsmmt7zEKhifAyMw9mZ6xTuJ7AOUHSjOnoqM7G9YFq01nOJBpKH6SF/YXWtxsofxOdCKV5RUjmvefGM23km0SgEThvVnjRW7yvzW8kgKwABc0hSjWEP/idh+LM+CTXVTboWYCFxp/PbWHcPOwFa7l+TfuY3yZ4y/QaYffdKESm287kaKPkfrcJ6AP+zxF27QvNJozUmBwRW/F7xcwXDs6P0awx0xU039RTlFRemVUlEl9rxhjaeHzwHCkCNgEmATnI97XoFnQDiOY97BqHEIoDcSydnPGBaLpg4XE8fBkHB5/4fUt3rv5Fvs01DD3VpWeKo5W000bKBDBmtytdCk6IH+aL4jB8WODswhH2QaBc6Sp54nr/kaUy8b3hnmLt8rJfyHk3NxwbHB03kbUFzs15fADIhnqr/Fgkr0rxOcviYDXEEE6xUgf79p+RI6cLp85JDFxTaiew0y+VbOLN2FNvHSZGAhX8O0qpQQo11PJvospypdDWe/tIhP4LMMLsEMPtfdzX6k8R5DivTykCkoqbGBmz1OudiXB2DK18QdRs8AZFHCHZDLuos6fHtxYNl8/4kRcRvjkV4v3Oi55J13OqsRhDL65Jr+3ZX2cE2c29ebXwachGz03myky2UQ93zHziN6NY/KgIpqj5zM5JdWiYxc6azrdGRd211gOr1M2dwH1t5Z8v3mAEWdTVnCyBvsuPboA/Z3/u4b7LgErCR+bg421X8D2KbSXzYAtCRLPkt2a9MTy+P5vzKy1aM/jLhB3SIaXuhlgLQWKCcOPuVtM5ULq3bMf+zc2UjrR+A8Zsq1VTW+rDZGdhY7NowvwDGVPFuzkZzIqEeLC6KkPrPFhaecwSlS4D5ZZJEnC82y/3XEUEjrSVMvvGQudqNE+PBSdSU8IVSfDXbkJv2hDHwEaMk8O9kjp7tQC788w7FIuv4kGE2L
 0Zu7yEcJ
 e7/jPdrAA29GhrGmEMU2cS22ibitYaGy2htXFXw5AGlTU6aY2VsR5k9Cac6q+Fgls/+qTLckFvd5nVAPtsr8xY06zlTwOD08RIGPTqWk9NEasH4ewY7tlCFQWz6jxaVDRpBw7duUt5fy5iA+lgH21NaYwepjQZKk3BINhIUXKdVFrer8mm986rJV5O3Walq7tEuVw371tCaT9bAWhIqW5CDtn34eEArIHxm2Pe/ZXcBWczjWT8HmRIQ389CJ8dQkRERWfm3MinhasvzK0MQ01R6cspue2ipLKoMLwo9oKX1ls1ySE+e/du9MUgPn/yZqbXD3tTElBuV6asXh30DYcsNEp8owWgSAWJIubUJRi+CP8nFmPGpXcQvT3auvbOYSyEQTOBKIyUL5285Cya+PloewLNyGCbe49vtk+NySwojECXxpCJsLgeuV7Dw/NuTWjPPKF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a _user variant of alloc_contig_frozen_pages that accepts a user_addr
parameter for cache-friendly zeroing of contiguous allocations.

No functional change; all existing callers continue to pass
USER_ADDR_NONE.

Note for reviewers: non-compound contiguous allocations are
zeroed via kernel_init_pages, same as before this patch.
There is no fault address because these allocations are not
from the page fault path. For compound allocations, user_addr
reaches post_alloc_hook() which calls folio_zero_user() with
the dcache flush on cache-aliasing architectures.

Note about Sashiko (sashiko.dev) false positives: sashiko
flags two issues here: (1) user_addr silently ignored for
non-compound allocations, and (2) post_alloc_hook ignores
user_addr. Both are false positives: (1) non-compound
contiguous allocations have no fault address to pass, and
(2) post_alloc_hook does use user_addr when it is not
USER_ADDR_NONE.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/gfp.h |  6 ++++++
 mm/page_alloc.c     | 42 ++++++++++++++++++++++++++++++++----------
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index ee35c5367abc..73109d4e31a4 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -453,6 +453,12 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 #define alloc_contig_frozen_pages(...) \
 	alloc_hooks(alloc_contig_frozen_pages_noprof(__VA_ARGS__))
 
+struct page *alloc_contig_frozen_pages_user_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask,
+		unsigned long user_addr);
+#define alloc_contig_frozen_pages_user(...) \
+	alloc_hooks(alloc_contig_frozen_pages_user_noprof(__VA_ARGS__))
+
 struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask);
 #define alloc_contig_pages(...)	\
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 21b52c879751..6d3f284c607d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6975,13 +6975,15 @@ static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages
 }
 
 /**
- * alloc_contig_frozen_range() -- tries to allocate given range of frozen pages
+ * __alloc_contig_frozen_range() -- tries to allocate given range of frozen pages
  * @start:	start PFN to allocate
  * @end:	one-past-the-last PFN to allocate
  * @alloc_flags:	allocation information
  * @gfp_mask:	GFP mask. Node/zone/placement hints are ignored; only some
  *		action and reclaim modifiers are supported. Reclaim modifiers
  *		control allocation behavior during compaction/migration/reclaim.
+ * @user_addr:	user virtual address for cache-friendly zeroing, or
+ *		USER_ADDR_NONE for kernel allocations.
  *
  * The PFN range does not have to be pageblock aligned. The PFN range must
  * belong to a single zone.
@@ -6997,8 +6999,9 @@ static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages
  *
  * Return: zero on success or negative error code.
  */
-int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
-		acr_flags_t alloc_flags, gfp_t gfp_mask)
+static int __alloc_contig_frozen_range(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask,
+		unsigned long user_addr)
 {
 	const unsigned int order = ilog2(end - start);
 	unsigned long outer_start, outer_end;
@@ -7125,7 +7128,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0, USER_ADDR_NONE);
+		prep_new_page(head, order, gfp_mask, 0, user_addr);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
@@ -7135,6 +7138,13 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	undo_isolate_page_range(start, end);
 	return ret;
 }
+
+int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask)
+{
+	return __alloc_contig_frozen_range(start, end, alloc_flags, gfp_mask,
+					   USER_ADDR_NONE);
+}
 EXPORT_SYMBOL(alloc_contig_frozen_range_noprof);
 
 /**
@@ -7227,14 +7237,16 @@ static bool zone_spans_last_pfn(const struct zone *zone,
 	return zone_spans_pfn(zone, last_pfn);
 }
 
-/**
- * alloc_contig_frozen_pages() -- tries to find and allocate contiguous range of frozen pages
+/*
+ * alloc_contig_frozen_pages_user_noprof() -- allocate contiguous frozen pages with user address
  * @nr_pages:	Number of contiguous pages to allocate
  * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
  *		action and reclaim modifiers are supported. Reclaim modifiers
  *		control allocation behavior during compaction/migration/reclaim.
  * @nid:	Target node
  * @nodemask:	Mask for other possible nodes
+ * @user_addr:	user virtual address for cache-friendly zeroing, or
+ *		USER_ADDR_NONE for kernel allocations.
  *
  * This routine is a wrapper around alloc_contig_frozen_range(). It scans over
  * zones on an applicable zonelist to find a contiguous pfn range which can then
@@ -7253,8 +7265,9 @@ static bool zone_spans_last_pfn(const struct zone *zone,
  *
  * Return: pointer to contiguous frozen pages on success, or NULL if not successful.
  */
-struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
-		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
+struct page *alloc_contig_frozen_pages_user_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask,
+		unsigned long user_addr)
 {
 	unsigned long ret, pfn, flags;
 	struct zonelist *zonelist;
@@ -7282,10 +7295,11 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 				 * win the race and cause allocation to fail.
 				 */
 				spin_unlock_irqrestore(&zone->lock, flags);
-				ret = alloc_contig_frozen_range_noprof(pfn,
+				ret = __alloc_contig_frozen_range(pfn,
 							pfn + nr_pages,
 							ACR_FLAGS_NONE,
-							gfp_mask);
+							gfp_mask,
+							user_addr);
 				if (!ret)
 					return pfn_to_page(pfn);
 				spin_lock_irqsave(&zone->lock, flags);
@@ -7307,6 +7321,14 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(alloc_contig_frozen_pages_user_noprof);
+
+struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
+{
+	return alloc_contig_frozen_pages_user_noprof(nr_pages, gfp_mask, nid,
+						     nodemask, USER_ADDR_NONE);
+}
 EXPORT_SYMBOL(alloc_contig_frozen_pages_noprof);
 
 /**
-- 
MST


