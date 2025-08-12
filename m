Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4754CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 18:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496448E0185; Tue, 12 Aug 2025 14:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447AF8E0151; Tue, 12 Aug 2025 14:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35D5A8E0185; Tue, 12 Aug 2025 14:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F68E8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:09:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C638D14014A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:09:34 +0000 (UTC)
X-FDA: 83768893068.03.930FFA6
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id AC2B6140013
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:09:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ffEB7IZX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755022172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ZDUkMKu9atmajMTxQr8Zy4WtzGPeYmeD3V264EGn5E=;
	b=Y0wCUGwC0iNjg1x0H0kcKFbknnMRiHLLG3bbBPb1LbbjJpG/WAoxRY8cyGF7cxtWHhtLFA
	6Y7M9/kGFgz9cfsJAAJcV+a3sNEuj2qvbLa+ZynlKR5nYkrwY7LqMGvM7XPYfNcMhWc/Fw
	+T5tWc5qYkwrQXVCtpKvE+AIB8PKJvw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ffEB7IZX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755022172; a=rsa-sha256;
	cv=none;
	b=EdjivUhB/pjBBylUJGF25zNDlY3nzNVRrNa2YnWeQRv8Wlow0uMuJNdd7Unic36FIC9j8h
	9NmTdeSpHIsGIlXyP6taYtuvB5HmaCqkDaQ++BPf/kq9RMEG5La+sPjsL/Wa5d2dtm3LnV
	pWHrE6CU34g6C2wqKzL5a68Mb3V+hgk=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55b975b459aso4963093e87.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 11:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755022171; x=1755626971; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZDUkMKu9atmajMTxQr8Zy4WtzGPeYmeD3V264EGn5E=;
        b=ffEB7IZX7Fekbm6UMgR+oPXFQ92+z3fVHczUrcoRmS1FEUeTUT3pSbPhzovPb5zzYe
         FCrDTo3L4TiGJtDP2DT54qYCdma7AKYnEpbT6noWespHP3S7BP3fc6QEmGuR7ufcu6rc
         31P8FbMNhDgcpedCd6sTyH46pLxQoi7NX85wZRnC6WK3fpXGlVgbfZ+decowLMc5f4FD
         kLbWReh1ggywjQezghAJ7r9yRzEnv7J/ET18qUU/YzzdTLbilyhESXNrsv2CbisFETuQ
         PEJWsjGlNEe6F+GwIH9rsvk46j+pNFQisu5t06fNyi3kGat9aFkhlsnyCHvYwDIpPBXo
         uc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755022171; x=1755626971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZDUkMKu9atmajMTxQr8Zy4WtzGPeYmeD3V264EGn5E=;
        b=HKqfNpJU2K+pBMWo4fwFEPBq/EQUpDE+vodAIzl5LAJlfcP6eZ3MO8IjF+RTUmHd4s
         bzqWoQTUWRqQOeTalrd4uCVAPLXA8oTQMvh2md4CAA1IBn7mMdkp6JpL5zdWc0t7EeR9
         yNc5SM45O/d8fAnd9poiC4Nw0cX5g/2MfLpKwv4cNKDQJVBmTcjp3Qs3miia3tyq+OPB
         IJGJc5J89biZ94+NALYbtlku4c/gEBFKon+Uvr8pRjZYxbstdz3SndTkK7QN3xQPEztc
         mCbNno+V7T/sLmRwUJ9XHidk0nK9q8PuVez81Ichmj8l7rP/W8VhurcWVPeRjik/ZyFU
         w9TA==
X-Forwarded-Encrypted: i=1; AJvYcCU9ZzCcz7MsX64Bzrd2FqwOZJH5ZykPkS2gVhwCjXQFg2TIkkvdng4kB88EQpXZCHDAD6aywMswxA==@kvack.org
X-Gm-Message-State: AOJu0Yx8cOupPGcN+9EEnNzzNkvijbIuqVYKyLjK7ecuwZFqihQYWwQe
	p6CFnPUulz32aHA8VtOH2krGu+dxMAs2M9Jda9M97rFH2Cw1rnqhK91b
X-Gm-Gg: ASbGncuHjLJvCth/vNO1rEYT+Qx7tgSpxaaHKkIlyxNOtMPhLbubmXvJLCIMae7Ec7h
	k3aDpUqCtJjZelC1Fm7A2Zliw5t/IQd6Q0wrJWqhOdFazVj+yY46KrgN+EvkF9GiJDJeJibdY1O
	ELsA29rBg1S+cIoz8aN2V+25ps29i66CkVaC1XklnWfMvRuJIa7eFl+Asemop4ZO/TruJ4q53qB
	F3aUkpJbWlMEh9J7PhB+29DbnHaIpJYMKbr6/Bokx/kP9XU5GLA0rs62hmscPRZ8s+PnNg50dPT
	MNsBkcuYfVFik62c+zFYTu5Q/JH7SmsZubitKAJXUo0uJS32kHoo3M61gjkXMaFT
X-Google-Smtp-Source: AGHT+IEEXGoeStCQXxDKTFTywpHq4TMpC9VS4tHSeegQS3BoIg5LO4J7Q33M2SPYDxo1P69r+f8Ryg==
X-Received: by 2002:a05:6512:3b2b:b0:55b:9647:8e64 with SMTP id 2adb3069b0e04-55ce03b94abmr69831e87.36.1755022170530;
        Tue, 12 Aug 2025 11:09:30 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88cae595sm4928492e87.155.2025.08.12.11.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 11:09:29 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 12 Aug 2025 20:09:27 +0200
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Qianfeng Rong <rongqianfeng@vivo.com>, SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] mm: remove redundant __GFP_NOWARN
Message-ID: <aJuDV7OzUZZ4g5lL@pc636>
References: <20250812135225.274316-1-rongqianfeng@vivo.com>
 <b5ca3ef2-bd36-4cb5-a733-a5d4f1fb32fa@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5ca3ef2-bd36-4cb5-a733-a5d4f1fb32fa@lucifer.local>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AC2B6140013
X-Stat-Signature: pxk543s1k1331wa53wigxqmuu67kro1k
X-Rspam-User: 
X-HE-Tag: 1755022172-240234
X-HE-Meta: U2FsdGVkX1/8ZLiBQ555+v/x2kEyeOskLQ8sy0AVxusjWpEm0Txn97NJ+taf2dhegPtkqnyEb6Yh0empGlIWpAVstjeSbKBBtZA8Qv/ZeWLxs8xGrfnoqqEYjwM+XYjh960vQqeqcho7XjGNhRkwsntvrQPY30Lxkdyfbgs7DJu8obvr+na1bZ2yVMxXcuNQisSstL00LPRTeukRXkx2dksRaNggf9ReWtZyIgpnVQMr+HKMqdAV9HZ4LCg+HTKfiuahBOTRaWvkkeKbpqf1vOghrsFhUkL1iJCytXnxsE6LPbPZwaA1hFJ8qk7kbdkY7GmJfAJ4HQLHc0l1IkcIXQVnrhuxaF+z5LLneEjjoKRHsNK0nVJlUeC1XXu/rbTDCWuNcVdprj0nSBmC0CnoNCGYnSEIf5inZrQQTLEt+3b1Lw8YetyNHj1tMUhQDIoX+pI6l8zaHRLt4y9qlwZZ8mCqb9uoiBwPiHTe2X80hlhTvn4WdY1P0AE1GIs8HsvyzdA4jCNfOYl73C0sHZBi8uHsDeAIc/kcLkbXgPsKL3ok1yuQycnSgimNO65Rdmek+b5vLc1nc77QnwnOKVyEunetXS+b9O4adwUtoOmapFo0/zpUkqP6vdYJqXc1OFU5kme1IJFNmyRVS1u/iqeX+bJemVfRmTYLG/Vonp1mQcxkVF+MOpE4bDCTB92FWTnUK6dFU14kFXM9/UxORAp2d2JQ9aqafzG485CEw3ZDZGu8b6UupOapf+ug/Mr+czwxLoelLMDJQxgsbqxYpu4PzJnRKhkAZF8Osf9B+5Q3y3BBrO1u/JrM0YjBUT4jiezkAZJIF8gHVvhw09IFOvrIGhQBeL3oHnaWyUBm+jyZzHN2vKmFR0a7bhxftS7fOIbqZAS2UABckwEUrKyuVcn9lrSZnVsedVh3FWqdLIqiO72b7PJuG4pqg9TQkiDajpQKbGX7/PKLZ0ke3VmHvqc
 FuoE7Ohx
 yDYgwpyIN995fv9mF/wIaZl9ADj9nLCwM0SDikITqGNJPNoEvh5rUZHpva+1tKPNcG2UfIEbtWu1o9qp0Eh/wICmxR2F5DzmGn8h6JVEjhsnKQR41XXEmNaRJBWwO/5Kt86MVi7d93h1c/c7m+jLqr7+nYtSpzbETAwqGG8h9Vny5y1p9i+SEueOIc95+vPuhmuo9fUp3el1MvvRuuWgqirV4qyIaoo9BmwBhXJQ8BsHtijJtl22jjZDKXa5hhGxK27CzMzenlfo1WgGLg4NIEQa5k7ovtCpv9acfASNYJbT2W7A3vitKV40DKWnFSVmw1PBGHhVZeeywtqnxYMpD+jg+SjpCKIdEI3uv3Wat7b+YZeOI1+G8U66VQxsEg6UAbGfM7WxIHwe7bS/fgQk6WuSDQPtab5T+XS6x42a1Ka2bQxDnSmp32EAvDMePukOXVUIwVFfsJYyjMfZwoNWpVZbulp0mDez4aNIgqbx7UgQ9XnY7tgcvTIDgygGne7nOhagUPo8yTo06xw7ckrwlqL4aGZPeFXJx+SvWX731jVwGrkUlkoew077n1KYIG9BxbGXfybJcZUoebHZOD02i6EkZrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 05:46:47PM +0100, Lorenzo Stoakes wrote:
> On Tue, Aug 12, 2025 at 09:52:25PM +0800, Qianfeng Rong wrote:
> > Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
> > GFP_NOWAIT implicitly include __GFP_NOWARN.
> >
> > Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
> > `GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
> > redundant flags across subsystems.
> >
> > No functional changes.
> >
> > Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> > Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> 
> LGTM, I wonder if there are other such redundancies in the kernel?
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> > ---
> > v1->v2:
> > - Added a modification to remove redundant __GFP_NOWARN in
> >   mm/damon/ops-common.c
> > ---
> >  mm/damon/ops-common.c | 2 +-
> >  mm/filemap.c          | 2 +-
> >  mm/mmu_gather.c       | 4 ++--
> >  mm/rmap.c             | 2 +-
> >  mm/vmalloc.c          | 2 +-
> >  5 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> > index 99321ff5cb92..b43595730f08 100644
> > --- a/mm/damon/ops-common.c
> > +++ b/mm/damon/ops-common.c
> > @@ -303,7 +303,7 @@ static unsigned int __damon_migrate_folio_list(
> >  		 * instead of migrated.
> >  		 */
> >  		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
> > -			__GFP_NOWARN | __GFP_NOMEMALLOC | GFP_NOWAIT,
> > +			__GFP_NOMEMALLOC | GFP_NOWAIT,
> >  		.nid = target_nid,
> >  	};
> >
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 4e5c9544fee4..c21e98657e0b 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -1961,7 +1961,7 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
> >  			gfp &= ~__GFP_FS;
> >  		if (fgp_flags & FGP_NOWAIT) {
> >  			gfp &= ~GFP_KERNEL;
> > -			gfp |= GFP_NOWAIT | __GFP_NOWARN;
> > +			gfp |= GFP_NOWAIT;
> >  		}
> >  		if (WARN_ON_ONCE(!(fgp_flags & (FGP_LOCK | FGP_FOR_MMAP))))
> >  			fgp_flags |= FGP_LOCK;
> > diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> > index b49cc6385f1f..374aa6f021c6 100644
> > --- a/mm/mmu_gather.c
> > +++ b/mm/mmu_gather.c
> > @@ -32,7 +32,7 @@ static bool tlb_next_batch(struct mmu_gather *tlb)
> >  	if (tlb->batch_count == MAX_GATHER_BATCH_COUNT)
> >  		return false;
> >
> > -	batch = (void *)__get_free_page(GFP_NOWAIT | __GFP_NOWARN);
> > +	batch = (void *)__get_free_page(GFP_NOWAIT);
> >  	if (!batch)
> >  		return false;
> >
> > @@ -364,7 +364,7 @@ void tlb_remove_table(struct mmu_gather *tlb, void *table)
> >  	struct mmu_table_batch **batch = &tlb->batch;
> >
> >  	if (*batch == NULL) {
> > -		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT | __GFP_NOWARN);
> > +		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT);
> >  		if (*batch == NULL) {
> >  			tlb_table_invalidate(tlb);
> >  			tlb_remove_table_one(table);
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 568198e9efc2..7baa7385e1ce 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -285,7 +285,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> >  	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
> >  		struct anon_vma *anon_vma;
> >
> > -		avc = anon_vma_chain_alloc(GFP_NOWAIT | __GFP_NOWARN);
> > +		avc = anon_vma_chain_alloc(GFP_NOWAIT);
> >  		if (unlikely(!avc)) {
> >  			unlock_anon_vma_root(root);
> >  			root = NULL;
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 6dbcdceecae1..90c3de1a0417 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -5177,7 +5177,7 @@ static void vmap_init_nodes(void)
> >  	int n = clamp_t(unsigned int, num_possible_cpus(), 1, 128);
> >
> >  	if (n > 1) {
> > -		vn = kmalloc_array(n, sizeof(*vn), GFP_NOWAIT | __GFP_NOWARN);
> > +		vn = kmalloc_array(n, sizeof(*vn), GFP_NOWAIT);
> >  		if (vn) {
> >  			/* Node partition is 16 pages. */
> >  			vmap_zone_size = (1 << 4) * PAGE_SIZE;
> > --
> > 2.34.1
> >
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>

--
Uladzislau Rezki

