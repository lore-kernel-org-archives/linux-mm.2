Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22DBB606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJfBtafa
Received: by kanga.kvack.org (Postfix)
	id 9FDF26B06D3; Fri, 13 Nov 2026 06:26:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987C66B06D5; Fri, 13 Nov 2026 06:26:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850926B06D6; Fri, 13 Nov 2026 06:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F2336B06D3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:26:57 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E79DD801E4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:26:56 +0000 (UTC)
X-FDA: 85429868832.07.FDEF066
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 45A3FC0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:26:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FJfBtafa;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794569215;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocYzk3NdaX97htiiSe4U1W+aFJaGGkLHqzJNEk6MXeE=;
	b=2hrwb2kOVuyzR++X5NDI4+HpGO+dvjtGxEUK5xYjj65W2DEQaQga16t54HDqoGYFjyoaHU
	KYSdUOzYYmcyr9MBqVMFF8/UplwB91b3Sc2BVgPvQDEtdSSlciqStcntm30oh/2XTvv3bZ
	it1IbfJ8JQx0lPnfndaoI+0RiWOaJrM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794569215;
	b=zTMuLZfh2EOWhzfZuGxsaiGtksCvBuWOgphJ/QrrerUQQ3kVNoeJiamVLFhyFj0lQyNQvB
	16SahLcni6zzPP1KNaTC8EMNGbxgdeqXeEhG/BiDRUyMV811yQmg4XvF/WrA5YmpxL6qMD
	68vzBr3irjw+uakB74vUugX57WN97HE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FJfBtafa;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB07A62710;
	Fri, 13 Nov 2026 11:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAF21F000CA;
	Fri, 13 Nov 2026 11:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794569214;
	bh=ocYzk3NdaX97htiiSe4U1W+aFJaGGkLHqzJNEk6MXeE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FJfBtafaQCnHVBG25J2NxFg1iYV8vtdqhAhg5MeHdNzE4fCZzvk7Fm0nev3/GXv/5
	 y132tppi/C+SC4mvm30b4QJpq5kMozD5hugTJzGO0t/yJ+GndBmY7KMOhkWUOf9AwR
	 XAwrlOtWTFeOjcf1Cle4Ap5Tg+ChSMPLw949sV3POCtD0dSjd02ErdXqmQnas14ybc
	 enkQcfsjP+q5oheQkJ7SirWgAuhSEbCHiJAa3N4v3hsj3eF52wxdHC+lx2ymLfMtGH
	 PWa3Z5ODsKhXRGiA7z50YDyuTmKLoCrewu4BN76B/ha9EjwU8kDEIvKhVEEnBHvkI4
	 lJVEEdTfZsQRA==
Message-ID: <sashiko-outbox-212720@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/6] ARM: add CONFIG_VMSPLIT_2G_OPT option
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arnd Bergmann" <arnd@kernel.org>, linux-mm@kvack.org
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Andrew Morton" <akpm@linux-foundation.org>, "Andreas
 Larsson" <andreas@gaisler.com>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAoQ1Mg?=
 =?utf-8?b?R1JPVVAp?= <chleroy@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Linus Walleij" <linus.walleij@linaro.org>,
 =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Malin
 Jonsson" <malin.jonsson@est.tech>, "Richard Weinberger" <richard@nod.at>, "Russell
 King" <linux@armlinux.org.uk>, x86@kernel.org
In-Reply-To: <20261112112528.1116405-7-arnd@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-7-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 11:26:53 +0000
X-Stat-Signature: puh7uuk788mgafwh1tat4yrwjxxmnwe5
X-Rspamd-Queue-Id: 45A3FC0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794569215-157917
X-HE-Meta: U2FsdGVkX1/+U5ueRY3GSgLEARsp8TqP9r8H0O4OSYAgoNqW585QoNd7IhMG2PxzA9xWBIKKRvCmspAsbRM8zfgtgG9lzl9MBtSR5xoWEZYeo25EJeBUMDRktgLHO0W3BBoMscsOhq7EK7yalF0JP3EHcCO0fYxmAA0JM534fd4RA/UkrMtSyJ5uX63/tN1yPEWB1wt+rer8Zb6bPSwmqDYW1RXlqMB6djnZKEdRwn4I2khM2/7KlDZ+r8ByONM4Fuabw5esnZmGZEOHo+0285AqV5BlZ92Qex4DSh0M6pXvyqD4n2WNZlvkMYQNNTouBSaPGckk1u7YytmT2ueqHJ7/bJfJ2/K+HNAPFHgAuWb8YPAtwJaKPMZRcxQ2wIza2hihNyTJirF6JFT7zSZhJmJ9JHdtDm72o+aFw0PvgiRon9lcAoxC7B58rl64F+8BKL4DSeGmlh3qwd7nzBeKdCRzENORshs6A3s6aQmCTHq0SqomP1DgRicnasG45l66alI3Dn/WhUTAouXVdPmAs76vrazGhxG60cNWvG5bjl6aS4bwyspfNvwVk0DC8d76IDeZmA8Dy7wx9Zj5lxrf9sLTIiBSAArO0ilOfTRAaZcnJjRTl09mXEf4OteJCTZt4ycMFO7S0zHJeCGJkiQFM13YOkKzO8bSUxKCwE98S5DCLIRJsGfuVIWU6YGeTwr4b5M3cdiy76HSPbGlIQEvjD2/7iW55YUXe8UT120FrMqpzPVq8Pprlku+baU99oVRvPocV9FOlcueDKPxo81BgTnO/Y3drEGl3b934QKg5AVjaTeFH5pjidTYBE1st7X9j6n92jOp9Rig/SgWicI57A0O6YM6ODEnKoO7hSv/8m5rtARONjfADWxhCl3TKQIEmpAIVPhBtGPbdjR5fd4Tmsp3bx8HEZK0Zg47wSDmoZ0eLzqo7evkznt1p0SWUXiYtZpj7B1Gsnz7xxCzAK6
 SviQ6nBc
 8nQJQuaB/sJMAtjDSTM9HlxELG7FJBacaj+Ch6liNGispCHoIU0eOQHWS1Uk6QFz2VxTObFHNMVya+uoewHkranVy9ibb9aXcFS4o1E1K8mMV2XvzPWTsOvYytjSilyugjaBe9AzF1YdLZoebaxxMgao/zL6MwvtFpRDdST+v9gPd8nJrhPqqtpXdpIaZZDbrciX2w2M3LyMXoIyUB73GwzyPUWRKd5ghDrKeheFoGDZdI+gbhj00e9ApAHCkorQ0Lg+Na/SzoLIwamT+z0WzdEi5B1Hm/Fnt0rbnvylS0HIUgGL/qTmIPjHGXoTYu8CiU8PHJDYbCaOh5hDrzS+puEyWBX22Oor7EsMM4aO4F8Gi8PC2Fzo57qhhBKq5m8EQMJEI2mpP1L2Ts8yKAPAHrKMzuR7vY2wkvFpUIzBDu9hFOStzNoxjrl3xTaPAJHdKEaRBT8JdW/p6AOSNo6eRUleg3GS0iW0/t8f7iC+P+DKHd708ouvefL+/njYPARv1psJZxUwWDdpgPlwc6JPLNwxwGPNqQtOn+DLN/LakppaDw6JHbmTT1JlIeDz2F5jBpyIfDAmk4pYUsgRwyhQyRIvsTjXiRFns4cuhpLaFD5C+6nNX5m2w1gYjNcbNhj4HLbA/3befvKtynga+kl1EL5Pic5JHH71RZ0Ek/kh3ntlj9yE=
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
- [Low] ARM: Kconfig: missing PAGE_OFFSET=3D0x70000000 in
  ARCH_MMAP_RND_BITS_MAX
--

commit 174ed2566532b79fdcb5633054674e730fcadf44
Author: Arnd Bergmann <arnd@arndb.de>

ARM: add CONFIG_VMSPLIT_2G_OPT option

This commit adds CONFIG_VMSPLIT_2G_OPT with PAGE_OFFSET=3D0x70000000 to
provide a full 2 GiB lowmem region on non-LPAE builds, and makes it the
default when CONFIG_HIGHMEM is enabled.

> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index fee6b7435b7ca..17b4da137a8ea 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
[ ... ]
> @@ -1052,6 +1056,7 @@ config PAGE_OFFSET
>  	hex
>  	default PHYS_OFFSET if !MMU
>  	default 0x40000000 if VMSPLIT_1G
> +	default 0x70000000 if VMSPLIT_2G_OPT
>  	default 0x80000000 if VMSPLIT_2G
>  	default 0xB0000000 if VMSPLIT_3G_OPT
>  	default 0xC0000000

[Severity: Low]
Should ARCH_MMAP_RND_BITS_MAX also handle PAGE_OFFSET=3D0x70000000?

arch/arm/Kconfig:
config ARCH_MMAP_RND_BITS_MAX
	default 14 if PAGE_OFFSET=3D0x40000000
	default 15 if PAGE_OFFSET=3D0x80000000
	default 16

With VMSPLIT_2G_OPT, PAGE_OFFSET=3D0x70000000 falls through to 16 bits
(up to 256 MiB of mmap randomization), which is twice the maximum
allowed for the larger user address space under PAGE_OFFSET=3D0x80000000.
When KASAN is enabled (shrinking TASK_SIZE to 0x5ce00000) and the stack
gap reaches MAX_GAP, a 16-bit random offset can exceed STACK_TOP -
MAX_GAP in mmap_base() and cause top-down mmap allocations to fall back
to bottom-up.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112112528.1116=
405-1-arnd@kernel.org?part=3D6

