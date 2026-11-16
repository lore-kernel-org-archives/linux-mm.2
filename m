Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CB7606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=JAx15jQz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6yuKD6uR;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=JAx15jQz;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6yuKD6uR
Received: by kanga.kvack.org (Postfix)
	id A32636B05BD; Mon, 16 Nov 2026 05:48:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2AB6B05BE; Mon, 16 Nov 2026 05:48:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D4606B05BF; Mon, 16 Nov 2026 05:48:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 660D36B05BD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:48:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDA74C0937
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:48:36 +0000 (UTC)
X-FDA: 85440658632.04.1B15706
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 779A4C0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:48:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JAx15jQz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6yuKD6uR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JAx15jQz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6yuKD6uR;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794826113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WdV7LfPZ4msOsP2SDeAiTLmjSH9L5rSuovDgUpDr7/o=;
	b=Bt/aVWBPBDMhGBY/3BMwW0DyMrbocyhLj98UuN+ggCfgZxb43i8jWRKsExjaTF3Ev8i+qO
	VZy3c9WnWRb33SUhQmQu3ZBnVeKju5r7ouwghguRDScrnij6oC2BM1hdBmHKpd8UmwAUMJ
	hv9yIS0ZVZJnTl1Gju5IS0DHTpkguhY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JAx15jQz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6yuKD6uR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JAx15jQz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6yuKD6uR;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794826113;
	b=7hm5O+Z4QcPZrTCULaBrlNHYxTiYaEoGyPrOBJT0SlwHKl3ekpvboLtpPrL9po+/YKkjVh
	eIk6yROlVKqAGqufo0W327pQp5JzVPNy00W3Lx5vBlz8kmIe7iFfoZo5O8AyOTFYrYcnlW
	2DY4vxtli11bhWf9giGF+WQmT79lUM4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4030822290;
	Mon, 16 Nov 2026 10:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794826112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WdV7LfPZ4msOsP2SDeAiTLmjSH9L5rSuovDgUpDr7/o=;
	b=JAx15jQzTftUEsIrFEpxbzwWMXmveAo8iHij/8uzgxS3WDfPaepPH8Vik/C1LrWoQEph/+
	iZsdaCrGUdMc6Rpgdo7n5W7StPbBOdfDrcKVBoWc63lMEBDp26q9AuXaO9JZ4VrDMYurnI
	Gnqv9JORJnHmfzlQccTlxqpQkU9lUr8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794826112;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WdV7LfPZ4msOsP2SDeAiTLmjSH9L5rSuovDgUpDr7/o=;
	b=6yuKD6uR7WQGQOIBvWjEYpVyQsgPsprYCksV1USMJ2Wrhf53d7sHLjz0lYIP7VomQjEarb
	1tiIDVnYmORGbaCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794826112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WdV7LfPZ4msOsP2SDeAiTLmjSH9L5rSuovDgUpDr7/o=;
	b=JAx15jQzTftUEsIrFEpxbzwWMXmveAo8iHij/8uzgxS3WDfPaepPH8Vik/C1LrWoQEph/+
	iZsdaCrGUdMc6Rpgdo7n5W7StPbBOdfDrcKVBoWc63lMEBDp26q9AuXaO9JZ4VrDMYurnI
	Gnqv9JORJnHmfzlQccTlxqpQkU9lUr8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794826112;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WdV7LfPZ4msOsP2SDeAiTLmjSH9L5rSuovDgUpDr7/o=;
	b=6yuKD6uR7WQGQOIBvWjEYpVyQsgPsprYCksV1USMJ2Wrhf53d7sHLjz0lYIP7VomQjEarb
	1tiIDVnYmORGbaCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 13A2D1334C;
	Mon, 16 Nov 2026 10:48:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ryFUOH/f+moMewAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Nov 2026 10:48:32 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id B066624DA6; Mon, 16 Nov 2026 11:48:31 +0100 (CET)
Date: Mon, 16 Nov 2026 11:48:31 +0100
From: Jan Kara <jack@suse.cz>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, Christian Brauner <brauner@kernel.org>, 
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH v12 3/7] mm: expose WB_DONTCACHE_DIRTY in bdi debugfs
 stats
Message-ID: <6npuytxjyfa75iypcnwvu4ayu3puysipkqjyrtssng4cieibue@sdkb62hjosuq>
References: <20261112190911.84702-1-snitzer@kernel.org>
 <20261112190911.84702-4-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112190911.84702-4-snitzer@kernel.org>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 779A4C0004
X-Stat-Signature: wahrswya134rf8hgirh54zyw8ockeqji
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794826113-291078
X-HE-Meta: U2FsdGVkX1+TVcSaUzGJkF65n0uaqhqvjyIsDk7aBIlgV+MFm5MekE4TfD3hKIfbzoqhRoeBoh5w7RSkXwga+zX2Zrcd0HzEhxEdbvfpdXEd2PJiUzr+MYsyiHVYo4u6XVRRXsFyo/M0Nep15dsPvCN4bChERz6XXejh4Sdp6VeYw2IVHqQjyT/Al4ZmpnsufhtymtNnPTlHfzaulLTyxda3zpd01wT3SvxqIvOhLfe0+pVAsNi0cp6S8sTdmZxy6WXL7ydOrYkbF6oTS5icSgRxCft+6l1fmwoXXnK6DLR3UbswlEpFVNtEN0CdAoLIXW4hVNMY5rfBkvAIdDaT+aLpMeNsfJf19HO43Ur2rOu4Oi40qjqdt5Nbi06qB/ZXVpUyPzvKu9MKp/PYYqbdksD1N5ZXARy/lDK6GMPlLt/Ajkl1VQ+FlLKQfLWIOPghUWNdIokZbqJQ4hko/kfnJIZjszaC/jWkH9hs31EzqXdi+1CJv9FjuTNqEyftppo8Qk0cv5vAXMFCFI9+uf3aA6hrccN2NeSPqchwAmakvNqALI8dKr5eV/CUoXz3ch1mgrPVTyGUghTXJQoezcSlH+vcVaiHeL6Vom+ihuoImutOJMdAgb0uFcj8SeU9R97pGpPskDJWsdnJCkkgiAHhJdiv17ToMcCRO5VrIQWqXmiVN/6r734vOzlwPFpAqRnwnaxBHSr0vnPf6d7gGBUq8IJFA7VuVvVZdU9jVFlw/WA90jQEoCYH8nnGLsUW7dtcPG7UK9VnuCXEeFOV+G26nDnfbM3EXEEBtnRigh7HfmgPlyqboLkY3t+sn5a7Qo9AXC+tRqbBGoHRDyK0kyz45vNPk5Fb2ETn0SQ5okDJxEhwhReDc86ReWHYPIdNoP2fWh8cwt9Lf5pk2VOo+jx8eUmcV4/LLXUOQk43y9M8T+1EZ/1g5Jvr1hxghtHHvxxggPiw02jtZRpE3PZc+rK
 dw+3fhMx
 RbUtkem3C/H67zGAqQ+QzSqzdULcPPQgtcakgUV8AuqnFYWP484IhYncFo0u4sSThRRSAGJfSuuG7CwGx9QZ+zGMxpzpnpCZsZYO3b/25vNOu3RZkFYab0sCxnE+bjzKcWu0PXXCdHZBxMfOeV7e/kOUfDDKsMTjy5Si+zGxKHkZrlp/7g8HqcFxFYhZMKhwumAnqPAEem1RSt3esqMSWqJH8KUytVQ096ddnbHPylttk+onR+ivxIr4NZW8rONHJFV6AHxUArXU4v+kekLGQI9bj5K6BJc161K2VD7RAGAgrjJL/URxHKiChwVQygudD9rUIafxC369TU3Wtr0YZKRInOtlPAFk90i0+pW/7uhwtWB7dLN9eyurJFYhvOe+s1AnRJ4FmU/qCCWfzCJZ/Nx7QlceeNjdlcWL2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 12-11-26 14:09:06, Mike Snitzer wrote:
> The per-bdi_writeback WB_DONTCACHE_DIRTY counter drives how much the
> flusher writes back in response to an IOCB_DONTCACHE kick, but it is
> not reported anywhere, so the DONTCACHE dirty backlog can only be
> inferred from MemFree/Cached movement.
> 
> Report it as BdiDontcacheDirty in /sys/kernel/debug/bdi/<dev>/stats
> and as WbDontcacheDirty in the per-wb stats, next to the
> Reclaimable line.  Use wb_stat_sum() rather than wb_stat() to fold in
> the per-cpu batches: the flusher targets the summed value and small
> backlogs would otherwise read as zero.
> 
> Fixes: 88d6f128d06d ("mm: track DONTCACHE dirty pages per bdi_writeback")
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/backing-dev.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index fad1495d3b200..a09c21759fb9f 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -46,6 +46,7 @@ struct wb_stats {
>  	unsigned long nr_dirty_time;
>  	unsigned long nr_writeback;
>  	unsigned long nr_reclaimable;
> +	unsigned long nr_dontcache_dirty;
>  	unsigned long nr_dirtied;
>  	unsigned long nr_written;
>  	unsigned long dirty_thresh;
> @@ -78,6 +79,7 @@ static void collect_wb_stats(struct wb_stats *stats,
>  
>  	stats->nr_writeback += wb_stat(wb, WB_WRITEBACK);
>  	stats->nr_reclaimable += wb_stat(wb, WB_RECLAIMABLE);
> +	stats->nr_dontcache_dirty += wb_stat_sum(wb, WB_DONTCACHE_DIRTY);
>  	stats->nr_dirtied += wb_stat(wb, WB_DIRTIED);
>  	stats->nr_written += wb_stat(wb, WB_WRITTEN);
>  	stats->wb_thresh += wb_calc_thresh(wb, stats->dirty_thresh);
> @@ -125,6 +127,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
>  	seq_printf(m,
>  		   "BdiWriteback:       %10lu kB\n"
>  		   "BdiReclaimable:     %10lu kB\n"
> +		   "BdiDontcacheDirty:  %10lu kB\n"
>  		   "BdiDirtyThresh:     %10lu kB\n"
>  		   "DirtyThresh:        %10lu kB\n"
>  		   "BackgroundThresh:   %10lu kB\n"
> @@ -139,6 +142,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
>  		   "state:              %10lx\n",
>  		   K(stats.nr_writeback),
>  		   K(stats.nr_reclaimable),
> +		   K(stats.nr_dontcache_dirty),
>  		   K(stats.wb_thresh),
>  		   K(dirty_thresh),
>  		   K(background_thresh),
> @@ -163,6 +167,7 @@ static void wb_stats_show(struct seq_file *m, struct bdi_writeback *wb,
>  		   "WbCgIno:           %10lu\n"
>  		   "WbWriteback:       %10lu kB\n"
>  		   "WbReclaimable:     %10lu kB\n"
> +		   "WbDontcacheDirty:  %10lu kB\n"
>  		   "WbDirtyThresh:     %10lu kB\n"
>  		   "WbDirtied:         %10lu kB\n"
>  		   "WbWritten:         %10lu kB\n"
> @@ -179,6 +184,7 @@ static void wb_stats_show(struct seq_file *m, struct bdi_writeback *wb,
>  #endif
>  		   K(stats->nr_writeback),
>  		   K(stats->nr_reclaimable),
> +		   K(stats->nr_dontcache_dirty),
>  		   K(stats->wb_thresh),
>  		   K(stats->nr_dirtied),
>  		   K(stats->nr_written),
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

