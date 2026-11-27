Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 873FB606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=LvrUk5/D
Received: by kanga.kvack.org (Postfix)
	id 331A56B05C2; Fri, 27 Nov 2026 04:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E1BB6B05C5; Fri, 27 Nov 2026 04:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1B66B05D5; Fri, 27 Nov 2026 04:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87FF76B05C2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:25:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F6C71C2C49
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:25:33 +0000 (UTC)
X-FDA: 85480366146.16.7EACB05
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7E1471A000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:25:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="LvrUk5/D";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795771531;
	b=Baw91qXZRPqvWl+xubk5JPui5iXJ/JzEwRXsgCHlMIIf0FuGnf5Wb/Rhqxds1p2Ye085wb
	Jyu+ec5W0K5RHjRZcsQYhZ8KQmolKIYbKHgPhaCkaPl1r9DOsM/x+BiGilHMnsp/Xo7XhT
	PMdKkIRpbfL5EYbymhEuoNH5FTF71Mk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795771531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkg78SVa1VvZWM1qpB5F09DE1jX0V7/77oNZYtMWp3Q=;
	b=7EaSc4ZBxAKQWDFaTG8xX6x3aJnD66kE3rXho23iwqM0w5AflQsyEA1WdbS0104KhZEeAy
	8M199Ud6r0jr+tvrxyGewbzIfTl1mpa4kNKggBetchRnFdX93LPJkjDG4CF6lYEQUMoLuP
	q1lgwtIwofi0gW9/CzjC0+i0ZBt7yyM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="LvrUk5/D";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-490d59c3edaso5340891f8f.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795771530; x=1796376330; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lkg78SVa1VvZWM1qpB5F09DE1jX0V7/77oNZYtMWp3Q=;
        b=LvrUk5/DpRP9ufBTN4M25PsruztCssgZ03FDPEsgtEoLXxVbnek7EO7Ygkm4gnKH0L
         gqWfTF9kPCsc5GQqoKg6h9PS7B+ilRX5eBSwJQTp0tu0IjktsN4R+whj3uDl+u+vp04u
         PFOOMjxA4vWLqiVkp6Z+zCRP8NgotEPrUHQqrA18Boije2pDjFht8AizHUQK/+4Jci1H
         Ct/uJxfrAMCeY1zDw9figavg+GskHyHbBgGChNnZxg+LQIiC+izKZ6ZJdBQ1ci4zyJzK
         gwvwBkskp6MLmysDSWeGPrZrTVt9a2n/UxPWse0Lg9badKoaJx8qWVZDq2pr4k0Qz6Yc
         TuZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795771530; x=1796376330;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lkg78SVa1VvZWM1qpB5F09DE1jX0V7/77oNZYtMWp3Q=;
        b=1xmt9Yv4yi9tqU/zz8f9DCn54QIQt/meXirk3H0CcVmcAAfbC2EhwPBwGKKCYbh1DH
         CyEJtqveUFJQHgTkduVMqaOJBlUypHnBjaBhJUeFVWGcLUhHHKsqg1cPDs8BCMqg5v4Z
         H31IrxEg/qByAYV/Xpi3TfcHG/1Xxm2MoGgbKKr6B/cibCwxrKviP99WatwsTdKyB3ru
         nEX4/OgSLJGUThpZLtzyVZVnClmuOlAI7b9dzW5+vRuizkYA80DdBgWMJ5uYsD2pwL+9
         VSIkD9eQW6K8O8fKx1yC2M8O8ElFp8FPtIbRq7FOkEgjRG3rvo204NVBT7ZRCIgSQCAY
         6wnA==
X-Forwarded-Encrypted: i=1; AL+hErEGdv7zS7GBckShUzKmD6TcNLqMXxhnJnpkWAACAISYXw5FIVyqgvqf/8KP/DehA3PAXQHlwNAogQ==@kvack.org
X-Gm-Message-State: APuU4Z9y79eS0F3ZyeWaX54BgAh+gMWCz046U8aeoKWmcLOIcqWCzC4E
	po+7I7JF68YZ4XR+6K9p0FVxCLViZiDZSwSOnkAosfcad+jYo2E4psNeJl4Q9H3KcnU=
X-Gm-Gg: AZFdTZfWATFaLEm/Mg+uAouVu+PDnGunkLMZFErU8bW5z9jORZTeZZoPb8Eeeihd5fm
	QD9BGFctYZAeyBlYmmq1pHCzkRD71TP5RKFPlscBg7MNZ/Y4t2y+jYjqP25QfVonBkU5+7RqHMI
	bB4bmniwBMGocRZU5gAek+WQoxFU7G54LqMyWH3GUtRAHGUCdGSRaf4SKPjCw6zhBCzKWVRFjsx
	uIx8x4lT45ciD39/qT5OQvGhm90drqQazuqhPdpJB4nhEZoa3z2ftEAAZZ3w1plfIFNRfuZjkrg
	RDEAAkydF3JY6iNYFK/KUaKAJW1t1TOCkG+xDa1wogKzEeArj/aNZH5XJhVLLiZBysERrqdB3os
	dLk9XLK5CLnrshn+gPGpO3jXxgZrbLHlwsGRw8HnWijWtu+LfBhwcfIEDC34yQDC74wPZJzMg9r
	VaQ0R50AB2R6Ou4XTnLPYQ+qBQslYkHtoXLALWLk1CszRUyrgfAZEd1p9vpTr/3NiQLjoX1Gges
	cHes49JflrTuLAUNUNpPPqMsYGf5VYmQi1cp5YQvnsa4N4yLWML1M2glAynS3olRXNAhsvV7K2s
	F97dEKwhMafS3RQqirD0n4TtxTPcBn9bAxiw+pv7
X-Received: by 2002:a05:6000:2382:b0:4a7:1fca:e537 with SMTP id ffacd0b85a97d-4abb0886cbamr47878406f8f.9.1795771529952;
        Fri, 27 Nov 2026 01:25:29 -0800 (PST)
Received: from localhost (109-81-21-11.rct.o2.cz. [109.81.21.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6c4353d6sm44226033f8f.56.2026.11.27.01.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:25:29 -0800 (PST)
Date: Fri, 27 Nov 2026 10:25:28 +0100
From: Michal Hocko <mhocko@suse.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Greg Thelen <gthelen@google.com>, Greg KH <greg@kroah.com>,
	Ming Lei <tom.leiming@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock
 against filesystem freeze
Message-ID: <awlMiOQjOyTH3hQR@tiehlicka>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
X-Stat-Signature: anpoyi9weiz1871g6rtxpnwahqdoqcdy
X-Rspamd-Queue-Id: 7E1471A000A
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795771531-595319
X-HE-Meta: U2FsdGVkX19HL9xN5SBKtfmN91e3eBdR/9k5oNyIxyNdTO4Oy9Y+at85dWy/5yzQcN5ePp63mr0nCZu079p9f1C+vAIlFV7WdNgKalSWmTB7uTyJTIhDBDbKBGeqrLyKDfGL/WB86o/tVkT2ZKGzLLWnddZS3Kj+R6D4gs5XLMEp0iT650dWyo7qd9aAKfuZLoXO67iiCFzdIN1ilS8VwH3jts+ot3hJbgZALj9mrsq635Q2IlQLP1jOeBw4CXiMnYaWyvnQ9HRvzUCaXqwR0f1U9oN4zK8OWHfUEG80qyvYRbExJ4jJkJ7A9/9Rhu4+uOR0XY/FFmTG0gA6cnM8NOblfV+O6xjEcneKqLgSQKzs/AC97JSIFYcAWe1m/dDfBQpL21aP2zXc1ez5FBJOFFWzZRIaev8ktW2rtxEaX70SdjQ9mfRJogRrMQVQbG8PKggRPs8MnYUD3ajTRhk4jCeoqUlTeTc3XAlJb7BiRArp20NH/UWnisJUpp8fiCO9zGAs9j+vR1wSF3erpMFCyi52QD5kEh2HnZBroKVFzIS6gYarJ4sM1/YkLhksEOh7OTuiJNPsdKXEWNpX+R5z/VWU+lYo9b6P4hjTZ9dwpeQFN6S/+KmuZUr0fS9ZbpgG1Le0HD8jdYthMyfYtoez0sSR26yBzIFxleB2XoC8tgWQnuEqAQqlq76dIbAd/tFZp6VMucAC4cPrdrS3oe/H+ken5ssqpFEYATKkVwRyDJ11+cCgX6N86Mx/FZzNhpKrGqsxJZuY8e7MuWBYKiMvjMH9Lty0IjRpXunYjJQ3mxYvjea7HK2ibhtLrRHTjhs+j0+4uyoB8Lz9xUrTDgHBlHnQB9PhryGbG4iqbdV5lARFbUiIn8mrhfmKVTAgg0TUfdkAFUOS+xt1difym4F9fvY7QFln4lEJn0nKQiF8NPrzGKXrvdW/NA5h5ugGqQN7BqsufIunO45GEJNBMeI
 nXmtp8w9
 6GOwbuWDK+g9peqJmRbYsII/01B7ZYQs6Z3btrKgRYOuKXL/rlblCUCkJnqQOAcmsnvvRLNaakh/PcsVHNQCp50XkCohWGxw8/JXZpR6PpZXaFfaZg5E5TRXkVlhPDf2H9eR6/cLwDcfXP00EFiOXcP4fLFmU28d1XfLg/aa32aZYveJPxX/kGbdrLq+8cNs+5yNXAYLlxR+hsIXV6F4psbF7CRO7Sy74Nt/U4fgsvKFKZSOg9Z7IPwi7lgPZ55llrrNIqZnCguajaVhvyC8fHhqNnDu396VRyXGHybiH6Bizv2ByKt65WUeH/tTcihrfSta0lnRilhomofBcG0r93WgZ9C5f9p75D65QXzGHRFDGFsFyKQmHsCLs7BIdi64S6f4y/A/5eZ0jE7JHS8hqqo8px8vlpd7W5eUq1/DMKFIFU4Pi4ejlm0kVbdkdPSS6RUhVuDIqJAbagm1m9QkbghO5wkeW+lgAkyTApKCRA6iq5Zv2upkCxd5rpR7fWHo8FBXvY4+E2exDagaGnhp4Jmv8cuSHmwaDt4hLa2pChmd050Dzm/yhglS00gAIluejpja5u2G5G2Ta4ll0WA5dhB3B0yKRc3pncCcrFgGcWNFeqmDg1psHJdUOmW5CkTmMjubmrFtvN54Ocn3IwXORCqT+usrt5QWWkepKrmcS04w0zLTS91W16C3kxxnv4BsX9DbZNmQ4yUCN/AVE99Dh3F2A+yzSc78cFjYUZxBooz5uYJzld6yrn0Bl/KhpfBRes/+cAmfBtJ2vnTbVZ272VxdPZdnyx12x/7X9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 26-11-26 02:08:56, Tejun Heo wrote:
> Legacy memcg reclaim has no dirty throttling, and shrink_folio_list() waits
> for a folio that is under writeback and already marked for reclaim (case 3
> in its comment). That wait can deadlock against a filesystem freeze:
> 
> 1. A task in write() to filesystem B holds freeze protection on B, enters
>    memcg reclaim and waits for writeback of a folio of a filesystem on a
>    loop device backed by a file on B.
> 
> 2. A freeze of B waits for the task to drop its freeze protection.
> 
> 3. The loop worker has to take freeze protection on B to write the folio out
>    and blocks behind the freeze.
> 
> The same applies to any driver that writes to a file on a local filesystem
> to serve block I/O and takes freeze protection for it.
> 
> Reclaim can't tell which filesystem a writeback depends on. Count the
> superblocks that are being frozen and make the wait time out after 15
> seconds. If one is being frozen at that point, warn and give up. Until none
> is, treat such folios like case 2 and skip the legacy writeback throttle, so
> that the task a freeze may be waiting for isn't held up.
> 
> This trades the deadlock for premature memcg OOM kills during such a freeze.
> The wait also no longer hits the folio_wait_writeback tracepoint, and the
> hung task detector no longer reports a task stuck in it for another reason
> as the task wakes up every 15 seconds.
> 
> Fixes: e62e384e9da8 ("memcg: prevent OOM with too many dirty pages")
> Reported-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
> This was first posted in a private thread and is resent here for the lists,
> rebased onto the current mainline. The only other change is the added
> Reviewed-by tags.
> 
> This is on top of v7.4-rc4-388 (25faec9ce61c). In a test with a filesystem
> on a loop device backed by a file on another filesystem, writers to both in
> a v1 memcg and the backing filesystem frozen and thawed in a loop, the
> unpatched kernel deadlocks within seconds. With the patch, a stuck freeze
> gets through in 15 to 18 seconds.
> 
>  fs/super.c               |    7 +++++
>  include/linux/fs/super.h |    1 
>  mm/filemap.c             |   22 +++++++++++++++--
>  mm/internal.h            |    1 
>  mm/vmscan.c              |   58 ++++++++++++++++++++++++++++++++++++++++++++---
>  5 files changed, 83 insertions(+), 6 deletions(-)
> 
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -48,6 +48,9 @@ static int thaw_super_locked(struct supe
>  static LIST_HEAD(super_blocks);
>  static DEFINE_SPINLOCK(sb_lock);
>  
> +/* nr of superblocks that freeze_super() is in the middle of freezing */
> +atomic_t sb_nr_freezing;
> +
>  static char *sb_writers_name[SB_FREEZE_LEVELS] = {
>  	"sb_writers",
>  	"sb_pagefaults",
> @@ -2235,6 +2238,7 @@ retry:
>  		return 0;
>  	}
>  
> +	atomic_inc(&sb_nr_freezing);
>  	sb->s_writers.frozen = SB_FREEZE_WRITE;
>  	/* Release s_umount to preserve sb_start_write -> s_umount ordering */
>  	super_unlock_excl(sb);
> @@ -2249,6 +2253,7 @@ retry:
>  	ret = sync_filesystem(sb);
>  	if (ret) {
>  		sb->s_writers.frozen = SB_UNFROZEN;
> +		atomic_dec(&sb_nr_freezing);
>  		sb_freeze_unlock(sb, SB_FREEZE_PAGEFAULT);
>  		wake_up_var(&sb->s_writers.frozen);
>  		deactivate_locked_super(sb);
> @@ -2265,6 +2270,7 @@ retry:
>  			printk(KERN_ERR
>  				"VFS:Filesystem freeze failed\n");
>  			sb->s_writers.frozen = SB_UNFROZEN;
> +			atomic_dec(&sb_nr_freezing);
>  			sb_freeze_unlock(sb, SB_FREEZE_FS);
>  			wake_up_var(&sb->s_writers.frozen);
>  			deactivate_locked_super(sb);
> @@ -2278,6 +2284,7 @@ retry:
>  	WARN_ON_ONCE(freeze_inc(sb, who) > 1);
>  	sb->s_writers.freeze_owner = freeze_owner;
>  	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
> +	atomic_dec(&sb_nr_freezing);
>  	wake_up_var(&sb->s_writers.frozen);
>  	lockdep_sb_freeze_release(sb);
>  	super_unlock_excl(sb);
> --- a/include/linux/fs/super.h
> +++ b/include/linux/fs/super.h
> @@ -234,6 +234,7 @@ int freeze_super(struct super_block *sup
>  		 const void *freeze_owner);
>  int thaw_super(struct super_block *super, enum freeze_holder who,
>  	       const void *freeze_owner);
> +extern atomic_t sb_nr_freezing;
>  
>  int sb_init_dio_done_wq(struct super_block *sb);
>  
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1245,8 +1245,8 @@ static inline bool folio_trylock_flag(st
>  	return true;
>  }
>  
> -static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
> -		int state, enum behavior behavior)
> +static inline int folio_wait_bit_common_timeout(struct folio *folio, int bit_nr, int state,
> +		enum behavior behavior, long timeout)
>  {
>  	wait_queue_head_t *q = folio_waitqueue(folio);
>  	int unfairness = sysctl_page_lock_unfairness;
> @@ -1324,7 +1324,9 @@ repeat:
>  			if (signal_pending_state(state, current))
>  				break;
>  
> -			io_schedule();
> +			timeout = io_schedule_timeout(timeout);
> +			if (!timeout)
> +				break;
>  			continue;
>  		}
>  
> @@ -1393,6 +1395,13 @@ repeat:
>  	return wait->flags & WQ_FLAG_WOKEN ? 0 : -EINTR;
>  }
>  
> +static inline int folio_wait_bit_common(struct folio *folio, int bit_nr, int state,
> +		enum behavior behavior)
> +{
> +	return folio_wait_bit_common_timeout(folio, bit_nr, state, behavior,
> +					     MAX_SCHEDULE_TIMEOUT);
> +}
> +
>  #ifdef CONFIG_MIGRATION
>  /**
>   * softleaf_entry_wait_on_locked - Wait for a migration entry or
> @@ -1490,6 +1499,13 @@ int folio_wait_bit_killable(struct folio
>  }
>  EXPORT_SYMBOL(folio_wait_bit_killable);
>  
> +/* wait up to @timeout jiffies for @bit_nr to clear, true if it cleared */
> +bool folio_wait_bit_timeout(struct folio *folio, int bit_nr, long timeout)
> +{
> +	return !folio_wait_bit_common_timeout(folio, bit_nr, TASK_UNINTERRUPTIBLE, SHARED,
> +					      timeout);
> +}
> +
>  /**
>   * folio_put_wait_locked - Drop a reference and wait for it to be unlocked
>   * @folio: The folio to wait for.
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1276,6 +1276,7 @@ struct migration_target_control {
>   */
>  ssize_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
>  			       struct folio *folio, loff_t fpos, size_t size);
> +bool folio_wait_bit_timeout(struct folio *folio, int bit_nr, long timeout);
>  
>  static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
>  {
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1157,6 +1157,55 @@ static bool may_enter_fs(struct folio *f
>  }
>  
>  /*
> + * Legacy memcg reclaim has no dirty throttling and waits for writeback in
> + * shrink_folio_list() instead. That wait can deadlock against a filesystem
> + * freeze:
> + *
> + * 1. A task holds freeze protection on filesystem B, e.g. in write(), enters
> + *    reclaim and waits for writeback of a folio whose I/O ends up as a write to
> + *    B, e.g. through a loop device backed by a file on B.
> + *
> + * 2. A freeze of B waits for the task to drop its freeze protection.
> + *
> + * 3. The write to B waits for the freeze.
> + *
> + * Reclaim can't tell which filesystem a writeback depends on. As a crude
> + * workaround, memcg_wait_writeback() times out and, if any filesystem is being
> + * frozen at that point, sets memcg_wb_wait_skip. While it is set, legacy memcg
> + * reclaim neither waits for nor throttles on writeback, so that the task a
> + * freeze may be waiting for isn't held up in reclaim and can drop its freeze
> + * protection. This can cause premature memcg OOM kills.
> + */
> +static bool memcg_wb_wait_skip;
> +
> +/*
> + * Test memcg_wb_wait_skip. It takes effect only while a filesystem is being
> + * frozen and is cleared here once none is. A freeze that starts before it is
> + * cleared inherits the skip.
> + */
> +static bool memcg_skip_wb_wait(void)
> +{
> +	if (!READ_ONCE(memcg_wb_wait_skip))
> +		return false;
> +	if (atomic_read(&sb_nr_freezing))
> +		return true;
> +	WRITE_ONCE(memcg_wb_wait_skip, false);
> +	return false;
> +}
> +
> +/* wait for writeback of @folio, see memcg_wb_wait_skip for the timeout */
> +static void memcg_wait_writeback(struct folio *folio)
> +{
> +	while (!folio_wait_bit_timeout(folio, PG_writeback, 15 * HZ)) {
> +		if (atomic_read(&sb_nr_freezing)) {
> +			WRITE_ONCE(memcg_wb_wait_skip, true);
> +			pr_warn("memcg1 writeback wait timed out during fs freeze, skipping waits, may OOM early\n");
> +			return;
> +		}
> +	}
> +}
> +
> +/*
>   * shrink_folio_list() returns the number of reclaimed pages
>   */
>  static unsigned int shrink_folio_list(struct list_head *folio_list,
> @@ -1277,7 +1326,9 @@ retry:
>  		 *    reclaim flag set. memcg does not have any dirty folio
>  		 *    throttling so we could easily OOM just because too many
>  		 *    folios are in writeback and there is nothing else to
> -		 *    reclaim. Wait for the writeback to complete.
> +		 *    reclaim. Wait for the writeback to complete. If
> +		 *    memcg_wait_writeback() gives up, such folios are treated
> +		 *    as in case 2 until no filesystem is being frozen.
>  		 *
>  		 * In cases 1) and 2) we activate the folios to get them out of
>  		 * the way while we continue scanning for clean folios on the
> @@ -1300,6 +1351,7 @@ retry:
>  
>  			/* Case 2 above */
>  			} else if (writeback_throttling_sane(sc) ||
> +			    memcg_skip_wb_wait() ||
>  			    !folio_test_reclaim(folio) ||
>  			    !may_enter_fs(folio, sc->gfp_mask) ||
>  			    (mapping &&
> @@ -1325,7 +1377,7 @@ retry:
>  			/* Case 3 above */
>  			} else {
>  				folio_unlock(folio);
> -				folio_wait_writeback(folio);
> +				memcg_wait_writeback(folio);
>  				/* then go back and try same folio again */
>  				list_add_tail(&folio->lru, folio_list);
>  				continue;
> @@ -2086,7 +2138,7 @@ static void handle_reclaim_writeback(uns
>  		 * enough for cgroupv1 writeback throttling to work
>  		 * on a large system.
>  		 */
> -		if (!writeback_throttling_sane(sc))
> +		if (!writeback_throttling_sane(sc) && !memcg_skip_wb_wait())
>  			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
>  	}
>  

-- 
Michal Hocko
SUSE Labs

