Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26513CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 10:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5278E000A; Tue,  9 Sep 2025 06:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655788E0001; Tue,  9 Sep 2025 06:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544468E000A; Tue,  9 Sep 2025 06:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1848E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:59:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF82E13B0ED
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:59:47 +0000 (UTC)
X-FDA: 83869416414.30.1C98958
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 873BF2000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:59:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cqeovs+c;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rMuoeX5H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cqeovs+c;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rMuoeX5H;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757415585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vd8wQMlXzXKXcCj++nSUg3MPs3H0+YLW4byTSnUGpN8=;
	b=LbxGHctVOt0UY5DXEhW75qpiZ5Y8R0mIZGpGJpi/mx7Zz5/ADRvq3khtdlagGdLSxIRlSe
	GkkdLM5otIJY+Q54e7gaCcAF5+35pdNRGscDuzSHNnAEdAuTd8UDwsS0m5D+DyzYSSr5W6
	iudRwJD11mGy2FUp0VpZixysl/8Djl8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cqeovs+c;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rMuoeX5H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cqeovs+c;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rMuoeX5H;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757415586; a=rsa-sha256;
	cv=none;
	b=WfnhmutqDLRJwjOAncz2JgwojxVG2yVkh5LDfBOU8sg0jvyC34AlHTmlEGRLLv5+3jyEsi
	VqRYqCO76vH08X3bEF1FbkJAo4aPyZYg+ictBVkKyLN5zXmnDG8OszhPmYxwm5a8J6yENG
	bek6ZcZMm1ddiYHb0snNfJbMnU9iBpM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B106F5C775;
	Tue,  9 Sep 2025 10:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757415583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vd8wQMlXzXKXcCj++nSUg3MPs3H0+YLW4byTSnUGpN8=;
	b=cqeovs+cpM75eL5RKYMbTIwmrGFq7UkMV0cZNfQoyh4qt+5nXLkOwUbk8JMUtCFj3ZAe+L
	fFBcDudcENjG7iyMHNg237ylHqeUCBNCfoQMyme7qh/g/lf+1ipwXIWroF3b0FU7BKl6f7
	cqxl/rOgpBCVTlZJJBCS6PYcFaMi7nw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757415583;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vd8wQMlXzXKXcCj++nSUg3MPs3H0+YLW4byTSnUGpN8=;
	b=rMuoeX5Hw6UparPgidr2/Pven6dTbdue7qxyhDzTOOF4Xek8F7mLkYaUOis5sEAXuMwVTf
	dAIuLc7JIq8JIYDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757415583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vd8wQMlXzXKXcCj++nSUg3MPs3H0+YLW4byTSnUGpN8=;
	b=cqeovs+cpM75eL5RKYMbTIwmrGFq7UkMV0cZNfQoyh4qt+5nXLkOwUbk8JMUtCFj3ZAe+L
	fFBcDudcENjG7iyMHNg237ylHqeUCBNCfoQMyme7qh/g/lf+1ipwXIWroF3b0FU7BKl6f7
	cqxl/rOgpBCVTlZJJBCS6PYcFaMi7nw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757415583;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vd8wQMlXzXKXcCj++nSUg3MPs3H0+YLW4byTSnUGpN8=;
	b=rMuoeX5Hw6UparPgidr2/Pven6dTbdue7qxyhDzTOOF4Xek8F7mLkYaUOis5sEAXuMwVTf
	dAIuLc7JIq8JIYDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93FDD13A56;
	Tue,  9 Sep 2025 10:59:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JgobJJ8IwGgLLAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Sep 2025 10:59:43 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DE065A0A2D; Tue,  9 Sep 2025 12:59:38 +0200 (CEST)
Date: Tue, 9 Sep 2025 12:59:38 +0200
From: Jan Kara <jack@suse.cz>
To: syzbot <syzbot+0b92850d68d9b12934f5@syzkaller.appspotmail.com>
Cc: adilger.kernel@dilger.ca, akpm@linux-foundation.org, 
	apopple@nvidia.com, byungchul@sk.com, david@redhat.com, gourry@gourry.net, 
	jack@suse.cz, joshua.hahnjy@gmail.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu, ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] [ext4?] WARNING in ext4_init_orphan_info
Message-ID: <puvp7vzyv427rdfs6jkdfi5qdhfrotxahijtah5wwvlh4s3ykw@tq5ytvrlwnlh>
References: <68bf244a.050a0220.192772.0883.GAE@google.com>
 <68bf33e3.a70a0220.7a912.02c3.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68bf33e3.a70a0220.7a912.02c3.GAE@google.com>
X-Rspamd-Action: no action
X-Stat-Signature: gbgtz3b5ytph1iyqrbpscqc6aiyk4yw9
X-Rspam-User: 
X-Rspamd-Queue-Id: 873BF2000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1757415585-198862
X-HE-Meta: U2FsdGVkX1+0Tvf/R/pU1ZzDtfW5Fw9+agbO1NsQYtGkr4IFVMkU/pfu0g7m07xNJT2K4feE82R+glSlc+7rYbCaOls7c8F8mBTutSrZ3+tm7A4XbHoWQm9ulePRD4xZlxUt1xFtR5obMMC6KyQjcN53ydue4puKevf6O03M/2ONhRI4VKY2TOuuBi6bK8NMCIQWzx8Je8dr3d7fwR3+ao7QrYHd5bVPrnQLLMIiY6albwDT/ofY/3S7BrFJJUYzfGbt0IO1ofx7gtiRHZfVKgFUITj8pEAyo8raNW9XGFiYC7fcA6ogK43kLY8rhz009F82hJDfPzRN+q4i9gsSXuOLly8/wOJud+nH9xK9k4FE9TIaw8IrYLm+AoBMY+ICpaGO/nECpkdDVDRKoE9humHdJJ6gb5v5bSKEpmace+GhQjl/XvJY31/VQ30W5XxsQwnj8jlKwN/KBPFO5shI3I08dRdK/xtolFfeOJ5tH7qY3AaP+8Aw5+z+Xd2zdEIyauXMW8XjJ3hZEwlCeTAZQ4pD8qvMn4/+MEU4ghdiwqIOQXr0lR/NjNhHScrLKh1Sl76Db7SC8z3sGjdpsepYBXKV7l9koAw/XgVC5NJtxEG/cQxuP45qIiQKRPbRhTANG7cb0TFOmDgCQgNrhZ+XNnVSwHkX3js3cFk0inLCewtcs2WdFWm/hUkTNTJCU81sPSUZCgeCd+dpK8lXYZgey6nMlB4peXHTVT4kzFxstErF1tlqmy2esX4bxF/ECeHHodx0DkO3MtYyUFcuCxpkfJPpFIIO3Dm42Q7Xso5KIOAy8txfogXFFGksABBIA4RKV5KwtTZDIYLKFHZq+BEZzInNuZGVksp1V4S/l7CaL8aLz5oUi7Es9tAxKMRO2tEcPbrQJDzcNegkz/lDlplUbCJLFBcgJRiRo2oRDEtnQQJxQgcGrMfqSxCesZcEzFnNKBdOL7Wuf4+E7DS+4Eo
 mj24MKtl
 t7wAh7myM6pp7ZdZI8eMAd/4syA/2jZOEMuomgoZSsdS8xrYEwqNq4hAli24qJnpfMJMaAGRh4jkjL2BLWRZsohigTmVw1yYNHTwpPzKGcq+Ye8xQz3p7byOV2eYfvszjd2RbNSMmtpqQIZs/qB6yc/E/hQbHUZRRJ/lAIHkABW3kVBJt79daSQ5mHrVSVxU90QDFilDsYHvusNrGK3PJoSrcVCPKAES4fuB6EzwU9DrgaLBxbTUmnr0n/xm4B8NvVJ4hQwytka450gGgcw5EsxFf8Cr7P79KAdiQYmOlaAv91QzMELmIAkKFrtfFrYPgWY8jIiKp36Ea7RNpCFK78jUQkljMhjLvsvLSGHkHUwfmub7vThfru0YQQ00hHba02b35+xFpzpqvPzbSx122aev6REI5uJr6XcB+Lo3XKZyNKdIuxFT7ENphwIgs07/DkIeCbJ1V4ZhQVrw8AQsbN/lXBh/iLx4IOQMQWTAwDSfheFQTC5MDrrfC01gisxg9Ko/rk2unxkQ/oz0TZorHheOcFYZPA5cj2xQu+uPsGS1oTYP3bWxmWbC3CPWWiyVU7KBJUOAlHPNARUk8aL/mIas9geI43W0qfm/OH+477oHZT6zkzvUguC6BmfVpndE0CYqjoGC9BFqAYtYrHa5jsfwElQQX4LY3JOQxHlvTDjUUaHjSOtQcqkYi9fyNBHOIqCPapGru8baSxKp71834QTTz4wWdVuwin7fWw4NHabOvVqCinrlTcqOFVDazO8NAM3o+GQai1axAWOGsMqvmtaRlwgPifHNGvrFnYsqAEcELYNfdJheD4UOq25PK/feUwVPv4BEkId2W83wowV3DMFlSPCE7OfVVeVYaUelY2/0vGJ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 08-09-25 12:52:03, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 02f310fcf47fa9311d6ba2946a8d19e7d7d11f37
> Author: Jan Kara <jack@suse.cz>
> Date:   Mon Aug 16 09:57:06 2021 +0000
> 
>     ext4: Speedup ext4 orphan inode handling
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16645562580000
> start commit:   76eeb9b8de98 Linux 6.17-rc5
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=15645562580000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11645562580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=429771c55b615e85
> dashboard link: https://syzkaller.appspot.com/bug?extid=0b92850d68d9b12934f5
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168d2562580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15869562580000
> 
> Reported-by: syzbot+0b92850d68d9b12934f5@syzkaller.appspotmail.com
> Fixes: 02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Hum, yes, we don't verify orphan file size is sane. I'll send a fix.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

