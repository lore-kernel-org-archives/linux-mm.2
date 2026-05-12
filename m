Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A692CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63FD16B008C; Tue, 12 May 2026 12:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6189F6B0093; Tue, 12 May 2026 12:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555046B0096; Tue, 12 May 2026 12:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45EE46B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:42:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E39958CF04
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:42:14 +0000 (UTC)
X-FDA: 84759335388.01.AD83C30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1AE75140010
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:42:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TTTeSIYr;
	spf=pass (imf09.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778604133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kub5HTDrwBJzNbI3PNEkBe/s6Sf2C6g3RIxDvnlWSBU=;
	b=0j5uLtBvdKCaKkhG7FeqE+AusmClwg2Ew7guTRhXWinB7i0e/HQBj+qFqv/arlDYiPd2jD
	zdDrNURMSl8AmNWO+bZpq6Q8GquLHH7Ar67NSY/ewBRkIchaGIsqxBUNou/KlhKPQBLwzl
	MHazkSOW82C3g2KN19H1L3pYzkAxhrY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TTTeSIYr;
	spf=pass (imf09.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778604133; a=rsa-sha256;
	cv=none;
	b=UW4/+bebbtBEbb47q6XW6taz+Ym+7RV9+YI2oIyJIO/lebtpDHSMAOoFYWnZ/gYoTHg1y6
	fFkL+6jAJfmGBZSw8WlIkmANPCW8qc2lv79saxCgihPADeQkLbFZPrcn9Rs3nzSsC7h93H
	SCL0aUGpQbCAWhcdexRIr1zHvajfQCs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C266418D9;
	Tue, 12 May 2026 16:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A35C2BCC7;
	Tue, 12 May 2026 16:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778604132;
	bh=HoLO8a+vZpAtLOTBMM5s56bZzE6B2/xXip3V7gv1An8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TTTeSIYr0mdy8HmJYqjqcLWEHq0y8Zlb5+Bkj0i0AArnuJ7wbNWQRMMg/+jBX4e7l
	 DMqWrdAzfmyEdet2+8O3vETYUEeeqn+HB1x8V5oWp3B/dV8OYzwc7AiQ+4kpybNjeu
	 oXlammqPj2J4WUGQdZx5gTME6ga/ClckN0NU0hI7bwp362zNjXaD8zqd7sk5PtrP0Q
	 I6saHT3UM/tU5CEmUlfhbS35iXJrbw0AAOWn+6LoGkEM+4Ezqd4MYb6Z2cOe1iuf5v
	 X0x+S5CcTFnIhFy4dpdSpOQ5IspuYVG0Zf0k0TaC3AV6LVdFF6C+DXDWZy4rOp+aAH
	 FMfkMFkcQb+cg==
Date: Tue, 12 May 2026 09:42:11 -0700
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
Subject: Re: [PATCH 04/12] swap: restrict to regular files or block devices
Message-ID: <20260512164211.GE9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512053625.2950900-5-hch@lst.de>
X-Stat-Signature: 7udoi1b7i4biqo983xsz1311yk6b51xp
X-Rspamd-Queue-Id: 1AE75140010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778604132-426325
X-HE-Meta: U2FsdGVkX1+yDUv1Pz6WRx/9YfJvZO8slGk5WzT+gC8FKHUpRUoUfm+t4KyadJha4yXuKsGB9q1l8v+xQ7cHm4RMPByVDyiYM6E7NUZwGHoJ7yjF5UOOTTeRgJ7mSsHPQZ6WE8ksgDnHmxZX7YuaSjT8AC6ftzcv0YsagHATQBNjW6kpaGQeP7F+T9gjWB2fvh6m4952E65m7X1rnUfDeNRkQGuvaKuTLaPxeetF9bcSt8xOE0hvq8F0N0lrdyUa++YD7Rla+gMHYFF7ikdp7oBGTaei2VhbhVCNNAzgdLgdbpYUMPG1uAg518TwzzMo9TArp1G8CJDlc+sKgk2Oh/dupbMz2cieEw6geqrWmuZUdfQ6S869WJo9t+Xtvr2/dPQaX3QlhJdvKY8jX5mZ4m5UxBNBsg7ZxWO1KtDdyMflnHnfe3D30S376cNwExM5cl47W2o+f1hYnCfaVtDYnDcl19j9scteO7ukXpeLwKIY/WKCbXusSxwlNlZo6GIETKmCyYxwDKg79vvAL0/r/W574z+mz0gH7eT3G1G1wwjr28VAtZtBq6e3Qa5P5ZUOeT3z6W2tmFvQHQyP0GFXuZOxMI7j8Dyeuz1IoYwUoAr6Cv5SskRgiQJdRfWy6/DnmateNP02PhSv+BRS2nVCIYDeSh9uVXhP1M9YEM9DT0S7Rsajw4opFTH1WVSbQ2Kn0eantoq5UpnOdm/xWYFXNV5whQMBq3EFDznugk7fKIooppL4EQ2L8w/IqU50Lf2Zl3IFdATxJDfkgskqYm2/ULUymGTWaIa6+YeHUx9LohoqcaoDG5vNhHBHH1tGjYPo7KcSjJncTAV+AjJwRNib/ifT+cye7ya6Rq/NkN9LiTlyfL8hAZbJcE8DzfVEJCDuGkqmnlGFfiJbJiX4b4RYWGAut11iBQN50YcEG5ntXg3zrS/VHVkBVGDyTOjVwSwzLUTmYYz4scCv7KzUPrW
 PchfCkLq
 xPqKBbbem+PKmFzSXmO2akmWkv64H5v5zsVqfl6Qany0rgmwTnKt7yUxMvNuyFmgN2TwdVejVJRNsBFvK+HSQfdteCo/UYQ2/6PfsvotsAdzOtO3G1hgRCR4DVvvGqevKVLy8Y5Kp+AYcpGVnFT5mBi/Fz7Y44lNZBegqDp+Uf1UrQu1NVo7zAgxQFXK0GzyWBZe0jWznhUX7tlkNNrG44DwNBbiQy8O7tfD/qIhLB9SsntFmXIBPqqMA04Q6PKbUu1OQ5511PrZw2C4fR9EW/i7WZLC1BdtBrUyPZFpgYzpk964GVPKK9ztqedUW+KLneTGnxaUxi+NmWJKlQH2w/FaludlWCL2KIqKO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 07:35:20AM +0200, Christoph Hellwig wrote:
> Various swap code assumes it runs either on a block device or on a
> regular file.  Make this restriction explicit using checks right
> after opening the file.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mm/swapfile.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index a183c9c95695..651c1b59ff9f 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3515,6 +3515,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  		error = -ENOENT;
>  		goto bad_swap_unlock_inode;
>  	}
> +	if (!S_ISBLK(inode->i_mode) && !S_ISREG(inode->i_mode)) {
> +		error = -EINVAL;
> +		goto bad_swap_unlock_inode;
> +	}
>  	if (IS_SWAPFILE(inode)) {
>  		error = -EBUSY;
>  		goto bad_swap_unlock_inode;
> -- 
> 2.53.0
> 
> 

