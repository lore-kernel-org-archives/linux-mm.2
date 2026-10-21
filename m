Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CECF7606AD15
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 16:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=sazbDk7J;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Ymt8Kd2v;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=sazbDk7J;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Ymt8Kd2v
Received: by kanga.kvack.org (Postfix)
	id 438206B0744; Wed, 21 Oct 2026 12:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410446B0746; Wed, 21 Oct 2026 12:20:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF676B0747; Wed, 21 Oct 2026 12:20:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E76856B0744
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:20:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56AE9C05E4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:20:26 +0000 (UTC)
X-FDA: 85347146052.11.7519541
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1144B180008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:20:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sazbDk7J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ymt8Kd2v;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sazbDk7J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ymt8Kd2v;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792599624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tav5y5jFkau2LmUYqTnA1wpMJIvN6h4hM3tj4E8VzrE=;
	b=DhvgPISYRhw3f3WMEN8V4tekfX4gnHx50uOHvzu9cCvLxfJmk1VhX6VCDOVhZJ5gzixaIR
	6wZNA9j5BKGy7aIMbalRS/4ZYrc6qzlw8uwHapC3meX6+h1lRlHs07D1gG/f6ChZheCUmq
	FBNPRK93WTiPpC1OyG0JaSuCHG4p4ps=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sazbDk7J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ymt8Kd2v;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sazbDk7J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ymt8Kd2v;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792599624;
	b=VfVT5PpXZhderQiXniqYv7cdVhIq7fehCpNJ2/vNsBeX4iQOzSzF2W9z01tccuhn0Mu79O
	/GV+re2M9W3/pQwaPtuSDv2ZQC1cTkjg2Xvjy3hJQxQIRB0jhP0t8JEjTimAna269LSUZy
	oijqj+JnAnLRF7pF5EXKcaUf0nSdMpw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7232C21DD1;
	Wed, 21 Oct 2026 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792599622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tav5y5jFkau2LmUYqTnA1wpMJIvN6h4hM3tj4E8VzrE=;
	b=sazbDk7Jp42D9Z5NdeyLUE1OcGu1nRmZpajaw7CVCmsDZprfrotgkGsrQwQYe5/Bbxvcre
	typgZVJwUShb1f0HcHtI6nycvsZTVVD5gDiTJAzIPvlyqRHKNvGgId6JCLI69hASVpJtBp
	pwPTXZUruQuRogJc6W2aVTO+QOCGY6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792599622;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tav5y5jFkau2LmUYqTnA1wpMJIvN6h4hM3tj4E8VzrE=;
	b=Ymt8Kd2vfBHv+m/U7yEAQSPnS7zjXjOXil3bIAOaaAlo5Yt102QKVhbjyEMgJXB1Sg3xwY
	B9MrwlRzWtDaHNCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792599622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tav5y5jFkau2LmUYqTnA1wpMJIvN6h4hM3tj4E8VzrE=;
	b=sazbDk7Jp42D9Z5NdeyLUE1OcGu1nRmZpajaw7CVCmsDZprfrotgkGsrQwQYe5/Bbxvcre
	typgZVJwUShb1f0HcHtI6nycvsZTVVD5gDiTJAzIPvlyqRHKNvGgId6JCLI69hASVpJtBp
	pwPTXZUruQuRogJc6W2aVTO+QOCGY6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792599622;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tav5y5jFkau2LmUYqTnA1wpMJIvN6h4hM3tj4E8VzrE=;
	b=Ymt8Kd2vfBHv+m/U7yEAQSPnS7zjXjOXil3bIAOaaAlo5Yt102QKVhbjyEMgJXB1Sg3xwY
	B9MrwlRzWtDaHNCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45D5A134FD;
	Wed, 21 Oct 2026 16:20:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TPcCCEbm2Gp9SAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 21 Oct 2026 16:20:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C82A4A1418; Wed, 21 Oct 2026 18:20:21 +0200 (CEST)
Date: Wed, 21 Oct 2026 18:20:21 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <dgc@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Mikhail Rudenko <xyzzy@yandex-team.ru>, 
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH 0/7 v3] fs: Deferred inode reclaim
Message-ID: <pm2fqzpmq7pmv7csi7k7vmbugceblvjlzcaoq3a6itakkri3wz@oagg7akwqrjf>
References: <20261009133253.20102-1-jack@suse.cz>
 <atfmukIp61u_dn6Z@dread>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atfmukIp61u_dn6Z@dread>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Rspamd-Queue-Id: 1144B180008
X-Stat-Signature: 9bxs6yuy4ic8z3hfkx8ah9sx78y96cfj
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792599623-221824
X-HE-Meta: U2FsdGVkX18M/RLUEHXUmXDh7yqDiql9JrRyJcMOtPYU0vHSecCM/+3t8ehQ/Fji7QLHEiv4GozcYP5gS5YhhSJnQa+m2jdtOJUwWE42ME63jG1ie4LV2KtGPi3hRpPQ+mYi2Sw8etBghNVJPsHTimQ8WR/pdzvz3veB8gZt86DW41q2z6lzlHzF+Se3i3g/lpywSSxMWYDx3gWVbQCmT9zkZKTUJMTeGf7R25WAzYRCSesbchK8hos/7i7iya+Wg0jGO4VndzxdQbolvpl6KdaFN2M2V2O7odzgbL744H3QJK8C5kuVLb6+L6ZTrqKBrmebb9ThJ0BqE1TpaDRs+Yea1FgDdX9lySQz2C8r9TFc6MVBTvMQ84NS620WHNFUXzVzoVG1q+eUF72bcQz/BSdFZD1YtnZLmEYG2QKbrNrd/BJW8jX3tnsk5YR1yMm6NWDpjS49qPOSMPmXIcmj2hXMf6UddcFVt3Yo7lig85bwDpXwYb96e7ZZLzI8aPnDeR3M/stmNXR01/VKqhcq26H3/359N4JWWtbkO/YWbBb0CQOIJIKUAC1DoZJ+7pY1mhboL0TZbUYucDlQ01r3g5ur3hJ6bplmmDPJXjVWaEt1/ap9oFs1zEmTavllHlLAKHYdtChMZFI2WYQbXo6W1NYUV4+J7kNWP1RMveAePrhrEupLxhbUK5YqNsTQnKiXBHOnLIY9JQ4N9p9vVQMCNZtMKfAquaVkwmxBRgO1yc/sX7/USXWvAImaquo1JhqSEjQIaeJw+kKo0JXeGI4YhFQo2C9c9WWSac4zdfGemzj5oliisjMrTiuqNpDsq+ZFbAO1mKWkiQaZjpU+/TlGI1sRBGFb1jfbCzxWAl+UcaLODZ5GwXYpNxu+YcVysdxgu8DVoD7oxcent5dyHYk5wSIZ11bahJAtLUpkDmYSbs3WZNM/Gd+Qki3Un8z9Ohn1QDjCwMgO81MoJMAxobl
 AFASqfOJ
 ZhGiCLTmbjr8akG6Lq+hz3VDe9+GMQ++CFt8ZB1IMBIzGcy1XIoa1wvg1RsbyACv5tWZbFbxj6ODQtuTsmae0Oj1aO58akG6+QsabhaRXh6YylVaUt5QXAuN/dEYBgDa0oriLEEQwBbObPVLsC/d+ZeuPLHeBJ58CjyJghS7ZH6S+NmjtxULELEJXBAvvMSXEQq59mqcyEPUmjUtBbyGjHpl8PAHYFWaR8fh1xEhNZYUTPgRY90A8eZ7rExKD6u/tALqVTjPJf8uanfTPnV7325/Bb7fh/pNOqfsIZAFrTppOnO6LKK2A8C2ZRPWQRU0UOBZe4J7TQZVXFmDGtc8SWnVDbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 21-10-26 09:10:02, Dave Chinner wrote:
> On Mon, Oct 12, 2026 at 10:23:38AM +0200, Jan Kara wrote:
> > here is the third revision of my patches implementing deferred inode reclaim to
> > deal with MM warnings due to GFP_NOFAIL allocations from reclaim paths. This
> > happens because to reclaim some inodes, filesystems have to do IO including
> > complex operations using journalling and forward progress of these depends on
> > successful memory allocations (which is impossible to guarantee from reclaim
> > context).
> > 
> > Since the last revision the most notable changes include addition of automatic
> > deferal of inode eviction from iput() when inode link-count is 0 and we are in
> > reclaim (PF_MEMALLOC flag set). This path gets triggered e.g. by overlayfs
> > whose inodes hold dentry references on upper filesystem and thus slab reclaim
> > of overlayfs inodes can trigger the last dput() (and thus iput()) of already
> > unlinked files. Since inode deletion is practically guaranteed to require IO
> > (and thus possibly e.g. loading allocation information into memory) I've
> > decided to unconditionally defer reclaim in this case instead of marking inodes
> > in each filesystem.
> > 
> > Another bigger change in this series is that we now protect deferred inode
> > reclaim from filesystem freezing. Otherwise inode eviction could block the
> > reclaim worker on frozen filesystem which could stall deferred inode reclaim on
> > the whole system. Deferred reclaim workers now skip reclaiming inodes on frozen
> > filesystem and we block filesystem freezing while the worker is evicting
> > current batch of its inodes.
> > 
> > The last bigger change is that mark_inode_reclaim_deferred() does not block
> > when the queue of deferred inodes grows over limit anymore. Instead it queues
> > task work to delay the task appropriately when returning to userspace. This
> > solves possible lockups when tasks would get throttled when calling
> > mark_inode_reclaim_deferred() with some locks or transaction started.
> 
> Hmmm. This re-implements the XFS inodegc infrastructure at the VFs
> level, but without all the internal XFS knowledge of when background
> inodegc processing is required. It looks rather complex compared to
> the XFS inodegc code....

Yes, I took some inspiration from it. One big difference though is that
deferred inode reclaim will be applied only to inode evictions done from
SLAB reclaim and only for inodes explicitely marked for deferred reclaim by
the filesystem. Just there's this exception that currently VFS would
auto-offload (i.e. without explicit marking by fs) in the case SLAB reclaim
happens to drop the last inode reference of unlinked inode. So in that case
VFS could defer reclaim even for XFS inode but that is mostly performance
irrelevant cornercase (in vast majority of cases unlink or file close does
the last iput() of unlinked inodes and in that case we never offload in
VFS). So I'm not sure we care about avoiding the extra offload for XFS for
that case.

> Whilst I agree that the VFS should be able to do this for
> filesystems like ext4, we really don't want to be deferring inodegc
> processing twice.  Hence for XFS we really want the VFS to call
> evict() immediately for all inodes so that the filesystem can
> correctly decide if deferred processing is necessary or not...

Yep, that should mostly happen. See above.

> > The patches have survived full fstests run on ext4 when marking all loaded ext4
> > inodes for deferred reclaim to stress the deferred reclaim paths. I have also
> > tested (when marking all inodes for deferred reclaim) the patches by creating a
> > memcg with 128m memory limit and then scanning from 10 processes 1m inodes in
> > total which heavily exercises deferred inode reclaim paths. This also verified
> > efficiency of throttling of marking of inodes for deferred reclaim. Basically
> > we cannot guarantee any particular limit on the number of inodes queued for
> > deferred reclaim as that is bound only by their number in memory and memory
> > pressure. But as the number of queued inodes grows, the tasks creating them get
> > slowed down so eventually some equilibrium is hit. In my VM this was at ~10k
> > inodes (only slightly above the 8k limit when throttling kicks in) but this all
> > very much depends on the reclaim pressure, speed of deferred reclaim etc. so I
> > don't think this is some representative number.
> 
> XFS has a "almost-hard" queue limit is 256 queued inodes per CPU.
> Anything larger than that sees reduced performance under sustained
> inode cache pressure and latency problems when eviction processing
> of individual inodes takes a long time (e.g. deferred unlink of a
> set of inodes with millions of extents each).
> 
> In normal operations, however, the low queue limit means triggers
> the scheduler to move the reclaiming thread to another CPU to allow
> the queued cleanup work to run on the same CPU it was last touched
> on. Performance testing showed that moving the reclaiming task was
> much, much better than pushing the reclaiming work to other CPUs
> whilst blocking on the throttle. Deep queues (like many thousands of
> inodes) caused other problems with ongoing (non-reclaim) operations
> then contending with resources with queued background inodegc.
> 
> i.e. for XFS it has proven better to have short queues, short
> backoffs and schedule/process small batches concurrently than it is
> to have deep queues, spreading the work out many kworkers and having
> "end-of-queueing" throttling behaviour...

Yes, I was considering XFS inode reclaim design as well. The big difference
to XFS case which offloads everything is that we expect to only have to
defer inode reclaim if something expensive (like allocating blocks)
happened to the inode. At least all usecases I have in mind are like that.
Also except of rare cornercase races the reclaim of unlinked inodes will
not be handled by deferred reclaim workers but directly inline in iput().
That is why I didn't bother with per-cpu thing as I believe the performance
of the offloading mechanism itself doesn't matter as much at that point.
But I could be wrong...

> > The first patch is a pure fix for a problem I've hit when running fstests.  The
> > second patch deals with lazy timestamp updates which I've decided to handle
> > better directly inside the writeback infrastructure instead of deferring
> > reclaim. The remaining patches implement the inode reclaim deferal. Ext4 use of
> > deferred inode reclaim is there mostly as a demonstration. Other filesystems
> > need to determine which inodes need deferred reclaim and mark them as such
> > which generally requires good internal knowledge of the filesystem. I'm hoping
> > that once the infrastructure is there, fs developers prompted by MM warnings
> > will start using it :). I know for a fact that besides ext4 e.g. gfs2 wants
> > to use this infrastructure.
> 
> But XFS doesn't, so it needs to be optional. :)

If you still want the rare cases where offload could happen for XFS optional
after above explanations, I can do a filesystem_type flag for that.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

