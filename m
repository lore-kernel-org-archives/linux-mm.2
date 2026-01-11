Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1071D2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 12:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2291F6B0095; Sun, 11 Jan 2026 07:19:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20AA46B0096; Sun, 11 Jan 2026 07:19:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D336B0098; Sun, 11 Jan 2026 07:19:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 01F046B0095
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 07:19:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B2E31605E3
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:19:58 +0000 (UTC)
X-FDA: 84319589676.26.78538B8
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9FB48C000D
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:19:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=grM1dBUu;
	spf=pass (imf22.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768133996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EIuAQwNEq1ZTksmpQsTcj8MLTiZO5nZ88SkZX9qosx4=;
	b=idRTn3OPxF+gQkL8w+ZMQiFmtImDuiDL8AZxSk2OAXE4M8pQ97UIgcNVUh7vn4JCFIt7HG
	W50r9TFOyD5rADq3t+DoFqaMXK7aETwV19Jy00hjr5FdOx9sYZU22ywFM9N/I/2KmQfipw
	yOuSDk3COiZTd6vnQFfRjuv7OdNDTfA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=grM1dBUu;
	spf=pass (imf22.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768133996; a=rsa-sha256;
	cv=none;
	b=QxO8V0G8+pbXNWMIjpw9LSpZPXaCEYwrQi8JsR7ngTxqBZbZY3zzgvkX/Wv8DLEeM4N2Wu
	k9svg0FSUurcE6kPDzfUpS1ETjHUFqbnVGDM8FpxbxxCO6qySyFtoh2PIOFfUGFhzYpuRy
	p8bM7kRJsuVxhyI0ke47kQZO2VLo8F4=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-29f30233d8aso37787495ad.0
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768133995; x=1768738795; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIuAQwNEq1ZTksmpQsTcj8MLTiZO5nZ88SkZX9qosx4=;
        b=grM1dBUu790bCz6KX9d6SkN+pVbqFkYgELpxhOByyCrGmpLr+ZWOSoAfIl40idu8Ed
         ZmW6rDwSKBRyOg23kPCdt8hOpkeddA3ECvUG2mH3PU/Sx1FF2w6ZxuQLebTSoTSKwdJi
         TLUnfbIiReNstgUgdUNNc1VzfzfL4ahd2sSAfH5yKbzugE2i/eD5q35yspcVU5dUQ4pm
         iHvs/AspH2zqXW1ETPybz97zkHZzv0NCH/5XzVdhEBd7U/Fnkh9n0FJ/Vm7I0A5x7vR1
         iDZtrPBhF5xHKy49JDNNqMQ894jjNKNM0bsKKYxtBslcwN+1Nd3w7t0/vteImEvew8o4
         Iv4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768133995; x=1768738795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EIuAQwNEq1ZTksmpQsTcj8MLTiZO5nZ88SkZX9qosx4=;
        b=tysTWvz/IwC3AGYz+iToprnu3S6dH55Hxdr6nMMDntuUSaFsmJCicUfADUX6JVqwda
         65ucKW4x1leIC9ZYyq5ByrirSc49p6MnBb2mjKNizdpDPym+0SUxOscGqWNqRfYlJhNG
         pRkg9w4Qoc4KKRkoo90Sevy78NXrjtFLbeS1QhqFmSakTyJ8JpJXn60wpFVSf3qAPxUo
         52fFikdGa48KVH8Mwz4BNqgUmBLK2aNF8vKSe56U1+Dt2Dwct6e828pqKMCxd2mhHwHj
         Lr4bJ7uWEU/h7u0GRnB61Vvk8Xvgx8Juq2Co07J1e0eIuAJMUtExjSjX/b6zvu6Wjyz9
         yl4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUL/f8V54Pilo/cTAgqcozmdDBooN+IpbonHgDA3cefrf6S/Mr3SQzmhoOtVRygWr7CDLUQQdM59Q==@kvack.org
X-Gm-Message-State: AOJu0YyAKvV/ApeAQiAko1BBe1FnPaYQVYfGDlBXEpFUBWniohJdLS4z
	rHdDofWip456vVtCxR2/zgzJz4N/aTndUWDwjvd/rBCTNWXtQ0tTxhrx
X-Gm-Gg: AY/fxX5Hu7iuWeoMX9eqPNQXHvEGY3GOKwWu937wmcuAn3D6Pf0G+yf6ucIt4Ly5IZv
	7kaMCPMwrB9f/oII0Fcxh4a530Id9WRTNd8hpstPLNZpngy18c5jKIWWokjR/1RPVvYdIzfEkaW
	pEyPTjpIwCQrPWSPSGtqgsRuHTrH+0j6duFNzvTYfbHUBIzlGrVA++OzwuF4PG3QRhP1UqNHro/
	c1oa67QiALaLd/EvVYYboLfMtxL0hb3NH9WEIsa7iXpPKa689cNhUwyuK1cZ2B4d1VHex6O6sGm
	STsHlnKfAzpQO0jb4ALEhw2yAKtbu7IB3s+Ue+s6FiiJcxlrbIA+LYVIIr9WKRUUqHv2J4NBcOP
	L1Nbo82PCupiMgg7CUFao8w5kwT+X3F2AhUshnxb4iT3odGR0LdRVTIbBN1dsktW4rOpPqg+2un
	irccZiXt0aAeZJN81+x1Omken89/zl2w==
X-Google-Smtp-Source: AGHT+IG7hx5em0fMnXH4KgBvC6u6j9pXcTSYDThlQSxU918X6KNR+BDgXGkT0wU8NhOuk8XcsmBDlw==
X-Received: by 2002:a17:902:fc43:b0:2a0:ccdb:218d with SMTP id d9443c01a7336-2a3ee442824mr159043145ad.17.1768133995527;
        Sun, 11 Jan 2026 04:19:55 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b07029fsm4877954a91.2.2026.01.11.04.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 04:19:55 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
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
Subject: [PATCH mm-new v4 4/6] mm: add folio_is_lazyfree helper
Date: Sun, 11 Jan 2026 20:19:07 +0800
Message-ID: <20260111121909.8410-5-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111121909.8410-1-yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f9dhxs5zioj6j8rz3ky9rexyfhscjysi
X-Rspamd-Queue-Id: 9FB48C000D
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768133996-807280
X-HE-Meta: U2FsdGVkX1/afXpmrfKPrVZo+hqSny96aPyIBCmOSMRiQsxvqYgim2U05pnqWFSRf4pXU6dELDF6rN9Kg9Hpt/d1d+4qa3ST1jvKk3STaDvJraEkNAjuPutoaVYyRKzPDLYhW9J2SJ3erZYrxzWxwGE+kbHEP/gUyn1+aApBvfXBCn+w51kojlx8/zLBdlUzRh8u5jKYWXcELAItHtNvYFCh8ITEs4ZdxJ1w8QNat0C4JKNs8bsawffLbBRffdasWTsEdHK/Keo9bH9o/DoHJHYwz8lf8Ihb9h8CXNbic0Yj4aSTIGVvgWzxrmLeAQaNWBYYSddsasSkCJAta48hl80XxoVfMYGRZEk+KItV0mWdBpRHEya1psTgKlyozpSY8u4ikdD4yC6VIOk3Gz0jIdaEpILtg37oiiJKXvEz5UcXQPuM0slPFmgoV6uIuTnqgiv8DQeIj69BIntmnwVL7xQS9W7nyY6aHd1SLoKLwqaBopGAoelE1XP/6s8bWjEVPzESDn8iOEzrK5avc/bAlJJJ6EAzgH30dZTVddjDjcK5olvsUysBnqDKT53mSuPBnh6OpnKjZuwfLuc0dMLaGcdhCXcn/SADgz8aT8vYpbnX5NjcA0ydnwxBqt+BlCaeFKg0ElB2qc764yIWMyeqLEPVnT9AFayxr9A3GL0ZAu007MvS6NQF2Ge72t4l83ve3BLZzHIyfrMl8Vc4M2UyIs0Ie7kUCXHSGADsh7JbvqRt2VDlrZTbW1DCuWmEEZRzp8bs7fhVqrgcjj/7S5AIVuK/2N5xukDzWdX6JOHQook/6HLfhSnUElqwFqPp0elUxSyPW9JSkKZDa35o7PP5zDiIaMDPTMJGFsAWssgvSuEacrkdGLEM+Hlto3SFO0A6MugUwyHwRYbb6N/eqQz1HUwDStRDWhNsTiGAeAQ3+7H9Wzjd6ZWxGE0bBRG3fbmG71NnXvpfW/u8msRV3mb
 4B6tgSvH
 and5Y2lCYbGiy2V6RvzxRSBkCTv+Dmv/n9DqtwCyJPPBqzk+/d/FnlewJVLaWojYH5QazySLHOhrV2fTZVSOOJJJ6zez2LVqaPRT0A/b4sQao2IpHz+w1hVHfe5rP3AzwCrUChtn3HWR7FwWIlzG8o8RSUB+6sA5oTekB20uoqR3mDtCISpDBcT6mL7jvZpY8qnzDbbHgHwjBTXHk5uucyCMbcm5vrWAfevGNtzSOnwGl2vbymq2kCW/NKAqENSIVLxF/n3Mh5wE7C9ItU0t5sEgxHcFelUktzwTQKNcatl2/PFJfv/WG0xaLwF2n3zRrZnfBdoPNsOUFi5O7yH3/K3bYQOnRvhxNiEdYQEFrLTqfgp4mx7skzgyK15yAnhjLGuzF85+Y8YNrBqezOia+S+bTLUuE2IO4Tz0xn0u3DR5IQNNeyK1vdXW0nA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add folio_is_lazyfree() function to identify lazy-free folios to improve
code readability.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/linux/mm_inline.h | 5 +++++
 mm/rmap.c                 | 2 +-
 mm/vmscan.c               | 5 ++---
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index fa2d6ba811b5..65a4ae52d915 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -35,6 +35,11 @@ static inline int page_is_file_lru(struct page *page)
 	return folio_is_file_lru(page_folio(page));
 }
 
+static inline int folio_is_lazyfree(const struct folio *folio)
+{
+	return folio_test_anon(folio) && !folio_test_swapbacked(folio);
+}
+
 static __always_inline void __update_lru_size(struct lruvec *lruvec,
 				enum lru_list lru, enum zone_type zid,
 				long nr_pages)
diff --git a/mm/rmap.c b/mm/rmap.c
index 336b27e00238..fd335b171ea7 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2042,7 +2042,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+			if (folio_is_lazyfree(folio)) {
 				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
 					goto walk_done;
 				/*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 81828fa625ed..ad3516ff1381 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -964,8 +964,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
 	 * They could be mistakenly treated as file lru. So further anon
 	 * test is needed.
 	 */
-	if (!folio_is_file_lru(folio) ||
-	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
+	if (!folio_is_file_lru(folio) || folio_is_lazyfree(folio)) {
 		*dirty = false;
 		*writeback = false;
 		return;
@@ -1506,7 +1505,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			}
 		}
 
-		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+		if (folio_is_lazyfree(folio)) {
 			/* follow __remove_mapping for reference */
 			if (!folio_ref_freeze(folio, 1))
 				goto keep_locked;
-- 
2.51.0


