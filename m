Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C907CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 18:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C0E8E001A; Fri,  5 Sep 2025 14:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7244D8E0001; Fri,  5 Sep 2025 14:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661078E001A; Fri,  5 Sep 2025 14:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 562D88E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:08:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D449B6DA3
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:08:53 +0000 (UTC)
X-FDA: 83855982546.04.0EAE7B8
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 114ED20014
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:08:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EkW4BWX5;
	spf=pass (imf13.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757095731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iGdnI/KfWDDu00FpGfqLB2W/2CyE6C3w8An1H9pjQWM=;
	b=wM4WPFV7uWXIXCCrs97+BynmF/Mf7mPyigkbmrFlifib4inyzktDp2jWyKn9GvfHSGFGZY
	GND9NggCkPwToXdeR8f/jMKT8lcV0KnoYYrdzF5TFVaMyIwERsAQvy61pSwpyvPPtsJiAp
	YjEEXtwdQMJXPXkr7MvsQ8GN40HhqcY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EkW4BWX5;
	spf=pass (imf13.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757095731; a=rsa-sha256;
	cv=none;
	b=3t1PbK7KLC/nIq/FLl7xc4QlaLwkrdzXl2uElHaXutBhWjLIlSYVgAIQKU904gkXCBmLhm
	p+J3D1nXvnipisBPDFOBDGGR2G+y7mH4uyt4GpGc4sbHCZIlPnnIniksuXIz3/98BEHzms
	kz3NQg1FIhyGLbPK1m794skjBUKW9A8=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3e2fdddd01dso255331f8f.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 11:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757095729; x=1757700529; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iGdnI/KfWDDu00FpGfqLB2W/2CyE6C3w8An1H9pjQWM=;
        b=EkW4BWX5kRgsKcM6CBgYYT1SWLYYNuWmgtpuY9W21hBQflK3XWBOvEBMbqg+e4DdDV
         ibPKa5yi30CigRM4W7ZLDYmcBE2cfGF9flfD5vhW2gzF5hV1RwmDkbJ48xkJ97eb21W9
         cWM56thJDf+Szog+PUpeGZTA0dDV7AfD5GOBMhxYPfknUNZF6ncfgwG7oVPPixoUQjAV
         L8ZoRR9cYY2+OcjSjVvT2Ljolu92xPZVQmYo2gNE8BO0qrxWkAOut4/6HAC1cl1da+F7
         ffhwbibHBmBPci3cRTPlmF0NQKD8PmA2u48cfUuXGSpTri4Ny0KbQxKSwmQr9ZN1mrHd
         WlfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757095729; x=1757700529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iGdnI/KfWDDu00FpGfqLB2W/2CyE6C3w8An1H9pjQWM=;
        b=SjxiDHtuioZYBoCZgv2tYnTa3Qd5L1YgMDXNjF9HliPeH/2ng1oaXOORyLuTTkSlwQ
         ZXVcL5tlpd5uXVZ3ClWMcpsqoePf8veLtsqCu3UsP3pEKVVTefULGeC4rvaQWpF4nAL/
         1PzJzoAN8UfgE2QUC3nwsIDPLYXtZJ2Bi0z1bDG8gGfqz5BtYedIrd3714PEC5reV1rJ
         zQu8dD6YNyb2ASreF+I00E2AzUARJ1Ntcs/1TCYLunddbrEUf5gfXG+RmElfBxlnX3ge
         FBUY2m88cugD4Pebjuvqkgjrl6S3XbdOAsqVOzcPHNX47ewrhfV/vGmlobDLnVdi+6w0
         fsUw==
X-Forwarded-Encrypted: i=1; AJvYcCUgYobdqRcrdWtFoA2cTTVeyIvDIiZaxty2oPUnJeuTXnftdZZ49kP6ZK4FudNlS4nUlpRkeFnx/g==@kvack.org
X-Gm-Message-State: AOJu0YxjpYmKYgfBM290mkZSM0E9evKX4VOmL6kLmtGGkpPDpK9tlsDU
	sJy0kYNLZPyQbciAu22rZ1y7CrThoKL3ogPgB426KOSN1zOVpBuZXSwnYufoAo/Njv39U5Go6Rf
	0VNvBBdxzcnUFO1r2bR2EfhEL/V6xXkw=
X-Gm-Gg: ASbGncsI4QHBrEj5h9dBH2xoS2XC/2Qc8NBaqZD3h/w5B4ZNC08pCDlRl+qXArqzSJf
	SpzJlkTg4uGmYgAZeFzopc8ZdpZovErdzAE0XZ/iGvlOOSJBRgXbVHgdl/hgV7R/T52k22o7kFo
	UOT7ywZZ7hXa8aQXSIMTvC3o7GAUnVM97jg2hnKa4EKBFOqARuhgORHvuVyCt0slDZzIjs9zB5L
	nDC2F+VP1SHw0aCDA==
X-Google-Smtp-Source: AGHT+IFERVcRo3NEqVJraCj4UK8XqQK1l3sZQfzYHrDnZAXUKAj3OQJ2L1gNLfVRJ4WTCNxbt7GRroTNPcmh78bqpuE=
X-Received: by 2002:a05:6000:18a8:b0:3d9:7021:fff0 with SMTP id
 ffacd0b85a97d-3d970220156mr11837479f8f.37.1757095729307; Fri, 05 Sep 2025
 11:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250820053459.164825-1-bhe@redhat.com> <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv> <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
 <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com>
In-Reply-To: <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 5 Sep 2025 20:08:36 +0200
X-Gm-Features: Ac12FXwl8rdmcy6KM72QT5kbnXVskzKHCQ5SWTQj8L2OmEz2lTLzNNXRX0uI6YQ
Message-ID: <CA+fCnZdWxWD99t9yhmB90VPefi3Gohn8Peo6=cxrvw8Zdz+3qQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>, snovitoll@gmail.com, glider@google.com, 
	dvyukov@google.com, elver@google.com, linux-mm@kvack.org, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, sj@kernel.org, lorenzo.stoakes@oracle.com, 
	christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 114ED20014
X-Stat-Signature: zmnuusanfmh3yxjrwtk8enc4e6j9oq5y
X-Rspam-User: 
X-HE-Tag: 1757095730-230269
X-HE-Meta: U2FsdGVkX1/Xz/E19mnYJ1VO45FjpXsu1qGbMplZ+emUtZx9FJJx1DrpMtEOfN27pBrb2hg9iN/Zf9JlRuxd+c2V/VSRtMQSfNYZyjB3Xp9tYv0VJHFVXZg49erG9V+Pyzmm5zwaEs5u1kR2DrecQ4Q0CiIL3VVKvST3MSbTBtiLSIXBj19bvHLDU39Xu8u7W153rjUMGJOL8v0vf3BBFXl0rw2wMYi789af8F2J5YhssTy4NEllZ1frE+dGWBJJVoOhadMDZZYd/9IwYCL0CQSE0vZQE2FIAYliDwzlIAPrI/tfy/4MC1bWE0wiTulRMcrBBWZRV4PjASfn05mnT+nwzENc3w9GI5+TYIre3j/h/HCAGIhwXaiN6yJCHGttsE2X5VEvYCP7fo3GW0yPXpSrYL6B51saS1ZURHEysBFAVP7Xj+TPYbxlpTvTGRbRS0izQDJk04e0n2BaDI3paOEX18f9H4xAg0OM7KTIBbHnIdyUmowo4PmlIgfRATjVXGva4pIQhrDMc3SMwwmMdcCv9hDzdo/c4xMdBmP8MuuJJQT+rj34rgji0ZoQ0ZFE5W75vQ2BsujjedFO6jdyHCUsRDEswFa9fvPkUMR5OUYIKt8NbHI1rZajbVS8bSx5w6+sTLOUMSeKbwFgyiTlxwx927OyToepMwdcUlRaOlicEXY/MUUkivNvsJBdNA0OXpws0jysfpV/Bj/fSsEt7aMQPdq5gTlM5Tq7dzGH1ilYTUThxP63NGt60zRHDNeVYNXq0zCq50kzaY6g4y4v0QNuYsqFFzcZlxoMqm9QukeNRHof+OloL1qnaLMj4HbbupjnFf7VWtKdQb8scSzrz6okOWRYF+J6mSB8PDmIW8ZgqGkI2d4iNxqDQ/MR8acl+5YfcpLj1JxCRnN/a6Uw+SlcHee1nFfTC8HEMyZ4WsQkRHLynmqDe1bhbQ5h3hoKqZbUZjjascOXcg1v/74
 ZaVPfhU9
 bL/9PnFnxY3jY/Agk2sJx31Nace4wiB7hiAsGoie2/gwehsu1QnLSQRxzwOjP0qK+y3YZwapKfZBl6KiS+aEAxjER8PJwFobOhfIdY35AIQAplgZGSAVPJ1gXWA62hrrOixF2SPDOudYPXrmw71MleaXlAJum4TOWPDavayyFCYOJNS/YgyuWL2PTi+JhsI9UzcIDOftC9J5/zS+cvAmecEJzJWFVfjyuF4Wa9rWY2IU/wQqglmp8d/OB+b88mxI9BhxL34e0XCpbnG4Uyi3C6rLldJb4RzFGN+D8QyYjIHAbDbODCpB0EnlM0qT7JD7GcZP5IyiYoq8hYvt8dnFsG2/qAdgfA0wUV+xCbf2faR1NWgIR+txmSc0qkHoNqWWctpDGmjCzzT4gmGk0d81r6lql02gvvzVQz3VcpHrtsfN71IgG/6tHyQfCAQZqVfv1llh3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 7:12=E2=80=AFPM Andrey Ryabinin <ryabinin.a.a@gmail.=
com> wrote:
>
> > But have you tried running kasan=3Doff + CONFIG_KASAN_STACK=3Dy +
> > CONFIG_VMAP_STACK=3Dy (+ CONFIG_KASAN_VMALLOC=3Dy)? I would expect this
> > should causes crashes, as the early shadow is mapped as read-only and
> > the inline stack instrumentation will try writing into it (or do the
> > writes into the early shadow somehow get ignored?..).
> >
>
> It's not read-only, otherwise we would crash very early before full shado=
w
> setup and won't be able to boot at all. So writes still happen, and shado=
w
> checked, but reports are disabled.

Hm, I thought it worked like that, but then what threw me off just now
was seeing that zero_pte_populate()->pte_wrprotect() (on arm64) resets
the PTE_WRITE bit and sets the PTE_RDONLY bit. So I thought the
kasan_early_shadow_page is marked as read-only and then the
instrumentation is disabled for all early code that might write into
the page before the proper shadow is set up. Or am I reading this
bit-setting code wrong?

