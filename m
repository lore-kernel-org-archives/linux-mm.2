Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F98BC982DF
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CAA46B00A5; Fri, 18 Sep 2026 16:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2946B00B0; Fri, 18 Sep 2026 16:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690FB6B00B1; Fri, 18 Sep 2026 16:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7966B00A5
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:14:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3B49807C2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:14:27 +0000 (UTC)
X-FDA: 85227985374.22.A4D2C5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3C9B11C0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:14:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c1K9Juxo;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762466;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUX1CMYSfd1cCzY+rZLKpCj1B/a7Nm8BOcFnIwzacKA=;
	b=6UyyzYtHBXBhTlmxJ/ce/FELrFFLLezUWUCLpugLxbVscpIb7lICklTSZNeJ+z2B6B465N
	R7zmu5fUXDEeKiZLDpSLBtCGYcuvjmakYh2pgcYxXsxjTVFJsJB9EA7OTRIV8qTPbyy71n
	iS529EO0tFDVQYsR4suPPumk3OAWqTQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762466;
	b=bsjzfWW0dZnlDBwPLjT3o/z5eGBaXAigQ9KCmlGloYjOx509e+HGwh1L1xlbs03Y3uZaYb
	yQht8QoWD/Svt3AdxEkd2x5/Lw3/weLpShzxg/o2NruiphRCLcN7P+jJ57Jx0H4Tn5CJUv
	JEgkOEaSa4aiIBH1DZTCdrWcMIS829M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c1K9Juxo;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD628602CC;
	Fri, 18 Sep 2026 20:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EBD1F00898;
	Fri, 18 Sep 2026 20:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762465;
	bh=fUX1CMYSfd1cCzY+rZLKpCj1B/a7Nm8BOcFnIwzacKA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c1K9JuxoIpd0ybPcfa6kWD3z1AEnt7uah5WM781MT65U7w3mGH1TkBNhFdNZ9WXOh
	 u/uCw2YcDD7rWhPfRaPzF1f+7/RHUmkx8mpTbHwUEjxXqM81pAvR8O2S2gOvqywOQO
	 FWvY2hCiZcx1j0t1FQU4VF9shWKsBGbF/DNyGxLVjy6e9E6Wmo69vBFEijiO1lE8J6
	 V2oxC45PLi9hOwYS1uVguivaABUjbrNvSZ84D3HlEADtZgW8CA8HbniVzsALfWIYBE
	 wzbiLZAU4WpZa6wwdHt+L3f4lsoucD79w3I5cmeKiF/xx+9pU6VLVlBAPJL/gIn0Zv
	 SLB4jTZYVNvyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 05/13] PCI: liveupdate: Auto-preserve upstream
 bridges across Live Update
Reply-To: sashiko-reviews@lists.linux.dev
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, "David
 Matlack" <dmatlack@google.com>
Cc: "Adithya Jayachandran" <ajayachandra@nvidia.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, kexec@lists.infradead.org, "Alex
 Williamson" <alex@shazbot.org>, "Saeed Mahameed" <saeedm@nvidia.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Yi
 Liu" <yi.l.liu@intel.com>, "Jason Gunthorpe" <jgg@nvidia.com>, "Alexander
 Graf" <graf@amazon.com>, "David Rientjes" <rientjes@google.com>, "Chris Li" <chrisl@kernel.org>, "Pranjal
 Shrivastava" <praan@google.com>, "William Tu" <witu@nvidia.com>, "Vipin
 Sharma" <vipinsh@google.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, "Jonathan Corbet" <corbet@lwn.net>, "Josh
 Hilke" <jrhilke@google.com>, "Mike Rapoport" <rppt@kernel.org>, "Parav
 Pandit" <parav@nvidia.com>, linux-pci@vger.kernel.org, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Lukas
 Wunner" <lukas@wunner.de>, "Leon Romanovsky" <leonro@nvidia.com>
In-Reply-To: <20260918200640.887030-6-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-6-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 20:14:24 +0000
Message-Id: <20260918201424.82EBD1F00898@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3C9B11C0002
X-Stat-Signature: krghuaypp13p6muj1zy9mjmzyo4kptzs
X-Rspam-User: 
X-HE-Tag: 1789762466-24292
X-HE-Meta: U2FsdGVkX19scEhGxa3lOlRvotsZpbkNJ9K03aLA4CAiQD8wqLszpUz7dGhXoiU5qZ9U3Wj1WqsU088e3w6LhZSn6t0gIjkKM33z2iclboNOPzSmTPcMRIsKoPJd+X+dh4Ue6Jkj4Q9aBV8b6Tlpz1/3C84/EC35gUqeR1gr2OKB6Vx/xzw++czFtdw827UfH/vUl2qAWwvrrgYAtudtGNeW0ExJFbeBTigpnGrd0f8OeoEBE1JjtMMZSsfIfr9WxcgrD5wV1yT0pVjqADQucw34S5BUvel3rdm7UVUbSSpyF+0EcTp0bxVPP+xjRLSQOPL+8HghOVkpBUVEpji0IBiSOEKkwAZmooQxnIQXzJBVZbPLp0fjyVbuIhHv1LaTIhJLrxkD+ui8zj6bc7Jzzf3qzTRi6vOPro03ExysnR5LejTvYn0iL+B15jDJIIIITEd4p3l7SvGBmlKoFOxNFS5f1YH97tJEf3qSjVhp1+EDokFGnQPRwmc082rkfYk9QMURpIfjGlgOCcjgm69l4CY78iqsq9hmd9dZ6FPIvLmhD00p/ldIplcCa98BbKSpSV1k/snjjeYQnejum4Z+fe6D95F45O5fdqhxXuqGnLyzZ0YHDDvhdHdP8C8Pn2pvhJn5lGQXEgwQYZEwswKvGqCjGa2ztOxOOn5zQGeLoaavPnXlo0gsKSCtaIJFMrFnI5rX0joXXFAM8YEsTnlFuM9rriDzAYHDy4lTIgh9T6+FF7PqJJq9xiYecrAViif99bkl/JD5lMe2yzGZsXR/H6/2HZWfFLzNRRGksMDLFUtacBUthoLSLsXLfNVR/OFfFCnz09yhaWt6QNG1RGOVFqBef25NTYMpyrOntkAPQ58xqfVC9mN5hT6nF33OGpj7KbmHIIz64/Glzw4cCo+Cwn+1FLY40sRxl5n2cITczd0v26lJdyih/k7kFiqp33If97IG0AQGaEt0O3PKsoj
 vstst9xM
 iNi5HcIsWYO+12ke/I6PXwU8Jlg9hDAgby1Rg2s6uYu+TOzeWa8RddX9gbQqWict/N32chy1ZbbniZBZdUHIb/zra3ZF3D4h9dlnc+C9rxTop/OCyuxYJWdPmk6v4QMrwsh7pjT6/G0/ZDBTegtQcO7tcckmgjR40Q5zSZsnHDhU90AH65TrxXEjcYO7A2dCaHo4q2GYtrsWaRi5ylx9+EHiOkwk6JsIy08b2AFqKm6+gLIsmurSS+Um4o+zk/SJ98ZrdbktsOBH7O0EsJFPyS9zDX7j2cmNHPaXQWlY8X2lBuO8IVvB62cdR2Jm80V5Rt0N9fzZe9ujX/Q1HDfzsTn5LdZdo6ZIs+RnElbNON7b3yhzaXnAxUjDCi8NJozEEo8g+r5eGezJP4Tuk6QC1p3YUmp56DrcK7CW+2l9JZjsXukaXLnWh7/m/g89Ig8v9IXlBP3o0Wk42uF96kGaB65DX9OES5C0iRacB3BZd3gSdIyvqeZ8VIsjieLl3VcDku8PQI17z8WTuW3bMJJXlN0Trbtu46mR2vvNhPhN8FotY6pYKEAr9WepImqJUoL5nw5FJiq64H8GC8+lvpgAovv+5Qp1sEqC3iNSJ3l8Iy7E/LbmVH93HIFe9g0lr4XHskBDfOL8Iv8qGCqP9xLp5kf45jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> When a PCI device is preserved across a Live Update, all of its upstream
> bridges up to the root port must also be preserved. This enables the PCI
> core and any drivers bound to the bridges to manage bridges correctly
> across a Live Update.
>=20
> Notably, this will be used in subsequent commits to ensure that
> preserved devices can continue performing memory transactions without a
> disruption or change in routing.
>=20
> To preserve bridges, the PCI core tracks the number of downstream
> devices preserved under each bridge using a reference count in struct
> pci_dev_ser. This allows a bridge to remain preserved until all its
> downstream preserved devices are unpreserved or finish their
> participation in the Live Update.
>=20
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918200640.8870=
30-1-dmatlack@google.com?part=3D5


