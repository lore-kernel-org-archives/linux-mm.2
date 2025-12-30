Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F0E5EE0203
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 15:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668666B0005; Tue, 30 Dec 2025 10:06:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62FE96B0089; Tue, 30 Dec 2025 10:06:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55BFD6B008A; Tue, 30 Dec 2025 10:06:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 433D56B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 10:06:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E01DC1601E5
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:06:10 +0000 (UTC)
X-FDA: 84276462900.19.F1D162A
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id E52CA140018
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:06:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DpC5b2th;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767107169; a=rsa-sha256;
	cv=none;
	b=5rqEoD4fkiyE/SPFpFjbzroeGT2efCJ0gAZMN89j+RXwBDg0qD0p3m8URogWsWdeqlm0uE
	xPjebeZSjS/0cX9pi7qXUrPXDYHTYZAlBER3D69wP2kj1PDZEEuuV1vqjvpZ0i/EvsoNtc
	uG2lA7d1zQa+zU4HUML4XH351n8Aa+A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DpC5b2th;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767107169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOqkutwDbpOTNGdll217rZJQOOakvkGFkdZuI1BpLb0=;
	b=0v+/i7CgmF4aJ/KWnEEHm8ROArM6cvusiTpCRs+e+hVRSYUObII8sCxt1giW8/tzBYXVsc
	RVPlfX7SQHOCjFlhiZgS8/QurjKlfTp2TOkSE+iIXbdonH2rfKwrYEXLMDb2I20Xr6yVop
	9ADY5hpNRxmZtv3sdBZGhXXyqHhvU8U=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-649e28dccadso16968001a12.3
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1767107167; x=1767711967; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tOqkutwDbpOTNGdll217rZJQOOakvkGFkdZuI1BpLb0=;
        b=DpC5b2thYU8lcDz0HmosbMtTeoLS3LIUHfaAqK82jXdw/8mWQEFjCpQEOGgkYrnCtw
         VYLbLEFO62SGf/vRvpjy1ZZj7x7nSJ1Aeh5BofIOpDI2b+R++5pZyL38B9zkeJV5jEbj
         9Zpl2DFwA0sVMRChmbADfapfZ8gcH934rf1Y7emzgwlquGhDROQho/DPcliwvcsyqfDR
         YQSowhwjtuter1HxmCKjysY6CGxU/TLpI8AhwqX13vsKjmvChqwszvJAfh1Abp2NCRRE
         fVBWWmXqzr0Zl5PIbvxI3+LIqU4huiNgOix5bMe1d3XLUx7bxz0Awjs7FTMn9+JUykI1
         qi9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767107167; x=1767711967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tOqkutwDbpOTNGdll217rZJQOOakvkGFkdZuI1BpLb0=;
        b=hca5jTZ8925LXDI0XoJf/4PPNwfqddFXWhOPc6dH3YfmlokxrFJ01DIi6V/d9jGFOO
         L0gHHFdekhtcWReC1+KbaVDO0o6Ix8tbbXnIPgx47wZOMLNTxP0RlgVMKVQwulbDaAH3
         dl/cSs5dFIRhTJ13nJIGWfb+dmtrYyTn6LGfboZbD6C9Tsw8tQQQFMO/cbQDQxZsDSks
         awhZ3jutOzpyqoH+Ozt+2pq8KiuWNZbjJ+IJGpBusqK6bkXtjN+3WmL7WIb9eRgjl5mW
         HTcXooW+wSG1nDY1El3dpZMr2DZeh+Y8SiI3/0cFq+fLCdi5JMERmNp4teL5nZpx4f8o
         t8hw==
X-Forwarded-Encrypted: i=1; AJvYcCVj5Ja1ytcVQT+EDNq245pqnJPXbVaXAMFMDGMJx/TdeYdipRSYaLrG4D27Ia8C8HBXmsnysjKOgw==@kvack.org
X-Gm-Message-State: AOJu0YzOb6+onEjsM4u1xY1oFZ9OEYljscVAcTWtR5j3SIizSTDUnPaq
	sn5odBPqUMKt7OFIrPtr1WcEtOqSCSS47D6gQ+/tPu6GetSb5bmosApI/i1QUNSb16Sptis7rI7
	o0sBcxOyXr04+fZFAbcRqY3/v66Q3WvPSHqSIRTFaOA==
X-Gm-Gg: AY/fxX55iQEiQxHAdW6VxH950FcC0w7lwJQjqyzhGAHKmURnBbgWenQopXj4dYMgoeS
	fPSOMFGsxOuADZIFS02B+rpyBwr3lMw/SIfk9IwnEwCIqCDc0FVFYxLOgQucH9Ul9Wy1AtMI63z
	ILVoPFXXRHzqQ2PYW+ztQzxDAmEuAF+nHwgtKCuf2dpcKs9P66+dOq4ekEeXoTK971B2QfCFruc
	lo73m15VQmKXThco7ABW9d9YAlGQQovlGTzED/3CXZjMrSRf/HBlf1KE9+KrQ1mx2gQlG6KEz6f
	HXl3HlZ9bI1V2yMlAoj1Ay5Ixw==
X-Google-Smtp-Source: AGHT+IGMZWTrRNb+slpZu2y8eWg+j4WfA9NxSt2fzIC0sx/x8C1VBQ1abXUUHhx62KZhGghaGNGmSmYa9XlRYAPUmTg=
X-Received: by 2002:a05:6402:3587:b0:64d:3b22:a5b9 with SMTP id
 4fb4d7f45d1cf-64d3b22a88fmr23190814a12.9.1767107167449; Tue, 30 Dec 2025
 07:06:07 -0800 (PST)
MIME-Version: 1.0
References: <7024cefd-bf27-430b-b8fa-04e1457e0eb8@proton.me> <86zf718072.fsf@kernel.org>
In-Reply-To: <86zf718072.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 30 Dec 2025 10:05:28 -0500
X-Gm-Features: AQt7F2qJ3a7s5qfdbisEUB9bUzL_h2Hb6hCdpCgwLMjci1CkKVcHCaWGzaNSb2I
Message-ID: <CA+CK2bBD_aMy7k6kJH__qhYhyg=mTCQMn89+fhcCcDpJ7PJNhQ@mail.gmail.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Fadouse <fadouse@proton.me>, Evangelos Petrongonas <epetron@amazon.de>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E52CA140018
X-Stat-Signature: zqmyzfm6dzfgznnkjs6etx1iy73cupji
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767107168-798512
X-HE-Meta: U2FsdGVkX18ZRX7HiVycWTc0TXHRII2KP1EjRbV3RtsMKnRda3ftMfvR1FmcdwZwoUsZCQofRZhDY14yyplIxFLLjHPAYc4/wJ2ncAgtOQbjZ3tyLZCXpGiZ0S4i36ZlPXmonbWHm4KEpOL38VJyYzX2XNd0hMPlxJxcKd9/kEnvJ5YyOC4gvisJXXr3YfodANwXmmd79r3XuCKykhWloWFb5SLE/DHFiYnuvt0m7fstLjYJuhHyXH44bxyjE3gloU4r1PABu3qNmPJu4BF3YOodp3GA9OCA8cJpMiJIb5Dos+z4rUkjt5kdNIK5jtqvJaBAxkN4iHfYf2+euRpHZG7IvDW2zA1/wN7zQFRwsvidJKpjA/8mnp+JtH1HPoAEBwKxNQ+naUp+yRNU3HyMFBsoqTxJV1h11yCsjeUuobX/u/hC0llb1andPDCKLiNxPBuPyL/M2grcL1Yu+Wv0DrhMFp/xcc+QLAYOfB1IlnqILT873X7J9nRoJ9L+MbjYQtRDan1EKmZQsA1sqPCGsmtWacDxzC3bQb9p47XYbBImUiMbMtz1xLhyl+dK1stW/RsEIXXZ3I9qKqwjbexJR2JTVXZhzgkNVDeAuAvCpXX0y9L/VpGMSDSlS6CkUJJX3EJm3Ut8zWn7SGilJi02LmMe62pBfgL6RXOTC8KUndPpGi2qV9Sq7gi15i5VXjKkDo7q3NZhOZlWnm0AeLbI7gHnv88XhryBLQ0KOPMqXWvRF0ljDoPsA3e8bF5m4HuWlygP8Lxy4wChxBlAeDvi9neBgz2EaA3+LiSsaFCLGzXwllJn3gYN1cJFq22gnkRomT4Rd0lx0+C6/Iug7ujB/JJsbwdeJB5VYon0ypdbNIfbZ35Q11WFo/w8cKST6l2Zb88JVGUsj3+kaFT/LZex9ceuG10i90Dcppodl4B4WjCRvUNSY0FKk98HPyFzTCSmBtC+82gcZD4i7Ft+N7U
 yWjQI4DD
 5g+zrCA+/ohV/qyBooR6/WfGUVgAubBG9iUQABFaS6CMa09blXc/WpqZ9B4Osi2FVseml9lkSiWPzxykHNo/Us6wIpaU0/W4FJut3XhuP+IJ/8Eb9/cbdDqek4nMvQk4dyKxP++8xSWNXksgEkC3nJVCgh5GnA8oreB5//pgvP5R4VxkFC7KOhbPjPnIMCj3tshWx8v4zY9Y7TzpL69SJT++OO+ApUprR3j7ClUumIoIblUtwyOR46e9y9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 4:09=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Wed, Dec 24 2025, Fadouse wrote:
>
> > Hi Evangelos, Mike, Pasha, Pratyush,
> >
> > I independently hit a crash in the LUO/memfd restore path with
> > CONFIG_DEFERRED_STRUCT_PAGE_INIT=3Dy, on a local build based on dd9b004=
b7ff3
> > (x86_64 QEMU, 6.19.0-rc1 timeframe).
>
> How? config KEXEC_HANDOVER depends on !DEFERRED_STRUCT_PAGE_INIT. So you
> shouldn't even be able to enable KHO or LUO with
> CONFIG_DEFERRED_STRUCT_PAGE_INIT=3Dy. Are you sure it is enabled?

I think, Fadouse reported a bug with this patch applied, not an upstream bu=
g.

Pasha

>
> >
> > In my reproducer, stage1 preserves a memfd via LUO and kexecs into stag=
e2;
> > stage2 calls LIVEUPDATE_SESSION_FINISH without retrieving files. I obse=
rved
> > a reliable crash in adjust_managed_page_count() from kho_restore_page()=
.
> >
> > Minimal excerpt:
> >
> > stage2: start
> > stage2: retrieved session fd=3D4
> > BUG: unable to handle page fault for address: 0000000000001410
> > RIP: adjust_managed_page_count+0x29/0x40
> > Call Trace:
> >   kho_restore_page+0x18a/0x1c0
> >   kho_restore_folio+0xe/0x60
> >   memfd_luo_finish+0xe6/0x160
> >   luo_file_finish+0x188/0x240
> >   luo_session_finish+0x2c/0x80
> >   luo_session_ioctl+0xf5/0x170
> >   __x64_sys_ioctl+0x91/0xe0
> >
> > Applying the patch in <20251216084913.86342-1-epetron@amazon.de> makes =
the
> > issue no longer reproduce for me.
> >
> > I can share full logs and the small two-stage initramfs reproducer if n=
eeded.
> >
> > Thanks,
> > YanXin Li
> >
> > Tested-by: YanXin Li <fadouse@proton.me>
> >
> [...]
>
> --
> Regards,
> Pratyush Yadav

