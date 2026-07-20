Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0A62C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A126C6B00AC; Mon, 20 Jul 2026 08:05:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C30A6B00AD; Mon, 20 Jul 2026 08:05:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1676B00AE; Mon, 20 Jul 2026 08:05:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F9316B00AC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:05:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB30FC016E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:05:16 +0000 (UTC)
X-FDA: 85009024632.22.1C5B05A
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf04.hostedemail.com (Postfix) with ESMTP id 13E5A4000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:05:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=WbucRlui;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784549115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HX3xWYPWMGyEZ3/iAdp9cHSDCjeSCNmVjV7Tq4qpRvQ=;
	b=i3o3KJ9TNK8caaPf3C2Ftwnye7G9UUx3cEcZMy1wm+m3AqMYcp3rtmF2GFhRU1PsWcVabV
	JfDfkXbvohrogVAlSwoQd+pUP56C0gMoFe994wCf9riEaNIcV/9JRHNQ0BeBRcUMlFA8nd
	2ZFuLrT6cAzc42TC8d4DYp1ThH6dzv4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=WbucRlui;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784549115;
	b=zNS7yxdpTYC86Sg9Wc8RV2JeSF9v5YdgX/ra+NBFv1BxhDdF75d/xXJUzsEpX8K0A+hvMN
	+c+EzIJGo69/Iofs6+k8iCQe+6pOl1DCLwT6Y8A1HdZtno90kYQBqVitVHrviJhzCa1neB
	MmaB0biQ6C9tbWEscvG1sSlHEF8r+1g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784549110; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=HX3xWYPWMGyEZ3/iAdp9cHSDCjeSCNmVjV7Tq4qpRvQ=;
 b=WbucRlui/MyrjjrMbSp6s1Vv/PSyx+GSABeLjgyHjAdxnak8LtYcugyrj5rug01r/izl0j
 70M7+h9A38dFsJKY6z0YRt/K6aXSn8FNXUMUjRFL5pfDOAbufuOtF0A5zev1LPPXJy/cqP
 r9tXmL9IarjQhv34dl5zCq4brT+OyteIv3a7FKaoozd2VpQetcDDLyrg2VgJDfRXs36w4u
 3fVJeESMVCJ6KqymByHlJm/gQoNdrUr3ckKHrHy0jDSLeVVnupad7vYpKE6YhHkwQvk5Rh
 3Z9afiGHbNq8PWGP2/IPV3g1lKijrYdWHTKr/RHJGTCduheUxx/hAPOkob9Ayw==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a5e0ef4+21e3a3+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v7 3/9] mm: add a set_page_section_from_pfn() helper
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Date: Mon, 20 Jul 2026 20:02:53 +0800
Message-Id: <20260720120259.1545-5-lizhe.67@bytedance.com>
References: <20260720120259.1545-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <muchun.song@linux.dev>
In-Reply-To: <20260720120259.1545-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 13E5A4000C
X-Stat-Signature: 45w7no6ignn1fknza75dnr3koox95dfn
X-HE-Tag: 1784549114-320781
X-HE-Meta: U2FsdGVkX1+CwkbKLJNpqSvXDvfS/hAbxuXRFq2rRDqkfCYVB1GIEOcOmqrNlP1sLgrgAia8Sox8f241K1jv659F4Zg6ru/ixYepJK317Fo1bK2oHbfSh170H078botiV4UOZU8qoL8DdVT23rPOosQQig/BRrDZKSbksKdkVcJjjrRkIA27d2GgJQWjsjyazBIylaSdO5MuSEZzXCrIXICzNbCGqda8Fqjz3Xe4LyjqsZqLyIO2dikHkVTT9xGPdey8cFQCu8fVK2jMh0lUOdunD+7vJEywv9e+mifXXJAYY5/VIcFx8bhz4D3FaqIS1wAM7aQM65nAx+165Yh9z1rnrOzQZra2fvLcf11hmymGnLOd7ryohUdM88ZjtHl0uz9OXLVwHOUX+a500vbislmcUdLSmFDs07/LkVtuWPTjmT8Lb5ne2snr0PxfrXvonRzkJBv72A/NzOougiSq+/bKVP5ax0lcSXEAq5kDT0Q66mvcyhoPP7aneM845giYKb1POSZPgrATvmJRMIZizNk16Bu7MXVIMqAP3SGMMeHWii2j+kQ3Jw9mWaIapkERh3p/SSB34fFRWeTLNjUbjqLUJOME6o+vcT5Qx6h6u0dI8AZ/gqKfLodm3XbKfMV1a3F0OZUF0feqpFSvSOnCVTGZfU+9fCXXxYgm1bd1SVVK/tnz4lyDxfRXV2ehJcg+ltDyDVGflUgxJGsQKEVvNMbLdgnGSVpwsNoWqoplRC1WcOCnj8D0927UXjHNPWAEjgYzuG+U+bo1BW23S+rTmUKFDvdX52ONsoTdsIMvK4ANM1580VlANP45YXHBzwSlpFTG3XWymaJX3tQl+AI3VhZlR1Gl1IRj+nfRYu9d6mbhFlwkbtO4oo2qwZYGkmy1J8BGPBH1s1lJMIL7NuDbvMQ5DqOkwNnrQ2KxzzUaocmAstG4JWaRtrSXVDL/S5TB2kfmA8fL2+Y0VafIxBn
 0HrTn1YQ
 E7h4OpSQkW/mUHv6/IuwS+ksnBtDEoMDldXDFBk17hDYVoqu9SBv0M+YpROUPE/8hNkSsN+bVIraLFatdrzsgqMh1r65+EaRZ/gc68vQc4WrnjMZnJsgrgmig7SBtOdJXFlaJcMVzJeIhsPW3MIbABbM6s75Sh7fjrDsyc5cGeeN4jgJ35z0UYGEKYfsDSteIJffkfT+sdTOMegjZq4W7M3auPfcqJsNzsIAJqbe40IAx/FLJD1+lNVpmNCR4FleUrqPnNFRcTE0y7Gx3SWkVKW10548HBZwErcctavt1U3H9NmNAjIIrLi07kDlwfphKWJ8e6KLBUOI59kWnDRwEyeqKRcA8vT3FRO+U
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

