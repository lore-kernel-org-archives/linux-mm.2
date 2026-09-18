Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE43C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5736B008A; Fri, 18 Sep 2026 16:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576056B00AF; Fri, 18 Sep 2026 16:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C2E6B00B0; Fri, 18 Sep 2026 16:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24AB76B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:09:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9256A62BB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:09:14 +0000 (UTC)
X-FDA: 85227972228.01.652A2F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 31A441A0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:09:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/Mldq4h";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762153;
	b=V7njwryxfmrD8ZeRNs1BpbLttbbwfDu5ErjoPGoOdCs8ZQeQPJLuXASdWQmrsO0Y0yE3Ua
	Wb3Hfmt8dEt+0Q7A2nqm4+yHkrjBre+vlDT73PYDrUpIj30FuEeHqs5J9FRJM70jS+OCzM
	+J+Ry0KA+G6Uo5PR3te9d0D16UslLGs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/Mldq4h";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762153;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0mvUweI6LVBPNQEepHdBFnrekjGsiPZ/QHwECl64qEQ=;
	b=u0fLvK1PFqb03nGbkvNbG3v7/TjgR3xluTVU8xmpR6sema9HGWkjV2PnwmSKvsU+xOF9K+
	F9VjJfhVPESIGoJfYt7Amm3ha3c1BDG2twP9IIAMl7C4h3KMW6Q3DcyBtlEgJikTj083mt
	KogADHQoO16Hy2L/KgferO16HxRCQ0g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D67B436D7;
	Fri, 18 Sep 2026 20:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6EF1F000FF;
	Fri, 18 Sep 2026 20:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762152;
	bh=0mvUweI6LVBPNQEepHdBFnrekjGsiPZ/QHwECl64qEQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W/Mldq4h5/cLD2pUa/DgWkA03MpbXuZlIHxIkDytYVQJvjTbENm4nRXEc2+CCx+jo
	 1s4arjt9Cp3O9MoLeNhbtEUa6eq7dwLCpSC9Yv+T5muc9iJ2B1RgizBY0qnVFKZvdj
	 +Lll49pXmPatXIM6AFUnuX8vioCs5z57nmEJqmgQqHCuVUapf5rJmFno7H5Zbw1qHU
	 Uy0dWh7vbhPCydklKF/HpuCSYphNIVTt+rFhs/V/nwugrKKSwOYizAtJxCs1m1jAmn
	 9ZJ21/mUBza39FWbEI0wegy/PYVXdjOPs6uoudIfnZLf6NU1MV1iLGErpeikW+lDLP
	 F80I/03u8yrgw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 04/13] PCI: liveupdate: Document driver binding
 responsibilities
Reply-To: sashiko-reviews@lists.linux.dev
To: linux-mm@kvack.org, "David Matlack" <dmatlack@google.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kexec@lists.infradead.org, "Randy Dunlap" <rdunlap@infradead.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Saeed Mahameed" <saeedm@nvidia.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Pranjal Shrivastava" <praan@google.com>, "Alexander
 Graf" <graf@amazon.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Mike
 Rapoport" <rppt@kernel.org>, "William Tu" <witu@nvidia.com>, "Adithya
 Jayachandran" <ajayachandra@nvidia.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Jason Gunthorpe" <jgg@nvidia.com>, "Alex
 Williamson" <alex@shazbot.org>, "Parav Pandit" <parav@nvidia.com>, "David
 Rientjes" <rientjes@google.com>, "Vipin Sharma" <vipinsh@google.com>, "Yi
 Liu" <yi.l.liu@intel.com>, "Chris Li" <chrisl@kernel.org>, "Leon Romanovsky" <leonro@nvidia.com>, "Josh
 Hilke" <jrhilke@google.com>, "Pratyush Yadav" <pratyush@kernel.org>, linux-pci@vger.kernel.org, "Bjorn
 Helgaas" <bhelgaas@google.com>, "Lukas Wunner" <lukas@wunner.de>
In-Reply-To: <20260918200640.887030-5-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-5-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 20:09:10 +0000
Message-Id: <20260918200910.DC6EF1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 31A441A0002
X-Stat-Signature: aawnx83cgiwgsdzqw6e6ymu3j3ay4xfj
X-HE-Tag: 1789762153-522391
X-HE-Meta: U2FsdGVkX1+J+7Qh2y31Iu/xMMqYCkuSPtPSVsJFmhMa2U3wt9uGJ4cbthD+d9kwXFizvD2W0ZOR94NAbWvSBjNvPHHzQ4HToye5T04WoBcNAP/mpWxQ4beFwgms3iczXexN7ilyQasEIG7x6zj0rHCHvqblcH35cERr9dKilKs+/5n+zJ+KnOTUDW3soBBnsyHLhf0Y1ePwS5NI9Wkn9wx/eM7mT74y5erdDaMvJmeMK9aJwUu4TWryUYakdOdS17ABI/dviaFkucx8ZDvfB4r9da1rqQQwh145EWIWxy+1eQ/EzxWof+XrwXjmsDfOc7dhhNxTb7nFQmKJ/0mvN8dnyj6Oss2dwkq3GDj8FOvxscHfWysXji9wAA0reWqQg+LUheg3sbZe2COzcOIOdDgFrTbp8xD4eIjCxQgogeaP3TLphNFHXxIy5x/qBqfwtDNcY7+L4tFXBO3vo1MKDxvl905MEE1eD+BPmFvqx6Bu8Apbn7nGGAJL5kkc6Hpu7aeVnHjDzHVEj8IWLQiyBKvEriDCBBQnH0K4E4Glo90LXwF+SwaaaYCNUUnojhMvoXbxqk2echrzjqYHlEDaZsIa64CAAi/F4KKX2NbDpGEjfKMVweawNiDMaosxAZGeDEPbK8OmVdX0ovbaZIzC/yVYBZavYFv30IqNBsqJtFQ6RqqhggzGlCx7MGNOzg5DPdyV3zVeR9iv0RK2hTAK444ERJ3Gk+UgjW7kQ7OykGIPEZk7Fz5yewSQbMh0uskO48vAf9eK6KP/sOYQJgSOrg1eOdDXTeNDgq3bdMjIrpoFFW/H8DCXxQoTgEcIOlRE3UxzqGkgGYXlySgnkIfuJAVfvvyMQrVHYWaif5HNyghar7VPxunOt8ZeBSky8wIzC/Ga0AsEW7FoZzd/RSjnH60eCcIt90/D0OwTkiFfn5HVgKZe2knLQxm60QIbSVr9XJ57t+vH1dmOmTnfXZd
 1CPdEDrL
 YgpspZNKjtCiKe+9VfATfdrv1QNuFlsgXr95VxP7em1B4lPUoIfQkKaGIOFyBHcUNj9XK/2rKvdNDMgD97m0veA8dR97jk5ekAdb6O4fnrhDKmxCUb8DtsfjjGHpp3v9x27A6OlyFrRnc4Lt7Rq1DnfAktcAfHmJSr5qUJXh9bIoYM/NHHIf+eIvHJCzVNWf9ZoEmCV42to38EU7i29m75UB1K4OnibZiPZZmbQDlkgkM9HxtHueTwGv8vJ8HRlJWh/rr954Jn/hacf5Ea3F+nepg6ahHKFqGGDP/3tbBXeDi9fQg4jvWe3O/Y83JpB/qe59eWd4U4GM5XbBhsaFrRX06t7GqGMOOD5gm1C9jIMy+UxPNbrenMysF4jj9rV/4aJWry4nI34dKKn93AvuasKv4pZ6DV3yq1QaYVN5SQRn+XepIN0FzXuq8TdhQbBwU4BmmvFvIkYV5zZNmklN7WoBOj7isHGeUe6ymEW+tCU2KhGYklEglCE7IESCnErb7iYREP1bh6qx5om/7l+QVfNHfKo7954Gpmq+dqkL71WTwG25sp6Z6D/xBOiHE+SGM0Xmo16C60SbG09DzycIwEKK2qcvw92RPBo8rWP6w4Jx5l/Bow6dUfh6imvf/qFeKOjP1O75bRssZhdyzaoIBOsS9Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Document how driver binding works during a Live Update and what the PCI
> core expects of drivers and users. Note that this is only a description
> of the current division of responsibilities. These can change in the
> future if we decide.
>=20
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918200640.8870=
30-1-dmatlack@google.com?part=3D4


