Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0E28D2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544B56B0302; Mon, 19 Jan 2026 18:03:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5056E6B0324; Mon, 19 Jan 2026 18:03:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1056B0326; Mon, 19 Jan 2026 18:03:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2902F6B0302
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:03:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA42457F6F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:21 +0000 (UTC)
X-FDA: 84350241402.18.EC70F3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3852B1A000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NFA8vN+u;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrSJ5eBE4kEtV/yKoYhFmv3L/LPoAuA8a/am5suflj0=;
	b=kXIih2IDMEUdpW17FhAloP9GixIGymWSa65mGppI6nTUzvnIlnW0TIl5QKproGST1kPjDp
	MrEbi6dcDxsRn62B8fEL459NXXxHAyDI0CSp8OOzT2m5hSochrem8dFUMNr1L14sBFlCHR
	gZXCxrFg24wVrtsKcZjhcMZxa0VDCOk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NFA8vN+u;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863800; a=rsa-sha256;
	cv=none;
	b=G1V0WVIA36JAF/Sjxb3HjIOHomKurSOfXMTBF0jdcW03HhqCbs2aBEmFiOy5YwoSEHZWKh
	6LaBI1MY5NtN+ZHFPaPtnA1vuo0roNuPJdHnm2IN7nUSNwxN9CKELQgOX9uxLUVAkBhtSr
	5YOahY50F+buWzsKJtqwlEV5IUb5tIM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 612DE4431E;
	Mon, 19 Jan 2026 23:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5E1C19423;
	Mon, 19 Jan 2026 23:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863799;
	bh=hAWBq8N2XzK189AInPRuJ5pazUVvYkJ/XMbZxTDq6Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFA8vN+uYHR1P2fcxt6dMoEyzFf4LfnUtoYyt9jx8oJu4wPKt6rnUGaOTyEZYUT6H
	 dwRMcM3AoTHnOBj7Y7SeG8+dLb70NLGg6HzZVhlzoAopdTAJL5pwYzJCUst4v5Nryg
	 LUAQfpNqqCc2x/VlxAiNNMB/3Eg1QT/Tp5j+5Itm9maLATp737NmUvp96+XTGqU5WW
	 SUmW/x5bmEkWKMAH6dTnU9DSZfEc83G8WzB/PDYui+mc+2Bww/LK/PRCNT6Qzfu/dg
	 0n/5PvsszAJAl61QvjQpjJcfl3ka2RgTgd29liaO1naJSGx2w/SbzGWfP2kTIAK5Vu
	 lvGnoxIaRtZwg==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 14/24] mm/balloon_compaction: fold balloon_mapping_gfp_mask() into balloon_page_alloc()
Date: Tue, 20 Jan 2026 00:01:22 +0100
Message-ID: <20260119230133.3551867-15-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c3hp3i1otikwnfa1skdsd5adjd6rfym6
X-Rspam-User: 
X-Rspamd-Queue-Id: 3852B1A000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768863800-93686
X-HE-Meta: U2FsdGVkX19DgK+1h2R32oQOm/hxMmU/FEkdvU3bq7uvpHsKD7YQg51qE5/sUAofEvQ+xVzsF7/OUWvZ2gWDnBoVSMkvjMnmrFbo2T/4hLe1H5RDIgukgeKC7mysDYv7hHV3cuZmOto1EvQDYV8vCWLALMB+1GgZhTWtAN5gwTCvEFmfMUiE1q4wSbN/zrslxGP1TZotVOzWpBee6kFhEzQQ9QZQzIgpfoGqFRsEAkfkOQ0XXYluk+BAabLLVgOjh01i1iHYi1DcSX+R0RRMUMTl5FgQ7pss/LCBqC/OJOudFmVbyVrN1c+HAjsrmuZJ5U7sWRR29dnQC+FtAVj7OWVBTzg+nDNWkIjdNCUiRCSMv0tpK86vF/siRfqtKlUNLLWuSheDou3nlQgW+9+jKFFavneey+hmqbE75oGGvfXechPTCbtSYGRkZ6xQ5URc4+i/Zn6HHyp1EL8lDfbNzYv5NoLkvJD/63z1hsPes7EILtHoWYp0VOiQfQfNtxBYKH781WV2wIivfgPsb1RupdkikhvcmTI0Pm7jzex+nWmIEJVyXKdsybe/RKP3arGYXtr0NaRiWF4EyQk1UtMD3O0XDhSrpcRruH9D3tL10jdOTeT2HD5oyEOE9p8/eXNevzxZW6sfVx0FGvUyUc4voHKSR0L8Lt3tCX8xHA/Mc56WgM5+MitG9wQHk6NVKeXFv6x+/ZYSs3eKXrdkXXGfEwpR2mzC3bboMF3Oc240kD+w9CclwEjjbxj2lk4aGu/HGk/Gcc0//2Fw07tMUvtyQwz9K4E3wjCY+WUqcqG0pObPmImsXuSZmKTa1rpr2npdOi1ks/09Yv07mLqc6oD6oFU6ESaBp6nZ/RxOTXCiNuh1CUDr9rzQPxQNLfsrqRU8TLhpGcIfaLWRAeoW6oHARYqtjrRepHtbZeSD3mnZqKDcv6BE66jw+hiPbpi3f0TTe2wfcKrPRbnKWpNzUA2
 gbQbuVmF
 2N75ZBEYuf64HD8PCF3PYibI01c6kzTfohe7bXZ6ToPxGyPNfDs4Em1bDLF+dM2vlJPLNAVOrwKygQWFhQYdw1l93cabfCatob0uKKGJMB3v42vYsPNCsNhZXFdsziiy93HAV5brdmKkqtoRqyCdlO8a2qxTuTE63jmEpQ/1QfqEmVpyxlOjnoe6limWxwglAFjGXDo5oZy+GW9dQl2oEirxePcWiQoQ/T8swNNPq0ZnbkyrAG2VqQpczGC9Zy1dIyWtjNw5vgNcaNTynulShTzuO3X8aQjwOMyCqJt5NqKAyGaMjgHqnpqi8WrQ4CFMYk9kVKTTmrDgxL6U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's just remove balloon_mapping_gfp_mask().

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h |  7 -------
 mm/balloon_compaction.c            | 12 ++++++++----
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index e5451cf1f6589..d1d4739398978 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -106,13 +106,6 @@ static inline void balloon_page_insert(struct balloon_dev_info *balloon,
 	list_add(&page->lru, &balloon->pages);
 }
 
-static inline gfp_t balloon_mapping_gfp_mask(void)
-{
-	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
-		return GFP_HIGHUSER_MOVABLE;
-	return GFP_HIGHUSER;
-}
-
 /*
  * balloon_page_finalize - prepare a balloon page that was removed from the
  *			   balloon list for release to the page allocator
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 5e1507a13a52f..1843e168db3ca 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -112,10 +112,14 @@ EXPORT_SYMBOL_GPL(balloon_page_list_dequeue);
  */
 struct page *balloon_page_alloc(void)
 {
-	struct page *page = alloc_page(balloon_mapping_gfp_mask() |
-				       __GFP_NOMEMALLOC | __GFP_NORETRY |
-				       __GFP_NOWARN);
-	return page;
+	gfp_t gfp_flags = __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
+
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+		gfp_flags |= GFP_HIGHUSER_MOVABLE;
+	else
+		gfp_flags |= GFP_HIGHUSER;
+
+	return alloc_page(gfp_flags);
 }
 EXPORT_SYMBOL_GPL(balloon_page_alloc);
 
-- 
2.52.0


