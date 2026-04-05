Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4699EF3D5E1
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9F26B00A2; Sun,  5 Apr 2026 08:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1266B00A4; Sun,  5 Apr 2026 08:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0236B00A5; Sun,  5 Apr 2026 08:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BBFF6B00A2
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:54:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 60B561A0AB1
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:23 +0000 (UTC)
X-FDA: 84624495606.24.CAAF8D2
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7DC8AC0009
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JAMdcBqD;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32+AkcMilp9VVAfduQufKDvkeOaHLrnbBWuUoleVhXI=;
	b=gKaBHew5tQU6ykBhRVpqJ3LSGbWxUKvWGZ+ybm1QPpURa3/Tp4ibKL/279TObNFDDh299J
	Xq5ohRD7Sd2Ot0t3Wzq71LrPTxCcoUVpZBqktQhyNRmd7ZU+IpWHB3NClyOTyKPi70ZVak
	TljAb+geI2qgI7jHqVxNPdd6IAkIAi0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393661; a=rsa-sha256;
	cv=none;
	b=tnRDiTDI+06CSiTUdbuyd6L9qBOTrgl0Fs4cJj+h06BCx7KM5OXq//W3VQgMfsybz00Dbc
	t0IkKxx/nC2USEAmdt0aSDD7IFTlr2yT+MLrgQLu1wNcfcDtAo8FZYv2o0/nA96Ictpc4f
	si/lc2eDdSyxa0tQ1pORDcpF+EJx05o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JAMdcBqD;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-354a18c48b5so2695162a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393660; x=1775998460; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=32+AkcMilp9VVAfduQufKDvkeOaHLrnbBWuUoleVhXI=;
        b=JAMdcBqD/RXP8zz+Gr6ziJo5O5RM5FkI75MWz3ezpS83XsYrkjKuE2OFEqmrAd+ody
         gjWiEeEHLnfjADQwA6ISyfVb+M1WbDq4EYfD6YogXn5t7iY4Fwpl+BTAUZ1HDFak8iSN
         yQrbfJ4mFx8yXbAUEjmzE9A/OeioL35eAtY0OW1wI3RUp1UYErJ681KCB3ha2EJA8mXr
         dLY2JuYrpL7urL/zR74hA4SMsAVKww3WSq/AYWoTk+7Sguy4NESm3k/Vz0bqpJgF0KZs
         8jemvM4of3O3HuCTyqu0VAQtztCaehb61UId6q91vyL9SMck1lxt6tx5dm5RvPrYL4km
         Dlvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393660; x=1775998460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=32+AkcMilp9VVAfduQufKDvkeOaHLrnbBWuUoleVhXI=;
        b=P8bpFrsl1UXLqkg7c9GjXvp5SkwQ7S6XskT73qm3CIkYYmEbj9vdMMZVYMmNTpNYAF
         nP7822N4UwICHTdwlufkK96Xitf6nc9v1SxhRCuSMFAdV3XZQTADjTpD2AEUB+4GnaO7
         efgCJMSl3E2NgRKfIUopv56N5z8qQ9HfRyBL9mrCgAcKwG2fjVfPrIjqi1oSU/bTwzyP
         k2BYJbPIub/flG0/tUZe/6FjVLIhAswKzWFU/d82RNSSlL7EQK9ozhafSsoo33E2agG8
         DLtuWhInNNcUmFSM+xO+QG8XKC6vtXSdavP/qfTdM9Ah/BDB8jkWiPeq+4EgR2aJhZDr
         Bs5w==
X-Forwarded-Encrypted: i=1; AJvYcCUMx7NLJHsZ0gvSaSyNSwh2WqVf7YzRmDOhLiB5Vfv/6h56x7B5OGI6smIFVJLhjchDFAKiZBzGgw==@kvack.org
X-Gm-Message-State: AOJu0YxjaR2A+rkxN2xVctqN0ryNua6ySP8KS9l/kpHfCAPyg9mM6ce7
	jeqKG4cSgrCh7t697I0PUHAOr2v7ALGeuUfrigrq/91YpxiMlAVwy+fA4lwvFDDC7dg=
X-Gm-Gg: AeBDieuC5/O6Jahe/8MwEcl05yUO2pKAvs7j6iqLfo5A8lTmx3zTdCvkmpNx1W7X+4s
	b4cBNCrDlUdbKwLsGIEQzZEHyQBfUUQIxeUv427nLFq6OiK4gGsxLsss2tgg/qDHTtaD38amANG
	iN1N2xiQRiS9xtXb8uIQNDXdO7K2xuRjzf/5hCRBpYWXp0BsuyccnGIX3c1X4VVipG2Cr7qAq7C
	b6NR2KzzB4aWgWZoV0t4B8nib2sABUWWJX5h6OEVzHTfuE1Y+P2K1Qbn0m1dhRpBmVhQGhnPcqd
	J28Qe+LCW7+4HFrHF+Z9rWdFJs8vcscLQGd6mEzPyIDJLWWIIZC4oeKmUore0nbAGLhZ2fcMF98
	+01EK6Ire2UhKozAL50Z82JgL3RgsWzvelk+ZsgKOZLY9wLpK0aIQK/W1pZjXylfdTr7IvKJuHV
	B29pWKozPiQcPF3VonKAFbY+54gLZVxCBN+9k83W/RBXE=
X-Received: by 2002:a17:90b:5111:b0:35d:93ff:2855 with SMTP id 98e67ed59e1d1-35de67eba6amr8915799a91.8.1775393660266;
        Sun, 05 Apr 2026 05:54:20 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:54:19 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 09/49] mm: panic on memory allocation failure in sparse_init_nid()
Date: Sun,  5 Apr 2026 20:52:00 +0800
Message-Id: <20260405125240.2558577-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7DC8AC0009
X-Stat-Signature: tfcrasxkufez3bwn6mgoum7prynkamf4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775393661-694026
X-HE-Meta: U2FsdGVkX1+BkfeXeKhKbmeP+RXI9/VY/BXh4hJl4pxI2NegXzoZ3Y9a/pWwJAUY2FjrOelcle3VJvW78LHQH9bwROmrIRxqbH2kjvmWteWCfw1pTiVS+d6Jkdm/2BxVcXBvctDFU6Cu+CBXrvJpmH+5rG47ttqfrigydaenTA1caYb2ixKeYN1XK4OjxCi4dypYBs/RFK0T3Ng7+kyOIzOIwPcGtcVkVkYll7Xv1l3JrHGkfAmAprhBrzeKeKk5UNOpYfM9Gb06sz+jru37wh9yqhulVXrcvs+6tki5Ou/DPtXknB/LBEmk1+TUrqHaLlvXQCt/XNtn5C9OR2wBRlmoWbwjL/GAfoSnA+RsePpT4Mop13temK0bbdEnIjd1UOrpNaY/aVUKYFYSN7Km2N93xJ0l+1NuSJ9jASuW1u7czrL83ZlFQdVQ7VYYJRQwDvBPbl8XLL8V+teGmBOSVRqThtGxmybqIruKZaEwQN+NE2NV9ZuIcUEJg5jweYioAC8175yynd1xGmJnUBtaCtRtdXo2OU1FqKouSlXOqhcQtxgh/Kv2Nz1vtCSy8bjx3Wp4wsSqy8DbXrQhuw/2ltTvSCetADjvJrefZcbp5viXzfego63TkKMPPkJpiaaCg2dOGnZtyBpAkol0t1iyTPLj1UAC6TG4nMhI+VXpYSD1U/pHXJP2Fx8Y8/+kNBC4NfZEI6amIBxS88JSaB89KvR6gFDo/jR99YN2V23+XmqBh6LVZkeYtSaKo1C/c0eIFk6uqHLalLRuxwRysSOmahwHUv4pNCD29xW4/dqwB5HMecHjrV4w5cMenOdDfMKjh/Jkp4bYQEo2tRqP3UgJaHxdn1AQ8dVJ+JUPgEevP88WU6K00Z0/hRuoOguy1LRE6EZQ2Po002VvOxZVAT6pwZS15rTRVBPfj2vrISGYqMz4RCnj7hqUemrbtkRxYTU4Fkoi24z1qwqx9DB/PoV
 DZeb9w6x
 0PB4fFwgI1f3hYFvtEuphzL6cC2rOo4D3TXIUANxmXg0JGa6kATFsWEl8i10W1njYANM2/IGzSd7rEU6vWNtILqYm0ZOghtelYnaLwiSTtfcn09GSbKZH5PUKgUxdW1x22JWohCMYIGZl8WlfiDYkU+XZ1DwzMvG6nM09Ce4+H1/U6RM9QFH+dSxdYT0euW6z9PglH7hcvZRtGixGzmf1anf1sVKMFB61ck4Neg3JV0bTehEUXbZTF8wv40OOo9a5NnqGb3BlJcL79ofNUY2+5DsEA5mCtfQHEHBkU7ibbBgMOQaszNL0of0qustERw08j2zIkD05fL7+D/JaBFlk1ziQBlxYLtj7p/TU8PpKwfFoXFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When vmemmap pages allocation or usemap allocation fails, sparse_init_nid()
currently only marks the corresponding section as non-present. However,
subsequent code like memmap_init() iterating over PFNs does not check for
non-present sections, leading to invalid memory access (additional,
subsection_map_init() accessing the unallocated usemap as well).

It is complex to audit and fix all boot-time PFN iterators to handle these
partially initialized sections correctly. Since vmemmap and usemap allocation
failures are extremely rare during early boot, the more appropriate approach
is to expose the problem as early as possible.

Therefore, use BUG_ON() to panic immediately if allocation fails, instead of
attempting a partial recovery that leads to obscure crashes later.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse.c | 37 ++++++++-----------------------------
 1 file changed, 8 insertions(+), 29 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index effdac6b0ab1..5c12b979a618 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -354,19 +354,15 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 				   unsigned long map_count)
 {
 	unsigned long pnum;
-	struct page *map;
-	struct mem_section *ms;
-
-	if (sparse_usage_init(nid, map_count)) {
-		pr_err("%s: node[%d] usemap allocation failed", __func__, nid);
-		goto failed;
-	}
 
+	if (sparse_usage_init(nid, map_count))
+		panic("The node[%d] usemap allocation failed\n", nid);
 	sparse_buffer_init(map_count * section_map_size(), nid);
 
 	sparse_vmemmap_init_nid_early(nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
+		struct mem_section *ms;
 		unsigned long pfn = section_nr_to_pfn(pnum);
 
 		if (pnum >= pnum_end)
@@ -374,16 +370,12 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 
 		ms = __nr_to_section(pnum);
 		if (!preinited_vmemmap_section(ms)) {
+			struct page *map;
+
 			map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-					nid, NULL, NULL);
-			if (!map) {
-				pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
-				       __func__, nid);
-				pnum_begin = pnum;
-				sparse_usage_fini();
-				sparse_buffer_fini();
-				goto failed;
-			}
+							nid, NULL, NULL);
+			if (!map)
+				panic("Populate section (%ld) on node[%d] failed\n", pnum, nid);
 			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
 							   PAGE_SIZE));
 			sparse_init_early_section(nid, map, pnum, 0);
@@ -391,19 +383,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 	}
 	sparse_usage_fini();
 	sparse_buffer_fini();
-	return;
-failed:
-	/*
-	 * We failed to allocate, mark all the following pnums as not present,
-	 * except the ones already initialized earlier.
-	 */
-	for_each_present_section_nr(pnum_begin, pnum) {
-		if (pnum >= pnum_end)
-			break;
-		ms = __nr_to_section(pnum);
-		if (!preinited_vmemmap_section(ms))
-			ms->section_mem_map = 0;
-	}
 }
 
 /*
-- 
2.20.1


