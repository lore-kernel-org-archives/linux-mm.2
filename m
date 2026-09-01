Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE52C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 389D66B009B; Tue,  1 Sep 2026 10:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361C26B00D0; Tue,  1 Sep 2026 10:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278516B00DC; Tue,  1 Sep 2026 10:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0AA36B009B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:44:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EEACF1C209B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:44:12 +0000 (UTC)
X-FDA: 85165463544.17.D9DC5D6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id CAD9A20004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:44:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YDX0Pe9q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OMf2n6Oo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WkLy24zm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6Pxovp5P;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788273851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/gTDEhVKdEhY/hU+0ykwPzObhxDg0wKu9fWSTc7Y9g=;
	b=dPtPGI2L+nYN24+8tyURGQNc5IrJUiJLjtZH5ArJKNZaZBjUI+qE7xdWnCRjUpPN4qLPnd
	fOzR1c5OLnGPHws67I2h/tuunTl+5+6x4bhZYY41m0r4xrVuSso+aqzH10peLj3DsSV6to
	F0a8CUZo07YCfqjYtct1zJTPwf1fdoU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788273851;
	b=2CaTa6VzcFVBsXh5VV5NI4tiV2g5tiQ2Ci5aXQrZHWqCdhWvx4h0Efn0fVjh41I+olqREc
	fc19m+1+yg05Dfi0yG05JghFOEVGEdyXgghfTaQcxUc/Dry8j1jM6xCsez5HHGAWujckn9
	U4jWGjNAc8c5Llxahfrt8F+QEg3o7uk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YDX0Pe9q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OMf2n6Oo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WkLy24zm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6Pxovp5P;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3F5B0220D5;
	Tue,  1 Sep 2026 14:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788273845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/gTDEhVKdEhY/hU+0ykwPzObhxDg0wKu9fWSTc7Y9g=;
	b=YDX0Pe9quX55bY2G/mUM3F009pTxAiFCrZMFAVbWSVHPy1owBESl8CICtz5SLVDXJk0xbU
	V1AFR7rdGZaYntaECSQ1ZGFoGm4em4izvRtFdHRqueWx1y9P50kqQRmwRSR+J20pPi97y/
	emB7IJboIBSe/qzjZQgPFugWEquQF3M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788273845;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/gTDEhVKdEhY/hU+0ykwPzObhxDg0wKu9fWSTc7Y9g=;
	b=OMf2n6OoLdjJqRPThc+EdieDSdE3Gjs9vU+qOL9/ZEIAkXvpmmCx4z2uBjjWetwZYFz7jj
	T3KBYqdYJhvTXeAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788273841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/gTDEhVKdEhY/hU+0ykwPzObhxDg0wKu9fWSTc7Y9g=;
	b=WkLy24zmDiV2Qbe5c5R9RKDkYqPc+z5lQ+IbsxahrgE/SqlN7jZSNZbL/beGhY3/75qC6o
	W8zPLn8twvvXqLYocbRB5iYPn5s4BCEloanGhsHK3nUDfjP19lA6qtQnNnLbqS2YDskzLJ
	O3py4GYxsPk4cShF408p8Eq+gNR5fkY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788273841;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/gTDEhVKdEhY/hU+0ykwPzObhxDg0wKu9fWSTc7Y9g=;
	b=6Pxovp5PTJjL5SxcAxUkopWjGa+vqMTVCyAdH/AUnNqVB3+PQroE3PV7MGFp8LY9QEA5oZ
	d/2s/Z3MB6RGoeAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A4B91369E;
	Tue,  1 Sep 2026 14:44:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tZhbBrHklmocAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 01 Sep 2026 14:44:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 940A5A13B2; Tue, 01 Sep 2026 16:44:00 +0200 (CEST)
Date: Tue, 1 Sep 2026 16:44:00 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk, tj@kernel.org, 
	jack@suse.cz
Subject: Re: [PATCH] writeback, memcg: skip foreign dirty tracking for bdev
 inodes
Message-ID: <b4yiuuthnjfgoc2djz5cju3jahstzwizqyaqxo5dd3qijmsww7@66sink2shhwu>
References: <20260901131028.1120284-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901131028.1120284-1-sunjunchao@bytedance.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CAD9A20004
X-Stat-Signature: foaoudqsqeooo7ruk39m6rpxbxbiijri
X-Rspam-User: 
X-HE-Tag: 1788273850-135140
X-HE-Meta: U2FsdGVkX1/bA38iXQOhfEoIfBHbCtewpX898yi8eC+44IMwbIjXvWyaHeFEgTu9GUcwsIrspPkz0/AMXNV0BAu+tVlNcww4hJwiwkeD50w+s4QkdIMtUVyUBGrxJf+71Y9IkPHY0b1A9iKo60M4FJldZPSLFoHqTaaKsttJtqNDCxYKwRcJF9Al45csHu64DK1jIBCFB0QTeNp4SjzBbe3+GubvFT6R9lyimoInBxKQsdz/bcFhsqYJ7nl221GrfaDWEJOiFCriNKTjtwpuZH1ONl46C7M9YObN06KnLZm49AIUIR3sWHYxzSMIeit4pUPNo05Ligq/GFbyB2U/rKkz7GRMsxf63aR0Ib8xSYSWMfMg4ZlF/cE9idSfw5cGGevwS3Cd9kaTHV2+/QWogC22DIkqV7RMbNuai/09+xPkIa0s6vbdyGsFYjzRViI3hHGUHM2xmwTKL6qsy4goPIUtaqKn8yc0+Bd8cAwaA7oiXejMFSFBRH7WPs5eoUjK3iJS6oeVav1dhgoOzkv+BmZbBfx2S/Bnuapo1IyvFKu1mSP8frVMc0dNFqx0uxwWq2nTvKv3mvf8A2x27sH4MfsdU1jqm5WOtn6CNen/cKU6k8vPBfy60IXsdrId8m9Z0an1E8ehfVo4XTItKnEkf/w+HqSF5PSEZvy4jcjktp6mbwZ0kOkk+duIPsajtyyfe2lnJvZtJgqyR84BsiG5OIPT6+OdmDY8vQEhmrnCJ4PA/mzVIUxrX+zqmbcw/qp9MSYRJNxzcLMTFknO1st8vCLOaxJz1hz3Mc3WaavjuDZhUKpLyt538jHkko8LGG5hpxAaJPrO3dBZIip6N4pc+SL8VsW65exL3u8Ic1zR9vVN5jguYh/AFBtp8uCgWD7hg352SOcxy+KtJ5RtYGrrcSaC4mOb5SH/a/A4jBiadu0TYjvlA99qTsIi/At3Stplzjkz9QtzJpg35GCyXBt
 ABOUvGdk
 nxBl/72b/vcfWMyt8VtOz6Ng46LlGlVjhJMax7eiALLdarqblD3sE7PeKTDgb85f7PRRSVvH0aFhhA3R1HX4oiIa7BwqIYt0ukW6aFrB8Lo/hDLYTRV10BmSC2VZsX0wQRXdrubeiRpDkqVO0xYuH2idkyG0O9LP7wi0e3joAsrLYXZLlKiR18J8Z0bfOYeo3bhdDuQzyobxk5kotpeefRKsMNM3yYJu5hQbcKfki9skAdn5qKtGhprbn7e2x/P6wCSQ+1ymnOxEBN/87VYsYkwMTudLpEUjLeH5tlgv48Pt2DD9fxb7UpmDtg2S/wyGbziYteuKY6eInfjXdrj8XZaeqNbyu4kGLUiYd+3GSxPzQ6n4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 01-09-26 21:10:28, Julian Sun wrote:
> Foreign dirty flushing handles cases where a dirtied folio's memcg and
> the memcg owning its inode wb differ.
> 
> wbc_detach_inode() notes that "concurrent write sharing of an inode is
> expected to be very rare". This expectation does not hold for bdev inodes.
> A bdev inode and mapping are shared by buffered users of the block device,
> while the inode has a single wb owner. On ext4, buffer-cache folios used
> by metadata and journal I/O can therefore be charged to different memcgs
> while sharing the same mapping. Normal bdev activity can thus produce
> frequent folio/wb ownership mismatches.
> 
> This was reproduced on cgroup v2 with the memory and I/O controllers
> enabled, using ext4 on a loop device. jbd2 repeatedly generated
> track_foreign_dirty events for bdev folios charged to unrelated memcgs.
> When one of those memcgs entered dirty throttling, the resulting record led
> to a flush_foreign event and queued writeback with reason=foreign_flush for
> the bdev inode's root wb.
> 
> Skip foreign dirty tracking when the folio mapping's host inode is on the
> blockdev pseudo superblock. This prevents bdev-originated records from
> triggering later foreign flushes.

I suppose the real downside of foreign flushes is ultimately reduced
performance?

> The tradeoff is that dirty throttling in the folio's memcg no longer uses
> bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
> folios remain subject to normal writeback. This is preferable because a
> single bdev wb owner does not identify which cgroup is responsible for a
> mapping shared by buffered bdev users. Flushing it can write back data
> unrelated to the throttled memcg. Dirty accounting, normal writeback, and
> foreign dirty tracking for non-bdev inodes remain unchanged.
> 
> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

To me this looks as a sensible workaround but I'd be a bit worried whether
a memcg that dirties a significant amount of bdev folios (compared to its
dirty limit) cannot be blocked in dirty throttling due to this - as the
comment above mem_cgroup_track_foreign_dirty_slowpath() describes. I'd
defer to Tejun to judge if can be severe enough. But I think if we go this
path, the added condition should have at least a short comment like:

	/*
	 * Bdev inodes are usually shared by many memcgs so foreign
	 * tracking leads to frequent flushes which is counterproductive.
	 */

because otherwise this condition really makes you wonder what is going on.

								Honza
> ---
>  mm/memcontrol.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..5d7320f76c06 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3898,6 +3898,11 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>  	u64 oldest_at = now;
>  	int oldest = -1;
>  	int i;
> +	struct address_space *mapping = folio_mapping(folio);
> +	struct inode *bdev_inode = mapping ? mapping->host : NULL;
> +
> +	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
> +		return;
>  
>  	trace_track_foreign_dirty(folio, wb);
>  
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

