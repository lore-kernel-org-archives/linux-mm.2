Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B741C606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 20:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ks04bzIY
Received: by kanga.kvack.org (Postfix)
	id A37E86B05B0; Thu,  5 Nov 2026 15:44:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6B46B05B1; Thu,  5 Nov 2026 15:44:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE246B05C9; Thu,  5 Nov 2026 15:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E42C6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:44:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80CF2A09C9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:44:09 +0000 (UTC)
X-FDA: 85402242618.16.FE438E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id DC1694000F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:44:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ks04bzIY;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793911448;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cajAByUeZEfXA46wL2DP0e8bMTdgT7qZWKnAlu0+L/s=;
	b=RgZRFtPCoZHJTlz5792mCzxWJgiWj1vfo463+6pr+BuSfedQv46XXbgGlc1IAs4+7lHDQa
	2EQrdaJHlvGXPad9aK7FHUiBQDK/rempOx2DBXV5/l63gt3DzuVLedlq6sTIRD8vnAwUYY
	S9OR02T8EvRTDTLhdwr5NNBwZDKMAs0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793911448;
	b=1AStVK7wr9Yktxstob8pam1vYuBmr7Yob9tPUR6uJU8fRcuURwrafZJchGmY52BsVKSQm6
	EqaWcpR8LG86A4FpTWFIwcQy1whkyzxd6Gqx7/pIv3N8Rw3YXGnrJd/dJlLSu9z/4Wqwio
	QqKga7RgSD4VvInXiMQsFNmIKUmRNkg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ks04bzIY;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F997602D4;
	Thu,  5 Nov 2026 20:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD3B1F0089F;
	Thu,  5 Nov 2026 20:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793911447;
	bh=cajAByUeZEfXA46wL2DP0e8bMTdgT7qZWKnAlu0+L/s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ks04bzIYP6YRtJvKU9ftPmzODeSu7My0kic3OATKm6VhntC0VtavJQ3HMcEFGE/9F
	 SpZKoJezE0BGBR8g1vnZqUNcnnARDQ10AfpXGiBdX5aAv8OEwBxbq5luUMbM7YuJeJ
	 caEqF/UBjGgcM4o+IJ5M2L1VVUIQT5/Bw/PS1ufM1Dg+BRW0OLZAKzLU788n1yOHYo
	 oEeoYGiHtrOPq0Vfu3Egc8G0rmrKgY3VK+2GLKMNXYIjPIZ9b/RsJgQ17ov95J/0B7
	 TdsNGb8g0o0LkVWTLEuoQQ7ZHdrlk9LaU1FXuPJG9za71KkPG0yHD61lcTCKxCPqu+
	 z8CF4TnQirVVQ==
Message-ID: <sashiko-outbox-200129@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] memblock: don't allocate new reserve_mem regions on
 a KHO boot
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, "Mike Rapoport" <rppt@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Kees Cook" <kees@kernel.org>, "Changyuan
 Lyu" <changyuanl@google.com>, "Alexander Graf" <graf@amazon.com>
Cc: "Tony Luck" <tony.luck@intel.com>, "Guilherme G. Piccoli" <gpiccoli@igalia.com>, linux-mm@kvack.org, "Pratyush
 Yadav" <pratyush@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, kexec@lists.infradead.org
In-Reply-To: <20261104204235.9066-1-azpijr@gmail.com>
References: <20261104204235.9066-1-azpijr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 20:44:06 +0000
X-Stat-Signature: kaap6zgianmw18e16xhkspitd4sa9scr
X-Rspamd-Queue-Id: DC1694000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793911447-912871
X-HE-Meta: U2FsdGVkX19F0Oe+T8HRLjwdTAxfeJ7m+ect239EzYBg7Ct52m7jCpu7X9YMjaDSQKGq2fHWV25VWbCEp5KueiuQZCVl2RwsdZRY4y3edwHChU2zNbLtujUpKdHXJLiCxZl4aIY6JCdbjyAA3FZu8zh2ZiyGc314fKla0m9VYsyImWRDsYhIW36/ctp9R26tzFiKaB8ODnU/hE8r/t1HdkXC4azooybNnb+oKjHOcKnQQGjSAIQ/a4RJMXDaq03OtNZxOemMr2ewLwRH3Z8pCHH2cURGhO1QIapERovCxZQPbSvB4Qzov3fRmjuzlmY7GN3pUidHKZ3dBXSs3DaLCMfV4fUnLHZ7M1/jV1cBJODwhKDKbvvO+PuvxQtjeDY2BSg4BGZOcwQca2sbL88qduenhdDR1TvkRD7WIjk1jVk2Shtaz/2aAzQ8QOrwlBHII4B4QC9OdpQAndZgxvV8QmXfW6adwhYPuL5NIH0tdHlDe08W3Hac+KBlv8oErBUMecL1q7isPKnVjboa95hTDQils9D4SSOX8qSA0BKMga3RXcmFxrUv+mk+97wpyJaqyGvD5TajwOSN+Vh0rD6cKOm3+JBWRrGO+gjiK08uk/TGztHJ56CJQ39g6i4hf3Gj4XvgCIqEstcoW6fd45Ex1KKNtVpH9oV2vdAHXo5qUifokriPvkUNCrg2gpjN3BvcCLmJKtw+GKu0swsw9a+YYvQIuKJEFxNgW+DywVD/9pLMoZnjw2+i2dnWLTrI4GJ8eLSORsSwZsguXdevA47d26iS+mzplmI7ZF0P/2Biq+hSctVQ4H7cZyTnVuxjqNtWg+8um6zbKm0mKxt5jGqzYhoe8BawEhf6HHlVuFRIPxa5YJscJsLlI0x2hokJDMfcM//Ck0sXiRb9Q+gLi7f9rd/DHqOJQWrKFSTYsuKDgEPCRikAnwmbI0svyupDWuP387bHxmEO6JMCguCZDWg
 MC8V/TIH
 C8Q8T3DXq5FPrz/LTJg4dolgr3hicLMxdk6TDBvRPMSSUjETglN1cj9AJhB/Xaxng5x9nupd91E8AgjkaQiSdWzueLz5kits7C+WMldgZ+yEu4E+FhhLfC/y4AEPWxk862YdKckwW3rj4a45PwTZsslAuX071mFPS5JKfP06dCOKDhW36Gv5eoHrU+wyNAyJh6tti9UniFuwcnBB49/ZwoMhhofNZcmW/UV5fnHkCZ45ceYALJbatU90ejsouasLrYYdMBEXH75M79tYeNj1qsRxVBbar0zCeQ5YvD+12SEXWxxcyatGqBdG3vIF+j3+k2gOr98xT/u/P1LDnSpmiTKFOnOvUSgop2iwE3f8sGJjWNkm1wVUHMXg/5rJOQlwTcZaDB2VjGn6fpa8LG2WBNPUV0CXuVsMz2YTw+7u4Ayi9QDS7dctRQSBEB4HkCZ+4D8QPmi1KYnQ8/zWOpMXNafYwtKLiBq8HKLcfU3Mi0Vp774Ch0K47xVhVzYu6dkwR3l2k/OrD359OXyj0eIdkEoolZPnYSxX0+lh3+USCWDOCEUfOrZmUIDuhN4yQDQ0Sozk/wZnsZNUb4DLCxwiTfidgW1C2vCSGZ055k/hF57cHAkgJpLowL9+BLYC7J/6oQhuM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] memblock: missing is_kho_boot() stub breaks tools/testing/memblock =
build
--

commit 19549caf363a437d6178ec835c2f8f9d0ecc7f1d
Author: Jose A. Perez de Azpillaga <azpijr@gmail.com>

memblock: don't allocate new reserve_mem regions on a KHO boot

This patch rejects allocating new reserve_mem regions during a KHO boot
when the region cannot be revived from the previous kernel, returning
-EOPNOTSUPP instead of allocating from KHO_NOPRSRV memory.

> diff --git a/mm/memblock.c b/mm/memblock.c
> index a450092a80fb5..e325e0542c9a8 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2827,7 +2827,16 @@ static int __init reserve_mem(char *p)
>  	if (reserve_mem_kho_revive(name, size, align))
>  		return 1;
> =20
> -	/* TODO: Allocation must be outside of KHO_NOPRSRV region */
> +	/*
> +	 * On a KHO boot memblock only allocates from KHO_NOPRSRV memory here,
> +	 * which includes the bootmem the next kernel boots out of. Only regions
> +	 * handed over by the previous kernel are supported.
> +	 */
> +	if (is_kho_boot()) {
> +		pr_err("reserve_mem: can't allocate \"%s\" on a KHO boot\n", name);
> +		return -EOPNOTSUPP;
> +	}

[Severity: Low]
Does calling is_kho_boot() in reserve_mem() break the user-space memblock
test suite build in tools/testing/memblock?

When building tools/testing/memblock, mm/memblock.c is compiled with -I.
before -I../../include and without CONFIG_KEXEC_HANDOVER defined. As a
result, #include <linux/kexec_handover.h> resolves to the empty stub header
in tools/testing/memblock/linux/kexec_handover.h rather than
include/linux/kexec_handover.h:

tools/testing/memblock/linux/kexec_handover.h:
    #ifndef LINUX_KEXEC_HANDOVER_H
    #define LINUX_KEXEC_HANDOVER_H

    /*
     * Header stub to avoid test build breakage; we don't need to actually =
implement
     * any KHO functions as they are not used in the tests.
     */
    #endif /* LINUX_KEXEC_HANDOVER_H */

Other KHO helpers called unconditionally from mm/memblock.c, such as
kho_bootmem_overlap(), have stubs in tools/testing/memblock/internal.h:

tools/testing/memblock/internal.h:
    static inline bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
    {
            return false;
    }

Should a stub for is_kho_boot() be added to tools/testing/memblock as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104204235.9066=
-1-azpijr@gmail.com?part=3D1

