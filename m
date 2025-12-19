Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2864E6689D
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302A56B0092; Fri, 19 Dec 2025 16:53:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286186B0096; Fri, 19 Dec 2025 16:53:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184BD6B0098; Fri, 19 Dec 2025 16:53:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 07E026B0092
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:53:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B6FE213AD02
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:53:13 +0000 (UTC)
X-FDA: 84237571866.27.8731181
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1111D40006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:53:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="a8QkIX/j";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of alukostella110@gmail.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=alukostella110@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766181192; a=rsa-sha256;
	cv=none;
	b=ELC2RiKbZHBz3sIFErTc/3RS9SpcVsix2W8Ac6eR2Ll6h5coMGPLRfo08pNJXMV8xek6H/
	XJcKhajgASl9woGCsaO266znRoeT5XX0PKsnAlRxhr/h2XideaUsmWQRkNzncsKSpe+oiY
	FdfHKWt+WSmBekZQ1nABB2snuZS9eGY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="a8QkIX/j";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of alukostella110@gmail.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=alukostella110@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766181192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uZi9KzzF5bcd1uvlKRoWhKcmxbMR2TNYp+Q5fMhirik=;
	b=Ta0UZS3XAUiR9AiM4msKfrAsrl1lAY7G9withFiWSVU+PrHn16+PLEMN/FrA6da2cFm9Vh
	Zm5Ls3DCenxq4lOVc5/ZvLmVrjjC/AXX0WY85fJLHsi/lRyOLIWDx3YIhnJ4PWDGPPvOxI
	k6GuWeqLYuAGXP96cyFZ5z70XKCet6g=
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5dbd8bb36fcso1629812137.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766181191; x=1766785991; darn=kvack.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uZi9KzzF5bcd1uvlKRoWhKcmxbMR2TNYp+Q5fMhirik=;
        b=a8QkIX/jQETf8YAcTMvR9ZBhyLndXMQ0PPa6U5b3Rq9gPjDCP9W/iNJ+cVLMJkutyE
         lYWKl9qklrotca/1F2uY0sdrz7oe340DMPZVjRhdfvUIHCowszQfvYwqsjd2rYDVwofu
         OAX7UHXqUm5RaTvhK+p+7ZKW9z0oNfKtUJvrE+ibSLyKU9UcSxTDDpVsKUlqutOG+GpU
         72GTerLi/0j9dgAl+PAZu+f40OsoHqggefw0ZmHbCnxwF1YTj73hQFSiztxcKvFDWAkV
         pG6q9ShtRbIdpFnUxNZNgkj1AsHoJR2T6d6A+VxPPgkWmMGZ2Yfmbnvpzpd+F4lFZgkt
         UHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766181191; x=1766785991;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uZi9KzzF5bcd1uvlKRoWhKcmxbMR2TNYp+Q5fMhirik=;
        b=tp2uodnO+oz+HVmOVenEpW1iPFqI+myt8rQC9nustNxyvohjYbEKdNPoGgIceCWTz9
         XNX8YO4BzYQhVCPHDzQRamnLaqWtES+/0xeMaqVg9tYVsNUDGrhpWgKPx8tbhklkjJ77
         7vq+lZC24OXP76e9yNVyN4le2s8uRFyrtBx2K/lzZxPZnfYFXD20vu7wZLb86iJeixOl
         U3wrUEzWA8kAjpjBHRYtIXT4sRFHKZfALAop5s+4+/EWwAN/J2Yqy9VLzr2AvzemSmeJ
         hLjs573P4FcILxl+SHhT5OR/eCB+hvHC7qie/fsl9+uA83WUELTlMgRVigxc+1pqjcs1
         zExg==
X-Gm-Message-State: AOJu0YzwU2idoYNbW1q5tSaIKduIVHerQu1IAghx0uZHaIh7aareNxeb
	PbRx3KytZjEPy3cMnu1wbxKrDUkZ+v09ZL6NDLA2UnbYdiytm1dzS9MSUnQq8FP7MmbyWIivkxT
	Q+0LXaYZjKC0fwPwsefdm7aMHe0TXqDtlylBp
X-Gm-Gg: AY/fxX6SWTxjjq0EDq1lJeF+mjuKLTzmcjg3SDjFs6iKIhv+MWExTS/NLNDbHg1cGYx
	DaVDaZNZ0AgU7CAtSOtGXHuDfHWlBA+nVaZDSwTi3kfKOoIKcFPwG0P/f/ysgO9B7zfok/HVW0o
	kT46mBDjCA3U2rwwYW88grweKp0pMuSR3erxPYidSEnSSdQgOFivu8Ky1NwGXN9rvDkb2o+7ub9
	YiRkXmJQV4hkiQl7D7CF4JvwpwBNiDfWlWD4wRbEJjW+oHNwzQXi45DGWwTXWm0oiQxhzLFvYGR
	ENp1noi9dcE6YeEzBAQDMuqMZ8bWfCma
X-Google-Smtp-Source: AGHT+IEn44AOCBX34I6O5yYxg7BtcWpCgmCzlERgs2cZaRjOSJpSfFTxdhHCjDh+IoN+2TZeUL4Ew5UDSsghqB388bA=
X-Received: by 2002:a05:6102:26d1:b0:5dd:a0bf:8c89 with SMTP id
 ada2fe7eead31-5eb023b641dmr2943753137.7.1766181190978; Fri, 19 Dec 2025
 13:53:10 -0800 (PST)
MIME-Version: 1.0
From: Stella Aluko <alukostella110@gmail.com>
Date: Fri, 19 Dec 2025 22:52:57 +0100
X-Gm-Features: AQt7F2qirqpokesaA1kQpoeLXf1ytQronnuOCGcmSrWCn0HEMEsfr91ct1zMCzg
Message-ID: <CAM2Az-T0s7hdpbgQ=dFHiqqvGfq3bN_HNGkHo2bcgPPD75BCNw@mail.gmail.com>
Subject: =?UTF-8?Q?Your_brand_gave_me_that_=E2=80=98my_old_neighbor_would_res?=
	=?UTF-8?Q?pect_this=E2=80=99_feeling=E2=80=A6?=
To: linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="0000000000007f51600646551a0f"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1111D40006
X-Stat-Signature: ae9e1t9fqn1m1ztu588x58e5sk8c8zuq
X-Rspam-User: 
X-HE-Tag: 1766181191-772741
X-HE-Meta: U2FsdGVkX1/CMLgSRG041tIhsatU+E2QeML2CH38aE6F7UWYylSYMdatBvtOzjQ7lRVevliPYnvyb01W+wFirO+RD4rfeqPCUhr2iRxKgOrycrfe4Gu4BV4ZiDH2Y0yAEdJuY7T4WDoe3e/5gG1VDs9QVoRnQ2Yz2iIJzl3ArRBqfnAqmnJBX8tFcf2E4CeQPeajEshzJgS90NMBIa77K/0UNQ+DTHyxSjUJRbr0Yo314n1e5O8DnftJAoTcp32uy0emp3aj9p5fNo0x+FOlvNFlLnjqn3r2bNGLq8a2img6783OK6dVEM9kwNjWlDIkKi+jnN1MgWTjuKCeYEHwFI0SqWaI08+8SDevP9biP7VyL453pYEdzl7auo/JqlVaPbpEHV0337FTk+MiB/Ac4poDDcxX5hk1kEzECTf0LKgeNAFKpt5YMKnSsjS2Zw6Eh+LQFEsfQ5SnrTeWukKhFqct/9AzPgVkJzBBTeFQgmQv+1hnQSfCpWcdGO0RbgIfAr/ZaM4PhQ4sOi6uWl9pUzSPihJvJKhNSOWlYf7B1u5ZTSdEDEBOIKs/UTUFwFqEJfMoEvATJyvqykjSunhPfpD0lLKKKbvC6Fv3r7qd//bngs2fTtAuAVb5eY/XBbsuCg+rl0rthhAVTsYjRiJl5HIlaxW1SBAEJapLkekY36f8TdeFfKQ66MfsaUaGI2LWgZ5qpzIAwMKIjWmNxB1J4ThLIhFoRg+9vgIPXRzWqKNqnsP3OX3wbZi+TiJ2molWx+OTun/42BYjpAKp+iC/NBMPWRWRY17SrDr7bfiS4JDHg/NVLWcEoGjLSWcBWSuwGCTIzLF77OUUrTZP9I4ypZ7DrqC4fqYBzI0WYQ3lORpXyY3x3s4NlWKWaRaCj/9/dW0GLfmWUNSL7xW74CAVfwOOGomTCiGi7SHZPHUnlYdF9P0tWNahZ93puMrUxYIxdQP2Dj3VjNJR205G7Ej
 ck3FG3jG
 uIaipUncxGw5EA7ir2uoBt2O+frspDuZlMaxPRAWF76Gs4X0HuHLaFoHJSGYTrBNV/rfoP3KKIYRiLID3Lq8u22VGsJ1nU9dweOM39TLVuLiLwXUCe9+gjfjIyk7CuUrWVm9Doe4j0Xe8oC5ejj60T0OuM05cjS11HeZs/Ahpge5WZakyY2VaFAjZoA5AQH/Oj2+MsZDiogF1xyhQl2fY72U9ZZifxCUhHdVLYu++TDRX2SkJRScKX+O1kEMNmdUocSGsCtLwNGNC3Q+h69qUYQ1ekZzzJSfdqehGIjv3hkc64xlsgidrAJXvqUMR4C08NfAKenDTh2gHrUxwdi/vDNQNw4ZO1RVfNwGnKtEfQ1MzGNEDRk9cHpYBgmbaab93AUh6TGaQqPja2TcoEDKVki69Wq7KO7OnX+hxD+QVfMUVzapTTxVwxqVq1rst2wuyrWxZ
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.468634, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000007f51600646551a0f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linux

Your brand has this honest, genuine vibe  the kind my old neighbor used to
respect.
He always said: =E2=80=9CGood work doesn=E2=80=99t brag, it shows up.=E2=80=
=9D
And your brand truly shows up.

I specialize in building authentic Reddit marketing that amplifies brands
with this same energy nothing forced, just real visibility and real
customers.
If you=E2=80=99re cool with it, I can share a short breakdown of what I=E2=
=80=99d do
specifically for you.

Best regards,
Stella Aluko

--0000000000007f51600646551a0f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Hi Linux<br><br>Your brand has this honest, genuine vibe=
=C2=A0 the kind my old neighbor used to respect.<br>He always said: =E2=80=
=9CGood work doesn=E2=80=99t brag, it shows up.=E2=80=9D<br>And your brand =
truly shows up.<br><br>I specialize in building authentic Reddit marketing =
that amplifies brands with this same energy nothing forced, just real visib=
ility and real customers.<br>If you=E2=80=99re cool with it, I can share a =
short breakdown of what I=E2=80=99d do specifically for you.<br><br>Best re=
gards,<br>Stella Aluko=C2=A0</div>

--0000000000007f51600646551a0f--

