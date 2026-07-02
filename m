Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF610C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FBD76B0143; Thu,  2 Jul 2026 20:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD036B0146; Thu,  2 Jul 2026 20:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C996B0147; Thu,  2 Jul 2026 20:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61F3C6B0143
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:51:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEEBE140117
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:51:10 +0000 (UTC)
X-FDA: 84945636300.10.1FD358C
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40750C0003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:51:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WwyYx1KC;
	spf=pass (imf10.hostedemail.com: domain of 3u95GagsKCOwgcifOjdObROUccUZS.QcaZWbil-aaYjOQY.cfU@flex--souravpanda.bounces.google.com designates 209.85.128.202 as permitted sender) smtp.mailfrom=3u95GagsKCOwgcifOjdObROUccUZS.QcaZWbil-aaYjOQY.cfU@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783039869;
	b=JeTIea3ZxFzx+X0EoCE3s8QNbIsat6qTmmwRkB6OGgyfcSooP5C3WxD4Fm+VeNL3M+vsEH
	qvBDRAWiDlMxb3HIfCZBN8OLosEUtIexqQbP+RbIUoqsQdVPpUIwABJUR2ml7PHyLJApnI
	45xdVjBnPY8TuHcbMyD0VbxrcXbzN/w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783039869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WZ/TPtvTNC+q9FGe3x84bP2kV6oDVoOCT17hGTL+ZZU=;
	b=IONfTCTbZg+NoxV09+qqJH6BfdFpft1Gd5EIZqxU7w93um9sixi/2mXBo7sPDgU75wkaat
	uasvqd6f26DYYTqAGDEGxfr9Z5HDgdjxoL/TjQauybfHabT7PFS+bbPrwQQv6OH7LEk6co
	XM37pGd0bJls+UZzsPge24MS7FjHaiY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WwyYx1KC;
	spf=pass (imf10.hostedemail.com: domain of 3u95GagsKCOwgcifOjdObROUccUZS.QcaZWbil-aaYjOQY.cfU@flex--souravpanda.bounces.google.com designates 209.85.128.202 as permitted sender) smtp.mailfrom=3u95GagsKCOwgcifOjdObROUccUZS.QcaZWbil-aaYjOQY.cfU@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-7fe0184fa91so11053147b3.2
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 17:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783039868; x=1783644668; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WZ/TPtvTNC+q9FGe3x84bP2kV6oDVoOCT17hGTL+ZZU=;
        b=WwyYx1KCNZLEosLn/6P/wHl7qld9m+fWlEB5ELOoWFp3hq37sDD11pmUuklmtwWiqL
         rNIfC4VDc/0sbbrN7075FEopbIOq9h2K60y4XIDfx4nuFYk9HXOn1QVdMMOJAOgXTB+x
         sRinac5PE0ATICxaIL3Kp1xdhbL3wVDL3AU/QACXB/zMUV2yrhTI7np0Si54yUEnTtXB
         AhhCwmKuXpwlzWtI0graCYgF0TY28Os9w3CKVnnLaBXZnaogpLsvaVOCnBL+K9mWKgVg
         cOTQaCGp2R8yWyO7NG6JA+JyeEZYkkmJ4DnC7i3kPPdCgjoZ2WIh3qqDlWUD0H0JiC/1
         LF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783039868; x=1783644668;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WZ/TPtvTNC+q9FGe3x84bP2kV6oDVoOCT17hGTL+ZZU=;
        b=pC81Q0wr/qyF/kJGWoHnvrZNIb0dWWahFvg8e14YYxqu+LpVUqWB/X+zAoazmeHUjw
         +yySYAL28QuZTk6TzJ1LYYXEnleXQy4cVmIPjiIt/RzFUeesRgB+V1WZe81EpZHF6XSp
         EH5xfru4Jij24QM+W3uDteyXmwTnyyL+HDgpwz+/wtsfVhlFHUpt//Y4d2vpoJCOITmH
         sjyh3g2IfrPfdjhPr1ZXKVv4My0aBKwlrcwGsz4XwtYoXFmsdaPUuS+pl1DM2wIBDiut
         m0yAu8Cb3e0WrG35IvhW0GMGIAWDWb254/EEjkbg9mtknFnqahEgW8lMtPA78qixZt+e
         weSA==
X-Forwarded-Encrypted: i=1; AHgh+Rq0EhdDmlGGp6xJ09wCCEmJquTGHveXS8FiLnQARhRAk1CnoBekkwgm9i/FH0nBXLo6iZumwuINPA==@kvack.org
X-Gm-Message-State: AOJu0YxRm2usMX3nPFk7X5PgSA4k0QZpEscL6OaZH2UsL79+6UG0H3zr
	xL11qne39Yg99UvqAsqVeTFW9rwabeyKKvKbaBd/Z6I7ee16yj/zufY/VHMFP5LKacHzMysWM2g
	O4iqwm1nsAdytyBIXaWeRShCwaQ==
X-Received: from pltm9.prod.google.com ([2002:a17:902:6bc9:b0:2ca:c162:e758])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:8d0:b0:2c0:b5c1:8e22 with SMTP id d9443c01a7336-2ca7e6847d9mr90430995ad.12.1783029435098;
 Thu, 02 Jul 2026 14:57:15 -0700 (PDT)
Date: Thu,  2 Jul 2026 21:57:13 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260702215713.627941-1-souravpanda@google.com>
Subject: [PATCH] mm/hugetlb: Fix null pointer dereference of nodemask in hugetlb_cma_alloc_frozen_folio
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: ineae5su3nd9s8faea6r6ioqkc3hwn51
X-Rspamd-Queue-Id: 40750C0003
X-HE-Tag: 1783039869-745251
X-HE-Meta: U2FsdGVkX18cYH3xP+ziCiUUUyqs2R1u+ux1x1DgTFQI70uAm74zw6Tg9UehZC/n1nJl8ILcqxXiiCLsfP3Qkigy1jwLCd5T/v2gypygs2g2VnXmvhuMa1y7oLSFryNf+6e/q2nCE+P9suxRZToQozEGwew5zYoGCIB80uDc1ZmuDRDkFI0zUC42kWVErGiq3dUYGr77St5TrVs9AnaDqnIGukQ1Uk49RGZGALTOW+LTYK/aOR7HUiCKLTmn/invLP1Z71tDOlw1I3FhQfBc60nSZGBP3yr9WDJp/GW0VwVohhPEi02VFQR8RA6Gc17UmTUXwkpNiqq8cbvlXVx4YgUxYHx4xkbMUBXaGFn1HHNcJgZvJBzKq/IhXw/hM6VdlthMgXs/46vnVpURrZcxu+7uro+91B4kci3R3+zVzdSvKIWeZ8n+1/sq2wXeeOilLgGZ4Ph6Wa/Vp+YGOSXcaJaF9JPh5FG6ctPNrJ15L2jyrOegM/hrahw6Le3tj7jVL0AxqavOmK7Tw9GIAZIafU2mGAjixvglTZeoQwNYOBFvPYQ9dVXC+F3tQj2CDvvXULUoz/Gvy2vKDhdjfD55QVS655wG5L+Cc5vQZ5g00h5orFOYpqVHtpZQIU6m3hLCzxD+bb/Nmz5Jd0JOcApNjT/V77CnZ2p3tuu7F5fLo3OOp9LtdCkNNyuPjOfIPv5fPlmdkzCMPcbW1DIhFC/QuxL9fweIzaq3T+SmebiSHr+hfTXfeohgcZ3wDJmvflpnRpTPwQDiXgHCEK3aKVpCdMi7uWRiJq3oWLs6YL3AjKg3I03E75r+x3SKdQ5GJ2lhHt/lboNdMVhCUWSo6eJMH9RsuCd17HxgS1rE36TEQXhAhRPJDcnTE7VBPMU7h9A9k+ERu8wQpK21QF2JK4Kqr0VP92X4u5bURen+1B8ydmeO3CQaLPf4IWevKzw7a0W8Rh8SM2Ih08qqj5aPMda
 1zIwRj3h
 lPdNCYPbqKwgZ88VvUM/7bFk0U/iffFnA4SFtSzLkb9FZPv9zkfVixFTpEUOXgo5XU4cGigN4F2F45sETTVOxitg41mJR5HFbXIOUpPOLCSIClp8EKPkq569w6YQsxyOE5cw7XJEPRKdaA8j/QfKWzQ8AP9eUAC1KqZEKaN/1ibgGIys7PfAj/0XZcXaUTGgCN1Lz48fxSH5EQWQ5Qr6+n2TvBLmLUe+/YgCrLLZ03IZ9vfp6zdxnFUF5fQldfr96iwOcultfDMwYHt6adY9GiS91fhQEzcaRD+RHS5AdH6i8aXDlyidYgL2cz/RJdSDRa63uRSb9uA7NBENF7xbrexGu/7/PNuBSETPlwXj0jjJySwPKMpA7UTSOpywN6QKa0p7MMz8BlLlQBACBWDFaiEPc4pf5spgA74OTnoNVgDHSURUgSVnbMYbbMIfYLE+LInZQZwnkoLYW9V7305safgJSuAV1k8umd5ZIzwSYsaI8uyATL4T7+Unp7y0pI1uBy7bxFEZv4JasiflPx+ygKGlmYwu17Ug/sBAy3XbSytE2kVIK2KK6AAMJzM0NOmTCUJ5QBcxcBMIPEJr7pQBnz2nHEhKj8TRPQ6ms9s2jssmJ0IlHKwQ1MFGMDWvs9ss+y0ExSS5kB6p9aRYaLPuIZzF8Kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
hugetlb_cma_alloc_frozen_folio() as a fallback to allocate from all
nodes. In this case, hugetlb_cma_alloc_frozen_folio() blindly
dereferences it in for_each_node_mask(), leading to a null pointer
dereference.

Fix this by checking if nodemask is NULL and defaulting to
node_states[N_MEMORY] if it is.

Signed-off-by: Sourav Panda <souravpanda@google.com>
---
 mm/hugetlb_cma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 39344d6c78d8..563e11e607e5 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -34,6 +34,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	if (!hugetlb_cma_size)
 		return NULL;
 
+	if (!nodemask)
+		nodemask = &node_states[N_MEMORY];
+
 	if (hugetlb_cma[nid])
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
-- 
2.55.0.rc0.799.gd6f94ed593-goog


