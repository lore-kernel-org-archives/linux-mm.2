Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D43CD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7496B0099; Wed,  3 Jun 2026 04:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF186B009B; Wed,  3 Jun 2026 04:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC8E6B009D; Wed,  3 Jun 2026 04:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FC856B0099
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:05:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7D7B120221
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:05:04 +0000 (UTC)
X-FDA: 84837865728.01.DA2D556
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf07.hostedemail.com (Postfix) with ESMTP id C6F9240009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:05:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fOClk2CL;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780473903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wk9MRIIObAkXzp6VZckmtUtqVfitvWEYaMcAPnuhTg0=;
	b=VwcYUeQtx79bSFMaN0GQv/HXlfTNVHsjGvjRaU2Qb8z/kx4NW6HyBWSCX7z3y/KlP23h9g
	6HlIaFg/CetQLDVYiyThP2y6nyD1C0apnEDcl2MmYg0q49eQGCwWEdKr1/Fz21oDEBC07p
	fc1KeopBfDPbgylzbgBNggW6nNMLOvY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fOClk2CL;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780473903;
	b=5KGAvdx8PfSfyxezC0bmJ10aIsrZqPOKfhEgYRE2qBAoblp3G3igc9VAR3jt9PXzYXu/gt
	baoqm5omz+HHS7VtM08bQBkJLOenGN8j3bqvbOxU9eyGeYWBaSScg9bp5iVogt1mzemAzJ
	Lg4a6SRvv1H8k/a0N55ttN5vgLsxzfE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780473894; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Wk9MRIIObAkXzp6VZckmtUtqVfitvWEYaMcAPnuhTg0=;
 b=fOClk2CL1fCwzT3+vuaOHqsI7g5da5AScnzI84M2/HrGKXqxQrH4IPvNIHKS3TxVjyxM2Z
 VwcAqVELhm1mJS5Jrmlx2v2SgVi7W8wZU3PkB+nodYQ/qhJ3BAm9UHoTvdckGxPm2D6L9x
 egKnpB+fJeGVp48JQRIr4kUNcyMq8Go7tDmCSgORlhH8367V2nOEoSgZ/KNVOZ/2HRg/qt
 VfryU/jR3qHqofObntNIVieU04cbqrnmdgbKUL2HiCGvfpjyQXpwmXEYdrQhYMBJMG8zx1
 rX+OEjJ7trpkY2JANC+C2RpU8o5q/J3iGZNIxu5udZ2lGtPjynn1E0LD1Bvmgg==
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed,  3 Jun 2026 16:01:47 +0800
Message-Id: <20260603080152.64728-4-lizhe.67@bytedance.com>
References: <20260603080152.64728-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v4 3/8] mm: add a set_page_section_from_pfn() helper
X-Lms-Return-Path: <lba+26a1fe024+34307d+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20260603080152.64728-1-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C6F9240009
X-Stat-Signature: wcdiqn7jeqhwpmhfymihgbgsp5j8tfso
X-Rspam-User: 
X-HE-Tag: 1780473900-145827
X-HE-Meta: U2FsdGVkX1+z7D2dngrNyWV2DqbGi7Z3AWmPKXxiP5df5ZVXvELi7pyvUDaw/o2s8zYOxjNoXp/m8R5u/gi5xNFHP0QnXsbYX6517ug5dvHODvLPvWUj7HcehAQRGmjnKKdFhakQ6I7hakHRM1ZQVfGQ8j9B70PWTuGHipmb56O8g4EVPCrPx6pAKNv1bD9x5d9YvlBFmq1pEvtCvc6bGVCN+wLHXZOX7VGQRjr7PnGlpmvwfb0cs9aNe1+5fYb40ovKm8xT70ITIBxZcInPs3c9cDN1qNq3UKT+9U+J7ig1Cp+DJziK2zDBm1rsGowHP7CzYBFBE4iiMugOA0DucXD4/KjwzJzDSvVrH2Hj3RnqwMglEtgmxkiJkVHzpu/ZaqptYYjwQxqAZFL9aVY9GhnQfctXFKFXjL+w9/sXcSWXPrS+lRWgol9AvnHo0XQlJJTHkkmWhqRNJls/ktfTuwC3ZsrbbQFKJU2726ZM5/rt2OAUr+swGMbSnYQcO4ZOR2ER1YBpJtCoi7dNa4T5hHJzoalbzB91CBzKR9IdSERx7tcdyIYx0g+CZ9mkgm9l/eNHtL8LVCcH7tk2B/CS0pEFFWUbgWYAuhWddD+eA+q34GGche/K9ncrR++ihIwDh796AKH9+X7QkZvAaAZ4rxQtn81xsb/rZpCyfluyXG+tsuhF8zq27t02eHkUxp2u2vRif9EnIYs+R6BkNOjgjdjCDI7nrTm1ogHtIsqv7UeEbm8iBCNGntJhVrea5F37cnd+wJ4KbD94izl9a4l6fWIc3wVHwmDxxjoxaUm5UIDPpegplIsYyphnSMVoNFVXF7CTPKYuWb9TBDVZTzUOVph7YZ4ZNGoAUb+0ul9GNAVyCA3/xMg7MV43hqA11f/YUrOT0RLsVlB2FXIdMM6bk4jz+Q07ti1dLje7G4CvhDOaOTBeiWxSifx7a5T2fddRwHiuKJLzJz5DHQvE5HW
 2B0gLAAz
 lOrpPJXm2Q8+eYxkj6kIF7tfTWjM6Fd3plh/XIo1++kQxDZMV7F8hZKMzniK85MHCEs4MAaXYWDr4EDYd8qjJiyUbjIBKXVAZ3Dzk6E32Jk/9VcWrs5IzDbeITN2ilFHN0Wpos0eCQLKbWwZ9A7Mcvwn3T1d0k0OG8VmchK2s4jqRQYaV21StTz/MHj8/PYat4rHWCbjLSHIpMZuFIk6FDZgdeJrBeqgJebOfQrNtD/Io2j93RwiVbQ/hsQPNv18zR1I2Xa+dlDYdA0PqpY1CLhgGMQ3PstfFL6XRKYBedvU3TfxVuZOZJKYtYBRu8Kyt2Pq5C1LU0BcFSTk4NoqzuQnCpNNVLq7XDOYqZEuywCz00cs=
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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 06bbe9eba636..1b0de1eef4c9 100644
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

