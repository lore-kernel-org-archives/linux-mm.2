Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 294DCC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E3296B0098; Mon, 10 Aug 2026 08:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA8E6B0099; Mon, 10 Aug 2026 08:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7276B009B; Mon, 10 Aug 2026 08:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC4F6B0098
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:23:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71396C011B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:23:02 +0000 (UTC)
X-FDA: 85085274204.27.792AF77
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8B35B40008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:23:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KhvC5IC9;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786364580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HX3xWYPWMGyEZ3/iAdp9cHSDCjeSCNmVjV7Tq4qpRvQ=;
	b=1pb6EcjDxzkm+e2BDusYaw9XuVKf+TZiDpOP5BtK+64wSq/PP3sb3nV9dSERln8Gw1DFgB
	dVgtF6X0cIaLwgSgFOWF5Z+VPrPWkq3nZLND9kJqhREtwsCsPrOSMjjro7diA87iA6D9bh
	p3OtTn+TzHIqYtTs+NfoF/Rxf6h2Mv0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786364580;
	b=0NNGLMuXK7+b9/8xP/eTHTZBTPl1Bkh3KobrV1cJwu5HGR2BnUKCBIxuinY+U+azbv+yNz
	O8+1PTZr4Y/oezVQOpvYzw7+KpahN4mnJ7uqYmdXzj2c0lkFyagf/VF49ZTAHlZQLIFpAX
	af04wQyLjm6SMXqIkaF+wsetEXp8xNA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KhvC5IC9;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786364575; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=HX3xWYPWMGyEZ3/iAdp9cHSDCjeSCNmVjV7Tq4qpRvQ=;
 b=KhvC5IC9t3DsefOPecnt0xCQqz0rUpvTC1Et1etmBREtF0c0F5WYlKcsqv8goPEZRZFo+1
 3ritwWNvhnAnXErPOYNI7vIu50Kdz64QdF9gEJVz8+PTB71xkLNqAwLROiuMU11vvGHteb
 1hv1z3D5pitNHV4ZZjOSpLZhYCiuuFDqTWADwf93Z5EmVjH4OGGu/l7ZUA/Pw326D5vfqq
 ez9sGHl9HjUeV6mghyIMCS+WpKFV/EfL9ImBqhk1jFz7OWJ+N+cv29ce9u4FyW+JG4CtJZ
 aphPbf7dkchqGPbCa/aBEZpRWcLE6W10FVefzOPNaIYDDESo+zmnfWmR4wro8g==
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a79c29e+c4b789+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20260810122057.30447-1-lizhe.67@bytedance.com>
References: <20260810122057.30447-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v10 3/8] mm: add a set_page_section_from_pfn() helper
Date: Mon, 10 Aug 2026 20:20:52 +0800
Message-Id: <20260810122057.30447-4-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8B35B40008
X-Rspam-User: 
X-Stat-Signature: tn7p31izosznwjs1hncsz4zwob1763ii
X-HE-Tag: 1786364580-937381
X-HE-Meta: U2FsdGVkX1+AcpWB8mdhuFFsqdhbZs6AkOWolujzUmcuJYQnRlUo3qOzesEwr1XLxZrCKd3cJUPJ3iZbbU+JEle5Ub9ONn/mckYX0bO5xD58SAjHKOuq8M1Dxy22wlU/003skVb/UmH2rx7t3FUunuzcfHpofxrP2d/EXVefsKa7PpJTqNm8Trmi4FMAoaUm1J3dDXh0xn/JQ0jjyROy+InrM08bAe/ivAXo3U1Pzi6RpA34yIpWuRk/4iY3Sxu8915GbYgIbkQibdzCwaHfa4qLcnRKIMpEsy5nwlKQum3r4mBGc/8m64LkWhGjRIUpq/Y4QNbGU+mL6Xz8Vtdt2SrZD5j+X9NjG8j0vD6scpl1rQs0YYX59de74rfxsvE6BXnGZZ2tdJiD+u7jC3SUDTAknlTTDULYvDgY0KC4BKjXlPHCCOGVsRJS85++LnCImMYwU9/SnnS6V8G5kIuYke+3/iTTROphkahdYvfmi6M6tElpZZiVXvI8Ss8DLQUFi6F72w52qOvtxUfWwIRMol0Sq2GYtx+N4cIPF298ey9MtgWZKjPe2qQISCbqrAFsD9iEFM8oKgNtCXGv/KvSnEQKmai6LsrF9UFKh4p3QC1SuxKT8gVfGRtLBjjzpDi8e1rymDs/IpYa9BxEnbYMOOau31LLqggYfznvBJpilbntwp0Dp2EvGYVwbuq20UwE+6ZaXOOpr3t3fp94rW3RfspfMyEdija+E0YvycNX/3PLcfd8JZybSLZZ0tXe833YN8AK/4Iu3uhhR+En0zgN1A0NE9IfkTqneK9jaItUjLZgMDRPWZreir6snmusb8RT6f2mj9oJlxUxWL7ejrWNo1YfuojGeMLcKIAipdfjjTq6ODG6UMVJmzrOoFDI63ZKz4TIjdfUq6PJvEIGW2tyRPkBPrHeQxFCvuQETNx5or5L+H/cTd7qDt2msYKceG+AiW/lob4BfJyHWaoNXNi
 w/DUPMkG
 im/56aK0SGySZIArp0xDzEJGAoz90lqSIZCf6QmnM253dJ8QdqQtRDZi9z3niC2R6aegw4N+gSP8zuqXLMBaTrFSDSQecc+9Th2l5Gmv+M8TDEH5roQcJRLDUTEtIYZpXdgaoUJmQw811Mr74h97sGmDwKA0wduEaVZdBvYOW1S6++u3eqCa+cnf3mN92oPsbg68CAfBzZYxTRiPxNEWERWyMCq5dyrvmSzlouutRKkFW+ieeslFil/oDXmR7D++hCNU662pUYk686Mxk6cefEms+eIMGYKDZxJReZw4pbJB9poScJurPEgJ7FVWsDdPda//X4j2BCk0taAzJXntpgCJwSpGI6Ct1YSKqnFGktze7wF8cnYmyg7zVnB8TKolC/gGBKdLvGXZjKOq0x3GaMsJ8ECYbvt/skdCCTuXoHnkFpvvT6HYgzqaa29L74fcXyts9d8Z/eGBRsNApc/AX10BQVg==
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
index 485df9c2dbdd..43343bfce493 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2541,11 +2541,22 @@ static inline void set_page_section(struct page *page, unsigned long section)
 	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
+static inline void set_page_section_from_pfn(struct page *page,
+		unsigned long pfn)
+{
+	set_page_section(page, pfn_to_section_nr(pfn));
+}
+
 static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
 	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #else /* !SECTION_IN_PAGE_FLAGS */
+static inline void set_page_section_from_pfn(struct page *page,
+		unsigned long pfn)
+{
+}
+
 static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
 	return 0;
@@ -2768,9 +2779,7 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
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

