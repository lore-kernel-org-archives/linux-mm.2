Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1FD606A335
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ikc01+Yw;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=H67vUejc;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ikc01+Yw;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=H67vUejc
Received: by kanga.kvack.org (Postfix)
	id 4EA4E6B05B0; Wed, 28 Oct 2026 09:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49B126B05B1; Wed, 28 Oct 2026 09:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A726B05B3; Wed, 28 Oct 2026 09:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 072196B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:20:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6354CA8B3B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:20:34 +0000 (UTC)
X-FDA: 85372094388.15.0CF430A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3D67540005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:20:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ikc01+Yw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H67vUejc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ikc01+Yw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H67vUejc;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793193632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eP4c7kBh4vXoea1Jno5pzeNfYitw/HO5XidJB0zRVa4=;
	b=JQ0SjK8iPIdcaGi2na0SctycW+bazYKEyZl2MCYH1tnTxmKkwVJGW3i9t74jYYPZuGnAmT
	aW7PtqnZTKCX1e2wwwgGayjlubvvqWuV+ybVkJpkdwysZSfFtMjbk4VVOio1Tt2PWF02MB
	AYQkRfrYBh0WxF/xWyWhVUlHd9xhOhc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ikc01+Yw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H67vUejc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ikc01+Yw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H67vUejc;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793193632;
	b=BhyuSWRhu1Ua1wHtBHRbWbwBj/h7AYe+hIdkD4x/BX2RLWRj4R/whDgR73Vzf+y1XB+2DX
	1Yob3F5neLHexr2LOaI0YLPkp4LFYEbo1NWpSI7BImBDZWc8ByHyHch+P2+brjTX+eXqbG
	SDc5YPFwevTTsxC/vk/36euIaPmIRxI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5D1A51F7AF;
	Wed, 28 Oct 2026 13:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793193630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eP4c7kBh4vXoea1Jno5pzeNfYitw/HO5XidJB0zRVa4=;
	b=ikc01+YwkeOjP5cK4KAg7kIoSfmaM/gDbSvjS1fyX9g7tvuFqqvq/YRInE2SmYquyKuV4D
	aHYXced9O69IJ7RGfVG5LE7kLChiFHEqnyrGiFwspHb5MLam260d4LDSYXFyhX2+5Sy8BS
	5hXUItxzlNghQKEUiaIz3NO+Xfi6ZEM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793193630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eP4c7kBh4vXoea1Jno5pzeNfYitw/HO5XidJB0zRVa4=;
	b=H67vUejcCsq2/G2lrDpyvijucebSJxY4S+sD6pv2UhwuYbNF8k8aRG0jrgVpf3dy0w6evT
	+N2yNvzlHwnULBDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793193630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eP4c7kBh4vXoea1Jno5pzeNfYitw/HO5XidJB0zRVa4=;
	b=ikc01+YwkeOjP5cK4KAg7kIoSfmaM/gDbSvjS1fyX9g7tvuFqqvq/YRInE2SmYquyKuV4D
	aHYXced9O69IJ7RGfVG5LE7kLChiFHEqnyrGiFwspHb5MLam260d4LDSYXFyhX2+5Sy8BS
	5hXUItxzlNghQKEUiaIz3NO+Xfi6ZEM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793193630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eP4c7kBh4vXoea1Jno5pzeNfYitw/HO5XidJB0zRVa4=;
	b=H67vUejcCsq2/G2lrDpyvijucebSJxY4S+sD6pv2UhwuYbNF8k8aRG0jrgVpf3dy0w6evT
	+N2yNvzlHwnULBDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5339213419;
	Wed, 28 Oct 2026 13:20:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UXF+CJr24Wr9MAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 28 Oct 2026 13:20:26 +0000
Date: Wed, 28 Oct 2026 13:20:24 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 31/46] mm/mremap: fix moving PUD leaves
Message-ID: <auH0bgdchd6DyCbU@pedro-suse.tail5790ac.ts.net>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-31-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-31-6f74bec9a5bb@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 3D67540005
X-Stat-Signature: ognniy9umckkjc67idh3abpcs6hs5zrn
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793193632-570555
X-HE-Meta: U2FsdGVkX195lgFgo/pclqQKp3v8xL6Fb5QiTuVq4KQcTD6pmaIwot4RAI3betFYM31DEpY+hsrWyfnNwGWRWmw9NaYk0Of+FS70p8Wg8LK+/SRsaXIlzWF+GDnK9TH9PbAupz+0Bsaqjuv6q0sEOM3Tg8FjCtoIh9iTH6IQsJDW4M4ifNuQj0ih0ww8i6cBWbC+QKplt57bs6AezPplGiPwQ992OS/HjtJcE+M/r9A087ggonVWeePEx+CRMG3CmDQYMKYO9NZPJ8pLa5KmKVy3qi5DxFyC+JGPhRroG6anrr+JRPGM7p4BCnlaNpN2TlFgjEq/OE0/d8Iz7JMrjqST0UthQyFrZmGTcuNAo61sMLS4ucsgTV2tNEEdWwC3O2RyopBTbC2rsCQK+LvlDDYkHkNxDccjqatiRMYEzphr8KQUHHARJk/tcG6IbAIc9aXoeO5TC8u/lpSSFJOS2B/8pgBUxRAxMzyAB/Tm1rsmy+Hyu6jAj8Dv9FmxhOYrmZtNMY8FSJ/tFBTRGvmtX8NERDFKFj1ehXWgZnHZ7xG0tH6HB+KLCpAe1qXb/B6wOfNnMLn3bRo3wvm4LkYzc6/CzcLK0bEwa9qpbR3lThw7PLi2XQa+2VxQeOhdqDkxexjFJrQ0KVXQKnm/pqRNtzs9L/1yEj5fp6/StZTWIdvbar968+SXMchZ3Y3N+8/KKELEE0/Co96dJm0DK8WUmvcYQIKzxyg2q4ZaYnQGNpuhA6COqqmxRxvtrR73WK6DTOw5F8P1DCAIZ2uFgFxZlHXV0zmubjLo/svXlfzaxmKG+XYn1scG0viTitaN8I+xC+Amxjh3eOrK5DQG6LRWmICdPgdXYFXuv7zrypnQUoUhewxtRnVEvTnsKATaYPKLeZV3Q7B4nodlzYlHqO0LM2rNlWPMboyAzcqMO9ZGLVzBVdtc7pXRlEpR/+TyqmQ9xPsUy7myLI5ZlZ1hy3j
 GoM0UkH0
 ufYT0WtdOOGP6s9wruxx78EGfleH4IQy5ckIauQ6sUZm1/E90qECPkr3igwrb6T9Dz1UXLu79D95aIJigudFarLArAVz3QNO8LDYFJ3MgTuQcHQl2mtxj43Ykfh0veO3fOuSFBydUQRU1mBvf3n2xwLp5lNf5cobos0RnL4YkkBS/thEJuBHPd5+7vSTtLssC62+JTRxUboZQeC+ERN9i/SMFYxX52KWHdeVKDiYdqYHtWnMDefaE+jx5lvTVobRIQjsU3uHQIPb7FsRU74DitdCqLHEhCrPh+AuBIuP7df/N1fh7JTB0d2yyVLl/o69xk7rUcWJ2s6fkRT8G1rkDrlshe60/3pGBlBivJbnT8uvkifindgWe3qDR4HWmOxw3JeM4MM83yp26UrT+n0sJR+psxPfVsLW0OIzrPgcOREeqdIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:51AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> pud_none_or_clear_bad() only really works on page tables. PUD leaves
> confuse the check and make us clear the page table entry and print a
> warning.
> 
> Since commit aed877c2b4257 ("device/dax: properly refcount device dax pages
> when mapping"), this also leaks device-DAX folio references, mapcounts
> and RSS accounting, resulting in "Bad rss-counter state" warnings on exit.
> 
> Allow PUD leaves in get_old_pud(). If a PUD leaf cannot be moved as a
> whole or the move fails, split it. This unmaps it with proper accounting
> instead of treating the leaf entry as a PMD table.
> 
> Keep using pud_trans_huge() for now, in the future this code should be
> cleaned up to just check for PUD leaves.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ david: fallthrough after splitting ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

> ---
>  mm/mremap.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 91f0865f6aeea..1237718848f5c 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -87,7 +87,7 @@ static pud_t *get_old_pud(struct mm_struct *mm, unsigned long addr)
>  		return NULL;
>  
>  	pud = pud_offset(p4d, addr);
> -	if (pud_none_or_clear_bad(pud))
> +	if (!pud_trans_huge(*pud) && pud_none_or_clear_bad(pud))
>  		return NULL;
>  
>  	return pud;
> @@ -847,11 +847,10 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
>  		if (!new_pud)
>  			break;
>  		if (pud_trans_huge(*old_pud)) {
> -			if (extent == HPAGE_PUD_SIZE) {
> -				move_pgt_entry(pmc, HPAGE_PUD, old_pud, new_pud);
> -				/* We ignore and continue on error? */
> +			if (extent == HPAGE_PUD_SIZE &&
> +			    move_pgt_entry(pmc, HPAGE_PUD, old_pud, new_pud))
>  				continue;
> -			}
> +			split_huge_pud(pmc->old, old_pud, pmc->old_addr);

Note that, if the HPAGE_PUD move fails, we split but miss the opportunity to
move at the PUD level (right below). Is this on purpose? Am I missing
something?

... I say, realizing I am missing something, because split_huge_pmd (and
consequently split_huge_pud) just decide to zap if the VMA isn't anonymous,
and split_huge_pud() just hardcoded it to "of course it's not anonymous, lol",
and just zaps. So there's no point in moving what isn't there.

Lord help us.

-- 
Pedro

