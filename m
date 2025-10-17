Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E97A3CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 08:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4320D8E0007; Mon, 20 Oct 2025 04:56:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3398E0002; Mon, 20 Oct 2025 04:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D21D8E0007; Mon, 20 Oct 2025 04:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 150AE8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 04:56:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C9C6140762
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:56:51 +0000 (UTC)
X-FDA: 84017887422.11.DDE5B4C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3A2282000C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:56:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TlxL9JlF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gXXHg0Kl;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vzvzZxbD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VIksI5YE;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760950609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQY0APsh278CNyuTjNL9Yy0qeDKE7+Zcmc3dmDr7Y+M=;
	b=FqRAv7MZTJhZygsCxKkpxyuAJqj7bO+gZXneHItQW0luY/0EdfRn3EkFc0NAdJja+FTo8h
	pYzALRaz4+LJgaMWVdGXD30H0DVICE0VLOYH0JG/Fu9c6jaydIhxn9mLfk1uH7HYmuW+Ll
	yffGLekpqwnm+xb1oaMcKE1BAJdPRTs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TlxL9JlF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gXXHg0Kl;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vzvzZxbD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VIksI5YE;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760950609; a=rsa-sha256;
	cv=none;
	b=5VWvGssjGyuk/V0HRqyJ0dvqqKILMgtuP4pv/P5s/9y5hyn4c5UmUCJHzC1fcA8c/hC4ew
	ZlGcsW/cZj9PBSiO0wy9WTacH+6ZwcROxYKk97v79a9WmK2V/18TOlGyVGY+GmUr2LY6a0
	2V0vi+ACsGTLH7FqTohMyZHmoCeCTZA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9D17D211B8;
	Mon, 20 Oct 2025 08:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760950603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fQY0APsh278CNyuTjNL9Yy0qeDKE7+Zcmc3dmDr7Y+M=;
	b=TlxL9JlFKAwndySpNh1I4Xnpg+anKZtDS2y7PLBVYdVZB7gGE42Eft7flIcOwlzJekyb/H
	8xSmF1RB3x9rGFTUoA/XbcKXE+2tJb3vhLo5sjnVbnD4s9zN3ZbR179yMu9iNcfSEXNUYT
	nmrBvC7TgqeK3yd/Fnoi2eMkjwfbmIA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760950603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fQY0APsh278CNyuTjNL9Yy0qeDKE7+Zcmc3dmDr7Y+M=;
	b=gXXHg0KlWO4+TWtwoeLcQuoEG3EdCqDE8es+TnpxNAm6kb5Dyc5GZDdHWM8MsMpm6/Iaxw
	xpo6pO7tMr9c0FDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760950599; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fQY0APsh278CNyuTjNL9Yy0qeDKE7+Zcmc3dmDr7Y+M=;
	b=vzvzZxbD2eARALY0nC9MdjGZl7efuKpM85/ydlJTdvKl9hrU6/UuhQ6gXc2IXvUXRNITjB
	uZluy1E4oNR15ymaxudBDLqfL6yO1zouznWc02xlGpbN9vPCoqK+HBeCsoZTCtsc4zTKVr
	efmdxJ11prXT1MNcDmBeES6yxqJYtss=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760950599;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fQY0APsh278CNyuTjNL9Yy0qeDKE7+Zcmc3dmDr7Y+M=;
	b=VIksI5YEww7h0zhiJyytFnfGeUaB4o1TdSNVirrjWiwXZf3WwvJPHnoF17PXG29f53f3nR
	3Nd2dZzJa75SJPDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F15513B08;
	Mon, 20 Oct 2025 08:56:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 94SMB0H59WhgZQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 20 Oct 2025 08:56:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A4D80A28E1; Fri, 17 Oct 2025 14:31:06 +0200 (CEST)
Date: Fri, 17 Oct 2025 14:31:06 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Carlos Maiolino <cem@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, 
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] writeback: cleanup writeback_chunk_size
Message-ID: <wjk2656emsjxsyjm2l7qnsaeg5oospkhwxp2gt3hhj4jsr5ul5@5aps7ijypzol>
References: <20251017034611.651385-1-hch@lst.de>
 <20251017034611.651385-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017034611.651385-2-hch@lst.de>
X-Stat-Signature: qghxdk5p714x8x1iec91def3ryc5zokn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3A2282000C
X-HE-Tag: 1760950608-840793
X-HE-Meta: U2FsdGVkX1+uzfg1a+0BwZ9eaQ01AqcMNTsTssTeE3RxbfeAPVcRRJ13/L3+qXe1EoSkDMl1UiBnrGf5tX9tgtXTejHH7WIC73dD2Y1jZba21xlgkfZzQoMIUZVzAn+SUrXCuA1MANGTgChpw3TkC3/s4Y/wmqsedkwgljrytPASvyigBu1ZTWRpOCPpElv3IEEJlpEcuEDJMdcI8d6+wwJcl0phpoqSNoeLkx5Vlu4ql3QvyM3X6Z2piOzwF5WqjyXVJ83gtl4Gi/6K568rtD21u9sqHJt0ADk2Zj1rmooCoYoGjN6Tu+eLSav8i6YEr5eKRX4zRLwMpLaSUm438xqnHa0GD9xFjm3s30etkiKRVvDgu7Crg0oU0BgyV+lI7kTMwk6QDHnungbiPcikaoG2h+iiYNqYLww6k1phS04iwk1iQiX78JfhTcprevczVenV0GaIVzV8xjKYtk+0uCqMyw23VH7mzEahi4VOWY3r/nBEtDJgoVX9YWRu76JM10H+2TIQP3LFqmN8Ke7MG5DRvhf+Ra4/9UiqZdZUCSL+rQUS64CBwIDT/7jy54I7soPW8NNq8iBgP0lQ85fCN2a/imYSyzMKMrYl4DOMBux++eSyJkqIuuVLnW1ktjEBklu7qNQxV+wewgOXOT+rzGEPeplnlqBHsjedx77Nwjhc8Kp3VwNf+09Hi89c23T6pffRUGW6eFcvEqMJC0X9cKZFvdf8sn+MgOcC2U1DKJje4uF69BS1x0evDH2JNntlLja/nkEK29RXeSIHToH4ChlvGV8IQ/ikKjgmQljidnYNCoLYnZfj2KlC63sJLzvKIZp5b1UpIcNkJvvLfCgsx5v5lSX+VOBGd7chrhhglzIaO4ylOAN2UIt8+S1RnmQ+ZH2ObwH/AE74QH1VPmRMRWroHZ9tvL7CyeVUXNcEC+A5rLKNkytx1tXz/UoKOjTq2S+eSsbfNXpcmPT0K2q
 cVObeNy6
 YEyLH1vtrzjqaf8D9ItKneRQuwO9v4iS8cO9He0fgb66SDeDu12wVqkR6oR7ruMOOOJ5RypxC06w/Ms7TThYPx9eT/gNUUHWsj28hyuNoUNi67xMhVmSdFVzVvue/2ZlIXpbOx6wFf/9mWiMfFZxyj7Pda4bmhHHeUCXECt786HpfbntvTEEzFxooDa6mjwlclWiOfteaVL34hS+obj9EZh/drKCu1TIVcRCpmLoJeJa9UeVdM1JMs0M203O00/NU7ysjk3xKlQ0o9b0LLsRdZ7MTfst871zdvCLZL8VCgPWZTqZVfmzu/2RVwiEFfq2skzJRvPJsfezaZe3A8qaMZRDbZ0ZLZeHuTtyoGF/X6aF0uUUlTNtQOs8cmQX0pPfGZibRwBF9tAt3upFyIJjxAHQ/1HlQRTLG5/vzZGSoQd/+gHaStg6NwOns6Xp3233OT4Bv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 17-10-25 05:45:47, Christoph Hellwig wrote:
> Return the pages directly when calculated instead of first assigning
> them back to a variable, and directly return for the data integrity /
> tagged case instead of going through an else clause.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

I think I've already given my tag to this patch but anyway, feel free to
add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/fs-writeback.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 2b35e80037fe..11fd08a0efb8 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1893,16 +1893,12 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
>  	 *                   (maybe slowly) sync all tagged pages
>  	 */
>  	if (work->sync_mode == WB_SYNC_ALL || work->tagged_writepages)
> -		pages = LONG_MAX;
> -	else {
> -		pages = min(wb->avg_write_bandwidth / 2,
> -			    global_wb_domain.dirty_limit / DIRTY_SCOPE);
> -		pages = min(pages, work->nr_pages);
> -		pages = round_down(pages + MIN_WRITEBACK_PAGES,
> -				   MIN_WRITEBACK_PAGES);
> -	}
> +		return LONG_MAX;
>  
> -	return pages;
> +	pages = min(wb->avg_write_bandwidth / 2,
> +		    global_wb_domain.dirty_limit / DIRTY_SCOPE);
> +	pages = min(pages, work->nr_pages);
> +	return round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_PAGES);
>  }
>  
>  /*
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

