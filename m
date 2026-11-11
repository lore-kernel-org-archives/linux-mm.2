Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03306606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hnAJOnka
Received: by kanga.kvack.org (Postfix)
	id 246B56B05CF; Wed, 11 Nov 2026 04:36:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6D16B05D1; Wed, 11 Nov 2026 04:36:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1380F6B05D2; Wed, 11 Nov 2026 04:36:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3F036B05CF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:36:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8249D80243
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:36:35 +0000 (UTC)
X-FDA: 85422333150.11.673C209
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E3829A0009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:36:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hnAJOnka;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389794;
	b=Qng9cdEU3NySkrzi4mYQ81PWM9oLs+ma7HDMHSNX5XSJ7nNYi4JEL1RzvRHaRqrGoken4m
	V+OSawkEzi77lIATk3KiEc1UYSE2n9QAoWY8SpjHXynpR00g4btPYDobCQlcCLtgui1nEw
	GBK0ct4RZGbXttZFhcyq9IOn16c3j50=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hnAJOnka;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJNb3lZ6t5sFOGVn3CCAi04LzEeZdHbIsSE+XUn+En8=;
	b=qi3DV+WXn9aC6IY+/+Mz036ZTZHY9/cuN9QhHlknXNJGjmJYh47DXy5Mur7tACRR56PyFa
	kgXnJ4Sgi1ONY54Dqb9s7LEFI9+uasetrJiHqTLZirEFvNd8Bg0RQ7rgJtNko4kMSpPQWe
	jtP+c4wKr7EJ9cQteZJLgk07eAFfN/c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EB19608FB;
	Wed, 11 Nov 2026 09:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851D61F00A05;
	Wed, 11 Nov 2026 09:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389793;
	bh=LJNb3lZ6t5sFOGVn3CCAi04LzEeZdHbIsSE+XUn+En8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hnAJOnkaTiUIgD29xN8uy/N56NBdY8A0ox3+/FrL5khLxHOW6B2l8W6nLGQl0PrYn
	 YRIvPTe6YF/F3tDZ1iLBZGjGcQRZYlJw5bXJPcMcr4qQhGB4HxcWH9xifBMAN/DXpi
	 QWygDMgiN3z6tAu8U0RscVHXhqpoNah8jj1ZzNOEaeU23RuYUbjC936+XyAQaUulCP
	 ZSxB3xwlGnJ8DdjO6p2DUu/+Hkvccj4/VCaDe1sJf8V2z8QoHYGPeGCbdY4UVTKsk7
	 roysdqQ5a7H/LXUQtnyn7UPieCP10CHPFcxaoYQl/wQsVAGM/0iByy97QqdujK4SQx
	 NdUm0GDBliRRg==
Date: Wed, 11 Nov 2026 10:36:26 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 26/34] gfs2: don't set SB_RDONLY on withdraw
Message-ID: <20261111-sangen-klagen-klonen-331f995b9cdc@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-26-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191245@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191245@kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E3829A0009
X-Stat-Signature: 84rjuk516myz9f96i1sy3xbaj66irzaf
X-Rspam-User: 
X-HE-Tag: 1794389793-706078
X-HE-Meta: U2FsdGVkX19TQqAx9p3B2dQ1J6shwWLfygm173xZyADXqil1MW8xKuSyGgkl6ahftIyfonWgCdfDrcwgedyEfxkgyd1uvbcOzuY4M0f/1bd6smVIylAkM8AUHpJE/rvW+NNxEKrnvtmwkbRsbjtDKoEHPRO+g1y27OZKo+vGe1I63TKL38zizCl3yKCIlscAE8ssnjTAumFOgpqk+fLHkP8Gm3BVlp+BvlukPj7GjvoW98OtafApcyIKo/caKE4FbomMVP+cn6QppyLx8sK7cWp/AFDS6a1UwZC4zOB9JKz3qyJLtgGtGR/VIhD8khEOyLgp3Iyb06PJXGDVu7jIAVsiH1G2H7h8amXXY3Az74Zww/YIxTExT6oUy8fQqUYtff34w4obqm+3wMdV6UFBri73vbgR/D/9R9fqu9c3BEeBE1yXm8IGwqUxKh6wlGt7H2tKV1pPyXhmu1frBtWQ0QFNbwKS+h7cpjtLq5c5cjvhWmVIkqBrDL9kmPA1mJi3zaAr/NlHQWREnK1dn/lZxG4DG9KLveH51cRmpmL/Jb13eLTiUm50aWXQ/Up0/w9pEysOOAl849DVGuyA9NK31VQV4DDuwkNDLf5WZU4Q9JM0gYU1l/7v19Ah+OyXAjB0gTbxFo//zHXjw1Twacd5JFIH0RZAOYTsAAt9T9GBho/2d4ux2KgviDRzqnmafjRhka5oD5BFM3WRv9eYBqbO3+4xOLNeJBtr1PxaLhdAVVgQ7tcUPZZ+DViH3+HUPb+gJRe4WrAVl9urgsZkMT1IJwJGEAmIPCRDcnu9D2CAuqmXYy7zJ1j5I1ab2hs0F2UT5mkR/PgfXYP+eM0MxkKlt1PwCRV86+qWQRhn/z7wZEHtoUdyNKDhPVqU3/fyL99bDu0atBawudIHbu6XRyddzFCr9AGZ+5uKBCauRgCnADswbeALEQZu+mQ8k8J6QdNoTyebKizhgTwULyXmdoE
 +qmSEclY
 SoKEcfdnuXlAyXYTp70jdpTE3aofXNirPSaxr49nzWasc4GA/gTJFXJWyOEkWNrMWndmQpbIzgqlJfkxoXt+ZVSNgOgPQEFsW62GyqWsV48NXR/ULe06SNW/JmuD6c+47oX8e6zMMm3K6wyOupSLITHZL+w8iGnJMKod/ZV2MNlfO2Z9rb+rsOUAQOAUKffJVpuyvejSvbbGMCbvwqIOONkR64LcYpLLWVzzz73nwS17st3zRZ+WBDcLWdTl9y2hS+mqTt89xVkKXqVDuo0KfvlBTMu8ihQkKcWBoShBtMjH3xiWmxsMJiTchBENCi1OsfzGFsbug49r5I6hPId4qDsjDJCqUjveoDDR8kDBwqGfR2uiknDUDOVuaGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 04:10:10PM +0000, sashiko-bot@kernel.org wrote:
> which submits writes for those dirty resource group buffers to the block
> device without reaching gfs2_write_inode(). Should gfs2_aspace_writepages()
> also check gfs2_withdrawn(sdp)?

No. sd_inode comes from new_inode() and is never hashed so
__mark_inode_dirty() never puts it on a writeback list.
sync_filesystem() doesn't write it back.

> If a freeze is triggered via freeze_store() in fs/gfs2/sys.c or
> gfs2_freeze_func() in fs/gfs2/super.c (which call VFS freeze_super()
> directly rather than gfs2_freeze_super()), or if a withdraw completes during
> the msleep(1000) retry loop in gfs2_freeze_super() after the initial
> gfs2_withdrawn(sdp) check above, won't freeze_super() succeed on the
> withdrawn filesystem and leave s_writers locked? Should gfs2_freeze_fs()
> check gfs2_withdrawn(sdp) outside the SDF_JOURNAL_LIVE check?

freeze_super() succeeded on a withdrawn filesystem before as well via
the read-only shortcut. Now it takes s_writers and thaw_super()
releases them again because SB_RDONLY doesn't change in between. That's
the point of the patch. A withdraw during the retry loop makes
gfs2_lock_fs_check_clean() fail and the freeze is undone.

> When gfs2_lock_fs_check_clean(sdp) fails in gfs2_freeze_super(), doesn't
> calling gfs2_do_thaw() below re-initialize sdp->sd_freeze_gh while it is
> already queued and holding sdp->sd_freeze_gl in LM_ST_SHARED mode?

Pre-existing.

