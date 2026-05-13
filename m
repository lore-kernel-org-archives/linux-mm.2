Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DED4CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 14:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42A66B0098; Wed, 13 May 2026 10:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F41A6B009B; Wed, 13 May 2026 10:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9099E6B009E; Wed, 13 May 2026 10:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF646B0098
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:59:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31D87120181
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:59:23 +0000 (UTC)
X-FDA: 84762705006.15.337743A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6BD4E1C0016
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:59:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iIhYEKx5;
	spf=pass (imf20.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778684361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7C1ah9JccRCi6ntT71qsUZVG/Z79mw1kuhsp9RZIJi0=;
	b=53evhgle9INuc7mmuoTm0DJ9jNPNixo2KXKPEw4FxxegjkfXB5oPjEL6GlWGKO38VfiDnP
	ZullvdkF5lGz4rDPiRjPvwPNaZqtA9UPLB2B99Yrl7pPD3v76JFNYknkMzlzaYkQBDNyVG
	VPv2v84GNsPOp8MtjAp1Eyv4z1WJ2JE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iIhYEKx5;
	spf=pass (imf20.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778684361; a=rsa-sha256;
	cv=none;
	b=gvuoOEO3SCgP48AofJYv80m174so/C3lfawaeGvwDbRMDNXblTPxLP4DFxE7R4G2RDVcGp
	EG7/5gQ43WqLsZQEF8yZlF3UkZE6RBkX5ZFEFZRb5VURJV4n/i+BlWKtAlwqzXQd3z/OzF
	7voa/RsryeTnqBzZk1gDGcJ76Y0pyjU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 57C5F44179;
	Wed, 13 May 2026 14:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D47CC2BCB3;
	Wed, 13 May 2026 14:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778684360;
	bh=zbNHyyDRYAeGo6U86F5ea4LHa32zJh59lyteWOe4KGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iIhYEKx51XcVXCXizSytP4ZvhZtiBJmIPf+6O8Mktq3AJeEzUzkfq9zJFMxWWOQN/
	 aoWFZ5To1myUEqEdw7VallkySu/iGPAldgKZg0gl6xnLSnuloIhSu3lBTLqysfs1I0
	 Skg4f9BktAuE18yvvQRJ70VrpwY5SAV36hi26w0P9GMsQkbf7JD+SNU9HxSde3AnHu
	 bo3a4ZV9/09phwV+AioQvcuqmfuB2eTSN/4uxVBmpiaTeWdd95EFcAzHk3DTbz/8je
	 v+mVMmUJ6OM8tMNlaOTQXwFxTd7uJskcOql+wcSZWQ2REyC0QM0b5EqoBwpRfC7ETk
	 FtuJsAzYKU1jA==
Date: Wed, 13 May 2026 07:59:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 08/12] swap,iomap: simplify iomap_swapfile_iter
Message-ID: <20260513145919.GP9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-9-hch@lst.de>
 <20260512170204.GI9555@frogsfrogsfrogs>
 <20260513065608.GA2250@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513065608.GA2250@lst.de>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6BD4E1C0016
X-Stat-Signature: k6nqwuku186ggm48784fnka8o7mou8jk
X-HE-Tag: 1778684361-161785
X-HE-Meta: U2FsdGVkX18xlvv+JLgFUkBfLGEjEgkI3Ezo3ppCmbSZgUS56EmUtaQN/33mGrnOZVVVzXQdCrj9aRgSxQIzI+wAKaJGI58RjBW+D/3yLKQv3hI5L3DypHJx7LFJzUTSR8Ar9Pe1wR4A8uxG1uC3px2o5kSp63T2CGOAGdI8bR6PAjd3MeFMOXVMlQH15Fd2sxuylS7C3LtN2z0K66+mLMB8WaRxBEiU79QzzORAOY6RIlEwmqTk5+/TswEqxYsAx9yA1gDt+6VZ5wGFzxNmSeXL9PsnSYXKr8V5fQqdKYI68nlzY4YxXMY7g7K2tcrXWfqmmA9GNDLih9a6yb0Wdn88k+gH4ZblwJhnImvGJvwf/5VhlOyQqFQXom/aRQJUkI85/9NZFlmx5z/Andkg4ngxJ46KKyCZQ6RoddfCfhealJpTWZJDVKJMlnNRvgfE/m1bSIDsWCqSilOH+5p2D1g8eOWcFcb0ay5jkOQJeucFrz1GH9bhlGQBSN9RK8z5oXFKI/hol9m3NmEmxob3+Bx/lqxOLLJY9HAD6f3CTYyw2smU3zbO1nB2vuz4FizK9OFptVlO1FvyISbdIki0MoZ9p4nAt6vlq0GjDb/EgnOEwp2JA/FfOq/ZTK4mpL7i5+Pqbjv/Ot+MfvE2yR5nDURqHHYan/rduhNX8B/UqWPlyM1L7/z/mxczniJIywMG73KoYYFkoct+mIu11eZQysiq/xUv9zTSXkrg+AEu0j59nlbunC09O6McNpw/JhSJs/pcYc6nionx4V2ssyDeAVmOs02hVwBKotLQjYMIZCrPyJsCIu55d90nrllguDjeP1gLLJLwLxCVHGAQjeTKl1mwFsoauubSWI1rcB5ZesmYpsWpqv/kj/X0cJIgEnz+DRZwtxDC6rWBXyMGVi4Bc5Wb4epmr0g6/qYWias5Odzf3uIwVSkYk3ws1Zvr8AEUSICBc68udmGKvJfBmeL
 94oIz/4K
 BH+K9c89nZZXkl/xhOpWxaQ1EeQrfzNOhW3qMpDjhHLI2bQyBe6DMsfhavW9B4lp2+Vw+X1fX7i2ETZx5lC5MkAtXzVLYXIKWDFMi/8uRFZ1l/h/mh+kOhxtcHrDrbH8n9IrBuF9K1ppoxU5Ccm+/732gkbZHHmA0bgKdYDAeAYjT3lPFonwjLTSdFvH1byif+6956CkvoL08AXfHQBoIXm5jqDEBnI2cYACuQpS33zeg1SU/t/QsI6ufe6PBgAE4/6fS3fvwCtDNRu8KtuVEoHwmpKJ2GRTntnJeW/BCK0L06Pwh0o+w3axwBVRlBb0qpCV/UVjL9NuwVUO6ucECl+gg6lB8rO9JaOOSG+60iQWKpJybB7tVftv81Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 08:56:08AM +0200, Christoph Hellwig wrote:
> On Tue, May 12, 2026 at 10:02:04AM -0700, Darrick J. Wong wrote:
> > OH.  Now I remember why -- it's to handle contiguous mixed mappings
> > better.
> > 
> > Let's say that you have a 1k fsblock filesystem and 4k base pages.  You
> > fallocate an 8G swap file and then mkswap it.  The first mapping is a 1k
> > written mapping at offset 0 for the swap header, followed by an 8388607k
> > unwritten mapping at offset 3k.
> > 
> > The PAGE_SIZE rounding code in iomap_swapfile_add_extent will round the
> > end of that first mapping down to zero and ignore it.  The second
> > mapping will be treated as if it were a 8388604k mapping starting at
> > offset 4096.  Now the page counts are wrong and the swapon fails.
> 
> Do we care about this use case?  I guess you did as you implemented
> his, but still?

We do, because mkswap -F uses fallocate nowadays:

$ mkswap -s 4194304 -F a
Setting up swapspace version 1, size = 4 MiB (4190208 bytes)
no label, UUID=bc9746bf-e200-4944-927c-80d83872f1cb
$ filefrag -v a
Filesystem type is: 58465342
File size of a is 4194304 (1024 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       0:  411383552.. 411383552:      1:            
   1:        1..    1023:  411383553.. 411384575:   1023:             last,unwritten,eof
a: 1 extent found

> > A more generic solution to this would be to change add_swap_extent to
> > take sector_t addr and length values and use them to construct a bitmap
> > representing contiguous physical space on the bdev, accounting of course
> > for PAGE_SIZE alignment.  Except for the swap header page, every other
> > contiguously set page-aligned region in the bitmap gets added to the
> > swap extent map.
> 
> You don't even need a bitmap, just do basically the same checks as
> the iomap code when moving to a new swap extent after moving to use
> the sector_t.  And it really should anyway, as the current abuse of
> sector_t to store a disk offset in PAGE_SIZE units is pretty gross.

Oh, I meant this to handle the particularly gross case where the fsblock
size is smaller than a base page, but there are a very large number of
file mappings that point to a physically contiguous extent but are not
in logical order:

{.offset=0, .length=1k, .addr=7},
{.offset=1, .length=1k, .addr=6},
{.offset=2, .length=1k, .addr=5},
{.offset=3, .length=1k, .addr=4},
{.offset=4, .length=1k, .addr=3},
{.offset=5, .length=1k, .addr=2},
{.offset=6, .length=1k, .addr=1},
{.offset=7, .length=1k, .addr=0},

That's two pages of swapfile, but with the current layout accumulation
code we "cannot" find either.

--D

