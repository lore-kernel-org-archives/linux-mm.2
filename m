Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35D9BC88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 08:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E766B0092; Sun, 13 Sep 2026 04:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A0D6B0093; Sun, 13 Sep 2026 04:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317086B0095; Sun, 13 Sep 2026 04:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC496B0092
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:40:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 157561605E0
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:40:39 +0000 (UTC)
X-FDA: 85208092998.11.A310A56
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 89CC3180006
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:40:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SBt6q6ls;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789288837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZbLBsQvqBa0OuqffzZ60qrRN9YSSPX5HFZkA81JtLUU=;
	b=Nf6ivSsM+RCUwBPXovENOXmn/baZ57pK5F37i0hKuMVNYX7xOYR0uly4l4rj64szUMeIKT
	Z3+a0kJOYzgF3C7hXsMlAfvCA3FjESoSKlHGnAgHa3ANj2DzezFHXvwE71UDriUO51qLic
	v2PbSto0ejrjF40xu4/zNG9mvq3GVnU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789288837;
	b=CRaJhtq+BcTr0xdutpdWgBH4znK3xyC3g+NKSLzZbQfOJqZSnvUgolz10j+l4Hybkv9Ss/
	LiBxtVRvqwnWDCj5ysJZOeyPZbAcJyk2pdIU7VJPVXdq0LIS5OIUxK1nXpX4U3aX5gowVw
	VvypiGDp9WGSRaIZovYaPNwWq+H7cIE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SBt6q6ls;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-8693af0d7c4so1603036b3a.3
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 01:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789288835; x=1789893635; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZbLBsQvqBa0OuqffzZ60qrRN9YSSPX5HFZkA81JtLUU=;
        b=SBt6q6lsBNc/i8qSmdcJuZc1vipZDJyxk4QoClH0YWyBJ/s8TVGuC6JPvtpO5j5LJ8
         cRU5P1lDN2zHHIz9b0I3T9HAlIDG73tSGLInjMaG3AMCRdNtBN9Yjhq4pPhv/c5tanpS
         hPg7M235tM3OXb/V9BoFpH4Q6+9dBVn7zPUnYMAYRbj4C0zxrYYusIKRQAYpf1kJoGwz
         9d8MKxPQU+XrMhQ95JvKaIUhOer0Mm3o5BTyr3Y5iG/xm8fvbsUwDAKP0Ez55dir7lsI
         e0JWIohTPLRa6u18nYFFWfPcw/klrb3CJGoKBYi/WshFf4YwDNVcGS+Adj6tTC5ibUon
         JIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789288835; x=1789893635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZbLBsQvqBa0OuqffzZ60qrRN9YSSPX5HFZkA81JtLUU=;
        b=lq0axTETsekKXo3WLsmTdbrRQiMJ1/dMn1Siq+G5mwQ5OitrbUWk8Wl9LfnFUSIY41
         b3kn/nw7x/75HwOxeGNDXqUi5FOU3n5dPJRFK3quZBA5oz5MOmHE9ML39zOwVRX/VD2V
         L1KZdMOFVIqx+S5pNg0QnVhkit4XRykYsIwq0UY1LHpdlLI37k1FsF9tWsvqBGqw1lps
         1BVp7W3AI9bgZKni6leaRTSC3mUF8YxSHq1C/+Np/jZHcunrd5Lge8CXLNTVkBz3xKxD
         Qf+j38CT37a4XEN8AExHlo1V4SGe1GgH6ZShzKClwSF9ZVNX+BK4E0VFb8OyWB/OYXZd
         kLjg==
X-Forwarded-Encrypted: i=1; AKwUvBwQF6bQVZ7Lz+JluZcuf1zF6b8QSq9dHvJSIZ9bHuYfgshhg/4wgeHAOa55j2HkU/RsnUIWClXNYA==@kvack.org
X-Gm-Message-State: AFuF++kzvFAlntNvC0uPw4vVaWcTOoh1XutY3KQvsnvrjJToGTti53FU
	Oqvjq4zk6yRE42KwM0Eh6AoFmZOP8V1ttHIciEDxVdjvp0QCKCQRINJ8xTKuVD/CpW0=
X-Gm-Gg: AYBFou19UC5V1f3YWgEYsCey6P4g0V9CjDgmBUBg14uVJvpMmzN69gflvFsoKW8xRqB
	fUkxsj0XLZsme0AjA0SfLtDKRvFbWEHU7CG2ss2NCaXeKwK1+qpVda4vFuLv+PxI+lm073tLU/M
	itvm9dQqUEQuQPV8Sk2qJ08EhzYhbb4jOO7CJaUk4Lzq+quPsfwRqB9VO+x/WFZ/Wnn0y6wVDcX
	Q+6GPjEmz+F50DBCpS4CEcbWlk881/RknplSaQOglh4D6lbho1L+NpwU4VtPHO6mSo0Vjctn7cT
	Ns8W2AHxqRa8C1Rft2RscQQURrNHcAg0pdxM6J8Fl5ASkG2Y7uV0ZTb1PFzg0I5eIslXUeA6NM6
	zK4uv7B1qQPociAQ7fXYSd5hVny3GxsFT8q8ZyZMytT1ECXbvnTXG/0PVDrYsPIa8Xz8Qte47EO
	R2vWDNGgQ/dzNdUOtk3QKktZPNh/VIE5ZoPsB1LhBF2rZWWZKpeQXHiy3WaSGpUq6t07TLVtCVb
	luxh0pOpqLZ8IMfs5CFM+5/16QInS5EIIkn1A==
X-Received: by 2002:a05:6a00:2d9f:b0:857:72ba:ff11 with SMTP id d2e1a72fcca58-86b34f095b3mr19117087b3a.25.1789288835163;
        Sun, 13 Sep 2026 01:40:35 -0700 (PDT)
Received: from G6L4RL2QG9 ([2409:8a00:1832:cf0:5137:990:100e:cc7e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b29cbb0d3sm3070531b3a.42.2026.09.13.01.40.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 01:40:34 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH 2/6] mm/sparse-vmemmap: support device DAX in common vmemmap path
Date: Sun, 13 Sep 2026 16:37:30 +0800
Message-ID: <20260913083734.86802-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913083734.86802-1-songmuchun@bytedance.com>
References: <20260913083734.86802-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8cazeai9n9xatw6bx78z5mw6cbmdp411
X-Rspamd-Queue-Id: 89CC3180006
X-HE-Tag: 1789288836-196163
X-HE-Meta: U2FsdGVkX1+NpNzERLzKps+47KyGxFZdQFKSGm/redru6ynvoiXsf5VXe42vcofiQCg8iV0+ifMoKRMtiVBSbvao3thmhR2WoMheF7dyp8Nse9OqcmKv8igEzyqvUBh7EHgCWp+ckuYHtKNLpot924ADhWDCwNffyMAJNU/hgbiPTv+ByjhcucUi0S2QqDL4kvQiernW1tlFa9QHQn9xKMRYUEE/3qQUnwaLX6f5wBB+Lc1udGcB3OMmJGY7c0CxeAqUOyeAPQm1XcJYwqtNomwvQ5miMax+9Zzbhyt2/h+EvsvcQMokmMr/Ajl9+3kCPoXKENlLrQvLJSu2eiMRtcqCcvSCjocEJ1uLNIqEOf/X/GnsKhAtD6w9f4qy4SFKpLYKsbj9M7L6uhEQADKhSjcHbpxmfjBG6j1Rz8DqGmNQWwDekPs9d+STar8D6inihCaEtIwloEBs5D8dh4H4MiOwlkjRe5Cdica3HakP2AYzTjOZLS7pAm71JtZqnJEFcZ5niVMtwfIUVHxJ5TmEX9TL32NfQ2xRAJc4XKWo7zrK+O4PxKW/AitWmWS5c5qrjY9Ho35EQbISpEjqvqYuSzEf8gXoH1mp+Uf9LonFOuQGaDS+4HDqReJ5XTQTwn3NLeLYwoUOLSpTL99+SLWnKeoXOMrxJKuhyCjf3JtC9yaN/RQy9T6/pALQJEYS2NGMMZJpmkx56kWLtNPpkQYysR0kfa4JBiZEWBIMtRd9J4P39/eYWmSp3JJyppqO87ZX5U0V/qVT7m3KCuqV4cnIdijy1xuk646lhKFsOfWnHem0D1fhs7XdyvYkswxeQALa1+VePp5xYzl77714mXTryWPLsRh76Ao+myQ1Td8edFOFmSWakBBYVJ4xspYxDDiGb36npB2qQTLSq2q0ujBWMCSeL197yAarF1k7cZURGndKJ6a5/yOFZyM4vbelaz2NXsk++Cq6qKSGhg20fMG
 9PNwQpM4
 rJacZXFyj5QCe8ot0pcfohJujgVKrJv2zy1LykjQxkjVYpBuotELoMq+tw7tvZ8M0u41X+mEPm6/xs9k//6PbJptLtJ8F76GWnFzel428BOUgNQKBUzuPD1vo3VpnjoQH780L+gDJkCgap4NworS2/1dcTxpYD4KVM81Z1un8XO+0pOLM6AAaKVR/DOkV5gK/yJcQToaSFrqdaDSPpwZt6IHZR5YaUYWZPagwhoelIwvzUDGSlk/xxbc9T+z5aovqv1w2jnBwRJxTS0uiPv7a9i2GEqB+fRLbd3W82GVYhx4O/amIt3xJBrK1kuhesZ6u5u+E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The common vmemmap population path cannot yet handle optimized Device DAX
mappings on its own. It uses pfn_to_zone() to find the shared tail page,
but Device DAX populates its vmemmap at runtime before the ZONE_DEVICE span
is initialized.

Teach the common path to use device_zone() for runtime optimized vmemmap
population while retaining pfn_to_zone() for early boot. This allows the
same path to support both early boot mappings and Device DAX.

The backing PFN supplied by the Device DAX-specific population path is no
longer used, allowing the redundant lookup and population code to be
removed later.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 878d29a4e862..e83821768c12 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -208,18 +208,27 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 	struct page *page;
 	const unsigned int order = pfn_to_section_compound_order(pfn);
 
-	/*
-	 * Device DAX still relies on vmemmap_populate_compound_pages() for
-	 * head/first-tail allocation and tail-page reuse.
-	 */
 	if (!vmemmap_optimizable_pfn(pfn))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
-	zone = pfn_to_zone(pfn, node);
+	/*
+	 * At runtime (slab available), only ZONE_DEVICE pages trigger vmemmap
+	 * optimization, so device_zone() suffices. Note that pfn_to_zone()
+	 * cannot be used at runtime because the zone span is not set up now.
+	 */
+	zone = slab_is_available() ? device_zone(node) : pfn_to_zone(pfn, node);
 	page = vmemmap_shared_tail_page(order, zone);
 	if (!page)
 		return NULL;
 
+	/*
+	 * When a PTE entry is freed, a free_pages() call occurs. This get_page()
+	 * pairs with put_page_testzero() on the freeing path. This can only occur
+	 * when slab is available.
+	 */
+	if (slab_is_available())
+		get_page(page);
+
 	return page_address(page);
 }
 
@@ -231,27 +240,12 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
+		void *p = vmemmap_alloc_pte(pfn, node, altmap);
 
-		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap);
-
-			if (!p)
-				return NULL;
-			ptpfn = PHYS_PFN(__pa(p));
-		} else {
-			/*
-			 * When a PTE/PMD entry is freed from the init_mm
-			 * there's a free_pages() call to this page allocated
-			 * above. Thus this get_page() is paired with the
-			 * put_page_testzero() on the freeing path.
-			 * This can only called by certain ZONE_DEVICE path,
-			 * and through vmemmap_populate_compound_pages() when
-			 * slab is available.
-			 */
-			if (slab_is_available())
-				get_page(pfn_to_page(ptpfn));
-		}
-		entry = pfn_pte(ptpfn, PAGE_KERNEL);
+		if (!p)
+			return NULL;
+
+		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
 		return NULL;
-- 
2.54.0


