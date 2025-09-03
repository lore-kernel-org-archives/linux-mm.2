Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB7D0CA1012
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 23:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22DF18E000B; Wed,  3 Sep 2025 19:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205608E0005; Wed,  3 Sep 2025 19:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11C2D8E000B; Wed,  3 Sep 2025 19:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 000FD8E0005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:46:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DC06140934
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:46:35 +0000 (UTC)
X-FDA: 83849575950.01.11C9423
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 790581C0005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:46:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Mba1dxRk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="b+4sSnp/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Mba1dxRk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="b+4sSnp/";
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756943193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2eMNILRIi5fl/7TwqQWQ4yuaKzHKs01WiGg9m5ceGQU=;
	b=mvR+PYRY1NXJgGfs2YhFRgEb1sQdRcJ7nAXPPMC1UWxCeAZkvWtEkuuOHofQpmwZLuwccf
	a0xwkxPIZogwQjdSPELNVNKq0wz4q/HSC1JwhobLpR9bkBk7CW1/2pv2Xu3dDWgvm2DDw4
	eYenMjp1vmnK8oKy6Qg8GYTHMjUP3UU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Mba1dxRk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="b+4sSnp/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Mba1dxRk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="b+4sSnp/";
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756943193; a=rsa-sha256;
	cv=none;
	b=3uPbJJTo4AHJZGVOV9gYg2+JieOInA5gUWcFcnv/BbJ6chEjOC6LOUjAqM2cznaCFPL+0l
	J5HuhEyF7KeqLPDqU8gV2S6dbD+DTTy3KkJZymCwYoDFttL7ladWnMqwKLTMf9v9wDqqpu
	0zUvc1vZc9VrD29dZem+8aifLWuFjBk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 82E621F453;
	Wed,  3 Sep 2025 23:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756943191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eMNILRIi5fl/7TwqQWQ4yuaKzHKs01WiGg9m5ceGQU=;
	b=Mba1dxRk6YJ+ojtmKh2eM23n6aBa7qmcScqSqLFlBjjaBao1ruTriFaPSPqjQ3KQDQ6Xbr
	94tKTa1feEyu68WFWI2SOVhSzeB7tU/AUrZfalq0VTFS/J80Pet1EAWL7g1LT8tpkldqHA
	dCgAxpn8X+Uydy7q6utrteKOJeNf5Uo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756943191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eMNILRIi5fl/7TwqQWQ4yuaKzHKs01WiGg9m5ceGQU=;
	b=b+4sSnp/O2EzFyl1Y0ZcQT+8n7OZ8LNQdSgw5SGiJmEfAEDyw8B4GFxhbqXhUMdp+iZFo6
	/prhKG/x4D7hudCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756943191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eMNILRIi5fl/7TwqQWQ4yuaKzHKs01WiGg9m5ceGQU=;
	b=Mba1dxRk6YJ+ojtmKh2eM23n6aBa7qmcScqSqLFlBjjaBao1ruTriFaPSPqjQ3KQDQ6Xbr
	94tKTa1feEyu68WFWI2SOVhSzeB7tU/AUrZfalq0VTFS/J80Pet1EAWL7g1LT8tpkldqHA
	dCgAxpn8X+Uydy7q6utrteKOJeNf5Uo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756943191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eMNILRIi5fl/7TwqQWQ4yuaKzHKs01WiGg9m5ceGQU=;
	b=b+4sSnp/O2EzFyl1Y0ZcQT+8n7OZ8LNQdSgw5SGiJmEfAEDyw8B4GFxhbqXhUMdp+iZFo6
	/prhKG/x4D7hudCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8BDF713888;
	Wed,  3 Sep 2025 23:46:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qZlTHlbTuGiObwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 03 Sep 2025 23:46:30 +0000
Date: Thu, 4 Sep 2025 00:46:34 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, 
	lorenzo.stoakes@oracle.com, kernel-team@android.com, android-mm@google.com, 
	David Hildenbrand <david@redhat.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
Message-ID: <qa7b7pvrycejnn6pjytxysu57xckhexupjrzefmk4j5hlaxka3@ayeg2vzpfe3r>
References: <20250903232437.1454293-1-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903232437.1454293-1-kaleshsingh@google.com>
X-Rspamd-Queue-Id: 790581C0005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: u611ngho13owrmcigaynaiua76r3fkf6
X-HE-Tag: 1756943193-927772
X-HE-Meta: U2FsdGVkX1/DRT14tWUGnqWbgyA4UhmTIM+0wVtefpVeZgV+lgPijct06jkQjN5i/I5399TbSkM5vsvOGXOFIOjNPs9BX8PSgUr/YZTiDsqL+blu53kiM99gmstjbsZ614s3oR7+HRsyxDnf0fmf7waUqsWRBby00wLIq7bn8UHUMFvqMmUT+HboqSTOnXcAHDt/Oy0bnWJ57j8QOoePxgnHp1mGSRoHpKchPyu0mhCDtYroLvsA1p7vkWOLjPjF8u7187gO9+eZnEoZcLUhKPS+dFC5WgYFOabYsTHzVbYMUX5E+fnYAWazgo5ZqU3dNboYTN9X8pbfBfSDB2ws1iaa2vb9ihCBoaLsvJ0RMQXLvQ0gekO2KEWJlQs0LGCA+1Lmj8tcHOHMBlAmByeedo7qdo8cRYdgJwP/yDhUqqr+aJ4FaetHR9LPnZXzzow6GoADv68L9aV037dVzALYTgA5vlevTyT9ujW5XA36hoNh2IiCPnLRSproOTTb90YGJwmJ1HAm/sgKGoTN1HLzjeOmGzOMe9BkChQYrcIyYBhQo9cb8gfpvxcPC2oXRCIVULQD6exSAaEt5JlGmr3b9trHtPoJE7kHOAR5BGsCZstmhsgrj3sIeJP43n+7WM7/vn4uhyc4TGUT5JUxy4/1ObIfn84ifCryuIy/9LHE8JTw3OFewoC+Eqk0K8vgGXfsOv0IYWNzFgJdSMVKT7fp7SSu87y71nyAqw/tnZmP3UnO2hWgectQk4xa8vHKRSxZtzz/gqHD2DvUWdlaPqj67vYmmKmZBDxf1wmqZSx15NZTJmSU8BOR+fbH4BRq4op2KkqDJ0feqBuJ4jUg7Nc9yE9Tkxs9DvJLIL2mpiItL+VPv3zMp5do4LfM0qKPfkaChKGbrknAbD7sMzMRuFlYNineEOYsCFGUVVk4DkLbEMiRaZPhecHbQfei0KPouDPy5WkvXFZOcp8lK8kva6k
 g5ZG9Lct
 wi2dZw6ufFo2Y18e43KdN7CNYA20nX0Z4b2FLunrBR8SdJnoPm06Z33xxFtyvhRaFoGTPB1EKbsmHM1004TNLKkLl0BGFmPzjo4qqH0+eB8TPIbEYnaaMMwnHcbXE6lbItlxEBU+vVLsYY/xAhXGxbfCQCwUH4baIdIxNBnLXeZ/CsgSlVQK707zC88FJ4ITfmR/w2FwhKdz3L0urUCJ6QoT0FOma0d7NY/uKm8WonLraUsiJg/KzyjotgALzQwI2f1UfsEzBMPgLKE71ANF245jb9LQLgHrJrcZrZg9DAgtZZbdR5AI0ilEDgt+MglwhlQlx/eDXAhrUGdogaWdAw7lO7W9P4p/x7cyJP2zmwKw+Eh7xhGnOmePaQDv6rQcokivuBoznULiPkMX9Ttyi99Q7sIr5ONrpWdN0nyooHTmKN5zZDBdOCpsM5QCPO4fUu0f5FRKsBSxSZUuo3hqTO3/+Vw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 04:24:35PM -0700, Kalesh Singh wrote:
> The check against the max map count (sysctl_max_map_count) was
> open-coded in several places. This led to inconsistent enforcement
> and subtle bugs where the limit could be exceeded.
> 
> For example, some paths would check map_count > sysctl_max_map_count
> before allocating a new VMA and incrementing the count, allowing the
> process to reach sysctl_max_map_count + 1:
> 
>     int do_brk_flags(...)
>     {
>         if (mm->map_count > sysctl_max_map_count)
>             return -ENOMEM;
> 
>         /* We can get here with mm->map_count == sysctl_max_map_count */
> 
>         vma = vm_area_alloc(mm);
>         ...
>         mm->map_count++   /* We've now exceeded the threshold. */
>     }

I think this should be fixed separately, and sent for stable.

> 
> To fix this and unify the logic, introduce a new function,
> exceeds_max_map_count(), to consolidate the check. All open-coded
> checks are replaced with calls to this new function, ensuring the
> limit is applied uniformly and correctly.

Thanks! In general I like the idea.

> 
> To improve encapsulation, sysctl_max_map_count is now static to
> mm/mmap.c. The new helper also adds a rate-limited warning to make
> debugging applications that exhaust their VMA limit easier.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>  include/linux/mm.h | 11 ++++++++++-
>  mm/mmap.c          | 15 ++++++++++++++-
>  mm/mremap.c        |  7 ++++---
>  mm/nommu.c         |  2 +-
>  mm/util.c          |  1 -
>  mm/vma.c           |  6 +++---
>  6 files changed, 32 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..d4e64e6a9814 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -192,7 +192,16 @@ static inline void __mm_zero_struct_page(struct page *page)
>  #define MAPCOUNT_ELF_CORE_MARGIN	(5)
>  #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
>  
> -extern int sysctl_max_map_count;
> +/**
> + * exceeds_max_map_count - check if a VMA operation would exceed max_map_count
> + * @mm: The memory descriptor for the process.
> + * @new_vmas: The number of new VMAs the operation will create.
> + *
> + * Returns true if the operation would cause the number of VMAs to exceed
> + * the sysctl_max_map_count limit, false otherwise. A rate-limited warning
> + * is logged if the limit is exceeded.
> + */
> +extern bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas);

No new "extern" in func declarations please.

>  
>  extern unsigned long sysctl_user_reserve_kbytes;
>  extern unsigned long sysctl_admin_reserve_kbytes;
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7306253cc3b5..693a0105e6a5 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  		return -EOVERFLOW;
>  
>  	/* Too many mappings? */
> -	if (mm->map_count > sysctl_max_map_count)
> +	if (exceeds_max_map_count(mm, 0))
>  		return -ENOMEM;

If the brk example is incorrect, isn't this also wrong? /me is confused
>  
>  	/*
> @@ -1504,6 +1504,19 @@ struct vm_area_struct *_install_special_mapping(
>  int sysctl_legacy_va_layout;
>  #endif
>  
> +static int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
> +
> +bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas)
> +{
> +	if (unlikely(mm->map_count + new_vmas > sysctl_max_map_count)) {
> +		pr_warn_ratelimited("%s (%d): Map count limit %u exceeded\n",
> +				    current->comm, current->pid,
> +				    sysctl_max_map_count);

I'm not entirely sold on the map count warn, even if it's rate limited. It
sounds like something you can hit in nasty edge cases and nevertheless flood
your dmesg (more frustrating if you can't fix the damn program).

In any case, if we are to make the checks more strict, we should also add
asserts around the place. Though there's a little case in munmap() we can indeed
go over temporarily, on purpose.

-- 
Pedro

