Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59B78D2CE1A
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 03:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0306B00EA; Thu,  4 Dec 2025 22:38:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760186B00EB; Thu,  4 Dec 2025 22:38:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64F0E6B00EC; Thu,  4 Dec 2025 22:38:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5383B6B00EA
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:38:43 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C92FC84E3B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 03:38:42 +0000 (UTC)
X-FDA: 84184010484.20.D248B54
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id D83141C000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 03:38:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QyebYQaL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764905921; a=rsa-sha256;
	cv=none;
	b=J/QKSG6Eql7y8l7LMcuj4/fqkJoSAHhbFrcoFeX2m4/yW/wUnrfeF6urtPqYuDKIFIJpDU
	OduOhS1nWjnEZYqrFqTau67uHJa2L5DH9WR0J2QaSg094TO75+FlHcFDDKfSMSG7/Ko/vT
	PR0hBipSdyJMu/l3VBa9YR93U0dpV9A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QyebYQaL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764905921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fl+caqWL5n0dvFbZchH+YmZ4xMTXCKbX5vTDeE5p1t4=;
	b=ZuYrktSzPnVVFmqZijFuQlDKZJBh/uUtJ1wwg/a91dDKe7O9T59vU1k5MaboAGvge4Mbd5
	rvFhNczsf7+hi2ZsbAbq8Q3A1Uq61UGb1O5g6alUxFYVjWrXTA6BDDXz7AKTfllt4aLvZf
	NhG9fCEv4F0oOX0MupjP92JbRLQiIy0=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42e2e47be25so884279f8f.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 19:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764905919; x=1765510719; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fl+caqWL5n0dvFbZchH+YmZ4xMTXCKbX5vTDeE5p1t4=;
        b=QyebYQaLnNFlEO0r4hGep3dUVYKuIueJ/ispV/YeJUsZ65ve9Nq4dWM2MU0s01l0VJ
         0YT5uXCUBbhRFCAAraClal3W7B6t6RrcKf15E4wsHJ4FNFMX+s8Adu+TsTTrFzhQsSDM
         JA1scxE1gEIhjYOpH2epZ+QSTykiC/3x+TXEbNyythnZt/uf/1SsF209Ds42VRX0AUR+
         Z7Q4MECeP7jTFhiZYWIGZ1tZBydwkvXHSH/W7nx/DCrASNlrn9mdLbiPns8oz6i1kiTg
         R8RNI6Y+381RvEcJP79pt/FWyWhMvlAIb7ctQs4rfcahu8OnXzzZb6a6plX4PRoe3hRT
         CRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764905919; x=1765510719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fl+caqWL5n0dvFbZchH+YmZ4xMTXCKbX5vTDeE5p1t4=;
        b=DFIH3ByQdasN4ldsKrV/1e/E895dzq5YVMb4lzFN1YfAOorr/cPOOMnzqf/2hv+ZGy
         tveFbKqdblIQ3R8bXdZQWp90e7EkvoCmBfv+eixSyPNYF8VTHwqVeG1ZnX5u6apGPRNR
         xK0OTBHmL5Rjq3gLMTWNfLwj2ITWCp4wCyuXKL/CSWvjZCYzNQcIc/KmqsWUIjSI7CYx
         Ii19wUIkVkAySMweHuWlnoUwRVUX2MEKGj/mZ80ZebczDx3f2DNiSM5kyIdqhRcMewyB
         Hw6Nd4Y2smM01UdVRI1qpQEqEAywl64P9D1qhYG3guOV4opFtz42D6WBi15dGWSof4uy
         Kywg==
X-Forwarded-Encrypted: i=1; AJvYcCVIm590EFZvH7rgFEdXf/J8cLlFi11+7PBYTCnPPOcWBFBx77x95dPGvLB5UybVwCT2kWwzEr1ebw==@kvack.org
X-Gm-Message-State: AOJu0YwF/TVHiZUwMGspMoBEUeKhX5233pOFRGsElkqHEEuXoeVmLq+d
	3nbh75KS7jxgKetNSLY28WWwSW462JdiyA0P5LIY8ha/zk852gBre86ldOIkHwunXEUukj0MtqO
	sJ3x+bbQLy8p9sbmIztb2QdH5EtMoGHE=
X-Gm-Gg: ASbGnctRr83P7WZ0NIwj2Uymkeknrl8idY3GqWoO6vcdsAPotqytZ+M2s84BlJB9QOV
	jWX8Zo5XpJSQs6suleHMfI0reo54MMDYNPR4zvm2ig3om4Zc0ANb3V0cKszzPUY2XlLu3RiUc1P
	joeCPcObcUeHFMyenfKwTx9p5IJ/uMstCWMACBLycWyQEcY/aQmIEJZtJteH22LkQ6cuClpOxjb
	AXzDaJfd1E7opIUx1gRpZ6wo5mqcFXACHUq41jS1CLbf0GCZKaPh7Yb4X8K3GWoMvbStCEe73Sk
	TokZr7pweKnpofAMzPvS7uvsOlBbhQvDbtPkuU5U70c=
X-Google-Smtp-Source: AGHT+IEb0cv8ajRkhP7gPEE04bA4LbLhiR6KMPX5vUsECmsEKi+k2NDEA1RGG2g6E2/gLEUu60VXhRWF46TPGjbxI7g=
X-Received: by 2002:a05:6000:18a6:b0:42b:4069:428a with SMTP id
 ffacd0b85a97d-42f79514c50mr5364434f8f.12.1764905919003; Thu, 04 Dec 2025
 19:38:39 -0800 (PST)
MIME-Version: 1.0
References: <cover.1764874575.git.m.wieczorretman@pm.me> <873821114a9f722ffb5d6702b94782e902883fdf.1764874575.git.m.wieczorretman@pm.me>
 <CA+fCnZeuGdKSEm11oGT6FS71_vGq1vjq-xY36kxVdFvwmag2ZQ@mail.gmail.com> <20251204192237.0d7a07c9961843503c08ebab@linux-foundation.org>
In-Reply-To: <20251204192237.0d7a07c9961843503c08ebab@linux-foundation.org>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 5 Dec 2025 04:38:27 +0100
X-Gm-Features: AQt7F2r4SDeGe1uHCJN0ZI3Zd_JW0xi9yGmGe6DkXMc4yWVA8HXcBjqiziEEKSE
Message-ID: <CA+fCnZfBqNKAkwKmdu7YAPWjPDWY=wRkUiWuYjEzK4_tNhSGFA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] kasan: Unpoison vms[area] addresses with a common tag
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver <elver@google.com>, jiayuan.chen@linux.dev, 
	stable@vger.kernel.org, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D83141C000D
X-Stat-Signature: kw19zkbq6497o3dj1g1w65j4syt7ogq4
X-Rspam-User: 
X-HE-Tag: 1764905920-291315
X-HE-Meta: U2FsdGVkX1+NzkzH5uj4V41Og5j+k/4F1zf9wUnxRHly+azjiLSgkerqRvlfAAlSzVVdA9jdeSF8WdvnUju4S0lLBqzQaz4M3ySlHDR+I0TldFjLrp2pnxWBg5d/2T6HC8B5GeEsl/32oqQz9qqJr1Vhf8iach4vbmv4L6wKcNM/7FvAgc61XVPXzQAPSrED6vG8Ti1IbczTvJ9HdvXfmNwN4vi15hdDRxbeRVtjJ4Y76gE8dV7w7s1mItyghKyvbv9TlGQL6t6jegB/JbVhhsUmq97M5Bq1xl+8KlPxMJ+d7Xz6+ulAY0jjfmaJ5vn3D/hgRkj0GfKtmKxxEahSfl+mwewRBQkEgzi6nRyF6Gv6my3Ow0I60I8VAjn1kM0Ll4pkMM7paTYYJ5p3p9XS3x+bONxXSkTKDCImFwVSxfymDlfMvfejFbgyfCsxsz0X56Uvm1tZ6N4169a5Jg7AnzSlejFlHp5rbL90SNDjbdu2mjJ3zZcRVQu+yR9qfh86NAz8NIJicOWJVW6+aN49WxRdh8y8H43sRIbE0NDnPP8AOInW9FNvSnn6Gwv1UKR7Mz0sVOx4z55smdK7AN03o47CVo1Q1odHUKn5HHOBKdECJZ0XRMd5cEnGK0jUJPS3JJx/0xFkxbIfqJaVe5oBrk1mxxq7+ygFUsVNqtvpWiLzTiNtC4CZ5hdp7CcfCTbmDmJaU5r3TP2dBkEnM+aTffOX0c+XmY36rbvBD6Rn4oiRvVaohClKvj1eN31kZb2XywCMDVLUxGNOzX5/EhTGRcJxr0uK4Cc9VITQ7uPUzQbJzmURMQhr4JrSe9lAZ4qpAVHd9WwPoZN/4J3HTDtusG6zhaKz7Zwc+ooQQzmhrB6/CBhQUahTnif81zHwtRhT0IfFzY+LFsWzSHM4uK3BlRUJGvG9wvr1cVqx2M+7s4Hrqg1C2e5Ocut66HTp4cem/8+t+GDhEUZWRuXbvdV
 ZR+x2QFi
 J60VN9o2ot6fvCgJBM2xOkzJ1XGmCQo1otKpT9kbd0vK9MHqazb4Uc7ViA2ph7gQfjU+pkS5rCQ71JfXN9o/WA1Ehzoi9L7NWw8qUJvzeeZ7mjfLI3T+lbho1f8aGjklIp40UpgDE99qBgNbgcSlhzc1LqXKvq9D2GbeKlAN64vHpXrw0jE1/KKH+Wy6p2vGVp4jWfbwxd/SdnF6IPXWcUYRM4Wg2xQOf00MysmfNxL8NXEmgp/MI6xNagBRJI3nicaIH99B40A5eya3A10U3UCQja2ETQvt5UH6COJAFkta4q/VkGs+cca7amMb6CYF3THQcaXDIsIvqfDpSFCKhh4xmry85i5F0EZ9BWqkBkzq46VFL3o4Y1zj1YCmtsUHoUHLkkSfBRp5eljraxvSPxAID7OQz80tFRq/bzDZcDjyOo3+s7JtTjX5mck1Q/j4dCP3fX5BAGS+JWrv+k7W5UucS5Tj3sXrTYnpBPhH8qLl6MBUhGS7aw9M//JVEKUA8RMaa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 5, 2025 at 4:22=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Fri, 5 Dec 2025 02:09:06 +0100 Andrey Konovalov <andreyknvl@gmail.com>=
 wrote:
>
> > > --- a/mm/kasan/common.c
> > > +++ b/mm/kasan/common.c
> > > @@ -591,11 +591,28 @@ void __kasan_unpoison_vmap_areas(struct vm_stru=
ct **vms, int nr_vms,
> > >         unsigned long size;
> > >         void *addr;
> > >         int area;
> > > +       u8 tag;
> > > +
> > > +       /*
> > > +        * If KASAN_VMALLOC_KEEP_TAG was set at this point, all vms[]=
 pointers
> > > +        * would be unpoisoned with the KASAN_TAG_KERNEL which would =
disable
> > > +        * KASAN checks down the line.
> > > +        */
> > > +       if (flags & KASAN_VMALLOC_KEEP_TAG) {
> >
> > I think we can do a WARN_ON() here: passing KASAN_VMALLOC_KEEP_TAG to
> > this function would be a bug in KASAN annotations and thus a kernel
> > bug. Therefore, printing a WARNING seems justified.
>
> This?
>
> --- a/mm/kasan/common.c~kasan-unpoison-vms-addresses-with-a-common-tag-fi=
x
> +++ a/mm/kasan/common.c
> @@ -598,7 +598,7 @@ void __kasan_unpoison_vmap_areas(struct
>          * would be unpoisoned with the KASAN_TAG_KERNEL which would disa=
ble
>          * KASAN checks down the line.
>          */
> -       if (flags & KASAN_VMALLOC_KEEP_TAG) {
> +       if (WARN_ON_ONCE(flags & KASAN_VMALLOC_KEEP_TAG)) {
>                 pr_warn("KASAN_VMALLOC_KEEP_TAG flag shouldn't be already=
 set!\n");
>                 return;
>         }
> _
>

Can also drop pr_warn(), but this is fine too. Thanks!

