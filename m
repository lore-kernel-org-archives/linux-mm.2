Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 056AFCAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 22:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482EF6B0007; Tue,  9 Sep 2025 18:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C5B6B0008; Tue,  9 Sep 2025 18:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4F36B000C; Tue,  9 Sep 2025 18:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1708F6B0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:30:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8AF7140700
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:30:26 +0000 (UTC)
X-FDA: 83871156852.04.852FE8C
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 927EC140011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:30:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="X2bWMj9/";
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757457024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fEQiOQ22rYAZhHJ5F5hChKykmBsdSQ9Mr5OeL3gCArg=;
	b=uMkLVhNzdaHJpPPRt1JO+ftJdeQqhZSeMGNNeaxF7UxicKiynf1z5jC66BjCdw3Q4RIQke
	ODJlI2zUNFmCLEp0YsaT3RTp8OMrBXnM8nV1clYwwTlOUXDsNCfsmLtjYL2WiUsjpZapER
	AstDkKQJ4gekIDzwCzpClOG5uvZZMYM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="X2bWMj9/";
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757457024; a=rsa-sha256;
	cv=none;
	b=DVGtxW+txs3jTYtTUrlm9WZYlSfwymJ0LvSXo2J7bOerS/GynUdRxAsQUeZtwvfL7s2Wq1
	dn+MMonN7Mzv3ua7l7Jy7mIAsj2s5B3QUvNvqwZJNOWgekkUUGnyYC89DmXGNPZh6epKEZ
	Ne+8V24r6LpKy1PxpyRjMM12Q2xVd1g=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b0428b537e5so989490966b.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 15:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757457023; x=1758061823; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fEQiOQ22rYAZhHJ5F5hChKykmBsdSQ9Mr5OeL3gCArg=;
        b=X2bWMj9/fRwT1tEDSEGwiC+3vvz9LTPD7SFbZuN/M4Tyz0Z45adSUUssNxU3oOAdVs
         FUJCRC6hHf5Co47wrePG/TI35dCf1CxP4JvTklARCmpOTbPEk6xUdGczlP0qZQQ5di+c
         u0WKuV+wPPG0nhK2P7JDAgYcMs1zD/OoQrxJM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757457023; x=1758061823;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fEQiOQ22rYAZhHJ5F5hChKykmBsdSQ9Mr5OeL3gCArg=;
        b=XkK9FTg54voB4FhGwRj1TKaVLWDAYWToLKgfjJCARahUeltzFFDNXVSpH4aq4KqywZ
         R8yxs7eO2McIisbxP2wECKhQiZc4O5jYyij8NlTvIjrtn6L+INvz902Y+qo/Yvesv4kF
         75HYT5NKuMz/V3OhhyPZP34y7qlhpJ472I75B9P3P1JYbuIE5eaAe5HyD+KtUUuI4vTt
         MYraRoCrtDhpGIgNk0Zjn9FgGOCEaxeyEQkMoKTknAEsQXUEWCG8mPFfT/sPiJWqJvQe
         LS3aaEtudJWiyVt9j4D+bpuPufHMqjsQFaHhPLbzxIc1ylpsZsDeOv/XTj28zlQPCMm0
         FC0Q==
X-Forwarded-Encrypted: i=1; AJvYcCV7+CXnSROllr2kV7w/YZviafYpzwspjo5ZXXk3mw2LWZoNwFRXVhfdb7ZIIH38o48iATsPvYxERA==@kvack.org
X-Gm-Message-State: AOJu0YzB2xO35z4CTAHJ+YJGTWSdX04+BJ8D6UgYvVeL8bLGo6dMZEsh
	1K22Hv273E6adVpVkbDYWUe/ti9K7bLWxJOxdG3l2NrElFD1VBY/lXhi/fRu3oY5QPY+p1tAzry
	IztCSzrg=
X-Gm-Gg: ASbGncvuMuP8BSy+Qduf4NmKU70MTYxvNoHskaveXgGWL6VNCXW1gOvvFUIIU7QpMaO
	+reUT8pGRiM5yeewD1WdElYkE6iZYnrEM5jDgbh1RYR4wbfzFrklRBZgweNhFDproDZKyZZpAT2
	ELVENACABgi9BuE8+eo8YriqXlwDT21xdyi+q9Wz6deC3dtZt950qN2aEmDRQWYs8XhVg4PzG2F
	bMXv7657VBMV50wjqVyHVq7RvHwKmY3vs8Lf1Bn0QcWrqusupXrYksAxV/Y8lIkDN0knazn3WuE
	GQwS+93eFgCKrRpjOVUeMml3a/RZOqaJfXXwPrNzSXpjKs+3v+fYTUnBizGtFopWMdugZb6ai+w
	zY27L7T47vRc7/yob5mTsQGRJPdM7EqibWOrb4ZIhCAJGIIxq05fbB4Zsq2NRMMK0XVSww46qEi
	Cx9oyntOs=
X-Google-Smtp-Source: AGHT+IEhpU61MNTBtpL4hSxz4QuhrWFXfU3/A8c/OHaJZExSZyrv+zUuNHK1ZowPWKGeMgHhjjWeFg==
X-Received: by 2002:a17:907:9623:b0:afe:a2c7:78c with SMTP id a640c23a62f3a-b04b13cd697mr1133323766b.6.1757457022490;
        Tue, 09 Sep 2025 15:30:22 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b078304516fsm63029566b.4.2025.09.09.15.30.21
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 15:30:22 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45cb6428c46so57007095e9.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 15:30:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW+sjcTn9kL+GAjJG/RDSk9d0UoZgo4EI9/17nF6bOPj//cv3bzm4xyArZ6fN9FO4Mh1QepR6KwNA==@kvack.org
X-Received: by 2002:a05:6402:4412:b0:61e:a13a:27b8 with SMTP id
 4fb4d7f45d1cf-623729cb58cmr11071027a12.1.1757456686093; Tue, 09 Sep 2025
 15:24:46 -0700 (PDT)
MIME-Version: 1.0
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com> <C85C32F4-BD58-460B-ACCF-F0569ED0941A@zytor.com>
In-Reply-To: <C85C32F4-BD58-460B-ACCF-F0569ED0941A@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Sep 2025 15:24:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg0bp-_kqmfaDYQLRJO30LYxEsMu3EKi65sKoi83EUZ3Q@mail.gmail.com>
X-Gm-Features: Ac12FXyoXbbHUJtrfKhAFeDlVJsB9IiUaRxuYQBQJQyqpHDKK1GQ8JtkX5zx-HA
Message-ID: <CAHk-=wg0bp-_kqmfaDYQLRJO30LYxEsMu3EKi65sKoi83EUZ3Q@mail.gmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, ksummit@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Richard Weinberger <richard@nod.at>, 
	Lucas Stach <l.stach@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, 
	Geert Uytterhoeven <geert+renesas@glider.be>, Ankur Arora <ankur.a.arora@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Ira Weiny <ira.weiny@intel.com>, 
	Nishanth Menon <nm@ti.com>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, 
	Alexander Sverdlin <alexander.sverdlin@gmail.com>, 
	"Chester A. Unal" <chester.a.unal@arinc9.com>, 
	Sergio Paracuellos <sergio.paracuellos@gmail.com>, Andreas Larsson <andreas@gaisler.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: kp69ymncs5sybigo7e85doz5rad7rfhj
X-Rspam-User: 
X-Rspamd-Queue-Id: 927EC140011
X-Rspamd-Server: rspam04
X-HE-Tag: 1757457024-987735
X-HE-Meta: U2FsdGVkX1+8LFj+qwytusL9V9dDOyJnXRBE6b0x/EBTKZam4PRaA605ZkASdq1YiZYTfZf/gJ2PIkGqqr6MqaBabeLSNy72TSrMoxE5309j+wRnIgf+9dEla4OU1tpmKqEH5fWl2akT7Wo6j3x7cfJituXB5PbE6Bjf5L5RcVFqcIPZfnQ/f6/wa+9Kw3NqqFC+FVpNxSfMVMbmkmT7y+mpAJ5smMYeVuJ1/AX0xC1ZSlLH9GxgKR6EPX6DqrdP76Qa4DO2JzKpMfvbiUExty12YCSVk9iV9uEiGWHr9DA6HqI7QKA5pZfAuVyxsDto9i7AI4k4EyXX2eN0DhdrQ+GVDsN96McsBfNXsMKxcyV2lyuoYObEwC1DjSAe0CXuesRsegcWwI9GxLv9t8t8Cq9UnglykOF0DOVG3/c3ZQfAvR1WGp1HG8t4AfjQXi4QRyvQNQaP9yq41gMe65GF9fZMk7SeqHVAwqmHhIYnXEjh+AP7JrOiEu5g1ptDuAToRWellkwDShr4xnl9WasfLVtykf2Djrtio15uGVANPKlq0k2p5cRsUxxBWP/IN3EsQDP6rj20AEESx51GsIwdCqeQINVs7pbzPDXrQ6Ael5bhZ0VGW/IP67sP3cUUaAbEFGqcz3UgC2CGyNLJFDGEgwPsEEhaxCuKLz0b6yzBTfq1J7h5jnN/9yN0kjVBnhCH9nmi0lQbBIPAJWgAsBuIOAYckQbHCgWInab7C2+cSyYKBHJqEiWRmOLw5J8MI2Taw53pMuatgtFPO0ahabDoocFjj34XDB5tbotCLuetx5Hhsu8joaejNoMZA7MCtNf5pk7QQFcVe/lXhBbtOeRX0RifX1v4o/MTRb/KwcwSya1iruK0Pe+I0OvhaH8oiyhHIT/cPWxAvqUfONCleZZmZxbgLB1yYgPn3efRbqUEFwK4HkwTKv52ck+EEurn1+iaMBVuVAGi78INTb1A6O8
 e7UE3B7A
 gJvsUhJBjIBOxbmNDdN8kDBBJcoCRT6A2B2cLcEgkk5Y85YqNxPZxBOeDBE6GEF56cHCYMlH1r+UCx3wurNQcZmY4+RSOprsGBO+6YC1DJchBRq4vvPvZ//prPcP/9MJBFcyLOaGoCjbKinBaUkum6yKVU2qtSAQ5yjABNtYmMLZIVYzwBUt801OGpAS7vKGR3diOC4JgWJKa3l2f49E+ZRUWh3fJmm6MQnFc80V5QZDEmYI9lmrNGuGbaai9bBtg1IMeeuvnKAgCCubOQEABtOBuxeFWOwayXKoCLvVQgE0XavuNsjpeyyyc6+2uH9h0rMjtIf1ds8bL+uZxpfEVSnLL7nMe3b7mJceZYxxhg+pkheE2N2D67RenQGxFHJDGS7TZWjOKeT4jYrN34omU6/DN8gDjeSIo5evGbWirpnp6FA8Skw8S9k5ZmPXhuuDfM72q0l8uOjLyiBQf3fTZdR8rOEE89N9QI2WOQ+cBFb9X4nCRajsRadTKocdBN0I6SoStPe+7FVwZi1qkxtNZxQbGfi4N6ipmSVc3ioOvFCM0ufwwYamdmzEoZqWhMFlByoa3qCOFYSdKHJjChlHKVwNQ4UomEe2ZJem/pIKR0i2hV8RvbrkYkpqwDw5hCATgddQaaEvr0lpUlRgQAb6k/pwoHc2VhYKPDCW41AbxvVGKcgPDC/Uy+uWFT9Le8HuPFQ68
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Sept 2025 at 14:39, H. Peter Anvin <hpa@zytor.com> wrote:
>
> 1 GB systems used highmem too, sadly. And 1 GB was the norm for a big chuck of the late 32-bit era.

Well, while on x86 1GB systems did use highmem, they'd typically not
use very much of it.

IOW, they'd have about 900MB as lowmem (ok, I think it was 896MB to be
exact), with something like 120MB highmem.

So they'd either lose a bit of memory, or they'd use the 2G:2G split.

Or - and I think this is the main point - they'd stay on old kernels
like the ancient museum pieces they are.

I'm not convinced it makes sense to have a modern kernel on a museum piece.

         Linus

