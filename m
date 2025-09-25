Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 198B3CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688F18E000F; Thu, 25 Sep 2025 04:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611B38E0001; Thu, 25 Sep 2025 04:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5018D8E000F; Thu, 25 Sep 2025 04:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EEF88E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:23:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0163B8658A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:23:52 +0000 (UTC)
X-FDA: 83927084346.29.4FE34AE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id BF9D2140004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:23:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WBRWDD0W;
	spf=pass (imf26.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZvnS4t8ULDy3oaZBxZU8fjXxnnSXaMVp56Tg/MX2OA=;
	b=lVrxogWFTh698qGPYhswpLiSFTUFwVAhmbu09VLrSTDul9/MRaRK6W5njMegLi9cT71XVx
	sKDrri+oiexqnEZeQqJnW+otA1l0grZm1MLpV1srqqlOUFrnGEpPP+qY+ozjfnGORASqPr
	SC6eFrdAfAC4vS4lkzorSgb+xFMM+p8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WBRWDD0W;
	spf=pass (imf26.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788630; a=rsa-sha256;
	cv=none;
	b=iBNuqBeqE/IEWKFo1ou1IYkUnYmlqfuJ3bXrA/bQXHIFhiMjONmnZHTWgSRVhV4x5aajZj
	uJX9PDUm8qjijIMUxQQbwsHtwj0JQk3lpoKTM92cTg9sBu4yiMrf9z4LiU0YVMgBdj0+kS
	nWqoHMVQXLmd9okoFaN05jqZ18U7jTw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758788630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ZvnS4t8ULDy3oaZBxZU8fjXxnnSXaMVp56Tg/MX2OA=;
	b=WBRWDD0WwGhzaJNQ1S34vqa3gylrNPGU4/2349Oz75Ty+Xc1oQa1U/BTLWABfZE1Vax8Gn
	WZNdJ07n8efEPC1Bh1p7qD+ueqng2DwaNx/R2QSJtxa/56l8YcXqspChjhMAE6qXRKAbq0
	7DYnoF/blEyTXet0SwZju/1aq1FSgb4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-IQZbcsnZOuahGWthXmk0cg-1; Thu, 25 Sep 2025 04:23:48 -0400
X-MC-Unique: IQZbcsnZOuahGWthXmk0cg-1
X-Mimecast-MFC-AGG-ID: IQZbcsnZOuahGWthXmk0cg_1758788627
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3f030846a41so459006f8f.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:23:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758788627; x=1759393427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ZvnS4t8ULDy3oaZBxZU8fjXxnnSXaMVp56Tg/MX2OA=;
        b=squr46ZWwa7Sf2g9Hxei4pNwe9HbanCvEi7+VDBAe07K0BidGO/vQC9vnZV1UzgKZ3
         ClUsFeWh0jLUV7MC0imAeIL6paMtk4BDUXhHBTBuTr1irQe5LilNkfTl4sg4xbL4CqAv
         uiuVoL3AV5rfxQL47YU27937/eYFX/oT3W/AsqMRGaUHWUvB7pPLJBcS85M2foQ8C2pW
         L+l3K7090dcNtthHZ1baOK5whuniRBfAIzJJ+c1OUzJWqtWYeNs89fNIcVClrPFMiOyk
         T0S6ekiiRmJk2UCwF+GmmhQoTyeDbLc7/HEIGAdTgThwFfl383BaCpJX+41M3Oezbdca
         rPUA==
X-Gm-Message-State: AOJu0Yz79UNs0+b8qMryDTht0VlRjyEZ7E0YnNiYMzqLicXrx7es+XuE
	G4NScP8BBZKh4RmjKy4b5yJfXVv66nqVKMs8PJeDhDMMtiAMVD4mepGftd7VOEKAtuvflI5/Vf4
	9ANlXNCS9wPUfrIruK5XwJzw7PNyTnW69BOgmY+Tk2L1xgbQTCbh1NI+HRizt
X-Gm-Gg: ASbGncuWsnut4KhhFY2P14bYUD4bcZp6LgKzTCuyuUzHZhm/pJqo8SSOSMjvVHdzGM9
	H4mZP98VABR3TncNgu2Cv7uRVt/BN3L6symSqexoFuZCj1QTfEUg5jYYfczru79/Ex8Vngz14+z
	09A46dZmERWM9yNRNqHn1uDfIoiJkFev6Tjb+0q21m96v/kfocx+yBgEpIat+KzLObqu5ACGYHY
	32qtdB0sXi4gzL7c0ILhBJ9QQDFaQbPbsAnPRTvt1CE0U6VT7KCUlLh1kmy2CRBUhWu91Lvm1+R
	efZXWo6aQHthF5KtQE9KLPUwmpj4/INR7PlkZjeamlAPbLLr5g509dop+e0sNNm29Ij3ybXbuD2
	S/yEcEMeXkp9nmGpGp/UKy3/yPQ==
X-Received: by 2002:a05:6000:2386:b0:3ee:15c6:9a55 with SMTP id ffacd0b85a97d-40e4a05bc72mr2223502f8f.34.1758788627200;
        Thu, 25 Sep 2025 01:23:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEm90tVZvBju/h6968L7JmuA7sRhW0+B1DnSBTpqFRGnLb0y8Ms9f0kgjcdG7a5Y11nOhUS8w==
X-Received: by 2002:a05:6000:2386:b0:3ee:15c6:9a55 with SMTP id ffacd0b85a97d-40e4a05bc72mr2223482f8f.34.1758788626789;
        Thu, 25 Sep 2025 01:23:46 -0700 (PDT)
Received: from localhost (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-40fc6cf3835sm1918420f8f.46.2025.09.25.01.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 01:23:46 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 6.1.y 1/2] mm: migrate_device: use more folio in migrate_device_finalize()
Date: Thu, 25 Sep 2025 10:23:42 +0200
Message-ID: <20250925082343.3771875-2-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925082343.3771875-1-david@redhat.com>
References: <2025022402-footprint-usher-aa6e@gregkh>
 <20250925082343.3771875-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MtIcYI3z-f-i2PAL_6dCpq1PxG6TCVc1tbLVhB7LMk4_1758788627
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: BF9D2140004
X-Rspamd-Server: rspam05
X-Stat-Signature: yg5qp6gy1iust844863ga6qwb87yiu4w
X-Rspam-User: 
X-HE-Tag: 1758788630-197726
X-HE-Meta: U2FsdGVkX19rVwh/i6SZxD7W+oO/a4Pg81NtQUIkUcBHr//xqOPl+aDcO8OBB3S/1XlwUp7uoUxB4LsyzJZ/s7a6+n5bCesN1itoj22FZjweH2BzNZhxAZYN8KOHpBv3tSJBDaTBlpRab6usFfT5jhsMooteLS53Qi2yyLGwu6ZHNp6Oqj2jzp6JIcAD66aFVnw2gWNSV8B34YQ4RJYGcDrHP+g+Blg5M25jiZbc22WaipinBVKrMginwlnUPI1u05lSGYmhkzlUjsI4XbaG/4Kfb8WFEp26Nfw8jBhXFhCxumQEuYRG2UZ1jPBk/MGdqPQ2aujvSsrI1Z74y4/yUVqKlNokdtN/KGLQ8iv02LGE2DEXy2gEvDRjyAQhaQevGspiMhTaPeAA8qq3fsHzChNKDIbXsaU7OfvGFUHsir3AOh/uD1VSXgMmIQh0DQzDl+IOhxDfN77mPWXGOGve25aHeBh0kLsMpAQbfUFCaDm4Wv2qUp7X+k9nWJM5z2EGnrHEchQ5bY3/xCCVkL412orGhznNsgzY2cRaGWMa0eYpcUS9eGWPVCKAysDpz14yDg9lG7OqbSxYBj7boMx8PeR2bblcnyoRgNN4g2FU5fBEkFE6+z7mcHSiq3TI6b44LkP7fpc3SrLG4opNykF2fS6If5hBn2j+TIr9ITq6m596b96Y7iEd8IbK0mRxatHt7WM75y0qvqUZHH6XIcBgADTk/aCgx4TIUz6pHEVhkqCamCkPdq7QSDXDg9n8QjVX6d1viM4YQ1eXgj/dEZ28AA9C4Kp1j5FzNTr8X7DB6ZiRTQWRdnvMTc0g76AFDilNVkGVjupF6Q0PAEflVAJ9/mJkNFllyPlsZ7CeLYdHDsmmxrWnFiETuVBj1EnM7QzriO4VrqP/mQ16Ml8kY4UVE8WoRxfoGEuyp1rtEbl5/Yl2dh5qSk6ur5GjTUpJBJt2YXhlasrdeCkD0VCm2UY
 z3qKGq+1
 ZK/IZHafuddgrhaCPIofglePWc0+n+HPCeC1wpJpUG8EODgA5bjBlk3AiW+rt+EPboCje0Sf7dAcK5wNVij5H5ZRY7FLGb1ZWHSTIYaSjNBjrBsKS6R9gt1z94ctr3BM5t1BRMoPKCCJqZy+hYXDzQCaDCf2ssgvy4zTQVt0OG4NKwIQl0sZT8P4QbqUkuR3vGSR/LC0bIv8zTFAj+VdVO2qTp60DH9mL7+Es5XP/XCWKTjI6Z7Vilnr+8nqrilsyGBhbPEKIp+ONlyoupWsWERfrkNToGse+8xW6Nw/+SdFKAp03gstUdVBrwCwhio+MdJMxMkr5gQY8bwEth2aL3Y1KEcriBu4Y02AnG5mMfUJCFFW04wyOnohwp8YE9WflUn7BUh3AOHDM1IeP/cvAsaPkbk+1SEle1fyrX3N7DCVqrbqUaRXNCZhnYOqcP6UQlCSJp1E+qRB8pkUet8KpGRv9+QP+mEXlmr+vl1sjkYzSSXYBJLf/J6GWOp6JuhkDjrqXERn2dphucXaPX1PTD5G+KdVJKCVEo63NEgY0YPxESrpL0+Tg936PYjnZp1slHDCYyqbE+BLwMI7vC9E4X78PL1qCnkwMibazRlHgjkrZb74kXkClJ5R9uRYPrMpVB6cqQSbNlkPoifq6E/3y6MzLPSIcumQbiCXQhIynFdmLiqAaNgsfiOEgsZBUxhpcPHpfpEfNMxN8vYRfqhteeU3m9puAevC7a1O/s+HLLJxohtoQ0slR8tpWUOz2Ui9xvmsIGIqWrJZvt1Iy9sNpj/xvom6CNP3swqiM+BSHx0IFMcpRTdLWPlvDBlOV6z0H3OPVLRHJ6gkDiBDzzPDC2MAJ3izw7q8GdbRVHiKk05kpzH1PkNVsRO6z0rl0Wo72yNsh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kefeng Wang <wangkefeng.wang@huawei.com>

Saves a couple of calls to compound_head() and remove last two callers of
putback_lru_page().

Link: https://lkml.kernel.org/r/20240826065814.1336616-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 58bf8c2bf47550bc94fea9cafd2bc7304d97102c)
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/migrate_device.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 721b2365dbca9..180dbb99c320b 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -829,42 +829,45 @@ void migrate_device_finalize(unsigned long *src_pfns,
 	unsigned long i;
 
 	for (i = 0; i < npages; i++) {
-		struct folio *dst, *src;
+		struct folio *dst = NULL, *src = NULL;
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 
+		if (newpage)
+			dst = page_folio(newpage);
+
 		if (!page) {
-			if (newpage) {
-				unlock_page(newpage);
-				put_page(newpage);
+			if (dst) {
+				folio_unlock(dst);
+				folio_put(dst);
 			}
 			continue;
 		}
 
-		if (!(src_pfns[i] & MIGRATE_PFN_MIGRATE) || !newpage) {
-			if (newpage) {
-				unlock_page(newpage);
-				put_page(newpage);
+		src = page_folio(page);
+
+		if (!(src_pfns[i] & MIGRATE_PFN_MIGRATE) || !dst) {
+			if (dst) {
+				folio_unlock(dst);
+				folio_put(dst);
 			}
-			newpage = page;
+			dst = src;
 		}
 
-		src = page_folio(page);
-		dst = page_folio(newpage);
 		remove_migration_ptes(src, dst, false);
 		folio_unlock(src);
 
-		if (is_zone_device_page(page))
-			put_page(page);
+		if (folio_is_zone_device(src))
+			folio_put(src);
 		else
-			putback_lru_page(page);
+			folio_putback_lru(src);
 
-		if (newpage != page) {
-			unlock_page(newpage);
-			if (is_zone_device_page(newpage))
-				put_page(newpage);
+		if (dst != src) {
+			folio_unlock(dst);
+			if (folio_is_zone_device(dst))
+				folio_put(dst);
 			else
-				putback_lru_page(newpage);
+				folio_putback_lru(dst);
 		}
 	}
 }
-- 
2.51.0


