Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38FD6CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 14:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FFDC8E001B; Mon,  6 Oct 2025 10:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF9D8E0002; Mon,  6 Oct 2025 10:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C5A68E001B; Mon,  6 Oct 2025 10:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA5B8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:55:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 306F91A049C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:55:24 +0000 (UTC)
X-FDA: 83967987768.17.5D94F97
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id D4B4614000B
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:55:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2aMSnF0v;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=M5eZAvfL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2aMSnF0v;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=M5eZAvfL;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759762522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4fqqFaLRqApP2CnNxjsITNJnHLiuJAc6kIlab9Tf0uA=;
	b=XqGfhTPY/cJj1bDAdwg5OLJ5LkS+3ZonPG78XrFTIQvjFxBLRESHfmErADMHkdrRqWl+wJ
	9zkD6FTd87swjf/jMi85sWG5LkLma1ZcvRThhtkB7EgGzhU9tjLW9i9IClUfb+rCsJLm6y
	ina9Tq4GG8EO+rqj/mGIB7qvK7T3k6A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759762522; a=rsa-sha256;
	cv=none;
	b=5qPqQdWzZaWOTMnxuFTGsVHR4xPiVOJ8EOFYygVVuzPop4dxYaWkp1sjGker8iBMRj/gwZ
	thcok0h/BOPAepr+u+CSsNNmNjOanWf7Hcp6ZGWlc8L6CCCf+x1E6ZJ19aU9c/wBg072tT
	SyibB6uj1BETidhsLXHa1p6gvPC6m3g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2aMSnF0v;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=M5eZAvfL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2aMSnF0v;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=M5eZAvfL;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 179442227F;
	Mon,  6 Oct 2025 14:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759762519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fqqFaLRqApP2CnNxjsITNJnHLiuJAc6kIlab9Tf0uA=;
	b=2aMSnF0vFaUTQlRjBeQC73mAUaJTiKhdaESayJJ7YIWh5slZz+JplwjOH9AQcRWxItehy9
	q/JF7THrUN1SgjARnPr79+jlwXqYvCA9XWXB7azw4seXgLKhauwx3vrJGbVNhCGR1uIZ0L
	Z20kEFq43f6quNgNrSVGvKEXbBxG24k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759762519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fqqFaLRqApP2CnNxjsITNJnHLiuJAc6kIlab9Tf0uA=;
	b=M5eZAvfLOdBG4iQO2ffuDrnOH69ngkkcpu7+bOKxVaJMVvSED9zYyCAoDDkHJ6gOqsbKEL
	NGcUGsk6NFbu4YCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759762519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fqqFaLRqApP2CnNxjsITNJnHLiuJAc6kIlab9Tf0uA=;
	b=2aMSnF0vFaUTQlRjBeQC73mAUaJTiKhdaESayJJ7YIWh5slZz+JplwjOH9AQcRWxItehy9
	q/JF7THrUN1SgjARnPr79+jlwXqYvCA9XWXB7azw4seXgLKhauwx3vrJGbVNhCGR1uIZ0L
	Z20kEFq43f6quNgNrSVGvKEXbBxG24k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759762519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fqqFaLRqApP2CnNxjsITNJnHLiuJAc6kIlab9Tf0uA=;
	b=M5eZAvfLOdBG4iQO2ffuDrnOH69ngkkcpu7+bOKxVaJMVvSED9zYyCAoDDkHJ6gOqsbKEL
	NGcUGsk6NFbu4YCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F173013995;
	Mon,  6 Oct 2025 14:55:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pQnvOlbY42jVJQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 06 Oct 2025 14:55:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8A3EAA0ABF; Mon,  6 Oct 2025 16:55:14 +0200 (CEST)
Date: Mon, 6 Oct 2025 16:55:14 +0200
From: Jan Kara <jack@suse.cz>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Amir Goldstein <amir73il@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] fsnotify: Pass correct offset to fsnotify_mmap_perm()
Message-ID: <uyh6y4qjuj6vcpsdnexwl2xqf2jnp6ejj7esr3g3hix66ml2zi@pqsbsjtt6apl>
References: <20251003155238.2147410-1-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003155238.2147410-1-ryan.roberts@arm.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: D4B4614000B
X-Rspamd-Server: rspam02
X-Stat-Signature: agj8oz7g3epgk3u9w6kcwxb6ngpezy38
X-HE-Tag: 1759762521-122856
X-HE-Meta: U2FsdGVkX19DFu1dbm9DC84X+XJLZr9SlbVdp6MSMEr2uHlOyADhxKZFTGCxXoxRCCwMeXysYw3MWnTDiJIuzljm3btDrFJi6LS04Hyjp3d5eHXS8Yn3v6bOH1UMe2IkMubPglAAwzf7WmtPiZHOm+SFwTcHY5JygIuhoHdE97yzQce69TTA6ClMfE5nphXpEoLHdmrmhurOJw4n3fMNp0T5r04PKwfbpLbttshh7vUni3pcoP8FQMxa+P/E67VrsUHXY/KyLAEa7pNl1Gf48SncoXYICbS8ws/p0mWjNm/QK/LEzPm5HwmOPQBbENXHY9QYed2yYzlnKGShuBrTPQXfhAk84m8R5QrvcxqZS5HuraqCoX2Yp8J1Eg4/S2feUhEEvKa5B1YH4KEMSrEQ/LGG61LPWoRcnllrDv898QvLa0UunZYe3ymZVljawIwKvG0unmT/dgVSLzJdMhkca4izBFUG4N034Il649ILwY+WYPePrdsNnfU+tdfulXTf57K4iszWR9AuN8tntmElfntCFbBMf78JG+/CxGVvCuLASItZCKDBskx6gSL2B7qL6nKWZQGIlh7RQfIlIxwwTRRnfYwoWEGtvX0i0qz4Tb4gJ1U9ZHcoY+B8XcW+mRMdZM8LjVAzMxD8OnE0vyinR9hl5vw3InyLQSMExBBK1701bdb3E7TmnJN+pk5ndlT5/2gNaR4SsS/OadfsEJRiaaFCPyxJTj5xrqahTcS0e3UKTsE8DsUB/jEQOouqOQYFYjVWxGiNsrYvZSMc+ZooM+UVY3mOiX0vwLH+Uke4u5Co4GUqq9bgdDXJqGJVWtJrOSFbP4CA7qeB9VWdqZCEfoHKuIZ0ZsyznDOrH9LK98Ma9moAMBU/NmArHFiYKNmEP1wjESTESeEcKaixNZ9Sehfmc3dD7Fht5zxuRrwo4mAhuDTikzNWneHD4Y7ItlQFoVBiOslSKOXbz1YyD42
 eSljUbY3
 rm8Ulzhm/9lLQmOEZGtfT0KmpAgjYuTeRfcS1n+xJYug800YT39NuQmod01bSRsOr4gu5UXu4Y2OnD358PczqNt2UjyjB32nQ7BsbCBTx8D9QelLkWS5cn7ABA752o3UweZDknNFaenFEqy+/Fr2o6apUFQYYlvmiasNdcGEZGEK0YXQfF8B49t+FqDHKYgnVkslEZDNM6lUl1JqWIRSKZiudPqeN/gHRThGR1i8oLusph+/ikzkUJzA/2rJbXZKtz8dmmDd8KSH8vpNY6lXNfWeDrfd2nrGK9TVdR/TPlfByPrArmcukGV3fN0BTdsMDBRsTz0IbBqWO29c37D9pmAI7R9anF5hfmzfZo8rZgHSbkzOJmbZy3IsMjmpGTVhWYYS9SEUY2xg+w992ciqnEYVz/VbQDtGZDJDCSDNcKUU9ScKIEsDQUtOvbPEzpuqaIElOsDSfe8miCoBbgExzBTp/fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 03-10-25 16:52:36, Ryan Roberts wrote:
> fsnotify_mmap_perm() requires a byte offset for the file about to be
> mmap'ed. But it is called from vm_mmap_pgoff(), which has a page offset.
> Previously the conversion was done incorrectly so let's fix it, being
> careful not to overflow on 32-bit platforms.
> 
> Discovered during code review.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
> Applies against today's mm-unstable (aa05a436eca8).

Thanks Ryan! I've added the patch to my tree. As a side note, I know the
callsite is in mm/ but since this is clearly impacting fsnotify, it would
be good to add to CC relevant people (I'm not following linux-mm nor
linux-kernel) and discovered this only because of Kiryl's link...

								Honza

>  mm/util.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/util.c b/mm/util.c
> index 6c1d64ed0221..8989d5767528 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -566,6 +566,7 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
>  	unsigned long len, unsigned long prot,
>  	unsigned long flag, unsigned long pgoff)
>  {
> +	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
>  	unsigned long ret;
>  	struct mm_struct *mm = current->mm;
>  	unsigned long populate;
> @@ -573,7 +574,7 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
> 
>  	ret = security_mmap_file(file, prot, flag);
>  	if (!ret)
> -		ret = fsnotify_mmap_perm(file, prot, pgoff >> PAGE_SHIFT, len);
> +		ret = fsnotify_mmap_perm(file, prot, off, len);
>  	if (!ret) {
>  		if (mmap_write_lock_killable(mm))
>  			return -EINTR;
> --
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

