Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE3610A62E8
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 818DE6B00AD; Thu, 26 Mar 2026 22:15:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779476B00AF; Thu, 26 Mar 2026 22:15:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4926B00B0; Thu, 26 Mar 2026 22:15:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 470096B00AD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:15:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F07A513C3D1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:14 +0000 (UTC)
X-FDA: 84590225748.20.B0A7504
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 47FF9C0008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qUprQn+Y;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfNWz2MwM4ZY6bFGmoYrNTnpJRQZnNwj/uOrRkiYL5M=;
	b=VRozbKrFNKNxsexocexC8Hd5cPZ+f/S85gofOOMQM2ZjxWylLPdywE13RmRbTda8s7MqQD
	23+9JjrHlXqxZBP6M0MjVnKSQKphr12pBzitDyTgSMQN8GJIh+YyscoAwQ9XagWU3y3Lg6
	4Q4W5m1MG+atOqRUbr9/G7UJHKrgPys=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qUprQn+Y;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577713; a=rsa-sha256;
	cv=none;
	b=VbcIQCdc5GPekQJje1CpcQNZ9dGe/9mpvHDaC/Wbn81c4E3jWJTwqXQ2XctTO68PiTOQhq
	sKNfT764WCtdBASbv2+3sFnfYEmUqpb8cCOU7tBSrJ1RGPrNB7dH9UCb1iffUGGf4G2G+J
	TeCNaao/lLzCyg5Fih+sDhCUVT9W+fw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dfNWz2MwM4ZY6bFGmoYrNTnpJRQZnNwj/uOrRkiYL5M=;
	b=qUprQn+YADvN/9XX6sWYfNa/kg5jNuE3cirjiQ/YhUk5tRCUEKizV7YGDnhu+O6mL2/RmH
	oTF5aOueObHp18z9I+INhJ7C79JF930GoJirPSOE8DqOuuEiuDjMjZKFEcq6mi9dt+yWRn
	geRfame3sIEEpbw6/P4+nyJYGxERCHk=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [v3 09/24] mm: handle walk_page_range() failure from THP split
Date: Thu, 26 Mar 2026 19:08:51 -0700
Message-ID: <20260327021403.214713-10-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 47FF9C0008
X-Stat-Signature: sbbbp8z6cp9eb8s7gfxwzk5csgdo7q6y
X-Rspamd-Server: rspam06
X-HE-Tag: 1774577713-290143
X-HE-Meta: U2FsdGVkX1+c/AOjLflTbYpkU8Zn/9c1Brb4g4CTrBeC9A06qzsuMbLkqIPoZmPT5ynusG/p6mTGFi9IlJ2qdS8qO8e+hiZaypE2gAPAjUWGwMZ6WS9Dj7FkOTt20wsrMR+kSAazEHDluVYDaDD0XIcvn0XHslguxLnbQluMmpuNTG9CbGo1nCK/BGHSYBCa0WZQz2ufDnQjyKXrVl80XInD7FUSCMXyBHIIVvcEZlyRMKi4PiFFzynTu139K+DLfGEiaQAdrljhjhocjx3hMnHIkMyRpZ31bZ0t8UfbMP9trIffsWHjHal5sraaEAci3k5vtuiYNBMSdJGDTafAq+cnIOw8dw3vbH6rEIcRCfQj9gHb/R5Icq5869XHexMcz63YOZiHsl2odcRe63ckqZvFXGeLMOQiB2O+jGwaJJ6dDkqRir5mSqKQSD6xDI6T08VeUHgnqxB52G0LGdp0TD44ZOBoJw95CUWFCQCD63DMLzD05nPU8V5SWjN8kIa1R2fm3R4CzxfRYPbMCv8pGJsXs6BtyaFVP/YYpDmbcpu12/oIwh+XeUyDDLgGn7k4pk5sqP6QMqrxqNeEgz6QBc/MMm0Pb6RPXE5wGOX3tyaxxaAoSq+XHv0DMkx4qMZfIx/VVAKIxLdGY/G1HbI7gGTr1k3g0suXUaxR6xkwqdtzNz9zEefCMZ6+Rl8fgy7UpQ3cG7fD+vBbbVkdiqwIOZhMJghFOvjOQq+C2oJcMgz+KTsL96ajsDEsFRGzJjwNcESgMUtw+UT50rVTwzQDrDEfN5xr3QswnWa7CJvFTk33EKnVW44yGzS6CKfi/jl4kOlpdoOc/xcb/wvx7JwuUYWtk43V7OqylYQVilhCANt33CwqV84YkvS8sClid0OGQwV8RXHPfIARMwWHJXHFz2Qf2PxpG1sOKA98ubtyJLLvSBR27Xmgbo+0UX5fGnbcCgZBwFUMyC6vqdzOE1O
 L8nh8LjP
 qfHj3KQGhq7L7ASoDaMSjabXLCUnh5J748JZnXVS7nf+WtGfLS48HpRKwWY8ftImywQB9gvSnJohOi1tmXJJd00N6ptAHerLROhlghWAyuzl2Qn2Nl0h4t8SjXNdvLU3herBpm8qWmBK0iOmgiaWZXW6h7HSzTuaEYjFFR+QuJpBufC8sDp1TQIe8PvIPJ4vAwKWvgd55F8yIjLpMrkQQkIq23Sjw4dWio4p5YZfyGFjevHxWFIPCYK+aqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

walk_pmd_range() splits a huge PMD when a page table walker with
pte_entry or install_pte callbacks needs PTE-level granularity. If
the split fails due to memory allocation failure in pte_alloc_one(),
walk_pte_range() would encounter a huge PMD instead of a PTE page
table.

Break out of the loop on split failure and return -ENOMEM to the
walker's caller. Callers that reach this path (those with pte_entry
or install_pte set) such as mincore, hmm_range_fault and
queue_pages_range already handle negative return values from
walk_page_range(). Similar approach is taken when __pte_alloc()
fails in walk_pmd_range().

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/pagewalk.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 3ae2586ff45b4..c5850de71b8cb 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -165,9 +165,11 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 				continue;
 		}
 
-		if (walk->vma)
-			split_huge_pmd(walk->vma, pmd, addr);
-		else if (pmd_leaf(*pmd) || !pmd_present(*pmd))
+		if (walk->vma) {
+			err = split_huge_pmd(walk->vma, pmd, addr);
+			if (err)
+				break;
+		} else if (pmd_leaf(*pmd) || !pmd_present(*pmd))
 			continue; /* Nothing to do. */
 
 		err = walk_pte_range(pmd, addr, next, walk);
-- 
2.52.0


