Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B6A9FEFB5D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA306B008C; Fri, 27 Feb 2026 10:17:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4076B0092; Fri, 27 Feb 2026 10:17:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7696B0093; Fri, 27 Feb 2026 10:17:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9302A6B008C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:17:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5391E1C953
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:17:46 +0000 (UTC)
X-FDA: 84490591332.14.EAF3017
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id D18431A0002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:17:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kzk8gPWI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kdZmmjlN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kzk8gPWI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kdZmmjlN;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772205464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1h6dSP2R/hvvqdXyOgaHEygft4A0JhA++XIXdBxaDAA=;
	b=F1tMOefHEifqNyUO+3sbLe2IVlrDnMLIipchiJ54rvSoKHtcJjQtB2MMNuCtgxoNsXe964
	syiCCnIWGWvPDfR3vRr60a55hQTK8kXDSVxEpXce5Y9bK1TnBO+E2MkHLdXPbYvm9NFjcK
	kOf5YXOoxozgIL23WxqykwqW9QuQ9fU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kzk8gPWI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kdZmmjlN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kzk8gPWI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kdZmmjlN;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772205464; a=rsa-sha256;
	cv=none;
	b=Pn8mtlFDv6+pv7ByxsEAu/yMfTKTDo55C34GHjncYWQnAlvvVEiSaYNZD5HvTqVtTiQyH/
	aCtKxAQQTpDzpfN17fPzCHFRlOjJmQGTMXuqxaeyxEqyV5RB1J7evPkrUj2suNrV6UTLEQ
	2DeJ3byqlimHgwfzUorjBd9nGw0G9ZA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5D6C65C6FA;
	Fri, 27 Feb 2026 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772205462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1h6dSP2R/hvvqdXyOgaHEygft4A0JhA++XIXdBxaDAA=;
	b=kzk8gPWIke67mRHYIeZTdnV0jWr344Ixrz5IqeP5IIO+Y5n3kE/53ezEwVrJh9EpgoDe4K
	q7/Q+/4cTBks0IR0DGcmKi8fSGYgAnGdM1ug3/77u79xuh65V5FBcegAwYd1iOYuHMVmxm
	njUPjtue30o7ac0D3dqO9YeT1fb7XyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772205462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1h6dSP2R/hvvqdXyOgaHEygft4A0JhA++XIXdBxaDAA=;
	b=kdZmmjlND/j+ZWuvLQ3rN9lnNuW6iUXWPzobKzWqIBNyaZHr4+G66FpCj6RI+xTlfWIvpN
	BnCkBmQWLaFiXDDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772205462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1h6dSP2R/hvvqdXyOgaHEygft4A0JhA++XIXdBxaDAA=;
	b=kzk8gPWIke67mRHYIeZTdnV0jWr344Ixrz5IqeP5IIO+Y5n3kE/53ezEwVrJh9EpgoDe4K
	q7/Q+/4cTBks0IR0DGcmKi8fSGYgAnGdM1ug3/77u79xuh65V5FBcegAwYd1iOYuHMVmxm
	njUPjtue30o7ac0D3dqO9YeT1fb7XyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772205462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1h6dSP2R/hvvqdXyOgaHEygft4A0JhA++XIXdBxaDAA=;
	b=kdZmmjlND/j+ZWuvLQ3rN9lnNuW6iUXWPzobKzWqIBNyaZHr4+G66FpCj6RI+xTlfWIvpN
	BnCkBmQWLaFiXDDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52E123EA69;
	Fri, 27 Feb 2026 15:17:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z3M6FJa1oWmzHQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Feb 2026 15:17:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1B44AA06D4; Fri, 27 Feb 2026 16:17:42 +0100 (CET)
Date: Fri, 27 Feb 2026 16:17:42 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 08/14] xattr: switch xattr_permission() to switch
 statement
Message-ID: <wvsbhwgtkeq77v5p6nwctpybzrie7m37xd27j3hmpwgoyuoltv@7vqndacm67tr>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-8-c2efa4f74cb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216-work-xattr-socket-v1-8-c2efa4f74cb7@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D18431A0002
X-Stat-Signature: m9g9c93tjthxemmhp4bmwadeymrsddb7
X-Rspam-User: 
X-HE-Tag: 1772205463-30796
X-HE-Meta: U2FsdGVkX19deFG/LdA5w3GxbYAHLh0OBxDFADfNa2o7iSrVhewiu+hUhflRyRts7JdSdISueSUiXy/W2fu3bZJoi7GIm5wlb6eE2Pfm+4wmrpMv90aGOTcznigp18iyO4kHuwTSm/o6qY9aDCXGDeFL/J6D6aglkFcjbhTCTT2PbrvzpHh77+Lm8mobHZOuyyhWn5mTrfrK3avMJRGS/hdl5gr6NAf91SwrW5ku/SOxZ92O+ziczMb4rnyW1tMQfM0azQTI37xHBlL8IiFnIYd/eawkV8VkWN+oFb+sD86qJp8+DLr+vicHuBUecMKqvcJU7Femi+vDWp6fXWe9rxzojKDGeEbxQJv6imGuemrdg+ZPxz5xquzNgcjy4mP1y5gcUamiiNBJAPWccuOaSn06/0xOGu3htPKPsCUBjfHf4FfLrteOtuHJoDDVwxOCIgf4Z8YLpLSmApPU9cuYIWO2n8E24sspFOP0zBe4MJPaYTSMg0ain9RMJ60kmXTdYa/afNAot4y6aCV4i8K565h4D+EddY5dqz8z1lqR+rtTA2LP42UW9AFFg0Z5wZlgVOEnoKCsjHh9OINqxIbBQGqxKXapeERcm4VMdPC8ltby37vq9ZwO6ZnyXl/pTC0z2mGfIe0aD9Mts/v4ruzvIGUMPdygvMJEuJ2f5+zjmu/6r229E4+9dSZ7SA2OPKsO8GtLN+v1nu1709vVadLD/y3OzMYtf9UX4vyGvYD3XNp6ghjopQhF/S51Xd1XnwIR9xfVwGoLAvQqno2QHPlH2JGBTtI3ygnlf1nCRHy1l6xekEh+aTz+kX/EGIyJ3Km3ASLWwXTJUV3bR10zxtW3C5tHcNnk+6biYCFpVzx0++vREkOCCEkXdt0K/MV2J3p3+O5VTL7r/MdXF713Kq6MEItEvGXQJjR9FKL9YqYwzTgVT7rxyqmeiENLj794dCXWaTO0RPcR7K4+fCixrfK
 5/BrM3J6
 OWV53UF0vTCtXsvX2+YGMXqlcKDqRSeYQ6L9L8173H3CNtZz/CZaNibw54tDbUpJsMn2YnaI4S0o1tEtGzYFHyQP5uoDsiPBVZh4C0mvGXpABiXfV3acTOafjGiXhozyFaL67bpCR9UJYrmSX1IEdOKRF6mbKziDzYXw5ivYrAjQUgQdCHF80UGQLmCC+iu2Z6Nyb0fkCt0ezg3x5i/a9hxwF8uhPnhmxKJiW4m4GVjDuTocTLBSonElG71Jc3B13VyTBSjMyYqqdDA/1lM0hmq1BVYgs86e2/cLTX0nQwbvcH8h3BfwUs8a4zH3vjHcFsg/LruvEjYuUdr64wphlkXRZQZJB5/KC3L13LpVlGe+O73Kh6jGUS16rH34XZxxZboD8E8QY2cLvNfccrqrCKDba9gA8p+HrvovJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 14:32:04, Christian Brauner wrote:
> Simplify the codeflow by using a switch statement that switches on
> S_IFMT.
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/xattr.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xattr.c b/fs/xattr.c
> index c4db8663c32e..328ed7558dfc 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -152,12 +152,20 @@ xattr_permission(struct mnt_idmap *idmap, struct inode *inode,
>  	 * privileged users can write attributes.
>  	 */
>  	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
> -		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
> -			return xattr_permission_error(mask);
> -		if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
> -		    (mask & MAY_WRITE) &&
> -		    !inode_owner_or_capable(idmap, inode))
> +		switch (inode->i_mode & S_IFMT) {
> +		case S_IFREG:
> +			break;
> +		case S_IFDIR:
> +			if (!(inode->i_mode & S_ISVTX))
> +				break;
> +			if (!(mask & MAY_WRITE))
> +				break;
> +			if (inode_owner_or_capable(idmap, inode))
> +				break;
>  			return -EPERM;
> +		default:
> +			return xattr_permission_error(mask);
> +		}
>  	}
>  
>  	return inode_permission(idmap, inode, mask);
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

