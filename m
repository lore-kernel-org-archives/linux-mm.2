Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 298FC606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 22:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qwer52Hj
Received: by kanga.kvack.org (Postfix)
	id 206E06B00EF; Fri, 30 Oct 2026 18:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 191086B05B1; Fri, 30 Oct 2026 18:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033C26B05B2; Fri, 30 Oct 2026 18:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBE6B6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 18:29:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 542F1805F6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:29:26 +0000 (UTC)
X-FDA: 85380735132.10.5786A70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 89D1CC0002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:29:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qwer52Hj;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793399364;
	b=J5IHNaTyspPxZSH1FL8NCIHd8+okysOZXgZvRXgxejxDF0qAbhJ2VASvyFgT97TGMULYUh
	mTJP2pR8tv42mQhAwoV/sHD4LcKbh12ZX2NcMZ95AEsbxLOK+aQN4BxcUAa+L6UTBgDimD
	SKwOlFV6iGA1yhHy5yLBTaUwv47gtrw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793399364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dLDtdwl/TQOX1alCsSuKQovIt8rojZpgzJ91qw+1M1M=;
	b=OLSXsQTbMa94XrDP44y2lu4QoUDK0Xq40uW8PrV5JBINoTXR98hNEYHC1exYroK5A/Fs7/
	2Xmfl7FBFFc7woNMvrPxuZW268oWzlM4a4/855tm5WYRWUjvJTP/bsUNwnZRCbDxJq5y9Y
	IcCD8OoAsW41/HAsPVF/UCqdVQXBZ8A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qwer52Hj;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E1BC601EE;
	Fri, 30 Oct 2026 22:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC1C1F000C1;
	Fri, 30 Oct 2026 22:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793399363;
	bh=dLDtdwl/TQOX1alCsSuKQovIt8rojZpgzJ91qw+1M1M=;
	h=From:Date:Subject:To:Cc;
	b=Qwer52HjSNACQ/YTSK005xD2/1Rkq4AV5LGO2/uKDYD+KXgoRbAQ8bjtuZ7EQloPk
	 uKEk8gDG726+KLhvq7vQ7xCQZ1372w2pBkSM5KcynOkSPA8Zw3pQ27T5/2sT+Vxvs6
	 GCBHXYelsp+lZq5tBDNGQ3bQV9l7iKwBSr/tYa4slWQGF6H0yvakEyQ09fnnGU1Bgy
	 F2dBwAMQ1KzrXKkX5R6cxIMzLj1D/Grc1IBehR21ZuvyXQO/7epZA1dzJ2RFAYFPHs
	 KwtvHHQMaCZyYJOr+lbBKgSWgBCLDwN6+AvLvkAPOganXfaWcAc4zgy45J+8MQCALk
	 k3c6YCNhYiRSA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 30 Oct 2026 23:29:13 +0100
Subject: [PATCH v2] mm/memory-failure: fix folio refcount leak and
 min_order_for_split() locking
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-try_to_split_thp_page-v2-1-c957c9b42eab@kernel.org>
X-B4-Tracking: v=1; b=H4sIADga5WoC/4WNQQ6CMBBFr0K6tqa0gsWV9zCkqTDAKKHNtBIJ4
 e4WPYDLl7z//soCEEJgl2xlBDMGdFMCechYM9ipB45tYiaFLIUWJY+0mOhM8CNGEwdvvE2SVUX
 VnVrdVKJjaesJOnx/u7f6x+F1f0AT99huDBiio+V7POe79+9jznnOrSwqUEqfQenrE2iC8eioZ
 /W2bR+qsti4zQAAAA==
X-Change-ID: 20260806-try_to_split_thp_page-a359f4d8c90f
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Wei Yang <richard.weiyang@gmail.com>, Nico Pache <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Luis Chamberlain <mcgrof@kernel.org>, Tal Zussman <tz2294@columbia.edu>, 
 Li Youhong <liyouhong@kylinos.cn>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6794; i=david@kernel.org;
 h=from:subject:message-id; bh=zPhj2fcNOfjvbM8UZ+0SfU7LezHBma1fbJ46FG4Yrgg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKeStnkH3yX82lhdspUF0meKZLqvZPUG6ZnZUwTCvLwO
 DCpZZJeRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABO5KcvIcGz2jbtxazI229rK
 Cfe92XruzQY3nTX5X6r94hSzJ6wWF2H4zfptzu0H3/VNoy7sPS5zNeTn0+0lZrVb+Hcsksptzhb
 cwAgA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: ntimg1wc8kwxcr3qmfu5myosjkc35pru
X-Rspamd-Queue-Id: 89D1CC0002
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793399364-478495
X-HE-Meta: U2FsdGVkX18BJ0hk0BtFtq4bu6DcLnzNTdmM3jPLTo4m2YFN3s5vgYCWgeAT8gb+mfndLAfjMAa11x2yjv8dKCXOFq8oQVItEuJo+lJdT5Q/92seoRbN4zM/4lDNqRwcvYt60tGlm4KhetbHWR3DaSTsPql4pMGDrMKO0Cx2DI/2/k1tG6504uf3JNtMwMZq+7vvPE3zg9ldtklF1xwVhAvgqU0Oy+ffBc+2ja+AGmGjFvOplF+J7k7/XIw+hvgih0mdrDkVQXMod5MuJCr7R2TTHrcyUaQx7A6UeYZ7pBF0qBl0XHFiTgajVhlprxk5xeEt8LDiDjRdEHz5I9Eft9Gk09vCmb5gB9bvq+laYbtElJo0NpfmxF0wTRvXtdUA+bdPLQdyXV2Wi7bqHYtsLg7tO+Ve9yDvHDohAQbh+xePL4buDQgHrzfmnJCHJdI6NQnfoUL72IYL9qEH2EBdTtX//JRsj1yvuascOdyjUDvw/yumUOl8dkAt6CAuvBYrIoKMPlrgNCyFD32GbBdogKruMjALSdZNc8wBwNT3WStLzSZvdOovOcBeWcKfzkhGd4XyZnlaSdoeFtVt3ytZCQrWFB/bNQa7suQot4kkADxfB86vOMiCPlMyNA+wWD0J4TMqWroWFjYsx11M0ncYtTQheVXHXbjM2cWWJdnuTXpy6bIb2J90MTVC7R2qnbMvNIrLjas/qCq+jpPCru8nRPM+jm5y/m/jCpC7iKwXBn2/A72t1o5XPCp9cEoghc+q3G/8ZnRbIU2GW18BGleRpMp1ODvdrGH99eINpzXVmCYXGDFM+dunlWuFFXuXsiSwdoXsxaQHHpo4XdfTNFr8HxPqMc1Bv2QdEMjbwrN6nlkqAPp1ic4sJlD2rm9I/UFcjIWju0QADC+DbpMtuHryVLsa30yA1QliUqOWFyzYPzodKUoXfo7u5XySEVhTejFFXu/L9rWhdGKVFhL6sg0
 laiiwkkE
 U+MyT3E7+eOvOVpTXe3xg//PAEVvuAVj59+9x1DiO4Das8JRahSGafk64uDqOiG9Eypi7vUNsPu5gerwYcULXyxxepneFAQl1CGDn/Hiki53cuVynK5dGRBJrcg1gRJPmXx+T1y8dBu+dn828KHr+OgvKp6/m1C5g04psUiIr4jlgHHTeywybHcdjCo74FarRIek3SEfZcDRP+QuBGlZUOsDYEnmVc0tnG1/FwUlrwvXRO9PvjLG37RdCVvLIQ4kLiLFrer9F/kgKHMd5JC+TLy4ezZcGOUHYBgsLExt9O1mxmmR343TTMKMe4wfN3yftg9U6J4sPJcjWD3u1UxEZm0ITM4Jl+ArVtg+5vo4K1BBS6vjRc7uPVDBXu+d0K42qCWEvrbiCSbFo7nGM4w/RmF8YtPUS8QQpGqITY7wcHaThEvfFNBWRPmgK7ComjH3aAqCWoGfsf5mAx6aCUUbj92fPPPyHkmdUAObb+3R39LI5GV/PtxsqgnoLdbsGfvWuBqgpOTWCf7Tk2X5cr37cO36zIgBpxQXm3iBt9rSzZvNPv6uRQl1HTflFYR8wBrcl4Sxv/of3Rqbxjv9U/z/rmDmMkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hwpoison code can end up calling min_order_for_split() without holding
the folio lock. There isn't really something that would prevent
concurrent folio split. Consequently folio->mapping can get set to
NULL after checking for "!folio->mapping", and if the compiler
reloads folio->mapping, mapping_min_folio_order() would try to
dereference NULL.

While very unlikely to happen in practice, let's just enforce that
min_order_for_split() is called with the folio lock held. We can
significantly cleanup the calling hwpoison code, and just get rid
of try_to_split_thp_page() to hold the folio lock for a bit longer.

Just work on folios now, which further cleans up the code. We just
have to be careful about doing the page_folio() after splitting, which
we have to do already either way. Do not change the way we split for
now, this needs more thought and should be done separately.

Cleaning this up we fix another issue: in soft_offline_in_use_page(), we
would currently have leaked a folio reference.

In min_order_for_split(), document and assert that we need the folio lock.
Drop the questionable VM_BUG_ON_PAGE(!page_count(p), p) check entirely.

While updating the comment in soft_offline_in_use_page(), just drop the
"NOTE" part that does not add any value to current code.

The folio->mapping problem was identified by Sashiko, and Li Youhong
reported it by sending a proposal fix.

This likely does not really warrant CCing stable, but I expect little
conflicts when doing the backport, so let's just CC stable because of
the refcount leak.

Reported-by: Li Youhong <liyouhong@kylinos.cn>
Closes: https://lore.kernel.org/r/20260804035828.2684059-1-dayou5941@163.com
Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v2:
- Drop NOTE comment and don't reference new_order.
- Fixup description and add that we are dropping the NOTE
- Pick up tags
- Link to v1: https://patch.msgid.link/20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org
---
 mm/huge_memory.c    |  4 ++++
 mm/memory-failure.c | 63 ++++++++++++++++++-----------------------------------
 2 files changed, 25 insertions(+), 42 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e86845..5d5afefda649e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4490,10 +4490,14 @@ int folio_split(struct folio *folio, unsigned int new_order,
  * If a file-backed folio is truncated, 0 will be returned. Any subsequent
  * split attempt should get -EBUSY from split checking code.
  *
+ * Context: @folio must be locked.
+ *
  * Return: @folio's minimum order for split
  */
 unsigned int min_order_for_split(struct folio *folio)
 {
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
 	if (folio_test_anon(folio))
 		return 0;
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b705f9f97f420..12aa4e52b2bce 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1744,26 +1744,6 @@ static int identify_page_state(unsigned long pfn, struct page *p,
 	return page_action(ps, p, pfn);
 }
 
-/*
- * When 'release' is 'false', it means that if thp split has failed,
- * there is still more to do, hence the page refcount we took earlier
- * is still needed.
- */
-static int try_to_split_thp_page(struct page *page, unsigned int new_order,
-		bool release)
-{
-	int ret;
-
-	lock_page(page);
-	ret = split_huge_page_to_order(page, new_order);
-	unlock_page(page);
-
-	if (ret && release)
-		put_page(page);
-
-	return ret;
-}
-
 static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
 		struct address_space *mapping, pgoff_t index, int flags)
 {
@@ -2548,9 +2528,6 @@ int memory_failure(unsigned long pfn, int flags)
 	folio_unlock(folio);
 
 	if (folio_test_large(folio)) {
-		const int new_order = min_order_for_split(folio);
-		int err;
-
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
@@ -2565,24 +2542,25 @@ int memory_failure(unsigned long pfn, int flags)
 		 * page is a valid handlable page.
 		 */
 		folio_set_has_hwpoisoned(folio);
-		err = try_to_split_thp_page(p, new_order, /* release= */ false);
+
+		folio_lock(folio);
+		split_huge_page_to_order(p, min_order_for_split(folio));
+		folio = page_folio(p);
+		folio_unlock(folio);
+
 		/*
 		 * If splitting a folio to order-0 fails, kill the process.
 		 * Split the folio regardless to minimize unusable pages.
 		 * Because the memory failure code cannot handle large
 		 * folios, this split is always treated as if it failed.
 		 */
-		if (err || new_order) {
-			/* get folio again in case the original one is split */
-			folio = page_folio(p);
+		if (folio_test_large(folio)) {
 			res = -EHWPOISON;
 			kill_procs_now(p, pfn, flags, folio);
-			put_page(p);
+			folio_put(folio);
 			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
 			goto unlock_mutex;
 		}
-		VM_BUG_ON_PAGE(!page_count(p), p);
-		folio = page_folio(p);
 	}
 
 	/*
@@ -2900,25 +2878,26 @@ static int soft_offline_in_use_page(struct page *page)
 		.reason = MR_MEMORY_FAILURE,
 	};
 
+	folio_lock(folio);
 	if (!huge && folio_test_large(folio)) {
-		const int new_order = min_order_for_split(folio);
-
 		/*
-		 * If new_order (target split order) is not 0, do not split the
-		 * folio at all to retain the still accessible large folio.
-		 * NOTE: if minimizing the number of soft offline pages is
-		 * preferred, split it to non-zero new_order like it is done in
-		 * memory_failure().
+		 * If we cannot split to order-0, do not split the folio at all
+		 * to retain the still accessible large folio.
 		 */
-		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
-						       /* release= */ true)) {
+		if (!min_order_for_split(folio))
+			ret = split_huge_page_to_order(page, 0) ? -EBUSY : 0;
+		else
+			ret = -EBUSY;
+		folio = page_folio(page);
+
+		if (ret) {
+			folio_unlock(folio);
+			folio_put(folio);
 			pr_info("%#lx: thp split failed\n", pfn);
-			return -EBUSY;
+			return ret;
 		}
-		folio = page_folio(page);
 	}
 
-	folio_lock(folio);
 	if (!huge)
 		folio_wait_writeback(folio);
 	if (PageHWPoison(page)) {

---

base-commit: abf8c33470f78e2226ee3dcdc69004660020ab47

change-id: 20260806-try_to_split_thp_page-a359f4d8c90f

--

Cheers,

David


