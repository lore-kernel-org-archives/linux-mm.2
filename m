Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD710CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 17:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 481216B0204; Fri,  8 May 2026 13:03:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431AE6B0205; Fri,  8 May 2026 13:03:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320AB6B0206; Fri,  8 May 2026 13:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2247E6B0204
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:03:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6DB91C0144
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:03:32 +0000 (UTC)
X-FDA: 84744873864.27.780C762
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id CCCD9180007
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:03:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o5C0yecj;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778259810; a=rsa-sha256;
	cv=pass;
	b=s2nYVqejEUsxqXT1XhQsC7L+LwYC7xy9qfcNGH0u4wr3X1VPAr69GL3QWwbHKc1okJ7/ym
	FaO1bJmxOA3JXAUftZ6d4B5JGGJtKRgEqk3fRRwB8y6mxhMRLJbNuCWwAvnw9AvkeoJKc8
	BphYtB1ydmQ58xn2g/rFQJimcGW/ACg=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o5C0yecj;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778259810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qBZJCatbKW31QndpUrt3FNHubTaN2agrmTU0pE10pw=;
	b=asHYslACz10ixOC/WBQ7sVgTf4KhXm2c2HrDN8eZfhIKBFYOMxSHQAfgl9weV6ABWt6i1k
	FcfJZosmsoG5ta2fBmBshDvn0erK4W6n4DWAFbZ3B27ctZdr3739yl59f951izrER0AA+m
	ZapL33bBlwTZWCeX47N1x+EvYKo3vSs=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-67bf769704eso213a12.0
        for <linux-mm@kvack.org>; Fri, 08 May 2026 10:03:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778259809; cv=none;
        d=google.com; s=arc-20240605;
        b=LWxLPsSdk3kUfQpPMmr806+wxz+uLbXmkLhyFt92Ct5BbwOo5tiZ0Cw4LOYBT7k0w+
         tNKw6xUQWGYAcEIHugtR7knw3o1DASv5nr726o4qKNTjWht0BT6vGCAvG3bJsNn6HBMX
         1/8lZXnKjoYTpPdi1mJue3rSluHE2PLLKQX3KSNcFOmgkA2uAjWTlUfx8dx2W5rPHZNP
         ekgOGnh7x+PHjFZkMIS9esst8DlT2nFhCIs4ygvD/gkmWVOn0QF2ZuA5UX30uOGQbq8E
         VYZvQL4y9AgRpKx1boOE7tg7lagWBzNm0GGMeDzUChcbuWzoM4pAaz1z5Cyt3c9I0UE4
         CoZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1qBZJCatbKW31QndpUrt3FNHubTaN2agrmTU0pE10pw=;
        fh=orqO2VDgStB7CNtz266yxOl3Fka1fIq1EQTQTU1BIH0=;
        b=RlCdm28lw19VYBL9uetcx3AWKCK0zd6gALe/3hBcehE3COO771gQOXwIVexSD/jy1c
         gRIH0pd65Zy6uXMf7AMGpLBkLunw09GDXkvAz+pFmQO9XfnG2ldlwmegVy/Q8RK+Szu5
         cwLKrb0vym+94kouFMIagR6DP2wNb8BhGxYw3s/tBay8OewCvAqK45X0lZ8ll3ynUAKU
         4dEFcPCvNlT24ko68MlbSNi4ndZUIEv1niEUqmFNDR/ahT7JdjCX8VuHOC/XRTGUoyGN
         68xVTWwU5Mk7uEkRognLby/4UjCX+9E0Ql/3gh8opxb2mNhKG1vG8Ec3w+vzu6nmH2uA
         uQSg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778259809; x=1778864609; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1qBZJCatbKW31QndpUrt3FNHubTaN2agrmTU0pE10pw=;
        b=o5C0yecjIUXks3TlL9+rbDYfp8fMgIkyppyBjMe/AXPC/2GISpfIkK08kfT1rPsd4x
         aSp/dyob+Peyu/wmR0sKRZmya6W/RzKSm/5lVTqryp/2VulWIIglsgobDADj0HGKmIkp
         brjONCVD+IqyncZkrQ6sOSUxtGzUJOljT5Iha3x71ptnXwC3DJj2phgRnxQpSeg9vxRf
         K/e6fy5XqM5Zg70iKEvde12P3LaactrHWPuB6r1jkl7Jrvx5YIfcl4sHRT9TWqQ0ZDZF
         s3XJ/ZUaw2lhmikz+CG4/iWVpNfhlHEIdt/sSOX9QpW/J/hMp5+BMczzCAEjI/9CMPB6
         gU9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778259809; x=1778864609;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1qBZJCatbKW31QndpUrt3FNHubTaN2agrmTU0pE10pw=;
        b=PHKsAo+HW9V7zFHD3iMMRhYWH4xVdTC/8GsJ4DoZ0/fpfx0NXuyBfcAnJ+R+LdL9o3
         AaftqxG1T1mqKn5BCyUEMv9g1aTTOuf+vqmmUze1Y9ODBdFyZ0gfKoMbQs3H49y1izKR
         Wfwz4DVJlReRXcdA90Ssz16l2CoRJmBt6Xfo9b5VcvWe71EigawCvF9ySvCQC62VyqbX
         +iXSpLeuMUrQJdrZ/kjJ9xpoMR4iZrpxHrJYBP/QEr0IHY9YTYTGRHNGO6Jt/h79JxdN
         OP1NSDH4sXWJx8FpQp4/P8MzhnESZ8PQXVOMQ7zJGuLE4u5A6xfWsbIY2i9xCH31w1xR
         y2lw==
X-Forwarded-Encrypted: i=1; AFNElJ/Vi201kllHHKQE85WOM/7C0Qs10BQGqGXdmZxWQ2qNmUrALNm5h6Vk6cWkbktKttK3rxizN6l+Ig==@kvack.org
X-Gm-Message-State: AOJu0YxmDU+ymMk8nLK5W/WPqexVju90gAQPxaoGMYizRiHM3siWdRQR
	jJp5IAicdK73MS39I08y+Nygbue57g62a6t1o5bZ6P49JMixFCjbAZQQJZcHezHknLYOKigJUPp
	Yq56/hN01ss1zFLn3m5rSlnfPFZQ/qPGrkf+ykSOL
X-Gm-Gg: Acq92OH9lGOiXUB86/tewmA0HeXTlJU8hpX31nz8wobxsEy0I5wMIv9wuUwgkI1cWng
	WsZaDwEQvyCx2TjIaDg+ecTGuL4cqtCMnlgS8kTCM3pQx3F139qiErPSwdA/D1Vv/dGfT7/ROlx
	nvbmaCzro7A8yZcyci7+i4Gh1qv8mZZUqoDUCWuBp81niKKIMmlKoOkGiDGaKD3O8JctRa8DSVt
	qvdAAQ0Zaowm9QWKaISqDvSMm8H/t26YkDSWmmNstPwJgehJl7GPWeE7fZMLWa45MnJ7W0Y6TBU
	TAi5mpgMeM0i1df/eOV40lQQcjqELeT0ogYEOanJxCPu2E6N
X-Received: by 2002:a05:6402:2b9b:b0:678:93b4:1fd3 with SMTP id
 4fb4d7f45d1cf-67ec504bd96mr99834a12.6.1778259808513; Fri, 08 May 2026
 10:03:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com> <20260427153416.2103979-19-ardb+git@google.com>
In-Reply-To: <20260427153416.2103979-19-ardb+git@google.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 8 May 2026 19:02:51 +0200
X-Gm-Features: AVHnY4LQJXE4H1yzg2s_XNJ6vUI7RiUknwjEFltvEk-tdRdSsPKhVQM2Qli3gQk
Message-ID: <CAG48ez1DJ88a0pBCE-Q0VXyDuJgng8zdunb38g4b4JPU88exww@mail.gmail.com>
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, 
	Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: i5wkhcbuqp3kgxz3pzp73i91q58s5zqg
X-Rspam-User: 
X-Rspamd-Queue-Id: CCCD9180007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778259810-106607
X-HE-Meta: U2FsdGVkX18sTNuM9sN2VmLXqLCDksddbVRg6qQLnQsBZ8U+da8aYb5PwvB6mD/NNzBXGUwYYSr3uwPWFPdNQhuz2neBWmbVcC+XPww8SsBmJr2yB3E0UWC4hu/WF1GXgctT6drU16SoUg54R4OU/bnmiZGtQocDGBj3X9BmamVJIPT42vNZdRFRjsTmBRyrGqP+NdIvEjxNj9Ow5Qn0Di5GDfpvXHfsKMv9VCuPuk/VfmOviTs9cXO0XllSHFKzOlzbwL1sQXOofVEbID8HCbEQSJ3Yocmpv4kPLjPuroLilSMeq9W/LnsdOH2YfFtIaLRT1uQ4VHBMOZwXUYhYmmpjlN8jBkq5ucB2YZTvFpcXMGmD1NTiSKHXrfO1PSFZyBrwnneHHvZfqJv9OmDOEgwfCr3zm5AXSVqcn+YKHQZ/VorlGk0ixiVh/1N0VJ/VMvt6HkVPACqmychflY+L9uNUsOdxJSmihV97OUY8A5qhh4uQOMAHN+OaHldcFP5a3/xbtXDPObjQFO2BtT+EA1HLv7qB4eGTeDtp8HCMzgHBw4kqQKGZ5kSuUuBh9HGRRwRQOwkzJ7iTaiXzrcgy0D9WOGLtSMxWxTrLqhvKmgSg/XoyUWFwa9pZCqLRgMf+7F7s8Jt96u8i3bvQU1M+58y7FifkP13KTiEJBx/rx5lTHUplLArbEsJFJKcEhIUq13d0WTmpnM7Ucpdyz/QqT+XRietkCznvgSjVfHr43XwhfInutNpPOvytvGXULr38Z4eh3B+789PM9x5KG0T6+k0/f12IjiGmmT87w61/xiyEe0i9J/wqJ4iFpR5DCybf33RS1v8sJ0EoMRzSYvk4D2IuIBaZmTEOiY3RUOKEyL7LMzEXKxoemGHTGJMXCoUDt1hXBUT9PJepkABL2mPUdbAY86w/RynpzQ9GPwb3xfJNbAgJuLLnN3KTIjdT+6/HMItvG12cVYlcMcPHvLV
 hI1Sg+Xn
 Dcz14DW7pueugGz0DlPxAQY7cZz3NAT+EtuI+lcpRcfXGEOx/pHko2Tu9RrvwA7wCa/7ZI8LbR+U3qF9EtMmbCRC7dGIn/XPeBZxXs1XbAQGUlrGLrxZHgyhEREuTcml4mUgM7IL2LFHtPPIABMmTofLXePftLixztNftDEzp+rQUsLB8ZUotd7wlv/irOysu+Mtx91rRkjqgU2g/66QZ/+f/V2qvZnmNa8AadnWvn2Qq3bkQz9geXEH9HPaWlaYW14MKeokofcdAgX/FeWiRHs06EjZ8dt8bjqdmCcSmzgdp0MiKmWuSKKIyV6cigveK6wHJVxaFlQVYwmzzv2MR2I4Ydft7hHmSaVwSpMgd/aqLMJIWAuXWO+7fvtpLwk25EOd1DBfIa+4nPtb/evv5S7VkAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 5:44=E2=80=AFPM Ard Biesheuvel <ardb+git@google.com=
> wrote:
> The empty zero page is used to back any kernel or user space mapping
> that is supposed to remain cleared, and so the page itself is never
> supposed to be modified.
>
> So make it __ro_after_init rather than __page_aligned_bss: on most
> architectures, this ensures that both the kernel's mapping of it and any
> aliases that are accessible via the kernel direct (linear) map are
> mapped read-only, and cannot be used (inadvertently or maliciously) to
> corrupt the contents of the zero page.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Jann Horn <jannh@google.com>

Sorry, I should have looked at this properly earlier instead of ending
up duplicating this patch with
<https://lore.kernel.org/all/20260508-ro-zeropage-v1-1-9808abc20b49@google.=
com/>.

> ---
>  mm/mm_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index f9f8e1af921c..6ca01ed2a5a4 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -57,7 +57,7 @@ unsigned long zero_page_pfn __ro_after_init;
>  EXPORT_SYMBOL(zero_page_pfn);
>
>  #ifndef __HAVE_COLOR_ZERO_PAGE
> -uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;
> +uint8_t empty_zero_page[PAGE_SIZE] __ro_after_init __aligned(PAGE_SIZE);

I think this is fine as-is; but FWIW:
"__ro_after_init __aligned(PAGE_SIZE)" means that this will land
in the middle of the .data..ro_after_init section, with padding in
front of it to create 4K alignment. So this probably wastes some
RAM on padding.

Looking at "nm ../linux-out/vmlinux | sort" with this patch applied
(from a build without any LTO or such), I see this:
```
[...]
ffffffff8473d378 d shmem_inode_cachep
ffffffff8473d380 d user_buckets
ffffffff8473e000 D zero_page_pfn
ffffffff8473f000 D empty_zero_page
ffffffff84740000 D __zero_page
ffffffff84740008 D pcpu_reserved_chunk
[...]
```
So I think there are almost 4K of padding between zero_page_pfn and
empty_zero_page for alignment; and I think when the linker linked
mm-init.o with the rest of the kernel, it also had to align the
compilation unit's entire .data..ro_after_init section to 4K, which is
why I also got ~3K of padding before zero_page_pfn, resulting in a
total of ~7K of padding.

If you want to change this:
I searched through the arch-specific linker scripts, and I think they
all rely on the generic RO_DATA() macro for emitting the rodata
section; so creating an analogous page-aligned rodata section should
be as simple as adding "*(.rodata..page_aligned)" directly after
"__start_rodata =3D .;", as I did in my duplicate patch.

