Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB8C260A2613
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=eOlwlcM0
Received: by kanga.kvack.org (Postfix)
	id DC1DF6B05B6; Fri, 20 Nov 2026 05:09:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72B96B05B7; Fri, 20 Nov 2026 05:09:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61A76B05B8; Fri, 20 Nov 2026 05:09:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 942186B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:09:31 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1547C80E9E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:09:31 +0000 (UTC)
X-FDA: 85455075342.29.DF9D532
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7D84620004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:09:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eOlwlcM0;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169369;
	b=v5QZI5f9Os+0qb6Np6K3RIezGLVWuYKkBgZFTthUALPR90cwwUaEQZuSc2EthfYc4QKVqr
	haOIaB3VRpSxP1qZ87UOUMfmvWgIHED3IZTyflMvE4iPFJVnUjumcdMgcLA6hOo847EEVz
	bdT7khvfSF0meL6yys1sH7HhboVo3eg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLGKyu23Muo1nOyFWHF0XtwpUfanp0noPFTk0HaDvb0=;
	b=Jk+Em5f3R/i1iTyuN4g4Sf2reLIsDtcgSumgSCDTVN0BhwgAlrB5apPLYzTD/EYCHGdEZB
	+uDX6TRkV0unTD8OepQKhL9KgeO1dcVIgLpi+T6uBKr028lQkhAn18qL7P2SZ7pu/wBRJt
	QVdrO0HMhluRg5vj7R0w08fikWrLrFw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eOlwlcM0;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b413997581so663231a91.2
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795169367; x=1795774167; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oLGKyu23Muo1nOyFWHF0XtwpUfanp0noPFTk0HaDvb0=;
        b=eOlwlcM0HH6HgQcVeOl7SXxeM+7YfxGlOmU2GnIaik/0AowJFkNjONOJ+BE51WqnUZ
         C08wJiCEBJe0flKFgSTQO2Vgi7C5Se6cpiklkslmQkQn0oFz/8rK/5+Nwb3yzdN5kuLU
         Z7AqrzkXymdmgyZ7YJ9PVXbhEBHZnlulRQT5tU+jxskY4B013PED4Yl6G9frzEmZABwd
         ZZiDiazb/5lIFuQX/y/GGaYjEikioIx+GDy8a89O41yTOVh8qXD1duHyrfMbGuvym+1h
         lZdWPhx6IamSZ1If3Ok8Dnsc9zfT2J2agh8MXp9LcFJY4Dt1vh/0HUVZ7dZvtKFoTGSV
         cTLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795169367; x=1795774167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oLGKyu23Muo1nOyFWHF0XtwpUfanp0noPFTk0HaDvb0=;
        b=NLHbMpEAKqUNifrTYEAPGgY7bAiZGk9rkRIjC9R41myx5h43GCjrqg1BL593BI4/d8
         GxUCHdXh37ouabNfix33YtAgYu/LjdWvIXna3GDzdtP1zGBFlrjvpwN9juFk/dTEb5fv
         nOWWaKWuaCJ9ONT7zbLHh1dC6XZHyXnC1TrYdW4WP9PrKgZmw3LI9BZ+g94EsFwnoqcf
         jfK8lbphUd7jPDMsREHMkNyynHAzu+GC/Fx8vKClZqA6N37nKMfNaF72YqdSqWMgfwCb
         VHyIaZC09laukUX1jiN0UmUup8SGU6S0/fflFT1gmdlzO3kB8cFvPK5xIsL1B+FDIyyk
         qOjQ==
X-Forwarded-Encrypted: i=1; AL+hErG6pAu8xQkosmqEeUCSdNrSdQQpKjH23H0dqkC14ABCRYrx+FIUfDj3qYuilfaBpGza6AtkgeHDhA==@kvack.org
X-Gm-Message-State: APuU4Z8Ya9EEUNLs58yKAPn1ukrGPTdjy6cA4Xs6VmdYZN4e1PQL8zTu
	niuZRr90HebWEKTJ4w3d6UEvQdKkkPx8QTAeHNN6mEfFCHPqEQiHXYdUvF6n1W1VVNw=
X-Gm-Gg: AZFdTZfBpWSLlKwjWJ6rG52Ta4xr60ry9pqZR/zmnL5PLfgbTiqmgc3AYaWaCbzyOJm
	3BOXcvmNSBJc8ANH0QYd9BzvgSxr9CagEKtb7x1qoRpIqjt7NVIMDqf1y5TrFIWUZK5tOjf2ES9
	mXj0QMaB2Y7Eig+x9NRQ0k6guhvGIY8xJ8mCuntrWVyB3Gl5OaRLpJSTd00wtULMkSYqMnGG5Va
	FrFYgJfzQ59Mc/liHkyTcC4RNAogoL99Uvzho4iG0rSVIDzL1lTeIT5c+Ru88SQYPa0m9Zm2cXX
	G/u7nYBN1CEoW2zkEXo2CIcKmtpmzUgUIqufSBWYW3qWUozpWnHG/rnrSb3JFKBGNiRzAvbevNG
	Cra1YpD0J+kr/hwI4T7XeOdUMJP+PTLrrLBrXOfEBWV/OSvFVuPBm9KMShSBOZ9/IhCsZakmYlB
	m0j9ssDWB+t0ndpFmPSBWTIxX6tzysIqIrKK/Mw9G4ucpJg0eQhc7+LjHd//1mZi7ISgeXaWfuA
	3VfNvet9kvc9/5rVhH7YpEvXGcKQVre8vsqRTaEFz8JKTy/zfsWYwoj7AgaoAOqWwVkaaNyPqkz
	lpMSlqwXuZ3sb1hQ4OHeINAqcXrSvDn39mONYY2fpfBflNVTk+Aa2bTHrdYSrJCh3c/Ou1g93MH
	IBJAEhNUEfwvYfH0=
X-Received: by 2002:a17:90b:2ecb:b0:3ac:8446:c1a5 with SMTP id 98e67ed59e1d1-3b41c988620mr2221952a91.48.1795169367038;
        Fri, 20 Nov 2026 02:09:27 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm3727321a91.17.2026.11.20.02.09.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:09:26 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 02/11] mm/mm_init: factor out common struct page initialization
Date: Fri, 20 Nov 2026 18:08:47 +0800
Message-ID: <20261120100856.16929-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120100856.16929-1-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4rujr6p4ny5u8dqn7peg8j8qgaioh5bu
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7D84620004
X-HE-Tag: 1795169368-897028
X-HE-Meta: U2FsdGVkX1+mb0XLVls07NmkR9Qh3MlpyLYNDxBDrlGaIXTp/Zfumatq93/6tt6ACz2OFbaGHTDfNEDxmbmT16/02IBgN3VqrQKGUr6iHDCj9W7Tra1fe/TH2WbKDRWBum9hWk/+JoNNhe9Ui8K3Zd72r+jC9EtSm0XXAFeZv2wSNqs25LpO87awMSMKCaRnKk8FeV4ezT5Mc5apBUgKHP4EEklP46qdYby+RdsVDclANu5qGhnXEvmU/PQDq37z3FrAjvZId5YPsI7mb+7n39R3GV6QG72r1oQwwDrKInTTmF+93SGAbnzp3GZERaYasdoTl+QG4nC++YiVBXD7lIp7G+Q3Y9zQhy0/yr+8VN3XVtIaCTVQrFH55V6lLyYh+RAYhEidE9qGgSRtheBFrXuzTzRovs5zZvScScyeZpwzJrkA8A0m8A1vU/KkS8IauKuL20cg1bf1XB8xHRS4CawGlc8dC5NQM/yAHqt3YCDRxQM7p4p3YIf9IqAM4MbGE1gEpSbaYwsJ+EHC0EpKBDEmbCFA8npXVXi0i0PCaheWdVytwHD+jG6YQEwjDvAEk3ts5cIkaFkVnJLGJbI5+/Z3SE1820y+3pKxQsjtprvXV8apzAHwDNwKj2AZCuLR9c/Yv0TZJmGnxIPlWlnsz4nSzQBWKXFmU4R0/n+/KOlr58p9XQ1g2O5UUM+L80SiiQe2LIMiEqTZjL5IotL83l0/PMrksoAUuGETie9bYquZLN5fLM4io3JkxD/UGwmIcp/GTnN9De074QugI6mMT8EOVXWiYgqEnLM9vIjToKDGcamZED2Jn2/5EygEFrF1wtJpU8W6LaBFgw6llwBFqjsuDHAf7dcF7WENDLjviYABpONkBUhZuke4NKyaZEIck3V2cW1Ro+AU8Ml7dq3LLvv5HEf8yzbfd+ySKWqf+NQmqwX05yFAg8QNhDTtMQ0lX9hOxrJuk6xR1evTL0F
 xmtxKIOP
 eSPvzbt6zGj8GfaAWtwsT3e25j/JCmJnym5ZtnV/g36DDHuTfgmj31O1WWgWo5WjA6SFCOUUrCNGh6PtIk4XeJwV+GvYfJg5xgvMaSjmNvYWaj3WYbYuJQXBCakBy3E5kXa5efEmSjE4rHIgCFl7oXs2GL4VSDsGNpkEFdK7ZsDdH5J7Qb2jK072uMeYrIjFI7vWLJTkipmjWolAVr+Lzeops5SHnix6owu/RwtV/SUCRufWMseZy098ExZOKDVTXaejb7wRfebiiQ9lCRuBDX30uZtCRGnjkRKbNNgeGzDqJZQOu72FDCF86P7kpl2Fo7BYLoSsOsFAtDjSH/sD5RBhROQbwkbEewzbnZateuniaF/+2mA2QX8TBD8ERhR9SmFvkLm77xrB65OFL+77vn+DQCV8Lcx44GBwciXUYg0YLnfsniMRxJd7gLi5A1cEhaR1BLUSnLnq4nnr+cHlc+UuMH4hdfvoJ92AWXSNGyVp10GjoSQxbWJ0j0g/6a0me7xVzYqKvb9gRI5HWwKUDGVOTL8QUFSGBwQOk+c2y3ZeUi72tAgaL/x8DCTHCWSxUQgG7YNEE0RRA8i8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Several struct page fields have the same initial values for every page in
a zone. __init_single_page() initializes this state as part of its
per-page setup, while the shared vmemmap tail path open-codes only a
subset.

Factor the PFN-independent state into memmap_init_page() and use it for
both regular and shared tail struct pages. Keep section-, PFN- and
instance-specific initialization in __init_single_page().

This also initializes the last cpupid and KASAN tag for shared tail
struct pages consistently with regular struct pages. Since
memmap_init_page() marks ZONE_DEVICE pages reserved, remove the redundant
update from the memory hotplug path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v3:
- Rename memmap_init_page_common() to memmap_init_page() (suggested by
  Mike Rapoport)
- Remove redundant ZONE_DEVICE reserved-page initialization (suggested by
  Mike Rapoport)

v2:
- Remove __meminit from memmap_init_page_common() so HVO shared tail
  pages can call it after init text is freed (reported by Sashiko).
---
 include/linux/mm.h  |  8 --------
 mm/mm_init.c        | 37 +++++++++++++++++++++----------------
 mm/mm_init.h        |  1 +
 mm/sparse-vmemmap.c |  7 +------
 4 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8883b780b76d..d8bafcd92791 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3096,14 +3096,6 @@ static inline void set_page_node(struct page *page, unsigned long node)
 	page->flags.f |= (node & NODES_MASK) << NODES_PGSHIFT;
 }
 
-static inline void set_page_links(struct page *page, enum zone_type zone,
-	unsigned long node, unsigned long pfn)
-{
-	set_page_zone(page, zone);
-	set_page_node(page, node);
-	set_page_section_from_pfn(page, pfn);
-}
-
 /**
  * folio_nr_pages - The number of pages in the folio.
  * @folio: The folio.
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0129152b74d8..08d6e47bde22 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -602,15 +602,27 @@ static inline void vmemmap_optimization_verify_zone(struct page *page)
 			page_zone_id(page));
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid)
+/* Initialize PFN-independent fields common to pages in the same zone. */
+void memmap_init_page(struct page *page, enum zone_type zone, int nid)
 {
 	mm_zero_struct_page(page);
-	set_page_links(page, zone, nid, pfn);
-	init_page_count(page);
-	atomic_set(&page->_mapcount, -1);
+	set_page_zone(page, zone);
+	set_page_node(page, nid);
 	page_cpupid_reset_last(page);
 	page_kasan_tag_reset(page);
+	atomic_set(&page->_mapcount, -1);
+#ifdef CONFIG_ZONE_DEVICE
+	if (zone == ZONE_DEVICE)
+		__SetPageReserved(page);
+#endif
+}
+
+void __meminit __init_single_page(struct page *page, unsigned long pfn,
+		unsigned long zone, int nid)
+{
+	memmap_init_page(page, zone, nid);
+	set_page_section_from_pfn(page, pfn);
+	init_page_count(page);
 
 	INIT_LIST_HEAD(&page->lru);
 #ifdef WANT_PAGE_VIRTUAL
@@ -891,11 +903,11 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 {
 	unsigned long pfn, end_pfn = start_pfn + size;
 	struct page *page;
+	const struct zone *z = &NODE_DATA(nid)->node_zones[zone];
 
 	if (highest_memmap_pfn < end_pfn - 1)
 		highest_memmap_pfn = end_pfn - 1;
 
-#ifdef CONFIG_ZONE_DEVICE
 	/*
 	 * Honor reservation requested by the driver for this ZONE_DEVICE
 	 * memory. We limit the total number of pages to initialize to just
@@ -903,7 +915,7 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 	 * ZONE_DEVICE page initialization until after we have released
 	 * the hotplug lock.
 	 */
-	if (zone == ZONE_DEVICE) {
+	if (zone_is_zone_device(z)) {
 		if (!altmap)
 			return;
 
@@ -911,7 +923,6 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 			start_pfn += altmap->reserve;
 		end_pfn = altmap->base_pfn + vmem_altmap_offset(altmap);
 	}
-#endif
 
 	for (pfn = start_pfn; pfn < end_pfn; ) {
 		const unsigned int order = pfn_to_section_compound_order(pfn);
@@ -938,14 +949,8 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 
 		page = pfn_to_page(pfn);
 		__init_single_page(page, pfn, zone, nid);
-		if (context == MEMINIT_HOTPLUG) {
-#ifdef CONFIG_ZONE_DEVICE
-			if (zone == ZONE_DEVICE)
-				__SetPageReserved(page);
-			else
-#endif
-				__SetPageOffline(page);
-		}
+		if (context == MEMINIT_HOTPLUG && !zone_is_zone_device(z))
+			__SetPageOffline(page);
 
 		if (pageblock_aligned(pfn))
 			cond_resched();
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 0034e37dbabd..dec22844f41e 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -109,6 +109,7 @@ extern bool mirrored_kernelcore;
 bool memblock_has_mirror(void);
 void memblock_free_all(void);
 
+void memmap_init_page(struct page *page, enum zone_type zone, int nid);
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 9b80dd7326f7..51fa77982ca5 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -212,12 +212,7 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 
 	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
 		page = (struct page *)addr + i;
-		mm_zero_struct_page(page);
-		atomic_set(&page->_mapcount, -1);
-		set_page_node(page, zone_to_nid(zone));
-		set_page_zone(page, zone_idx(zone));
-		if (zone_is_zone_device(zone))
-			__SetPageReserved(page);
+		memmap_init_page(page, zone_idx(zone), zone_to_nid(zone));
 		prep_compound_tail(page, NULL, order);
 	}
 
-- 
2.54.0


