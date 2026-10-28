Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33D4C606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JZX19F6g
Received: by kanga.kvack.org (Postfix)
	id 35A226B05C5; Wed, 28 Oct 2026 16:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30B496B05C6; Wed, 28 Oct 2026 16:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F9A76B05C7; Wed, 28 Oct 2026 16:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E19BC6B05C5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:15:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 669FC1C23B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:15:35 +0000 (UTC)
X-FDA: 85373140230.17.B1853F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8EF771A000E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:15:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JZX19F6g;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218533;
	b=p6HYAOiOz5D8wRbwZ1LHPNOtHu191439jMvDS+9+C2V7aR84NTSKDJFEcuD4/LvVERcdGO
	GzZgdeAjosQPc88DJrxJHV8VixglRZrLFuaRAODESQ3yyeMVfGq3Gdv4afLSJq8Znfcc1a
	ODF8zuuAMrrFvdslYC53FxriVQGLFhA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JZX19F6g;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U9COBRxd2nr1hsxeOTWoNKKoSqjE21lpsMn2gQskWh4=;
	b=y/+L5fmr1TiNnOlod+nCtCTn6HyQYghfomeOfU3kr/4omhRjkRw2fq/82rQ3OpdSme+X71
	6Fgfhtoy5PlGT4mlSstYma5zMO4ITer9PjgZ4nUtdxqQ2FThLQGE5gU/5nF1w3TTO7cy9A
	F90/46zUQmB+zSnyJQq4wTHY/0ENHjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C541600C8;
	Wed, 28 Oct 2026 20:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E0A1F01829;
	Wed, 28 Oct 2026 20:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218532;
	bh=U9COBRxd2nr1hsxeOTWoNKKoSqjE21lpsMn2gQskWh4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JZX19F6gA5CN+NMYFtdVEv0u3QnOUGu4iWEpYStl/W0tES+fgQpo5XoWs8s/oyEQ4
	 5qhQpyiyfFoxA0diKnC7Ridn6ph+eBszx7zbBu6XVtid/IwSi/8UMCYCbTHdnIfXV0
	 ily5aiaR+QrO4L8gmzXp8QI2G2G7HLkNK+3IyAGipcYBBKuU/6hlOxSxhVnKUu3C1N
	 k/R/piabG0DyjRO98AhejgbAJRB+eGPPqwh3X12RE+3UCPk71le1HzT6FVWKzS3d71
	 9iJGVrjneCkR/cjFZYglek6RUdg2xkxarsQANF1Nxj3L8UH3vo4iLKNuh71xlP6brj
	 Eu4gAp/l6J0nA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:38 +0100
Subject: [PATCH 10/15] mm/hugetlb: count again if the reserve map shrank
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-10-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
In-Reply-To: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6749; i=david@kernel.org;
 h=from:subject:message-id; bh=PTBhJG9rK1MoJYbu6w43UaDUSDaQ1jMI/kOQ7J0Q9XI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZd96A/mnrj1mafNk5V9s88+3e72bYlGa5EST6/7t
 HKrLeKtHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzkhA7DH67bOwz3qO5uffyX
 d7/GX5MJ9082/tzyqNboxBFlr9OTKwQZGfZ/Mj8jeNPo9dG3Vvfvdm6bIXTmQo6Cho7z0sXcjbk
 R//kA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: sqao51pt7i84tn9ukb4za8tczsygqyom
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8EF771A000E
X-Rspam-User: 
X-HE-Tag: 1793218533-288197
X-HE-Meta: U2FsdGVkX1/E32S6/u9nosgk9cO6wjw1BpxCg47LcIBIfYxoHY79cmHHM+Go3MP8PG2bu+/q/XqnYKQUma1Qz4oMvwJvFw14/3GmPH6+EvzNSJormLiPx51jQxC0Nre0rQvSzqpHEebzMpj7wf3i8DPGR5jgDZeYBYE+5KvGYBo08i807I6kal8IADiCKVkj+HXEnp6/oatFdUNElXOIkzY+2tkSsGMCb2qoz+hUL/CmKJaEuE+QZPuX/jYHknzIdOXWqvsqGwC/ppJtRtEi8nxfe6CCWCLJqcqdiI4FPTgihMgiQDTDZNp8gynYbyTsdJS1Ol+VD/A/m8AAgY9NAGGiLtYe3hHbOMFVXNj81xPZzS11PvnOTp8f2b8f9wTnXOn57MyteNdmr42G8RgXJCPdi5YtSqgPxf8wYBpMxMi4U0VJZwJ6BiZ5SxoOiYMjK3yzPdjTYB1aQOaEkRoN0kCZFOqAHaJiHISI+QIV07JJmzSXj/LaxSBypadsHyHMebxboEzIqULWDM3RhrfaSdGPHHXGKuXj8hcu/45puPe39LO/5Em+Lxs73bCFHjzZxlb4GbppIG79UkfEmA+vLUVg3NJ9qx3glXi4KlNsLqyHFWHfDfTmJU/cBf8OT8CpbG04Pvy/tYq+jgNJV05yIy8MSjGsbijL98v7YWeGTCQHQ9OvLKgK6QwkCk3vQGkQ6O7SXeotbs0XEMpkcdmJ/Q4sSKDNT/Zm6EqfDh7FSsv9EK+0WhtPTN18qOSBFEqBlL4A5ezEqmt12HqtVsBEIEpqJzIdvTciqfUf/8atCIdie8xpjeEMomWEp8IPh2PqtThZCRkQuy8opUNT0fnutu2RRkqx5gOPQg64sfPBziCxzGoDIMw3AlCXm9Xw3JGVh1apunnqoceKIlch5TW+lcXogiSvZn0mm0Os17z+/59Rmtd3eJzCYzuwXOCVTQHvLqLNPz8GvbVfrqFlPS3
 Pb4KExfY
 +RecXPJkSH9Cb3TIwATPTgstD9FjFkSzlcIeTLS20COSkP79OyG6mjDIgoj86hblZEw7O1m2rwysd7m8WuJzRWNtCw/M4gkJGSOpXokbQ5Wf6U43/cRurJDF/RjOfI2tkycO3fJMuUjn8nPvREDkiCSZnCjMZI0tm50Z17PYdwqPeb7VboXwBg2k1hZHWeunBLVzhTXo/hwfLHg6VZJDfl//Icxe9MVwkn7rhtnp6h8VlztUm9W5rCP9OyNbmDnV/2o5EhEXvyhIdP8E5Fyexjl6/9XI+W13XvNt8CCPzL5fykaVIi2AnHSVyeqoiFWRFrxVoA2fD9Gi3tUbaKWVX+vjWimoaWVmYRngPIdpEQ70CiaNg8u5VK3Wj4NlUDCJ1KPUp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hugetlb_reserve_pages() asks region_chg() how many pages of the range are
missing in the reserve map, charges the cgroup, the subpool and the pool
for that many, and then lets region_add() fill the gaps.

It copes with region_add() adding less, because a concurrent fault added
an entry in the meantime; however, it does not expect it to add more.

Since restore_reserve_on_error() can delete the entry of an allocation
that failed later on, entries also disappear without the inode lock that
mmap() holds. For a previously unreserved page, UFFDIO_COPY can do this
when the source is not resident: it allocates a folio, which adds the
entry, fails to copy with page faults disabled, and takes both back.
memfd_alloc_folio() does it when it has made a reservation and gets no
folio it may pin.

If region_chg() sees such an entry and region_add() does not, an entry is
added that nothing was charged for. When we later delete it,
we decrement resv_huge_pages and uncharge the cgroup once too often:

  WARNING: mm/page_counter.c:60 at page_counter_uncharge+0xe2/0x160

Similarly, HugePages_Rsvd will underflow.

Tell region_add() how much has been accounted for and let it refuse to
add more. Convert it to a region_add_limited() for that purpose.
hugetlb_reserve_pages() then undoes what it has done, as for any other
failure of region_add(), and starts again.

Note that we move hugetlb_vma_lock_free() so we can retain the allocated
VMA lock object as we retry.

Limit retries to 10 to avoid livelock under repeated concurrent rollbacks.
Return -ENOMEM if the retries are exhausted.

Fixes: 846be08578ed ("mm/hugetlb: expand restore_reserve_on_error functionality")
Cc: stable@kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 58 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7f240cd7dea0..06d2a78c7170 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -735,26 +735,36 @@ static int allocate_file_region_entries(struct resv_map *resv,
  * region_del.  The extra needed entries will be allocated.
  *
  * regions_needed is the out value provided by a previous call to region_chg.
+ * limit is what the caller has accounted for.  If more huge pages would have
+ * to be added, because somebody has deleted from the range since region_chg,
+ * nothing is added and -EAGAIN is returned.
  *
  * Return the number of new huge pages added to the map.  This number is greater
  * than or equal to zero.  If file_region entries needed to be allocated for
  * this operation and we were not able to allocate, it returns -ENOMEM.
- * region_add of regions of length 1 never allocate file_regions and cannot
- * fail; region_chg will always allocate at least 1 entry and a region_add for
- * 1 page will only require at most 1 entry.
+ * Ranges of length 1 never require allocating file_regions and cannot fail
+ * if limit is at least 1; region_chg will always allocate at least 1 entry
+ * and adding 1 page will only require at most 1 entry.
  */
-static long region_add(struct resv_map *resv, long f, long t,
-		       long in_regions_needed, struct hstate *h,
-		       struct hugetlb_cgroup *h_cg)
+static long region_add_limited(struct resv_map *resv, long f, long t,
+		long in_regions_needed, struct hstate *h,
+		struct hugetlb_cgroup *h_cg, long limit)
 {
 	long add = 0, actual_regions_needed = 0;
 
 	spin_lock(&resv->lock);
 retry:
 
-	/* Count how many regions are actually needed to execute this add. */
-	add_reservation_in_range(resv, f, t, NULL, NULL,
-				 &actual_regions_needed);
+	/*
+	 * Count how many regions are actually needed to execute this add.
+	 * Fail if the number of huge pages to add exceeds limit.
+	 */
+	add = add_reservation_in_range(resv, f, t, NULL, NULL,
+				       &actual_regions_needed);
+	if (add > limit) {
+		spin_unlock(&resv->lock);
+		return -EAGAIN;
+	}
 
 	/*
 	 * Check for sufficient descriptors in the cache to accommodate
@@ -790,6 +800,13 @@ static long region_add(struct resv_map *resv, long f, long t,
 	return add;
 }
 
+static long region_add(struct resv_map *resv, long f, long t,
+		long in_regions_needed, struct hstate *h,
+		struct hugetlb_cgroup *h_cg)
+{
+	return region_add_limited(resv, f, t, in_regions_needed, h, h_cg, t - f);
+}
+
 /*
  * Examine the existing reserve map and determine how many
  * huge pages in the specified range [f, t) are NOT currently
@@ -6828,7 +6845,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
 	long gbl_reserve, regions_needed = 0;
-	int err;
+	int err, retries = 0;
 
 	/* This should never happen */
 	if (from > to) {
@@ -6850,6 +6867,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	if (vma_flags_test(&vma_flags, VMA_NORESERVE_BIT))
 		return 0;
 
+retry:
 	/*
 	 * Shared mappings base their reservation on the number of pages that
 	 * are already allocated on behalf of the file. Private mappings need
@@ -6928,7 +6946,8 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * else has to be done for private mappings here
 	 */
 	if (!vma || vma_test(vma, VMA_MAYSHARE_BIT)) {
-		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
+		add = region_add_limited(resv_map, from, to, regions_needed, h,
+					 h_cg, chg);
 
 		if (unlikely(add < 0)) {
 			hugetlb_acct_memory(h, -gbl_reserve);
@@ -6991,17 +7010,28 @@ long hugetlb_reserve_pages(struct inode *inode,
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
 out_err:
-	hugetlb_vma_lock_free(vma);
-	if (!vma || vma_test(vma, VMA_MAYSHARE_BIT))
+	if (!vma || vma_test(vma, VMA_MAYSHARE_BIT)) {
 		/* Only call region_abort if the region_chg succeeded but the
 		 * region_add failed or didn't run.
 		 */
 		if (chg >= 0 && add < 0)
 			region_abort(resv_map, from, to, regions_needed);
-	if (vma && is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
+		/*
+		 * A concurrent rollback removed entries after region_chg()
+		 * counted the range, so we charged for too few pages and
+		 * have to recount, recharge, and try again. Limit retries
+		 * to avoid livelock under repeated rollbacks.
+		 */
+		if (err == -EAGAIN) {
+			if (retries++ < 10)
+				goto retry;
+			err = -ENOMEM;
+		}
+	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		kref_put(&resv_map->refs, resv_map_release);
 		set_vma_resv_map(vma, NULL);
 	}
+	hugetlb_vma_lock_free(vma);
 	return err;
 }
 

-- 
2.43.0


