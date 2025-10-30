Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B456CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 16:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9C928001A; Thu, 30 Oct 2025 12:43:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767BC280003; Thu, 30 Oct 2025 12:43:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F5A28001A; Thu, 30 Oct 2025 12:43:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8C3280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:43:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E884E1401D7
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:43:47 +0000 (UTC)
X-FDA: 84055352094.28.B0E7108
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 08B7DA0007
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:43:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HAB3NxGa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761842626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W8NaKFIa21x2HNBN6xbLMzza2GzAoImbWtV6ctvvfMU=;
	b=z6SlGXCYhxrin5TBpa/YjJC/SQ/I28g9covk9KnAaqamN+L1dH5n3Qtgb1IfVFwKl6znl7
	asgbj96BHpFNehsqwSMUQdVX0Nr9zpGtLYRXOShv2qjXL5vbH2hK3qQ+rM/jhoyEXTwwKU
	NrUE/Ro3/SbeG2NMb6aBV8q0kJMwcbo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761842626; a=rsa-sha256;
	cv=none;
	b=HykUs3efoBdBMWHbqE28aRczDCeyfAqtAYp362ZL4VSjIOziSshCliAw0ZSL8UvkSzRflV
	4F1s+oB1oBs5v3G1V2rFBIEMeNUy5/iWewQaNg8Co+KEKqG+DFfXiq9Dwgu5tLeVm2wYEq
	oetLOEM6PlLXVFBgkMCK1OSX60/WSgI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HAB3NxGa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-427015003eeso1106468f8f.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761842625; x=1762447425; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8NaKFIa21x2HNBN6xbLMzza2GzAoImbWtV6ctvvfMU=;
        b=HAB3NxGalopxKhu41JIgw9PREBUgkODZH2XV8LWLPgVqgg2+YQiicpmbWFQOHdOOdy
         Wbo+cGMjKoIs+u3GQrWhXKc2/5IAaEIHCCTIpgybbSTCG93Nc/kObOvK75ODLkoEZ9sU
         GRd8q0Tzypep/tU5j3qS5IBY2oTIt64BH+TbqX3Baf6NdSrwTEiKlQ2ac12UI/I776w1
         AhGTtVbECTRpxKJwpTphHqswZyyDtHTOeaj5Qr/OmM7dAKgFiY64S8TMXa/i9ELAoyY+
         pXmMbfic9kFp2TlGw/+HBj7ItKHEzg+oxDdLTDlPiYOn7oHy0iBbcsuISzk+Mdhj6KOP
         jVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761842625; x=1762447425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8NaKFIa21x2HNBN6xbLMzza2GzAoImbWtV6ctvvfMU=;
        b=Zer+LNfOGkNT0JcQIcPFce/qxfN6RxWqmb1NzMDyPFZqHwEiJ4lBkMuIgPsQtSWTIj
         NdjLi3L3tMQhm0tATKlZnDPih3QOITEVBtUuK97S20LWyf1lxipseXpx2BLLGsmblAUU
         xnG7qNybBzXm8W0pjgDNTUB1F+wqQMQvMOTRcbcOGCg5ToqQvPglOD1FKy9osPDvKPV7
         VCXAcosFIejVPejg3T84VlOsgJX1ztwZ9YDSbX1fjXLlbpkqntAIg05CIVNNLxM55jp8
         CGNcKcaFfazFHuad9yEPxTDUQ4VzNhcd0VBO2J+bjniYFR4wge1OoX+7RJga8RORSLzR
         iBJA==
X-Forwarded-Encrypted: i=1; AJvYcCV6k5cSUZM8UFQ8wrNsXGDvdr6JOK320B1gATiNabAdHb2iFzM7J0pc+IMME6oAukfD+JwedKVMZQ==@kvack.org
X-Gm-Message-State: AOJu0YzUh2j4AuOi/SSR1t/7i1LN9Lr8/HNdS+qp2w5Sq3506vmTbsy+
	q9H0S+kfIrcUSmsnZ1R+8KKtRF1GB4aj9MkMrfgQ6rLglbPdGfUxEfM4
X-Gm-Gg: ASbGncuLlAQXS1BA6sXGYX25/PGgyr5HgRbeyc966LArre0hf4p6md9vrsymni+rRr2
	KVjgelEIt5vDEXcBL2yeBbLFGisWQg2IZfhUOqQ1wEAOeln2/9gWQ90E7y7mtNeQE83hamQqw72
	p91xkdvoXgdwZdiFM+5BiEG2CDA2gGk2e+2iND99biyl8AQh5p4ZWOKicq0zSdsvBip5774OTGO
	bHZJnrFtaCRSrEMLIJZ4DyuaFzFmLEpgIRO4z/HrzkGFqCUBkSd57/gfsVwHiFQgSpNo1McQw8c
	Axi3w1Ml3Oq9HcEKj5V4H+OuVN44aJXVNxzfKXGeGMJJLqX+VeKBcUKWkjwF3OeYYJa6XAQONAj
	OCBvYoybEp2ymv84K8zAD8Bs+q3NXOnMNDCgE9c7DaMuOSRh/y+GXl1Hmxt+Mo8QLWL4eblXj3l
	KG6Z331lXR7VnVdSMYxI6aSC2l9MuRKj+omHE6HSNFeFIZ9d1eH4k=
X-Google-Smtp-Source: AGHT+IEq0NtBB9os8AQrwNuf6RMTKhTbnzYUGptUR5F6h/jQOa3dSLBo8JhgapieccnR/IZAc9uxSA==
X-Received: by 2002:a05:6000:2382:b0:427:151:3db6 with SMTP id ffacd0b85a97d-429bd68384dmr244092f8f.24.1761842624150;
        Thu, 30 Oct 2025 09:43:44 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-429952df62dsm36796839f8f.45.2025.10.30.09.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 09:43:43 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RFC PATCH 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
Date: Thu, 30 Oct 2025 09:43:28 -0700
Message-ID: <20251030164330.44995-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251030164330.44995-1-vishal.moola@gmail.com>
References: <20251030164330.44995-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 08B7DA0007
X-Rspamd-Server: rspam02
X-Stat-Signature: u1y96ooipbknsg6ynw19b5ueebie4ebt
X-HE-Tag: 1761842625-271675
X-HE-Meta: U2FsdGVkX1+E32nj//R1ummAOHAFWZqzzkIbAuxYJ8UpVJAQAB0ElPrHGTYrTGScZwx8/XojNpCa5UrzcF1j64yoHiTzSlRg6jWZpxcI/vSjQiBaw/YWr/++4UYhBik8bxWpLOJpl5V03EjP14TA5wF8Jda9aNh+dtSeETg3IcASVGa5/GZ0egoN94DXT5NPSId7cVpH3ksmlJAapKsWbhzq/atKpz6IF8Gvv2lLtD1ybGtMg6x/QxUJ3gEoN//lP2yY+jFCyYmSxy0lhiP2H6RgnFLYI3ZFhBFpJ/5/Asc9m+3f26SN8p1PBS6VspFn+u6IvTWEHuB8dR0phKffC5QRP76cmQb+ZbyX6drD1curHsYoXjuHNDC4jzjXbVbSxiC1D7hYXLSBEMhJ4NgpaYmBKmBT8SajW9WAzN0+uZYAogegRldHjnKNyChZRNy7UhVyOskgeQv5g5Qc0QAe32Ih17uDFRkECSy2/oF8TzKcc4SfWo89hm36UwcNWvdn4gSCjQKNZNWmyRUcJwLqBgj5WEyF+d7aSSwV67Tpkpck7TWxdVJqQySBIMB9RWvoPna+2ac4VH8ZwhR65RXknEXKXqWe+gQuPZ76fVkmcd97SmDWa70mT7DjFD7GCOu0Cjm1X0C/AU9JGGiGdAhp9L7nG+u3q3D/gXKJx9ySEGBRTdgKcR1XIMc7isL81plGonVmicANrKX7OnHg6/3niGQLL5c9/LgLHD8kRK71QoLVO0BazmDhaKaRJEtxju5U5uaDojFEuKucATrwUyjYkRKCUhFrwzH6wSryX3ZCXtpXRrSZ8WrPzP8DfvFNh3Es/B30htHnj/6SrQsnOVE/DigUonwGiqKDuaLaQFWDQD/iZEe53zo9uTBQfB9wG1BEJtpzAnYHQ4xJyV1gd5rDh4bdwv0NwbJhdh+i4Db6CHwEQVTdZALpxtEAflCacoMahknKMk4FS4EX310y7kg
 WJ+Bw+Td
 CRlJs6q211tZ/wVaA6JkLxgi4/kkxDU5B76DoqJKVrXpDABGTOR1W+/Z7DmZYyfpl9mSYfT9vfyuR5KdmmCMYllPTMR542/nme2N4n8KxfH8cP4SlBL7nMykwWQB9IOYHY2839JuweNJDEdVwcGF3s2HLc9OeLtieLr0HKMSNLdgK9GwvcTH74avV0EQu9t5MmsyCH9c9zRYbow6dqxQmfewUBhEGKiHUvCMMKa4c/kk1OzPr+PhbbOE8V2ks3FSGtQDfLE4mSRHyZTnvTmunsAeAMl17/udOMRf1rhhUMkgNbtK1Za55eeH1fLbJdaxooSrxgCrZ22FRO6gTh9k+/awl7/iY5bbK2Qh5XBndn6YBjBFhMKZOZQVGYvTNmpjfbqXzWELp8GWhpOvgffpMkCadKzFGBLnRjCb7ywiKNngwkcPTjGpatn2gYQyz/BvTvYCJYqIktaQTVL5TorNwAUQ9rVZ3eMUCtd6d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_area_alloc_pages() attempts to use different gfp flags as a way
to optimize allocations. This has been done inline which makes things
harder to read.

Add a helper function to make the code more readable.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b86c36d51833..76c060ef2bf7 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3614,6 +3614,17 @@ void *vmap_pfn(unsigned long *pfns, unsigned int count, pgprot_t prot)
 EXPORT_SYMBOL_GPL(vmap_pfn);
 #endif /* CONFIG_VMAP_PFN */
 
+/*
+ * Helper for vmalloc to adjust the gfp flags for certain allocations.
+ */
+static inline gfp_t vmalloc_gfp_adjust(gfp_t flags, const bool large)
+{
+	flags |= __GFP_NOWARN;
+	if (large)
+		flags &= ~__GFP_NOFAIL;
+	return flags;
+}
+
 static inline unsigned int
 vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
@@ -3852,9 +3863,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 * Please note, the __vmalloc_node_range_noprof() falls-back
 	 * to order-0 pages if high-order attempt is unsuccessful.
 	 */
-	area->nr_pages = vm_area_alloc_pages((page_order ?
-		gfp_mask & ~__GFP_NOFAIL : gfp_mask) | __GFP_NOWARN,
-		node, page_order, nr_small_pages, area->pages);
+	area->nr_pages = vm_area_alloc_pages(
+			vmalloc_gfp_adjust(gfp_mask, page_order), node,
+			page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 	/* All pages of vm should be charged to same memcg, so use first one. */
-- 
2.51.1


