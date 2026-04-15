Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 139ACFA0C43
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7546B6B0095; Wed, 15 Apr 2026 04:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C256B0096; Wed, 15 Apr 2026 04:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641B36B0098; Wed, 15 Apr 2026 04:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 543386B0095
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:01:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1229814039F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:01:57 +0000 (UTC)
X-FDA: 84660046674.07.2B483E4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id C9FAF4000E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:01:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CLcWqVcJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6U64RHXM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1y+e3Gr+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CopcsibF;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776240115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=akN5Uu+otL7jpkoKju+WPDV2S3IuEX0eNSjfjFCNvqk=;
	b=P6rYtPSOBD7JTGqdPSb7s2IfXGZfGnE35wHbshwpaskCLPhu3UsP58Rr3iQ04xjrwIKUlx
	U6G4OiLY0nxhArQcpNE53BOSl3uUQ/PaqEtsmq3u/W0jeFAF1mjJN4qiEZ5huB1eb9AV9V
	4iXA+J6tOjE+QUhSEFjlDQ9+s70ngFE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776240115; a=rsa-sha256;
	cv=none;
	b=AKk6S0vDX9f+C80t6PrxhrmRC6FOCXK+VlvRQk05978ZaPNCYcyzzKkmPplsRLwASLmi7v
	UUgbCAM1w2lzcr/eS+ZpzoTmhiY4GSLfmtK6LEVzR65vWrhtcZXIbFrySLunej5yylPp0m
	o+jOjaye9V8RqY0e9gdKmBBmYzDdCmo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CLcWqVcJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6U64RHXM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1y+e3Gr+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CopcsibF;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 364BB5BE0B;
	Wed, 15 Apr 2026 08:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776240112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=akN5Uu+otL7jpkoKju+WPDV2S3IuEX0eNSjfjFCNvqk=;
	b=CLcWqVcJ8h9lG3TjkVCHKEYzyv9XYd/dQ0OaXz4yOxNEWSJ3ZMQTrEv1X5jIFjpe3CIuX1
	BMXBopE3IVEEEmEcEPlB+K2wDqW6LIgpYcMul+rWBS3vfP938rPqBTFo7RXwyxmfJUE5w5
	cMiqD6f5N2kuo5k2Io5ytzH1W6f/ukI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776240112;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=akN5Uu+otL7jpkoKju+WPDV2S3IuEX0eNSjfjFCNvqk=;
	b=6U64RHXM9iglHLh//cFd9OAT3tpP9SDjIt4AxM58I7ObJhrZxRMyTFsIC9iJ0TQ+EGDQpu
	7KD/oV6FADbMiOBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776240108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=akN5Uu+otL7jpkoKju+WPDV2S3IuEX0eNSjfjFCNvqk=;
	b=1y+e3Gr+sGjZq97lNRz7Y0mbkFWB3vGraS5HKPjSq0lHW+ALFBIBtg/H3tl9bDxJT31vTl
	fBscObtzWrgpZFIyGMw6VD8r449R8kfE9UWMl2rCemAjtXyAGyVNsfSM+xgmT+m6rmW1NN
	3lvkIJTqJvuhTbstVpYAczEAiO0JsBM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776240108;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=akN5Uu+otL7jpkoKju+WPDV2S3IuEX0eNSjfjFCNvqk=;
	b=CopcsibFGDiM272ncR2T6HKKzD2nZIpxLAuNWpkuLXkP+XUkvIupOzAdLqLfaGeyQd867B
	hEZMPAZRAxigx5Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 733B04B8DB;
	Wed, 15 Apr 2026 08:01:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9w0HGutF32lzIAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 15 Apr 2026 08:01:47 +0000
Date: Wed, 15 Apr 2026 10:01:41 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
	hughd@google.com, baolin.wang@linux.alibaba.com, peterx@redhat.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] hugetlb: pass hugetlb reservation ranges in
 base-page indices
Message-ID: <ad9F5duupm8Rn-Yw@localhost.localdomain>
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-7-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409234158.837786-7-jane.chu@oracle.com>
X-Rspamd-Queue-Id: C9FAF4000E
X-Stat-Signature: qw1i6m8qkqdgtr9qm8q8tmbiy86g3y8j
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776240114-90616
X-HE-Meta: U2FsdGVkX1/4UPi1iDzFl1OTeyOdIw171wvg17Vrcy/+ZFlHaZaOuopC+9Y/lT+yDU6Gmiapqz6+OTrUOF6tQkWK1oj7LoOf3HZpTF/pInlxIjVBGSeyNmDlg6uGfV70zztn8lxetRVlVqZ6Vccgr7vhPAk7Pj3UXtLykJNWn1nt6QVrupWlJeSdHD0Gi7bi7BI6Hf57vxXdgox97bIcPa6rUdy+ErQETbnliPDqstjFkewL4FRmarbiwKw4DDA0gwwAC3kz6esbMhOsgN7lEeu4McU8uU5nvVbpJeKBEcs3t27++0ptHKpqD3fWrHPwkuwytFWTd8OlrujxIrNNWYJmF93CGEiLR834agzTSNgAoawC0dmclLIUzQxrQpCM5EtP8Kk5K8FmMsm+XPdeS9Q2mJ47qqV5S77OW6hOTwn5PKOCkulBrVs5ydlgOM7LgscsZXH0mApuOiNXa+aDTgTLphr16/fqWnvar4uzjn3kg7VCTM3ihB/CXCowG4oVUFhkJWlNCPIpF57aJq5xMoTPBVbFw7mW1Ek7+q11VoZM/3s0i8aq6Oxck6G/u+ibOnjPGoKvBxYuOtnsl6HsT10OtwufQ6Ki34fruPUUEgaPmULgNVgdkdqv7patd9khuYJDTBIjRyHrayhLQXa5/aJhRa2OJkUEP6E70/8S6QmlB3H9y2lKhBBA9cDDQFOaLZhcasNP6IhagElOZunTROJ/8ISNeJ+QJO8N57cX4ORI97pYwt0nCy7y+7Fk17K/yV1YX0BnMWGAuq6JVefI95kBeFTOGYp8KXJkLREallEcuZIvcn/1hH1drIEbnDga04jf8SU63z8lcT30yHZkXkGx4JehJQWrwSpCp3rixbNWdQIPdoaVoFNuwQLxyQYZilmtb2Y5eLcO+9NNlb0jzglz1Wmofh29lj9tY4oGxzgX70vEfpaQZdqdgO+dk/7ylEPBIV9uf7cG/UT7Z8B
 izoRDgrq
 Q06fwzroAyiR8QHLab2GONk0jRZasJlN4ZjCNMV9yOtJdsaDtClESF9N2L0ncvyJIlyO6fZLYOwVsVewIVJYRNUaCKYt1ZL6W+633YaqZ350woo6jSo/oE1INa8090GgEbmzuMg3xO9pccPLJkAviGn+MWEyTS3s8/8MFxD2lZy+q4Y9Qq/EjCmS2rHCjEdi27kRGYXi4wlCKiJ3EzcG256OnSVlYsw1TGu51PLveSQ2tuA+KxQGuFrR3X28GCj2GMl/LHgu+y/SwEvrdhDX9CcIJ0dhkFBm9KEMl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 05:41:57PM -0600, Jane Chu wrote:
> hugetlb_reserve_pages() consume indices in hugepage granularity although
> some callers naturally compute offsets in PAGE_SIZE units.
> 
> Teach the reservation helpers to accept base-page index ranges and
> convert to hugepage indices internally before operating on the
> reservation map. This keeps the internal representation unchanged while
> making the API contract more uniform for callers.
> 
> Update hugetlbfs and memfd call sites to pass base-page indices, and
> adjust the documentation to describe the new calling convention. Add
> alignment warnings in hugetlb_reserve_pages() to catch invalid ranges
> early.
> 
> No functional changes.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  Documentation/mm/hugetlbfs_reserv.rst | 12 +++++------
>  fs/hugetlbfs/inode.c                  | 29 ++++++++++++---------------
>  mm/hugetlb.c                          | 26 ++++++++++++++++--------
>  mm/memfd.c                            |  9 +++++----
>  4 files changed, 42 insertions(+), 34 deletions(-)
> 
> diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
> index a49115db18c7..60a52b28f0b4 100644
> --- a/Documentation/mm/hugetlbfs_reserv.rst
> +++ b/Documentation/mm/hugetlbfs_reserv.rst
> @@ -112,8 +112,8 @@ flag was specified in either the shmget() or mmap() call.  If NORESERVE
>  was specified, then this routine returns immediately as no reservations
>  are desired.
>  
> -The arguments 'from' and 'to' are huge page indices into the mapping or
> -underlying file.  For shmget(), 'from' is always 0 and 'to' corresponds to
> +The arguments 'from' and 'to' are base page indices into the mapping or
> +underlying file. For shmget(), 'from' is always 0 and 'to' corresponds to
>  the length of the segment/mapping.  For mmap(), the offset argument could
>  be used to specify the offset into the underlying file.  In such a case,
>  the 'from' and 'to' arguments have been adjusted by this offset.
> @@ -136,10 +136,10 @@ to indicate this VMA owns the reservations.
>  
>  The reservation map is consulted to determine how many huge page reservations
>  are needed for the current mapping/segment.  For private mappings, this is
> -always the value (to - from).  However, for shared mappings it is possible that
> -some reservations may already exist within the range (to - from).  See the
> -section :ref:`Reservation Map Modifications <resv_map_modifications>`
> -for details on how this is accomplished.
> +always the number of huge pages covered by the range [from, to).  However,
> +for shared mappings it is possible that some reservations may already exist
> +within the range [from, to).  See the section :ref:`Reservation Map Modifications
> +<resv_map_modifications>` for details on how this is accomplished.
>  
>  The mapping may be associated with a subpool.  If so, the subpool is consulted
>  to ensure there is sufficient space for the mapping.  It is possible that the
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index a72d46ff7980..ec05ed30b70f 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -157,10 +157,8 @@ static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
>  	if (inode->i_flags & S_PRIVATE)
>  		vma_flags_set(&vma_flags, VMA_NORESERVE_BIT);
>  
> -	if (hugetlb_reserve_pages(inode,
> -			desc->pgoff >> huge_page_order(h),
> -			len >> huge_page_shift(h), desc,
> -			vma_flags) < 0)
> +	if (hugetlb_reserve_pages(inode, desc->pgoff, len >> PAGE_SHIFT, desc,
> +				  vma_flags) < 0)

Ok, this is something that I have been thinking every time  I looked
into hugetlb reserve code, but I think we should be really starting to
put some meaningful names for from and to, and pass that to
hugetlb_reserve_pages.
Because "desc->pgoff" and "len >> PAGE_SHIFT", meh, and it is not that
many places we need to touch, but we might want in clarity.
The same goes for hugetlb_unreserve_pages() of course.

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 47ef41b6fb2e..eb4ab5bd0c9f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6532,10 +6532,11 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
>  }
[...]
> @@ -6558,6 +6560,12 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		return -EINVAL;
>  	}
>  
> +	VM_WARN_ON(!IS_ALIGNED(from, 1UL << huge_page_order(h)));
> +	VM_WARN_ON(!IS_ALIGNED(to,   1UL << huge_page_order(h)));

If we want to scream if someone passes us unaligned indices, we might
want to do the same in hugetlb_unreserve_pages() ?

> diff --git a/mm/memfd.c b/mm/memfd.c
> index 56c8833c4195..59c174c7533c 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -80,14 +80,15 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t index)
>  		struct inode *inode = file_inode(memfd);
>  		struct hstate *h = hstate_file(memfd);
>  		long nr_resv;
> -		pgoff_t idx;
> +		pgoff_t next_index;
>  		int err = -ENOMEM;
>  
>  		gfp_mask = htlb_alloc_mask(h);
>  		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
> -		idx = index >> huge_page_order(h);
> +		next_index = index + pages_per_huge_page(h); 

Trailing white space.


-- 
Oscar Salvador
SUSE Labs

