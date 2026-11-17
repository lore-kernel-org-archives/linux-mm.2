Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D03606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ammEKiKC
Received: by kanga.kvack.org (Postfix)
	id 0F54D6B05B4; Tue, 17 Nov 2026 04:51:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6A76B05B5; Tue, 17 Nov 2026 04:51:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89106B05B6; Tue, 17 Nov 2026 04:51:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBC246B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:51:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3DB0D40390
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:51:25 +0000 (UTC)
X-FDA: 85444143330.30.C943EDA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 97215140009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:51:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ammEKiKC;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909083;
	b=lqAn7aMdtmc2KvwJEoBR3z9eVrqzi5gslB50u7Z0PefHuE03Y5Zoy1SjOe9Vtvg6w/kYeS
	Txc23KSxMnt9Ybo5iBkvFP7VSV7NEcVSb2DHoj/Zo1FnOlsDwOw6fmcKMcgAZ608il5TWI
	YMWHfQTfThLv37hFNTc5Pr9bCQr2G7U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909083;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgWorztv2BHlor1T6Axd/Nq2sNHTNA8oBQHQSlfJdi4=;
	b=Rp0CCMxitI8iOMymR0LSexy6Tcs9477tBBP9Ey/ihE2FOUkam/rGY2S+pm+aF4RPxkceq9
	1ntHU6L91ioO9bLh56XU3C4lLw5eSyAeS0EWUZqUow4/XPKBVdufl/FEUMXtb8uicZV+18
	ulyrOLP6vsvxN1REKKGoRB2cPfmAYT8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ammEKiKC;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E87D62F68;
	Tue, 17 Nov 2026 09:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9C81F000C4;
	Tue, 17 Nov 2026 09:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909082;
	bh=IgWorztv2BHlor1T6Axd/Nq2sNHTNA8oBQHQSlfJdi4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ammEKiKCdIdyCVZgC/j7JtdKyM6HDM47RW0+62Wq+RK1zS5F7otycEtBFf6a8b7GL
	 T8OFTwYhAT+rtnMSu4E4U2HOoFCrBq4YNpbs2byR8wgY0ul+t5h5uTPwotJ/pIJHJU
	 ZXc0vTVYbaSRx/nmmS9B3WwiJE7bzy+OmUITRwFeddJEwqg9ejhbZEbJOZBV1z8byG
	 tx2nM8Qy17jXG6sYjCTOH7SngDREzscNaNbgEhoirAzPZWru3N5P82mcN6Z673HN8q
	 4kD3T7R/SSAGgkoahMLNDdtftjITuqlozGsERONYZF8d1fAOaliy0JLkeBol/A8VOt
	 rZqE/leZAHe4A==
Message-ID: <sashiko-outbox-218535@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] exfat: keep the volume marked dirty after a
 shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Jan Kara" <jack@suse.com>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261116-work-fs-sb_rdonly-fixes-v1-2-95a25ce917ad@kernel.org>
References: <20261116-work-fs-sb_rdonly-fixes-v1-0-95a25ce917ad@kernel.org>
 <20261116-work-fs-sb_rdonly-fixes-v1-2-95a25ce917ad@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 09:51:21 +0000
X-Rspamd-Queue-Id: 97215140009
X-Rspam-User:
X-Stat-Signature: d6pdg3zkofbazjzri3bfm9kchumb4d6y
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794909083-780750
X-HE-Meta: U2FsdGVkX1+L4NZtBZxoFzqmfmENNGuiBqNlnZXesHETuijl6VtQU2jFT0wMCZpnLsa7NRkUG93ZTwo+ZAv+Zq4m5w0hntukrzZZdklj9WSytZmr4cbPfuLl4eI3xGKJ13DvsqnfAQDwfsmeYygHuHsNo4k4Y/9SJAZmD8c57I3HuzaZepi0Mw/ysHKgXp6OMJ8qTauE/OFd+CBFqJhTPCNcdD7Hwi7kTtLT24SfkdTSnluRTYu/tizM//3D3HZ38Fn3IPeHbTlg2j1Cmt+aA+MWpg3VHJoHrNYXnvR5KJRZCRWzUrJm0Gle5q9O7vi4A1XGfmtj1KXoPzZSHQsUw78wpZMkV90RFEJriGnp5fj9vrvqk1s5l6bzhOdYL290u4CTXv1WpzSgutOy1ik6RMH6pO5adrSfYG6i/y+Cw/hHOmsFkoIAtIyWVVF1QMU1eJAVezpORjVDBvwhZK0u7HKpBfu4VhKgtZNoFJFG0LhCN1zUyneNy5E/BDhkOSOZJbM4puUGe/F6LwRBFSd0y0WE1UM5jpAsBlRwVTKbp2RZ8VmYv/jc83VGMYmaLDVJmDO8Jrq63MDjajX3iMLzR/b8C7e2EwLG4FKho+PAze5CTCk3bS1nogYRccdYy0CDv6KeHnXDoU+hr9+cnnDcKfawao5eaCCHCL7KPpaqu8/kOHwN2oxQfa4hWNqfbr+971E0cOxKd7TKvSpNk0Yxkv5lIUldIQgseO41O7EEReVBujfJkrPh8U68LdRn05t2VigMNhOUcvVMBh5J8jQNI0Zxowydt6K517qVgoVsCXopy2aICBfxPV940XInc2LFO5IOqd4IKKsI0zzcTkn1JUfJLwSkjhJsWFE1kCGRiU32UWeMYwjMJCOn0i0/TTnLuexC+yPeyMD0RED678gWdLcdNgNC/bnN2wSrMgl6aEnzWNCmREz4JlMlarWnX+AabMbwAFXAiGR15WcYk5S
 NUh89NDr
 CxMbghJVG0XzVMOx7LNL0v/2W0Q4M0s3iD7FdkT66WCk//LSVHJmIQOUQRPhSLjJU7hqs0zKUOLjP6Jyl6Y0K5sjiq/ICH9qn23ApN6kMVf9XJ/4xmw5K1ejj1VBJbTwXB7J7tdeNAu8SETcLOa1f3RT5jlhLNQtC5q/DmF4IEWaMQXbnf3n5g6D5o/VurqipvowE/JWEEkRSdGkyzkr/JB/W3b1c5H4yGciHJJw+qdAeUhY5TOe51M9oXlc5PJyvFpzCWYBzUeu04lT38RaCEBwlfDiy8Ddw2Jvb4Vl3UrhuRQL4V2FNznI+OaceBXtzFm9s7Kx25AJWLcATzoEnksTWaT8Is+A5WzH6Xw4TGKgXRZvDqyxe1iwkEXkn1Ccls62yeyc/6JlSUYBvwfgVCnDJ1UVQJkS7qnuSyv0YcF8EzldVh/17XZ22z7vOhnF8HJRSX13yjyP3vgVsxjxugE+Fxe3QjT2IoJcJFf1v1TYLgbky+YSMenwTl78cAQnPgAF9NkCYjMHMz9vomeFO6k+LNEhyFzeafQ9on03aUIM/toc+GAk1KN+nLzKasH7kMsROi6vYWmrw8+ufFFbUpvuiK3lsVJhrXDTSk0eCEcUh3PvowSXs1IacphXSQgjLvBDov5M1oKQcqg4sLA7ms/F3OFS2BWWtwwMTYWRJP+UQwSPUBDQvdrtnMcSnTtmaznWNe7U9UBT1Yiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] exfat: Fixes trailer cites f761fcdd289d instead of 46a557694b46
--

commit a1d3dffdfc2b9385cf2e9ba0e7b99bd916f22ffa
Author: Christian Brauner <brauner@kernel.org>

> exfat: keep the volume marked dirty after a shutdown
>
> After a shutdown exfat_write_inode() and exfat_writepages() drop
> whatever is still dirty. But exfat_put_super() and a remount to
> read-only still clear VOLUME_DIRTY through exfat_set_vol_flags() which
> only leaves the boot sector alone on a read-only superblock. So after a
> shutdown with EXFAT_GOING_DOWN_NOSYNC the volume ends up marked clean
> although it may be inconsistent. Leave the boot sector alone after a
> shutdown too.
>
> Fixes: f761fcdd289d ("exfat: Implement sops->shutdown and ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

[Severity: Low]
Should the Fixes tag reference 46a557694b46 ("exfat: do not clear volume
dirty flag during sync") instead?

In f761fcdd289d ("exfat: Implement sops->shutdown and ioctl"),
exfat_clear_volume_dirty() was only called from exfat_sync_fs(), which
returned early on exfat_forced_shutdown(sb).  It was 46a557694b46
("exfat: do not clear volume dirty flag during sync") that removed
exfat_sync_fs() along with its shutdown check and moved the
exfat_clear_volume_dirty() calls into exfat_put_super() and
exfat_reconfigure().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-work-fs-sb=
_rdonly-fixes-v1-0-95a25ce917ad@kernel.org?part=3D2

