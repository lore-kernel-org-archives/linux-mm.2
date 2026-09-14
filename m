Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E188C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1BDD6B00A0; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE56E6B0096; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2AA6B009B; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CFFD6B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E02A81C1848
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:56 +0000 (UTC)
X-FDA: 85213020312.25.2B68980
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CD8C410000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jWGpCUfE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406154;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VYhTgmENuwvZGsNeandnCdGRcFuKSBt0JKsplO99bg=;
	b=0vgJuown0X1ARUoygLiDqjdb231rvss+ER+hlC6HcIDXbVYXn4tSt1ea8DNENTea1IvH4v
	eGUAD40fGPLMJfOilwsofD/ClxTCwkKgwXhA6zTXLumznzRB1uOQtpSzPNPy2HAKTFfVpK
	5Lu5NHSVHATHq1hT/YblcRwnFmNWs8g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406154;
	b=Pauwg8tLCD17mQYgzzHBV0pwwr4VZr7TMLtlwsqqRRBSV5MYsPFus1cYhY0k+Srih6lrlo
	zL3HF53jyw7Q3dUAuU2UXeKjCcFaFTvEp29Wm1WC9zUfZsZJIYZHF2gX8WlCs0UfZI3RC9
	f4PESoyDb+bOLZPcrtN+7tfBV15VGrc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jWGpCUfE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C8B9943E41;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9D43C2BD00;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406153;
	bh=tmqSHbyI6Xb4v64GvXcWWq54HgIvyBGsHeSU+Ycg1js=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jWGpCUfEg/3UkU4Gw2pwweRoRvr07L+ns78LHjMYp5ds2kWOttIDRVL9RVQiBi6+8
	 Qwu9B6wA3gODhk9iEUYBqzSF3ZNMOTzxaEFPnfZdUnalksoKKoViBni33OssQLTRtE
	 SOjZKhUaGeMusBEcuQzDMD64R+Ik3uS0MW6e1nm9jY/0OeItiIkrZI/64qoylbVM7V
	 nGUStS18P9LrySYwxaEXugAQmxRfmfPATcVPcbsZEYct2AWZqEDeBaQYEeBCP9WBwZ
	 SlZm9ETDyQJyBQ+InxRiGN8Z/uAW8YvOt5iaScWhi7KJbDHOxwLEOwDdV4gIGQDgj2
	 73DXIyC6B1ZHA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3CAC88E78;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:43 +0800
Subject: [PATCH v5 02/17] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-2-39878b37dfb0@tencent.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
In-Reply-To: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=3844;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=os8GAwRhiIAeYozzDiYE5/qpjgUr240Y6fX1iEFFm7o=;
 b=x/Xr68PDIC2GidVJPvhZOkF4fMPuURDvqo9AMcQPkTXq+N/nZXOj+Qides9OL/uE6BsYnEoi0
 yp8AJJq1p7ZCESo/T6+fI8f/sEtTrNCP8wjue0YaiDEN6vRXpRmwBni
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CD8C410000A
X-Stat-Signature: bnwcrsefxaswzycpn6rqnyr6tneh8afb
X-HE-Tag: 1789406154-267170
X-HE-Meta: U2FsdGVkX1+hoggDZFVw5iLPVN7nPJbfvfcRjaxPpzS8q+OeJNYV3gHflsB1648KZi41juRYVnz+7fiZ2OaCvH1aMvii87C/utRM9RjCYE2uzncJmYZBuS0IkKgt4CY0+j1EPuCUM/+t0Okc7jOaOfS84WgeumY6spnaF1I2+TtlXVXlHcSsdTtfUdKjXODp0RjrxYedDX15yy2sydqUGyo7AEFSe3FTZ546a4LViigzGpzMiZqsybIUbSxuP9QUgskwyxv0yGj7xS/LsPLtOxhfHYHxTMZp3Oa1GmThzSaNftxuFtzkoq5Qv5kMhSzYDgCgeBWSISsZLegAcBafS71yMpWPd56xlapI32pb2e5GWTrBcKVNqaYlFkd0Hv+mDnWrbeitQXq3zSbcGxqx8RWhT69WquW3FSLdCexnOoYDzAWZ8eCtIZWTHEhvle8Bv5bk50leENyACi6EdNdQe7DWIJgW6LqiyJ+9Dr3bZ256ynsbrhtGwSpSLJOmWCwpbHgkyQZNqlFoWCEnjG/lKi4tv404EIlPTAwvJAUCYDXtFAGaZCzrQ+kx5xXKy43VGpl+5hHHjgtovVWojW+ja64MwIwub+qv9MEN6KdzVzRhjX8GK/h7cjTPPNNqOp3FjWcE77ZWow3a8MorBHwlq+Th8IIwNW3GC6ShHFkMSVfHW/XeNpZKSEPPc74+FP4IceZtJeL7AIQ9hCkiBZo0CbpPPgliFQVPIkRpvWUmysl6mWsEkLQ3vevKUEAX7RH/LjK1cJeIMJw/yRNLQrGMbeF+hDomvAjw0z7TNDCgcffua9QEjq8Ly/YfapZsE/0KN0MKsnSqYA04OKkmgq7GsYUQU7a+LIc5+3nAGsemOL/ma8Z8tIEUEPeXhAaIIWnGPgQnVgF7ntzTwxR5MMwQv234gKI4jnqJocdL8CRMO2TZZ1xkWD7eXI1AtR2dkx+25b2yAn/W27Ca2xErO+Z
 dlk2kIMV
 16t2QEV8fmyYV11DPZAhz8iKnD3511QSW3l5FbjuxVdungPdTYNyMPIOhcblaexMlVXvIsxcDHJ01mq9X6Kg/mH5ngvAAgJ/xYxzwmjQ6TDm6vHTBybbsZFZx6ZIzJa4zBHjem7ZdkwCZFcGubvqrV4gQS5eP7ZfZayihavvZ3YOXsc0XHuGrWC7rJzSZLma3jV0ZRK/aBm1zZ4RISNGRYo/x2swvdwO7hdwXsOZBGU+32qv/KB0gYVhiq+iNalbySYNxBaURXJ1KhFc9dZ1StHPziUyvMG+H0bWGBIFhL+c+yHbR3R0lP/AFv7u42o8h0+m3EIAMGiBFBzcpsMOHYL5UrpsbKVQAg/ydG5Ph3uF4bMz7m7TccikJIcTtX92LxBtThFSNQC0aH1GJ7zAkT3b/0YlPllXKDDFgPNwaf2DNeJmgKsQC/Eba7R/vuLtIMtEEiO15w6j+Uj/zneZ4uE+EpHcIIBiPFT09ZR0C5e0bgrieiF3n3cCGFMW2FKPxoag3OuKD+expzYdWmysZMh80aYxerMTRi96MWWYesUZkQjPB5pKQCgXsIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

A folio in the swap cache cannot be split if it has a mapping (shmem).
The split code does a defensive check for this in
__folio_freeze_and_split_unmapped, after the folio ref has been frozen
and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
rejects the split and returns -EINVAL without unfreezing the folio or
restoring the counters.

That error path is buggy, if it is ever taken. It leaves the folio
frozen and stuck, skews the counters, and fires the
VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.

Check for this case up front in folio_check_splittable and return
-EBUSY before any state is modified, so the split routine always backs
out cleanly.

Also fix a bracket style issue that checkpatch.pl keeps complaining
about.

Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7140a1031fb2..351e8893808b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3934,6 +3934,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type)
 {
+	const bool is_anon = folio_test_anon(folio);
+	const bool is_swapcache = folio_test_swapcache(folio);
+
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	/*
 	 * Folios that just got truncated cannot get split. Signal to the
@@ -3942,11 +3945,11 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * TODO: this will also currently refuse folios without a mapping in the
 	 * swapcache (shmem or to-be-anon folios).
 	 */
-	if (!folio->mapping && !folio_test_anon(folio))
+	if (!folio->mapping && !is_anon)
 		return -EBUSY;
 
 	/* order-1 is not supported for anonymous THP. */
-	if (folio_test_anon(folio) && new_order == 1)
+	if (is_anon && new_order == 1)
 		return -EINVAL;
 
 	/*
@@ -3957,7 +3960,7 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * swapcache folio split. Only uniform split to order-0 can be used
 	 * here.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio))
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && is_swapcache)
 		return -EINVAL;
 
 	if (is_huge_zero_folio(folio))
@@ -3966,6 +3969,15 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	if (folio_test_writeback(folio))
 		return -EBUSY;
 
+	/*
+	 * A non-anon swapcache folio that still has a mapping can only be a
+	 * shmem folio under SWAP IO, it's removed from either swap cache or
+	 * shmem mapping afterward. There is little benefit in splitting them
+	 * hence reject it here up front before touching anything.
+	 */
+	if (!is_anon && is_swapcache && folio->mapping)
+		return -EBUSY;
+
 	return 0;
 }
 
@@ -4038,14 +4050,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			}
 		}
 
-		if (folio_test_swapcache(folio)) {
-			if (mapping) {
-				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
-				return -EINVAL;
-			}
-
+		if (folio_test_swapcache(folio))
 			ci = swap_cluster_get_and_lock(folio);
-		}
 
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 		if (do_lru)

-- 
2.55.0



