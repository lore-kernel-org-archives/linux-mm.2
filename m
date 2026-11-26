Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73BC1606A330
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 13:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=CHmbyS7r;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=STsQXCyy;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=CHmbyS7r;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=STsQXCyy
Received: by kanga.kvack.org (Postfix)
	id 97BCC6B05B8; Thu, 26 Nov 2026 08:29:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953696B05B9; Thu, 26 Nov 2026 08:29:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 844796B05BA; Thu, 26 Nov 2026 08:29:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 019816B05B8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:29:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D0051C418E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:29:47 +0000 (UTC)
X-FDA: 85477352814.06.F23385F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 39511A000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:29:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CHmbyS7r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=STsQXCyy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CHmbyS7r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=STsQXCyy;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795699785;
	b=7sNEZzfaQMkaXbE2gYYmyAus39kGN/h4bbsQjnN3I24MrYwPb3Hft+4CEqpyVgMoO/nbDH
	NSHeQ4SbftUWGIyrOC8dW6pDMxIWJ4wP2YFWq9y0KrfC7JS1Ws95hrC/FphIzafCFKYNtv
	XS96H/1qiYC8zsITmcvn4ahgTp8yRDE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795699785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ETYE+9jLVYhPwhx8oW4f7yzkUUYn0BFPEg3N+uQXDg=;
	b=dpHNqg2yhUJEGX2oOY4OfqTGX6tH+JH9cyWKBhyzrTDeSXKDet4s/tiDFYA/knP39UPm+N
	lzT/hfEzjfVky03lvs4dyQuge2RxSuZwM6cOzJXPg2k2zyc9lgTZBYMIXP0S46aafR0wY5
	jWotcWgHCVO21TGKHW7BjLPQbC26hdc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CHmbyS7r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=STsQXCyy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CHmbyS7r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=STsQXCyy;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 832841F82D;
	Thu, 26 Nov 2026 13:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795699783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ETYE+9jLVYhPwhx8oW4f7yzkUUYn0BFPEg3N+uQXDg=;
	b=CHmbyS7rE8D9y6HmMS/dNYUQ9+I6L1l9cZmrUzcYKiQU3JHWp8M0wGxqDzydGfXj0Mldst
	IZMUi3/aW9s/JCTj8X6oe+vV8fowpoJDqdS8FUGCfl9q93wIG0IH6AQiCR+8i8ZdjEp8v4
	CqUk0KbJSMxBtcwg5vLnv863Y/aHZN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795699783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ETYE+9jLVYhPwhx8oW4f7yzkUUYn0BFPEg3N+uQXDg=;
	b=STsQXCyyhppnt+hXynu1+B4O5f6wcSuPJvxY2UcOXafOnKrfh7fE/y4P2qGwyEj4Mt3957
	XP6KkhAVY6ulBaAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795699783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ETYE+9jLVYhPwhx8oW4f7yzkUUYn0BFPEg3N+uQXDg=;
	b=CHmbyS7rE8D9y6HmMS/dNYUQ9+I6L1l9cZmrUzcYKiQU3JHWp8M0wGxqDzydGfXj0Mldst
	IZMUi3/aW9s/JCTj8X6oe+vV8fowpoJDqdS8FUGCfl9q93wIG0IH6AQiCR+8i8ZdjEp8v4
	CqUk0KbJSMxBtcwg5vLnv863Y/aHZN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795699783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ETYE+9jLVYhPwhx8oW4f7yzkUUYn0BFPEg3N+uQXDg=;
	b=STsQXCyyhppnt+hXynu1+B4O5f6wcSuPJvxY2UcOXafOnKrfh7fE/y4P2qGwyEj4Mt3957
	XP6KkhAVY6ulBaAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 578E3134C3;
	Thu, 26 Nov 2026 13:29:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YVL2DEc0CGuWZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Nov 2026 13:29:43 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id DB69D27E29; Thu, 26 Nov 2026 14:29:38 +0100 (CET)
Date: Thu, 26 Nov 2026 14:29:38 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>, 
	Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock
 against filesystem freeze
Message-ID: <chxughsxznjexjhb5sjy7dtzkemkarwt5gogkphhjsggis6mtf@uol26i75zbal>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 39511A000C
X-Rspam-User:
X-Stat-Signature: bkd7bsik7tskhf9dfip3izh8zwc7wpan
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795699785-415027
X-HE-Meta: U2FsdGVkX18Z050LQ19kEzCM+WXByMIeIsrUJDdsgs5hB+46rTQtQSCBY2C7Kcj9PWxNDa/6BBwZRp0c4V6G6/SpNAgBKKtOHC10fEFvDT1jBRGneWzSRyyrzt7JjulmOat9n/UJjVg1e/Ne/y7I6sCCYaZaqQa8qn8IXFLWa5L/nrFUDnUJ3Gqv05mZB0lE8JitMzqLXceLO4HgAXvTMZywQN6FKdILlY8bFIjx5NhPLUqTx/m1AGrvlbEnhdA6kPUXADa0IEALu1LVGnWsyl5lQHdeLmf/yJIRjoppQAZWKkpOPTppxNVBZYf8DrGoCJJhOl7d54SilNhmqgKvIOPT+VGEmAkytFUXkJv8mbu2hKgb3zt/7FnK37MchfVVS8+oK7AC5a66D8gMVHVlpWGwozqsWIorD252oFmDtoEA3/IU44QoiQJwp5nYDo5RHqg6o4o1wTS2VV2OJbPPlK3Q12QGt4rEEghZENODAg3U+/W9BKLPLzAsFx3chY51G0+xrccal+iW2Hop5H7UR9SGe+yhN4hLBtG/d+R2MmNfw3OgPglff8p3GBmKLIAlL3fdTQJ8hdU0Fv6R1s6V7MXaLbV/vWL5zYHt2QNJzcEAa2Dd/12PUR9/8JSpGi7LZ0xKC1D/DAEilJ1DLKqN4i0XGqZfQBKeucz6B2JURJMMEgfXamTPmik/hAbjYoAHmlGdL9wPIMazPZAQwTsW/6ktid3yBoHHgO5DoepIUY55PF1jpJMepsxCLgyX1aBjqMUcwk+8+789EkT1lG2T7qT5tygOEsdwjj5M9Aqx+D70PCrpV0qkWfvM+U9b+Dkr0MkqlEQzI6c2JK5xO1T1TUnJso9NSaCQg4KtraGtjwPyYWTprv0Q+QeYMZR4cF8ueXBZK2tYZBFp6zVALXEI3SgKZvnPEHivnHVl/mfLV6QgYa9noQXf8rSuIP2k4Kmq5w1QiyxNc1P0dr9O7zN
 +lqBSH9u
 3+Yz0cx3YsN9i0reANjkW+HRqMwhsLWdtQyL88IF+/jRm/gMJFBKuUFAwkKHF6zszj7XHUjh9O5YVW4ulpYDezAFnC9C6DXnDmm7DBNBRES4VIt6iQxTMrNe7PwzFFhEYLI69u+0BhKCxEpudnLDsGEU4yfEPvyZsm1WqfzwE8SXK34r0rlpJmLo9+CHNYXjMyFkTesFEhbTODTdwHs8AIRnjEDzngqeYY+BuMrYQ98CnqHg1Zk7/u09mqQPIPLy9x/p6XpU2zs+LiNIsT/+C+oCSUqg67H8I4bmEHtXMr/tlIa0Ag04aYP2VXPfz6sU2SthFNFxcqkTeUYM/nHEmLagHBe3sd0Qd76MCk9p0XMUdatPBCofOuTOJhfsGg+eG2A+WQByo73IQXLSmP/VODBLUCVSpP1EiN9EXfsR3wAC0Vq9bF0tBS5fJV/8n8I2SPpLA3uy2Gypl5oH/QhMO0xef6o+GgzV2SdEfU4FY702eMRTAs5TRm5Glei6eQ2TmyhD8jt+JT1wOlQdwSXmOllZmpFThqs2YTLFsZ0DfAW7QePJDdUpBHEFNEtd3qhF65ET3wXKqzi6xvbC+jFa1H4zhxr4Z9+cyH8E9NKktDl/moEQ4a8u/5McEC4cNFHIOQjNSgp5qi7RHUtQPUcHguIKnClaMOv3uVeNUmVMvwKFqK+I=
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

Yeah, it's ugly but it should fix the deadlock. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

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
Jan Kara <jack@suse.com>
SUSE Labs, CR

