Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3C49CD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 04:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625A86B00A9; Wed, 17 Jun 2026 00:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FDC26B00AA; Wed, 17 Jun 2026 00:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A826B00AB; Wed, 17 Jun 2026 00:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 294A26B00A9
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 00:26:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D99F140314
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:26:41 +0000 (UTC)
X-FDA: 84888118602.19.8884887
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf05.hostedemail.com (Postfix) with ESMTP id AFEBC100004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:26:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RWy+6Acq;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781670399;
	b=RvhZ2vohaZAqQBMBiY98aoMVQ+xO4tpAUfra4xfc/z39a8WD/gcuV40X9XVHDEFcDnjN6C
	eRXdzIsruHMk2dST3CbtuTPAcUEn4Cba41+JQQBPAqHVtbReCS/RSttYXkWZcpTklvfpAZ
	TtkvEaEM8VAdo9dqURVOnkqOvQZ9wRE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RWy+6Acq;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781670399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uq70pVdz6YKZLfbdKy0h09bc+19np/RW+u0WBUf03HQ=;
	b=EyOcq3mLgC5CRP5l5Ik+NRsGx2qDL2B49dSWE1hAq7P4ubk8ZMXbySC6nFX866sSezEidg
	xPhbaYRCm2FK0/CP69qiZZQzjiTEVP3dKl04eZQ9JYgXMLbk/TDRSBfeIAcQ2hgsoiHrhc
	TPLkAQgV6vuGpy6dqlCpGfbM/ZeH31k=
Date: Wed, 17 Jun 2026 12:26:08 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781670392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uq70pVdz6YKZLfbdKy0h09bc+19np/RW+u0WBUf03HQ=;
	b=RWy+6AcqD5IlFQWwjNyPnNYdTylEhmJ5KcGETwljXFmsDV4A8L8IBz1Jcua0G8m8z5zWQ3
	BEM032kvw/+DlUkUqeg6Opylm1/MnXc2jybmBKCatOPuMaof1XLczC05vgcdPMUv+pddb1
	E5lhp18VT5/D42mrY0DYLOQKE8NngJk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, liam@infradead.org, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/slub: factor user tracking metadata size
 calculation
Message-ID: <ajIg4JCDhz_yAnOX@fedora>
References: <20260616141410.52117-1-pengpeng@iscas.ac.cn>
 <20260616141410.52117-2-pengpeng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616141410.52117-2-pengpeng@iscas.ac.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AFEBC100004
X-Stat-Signature: 61gjuf78d1y1d1mxy9gn4nqtc184zaym
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781670397-58196
X-HE-Meta: U2FsdGVkX18H6D+7PtweIADv/pRTjlXRboFeI8ewFwBBwVYdMWeTEwnNTNy90RjcWSQ03tsr2CZlJuhU7qOrLm2bUMiD832fX4qyLEX+ZkDpGWGR7vQUswXMuDphPiKZ7ay5u/qx5dY9uKHAhnLYBoxt6uPwvKaqvz2UtLE8PeJHpgfL2YCd5O+d+uehLxQuiO7Bnj9mXuHdwcpd7Lt2qRpFXK8x1liLrGuRClhxEhUsGBOwGHPCP6mqlcUXQ7UDGFBGOXyyYsxLB+A1fU9rfgpT3LRVDnUkFyQtalG6rT1tOgYWb80ElSmyAw4mvSRGvpLLBkZ9Fax2UH7pVNkONqhKzyo2I1ZztF2gcYWvXlG/JRYS8ynePojpZYR09jswOwK6mC+W+lcbBcwxDnYadPsbNt927FVy1W+qEKCxzwDlUh4RQrw+RQYMptwDMTSCEpNBDFWzbRNNzenwZ2PvEcGrKbHIk/fcDpPk/p2q+vYKxJnmxItdU3kOMkSzzuhh7J82GtIYlXip59ygKITfBmgeXjFxLmwblY1vDBIsWOmWDZe1lG2pIjX30dj5Y0ZjpuQOcKZfzv45X6KqOi/OPIGMaTmGmacZuhLQZJ/ZAg6C4LXOM9h17+xVOQewmhIwpeo655oXqjjo7aY3ftdb8IVlNjRl2QvNIgYviU+JDzXgZmP/emWGQwj9NhJR0/0Xhmqkdfz/PEVe1/Ef5+lVQHMV4sbdyXG4d1DBUFmvrjUauuvUSqTp6szAd/jiBbBdnCfwnwqEivvJ3gflHtmcRJ/ipMa9IE5drJVsSv15/C9FCSxWYH+BSggVxqcSQLxSai/8niwxKP4tqK7TEm8IRg0bEOQ/LP8/uSMxrg8EMhyJ6YD6v2QtlUa4toOCaNoPbzuosvdpDrXOR5myGwY5ZBJAYl5eurl+8DBhr1z919thiXDsuWN1NmNil3a3AjnQVZjJv38Ao+8ukB+Amg9
 tvaAJXc+
 yXFmm5a7+3pgb2clUvCvdK7CXNpAEWqeAm87A2P27F9ShgChBN8iQYLSNbsZDJ+UU7brKW7lTqx/ZamXhbb/o7Vk0mIdFKdOXxmwdWj9ERxvizXsWK6wZuFex1IwydLgBTRELa0XNVlK3S2ssBf9sUDIyPHYFzS4wMs71gXADuKf2d+h84J+0IqHS9jjgBMe0KMfHhAmViyHFTc8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 10:14:07PM +0800, Pengpeng Hou wrote:
> SLAB_STORE_USER currently stores two struct track records in the per-object
> debug metadata.  The size is open-coded as 2 * sizeof(struct track) in
> several layout and offset calculations.
> 
> Add TRACK_NR and a small helper for the user-tracking metadata size.  This
> keeps all offset calculations tied to the number of track records and makes
> the following extension less error-prone.
> 
> No functional change.

Do we really need a user_tracking_size helper? This seems introducing some
redundant checking for SLAB_STORE_USER.

For example in set_orig_size(), obj_exts_offset_in_object() and
check_pad_bytes()

redundant checking may be confused...

> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  mm/slub.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f87e693aca5d..43d4febd5bf2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -327,7 +327,15 @@ struct track {
>  	unsigned long when;	/* When did the operation occur */
>  };
>  
> -enum track_item { TRACK_ALLOC, TRACK_FREE };
> +enum track_item { TRACK_ALLOC, TRACK_FREE, TRACK_NR };
> +
> +static inline unsigned int user_tracking_size(slab_flags_t flags)
> +{
> +	if (flags & SLAB_STORE_USER)
> +		return TRACK_NR * sizeof(struct track);
> +
> +	return 0;
> +}
>  
>  #ifdef SLAB_SUPPORTS_SYSFS
>  static int sysfs_slab_add(struct kmem_cache *);
> @@ -751,7 +759,7 @@ static inline void set_orig_size(struct kmem_cache *s,
>  		return;
>  
>  	p += get_info_end(s);
> -	p += sizeof(struct track) * 2;
> +	p += user_tracking_size(s->flags);
>  
>  	*(unsigned long *)p = orig_size;
>  }
> @@ -767,7 +775,7 @@ static inline unsigned long get_orig_size(struct kmem_cache *s, void *object)
>  		return s->object_size;
>  
>  	p += get_info_end(s);
> -	p += sizeof(struct track) * 2;
> +	p += user_tracking_size(s->flags);
>  
>  	return *(unsigned long *)p;
>  }
> @@ -885,7 +893,7 @@ static unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
>  	unsigned int offset = get_info_end(s);
>  
>  	if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
> -		offset += sizeof(struct track) * 2;
> +		offset += user_tracking_size(s->flags);
>  
>  	if (slub_debug_orig_size(s))
>  		offset += sizeof(unsigned long);
> @@ -1088,7 +1096,7 @@ static void init_tracking(struct kmem_cache *s, void *object)
>  		return;
>  
>  	p = get_track(s, object, TRACK_ALLOC);
> -	memset(p, 0, 2*sizeof(struct track));
> +	memset(p, 0, user_tracking_size(s->flags));
>  }
>  
>  static void print_track(const char *s, struct track *t, unsigned long pr_time)
> @@ -1196,8 +1204,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
>  
>  	off = get_info_end(s);
>  
> -	if (s->flags & SLAB_STORE_USER)
> -		off += 2 * sizeof(struct track);
> +	off += user_tracking_size(s->flags);
>  
>  	if (slub_debug_orig_size(s))
>  		off += sizeof(unsigned long);
> @@ -1401,7 +1408,7 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
>  
>  	if (s->flags & SLAB_STORE_USER) {
>  		/* We also have user information there */
> -		off += 2 * sizeof(struct track);
> +		off += user_tracking_size(s->flags);
>  
>  		if (s->flags & SLAB_KMALLOC)
>  			off += sizeof(unsigned long);
> @@ -7820,7 +7827,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
>  		 * Need to store information about allocs and frees after
>  		 * the object.
>  		 */
> -		size += 2 * sizeof(struct track);
> +		size += user_tracking_size(flags);
>  
>  		/* Save the original kmalloc request size */
>  		if (flags & SLAB_KMALLOC)
> -- 
> 2.43.0
> 

-- 
Thanks,
Hao

