Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C3A5CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 12:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28A1B6B008C; Mon, 25 May 2026 08:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23AB46B0093; Mon, 25 May 2026 08:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1296C6B0095; Mon, 25 May 2026 08:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2E546B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:20:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8B8D1C0152
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:20:10 +0000 (UTC)
X-FDA: 84805849380.26.BDC6427
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9CC9B18000F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:20:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gOr+SW++;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/bf8OI2J";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=t+oCC0Pj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mYLjb8mt;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779711608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PqfB1Kr5g6SVxfd6pFjgYACkSulPuOJ/RrprUx1Yf9c=;
	b=5Jt7HKVuqYxrKBmgHIhv87HnMsGhSgGmoSpUD6tHAEj1IlJOpIA4MEOmOi6ptNv7uwJ3Hc
	4WxLCox52sdvbgAbZUlaMzQttXuDxbrYyRn+PDz0x/lvgfAL3bEGkMq2s+IKesbWbwAYBj
	g7FYsu+zP3Ii6i1D3pRNpnV6wYtR7hM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gOr+SW++;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/bf8OI2J";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=t+oCC0Pj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mYLjb8mt;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779711608; a=rsa-sha256;
	cv=none;
	b=WmLF0ZpzR10XtYX/fFWrB3pJNrFMuah2A0b3SUc8t/kNUI9MVsrKE2H+oJCBGqeQq6vUDw
	3ij84IjnMWdajzWUSEzlnlLqynzQZ/LZGZaO0JaCsky3lBs9j/SwcV4ZCdJ8Re1bx1hhiH
	GObrw/f986RVaTCbju7p84vzCNx0xIg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CFF946B5B7;
	Mon, 25 May 2026 12:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779711607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PqfB1Kr5g6SVxfd6pFjgYACkSulPuOJ/RrprUx1Yf9c=;
	b=gOr+SW++IhoWNq+bc9l1riY+T8Wadxyds+6bj1YX70wZVq5R4QSVT6cNXpFU4s5/Ewhawd
	uNHapk5+qf1mX1NY7OrsheeAbjnXvI+a7gXFDlMFKHmgYJ5Lug5NoQiuNKaBSmzoYZUT7B
	e8P1SIMFpNHLAUQA5bl/8AJPv+tzlSU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779711607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PqfB1Kr5g6SVxfd6pFjgYACkSulPuOJ/RrprUx1Yf9c=;
	b=/bf8OI2J/6hCTJRH9OTL1lruS6RVcmzeMZuwn/6utearl8bvbi2q30/u4xKdZpImlkGx9O
	LPlm29Uk0MSHUVBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779711606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PqfB1Kr5g6SVxfd6pFjgYACkSulPuOJ/RrprUx1Yf9c=;
	b=t+oCC0Pj85PX857Tcq2heOdieSU4kQkjH208IQ9o/Tnl3bKKEYCzQS5fUMG30GAJYrU7pL
	Yo1++iRFd1svys0ynUa2Y8uAxjXY4k6O4wgjERYXlxNhHpsK+pYUnT8HhT+ngmsJ4cUAPc
	zYrIuGRP0992kwCVCASVd9NHCOABzNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779711606;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PqfB1Kr5g6SVxfd6pFjgYACkSulPuOJ/RrprUx1Yf9c=;
	b=mYLjb8mt/iNKz7nrEUZnakkFvcTWxl8UQERt0rFy8anZHDkLwAiDOnsrUojcVCg3pq93gx
	+XCqusQEQ4VoLdDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B13E759C37;
	Mon, 25 May 2026 12:20:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CBfcKnY+FGogMwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 12:20:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 55552A08D7; Mon, 25 May 2026 14:20:06 +0200 (CEST)
Date: Mon, 25 May 2026 14:20:06 +0200
From: Jan Kara <jack@suse.cz>
To: Alireza Haghdoost <haghdoost@uber.com>
Cc: Jan Kara <jack@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Kshitij Doshi <kshitijd@uber.com>
Subject: Re: [PATCH RFC] memcg: add per-cgroup dirty page controls
 (dirty_ratio, dirty_min)
Message-ID: <u2ckfxudxhp6xjljlpext3m3dc3fbx3ebatyz7tbfhk2v7am5b@mn3ye7xstiqf>
References: <20260501-rfc-memcg-dirty-v1-v1-1-9a8c80036ec1@uber.com>
 <pbwzmyglpz33d3k63aopi5vlghz4jmur2k2g4res6mhktuujhh@rmqooz6bqaao>
 <CA+w=M=RkewNB0Fc=KNXTrOnt-YABFy+7ZALLmp1wQOP5k_=13Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+w=M=RkewNB0Fc=KNXTrOnt-YABFy+7ZALLmp1wQOP5k_=13Q@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9CC9B18000F
X-Rspam-User: 
X-Stat-Signature: 4751a4s76o3aw4338i83sqm1wcayh7qw
X-HE-Tag: 1779711608-897297
X-HE-Meta: U2FsdGVkX1+Ao+OM5uBPlmy674kuirCwN/kCNzapwSIMHg1pvkfxkGlErEtcxxdXdFNGDUjcpS3U8IqK1WuRBhV7OjWbcdwxeju2qAdUolaggspZFSNkvK4Xxpo0/OvvuGyVtvodGLM5/q08+l9brWBt2YjG0Ie29opUbdzSrIaEYno5V0iyVXRZdCl8lYHGCgP4dlLH7hQh1w4ZUHtgLcUN4o2FObjkVzd4Nh5py+C5NqSKi24iX8Nh6SpVbcigBig1IibMVooNJ7ln1HG33R0uLsbbAN/LG703ykAAOq0D37vAceg5VQOTfs+JWHs+K/iH9Msoj4+uHIXEtmnWQFvwC0VDrtdfJYVgF8gElw1YD+dM7ps9NoSQhSNKXnt7nPKA1bXwRQnYQCFCrlNkyF2H0hLSAEWZYfOzJGSRtR9AvNkpAthCKGO+t137IY+/Sjv2s/UvlAUTbsNJuH2/ux6emv/QuN6CH01Hrpd73/5w/M+6jPz914HEc13eyBk0eGCevMbM3tYACrAAuFFYvFOflwcNZYppxSgtCwnPQWhQq3gvshzEcHB/agyvr/XkSX8wzrjhmoL/pZwbd4pWdTUk203KDdD4W5MKLs6WeFJGybe9m9DF76WcHXWLZwBCTwv8sVKU6JRqueR7X0sSjxdYfjt1/KWsoVKq6R4KEjee0ZINEHgoW0zYgiPbykwC8QpINJqkkrgE07NicIol1/X3V2vvhox/L6d+L31awN1+EWyasKjlh6epCQF4PRkapz4avG001z9EkgQA/x0580uemoYwYiPu2lVRa7zuxVaW0aMReTV828MwCXa68yKEGX2jw3oCI/k81LqMgmqN2uYK4ewuMPj0XUYjNgzwaYAwAhw1OI07cw2ZYJlEchXsSZRU/YowuckBPr2oqzO3nB3F+47HUV5DWfChJ9dQtSFv3yr0ap0kb1b7npRagCUrefvWaDbUsSrIpYgFD5M
 3rP9eQCw
 pKCGZnDhyw0wJvGhed4cfoIIJyRCRqOl+t5OSjXq+mxLyayAnZZZ4U/V/e+6Bc7Q3ZtlBl96y3Blb8RL9Z9f1Pp4WZnufBGKK3X4ZIp/WE/BizRlst4YtDe1mTsKmkwskTzlXBdGVxt8oYyNFoewQ6Viklwkf9kPnj4CbfqtLZ85wz3KEOw8pkC2SDQxcRIbett6UdYjABiaUAshdlJUFyrfofgKrOpWt976dytztsYL9/gAysCw/t73IwYSfgoFVTHR8ykleZl6CoSbEUDUqiEmxSNqlhR35MJrNp8Xst9ct4ysswBpO+HlHeKuprn/WX2IUWhe1Zr4oiVejrNHGBdiJpnxjHrnzrX8wwKXZ642TBYO+RAkxU7OUutU4juQyMd5arCu4uyEQxbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the details and sorry for a delayed reply. I had two conferences
lately...

On Wed 13-05-26 21:10:10, Alireza Haghdoost wrote:
> On Wed 06-05-26 16:21:00, Jan Kara wrote:
> > Things like motivation actually belong to the changelog itself, measured
> > results how the patch helps as well. On the other hand stuff like history
> > is largely irrelevant here, frankly I don't have a bandwidth to carefully
> > read the huge amount of text LLM has generated below so please try to make
> > it more concise for next time.
> 
> Understood. Will trim for the non-RFC posting; apologies for the
> volume.
> 
> > ... I quite don't see how a multisecond stalls you are describing would
> > happen [...] If we are below freerun in the memcg, the task dirtying
> > folios from that memcg shouldn't be throttled at all, once we get above
> > freerun we throttle by maximum of throttling delay decided from global
> > and memcg situation [...]
> 
> The stall is reachable even with the victim's memcg well below its
> own freerun. The freerun shortcut in balance_dirty_pages() is an AND,
> not OR:
> 
>   if (gdtc->freerun && (!mdtc || mdtc->freerun))
>           goto free_running;

True but this is mostly a performance optimization.

> Once gdtc is over freerun (because the noisy neighbour pushed it
> there) the shortcut does not fire, even when mdtc->freerun is true.

Below in balance_dirty_pages() we also have:

                /*
                 * Calculate global domain's pos_ratio and select the
                 * global dtc by default.
                 */
                balance_wb_limits(gdtc, strictlimit);
                if (gdtc->freerun)
                        goto free_running;
                sdtc = gdtc;

                if (mdtc) {
                        /*
                         * If memcg domain is in effect, calculate its
                         * pos_ratio.  @wb should satisfy constraints from
                         * both global and memcg domains.  Choose the one
                         * w/ lower pos_ratio.
                         */
                        balance_wb_limits(mdtc, strictlimit);
                        if (mdtc->freerun)
                                goto free_running;

which is the key logic. So unless you have strictlimit enabled (which you
didn't mention you'd have), being under freerun limit in your memcg is
enough to protect you from a noisy neighbor.

> After the shortcut fails, the per-task pause is computed from the
> dtc with the smaller pos_ratio:
> 
>   if (mdtc->pos_ratio < gdtc->pos_ratio)
>           sdtc = mdtc;
> 
> When global is the worse domain, the victim sleeps against global
> state, not memcg state.

*If* you are above freerun in your memcg (or have strictlimit enabled) then
yes, I agree.

> > So can you perhaps share more details about the configuration where
> > you observe these delays to innocent tasks due to another task
> > dirtying a lot of memory? How many page cache in total and dirty
> > pages are there in each memcg [...]? Is the delayed task really
> > throttled in balance_dirty_pages()?
> 
> Yes. Re-ran the reproducer: stock 7.0-rc5, ext4 on virtio-blk
> throttled to 256 KB/s, dirty_bytes=32M, dirty_background_bytes=16M
> (freerun = 24 MB), noisy = single fio job doing unlimited buffered
> randwrite, victim = single fio job doing 4 KiB sequential write
> rate-limited to 500 KB/s.
> 
> Per-memcg snapshot during the contended phase, ~10 s into the run:
> 
>                        noisy memcg     victim memcg     global
>   memory.current        47 MB            21 MB           --
>   file (cache)          38 MB            14 MB           --
>   file_dirty            26 MB           1.7 MB           27 MB
>   file_writeback       1.5 MB           4.0 MB          5.3 MB
> 
> Victim memcg holds 1.7 MB dirty, far below any reasonable per-memcg
> freerun. Global dirty (NR_FILE_DIRTY + NR_WRITEBACK ~ 32 MB) is over
> the 24 MB freerun ceiling, driven entirely by noisy.

Ah, OK. I think I see what's going on. How much page cache does the machine
have in total and what are memory limits for the noisy and victim memcgs?
Because there's this somewhat surprising behavior when you configure dirty
limits in bytes in domain_dirty_limits() - the memcg dirty limit will
roughly be dirty_bytes / global_available_memory * memcg_available (where
memcg_available is memcg page cache size + how much memcg can grow from the
current size until it hits memory limit). Since you set dirty_bytes to 32M,
your machine presumably has gigabytes of memory, then it's possible victim
memcg dirty limits end up really low.

> The victim writer (fio with psync) is in fact sleeping in
> balance_dirty_pages(). One stack snapshot during a stall:
> 
>   [<0>] balance_dirty_pages+0x5c5/0xac0
>   [<0>] balance_dirty_pages_ratelimited_flags+0x2a1/0x380
>   [<0>] generic_perform_write+0x194/0x280
>   [<0>] ext4_buffered_write_iter+0x63/0x110
>   [<0>] vfs_write+0x28d/0x450
>   [<0>] __x64_sys_pwrite64+0x8c/0xc0
>   [<0>] do_syscall_64+0xfa/0x520
>   [<0>] entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Sampling /proc/<pid>/wchan at 100 Hz across the contended phase
> yields the histogram:
> 
>   104  balance_dirty_pages
>    88  hrtimer_nanosleep    (the fio rate-limit sleep between writes)
>    12  RUNNING
>     4  p9_client_rpc        (virtfs, host-guest filesystem RPC)
>     3  d_alloc_parallel
> 
> The vast majority of non-rate-limit samples have the writer parked
> in balance_dirty_pages(). Victim per-IO clat in this run reaches a
> 3 s tail (worst single 4 KiB pwrite blocked ~3.0 s) while its own
> memcg holds < 2 MB dirty.

If dirty limits for the victim memcg end up really low, then yes, this is
what I'd expect.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

