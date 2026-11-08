Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB44606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 07:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NizOiOvT
Received: by kanga.kvack.org (Postfix)
	id D1AF36B05B2; Sun,  8 Nov 2026 02:44:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD53F6B05B5; Sun,  8 Nov 2026 02:44:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27866B05B3; Sun,  8 Nov 2026 02:44:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 817166B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:44:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2387E16018F
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:44:01 +0000 (UTC)
X-FDA: 85411163082.17.8A7F9A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 88BEB40003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:43:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NizOiOvT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794123839;
	b=QFnyx9CDJzHwQrrbuXPEZ/daJf9rckAz/NOJBMtAGFDwEEHEMRpjLCaH1rdS2knYQA16R5
	l4svHhv4WLSSu9JpUyiEM4y62UBE3PLyilPEBFTGcSz+gFn/OczCoMaQ5Qq0VSMZmQIoSD
	5Fo0+Mk6JZaLLVtI0krQuEHd6etGles=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794123839;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpDMzRkJE7jL49ULGOvX8i1uKCtA5RX0wTzxTcr49oo=;
	b=wTg+4j/ttaPxoL7a4rkfkWFS24ekzuNdafI/8Db1smXdeI7A31d9ieIKXBcbl0IbPeDM9Q
	lKdRX9jSKgKRAF2eHuD7UH+LhSy5QzM07hmWlpSH47tSQU0FwOoJGHdUWUe0OtK3DgPBf4
	9SOAO30yFCjT9AE8ljVr4m+AGl39awU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NizOiOvT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA3624182F;
	Sun,  8 Nov 2026 07:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92A11F0089F;
	Sun,  8 Nov 2026 07:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794123838;
	bh=jpDMzRkJE7jL49ULGOvX8i1uKCtA5RX0wTzxTcr49oo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NizOiOvT9WYRsDZ6P00VyxBLJNQ7EMuzVR9EzR/z3uZ6PrE3Uys4pyC/rsoIyZTRJ
	 umslvkVJNbhoyWEpRLVB2sxXBGhhIdT/0e0nGg82FjM5Qq45xKM22S0RoDjrfv4Cx0
	 oHo3V2OAZOBg4bTHt6A5oVVmgeUo5LRtf4wqPZEazX+EfsCRg7vQLdZN8tiBOfOSVN
	 xM0n14Y6oS/KhnOfAWYaW2D/4RcC8yrtIg5g432hQSyfbbEr9kKDBe+mqs2kUfPGWx
	 VFx4KLebgMlTspc5fNi0r2liZTvozelFVyuNOJPkIYMgZ1vhZ6LBGwuapeodNdMWWm
	 rxA6YNRbfikQA==
Message-ID: <sashiko-outbox-203634@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] arm64: entry: Always inline helpers used by
 non-instrumentable paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jisheng Zhang" <jszhang@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Andrey
 Ryabinin" <ryabinin.a.a@gmail.com>, "Alexander Potapenko" <glider@google.com>, "Andrey
 Konovalov" <andreyknvl@gmail.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Tejun Heo" <tj@kernel.org>, "Dennis
 Zhou" <dennis@kernel.org>, "Christoph Lameter" <cl@gentwo.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org
In-Reply-To: <20261107071339.17467-3-jszhang@kernel.org>
References: <20261107071339.17467-1-jszhang@kernel.org>
 <20261107071339.17467-3-jszhang@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 07:43:57 +0000
X-Rspamd-Queue-Id: 88BEB40003
X-Rspamd-Server: rspam12
X-Stat-Signature: kbju6cu8u4jq4ndscuxieaqagftmbt9k
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794123839-988311
X-HE-Meta: U2FsdGVkX18uv+qLw+BTjFhmBGcT4ub5Z6cAmA4to81JpS8bcikXkdWHWT4qX4DauYj5rpzY6oIMOIieF6tmwzi+/bEY5xt0UitZJjNb7DkHHx7r9ZFPCBA6GqIuhcRbLTefdCArok2tXay85D24BYYgJpk7e9qLifVBZBnxRDT8Yu54qNqdcxzWyup5rG1S+r3T1hWSyWyp0Pq8D9jq0QMToVkF16ZsJxFw+9k3s0Q4u6hLGVz/dFvo93GxfOliNFCo8RFvaBynZ8V7fuoyjpdHSH0RxmdZ1MtxI1yfrC9Gv8u4IjWdANrrvOzkQINyV2/fDGA0MkBaO4SRPdVtM2C6orU7p1R+gf5PEvPGdYPVYlfrWu2BXo/9XzN2R3zvCfnF4tuICzvYSAENL2e+kHGJfVOxwT/MyehbBwkqyHWEF7kPPxAEVSma5neYWzMXMzzz8CHUEEa1Im9LFdI5WZGO7cdISKJOE5mxM7FBRhgOr4U2y5k49KrDoFqzRoh66q/qsrkUQw0lrPYyfnNLavwnoFLVRojqILjil1U670Yszp7w52V//paKOT4kZ8sKce727pTuqMM8fghftAqBmcTZLEu3Gi16RPOCqJEtLYP5oPXbooEDBWNByi5N0AwcEywQBU1xIXb4vw7eNSlS2wVf1YJM1G3knCPgkVbg01yhNbK1L6K+4P1DJbQmvQCKyx2rxBWYr/xSTPrBFcPNHgz2xmMrmG+N1acrWS6RmOys6RkYbztLv86urOQMOzOo9lC9MwOPTtV0zpIAvUbW2b5pm0iv8EIlXVb2RM9xksqBkp+G+mLYB3efhncd9epi+yi2xvpYJZdf6y1kPLvy7dGH0ZEbugJjaHEchfzccx32V60zmrrCOmeRi/6wCoIEp2FQ7AmmtFXby2QDsg+n+icmucrOboE8O3JEg1c+HtICYkHl7+vFc2Nhfa+4yiY/IQ12HAX/b1UHWm9w11D
 +7F3ZMut
 1cbXb4TECR2SrXpOmdztZMahJYZ9OYKf3nWQ66has5WZoysrMha6lnkQaCUaAOVSs9L0CKwoirj5TkujvNsBqlXV5cIu/y2x7UPQArc0X2jRonOCGE+LrQHaEqI0kjB0BbR7C1/XybZnsuAJumhesx9XoVjBNx1nuNRabCI4KSRbHti+pdqHFlguUsQpPetN0uNQjwCrjBh9p6Blf4sUjc5fhuvcb2g3ug6shR6qNSu56sdpIr8MPTZntZqxBhdP0HF9pC15TKQA0CL14IhcQgmVxuQKtysOTABDS9fNtNDe/B/SdZ8zhVkiZAjxETMDF6XEh6qxSjbtwtXl4yeLTbgHvg21qhTPwsGDLtv1CmWNverEOO1ySx12Dp1G55eo1ey3U4o7TDY9o3mCYzl1PvH8zloXnYm0zQxu5jZa9YnEqGPMiFevlVZr1iysGSJ7fI5VjpGbbl4be0dVrG+GI9gnBwcVvG6m5GJuTUFzevYqxibjJdBbG83IFb3BRHVvdIEaG3k/LfWexaYIVwXX87ydetnDAjaRUE2UxdET3hL/ZK+ouRJVC82SIShaSrwXE2hbEbt+RKalNoU7d38NK2WNEoUUtNLlDI5LqZiakiZ6Q9npTSim6liGo0Hc/SXYdmxmAjvt8QHUqKO9aJ/0LVBtYe00flgbI2755QWCKOjWafgK6r9twtwZfRrr3ACQDU2HUps0B5j5Sl0PH7c45Dhv8xwAGGIRswHFQARplNBHKJGBoyTaKnw9DNdNuNinL41i3FrLGUqP/EqJjM22Obsf/TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Low] arm64: entry: kasan_hw_tags_enabled() not marked __always_inline
  for noinstr
- [Low] arm64: entry: sme_{enter,exit} helpers call non-noinstr
  test_thread_flag()
- [Low] arm64: entry: #else stubs for MTE and SME helpers not marked
  __always_inline
--

commit 36003a6dfa6a3ccb4d813e94b64d8956098d7ce8
Author: Jisheng Zhang <jszhang@kernel.org>

arm64: entry: Always inline helpers used by non-instrumentable paths

This commit changes several MTE, SME, CPU feature, and entry helpers from
plain inline to __always_inline so they are not emitted out-of-line in
.text when called from noinstr entry and exit paths.

> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fps=
imd.h
> index a67d5774e6728..157d0551f6279 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -749,14 +749,14 @@ void sme_enable_dvmsync(void);
>  void sme_set_active(void);
>  void sme_clear_active(void);
> =20
> -static inline void sme_enter_from_user_mode(void)
> +static __always_inline void sme_enter_from_user_mode(void)
>  {
>  	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714) &&
>  	    test_thread_flag(TIF_SME))
>  		sme_clear_active();
>  }
> =20
> -static inline void sme_exit_to_user_mode(void)
> +static __always_inline void sme_exit_to_user_mode(void)
>  {
>  	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714) &&
>  	    test_thread_flag(TIF_SME))

[Severity: Low]
Should sme_enter_from_user_mode() and sme_exit_to_user_mode() use
tif_test_bit(TIF_SME) instead of test_thread_flag(TIF_SME)?

test_thread_flag() expands to test_ti_thread_flag(), which is plain static
inline and calls instrumented test_bit():

include/linux/thread_info.h:test_ti_thread_flag() {
	return test_bit(flag, (unsigned long *)&ti->flags);
}

Inlining these SME helpers across the noinstr EL0 entry and exit paths in
arch/arm64/kernel/entry-common.c allows the compiler to outline
test_ti_thread_flag() into .text under CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy or e=
mit
bitop instrumentation in .noinstr.text, whereas tif_test_bit() is already
marked __always_inline and avoids bitop instrumentation for noinstr callers.

[ ... ]

> diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
> index 83f3b05fc7849..b2bf2e70c9aec 100644
> --- a/arch/arm64/include/asm/mte.h
> +++ b/arch/arm64/include/asm/mte.h
> @@ -222,7 +222,7 @@ static inline bool folio_try_hugetlb_mte_tagging(stru=
ct folio *folio)
>  }
>  #endif
> =20
> -static inline void mte_disable_tco_entry(struct task_struct *task)
> +static __always_inline void mte_disable_tco_entry(struct task_struct *ta=
sk)
>  {
>  	if (!system_supports_mte())
>  		return;
> @@ -245,7 +245,7 @@ static inline void mte_disable_tco_entry(struct task_=
struct *task)
>  #ifdef CONFIG_KASAN_HW_TAGS
>  void mte_check_tfsr_el1(void);
> =20
> -static inline void mte_check_tfsr_entry(void)
> +static __always_inline void mte_check_tfsr_entry(void)
>  {
>  	if (!kasan_hw_tags_enabled())
>  		return;

[Severity: Low]
Does kasan_hw_tags_enabled() also need to be marked __always_inline?

mte_disable_tco_entry(), mte_check_tfsr_entry(), and mte_check_tfsr_exit()
all call kasan_hw_tags_enabled(), which is still defined as plain static
inline in include/linux/kasan-enabled.h (even though the underlying
kasan_enabled() helper is already __always_inline). Force-inlining the MTE
entry and exit helpers into arch/arm64/kernel/entry-common.c expands
kasan_hw_tags_enabled() across dozens of noinstr call sites, so GCC with
CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy and CONFIG_KASAN_HW_TAGS=3Dy can still emit=
 an
out-of-line copy of kasan_hw_tags_enabled() in .text.

> @@ -256,7 +256,7 @@ static inline void mte_check_tfsr_entry(void)
>  	mte_check_tfsr_el1();
>  }
> =20
> -static inline void mte_check_tfsr_exit(void)
> +static __always_inline void mte_check_tfsr_exit(void)
>  {
>  	if (!kasan_hw_tags_enabled())
>  		return;

[Severity: Low]
Should the #else stubs for mte_check_tfsr_entry() and mte_check_tfsr_exit()
(when !CONFIG_KASAN_HW_TAGS) and for sme_enter_from_user_mode() and
sme_exit_to_user_mode() in arch/arm64/include/asm/fpsimd.h (when
!CONFIG_ARM64_SME) also be marked __always_inline to match
system_uses_mte_async_or_asymm_mode()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107071339.1746=
7-1-jszhang@kernel.org?part=3D2

