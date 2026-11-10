Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386F6606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OEG0XvHL
Received: by kanga.kvack.org (Postfix)
	id DFA776B05C4; Tue, 10 Nov 2026 00:58:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCB436B05CB; Tue, 10 Nov 2026 00:58:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9E86B05CC; Tue, 10 Nov 2026 00:58:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AAE076B05C4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:58:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4677FA08E4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:06 +0000 (UTC)
X-FDA: 85418153772.21.3F6917E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id AD4A11A0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OEG0XvHL;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794290284;
	b=5g2UAdYgBaWHQAwJdfXG7Zn5U7XLny7/k4bxtxGMJ/DWs9qnm6lbo1Rj49X0Pgt7NeE5d9
	7sPS4On8yoeGhup5gpWq2swJ5Q/F+jQLmcuUTlKQxDuBQQmDDhenuRSTWrllWE1jODVJOc
	uCARTYSMAW83Y4ew8K6Zb5H4vpvd4H8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OEG0XvHL;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794290284;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbYzdrnzzIoTF6klOJuhwjCo4xeNklc3rzjESHYyhtM=;
	b=UGd9JH2Gi25I2qW39bvG0VWyEluYZSouNM9JfZQTR6NVkPhwMeIISt3UUjPhpSQQGts+7q
	AZeSauOilki90FlliE6LW5t6ZtK6LCFtigIu/Nu5ihIyV5ulHCl7mH19PwCJowb46agfsh
	vuaDeVbNTLOLfhdG1lpFeq7nI2p4Lkk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B70361CE9;
	Tue, 10 Nov 2026 05:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D5B1F0089F;
	Tue, 10 Nov 2026 05:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794290284;
	bh=WbYzdrnzzIoTF6klOJuhwjCo4xeNklc3rzjESHYyhtM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OEG0XvHLa5w/b3Ea4AxYP1T88+5eKeW34uHUGo630Ycj+F6mADSQPqzCLKt/Xx65S
	 gfBpWz6G+F22Wyi5LBmxN7FD87FPaFI1QmRQGx4E2Tkb1p7QySb2TNWCjCJpmXHWEe
	 SrJ9pWcD+BICF6UzxClqIZkItl1ofjUwvrDI8cjSvoZpCIUixS2uwYJnzkVg6lvQ+b
	 Pe0oBqN1lI1dHQtB9yrIBMa4V30vXUQZFRHdDzZG5dk2cEzboYejCcVKh58Ucx2PNP
	 A2TTW6r4OOsVTfPAMcfe6BIKwt59n2OmU2Z9zvzNp2oZjlFyBu635OwBEXBZZAY5Iv
	 joa2pH4XQYrcA==
Message-ID: <sashiko-outbox-206371@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 12/19] mm, swap: let swapoff destroy xswap devices by
 name
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, corbet@lwn.net, hannes@cmpxchg.org, chengming.zhou@linux.dev, kunwu.chan@gmail.com, klarasmodin@gmail.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261109055455.536925-13-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
 <20261109055455.536925-13-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:58:02 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AD4A11A0006
X-Stat-Signature: 9btzit333nmgpzsaeonnjkyrabf6h3xp
X-Rspam-User: 
X-HE-Tag: 1794290284-830735
X-HE-Meta: U2FsdGVkX19iU3ztpPjd4BjwXdD1QfzEIHjtquSFhdw0yQv8/JhSXqcplBk2v2HdfaLszM7k99sEPngAbem/09nTKC1xLg2zn6oza5Q3fk++FgagcAMb3eGmFcejSJmG57SlMEXpkdNW69BOPL7gfPM3D6hBiJdHRt5EmINuLpiU1iIEUZL3PsYbShoB2L/BRz4ZSlXA96CBVXZfbijxSi1pqkw+s24Axb9lU4X3Exjg1UpnpBlSB6owOkOuK3FpZvBXZVhKB0wvOZqEgc7E7uMmwXWCz9zGIsOjBGKZbK4Qd62CKKNr9DIHzNiwg21FxRfFXMo13ZX1eANHVhrzTBjvhXYJ9VUO8G4eQXuiEkU9OFhRauku2X8XrqnwiFqbfePNkUpyvQI4DTAdL7ovEzmnlqigEoTnALM+kMMekNjTWD6TLIdZYmVS/31nc383r7HuYrkKxI1r1Y9SYZAl5hQMo1Nzub/m5LrloH/FNui6nB+QtHWpMF9QtCeaIVak6VLGeiHwS+A258+4xIHu3RPUHrbwmCHyxQJlo4RGzGFOODr8kucY6Ms579dXNy6hs+52yCIvzjsnOm2BO98ijDX05+mul5kb4EC6LByWEWDQxTgxlL6IVv+H7AWjiJizD6cC/R+TtQ7LDvV1xRear8lbDRudDZM74yoWImGKQmdDGEKojAk1LG2J4lQJKdj0av849fedUBx4YF/RPLUKue7ULhy+QtdH8UqozAJTRzxwet1uUUsB84OC5/CbGT9DcdTscRVdy2rXqLKimBc8HgPobFBr3qeLJHCA4XHehPNPSboWTwLX8SD+qqfTC9iIOck1+YAz7GghWDVgbkq5Dd5mEs/isvXQE0FEyz3gx8vWxQm8E0hxHIwtsUmkXFo9xIxiT+OGSHFlHp2f/Knv8T3vRzx3TvnfLC4Blsx8N6ZYVKVbFYN7PRQrDDMvWUXbBYUdHKpfzWe6qztuecM
 VAxGE9g9
 XkOJaA3Krsna+4mCrRbNz0bnV7i61Un1ZtE6l+mMwaWyaZtXmfWyv/SYnZ1avAOpZJ2DWRzAU3itPYZCfsVNj2r6Ii3x4S1qVZ4I+YkTDPK1fcU8SAzsILgL2knlV8xYSKqMRjje3Ds3kwmLPlgq8oMa8fMFXCTwgsi14JKYiGViQCIb0Cj+unCG8PD+rNxYgTDN0jvRcWhnoOiypNF0u0VHM1+Zmo4wHdgC2G3D9n9GlFK6wKSWt4RYdlvkENbrKcqkN8SslqvUmNw8q3y3BS6f5pyFuFz/Z88udSYmxV9Ca93CP2WD+Vrc/sWkJBsX++aN+VqsuhpSeEOT6hiQMwiS4eMvrwCIyU291SavKU/zH/YxcN9z2uF1NBmnyt1HBtuqkVOSkuqiWFeJUl0KDzDqB+AxCAZnWKfYD5dcCcvqm2QsKW/S9tWEdDAbxNXHQcgnaenOfnrwlskOJDvcOxufg1pv+/MWM2GtBhZNzKCckzVdxbtQ7q+hqns4DRMEOoTRpRp+Tx04jDWE4Oo+6nE1IWdfQW/ZAjrcDOJ/V7unPRGl5UO1MVnP8a5hMMXaipojOQ8rHiRuqbAcJ7kh5EjHgG9qaqqDpBaBzv6aSWmDXlP5/zBpXN/9pX8yu6fxebrnCuITrbIB9iPU=
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
- [High] mm, swap: ERR_PTR(-ENOENT) dereference in sys_swapoff() on
  empty path
--

commit ae71026877d501dba7d03d0b98df83479aa3a6b8
Author: Baoquan He <hebaoquan@kylinos.cn>

mm, swap: let swapoff destroy xswap devices by name

This commit teaches swapoff() to fall back to destroying an xswap device
when file_open_name() fails with -ENOENT and the name matches
"xswap<digits>".

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index cb53f9415de8f..7b1d16226b7bb 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -3513,8 +3520,21 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spec=
ialfile)
> =20
>  	CLASS(filename, pathname)(specialfile);
>  	victim =3D file_open_name(pathname, O_RDWR|O_LARGEFILE, 0);
> -	if (IS_ERR(victim))
> -		return PTR_ERR(victim);
> +	if (IS_ERR(victim)) {
> +		/*
> +		 * An xswap device has no file, so /proc/swaps shows a name
> +		 * that cannot be opened. Accept it here so swapoff -a works.
> +		 * Only a missing name is taken for a device; a real file or
> +		 * directory that failed for another reason must not match.
> +		 */
> +		if (PTR_ERR(victim) !=3D -ENOENT)
> +			return PTR_ERR(victim);
> +
> +		err =3D xswap_destroy_by_name(pathname->name);

[Severity: High]
Can this dereference an error pointer in pathname->name when specialfile
is an empty string?

When specialfile is "", getname() returns ERR_PTR(-ENOENT) in pathname,
and file_open_name() -> do_file_open() returns ERR_CAST(pathname) in
victim.  Because PTR_ERR(victim) is -ENOENT, swapoff() then evaluates
pathname->name without checking IS_ERR(pathname) and faults on
ERR_PTR(-ENOENT).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109055455.5369=
25-1-baoquan.he@linux.dev?part=3D12

