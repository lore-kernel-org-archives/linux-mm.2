Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED18BD44C5A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10AC06B00A1; Thu, 15 Jan 2026 09:46:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094B36B00A2; Thu, 15 Jan 2026 09:46:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E57606B00A3; Thu, 15 Jan 2026 09:46:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D05366B00A1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:33 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4366B8F13
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:33 +0000 (UTC)
X-FDA: 84334474266.17.7C36F48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id BB57B1C000F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f+4yh2N1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488391; a=rsa-sha256;
	cv=none;
	b=YllDY7qFo2JeD6dXPZF52fyMEak49XEVyrZax5zE8lHDQdzA1QBD3IT/eEbuK2I8Y9mpjA
	Ju0Dc3d7EUH6VwpXsjx07SaGIiQBJ8579KAVlwtjEByNAfXTB4R4NjdHjJraQhMBOiamyZ
	FbU28RV4I16uPmxTxRUJYCCLixRQgCk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f+4yh2N1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vYqgaQlV2u4eKpr8abHc6oHy/CimCsfFWCmsmcF/FvQ=;
	b=vrAyQBSp8Tl/8DP/zyJb5O9z6Wk8RPFMMFNJhxhCX+RxMsuxwN+dWc2dyQ1Aizjp8x/ury
	80RvVRuEXmJXZpJB90ZoqIUTDm9XESJZQGUWLwDp6Ms9TQA+L6rRo1oVLyg3Pf6MEZlzNQ
	YgwwDt35vVLIJBsfnXtjEWNn5XimySo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 53B36601BA;
	Thu, 15 Jan 2026 14:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751A9C4AF0C;
	Thu, 15 Jan 2026 14:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488391;
	bh=56Ngy67RioCpKMVBbaFXYfTVQpop0DnoZP0CjrywvUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+4yh2N1Ui5vDxiqaa6nDoQS70tqyMV4l0hk6BZRLjBISP92a7NNssKlOaF1MJg3/
	 l2Qd/2rEHQZV9AU5pv8Yybj2GS4xWwDLQETriDFX60jH0d+rSx+xwy5VxWnpF6Z+Uj
	 VeR/JeOytDJybekS7QRxMTa82aOcS+RBzeJ/HC1/+ddps1xK01AkJvR5OdAX+HPWuE
	 s06wvq3szAUcN0W+u2MLn6QZf9OXaI0t29SSAhz9iGlsU5NnZNKdVbApylrI7/Rsnr
	 TxpffDc3TI3pGphP6Dfw7C8Jkm0fuGUbStpTRiK7GrVj80T9XlImza8G/mqFeM4Bw3
	 kxOsGfxIpaf8w==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id A2945F40068;
	Thu, 15 Jan 2026 09:46:29 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 15 Jan 2026 09:46:29 -0500
X-ME-Sender: <xms:xf1oaTLkX8meUF9nP-4-GBiqHPAJu27RuS8q68_R5ZWbG1Iq6pV9pA>
    <xme:xf1oaWZNp8Oe5kFMC6eoW1IxPOaAm4ZjfTF9AQD0IUhiUsih1FJkDMrdFdk0rrmYG
    NfJ4Dhj2RFRE5N1nphDaEH-e5AvxvchuwiZDN3SCt1A4_Ub0Vs1lGA>
X-ME-Received: <xmr:xf1oaeiMLIa6UCiOo3JL7MwcIRAI575eTI57pO7YEFnGstfT2lfNAtYX3JTrTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeefucetufdoteggodetrf
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
X-ME-Proxy: <xmx:xf1oaT5GQrryz3IvANZNyFUX9ewr0-Mar5f6dzjx6UNxv25sxNBjsA>
    <xmx:xf1oaerkx5F2pBotJohXjO_GELTkHFGroaRSYRhC5poa8r6gdDtsrg>
    <xmx:xf1oaYgCgnm66BfDrDLFOnxk4KSe58EeitT7c2Mve4UmToMMg67YyA>
    <xmx:xf1oaesqFdkvTiklhR_Mpu6JN1tjOK5D6rdxAM0POBK-Y0qG0AKHDQ>
    <xmx:xf1oaR1SqSBNb2GLEaI8n8dUFU_Ei4ie7SCMDtwDnNQdy_M9Czliz8hA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:29 -0500 (EST)
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
Subject: [PATCHv3 13/15] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
Date: Thu, 15 Jan 2026 14:45:59 +0000
Message-ID: <20260115144604.822702-14-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-1-kas@kernel.org>
References: <20260115144604.822702-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB57B1C000F
X-Stat-Signature: 5ttzoczjw1r4uo8fypyrwimtsugbqcc3
X-Rspam-User: 
X-HE-Tag: 1768488391-471677
X-HE-Meta: U2FsdGVkX1928yFQ1cl+XHELxQN6U8jMMXM6IJ56EW8FGc6SpqdRxZm8VTSJlRCM0jyLkPt2q4kU7aqskMw4tfHx1UGzt212aHooQn3ZrOMZFyBcFP01MPKEFsezVwsq9orPOkm/S42bpat9pwbgVqgwbXybWxTKmKV4FSaVwoZ4if7CP3Z0dUz8UOO/9x7qgY07O1ML/jq/zRG8+gzBPRZpM55LQ1znKPOLt2tEgq5f9fcJ/llhSGilIPJaxxstQI89EG9R/EUj8hPWyIg9cnyddnHGFtlB8OQinoTcxqck83qusaM42s9oceTRjPzcd/+6++iyBfpkPxfERvHuGOisoa0xa8zOv8SpjtRJlpkFu33pmBUkmkOgGOCacoCwT+iaTfVXK9A1w9VgwATkszjFrIcnimcJVD46nywBqccbQX71cLrTjPAugKcWXwxJ3wcw0EF5UNd6qi2BaeKDzPa5QS2ALHlxfHudB5OiDK1PEVbLYAGm6XXRbic4btDpzdV3ovA0in0q1Iu1JU092rHm29jdzB1ml6g4cb6OKj190uA3gRXnreKmIaX48OOcKl6snZv0c8EdP5sWCEW9wDOSVWVlcg0a/iZZb4zBroxvKCZO+9M/W7aBZE5dWz8ocg/h4kH8VLr/4kS45EgeXG1cy1/2GPLLfdFqX2I9ljJx1D0aLGc6GiBSSTZjB+QUFy7dLX5zUYDbDqmrwEi3jYngPm1nZWTQJOZbTwYIwz1ElaoQkjeHRIS7lx2NF3IsBxESZHN+2OqsSGQntfRSVmxjz8ZfyqogAoAlC9YCNg6MWQ8DflTrF+9PXTJsMpFortRfu5EXw2XlK6yxlf8ECsNN+eiQ7QBMy8zDi/Ey1gOmpFAIrWv1xajIY+Jngdy+Z1I2L4Cwj+Q5tQdSANSYX2xTU7+T8o47jqkHJv8ysfYRBsaj7QA5lVFY+pKxv0x0VgA8ecIxXKtvY8oYa6S
 5nPMmPA8
 7p6iNc/S8ZW0vrYw9UIF5kQ5F0hUO81FkA7WhJ2HeibmItkVdGtsA/pplk8/4uLmC1hb1P+29pioCLOEJahH+LUJ+NsttH7t29Tlf87zz306m1ypJdtbWplRpgqReQQp6YZXlyUpSbUhwdKwpVtb727ZwhdMTSGw2GFBHnDH3Jdmxp6OaXgMf4Qg1Y3HAI06cz7wVQHSfiukvIB4jI9fJbLgKh2k3P8WsM9D2ar6w2+tluElbP2qkOFb+C9AESuzwiYz2Re9JZfWyxeb5DqMzH64xC3huvsyAUNZiTp47dSgxrFgxBNjUqYhHCA==
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
index 660f9154a211..f89702e101e8 100644
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
index 5a802e292bac..5afd9f4231e3 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -399,9 +399,6 @@ static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 	return vmemmap_remap_range(start, end, &walk);
 }
 
-DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
-
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 static int __init hugetlb_vmemmap_optimize_param(char *buf)
 {
@@ -431,10 +428,8 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
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
@@ -566,8 +561,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	if (!vmemmap_tail)
 		return -ENOMEM;
 
-	static_branch_inc(&hugetlb_optimize_vmemmap_key);
-
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -604,10 +597,8 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
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
@@ -673,7 +664,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
 					&folio->page,
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			static_branch_inc(&hugetlb_optimize_vmemmap_key);
 			continue;
 		}
 
-- 
2.51.2


