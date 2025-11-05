Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F269BCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE808E0015; Wed,  5 Nov 2025 04:18:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5758E000B; Wed,  5 Nov 2025 04:18:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DB708E0015; Wed,  5 Nov 2025 04:18:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BA748E000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:18:50 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB69057CA7
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:18:49 +0000 (UTC)
X-FDA: 84076003578.14.3C3402A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8205580003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:18:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="L/5v6uA4";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ntew6u+s;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mGFNUeh0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wqB1cCja;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762334327; a=rsa-sha256;
	cv=none;
	b=60sNMRCfYBpWWWHbJuO6tEqPnTaCLTzF89JXDCl3oLW0ERugs3CDEqYZ/RGdp3xs1g/avl
	oHwuge806d96szjJ4DhsyEvkf8VEECXrkFAD1tl5fzNKhH8y1P/+vPgGKgxN3LDxiWE1rd
	U+oSkDb2zV9waeQCXUvP8n282lmaOuo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="L/5v6uA4";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ntew6u+s;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mGFNUeh0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wqB1cCja;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762334327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUHNWHY9N3N9CS8EUbNMZ/Hd+PugtBGD/ByWJUAr0TI=;
	b=iCH41BsYgp5ED1EmoX50k7Qo1sHXcXVBykjkQc7x1IOPOaSN73+bi/BIeSfEgFnDqXotQJ
	GF+TwcxqkHsrU85ZYyiV7z2Y/NaYoP9uvbbozzXSCLbs3SIUnlhE2lN2dv7N7i4AOnWJFq
	lkkmWnzLjSrmh2z2QZ5BMr0WLqCKx7w=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C54941F394;
	Wed,  5 Nov 2025 09:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762334326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dUHNWHY9N3N9CS8EUbNMZ/Hd+PugtBGD/ByWJUAr0TI=;
	b=L/5v6uA4jQmSUe+rmgFBMs0e+y2W37fa7N280Puhbcx39WTudZhEP8yb73+Kh3PaDt3Dpr
	WN/EDq/88YX9ff4cM0s+7dFKXUxR5lKDMDbsk8CUutWp72U0VW0I340ELI8aNXZs935Cn2
	GZOdEA1hTEo1AYEnc3u7eQ7v4opA87w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762334326;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dUHNWHY9N3N9CS8EUbNMZ/Hd+PugtBGD/ByWJUAr0TI=;
	b=Ntew6u+sECbXiA5T5xacYOSTY5OVu0yTDT/4kR8DOnxfwC19o2aWC1J1OGC//T9+6vkdMo
	OIKnIlMg1U//vKDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762334325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dUHNWHY9N3N9CS8EUbNMZ/Hd+PugtBGD/ByWJUAr0TI=;
	b=mGFNUeh0F0IXW9J44zNqtXoSYn8Iv/jo4aVX6RTO5WxoiSp4Ac4FxuLPj4JEPniue7pXlk
	qSumBQF3S5UC4cn0a7d6F8tnhlhf3mXCmtXBRtXjZ17onU2xEGnx3HLh5REZ+9KiXBufPz
	fc2H4UnNVKqcyW498Od7EYm564lyRZ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762334325;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dUHNWHY9N3N9CS8EUbNMZ/Hd+PugtBGD/ByWJUAr0TI=;
	b=wqB1cCja5TwBB4BQFUcTqubtIQ0/vgQreTWbmreJZ9MI/nryCjIlyhENWTiKDFCj29ycjE
	q4+9xbce/WUxcGDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BABE5132DD;
	Wed,  5 Nov 2025 09:18:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id reiVLXUWC2lPEgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 09:18:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 74665A083B; Wed,  5 Nov 2025 10:18:45 +0100 (CET)
Date: Wed, 5 Nov 2025 10:18:45 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 13/25] ext4: support large block size in
 ext4_mb_init_cache()
Message-ID: <n3jvaazkla3usq5vx4kxsfkr33d2mwm4eu7xpgf7qssktmjwgu@btxoicdj3vrr>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-14-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-14-libaokun@huaweicloud.com>
X-Rspamd-Action: no action
X-Spamd-Bar: /
X-Rspamd-Queue-Id: 8205580003
X-Rspamd-Server: rspam07
X-Stat-Signature: 5dqphjndxpwbpmifhyy91xqipout9j6b
X-Rspam-User: 
X-HE-Tag: 1762334327-249627
X-HE-Meta: U2FsdGVkX1+hnkRD8a/g5dNggW1ADVtXuqYlQyCGEtOc/skj13teAt7jE4VSwBzpOzxzRXBRARNjssFTsJYFFLozvyEobCpZBVDqMNYheHr4KKLyAJPydaDCthIhTT3a/VXm1VR0xDNtILEbi9T/41h10smz9SGyzRK2hnb+2z0iSFJmA1MIN4D17ADwFW5FsGg+lWzbEMTHB2wZk9BBE9jsYVWcgb/JQLsZCyO+GMLHT6qwdPrjcR74R5S45ZiNUEBg0qHvc4UqrzpLBEGMoThtKnN7mR/srTknFcfYiFqJw2LP2oTS2owElgscngwMhKjdGvJBqUALrOQvFq7YifcoF+dkVhsslYkMMuKfVQiOy/rQ3Emyk5KZMD+JA4Kc57Z/LMrksjyG2v7xYm+kyDOzuWZ0XzbmSyoWlo1Eyp7BbipPAnBqP2a5b3QcMJDNfqzhUT1GC2jSZwUl2sYs9ppFHVUxze8kJ/8f1wdlqtUSnSmDn5N8wW/8BbPl5N1jQNyClEBfWDtU4EfTzgRTyy9Dif3y5gBo8kUHUwuT8amGwN7VfU2eWIC+wAA2+Ij82tKHfA+oiUcZ2l9rDZGfYOtZgmpZ/lt2mKNs++v0ISIcIX7DkylXi7YtQohrCeawsJ5oW1UReON7ALpGpB5kLPE/HXi19K8ooR7beHuagmRk1c2gqdUanP3lnyPp96VePQvS+QdMqZ1o8kPNMGhvn2v76GtNiZfd0bQHrg4rL7k51NP+MR1Nbj3J6zPSJoN5nWTKEM8UAJysc1octqKvxShDMPtQ8Az89RESQjM5J0Vzf4FdxLthnOW6xw83s0yUIn6HSfPbxsL0VbzXd+DDsQ9ElQscZs3kcbBjEOAIo0A/t0r7JLzGV5PoGiq64GVPgDsPr4TxSSXxy7Zv7E1O/W26UTbsc/sHmuni5gLkgqybDkRusCmmwBN1CizHBkIMonffboY2IJuFa+jkNlp
 VRDHoLvB
 GF+m3FlgFXVCx0mjEs6T8Qo408kakRlyIOBedEzl/tzngxM1eoqV1JdVK4ppNDlZ2mUEaOZ1ew1qpqjd2AXti03Myw2/ZJbPInFZNlQG5jv8CDMLqEJkdgPCX0+qRP7CqujQgIR3V2TzfaQnhcSZVk3O5eASuKpdvwBfZcl8/+rkgueJasJmq4X2114Hg5/sKmoIe9Q4pPsIKvKesLdzd67gJNc0mPagJbBLU8tTnZ4MrtZNBaa5N6catBMC+c0L8B1zL+Y6afykO0Zw0DrdGkDHtiOWeXGmwNdwWEJJI1JGYQjFWrdfSncRD6T5+xn9sGBI9KJPcd+iXT3pQpDyqSQfBvDQHmz8kL/eVOlRx9/VRUVc2pkhV3M2fz+W03+SRti6gUEZJ5EzytVWL9l00OiGg/xZk3L3YLt/YbdgjPimnvPvfVzhHXHMn0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:09, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> Currently, ext4_mb_init_cache() uses blocks_per_page to calculate the
> folio index and offset. However, when blocksize is larger than PAGE_SIZE,
> blocks_per_page becomes zero, leading to a potential division-by-zero bug.
> 
> Since we now have the folio, we know its exact size. This allows us to
> convert {blocks, groups}_per_page to {blocks, groups}_per_folio, thus
> supporting block sizes greater than page size.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/mballoc.c | 44 ++++++++++++++++++++------------------------
>  1 file changed, 20 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index d42d768a705a..31f4c7d65eb4 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1329,26 +1329,25 @@ static void mb_regenerate_buddy(struct ext4_buddy *e4b)
>   * block bitmap and buddy information. The information are
>   * stored in the inode as
>   *
> - * {                        page                        }
> + * {                        folio                        }
>   * [ group 0 bitmap][ group 0 buddy] [group 1][ group 1]...
>   *
>   *
>   * one block each for bitmap and buddy information.
> - * So for each group we take up 2 blocks. A page can
> - * contain blocks_per_page (PAGE_SIZE / blocksize)  blocks.
> - * So it can have information regarding groups_per_page which
> - * is blocks_per_page/2
> + * So for each group we take up 2 blocks. A folio can
> + * contain blocks_per_folio (folio_size / blocksize)  blocks.
> + * So it can have information regarding groups_per_folio which
> + * is blocks_per_folio/2
>   *
>   * Locking note:  This routine takes the block group lock of all groups
> - * for this page; do not hold this lock when calling this routine!
> + * for this folio; do not hold this lock when calling this routine!
>   */
> -
>  static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
>  {
>  	ext4_group_t ngroups;
>  	unsigned int blocksize;
> -	int blocks_per_page;
> -	int groups_per_page;
> +	int blocks_per_folio;
> +	int groups_per_folio;
>  	int err = 0;
>  	int i;
>  	ext4_group_t first_group, group;
> @@ -1365,27 +1364,24 @@ static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
>  	sb = inode->i_sb;
>  	ngroups = ext4_get_groups_count(sb);
>  	blocksize = i_blocksize(inode);
> -	blocks_per_page = PAGE_SIZE / blocksize;
> +	blocks_per_folio = folio_size(folio) / blocksize;
> +	WARN_ON_ONCE(!blocks_per_folio);
> +	groups_per_folio = DIV_ROUND_UP(blocks_per_folio, 2);
>  
>  	mb_debug(sb, "init folio %lu\n", folio->index);
>  
> -	groups_per_page = blocks_per_page >> 1;
> -	if (groups_per_page == 0)
> -		groups_per_page = 1;
> -
>  	/* allocate buffer_heads to read bitmaps */
> -	if (groups_per_page > 1) {
> -		i = sizeof(struct buffer_head *) * groups_per_page;
> +	if (groups_per_folio > 1) {
> +		i = sizeof(struct buffer_head *) * groups_per_folio;
>  		bh = kzalloc(i, gfp);
>  		if (bh == NULL)
>  			return -ENOMEM;
>  	} else
>  		bh = &bhs;
>  
> -	first_group = folio->index * blocks_per_page / 2;
> -
>  	/* read all groups the folio covers into the cache */
> -	for (i = 0, group = first_group; i < groups_per_page; i++, group++) {
> +	first_group = EXT4_P_TO_LBLK(inode, folio->index) / 2;
> +	for (i = 0, group = first_group; i < groups_per_folio; i++, group++) {
>  		if (group >= ngroups)
>  			break;
>  
> @@ -1393,7 +1389,7 @@ static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
>  		if (!grinfo)
>  			continue;
>  		/*
> -		 * If page is uptodate then we came here after online resize
> +		 * If folio is uptodate then we came here after online resize
>  		 * which added some new uninitialized group info structs, so
>  		 * we must skip all initialized uptodate buddies on the folio,
>  		 * which may be currently in use by an allocating task.
> @@ -1413,7 +1409,7 @@ static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
>  	}
>  
>  	/* wait for I/O completion */
> -	for (i = 0, group = first_group; i < groups_per_page; i++, group++) {
> +	for (i = 0, group = first_group; i < groups_per_folio; i++, group++) {
>  		int err2;
>  
>  		if (!bh[i])
> @@ -1423,8 +1419,8 @@ static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
>  			err = err2;
>  	}
>  
> -	first_block = folio->index * blocks_per_page;
> -	for (i = 0; i < blocks_per_page; i++) {
> +	first_block = EXT4_P_TO_LBLK(inode, folio->index);
> +	for (i = 0; i < blocks_per_folio; i++) {
>  		group = (first_block + i) >> 1;
>  		if (group >= ngroups)
>  			break;
> @@ -1501,7 +1497,7 @@ static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
>  
>  out:
>  	if (bh) {
> -		for (i = 0; i < groups_per_page; i++)
> +		for (i = 0; i < groups_per_folio; i++)
>  			brelse(bh[i]);
>  		if (bh != &bhs)
>  			kfree(bh);
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

