Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2410CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F4598E0027; Mon,  3 Nov 2025 02:42:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A50A8E0015; Mon,  3 Nov 2025 02:42:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFDE38E0027; Mon,  3 Nov 2025 02:42:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB6068E0015
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:42:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 926E31A0A90
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:42:19 +0000 (UTC)
X-FDA: 84068502798.07.C51F3E1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 55076180009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:42:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E2fj1xwv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="6/uq2ziu";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XuPUqwaR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eT2I3gKQ;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762155737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UimfoG96X1jvnyXzTz1B//n6UQMpn5oIqKnAct0hN4c=;
	b=lO/ShZMqiyIxs/J9cWkhVHqWt/iLRl80+IO/hL/pfhS/fn4jLU8yWHRqvyeg4hNax4Ca7L
	r0yNOtgvWUGobNKaega7u/sT1vLRwiVAxfYUBaAoG5k4y7snZYPpQrxxUn+U+5MstqSszg
	ob0YkNO6l1m2rwUYHWwcreq2pc78w0c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E2fj1xwv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="6/uq2ziu";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XuPUqwaR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eT2I3gKQ;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762155737; a=rsa-sha256;
	cv=none;
	b=mSGaGXxL/wCoDRBsfZuHbzuLNVQe95RA/7y3cDf0OqAeqYQiFW1cDiUBV1J/iPpGD2Txud
	MpQ5lfuFbCVcauXmGJejEGHrpUK+jrcP9bdyfMnagI5WwVn+tB9aSxGUahXJKQ0TySrdx3
	B/U3/Lhy5wrcdTwKRKQIvWbdO9n9dZ8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BE18321D91;
	Mon,  3 Nov 2025 07:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762155736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UimfoG96X1jvnyXzTz1B//n6UQMpn5oIqKnAct0hN4c=;
	b=E2fj1xwv0B+gyuP6qYpBTM7md69BXYUOjZPxuF8JoWVgi0aazNVCDfJUHVCkh33CtLKcDm
	O+VA91snFtoUyK8xI2DGKenuFbYRqY+BcJlwAymb1AFkjpzGKEKYqObOy2CaOR3rqVp47I
	/r2oE0Hu/qj1um83dnXReFOZ788D3ok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762155736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UimfoG96X1jvnyXzTz1B//n6UQMpn5oIqKnAct0hN4c=;
	b=6/uq2ziuGvsIQqpmyavnq9XJY80lnnyvGE/hhi5j5lKSzoqMg3PQL+RONXWLu5fgR5mJmM
	Jruvqcj5z3FxnRBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762155735; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UimfoG96X1jvnyXzTz1B//n6UQMpn5oIqKnAct0hN4c=;
	b=XuPUqwaRNb67Fp//e+jApIHky15QPii6rtbOqLcACZLNreQUWESyexkWth3+7en734lgmO
	NPMXuAUyOzxKWGgpBtAeulhPQCJBLy2FV1ZBF1bF+5t0hgGSj2yMLQjE2ugcILEWy2vV7y
	8HVaw2zH2XZTYYRLZ/arwFBrb5qbRNQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762155735;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UimfoG96X1jvnyXzTz1B//n6UQMpn5oIqKnAct0hN4c=;
	b=eT2I3gKQkdHL7CAykIvAckQpPuJL/WThAe57YUPfXR6NW25GxkKuk50ag44Zh1SIAUdtMH
	2Crn0lgXnBsE1fAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC08E1364F;
	Mon,  3 Nov 2025 07:42:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I679KddcCGlyQgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Nov 2025 07:42:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2DDE3A2A61; Mon,  3 Nov 2025 08:42:15 +0100 (CET)
Date: Mon, 3 Nov 2025 08:42:15 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 02/25] ext4: remove page offset calculation in
 ext4_block_truncate_page()
Message-ID: <bk6mmw6msixyg6boqodonkmyxrok2bkrhklosuwyxcipgmfdcw@3knvjhm4ggyb>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-3-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-3-libaokun@huaweicloud.com>
X-Rspamd-Action: no action
X-Spamd-Bar: /
X-Rspam-User: 
X-Rspamd-Queue-Id: 55076180009
X-Rspamd-Server: rspam03
X-Stat-Signature: 31cbcn9b11hb6ni361iejpyef3uin1ep
X-HE-Tag: 1762155737-169798
X-HE-Meta: U2FsdGVkX198jz/OWwSp69OFxncoicT9gqqwMTiZg/yWiZOhmyIMVyKluizTVrxr+BNd3dVRnJuihle5BlCEJUJFwGEElHmos7MyxNLq7mgV9Yq7kR62U2vkJw2/P7SJn9iLExO0yRlRFWKR7ft9GElFGUHw35/LX1YjHbJGd+vlOuUToITp4926qrad0Ftzw8JnmWJDRZwYFOvbeR8MJt23H+R/5CA/yRnlEVvQy3+jnDE10lUNSTx19v/Z5K8eQa8F3YNB+P8gIH8SfTJ1uM5Tlpc+5KKAWH3kZ9NwkRbTRyf38V7GuYHpjixlXPHF7929HAiv2f8wsgrBvJ5fHlbwc4+YSuHgtDv8z9Y85E7ujLz53KLbkifMOag4qLMqQuYambvh8o0fH079aT4h92TZx2TosccKbQIQm0gO88E6Z4Oxb09gdvVu/tU8PEIJI0JRgmXq2i/GRBd7srILENpy0Evh4NSPBoTxBbtPLW7QCaKxVafnQ1Tv8n56TqJOdUxGlvh/Pss2GmzeyJiTT5nfADz9ve0m6j6T3iYrSG+S9SRcuo9sSUmkOPiVjMynSAmd5dpObP+zdZna60NO35e+NmIya0Rsfzp3E+84W0HaRgPxfpF4XbrsZJGfIxKoZH/pSz6mI9us/56ewJQfZU2S0JA/8/ISHTqpisQ7LhMWQ3EuQERzjt9WNXGQftR6Lyyzw7JYOiVMNXRKIjrtQ8sZZYhwYmaNGorL6mFcnW4Lh180mpo+Imv403oEN7UTsoGBTlByXXDUIGxIl/lc1XkyqHmHeetMThAQSPPGfDIpUYXBS4qcoovCcLBVP3P1yc6DvzYaon6u7V6Euv4P9nof7KkJvNgd4XqUI/uNA+wxIxxfho3zig1GSupidYQmwl3nNwiaNyu7ViDndG3YG8tQLxP4On9n0RJm8IUIMqZu9ub2zDjAGsViBwmCUutIb8QKmnnryM2FKFF1kP6
 EdTGs4Y1
 ae6F6scMEa76RamtwgutqsvdDkY47EIRaHkVHQDLMiskmGu8gu/vAPRY7RYYIKj94xagAKXRftBJ/6JIjpq16Qyb1zcKUiEYwE4PcASdgBdkxw6evAsLLkcmDBTDlrZdfJ+My8BgiF5Cwcsnwkb+HCelzv8g8iV1qWy8EmSC80E5Zw+5TCo3b7nYn7yBKLPxVME0f6QYLP9DKFuEcDRh7zFZz4Q4htRORcBKsitDnouz50hnoEN5ywqq/srw9sL2BrxdfJdC5TWKlwkYjNM7lBOwqxDFLrEhwJ4rbt/XilYuTKjZnhMUlnEdooONMleTpqEmg9eZueAri5L8eaLvulN1L6+0wHYmL2JRN39/gQ063BQCCGnQGv3iqt1uSWwStZQj44CPO+Bblv/QYHj28WXuGVckVWhGmOnoHa5MHGIMLiwkmoWEjMUqdCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:21:58, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> For bs <= ps scenarios, calculating the offset within the block is
> sufficient. For bs > ps, an initial page offset calculation can lead to
> incorrect behavior. Thus this redundant calculation has been removed.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0742039c53a7..4c04af7e51c9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4183,7 +4183,6 @@ static int ext4_block_zero_page_range(handle_t *handle,
>  static int ext4_block_truncate_page(handle_t *handle,
>  		struct address_space *mapping, loff_t from)
>  {
> -	unsigned offset = from & (PAGE_SIZE-1);
>  	unsigned length;
>  	unsigned blocksize;
>  	struct inode *inode = mapping->host;
> @@ -4192,8 +4191,8 @@ static int ext4_block_truncate_page(handle_t *handle,
>  	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
>  		return 0;
>  
> -	blocksize = inode->i_sb->s_blocksize;
> -	length = blocksize - (offset & (blocksize - 1));
> +	blocksize = i_blocksize(inode);
> +	length = blocksize - (from & (blocksize - 1));
>  
>  	return ext4_block_zero_page_range(handle, mapping, from, length);
>  }
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

