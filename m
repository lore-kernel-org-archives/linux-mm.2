Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5A5C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 11:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FDDF6B007B; Fri,  8 Aug 2025 07:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AE416B0088; Fri,  8 Aug 2025 07:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19D816B0095; Fri,  8 Aug 2025 07:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 067BE6B007B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:48:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8CD11601A2
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:48:47 +0000 (UTC)
X-FDA: 83753418294.21.5DD01CB
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0FF7F1C0003
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:48:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KlH2z2/S";
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754653726; a=rsa-sha256;
	cv=none;
	b=XXml91dhH2muofQ4lca+rmYXIwVmg72/pOYZWNgsnLljSFFtEUnNKZuCHnacmXp+4H7U7v
	HLYPv7o4dwX5XkQE41YMmuXmL2HtFxnLoKnkHac/EfAXo9z8s25tYCdIYglAJYTWsErm5b
	Wi1dpX8t1o71/JBKDlzhmnObRLiAnZw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KlH2z2/S";
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754653726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:dkim-signature;
	bh=gYAXWo6twhMmTQmsSMogzC8jrE3F55wbNU4ypN7F78Y=;
	b=cjb6LMuIsdQqclo/ToJLKgZStUZrOEUFLk8HlFTW+3bQNMQoCGtA5z9k/8iLgR5kDDx5us
	xRLXBMyankv/e1yfgZRzH8Z6JYn4J95gIgKOnU8os0WADk23hsH0sCgA0KTTUkmbkUlk1N
	iC0kZMn573cVwMD07Ig2IyrH8R5VOmk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 20276A567DF;
	Fri,  8 Aug 2025 11:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFFEC4CEF1;
	Fri,  8 Aug 2025 11:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754653724;
	bh=FUx4gUgdyZ2ZZBXuzAMKD50bvkFnEcWtdMYMuJy1cVM=;
	h=Date:From:To:List-Id:Cc:Subject:References:In-Reply-To:From;
	b=KlH2z2/SRGW4K4fN/lCfwfHAWCLsioLuNXYi0U8bGmXfTGaqjSCRwOhCs4s6TOA0J
	 7X5PzrzWTGmySfiKXxgGxB0TXo1/sEh2IwxOimdqCIM5itio7QuZye5qUFhTiowsro
	 g9QGixSNwxKrLcq5ITi3jqk67TuJhrezSoeLBNFz3QMy7WAmsXR3PnPszSWAp/YNRf
	 EpX42Uy/odYqRyAa1Gq9Pu3xMZtrRg9Wroqn8PxqGIn7GoY01TQOQU0yKZO8i1uzel
	 dv/TdTFEOVjWt68sUn36VVGp+5yBeS/m5Bp5b7ElzfFVkSOFUCDepl9vRLQpiKGtKo
	 ASrYLKLOSRMsg==
Date: Fri, 8 Aug 2025 12:48:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Deepak Gupta <debug@rivosinc.com>
List-Id: <linux-riscv.lore.kernel.org>
Cc: patchwork-bot+linux-riscv@kernel.org, linux-riscv@lists.infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
	lorenzo.stoakes@oracle.com, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, conor@kernel.org,
	robh@kernel.org, krzk+dt@kernel.org, arnd@arndb.de,
	brauner@kernel.org, peterz@infradead.org, oleg@redhat.com,
	ebiederm@xmission.com, kees@kernel.org, corbet@lwn.net,
	shuah@kernel.org, jannh@google.com, conor+dt@kernel.org,
	ojeda@kernel.org, alex.gaynor@gmail.com, boqun.feng@gmail.com,
	gary@garyguo.net, bjorn3_gh@protonmail.com, a.hindborg@kernel.org,
	aliceryhl@google.com, tmgross@umich.edu, lossin@kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com,
	richard.henderson@linaro.org, jim.shu@sifive.com,
	andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com,
	atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com,
	alexghiti@rivosinc.com, samitolvanen@google.com,
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
	zong.li@sifive.com, david@redhat.com
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
Message-ID: <09081487-89ac-4f8d-b9fc-e563f09726d2@sirena.org.uk>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
 <175450053775.2863135.11568399057706626223.git-patchwork-notify@kernel.org>
 <db4eb976-693c-426c-a867-66cadd3dd7d8@sirena.org.uk>
 <aJWz82F21pVTSVJi@debug.ba.rivosinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="D45dRbRxMwDeSA/W"
Content-Disposition: inline
In-Reply-To: <aJWz82F21pVTSVJi@debug.ba.rivosinc.com>
X-Cookie: What an artist dies with me!
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0FF7F1C0003
X-Stat-Signature: a7mwonxk9d61ta3jeoqoia3gika1gte8
X-HE-Bulk: true
X-HE-Tag: 1754653725-955207
X-HE-Meta: U2FsdGVkX1+CFRa3PD8EnlFhoFOeQbhYlHDfh88N0tX/PoHAukL6DQ4pK3AM75Si+n8lmBCfCTD6t8YYq5RCJo9jjF4ReBCUDHWUXHgYKYKRifN6Y6KyU7wRKKYRHvFAT/8KWS8SQK0ERia44a6bYUGnjLj5la8JBwTD+nb6cjggKzMt9JRgwkqVwqww2rLx0bsZpdaEv6T8/k6rmcFXwn9xjNPLJKHyP41JwHPvjc5pSms0AA0kbDS3Tp5+SrJGtFq+T4MTzS92yrjIkMN++wOJVbxmyVBSQSjAgdNoYoFUAFnl1zCE/+YIdxzFbM/WVF3Bct0FKf0p6DnLX805CTmVWKDoWESKaVvQXHvKlc9DYaYGjBdOO2boAwi2pVNpU3HFVpGDm4piJc23yUJuvPBkUfsFN7U4aAGuVsfVk7Rp4tvNV17wkFQI8q3HELPazMTae/y4Zvh2knL5+10/TBrWa7wBFLqWlCZuIpoiXe5nVS5g8rDeQs2XaLHNJ5Zf2GgSy7BSeoGkMhGMMC1dHGaHPdasRHIyVOvhX/pxkFYmPoilxM7RGCt8mFrgvw71Sw6ZpmRcCcOS3jev4XEcqBsymAmNA+JHrc4ysX+aVAq5OY6VjGHsymQkLEdvJdSfOSAwWfN6tdme5JxJk4N/kPLK3YpvCfr6ITyRWpMJm7dgN04jjZPrxi6JJ+UYORvggjQLDSNUqlktPihTKVZ8vrIUMHckdrWBsL74b6An5AsTHSRrS0X+k0ZKmc+ruKTqg7NnJwr9aHQ7CbGoTsPStXXtr0ATW/ZLyU9DS44xhk4wuCbxWIkG8ajJyTqc2W12fZ3RKcHOLOBC4ZPsUI/aYOWPw+JFEywQIzUgbWiczZjyvd6n3BvymAFHHvWO4u742tjDmBpzFxfW3y8B2IANwSSqlYLUVunTG1IVLW3cpzbpCqC+sGIt8Cw1tlqo+yJqgB/2eR0f8DG0EmeVDzw
 9ZOO2j4V
 ON9qAerUeUGIi0l12BHUNvm8zbbTNe3ZiQuz64ZDz0POuP037mxRAdhnay29XHCQ3mhdHFToTUuftIvC2ngFGq0G00cIquZZIejTFnLxF+vTleJr6jYzaJT45dS6a8aw7VNdSPNXq5VtKPwY3xZsm9c3BNRCquQtD5s/pT7592cc+zE7sWtL2syFE4pzcFF4UzC0zlgytNVhe0gUr3LM7fvwKUEBuFVPvMivc1cnpaJVOA39p/A32sCuNS4JjAzDNLRNHv9B7IEyN2kR2F9xUAqlybUw1QLv9hJ3fjnX/2uaE451b5Ui4oS/cF4N5D+Y35eeu0Gu4OMxHxs2IP9Y6Wn8jl1L/RaQ/BdxvJ/hBtFmArWSMODkfUOaohcQiV23U38ykzOsyAdPMT3Am/XRVBdesbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--D45dRbRxMwDeSA/W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 08, 2025 at 01:23:15AM -0700, Deepak Gupta wrote:
> On Thu, Aug 07, 2025 at 01:28:36PM +0100, Mark Brown wrote:

> > Do you have an update for my clone3() shadow

> No I don't.

> > stack series that I could roll in for when I repost that after the merge
> > window, and/or instructions for how to run this stuff for RISC-V on some
> > emulated platform?

> I would want to write-up instructions. But I don't want you to go through
> a lot of hassle of building toolchain and bunch of other stuff.
> Let me see how I can make it easy for you. Will report back.

Thanks.  FWIW I should already be sorted for the kernel build, unless
there's a super new or specialist toolchain required for this feature
(I'd guess I should be fine for the shadow stacks bit?) - it's userspace
and emulation for the extension I'm missing.

--D45dRbRxMwDeSA/W
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiV5A4ACgkQJNaLcl1U
h9BR4gf/Yvc9us1uldFqSA9g7p+0bzU3IY/RfdDdME4qVGVWWXybW7b1P+6OdvKr
lRLLeAJQkpEzhtLNeXXTVgRijmaDgccqM2d2Vkehw9qrW1+pwA56PX8PQPBtJsGL
riODDRX0jZSrSVAPE/mwrQRc97vY83Tme2w2Psah2FzICcRcLdsC9vz3BIsquWgp
5LbvWFyIS7PraLBoSkO76qBYDtRwjw3LzoANXm5rYo9QKsT48UPgjfvmzxLqTSxT
oDMob4PjC2+1FU6Q1yzo5CUyK+aX58BM0OGwWEq4DDOCu5kd0ltVJen8HWszpfVz
YgUpgySyAiGsfZTi1JBRv158syBsdQ==
=5/MC
-----END PGP SIGNATURE-----

--D45dRbRxMwDeSA/W--

