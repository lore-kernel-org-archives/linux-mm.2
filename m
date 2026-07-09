Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 794E0C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 765CA6B0092; Thu,  9 Jul 2026 07:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73DE46B0093; Thu,  9 Jul 2026 07:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 655D96B0095; Thu,  9 Jul 2026 07:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B29B6B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:27:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFE6C1C6794
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:27:00 +0000 (UTC)
X-FDA: 84969011400.24.741DD3A
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf17.hostedemail.com (Postfix) with ESMTP id DE61040007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:26:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=okSmaLq3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783596419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ys2Upgcdh8Sov7eMQd5S5YsjOZi6b1QwjfihqCLWpT4=;
	b=c8wF9HYnBF9mQOICkRJQt4lhmMcFdB4wOHkwqmoIjjkh9+YQAO9DngCHZmCiT3ahsjWFJq
	WJSOhuYnNlNvUbfoCe0GuXWQms0zGOPraJ/zFRUJ1gvFqPkZxuoQFfkDI9DjXPn8/bJrOx
	kWh2wT/R38f1aQVUfPirfPtQd3AfJDg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=okSmaLq3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783596419;
	b=aEXuhOeheL3wEP0LMweV4ae62afz7W6jxzBr+cDt01p4Bsx/VxKdGg+R3FaZQdbmhchywX
	B/yuzExM+NIoe5GJVsVVXeBg8YCrb/U/F8uAMymFOmNCdr1Cnq84BLUeu9OpAl6aueqR/Z
	z7WYTBnx5s1HENfLaV8DoD4Ki83Txgw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783596414; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Ys2Upgcdh8Sov7eMQd5S5YsjOZi6b1QwjfihqCLWpT4=;
 b=okSmaLq3Mu7uU7dUerUjWtavAzz+qd7UeIXUy25RBrQO+GlvmFLmQMJW0vXFFsDJAg3Uzf
 Rwa9BrNDI+gNJaSwZkk0N258IrBE5H2UR1m8ZVIfSY2LDPWPZTvae+feaApkOjT5c8COf6
 +sf9eNFFyZeffDHW7Ub09AeiFykw2rWPpEq7eAJ+tByk6CcKxBSSlz55K4Puelr3ghvJSa
 DyJCDwyhLnO+EfzSK/agKs3Pf4zC1NkS9Nr+3dgzj5EOdnExqHYnfmZ5vft+VwcrfHBXWy
 FpnLtO0ss2Hysn8dnyL8WzdXcJjbRQYybxogV8Yb2hth6KiC3GN3p63JHF32Jg==
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <x86@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu,  9 Jul 2026 19:25:15 +0800
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>
Subject: [PATCH v6 3/8] mm: add a set_page_section_from_pfn() helper
Message-Id: <20260709112520.24857-4-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a4f857c+c083a6+kvack.org+lizhe.67@bytedance.com>
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
In-Reply-To: <20260709112520.24857-1-lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: DE61040007
X-Stat-Signature: bfk7jdui5e9ez1eh79njo18tirnzs17w
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783596418-225596
X-HE-Meta: U2FsdGVkX1+tfP/PPiJJDx/+5OAeoEwjvNVU2eOuz3HqNEY4dSrsmmYSzDIOePNIQoAkJogYlAaIm8yKoflrW6UBiPsvPXb/zDNkpOmLNM9dp3m/tH+m6y4qyAdeE8WVkbjALO/MOkamAgVSc9O46Uoa16ocstmE+8Cl7wXd/Jh32Q3t4xamDw5qa3FSktAqpBVDRNtNxSdIq84JIu0vwkKKDyu0uO0vLW6Lj/GwL6otH4Ic5xYJitSPVGr6LiOG1sD9dhoZ0RUxpgY7DNr6Cx4dnQN9EP9g+SZdUU6IT9s1c7z2Z3TGnuYEjXWLhRL+v+6k1txuAUeClHCh+Si6cpFIpV9pflV2XKNZ51ciHHneriTrdojsuOS4AzIIr8Nj25VKJF69EILrlJlSWM/ZFNPbc058bJvZSM/c0BkgI1poBuOZVEW6ZKJey5/U0VMaz5SZZnISvzcKfT60oCP2obZjSbRVFXq9AlPNzVohVNrg5mdvYfYZWw3uDIQdoShfixb3AkSK81E1fkADmtOf6kg0q6HB/RsumvykeCjVJt18jX6KdNL/P0Iw7IbUtMzC6t1wxMXItjcOAJnqJrB6UpDX0h4/ZQGKSYEI7TbUNkHZO0CuKs0r+bQYHljkRs89C3TG4jYEead85S9H0ma5APeht2TqBBol4uzuO/GsVizJX++47sLQDrG2ll1eP2LkV8treICXUdeTKciX8k6uHOidoILZN9VAbMsLP6tj0nC++4QhPmADfeyJclxX5/ePqmQJdRNroli0NUCz1G/BOw+FIjuaam3z5bB/caAxiu9jgi/X5zOWCRz1vnUISgPdNSUluGnUnD7kvjDXoLSWgfra7QJAyj/GB81nFQ8MSR1klOofVdfAdHBQ7gREb27sZHNrtSwaWxUxPrhgyw3ZfiQ0GKZ2k+zXLHuZz0HeSI03F6BvXiw2/MfCdEI/0bV1pvmnjreO0y7mU4hmMP0
 mFjKpwf0
 pT08+GPC4A6d6ZUzAM6+qBQHeZbe6WiXU1S48C2cjxhzl65M3lT3f4UMUhp6PR7VEt+y45BYylZlzDc4gzSmgWtob7jsqo8aRJPYgUaYCKqh7y1UyJTnFHTPDi7N4Gdish0rLtKW93eqMfqFZ6Q1DwV9kz/LpddSlrMWpPYe4CZZjz4hvne3dcH4vyde2zArzFOueYrEXpQIpXTLtWebE8uBVtJRGzadG41IwnsGJv92KQAwjQ2Zi9X+U0RwLiSugwJWFSM4+GxCU1ofMZqibXonImSpnjmSReed54DuWmaknMAEWL0eD7uxCqJqJ0eed/Mw+AS4JVz3GW20=
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

