Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 456DBD47CD6
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465ED6B009D; Fri, 16 Jan 2026 06:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9656B009F; Fri, 16 Jan 2026 06:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 269566B00A0; Fri, 16 Jan 2026 06:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 150F36B009D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:22:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D54F413B5CB
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:22:35 +0000 (UTC)
X-FDA: 84337589070.01.E2C18CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DDAD580004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:22:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b8g0cLnT;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768562553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HArPDH30zUaP46WbpZrPeDtL/IH19i0ZCljZS0KUGpM=;
	b=m55CcmIQkSK8o4P1QhS8kmPXXyR0r5WebpL3Ld2f3G53sK0fBIkLGUYH3YKtG9X8pWl97v
	cdhzR4Kj3M3jF6cLqQpMNsg923HtOinRP/JizIzSXLX4qRm8k9gCwTamtt6RvCgJDTHoM1
	0xVjUgYoqkjXezVVAupJXZHmCoTY44g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b8g0cLnT;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768562553; a=rsa-sha256;
	cv=none;
	b=3ZF++HMLOkYVRpokTmOWymZXOAulyKjgjOIpGQ6zERFhqpZwCr15hsFJ8eUPiPD/0806QS
	uqWf0NhXwBYBEIBDvbyxq7W+SOo1MoEo+r85EuNBZiTt3mjRotYgW2fIXv2D1bw9mBDdPY
	jwK1KNHZWX+ZSREYBB8ZPF+8Zn9A+b8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CF516016F;
	Fri, 16 Jan 2026 11:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFEBC16AAE;
	Fri, 16 Jan 2026 11:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768562553;
	bh=AVBcqfwv4HnAqgcteSfH5IP5ilFZ6g7I/bqNeJQP95I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8g0cLnTmF6l+lcFfexSzl8Dhd7Ymz/1cfV1yF4r1erM2SBSuDQOTLjMRlD6vvnRF
	 urI7sQFDAFU0EmjW8uRHoSkjk2xjicicMxdJWsvKwl/t4Z1yvULV8YSl/+VnqzRKaX
	 SrCYw45GCQ+uhVjY/7p11O3iueRWY9NETYWrnVRqPdZZaY3i5UzzTRRYzrKw8ZGuhg
	 WgiZa5RV1vk+tQCa4CMdhTToIBNzlyX1cemal/VGTCt2IwVW4rCqEGzPa/P+cBAj7i
	 lYEAkMmAkY0nCU5hTuG2B9Dt9I5svhq7IO3MdTmCfRyQGjrf4FBkCJxlJdCtqgHk5E
	 Z1UC3TU1Vd+YA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v2 2/2] kho: simplify page initialization in kho_restore_page()
Date: Fri, 16 Jan 2026 11:22:15 +0000
Message-ID: <20260116112217.915803-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260116112217.915803-1-pratyush@kernel.org>
References: <20260116112217.915803-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DDAD580004
X-Stat-Signature: gwuuabuhr8ihz1x39wnpmkxtbb3eipr4
X-HE-Tag: 1768562553-238341
X-HE-Meta: U2FsdGVkX18FVrlXLploU37pBtUCKrDa/vHUczY0E4rtGY6in+C2HiWsgJsRUqCyDmyZmpfRPydukL2/dEiAxU675jwtjC5oavNQ6ickq9KYU+xlRLUGRFPoGPoz7Ats47dLg3WM7dxG980Vpt427N3hIAp6hU7fYIMRwFY+1HExgmvVazAk/AMUycB2L+tAq9Qy7DgARXJjQBYwih+Fq9IiduUeHn78U5xMicO7UIgFIr2ejCXmHpaW0M/32txeNbV8JyXW5ompDZh7XBlK2nrDjqFjk9LTLus8Ek03q/Q28U7Wki6zBZMzQvXe1riBgam4GfslqT0oCTYKYylO4ghzJyItgCqZsntuKeRMkCXl6dfOkEawOVwrKmC0nRjBTSMKdNKsPQ61gyJNu5wIZb6jrUUmzHJSBXTNc92qb0AQCVKAQTpA7xIoPbAmPAwdmAk/JuAQ8EgKrKxsMiD44SEWrsnHbCiUZbwhE6sNPWTNzVj+JCJGhyw/xDetjLRs/fVzgLQaf2gyGnwBT/qhSZxFD3yiCnnaM5J3GUk3ORyJuuGe4amZrhfsHUD7nHZiTsKxkAF6w0e/he6mEs0WJeML9Nyqm7HzFU1hBfxB7DcP01AuF9UiQFfVo/FKuxbpjudTUQrMD2xiuqd+YA3fFBahl91Kiiri19eBMAzv3Jd8pPO5Y4+5LuZ/SRnSckt3PQZCyEgz4AHgmSd20r92XqaK4cEHRuo1zGqG0YVPDaK0z1CkzBOwxNN/0zuWkGpOoeDh95y4SbWf9hgbUfqvHG5H1Jv43WIHKBRs933byuGx8CuIhwkPByqAgG59sPF+7B8ouEhL/QeIlEPfMc0sB3GQMD4uVbPEvYbMlrDNKHbroTAPbTXh9cUlkvIhivFVOM62WAFA1cVhDzEmI8y8k1Dqn4m6oU390nK6I5X5czAPeI/Z0VenU97fZAPpZZHPYbxSEFDHkfwMvR3+J4G
 0c5WOL6U
 PmmiK
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

Changes in v2:
- Use unsigned long for nr_pages.

 kernel/liveupdate/kexec_handover.c | 40 +++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 709484fbf9fd..92da76977684 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -219,11 +219,32 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 	return 0;
 }
 
+/* For physically contiguous 0-order pages. */
+static void kho_init_pages(struct page *page, unsigned long nr_pages)
+{
+	for (unsigned long i = 0; i < nr_pages; i++)
+		set_page_count(page + i, 1);
+}
+
+static void kho_init_folio(struct page *page, unsigned int order)
+{
+	unsigned long nr_pages = (1 << order);
+
+	/* Head page gets refcount of 1. */
+	set_page_count(page, 1);
+
+	/* For higher order folios, tail pages get a page count of zero. */
+	for (unsigned long i = 1; i < nr_pages; i++)
+		set_page_count(page + i, 0);
+
+	if (order > 0)
+		prep_compound_page(page, order);
+}
+
 static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
 	unsigned long nr_pages;
-	unsigned int ref_cnt;
 	union kho_page_info info;
 
 	if (!page)
@@ -241,20 +262,11 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 
 	/* Clear private to make sure later restores on this page error out. */
 	page->private = 0;
-	/* Head page gets refcount of 1. */
-	set_page_count(page, 1);
-
-	/*
-	 * For higher order folios, tail pages get a page count of zero.
-	 * For physically contiguous order-0 pages every pages gets a page
-	 * count of 1
-	 */
-	ref_cnt = is_folio ? 0 : 1;
-	for (unsigned long i = 1; i < nr_pages; i++)
-		set_page_count(page + i, ref_cnt);
 
-	if (is_folio && info.order)
-		prep_compound_page(page, info.order);
+	if (is_folio)
+		kho_init_folio(page, info.order);
+	else
+		kho_init_pages(page, nr_pages);
 
 	adjust_managed_page_count(page, nr_pages);
 	return page;
-- 
2.52.0.457.g6b5491de43-goog


