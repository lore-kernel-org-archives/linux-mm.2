Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8FF3C44500
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 11:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8EDA6B00C1; Fri,  3 Jul 2026 07:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A660D6B00C5; Fri,  3 Jul 2026 07:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4636B00C6; Fri,  3 Jul 2026 07:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7310D6B00C1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:44:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 056561404D1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:44:08 +0000 (UTC)
X-FDA: 84947281776.11.0412A66
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 57423C0009
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:44:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tKakZnJ3;
	spf=pass (imf22.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783079046;
	b=7zw2sLP97InAWHnQTu1v3KKqAvJ0De0Attce5EpYx5LQGipqdp2ZLUyWB5AtRw5CYrLfNz
	3cJjdD8qSVNhMSWjYNJejSekfBwe36Y6mHPYmTdIKm1weMPPEjuPjTDobnaMx04HsX67hi
	O/bWt87ri1lg3a470EX3fhcDY7mtlFU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783079046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JLEv5rnGz+dH05b46BfT9OvCq8I6vCtHuaFvN5MWQs8=;
	b=vVuP7xG0uXINSMKE8uY4eB8cx+Hf8hBgKL8iIJPS+eAUbgSPVJsST3VLGr/wzNNcCZMkPA
	lR5nZvrRPG0O5Sop0F/UR7JOBRqfRmLMDm7p0vhJ3gm0COkLPujveq19mSORmpYF7ZojG+
	i+jZwF3dI40RTzbezNMIdPdGIDR7L5A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tKakZnJ3;
	spf=pass (imf22.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AE10462B;
	Fri,  3 Jul 2026 04:44:01 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 65D7D3F673;
	Fri,  3 Jul 2026 04:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783079045; bh=GrslDCw/jAcNOwlB5p8nyDTpYshtAqIWlzis+qMG09I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tKakZnJ38IyGMrpp+FvNGCM4vGiYTEfyBni8Tcaswrg4QrDdEbNpUaICG78eSHmGQ
	 OGQV+KmXsh59rXzLS/pX0QGbIzhBmg5wD2mrtFlZMHliVzpGArzzl6pwF6bB5ekiJB
	 DUxWC4xjecD3+Ioa17sixIZ2uo+RdtMykGKWIz5Q=
Date: Fri, 3 Jul 2026 12:43:53 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: oleg@redhat.com, richard.henderson@linaro.org, mattst88@gmail.com,
	linmag7@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com,
	will@kernel.org, kees@kernel.org, guoren@kernel.org,
	chenhuacai@kernel.org, kernel@xen0n.name, geert@linux-m68k.org,
	tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com,
	deller@gmx.de, maddy@linux.ibm.com, mpe@ellerman.id.au,
	npiggin@gmail.com, chleroy@kernel.org, pjw@kernel.org,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com, svens@linux.ibm.com,
	ysato@users.sourceforge.jp, dalias@libc.org,
	glaubitz@physik.fu-berlin.de, richard@nod.at,
	anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
	luto@kernel.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com, chris@zankel.net,
	jcmvbkbc@gmail.com, peterz@infradead.org, wad@chromium.org,
	thuth@redhat.com, ada.coupriediaz@arm.com, kevin.brodsky@arm.com,
	linusw@kernel.org, yeoreum.yun@arm.com, song@kernel.org,
	james.morse@arm.com, anshuman.khandual@arm.com, broonie@kernel.org,
	liqiang01@kylinos.cn, pengcan@kylinos.cn, ryan.roberts@arm.com,
	yangtiezhu@loongson.cn, sshegde@linux.ibm.com,
	mchauras@linux.ibm.com, austin.kim@lge.com, jchrist@linux.ibm.com,
	arnd@arndb.de, thomas.weissschuh@linutronix.de,
	sohil.mehta@intel.com, andrew.cooper3@citrix.com, jgross@suse.com,
	kas@kernel.org, x86@kernel.org, linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-csky@vger.kernel.org,
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-um@lists.infradead.org
Subject: Re: [PATCH v16 02/18] syscall_user_dispatch: Introduce a weak
 fallback for arch_syscall_is_vdso_sigreturn()
Message-ID: <akegeU59jSK9t7FX@J2N7QTR9R3>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-3-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629130616.642022-3-ruanjinjie@huawei.com>
X-Stat-Signature: 5iocjg1kt9wwp3uifiu3ajx7ctur34co
X-Rspam-User: 
X-Rspamd-Queue-Id: 57423C0009
X-Rspamd-Server: rspam05
X-HE-Tag: 1783079046-965368
X-HE-Meta: U2FsdGVkX1+PqkzJeUo/29jksyIcqA13FMp0MXXHM9AAhXFZ4d6Y/1fuLUB7I0eMYGt+Xkx9inPicUa0tKxKMitj3AtlETub+yPenB5ORyxxr9LH8MVKlTF2O3vdumC4+3n3JlDxzW2bp+VGtcR719SdFqDdtoTCqf8t3NKjWowbSrtKAN7uvNcrfi41JlpG+b4psrK7G2bQ2MGLt+YIS5A38JQ6trMWr/Ft0BorMdcq8xn452wEGw+ef9W8pq44HFp2IMbLj6kDGjYNYIok7QolxtUGQK3HA+T1oL02PHR/HJnOtBupV3q6xeoq/2+ibHyNYDu7ybOpsI13p2wVcE40au98O86fga3UM0YxTpVQK7KS2xmb//Ginq7YbS9NrAvkIhaBzqjRxRmedrzWwAzvHup80sfWZGYCQQxLXcMYMideD5lXWRpeU0zmgLKZtaAZa0IelEh3qlXLukDio0HPwhQyFAu1cJkdNns1aPnfdvoAbLnJWb2FSeWuPA1kzC7KOdFPZ3I/iOUvDQ/RGihJfXNgxQa371OJnSIm2UZSL1hjapBIzk8OSXZU7oSFspLoglmrFuTD8paWytH8GLncRJYjJFZUnMmJk0h9em2qZclsJNIpqlnPB2aglkkpv06FuPgA/nSBCsfuA1eCR6aU5sCj9Km/mTQU4PwJcVWLaWNc5JyUrYGT4xtanQynKINgaxfZiM9+7KlK+UzaCKAXA53QaTpbJKovINvP2syWkTx8D/2q/Y65/WFpZrjNcTNjK4Vo+SxOCe4FhnDKSmIo57LqHXrTqKlKYf6gM+bXGk9ukXNHx1Gd76JTVtQ88Vkp1ULbbood4DFzMLjpmveoeNZcH8LKjboUCpRvvD54xg8sHK/K+nJbN9wMPrp6XYkdWKNOxjD+5W8bEONieQXJ9+gQhn5Gtz440rJWy71iVHOdBKmoxBuQuVzW2kH8F78kh/WMLgNHiUMYDFh
 Elybjm4I
 nzkBvXuBLewKlgMki15oMTBkHYoqXlf3Gjma3mMI817enkgW2i0Ki9FWUJW/vz/UeSs0/h8TK7TInyN0HmQug2pcddavm5PKGo5C56n+XU4IeiLCIoJ3nm0fGv4pmvyzRVXpgCiKJOACPNrf7HiVvokvP06OzPt1OKvp3Fvm4Obn4v3Y74NyMrSTg3h1EXQhQTzAyJda58QFctd1pFCVO5gGyM19kPgdRTw9EtiqiaKzgGQLcDYCmpTn4YMDF1jWvwDGhz5ooWBJ+IoiNz1YiitSacs2V7xGkyJCfbg8V23Pz6IREU/19i+Y/KYOHXF2XbqwGCcodpCXiUOv+yGUwvv6SJwyDFYE1ys6N6Nz6TDDQot8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 09:06:00PM +0800, Jinjie Ruan wrote:
> Currently, multiple architectures (LoongArch, RISC-V, S390, Powerpc)
> provide identical stubs for arch_syscall_is_vdso_sigreturn() that simply
> return false. This results in redundant boilerplate code across the tree.
> 
> Introduce a default __weak implementation of
> arch_syscall_is_vdso_sigreturn() directly in syscall_user_dispatch.c that
> returns false. This allows architectures that do not utilize a vDSO
> sigreturn to entirely drop their redundant inline definitions.
> 
> Architectures requiring a specialized check (such as x86) will continue to
> override this fallback with their strong symbol definitions.
> 
> Clean up the redundant implementations in loongarch, riscv, s390
> and powerpc.

> +bool __weak arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
> +{
> +	return false;
> +}

If we need this, please make it:

#ifndef arch_syscall_is_vdso_sigreturn
static inline bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
{
	return false;
}
#endif

... and require that architectures which need this provide a CPP
definition.

The use of __weak is generally problematic, as it prevents the compiler
form being able to elide code, and gets in the way of symbol resolution.
It's perfectly fine to require that architectures need to provide a CPP
definition alongside their own implementation of this function.

That said, as per my comment on v15, I'd prefer that for now we DO NOT
enable syscall user dispatch on arm64, and we first make it possible for
architecture to express whether or not they support that, even if they
use GENERIC_ENTRY. That might mean this patch isn't necessary right now.

[1] https://lore.kernel.org/linux-arm-kernel/akZgV0Y4YAmB43_g@J2N7QTR9R3.cambridge.arm.com/

Mark.

