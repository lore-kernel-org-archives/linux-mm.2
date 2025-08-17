Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3319BCA0EE6
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 01:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DBC58E0031; Sat, 16 Aug 2025 21:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410208E000A; Sat, 16 Aug 2025 21:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3263A8E0031; Sat, 16 Aug 2025 21:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F42E8E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 21:37:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99E83138A88
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 01:37:25 +0000 (UTC)
X-FDA: 83784536850.10.E943CAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BA707100008
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 01:37:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rcYsx2I1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755394643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0rGQEVdqE9BvB0zusq54TmefVHfom0s3d74aC8vKpQ=;
	b=sC1gk01zZWDzOQ59P4Z3GUUTcI8S1xu6x3pMZtqlqXnkW9hzAq0jzdmSTkkoRtvwm2uZE8
	bxH+Y9HJrAG97b//54yNaH3cvXVAekj65Ku0PoSDW6khZwNb66zKHzZRPd1GsmsT8+TCzd
	Qmgem630WsfMV4kwQ8JE8NGTPEjcFOw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rcYsx2I1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755394643; a=rsa-sha256;
	cv=none;
	b=Fy7kJ8eZb9+/CpNXNOBdfuOgWZj9Lnobl9GDmBYJNGxdCrDRYqo+p0uXaifS95CzVvQaAI
	sIFfgZZ7taFS/W3F2Jdc4p4RHlTJbqdZ+XJe+nvK6YQvwE3zpcZmM4BXe7dZGjVPq2QmTF
	6a0E+XIjr4KPh9e0+8dPUlMkavhqy+E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 074D6601DC
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 01:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2173C4CEEF
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 01:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755394642;
	bh=98B3wydd9pNJSwXo9oKtwIU8Z/skWmHQS9kAtrLaLLo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rcYsx2I1rgfl9DQKoVL1bDhTn8/Cc3FXxGdkgj8rJFw/zAnQ9GvPS4C6MzNWYL0GK
	 vTBrnuoXNPr/uv1obdItA0tYnIq2RD8BcRxrKeBkMz4YBleTag1tVoGDj7HmAuC9yN
	 N2sncmKUln+CxKbkpKVNHpM3Xf8NpxRi+mqA3E+cerh3boyktc9RScJNaihyiYdb4J
	 6VIR7K8AjivQpv+ivVQiBHmk+Gi7J6ti2jm8W80nhZRz7m38YKEcAdd+9xtgEuoP0r
	 PIu1hkgvrx/fj5qWWQMfsAAHI+Sdl5iPaauBstO+qblEXdwh4JOYf4qX0CxSfwUPcA
	 SF5Xndqx0abyQ==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-afcb79db329so416286066b.2
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 18:37:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVThY6PGCV9bneWSbbRCgShrBppYuqYUmAi4LHJwVSmEAzaN40U4nPu8ubbYkBgIB3cJYTxliTZkA==@kvack.org
X-Gm-Message-State: AOJu0YykZaeWaPvjksoC/72eoTI/wF6JEzgkZZ1dYY1BPoEzOSFOHQEX
	H2tA18emFUCe7xSJh4sCl2zCe/puR8bjm0Gdyc52l45fVuK/IQnbu6+vLLEHUxSZN02h+fJ7fMQ
	djoHdbnGr7RH4oh+shF+LEZqemIdo8jI=
X-Google-Smtp-Source: AGHT+IHXjJ/zZKNED7MRYupguP+hzkILfeOdZashtip7Q2uruj+3o+XpMjNgILr82FhUMA/aEsi0zdq1Ko56W4OITiE=
X-Received: by 2002:a17:906:c154:b0:ae3:c767:da11 with SMTP id
 a640c23a62f3a-afceae5af28mr383029166b.50.1755394641318; Sat, 16 Aug 2025
 18:37:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250815090539.1578484-1-chenhuacai@loongson.cn>
 <a20d605c-79a0-4d89-985b-9512a990b492@redhat.com> <CAAhV-H470h2HDEN_NY2qNBxUqQrSRQhLzwqZe9PB8GjnNsZVFQ@mail.gmail.com>
 <66ebc632-6704-4637-b62d-1cb11e5a4782@redhat.com> <9db98f7f-b90f-464b-ae7f-e94ac523bc28@redhat.com>
 <aKCwjCJTEhX4Q6wW@casper.infradead.org> <e06f23d9-adcf-4d0a-8ba1-bda6d4b483b1@redhat.com>
In-Reply-To: <e06f23d9-adcf-4d0a-8ba1-bda6d4b483b1@redhat.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 17 Aug 2025 09:37:08 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6csiOVDco=pocC72WSPiafDJV+1+R7P0KvB15dxOjtow@mail.gmail.com>
X-Gm-Features: Ac12FXwmxXwhrFiUo2UU-awg0ihzGsCPQXGqVMaq1mgOiUl9KUx_ClVs_iHzOFk
Message-ID: <CAAhV-H6csiOVDco=pocC72WSPiafDJV+1+R7P0KvB15dxOjtow@mail.gmail.com>
Subject: Re: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Huacai Chen <chenhuacai@loongson.cn>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BA707100008
X-Stat-Signature: et1n9zs5zb1cujswm7dxgiojh1y5g89p
X-Rspam-User: 
X-HE-Tag: 1755394643-858362
X-HE-Meta: U2FsdGVkX1/1MLDjhh9+Y9Tnqv5XT/7EEFiPsV9X+nSyCSwlVuoM2k4mKPlEURt4rrwk9TrsklQF/GBqi2IvcJnnaiYZSybo8QRKOrLUrSoGetmRBpiAtsgO2YazxffKRke8N8BYfIwZqMVtk0dyK7l3BVQYK7C5zI6i+48jr3WgRBwlWezDHZynVi6e+vqLu8gt5DPzTOFRzJN7l4j12WlahWJ0ZvnVSGqYFlZhoMkovA9+Ua6wlzq+aiKzD14vkWDc56nHxT2ndy2CYTfFFDop6I0ZvEZH4p3Zm0fi34IEctXMD4OHBrdkFClfbn3lUhUNjIZXdHRWm/BO+LTVYPooomkdvkbw7nrO2z53jN2dS+EbvAvIs4CnUKct7eDwj4gWk9ShNwawkWdRxkV5GDdCSSD13q51+Oy6AVb6EsVgMe0VIesyRxG5MeXYRXCB3QcIAz2ht/McgfkEMeC8HxVsOWAFwy5hgW/WKL+EWGt/DT0ajE13Jz1p4sfsCxfZeGQ5S8QLejHFU1ri4CFmKMMxB8HrgyDYgyLyIxRZrjnDDGoCBEdX2wR3GlsVYTpKk7JO3vic+I2R+haVzJbrXf6uTXTfl8hc7e1e5nYM4bPEjQJLh+kdnclHGntZyyMZdnUT1U/XOeUMOb/dqGF7538LkvwR+xasLDiyGbIKBhqcbdhhFGCGIIbhpQn8C+81gnXfsdux1ZfHxJHoGJPCGPplaVrXGFm4wIZXwOKaI9vxvUmq/wbSCSDJWFlyTeSjO4W9k6Gw3viZoeffLraQCL8JCqL9VaJIn9AI8UMmlVXIqq/k/ihP5oilfzYhDVOWpCaj2F4NtJA04t9usJdBe2yYwmCr9XhoU+FykvIfsYn8EuKXqfYWd99LVC6c5YnrJSqVIelT4ixoGjQR68CUrWaJgluG2cEjqm5vrUo+hzujU1tynn2yLj3BpPBVmFKl+JViBDgSIrz3arNIutZ
 qnNR7yMn
 7Mphy/3zd8J/NcZnGyuLSp4OODNYKyszz5D+sQOaWsYdCwW3edQAujCXIK2rYazn5FnL8laSQ3g/+5bvx691eyFlj0LIbqrvwpIpJXpxz+GbBHga3juSjZoVJrZToM21W+tZOQNKAKEIql4K6yNHqhkONSsy5aBdG/F9qrx0rROO7YDMj3t8vFDJEJWKAOFapMQDdlfkcXI2ikZK7P7xLcFVcdVcmuht/DBERrt628Vm005rBLxT2eMIz+Fr5y+SkxhuTS3ULi0isASeZ+hqk+s8eFtkJaT9wtf9yJZwIK7RhFKM4cMYbKZdvWduIFM7bxOIE4/UQFEyVXuT2SE/P4knjxl7kIWfPgwPz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 17, 2025 at 1:02=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 16.08.25 18:23, Matthew Wilcox wrote:
> > On Sat, Aug 16, 2025 at 12:54:52PM +0200, David Hildenbrand wrote:
> >> +++ b/mm/balloon_compaction.c
> >> @@ -256,8 +256,10 @@ const struct movable_operations balloon_mops =3D =
{
> >>   static int __init balloon_init(void)
> >>   {
> >> -    movable_ops[MOVABLE_BALLOON] =3D &balloon_mops;
> >> -    return 0;
> >> +    int rc;
> >> +
> >> +    rc =3D register_movable_ops(&balloon_mops, PGTY_offline);
> >> +    return rc;
> >
> > Using 'rc' as the name of this variable is an anti-pattern.  All it
> > tells you is "this is the return value".  Calling it 'err' is far
> > better because now we know it's an error number (or zero for success,
> > of course).
>
> I know, we all have our things to complain about. Some about Cc: above
> --, others about the name of error variables :P
>
> $ git grep "int rc" | wc -l
> 12730
> $ git grep "int ret" | wc -l
> 80386
> $ git grep "int error" | wc -l
> 4349
> $ git grep "int err " | wc -l
> 6117
>
> >
> > It seems to be a particularly IBM derived antipattern ;-)
>
> Careful miser :D
>
> > Some internal style guide, perhaps?
>
> Kernel-internal style guide maybe ;)
>
> >
> >> +void unregister_movable_ops(const struct movable_operations *ops, enu=
m pagetype type)
> >> +{
> >> +    switch (type) {
> >> +    case PGTY_offline:
> >> +            WARN_ON_ONCE(offline_movable_ops !=3D ops);
> >> +            offline_movable_ops =3D NULL;
> >> +            break;
> >> +    case PGTY_zsmalloc:
> >> +            WARN_ON_ONCE(zsmalloc_movable_ops !=3D ops);
> >> +            zsmalloc_movable_ops =3D NULL;
> >> +            break;
> >
> > This might be a bit excessive ... just passing the pagetype and not
> > having the sanity checks should be enough for the tiny number of users
> > this interface will have.
>
> Yeah, no strong opinion, this was a 3 minute hack.
I have tested your code, everything works well. But if the checking is
too excessive, can I use a set_movalbe_ops() to replace both
register_movable_ops() and unregister_movable_ops()? Because register
and unregister are very similar without excessive checking, then we
can pass a meaningful pointer for register and a NULL for unregister
via set_movalbe_ops().

Huacai

>
> --
> Cheers
>
> David / dhildenb
>

