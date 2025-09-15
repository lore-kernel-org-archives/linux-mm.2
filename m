Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49BB1CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 17:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B09B8E000E; Mon, 15 Sep 2025 13:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988448E0001; Mon, 15 Sep 2025 13:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C52B8E000E; Mon, 15 Sep 2025 13:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3D28E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:05:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35725BAD00
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:05:38 +0000 (UTC)
X-FDA: 83892111156.21.4BD8B6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 871E3100018
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:05:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="C/zc5hBL";
	spf=pass (imf05.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757955936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCcSyLKtRBEpOKVEnWbAIl+bl/ydhsIKcxdyT8tetGc=;
	b=o0G0NbkkYDeXhUKwM0tbO25GPGS0Xk+9G3Dd8ecckTI5pZxC2bPjyu7KLKuegcs0PSX5cY
	HvjebfyOEmQWKDyjExPPBhkKfrmemBE6CV2SWeGWxK18ERJ4sBBCzxhXLXZIVZxjSx7aVg
	UHdjUcgODTM3n7RtAALhC0E0dEQK0lg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="C/zc5hBL";
	spf=pass (imf05.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757955936; a=rsa-sha256;
	cv=none;
	b=5qEzg32vN31xFmL+Rkn6Vs94lUQ0cPmZ0JqS/V9wRsSWg04bBdr6QPqg+yMLPWgfgKZXAR
	uIl/ukdjWNmujJFoVFPuFRSBUkf1iB+SSibsHp27C1z7llIi6PjrSj3E96f+nI3AtmOG2k
	kaI1L4vJOfINI4aJihwXoc5FlUF+qVk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 732A043FB6;
	Mon, 15 Sep 2025 17:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836BFC4CEF1;
	Mon, 15 Sep 2025 17:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757955935;
	bh=QCcSyLKtRBEpOKVEnWbAIl+bl/ydhsIKcxdyT8tetGc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C/zc5hBL1H1uKA4zJpx6r2zWCbmwpMbns8eHIZm3ik363b1+81TX9PT1Et+dcMVca
	 w5QytMmZb+apJkySW4bNBKMo6lJ3C6r0mxa9HhzqitrKeMYletMYV0wimqQwlVQoXQ
	 N6HxFlT+W1d3WFv+EgRZu2E7FypYIKsgnAr6I8ouQlHTgB7epnj7gUoxW7Zh4VeH4L
	 48iv8rQ0flOx/+9ZQi1ko6TpmEXZAgBJqVM/I5UYFPfiiqr0i+1sQJwdfZ7YYx4dYz
	 /bUezOy7NhnEmdEHrIp8RvW0e8uuL4z1ozgWA0KqTJhdZfbeEkNq5C3Ak9Jr90kdqW
	 vtLU5IWoHfkhQ==
Date: Mon, 15 Sep 2025 18:05:28 +0100
From: Conor Dooley <conor@kernel.org>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH V12 2/5] mm: userfaultfd: Add pgtable_supports_uffd_wp()
Message-ID: <20250915-borrower-crusher-7a9e9121a1b0@spud>
References: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
 <20250915101343.1449546-3-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/gi+eTVpaGnrTG3f"
Content-Disposition: inline
In-Reply-To: <20250915101343.1449546-3-zhangchunyan@iscas.ac.cn>
X-Rspamd-Queue-Id: 871E3100018
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: x3eewu99g6kupn7atsoz7sc3j1g8exot
X-HE-Tag: 1757955936-533462
X-HE-Meta: U2FsdGVkX19RQ9rR9PvaCXrmANefmf0Jf7eKUxGYPgv6Vi82E1SL9+yWYyGSyz9HBoSrORQ/xGDNWmnGl7Gn5xd0U9tjM9Et+8qu2315QeKLjPfTe1NT/IEM4hjNUFjpaQIqp5djor+FU1d+uRBX0KsEntWOjI95zMU+FnTlcnQOXNfNROpHicNXOJCNv4WhKVDqR6RTi2mNAJTfOTGftUtMaM6r08h3iCRF3r7zohHoqCDZn2i4CmQqXMlsB02ym68yTgNz0meipaapSBEdS7ERXa96mVr1xEQIp7pP9G3beUwjFXr/HsK1QRNhxoEL7D8jDvh+Hwd1eWqfxsgN7oJGB9qhuYuqPRufQhv0RvZLARNw8HsqPhuDe5JcJvuHV3Vk0PLew04YbnWu3HeIdk1kx7HpCnv5AKrCeKOR37qNCfz6M2tvTQ7YBHmroK8rhRe5TQbz2JCGI/27+T9M9H7kCVDV/nXS7rvHhmNohVy7ZxTr72TrGdHQDHK+skjS/duNgUB37Xpnl7H/GASv7Vmu8l2O+h+u+T64AUjD2VO15LeIpLYNoDsVTy4wmgms0sMiD44iMh2nm2nfKt/4nD6gyuSIVBz41IhhrUgstQmY5+asWZKvRLg18O5sq/Fxeo+SIXDcf8Mwgytbv4eRf3i9QQ2dUnTGXdXlQYfz9f+Lj8U9CZUuxGgU0lWWaN5kn/nwKY1yGDh3L6ZZZzsCGHqe+w7rD3RKVUhlBoYS2iD2OW05HnvdeNP26kFLbsRVWd6hfIuugZlrjcPBoIpisEKfhJjpVNtt8BBOsyF6lmN+CZjOB7ZISDGM7E8GpcI60+yciYQgC5ceHBwZ6MQidaeqiSe54gSbrq4a3De4e10DaaPpLUJLYO3cGhCgNXDDwv+tgCzDAgwm1M+iBptjGLKgcdPYBOu4GjCYrXFsDTio39IpC+UCHyoCtwFvYUi6eVHUntjB3xSo2/B7gBW
 NScT2494
 evKG8w0h7esiJBlYYcl8ATODQxCDboFbHTW4mQ/mjXQGHFGqx3vFXPJvo9uTToA4tfNShVOhMbffK1JBih1j8jvZ7fqaUeDH4hE2ZV2pQoHQ8RGX4/DWecvPdHQLiROsZtGf6zDCojJPTYN2fN1yngOGmb6TNzK4ceaIEdVkM+iUuzi+oyZeZO+QYwAQuzPSPyomEoXY8ex3FgA69drqwtgWhBmPHN7S1BgnAlpKkLN9iYZ/zm4PY/KMZMohsXo7LzhAMDfuGnQiOWXM5bWK4sKhXi+9cqOYV5D9ztcxEH8Dvj8jc9GZJ9bIZFWi0I9BRPi1OlkyoWcudWgh+9Hes50yw85jMunjVpG83TixOftkrFQNXLwQbGMES4UebAgOkLf3JZ6bLJFycsEf+e5ii1uc7FgGr9ZJQjzSdPMDjcR9p+4T3slyLXK3phkTF/GtK/Bk0iH/ElxYVGuH4WkFYj4xGmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--/gi+eTVpaGnrTG3f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 06:13:40PM +0800, Chunyan Zhang wrote:
> Some platforms can customize the PTE/PMD entry uffd-wp bit making
> it unavailable even if the architecture provides the resource.
> This patch adds a macro API that allows architectures to define their
> specific implementations to check if the uffd-wp bit is available
> on which device the kernel is running.
>=20
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>

According to patchwork CI for riscv, this doesn't build for 32-bit
defconfigs or the no-mmu defconfigs.

--/gi+eTVpaGnrTG3f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHQEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaMhHWAAKCRB4tDGHoIJi
0g3AAPYyMr0sKk1q17lwf8rI9IXyUkgSilhSi7k0qTds4n0KAP4iPiualM+L6H88
quoylo0zyBkFOvt7aPxdrFyH/BhuAw==
=Y8mB
-----END PGP SIGNATURE-----

--/gi+eTVpaGnrTG3f--

