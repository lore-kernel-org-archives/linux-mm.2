Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D75CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 11:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6B66B008C; Fri,  2 Oct 2026 07:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4674E6B0092; Fri,  2 Oct 2026 07:11:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356286B0096; Fri,  2 Oct 2026 07:11:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 123036B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:11:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A070C40660
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:11:03 +0000 (UTC)
X-FDA: 85277419206.29.A96167B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4F573140005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:11:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sMe4+Qlm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="4h/s4NNa";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RgXx8RmF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8i2NzZnr;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790939461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sfEfBWrNG2dSSShC5UWTM6bV5UZX53RFwxm/btMyTAU=;
	b=KTRNx+OhBXofYv3k8nRhWRmZBpcOw4pskDb7Snp6U92wSaCcja+4GPydsLwqvafhwDP3cN
	tGLLW/lOK1HVK9Jm8k5q7uKapuQhsrCqMvdXWytO+B+iLqzBRYYmxL1Z2mFouczDsViSvI
	XiEhVF6lHl4WX58XP2DACSgPbBlzQLA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sMe4+Qlm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="4h/s4NNa";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RgXx8RmF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8i2NzZnr;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790939461;
	b=P5oy93HWDxhFCmBY9p67/nqYZ8c3nyTPe324vrYh1DdKHjwI6Kdu4i0wNdd+nyrZT0i54T
	/38+1+waiWwp3bIVgjRv0fA/UbeePnm3voJzY4x8piNsRIXMV0tii3MTP1OXs2R/vq/o9v
	mPafJgIYD/OCOQpp8o0CsYqLubb+c8s=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5DE5F21D91;
	Fri,  2 Oct 2026 11:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790939455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sfEfBWrNG2dSSShC5UWTM6bV5UZX53RFwxm/btMyTAU=;
	b=sMe4+QlmuP0qwaDghsFrDHaofCGOeIjA8EswEDuJd2Lc1q/JSCzYhjp1IwTnOA9Qe0NRxH
	0HxevK9BIEgwZpay+C4z8JP7uUhJH6bDsMU4jGXyqy4V273+MAMeY8ZLXfyPODpQ1PayLz
	NN3H53J+luJ05+A6YlTKU3hkRSVXQTo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790939455;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sfEfBWrNG2dSSShC5UWTM6bV5UZX53RFwxm/btMyTAU=;
	b=4h/s4NNa+NlhLl+I2kPIewI8F+oxwK8uqVLNcVmvVVxVFIZDOeRuzZKppj6F5hrOYcZXYb
	eeZ9wtYg8ljQXNBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790939451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sfEfBWrNG2dSSShC5UWTM6bV5UZX53RFwxm/btMyTAU=;
	b=RgXx8RmF69ZqV1QwybR/NHa58iXFSAvl0YFksIro+jJ+9Sk5PkRiMT2A9U54VMv1TxhHZa
	pSm5ZzY3GUZTP5+xTNkWzQuYAFot69mxFnYxnh/I/Y9hkydagld+ntL8Q+xLEIbeIf2ILJ
	7pHQ2uEwlgJTITWv1seuyW/FQwdqlMw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790939451;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sfEfBWrNG2dSSShC5UWTM6bV5UZX53RFwxm/btMyTAU=;
	b=8i2NzZnrxC0zQCAvZVCkdaStr7qCHRiBrv/0u6jq3Z6wRIg4iQCJP9L3ymZjwVnIuK6zGI
	0O9FA73dOsGkiKBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 30C8E13C08;
	Fri,  2 Oct 2026 11:10:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /7CAAzuRv2ppagAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 02 Oct 2026 11:10:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B0F78A13C2; Fri, 02 Oct 2026 13:10:42 +0200 (CEST)
Date: Fri, 2 Oct 2026 13:10:42 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
	linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	willy@infradead.org, tj@kernel.org, akpm@linux-foundation.org, 
	Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4F573140005
X-Stat-Signature: zp4dcsktwdmeaxe7udbxtfjs5cztgzxt
X-HE-Tag: 1790939461-196157
X-HE-Meta: U2FsdGVkX19Lo6wuNqlTRkZA0SJp9cFOHG7ujaeTszlVDnnZnpWBzIjyizmBHwqzYbm9G2HQIEjsT89hsDmSOB/XVwcQsLVFwyjPakXi+d1KGJfGZznDzu5TXfz3hfzaGxULg8ioV8ZIRbmH/ci833MbqncpirJBQlEVdKs2/gIpJArUvPclE5xXCmiJo/WbSI0WZrtF/HXNhcQZSRvDHemBVLSZrQgfTlt3okBGreYFkK5c10bsY0TpIE0RwlgJkulYk44HlevuyV/rBAohzJ7PTbrm6eQphy0QWmy1cU5skAulknurapSxbrsRWF5uI+YOyrCcjvk378b4mrlBY9hZvMOay6AtSM7u4Zkbdi3v0nLzJB9k6bJmL+r9lr5plVEJLiW/5PoMAg/aMj6oIPU1S6TY6r9zEGLrza0z/JSJ+VMdbVD68LLah3qX/Q1yK6eJeMikOaj1HY6gSQuYhSAta0YmIVbReIb+UdbfXt9/252yjEjxvdQLinTT91AGFVZ+9iqAbiw3gjI25E+DniNdRtVc/ztkQazXIi7vX38+pFm9QcSOH+vZ+Q64Wdi1ywOk24ts01KuHPbI/gVbW52tAHU364CapTa6orz+DTaDGkF7cc6AfEvan65CUpnfLGWu0RolHIj1ew1t6CZ5qh7D8Zt8OTDh/0UwvKU0m59Xs/e9UzWItSzJhy3b5ZqSWGZ3XITlHWhyFImrqJfrwc/MbK0UdhOjVG6XJhzNrlCjSW4ZuG04mGOQeENf5DLrD61FOVLFnQ4BaCHFvXiYvvjqcj2/HGQngMWjCY6REuKkIax6+pINEhgg66nP7VU1kz3Qt9HiW1sT7eo1WCXICiljm/b0afT1sHoyvMeS3+VNa7jwfYnEbzsKf2AoeIXYUapjLyRhb6P8c6OQb6ip0Nlqv7G3WoyzToznEyYy5JavoVN4a9hpN/qUkQ6Yjv0Fvjnyb5SxcjN4q/7Bf1C
 k+GGPT8/
 4PG3dp7iZqgviP3qBnSwW3Yvo65s5jIHqm7W24F1eVqO4f1eKw8OtZLxg2pqT641yre50JtHN6brSN+sX6+Hefxru+CbHGHNLCc7QJpT0d4XMmbtjR3usIs17hvwqSGVd/tWzNeEijbVMeGCjlwge8Cuw26qvCVI74vDykwqsdbQeEYd6UXuDHEvez9uoYcY9zp2K0Bc2IXmHo3IOMumeI9dxS+1H8RiL3g4CJrSlegTAbBG+/KgHgVTB8a7I6yzx0xrkL0Nq1sfCzqPINg5w9WzKm3wu9JMoFHDKyID2q0bT53y4laJSw9i4yFDFOXExr5bzgPyzUPjMHFXqeX1a1W0lGbSCIE47riusxPJgSFEcGspRg2iSqp6yH57Mvm2zmoCE65AtIofKAi0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 28-09-26 17:51:09, Julian Sun wrote:
> On 9/28/26 2:24 PM, Christoph Hellwig wrote:
> >> So I think tracking devices by dev_t is a good way of dealing with these
> >> problems. But then when flushing you have to transition from dev_t to
> >> struct block_device and blkdev_get_no_open() is the canonical way of doing
> >> that (and note this use is just internal to block/bdev.c).
> > 
> > I'd really prefer not to grow more blkdev_get_no_open users.
> > 
> > But the more I look at this I wonder why we even bother.  Trying to
> > attribute individual bits of dirty metadata to cgroups is pretty much
> > insane.  Why don't we bypass memcg accounting for buffer_heads like we
> > always did for the XFS buffer cache, and what btrfs switched to last
> > year? See commit b55102826d7d ("btrfs: set AS_KERNEL_FILE on the
> > btree_inode") for the btrfs side.
> 
> That sounds reasonable. However, IMHO, the main difference is that ext4
> stores this metadata in the bdev page cache rather than a separate metadata
> cache as btrfs and XFS do. The same bdev->bd_mapping is also used for buffered
> reads of the raw block device from userspace. Setting AS_KERNEL_FILE on that
> mapping would therefore also charge newly allocated page-cache folios from
> those reads to the root memcg rather than the reader's memcg, bypassing its
> memory limits.
> 
> If we pass a flag from ext4's metadata buffer-cache allocation sites and
> check it in grow_buffers() to charge new folios to the root memcg, accounting
> them as kernel-file pages would still require persistent per-folio state.
> When a folio is removed from the page cache, the allocation context is gone,
> so we cannot tell whether it was counted as a kernel-file folio.
> 
> Separating ext4's metadata cache from the bdev page cache would address this,
> but that seems like a much larger, longer-term change.

FWIW I share Julian's concern here. It would be fine to use AS_KERNEL_FILE
for ext4 metadata but I think just unconditionally setting AS_KERNEL_FILE
for bdev mappings will cause issues because some users may be using bdevs
directly for their workloads and they could still expect proper memcg
accounting to work in that case.

We could set AS_KERNEL_FILE when opening bdev for a filesystem (and remove
it when releasing bdev) but that would have to make sure there are no
folios in the bdev mapping when changing the flag as otherwise the
accounting would go wrong. Looks it might be doable but getting all the
cornercases right will be hairy and overall not very appealing to me...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

