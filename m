Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5121C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13186B00A0; Fri, 18 Sep 2026 16:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9C16B00A3; Fri, 18 Sep 2026 16:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2CAB6B00A0; Fri, 18 Sep 2026 16:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 908556B00A0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:15:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B85ABC075A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:15:44 +0000 (UTC)
X-FDA: 85227988608.15.CE91F3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1600A100002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:15:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K//zyog2";
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762543;
	b=PXFbZVh7KzfIbUtSdX3RTvQh2WiifXi5pY/2lBSRjk0A2OghmwrxG8XgKrm8R+Uk1ypmMo
	lzlu3L2YOLvosJKFwHW15o5Ng8N1MjLbTUVHVKS6026MIK5BSZqVw6cCaD3IVW6Znp4VHu
	TDh4/Z2LjPytcuUYvTsdrBabHpzpd1g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K//zyog2";
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762543;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAEsOLRukFLus0d8Tfr9V8PlCCQdG3TdiUlAGwmhXjA=;
	b=KPLgLyv+7+wAlTAdLNxetVI7CY9UB7TzIu+PHjV4pJ+Zvbvusgk6XdtzLQxvkvuglAU4sT
	O1eF1iYgyo/rNnKBc3b5Ds3WsygCEZ3euJcin+fjzhT2TKhOGXcK9YpKiTST5cv4tri6QV
	RUX++qgBM3eXyNPXyEJBETLLpFaDQ+I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B333407A5;
	Fri, 18 Sep 2026 20:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B171F000FF;
	Fri, 18 Sep 2026 20:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762542;
	bh=OAEsOLRukFLus0d8Tfr9V8PlCCQdG3TdiUlAGwmhXjA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K//zyog2V0U5XIgFvmnnIv4886FNdZhDLQofPIKBTWXzdsJ0WqbwVY1MECT0yYu4i
	 4ZqWxbUzkgZhfArlZn0Ohx4LFYwze/+QQeCZfTSuZe8bXffQM+TkOo1vajLxH7QWKH
	 pCzk0jC946j9ZqV6KNZOaQ2HQrhA6m3AyVuiamOMb/3xqlTrQVp290o5zWsY95idWy
	 G4mybv/5QF7JoFrCjTh9fQg/QiTBsGdTVOxOAnuaP9GraJEAjOSmEDR2ncBnMgtL/M
	 +ED9/D/rGVUXvb46t+ZZKpA1vQI9jjyYFR8T2zFltuShDIyWw8pfajQO7Jxf92LGze
	 zIJGv2d2yxv/w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 08/13] PCI: Save and restore the ACS Control register
Reply-To: sashiko-reviews@lists.linux.dev
To: linux-mm@kvack.org, "David Matlack" <dmatlack@google.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: "Alex Williamson" <alex@shazbot.org>, kexec@lists.infradead.org, "Jonathan
 Corbet" <corbet@lwn.net>, "Mike Rapoport" <rppt@kernel.org>, "Bjorn Helgaas" <bhelgaas@google.com>, "David
 Rientjes" <rientjes@google.com>, linux-pci@vger.kernel.org, "Lukas Wunner" <lukas@wunner.de>, "Parav
 Pandit" <parav@nvidia.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, "Samiullah Khawaja" <skhawaja@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Vipin Sharma" <vipinsh@google.com>, "Leon
 Romanovsky" <leonro@nvidia.com>, "Adithya Jayachandran" <ajayachandra@nvidia.com>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "William Tu" <witu@nvidia.com>, "Josh Hilke" <jrhilke@google.com>, "Yi
 Liu" <yi.l.liu@intel.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pranjal Shrivastava" <praan@google.com>, "Alexander
 Graf" <graf@amazon.com>, "Chris Li" <chrisl@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>
In-Reply-To: <20260918200640.887030-9-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-9-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 20:15:40 +0000
Message-Id: <20260918201540.64B171F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1600A100002
X-Rspam-User: 
X-Stat-Signature: t1pmyp9qby8e1b7ip1ejfizxqbxk5dnu
X-HE-Tag: 1789762542-41022
X-HE-Meta: U2FsdGVkX1/G8a6+hVeGvgqc9tdmQcFNhAOyGaoOeBURJ5/z4rJU5qwOH9kpcwav//wZN0d67I5aH5o3g2COTEdDAn9aXBuECIyMnTqXrIFxftggYyphDymqrZlYB/Qrxvblyc58T3bk/GRWQcxgOJ+CKpHashA0YFxexNK5ffJi3w6LCIwKAU6Rc/DRcIO81BzMb0evBH6wakizXTor4DC1uFwe+aHC91SuEW9WJ9Jp9V579NbPOKH9t6/P8c+PV/gRX5BVUmIxt23RW5zOU+jD73Cs+3EEHroGblpsWrUd6IOm8kcweLqcdj4Gkf+zp5W9bOdScihSaTGMbS/qm2cnUCJPEaE4IhgEduCZ0cP8OnN5TryJwfeerKuUjkgH9lHKY/trGy8eg/Uhjr8lSuYo/SOVOyY7IrGSdizzadxld3e34Hvqp3BpHKTDR6fM7EhncCiPn3JYeFm6VJ66sGjTu+yAWJZLtdM9VIghW0XbqalnaTyUehcgbq3sPdCU868dl2kEMqY0vkyznQrDt5zP1PGpql08qjj6YaObqbfwTp5Y2fwaCiegOkwC10O1j66HqznVeYfVu8y66OILN5XaHuMOfEn4Fi9ee9Gg2MDl6X8DF5WY8n7trwi3xRRHRZ+ZtdXUTnxQEspkvDUDY37KdOrp4sW6WEIIKHirMkFjCM86dPQEMvOYyToUzhdHzG9XvebM/wxm3KN+bKWY0rTngchvJ/slrdRTSrVmOfg1TXo+0hAugfpn7JytdkNY5dv4ix2EJzZ+VxYZ4zUy+/Q5OpDUuqmlZhW5hGsOpB7/OsAI3y4E1KhousIIOU5mZlV5TyghlMtNkUj5tQQhHRVb4UcFcVrqwSdcdw76xGRiV1+E3uuNpd6rQp6wRyunErUlo+Aw2XY+G30oGZcRdlEGke1OsMConhLOONvaSbIVkK5URezfTS0iZaE8ZmoOakUjX8VjQnNrtdsYqwQ
 L7k1EEpg
 sSXDXsmRohUGc1lyR9vad7LselnL2rJ9125OZ/AXwOiFFreZBEUXaYQTDDuiZ4BVZ/P+Rw9fo3Kb7GGuRKcAupmh/rM/5CQKYps8r2Qve0FPv7/P2NcP40lzE1uJg+OtFcVVAE1Hu3iW+D/abdLKktTsaD5sssYTJpKA2sxKstProFJfe/sEqk0b1zuKdeGHxzvo4w1ydf6LHMoZx++pedtOWieF0/OL5Ag27nRZAtaVi7hD3Hn5DVd4V5PngvlY4sm9S65dBz0Q7RpY1ondb6q+m1RGBPStud3JmAJhDjf4/pwHIrfELMTbWUfqLfU9+BCIp1CzPp6GA65vGMke5Zpmd66RLoFiWYPTuAk1ldkWvLt62jikBbpmWWtBkWOF3UyKRLXXuXIzhsJ1N3jSfqC5SOMQLWFRs3+wNIQck0JlJbUHhfaYO2MW6le7HK7W7qyZigewPCAQGmg92U+8YlPhx/i+sSHjT6kUqVF8BTdkyC9sW2YGd9Lhh8zI7Y0v729uqJ668RzpIg6yLxvtbUau8/IWR9LBaAQYsuYMl4J+koBnvxychD8PxP2msvX3xWzZkEi4j8o9zZH2iLIpg2jna9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Save the ACS Control register in pci_save_state() and write it back
> in pci_restore_state(), instead of recomputing the ACS controls from
> scratch with pci_enable_acs().
>=20
> This makes ACS symmetric with the rest of a device's saved state. Today
> pci_save_state() ignores ACS entirely and pci_restore_state() re-enables
> the ACS controls from the kernel's current ACS policy. As a result, a
> device can come out of a reset with different ACS controls than it went
> in with, e.g. any controls programmed outside of pci_enable_acs() are
> silently dropped.
>=20
> pci_enable_acs() runs when a driver binds to a device
> (pci_dma_configure()), i.e. after pci_bus_add_device() has already saved
> the device's state. Refresh the saved ACS Control register there as
> well, otherwise a subsequent reset would revert ACS back to the
> configuration left behind by firmware.
>=20
> Devices that rely on device-specific quirks to enable an ACS equivalent
> keep that configuration outside of the ACS Control register, so keep
> configuring ACS from scratch for them. Do the same for devices that have
> no saved ACS state at all.
>=20
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: David Matlack <dmatlack@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918200640.8870=
30-1-dmatlack@google.com?part=3D8


