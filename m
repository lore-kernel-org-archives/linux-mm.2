Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B253ECD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 16:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3396B01F5; Fri,  8 May 2026 12:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A1E6B01F6; Fri,  8 May 2026 12:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A07B6B01F7; Fri,  8 May 2026 12:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB3EC6B01F5
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:27:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96E00C0A65
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:27:15 +0000 (UTC)
X-FDA: 84744782430.25.93F5E53
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id A00394000A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:27:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Me90w3N9;
	spf=pass (imf11.hostedemail.com: domain of jannh@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778257633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWrAzUBaU8exS/YJJSUkuMAq0O5XPD4cN6KpasU2G7k=;
	b=owYCtZnfSX8h/pDHshjimco9K8ACe+S6OIKObChHmM+bv+2dOsdfPSKnspB6qWV3a+hiU8
	BR02dkLLY+xTeq/mt4kLKhMo9d8emHMIiUiLTpB5CZ9ZZkG/qmvZjgsQTHTrb+ixKNFQlj
	J31dF/jeUZkZL2YlMJZIynLanm+2rqc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Me90w3N9;
	spf=pass (imf11.hostedemail.com: domain of jannh@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778257633; a=rsa-sha256;
	cv=pass;
	b=nz4+iIFH3Uu+Z/EFALqwbVf3bB2pLyiXHWNrXRpzS+SI9KeKmvskparQ/w8PaIQzIWKvqn
	xENteY+zicfnN2x+vQvRoGDp+I7BLNRk5zs+V6jmSY1dkbtXkCutDz244XaAGMK36EOlJq
	2+uT1D4bYz6lQm21rcL6XNIRhtwKoIk=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1270fc2bdf2so10535c88.0
        for <linux-mm@kvack.org>; Fri, 08 May 2026 09:27:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778257632; cv=none;
        d=google.com; s=arc-20240605;
        b=ezhJNIqyCRs6wuqjrhl0OiSYkRXUM2q7nvHLykk4uF0yBSF6v5gNLKTlDGsn3NXDKx
         WEZHrO7HUE06ySl9MpL6pegq5VEIQBeGzNTJ98zfDcUiBMla7YmUdDB4CdWM8iRdaI2n
         d3FBx/ruycISOl1oxUpnhBbcalVOWQxwnNlnT5fSn0PJMDlBaBehg9MiI8K0Kn/lWJv8
         BSiV8vtHE4lKF4auYU1ECgE7+TdrKxfC7hN08jZwkGeW3KE8Hq1UmI4d4UpiWXN4SInw
         syeGjsEv6n3Ji5eSMkvBaiP5P/7F5jJRVcebHUUj5cEuMt/pfBkS2TOASwv66TShpAyK
         GOgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LWrAzUBaU8exS/YJJSUkuMAq0O5XPD4cN6KpasU2G7k=;
        fh=iRN60qhK9p9DsLQMzoIkuzOwiJPVU4JMk4lyt5T6/ok=;
        b=GKxgL+bRqGUxK4ynkk6Bm/nbWugrTVK1jKMYAnbSmz3tSskcPuGoAs1csaINC5WXm4
         o1hENwnuT8IYRMtmNQdjp3T6HheyWPyom7CKK3gRySiNm7As9a4fqjuv0jXBMfcQF8Vc
         9x8cZhF7BGoIjaZVGxLtMzWz652gB+OUtBsyoOboFq/xIwDOHBU6Kt802jVtCQBAtxwn
         PK+vGAV7lrXSPkkJpVClHmebyDetvoGKqq+mV2cAQnoMnqu0+IVk96FNXUDg71bvfYmP
         pSVE5OQLlly/a2nQAW1OxNoRenvswuBlo+B/n6rk5wve4+sFN1wRku2BtwQ4wttmDTr4
         Mt8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778257632; x=1778862432; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWrAzUBaU8exS/YJJSUkuMAq0O5XPD4cN6KpasU2G7k=;
        b=Me90w3N9wMyrTKogxykRCvFuyqRC6fxsQCw4jvl+ICI9E3vsktoUCcTZO9hEhVml4m
         5RgB0CqpJFl23jqm1Rs8oVbOMIj43l0DNS+86Y6X6oZguWORi7FvGKpbuJX6BW6XOjnD
         mIUIDtA2NJwJWkyV5NIj1cYQNTxS6L0GzNyQ4xwJ/oV7dKSk9QksgcP1j8WaSJY3kGgO
         FWzjyf36HZHrA6we9HtwILjgCFXdB8HFBSMM/34QZIr+itBLSrPaodwjqBKpPPuYytky
         9ssGQ7A/J6xUndWJQhucvWndkarWofOwy0S+CVHcTa8MfYE3/1nv+2Z0tGJK/hTgqA9P
         lotA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778257632; x=1778862432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LWrAzUBaU8exS/YJJSUkuMAq0O5XPD4cN6KpasU2G7k=;
        b=ETclaL8fr/SzcHQNIbR6eBy88Qbnhaa8jhG5ZTEI9a5UatXWCpC8ora0nuayc2nYbN
         Xk6DcAASTrpnZ0zHF7XzAcClWlwrPnWvSf/dSNakCvjUBFg5IdIPpZUNl/6S5bGYTIaI
         nrHXGi/Ka/egE93YkIajEQUBBRiAPK6ZXNb4gFV4ZAapr8XI9w3Wm2W8EcyUxcNRORSE
         fXVvqDOt3bBW+lUtKz+IypaaVpT5MQlyhFP/gpPxmsABM12tHGC2Lkbp8m4k3q2ESxEc
         aRNQVH+2bhFI5Bthl/jCgquGGHiEDTera/fmxdSDTEQWsvU7vbAsksEj9SBTanxTWx6o
         2pDA==
X-Gm-Message-State: AOJu0Yz/sl2LqHWRnz3iU808I1YPa74fSv9Z5TyyA/npcBy7gijkjYeg
	vOfleCisyItqMd4eBOvLfcMD6RA5QjEtdKDJYQg2drhNgB2qtr/8E2psFcrG8Y6cL5RuMgGJC3M
	9RxGvwTMSyJNTJN1igRverv0n26O1SBgAlH2MepCq
X-Gm-Gg: AeBDietQ101hZG8UYs90EluqRja75RCzGEX7rLrqXcb31YAq9xEnKQzPgwM/PFx/ZT0
	ADP08Apyrzka4S2NhmJYZkVGSAM4Tn4rvHRM9UCykJW6NIRqZO0mRwyuLnUDhfoF9aNEBzsVynG
	LYwxBATbPYI3i+H8prZSPwzCXiqBG+jh8JNI/TIwqQHUxAtaCMS6n3RfoidBKmtvbhsrF3Mfi3B
	fIThBlH3IfIg+Idcsl67WE29U/m+x8fi/LanBuOz4vD1lNzXGQTkxU0I4f4U82ANMH6nJVmevtt
	+YjILLubgD3BOTXkXvlUpg9qkWcWiO/l8T/HBX/44tBjQguY
X-Received: by 2002:a05:7022:1b07:b0:132:1e01:86c6 with SMTP id
 a92af1059eb24-1326f1adf79mr146458c88.3.1778257631452; Fri, 08 May 2026
 09:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260508-ro-zeropage-v1-1-9808abc20b49@google.com>
In-Reply-To: <20260508-ro-zeropage-v1-1-9808abc20b49@google.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 8 May 2026 18:26:32 +0200
X-Gm-Features: AVHnY4Ie_zoehI8s5zgNqv30LukVADTdXtN2wjCtxwLZ63ygAkVHFVZmFiSPGIE
Message-ID: <CAG48ez2ed44M=-qsZO7gwcz5L2njdRdk54d47jEg48MhWTkaew@mail.gmail.com>
Subject: Re: [PATCH] mm: make zeropage read-only
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Seth Jenkins <sethjenkins@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A00394000A
X-Stat-Signature: k86nrph74i1743rrtwa98xdbm5rhcbq6
X-HE-Tag: 1778257633-926372
X-HE-Meta: U2FsdGVkX197ft7hvlwdpct/Bxjm+QjgWwX4MW8MeRuUzy/a3ZrxpOGdYP9h4l2x8qSknQe6hOCP+jmgK8RQ2Gh52DTq5U+3TUVjAGucb8MkZt0dVqcAr3YqRJleBAmeORdeW1kzZEWk8HjXdGgNUfBy9FwNpTOdUQXg8RRHtdTtCkWQaoPcJ7m4kCbOrikZEdONKwr7aWX7Kbs20h1odW3N5QLC+h6BiyFwbdG9g0BMK9U7Pr7dLkRoBVz1onZ/L5ogbWVS7WuMMH9B3UjAIDoN4QvYfXxnoxQ3GfiFp/bzs7W0IuE7zQy38IcKB0J8M/5dvi3pv8fdc55qGWAZrOo6RMoJ0Wo9xxz+Gzulo9MJQcCHEVxIELAsgo9u34/Hfn2vFfwfoUW2qXB1WO0IcGmXj2HhsT1Bpe67OTJjibrqJJIlhikDlVDNXAL0sa45F5MKjdkw2R0Y2DAI8+Dxxj0BSpwHIO4CHtBc9wj2nkpUYMdvBDSmnPjcTgZUyz+n4yUXQFNcq0F3q8K9PoF4dlNwBRpS6B9Ha1PxjYwwjmhrcT94S38SJNYbtUMN7ES5GNN7c7CWGXwF+AMGjWxDRXpJmkVkiG4EeRYxqmOWYeb5+/hrta/XAkpxR/FdFGiBx8Z2//eGFG0dM0OMBMXLPHqbTCee/axaDoq/Nnw3DBk88LRGpq8zdJ79SuYwKg1Xl3I1HB0yXVHyJG9kgA0Um4XY8tNWNQT8xqE8AtFesz8BA+EghllDsDMLJmNmXRSpOMALxOgmmoxic7/BNgkmiX8J6joPrvaU8OAdNfx+z2MnfncdIG46Dk6iu4LC7AaH+6kem9jMEkx2FoTx9HFY8T9d7Oe4XEBPn+CFwKGFgODx/S4uNT9HlQOz62eNGBSDl7aJgAB6ECEMBxk86/+NaeKAq/YmQzR+ojllH9J0ngT0M+zjJ6lq6Cc9sDC1Pt/DL0unqLevvF5DXCoosk7
 EivHjaBd
 oCaSS21lLFfYync/+8CRapKAJOn8sYz/c8/myxrIKt9syu+CnvOgBatn9YcNiQVUXim4I1UDRcLwkX+NAf3dthH4gPzECdurLPHKDWqrs7RMwjkEVa1IRY4o+ofBEPpessvFzHC1DaejtIhgTAaT1ck2BOJBxDRJ8H5FY1S0Pp4mRFOo3tGREy/JDaxWw3tf9JyMI9B52BVLXTcyPJAh8CvLSMn2DRSe22a/0n4MQE8mbtG6bTohHcz1MmwobfHckterIEhDS71NITlXKJB8GK92UI3QnocqRnQUCuJAWQat6/0CoLYXOdFAAAfazDm+jL2f1iN86ikWrsum2IVV4rx1mfOzcysPuRuM4i9siCwox2EU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 6:12=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
> Put the zeropage in the read-only data section - nothing should ever chan=
ge
> its contents. Set up a new section .rodata..page_aligned to mirror the
> existing .data..page_aligned and .bss..page_aligned sections.
>
> There have been several security bugs where the kernel grabs references t=
o
> pages from some userspace-specified source, via GUP or splice, with
> read-only semantics; and then later on, the kernel loses track of the
> pages' read-only semantics and writes into them.
>
> I have seen such bugs in out-of-tree GPU drivers before, and recently
> upstream Linux bugs of this shape have been discovered as well.
>
> One problem with these bugs is that fuzzers and such will have a hard tim=
e
> noticing them, because the kernel has no mechanism to directly detect tha=
t
> such a bug has occurred. It would be nice if we had debug infrastructure =
to
> keep track of whether file pages are supposed to be writable, or such; bu=
t
> for now, the easiest way to make these bugs detectable in at least some
> cases is to make sure that writing the 4K zeropage is mapped as read-only
> in the kernel, so that attempting to write into it immediately crashes
> (unless the write happens through a vmap mapping or such).
>
> This patch might increase the size of vmlinux by 4K since .rodata is stor=
ed
> in the ELF file while .bss is not; but the compressed kernel image size
> shouldn't change much, since it's compressed.
>
> I have tested that with this patch applied, calling
> `get_user_pages_fast(address, 1, 0, &page)` on a freshly-created anonymou=
s
> VMA and writing into the page with
> `*(volatile char *)page_address(page) =3D 0` will cause an oops.
>
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  include/asm-generic/vmlinux.lds.h | 1 +
>  include/linux/linkage.h           | 1 +
>  mm/mm_init.c                      | 2 +-
>  3 files changed, 3 insertions(+), 1 deletion(-)

Seth pointed out that this is more or less a duplicate of Ard's
<https://lore.kernel.org/all/20260427153416.2103979-19-ardb+git@google.com/=
>.

So this patch is redundant; sorry for the noise.

