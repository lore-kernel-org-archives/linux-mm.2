Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7181AF94CDC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:14:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFFD66B008A; Wed, 22 Apr 2026 04:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89476B008C; Wed, 22 Apr 2026 04:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79076B0092; Wed, 22 Apr 2026 04:14:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96EC06B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:14:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 55B09E5F0C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:14:53 +0000 (UTC)
X-FDA: 84685480866.29.AD3518E
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 64FF220004
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:14:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZcOb1na+;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776845691; a=rsa-sha256;
	cv=none;
	b=6/nUjMMuJvvnnLY9QY0ifXlTOYDgAai+HkqDZoJHDcQYmn+OqKrQmUeOGf2fmn7DclD1Qu
	5bbl3vvEkewSwjc1vx/vtkU0cAJiZtRIoiKSP53WC8s3Dv4zOUU16BqDWMAaWO8wOnethL
	tNHqJHmY9DTiWQbMvOl5XCOGRyflHsk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZcOb1na+;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776845691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TG6JcdOEtIWQgfEa9nERXqC1ZnDVOapveQPimu2FdY=;
	b=2FHRGIegGLT8b48ySw37mekiBaFuFDRhd91Mpb/EFtIEs4RUg4HblLnodcAuHZXXZYhuoq
	q2Bn5EZpCqIF+t/hSTV6HWV9pJpoJMDXlsiu20m7AInGXgLbYJQKJPvJg2OKEq8B1As3ET
	K18l2KvleQRc35q53QYhvBL8KpN4M0I=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82f69adeecbso2218007b3a.2
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776845690; x=1777450490; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TG6JcdOEtIWQgfEa9nERXqC1ZnDVOapveQPimu2FdY=;
        b=ZcOb1na+rjgol8zn7sMpTEUOA9fWJX5iQFr6oxhu3mdGKrFyYX1uxdPNs/tPcasUlA
         oZFTrAeBBMxBXD6U8WEZxQYR3Gf0eIXVo3ap+tUzyxIpDgAPc8jwhGUtNER1eoSlrPtL
         jIt2yTz9q+JRYt1M4rui7gCZ0847tQPQuckhLUrdgJMiBE1S/IpjDgiuoLPmT5l0U7cb
         RWLAK2TCodfqcWuWWpdHimfICoFxq0NhNo3fsC1xGadDpwmwoqX/mLyYoygxDrlZy7+Z
         NJNT5kz7zM/xchSsOLSCSLbtfLBabxvUDizFvsjdlNFhV0QQLfbu3Egrtx7h8tbJMyMl
         TNXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776845690; x=1777450490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6TG6JcdOEtIWQgfEa9nERXqC1ZnDVOapveQPimu2FdY=;
        b=qX5m1mAnWwp75OPEoSavYoEY43SLcIPqejhUcTi2BarzVaOWvp9mEh7gW+8LPc/kaf
         XF5q4eiYscD9o6z2EHz3PZ8AHoS9MNgJJcrD3rf838eBaZaRvddSss3dpFHONeNZb6dR
         puh3GmhV3XUEA8f2XsQCr/S5VtR79JQiMcKnl78CD3HqveYbGisvZOuwydCdnWESXeEt
         Bv5SL7sCKjG16AkSKcfSSUAXUL5s7b8IchZcfAWbu8V4UPrMY6sMlQcdgSVrStiLxu7w
         Rr7tU3H0s8KxCWXj/PdYyKhtxs0eLP4PlsjzsJTDFtpvAtEafsJdMDWsm38g4xvJ7fvC
         S3Kg==
X-Forwarded-Encrypted: i=1; AFNElJ9LVl2JFgVyaWhKXINz0Y+MF7KQQ+jq01HZ2U3DUfmf3DxibMbvF6Wa2HaSJ7UzWtWHpwrJ/3RMZA==@kvack.org
X-Gm-Message-State: AOJu0YxJ7+FSRHMYWgH4th6ssuf2ox0Caex6OPrBkElyYzggLQ3rGuBi
	ZQui1wAwDFpP5JXRat4bk+kMV4alUxAmMmoQVQ2xDcOsZ1sSdQKUHwH01vgRuiWyLgY=
X-Gm-Gg: AeBDietRdOuwXoenEIi7G3bkn5M+3n2e1cGgknG1pz67gKrnIxIt2L8TFzYmQgI/uKu
	kpV9h8NAO5QV3DSaEhH37qEv1y4yAlzv2Ir1BQw/sQ14Qu8Fv1DKVPbgWzqmHyJGuLkl1/IfhXF
	3wkRyWNyg7mypra+IM8OQCeO0xr91VmtsED1LF6pC/Q29ecWpL0/a70UHEHjDwAvlg8P67TAvaY
	6woB0/r5OocPC0gzrbGN2nIYwHjsSLfsiXytNwDVFXYwjYFl1SVw/tmSR1N2BszSJdtlCBUBuuG
	G8MB23cKflyoXzUc2Cg2CwF2Ca5wzw4OKbvhQiczEpvlNsCdrhvrD27K5pIrKyhim6Ty+aLkhGg
	eRzhQWIhq9Wxc6WS1ydozyTZymI2xxB6vZ7W+Gw2cXN089g4som+7EqbnX4BFNHRkLyR5aozFpo
	g4kG9o+wK2T3NBUz7+cKQTkykp8dIA
X-Received: by 2002:a05:6a00:1826:b0:82f:2384:212a with SMTP id d2e1a72fcca58-82f8c961ef5mr22759743b3a.26.1776845690162;
        Wed, 22 Apr 2026 01:14:50 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::34f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec0307esm16522874b3a.53.2026.04.22.01.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 01:14:49 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/5] mm/sparse-vmemmap: Fix vmemmap accounting underflow
Date: Wed, 22 Apr 2026 16:14:16 +0800
Message-Id: <20260422081420.4009847-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260422081420.4009847-1-songmuchun@bytedance.com>
References: <20260422081420.4009847-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64FF220004
X-Stat-Signature: him464kwtagrh6694znuhf6yoipap7px
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776845691-825202
X-HE-Meta: U2FsdGVkX1+A0NEZ6ROaGivzYQjWZW5100mYLvqiUlqyxuwtoPTcxRzQdJ1Jl2wRoUHr5aBSJfFfHmEl5ckHajnrBoVux9Dun+AdUThgMCzf9QPuKh929ipwEAEzRQaj35y2+SWtoZk3tTHfTbfjA7zNS1P/6qOxS3+RonaLoTCuPe69wd2QJLzkKOsTWE8KmikOcgsTBo4c6dPj8mry/DW2uSXTLoD8DNAUtX7clXRzo29w4+4m7gr5P60hUDFfFKbFgH6sLzNaOe8ybjYgWYeQa1RoJk5J4c7nJr+9k61RqU5oMPHqkEv7iUM4oMIbQrUmi9ZAp8a/fQAkZQp91e9eQn9M/QxZ094vZ1aDcnkLNIg2ESCq1Wvw6aYVpZ+B68IrgK8Nk9rtv5rL40e4gv8Jb8gsuUyW3Y2sHMfJy1Nu8TDhInrBMNoqAiNXna564F/wHgayhaqluikXXDO6TrX8z9ArEg1yQBG68MJXOzLbUGw0TPBqzO1GxuGROuhJhvxHxfmjnAcaluRxYMmkYiNFe/mubpaE/uux9JWmcfJ7hfsPL87kDRQp64dpjXRmWWS+UIwxiZNXkdJ9CQ2xL1NWbrPpQSF5Fn6ODXeIzEkRjL74KG7Z3FOVwABkY+0Hr1pTQ5rERAMn1cMW9YYczP1rsDTD4+7VqzWZrewP7bQz+/APW7F8G3592BFsdOcob60+birrmucB1o6TFlnkIEoDoMgWPoNAYXInyRHwaeVH3VoD9+mVE9VjDo56ps5p41gRCiykKBKFi6zWNQULPi61allYXVaZjPeCObecNCnBggjkjZsnfB3bE7T1EDJGnNj/Cgp+qi1S5mskEzr/+VZEMH3pF/GIpZX1AXwUVBaDbs2Q7nZZBcligP+7NEZPKXw/Mx9WvJl+27BX34EeKd2h7soZzkzD8ByoRPIiCckESLPtyNHkPHhhuaW3uEHNFDPwecYYMQYxmAN6OPw
 TWxUi1le
 UjMUtETPaDoIsT/ww6ifWEyKFwL0pHbB4wV5Z+tf4hNO8UO1o8B24FygbrB9a0l6JwEydDdpBX7E1g/gzKbwvYcGD42/i/iKuFtqqmgHE3F/v0VB5+b3UZTbPc5PKQMifaNyrqGxdvmxfdsgPXSOq7d89fha79iVYf3sfP4FQGoG6PpJi2ST1TLebWEjS2oq1xEGuT77IT3HTkGNoIeeS1UR6i9JIXM2wh0K0cpqvXUWsv8cm/DHyOKDGqHwwJwzvFinSVOOqBPQTAwhFaIfkLpvoJjf4w5h6dlMNb8MVpFtGSKQGzoHVCOWmBlQbH4XeT0I/66bh575dJbhn+wjLDZXNCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In section_activate(), if populate_section_memmap() fails, the error
handling path calls section_deactivate() to roll back the state. This
causes a vmemmap accounting imbalance.

Since commit c3576889d87b ("mm: fix accounting of memmap pages"),
memmap pages are accounted for only after populate_section_memmap()
succeeds. However, the failure path unconditionally calls
section_deactivate(), which decreases the vmemmap count. Consequently,
a failure in populate_section_memmap() leads to an accounting underflow,
incorrectly reducing the system's tracked vmemmap usage.

Fix this more thoroughly by moving all accounting calls into the lower
level functions that actually perform the vmemmap allocation and freeing:

  - populate_section_memmap() accounts for newly allocated vmemmap pages
  - depopulate_section_memmap() unaccounts when vmemmap is freed

This ensures proper accounting in all code paths, including error
handling and early section cases.

Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
 mm/sparse-vmemmap.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..a7b11248b989 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -656,7 +656,12 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
+						      pgmap);
+
+	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+
+	return page;
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
@@ -665,13 +670,17 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
+	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
+
 static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
+	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
+						  PAGE_SIZE)));
 	vmemmap_free(start, end, NULL);
 }
 
@@ -774,14 +783,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * The memmap of early sections is always fully populated. See
 	 * section_activate() and pfn_valid() .
 	 */
-	if (!section_is_early) {
-		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	if (!section_is_early)
 		depopulate_section_memmap(pfn, nr_pages, altmap);
-	} else if (memmap) {
-		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
-							  PAGE_SIZE)));
+	else if (memmap)
 		free_map_bootmem(memmap);
-	}
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
@@ -826,7 +831,6 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 
 	return memmap;
 }
-- 
2.20.1


