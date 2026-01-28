Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAC27D25926
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C5A6B00AE; Wed, 28 Jan 2026 08:57:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D516B00B0; Wed, 28 Jan 2026 08:57:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A386B00B2; Wed, 28 Jan 2026 08:57:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 061B26B00AE
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:57:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7599D27F1
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:57:07 +0000 (UTC)
X-FDA: 84381524094.02.20A43E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B9FC64000C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:57:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HlE7J7Ds;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B07NzTmFEL9hXOp3hT30o885xztUfp4eucsNozFuIsE=;
	b=qPBIOUhOxU0Xjv3SbiJ3j8htu4BhD/5FFuuj0yKAKVz0lv8MqJrSZIS/oBDxjuuc3TZtVN
	E2+DnlLmj+xZyTNIf7neS5G6KvVLsdMz6Cq+fhsh0NtM24a5Ef6v4NOaYvDiQ5o9rMkX7p
	7yYNzftz6JHvNSUIthEvCeYjpoHuuFM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HlE7J7Ds;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608625; a=rsa-sha256;
	cv=none;
	b=R6jURAh6diRe59/zsFl2S2V1TowDeYk0tJ8AHFgwllcojP4tsR8iqbsEqITJ+n4jQ8bk3D
	9Yeg8hLc8EN4fySrDYgxMUJVcDiiEoqOpwNvb10TtMGuLD4P3RjkKUX5/aIW3XLXVWSV6k
	TCLpJaDoWJA3Tr8nvB1b5IZPQaeg4T8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E181B41725;
	Wed, 28 Jan 2026 13:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097D7C4CEF1;
	Wed, 28 Jan 2026 13:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608624;
	bh=yZZwgfqhBoB+VgGRm27UrMryetC9+LjML7284/gAEmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlE7J7DsdNqUWIc1XnDd+VFzZdsxUKIEv2sxe2PHHFD8R4JE8YMFUylR07DiXnxE4
	 UjfKSFRr86Grc+rt8JVASkHit7IsBiei6lwG7AZ/qRgONcdWcGvJklg0oJqc5I/cf4
	 h/XIg6NxyRtYUgJgOT25kXSr2QGXxFXVkWtMVpjFORSmPoGQcs9WLDcLvKQkAl0neV
	 N3/JcriEnuCCqY9ILRBklb0FYp4VFHKEEjHXpSbogVoj3KkRykCX/xVoIV+NmvlghN
	 pqMh7qJeQcpG18YIHfkYlbNXfZvogEYQClcqs6IPfVaPzTUWKE0FJWkgFcDbvgkV+h
	 hFgqFPoWHQSDg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 33F58F40069;
	Wed, 28 Jan 2026 08:57:03 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 28 Jan 2026 08:57:03 -0500
X-ME-Sender: <xms:rxV6aXnQoYORUEJfWcMxyo8Utbdr1nnqK_e9Dt2yNLa2kFQN4bDZKg>
    <xme:rxV6aUCDb9qtBGo6vgkCStkEVFgMd5BqCb4yuZvNXObkd2NQGOJGAw3XpLie7Zron
    Y5cea1nPq5SkzgxIpqxtlDDTq5zHPuHJm3fy4wlNoWHhtjpOINs>
X-ME-Received: <xmr:rxV6aXxDFK4qRDtI2uYHwCd5WuTe3f8CUFgxxZPO7EGvJp8cb0cu6G3p31_Swg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehrvgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:rxV6aQd3tU6CR3495l0k4R55iRhA-KACa-z7zffBlWbsS5Ox-_q5MQ>
    <xmx:rxV6aRziYj08uSGDwixjzQ_3baNols0S8cT7Ow-TVWMGM1QZty_CKQ>
    <xmx:rxV6aa7xWjAHv-sRdAyvYGQ7mymmsVjQlvC_YuCk4q75ZUVfUzpCGQ>
    <xmx:rxV6aeyiqCgqSZlh_Pp9_MA7VMCcPdMxL8v3fYfISp1lON_P-nEPlA>
    <xmx:rxV6aaZGxRkppOlYDSXS1gs-3kBwwg6tyHWUhZtbi9eJIC9Zfetyg5XW>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:57:01 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
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
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv5 14/17] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
Date: Wed, 28 Jan 2026 13:54:55 +0000
Message-ID: <20260128135500.22121-15-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: t9nbqo9pnqu6o3eudtwcyf8hmpecbt43
X-Rspam-User: 
X-Rspamd-Queue-Id: B9FC64000C
X-HE-Tag: 1769608625-997957
X-HE-Meta: U2FsdGVkX1/LeayZYjkOc4pbdaC7BMjqH2iYWsCRzaJTYhXeQ9mrlAzB7JhP5/rFbFVEDkjwg7w6nUzBL3hVtkkf3Mi3vrsNdY6O8OizVggdqZuCit9JbIsff0qim62yabQDirDhdV7YYiBl7FowFBx+ESqYe8YKZLpGoQxRgONNQc4I64O1pYBA/0xKLPjXWUvnbrh9zJy4ChZbaR9dXQanoEI7gzg9URYTtlR9HbenKPcwG7v2v1rL+Uc/XlQfu88crszuHYw3his65zINnBBIMNg4TTJhSuPZfAswP9xzciguL2s/QFBIlZzDAoOKR5+JPphNPVZLRhypYmpGiUXyJd4CGXHibA3koQdNFfAlFLKrla3g9hwzq0INy+JXgLy3jQ4sh3Kw0fThO0DnALajevwLV8/SBmZz4wHlnDabMBYzYYXuRd8r7Z8sGTOwJKnhZhvYXeq8PYtdHFjSGqogjJ95/skefJ4EcU30A17IkhPqrZOhUqCpVReOAKkZVWnFmdeEyIjoZ1kbGDgDPuXIjLAJnCnahQN+bXBiQAPbiy6fCl7MOhoffoIwGFeciTPPzTXY5SrHQJpvkgG42tgajAhU1pKdKJ4kXkjDqkYbgP0prkrIlYjCeU/ck7tBhJESPlsJYg8IoZ8ijHdJKALFMWTri8q6wmXtjAkYNvUyl5PKHUeHPYkiJXgqLTPA1riq75CW2kD5OWQXK0AJ/+u2zSzmKl/QVLI4gEkLYIXkzWZgToy1/v2NonN95qXlDLiIpOiGRH+t4fSejpH07pCy0lsWyswPcYxI2rBlCH7qDe4mPUpYoLD5L4JEaYoyxWgc1vfm/B9iqra4KDbMqSFf56FxYxxpDOilH0TVuvA1egbcEPEGbUkjDw7BRVh1V0yqlCfpZUwJC4Se2Z0bSkF5pyenk7AyVhEzjyIu7lrPvt67RFhHwGEBS0rgcdxT6hhvUWb7wR3gZKo1j1C
 Mrns6NRr
 MtzpRCs0VzqrFz9QUAORj/9gW073n9dRb5FBtAqiPdT6LcrbUtoOXwdv2eUXlaKYjYTPQWJ0eEvIUStGYu6tUVTmrfFWqdqdOZaueAJtZNGyeeHXfqwopl3uqiP6j1Ri3HznzmP9s6wwxU11Rl/gVY+EUXU52ZUVxpxE9wMlZfCAnFbxVlOZzBeKdo5spTU2RhXwnNx6j+NrMBVn1kvFkL3lMFKKzvl4rnbWUdIFcr/XM20GDE6Mx/jTl/Ob2i3gwUGlpjO6GQZWPBaxELoP/0+KtkI3SJYNVJDst/GtZdzgfoFd2pW38sejlOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugetlb_optimize_vmemmap_key static key was used to guard fake head
detection in compound_head() and related functions. It allowed skipping
the fake head checks entirely when HVO was not in use.

With fake heads eliminated and the detection code removed, the static
key serves no purpose. Remove its definition and all increment/decrement
calls.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 include/linux/page-flags.h |  2 --
 mm/hugetlb_vmemmap.c       | 14 ++------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 5a8f6fab2255..1aaa604f4b9b 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -221,8 +221,6 @@ static __always_inline bool compound_info_has_mask(void)
 	return is_power_of_2(sizeof(struct page));
 }
 
-DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index fd74a164c494..63e7ca85c8c9 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -385,9 +385,6 @@ static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 	return vmemmap_remap_range(start, end, &walk);
 }
 
-DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
-
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 static int __init hugetlb_vmemmap_optimize_param(char *buf)
 {
@@ -419,10 +416,8 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
 	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
-	if (!ret) {
+	if (!ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-		static_branch_dec(&hugetlb_optimize_vmemmap_key);
-	}
 
 	return ret;
 }
@@ -546,8 +541,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	if (!vmemmap_tail)
 		return -ENOMEM;
 
-	static_branch_inc(&hugetlb_optimize_vmemmap_key);
-
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -583,10 +576,8 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 				 vmemmap_head, vmemmap_tail,
 				 vmemmap_pages, flags);
 out:
-	if (ret) {
-		static_branch_dec(&hugetlb_optimize_vmemmap_key);
+	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-	}
 
 	return ret;
 }
@@ -652,7 +643,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
 					&folio->page,
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			static_branch_inc(&hugetlb_optimize_vmemmap_key);
 			continue;
 		}
 
-- 
2.51.2


