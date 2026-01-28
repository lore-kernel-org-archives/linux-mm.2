Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63F9ED2F009
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41216B00B0; Wed, 28 Jan 2026 08:57:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F306B00B3; Wed, 28 Jan 2026 08:57:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B1E6B00B4; Wed, 28 Jan 2026 08:57:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9DB0B6B00B0
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:57:15 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BC801A065E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:57:15 +0000 (UTC)
X-FDA: 84381524430.18.4A6D69E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 70B3380006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:57:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cTZQ6R98;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVwuFng2nZHrYqkmebOjdjYfKKmOgHaN5oXs2k81MRY=;
	b=xnzHNRHBOwLw9/SfdpPhrsGlBNlvBHhyb1JGS67YmPtGmv7Tq4QerrohwFiupgpiDc8Hpn
	sL1a9IK2brKl5i0Nqu6dcuYbwEZjNAU97ZXLUoMb4aUaouPfUQQNuEMuObfr+4Jts9aNMl
	iDsJ95+plKT471Cduqh0OPxBQYq051Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608633; a=rsa-sha256;
	cv=none;
	b=u0It6S19xKWFoGEDVUAWBYMSixoV08Ql4NJG5RhB/tAi1QZXVQUda14YbN+txirt2T/Z/g
	SV00L+EdaBTeLBS+b9FgKWnDu3oYEKlL3mPim6KU/5ZXGAFAagSi3vMmeTlQVjqGwFTUc4
	4Pdq5nsibTAVKPrDJu7qRDeg71btqxw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cTZQ6R98;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 006826001A;
	Wed, 28 Jan 2026 13:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAA0C4AF09;
	Wed, 28 Jan 2026 13:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608632;
	bh=hHQLWMhahxCY/meKke54BXwjoj9QXEZAW+ce8KhMydU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTZQ6R983vdQ23cB680GoXRU6UtfvRZtA5nJ91sXhdrW2W07PXFBFkMNGrbDSGwQh
	 7FPOdS4mWFiijQTd5baeR/XRUZZHE2b86en9jJejM/AsJVuTsswcIfh+a8XMN/pYzt
	 aua6hs79qeX8tbDWq8U+kIDtCkE7JL26HpWnpa6hdB2h2znOQgtOIV3a71P9C14JfR
	 CtV4U0UeyULoxG6svBRDnv5PfU4rnKCh22hvtOkXzLHv+2IaH9THWgT4ThQQdXpBeF
	 4TYkCvAyoFD5vp1Y5Wp7EZfkpXRIOs3Fu9p7N4BrUPuIwov910Ddz7GpkZnTtI5R67
	 NdQ9QQNGQ2GQQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4D1C8F40068;
	Wed, 28 Jan 2026 08:57:11 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 28 Jan 2026 08:57:11 -0500
X-ME-Sender: <xms:txV6aVRQZB4KG2aHpYfJYJZOXXC1PLooJs_GaKWCkx5U9eVU7GuktA>
    <xme:txV6aX-1AkaQZPx4bmd-EZWZ97Chz7YcWia9gZQMX_-Xcv9_dmDVRFg9qha0N88aq
    139xyLybL-eWMOs3KUp6mZVGh_TxJmo8SN85KepyDzCfBuXcRaZu3M>
X-ME-Received: <xmr:txV6aU9C-a4GNq3QgjgIL0c3RPvS0WtekJ0mUxni5vZMDwkuSc5QEXzkZ6QPbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
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
X-ME-Proxy: <xmx:txV6ad6Iq1E8Z3yOgvdgcQGabzVFq4WqGZTzNUYrbGvZNX6_lbnc9g>
    <xmx:txV6aaekY3jMEFwcYD1bdHuxRNRqyhmgT2rKY65aOFebDcEf-mypIA>
    <xmx:txV6ad2omuBPGobjaAntywEg1ficwRHQ4I72jGRwB9V1RFxWQ_b2VQ>
    <xmx:txV6ae_bsROEWyoLL4qunHwLOYp_FSpOe3wiCl-sTtJ-Nq-yh0qifg>
    <xmx:txV6ae0-r54FlGDx1kyuxUrT0kia0bwlzouGrOGwzXDZ4CHA9S9hsovv>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:57:09 -0500 (EST)
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
Subject: [PATCHv5 15/17] mm: Remove the branch from compound_head()
Date: Wed, 28 Jan 2026 13:54:56 +0000
Message-ID: <20260128135500.22121-16-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 70B3380006
X-Stat-Signature: gnt6q5zhj6rsw88qeyw6aa4oz3s3zann
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769608633-300203
X-HE-Meta: U2FsdGVkX1+BSaEqxnI9prtgy4kMp0xEMAFJJYmTYR2kkQh0KWJ20s4q1V1bQrplpO0o314VV4LDktHOdjSJikWm+PcHYfXQvyyzJPoB6W7DYWlCFd4zxku1sEp5sLE9yrKAm5Is8AeuOk3C1TpR//k6BbD/XH26FeLJv10TMjFmAhXD6pVp8hVY2zL5rWF8ebUv0/onqDdQRTggGVcVmneE1VLoQ3X9Bs8m1gGRukCma/HDgWWgs5pmLWljwyeF39CGkXy5tFyN3DPkQChegxnh0KHa1GH4BN1wdj0FxHC1ShdLlo9tY7Nqtgw0qDsmhXCsFVqX+hu141DI8rE6JfTa+YnYVNWeaoZg2GAanoxt3RtcvkMU7eGL+0CP5+ALDjqDO0WHJusfSoM9H/XTmJAHoM7Nt1qjvc2orQBDZxPKYHN9f3JlkyTkXwZWA/Sm3QvuCU3g3Vh0yeDk3Dlt0r3xRb23Yfn4jraM+8uhxycpEhd0NmSlCJZGhH1xckyWvDjPLTNZcCMHGWwaNy2+2iA6fcn0QkLmjLvACVUVHbeBM4yBgVXd2YpB/9Nz8QMfFX57w8MxRnJ7irhe1yNbd1Iy8+nkIHwcnt2bmyeDdcfT2nrToGeQJYNxcku8cmXeC1dhaKARQlT+Rf2irZrQABmbn37EjhQCCk4d0/hX/ODqqY5sVnvEj29l4waNwYpogps4yvMRrVhSjlyzh5myYkbDnInzEPlEr0hdH/SPTprxR73bh6tYmxsGin3vTfO0MdKbODf7Xzy978wdD9ePv7MTT82SIyKDH8qw4NjVdv8W+nVu/69g/HQwmzq3jmFCaY99rHbOWob3Vu7YRfJAaoH5GYdtX2XZPhMfNqA9+G1kOc0AHBJ8HKQizdS/eTJXfzFlW74quV+mm34DdN1V3jJPVIZPlP1qbfR40IvdX8NtNr/HRM3uBZnynvQIu4gdMVcylcxdDUbmFWGmWtm
 hWA+lOHk
 nu3npNcD9EIu9LEHaLONfT5YDzKjEJPDwk+o3fgYT609RHgl61h/9G70IujvulYwvAYyrxgGmtevu7EXf41H8lulcNl8afRYpAs9M0sNKo+i37upnOV3qFTFsI8aXVkTtQdyhiXstx9T67+N6B4l+n9q9qQjq9/Ex7gbMb7UWnni/g1F1IgcHWjPOc6IilLjFjJEt0bnlHNms3iVCx5JyAkFr8LAoCpuIHLqJ83cmpBe1laiMgVbwrUi+/JztAq30up//L7pSjtfhc3PRlQ1yibdN844CAbYCzEy7EdEXwCYJYDeWY9niaVduie2kR38t1hN1t83lVXfddm4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The compound_head() function is a hot path. For example, the zap path
calls it for every leaf page table entry.

Rewrite the helper function in a branchless manner to eliminate the risk
of CPU branch misprediction.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/page-flags.h | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 1aaa604f4b9b..16384cb6f962 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -224,25 +224,32 @@ static __always_inline bool compound_info_has_mask(void)
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
+	unsigned long mask;
+
+	if (!compound_info_has_mask()) {
+		/* Bit 0 encodes PageTail() */
+		if (info & 1)
+			return info - 1;
 
-	/* Bit 0 encodes PageTail() */
-	if (!(info & 1))
 		return (unsigned long)page;
-
-	/*
-	 * If compound_info_has_mask() is false, the rest of compound_info is
-	 * the pointer to the head page.
-	 */
-	if (!compound_info_has_mask())
-		return info - 1;
+	}
 
 	/*
 	 * If compoun_info_has_mask() is true the rest of the info encodes
 	 * the mask that converts the address of the tail page to the head page.
 	 *
 	 * No need to clear bit 0 in the mask as 'page' always has it clear.
+	 *
+	 * Let's do it in a branchless manner.
 	 */
-	return (unsigned long)page & info;
+
+	/* Non-tail: -1UL, Tail: 0 */
+	mask = (info & 1) - 1;
+
+	/* Non-tail: -1UL, Tail: info */
+	mask |= info;
+
+	return (unsigned long)page & mask;
 }
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
-- 
2.51.2


