Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F412E6FE30
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 20:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4D8B6B008A; Tue, 23 Dec 2025 15:51:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05E36B008C; Tue, 23 Dec 2025 15:51:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B016B0092; Tue, 23 Dec 2025 15:51:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 95D5B6B008A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 15:51:10 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3183714049A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:51:10 +0000 (UTC)
X-FDA: 84251930700.05.FA4346C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A546E40004
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:51:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RHms2tR4;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766523068; a=rsa-sha256;
	cv=none;
	b=FtRcUUUlF6jNvmhPXxYUfQjopJ7RWVeeTGINjJuqrXKWFcBAHG6fL83v4/GHO1WYUS89HE
	xZf17QP1AOVQxV4pKKywsr45TQzV6iIq7HVYUrqLTBocLKqbQnQLohPzmugMU6iqbbQAKx
	XDQqcUJ5m2VxbicICm9zkGA2PL1cAz8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RHms2tR4;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766523068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CiAxr/jr3FuXrN6cDMthIAzprS3k6aJ/erwrYJzKKbw=;
	b=EIFP6DVbTL0alLFgnOCRC9v+V7Aub9XgX3M9Wjh+ICy9g5RAoopOIUFBG+Dy5S26cDNvTX
	hwuZegOqBLDzravJiOzYmXHifvtgf/Bzyy/bGei1ohpe2TCVfUC0L5kQXKSpIVV5vGTEVC
	u4y8XE4dNzMXfF0G0FX7XPI4SYZ8OMc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 33EFB60145;
	Tue, 23 Dec 2025 20:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E063C113D0;
	Tue, 23 Dec 2025 20:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766523067;
	bh=W3HxSY2RwX3H9YY1vxQutvRujCU+HdANvwda7ib8N5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHms2tR4kDPOQ8xZeR6XvdVcMUnBCculb5GtvvlY/zAWQM+3Atwwih5LYb4B42zwE
	 2bS2W2q1rzjTIG8qokrDASJLYgJ72ukhd+c7iR0P3tJvvhFS1+GB/sJbmIjXaW++Kv
	 goeDu9eKewn+PFUqRqdJkCKgPqNxtRNPgs5SotEun5pgAwl8+iqL81RuRbOwcTdvAu
	 rSHMYjMHHiOBZbe0HSEUSWIbiRdWlHbt0vDlM2NwOyysPMGPrOblcD4HL28GxdDUbd
	 6LZkpBAH+sZHXLtiF+8tAVPIp9UwUl57PSHxYLgyecPp1ZPO9o5EN2MS3cWytQIm+V
	 kk7PXygJJYxqw==
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
Subject: [PATCH v3 2/3] mm/rmap: fix two comments related to huge_pmd_unshare()
Date: Tue, 23 Dec 2025 21:50:45 +0100
Message-ID: <20251223205046.565162-3-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251223205046.565162-1-david@kernel.org>
References: <20251223205046.565162-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A546E40004
X-Rspamd-Server: rspam04
X-Stat-Signature: 9f71bfafu3y4gijsxn4xuxz6inodfruf
X-HE-Tag: 1766523068-729672
X-HE-Meta: U2FsdGVkX1/0ODIJLMmGu0bJLoFANKQ1/AM+dJQYNqLqSH/0OU9E0zDLLLfhF1Y++RoW5cnLkNbCy0jbfNg8Qt9VQzguHZ0Ul1nvm+MWmfaBcYHZ1rcCAKmdeu3wzo/w/86r0Ngar4NxgnmMvrQcksgwJUV+/ZaE3F3J4qeVw7am+WD+h2bx4u0v9/l3sKSg49+JI/LsN+G0X9lC89Bh6m5DubL6vmUHVMpRw8dYVFPHXk0GaEAmasFj7vJTlBWCi4yBhozwlqR8mNg/A4q8euVcFm8ym5/BYc1jOswPyVSl+tuwW4mMNBsNasPfR4DkcJz8ItRB9uovUXvtjcUmvPCmN8dGf8xKLALY9/vLPcKyAFpWmPODtKYc21VbMakI66xgGkh8wBmrugbnKzgWK/ufgfjuXEF8K9f3T9dacZmdCjsaKAYhiphgfFyycx3VycjEvzhGeWYE1nSP9rCbpxyX0IQO0WA9VONi6V2BbR0bjzzWWN4StsULBdnLoDgGeKNGDfFiyMV95SSvGdD6hnUgNX4OunaNfu1s1U6PTiSingK3bZLu/3JpG07KqTY6Vb2HBcVEoUTW4AxlQElKkUYqc9NvtWu/iefXnLISilZ9rnbS9gZNJo9ZWPj7HOrNg4Q5WuNPHz7cIukETU6BlhBC5SnSb217MYQ0MlGqmF/xcBJal9EbkyH50RYQ+xquPF3d/vDiSKa23ohtBZhY5xfxqMtqenOviRzoAp/sT6lGpQVcxEg9NJVV58HS+jHwxvQmCSA0mDH+JwkeHDonyu7FyduiHAXHV0ZH6051XubxvEAaMi8kBntPa4tyvGOpwbcjJ7JbK6OsBzJ8MqoWXs9BHNStTK4rQ/MTTCRFOu7BdJ01uaadxChjXC73QC37cwONvCCOiU/PpKOnunIpcVVtB6FeJTVv4BboSLDWy/Y0l0ANYcM1c75bjQv6wlzt+A6VlJwwO9HC/bRPEbD
 0Svgo9Mb
 BOU59GeblRE36S5Rn7sclZQ2VBsH154tqu7/xw1ao5VwoIXEmDQ3K9Tc0hWRd6FbrvvoHtge+9yPmKvw4PNGOdLgANlckgVeiudncdae7FxyxhAli0aBCYSIEEgA2E99K1nvKbdr6eDu/qSRCf5NLd3WyMQwQ6IzyTQOKwHPGR8SqDjtIgceXSrMpF0em4rO1oTzg6+nrzXaO25WjhGTGoQ0cNs4Vi3ZGc4hP2971loHTagqNdrxgb5hINJh18YKpiGhYLUtO2CKph16T2lDkqPKTuBPQBoLpN7eu/LhUDDfKoL/4WaA3D9sv7K49Mjw7VIrPqBF7LsJ23vcYubRi+MtwkfOrv72srnnLFr2zFsmRNKfCQkLkwGar3oK5QusF7pGyRvpbWaVxUxsuGxEgVovgdoAtpsif6jkXyGdLbutNbG65ixkVKg3iSJd9DXkxxepfQjatwLmnr9wKNTvvjWTIj911nkf7EVX4
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


