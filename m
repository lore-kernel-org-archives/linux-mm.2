Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C077CD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 12:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E866B008C; Tue,  9 Jun 2026 08:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7169C6B0092; Tue,  9 Jun 2026 08:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C786B0093; Tue,  9 Jun 2026 08:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 534BA6B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:53:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28EFEA0573
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:53:01 +0000 (UTC)
X-FDA: 84860364162.03.75A5146
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id E0F06C0015
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:52:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D3sxU875;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Lydqrcde;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E5p0l2vR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/qcl9yXQ";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781009579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YjVs4XMojEDCZDsneHUjmf+6PVevcMqyxX1dX7ene70=;
	b=V2IORUE08McypNR0Nv2RhJZa2H2kVWzccj9HAh88GTUL4SlhYpexvvyS/oGNAojQ9LzJhc
	GzQOT0Ixjd0MzldAiQUqTCOiOzHmaP2eGkK3Rd5hRJkgXpJjQEVTwyh4t7IUhL1ILIYND9
	FjbmwZQ013Y1GYujmyQoacUp2KIl+Fo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D3sxU875;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Lydqrcde;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E5p0l2vR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/qcl9yXQ";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781009579;
	b=QddXJd3VU/0xCYCtLsHsuFxX4obS+7W6vow3j7ixv2oThFxV/R8UqX2QYgWobYoRG68uUi
	UkWg5kvS0VWVBz8EJsQjCwkXLq5tPiXSwLKDqqgzOlsTysHFvp0Ww87HPZ7QjweGcaOS+y
	6rFnltsmIi/0mI/kuD3a0ZpAqejLGZ8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F4387599F;
	Tue,  9 Jun 2026 12:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781009577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjVs4XMojEDCZDsneHUjmf+6PVevcMqyxX1dX7ene70=;
	b=D3sxU875kN70T0k1ZVYP9/E8y2C526A1rckA9z0cLAfzHFl1kIf+w82Oz/0wkqviJaBluv
	1liRSl1kEmUo1AgPYzvfXbNp3pYN6mA2lOG/qugCxyuDgLMKY9odM8ELxvwVSPpsiw7mqh
	nc/D+lzSLjAX/vZpkxoqK7h5fLCRAQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781009577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjVs4XMojEDCZDsneHUjmf+6PVevcMqyxX1dX7ene70=;
	b=LydqrcdeYiAka5kpfgjfXTGMot6slWhu4iN1WL/VymRlCSQNY2PQ7UfTg211b34ndFZL6Q
	zY4Dy4l8Fb4Lx0BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781009573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjVs4XMojEDCZDsneHUjmf+6PVevcMqyxX1dX7ene70=;
	b=E5p0l2vRyc4Aamw3PZVZDZMxitZ+J7/tHa+G1PsNtT4tWBTSHyIZCAYADXfyKQCnMwK03J
	h8XcA7s62eeQCNGURjfIwiravYlhf86bEQXB5WrkyUH4OwlVX4yVrEqx7FsIM4gRbNhcqK
	WnJE/cldEn/uoMKXeqGksCk3xFgWSEQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781009573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjVs4XMojEDCZDsneHUjmf+6PVevcMqyxX1dX7ene70=;
	b=/qcl9yXQ05C4n3FIWYXNaPy9IIWptYcXNBNYxuZveZpo7H0K5Tpb6S0sZjVPVtKsdgnSXH
	iHdeyBLUvHfYc1BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5FF84779A7;
	Tue,  9 Jun 2026 12:52:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DaBnF6UMKGoQcAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Jun 2026 12:52:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 08919A0A90; Tue, 09 Jun 2026 14:52:53 +0200 (CEST)
Date: Tue, 9 Jun 2026 14:52:52 +0200
From: Jan Kara <jack@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, 
	hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com, 
	linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org, 
	shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in
 memcg slab shrink
Message-ID: <5exadtggg276xp5tayiqbbomnms4hjyaopmgu3chfpl2ug56dq@vyhswy2afzmo>
References: <20260609123047.1948242-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609123047.1948242-1-usama.arif@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: y9kgonmjhoano8x6una7985bou916ty6
X-Rspamd-Queue-Id: E0F06C0015
X-HE-Tag: 1781009578-97443
X-HE-Meta: U2FsdGVkX18xlu2vIxt2Y0Jxv/PFa44PeLuNJKWR/ipLk0j/6KdUZiRwx6EajI1STKVbDmnP9MkBF72TAO1JhnUfyN1xMW62oYH90sChKeTx6qfTDJEvm1dZtJtBgsYJNjKSlzu5PW3eJgMVWqB4ruMm/KyduOi1kLgLd7Ql4MZfwLF19bzrQuMS3tIGfncENowZsUmhqj8S1KadfkyfBM+llrtN11eSNvOudur7iAJloszrduPA7gtIngBBRFmeI9IPDIxLycCEt/GaemaT+ny9jsdu/d6aYd5v+BCTSOGuxFynraF/EmQtI69Xr1oe/fWwZ+J0QTxSI59/rEbJ4phGjcKh5IfltveTeS2nIOz5jS7lZNe4Iz/9PL8Sb0wk11TT3Hx34U0LmY91ycGuikwcJ6UZpV83tuuTAgQJ1Kjrcfb5LJJLmcmohXKfkQ4pZrey7mYpvd/H6Fee+fH3piXHBzlOByhJ6Cg8rOHndWqxXAdpgwPJpAQKGpcws9Nk53X4w1FXB55lYvBGtm235/EzqFs7AfDhhm9pkJBgFxyIDNHGf8/uPdxoCZk73DZNHm6TZtJIdzMQI9hPWIGZzdLRMqFWksFtaS/OpTjSrRJGttU4HkDDUvjalSX+92YV3DpStrMCTWk+uYKQDXwcz4jyWn4D2vXqd5GYG1gotWspSTsijSxmbZ2KNohUVV63axc+humaYrArxwnV5S2YuBG8RJRcwSgmzwFIYcDxrh08glMQfkWFQFlre2AmAVaenjz7wH9ipgVaLkSXNVxAl08tEoVEdUXRrxuf5EdWNaMDo8Yt1swrpJhKQ+hDecRLiNkSNin17Z61doV0h8WV8xQkLmWo2qfHp+beLRfWW5sR0eH3r7zu/fQCFYxioFrcs8i34FNnyajNF9eqQXtbrRCbTDkVXICYnZVn7vWMmWndkYIh4COQdddrXUBnXpPBMspAIki3g5CWNGS/WFF
 MvkKIOcF
 tOY7Hcxwoq5j4jI56UYPq/OAolOauefJnu147fjDNx5SB1iv5PN+Q+QfIhqv+EYhAmEqEsSt0OrBQ7M2744HIIz4s8WQDuazfDMgSx8b80iL1FMe0BpvZfpNRWzwMqanRyZ0sbd48fqKQ460PEJj+BRYmSTvV8A/pzSlu8Zvrn8XJsUzTvp7i+Tlbm1gZXVwAI6SRSOr5TMbgh5mZlLD8+mRI8NHClA//urIrMNw0bD+kGscvd3MZovFZAcsTiwc6KAKjIJgaHZDmhTaKE64ZadyYDmKat86MnJx1cAkpyoYZz5raMlnr5xog3MZ/g12pFKi5Ih7kd/UBg9fnYWErkfXX0ngUYtD7O5sMXiIQ98wVcvoPKfjNVxTTOBstwWhJBd3zIS+J3A84Yk5Gbc+TbhGBwznwIZT+tgYY+kM/yDFjilY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 09-06-26 05:30:47, Usama Arif wrote:
> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
> btrfs extent maps and xfs inode reclaim operate on filesystem-global
> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
> None of them filter by sc->memcg.
> 
> The mismatch shows up under memcg-heavy slab reclaim. shrink_slab_memcg()
> calls do_shrink_slab() once per (memcg, NUMA node) pair for every memcg
> whose bit is set in the per-superblock shrinker bitmap, which on a busy
> host means hundreds of calls per reclaim pass. Each scan queues the same
> global shrinker work item that's already kicked from the root path.
> 
> Because btrfs/xfs global count is typically non-zero on any in-use filesystem,
> the returned total stays positive even if a memcg's own dentry/inode LRUs
> are empty. shrink_slab_memcg() therefore never clears the SB shrinker bit
> in the memcg bitmap, so subsequent reclaim passes from the same memcg
> re-enter super_cache_count() and pay for the global counter walk again.
> 
> Restrict ->nr_cached_objects() to the global shrink path (sc->memcg NULL
> or root). The memcg-aware dentry/inode LRUs keep being counted and
> scanned per memcg as before; only the global fs-specific hooks are skipped.
> The root/global shrink path still drives those hooks; only their
> invocation from non-root memcg slab reclaim is removed.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

To me this makes sense. However I'm bit surprised that XFS inode shrinker
(which is what gets counted in nr_cached_objects for XFS) isn't memcg
aware. I guess since these inodes are on their way to a relatively quick
destruction, nobody really bothered. So I'm fine with the change, just
I'd like to make sure XFS folks are aware and don't plan anything in this
area.

								Honza

> ---
>  fs/super.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 378e81efe643..5216c5dbd4c4 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -24,6 +24,7 @@
>  #include <linux/export.h>
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
> +#include <linux/memcontrol.h>
>  #include <linux/mount.h>
>  #include <linux/security.h>
>  #include <linux/writeback.h>		/* for the emergency remount stuff */
> @@ -169,6 +170,19 @@ static void super_wake(struct super_block *sb, unsigned int flag)
>  	wake_up_var(&sb->s_flags);
>  }
>  
> +/*
> + * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
> + * operate on filesystem-global state and ignore sc->memcg. Driving them
> + * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
> + * per-cpu counters and queueing duplicate work: the actual reclaim happens on
> + * the global path (kswapd or root direct reclaim) regardless. Restrict them
> + * to that path.
> + */
> +static inline bool super_fs_objects_eligible(struct shrink_control *sc)
> +{
> +	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
> +}
> +
>  /*
>   * One thing we have to be careful of with a per-sb shrinker is that we don't
>   * drop the last active reference to the superblock from within the shrinker.
> @@ -198,7 +212,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
>  	if (!super_trylock_shared(sb))
>  		return SHRINK_STOP;
>  
> -	if (sb->s_op->nr_cached_objects)
> +	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
>  		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
>  	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
> @@ -259,7 +273,8 @@ static unsigned long super_cache_count(struct shrinker *shrink,
>  		return 0;
>  	smp_rmb();
>  
> -	if (sb->s_op && sb->s_op->nr_cached_objects)
> +	if (sb->s_op && sb->s_op->nr_cached_objects &&
> +	    super_fs_objects_eligible(sc))
>  		total_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
>  	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

