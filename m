Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C462606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=05qekNvl;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=UkMXw2Gd;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=MICKFMxi;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iONvCRX6
Received: by kanga.kvack.org (Postfix)
	id 352036B0702; Tue, 27 Oct 2026 11:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301C36B07C5; Tue, 27 Oct 2026 11:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F08E6B07C7; Tue, 27 Oct 2026 11:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 018C16B0702
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:43:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0971B140A40
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:43:03 +0000 (UTC)
X-FDA: 85368824646.20.BF8DD21
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id BEBA980017
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:43:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=05qekNvl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UkMXw2Gd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MICKFMxi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iONvCRX6;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793115781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4U5OOZBCiWmK00YiJ7rS5NugQwh3GpoktzIg7zSeoQ=;
	b=e7h0LKXDxUto2C0vRLHq2YpknMbmsFTqqtOPGZqR7mcoa2x2cKLx6VOI49FRHjldXG9vNE
	RngWq4VKLGaeYVIRL791bJHfZ0j+W9r3HwAHTjT4FkzgvNS/xUxG8tGqySIeJC0D8vJ7g0
	cTDjqO8QAVYX9YxBfBt6mxKom8czMo0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793115781;
	b=qXdQCopfLxHVKZuTSYRzUT39Utj2pZuf3qx2G8DWJOzyx4aG2CtZFyW0Yp2CYot0FKhIsZ
	sh+8umghle36rD3cOMfCZ0rVlqtfxvsM6jNx1Df7XKj/6NIZPkdZGh9ZlzO2/VI86XaL56
	bn6RGOnMnIkCSLuOnQOEz7csWkquG1U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=05qekNvl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UkMXw2Gd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MICKFMxi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iONvCRX6;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 730EA1F397;
	Tue, 27 Oct 2026 15:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793115778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G4U5OOZBCiWmK00YiJ7rS5NugQwh3GpoktzIg7zSeoQ=;
	b=05qekNvlKxYfyyOuygu8+3pYAJao7K0mXfnE6KXfrx/hkl/80hoFbpRUtsYvyIntVj+oLv
	vDBzBlXApw5NA8MvS2EofY/+wrChBdJQmmQN51QiMhLZbC3I3VC78D5PCvDL8m+BjSSEKn
	oYiBO4ys/YhKuauk/eyKmOjh4EoZWNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793115778;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G4U5OOZBCiWmK00YiJ7rS5NugQwh3GpoktzIg7zSeoQ=;
	b=UkMXw2GdVLvAzlrBoviLIYMkafRvU0AbAnkeAfQewRgHdNSOWLW7fCE2JvkgTu2H96p20s
	kyxLvfX8bKbMwsDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793115777; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G4U5OOZBCiWmK00YiJ7rS5NugQwh3GpoktzIg7zSeoQ=;
	b=MICKFMxirw3QfXVJtsj5qm3OgphtQWfsLFbgiSg0OMS/b8arLi9n+PrV+qhxz9TU5C0bkw
	jeaogT/ENx46NUyFExJ06OC/BXyn9+MbrpS8UpOieq6JHf4oSHNsToSOwPR9/6v3GAKTOz
	YSp6NUt5K6epZ5B6IPGc74IaHM1PeAI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793115777;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G4U5OOZBCiWmK00YiJ7rS5NugQwh3GpoktzIg7zSeoQ=;
	b=iONvCRX6Pq2+FXsSue5YihO49MeLmlXlcYbh/7SjU82ZnlEfkZN4nY9rbMX+RNwFOgT7VL
	gTm89YVvu6kVYBBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 798B313319;
	Tue, 27 Oct 2026 15:42:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lULFEX3G4GoZWAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 27 Oct 2026 15:42:53 +0000
Date: Tue, 27 Oct 2026 15:42:51 +0000
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
Subject: Re: [PATCH 26/46] mm/mmu_gather: fix flushing ranges with 4 GiB or
 larger
Message-ID: <auDGY9F6EZ5dJlsa@pedro-suse.lan>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-26-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-26-6f74bec9a5bb@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BEBA980017
X-Stat-Signature: 389ducprzazcaapojnaceug54gxjifbb
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793115780-397299
X-HE-Meta: U2FsdGVkX1+xL6/fbyPSuz8v1p2Jeo3ROCT9liKycPeSzMAHQW7oDi5vJyqPgsf2C05gixAKXaqnrJyybbi4tXNGNv8ZrBdETVEf1JnmXiVRUduvYQmQ/UTjKGdrqlQgifpTnjwQqYFJPT5TNFY0nwAPDw5Gj1wrLRQcdzP+bdFKBe+QELTLrJkv060K+tNhj35hlNwm2bkIdjTnAoZ39YVtBTY5VL5JNj5TkoyxazuC2wWoPYh3XLfrJ/WqIw4DNULUIIbctFdfJRI8TxYut1VgIW396O9Lo5gJSGXBzbcV3M79I4qZCuCmH6FTykXz/SgEYXhoBnTbL+VbMblmlq562+w9+AApWnQIF/GkPhJf4iTAAon98RXD0O+9sm+gL9DuhPy6ydiHHiiP4ewYbtXOKgmz0wAHqqbdBi+cSemAHyXuQ3Jnpd4lbtBZbgPEaKD+bpGwhB+nlfLcM7ZBTdZfUuVGvmLLgsTGsLcQgRC8QFrH4SyUod1pJ1ZyFNQD0K+hSwj3Q9OrMItsa68/sU/tcKiWzPRkmd1DUY/ahtFypxxNjvkHE+sfWUMCmsNZQOlDSTyXzVSz8w/QGBWKjf5O+iQJlID1Z+kN7g1a40LZ4sNyCL80M7vVDibZr2gTnAt8Nv2+lRqOt1mOcvZMX64y4wrWQ/+TIyigrLAnWU0tbE/O03qUq//MWQz28izYjz+nY3yEy7XLk2XL/TDk4lRwfOGz/5D3sUMplqWxf6ZYmIXSEpN6G1Hj1iuEy6DG+ogorpczryqWVMzHBPm7XhTnZeqBlvEe2/kYHeeHGuN8hIGlQMs4JjZUJBeJFkgu//5p9H3HHMAn30qzsZgyWWVO5DyZSmjxGrLpgBDCjeVhQZIKgeL/wXgH2bv9o3bi0r8hLe6oALYzRnyLeizNq9uKdUU5Kz/oqsPXUM/jylRzCcai2shbdNCC8JMqlZbmsbgKCSSUUXAqoqJPfp7
 M63VFQos
 6gr95cK+Hox0bngrdO1LA1Dhd3nXbixEVgmcxwbC2cxGthx9TicPOK3RnH+FsjXwHsczvfoxfVwQSA7EJpJVJLm4hYiluS+SbAa2TBGEYYrjqmqkBPRu9AyDhZhnQ75Gbyd72dTFXPxV6Ktn4RiK/tqSK6pStyapVl63b/QPXm4dr9yoB7VCCaWYx8BKFAQNMO3YkkjQVdJgiU/xgX//FWjg4VzdleOct7jdS4gQ3Zrv9ia2Xqnd2m4LaLVQjHPXDD7gk+BUGffhtIq8IhcZyaWapfUFyLNW4noRt18cMhI24l2+RaZM2K57LdRd47SAi5dErC1MGMqz9gz9TcriZCMPo5goB620E6hcIbOy7Tbeyg47KcHfGJBJnB99xtlyqmBqCUpkNjr23tn0hvsg1acjl6RkUPxLzZwCc6SUum2jCh+dtcLFUSU8M6/jyXWUldHJNCHsDqJto6MS1gm4Al4x+yQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:46AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> __tlb_adjust_range() takes the size of the range which has to be flushed
> as an unsigned int. Its callers, tlb_flush_{pte,pmd,pud,p4d}_range(), get
> and pass an unsigned long. Consequently, a range that is 4 GiB or larger
> gets truncated, possibly to 0.
> 
> On arm64 with hugetlb, a 64k kernel can flush 16 GiB hugetlb PMDs, and a
> 16k kernel can flush 64 GiB PUDs through tlb_unshare_pmd_ptdesc(). So
> at least these two scenarios are affected.
> 
> Fix it by flushing the proper range instead of the truncated one.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: b528e4b6405b ("mm/hugetlb: add tlb_remove_hugetlb_entry for handling hugetlb pages")
> Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ david: use two-tab indent, simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/asm-generic/tlb.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index fbe1114e9a443..3f4a180b48f3c 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -350,8 +350,7 @@ struct mmu_gather {
>  void tlb_flush_mmu(struct mmu_gather *tlb);
>  
>  static inline void __tlb_adjust_range(struct mmu_gather *tlb,
> -				      unsigned long address,
> -				      unsigned int range_size)
> +		unsigned long address, unsigned long range_size)
>  {
>  	tlb->start = min(tlb->start, address);
>  	tlb->end = max(tlb->end, address + range_size);
> 

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

