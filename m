Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74D8BCD8CBD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36986B0088; Tue,  9 Jun 2026 04:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3B06B0092; Tue,  9 Jun 2026 04:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F776B0088; Tue,  9 Jun 2026 04:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F0B86B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:46:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3005E404D6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:46:47 +0000 (UTC)
X-FDA: 84859743654.23.7C30FB8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id E93CEC0007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:46:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iifc0pdL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EvEGavgP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y9Kd2cpH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8s7K2iF7;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780994805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SkwgUno5OVjg29hLYJfsk0E2z8CzY6794Poai6l+Syg=;
	b=IARQFrp5DJikwoHh93cr4YYWTUuwHZd4WQxK/7q8HuYtSMOO7yz+3NAuyI6ulIMfyAlpIT
	sXeGksjIyUaGU6Ae8lVu31POsLmDth9kBYA9bSAjykdJokla92RTmXUJgTkvdPaRLm+27B
	6ajuBXb8j3B/sn8T/UAHHDDw8uYqLIg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780994805;
	b=xQqHIYQiBA3yI9Vx8cPbg6a7jh4x6n+ZeNfB+PrXPUVjJC3uyWv6nrxRh7PjrsRT+uG9Fr
	INAca+jpJD0vFxnTp30kvMzC3W8J4omru947MKrj7D1JRS9/VUt8udpm0IdzS+uILZ4Sx6
	57QGtowL35QFliq8vYDvEoI2Uokovgk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iifc0pdL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EvEGavgP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y9Kd2cpH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8s7K2iF7;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 409446A7D5;
	Tue,  9 Jun 2026 08:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780994803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SkwgUno5OVjg29hLYJfsk0E2z8CzY6794Poai6l+Syg=;
	b=iifc0pdLEJFFz7v/nTbIvZHa0aSmahb6nKmAc4JRUnbwNn9QaHqbdA0XFQj2oRrUVJ6Ywq
	fXfttPOuSZO3+B6b2S/x/80dZYPGFCgWGcu4ok9kxKlxXZ+qKVJrXg3erC/3vxjJuz0QjR
	smJS8VKQzCN/tGzKIds6ThXcFGQHOso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780994803;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SkwgUno5OVjg29hLYJfsk0E2z8CzY6794Poai6l+Syg=;
	b=EvEGavgPfqnRsj+bigCqM6Nre3O4jhxk2gVNy46rYQtMxClruQlhTfICwsRCfChXJxTSwn
	kRA5R5H+A20BpcBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780994799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SkwgUno5OVjg29hLYJfsk0E2z8CzY6794Poai6l+Syg=;
	b=y9Kd2cpHerZ3l4p8U1BCmKTQtSyWENzbZAsreFaiCeAdtHXYhk/30v/l/qZDBQZUfyxbe9
	RV6WLmQoKYEtlBwsBd7ZZvnXt1t3Kc6KiR5dMaoZIqNtE/u1kZKz75l9Z4nfleNzC7Pb2l
	5Vzho73fdJ+7mSEiFfbl7DdNvWgUwIA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780994799;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SkwgUno5OVjg29hLYJfsk0E2z8CzY6794Poai6l+Syg=;
	b=8s7K2iF76Cm36PZHMJRIknZM58rOeOSYodxzyzZvuCd2izMaAMudwtzN4KAWHqUhNELa6M
	TjDt8cHOL3HYDgDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34C98779A7;
	Tue,  9 Jun 2026 08:46:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r93dDO/SJ2qNdQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Jun 2026 08:46:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BB4F5A0A90; Tue, 09 Jun 2026 10:46:38 +0200 (CEST)
Date: Tue, 9 Jun 2026 10:46:38 +0200
From: Jan Kara <jack@suse.cz>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	Kees Cook <kees@kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>, 
	Chia-Lin Kao <acelan.kao@canonical.com>, Benjamin LaHaise <bcrl@kvack.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	linux-aio@kvack.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] libfs: set SB_I_NOEXEC and SB_I_NODEV by default
 in init_pseudo()
Message-ID: <c2upjkd7boexrdqi4t2i7tcm36mdjo3nz6p4js4heyhb7xjp5e@pkhjld3pafvu>
References: <20260604025315.245910-1-jhubbard@nvidia.com>
 <20260604025315.245910-2-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604025315.245910-2-jhubbard@nvidia.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E93CEC0007
X-Rspam-User: 
X-Stat-Signature: w89rmq7ibdgm7e5o49gegdapr7p8o9uu
X-Rspamd-Server: rspam08
X-HE-Tag: 1780994804-786523
X-HE-Meta: U2FsdGVkX1/UZN5c9qG+UyKg9HLGM2IO4YbvVPMry91SMJziLzgt6DJf/PihWd8TIBrnPk7sRcYei65Elx6X8cO7x7k5DLUo+zYoiYxfxWvNg5y/jlJpbhcc1xhrsjAfd3OsUD4dGi7nygUA1kaxvEDgVNWA6wQda8VuLQREkYYExTVelSATwa55Wd/C16Ix6hWq0j2HmGF0mA1OhIdCfxA7kLmq+y6l2AtkcaHeh7bNQ/yRz9x3TINpCN6gl6vJ8x8FiUBEl54b2lrcnbpqT32TWWSWQOOX5QItM5E+2ahyapics9YqPcNB8bJsUT2wFFziGGH6D7v6VDjGqKDd3EWmwZyxkelHgTrjbasd6U21d+r7AIROxeesgHhK9dNXSVpw7QiPIo3SNS6n3q6n2ka+V74itM8qaZYTb0tDqG2d7k4yI+2OnoFBlAcuDeKaz6ccLfJLJI7TYJG+xPagDGO7KGBIPn8rRW1L0knVLO3ilFCtfc5NAwCMGfAEeuoqtXGn3WZ5yfoNiC9EbuH3nytjpL9t40W2s7y7SjoVUlZcPsrdd5oWcLARz6xXHmsomz3nPGVhBBQub7xGCKBC3WpVjh69Syu0V+DJ6+X6oT2jUstmE+9SR1QXp0SC4tEI/pxDieubNCjSY910kN2TmXMwN1Gq8uX3aQ3Z167oowI1tLWfv3+cghi2w8wkMV/43fMVHzb/A1/75W8CyQuG5wRbi2MAOBizttLDslgqqICwu2HpzC5IxJKUGo1usmTobXC6/ttwBw+DJXrRDl2kvXMLRYzVAmPAKxYjQSSLi1dm/cwokRSbssC/8b8zJbLrlSD2FFY4aM0e6+D+IRQ+uiYOWYrIldVSFp51m69tjpM8yKjgSzG2J/LRQORwjlFSRT9lT1sgmIPrP4pbtaElezb4vjVsmeb/OvSxjjo2fZCw0lj95Gus44i3GWddeHgGt19rcg04P8ui8nWzPyE
 O0+FJzIZ
 48wxv3FdxX3mHkOJbfhOzPHxphy4OKH+uiDVEc/+msvTuTgu1Q1jkHaJlJXuMjllTR0Z55uHDN/1UR11qeYDo6bnH7cwLxxTRqE+7QPz+S67Mq3By3tPI9StBksx8qmcxA23gpLZxbBrE2V208mu5Qc+6+3JGx+m2reiywprS0v0Y9irXiq+pi2t7yzCNr8trS6d2sNSrT/rkN9vz+iGCeUYUT9BcbE0fEiSB839u9Y8oqzhIxqFKsCJjhuJrMs+Ecv6tMEP//jl15r+JLpcCBKH1UcxeH4JCtUmJ5t+Y9dIh+NrbGwlyN/tPaooLGqiywgsR5YHm7r3wmk5EEbk0gxMjwMhTo1LgGuP3MRP5fzS2C3pazqw6oO6G4RgQb79pOpLwOAGuYQtmv0z/loWJDP21cAcd7sTk6cN0xc3Bj3EPmXFvTzp5Bqh5D1L84cclCvZmEDOAUYVwWq9C/9XCN0/L5Vn4U6puf1XScuTEpccFbpdjvs1jG0yecMHNPc8Ob+gEBukB/bcuvHVvKzTE5QXllDubiiJJVcTY772WEd5YQH/7qh+Gv0ig1WmGx0rMVsBKv2IOoP+eHXfytgB5PcaNWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 03-06-26 19:53:14, John Hubbard wrote:
> Since commit 1e7ab6f67824 ("anon_inode: rework assertions"),
> path_noexec() warns when an anonymous-inode file is mmap'd from a
> superblock that has not set SB_I_NOEXEC. dma-buf backs its files this
> way and never set the flag, so mmap of any exported buffer trips the
> warning on a CONFIG_DEBUG_VFS=y kernel:
> 
>   WARNING: CPU: 11 PID: 121813 at fs/exec.c:118 path_noexec+0x47/0x50
>    do_mmap+0x2b5/0x680
>    vm_mmap_pgoff+0x129/0x210
>    ksys_mmap_pgoff+0x177/0x240
>    __x64_sys_mmap+0x33/0x70
> 
> init_pseudo() sets up internal SB_NOUSER mounts that are never
> path-reachable. Set both flags here so every pseudo filesystem gets
> them by default instead of each caller setting them.
> 
> SB_I_NODEV is inert for unreachable mounts. SB_I_NOEXEC has one
> visible effect: an executable mapping of a pseudo-fs fd, such as a
> dma-buf, now fails with -EPERM, which is the invariant the assertion
> enforces. No in-tree caller maps these executable.
> 
> Reproduce on CONFIG_DEBUG_VFS=y:
> 
>   make -C tools/testing/selftests/dmabuf-heaps
>   sudo ./tools/testing/selftests/dmabuf-heaps/dmabuf-heap -t system
> 
> Fixes: 1e7ab6f67824 ("anon_inode: rework assertions")
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/libfs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 1bbea5e7bae3..e8226b9e1bc8 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -736,6 +736,7 @@ struct pseudo_fs_context *init_pseudo(struct fs_context *fc,
>  		fc->fs_private = ctx;
>  		fc->ops = &pseudo_fs_context_ops;
>  		fc->sb_flags |= SB_NOUSER;
> +		fc->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
>  		fc->global = true;
>  	}
>  	return ctx;
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

