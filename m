Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907C0606A335
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pv9T4iqV
Received: by kanga.kvack.org (Postfix)
	id 0BD186B05B8; Tue, 17 Nov 2026 07:50:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3C806B05B9; Tue, 17 Nov 2026 07:50:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2B8D6B05BA; Tue, 17 Nov 2026 07:50:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BACD36B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:50:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32F1CC040F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:50:01 +0000 (UTC)
X-FDA: 85444593402.29.F6032F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9C653140008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:49:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pv9T4iqV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794919799;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B3SWx7uLf7z0DoB4KPhEmf94Hne1nDAlfrus+vdbRpw=;
	b=YYxOpBMtRY8uB7pKrlw62M6xmd8Rivm1W15UfFE9RXIf1CCgE8DjSqxnrPVVJ3oyor0pgf
	tuFb/v9MQ3Qz/05+VytCCx68q2HgFoZNGyavSLP9YTAoF+pLzvCELIjHenLZyu6UYxFxi5
	LobuaAujsVNMxeOeimEfwSY086RgLpA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pv9T4iqV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794919799;
	b=fdZ3+je1mpCGfcAcjBeqP6noSYzAMWD1H/u7KI3jEQYI5eLj1Cyo+QD2CSZkWskr6Ugkfy
	600KaZe6YFI9w+pDzpzhx30cAjOeyWptXZj2lxhIxLzYeYik2BrkRsDP9xFN2Mlrs+KiTp
	T1g+EU8MmLr2p88ShR/6pNBfsw5t86Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BD766346F;
	Tue, 17 Nov 2026 12:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B551F000C4;
	Tue, 17 Nov 2026 12:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794919798;
	bh=B3SWx7uLf7z0DoB4KPhEmf94Hne1nDAlfrus+vdbRpw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pv9T4iqVA7ch6/Gx513/oIXSKMvqyBW31+b6gx1fQr4NHypnjjqFJTf4s08IEsy87
	 qApnTnTuQ5fbVGszK0ewj2f01ZAk97yU6tA+qdR2b839/1Z/v+7xKSxISkmUvpL08O
	 wtjCBWjSqDs91S50DbCXZzeBq5sNWR40xB+rBw4uXd1enNVZwA02/UHHxsmPEI2ZH0
	 PbLApuvMuZ1zLKxWmmLzoVBsyZMdovL5kR+wDweMZxYv9Etrdd7UvPci+y4ydcXCX5
	 VlDDEP7fUg6VqWuzbzUvWC8BfvCpULOz2h6UotMVDaNv6cvsgeu9qgK2PKfyWm7Ns8
	 L9fdrZDZTESbQ==
Message-ID: <sashiko-outbox-218799@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/10] powerpc: kvm: allow flexible PAGE_OFFSET
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arnd Bergmann" <arnd@kernel.org>, linux-mm@kvack.org
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Andreas Larsson" <andreas@gaisler.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAo?=
 =?utf-8?b?Q1MgR1JPVVAp?= <chleroy@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>, "Jason Gunthorpe" <jgg@nvidia.com>, "Linus
 Walleij" <linusw@kernel.org>, =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Lucas
 Stach" <l.stach@pengutronix.de>, "Madhavan Srinivasan" <maddy@linux.ibm.com>, "Malin
 Jonsson" <malin.jonsson@est.tech>, "Matthew Wilcox" <willy@infradead.org>, "Michael
 Ellerman" <mpe@ellerman.id.au>, "Michal Simek" <monstr@monstr.eu>, "Mike
 Rapoport" <rppt@kernel.org>, "Nicholas Piggin" <npiggin@gmail.com>, "Nishanth
 Menon" <nm@ti.com>, "Richard Weinberger" <richard@nod.at>, "Russell King" <linux@armlinux.org.uk>, "Thomas
 Gleixner" <tglx@linutronix.de>, x86@kernel.org
In-Reply-To: <20261116124832.662455-5-arnd@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
 <20261116124832.662455-5-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 12:49:57 +0000
X-Stat-Signature: wttxzdi58qep8kzt9dkwf5tqsdzuyxdx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9C653140008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794919799-689957
X-HE-Meta: U2FsdGVkX19kxooFRXaG5lTUOvWePh3yKl7TuYWILQOrws3tYSpkWMxAHNuWuJEArEUt2knM9t2wik5HLdTTpiIejMjRrRzdVNubqo1ifsendVIPiIzvIl2TvG9F8zmWoPmifS450cCeL/hIs69SxMfL8uzMir1MYOVIBoHwlNQzf5G0Q60tDb4PGnd8S5BdUb8QLTgNXMeqfsvFjuhJI7XydCx3P4Kd24ReJ7npGXGgq5oNFduYoCxbI5kwxQuVE+5o0Za9h2vqUXBTrJr5jowWAfTfCdqjwPVRPI8iE4GOAtXHYSGMwnz7QuUk1OfXZcpblqsCnsBQsciL1/dfNCldAsiPST2ysVsU8boGxQhsgoiky7qAPGFphiXYEocUIXfQhLChT7F95E8jf2TvtyXa1qxb8U9J9nMCLALeWnP9bgFY50cu//WDeYvyRy5J1L+jQmZ3jM5xyrSffugXoo66cAEyoPzrj3ikZ7Qk55UODm/2aTqAWVQt4ZiajPIifRC35AmvmYpvmtUJpoKCS4ephqbG/cXaNH9Hr5s3/GpSK/IWY/4/EtBRBGEGhdJvMXM/RsY00tX8PZJZg/PDNoPDNXQiLETAShpeTVA3zJBRADxFuPtdS8Cj+jymtERfBaeYKTaKaFsxhHmF0UVIZDbzIBH+HMP4XdFweHTRFnf7rcglKFZB3E+YL4Muo3AtQZkszKFPy7xS9ebWjCxJ3ZduTmF9qjZ6n9DtUoqOxLBp0dkXqRMULqZ+4Bhdm01Kmu8lCTqtH71cz1c0mXHZiXB4K7Dzp+sp2gyZBW3tfN3RhzQhAjw9WsZYJ3ize8Mt/olFq7/KWu1rxNtry8mje0eLnrGzBUlO3eUitIDFmChJA7E9qOWfXXzlQN0Ui0j6CDlovhTfmhDSI7oETwvAFVK+k1//9iu8lIW2lbCtqs0Pxfp7htnQ/kEiyvYC65r4Rwweb/EnN3YJYYm4DzT
 5iXr8ug0
 tSxVlag1IMRRaJfDTubMSAE/JUDpIUq7PAGfbZgwT2gJw7C+J1xgjp+KsqTttKzbZpQ1geqGj2nNnoKpSvSyep4qlWdZT/EBvtcdCP9cf2XqfpFN2jyO6Aob812mjbUnZj6ehq59lug20kI/ZfGWNxypoMyXXbWHLHCF0oXub1IobmwtUFXU1eed/zi1tdIk1WU7ElbLUP2Ts3GcXZ7/Yea3EuHAA+yGIDzZPzYMIOwJQHrkVBBEDPX1q5W09yamsvMBevYHxQyNN84nhP62jaTy8z3hzIP5UeAWII//a6hPqtdwCFjcjXS1bFjugK7yO9FYPbRtQKlyWcwN7U0PQSoXejjnYZIzosJRhNww6zzDP8FP3Nx/PceTHzFdltB4k5l+D8SO6ho/Kqgf1hTP/ZKoKTEd7hUYKsEetf1HT47ISnAOEbEWwQa+DXqvpWIDDvh8Aa4RS344GAQ7NYB1paGFJG4RV5stKUiD1YwTC/rSDK3PCL43cZA8tBP14X9QkFGI2L+OnKoRq5yVJ3MfMyu10OKtsNcps5t1drVZEdUsPIJwQXGALL4/xD0moSRkUqQ/MUIphg7BHBDSuj20JsROhxQMzKzPrA1C8VCmWP5DRhapOHR+AKqUJgPHxe51cPpE1xX+iE/vylCSHtNBJ1Xz2OGtLU+BSwy5AQEwguVMXE1U=
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
- [High] powerpc: kvm: incomplete SR restoration in LOAD_HOST_SEGMENTS
--

commit 32f84cc08116a09feebba0ce8cd2fcce44ce22ae
Author: Arnd Bergmann <arnd@arndb.de>

powerpc: kvm: allow flexible PAGE_OFFSET

This commit replaces hardcoded 0xc0000000 assumptions in PowerPC KVM code
with expressions derived from PAGE_OFFSET.

> diff --git a/arch/powerpc/kvm/book3s_32_sr.S b/arch/powerpc/kvm/book3s_32=
_sr.S
> index 6cfcd20d46686..f38377c30014f 100644
> --- a/arch/powerpc/kvm/book3s_32_sr.S
> +++ b/arch/powerpc/kvm/book3s_32_sr.S
> @@ -113,8 +113,8 @@
> =20
>          li      r0, 4
>          mtctr   r0
> -	LOAD_REG_IMMEDIATE(r3, 0x20000000 | (0x111 * 0xc))
> -        lis     r4, 0xc000
> +	LOAD_REG_IMMEDIATE(r3, 0x20000000 | (0x111 * (PAGE_OFFSET >> 28)))
> +        lis     r4, (PAGE_OFFSET >> 16)
>  3:      mtsrin  r3, r4
>          addi    r3, r3, 0x111     /* increment VSID */
>          addis   r4, r4, 0x1000    /* address of next segment */

[Severity: High]
Does LOAD_HOST_SEGMENTS leave host kernel segment registers holding guest
values on VM exit when PAGE_OFFSET is not 0xc0000000?

LOAD_GUEST_SEGMENTS overwrites all 16 segment registers on guest entry.
On exit, this loop keeps the iteration count in r0 hardcoded to 4, so
when PAGE_OFFSET is below 0xc0000000 it only restores 4 segments starting
at PAGE_OFFSET and leaves the upper kernel segment registers up to SR15
with guest values, causing subsequent host accesses to upper kernel
memory to translate through guest segment registers.

In addition, switch_mmu_context() called after this loop only restores
user segments below ALIGN(TASK_SIZE, SZ_256M) via update_user_segment(),
while Book3S-32 places MODULES_VADDR in the segment below PAGE_OFFSET.
Should this loop start at NUM_USER_SEGMENTS and run for
16 - NUM_USER_SEGMENTS iterations, matching load_segment_registers in
arch/powerpc/kernel/head_book3s_32.S?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116124832.6624=
55-1-arnd@kernel.org?part=3D4

