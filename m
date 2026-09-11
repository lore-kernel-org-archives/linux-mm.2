Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9004C88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B84B6B00A4; Fri, 11 Sep 2026 11:05:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06A946B00A5; Fri, 11 Sep 2026 11:05:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC1626B00A6; Fri, 11 Sep 2026 11:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBB6E6B00A4
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:05:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB53412027A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:05:22 +0000 (UTC)
X-FDA: 85201804884.04.5543860
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3944540005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:05:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IEbzkop0;
	spf=pass (imf01.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789139121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F1/KDdS2USdUyGR5XiWg3ho+mGEZKHR3GUWPOY9FID8=;
	b=XKOFZera1Cg+tqbVzmjiehWswVdvsqrDYWjtLOUetqIHPC8q0dflRsxTjRZFSPOa4AqRO1
	q1JYErLBRlFATx2ZR+RkjqG79AL0PkMFv4sxVT2zs1AWX3nP4L5+0o3G/mDsd55nDBwWmz
	Hq8OqvvcOKuRAjRFl6TuIFDw/y+PzSA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IEbzkop0;
	spf=pass (imf01.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789139121;
	b=6U7wMNWsRqcJN3NxA1fgVXP2zGWNzxlqtdufnh7uU0lrfhB7qhjAPAh3QiBL1gxq/2IYS7
	d9qezi9Il6OQdoYpLAuRjTxww42Y8XgwCsqdRvbsQySypqy4icQVM9Vtlyl80Ulya3ra3o
	4jjeAlmljNXnJJX4MNWsh6ygwdwE0lI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 3D9A44478B;
	Fri, 11 Sep 2026 15:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 124B91F000FF;
	Fri, 11 Sep 2026 15:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789139120;
	bh=F1/KDdS2USdUyGR5XiWg3ho+mGEZKHR3GUWPOY9FID8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IEbzkop05s/iqjVqRTFhoFeuXLx2TOQ1ht2oPNufR5t4VeP5RNyxjyi5qYgqLxrhO
	 kUBE0G5W+aB1FsvHjbY3UwbjjREYCpcYaRV97qCPRQ49YMrBElE9lw2Nq9ZXU/wzEE
	 JEz324WTIFeQzjFweLL+x9QsAJCmam/MvENPDMv2FYF/9X2UVi870KlyPiGi3VNszd
	 XSWYeTlHITdTP81xB/WczWAUNpjIQGXwxP4QuPeU/a2D76PqlNEvDWpM4QbuCMmc0r
	 3EBAhFZnTX5eOops8UnxEbEqLtD2Oit8h6JssMRtHO0Vr/lMKQ35G7Pi7UpRn+cpu4
	 mdFUPRuUIqXTw==
Date: Fri, 11 Sep 2026 08:05:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>
Subject: Re: [PATCH 0/5 v2] fs: Deferred inode reclaim
Message-ID: <20260911150519.GA6244@frogsfrogsfrogs>
References: <20260911081309.14137-1-jack@suse.cz>
 <aqQV6Uwma_KjUH0O@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqQV6Uwma_KjUH0O@mit.edu>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3944540005
X-Stat-Signature: xspwr1179zuwroq48ju1zgzucfoxy4od
X-Rspam-User: 
X-HE-Tag: 1789139121-541248
X-HE-Meta: U2FsdGVkX18cCZMJE+X59UQHgh01J+OQHN9bZf8AqC3+HQfXkcPrvcwlutK8c6tPGjXpXLkpbYsICNZbdjsd/fcA2L3VpWYWf1g0iaRcmVNGJ8gNXSNpWrz2oC6htnlNcLIPlExgnbJAnQzjvQsyNVQk6I5N6kNb1Gb27px+RVZa+BR4JNHC1A+j6RnFtaZwH6H9ONHThfhgWTyGhV2LIGubgZ10ekK00oCCGxrILp8ur1CppmB2GM1xNWTC6uuK0+s6xCwosDDgbOB86i87L7j79B+r6ps/SkWkkigg/T2UW62SwUt8/grWsF4XTayeGLljjViowMibp5RwiQJU5FC69gVePC0GSSHBXdo8zsvepkbeLgTLp1ewY2q7rovNQeUqfJZTR8GEv649A3/PVbbAQYa7vcKSnfao1jRCKTqsmBToMgNQ757tCefG/c2ln2BUZ59glsI5FjvhXMWtCEBXFpaRUXX/Rkf0BBPbiB8rpDfNCfQ0UW+mHwJG8JVSGp4CMqydmPNY/FkFDPFT0+OHwfYA8F5HZvOmCpq28JjoWLwnFMqWIezWHdwS72c9IgwdVIf7fQlGaA1qGnZ+K/8Lr0mMQ43aIucbWwry5TScOH59Ip/n56xTpJ6UTK8Ppgfd1LXpspm8iDNsag/mOSFVj88onNRGs9L4daKAepqPhXOr+0+3YRoei+xV+DltipeKpZRTEHRUx5kiArhtFEMa2ZU0mJao4zPSHrVssn0ft7ccvuaoUtc+E3TtiagEaGUDBHkNyBjuqhqroBNbMojaBlLISSrs84Oh/8dlYJqGt04b+dWdUa1Za0daEn2VEkdcrHlS4QCo8d8c0AByEvXS9z+iEQMhy84rpLYRTP29Ci3ExZ7lzWSyrOotgRab001jB4A6ZqJfrlV6gkNV1n5pys9VhxNm21+Fstc3Rb2gIDYb6Nz/H1Mhc/1shVXrwcTXqYfCQjYxXJutPPl
 m5V1ZtcG
 ZDri7S+ymy3ofAq7Gka/K+oguvAn8+o+T1e2/VoBqfTrFX93OdedYmP9oSiVZD2nUpaWbUh4YLDjXbo5VH75MdYI3RRVql9wvFaEeMZvRxhIcyxPNiEzRc1boNDE8/tLyV1jlC0eZY1wmWxwDjdTgBKmWtKF5de801Cm6dLAG/43wOfB1sSoY/L50DAnXz1lPzycHG8nYaXx5FokoSQJj4KJSuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 10:55:53AM -0400, Theodore Tso wrote:
> On Fri, Sep 11, 2026 at 10:51:36AM -0500, Jan Kara wrote:
> > 
> > after a long pause here is a second revision of my patches implementing
> > deferred inode reclaim to deal with MM warnings due to GFP_NOFAIL allocations
> > from reclaim paths. This happens because to reclaim some inodes, filesystems
> > have to do IO including complex operations using journalling and forward
> > progress of these depends on successful memory allocations (which is impossible
> > to guarantee from reclaim context).
> 
> Thanks for the patch set!  I wonder if it is worthwhile to wait for
> inode reclaim before freezing a file system for suspend.  On the plus
> side, it leaves the file system in a more cleaned-up state, and
> reduces the amount of memory that might need to be written in a
> hibernation scenario.  On the other side of the argument there's more
> opportunity for freeze/suspend deadlocks, and more complexity.  So
> maybe it's not worth it.
> 
> What do folks think?

xfs doesn't flush any pending inode reclaim work on freeze, since the
log will be dirty and log recovery (if the frozen fs image gets
remounted) will take care of that.  Freezing to make a snapshot is fast,
mounting the snapshot is not.

--D

> 						- Ted
> 

