Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60ADACCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 11:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEBE28E000F; Mon, 20 Oct 2025 07:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3448E0002; Mon, 20 Oct 2025 07:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00878E000F; Mon, 20 Oct 2025 07:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E58B8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:45:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D208C0137
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:45:39 +0000 (UTC)
X-FDA: 84018312798.13.E1E0884
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 91945140007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:45:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ycvFCmNm
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760960737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkweqAAJQplqVKFIiBARnqmdFwuOJtteqmLLYasVklw=;
	b=f1ZLSdhWpAxGqOfvvq8AaIu+2DBYByYaXnqSfhpRW0qZYAaOJ+pZ9LI+V3cEfQ5H4ht761
	CK4xZWrltEajWXM6EeMS5m9Wpe8YQes4+nLK586aN8Ua/aCC/YpX29mq6x8r+i1v2AkKqh
	T1fZzEntUxRkxKaF51g/sV42INVL2VM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ycvFCmNm;
	spf=none (imf23.hostedemail.com: domain of BATV+17a2c00bf4ec3f455068+8093+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+17a2c00bf4ec3f455068+8093+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760960737; a=rsa-sha256;
	cv=none;
	b=561EODyw4uEDHRhwz6E9/nJpc+wdd8QaVJqFmaHtZ8Rnf+nNp2tsk2q1u8Gbb9+/0gRlwm
	r+p6mly56uldtNS+icFuprxm8Xmg3Ac+LDrV1dK3uMWIg8/E8zMiHAVNYFiNdvWDy8clh/
	Qd1Fih8UWARDifigvY9SdYRF8Z6ITUA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=MkweqAAJQplqVKFIiBARnqmdFwuOJtteqmLLYasVklw=; b=ycvFCmNmRu+BgF1ZNr0uRQYdVm
	zZ1VLqnpm90cz3ojZJZwOL/kce6A1db/H98JPaq0YefLH6jOdGS0ETm1E42h8FsHGf71QS9SVVzST
	N8YNOa1RtZUSUv1qXyPvrSx6/QKYvUnjHX06brKu+G2WKljvwMwbxEwgLmEhQULiyt9y9zNqFYxF2
	1y4yv9oR6YPHq1VVzIP57UzEQNaBBwQYQA9mhVH103S+sjhjk53192Dynd0bJ32CBcsDRSgmo1mAj
	CdcfIGXXtvkrI4ofzs4DGRpVkOjOaSoizA/DQY/4FSVRWHyjXStf8iZ9dNMmzT87YQgT0KqOxqu/S
	Y+u3ELCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAoKV-0000000D7CQ-1kGG;
	Mon, 20 Oct 2025 11:45:35 +0000
Date: Mon, 20 Oct 2025 04:45:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org, djwong@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	martin.petersen@oracle.com, jack@suse.com
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <aPYg31lAv8YKxJJJ@infradead.org>
References: <aPYIS5rDfXhNNDHP@infradead.org>
 <acbb5680-ef7d-4908-94f4-b4edb8b3c48e@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acbb5680-ef7d-4908-94f4-b4edb8b3c48e@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 91945140007
X-Stat-Signature: 8dgj1ujj7tn8gkn3o4cxaeqdtjt45kf9
X-Rspam-User: 
X-HE-Tag: 1760960737-297887
X-HE-Meta: U2FsdGVkX1+mI4cYHRGYw6HGJucWy7MUcJtGPp6owcV4wDG/jiRHclozKJLQSia5ajx6pkI/2L7bLFYx8KAlLmhbLuVOWeeW5kcmyAtFb5HGmWLIT59q3F2+CntvgtepLxta/uNGkrpG7zRAq1h9X+3Glf1WPCV3MLNirm5Bk622Q3U247oErchzPb2boZxhsK/p04ulr+K2DXVNtDeGXkguddqVJW54CpMzwhiAtqV9hsL5MzUTDZbcNKRPBT88hN+TsaCA2F4CJf8ZsOIs4d9FAtMKTnS5zSMt+bBg5HyXj9ugKZmKh4YJhCXOTjXs9QMpYe5ZslEZ7mkV0pEZ0u9Z11KrmEylkB7AlcUQIEi6P0YikP/b9MrdbMg/ctvTWKhzhf+hwM3qj99g2UvrihXVsx1V2HERXxDQ0a2BFjqDMQIQfvLoBNDzNfpjPaKReVS2vuXt9UwWc+/SjgwHVWsVDq6NhgDG8JPKU61iL6q+jbFiNswSfg0vJcVz5cyVE8h1TGFhiBRcBgjpizvd0+mlqvhXOvKxylrnxw+9TV8dAyYRZS/4+lzptbKdhqqIkQeYxGwfjoeBA+znck8xRZiCifEDNYu9oWqpGeaNAYxbgoYLy5MnBPPB104RLk2pTNPqmeR1+bsbC+30fjTbee48h2Sq5cTC4eKMyiCSMlGD7JXi7OfVy1EseIj2TySbx4+iNbEbEq+Ug2kUPaAYvxP3lntZonGHbmM3Wvl5iWZt+Ld8tb+Txub6R5gWu+s38xSMYqhmBgX4FTqBdNgQ26rvyvp6dD5QFUeNFeRYZHYH1+FJqCI/1CqGk1f14wY2XNR7V+zW6fJB8zXPU2e6cEXhIKMpJZXCvrxeFdIul4l1tPCybX7INLs+teBOJ6ExG81/YBp1+Vb/RC/Dq5Vuo+GkdkDCRLHptlA9u/CLYpUyXprjXNzaFb+PYICkzUcx0TMjul4QJmrWMNHyGZX
 eC4tZj/h
 Hyg4f7gJVfV8muOoBekKvLClEDFB9NBDWsWfUxlV7jrLRFF9hwhxLasHBXbHnSMdFF2MydkJmGcy06ueWil7vfEamWhpAIYw9R20+JYmScG2FxEzQt9rWImwQUCYK8Lh18jb/zhp7JnsotHmQ5yQ3nJ58Z5cwXjgxzxoxMJXa9FIeTbH14bFVWCWWzVjowlAztu2dz5lTWKmYDA3iLhnQvaW37JpqSJbva+gS4mYayWKRmfqf8k9SGGMvnz27LAo+DEO0/bHzXFxm7+leZDTWf4spjYaGYVL6C9tt7YpfEy0rh5U1ocIZ9P5HVo3YQX1c0VPWbtgbldgj4RCwdKbMXSWMzHkV77jHetqM8srTFG9cqVvBkQdkWBVStI23+Tw2xz6bx0tFdO5p5QyUTZeNe7JBfksQtPfP1k19IMjTcP/eZ1A2DfTTOq9AJ80g47FRPtuq5Cdi1O4uVB2XCJMqkijtplXB/VRjamcrnDWhmOR4MHWw429Ihp/PPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 08:54:49PM +1030, Qu Wenruo wrote:
> 
> 
> 在 2025/10/20 20:30, Christoph Hellwig 写道:
> > On Mon, Oct 20, 2025 at 07:49:50PM +1030, Qu Wenruo wrote:
> > > There is a bug report about that direct IO (and even concurrent buffered
> > > IO) can lead to different contents of md-raid.
> > 
> > What concurrent buffered I/O?
> 
> filemap_get_folio(), for address spaces with STABEL_WRITES, there will be a
> folio_wait_stable() call to wait for writeback.
> 
> But since almost no device (except md-raid56) set that flag, if a folio is
> still under writeback, XFS/EXT4 can still modify that folio (since it's not
> locked, just under writeback) for new incoming buffered writes.

All devices with protection information set it.  Now for raid1 without
the bitmap there is no expectation that anything is in sync.  Raid 1
with a bitmap should probably set the flag as well.

> 
> > 
> > > It's exactly the situation we fixed for direct IO in commit 968f19c5b1b7
> > > ("btrfs: always fallback to buffered write if the inode requires
> > > checksum"), however we still leave a hole for nodatasum cases.
> > > 
> > > For nodatasum cases we still reuse the bio from direct IO, making it to
> > > cause the same problem for RAID1*/5/6 profiles, and results
> > > unreliable data contents read from disk, depending on the load balance.
> > > 
> > > Just do not trust any bio from direct IO, and never reuse those bios even
> > > for nodatasum cases. Instead alloc our own bio with newly allocated
> > > pages.
> > > 
> > > For direct read, submit that new bio, and at end io time copy the
> > > contents to the dio bio.
> > > For direct write, copy the contents from the dio bio, then submit the
> > > new one.
> > 
> > This basically reinvents IOCB_DONTCACHE I/O with duplicate code?
> 
> This reminds me the problem that btrfs can not handle DONTCACHE due to its
> async extents...
> 
> I definitely need to address it one day.
> 
> > 
> > > Considering the zero-copy direct IO (and the fact XFS/EXT4 even allows
> > > modifying the page cache when it's still under writeback) can lead to
> > > raid mirror contents mismatch, the 23% performance drop should still be
> > > acceptable, and bcachefs is already doing this bouncing behavior.
> > 
> > XFS (and EXT4 as well, but I've not tested it) wait for I/O to
> > finish before allowing modifications when mapping_stable_writes returns
> > true, i.e., when the block device sets BLK_FEAT_STABLE_WRITES, so that
> > is fine.
> 
> But md-raid1 doesn't set STABLE_WRITES, thus XFS/EXT4 won't wait for write
> to finish.
> 
> Wouldn't that cause two mirrors to differ from each other due to timing
> difference?
> 
> >  Direct I/O is broken, and at least for XFS I have patches
> > to force DONTCACHE instead of DIRECT I/O by default in that case, but
> > allowing for an opt-out for known applications (e.g. file or storage
> > servers).
> > 
> > I'll need to rebase them, but I plan to send them out soon together
> > with other T10 PI enabling patches.  Sorry, juggling a few too many
> > things at the moment.
> > 
> > > But still, such performance drop can be very obvious, and performance
> > > oriented users (who are very happy running various benchmark tools) are
> > > going to notice or even complain.
> > 
> > I've unfortunately seen much bigger performance drops with direct I/O and
> > PI on fast SSDs, but we still should be safe by default.
> > 
> > > Another question is, should we push this behavior to iomap layer so that other
> > > fses can also benefit from it?
> > 
> > The right place is above iomap to pick the buffered I/O path instead.
> 
> But falling back to buffered IO performance is so miserable that wiped out
> almost one or more decades of storage performance improvement.
> 
> Thanks,
> Qu
> 
> > 
> > The real question is if we can finally get a version of pin_user_pages
> > that prevents user modifications entirely.
---end quoted text---

