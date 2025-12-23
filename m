Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B65E748EE
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 21:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8FF26B008C; Tue, 23 Dec 2025 16:41:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39F16B0092; Tue, 23 Dec 2025 16:41:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3CB86B0093; Tue, 23 Dec 2025 16:41:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B2B766B008C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:41:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D99513870A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:41:07 +0000 (UTC)
X-FDA: 84252056574.14.490D364
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id DBB48180013
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:41:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e+NWqGr+;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766526065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CiAxr/jr3FuXrN6cDMthIAzprS3k6aJ/erwrYJzKKbw=;
	b=hurPCegBgNd6Z69svrXjujR5czD8uc2i4f40Yqbr56NDaksAGUUFZAYXo76A3OTt5ba1aJ
	5XjY+fqy8GBThd1ez3ZA4j4t1XrxVWfY0sik1zp8VqiC4/0XF/25pmfbtH4/Fvv9Jw9g1X
	0uhxm5MogAs90otv/hAu3NLigtmUMXc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e+NWqGr+;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766526065; a=rsa-sha256;
	cv=none;
	b=Ti85gGm9j3uW9Id8Q8OK8IelNxy677zk4VofHQHWD0k5BZPeEyySAO/0ybO+4mIW/a3wSu
	2rvCFPSg5sZwSxqbfyigLbZ+cNM86oIo1x7OyJhTbzc2k3YX06//CnUKitcXBs+RAb1wwY
	pxEtemDwhamGznpuKO4gudwWeUse9UE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 73E686014E;
	Tue, 23 Dec 2025 21:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2F4C113D0;
	Tue, 23 Dec 2025 21:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766526065;
	bh=W3HxSY2RwX3H9YY1vxQutvRujCU+HdANvwda7ib8N5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+NWqGr+Yf4O5nnD+ywIa3mHdqiAVrAxHl/eU9mmue0DLZASBjHt93WAweUTKRjpY
	 i4nyhauR2ggiQzzUAiar/nb79XsXz+N3zvaoWgRryts3+WoY8xxiBQROAhPbj05nSP
	 Y6jSBwlgDt+bEQrSoLvxFzQNjk8skpDj0k62O2H0YKdi8uBKS+/o6AUxdXUqhirCry
	 3pm2XnpXEy6PaH3KSdI5O+qY+lkmCZY2M5yMxdFhYfaabCApoYDM3fTa4/m/cYSvoU
	 prD6j7tOQviYKtfPgYGLiklBwJ6w6uCaA6MxdHbsSMGTlXe2Nu+903I+PT/W1/moRX
	 nbE0AU2KEpBYw==
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
Subject: [PATCH RESEND v3 3/4] mm/rmap: fix two comments related to huge_pmd_unshare()
Date: Tue, 23 Dec 2025 22:40:36 +0100
Message-ID: <20251223214037.580860-4-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251223214037.580860-1-david@kernel.org>
References: <20251223214037.580860-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: fcma866nmdg4e4i4316d8uik1f45b63b
X-Rspam-User: 
X-Rspamd-Queue-Id: DBB48180013
X-HE-Tag: 1766526065-595935
X-HE-Meta: U2FsdGVkX1/C9gLTREB04eGT2yPe5cwrzqr56jCQhXNrgX7lfxJu0nyCnOEuAX76o1y5MsCBsZjrdNBtV+StsxqhCwSjq44PcUJrAeN35MqKaXXx4VXmHh47G0lo64sdsdea7b/LdlAR9+51bIHbV0jK9lZch7FMfiqTwP6xtIkx3RZaWLrr7ul7++2eRoC90QolPaxuAPRR3Mj+jT+GrW+ndfRJZ4uYuJjPZCXumL5knezlz09Cx2ZYdXu+WlXR2eYlG42w8J5CiR6AGJgDqytCnbZZMIC7Sc99VhZiY/4NhEsqSzL9uOlNklKMDpTRPKMztDPFlsKPHZP13I0c1jFwn95HNLjrBY60ItMdsvLjpSsWxleADyvmOkRmAvDN/LnWfBHyNLrnicJ6qJtfadg7ZsGm9VCroDu+KCV5FblFKVTiCBHM2I/wCN4zk3tUnZ2zDchd83emUaBoyzPC9rQ76qoozdhAhnSfCtoqQ0b/4lLC5zdKQcOhsXgE2ncXHCUWmzd/Oq3IskUu9M9mJmwq+v7HmyDcyAsAox9SRxB/Yx5tw8/tqxZN1MW9OjUMQTqbeZXLF0zxyt8Zy82YYnIRRnXPETL4Xprwjw8p8n6NQjf5hw5/0ilJ3nbZti089tnlA2toPbiTl1bUY69ZMb5489hhZKApm1nOt2AOmcmCsaQcOkp4zlH0Q/gVdP0I1nO31fE/Im7gcKupJsswImp1llQQPFOa6XTFb8Zeh9AZbkC6ZfwSEIRcJPP8DEgN1JJAVZ9FhOzEPxCP9LZT/iji9KYQxEP0H1RAiWYxNHNRNxVct36apZgfY7Y6fE6Z/nzvokQ7zSCw7GwJkNFl9pSiYQWDCyycmxK/0Jwc3xx9lbBjUAyBjdSt5KTXGWc5HHFbYqkVDQK+ayPtdGdI+VHjYNQTcpCyrWIc2zVFOe3YKBRHuvuImw3Vcsmlw+Z75ykz2VGmGihCPUonX32
 ck9BqTIh
 r1ZeYUbcKYlLPS0VyxcYOFH4nV0JYCUdmliEOMTXu1SwHT17dfwL4iqV+Ato76JsAqIX6uKnUG7cuYWOiZyiwJoZgmoGZOy+8Nyp6upY2byZ/RwNUVLfdrvXoCpcVPzWmbg5YFmeeOodETzYcC7lO2IjAciQmFRXhArgtRRjPUHWfOjZzL8dMYD9q8Z1kE48XkcxezrvHIwaFFQ1zR2yJw+PSES4COTMttUZRJFIW/QmkXrih/b+kvi6q6oOGFQU4Ot0Ijp8E4zHk7ifurU7UmSGs19jlFUIA49EAUnBFazzo96o52qCgsgbALpwW4K+03+0SjtczX3efD+S93b4MVcoaRh/qgzKXGNvKQgM0VdLLaDkPUzP1UXdfyLYwWK1wcEYZQNaEHh4af6Fh0KL1fGxbxQY0X9XoeldbGMpJ+IcGIaBkGFnWRlg4MplKfGf7kFW4qlxKfwnlyzmBDKdd1dI3jfhI9kIKscgR
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


