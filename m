Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D74606EE81
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mVrw6HHV
Received: by kanga.kvack.org (Postfix)
	id 4524D6B05C0; Thu,  5 Nov 2026 08:11:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4035D6B05C1; Thu,  5 Nov 2026 08:11:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1C76B05C2; Thu,  5 Nov 2026 08:11:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDFD26B05C0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:11:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DF6FA813A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:11:10 +0000 (UTC)
X-FDA: 85401101100.25.5122CCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C79E3100006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:11:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVrw6HHV;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCJIKkyLRcnhroO1aaONY++L92KXRYW5XDFDK8Wryfs=;
	b=r+7DE5L0MvlIg9EE1lZ/+WteCX64aEloDa4THwa1I2uz65cdTXpmx7SJh2wRZy2UHHDvBq
	uXz82N1Rjp//7HzXC2dFFC1RyEMVGYxPjlKHV3fNzwEZ/99hbwJtwomLFZYNVGQ6hoYY17
	XwGaCZs+vrEmbqkrJ2Ne/WP/1QiTP4A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884268;
	b=ryN60OCOJs2dudMKpPfL5SfBBvnZAMhm7/JZLsdIzBgLHNw2jkdQrULGFL/lTWvufUHWzB
	rHpOKU1iPu/upXUVPGvtf+dnjFh18Hzg0qKW3qyLux0vd5e0GI8Nj/ra7q15m+t//0vR9h
	S6VuKZpEBSHm7nNqqV0TWVEKWjy1N1Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVrw6HHV;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21140411DD;
	Thu,  5 Nov 2026 13:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390651F000C1;
	Thu,  5 Nov 2026 13:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793884268;
	bh=KCJIKkyLRcnhroO1aaONY++L92KXRYW5XDFDK8Wryfs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mVrw6HHV+bupF80pNKlnzcHxZw7ocqJUw/vupnR9C6ML8QwB2ebc8FIKYBQGXMg03
	 AmLAafGsgoET5s5J7aC2Uhm9bA1+jRFQXsPZbz0ViqK426+QPJab6y/dIiuiPtzkBW
	 qwU5R30Xe6wdVFOjA3awVfFYZZg040ThA3bZhNUI+yzPM07XXLKG7a+6eJEiqaUEe5
	 HlpkZHYAeQwU9q7oMs0L0FbS5ekVtDfvcU32wh2CP20ffvo0b9SSJXzbsefbmSrWKX
	 7Kxb8btNKdCjJozD1GqxSDedQ4ioKKWr05D5rzTQfPKB6PnB/ILLTuIhZyBnOicXuz
	 hF0wsoc9x7VuA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 05 Nov 2026 14:10:13 +0100
Subject: [PATCH 4/5] iommufd: fix cleanup when adding memfd folio pins
 fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-refcount_overflow_stable-v1-4-70b9c655da3e@kernel.org>
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
In-Reply-To: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Song Liu <songliubraving@fb.com>, 
 Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>, 
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, 
 Steve Sistare <steven.sistare@oracle.com>, 
 John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3513; i=david@kernel.org;
 h=from:subject:message-id; bh=xhwhJlBPehyF74AdW/XvbNaMmG2B0qFeGlvJE2A5afE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLeNFiGOoi/Tqjd2rLuo3LI1uLV80+ylDX63QtS+rj86
 OueK6VRHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExE6DbDfz/rnLXTG9YuvdW2
 v51td9KxD6+qG2787ev49NvQfrud2EmG//4fPNv0dn6R3P9i937u91PqfXfvuqq7qbV7yhZB1rP
 durwA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: omx67xx1yyo954qgnzfjrr37ji64fa39
X-Rspamd-Queue-Id: C79E3100006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793884268-656502
X-HE-Meta: U2FsdGVkX1/dW5yvS0rQdW/QWqAB3FGOT1byZGpatABvGM1zNcFUv/BQi311Xq4nJiZmwRxgWujjpd+zgAba5qEBtWvbtEPb2IqTeqMfNFviegFXaGY0bOVWG/3ufGCMwdWsdRh0ZUke9bmzpMIbXqW9RsN/4k57JcpZTGlropEjxUXoFoGVRgXUV7F93CdVyUc1ZwUJ7i64l5AcHarup+tNvDcXlePyV2W9r73UOHlPnJqpGgObdn3G6c3/WYyn/XPR44hE3dZdzLRUw0y3yZFicm/cEnW+NAxzGfQM2ZmxAG3ne7d7uzWsD8W0PpG++2e3aQShLw1u1Hyr2U37oWwi3j4GGa50vq9OdZ01TI1GYBkZR0l3JPKe/lahNfUjwX3EioW1Yql204d8rOtdBigQQxSFO0npPmybRXKXPYo6j37wfIihRtT2J/0MobJ5zmjdnBVVCtY06OkCa+C+U48UxdMJgdIX1LckU0U1dnZnmrQQIEogKEMtM1MxIQTZBfii5gz2iiQKI7LOzVXmyASOGn2WdM3T9MCGkbdrtE+zR8W7FNv0phUHBeORYJgWTLkMrgBIvsYt1zTgypLIMtsBLisHXVmims4PNY0YhM/pO/1+eE57gzg1wWvQimIeT3sMeXyFBJpVBZ+uLDFpQgyKSvUm0KP1U38aWI9Z249UuEcd1xo1z6E5xzA1pro/F4/lXI/D/QWrcWa5Ddr0VO6tXJ6gHPckfTZAuh5ZAgpPQODWV0A+s7ju32hZy35wKPnlkJRdCOLhKvBaDdGSkzc8bmTc5O/mdgaTRN1hcOEmuNe/6PbyWlx+UF29Fah33Wv1jbDqSpDOyTMcvtwzCSve2OZgPJFn3soo/CBfzS9n+hdhReBFwlTEySffBsSeV20vTS07PtN0+pqVO1Is1HdNMbIURk/R7ExP/WG53//20neVQzh0xJRL5yDEwIfzIGl1MnAr5bJPkeJoK0L
 ehErbzgn
 S05QmQ7b5pDLAhmy55i4LvfkUXQq3/QXe5tJbvYo9WCd5WoQxO2By9Zd+INNmpiLS+9KisAwxO/E9ts6u+twUJDc2VT7CpqizgSjIw3VpYwl1eISub6G5vAZP3Mdo/c+qY3eU/wpAcao2EziqH92O/lrrso8LLKvBSRR09643rssqLEh5PwgSzWYEROUIx3oRODLEmAaPSK0jfsnqqj707nUEZYm/ew6Glm8QNe0+6b2adlQ+4MQfEuskS695ZLawrPK/EwjF3SLyjtsYWR4L+LYmyimhOvsXirMDGP8FQpM9fQHpJRVlWzjJKu5DY1T3lmBP3TNgqPr+TioM7SiI8jdYzGd+Yo6+AxFO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

folio_add_pins() can fail after memfd_pin_folios() succeeded pinning a
folio. Upcoming folio refcount limit checks will make this easier to
trigger.

Let's fix three problems in the error handling:

1. pfn_reader_release_pins() uses the allocated array size instead of the
   number of folios returned by memfd_pin_folios(). With large folios,
   cleanup can unpin uninitialized entries. Remember the number of returned
   folios and use that during cleanup.

2. pin_memfd_pages() returns on failure without releasing the pins acquired
   by the current call. Release the per-page pins for folios already
   expanded into the page array, and the single pins for the remaining
   folios.

3. pfn_reader_next() returns on failure before updating batch_end_index,
   even if the batch already contains successfully expanded folios. Update
   it before propagating the error so cleanup releases those pins as well.

Fixes: 92687c793644 ("iommufd: pfn_reader for file mappings")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 drivers/iommu/iommufd/pages.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 2f6153108add7..fcdbde007a9ab 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -781,6 +781,7 @@ struct pfn_reader_user {
 	struct file *file;
 	struct folio **ufolios;
 	size_t ufolios_len;
+	unsigned long ufolios_count;
 	unsigned long ufolios_offset;
 	struct folio **ufolios_next;
 };
@@ -800,6 +801,7 @@ static void pfn_reader_user_init(struct pfn_reader_user *user,
 	user->file = (pages->type == IOPT_ADDRESS_FILE) ? pages->file : NULL;
 	user->ufolios = NULL;
 	user->ufolios_len = 0;
+	user->ufolios_count = 0;
 	user->ufolios_next = NULL;
 	user->ufolios_offset = 0;
 }
@@ -843,6 +845,7 @@ static long pin_memfd_pages(struct pfn_reader_user *user, unsigned long start,
 
 	offset >>= PAGE_SHIFT;
 	user->ufolios_next = user->ufolios;
+	user->ufolios_count = nfolios;
 	user->ufolios_offset = offset;
 
 	for (i = 0; i < nfolios; i++) {
@@ -859,8 +862,12 @@ static long pin_memfd_pages(struct pfn_reader_user *user, unsigned long start,
 			} else {
 				int rc = folio_add_pins(folio, npin - 1);
 
-				if (rc)
+				if (rc) {
+					unpin_user_pages(user->upages,
+							 upages - user->upages);
+					unpin_folios(user->ufolios + i, nfolios - i);
 					return rc;
+				}
 
 				while (npin--)
 					*upages++ = folio_page(folio, offset++);
@@ -1251,14 +1258,14 @@ static int pfn_reader_next(struct pfn_reader *pfns)
 			return -EINVAL;
 
 		rc = pfn_reader_fill_span(pfns);
+		pfns->batch_end_index = pfns->batch_start_index +
+					pfns->batch.total_pfns;
 		if (rc)
 			return rc;
 
 		if (WARN_ON(!pfns->batch.total_pfns))
 			return -EINVAL;
 
-		pfns->batch_end_index =
-			pfns->batch_start_index + pfns->batch.total_pfns;
 		if (pfns->batch_end_index == pfns->span.last_used + 1)
 			interval_tree_double_span_iter_next(&pfns->span);
 
@@ -1320,7 +1327,7 @@ static void pfn_reader_release_pins(struct pfn_reader *pfns)
 		if (!user->file) {
 			unpin_user_pages(user->upages + start_index, npages);
 		} else {
-			long n = user->ufolios_len / sizeof(*user->ufolios);
+			const unsigned long n = user->ufolios_count;
 
 			unpin_folios(user->ufolios_next,
 				     user->ufolios + n - user->ufolios_next);

-- 
2.43.0


