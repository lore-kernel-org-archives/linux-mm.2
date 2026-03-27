Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8195010F284B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92AC6B0095; Fri, 27 Mar 2026 12:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69D16B0096; Fri, 27 Mar 2026 12:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6F86B0098; Fri, 27 Mar 2026 12:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC9366B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:04:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D8ABC3589
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:04:31 +0000 (UTC)
X-FDA: 84592315542.27.18876FE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id C0E9D40011
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:04:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zgoHOdj3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5Hrn4w0u;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1IS8VkSh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IeVik0pq;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774627469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RgJOCPmwW5dXy+RP40xSPJQ5SlHLNJcw6k/uuw8+KxI=;
	b=UhwPPHdCNJLS6ZHxGOS3TyZhh2MVy8YtDMjYUuNPEaDl/v7Tv54mdGJxh36LOUqXoMUwsB
	3CANbp2GV3QXhNcKz07eo0aTtcWwcdXJu97rw1GKvFChhYV3TiMxoi9rZjhqK1fhbZfAGX
	zK9sroxrTi++TQm0IsyOpj6R7MH+Y9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774627469; a=rsa-sha256;
	cv=none;
	b=oUFC6bDxZ94afW8IfJhfMv1NaLCSKZ9KiCfr5698VUcxStqdW1QWYOWl51zt3QAvIjadou
	4zglboB01Khuri3JeWq1t7IfGiY9tFpxP5c6sSkFbxN2xaLNzWDt/ozx/jzX4/FlxhnOkn
	cNbQSVoBROJXx/K6qVYfbeercOe87Hk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zgoHOdj3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5Hrn4w0u;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1IS8VkSh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IeVik0pq;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E3A354D427;
	Fri, 27 Mar 2026 16:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774627467; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RgJOCPmwW5dXy+RP40xSPJQ5SlHLNJcw6k/uuw8+KxI=;
	b=zgoHOdj3cW3CVBEs9Dw0IicaGtiYynSuIr0k1zyotrsxVLv8wk2kDFnyivqvohIZHvEfUk
	KGmgGnLdd5tFdgO9nCpPofxmh4RA08BxcuLvpkNft9XPOG4UbTO3Gi7IeXvB+wCc4+oLQn
	oZZjbHp7G7FsY01NSz9b76xl7Vg8DEY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774627467;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RgJOCPmwW5dXy+RP40xSPJQ5SlHLNJcw6k/uuw8+KxI=;
	b=5Hrn4w0uVbDAaHzX7KAnWkL+naJRL20WQPLHA5yQw8IE4aouflZKmPaB4cI7FeglMfZ64n
	afYPFxbvQk1Tu2AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774627466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RgJOCPmwW5dXy+RP40xSPJQ5SlHLNJcw6k/uuw8+KxI=;
	b=1IS8VkShkTk9IQsIXhXVGBaM6req2voyLNiKiL8xnekc3WYunGfOnI9+/PAJXaBg6zxXny
	JeQFlF154NCj3p1rWMk3ccYyzZyAZH+Lyv6tVb9O7OPAiv5uGHyOsc7syLwGWlWloeEgqX
	T3WHKTznTRZ7cWcxqzcXCEjtrW1QSzo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774627466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RgJOCPmwW5dXy+RP40xSPJQ5SlHLNJcw6k/uuw8+KxI=;
	b=IeVik0pqAycfnnME+zYk5Io7kaqelik1SRCvS6NsbkSCVCGW5vMIbe1eFfGbaAvUPu9lBu
	U511CVw7XP3C5jBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D79474A0A2;
	Fri, 27 Mar 2026 16:04:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PAybNIqqxmkgNAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Mar 2026 16:04:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 79149A0976; Fri, 27 Mar 2026 17:04:11 +0100 (CET)
Date: Fri, 27 Mar 2026 17:04:11 +0100
From: Jan Kara <jack@suse.cz>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, hch@infradead.org, 
	hannes@cmpxchg.org, willy@infradead.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: reinstate unconditional writeback start in
 balance_dirty_pages()
Message-ID: <5x6fwfy73rufcvhb4n74ffenbof6iftnupsouvm4wnmzdx2c6c@qhdnonwgjve6>
References: <20260326215127.3857682-1-joannelkoong@gmail.com>
 <20260326215127.3857682-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326215127.3857682-2-joannelkoong@gmail.com>
X-Rspamd-Queue-Id: C0E9D40011
X-Stat-Signature: uf18rer5itsk1gpotxqcwpyigg386egz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774627468-493464
X-HE-Meta: U2FsdGVkX1+AkuZODMfW32eif10qQOu2BOb4lD3HSZFBt/m0iNMYL5MPXrCyVxkGho8yEmcY62udBs4JJI/Pe9KsfeLcZTtie4Fq/rTovbdcLwWvHEwHQ6K6GDLTt9UNpPruQczUt46EVXDASDO3Zm0bOGJ6L8hRvXgDDI6gwKNBra2gEoq+EjaggsCcUnQG7sPiDJebDHMIueb1oKvf5K26673kz3iFZ5VY97QAElHolbII6/fs2BJGNXXxvF+xGGGa7OOTsz5X8Eb4d/ZmOUrFwqyPRjNCT3xcGCSAxjEO//G9+jcMscvjHGKZi8MhwXpSbYkF8ru76U0FAW7J+60kd5OnucdJfilar9xXud50JVxrTFnwt18RCRp5ELI03nrKbVG4TC80aBj1LUuQ8wYYqwKdiaNCa0cHCdxpk+uLjq9T/O0SKPhinKrBrGzOEInLHOMA2f1jlTPDf81fU3KUi4e6FzVZb2hS9gFZVs1ftlJ2yGS4zc6Nq0xzXwzyKDDXZPNIg35/7wWy/qOVhIZQYy4X3rP4HKbAj1VpzsIEf/kE3uBC/jHYmAxjDi0zYArUCspt+7VRbuAUAxfArdDT5u5/qrexkxVu00jRrWoZ1gJDaVVop6vJnkcTizeWkh/KFlUhwxHYTjpdppU2rM0s/MuT/QQdr9DbQ6kRSgOTJCzOA+KFrWQPTZOYLzIr6EmzflNK4xgIALmduSoJSP+UwSFlAL/PC3QFqstSZJ8IgbKUu4i0TLKj7b6B5zqPWHzF9uHbkktVGaNlrOOHAYMRvW0jkKR67K/xk4cdqmX2pl0kUcEpxbPf/lNlaR5WsIKLchrCiS0mzzx6owtEX4JfGJLANqe/Y6FMJBFPrsAi/8o5In6Dx8hv0R7o21eb+SiI10K2x0mLyFODq6h962gjUieegv5zooTwotgrkXfPaC5aUSx7qy25CrTJfljfFWzC49SihSYa+yB00sE
 M4BQVf8E
 KrS3eTmREzsxzOkDwW8FnSUghoAZICurAqd/TrLnez3GbRRmGI/ANmlglQStThcy6WE2fUuWS1v/9XMBwtJB67phiTGMXCtff/7rUxNbcPeD8117cJVQWX9vvt52WwF4W5MD8l81IiZ5wACOuypiOSONiBYsRtXyT/bZOrIHBlfvwi7imfcWazEcRAkdPAsH9xCou4N2GDo8ciJaUY9esSXjqFDGAAwYhGykCA49mtgqFGIhmz0gxzpa4Kv90FR5kAAgckVqFx8Qy7RdC606mWpafTViVVy/Ao3fWLPd4aI9rG3r1GdOK4iwUJsKLmgHiyFzTqPA+NiNddNlId4hiv3q+WyCszIjLVA4cJ0ENi+eITqZ9HmiDgMxoWB8pNfloIzwDI3ZfyxBfxwf5bY2wGE/qfZ81eHoqckQa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 26-03-26 14:51:27, Joanne Koong wrote:
> Commit 64dd89ae01f2 ("mm/block/fs: remove laptop_mode") removed this
> unconditional writeback start from balance_dirty_pages():
> 
>        if (unlikely(!writeback_in_progress(wb)))
> 	       wb_start_background_writeback(wb);
> 
> This logic needs to be reinstated to prevent performance regressions for
> strictlimited BDIs and memcg setups. The problem occurs because:
> 
> a) For strictlimited BDIs, throttling is calculated using per-wb
> thresholds. The per-wb threshold can be exceeded even when the global
> dirty threshold was not exceeded (nr_dirty < gdtc->bg_thresh)
> 
> b) For memcg-based throttling, memcg uses its own dirty count /
> thresholds and can trigger throttling even when the global threshold
> isn't exceeded
> 
> Without the unconditional writeback start, IO is throttled as it waits
> for dirty pages to be written back but there is no writeback running.
> This leads to severe stalls. On fuse, buffered write performance
> dropped from 1400 MiB/s to 2000 KiB/s.
> 
> Reinstate the unconditional writeback start so that writeback is
> guaranteed to be running whenever IO needs to be throttled.
> 
> Fixes: 64dd89ae01f2 ("mm/block/fs: remove laptop_mode")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/page-writeback.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 601a5e048d12..c1a4b32af1a7 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1858,6 +1858,27 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
>  			break;
>  		}
>  
> +		/*
> +		 * Unconditionally start background writeback if it's not
> +		 * already in progress. We need to do this because the global
> +		 * dirty threshold check above (nr_dirty > gdtc->bg_thresh)
> +		 * doesn't account for these cases:
> +		 *
> +		 * a) strictlimit BDIs: throttling is calculated using per-wb
> +		 * thresholds. The per-wb threshold can be exceeded even when
> +		 * nr_dirty < gdtc->bg_thresh
> +		 *
> +		 * b) memcg-based throttling: memcg uses its own dirty count and
> +		 * thresholds and can trigger throttling even when global
> +		 * nr_dirty < gdtc->bg_thresh
> +		 *
> +		 * Writeback needs to be started else the writer stalls in the
> +		 * throttle loop waiting for dirty pages to be written back
> +		 * while no writeback is running.
> +		 */
> +		if (unlikely(!writeback_in_progress(wb)))
> +			wb_start_background_writeback(wb);
> +
>  		mem_cgroup_flush_foreign(wb);
>  
>  		/*
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

