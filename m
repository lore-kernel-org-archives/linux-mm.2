Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70E08F46453
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFA006B01F9; Mon, 16 Mar 2026 07:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7B06B01FB; Mon, 16 Mar 2026 07:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7466B01FC; Mon, 16 Mar 2026 07:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87DEE6B01F9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:39:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 331A1B3DC4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:39:53 +0000 (UTC)
X-FDA: 84551731866.29.B3A4E5E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id D228B40012
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:39:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1VOTJ/CI";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WrcwIU8w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0FCXMhAH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZwBt7GoV;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773661191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpogbJAKqrlr2Jx82XPikBWtnw8kteDhEFarzwucIvA=;
	b=dw8U0Bhl12p0VT8IYCp2g93kAuQvDKQr6VOhQTG1+/Cz0U7WQz57da9Q4h6rhvVDPzAhvW
	gEdUO4DExp+6KViu5afWQd/UnY6gUCNgvDltVbIhZ/hEpASAHdKK3zjiRy4x1npSkNYRb3
	pEQgcVFGeVDihtW2/LBF4/kDiRYLgc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773661191; a=rsa-sha256;
	cv=none;
	b=pV2J9fApiw69jTz/b1ti023Ms/1WOR/YTpEnyEKBoDQWbCD8NpIAMbq5cHXxMw8BwYukw/
	aXSI8PSblZjL6rwHOgZweb3sgdnxSFp1Rn9W4iKM+XYZdHHc9S+Dt6/+LNDAMt5Xr41s1e
	xY/s8FtDX/KlCFqO59XmxN0x/k4vCTQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1VOTJ/CI";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WrcwIU8w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0FCXMhAH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZwBt7GoV;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1EE4C5BD17;
	Mon, 16 Mar 2026 11:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773661189; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cpogbJAKqrlr2Jx82XPikBWtnw8kteDhEFarzwucIvA=;
	b=1VOTJ/CIYARFeB4c0GGQe2fUkO3pN5fitVartjTKeOOv6lP4ssiBYqGPXhfjVouCG5x0yS
	UakA4jQQLeGmEnyvOcHkn1CIfi61jXbIyma9ljq1/Agvf1MYoi/+Vl5azAfgpH0Z/ibVNj
	VYBIBvsj2nbpzVwTYIK1XyC7uAolx3c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773661189;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cpogbJAKqrlr2Jx82XPikBWtnw8kteDhEFarzwucIvA=;
	b=WrcwIU8wRm965FXpM+VDVlVGpKbJDkt9Uug6sqYwvZYVi+ZWzx/BHQXO1pV9qRBUhuwxCf
	AUHlxupvyegNqkAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773661188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cpogbJAKqrlr2Jx82XPikBWtnw8kteDhEFarzwucIvA=;
	b=0FCXMhAH9XELfYxwGSJLOnqecKF/tC6PDzWwnuVLK1ylgJoaI+Td7JHOofVDa74rV/KmXp
	grxCYxehClvo47PaMja/Zl9/gfp/YrvO1jWbUQUNV7CDIn3ECtIyuvsmZTJVSCHz/L4ble
	8uo7UKa6YFWmdLJ3hvoxWgAsOGE9UsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773661188;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cpogbJAKqrlr2Jx82XPikBWtnw8kteDhEFarzwucIvA=;
	b=ZwBt7GoVI2St8qTK4fRIa4GWHWz/x8kyNZgD96KCVTBO9gzPgLfJRWCH5Nz8MjOys02hgt
	tgHGMd9kRcy926AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D41C4273B;
	Mon, 16 Mar 2026 11:39:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aZIgB/7rt2lOKgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Mar 2026 11:39:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F2167A08C9; Mon, 16 Mar 2026 12:39:35 +0100 (CET)
Date: Mon, 16 Mar 2026 12:39:35 +0100
From: Jan Kara <jack@suse.cz>
To: "yebin (H)" <yebin10@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>, Ye Bin <yebin@huaweicloud.com>, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	akpm@linux-foundation.org, david@fromorbit.com, zhengqi.arch@bytedance.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] add support for drop_caches for individual
 filesystem
Message-ID: <27l3ppyys6j7vto5w2qqxemekk2vvnnn4qxw3iddupdeby3dur@6ijr5wwa5gcb>
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
 <4FDE845E-BDD6-45FE-98FA-40ABAF62608B@linux.dev>
 <69A13C1A.9020002@huawei.com>
 <959B7A5C-8C1A-417C-A1D3-6500E506DEE6@linux.dev>
 <69A14882.4030609@huawei.com>
 <C63DBC11-B4CD-4D8D-9C09-E6A9F690FB21@linux.dev>
 <69A15314.3080602@huawei.com>
 <57055A1C-0684-4B77-80ED-4A641F262792@linux.dev>
 <69A6482C.6060807@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69A6482C.6060807@huawei.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D228B40012
X-Stat-Signature: x57doku861oscpjcq8pzujyxfxkbpp4c
X-Rspam-User: 
X-HE-Tag: 1773661190-135190
X-HE-Meta: U2FsdGVkX1/7wnxa8O22CWllJ9XqkX35/ZcV8JGuQBvwH/70ekSNefx0hbwLgCPTe4UsLY/qeuDA64jLaWvYvbpUUnYMNck9jI2GIL80uOXnqqH9AbZQjdHcU1oUqc6HV/0Fy/3oTz2XsGgTPc6dcNt04sVmfXpG3EF6v9/peDV8aGoKSN++nmJWys2FeeU3cBpQfk3fizpkeXgCj/KveZI4JPwW5d2DgnOvO/LUy30VW3f6jYPNZ/x/Hrsph21Hhyl6HPVuWSIq7/OyZWO2AJ09fVpHB6fnU1ZY2ce9HMnxCYYNdLmkWwqBVv2ZBXKV5xRlZ+9aliN5cR7shjvWtNUl1fwT79udqSAcjrp5RWzXzYRVn5mLmcrwq1n7K+OMR3f9t+F3aOTD/7TbfgTmfgYwWZr3QsO2Xh8KmhTu+HCA1t0+EihOZWMqxh6htQ+xv4N5B5GgrFGnkx73e9HNFktsb8fLZETjmcJdh+lMeWxGXUczEM/vO7VeMs8VdVOsccNW4hJrQS5zoOEploH+TLR8ZyepLCRi/BpwZ79DE+DiCPvyEOXVueW3ymfbHBU2mJq25gKQapFYhFxr7uqAp5oBUWZWD6TibCJY0iyjJM642DY5uwJF/JJGhvWPpq+Vs66M/hWe4Itwj7kKyUL7MFmzH/aZ4o2Z5ORcKuT9CY/NfUz8ykVhqb+OAK76TPSOhb4sdU8nenWevuX8NBcVsodfegkQpwK0sJDYvxtYqNzGfCAntaPwdbr3xJyoNlsDk5nW8Gvmj28uN+P7+pf231ibPWhy/gR7g8BpazllLBorGBV1YmIpeDX0G2cHkRAv+SZfjnbNXPX+YORTR3LR8w30ZPP9/iiZaqWc/iZm28DT6Lr+iP+KVMPJiaESPGavWjwI6RsVaEwyuC/uZ3DElr1HF0nVXaKE8ytBjQ7Y2E31iF6uV9cb4eWZRx3bJoH37mV08mAsVYYUDiWdIuQ
 vINQkm1t
 sa3U1rV4xKvPoAibcfuknyvalWA2qqXEKqaJEW+5mbXA4RFEccVSqzRSwKMB0mb8E97Z7t8ymVTzbmCe6ZNgnbLkix7vsLEZJm6T+icD+0CYrxMxuSRMn0bJlzrFKXrhfZqGq/LHBUvvFfWKIbRLyK6Vmc5Ci8gIowiMwQ+9c7KQiBR0CFOb5mdC89RK043ki7ckYHZP++kt4DKesXspu8VAzxrjimSJEbPoukBo1IHGNj28j0ahvZAQvyWUYstHOkY/5fjpROqZKPv1m6Xd0+envRMW+4BNfgddIBj5WiuvOtiw1pw9wQdQQl7kK/PoESz/F0ZKcr7SVKKYKtn7GWeHLPEmxbg9TEYdrlp90wn7Q5TUNHiP5mI/FwQJqKdWZ8gdtI5Prb5fCLMtEvdJqxuqQqn/4/FmijHoh8P1SUz086dL49niKzMBWEVYhmPnCWGB4HcGSCf9oqcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 03-03-26 10:32:12, yebin (H) wrote:
> On 2026/2/27 16:27, Muchun Song wrote:
> > > On Feb 27, 2026, at 16:17, yebin (H) <yebin10@huawei.com> wrote:
> > > On 2026/2/27 15:45, Muchun Song wrote:
> > > > > On Feb 27, 2026, at 15:32, yebin (H) <yebin10@huawei.com> wrote:
> > > > > On 2026/2/27 14:55, Muchun Song wrote:
> > > > > > > On Feb 27, 2026, at 14:39, yebin (H) <yebin10@huawei.com> wrote:
> > > > > > > On 2026/2/27 11:31, Muchun Song wrote:
> > > > > > > > > On Feb 27, 2026, at 10:55, Ye Bin <yebin@huaweicloud.com> wrote:
> > > > > > > > > 
> > > > > > > > > From: Ye Bin <yebin10@huawei.com>
> > > > > > > > > 
> > > > > > > > > In order to better analyze the issue of file system uninstallation caused
> > > > > > > > > by kernel module opening files, it is necessary to perform dentry recycling
> > > > > > > > > on a single file system. But now, apart from global dentry recycling, it is
> > > > > > > > > not supported to do dentry recycling on a single file system separately.
> > > > > > > > 
> > > > > > > > Would shrinker-debugfs satisfy your needs (See Documentation/admin-guide/mm/shrinker_debugfs.rst)?
> > > > > > > > 
> > > > > > > > Thanks,
> > > > > > > > Muchun
> > > > > > > > 
> > > > > > > Thank you for the reminder. The reclamation of dentries and nodes can meet my needs. However, the reclamation of the page cache alone does not satisfy my requirements. I have reviewed the code of shrinker_debugfs_scan_write() and found that it does not support batch deletion of all dentries/inode for all nodes/memcgs,instead, users need to traverse through them one by one, which is not very convenient. Based on my previous experience, I have always performed dentry/inode reclamation at the file system level.
> > > > > > 
> > > > > > I don't really like that you're implementing another mechanism with duplicate
> > > > > > functionality. If you'd like, you could write a script to iterate through them
> > > > > > and execute it that way—I don't think that would be particularly inconvenient,
> > > > > > would it? If the iteration operation of memcg is indeed quite cumbersome, I
> > > > > > think extending the shrinker debugfs functionality would be more appropriate.
> > > > > > 
> > > > > The shrinker_debugfs can be extended to support node/memcg/fs granularity reclamation, similar to the extended function of echo " 0 - X" > count /echo " - 0 X" > count /echo " - - X" > count. This only solves the problem of reclaiming dentries/inode based on a single file system. However, the page cache reclamation based on a single file system cannot be implemented by using shrinker_debugfs. If the extended function is implemented by shrinker_debugfs, drop_fs_caches can reuse the same interface and maintain the same semantics as drop_caches.
> > > > 
> > > > If the inode is evicted, the page cache is evicted as well. It cannot evict page
> > > > cache alone. Why you want to evict cache alone?
> > > > 
> > > The condition for dentry/inode to be reclaimed is that there are no
> > > references to them. Therefore, relying on inode reclamation for page
> > > cache reclamation has limitations. Additionally, there is currently no
> > 
> > What limit?
> > 
> Perhaps I didn't explain it clearly earlier. What I want to achieve is
> the ability to perform memory reclamation (pagecache/dentry/inode)
> based on a single file system. In the current network environment, when
> troubleshooting issues, I want to control the impact of operations and
> only perform memory reclamation on specific file systems. Therefore,
> some files might be in an occupied state, and relying on dentry/inode
> to reclaim pagecache will not achieve the desired effect. Additionally,
> I have encountered some users who periodically run `drop_caches`,
> mainly to clear the pagecache. If we rely on dentry/inode to release
> resources, there will be issues where the pagecache cannot be fully
> cleared. This level of granularity is actually unnecessary because in
> some scenarios, users know which partitions they use more frequently,
> so they only need to clear the pagecache for specific partitions.

Let me revive this thread :) I agree with Ye Bin - the more interesting
part of this functionality is actually giving userspace a way to
effectively trigger drop_pagecache_sb() only for one superblock and inode
/ dentry shrinkers have no chance to do that. In particular because for
example drop_pagecache_sb() will also discard page cache of currently open
files but the inodes / dentries are used (struct file pins them in memory)
so shrinker doesn't even consider them.

I don't have a strong preference whether the API for triggering page cache
reclaim for one sb will be through /proc/sys/vm/<some_new_file> or through
debugfs (possibly <debugfs>/shrinkers/page_cache or something like that)
but this functionality definitely cannot be achieved by just triggering
some shrinkers.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

