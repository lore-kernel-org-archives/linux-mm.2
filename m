Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12FA2C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39E26B00A6; Wed,  1 Jul 2026 05:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9D36B00A9; Wed,  1 Jul 2026 05:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27DF6B00AC; Wed,  1 Jul 2026 05:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C32386B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:08:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 563DCA029F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:08:04 +0000 (UTC)
X-FDA: 84939630888.16.58FCE3D
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7512F140010
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:08:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=e8ra4vnc;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896882;
	b=GJVulpSf6zACTwxt1RVW6LKwlJw/mqIL1k04Pg/KPVCuJO5H9OYSeawb080NSxS7dClfno
	E3npRP+MtQXVH/WjPAGVoLT4crJUHr78yF/63bnDBa2oq0zou0kjm/yXrOkooD4nQxMvOg
	HhJwqpS7F6c+5c4099CV8lGAb7UyESQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhHRPns26kjobDeVTfdIaOXkLcuTqZreUPTw3762+fo=;
	b=NXj6D/VjgSuI1FlUCBjXJPu6EXOS8RwYBru+kxtPgnGdtATytvF6EtxQTw5Nnjn7LE4HoX
	jeNERd2uOabHShqnewwE8y6H/t0+2e2EGKqvgpmdEenqtY7SHvIctLKdvF8AmtOe+t4PT4
	mm0uRmIAgE+SVL3cO0JBrloyZyoLsYI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=e8ra4vnc;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782896876; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=yhHRPns26kjobDeVTfdIaOXkLcuTqZreUPTw3762+fo=;
 b=e8ra4vncVN2meEBGW9TJ+NnnnlAEBXIb/VP5DcHQQ/QKVfpkCHdcNT9OChqzhxWttFQZQc
 oRD02mEVjcOGt2GbJCfXmzqQDJGxhhO66ArICAJ6QAeKWEk8gjgx+KiaksBM7nlZCXSilx
 91rtd7crFYPuLr3VoNV0QcCjrWTmUbMHtUZYaZhbUDHVYwvZ/Rl3/dKayD6pPaTsWU8NL5
 +a40SE4gTTQVMXGAJ2rebTbfSDgrT/rj1Vr1I7VfMve4geWaYGD4vWrK54AXZlsXXIu3lf
 tPOxCcFh3iZqBs7OS3NEPnE5bZbi/uE0DS0fBMK1bNlKtn42YUWUZlN/NhwTqg==
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
Date: Wed,  1 Jul 2026 17:05:48 +0800
Message-Id: <20260701090553.62691-4-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a44d8ea+839a35+kvack.org+lizhe.67@bytedance.com>
Subject: [PATCH v5 3/8] mm: add a set_page_section_from_pfn() helper
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20260701090553.62691-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Stat-Signature: cnahhp99xus3qtqedhb9cte1gf8hkjac
X-Rspamd-Queue-Id: 7512F140010
X-Rspamd-Server: rspam06
X-HE-Tag: 1782896882-189491
X-HE-Meta: U2FsdGVkX1+koBTPDbQFpETwL1pCjOv1bE6kLnkZ80r6zuXeqmE1da3tPx5U3ERHC4I3k5JSni/ajq/bo7PjfsdcwGz9LtglrVWA1RZpEtmpn0AO22EbDywpKf5mmLmnaFugHuOeCSw5B4p13mMFmQ0mW0iQVg85nKCD6qiR4IMR9QBgpVLvclDdXfsernOpVzQIG4HtnHEvRHsZOnobr4fwG9pCu3QC75FHDALlaKvr73YL21B1pOG/fo7xPwJ7pBbXImSjMd3GmX8DSpfqrCI5j0R3Duv9hiMWncBzbOJEPit7cK6q0dUUXi3U5GhA1xzTW73/ku6Hc2LXDpugsdJMQQ5BAfhLNi9/7avAXji3dxiwxxEatlBBafJDnG31H3AP3yVaZlY6o6GVf5ns2kUuMffap/Qm9Fck39ap2G9gLyih+JVfRFcTDLsZB5ir3bHayOc1PDT/1FHC1XvVEtIl9aDL2u5cw65F3bntSI8s618myYAaJ1Oz0maozJBZsHPoJ4+t3gRExrvunh8QDotm4IKOD7IIn8lW3Qs0k0HicGotLx/Ty5AVQZbgFe9Pa5NP3ldKqKWuZjKXBYgC70n9J0QKNIwhGsgsmEYvO0kqPDZTTjCeU9xPFTYjvrQ6kV0mj428508aj12+Iek04HqLfmT8KtuI1ZpTe3WmnIQ0giR7DALM416UhDrfDikq9hnJ86a9GkGhkH7it8uivBGrxqptAG7B3U3eoU6d6nVJB6sr7z9hyr6CC1vybhXrukonMD1VIlueF05oWq8VEbIYd0ra95ytPJDjhwWxZRNVU2bilPRMBSuMtQFaKK/e0JRu7F5Sb6iJuFpYc9iWe47bWmLv3L+69mqe5olEuIzyaJoQLSienDlH7h800hKwsFCiT4AoBKhBcFXX99CO3WzOev6bv3xK7xiKPIHP5uRhKQGoZ4q/iRNHk0usK0br3zqi1IOyxAgKRyt44JN
 uppd2wBS
 o55waRk6z6WNCmBAtbV3uRxU0CafV4Gx+OuaH8p8sE9Kb/VbXXApYyEN4c/x6ztUXZyyRg277RaYup75CeGXXTsUpJcET5mUpdxyyiQX8+M6xjnrvSqk2rlbHCHdhD/uonsZ2vD58qrFF2xv6WyPjNKZq15nLWBYMV48N2VVOFCo/4n/qbfgEN2CXRG2o6cB3JUKuR0Iy3hzCffo4wYnslFoaImV/FCu/yFmBWKPV0/wBLEYIy2mFm5iJ7ce9lHz4j71o/XEPbAS9DuDqfJ2qy+4vtFf6Qgxywf92J17sA8KGvY4YHI8dQiwZF2/XqulQdFRfxdunSeSUcFM=
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
index 485df9c2dbdd..f78afa63dd3d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2541,11 +2541,26 @@ static inline void set_page_section(struct page *page, unsigned long section)
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
@@ -2768,9 +2783,7 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
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

