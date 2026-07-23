Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D7A4C531D4
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5124F6B0092; Thu, 23 Jul 2026 10:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3586B0093; Thu, 23 Jul 2026 10:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8D16B0095; Thu, 23 Jul 2026 10:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 182DE6B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:30:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82C1280404
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:30:47 +0000 (UTC)
X-FDA: 85020277734.30.9E73294
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id CA2518000B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:30:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p0BjXa2k;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817045;
	b=ltcPVypTtzFshspdk8iE/OJGqoOyjrvcl0IvbIF1Gm16B7YwobPiz04K+I+ybxiJHrPWPY
	N6VInfya1OnftYifJHYbK1og6rmID6oak4UMK8+C1He3/C2h7C3KnFikU8OLmbuNpesuCi
	u771QqdHbcyWg/BXHkErNgCxHguZElk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p0BjXa2k;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwsU3Mhrg9KcuFxTAl0Tes+dvmZix99ipM91bAbmnN8=;
	b=wku05+OKKD5TJLYwynGfezV8XtyVk4INCp+eOlEDC3xfxGX4zjvhlZfX6mMuG7S7RG5zUm
	ZFyO9dVmLIpHbtl78cRG4k1LQC9tTXZr7z52WfX3CQO9qW6BwVDnmUHNA49pApfNX6K2Dn
	QAiT0wXnb9XkFKhpBKqV3fTt1MbpIUg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=cwsU3Mhrg9KcuFxTAl0Tes+dvmZix99ipM91bAbmnN8=; b=p0BjXa2kEzvTX3Es+vq2+xSUBh
	yMDm18HK8DuM1ZL/O43br5EnYTlMFmswaGnixSTRvIi/62M74RVfGJJ9MsDxMkip/QR7Tp8I7vfBc
	LxJE0vnlOGEns0fF+c1/u9fRsr1Ggk+HbVb3G0Bu8s3cYjI/iNwLlJ3sryLtgIQElsveLp0mnzkEM
	BPja3cde6PwbqXTBCd1D7oVZi0/XcUN0Xl46EYds+Ku8Shi805YWRGTfwS2tJWW4XMEMXbFFJ9tAO
	Fwj1HMjKQgKOVIL8jeOcKtNkGeXb0Z1VB12O3FbmYm2Qk+NWe8HjWcMy+ARt+QRPjX4rFrxpUGpp2
	FBCiGZzg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRY-00000000jht-2pEi;
	Thu, 23 Jul 2026 14:30:36 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v4 03/14] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
Date: Thu, 23 Jul 2026 15:30:20 +0100
Message-ID: <20260723143034.175661-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CA2518000B
X-Stat-Signature: kcpnwg4trqqzko49ea8p41hwkuah6tc8
X-Rspam-User: 
X-HE-Tag: 1784817044-779547
X-HE-Meta: U2FsdGVkX1+MeUswloAPAob84Y4CL1vKOfcTFR0JCA8bwFBUYXrEsyR0cULeeinafE2t40yl8FfWdfwk3rq/FWy0eRYwKVTghkCI+HmbziONAvuM95jxi2KfT4X81KBq/ylh+bYzUVNLQG0P6AS5pTkxyTjqI+v/DqpaE2/rXm6UkEVSJKPZTWNWMuVV1VHawvtdBDKEyvjOMczP1Flps0iI3O+H9FwASKEqm+V3iCw+jc/CyXY40QE+SVrg0MWvksIrXzO3WzkZ9RUezTHdeGwD1j0db51F2/wu5z3EW87qGN0K0eQQFUFaxWq6cjpabRZ25nLgdVszjj2y3waPOxr7DwgzCyBZ56Q++NaJpdUDM5K+nzls2l5kAfp2xjCCul+3Z+UdSsTqhs4usY+2no2OAE+OFWBBYA9j1YIU5awI6iWg/41lNrEcjlOnt+8+UoW+T3O9znjIEwnthqwr5xsBltvMH+TtNF2l3EHEhf/n9rmrEsaCHlXb6PcNV0qaDBVMZLMDGJSGzjQTGqLaA9KWTIpfsSZQ4h9kHvVuArTOEzlh/w6yPqQg15CxQUeu+Z97bae3mr8xfghxLT6DWF7KJ7ePcu7IDn3wEFSipRUykGFfqdG7plomlhz1V3U3EmEUnlyI70tiiLdWDGHDX4sbkhVRhi19y9xZS2XaVH6hb8Oh3EABDZhwum84eivu1Ie/F+2ZrWjQTWzamqEVfKrSLO1JmQhj+HlT1jYhEzQWy6nJJSonYvYOwd/szPDlkAUDvitquOKJA8XuQS46gIN+oUgg19dWMG/8QCx3lyt0sfVhCVooGaH8QeuCfN+z1iaFQ35Sy4aX8aTWy8uLI/JSImlmiyhOKYXMwYz2AXtKODE2sfoD1NXFT71jtWb8+VA9BCZAOMaMViOdbBnu6V+61NjV3/mY3kKAKUmA55eAE6o87eeW0gEjx/HvsMeWpJuTG9QizH99CzDM6Lc
 TGVtdfnF
 AMnsvV0WZ+bI5cvGGCtY+R7Pvxd878ybRY00wyRCVia/vClgHZsKjNcmA8vysIer97eCfXed1Jb6iPBoGUwi8z9nMkY5lj4pEioP/X/7qhzUqSF6EDl6HSrvPZ2gM4PTovM0ExeMbndKzZ9hyLEhI5sfnSz3/ckzipq5teVXcCy4FKvV129eoLSYrsbmNkXDJoh6IqaiQoAF0jhciqvqL3o+Kefk4JXwxBA7ipX4wQfyjvUrOPZTpgORK+zpj3icBKaLM/NK37Cvw4CpN5/MPIxkcGl59pWSAKU/gefORL55y7lltI92gtkvzinJD2Di8Lfw6nM8L0qwDr/9y8rVN5O87yFYUOGAD3im/RfY7EIu+dhtcxuvirxRQOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a better name for this predicate.  Also make the argument const
to allow other callers to be made const.  No functional change.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/page-flags.h | 4 ++--
 mm/huge_memory.c           | 2 +-
 mm/memory_hotplug.c        | 2 +-
 mm/shmem.c                 | 2 +-
 mm/vmscan.c                | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7223f6f4e2b4..4185a03a45cf 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1083,10 +1083,10 @@ static inline bool is_page_hwpoison(const struct page *page)
 	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
 }
 
-static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
+static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
 {
 	return folio_test_hwpoison(folio) ||
-	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
+	       (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
 }
 
 bool is_free_buddy_page(const struct page *page);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..353340309107 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4413,7 +4413,7 @@ static bool thp_underused(struct folio *folio)
 	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
 		return false;
 
-	if (folio_contain_hwpoisoned_page(folio))
+	if (folio_has_hwpoisoned_page(folio))
 		return false;
 
 	for (i = 0; i < folio_nr_pages(folio); i++) {
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7ac19fab2263..33007e8e546a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1813,7 +1813,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		if (folio_test_large(folio))
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
 
-		if (folio_contain_hwpoisoned_page(folio)) {
+		if (folio_has_hwpoisoned_page(folio)) {
 			/*
 			 * unmap_poisoned_folio() cannot handle large folios
 			 * in all cases yet.
diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..492c9bef3620 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3240,7 +3240,7 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 	if (ret)
 		return ret;
 
-	if (folio_contain_hwpoisoned_page(folio)) {
+	if (folio_has_hwpoisoned_page(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		return -EIO;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..70e54ace0e74 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1086,7 +1086,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		if (!folio_trylock(folio))
 			goto keep;
 
-		if (folio_contain_hwpoisoned_page(folio)) {
+		if (folio_has_hwpoisoned_page(folio)) {
 			/*
 			 * unmap_poisoned_folio() can't handle large
 			 * folio, just skip it. memory_failure() will
-- 
2.47.3


