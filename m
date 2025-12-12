Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D16AD4336E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 07:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48556B0005; Fri, 12 Dec 2025 02:10:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1FF66B000A; Fri, 12 Dec 2025 02:10:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935FC6B000C; Fri, 12 Dec 2025 02:10:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 842396B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:10:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45BB913B0BD
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:10:42 +0000 (UTC)
X-FDA: 84209946324.09.A89569E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 717A5100018
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:10:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5LXJHbl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765523440; a=rsa-sha256;
	cv=none;
	b=5jx9w4vnH5zJ2/AgCjgA548VSTUCyiMCl8CKLVI7pbKkVOMz37SxLpgst70sa+KbTUi94e
	qZRMt6MHX/qh9gsu6QnilxBsznP0QEVGNJdMZHIazirB90D8UYnK6vK2rItnm9sTZC47Q4
	V2/e5QNgsaVCWNcSFO7dAyMEydmaNtE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5LXJHbl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765523440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CiAxr/jr3FuXrN6cDMthIAzprS3k6aJ/erwrYJzKKbw=;
	b=RPSqrJbA3sesVPYr2oeOQ0wjz6ahOM+CFq/gytlWl/ovQPxjZCcFCx3oTCp9yJeEQukqwt
	Rm+TStMvhtwmRRFDyuHL+FfCSKJg2+jqLb9FRb6MKNFsG6d6kvHQewip7TZNzkX7rFUyQm
	UQx7ezEDafRgJPBpvjqOmXchEZiuoKs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9675441ABC;
	Fri, 12 Dec 2025 07:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C923AC16AAE;
	Fri, 12 Dec 2025 07:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765523439;
	bh=W3HxSY2RwX3H9YY1vxQutvRujCU+HdANvwda7ib8N5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5LXJHbl4t/yZePoL+B5dBMynM55zoKdjs6ice5C3xI5rbw1w9yHevZvI2Z3SCTQC
	 epN47mXBxt2TgCEbXYLwoX4ReQ1KACjDgTW6eLNJLmRRe2IeIbtQkolqfsKWQLjgko
	 jOZXndjc2E927pjnwZ6kE31RuOUIGctXO1JScVN7e+llDB+mxePARPVqHdzWWqO6wR
	 ErDnwnI4ySKKsvOAGXTDE9AJ3ZjpiJPgUnfTOLPbnbHE4PmSeSUBzyk4SRg6q133S1
	 PrTkOshx7hKd6jqgwtfMwidp2PG52GKbGQ3dXjkC8y8/1tZmw2ZS3RGOam4VfhV+4b
	 4TDP4pqH1yCqQ==
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
Subject: [PATCH v2 3/4] mm/rmap: fix two comments related to huge_pmd_unshare()
Date: Fri, 12 Dec 2025 08:10:18 +0100
Message-ID: <20251212071019.471146-4-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251212071019.471146-1-david@kernel.org>
References: <20251212071019.471146-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 717A5100018
X-Rspamd-Server: rspam03
X-Stat-Signature: 7trq6pizpcdxyae6oudhmso5giwaa935
X-Rspam-User: 
X-HE-Tag: 1765523440-847956
X-HE-Meta: U2FsdGVkX1+4usLRmrpA1ZbKxrAs9VqLa4n2afRy3QAcFC/9Li2sGJgLGL7oifAXbLdqUhaPlsttHYxgIBkA1V3qtry/T4AQfupzt1usgGxvBFr7CE4H8XAzW007HoU0sN/euPjF974nh86qnhAudIYP1+e86vx2Rh2hkm4L67KgbljgozRj3TaynLl1p4PEcVcGzlIoZD+SCbG6t67Mj2hudbLCFbLWikNKmemxa2tV5O/vBseyrBp00302UUQ6k2qk9XIzza1moArk6vsQ+gv8DoZ5jbHnA1cNhBDUS/wVseD/1aX80w23lZIc60tDNPv1XJZtkOp20dW/88Pnp7glFRx3fox8EHWa6HNwogjy2Kevv+76jdgtAh1AAuwQElqQujWMevnQ78H12WlwGhEiPWeZT8MJWUYaRMNy0ac0pCTmmCcJ80NgN7liQJs+F9S/BeLhFDKeGFmsjCeNJDaAFcswhrzB3KVWkmOIAh1sLr3q8sleEo2fQ8+w6QrNYyXeYvjjR9fqB+/nIQXMvb2Z0YOhbccx1tZ/GkX/qjPWz9fCMjbxbhsWHP+JR36nNbZJafnLA70W06+BdGNURELtjIp8lVtPysBt+7K/qmhUmeIczp66Yq1h9xLBSq0Jocc3F3YbpzIXqoryqO4qH4hkxnjwjQUfb/qoaJlGKlTHRiVEAF6e1TUnTgwWsRbWvvgexdip7vr5Oe+DSTbFr+T2bJ9VeQAjj0TvEHXWWcFTkZxAokRoYuqV11j/yPAOuBjtiMCL8Y2NXfpT8Z4R80r21RLI54AW/hOJ+Nuh78GGxusGaSwYvs/l9K6Ao2Tm2xRPvFy+GkIBYDkPU/ix8IzJLI5nnLOiRnhFiLyoN9sP06JNJL4+nxAlVwVBBenaJnF9fx3xsEgX4gk3GJQmguH4/NNDkOO/ZClJpbyrskovzD4t+3O1uC89+OH7rIfBeRdyACt+N2PC/0pS3GC
 Rjk3BeKv
 1IxkTnGAZWjmRX/AePItnkPOJv4wF9C+fJZ+/+xLLt/pqByF50EQhWA9GuAGdNyAEaXmCb7URY9sOVzv8Hlhw0UvKw7C9GpxdX6Q2z1tUGxqlFsRuEtB0VYhKoUExlRqTjHqyLDqr/hO+mjzB0HWx6weimwVIG+oqqvR1Vf34IsNcdHpJy+8XhaqoL8xZ07khWIvdjhVZj0B8ORjq9hJltvX7MofuQXt9YXiz3K2fOMkQS15cKp2dypUigph4LMcP5Zjuv1NP4SqIdBAI0l9QyX6hoKtk2RM9eWLE8LyjdqUyScqjJQlT/C402KLfq3zCUU0ffLIeMYYNmeDyGTDQMNJGrcE/M9g01HlM7Q7gEfmtJp8NX/f2f28XuLsXvBjh8j0aed9izJ3eV76jZxkksHbR0AnRkPFKWhUCPNWpOsSSRyXeFBQ4DJbn19KYPpkIhyCeACELXC/RUq7JwyCjegnU6fJT6hU+AzsL
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
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
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


