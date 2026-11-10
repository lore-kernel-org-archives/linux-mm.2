Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AADA606A327
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j22Pvhyi
Received: by kanga.kvack.org (Postfix)
	id A67A16B05B7; Tue, 10 Nov 2026 16:55:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3F0E6B05B8; Tue, 10 Nov 2026 16:55:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909D86B05B9; Tue, 10 Nov 2026 16:55:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69F176B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:55:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E31A88011E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:55:05 +0000 (UTC)
X-FDA: 85420565370.06.DD3B4C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2CE92140006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:55:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j22Pvhyi;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794347704;
	b=hvtxdvLvKi9dKfsOescw1fgFXYfctAffjiTJ4PV6xTK5xihe0tHvTyjKCLwNEiQB2+DbgJ
	dLEAVCM/8TG6WPv2CiO8fAUuqcdI76B/ScLBxAG1rHcV+ldBqDKfjUkir5faPjKyyRBVqX
	mXSdwvIpePEOsQKtfVDSHybxwkIvUow=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j22Pvhyi;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794347704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qo2+jRzUK6ef9hbeUahqrraMXl7IGJhVlYVAOScV8ZI=;
	b=1jTDtlJfAVWpFg5z//LMwwrqdn7GyjqUnPAmUdCZcx9Y1bGPVSoUKFNy8bHt9poKwBH7o9
	eBYI0M+19U2iUVLP2C4+98JYTzMmSTI2zukEDpDgHjFcwm5YITEHzZtqcNTuP2BPCLbBhl
	JkujYNMj8noxi4R7P3UIv8ZJnlNRkEg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A3A743C76;
	Tue, 10 Nov 2026 21:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944791F0089F;
	Tue, 10 Nov 2026 21:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347703;
	bh=Qo2+jRzUK6ef9hbeUahqrraMXl7IGJhVlYVAOScV8ZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j22PvhyilTKnM5nyfrsCHKDdMDuDUmUojoPgdFVX3mAQZV2Hd/EwIcKqe9WVrqR2c
	 MSzVoBQwUnPD6JzsOc+1o53n5QYkcA+nlbqm6dxtbnSJyl1ZOQIiHKoQnYZzRHBowa
	 e4X8dMoJr9bDyOXLzZ3FjgJiGislRrlSph8RedwX838BPRAKN2NO3x0D/Z2w9j2CW/
	 KQxt4VdILN3yV+fYs4w6/qhzADCZGiYz2e1iQFRwWJMpZ2iPogLQ1Bb6gF7gFEd0oy
	 GDOo3T8sD7nRxhmfhzFYGhDL0p+Q5hwG10KJ/zATsmnIkscFJ7zS+hlynFopD1R2yP
	 G8nJmfQnsF5QA==
Date: Tue, 10 Nov 2026 22:54:57 +0100
From: Christian Brauner <brauner@kernel.org>
To: Qu Wenruo <wqu@suse.com>, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 23/34] btrfs: check BTRFS_FS_STATE_RO instead of
 SB_RDONLY at runtime
Message-ID: <20261110-kursniveau-zeltlager-quintessenz-36b26debabe3@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-23-2f44f64f0b66@kernel.org>
 <c88e4e9c-6b86-4fbb-94bf-909522badf83@suse.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c88e4e9c-6b86-4fbb-94bf-909522badf83@suse.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2CE92140006
X-Stat-Signature: n55rgcm8pmnyfkot6z5f8a1gpum8rm8y
X-Rspam-User: 
X-HE-Tag: 1794347704-967881
X-HE-Meta: U2FsdGVkX1+dTRJkhb2Mwm1Ln9THf941q//AxoDYpf3tzwTJ1Tho/y3cdaHGbmgqH1MgtGFLJ1EoP6rmPA3nFFY+7b3bD+gp2p+/MAonPMWLPrOW0x9avJhV2qsjeFaByQUPMtsCxRX+hm7JIt3S8w27vvtzkufmoNivCtj+biOaXawWv8QkUUKmoXySEF43qoCfUeaLOsalGaUakBuO+pMPOvPi/cYBSpoCjri2Hzsl0UOf241lWSrFj/Ln9CFX4WIakwXlH8L+cyy3Eik0ufNMm0F+z2hvwsQhn+yfLFN9RMovl4JHeHhEadOwkpI5xSQZGT+bhlNmSV9oNeNUCD+y/6GtuNZx9gBklklKcmGJLYNgGpJYutiooEhxX1lE3AzZfZariM5Xj2fsfDltjVn4DTaFd5V7z5hEsZ79ac3psqe7DG9naKLcHpgHy2SCDu7yLRACtpag9j/8t45fORr3tAQYF7tUTjVQetr0whMbV0E3lJzsx6n1SAM1h1ps759k+PZVZ+6mTi2f5Bf5fTkmB06TGXDtOkrB8fwDfI4S33O3n03XnOsTIVL4++IYCuz32i+T3NauSe+4cQ/+dapb5KXP3bDPMmX9NLi6PeBKjGHIDRst/7pPREGMbV0C5HOGXYpGa+cEv0TOrXR7TpbfG+4T3d8YK1YoUZXVPBUtrUgKFOpUqvozkKBWmitMTz/U7E7H6v1NX515XlGV6bKXn7ZNgm78sCJgovObIQNzKxJ/CiOP+3++458Kklxc++ZakP+8YJ7hAnVC3cwbwnUWxusNSA8trqFiUpXpk4G5lmY5WHCspSTR/VZNefVTw5Xz5+WP2tw3YOQwkcOcqS948CtSlis86kDgEoNNA2xKOEOwVKZ8LH7yI7EUCqiMu+dbtNDOf+i8kDKTyk74yVjSDVds/GtI/TetSvnu+ajMjSWoEV/lHiYTpvy0aSsyQfAzJgzpS/5/Msy9AZE
 S0TR6b6e
 PXBdPW55cyIfgAGxnVscHLiXPnvTN5GHCglJxmNHB2b7zsV9injrY5qFBdXM1MRXr01MO4doInc2E0dQwQTygEr2sAEhhwxltMiAn/JjHZTpJQd2z6qKmu+z2qEiyb96EYO/LxucluFX4YrWfIjOe+3qYKKXRFeex3QKwNrinbNpYOEIEkfVXfDJRI2hP+r9+MM0JsIyxrjbfyDYN+p7Rceafyo3kz+Wi5wVrLCQbb2xef7ao4BIzaY2doEQH40zeGqYEaskKBkFFcpLhu1o1oMTUL1ENF0kHEaEuG7LQ99vp7dCJ93qRwIKPL64kWXq2N5tciRhYQUSia0rNuJDcPvqq91+E6+1nIUC+/D4YqMZ/pdk4/EZ86V0PFuEVNAAUVFNvZGSCikXc074kqgmvsg/9aNVkbwcLoDRm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 01, 2026 at 01:26:22PM +1030, Qu Wenruo wrote:
> I love the idea. This reminds me exactly why for btrfs_force_shutdown(),
> we have to manually set the fs error without marking the fs RO, to avoid
> exactly the same problem.
>
> With that said, can you also a set_bit() call in btrfs_force_shutdown()
> to also set that flag instead of the exsting setting fs_info->fs_error?

I think so. I'd set BTRFS_FS_STATE_RO in addition to fs_error though.
start_transaction(), join_transaction() and btrfs_remount_rw() key off
BTRFS_FS_ERROR().

Note that this changes some error codes after a shutdown.
btrfs_permission() returns EROFS for MAY_WRITE once btrfs_fs_rdonly() is
true so opening a file for writing fails with EROFS instead of the EIO
from btrfs_file_open().

