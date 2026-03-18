Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD38D10775E6
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 16:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9866B02B1; Wed, 18 Mar 2026 12:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA596B02B2; Wed, 18 Mar 2026 12:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0086B02B3; Wed, 18 Mar 2026 12:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81A226B02B1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:22:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25204C2B1F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:22:30 +0000 (UTC)
X-FDA: 84559701660.20.B35D5F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4B5EE16000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:22:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XpeluXyx;
	spf=pass (imf08.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773850948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpUij/boElpxZS1JyC/IIVmLkerZuIkDbeCw+AaRVqc=;
	b=hCP9snrOvFCO4kazcqlF4OrbpFpDiHCB+qp2d1NLko2KQdAYoTbTie4Z352fO/9Lnq+Ebh
	v5w5U7CHWG2Z8/cA/n5hoU50//C0cMM97kgQe2HKPp2EaMqopMg2lxRQ/bOwQSd+eaM8nS
	Fy/BVBgLPXSVO7bQd16XjXn8/BbIah8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XpeluXyx;
	spf=pass (imf08.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773850948; a=rsa-sha256;
	cv=none;
	b=MZvrFFiqs7HXEKQnJRzrhqrusL+kKEh8OHlyVo2+O50G9Ywo6fcgWWVKf6yrcq8UKZwshD
	A4pZdeMJK4P6cE7JhN1/DrzkPsMnQM2/zHY423t9RwMmOOjANAnQ3mTXv9G7QOxhjftFOz
	5leLqUAtdiuSYbHk0g/uv541BSHGxC0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A99260097;
	Wed, 18 Mar 2026 16:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC48C19421;
	Wed, 18 Mar 2026 16:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773850947;
	bh=FGNSu4DlIfiUMZa5ZkmaJp/QIn2lggE4u2Ndygv6FBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XpeluXyxDsZzF3NAmckdqJwpVkaAqttUopjBMOigcEjrW9PG4hOk9bFNjIu2+1hu1
	 IcsDTmGhCVATBRixcmNQQhBpayz2AxBxUoh+MbYsjRcLuorNTLiwBf6/k0JgHJn6Wz
	 raA3nLiznqIL8OBq0mPUTLKCPd5eb3Bv2V64KLPcxM+MrRFRw5yx4UwmNfiJttbMZO
	 J7HUEZM+SLsx9D5/aRBj0upZmqFXxEgFHzFGt2zHtfm6J4HCe4vfApVE0dgUg61GmQ
	 0lp53wfP1tgknNDPDCf1MumSabgXnKYpdnqZftaDNWH4frl/QojAulg09IVXxCoww0
	 l5WkFd3jbD+kg==
Date: Wed, 18 Mar 2026 09:22:26 -0700
From: Kees Cook <kees@kernel.org>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-mips@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 00/15] exec: Remove AT_VECTOR_SIZE_ARCH from UAPI
Message-ID: <202603180921.1B52D626@keescook>
References: <20260302-at-vector-size-arch-v1-0-a11f03ba2ca8@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260302-at-vector-size-arch-v1-0-a11f03ba2ca8@linutronix.de>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4B5EE16000C
X-Stat-Signature: 8gt3w8bqzhq7ga15rpa5gfcf6rn9p4jj
X-Rspam-User: 
X-HE-Tag: 1773850948-842803
X-HE-Meta: U2FsdGVkX1/xnKZpmJtwe2TLnAykcfG8wXIs5v8wBb6geYRhyCWGJYB0JjInkS/wsJUFZs5Oz68j9KRUY+f4i02I7liIpN79id7YLfordv5JUP9v22ctGcRiLXZiskTDFvjQZjUpbDzg3vJmMjZenn8wOcx5jw7MrF22vGNNjtEXlXvV0XG55CSpaaDix4FLpSDiB1vLrSx8GTVlhMkO06/I8vlyC1svCXX0H2EovAj8FekhTPaOHFQvKMF6ivoQugv/54szLHp1NZS5pBp0nA3e8wU88CTklFEohjA2PpyUiTz0r/E+MOIBKBOq3BZl2P1gWq0SMt6pEBq53oST+TbmEBBfO8zQTht5fIY9MB2hRuTfyOfAcNKnIhgzKk4t6RWOiO8VsG/27rrQSbW7ybLtdd9KImMIhwYkIuV6wCogug9Qt2VMYlLLvCObP7jooxqu+j75SkfNOPwKkdR2XZLGFeDFwLENkN2AKIfdSeG4Y2Lhwx7+3p1pcXyOPsnYyJEYRHR1qnMb6IfNsxdHyGS//xgKrcfVsX7dCpSk9hOMThGr/I3DoYn/MedO8L3VuAHhsZdq57zswkFayzxDcTdKcyJea8Jp2MgRVp807eoM3JDMWFBs5C8oSOFXeB7YufgNEUFQ8U6mg1Gydbw0d6K+2EBaWJKq4MZg46KdJgf2Fo52u/zTYXVE1t6ohLYFHerfzyLZQ2vnMOTWbYQwa2d+AgwkF8AoDHpMcoNOcPKEs1VbvOnWz+zek5KMk8mDRXnqjd05aup6n27u3C3DATUB4/ca3Isgcme4NHoleBvWd9ZW9i67/24UzcqHx2Tk1phAsrtDqRlkvzGAJQrzWdmY9cJCLlfETkfNZy4XWMZ7KkGHNO7HA9y5sm+s+Mq0qcE0RFzE3Dn455a99nsTVbwAHj6XZFQs0ggaiPpS7kmVE2B+nRbxNgjONsAGX4WJ8mX2B/CXwawyEgKHc39
 EdTtd80t
 oGIbzx6VuEwrEGnvpFxNPE7iN91/zBPT6BW4ZweFSfo4si617paijwlTTPdeEVHSsBhkaiIbxoQBCMw5/avpfoxQe/kEcz1R28Snth63uDnD3vdNxahU0U8uSk6WQBKZhMgYObNTPk4WbAiC0u46aleCYuSq8a7bNjUUr7NYJ97Cttq3mZ4f4jFwZmtyqNzhCGBmcEWNk/LEETjTZUHYRn5mAc2oA6FAW+oGGQF2FInRceTq6XjNP0mEXDaqDwresajafg+J/32RBJcHvfzWm0eVqqxuk4Ea2YRBfOb6wuLO+Y9HcgK4oKpm41652TeIgFhIJVxZAiikUASdUNf8v+Jx32MpinPN3yfhw2Ss5+L7HBmDGp1J9deUtqPQQzFDR2WGml85MZGeg7SsXj06e6L5QR4IZgkHh6g2uHZT1H3HwxfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 01:25:24PM +0100, Thomas Weiﬂschuh wrote:
> There is nothing userspace can do with this value. In the kernel is
> always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
> userspace and also changes from time to time.
> 
> Move the symbol to kernel-internal headers.
> 
> Meant to be applied through the asm-generic tree.
> The default recipient list was huge. I trimmed it to only the
> architecture lists.

I don't see anything in Debian Code Search that actually uses this
symbol, so that seems fine. Userspace already parses auxvec looking for
AT_NULL, so length isn't useful.

Reviewed-by: Kees Cook <kees@kernel.org>

> 
> Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> ---
> Thomas Weiﬂschuh (15):
>       MAINTAINERS: exec: Add more auxvec.h variants
>       auxvec.h: Move AT_VECTOR_SIZE definitions to linux/auxvec.h
>       asm-generic: add an in-kernel auxvec.h header
>       ARM: drop custom asm/auxvec.h
>       x86: Remove AT_VECTOR_SIZE_ARCH from UAPI
>       arm64: Remove AT_VECTOR_SIZE_ARCH from UAPI
>       RISC-V: Remove AT_VECTOR_SIZE_ARCH from UAPI
>       LoongArch: Remove AT_VECTOR_SIZE_ARCH from UAPI
>       s390: Remove AT_VECTOR_SIZE_ARCH from UAPI
>       powerpc: Remove AT_VECTOR_SIZE_ARCH from UAPI
>       MIPS: Remove AT_VECTOR_SIZE_ARCH from UAPI
>       sparc: Remove AT_VECTOR_SIZE_ARCH from UAPI
>       sh: Remove AT_VECTOR_SIZE_ARCH from UAPI
>       alpha: remove AT_VECTOR_SIZE_ARCH from UAPI
>       auxvec.h: Drop fallback AT_VECTOR_SIZE_ARCH
> 
>  MAINTAINERS                              |  5 +++++
>  arch/alpha/include/asm/auxvec.h          |  7 +++++++
>  arch/alpha/include/uapi/asm/auxvec.h     |  8 +++-----
>  arch/arm/include/asm/auxvec.h            |  1 -
>  arch/arm64/include/asm/auxvec.h          |  7 +++++++
>  arch/arm64/include/uapi/asm/auxvec.h     |  6 ++----
>  arch/loongarch/include/asm/auxvec.h      | 14 ++++++++++++++
>  arch/loongarch/include/uapi/asm/auxvec.h |  8 +++-----
>  arch/mips/include/asm/auxvec.h           | 17 +++++++++++++++++
>  arch/mips/include/uapi/asm/auxvec.h      |  8 +++-----
>  arch/powerpc/include/asm/auxvec.h        |  7 +++++++
>  arch/powerpc/include/uapi/asm/auxvec.h   |  6 ++----
>  arch/riscv/include/asm/auxvec.h          | 13 +++++++++++++
>  arch/riscv/include/uapi/asm/auxvec.h     |  2 --
>  arch/s390/include/asm/auxvec.h           |  7 +++++++
>  arch/s390/include/uapi/asm/auxvec.h      |  6 ++----
>  arch/sh/include/asm/auxvec.h             |  7 +++++++
>  arch/sh/include/uapi/asm/auxvec.h        |  8 +++-----
>  arch/sparc/include/asm/auxvec.h          |  6 ++++++
>  arch/sparc/include/uapi/asm/auxvec.h     |  8 +++-----
>  arch/x86/include/asm/auxvec.h            | 12 ++++++++++++
>  arch/x86/include/uapi/asm/auxvec.h       | 13 +++----------
>  include/asm-generic/Kbuild               |  1 +
>  include/asm-generic/auxvec.h             |  7 +++++++
>  include/linux/auxvec.h                   |  5 +++++
>  include/linux/mm_types.h                 |  6 ------
>  26 files changed, 139 insertions(+), 56 deletions(-)
> ---
> base-commit: f6b3b0a4c85882ad75bce3b093173203e3f39f28
> change-id: 20260109-at-vector-size-arch-6e0f2e9ff8b6
> 
> Best regards,
> -- 
> Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> 

-- 
Kees Cook

