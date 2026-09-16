Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D6BC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBC506B0088; Wed, 16 Sep 2026 08:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93716B0093; Wed, 16 Sep 2026 08:09:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B82AE6B00A3; Wed, 16 Sep 2026 08:09:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 918DF6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:09:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08AF61A06CB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:09:55 +0000 (UTC)
X-FDA: 85219506750.02.01DAEDC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id A0B2120008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:09:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SQzgqKj7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ii9UL340;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h4lTgrcS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=drprDADX;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D85vXBe2xfk1jvSWs9TcMey2V3KKLMoyz3bWz1rk7eI=;
	b=T8bxO/SZ2+FL5QqQJvzBuVGJM2n6KXtwvUbvZmJtsNHGcOvdh/RIErxEOpgME+Cg1Ei0p5
	FYNDGrnvRdKVeaxY6z0aCFrPHIXseOPwRfToXA7ESZqltWl2r89ljREM0rixAhjOa6TwSr
	Ov0MpcI/rRakAHhfrjZ0PmvL4HHKwrk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SQzgqKj7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ii9UL340;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h4lTgrcS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=drprDADX;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560592;
	b=a08ZifNKomL7fwMkyEtT1yPFPu2xtcAS0Wpv/iTH3Kgw9qf0/Zx66RCSMcNxEOyyEr1p6G
	gZ1Jm2VitcQSmIcpbOTPips8R9v6MiOBjQRbeFVEJpItznfAWpBtLvwAQNuwAjjzmhVcQm
	g+ZQjvIlrZSstUB5jxrZ4qF27b3pKQU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E73E81FE5D;
	Wed, 16 Sep 2026 12:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789560587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D85vXBe2xfk1jvSWs9TcMey2V3KKLMoyz3bWz1rk7eI=;
	b=SQzgqKj7lsf2UAcZl4s6jxmS3A9EcIP48QnkWkH5uJB7nLt0OSGd0HBtKtZJp3VCnxOD+X
	0T1OIq6Uv3JtwGfGX1k01qAagOOWDn49od7h+lcstDyBMU1y07mnLTv1oLA+PvRI19RPZ/
	SdieQeijm6/QDJgPmbZloi3vnFO3+X0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789560587;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D85vXBe2xfk1jvSWs9TcMey2V3KKLMoyz3bWz1rk7eI=;
	b=Ii9UL340WKjT4dH6mhNsOgZQXueEg1OOvbp0RTHkrvOmG2okjBZ/XspMz+9mPrH8dh74tT
	LHuc4DG7kr6axGAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789560582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D85vXBe2xfk1jvSWs9TcMey2V3KKLMoyz3bWz1rk7eI=;
	b=h4lTgrcS795S9e5ofKlTaEjGmbVI2CkNtSx/AtITpaUCyI/SCevJy38l6BjHP+1VGltIk+
	jchB4o4X0wR2jn8CsL137siGXmvL74GQax7VWBFq38mODg3zU02r8IVylbVQf9Dbvj3XiE
	C8N38rLTvs3SkbJUoOuuaGfp0V1OTrg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789560582;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D85vXBe2xfk1jvSWs9TcMey2V3KKLMoyz3bWz1rk7eI=;
	b=drprDADXBAHHVtDPk/j7Gyn+5Kqcv1TvhWJ7bBltu38WJ0A34FsbiLt/LsK3v+KTaI6AxQ
	V1ArPhoThqRmuDDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F11C11348F;
	Wed, 16 Sep 2026 12:09:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OVrVIQSHqmp0SAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 16 Sep 2026 12:09:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 81E26A13D5; Wed, 16 Sep 2026 14:02:35 +0200 (CEST)
Date: Wed, 16 Sep 2026 14:02:35 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hughd@google.com, 
	baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz, ziy@nvidia.com, 
	bfoster@redhat.com, joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com, 
	yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 1/3] mm/truncate: fix data loss when splitting
 straddling large folios fails
Message-ID: <xl2rtnntlxoxoozkddgrlkcsgukcngvvcwazm7gb7q5g32yxir@ef5ltcwueboh>
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-2-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916092450.654408-2-yi.zhang@huaweicloud.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: eo7xrw7d8ppkn3b7ozquj4m55fkcctsh
X-Rspamd-Queue-Id: A0B2120008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789560592-71364
X-HE-Meta: U2FsdGVkX19FgMcK65cejJBdBJd5KTeIsMQFeo7AyGm2R5ug5kNonOy+2bOKX5ClHe+GQ5hiS7mZ9P92xNVSdvAqLMZjbGJoJUf39ClKNYmLJI5wLBqgtukFNU5r+3Y/gQvWax8WChv7hj0v3LOGVzYEF5NKNwDQPnSVykMlciqWCUeTXMSQrjMcl654i28W7u0rkoJB6gYkK1rbn6C1brDezRg8IvVsbM/Ot/MlKGKxjTu2GCFvcT0Hq8JFJFUAD7n5hck2bNajrGguk4+j6LrBUvHqU0R8DGzrQ/GXZsq9PdJ/AvlWFciTNOHNdh9uDHffwLyuc7yQBYpXfEB+/dcBNr16TOhLlw9WWyQtTiCf+KgPk7150LdESw00wUEPITwwCdS0/0GE2pNZ+jF+xN2GpKTf16s3V5o7gxnw5FNGNFfrluh8F8tvA/Bf+kdidHi5Nus+tf3Fq6IM5dsCtGP83Pw7WZajpabvIkgugx/zE4MvgAB9ZJ9SFT69WOpqyJMnbM596EMRmxP9wEhwO6rLL6eoJ7tx04Ov1mUf+FjSafGQqXk42kbVyaIonnn5zaBnm22kvSo+Ej6H95NcMTHfrCRjPbl2LdLwJceilhG+unE/w8LZO1UdQHFk3HmuH2Ncxs7teD8Y4StK8jrHttWyMJtclxSColrVn4xTBHuEdW2D26y27rIXiyhqnpgUjP6HpXE/cVobACeuAgL1XpxVMHrKLHbiStGO5xo1pk7d5RenfqJD85DEybHbE1GluHxz4kP3loV60tHlnVmq9WCQ26J/+xeYOIJbCHD4XFMYMGyblX7nLOLmfiqHNhxIiLgZnlBmc6tyV/UKHR7Kd7cCjwjpDd3l55L69EI0FfTtmxgV1KgzUopcqycv4s6jhZh/K1HtxhGZHDDUh56GDwe045PnzxyxbV8bGxVdNy/Ij+vkiqHd42q3NIciy4sSrdfYRrOWfPUfJxiic+h
 nVRnh1RH
 HgN33M18ZSh+OiwGP4EHkL5ZIwaflWVLOdlG3o1VIXR31EpO01fyAVL1UMRY67TrV55dLaHqqNz+XDGosU+BbqiJAyvpdiVDpr9JrHYXh6CwfyuEX9+8ozvzxjelp2rVbPsJJ8mPH8DuJceXVOsI6xpJHLGq6l/twmgs9MEgsU9Hb47KXv9FA7uqjV6TLTnyoim4CVLB1z1e+K8jJ45RA6kmlDY4ru+ZECwyOvtOErwWVBOba2Aafd6If5l2vVE2kEL29t87FM+fTtzJqPWQn0QRrkaPFBlR+W1Zq3dtTyvQMimnGzBhq8//9Vy5860hPRiLgMHJnFjpi2ndid/jF+oMKmlKM8docRqZSV2wrg9Y0iBTZh2A9Ch9Wz4bN2kczOU8SykbTmz7ipmlc7jveOj3SldeRq5ETL7dR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 16-09-26 17:24:48, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> truncate_inode_partial_folio() splits a large folio so that the caller's
> truncate loop can drop the in-range sub-folios while keeping the
> out-of-range tail. The first split at the punch start edge is
> non-uniform, which leaves the sub-folio at the truncation end edge as
> large as possible, this means it may still straddle the range, holding
> both zeroed in-range and valid out-of-range data. The function then
> attempts a second split at offset + length to isolate that tail.
> 
> If the second split fails the straddling sub-folio stays merged. The
> function returned true unconditionally on all exit paths of the success
> block, telling the caller it was fully handled. The caller kept its
> default end and the truncate loop truncated every sub-folio below it,
> including the merged straddler, discarding the valid out-of-range tail.
> 
> For example, a 4-page order-2 folio punched from offset 0 to the middle
> of the last page:
> 
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()      # same_folio == true
>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>       folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>       2nd split of folio2 fails / cannot lock
>       return true                       # BUG: caller keeps default end
>     end = 3
>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
> 
> This became reachable after commit 7460b470a131 ("mm/truncate: use
> folio_split() in truncate operation") replaced the atomic split_folio()
> with folio_split(), whose non-uniform split can partially split a folio
> and leave the end edge merged.
> 
> It has gone unnoticed because a dirty large folio normally carries the
> filesystem's private data, for example buffer_head, so
> filemap_release_folio() -> iomap_release_folio() returns false on a
> dirty folio and folio_split() aborts with -EBUSY before any split,
> leaving the straddler safely unsplit. The bug is only reachable on paths
> that produce dirty large folios without filesystem private data, and it
> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
> attached.
> 
> Rework the contract so the caller is told the page range to discard:
> 
>   - Add pgoff_t *pstart and *pend out-parameters that receive the page
>     range fully covered by [lstart, lend] after any split (or none),
>     i.e. the pages wholly within the range and safe to discard.
> 
>   - Adjust the ordering of the validate check when splitting folio2.
>     folio2->index is only reliable after the reference count and lock
>     have been successfully acquired, since it may have been split
>     concurrently, or freed and recycled to an unrelated mapping. On any
>     failure to obtain a reliable end position, fall back to
>     folio->index, which is safe but leaves the sub-folios split off at
>     the offset edge in the page cache.
> 
>   - Rename the byte-range parameters start/end to lstart/lend to better
>     express their semantics.
> 
> Callers in truncate_inode_pages_range() and shmem_undo_range() pass
> &pstart for the folio at the start edge and &pend for the folio at the
> end edge, so the truncate loop drops exactly the fully covered pages and
> never touches a straddling folio that still holds valid out-of-range
> data.
> 
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

The changes mostly look good to me but I have some confusion around the
folio2 splitting below.

> @@ -259,32 +271,62 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		 * for shmem truncate
>  		 */
>  		struct folio *folio2;
> +		pgoff_t end, aligned_end = (pos + offset + length) >>
> +					   PAGE_SHIFT;
>  
> -		if (offset + length == size)
> -			goto no_split;
> +		if (pstart)
> +			*pstart = round_up(pos + offset, PAGE_SIZE) >>
> +				  PAGE_SHIFT;
> +
> +		if (offset + length == size) {
> +			end = aligned_end;
> +			goto out;
> +		}
>  
>  		split_at2 = folio_page(folio,
>  				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
>  		folio2 = page_folio(split_at2);
>  
> +		/*
> +		 * folio2 may become stale due to a concurrent split or
> +		 * freeing, so validate it before and after taking its lock.
> +		 * If it fails, we can't get an accurate end position and fall
> +		 * back to folio->index, which may leave sub-folios split off
> +		 * at the offset edge in the page cache this round.
> +		 */
> +		end = folio->index;
>  		if (!folio_try_get(folio2))
> -			goto no_split;
> -
> -		if (!folio_test_large(folio2))
>  			goto out;
>  
> +		if (folio2->mapping != folio->mapping ||
> +		    !folio_test_large(folio2))
> +			goto out_put;
> +
>  		if (!folio_trylock(folio2))
> -			goto out;
> +			goto out_put;
>  
> -		/* make sure folio2 is large and does not change its mapping */
> -		if (folio_test_large(folio2) &&
> -		    folio2->mapping == folio->mapping)
> -			folio_split_or_unmap(folio2, split_at2, min_order);
> +		if (page_folio(split_at2) != folio2) {
> +			folio_unlock(folio2);
> +			goto out_put;
> +		}
> +		if (!folio_test_large(folio2)) {
> +			end = aligned_end;
> +			folio_unlock(folio2);
> +			goto out_put;
> +		}

So I always found this folio2 lookup and revalidation somewhat suspicious
and now that we're digging into it I'll ask: As you note in the changelog,
by the time we compute split_at2 the page can be already freed and reused
because it was split off from the original 'folio'. It can be for example a
slab page or anything else. So is it guaranteed that page_folio() actually
returns something sensible? What guarantees we properly detect the "reuse
for something else" case in all possible cases for which the page can be
reused? I understand this is mostly a preexisting issue so maybe these
questions are more for MM guys than you...

So for me as an filesystem guy I'd appreciate some comment in this code
explaining why grabbing folio2 this way is actually safe. The really safe
way of getting to folio2 would be to use
  __filemap_get_folio(mapping, (offset+length) >> PAGE_SHIFT, FGP_LOCK, 0)
but I suppose we don't use the mapping lookup as it is more expensive?

								Honza

> +
> +		/* Split failed: back off to the head of the straddler */
> +		if (folio_split_or_unmap(folio2, split_at2, min_order))
> +			end = folio2->index;
> +		else
> +			end = aligned_end;
>  
>  		folio_unlock(folio2);
> -out:
> +out_put:
>  		folio_put(folio2);
> -no_split:
> +out:
> +		if (pend)
> +			*pend = end;
>  		return true;
>  	}
>  	if (folio_test_dirty(folio))
> @@ -413,11 +455,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
>  	if (!IS_ERR(folio)) {
>  		same_folio = lend < folio_next_pos(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
> -			start = folio_next_index(folio);
> -			if (same_folio)
> -				end = folio->index;
> -		}
> +		truncate_inode_partial_folio(folio, lstart, lend, &start,
> +					     same_folio ? &end : NULL);
>  		folio_unlock(folio);
>  		folio_put(folio);
>  		folio = NULL;
> @@ -427,8 +466,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  		folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
>  						FGP_LOCK, 0);
>  		if (!IS_ERR(folio)) {
> -			if (!truncate_inode_partial_folio(folio, lstart, lend))
> -				end = folio->index;
> +			truncate_inode_partial_folio(folio, lstart, lend,
> +						     NULL, &end);
>  			folio_unlock(folio);
>  			folio_put(folio);
>  		}
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

