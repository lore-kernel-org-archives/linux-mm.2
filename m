Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553D1606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ju6Cfz96
Received: by kanga.kvack.org (Postfix)
	id 69A9C6B05C2; Sat,  7 Nov 2026 17:25:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6738A6B05C3; Sat,  7 Nov 2026 17:25:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58AD16B05C4; Sat,  7 Nov 2026 17:25:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31F026B05C2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:25:05 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF9C71A040E
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:25:04 +0000 (UTC)
X-FDA: 85409754528.14.967CB32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id EDE0F1A0007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:25:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ju6Cfz96;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794090303;
	b=QU3afyQ1Kpyp9Y8Nbmb+KNQpASNwbkJHMs3TClWTXTuAV7Vm5QnbhzfEZXYLwzxX2OVHCL
	ijoVfp92IY9t9Lm5EThuv9q8jI8x/Qi0z0mx3pOQuPbMQFQMbRgHnWK4f2Glvj+KYogy+o
	JjaYmwWZjEd95vUdE9iI4HaoZTS7mKA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ju6Cfz96;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794090303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHhzsFK46xamHLjxn99YRGd8ys0XhYnUbLCGMyb//rs=;
	b=sd4CF2fh4TV3aRaszyVhDLrVPcjcWE1msByeA1reCJMeg25haDmHYJgyKMpOiHkVKIPYe8
	1KLcxA8s4OJgK66+ri+A3dLHVFNybYN7Fat5O9gKHID6xVAhwdMhRCiEAx0L7xqrmG7RuN
	PQzFR3GjB8ANt5tPZQZZgusxrvpyyJM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6300561265;
	Sat,  7 Nov 2026 22:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB901F008A1;
	Sat,  7 Nov 2026 22:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794090302;
	bh=pHhzsFK46xamHLjxn99YRGd8ys0XhYnUbLCGMyb//rs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ju6Cfz960666XG0yk6b/gqWUfTYFPewkV84zF0+CiI6bHhEhgdSqF+x9V55sa4yrD
	 P8vI64/cOlDJ8RkSsq6dPjKek/Ywv7qDM0to8D8N2TlPLfYAiaeqRU3ygvS8fFNzW0
	 qcTQOlqQLVfLWhOxezpaaFBCmaLbjjCpvynfNXTz0gnEJUSOEgjRmkMt9fkFM6F3tl
	 VVSx46jVnCDPGXao4tWJh/skNSlPw2a4bikZ2UpqJJNMOTXeCQm1pQqdwuGsnJ9i3g
	 26F2C/HSmE4JxmGcGSJXwM4K6RcTQ+dJwP+iIOXHVEOiN2wgDA/sINnzqBI+g4eSXl
	 jVciwuVDKOX5A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 07 Nov 2026 23:23:40 +0100
Subject: [PATCH v2 4/5] iommufd: fix cleanup when adding memfd folio pins
 fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-refcount_overflow_stable-v2-4-c38f6809b106@kernel.org>
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
In-Reply-To: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Song Liu <songliubraving@fb.com>, 
 Rik van Riel <riel@surriel.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, 
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Steve Sistare <steven.sistare@oracle.com>, 
 John Hubbard <jhubbard@nvidia.com>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Josef Bacik <josef@toxicpanda.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, stable@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3608; i=david@kernel.org;
 h=from:subject:message-id; bh=fau3pBzKpQXLjgKtqqi0yzExsXgD+rlECuO7Pn/e1yI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLeL2W0bHadVfTlfHZP64PqGzeK3Teah+fH6VZ+cpw0a
 8b3bK2FHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEykZDkjw1KTmIgAwY894ov6
 fFjzPUWdLKuu84grbV43U35iHm+dN8Mf7jCua4Zxe5lMu1PvLr2yifeOxIUA3UXyWnqt+rHOG/O
 5AA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: rnm79ne67gcqn51p4w3wjdzdcc7kxppj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EDE0F1A0007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794090302-337020
X-HE-Meta: U2FsdGVkX1+Pjrp5U2IN0X3iIyG9B6ziahPA6Bemjg4a80hpOoeoxtx0QcYTwo0E4enkkbU4RFD02SKjb3PYbFT414dXckA97VSp/aaRMZapEcDEhMglHZl8v3aGBpmsrqRf3gTOdKQ/5VaOTTvkTxFar72efLOohcK0mn4DoKSfkjiTVwUWAVYpe0YWPY7T4zKxWrh6RTmFuZr8fhiO7N2X6vQlQb0TeJPUjVtVDYONdIq9VZSyXXsR7ooHAUjpkWXCd55hEcb6gOFjQNWBH6JQHsLxRcNFpBX4Sg1+WlGuEXA9NiNr9sgnuEtBcj6O0jjH2KGR86njbPFe3zRO0V1kv+ycTxJDwh+tJ3lG8dis5Ro8AtHuU1AOYc7e9sBu+y4VgRpE/d+v5avWnvLpR3Q0HfyTUPqSsTvXDR4Rw/VotCKn8LT6eg3RJ7Sbb2BQ1QKadvAFToEFH9VSB/2zj/cYVkRFom8+eZY9kINszInniX41EA1k5vzB3ene1+iLQvTDAADTYWaQ75ZidSAopz8WHAdSLY/QA9UJxjCCqCJu2JL7hmphdvBMWA1Y+7c10s1zt4W9dVOsBq9/Z2iCcb2RSTa64iNcpDetn7XH1nuH47QVzJYjKTKXxjYY3/fuFNYciWYgpuV5G8Gqtci3I4867lL+WYc0i7F3brP74pUfgD1LEh+rri7nuLbfe9D30i7C4/h4BhP8aExl9urp4qrk0ggAk//4zLtwNCUnTptpVt0a8QJTFelHlbEfHwIKBB0pj4/6ERGwF0K9aNI3uI3sc+6AjAYcCyvcmf92RpzyvpKiUV934yCDZHtGgpu65+4ZNHEw+7d0TZjyEw9Y8Ak5VknfF/UcUNwlDBI9wVzHfK62abu7sFBJglmKJWo5qjkJKHhsL4gvNBt2xHtX0zvyvyhkLtlNNSdTSzKZMnG1bvwjk7hvCabqZDOSnqBSsu6jGHssnhy39SYoG+x
 z5G/8Cdr
 aByQMKBKbWYDxwaluXH/pc9vJCfTjrWizT+JJG5ejMI09oSJLj8b1wDCB/CdJr9PWpm+QOuuCvr+lGTIvALQbcURpEdMu0w8cWnd25LCI3b008AnlgFPRkxdpmSpcTqalORo0uw9XrAYtm/3vPuebkRPvbDDwzGO1JfZ+gPa7EsAICcglQEHf2IrvtglfmpnBrabWKzp0rVY6r4+fU4ntEoSPq04fA25PowVkGfp6RPtDQ1Tx5hEvGjnO0ow0XCG3u2ETGIP/w1YSdRS24bmjp7GHpqUYv0Qp13FfJPXiXq+q2yulcP8unT0i0Rnf/b/6EJ6qfHn9JCCTaCgbS7EnDoS1Iw==
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
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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
2.56.0


