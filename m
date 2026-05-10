Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D3CFCD3427
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 13:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94A846B0092; Sun, 10 May 2026 09:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD6C6B0093; Sun, 10 May 2026 09:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775236B0095; Sun, 10 May 2026 09:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60A9A6B0092
	for <linux-mm@kvack.org>; Sun, 10 May 2026 09:56:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33FB5A03FB
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:04 +0000 (UTC)
X-FDA: 84751659048.02.BE274C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 94CF6100003
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hSTcgZez;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778421362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zsd2bdyUAYP4faHLqQ3AsGXtCLIrz7T6JKLITX3R0ak=;
	b=GLAK0HfDABB7qSVPfzFbJgbuth4UbrC98c9P0qEjY8b03hzOXM30lnrQcUdoQOOeMWQz6d
	dLNaH+LSPBlAxpbyoButYjexMBIe6/oUDHOgXWvn8tKAXhZlbPMsEgyQjPcyZezGskAzOp
	2T+QqnDZP2QFqqs/roXJyFgbkHbmmT0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hSTcgZez;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778421362; a=rsa-sha256;
	cv=none;
	b=qLu+mg+1hc/krGZO1ImDxMYnHFaOoyS127kNUSFLQYouhuSopzbXCPJzwu5LdCINhemBav
	Zt7aRym9LDlFWlXSQvufFJDePoWjt7RDouD6nOsB4GiZ/mkPv940hrRsBgAMKzAtCBQg5c
	m7UcFaulCAa0ia3vKLyDyGHceF9K9ss=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9C684412F;
	Sun, 10 May 2026 13:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40020C2BCF6;
	Sun, 10 May 2026 13:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778421361;
	bh=WNlS5KGrIJ+SWL3ygZxbK8TC+u2LpU5BV2wDLG+l528=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSTcgZez3XaeIhho7n2WGZSw5ABZYpJb3CKZ/rAqnXrtO0MIpNrAxyuhKqWOD5Kfv
	 +VgBo46B0FClBf5tp4aMp06e20vNNhdW9oMvJsug9CXmZRVQSQhDwhABqwJfrQfuiV
	 znV3YflG3hryHFJA6hphn5XsLailKa12XTgfUV1c/hzHReDzjiZ8c/xDRAvmhbTWoF
	 TpdOTYkJ9kZoihSll0cZPECdaBxNsB1CzSeBLzzsPJe6jEm0B1CApA7JWpl7i/fRkT
	 MWzgM+qVbSDg0941TFQ4FumG/Ss6VLzWhWy2OhaODhm4wDwpvlOF/CqEd8AMTerhpk
	 +P/4yh9Wyf/Gw==
From: Mike Rapoport <rppt@kernel.org>
To: linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Mike Rapoport <rppt@kernel.org>,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 03/10] sh: mm: drop allocate_pgdat()
Date: Sun, 10 May 2026 16:55:39 +0300
Message-ID: <20260510135546.13554-4-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260510135546.13554-1-rppt@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r8bzi5ikcea96mga388q4fuz7xeukfeg
X-Rspamd-Queue-Id: 94CF6100003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778421362-201050
X-HE-Meta: U2FsdGVkX18aF9tPGD/TxOLU0kQJtH/6w2iYdQ/pDYDD4IUoBKwX8QioLMhZoA7FkMd2cV1WtoujPhoc3imsmMueRENQzS8ewPebwZDnpiI8pB3vaqr4SgLp8wCNK7CA5YVbN4F4CSQFOBtGfZuOI+xDO8o53A2IsgdGyI0pTmHpqFZtbANUpAaqYaC1HsSQtHsJrcB/4vY8pReKABqESREneBuo51vB/5TMRXrJ7r9HiGA8CelEHEpe/d7D5A621BKhKRrrUs/oOEtPbubDsqXKXypgLZSTEca98LgRRzZ3IQhr5T7OcC6dxsa6IL1tQi1qwRlcO5OZ+huuwPQ21hTgqZ7eVLHO2xq87JGfY9yjmJ+bAclNBlviRWfxfg06soMdOlBJOZRcqqKUSHuCs/YAwO4X2CX4R7IDqxbaLVE7G2Ph2bfcEnsC7ghQIbvzaa0AnGFvMMYILhr9TzdwYX0v3ZvHnsLbEZ+krnKnLz1DCuV5auaSG43OKCFolQuFLwqJySqhMEDb6XOD1pBMgUst6XFzCXOJ9djaOIseJZ28H3JUXXjPOJVBVGezJC+WD5j0zpieZ7tA7XGZJ4t3kLa6llfWstsBtIDrhPJgaGPwdRLim7W1zlH06RGL7PFRmnUyob729b9pgU1lvz1jlfuvaDS5s9y8gd3OnhnZzZL9XtKsJRTPA7Ts31Qm0ejnAGh8EbDVjWhzJea5ODN+85BfCBtpKvvc3v4qf9kNNd1CzlxaiDI28S4s9hFLTlZSt2HZJVy8JWqu929Xl5V3q1UPnJuMtfrMhiWQpNUtid2IFpzIYyqKPMZqq30Jg6+c0gmZL7SDShcUo9+2mRUyg5gPbFQH0Y1D/ORf71TdFdpUREAEHm+MZuuAVly8rsL7N+oNPkOZBZEaluRYM/bBrC/92LzsUIrVwB/tVv7Oem+M1FSOsHwdZR/rElqI1nBedm/by057t35ITNaYWx2
 zaFANWwr
 sK10gKw5PW49IBD4OFIYmfCNoyUIx00AMeO3l12e0YwJPfByxFHLTsCwtHUuyyOCjgYe7+ON3wC1I7NrS0epWcOPwdvRjPOkiXAHgWr+XHu0tR4oyyGvH8qkiIf6ZQvj9bQa85gfk8hJNdLS0ZzVPCCFnbYq4OGWN+/qvaznxt7X19c/QC7QpkuPwjsl7tgWwtQ1X1VwZlBDGNKBF950rj8Gx3xnfybh/rmejzmBapT3zbqY6iJiXnz4I1dJpEPQG80gLRB/jRIsSQGookckdfEfw+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

allocate_pgdat() function used to allocate the node data structure and
initialize its node_start_pfn and node_spanned_pages fields.

Without CONFIG_NUMA there is no need to allocate the node data and
setting node_start_pfn and node_spanned_pages are redundant because they
are anyway overwritten later by core MM.

Remove allocate_pgdat() function.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sh/mm/init.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 4e40d5e96be9..d73179116184 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -199,20 +199,6 @@ void __init page_table_range_init(unsigned long start, unsigned long end,
 }
 #endif	/* CONFIG_MMU */
 
-void __init allocate_pgdat(unsigned int nid)
-{
-	unsigned long start_pfn, end_pfn;
-
-	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
-
-#ifdef CONFIG_NUMA
-	alloc_node_data(nid);
-#endif
-
-	NODE_DATA(nid)->node_start_pfn = start_pfn;
-	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
-}
-
 static void __init do_init_bootmem(void)
 {
 	unsigned long start_pfn, end_pfn;
@@ -222,8 +208,6 @@ static void __init do_init_bootmem(void)
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL)
 		__add_active_range(0, start_pfn, end_pfn);
 
-	/* All of system RAM sits in node 0 for the non-NUMA case */
-	allocate_pgdat(0);
 	node_set_online(0);
 
 	plat_mem_setup();
-- 
2.53.0


