Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE79D2D0E8
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA26D6B008A; Tue, 13 Jan 2026 07:44:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8CF06B008C; Tue, 13 Jan 2026 07:44:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B794E6B0092; Tue, 13 Jan 2026 07:44:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A89AA6B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:44:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 75FC71A0117
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:44:50 +0000 (UTC)
X-FDA: 84326909940.26.9C22F5C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 035A6C0003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:44:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K67Cdn3S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zxU1APvI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K67Cdn3S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zxU1APvI;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768308288; a=rsa-sha256;
	cv=none;
	b=7BDmePI9guP/uZ/0Up3+zhx9Uo7r5t6D6Mqn0eY37LeVuR+7fUNMHKYAwW0J3kDzPSXJJd
	/zhsOGiGQZJjNfoL6GMqj2rqSg/C/ASWPxUEiLney2eoc95D2jejGcCrPXrETsCBcldQ//
	CZu+9g1D5LqKCKK47uGOU7/5eyqhLJo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K67Cdn3S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zxU1APvI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K67Cdn3S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zxU1APvI;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768308288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BYnIltIsPKs/CGQ9ft9ry0PJhQG3lj+kfXFjWwd6nw=;
	b=R54SB0kLq8GWmaEh8gOQEcmmk7ZIE703yxF6BPYp0XIzfiZkaNIbao2F88iwD+h9TPX7sm
	LffpbSOeg4wyYd37jo0+FiJ+gxSdlDd2LmhC+7jzaT2qjtj4y/psd7U2MPz0mCpbjEoZpM
	HWwwv1QFZ5zDWcbcZuSF7ibvMgVHosg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0673433684;
	Tue, 13 Jan 2026 12:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768308286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3BYnIltIsPKs/CGQ9ft9ry0PJhQG3lj+kfXFjWwd6nw=;
	b=K67Cdn3SOUv93HIrhrEBLx0e+jAmt+RUP97YzIXJfiMe6OR1Zscg+Bv2oc3sW7TJGVdmhx
	xpxoaaBJvhSslfTef2nQYfmO8cjGfob6+nPw8GLzPJ9Z95ZLLcrTpmd0b+lIgvNIqsmFgu
	39HnI9uLTyB+Syha7Lmh7gj6dcdSKGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768308286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3BYnIltIsPKs/CGQ9ft9ry0PJhQG3lj+kfXFjWwd6nw=;
	b=zxU1APvIwO0MBG6S8o6DMZwyJWL1DB6GEtq8WkKNZhXWC2qQ7Y1fvrOXt5fVdsU46gdlUk
	UWXWXL4cR10h93DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768308286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3BYnIltIsPKs/CGQ9ft9ry0PJhQG3lj+kfXFjWwd6nw=;
	b=K67Cdn3SOUv93HIrhrEBLx0e+jAmt+RUP97YzIXJfiMe6OR1Zscg+Bv2oc3sW7TJGVdmhx
	xpxoaaBJvhSslfTef2nQYfmO8cjGfob6+nPw8GLzPJ9Z95ZLLcrTpmd0b+lIgvNIqsmFgu
	39HnI9uLTyB+Syha7Lmh7gj6dcdSKGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768308286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3BYnIltIsPKs/CGQ9ft9ry0PJhQG3lj+kfXFjWwd6nw=;
	b=zxU1APvIwO0MBG6S8o6DMZwyJWL1DB6GEtq8WkKNZhXWC2qQ7Y1fvrOXt5fVdsU46gdlUk
	UWXWXL4cR10h93DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E3C6B3EA63;
	Tue, 13 Jan 2026 12:44:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GX5lNz0+ZmnoZAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 13 Jan 2026 12:44:45 +0000
Message-ID: <2cdff2ed-a45d-47e9-94ef-f8ecd178bbae@suse.cz>
Date: Tue, 13 Jan 2026 13:44:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 8/9] mm/slab: move [__]ksize and slab_ksize() to
 mm/slub.c
To: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org
Cc: andreyknvl@gmail.com, cl@gentwo.org, dvyukov@google.com,
 glider@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com,
 roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com,
 tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, hao.li@linux.dev
References: <20260113061845.159790-1-harry.yoo@oracle.com>
 <20260113061845.159790-9-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <20260113061845.159790-9-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 035A6C0003
X-Rspamd-Server: rspam06
X-Stat-Signature: i67sj7uh99tccofnt5sfnizpe1xn9stt
X-Rspam-User: 
X-HE-Tag: 1768308287-504284
X-HE-Meta: U2FsdGVkX1+wAfJrNd37KVxN66InQd/H9H2M5LcIkW63CYVsRwzF4uX9SomXxDfd3r+Uq4iY3dM4Bu389ysUN1MGlX4hDKPVWt9K1WbKYwlK00co6rM0hub1x7BJdqKJR8XB9MJkzwyyDggBcEnRVqk0wEBWuEPs7llrTax4V1fOTU31jigjJ3lhtXePVeVRfbLwzLOFE07GUQFvv5IgBpUEgRdnbUOufIHUBiRNgEGuiMSwGRexW+HfhA497nDfELGTdFhHQcsWkU1ykXiZ555LYTnw/FRFUTKnYWw0FEuX4PkZ5ziPHMtW6gfKlxVhqVu/kfbBQCpQ60iVxyj6+9NvjmlKU6EhG0qByReY8mRRTl83dVKSXgU9YeBicgoZrYhGDOabtaHjoiah3AEN6Tfg8tg3HvYsAzCN0J9mHQ+mruXa8O+hJb70J1rxkXk3QE4jlC9NvZk4ogqDMRKIPut8ju+PKKeDJ8T69y32idZQVS2EAI/NeUgZSrb2+U3GRYVNjSHLgqEjz2J6M/W6U8RTiQjwcLl86B3ClGMEe1KdjsGHJd3zNifammSjj9MHMquEIca7cO6XVaR+OuDGLJRNPt5L15ydH4z7+z6qPLoB0Ln9q/Q6I7tr1M8smt0Ym4QiM9EhIkoyVKhp9h0vfdCm/TApCmLMjAyilQFXF2k4w8XnCvPQd1V9MC6A0HSAXPzEgq+I5ptlksdBoQgtDr61sJ56UWLkNT9aEW/RkzhmzPXPBOxiMNWpeOcmWnMTY58WK9RxXwW3XmruijSqWDfaUOYyzcRHK5ekJAXSay2rNlXxrpKB7OeR3IMQMdvrcBs9K6iZ8gsod3Pr6/rGnYNRIyO6VuJ+c0Tz7wMCD2k2p23J2+CbbBciVDnXrL4tC7pJTNiWBVgG4r/AOyAeC4qeN5fiPeL/7VXNp2Q2wBsduUERT5YumoaGpevWRdiN0JA/lK9lwA3/8MfL8/k
 mRqsMe67
 GJffvrSA1+HgPmGhBQhrZhAx+8pP2AluOJ4SmnnoAdH8iBr67NfucDKK0byNo8owaV0yl5KBKL8NcPbn+h2ZbNRNUSNs1SpumDTFfGreA1k0HhlsPCoKgW3PBDukwoT6zkTrDk5EzolxIX/YaK7lfTfpT8dtHz+czywWsx5r1Vrps3xoFdo7LpY3Y5GSAI8epROFub4+Gh7+R0+LxB2FiaCN5U97uIQxDK+uT44PZhgQ+cFbihERRmTFi1PNpx8pA3dF31r9Ryw87Lth96CvEf2BbxiUvc8LfWICP+Ag7Yo5C+gwGR6M6yhJ8SMnOdEd+3WQ1oMw2MH0krfTl8+cQkL+s75k8qRBiEhtRQSEzO9AYsgw98LcGVX68hrJYsITDt3nh0socYGVLy60vi3r3QIdArsMJ4a8hvB06ky8BNpfk7hs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 7:18 AM, Harry Yoo wrote:
> To access SLUB's internal implementation details beyond cache flags in
> ksize(), move __ksize(), ksize(), and slab_ksize() to mm/slub.c.
> 
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/slab.h        | 25 --------------
>  mm/slab_common.c | 61 ----------------------------------
>  mm/slub.c        | 86 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 86 insertions(+), 86 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 5176c762ec7c..957586d68b3c 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -665,31 +665,6 @@ void kvfree_rcu_cb(struct rcu_head *head);
>  
>  size_t __ksize(const void *objp);
>  
> -static inline size_t slab_ksize(const struct kmem_cache *s)
> -{
> -#ifdef CONFIG_SLUB_DEBUG
> -	/*
> -	 * Debugging requires use of the padding between object
> -	 * and whatever may come after it.
> -	 */
> -	if (s->flags & (SLAB_RED_ZONE | SLAB_POISON))
> -		return s->object_size;
> -#endif
> -	if (s->flags & SLAB_KASAN)
> -		return s->object_size;
> -	/*
> -	 * If we have the need to store the freelist pointer
> -	 * back there or track user information then we can
> -	 * only use the space before that information.
> -	 */
> -	if (s->flags & (SLAB_TYPESAFE_BY_RCU | SLAB_STORE_USER))
> -		return s->inuse;
> -	/*
> -	 * Else we can use all the padding etc for the allocation
> -	 */
> -	return s->size;
> -}
> -
>  static inline unsigned int large_kmalloc_order(const struct page *page)
>  {
>  	return page[1].flags.f & 0xff;
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index c4cf9ed2ec92..aed91fd6fd10 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -983,43 +983,6 @@ void __init create_kmalloc_caches(void)
>  						       0, SLAB_NO_MERGE, NULL);
>  }
>  
> -/**
> - * __ksize -- Report full size of underlying allocation
> - * @object: pointer to the object
> - *
> - * This should only be used internally to query the true size of allocations.
> - * It is not meant to be a way to discover the usable size of an allocation
> - * after the fact. Instead, use kmalloc_size_roundup(). Using memory beyond
> - * the originally requested allocation size may trigger KASAN, UBSAN_BOUNDS,
> - * and/or FORTIFY_SOURCE.
> - *
> - * Return: size of the actual memory used by @object in bytes
> - */
> -size_t __ksize(const void *object)

Think it could be also static and not in slab.h? I'll make that change
locally.


