Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BA68C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 388C16B00A1; Wed,  2 Sep 2026 05:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338636B00A3; Wed,  2 Sep 2026 05:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227E76B00A5; Wed,  2 Sep 2026 05:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E741F6B00A1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:03:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46D2980120
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:03:44 +0000 (UTC)
X-FDA: 85168234368.12.DC270A3
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5482F160011
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:03:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="JvgH/Qor";
	spf=pass (imf08.hostedemail.com: domain of glider@google.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788339822;
	b=eRoLmdVEnuD3Fo3nC/e+hXiX/4Aw7UjbuOFkkN1t3ZPbcsB+18SY/kbDqLCNSYcqWAfuXi
	GYW3KeFZXTRm6U5bBvH9GX+ggmcGS1OV3GYkFg2ysoNiU6JTZr5J2v4tzh/5efTQq2rMG9
	LGF+psv0nd/GRqKsruDlCLzj2Mzu8Hs=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="JvgH/Qor";
	spf=pass (imf08.hostedemail.com: domain of glider@google.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788339822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YkZZkC4gsq97UcRVGWrKmuFIoNEN9InKHcyGDJRFeaM=;
	b=C4BIBQyWzUAssjxWtlequInKfdV1Irp5pfTW4dfWMJyAnIIQSAG8S1/1fUhz8VFgPElRZ2
	X5cMDk3vQrDIdNUGgOXUhJh31JW2gPiiPt0FF7pThTbGIM/Rc5dtNKrF1mcrlRm9llQk6P
	DYS6HrLEI1n7ZeuR8yJiCCkEpBjDCvs=
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-97bf8f6a31eso295077241.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 02:03:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788339821; cv=none;
        d=google.com; s=arc-20260327;
        b=auGGD4/jrZOcsWnMXjnA1Y7ZzNPQNFXZktIob8xAxCM9ojac62tDrdUv4Joykh5/vT
         SnLqK1GsRe8UQg+6oGSSnjPGWfQo9xfsXuV7BAlCIDt/iGjgOly7ctyUc+sWPSlYGvt7
         T2kXflc1zNdpxqlkwAWN9MSpDCRWviT072E3xk6/Dryhcjo3Wij0orIyEUwbKPRWRuk7
         kyr0/ml2VkDDfDiVdNfRbZwnUiG7WGz5SmlCIoDXxmvw33TFuC4l/whYhfjaV+uZ/IsL
         /VZuYaPi5tVME+LaFeVpUjRyEFJDSCFpLb9+9cuknahduMpdSM+2jNSbrHLBZxsq6DAJ
         wAUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YkZZkC4gsq97UcRVGWrKmuFIoNEN9InKHcyGDJRFeaM=;
        fh=USChgnlSviwGebx8EnvVDNQ+0urvfja3YDyMqOFhxRQ=;
        b=G9YOWUcEo2g7SiQ3Rgm4vxm8Is5/1UO1/NLwhG34ZtSrINLDIUmr/DIy3MuHWdim1S
         GelFQj1grYNcNSs5BDcFFkc37m9H7q1LHRJ7lqoB5kgYrDBo3vhlc1DMsY6A+Se+DFX2
         Tu7oM/dGl/TFEyt56tOp/2BspCGEhwcy728jk7wMJ6bcdwhUtjnwkRx0sS5gMhQMN8gi
         YYGyf4T24FYmun7J1bK7ve20TIf70QmBXWGj7F4qCBa5cXKuSvjxLIOnf1JW0+ffG808
         gOH+0QlSUmmPV/QAtRxQQf6A0wGfCpxJhHtt06u5Hmch35r5y6OZMtsiTCrNSMIPa/7m
         wOrw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788339821; x=1788944621; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YkZZkC4gsq97UcRVGWrKmuFIoNEN9InKHcyGDJRFeaM=;
        b=JvgH/QortlTXE1cU2vTdmaJhu8m+fCZ/+gZ8jsfrcSq7ASQrz79Mgz/OeuACIbAq3M
         vKe+V5SlXR8G0ZXlcvjJvkEptDBoTLMoH3JSX05TXjuyyW4miMWKAuALExopZYDH5w8n
         KLPwHvlP7WgjHYlvuUzfjbsaB4EiYaBRO6dYEZq5mIYcRCG4k6v+5LE+hcqRHjeJICXA
         ZDGEvf5BY9+Tq0i8Lyq8ScQKBKef44G2EVxrcA/uJKePY+GD2DwExQywfMC1hxjvKlMO
         Zn68y8P3tOGAuByNerVpc4vuuHTDwI2ehifwfijc6lkvj9dkAniHaxGGJJb0+7DdJi3H
         zvNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788339821; x=1788944621;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YkZZkC4gsq97UcRVGWrKmuFIoNEN9InKHcyGDJRFeaM=;
        b=JMfK3zN8NLlW7MFHwyrfFCyUjB5oVyJMUtqs2Lnuzfz1AEpmbSIK9O+Z8Hux7Jamfs
         yVM+sOYF5L3MFsUUgrNVzkABghKbqThtTg9rejb1kRYkNzrixmdYM08KfJXwGuoJZsLa
         /1e8LjjbI1msfty2A8kL6yZ/yRBCmYmLvV2B+uVUqB8Uq0eTW6diScSl4RdhM7ConBvZ
         T/6yQhBOlorbrqVXSFC5wtzKqLKe5hJ5tUGGr3MFdeqLSFcHgb9IsD+q+T5JhJSQ5FnI
         YXSQ5e3fZqfAgpN6HDRJXESYlC1gtgtYN2EnscFypxlabOihme0pg6bh32Mi6EKtsl/B
         k/ow==
X-Forwarded-Encrypted: i=1; AKwUvBzRHK/y9RfDqByi9tSvgsivW0SA6kBUDrWTnDuF5j/XOpmNWf6skdZ0ggKWJQSRaq9Dsx4tZAtnzQ==@kvack.org
X-Gm-Message-State: AFuF++k9COr8loLWkgn5xKTHUCAQibf9zSiix2wMOIcwu+JYBiWH3m45
	EtWmvAlJ1eyjdB4oAXochxYrUFwf1m8Q2d7wjUiLg7NHi/BfpSKAcAi+wnW8FJxOcq9rTr8GxUe
	XEvVoEzykDAYFSBekgU/JNBXrPlWGBWtUejU+vQQZ
X-Gm-Gg: AYBFou2iGpNiT+5YxkgF5O6TTgylirgJV/Zu5TaSrR7LwcyLVgYG4ycehrEp7vzQlML
	bJO6ICrqdijA0sTBkGIDy9O2ndEASykdkiPwsHGg+/1iUDPNQmjNPYVzXCuV3ggZO81GAPyWHjz
	2lUVac+54P2S2ou4GCGCxizMOqFftcVFFvZ9pTaR5Evhx7rMMAO1CdAiycErWX126hGigxlgCVB
	d7THgMgL7fYwzPm+ieQIeT1XBNpbQThwdUZ41+ryqIaG93fpA0TOcPTP2RF+tbfMO3PYRugbGjM
	JW5WYQU1KNRNWf1kiYLYmpZVZJuwofseIcgJWxgdqoaP/3pZdmAUNsIkecIcNT/KQrfsXXU7kg=
	=
X-Received: by 2002:a05:6102:6441:b0:783:f3bf:f9aa with SMTP id
 ada2fe7eead31-78a1f2e063amr916613137.8.1788339820556; Wed, 02 Sep 2026
 02:03:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260902085643.16309-1-liujing@cmss.chinamobile.com>
In-Reply-To: <20260902085643.16309-1-liujing@cmss.chinamobile.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 2 Sep 2026 11:03:02 +0200
X-Gm-Features: AcwNN1VVJDdJtpLVkG9nJXNGJaL4XfWXPCp1y0Sa0aj4Ivq1HDRBY3Bb76Pb24Y
Message-ID: <CAG_fn=WbSdcf9Qj=15df=P-b+ZjugRZ5-sdeYePFwkMpBfc0TQ@mail.gmail.com>
Subject: Re: [PATCH] kmsan: test: check vmalloc return value before use
To: Liu Jing <liujing@cmss.chinamobile.com>
Cc: elver@google.com, dvyukov@google.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5482F160011
X-Stat-Signature: mh6du5ieohppiykjejjdhs8xzkzqrusc
X-HE-Tag: 1788339822-406866
X-HE-Meta: U2FsdGVkX198TM5gePx+n6uwhYPHsQyv60ylr1k6jvS6+UyP/uQvc06FvUJDAf7K3qcEOzUVNw/U6biT3Pyi1+2utgHQkTtZsko2nmBnwIwXBhmMyAl35nvEvUuMMdrRlULvUHXjh6WBx2xOABLS0DtUxWckzS7g2MsGTy74hDFeSWlXI05red2yTaVVEplSMX80VL1D2egsMF+uSDD4BvVaQ3BaHugby5yLyAeDe2yU+2txCF5Hx2FbUGr/a4Ma+rweHlPaYZhwm8Bb1/9GgxXd/vQw8U3whtAQAoxpjUo5zmC/x8XYaJ6PjMZjIpL/4i0DUzGy9cmRm7hVfvjSMN6e/VhxiLtFPTOIWycmzpU4reEL9s8rlHQlN6ayuaWhIlhcV/qapKEbaKhrmlgEt2HiKZaegl8hQrCFnLeJcl4rmxxg3uSZEApe1O/cPBE6AX99m3Kto8eC2xqYuY5W0lIsmLH7rgHOOykIxODXqSRKIPFT2kSk/cwHBcHuMqff/0eaNtoUMpbs7i0XPtr5VgtDonozD0PVHXU+d1DEVMtzGw1J6VN4fDh7ffuIXFNvLrYN2bjJDMTNln4Sd0NRTGObTCA13TLZ9UrqCn4F+pwd0Rtwx8Ilo5rfKOlb9FpISjuATpPYhSN0HWnIlunWHjcxabdnkqxB2eh7czaou95P4cDA4jv40mVmSDcydn8k6ipQpzTTHiv+UCimrW/MV7nzbAsGR+zgNRdCKyWIELbgB6kKlojDy8VFb1gYY8lW2QvqD76oe0FK1/DtTJ8fQLbHSelumi4CNpIq6hr4r7aWvTESjAV3NopXs+uqTbITEny0ujkHkNJ/tkBn3xHtaDNxFgkvpPoru/ZsEb9j9d5gHZ9g/a4vhk2GMy3RN9Q/gUkKW5AKgQWvCbBs81542v0plhRWcOFqew4QajMgFzG0YcxruvUbw/lDOacR1Ios3kbFHx/NNNisoBZc0M9
 wqSgK30U
 pep6iaRNiCdQjszwRuvz6dpOE63PgO337851tAl/og3mISiNQz9+0BK0rLxb0uTQ2iHYe7dH6NMbHbf2wz++d97vwdtZFaHUSVXpgGflw65qwoUtIzlpD/nhN9F3+IVgC9DPQpYz/r4/Zi/fkirMCQRzf9VB6xFif3TNpjMllpf+VFbJWOaRaPUv/Qn7xkezxcfDoEtdSUa3W3aneVhTn4tguzwIflPVBt/t41uQbVI1YfQt+9/MgQ3WpfNUZVxgNJpxa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 10:56=E2=80=AFAM Liu Jing <liujing@cmss.chinamobile.=
com> wrote:
>
> In test_init_vmalloc(), the return value of vmalloc() is used directly
> without a NULL check. If vmalloc() fails under memory pressure, the
> subsequent buf[0] =3D 1 and memset() calls will dereference a NULL
> pointer and cause a kernel panic.

Out of curiosity, have you actually observed vmalloc() failing under
memory pressure during this test?

> Add a NULL check immediately after vmalloc() and skip the test if
> allocation fails.
>
> Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
> ---
>  mm/kmsan/kmsan_test.c | 6 ++++++
>  1 file changed, 6 insertion(+), 0 deletion(-)
>
> --- a/mm/kmsan/kmsan_test.c
> +++ b/mm/kmsan/kmsan_test.c
> @@ -352,6 +352,12 @@
>
>         kunit_info(test, "vmalloc buffer can be initialized (no reports)\=
n");
>         buf =3D vmalloc(PAGE_SIZE * npages);
> +
> +       if (!buf) {
> +               kunit_skip(test, "vmalloc failed, skipping test\n");
> +               return;
> +       }

While at it, can you add similar checks to other allocation sites in this f=
ile?
The problem is not specific to vmalloc()

>         buf[0] =3D 1;
>         memset(buf, 0xfe, PAGE_SIZE * npages);
>         USE(buf[0]);
>
> --
> 2.43.0
>
>


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg

