Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EAEFFEFB56
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8775A6B0088; Fri, 27 Feb 2026 10:26:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BC06B0089; Fri, 27 Feb 2026 10:26:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779426B008A; Fri, 27 Feb 2026 10:26:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6358F6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:26:12 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16FD31B7EF6
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:26:12 +0000 (UTC)
X-FDA: 84490612584.02.A1A79E4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9D5DE1C0006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:26:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dr07HTs4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0vIiX17I;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dr07HTs4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0vIiX17I;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772205970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qc5kTPIg0SUn5GOy2ONe2+Zsp5R+gcLDDp/mn1CBSQk=;
	b=Lytm3ZXB6LaeZe3tvO6cMs0ViCZy9ZnYvg7B8zrj58W1GKkBUOm/fZoi9eDJYQBgtTa21k
	ozHtYbWa2eF1noSWDFYzBPI9xnUt+QIPmWy3PbbNNlEzma+tEWRFswnK2cawlhkhrWiBU5
	xyKsL8yFeJymnaocMuNQmDpLz0DpGqo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dr07HTs4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0vIiX17I;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dr07HTs4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0vIiX17I;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772205970; a=rsa-sha256;
	cv=none;
	b=8Vu+0NMOetmWfniQKarw7+LEdf6a5mmBkyqP5isBsQoZ6qLElgq4MqRkrWtE1hDvJTJGpv
	1BfPfz8CbVOy7k1KkjSF02GEpBkRaS6+CpSqCnbW0l4eCLz1n/Z3EH0plGiKTXDjK8Fcvh
	peStigZOyWf27hiY1etMjT507neMhKE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 41E9A5C1A7;
	Fri, 27 Feb 2026 15:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772205968; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qc5kTPIg0SUn5GOy2ONe2+Zsp5R+gcLDDp/mn1CBSQk=;
	b=dr07HTs49SWh49lnsTVU/D1W1XQ+NDgzMo4yRr73NScjW1jcD9+lT2CGdh9n4STFj1Twfk
	eEYeomyzXckJL5DnCF4EXmemOXro+O+K/ESSH/4FciOGhl7OY4U75AOJePTdiyTFb+wEFv
	VMsHS5eS5NGXxv1shnbGbcLBNwhL3bU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772205968;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qc5kTPIg0SUn5GOy2ONe2+Zsp5R+gcLDDp/mn1CBSQk=;
	b=0vIiX17Iyqw56xfSOzDLF2z6K+4GopLa4Hz9GmNCHeQS8CqXOSbnJtcepw2CkTQ6hVGJO4
	kDUc9gOhmozmWhDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772205968; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qc5kTPIg0SUn5GOy2ONe2+Zsp5R+gcLDDp/mn1CBSQk=;
	b=dr07HTs49SWh49lnsTVU/D1W1XQ+NDgzMo4yRr73NScjW1jcD9+lT2CGdh9n4STFj1Twfk
	eEYeomyzXckJL5DnCF4EXmemOXro+O+K/ESSH/4FciOGhl7OY4U75AOJePTdiyTFb+wEFv
	VMsHS5eS5NGXxv1shnbGbcLBNwhL3bU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772205968;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qc5kTPIg0SUn5GOy2ONe2+Zsp5R+gcLDDp/mn1CBSQk=;
	b=0vIiX17Iyqw56xfSOzDLF2z6K+4GopLa4Hz9GmNCHeQS8CqXOSbnJtcepw2CkTQ6hVGJO4
	kDUc9gOhmozmWhDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 393A33EA69;
	Fri, 27 Feb 2026 15:26:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id J6D2DZC3oWmrJgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Feb 2026 15:26:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 05E25A06D4; Fri, 27 Feb 2026 16:26:08 +0100 (CET)
Date: Fri, 27 Feb 2026 16:26:07 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 11/14] xattr: support extended attributes on sockets
Message-ID: <hy7vat2udvtkkgggofdj2z7hdwlky4ehpyuhpzdzrwdz43snyp@km35qarriknf>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-11-c2efa4f74cb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216-work-xattr-socket-v1-11-c2efa4f74cb7@kernel.org>
X-Rspam-User: 
X-Stat-Signature: hbyupqng9zbg8k6zju1ffhgxgbjchi9z
X-Rspamd-Queue-Id: 9D5DE1C0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1772205969-481413
X-HE-Meta: U2FsdGVkX199oG0eRXpB19HABVEthJpPMbHR4ahuzhB4+3qc/2bn0OQLEA9QhipQicxmG5eFd8ryHMpufZ62o2KU5us+1ESgxAxfyf8CgaR5m8IUKobit5vNYx5AeE3aTXTk84GgjziEIODDrTnfpz092OX18o+TrATp/YPt/5RLBrzyUkyU5I63hLdkR+yE6qmlBVDCJkd9E3SQj3YxjymF0EvT0zw4H/J5/q+ibXaHv0rsVhET7ycQqIaahkVWltjlSTVpBFeN/+tsV/k1I7uR9ZER6n+5NNM2o+DRp/afaSqkI33y7jzMVqIBePCq+gkaMbbyN0Ev/PCj3s9y1jPp/KhUWkA3K9rnnK6gBPQyxn/x05Cw36taVocVAAB7sYngJFb4tkiDhB3PI0/0vBPDU1DEDIPsBGiH0hit+joVWKLZIHgLE2SLZOIn1p0aJaHZVh07B8dvO7qTskRgj116ImTl6wH1+MWV2ReLwb4rbok1fC0au2qXpUgOJX1zXDlDx3BeJDFAzkSB6iQ26oeY2t0oz8QLqB0pHs9BiepaWqahEwX/jeNqPuDn5iAhRsccVI2D7pm1mj6Bvz4eNjn6ffomTnXvFcf5s5WaKbvr944MK/+oZtYCBFOKJeVf7aVAcK22PyjIllgkPQqcGIbo0BuWkxenNnNjTsgjkGujjKp6AEFOlvQa2tXR+6uvBRvoAXcjaVyOMcT+ElMgbqI7rhwuGQNDQ0y5cEau82sbDriJ5dFEOG9LWTQWpspotOMhzhxLzxc5ppNv9YRcyookeWbBaKaGG92E6JlK01gDmuZctiz/qJhaz1oVOo4HqN1aWarHDHs3a/Y/+jjFWSBkp3DNJ5pm/yiCJ6wE3YMHEQcYh6mAON0+WI84315q9a7WRbsPm5Qs3swprNEtOJH8AOROCiEMvxlnEMSBDu0ke9A9G7xc294Z6LPpXWtflhUXFS89kuy/n9x8VF6
 s8/ELj+6
 QPW2fCO0Eaca2DRBQdGwPnSExhMVnaUVHUXF9NZin7m2ADtHfAn3S36AvWGPb6S+B5uzCj5MVr6DmM51RGU1rCSIy4qGXUkSqnn/uRgTaEsDNKVBlJWuEsG3a47xVFjN+Gj6EgL4Q0JBdVpftWz8hVzFkP8tKKvRG/8mKQ9zDugT18zhFbchxIsiCheVPsmh0Xaqm/3IcqCR3l5eZjxTEKs88zt23GOY2BHs8HHcvvDXhubm+ZD0jTqYXyJ4TYBtXXyUmPXYU4rKh7eUzVwFno4asLdfb+yycl0sAcYalSvAo1cnmyPDkc0uxTQzm1R0hd4tGVPP0CZ3G3LVphg+kOUzWexqvo3KNgActMykMVyNZ9cM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 14:32:07, Christian Brauner wrote:
> Allow user.* extended attributes on sockets by adding S_IFSOCK to the
> xattr_permission() switch statement. Previously user.* xattrs were only
> permitted on regular files and directories. Symlinks and special files
> including sockets were rejected with -EPERM.
> 
> Path-based AF_UNIX sockets have their inodes on the underlying
> filesystem (e.g. tmpfs) which already supports user.* xattrs through
> simple_xattrs. So for these the permission check was the only thing
> missing.
> 
> For sockets in sockfs - everything created via socket() including
> abstract namespace AF_UNIX sockets - the preceding patch added
> simple_xattr storage with per-inode limits. With the permission check
> lifted here these sockets can now store user.* xattrs as well.
> 
> This enables services to associate metadata with their sockets. For
> example, a service using Varlink for IPC can label its socket with
> user.varlink=1 allowing eBPF programs to selectively capture traffic
> and tools to discover IPC entrypoints by enumerating bound sockets via
> netlink. Similarly, protocol negotiation can be performed through xattrs
> such as indicating RFC 5424 structured syslog support on /dev/log.
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>

OK. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/xattr.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 5e559b1c651f..09ecbaaa1660 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -163,6 +163,8 @@ xattr_permission(struct mnt_idmap *idmap, struct inode *inode,
>  			if (inode_owner_or_capable(idmap, inode))
>  				break;
>  			return -EPERM;
> +		case S_IFSOCK:
> +			break;
>  		default:
>  			return xattr_permission_error(mask);
>  		}
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

