Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B7C6D6D230
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4116B009F; Thu, 18 Dec 2025 10:10:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769F96B00A0; Thu, 18 Dec 2025 10:10:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60EF76B00A1; Thu, 18 Dec 2025 10:10:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BEF66B009F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:10:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F068140130
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:19 +0000 (UTC)
X-FDA: 84232927758.08.8740040
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2203812001E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iIq6z2Mb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070617; a=rsa-sha256;
	cv=none;
	b=fAcNMc1jFUBSeQFrxpSs01AWsQAW4V5bUxKy/K2uQ5V0xYvu+2AmHrN0TATFH1wx7Zfd+o
	h4YhAF+/ssD1LDzMmYoZFSfMVldz/3GcGRPseiwnv8+qEF6iMQGQv8LOE4tBh8NQSEqDdt
	SHw1HoSa9X3m0Fv/nJ8JJVZ38axV69U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iIq6z2Mb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cBnou2Tz9Fcd1LKwDzEvjnSdrHvnvZLFmz7nOy2sRE8=;
	b=ycldeJcmfQGbetLPtdCOUEQ/XXIwZaRY8sU8BtweEvWSU+0x2QplgOnJ3BDcrhaX/QvLBU
	CalCX8qyuNfTBKy0r1pbf+0Lu4j/iAE8us2OHNZmI1J/iDUKA1bxmBQPj4CTeLF+97Sh0B
	vOxJj2h1Tkv+rznLPC5/D46u0aXNXS8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F5E460135;
	Thu, 18 Dec 2025 15:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4ADDC4AF09;
	Thu, 18 Dec 2025 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766070616;
	bh=gUJboi084+oJ/+7QBnw/f3iBTg5QbRgqWMYm6NfXmSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIq6z2MbTCm85m6bFIbnBycalop6OftakaUBDSFiEYt66jEGEiz6tgjaDIwVC5qmk
	 HqcvKtaoTsTjQipEUGcAoFpkj345wNaV2S4IyDjJWpdIWZSFZC3pAIwBK9NGldIJ/r
	 SkGCaEh5jxMo9FmGxZZ7smE7Dscav9bvlN7mk3vJx0JvzDOEjDp5AKNd7wQO/Up3VW
	 y/KNGtq/yUmx/WRSxe5RTSPGS6NkdJ5ayJkv97SNxIwXegjItP6erYK+p4QzSK5hSK
	 SaRgD+WnJx9f6KJmtnFxJfl8j1ohG8uqJ1qJzYVgLeCMX8Qr8edVWO2BznZ8Sx5RTe
	 eNyCNInjwMPCQ==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id 41F17F40078;
	Thu, 18 Dec 2025 10:10:15 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 18 Dec 2025 10:10:15 -0500
X-ME-Sender: <xms:VxlEaaVuPks7R6wFtEDdIRQst4L0eZII5IxfeesvzBw2zQWV4wZK7g>
    <xme:VxlEaV2Sz1sC-al6neE3iWWLrmBqmOYDcrsSAI1bG7Bk1eKjSV3lVjpXrmRmvoZGh
    45pVUfeuaPhTTsD5Fut4f3rDiPeQs0rGazKDjZpO4_vLvoX0LkTwg>
X-ME-Received: <xmr:VxlEaRPU-0IGZbBXnCcORcqggFh6n7ZMQjt1oBR1xnBMGG1lo3v53nhcyXeYCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegheejgecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:VxlEaY01GD6ZoysoBopTypgNlWdBBwY27VD0U7FB309DXJkzfAc7aA>
    <xmx:VxlEaY3DswfPDhOqXXnG9Y24GlsHYwBv1uTzO1uaso0zEqoMVD6XTQ>
    <xmx:VxlEae8_OjEKaK1E1ACpgVsQX8cQtZLLqmqrzPll3krKjhm6c8hqMw>
    <xmx:VxlEacbZpYbK2_Lc-86Kkn4fZ0j98DTsrUbG9E9OWBJn0Sv2ZzErLQ>
    <xmx:VxlEaVyHQCDTEmAITVu5K3-xSZ367ekPRu_NBoygEbUs0YfDl9RKDEdA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 10:10:14 -0500 (EST)
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
Subject: [PATCHv2 12/14] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
Date: Thu, 18 Dec 2025 15:09:43 +0000
Message-ID: <20251218150949.721480-13-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218150949.721480-1-kas@kernel.org>
References: <20251218150949.721480-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2203812001E
X-Rspamd-Server: rspam03
X-Stat-Signature: nun53fnoeprgr69z3aru8meh7kb1aiqi
X-Rspam-User: 
X-HE-Tag: 1766070616-872299
X-HE-Meta: U2FsdGVkX1/yOirhoOOVa8u7SoHv9DZfecfsTcEhArADUzxTFVPfKI086WLrQnSsZko4ON8rBy2iXJZWbkW+HLMzEHYLSzvCvVCaerwvs2Q3tBZLw6aUmStRiiInPkf4lvWH5hGVSgSlL3tYsDOhlDSnKNEWwtCw7oL5WSPtFkOxRpF6axpZGZ4BjQa7+TLKIgImn2qNQYmReplDLxoxepA+r5bp4S7Y5qwNpBJN5r9SDG/jKNXjfr99Q7NDxal63lKJaQpMzb85thf4vsh/pdRMO9rIb7fJrVC/NWTRORLp0BO/v3vbX0ABbg5x/fSWrzqDiF8aEnKLDisggobMl7DHSgW1URsYgTNGQAdpOshXXwqZHTxVuHCPEHnQO8x/+Fe5/w6rfjH8wozdKPfDDrtX0SJrQ48pTtseMfRY+vz+fB20+glsL9MyqigaoTLi7OWv8L8g/JkTyeJ/xC+vLzQM5Ugjtw22pHG5bJy66SBTh5DzZ1RH3PjA0Qlz5Lh4/dHHucdZQI5Ru8wtsxwxoPJoZpYUz1a40rwvkRyIzvNyvYpb8H1m2tygXQItsj9KQHD6TOU3LxSNFfj9MtBrdS+Itbnn9YscBRhYp6NVvWb3FXGPcFX6u7QhSAZssT2hLAfd1nICha3wzeIPb/ucrcEConHUMbqdxkJG09zno3bIfHJRO/WnFoU3Q1PiBKSKhL9SBy4zHohTEba81PrKcnbDtSiFiC0awuJ8RVBtaJwQRX9tpfEuVseBIt0GYhZuvSYDZF9DQe5PHJtiF3Pa4/CdAUHYJ6ZsYpZoWHcpkhzQUsTFmP8z41MkSpgwXzdsIwXExWTA0zrhoymM1jWogzifYQi93WRM9DFRj9QMBgFqaq0QFm0WmA6OG3fgLcyZnezRMIncKxZ5Dk2mSMHISbgVhTWmuztHpv/OXzDUBFdW5OCwZJXDUJr9A5bmMWAMWMuvq3Mcq/7VbLJiEGQ
 wqiekonb
 KABPXp6xLzgUYv6t1XHAzgibb5qzZbtz9V/gQJ3YESlV5NlZmJPHMdWq6om2qIvWVVQKzSvTVHnEmOJs23giHcVmo1t7/nNjcgGDmxx7S2uf1z0Be4xxnwEYXqiHi7ylCG/bw3BAtERc3IkFBF+MN3AhfAI0i9u0XtbYm+mPQal6PaJNBUGIdGAwE8r8xiM+YvBn0DWK0jrr+mODQKR7JtbpAie6MbhyJH1/yRzDVcuKNJ8kzZyYqWdZFUC7AhBrM5hsDlSanX2nR7kQbb+t9Xw/IEKeQ3Dz88y5bJf0r+dH2w5Tn25iFtvXg0g==
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
---
 include/linux/page-flags.h |  2 --
 mm/hugetlb_vmemmap.c       | 14 ++------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 9d89beed9df6..2255e7e6759c 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -198,8 +198,6 @@ enum pageflags {
 
 #ifndef __GENERATING_BOUNDS_H
 
-DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index cc0fcf847810..f68ed7ebf873 100644
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


