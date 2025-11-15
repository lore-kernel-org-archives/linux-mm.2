Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E30C5CEB2D8
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 14:51:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8788E0008; Sat, 15 Nov 2025 09:51:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0388E0005; Sat, 15 Nov 2025 09:51:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD6C8E0008; Sat, 15 Nov 2025 09:51:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 69B788E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:51:49 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 016AA89A0A
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 14:51:48 +0000 (UTC)
X-FDA: 84113130738.10.F2E0B3C
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id EB06C1A0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 14:51:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZL4wXMtY;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763218307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rIydVfx8R0TzH1/4QIZdK5YhW2r+O6Ifbkqz8pnbgWA=;
	b=ZPBo/9n7uWoqebahnducPYFOHK7spgPutN6WLe+98IpdrXNnFoqFF5MtyA3a2ys3fd/J9s
	MpVvgeavyaniZMk7cCRbGetVJU7OPorzg+SWT09I1muxfTr0PLXyKatvgcIVkhWv9mGEZw
	a+K1v3PVJRTySIt/A9yZFpfnxCbT/6E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763218307; a=rsa-sha256;
	cv=none;
	b=7x9fVRRvBxSqkc3nqJkVRQbtZAU4mGsVAVOjwrkghtq0pTY6TVxhYygvYH/1MPAgEpiLII
	wSOrj8wri+yLZYKyoiDNeLclY4dLzOd5WwPWm4dUt7cq/zk1chZo0dKYUVHSSzb2eQfgED
	+dgXVHWmtQMP9XYCLNPmgQ5oGxSOB08=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZL4wXMtY;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so4501574a12.1
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 06:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763218305; x=1763823105; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIydVfx8R0TzH1/4QIZdK5YhW2r+O6Ifbkqz8pnbgWA=;
        b=ZL4wXMtY+qwtdNbaxgJKAz0cFvrWqEOiHlyQt7CYZ+3ua80ivFWe1zzVYgb59aC+5x
         VnrjQUksvHZi4JlW7RUBMA9IzZZRTTUaSJZge+x/DGSIlayFOBwb8On6XTE1kO7S0C3V
         BX0hbX5mJfPdYs9YWQvwozO16sLsY8+wp5mXDgJs5LtEELk0D6ULtMoCijNSFQcVJdqy
         Szo/0CsKCq+jUNpIz9JAcZAo3sBr8mvB7RwdE7JaqSSjAjHp84OYM0SpowDAeHEMrHjg
         LPpqoTu0C6CdcUbYJ1g4NRlgbjCX+D/l0NHA6SqyNDefuxrhft83no2ISNXX3A+fUcuH
         GFAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763218305; x=1763823105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rIydVfx8R0TzH1/4QIZdK5YhW2r+O6Ifbkqz8pnbgWA=;
        b=hC/1hH2Ivs5GLw84IiqsIpm4Dbx0XQw5SEOFPhdLiFWAsTBXEj5X96RyAg6QIA+PKw
         rkvZukfPNQmiksCJQ89DzrypO6XL6CA+PLMngd/XaSaxHiEy7UI1nBD9r/D05sS9Yojv
         QGRXbEgJXCFVnk+QZam529ssXtTrv426OPwMfJslzKFlwENkk+k/YpmuwNnvMnBNKeVl
         EN8BfFa+cc8G9U+3o0FQ/GeAiVAON4lpixOrGcy504NCJ9Qxons/VtaYu9QrLodXqSKV
         0ubE5T69WtNIOwFtaAJmJMwcKsO+oy9RmlzezVt0xv5qZIstJP6gvpukKVr2l8TeUdRs
         Vb5w==
X-Forwarded-Encrypted: i=1; AJvYcCXSU20a9bSvspSWe+TnPA28lk+JXu9Tvmz79EqlWZf3+kEnPnOVgB+NOOzSwnyeFMY17eOVNLhFbw==@kvack.org
X-Gm-Message-State: AOJu0YxcPxvBCcMXA9McEfxmCNdva9kZ2l1UHVBiSOwWLqCKHL/EZkcj
	L6RUd9JkpaGgDte4CPlcoyoVy0PegL1NUl++8awkN3HwDG7bZvRqDK78sCKwWAds8qfKNaPHJil
	3YY5Ety7n3iTaTeBmyV7EprCsoXiVtnmMvkDUZK1qhA==
X-Gm-Gg: ASbGncteHx1Wtz49mNbWxuHXeyBRt9AcqB5AI6d+iIMXjUvtTpXLET2ogufvykuxjDm
	rjBbY7LYPrG9aFrE+4/bMLtkg8iYLjOueE0TPjVkFOYlXfs9UefyZHx1YfunPJq18TJhCrNWLiZ
	hK4eS1F2mQHZXVB6f2B0lO84BymSim5ZiK0J0G5XXgmrBDC4vd8ERBFPaw+9FPY6krDsxGvm56J
	GNHF/ASWAWtnruqCfZkYmJlohDQEWl+DhbhCsGgRN2uqzLkJvn9V4JehwDQocXWoJr/bFdlJQuQ
	dX/UF3jlXaDFn0D4
X-Google-Smtp-Source: AGHT+IEQMTcydSOnSXEZk6d6DShEuKVDmQ+Bt+sZ1KHZZQpJpDG5mcJNdHvQHscSrYwgga2nJvO8Tcun1n9K19t88R0=
X-Received: by 2002:a05:6402:2742:b0:643:8183:7912 with SMTP id
 4fb4d7f45d1cf-64381837d5fmr414948a12.9.1763218304333; Sat, 15 Nov 2025
 06:51:44 -0800 (PST)
MIME-Version: 1.0
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
 <20251114190002.3311679-11-pasha.tatashin@soleen.com> <aRhKeXM5iAswD7oe@kernel.org>
In-Reply-To: <aRhKeXM5iAswD7oe@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 15 Nov 2025 09:51:07 -0500
X-Gm-Features: AWmQ_blhrf5vCj-730ss7a9AIJUQQXQW4QkjWD0eNWJZG1ouYtdeYt5sPgpeEXk
Message-ID: <CA+CK2bBnEKk_mQOCfDhnqbUCovLCKhFw-p54Q4_Sutk4oieOVA@mail.gmail.com>
Subject: Re: [PATCH v2 10/13] kho: Update FDT dynamically for subtree addition/removal
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, bhe@redhat.com, jasonmiu@google.com, 
	arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca, ebiggers@google.com, 
	graf@amazon.com, kees@kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cux6yep7691c66knwrpi1abk4sf5aot7
X-Rspam-User: 
X-Rspamd-Queue-Id: EB06C1A0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1763218306-619863
X-HE-Meta: U2FsdGVkX1/7X5wl8r3W76W/wnsTsEFbpei/wbfRZqacjJGxQIt0DmFCv4B2fMWSThdqZ+LYV2NVJWBJlBoUiNJGN9DRcPMgNIhSTw9Vxy041XvwAeW0WRNP1s9RpG4m2oOX25MIJJpJaocrxpCcunyFkJeDNyyH9tocWAxLGCex8XCm73NhkVsOQGlVDjMtAvXuQzcgyHF/mqh0w5ux6yGqwC7EmthLtvjFo8jyWASqGslYQEcGEoz/j1mtg8xEykK7eKTPiS0yv0IeF42NTEQAMzz/KrOHz36SqzSQ+HxOQYEnmBVq5KVGn4RIA5q/EYvWIFP4Ekq3hGkJMR1qZ/588SrEJ7Ft9QO3WpRVONVq1h2c+/EfrHM9+s11PPI4Bige6bLArbzeNB1prX9Z+KB17WC1x+jyUj86y7WP2ZRDMtCIF/GHCo9mra/5T2t2FWZuE+LKrO96sLAhj3xh55YXVqEofoT7PUO7KqMATJ3yLtGDN0LPn7qOm/i4KpDJjI3PNjO6duRiD0VadN4ThkVvxWGiUNwuQmpYVmRpbSLqwl0IghFwvVoerZtLGMTuhiSAJqZPT6Oje/uIN15fNIfMAMoNyo8LfgeJQDXcxE5f/niorkVKtXMvgBoshUspGJOrfNXP8zrSgaUc24p6Z/PKQyfPhpHUZ+6bJ6UxpCBR7e/9AU148/dLYDtAYqhhEbpuFvJ7bxWASort6QVYZjzKvhQXo5ZvqTlfHBx2h6jwgGEd8N7SzTlrHeGt4Nd4hSLWkgCVIRdHiW6PT+cUW+yqplbRYHEKEgpr1+KOkA68YEvFNSjPi+b+TjDHIow/qPruiXp4wat+JOnZBNWAhrGBerGWsUpAELwiogGZXcyVmgxsnBSgN3mYaDv9Hxb5XJ6dbq5hRwMCoQV1Kjsj9GUe9MiI7Sa+IpalDSVIGBfBbfW5/f1nWv6JwRQJ6zAwnkHKbDLvVa304Qy4sR9
 cTeKGqb4
 5UTEX3xr0ubtu6K/ZmT9el9cPprXnGELZ9XwtdCoycs7S/cT1jTtf01c7jKnnO5DBGiSIFQlw4QsTpMiBX/AHlgxNMwf4JcF9cXXmkD1lBKAqrbHa+TPQb7PvqfAb1iTK2a6gVOLYk0PP2BVjg4kAKhlGcRIP37WoOrAPojRuE9I0j9c8O1NNuPiQlwVhH1g8Jp2dvs15NSzmhxzaTZD/L4v+tHBttXIjPJwHfK89DY+pAgJnRqS9vIr6Js5W+O3S/79OhR8oZkaI8es=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 4:40=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Fri, Nov 14, 2025 at 01:59:59PM -0500, Pasha Tatashin wrote:
> > -     struct kho_sub_fdt *sub_fdt;
> > +     phys_addr_t phys =3D virt_to_phys(fdt);
> > +     void *root_fdt =3D kho_out.fdt;
> > +     int err =3D -ENOMEM;
> > +     int off, fdt_err;
> >
> > -     sub_fdt =3D kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
> > -     if (!sub_fdt)
> > -             return -ENOMEM;
> > +     guard(mutex)(&kho_out.lock);
> > +
> > +     fdt_err =3D fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
> > +     if (fdt_err < 0)
> > +             return err;
> >
> > -     INIT_LIST_HEAD(&sub_fdt->l);
> > -     sub_fdt->name =3D name;
> > -     sub_fdt->fdt =3D fdt;
> > +     off =3D fdt_add_subnode(root_fdt, 0, name);
>
> Why not
>         fdt_err =3D fdt_add_subnode()
>
> as I asked in v1 review?
>

Oh, I missed that, there is a slight difference between the two:
'fdt_err' only contains FDT return value, i.e. error if negative. The
'off' on the other hand in the happy path contains subnode offset, and
contains error only in the unhappy path. This is why I think it is a
little cleaner to keep different name, however, if you still prefer
re-using a single local variable for both, this is fix-up patch:

diff --git a/kernel/liveupdate/kexec_handover.c
b/kernel/liveupdate/kexec_handover.c
index 224bdf5becb6..81f60ccb2dc7 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -713,7 +713,7 @@ int kho_add_subtree(const char *name, void *fdt)
        phys_addr_t phys =3D virt_to_phys(fdt);
        void *root_fdt =3D kho_out.fdt;
        int err =3D -ENOMEM;
-       int off, fdt_err;
+       int fdt_err;

        guard(mutex)(&kho_out.lock);

@@ -721,14 +721,14 @@ int kho_add_subtree(const char *name, void *fdt)
        if (fdt_err < 0)
                return err;

-       off =3D fdt_add_subnode(root_fdt, 0, name);
-       if (off < 0) {
-               if (off =3D=3D -FDT_ERR_EXISTS)
+       fdt_err =3D fdt_add_subnode(root_fdt, 0, name);
+       if (fdt_err < 0) {
+               if (fdt_err =3D=3D -FDT_ERR_EXISTS)
                        err =3D -EEXIST;
                goto out_pack;
        }

-       err =3D fdt_setprop(root_fdt, off, PROP_SUB_FDT, &phys, sizeof(phys=
));
+       err =3D fdt_setprop(root_fdt, fdt_err, PROP_SUB_FDT, &phys, sizeof(=
phys));
        if (err < 0)
                goto out_pack;

