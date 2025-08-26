Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20BABCA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 15:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528A76B015D; Tue, 26 Aug 2025 11:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500076B015E; Tue, 26 Aug 2025 11:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43D516B015F; Tue, 26 Aug 2025 11:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 335876B015D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:37:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0D19B6EA0
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:37:40 +0000 (UTC)
X-FDA: 83819313480.16.BD838B7
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf26.hostedemail.com (Postfix) with ESMTP id EAD97140003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:37:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf26.hostedemail.com: domain of aris@ruivo.org has no SPF policy when checking 173.14.175.98) smtp.mailfrom=aris@ruivo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756222659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=3aq0gwnAvZA7qhtpk0Doo52Fu0ctEb6sp1PfDIBh6+0=;
	b=S9l/styE6QI9/2lt9vX/gd5THtShGxf7PCOpChccqQ0Eg7d1sfQlCzJQ8TzK9qFZhx8Elj
	FmmW+yKH4hZrxYc87StfYn6sgLP7CtA6u+1+jYQIX8SMF2JWIuumEWVJEU5sibQw8EKXMe
	2Ezc3L92ORNXLYthBAX8MfB5d6+mN2E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756222659; a=rsa-sha256;
	cv=none;
	b=y8o8Xy5+S4MJOORRS/q2JiM6ZW59hp7wEin7lYy3DiMVfKSXEYUf6yNvYCTn3sEx7Xlmjk
	OBuT0w3tDDmWWCTVAWQ4ohuLb9+rv0wPxxl5rqyu0QTgvGx96BDlIRpV/nbdx0APRlHRYS
	7ZAM2x7Go1HCv03QthGOdKxRAg9OZ1A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf26.hostedemail.com: domain of aris@ruivo.org has no SPF policy when checking 173.14.175.98) smtp.mailfrom=aris@ruivo.org
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id 065D6526E5; Tue, 26 Aug 2025 11:37:38 -0400 (EDT)
Received: from jake.ruivo.org (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id 55D8E5238A;
	Tue, 26 Aug 2025 11:37:21 -0400 (EDT)
Received: by jake.ruivo.org (Postfix, from userid 1000)
	id 4106E17A0A19; Tue, 26 Aug 2025 11:37:21 -0400 (EDT)
Date: Tue, 26 Aug 2025 11:37:21 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Subject: [PATCH] mm: make folio page count functions return unsigned
Message-ID: <20250826153721.GA23292@cathedrallabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EAD97140003
X-Stat-Signature: 58p1q6k3cz8weisyu5sfyf1dfuiokh34
X-HE-Tag: 1756222658-957490
X-HE-Meta: U2FsdGVkX1+I1sKJN3knb8ezFHUewrZEA+FPIC1HFRsaOK9ImaBg7Mv6eAobaDQD84PJKrGSU/Un/goXVe11a5b+uUbjXNvoBNHpiF4EUK0ZzytTvcFs31NF3ti3JyW3HV/Y9AfO2nAmBeUq+hVm0uwHYTJuUxEFawi0vF5AfBXw3Se3YsxFqTTc1r5T7hW/3g7ZvaSfLWtlGgFG3gOGHZYHu/ihfjg1UAgiggdi8Xe9/r9Z8F6s+2E1I/mIJlRwxlmNDs/gGK69KsGU3mqseJnDbOBExKu3lc64mhNi3lgbDmmRpV1nUzUGsoJd2J8TStCpQ7UCK6s89KQAsv4Gsrw+wmKyokJ8fs4ewiDn8wA7RfTjGn/roJvyKdK+3YC47QXLBznJ7ImSKKHwQBzN+wlcfNdWgoGKEX0tryyDftMW4AD//VlvlYodofLcVhP69dcrBl9nMhX0APkApMSksvM+4hs0d9ykcOBOM4bOV9TtzvtpVt3bJ3qROdF3afK5yC9J1unU0p36w9orl6j7KR3uDQW8Ds7QsRKre1FzS+yMTffUXvWJq0W2qD+NRa+1P/scOmgdWugL9A6WUIg22g1Tqnz1D9Q3rUvUkKD84CasNQb97sFhIKTqeh/elsPlibw1kqYpCn4b0GGuOWWPnUaeWov/ISQrxxChECs7RXI4OxZDswH0uGrtdMpsPrGvJNzNnDphAHT3ObVY6N8B/Gon/q74EvciPOBzSPNXVfFDehxN39TV2x5RfVMPsoeqmqNglzHQC9jHDEtapo9QzIBj+CXZqZDc6K51yVPkK+iNXh8Uwu3LQtcWScECqyeB5jYI6hlVvj4LayAAmW5v+lRUFkF9nTSDauN/YP86fPbcJK/7G4CtiMzq1QZA7Xd6H7C0tvyChB4t3bw3ZZu2W8n4TP9aLikZvlloUFqkyLH8/Sl6W+WkR7rkUrn7RJCjrfnWQhnWm+JwnEOB5KU
 Svj4DZ3E
 4TQ3CFFKdlgHvOhwddbcPB5+gpFlwdfIVmCwh8+5I5JW6+DQ7aDezYH6+K1YfM7WSzBfSeMu5fyyFDb5+QD2W6OHDOWu/6ZFN3LqhmSsFlAg66g+SGeB0/oTPxdB4RsUpHo5uF3iwd3mOtN+mBhzse5S8+JyjTCegvDtKUwUZFvq6TonRzIOBnLtTbra6QY0DZBYpeVaTgRE9QRPsButD0Hw1fW58oYte0WY0NkCDNgFKTXue7kabcoLRvjBHxmFC3dk2Tel4AQ74ODSmYgWcSQ/nSEUGfy78ZYlVa+vecccBChdwyS7zmQqnXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As raised by Andrew [1], a folio/compound page never spans a negative number
of pages. Consequently, let's use "unsigned long" instead of "long"
consistently for folio_nr_pages(), folio_large_nr_pages() and compound_nr().

Using "unsigned long" as return value is fine, because even
"(long)-folio_nr_pages()" will keep on working as expected. Using "unsigned
int" instead would actually break these use cases.

This patch takes the first step changing these to return unsigned long (and
making drm_gem_get_pages() use the new types instead of replacing min()).

In the future, we might want to make more callers of these functions to
consistently use "unsigned long".

[1] https://lore.kernel.org/linux-mm/20250503182858.5a02729fcffd6d4723afcfc2@linux-foundation.org/

Link: https://lore.kernel.org/linux-mm/20250503182858.5a02729fcffd6d4723afcfc2@linux-foundation.org/
Signed-off-by: Aristeu Rozanski <aris@ruivo.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>

---
 drivers/gpu/drm/drm_gem.c |    4 ++--
 include/linux/mm.h        |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- linus-2.6.orig/drivers/gpu/drm/drm_gem.c	2025-08-11 14:52:45.878752324 -0400
+++ linus-2.6/drivers/gpu/drm/drm_gem.c	2025-08-19 00:31:01.495295839 -0400
@@ -620,7 +620,7 @@ struct page **drm_gem_get_pages(struct d
 	struct page **pages;
 	struct folio *folio;
 	struct folio_batch fbatch;
-	long i, j, npages;
+	unsigned long i, j, npages;
 
 	if (WARN_ON(!obj->filp))
 		return ERR_PTR(-EINVAL);
@@ -644,7 +644,7 @@ WARN_ON((obj->size & (PAGE_SIZE - 1)) !=
 
 	i = 0;
 	while (i < npages) {
-		long nr;
+		unsigned long nr;
 		folio = shmem_read_folio_gfp(mapping, i,
 				mapping_gfp_mask(mapping));
 		if (IS_ERR(folio))
--- linus-2.6.orig/include/linux/mm.h	2025-08-11 14:52:45.878752324 -0400
+++ linus-2.6/include/linux/mm.h	2025-08-11 14:53:00.396630632 -0400
@@ -951,12 +951,12 @@ return folio->_flags_1 & 0xff;
 }
 
 #ifdef NR_PAGES_IN_LARGE_FOLIO
-static inline long folio_large_nr_pages(const struct folio *folio)
+static inline unsigned long folio_large_nr_pages(const struct folio *folio)
 {
 	return folio->_nr_pages;
 }
 #else
-static inline long folio_large_nr_pages(const struct folio *folio)
+static inline unsigned long folio_large_nr_pages(const struct folio *folio)
 {
 	return 1L << folio_large_order(folio);
 }
@@ -1971,7 +1971,7 @@ static inline void set_page_links(struct
  *
  * Return: A positive power of two.
  */
-static inline long folio_nr_pages(const struct folio *folio)
+static inline unsigned long folio_nr_pages(const struct folio *folio)
 {
 	if (!folio_test_large(folio))
 		return 1;
@@ -1990,7 +1990,7 @@ static inline long folio_nr_pages(const
  * page.  compound_nr() can be called on a tail page, and is defined to
  * return 1 in that case.
  */
-static inline long compound_nr(struct page *page)
+static inline unsigned long compound_nr(struct page *page)
 {
 	struct folio *folio = (struct folio *)page;
 

