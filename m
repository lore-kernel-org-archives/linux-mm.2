Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62110CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06388E0016; Wed,  5 Nov 2025 04:19:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDDA78E000B; Wed,  5 Nov 2025 04:19:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4888E0016; Wed,  5 Nov 2025 04:19:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AEA58E000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:19:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4537016020C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:19:32 +0000 (UTC)
X-FDA: 84076005384.11.0ACE7D2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id BFD761C0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:19:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n7CKcfUG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1OwZB+RB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n7CKcfUG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1OwZB+RB;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762334370; a=rsa-sha256;
	cv=none;
	b=ifO4iKIJ8FCFe+emAPxK6s73aUPgh+HdiwDo0gBBf4Z3BsZerrYiRqQX+UC/8GN9iEz7L1
	Z6u9gA3qYszyIOLk7pJrn2wuv634aDAiGqGF8OPa8DFjEOfcSZ2lBnxaKplqHImq+ziaNb
	RTV7iDc/Nah2XXyrBI6EHrNQXEmrLDA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n7CKcfUG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1OwZB+RB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n7CKcfUG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1OwZB+RB;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762334370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMwdMVhHhC8T39Jua7OgonrjFmJ+xRW6Om3Oi/7Ntz0=;
	b=A4/i1eJHfd73Y88jpwIOms7eTfI94ST1JJmA1AgqlZz8A3mI1WNAd6rtquguUjnFbgMHWe
	3I5qQaa0XAXLLzC+cwyxkZZYnFobaTkvDa1Zep6XosLOEVYm2oBKWCW5ksrrM+WeTVlSX0
	OHFtfAXOpV6ykxcay08D2X5tvLCxccc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0AC941F394;
	Wed,  5 Nov 2025 09:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762334368; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FMwdMVhHhC8T39Jua7OgonrjFmJ+xRW6Om3Oi/7Ntz0=;
	b=n7CKcfUGsA9pxtR/T6/gyIL9atCSLS4qFmqG0juDkMTcHntgxPyHmPNINv5Vt4kEy6rg+k
	1SFP7Q3BwUoZIS/TNRsjJTOAsPG9FZt99NA1xKyVRPPw+mY8CfgJzhDSCU+Anjwa3Ue+JJ
	jwFELPxZeznF7OPG81qgnuE1ZI0zDhU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762334368;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FMwdMVhHhC8T39Jua7OgonrjFmJ+xRW6Om3Oi/7Ntz0=;
	b=1OwZB+RBx2VqDiKFCkxeh+3Fmfs9jMP5GkHhZsXrYqIco49jEwEKwxJwENpp6AZwJBVuKX
	ZvRw0YSLC0UbpZDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762334368; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FMwdMVhHhC8T39Jua7OgonrjFmJ+xRW6Om3Oi/7Ntz0=;
	b=n7CKcfUGsA9pxtR/T6/gyIL9atCSLS4qFmqG0juDkMTcHntgxPyHmPNINv5Vt4kEy6rg+k
	1SFP7Q3BwUoZIS/TNRsjJTOAsPG9FZt99NA1xKyVRPPw+mY8CfgJzhDSCU+Anjwa3Ue+JJ
	jwFELPxZeznF7OPG81qgnuE1ZI0zDhU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762334368;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FMwdMVhHhC8T39Jua7OgonrjFmJ+xRW6Om3Oi/7Ntz0=;
	b=1OwZB+RBx2VqDiKFCkxeh+3Fmfs9jMP5GkHhZsXrYqIco49jEwEKwxJwENpp6AZwJBVuKX
	ZvRw0YSLC0UbpZDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E915C132DD;
	Wed,  5 Nov 2025 09:19:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Tu/iOJ8WC2mBEgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 09:19:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B1A86A083B; Wed,  5 Nov 2025 10:19:27 +0100 (CET)
Date: Wed, 5 Nov 2025 10:19:27 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 14/25] ext4: prepare buddy cache inode for BS > PS with
 large folios
Message-ID: <6beewixhvz3kfu33gz7silaiceywhuftyuplfnqsusrzwlsq6l@b75fxyfcmrkg>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-15-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-15-libaokun@huaweicloud.com>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BFD761C0005
X-Stat-Signature: yyboifu1o8rqzesf77z96nz77jett8sc
X-Rspam-User: 
X-HE-Tag: 1762334369-637328
X-HE-Meta: U2FsdGVkX197SOeoXbI4lQtzpVuvqRPvyS/UxW5JTTODKfnOjFejJdRXhuP38raqIKggE5EmMpLZ/7iq87D8Fm7mTauwKctBypIdWv4TUNbhXYYfTkVY63czTSqdXfZz35X1oUPpnZBELQH9Pv12qBuYku07L3aKRzirgDNhDOl24ODNnT8TDfZCTVle3vrxrZIDCVG019V7DLKHEYNZFWvHakwz96/MoRHiYl75TnDUk64125aJmGrlIdqGEpwK7XrxBGkapwdVy8md36CHpGPXcSHs3jIUn6dRa2jUz/9bYUsR+IDc3REHXQdxkCJNLv5a16NB1OYybDagyhPgcD8qcdcnZf6h/tOxba0Y9ijGC4EejG23hbTof3a7ySQ0KjMsewZm5IaPw5q42LD6xlbYVl9rx1jjEb0nVToYVHccLIQhdvZxD5s00CdAdAO/x9sS3pA2ktW6ImQyN1LoO+snuHR5n/ZwMkZOBLGFV+27CwC3KZfVrgi/ncz2XYEeb3Nc/DHdRMDLB1pyL5mnN1Ml+OCfJIPoZ8RcllXwCFxWAPPnnV7Ld9qreDJ/kZgXnR7odUFlBQ3hqhmvVYFuufr6d9da2Jq2ZZJ1QF06R38fmd/ma36x5jk/RfXLNjoh7x1tNYC6m5QyU3dV3kTWNo/IewrTugBCXHCF/eEsjo6xQuhc+rgp4LnTdH8MHiYepUalbAmUugkE86IrJUwMpcQ9P7h1UZy04w+z87CtaLf6nzp+/VwcmLRnxhDiqZDi/DHogLUUNqy+9Yhr0bnD55rx2LM20OZyvEYex4MEggz9SCz7UBhafgAjZymkqpojlglsd51yYxnAWHeKAapcrI2otFU2pQ6M9wKAzPhur+PiiP3U4yeHi0xE8sLdiEzpceR+bvBJDOkFCWOC4uLqUCVKRGV4iSo8IZ/BvWOXuAKzK0eMCdKcvBjm6079yeVyv9IZhBBdBQVKPU5GmZA
 8r1ugxWx
 AkrhaZ6FQy7HhMud6e2pq+V7iJ53jDr96ONZQLMAg40idkPsvY21vT4k2Tq7Jj6CvUXp7HngVsYRQpICUcZAxpJU/vo6YIN8Y9rBON/f5vaTDCRjsuYozIkFvqc3KJHgtUzLbGljzLvJsIWz7FM6YgBSYVbRswdz2J6Fx7yR+ixj1iDjEvM3u3kMiA006Tk42uwqHniel5MJHzLEW0Sb793aTK/kGNU59d4EY3W45wDYLEQVIG/skhnGSgS/HAmoek4GqwYQwIRxBByufSD8ZMOQN3DRpGKQWRR4AbpJ22vP6PC+SbgxI7qDDq3Nb3fIdSwnD6IiJ+oEMPy+5LPYN2ob/GTJsvdjnuyRsR+d3CEQEAC4M11OBpoIvYLCKd77kWtCG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:10, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> We use EXT4_BAD_INO for the buddy cache inode number. This inode is not
> accessed via __ext4_new_inode() or __ext4_iget(), meaning
> ext4_set_inode_mapping_order() is not called to set its folio order range.
> 
> However, future block size greater than page size support requires this
> inode to support large folios, and the buddy cache code already handles
> BS > PS. Therefore, ext4_set_inode_mapping_order() is now explicitly
> called for this specific inode to set its folio order range.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/mballoc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 31f4c7d65eb4..155c43ff2bc2 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3493,6 +3493,8 @@ static int ext4_mb_init_backend(struct super_block *sb)
>  	 * this will avoid confusion if it ever shows up during debugging. */
>  	sbi->s_buddy_cache->i_ino = EXT4_BAD_INO;
>  	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
> +	ext4_set_inode_mapping_order(sbi->s_buddy_cache);
> +
>  	for (i = 0; i < ngroups; i++) {
>  		cond_resched();
>  		desc = ext4_get_group_desc(sb, i, NULL);
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

