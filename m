Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B27D7C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 17:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8DC86B0096; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14D16B0098; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4F46B0099; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 806D46B0096
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 222BC40371
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:09 +0000 (UTC)
X-FDA: 85053404058.22.23143BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6D8BF40005
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYq63uts;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785605767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uiWMed+e4y9TXxwRAiQ3Fg56ABB5uO8dHBY+Ne9IA7s=;
	b=6tKcpbBHG+rCUVCKqABqWDI8CIhPNFpjIc7+QvJ9cohH76I/KAyQlYciJbCpcSJ9AsVEiG
	O86WEDmbh3InaCtuwPTgU4O9HjXCRC9zLYk2UN/SQgAEoKw+0MwAWA7RX9iYJsd4esdKgR
	eD8NKbK+Z0cFeZ2gPdK4ZwjbS7G7xM0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785605767;
	b=US9wqBw8+6LC+zM8KR+sW0s2wpjMsjLSnRO/3ICI04MDDrUPKh9Wiw3ps5BzERkt8VZTp5
	kYyYxY1izwkng3Wivzys8Y+srD7vmcoJrDjXgHAoE9x7Set7qPdQAPW5EHUEToYOjdBjLZ
	7O7L5YVK/pl5jwwsbtRjCgGwTCbiv+c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYq63uts;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A47C043CA0;
	Sat,  1 Aug 2026 17:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C941F00ADF;
	Sat,  1 Aug 2026 17:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605766;
	bh=uiWMed+e4y9TXxwRAiQ3Fg56ABB5uO8dHBY+Ne9IA7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYq63uts2BX3RT8QBWXV1P7DCrKOFcTgxo9PGxsrjQSW+hcplom+EoZzSFzf8zyDA
	 YBfSaEi2as9OOiT8vi6D8MV/9GKLCWMM3kvoPfq+W7ffAMYGDFxY71gCPSbLDOkzI5
	 VqipxAaAfN2yf6IBxsVuuVlLpkCwxjA0HlYy4l7NOn+zNUEh64PO49gfnQZbfyTJNk
	 IwZ3TYq5lpv8dYAk3/puCw4SLj3Plg4lggsOnf0Mi4n+HJpB/OKbgsWgSXQWy2iCCE
	 7jxncCePmxG+KBBYCeDEVblgL8GClZ6kWUS3y1RnCd0wztk45h7K3hWPYQSqsPXQYt
	 fi5DaXe+Fi1+w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/9] mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
Date: Sat,  1 Aug 2026 10:35:49 -0700
Message-ID: <20260801173554.94710-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260801173554.94710-1-sj@kernel.org>
References: <20260801173554.94710-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6D8BF40005
X-Stat-Signature: ozyfyc45rcp4wymru16f8po6uw8z4bge
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785605767-165826
X-HE-Meta: U2FsdGVkX18b3enu4TnGQz9rlqFr9jgs6LfBE/sFqDwp/oY32TEQq5Pvkd5T7raCpbpmN0g9GChVG4YuyUEJ/4Sxzxc1EbeuzDhM5pFXnLXiJ4C57XkHueM4yAnggqDH18svgdPqsy0Es97URIb72Atp0iewY3rSAm6w2ZbR8BD7l01P7oeVDTU6094ROTPMqj52hHs7Mvu8mdjmthy1DxPKXD4Jn8FcpU+kVS9Y/WqIctDWuSmI71Gl+7KIffmn4C8E2BPP9L7JcQ/XPsAfgSapYbqTK3naT013YfTx8Sk4tuXXOKUt5oMO/yFYyfNLqk46shcUf9qPPeMHbq4v4AXu94cEaZKU/Ei2tfsQ60ZU+TAZVT1xLrRPnU6Z/LdoYLf4fEydIKFAkZoEpKwKBxwNtdKKqw1y8cztD/aD+EyVEyZuUHO9es76JFWC9MrmqdGFz7Vc8vB9nfG9p52xxn7dKcpytGZKhJeqh4X7jKBU3cnWUtzv67ASKjt4mrKBPoRZD3+CxRz2KTDyefd5hE17IykPQaTM+BuQIpLabkL0rSPZINGAuYvGLodyQAq8xcZQwHe0RyZfuSbASVmmp63chPGsqSiL9Bqc5rRVmqD4KvP9GaWvuq/qXEYj4OktsWtwmseRHfbUF1Xm1eFgPnCJcJLp4d8rg/qSBV5jOZqMMnfSSgL5uiaF0L39ZYT0TNJlB0vXndcyzrytkaPyb7crf8IPuwZhllqrlZQgolP/VUTz8c2iq0upeNwAgxQSw8N9ugzZqKvApKgDTWkd3r9/X/dh+r2MwpEWxw4F/CXw/45Q+g+0uvF/40P5wrzhrdEzbM5eg2G6YOYsyeuD7gSrTsH9QdjVwvC9qOJhhPvnbi5hUS8d+0BayvdExBFbhNSqz3Z8veSvGdCmlsVp8TLAeVCdNsHJ7oozqwvRhswfz6v9fcRXRVvLVwPORNAP36i2bbc129gqbek3gAm
 GqifHZzi
 nq9UINKulMOKr56D3Bb8KEIpP7jJ5BGmyLq6nHagOuo1BGFlRlFAWn1o5o120RivnWIMlfBqgxzaX0EXWEBe1gdh8cgiZxe8z6N68fyLLhE7uGvv4o2s0dZbJZTuibEbVw4x8EQc8gEQNPoew9+yhDGNWryZjN2uAU2BaU3iRq8qtXA7ehKnEGzeuU03kkQsKvzJhkyHVC2jUK6qjSj/InGkISISCyYij5E33oEUqwK8A+tHcGEQ+FwnB2siK6ygNfjEGA2h1uFvO3NViMS0G0RjEiPRdZeWUOntT9sUMEkYIp/uFLxo8aUloIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For applying DAMOS_MIGRATE_{HOT,COLD} actions to a region, DAMON virtual
address space operation set (vaddr) calls walk_page_range[_vma]() for
the region.  The pmd walk entry function, namely
damon_va_migrate_pmd_entry(), collects folios of addresses of the region
in the pmd.  It starts from the walking address and advances the address
by the size of the folio of the address until it goes out of the pmd or
the region.

Let's suppose it is for the first pmd of the region, and the region
start address is in the middle of a large folio.  Also, the next folios
are small.  Then, some of the next folios could be skipped.  Fix the
issue by advancing the address to exactly the start address of the next
folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org

Fixes: 09efc56a3b1c ("mm/damon/vaddr: consistently use only pmd_entry for damos_migrate")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 035cd509f6b58..aa833c2c4fa35 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -669,6 +669,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		return 0;
 
 	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		unsigned long page_idx;
+
 		nr = 1;
 		ptent = ptep_get(pte);
 
@@ -681,7 +683,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 			continue;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
-		nr = folio_nr_pages(folio);
+		page_idx = folio_page_idx(folio, pte_page(*pte));
+		nr = folio_nr_pages(folio) - page_idx;
 	}
 	pte_unmap_unlock(start_pte, ptl);
 	return 0;
-- 
2.47.3

