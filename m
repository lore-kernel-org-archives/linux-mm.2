Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 383DA606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 09:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G0aoPaWB
Received: by kanga.kvack.org (Postfix)
	id 2EF516B0646; Fri, 13 Nov 2026 04:38:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279036B0648; Fri, 13 Nov 2026 04:38:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 141266B0649; Fri, 13 Nov 2026 04:38:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E21666B0646
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:38:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9D28A827A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:38:37 +0000 (UTC)
X-FDA: 85429595874.11.B064FEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 55C1CA0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:38:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G0aoPaWB;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794562716;
	b=BGER3JZYms7smgjfvqmEUpGhfvKwhgdRXXprtUsHt60W7R5s7J2rHs5Wz0k2WeWZ43wub+
	/BHu7S3NrOBZ07iQABRTtbkkH5XEEV3TFzVtlDMvaYCj87IsRKveRsDLu64b3gMUwhjB5X
	OE7uLuWZup5LLmusZXngMQ1kDEa4tbs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G0aoPaWB;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794562716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cyYiEXj4r2TdfxUYkpb5oOHA+dMqnC/KnZCWbHMkenQ=;
	b=gv7h2KtiYpB5f0H/kYzAE5ONRx8y78v5F3eVrWULJxruM7VLoXHvvGFJmhd42mfuuc5BEH
	7AIBcN2RmuPaxUVKG2TjjE/FdK4dMUoFHv7Sumh2XF7xifZWGbgjHoCwp4gnMBX7sbSRfp
	FyDbwe5YkLXRWbb8hwOYq/Qd3tlx5+g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DFA4463C8;
	Fri, 13 Nov 2026 09:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F321F000C4;
	Fri, 13 Nov 2026 09:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794562715;
	bh=cyYiEXj4r2TdfxUYkpb5oOHA+dMqnC/KnZCWbHMkenQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G0aoPaWBd72jNdaUejL1FLrAnRK3dBg7nKImNWeUFNW4z4PCgCfYTdQz1fkRwVHmb
	 KMUT4o1pv98YTq4+sOb0DRnY5NA9AhSY9muPozYtlPKP7GITGIWVyqxlT2Lbe4gDgh
	 DUKeiVG6uBVTl5/xgukvDHNaOL5j36fa2FQ4TKuu/sqZvneH+k7Y9Kkvsr58uzYShF
	 m6liZNx7Yn9oUKVS6OG22zQht8IfiDOTOY2ocG2nLZ33OCWigHMStPuFGS8jRrcEDg
	 HPmsR3svBeIaC1O1WZTEBFOuB731AaPpyqUmnt9jeKGaFcyRTBKxm1yOv1bk0r5wv1
	 n093Q7JztiiYw==
Date: Fri, 13 Nov 2026 10:38:28 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>, Dave Kleikamp <shaggy@kernel.org>
Subject: Re: [PATCH v2 04/34] ext2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261113-hermachen-qualvoll-porzellan-adc585bf14d1@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
 <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>
 <20261110-kargheit-impfen-pausieren-881763d28b19@brauner>
 <za33axmgzmuzsj3zmfeh43fkphtcsqtkhhrauwuvs7aiftelgp@dzl6z322st5f>
 <20261112-wohncontainer-saurier-wonnen-91f30c3b3ae2@brauner>
 <20261112-besorgen-nobel-handschuhe-fb3373259b5f@brauner>
 <20261112-aktivieren-datteln-assimilieren-062b8257ed49@brauner>
 <7rm43pfkasky5th4fs65qdt4l2d6j3togha56idrqhs4524qca@u7socb57rg3v>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7rm43pfkasky5th4fs65qdt4l2d6j3togha56idrqhs4524qca@u7socb57rg3v>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 55C1CA0003
X-Stat-Signature: gy456o8ox7euq1qzcczjsqqhimrioasd
X-Rspam-User: 
X-HE-Tag: 1794562716-392363
X-HE-Meta: U2FsdGVkX18pvHsu+q3S5uMlIk12dtZhrxEM5rFemnDLcuDowovq719NY3SsR6c8yCgXfYF60gZ1IzwarnNcJWT7t4RCcERK/rlsJmhYhRbzw00sqAA4zTo/iwPuBISgix2XyrKYnuT88/dJYM21DCFx7nQHkhlQ6HEQOBdzxdiNfue2Zak/6u7fK3bE9358j8c2COJho9/PZCIi5Q9xgx+R4YFcUAJEyvAp/OiLOBOZuNTvkv5W3bfq29xZkvmdsh4yd6Oz8nbKODkFmocVwAovaDCxrGcEDyekiPfhWc7izOL3mS7loW0qYbXLQLrngvtBuFHL3qTrKqluW9LnSr/meXs6y+EilEHqUjP2GkwCIBQq3CwH8p8b/P8Y9L0lL3jIDrTLajOesxNhIA5CCtSwni3IiM3B9iBVaszMD6vJzZO/YeMoohJJvpI7DiDNMWdbOxSRER229tP6g3BLiivLZD/TCl4jFjeokT0sOAtTqJi06NP3qjtnrc8nrnxGEgBs+WX+tsZbqevbfIUeiVyKILeornzSVDrUevFcSRTBMVPRUgwdtCPKrEDlcLdZNfQDobjy9YqMllbq2xwOahbBQ2Pu4EluSCkJq7kPzhM1MgatdMLJOVzL1Zxu714qYnJvyhcSGOs4A1rJgbEdtCHS1N2Z9lxd2RtdtKx8W1QkmNs/PGWgNDBD2iXrJSSAHDcLyo80X+HRL8YfVqqNguCp9gYCUFmLB0SpFPnA0k0k4uNNd6sXcbPSwdsifBkL50RlMiQggXgCx7auv7Ve1HFHt0WWCFu1OGrRGjgUSqfk3i1oMQEo07JLQ+BqvyIKLpcJABodVwWC+GnH1WPl9gekdB2sOzrzp5HTHrBUUiyudbHyM6J4edsfJOlhmhkVDeR3Z6VXYxr96d0G5oTWTtSGE6N9jYXMLMpaO2rOaxAg2UYry63h/iUI2m1q7HYbmoU1UflPwl67ndaE7Gk
 48gd+4Uj
 hYMRKc5wLv6tgJZDuCyQ7MuhwdFpdXpNs9Ad/7U2lgGDz5/jId9blsdaYNCRewjmXp1qOJE2LiqZg3wIW5io8YiafUuPGG7ERmwpJ2sKcnonc/bY7512ccnnAXfxl8RnwOpz7q8dWsow7rfJ53qWG/YZ6mB2px/JXXFgAm/mlGc4xcTWVFZRXdNSRiZP4p36uUUIxD95UYzLFQx+4XQnlQuXAdItixJKQLZyIEnW9IfBDlZiVIj/PJUfSAztKsBjWIrMNPI2SskJIP4cpdrtlyloGJDHJ8e0P9VxCtIDZP5Fs2/8DD3yqgIC4caXG3AA04d1IQRkcF93gh9M36rfcKtdRCIDo91PCbigrrZIoocL++LlHN+lY343QC0RqtNRTNIIM7cVHRlVNWVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 07:27:45PM +0100, Jan Kara wrote:
> On Thu 12-11-26 18:03:55, Christian Brauner wrote:
> > Ok, so if I understood you correctly the changes below should be
> > implementing what you ask, @Jan.
> > 
> > It's a diff against v2:
> > 
> > - jfs: free the anonymous tlocks when evicting an inode the way
> >   txUnlock() does. That's also a mainline fix.
> > 
> > - fs: sync_filesystem() and sync(2) skip a superblock in the emergency
> >   state. syncfs(2) and Q_SYNC return EROFS.
> > 
> > - fs: refuse to freeze a superblock in the emergency state. Otherwise
> >   freeze doesn't sync anything anymore and the flusher keeps writing to
> >   the frozen filesystem.
> > 
> >   That means, FIFREEZE and dm suspend with lockfs now fail with EROFS on
> >   an errored ext2, fat etc. I think you said that you expect freeze to
> >   fail anyway. I think that's right.
> > 
> >   The exfat, ntfs, btrfs and ext4 shutdown ioctls then have to skip the
> >   freeze after an error.
> > 
> > - ext2, fat, affs, ufs and hfs: drop the ->write_inode() refusals.
> >   Otherwise the flusher writes data and bitmaps but never the inodes.
> > 
> > - ext2, jfs, nilfs2, ocfs2 and ubifs: their ->sync_fs() checks are dead
> >   now and go.
> > 
> > - ubifs: drop dirty folios and inodes after an error. Without the sync
> >   at remount the flusher otherwise hits ubifs' asserts after a remount
> >   to read-only.
> > 
> > With that nothing is synced on request after an error anymore.
> > 
> > syncfs, fsync and Q_SYNC return EROFS without writing anything and
> > sync(2) and umount skip the filesystem's own sync.
> > 
> > The flusher and the block device flushes in sync(2) and
> > kill_block_super() still write. So what ends up on disk is the same as
> > on mainline today:
> > 
> > Is that what you had in mind?
> 
> Wow, that was quick! Indeed this looks like what I had in mind and I like
> the result. Thanks for implementing it so quickly.

No problem. We're paying off technical debt, big time... So I my motto
is "let's go", so we can focus on the fun things again.

