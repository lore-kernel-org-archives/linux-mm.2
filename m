Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85870C5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 01:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F0326B007B; Sun,  9 Aug 2026 21:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1176B008A; Sun,  9 Aug 2026 21:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6DC6B008C; Sun,  9 Aug 2026 21:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 197FA6B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 21:09:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19AD31205DF
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 01:09:03 +0000 (UTC)
X-FDA: 85083575766.20.337F88B
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8FF182000E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 01:09:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=jH36bWdH;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786324140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0J6vE+M6GXmj6wruBJq705a8UBdBkuRmzd+D8Xhn9KI=;
	b=0MSqJRPMXqqOiyUoHo+CvLXmimaGzXQhD+GlnZbzK8EVpGN45UqP/g28Nc6zKpf6Nq2aPK
	xBIeeidv8oUd+TtvCQVUkfKTXnOyL9r8p16mygHnqE1ilXoEjSnMLIF095enflXhXspe8F
	8cXBdBKeH0dIefwr+L/4TKYIBoezMrA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=jH36bWdH;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786324140;
	b=8ewakvA8IHaYgFLp9R/Dgj9itAK5W0G8+H+ppYQdhdTMy3xxovofjpuYQPFCsU5GFtMtl/
	LzV+5UkiRNLDuBprXrnIv5S9vvIKybO7KoZRpqCg/8EWo56X4+9mM8bhHhDWUyNYZqijDu
	qCQTmQiwC3Jbl8s3OjW2LWQOEqpSE6E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0J6vE+M6GXmj6wruBJq705a8UBdBkuRmzd+D8Xhn9KI=; b=jH36bWdHlvCL3AAMg+oKExRRIV
	ocZON57aM4aKu3Lb/kBaroH7/jHTkLO2QrXg2GQPmemDbMz42qztkvk1SeovSTIA0RE7wi7rBDS82
	ufu0mRtlTR3IOUZ/UGnBS2Ui7OsvzOE6iUxOd5GOIkUzRkNYMtw58uanhDEJPjCGnkxWldGYQSyuZ
	v7V8rua6MGo+wNKa/u9MVyYaNxqtKJM+SFXDuYVmUWyR5eDUt7ijNyG/irp8a4xmEgYZOW+eCL6AV
	J89qwBsXfxky6fFQx4A9WVFjDT/LGMMFG7Qcmr9F0cYA8nFZHkPcr7rzWIaBn+CEt10cKdtHelwVk
	QX8vjp2w==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtESu-000000001bM-2QWe;
	Sun, 09 Aug 2026 21:06:08 -0400
Date: Sun, 9 Aug 2026 21:06:08 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [RFC PATCH] mm/cma: don't release CMA pages still in use
Message-ID: <20260809210608.06b5ccb9@fangorn>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wyq9kcowp9qtnfp8h4qyyq17erb6pz38
X-Rspamd-Queue-Id: 8FF182000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786324140-152266
X-HE-Meta: U2FsdGVkX1+dvrWIVviBcwHM2R+M1wbOat2HRO0Xn7wmG+UlmV1RQAx+BHAM1BKQw1Ojw6lkQ8YaG66PBUHYIspdqvwb8NhD6estL+QJofiQ0A/dTc48odAcRKC/CcN635HgJuMu2YZVwTDcMKLB4W5ahCtmUol9+SEWPLmKuRwOs/451KTnrwWkDUL62b/+NndhbimzRsWCZoQmWykzvS+EXE6HTVUHU8zwJNaC1uF1wtjgDcjFghoDtNAvH8Lg7YIlVBoepx5FnOmwbCFZsczV/gYhsKFrTbdfXd/e94ZvSidr4DxWCwv7peWMO3Ot0UVmMuVjUcqYqfcL2U6/+AQXeiQKXCF5PhWv1u2zD5nOjqW65eC6unzMwuP7TyU1mQ/rTa1IkD2aBsEhUohwiWDmYzuaBlOqydTOjo+kpz/slIYLlPOgjZBglCBMDFXDRKmBbzB4nlwPwAOGhFtHDNnCNhdILXD0gRiIIampOURgAl+Arsaldv3uw/mnK49/ulm+jxzx1BzyZJ2hhpjEf2wf03RZFljgAl3ACkh4IZ/9cYSJxjJtc2YuLjdFuYoVqZMPPXxHu1ierVqidN9Rn2IulWFRQ4/0fVgUi7hr5asksreZ35+tGJuANixrI/CbEgUDlCmWNZtuTDT4/sQmBB20BX51llYPazYqXbZgVbi21wRWNPwDWBOD7rg8kVNdX2mM+nGTbb6Ic4n6qZkusgWu+Ln1Qww8LRqkNymITniEtOG7hMTzMACpTjpmsnwm/PqAlESKt/fkTAy6jCdo4JzpVmqPw2VnvcYu9uNE8Yf0ubJdf0/rJ0RnhWVpWh1tODQBbXMk9aA2FhUwwH8PxCZJ2A2RfURgjExvBvfTQjz6XdDJYjLMNdc9fPNskrHr38UjzkSBc42ovcjOhSUxZ5H/HjMfKHRlzO0HPBOhW0FSVe/3nxUlL9LwUpOtJowrJ9AUoGzrU12XV1wXMhn
 3zJ3R6N2
 9XXaVHEFj/CExJ4H1ZChaGNybQUKIJTtBHByRV83i4DoFAR1YP9HGRlzETxNjJscoUxxcvB5WpkvhUYTxy7rIr76cpcwsESepJsfaNSL8Id7nOj6+ZTx4PY2+5GgxS2xZbA5Bd6UFNYbrLhmN3169lcistbt8Z4+fgegjyrK3nZsb7R4RDFUUjzALwKzr5E4EL0NnIkUBYRA6RZ3vr8uwI3EgwLrx1A8QKIUFwnEfWHiacxOQ7B18D+XprqdMjzJEx5Nl4+kZUZleoxgFVUFitOJV/ELv2XwLJX3DGI9l7+ObSAA1L0bS8RqbqilCDSUzsO3FgyCvbctPdtl9M7mTvowjDykaLdPr8uSCLPDWwwazzoG8vLbbMCDQ6v3qPcvw/A70
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a driver calls dma_free_contiguous() before quiescing DMA, the
page still has a reference from the device. put_page_testzero() there
returns false, ret is incremented, WARN fires, but the code proceeds
to free_contig_frozen_range() putting a live page onto buddy and
clearing the bitmap. Later cma_alloc() hands the same PFN to a new
owner while the original holder still references it.

A concurrent put_page() that drops the last reference between the
testzero loop and free_contig_frozen_range() can double-queue the page
via page->lru, corrupting buddy lists.

Fix by freeing already-frozen pages in contiguous runs via
__cma_release_frozen(), while skipping still-referenced pages.
The CMA address space for pages that are still in use at
cma_release() time gets leaked, but the pages themselves
will get freed once the user drops the last refcount.

This change should be safe because nothing can get reallocated while it
is still in use.

Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Cc: stable@vger.kernel.org
Assisted-by: Hermes:muse-spark-1.2
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/cma.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index a13ce4999b39..66952bb03abb 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -1018,20 +1018,42 @@ bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
 	struct cma_memrange *cmr;
-	unsigned long ret = 0;
+	unsigned long skipped = 0;
 	unsigned long i, pfn;
+	unsigned long base_pfn;
+	unsigned long run_start = 0;
+	unsigned long run_len = 0;
 
 	cmr = find_cma_memrange(cma, pages, count);
 	if (!cmr)
 		return false;
 
-	pfn = page_to_pfn(pages);
-	for (i = 0; i < count; i++, pfn++)
-		ret += !put_page_testzero(pfn_to_page(pfn));
-
-	WARN(ret, "%lu pages are still in use!\n", ret);
+	base_pfn = page_to_pfn(pages);
+	pfn = base_pfn;
+	for (i = 0; i < count; i++, pfn++) {
+		if (put_page_testzero(pfn_to_page(pfn))) {
+			/* Add it to the batch. */
+			if (run_len == 0)
+				run_start = pfn;
+			run_len++;
+		} else {
+			/*
+			 * This page is still in use! Free the freeable
+			 * pages encountered so far, but skip this page.
+			 */
+			if (run_len) {
+				__cma_release_frozen(cma, cmr,
+						     pfn_to_page(run_start),
+						     run_len);
+				run_len = 0;
+			}
+			skipped++;
+		}
+	}
+	if (run_len)
+		__cma_release_frozen(cma, cmr, pfn_to_page(run_start), run_len);
 
-	__cma_release_frozen(cma, cmr, pages, count);
+	WARN(skipped, "%lu pages are still in use!\n", skipped);
 
 	return true;
 }
-- 
2.55.0


