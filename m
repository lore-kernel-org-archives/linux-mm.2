Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D26D7D6D22E
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0976B008C; Thu, 18 Dec 2025 10:10:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81FB06B0092; Thu, 18 Dec 2025 10:10:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8826B0093; Thu, 18 Dec 2025 10:10:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0466B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:10:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A4B21401C6
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:00 +0000 (UTC)
X-FDA: 84232926960.27.ABF0CA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4926C4000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:09:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QQSva+qX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070598; a=rsa-sha256;
	cv=none;
	b=GrlqRSWBmgUHlpBewWH0ME8Hyjm9Cvq7Id+qHBAy/SxoxQMb/BQ5zznoIemuhz5nZaYukJ
	fZIL4sdaK/wSjSMeCMvDYuJwnpg+88dYrQ8n7GwitXh5Q/Fs7eoP3x60HE0Wye6pNeY0OB
	3zcTipXDnBzwXdPpbv4Wubg5ofaGSHQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QQSva+qX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3Raub+Hmg3EEPcrnLT7qlSyy4FytM/obVjAHlbQn+Y=;
	b=EgDxoUhw9D46oOnnbSOUdnzC6F0MkhmuP5jYFqFz7V1giCkWcU/34sCC+YA9/9TY3gNwIh
	meRzzhwIXITHoS4cKvz5OzRliprgPnJA6XopN3mZL7lOOX1RnlbR/g/rSa0+CJe3cZsBig
	iNXjhfvchn2IUQbgmL2iPxGzcVBg0zM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB1CE6012A;
	Thu, 18 Dec 2025 15:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F182AC116D0;
	Thu, 18 Dec 2025 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766070597;
	bh=9tLpQ9D7laIhJe2k13i2JMUzd18FwyrCUsedyAAXldw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQSva+qXAV/iy5U1+Gb1iCUvWGDgAUWoCxTdIxlEzvm3gjMlXKlFAmGWvuvRb1nAn
	 G++siGXaPMw2oW3hDZ6e3lmPQfgw82PUxPEtLgG/Sf9rMlLfmIO2t5lKlBhtfEbPri
	 gRdwMG1mnHkWRmHNlrLbSEAWdEbIcYB2SuyhsleYH4A0Mu6MBgkF5qrRMGcNrsD+95
	 iwoIh5vUXWvCjlKQOjwG7HF4RHD9vgt9bBxyKr0PRxwMFCOFFCx9ScYtTU970nSIH0
	 gc2FkgrlSYakJRiRAtSmwJNr0LQiaJuyCOOVIf0lm9l5aLOLX+/Y1LbzmG/v5xZ7Ij
	 xZXApF1PZjbzA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4AEC9F40072;
	Thu, 18 Dec 2025 10:09:56 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 18 Dec 2025 10:09:56 -0500
X-ME-Sender: <xms:RBlEaR2fhvEo3I9H223A72c6QsadcD4W7NTs-DWLoZ2GIiX0IS_J5Q>
    <xme:RBlEaXUFuML-YtoKCtgPb_v_qpZoAEklCVMMLXU11m9Psq8aVzztt2CkknpUJUBFT
    R7LdTn8byNjQJsVYBtF_x4RObdLjo05rDA-Oe6MavTdvloco9LGNg>
X-ME-Received: <xmr:RBlEaUtlfNUdPkONed9hQfRlWsncL2uJc28fJUvNEA4HznICdEcGmEbDEefAZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegheejhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhudefjeehhfektdeuvdefveejffdvhfevtddugfduffejfeeikeelhedvtedvveen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    hmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgt
    phhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrug
    horhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:RBlEaWVa7pBUSoyh5o9OpVxLvmRGihXg4NkKFWXPF89VPvA_4O8dgg>
    <xmx:RBlEaYWDG_mf7dg3FyvkwvsuduL1uWK99-R01OILjMXZhE-vfM0kvQ>
    <xmx:RBlEaYfMfznDdC95GykU4faxoeMRXO47A96pX_L0hdHAqVQTyt6MVg>
    <xmx:RBlEaX5Gs_RBbVT_gsY8ikb1t26jitSlNbV2JM8p7aFa71YUjGoGuw>
    <xmx:RBlEabQhRdV8GFZstDQfSbfpFuwG7ZmiWxUtbFjrhnEuxW2ppVacABTz>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 10:09:55 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 02/14] mm/sparse: Check memmap alignment
Date: Thu, 18 Dec 2025 15:09:33 +0000
Message-ID: <20251218150949.721480-3-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218150949.721480-1-kas@kernel.org>
References: <20251218150949.721480-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4926C4000A
X-Stat-Signature: sxxjsc4a5y6bjnsbstzpng7ghu4hdex5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766070598-579248
X-HE-Meta: U2FsdGVkX1+2ka5OPXq5b7EDzi1qik4C6QFIkQuVgjRxQ/Ty+Ckho89ZCo0cVuybhGJY6QaQttORmFjEVuZt7uaLhE7YH1KvAIJDM57O1nmvt6WaEJQlUnyJQQZR9NN2DlbtrvKRi6vUPD9lc9CAZPApQFCVlO+8FOFxLo0GdRTTGMRcHgnXHq0ZyXyQm9Rkcd7EYgioDFdhPMkQswTerXm20QTVXJ+j2eqIlWlm5Ixyv3Z4MWH9xdCbo7Z3IXy36QrDOeC0PLg+uZaYxTqn9hVqJoyymPZd+1GE1tdU6YqX9hjRItk01v2+2fq1msRf3zaKGAey1SmqaFCdSpLQqCIbZlgzRK3U/ZTyvgnQN14KSYqbxYbCTz5+JLoalR+9fVqnPKsfD/uxMu7+JSbXeOBHPH+bFbYtae9xwSb7OtJ68j6rYc/D0XnjNlYQPQkFUia20mhGmrFC806ASiSUH5W10B7HMielN4QrNk5AFOZeIBcFu3NWgJ7eIr8GdqzwCTyiY8enkMaFkLWKUaqEQf3ZtYIhhXpt0KNu9JDp6wwTAdOpwI0BwhmS9PF8t11JXU92nu6w7ClkGCCWFpOb4qMu9agFjwbhIlCnS/h4/ZfrQ8zJr6nKRwK9ettV/53Ehg/ClRt9f8RjLIuOw5pDZGF+AWNtTrq2VoPF4KO4DddtmBCptKPDUoOh0Y7c+Fr54ioknuN5IcWBZ1w2s5eUEKBAa/rrfEs4qj+Q4BXYrd+eBZXxIwoFusg3BcjSonxER5+F52HfK30zl37fzBfK8D7tUX0Pi3DT7LC0WACimbt6+ZT5j2OV79iy7U/pVrP9Cs1Ypv0Ta3ewQEo3SB2xKfl9jTjsNVbv/7kBdDK21nQuR7WoL8Hgtf/vq5KhRgydmj2EMyX2ARxmiueoOZvnW1QbC/dmw9D0JcE+hZ3B4DT5tKLKapwxnmpbWXv2Nv8B18V7qwPBjvjO1TBwQid
 S8x978P2
 CeUyIxmpxGr+WLxHTRy379ayCBXhozZraXrQRBYISGOLE3DkCXMHJSISkHKs8IQPJ8M++KUb4rIYL+gVI99PWAUrO2vc8CQBa7HSJSlFV4IlCou4tntXUdxTcR8KSURmlcjvZqPaP2azE3ZGhK0U8mIeHSjh3Oxhjqmd5f6fD/kw71d6SGxLnLldAyv2gTGF9WsT5cda4Xm8wnLlM+90ddMGwQxvI8eFJJVywCNasJDwBR42mWxU/jY3BWIXAHCjPLAdxN0oRGIgXPm79cP07avlCTD32Y5fxdcTn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The upcoming changes in compound_head() require memmap to be naturally
aligned to the maximum folio size.

Add a warning if it is not.

A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
kernel is still likely to be functional if this strict check fails.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/mmzone.h | 1 +
 mm/sparse.c            | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6cfede39570a..9f44dc760cdc 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -91,6 +91,7 @@
 #endif
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
+#define MAX_FOLIO_SIZE		(PAGE_SIZE << MAX_FOLIO_ORDER)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
diff --git a/mm/sparse.c b/mm/sparse.c
index 17c50a6415c2..c5810ff7c6f7 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -600,6 +600,9 @@ void __init sparse_init(void)
 	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
+	WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
+			    MAX_FOLIO_SIZE / sizeof(struct page)));
+
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
-- 
2.51.2


