Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC12606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 22:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NuwjnRJ7
Received: by kanga.kvack.org (Postfix)
	id 7F2516B05DB; Thu, 19 Nov 2026 17:38:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA266B0651; Thu, 19 Nov 2026 17:38:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708146B06F9; Thu, 19 Nov 2026 17:38:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA246B05DB
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:38:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EB481C3F52
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:38:42 +0000 (UTC)
X-FDA: 85453334484.21.50C2EAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0E2E1140003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:38:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NuwjnRJ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795127921;
	b=Tln1Zmz90Fgwf6CvMc4AX6QjR/Tpt+XoI+mJS4l0xb6kMTbAuv7toJQpvb3CsSuRPU6CLl
	UWNMmW0EfEnpjZupOb817QwaoCz9ouNrbX7x+1gFFiBd36lHQ4TiIOiumcpZzPDg4erjL8
	s6q0LbnijEwc01pg1c476vHdFjMNJEI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795127921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cj8MKy2tc3Sx1JwUpxECQgdXmsrh1YRqOP4Sl+8Dj74=;
	b=sREJDYGN/zDZp74nMcsjyP5eo3IPlj6gwrAFYlvE4xxKtBzQD34CfPmWmRchkv+JGqe3hV
	fkRcrv/D6+MgJu1ixbKhbEh6FrY2pQHUBORftyXM7C6kgFUfvsqDdbK2qlqX6DT4sZii91
	j+M+/wHMFRgtDnNysKYjDZM17KS0v7E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NuwjnRJ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59D3961F65;
	Thu, 19 Nov 2026 22:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EBA1F000CF;
	Thu, 19 Nov 2026 22:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795127920;
	bh=cj8MKy2tc3Sx1JwUpxECQgdXmsrh1YRqOP4Sl+8Dj74=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NuwjnRJ77VaBWoVlfrRYMOPJitsXnO0CmQ0ewhyBdvVQIUMa/2Lla85Nd6sVLcqSO
	 rBSZstLLajgdg7CE+ZtMUiIPEv7PaFl58FO+wjyZERXsQJXc1P+8EZBEsc/pc0Li1r
	 dSkKtAQNhJuxTDl75YrxBtqZBBY5rTx9XQlDa6MrD3Mm2Dx+CX2hcFoQ7EkEK4jzX2
	 ix5bmcrCXaw7nWXSZsh23FNASS8JJ6jpmZa+nRvl4KCo6luiLjhnX2QZ86aYoWNNTT
	 gsxJFCM+Haoqlx6Fd3JAZz1snnrO7gz1yCU4oh1Hz3OR/4LMVYS79qCG5O55gft1aC
	 rAn9WVkFg2HcA==
Message-ID: <sashiko-outbox-224145@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 10/13] PCI: liveupdate: Adopt ARI Forwarding Enable
 on preserved bridges
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
In-Reply-To: <20261118223704.3286085-11-dmatlack@google.com>
References: <20261118223704.3286085-1-dmatlack@google.com>
 <20261118223704.3286085-11-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 22:38:38 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0E2E1140003
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: fchx96yqczts6kr97k8bb81cqt3x88fi
X-HE-Tag: 1795127920-539609
X-HE-Meta: U2FsdGVkX1/1WJy0VFnL7RLN44QZHD46cRZRD1zexLtW4gRHeTdQijrL50oIVjiG/bKVCVPoG3NGPoaknXKNdcF/PRCas15I3X26S7PRVRltWZ+Pb2RA5RO+RP8HZN+YUPmsNwyBlWQSPUbQ/5sDzVcT5mBibizs26fyLQR8BI1cvZDM3n0h38ddl4ms6PhtggSROrOtaBJjcuQonKpmivshwTC834RW0XnGIYFiNcE4Oj95DwsO7WuwDk8iIJnXk0Arv6BflJMNZ/uUWdGUdPBeJaHoF7ihSmW8IcTlL1pZ2gTPcJSZRTVG/XuEfA35cyLPCEW7qfE1WRywYzT2fPg9P+2id8isW7pDBs17LDxunHDB0Zdtzh/XA3hkcj9JNj2/b5bMyFoy9Xu3VzWWw8CC+c4K+uyOErt+CQl+euQx0eM1yMWdKNY+BEPlNxH86Oj5CL8SJedkM1nV1a+AAEdQDsUkKMy6EYLbNjb5Q5P5281bevA6shnE9CRN7lP3AYLa9kMiUDzfCZKQW5jDWrnYtA0xgaagdwnA8Mphw5vgtrJAY3WhoYG2jV3T5TlatBzHqTlLzNePaP8crB+1kxoUpO9NXnsinbbev7tdIwaqIqhkvavXGcpTWOJ+EDmqGA1IQxYLex8CoMJmmIkOxiv4aDc2O1YYKZ4QIwK6gcB/RMQDSaaM/VCisd02UFkUiQSiyl6FFgcIfYZZAvEBJ9eWXiZiys0BnVKocxC6XCm6hhkcasfrZO4op+RnSiyc9iDPyY+6XMnXyk+DzQ0LyX4hK+dx/ubahv1enA0v3o8qEJPe3Wt8/h0FLLcUK3/4TLi0bfyD/bVw5luCE4xxSgMHEoApa+8bvNZ53yMlYPPlGa3SK7igWbDc+3oB7fi3ZaY2wQleIMtHGZLBJMFZEVhhg3mgwneoQ34tYAUKvXP4DOcvCjLgEevEmsoXs15VSQJzMd8AdVc8xg2pmMe
 Z49Ac8eV
 FZMP1pTI5PgLL2+MRsLEBRPuuzWMkWAVClvhheCB794+w5uAqUc+elVoLXJpXB6dFKtXyneMw+uL6WKMz7ueON4PGaZrWhZjQXhRURBsX35Tf9w+TxpSVqtozgDSVq35Tnu8P/JkAVQmwayUsU97bRAqMuQ0QbI3ake7RfGcAaETbiH+Jri0xSxOL/7gv6uijMUwTEs2Boqn5CgWfoWYLEzv1WEByrpX409rMfmQuW3gX/Gc0qakqzT93jB61GoUiPQQRt3oZmgrfAPNWF+m+OdPYtmKhQPaN/TMLPp7rzh+yG9cR536/JJlDLWZtTrNK3LOWFPV34gzTT9BYg/jSjGGkQ0vWGRv4LuTWQswnUeon5lbbQdhnedmnSAiYFQqpiodIUF9cSod9X3jkB7SZjj4/EHuvqbaFygo5bJ0SPLpJF8vnocdJ9f2mWQm/6qUq6QnVa26WeDeXUPFVAQyc/WXAp8Mzf6XqwQcT3wU/pflaGOv9c4zDt41YvTVMfmNUK93/7GuRQ0sdvCjCJLNwqfyxeofWIT82EzQtp2Mu+WfUg3PfwpMEiipv9o+Tlz6QltcQG5NoOLWDGCgB4dkm/Uy/FrsLuJOoGwc/CsijIQHmxOOnbnHo1h4DvLiu9i/Swys0aNyy3mM9PoOPLpUcq1hgMFVNbRtZya9eyvz4z7XoI5Ae5ufg1kU8vSgPMfrfjichCR0io6iOrrqQrLxbdqBT4OcP3fRsc3RWJZ2WgbyFdGCdQJQPtZ8eZg==
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
- [Medium] PCI: liveupdate: stale ARI state in pci_configure_ari() with
  pci=3Dnoari
--

commit ee2b5e1cebde3231a1c9acaaf68c272dbf3c6e8e
Author: David Matlack <dmatlack@google.com>

PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges

This commit adopts the ARI Forwarding Enable bit from hardware on
incoming-preserved bridges during a Live Update, even when pci=3Dnoari is
passed on the kernel command line.

> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index ebc565b4780a1..b5b578355a1b6 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3748,7 +3748,7 @@ void pci_configure_ari(struct pci_dev *dev)
>  	u32 cap;
>  	struct pci_dev *bridge;
> =20
> -	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
> +	if (!pci_is_pcie(dev) || dev->devfn)
>  		return;
> =20
>  	bridge =3D dev->bus->self;
> @@ -3759,6 +3759,12 @@ void pci_configure_ari(struct pci_dev *dev)
>  	if (!(cap & PCI_EXP_DEVCAP2_ARI))
>  		return;
> =20
> +	if (!pci_liveupdate_adopt_ari(bridge))
> +		return;
> +
> +	if (pcie_ari_disabled)
> +		return;
> +
>  	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI)) {
>  		pcie_capability_set_word(bridge, PCI_EXP_DEVCTL2,
>  					 PCI_EXP_DEVCTL2_ARI);

[Severity: Medium]
Does returning early on pcie_ari_disabled leave PCI_EXP_DEVCTL2_ARI and
bridge->ari_enabled set to 1 if a new device is hot-plugged after the
preserved devices below the bridge have finished Live Update?

When booting with pci=3Dnoari, pci_liveupdate_adopt_ari() sets
bridge->ari_enabled =3D 1 while bridge->liveupdate.incoming is set.  Once
the preserved devices finish Live Update and bridge->liveupdate.incoming
is cleared, hot-plugging or rescanning a non-ARI multi-function device
below the bridge causes pci_liveupdate_adopt_ari() to return -EINVAL and
pci_configure_ari() to return at pcie_ari_disabled without reaching the
else branch that clears PCI_EXP_DEVCTL2_ARI and bridge->ari_enabled.
Because bridge->ari_enabled stays 1, next_fn() calls next_ari_fn(), which
returns -ENODEV and skips enumerating functions 1..7 on the new device.

Checking !pcie_ari_disabled alongside pci_find_ext_capability(dev,
PCI_EXT_CAP_ID_ARI) instead of returning early would allow the else branch
to clear PCI_EXP_DEVCTL2_ARI and bridge->ari_enabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118223704.3286=
085-1-dmatlack@google.com?part=3D10

