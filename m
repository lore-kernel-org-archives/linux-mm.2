Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05E63CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CC556B0109; Wed, 13 May 2026 09:22:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A41F6B010B; Wed, 13 May 2026 09:22:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BA6C6B010C; Wed, 13 May 2026 09:22:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 497896B0109
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:22:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16370A00AE
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:17 +0000 (UTC)
X-FDA: 84762460314.28.5C6257D
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2860640012
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eGRasrWw;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZDeIIjrnNpMULL+G/A/MulBde5nkuD9M1+mQAv5l6w=;
	b=VJcoRBnn2WaFdOezniEMwWzOSNTcQFggJPqVKcjcN8Fax5ExZ52fK5cucqeV5y033qTJRo
	WjgdK+7TqPfF2DT/C6yHWnFMobBbGQqSSaiC3KZC4vm0Ims6MotOxeMNagQOoiq/hG87lU
	88tQjKh3UqnqzmfLADOQX3/6QmH52xY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678535; a=rsa-sha256;
	cv=none;
	b=ACPoFvIaJb0CT3XJL81Jlh7HF0vEgpUgNbz4pqj/Cs4kiLYlPlwPE1mogI4H7+73cXI/00
	s7z73otz59yebJ9JsTCAX5naP7aux93Qx97OrxfgvcxsPl44zD/Uce3tM9NRlDlykWOt5L
	eOzLu6RYLhWA5bLz0yrmekz20p8axZQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eGRasrWw;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3660daea6a5so3681192a91.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678534; x=1779283334; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VZDeIIjrnNpMULL+G/A/MulBde5nkuD9M1+mQAv5l6w=;
        b=eGRasrWw0djB5joAuQz7P/ltOF7H9XRrPHlwqIObrMBH7ofdtyi7/PA7+nFOwJb04M
         DmdpGhgqTeIZM/WsjXd7Ju0TbStV8BAYxEt74cc0R2RwzIoous65k5TnIlZapAukbx75
         rbAr81TIP9g9DPP+4uCOJv29CYabLQuv2G2vUbl+PgGYKKBHVXCEZ+HZjEYt32mN4NZj
         hiXL+0Lcocu2me5AnsgfTNH4Ahuxsv1KbUGm4VxdYymTCXIiKh9ea/ELAFRMslwxcTQ3
         ATLIln3L+RISu4bjW8FsQil+GrWq++Zf7Ie65cOy69kO3mtuZat7KnzkKbv/NM1Syew0
         zNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678534; x=1779283334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VZDeIIjrnNpMULL+G/A/MulBde5nkuD9M1+mQAv5l6w=;
        b=FVSPFGqjD4xqXtNk5PUBv4XcIL3rxPYWdl14+d2DVSfyeMdpbttCPjjZIiL8P9Cms0
         nLY5G7OaIeelekSewZPNvsx35qxyVb6jTCo9tKNedXV6gzIc6CyN1/OdwDaIlbM7bgPB
         kU6x7dl4B2pUarucdI9Ab1AVaXnB5/65NhOxTXtfOdWbIG5mjSS1jpVZiJebReCWj937
         dJ7/+4NjQvScK0YqYjmWxpKcr1biA7IEBsaIVX4HkyB0EBBinIA8Jm2MtqzBFVhuyP/7
         peODjmhqkXuffLFpyFGi7Ovs2RvoOjakN7ywKK4PnNZ1lNfCKoSj8eHixzVro8BGqptD
         s5TQ==
X-Forwarded-Encrypted: i=1; AFNElJ8R+OpOrR+29eBLY6V3NplFuuH61a1bRoIFaCFE6EPNgy1a5nkM8k5F3aIlboyfHh2v8knoQfMTxw==@kvack.org
X-Gm-Message-State: AOJu0YxOZIbN9l33xgPjWK9EsuMIz1Cy4BDvV2DC65o+X5XXX+5VSjEg
	rXVcqiCoKTQpBUcRjiBr84+J6cbNf5J9USp/EDS7d7lVT10YlyJm3bam8S4HjVWMZz8=
X-Gm-Gg: Acq92OHAUOaJyYhUF1+pAiMPU3qJIvIw8h+A7s+fQmyXUrpHjfCNHi4/Rss5lvVb6ia
	V64a1+3NfgAsL5p2+uSx4OvFMbjD72XjtwR1FKXjal36MP6EjDYsQqlRaXkzgjDbWC52bAKevOk
	Fy7EWmXUbvl8iPDfSjKYFJCsYycH8AbBNiMIiAK9iuB2JO38QE9kuj0QWSa9kVWAjCvmjAkIpoN
	JsJK+7UEI659+DU8RXDDWAUpGBMv4jrk6NNAocJTCA5J3fotDv89yv043HuJH4IxuXqsd0NNdWZ
	TOB4S3ypjJ1gWVEMDLua/p93f+yyAaXPXecei34HU+gaTFWeZPwoFcPTEyl3LBymOM+QpkB1AJg
	iRpln94D6V+WY97l94ILuzQToyL+XBvjjSN4PIyCsQwcU6AntDrh1QMh4DP5obwt/S7IcQA/xRw
	vwdV4ARSOW754rrc2MCk8Hf31KwjQyqqaFFSs53K3AMwygMBUwsWz9CIpQkjAD
X-Received: by 2002:a17:90b:43:b0:368:1064:62f7 with SMTP id 98e67ed59e1d1-368f77f6824mr3031213a91.6.1778678533741;
        Wed, 13 May 2026 06:22:13 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.22.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:22:13 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 59/69] mm/sparse-vmemmap: Localize init_compound_tail()
Date: Wed, 13 May 2026 21:20:24 +0800
Message-ID: <20260513132044.41690-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2860640012
X-Stat-Signature: o6omzjtdr4exofz5gwap1b47o1utky6n
X-Rspam-User: 
X-HE-Tag: 1778678534-428610
X-HE-Meta: U2FsdGVkX1/Nxem/A5s1WUNsHzdEWC1z+S2BCRvRZhsS4j9WX15m73VEPhM7PCQOGTOz65oY/EtP9tjDgVfguyTDZKX404i5YAuDcpou0PuQ5k0jI4U10LUJLJAtiia2d6av2aSWcX1yolFfCfmeanUaSC9oAiolarYlbEJQq24Eyy3MS7Wy22OS+MyZifgumjjBbLFexf0XsE/hedISV7oknbjt7H4kcR587ckd8etiL2dkqgGjUBGtuLj6wEDDmhK7y6UVwgyKpHPMnavLegdBe7W5Vxh7IG4OdCLVVhKIkrFrl2qdaeyVjLMvrPRmnvoH3EmuCmK7PTfX+h9SuUQLoD39Bky53tnBEzGUkp+zniKtskyzb5fIB2/HZiKr1d/VFpj3Us7BgRLHvHbfjXKKlq25XsIqDvqnjcJwM4r+eckn1ui82hHLhUzXlGD7oi1esrEsZGBb9yFyBkTzvy/e8gjbqsal25TJDmOJBC+yOsLLjN14NS6gpMYtA41VhWsH4TPIBGQFZyi4Mol53e+1H6TR776fJZFb0X8mjKwiEjSAbLULqAtE1x/ZcBa5xvyXuNKowuPBAcs7R0u2xzSstQE8ZJ70ZeIV+xOZQ442xxCntSDdYlbMv6DeH9iXZjxZb9EWmU1AjOX5hP+Vmo5oSte+q6VPy96YQXz2Uo6wRWIZJebiEFiAfE8P8dUU1nYHN55qrt/8ukPmEr56Sae4dxPFLCCwve2yyT7fuLIKdjXzTXVEOugef/NOtju7QLgPX1gGUdPLGCVPjh/3yMANl+Rb00S7C2rFVVW19MUbLUW1TkIT06U43/CinLuZhSQErFx9YbigJoOZ04YQMWHNoUyBMw1pVOWoNMoDyujgPtlhYX4RInlWdrG0yHYZUaN/qVgMlGJI/hpb5VfIT67lu8yVlVGqvUPmHqms8NeppH5oqZNOxBgubuqKVZKbYrj+zq2X+FwaV+x/Hyl
 XZGUlLDa
 FhzbiCQthx8wes3iQqoj+Fe3HTMEg3xd/bWYDpUYPhyyUipQxyasxovO1YhAYtgtipbXcnRCHZFx/ph16rEhGC2OT5hMcY6GLmZyv+rilFxOL/RWIahF23kXj108P+FFWP1RVwO66O5H4KSo5pem0uOIDibo4+pidkjtQJilY/u+OihKQsGOVyeFLHO37F0j56eth7IE/bFrqxDyuY63tIQ6cKus+PvU4spMxqshWJqkKQgIf7AIrdy9JD3nxNHQe2Lh2R4pjXJDrqwEw5verkirz386F7l5eI7bhkW7pIEB/xqIG39ngSGOzeTZ/sAQ7bWB+noX5Dxngi3uIMcfrNl62F7v2aUx1ekZtX1gqpM0sogc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

init_compound_tail() is only used in mm/sparse-vmemmap.c, so there is no
need to keep it in mm/internal.h.

The helper is only used for SPARSEMEM_VMEMMAP_OPTIMIZATION, where passing
NULL as the compound head is valid. Keeping it visible outside makes that
usage look more generally applicable than it really is, which increases
the chance of misuse.

Move it into mm/sparse-vmemmap.c so the helper stays tied to the only
context where its NULL head argument is valid.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h       |  9 ---------
 mm/sparse-vmemmap.c | 12 +++++++++++-
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index afdae79640b5..aff7cebb1da4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -907,15 +907,6 @@ static inline void prep_compound_tail(struct page *tail,
 	set_page_private(tail, 0);
 }
 
-static inline void init_compound_tail(struct page *tail,
-		const struct page *head, unsigned int order, struct zone *zone)
-{
-	atomic_set(&tail->_mapcount, -1);
-	set_page_node(tail, zone_to_nid(zone));
-	set_page_zone(tail, zone_idx(zone));
-	prep_compound_tail(tail, head, order);
-}
-
 void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 667424aadd6b..38777e4952e1 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -265,6 +265,16 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 	return 0;
 }
 
+static void init_compound_tail(struct page *page, unsigned int order, struct zone *zone)
+{
+	BUILD_BUG_ON(!IS_ENABLED(SPARSEMEM_VMEMMAP_OPTIMIZATION));
+
+	atomic_set(&page->_mapcount, -1);
+	set_page_node(page, zone_to_nid(zone));
+	set_page_zone(page, zone_idx(zone));
+	prep_compound_tail(page, NULL, order);
+}
+
 struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
 {
 	void *addr;
@@ -286,7 +296,7 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 		page = (struct page *)addr + i;
 		if (zone_is_zone_device(zone))
 			__SetPageReserved(page);
-		init_compound_tail(page, NULL, order, zone);
+		init_compound_tail(page, order, zone);
 	}
 
 	page = virt_to_page(addr);
-- 
2.54.0


