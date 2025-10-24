Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D520FCCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5615A8E0114; Fri, 24 Oct 2025 16:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5121E8E0112; Fri, 24 Oct 2025 16:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427008E0114; Fri, 24 Oct 2025 16:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B39F8E0112
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:45:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB29E140F2A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:45:05 +0000 (UTC)
X-FDA: 84034187370.29.24153EA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 452C520008
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:45:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZUpSu3qg
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9O7eiV4WH1ThCiQSGil55E8A/JzNJDLMrVHCUpnr9uo=;
	b=vuyPW6pQHNLQRNPshEi9AIZYwzk2BOqRt+i3OZcuBU7JXs6zXMGxcEhsKR0ElPjkzvxxi3
	fYJvBF+AQdwmEkV1ybgT+JFK8e9PzWRpi6IWzpCJHNeXYa5nNPJ8SU0U3TzHxu0Na21VgY
	zu3ERytPs3FyOzAqiyWyyxz3RAeS38o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338704; a=rsa-sha256;
	cv=none;
	b=2OWI1LrRIm3cu3+sXAaGfv1xnB+0suAWy2pePO2kcxCkpCSOD8YYvfARoDVXxdf+2E2LJq
	WQFENwHjMMCyGujK/WRy+cy8qaRDN4Nsp0bAeW3DupTZFBpm/JOuwu27vF+u+uAV2IQ+X/
	8EhYQECvkkd6EseuiMY4/2/WM2qJmWY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZUpSu3qg;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=9O7eiV4WH1ThCiQSGil55E8A/JzNJDLMrVHCUpnr9uo=; b=ZUpSu3qgs/dTahB0n74ir5R4Ym
	uW/2BHtdEqTDjNT45v0URHY1LqEMmki5OyOvWA7n9qBDw1pbJTFgSSX+jllazUUEcVDIJcIGJVr6Z
	3+F0O/j9GZBkhua1dUZsh4Xa6D/KTqWd20RxFvPIfEjCVkrP7anQnptdHAMHi7YELcI/LxUTMvWRi
	ThULbVEBGzSQY+9YUdRfA7Z/pbSvAoXYTbhYAIZwMYb4FwIEooHf3GWwKyDjyp7figPso2xXLWvW1
	uSkFkfyYlft4BdGVDjYWS4fvQwmiQ+3WkAO4RQoxPJgUqd7q7y0rpprKfMzMa64BoT58+QrO6JY+c
	FH7vXZXA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeO-0000000AKV8-3IIi;
	Fri, 24 Oct 2025 20:44:40 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 17/17] slab: Remove references to folios from virt_to_slab()
Date: Fri, 24 Oct 2025 21:44:32 +0100
Message-ID: <20251024204434.2461319-18-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: nh6bdm76us9cxmtt6rtikxkimhjmf7ka
X-Rspam-User: 
X-Rspamd-Queue-Id: 452C520008
X-HE-Tag: 1761338704-958642
X-HE-Meta: U2FsdGVkX18kKuMadhObOboImgGfaDDYpfKnFUKV6fG8t49HP2Fkv75XtxwKSYiTb2AFj1qBsnk08KYXOzY7mgeGIQ6gTzyBjIIwe5PVAZYFClMMudyUSRkPgKEa8vaUJwG5WX+5B+nN+Wai4peEsgBIfC0HMg4C8V83lO6YpqFEpsjPAPDWZBDvrd2zJR6pPVaP6SCBX9plRz4dscvBkSamWCNSB7ivc7KkOnzsEP8mNou2qZDCi9w5s690glgNIx9CiSTK/A/5aWmiiTDRNGUdMrdRzrv8aBMjB9Xp57ebGVrz+i4cxOd6/qbqYF/fg+GfA2T5ULe4MFN09zf3fWjacPESXFs57JbYgSx0aHOZzLrWdh4MOF52xrXAL06NtKSiLJJ8IwEFsYvLgWevcgI6pdrn2qisihmgHIDSPZjr+I4WRIeI4ReGphOhkE/mR0P1bpVkveEKFBBOMGCdE1AZRrr00N4ya06VO89ZP3F8/Kv78Oe28yfDiHarFKkbSoSaVwtx24iYVoENCYbsIe00YgeDDMqpGx48uJdVeVF/UE52Zr030QMHWJiXyl4rRm7chYMbIJWUFsRCgmH0FjZQAJ1w4pmVmq07buskCOpmS2JArNCANQ0Tn+r9w0QjfgIQETGYYR3Fxy21SfG6uJK2yN1enctl+JD1eXxet4xlNdmKlwpwNE9DDoXa/fivmdmaS8d9HI8nvjOYVNzGKSjoXdl+hhP77YGVVroxcnQbf4CfCpJRzq7oIVcypQqwU+KPZNbdA7Z3P0lF/2VsBDS9NYdPllOwgNCNVBwiGsZiWgnvH2Xet8SjkzN9O08F6yHEWuOGT2LMHHJ7PEsDd119NgMjabOg5UMRD/EzVbWzMERcoBmcDnOTasVBMyOMPMi1z1dnFwpCrvtN6BztIJhJ7hFZJxbm1cb8dUtA8RKKkXb+B6dFEeWbTl/CQLNq8XxdLxrMGPIj2H3KgZA
 iQBltGbU
 vchuknVP/4s7C4ZlF43cnoYiIV8N1wTmo52yhFv99iopDgCaDuHHqh7hzTfFy+Q+FnK2tULSdt4wo9VHElsKhyF7hQEIiDRRkhi2wXOG1K2lIQ/ibJVgrGM+/HQ9aiRC/qzQmby9Z12QpKVqf4gXTZ84F5hytIY+aCP8dLDD15jtkk2/KPeewvrThyp89PowYS1I21rOudc9S6mTGBLKmebetTRsYEYCikO4w/n9zneQfzLI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use page_slab() instead of virt_to_folio() which will work
perfectly when struct slab is separated from struct folio.

This was the last user of folio_slab(), so delete it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slab.h | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 31ccf0f6d3a1..6e3e80c90043 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -117,19 +117,6 @@ static_assert(sizeof(struct slab) <= sizeof(struct page));
 static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(freelist_aba_t)));
 #endif
 
-/**
- * folio_slab - Converts from folio to slab.
- * @folio: The folio.
- *
- * Currently struct slab is a different representation of a folio where
- * folio_test_slab() is true.
- *
- * Return: The slab which contains this folio.
- */
-#define folio_slab(folio)	(_Generic((folio),			\
-	const struct folio *:	(const struct slab *)(folio),		\
-	struct folio *:		(struct slab *)(folio)))
-
 /**
  * slab_folio - The folio allocated for a slab
  * @s: The slab.
@@ -192,12 +179,7 @@ static inline pg_data_t *slab_pgdat(const struct slab *slab)
 
 static inline struct slab *virt_to_slab(const void *addr)
 {
-	struct folio *folio = virt_to_folio(addr);
-
-	if (!folio_test_slab(folio))
-		return NULL;
-
-	return folio_slab(folio);
+	return page_slab(virt_to_page(addr));
 }
 
 static inline int slab_order(const struct slab *slab)
-- 
2.47.2


