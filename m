Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA39C982DF
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 711276B009F; Fri, 18 Sep 2026 16:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C27F6B00A6; Fri, 18 Sep 2026 16:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1396B00A7; Fri, 18 Sep 2026 16:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DBB66B009F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:20:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3D9B1C30DD
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:20:07 +0000 (UTC)
X-FDA: 85227999654.11.C76BDF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 24D7118000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:20:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjUAFoYZ;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762806;
	b=Mx+JcWOHwDpNjsSUgvrxksnY0ew7WdQ4rGUG0wswUeHTEL3td5H/qd79/BSYZhEf5/q0UV
	bGStEA+j0d1xALdQtoI0unqSl1w3rWxpIx9qotHXbsDiVCCbKca0Yt1h9q70aURrmC8yFI
	yJbUxtXy5y9BCvJl97ikmDeffJvw+II=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjUAFoYZ;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762806;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cyl7vQEW3LfLjMkgXBXkK29B6dIUdPn+EyE/qOnRRR0=;
	b=E4tvdWH1tzlbxmvTT88sf+cAJ8engVdG5+NitKgfcj6JWBwF9Z8rMXZ7FNRLc9V5S0u89C
	rBYpn8OqErUVSFRaTTbbwqJB2ttCCCZIlQsQhzJ6JpmjxNkObzLkCO9TC0roqC/42EvTk3
	oWqrXQie/vDda/h7LH9PSx/9JpYCqCc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE1CD602CC;
	Fri, 18 Sep 2026 20:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AE51F000FF;
	Fri, 18 Sep 2026 20:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762805;
	bh=Cyl7vQEW3LfLjMkgXBXkK29B6dIUdPn+EyE/qOnRRR0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mjUAFoYZxPnQsQpOb1L4wDNqgVs+S5TR7L4F5G2tKrnkscbfk4QcfcKxREph+VKZo
	 HU3vZ2CgZGzNL0KHEe0HjGVd/CzNrQI8pyVAy0FTcj2mqPOkLNYCPtrf3ckcj7DhE8
	 +tqrhYnJcft2QiuKOnJYw3zmVc4Hfu4Bv8z2uZRXufolpGJHLAOMy7wLeOoCyIaywN
	 0YFL2w4urvGcCgv50l6U6RJbbLEgs44TDrHqe2wuj+SIUebumCXE7QON4KoF2V65y2
	 ogVEOzaDp5uXgGhOWTsvegM1Tsg/bEtnr51NmkSqpNGRH+UMEc75JUA3+0XnXd3u8h
	 VBiGcEdnQ9wiQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 03/13] PCI: liveupdate: Track incoming preserved PCI
 devices
Reply-To: sashiko-reviews@lists.linux.dev
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, "David
 Matlack" <dmatlack@google.com>
Cc: "Mike Rapoport" <rppt@kernel.org>, "Leon Romanovsky" <leonro@nvidia.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Saeed
 Mahameed" <saeedm@nvidia.com>, "William Tu" <witu@nvidia.com>, "Yi Liu" <yi.l.liu@intel.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, "Josh Hilke" <jrhilke@google.com>, "Pranjal
 Shrivastava" <praan@google.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Alex
 Williamson" <alex@shazbot.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Adithya
 Jayachandran" <ajayachandra@nvidia.com>, "Chris Li" <chrisl@kernel.org>, "Samiullah
 Khawaja" <skhawaja@google.com>, linux-pci@vger.kernel.org, "Alexander Graf" <graf@amazon.com>, "David
 Rientjes" <rientjes@google.com>, "Parav Pandit" <parav@nvidia.com>, kexec@lists.infradead.org, "Lukas
 Wunner" <lukas@wunner.de>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Vipin Sharma" <vipinsh@google.com>, "Jason
 Gunthorpe" <jgg@nvidia.com>
In-Reply-To: <20260918200640.887030-4-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-4-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 20:20:03 +0000
Message-Id: <20260918202003.E7AE51F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 24D7118000A
X-Stat-Signature: kd6fzef8at4uzbfei9hgarrcjuawtgcb
X-Rspam-User: 
X-HE-Tag: 1789762805-795981
X-HE-Meta: U2FsdGVkX1/ZXrxUadoxGSyd++8S2nic6s6Wrn+xSZDNHH1LcjlM/MRjmDpkhtMFoEyygyUiK7ENf4791FIOtQanU71BV3Hh2oRRPOtiLy6KR0343MC1jPtEZW50LDflArNdP4fQX38d9aNjSGvrdiZr38TAOuKV/2GDEIGnNNxOLL68lFmD+umwc6E3OgFX8s7j6OvKXzPCBNe9Sx8IJwVN9TNRgNFAgUOtn1gTQ6fH/kuTHWrfunQchwueooPuQ50sY7uADbh5bwrdrmkE/ALJ2lp6yON83v1+7GnI1Uwb7QJDCDDYOO0vMHc7RCo2v8nJNiD59wBDXmULh33gAAoRSL5htPJzUdSRcO2YAE1SGgibbRkuJuFP/+BcQUQ+TPcDHTIWTNiEIg0VUmf1GQyIeT+tbAWf1nbbG0BQ8a2omfbAP8UdygOz2oE+KSgLoh6S1J9fbtfGYKlvUiuz5JgKjWT9DHtvH8jmSLMTgTdEeMo6Zomf5l60TkVIakYMzcRwg2lHTe5kJHut+B4UtxKf4YaNzbuIcwkGgY6BAy0Shs2aJikmzhugB+06gqrEUTNDAklAco+tQJOxcIHYTUOtKtmFxe6lNPIVL5ctbhakAThPk5lqzPeZ/nqmayk2YUuMC2KM00LzNzaC3VRDYMhzMtaibUckrb36/PucUJRj4RaU9gzuaHtGGkUQa6ELMgwuXiibnjV5zOaLjoPO/tI3LQjznx6zj7zlm197Qw/YFO3fD54d4H9HUM1/bFijas3fQfI0m1kpWfpIhxyzDmPI/T9Rvcg3fAC+8vTfiJYd9knvNuJLwALJOPJ5Rq6Z2Z9UHdAXSopA1YcXAt5rNg1hwueb+wP62EYGlMWehJ11x2UuDUTNQ9DWHWL50I0babo5nMuTFgk36QLcbcULGbOArp6qfiYk1LMRigW6FxLJ1qOjiCFhObnOIkT9BM30C7s2Dzv/ibbFrubLE+u
 FTUB/JVo
 Mpw+yqRoFeAV8WlfyLOAuv8SvxFv784/lXLlFwjEuXVLsjjwRRmDwiOUOf4Ejj75QfH9OmUZyGmbTEyk9ZN+UUUiyUrMgN6t+XOrNMBFgAWMWLMfwW/jpVQuwC3tAGFVAye0duFU3MoWu/nWkmwwjkyo/5EM/0wc5H/0kDa0ylc/yog/jMLfGeAMqeUyV/lpSi2z7O3od0paHKMz+kGlErpJg/FnATcdvO4G10JQrdRUI3q68tGwFKxajMh58HOfhRSoeG1lFdkvu1T6mIb98tSTkqFh9xci9VgSE2oY3ecCnmhv397CkqIyhM+/QVANc6p+4uu2gSjcHCsHYQ09+ImXen/bAof3v8UV+rw6xc/60Xb4uvNgcN2otZ8WaVoHVOnhdHOVnjWdE9fUvTdAkTTL+I4bj39lcxOErxNYgUPmJAy2282wNRrA4N4ejQuTiYU/wwV5iq0VXCKENPdk6VkhVqHPZHvtFPBWhGVzQQAOjTl6nxbcCCoF5TbrVj2cGzNhptHgfiX7tDtOp4zc4dKP5dQbB2F8sm1RrUYy/7C89g+cPtX5scaUq0VzfohPFdS2I+Hp7X7CVOviNaWSDkcYLFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> During PCI enumeration, the previous kernel might have passed state about
> devices that were preserved across kexec. The PCI core needs to fetch
> this state to identify which devices are "incoming" and require special
> handling.
>=20
> Add pci_liveupdate_setup_device() which is called during device setup
> to fetch the serialized state (struct pci_ser) from the Live Update
> Orchestrator. The first time this happens, pci_flb_retrieve() will run
> and convert the array of pci_dev_ser structs into an xarray so that it
> can be looked up efficiently.
>=20
> If a device is found in the xarray, the PCI core stores a pointer to its
> state in dev->liveupdate_incoming until pci_liveupdate_finish() is
> called by the driver. This pointer allows the PCI core and drivers to
> apply Live Update-specific logic to incoming devices in subsequent
> [ ... ]
> as the xarray key.
>=20
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918200640.8870=
30-1-dmatlack@google.com?part=3D3


