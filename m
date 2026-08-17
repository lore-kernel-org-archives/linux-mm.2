Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A7DC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0496B00E3; Mon, 17 Aug 2026 10:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79AC6B00E6; Mon, 17 Aug 2026 10:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E796B00E7; Mon, 17 Aug 2026 10:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80E0A6B00E3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:54:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06C418078D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:54:33 +0000 (UTC)
X-FDA: 85111057626.26.BCB88E6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id A5162C000B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:54:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uIUBzB05;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xoehDUr5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="mW/PgIhI";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1Vldl4kH;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786978471;
	b=tTxq0IJFjpNol26N5JjFpLPuLTCgDGbUpx3OjwnzNTxPT6tYlUmbH/3r+29WvUH8JjCBtD
	cZ931e9aeayI7sDxYDqGWF5qPJ5bANnrEoQQy06jZoUsLFNXbRtHCrMUD9FOQzLl/0Kkww
	HPrgt3o6xLuZuAgWTt81eFEezO98WSo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uIUBzB05;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xoehDUr5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="mW/PgIhI";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1Vldl4kH;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786978471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WpOjLp52EifagBnpZ/4guSYkhgxu0erpf0alM3JApi0=;
	b=WpxlQ22XQJKJV4ZEo4z2+pX1hg9HCRrfORz93nRTEVNwwG/romx5MfkUGTs1dBEa6BHM3U
	4Cl2OHkMm+KBBFlpWwB1J2HGBBqLQi2mS1M2nPTp3tNhmoca3kAu2bixyPWNSHVWew00HS
	g2pj7Q/FAKFEerkV7S9xJ6JLMXjxN90=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BA8333CCD;
	Mon, 17 Aug 2026 14:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786978396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WpOjLp52EifagBnpZ/4guSYkhgxu0erpf0alM3JApi0=;
	b=uIUBzB05QVPknq00o56pxRbPJsT1vL7Dhc3HsSTc3ywa8bbXn+TMeLDhWbMvX2BQ0dFSSr
	dbtJM5YKBwlrNMHoSy2nUZ3BOsIh71FHu2XE0HmjMhEE/+/luYbiInZh3r5jg2D228VDsN
	U0xZCzPtczTF2qVud+Ydbjqji8veTds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786978396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WpOjLp52EifagBnpZ/4guSYkhgxu0erpf0alM3JApi0=;
	b=xoehDUr5BMZ3ItHOrdb4BnoT5SHW50FCloyJzvmqmaf/DZAFqS12uteL5EHi6DqHDExhEI
	4urxXmqXB5l7X8Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786978392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WpOjLp52EifagBnpZ/4guSYkhgxu0erpf0alM3JApi0=;
	b=mW/PgIhIzeHttQi8xdup3NiKRaUDjgu7aiYQ1QeGHVvrrdkqSnL9kBcv5mn/YnF4+yD4bM
	NJakosw8VjVwq/MVjHtwBldQXkvgA53e00m+XH/EQGtQzdAN5LYxavwhWkwYi5wbz2ic9J
	HmU+AYtz7o0aKOvKAy6v1f9sX7lPM7Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786978392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WpOjLp52EifagBnpZ/4guSYkhgxu0erpf0alM3JApi0=;
	b=1Vldl4kHu/viiCCFohYYvFlgy2raPLcdQ0bwWNf7r475taSFY4kKnmSpkYq04qIMKuHzJh
	/o+cTEfHqVTLMoDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF3B279505;
	Mon, 17 Aug 2026 14:53:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rkfAKlggg2pUGwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 17 Aug 2026 14:53:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4F645A13B5; Mon, 17 Aug 2026 16:53:08 +0200 (CEST)
Date: Mon, 17 Aug 2026 16:53:08 +0200
From: Jan Kara <jack@suse.cz>
To: vova tokarev <vladimirelitokarev@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org, 
	security@kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Fwd: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to
 local privilege escalation
Message-ID: <trv2wwdwprrebu4s6i2ufepk5a5ir4edz3tnttv7ivlkzihx3e@zq6lt67oplc5>
References: <CAGBKPgOm8q-8_rwyRPEmSj8JXdh_GaK1Q8vpJ=j-+yA0SgcNQw@mail.gmail.com>
 <CAGBKPgPPALX_5CQJAKUNjwi2fD28pBeS5pRuwQgePU93pOy8EA@mail.gmail.com>
 <anXnHMInq_JLYbWc@pedro-suse.lan>
 <CAGBKPgOfbMJruqcegJca6BBpEtpd91s5ASF_VU+gucWsjwp8WA@mail.gmail.com>
 <ancYCBUT8aB0qHwz@pedro-suse.lan>
 <anlOGOmO1HWVCMdF@casper.infradead.org>
 <20260811-knieprobleme-holten-palmen-4d42742b1962@brauner>
 <CAGBKPgPanzn8WuHK1hm44FLCXwJcnk7W=J6b17D9UzScWW7SJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGBKPgPanzn8WuHK1hm44FLCXwJcnk7W=J6b17D9UzScWW7SJQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A5162C000B
X-Stat-Signature: zmg48k7jxqti3ex77j8bpteigsptnmre
X-HE-Tag: 1786978470-902830
X-HE-Meta: U2FsdGVkX1+7r/THfnzWR5il+4CekIoefP8eXTykoglx7gRhjEK9Wuc6WNqXXWWASG68Y0W0X54kn3o1pn0Uz8E7NOzONElpXkWQ8c8svVygZq1qnWtc90xmEWImfzIJ/hfIlKKt7Iy7SqejAIL0lL3nvRaAI/c/YvXrCfglionPzFPRhack+EDeIuqup4UBP4z7s4ayCt2SKSjL1UArhGtiZ/E0TkKFmqhdlGjCC4wlDvdOeIFacPpSGsQydpEKwIg5ZVCkO405dAfiCvPzFzaw9fM1gGStn/bdch+6nEPG0TyfxGdCRAVZMPVMbtZwzQCQ9w/qaO3KrmnBjNY2l1kXC+2yzCmYotwyz/GWbi1L1u9Sal8TWBt34iA3RE3RwBewGZZkBgRCk0YAMpvrgBIVIPQRxs57RRsz9VP4tDkBfh290hMqZMx0ykt3jSnBz5dcp/k4U5aoy/yKXg090AJ2YDUzk3zWnaixnllSEs1cQas/+F/4/vFqdV51ggsx7wAeSnG+kT24Yb/FUenliRcIAcDq1CkXrEfd4jVNE+SHSCc2om5Y5rkkjdhWgxlQ/r6scESDoGUHU2LfF4O+IGoM1SUu3khwlzf1BH9Lutur3/zn6sBe/dTSaydw/t/Ndv29jCafbZyTbyZ6/+qjRKeWFnH4mZSSXVUmiBr/EPDbldZASwCV+ICdJImeu0F7HkF+0Kz0uaKBDbT+Vxh2e78PENMCKcb+NBk+Kv5ZD9wn4OvaxqteR9R/N0Q0e6Nj/HAP9iM7DX9/jC9i/cpA28MrfKWSm4nfXScC6Ec+0Byw31CyVVtvJj3BtFozUB5xha7SnAmNf9dPgzmTsN28ad/wWVgUQV5hMnQi2VXsrbFYHhxHIXWwx3zDocH+ix9/cmfr5zFxGBfby3rbXz3/LJl7zmJoUaPJH0h0HgVgdFvgnmh9UcL2mL0SqQzTntMGjh9JFpp6vm0S8NETLDP
 NasioCGS
 8nOpbotbPG74J7jliILCemz+vEdGbEWFHa9vH3hbF8KROugSvm7FtDrs2aHCO0CHBFbdfQLOVl6qhgJn6eXj+hqmhoo596lV10YpgYJDbfsb6XitxwzcXvLPtWiFwkAThQ7738/JDPt5MGOP20vnzFnpnpzoKKHeZy3w60Wy74/Kg53pXWGJwmwJTZKq5uM0z/zdt8xobTxNNshP8mIYi0MdOM00PtNVylP1lb/mwgZi5ZO+4ty+74zT39AZMWaaUUg9SbFoaG9ibAkjTaMCNhW/LZw25aMJYKZnaZ+ASvDQuNzsGTJWlofejr6FankiMZOEjj1J6w2o05hKZiZJu6zlwh70ainTiJewQyQmlry2Vr04lruV3FPzwPIlVo/1NNXXpltGKWA6Mv8U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 14:16:31, vova tokarev wrote:
> Matthew, Christian, Pedro,
> 
> Lol - fair point, I'll keep the reggaeton references out of future
> commit messages.
> 
> Agreed on severity - but this is a
> killpriv invariant violation, and the kernel has treated those as
> security fixes worth backporting before.

I tend to agree this would be good to fix for consistency as much as I also
don't think this is a particularly serious issue. Removing SUID bits on
write is more of a hardening measure than serious security guarantee and is
there mostly for historical reasons AFAIK from the old Unix days.  POSIX
for write(2) mentions this as: "Upon successful completion, where nbyte is
greater than 0, write() shall mark for update the st_ctime and st_mtime
fields of the file, and if the file is a regular file, the S_ISUID and
S_ISGID bits of the file mode may be cleared." truncate(), chmod(), chown()
have similar notes. No mention of this when handling mmap BTW :).

Anyway, the problem with calling __file_remove_privs() when writing through
mmap is with the implementation - in particular the locking. To be able to
call __file_remove_privs() we need to hold i_rwsem and that ranks above VMA
locks / mmap_lock we hold during the page fault. Now that I'm speaking
about it I even have a vague recollection this has already come up in the
past and we've just decided to leave it alone due to these technical
difficulties.

> 1. The fallocate killpriv fixes (XFS fbe7e5200365, ext4, f2fs) are
>    exact precedent: same reasoning ("can change the file contents [...]
>    should drop file privileges like suid just like we do for a regular
>    write()"), same one-line fix, and they went through the security fix
>    process with CVE assignment and stable backports.
> 
> 2. CVE-2023-0386 (overlayfs SUID preservation) -- same bug class,
>    CVSS 7.8, CISA KEV.
> 
> 3. If permissions alone protected SUID, write() wouldn't strip it.
>    killpriv exists for POSIX ACLs granting write to non-owners,
>    group-writable SUID, container shared mounts, and chaining with
>    other write-access bugs.
> 
> 4. This path is reachable unprivileged even with
>    vm.unprivileged_userfaultfd=0 (UFFD_USER_MODE_ONLY bypasses it).
> 
> 5. Pedro's point that MAP_SHARED faults also skip killpriv isn't a
>    counterargument -- it's another instance of the same class. We can
>    fix them independently.
> 
> Given that the fallocate killpriv fixes went through the security fix
> process (CVE + stable backport), should this follow the same path?
> Happy to send the patch either way.

I didn't see the patch, maybe there the locking could be reconciled in an
easier way (although I have some doubts ;)). Anyway, without solving the
locking issues I don't think we should fix this.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

