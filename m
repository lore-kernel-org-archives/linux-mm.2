Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B1BCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 22:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88C86B0005; Fri, 15 May 2026 18:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5F746B008A; Fri, 15 May 2026 18:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D1B6B008C; Fri, 15 May 2026 18:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D1476B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:12:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46157C13DF
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:12:46 +0000 (UTC)
X-FDA: 84771054732.26.DC3D122
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4891A4000D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:12:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tv+IRzby;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778883164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mb2Px+VFI1la/B1T8HdQLAoDo+pi65QwRBrBz9J8j3A=;
	b=iYhHgqV7jsTK+26H0itzleEOveDcLs62k4CYcYZ7vDz3+IZs/Fqb0/KcMkNp2a8uXupmMo
	Z5a8Z4nyiL0Cf764fAf0tWoAJYVpWr3mrDz+WH8nT4R+X0SwxVUPe8PUy8OC3sq4Jg0kcq
	xl4HVFKnRVsyL6Y43+zIShdwkTDoEB8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tv+IRzby;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778883164; a=rsa-sha256;
	cv=none;
	b=KJhHgjRsoJePbkTaQIeDsVay9jFGINd/7pYfXdzXmrVcDtefPwp4rqTX103006nkERe3cu
	SqtK8CFttqzBPBNXnfZBi7kHwN55eVMyjxG2gwtQn+kmtBtlU76Uh0Jyec57rKGhwsl1cH
	Ab2fg11P/ECIq+tfAr6YS3VOSAdY5JY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3402F4417A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD656C2BD04
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778883162;
	bh=Xo9RN/YaHlAbWe60yDn3HcJADUDb6frVOkoaJStZf5s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tv+IRzby0Wc1y1AfRAfBW3nKPJfKGSdDUKMAC83W6JZ/dYSjgCeuFvnvRb+k2fDWh
	 xbo5tF45ctQN2+lUP3uiBUSdgPOAi+Wx+0tkvg+4pJup5eskAOQTJlwp6phqJcshLI
	 zwma6B6kmV2AJ2QU39YgSPGY+7u3MZcxTeE3mLdPCH/vhNyTGPwjMe4zxLH36reM8B
	 Aer/b8HC7tlHs6JLUSTc8CC6m60eU8oVJuXGFC3sjcHNI2tTjQrIJ4E+efJOd+l39W
	 8dpKuDtdYrLdKdfWZ3TWstbmXaMPftJx2DJhHT9Ud2qtgOsF/sPz15MPQ/jP7lSeCE
	 kkkwEGkOg5Eqg==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-65dead17c24so645651d50.2
        for <linux-mm@kvack.org>; Fri, 15 May 2026 15:12:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ94uD3KNaAdKzAe8CrX7bmMA8LC6ZAHFW/EHQtDrmdrBEvnBbth/b7cHj8knqXPwefeCwPBg1S7Ew==@kvack.org
X-Gm-Message-State: AOJu0Yy/aOk9Yz9IV6Dgy+3XfWrd5/rUOQ1AvW9aYq+TfxvkvEh7zEUM
	YIqpz7u/CVIMCTvrWlSMy9mmTKmR90jd01Ukafx9OZWdQ+qsT6i3rI0FgK4kVRNmCYdlzDPpcsW
	VR/NGGQDT57Jc7E6nXmZgSxTJpPOVNV+DqUv3qn/mpw==
X-Received: by 2002:a05:690e:14c4:b0:64e:f106:60ea with SMTP id
 956f58d0204a3-65e22807f82mr6158139d50.44.1778883162092; Fri, 15 May 2026
 15:12:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-10-hch@lst.de>
In-Reply-To: <20260512053625.2950900-10-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:12:31 -0700
X-Gmail-Original-Message-ID: <CACePvbVPV55SgPmivqMX+bP8H7FKcSAbWCwAe5icgZjZV9vUNA@mail.gmail.com>
X-Gm-Features: AVHnY4LtC3KSyPNEsLh1ud1t2IOob9XfSBaYZO4ouG71LQM8qOS5lvZuuzrl4N0
Message-ID: <CACePvbVPV55SgPmivqMX+bP8H7FKcSAbWCwAe5icgZjZV9vUNA@mail.gmail.com>
Subject: Re: [PATCH 09/12] swap: push down setting sis->bdev into ->swap_activate
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fw1sugud7ehzoyg4qsubweb15tr358tt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4891A4000D
X-Rspam-User: 
X-HE-Tag: 1778883164-289185
X-HE-Meta: U2FsdGVkX19vwBmXp6IDcxaKKz0bBe60TZt/RLY9Y+Nmz/QA/Kcx/PNSFfA1VhY9TebzKyVRe1ayNvM9PhnLLwT32Bb80fafpOSbBxQdu346Rjb6K7H1n+otJbHyH6JqrPcAR7dalG69rOInypt/bSlodKkdj0My0I6aZ068GioSRhLuue2vljEmhx1kMgJAe/onhN0ILFWtKNS8s0LJpIF2krwN//VwJvD5yw77fzPz+ESWuR/5k79waYA3xDPXHbu24u/rFSbojbi/oMt3BeUjBYIlf9JS/3gGZ1acq9fmQaiIPFgiVOY6stGHBQkPJibL4B42QNVvDbuSOx4BwTZucsnTtX8iQOMQAowPY3+bv0Ly5tfolZ5GEUFV37xElz87qUvl1aGzRdjuQWH2nj/jVy2nhfOjjQIC0AYtiwXme6hBrqjFnRrc+wuFuGzU1JMojM1ssxHSvt10WTJ9vBDo1Y+6CLlqxzG3nPIMiKpdDLvjhbMz+ddXUdSDdB9rKqJpYJpwFd21S8WCYVnHxEqEDjamVPTKBH/JgpKfj+bAQJqV4qAU/L7SvGD3UjdzzOCVyGf1PcUrEuMe0ijICbKxEZZmvIXAPCuquBuqITJ1lveWtlNQgD7AOwR3QV42J3ThoGs58RkwtSwvCVhV50Z5t0ejJjseoFjI1liJvmXTFYWZnHdCiAU6i3Mw6umw3yu+HgNgLdA4IL7VjQZqTzMddqRgOIQlOZjlAo52c6bRkR0D/8U5Jbi8PlcYFaBe5WtuLPMrT3rC4xdhG58H8jv/zp48g1jSTujCeyWj4IGrvbi/mIB58hByeStyY/VIEDKxMwVX0f310hmnkUza4JSQuBFLNNBiJEi3wM/da8M5RBTVIminkEAz35RoWsjX8d7FW50WAVN8PQOtXqUpY3sXeCt2C7ab493YruDKxzf/1kqB8VR6cfsobr+izo0e0rID54bYgAqMG5nOrEP
 zmMlZ/GO
 wyOu/xUmMxBxMBLH1G+RQy5KHLmFjeKDtdNsRHe84Up2KdjxOU+yJlCsxa+HIUgv1NvT1Sbjc5ymswZt9LpJDiaxT2XctbpdVVuuE9MctvkbfIJiP7y7GdcTAUXxf0EE4u2sOdypUt3ulxHG2InLnxBC9GYywBnWXmxtWTXS/KES2wCpZb6NLWtZIzzS8P5IyA7/fKoOHaxxmbt0ubT3DRSHxgJRPruI8TwoLwzh3DaowtQfrd5HfN173BM1czAmYs1IrFIvViUONqyDx0HRE0D7lltjKNOuub2xTsU/Lc1erpDlaqtJZiyWAaTZ/oWpPPHF8pEltZsQppOD/nalsgo00POwmsexyIxQRswI7RsGoVP/r4CgAFHxQ6iiqO4BgoIfJ7eW4ig15oUwDqrYAYzSkp1nFcPy4UOKArDk7skkQV/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:37=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Only the file operation method knows what block device we'll swap
> to.  So move down setting sis->bdev and the special blockdev flag
> into ->swap_activate.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>


The core swap part of the code looks fine to me, I did not look much
deeper into the fs side.

Ack-by: Chris Li <chrisl@kernel.org>

Chris

