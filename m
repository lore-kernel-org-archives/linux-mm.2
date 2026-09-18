Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F93C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44F2E6B00A4; Fri, 18 Sep 2026 16:18:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF206B00A6; Fri, 18 Sep 2026 16:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EE9B6B00A7; Fri, 18 Sep 2026 16:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BBC56B00A4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:18:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 942901207E9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:18:01 +0000 (UTC)
X-FDA: 85227994362.29.9EE2445
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1190F120005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:17:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ic40wAoF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762680;
	b=Fb1NbDs3VP4dTNAoTkAl8jewCoPzuXBTP0Nr5ceuawA3PUnzTcOZVrUslrAS5nwzHY4H96
	27RhuXWQZ5JW0uTUizulgAWEuMeI4RstBMehgaTn6ySzzr4Tx/Aih5cfK+EFVZStNPiiVz
	Shsum9fC1y4ZdT0XB9j/AORAD8ahd0E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ic40wAoF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762680;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rj26d3aL2UpD/OsbufCpnz9ZaAuE0EUthnpJ0sXROVk=;
	b=KOCepMgxnGwwgImJa7Wz8gl6TQMMUJ36npHLdYQN5VynBrHUH+bwYt7HwBig7r6DNACqiZ
	/AfOa2tbvHPSk/MRU4xcKPNBRPDP4ZS11OQtyPLLJPNk+Zc20CBHYVJxSI94+yafBOKZOK
	xWL1WlDj2uNXIaSfKNMf+Xo34NeZlbI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AA26602CC;
	Fri, 18 Sep 2026 20:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3871F000FF;
	Fri, 18 Sep 2026 20:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762679;
	bh=Rj26d3aL2UpD/OsbufCpnz9ZaAuE0EUthnpJ0sXROVk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ic40wAoFb5QI4S4AZtHCuYo7DpiDWYXy+Vg66oKsiZCf0vKs7mFaybs+eEkI2Ca0p
	 LsvOzLbUd20yb6EfzbjtdXMW6+daSuF3ys9c3jtzvaWzy1+r+5mGc1fW74XF/5xHyW
	 b8HuWqEy60y7RoYviDGVFDKJPsAyD0qU/Ws/i7DJ/dd3yXFha6vfyubXF5yueTE+jX
	 ziihUo2gPcptS36xC6q1uUCmQUnVk+m3aIeKFzuZWUeN22ifPM8TEtaL7Iv1Dkxwc7
	 Isj2sKpT1v3z952iVZ8xaJorgYZQ0GT0fOo9V0X8cIwBEDMIzs0NEPjHoY3bSChifJ
	 /+vGQ/ZG08ZDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 12/13] PCI: liveupdate: Do not disable bus mastering
 on preserved devices during kexec
Reply-To: sashiko-reviews@lists.linux.dev
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, "David Matlack" <dmatlack@google.com>, linux-mm@kvack.org
Cc: "Shuah Khan" <skhan@linuxfoundation.org>, "Vipin Sharma" <vipinsh@google.com>, "William
 Tu" <witu@nvidia.com>, "Alexander Graf" <graf@amazon.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Mike
 Rapoport" <rppt@kernel.org>, "David Rientjes" <rientjes@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Chris Li" <chrisl@kernel.org>, "Josh Hilke" <jrhilke@google.com>, linux-pci@vger.kernel.org, kexec@lists.infradead.org, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Leon
 Romanovsky" <leonro@nvidia.com>, "Saeed Mahameed" <saeedm@nvidia.com>, "Adithya
 Jayachandran" <ajayachandra@nvidia.com>, "Jason Gunthorpe" <jgg@nvidia.com>, "Lukas
 Wunner" <lukas@wunner.de>, "Pranjal Shrivastava" <praan@google.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, "Samiullah Khawaja" <skhawaja@google.com>, "Alex
 Williamson" <alex@shazbot.org>, "Parav Pandit" <parav@nvidia.com>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Yi Liu" <yi.l.liu@intel.com>
In-Reply-To: <20260918200640.887030-13-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-13-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 20:17:57 +0000
Message-Id: <20260918201757.CA3871F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1190F120005
X-Stat-Signature: u7ygga7p8wfqw13wqmabu1ocxcgpyu4n
X-HE-Tag: 1789762679-361506
X-HE-Meta: U2FsdGVkX19TYl6dJnitl1HWYZYIMN0rYDtzVUGgHbxinsG9q0IN3vbauabKwITKYQmfkfr7cSJD4WKZgItGDUU3P0dxoMuYP68SXhzHsHxIFnZw3ADfu2G5oItpIsXApmDMrxCY7awdOEOnjdiiss52Y1pd2kfqTC+VhxUs01D/rxbnG/KA945sVVPNq7iKo2SrkcDaIGWQash+APhcH2yh03W9MonjcYcET1SBIm5k7ZpcF5xzhXcWgJIzivWuIiExiF+GfJ8BEQLpq9qEktgqgZw1ILTl6MwC6pgAK3dJbHV2TXG5NSrIYPGd2huMMBDh2VZyae5l7hYATqk06RNj6OHjtAgz3Mfu9AAA+TjYojBPeYazgpLroZQRvDlbK8pDsWnmczSZ6UnGGT9bC2XXG8WTqVxUfQyx6nqaXXTtwh7kBr58UjHtvN1XcHurW6muJWZV7gyHsMXb38ADTyLUvmsSucNYim/5yKOWxMVmLGg+V3z/vxPPkPsRRwn6s2EJa50mP1cdofac/NN6WFd8CR3QTB153e6VrqdhDbpZh1Z6PWmYnBMCCuRId/xL9qHivDiE38C/ze8+MilDwgdVan/LluShsSrFzlRgWowypCZpnVKsJ1+q0NkMo+1UUUtfudSGXmcUjoa/PXlcDE5P4GGBH7Zs4nB/LDKFnV+L4wtp6nzH1k9yX75kEiSCXd0NNtpTcsWDSr17bC7DMtIhku/Ki8xTQMjBSIt0QvlJk4g7/vt+sv4Nn+862LsLcRE+Ho7pNY5CRoFm1MxxPzS57s3l8qDYUl+kEqn32zeXaABfS3Ppvs6HALy1sqkEyAuT/sabZXq8Q5A6uA7eiqAtG6PKHK4bjy6uY1TtrpiQ+1c1E251CiWsAYda9at77pidB0TcrpvPhhq8q2vIth3reqV2zr89AoxmZ+xVgE1KBroMrKapamULd1kOqshhYH58t190GdxZ+Jht+H+
 CI/j/GBL
 3gj0jQlH+vvoPsMZh+6gb4eipb5/cNoxw0KlJ62uO9KzK1tmCXUMUB2mkFiH9wji8D7RyomtDrfYtW1CZ5pJHlIzuDSJowKau9Tiif83qXZDOawR4kz4H5Xwuw/Ujlzc8ca1+S35/7IDVqxC8xO4nNrPCvPzcOANRg38goORnTbEq2kt/TVoMmkXL0eIzDCq03Pan8JhTNhiBEmCWhgNIzQzS+C2DwLH2AcrKnFi8n8P8dJVDOb1ErgCvbmCgvCsXaM4aIg5+c7zpAKA4ZlhiFhzrf96JyUpnZzxYluHaQfF+/jpdWOHXxp0Y0bbZAwFEWkA1i2UzpOWG3/NqsIbo+PY6amEx/B1BAq/LUl72zNUo33cMKO/s5W5gLpX3lpreNzkyOV5ULX1+QM69QEdpjIws8x5DBw9EZawhiCOLnjYYvhxizRaK4L4Qa8Ai7iEz/QxbW2nX6rpWkMAM8KwHtWF0Uks0WjbJfn2/mheQAdtwHd5HnaifebWhE2/F7xufBoFjjVfSPdbKTmXIX4RKb4zFlP/+Uv//QNDsd+LoZRWy5v0ocmpI+xkm1ipRtKpp9Q4FsvvE2RgNtegnJys2wiX60mAd/Bb1qk7jgLvXSCQWKkTRig6TPr+i6KhufldhxOSQUfXuUREGDfHGGuKS5CBVZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Do not disable bus mastering on outgoing preserved devices during
> pci_device_shutdown() for kexec.
>=20
> Preserved devices must be allowed to perform memory transactions during
> a Live Update to ensure continuous operation.  Clearing the bus
> mastering bit would prevent these devices from issuing any memory
> requests while the new kernel boots.
>=20
> Because bridges upstream of preserved endpoint devices are also
> automatically preserved, this change also avoids clearing bus mastering
> on them. This is critical because clearing bus mastering on an upstream
> bridge prevents the bridge from forwarding memory requests upstream (i.e.
> it would prevent the endpoint device from accessing system RAM and doing
> peer-to-peer transactions with devices not downstream of the bridge).
>=20
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918200640.8870=
30-1-dmatlack@google.com?part=3D12


