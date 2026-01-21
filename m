Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA81C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 353B46B0005; Wed, 21 Jan 2026 11:02:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6486B008A; Wed, 21 Jan 2026 11:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ADF76B008C; Wed, 21 Jan 2026 11:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0624D6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:02:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93F4B13B86C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:02:46 +0000 (UTC)
X-FDA: 84356439132.22.6591ABA
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2A9412000C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:02:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T40+keRw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769011364; a=rsa-sha256;
	cv=pass;
	b=y/t6+DQk+5i+a5JNVLaz0X3urDEDdlzDkn9JyfMltTgWBLVEzmKb8IjsQJ1c2hzeLd2kjn
	adlkSNXO6YlhffC4BbJNBG0i5wn1elH0Zg6s2GPt0ktFg8CLwn/jeG3WvJpWFKwtJRAk5Z
	+RSVJcwTwBZflbcC+ixnM47bMw1YbGM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T40+keRw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769011364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjAz9KoCtw5JjXr43UPq95MQTMGTgk1KGWTvjY/q3LA=;
	b=3YlfCTRng1TVPtvtLs1wRuub1N0WnyHBNIDVdIMZkMz2qeoOLWMplVVswaPKLqVhQlAXK4
	Re9w7AdkGgD25WX5MP1ZfIO+3bGarxPasA7lPqy2xZQK/xY8a9zr7Drk/Ds+pm2e9l9LR2
	zEXWGP4aN4fX2R+bXi67osS2IF1/KlI=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-64324e8296aso3765d50.3
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:02:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769011364; cv=none;
        d=google.com; s=arc-20240605;
        b=LZzA2yx7HyLtWKnaik6axUIB3m5L8CyRv6OINWjkPXxySs2OTQ00rdXLWDEOJa7eke
         ML+HBeTzcPnf1gLU8thYFVw0yci2nIHVkfwiNW7Yj45DGbwKqJ3lCQpN78odrkzbEykG
         WbslAW4kL66E3ui+7LP/XZZajY3WHf0+WgYfw48NvniCEavCfRXvkhUDPSDM/kwSVO4x
         qBw32Wfyl1pS3RPnGY9EoUHjK0hI7ge4v/3SqGxeThjMW2gxLTdhO/PDhhrXyWFaHrGU
         Nr+qRshKbNuzPUrRN5zGB2fRrVqnj4ZghkRGjaSCdeYrkYT6v0Ep+jV+qFTMOov9USdK
         B9zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DjAz9KoCtw5JjXr43UPq95MQTMGTgk1KGWTvjY/q3LA=;
        fh=w/RNmHYXd+EZE64WxpmphSuF9rpjkqeCFB3xBr2jwJQ=;
        b=Otgu2OkFakgvT5ET9L8o4SSRiJEuynL8rpBYgZdygM08ieSYTAFFZCum677K5R7iY3
         XH2PuV/EXV+Sgnxq+v8ry73JMeLnKsAi4LtuuO6XDc0mJqYNPgP6W3sdgWTnUnpGURAX
         /ep2/9Z6Zav2DCsFG8tydls2q54lgrEzvBTuWqKXFOTqViDA7NmmgKGaG/govfWoxTqW
         MWb9ZkkORGfuGWlk/zKADnxxvyJHPh1ejY5DhVVvosc6zKDb1pbkEvgl2OLx0r++ruCy
         egwVY4KmzArQkCA5hDVlgFAkePhx6Elakr3dMMwF9tr73lLEF2+k5JvSE/ZJtZ1t+qTq
         O8oQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769011364; x=1769616164; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjAz9KoCtw5JjXr43UPq95MQTMGTgk1KGWTvjY/q3LA=;
        b=T40+keRw6092ct0n3kLTmY6ARRo8j621redU3Fbfvip8XJ5rbqdYR5WIkVUjAX0yWW
         wp8l+01/UDlVQe1uH184jWGZp3AVcBMuK0bFlrwXcbcN9kEX6MUvc1RYN+reqehq3qqV
         B3/qkCtEys1kml7mL6HVTyQxU7RHV9Mh0TXgz4f+RWrHQC8zjR77EIv83UqlflZ8HKGS
         k1/TEIFRX4xgnm2t+IpF3Q7J1xtmHJ4DpuTrcsjrTTlj5mdUc/hbc+U3HiLmZOfSxblP
         rsVcCX8BNzCS3xbg3ey4vmI10uPtxL/E2VHN8gwOc56yYz6E7EFUecjnCuIUAOL5cUq4
         zyBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769011364; x=1769616164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DjAz9KoCtw5JjXr43UPq95MQTMGTgk1KGWTvjY/q3LA=;
        b=TOsKrEtg6l9Vpkk8A4tP9Gkvf2yBcG1mxzzgp16lKHr33QpabDIkEj4ayx8yN+RZQy
         XeVCmMeXvMZY0nov2EdUz6IPkOUfQWJqKnbtknJ0sIYXmm7K9NGjyTvWdqwrFw5FDUcI
         VsaHNsboBBTxV1L8+WK1OVp6UCzPbwRtfkIlalOdSDnKILdtsaoUgbvR/G3YKN2TT1tF
         4844GZbsmXHv5qiNEB1E0FSJxermmoL5CoiNwVFfK0OoI2ye5jlgoJHZEYzXeI7joix1
         toZGzk9LUXvxkcdHMXlGhChNpYFP2XNKvpBZb+jXJT/uVJyMZQjHvKUDYZABTSZw3gxv
         zDfw==
X-Forwarded-Encrypted: i=1; AJvYcCUVvG/i9VsI3xY5pimDRu4MdfmbWcDnXWVJg8OW3VsdWEpqglV0L65R5/SrDhvNXQZZizpahpLbFg==@kvack.org
X-Gm-Message-State: AOJu0YzQx2M54O5h50LLAB/T7TTzIMXmheRqgiXWnTGv+MfbkRfeuozl
	j+4RmvchY6JyjvQ69UxkFwp0TU+oucspwedmrVVvyRkYfUSLZyuoCtDBprGBhf2EAhpbs8PQ9MG
	qcbJbvg+wpvGF4f6uUwuXu4Rbvy3rn9k=
X-Gm-Gg: AZuq6aKuguPlY33Urp25geCByl4JLJ5gcGQSlc9ifeAvumrrapWIO2Po3Ik8RX3bhzv
	C8HmLz/yRDWDlHlogwUzsaxNjoxFZNNZuncD0ZqNbPJRF/YstAo75edsqsL7ie9L0IMLa1p0ZsZ
	VtHXK5uQf1KruLG48lpwJQECZ7UaTyGDNi1HdDDs2tgBqfTKVog3PuWeIuv9vWdoQuQIpRwR4in
	DAkt9j0xybS3HtAWNylyrUXVFV8yX3J+KPVuo2pWzlV2zsBcPW1wWqgeymt0SC5eDmb0QO+wFLR
	Ax9x5hdpK3WrUNwxCo+6ZbXFgqX9
X-Received: by 2002:a05:690e:bc9:b0:649:45e9:5545 with SMTP id
 956f58d0204a3-64945e956cdmr2171879d50.2.1769011363372; Wed, 21 Jan 2026
 08:02:43 -0800 (PST)
MIME-Version: 1.0
References: <CA+fCnZcFcpbME+a34L49pk2Z-WLbT_L25bSzZFixUiNFevJXzA@mail.gmail.com>
 <20260119144509.32767-1-ryabinin.a.a@gmail.com> <CA+fCnZddq=S0H5qXZ_CLSB3Y1cNw7nY4AYTBsGRR5DmY5+=paA@mail.gmail.com>
In-Reply-To: <CA+fCnZddq=S0H5qXZ_CLSB3Y1cNw7nY4AYTBsGRR5DmY5+=paA@mail.gmail.com>
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Date: Wed, 21 Jan 2026 17:01:38 +0100
X-Gm-Features: AZwV_QgZKfvJ8durzk3-qWhK-3WciMuskgbHg7adkHLjd0cRD9-mKJKeXArIs6Q
Message-ID: <CAPAsAGxiPhL7evokSWWXveVdZjU+8kUSjCA1PnEA9WGP2hiFxg@mail.gmail.com>
Subject: Re: [PATCH] mm-kasan-fix-kasan-poisoning-in-vrealloc-fix
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>, 
	Maciej Wieczor-Retman <m.wieczorretman@pm.me>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wtfpw36ctma98edkcofeu9rdkoxgc5hi
X-Rspamd-Queue-Id: B2A9412000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1769011364-707837
X-HE-Meta: U2FsdGVkX18pXnr7yvaWiSwvwBEJ0mSoPs/XCDtZUSZe24dgURSoxAcxQ7/CfDqAaf9msK1CPJ2VnTvaNajAdTO70JXIlQ3z3qANncL0F3vkCA5nCSKDIzydezjY9qlkQ0QyJNHAni/TwWiOANfDT5A65qZkRdQ/BzBnrk9IbXTK/tsWQ7K+vE8twgVXWO94MiSLhfbljlkIMnUPptodUVFXufUJ9Tkd9Q+ECpVjzJ9m1pDxhtIYqCZMGnZZiMHJwLOXtdqvTD9MQGGOJ1yz1VZL8VCv/t4TJOJnkE5yZoczMKY4Wdr+Hvvm6T78Ivzvi9AKTQqKOQfLyzJ69ZSc1wtGSMy7ixYCMITK/lgWHlFezClyqdw4x3yTPuaMOuZXP6FV2iGossGBaTkLYm2KTFh64qZdYoQ+CnIXjEJ40oxor7a68WcqZ486/qyatWeYt4jmzNWgc6RpV2EUfYpfrnu7UGP6r6pdJigx/ETxGR80drO02f/J5DxAgqfFn2qY5JfcGI9dhyQq04nleCnwYpA+oJCQ+OGzdOLUkp+CdaI0kTUW/xsE2jM2cUgcgL4uqa6/CqqbhIDfnFU+WVIU1rDLzhbjDSXe02BPz9kuVqz2UlJ6CtyZKKmnsKYk7DcgjQ6DZ0VKl6YIwnRigpkUbtE+g4k6lxReqshRa7ZN+7vhebtv7422O0GXRLCqTcqbAsqPWndLtMglZKBg6fZVzEkxxQ1cDhm8sMK1lnALyG57k/jUjH1Kb6JKx+2L9zKP8VxrnBbgG++zWeOAFK9aQjXfnWwmbnIcblc05JftjgDC9Axh86oGGY109YK8bwaAQzrW4lQ+UYHsF+Tq9RynQbIazsIEaZ79UNMl79He2GqVIQLeQKWb5cAjAYgBLlA/ISsKJfn59suHgMdSDiSwRQ3UyE9y5vthXcckfwZe1wCRYBei7hSVBrKcKsnOJoF1g+TO+Aocz0pUihkt9qH
 DRryl4o4
 7WhFDMABr1Iq3QcbERBRDfv5o7DNo5vUHUyBTJ3vHgVS/Dt9Li/8MoNU61UMiUQrojo2yIofP5R3Jxr/pZNW3ACvMKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 6:46=E2=80=AFPM Andrey Konovalov <andreyknvl@gmail.=
com> wrote:
>
> On Mon, Jan 19, 2026 at 3:46=E2=80=AFPM Andrey Ryabinin <ryabinin.a.a@gma=
il.com> wrote:
> >
> > Move kasan_enabled() check to header function to avoid function call
> > if kasan disabled via boot cmdline.
> >
> > Move __kasan_vrealloc() to common.c to fix CONFIG_KASAN_HW_TAGS=3Dy
> >
> > Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> > ---
> >  include/linux/kasan.h | 10 +++++++++-
> >  mm/kasan/common.c     | 21 +++++++++++++++++++++
> >  mm/kasan/shadow.c     | 24 ------------------------
> >  3 files changed, 30 insertions(+), 25 deletions(-)
> >
> > diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> > index ff27712dd3c8..338a1921a50a 100644
> > --- a/include/linux/kasan.h
> > +++ b/include/linux/kasan.h
> > @@ -641,9 +641,17 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, =
int nr_vms,
> >                 __kasan_unpoison_vmap_areas(vms, nr_vms, flags);
> >  }
> >
> > -void kasan_vrealloc(const void *start, unsigned long old_size,
> > +void __kasan_vrealloc(const void *start, unsigned long old_size,
> >                 unsigned long new_size);
> >
> > +static __always_inline void kasan_vrealloc(const void *start,
> > +                                       unsigned long old_size,
> > +                                       unsigned long new_size)
> > +{
> > +       if (kasan_enabled())
> > +               __kasan_vrealloc(start, old_size, new_size);
> > +}
> > +
> >  #else /* CONFIG_KASAN_VMALLOC */
> >
> >  static inline void kasan_populate_early_vm_area_shadow(void *start,
> > diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> > index ed489a14dddf..b7d05c2a6d93 100644
> > --- a/mm/kasan/common.c
> > +++ b/mm/kasan/common.c
> > @@ -606,4 +606,25 @@ void __kasan_unpoison_vmap_areas(struct vm_struct =
**vms, int nr_vms,
> >                         __kasan_unpoison_vmalloc(addr, size, flags | KA=
SAN_VMALLOC_KEEP_TAG);
> >         }
> >  }
> > +
> > +void __kasan_vrealloc(const void *addr, unsigned long old_size,
> > +               unsigned long new_size)
> > +{
> > +       if (new_size < old_size) {
> > +               kasan_poison_last_granule(addr, new_size);
>
> I wonder if doing this without a is_vmalloc_or_module_addr() check
> could cause issues. I remember that removing
> is_vmalloc_or_module_addr() checks from other vmalloc hooks did cause
> problems, but I don't remember what kind.
>

vrealloc() operates only on vmalloc-backed allocations, so 'addr' is
always expected to be a vmalloc address here. Calling vrealloc() on a
non-vmalloc address would already be a misuse, independent of this change.

