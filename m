Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22306D374A8
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 21:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DEAE6B02F7; Fri,  5 Dec 2025 16:36:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5C56B02F9; Fri,  5 Dec 2025 16:36:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CBC56B02FA; Fri,  5 Dec 2025 16:36:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BDCF6B02F7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:36:27 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A710139FC9
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:36:27 +0000 (UTC)
X-FDA: 84186726414.12.555E0B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 67EE2120011
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:36:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S1GwPY7f;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764970585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eF3F3CUPf/5tOCMXunCI4NjTc5Ai6MxubGyRXDk/KS4=;
	b=hDJQ0/JOmjX5QRwfE1MaKvKoGP4BboL6ACyXyc9hUoHK7N64K7uvn8yyxk0UqgWhWh5T+j
	ykfbB/Tg898qFYle7E0xycuakLnfXHigcL965ih4pUgWyLshQgwFY9BKlIMQgAsbXcoViM
	Fpr4gZ9m5F9T5sGS21QcVSDiykf7Vu8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S1GwPY7f;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764970585; a=rsa-sha256;
	cv=none;
	b=S1+VLNTXZWKLunxSlB3mJKDIWw4u9ggALlTfTjs4i9NoILEsLXnUrQ4fGaridrbEmPfVJ+
	MJyMyhGB9xjyFfx+D9algnIQHTTma50moDMpUvaGuuAUPHGqpKTZ7b9cWVt/HAgh6+QRkE
	yw8uLuaPtOUUdrvsLgOqGD5aHf3g+LA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6902743A0C;
	Fri,  5 Dec 2025 21:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0112C4CEF1;
	Fri,  5 Dec 2025 21:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764970584;
	bh=o38uGAMpi9BdWN5xQqMRFNTmj6rucJFF3oUHW7Ho378=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1GwPY7f7m7pYaS3MVCNK7lzPbKUsHhv56xvJR387DiEcS3s+1L9IoIEdiQjKnPJF
	 syWDzZO95NkH0eeBJih2q7r/rKlfAnR4OM1GX0IdU/1RGPWDi+z15xlnuHTZxwiRsM
	 QXp2v+PFeEYzsxJDj+DOgl8D5s8QF7MJgTDQXndp+pEgFiNeVwSG520KB6QuDytMGd
	 87faJ8Hv31qdU86J7RatR2JmGzqLfyu1qpWjM1hCx/4adbMzFyFlnqGHPIZoPIf1GG
	 Cpa8yKbeULm/1EO2jpSCdRhuVdL1+R6TUzR5/hWySi0TIoBxplT5BVRK5S1+1gVEGJ
	 F1GV04axuZtZQ==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH v1 3/4] mm/rmap: fix two comments related to huge_pmd_unshare()
Date: Fri,  5 Dec 2025 22:35:57 +0100
Message-ID: <20251205213558.2980480-4-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251205213558.2980480-1-david@kernel.org>
References: <20251205213558.2980480-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: je9nmxkb9s6q6ehtcrp1uewerbd5zt51
X-Rspamd-Queue-Id: 67EE2120011
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1764970585-908562
X-HE-Meta: U2FsdGVkX1/MY0MKYvx/H9VUosZqc7FHUG+SUulBWkO9ORwjWkribdB3LqlvO6T3q+Uu9TlcInZ8B2V8BnXHHG8rOa581wlNrGZyoGrYq1kaC+Ywy/n9sqwjizpN7DluZxAygeDA9w1Z5lOg/FEir0800AcnAqS5gViS0/9JcaoCjoWVS8QN/PPU6esJVI0HtwfXjinnNQPlK+QY17SReKKQCFma+DCilhK6/RSYkfPUsb4ArbzzWP87ja7Q6j1tMgNA+0+K/IZiR1EwCUXj+5ykIlQmkBAwrfTzMp1HqzewNlbeuZkFYBpSG2tkDcdh4Ng9C/jAQ0unIAUeIyJ65N+U0xfdfFR1OS6Mr+TSnEqu5waQZJI+ySWF1yDrtQbvgWP6yXTjSkYl+2OywWZVbZOeOsCF+p6MN6j6XkGn0MWM/AeG7ZBghMOFjwPq1Xxb5HvcNbRWCCX+1enkmIuae8CWkHIUofQuCdo7JoQlTWWyye6qjckgUbkiCq79wCTYEADKXrW8pB6H3Ovh2DBRiV96EIIDxG+74b5QxYjpEndMlo5xqo3DFbXR0t3wppvDVwoufhrw7nKxUDyQFssqs5ZbAEBIAVwG9z2gkrQ4NPjXEjfx3CaSSecUEsOTFWqw3zzmoaguTTe0Tla0bSGHH3C0n3fuE0pUf7YxGFNi608Fro1p9Cx540COncyCFJ5qxVcP25wjzGZzFxMkw1KIY/V0Fqdf++1cx8WsQl5BHqWu1yWFk2K18xnaKiPUKYAl2C4JIzQL8XeqH7uZO+WDqDSucNh4PIJ0QpVgBhBmpPgipFz2/eKGFaPz7M3t3gOMDhuzi8ehyRoMZUw3G2xYaYANwqM+Rzkn897NhbR3bFqgWQXZWjLF2A3SVkDAHCB9MwbaVvBZxbWVz9OTZiVFFFV/rLUSuwMj3ZjH609LYhQNhhNb8gqzVdBHmbewxB1wfAiy2PxOkNlobWCbO6b
 Rla/6k5B
 6weyViusY639Zv+622qH48e4eqeiFBs/r7fYX6rT4AfTQBzKrhQGeNYHQrtp1Brhu9unA+LmRzR9BsJE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PMD page table unsharing no longer touches the refcount of a PMD page
table. Also, it is not about dropping the refcount of a "PMD page" but
the "PMD page table".

Let's just simplify by saying that the PMD page table was unmapped,
consequently also unmapping the folio that was mapped into this page.

This code should be deduplicated in the future.

Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Cc: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/rmap.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index f955f02d570ed..748f48727a162 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2016,14 +2016,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 					flush_tlb_range(vma,
 						range.start, range.end);
 					/*
-					 * The ref count of the PMD page was
-					 * dropped which is part of the way map
-					 * counting is done for shared PMDs.
-					 * Return 'true' here.  When there is
-					 * no other sharing, huge_pmd_unshare
-					 * returns false and we will unmap the
-					 * actual page and drop map count
-					 * to zero.
+					 * The PMD table was unmapped,
+					 * consequently unmapping the folio.
 					 */
 					goto walk_done;
 				}
@@ -2416,14 +2410,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 						range.start, range.end);
 
 					/*
-					 * The ref count of the PMD page was
-					 * dropped which is part of the way map
-					 * counting is done for shared PMDs.
-					 * Return 'true' here.  When there is
-					 * no other sharing, huge_pmd_unshare
-					 * returns false and we will unmap the
-					 * actual page and drop map count
-					 * to zero.
+					 * The PMD table was unmapped,
+					 * consequently unmapping the folio.
 					 */
 					page_vma_mapped_walk_done(&pvmw);
 					break;
-- 
2.52.0


