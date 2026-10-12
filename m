Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79998CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 09:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479096B0088; Mon, 12 Oct 2026 05:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A086B008A; Mon, 12 Oct 2026 05:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317F76B008C; Mon, 12 Oct 2026 05:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 052486B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:38:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 065BA40A74
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:38:30 +0000 (UTC)
X-FDA: 85313474022.25.FCAACAC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6F35D180002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:38:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YoJuOtRL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qc3PUMzI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jBvpIfag;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RzBeEw0C;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791797908;
	b=IdWf0iAa/U+Kw+gC9BGGuCYHLEqb+wNN1PqEbs0B2PfoDdsIK4POy5fM4iH8Ft7ORmJ+A7
	C3qih6GOd63MaWmAEw3g5qGcD6CaaK6VF9vW1bKMKuBA7UMl4d7bDfovAXyaK/GzJ0JqoM
	XOQ2S8iC2sDI+YvN6nlewbm9AJMgRZI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YoJuOtRL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qc3PUMzI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jBvpIfag;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RzBeEw0C;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791797908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kg1XO9faP6m/0SQ0V7ZFc78dVzs5U9T2ADjMTseWY8Q=;
	b=nptejkwxYm25EsqJ3OUpJGUZsSBwGSJsRc0l1gldpsrKEEc+EXpfs4Kh5LS2o6OJhJXJ0P
	DA7mPH48I18xUtoOPwcBolP0+twjgjOdUVS2WJRW9N7ah42tIVSe4qD/rpZOF8eOzSiNeo
	QItLeyXPJ2RVT76n875rU47fLInQEP0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C4B021DFB;
	Mon, 12 Oct 2026 09:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791797906; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kg1XO9faP6m/0SQ0V7ZFc78dVzs5U9T2ADjMTseWY8Q=;
	b=YoJuOtRLPgh7f9CbXokLXvzdhWKhzjqBlnoKGbBdQ2JFfo5v6bHzZqfF3ssrwLSFxpmeMf
	S4DW2FMmIXpecJOfF0nR97pcWGAd6H16WoccOxqdLe8VAPvA2lKlgndgjVwufvrceMYQNh
	mTA6YGXv/eYFMMMGiZjIGJxfP15l6wY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791797906;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kg1XO9faP6m/0SQ0V7ZFc78dVzs5U9T2ADjMTseWY8Q=;
	b=qc3PUMzIZdRUvmkFX5yMIvkOt1BCm4OSqtnP7bOa5Nr0IXlAsxHow1k47xh8ElUhwuTbTt
	Xscz2vfer4lh8iBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791797904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kg1XO9faP6m/0SQ0V7ZFc78dVzs5U9T2ADjMTseWY8Q=;
	b=jBvpIfagC8+JRjzlAttwUE8YIgln3zHFXhf9IsjhBcll+k3u9GNlXPolhkO4u1PP85Z5hY
	TUl/8mBKyLyqYYV0FRrNb3cTukjTSpV1VR26p5pas6xj4mMfAWVjODWkQze95jrCxNsmIJ
	zdIUBH79iDepCo6E/PKuyMnXDZ++Ed4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791797904;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kg1XO9faP6m/0SQ0V7ZFc78dVzs5U9T2ADjMTseWY8Q=;
	b=RzBeEw0C8Lhoivs5CAGhjdOHh77P0kP84OlOsbNGbTTmYBf7bIgGzxSqDGms1qUgRsSFov
	rUsfpc/ZMyD+pqCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 73A5313314;
	Mon, 12 Oct 2026 09:38:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GTppFJCqzGqZcwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 09:38:24 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 05E1EA1403; Mon, 12 Oct 2026 11:38:20 +0200 (CEST)
Date: Mon, 12 Oct 2026 11:38:19 +0200
From: Jan Kara <jack@suse.cz>
To: Nikolaos Karaolidis <nick@karaolidis.com>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Zhihao Cheng <chengzhihao1@huawei.com>, 
	Mateusz Guzik <mjguzik@gmail.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs: don't lose inodes that another LRU walker is
 isolating
Message-ID: <zec4khbtx7uap5swffdwxfesiz7as3ey5ulzyruwbztqfpymzs@n5t4xbsoz6c6>
References: <20261009142431.713875-1-nick@karaolidis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009142431.713875-1-nick@karaolidis.com>
X-Rspamd-Action: no action
X-Stat-Signature: curzyie4g9btcmzee4hmqw5ndtgj8d3y
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6F35D180002
X-HE-Tag: 1791797908-356570
X-HE-Meta: U2FsdGVkX1+lPBMSiAbJR44xR9CFsl/A6DyrAcXhoBP4b0fbTdXAB2sWQsT6A3RJtoS2ODMLBsBv71G29gxXja5hs8PFih1ilNx1XOBdhkojbDJCiIn/BSaPGJwf1Bz2ddEBrZFoA4AJ9FwBE5WYUN+GQ+4G+o3Oh1plFSxXkYZzZN2mkMpaG+EWnriL/UHSUtgQULEB9ripVxbxH9u9edButa9PRF/DddIKaGKyC/uhKkuc52BLmXkqxHjGXH4XSpJ2LOpmn66pe949RrvOfsFnSDC4/CULscKknWkIO6uAv7l3TM4SBoLHoTJ6Sibiugu4/3VbA6PMtjuwtMUO08ccMPrydBjyv5wH+R1F2gmmVicFVNUelJGpzJboMjhNtyqPlO0RwysbP0p0TzrNLOQJpARFfOBww2G5OO1NAfk6J8RTbUhN1JJj+8EvToUvxhpY3tyodk/kR56fyztJCPPCBAKBrlPoLYQAntavBN8AF35lA4uCEOVx66UHI/gN48q3cN2354hH14oJJ9uBSIrUHaxOjORvor/fd8lpDUEFjFzJWWtlFPXpwBOl7foHIU3DsLI4ysPGuWWvW0FYPAiU9swY+09a6nB8ofLJxNJPHvmlvYut6kAFG/kVE42dMmWJnIWj8VzOM5jFzIGfkX07rYgkdALjPGYPyGlb2i1KjdqK5JFs2jIhoRmvytHjOjJ/V+kXrpJJZYoBwhxiunaRYpvh8c9sdO0Uz6gAudNHX87W+DdM2knNRwlg+/MB9AHYmR3QJqNQDrMv37ENj5lFZxLgu2EVxr/61l0G16HYQj9NzgjRsubnD5GM3G1Uma7A3euX+VV0mhCcIkqdbQ0goit8IR0vR+Z5GH3tueoxWuzEb2cUle5j1i/wVTbHzrk3SLEO+Evod1fU4kqWrSLkuWCxi2zSNMu+3293nq/wuvU8SJQ+JMG0MHAGfMUd+vau8k+RXGabvmqjO8r
 DJA1xCPY
 9B/DkGWma1wvI+vAT14efLD9rFUH909YsT4FK3QJxXf+3DTrKOG7R+kUG2fLKXe8teUbt5ZMf7yXNvzwXC3A7fKVBIQmwnfoAU/9qOPzhwFBkdhrbhhErTlf4daRCtUhbmVuV9L7G2u99Gmymvd2Iyld4YQccLmm9scB2VKeyO9NC6GZwRAwP5QwSONeLbzZ1k5/NrMQuS+BJSdmeURftHPx9X33g8t8SLlay2zVISr9xEao41n3gko3iEFs5hZvm643ceKkhqFLV5IIehWW/v46XGDCuRb/VLUiLOtZzFGoWP/QumQX7OWfmz6ohVa48RbUDWAFt9Y24/V7t3SDkMCmOGHcfFC2fhcLf1/l5xXlF2asZ8HlQaMU1N/duYj0Mj/ybUODEHuXYKlWSkPxD3G+tumm3saqQWrgJ5S+dS6fOv/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 09-10-26 14:24:31, Nikolaos Karaolidis wrote:
> When inode_lru_isolate() finds an unused inode that still has page
> cache, it sets I_LRU_ISOLATING, drops i_lock and the list_lru lock,
> invalidates the page cache, clears the flag again and returns
> LRU_RETRY so that the restarted walk can free the inode.
> 
> Another walker of the same list can reach the inode in that window.
> It sees a non-zero i_state and takes the inode off the LRU, as it
> would an inode that is in use. Page cache deletion requeues the inode
> once the mapping is shrinkable, so this is harmless if it happens
> before the last deletion. If it happens after, nothing puts the inode
> back: it stays in memory, unused, clean and without page cache, out
> of reach of the shrinker and of drop_caches, until it is looked up
> again or the filesystem is unmounted.
> 
> Before commit 2a0629834cd8 ("vfs: Don't evict inode under the inode
> lru traversing context") the pin was an i_count reference, and the
> final iput() put the inode back on the LRU.
> 
> Skip inodes that are being isolated and leave them to the walker that
> pinned them, which restarts its walk once it has unpinned them.
> 
> The window is reached by any unused inode with page cache on
> CONFIG_HIGHMEM kernels, and otherwise by inodes whose page cache is a
> single shadow entry at index 0. On an i386 HIGHMEM guest, eight
> concurrent "echo 2 > /proc/sys/vm/drop_caches" over 2000 freshly read
> one-page ext4 files leave roughly 400 of the inodes off the LRU per
> round; on x86_64, with the files' pages first evicted through
> memory.reclaim, 3 to 4 per round. With this patch, none in either case.
> 
> Fixes: 2a0629834cd8 ("vfs: Don't evict inode under the inode lru traversing context")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> 
> Found while working on reclaim of inodes pinned by page cache in
> ZONE_MOVABLE.
> 
> Tested on master af32da41b032 (v7.3-rc6-232) in QEMU/KVM with a small
> stress program: mount an ext4 image, read 2000 one-page files, run 8
> concurrent "echo 2 > /proc/sys/vm/drop_caches", drop caches again
> single-threaded (2, then 1, then 2), and count the filesystem's inodes
> still in memory via how many the umount frees:
> 
>   i386 HIGHMEM:      ~390 of 2000 lost per round without the patch
>                      (3 runs x 20 rounds), 0 with it
>   x86_64, pages evicted through memory.reclaim first (single shadow
>   entry left):       ~4 per round without, 0 with
>   x86_64 with KASAN, PROVE_LOCKING, DEBUG_VM, DEBUG_LIST:
>                      6109 lost in 50 rounds without, 0 with, no splats
> 
> The reproducer is a single C file run as init; I can post it if useful.
> 
> I went with skipping the inode rather than requeueing it on unpin
> (which would be closer to what the final iput() did before
> 2a0629834cd8) because it avoids the remove/re-add and leaves the inode
> where the pinning walker finds it again. Happy to switch if preferred.
> 
> Jan, this applies cleanly before or after "fs: Basic infrastructure for
> offloading inode reclaim" (v2 3/5); happy to rebase onto that series if
> you'd rather take it there.
> 
> For stable: 6.18 and older need inode->i_state instead of
> inode_state_read(). I have only tested master.
> 
> An LLM was used to check the analysis against the code, write the
> reproducer and draft the changelog; I have reviewed all of it.
> 
>  fs/inode.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index a9d37be390a1..74dfc379b377 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -942,6 +942,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
>  	if (!spin_trylock(&inode->i_lock))
>  		return LRU_SKIP;
> 
> +	/* Another walker is dropping its page cache, leave it to that one */
> +	if (inode_state_read(inode) & I_LRU_ISOLATING) {
> +		spin_unlock(&inode->i_lock);
> +		return LRU_SKIP;
> +	}
> +
>  	/*
>  	 * Inodes can get referenced, redirtied, or repopulated while
>  	 * they're already on the LRU, and this can make them
> 
> base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
> --
> 2.55.0
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

