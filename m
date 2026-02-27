Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0E53FEFB5A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE1F6B008A; Fri, 27 Feb 2026 10:15:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA8736B008C; Fri, 27 Feb 2026 10:15:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1396B0092; Fri, 27 Feb 2026 10:15:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C507A6B008A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:15:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75830160707
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:15:25 +0000 (UTC)
X-FDA: 84490585410.30.86424BB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05754180004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:15:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=McM9intw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nPhduoPp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=McM9intw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nPhduoPp;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772205323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n16DyrXNQJJWW+Jr2xePFGtnXxpA3QEZ+Wy5qwxXsU8=;
	b=hMJu/H0/6unTQN5tA1O2iUgtKGCxkMadCEvuM8XA3MEbfNOB05eWcJZEfCnBXVpt4ux4tg
	m7da5gnvMO/6mGCGDbH+mfwM+M6D+rh7Q+xSlCv89nw5/f5Oaj5BD3O2TcLx7MSnF+m4Yv
	OJ1QhscjWjQexFwYKzFcwCFQWHpWi2k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=McM9intw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nPhduoPp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=McM9intw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nPhduoPp;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772205323; a=rsa-sha256;
	cv=none;
	b=RgpAJ+s2eDMM3q8F/VGzezVu6mRceH6cXuQO02H3GfrqOd6oEmwL1viLmZ7V8m4jRdWzmz
	qDMXdAQCyVfFZcbde2rGJoHXKh1jMaNnl8GkTXuHUFLUWV/OcKIyUVQ4cduLzsT54sgz51
	iej3cYsN0xpNFK1RYYjX/dbj5iTLi8w=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9F4145CD90;
	Fri, 27 Feb 2026 15:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772205321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n16DyrXNQJJWW+Jr2xePFGtnXxpA3QEZ+Wy5qwxXsU8=;
	b=McM9intw4dirxWmBikLUCFafM+qqOFKvkFzEzBQKIUIUo01I5KXX+IugLybO2xPitFE12y
	HYyw4WAS9OlflHpr6gRLel2LZHMVO6Bn6ar2N/CSETqJAFRxTCl9mZgE0Kp+D/5SwWaJuU
	JxeSRcRje66izI0nDY9WuHAnvrtwjdM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772205321;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n16DyrXNQJJWW+Jr2xePFGtnXxpA3QEZ+Wy5qwxXsU8=;
	b=nPhduoPpt1VRceBdX36AOVfehD+5hdYNO3nYAZqf9TK0TM9u9kzDkUkPT//+UfWFUmdzsF
	JWnydrZzTp4qJJCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772205321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n16DyrXNQJJWW+Jr2xePFGtnXxpA3QEZ+Wy5qwxXsU8=;
	b=McM9intw4dirxWmBikLUCFafM+qqOFKvkFzEzBQKIUIUo01I5KXX+IugLybO2xPitFE12y
	HYyw4WAS9OlflHpr6gRLel2LZHMVO6Bn6ar2N/CSETqJAFRxTCl9mZgE0Kp+D/5SwWaJuU
	JxeSRcRje66izI0nDY9WuHAnvrtwjdM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772205321;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n16DyrXNQJJWW+Jr2xePFGtnXxpA3QEZ+Wy5qwxXsU8=;
	b=nPhduoPpt1VRceBdX36AOVfehD+5hdYNO3nYAZqf9TK0TM9u9kzDkUkPT//+UfWFUmdzsF
	JWnydrZzTp4qJJCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EA413EA69;
	Fri, 27 Feb 2026 15:15:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l+XJIgm1oWk7GwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Feb 2026 15:15:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5A184A06D4; Fri, 27 Feb 2026 16:15:17 +0100 (CET)
Date: Fri, 27 Feb 2026 16:15:17 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 07/14] xattr: add xattr_permission_error()
Message-ID: <hexzz2e3fgb7ww2xzs4vf44od4dkbdhrcbfccscdz3gbf72dug@vzpbafbt7tzl>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-7-c2efa4f74cb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216-work-xattr-socket-v1-7-c2efa4f74cb7@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 05754180004
X-Stat-Signature: m9awt8kxu8wehzwuijzg7fc9rntz7n7o
X-HE-Tag: 1772205322-486184
X-HE-Meta: U2FsdGVkX1/b0VzVGH6XRp9fUpf2cWxzGlKXn5ZZFtgGoQ31S6IkxPYPxQFDh8zOQi/hyduNtpvTKGS/zJ0BjTL4eujYXJatbvPyqSp8PXzP3in1ENAh5BjU0Ebzkj2oYm2IS3pl1uZwb135WVswnbK5ZebnTl2HfvBPeM4Fs/LZ+IvuDXNhhg7zrm0nRAHow8N8jTnejD4vysAarSXIdL05ziWL3u36XUSTqf3WKOXbcEHVxLQlIZrHJXDrQAnNI741NLyUOKm3WaqePUmfG8Z/eWoDwUIHghE2AnWnTcM90BSlNR5n+nulTyEae1LqSnjPIUWxmGwmYhxEbpzbpFwyq0g9v7Et7Da21yIvmnwOQgy3XhHFvOp+La/YGkqBMDfhXC74Uz/xL1/QudQMqY8WRc1IWyPawNnnaqTMq8m070LayAGZLhN6tCCQ4dWbN1weEVoIcAqKUcBT6uBRW3XNj88WH8r2M8QzVlDRy9Cr6qFdPQSQGoK8EbDG48EqWmhnCXP6GE/cvEr1FQJ3gdiQkmlN40BV3O4Vb5JbLxDaJguZf64McjSEgky4yw40cWnpfOnQXMAztZ+0mLAL0M95oDi0p/aqWxXNR97tLm283FabSSPWafcFmEH4YVVTNLAjjmaSqXP7AILgZ9qSpMFStFSbCz/0N6oULasXTt7/9vlwlluNhakEZMW1rDoV9UeHoYyfOehbkke3TIu0k3NVZzD0XleIzQN6OyQkkrTvQOWHPT2Mk4GO1vqCXBdJGAQXhso5IH+H+WBC6FA/tlNpLsucp1sxe6QKea+Mq6+nbkzQKO4NdJeRB2Et1DBtRPVP9he0V6FT2XzpgKnFbwGlhFRr0nQ/5IWYE6TO28Dd20I87ERtjDrGCV2TMT+nAbQYME9oH0BfWHaIGjrdkd9aUL+Fn4txPFxWC04UK4qU06VVU32G58AhopDR3aRL/h0R8hXK8qycXfu4cLV
 IKCp3O3s
 wiildf34DjauKXP7hL33UpMz9SpTd9ctN+36ECmAdAGT+Zd1ZHj1m07kIgkBRAH4KgKhEGXJkHAwLGZN8aa1+TQexzxYklQy+bgTfFLNAc1HybTTPVhLnE+QDkNATJy1bVwQsCOE+ckmP7r+rLI/+vWv33VxIq4Y2jEbGGcmoGxldjTfGALro9Q0B5nClNERR8IKyj5yJSRlJb8g3jxFyTsjoQrzlY3XGUh6F257g0WEJoCno1sRN/rpuJDFFKQ7weG6drpPfykW28Cgq8xxLNXMht2UmP2i4OW9y24EYjOWWjVm5KVS/4Q1My1GqJug7EhOx+tN22N6H+mHGOxh1kql89ITf+t+cRQNIw+bEIItJYMmTX+P26/Q3yvoOW0fjl6Zu8exGNcbDZQPh54euDogH+5LebXPtmgLz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 14:32:03, Christian Brauner wrote:
> Stop repeating the ?: in multiple places and use a simple helper for
> this.
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/xattr.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 64803097e1dc..c4db8663c32e 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -106,6 +106,13 @@ int may_write_xattr(struct mnt_idmap *idmap, struct inode *inode)
>  	return 0;
>  }
>  
> +static inline int xattr_permission_error(int mask)
> +{
> +	if (mask & MAY_WRITE)
> +		return -EPERM;
> +	return -ENODATA;
> +}
> +
>  /*
>   * Check permissions for extended attribute access.  This is a bit complicated
>   * because different namespaces have very different rules.
> @@ -135,7 +142,7 @@ xattr_permission(struct mnt_idmap *idmap, struct inode *inode,
>  	 */
>  	if (!strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN)) {
>  		if (!capable(CAP_SYS_ADMIN))
> -			return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
> +			return xattr_permission_error(mask);
>  		return 0;
>  	}
>  
> @@ -146,7 +153,7 @@ xattr_permission(struct mnt_idmap *idmap, struct inode *inode,
>  	 */
>  	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
>  		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
> -			return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
> +			return xattr_permission_error(mask);
>  		if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
>  		    (mask & MAY_WRITE) &&
>  		    !inode_owner_or_capable(idmap, inode))
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

