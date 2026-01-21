Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88E3AC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E97D6B009F; Wed, 21 Jan 2026 11:23:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E44C6B00A2; Wed, 21 Jan 2026 11:23:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B75A6B009E; Wed, 21 Jan 2026 11:23:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 533706B009E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:23:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20D6B1607CE
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:26 +0000 (UTC)
X-FDA: 84356491212.05.3C5C75E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 23A8E18000B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LbLwnIs2;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/RrjtBi09bIw3c9AyMDH6uT+NMV1DsNoFITETtf6aU=;
	b=RKKmTmO8ZkYTiSZV5U7RuyLbhoy3Kg8+YY2jWMy6U/qn4JhAYxd5YsokVPObCxoNSLdhj3
	6158bFC9p3mz7sUagb14Q4Up85UDU5mhSD1KNcQOLw7zaikcz8siNDO4tp+s4iAtNI/cy9
	EafEKZKeo40tn5UejLbFyt4RZ31oL38=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LbLwnIs2;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769012601; a=rsa-sha256;
	cv=none;
	b=AIxAAs86W6zKaVGKQth0GhbOiYQOwVEd72xe2iY2iLIliF04cyWhpBYpMTWVvslWhkkvPt
	wbfe4AYvmAyA5gdl0krTjJqu7QBp5Ub/7O5PK7gpfMJ4xuToe6bGTg4rrMHzVkUPJogWEZ
	MVjgURJW22Zz0f/uUlYLl4S35DfwVos=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 980A26015A;
	Wed, 21 Jan 2026 16:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4592C4AF0D;
	Wed, 21 Jan 2026 16:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012600;
	bh=CqQagqpIE6shmA1vnfmKBVn7MpPHWOxlVoFvPYHGmlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbLwnIs2SB1XJPOwcoR96gnrEbkh+kE10RukjZLlEa2VV5YD8IROP0ytow587gYIU
	 dBW2ABWcS/UqselIXSHmz84xnMsmUsPVkAAXhzutoG4Tjfaaib+KMgdnSY5Ac96fmW
	 EyAP2w0NcEGJ9/A2JImPUTcmedenFevzZ9FOW+XrKLausbPt6AUr57dWds9e9f5sAa
	 +0Ig/tJ2+rIyqiJ90yxtvHwL6d1vD9mzN63WlYughNB5sIviWUP8LEa/q0E8YEDVRv
	 WP08RR/vIfEQ/dYn96CEAUQn3gY+lmyfRPagXOTyHiNgNydPj3Y9MXZEbzMc125Z0x
	 HKKAAOOL9lTiQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1760CF4006B;
	Wed, 21 Jan 2026 11:23:19 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 21 Jan 2026 11:23:19 -0500
X-ME-Sender: <xms:d_1waSIbRrbaKJP3yuk3GJzcUegtqL3WcZeERntPps0mIE8D0aYnhA>
    <xme:d_1waZZRSDw1tkqlVlKgRlJxyIHmaH7UKO1LH3-lCWA2PVt7RMlxzt_bXKGX8kpGY
    lQYgS5JRz6KrZDWbvescTPSoEmxlYrJwAXc3AK6BfR84zFyh7zH8g>
X-ME-Received: <xmr:d_1waVh1vgg5Vm1dg_Gk0ERl9oigpyuKKLnwYigYCqcJtVhWGLypgPqVH3QrWw>
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
X-ME-Proxy: <xmx:d_1wae7ddtB9w6aurFIXf6QwdqRTFD3piyf0QDjDQWj12nMEh2yIUA>
    <xmx:d_1wadqatLwB3bZjqr6SARpLOvwdOriJc_GuEHbWNDxoZ7E7PEgmjA>
    <xmx:d_1wabgZAUXSHoh9LoR_s5SxFyYJVpHDhs8bRAa-psQ8jUNDGErLAw>
    <xmx:d_1waVsqR60lI021puQ9I1WxluMjlDk5hPWw_sgtZ-ogpRm8iVgegA>
    <xmx:d_1wac20sQDO869yRk0cI772q18ow0nzeyyrwGstR5Q1rzZoZDfj8Coq>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 11:23:18 -0500 (EST)
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
Subject: [PATCHv4 11/14] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
Date: Wed, 21 Jan 2026 16:22:48 +0000
Message-ID: <20260121162253.2216580-12-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 23A8E18000B
X-Stat-Signature: 9t5ztpi9c3ffop6e8ihrr7f8mce1q4zy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1769012600-499096
X-HE-Meta: U2FsdGVkX1/0Xx7qECE6onUDT4SJVnV24C4/Suqqc4YQX+ZJmx9dvzhHQRwC6xGVVU7/T/GbhNmBDf+2HnFssE2qGZJTBgPoPsOgt1OnaZ8fKEshwbmVhFFdjWsJhCUlF6Bw26szKhOIXbCzvLTlBs3tnZFkpD0XcizWC0lveHsHa4DAajf6p45ZxpA9MDwcz9cRWJvKfo+C8HAxSXZqwb2PVXTk2BNpn/gtS+FGueAiWyp+Tn3bVnOaU6Fym0xitAL12rYZDYw8pZK1cbHAVoKjyso8Aib/3V+tQGBd6wHlIg0B4x0Y0DRUrc0VpZj9U6ujJ02H19XZayaPUJ3DM/aR5DJ+fDrMmXuGkK0s5lPu/EeVqJsvVA9CStHwzzOoYBriH45DyAOj0Ll/HwGmTR1waockRb9xTHlo4Y0X7+bPHD5Cmr8IrZOGVpPK3r9PzVT9btOmSgl330zDgU8aWlDzU9LHniJdM2ZLkog6RmXt23sukVb8RTSHDXJxPiNEbZNYfU2+L6NwuUQQt/EpMukUs/DyiUJuVB4hNNcoMG5S0QNaBgws3duL/gIl2xcoPxoZqG0jUyM2CW4olZJI6rPIXgR2N91UH+g9nLjtef3mjYz46Ow/GzDgDc6M5MxbcCBsRwFQhNTqAUXbFaTF7DMQsZbb7SozVh4MTpst3YNyOqe7FqzhsXFUDJMiNbINYW7TT0T0Qu3zdyD7RnTCjPpGoaJ9XlXb2qrKHPnZjdQC1uZnZnYl9IRInfd9DN4LqEm1dFvxW9C9Vp1HgiN+8v21APCLnYWa+YOy6a4CyoB+SIxy62IrUKgGtEg24VMQ0wErCdEdeXVkcQkpTrLfJdOOepUJxNLPX0tpV/D6ktKVhfOWf+/bhHERwFUTTQjYrFoxpTXtw+3WV2IrLhJkczwpYm2eWRe35U7FONoDVpxfLhedbLy9asdGOMhhObKIMrYHMDPQKDRO9LFyCS1
 yvAtGu0j
 kMR/wbUvAOooFWY7ppRSExCF5Kj1xACdB2D93BZaRXkMNNMGO5sGPkzG1MLvg5rifgd43XLh6zqmwRGvmyUdG/J4+LYz8B5t2TGNi5yr8btTEYh0mVeN+I2GFTVdF+ilAUFcFRW+FUT8pne0osZhHerNVXLXDR84e+Xor+RXLRvd6LUG0bAnJrOlB9mD9//CJmMUXx5Z/Edb41VBkcneQkg56NL/JwhN1ZALq+gvLBl1ci8UgWbBfo3mr4V7KeCdsa/YrHC023c+DQNh/EOYi0/Hyd3SVX3kEcIvqXDRJESsZDX0F5TwHjPQp0Q==
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
index 51bb6c73db92..f2a3340c8e22 100644
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
 
@@ -410,9 +408,6 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
-
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
@@ -444,7 +439,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
  */
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
 {
-	return __hugetlb_vmemmap_restore_folio(h, folio, VMEMMAP_SYNCHRONIZE_RCU);
+	return __hugetlb_vmemmap_restore_folio(h, folio, 0);
 }
 
 /**
@@ -467,14 +462,11 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
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
@@ -564,8 +556,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -624,7 +614,7 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
-	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, VMEMMAP_SYNCHRONIZE_RCU);
+	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
@@ -652,7 +642,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	struct folio *folio;
 	int nr_to_optimize;
 	LIST_HEAD(vmemmap_pages);
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
@@ -705,8 +695,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		int ret;
 
 		ret = __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, flags);
-		/* only need to synchronize_rcu() once for each batch */
-		flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
 
 		/*
 		 * Pages to be freed may have been accumulated.  If we
-- 
2.51.2


