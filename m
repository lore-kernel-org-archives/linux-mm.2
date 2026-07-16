Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA9AFC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97EDC6B0118; Thu, 16 Jul 2026 11:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956026B0128; Thu, 16 Jul 2026 11:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86EC76B012A; Thu, 16 Jul 2026 11:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 567C06B0118
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:06:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DCF1B1A01DF
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:06:27 +0000 (UTC)
X-FDA: 84994966014.15.7A3C772
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id C5F2780003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:06:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ikMIH4Ic;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="MNxsDl/3";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Vp74B/0y";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ko63zMhl;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784214386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HujAVb6RxLv5hlDKjw4a52J9PZBMkT3MwEYBIBN7m8g=;
	b=CqgMDAWtAmuZ5eEwGFfnrdt+1sgw8/75iExBO9/KZeGOc6BPMSYAW+ze0xTrguzQo6nncW
	TgtJSi6HqcGn1X/aK6lQZrCfm67pBRK8UqdNI41el55b1xPtdDPkJru2iRrNo6+NhhUucW
	oKAy7KGLqg77L3eAZXiyXqYVWRS84Jg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ikMIH4Ic;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="MNxsDl/3";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Vp74B/0y";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ko63zMhl;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784214386;
	b=1iNOeBJMCP+mOceciJmG90a0hmK4tvi8Nu5jvN3ZuHcIjEtDRCpxC6qmoAkHHFxgrYko6P
	PuxEUxSRZvHXCEOVHRtkKhtF0QGI5X7ztVNoT8YsbxIlgHl3i3heAVuxXYJO5dRfnUzR7v
	M50c5VWQk5fnTZwD9YSHaiM9ALtG8BM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EBD4D3E2F;
	Thu, 16 Jul 2026 15:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784214384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HujAVb6RxLv5hlDKjw4a52J9PZBMkT3MwEYBIBN7m8g=;
	b=ikMIH4IcJlUgiCWe6Ktqow1P47x4dTtfrGnNl57lvOAK14l/CccNBlYLznxl4hfWYYdWU/
	buiXPf9ZKxqb3EUJMU9e7DOmYW6LavsklXFMbVpM6aF4tiJx6f83Ml7v6jFbemqGmxVauj
	iTGZ/WmvYNux3CAAD/aR1uyq5xFyz2U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784214384;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HujAVb6RxLv5hlDKjw4a52J9PZBMkT3MwEYBIBN7m8g=;
	b=MNxsDl/3q0Y0Mvld+ztegXhsQVycpelLl0EwVsI+5AP1FCgVle9Q9l7LdsSzcGp4SySBdJ
	kSK+w28+S0TbmGBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784214382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HujAVb6RxLv5hlDKjw4a52J9PZBMkT3MwEYBIBN7m8g=;
	b=Vp74B/0yTUhb5X27/u9G11wU+b2wXaxylCbXAg3OB7INHoy1pRLTVizpxnnddzeEw45O0m
	ghLhBGMGQC4l83VQFQK0WlJQplysJaKdxHrkvHAORbkJ34U07ckZ9dR1f0geqgUjmGwjmY
	a+vfRUKBjCNFHpoJk+WiGf1+xlDTNu0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784214382;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HujAVb6RxLv5hlDKjw4a52J9PZBMkT3MwEYBIBN7m8g=;
	b=ko63zMhle94/EcBCSuJjv6zUQFuaUI9Jg9G7vfuB0cZBKO9uG3Z5J16psxiUwR6Z9ZW4i/
	fIG9aQXP489gU+Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6653779AD;
	Thu, 16 Jul 2026 15:06:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tcMhMW3zWGpmaAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 16 Jul 2026 15:06:21 +0000
Date: Thu, 16 Jul 2026 16:06:20 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/mseal: limit scope of mseal address zero to
 address zero
Message-ID: <aljyYdgzRZW1kIhs@pedro-suse.lan>
References: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
 <20260716-mseal-fixups-v1-2-3a9609bf041b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716-mseal-fixups-v1-2-3a9609bf041b@kernel.org>
X-Rspamd-Action: no action
X-Stat-Signature: yo3gxb4rrgto9ukypgj7iu5ms757tbsy
X-Rspamd-Queue-Id: C5F2780003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784214385-798665
X-HE-Meta: U2FsdGVkX1/waOBi8bJDj2IV6wtZ1fsSa+603ckrEtXMn8/+ZXrEB7J3nBt76absYJ/LOZ3QvmRARIu0sOOxImZ9UxB+vB5Z9Y/0PtMZ5SoBXmkKiqPA3mKoGxYG7SU9P/HTneUfxUY/Z/sx8aEbpB1RZMdrLayB+Wok/VAd+rYOHA4vT05sIJPe7B8meoNxF6EfuQI/8A4DdTPKMOwOenXLvi1N6WnWbR99laLnFi7EhgPhOkRrg79+X31q5yoU2fk3D5wl456mGvYHWLS6/uytdPryEZs0cm49UYTUcMgb06woccbnJ0wTWzrOotJy5rF9KMkcRP/xMoNJO05s9W6ImwSFGcfwZnhGOjwUIVh1X8PNPjR9D1btjW7XoqXgj9M70rv1QVNtGvMFHjaxJo9YVcfV96kZfrDxmdkLa/Q5y/UE6doE6s36I64pVnIdliETU6AxXpFIWyl7tUlAUQZF1TKdEttQBH6FAUng2hzHjFhI0AgQU06pIm6l1evmWCiNMSAwKUgw6VckN1Dg1lxhY1wu6wmqy6gA7HH8GAw9rjsWnpGE63SZjUqwezrAKS1i0JPWY5F3O4VK5L0xRqUlE6RXvKNeg16G7CHYTysSDKpia6eiynkY0YIUQ1BIHPk6CsY338i9mbKgIzquDzOT1Zk/BeCzJJc4sG8yUvCrNzYYUavQCp/ngGga69pPDi3uIVKWd4kKCGOC/nq0u4vH+Kt0hL3LnemgGMCu06tByFiCMLS5t2YAwpq/iGq9+g3sN4ryhBKjEQzsUYPMrKiONk8kAEZkhrzLKcSu6Ahshdth95UnhBWbjiAi/pwrYQ2K2veqJEtYYQawfU9KxVfgvq5yFOVdJHHWLiGetREIqqAR8lIkhlP6yaV52pCuyXFtietdTKEN7hKbagDaAM1kFT1AS96jpDq5JAWgJaoANeqP9yWA50mpYlX7lDoK96TD7YCjEIuJkgDoO21
 yLe+cYqH
 hmDZIhrBOooQAo8+1hdF+PJXS6+TnOZA0sFEvHs7HrRPndA69WX6b8oNj3fh5TGCGIhoYYIQ2uIuKpEqImFB8q6eT0RITwNeNMeOtwfzdjxOmVav+SIq+7CE8okk2xNg0YxXBD2hZa7WNopBd2ukpWgIoRrJmD+24HMtDSi0c/dAqYoJ0uL9m5qFgfT8nuNbOTo0CmczYFEsQyRdzSIoVSWCM/0Q1wTWATmma1fxeRv9D8igaRTE7+ER3R++AGRGrlwdA6RmJi4YP+rmQ5RrhdWtBp4BFKkMp6rn4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 02:43:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> Commit 44f65d900698 ("binfmt_elf: mseal address zero") unconditionally
> provided do_mseal() to any internal kernel caller in order to address a
> corner case slated for possible removal.
> 
> It also incorrectly attempts to mseal() without checking to see whether the
> mapping even succeeded.
> 
> Restrict the scope to the corner case by providing mseal_mmap_page_zero()
> which asserts the MMAP_PAGE_ZERO personality.
> 
> Avoid unnecessary checks in the start, end range by abstracting the actual
> mseal()'ing to mseal() and have mseal_mmap_page_zero() call that instead.
> 
> Only try to seal the VMA if we mapped the VMA.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  fs/binfmt_elf.c    |  7 ++-----
>  include/linux/mm.h |  8 ++------
>  mm/mseal.c         | 48 +++++++++++++++++++++++++++++++++++-------------
>  3 files changed, 39 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 16a56b6b3f6c..e3131a311995 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1353,11 +1353,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  		   emulate the SVr4 behavior. Sigh. */
>  		error = vm_mmap(NULL, 0, PAGE_SIZE, PROT_READ | PROT_EXEC,
>  				MAP_FIXED | MAP_PRIVATE, 0);

I think pedantically load_elf_binary() should error out on mmap error, no?
Not that this personality is used in the big 2026 however...

> -
> -		retval = do_mseal(0, PAGE_SIZE, 0);
> -		if (retval)
> -			pr_warn_ratelimited("pid=%d, couldn't seal address 0, ret=%d.\n",
> -					    task_pid_nr(current), retval);
> +		if (!error)
> +			mseal_mmap_page_zero();
>  	}
>  
>  	regs = current_pt_regs();
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 550fb92957d1..87feaa5a2b78 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5291,13 +5291,9 @@ int reserve_mem_find_by_name(const char *name, phys_addr_t *start, phys_addr_t *
>  int reserve_mem_release_by_name(const char *name);
>  
>  #ifdef CONFIG_64BIT
> -int do_mseal(unsigned long start, size_t len_in, unsigned long flags);
> +void mseal_mmap_page_zero(void);
>  #else
> -static inline int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
> -{
> -	/* noop on 32 bit */
> -	return 0;
> -}
> +static inline void mseal_mmap_page_zero(void) {}
>  #endif
>  
>  /*
> diff --git a/mm/mseal.c b/mm/mseal.c
> index 207fea89c61e..5930551d84f2 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -32,7 +32,7 @@ static bool range_contains_unmapped(unsigned long start, unsigned long end)
>  	return prev_end < end;
>  }
>  
> -static int mseal_apply(unsigned long start, unsigned long end)
> +static int __mseal(unsigned long start, unsigned long end)

Why? I think the previous name is perfectly cromulent.

>  {
>  	struct vm_area_struct *vma, *prev;
>  	VMA_ITERATOR(vmi, current->mm, start);
> @@ -66,6 +66,38 @@ static int mseal_apply(unsigned long start, unsigned long end)
>  	return 0;
>  }
>  
> +static int mseal(unsigned long start, unsigned long end)

I don't like that you go start - end on a function called "mseal". The actual
system call goes start - len. It just looks confusing :) So either rename it
to mseal_range(), or make it take a start, length pair.

The overall spirit of the change LGTM however. 

-- 
Pedro

