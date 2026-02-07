Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B03A7EE6B7F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2331A6B0088; Sat,  7 Feb 2026 03:12:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 211DF6B0093; Sat,  7 Feb 2026 03:12:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107B56B0096; Sat,  7 Feb 2026 03:12:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 008676B0088
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:12:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B70CE13AACD
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:12:45 +0000 (UTC)
X-FDA: 84416944290.02.710EFEE
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id DE20B40003
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:12:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TAVwcqPv;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770451963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3c08OVs7S+JipvsoiksDQinUdwR5RLYJ0JjNcJIizyM=;
	b=jNGX728WqzSfkzXCuCZlu/qnmo9k7Nj5nl/MRxm9aASu2v2tcwihXfS9crIc+mIykz8SgO
	J+rX3tzB91zAigsPruCV7u9scTTvWw7NWSaVGIU2rggm9WhMFqIdMYRvO/J4btJ9TlHD8S
	08legKJoK+Xix12NUSlL7WLwBCXpYok=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TAVwcqPv;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770451963; a=rsa-sha256;
	cv=none;
	b=vs2bsrsCmwITzQX4PoFgIjmc5TjIJmUrFTYAqvz1S/z1fXmLwoZHMIS7LPNovQfdaE8xLW
	xn9dg4YYbfBN1wVXW/Z2xQ20/zZ1ba4A4leWt5IEVTHHR7+aqZGhctCDmPlNdXTQWBnEIi
	hUmebRwQXjVyoc/63cKZCO4/feievJU=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-81f47610542so2007468b3a.0
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 00:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770451963; x=1771056763; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3c08OVs7S+JipvsoiksDQinUdwR5RLYJ0JjNcJIizyM=;
        b=TAVwcqPvReIblK89K9qi2mdIXilqAjnvn1D9td4ccSoswP/Rt6x1L6dcUICKdWENcu
         h/ZmPTWuED0DVM/HfU3sjiL40qD0ltbAu1hmD+lwvwJZ8YvNI5Q7ZQIPrvF/KQn/jOIC
         c1YGUEjKbJ6mjVtm90rTsxvdeTbyv39g/6E7EBnqbdMpqdl4ouFSw2Z45yv8e4R23CNR
         hzx+KTaf0yd/CReyD/t/EpG1TJLGbwlaCnRkDkgdJJtWZgwiX4dwMZPZkLUCRNBqoZK6
         MNth+3KtkOw9GbBhsxvJVweuN78Rg+BAD3PlFVR9CRbkgyS/X3agxfcOcms60S3b7ltX
         pAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770451963; x=1771056763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3c08OVs7S+JipvsoiksDQinUdwR5RLYJ0JjNcJIizyM=;
        b=g1g0La47L+4GBlgqpm76tz3OUMh+jo62lDBkcpxjC/5l3Lr7MF0xPZaRQMZa7/5Pzs
         6kAu7DBN5Sbjdv81N9Hd2huysb98QWGX0CNJa87tnrunJtQtiNc1XL1njprBPNpqxxPp
         zT+bFssvClKD72a00ZLMwoTEaG8uU904nTO9F7ke8THP/5ZP95qLC2BpMWnGqt/IkFDO
         ipf5NuefC4H9mGvpmgTQL0vsx6xCoitV0C5pKKRf3yJMESpdw1sYa+Q1KiAknVHUe4oH
         SvM85O+GngDY2o7m92WDViADNM1A2NhdwGyo5m41h+pOwHxaWXNsIakb2fRvElo2vTvs
         9WhA==
X-Forwarded-Encrypted: i=1; AJvYcCWU8RRnZXxTLHDbUrZeEvtmII3U2LaLZ5D73iaIalRlfb0wrGj4i2lTYqqdLqIYSottMhpqWrMeLg==@kvack.org
X-Gm-Message-State: AOJu0YyISA4FPPJosshLV2vhMtDU6fOpX3agh++l0Wg14PT7rBY8PWa6
	qxD8mW9Gm5byPZ7sxzzOOPIuT5bBr4qsJu4U+du/6nxCW4KlO30aQAoH
X-Gm-Gg: AZuq6aJsTOWyaT8SSEoWAwaBK4wWVMChSmMH2Pbb7Bs2llUHVXMjW7x1npzGqaxNLjO
	3DgNWHmiZ/6/MgBYtWYdFuT109Dr87y/ipvx8/eO7oL0c5DJIOsSz6uopk3MrGSBSQv181zbed6
	ZqKmFt7pEniHibLLqWuGU+48GxMIfUBgU9FwbSQ8n6VOznVS9Vk7VneGNSumt/+hcn0TPKiOaoS
	Jjr6kSnW76TOoWxo5IAsAPukLNunxpT51E4JWvbmgc10t7tDXDXxhAXAESdwfO7v5s+17LYty55
	8/EieI11mO75UjK3xGuBxF+W11YHh0blu+8arVGJfMu1P3zKrUi7hxTpmtIeskKVBQoo9bmDFyq
	u2bUqLIsZOK/JeQ1Xu6416zhGckUYGhhHVgVAK4eqACgvrb+c2paRwnvppVZGMxXzlOJ6hJ/6D6
	aZ8pOoXpu3mA5M6fGjBbFN3Tg=
X-Received: by 2002:a05:6a00:bb88:b0:81f:8084:7ea0 with SMTP id d2e1a72fcca58-824416005d3mr5155801b3a.7.1770451962804;
        Sat, 07 Feb 2026 00:12:42 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824490442cfsm3951466b3a.16.2026.02.07.00.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 00:12:42 -0800 (PST)
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
Subject: [PATCH mm-new v7 3/5] mm: add folio_test_lazyfree helper
Date: Sat,  7 Feb 2026 16:11:42 +0800
Message-ID: <20260207081144.588545-4-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260207081144.588545-1-vernon2gm@gmail.com>
References: <20260207081144.588545-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sse3s1sux9m6qt56kh7aewuywtpny7iu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE20B40003
X-HE-Tag: 1770451963-725118
X-HE-Meta: U2FsdGVkX18H3VltPboyMHU/a9jof5pGYDqNWW9FF7r5HywEbrG6xfmo/LHbgiBRS8kd37h+S1nSTuKd39hgVcIsEdUib6wELCNi+yJImUN1fdZshhdkyRXRLlJIiK7778DndBGHJ0365N93lTWovAqOwDB5CNaRNBwVTplU4ePR2zkGLYEEb18R/BYw840BSxVFRTg407utoL78Ln33KwCJmqYobRwzH2957lTtGhiu1SuhiTsecwSQSac+EFQh88uNfKxVxPk4c/CiInFnoyoWmrx0PBBVj7wRe6kd2xoNFBKL0X6MBivj6bEzecXBgEV3h6fUzuSzv5xwVy46ZaQIavYMHAU8vMLP3qlnfJGLtEIC74pTu9s2u/U99SdAsMzpYtBIx6CsVF+Io4VuKv9AteRFa0A11hjDt7NEY83PSF+lyxSLlZ/AytoXvinLUOOaCeeZvjiBMZjFB+IZB8xDa+wnM+cIMo++sOcVmD7HvC8DT5l2fYHuOJf2lw263djMkSAAK0Xky/T4CVGDcy8CDlpLViE1V2r4ee2obyvVfx1HE4UVjCjwf97/iE2uxnR+DJqBSB6BABlAB7wjiXfyEm8dWXUVpjkJ0Maxj8tIGhP9MGPAjlCNPnMdY7neO7tRAq42m5y3F26p0KJ0zr96J6vNbmercFoMDFBdgTysde03FVcGyoOP1j6iy25jcn9wvwHg9RXgjmaHSsQWAAAPWL9ZB9PPmiEEQkp7q1NBEv7hwtQmr0q2vEebIGUohu86BBnJMkNIag9obcAWN0+Jj+cp0zjUJZs3HRewocFeRCEm2mARy3O6K79qFUHB0IyvIj01WurxLiXq1zNO/TtyneCOqC6bfghB42t1zjTgljUdcLXygC/Qp3Kma2kYncFyMB3PRl01arp/Cl6rfQQf8YBXVPLHDZpb5EaFqrt6tUeoS2tA2QV55PNtyjwHm+cqdMeiEcD4jeapR1x
 ao+vopur
 rT3AdTKlYWmCdcFAYZYTUKWDByodWWeWb4lsIHthu+d+5C5Ztv1uEgdDq/JfaplfndNoeu78nurhKGvn/XBFqdJVwTrK9kicdr7v9Tj4g/lNmjgb1l3j8jv6FcNYCBGP+5EWqp70kY2RCnzyrRhtUDRFeStpSeUMYVbkFw9Cv5hCZHHSgRyEsysXwwUKl3caV07QmtSzz9WPlHeEn0dgEZen+ECxGyAPPpj6pFHAQutETMDrLS3N1ZxfrS5AgKPGcbkcXKqrR5ik1b4oNWrhTwapW8unQqLcCCHtFHMKs5dXX7IEyYP8N5WGPuAKbJboSh5BbUNl2zFfXQeKwVN1tkNPPReHesigbPj3SOiACf3wuP5tyQc3cxXp6VsY6rUDCm2RsFMau/ctFBZozKnLNHaPqdUg7wA9tR+WTYovkAUzUJT/tjWwIwx52+6O4LZcVh6H6lyob6kq7t7bTsAJWJrDv6OPl1F8lqQVhN51l2O0ch0nc1zdLsnuqI/JMDGrAYMbspm4lLFEkHHgs/WLCmw//ZWh8aTARRxBr0l3lwrURUMoWhzbUKDgo++7RLEyCidX6CQ9AMq+melfTzoNr5JZK8yvq1tuZm9mUWx+6S0XzVthAXqSz4o5If4H39eujeRKVd9vKJc6Hc+M=
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
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
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
index c67a374bb1a3..e3f799c99057 100644
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
index 44e4fcd6463c..02b522b8c66c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -963,8 +963,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
 	 * They could be mistakenly treated as file lru. So further anon
 	 * test is needed.
 	 */
-	if (!folio_is_file_lru(folio) ||
-	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
+	if (!folio_is_file_lru(folio) || folio_test_lazyfree(folio)) {
 		*dirty = false;
 		*writeback = false;
 		return;
@@ -1508,7 +1507,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			}
 		}
 
-		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+		if (folio_test_lazyfree(folio)) {
 			/* follow __remove_mapping for reference */
 			if (!folio_ref_freeze(folio, 1))
 				goto keep_locked;
-- 
2.51.0


