Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 631E0CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B3C6B00AE; Thu, 21 May 2026 00:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1AAE6B00B0; Thu, 21 May 2026 00:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32406B00B1; Thu, 21 May 2026 00:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E95F6B00AE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:03:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B2FA1C148F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:03:30 +0000 (UTC)
X-FDA: 84790082580.09.9F30F35
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf20.hostedemail.com (Postfix) with ESMTP id 93E5F1C0009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:03:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=QgheDEo5;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779336208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vp1wEakIyL2i5/j5G04i6m4y/xFgX3dqvqhZlULkuAQ=;
	b=UjDUKVQfRCCiNIhYaSk4d//Z0ktJA/7YexDvigz0kuVwltJLUm+EezaEgqaitJjJHFNKpn
	+FhCfl7J6UQpivfZHoG+b13RPx9RzhjbXE2DL02tG2XhjpZfjXaF+dUWPr8WaLrOwhDRbA
	ei4wW+Y5dvOZMKBck85JK2qReqAyWzQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=QgheDEo5;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779336208; a=rsa-sha256;
	cv=none;
	b=Qf29wsXdaoP0ik+pYLoCEPjDXC8rOCQzQyhlY91CzuspNXsU3CkX7+tdJfyhUVwbXvmcSa
	9cZ1WB4cwq9crKzrxBQIdGfshWdq2HN3ozD+IqxbU4nmm/mZr15VptrlU3g0bvMJyBxVNt
	zjWC68WE1F4T4c7t9rNrb5Sf3GNrUWM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779336203; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Vp1wEakIyL2i5/j5G04i6m4y/xFgX3dqvqhZlULkuAQ=;
 b=QgheDEo5ToVzm/8TqFx7/h8iE0Gbm7QBfH+BFf9w9Fjr0o1MpD+Fi6VlIu2KIWugZ4iJ09
 rDYsYsVck3IwSZj/+Vxt6MlELouX9Dp0IPw8G7h9PZ7TPyYbPKmAdWWq/PHvvBTUcjv7qk
 MwV53R1J904aCEbu8dM8wkKQO02a0DCxBbjFsKX1qtZxbPH8aB0k/ilUgy+D7nW53md4LL
 r3GYT0sAIXUkgV0UqV3SjaBHPO5t66MTXcRFW5U+wEEpvNdgFFFTHbsy2eqPG3wJyQCmWk
 SB6UZVQcjiOYnWkH2Wt5edZUqJkrHRd3R4J4AQIqZcPz0apVN/kzQuieeYcA7w==
References: <20260521040124.10608-1-lizhe.67@bytedance.com>
To: <apopple@nvidia.com>, <akpm@linux-foundation.org>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<mingo@redhat.com>, <rppt@kernel.org>, <tglx@kernel.org>, 
	<kees@kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a0e8409+44f7c7+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20260521040124.10608-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Date: Thu, 21 May 2026 12:01:19 +0800
Message-Id: <20260521040124.10608-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <x86@kernel.org>, 
	<linux-hardening@vger.kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v2 2/7] mm: add a set_page_section_from_pfn() helper
X-Rspamd-Queue-Id: 93E5F1C0009
X-Stat-Signature: jg95io9rh4dg5x7dpxb91wj15bfah55n
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779336208-828329
X-HE-Meta: U2FsdGVkX1+/ZOYSOY2m9HbAtfYH70x28Wkkd1cywR7JopjJT3ciwgBDVNWHL8KXoRwLiUwUsefhrsd+vB7xTBh9XBi5mZsS0s5kY4gV2hFyKrpE/R7HqHJIuo5Ojgjt5xnm2YIBbShVI2DpdPR5wiKv/pHKRI54bMkCUI51zkzvCfjDA8radHtMhCRzj4WprQBPoUj/E2D40MsnfdIE+BZEpmURYghffDM+XS07ayA4kdtvMojZc3bZg1SPL7BFoE+mZigZ52zc9Jl2gXgFR8joE29OopypmZYrApPPi8+1p57PiBy3t8r3rmhSOB/pWCIxUJAYqSOeZZ5ZYqm7QxpEhvo5LTQh+H9fmwHXky7NTj2PPhl8cjTFQj97DInLeTl7IshG1stEqYLGeAOmsrNBBxR4vXmkkqV7mrL6NbPTYzeEa14ypdo1OY7dRuzjecmJzKURYjgUoSHrBhjPpMgTHm2nljkiEGa+FU1bZmq+F77FopCGgXwV0c/OFDHIwcikfWXq+XxPJYi1lODIn+2BgPFLQWUSOrB/GHiKwQJBRfeScKfqxWkZCasihefcUIFc7viGixdkN1lV/+NP60ffgXGt5RKY8fr7+zYrEP60AyB2yOwiu9afcBKvaqQKzZezYQSaTwXAULzmFO6AJdrfIsfyXDrGB1Y7CgOlf35iDUz26imGiKuhe0hV2RP+41bshHqriRTv9EyHEGeYIcixDgoOX0vKsO50pfGkDUmFzyycBXY5vb643BOrHZpL8vK4/CzHvxQRWyT08SqBOyp2HFpMMX+z7wuXSyzNaHO4vUe8zAwD+gHfijWyexC8Wzac+GRdDS69oZlACGnYcTE/0C2g6Uezcglfd1JqeHMUQEugLvBxQ8Q8ltO+JTzN1bnrBgwnc7A081zkMCiwsH0givSvAjZjPp0OxddLaQ9WjXh6jxT8Dp1wvhCJF59mFwmlwN+U5Ho18BiLO00
 D1eUiVbd
 Aa2g/wXc+Ew0Zgr+j9B7aQ/V3WR5UKfONU02bDkcmcGRgE9NjQjiiMDTYQfbyOPKxRpUZ8w36fI3n1+Fg/udlld45XQi0NoNr0nGy12vRiwweETGZv7mHAwVGgECAg+74bvNYeaFT3uGii//4K3x10R+KcVyctRs+8FD69KWnLla1pvOPbKb6AMB2s3SpYOEvxRsSKa2NDP7LctPEum12P0Wu+DJ6k0v0r1ZvxdOfGKruJVjqn3XVLAGWt7i2w6rQdcRPJRBh79sOOGQHViPbmUef6f4DQ736PUED+4Bzyoex7NWklCjgAVF830Mq7wdn4zY46b6Rss8NoO/dgS5BO6BrPg==
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
number from the PFN and updates the page flags. Otherwise it degrades to
a no-op.

Convert set_page_links() to use the new helper so later ZONE_DEVICE
fast-path patches can also update section bits without open-coding
SECTION_IN_PAGE_FLAGS at each callsite.

This keeps the PFN-to-section translation local to the configurations
that actually store section bits in struct page flags, and avoids
exposing that detail to generic callers.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 include/linux/mm.h | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index af23453e9dbd..bf84e698385c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2507,11 +2507,26 @@ static inline void set_page_section(struct page *page, unsigned long section)
 	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
+static inline void set_page_section_from_pfn(struct page *page,
+					     unsigned long pfn)
+{
+	set_page_section(page, pfn_to_section_nr(pfn));
+}
+
 static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
 	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #else /* !SECTION_IN_PAGE_FLAGS */
+static inline void set_page_section(struct page *page, unsigned long section)
+{
+}
+
+static inline void set_page_section_from_pfn(struct page *page,
+					     unsigned long pfn)
+{
+}
+
 static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
 	return 0;
@@ -2734,9 +2749,7 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
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

