Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EE43C982C5
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67FE36B0088; Tue, 15 Sep 2026 08:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 630B36B0096; Tue, 15 Sep 2026 08:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537B56B009E; Tue, 15 Sep 2026 08:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E69C6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:07:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1F951C2434
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:07:20 +0000 (UTC)
X-FDA: 85215871440.21.7B916F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 335DA2000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:07:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TTE6T1Xf;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474039;
	b=6wN8iieCoLx4/yPzb4Z9cBlxP2GsDE6S7PR8z2AC9FSjeHi0zCSMb+z+fxwBuqVWj0RYsW
	qjM7YJVx6cf0THXry4BpDNZMHEliLnYDyTQu4rlu0AFKLGsa9CVtJXIgo9xwB6GhrtEB2a
	8QNFyhnpTl9whs5Yq4VFMA+QLxyrLio=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TTE6T1Xf;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474039;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Lg/vD+u14ITJU8+go78ZuhkRlXcBzG+UGmK5JLRPZA=;
	b=hT1lKI02zWJmJ5L6beLTCGC08a8FsNZ6txWJT1aHGxlGHqosmgLBB2s4+TTEZuMr8Ui4Tn
	y0NWZTx7wnq0yF5rmn0NI7Jco3C01aGSEHwAkxwbhtK7wNPnuAngx99ZIStOp0iWq9ZQY4
	tKSTeeuC3aAJ/uTkuu+HXKoP38QtObQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A10AC600D1;
	Tue, 15 Sep 2026 12:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F5F1F000FF;
	Tue, 15 Sep 2026 12:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474038;
	bh=9Lg/vD+u14ITJU8+go78ZuhkRlXcBzG+UGmK5JLRPZA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TTE6T1XfEzcNIJ8WFiySWnwQP8yJBWzCe+zXTpLvevuGzn9lG1wMo6JkmfwwL/Yd+
	 v0620B9v7rVjPwqdf+dJBvrXj/aAzuqd39yYhvfUVwF6Y68DbvQH8k6e9kkxs5lDOO
	 T8fcWkBPfS2hGnM0lvlb7z4+ZX10iJvVylZm/YCij8A1eYUDStsAMbhEWNr7ZTNW0K
	 d0wxrxeE8FTve/JAmJz66C/VfP51gl+cT2S3btyqcJ0w7YNf/OBOpnS9KLaOzdPK1Q
	 PzvyZfSsvRdUn8CutJLqPgs8jEgY3WTHPuRHCKpcfiaY7lO9YqAql9ka1D9FfKpgP7
	 bePqW74CAgyKQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 31/50] vfio: install the migration data
 descriptor when the ioctl returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: kexec@lists.infradead.org, linux-csky@vger.kernel.org, "Jens Axboe" <axboe@kernel.dk>, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, linux-mm@kvack.org, linux-um@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFt?=
 =?utf-8?b?dXRhYmxlKQ==?= <brauner@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, linux-sh@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-openrisc@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-hexagon@vger.kernel.org, "Oleg Nesterov" <oleg@redhat.com>, linux-snps-arc@lists.infradead.org, "David
 Airlie" <airlied@redhat.com>, linux-arm-msm@vger.kernel.org, linux-hyperv@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, linux-mips@vger.kernel.org, linux-m68k@lists.linux-m68k.org, virtualization@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, "Jann Horn" <jannh@google.com>, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-31-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-31-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:07:16 +0000
Message-Id: <20260915120717.15F5F1F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 335DA2000B
X-Rspam-User: 
X-Stat-Signature: exzbnxqykke79rwz3hymcekbznsxxkkq
X-HE-Tag: 1789474038-772645
X-HE-Meta: U2FsdGVkX1/e+uEGke/dbBXm/CF8Y0HzI8/JR4lUT1JXB9admUMysB7ZuxYJIXN0YO+oX1deUmfvgIIj0Q71+q9jB4EO/vexTh4jXyq3M1lC4cKlAl3Maf4193GO6DdqTLYbhZNcmmepv8AKUoPDB6LBgc1sUzemRXacQyJVMgdXpUK3A05gAtnYq1CfvsXyshUPwKZmKSKCxoaSVPEP2dfhc1Go0R4miFF2JGphXaEQJtSYAofNjS49+iDioZs4auI+ZGaSTB3W69pFtkK9DmHWW/PT8JAGa/PbPzkHXrNKxIxTSbx2StGCggsNJrJ8IBa3MXrKhMN7as/mcO1Y4eqCM8VdJt+bCkwt0GRmRIHsgL2ufo/xG21FW40Ygca6Zc7UUy0CglXDmZ0Wlm+SCCtfVRVBGuwGuPIryN1qCbwoY/ZGx4cYohJIJdZiwvgD6AE1LmvVrHH7mtYdMBvIG0B4ga9YyyIE8k2CHiaQ6qCIonXx2FRBn8oj6J9aH+TISxPiAUpY+qDLTpyFPdmc+H9qez7rYtUhs5/0GJVHumwSNOcNHgqfyS5hdCLfIR43UHthrPx4keiJnpZxS493XG416WOJWiJk4V2ECj2QL1j5LXuxGGFhHOZM/oxXejbDh28P05ZWN46n96mlbSvMStue0t1+mV8lgYp9u1ZK5SNlrUupo2n17+Cq5gy5OlPb2Yp/CoaqQNN0njAoWRrUbeju2PkIF245PSG52barx4hWK40twQnAXgKrWc85cliIBqEDlcRt1cEyFZj7fu5b74iHf0BroALEO5DnCpX98MbQ+J5I+fPjvRvcAJV9Gn6NcAI2pTuR+0v3Pn2HFL9FQMHPyjRG/rBiOxC+9JyGWQVUHpZTQE3EHRyUEwLsODM2aTPCbkdsIn7gWFp464ei18SMA1/EcLgSAxXH8kLOCMQ2FQfF0YnPn+UFgQYq267fEdjRdm9o1L46RlfXS7p
 5y7Zb2U2
 K9QuE37+k5VDhj9ndhWQahqdwiFBo6ObDDE2hN4pjl+buiY+dwc6NvFWNWDYCeBjRBJMy06WXEOOJa72gdSZzKg1ANaeMm8VdmQBOU+X6SN+Wii+o4gJ+Z4cWEtXyXKMpvCNzzCbg5UPJwPC1+9ZwDoD+XdK3Akwk4Xa9ukiURD2lAlcA9cTMPUhVgJSEX7HYLTeEDXzsVzaCA+IygoaKS7QJfPUjCpix3eb9NaD43X2v4R3P3TPPe3J8jynAlK4xmsLmMR+nGJ17poGzeMZtuQU+dWLH/lSdS4ZHlHOceLQ6ew3h+1zNkmpFm+9NRplfoX/A4BdQEbEt4V+Op1oEMEslA7XERv8f/2FEfs7ZDbZxyq9ONfzLZu+zAFvIfw/PxReSKztEN+fJHNpLkveopXNele59dlz5hVcCBLensRWyPCYpU4aHDwwUm8W39uDM1l9KCny/MRsyoiQwhbXT4buOL1tWXG8itaHJxSW9h2G/kCxHZRBfpzPIkG0KyrjrjpAtMU/7MX20nizLA7QnTJ5ZWpqSGRDrZWfRK7Yw5h7N84kyYNixWsZbm4DH96O8Xkow0Bb6gbKmVFHB+ta6ea3RTZwpf2WkXzIfO0Tv/fG3BL+IlzOfUllaofslAySCRSbyjqXMGMVvPz/uy2l99EpTIzMRvRYmnt3bL9D1Cn6sf0tit6MpfNO5LN7GQif8jaOM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Rely on the fd exit path machinery.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D31


