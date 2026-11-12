Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B674606A893
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gTY84qd7
Received: by kanga.kvack.org (Postfix)
	id D2A0E6B0610; Thu, 12 Nov 2026 17:54:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01D36B0611; Thu, 12 Nov 2026 17:54:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C181D6B0612; Thu, 12 Nov 2026 17:54:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95FB66B0610
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:54:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 264F5140729
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:54:54 +0000 (UTC)
X-FDA: 85427973708.06.5EC98EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6A87EC0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:54:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gTY84qd7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794524092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHhzsFK46xamHLjxn99YRGd8ys0XhYnUbLCGMyb//rs=;
	b=kHQfQMc9F585P+aMkg2gEwB1kDnX/DQ+Gs0Tdg3jtX2DN9IFTnUF4t916orSstP+oUfT+f
	K5GoSCCc1MuFhcIHbB3qpXKL+zM7wul0AoDj8j/iZgWrAIZ6PUrSUOhiJgGakWzmqcwr2u
	R7QSD6rQjRIWzDh7IqgqO21wdjY2goA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gTY84qd7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794524092;
	b=qSIJwEs7vDNBZ8iqkJ7IRswZcNzwTwIiYDvHF19mUBd6eTClrmVDL2Z8eDLIZ/xAifU8PW
	jhdZxaVjaJ5CQyHTds1/lZ+FRRu51npQDQXOsPiudd+Y66nD6ldVlztKFAPAq7UyQuEbzH
	i1nfrBpVUyCWafFiHTlRJ4ja1hcJkPM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00262605E7;
	Thu, 12 Nov 2026 22:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A654C1F000C4;
	Thu, 12 Nov 2026 22:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794524091;
	bh=pHhzsFK46xamHLjxn99YRGd8ys0XhYnUbLCGMyb//rs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gTY84qd7Kx3xPJVSlv0Vh6c6y421QqsRHJjtrv1m/Yy9rYUB7lVIMR2Q9+p3I4D8d
	 Cd6DXTn1l1oR+10Zi+NGZMXZyh0Hi7gJx2OHUn0ZtgzoNNVgn/ezSAZWxcRyV3TqwE
	 mtkGq7QEDVZ7DX04ybJibX7CyFzaqSRaKCKlwJzt7eGK4KTJ0VdZO0PZHWFRLHoFdL
	 +eLyisbrDfaeVdxr+nB0qU/LfMLVaIRQhwQtLh2xk9inPb4kR52Jc8i7yiJuhg9b9P
	 3xd8tMMPpSSiRP14qBEzFPjLpzLx2a7v0ZH3yV1K8bJ/3J3Vo1BsdqZsRNF0NkHbLu
	 ckaA6vBpBW1kg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 12 Nov 2026 23:53:23 +0100
Subject: [PATCH v4 4/9] iommufd: fix cleanup when adding memfd folio pins
 fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-refcount_overflow_stable-v4-4-ad3deef0bd23@kernel.org>
References: <20261112-refcount_overflow_stable-v4-0-ad3deef0bd23@kernel.org>
In-Reply-To: <20261112-refcount_overflow_stable-v4-0-ad3deef0bd23@kernel.org>
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
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3608; i=david@kernel.org;
 h=from:subject:message-id; bh=fau3pBzKpQXLjgKtqqi0yzExsXgD+rlECuO7Pn/e1yI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+OWfJhtdL7uhLDRC0Ci/bcInJYkF8q6oQt8/+GWc51
 JawqDN0lLIwiHEwyIopsgQF3zd4+XJdbbUbHzPMHFYmkCEMXJwCMJGt3xn+O8cetij4uVtU8oRf
 qCGz1BS7tZeaBNq/sjmlcTIZ/HKKY/hn2e/SwJmro3uEceW+PhXP5TmTz6kE/f4YvvhRyLEHv0W
 5AA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6A87EC0006
X-Stat-Signature: 9rokm8fabknymq4hq5qb6p8ctqmbsj69
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794524092-155777
X-HE-Meta: U2FsdGVkX18q5PDnH6m67UbneXXpfkQ7Fx2rwkMlzwcNrq3JOf0+5bcFg/WlAkiUBSOYgH0nmgr1icZoOaVBw12KGYTcuTcmV2ZfRbDWoLdrFnvrpOy85ZHYkKO/pIIem0iOikdNGSKzo6rqtNO0ut/uX7wmZQt+FGyHnAqpgUCqgIRLI1t6AN+M28Pv36LpITBPR+yvRzgJDYAWR/r8q9xCveYa5Qak43B6YcR6+VVJ/oAPNQzxxzMJToG8e0VwuJuoEmJ0gU6o5TF0hLN50VwzxZlLTZEJhJ3hI6Dgp9n9mRaXM/o7hH5Bz1oyJDqA2oaJBeJPG4/Gq7PedESxLQGsbvYFCeqNNWYRdcXySnrMlIrgrCnQDN+GP6rbQ3zyvIXf9TLajshURSDusoDn9ew3rJ+My+8DkTl4QvNX+O5moIL62z+nMTLRoE160ErynQV0vh6ukkFFkugnsQq8N4zmek9NKvcTqL/suoZqw3cLwMuJRR7Kyn79qdKMOxg5q9pX9EgSzbqGMCPe3Wu9G6sSytcRxNzv/yJryD0nt3KJyQtZXBQkMTg9OQGhSyXPwVAs+JbhAUq7jkclRHimSOslUyorOiRf7L5rZ2uHhROYyWH4WONxAq2C2pwcYLTQ+1MXdmEoQkVDQXaIOxG8zcxJ6Lru7Npp4ZA+HM2uZXSnze14eGRVNmHVvYXg5ebgJ+aQtE0SgkFr/JFXIf5VM2YJkBMReD7cPwAkLqdto8yyfQXVe8n87NwU66ImxLU0bldeqD1j32kErV5ys6dfSv9EBasFfwcn+yqFS1ibR1jsbIIcrE3xgtYOzFJUFlhxWfKpNCKMF8OcGNzV4E9G73zmVPdvsH+EGhNDlunwAQdpycD2SfFMIx10Amkjvob9y6que41VKvUfYp7Xbf4YH5PUZon3vHVx8GTsGQzbqyBNw3sCkuShZH2Sap2Zvq4a4UEOY+BSVYEuetK9rDp
 O3N6sITh
 swt/vEdyAqsdnKMzemvk4FkYYWHTVFmLyqTGP98GXOXUrcc4hMkaR3G2AaY3VBUJTCjQw1hV/18iT5ILxj8A2H52wMkg2VDXUtHYJgF3pST9eSkS/XpIbhmUeBGeym6yYvEiEuPWgKzhcG5vvpyKAQL4y207wOWcQUHbf5/e1D1awkVuN9Yx0Kl0g1m9l6hjqYudFGSc4ELI8WZ88G84k/Bg/C/qJuoALM1GOdtbDm75PbS5SURxjsQAnu3PuBsy/66zUeSF7cA15t5a2aHr5u/TZ2gjBXXSjRqUjnoJzjnU2YY7hjPzFbogXwTTk02i4tmg1t6+EKlimruaSedokCVSQjA==
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


