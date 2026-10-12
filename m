Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC681CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659746B00A0; Mon, 12 Oct 2026 04:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E65D6B009F; Mon, 12 Oct 2026 04:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39CDE6B009F; Mon, 12 Oct 2026 04:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D59B76B009F
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:24:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C253140928
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:18 +0000 (UTC)
X-FDA: 85313286996.08.89A0A77
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3D01980007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3bpsPYVH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s4azxD88;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3bpsPYVH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s4azxD88;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791793456;
	b=L6x3GDgnLmHtGf7YZWSoj0eUUfEoE4fUDuP6sDAIBcTTUX1JtccUX1aFLt8hbsj4hhG6CJ
	yxdJjqmDhs+u9b2yFn62U4deshU/G49e4qzr2xBXe06fym8gRISFO8+cq0AAUsKkah5Wsu
	F7Dv1DEIKCx1gX1YynIPELFanA6viIw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3bpsPYVH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s4azxD88;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3bpsPYVH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s4azxD88;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791793456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QY1OoKKUzmo9MrxvOaP0qbVh/NTWNu6sX9Pwj1+pn9M=;
	b=LhU3yNu+wF2nPYC1XjRcUBDUJ+UM2gjtD7Q+8djX+XyHPql6e3GMuGB+RNXj1RtTsjtL8S
	GO1P7CqM6MNvoswyiI3s4Cgh6mDFNy7EMrkaNTOGO0MfG9L1ChdRxecedlEqDp/hIxJ+H6
	X1C5dg8a1QnuNZJZwl7E4OlJORMngpY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 347041F78F;
	Mon, 12 Oct 2026 08:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791793455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QY1OoKKUzmo9MrxvOaP0qbVh/NTWNu6sX9Pwj1+pn9M=;
	b=3bpsPYVHYND8iw4gSY0WV3TxMtqRt0YOjE24ETsOpLe87j+GxvAhDNYLOrmwFx3OTWgJHA
	z40X+6h4App6mQ1FoY8wfk1Vqyin99fsaKK1ncmjRMU/8gl+4YkQqD9vaPEBuohSkehjFn
	S11BlAg80JHuJ/JwmtNesDJYAO7Nrlo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791793455;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QY1OoKKUzmo9MrxvOaP0qbVh/NTWNu6sX9Pwj1+pn9M=;
	b=s4azxD88H6pDNR8EDMWNvbtg/zxcvlRT7zHNhsvtxynGj1MPFXvBLu8ZSADN1NcZ+q+Ftp
	2HEqV6ruOq0wBnCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791793455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QY1OoKKUzmo9MrxvOaP0qbVh/NTWNu6sX9Pwj1+pn9M=;
	b=3bpsPYVHYND8iw4gSY0WV3TxMtqRt0YOjE24ETsOpLe87j+GxvAhDNYLOrmwFx3OTWgJHA
	z40X+6h4App6mQ1FoY8wfk1Vqyin99fsaKK1ncmjRMU/8gl+4YkQqD9vaPEBuohSkehjFn
	S11BlAg80JHuJ/JwmtNesDJYAO7Nrlo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791793455;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QY1OoKKUzmo9MrxvOaP0qbVh/NTWNu6sX9Pwj1+pn9M=;
	b=s4azxD88H6pDNR8EDMWNvbtg/zxcvlRT7zHNhsvtxynGj1MPFXvBLu8ZSADN1NcZ+q+Ftp
	2HEqV6ruOq0wBnCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1629413408;
	Mon, 12 Oct 2026 08:24:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f1GIOi6ZzGomHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 08:24:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8DB8DA1403; Mon, 12 Oct 2026 10:24:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/7 v3] fs: Deferred inode reclaim
Date: Mon, 12 Oct 2026 10:23:38 +0200
Message-ID: <20261009133253.20102-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4377; i=jack@suse.cz; h=from:subject:message-id; bh=V9oUBCPzZOaV8+MDpqgAOKQT4zKDxCe1JR3JQ7aAPKE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqzJkJNG8Z/VSIn1YRqVysKcA+cKJjTnmEhvW+r +5nwH+mv+CJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCasyZCQAKCRCcnaoHP2RA 2WzBB/9ma+bTApG9qKyDdh4FFzGal4LDCzodpeWUzNkdFicwTuyVPaxVeOGYW7e+8xrsniiiWS1 OZKCn2DbClxcwg01zyurbqqdoNubjTqGit43jpzBZRdasNgCLEbB1d5U65Fn3lBt0ZF70Cj1VxL Sa3P1XjM61CmOuvB7KXY2he/65uv6ADeYtWnMf26N/JlJF1AxXlv5WgnnMl8eea4LsI3hsYir4d DYNjprn3e96iHYsIcIhfMIGbC74QU68TYHJSFIsVS/Ort4yXxwA2lZpKqIF+/2jBz1kRsYY5RKL Ou5Y7WWhrbNIxSZBKTDQPy0NfBW7NEqO1FKJFDx7n0AojcRS
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h6zrxa7mgcr3ox3otrxi4path1nopafj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3D01980007
X-HE-Tag: 1791793456-250302
X-HE-Meta: U2FsdGVkX1/wA5qig/1PKoE42I5Mq6dBYfc1kscGjfMOH5jg5Yb45HxESeNjaYUsL4O6vDPJVZaZ6vF2XYp/MYPrQEdycAnpR8C8IJ33jQIhfyDJr67buIfVIQhtmRFycLQz14cgPJ6tjcR9XJjqAyXwejd3tCPQg7entfrIvgG2Cnl3iOo/WCzhXud/qnrlVZNpxo6jyTQ9WTpMxT3vSvu2tRc2BBgc9ybYd6M0MPtP4u1RxWki4agLou5etbibQ/GpArowkuvaDJaNO6uT1zUBR8u1i4+62CY2OK/QzgyO4gg+lA/K04RtMmZt/rK8GlziCv4cqn2eX9xCLzuxxK63n/njWUUpASFFAdUmESgqBKOCo64NdHySbFno/TwQYBuw+60d6odRpFnnp6Hz3Nt5t2DKNlmmcaHzkyn/2K/uJcPpEzq7jmqB6c7BiFC7IR87ik3r7HCWu8fr1FjahJH2ruQ8ADGHOSefqd0xNeCCrap758fumbKpaSxQtY6SPtJgbICWzydI2+BY24kkISpLz5zL3qorVhrHF0klvR2wS7BXSgP2TLnpsKism332LEWQinEliL7MpCLm9rJvuPn99JK1BfQbiruS1GtcuzDhShBmFfYBks2W8tw7HF6DQNIf7XcggC8ySVfWDpfTs6z5ABnOnbY0q9bshzyEi6uJ9PcTSDqAVYkCKhifGuLOejl/8S2BHAcYiDiuaeF9EnxOeVgEeuoeqK8u8m+92FH/MRXn9YRv3AozLI33kDkgdk2ornTfIBJir6OJ+CVIifZ0g7sjbOw4rHe5M1TbSuVaAd56OnkW9OFq0iNipAiypMyj7/93L6qJJ3ICYTLiqmmyv8EGpqTWPECzUwP6LkOt71yTTplaFspwJYDMqy9QJLBR5xt2LwqX4kN4WK1DtxbkjzhIcdKP+lVWE2ipsYbe/zOm83tuaj35LSb/Gs1+hJPqFacokXF5rPaSgNk
 Q4m/TnI4
 bW3buTSu6w77AeDK1eQoPkGgnRbiqnuh1IXrS6Ri6ybNJi2FKY5vWZ0Dv5yqVMlA3xSLhrZyQ4AKtvjg+6GduiGDfvhW19T7h2yGLQsCBbXSJJtdXY2IyA5uhKgH3TlTgsHKmbZE0eHy7dU8N7pVG+7R4tXh1GxjmOeFv5Vs2WRs6MgVvX+6mcZkXsiI0+Bw2NqRAtNAgDhV3dUc8mMVNmnSHnCBjUxH1z9+yhxGKZC1hNh03iauBjNgWo21TNON5h1VM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

here is the third revision of my patches implementing deferred inode reclaim to
deal with MM warnings due to GFP_NOFAIL allocations from reclaim paths. This
happens because to reclaim some inodes, filesystems have to do IO including
complex operations using journalling and forward progress of these depends on
successful memory allocations (which is impossible to guarantee from reclaim
context).

Since the last revision the most notable changes include addition of automatic
deferal of inode eviction from iput() when inode link-count is 0 and we are in
reclaim (PF_MEMALLOC flag set). This path gets triggered e.g. by overlayfs
whose inodes hold dentry references on upper filesystem and thus slab reclaim
of overlayfs inodes can trigger the last dput() (and thus iput()) of already
unlinked files. Since inode deletion is practically guaranteed to require IO
(and thus possibly e.g. loading allocation information into memory) I've
decided to unconditionally defer reclaim in this case instead of marking inodes
in each filesystem.

Another bigger change in this series is that we now protect deferred inode
reclaim from filesystem freezing. Otherwise inode eviction could block the
reclaim worker on frozen filesystem which could stall deferred inode reclaim on
the whole system. Deferred reclaim workers now skip reclaiming inodes on frozen
filesystem and we block filesystem freezing while the worker is evicting
current batch of its inodes.

The last bigger change is that mark_inode_reclaim_deferred() does not block
when the queue of deferred inodes grows over limit anymore. Instead it queues
task work to delay the task appropriately when returning to userspace. This
solves possible lockups when tasks would get throttled when calling
mark_inode_reclaim_deferred() with some locks or transaction started.

The patches have survived full fstests run on ext4 when marking all loaded ext4
inodes for deferred reclaim to stress the deferred reclaim paths. I have also
tested (when marking all inodes for deferred reclaim) the patches by creating a
memcg with 128m memory limit and then scanning from 10 processes 1m inodes in
total which heavily exercises deferred inode reclaim paths. This also verified
efficiency of throttling of marking of inodes for deferred reclaim. Basically
we cannot guarantee any particular limit on the number of inodes queued for
deferred reclaim as that is bound only by their number in memory and memory
pressure. But as the number of queued inodes grows, the tasks creating them get
slowed down so eventually some equilibrium is hit. In my VM this was at ~10k
inodes (only slightly above the 8k limit when throttling kicks in) but this all
very much depends on the reclaim pressure, speed of deferred reclaim etc. so I
don't think this is some representative number.

The first patch is a pure fix for a problem I've hit when running fstests.  The
second patch deals with lazy timestamp updates which I've decided to handle
better directly inside the writeback infrastructure instead of deferring
reclaim. The remaining patches implement the inode reclaim deferal. Ext4 use of
deferred inode reclaim is there mostly as a demonstration. Other filesystems
need to determine which inodes need deferred reclaim and mark them as such
which generally requires good internal knowledge of the filesystem. I'm hoping
that once the infrastructure is there, fs developers prompted by MM warnings
will start using it :). I know for a fact that besides ext4 e.g. gfs2 wants
to use this infrastructure.

								Honza

Changes since v2:
* Some cleanups and simplifications from Andreas Grunbacher
* Fixed couple of bugs pointed out by Sashiko
* Added support for auto-deferring eviction from iput() when inode has 0 link
  count and we are in reclaim path
* Added protection of deferred reclaim from filesystem freezing
* Throttling now doesn't happen directly in mark_inode_reclaim_deferred() but
  on exit to userspace

Changes since v1:
* Multiple workers to reclaim deferred inodes, related to that I've
  moved lists of deferred inodes from per-sb to global ones
* Added missed lazytime sync fix

Previous versions:
Link: http://lore.kernel.org/r/20260429174850.18223-1-jack@suse.cz # v1
Link: http://lore.kernel.org/r/20260911081309.14137-1-jack@suse.cz # v2

