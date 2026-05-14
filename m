Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B514CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549CE6B008A; Thu, 14 May 2026 04:05:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5223C6B008C; Thu, 14 May 2026 04:05:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4369A6B0093; Thu, 14 May 2026 04:05:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 323676B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:05:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F24FF16099D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:05:47 +0000 (UTC)
X-FDA: 84765291534.12.ACDA29C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id C63A140002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:05:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="G8ERET/K";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YN2yPZc6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="G8ERET/K";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YN2yPZc6;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778745946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Lbg6cyj1Jb1nO4maZGvNBfgjbvvB27TqDOLgXK9cAo=;
	b=mrQmJBUzLOgndSO7etJ+P2dqvD2SvTovJtQjJ/RbjN9jVHyzLlrb+LGuzFjOOKc3A0pYce
	8dvWTJqpSs2QQWYqpErKgVdc7A0zDOMw9EFmTvF7jC4O8dVLrWsl/El+y/dyMd02RT8a1F
	MbOPC8JGhG80J4Njt6TZ+5qamD5zOU4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="G8ERET/K";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YN2yPZc6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="G8ERET/K";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YN2yPZc6;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778745946; a=rsa-sha256;
	cv=none;
	b=wZGieS5kxfXjfX3dJ0ssh4jmFtpA61WVF62JDVF22mOhJ7denWwYHIgTi0roB5qLhfp6NJ
	fBZQJlNpcrklYUHd9/VSNXeAMH119bUXj+M2fK5PL/3L+61ondy3Msj/RW2BwI5L4QT+sc
	2+fTi0AuyBLBOEPleOENxV77QalL6kY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0FDAD672AE;
	Thu, 14 May 2026 08:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778745944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Lbg6cyj1Jb1nO4maZGvNBfgjbvvB27TqDOLgXK9cAo=;
	b=G8ERET/KxDKWZ6jcm0+zZzQgpn8Mw38CeVTUw13UI2jZWyxFvh3cLONHhAcYl7dsZI1BYX
	owqI0E6GXgIoAONd/sFlzleyPfgdLsVE7+sRr64PnIX7e+ivMV3oV56C97RFa6o+CzNjmO
	b20q4U6WyT5BkfG9o41ElzspWg2drzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778745944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Lbg6cyj1Jb1nO4maZGvNBfgjbvvB27TqDOLgXK9cAo=;
	b=YN2yPZc6ftnQsh1QKMPUd/fbSSAWcHhc7YoVx3x/UClmmYvZ89La1Xtm468U90g2+5H8lM
	HJBo/b0woDIqYFDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778745944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Lbg6cyj1Jb1nO4maZGvNBfgjbvvB27TqDOLgXK9cAo=;
	b=G8ERET/KxDKWZ6jcm0+zZzQgpn8Mw38CeVTUw13UI2jZWyxFvh3cLONHhAcYl7dsZI1BYX
	owqI0E6GXgIoAONd/sFlzleyPfgdLsVE7+sRr64PnIX7e+ivMV3oV56C97RFa6o+CzNjmO
	b20q4U6WyT5BkfG9o41ElzspWg2drzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778745944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Lbg6cyj1Jb1nO4maZGvNBfgjbvvB27TqDOLgXK9cAo=;
	b=YN2yPZc6ftnQsh1QKMPUd/fbSSAWcHhc7YoVx3x/UClmmYvZ89La1Xtm468U90g2+5H8lM
	HJBo/b0woDIqYFDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3146F593A9;
	Thu, 14 May 2026 08:05:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Vh5aCVeCBWruEwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 14 May 2026 08:05:43 +0000
Date: Thu, 14 May 2026 10:05:41 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/69] mm/hugetlb: Initialize gigantic bootmem
 hugepage struct pages earlier
Message-ID: <agWCVeywSo5lk1Vs@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-5-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-5-songmuchun@bytedance.com>
X-Rspamd-Action: no action
X-Stat-Signature: aui9ykt85p69rskqjrx97xih1ha17j8x
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C63A140002
X-Rspam-User: 
X-HE-Tag: 1778745945-810808
X-HE-Meta: U2FsdGVkX19imGIvJBVrmQa2bRPN+D1EBGZOgM9CPuB9UE2u7mVtz41fRj7Bs8AePxgPKCAA8YPOosMNHJIGvNdMufbhDqGdj1fspG024eCi/HwxdqdCfVDGS2rxqz+Lq5D8/3ynTNwJipdcJoAfF9tW1nRyEONNyGOW7imFhOefoTDZS22AN39MAA3jCb/sgRupW4CUt4u3S/Z4KJW/XewJpEbUbEsDZXyc/5h3O5b08Bh9cIWn1PnG8ajMm/UauVCSY7OIRuPgeweVLJC8XfYZubit9rudqCS0Lj2V1TXDQc01advNZn43XZKP4gKOy6FUU6ttdViCNkEbWdXqOtyrZbhr9boX7QaPXe6XULTV666ti+S/v1jbv+1rE9aWoJMFn5+fkkPSROkRQ/ugz1/5dK3UX2eHMcXB5kvA1QyF2NVg2GpEruZFwtJDNiXLQc7OKlAVO6Dvd1DHBA8gBiYVOKTrxHcwqfkjl/vcMOIAgW0YsqwP5XIhRe9BR2wnoROaDlF+8JGY9GF4X/cdld/PqQySPzWT+nXYPzj5RqEH/0IBk0V1+jPluZlHgFaNCP4yMOThjygFIojhoKrUlkt5rBHoFusmNIefICzrRhxiAOTymcd9aibU/bhZMjsr8R0DPizOUreRb0qq9thOotXXzlu5x/M3Dp0GZ964vDKPL0gUdKl/EM6gLk1mfy1xKo3xot8tAd45s0tkCaLLqhisqfTl/7dSK1aU62MUXVo0Az9g0waNcQ8OnZO+GHXtM7rrUhQUMfgjEUyBngOfnAAzkPTvhVkOQKItfbtK0D9LciJTHiFjq48bDsP/OUwbhbA2yeZaTAnxrTdEdOSryjtrjGhikq4QW7YVShTuXymqXWLHqIrpZ+bsFzxOHm78pFoaEFOjYGnoHurOa6ithd3cSc8D+WSUoKs+HboccYTJX9wRUBdk/NWBOR3OJeUf0zGxTxPcnVpwJNSf133
 FKIeIqd7
 8cJowicat/XqINjnrDbbsuJ8C0K+0Fd1yKTUa3BITxhj8ZIiiqSp5RtyBQPyfwFhF0gEgI5kZyxGVVgnelPmFOlHs7j/4beXQAFVcGUV99Fp25MerLIpHiSxCnI5HU4xZo3Lr1YxsKXaxNmX5p1CxL6c0KhNja/9PPirHI2WPEnKVGNbdu9begxIL3aWbEfa+hVSQdl3ebgpZbzw6kmGSQm+kBKvU10A0fBhxKeB4muYY5Kpv/pH7MwgVxXoGb9BIGw0kYr+NpyABcBSp3ne9S/5TpxmtpCbJdn2W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:32PM +0800, Muchun Song wrote:
> Gigantic bootmem HugeTLB pages are currently initialized from hugetlb_init(),
> but page_alloc_init_late() runs earlier and walks pageblocks to determine
> zone contiguity.
> 
> If a bootmem HugeTLB region is marked noinit, set_zone_contiguous() can
> observe still-uninitialized struct pages through __pageblock_pfn_to_page().
> This may not trigger an immediate failure, but it can make
> set_zone_contiguous() compute the wrong zone contiguity state. If extra
> poisoned-page checks are added in this path, such as PF_POISONED_CHECK()
> in page_zone_id(), it can also trigger an early boot panic.
> 
> Initialize gigantic bootmem HugeTLB struct pages from page_alloc_init_late(),
> before zone contiguity is evaluated, so later page allocator setup only
> sees valid struct page state. This also makes the initialization order
> more natural, as struct pages should be initialized before later code
> inspects them.
> 
> Fixes: fde1c4ecf916 ("mm: hugetlb: skip initialization of gigantic tail struct pages if freed by HVO")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

but

> ---
>  include/linux/hugetlb.h | 5 +++++
>  mm/hugetlb.c            | 3 +--
>  mm/mm_init.c            | 1 +
>  3 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 93418625d3c5..52a2c30f866c 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -173,6 +173,7 @@ extern int movable_gigantic_pages __read_mostly;
>  extern int sysctl_hugetlb_shm_group __read_mostly;
>  extern struct list_head huge_boot_pages[MAX_NUMNODES];
>  
> +void hugetlb_struct_page_init(void);

we lost the hint that this only takes care of bootmem pages.
So I think hugetlb_bootmem_struct_page_init or something like that would make
it more clear?


-- 
Oscar Salvador
SUSE Labs

