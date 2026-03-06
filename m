Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1043F01825
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 257AC6B0089; Fri,  6 Mar 2026 05:30:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F356B008C; Fri,  6 Mar 2026 05:30:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089586B0092; Fri,  6 Mar 2026 05:30:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDCF86B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:30:46 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B259913ADAB
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:30:46 +0000 (UTC)
X-FDA: 84515269692.08.1DF852F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6CFD54000E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:30:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LftkTYlB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=632EUAM7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LftkTYlB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=632EUAM7;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772793044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vAQr6SkqV3zjssVR9rZd0gIGba+OVvVWyTtFYxHG1Tw=;
	b=RWNA8Yc0G7fosFCQh2IZx26Y25vB5TjcsF7XkkLgfwGU4x4/F4Be6I7HnlTAhRj5IpbViK
	KO6XcISJrS0FPCEMcBsug4iUAhMtJny1PjdWpp0xlKrhr86r8wVs1UpAbSlhjPytmQMnG8
	dHRNJthflXTiSSOG2jkRjznaQbyEdg0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LftkTYlB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=632EUAM7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LftkTYlB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=632EUAM7;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772793044; a=rsa-sha256;
	cv=none;
	b=zBlMHhGgYDyHKFcfujMZwT1GJD2ZvAmNXdxpTbjhbPmb15y2xCTZMFIVXKEbPTv9AQzgXp
	dcM+AvASODEmNMTIVbFKf4oc1FsO09E0UI79kN2szIGc3qJNW6a7mOMe/XUoWiTkiN9W/Y
	OgSpVJZeplEgwOUX+jN4+lIyXaUI8KE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 875923FA7A;
	Fri,  6 Mar 2026 10:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772793042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vAQr6SkqV3zjssVR9rZd0gIGba+OVvVWyTtFYxHG1Tw=;
	b=LftkTYlB+zrmExZCM0xNBcZqm2VBg2WGKqZdbGMSrzXN1qHzs8jIT7z9P1neGQNTtOxaS3
	49tsqrFGpbUs1Bkcp3+4aYxaZ/oFlZbu8N5kZJVAVVOKRJIbNWHOmefLgDzGEG5KtChk+i
	udYkR76rHLSYTOgXKupZhCjazdHoYc8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772793042;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vAQr6SkqV3zjssVR9rZd0gIGba+OVvVWyTtFYxHG1Tw=;
	b=632EUAM7/SbLKijbGlqOzTmYmkiz+gXT9KFcaSSq/c1yD7DQL4ilODdzxNyo+UYamNPbrK
	aDxOVrBsk59Dp/Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772793042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vAQr6SkqV3zjssVR9rZd0gIGba+OVvVWyTtFYxHG1Tw=;
	b=LftkTYlB+zrmExZCM0xNBcZqm2VBg2WGKqZdbGMSrzXN1qHzs8jIT7z9P1neGQNTtOxaS3
	49tsqrFGpbUs1Bkcp3+4aYxaZ/oFlZbu8N5kZJVAVVOKRJIbNWHOmefLgDzGEG5KtChk+i
	udYkR76rHLSYTOgXKupZhCjazdHoYc8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772793042;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vAQr6SkqV3zjssVR9rZd0gIGba+OVvVWyTtFYxHG1Tw=;
	b=632EUAM7/SbLKijbGlqOzTmYmkiz+gXT9KFcaSSq/c1yD7DQL4ilODdzxNyo+UYamNPbrK
	aDxOVrBsk59Dp/Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C4A063EA75;
	Fri,  6 Mar 2026 10:30:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WNGxLNCsqmn+NQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 06 Mar 2026 10:30:40 +0000
Date: Fri, 6 Mar 2026 10:30:39 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4 4/5] mm: rename zone->lock to zone->_lock
Message-ID: <nn6xirm5sa3mf63gcq5mlthk3nrrdig6zpv2mj4vqnsl27nsxe@2si2t2l6pgex>
References: <cover.1772206930.git.d@ilvokhin.com>
 <d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6CFD54000E
X-Stat-Signature: tkp7ix1bq6me4ofwmba3crz98wg5tbrf
X-Rspam-User: 
X-HE-Tag: 1772793044-536752
X-HE-Meta: U2FsdGVkX1+WRTT3dbVo/N5CJKnQUGvJvwQgY0EbfelnuUhsIurpKSw1DOQIQ3EKwbCxZjHEGbKlhgyYU7NQKMN8EZNgtxosFQOfgjDLuIER9EtDmLK5ehhnZrp1VCkG6ZQLaSc65fVIByMpZ8EkOMMI9d6QFmrJzKOJl7Z4bP8crlype6tT5MV4WmLwKh6I246Z5e0UOnt6ICi97Gv+mNtbKMIRrf+WYOVvP6h5khaRe4wdpX7oQ6L4YLa1mnmQl/vEQDW0JDN+YiP9+qh0h4GBCIZs4rSFqd7vdGjI/+uUh0eQ7cpN9xHlLGZlutOuGIataeTa9PlmJPFl29LNhQl4IcPNEfQwhzxu4Cn4MvAkpkuRIX0YFrjkf3BfA8hJ1kKv2dBDwisUbGy+us3l3Pfzl/MwjkxqlNLpaurYTZ1juilQe9/A+fe6BsnY6WuZZ/YK/mbsfxoS8cC01CQU842LI7/SN5A7j0amAJ8DtxtW/f9E3fgFDEoeSwzB9hzicxdpnmw4kwd0kSESNGLSq9PYKXEe81bKPyVjscFvXjNHfG3lXUVdwnfVry4YuSPguNNwwRjOVQdBDWiiugKAucEAe2A3ZR8ttl7NFPgW1tE+3/CpN1HeObJ3zMBxdr0XRCP79oB011t5csvIwYe+8uNb0SRnJKlwwGIzgDVrNp71/ptZH6q/ra7TLMs/ZTsc/JETpTDdpo7WHmu7Gg4M8DREwRZCmU5AJBBBV4RWuaGDtD8OweRiKRmD+18BTRKfIh8ZHwuBn2BwZSqejEWeSnm82frjm5gyJbnERBr8ypyjZ5rLYZbqVnP4a5qVGdKcZOK+LiAkq60fXCbrjH0IS+gbmhDG1ab+FsMlnXKgUIwj+MSOeHwJ7OQLk/ECJACchbPUbjqNdIWAz6bWkHBTIb8kdtcfzjvx2uyZ4qMdcJIXYnPK9lfloI0R1l+rehLXL1FPl0xEqMU6nIdB+Pu
 1sDNSoaj
 1TV/if+7DMZ+NiLAJfQA1hMP93HOpqwSznnUQPvHsrDCLpLwr/38+v7JPhtZ9MshPqr8NBniADYwvlkwri6CBWKupvrr9hEXBFJowG52QHVUkdKLVxMix97iPHjaerpLRkXXIA3fAyZ2rsN9p/u++FzNTpX/TpjPk5gFBfd2dLWHEpt1/grRJJXitEvvsDZz98WFDdnfOPcezUUdCPbg1tZaO+R8XST64KxQHxZtx9V/i22Ub20DNZ91jILEysEoeJnimN4JU3DeF/kvzmaWvY71kLavIlPxYEsS5TUmHZyEduNaKfMCcKA+/y3v1tFKving42jGybqdr2m3E+76ETObV0241QGK1vXWojVhAeVrFWrmUI+W/Xbze1H0DHouJJvhHOUspcSh+lUTD4LGx3ZwksAAaBqZWPgGvAhza3gK1rHPmMD4K8ernPGnL16ZNyxU9ieIbxwuXmxGgVv2u8mNWK/zI0MpnWSh4OpMho1CrG9kfvJg0zc+HvcccdLHAxkC71KOMf5j4J64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 04:00:26PM +0000, Dmitry Ilvokhin wrote:
> This intentionally breaks direct users of zone->lock at compile time so
> all call sites are converted to the zone lock wrappers. Without the
> rename, present and future out-of-tree code could continue using
> spin_lock(&zone->lock) and bypass the wrappers and tracing
> infrastructure.
> 
> No functional change intended.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/mmzone.h      |  7 +++++--
>  include/linux/mmzone_lock.h | 12 ++++++------
>  mm/compaction.c             |  4 ++--
>  mm/internal.h               |  2 +-
>  mm/page_alloc.c             | 16 ++++++++--------
>  mm/page_isolation.c         |  4 ++--
>  mm/page_owner.c             |  2 +-
>  7 files changed, 25 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 3e51190a55e4..32bca655fce5 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1009,8 +1009,11 @@ struct zone {
>  	/* zone flags, see below */
>  	unsigned long		flags;
>  
> -	/* Primarily protects free_area */
> -	spinlock_t		lock;
> +	/*
> +	 * Primarily protects free_area. Should be accessed via zone_lock_*
> +	 * helpers.
> +	 */
> +	spinlock_t		_lock;

I really don't like this uglification.
Suggestion:
	spinlock_t __private	lock;

>  
>  	/* Pages to be freed when next trylock succeeds */
>  	struct llist_head	trylock_free_pages;
> diff --git a/include/linux/mmzone_lock.h b/include/linux/mmzone_lock.h
> index a1cfba8408d6..62e34d500078 100644
> --- a/include/linux/mmzone_lock.h
> +++ b/include/linux/mmzone_lock.h
> @@ -7,32 +7,32 @@
>  
>  static inline void zone_lock_init(struct zone *zone)
>  {
> -	spin_lock_init(&zone->lock);

and then ACCESS_PRIVATE() all over these helpers. This will not make a
difference to the compiler, but it will work with sparse.

It's not that I don't understand what you're doing, but we're going to need
to look to this code and refer to this code 20 years from now, I would rather
not refer to zone->_lock :)

-- 
Pedro

