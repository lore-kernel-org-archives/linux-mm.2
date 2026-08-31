Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD27C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22E36B008A; Mon, 31 Aug 2026 07:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D3C56B0099; Mon, 31 Aug 2026 07:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911506B009B; Mon, 31 Aug 2026 07:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74A4D6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:18:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 038858045A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:18:28 +0000 (UTC)
X-FDA: 85161316338.29.6A95150
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf06.hostedemail.com (Postfix) with ESMTP id B21C218000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:18:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=e6bQxNRc;
	spf=pass (imf06.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788175107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3cbkuNFC4N1fAhS6eNTbPmQJtMCLdt2nXyAfh98ZQIw=;
	b=fNarxUovxMXAbKk6g4E+L9jD6qMhSKNPNsRuWiYGcVRMO99prDmZXWO3YHcJrhy0djAO3E
	njp/6WnVEgVCwukudK4ulX57BegQOUDTnYY7lPPLeLm5k3jH9/Hj545LR0Tu4H5t0rJtsg
	QHwL7hTKIrprpCIaV/g1jU3yc9AGXKE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788175107;
	b=wDKwH5G/JLjdxD1qtJROTOudo5cESWLcRNTalCpSD+dTAwlCRfXYUYOepR2wrBt5768t4u
	VKhffPaa8quFnQV8n9jinE9G7cxZdrhNOLRHv0Lfr3vu4WCT2Nw3hUXpSIuLJTT99AvPrk
	NLonlrsXJtpXVR8qksUaJIDAdf1sr4I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=e6bQxNRc;
	spf=pass (imf06.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788175102; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=3cbkuNFC4N1fAhS6eNTbPmQJtMCLdt2nXyAfh98ZQIw=;
 b=e6bQxNRcHzCKsZZJZ+/iFaBsoc07y6qbZ1fxiy0HYE+oyhe2Q6ljMgr4mSeX+/YG1k7O5G
 9hx+K2/O8omQJcavD9JIu5pYz7aw5PBDUlO4tHIW0AUbxOtzRlUlvOC+ZduCXnNYkUvqdW
 nEIVJ7BasMyQfyIkY/lHIXscK9SQSpblfXlL2WSJWaPLg2QOdPrKVvIQgBq6m9+WSIck4o
 bUZqaMvg9ulHpeP88X/K36TKY1C4Y4ZIO8UaBhaitMRH2PwtwW6/Frph7OTUNoUFBHY3Qo
 xfnI8gjg36j3IrPDlpjc4W8p44dzoJ9hKt2ioDVS6Oiuz9EPGm9/SqVjw+sRaA==
X-Lms-Return-Path: <lba+26a9562fc+9e84d3+kvack.org+lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260831111638.76012-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v11 2/7] mm: add a set_page_section_from_pfn() helper
Date: Mon, 31 Aug 2026 19:16:33 +0800
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260831111638.76012-3-lizhe.67@bytedance.com>
In-Reply-To: <20260831111638.76012-1-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B21C218000A
X-Stat-Signature: gedq6qzmgqi99tgozap3izq7mz4unhbe
X-HE-Tag: 1788175106-794657
X-HE-Meta: U2FsdGVkX19AAlmWkpIkOAJ7XwRm8y23wgatYLPNzmduMLZFeJNtgEXIE1QIr+LKN1AIAXyX892kdGX2KiZs9agFYzuazDe+wkdIEJ4Qd+VBjpUjYwMuzktoKHGBtVjVUkIg4+CkuId6VthaLeAaxI+SHl4O7VPEr2iH8mBTE/tlME6c9Q1dvSvXiiMP+/ItvJGcV4wAjd9e1338z9KMUt/+YOn/66XjGIEvd2BBryV04DyfTfzMNW1/9C5YyuyDet8lg3o+p8KUPR/VUYXjS8QQckiSgvOfHDizvn8ADVL/wPpHZ/ohehjkbTO5Gsa9wJD+CiH8bAmv20eo0FJN3dxLfdR1CMuut//9ap8LGV/TouY+IqVi/i8uq4cBbXdDxk+ZJkuGLqV9R5SbGcpA8y0+gmwfDpLvoqwZ7ZALBOf+jHmqTyYs9U4wtgwD6EgrEdtwKLjgh2ZFxMWLJCEWeRkckrVBYNhiDAv63r79HySTsrif4IyRAkpL+CHi2CRMti0Y/2cthFMUGFl0CXJF4Y3Bi8FbUPa3p5e06OHVrRszW7dK+gPk0N+SfUx0DhXJ62eSqvwxHlhn4D06zk+1vglp7+z+2EMwN/1X3Xw/u6DXlWtbvHCs5eM0wO+pAlzqDxL2U0BHoo3HvoIdcVnwNHseAA/eOUOci2pZrmoMq4T77XLtff+9UvO1w8CpZwcHdmFo6EGMkPOEVxckXnkTptms6uQaYvOa2cYAfspeYHUnKXHBYTRMUaM+bZzQngRB9EuT/+nfvxu+BX6h4Xt2MpFavSITjohmm5lcOndqIO+kaZvLWZgdtFyxhSRN3Joh76qx4w038OkoClWWPNG+qoU3nAwtAawsro7wuTv0i3Se0bluJgTOlBjKAh2jYtWNowGUCqne1aKmVCohc0Ptjh1/a5L5QMrHocbIOLa9KIfQANlIs3WSpGERccI6SNGC7ru+Hy3tuZ9mX9BKKJm
 4JWOdaHi
 W7ScckrX6FsOoedBQYrlkCA8ScTzGbvEhxDoIvXKCrEgvC/B29Nx1HMykm6D9MbKPcl7yNV1pMhQpUMeRegSHEx74/dcqZSVq3P/kxTWSwXrBgClw3N3ikIbuzLpXZstQe4J9oVxAq837OhSh/7Nv3hKUI9zx8NJ5LGnb2namGPtQbT73HUI9js2/vBXss4W1+gOhw5mYshkPramn4uThgOIz4lmR3ZuXa/pKJFQus6Ta+l1y0PdGsuM1LBYVaG6pcgrYRcEJhhd4U/JwaaNzgPvbSePdZPvwRuux6GqPgxw5we+duLOo0xWPNdyMIulGSCAy5CyNBIrD2MO0/fmDcETZvaCvdfUGlXif
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Callers that want to update section bits from a PFN currently need to
open-code:

	set_page_section(page, pfn_to_section_nr(pfn));

and guard that sequence with #ifdef SECTION_IN_PAGE_FLAGS.

Add set_page_section_from_pfn() to wrap that update in one place. When
section bits are stored in page flags, the helper derives the section
number from the PFN and updates the page flags. Otherwise keep it as a
no-op so callers can use one helper without open-coding
SECTION_IN_PAGE_FLAGS.

Convert set_page_links() to use the new helper so later ZONE_DEVICE
fast-path patches can also update section bits without open-coding
SECTION_IN_PAGE_FLAGS at each callsite.

This keeps the PFN-to-section translation local to the configurations
that actually store section bits in struct page flags, and avoids
exposing that detail to generic callers.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/mm.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..6640c7522822 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2644,12 +2644,23 @@ static inline void set_page_section(struct page *page, unsigned long section)
 	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
+static inline void set_page_section_from_pfn(struct page *page,
+		unsigned long pfn)
+{
+	set_page_section(page, pfn_to_section_nr(pfn));
+}
+
 static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 {
 	ASSERT_EXCLUSIVE_BITS(mdf->f, SECTIONS_MASK << SECTIONS_PGSHIFT);
 	return (mdf->f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #else /* !SECTION_IN_PAGE_FLAGS */
+static inline void set_page_section_from_pfn(struct page *page,
+		unsigned long pfn)
+{
+}
+
 static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 {
 	return 0;
@@ -2872,9 +2883,7 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
 {
 	set_page_zone(page, zone);
 	set_page_node(page, node);
-#ifdef SECTION_IN_PAGE_FLAGS
-	set_page_section(page, pfn_to_section_nr(pfn));
-#endif
+	set_page_section_from_pfn(page, pfn);
 }
 
 /**
-- 
2.20.1

