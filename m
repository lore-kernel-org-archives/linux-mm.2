Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885FDCCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 09:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82AC36B018E; Mon, 19 Oct 2026 05:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801F06B0190; Mon, 19 Oct 2026 05:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 717BD6B0191; Mon, 19 Oct 2026 05:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 467116B018E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:44:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D69861C3ED2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:44:02 +0000 (UTC)
X-FDA: 85338889524.23.8A6D673
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7030440008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:44:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WH7aG4VM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aaVhJAWM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u6VHnfyM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qXNeOZFc;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792403040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09Lq3An05DWPwWxeP0P+1z2FcKSxt+uwU4M2CkK9Eew=;
	b=cO4nlDGDPlb7uQ7hdggw7MJCo+2+ekprsNjBh7jJ7w9MpGrR+kLNX7qAj7LZVFEM0sJSxK
	tgCYkfWfhf6DzRJJJ+zryQBWVz3jELt+8kFcODXBhPdqD8Gc5e7Q5VVudjHrNq8AuOuAr3
	DfV/NPRWH2v39+Pkby7csTEk2tQQJIo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792403040;
	b=0jddI9qd70VQzVgADGISTUEMQwuJqyIPK/Lodeto/lBIb+LOvdE7J9l715Z+TKCyyXVPiV
	0O1aI1ggiwreQeRg8rSRxsUxOlaBoGnzDrPWz5HL/4Tb9i5ZZLRaR9FdcJr5Qbnv9UZ+Z6
	8YNXAEap58zAs0xp0rdSrV2QFc+vhhU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WH7aG4VM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aaVhJAWM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u6VHnfyM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qXNeOZFc;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DCDCC21C08;
	Mon, 19 Oct 2026 09:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792403039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=09Lq3An05DWPwWxeP0P+1z2FcKSxt+uwU4M2CkK9Eew=;
	b=WH7aG4VMWqpdzzXRD5GJ5dlxyI/o4EpP4Q94+TvJH9IHtf6zS54iHiucDyKotDjUP8CYOf
	8PwpQlkbGHerat8yADcrafZBWQgMTutlnyodTHJlVlw8Tdt4oedJLgKKMPOLVriTotfhgn
	tIR1RSaUeSX1F61Fqg0c3JRghG1DeaA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792403039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=09Lq3An05DWPwWxeP0P+1z2FcKSxt+uwU4M2CkK9Eew=;
	b=aaVhJAWMHnFF7+W7PztBek5nPyblgTcK+EAJOCjarkm2YETBlBCmcztlnE3/526Yj4DhND
	4wjH76CgpjeF4nDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792403038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=09Lq3An05DWPwWxeP0P+1z2FcKSxt+uwU4M2CkK9Eew=;
	b=u6VHnfyMtr8FXFmcl6a7oawp/5Dnehifq04nZUU8VkEy8cCVV6mdykSTlMcrhTNKKNJCnZ
	T9A7GXg/SiZqbSBVlHRZnk0smuNlY191IrsvgajtdWjgvuLkmFAcobgaDg9dwBz/29VSIq
	Xygu2EZyWN8pnAcTuoE7myI2T9+qMXg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792403038;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=09Lq3An05DWPwWxeP0P+1z2FcKSxt+uwU4M2CkK9Eew=;
	b=qXNeOZFcz5kSMb+dkWrHfvw1RIyoj++ARYsiqXv9EO/F63yoXtRYtPeM/FZQBlE0kpaYQF
	KF0ROHT+RnZR5FBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AFD48134B3;
	Mon, 19 Oct 2026 09:43:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q8gqIV7m1WrZMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 19 Oct 2026 09:43:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3C4D9A1413; Mon, 19 Oct 2026 11:43:58 +0200 (CEST)
Date: Mon, 19 Oct 2026 11:43:58 +0200
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Mikhail Rudenko <xyzzy@yandex-team.ru>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/7 v3] fs: Deferred inode reclaim
Message-ID: <tsjar7j52anyxrtfdqfhmp6enu4e32hsvtitk5gy3bpxvagsjx@5exi7yidgf66>
References: <20261009133253.20102-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009133253.20102-1-jack@suse.cz>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 7030440008
X-Rspamd-Server: rspam08
X-Stat-Signature: ayoxd83mr1f34gr85z4fephybfd7r6sj
X-HE-Tag: 1792403040-591480
X-HE-Meta: U2FsdGVkX1/0tqCvTkWdqgRMIfvZldIIoOpJyyqDhiLhmrcGCwADcqF+lrPelPdILpftkEjEySAzT43TqSeePoHS+O5deKNgJEIkN+LpG4gaYkNgYam1ACCgHUYIZH/gLrWx/twztwAjWjilEFkK7CzqUtyNuiRKP1bDt/Uec1bffDzuzPambySpjd4//mKB/Vau6g2vWeWUzgmTgVRSLQnqc3i+LXJoQe6ZBGY8yTG1GFXuIQ2PotG29q+z7cj6FdX9mKwAgIhJR5Zj+u63myQuKB4LcHp2HQ/W3suO0gr9Svj+F1JmM/KMYKgW8S0/ISrAHOA9lhTst6kI7exR9EPU2S4MoaBdW9rXQTfjPoet5iAj87EGDKdcPmjAU2Gx776Yw1ZHiHNHV/TvjGwvt0FOB5zhRhMB6lMHdOlcfAwhZ7YLSxx24FgqpDyq3MQ6SCGdH+4Pgr44Kai2tPLT9gL71KzbKMqSWRKU2O5Tkb7BjKXqSzrtsUZldfLRrEyagY62xSybF1IEZFIK/lngU9AdmTvqbY9vdVC+/dP3BaYkp1RfNwwMB8UJao1CvWWTyHv52JQsXsavMQnmu1SEESrPmpL3BMcK7Jby92ASpgtzkptWmA00rCgt9y3UcLneOVt3CJwV3hkKyssa7KIdIBix2FgeTF46SSajwvRvec4BmbBejPKwjQ1kKrhh4v539HjWH/m+U83+oBN6g5opJqwh5rO8/a3TS7y/REFyuxJaEcWestwJow/2qibz7FM/Q7YIB2HlbKbwGsUO9AzPpQG/nyjxHd5Bfegt11ACRAJiMj4WI88yofJCCz1zCL4szfN7BJAKiqB3awuSw43NujdTMx+jloyrHx3kw3+ldwUr666N/l/b1Ck4XOTBmb/QrfBeg+9TUc4unloERZN5vKX6Lyl/nMgosjkc6tm54WmiiKmov6nA6qPaGKCoe3RxBRQaSjnjm/xjXwGOn20
 V7QjY7FD
 mMIVjIq9QkccHuUTwh+R0UbB0CJRJY3lYESf9iFa4Saqa4uccYLgvk9sLSsjBd1Ncq1+CNM4n6evnaGoIniwmTTWGebQ01k+txdEU6FhZWPA3UgyZcIy3JWmnzORUSqyN+OpAowz/XBBMOv93nCrQK7oPkOvFFjpBBTYBWNcTPuayRc5UslW5ngbhSNra7zr02b5QeWOLFoZKsw6c8sWY5XTHe+mt9gp5zFDr3R260i6D3bZHrOXTflKw0wqYaiTARXbZjky2vpFEtElNTb0p4+cBCRejKX4cVitkbJfqXDEfdwHrcfuKtido0xwZWCoq9eFzJjOWWz9uotBwCItYpgZAStG7UXeKbEYg4HggrhSfc9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

FWIW Sashiko still found some stupid mistakes I've made so I'll have to respin
this. However none of the issues Sashiko found are fundamental (just some
memory leaks, wrong memory ordering, ...) so the overall design should
stay so if someone has any comment to that, they will be still valid.

								Honza

On Mon 12-10-26 10:23:38, Jan Kara wrote:
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
> 
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
> 
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
> 
> 								Honza
> 
> Changes since v2:
> * Some cleanups and simplifications from Andreas Grunbacher
> * Fixed couple of bugs pointed out by Sashiko
> * Added support for auto-deferring eviction from iput() when inode has 0 link
>   count and we are in reclaim path
> * Added protection of deferred reclaim from filesystem freezing
> * Throttling now doesn't happen directly in mark_inode_reclaim_deferred() but
>   on exit to userspace
> 
> Changes since v1:
> * Multiple workers to reclaim deferred inodes, related to that I've
>   moved lists of deferred inodes from per-sb to global ones
> * Added missed lazytime sync fix
> 
> Previous versions:
> Link: http://lore.kernel.org/r/20260429174850.18223-1-jack@suse.cz # v1
> Link: http://lore.kernel.org/r/20260911081309.14137-1-jack@suse.cz # v2
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

