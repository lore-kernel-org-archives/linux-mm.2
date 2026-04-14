Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41566ED7B91
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75C06B0088; Tue, 14 Apr 2026 05:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FFCC6B008A; Tue, 14 Apr 2026 05:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF6B6B0092; Tue, 14 Apr 2026 05:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 791D26B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:15:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 268411404AE
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:15:57 +0000 (UTC)
X-FDA: 84656604354.09.08C546C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 96850C0002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:15:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3AzqO70q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XJCXY0I7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3AzqO70q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XJCXY0I7;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776158155; a=rsa-sha256;
	cv=none;
	b=QVvtSJbZQsyMAH8/XqmqmYP1hLR37e+QTwDh1rdst04xk5CqIRhAK+Bw8i+vhx0SQouuxZ
	XItRkF9UN1TeRiVny0K4Z7iNmW45K7BbXHAbeE9anea775ptw5jQOJjVdhIlj4OLUBbUdv
	b+T4G/GF1rQ7Nz7phxYkdpzJhpn8N4I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3AzqO70q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XJCXY0I7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3AzqO70q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XJCXY0I7;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776158155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wtgz2wrDJhkuXG38j1ADf8IY18XzGB4DzMJAkz28Fo=;
	b=FRcieDB4wqdX2OB1tdrtnOKbFv9fI96rnOcOOimzn04JRZ6Phb4sIFdpvwOmYQrsVcGtSq
	9yyjqDZOpPGzKnC1jFqDaNs1Ba3STpuEekSAREaEs9j4Peb6UA66DpK326nlQKM54TAgZc
	0x9l/MbeMNe8WaG5Gm6BvmIjwavJKKU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 98C565BE6A;
	Tue, 14 Apr 2026 09:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776158152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9wtgz2wrDJhkuXG38j1ADf8IY18XzGB4DzMJAkz28Fo=;
	b=3AzqO70q24e73+3GcjxpExM+cs8Mnttr50jC6b9PHfCsWbgQHsNxjHmmymnpK+IiZ/Hh+6
	b0fuYYX3zYWUGLb+CZH8IujlysqgvwiJ2hcDCVIl9k566rtCShCsQ+jXTFyofTSzfXHh4B
	IQjIwzl6IRLQrhCrweUE3v7Bk2WQJHc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776158152;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9wtgz2wrDJhkuXG38j1ADf8IY18XzGB4DzMJAkz28Fo=;
	b=XJCXY0I7SdP6EMWKNAUdYFDP/2DbqGiGS632GDZHfypQmo2JyrzAe68mUfT7Esh5B6GlZS
	6k+KueWAxC7mIRCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776158152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9wtgz2wrDJhkuXG38j1ADf8IY18XzGB4DzMJAkz28Fo=;
	b=3AzqO70q24e73+3GcjxpExM+cs8Mnttr50jC6b9PHfCsWbgQHsNxjHmmymnpK+IiZ/Hh+6
	b0fuYYX3zYWUGLb+CZH8IujlysqgvwiJ2hcDCVIl9k566rtCShCsQ+jXTFyofTSzfXHh4B
	IQjIwzl6IRLQrhCrweUE3v7Bk2WQJHc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776158152;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9wtgz2wrDJhkuXG38j1ADf8IY18XzGB4DzMJAkz28Fo=;
	b=XJCXY0I7SdP6EMWKNAUdYFDP/2DbqGiGS632GDZHfypQmo2JyrzAe68mUfT7Esh5B6GlZS
	6k+KueWAxC7mIRCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 817E34B382;
	Tue, 14 Apr 2026 09:15:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Y5+TH8gF3mk9QgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 14 Apr 2026 09:15:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3A484A0B66; Tue, 14 Apr 2026 11:15:48 +0200 (CEST)
Date: Tue, 14 Apr 2026 11:15:48 +0200
From: Jan Kara <jack@suse.cz>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, 
	lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <z6m4h2yamlckbyzh2ey2ixa7t7s6hlzg5jcle4qyebkopkvujw@pcrzrkuycg4g>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <ad1QfUWEPSCDUDYv@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad1QfUWEPSCDUDYv@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 96850C0002
X-Stat-Signature: cgp8nu36ryopycyi7stqi6eeiw1yr31j
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776158154-704667
X-HE-Meta: U2FsdGVkX19r7FQMnLLvN95K9zNRgfz1Y6E/Mio3ZzIV2yn6xFboSQlSrHbR/xbAcjiRwrl/xvyq7Li8W01hmPZ+Rt5UFr07+gSCSCOvZiGId7DDORgP1PQTZTUJms/YlYnFD670DvbIHTL+6o0PThLVcM4+7e8SbxaQ4qCdtoEZ/dsIy4a1UAQ17y6C62nWoZhy4DFvGxgutxSdbFRcBiYDTmix3mFimJxLGeAlsAT//pU1+aQdXDbzUMBPr7QewKw7ibEafg8II/R/E5SxXHccQTkPFyXSDnGI7SXkIUHk+75gTKgbvIm5Pb32lomvAWa9XPg48EV2EEiSc5jPMm1JDWN1f1tvwDmNGjL+AtC93ahDxbDQCudQ1lcOy58rd8WPB1SUwo8SmPO/eYjm0NHrOkL9zivM3NNzecXr80jL7scIArUXUFtMwi6CiuZV6WtfgxSBV81JsbAj5ZbFkYHIrdqUllBhC4M6JNBo8lRD4idAn4VCGFtBn5d4RmeqtF17SXTgkj6DvLnpibrKC+9RXCnqpMybVkWZ/xVYecJYg5FQ751fc/FtZiAbOq7TfnepYooGr1Dca694gjk4uIiqZY2orMJYmNXgcTremIMDg6FBXj1+7FPSEl0mFugaOAdmXXzmwv9Dv/PrZpRaRQWTtMoTQe4mcV0hYsuNn0SG6L1OzkaxDo6RloniugaBtWBWSy5Vca2vAiYje6YKD0IUFOksp/8Tkw1X1P5Cd8DQXJuqK5ZvbcdkHcS/FrkBMs/IAJyVqRGkNPuJix33aRMDGex10/ddbzxOk/PbNEuMuQYJQwNB/uYS7XX/dIhAAVyWi6WTnVMwrDnvCsRhSO1YuhROeRq0nIxYqVUv0fvxZyH5cfs3vSurXfTs8FOQgZeiJpOG9JzMd0vyPXQhK1vcttRTSaaP8TXV/AXxL14LuNRTxQ2E1E5rBdMLSYkWzKikd+5AyD10jYa5Rpn
 8w7VLfgZ
 BxgvxMI6grvgufkbN6nDcppnnVaIhtd8VeM3dGKeWEDh8Bkcvp3FEtEMoDR0hB/Q+3bq/yjxKzeAIxGmM3jediB9YEJ57/1dQlaTLJBPUDyVBB+a+2q9QcKOT80M2DQhyWX425148HKtRPCH2dKropix2HVKjf0JZQ9+aHqvCxxtkDdI6Z+WSnToHuKe41NgaArrQZxjy1jD+VB6qNVTqCRfsWUP7EC9k8G6ztPanTAg9NxfnNwBi6BzdQ9i6Xe2bFz1LLZcIkeGhUCQv+jmU2O3prdAU3CeI2Zcvaq4tbF9bYaefccMQdbb8ri6jZp6Gn4D8HyO9wQDBizBYb/g/DZswTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel!

On Mon 13-04-26 14:23:13, Shakeel Butt wrote:
> On Thu, Apr 09, 2026 at 11:16:44AM +0200, Jan Kara wrote:
> > Hello!
> > 
> > This is a recurring topic Matthew has been kicking forward for the last
> > year so let me maybe offer a fs-person point of view on the problem and
> > possible solutions. The problem is very simple: When a filesystem (ext4,
> > btrfs, vfat) is about to reclaim an inode, it sometimes needs to perform a
> > complex cleanup - like trimming of preallocated blocks beyond end of file,
> > making sure journalling machinery is done with the inode, etc.. This may
> > require reading metadata into memory which requires memory allocations and
> 
> Some of these allocations may have __GFP_ACCOUNT flag as well, right? Also are
> these just slab allocations or can be page allocations as well? And does the
> caller holds shared locks while performing these allocations?

Yes, some of these allocations may be __GFP_ACCOUNT - e.g. if we end up in
fs/buffer.c: grow_dev_folio() which needs to allocate folio to load
metadata into and allocate buffer_heads underlying that folio.

Regarding shared locks - it is fs dependent. I cannot currently remember
where __GFP_ACCOUNT allocation would be done under some wide-scale lock but
I cannot also completely rule that out. Definitely there are allocations
without __GFP_ACCOUNT under fs-wide locks.

> > as inode eviction cannot fail, these are effectively GFP_NOFAIL
> > allocations (and there are other reasons why it would be very difficult to
> > make some of these required allocations in the filesystems failable).
> > 
> > GFP_NOFAIL allocation from reclaim context (be it kswapd or direct reclaim)
> > trigger warnings 
> 
> I assume these are the PF_MEMALLOC + GFP_NOFAIL warnings, right?

Yes.

> > - and for a good reason as forward progress isn't
> > guaranteed. Also it leaves a bad taste that we are performing sometimes
> > rather long running operations blocking on IO from reclaim context thus
> > stalling reclaim for substantial amount of time to free 1k worth of slab
> > cache.
> 
> Agreed, particularly in the multi-tenant and overcommitted environments where
> unrelated direct reclaimers have to spend their CPU time to cleaup/freeup
> memory from others.
> 
> BTW I think kswapd doing such hard work is fine.
> 
> > 
> > I have been mulling over possible solutions since I don't think each
> > filesystem should be inventing a complex inode lifetime management scheme
> > as XFS has invented to solve these issues. Here's what I think we could do:
> > 
> > 1) Filesystems will be required to mark inodes that have non-trivial
> > cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
> > whatever :)). Usually I expect this to happen on first inode modification
> > or so. This will require some per-fs work but it shouldn't be that
> > difficult and filesystems can be adapted one-by-one as they decide to
> > address these warnings from reclaim.
> > 
> > 2) Inodes without I_RECLAIM_HARD will be reclaimed as usual directly from
> > kswapd / direct reclaim. I'm keeping this variant of inode reclaim for
> > performance reasons. I expect this to be a significant portion of inodes
> > on average and in particular for some workloads which scan a lot of inodes
> > (find through the whole fs or similar) the efficiency of inode reclaim is
> > one of the determining factors for their performance.
> > 
> > 3) Inodes with I_RECLAIM_HARD will be moved by the shrinker to a separate
> > per-sb list s_hard_reclaim_inodes and we'll queue work (per-sb work struct)
> > to process them.
> 
> This async worker is an interesting idea. I have been brain-storming for similar
> problems and I was going towards more kswapds or async/background reclaimers and
> such reclaimers can do more intensive cleanup work. Basically aim to avoid
> direct reclaimers as much as possible.

So similarly as we eventually moved direct page writeback from kswapd
reclaim, I think it makes sense to remove difficult inode reclaim from
kswapd as well. In particular because I think such separation makes it
clearer that while you do complex inode reclaim and allocate memory from
there, there's still kswapd that can free some memory for you to make
forward progress. And you better need to be sure that there's enough "easy
to free" memory to allow for forward progress of difficult reclaim.

> > 4) The work will walk s_hard_reclaim_inodes list and call evict() for each
> > inode, doing the hard work.
> > 
> > This way, kswapd / direct reclaim doesn't wait for hard to reclaim inodes
> > and they can work on freeing memory needed for freeing of hard to reclaim
> > inodes. So warnings about GFP_NOFAIL allocations aren't only papered over,
> > they should really be addressed.
> > 
> > One possible concern is that s_hard_reclaim_inodes list could grow out of
> > control for some workloads (in particular because there could be multiple
> > CPUs generating hard to reclaim inodes while the cleanup would be
> > single-threaded).
> 
> Why single-threaded? What will be the issue to have multiple such workers
> doing independent cleanups? Also these workers will need memory
> guarantees as well (something like PF_MEMALLOC) to not cause their
> allocations stuck in reclaim.

Well, single-threaded isn't a requirement but in the beginning I plan to do
it like that for simplicity similarly as currently there's only one flush
work doing writeback (although we are just discussing moving to more for
that). Also the inode cleanup will contend on fs-wide resources such as
journal so although some scaling can bring you benefits it will be
difficult to scale beyond certain limits (again heavily fs dependent).

> > This could be addressed by tracking number of inodes in
> > that list and if it grows over some limit, we could start throttling
> > processes when setting I_RECLAIM_HARD inode flag.
> 
> I assume you are thinking of this specific limit as similar to the dirty
> memory limits we already have, right?

Yes.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

