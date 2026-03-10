Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E39FD2D6A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 12:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8DF56B00F6; Tue, 10 Mar 2026 08:28:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65BB6B00F7; Tue, 10 Mar 2026 08:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B5E6B00F9; Tue, 10 Mar 2026 08:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 966956B00F6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:28:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46E311BF8A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:28:37 +0000 (UTC)
X-FDA: 84530081874.22.AF135FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7CF918001D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:28:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FOutLnoL;
	spf=pass (imf30.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773145715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYE/HV7EYizpiAYX6Lz6xzxADa1AFKYBU1J/zOcqJyk=;
	b=Kyj+UjAjrZL4zHc1BGJlXj5WRItvhsyY0IpVvHxrkgj2bwhR2G6C9YuYaFyQBo39lD5YSi
	Sp1Ysj7Vl48q9Esok45tLauYr41z6sgCDC3fbekluPFS+zc1KVSo68VG33HMB4JY/3CiCT
	X01VQRzh0pKTePNFwXTcoT3m1pcTxDc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773145715; a=rsa-sha256;
	cv=none;
	b=SlZEKfmi9GHpFIK4oTlUqjFwobRG3ufcO3puC+0BjFfbT4kxaSX7XnEUbjhMSEXtcxHJEq
	xjvmbb9LOQFD2Fj+eAqK5fRY3f+lcRN12lAT3otgax8ONogXtaZBPklrdpij7Mc+6x3q6p
	/C2M3ZnBIxlA5YuJrxz1SbB7ZUH+PYw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FOutLnoL;
	spf=pass (imf30.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 337BD43449;
	Tue, 10 Mar 2026 12:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8179C19423;
	Tue, 10 Mar 2026 12:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773145714;
	bh=NZ5oTCN6VGzePwnu776uK+3unhTqb8pwokxv1IJtK7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FOutLnoL/seeB/icY17T5kE23weT+c8OWPxsN1CuLtbqZf1qO8twCXpCHPEW4zEb5
	 uM5pcZxBh8XK3wQOjz6gQLnb8DbNMsJ6SwgjqzPaDdyeQRMdzDiadj+7d8CVSVSbbp
	 WbSnGZkMbwo0cpPlViR1A0oh5e53oFE0sYAJxulW9oCNKaXKAhhACMzXx6XsRo3Hlx
	 /XgKdmLcz/EtWl6VZEOUGY5PBqGn3Xb4X+aqLL+l2HoSL3wZMd6NhcSGeVt+ZFpBkn
	 8s7ZymgPrZjLjSz7/xRlCoCIsHrVCduE0eaA6Z9IamuK4ZW4bnyThB9ZhLWcSUucoJ
	 BJsDSXl6ZXWkQ==
Date: Tue, 10 Mar 2026 12:28:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH 18/61] sound: Prefer IS_ERR_OR_NULL over manual NULL check
Message-ID: <19aa26fc-8570-492e-8e17-23d6950676f0@sirena.org.uk>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-18-bd63b656022d@avm.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7JjDB+7CEHk89uTh"
Content-Disposition: inline
In-Reply-To: <20260310-b4-is_err_or_null-v1-18-bd63b656022d@avm.de>
X-Cookie: A fool and his honey are soon parted.
X-Stat-Signature: 3xiitcs3rzpda8goq9ccghmaa8677qa4
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CF918001D
X-Rspamd-Server: rspam12
X-HE-Tag: 1773145715-968138
X-HE-Meta: U2FsdGVkX18oGcYNHp/6vh+7FSiGkTJx2+ZFtGpHZWhy3SVjFzs0v14l8iLSo0JZeKRFUzvbxVC0HS/nX3qVtgkSmo0YfMhpizJ9jr478yEzRcj6cpmCwA3E1HGSvPDwajCayE329Ye9RdrfSFjpY75F63Hv8XYk+ZPVbuSnCqNwi1SuNVejuMv9ebvvAnQLlaxBHcnuDEy5KHPNCpXVI+gCS1GtClQq3lqb4VLWRHZj0aDbI4Uypw42iXOwX4Yty7ELJi60kwbGm2mExcaL+H4v0q8kisigDbzNsREMD2Gihq8VThOVUhGjYmmJMDYCkGFj2etRElWHfP/4E8I9b6kyelUWMr2OTE8BgwBOlP/U8hQC+CEW71AU7zMzKHh4q7axh8qGnkT0a6YUVZISX6bFpQwJ+IuR1DXwtf81SuCgNObDG/4+eQXg24FQfO8oJtkNz/hKWRyRCf35PExOb9uSi3SmB8warDn+V31+HfcuK4zMlEGWGeQgqMY0+137663mFsr8VjTAH68Wbz4v22B9yMyKYeWek0WAhy2IeT59Q25/VkxT40HvxkFzpeKQeTD7AlUEaOgXIyG0zUzlLaLMn67OKXaSfQtJLybtQYmmkVf7MuNKFbrFcdVLMar/HLNHhB7an4u92JhZJEZSALvB2j+McP00ifczk+gu6ds2kf7l144oIKLvNAt28Sz5FQbiGn0i32wdXF8GDwuHXS3rR2pBstYJinmXA24Vl9HdjdFcdRcSCAWCIbBRM2HxO1zemV6ae9tOLJcm5Ytfsc5/3DhykpS7F1KOTlVIy1YI3cZVm6sZgkc17tdmr5zHSIU8lAInKJBuvvYzkr7fpm/D7aJQy1EJkkpMAUwkY7UkDuAk/0/L57J71fMfdYC+PvoIddr0o5wgGsmZn5pR01I1oKe+vraEim/wcg6gpDQ9Yy/G8o2bLZJKKrcAiT1kTsBxSRpvzOB5GzCTLew
 1nFtNJIc
 nZM+yy9AA1mdqP4euPFwdrCJMen4dRtFrzVnkny+y+Es7WD9AFELM1vSgjOCfG3c9bw2tfDDLMZGC7erORq4vHP2KAtVqc1LhS1r+Kx7oCTgMcbvK6jBxt/1R3yrtO7PyAjg+kh0okM/CioPKz/aEt0AI6IVw77rwXBI/wuPcRotrNBWIuWJEDRbfEgSlOZK6YhiqOE26iBtfmyeQL2e4dCUfN0w3NuyWpKwmp+0t1fcZ2e474vnRjfO4Itv/m4sG411xVNrDq+lOP2Hfds2hp10nIJtulFBAIc7lv3ymWghXr4cWCZHIiOkb3hrUMGNFn7X+OzEpskIm0K94VYXRrgea/QkctibmbPQ5cN0GvWpA2ETdQNLJBc9UgaGvsNhe4UrOBMRlXx1sSmmHrYYxRgUzPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--7JjDB+7CEHk89uTh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 10, 2026 at 12:48:44PM +0100, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.

I can't tell what the dependency story is here, it looks like there's
none?  If that's the case you shouldn't send things as a single series,
send separate patches to the various subsystems.

Please submit patches using subject lines reflecting the style for the
subsystem, this makes it easier for people to identify relevant patches.
Look at what existing commits in the area you're changing are doing and
make sure your subject lines visually resemble what they're doing.
There's no need to resubmit to fix this alone.

--7JjDB+7CEHk89uTh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmwDmMACgkQJNaLcl1U
h9D4VAf/VCpoXjivQsq8mL1i6sHdID6byBqwG7egrwiRCrsZav80JlvY/F+1fWQl
Fe3Ct+yRv1pWeNy67wSCZD3mtHtNH0JpwRTNxS1XQrnXc7CLjzKunCldDfzTbfom
+QmXWHQB3Qo9ie1ugoAGet9gx/vkV0z+cv9sVHg1o1R7/AKqfgov7xnuP9Hlv9Uk
p1pkMya/NhbXBsrh+BFbktLgp+7sAOMjWgtGZ3NfHzwju9n4Jdbl1JcPxgDl0SHp
6z8kP2+oskOspesqLWw62mZF+bN32Ycjt1N7/EFjtPBdJKIcQJLICoACzxyQBZYg
+i50s/oSRL1HiP4US2lxoy8BqxaqrQ==
=U6jW
-----END PGP SIGNATURE-----

--7JjDB+7CEHk89uTh--

