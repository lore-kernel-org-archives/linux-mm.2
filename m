Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E974606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lmyAiEce
Received: by kanga.kvack.org (Postfix)
	id 1433F6B0572; Tue, 20 Oct 2026 18:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11BE86B0574; Tue, 20 Oct 2026 18:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030276B0575; Tue, 20 Oct 2026 18:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D20DE6B0572
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:10:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A75A80401
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:10:14 +0000 (UTC)
X-FDA: 85344398748.16.7900E39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 853C0100002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:10:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lmyAiEce;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792534212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wC7eO4Nqk4KZLdcN14swpHZxWyRamkg0re5UUTziYH4=;
	b=vBSWLs8YMMENKtJEeRR8Gw1+8qLvKM2xylq1pHIx9ToioB3dkQJ3h8KqkFBcPWwox/1D4q
	zpPiDjLU1DYs93GsZWUuVeSuS01otN8PZ/MmbQGgMRzjfdDBcQhKT2o7dQEMKR/O2ZA5As
	HkZOiFTWCm2cRU9gSK4mc7SUT3fyBW4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lmyAiEce;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792534212;
	b=Cn7Rg1gOJaFx2g2L1Qlk8ti7Iio/vpBaK7A3eCvXx2wwWDSqNkN8tE8Lm7GepihJ54OES9
	aC2dDqMBAJuyaY+RPPXjkLkdaQsnGrwPxQBJjFGVh8t+KIbDtcKwJGw20yB4ot2DPOm9FJ
	Sj52M5A/X24qxthVjz4MfZVJtHxRdUg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5ADBF41294;
	Tue, 20 Oct 2026 22:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E78D1F000C9;
	Tue, 20 Oct 2026 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792534211;
	bh=wC7eO4Nqk4KZLdcN14swpHZxWyRamkg0re5UUTziYH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lmyAiEceiohjlomp5OsDg06G4lKBLeNOnePW/C6m+WLvbu7/GPwhyNtKMrag/G2ex
	 n7+gXGQ76anfMREO1vbPugq1zolcX/+l+NCYmKEy/j6AeHEMuJ1ORGRw5qAiYcfTsl
	 21fbb6mP55yEnv38n2jZrmcPzR02+v0iO8kbuOl62YG8ZXg7sFY8ymYNUuYaGKnH1w
	 N5p9E8beCOJBLh21vIGh+PCKE17vU2ZE1o5XzZdTOhm1bZEctpgyS42lfERSUJQyX8
	 0n/EKCtI7jBBt1vf4UYCWOSHhhZZdIKLLbhbHnnl551AX8HJifE2V9YYAzOoPKlIWp
	 8AB9lK5JvLmzA==
Date: Wed, 21 Oct 2026 09:10:02 +1100
From: Dave Chinner <dgc@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH 0/7 v3] fs: Deferred inode reclaim
Message-ID: <atfmukIp61u_dn6Z@dread>
References: <20261009133253.20102-1-jack@suse.cz>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009133253.20102-1-jack@suse.cz>
X-Rspamd-Queue-Id: 853C0100002
X-Rspam-User: 
X-Stat-Signature: di9f8noqqz15846b5nthsmyy5nyd9mxb
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792534212-409999
X-HE-Meta: U2FsdGVkX1/tfnjKSplNHDxF4boOyhG6AdUlg0fQGE+Ska04r7w96blJ5CqhdTRqqxNdaG578s7V0Ut5ttYtiuuCa+Q80Pyb+jvGcprq1kQST4YbJQal7cmVOMGQqi+oh5QwBG6YzRZpv5k/NNmyCnD81YXg9+l3TO1YtPgY2toAIIO16Cy6FKbPjV1WdwQW4ywmXALsAsv7+OiAA9kSnZY+HcrwDnE9IBhw4KayDZSSeSxhfTK52m7tU7zX0j3A+DLTWXYaV35yDoxqwYYUwoEQGlS4WmJaz0lS6NMtNRMaAtnHLoyLpJXvrMXzD9b96LXmzSOHiT9FvRoAOkuT+azWVMJXXYNiJ4a70iXz5vTISbzKQ2lbWldBKzQeOWh2+2QTkJZNhMDtWPUZk+k9u8u18cl7pGLtu6KkUH2ae/JPa0fVNCh0zaK1gZPASwOXSWRAjWs4lnx61YL8Ul+ZprdR9mh+j7rZd9Z8o+RzHDETpqa+PkDXmG5VlAih/vYl7+ume8pkgFI88z8TpoISzz3qdR/LIzHt0I8pTu8mYHKzP7aM35i6Jn5ypYVsJpQQcCmVFdYxWlxP3CgY8e4zfzAVhEtTSWPOz6SmBt+zPVoHUa0VUeWQTTRcdV1YAKE6TX/WFrWsCxBDT5U6VJ2Is2ytKhOKpI6UAMd9uW1F6DOJZrBlLXTXnp59mfipJ1cWqKSytuQTyE8P7DLBPX5ssXlgU1ujZ0F2mFeAHXAS/+oXoEfum/anADiu2Q6UnsS6h7IVRE2NPqQ5euvu/PSBXkIzeR6Ip6lXemNjVh41twjz8Lm6xdLAhgJBIP4UFiYVzg41VurLozDPdiLdYwOhygJ2H4Ujl4h7t++W4jkWOqu2S12iTLR00r21lj9UBlulD2WpalmwuBUWubLFb2sMvQ64haUXNC4Zz2/xLk64KCKu5005hcERDqUW7OEk9kgI0b9n/i3cj7YOUHGI4W1
 A/MG41eV
 8ZARItGJIvRQc9ezfHM5ma5vOjKS0REKXK7G7jcQagkhSV5Suz/sgIrdfddG5Y6YfXgSBIvVze0hgzDY0eDv8hIeCmRkF541t7Ys69hXk621D9gAiAsrJYQREha0/RqbsQpbnjswhE/h0vbeXHw6rX6Ns2kdeHvNCrcLN5ro2DNyBnNJjeM3m5LegSQBLRJT0uR/ZqjcjsT2lw69QeAA0/jgUSdm3rGl2gkBUUFM4gbunDKtCL8kj4BM7KSkAvWFOJyjtT1srW1zQSmJeSqcr8G0t4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 12, 2026 at 10:23:38AM +0200, Jan Kara wrote:
> Hello,
> 
> here is the third revision of my patches implementing deferred inode reclaim to
> deal with MM warnings due to GFP_NOFAIL allocations from reclaim paths. This
> happens because to reclaim some inodes, filesystems have to do IO including
> complex operations using journalling and forward progress of these depends on
> successful memory allocations (which is impossible to guarantee from reclaim
> context).
> 
> Since the last revision the most notable changes include addition of automatic
> deferal of inode eviction from iput() when inode link-count is 0 and we are in
> reclaim (PF_MEMALLOC flag set). This path gets triggered e.g. by overlayfs
> whose inodes hold dentry references on upper filesystem and thus slab reclaim
> of overlayfs inodes can trigger the last dput() (and thus iput()) of already
> unlinked files. Since inode deletion is practically guaranteed to require IO
> (and thus possibly e.g. loading allocation information into memory) I've
> decided to unconditionally defer reclaim in this case instead of marking inodes
> in each filesystem.
> 
> Another bigger change in this series is that we now protect deferred inode
> reclaim from filesystem freezing. Otherwise inode eviction could block the
> reclaim worker on frozen filesystem which could stall deferred inode reclaim on
> the whole system. Deferred reclaim workers now skip reclaiming inodes on frozen
> filesystem and we block filesystem freezing while the worker is evicting
> current batch of its inodes.
> 
> The last bigger change is that mark_inode_reclaim_deferred() does not block
> when the queue of deferred inodes grows over limit anymore. Instead it queues
> task work to delay the task appropriately when returning to userspace. This
> solves possible lockups when tasks would get throttled when calling
> mark_inode_reclaim_deferred() with some locks or transaction started.

Hmmm. This re-implements the XFS inodegc infrastructure at the VFs
level, but without all the internal XFS knowledge of when background
inodegc processing is required. It looks rather complex compared to
the XFS inodegc code....

Whilst I agree that the VFS should be able to do this for
filesystems like ext4, we really don't want to be deferring inodegc
processing twice.  Hence for XFS we really want the VFS to call
evict() immediately for all inodes so that the filesystem can
correctly decide if deferred processing is necessary or not...

> The patches have survived full fstests run on ext4 when marking all loaded ext4
> inodes for deferred reclaim to stress the deferred reclaim paths. I have also
> tested (when marking all inodes for deferred reclaim) the patches by creating a
> memcg with 128m memory limit and then scanning from 10 processes 1m inodes in
> total which heavily exercises deferred inode reclaim paths. This also verified
> efficiency of throttling of marking of inodes for deferred reclaim. Basically
> we cannot guarantee any particular limit on the number of inodes queued for
> deferred reclaim as that is bound only by their number in memory and memory
> pressure. But as the number of queued inodes grows, the tasks creating them get
> slowed down so eventually some equilibrium is hit. In my VM this was at ~10k
> inodes (only slightly above the 8k limit when throttling kicks in) but this all
> very much depends on the reclaim pressure, speed of deferred reclaim etc. so I
> don't think this is some representative number.

XFS has a "almost-hard" queue limit is 256 queued inodes per CPU.
Anything larger than that sees reduced performance under sustained
inode cache pressure and latency problems when eviction processing
of individual inodes takes a long time (e.g. deferred unlink of a
set of inodes with millions of extents each).

In normal operations, however, the low queue limit means triggers
the scheduler to move the reclaiming thread to another CPU to allow
the queued cleanup work to run on the same CPU it was last touched
on. Performance testing showed that moving the reclaiming task was
much, much better than pushing the reclaiming work to other CPUs
whilst blocking on the throttle. Deep queues (like many thousands of
inodes) caused other problems with ongoing (non-reclaim) operations
then contending with resources with queued background inodegc.

i.e. for XFS it has proven better to have short queues, short
backoffs and schedule/process small batches concurrently than it is
to have deep queues, spreading the work out many kworkers and having
"end-of-queueing" throttling behaviour...

> The first patch is a pure fix for a problem I've hit when running fstests.  The
> second patch deals with lazy timestamp updates which I've decided to handle
> better directly inside the writeback infrastructure instead of deferring
> reclaim. The remaining patches implement the inode reclaim deferal. Ext4 use of
> deferred inode reclaim is there mostly as a demonstration. Other filesystems
> need to determine which inodes need deferred reclaim and mark them as such
> which generally requires good internal knowledge of the filesystem. I'm hoping
> that once the infrastructure is there, fs developers prompted by MM warnings
> will start using it :). I know for a fact that besides ext4 e.g. gfs2 wants
> to use this infrastructure.

But XFS doesn't, so it needs to be optional. :)

-Dave.
-- 
Dave Chinner
dgc@kernel.org

