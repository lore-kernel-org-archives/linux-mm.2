Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAAFE606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8CbpRw/
Received: by kanga.kvack.org (Postfix)
	id 186D86B05E8; Tue, 10 Nov 2026 07:05:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F196B05E9; Tue, 10 Nov 2026 07:05:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075936B05EA; Tue, 10 Nov 2026 07:05:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D94736B05E8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:05:46 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7428A80352
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:05:46 +0000 (UTC)
X-FDA: 85419080292.12.E88BB01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id CE1D72000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:05:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y8CbpRw/";
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312345;
	b=3MekERSpwwZ1+HBtjGt9xbLG8jaOslowRrbXAelqSLTzxdqPGNo0ykRfFD5f0cFCAcBY7W
	r9XyYAKd6BXGmUTklVY3TyoCIemSebFxpJHVJiaxoypRiBkFxRU4YtabZqC0l396O3nMgN
	emI7WNt2EDvggTP6idrdYDrPaS6G2Og=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y8CbpRw/";
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312345;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7f29XFWh64dcE7Gp945WM5mLh6no3Sb2g9P1AjvQJw=;
	b=che3mcoYUcn6nTIGMQj94l/+GuTnOPYDBqCz6oxuz1ne7c1UGyBZmmpRiQHjVN4pz7QAH7
	745CzyvlynvsTdoa74WUXM2//0AmGyokH8khWXRT6eeqUvh/ddTO3rrmYcYbg8Y+B1E7ab
	C3a/yFnBVwe/RRiT/2dhk3HiEFXU6t0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A07140426;
	Tue, 10 Nov 2026 12:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0861F0089F;
	Tue, 10 Nov 2026 12:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312343;
	bh=j7f29XFWh64dcE7Gp945WM5mLh6no3Sb2g9P1AjvQJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y8CbpRw/nm+kIkWV5WEeq/0BxuE9wHCWFMC/cm0g1cRT7hVsWLamnW6a0ANHjpaZT
	 S6UMOBEuKH7iKxqLJ+VaCMUjMPimpe7PdWZEessyxHRONhgvliaXgXmpreIfdpXknr
	 bAsUtTJeH3zAfzg46VMDe0BqJA4zcjHvwh7yAvfBv1yOu5nj6fC9euSXOABOcugvvQ
	 gFx8y/JPa/X+4BGvowNono7b2jjAAgl9WiMreT1fcKmhtp/JPFJ1bOFMcHJSqeIZ5n
	 hSkqajRGX23b/xsVP4Ux8l4cyyh1YgMNFWTpDlRAcaA6Lg7gZ37nhNWRH0Hogdb82T
	 0U7Y0q/e1uEjA==
Message-ID: <sashiko-outbox-206977@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/6] arm64: entry: Always inline helpers used by
 non-instrumentable paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jisheng Zhang" <jszhang@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Andrey
 Ryabinin" <ryabinin.a.a@gmail.com>, "Alexander Potapenko" <glider@google.com>, "Andrey
 Konovalov" <andreyknvl@gmail.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Tejun Heo" <tj@kernel.org>, "Dennis
 Zhou" <dennis@kernel.org>, "Christoph Lameter" <cl@gentwo.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org
In-Reply-To: <20261109114500.20298-3-jszhang@kernel.org>
References: <20261109114500.20298-1-jszhang@kernel.org>
 <20261109114500.20298-3-jszhang@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 12:05:42 +0000
X-Stat-Signature: 1apqtiaj1pqj1j411ihqa85hygrzdjqi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CE1D72000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794312344-498024
X-HE-Meta: U2FsdGVkX18PIOTTEkzJ5GjQa+ik8a8v/eqzIqPWa0Pl11W0PrhaET9kE6XfKowE1wt+31jJZBJUdk0Me/BW0nBH+O3mDHkjpxzMa6Su+wCEMrHl4HszQjBiDhwi90UiXcrCApU+9zc6lGkrlKIu7CVh1IpM8lfc12j0vF6ZzS8OeWGl+YPoLbBKRrbAL6ur9uh15s2duBLfvAnWcEQNMgAF2XBno4e7wGthM818NRJ2gA7oHdQZ4CxHlIRBeMa/EhtcdiWSQ6tMYGaftA0etoqQu59DJQm7W3DpIrIB60gn+22Qsr237QNf4k+S3u2y55pHOKVyl/LObwQTzhnj4YyEkbsQZVppouQ9Q+dWRzfA1bGkJz/J/syFqkJBGe5ko6ozzlDVCsJRVbF3QqA7iYUQzdoyAF06dvvDVDSgPe7rpsgJ+b3UYotZNCxNBqNy2Mj0cmiTFGmBaSe1gXFEm/wrtDRzQ2RZUMvxGj8ZucW1oO+PCkfkwm3ATSZs19RJGFN7Pth4GVqcIQAJrU8opEcUCCpsuKrEcUA2504a0qvODYFOVN3L2NqUo3niJWxwSZbrV+bfT/1CsorUydJYT0ra0Mp9AyFUXeYaU3oetS9hFs35urwQ+ByfLsIp/dT7YEGw4OvPnWrfXHDhuUtDo3vS4HjNLINstTCxCsKTv9XsXmT4uG+DJjTOxu2/86oDu8X5o/CnYxFFBs/+B+jlvszSl9VjCkJ7FWZnCMUiANpkHVrzaPw7lPvMKYkzGrD1F2AGrnqD8YV2VItrvV2lvPyuFMvvZoGd9PTcPkP+544Q/eH124VUExNxbBxuVCWJO9W6YBE/jeKWoIGAllO0LuJtuYZjvRt+yJ/D/MP1DwQOReog7dT1BwOOqABuCJB6F+uNFs1Pu0F/m0jn5BBBITYIrW6jacfmXfWCrkYhoHgJFEyNQtsP5KQzqhWpPovCZimL31xrUM2bfwUgY9p
 MT5sSR11
 k+WqIPuq2P4eVnzBS2ZKcayVj7shmIKTSwPvvKkWrxB1gx51buTSWadiWh4uAmThQT/QycFpnLeokr732qgYhYd7sN8lL5YiiBqgUMIjsqeN3vLgOaqI0p4+MUcaKiGn3gwDP1y3LeMYGYItj5npbSPo6xlJIE4jFyyjtSJW8vOJHN9+iUtPSp3blRK+jCooUPo+y5q+exrpRIrcNoIx+7SXgwZaZSs1kDAG44M5jX/fXvFALucDOMVu8vfsGfP7u0YvNKmVnNj0m36Dwk50IztHMcyF6I2nbKXXVIA0YzPNBHm8mzY7k076KnAWtGWrlRIvOTRozagxeJM8ZC9SoTaGtF6Yoy3QQez1ujugMRbT4/2UisZZxUTn30xIARqAW7ilk2V2guqWg+ScbCAbopkls0ovyf3dFk8KMQUd5iSq2PZLKqSbHXZZOC8zEch2vpOBMlKln9MnybehthC4KcXszOb4wOa4erzJ7qVDL6xP+Mt+WGJRtSFFxIZ1o6gtoUFbHarVovDuJgW82QzlJp1Ss42cMPFmngeG1tSQI6xrTS+WKtGyeK6ZzT1+lbQIUdfiTBsl9bDy+Ga2YZfNGa3xQCpktDTwocgt0brJWhKTwNRoew6y4+tVvfJBtJ0m/xY3IB/MGkbiSJuaB8aLBBE25cjHCM635NT7T
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
- [Low] arm64: entry: missing __always_inline on !CONFIG_ARM64_SME stubs
  in fpsimd.h
--

commit ed5f3b4320afc347aa0402f3b75096047a676bff
Author: Jisheng Zhang <jszhang@kernel.org>

arm64: entry: Always inline helpers used by non-instrumentable paths

This commit marks MTE, SME, CPU feature, and rescheduling helpers called
from noinstr entry and exit paths as __always_inline, and updates the SME
entry and exit helpers to use tif_test_bit(TIF_SME).

> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fps=
imd.h
> index a67d5774e6728..e7c881c1c1f79 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -749,17 +749,17 @@ void sme_enable_dvmsync(void);
>  void sme_set_active(void);
>  void sme_clear_active(void);
> =20
> -static inline void sme_enter_from_user_mode(void)
> +static __always_inline void sme_enter_from_user_mode(void)
>  {
>  	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714) &&
> -	    test_thread_flag(TIF_SME))
> +	    tif_test_bit(TIF_SME))
>  		sme_clear_active();
>  }
> =20
> -static inline void sme_exit_to_user_mode(void)
> +static __always_inline void sme_exit_to_user_mode(void)
>  {
>  	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714) &&
> -	    test_thread_flag(TIF_SME))
> +	    tif_test_bit(TIF_SME))
>  		sme_set_active();
>  }

[Severity: Low]
Should the !CONFIG_ARM64_SME stubs for sme_enter_from_user_mode() and
sme_exit_to_user_mode() in the #else branch below also use
__always_inline, matching the !CONFIG_KASAN_HW_TAGS stubs updated in
mte.h and mte-kasan.h?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109114500.2029=
8-1-jszhang@kernel.org?part=3D2

