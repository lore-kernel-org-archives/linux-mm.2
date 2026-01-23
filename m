Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 111B8D7234A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:23:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 788B66B043E; Fri, 23 Jan 2026 03:23:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773F66B0440; Fri, 23 Jan 2026 03:23:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 655136B0441; Fri, 23 Jan 2026 03:23:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 513876B043E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:23:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4ADE51A03BC
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:10 +0000 (UTC)
X-FDA: 84362538540.20.B8000CA
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 778FE80011
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jnsPatYD;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjszNGqHfA22eaPPL9vpz70+uk7Z7KgIqX3QyklITGY=;
	b=Mon2saD2hTLqZO6Kz1YU7ILBeZjyNoVjPbR+z0tj0ke+gvE+6FqH1POG4I38wyTvBxUZXF
	xrRNhodxmdWIno1/wPuAmyEMtO3PIokjKTQcQPaK0e8rKwMX6OT8JaM7FvCrb/ATaV+bs/
	F50Hm9jg+PjpyS2MflPj7tmzww6BDs0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jnsPatYD;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156588; a=rsa-sha256;
	cv=none;
	b=UzhU+ZxX5aegnR29K2QtFyX63ASXrXCeqZzqM3Rse5NWQ4IT5T1vGzO8CypEYbHnlZCR3+
	FszvPB5GPUIGTOcgHMnL1u4heGbJf86n7CdWYPTtLNzo1H084O8OosKBkRl7QIukFirj2g
	pPqbOYKK2v0hfmN0cekAnH1mVR/uuJU=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0c09bb78cso13353435ad.0
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769156587; x=1769761387; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UjszNGqHfA22eaPPL9vpz70+uk7Z7KgIqX3QyklITGY=;
        b=jnsPatYDk8/IOh07kV/c5VlixhRWiZ/tYMs+tz1KZtNWne7zf6fcIDOv7gFP4xKGeh
         Ty0J2YH4HtmfNKUrdqO89CswMy7FqiPEFBqsNYp5K9XzQ2VA+OCUtzf+6EIScd7U7th/
         7coT/0jWCKCX39bDxnxHt9HQJZi1REa4wbOu6/qRnnsCACH6FRQeH/qfXfY6/WWZ0G4k
         P8L6lbYHULJdoa4EyxUvEKsJywQ+/GIcHhL9qbcKMC0fHo3CF3H2gVy3EIV2wNKXNXMG
         bw76HoyPBoWUN9OpxYb88eGbKGU5T45yvndkQoo/6MwglGEIZPqgjGkKIDB1zNMtZiKa
         W94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769156587; x=1769761387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UjszNGqHfA22eaPPL9vpz70+uk7Z7KgIqX3QyklITGY=;
        b=YxP8z0Fi29mdBL/PSoHG/Axa2gaOO25tQszjZ58J/nr/VwB1yg689E5VOOkI+AETxA
         juZDW0/MPnTBxjWHRSlY/dvwlnd6cIz8yuU1itqQYUTi7TUNYeQCoErDnYacP/mcZAj+
         KIU3plUMfwXW9opCRUUKbvRYL7EkraQt+bttt8LeRHTcjKZASmzDiJWmJ7Se+4U632Ou
         qFUYsbK5rlhAbvG/CaJghdZk+JCBKzBiQ4U3N89JhoUgVjxlGdpEOnz/L6RJuolUEdki
         8bmwicE1lCURZfqFpjMj/n7O3sxG2DZi0oDnIqVeEsmlAbUWlzSkXAMr1xWbwe8By6bG
         FnQA==
X-Forwarded-Encrypted: i=1; AJvYcCUVfMKp3zIL7kTgvIJ7Ocyx5g+szZQJqjbQVZXCRUIQK3dgC/tbxF2Gx13XGI73gh3pbtmkCC1vuA==@kvack.org
X-Gm-Message-State: AOJu0YwtMnvDrozFmXIRABWeEvMx0Hb3eT/44HvFaZ+ECvgRVW9VdACv
	LZGYDOQWA2Joujclqf6ldAxsF82cJmEfRRH/i2iWga0efLo2xFMKjjYU
X-Gm-Gg: AZuq6aKtMVS1zpuNhb4jkZbDqc7XDh/rVtXpQXGay9HNVYJCMHbxXYt+8Yz5qho2aHR
	LlIJtKMaRxQJqMdGZ+BLIxMP2/DqD5neIX/prwmgA7EbBuj8uXoklHi0JM7DAs5vn4yEQPq2wy5
	JLZI7ZPOktLfHZ1QCQFN8CMWdWbNjNxPn4ghEe0NCET3RR0YktIdjDtAkujsMZojAZYBrKUOWSG
	4LqGps5bGmBzskCluZ7+kfllRxihSatAjIu1s/OTude1S1KgQQ3TXCbc1gaLHuf31aBPqy3zNjG
	180XIgEqU0CbIvUg9+4G0ThHpIAOMwnuS8SAqzbK/GJDsgw6qbFkDkPtPrYzNUQtBzXTaLNVyXF
	nWhMdM8SqSF1MzLpPvhdLafr95NNm3dILflqkISBTMebC2zD4qt/Z1kiz/jOGmafUCAEeisTsCY
	lHNfGyMkQYBxcMMujsvB0qo8RGiwa9jOK8m1A=
X-Received: by 2002:a17:902:e546:b0:2a7:6289:faa with SMTP id d9443c01a7336-2a7d2f05e2emr56904475ad.6.1769156587238;
        Fri, 23 Jan 2026 00:23:07 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c635a43f11csm1348363a12.35.2026.01.23.00.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 00:23:06 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v5 3/5] mm: add folio_test_lazyfree helper
Date: Fri, 23 Jan 2026 16:22:30 +0800
Message-ID: <20260123082232.16413-4-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260123082232.16413-1-vernon2gm@gmail.com>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 778FE80011
X-Stat-Signature: 77xmubqazqukui573fxahm8mk6bascpt
X-Rspam-User: 
X-HE-Tag: 1769156588-717285
X-HE-Meta: U2FsdGVkX1//7k1gkgc51ThbpAypFZeYXA9+XuH9G9z9oqygGVgoBI9c26kaJ5wgh/VZP/mVYxcOcvIdj4wxpRt/CvPMw8mAlW16ujuCbay08jHvTbsH+MUA6RZhxGKcBhHJ/7iQLj980tcpE71c/JSli4T0PIX6szDNuEYUm8ES6IY6qiQOqC7eEKeZ0ULLxiR3YBlVVh8KUv5Q68a98dSRd11FOJvdh8LGjksB/rDlZG3ZmvYNhGEOAkAuLGhXq3of1gsiCNGKyKIxjIMaMqHRn+rYM6pZ8ksq9v4vpG2bVPz+zRKUg4Y5nWyaT7DMKE+eUvIAY4mhX4MLfM2kxIv0gEvCqGSOgvIgAfbaYHc4RhKWHfk3Fdr1mHHcTS6jid57mgvgD7Zxd2sx55zld1F8Zn2lbutumguoKL7Gxp798nHxNYzmR3gR6o2JQoOt2NuLPkhkw+xWaVNMlniH9GV1ohPVAlkkYrA462I1Tkajc9q2YlGtpZduu6JW3Oamko8Fw0P2RRkUWHdQmUrpF6HZj8tBag2pNnslyrTHrOMUzi2tbaOrixnl0TTIYl+0lmnFCRLcz6HjQt6sKlncMgfMiCNzEU3oXSssp6pW2tYXIPJIPEo3Hj8fhcRSBdjjoh6mmUNHGzLwYeIuTWRKIbyNrRgHHChcv0n03OR2PmkMBJY+s87UEZIuaaztWT6V59pEOZBybRzdoJu3go93hgt1Zh4/sTjG6s01teEtx1vnBi0Mj9F4pZCkpXgCfZKha3zV9JUIf3P6s+FzEfbFlGYwcqgRNvV5tvULuGWFDoiZwnehaWmBG4yoJywqlQN4SZ7u0+b46J2UUiWPQxrBHgdWsS/8igknu5fV8ZAEIenmEoFO5wtpELBpBXgl7wjSEanY/mg8LmvAocIyuMPZlxBSnMNg+dhRGhnWDcMd3cu7JZvuVrRY7TdLlmpb4SaZ0iVUT/K8RCzXAAls0SC
 5TJZYryO
 wqPQ/Ja/IzoSf8jcm841FulMI61K6ir/7CBQneOp2cKby5JT3jF1XdMa8kRAlHz6z8xTX30tLQSZCXPJiOiQ4/vRsXk1txLa2FYpIbexo70aYcCNhfpkzrqGqUNawMoTedvnoRvu6GCm75tgP10KEB3D7lXUhl168Q9EjlYbdriI1wtW/UVju4K4EzFuINpgPFc34JZs8bzcyVzDChxLtxa3xzoL9jiZL5FCTVdvmQHvMjBonUnQRiIipmo5RUonVPeoHexkH/Az28UZm40aquZc1ubUR0i2xYIPD+wHrA8mWVWtBsRLw4A2YlDLCRyyTOZ27dlYGTJope0dZfJVAp5F8AQ3MW2R/JI8Q/DCT/w/bkHWxuNdKpFEua3fdvh+0Hm/1dW3gTZqKnXfMGiXhp1r5/9ZujhC3Ztt4co6pyn3z4kd2F0NjcuXqBo4VFnrrL8DJfCXRglycWPxmw2pnB4HiA0Bg7tC2V/4sW1qvEMxYum5Z88sPS7shOK6CaJJ0ecZ40tgJF6BJGIa3Z5cJbBV6Fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Add folio_test_lazyfree() function to identify lazy-free folios to improve
code readability.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
 include/linux/page-flags.h | 5 +++++
 mm/rmap.c                  | 2 +-
 mm/vmscan.c                | 5 ++---
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c73..415e9f2ef616 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -724,6 +724,11 @@ static __always_inline bool folio_test_anon(const struct folio *folio)
 	return ((unsigned long)folio->mapping & FOLIO_MAPPING_ANON) != 0;
 }
 
+static __always_inline bool folio_test_lazyfree(const struct folio *folio)
+{
+	return folio_test_anon(folio) && !folio_test_swapbacked(folio);
+}
+
 static __always_inline bool PageAnonNotKsm(const struct page *page)
 {
 	unsigned long flags = (unsigned long)page_folio(page)->mapping;
diff --git a/mm/rmap.c b/mm/rmap.c
index 088723f909e4..6b09be06c707 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2049,7 +2049,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+			if (folio_test_lazyfree(folio)) {
 				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
 					goto walk_done;
 				/*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8643c0fb9162..1f32c74ec738 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -944,8 +944,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
 	 * They could be mistakenly treated as file lru. So further anon
 	 * test is needed.
 	 */
-	if (!folio_is_file_lru(folio) ||
-	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
+	if (!folio_is_file_lru(folio) || folio_test_lazyfree(folio)) {
 		*dirty = false;
 		*writeback = false;
 		return;
@@ -1489,7 +1488,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			}
 		}
 
-		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+		if (folio_test_lazyfree(folio)) {
 			/* follow __remove_mapping for reference */
 			if (!folio_ref_freeze(folio, 1))
 				goto keep_locked;
-- 
2.51.0


