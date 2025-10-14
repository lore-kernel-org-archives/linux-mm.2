Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C360CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 04:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5384D8E0007; Tue, 14 Oct 2025 00:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517D68E0005; Tue, 14 Oct 2025 00:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C788E0007; Tue, 14 Oct 2025 00:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 356388E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:44:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC60013BA22
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:44:29 +0000 (UTC)
X-FDA: 83995478658.28.EA5C5A7
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf19.hostedemail.com (Postfix) with ESMTP id 325621A000E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:44:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760417068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N5Kt7wPvvc/wzewQhKU0QPVkOeL83ITNaMjuXMkWATg=;
	b=v3c+c0ZeRau1SFY0ZvoBcKa+cwGxI9nylSvm9ThIEgKsr9q8IBQHTD2tsvzZvfhJ+c0XAe
	1Z9tROhT6thGWeX6OoMErRSl33es07RzEedXgB0VoV0M5ftTPwypXepGLhyvChIv4kTyfc
	maZkmbpH9F6E6uiOgHntcznTQRGkZ2M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760417068; a=rsa-sha256;
	cv=none;
	b=2UESeQAITkj5AlfYPiqJxkaF4ulpk+47NtUVrhV8RP5VgRHqzOVdvHckSlk1iLc7NmKj0v
	oZMVFOKt+hwA58ix/sPAwiofn8zR9Ls1RimWzYoB9IMily/XvWxXACMfUDFSsr7h0SfthR
	76PcNHJdUgr7S4mkBPfYlmcbbzSMyY4=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 26F11227A87; Tue, 14 Oct 2025 06:44:22 +0200 (CEST)
Date: Tue, 14 Oct 2025 06:44:21 +0200
From: hch <hch@lst.de>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: hch <hch@lst.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"v9fs@lists.linux.dev" <v9fs@lists.linux.dev>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"jfs-discussion@lists.sourceforge.net" <jfs-discussion@lists.sourceforge.net>,
	"ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 04/10] btrfs: use the local tmp_inode variable in
 start_delalloc_inodes
Message-ID: <20251014044421.GA30920@lst.de>
References: <20251013025808.4111128-1-hch@lst.de> <20251013025808.4111128-5-hch@lst.de> <aae79ea0-f056-4da7-8a87-4d4fd6aea85f@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aae79ea0-f056-4da7-8a87-4d4fd6aea85f@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: 325621A000E
X-Rspamd-Server: rspam03
X-Stat-Signature: iyae4npahs5oqbum35ed5x8awq6gci8r
X-HE-Tag: 1760417067-915531
X-HE-Meta: U2FsdGVkX19FBPDzo/Ym0s1eZy+3iHK5ZwuSgHkgqWTD3Jl7xfPWN2PooueC/3QJ+jw/IgX3OEkrlQ8M+EWWovyxguEIMkGhSIAMKlvzeKdjkPb2viCL1w5dyvJDDgPZgi4SS6fBLEPlKO8xmK1rtEmPHApSdJcRHGkb6YwbYB8q5K4kIvAm98lZfBmOKjqwThZQK46FdSRbt59f8J5OSxu7W7a7C1gVfIkG+aK/orTwwhjzMBR1RdgnQLd9Hnu4qwKddT6LgGtJ5Q1kORz/3B65SJPfVjhFUa6+dltjM1itaKYb08lJn9VNTteLQ4gYcT8dVeA6Mokfz1KPgjoMByHRvJYqqc7cB7mjdY1tNIpDU+05CtuGlAyXYJGEAtqjBPXecdERe3hltMT44bEnL/ONMpVzpaGTYItFH7JBG54hGX2+LrnO4qbTtG0r3WQo9Iy7K3mZdB+qfWToCT/dV0nXEkGT0oieohtS0lgInHgCbN/orqt8nDrR7N/7ogiVjUHmG5UmB3pnlVIlmBZwggdJrzPWOrPcU3e2zj09Y9TP2+kE3Ssdiphf87wEdMY5wJPBzpS12DFG+xxlS+xHsZGH2R80vIuARnQivgYBxcKiYjtlLhj7C1MzrljPSdRSqF+VO95FGF9GFiWeftqFDoRwE14k6Q8iJTZiQK5MT9IGiJfR5W0k7N2DNq14xEbp32Hc8BTkWlAqA2MkVN+1Z4pToM4wPTlatvkMsVAEdBnDt5MQoxvI4P28JHUwdGYE3RZW88cOAH6V3XjAk/N2rCTsawF7BzyZQLyRzrXMJr1RPue5QqFbOozlYR/rxAaxAnXxHv6CcaSVOsFZmzeXolzzESrwPdJqvCn5SdwVH4bMGvuMYQx9dRKnz6GhL1kw5fbfM+8aXxT8GXJrNj70m6ibj/Hy3qBuerE6j+TCco/wW5fE5zLsG1dT06WOTC2XvImeIlpt5bf/3jh9g3D
 duSbXjC3
 1q4fJBKRKBuIKzANfnntPtN9PNQM//iAPI5adj9XRXCxMwkHMTzA5YIe2+4b+scsfiViWsoM1ugQWegpvccMI5hW7EBWzn3/D65cn35z2IdUzu+x0Z4NsFm9awtKkeOXHHQLOG4QYnKUanXX+1wCwFoWGggOAnQhU5+kNf7Zu0j+KzFtdE2MELHzXcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 08:11:35AM +0000, Johannes Thumshirn wrote:
> If you have to repost this for some reason, can you rename tmp_inode to 
> vfs_inode or sth like that?
> 
> The name is really confusing and the commit introducing it doesn't 
> describe it really either.

It is.  vfs_inode is kinda weird, too.  The problem is that inode
is used for the btrfs_inode.  But if there's consensus on a name
I'll happily change it.


