Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB8B5E87850
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A0B6B009E; Tue,  3 Feb 2026 12:40:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B8BE6B00B0; Tue,  3 Feb 2026 12:40:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1645A6B00B5; Tue,  3 Feb 2026 12:40:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF1306B009E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:40:35 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3219D5118
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:40:35 +0000 (UTC)
X-FDA: 84403860030.22.8710FA4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2B0874000A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:40:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YU1ha99e;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770140433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmSl7/1tMINHvaZwWji7tBNR9y3eOnNMtJc0andbC/g=;
	b=m/D55cMYnCq4ywGGQRXHg1WTeclA6Va9iADq3QHNQk+RKGC1a9KpLm4xLJjzPfZnbA0God
	/fbtmkDNKu9ToeUvsr0dxlcMHyiX2VqBbGcwDJbHrVPICDn/zkPwfnEQgdDlBU0az4XnSc
	/a9o4b5tosuXl69UQB302ZzhK7nQX/k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770140433; a=rsa-sha256;
	cv=none;
	b=KKNbD5eBQpN25xjR4Uf2PQM/0X/2P6ZNXbl9GA7Pk2L7abnFC5x2e5LYTWryIlOlldXkyv
	QnzAAIo8RjUxgfHtaKusS9tK0ofoySNkQERhjOvXKBMR3eq2SQj+nFydD14jmGKWVLBuPj
	jWx+W8BCC/ZmI8Q+VS+T1DOUtZGURGE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YU1ha99e;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770140432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nmSl7/1tMINHvaZwWji7tBNR9y3eOnNMtJc0andbC/g=;
	b=YU1ha99eXA0xt0f1i3tOWVLWRxM5Nvf74Jdp5xGyfP7i8iyAuVFZPv4jmP5aBC7+ga2h6I
	Oe+H59C2/NKn6M5z+NAKR7fVDj5CtM0G2wqL3qD7FfLGfMXeIWMqQrtmB4/CuzIT2gVPke
	iUGccXqW6b9OMMF3SZzLpRN3FnJISfU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-PRZXNU0aPACRIVuUtEXDGQ-1; Tue, 03 Feb 2026 12:40:31 -0500
X-MC-Unique: PRZXNU0aPACRIVuUtEXDGQ-1
X-Mimecast-MFC-AGG-ID: PRZXNU0aPACRIVuUtEXDGQ_1770140431
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c1cffa1f2dso12124085a.1
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 09:40:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770140431; x=1770745231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nmSl7/1tMINHvaZwWji7tBNR9y3eOnNMtJc0andbC/g=;
        b=c6hKfnfVcCITU2B4g7eM3KG26siqzxsHaOvyHq1UB5rBPkx1UjPLJwHLfrkLlYv5Gh
         MNNd2ztmJdlPGJ959JA55Sj6j1UogQjtpsYL2nnTLccF6frLVsTa6y/gR5LaMZAfjCeB
         0MU8WWRjVwvMZ4kixtfxK+R/xdBdQlQHdCb7a1H+1gpdteF5zGpgAVtDyUQNmelCgM8M
         kXTrbNPfbmXR4U+Vjxlia9jgwRT6k3Lu0L99rg0mC48Ov7OiqENZ3tZez2cO4qpYD/1I
         52RaaVeI5bddLMc3EsrrH+9PyrRn/oPe8o8FtnY/LgI2n5bDYEbOOWn5SquaOdNQgEE/
         1gAw==
X-Gm-Message-State: AOJu0YwhUXaGow71GPefyr3gYoBX03LZH8Xf7b/tZWI2Q3Quodkfk4Wd
	73+/gNePkK348PvyLHlTwBhCqpDOYTbTed6g8kTTxkca0iQQMoCdF9wbKBxU+TD7a3IFFqEu6ci
	o8N/QylnbbZCDgb8paD6TL/vlFCVhY6toT4KCaoSx8dzMXyj9TR32
X-Gm-Gg: AZuq6aKkc82kBtdUpCXn30iZRPrIUoE1/qKX2O3n5aIIcMAy0950g9QC4am2gZaT8Kx
	toSGHww2MTMgiE6iyEWiijyKEOw6NNUumQJ0A6idtQw9xHL0hZOH8kTlUiS9HY7eSzFS72ZebEI
	chyjzUIDid+odMo55iRE/2Glg5BqJlOlESQnZq9Fa/hWWh0kScr2pKAHv3Swj8tbfsYlZlkaXIB
	ZRAcBpyTSUQl6W3tSYrX2+aiRiD66fQTE7CE9GTWP2vzClzpIBJ2MDmW8o2xS4JSp0oIX1cYZxk
	dnyhYbKD6q8SPTNheagQVD7MEyhxJQJHsDHz14mLlS5lEZMYurc19OdohhpNy9elQ4gMhUdgr3o
	TUnE=
X-Received: by 2002:a05:620a:2910:b0:8c5:3045:854f with SMTP id af79cd13be357-8ca204ca94dmr428086385a.30.1770140430571;
        Tue, 03 Feb 2026 09:40:30 -0800 (PST)
X-Received: by 2002:a05:620a:2910:b0:8c5:3045:854f with SMTP id af79cd13be357-8ca204ca94dmr428079185a.30.1770140429666;
        Tue, 03 Feb 2026 09:40:29 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ca2fd56420sm16357985a.54.2026.02.03.09.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 09:40:29 -0800 (PST)
Date: Tue, 3 Feb 2026 12:40:26 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 10/17] shmem, userfaultfd: implement shmem uffd
 operations using vm_uffd_ops
Message-ID: <aYIzCuh8cjd09zrP@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-11-rppt@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260127192936.1250096-11-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _SDS7f4BP3Lgo7u4b4B_zYy7DetTkCWBIhCWNnkQqY8_1770140431
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 2B0874000A
X-Stat-Signature: 5hk6zegnq3z5dwa5rrb4nseuaqdbr46r
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770140432-359178
X-HE-Meta: U2FsdGVkX19sqIf8ThZAmBL04iXgsSemXuYSrk7YY+yQ3Yf2wjIiagZA69Xv8eqnAZP9PzAFgI2wW7uvldhp5CeIW1QBNfw/Toid/6SpanEDD7iq/tAKRR/MU7VkcJKXQ4b/kYYZl9eMpCkUnald8n5+Z/a0cRteyK79pg2jGjPSm+/QbiQqGGwe+6S6eWgAVOy4T5PPdWCjucCkqVj7ZsHx/a/OCdxXNOolSOjljxKGX+uHXbzii11tMlQlv6xbej/dRWb5fVs0dZZexUEXDkdh5mFi2+s0tQbryFxe4gfD7ZOjSzI8JD13zqJcu7LueHi/L2mKS7C8epxGqPzRrYuZ+Vs59b1WX7AHgFJxdiCMAAQx2qwi8Mu9zYqVQSWT/38+0OnAIHZhx+vD3e2f8nyzLCyY13gHKBXaIDqofG35asjjGxuiJr6JsCqC2WNOy4yMrwGbn21JJqWQl+1subu3TW/PPTYjMriIs9c3FKl0Ys8pHIW3mciP0sAu3x+EnLb+vBf0b7gVrlUKP7Jx+PUY/jOPjj2lgWNJ7N+VfdFyUi3c5scnv8YP2HKYJch4tke0U6Dp0yrMshciNhJXTkISQRmiD/rj61Ep0SOYGibHxfgMCAOyoaxBeNwAEFJLVJplK9P8Z8t//py9UmyjXmYfxWDpgDX7OZWlCNJYpdTKDM50TY2vp+Q2YyDIVx6/IVp/rjdbc6hkTRbvM/WUAqtYQqyIg/13qaLnR2Ru2Deb/UPEQw/PFXvIfs6YmEzX/ziIE7UGjD2QUSe3IpQQdmi+h6TvbVsWRT8/NRBAw74BBLF0P2iijttKQAyKvTNzaSmfbuIf8xsygO1VXqIdq/EFOnfhmjSmpmkMYdfXHzyyYkNkxcyNCITsjjIkrd+AnKmqmfveO3J8cmCsg3aJxEmpjTvu1ckvi7pAIt197Q4gJOm49CLk/DHdCxQAaOrKkjhgHtgVh5F4jjnJsnl
 Xrh5prKz
 vRU4K2Y9QC9wuwbigJOtJzRSUHEv1fWAGPr4BVVISdz52XvMQ4OzWnPHvUiXaD9qZ2Lfkh2YubxokkGmDLWr2y5SRrwoFb4EvWvR1Q7gmwJutQa9DA57aX1q97dZN9ijbUtZqVuRce1jdm7CaHr1WYg4mtp5cqv06ZRz8E0rPXfFMqcNQlYDDTeAeDegi1PMRvm5CkQminFFGYAL9+JSaCdconIMw1+9lq1x5iw4NHva5o813spZfZE6/xPCJ+OdNMTrkCC8+wwAnmw8VH350CMAhkG2gZ/M3QRBJiMQ2Edbx/LkKmS/XSuBU7wpHVsUvTNPxRJAbBYN22v7W8WRD9zSbHO71tLREsdC8xVYiEVuM2dGdhdkewY9H4B+LMXyerUbqcjdsnK/ZoFKceKFTB/aAvSuSrdSVU9xXA6PK35E34L3JML85t+Ftl+zeHqkO0O8OlWovBVaa59U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 09:29:29PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Add filemap_add() and filemap_remove() methods to vm_uffd_ops and use
> them in __mfill_atomic_pte() to add shmem folios to page cache and
> remove them in case of error.
> 
> Implement these methods in shmem along with vm_uffd_ops->alloc_folio()
> and drop shmem_mfill_atomic_pte().
> 
> Since userfaultfd now does not reference any functions from shmem, drop
> include if linux/shmem_fs.h from mm/userfaultfd.c
> 
> mfill_atomic_install_pte() is not used anywhere outside of
> mm/userfaultfd, make it static.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

This patch looks like a real nice cleanup on its own, thanks Mike!

I guess I never tried to read into shmem accountings, now after I read some
of the codes I don't see any issue with your change.  We can also wait for
some shmem developers double check those.  Comments inline below on
something I spot.

> 
> fixup
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

[unexpected lines can be removed here]

> ---
>  include/linux/shmem_fs.h      |  14 ----
>  include/linux/userfaultfd_k.h |  20 +++--
>  mm/shmem.c                    | 148 ++++++++++++----------------------
>  mm/userfaultfd.c              |  79 +++++++++---------
>  4 files changed, 106 insertions(+), 155 deletions(-)
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index e2069b3179c4..754f17e5b53c 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -223,20 +223,6 @@ static inline pgoff_t shmem_fallocend(struct inode *inode, pgoff_t eof)
>  
>  extern bool shmem_charge(struct inode *inode, long pages);
>  
> -#ifdef CONFIG_USERFAULTFD
> -#ifdef CONFIG_SHMEM
> -extern int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
> -				  struct vm_area_struct *dst_vma,
> -				  unsigned long dst_addr,
> -				  unsigned long src_addr,
> -				  uffd_flags_t flags,
> -				  struct folio **foliop);
> -#else /* !CONFIG_SHMEM */
> -#define shmem_mfill_atomic_pte(dst_pmd, dst_vma, dst_addr, \
> -			       src_addr, flags, foliop) ({ BUG(); 0; })
> -#endif /* CONFIG_SHMEM */
> -#endif /* CONFIG_USERFAULTFD */
> -
>  /*
>   * Used space is stored as unsigned 64-bit value in bytes but
>   * quota core supports only signed 64-bit values so use that
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index 4d8b879eed91..75d5b09f2560 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -97,6 +97,21 @@ struct vm_uffd_ops {
>  	 */
>  	struct folio *(*alloc_folio)(struct vm_area_struct *vma,
>  				     unsigned long addr);
> +	/*
> +	 * Called during resolution of UFFDIO_COPY request.
> +	 * Should lock the folio and add it to VMA's page cache.
> +	 * Returns 0 on success, error code on failre.

failure

> +	 */
> +	int (*filemap_add)(struct folio *folio, struct vm_area_struct *vma,
> +			 unsigned long addr);
> +	/*
> +	 * Called during resolution of UFFDIO_COPY request on the error
> +	 * handling path.
> +	 * Should revert the operation of ->filemap_add().
> +	 * The folio should be unlocked, but the reference to it should not be
> +	 * dropped.

Might be slightly misleading to explicitly mention this?  As page cache
also holds references and IIUC they need to be dropped there.  But I get
your point, on keeping the last refcount due to allocation.

IMHO the "should revert the operation of ->filemap_add()" is good enough
and accurately describes it.

> +	 */
> +	void (*filemap_remove)(struct folio *folio, struct vm_area_struct *vma);
>  };
>  
>  /* A combined operation mode + behavior flags. */
> @@ -130,11 +145,6 @@ static inline uffd_flags_t uffd_flags_set_mode(uffd_flags_t flags, enum mfill_at
>  /* Flags controlling behavior. These behavior changes are mode-independent. */
>  #define MFILL_ATOMIC_WP MFILL_ATOMIC_FLAG(0)
>  
> -extern int mfill_atomic_install_pte(pmd_t *dst_pmd,
> -				    struct vm_area_struct *dst_vma,
> -				    unsigned long dst_addr, struct page *page,
> -				    bool newly_allocated, uffd_flags_t flags);
> -
>  extern ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  				 unsigned long src_start, unsigned long len,
>  				 uffd_flags_t flags);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 87cd8d2fdb97..6f0485f76cb8 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3169,118 +3169,73 @@ static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
>  #endif /* CONFIG_TMPFS_QUOTA */
>  
>  #ifdef CONFIG_USERFAULTFD
> -int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
> -			   struct vm_area_struct *dst_vma,
> -			   unsigned long dst_addr,
> -			   unsigned long src_addr,
> -			   uffd_flags_t flags,
> -			   struct folio **foliop)
> -{
> -	struct inode *inode = file_inode(dst_vma->vm_file);
> -	struct shmem_inode_info *info = SHMEM_I(inode);
> +static struct folio *shmem_mfill_folio_alloc(struct vm_area_struct *vma,
> +					     unsigned long addr)
> +{
> +	struct inode *inode = file_inode(vma->vm_file);
>  	struct address_space *mapping = inode->i_mapping;
> +	struct shmem_inode_info *info = SHMEM_I(inode);
> +	pgoff_t pgoff = linear_page_index(vma, addr);
>  	gfp_t gfp = mapping_gfp_mask(mapping);
> -	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
> -	void *page_kaddr;
>  	struct folio *folio;
> -	int ret;
> -	pgoff_t max_off;
> -
> -	if (shmem_inode_acct_blocks(inode, 1)) {
> -		/*
> -		 * We may have got a page, returned -ENOENT triggering a retry,
> -		 * and now we find ourselves with -ENOMEM. Release the page, to
> -		 * avoid a BUG_ON in our caller.
> -		 */
> -		if (unlikely(*foliop)) {
> -			folio_put(*foliop);
> -			*foliop = NULL;
> -		}
> -		return -ENOMEM;
> -	}
>  
> -	if (!*foliop) {
> -		ret = -ENOMEM;
> -		folio = shmem_alloc_folio(gfp, 0, info, pgoff);
> -		if (!folio)
> -			goto out_unacct_blocks;
> +	if (unlikely(pgoff >= DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE)))
> +		return NULL;
>  
> -		if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY)) {
> -			page_kaddr = kmap_local_folio(folio, 0);
> -			/*
> -			 * The read mmap_lock is held here.  Despite the
> -			 * mmap_lock being read recursive a deadlock is still
> -			 * possible if a writer has taken a lock.  For example:
> -			 *
> -			 * process A thread 1 takes read lock on own mmap_lock
> -			 * process A thread 2 calls mmap, blocks taking write lock
> -			 * process B thread 1 takes page fault, read lock on own mmap lock
> -			 * process B thread 2 calls mmap, blocks taking write lock
> -			 * process A thread 1 blocks taking read lock on process B
> -			 * process B thread 1 blocks taking read lock on process A
> -			 *
> -			 * Disable page faults to prevent potential deadlock
> -			 * and retry the copy outside the mmap_lock.
> -			 */
> -			pagefault_disable();
> -			ret = copy_from_user(page_kaddr,
> -					     (const void __user *)src_addr,
> -					     PAGE_SIZE);
> -			pagefault_enable();
> -			kunmap_local(page_kaddr);
> -
> -			/* fallback to copy_from_user outside mmap_lock */
> -			if (unlikely(ret)) {
> -				*foliop = folio;
> -				ret = -ENOENT;
> -				/* don't free the page */
> -				goto out_unacct_blocks;
> -			}
> +	folio = shmem_alloc_folio(gfp, 0, info, pgoff);
> +	if (!folio)
> +		return NULL;
>  
> -			flush_dcache_folio(folio);
> -		} else {		/* ZEROPAGE */
> -			clear_user_highpage(&folio->page, dst_addr);
> -		}
> -	} else {
> -		folio = *foliop;
> -		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
> -		*foliop = NULL;
> +	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL)) {
> +		folio_put(folio);
> +		return NULL;
>  	}
>  
> -	VM_BUG_ON(folio_test_locked(folio));
> -	VM_BUG_ON(folio_test_swapbacked(folio));
> +	return folio;
> +}
> +
> +static int shmem_mfill_filemap_add(struct folio *folio,
> +				   struct vm_area_struct *vma,
> +				   unsigned long addr)
> +{
> +	struct inode *inode = file_inode(vma->vm_file);
> +	struct address_space *mapping = inode->i_mapping;
> +	pgoff_t pgoff = linear_page_index(vma, addr);
> +	gfp_t gfp = mapping_gfp_mask(mapping);
> +	int err;
> +
>  	__folio_set_locked(folio);
>  	__folio_set_swapbacked(folio);
> -	__folio_mark_uptodate(folio);
> -
> -	ret = -EFAULT;
> -	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
> -	if (unlikely(pgoff >= max_off))
> -		goto out_release;
>  
> -	ret = mem_cgroup_charge(folio, dst_vma->vm_mm, gfp);
> -	if (ret)
> -		goto out_release;
> -	ret = shmem_add_to_page_cache(folio, mapping, pgoff, NULL, gfp);
> -	if (ret)
> -		goto out_release;
> +	err = shmem_add_to_page_cache(folio, mapping, pgoff, NULL, gfp);
> +	if (err)
> +		goto err_unlock;
>  
> -	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> -				       &folio->page, true, flags);
> -	if (ret)
> -		goto out_delete_from_cache;
> +	if (shmem_inode_acct_blocks(inode, 1)) {

We used to do this early before allocation, IOW, I think we still have an
option to leave this to alloc_folio() hook.  However I don't see an issue
either keeping it in filemap_add(). Maybe this movement should better be
spelled out in the commit message anyway on how this decision is made.

IIUC it's indeed safe we move this acct_blocks() here, I even see Hugh
mentioned such in an older commit 3022fd7af96, but Hugh left uffd alone at
that time:

    Userfaultfd is a foreign country: they do things differently there, and
    for good reason - to avoid mmap_lock deadlock.  Leave ordering in
    shmem_mfill_atomic_pte() untouched for now, but I would rather like to
    mesh it better with shmem_get_folio_gfp() in the future.

I'm not sure if that's also what you wanted to do - to make userfaultfd
code work similarly like what shmem_alloc_and_add_folio() does right now.
Maybe you want to mention that too somewhere in the commit log when posting
a formal patch.

One thing not directly relevant is, shmem_alloc_and_add_folio() also does
proper recalc of inode allocation info when acct_blocks() fails here.  But
if that's a problem, that's pre-existing for userfaultfd, so IIUC we can
also leave it alone until someone (maybe quota user) complains about shmem
allocation failures on UFFDIO_COPY.. It's just that it looks similar
problem here in userfaultfd path.

> +		err = -ENOMEM;
> +		goto err_delete_from_cache;
> +	}
>  
> +	folio_add_lru(folio);

This change is pretty separate from the work, but looks correct to me: IIUC
we moved the lru add earlier now, and it should be safe as long as we're
holding folio lock all through the process, and folio_put() (ultimately,
__page_cache_release()) will always properly undo the lru change.  Please
help double check if my understanding is correct.

>  	shmem_recalc_inode(inode, 1, 0);
> -	folio_unlock(folio);
> +
>  	return 0;
> -out_delete_from_cache:
> +
> +err_delete_from_cache:
>  	filemap_remove_folio(folio);
> -out_release:
> +err_unlock:
> +	folio_unlock(folio);
> +	return err;
> +}
> +
> +static void shmem_mfill_filemap_remove(struct folio *folio,
> +				       struct vm_area_struct *vma)
> +{
> +	struct inode *inode = file_inode(vma->vm_file);
> +
> +	filemap_remove_folio(folio);
> +	shmem_recalc_inode(inode, 0, 0);
>  	folio_unlock(folio);
> -	folio_put(folio);
> -out_unacct_blocks:
> -	shmem_inode_unacct_blocks(inode, 1);

This looks wrong, or maybe I miss somewhere we did the unacct_blocks()?

> -	return ret;
>  }
>  #endif /* CONFIG_USERFAULTFD */
>  
> @@ -5317,6 +5272,9 @@ static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
>  static const struct vm_uffd_ops shmem_uffd_ops = {
>  	.can_userfault		= shmem_can_userfault,
>  	.get_folio_noalloc	= shmem_get_folio_noalloc,
> +	.alloc_folio		= shmem_mfill_folio_alloc,
> +	.filemap_add		= shmem_mfill_filemap_add,
> +	.filemap_remove		= shmem_mfill_filemap_remove,
>  };
>  #endif
>  
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index b3c12630769c..54aa195237ba 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -14,7 +14,6 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/hugetlb.h>
> -#include <linux/shmem_fs.h>
>  #include <asm/tlbflush.h>
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -337,10 +336,10 @@ static bool mfill_file_over_size(struct vm_area_struct *dst_vma,
>   * This function handles both MCOPY_ATOMIC_NORMAL and _CONTINUE for both shmem
>   * and anon, and for both shared and private VMAs.
>   */
> -int mfill_atomic_install_pte(pmd_t *dst_pmd,
> -			     struct vm_area_struct *dst_vma,
> -			     unsigned long dst_addr, struct page *page,
> -			     bool newly_allocated, uffd_flags_t flags)
> +static int mfill_atomic_install_pte(pmd_t *dst_pmd,
> +				    struct vm_area_struct *dst_vma,
> +				    unsigned long dst_addr, struct page *page,
> +				    uffd_flags_t flags)
>  {
>  	int ret;
>  	struct mm_struct *dst_mm = dst_vma->vm_mm;
> @@ -384,9 +383,6 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
>  		goto out_unlock;
>  
>  	if (page_in_cache) {
> -		/* Usually, cache pages are already added to LRU */
> -		if (newly_allocated)
> -			folio_add_lru(folio);
>  		folio_add_file_rmap_pte(folio, page, dst_vma);
>  	} else {
>  		folio_add_new_anon_rmap(folio, dst_vma, dst_addr, RMAP_EXCLUSIVE);
> @@ -401,6 +397,9 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
>  
>  	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
>  
> +	if (page_in_cache)
> +		folio_unlock(folio);

Nitpick: another small change that looks correct, but IMHO would be nice to
either make it a small separate patch, or mention in the commit message.

> +
>  	/* No need to invalidate - it was non-present before */
>  	update_mmu_cache(dst_vma, dst_addr, dst_pte);
>  	ret = 0;
> @@ -507,13 +506,22 @@ static int __mfill_atomic_pte(struct mfill_state *state,
>  	 */
>  	__folio_mark_uptodate(folio);
>  
> +	if (ops->filemap_add) {
> +		ret = ops->filemap_add(folio, state->vma, state->dst_addr);
> +		if (ret)
> +			goto err_folio_put;
> +	}
> +
>  	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
> -				       &folio->page, true, flags);
> +				       &folio->page, flags);
>  	if (ret)
> -		goto err_folio_put;
> +		goto err_filemap_remove;
>  
>  	return 0;
>  
> +err_filemap_remove:
> +	if (ops->filemap_remove)
> +		ops->filemap_remove(folio, state->vma);
>  err_folio_put:
>  	folio_put(folio);
>  	/* Don't return -ENOENT so that our caller won't retry */
> @@ -526,6 +534,18 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
>  {
>  	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
>  
> +	/*
> +	 * The normal page fault path for a MAP_PRIVATE mapping in a
> +	 * file-backed VMA will invoke the fault, fill the hole in the file and
> +	 * COW it right away. The result generates plain anonymous memory.
> +	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
> +	 * generate anonymous memory directly without actually filling the
> +	 * hole. For the MAP_PRIVATE case the robustness check only happens in
> +	 * the pagetable (to verify it's still none) and not in the page cache.
> +	 */
> +	if (!(state->vma->vm_flags & VM_SHARED))
> +		ops = &anon_uffd_ops;
> +
>  	return __mfill_atomic_pte(state, ops);
>  }
>  
> @@ -545,7 +565,8 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
>  	spinlock_t *ptl;
>  	int ret;
>  
> -	if (mm_forbids_zeropage(dst_vma->vm_mm))
> +	if (mm_forbids_zeropage(dst_vma->vm_mm) ||
> +	    (dst_vma->vm_flags & VM_SHARED))
>  		return mfill_atomic_pte_zeroed_folio(state);
>  
>  	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
> @@ -600,11 +621,10 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
>  	}
>  
>  	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> -				       page, false, flags);
> +				       page, flags);
>  	if (ret)
>  		goto out_release;
>  
> -	folio_unlock(folio);
>  	return 0;
>  
>  out_release:
> @@ -827,41 +847,18 @@ extern ssize_t mfill_atomic_hugetlb(struct userfaultfd_ctx *ctx,
>  
>  static __always_inline ssize_t mfill_atomic_pte(struct mfill_state *state)
>  {
> -	struct vm_area_struct *dst_vma = state->vma;
> -	unsigned long src_addr = state->src_addr;
> -	unsigned long dst_addr = state->dst_addr;
> -	struct folio **foliop = &state->folio;
>  	uffd_flags_t flags = state->flags;
> -	pmd_t *dst_pmd = state->pmd;
> -	ssize_t err;
>  
>  	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
>  		return mfill_atomic_pte_continue(state);
>  	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON))
>  		return mfill_atomic_pte_poison(state);
> +	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
> +		return mfill_atomic_pte_copy(state);
> +	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE))
> +		return mfill_atomic_pte_zeropage(state);
>  
> -	/*
> -	 * The normal page fault path for a shmem will invoke the
> -	 * fault, fill the hole in the file and COW it right away. The
> -	 * result generates plain anonymous memory. So when we are
> -	 * asked to fill an hole in a MAP_PRIVATE shmem mapping, we'll
> -	 * generate anonymous memory directly without actually filling
> -	 * the hole. For the MAP_PRIVATE case the robustness check
> -	 * only happens in the pagetable (to verify it's still none)
> -	 * and not in the radix tree.
> -	 */
> -	if (!(dst_vma->vm_flags & VM_SHARED)) {
> -		if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
> -			err = mfill_atomic_pte_copy(state);
> -		else
> -			err = mfill_atomic_pte_zeropage(state);
> -	} else {
> -		err = shmem_mfill_atomic_pte(dst_pmd, dst_vma,
> -					     dst_addr, src_addr,
> -					     flags, foliop);
> -	}

It's great to merge these otherwise.

Thanks!

> -
> -	return err;
> +	return -EOPNOTSUPP;
>  }
>  
>  static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> -- 
> 2.51.0
> 

-- 
Peter Xu


