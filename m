Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76CFED2168E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:31:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12A16B00A5; Thu,  4 Dec 2025 10:31:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3256B00A7; Thu,  4 Dec 2025 10:31:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1E76B00AB; Thu,  4 Dec 2025 10:31:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A62F46B00A5
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:31:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A4461401F8
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:31:41 +0000 (UTC)
X-FDA: 84182178402.24.9CC5A35
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3F30B20004
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:31:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JnMKn7p3;
	spf=pass (imf13.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764862299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=POTlX6ISPXXEWpjlfGwt41tj3VGCl5g++BEcuBlKXmw=;
	b=WaVI4p5LxODLyWbS+A22BJ0H2LmEOP4UXN0xsHB+FVc7zRVK2hQUyaxwRljMAP5FW3nw5D
	pi8wLNq8YiQwdN4ej4qbRrUWenDTgYtgn8+b5PV/pt4ipRZe+JJU+ROar/CKIiDzGR+iwH
	hPBktnuNHOE+NkNV+kGO3qzq/05Cudk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JnMKn7p3;
	spf=pass (imf13.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764862299; a=rsa-sha256;
	cv=none;
	b=lDkv8ExQ8V1h/54UR9wqQhw6+K6wi3l+HJkvQ/d9TCs//o8rsxWdpdNg9JT2aiXeI15mia
	tFQyU3+jpm/+sPYrhx6x+0A2mwm6M1DsNhRx3en+3XK4k2uQ9Nt7bu61k4TyZHzqvm3vtR
	0M7kADUI0rqopG9d32/Dq+nGc7hlNgQ=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b713c7096f9so176183366b.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764862298; x=1765467098; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=POTlX6ISPXXEWpjlfGwt41tj3VGCl5g++BEcuBlKXmw=;
        b=JnMKn7p3Nl7rDBXH4vX3l3rN0EGz0zOSEhenutGTvOl19aYMIEv7azcEU/qNJDeDRL
         ixXPwEG8ip8RZAI2CgkT2L5O3yvVMMCcsTzCMBsz30G11D6G/JbgSUk3lrvTgKZLYbXK
         8VSvV+aWwzBlBpvNvCJWYzbBodlwboLwyK2bq/pBouCct3vROnahh7Z9xXZXl13G229E
         dx4KWLbQFFoNmoqHl79xkjPDa1PIVVB47iG4mcYM9foCMADwzafiIIyV1/Ety5R6X+Ge
         pOLHKqphVVwwrqqoPyhSEE4gpe/1EVm0BDB1y3feh8f18kh4VyMj0cIZXapsaNdPbRdA
         OXXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862298; x=1765467098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=POTlX6ISPXXEWpjlfGwt41tj3VGCl5g++BEcuBlKXmw=;
        b=W2ouQ6QmJInI2G1AVGpJcYbmFh5lQZGVTDq3jy4mSKz83mgL4qxsQ5yCG4/UkAiVBn
         Ox6Yyglus9HFYqzA0OsxRmOc/IMGVK2Q+Eewk9G9qHseql7q5e0soCxV0AYxfjMEcPM+
         4Y4/Pqxq0vnb7QWgZJksPn0S2kqkKlEyQr3PX+dG0UAlkwGZStL4q1K3dcm7VayAS6BB
         PdMPorr49hXho2l+S03AdBZPI1nNotxOhrbHs259ERCRvtk7RaD/6+7sa7sHbwZdrTF/
         RPW0irMLv0rWVemmsSpQqwRj4/hpHwI9+x86NyzeIZ2r9KZdW2Y7IrT6FVYYTRfjfkTl
         jhUA==
X-Forwarded-Encrypted: i=1; AJvYcCUMqS+hhBUGL0OAlEYDt1nykwLsDsPI75G9xaKaC6mZi8wEHe5n2OuYlxAoXoLuwAheMI4is08SPg==@kvack.org
X-Gm-Message-State: AOJu0YxUBVarioFv0b0JIfcRDClrr2Zx9Ld8yjI+PLh/Zyi+cE62ERDD
	Kro0/KMojs/T7YAA+AFl3+rx6XW6YtayPT9EWRY8WMYryNbSbd+cE4865e/tTpI+/n2SDWcHx/1
	lZKC4jmCL5JPeHODxHQtu9zjjcs/9RkI=
X-Gm-Gg: ASbGnctU1Llln+hITl7jgt29ByduBXM0z3TqkK+3o4mAp7BcJqeRj7P8sHKu7m1mJUL
	vpdNcRg/fBRAXpIQqWVKP5Jszgf0nHih84t7jMv3RKJwBTxmR5Cjwk2KdIcCjkuQX3576KuW2v2
	RC6D+WdazUGdsWvly+bS3XFyg4KO13fEzUFnGFKLOATbQqoQ5Jn/Zbnf9HoTRdOZhrJyjQGeXE3
	hFSapRi0LFJ6hTx/lC3KhkwzDqQaRCjuaPDlV3wcld0wtZtjpZQ0STVNoAi6wK3EPcIYPlCcyBR
	9i79ZsXliJmBbF9gchurp+TMxLY+FEXJ2DnD5hCzZsonotTCMq1TiF8S0fFPp72Rc7Kl+do=
X-Google-Smtp-Source: AGHT+IENRfMe6T9wqDS/PoUZtjNDj8ACh6Vacb1wpcUt4B4CeOHB7XDWM2IT6MHbrsb7tHai7cfQga2AdduHQ3E5aFo=
X-Received: by 2002:a17:906:d54d:b0:b74:9833:306c with SMTP id
 a640c23a62f3a-b79dc777cb2mr731791366b.47.1764862297473; Thu, 04 Dec 2025
 07:31:37 -0800 (PST)
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-2-ethan.w.s.graham@gmail.com> <CA+fCnZcvuXR3R-mG1EfztGx5Qvs1U92kuyYEypRJ4tnF=oG04A@mail.gmail.com>
In-Reply-To: <CA+fCnZcvuXR3R-mG1EfztGx5Qvs1U92kuyYEypRJ4tnF=oG04A@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 4 Dec 2025 17:31:01 +0200
X-Gm-Features: AWmQ_bkuYb6owVWFxIAiek-YuFB5R-dRF0smhrRgpbJbH_xsE9jvhcY-L55PbKY
Message-ID: <CAHp75VeARk=pm_R10K1bEoCuV+32HgV3ZvQCNVs4D2_2W3B_Tw@mail.gmail.com>
Subject: Re: [PATCH 01/10] mm/kasan: implement kasan_poison_range
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, shuah@kernel.org, sj@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3F30B20004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: oi83w4t7eowg4fypd5i43iemdga8axa1
X-HE-Tag: 1764862298-868195
X-HE-Meta: U2FsdGVkX18FbVCiczoN4cW2vuyDAnNHAzYo/wgqd8Qq+gNoRemX3Z4aQTmChJEFIb5pMmokkTFGeqCIpHxabTam3x8qErmI/uHdwI2t7+vHqWN7kHhatF9y9MMn7DoXPttcbvkE8VYQoyF9qDYt3d2c/6QUOHB/x4qNoR4Jevh0Ia+jyDZyg6VP78PI81iGF5KkIpXU24D/ny9JxG6wpdrC/SrCKl4mv+91AchrK/Eng7rz1imcr7hZJaMkENrY5eHcdAXVtYXDjkmP24TxSvPZaVnqUM0LpKpUUj+CjLErO4kilDz0wIi30V4/zNcdfxKxhEODngNGjv0wM7djsJlERuFFBPwvXUF0z1WFWHT9kpfDQM1uoxTDxmSpZGeW6QsS7LZp8H2CJSG+pjWmLhl6IziVicuFb84dLs3J6tTszanALb5r6QYo6IgR76VsH4aH94FW9BMf/9+EfqxdlcPSlF/rmw83stpd8V3GDp9Z2cnOhNnQvt2L5Uu2HFy6uplFeoypM8vSFQALDJubBO01T9yLvkAzwHeEAPikFKptW2V6Zt5FS9aJa8HORA2j1ndI/o8DJidU8hDNxMWBd+u9q3uxNrosyF7L1eLBq9CpROmhFbCgXNIRO/HsCQkL+kTe8qVK8auVZZrtdMUHW33t0U+m2urVgS4JH/NvROcYQWoPkIVBBi6ztAQ2/noLi3HLllQT8PBfJD90nqfaP6I4Hks6Fo98+nwPHcZKHB1Zm4ymuIraheQ/Z9CiewS44jhri+vUCAy+i6lrbH08LGVkO3cpUX4eNP81NDzzSOdgdW1j4WnFqB7i2mB8ma9d0sNznRwg/leeHr2B/iupfEBqHP8o3XVskwXaYnyPLfkEcxWCjyfUPp/pEhxZNol7cxsbbNiUvPfF40rdfU9nBTAE16Q43rzj+WB6h8ICbKCZ7PHalqv9zhDAGEt21KT1HKsVjVcicjqyEKJvljf
 gKjkLaoc
 azzmtA0Cn8woPorUNN9yulVtLGfLpd6w6Get50pO3LDmNStfhDhRM3N8nNhqeVcAcwOmZMFZ5EjsTFXbBorG4CBX7RxlZar4PKr+p3IZ2sReJU/QDV2GcPh4qcgRp0KAYLuLJ6Lk3fXvW0AdrCesDho2nArBfOLpspZniecUjq1Vh/WlbmCvzHYdE5xql2PQyY0rtUlgqP40g5miWa8uG6C7EA1ybT1vhqkfOJYNB678RNm62ZX/rFnOOmcz4Izjdt50oxCbKBemXTIDKle9+3pbkKwS46LPW6+pDDeTWMUZS/ULl6m9Rb6O3q9EtnECw84gAFodsf/k6KlxlXAEs8F9PiLctRx16hs4OUCjhLaMlOVot6f0ZjE/9S3YI+6n+C1k7VvgXnb6lBB54U1Jrhw/U4LSUjgFxSyuKgRcu788QbEevTOLM0Vr5LdStJm5BkdFXSLfGwk/gi/ldADL5BwLbU2l0tOpShNgguIz1JZFjOr4IRcm4pkNty3mbfJuuS1r/xpH16VFNgeojzVqlXJOeCTfbc2OxPUYhaNsKs/TF9o06UMbhnC/Woat3Ifca7aWn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 5:17=E2=80=AFPM Andrey Konovalov <andreyknvl@gmail.c=
om> wrote:
> On Thu, Dec 4, 2025 at 3:13=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gma=
il.com> wrote:

> > Introduce a new helper function, kasan_poison_range(), to encapsulate
> > the logic for poisoning an arbitrary memory range of a given size, and
> > expose it publically in <include/linux/kasan.h>.

publicly

> > This is a preparatory change for the upcoming KFuzzTest patches, which
> > requires the ability to poison the inter-region padding in its input
> > buffers.
> >
> > No functional change to any other subsystem is intended by this commit.

...

> > +/**
> > + * kasan_poison_range - poison the memory range [@addr, @addr + @size)
> > + *
> > + * The exact behavior is subject to alignment with KASAN_GRANULE_SIZE,=
 defined
> > + * in <mm/kasan/kasan.h>: if @start is unaligned, the initial partial =
granule
> > + * at the beginning of the range is only poisoned if CONFIG_KASAN_GENE=
RIC=3Dy.
>
> You can also mention that @addr + @size must be aligned.
>
> > + */
> > +int kasan_poison_range(const void *addr, size_t size);

And also run a kernel-doc with all warnings enabled and fix the
descriptions respectively.

--=20
With Best Regards,
Andy Shevchenko

