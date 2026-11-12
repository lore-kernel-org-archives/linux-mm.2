Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E795606A338
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 02:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TbsS8hG2
Received: by kanga.kvack.org (Postfix)
	id 941856B00EF; Wed, 11 Nov 2026 21:16:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2436B05B0; Wed, 11 Nov 2026 21:16:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E15D6B05B1; Wed, 11 Nov 2026 21:16:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5EC6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:16:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C29BC036C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:16:07 +0000 (UTC)
X-FDA: 85424851974.16.0FCB0A9
Received: from mta1.migadu.com (out-96.mta1.migadu.com [95.215.58.96])
	by imf09.hostedemail.com (Postfix) with ESMTP id 55C0014000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:16:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TbsS8hG2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.96 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794449765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FwTv2GjEBlQR54GrEgezu3FqUMu0/uxeIqk78GyVHCk=;
	b=xNXYNUA2i4+EZrIHZGdFOHwrpswV85Bx+BoHScoxSR8S3HetWQLHOMiwZZuiRZsWGoVzn+
	eCpHO7kz0c6OaED50NSGk/tuDYZqsXlLP6nLxwz63A0tm13dNiPVc7ku7tL4aTL1SE66XF
	anbm8gDgWaSeXJUtmOJqLQazHMEqJ5I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794449765;
	b=sOepVAZSXiSh8h/n1OuUIQ7odWNdQhdpRNjDC7iz6xzCajZNdS/NyshR2276POOBCFr0vR
	/M7sv4GYlxUZeU6oT0IykA0I986H0zjV0ydM+M2PDj3iUib1AC8gx0xANYrHcAHY3D3H9w
	4F5WlflD60yDWUp6gkUnaN4t/pXS+1s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TbsS8hG2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.96 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QdTK9vDoJhaUIW/U2XIf5FYJQ9anojdg/JfxOCFPB4I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794449763; v=1; x=1795054563;
 b=TbsS8hG2H99euT9cfkFIu7YsULdZtjHsHuxSUFjw8Hba4NXZu0/Oeq3XY6uQpyx1OOqVd1DF
 z7x4fvyzNZq/zZl6+T91em8H/T15Ux3brX+voPeNeCwq+sbApl3nH58ZfYLLQnQ4uKiDZnML1JQ
 qApNnAS6yCS77VRM1mXrEV70=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8cb470a74291e90a;
	Thu, 12 Nov 2026 02:16:03 +0000
X-Mizu-Trace-ID: 8cb470a74291e90a
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Thu, 12 Nov 2026 10:15:33 +0800
Subject: [PATCH v3] mm/hugetlb: charge hugetlb cgroup and memcg in
 alloc_hugetlb_folio_reserve()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-for-alloc_hugetlb-1109-v3-1-7a144510a373@kylinos.cn>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNwQ6CMBBEf4Xs2Zq2AoIn/8MQA8sCq01rWiASw
 r8L6NXjm8zMmyGQZwpwiWbwNHJgZ1c4HSLArrQtCa5XBi11qpTMReO8KI1xeO+GlnpTiT2WiCU
 mGaV5rWAdvzw1/N6Pb8WXw1A9CPvtbWt0HHrnp9086q33kyj5TzJqoYROznmCFMdNJq/PybB14
 YgWimVZPmoS6KLPAAAA
X-Change-ID: 20261109-for-alloc_hugetlb-1109-0ccac58e69d1
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Gerd Hoffmann <kraxel@redhat.com>, Dave Airlie <airlied@redhat.com>
Cc: hongfu.li@linux.dev, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
 Daehyeon Ko <4ncienth@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794449756; l=4820;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=pFMQxDRwAloKyD9un+uH5Do41KW7aYnWyhIKwB42GmM=;
 b=/krm/uLaEvhDJqjULlNLgkdgLTXQAtC9oZ422Irx8PjuQC4YU55WHVduK3DsU3hy4K7MraGOi
 h+Slav7AQIXDQvA+jQRTMv8UzitiRTOeRBPXBGpqA0hDZJWg0X+/dif
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Stat-Signature: a3qd4jo6neujjy8tsc1pus1g53bmr1b9
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,LOTS_OF_MONEY,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 55C0014000C
X-HE-Tag: 1794449765-583999
X-HE-Meta: U2FsdGVkX1/j1rZ9vLQRtb7ZgsLTRK4rLV6Zha5t8UGyWC7LJZnMNDNNaO5TCczt1ZLIHJq+wZ0S5ybrwExFuzvssl9LzuJFKauXBFeu+c0DfbO9eMCAXxukEQ4CDqijhJQfP455R29bazVjC5F8PlRD+3IkV4OrBOugdaZjGMSTUuVrGiOslEV48ij2h/I0MEf0V0oeOuJTMPLB/Tvy8aRhG//XnlbG4R7ejvyzAuCvaobH4QK43I4I56mkkZzPe1mBZqtRaW/7YxAIBl0pQollIKUeaOMtYaSZVjawSQcvLr9kIAKmUbIZ3k53UBULeW4Hh5veohtznhckkqBPShbL5C9dXKI9qRQ86h6fluZR+TSL+jyS6cJnrRLPXmP5kK/SRaSNEcGl5c4YtYv/sP4QnIabvlF//T2jUZA7jawFKseIxjKRanwt0GKbKgeZkSQF8FwwoP1rcD9/4bjqeZQLR8DDFeg8DaZ07uPzJ65M7wpbf6ppJrm98w1336hSVv5zJ+MSPrpZUd8RYHi3XL56sJQKCl6ImrG/ohfqiX2Ue+b9jReW0F1iUardDg3E0XIIziIoYBLrMA2yWnzR78IKOsjrrxTZA0Jc5hhA8W+oQpYn4oV+17dMhbBCYB5InxDCjdDmxvLH6JpcV1WIfXR1s9+6VGOtiY9F9KCj8Qu/EOWTxOoKZKDtNprnxC4pKdP+64AZx8c4CLbVlbqdxynzBwTCEe2YN1iV9HQxoar8O0I/3XClWX70OrjNPhwMfUDM0+Sh4ZtQSqMgl53N5cgG4UyG2+IxoYnBvRcxAiXRz43Ly3Qyi1KIa0t3q/os9owBomGBhsokyI2J37E/rOUlaWvtICu52Rr9teMbygmBNW1/vmk4DBiAViXE9BQTjcsIJmD6ygS7aKGP+ZsO/w8mccEViX5f/iGsWY85iy3aqQpdOzRUyTXf7+hXEDvcsVZSv2tREOuwm5FlRr7
 p69rCur+
 z1NjcevgWwIMCLsVVkX/k+Y6BQfYks4tciMTfBVwjRsG6bGjTqEy4yF+a5uqdVB10Z/IgPBMYMywM7EIBvW/ScGrduURm3eYWEJ+2jeBJef3MUb5FA/KL3/FenHPcZcyU5lqZO2SB4dNevzKpb/77LPAnnXauMF2h8Q9saUCxivmltd33WdfbY5C7UmfxXaz4NdMghs2Lhpbt0EUhjbYzJWS5Wa4O+O3D8lHeCdjyu51H254niopEcAye4J3AcPB1vhF0ki7mryPOMX716tNoBHHlD17Ti2iAYPNKI3kD++TlmNAkchedi7zNZM0AIF4Zpd7hw2wci9V0hlo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hongfu Li <lihongfu@kylinos.cn>

alloc_hugetlb_folio_reserve() hands out a folio from the hugetlb pool and
consumes a global reservation, but unlike the fault path it never charged
the folio to the hugetlb cgroup or to the memcg.  Folios allocated for
memfd_pin_folios() through memfd_alloc_folio() were therefore silently
bypassing the accounting: they are never charged to the hugetlb cgroup
usage counter (hugetlb.<size>.current or hugetlb.<size>.usage_in_bytes),
so the limits (hugetlb.<size>.max or hugetlb.<size>.limit_in_bytes) are
bypassed.  In cgroup v2, with memory_hugetlb_accounting enabled, these
folios are also not accounted in memory.current and are not bounded by
memory.max.

Charge the folios to both the hugetlb cgroup and the memcg, just like
hugetlb_alloc_folio() does.

Test with a process that creates a hugetlb memfd and pins pages through
UDMABUF_CREATE. The counters were read while the folio was still pinned:

Before this patch:
$ echo $$ > /sys/fs/cgroup/test/cgroup.procs
$ ./memfd-alloc-folio 1 &
$ cat /sys/fs/cgroup/test/hugetlb.2MB.current
0
$ cat /sys/fs/cgroup/test/memory.current
1351680
$

After this patch:
$ echo $$ > /sys/fs/cgroup/test/cgroup.procs
$ ./memfd-alloc-folio 1 &
$ cat /sys/fs/cgroup/test/hugetlb.2MB.current
2097152
$ cat /sys/fs/cgroup/test/memory.current
3313664
$

memfd_pin_folios() can now fail because the memcg charge fails. Two
tasks allocating concurrently against the same memory.max may see a
spurious failure. That failure frees the folio, returns the global
reservation, and undoes the hugetlb cgroup charge, so no accounting is
left behind.

Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Cc: stable@vger.kernel.org
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
---
Changes in v3:
- Updated the commit message to describe the new -ENOMEM condition on
  memfd_pin_folios() when the memcg charge fails, as suggested by
  Gregory Price.
- Added Gregory Price's Reviewed-by and Tested-by tags.

Changes in v2:
- Rebased on a tree that includes Daehyeon's "mm/hugetlb_cgroup: prevent
  use-after-free during cgroup offlining", as suggested by Andrew Morton.
  No functional change.
- Since 268d64fabbf1 ("mm/hugetlb: fix NR_HUGETLB accounting for surplus
  folios") reworked the NR_HUGETLB accounting, use mod_hugetlb_memcg_state()
  instead of lruvec_stat_mod_folio(), called after a successful memcg
  charge.
- Return early once a folio has been dequeued, instead of falling
  through to a shared return.
- Corrected the Fixes tag to 89c1905d9c14.
- Updated the commit message to qualify the memory.max claim: only in
  cgroup v2 with memory_hugetlb_accounting enabled.
---
 mm/hugetlb.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da1c17f14a62..256bb2095b59 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2223,12 +2223,19 @@ struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask, gfp_t gfp_mask)
 {
+	struct hugetlb_cgroup *h_cg = NULL;
+	size_t nr_pages = pages_per_huge_page(h);
 	struct folio *folio;
+	int idx = hstate_index(h);
+	int ret;
+
+	if (hugetlb_cgroup_charge_cgroup(idx, nr_pages, &h_cg))
+		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
 	if (!h->resv_huge_pages) {
 		spin_unlock_irq(&hugetlb_lock);
-		return NULL;
+		goto err_uncharge_hugetlb_cgroup;
 	}
 
 	folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask, preferred_nid,
@@ -2236,11 +2243,31 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 	if (folio) {
 		folio_set_hugetlb_restore_reserve(folio);
 		h->resv_huge_pages--;
-	}
+		hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, folio);
 
+		spin_unlock_irq(&hugetlb_lock);
+
+		ret = mem_cgroup_charge_hugetlb(folio, current->mm,
+						gfp_mask | __GFP_RETRY_MAYFAIL);
+		if (ret == -ENOMEM) {
+			folio_put(folio);
+			/*
+			 * Skip uncharging hugetlb_cgroup since the charges
+			 * were committed to the folio and freeing the folio
+			 * would have cleared those up.
+			 */
+			return NULL;
+		}
+
+		mod_hugetlb_memcg_state(folio, nr_pages);
+
+		return folio;
+	}
 	spin_unlock_irq(&hugetlb_lock);
 
-	return folio;
+err_uncharge_hugetlb_cgroup:
+	hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg);
+	return NULL;
 }
 
 /* folio migration callback function */

---
base-commit: 2c5dafa7f289d760f4492260b0988029aab478b0
change-id: 20261109-for-alloc_hugetlb-1109-0ccac58e69d1

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


