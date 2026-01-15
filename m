Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBD0D44C5A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61AA46B00A0; Thu, 15 Jan 2026 09:46:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CDF26B00A1; Thu, 15 Jan 2026 09:46:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44EE26B00A2; Thu, 15 Jan 2026 09:46:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35FB76B00A0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0783A58650
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:32 +0000 (UTC)
X-FDA: 84334474224.29.ACAC9AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1230F14000F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f16iBKwJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488390; a=rsa-sha256;
	cv=none;
	b=lu9c8Yk1f7GZxYSY54s7vh8u19aCVua93S6SRhrSLQiBFVPNnDQJ+COuBBzCPBg4Budkwf
	O1FWCqSRbxC7ScVzCAlax9btJijr5cpmXpNqxoPhrWEmyKxa1NIlx03zlMBOdVcI9GWFIB
	PGEjyVONdOpl8lQhuPcrzsLReXZweW8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f16iBKwJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXX8Q9BkeF251imxmwkEnGGUAt8t2Ojp0tSz/q4SkOw=;
	b=1uQjMfhMtARb8Fym+6GqaC9QE16FXuj31AyY0trUR2taxCRpi6q8574hlj9bqH9wd6kxzl
	8J5hPrNiV1dsFvlqIgRErO0IRq469KLcoqL5bR27XNm4s1jlijntSzdSZQ0xnwfAQthB63
	TdrBf1lbbEjc5wmRcLUawwFknT6Z7TU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92042601A1;
	Thu, 15 Jan 2026 14:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD867C4AF09;
	Thu, 15 Jan 2026 14:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488389;
	bh=vihP4PIaZOeW2WsiFsW3RxkvVukSadfEbbD8jojLpjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f16iBKwJuF7CDueME/0dyCAazzZAskjd+uQsSGr/+cm+PQnlLJwRgrDNXZgXrQLKw
	 1TLcNPSU12uU8lrwcw9z4dJ9uE9tOTEmfzoiXBESqR+9JG4RmpXqtTQk/dZADgh/iq
	 DNjQ/aZmWy2O/QzRF4m9o4PgBB8EjGYWplGS+FpHNLgjSBXSc0QfLoz7R9qsVK3GU2
	 9mvZKxKoe2pVo6ERpiwlcFFn1cv7Yl8jxTzVMH+1YWiRQ6Fq7tm8XoKD+JOGvZ5pdc
	 xCcl91SE3XboTkVMtDBdpU6/OQXLc+ggupGbnQ5Ro6N9BMKqUp4A4P35o27UrOMnAa
	 2OTywiMiw5NSg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 04076F40068;
	Thu, 15 Jan 2026 09:46:28 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 15 Jan 2026 09:46:28 -0500
X-ME-Sender: <xms:w_1oaZLOsV79fH6afh8I-qgOR5HK3wffG2MsR1EuG30hfsWcmfgNDw>
    <xme:w_1oaUZYmkBguGgAuj0W4vi3ARr29gh2VG_PN1cQkjUDr6fk7nnQ-kdJabIjT1mzo
    xAd1ztl9nczQt9ACMYTLD4bLgLNZOq0rHpr10MEPrHZV9shCkyJ5Hs>
X-ME-Received: <xmr:w_1oaUhu7VvPqMbuheyEB94nVzfhT2Hn7Ouz44kfVYJPIWVZcvIYnIbNzXmw5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
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
X-ME-Proxy: <xmx:w_1oaR58XgzzN0I3rKpzF7351MuGP8_18RZ_jUPaDOSoRrepwKLIdQ>
    <xmx:w_1oaUoVssqlOp_FcvPAEOlk5kIQgI1hhMLNQuCVK_zZtBIoXFZlBg>
    <xmx:w_1oaWjbLvXnBb4HktGnc3DV0BE-ZEt3d4qpK2MzF6Hl0gcrJG3pAQ>
    <xmx:w_1oaUvCBvs3nfNgzjfHl4zV9_PmuWLn4eR1xvZok9hamV88XiftkA>
    <xmx:xP1oaf0FB2_19kbjZqjUJ5mfTg5OfX6YZdQv_-fBFL_8qLts3Ua7QgeB>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:27 -0500 (EST)
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
Subject: [PATCHv3 12/15] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
Date: Thu, 15 Jan 2026 14:45:58 +0000
Message-ID: <20260115144604.822702-13-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-1-kas@kernel.org>
References: <20260115144604.822702-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 389yx951rqoc73aspdiu4qy3fca55wxx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1230F14000F
X-HE-Tag: 1768488389-567591
X-HE-Meta: U2FsdGVkX1/KjeJPg6rLeaKisn2V+sDtIz1MaW3RUSVNoLi+ctVMjBfPkmqP1lb2UC9NVktFHTCJwgkNxyzNQ8zv1Ho25HV5ZX2zEPH04d5YqwSK5Sc6zLRdo/nzc9PplsZMchNHtgdWQsYZT1vZ8bMYL4DrtqG9Wg4YY19DrekIpuDPw5QO2Njh1l/OhczfY3Un3iiM1UUlLqBBORlXhloRHhMyhSaBvoKHjPNh5wg1mSEtCeGWQsKUrmt6fXkeYtuFuyn7U7+oSGAqYkiZwjXhSEUgAQo+dSFyVTz999K+l1jj0o9ACGUK7Q1XwQye0+JbvR4CjR9DraCXT9LybKN/rvNW/TLRAm6w41A+YNE/rUdxBQkncTb05pcyoROOHlNj6lzsq8IDK7V1SttV6Lz/vVv6918QY/TodBHvmg9KoU/5GfmxXbrLzCoMMyz7zNgBvMwatVksIYpZFQKfqs/ILUWpIyHFl0ZS/rLQRuapGvUF+tmOFfN8i7ZV598iuDsmV0LUwrZu0ffJfUTHu2Vk8L8iYBv0WdaRUAmK2MFZApS7KneByurKWg+3rWKA/Lx+xe8GqIhAs/Zhy4uag2KE6X59ZJpgRhEWtw1POJncZd1NbnVd0HiMue56JytGJPCFv3g1dsgkj5ua0/AuJI/WjfK6dpqhR4NL8J/jhzROc8AXZ1j4LGo30pR62HEh6VM++HRZuLHils9s6x/yVzCkFXlwHXVfEBjgyPYJKnvO4JpHTPbVpkt+aEj7dpSdxZopCn+rIgOfzCi1aFLbMiBEUIQ+fBAXLfjib3gYUwp8hxA3GYIgiRcUB7LkL5ru1RMNbLiEfWN8aXr3gjLcMI7tjfLPX+fS0K0ySMuOryZMFBmCCopjVGMbi2vGk8BEwhjb1gvEyLPp8mwX+/fS4kN6XAWaJT+vVhz3i7ozl3Y09MJ71JRJnVsxuTLD0/MJyxdHuS0GYSjoXb/OpH/
 iv2hEXwj
 dSKVNClgHOCljk2o+sqowwFV9NBvyadAkvcGSguGCioyaS/bPRlj4E1o/WE+7dN8yBAZidQpMSxNtb5S6Nu+JJsY052m1d97Xxs3wRhPWCvBfeMAulDcZnj3JmRuzKx7WEGQwsmTTYhRwV9JwhkgbtzVRDkQtynkLLBty5nMx5AiWJYJ6AVexEn1bqRVCgeBUloKlmXAtWBRvwaJVMXJVnDQ2oQJNWn6BJTEnF/B8di6TVgHiuf8KvoDQj+4l7bfixIwswXtwo4RJwae/515mtbCXoNIU1CF23HOUz1ROg4FvSFa0fN+kL2Ohwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The VMEMMAP_SYNCHRONIZE_RCU flag triggered synchronize_rcu() calls to
prevent a race between HVO remapping and page_ref_add_unless(). The
race could occur when a speculative PFN walker tried to modify the
refcount on a struct page that was in the process of being remapped
to a fake head.

With fake heads eliminated, page_ref_add_unless() no longer needs RCU
protection.

Remove the flag and synchronize_rcu() calls.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 mm/hugetlb_vmemmap.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index cbdca4684db1..5a802e292bac 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -48,8 +48,6 @@ struct vmemmap_remap_walk {
 #define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
 /* Skip the TLB flush when we remap the PTE */
 #define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
-/* synchronize_rcu() to avoid writes from page_ref_add_unless() */
-#define VMEMMAP_SYNCHRONIZE_RCU		BIT(2)
 	unsigned long		flags;
 };
 
@@ -423,9 +421,6 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
-
 	vmemmap_start	= (unsigned long)folio;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
@@ -456,7 +451,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
  */
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
 {
-	return __hugetlb_vmemmap_restore_folio(h, folio, VMEMMAP_SYNCHRONIZE_RCU);
+	return __hugetlb_vmemmap_restore_folio(h, folio, 0);
 }
 
 /**
@@ -479,14 +474,11 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 	struct folio *folio, *t_folio;
 	long restored = 0;
 	long ret = 0;
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
 			ret = __hugetlb_vmemmap_restore_folio(h, folio, flags);
-			/* only need to synchronize_rcu() once for each batch */
-			flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
-
 			if (ret)
 				break;
 			restored++;
@@ -576,8 +568,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -636,7 +626,7 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
-	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, VMEMMAP_SYNCHRONIZE_RCU);
+	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
@@ -664,7 +654,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	struct folio *folio;
 	int nr_to_optimize;
 	LIST_HEAD(vmemmap_pages);
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
@@ -717,8 +707,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		int ret;
 
 		ret = __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, flags);
-		/* only need to synchronize_rcu() once for each batch */
-		flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
 
 		/*
 		 * Pages to be freed may have been accumulated.  If we
-- 
2.51.2


