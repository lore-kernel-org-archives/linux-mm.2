Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00893606A332
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 22:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K84lAhix
Received: by kanga.kvack.org (Postfix)
	id 0C5D76B0687; Thu, 19 Nov 2026 17:38:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09DF16B06D6; Thu, 19 Nov 2026 17:38:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D296B06FA; Thu, 19 Nov 2026 17:38:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4BBF6B0687
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:38:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50A5A160CA9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:38:47 +0000 (UTC)
X-FDA: 85453334694.26.254F7EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ACB281C0009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:38:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K84lAhix;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795127925;
	b=dYCRjCfFFF4Dwpcj3C2fo+hGqyiD/NHkNfLcppePhYbHE2EAH5mRbkG2coxVyThw5I2Zng
	IuskySuPUtxKjMpF7B9+jmT0IKK8CHMXJvSY3tcIHgrXETlooGchPkvu4lMMHljcFSTk/U
	LFqu80bZdRqlTXmQnoxdS4m3dOi2E10=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795127925;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oub/Ol/8+MHQZEeLyeMANUxv5ii8PId82e+apI4K+qk=;
	b=zuL2c2VPVfLjQ7J7vVJjg2HZ2w9XN6qaXNCaS3jK+o56J9kXwmXQh3UOdfhghA7vAUubgz
	umtelrr/btCp5LXhCufXpR7CXl5YH5TGPY02eNfmSV+jZng39l+UnzXzw0TQHiEYHkYPql
	yQlWbzGkPoZoOZWIfu1dYvU2C5orO3Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K84lAhix;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E71760D29;
	Thu, 19 Nov 2026 22:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7FB1F000C6;
	Thu, 19 Nov 2026 22:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795127925;
	bh=Oub/Ol/8+MHQZEeLyeMANUxv5ii8PId82e+apI4K+qk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K84lAhix8cpsbsDJfvQeFZGr+Kk8Lz8wqX8LsgOt1bVOP+kEieFCct6YVOzjhHp7x
	 OpyQVrxppkAYDnQubFP54zWqkFntRE+SzwrlCoyTrb6gIfcBHRgyAl9fNELbzT9wIP
	 6f9ZdkqZ6lOgxy7x4VJM1SJ1d4POd7ZESTcYetGoupVdU2w1on2fb0QaqmkLBOqhtC
	 TKbTLWHkGCIcLv8A0bmo4qecQBFq9m10SQYtCJ3KEVvJEMkjG4sq8l96fdqwsvGenS
	 Y6q1K78HFEyAwsZkjf+8XUozb1Vkb18oCul+Cu3Ve0N4JuLuM2KR6sZBu2CYgu1gIv
	 JK4CKeGZzvC5A==
Message-ID: <sashiko-outbox-224146@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 11/13] PCI: liveupdate: Freeze preservation status
 during shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Matlack" <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: "Adithya Jayachandran" <ajayachandra@nvidia.com>, "Alexander Graf" <graf@amazon.com>, "Alex
 Williamson" <alex@shazbot.org>, "Alex Williamson" <alex.williamson@nvidia.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, "Chris Down" <chris@chrisdown.name>, "Chris
 Li" <chrisl@kernel.org>, "David Rientjes" <rientjes@google.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>, "Josh
 Hilke" <jrhilke@google.com>, "Leon Romanovsky" <leonro@nvidia.com>, "Lukas
 Wunner" <lukas@wunner.de>, "Mike Rapoport" <rppt@kernel.org>, "Parav Pandit" <parav@nvidia.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pranjal Shrivastava" <praan@google.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, "Samiullah Khawaja" <skhawaja@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Vipin Sharma" <vipinsh@google.com>, "William
 Tu" <witu@nvidia.com>, "Yi Liu" <yi.l.liu@intel.com>
In-Reply-To: <20261118223704.3286085-12-dmatlack@google.com>
References: <20261118223704.3286085-1-dmatlack@google.com>
 <20261118223704.3286085-12-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 22:38:40 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ACB281C0009
X-Rspam-User:
X-Stat-Signature: hs4sewm6bkrpxp7eg68d4tfu43txweog
X-HE-Tag: 1795127925-235159
X-HE-Meta: U2FsdGVkX18mKThdjgmMi4NxG99n9KHRr5cX4WFMFYZdTTu9gFiAFYDxABsNKekEL4CNRz0z+z8cRYbiH19T2kmS3vEJnVlOL6zXl6R0uDX6vVtkCrYAiq9mGNcWX/u1RaQbN3SIzZueny2e+XZx4b5I7OJkdRS59BYdeELCKySYWFc5odZqlbRGyc+Lh3Uu5UAyf1My7pUBfKbXPSiierfVZX/7gYOeiE7kQPE+LYz/jxGC9y7FRJHyIB0HHM8hVJJOhUozkkrgyBNRLz9V4cSJt7K/bInmZOKwNL6YdoredwSqOzzn4XFYKWKbLkYgOHYrydQCIkEJDaek9nAmFmeZUZFw1lleQPYbiKmReeSPJMYYebBet1K54valXlssl1s2I6uep3bHs3UXtPpDuPwWBiejhfnoZSbftxchAL79qPu+rwD6h/ZwP3dWOt3xiqwA8zbQnYeMb2YcEiSM9ktm57U0d2VoOC7Qeof/fXFHgcbFze8BG8gPywhOkgYMteH2x5lM83uWuCyzRHSrQa20Rp9svoodYk7EKIVYAxY4THuAkZtIbpJQQr/GEaQt2My43/A98eU7/K0nknwHa6svIUOY4YOwVSDiacxCA+e4pe1Ym6eAt5Cx/1gxknTVHQqqKNBRym40oKga6dfxe7m9A+iGJYFPQkyNh8MyfqnxQOLNT2ur8A9oXB3LKI8S2SolwFf8jk8Ny66qV1X0upNI5IK1KC5k2UQinSiJnr4vCEtKQdM2G669X2+DYlaOJr5IDt1XRBpJp9KTDnEuF8bn8yC+65k7VNSY90WVk0oE4rfWYelhDCKPv83ODwjceKY0fm1EmQ3qkr7wRyHdd0CbGfFHcPhZ+jUT3QIfgK6q9d5H/RLCb+s7j4jTCopeWuwqx8TLvv3Fbx29cLwK1serDpv1SyVFSGWX0nLO5eZlYgP/bkIPTbeWe6p0FE7SqqmqB2rDrvP0OlxAqAS
 vSGJYcNu
 5abKBud+hMUqGen+8LfecENvKUEbCkGD9kMJd9KCCg54wg1thNr9+IcE25Wi6/vbXfyCWtBX5aFjV6x7ImMnSYjYZVQAiNOmTcijSdr+LGIqbnmpBrUdovn2HjOpt1uyBLSlhCuDoLM1bkUFDHhQkgd80fesnNFaIY/cHqH03KjbZoEqdjNKAjNsVcqmadb9BhvP4JGaJvSiFBD/sda6fRTIyYYTkNVJlRrGciE440mEJgD7Zr4ufEQRw20+PFc2jkiYWZFqkiLmaCNOiJlHayyyNJvjUTD4Fc6zycQ3b6+IwC28vhqZKS1SgNzyyir4mvxamg+QEFKrYFVfWQXHNzzvfrVnJwFXafF/tDGGP4uQo0ZnewTA91h2y/c/IFRxaCHJNfDI1+y+gdSub5+oUQGshWrq0/yttKB5YbfnKMrBCCty50lwSRoz4RB8//Z6HcOen3NcPE/w9QEElLMGVkPOpC89088RLECtN9zA4M2xOsuAng8Qup9A7+uzQHP6aJlYt2/POSjzDsnhSQ1tAD31q7NGyaS6id56jESMQyUoC+KN3dCO8PITfQxww2oUDKClbO2EmJtp11XQv36RkcOrFJFugo601m5s2TWBgHqXoGqFYQ1tTGFddryODMDfszxdtxg4g1j1lfchShGXgMvJZToJSaXemQ+duYwpGC+UmdJDq3UpL+bQwTkJAnZCs2TKN/VOREHLClrNGQhy3ngA8F9nWNo77jJ0UL0JYX0v97v4+TaYz2tla8s6TlibA0uTJGhTuX/uijG0=
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
- [High] pci: liveupdate: panic on session teardown after
  pci_liveupdate_freeze()
--

commit a3120ec70b92ea26f3e1d92d3bd0d1531b5a73b6
Author: David Matlack <dmatlack@google.com>

PCI: liveupdate: Freeze preservation status during shutdown

This commit freezes a PCI device's outgoing live update preservation
status in pci_device_shutdown() so that devices cannot be preserved or
unpreserved once shutdown begins.

> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index a45ad86370d5d..e26d2f5c2338c 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c

[ ... ]

> @@ -520,6 +523,11 @@ static int pci_liveupdate_unpreserve_device(struct p=
ci_flb_outgoing *outgoing,
>  {
>  	struct pci_dev_ser *dev_ser =3D dev->liveupdate.outgoing;
> =20
> +	if (dev->liveupdate.frozen) {
> +		pci_warn(dev, "Cannot unpreserve device after it is frozen!\n");
> +		return -EINVAL;
> +	}

[Severity: High]
Can rejecting pci_liveupdate_unpreserve_device() on a frozen device trigger=
 a
panic in pci_check_all_devices_released() when a Live Update session is
closed during a non-kexec shutdown?

Unlike kernel_kexec(), which calls liveupdate_reboot() to serialize sessions
before device_shutdown(), non-kexec shutdown paths (kernel_restart(),
kernel_halt(), and kernel_power_off()) call device_shutdown() ->
pci_device_shutdown() -> pci_liveupdate_freeze() without serializing Live
Update sessions.

If a task closes an open session FD with a preserved PCI device during or
after pci_device_shutdown(), luo_file_unpreserve_files() invokes the file
handler's .unpreserve() callback and then unconditionally drops the outgoing
FLB reference:

kernel/liveupdate/luo_file.c:luo_file_unpreserve_files() {
    ...
		luo_file->fh->ops->unpreserve(&args);
		luo_flb_file_unpreserve(luo_file->fh);
    ...
}

Because dev->liveupdate.frozen is set, pci_liveupdate_unpreserve_device()
returns -EINVAL without decrementing dev_ser->refcount or
outgoing->ser->nr_devices.  When luo_flb_file_unpreserve() drops the final
FLB reference, pci_flb_unpreserve() calls pci_check_all_devices_released(),
which panics because outgoing->ser->nr_devices is still non-zero.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118223704.3286=
085-1-dmatlack@google.com?part=3D11

