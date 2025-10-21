Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD16CCCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF168E0024; Tue, 21 Oct 2025 08:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09FB88E0002; Tue, 21 Oct 2025 08:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9E88E0024; Tue, 21 Oct 2025 08:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5A4F8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:05:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 821D987A9B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:05:49 +0000 (UTC)
X-FDA: 84021992418.04.30B10BB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A47D40003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:05:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="stj/Mbe+";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IKov9Km0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="V3/CNZYa";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K9ZOwBEY;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761048347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ceJbKSzKfwLTY9oVjq75SsrcC00Yrx2qzu9C8Sz+9mY=;
	b=V7yYlJBsp3Qr2ZQYF1+WL4fAXHnxvP7SNW4XGtoCLJ+0fOuXdhzK8FkhrfSZDmZiNgbA5V
	FMT75ReTX73jW/8UNRdkJGDEsuIKMzXbSGU4dywnlcXgfyg/Nh9QOYQNZPMbHP3PivTcLh
	Fzl3QAJNQVt2+OgWDKdoT8iqe+B67C4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="stj/Mbe+";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IKov9Km0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="V3/CNZYa";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K9ZOwBEY;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761048347; a=rsa-sha256;
	cv=none;
	b=OK0yCRt8urDP3ibq0s7ICRN50HfSevFmyZ9t7bvf2e9y8PMyxLYsNRV1Vz9clcbm9T5feL
	6a8zlm/ayJdMxeSu6lU/ZhYYo9Tf5BdT9PiE3SIVIJNqggxICaA6icyfmMwCZ2zFgD+7T5
	bzAOgC3NgIW/IsuUzFgaMI1XFcR2Ybo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 74C1C1F78F;
	Tue, 21 Oct 2025 12:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761048341; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ceJbKSzKfwLTY9oVjq75SsrcC00Yrx2qzu9C8Sz+9mY=;
	b=stj/Mbe+6r2rUr/tvdKO5hySyKd5RmpIXuQ7aXJ3HWP+U74Cb54fgwUdSV4bhkTy56aeoB
	D5NdbulzXUTgsTutzUf2OlLRFIZ8IqzC+LqHTmOYiJBot0Ofs6uzN/LWnGHPkksUD3KkSs
	kkqI4JuQJYvK81qUN3qYfoHs/WvQaZI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761048341;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ceJbKSzKfwLTY9oVjq75SsrcC00Yrx2qzu9C8Sz+9mY=;
	b=IKov9Km0o1N1o3ILTPYyFXew/n/UtiynTAtvNDo0UFsb/cZwcNZk+JVFysx2s+AwTGJK0X
	z/2Q8F17ZSzaVRCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761048337; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ceJbKSzKfwLTY9oVjq75SsrcC00Yrx2qzu9C8Sz+9mY=;
	b=V3/CNZYaxRAjiSulkmeeU8UEjq7b3lhR0d4F00ykyOjsMiiSnzYFC6mms2ojCl/Hd9hLbM
	coQfSRywd5tfOZEujy2jXCI6nkGt6UAGYLi72eX3mUVR4fQe1KMcLy8XiSWA2guRPl+2aG
	NVT2HlElAR06YOFbUNyIAlltGlLkJn0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761048337;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ceJbKSzKfwLTY9oVjq75SsrcC00Yrx2qzu9C8Sz+9mY=;
	b=K9ZOwBEYR606q7TpYxTUVmas8J+sWi0rNh29oDd2kPYUJBgVHUP7w1CILoXhAeOQPNvReh
	PwYgJob5oFN462BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 671A0139B1;
	Tue, 21 Oct 2025 12:05:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aEsqGRF392hgYgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 21 Oct 2025 12:05:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 25CF4A0990; Tue, 21 Oct 2025 14:05:33 +0200 (CEST)
Date: Tue, 21 Oct 2025 14:05:33 +0200
From: Jan Kara <jack@suse.cz>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com, 
	trondmy@kernel.org, anna@kernel.org, akpm@linux-foundation.org, willy@infradead.org, 
	mcgrof@kernel.org, clm@meta.com, david@fromorbit.com, amir73il@gmail.com, 
	axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com, djwong@kernel.org, 
	dave@stgolabs.net, wangyufei@vivo.com, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-mm@kvack.org, gost.dev@samsung.com, anuj20.g@samsung.com, vishak.g@samsung.com, 
	joshi.k@samsung.com
Subject: Re: [PATCH v2 05/16] writeback: modify bdi_writeback search logic to
 search across all wb ctxs
Message-ID: <64svwwe2zosyjibtzmhxj4fvffhzlmntrf2fsxlh7jhj33c5wl@h3vqsl74fihv>
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
 <CGME20251014121036epcas5p17c607955db032d076daa2e5cfecfe8ea@epcas5p1.samsung.com>
 <20251014120845.2361-6-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014120845.2361-6-kundan.kumar@samsung.com>
X-Rspamd-Action: no action
X-Stat-Signature: d8o4rpapoememb489ndatrrqk9xxz73t
X-Rspamd-Queue-Id: 2A47D40003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761048346-245826
X-HE-Meta: U2FsdGVkX19fd3UgC46G/7StQeXE6tPNPMNddYqtR7/VdmvoM2zB/V632MpDYxdOemLw5KwE04EM3hnOnnTlIHL5iNoNWm7PYJO/ONNFVqbexE360ldFXcmbXKBahLfAk8pXvilpZZ6gn5Vj9GpPPSxKQ/U54/1tyhojULHWFUJRWQkMi+kv1m+HPdLno30xtlJ8MAmg4fZR2HWh1XC8mr77oV+oRY3gR/pHvv3WRczTEFw0x+DvXA1xPf/pptR6P6yo8KxGTwW/Oy5kwOObJ81uQeni7BAsghqH0Szl4E6V++h61bZvR6QP7S7BEjkIxNfWzRt7oY6RoyoHt6L/uTXIxd0t8C1nKjBfN35nBc3oQ12le4LAoI3ux9N+XY9yZ6Ppf0Tx2Yak3fElIP25I9vO55iHd2o33hJ0j015I6yp8vsKRCRtLw4JCOZxGJ9m2d0wPJfkZleUL9TS0LjePoFF1LwNjA7XwKigKAeTg/Gb2uXKr/h/Cbz/+c1HBVRjSVpQ6l51Q9B3S7vmhEzQmTjldcmxv/oJS+YSDjMmjP2Y1pVtZjnDQc23HNYy3DXGm/cfDG4cwQJ54Yn46eBCreLl9nWXjUZ6e5S2zEcgbfxo0nyiCh6wpl6cafi+hzmnTayu6FnWUkJuUP0S8i5ZjzBlXfwqQQQuenHzxOB3sYT/PkpcBYpWKqvv07wlBWOkYlrfV45CAd+v7Il1ShbjOwBquOfIlOUcYMqTq/S91ljDkve4xKOZrmH27436kDU+1FWMeiQM5OKCzoZeoofwD3kX7WIeutCrArin5ZMILF1Y1BNxt33hpDEn6RaCP/Q2/u6Q9x1w8wcnOKlqNDQ6QKW1uNFj29Mdo8Bpz8YCgQ/AYTDed/MyeraJEXadcN4Jzo7ZbujR6miTJHkpgyH6maVo8aiRplg0vqGGINC0dYMElsHxAYypuG/JpR2MUcS00dJbNRwoTLV1O49W1vb
 ubJvVPCk
 WSpGc5+wSmuA4OnV9AIqkkGpLqHJuyVJIy2xi3Pirr5e4YmpDoE2NsVEnNpvypsi9DX/Whl0EE+przaU9FV14Id4JM0S5oAjzqHVfJXt9WkVtu1s/FJ2gMmIyFi/CWSzAVA767AYa7qX6IrvORw8yl5UcbcZcmh02LK9IUsyaEo/6S64D1ERbMJ1wMHCZ5SK7aWJNVV40T278pKPDMR2EohnbgG4dJWXdOuxrJTzcuKoWNA/HwLy8XvNAi4JWTraH61hi0GgkGWLCLOUbKHyybSErve5tymrAg4BXXRf8Arm46JSspXgGap/ljaHzQRTH02lMuzzekzH6bpgLhviEI7pSF7Y7s8chr3wtWRsw2ZLNVGDM9H6BUJ4EPl7+HRHbYinvrX8v+Pjel9rC72fbnjOaJ1QGaFKpDjsh52g62zTMmmUD/HuHNIOk3SfN0VzQBlJ0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 14-10-25 17:38:34, Kundan Kumar wrote:
> Since we have multiple cgwb per bdi, embedded in writeback_ctx now, we
> iterate over all of them to find the associated writeback.
> 
> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/fs-writeback.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 56c048e22f72..93f8ea340247 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1090,7 +1090,8 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
>  {
>  	struct backing_dev_info *bdi;
>  	struct cgroup_subsys_state *memcg_css;
> -	struct bdi_writeback *wb;
> +	struct bdi_writeback *wb = NULL;
> +	struct bdi_writeback_ctx *bdi_wb_ctx;
>  	struct wb_writeback_work *work;
>  	unsigned long dirty;
>  	int ret;
> @@ -1114,7 +1115,11 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
>  	 * And find the associated wb.  If the wb isn't there already
>  	 * there's nothing to flush, don't create one.
>  	 */
> -	wb = wb_get_lookup(bdi->wb_ctx[0], memcg_css);
> +	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
> +		wb = wb_get_lookup(bdi_wb_ctx, memcg_css);
> +		if (wb)
> +			break;
> +	}

This is wrong. We need to run writeback for all bdi_writeback structures
for given memcg_css. Not just for the one we found first. Otherwise
cgroup_writeback_by_id() wouldn't properly relieve the dirty pages pressure
from a foreign dirtying of a memcg (see the big comment before
mem_cgroup_track_foreign_dirty_slowpath() for more background on why
cgroup_writeback_by_id() exists).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

