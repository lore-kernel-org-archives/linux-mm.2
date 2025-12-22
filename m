Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C369E674A9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 13:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D654E6B0088; Mon, 22 Dec 2025 08:45:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D458E6B0089; Mon, 22 Dec 2025 08:45:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68596B008A; Mon, 22 Dec 2025 08:45:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B79866B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 08:45:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5066E86D8F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:45:38 +0000 (UTC)
X-FDA: 84247229556.07.B7A7100
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9845C80009
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:45:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XwGLfGwf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766411136; a=rsa-sha256;
	cv=none;
	b=MCIPGoZO28mSSM2GPqsBwiRo3DNN8paajo/qVFbHt0xzZSDn11H1zynCDOYrRybpPaVhIa
	mCyUrXuBpqMP6TnAp4VQgX9uGPTDyDBHztwxDCj0OGRuxNq+02UXoMg2UTPcSMQ7zJwc2R
	YQK6hcFApp/B9viS3yPycBh31cxSHnE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XwGLfGwf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766411136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=5niD6qFIutyDUO0yqrRE36IYEi5/CdeQZgzBBwe5Jvs=;
	b=oJsBpHukaf+TtZgUVcGca6PN8SwzLXPzf6T++pUiQvwrxtnySos3zfFt8fp1IDFdbg7PCw
	C6/Uw5dvQbETs17twAbhXsnc1sSChsHC33/jHDfMqteS8BR6EQJh3W03MPeIuT9zfPaVdn
	Ybd8KsWXMtV+C1mYjyDm1v1HtrHwZV0=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64b81ec3701so5697655a12.1
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766411135; x=1767015935; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5niD6qFIutyDUO0yqrRE36IYEi5/CdeQZgzBBwe5Jvs=;
        b=XwGLfGwf4XADwwGXLoxlPQ6JG99Modtc6HLb0Bn/m6oBkDQGCs6czdsqR9ZfkWPIum
         p6hspMW9MhulSaK6cNvr5CTCYRFhOJtVSJwuY67z5hVlS1aiCXNtcMefljiPammeD86u
         LrYmBq79gnFRdSv/XdTaKbqsWwqEdFH7TC9e9582RZkxPgfd4CdO2d1phMfAjbET3QMv
         CnXtHCI94UcQ2IRikXiwn+mbEwQ7AViYbzSchIBGl7kYvrOcpJbeTKM+OjYLuRwCYbY0
         oy61T+1mknhmMt0oRRu26WboFWa8x3rYfTql/XdCJs0azK7h+06roEzim+c5Y2lCJrGw
         mvMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766411135; x=1767015935;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5niD6qFIutyDUO0yqrRE36IYEi5/CdeQZgzBBwe5Jvs=;
        b=UMyx1oNiyMmXQbWbDC3MU0ndxaJ6RE0+w12A1fJplPhtOea7szDkDXMCN34+qivndT
         SWYJz+dXVfNGKzfJmqicyOHSRs7X/4Wwp8f1LoWPYB4l0YYhTfzswZEsf/urFKTgieHk
         KT1gP/H75SJn1YKAGBDzw5iB8KMp48WDwbRxS612Psn4CLsF7xvPnJHiEEL06GzT/XFu
         juQBWSiYuDt/nljVi67AMbqxpqobwt6mbz0dwZf4EKwPyr13TueEZ9MV2h89eF52u1co
         vcUPx7ylHB8xgpoq7ThU/SXfrJxW3TLVsI4QSyPoGC3go7ByUoY1uE/SBu+LCxNcMGzw
         se4A==
X-Gm-Message-State: AOJu0YyKA9ZYXOy4nIV+tsS+zBxfMNhe7foS5v8TwMjrnTH51/y1P3J6
	qPkpgcF9cTdCnbfJnk93/EUkF4Q/Fw9aPrBDPutrFeWy2JIkk1d+puZB
X-Gm-Gg: AY/fxX7GRoIlGkSEXOy0qQSRUcRUyd9D1dm0pClcPo/bPSjhEdZI+Zm6OBCpOfUQzVq
	2NV78yWZcOJFqPJTBKcMOCxkqQr74a5rzeqcEqKqbI19onbMEddv+mEYNLabXuSBRDv90yrVAQR
	r+jg3jXWvXCMIGr5HbAAdoxUf95ztk1CUeQCWaOlEqWhVvjViGaHySmmTqMrvB+DjRikPS3SQW5
	8MzNpA84jvjXgbzXPyKGDfC34Kbq/drTfIvjNEhxGQyf3SQws/BlnaPE3k1+C0gsBYwwb+ZZgb+
	2WE2LxNil086WKFxwNLoMwY84ro+GmMpgE/kq/fDap64K+uI0m8Oh+Cb3oBHlArkpew6MERq4Fq
	rA/okYs8h1xK+kz+THjJQRR2Gh69D/9OUQhSB2aYiGgD0t9479vgs5q2XT2YfRffF3DiPv9MHLo
	DBNdpVhHnT3mYB4iwaSNdL
X-Google-Smtp-Source: AGHT+IEsaUg8H6NF7rDmdQwZqz10emrGplIh0mmXW2EVMfp0t5I8wKIO3A08IB3/XrzYx+IQjB7ikQ==
X-Received: by 2002:a17:907:e109:b0:b80:3846:d46 with SMTP id a640c23a62f3a-b80384610eamr908277466b.20.1766411134143;
        Mon, 22 Dec 2025 05:45:34 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037ae2d5dsm1110039766b.27.2025.12.22.05.45.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Dec 2025 05:45:33 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v3] mm/huge_memory: simplify page tracking in remap_page() during folio split
Date: Mon, 22 Dec 2025 13:45:31 +0000
Message-Id: <20251222134531.20968-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 9845C80009
X-Rspamd-Server: rspam10
X-Stat-Signature: ngsqrcisgzxqog5bcx1oh4x48pojawus
X-HE-Tag: 1766411136-716974
X-HE-Meta: U2FsdGVkX18jvfwK3QNEezvNpVFxf77nlDU4t7rsijDeAgkaFShoOJylO/ZLxi2FxtFb61D/1aXYklRhsOI6hDKJF+/9KsupziiUyJBvQL4cJwRI/wskOi2VpLy4TwnIVYNiHh0e01TRhajZjKqFDWNs35hv+vIYBm/mK01B3lOOmqtvCx4lN7Ryo2uG222mtRibZfNe7oM3n4tJX9hdAbWdKU2FZyN3qTXBQJ/hhF7W3RucVmdUSQ2uE2BhpGpQxIgaG/9STNyu4aXMvc+Uqg+4k/trD142idIBPNIm9CRA7ERpvEAA0B9ydnTNsxHrqpy3vWDmDk4U4GdbZZVB79lWpYlFry8SXYKcnetQtcDJM4h5KfJNoHq6LOjg96nMC4jaS4LbBZMJSehRMYmX1Nw3ryZbhT60v4+0lm3wrjaGef4jnDMtrPP45X1kPT7KZM/eG2wjIMiOvrD0JG5LpGAnb0MIpft/w/lsbVs5XMczA0G8uwt/HxLf/MHAF2pHXQNMn0G1sja9StRWfw6nzIk+c5ayS6zhCVL3gabyX5pD4/DwLsdvAh3NKt4yLuWlNwR/qNyYxBdNHcX3fQxT9rsViIdRcFvS/86NUB1XJp4Bnvc/2vsvGLlVThKfq+BvvGWeCx0bbIVg3f/6hIUdGCGhOw4iyUeZA0doR1Rf+naePhiK1QrJA1AU25xa1f5NBRZJBh/Ef3lQLaIxYywGww0bBsuaMVwQFt82avUCFek420IFGRDDtiJeFYdTOYElE5aUrlCtMdiDW5vMeMEBsf4f+zsArRxP9AnLWFtF1VFcFhbYNuIpRD+Fsf6hNWiECEZOLAyTu5QpQq1GeXp7aabs6cpM39ZmEWD5rpbzwrib4vg4ztRoBSUUiiqN8kER24Dr5LllPmmp78yaGH6CPEnPzdRNh93I4bWs5ena7onJyIp8zJXbkGzOlyYKuqBI2nPvbfvmWB9NEHNwsTM
 Zx9pgaIB
 KXYSEW8ruxSLoTw4EXaqyyxdonfBOUG7hP0r99a78KZ/FAYt3cAM5LsjTGypQDai4YLuLCdhXe5sPhwF6cm+gsgOBv4n/wx81whGCjMxRkeRrvHtx1BuStSWOdW3/lXtt9wMVDpRxLiizWz6Eu0vpT2MIv+R4Rb29WtCUjijH4SkuV1Dy0jTN2c3IupzGKKJXXODx2MNbkJ8mfQmkQCRo1ryMvJhrzGgi+WTJx+glrpp8cykjXlfjHlxydMSeUy5NdwQB3njy+UWxy88SeWzZiWDLsgT9zGpe5ou6dWlQyTxTO69SeprPH255/faQCHOGZWdnfCnd9gwD2EC53SYvtpj2EzYw3bSjxCap69SP2Uk5hL50+VULuu67R3L2qkoF5GQ3iGNVpoUKOptV3vPOag56nndPZ4P+1W+f/e9scA5vXPT6854jSpKhebAStgHi3NHWredKkSxYl+MpiTpwmNyB74BG97pH0kmA7r4BHFqnBSjgDVR6KoSFR4QBUMXBEykrClAuRweQAoRuZbd4aqB8NmVP87sgkiSepvGLjVi9AIY8fhpu58siKLJjRWcEv73hXrCqIcYYuDz4wkktk3+w1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After splitting a large folio, the resulting anonymous folios must be
remapped.

Currently, the code tracks progress by recording the number of processed
pages in an index variable (e.g., @i) and comparing it against the
total. This commit simplifies the logic by directly subtracting the
processed pages from the remaining count. This approach is more
straightforward and reduces the number of local variables.

Additionally, this commit renames the variable nr to nr_pages to improve
code readability and self-documentation.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>

---
v3: still use nr to count pages but subtract it directly
v2: move folio assignment in loop
---
 mm/huge_memory.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..d51aff0b7838 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3423,17 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
 }
 
-static void remap_page(struct folio *folio, unsigned long nr, int flags)
+static void remap_page(struct folio *folio, unsigned long nr_pages, int flags)
 {
-	int i = 0;
-
 	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
 	if (!folio_test_anon(folio))
 		return;
 	for (;;) {
 		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
-		i += folio_nr_pages(folio);
-		if (i >= nr)
+		nr_pages -= folio_nr_pages(folio);
+		if (!nr_pages)
 			break;
 		folio = folio_next(folio);
 	}
-- 
2.34.1


