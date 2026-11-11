Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E1C0606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=e8CQsAlW
Received: by kanga.kvack.org (Postfix)
	id 9D2C66B05BA; Wed, 11 Nov 2026 02:19:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A31F6B05BB; Wed, 11 Nov 2026 02:19:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8386B05BC; Wed, 11 Nov 2026 02:19:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DA026B05BA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:19:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE80FC0226
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:19:20 +0000 (UTC)
X-FDA: 85421987280.17.A4508FC
Received: from mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id C4977100004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:19:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e8CQsAlW;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794381559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2B44I80yRTwHpmne7w8w5UEwVE2FyJszfb9G+y4FbZQ=;
	b=PapCZUt/UANgqur880Q35/iqjKRYtnr7BrFImiju1cMRV5R+YEAiD0BFXBIPD6frZiaWNu
	tpZJ0WTxYClTwxvdcBNq6DVaabh7PtPLt9ABFRTZqoIV1uD6MCEs6hK5lEWzsvY72MrBdW
	ox2rmTSXn/D0m3dwHn/jn3MExFJWNE0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794381559;
	b=7VV/p69Wewn4WIeczxeJasmZTJVUMs7qvXu+MUkNADNr9EaOEHDugCbfkgjkYoC8aew4ea
	qIO/NWRbWl0ckglvHixc25v+rK0LD/i1WelJb3GgmUKeHxY/kX07gtxq+CjVpLtBV+xedV
	9r3GVLAcbSzT3TWCogx3Ro49ZMLf1j4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e8CQsAlW;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=e3C2YxWwamp1JVxxl+Kr1uZVG71pB4w/RtL57aIvTw8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794381557; v=1; x=1794986357;
 b=e8CQsAlWT5fwC3bouk2rRXr/uuK41/tLMOeOxpo8OD7eCxQxEUyLLEvOG4R7xRcTMuW8EWAT
 ZCSq+w9+SB8lyekQS0JCulRmcWy2HkDVTC7XM1g+1Wqzyusm99qF9i6fJlq6+5K7+X67L6ywksh
 knAkVVO4yIUjcdKQWVlQ8HfE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 585797a17084865f;
	Wed, 11 Nov 2026 07:19:17 +0000
X-Mizu-Trace-ID: 585797a17084865f
X-Migadu-Flow: FLOW_OUT
Date: Wed, 11 Nov 2026 15:19:06 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, baohua@kernel.org, kasong@tencent.com,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, david@kernel.org,
	rostedt@goodmis.org, mhiramat@kernel.org, hannes@cmpxchg.org
Subject: Re: [PATCH v2 3/4] mm/mglru: skip cold PUD subtrees during aging
Message-ID: <avQW6uvW7iG9Tw_F@fedora>
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
 <20260901063755.1519710-4-hebaoquan@kylinos.cn>
 <atJwMRHXzXc57qpu@KASONG-MC4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atJwMRHXzXc57qpu@KASONG-MC4>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C4977100004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gmw1yixjm4qmnypgkinyi9xxpb6y6b7b
X-Rspam-User: 
X-HE-Tag: 1794381558-150834
X-HE-Meta: U2FsdGVkX1/safoYD07Y+/1FKGYNKD8DnQDy/vx5gcVffrpLngoPA47GGlRTsonntura8BSBnzYWlPstAj2CMNJUIm/vMWnSYfgVZuABPRRKcItHorsSrZ6P0YIhm8p2+Qo4s53JMbxX6lg60LFfeHGtNlKsgmkCivNN2Ha+O2LOeLyIkNCFNxuQkkqBFIaHp/JRftN2Z2n14HanBnl85lLGuT0XlzNTQpN1eqrs6a0sNJ00uFxYsVMKyTDJutjrBL2pOvWPTlv6KMqrGVvL11cIeoBL1vQUedxt98sYQs89pPyKid5USH4RPgcFJHDe/YbsSVV9zWRISpCBPk0AWrCd/zbEWNXUD+97yGjLG0qBtGAQbx0PAXKODh1Vk99IX2/dBXrP837TsNPl6T7tEAClOm8d0jXsO6DBfb9m+BCWiOy3VMJ9VAJbT0t6VDlpWs8Yw+UvJlkGchYySm6Z2SYtvgbWl9A4hsxaY6XP9ncYEIzbb27MCU1792ncIpZwhjJBkECDGVbNyCUqpKlsVFzgdEmRxxLFeP+UC3kZjw6kHjvWkUVxHUm4lC99aBc9JzAbatYOJDeZ77J4i27dL+LTCl0yFMOJXIlfBT8JYR+vf5fRWn3EZBM7i8nfWhJnterIMDMe5LZ9bl54NTJpwX5lk6swe3jmXqqIi22K+e+2CMuNjCG1rqxowTuL9eEzbx98HMTIclGLTkMOY9PlWmC4sY7YhXxz60XNe9cM0MCFFb0B9udX50BhBlyyzbNxw7nZUwZqo/+CHXUlaSS/Eikgn4aL4wGCP8FLIwrpG9gzirkz0AJJ+bh1fKTIOC/7SluB/5h0I2VtJNVBplkmm/Ax0MdLoBRrAqWD1VLLNopn9Fi2UezbKFiLv+Sv1uPynmnDnbEtdy+vlXsnkv4Veu8iU6c0rfrzmtOfo2eoyPQoFUBpnDHkOH/QWFHyp81BTvD1PPvZK/hcUZgnOs+
 1JqGff3e
 L52eP7idI+ktC2EG3s8mzC7sFBeNSlYczLgdQqOH0Vnl7fIKqfFLIy9oTIk7DWEEOa5ho0rCY09UZNI2WsZyvkA/SjRKJZ/hA8gb6z5ls6nBXiFkpNbuVJCWfoAv+jghsWBJbArXfM1tN7iC6zqYeWTD+Xwl02V8AWRrqxMkfASGpXeO0yJ7p/Ig0/2piNpwXKoNw7K2m0G9fdufsoPPGCRZzUVTw8zL8xU21hW/BmYO6ufx5/BJWAdFWZMqfa/XjBYesKv6inPvFMy0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kairui,

On 10/17/26 at 03:53am, Kairui Song wrote:
> On Tue, Sep 01, 2026 at 02:37:54PM +0800, Baoquan He wrote:
> > The aging walks into every PUD and runs the PMD-level Bloom filter
> > on each PMD. Add a coarser PUD-level filter (pud_filters) one level
> > up:
> >  - walk_pmd_range() now reports whether it found any young leaf entries,
> >  - walk_pud_range() records that in the PUD filter, and
> >  - on subsequent generations, skips the whole 1GB subtree when the filter
> >    says it had none last generation.
> > 
> > The double-buffered filter flips with each new iteration, so newly hot or
> > migrated-in pages are re-checked promptly rather than suppressed
> > indefinitely. force_scan walks bypass the PUD test, so manual aging and
> > newly added mm's always rescan and re-populate the filter.
> > 
> > To keep hot regions marked, also report the covering PUD from the rmap
> > feedback path (lru_gen_look_around()), so regions whose hotness is only
> > observed by eviction will be re-scanned.
> > 
> > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> > ---
> >  mm/vmscan.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 47 insertions(+), 5 deletions(-)
> > 
> 
> ...
> 
> > @@ -4397,8 +4431,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
> >  	lazy_mmu_mode_disable();
> >  
> >  	/* feedback from rmap walkers to page table walkers */
> > -	if (mm_state && suitable_to_scan(i, young))
> > +	if (mm_state && suitable_to_scan(i, young)) {
> > +		/* the PUD entry covering the young PTEs scanned above */
> > +		pud_t *pud_p = pud_offset(p4d_offset(pgd_offset(vma->vm_mm, pvmw->address),
> > +						     pvmw->address), pvmw->address);
> > +
> >  		update_pmd_bloom_filter(mm_state, max_seq, pvmw->pmd);
> > +		update_pud_bloom_filter(mm_state, max_seq, pud_p);
> > +	}
> 
> I saw the discussion from Barry about the concern about the overhead
> 
> I think we can drop the PUD ptr walk entirely. The filter only
> needs a stable identity for the range walk_pud_range() is iterating,
> and (mm, PUD-aligned address) gives that on both sides:
> 
>    walk_pud_range(), test and update alike:
>       (void *)((unsigned long)args->mm ^ (addr & PUD_MASK))
> 
>    lru_gen_look_around():
>       (void *)((unsigned long)vma->vm_mm ^ (pvmw->address & PUD_MASK))
> 
> Will this work? Also I took a look at the hash algorithm of this too:

Sorry, missed this mail too, thanks for great suggestion.

Yeah, it's a much better way to do pud level filtering. I will
switch to it in v3.

And the same idea on PMD has been merged, your suggestion is earlier
than it.
65a9bf08a3e4 mm/mglru: don't use stack pointers when walking PUD and PMD tables

> 
> static void get_item_key(void *item, int *key)
> {
> 	u32 hash = hash_ptr(item, BLOOM_FILTER_SHIFT * 2);
> 
> 	BUILD_BUG_ON(BLOOM_FILTER_SHIFT * 2 > BITS_PER_TYPE(u32));
> 
> 	key[0] = hash & (BIT(BLOOM_FILTER_SHIFT) - 1);
> 	key[1] = hash >> BLOOM_FILTER_SHIFT;
> }
> 
> And hash_ptr is actually hash_long, 64 bits if we use hash_32
> will it be even better?

Right, hash_ptr() is hash_long(), i.e. hash_64() on 64-bit: it hashes the
full 64-bit value and returns the top 30 bits of val * GOLDEN_RATIO_64.
The 30-bit width comes from BLOOM_FILTER_SHIFT * 2.

With the v2 pud pointer as the key, page table pointers share most of
their high bits, e.g (0xffff8...). But with the new way you just
suggested, it's the other way around. With the (mm, PUD-aligned addr)
key the low 30 bits are cleared by PUD_MASK, so the address difference
lives above bit 32 - hash_32() would truncate the key there, and two
PUDs every 4GB in the same mm would get the same keys and always share
Bloom bits. Please correct me if I am wrong.

Thanks
Baoquan

 

