Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 725D1C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98A136B00A2; Tue, 14 Jul 2026 23:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961766B00A3; Tue, 14 Jul 2026 23:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850D16B00A4; Tue, 14 Jul 2026 23:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 162806B00A2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:17:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D864A053C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:01:00 +0000 (UTC)
X-FDA: 84989509080.27.CC36CC7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 31A8220010
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:00:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eENy7ROG;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784084458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9uqOn1R4+r9lMeuwYoLpR5vlJPP1JnN5hGqw9wV+8Ww=;
	b=Lf0z6V6ieOnp4ECgYrBPLgR+R6cHcW48q4qaj1dWcfVIpvdAvymkn1nfE7VpeVdo5pzKRr
	aWoqxJY4aZpMsmZYWsu8B91tDejyuAD8Egweh+jwtTZQ6C2f6QK1vgHTqLaRd+NoTVmqpM
	bPlNhMD40uauz6DrvfZM5Yytx9bI7sE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784084458;
	b=yYnReRdHvVkdR5p1A4VRelm2VuDTVjUC/Cob9oaJz1LANHfS3FqTm8tJANE1qtssvRTYVG
	bBynNdy/tRWoXm/5Mnb2QMuS+C2b4CquuRffvjxLwzHFB2x9O6NuvAZPcQ6356lISK6zwR
	PY7+7NFQTjr6Lw0fp5xaxvfXKWpokIk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eENy7ROG;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784084457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9uqOn1R4+r9lMeuwYoLpR5vlJPP1JnN5hGqw9wV+8Ww=;
	b=eENy7ROG49yyx32Q3ueCcv9WnqJ874Yly5DOyREHKbDivSTN7phLmZapCsXk2dbjDBAylH
	THMcvME/0KmRy8wB8HVGaDRqDLNPWgY0eV3QwvA/AgFsheD74mIKkVm7kw2wyouUYbX1IC
	SEGa8u6PsFYWi6Cnk2c6RxgP8pqXrQ4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-RLZNDMXpO7-tX4auukvGpQ-1; Tue,
 14 Jul 2026 23:00:52 -0400
X-MC-Unique: RLZNDMXpO7-tX4auukvGpQ-1
X-Mimecast-MFC-AGG-ID: RLZNDMXpO7-tX4auukvGpQ_1784084449
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC3C3180034C;
	Wed, 15 Jul 2026 03:00:49 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.76.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DEBAB180028B;
	Wed, 15 Jul 2026 03:00:38 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v2 4/7] mm/khugepaged: fix outdated comments
Date: Tue, 14 Jul 2026 20:59:33 -0600
Message-ID: <20260715025941.1571316-5-npache@redhat.com>
In-Reply-To: <20260715025941.1571316-1-npache@redhat.com>
References: <20260715025941.1571316-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: t91916uA0r1QTWx9jZ8-wPtvBsEk5tlwZ9AnlVaOXOM_1784084449
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 31A8220010
X-Stat-Signature: k6n6stbpgw3igii57r53oji95m4y6yte
X-HE-Tag: 1784084457-26648
X-HE-Meta: U2FsdGVkX1/Z1Mm6wK2Q1JDreId9BPe/i1T/R6rPXKWhZ3K/LV2SzbppsYUJklF5tG0jNlbUUtD6FFYJjg2LEZNwcIzilLF5ynycOA/Rd3ecKXsVDduxaxInAeMU61MWqWHoSgUEODesLgK52lFvufj8pn2FTG0M8mW+s43ipA0/9O2dkzJulZWpz/YkSHMWMelGNSrox72gMnGEdzvsXt3RRww4q+/dJTVzVRvFZClFErXMvSRggZDomfkPDbcX7AJjxPZOqKmXuYGPCCml3a0DE/NRzQR2s5BLJfNerjOqWxf9pSSv1ks09lHyJsXcnTYPfMGTtdZhOzMJrCfO1eHbu4+//PWO28gCxJUa/rrwUa+lZNZZzyva2vbxOL+sKrn39bZq+k6I+EVBntQJZoTWpP8CkO0PQ0hCEc7rVW9qdyJx5EDyZ9o9FopyZkKfGqs50/P5YCenF4NQzpVG9koeiJ2pcR8rN7XxKxlpYQwm84M6uAxZ4yda1joEr8XWY22kiDKRXC7aZ94o3EuSIOv1ovH//oQnVWo3TbqX4tg3u7GlX7DZUQQ9Tijdb3tx6s04/NVVa6GPJnHlKyL3FR9wsl2998WcKnaS+6OZMfVwgIYDtjTcU4vzdc1xtaG2QDU9cdaPxOobOc5gL+z9/X5lLWBNK+uzovwNDX1nXGWTsRageZnxlE5UsxC0ki+gDmNq7Y6HCdui4q7siQ7iKCKOcFemmg+T2IauFdqQOVN0utkFZ+Cc+hjQ7YMnqqWslin/1cfbna77wJZi0EcqOOUQ/FIC+JPESWJq/I8dzhU7g/2ZQtWTRWZuYLYNRIy9e5bGnQpcvogG6io8edeGjc9ffwZk77L1cgbZe//mpWrfoSt7QmIiui0hd4VV5IbLtlN4mE7jjXIr6OIFA9rnYVV85N2EaOjtVuEW6lclZe+D6xUDZd0bNIOVMZSsDfDMWy5zR6RVQ/XxFbvCV0v
 fi7Q34v0
 xExyv06fXT52Bx9TngkQu/vxgWDC27VF6XQ3qZbXXjBCooLlOiuOqc7p5L8egrjQ5X5+Pb81Q96gfn9af5ELdff+9QS2JJViumFIHUhXFfujO5Rlch/TT2siUx1/Ni9X6RKSBawbwOjPVM8J2FmxtyUsOXHXMxu97Iwecm+XLL7ydLLzDjvdr+uSmRxWLcpOM4S3547PsZLdlNIaiu8Hf0w9V4Q1zi6U9n5P78x4FW5OOsuf/Rw0Oy0XMRdzaCXhffKY2WVU9gWzbXS4nxh2Y6JJfUsxI+aTzgRtf7BlBeBhU/4iPYjRSCuYLlN903ypSP2YPh0y6UakLFWxNPsf6BNMxYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix comment in collapse_scan_pmd() that still described the old
folio_mapcount() > folio_ref_count() check and a "512" false-positive
scenario. The code now uses folio_expected_ref_count() != folio_ref_count()
which doesn't suffer from the same limitation.

Fix comment in collapse_huge_page() that referenced ptep_clear_flush,
when the code actually uses pmdp_collapse_flush.

Fix comment in __collapse_huge_page_swapin() that referenced the old
function name khugepaged_scan_pmd, now collapse_scan_pmd.

Also clean up some simple typos and stale terminology (mmap_sem ->
mmap_lock, PG_lock -> folio lock, page -> folio, grammar).

We also clarify a comment regarding where the max_ptes_none check is
deferred to in mthp_collapse() from the original collapse_scan_pmd check.

Acked-by: Usama Arif <usama.arif@linux.dev>
Assisted-by: Cursor(claude-sonnet-4):4.6
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f65bbe2051b3..d785468ffb96 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -620,7 +620,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 		/*
 		 * This is required to serialize against
 		 * collapse_test_exit() (which is guaranteed to run
-		 * under mmap sem read mode). Stop here (after we return all
+		 * under mmap_lock read mode). Stop here (after we return all
 		 * pagetables will be destroyed) until khugepaged has finished
 		 * working on the pagetables under the mmap_lock.
 		 */
@@ -789,7 +789,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 
 		/*
 		 * We can do it before folio_isolate_lru because the
-		 * folio can't be freed from under us. NOTE: PG_lock
+		 * folio can't be freed from under us. NOTE: folio lock
 		 * is needed to serialize against split_huge_page
 		 * when invoked from the VM.
 		 */
@@ -816,7 +816,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		}
 
 		/*
-		 * Isolate the page to avoid collapsing an hugepage
+		 * Isolate the folio to avoid collapsing a hugepage
 		 * currently in use by the VM.
 		 */
 		if (!folio_isolate_lru(folio)) {
@@ -1101,7 +1101,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
-	 * remapped to file after khugepaged reaquired the mmap_lock.
+	 * remapped to file after khugepaged reacquired the mmap_lock.
 	 *
 	 * thp_vma_allowable_orders may return true for qualified file
 	 * vmas.
@@ -1159,7 +1159,7 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if khugepaged_scan_pmd believes it is worthwhile.
+ * Only done if collapse_scan_pmd believes it is worthwhile.
  *
  * For mTHP orders the function bails on the first swap entry, because
  * faulting pages back in during collapse could re-populate PTEs that
@@ -1351,8 +1351,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	mmap_read_unlock(mm);
 	/*
 	 * Prevent all access to pagetables with the exception of
-	 * gup_fast later handled by the ptep_clear_flush and the VM
-	 * handled by the anon_vma lock + PG_lock.
+	 * gup_fast later handled by the pmdp_collapse_flush and the VM
+	 * handled by the anon_vma lock + folio lock.
 	 *
 	 * UFFDIO_MOVE is prevented to race as well thanks to the
 	 * mmap_lock.
@@ -1643,7 +1643,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
-	 * scan all pages to populate the bitmap for mTHP collapse.
+	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
+	 * is then checked again in mthp_collapse() for each attempted order.
 	 */
 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
 		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
@@ -1764,12 +1765,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		/*
 		 * Check if the page has any GUP (or other external) pins.
 		 *
-		 * Here the check may be racy:
-		 * it may see folio_mapcount() > folio_ref_count().
-		 * But such case is ephemeral we could always retry collapse
-		 * later.  However it may report false positive if the page
-		 * has excessive GUP pins (i.e. 512).  Anyway the same check
-		 * will be done again later the risk seems low.
+		 * Here the check is racy, but such case is ephemeral and
+		 * we could always retry collapse later. Anyway the same
+		 * check will be done again later the risk seems low.
 		 */
 		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
-- 
2.54.0


