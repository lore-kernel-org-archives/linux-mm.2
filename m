Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F6BD46951
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6772F6B008A; Wed, 21 Jan 2026 11:23:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BEB86B008C; Wed, 21 Jan 2026 11:23:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43CE76B0092; Wed, 21 Jan 2026 11:23:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 307406B008A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:23:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DBA70D34A7
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:02 +0000 (UTC)
X-FDA: 84356490204.15.5DE4D2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B5EB9140013
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JK4NqiUZ;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Fr2b8/5e+JkS78q+WvL6mRKaYEPdAHtIViflwhwKT4=;
	b=L924qB4rJyVwSwWnq3iXBnwnHAGyi8GhAtJ4McE7y7OTvEBYZTV1nmGu9rypKJN7QrplZM
	wrh50tHkHVxEwnr9ueAOGsj00Dg2AKJu1hvxhazjBKWmk4tKQ0TqZltAQkmFKbZy+Qbsad
	TKGeaZxjxtv89437w1+92lAf3Fshsx0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JK4NqiUZ;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769012580; a=rsa-sha256;
	cv=none;
	b=zkIW37l/F5rezJigLvHWaEabPk0oGrQdVXQ9cN8w4PT6hawFm97L6g5auQE7qWv+jLqWTw
	7oTtERmou2VejUpI5OgWgQkK19dmNkGDDmfxetIkqDbJwOpm+Y4xcj92V11dGXy18xfV+z
	rBIq1mhJxiMGtHUFUgxxMb48aSmdbUE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8547443F2;
	Wed, 21 Jan 2026 16:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE11C4AF0B;
	Wed, 21 Jan 2026 16:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012579;
	bh=94U4vpoj3XC1XsIsIF8ogVhKHsiDO0aWlPB13fldaPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JK4NqiUZ+MIPgVTwafVFr03CziRVivVoT4DgfgkO8x7AoJcHHMIJvkhrCDVBS4Gj4
	 TkUFa3gsbX0kDTms3flfsV6Kl3hGj8NqtEVwfWHBa5ACoPBbRwZksgX0YznjDdeBB3
	 ZOjZ78dXo5yIh26UdiJCLQLtxEuPGOwBoS9HnYsHJ9DprsGPXr8twMNZKoV4P85aO5
	 yKf4lonpDK0v2wpV7SlhiVtR9+1y8Nq2VlYhNiqvEtBUTL+UUnHfO7N//2kX3jGVqa
	 7ed543VPAax64WQy2m6uhE05KoLKXNfKIqrq8ydLFf45zQZAU1ptO8N2S7chfmMWX+
	 r7bvWtJ/OcR6Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5DCECF4006D;
	Wed, 21 Jan 2026 11:22:58 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 21 Jan 2026 11:22:58 -0500
X-ME-Sender: <xms:Yv1waVqtPPVfV3hDkNLEGqIx3ef9zYss_8Biei4bGLY7CK-6KoV22w>
    <xme:Yv1waW7jQu4uvc6hSNsKEDKIKYGQzb7meOnSXIQNmaIe8PpicDfCIt9XPVw_S7fjl
    2PmleuvicrkaSGBMCThi8edPXvDx57X-3j-bZAHGeuq5zmkHVLTSXg>
X-ME-Received: <xmr:Yv1waVCelrJ12Q_UvMOdhJwf_4ck6rtOQUtblwnqHoNoMgHy5-U02PYBK2b9hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeefjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:Yv1waYYf7ypftXewdAjMM6uQdv6TTijhxZFan-Z7DWF6ML3c8z2ZYg>
    <xmx:Yv1waZIY95RoJrmuwlproUIyq3XDIjrXSFVhp4GICYkVcPZfCYwwbQ>
    <xmx:Yv1waRDx44szWG5JVIbhvWH8j1so-lacDnSntax79R2WfAadLgp2_A>
    <xmx:Yv1wadPqdX5X7vvE4a_14QI0tRZh4ieZMqaEOlWHMfEIdYe1pXg0dg>
    <xmx:Yv1waeV3JZFBvcrTQhbCeMvdYKnL9Cmf0rsBQoFUZg4slqFiKAl01xcP>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 11:22:57 -0500 (EST)
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
Subject: [PATCHv4 01/14] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
Date: Wed, 21 Jan 2026 16:22:38 +0000
Message-ID: <20260121162253.2216580-2-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B5EB9140013
X-Stat-Signature: qab7idxz7gi4tb6dfm7coe7dymt5ip9n
X-Rspam-User: 
X-HE-Tag: 1769012580-191727
X-HE-Meta: U2FsdGVkX18/d2MztEbfhxlXSPNmtkrRAiqJdlt0zTqBXUEzEnlSuJ3L53y4dIXmC4UPN7hg8l7NFjfQ+ivw7JbNSCbxtHKzSnJZ3IhZBJEBQpiRozOU9TuNcHeSJenAqyS9HSaiyBGRQdRy3uj4EB4s/AAkKeGs6k1LdQ1UjjZsinEsNdnQECeKai5UXnnqYzlCXhNOCcdE1U3qM083H/QnIhZRgJbtDywh4B4X8ZGX7lBDkvk0X1uXp/uK9HpR/oNOSUTFZmcx6fiLkGy3AMGfNjPsRgn6KH+dl+Yuk/8QS772a4RyWXaxevfXSSPxzwyy06qeD0mU7TcvAI5LJe68wokXqfh9z6nDdhjDjD/nIwytdeBKquTR9BcIz2yKYY8ObR0SR8g5kciMeoGf++NMuKDDkAzz5/PEeRZK76LxY5+dwdZtEFw+iQA3uV8iqBbDWa6FVlcX6En8nBCrg6VA1Mf/UzWbVSLmB1e3RdU1Ue4kp87mybe+6669ikKDGzVugHqXh2pWZdjgOzd35bnSYJF0BnBv3vDQfGoFDJB8m5gQcDavXTvWz6zWp5HF7JbSgqiORk/RFH8nFP5RTNaLCwAWXDxBKQ6q1XHI+X6x3d3ANXyaRy2SYwqjUx1OO/Ny7neCajk7bW4CifLMcHXoc8E2EYHX2cHBnCinuBEANRsupxEvxCBTfGoDKP6l2MnOuw0XNXLmWPGn7S6frTN61yZInnmf2ByLyps5YzcvlnvmDNMreD457pkxSeCWE8GY3KVhz3iEZjR8D66b9AQxqDurSP30vqJV7dqjfR7rPyRh+62UT4gBUC/m9JqknoRGZ2HEI3LgensleuVTS6dqQty8K1rvfqkQQ/VPk7PX0mxkR6gbm3ngPt27X26eEOJllFxwOfBeNY0GruhzN4bPvlgxMbXEI/GEFt1wpkhxhPnJbVpU7WXa/9x/hDxDBWybMUPkwm4Z1AlSUJq
 rPDPq+4B
 LdAataUcetL2AVo9kh74IlDnE3eDA86ehU0BVK7TxoCnvdqulo7Dn4WouOvP4/tWsHfyiCSi1i2G95rWXS9sBd+Yr1JdnuSB+L0faZQ+qzs6yzEANKlag/Ac8jIKZ5I2Weql02Rtyfk6bJybvkLU8P8uH1QEKZwJ5tgQxFgacjn8DdYckPwYxWfVdAJcERM6EsKa2GbIEuzBbGAcqc8nI455ttD1gNfOirBuvMR/driOmT6jn0B326+jw2TvmrsS0YUgOFImX9psnzKGknT7FJkD4guoDIS6bGpRUl6hFppXxoq+Kkr982d4douVWvjkKBN+fMJQMbgnjlzZXsvSnAuqTjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.

This is preparation for adding the vmemmap_tails array to struct
pglist_data, which requires MAX_FOLIO_ORDER to be available in mmzone.h.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/mm.h     | 31 -------------------------------
 include/linux/mmzone.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c79b3369b82..2c409f583569 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -26,7 +26,6 @@
 #include <linux/page-flags.h>
 #include <linux/page_ref.h>
 #include <linux/overflow.h>
-#include <linux/sizes.h>
 #include <linux/sched.h>
 #include <linux/pgtable.h>
 #include <linux/kasan.h>
@@ -2074,36 +2073,6 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
 	return folio_large_nr_pages(folio);
 }
 
-#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
-/*
- * We don't expect any folios that exceed buddy sizes (and consequently
- * memory sections).
- */
-#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
-#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
-/*
- * Only pages within a single memory section are guaranteed to be
- * contiguous. By limiting folios to a single memory section, all folio
- * pages are guaranteed to be contiguous.
- */
-#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
-#elif defined(CONFIG_HUGETLB_PAGE)
-/*
- * There is no real limit on the folio size. We limit them to the maximum we
- * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
- * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
- */
-#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
-#else
-/*
- * Without hugetlb, gigantic folios that are bigger than a single PUD are
- * currently impossible.
- */
-#define MAX_FOLIO_ORDER		PUD_ORDER
-#endif
-
-#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
-
 /*
  * compound_nr() returns the number of pages in this potentially compound
  * page.  compound_nr() can be called on a tail page, and is defined to
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7fb7331c5725..6cfede39570a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -23,6 +23,7 @@
 #include <linux/page-flags.h>
 #include <linux/local_lock.h>
 #include <linux/zswap.h>
+#include <linux/sizes.h>
 #include <asm/page.h>
 
 /* Free memory management - zoned buddy allocator.  */
@@ -61,6 +62,36 @@
  */
 #define PAGE_ALLOC_COSTLY_ORDER 3
 
+#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
+/*
+ * We don't expect any folios that exceed buddy sizes (and consequently
+ * memory sections).
+ */
+#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
+#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+/*
+ * Only pages within a single memory section are guaranteed to be
+ * contiguous. By limiting folios to a single memory section, all folio
+ * pages are guaranteed to be contiguous.
+ */
+#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
+#elif defined(CONFIG_HUGETLB_PAGE)
+/*
+ * There is no real limit on the folio size. We limit them to the maximum we
+ * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
+ * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
+ */
+#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
+#else
+/*
+ * Without hugetlb, gigantic folios that are bigger than a single PUD are
+ * currently impossible.
+ */
+#define MAX_FOLIO_ORDER		PUD_ORDER
+#endif
+
+#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
+
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
-- 
2.51.2


