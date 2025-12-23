Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1B41E6F082
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 10:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8A586B0005; Tue, 23 Dec 2025 05:45:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D3B6B0089; Tue, 23 Dec 2025 05:45:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19A86B008A; Tue, 23 Dec 2025 05:45:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C07026B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:45:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40466C0217
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:45:03 +0000 (UTC)
X-FDA: 84250403286.05.3162CB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5C44C0007
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:45:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jON0z822;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766486701; a=rsa-sha256;
	cv=none;
	b=0g5LsGICbLO9Rd19bCE+E81nckJd/u3ZHNS/L2m7NTa/cRAgR3x6zkmiCMx491KDm3//M/
	SUSUxJjWj/Echp8rD9ZApDQqeyaCdil0pJTRq1+pvsvAk4+se7GgX3vUddufgL7Uh9Lbk4
	zfcUH6+6ck2wdW5oIEMWgjGaW0fQylQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jON0z822;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766486701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9IYOnHMXqXm+Tf4oCMVqcfeNEvc4/yNfUdZAwxsTL8g=;
	b=nGqaGGC5vgfd/A6CtNzdqzVDmNKuOYNZ0CnxeJHfx7TXcEyjS/y3qwH2zsmpXg2oGGqmUT
	MAL+TtY+e4nFlYKNn2/49J+IjruUm4BFpX9+23B3Dda6d3SlFKoYEJQggGigK/fJUyG6lu
	0C7xF8emTy/VY0A8VVQd8TBceflu57I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 059D1600CB;
	Tue, 23 Dec 2025 10:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4CCC113D0;
	Tue, 23 Dec 2025 10:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766486700;
	bh=OvvBh3rBFu8/YoqGW0OVMvMC2gUrUjk3BKp4jAKJ5cY=;
	h=From:To:Cc:Subject:Date:From;
	b=jON0z822WBdoyLOJjLlvfkXrkqu6HzPdAhG8rpHn/N9eKY3CAu/hCCf7Mc4j2i/3l
	 hQiirZPJNV6uayyXXW51Barhq2M0Oa6KnLSM/vQeC+Y6KjefyvIhwaEuAR5pqK3AoZ
	 3DlDLXkZQkezL9+VkCxrIL0bM/oonhQU2/sIVyLQjQXFHPRysv/bBvCBRsrMcS+vzp
	 S6Z2SQNs8mupbsAA0VwpK3E0LXKHx/2ycceFBxo7wGY3f4Wv80blA2g97eD8TDzUyq
	 jDiJ2DAupbad9j42rzqQjqjaS/lPfm8t8D654SsZM6Dor5tQ8iFxzCBQ7Gn+oO//u7
	 kEvymJfuv8F7A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kho: simplify page initialization in kho_restore_page()
Date: Tue, 23 Dec 2025 11:44:46 +0100
Message-ID: <20251223104448.195589-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C5C44C0007
X-Rspamd-Server: rspam03
X-Stat-Signature: s7oy645b1mgtmxwosu7nomisa5t3gde1
X-Rspam-User: 
X-HE-Tag: 1766486701-287770
X-HE-Meta: U2FsdGVkX19P7O3rDhs/l79rHeFz70jkV7s40QxmIJ1Y+b80VWUnPh/uyR8RBtzuDjacvDBL7LDvt4uyvSyZhxOXcKkyxsM/J7xG6UrKlYrB/VFYKbE0vfH1XWnu7YlVwsdD8iyHD+k1LkH+mJG6GJNJ0pIUpViAmjpXwBzsoiqzrV1W0ljIUyoKuwOpNJn1XpiE+XrQW6T0yfIWD8ov/u5Esg/He7GYUoqGse2bN8VWM3/g+KOOadcjZEBe8i8U3PTShWd8Y2uAXO7YklrL0G676UKJG9faQhdz5J86uAaxO+9ryYsCbW+S1a0VSkaZEtgCmkh/qaqKT2+OlSPLw97hVaMJdOMGKsuBkGIobMuuDJ9E7hJ8CchyAJVisj7Jes15L+cElLuvXBhy/KBvpZFl4Nf8g/kdhxOYDF2xSg/TRA8SMXkrb/zfRPibLLY4kewx+zZqyXq/YR02Igmh5gfm2naXSBzQzFOXynC9F5CxXihSNqoZRafLeWAP1Mp5+AMxh4dyAxrFQvGOisKTOPknHNJeE4Cs+89fEj82NVtB0BjHB5eyMqVo60dSLZhQadv7KK9XsTNXUE8eCPD79cqbddLh9zq8PRckHikABOBvCeqFW1mDupBVgc0hDWWeXZ411lh8H7+j1F+sebs1mR2BmIQOOFOv+gHN28SS7gr23oNtJ7pqP96//v+OuMbcCppn6pnrQ/FiBsBmD7YvTGr+SAVfofYBh3d8un1yUhat1vLg2Klob1ZF/uHpkdXELHgqfMez4ILKO2Pdcvo0/Nt73wrMgpGJGezD8yGLJfoexP8hCTOJ8Koi2jFkIpEntsfNrLULpN4hK/KGMuvmuhclC9IuC4TYQ5M7hxmAJhkvN3dGtqw7ekyU5dCvGj2gle+AJgTTESpeXwaWCSxOf+z63R0Ed+HSFw/aWiDJMnVG0+0BkmA2pcUGOYysR5NftuvqLJ3DMEs1+2L0qlF
 0YN52C6g
 k+dZdUc6CD3yuDqXa5Dc3CZNrEUxrQRBrR1Ap1pz4e4aQ4ajsGWZwu0GrOeQRNxNequnMbVdXmyHWnugrYLK3YdnIpLaRto+1x6koijB/3UFdLqiZv9MgmCncS18B8CqU7os6NCAXJMfWUwiUdRIv6cuArogA0MGw24WVz0FCWAlmVA8MthNEM/NKT+Hh0jSXCa9TOlyG/xgvjPjLzHg3yEkfbi3FdLbub24S6b0qHT9l2y26Ej5auHsoE7xUxT2S6d2NjjRVifhPHK6ljNlDvasV1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When restoring a page (from kho_restore_pages()) or folio (from
kho_restore_folio()), KHO must initialize the struct page. The
initialization differs slightly depending on if a folio is requested or
a set of 0-order pages is requested.

Conceptually, it is quite simple to understand. When restoring 0-order
pages, each page gets a refcount of 1 and that's it. When restoring a
folio, head page gets a refcount of 1 and tail pages get 0.

kho_restore_page() tries to combine the two separate initialization flow
into one piece of code. While it works fine, it is more complicated to
read than it needs to be. Make the code simpler by splitting the two
initalization paths into two separate functions. This improves
readability by clearly showing how each type must be initialized.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---

Notes:
    This patch is a follow up from
    https://lore.kernel.org/linux-mm/86ms42mj44.fsf@kernel.org/

 kernel/liveupdate/kexec_handover.c | 41 ++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 2d9ce33c63dc..304c26fd5ee6 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -219,11 +219,33 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 	return 0;
 }
 
+/* For physically contiguous 0-order pages. */
+static void kho_init_pages(struct page *page, unsigned int nr_pages)
+{
+	for (unsigned int i = 0; i < nr_pages; i++)
+		set_page_count(page + i, 1);
+}
+
+static void kho_init_folio(struct page *page, unsigned int order)
+{
+	unsigned int nr_pages = (1 << order);
+
+	/* Head page gets refcount of 1. */
+	set_page_count(page, 1);
+
+	/* For higher order folios, tail pages get a page count of zero. */
+	for (unsigned int i = 1; i < nr_pages; i++)
+		set_page_count(page + i, 0);
+
+	if (order > 0)
+		prep_compound_page(page, order);
+}
+
 static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
-	unsigned int nr_pages, ref_cnt;
 	union kho_page_info info;
+	unsigned int nr_pages;
 
 	if (!page)
 		return NULL;
@@ -240,20 +262,11 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 
 	/* Clear private to make sure later restores on this page error out. */
 	page->private = 0;
-	/* Head page gets refcount of 1. */
-	set_page_count(page, 1);
 
-	/*
-	 * For higher order folios, tail pages get a page count of zero.
-	 * For physically contiguous order-0 pages every pages gets a page
-	 * count of 1
-	 */
-	ref_cnt = is_folio ? 0 : 1;
-	for (unsigned int i = 1; i < nr_pages; i++)
-		set_page_count(page + i, ref_cnt);
-
-	if (is_folio && info.order)
-		prep_compound_page(page, info.order);
+	if (is_folio)
+		kho_init_folio(page, info.order);
+	else
+		kho_init_pages(page, nr_pages);
 
 	adjust_managed_page_count(page, nr_pages);
 	return page;

base-commit: 9f7b37a7c250baf3092719d4ebc9a8edaa79a7b4
-- 
2.43.0


