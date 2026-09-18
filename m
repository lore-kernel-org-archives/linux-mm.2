Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FAFCC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896F86B0088; Fri, 18 Sep 2026 16:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846FC6B008C; Fri, 18 Sep 2026 16:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736476B009F; Fri, 18 Sep 2026 16:19:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 513066B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:19:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBD2980768
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:19:18 +0000 (UTC)
X-FDA: 85227997596.26.C77FCE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4BE9A80006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:19:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPlYpnky;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762757;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPMFs+N7+9joEThLRn1A4j3xw35F8/P+UFOYT3cS5vs=;
	b=qsf+m1XYq+HoGCfKr3uugRBKbIZbik20q0dbzPybsBGT8f4C1YsPUARSPmH44i/lxsUGt7
	U4z584I0OhlyE+W1Zdwn5gzYTyqIvdH2m3O2HjvcXTIWGelNn8j8ehoBqRwCIU+gOp90s0
	2ueIe/ZJMTTMl9RNjU62FEpfTx1sQTE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762757;
	b=RvzeoLll1nTCmC3K5v5iRzNsI+owmZwGF8HUJtu0VlACJhF024ZW/1eX3jy1rVILLIuOF/
	Nktxeu+EFrXngIfPW4djuCk0nyK1YleYuoZUtf8wCGJ9BM5UM6uRZxWD5rsM7+kf3939bm
	VXTm+Kbs1WIoTz0RiNplyESQA6qLy3o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPlYpnky;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 808F64125D;
	Fri, 18 Sep 2026 20:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC1D1F000FF;
	Fri, 18 Sep 2026 20:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762756;
	bh=sPMFs+N7+9joEThLRn1A4j3xw35F8/P+UFOYT3cS5vs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YPlYpnky7mi7B4nDnFiPWFOktxyeOfZ6KKSL7GtCns3H/qFcDP2ymrRRryPu9vgtG
	 q3IxdutHh9FQV/SOx9Wfr7nM7nCvaF6c9fG3dRTc5Pwi6HbXkMEUHCpWm2l+XRvbMO
	 jyeanBPSSs+r9gtihibrV5eci0c2MBoImHb46PnH+WRVi7fbVIbl1nqRcZ4IT6EXdJ
	 lZg0alLcSFWRV3YTOLv2NZHPojAX5Wlyzk00C/tqasLB3LL6/+D84ZWFbIYsTxj4KJ
	 4z1cNCOfQScLPAOORjL2DmtXqRtwA2LJtSLXY7mhhQ0A87b9VYfmZ+8i8MSYTSbUfP
	 5LSVRzzVbIVGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 10/13] PCI: liveupdate: Adopt ARI Forwarding Enable
 on preserved bridges
Reply-To: sashiko-reviews@lists.linux.dev
To: linux-kernel@vger.kernel.org, "David Matlack" <dmatlack@google.com>, linux-doc@vger.kernel.org, linux-mm@kvack.org
Cc: "Jason Gunthorpe" <jgg@nvidia.com>, "Leon Romanovsky" <leonro@nvidia.com>, "Vipin
 Sharma" <vipinsh@google.com>, "William Tu" <witu@nvidia.com>, "Saeed
 Mahameed" <saeedm@nvidia.com>, linux-pci@vger.kernel.org, "Mike Rapoport" <rppt@kernel.org>, "Parav
 Pandit" <parav@nvidia.com>, "Pranjal Shrivastava" <praan@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Alex Williamson" <alex@shazbot.org>, "Jacob
 Pan" <jacob.pan@linux.microsoft.com>, "Alexander Graf" <graf@amazon.com>, "Adithya
 Jayachandran" <ajayachandra@nvidia.com>, kexec@lists.infradead.org, "Josh
 Hilke" <jrhilke@google.com>, "Lukas Wunner" <lukas@wunner.de>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Bjorn
 Helgaas" <bhelgaas@google.com>, "David Rientjes" <rientjes@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Samiullah Khawaja" <skhawaja@google.com>, "Yi
 Liu" <yi.l.liu@intel.com>, "Chris Li" <chrisl@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>
In-Reply-To: <20260918200640.887030-11-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-11-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 20:19:14 +0000
Message-Id: <20260918201914.EFC1D1F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fx54c1yesntc65emr1uwt89kzxe7dwp3
X-Rspamd-Queue-Id: 4BE9A80006
X-HE-Tag: 1789762757-892974
X-HE-Meta: U2FsdGVkX1+WNCrfSbGBCPc+rDlJUJcf+g62tNWwMCgxU08vcSTGzokUTDQGXO3s2jFlF2ur7PfLqEGm4/Xf8L0ATvdeL9UlMZGprfKZM8sAszvq7TMpmi2J/fo7q4ktIQA8msdvpNkMTdO+FGP1gKC0Z7ZxnerrJc9q8370a0rBjPYSRZACjQFDXuI/vJUCKIUszg6CwQdbw/NMOvr68N9PtmYM2AlBaBCQ3aHDKJWkYcyrT10S2jMWgOejsM3kkXATcu16zD0Gzuql+9GWIt4b7klv3svln+cdPKoRUy5pwSE/Wt/sIuHMCWzWBQyvRfXMP9LjQBlJlVxVCGuJw0mT59fWv2bBKuhcyEfKX0uTs/zLf9vzNrZa3pUpojUPjU1nRCwOjfTrFsxvzjFCh809zMeP9FuQPfdvrSpfTR9IamY5B+oudyjAofaEju/dU7jbCNzBG1H9PubXwuDnA26Gyuv+Fk1ch6G01gyu4pr2pOUDxoa0V+2aJ8/4Yj7W0YyfDGXSXOJPzTqMkzCK0jBXeBBcfnhw+NJcEh3FFtKFXAQ91thchaJj8zWaFCxplLjlzqaNMqZVfFmDEcDgu7ccvzFCtu9SLtlKP2Qnjdn7qVUOHWydVpY1JY24ek/R7RPyp61iPqtN92IVluc3Uw3MqhKMe/FvRE++w7nCUr1qusLbLzSXYyy7P6cKS/LUsQaZLF1TpHLS2LbFOcewXD1uMuNFw/NNiLms06Jr9q/5UF8JtNuKOnn6H+mluPL5nfY0MK0okh3K8fGnr9gaEyjX0EJ/q+F5HyXsddhXMggpZ1ELj7FK0aCl09YxlyLT6tju1hp/1+eT7huNTW5ZDAxTraV1X3+cKyXFDq+rQQMlwWc1fVF+ZUdJGQaVlu3e6KJyOR4SXf9GLnUsxuFl7KOhA2Az3cOBZpTEzzLYZxZKvuokMC7yqRRLt9LcFrVA3PaDvhkOshamP4ZffYR
 kJ0Vs4if
 oXmQk7ZqsgwgydyqEBGKhQDCWCqSeFgBuBN+AtbeHf+T7TIYNEO1zC+8M1GZqW7DH3WMiNI9ffyCWKPsBuy4B0Cd6qKtlEqLDIJ0TtN8h+aj1D3Yq/u0hWI0ZbTM7RYzT6QqIGnx5gKjd6DOi0nwQtwoOgotSOyjKaY28+PxgH9HTk/NrmbPWhICIMNZZ0C9RnKEWWXl8PPU1gAZf4efIU/6GM+ZRLKOd/hrY+MAEqz5n2UXN07lRoo743tX8TdcDu7bXpfVYVpAl/ULJwydECoDINIWoDMs+8Arm5NCkWP5SKIkh72Aapjo5vgWYcLnof2egOVa5ViyTxvYU+8VWAuzEhRwuuUkuV4opy2R+pesKtX6qQ07IW+T8Vw2qDB/g1iK3Wkr6PHMPPTaFjNE9LpVQeMecRIoCTB2ipxv+v6aeWd/goToMyfztdy50OcREH47CWS5j48xB45eJXMM2dtg1L3NX1zY7c6OV55KYoAuC50vxmTMjylHdi0b9mpZwt3sGIszNU4DWLSKZZt48/ZyYhIUySzgjEl5wjQkbBJlcxYDRauCWiu2BihQNGjASV/JBpfeOzeJGU4fjIvRiXnQ3HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Adopt the ARI Forwarding Enable bit on preserved bridges and update
> pci_dev->ari_enabled accordingly during a Live Update. This ensures that
> the preserved devices on the bridge's secondary bus can be identified
> with the same expanded 8-bit function number after a Live Update.
>=20
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918200640.8870=
30-1-dmatlack@google.com?part=3D10


