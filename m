Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48206D2D0E5
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A41846B0005; Tue, 13 Jan 2026 07:24:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF226B0089; Tue, 13 Jan 2026 07:24:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0796B008A; Tue, 13 Jan 2026 07:24:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BEB76B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:24:26 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1AF2CC1677
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:24:26 +0000 (UTC)
X-FDA: 84326858532.28.690F0FC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9D8E61C0002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:24:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VdgyNy8M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hSt4CMZN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MwX0zJhU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7OBoEB0T;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768307064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VIREq6KcfFEqYToZSs1rcoXYYB9B9DenDKR0lGfaUg=;
	b=GM+GlImitLU9Q56InVunRex7uuP2DLXfnQffjVARmmVA0MVn5sNVeGUjh4R3uG1OrrQUi5
	AtGyL0QNQtJh9NzADWkHMDM53FCHe19eicUMXu2u5kdCfZQ4ZDa7ontSME269wDz8uniYV
	78FmCc14KeHpVs/kyj5iZxIZO20afJE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VdgyNy8M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hSt4CMZN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MwX0zJhU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7OBoEB0T;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768307064; a=rsa-sha256;
	cv=none;
	b=gBlhxiLipyTvNNJ7qZcvVWLrmYjgr3X2+7487C/xF7X06t2NjCoKxYq2JHCzGzv6vHFLVo
	ArutlJMImHcxwD8mjrTyrjAPgMDkz2mEd1EElWEzAkIkp6t0R/2rZfjFmT4ssNCZq/NgpV
	7TDFtT8ngFwanfy0t0PFx392ORJqfBE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 93FCC33684;
	Tue, 13 Jan 2026 12:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768307061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4VIREq6KcfFEqYToZSs1rcoXYYB9B9DenDKR0lGfaUg=;
	b=VdgyNy8M1/cM9/fXaeF9wajTIaQ/Xp/iUbQylO3k9E0wO529LCOKyPOPId63l/2cDlI/ZI
	ZweKn//WYVVC2NwsfBzh+7Em6cnohBxIK4TH4x4yzRu/Jo1q6JMnW8EORiTCcTyBTId6FD
	YSUPvGB9fSdd8ymeF32tJXRy7Bf/l+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768307061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4VIREq6KcfFEqYToZSs1rcoXYYB9B9DenDKR0lGfaUg=;
	b=hSt4CMZNkuG2lUSWPL4AKxbM2Z+KtR5t99rvk3EGsNk9SHH0ufAlxo8z7T8Db9FmOs/FuT
	HubkgGphNGa+s1Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768307060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4VIREq6KcfFEqYToZSs1rcoXYYB9B9DenDKR0lGfaUg=;
	b=MwX0zJhU6VREU5zdOR5cKxeGFkB8zi5R09otc0ZT7h9sc7jG1bD2RT8l0ncMREESNL/TxH
	B0+ucA7tilGghbTP2NSeLAhWhPLFWr9RoTW6Po2ZWRc0h4CmpGfIj/g/CB5kPz6Rd0/Nt/
	IIjdnfWmI30YD5Td/uIDAp1T3Xw+LY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768307060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4VIREq6KcfFEqYToZSs1rcoXYYB9B9DenDKR0lGfaUg=;
	b=7OBoEB0TZYVGqebUmFP+wmOAV43mhWtkMLsJjKrdSGi2XJt/HRjTZXGyZiG+resWyua0t7
	o6dibttJahzzPxBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7FC973EA63;
	Tue, 13 Jan 2026 12:24:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id O58sH3Q5ZmlYUAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 13 Jan 2026 12:24:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4307AA08CF; Tue, 13 Jan 2026 13:24:20 +0100 (CET)
Date: Tue, 13 Jan 2026 13:24:20 +0100
From: Jan Kara <jack@suse.cz>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, 
	lkp@intel.com, oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	Dev Jain <dev.jain@arm.com>, Jan Kara <jack@suse.cz>
Subject: Re: mm/filemap.c:3307 do_sync_mmap_readahead() warn: assigning (-12)
 to unsigned variable 'ra->order'
Message-ID: <s47y6ysj4c2z5c5axtxbeset4divigctg4s3p7gbgmvfkoizeu@malcpodvrm46>
References: <202601131311.g3lyUAks-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601131311.g3lyUAks-lkp@intel.com>
X-Rspamd-Action: no action
X-Stat-Signature: 6gsimknkt4s4yqy1q97brcpbsubwtbi9
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D8E61C0002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768307063-350732
X-HE-Meta: U2FsdGVkX19T6mhTI7BQHKf4UolzSBd869+raG/SfgHObR6qY/RJXXc79cTvxjvmc5F/jgKhBdQCHE1BqozUURVF5vm6HSuo7YF5oGCFIYedy8/ynGC6oMpEz7jC8REYXIctMRGh9IRFgIGxIKj/cD5rkr0HKpgaVZ8S+ZVDYHmT3D+3rpPUYRji/rd7J7CTpK8zL7CMnFA9ho4ryisywofAOM9eLAj303nycbWpbijyVZsBJXeJr72HoemTS6TfUt1MIUdEfZ0QxmACuOBtpEzG2uN3ngy0Pt7hVD0DpANSWZfg49eN94WLBQr9xw2glVZ++bwF8v44jWUG/qDNdtUl4lEQMgoub4dYutn+p8PWlUsMv6zs26wx6Y31CfsB7qhtZtJn9ldM1Zav5S4PgEOLnlvjGX38/lZZXimGx6ghbLVpDG+9wWg0tT5c1jKYt3Q39Zniz6BTviA++bxWD1NQPmDfHNtgZOCcOLYP4SHbLRqTH8mP47Sos/xstbnmTDxR4Dx/4msAlN3wacYlqHm7Oqwz5ViRJM2JpG/HPcDBiKDboZL73vxpoubbgCcIAjNFiX3dESIei8PcT5+123cddn5v/+MNYaoW5X1XWLYvh/EV29oA9mc0X1dysiXoSiYMcLh8bozfuktnlLI3es7vKWswSgLU4C/KTJC2p28CgsYiUJc+iKZGmKLcaDfAaNoMdEHuiZYFuKgB57p2fG0/V9SErBMch0eJHO7Mden1uFEY97v5ggtgxsucXGoJnsdJi/By51WGbthm1yiRXPqGgx07bL3b0JzKSSPnqC53MHk6tVA40QRRSTRldVNF0+IoLuMmWuRuhMON6u4lS836dl1vt1GLyBb1+ePcmy06/WuVAXs/ur4cKh8swuh+yiRjdRSdSxoRC81TsKQ+fT9yLl+Log7EN6Bz1DLraANi/dhOze1ISI0WPZRBIsP4S5dvbS8uJVyxDypWbPd
 SSDMFRTM
 4tV/LYz9FEKjtjaWBPnI28kau2VqR8y2sAN2psgGUyEU4AZKkPIi3wUzitksgAMs378vqqCCWa+U9rksDDsWxNR00Mkdi6cCRKsaLiKWqY97NlSPsOp0VGLMKR6DLyD1t3PVSkExKIUgi/EfqyPgrIoBTT6avAvlm/GU4CGTGTrWyTbAAsM/WnS0cobmXnJvypGs9QbrN2W1XSQyOM7nxm4Os2mtK4Pmme/AnNEC6eFx9m2JV05y7KRRLYkSXDJqHohtqlUfHUP3XJTDQbQWcJEQM3m5LG0ksbB2BYSvivHeWlBiPUm5xqQl26qYGNb81dh21TFyaMIsgUWu9hHuZsFYHTBk18leDq86L6cGciLVbHYSW/b6CHVTKFNrrhAeeCrD0jHC2bmdbjnYGfA9X97HMuhGiYKbXNvK/JCQgVJPK1FHie28ndM5OQBt1g5S2dQ4EaDDo6t/CLjK1DMr8V0/9AtZ9l8+C/l7Z0+CzZP1ealU07e5KHo99Ei4lUOk9D5A8hSwHarlz6o9szB8zRQ1BVeb6NEeuKcneTyGmul7sUu3L651RH/M/eYCKHYBCsZ6/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 13-01-26 14:12:28, Dan Carpenter wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   b71e635feefc852405b14620a7fc58c4c80c0f73
> commit: 9f1edf1aedac1b287355f63f768ba4275de72dca mm: readahead: make thp readahead conditional to mmap_miss logic
> config: x86_64-randconfig-161-20260113 (https://download.01.org/0day-ci/archive/20260113/202601131311.g3lyUAks-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> smatch version: v0.5.0-8985-g2614ff1a
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202601131311.g3lyUAks-lkp@intel.com/
> 
> smatch warnings:
> mm/filemap.c:3307 do_sync_mmap_readahead() warn: assigning (-12) to unsigned variable 'ra->order'
...
> 9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3306  		ra->async_size = HPAGE_PMD_NR;
> 9f1edf1aedac1b2 Roman Gushchin          2025-10-06 @3307  		ra->order = HPAGE_PMD_ORDER;
> 
> HPAGE_PMD_SHIFT is zero in this config?
> ra->order is a u16.

What's the config exactly? I suppose CONFIG_TRANSPARENT_HUGEPAGE is
disabled in this case, isn't it? In that case force_thp_readahead will
never be true and thus the branch with the assignment can never be reached
AFAICT...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

