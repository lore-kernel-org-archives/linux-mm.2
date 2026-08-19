Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB824C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 10:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D692C6B009B; Wed, 19 Aug 2026 06:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D411C6B009D; Wed, 19 Aug 2026 06:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D546B009E; Wed, 19 Aug 2026 06:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A22D06B009B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:12:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37FBDC051A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:12:29 +0000 (UTC)
X-FDA: 85117604418.26.FDDF5AB
Received: from mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4D8734000D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:12:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ph6h+Yb0;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787134347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mZI08F2LQO/jGBQbPYLcaLtDA71wUzq833eNZn6macU=;
	b=H7Jho4r6CY24eEv9kPNS8+DkZPse+uxfnfpSTxzYLJZ/GcNk9BgVVAerBtpcoqtstb3tfy
	kEzF9vZ7onmM60WkUFtCHYPA+ze6bfBI7OKdDQuwHqWG66OkAWBu0uOVisbuZMh43llwak
	ejSggmEVtEwf3Dvpn9ZQ3cf1OTb7R7A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ph6h+Yb0;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787134347;
	b=kdZUO8JiRzQMeIjakyXMBSQDP30EGQk33GfNSiOuHNyGjyPd9LMGoRyeJ3Fq1zxOTwfcvn
	itE4m9RxnOIv6GPr5nKk+WYytCTU6wZwDE0BwPs8lBnbcYPAmSlKVz6XMef+Y5HwWmF2ps
	JYJM8nbKXcGqMAs4OTVJxG9y9UZ5T/k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=l+PKb6jTUmXifbhyWqtNEUsE1xBMlun/8+6U8Y84oHs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787134346; v=1; x=1787739146;
 b=ph6h+Yb0YLxYrPkVtD+RFRO8SJJTbiffXnAqXuoIU99wi/Npp+7gxvW83khT6KotMangyYQS
 gmdeC7fKZ+BLs2QdiR1ekdcgTsTEsZCCIqvBdL3VPPt96BwuNrO2d8bpGbRsPLAz556c9xiX1ps
 5bMZa/5porzu/UIxEQzqWDL4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:51::)
	by mta12.migadu.com with ESMTPS id 52389be3d342616d;
	Wed, 19 Aug 2026 10:12:25 +0000
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	usama.arif@linux.dev,
	ziy@nvidia.com,
	kas@kernel.org,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com
Cc: stable@vger.kernel.org
Subject: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio on zap
Date: Wed, 19 Aug 2026 03:12:22 -0700
Message-ID: <20260819101222.3732660-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D8734000D
X-Stat-Signature: mqthghd6zuao53w3xmnr7jnwun171or8
X-Rspam-User: 
X-HE-Tag: 1787134347-559088
X-HE-Meta: U2FsdGVkX1+ngVPRxCyd2KEXaPhaAGQ/ODBB9IHMaZAr4jug02ZwqI7Xds1Gnl2ozU62hRywL7LzFNPF10CJOqqRR6rdD8yNGSBHAdONbYoPZdPsdhXvaO4IdiDlYye5lwekMQB2Gh+rAC1H6A2PWfr0mDipt5Mg6O2kaZvWiu0Vf8MILT6VoNuH6M+zQsACJS8rYDyLi0QwNEgtFsjzLmwp7lqgzN6fffyU/Axz99NgxbPhL9DlW9xIK2H8AL1SPB3/r0pXBbNVzqeooIJwcdGF2UmNzadWy27l4PQWrgGXrAm7E+NO8HeOEfUU3M53QeLbxr+XTB3mB2PvwXxKBMMZYrmXemVDIQTxknmmTtAks9OOUx1hbWtKlD6rtBiaC5rRb9+k0QWA0S3d4oizc0zG9IuE/OFvEOX73EuS8UUZJg/sCiPXzylqzfhMKFS+gNF/NfnNL1fTnsHy3TtGz6RBWq+kciz+DLxrS4Md81zboHKUcZmHKbZyFehUTToEmjE58Xkq0QEJHhMvDkaN5P3avgCV0NF+rcGWZyYMb5YnukNSadUR1XsekKGkRYfCR0XgvU9m+3EIE/XPG6MzWaVVNWnRTIcQYLF4Y8Wdo0MZlAPRdLhCGRBcdM85CZop9zLJZ9+SkTdlYxhnERvxLVmV+LG1xPD0Fx0kEX1e0ws3YqRSgVM3mIDpkMhI1tqeU180aFgJ4VpbYo5UMn/IYtX0G/4Aj6SdtTYOwZqXyWhEKE28jeD2Hxj8iQmtKshTi5NTEH0zVjz+/xXhRSg7p7DBDAAc/XJOusJyIsL1Ktg/N/EnewF/n/Hzb4Z3jY4waJhcZtJKx2BfGT22sPUn8c4QvynY3kTwuQcxNoo0r9nO+CJPd3CadDI/3CnMVnyrCpr/qO2ToXWAaAoMCsBKnuFcYMouVibzWKlb1/Zvh5nWrSwJttY1YzXC9KLd3dy9XxuLiLFg1BrCEzb8wU1
 08qOr3y/
 yYXpyu3EKpVygSF2m3mFtClsmdY6FNGUTBgSklcIxbuhKdeSRcYBBIUWwPZPukcFYFAyp7kvBMKFNUnCtkpQ2Gnm9I6E4mgK2yQgASgV5pxOLPO3VapPKr2D3LwVrBXD8xstRHnLkIHnHyMfV1phFwuCJ7dbr/oTWsNtYY7ykSKB5vG7AM07BP9St9PEcGrBYntvO2QPTC2dMCGvmCDW+az5S+KLyQHE00sqpzkVuZ24Jm4h91X/xwBfLUd4q1/nT6E0/XTQSsGzM5QtyjUp5mtwtW9cBBwO6rVwFS0BiTfAOl3fMgNMcieRGUGSMXiqbUz3FEyozHbzh6z2+gyAC3fGFdaUOIjbZQiuF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zap_huge_pmd_folio() propagates the pmd young bit to the folio for the
file case, but not the dirty bit.  The pte path does propagate it, in
zap_present_folio_ptes() and so does the pmd split path, in
__split_huge_pmd_locked().

For most file mappings the omission is harmless, because writing to a
shared file mapping goes through page_mkwrite(), which dirties the
folio.  tmpfs is different: it has no page_mkwrite(), and
vma_wants_writenotify() is false for it, so a *read* fault on a
MAP_SHARED tmpfs mapping installs a writable pmd via do_read_fault().
do_read_fault() does not call fault_dirty_shared_page(), so subsequent
stores through that mapping set only the hardware dirty bit in the pmd
and never call folio_mark_dirty().  A shmem folio allocated by a fault
is marked uptodate but not dirty (see the clear: block in
shmem_get_folio_gfp()), so PG_dirty is never set at all.

Unmapping such a folio - munmap(), or exit_mmap() when the process dies
- then loses the only record that it was written, because zap_huge_pmd()
drops the pmd without transferring the dirty bit.  Reclaim afterwards
sees a clean shmem folio: the whole swap-out block in
shrink_folio_list() is inside "if (folio_test_dirty(folio))", so
pageout() is skipped and the folio falls into __remove_mapping().
There, folio_is_file_lru() is false for a swapbacked folio, so no shadow
entry is created and __filemap_remove_folio(folio, NULL) simply empties
the i_pages slot.  The data is freed without ever being written to swap,
and the next fault on that index returns a freshly zeroed folio.

This is silent data loss for any process that keeps state in a
MAP_SHARED tmpfs segment across an unmap - for example a cache handed
from one process generation to the next through /dev/shm.  It requires
the folio to be PMD-mapped, so it only shows up once shmem THP is
enabled (which is what we did in Meta fleet and started noticing crashes);
with THP off the pte path transfers the dirty bit correctly.
It also only becomes visible when swap is enabled, because with no swap
device shmem folios (which are on the anon LRU) are not scanned by
reclaim at all, so the clean folio is never dropped.

Reproduced on x86_64 with a tmpfs mounted huge=within_size: read-fault a
2MB-backed region, write a known pattern through the resulting mapping,
munmap, force reclaim of the cgroup, then re-map and read back.  Without
this patch the region reads back as zeros and vmstat shows zswpout 0 -
the data was discarded rather than swapped.  With this patch the region
reads back correctly and the pages are swapped out as expected.  With
huge=never, or when the first touch is a write, the test passes either
way.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43a..afbb5974bd225 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2449,6 +2449,8 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 		add_mm_counter(mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);
 
+		if (is_present && pmd_dirty(pmdval))
+			folio_mark_dirty(folio);
 		if (is_present && pmd_young(pmdval) &&
 		    likely(vma_has_recency(vma)))
 			folio_mark_accessed(folio);
-- 
2.53.0-Meta


