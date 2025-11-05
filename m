Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FBADCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964378E001B; Wed,  5 Nov 2025 04:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914438E0005; Wed,  5 Nov 2025 04:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A868E001B; Wed,  5 Nov 2025 04:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 709628E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:50:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C92F12B350
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:50:31 +0000 (UTC)
X-FDA: 84076083462.28.5E9A77F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6C8964000E
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:50:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sJ5F9DRo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iQMwDzZ7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sJ5F9DRo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iQMwDzZ7;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762336228; a=rsa-sha256;
	cv=none;
	b=QOHcJZ+XX+T1nb97WGGde27ZTy27eW5Yaxmwe0Ufca5v7nGrnVmdqTcNCSARNrH8yoPHKn
	1cqWfGUd6DYc5cMU9ORhicbfQRX7JELeMLy1wAL0d9TPh46y++c0Z34dCKI0xqsFP9Xg20
	K0Xs29uG0mw9BFyYTDQb8vNEb+X9Vz8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sJ5F9DRo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iQMwDzZ7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sJ5F9DRo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iQMwDzZ7;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762336228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cY5ii2iDdhZ8VdCxHaGIdjUSBVcQnRly9m7bibgj8xY=;
	b=idRNVZiR5fzhFF+XnwpbuPRxNnNvwT87nuxrU7QWo27xdmDmr/Q5odBa8NVXDVRRc4dpH9
	9qOF3Q4gKPmN1sKGjaL5f8lcboE+ID5WD02KcaSfOm6k9QZVu5S2S3gjh9ZZd56AtFYCb0
	zxiZjQYNZuDsUpagZOEIutfIofydnfU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9438F21190;
	Wed,  5 Nov 2025 09:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762336226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cY5ii2iDdhZ8VdCxHaGIdjUSBVcQnRly9m7bibgj8xY=;
	b=sJ5F9DRouVc6UaiCoRTKMPUvE0xokRFGY3dcZTAt0qjt3Wh5IprrWhyNm7HicsXAy/UYBb
	LvEIyHEPITaNtLJMzxryjzcH+3zJnuttYdx1p6GqMtoYsmiQvzkokXlRPXKzTwVBqogq9R
	FhvZelBXeB+6gdHd78Yq0N6yZDwjUfI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762336226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cY5ii2iDdhZ8VdCxHaGIdjUSBVcQnRly9m7bibgj8xY=;
	b=iQMwDzZ7CiXw/caoRiyc8sBxyuvzbbxUp90wjCTqSNANDiUPnE7I+X3wFP0+zm0ZAqvVIq
	S++hRsEQPjJ1pRAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762336226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cY5ii2iDdhZ8VdCxHaGIdjUSBVcQnRly9m7bibgj8xY=;
	b=sJ5F9DRouVc6UaiCoRTKMPUvE0xokRFGY3dcZTAt0qjt3Wh5IprrWhyNm7HicsXAy/UYBb
	LvEIyHEPITaNtLJMzxryjzcH+3zJnuttYdx1p6GqMtoYsmiQvzkokXlRPXKzTwVBqogq9R
	FhvZelBXeB+6gdHd78Yq0N6yZDwjUfI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762336226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cY5ii2iDdhZ8VdCxHaGIdjUSBVcQnRly9m7bibgj8xY=;
	b=iQMwDzZ7CiXw/caoRiyc8sBxyuvzbbxUp90wjCTqSNANDiUPnE7I+X3wFP0+zm0ZAqvVIq
	S++hRsEQPjJ1pRAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 84C0813699;
	Wed,  5 Nov 2025 09:50:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uPFjIOIdC2lZMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 09:50:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 381C2A083B; Wed,  5 Nov 2025 10:50:26 +0100 (CET)
Date: Wed, 5 Nov 2025 10:50:26 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 21/25] ext4: make online defragmentation support large
 block size
Message-ID: <vkbarfyd6ozrrljhvwhmy2cq23mby6mxl2kxlsxp2wqgmvxvgi@6sgmqhhdnmru>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-22-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-22-libaokun@huaweicloud.com>
X-Rspamd-Action: no action
X-Spamd-Bar: /
X-Rspamd-Queue-Id: 6C8964000E
X-Rspamd-Server: rspam07
X-Stat-Signature: q5iibpbwobmeppp39zbrtk1mwnw5sdwa
X-Rspam-User: 
X-HE-Tag: 1762336228-505059
X-HE-Meta: U2FsdGVkX19intT6Tq9d3//MMtBak5lQwKxMTI1lAuWx35UB104QzjRgmZQ8CyyNK5xFlf75829wi9v9KGLNypkBFueLQ1/9+VBgVCAiWZ7qeEG9wUuqJ65CxHPlMJv2StMQO0DADtVi/qiq/JajzQ+d1v+CTi8Xv9suaxDFrvqRXUyMdyh/RHSNxnbCJPqlG3TNT1GzvCkXaCmGcT8+/G8YRpS7K/POUkqY6cSMv4Ww0UGOktHpa2l2AsG0unHRil9un2+91F0Wi5x1OUY4yvH8nX5vZV+ZDkd5jCu7ywARLdvDebeZj/jVMRNdx/OqIjJt44tVkrTpoXhu5hWdJx66Jx+KQ7Ajb9gMLICXYwubR6ul4nzjlOlraFce26hSenjAQVSxrXzrFNEcsNxju8tSaV5SlnaPqXGP6UcYdlY/aiSPpeN1gpYuHG5S/W3+cGlVVI0Qvsr3GPIqF2hlJ+GK/PIoQDJI8OxxPt+6d0PigTRuL4Nx7Cs2M6si/StMsW58tUyLa/dL4yLGbbBdffpFFq3FGH1RthJ/yTyGHxVBeIKAU/Cn37onBlskP78mMuPOOCQRtFSA6dzEl3mTX4pUZ5tdjvhCilQ+Xvrqxe+X1qNs19WqYy3csH6Chka6nfkaQeRat3Rq0hvACJ5zU1a8563tzL008TCetovpgooJBhymkInVNZtyATHDfapSaaC4arh7ILRcMEJQT2VNbEv6JzDwk41tryARjaV7sk7wgtpGA87Z+EJlcOgtgISMF682UjHcbaRGNWO0Rl/YM++5BkaR+F3utWePRm97lqq7+h2vHBKiT6kynMwd2WADVFH4awzgsArHgY8+JLnd/S8FokhpWdxt2OiBlRGB2d/6AoBfj2iFQd7gNQXBn12cbcjMu+T0gWuq6GwqJxL0WplZCPJGvxtv31vmigfD9Lwt+Kpj0gJRExJpAH1L/6ZbYQl5O1F41dcU1/k1TEA
 OMizPbjy
 XNms/7rIiOFS/7v3LKVQfzzwUstULobbEFfsmOGSInMDvP0y6zXVcTpnCWoOkO3H0D0dHdavwIKQujhUFKhIVq00t9jcb8zpsBx0O1vIo6YWIM+TNSJyj6H1wFkvMizpgx+D+C1N9zOmJo88envEVhva8k/b0wPTSRSMQRvVmqSCtmU4EEj9P6+kOLCWdVhctmP+wLcYn1nqf5l58o+IwUvVuVrKqGPoKVYzfhp+wQRRWK1d8xylp9klE931e1m/L/PI5rBIIzrwouYAfR194x7vjHd5vxOe6riPrYcYs1JSCvXknccIvEAcXdSBcRV0FbmFg2ZHTrCJ+f6xsqCPdD8/sZD287++nu71qCFgkS1+Ckqixv3aXJMUqwL0pwfrNaFfX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:17, libaokun@huaweicloud.com wrote:
> From: Zhihao Cheng <chengzhihao1@huawei.com>
> 
> There are several places assuming that block size <= PAGE_SIZE, modify
> them to support large block size (bs > ps).
> 
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>

...

> @@ -565,7 +564,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
>  	struct inode *orig_inode = file_inode(o_filp);
>  	struct inode *donor_inode = file_inode(d_filp);
>  	struct ext4_ext_path *path = NULL;
> -	int blocks_per_page = PAGE_SIZE >> orig_inode->i_blkbits;
> +	int blocks_per_page = 1;
>  	ext4_lblk_t o_end, o_start = orig_blk;
>  	ext4_lblk_t d_start = donor_blk;
>  	int ret;
> @@ -608,6 +607,9 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
>  		return -EOPNOTSUPP;
>  	}
>  
> +	if (i_blocksize(orig_inode) < PAGE_SIZE)
> +		blocks_per_page = PAGE_SIZE >> orig_inode->i_blkbits;
> +

I think these are strange and the only reason for this is that
ext4_move_extents() tries to make life easier to move_extent_per_page() and
that doesn't really work with larger folios anymore. I think
ext4_move_extents() just shouldn't care about pages / folios at all and
pass 'cur_len' as the length to the end of extent / moved range and
move_extent_per_page() will trim the length based on the folios it has got.

Also then we can rename some of the variables and functions from 'page' to
'folio'.

								Honza

>  	/* Protect orig and donor inodes against a truncate */
>  	lock_two_nondirectories(orig_inode, donor_inode);
>  
> @@ -665,10 +667,8 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
>  		if (o_end - o_start < cur_len)
>  			cur_len = o_end - o_start;
>  
> -		orig_page_index = o_start >> (PAGE_SHIFT -
> -					       orig_inode->i_blkbits);
> -		donor_page_index = d_start >> (PAGE_SHIFT -
> -					       donor_inode->i_blkbits);
> +		orig_page_index = EXT4_LBLK_TO_P(orig_inode, o_start);
> +		donor_page_index = EXT4_LBLK_TO_P(donor_inode, d_start);
>  		offset_in_page = o_start % blocks_per_page;
>  		if (cur_len > blocks_per_page - offset_in_page)
>  			cur_len = blocks_per_page - offset_in_page;
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

