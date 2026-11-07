Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41A0606A334
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=lyUabmcT
Received: by kanga.kvack.org (Postfix)
	id 18C876B05C5; Fri,  6 Nov 2026 21:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13DBD6B05C6; Fri,  6 Nov 2026 21:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053396B05C7; Fri,  6 Nov 2026 21:30:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A44EC6B05C5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:30:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 275C7A74FD
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:30:26 +0000 (UTC)
X-FDA: 85406744052.17.594E156
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B22A120005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:30:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lyUabmcT;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTp1i9BduYTpsMZ/IMpoCtzJTxHjxTbrJBkyfID/DQw=;
	b=RVTIoLFMCyAhKNCpwX5LJqXOzQCIgmOAE84mPMRqv9mVGKKXm/mRcAryntWQmrBK9A7FIz
	i4+VaGlSOCEqDdVqY4OK0kA7X8JYeIck6wuBX3U+ScDdxHQ1PqBn1lgNJqLy20IDaRcHxJ
	skNV9Yo6D5pmpRL8ELKLOZRE5VtU11A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lyUabmcT;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018624;
	b=QpcTX840Rq5LF2Ls7Hr6DfccLt3dl/eI9FwKUtjmMVlnS7D1o+G4xu4HPOi/AEv2pMt1tM
	Jnu/9impkt1NNC1l+gkAVHaDVQBOPVeVyUYFWQZm8PdNcAu7G/TI1qNX9AzZCmI8HpeX/m
	DHEbtF2cJlaNbw5N5pP+uM9w194sfVo=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-370a1bc464cso1171511eec.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018623; x=1794623423; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GTp1i9BduYTpsMZ/IMpoCtzJTxHjxTbrJBkyfID/DQw=;
        b=lyUabmcTid96z1AZoXVyFMPqKRUju4cguREC62Ztt022S+4JF2nGQFmaRKYB8TUaoa
         RxmLwpG1UkQg2xnR8v21NPC/QrNcsGSLoywZCBzeSnvJ6Tp/9GiXcxcP6VZ40N9J7FJl
         AcARnP/miepoO0p7aYV7gQvwUo3vHxgtIpo39Wd8Cs97a+Zw7D5VuHRDyJKQnOKb8DV7
         9lnKZ3UKqaJ8PpBhURV3tz3oenlHbFAUaGfPsGpuOxV8b8I+h4nTMACFS4HJLvtbK10h
         YCXefNnUTvvqyIuueY4ueJJ0NYmepl47W0KyhfdjCUHXXiyBG9qfeZIQ9Xh0HouMPrIf
         zZ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018623; x=1794623423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GTp1i9BduYTpsMZ/IMpoCtzJTxHjxTbrJBkyfID/DQw=;
        b=B2HzJwUh7MlAX7VYIiFCWAMcpdugTzpXw6RPyL1m7dKpqYXurnCABd3LAwD+90qIwV
         boG7n23mlgjmNEJOfp9Tkp5dgDwITLAAfQPLWT1I2RtrMJEzRco9Te+w1PwBTSPvTawB
         enmxropBCNP18DMq9FhkIYixMKNeuE0hdvNarx3AXWs/rImVigP88MsaOhq+rQ1HIpTm
         d+hXLIIwZua7epuGJ/lZqzbCTj3hbOFjSz6PWQzpWIrOaT60k/EFtDUK1RttWDBLnKnQ
         4nBjSXvnH8Lg+n1Exlh/8UrIFbrqM5y4mzdRcwjm539XlzDCl+ow01YmdqdTP4kEo1ux
         x8zw==
X-Forwarded-Encrypted: i=1; AL+hErHnK/G3WubohE7RliojKU9qE7qJwZ37hkMiE9W6URIvq2pdQLibFKJeDBPHXORnKah0AGsdwFqRSA==@kvack.org
X-Gm-Message-State: APuU4Z/S/VyoMPnufh0SeV6UGg1CA08FyKr4Sn797oQVGGWgrzohyaa5
	bP9nUbo1xJQIug6ptB+D6sUUjp/ZyyNyBLB5Ryhpn4yR9b/bV6p9uEjTI5LSle1IuO4=
X-Gm-Gg: AYBFou1yOx6SgdUYsOtb1mFi6wJt8GsoFHZSuZ2Ya6xKMywNGtF3SeWed36eHJu/FZH
	43xA1kCHqLitj86iXvzjnhG129fJ7xUYyBr2RIqeWVfX5edLY6NRdxWyP8+lTFiuuG5NpUsyUoQ
	f0mfXUzqAvupeNHfbwvALxuy8VnKdg9sI0Htx2R3w3HGnh8pYDRHS6VokbeBbfye/ISSSJQn42/
	Y3/dnZXgR2vIuBR0/HlE0Cw9ON7404W3Rely/g+Uav9/3XDs/nEwMqL/PDLZO+F/4qmDrTfFrFL
	Q7BBDsNoFuwOuRkElhKFpd+MRwR16rI3jSqJkfnTdqpHxJ8zCIiG0lzBlDJ51Uszo5BsCgTDmpJ
	KHu9cG/2l3mZQrVOLjfyxNwwT/8wEk3mkAYesNFJzJ3p0FdsQujAhva09i5n4cQm4fdSksATi6z
	0EvFoHth0o5sM0I+nqCPMtKs7V3p7BB6/FYskKzIqQe7lCAxOxYkAFJmnBQd89O1HC0YDuY54aE
	BeNtum1MbF4h1X4ybSsQy9K1tRJQE+ggZ8M19QXrewpPZSkLiIXpV25j/4DYbc2VUHTr7DJ87b7
	a1ZZ6Xv9W4bFfIMKpTV7CMgmsh6KdKATLlGravGei47Gdab9eL/xHT37nQby
X-Received: by 2002:a05:7300:f195:b0:369:f420:8679 with SMTP id 5a478bee46e88-36f784c065cmr8122187eec.38.1794018623000;
        Fri, 06 Nov 2026 18:30:23 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.30.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:30:22 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 13/13] mm: hugetlb_vmemmap: make vmemmap PTE conversion folio-oriented
Date: Sat,  7 Nov 2026 10:27:56 +0800
Message-ID: <20261107022756.77731-14-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5B22A120005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1go9s1reognp1thtwqzde3sfh6juwc8a
X-HE-Tag: 1794018624-512168
X-HE-Meta: U2FsdGVkX18zgETeuJBp4dW7KpvBojTXoRV8OrUMy+RSsq2UWxAECgBtaGXXZfARfTX3jvgdTQcc0wtWAqhqws+uMRSAv6mgEe83fxv3KoBcX2iB7UOTOu3netBkxe5ZS6Dv5jmXw4jcwW4n4k5sMPYovnRHZZeVneZHOJew6tB09eAQvl9qwbUK2IHID4RLiOEbmtMKW2r4FBO05sA+gsFlShvCUIu+Mg9RlxCBuujXdrn94ipVAaWMIFxH8Hjcm9t3lO6mtWiLnct+ncrFOXZjSHq+QIcQnEkVLbTMEtJgcAtPa/9P2W2rQ0w9PN1uPx5AVu4t5DG2Qp4pf0dtBnBWkVwyazTFMN2+ZAg3baPK3X4KDnJHczqY6PybVVcPVBgF9vJiqzRhxRpCpxsO1cmy+vhv258u3P4q0zZPZDxbUtuAP/NBx2VePikVboWzrSiHBWX+6BTfTBIRo9o3+yXRh1KcgXDCs4GaXbRTOzCUBPSESjyEJtowc2LEQJFv70HfkqWdPeZV4Ts/l6QrdY9K1PSo+w+7vnn3cHD3P5O9+mRf4lwb515U3TrXRxgFlyJ+VCFymxV9i+jDNdxf4dX6ICyjnRgiKQf7GNzv6hRV2J3g/A3gARpa0bDUPWImoY+YIvZivLreRWkJ0qT6DjdOPrARVLVEa0E6YjYD3z20HTWa0B985WhdDfU5tUkPKfFKFzSqyx98Vr8HpTHO6Z2IOHj8UtpLAsW4RdvN0nk5PdXUSCa37Lt2CFgyktMSPBEQS5DPlSqqf9Tfyh2/I0Q9A0Xn7qPhvMe91RT2HmhCei0uXeuE3TMbyDkFDsEK5m6q9ICBrnUVY4U8S+5QK8Aev1gGg3tzMtnxoQplJ5oAcuE/c8CsXyTzTlyXIcBXEpNkxZvhgZDQbosxiEz9LjNYmMk7ZdtxR7jJfCNIrJJsiKVnUeR0dmJDGktsxrHrj1cHYu179UsONYPqfix
 U3DdIl0N
 h14cvOPiHAnaLRgZongOeDwqIzG8MXt0cHHOAgW+hY+iwEC8i2MgtYb+HM76kKVEJWqSv9ih7tDN4ytLYoqR4i+kNhZ7yKmk8D/QfTCh/Sp06nccWAtp5i7Yvc12dBDSEN2xXdWMjAn0nfw2WOOdQnmSaez3olXfMjXfipjHiUjg/HN3qvpGMy4fuwaZqzH7QYm493qtCeojZBUC9uUjAUm2b0OKuXESY/K9/P+gzphgEDx/c7muHJmGoqWrL73ivNoUCrRIHVvrDGIgdo66U5rFdKpiDaiZ+TFN6WxfpcZwNa41hEqCzjaJwLNAgYVE/UR+azSIld51SqS7Ru5HDGWk0phXCyPfNJ23FThAO3N9m5KNhuFm0aZw869K93q93sXst6mssSRS+QfA0URvwxYY81+UAQ4S8NMKBIKKAzXxKEBqXH/Sl9DXf5x8QMArlTjsM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Converting a folio's vmemmap mappings from PMDs to PTEs is a per-folio
operation, but the current interface exposes a raw address range and
hardcodes deferred TLB flushing.  This splits the common mechanism
across layers and couples it to the HugeTLB batching policy.

Make the folio the unit of PTE conversion and let callers select the TLB
flush policy through the folio-oriented interface.  This keeps
HugeTLB-specific eligibility and batching outside the common operation.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
v4:
- Remove the redundant order check from vmemmap_pteify_folio()
  (suggested by Oscar Salvador)
- Collect Reviewed-by from Oscar Salvador
- Collect Tested-by from Andrew Morton

v3:
- Use two tabs for the new wrapper parameter continuation (suggested by
  Mike Rapoport)
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index b8c10671d53b..ba8e11e399b2 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -300,19 +300,22 @@ static inline int vmemmap_restore_range(unsigned long start, unsigned long end,
 }
 
 /**
- * vmemmap_remap_split - split the vmemmap virtual address range [@start, @end)
- *                      backing PMDs of the directmap into PTEs
- * @start:     start address of the vmemmap virtual address range that we want
- *             to remap.
- * @end:       end address of the vmemmap virtual address range that we want to
- *             remap.
+ * vmemmap_pteify_folio - convert the vmemmap backing of a folio to PTE mappings
+ * @folio:	folio whose vmemmap range should be converted to PTE mappings.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Convert mappings covering @folio's vmemmap into PTE mappings. If TLB flushing
+ * is skipped, the caller must flush TLBs after all pteify operations are complete
+ * before remapping the folio's vmemmap pages.
+ *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_split(unsigned long start, unsigned long end)
+static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
 {
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
 	struct vmemmap_remap_walk walk = {
-		.remap_pte	= NULL,
-		.flags		= VMEMMAP_DEFER_TLB_FLUSH,
+		.flags		= flags,
 	};
 
 	return vmemmap_remap_range(start, end, &walk);
@@ -537,21 +540,13 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
-static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *folio)
+static int hugetlb_vmemmap_pteify_folio(const struct hstate *h, struct folio *folio,
+		unsigned long flags)
 {
-	unsigned long vmemmap_start, vmemmap_end;
-
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return 0;
 
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	/*
-	 * Split PMDs on the vmemmap virtual address range [@vmemmap_start,
-	 * @vmemmap_end]
-	 */
-	return vmemmap_remap_split(vmemmap_start, vmemmap_end);
+	return vmemmap_pteify_folio(folio, flags);
 }
 
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
@@ -576,7 +571,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 
 		nr_to_optimize++;
 
-		ret = hugetlb_vmemmap_split_folio(h, folio);
+		ret = hugetlb_vmemmap_pteify_folio(h, folio, flags);
 
 		/*
 		 * Splitting the PMD requires allocating a page, thus let's fail
-- 
2.54.0


