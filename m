Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E98D260A2606
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gAE0xBd8
Received: by kanga.kvack.org (Postfix)
	id 099066B05B8; Wed, 28 Oct 2026 16:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0488E6B05B9; Wed, 28 Oct 2026 16:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2CC86B05BA; Wed, 28 Oct 2026 16:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE48E6B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:14:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A9CC8011D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:16 +0000 (UTC)
X-FDA: 85373136912.18.83A2484
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 693CF40008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gAE0xBd8;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qEBctXhmn4h5YyAOB0r8W63ghO8tdi+PNnWiA8yCOpA=;
	b=G4SfCFDAHySu71zkgaTvdKn8s32mn7UgxDYX33NEHqWYz4n+JlcwGHR4gkPSCH5jsycjTD
	GvqHZT7IepLr3J4XPmewYCgeNFYb/I5pJ3d5PdGe3aM1N3EdQAKknLlKbWhHTz8IUa158i
	iKHOhmLW3yWGgGqOl8PHCu6rLql+jlk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218454;
	b=LvEYAmJycoAvTkeWoNURImhmFxZt672b3UxVJLOzM+gSgPGn6Li2tgFdQ2WH0hjWppk219
	JcBW7ftojJbdjOEKEXIFeakb4rYyIiuZZkMvVIJ3GvozjulmGRdXFICA1AvF0D3johAqYe
	ZgYWUPddyod0lE7ZjHT0fCTeUCF9z/E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gAE0xBd8;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B78160232;
	Wed, 28 Oct 2026 20:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53671F01825;
	Wed, 28 Oct 2026 20:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218453;
	bh=qEBctXhmn4h5YyAOB0r8W63ghO8tdi+PNnWiA8yCOpA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gAE0xBd8fJHcKjRT9ms2IAxmhPu/nKhwS/b5GZa2xV+OeRrYHiDFxM8NxJ4KMecJ+
	 3EhtquudZNVaihZXb35hXL+2IwbANf6KABKqncm2c81z3yeHdh3B1yKwbzeAf9EAId
	 ivR/W9uCcXiqEwPFWcSnvOZuQ5OClOelI9zD44uFcIsZmkbo5wIxAi/mVJScOrqxwp
	 jaDN7TAw4JUEDZ1IwL4djohnzOtUb+N4bylhGmAX6C568XaQCsWYoHqgVw4K+iZwKR
	 PiAf0k1koxMdIyzmCyqsscGTLC7hc+UqjcAtMskoKDDgZfyuVqvINrgiITAfJkEM3L
	 HwBpH8nhU1FPg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:30 +0100
Subject: [PATCH 02/15] mm/hugetlb: compare against persistent count when
 freeing lowmem folios
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-2-a0a033db180f@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1943; i=david@kernel.org;
 h=from:subject:message-id; bh=Rd6aso6VgETc53Dh/h6R4OrmZ5cP92PBFstwxhi7Wzo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZeu673RsWBlee3MBYxi+ba6dbx33waIf53VlrVmk
 uz9q3tzOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiI7GSG/9HZR48me92XnvUw
 kzFJgLU2efmeZj6tq/cenjLeJrjMgJnhf+baewHSn7tOrE8/FPVn7uFXJdX3dI8xfXjCc8+E/VZ
 mBAMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 693CF40008
X-Stat-Signature: 1yad1zeub516rzn9rsueypadcopwdbzu
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793218454-629588
X-HE-Meta: U2FsdGVkX1+acHogM8BRdrypWPBeQ+PVfwYt0pF8K97xCTt6k5gyTcITA/fgGjiQ3QowPmCWT4YvdiDJq329GDhjF/jjCMp+J51Ct8RTk6YYCvhTRAWZY0bkQhEfU9ZNG0MqTsZ1YG/rsC9OqypzKPtcQQq5OHXve3CnPwJxYe5Q12Ncu26mzFugs4VKvQBxAYPVoBAckmqd9LvEDgbY+H9tH+Dr43Rw9yy9bac7XKeLfxUW2ys897U9My6G4MAw9I4Dw/pKPHp+T/zUFBr2D7VWdYIIfk7qvnGe+ybt97pdq573EnphEX7m8l1fSaskkbnSCXxPr0gD9Oh0sQrOxjgfsGqa+g6tIedAw3zBiYNMkYtjDT/JgJov/2gXuQXNZawpLTYA64IsbLhAs+OgF35iH85RzVWV6Sm2U26Mgggzm7bietpXs/LjPSxGmDINFBcpz+5jIVJFRcZYngj0hJzsiWeH9gjZUyngppBvQL7OJ7M4x8rbLiU+B4nn0T32ljIceBvl3K0ZuG+BL6/1m9GrBg1jOLG//OYI/2N9mO3Fzh7DFJdsGAvw16BXX5hK5wsFkMTNrq1s+P1zviuQR8bZSrEGmhMsWPDbWz9EFjEh8ev5Vg7nuPmAbrrzh6keRslJv4E3SUWKXz9FOFhel7F47OaVtWbx6RqGwQ5+Nr+D4cfM6iviHh5/F+qI2q/kEYVsv2v95YPGMFaIWZHUTUR4RmK52qrSSjRDfPtlfmUwnvXEjtVxqdLHyI2tmbw8SivE/C7LQq0nDrgubAtUbInopwudmGyLLpMtWM1YEk6cBrRFnqvf4kJe+cTphWm0IFBtM16VNEMoS5vAGFnmBiQ8EAH2pphBtk22c6LnZc/U3GDg5HANLa2b7nLh8jN+OkyuKovA1xfQPTe3pVwTFJRs2pkcrAVA9Q4fQp07gtgNZZGxJHeRDrnEfWWcdIWaY9u7FuwQV1vRcjhnS4Z
 bMfS//tj
 G/2fPVKsgQ30XId29QgK5GPjfO0Yg8keUv4dXcMV9ugfpY7mYe4mY4ccH3EmtPRYaPINkAkfCjNYEGzpGzDc4umPlD60yIaJwMVMWE1IBn6KlwqWyxFZ1lxyyH9sibpJcrmXgji4c1DeM+Tfo9NfslLYBUI9NGqUGy1ss55xg1GJasdqlbW0j7/4uTt9c7CPfgsq8OIRUpjf4Vzz5fIKDRSy8AjRjKxWEC6vsL4wsF5xyV2CefuaR+AgHUa2iskT6rusNkWm5eg514zCTIcP0UkVgGTJC95TI/cww+bB+ppBs1s2UhbLBnupCx+40KJM0bs0v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

try_to_free_low() gets a target number of persistent folios, but
compares it with "nr_huge_pages", which includes surplus folios. As a
result, it can free lowmem folios below that target.

For example, with two persistent folios and one surplus folio, a target
of two can still end up freeing one persistent folio.

Compare against persistent_huge_pages() instead. Convert the macro to a
helper function and place it before try_to_free_low().

Fixes: 7893d1d505d5 ("hugetlb: Try to grow hugetlb pool for MAP_PRIVATE mappings")
Cc: stable@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da5d04edf7c1..3a94ea1c9457 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1335,6 +1335,11 @@ static unsigned long available_huge_pages(struct hstate *h)
 	return h->free_huge_pages - h->resv_huge_pages;
 }
 
+static unsigned long persistent_huge_pages(struct hstate *h)
+{
+	return h->nr_huge_pages - h->surplus_huge_pages;
+}
+
 static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
 					   struct mempolicy_interpreted *mpoli)
 {
@@ -3719,7 +3724,7 @@ static void try_to_free_low(struct hstate *h, unsigned long count,
 		struct folio *folio, *next;
 		struct list_head *freel = &h->hugepage_freelists[i];
 		list_for_each_entry_safe(folio, next, freel, lru) {
-			if (count >= h->nr_huge_pages)
+			if (count >= persistent_huge_pages(h))
 				goto out;
 			if (folio_test_highmem(folio))
 				continue;
@@ -3773,7 +3778,6 @@ static int adjust_pool_surplus(struct hstate *h, nodemask_t *nodes_allowed,
 	return 1;
 }
 
-#define persistent_huge_pages(h) (h->nr_huge_pages - h->surplus_huge_pages)
 static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 			      nodemask_t *nodes_allowed)
 {

-- 
2.43.0


