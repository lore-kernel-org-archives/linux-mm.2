Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 048A4C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1881D6B009D; Fri, 18 Sep 2026 16:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F126B009E; Fri, 18 Sep 2026 16:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04D8A6B00A2; Fri, 18 Sep 2026 16:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD1E26B009D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:13:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C0F91A0792
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:13:46 +0000 (UTC)
X-FDA: 85227983652.18.454F6E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C1A9414000E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:13:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HyCzK9W1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762424;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4BHzfgU7NlhiaeoyLw4QIVrcWHr6+Q91E2JaLOkHxcc=;
	b=FXGf61Zty1KiRYTx+BfyF/1iqvAg+FM839W3tgKwdV/jp1k9E4Wu4qko/rEGNy0bjbEWyl
	B/CnP1AAR33rlz/i2vJLurh6IJzA1aCVveLX1Y/Sb56tXm1cHgV4sz1z/76a0/CHvy+PKs
	U0Sj+Qz+BD4km5wo8aMA3v55ilOgVM4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762424;
	b=77uWVjwRkRgoSPBFtMNxUnN5Y6w9uKBqhDCvm3ckuN3Wn0IJDVI1nAostxRUG2XCEmvAs6
	zM/Js8TFBXTRtHTprjvdoMAysXxC+R+RV+pyAR4pw42EDDZnVtA7OlRKKCYw1Xk77VCyAP
	rK8nK+dkWhmMCUAqD8htIGIT4d4lohg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HyCzK9W1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 56CF3602CC;
	Fri, 18 Sep 2026 20:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916F81F000FF;
	Fri, 18 Sep 2026 20:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762424;
	bh=4BHzfgU7NlhiaeoyLw4QIVrcWHr6+Q91E2JaLOkHxcc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HyCzK9W1dXl+/YzMV88nR47sMs1YSKPOm7r206nkfEqmpQfxEqtGNi3uGia1CiCBy
	 58AvHvwaIQ+5VvMMIpang4tGjgDjDjJJHMlILNjF+5dHsU7BoGwhL8u0ThDISYllWa
	 7jwOzqBUcYKmKJocF1NyOwvZClXirVEzLYh7xCASXkO0Xc7ZYgKO/LgUzZj6HR1apQ
	 fEFmh0X2YOQQ+ddXCNBoH92KvaJYaS0WTY5IpHpB67cYD40enYMIXjOOGUAXE3Qvr/
	 zo/uC4l4oyXj/Kr40at8aj+ZgiYbrX4n5HubEsVEjViWcJitj/xiMzVDD9pJJoNy+4
	 om2D0s+D1QSlg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 09/13] PCI: liveupdate: Adopt ACS controls in
 incoming preserved devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Matlack" <dmatlack@google.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Alex Williamson" <alex@shazbot.org>, linux-pci@vger.kernel.org, "Pratyush
 Yadav" <pratyush@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Yi Liu" <yi.l.liu@intel.com>, "Josh Hilke" <jrhilke@google.com>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Alexander Graf" <graf@amazon.com>, "Jonathan
 Corbet" <corbet@lwn.net>, kexec@lists.infradead.org, "Adithya Jayachandran" <ajayachandra@nvidia.com>, "Leon
 Romanovsky" <leonro@nvidia.com>, "Pranjal Shrivastava" <praan@google.com>, "Chris
 Li" <chrisl@kernel.org>, "Samiullah Khawaja" <skhawaja@google.com>, "Saeed
 Mahameed" <saeedm@nvidia.com>, "Vipin Sharma" <vipinsh@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "William Tu" <witu@nvidia.com>, "Parav
 Pandit" <parav@nvidia.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Lukas
 Wunner" <lukas@wunner.de>, "Bjorn Helgaas" <bhelgaas@google.com>, "David
 Rientjes" <rientjes@google.com>
In-Reply-To: <20260918200640.887030-10-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-10-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 20:13:42 +0000
Message-Id: <20260918201342.916F81F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C1A9414000E
X-Stat-Signature: dk9z6c8uachkgyywo6ngrsoawwikn4wn
X-HE-Tag: 1789762424-606317
X-HE-Meta: U2FsdGVkX188bxKL4jF6v+nv5ZBprIa+tGEs3q0qpmrX52T/NWtDZhDPLC/zvR2icNWUK6DMPcRD/WJW40UmkKW6+fFP8xWfmbzxnorOcpqQOW29V5I2X915MXPbm/pdJ9JXznVko+uYSBYrQHdR53O77trlkUrR1DQKx6zvDAKj3F71HuXT8Wfgo2AUP3AhDkWjYtxJ3O1YdV8hVVRrm77PRgJRNh5buGO5vfZoMYsw2TDvAv9wuT8IS+giS0md/eJ166F2DW+XXalrbqYqNRvHlYU6zxjGKSV0j2AiU5yvp1AHNpE5toMWW4+8/EUf1R1dlTnBdq/+eCG3GqG+mTUwbup5cyRdvwQHdECk4UWX0VgsGJhYjUwAdWW2xbEuAHt0pBk6sIFARUw+IULZFZTk+QqWpUzVzB0KzSAj9qVBr2VGupQmYkU5Z05EO2xV+QQXJq6Zj+xeKvCDc0WefHB3lMR5/Pvw11zCCpb4cVbvwy4MnWnUJ/tl8Q/8lpb7u0xayb6OCUxp9GWWlmTxgIqaCui8NkArbYW7KdsmEtpqmGyplJWaXhB1RJWMfsxdV90m23PGvd9ToA8QkvZgHEuGYXPt5LAcMqHwvo+uMjdQc8WJuVWVYd8NNKKYsQmKUJrDlbA9I7yMixqLNrZwszfe4UAn5sZj4xT3NjZN463lYwn4grXeN3iHG+woODfxbLP6+XiOOAubf3M8yrQFWkpHihPxKVRAQdOBEG15sVN0AWAT9jGaEwU9B7CY3JTycIp3DJUuI/diUkRC0Vni+3jkd2oys8kmsQZfdoT7CNY7JbgOSEKQRvC9M4xVKy4ZFS5tyI65byRqbDuDSqTUpK2FA6XyPT5QMkcAhOQWkXXAE+DZ2+dkeOthNEifTbffuTjZMFNDwTl0BnNvlB8+tjRKCKFKTeEjbTN975RS9+3CumPnBngYZYnacUyIa2erqHOPHvSxqz7pcBOhoRW
 B/wEyGNJ
 s53En5+TSWrPyTTVqqdM5BD7ma4BTF2waNCgl43dCsi5Hp8pE6RRY2tC2WHQSgrMqSB5mKwYHI1Wt5pj31SY0zfpqK+1m/+Few3F5jFEV3Sqq19/Yh3wJe5X37EQRWqD7xp46LniJjQCDD3q0dpJKXYfeS5R17GS3KKcBT2W/aZ2f0WxJpQ7F0sFCACtOym9yMPrFLMArCr6LOOnbxZCSUR0zYLtdnE1UDmBEOqBTadqzwUBWdCazw6yItjmZyo8TmWKX37O2ZduOF+VEz4HH5kcQ6970A1m9YA4JrFASaZwAS9ggFo5p32qhbWea/3hXns0kQpOptMuOFCHmuUNaKTPgMf5jaQWWARz3gerCZGVh1eXGI9ZckVWgmMVr0t6o9A03aT33DZOXLphzQFdnp5WRvzJaO6MFmaFpeF4rgPji4CRE7FZ9VyyI9MQUC2t4vYGYkEjrAOilHQyWupmwB5r56Bhiu11t2AcJYxrK+eoavyAT6CMKTRzuouD8PmBIoUKLhAgOs2igsayygZwuN9ybnsU45+tS8NsoVm3VW+80Frr9HP7lSsoyk/wNDKcs1wQ81CJY5c/n+Gtt4trTW4g1bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Adopt Access Control Services (ACS) controls on all incoming preserved
> devices (endpoints and upstream bridges) during a Live Update.
>=20
> Inheriting ACS flags avoids changing routing rules while memory
> transactions are in flight from preserved devices. This is also strictly
> necessary to ensure that IOMMU group assignments do not change during or
> after Live Update.
>=20
> The adopted controls are recorded by the pci_save_state() call in
> pci_bus_add_device(), which runs before drivers bind, so they are
> automatically reapplied by pci_restore_state() if the device is reset.
> If that save buffer could not be allocated there is nowhere to record
> the adopted controls, and they would be silently lost by the first
> reset. Program ACS from scratch in that case, which is a better outcome
> than leaving ACS disabled.
>=20
> To simplify ACS inheritance, reject preserving any devices that require
> quirks to enable ACS as those quirks would also have to take Live Update
> into account.
>=20
> Signed-off-by: David Matlack <dmatlack@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918200640.8870=
30-1-dmatlack@google.com?part=3D9


