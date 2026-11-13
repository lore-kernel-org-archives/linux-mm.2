Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1697606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=iyoMEpXz
Received: by kanga.kvack.org (Postfix)
	id D3AB66B064A; Thu, 12 Nov 2026 22:35:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBAD6B065D; Thu, 12 Nov 2026 22:35:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3616B0661; Thu, 12 Nov 2026 22:35:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2D66B064A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:35:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA69A160439
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:29 +0000 (UTC)
X-FDA: 85428680778.24.DE917F8
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 274D280002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iyoMEpXz;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540928;
	b=8mD9TuivFp1LMF2ZrUmQSXNoLETdc281YcNlABMh/suZz9/W7kjUpW3BdUvnTNrWMtPeWX
	v67pNwM4XPkvv/T/mPh5FU5JxoUQIr70NEOFjBFDp/PHA04R3ZaEKXii5i3k2WIs7+HjTP
	TAvHkB10q3JYQ5GYiu8pTGLbOFdWAtg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iyoMEpXz;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fx9BDQQeKoTDNDbEhBwBM0FWpMS6IvOY7MZ4EVdx3a0=;
	b=ZK9qACA4BOcx2pQxhVISDwLTxRoTjrutkayxLWqJEtm+L3HXIHyToayPoYIAemIMPcZUvV
	DRYoSv2dtPjo9M2+lOSf+YxPKaf6z09+tz6qMyI6rjhbfIHOjF9KYCI4PDXth1RmbEwseN
	xihp8+TaindxnT4jIh2pQV5RxoV6ZTk=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36dbde64409so854812eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540927; x=1795145727; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fx9BDQQeKoTDNDbEhBwBM0FWpMS6IvOY7MZ4EVdx3a0=;
        b=iyoMEpXz+NwfbvLSvowRTD4IqvsaJ1nxFqklFRb/wEXMLGt3jX8LPVfoMjXjpaoGkD
         UhQ8/1/y5MAEw1RL+Z49JU+a+prYkea1St/yRC+rFbVzZDP2kikc2xdJN5zwM8yndHmx
         Bxh5mdxZnnAcNUsT8OB8EccFr2J2pfuaoQIy0pdmdt6NHFXBdhxcf8hdXBUs8CEUWgVj
         W6MlCWHpNwF/yVBCvtjBDaLDlexhqcth2mz8i+8Qlj743G1DhqT5ix8Rsuza30lKKatF
         H5uts28whzwkGL2FFx9MHhjcCsxRNlyvIDkpp++UtJ62ukmV7r81snnCmlDXgjRk2+BW
         zKyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540927; x=1795145727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fx9BDQQeKoTDNDbEhBwBM0FWpMS6IvOY7MZ4EVdx3a0=;
        b=RsrE0zpkrq9Q/Hlhi9Ppaq9VdwEl9Lumlqu8x1GWwtHe5tpEbHwEF/rEvcO/oIXYQq
         ycxYghsggstao2ASOTYHm474xyGqaoRTvaMns9rbEqD2Y0uWcoYau9DgRh1xuJBINgNO
         AKDyb1rEkrm0fNpd71T/yVLkyXhm1ACzDM1lhFxAFW4K1432DET2svgikrGFyFg78XHu
         2NGZkK4Gxgf4cN6/pm8gCSTjRZ12g/FKVNoGEpaX5CSes3CBYin52wc2lzrZwnFIJWuy
         3xtF4vp/6iQ8bIF9OXC1Mkp5kvlmz7PAsg+N4uRWHez4mne7nvFPBQ+XR0uS/w6rcTgv
         eDcg==
X-Forwarded-Encrypted: i=1; AL+hErFD8qp8CyP1bObo+glHTRw/nLRrj+CpBfM9NIJgPRfrDMSWQuiCiMhpbk0uclZRoXTf4HgN4Dkc2w==@kvack.org
X-Gm-Message-State: APuU4Z8H4GvLe/C+w/itRJNkLMCip61PeQ15/7ElvgSIqBXn+cTBBP6Y
	9yw/0Boj/4+aGGpE/gcml8lceH/7tc3AEeJ2carpCIs6qYYeZi+J/Dc9LpxWo1SA0KM=
X-Gm-Gg: AYBFou0lJzwIc2ASS5hCBrWANCLFsXGfLsz4ncLOc6xSq8Oe7WISNzCxmJuargHEhsC
	b2+yYKccdlmXR0Z1cFbZveGaWVkSUxOoGY0uSN/ErGhyrQafFyE/B/YGLG4+ZRUTmPlO8EIZxLh
	UsyPu9y9Kl2O9BiFaGsL216a1XzWVLdX5VFqf4NzoHGkFVuJlsjoxbKf5S100i8VUSHB/FVXGH6
	62FTbev4CRJBj0ecmt03ZYg+75g80/LmsvRV9pcUxnUVQxcrwjhyv/LknNZC6CR4UMixpCy65ey
	eJLNlethzajlVStB0GOeZcI7sCxtQwcXRQgeIdkf4VEyAtD+W0npLy3oQzhXi1eN5SnEHObFhE0
	xrgIkN2aoWyCuDiztuLKIkhneOsclCLZrZAv4iq/Zgt5BxQZt6EyUOIfyZ+D9nDag1xmLsxeqDj
	Mq8dezPW3jbr8Jid9Z8ZEONnputPEqxLIhGJId2RP4YnFi7yqOooRVRq39mVPN+zfgrsFW84YjY
	TeAWPCIAvoqqXwbtD99TO/YKNhO2HI3gk+lKPIGGT0VLSUI1f53ygPkSOZLGmJDHuadwYslSLUf
	jzJhx+tdAzyAiEKk81J299NcgvEgL+AWncFnT0tuYaa52m4wNRijYh3FqeYkNw==
X-Received: by 2002:a05:7300:d58d:b0:36f:9d8:4a33 with SMTP id 5a478bee46e88-379675071a1mr1169403eec.31.1794540926434;
        Thu, 12 Nov 2026 19:35:26 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.35.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:35:25 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 02/14] mm/hugetlb: optimize bootmem hugepage tail vmemmap init
Date: Fri, 13 Nov 2026 11:34:30 +0800
Message-ID: <20261113033442.62970-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 274D280002
X-Stat-Signature: 6pd5ii96jq7k7tss8hkm3mdbdtf463gx
X-Rspam-User: 
X-HE-Tag: 1794540928-657765
X-HE-Meta: U2FsdGVkX196DxgHbqPWNM04Ygxo6s3ii0x1KMGUjYJ85VY/vr4vlpTnEXvIqa2RX6AbINfWRoxuBzegScZu2IiQ4Q7zZ/RPPECGibT5a0zYW52sLDMcXvClS+NO9hoN0ob5j1UrVluYu1vQhXaGiButOoWoW0TvDbnvijWWWA0LgWnw/Z7feGU1/6cBd8nlpwGfWaQCzsmveJBNoQYyKr7CTcNMaFq9xte/euIINZjSwheuYpoIdcQPQMVfrYBCNKCPZ1W1/8rcxUrlBMp3/MoS/BfQ8xxfHBLDcIX82Pa++bCTWHspvjhDwIg8SDpcQbkzQEi9n0h532LvLH/3edjMNaGLxOrPtm26kI+V3/Mtt0xNTowQtjzSFEQrG4Ka0g8WnepbViTozJIs56/6QvAXgNOkuw4p1jHdYJje6XYMUdfMEfjzjJIRGOvRkeqb+FOm90ZhhOUx+6AiTx6JpGSSEtUBqEBYi+esEq61bok/0CFojDn+6dku0LV1zFr3FIM5tk8BmVpBU3THOKJPpBC0xwRdDhsQg8PrQBRC4cbAhq7uGgQlbngpvvfFxB67P7qUbgi6EsW8CeUyn+i7W1aYbeXab1+9f2efjkew31l0LsODYS5Jq2BAS1a+TOekH3dapOFTaGKiL59qW7SGGvgLbBQ8gI46JPJh6qfchk37fA+WD5ny6esAqJTe5lVACSrPN+hAVN9gZNENvr1MBToF8bBoGHfhLKvAbcfyFcC+/cqGPVnxCzA0jV10XkIX4H80qQP1XonVWCrRAMMyHhQfFc1R1y0eIbR1idIRd22Q48hn8EVBqZdaf2grfkz6wA5sK/BbbNQ1LZ6TDJa5a/aG/oJgwM7ZiZUlF0Ee6YoOhWQdfkF11RyBeHXEw6GBJ5eqvZOd+GPFaeOM+UCim0l52nNw5aZrcmL0exIfFq8dqGdUJOHXYtmLlE8rFlccvJfFgbHGOfq8rv3ivU1
 Wb6P2z5t
 cBtwFzV1p0a29shQWWY1nHzKB4f0VpIhWljIg09C11ICF3Kih4o6TCsfhqZdq30f3AnCNwaLPb5FA3mZRe8SQFRS+4o7ns4equeNzCiaW+OR8xyATagZsJBXJo+tO5lrJ5JWKhXP7G4AsOewxKSlmkrFG5YhO41GCJo1RnBa25CsqnwHA7r4VMeQFcTDSJBQuYkuQrrraEA+YmbVE64mVWnc2bgGcy3r3vba7EU7Mx6VBKgujACcaPj93z7HMGO/aRucSqCIwa2WM2HKKuYmuSHVhIsM2pzsVVxXKj4AbH+BI5nruXAsMSLxHGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Li Zhe <lizhe.67@bytedance.com>

Boot-time HugeTLB allocation has to initialize tail struct pages itself
when HugeTLB vmemmap optimization (HVO) is unavailable or fails.  For
gigantic pages, this can cover a large number of tail pages.  Most state
installed by __init_single_page() and prep_compound_tail() is identical
for every tail page in the same huge page; only PFN-dependent fields need
refreshing.

Initialize the first tail page normally, then initialize the remaining
tails with hugetlb_init_tail_page().  This copies the already
initialized first tail page with memcpy() and refreshes only the
PFN-dependent fields in the destination page, while avoiding the full
__init_single_page() and prep_compound_tail() sequence for state that is
identical across tail pages in the same huge page.

The fallback path was measured on a v7.4-rc2 base with a temporary
jiffies-based printk modeled after the existing timing in
memmap_init_zone_device(), using 4K base pages and 64 boot-time 1G
hugepages.  HVO is unavailable on arm64; on x86-64,
hugetlb_free_vmemmap=off was used to exercise the fallback path.

  arch    base      with this patch  reduction
  arm64   360.8 ms  256.0 ms         29.05%
  x86-64  171.0 ms  165.0 ms          3.51%

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c | 23 ++++++++++++++++++-----
 mm/mm_init.c |  5 ++++-
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 88c9aa700533..ed3af959f615 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3266,6 +3266,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	enum zone_type zone = folio_zonenum(folio);
 	int nid = folio_nid(folio);
 	struct page *page = folio_page(folio, start_page_number);
+	struct page template;
 	unsigned long head_pfn = folio_pfn(folio);
 	unsigned long pfn, end_pfn = head_pfn + end_page_number;
 	unsigned int order = huge_page_order(h);
@@ -3274,11 +3275,23 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
 	 * we must initialize them ourselves here.
 	 */
-	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
-		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail(page, &folio->page, order);
-		set_page_count(page, 0);
-	}
+	if (start_page_number >= end_page_number)
+		return;
+
+	pfn = head_pfn + start_page_number;
+
+	/*
+	 * Seed a template from the first real tail page and refresh only
+	 * PFN-dependent fields before copying it.
+	 */
+	__init_single_page(page, pfn, zone, nid);
+	prep_compound_tail(page, &folio->page, order);
+	set_page_count(page, 0);
+	memcpy(&template, page, sizeof(template));
+
+	for (pfn++; pfn < end_pfn; pfn++)
+		memmap_init_page_from_template(pfn_to_page(pfn), pfn,
+					       folio_zone(folio), &template);
 }
 
 static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 3988c19699bc..639880afe0ee 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -720,7 +720,10 @@ void __meminit memmap_init_page_from_template(struct page *page,
 	if (!is_highmem_idx(zone_idx(zone)))
 		set_page_address(template, __va(pfn << PAGE_SHIFT));
 #endif
-	memcpy_nontemporal(page, template, sizeof(*page));
+	if(zone_is_zone_device(zone))
+		memcpy_nontemporal(page, template, sizeof(*page));
+	else
+		memcpy(page, template, sizeof(*page));
 }
 
 struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
-- 
2.54.0


