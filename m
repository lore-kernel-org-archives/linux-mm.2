Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 133C2606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F3f/VwnP
Received: by kanga.kvack.org (Postfix)
	id 3675A6B05B8; Thu,  5 Nov 2026 08:10:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317BD6B05BC; Thu,  5 Nov 2026 08:10:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206676B05BD; Thu,  5 Nov 2026 08:10:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED6036B05B8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:10:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 742ED1C442F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:10:50 +0000 (UTC)
X-FDA: 85401100260.17.3CD6CA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B80741C0010
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:10:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F3f/VwnP";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1iaS7pxTq1YBHZDyspJs0dpXEY7StT0kkQshxwr2aA=;
	b=iumdFqRDfnxhKUzAQ/Xq79zfURdRtYqueJvOEeBZDqG32OfRRIyLOm5c3hff3xOWnIn3Bh
	yPa/Jfk1nZAo+FWmiLB2annZn2LXvqfe4fY6p8stosDHH9zvnJQuwg7J5U1dLXwETUlkLD
	Nqvu1+eX0QDzHcnIDlVteLPnOM3eCLU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884248;
	b=P2016AzilXYY0zu2FeA1nZn4FFzjcv0r+e/BA8MAsK8RQFKyUJfbAhCouRetMJI4FiDvee
	fCCe1IWbAaiSAYUs5CFWwe+yQOWYymxv70VbT2l6wh93QBiz/rTRoPXR9DsHn0+R24hnP6
	qHAXc7WfJ/McEk7nqN0aMnCZ2Op876I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F3f/VwnP";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 564B860F4E;
	Thu,  5 Nov 2026 13:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456FC1F00A15;
	Thu,  5 Nov 2026 13:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793884248;
	bh=R1iaS7pxTq1YBHZDyspJs0dpXEY7StT0kkQshxwr2aA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F3f/VwnPu04LnZzWyr4Ia4UOIe5utTPhGLEtSJh1SqeElGu1gCesnH5rre9xAB+bp
	 QwDwK8WstTrGd28xcMJHGxZKaNcY03hk3IeONTxDsD5dG0cN4w2kTnUAkJztduLBK4
	 PnEDs8EXg4JBG1aBM5oWyLk2ocDTbBQm8/EHMloh6SSkWpwZi+Yv0RKSR89EbFlwY3
	 vWHydrYSXA6VlTp5u3NsVnkOwouQr/+Z86PZt6pQLyyrWs69OgL/8xpke7mKYvAad1
	 sZI2CNXm7TbzH07tw1FlPJ1SoUgV2Mqy9PqGqoOZgSiDDb08Dsx3ne392X4jwr0gIL
	 bNZoy8UNYlGwA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 05 Nov 2026 14:10:11 +0100
Subject: [PATCH 2/5] mm: limit pagecache folio refcount when splicing into
 pipes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-refcount_overflow_stable-v1-2-70b9c655da3e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2550; i=david@kernel.org;
 h=from:subject:message-id; bh=HeWasX6+2Sb8yH40ZbaSQQX7qw4+HNYtLsd9jtSfniY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLeNFiqbmVpubH3yal3z2PnOTmfnbnlyMRdb9R0tUXj4
 593nWIq7ihlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAi1W0Mf3iTuydduqH4dBPr
 4WKrx/1TbI/s+SRkcjUnuGRC55Hjy/4w/A+7c0c98ctFqUM1IVq+DGc8N0ZvDNctjJji62Yk84T
 tODMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B80741C0010
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3fxhb6o8kka35f1qxaoinkacpmite37d
X-Rspam-User: 
X-HE-Tag: 1793884248-924534
X-HE-Meta: U2FsdGVkX182ZdSBDWI9DFww5HiihcaI1Z4qYiH0lS0FBkgcOR6joJp10jgw3Js9QCDU5SLX5Slgb0XblSLGN2vvhqhTcE9BD92SJjs0tqUrRtfI/SZHu4JpPDn5hnD3ClHTIHvhfHW5GckK/Xh2cDz2iM1/Aqp10NNjTgvQK108/21wSb2x5mJRHMdEGpLYq3eOtsLzsjdP/i3RzwoqSrjOPJvWVnXTtwK9kqOdj7kgFDMZA5xC7csNakPg+Jk2cE4zNZvRu5hT8CyVmXOnGbh+i8T4O/hbJRXf74mOThV9Xd5e8jmhtamYUkALmHfdH3WyfTlab54V6WfsvPGfaEd9O5dt8cObSVX9SnfIOrQjcw41nI3WbMPMyCn+fF3CkG2GdBuLRisKY+jMoYt5vXhVO+f+EfTUlx3bfGy/LgQQMjRJOby6kNdTh/FJb1BCgiaxYHZKMKvppVDtH+Bt3sk8f52RbvrfMyu65UBHrSqXlVLEpRR5z6s0vGFbHrlyrTt0dIjcSCp/67eHMLojRA4LlWp6cXzXPdPey7GiL9gsPVQ3YViiFxQk9jeZk1XtG6PxqTZG7qsLGs7w8i3lckyDiByTTzoxgqkxQ4qi81n6GpRuoRTJN3a83v4As/0sKK8vvR1g0iZnTpQpwXNO80qE9xjIFG2bBwYsDYdzlKey3OIwr03FgtRGw+/zc3rSlQ2nccZgQKgJ5Y5UGFWT/gGKJmOoPgtfe+FhNJweBYOIIvkjIvwTn0oF8w2wzcIBjfcCiaS2yrBnE7Z7AWxGfuFP/c9d7YgpGgzqe3GHPnVCpRXUyqPEDeJUvaVCCzoOq8Dvmfc5WI65R4xiWUiqrfvw0Nf1umhYUcrSkCKx/ww0YGTAHOR7qNZlXiE6ypGu9TGlLXGCXX1pGKa3+3Q1p0LowPVdqHQK7daJnfJn5dVdbxBLxPshaELvjwDdubG8DhEWbgIVAL9YNAhuFcs
 Oeu2m7bw
 Cc5xTeXPIfCq0vLrt/DAobp4pPs9jqfV8HcFtQmt7cgrFlvZ1/Am9m5j/LAMASRYLVE0OTA/Hw1mkclpPDhuWMEFT0g00sAX74TbYzC4MvUx1p7w5TQNk0Ioy0QC1xi0NFEQEpYxml1lew0SAJ9bRNwc4WPxRh2URpF0OiJm3IOXfi+PbwpOhyPoE8zmPXa/36Ff0wi4YZi/vVFGUwQ/X1Fzo/7XyoPMf8xF45hBIBwAjyA7Oc2DKtQ0XcEPML+NAaVAiXya6x4uGZ+kaKBS2yvELSDLCSdWvluLP4+jMdecFn69cgNy9rPVPm67II9ovZMkw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Similar to mapping pagecache folios into page tables, let's reject splicing
folios into a pipe if the refcount is at it's limit, similar to how we
handle it during GUP.

This will prevent more cases of possible folio refcount overflows with
large pagecache folios.

Let's keep it simple and check in the two callers of
splice_folio_into_pipe().

Also check in try_get_page() to cover pipe-buffer duplication by tee()
and partial pipe-to-pipe splicing.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h | 9 ++++++---
 mm/filemap.c       | 4 ++++
 mm/shmem.c         | 4 ++++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 79ae8fc0d6bb4..a82cfbce18215 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2287,10 +2287,13 @@ static inline void get_page(struct page *page)
 
 static inline __must_check bool try_get_page(struct page *page)
 {
-	page = compound_head(page);
-	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
+	struct folio *folio = page_folio(page);
+
+	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
 		return false;
-	page_ref_inc(page);
+	if (unlikely(folio_ref_count_over_limit(folio)))
+		return false;
+	folio_ref_inc(folio);
 	return true;
 }
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 920bbf86dfdff..0f2ec790a5b65 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3168,6 +3168,10 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
 			if (writably_mapped)
 				flush_dcache_folio(folio);
 
+			if (unlikely(folio_ref_count_over_limit(folio))) {
+				error = -ENOMEM;
+				goto out;
+			}
 			n = min_t(loff_t, len, isize - *ppos);
 			n = splice_folio_into_pipe(pipe, folio, *ppos, n);
 			if (!n)
diff --git a/mm/shmem.c b/mm/shmem.c
index cda1a0f7db99d..1c0f6bceac486 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3819,6 +3819,10 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 			 * Ok, we have the page, and it's up-to-date, so we can
 			 * now splice it into the pipe.
 			 */
+			if (unlikely(folio_ref_count_over_limit(folio))) {
+				error = -ENOMEM;
+				break;
+			}
 			n = splice_folio_into_pipe(pipe, folio, *ppos, part);
 			folio_put(folio);
 			folio = NULL;

-- 
2.43.0


