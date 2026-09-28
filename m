Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 233D2C98328
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 06:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211B56B0088; Mon, 28 Sep 2026 02:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B236B0093; Mon, 28 Sep 2026 02:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A576B0095; Mon, 28 Sep 2026 02:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D69A26B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:24:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6981680B28
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:24:09 +0000 (UTC)
X-FDA: 85262181018.06.32BA4F9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0EA0540004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:24:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=keukrEB2;
	spf=none (imf07.hostedemail.com: domain of BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790576647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DR/hwaEZILg/9rvVDgZU74EvXnZO71agIm5YgCpk650=;
	b=SIpEJzchPkOLU/TgKycsWV4JD5FV1Kc4C7dPeZLNGwin8q+vtBPyiOMgGy7Nedhm3EPB9U
	i3BcCIT+HKog9cbYA9r79mQ8wh305B/rDEWsPxprx4k1D0aUWZMVwbgz1EnAu9hk2YcKnb
	Xh84h8e/Fas0nAZVhFliENq2cGhMdUw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=keukrEB2;
	spf=none (imf07.hostedemail.com: domain of BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790576647;
	b=xb8V2o6+jJZOHeJN8+pcUXjPrdKGLU07pLMeX4q9vNqBrtKswFzVnGiFfX2InGsojyVihJ
	vvolxFpdFcKoMQoZuY0RP7TmbkaEuqQJbWFzJoEaXKB0xWD4sIXAVm2HiVJv0tFBDgRZxD
	/SAcNBLfeUUL/MYz5ga/DbBkMD1h2/4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DR/hwaEZILg/9rvVDgZU74EvXnZO71agIm5YgCpk650=; b=keukrEB25vjEoqL/8zVNNWoGFM
	2FBJRmD+w+My6XUr8jIFsV/2GBFZ2lG14Za7h23vhi1GJDZi9mMJtwcASd+HqE+mJ0ah8L66hc7a2
	3HG8FJStZ8ItddZyxkLFDuerZh4rpvbjp1c1tGJPxKjpE4vdKHTtfjAVjF6/ffMIf4nMsWl+RYrmP
	Sob/bxS39PhpKuYbIZThEFM2e9HyDBcLjN9dZQRNXoW6IBZ5BT5/AUvSsKnUvFbURriMxPPPd0P21
	HOiTaTHd3KzuYOVj/wmFcvAK49SbIB3DqGqmi28XpaYDnZamfZNx8BgAoseyofHdpsGIvv/mnsAK5
	Pog5nVMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB4mQ-0000000HRoj-1T7I;
	Mon, 28 Sep 2026 06:24:02 +0000
Date: Sun, 27 Sep 2026 23:24:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
	Julian Sun <sunjunchao@bytedance.com>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, willy@infradead.org, tj@kernel.org,
	akpm@linux-foundation.org, Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <aroIAqoCNDBPlB2A@infradead.org>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: jow9emhqbyj7umamko1kcspk55pjt1zp
X-Rspamd-Queue-Id: 0EA0540004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790576646-424044
X-HE-Meta: U2FsdGVkX1+vizXO4puA3R1fwWQ38r0PrPR9HUHLsahQJCO9BSQXSrXujmXbT9HOf6S+ywvl7tEVshUxqcy7+IEc8TKrIvB7pMWQ8ehel0cwznPRxB+w2vrLo2KiB15gW5hfqUe6TcSrDNQUV5l2dALQy6xhXH8sHVe8gBNjHGXuga7lxtmWs5E2b40SbwDe+juad6jPv5PH9tguE/lPrRm8kjNSIL4XZYNZpS+PSRE5e3ttHivmWPP5xHzeMjKWrWBsrPBDnL53kV3p4xkUL7aWwv3ksWfHKwlKt0YuGs78Y2w5mJbJZqezI8nYCJHBTFI9/IX0BqbPnNBX5tgxxwGq6svreQip/0sgDCjuCFKn6ZBTDkFLfUykd+U5LRmQf6EQVQVwy37pJy2C0TKKjNRczBKH0cwwwBuM+7jyI6YgVnQZp9RTu/CzMq91Gc7oyXOvEPiqb+ia0Qzk//Sm14I+xeFawTNEkGZM3dg0Tm0zpuUWZGT4nD8MDIUgVNmcDzrLpYVaMQo22HZUVXjgOZyDm3sVBp5ngPtR3COVbmBlkYj2rC5JsWGKleJFXsfVeQKWHYACbTBC0TsmMvolKjOa1flkAjfA0KlTTXkYdUuU4vYtfRCI3WVxhDSAyInIe2W2H4Ekh0NbmZTgRipRClwZn9t77AyZCWPIwjV5ovBiBlbt9M/Z/Cn2oaXzOIiD/05asOweIXTiPKx9H0bPbjtDfl5noxjwgpYHpNKv/JOZhIswesV9A2MDds5cxYeLFCA24aVKul2SmzMN8PHX5hW7Fc93UfIszdqKGtJJE4JhW2GJUD1T1htpsz3iyDTrSLZtIt9VRDsKmDpF6XRT6ltfWUiTYaihXi73MwdQQHbWRd3/GqRaub19jDKCTdghUZEuGv1gvkZLf5Lre9gLgbzmcP/jPvz3NjgpCorviV8eLPoY3xRA16zDS8+EbXAPeo08cuFdHYbpKVBOvdq
 AB9n63SH
 9QHiLNuwhRH9/F5ki5i2nPGJl/xXQgDnKlZ1G4LR+qfnosj/LUiepffUcuqugUD6STSCXYyFzGRTtgIwafvZA2GjGVo9kNlLglnb8viA1IUCe4avVl4uxdkkkXxXR8+ZpPsqREeJ3xijd0ifMf/fiHeaqPQkTC+8iJT38FlgpmL/rTtBwqUA8ZcoXDlBtQhht4jRVVaSkMRxsAYSmp63CPa3hzi1Kaj3siGybxIMWRiGh7McZ1i2TvRJArYJVT3208oEfPPl56CFTSZ45ToFYgX7CWtt28TXNtPG0rFlpp60wo3bsdOHgiYDzjctiYFQoaHrdVBR5BGeHOApZBNYN7K4epQiMIi0cY9LOyFe2+eDO4QFqM3oz+omnxSg+W4fWGEqHii7nfk4QcElgUjCB7euDXtHpYCoBVdgjrj4pEDXTv4Tivnbez1FNFFsLvh76i8TT3aUGlaXO8M9QBQ1ULAXHAY5LieMJ9LGbcPPFRqX/kilvUVf6NY9Gz3ZOXgkD9QVN3pU5EcaN8TBq3UJnDjWV7X9007C/rSkeMS8KWvCy7OoMquJ597hp1R3Xddwg7PQ4Pzh86SrCtbM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 12:34:52PM +0200, Jan Kara wrote:
> On Thu 24-09-26 23:52:33, Christoph Hellwig wrote:
> > On Fri, Sep 25, 2026 at 02:44:42PM +0800, Julian Sun wrote:
> > > Add bdev_flush_by_dev() to submit page-cache writeback for a device
> > > identified by dev_t without requiring callers to hold a persistent
> > > device reference.
> > 
> > This isn't really a flush is it?  This is writeback.
> 
> So bdev_writeback_by_dev()? Fine by me.

Yes.

> Well, Julian is explaining that in the cover letter. We don't want memcgs
> to hold bdev references just for foreign flush tracking. There's no easy
> way to get rid of them so they could pin bdevs for a long time leading to
> strange artifacts.

I have to admit I didn't get it when flying over the cover letter.
But this also really belongs into the patch where it is more obvious,
or even better into code comments.

> 
> As you write, we could just hold a reference to the bdev inode. Those get
> unhashed when the device dies (__del_gendisk()) so memcgs would be just
> wasting some memory by holding these inodes alive. But still, transitioning
> from inode to proper bdev reference verifying bdev is still alive will add
> a bit of hairy code (essentially what blkdev_get_no_open() does plus
> verification inode is still hashed). Plus when replacing foreign flush
> entries you're under irqsafe xa_lock so doing iput() from there is kind of
> a nogo.
> 
> So I think tracking devices by dev_t is a good way of dealing with these
> problems. But then when flushing you have to transition from dev_t to
> struct block_device and blkdev_get_no_open() is the canonical way of doing
> that (and note this use is just internal to block/bdev.c).

I'd really prefer not to grow more blkdev_get_no_open users.

But the more I look at this I wonder why we even bother.  Trying to
attribute individual bits of dirty metadata to cgroups is pretty much
insane.  Why don't we bypass memcg accounting for buffer_heads like we
always did for the XFS buffer cache, and what btrfs switched to last
year? See commit b55102826d7d ("btrfs: set AS_KERNEL_FILE on the
btree_inode") for the btrfs side.

