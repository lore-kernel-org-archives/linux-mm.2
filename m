Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B114E7DEF5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11B16B010D; Mon,  2 Feb 2026 10:58:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE69D6B010F; Mon,  2 Feb 2026 10:58:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9376B0110; Mon,  2 Feb 2026 10:58:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC1CF6B010D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:58:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51095C0B36
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:41 +0000 (UTC)
X-FDA: 84399974442.10.61CC771
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 247ADA0003
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JUuYPjvH;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+orHXb/F/4Jgn+yzNGiUVFTECbgQWYQLdldFXaEZhdI=;
	b=d+SjYexlTx08lzkl1sf4mJvt6FcCQMm21hRAz79fuIN9wRnRtr3ae9Pg197MElH5gKn9xc
	9TvYV13B0oHThZ12KvAru4D2ZXuvKkkid+ejf/qAO0tQmHPJb7mHStOQVdMfte8oTC6Hmk
	ZVwQ7RtbY8Nk7qZvX+6SPdvXF12OcJQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JUuYPjvH;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047919; a=rsa-sha256;
	cv=none;
	b=te/OeCmPgT0arhaOP1uXXnH0ZqU7xbxn5Fix2guZwKROtFxco8Op1ZqU/arhtNm1FFHOTU
	oTiQw6aEIV1cpl+n/TvFllm4QBgzFBTM1f+vZ+g65TK4FNkgPYEXB1WC+EoxUIme4fzPoL
	4lWttdQTP/otM9k63MiQo7+hH7vi3hk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5609043D17;
	Mon,  2 Feb 2026 15:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ECAC19422;
	Mon,  2 Feb 2026 15:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047918;
	bh=xBYdRN3sYZ6CyWP7NsrlACbZJA1Cw/lqNiJhnZq7FSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUuYPjvHnLyfoerZQnpfLmN8zC5Uq4UkgI6PydwFpb+a6+d0kLTWxdeqNId5pCQ4S
	 bjHkWdhttVZ2QyojnL4HX77XPmc+hi8J4ogibnqKEWYLSEgY8cCLxBpCuaqZqzkdQu
	 ONqi06hobi0lrIc6QJaLtaTDCXpiwE8UocnZz5DUIHpR35fuMkWqrcRqpyNiQHuiBo
	 qgPiDUyFBDHPB6eYIPo3ORtKtPhz3Rkdvo3Z9ZJvMqPy1mPbkrQ9uiyGPHJnaUg8ji
	 TJQmZ82s5ONBBPon8GTJ0VkWA/7KzhbqvJdl+iF9Jr/1LJ/ANlDIdnRVleRhle+iNr
	 vzuJ1lpcQtyxQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id AD0C6F40069;
	Mon,  2 Feb 2026 10:58:36 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 02 Feb 2026 10:58:36 -0500
X-ME-Sender: <xms:rMmAaQktccmo5zRUOKfM8qYXSW_Rs-wxgg1SFe7h15zsDGggavwAug>
    <xme:rMmAaZBMoxWm4wLE7JprxWxqzoZbsnkGRt2E5KlQbYd0qc53WIFPk2PCAU1hS7QWT
    6vxfEFCYKBgqFD95iw4om0DGCo0Srf0feZPVqdSYTQP41_lGn62jeg>
X-ME-Received: <xmr:rMmAaYzavl9ROuv6CkdLxcjnWMwqNgJWmkPJ68CDY9k1itnKJESV1ejjEPl-Uw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeektdeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:rMmAadco0FpI0FoHfSbz9WDxtIqAgoR5SRUYz1MhB9fi8vU7Jd8MFw>
    <xmx:rMmAaax3Qax-1wdz_e3Zp3-zwt0OTS9Rs3_h0ouojgvViU6rbUC16A>
    <xmx:rMmAaf7_PyCQBGnNbqgj50-cs3qO-RV-5_JVF-VssC8cYdQ7ESYl1w>
    <xmx:rMmAafyay6lY5WEAMUXUUSxW5Nt9vwUjSqOOrgtE0ZLk4thNL8fzVQ>
    <xmx:rMmAaXZFRw-DkCfmrIfAw2Ct358ZDGDgKhhm_osk17roauah1yHnwk1L>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:58:34 -0500 (EST)
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
Subject: [PATCHv6 14/17] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
Date: Mon,  2 Feb 2026 15:56:30 +0000
Message-ID: <20260202155634.650837-15-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 247ADA0003
X-Stat-Signature: gx3uwy4ui683kyyazmhznf9b34qb86xi
X-Rspam-User: 
X-HE-Tag: 1770047918-341120
X-HE-Meta: U2FsdGVkX1/KH7gvpHO7HBuc+6WmK0ipoAOKy95idhIzk/jgxb7s0XOnnKEchzCwL9agWoBN+kAiI67WTh7VrN5BYG7WGR8aNZ9cmTuQg+ks9W4Erl7El1mggA4EMJwnfw+1a9mEGiFGvKSDefWAMBitxCuYOX7ollrMU/gy2nsJiYHinfLxFNhRmSEL4f+2WA3pO4AGuloDlxkVBvru0/iMs6rODyBYHEnJ41s6A1UmthAtU8z5PpdiE/yRMl1ssrCZkENJHDYVuJ6Z2NlfxZxOQuryLnmb68PJwReLLctL2qgepakpkRUuC8DB0NbaUoL/uJTVxVoANAaBI2oomIId46jPtgLjybu5ZDc6j6FiI4teeX2d2JyEzFbIMXdZPDZXy/mH0mpYRPELGVMzu2efJwbMMfuKmKsqQmNIENgrivvSIIdnKYYCbU8N4tThpys6nJoIN1zSTsq7fD0iffPPOxIKn6xQA/OBXAjuSUC30XQ1H8vvtaDtOVCZ2woYJF/Gsw3oXv2VIW18xUxoAMGLa+X38Pl9h50IxQ2ZGhALZQVgIJFLuD52lLu8+wKOvtKVus5wm6xobjI8WvN4jnaDcrekIQNMGivwnordtsKiADXEwZMIw0IriAOR1dkqaxt1LHTkUTpsNsIdQB/MViwVrfZ6YVJKx8fgWixHtExuGeVUhaePcKYL8kzUL6OhUzpNBoQsKj1/JzRPuFHIBWIudABRx00lZ3y5Cw5Mt4MYYWgmVmiUvWtNbr3/zMk+p8QhCH7BvFA0PnS0dJjJEnHSMjxlTJGArJ7sQBvFhHPigGIU0pVom/PBjv8gWMYcyU418ahG7akXffMDSi/G+UnYHNyA+ZX5EMDdNdnypE1zgCMRU5NyWkzPPYwrLBFgcrojIESvDM8re+x+C2XpJkx6y7vtt/1Vnp+rr4KYDWf0XyiAZ4fry6IezWEtrf0UMZR3cBHP9ORRDW+bWR4
 0YP2u0Gw
 0yF+CFMpjgj+xCrDC8+w6DXPSelHQqBftVeUlLE35jCD8Hi4sHAh4nyfDQ7F7XA4tCjIiXj/r2CH5WtSlrDJMnxmbIg6sXtnHLDGmvKxiJ+WQiDducIYLXGuU9/Hgk9E9H6yA4dG3U6tyX6wgxYgNJcFsJEr++pdvydaYle1YYxsP5YMk9dPcJKPRxmes3GEADwDT8Pmm0AmOkSw++o1FO6Tkio/3ng3/V9jKi8HJjx6u+vS4NbGKwGpuDapL5/G3PY3mcxRDv4kROz2+QOoIKUZgyoUIENkpFFbPgBWSke37+X2Qd1RHroVOPg==
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
index 6088fc77865c..bdb68779d7b2 100644
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
@@ -544,8 +539,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	if (!vmemmap_tail)
 		return -ENOMEM;
 
-	static_branch_inc(&hugetlb_optimize_vmemmap_key);
-
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -581,10 +574,8 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
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
@@ -650,7 +641,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
 					&folio->page,
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			static_branch_inc(&hugetlb_optimize_vmemmap_key);
 			continue;
 		}
 
-- 
2.51.2


