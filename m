Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505C0606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cS47NPSf
Received: by kanga.kvack.org (Postfix)
	id 110A46B05BA; Mon, 16 Nov 2026 13:30:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8F46B05BB; Mon, 16 Nov 2026 13:30:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 025476B05BC; Mon, 16 Nov 2026 13:30:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D32816B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:30:13 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60702C024D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:30:13 +0000 (UTC)
X-FDA: 85441821906.27.3E37BFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8A70014000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:30:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cS47NPSf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bxc7Y1o0IJUNu9aa9tdWaFfEPqOd6AjiRxCSLgH+Bo=;
	b=riC3wiWm1Zpb+ZR9L/zVwQd+IJjia+sd2T5Mur06754VvbmUhrXcZY9gDBv9nStQgacqPd
	v0UP5OSnMkB0z6z7yBc0b1Wf0aq4uqNxRAiwvjtfN2DEG2CsFTP2P80lvsPsZyu+o581aB
	36H1JM07vE50gJWuoHm2u3BSuF/o5DA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cS47NPSf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853811;
	b=lJqslZgWS1c/sPl6pv/I9LrGlN3VbN2PTvE/MaoDeR/ILnpCne/VpLkjIMEGQfT0ZSNCNv
	LT+J9rjlnDanU8AlqiiqByXEemBLFQZZdItsAOdpkokgNLve914b01DQa20bAnMe29ttz1
	WXf685Q9Lz6unporUO5pzUQC0BCxzAE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22FBD61EE2;
	Mon, 16 Nov 2026 18:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACA51F000C4;
	Mon, 16 Nov 2026 18:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853810;
	bh=2bxc7Y1o0IJUNu9aa9tdWaFfEPqOd6AjiRxCSLgH+Bo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cS47NPSf1gAw5oMwK36MhxFKNNMf0Zf5rdwGjatdYMRI4cfCx+8fa3l77UfCcKdE6
	 ApXuBPsF8x9XYTR/ZlwZ4qpaoFpf+aV1r+5qlHrnb89jyTZH9sHwrfZjRRjZuozltj
	 CHVv5vqW8n6bo6vNBMk/4+8d+4rgu+UUvXcRA1zxUVMiBUl0XFXlqRZBukIl9HsYqq
	 MCJu/2N4PS8/dwGA8fnkL0laB4ZETSk3FlO6nrmpjDXkl23Eeh0hJ6aKZGKhfabLPD
	 yDcKtQ13hEGwYOaNmU7XyaE1+Wkj2dK73LJl17F+ExoV7wJ5jiCSoNA77M89afE6fC
	 8M6yv/UgoCSpw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 19:29:24 +0100
Subject: [PATCH v2 03/15] mm/hugetlb: preserve reservations when shrinking
 on HIGHMEM
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-fixes_hugetlb-v2-3-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2610; i=david@kernel.org;
 h=from:subject:message-id; bh=LLOzrq96DN9yt2OFJ2ZyOmBcDl7+i0ip7px3+VJMlgc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e3f4i3Qb/bjD9n9Fy+ekbrGTTP7VWhvCBK6qPEgw5
 Ho23/lnRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABPxMWf4n2f6IXbVt8MXIn7n
 Bq2aufvR3oecydOeaAWKHbnvuu3A2XOMDMtTl2svmu14P6O1SHj1rnWHDlapSO/wWFb6uNLPQMX
 yLQMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8A70014000F
X-Stat-Signature: fg4gjnn5n59he4jcmg8j4sfgnwqez835
X-Rspam-User: 
X-HE-Tag: 1794853811-392095
X-HE-Meta: U2FsdGVkX1/sn2pgpxuDvyLTeMDb58C0IAeYUTik7rhlt7Qp0yC8vMm+L/J/NQsbeo9SaT4ZwBALGpnhMXVp0LjjQjuEL0CnvYG1bgwlBvsbsPCgQmhvrfErRmTGZxZhWAjg9RMjz5zNAdaSxMrrmpHOxoQoarqtG/pru4c9U677SAludeHS6wWEXgofDRny27JfKwcMrNaSdLC0O9LLIrJ23vdKfsIwZ2JiDctFq+IskaW2RcTZJ6lzbXFo1t447L73V4AQ1zAwgmWDQ5phb/7KtIxGlixbLfhiEdH0ETDnXSJIXG6HWkSZqVbnEgo795pMQqF5ij8xCxMFT48GfNp6RqFoRO6vLjofXe0unvu5F9HJKuZrj5l5FrOzUZqlS8KpO4nLmo3g4ffShLtkIiAEjAhELOiJKjFaPsCGxG2mlGckLMyWH2RlnnXv6BZtN+AVCHBMMorfcVK4dGtBybBXpqp6BZamuJAWnMCI0462gVWd8PijZlFyWQpVbk5MkHS1cKtyB9P6YR1HaItHo5h64FZJGRc9vYIZ2pDUCOIFJYhnzbATuKEq6D0vWpBUnWVz4nWRmoZeWhlMdFdaFL7n1hgCy2UEI/5EfxjYVeQo2ycDHfV37IEaO8uftTkTkSjzTeHGDU72JAfURo/AjpgnDzewJa+dA3Wa2qEYSFBRmFPRlwJSe//zijGBo6jD+Lhr6Po3wMRPmW/JXWu2UhG7qhM8m60E6jcfUoie+HnVbR6PJfrcK5zFBzGVzt0ZAXjx6yrcjMP1wgrl8xHt55Gk3Lm2PUSZsPCIcSBbyX0nwxGLC6LzDu47AKzKDMAaCtQwjU5uIZL5iiZLDAQlv676i5STotXavvUJSoPUQCoKW8LqswLt7X4RpRYHOG6WInDGC+tmKdVrECbkSMfj5HPtT/DqrBRkK7Wj3Xk8DuuOufMs3yc0CqJURpaYhkIHQz6efVJnLa0I7QWmMjU
 I+gRDY7e
 sJ2em07r8rneUolKJitYNvB7mB2wxRfr766umGojVOWYVds7YQmL+OilP7BybKqm95J4I4HopxcbgOeQ+phQ9+teULzNwDSggD/rSBDI/9QnS8uYcpbe7BiTM7zSmRMZUA+ExPwA9e0tAj2pKboafd0ec30RaCb7ndiFLrSEcqOD4u6MmCBFrDTCgytMC30Fo8y0vvbEVbK8nj9SRsU1Vn/d/vX5GhE5lMhvW/Q1iyVxKYShAp7lv9kh4u+6PpS8L//VRgULidV/iSLEbLpmkrxhgHdS7UN7FHwyePpcF57Asd36UhCfDAjh8T6oRXKHe3UNQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

try_to_free_low() drops the hugetlb_lock while freeing lowmem folios.
set_max_huge_pages() then resumes freeing folios using the
min_count computed before that unlock. Reservations created in between
can consequently lose their backing.

Collect lowmem folios on the caller's existing page_list instead. Keep
the hugetlb_lock held through both selection passes, and free the combined
list at the caller's existing unlock point.

Likely not stable-worthy.

Fixes: 1121828a0c21 ("hugetlb: call update_and_free_page without hugetlb_lock")
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 349d45b932d9b..0b071bef226ac 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3712,39 +3712,31 @@ static void __init report_hugepages(void)
 
 #ifdef CONFIG_HIGHMEM
 static void try_to_free_low(struct hstate *h, unsigned long count,
-						nodemask_t *nodes_allowed)
+		nodemask_t *nodes_allowed, struct list_head *page_list)
 {
 	int i;
-	LIST_HEAD(page_list);
 
 	lockdep_assert_held(&hugetlb_lock);
 	if (hstate_is_gigantic(h))
 		return;
 
-	/*
-	 * Collect pages to be freed on a list, and free after dropping lock
-	 */
+	/* Collect lowmem pages to free after dropping the lock. */
 	for_each_node_mask(i, *nodes_allowed) {
 		struct folio *folio, *next;
 		struct list_head *freel = &h->hugepage_freelists[i];
 		list_for_each_entry_safe(folio, next, freel, lru) {
 			if (count >= persistent_huge_pages(h))
-				goto out;
+				return;
 			if (folio_test_highmem(folio))
 				continue;
 			remove_hugetlb_folio(h, folio, false);
-			list_add(&folio->lru, &page_list);
+			list_add(&folio->lru, page_list);
 		}
 	}
-
-out:
-	spin_unlock_irq(&hugetlb_lock);
-	update_and_free_pages_bulk(h, &page_list);
-	spin_lock_irq(&hugetlb_lock);
 }
 #else
 static inline void try_to_free_low(struct hstate *h, unsigned long count,
-						nodemask_t *nodes_allowed)
+		nodemask_t *nodes_allowed, struct list_head *page_list)
 {
 }
 #endif
@@ -3939,7 +3931,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 	}
 	min_count = h->resv_huge_pages + persistent_huge_pages(h) - persistent_free_count;
 	min_count = max(count, min_count);
-	try_to_free_low(h, min_count, nodes_allowed);
+	try_to_free_low(h, min_count, nodes_allowed, &page_list);
 
 	/*
 	 * Collect pages to be removed on list without dropping lock

-- 
2.56.1


