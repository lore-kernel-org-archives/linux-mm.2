Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3494ACAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 21:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D39F8E0122; Thu, 18 Sep 2025 17:10:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AB858E0068; Thu, 18 Sep 2025 17:10:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7A28E0122; Thu, 18 Sep 2025 17:10:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60DF98E0068
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:10:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DF1D1DF2A9
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:10:28 +0000 (UTC)
X-FDA: 83903614536.30.EF89077
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 623B320008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:10:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kdoP1WsY;
	spf=pass (imf03.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758229826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZyRMAGtJGacuQdFaM0nSr2jQ1lkMUltkxxjZY/sGCQ=;
	b=wu67qa5RzyjSYtGBytlokyxzxJnxybERXRKsocFo4UhbjYcGmEZ0cIm5ZOke/fePflNnkl
	gzpduouBvdXi8DK3MlFdelqjY12uBsBYCEl8P4XZC9jvPmq6c9o9Qc7/CuqO69KY/AMeUP
	4wptudytZB8eLoryp1EsDyliv5yxQLg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kdoP1WsY;
	spf=pass (imf03.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758229826; a=rsa-sha256;
	cv=none;
	b=5JzFk2owVZr/t1svt4VSK267max4bVaVbs3jeXslx+WJ+fWM0QR4RYtiJ8nmclHhe/SHYK
	phiJhBlnPi2yn/r0ts+WihYkCxvN/qdx5+YWMYXAjhJV5B0ZVp3k92xpA22AUAWjdc7/Rj
	/pjEAKZH21+AIscmuuFeCuDLyb6a98w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 777EF601EE;
	Thu, 18 Sep 2025 21:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8B7C4CEE7;
	Thu, 18 Sep 2025 21:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758229825;
	bh=jKkcmf3MDfbgYuwWGn6u6Q37sQo63v9wUZb8rTdwbcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdoP1WsYZzMmLUBAA/L36XxB9IEcVc4Z3/ChXrxWDhNsJZJzU3SIc6TS2LkVInryU
	 tVochwRrdRZdIIdxdorpyqRVl+mGLXr55YDmTdu95nHE/JWnwHuxD+/fVTdWmvhm2i
	 6LDGQnf6YW+KYWmnCOFrMmX3GvFaPoTYiFMkhDRmYJ5Ozf+V44WmhS24veu9DGogg7
	 UK14SwgRtDoiHI8l/XXxGjxXg/JvpNDz6zCXDE5S/s93DO+Sw0bsAbP/nSEjlkwS/+
	 Ccmvj9xhlgLfoch+tRE/ZqhgwmP39qNFB/c2K8tAJB5QkzUaekiVd5CNy9Gldhfi92
	 qsolnw97+XVpg==
From: Will Deacon <will@kernel.org>
To: catalin.marinas@arm.com,
	ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ardb@kernel.org,
	dev.jain@arm.com,
	scott@os.amperecomputing.com,
	cl@gentwo.org,
	Yang Shi <yang@os.amperecomputing.com>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block mapping when rodata=full
Date: Thu, 18 Sep 2025 22:10:08 +0100
Message-Id: <175822779944.710258.10028837182267037801.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250917190323.3828347-1-yang@os.amperecomputing.com>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 623B320008
X-Rspamd-Server: rspam05
X-Stat-Signature: ac7eh88pkbhk86u4j13arw5fxd5tudp8
X-Rspam-User: 
X-HE-Tag: 1758229826-76558
X-HE-Meta: U2FsdGVkX19HXXJMEgpX7OlRfiMPPFFohAJEXnqKppu+pWBQlNzj2DzimGS14Liftv/yO3xQTwwVNK5wNvqk3rmYrr59ohUhlOnaF5iofE8xNXblFm4NdCcDPnS/6aOqQ54kSOoCQSdMeHxJlkGwawpSSJXnuZQr7QBFwoyT78HOyml8uoRgYPFGXLeByjy3MQA9sqrQItFycm17K69s5akB6pyE30sOZSVYthlYpLn+hviZ1/DlcY9VSijVMZDKgcKxMM4CdAWYoUFySdfUXqyPcLKhjlO1WvTL64as7Jx/n4I3JGc4kZv7v+mv/i8KWPA92JKD0JcUAQEqacTnTH3jxNG/eqrtS/49RaPukIwMmkLYufDsbamznbL0v86KuZmEn8sTlzwAvV303HIhO25oAzcnpnkrs/00YUGHJylrNnTqAiZ1wP7n5MRKI2bTJ4GZIm8xDPMjArLpBN8cl0sl6Y4mOuO+6VzzGE0m3IkdmPyk9N/eJ8aboNZ/clpFBZlCiX2J3Oli/MiJ0X9HOBiKOHjYglTBZcbs6d0k74BB3vz+TeHDVQEut/y0CoDhv7rHf1gYaZwHFWYhSakSiA9Iq91DNocoaf+u9I82HNWwxfelCAqRn/VHOgZ5nPArPDY9SmgPjMgC7WBopA5RkiTdhAHy1W7CoihOTCfOsVhRExWOKMTdGHWWm5BRoIrD5YZOzM4Pl21Ife8yxlJZK06GXaSyR9vVHUrhtTiLLkbuD/pli7ihlJu2k4X0NDa0hNuPBRDhyUzAhgOJgPFYaA4NTe3F73bZ12Hy68qNgLdOtcr1YSIP6wSJgYuedm6oWTMJa7jn0ir+wUDkxAX5C+/mbZvAm3gc58i61U7inLKvaiUxs3MONL8r7JbPlwlxkrNZXPAU0WtY787f51+Tjw+IeHjz92PsEnSitAb7LhtQIpQJXmVW4dnEch/CztW3ja899EVF0nxS8mM5Lzo
 fvPWCUZ3
 0+Q69n6J5CYHsdTjVE71niyr4ncW9pYdYmi6YK5tNvXNICr7r2NyekvaNZE0gEhRBuuk7+gue1EUksYPmksOdxw6yFp45yopgFj92Boe+eOJMT4h3aiYFjpK55VXSJY5Y3jSI/b4MgKTzTTpMbT1kb2HqpdzC1M0D4cREnIi7q+73Zbqg0HIoKjBG5z0jYNjFqxHhuKTgXZ0HSRMVoW02mGxioD2mIwzQO3RucjWaeIZ03RVCYBwF3TprFhPxguxvprwDPCrCPL44+0LUbit/1PC4yPBckV226e861Uwr/8iF1k2jV6m4Oglh+8V+kxK4LozANISIjDChxZ6Za94xgcvs1jtunl82pBLs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Sep 2025 12:02:06 -0700, Yang Shi wrote:
> On systems with BBML2_NOABORT support, it causes the linear map to be mapped
> with large blocks, even when rodata=full, and leads to some nice performance
> improvements.
> 
> Ryan tested v7 on an AmpereOne system (a VM with 12G RAM) in all 3 possible
> modes by hacking the BBML2 feature detection code:
> 
> [...]

Applied patches 1 and 3 to arm64 (for-next/mm), thanks!

[1/5] arm64: Enable permission change on arm64 kernel block mappings
      https://git.kernel.org/arm64/c/a660194dd101
[3/5] arm64: mm: support large block mapping when rodata=full
      https://git.kernel.org/arm64/c/a166563e7ec3

I also picked up the BBML allow-list addition (second patch) on
for-next/cpufeature.

The fourth patch ("arm64: mm: split linear mapping if BBML2 unsupported
on secondary CPUs") has some really horrible conflicts. These are partly
due to some of the type cleanups on for-next/mm but I think mainly due
to Kevin's kpti rework that landed after -rc1.

So I think the best bet might be to leave that one for next time, if
that's ok?

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

