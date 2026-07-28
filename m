Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B515FC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FB156B0096; Tue, 28 Jul 2026 15:47:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336E36B0098; Tue, 28 Jul 2026 15:47:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FEA76B0099; Tue, 28 Jul 2026 15:47:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E530C6B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:47:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62F7EC04A6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:47:25 +0000 (UTC)
X-FDA: 85039219650.14.DF1771E
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8D3EFC000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:47:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dflYIAoJ;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785268043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJ+l350a6OlsWiNiaSEE/Z8jsj56ru6jIVfVE/WM2fo=;
	b=cptM8lREL/kVDdkvn0lJgS/2WeIs/C8UmjAQOntGzqPgFQ5+kM6PGg8ItSgP6z+Uh93WDv
	9ueNstD5CQ+x1x5csLC319Wn71TQvgTN5I7tzic0JkkXNkmB7PvWxSSXS89l04WxpX94Vo
	40BBNP84Yek9kBhpOshwc/E1Ease/eY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785268043;
	b=j9OtupiuOHZg7Kr1ZxKrejVnfxn/Sd04hzsTzHv0tc+jkCbZSkc9dPoo6Y7JqJxoN7tkP0
	38rZbZNhslgT5xiQI643Om5r5OwDJZdi+BbARxw/N8x4NaIwKQ6olhMYB2Tm+6m5OHuBJu
	xtyWxfbsIKGo/Du9v1e/1DgZmdYN9Qo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dflYIAoJ;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8edda5d56a5so1735376d6.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785268043; x=1785872843; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VJ+l350a6OlsWiNiaSEE/Z8jsj56ru6jIVfVE/WM2fo=;
        b=dflYIAoJ/9xNwXWhVaZWWuwfoEnPULq6XRYumTLmb09C9SlsMFLp/reMuT4actiuBT
         CVjZvrSa+cLi3185KLIrB+fmCKoqneH8tTkO9ILhjUBFiZRU+Soua5W3dg1FeTDLYqcz
         JPmfIAGpfwlYvbOebAHA9q70U5AiuvR4k6IhPcaXPt5QCxyuEFX9xHOGCGhnz/DXmRz3
         5/ABQQRhgwXojlO1SmbGtgTsz5gCQLve61k2HFDmsc/n0F4jXWIeTUcs6OWjFedJ6VqA
         QhicRuKtj3Vel4v5lWkUKazbHBOp4Zonh9M/HIfFrw0NNUbm0Am/ZnmbkVZN3xAJQZdp
         m1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785268043; x=1785872843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VJ+l350a6OlsWiNiaSEE/Z8jsj56ru6jIVfVE/WM2fo=;
        b=no5Ge4t1GEzzEoGx1p4rcElE7ZVKe9oiXzoOkUiFmd0M7b6ITtHD+TmRnIWPK8999L
         O3LaG7uyLf0EEbxIXIFW3+tjWeYQzSt6fN+8xOJRPI8yKX3i58yPZpC9m69okbJnzhuv
         e8Cl9dk5F7EJlGAHS859NZajXl83HR2bM3eopaFhEQgzyzsNQ8NKh55qZpVf3FWCew5f
         dA9SWLRdc3bymaT5St4elQpmojtKHeJmP1FKI9BIlUexKXM9tZfFBbrvb5JoYPcRKhp/
         4lU/RRVQasw4B6BJl9u+7lxzzXJV4jfmFchzEp6NEiXCkqM5YfcnSryEN2warWkiAYWj
         fgpw==
X-Gm-Message-State: AOJu0YxMs335yHvSIkFRPqSzbSQiz4Wc0O1v+aXIkwR3XgPmrrO3pe1s
	rA3vvr8YARvL7o5o3jVu6aUt5pmCoxhNiXKER73qKiTlVsWKA4S7Ikvnq77TxzuTJFmpugEg0oJ
	g/Obu
X-Gm-Gg: AR+sD12HIhgk8+BdoP7HoMf5vH6i1o1ZuOZr5Yofk2A9MBFfGSv244ZLiFkfkbWALIA
	VV3dw6nBCQ7iwW9HVth9LB8Tw9x7n1fSlCgfn2SWOCMFwA9YZEcfVrKX14rzkE7XEX/T0FDp/7c
	pJ2aSZENfSUwPBCtU/T1M4f+g2IDsdv7AstF8iusePGp1WGsvsk1DDfHV5TvXH92tPBsa+GMXpn
	ZGnaeXwAOamHcpJCDOA7GQJZQ/m56KzxxyDf02ilPhmEh1hkV7YpdEhTXQmna6UfTHXZQZYT4Gv
	YsfkINGReyTeCWxnpn9ZvaNTSXMt6eXpd2F3NqTvs4c4jPFg18rWr0FnKnBNr5dQMpZ39rDR9eJ
	8I841Cdy6H66Mmz1wuUQMZU95vV5aWSiXHuQ9diT29mKvdl5PI994NUEVih9iglOsPg8wGU5Yha
	DFl5PAG+Ah2Ag7qMeTqQIpQXKQ3WUkfabAHQvaQvlkWXH48/Sz6pLF0PpbQ6aRdjtfea4Todl+P
	XvZ+j8swGn32W3AV73okh3ZJXTlnj0QgTOBoCIFLsUnriemT0F73Hf6RaFssQ==
X-Received: by 2002:a05:6214:21ee:b0:8f4:821d:95f7 with SMTP id 6a1803df08f44-908170026e8mr41209526d6.18.1785268042709;
        Tue, 28 Jul 2026 12:47:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dd6b539sm6700176d6.41.2026.07.28.12.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 12:47:22 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	sj@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
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
	apopple@nvidia.com
Subject: [PATCH 1/4] mm/damon: defensively skip zone device folios in damon_get_folio()
Date: Tue, 28 Jul 2026 15:47:11 -0400
Message-ID: <20260728194714.3713735-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260728194714.3713735-1-gourry@gourry.net>
References: <20260728194714.3713735-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8D3EFC000B
X-Stat-Signature: npwszwprp63p3mw1q4qh3sjaop6fi3qc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785268043-605898
X-HE-Meta: U2FsdGVkX1/g+9JRcs6sti3oyxoIzY+eD9OgP45Ugx/nqZqH+8Ncjo2b9jpHHfaX/mPodG0KRHUn40jmclLTM0khisoZ8HohniBElManGqQ6gcPRlhWlnorsKoO+jLIcbcnuSFZoZUTgLcflFh5+u/YqGA7NkK06+AcIkQi2KqeSKpraqA+2/c1cp8ox5rPj5vVoMHjznFhESVBFPar8AVfl6EI65AMTqRLDE5g1Rp5T691ie1COgPZPouQU1jyGRiqYdlUKgl2Q0vnlwuaVopxmfOeVLKPU8OJHeB7dahppr3zy7jzlSOc8vbNHjanpfxGi17cqHnLko8JLTjautWNKxU6S8Oa153EN6Xs4ZkUp8lHvBEnfgQKRb3mG4f5Wfybz/Z9gLUErDgASxTnY2kHTK4xAFdPWPuszsNS8E2m8sadzZCucGNWnA8m4I01f8ehJpaOJAfdMXKQSKAKWAf/asdLxcXemLCHVubX3JDfjLby0nGrVXAS5C3+K4IRWRYQmguXKy6QLsIF5fybjtLf6NBrjteE2uh8I1hAB1y7W704AJfcHEHj4TVtSIKMS1dLGwgUc2X1IiMyEymND8iwuaAfSpopaudTEwAHCBgpwyL4u4wC2H4tWL4CuAU6YzlHGAJ4F4EFLr1mlR+Gpgdshhx3xCuuzZ7Zy6MgOj1E9CvmSGotlCCCMQYsVXIEg7CTcOkLS7FsUXz5h8/KKEM1mHcd8U48/+9z/6OcqvBJ62T0tEU2wJ9GF5GNP8YYheIufyGzbQ0dZDCxYk8gLU/u/ik61l6w7iykTqSvw0KseAx7bqKIAjBh+kSLZjjaMoL029BQbU0QmmhKx4j2QB0o4exr9DVXj6lCbksiPZ1Xm2SWCptdEEekz4pgGNKyJFCa2nWNv5y+J+15EyOsFHohTKtG62c2qwnlkQjsAVKZN3vHJLeK/6Gf57abO3M8MuwBo7wcHbEmw4eO90QR
 JmDIgGrr
 T5duIs5mTB7u8+0WU3C8TfF9gfrbnopdsIQpVveZIYRKMxuv+B4VXwGYjgTHe9lyCibT5/H7HNBDptEClXpeBTX6uGz9vAR4rVdAGCYKWVXVPhKrFtFjZJGbisjTN1DOkj2xklmNjx+vAJiHs2w/HsOB4dWqhMN7ILw1tk704JfuJc9pZBU/x/XSH20P+Qzp3s6bMpmrihgzaX0qJXDdm81MNbXtuKJxvmp8mRAhiB92t4EGred7o6V7SzaaAXVyxWyMRL5DXgBi1TZUSFzdA/34KsOILnHgCXNP+U9V6RDf2dDfa5II1775UBSnVCGpz2+Lg8wK1R7OijRWSDnlniFoTdDMJGACsDnFlPYeUe24zLUQvBjZ9TX7peig1R5xYpxXIjvE5JmnqVfrsenFn+dyPDT4PACm3iqNCGkKgYdMU+Yc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All DAMON physical- and virtual-address operations obtain their folios
through damon_get_folio(). That helper already excludes ZONE_DEVICE
memory implicitly via pfn_to_online_page() and folio_test_lru(), but
this is inconsistent with other callers in mm/ which test explicitly.

Add an explicit folio_is_zone_device() rejection in damon_get_folio()
so the guarantee lives in one place and covers every caller uniformly,
consistent with other mm walkers that reject zone device folios.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/damon/ops-common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index d7d7f100389b..d8bca7355b4f 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -32,7 +32,8 @@ struct folio *damon_get_folio(unsigned long pfn)
 	folio = page_folio(page);
 	if (!folio_try_get(folio))
 		return NULL;
-	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
+	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio) ||
+	    folio_is_zone_device(folio)) {
 		folio_put(folio);
 		folio = NULL;
 	}
-- 
2.55.0


