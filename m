Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA5CCA100B
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92D318E001E; Tue,  2 Sep 2025 12:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBEE8E0003; Tue,  2 Sep 2025 12:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818DC8E001E; Tue,  2 Sep 2025 12:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 701E38E0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:25:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34BE01402B3
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:25:52 +0000 (UTC)
X-FDA: 83844836544.24.0EFCEB9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 747AA1A0008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:25:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sc317jNV;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756830350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGt+rfAZPqOpC/usLmyRdPXY0e3SkpciH6+5LLOoAzw=;
	b=g3C4xQ/PheLjhbEotG3ebN8G2ybnkXRIUNekOQCtHdxzpLYtsS1eYNbNpH7v88tPPAntme
	X7ERks3HnCh99nSUIJ1Vab7zDaZpG7Ewlng4dNnyb5TzahG2cK2kAxzHch6gWP4aDwsI+m
	D45P2luQXIRFkXbAhv63Vepv8RmaS4g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sc317jNV;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756830350; a=rsa-sha256;
	cv=none;
	b=FV+BYtDugjwWoROAWO8g0HdAeGcewOFxrMw/IFLEHRWHTbeEwZ2P+Tw5Pm9axQ2eVEuy7z
	ei3eocPuP2jCTqZovhy3SXsEtc5hufiDgdKbivRgMIFOJUV+v2k2RH00vSWC/rR0HZQ70V
	a1GFZ719oqMVfjqVoLOBzwEbaVfpt8Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756830349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fGt+rfAZPqOpC/usLmyRdPXY0e3SkpciH6+5LLOoAzw=;
	b=Sc317jNVjK/DiyAK/nLbHp3t6XNFAYUTHSoZzaPL6Ox7shjvSbqD45wtUjW5ewtUP+YFNd
	q0sGSdYrLCU0MppKTw5fY0GzAtlsIjT5Jaj2ESarX0gElzHjeE8jPBv2pVawULW9avnRmS
	52SpXFBFKeO/uiVEPtZrF2PQKEWfN9g=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-578-bSUXBqyPNWqsMD_lkbXvuA-1; Tue,
 02 Sep 2025 12:25:46 -0400
X-MC-Unique: bSUXBqyPNWqsMD_lkbXvuA-1
X-Mimecast-MFC-AGG-ID: bSUXBqyPNWqsMD_lkbXvuA_1756830345
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 983FE19560AD;
	Tue,  2 Sep 2025 16:25:45 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.80.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D482230001A7;
	Tue,  2 Sep 2025 16:25:43 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 1/2] selftests/mm: split_huge_page_test: fix occasional is_backed_by_folio() wrong results
Date: Tue,  2 Sep 2025 18:25:35 +0200
Message-ID: <20250902162536.956465-2-david@redhat.com>
In-Reply-To: <20250902162536.956465-1-david@redhat.com>
References: <20250902162536.956465-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 747AA1A0008
X-Rspam-User: 
X-Stat-Signature: 7b864yz91u6em1p18mokcopghf7pfy96
X-Rspamd-Server: rspam09
X-HE-Tag: 1756830350-784916
X-HE-Meta: U2FsdGVkX18Cm1NsE1SFoAnQjVOINpArjgHTyE8CT+Pg1LRlxEGpb9VrvRY7UiRgLnFllc3kY1gQKmYbPIWjIcKC7EcoRzh+cOqoSK7WvbT+0XIHgRLcZatvJQVnjdpjmpCq+SSKoCK3HTTcbtisNvYhjrR0kvr9yt7teDH8VTvrs5Gjt8n1sX/NHFwaPrFKkIZ6pHH7Pq4mBON3VUdXcLwkh89HL/+ZBncuyFFdakHwtrjRtybeDvm4s5itZpkR6IrS0ZpSiBYwsTDq07VYrl8SCz3WS4p9v9PBLF+cdno90OSXfHo8R0op+b4jF88yNjt25VADqUCDkq/yvpqG/qJ2VJMdyv1hl7k1yypvdgZoaxg17esnsDDNG7K7/i9irZOhun5iSRJwO7+wydJweNU1XWAWP6rRWY5obrKjxYCK5cTlKHBmGeEU75yjxf7acWU0AAKRoNQL2SUUVDGabxO/aX13g9/Jc///51dBKxApkysyAE1KBWfMeOfs0wrcaFitrEK7rB1DUeBw8nRP52H816CJMed1CFNzwjdZkhL1cSQSsoEUP1Gh5c/Qu68zoG3cwFSWOVM5likW4isddOglrUY83zA8Ah1QtPM4Qs1Lia7r5WeF9uR3zKn7sZl/G3m2NzoQ6Eh0+SRFJ2zQ1NeabRgreGZ1oaSiY8URduRh8xP4B2FRIu7TShwQRxOpuwuw9kQ+dHLy/5kwxjmxIu5r9nwfOMJ3tO/0lYR7KDuOFdA/7iZMD720J1oguIAz5MeF3WOcrRTXUB2x5ZzWvu3GZQuZaCHCZnT5GnvmyLc26+ZAev0MykiWxTK297yWgUSxfu8KCjvoIbhNMD5vHOWED7L9IGcmbfPyYIUwEfy23evk3JecPgxiKkAKJ4jthDUmvRbRH5B90B/YrqfqMTKp/YUQrbp58NG+Yc9927aSgL7V50WsyTyxnJ1iww4Hh4uz5TQAva1W/oMyNcP
 5ZgjSnSM
 NBLaNI2tE25D2dCEmNq9WRrbj90PKG5g/o3K/uajcLHCYqWqEnZ7Q0pQEC8Qt+3ChtFjbPxW1lMOnhUHMV/PTXxcxThLICUedjDGVCdPrrQIzbPFiI/1OmVSSSysK4163+MqHPu5O34y8S9z0tQ1QLE1qbvpHuFRwUqW1G99u+3E47QTg8DokTJEGikvhi+qkx2/+db+G4+0LSrBDRkc4OJC5nE3W8KDjlnEGNLtDsnHvUWf1PdxNq40WKevawW2Z6wpemXRysaxMpNM0jaAqFiacX0VsvvkK9NJ+wXDBGQhEus9nGZ5lzDW5c1Vf9+4BklSR9gDJKQfKj4axhSnkf+1rulVYYlj9mqA4WjhXrI7itn6WhnCh5V/0PwWcYu3g1IES
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When checking for actual tail or head pages of a folio, we must make
sure that the KPF_COMPOUND_HEAD/KPF_COMPOUND_TAIL flag is paired with
KPF_THP.

For example, if we have another large folio after our large folio in
physical memory, our "pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL" would
trigger even though it's actually a head page of the next folio.

If is_backed_by_folio() returns a wrong result, split_pte_mapped_thp()
can fail with "Some THPs are missing during mremap".

Fix it by checking for head/tail pages of folios properly. Add
folio_tail_flags/folio_head_flags to improve readability and use these
masks also when just testing for any compound page.

Fixes: 169b456b0162 ("selftests/mm: reimplement is_backed_by_thp() with more precise check")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 10ae65ea032f6..72d6d8bb329ed 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -44,6 +44,8 @@ int kpageflags_fd;
 static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 		int kpageflags_fd)
 {
+	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
+	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
 	const unsigned long nr_pages = 1UL << order;
 	unsigned long pfn_head;
 	uint64_t pfn_flags;
@@ -61,7 +63,7 @@ static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 
 	/* check for order-0 pages */
 	if (!order) {
-		if (pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))
+		if (pfn_flags & (folio_head_flags | folio_tail_flags))
 			return false;
 		return true;
 	}
@@ -76,14 +78,14 @@ static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 		goto fail;
 
 	/* head PFN has no compound_head flag set */
-	if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD)))
+	if ((pfn_flags & folio_head_flags) != folio_head_flags)
 		return false;
 
 	/* check all tail PFN flags */
 	for (i = 1; i < nr_pages; i++) {
 		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
 			goto fail;
-		if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL)))
+		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
 			return false;
 	}
 
@@ -94,11 +96,8 @@ static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
 		return true;
 
-	/* this folio is bigger than the given order */
-	if (pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL))
-		return false;
-
-	return true;
+	/* If we find another tail page, then the folio is larger. */
+	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
 fail:
 	ksft_exit_fail_msg("Failed to get folio info\n");
 	return false;
-- 
2.50.1


