Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1E09606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aV6LHwkJ
Received: by kanga.kvack.org (Postfix)
	id 754A76B05C4; Mon, 16 Nov 2026 13:31:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705FC6B05C5; Mon, 16 Nov 2026 13:31:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CDBF6B05C6; Mon, 16 Nov 2026 13:31:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB786B05C4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:31:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8FB411C2CC6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:31:23 +0000 (UTC)
X-FDA: 85441824846.29.C8DC57E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id AFE13160010
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:31:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aV6LHwkJ;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ll3asYuiuZ79eATlz0yEAcompJfGJnlC9CkPVberbcg=;
	b=mmmolMpQJqyqW2S+zsOaaSWgdJyDiRZlahxiIomRxsmY0E11nhWnaoMK8w5dO9hiriv4dr
	msYlesAf4dYqNUsP6wkzEfDq2yUbbE7c2p1FyHnb0FGimAtOnFk6qbkteGRhZy6R+2rJ1g
	3aSa9SjoYvsRlImj5lyeVfLTNLuBlkw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aV6LHwkJ;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853881;
	b=ATTQP3w3JpYvKKqcskis0dpjZlwqf5nwPbELTj/2f85iktqoygdbctg108KrxEYOo25SvS
	tz5U67cOFCy67eGUVnVO4GqoIehIi5qw/WzxALMCnAdkNeEP+XZHthcF5K2ShNHJg/Z9tp
	3joTIpDSnQXOZbh7feuStxESXjE5vlE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F0AEF41F9A;
	Mon, 16 Nov 2026 18:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC6A1F000C9;
	Mon, 16 Nov 2026 18:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853880;
	bh=ll3asYuiuZ79eATlz0yEAcompJfGJnlC9CkPVberbcg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aV6LHwkJ65YIOBZzlGD2MLT816Fhf7JiPdkgh9tZNaCgbT8HNSC1K9+I4/0gjqRK1
	 cVt8ZI5h9r0Br8OUrwGsPOtMHUlWnvTED5hkhFLCzMSpz7x2xIK4uE4P0JSSNzfUmG
	 24Yqjo6x0GHwxY9K7LZPpKqqor2oN8sYJ1n0Ga1BLgA3XBwqu3zP6g7QSIaugXpb+w
	 MT86UsoghGDyQfJU6uFNFwETHiQOP0BgtnG9NcWGBR34EpLxfg5fIlo3sRR+FOXOy0
	 CM83pYgPHFll+SfnIaPhVVy6m++XI15nfp4Zw2rKbyGQ1dJ1P369m28AujKxA2hluX
	 tsKXUN37L1pfw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 19:29:31 +0100
Subject: [PATCH v2 10/15] mm/hugetlb: count again if the reserve map shrank
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-fixes_hugetlb-v2-10-4dd9e94ea9ac@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6751; i=david@kernel.org;
 h=from:subject:message-id; bh=pjdR88mv7+rpLICVRcSvJB2NuhqdX1kITUt5B5uk0C4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e3c6nm8Q/Wp546FVUle8uvfENI+8ax6hrfriLDvv6
 kxb5+DTUcrCIMbBICumyBIUfN/g5ct1tdVufMwwc1iZQIYwcHEKwEQsbjP8d3t5cIX6/cXr/e/8
 9pzewRpX9ETChzX4Z4f6KcOfz/UPHWNkuBpspJz/T/B1UKMnX1FjnPPlp5M9KtKuM+Xc/XdR/+w
 CTgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9bddyw54ehqn7q195cpyweqgp6bn8sn4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AFE13160010
X-Rspam-User: 
X-HE-Tag: 1794853881-7913
X-HE-Meta: U2FsdGVkX18ZU3/K7z7LK1f957lMiQRfeJJuCH58qQ3LxS8eNwJSOig6ITQvb+b9kRfXX0lml7TKEzZu8NqQ/NlFaCPJSafuvONswJrv0y7TLkGLXxRoGJr4p8olGE2zL5FbW/ymdzkRXrEUUNMNDVFMy4iGOXrPF1rOPMnKjNged9Ch/UedCXl0/PJzufFy8lb7SBRnJ0pTsAoY6NOf3q/SbhZKISysy8sCFfZwaHLEDvkZpI1qTgqlaZ6HbRNEwm4ZOKLrX9sQBFNnAj/oM4ZU5hk4mFtMcpRo4AzTYdDeQoOXNwFUvpxhYq40xkoqz6aw19LgF9CxnRU6AsUA0Iu36OCpIo8BroU9f1z9ha5q6tIcvzlnfHozdQ1qHeKc0TS4FUHm4om7MtBHg58P+Yd68Xu2yvRIkCom4010z3WGIpE82aAMB/rhnFusJHK9j+d8yQhvfbCHTFG5K2pk11hqH71BSZ9OtY3CXglfrh6k6WRI2WreJe+Yd2wkC6mIvoolEUCHfY+8oR9jVhZsDqzssVM4oNTMi7Qi0++JH7RSzhOttFbnfMTpEYy+kvNuT6a5eq8UDqJlctX2E5jlW3d2bRxOaZFwHiCll3Ihwzf1TaSVTfKky91YeiiaQC/OgVjDGZcJlBOesw+srlQ1LayQFb1orovE4Qq3lSXS0dnfVVgPIHNBEQr4e0SqRM6XT6QGisES1rmbpstNsRKQFStlSFxccAIP9dckJoSUFRnai8wcBMc0VL5xW1UlKFW+c17RtHd3Y469YErUpd8zLf9gPJtWb/NphTR+umP5V5VBJLBDoRTa0WX5xU998CPyuteBAHVLG9Igm5+Qh9W1deK32LrHAXOES07jBKzHDNwVIl9SDm5ruMtatPvO/tSE/lG/yC7sagCiF7KryJJWrru9oLnofXUP7Yghpcp4BP8yEusV0mAkUWhKxcOd7Ts24wPVQvE8x87zkpufZKn
 aEa0vSHE
 Ac/5ildqZaT6fVf+LH2CBXKMAtpfwbQp9dJjWWwiEvW5jlOtyYHOqPrk7I2IcIGsW+vhafZQ+DaBxNzctCuPd36tGikgbxIVAbKJf7KNUnLlxm76FfOFefYfEHBGw91miXU35bfBKtD/1HpISgDXA4W17oxo/lfcflkAAj84FA0oSQ+7R/WxPao0lw2r7pyNBAa+92O/D+nzHahi5uVOOPXvJNs3sOog/wEopZOj2QYBo+z9YWjt07fUJAzcUaUl+9fgu17tyD452KjBjoXDyfJQb6WUXlTytXdHfh7rvE/1HsP3QRoPK+1ENVAEGc7RueD9nBKqDm+dF9qAApwLZiSVPdCm7oWIfIYgCT4nSdTr3lMWAvx5jR2bz76yXDPJ2lI7T
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
index 3d8eebdca5136..112fa25f36833 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -739,26 +739,36 @@ static int allocate_file_region_entries(struct resv_map *resv,
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
@@ -794,6 +804,13 @@ static long region_add(struct resv_map *resv, long f, long t,
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
@@ -6847,7 +6864,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
 	long gbl_reserve, regions_needed = 0;
-	int err;
+	int err, retries = 0;
 
 	/* This should never happen */
 	if (from > to) {
@@ -6869,6 +6886,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	if (vma_flags_test(&vma_flags, VMA_NORESERVE_BIT))
 		return 0;
 
+retry:
 	/*
 	 * Shared mappings base their reservation on the number of pages that
 	 * are already allocated on behalf of the file. Private mappings need
@@ -6947,7 +6965,8 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * else has to be done for private mappings here
 	 */
 	if (!vma || vma_test(vma, VMA_MAYSHARE_BIT)) {
-		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
+		add = region_add_limited(resv_map, from, to, regions_needed, h,
+					 h_cg, chg);
 
 		if (unlikely(add < 0)) {
 			hugetlb_acct_memory(h, -gbl_reserve);
@@ -7010,17 +7029,28 @@ long hugetlb_reserve_pages(struct inode *inode,
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
2.56.1


