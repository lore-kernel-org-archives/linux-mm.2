Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B90CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 22:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D013C6B0005; Tue, 19 May 2026 18:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD88E6B0088; Tue, 19 May 2026 18:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C156C6B008A; Tue, 19 May 2026 18:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC8E86B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:00:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68FF49389F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:00:14 +0000 (UTC)
X-FDA: 84785538348.21.4EAE96D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 77AA220007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:00:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="IfMl/NWN";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779228012; a=rsa-sha256;
	cv=none;
	b=yANZpQziR0RnjPDUwp8p0UFH05toEBFalj9j9IpkawHZV1M3eA2UqmaGSeN3XAuVN+gpR+
	sRq+OFmodRK/WZvIxlzZhkU8aI+1ODnv9ncc6XZWb8LFtTxMgEpYGvU/iJEEuvjSpxpP7j
	HYROdK1EKKk5d8zwl2MauH4CavqUhFk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="IfMl/NWN";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779228012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnGwuiYlVJlBXNtcIqK4KbKEb2r6ker+wowDhgc6gnA=;
	b=6lzZt6kogNG2uqBsEqlElLzS9kFGjNy+f1Zrp023BfyK+2p8w+DnmDofHF6z55SEJFjd2R
	miGSvVGd+U+k88NuG/+nlEhDMPn8Kx+bXmyTD+XJDkvCoSQxxoQecA9D1w202sMGUfvlbu
	5VTZqtaH8BXM875DjlOrS5cA9eoHazY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67FAA43CE8;
	Tue, 19 May 2026 22:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDFB1F00893;
	Tue, 19 May 2026 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779228011;
	bh=GnGwuiYlVJlBXNtcIqK4KbKEb2r6ker+wowDhgc6gnA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IfMl/NWNFt1b1HQUzivum+2BhsMi/hbKSotMR6HUnqUIgTpccTixvjpyqhu9Aa8Mg
	 UU23C4UYmod2eGcw49FL/HN0QKDQuA18YhjA00j5AAVCA0kbzk6bSYZwa+dFIerwya
	 0HYc7kI/lgvIYw6kvLuUHiOp1Q/FX/8UBpHRR8Yo=
Date: Tue, 19 May 2026 15:00:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Sunny Patel <nueralspacetech@gmail.com>, David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
Message-Id: <20260519150010.a1cb46f2c8478414117d6932@linux-foundation.org>
In-Reply-To: <4c3eb1b4-1ea6-46ea-b04d-b218ef266c7f@nvidia.com>
References: <20260501115122.23288-1-nueralspacetech@gmail.com>
	<20260501054416.af0ed62d635c3eb01d425e61@linux-foundation.org>
	<5b25ef69-ffd1-49f3-a340-db70dcc96b29@nvidia.com>
	<4c3eb1b4-1ea6-46ea-b04d-b218ef266c7f@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ek5aed5is85z1bp4joq68q3yc7cg7xbo
X-Rspam-User: 
X-Rspamd-Queue-Id: 77AA220007
X-Rspamd-Server: rspam07
X-HE-Tag: 1779228012-401219
X-HE-Meta: U2FsdGVkX1/5ucjj9qjuhj8PoUeHuFoVB0c0cIOK1oMwrBJetNwBPXAj8dtXylBEP6/KyucGQF47XgchzEJ00CVj33zt6Js+VTZnbaKTXh4yNRx8BbQUrFnc5vYpUyjqGE1LeXHsXVBYrmSvBJfAHskRs6GfKkXF/y8Xy1nXP6fhy6Yus9oaLiNSP0U8j5GsjhBlG1q35UlMxU06lXV6L/gnhCZ48+WsmLH/RjSncPta8lFcYS2C6hyi51x2eu2Mu80HZfiAlI9ds3m4VVZlRO+EWot3cSr/C/QUll9ejbACeBzFrEEzkg7mcYPfsKXH/geLd1gmvDpNeDXwDlMUTymRF8FerOkoxKS65bYf49L+3QuLPs1yrvJSCOjVOSDiHYL59aHAUPFWsCawzQnQIilxfwU8QsTkcMAWNn2XLaKQnGUgnkjlVkYnS6n5GjDOAn+ZzBSkwAI6TglcKcVaLS5359Xo0dXnjEq8qJqkc6lTmbwDhoaNUzOAqYYVP2Ir7Z3UwkxmCWgO5JASurTlYjO1pRdp5n8HSyALnLpsadLnoWC1UOvpBwSW76oFnrqlppIJY3y/w4unFj9KxveoV7is0+xuNYr5tFxudlYJSx0doZc93OrZbKBU0UQ6CXcgy03k53jrz/glYIs4XHLDjfm0aDEqCCHYJO7RMaVpcr5yQXY7VUJmff+x8L4LZ4iCkMcbiOdjmqeNPmxF8Y/g4pPbyXjS6fhlrEdlO2SalLd2zeQArONpgs4geMXdPUjo7nkOgF1ty2EKAQq5xFEPxuTixQi1obmWVGFhvefYdsfqNjMgQ6WDiMAsB4p0UMp3q+OwyBJmO2QKxqXaffuGoY/NnT1cMnDWRQ56mmWXcWBpswKZSFR87EwHHK7rXi/J+LXlNNmYTrovAy1p4j6peGzPGtAoVdqTF2EgyGdJw3ljN7WlVL3N+n83ok5ePEnWSs888iY3WKJxF3IYi5G
 MqTElgaJ
 XeBVhJZJCblrq9JktSfRPaZN5e1Esuq/3xBPAnVW0uCd7IUFa/SbQS6k/HOcSPwUh7XPXKcIAnG3q78enaWUsLGDDYbwVEfIA5WzxXSaPu9GDOrINN+JxwhtWAVBiuHRl3EbP1ZMN9czLr5PhgmXAhfex/J644gQzOpLJsW55o9xtoLhU+BzgkjdJrV3PDg+IqBTfPvcmSGaFB0I/hTjX60DFxlG8RH5UvfqQEWW8chk97TjEEADBL9ustA3w7QiFvHHv0Df9sSpEAvKd0sVBU/Ou3mQoXUxt2KrIaM44WvYPLk5Vt3qDjuzfLU3QhDvuzK55TESMm++nTP7qGqbiGuC5HcfEf0Kut3/8FiQzKxsZ/Ewgm94qAyeFAGQm0taDmu+lHT2U+XpMBnDJwFWhxFj7r0ig0qd04I38yZLvIDZ0ptCZHtN8zPiWsJbKo62+hX6cdGWdOZalvpj/3TiQunNoJghGIWfokYHLoxYtEQ/0B+gKNxoN5BEBAvoP66wKxK2Ibflnj2rxT/XvqG8cgg1wPU3TMIrQ/K+EUXEgVZFH65drWPZqcCSPlaF+pAh1OVBpeSzhNTQe4Y+IHYHzilJeP7UTGPdPwvuF0xPx6+VZWYCUvljpbyiyRZndFZVwrS7Z+Vq+HX7N17uVjH82L95Pr+3NDpdaycF1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2 May 2026 10:59:33 +1000 Balbir Singh <balbirs@nvidia.com> wrote:

> > 
> > The issue can be reached if we try to migrate a non private/coherent folio (I assume DAX/P2PDMA)
> > pages. Even migrate_vma_insert_page() has a similar pattern. Creating the pud/pmd/pte structure
> > there is unnecessary (but not allocations occur, depends on pmd_none() for example), do we want
> > to clean up all of it (need to think through)?
> > 
> > I'll re-review and send fixes as needed. Looks like David sent some fixes out, will review
> > those as well.
> > 
> 
> I checked migrate_vma_insert_page() is no affected.
> 

Thanks.

What to do here.  We have a cc:stable hotfix which is adequately tested and
seems to have passed review.  And a cleanup patch from David.

I'm inclined to upstream this patch as-is and leave the cleanup on
David's TODO list (one more can't make any difference ;))

?


From: Sunny Patel <nueralspacetech@gmail.com>
Subject: mm/migrate_device: fix pgtable leak in migrate_vma_insert_huge_pmd_page
Date: Fri, 1 May 2026 17:21:16 +0530

When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
to a PMD check failure, the pgtable allocated earlier via
pte_alloc_one() is never freed, causing a memory leak.

Added free_abort label to release the pgtable in error path.

Link: https://lore.kernel.org/20260501115122.23288-1-nueralspacetech@gmail.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/migrate_device.c~mm-migrate_device-fix-pgtable-leak-in-migrate_vma_insert_huge_pmd_page
+++ a/mm/migrate_device.c
@@ -840,7 +840,7 @@ static int migrate_vma_insert_huge_pmd_p
 	} else {
 		if (folio_is_zone_device(folio) &&
 		    !folio_is_device_coherent(folio)) {
-			goto abort;
+			goto free_abort;
 		}
 		entry = folio_mk_pmd(folio, vma->vm_page_prot);
 		if (vma->vm_flags & VM_WRITE)
@@ -893,6 +893,8 @@ static int migrate_vma_insert_huge_pmd_p
 
 unlock_abort:
 	spin_unlock(ptl);
+free_abort:
+	pte_free(vma->vm_mm, pgtable);
 abort:
 	for (i = 0; i < HPAGE_PMD_NR; i++)
 		src[i] &= ~MIGRATE_PFN_MIGRATE;
_



