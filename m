Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21317FD2D9A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460B46B0088; Tue, 10 Mar 2026 10:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438D06B008A; Tue, 10 Mar 2026 10:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345606B0092; Tue, 10 Mar 2026 10:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 127636B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:02:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8F5056EB4
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:02:07 +0000 (UTC)
X-FDA: 84530317494.11.1901AEF
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id B91751C0022
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:02:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2pqWQugs;
	spf=pass (imf21.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773151325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wLELxQud3htXSosde/zL0GloFPfZfR+i/6R3NCGqSE=;
	b=3WGHsLPeXuKlH1KerAwWQ8GnV47xE5/+U3fpqAXMr7DkTd/XHISrpJnPvQBOB+rjheSoRa
	hu1hA4RN2AcGhX8D2oRfjaspWc46Rb1uCKm5guHDGBgLzkaEWgABQPcb+95FDnSGPUxiW6
	j9Max++1NxWA4nboyUsLAP+s+hX7XGE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773151325; a=rsa-sha256;
	cv=pass;
	b=G+i/6i38izmCeHRiUHDk1jVkYzIJoMOEIwRaYOQmzylfjsfbaSaZK5dbxFqX9FK6mfTnhD
	MgCito8kEHV0vXV4MtvdSqK6Ax3/ts5O9o7r9LVXNtLr9cD3bhqrckLnrEZjEqxB30ev7Q
	eCQVrseRsymgi2QID/xU4B2HKzLBWLs=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2pqWQugs;
	spf=pass (imf21.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5091ed02c54so499241cf.1
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:02:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773151325; cv=none;
        d=google.com; s=arc-20240605;
        b=C4BtUBcaBMbUdATBNEb6QEecN+YtIsLGfoFggE3yQv40TYgKgLCmtdt3hknC3haid0
         inPhZjMeyHra/jTO6TZN/3+0wV6xxf5YdswfIdwhu5L5aOmQqlICTFqNmaMF0ulyxstl
         1pH/4V1xAS/tU8ShVIRj8blP6fM0IPoEL0wTg6HrvtZY14hK8IquoqeY7hQynkw6fBN4
         /AYGWwCknLhqFfKZTFimBvUaMW7YEAqdNh2JmUAB0b6xh6Xpx5EvvCmw52OLgTN+KmOG
         DTAM2OAFostPaJw0UH81YjvQ4ToVVfbgYLKG859pV4ZMphxzxy55x9WmdgqcRtZIB0bE
         I2Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4wLELxQud3htXSosde/zL0GloFPfZfR+i/6R3NCGqSE=;
        fh=mNTpWP10vxtJut90NNknmVU0/q/Fbja2vHPluBcyAWQ=;
        b=d1Ca82S+ms04fSvYqW12Tmb7glvWQId3+4W6Iqt2rKBVW3oo8flwm1XY8ZBxzc2bWn
         zSwHb3SMcDPHQEhQKawF7YIKxdPRGHaI1vm6ihzxBb+kjKwSV7tLM+IcBwMrudT+HwrY
         cEB62/PvqoH6aNOHKLAMJloeGuPvnb6Fmy7Zlwkz7CXCEQxg3M3KJKPSNCzhycVeW9IL
         sWjzBSsbyvj/+OzQIBQ+V1YhPX8a/KJmoLCZUNK87hXLgGl7+x4IRGzhniBkhl2+rEvt
         dSHLTaBTAZ7xacx0PSEh/CCpJjNt7fD7lmJ5F86GGRwR/2cMlzKMBuJ+K/4PGcTO98tz
         UrhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773151325; x=1773756125; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4wLELxQud3htXSosde/zL0GloFPfZfR+i/6R3NCGqSE=;
        b=2pqWQugsy8r9pi5vdeXtdXaWbGc0gKDpA6GdZDPl6vx56arWvKxAP5IO/1LML7Ivhz
         0UnWv3j7feW2ti3pymY6cHwUywYZlsxgElzxnKL5FisBTT+Cg4Oy1Yd2IXKmShxH+iy1
         HT1BiaVVWZF7hz6OPViw1LpOAwk5CxmfU+CZESEnE4VvnpqlO5oap8hl9/poQog/hW3r
         YAyRpcpGj4GC3crHpy0lNC9rkiOK8HmkjbHqnd/bo4sx1r8xoCAFjVBd4ZWfhywBsExI
         iSbdxf5aNb05FcbP+flxZATv2FXQ6oIuBNqWTZXFIJLJBYCPVX7TGJBtmqB3qFh6InQN
         gNlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773151325; x=1773756125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4wLELxQud3htXSosde/zL0GloFPfZfR+i/6R3NCGqSE=;
        b=kYtKZ9K2Du5d9f0Sh6OB30JWxc3hDe1GZcV4SoQclk7WHhii9tEJlJn3Ktwu4c6Htt
         afUjsp6DqL1GkPZE2SGIn9rcp2qmDIUaUhZ+WUkC3SLg0GWJOOXv2pm/FEhLAvOlZj6X
         vGpqilu9Dcu9LttRMXgvRr6tM4owkUAarhBsDdNxPJhjMJkYsG48FO4U8bqk2r2nxDoo
         lqKD6ujXH2O6rowQFSp3btaEYGHXvdCQXOv3/q7V4OyB3544zeJ+mSYf3k1GZA2KUZod
         9dcFKnma1PmGwLCCDFuuk3r5le0rFzBxtnJkLjsRk6TTwj3NzdviRVUUsKhElttvCbQ4
         8vPw==
X-Forwarded-Encrypted: i=1; AJvYcCUR95gszxVXcrnNDk8i4m8k7LwF5JFvRX3fchQHfOHzRFHM+XKQ1PGYt2GOioKPwL91Z8lqZti61g==@kvack.org
X-Gm-Message-State: AOJu0Yx2JSAUtUvv3aNPqOY0pG1/5VrlYTkrgStl80Lii5S7Mxac6K4h
	AVHrQrJe0DHCXqDPmweNqp7XMoTHDbc3NeVel4E3Db7iVlALe96UKj5dXamHdSkdNcYvB5i0u4M
	Rzv5LeL5o1xKdCnrntWDQkKH+Irv3ZTdeCLw5Jw1o
X-Gm-Gg: ATEYQzzC0IJE6vFdRMYaaL54dnc0z/Dn+BuTT3Oo+sfuiiHNLcXhAzBxaPIs4Z8dD+R
	T/n2n0JNoq44H3IYWlMOAbCCogekqUPIAghB051n/RHoEe9R8to8dZo7TLVffcpzun9LeYRtB2e
	JzfBn/SfMK552S/Lt6N95H2p3FBkpFSrNtuuYYIGAUaaqW/yE5fYdL3WLFQBTiMHiQc15WhYho/
	Isegf7ErcghaWlXC9LMYQD8vTWCvyRfggqSHBMeJZ7tfJT0q3Rt75t3qgWy9EKFo6EsPjhqCKxV
	YwKyV/kgk8oq2Za+PaU42It/4CDYLh+xb8H1ZZJm3a0nD+Ns1U1TKRvI70fjDVum+PIMG2xMU3E
	BeSQb5qgHKXchLrld2culdwsd
X-Received: by 2002:a05:622a:1786:b0:506:a3c8:d44d with SMTP id
 d75a77b69052e-50927ff52cdmr11664521cf.9.1773151323418; Tue, 10 Mar 2026
 07:02:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260310060407.1133800-1-senozhatsky@chromium.org>
In-Reply-To: <20260310060407.1133800-1-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Tue, 10 Mar 2026 10:01:27 -0400
X-Gm-Features: AaiRm53oXK-y_X72MbDBnlVPnKuN7PrK0OkebVAEP3R7Ae_eXpwB4ioa6ZhtZZQ
Message-ID: <CADyq12zF3cwzSFcKYiGAdJ_G-NVnydBRQn+x0fgNq1kVgof4Vg@mail.gmail.com>
Subject: Re: [PATCH] zram: do not permit params change after init
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, gao xu <gaoxu2@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B91751C0022
X-Stat-Signature: 6zzn51w9f4ay3caujcf436m1mfe5urgq
X-Rspam-User: 
X-HE-Tag: 1773151325-352469
X-HE-Meta: U2FsdGVkX18lMRyhaA94qim/xtoJjl7OYgfOaSsIXDWs5YpsI77feWVagnmzrj7riW8gSrMPm7g4zjsM84za9VivNEaHXqXjX1s+Od3sCUAUH3bQIQrQlaewK1tAo6yBydiCPWV3up55sUfa77NARj5U/kgpIRLH/KA5Vs8EX45F0WkVTnDpTMl6QrdBQaPo8rwf2cHu2MhQhHpm/hoYKBqC9RRffqBXycI2t/KucCXtOkAJSlPsrC8q688ahyykPKhp3LkPP4eSH/ECV7FrtkKc1sWoBCtZMYbhYgFrBZ8WFo+ErkuD1yNjsyNpoRYi3vQoPTlZZt30LLivKPSshfPdmofDExq4qHLVhjhQeDXJILjpKlxZ2CCTHZOW8DO7nZCWAJDA6AMNyt2sdwTpMjHFfZOdK5i5GfkrvlrEMc/BgZZkzEjvYWkgbZclTeBkqMZrLamyJn7iDBNQhEtOtd3jmMdaCJm7AtizEwsclM44qxvXVhUBseaFxUtzDn3sJEUrYvZ/wL32esTTiKhKn9b6XjrQsbTqmk7MQEi7FUw9GQ4D9MhQMEeW57F1dl/4Z6QwdkZahaNI1m9tZunp3wwpdQguWBZ2SpAA5Y+8jx4fIT6oI4PXVCVbIbfCC/HRcdBt9ebKW/gU7qg5/RfdW1kkUin41eJm4w1H8YG5RQaWheRnKcLN3A9Gec7ohqKLPnTsVfYvX5HN+i8IIoknSkBYHNM9tONC1+m9qBpHOLrUoe0fk8GRCZQsYwT4y8y2RaD8jeHDVOZqzfEh5YorNW5WeeEj8hy9nNOYhENj2zV3BUAPd7W9mrpu9UKU1t5oe/aXTyRXrfB0wcm2qGrmhzxXZlpdxLKc/z7sfhn/GhLqJrbYm+ui1paZHQbr2mtQsXCebvkOirZDF/KmPfRfRnjIEuEfnX8HbbOaAmrJxt1Caa3lD4+aT4DsUE1CUNS17Afp8xrdB5zquUWNxtu
 jfu3/dBy
 JTyjZG9bXYQI5d46X5jiLTbC/hsjeFoCHgO7wp70N0rvQ0Vb5T4cNNqwPmV2h7zGEtDYB2lKbZnExAnfvhrMAMdyQ/gHnRC3JE9JHIU9eOk9e5Tga+S9lktePtoW59BMNYvMwYGhZMFcnNHKCuwzPCJdKvj8R0E5CvkMl0LTTJyoIxhxyhHmOcv7+IoWKCev2QPr0Ct6yKG8TrnMCgNFzlO14NF/xQQX2lGvGOiBZYeQc1yNIzDjahwGcZcTc3JVeJaKXpj9YcKJ+XTzSRRaX+FS+X044stw1vKQVpDrXYhG6/6knQujDIfm+znr1rDM9WorN3ORT35ys2JeaMdPCKxIPpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 2:04=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> First, algorithm_params_store(), like any sysfs handler,
> should grab device init lock.
>
> Second, like any write() sysfs handler, it should grab
> device init lock in exclusive mode.

comp_algorithm_store() and recomp_algorithm_store()?

>
> Third, it should not permit change of algos' parameters
> after device init, as this doesn't make sense - we cannot
> compress with one C/D dict and then just change C/D dict
> to a different one, for example.
>
> Fixes: 4eac932103a5d ("zram: introduce algorithm_params device attribute"=
)
> Cc: gao xu <gaoxu2@honor.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Acked-by: Brian Geffon <bgeffon@google.com>

> ---
>  drivers/block/zram/zram_drv.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index c41e1257243f..7551c5e664a9 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1769,6 +1769,10 @@ static ssize_t algorithm_params_store(struct devic=
e *dev,
>         if (prio < ZRAM_PRIMARY_COMP || prio >=3D ZRAM_MAX_COMPS)
>                 return -EINVAL;
>
> +       guard(rwsem_write)(&zram->dev_lock);
> +       if (init_done(zram))
> +               return -EBUSY;
> +
>         ret =3D comp_params_store(zram, prio, level, dict_path, &deflate_=
params);
>         return ret ? ret : len;
>  }
> --
> 2.53.0.473.g4a7958ca14-goog
>

