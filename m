Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE40FD5E128
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 10:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442846B0089; Tue, 16 Dec 2025 05:54:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422226B008A; Tue, 16 Dec 2025 05:54:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3174C6B008C; Tue, 16 Dec 2025 05:54:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2149D6B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:54:30 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7387C05AA
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:54:29 +0000 (UTC)
X-FDA: 84225025458.12.5571973
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id A109DA000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:54:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FOLYh5z7;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765882467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tD9Lp67s7fpdz6A6waWN21OJYKTBdSKb+Od0op95dQE=;
	b=l3Lh9zKo3/XqDJdYFhdPEgM9GZ9IjEwOcPmgByeeGKJnUsv8hkdJo4VWYPf/ky2AfO9tPD
	jViS+INdhQWEEqi2G7NcvF5Ds1zHolPEDmjHbs3PXNwRFB5nZPfxtk3pJk8ZN2p0IBujt5
	ngZsPEbS/uxFXqNiuio1Kowcsb7xJrU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FOLYh5z7;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765882467; a=rsa-sha256;
	cv=none;
	b=ZSDEdTwx1RqslgcxA4WSr7hiwuHeOCIo0e13nTVmnBmKAfH0wBYyX2ozn+pdc+MODiDnth
	EiLaryveBUvnv7oo1Z4aJlMxaGrAQCLJOiRZJIzCKIYu1kmoZ2Wez6xWcXDpbYNg5XQp1c
	ypTqysNOiiu6+8pb77nlcbGZK2nBvao=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64312565c10so7862246a12.2
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1765882466; x=1766487266; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tD9Lp67s7fpdz6A6waWN21OJYKTBdSKb+Od0op95dQE=;
        b=FOLYh5z75PpnENnVWhJBGk+IGov4067L7z5hDKkc5GGvXlvOBC5QsZgjSEJ565knyt
         yo0aocvOownVxzcweGnBsa0pMLmIZXHaGgcLBstIwirN6Fju++ze6NOqRIu74zAz/pZx
         9gBxdYHnSJfkwE5sVG18j+ZjO8Iv059cixLd63+V5WClvIuCHmplAdYAUWWmPNFh7ZEZ
         2VW0ZK93KhKJ9A3pJ2GFKYfYXwzQgpLHX6rLlVe/QveoopVNtib5V+FBEAkvyyg9mveb
         SXxJKVd7cZjRbx0sR+5WysFupUeRQIqZ+kBpn6bSWRzi56cENbyUoTzuVmEYteGD4aYK
         eyng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765882466; x=1766487266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tD9Lp67s7fpdz6A6waWN21OJYKTBdSKb+Od0op95dQE=;
        b=SJ799tM+gyvhHk7rH8Q8SuATiPWpxkUqwBCKVw2jJGwCnw/6Jnp8jyaSKOhnm1X0hS
         uV/FmaCJIZ85ZrdD7e/5OKTjdHYwab/FhXHPFQIU7UhN4RG5iaw3wzGVOpEBap1dXnlN
         m7mfgpfFCmA7cujOzOyqprs4r2+VwqJAKFMnBjr5j8KRNt3LVTR0Z8KeBwbJK/T/GBWm
         1+/kkjr9QMpWnAj2qHYms7vj6DyzVyC1n61r9H+ryuWoIvjdMueKivVv5I7t7wtIqWy6
         RwINnAGjQvFreRcjdqrHxh/teoivDTMcZu0tgbGSUNXXSBXEyvRHW7HmXQkc3jadCKYO
         5ujQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+SO21zNxyjTcR2n5ktHrK/1bq1vc11BN340dvAsQ1Mqm+byM9ivVeUzScNV68GsLc5grXP4yogw==@kvack.org
X-Gm-Message-State: AOJu0YzGoEmpq7ao1pDyIQKCAFpj0eGYsH7UR2zfJ00YnYGdqb2rj6a3
	NhHj071QkM0yAq5LZCDM74K98HROX6VawvFYCJxqsBxayMtFHBYURu8DuTq4joUvfhDuFyEHkVB
	ci0v5H/a//61KAZSQ4oSKdzylYC/wBnBCYgX8pqfMZQSzoBQuMOKyibg=
X-Gm-Gg: AY/fxX5QKb6PnlcuV1b+ODTtULDeJUSWV96i9CEtehubedSUQhvMDwNVb/C3WahdlPS
	7RkGMSfOhI2eUugRug68AtaSuFk8Sjs8DPGThSVU87oBj+WXk7/moXF1mjXmH844C0x7w0neeyQ
	EIlin2XxkW1qRWC5TuZXOGzn40L/jTqzUHxtwKBKQi0M9qXyWc+SwaNYgad2kYREJ5Su86G4F/q
	25km5twUuFH2HyQyt96GDoy4PSlB2+tOh4ZmlIMKgMUhpz6+Nc1f51pN1UQwEi20LJwwP8u6cQt
	ksN74G5K5hqbP1QaJ46UyZpg
X-Google-Smtp-Source: AGHT+IG8p73VOEd7PIH7r8dPppBNaqwWAp6Ul+8IZ1rzMRtM5hnO+5XyLdPBbMwU+FeyF1VpXJUhh7Mk0kFKx5MSPVw=
X-Received: by 2002:a05:6402:1e8a:b0:647:5544:77e with SMTP id
 4fb4d7f45d1cf-6499b1e4cb3mr12436882a12.29.1765882465622; Tue, 16 Dec 2025
 02:54:25 -0800 (PST)
MIME-Version: 1.0
References: <20251216084913.86342-1-epetron@amazon.de>
In-Reply-To: <20251216084913.86342-1-epetron@amazon.de>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 16 Dec 2025 05:53:49 -0500
X-Gm-Features: AQt7F2pQE57kuXlYblzW6adJj1GXxwk29ATnbIbA7QihcN0-E40g7fo6gXcODdg
Message-ID: <CA+CK2bDeaEc=9hENwz+LaJ0DXuvL0PxU0_MGKtZh34YkrQT=3w@mail.gmail.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1tixggx4wh9ikurbbp1ygea87gfkicmu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A109DA000B
X-HE-Tag: 1765882467-699104
X-HE-Meta: U2FsdGVkX1/8hwSbDxVmIF3OqjUbdp6lqaOmXUrkOgKrKQ9TlR/uwn6eqPhEFsiU+rb6eij5pAiF0OOkpKPIlDWT+MWgsPXgOcxiHPRBHYfahvnO/lcu2Q2+P8CB3DCve6bsuo9XkLTDlIyiS0hK4jcs5XQZMLaV+9TzHpXqY71Jt33hv6Tqgk5Wq8Nks6l+c3Y9GRtJ/+z/Ps7pG4VsrSay6byDhMENrJog/ZB+kecwxOTbUEk/01iWvl9UeOhQt55JRr7vZkhlsVnljdJwEoLrDt0OBy4vXjl4M0wfXpXiJjZglRkkpe4Gng101M4LeJvS/ec3olTa1o2QcUNf1ODizvBVPRTfBzhf4u/tEEyVjOSSFDxuLJ0XxoYsitsoM2oK+XWro98gDaLrwRp0AIQ7m8nI7rlNLLdbute8uXKPOjeGUgJ5KjPzTAnokOKDyyankMEP3Pkz6+IZpUXTFQx1AIEwUXVX3doJUdoGbt5/oPWTEma8Kyy3fWTwBsbQ17dP3INhTg8QVZJcV99iXXD3urWm33zNs2j4sq8mMJY2TM36NcHM6r46tSDBq1bcFczRhGCz6Fu6ckOYI60+kNn2/Fibxdqlss9csrKhiVUr5nq9dc+Pv5fa+me7gp6PLwEoQOFs5pNVvJJ0fwUQSKrLTTVeS+wywUZp19BJKEZsfvx4VVzdGsja4Acmx/I/vpWcsUKp6YUUnU0IBj2tErgdKYKvdtyoIBUqHGF1ke/v0d7YtI5MqjtoMsoBsbr0zfJZIuYippuVkC259mx2jnh0+QYKhytb9zcl/UnSApzAxcxe5RXoGCDAIMVDX8iw8PduI4NAvJ3zGV82gA8AGgmt4MiSQ2xb2sw1rl4rDFQIhA8Q39Y+m32BKoNfxqvGM0Bcrl3kAO8sveGdhuiMz8Ce0f9uRGZ2InktDGP5BUFrmQ8tpqZYbqT9F8bg3E/7A9FfphkABXpOkGC6Ls8
 GmPrEcJT
 3V5ExxQAhZgtaKlTsqDvN3C4GuhQRySJeUgYzilagqVFHW5DOEFl8KImIm1cMwGRnYANBmLTkZtKh3OGdqkqCO2HZPV6l9BD9sA/LbPbojsnbDyVPUZgZY+Bp01x+ahaGz+QRPMTk6cPC3Wf7aQ3V2qyFd5mxuGuJCaUmhhaH5LP3k5AGsLIlD3g29N/GqPlS+bETpH3Eb1mNHtsjaJD2d5WcFRoLADDazUrHA1HhPro5qYaw/Z8Ytl7HyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 3:49=E2=80=AFAM Evangelos Petrongonas <epetron@amaz=
on.de> wrote:
>
> When `CONFIG_DEFERRED_STRUCT_PAGE_INIT` is enabled, struct page
> initialization is deferred to parallel kthreads that run later
> in the boot process.
>
> During KHO restoration, `deserialize_bitmap()` writes metadata for
> each preserved memory region. However, if the struct page has not been
> initialized, this write targets uninitialized memory, potentially
> leading to errors like:
> ```
> BUG: unable to handle page fault for address: ...
> ```
>
> Fix this by introducing `kho_get_preserved_page()`,  which ensures
> all struct pages in a preserved region are initialized by calling
> `init_deferred_page()` which is a no-op when deferred init is disabled
> or when the struct page is already initialized.
>
> Fixes: 8b66ed2c3f42 ("kho: mm: don't allow deferred struct page with KHO"=
)

You are adding a new feature. Backporting this to stable is not needed.

> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> ---
> ### Notes
> @Jason, this patch should act as a temporary fix to make KHO play nice
> with deferred struct page init until you post your ideas about splitting
> "Physical Reservation" from "Metadata Restoration".
>
> ### Testing
> In order to test the fix, I modified the KHO selftest, to allocate more
> memory and do so from higher memory to trigger the incompatibility. The
> branch with those changes can be found in:
> https://git.infradead.org/?p=3Dusers/vpetrog/linux.git;a=3Dshortlog;h=3Dr=
efs/heads/kho-deferred-struct-page-init
>
> In future patches, we might want to enhance the selftest to cover
> this case as well. However, properly adopting the test for this
> is much more work than the actual fix, therefore it can be deferred to a
> follow-up series.
>
> In addition attempting to run the selftest for arm (without my changes)
> fails with:
> ```
> ERROR:target/arm/internals.h:767:regime_is_user: code should not be reach=
ed
> Bail out! ERROR:target/arm/internals.h:767:regime_is_user: code should no=
t be reached
> ./tools/testing/selftests/kho/vmtest.sh: line 113: 61609 Aborted
> ```
> I have not looked it up further, but can also do so as part of a
> selftest follow-up.
>
>  kernel/liveupdate/Kconfig          |  2 --
>  kernel/liveupdate/kexec_handover.c | 19 ++++++++++++++++++-
>  2 files changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index d2aeaf13c3ac..9394a608f939 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -1,12 +1,10 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>
>  menu "Live Update and Kexec HandOver"
> -       depends on !DEFERRED_STRUCT_PAGE_INIT
>
>  config KEXEC_HANDOVER
>         bool "kexec handover"
>         depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FI=
LE
> -       depends on !DEFERRED_STRUCT_PAGE_INIT
>         select MEMBLOCK_KHO_SCRATCH
>         select KEXEC_FILE
>         select LIBFDT
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 9dc51fab604f..78cfe71e6107 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -439,6 +439,23 @@ static int kho_mem_serialize(struct kho_out *kho_out=
)
>         return err;
>  }
>
> +/*
> + * With CONFIG_DEFERRED_STRUCT_PAGE_INIT, struct pages in higher memory
> + * regions may not be initialized yet at the time KHO deserializes prese=
rved
> + * memory. This function ensures all struct pages in the region are init=
ialized.
> + */
> +static struct page *__init kho_get_preserved_page(phys_addr_t phys,
> +                                                 unsigned int order)
> +{
> +       unsigned long pfn =3D PHYS_PFN(phys);
> +       int nid =3D early_pfn_to_nid(pfn);
> +
> +       for (int i =3D 0; i < (1 << order); i++)
> +               init_deferred_page(pfn + i, nid);
> +
> +       return pfn_to_page(pfn);
> +}
> +
>  static void __init deserialize_bitmap(unsigned int order,
>                                       struct khoser_mem_bitmap_ptr *elm)
>  {
> @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsigned int or=
der,
>                 int sz =3D 1 << (order + PAGE_SHIFT);
>                 phys_addr_t phys =3D
>                         elm->phys_start + (bit << (order + PAGE_SHIFT));
> -               struct page *page =3D phys_to_page(phys);
> +               struct page *page =3D kho_get_preserved_page(phys, order)=
;
>                 union kho_page_info info;
>
>                 memblock_reserve(phys, sz);

In deferred_init_memmap_chunk() we initialize deferred struct pages in
this iterator:

for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
 init_deferred_page()
}

However, since, memblock_reserve() is called, the memory is not going
to be part of the for_each_free_mem_range() iterator. So, I think the
proposed patch should work.

Pratyush, what happens if we deserialize a HugeTLB with HVO? Since HVO
optimizes out the unique backing struct pages for tail pages, blindly
iterating and initializing them via init_deferred_page() might corrupt
the shared struct page mapping.

Pasha

