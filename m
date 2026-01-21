Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5585FC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684056B0098; Wed, 21 Jan 2026 11:23:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6273C6B0099; Wed, 21 Jan 2026 11:23:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516F26B009B; Wed, 21 Jan 2026 11:23:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C48F6B0098
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:23:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 901BF140737
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:16 +0000 (UTC)
X-FDA: 84356490792.04.224E2EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6ACF540016
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t6ynnu5K;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fm9xXALuHU6bGoBgFuHRcDLgwrXxgQ11ucLaprSV8OY=;
	b=GxRkVBXQa8j2RP8/+ZW6pE+XBboaZyr+HXvnh/gqFHEVxYgy+2Z5+J2YIxiRvBU5ItudDn
	ISqSiUIYLIzR07eFoMar67Hm2z+1xLMPCMQxNqReFyYBXvJ3c/RO77+WyOefQHHGKkikoL
	u0SLA6tPR+5ipVExSmSYyYdmXkAWfBc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t6ynnu5K;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769012593; a=rsa-sha256;
	cv=none;
	b=iDzN4+lKt6mxGXL5Cu7UEYY47CMjprVYh7S4MC6BCt8MQWv0s5XG5MRsCAwt/c6+NmBodL
	sx0YVugIpBck5/hqeVlc7/aUoC9zB9FB9l12ZQPsmbxdlbPsQ+WTMgidWBsSkVP3RRICkK
	0Fel0id0hKQR8GmO5so1inoEOyXStBo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98E3244352;
	Wed, 21 Jan 2026 16:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4ECC19421;
	Wed, 21 Jan 2026 16:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012592;
	bh=O96ch8fRog/gbFpgMz6eS5fD/+jtpBs4wHGNLJ/2IQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6ynnu5KcYfiTiKByn5aKPM/KrxY3Mjnr5IfqrW02AkMYI8pyQ7qy2p12o7vvMTAq
	 ekh3X4S/L4GAi1FtV50tI2WVrZv75YHkEbMV3LZJo9B5UgbJSZ0dyiDVpMfUrIf6CJ
	 +LTszXpgJpdYlrPy4oZvOyelbVZlo2ZDKoN67j0uQcg0jGLxOn0apVugad6s8M2cvo
	 UAfC60+cZzVxbmI53uSRhA5EPx2ZB4imA6z9THaKJ7l8GBZhuKXd6ArYPS6z4eSdrK
	 cuq1+A/OXpFFzlr+e5PTY0pDLAHmKW31ZqoITNoDT8LmW/C7QUmd+IQyTUocywLaiO
	 WkW7lSUpBwQ+w==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3C1A3F4006B;
	Wed, 21 Jan 2026 11:23:11 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 21 Jan 2026 11:23:11 -0500
X-ME-Sender: <xms:b_1waUgNdyt_hrEKOO8N1Ezsw0Mxcjj9jv0olG7LNPtx4sGqs7hQsQ>
    <xme:b_1wacSPtUoVKIiBIEPKfGW1-glC9hvVaK9HDcH4Vsva3oocCbqIdSa03Tp8YfbMP
    qwbJJRJbQox4qtenhtu06yU_h2MWf8UBTqFdfO6aemHUh00vLj90w>
X-ME-Received: <xmr:b_1wae5Ch4m0R2sOBYO0KjKA2uckhpt06YLcOE79PwLLMg2yPb8wC6AD7xNzNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeefjeehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:b_1wacwq86hwmmMXdWwsgRCfXY4UKrmPeQp5OMihHayQ2dvhvzs03A>
    <xmx:b_1waWDJWPeJqlf1CNZfPc1olJfd6riFp69Ek9y_wZFMVLhQjp0rdg>
    <xmx:b_1wacZMPdbasQfsGbR7z2V1onT4nQqWi3arQec1BPe0qQrrRge_iQ>
    <xmx:b_1waVF7r84uQoE1GmaCZV_307C6jcnfbVY-ZUuXRvGFazgr4sdp5A>
    <xmx:b_1waYsxoenm0iNnV3ewZDeHCvyfYZH85VqTJ1XfUdDUhHjR3vO8OalF>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 11:23:10 -0500 (EST)
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
Subject: [PATCHv4 07/14] mm/sparse: Check memmap alignment for compound_info_has_mask()
Date: Wed, 21 Jan 2026 16:22:44 +0000
Message-ID: <20260121162253.2216580-8-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7dsn7igkeymfe3cfe66ququ5gffe1js7
X-Rspam-User: 
X-Rspamd-Queue-Id: 6ACF540016
X-Rspamd-Server: rspam10
X-HE-Tag: 1769012593-577385
X-HE-Meta: U2FsdGVkX18XfgyElvxvHqajRb3QqURJZjtXB7h0UvUD6DW1TCl20iWXPPgw1HT8NnN8rQt+y476GD1MlMst5JyblpjqWAc3Zlm04i5u8ngR0fcCrSzo5p/dH5W/1qX8JIYG40+yZHFNi+un6i+n1YDY1fLgK1pnarFnT7RTXe43LXp48jSVjAXbWx9jSUqkX1TcgQI4db1BB2o5N2EJUKolclpwEzmMmJZJnLqUdKIdf9n0n4ST7u9cu8ykdC5LJIsllbvP2OiUdbE8O9ZdtI3ZyvYJJsFCP3gQ6/kSMPG0HnCO4quj4wn9hI15ex0UfxPNzhwYf2zznecsvdooygdEHXFr9ve0QWmzOIg6ROi71eMxdQ0CZssjFJAM+gNsaRvz81agrKpFMm5UegPIfr68ZKqmvk1deQZt+6NyrNeLNDMEdusTED481ANQQMdA9h0oe8sHLA7EdX6DduueKRP0U9p4/IICOOZTzH6HQZOZCRLRa0Crg8I0DGwnHVf+/rAW3vYIY1T+uUHhg1KwlXmUA6Ufx0EyvE/T+LE5dRvtkjWfZSN0dprViO9XLt87qam24Wl+HMCXNpqRT8O0e/vUdwUiTQC/n58WJzIoTXVHqZBJ5mnAXtc5Gd858Q4jrJq3QOJ8n9RWKVEpYvAHa6rB/ZH4yxSejmkgETwOFNhwkRZfi656RAofg9PPLYr2iQgC9lW5nq2AmjtA1o0UF7Rlsp/z5qah+gz807MFT/JsiajIGR66JeIhEElzvgabeJb34s33OEkTyRxXOEj/cw/drJKRrxcfc0aer1G7lMY1nL4c9cAzn0+y9LkDSPFC8iOfpisLR1tP6OIz9+lv/E5UHBkWPx+XJKIIdub9ASi32FHHKnOa3VcmrPok6eJ6SjNCZrz5GP4pNT3/P796VRfCMcdZ+S9DMF6GESmp4VjRGogZPkWCVTckd7DIyA8SFvNwuTFGSnc775UelTG
 ZsO5I4n+
 qWlghK4//OSGDm+dLG4zXJwNrIIg+07Eh8KUpXZVGw++QzHfges5sfMZqCc42aPr9gW+xMV96OwcM0FOGJn8TZZjSCdE+SW0Ec0SXDN+SMLYmlCXgMBCJ0lGm/nLGM4RPpmNJBOAEIlOoj1Wb7YgDvzAG/m7ZpV7eznreGxbC5wyPXvUaA9kzg4cTvP+8xUx35crjkA7VYBKFobSyVKL4/l7H3nGsPa6bd8eNrjTPFjzduBMor2qdvJZCoZz66gVHi3G2NYOCMhOZkrKVOh3GhILGnEA1nDI8Tt3bwtIRgw70fdcSL8L/59pI4odVlFEu5zRWR1NSB3zwoP6m6n/prAwwMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If page->compound_info encodes a mask, it is expected that memmap to be
naturally aligned to the maximum folio size.

Add a warning if it is not.

A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
kernel is still likely to be functional if this strict check fails.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/mmzone.h | 1 +
 mm/sparse.c            | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 390ce11b3765..7e4f69b9d760 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -91,6 +91,7 @@
 #endif
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
+#define MAX_FOLIO_SIZE		(PAGE_SIZE << MAX_FOLIO_ORDER)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
diff --git a/mm/sparse.c b/mm/sparse.c
index 17c50a6415c2..5f41a3edcc24 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -600,6 +600,11 @@ void __init sparse_init(void)
 	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
+	if (compound_info_has_mask()) {
+		WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
+				    MAX_FOLIO_SIZE / sizeof(struct page)));
+	}
+
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
-- 
2.51.2


