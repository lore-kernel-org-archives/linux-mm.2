Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E7CDCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 12:09:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30EAC6B0095; Wed, 14 Oct 2026 08:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF7E6B008C; Wed, 14 Oct 2026 08:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AEE36B0092; Wed, 14 Oct 2026 08:09:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4AB96B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:09:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D50214025C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:09:55 +0000 (UTC)
X-FDA: 85321113150.08.24BA6E8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 294BD4000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:09:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iQRLg9TI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CVR1B7ho;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PJtvjB0A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O8w4tWkC;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791979793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WVgkZ/vvaM7S8C34FvgRuKF0g6RTv4zFtLpv2Bvz05E=;
	b=WmmnXpQzkej6HXbHZvzcLf9QFH5+lJCkrrTpVna10zs+aoVWbBWE2eZHJcgRbAILeT3Fsz
	JjLpVKjIIIhqp3r14OyrXv7aKdfcSR1Dm+yrbmxKnS0EuSMc4IkpONmSx8CD9ZCFg4jeff
	OrpoP8JoCxtjqZfeOyozXj7m7U/Zvn4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791979793;
	b=MGu4WNMiHrAJ0xj7Lm3R5HXihtEkDJtC3IsZg38qv90caJJ2gviMeElwY9Di8JTBTvFcXn
	V77vrr+q4vCufao5/6+8YTXRpM5FVFkWbv6dj6OJUbKApdw67ctvXqkZ+rljsQn2+v2kuh
	+KGymWJEEhAwx0M0BDIEqrfa0u5TJP0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iQRLg9TI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CVR1B7ho;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PJtvjB0A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O8w4tWkC;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6981A221D9;
	Wed, 14 Oct 2026 12:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791979791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WVgkZ/vvaM7S8C34FvgRuKF0g6RTv4zFtLpv2Bvz05E=;
	b=iQRLg9TI5KfvV6s5JpsBoG8lmaOpqKM9SaPZcmLMreePwZhRTw1n0J06IPaehDuo8w8VUH
	1MM2QX3VfHkCTCmI3VCxaccLUkbiFyGaoDSHkcskcn/uzc5MLXVUS3jNvx4Ok7NMNHnLfZ
	xhg7xc7KF/5qs+I1xlc1qepe1vgxHuw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791979791;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WVgkZ/vvaM7S8C34FvgRuKF0g6RTv4zFtLpv2Bvz05E=;
	b=CVR1B7hocEGhQZ53SQuKvQot9eKYTLYkEdov1kC/ZgJTsdR0K8WhPFrqSarIAnshvd05Ka
	h/kb0Bxit6kfKpAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791979790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WVgkZ/vvaM7S8C34FvgRuKF0g6RTv4zFtLpv2Bvz05E=;
	b=PJtvjB0ATXY0xuAfABs+PjKs5r9I5eY/PDc7q45U+/XeFotYb+g6h7fY7fr8V0HG5h+P/g
	kpyBak+qCAiBm7YYk1IqfSRDmuSep13QqXYlTUMNoVK1mfl+6zR9GuLxgWjRoJVmTcQjZD
	exELZzYyAScTUsdBs0XlFJrGwGjIVE0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791979790;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WVgkZ/vvaM7S8C34FvgRuKF0g6RTv4zFtLpv2Bvz05E=;
	b=O8w4tWkCMNGFzDnkpHWQ/s3vb4DE2HuKHckr4bWZCMGe0yuiQdolFK2OcHKuq6Q85G2RIS
	lOCFU2C3ohkEBiBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3AC4D1368E;
	Wed, 14 Oct 2026 12:09:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +JkQBg5xz2rbYgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 14 Oct 2026 12:09:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C0E1FA140E; Wed, 14 Oct 2026 09:35:32 +0200 (CEST)
Date: Wed, 14 Oct 2026 09:35:32 +0200
From: Jan Kara <jack@suse.cz>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ian@honeycomb.io
Subject: Re: [PATCH v6 1/3] writeback: clear the old wb's dirty IO state
 after switching inodes
Message-ID: <f7cp6bslfs2ktarigwvto63masggncd6al2hefj4fmyvehybhp@3y7pjailoxkh>
References: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
 <20261002-wb-dying-cgwb-flush-v6-1-1991b4e2dcff@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002-wb-dying-cgwb-flush-v6-1-1991b4e2dcff@honeycomb.io>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 294BD4000C
X-Stat-Signature: 56ppehwtraibtsozy3oi3ptwj97mhdip
X-HE-Tag: 1791979793-662937
X-HE-Meta: U2FsdGVkX194Z3zjdnUgrKAUAcN+hzFj2Rg0iUU5wcyL14wKwDPotY1t/joJEnxugjkBjOSuAFS5qpYtox6I2sCT0gvYuKfj6s4tTufUGGWlebcz1oN0yDXyvv8E1nWM9gSSaP9nl77JqNW/VizVLDjiltEfCczgluuFw7ZFTf9DF7Ty/p+31QCxxiAtWlzZe8GCtYT85YZ97Q2dSmxGEJHqMmetS5BQ1DuNlQHmXwYoqXqR64cSeq3JHc4tnazqz3cxfKuQo/VcGK1zNF3hPaTws8z3t/HoFGDqaRpYOIbM1XuflaZoaH+zPOCubu5cLT5C21nmsKjYn6chBXZeosYD88C4MsAMsxrXxMyvVCPsogllW42gD4MzN1Og1CCDN9iXPyr3d5v+CbvOBuRC0GilPUvymw62pTJrgwvK+LQh4Apc+f/s/WSB/jq3LI23GBZpmpLCs1Q/3AwZn5AocjslPnWGsGYQ5bOwlO95oqJm1whJnPCGngmLhbXqiHTNKtyI93aUChNkFwEgISVxDu79c+39jGsYuWOb4k36bFN5GWv4pAqAT9RquXGUZPr8D/ZmESDisFB0y5X4FdtZozMGvLVnHE9XGiFyUZvGy2MRG/IdVwOGUUMafQdxr5e6cR8M1yCvKa13iW3RYSSgBekuQoOqVC/5TI32/OGR5k+Tn+uI/mKuQ1FDBp73UoX4YLqIWh6xb8e2EpDZArzZvhWHiGFn/OGE40hTbgqxtM4HLUBbTDszYhh/rf10a1YsLtlQvXa9DKhxbc/XMPj01Y8vEDdDpj78CiOwKb4j6UbOUjAtfr00ySk/QXp3XUjLPpUt84NyKpxLjwXYV5LdqOW1vFYHCF+THAWaQqo8TBXRGU7vsFTn7JG0dYfh7KCukL0nPvCv8vEtHraE47jpZ6KyMgrryOv4JLDMxFQdIK0xJiHwyJe5T3LXUGp6jWjomfFslKZuiu1DnICs/Bu
 gYD7257e
 wJ0PHfTb+vLzKN9RfpVXSmubaIKnSOhbfX3oOe+99YL65rTypRKl6q89kuDnbC0+1SmQseiPcnmmTgZilH9ZuDdykTZhNdU4V+dtLnKGca9WJ5QcfWJdNIPjm0pdAH3SQUVOyYK4kgG7pXbpCC8vAemmq8xvGQC0oUIkHVSbPhUmwaKeQSf0k5VukFqKA5DJ81p1xvTLyMiQkHHXorrd8fdi/gia+9/Vnr9zBdI7kk/eTr9za/gwwg3nVQqKLmj1SaQ+wzrX46iUU9aGnRqRXAu7xa2DBszOtcfRPKG0nr10KIKv3FxGQGpsikupVitZYu/y6FcNOIgu/rSSDuta6OZb12+j7yaKXS9Jq4UaKI26ls+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 02-10-26 21:40:45, Liz Fong-Jones wrote:
> Switching a dirty inode to another wb can leave WB_has_dirty_io set on
> the old one. inode_do_switch_wbs() moves the inode onto new_wb->b_dirty
> through inode_io_list_move_locked(), which only updates new_wb, and
> nothing calls wb_io_lists_depopulated() on old_wb. A live wb clears the
> bit on its next dirty to clean transition, but a wb that gets no more
> inodes, such as a dying one, is freed with its avg_write_bandwidth still
> in bdi->tot_write_bandwidth, which wb_split_bdi_pages() and
> wb_min_max_ratio() divide by.
> 
> Call wb_io_lists_depopulated(old_wb) after the switch loop in
> process_inode_switch_wbs(), while old_wb->list_lock is still held.
> 
> Test: after the last patch in this series switched a replaced wb's dirty
> inodes away, BdiWriteBandwidth stayed at 411700 and 407820 kBps with no
> writers and b_dirty, b_io and b_more_io all empty; with this patch it
> read 0, in 3 of 3 runs.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
> Assisted-by: Claude:claude-fable-5-1
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index d26b2cf05283..050d507aa554 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -566,6 +566,12 @@ static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
>  		}
>  	}
>  
> +	/*
> +	 * inode_do_switch_wbs() only updates @new_wb's dirty IO state.  Clear
> +	 * @old_wb's if its IO lists are now empty.
> +	 */
> +	wb_io_lists_depopulated(old_wb);
> +
>  	spin_unlock(&new_wb->list_lock);
>  	spin_unlock(&old_wb->list_lock);
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

