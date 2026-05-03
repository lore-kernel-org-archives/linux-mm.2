Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52454FF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 17:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C446B0088; Sun,  3 May 2026 13:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D4E6B008A; Sun,  3 May 2026 13:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543526B008C; Sun,  3 May 2026 13:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46B1A6B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:16:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E464B40010
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:16:55 +0000 (UTC)
X-FDA: 84726763590.25.D4C0C8A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id B2244160009
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:16:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y+LJcVBI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QizszKGV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y+LJcVBI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QizszKGV;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777828614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMnlDjtPDorfK+LxpO0mE9kXpC2eJBd3Y3Tb0JnKjBg=;
	b=KXFWp8PJPCGnk47EjMbfIY/+z20sHMUA9yYjhmvBzY9mEUvut9DVMvz0/yVFcgvXuEU35X
	Xvg6T9Zvn6rld0Z5qiESr3DbvR31mlfVwyu2WcyC5atSO1LX+w3NAWMemZMEA4k2iY+oWk
	6HV5XxtK2N6cRY3J3utg5AqlcH5vi4s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777828614; a=rsa-sha256;
	cv=none;
	b=39KjqHzIVOdp3fgszKdHlcw0kgAMb+oGxBy9rQ/S7tArfd/nco2e/GjXr12shnZX6sTg6G
	5Sskub8gZ3fkrb3lg+LuZc116c6X+roIoHEwAacFGHWEgW7JKsaoSeaCFQewQfsVJuuOF7
	YZ/kU21HPAlWqrN9W9ZvO9psDhldyMs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y+LJcVBI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QizszKGV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y+LJcVBI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QizszKGV;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 594246AAB5;
	Sun,  3 May 2026 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777828611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gMnlDjtPDorfK+LxpO0mE9kXpC2eJBd3Y3Tb0JnKjBg=;
	b=Y+LJcVBItvIWLZmClLkv0eww17PSqWOv0bqeLO0MBEziYVoYhugSp0pNtdHnx8BGx686fn
	ri5ZuvZ++pRvBoINATok7tzNWYW9TOVLfR4win5OwKZz0lYJWWw8+2SRfDNuw3Ti+N+DQP
	1AQycUrzefnnlRszyKiDqeb/TEC/ilM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777828611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gMnlDjtPDorfK+LxpO0mE9kXpC2eJBd3Y3Tb0JnKjBg=;
	b=QizszKGVSbFankdpGeiqihBaPwK/B8hbFdqb5otdUmCmmeudDNKgX0gUE7YEAKnPk9pxaO
	Ws56X0uBvKBw9zCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777828611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gMnlDjtPDorfK+LxpO0mE9kXpC2eJBd3Y3Tb0JnKjBg=;
	b=Y+LJcVBItvIWLZmClLkv0eww17PSqWOv0bqeLO0MBEziYVoYhugSp0pNtdHnx8BGx686fn
	ri5ZuvZ++pRvBoINATok7tzNWYW9TOVLfR4win5OwKZz0lYJWWw8+2SRfDNuw3Ti+N+DQP
	1AQycUrzefnnlRszyKiDqeb/TEC/ilM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777828611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gMnlDjtPDorfK+LxpO0mE9kXpC2eJBd3Y3Tb0JnKjBg=;
	b=QizszKGVSbFankdpGeiqihBaPwK/B8hbFdqb5otdUmCmmeudDNKgX0gUE7YEAKnPk9pxaO
	Ws56X0uBvKBw9zCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC2BC593A3;
	Sun,  3 May 2026 17:16:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HKOjKQKD92ndXAAAD6G6ig
	(envelope-from <jack@suse.cz>); Sun, 03 May 2026 17:16:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DDCB2A079B; Sun, 03 May 2026 19:16:45 +0200 (CEST)
Date: Sun, 3 May 2026 19:16:45 +0200
From: Jan Kara <jack@suse.cz>
To: Costa Shulyupin <costa.shul@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] docs: locking: Fix stale dquot.c path
Message-ID: <ulnz7qjfg2rj6xtgjhdhrejclzhkeacw54jsgvxkchc6wrtsul@pm4cm4mkxdtm>
References: <20260503160221.1594319-2-costa.shul@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260503160221.1594319-2-costa.shul@redhat.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: B2244160009
X-Rspamd-Server: rspam04
X-Stat-Signature: dus5dsac7y6fgqufdawbotphebo653kg
X-HE-Tag: 1777828613-765944
X-HE-Meta: U2FsdGVkX18HPwJ0hADBeGpCCvump0XByX8UReg1krFDnqo1Co/lC372JOzxaNFJCBKxBZTUibyTKWrgk02QQfbLFbWrgDLRxdtKoaXJcxxI1xqovQFGjh8Z0mt3imACohBFnaNCOBErc5WYkl941fanpt1Feaw3vsO7F2kKTuLzCiKSkIDAscouAZBNy9Y4pvyR2iomSNrTcN4sxHYUQOuCQWQvtXIXAo5nHyEiCdZF+eOXHU4AoOu2KoP5U7NwRnDtYwWwDZ3yQln72OysnfbINVw/UlHG1PMi6ZITU2fJ244UqJ9lBpo/xw53emMk0LZ3egBM6tbmCLWKa4hy3P1SDrxMp981K6f81UEvLIv27zwRJ7LmfnDZsBdC/gPTKuXQXnvvOrIW3REP1ffBpdtY4vCV65rclgA8nMU2Rypt3eVuccu0z+qZnV33SrGfmtLTtbFjE3y5qEb/Z3k0Awu12eJOR+LNQE3ABeMjLtgxfxm15IdQBN9w5FEMp3WVNP5Toy3YbOL2mRRylykMI/Q7vjrtzeY9LkcRF3jpdLgzbu1iXx16xZ3c7zs7W7ziPYpJ5bLNwxvl3UGIWUb7ZgOxJwizTJT2hy2NyT+AQO3JVKMx7RrkAhqsHDbaSYl9G4oyIvH+aAgEGhZfHRHIzrgrttoUyZL4iUZbPqAeheyhshg+s47fp5kEZNgY1PG83DHk6+7YpXiUOI4gb9syT8rkASzCHRxPz0YE9T49Xc4zF5MQXa1bxOGzUvNzLuqprU43ILQHIfuEi3s0p6pfrTBzLp3vrpZXNE+CMAAm+A22scpzyaz4qzM10C3ZfWTcVkwY9CmgF+stmevFw9iuxQKJzztuztdU6yzMLo3Ovq1SiUl04OXFPN/s7/mzc/L9rcBEhAa3JVtH/1J0c1wBNLxjzxJOfFKCyV3j2lfKaFHSWUGSubUfbJTasKGW2/HVXCPLKhyM8IxIbSr5tWM
 zV7rUbNr
 oDP+vjfmq0svY6pLrtt829KelfVOleLzRXdQTC1POVxdCuzObyGKP9fYTljyjUce8hDDv2/FrbmLL4QTMmUrOvv3TUB8oXlv6nNUNqqrP95Hch0lMGPw/Zi6uMGWcTCJWSDk13onDHE4RaetgIwWxnScL89JEJXF3upB3hXq61mFswv/YX0/ATzRrDzitfN9iad79Sw0gIvAgfq7UUzHFDDTQ/NI5E7YwdHmSJImIFcK/qCevh6vzoi2PxP9IWlZI6rItRZOl9FLnjJOCkh9z6QpnwE8dTog5YMGwKzlMcF7XqXhJ9UtIxDdKUhRBmsTQBCwC6hkuQEnSfYd4nVgD20vAyPWarMKHKp5Uq5v1YcJsZ1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 03-05-26 19:02:22, Costa Shulyupin wrote:
> The quota code was moved from fs/dquot.c to fs/quota/dquot.c
> in commit 884d179dff3a ("quota: Move quota files into separate
> directory"). Update the reference.
> 
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>

Right. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  Documentation/filesystems/locking.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index 8421ea21bd35..277e49314d32 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -584,7 +584,7 @@ write_info:	yes		dqonoff_sem
>  FS recursion means calling ->quota_read() and ->quota_write() from superblock
>  operations.
>  
> -More details about quota locking can be found in fs/dquot.c.
> +More details about quota locking can be found in fs/quota/dquot.c.
>  
>  vm_operations_struct
>  ====================
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

