Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E478D6CFA2
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1AC56B02F3; Thu, 22 Jan 2026 13:12:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF22B6B02F4; Thu, 22 Jan 2026 13:12:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFDC36B02F5; Thu, 22 Jan 2026 13:12:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AC5A26B02F3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:12:59 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5785513B14D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:12:59 +0000 (UTC)
X-FDA: 84360396078.08.7217682
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 557FD80009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:12:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ITTyR1vf;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769105577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cgleVbWoUUJU7J/5S8L5DRHuujiCZGV/xdGRb4522Uk=;
	b=VE7+CG0aZPB0qk1Bw9KoOr3mnF8WRK7MhUXfhrBm5rctHrsZNlHHPsc9/jsg1ID6Jy3Zt8
	ExiU6IFTZCIi45mgTJvFhEvr41PlfduNL/XMLz+hSaOEJO5xow2mPqCr22xJHyQ9EXA14m
	RTJp8dyW17wIHhLOXc3gSKVxcMxv9Ns=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769105577; a=rsa-sha256;
	cv=pass;
	b=2iXfXOckjJ0HiA1T1cq5h8hlvWUWgmHB0ieVtodrXnGXJcCOwM4iCM1MhE3bYR/IhqTdc1
	9iq69qQ3g1rW/4eN/0HqdMyyQ/nrm9PJE2Ry5IUDdQ1WE4PQFLdKgDB4zdZIXkyyxEAMHn
	Bt4gjIWEhjWeDSjmCYnwThwZvR2LJ7E=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ITTyR1vf;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65814266b08so2438534a12.3
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:12:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769105576; cv=none;
        d=google.com; s=arc-20240605;
        b=diM+72pOHlKnHmhu5fCbmMoAqLniHEBZJ2QsCI+jD6zf68XQ98a2LjS8lBfVicQmaB
         D6Jq6e4+4+CUJLAbpZKBV2bT3PwDaWZPl1rHYowqapUYv4OCB21XCoj7GiEYM4CSWc3p
         Dt5RP/bf3aWK1Mgi4TUjvERzhxIu1jKTE8/OQD14Y0iWa8m2KaWUyt2QSeO+1Z8QIg7U
         ZExaWLyNkyi6zUAXXh6LYC61GjECzETlXCGlXcFABqa0lyBszVvMDTs+BEzdj1SzWDSn
         0q3TGrGNy/GN8LeN1P/70NU+k42qSVdrS6AjrMvgev4zNDitYwJOi1zOTtPs2mTDQigM
         S0FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cgleVbWoUUJU7J/5S8L5DRHuujiCZGV/xdGRb4522Uk=;
        fh=QEQ6zrFtCDY+0sp5G2di82YmB0neaZXor9bW40kfoWw=;
        b=ghXf9G1L6mLmoSWyILMzp9wi0ZBLJNabS6N+tehnAUB7xLw6WnG16Xf88q1sxhtg8j
         28vuNnB6+ZJsrAUggTaOPRt01S99XAPPDpj4TXC+GdCKnWycTvXMwJ66iatiJIUckRFz
         O86p2S6IlZU4nOO1dMUlfy0vQn9g4nrWUrAy7CuBzGau/9to0yx6VcfK5JKxuiXZvKrp
         A/lwwZsBRAqKKHGjZHQkgh0uckQ4alFhLQ1ePhybwAjkgCEmFl7qT67IE+dnibxsOaQT
         rg+BmkOqTjMhRTBzXNIUbXloN8RpDpI/7lfLu/gZbRe1wWSw55Ru3unsiCmokTdpPii4
         nB7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769105576; x=1769710376; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cgleVbWoUUJU7J/5S8L5DRHuujiCZGV/xdGRb4522Uk=;
        b=ITTyR1vfRAVG5sL7khnLjEM9ZF9DoH7C84qV+CVFzxaYRNJLDxn+loTckudowsCMHN
         hSf5BtwOB5ku6bQb0KIVphcL80p3zgM1AXmdoxgI2rQC/UvenEDDrPfwD1cLOavN1rZI
         q+AltMG5NqrW3wnMsdndr4rYVdc0vgKbXVzsXW2HZghZKAwBSb2xFYzzK/07yslXSgz3
         g5KC/pW3J8blbe3TU9r+PfHE8qMWMchbxqUO1FrXhzMWKVc7zI/yK5XqQDqNNBmPyoMQ
         wIw1r/tcTKDVAMckwnx5fwf1Ga+0nxGf+/AucPHu1cs4jYe8jsawiBvOgi0D610o8wbp
         KYWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769105576; x=1769710376;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cgleVbWoUUJU7J/5S8L5DRHuujiCZGV/xdGRb4522Uk=;
        b=C8M4faqFVb0F3sUwfYzd8zw9BFZOaOS2UsiMa+6bO1uXyakc+4Rw9e494DvQfOxXd1
         zR2c8F4Cnvt62IJSb1MSK0FYhnsz9BL1g/nAit4fGoZhQE5b9lJIW0ogcqRnOPtz3+Td
         t/cZEsHQz7uXH2IQ0gb/ETKFZg2Ct/ach1un1wrXkA7Z35iQTbBRAujfAQh62l46YLkl
         5SY5o6ZDT50/+SEFPx6N2RrdgwTIDBCmn2YL2ZIYt7rbBBg7klk7zJlNMHfMsngXqlTl
         HG4N2lnNhf0oETSuNdF/SgDSJnJrpvvwR1KfVR+NW+/1SmHRTh+M/+ikT4lp5BbSJpQb
         uy4g==
X-Forwarded-Encrypted: i=1; AJvYcCWrR9VUa4/lX1ro/olZij2GQ87mybgDlcvk2IDYjg81G/WMVoaWOlQRCIh12ejVNlSDAgtlntiEBw==@kvack.org
X-Gm-Message-State: AOJu0YxCtK8DkZQxprewgI0YrxC6ADm6YRbVS345NiuCiXzjew6kg7/V
	exMKUNHrBFiFdkHvHpEFjpSU4YajhHhkkcGloKXxahJWrvZ0eDCTomtGn44eLtkW91AjuoicYBI
	rrKXjeprHtdbxwqxAgOIX/FXFEqxWzOqAwa582yhW1g==
X-Gm-Gg: AZuq6aLDH4u93UKQIbxgPOWP3HznHctN7OOmy7W+64ju9YPpfAZSA4uwbkdMfcLC3T/
	JMmUOBc4haJ31j5RPVRmxfAwnauT/5F4xaBw7sXLIPUhnDPMh0t7KKlEFbJsdtTw/Xpq83k65uZ
	EVFPG451Kd4Sep0jC5K8rCglPLuffL2y+1r8jwJvupzlRVrAOeZTlf2J6T8hANCJJfQeIokPnIt
	G3iy2+IkVGfqNkanQUB3cAW5UbMXr6YlHgItMnJT4eBPm0/fw2NOp5o4/+UO00pxtDFsPdo+ZX0
	BkBQbSZ0uHj/45n1hDg+KzZWnQ==
X-Received: by 2002:a05:6402:2745:b0:64b:46d4:5d54 with SMTP id
 4fb4d7f45d1cf-65848763bd9mr334433a12.11.1769105575867; Thu, 22 Jan 2026
 10:12:55 -0800 (PST)
MIME-Version: 1.0
References: <20260122121757.575987-1-rppt@kernel.org>
In-Reply-To: <20260122121757.575987-1-rppt@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 13:12:18 -0500
X-Gm-Features: AZwV_QjD1qdgR1i_TWwWe-f0Ky_qgOK6uSXJjfLb15ZCQS_D3qhs3-TkGlSTUFo
Message-ID: <CA+CK2bB-JZEFp57rCYK8wGKoGP8U1NX_nLd=RRu3ozuVn339UQ@mail.gmail.com>
Subject: Re: [PATCH] kho: cleanup error handling in kho_populate()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Pratyush Yadav <ptyadav@amazon.de>, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 557FD80009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: mn146o7icibmmgcgc6fbtgy5mo5h7ktc
X-HE-Tag: 1769105577-571301
X-HE-Meta: U2FsdGVkX18glCbQQwZqrAly7dReQukpV4LILkKLC6FAl2aD5uun/fVQgGo/srOnBsqh1EXndp7XjpWGB9XJ+xEgdLH/Jas6ORsOoCFvT20StQK/zApNu82HDCP8pbypxfczWIdMcsw5NT6fZb47IuE87YPetqbGmutPNUJq4EZ4cmwjydcKcgMiMJkQGVQBhGasZ/RB1Z5qrajAtLQqHhLKLM/P+2dT3c0p5e+fE+DFgrdhwA7U3wkz7tgA48Uzw/tX9P9hgChbc3Q775meNqd+5FzcafpHOMx1wTrFOXDgcpjLufWvem9pY+6r0TRXmmNTdvbSrYPthpwyVbslMfLzU5ktEYCWUMU8xkeVdVex49feY2yqqVTpmsjPmnfbpGVY0lYr5R5vIdrddxCwwx+WOlXCfk125SdFo/+PFyY5n0+lTDfmhM2QWPcXF3TS3NACKWNCy/LkFXQ/1Y4rb5Tw14x9S6ElAfR39+KWKk27GkVXyh1xCYzRYJtYVheCtls9RTg1SGEmRERd3JC/xXZ/7vtdvRn7vjOMYYL84FDkimcbZKT92nKnYY2kr7mEpMj1lrUH86HB/jwJeSHFvctokGwE3bo7CRptwpzoF6OJM3J3DGclPB0s7x8yNbSnY/6xrLt+iwS2EXqi7JQsSioD7C11YXSaGSiBzBiu+5ch9DU3l5YE1aYnPjJLT0Bo2iuhaQt+YMhARemgVGNUXVO2ulnY/e74NwvKMQ0yIN2YbQECaFadHWEzwkw2QnZCCQJSdyGlEIvDlB8Cr2MCx/S2TIjNzr04j53VyMTMZE/sVwfiOGauSgnT1Cg2PFTpcT1pGUSDb6rDro6aVS8FS3GK485G+K+VUDvVyt2T2emgLVDdfu5sF6tUVHHOSKM5xvwmdQbDEVbbDzAxns2g2PwSCXSg6TUiFClNGEWNYE10DsRQ4O2WhNndHBmX6+Vp9v9ohdcQM3iXoh817aj
 3j0BcFe8
 8yad43OjNSOZf2d5k3isWD1rcocGoQfoX4s/XTK/oYEgXybNZX/1Vd8YeLXyiuA4lU5xLOd8mTj/6wC1sFbOzcDDiLdtUtUcuM7DZTGpBvIR7cZ8Pim6zVkWg8WAXVkzpDTx448rcTTceYLJQl2T7OsHGDLX0iqoTKVGkFhX4bGelfCs0VGk7GRO9euJ4qXmRvGQwUKmIJ2H3Msy+OIY6KNyVZu5p84+pnPh3AmoSyr2mvDlUCwiV0SdEYiSUKedaARLMcuaJMSFa6QMDC1xUxmQ2I0PQ//LIABNqxR//Sh3iMeiY8RQQaM/Du9SUlRPw99Ckvx+Id9giGShoCZx5gl5GHnNp62lOhnZKUaEwrxzYNmGLbdGdE+8ZXt3sh2yBI7soDrLJuJOtk0x/A8kPOYyLLQMHhUurSTozbDUhIjG0ZGoYFh9bfVfY2Ld/NGK05hAZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 7:18=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> * use dedicated labels for error handling instead of checking if a pointe=
r
>   is not null to decide if it should be unmapped
> * drop assignment of values to err that are only used to print a numeric
>   error code, there are pr_warn()s for each failure already so printing a
>   numeric error code in the next line does not add anything useful
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 39 +++++++++++++-----------------
>  1 file changed, 17 insertions(+), 22 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index d4482b6e3cae..e248ce2e04b7 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1441,46 +1441,40 @@ void __init kho_memory_init(void)
>  void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>                          phys_addr_t scratch_phys, u64 scratch_len)
>  {
> +       unsigned int scratch_cnt =3D scratch_len / sizeof(*kho_scratch);
>         struct kho_scratch *scratch =3D NULL;
>         phys_addr_t mem_map_phys;
>         void *fdt =3D NULL;
> -       int err =3D 0;
> -       unsigned int scratch_cnt =3D scratch_len / sizeof(*kho_scratch);
> +       int err;
>
>         /* Validate the input FDT */
>         fdt =3D early_memremap(fdt_phys, fdt_len);
>         if (!fdt) {
>                 pr_warn("setup: failed to memremap FDT (0x%llx)\n", fdt_p=
hys);
> -               err =3D -EFAULT;
> -               goto out;
> +               goto err_report;
>         }
>         err =3D fdt_check_header(fdt);
>         if (err) {
>                 pr_warn("setup: handover FDT (0x%llx) is invalid: %d\n",
>                         fdt_phys, err);
> -               err =3D -EINVAL;
> -               goto out;
> +               goto err_unmap_fdt;
>         }
>         err =3D fdt_node_check_compatible(fdt, 0, KHO_FDT_COMPATIBLE);
>         if (err) {
>                 pr_warn("setup: handover FDT (0x%llx) is incompatible wit=
h '%s': %d\n",
>                         fdt_phys, KHO_FDT_COMPATIBLE, err);
> -               err =3D -EINVAL;
> -               goto out;
> +               goto err_unmap_fdt;
>         }
>
>         mem_map_phys =3D kho_get_mem_map_phys(fdt);
> -       if (!mem_map_phys) {
> -               err =3D -ENOENT;
> -               goto out;
> -       }
> +       if (!mem_map_phys)
> +               goto err_unmap_fdt;
>
>         scratch =3D early_memremap(scratch_phys, scratch_len);
>         if (!scratch) {
>                 pr_warn("setup: failed to memremap scratch (phys=3D0x%llx=
, len=3D%lld)\n",
>                         scratch_phys, scratch_len);
> -               err =3D -EFAULT;
> -               goto out;
> +               goto err_unmap_fdt;
>         }
>
>         /*
> @@ -1497,7 +1491,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 =
fdt_len,
>                 if (WARN_ON(err)) {
>                         pr_warn("failed to mark the scratch region 0x%pa+=
0x%pa: %pe",
>                                 &area->addr, &size, ERR_PTR(err));
> -                       goto out;
> +                       goto err_unmap_scratch;
>                 }
>                 pr_debug("Marked 0x%pa+0x%pa as scratch", &area->addr, &s=
ize);
>         }
> @@ -1519,13 +1513,14 @@ void __init kho_populate(phys_addr_t fdt_phys, u6=
4 fdt_len,
>         kho_scratch_cnt =3D scratch_cnt;
>         pr_info("found kexec handover data.\n");
>
> -out:
> -       if (fdt)
> -               early_memunmap(fdt, fdt_len);
> -       if (scratch)
> -               early_memunmap(scratch, scratch_len);
> -       if (err)
> -               pr_warn("disabling KHO revival: %d\n", err);
> +       return;
> +
> +err_unmap_scratch:
> +       early_memunmap(scratch, scratch_len);
> +err_unmap_fdt:
> +       early_memunmap(fdt, fdt_len);
> +err_report:
> +       pr_warn("disabling KHO revival\n");

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Nice clean-up, thanks.

Pasha

