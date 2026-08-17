Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7B54C5DF74
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61CCE6B0132; Mon, 17 Aug 2026 18:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1FF6B0874; Mon, 17 Aug 2026 18:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EAB86B086E; Mon, 17 Aug 2026 18:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5236B03DF
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:08:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C655120950
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:08:24 +0000 (UTC)
X-FDA: 85112150928.15.2B4C6C7
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4723E100003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:08:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DvYghsS7;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787004502;
	b=cpvhC+olaoa/IWi49kMQLBPgzfpSfalw2RaOPPU1nhR8Uf6BtOBRkj5ltD7pZ4gOLDZUS1
	LbO0bSwvOODW/Y21uZzxNOYNWFDi1O0vxd9ZjSOpqPbXsH8nBC34yLg+CebB+juC9YqopJ
	rrnNBcsVEOdQ7UcgdmOfix+TAHA5hp0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DvYghsS7;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787004502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oLjt6fqOYQqPl3RBDaIWJlYyCKzqU8AbAXeHyMH4wI=;
	b=hBZEFLHMa0YD4hEHkxgpaxpD7SlCfrDyGZjDvHz56i3LqrxTRyBO7vGkquYo/fhg6NPUVH
	qPQ65+vl5g8pzdsFnBXl+X78UzORr9kw/+LZDz56HBUOO/vo0TdOXhkf1kIE8GiJiyYsES
	c9TEGjNyzhRDvd24UqPNVZJN5+b1DzY=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92edb12cdf2so327758985a.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787004501; x=1787609301; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2oLjt6fqOYQqPl3RBDaIWJlYyCKzqU8AbAXeHyMH4wI=;
        b=DvYghsS7zZeppHP844FhDCmlRL/EPuHhWf3xS/pwMYoOyqAPjziEOTbILddV1YqjUf
         1n+3zIGt3VOVkguZycCwny+apPSNaNN6WJKo6UCRCRai2ko54FieFRzPm+qdvYnQdW/8
         TML6EjUY1VLL+u5gq9bvKePqfGELBxmNk53s0QRmlvh+d0m6DLwQFtwxchVCcTfLVBQF
         DTQozIx08vD/0LsXKesZ1zh2TpIs1P1tjBQ62oqHOSXswMr8hOhWsPIY4DBN66yy+Cd7
         UhQ5/D7w14fgX/TMH5EshEFLvd8M1SD8+6Ccin6dUyXYbtWFi28fOZafoEX/t3AYRfcE
         n7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787004501; x=1787609301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2oLjt6fqOYQqPl3RBDaIWJlYyCKzqU8AbAXeHyMH4wI=;
        b=apMxoabat7jUOUuFIFIK2VBy8OgdMJW5c10SD43zfIEnb+TMmIhj0ND4QdJYPCM2BY
         RYRZ+i0QxZAtUPdTLc207UCaF6mDkZpRo14E6CZFOluZ88SLtTH89ohfeeBpV+IcPn/D
         wuHRyNgFcdHTu0XpbRWqrDSgfJo0ZXC94Ikfalft5vgDUKBUhXxhleBRK2GRuVUkF6dV
         r2pZpniYBcia2OjTXCx9EUbug6oT53PIsnfIds0rvl61PBd7Dg7oyEFCY7XUeL9OR7hJ
         LhloD3T4qA4SkrTpFvYzU1giw72O4FF8t7yicbr5kOO7ZAIHufzPR3PCRKcSYmBFAEB5
         77ew==
X-Gm-Message-State: AOJu0YwNC9Tb4izaxdTmMXKXErKvEg2Z/Xz9v8yyILTyF5uDfk7LMUdE
	oHsHm6VO4ZQivBV4t/857MXcUS0ok5jJ2W/7KhHV1VeaaCd0cPKOjJF9AuVmTDzpNM+c/p0diJ4
	pn1lJ8IQ=
X-Gm-Gg: AR+sD12pICgb9Gq7a/67wne06jaSyt7FEFREuG2xxxs81HkxRjPG2feiVgDDEee0TyE
	GX/0u6LQCt1KcdS+YG0FRMYVxPo/UfhnARaFrjm7bcjzmiFpWnr1C+j2eKzqm6AfxY1Q8ORRlqX
	Si8+RIIKHwKJFDHzVpM7h7mfnh/gJ5wPgP2OJYQuJuTMPOir3XzddmDiuhmJ08ICdW3aZzqZGVs
	lPh74qg+oYQkdSMpPk2K36gEGdhe4oLjSXMRTS71NMKpv72aAZeh6cDRJrYiiVK3mSP/eENM0Ry
	FglN83UI2r95ETJsEC3pTc3Iccp9ALEfsV3+6h9weFXgqNA3jT0QIuIt8EWs5wnPx7JUu7KvqRs
	CGkNwrj7XTw39PjP6DN/YQyadGKrkxhjD7UHjV4MKo/LB/GBLvahW1j+cReAi+TCgtdgBuBQrCd
	BDpQJaKriFnK0qGwJXkFNccyxbOFgm78ICSuTDbe2wp5L96zlCkxoejXEm3fsBEZlc9Etzcgj5A
	WEZkTwptJx4UGuCDB8+7XGm35XxewGfD1VP8uZtcOzVx3+rnN3WGYvY4jhe8A==
X-Received: by 2002:a05:620a:2889:b0:92e:7cc9:a888 with SMTP id af79cd13be357-936d1fd98c4mr3001265785a.2.1787004501326;
        Mon, 17 Aug 2026 15:08:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937033ce78csm147108885a.31.2026.08.17.15.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 15:08:21 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	stable@vger.kernel.org
Subject: [PATCH v2 3/3] mm/mempolicy: skip zone device folios when queueing folios
Date: Mon, 17 Aug 2026 18:08:10 -0400
Message-ID: <20260817220810.1175596-4-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817220810.1175596-1-gourry@gourry.net>
References: <20260817220810.1175596-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4723E100003
X-Rspam-User: 
X-Stat-Signature: 6ke1eyodg4p8ejfxdbtx9yfifkq7tjjt
X-Rspamd-Server: rspam06
X-HE-Tag: 1787004502-411205
X-HE-Meta: U2FsdGVkX197JLQXmMBVIRpviSLKV0ZRAVLUKM690AjqlTRdCJ5kGlJ7QYVLbRHsbHDpGULQtYvyU/BTmA0GGhx9xxtxDySwNx0fK3DGMTnfwoRJmG+Z3vRtdkZKaYdZDHT8wOAbVr8Xpj4jRLsTKN7GnrV8LRm98AKNA4zB6IrETeSEqhe7SeYGkvaTtLrl4khocyX2+Xh81VC4NWyfDd6E8hvIKEMQJAUbEruAom2vL2yVeuDvw2qX8UER1i204HkO3hVtn2pQ8FhUkzWphtmoJCw2FkS8xRROslOS1p1GK1IbaxxacbcImCA5k5gunc/fvGwZay9LogNthSR3xfSaprMWmH/oZ4veADqhTtNYCUg/YH78Tq+GSMU7oc3xwRfxUZFDAl8/uJVNUjW6H0lpExcKWs05LpLmxj7JXiQdxHq7Og/LEPrzKNS+xDiOLgUjIg7cfBqQbOvQPlDIAEsW44BDfDwUYjcbkZUIHzhNS/iX1QMSyYvJxAgVr3qTi8u6vWFJv7b1dhTJZdLNFLLlC11WBUBoaNLiXiU2Z0qcDmAaUDxEQ1DoNS7dFem9/tppuohCaE0lYbFxAfchTaXkLoBInVJEwYHFgJ0UQFCBjnHCF8WEqy9W/NhH+V+1eMuErptLogApD2ULOpp4Qf28wZ3vbu/KwUOSvyCK9/c/IYPKCVc7/IkHcuVYGkaQJQBLkoQmuihfHYQIBzmpWE9x+8/6U446XrfB5BYPP3WKg4OfLDUThIvR9sjWuEQGXr8uYgReTX4s5s4KsG0tjOKVTgIg519Jp05Pn2r52uWn9z/LwzD0xDpJueRbv5yOVODcZaVpEXcQZXTy2Gfcp+hL2uYMU/GLLbRo5/grYDAzmXln8eXEGmzWg6hVC1XhSy0Q7yuUyGSWxyaVFamhwxZcbbP9E/rJB/Biyihq8lHnzI1trWjaz3ybwBXr2mq4H2mIVtuzhh3goZYajaS
 4FmXkCOj
 TBZ7Nc4N/j/hT1v0vQgWNvfdhEO7IwH6mxfUJm/RIE3g5L7UZWEGQ2nJv/SYzoOxsIb+RlPqp3VzL/rjgshz0whBhZX+UeZczxx4PQ35D6ZJaCLYeRASpbn45JNRit6jkFV79IdSaTGtLQDhpaUw4ezAzDMsnbd1f77fbVZZ+6T8AFCfW7evcSExGoHtyVkQcI0/2Vf843hndgvBpFhHC3QNdrIR8HGz5kKgpTeDORrlOTQHpzfwfFpP8pUQihjjLV6cIUaZSzMXxgWzrf4guNlNY9j/QiaGP7z9XPGs1wxEP+K2Dg25qrlmBOs7+WT3mERfmo51smgfU9O+i5mA/ikiEIxzrfLrOOQzrAkhOo8Uvb8DzJlrxToJSln9NMNyto5QsdmEu/LXgn5uCFFaUTYc1Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

queue_folios_pte_range() already pairs vm_normal_folio() with an
explicit folio_is_zone_device() check before adding folios to the
migration pagelist.

vm_normal_folio() alone does not reject zone device memory (a present
device-coherent page in a normal VMA is returned as "normal").

Mirror the explicit check in queue_folios_pmd() as well.

queue_folios_pmd() uses pmd_folio() directly and can encounter a present
zone device PMD - e.g. a device-coherent THP.

This is not filtered by existing checks:
  !pmd_present()   - only rejects non-present device-private and
                     migration entries

  vma_migratable() - excludes DAX and VM_PFNMAP.

The early return also means such a folio is no longer counted in
qp->nr_failed under MPOL_MF_STRICT.  This is the same pattern used
by queue_folios_pte_range() (skipping zone device without failing).

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3498a5651d50f..3418b5664dcf8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -662,6 +662,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 		return;
 	}
 	folio = pmd_folio(pmdval);
+	if (folio_is_zone_device(folio))
+		return;
 	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
 		return;
-- 
2.53.0-Meta


