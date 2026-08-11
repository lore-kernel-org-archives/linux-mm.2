Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D31C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14A376B009D; Tue, 11 Aug 2026 13:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA906B00A2; Tue, 11 Aug 2026 13:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2BA36B00A3; Tue, 11 Aug 2026 13:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D15356B009D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:21:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DC6440181
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:21:08 +0000 (UTC)
X-FDA: 85089654216.06.20D31F6
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 57E7E40003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:21:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="QIAi/En5";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786468867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vdlN0I4eOAZv2Qy49qE60ejxX7ioV1x7Kb2lltJcp7E=;
	b=H3kWRtpcv3DBZN5N3BcLVyaoIfZLa2e1tnAbaGjLypfGi2s9hjbZCpo5QZVYW2bh4B34Hq
	jh+kAwn2mL17QJjVrvHJqKOusYQplc2tmsfwUq7L2EqAyUYFOVKRcdVG+Ht5E9x3FWZgOW
	cc2QnjchdC9+8Fr+xfCqNcI/1t2H3lI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="QIAi/En5";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786468867;
	b=qhz2BTHp8c+yQBi31bp9kAIUrn8HleIoPCEBKVWEvvVDPHptjHMD8vSNtkRzaoxg9GdnOV
	iLtcuLrbl5XEYWTb+u9NGhClEPKlDtjL8Yku9ONjFU5wEYvq0vERiLTLesYE4FYa6GzRRM
	vvOGTH0LNRxNDom6U0XAWQu0H+b6VbQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vdlN0I4eOAZv2Qy49qE60ejxX7ioV1x7Kb2lltJcp7E=; b=QIAi/En5UGoWdHRQsETDOCk6cO
	UmC77yL5DmC652os/5Os+ily2xRQzsxW3rOwiym6mtLSOKWiorbXACGAMgQMf/JiUcuM/qflpuhQS
	dhQxAKG15weXMrWjRRzELbWxZfxbeLwmjYvoBxeMK82KzTL+ZKOSTwYfFoKtBVsnFxYbTndsdDaaF
	dAY20Sj0UHcdPgY8uDgnKJC2OzVZ0ifW0cGB+7y6MeGQeI21b5Vk/ANE5EvKaoiZ4VsoMv1hNUzYr
	z6d8Vswjei0eEFVzs7ZuRjU/5zoL5g0HC73p9SbLaAacQp3Hh+vQf1Q02/oveJy+6blyKDqkeDHCd
	jeDPqMaA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtq9e-000000003gk-0Lbo;
	Tue, 11 Aug 2026 13:20:46 -0400
Date: Tue, 11 Aug 2026 13:20:45 -0400
From: Rik van Riel <riel@surriel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3] mm/cma: don't release CMA pages still in use
Message-ID: <20260811132045.5f114772@fangorn>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 57E7E40003
X-Stat-Signature: x9wqznu34erakabqrhqu9bdi3z1z6fb4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786468865-433606
X-HE-Meta: U2FsdGVkX1+zgMgcvDB5nXZYoC1rJyeV00WFS6zmiZyjobefMNFIudNBrYLPhwE9x2WPwbTHPDEjRGivZLREUhBW25v81Btn2WIhVoflD84qmnS77wWtODSbC5qKvkypQk+LDURX6+mnJFTwADhfEkgOQ9eajXQHago0E5uEHyABVuUsbH774CLYwkZHoa193hgVaLQ6janLqu2FznyKoxNPavxwAor6Tfh/dSX7Ouz8/98PN0OKaRDSNlNhHM+ZmHNoaDj44KG+NGWA26+8TzX1AwV5C6QmbAPEWSeShCJCEbuJMPFPgo+bovkAkdqP45e5x1ek5SHLB948fF6jeVpQfMvZeVS1gPAAKYC0CBOmeE662D65bmSE47YvwKcTacdZtfIgPVViEBXphW/tAsOptOH8vI7kzva/gcWXWs2jUgIKoku087u6c80VPPVDbPRXcrqS8MVpkL1rZBDfE0RudO91xGItLlxkCQxQj7NuB4VcWnRtpacMx5tJGhR37OVA8DWMOkg2vjOvoYo3NpUaEZee3tOQFAat6F/Sbxir1Ewu8xZI3TjafJFkal+zWMM7UyfOkVpIxjap1bys175az/kTSpnzhpia1pgX+KbNrrmYIu+Y2myZB9n4tHTlpaofO9huVFQWNlloqBneplHXO4bnrx+uNiBlD+DeFntKiTHBJNXIkkrTmFIAqbbcJBJv+u8LPJAO/lPajA7LmQNKJk9N2L/YZ3a4SKkQk5gmrMPsL+yjGht8e8CjycQtu8eu5QaM8B2eVwpVn/MJCywDiSSovfZK2epeeLuKSXlPHsZfpE9toQSl70nF9B4tAxkyne0tqx54CLyUDW6tRRHSdTHRTvnYWGrrBwWMSiuQ5YrEUnvDCHOkXN1qd/JHKrunfkoydgfIUPMT95D2wfuedP2S395/wqwS1G032DoxCRuOqoIUSh/V5OC2YTl9XXZHoVQyWlXOmJLxvyD
 rZ8mbKsv
 NtA43Wm++YNlSZ2zgoN1S9nkP/IUvDuB7UxCSMOrUsVnLHfcxkLzpVmtYfqeQduzz/r+R9tOzO2dRSGUhC+SrI3mgbHMDD277tpqYkAQlgRVkg9BhkK3hTUaKCaelKsvOz2+LLQu+fJltGI/MtRqU4p9yoer05X0Qr2aWmiXyq5lOlKzEsbElIwsB0Awb2//UIVBEPRTt4tNFplO8Mkgx3YPaTw2i9XJce2u9vC82ue+Dhm8hVte6WnYCljgv9rWQRyIeTZGYWfJqlQz4HsgDVJhfHxNbjxMS7npyT/go1BSlQTMn/Q4FLLVMwkzaOwG59XkUXX26wzLWqiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a driver calls dma_free_contiguous() before quiescing DMA, the
page still has a reference from the device. put_page_testzero() there
returns false, WARN fires, but the code proceeds to
free_contig_frozen_range() putting a live page onto buddy and clearing
the bitmap. A subsequent allocation can hand the same PFN to a new
owner while the original holder still references it.

A concurrent put_page() that drops the last reference between the
testzero loop and free_contig_frozen_range() can double-queue the page
via page->lru, corrupting buddy lists.

Avoid the corruption by not freeing a CMA region if any of the
pages inside are still in use.

Make it explicit in the warning that the driver allowed a leak.

Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Link: https://lore.kernel.org/linux-mm/20260809210608.06b5ccb9@fangorn/ [v1]
Link: https://lore.kernel.org/linux-mm/20260810122737.030f8452@fangorn/ [v2]
Cc: stable@vger.kernel.org
Signed-off-by: Rik van Riel <riel@surriel.com>
---
v3:
 - simplify things by simply leaking the CMA range, drivers should not
   call cma_release() while the space is still in use (David Hildenbrand)

 mm/cma.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index a13ce4999b39..c1425f25c39b 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -1018,7 +1018,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
 	struct cma_memrange *cmr;
-	unsigned long ret = 0;
+	unsigned long leaked = 0;
 	unsigned long i, pfn;
 
 	cmr = find_cma_memrange(cma, pages, count);
@@ -1027,9 +1027,12 @@ bool cma_release(struct cma *cma, const struct page *pages,
 
 	pfn = page_to_pfn(pages);
 	for (i = 0; i < count; i++, pfn++)
-		ret += !put_page_testzero(pfn_to_page(pfn));
+		leaked += !put_page_testzero(pfn_to_page(pfn));
 
-	WARN(ret, "%lu pages are still in use!\n", ret);
+	if (leaked) {
+		WARN(1, "%lu pages are still in use, not freeing CMA region!\n", leaked);
+		return true;
+	}
 
 	__cma_release_frozen(cma, cmr, pages, count);
 
-- 
2.55.0



