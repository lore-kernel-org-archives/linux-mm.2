Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C12FCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537898E0081; Wed, 17 Sep 2025 17:42:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E85A8E006B; Wed, 17 Sep 2025 17:42:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425068E0081; Wed, 17 Sep 2025 17:42:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 322188E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:42:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCFB4C058D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:42:33 +0000 (UTC)
X-FDA: 83900066586.13.EAF110B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 13238140005
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:42:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=fujaylDM;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758145352;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WiA4cNkcVugPJeaGJ538psZmIXMv7YQioKZQ8gTrQT0=;
	b=TnTaMVD9ZCQvx2RrCvocq2XyB5T7RVVd1+lZckMQWLDsoXG/g8qbe8uI2ty3HT4lu4TCtB
	YZ2o7KpLrFTF8p0CazGM8WXX0YELNzSTviWFh1ijjw4t4NBPFEWEU+WIAAAFp84dmnkHAs
	TgkgKQ3nbMIAFazTJepbMpNfqoEsroA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758145352; a=rsa-sha256;
	cv=none;
	b=iaSRvjBNPRiUYSM/WSDb8Cs+YgSokIvCLYvG2wB4o/kt1bJ7nVRJibsqNHMSD2B99VMn2J
	Eu2qMa4dUtodwic9winl+1IMMMSIEi8GHyPHbdMj4srNRIIrFUWIZDFQQeYRhXYWj1P3m4
	jtIjpHoZLoPWFiDIL90ONqxNdQ3Ue6Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=fujaylDM;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WiA4cNkcVugPJeaGJ538psZmIXMv7YQioKZQ8gTrQT0=; b=fujaylDMlrRZuozd8WGkA8xUs5
	obML/9dTfJzLt9IZahq8QmdwdaWWQl5tfmd7fCVNCSfVy5C+HY9i7X1NO56ExQdhDkdK6Xv39xACN
	ZXDE1aty3ryZ1rZuFk5n5/XRYy4/lbHFbwQq3N441qXXfLWfAx6dC6AlsLxy6QiyUwOv0yZVUINox
	wTbtmE7SJIqu6x/IaMZWGZmSmeLbEQ1XaJu3/x9UIizNdsxmz2vq1WPywbEJeCJTI4+UjF2g37jtX
	UqsMcs8q0e9m7Q0HBxKxXE98e785EEp7vA1+aJxDokL3q9vjL/Zd88/Y0oXJRQzIy+gxiFcKc9cLB
	2jFsJGEw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyzv3-000000098eu-2Sc6;
	Wed, 17 Sep 2025 21:42:29 +0000
Date: Wed, 17 Sep 2025 22:42:29 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Max Kellermann <max.kellermann@ionos.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	ceph-devel@vger.kernel.org
Subject: Re: Need advice with iput() deadlock during writeback
Message-ID: <20250917214229.GF39973@ZenIV>
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV>
 <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
 <20250917203435.GA39973@ZenIV>
 <CAGudoHGDW9yiROidHio8Ow-yZb8uY7wMBjx94fJ7zTkL+rVAFg@mail.gmail.com>
 <20250917210241.GD39973@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917210241.GD39973@ZenIV>
X-Rspamd-Queue-Id: 13238140005
X-Stat-Signature: kc3jny4nq8rch7b3tbruteqenwwxrgu8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758145351-485124
X-HE-Meta: U2FsdGVkX19sQvPNzQxKytjtucAf742P0TyKb7ysY5Hp7nxVUfQ9yhhGbV9lRpqtKR6IU55Cc7rrQo19hN7lKjjGRMP4g6xPd3IT80FHwe5CBfarSCFhmkTVprHR+hvkcUshlWKVUD+lAPsC7F3QzJbizf4H1k2uw7kKRihQ+zYZ9c3usNgyT510PXB3V6SXLoznKPVXzaG44ldyYxpDqiE3uqbc8Cjo+BnqzYrhU5sPR5UZg/9FjuJyoTsnZ16LfShruKUV4S8MyO2NBJ4pR5R80YhuC16qCiGwP5eJo26V4hERm/BhLFlDYY0TyIXdSvEPi5GosaHNt8rCN+mu69lW9jOMZkC+Kte1Her4tj1tdtCGqFREq2xqjZpXwV2yKGVyn9olQzreznxX8tm6/ofDjTM88l8hue4Q8jjtGsm3bEdaYg6yLvxeiEoS+9IjlS38S8U50jEveQoNwCAb2EHQJcwh65iYuztQZB7WlX3ocxx3UqFAffTz4mzKcXiL8OZvbRTK5XJm3xlaZSN1f54xNhz/6I8fdlCxmURtGziRT7KP3msWF5LImtFSzR67fle3FU1JpATqfEHIEPzo9Gvkq1llddaDRmGZqBeyU0cOowDiLy1aYE0cOrvDVZ2DTtaik6mLFzUa6/PZFqH+3TCYPeaOFfW+e4tvGW3bUcFmN27tZMLvd6KgbC27CUG9nJC7UqDPVslmzYnSl0AoDeKTdapzkU8TxVhEC6IwzikA+nqUqg9uJfyM2jfvCuOggjR/g0NDirJ18HaNIst6M9Qd7bdji3iirJqAhvmuYHqGjCc+Sn+SJR+7NKLldq+1O2sh5HlIMjo/6+RpKKE6wKpwBDVnjW8uVmYi5chDBbE9LKyZJA3YyoNKEmTLdccRln1IfyTK6bQR6p7Q8w7l8hvNnGKuLtNWl3V64aORFIMna0jilo1b4IDvOeoYbyZHRKhHtHXOHpJuzULhF5R
 7K93+fzO
 9IMsQgDwgktCQQ6bnmIoK1kZES2B69nxJOBUBOiCcUJNeBKTT2I5dHILC4Ohh43V9AxcYUrniIraL5dB1E8cdw5g+LCwrowQLPDm1zWgXzNWIUpc3SRAfoNHgdvxaZM+kbL+22MEDx7alFCZSreV4d7Q3OBUx8c/QAAOBLE8R8hDpDfBmSma4C8ljss3q4AenycLOYAWcAKbTGtZwxp0YDton2IgvzNA83CPhn1ztexk/nAR9nGx5V2dpFvmCOgSxETcgA0WPe2nb8uvg3h97pTYineZN8ZQ/Lvxi0Q934VmwRjef/cYXqqR3sHYRdI2CfzOeog1xo3Gs4GIWg5zcDxpbnA1a5dx2a5OmCSqpR+438UxlwYmnd63lpFVZjnpO+GY0RvPBQ1/uZxusF22h1ke9cSP+J7Krbp6awLDfMkQ8cXdRsz7wwGsp3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:02:41PM +0100, Al Viro wrote:
> On Wed, Sep 17, 2025 at 10:39:22PM +0200, Mateusz Guzik wrote:
> 
> > Linux has to have something of the sort for dentries, otherwise the
> > current fput stuff would not be safe. I find it surprising to learn
> > inodes are treated differently.
> 
> If you are looking at vnode counterparts, dentries are closer to that.
> Inodes are secondary.
> 
> And no, it's not a "wait for references to go away" - every file holds
> a _pair_ of references, one to mount and another to dentry.
> 
> Additional references to mount => umount() gets -EBUSY, lazy umount()
> (with MNT_DETACH) gets the sucker removed from the mount tree, with
> shutdown deferred (at least) until the last reference to mount goes away.
> 
> Once the mount refcount hits zero and the damn thing gets taken apart,
> an active reference to superblock (i.e. to filesystem instance) is
> dropped.
> 
> If that was not the last one (e.g. it's mounted elsewhere as well), we
> are not waiting for anything.  If it *was* the last active ref, we
> shut the filesystem instance down; that's _it_ - once you are into
> ->kill_sb(), it's all over.
> 
> Linux VFS is seriously different from Heidemann's-derived ones you'll find in
> BSD land these days.  Different taxonomy of objects, among other things...

FWIW, the basic overview of objects:

super_block: filesystem instance.  Two refcounts (passive and active, having
positive active refcount counts as one passive reference).  Shutdown when
active refcount gets to zero; freeing of in-core struct super_block - when
passive gets there.

mount: a subtree of an active filesystem.  Most of them are in mount tree(s),
but they might exist on their own - e.g. pipefs one, etc.  Has a refcount,
bears an active reference to fs instance (super_block) *and* a reference to
a dentry belonging to that instance - root of the (sub)tree visible in
it.  Shutdown when refcount hits zero.  Being in mount tree contributes
to refcount; that contribution goes away when it's detached from the tree
(on umount, normally).  Refcount is responsible for -EBUSY from non-lazy
umount; lazy one (umount -l, umount2(path, MNT_DETACH)) dissolves the entire
subtree that used to be mounted at that point and shuts down everything
that had refcounts reach zero, leaving the rest until their refcounts drop
to zero too.  Shutdown drops the superblock and root dentry refs.

inode & dentry: that's what vnodes map onto.  Dentry is the main object,
inode is secondary.  Each belongs to a specific fs instance for the entire
lifetime.  Dentries form a forest; inodes are attached to some of them.
Details are a lot more involved than anything that would fit into a short
overview.  Both are refcounted, attaching dentry to an inode contributes
1 to inode's refcount.  Child dentry contributes 1 to refcount of parent.
Shutdown does *not* happen until the dentry refcount hits zero; once it's
zero, the normal policy is "keep it around if it's still hashed", but
filesystem may say "no point keeping it".  Memory pressure => kill the
ones with zero refcount (and if their parents had been pinned only by
those children, take the parents out as well, etc.).  Filesystem shutdown =>
kick out everything with zero refcount, complain if anything's left after
that (shrink_dcache_for_umount() does it, so if filesystem kept anything
pinned internally, it would better drop those before we get to that
point).  evict_inodes() does the same to inodes.

file: the usual; open IO channel, as on any Unix.  Carries a reference to
dentry and to mount.  Shutdown happens when refcount goes to zero, normally
delayed until return to userland, when we are on shallow stack and without
any locks held.  Incidentally, sockets and pipes come with those as well -
none of the "sockets don't have a vnode" headache.

cwd (and process's root as well): a pair of mount and dentry references.

