Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB63CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42416B0106; Tue, 19 Aug 2025 09:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18E36B0107; Tue, 19 Aug 2025 09:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EB76B0109; Tue, 19 Aug 2025 09:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF5716B0106
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:49:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3396C16079C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:49:14 +0000 (UTC)
X-FDA: 83793638628.19.0AC0058
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8C10340002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:49:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jLGB2Osq;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611352; a=rsa-sha256;
	cv=none;
	b=B2Hj8/5FWWtGBkLAnT37gSdtTH62vreVvdQ3uTp4Dy40flFPVHT6auoHVPb3utJJnXxRWU
	tsWtqkO+2WRxqziH5JbFSewZw6WmxIBOSn83qOoVdP83aC1sHL+qOuNQcXtTFdur3auoQU
	w3sY1kOkcoDgn40WGpyTe8L/+q2P1p0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jLGB2Osq;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AyWTWLJP6DW1C6EfE8Dr/2WHmv98BO2UL0YW0p387dM=;
	b=W4Ukf2y3aEHwwLX8X5hx7ShXoVmww6F17utEiNhiWb08zRbfqh5CLRkV8vKY3r1ZFxeZgJ
	ADqJYcQWvqzVk3AduJUb1FpDJpr0KqD5ER69TwWIE0ZsBrwCLdgzeAtH3DGeG4HuAY11+l
	lgChFKW/J7SVHW2OcRq9jRQXbqABfFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755611351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AyWTWLJP6DW1C6EfE8Dr/2WHmv98BO2UL0YW0p387dM=;
	b=jLGB2Osqbx/GypZRcbnhtYaRVNWJuyl6xcQvOawiFC342MCYZwXxwkwYwK9nRLcON9d3/6
	y3jI0SyuIIzM7FaNNfG9qzETEGpl3Kxl1wXFMCoLkWEfTjcgKdQZQEYsyTjZaheYVBmTD8
	hZIOOUKdL0mbkcmkuACrLio73TvOqwc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-L1GnHHeeNRic9_6RStOKvw-1; Tue,
 19 Aug 2025 09:49:07 -0400
X-MC-Unique: L1GnHHeeNRic9_6RStOKvw-1
X-Mimecast-MFC-AGG-ID: L1GnHHeeNRic9_6RStOKvw_1755611342
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3321B1800298;
	Tue, 19 Aug 2025 13:49:01 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DF961955F24;
	Tue, 19 Aug 2025 13:48:43 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kirill.shutemov@linux.intel.com,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com
Subject: [PATCH v10 12/13] khugepaged: add per-order mTHP khugepaged stats
Date: Tue, 19 Aug 2025 07:48:23 -0600
Message-ID: <20250819134824.623535-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C10340002
X-Stat-Signature: 9eihgbwmxtj5ihd4uu3squqr9y5ydmps
X-Rspam-User: 
X-HE-Tag: 1755611352-173705
X-HE-Meta: U2FsdGVkX18nH30rTZyHcgajlrdtbEyjDPZtaSrNsyAcUQDvOSTmGaLkhpkJiznNzbp4x1St6CIC0fl6f9gR+vcGUmrZpFD+dtBBynjqCUJLlKChgPkO3TEH7Io+akN5lBqfpEQb06bmFUQtYlquJxNUsL81dXj6R0DOo7c/gy/KlNLvo9VOolVJ0+LyWNo3vjZ7/fn5zP8rxrDP3aRwpjNDaEnk2Tpqw56ZJlxdHlQZvHlmhvZ/TZnb2NM3wMqXi6ZcH+7WJDVpKPHOM53Y2NP8WgqtB2Cv4Sn3WojvRC6PCMN/jnEYhCLf5PwSg1PF3fSYoPVf679q+feRpLQ5IEcb65QxoNjuaP5y87IdRC0WuXbW/gpgJfOPcqTXw8rxvhViPZ7dWQ73kw7g8is+AwyUh41Cj5/6I8H1l1ES1mAzu4VybbJ1pYuDY8inqv/g+uQa9bJsTx19dnoPXoqW/2p1Dj2AelYArmRD/lobRewgTGe8o2i69l+b/RzEmU3uL5D+cd1Oe6kzl7aD5WO8MrVVBuya3PbfXUXgFXRqshOvxFrZ1BSXLYt5T0CIcNVZCU2emJ7IlEbGAzCfXrqf/TZaJptCR7EACOjU/odvVPz9qrb5Rz2Yslvtd7GeslMMM4qkCddvM7Jrm9Q820YtsjaDGXoJ+z7KK3v4M3p+Gten67WWbTl/Qirw+YgKn5op7qkd1xXDTzs6MGgXkzFo3ycwrvQw37MHZn/loahwnLy4SbC/CqHPyPYOamLrXzrI/Z++y3JV/bd7fIup7xxh4todiSwmIipNpRM+BTT97LRCes+AKZofKKutyl297a/HMO78p/UV+UV09PYcLei68eTDFJwAttce/Hp/E7s39zzHWVHrLonWdmN3Q0pQQJHiMexRR85Vlr1rEO4PAJRqcUoPs26/qDYj08cOVD9GlwkDlfQFxZcPAo0mZ9++AmjRnlcgdd4148H9WIy90Gc
 UboL1eDn
 vA4dVdr3XfauIYUOt77YaVkIwbGiFGk5iQ7AAJmBue39lqUSRe+mCZxjI6bLwI0PK+3FOTux+JtB82WUfqPrXUy9B6JQvMFB/RA7xonnTNX4lTak4cnJJVa5RtVwLgolN1iY0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With mTHP support inplace, let add the per-order mTHP stats for
exceeding NONE, SWAP, and SHARED.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 17 +++++++++++++++++
 include/linux/huge_mm.h                    |  3 +++
 mm/huge_memory.c                           |  7 +++++++
 mm/khugepaged.c                            | 16 +++++++++++++---
 4 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 7ccb93e22852..b85547ac4fe9 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -705,6 +705,23 @@ nr_anon_partially_mapped
        an anonymous THP as "partially mapped" and count it here, even though it
        is not actually partially mapped anymore.
 
+collapse_exceed_swap_pte
+       The number of anonymous THP which contain at least one swap PTE.
+       Currently khugepaged does not support collapsing mTHP regions that
+       contain a swap PTE.
+
+collapse_exceed_none_pte
+       The number of anonymous THP which have exceeded the none PTE threshold.
+       With mTHP collapse, a bitmap is used to gather the state of a PMD region
+       and is then recursively checked from largest to smallest order against
+       the scaled max_ptes_none count. This counter indicates that the next
+       enabled order will be checked.
+
+collapse_exceed_shared_pte
+       The number of anonymous THP which contain at least one shared PTE.
+       Currently khugepaged does not support collapsing mTHP regions that
+       contain a shared PTE.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 4ada5d1f7297..6f1593d0b4b5 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -144,6 +144,9 @@ enum mthp_stat_item {
 	MTHP_STAT_SPLIT_DEFERRED,
 	MTHP_STAT_NR_ANON,
 	MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
+	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
+	MTHP_STAT_COLLAPSE_EXCEED_NONE,
+	MTHP_STAT_COLLAPSE_EXCEED_SHARED,
 	__MTHP_STAT_COUNT
 };
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 20d005c2c61f..9f0470c3e983 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -639,6 +639,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
 DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
 DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+
 
 static struct attribute *anon_stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
@@ -655,6 +659,9 @@ static struct attribute *anon_stats_attrs[] = {
 	&split_deferred_attr.attr,
 	&nr_anon_attr.attr,
 	&nr_anon_partially_mapped_attr.attr,
+	&collapse_exceed_swap_pte_attr.attr,
+	&collapse_exceed_none_pte_attr.attr,
+	&collapse_exceed_shared_pte_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c13bc583a368..5a3386043f39 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -594,7 +594,9 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				if (order == HPAGE_PMD_ORDER)
+					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out;
 			}
 		}
@@ -633,10 +635,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			 * shared may cause a future higher order collapse on a
 			 * rescan of the same range.
 			 */
-			if (order != HPAGE_PMD_ORDER || (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared)) {
+			if (order != HPAGE_PMD_ORDER) {
+				result = SCAN_EXCEED_SHARED_PTE;
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+				goto out;
+			}
+
+			if (cc->is_khugepaged &&
+			    shared > khugepaged_max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out;
 			}
 		}
@@ -1084,6 +1093,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 		 * range.
 		 */
 		if (order != HPAGE_PMD_ORDER) {
+			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 			pte_unmap(pte);
 			mmap_read_unlock(mm);
 			result = SCAN_EXCEED_SWAP_PTE;
-- 
2.50.1


