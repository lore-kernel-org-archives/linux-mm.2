Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C88606A336
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gWEhRREK
Received: by kanga.kvack.org (Postfix)
	id 9D8226B05C2; Tue, 10 Nov 2026 15:38:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0836B05C3; Tue, 10 Nov 2026 15:38:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8976B05C5; Tue, 10 Nov 2026 15:38:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BFB16B05C2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:38:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3A67160A16
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:38:01 +0000 (UTC)
X-FDA: 85420371162.30.4F8831A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 22CFF180009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:38:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWEhRREK;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794343080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHhzsFK46xamHLjxn99YRGd8ys0XhYnUbLCGMyb//rs=;
	b=WT281lNdHZz2lQ7UJUifLt5T2HDvrZ33vHrBqEdRtp7jdQIsNFkscYN49nyoWxb9rkjOjV
	uSjnkMKxgcgo2oXK8OmC77HhCbGobXswD/Vi6uHO0Ij1FAO593T6e0GY8scolu4af5NPoL
	jf8x7Uul2+UZJgxaTFtm5oNF5u83BYc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794343080;
	b=XB89y24sXDs/qDRUvfW+GmLvfHQNkmCaItZc1a4zCRE2duVTH+w5F3LjvYsGJsw3WugX5K
	OEaGpq1W8mYWTGcS1easE3WZva7uQW45Nt0+RtTnqCGdxFREvg+YHeKdJvjwi+TPXWx4fc
	7jLl5xI8EchU/xzHlB84jP+vx9+1L9s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWEhRREK;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1D0F618CA;
	Tue, 10 Nov 2026 20:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38231F008BD;
	Tue, 10 Nov 2026 20:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794343079;
	bh=pHhzsFK46xamHLjxn99YRGd8ys0XhYnUbLCGMyb//rs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gWEhRREK9FVVHGNpd2nGoRZ8s8g//Xfo+FROKWQm72DFOPJ0clcsk98bP/mbSEE15
	 8tWNbXJ6ZNTJnEuv0ZAUuKp6PFeH/15MVpNDyhm3dMZpIOcWjMjBN9nu1TGLpO8Fdm
	 K938D0LjGqLb8R7ju5fJRrASjlZd+VkaeJ4987fZcckyNFHaLstEB4wbWA+Kp+AaEJ
	 GbUCt5fezRqDI2Ol+HJEiFl3DN+nSnWYbbAasN0F9NQtdU2FPjnwK7OdH93/i4jZtb
	 G7QVslVoA/cKhDVDIKtarFgGX4bz//b/KI9Ga/Jc7nXTTY8Tzkre99epxDmtOqTeVE
	 Ix7wdKANaY+3g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 10 Nov 2026 21:35:44 +0100
Subject: [PATCH v3 4/9] iommufd: fix cleanup when adding memfd folio pins
 fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-refcount_overflow_stable-v3-4-318625d63a98@kernel.org>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
In-Reply-To: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3608; i=david@kernel.org;
 h=from:subject:message-id; bh=fau3pBzKpQXLjgKtqqi0yzExsXgD+rlECuO7Pn/e1yI=;
 b=owGbwMvMwCF2QOXvyb15Z08znlZLYsj63BA+Y9ux4zLMk2e4PpP5oXDoUBfvZgmLYJ+T4Suvf
 7qZaHHRsaOUhUGMg0FWTJHl2rqc1OA1rY5lUYZuMHNYmUCGMHBxCsBEki8w/E9vmOcWxrp9lUtt
 kNILo72njKafUJm6ob9t4eGK2tjDS1QZGXqWF/mFrH+wmGlO4dX2pglu6r/jEpRkppTqH5vx6V5
 pKg8A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 6o4tutaxteyouhu7htbhxzfhddieyuok
X-Rspamd-Queue-Id: 22CFF180009
X-Rspam-User: 
X-HE-Tag: 1794343079-824551
X-HE-Meta: U2FsdGVkX1//PUObGOH1wUignZdOMKkUDFMfGT8mt6tg0kfUQgjhrEkC3K3lyHtXEA7/CMxaZOLq42tsGxop6kxD5BhLWbMfIH5gMV9CrB6cVT9DxQLipwcSOuaMJl3w8ssKoOQSh3vN+1bbwI9zV+8Tj1yVO7ElFX1/H3G4WIznKKnv319EwpY0QmVca6ef1EUnQcU3XqJxfAKgAElkOdmaa59S7YPNDgpHi2EtRrJ6E4QBfpWnm6HkNKn8nKz8n7IPbY3XEyMHJE+44GGq+1RwnHwn7+jZmxWVdAvTCD5SSELmR4rJvsbIIH5bwWd3hPNBAQjpT1cCmBVINebo756YI2SECyHr0LMtCsvgqzD4Ij21C5wH69bb4RDvBjBZAuYDRv4x/NikBwCPs9fBI62+/jyPFVH+KHZZOnN4IVLgsyASCvUCcHGG4n1TwjD0nE380teFdAXSLpXdmcKZyKrjkzSS0gJmYq860BN+s2nY6NZaPMFHG1m3kps4VJUXa3VTtKYQlDP9zEa4NY+oKmf08JQ8eh0uO7QRAQT1V5ZugYrDAExroDSMQyvGAzDp7VfuojBhsCGTG5Lwy/XrKHZslnLDQ0C2K1lO4xEmwAFbvNtYheVUM8FkAmVmSleBvbpjJWpe9+XL+feu6/VEaKGUywe6WQXgDXrdBttETN4R7VGdzbor6Defm2jt6XE7gb58zOG2KyTi7Q06sBOK8ELz4hboti51QoP45PlbxYCIs+EeaTZZPB0sC77YwwMVPl6Eh5H7LH+iOk0KY8jjiA6vnT2+1UHB/I2DrlWpy7zfvNvuNnRvnll1yKsRl5zHH4egtnuKfXBd5IdlsjtupaPkFO9eJ558WcyFiZN6VSQa1jhuduA3rIEVsNbUA4uR2qE47FqE2wMlIQcRyGOU1/nagv1Krz+LqcC/TZcDu52u6nh1qFcacXGI6DEd8RLyliJwXsTVcJy24a374xd
 ZoZRu2Ie
 tO76ApTAfJS6z7EKHGZe4756EWrNZHYgM1obNn0NlTBEc2WcOpDGQNWlTjGiWeCiQd+v2Qhqm/fo3sg510VTu7tgvwBxeafJx59k9Fe90A7TUMo/ZKpGvwJtaejBU51s1Ua2xiXTyAY9GWlK+bGtNTDka55lI3pCaqgkjPbj6E2xINsb7Z0jmL0xFh7r4sSzfzJBqaleQ3fHyk2ZH+ZLjFJjnvlDwjZgAo+805m3BlO/ESeuRRGruO4w6IxvGm9vR7sXX9W2kp4z8L2T3xDRoufKpoD+L2bHdD80ojOnFzFMwzXvPfG7AhwU6W9oMtp3sgEyE88yXgsQn4/MGwU1gvuFFIg==
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


