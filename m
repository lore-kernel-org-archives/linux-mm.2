Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48836C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5544E6B0098; Thu, 10 Sep 2026 11:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5053E6B0099; Thu, 10 Sep 2026 11:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3D46B009B; Thu, 10 Sep 2026 11:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 135036B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:17:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9799B140569
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:17:06 +0000 (UTC)
X-FDA: 85198205652.12.A716B23
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf31.hostedemail.com (Postfix) with ESMTP id ABAFC20002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:17:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="aORfu5j/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789053424;
	b=LdrQZIlLZ75VetSnRAFnIlzKJUbbf3onIlCGNaiHVc5FVY1xWq/2ZzPecko0ENPAT9dkOj
	G3J89CCSnizqiLy8zaHSn4lkDtxj5Tx4Zbduehxiyhf/d1vFQydJt96msL+XYmHzSDTvci
	PdjEPKphgAPmHZSiM7SkFbQ7nVFJfQo=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="aORfu5j/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789053424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDN/YUpPOFz+Kdvzz1//obMcefb85ZenH94zRZ152w8=;
	b=a4x/hGikCGW4aPq/nZNY+jAlqgwpAA7Mh2K0jc4eb5iIEna1kJMl6Xadazl+hCMLKre8VB
	5dOK39U38Vw3VqsgYAjkFQP+b18/zhTSSXe8Upc3qqPFNT2JAPHiWHx6OGjl79AImmWVeU
	4M0MivMSZOYu3rbqDHqlYJXgR/+fKwU=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5306706e89dso312181cf.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:17:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789053424; cv=none;
        d=google.com; s=arc-20260327;
        b=YSFQCz9TvSE/eydjzLxXMD71WE2SEJO8sJiRjYekpeHUglKhBsBTdcdB7+dE3LOwF3
         ZgFUzdVLBounea5Dbt9+33H04TX0LsZdEsbxnvZpFoHqAUC449TM+5YwLfw60KjwRjuZ
         KwYiutukJf3m7HB5KAysjgvEu8WGI3AmTETyoZOOPEld4NrcdhNNy3wSTIE7M092PkKV
         PiBLDAPKaNi3uosUYaPGKZLhWOLRp9u3TxwpuuIIO7HiUlrV0CVpZgNzTaNQ+RX80btc
         tyXxa7hJxZnt/XXz/t6R7L6jCo2NCvLmoqeqr2wHS+POJiTDivM4PAhAO0Izkl1nqo0/
         X5mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xDN/YUpPOFz+Kdvzz1//obMcefb85ZenH94zRZ152w8=;
        fh=Df1I7BuCRwkSm88JMHx1sc5zLJprYSQLjA8m+omAjs0=;
        b=jhkPbbETgaqUOg4x3czI/uxuP8Bsc7WNm7no6zlDELFPo7H83aTNghTaz61Q1OE5U0
         VzGCXfEGrJ6ykROApAz/TgNw9gM1pH2/RY3xGnGa6MdKQjYKUlLYcY6qzQfpOTIbFtf7
         QU21/nirJ6G+0wB8gNUEORYPA+sVGIf6NW9J7jmjt7RmVQu0Jy6rAdcuvXxi8Rz6Xwlk
         PyJWQypf68tBY1NCeBC/DRHF06MjbVCV8VGFRj75oVMQR5cvJGgtlkYsaYV3XoQPNFsG
         LsEwIjcfJr1Gg5oAmOXcAvkvZyxgVSh3Vlj/on2vDz+k7iogjO352Iug1TkDrRaidJqt
         TuBw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789053424; x=1789658224; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xDN/YUpPOFz+Kdvzz1//obMcefb85ZenH94zRZ152w8=;
        b=aORfu5j/8vTMLcuydu7dfDHiX5gucodQpNokWJznrtK2Ym6x9NicZT66Q4J3LJQFDz
         l/hQK0qPOC7x++ikYS3ZlJ6tUNFSC/rhLfzifvLdn+HCMRBYsXAUwuJpJu1AggNNeYEP
         0CbWHoGIggA8BxjG9ARBYulyqjjGIaMbvzl1hB3hQu08lY76DG+t5yJTQQfQ5O7MpPxe
         w9amaWqaHHxEiqQ0JkNBbKlMKkX1xmZ3uedI6b4OxvA3sWYUiCMk7fx7TakPgi+esgB1
         h9dz82YeBE+Vm67srKUYQQ1rF69a+ArCJC5LriC0fRXPITrQGZ707Vpk+QUL/Q/q/ZFq
         vRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789053424; x=1789658224;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xDN/YUpPOFz+Kdvzz1//obMcefb85ZenH94zRZ152w8=;
        b=Wt+DbJGIHuaLU96u5TU1ow5/dkAND6z7aoHpTRoWbOQ//DUsdqsfBgqxneol/AHGaV
         oH7jsnI3iFb4AUednLSRpou9FGFSPfn2sHVk1sDXt+oj1eGpwSnu6AmrkvEFx4F2dCNf
         ctJp0Y6x7qXtpLQsiCy8ljWsx+EzrzZnO2+h1TdIBcX9TXqO/nAOY/qe+xSqvbKjLKdd
         m4M8HTtuIiYqzYqXf+IVPcok/b1p0+olnmi0cKbEEUbAxESxS8VwY/FfmqXcBL5qEoJQ
         FMrA2+mZnS672QE9yGV7nYCrpjs2uEeK693X/iZ+jeGBSWFTAbdhrMGabpvQMNG/kyqO
         BPOw==
X-Forwarded-Encrypted: i=1; AKwUvBzv9NnXYQkzlwGJhISuGNcHHO/E/CO3QW88me3/c8i0oKyi3uaRWVbAPhvANVUU7uoACEm+ceaYKA==@kvack.org
X-Gm-Message-State: AFuF++mVZ8SeDz68dRLcY6+wD+A/cR4XlnCvqJh22s7y0rUIg/85U5xw
	zMP3pZ9GSOxxH8sCYk6faik+PcAwA7IZmYgT4awsF1Sovu4CZ7vR4LKdizrFcANmYmPEhtah/YY
	mg2lxtxviGEqzqcOE4kBsGORNBdizxtqhwhm2QlBE
X-Gm-Gg: AYBFou19Td3KzOQoairuvQkSstBTLm5mRNH5em/mSthEbm017iQtX8lQmXsipCc5k2/
	TK1+KtTcEkQ5tUWa0MANQjLsi9LvR9ZnfbziIhFVIcs3JfdDgVF/I53y1/6uIXDycpdQYQJ//ra
	LqUc/mSO3T2aXyRJTGqf+hI5LKMhxMNWeVrDP1zuebDsiRQ0sYQ9XMxaTpKlKdiVF8PMdskEQHU
	E4J+KehYYbiCHv3X0/3SmkjMnlO3rrbCjOpUY0INkzt83Wypi7QO4Id4Wz8aofF9nz+ukKqpg39
	kSk4fHyiuhFatnG2OJuu9j3KpFbwtTI+WsZP8AQu1yBU7hgUJJQFW0FKppmOPDljY4ljIKQ8qkY
	H9Q11fErVN4tN42W0tkcD
X-Received: by 2002:a05:622a:1107:b0:51c:ad5:93be with SMTP id
 d75a77b69052e-530b4874003mr21164601cf.8.1789053423038; Thu, 10 Sep 2026
 08:17:03 -0700 (PDT)
MIME-Version: 1.0
References: <202609102250.lIycVv3n-lkp@intel.com>
In-Reply-To: <202609102250.lIycVv3n-lkp@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 10 Sep 2026 08:16:51 -0700
X-Gm-Features: AcwNN1XA_1Vxrpu5C9I0NHGQICi5xwP_ReZ-YZ-hWwO3NXMcsgCngvh-2ENY2I0
Message-ID: <CAJuCfpGzZjvC49EJb8KwjzsEKi2HZbrKs=P+06GNLDSFoTedMA@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 358/388] mm/sparse-vmemmap.c:507:48: error:
 implicit declaration of function 'device_zone'; did you mean 'device_move'?
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ABAFC20002
X-Stat-Signature: trbswbpzmpfn463fgq96g9q6wikj3cyo
X-HE-Tag: 1789053424-629060
X-HE-Meta: U2FsdGVkX1/I2E8ukP83kuY1mtE1dcYnohzZrKLDD4gSNpWt4uJkmjeN1Fv/WpCNKe08pZLf3NhxG+f0WS05BXY+MRhlQ2EyEA3jVtVrGxuM1R1ov++rQmr29OARqABQSF/C+Rua33C1QqGS+53/QBkX9UlQ3qobZDsguI+xiET39idwYkS5jXkGcDf9cPtde4At4zqjSMi5xBRMLudPpLJKYKyYraWZSUEKX+GR/n+I2HlokcuyiK+WBaxb0e1j/F3cNOUBgOFVU61JDcewHwv+GtDEyR5Omz4arPjf1HjXZe4WhYb5av1xto7IIdwblWG7PGFEdjqFKMnNQ2LszRv46XYJ/AnfDnhXfQFUAp9vZX2+iMGFXCEmwnYVgI6g2IunrLesMAbhpk/cP1fKTJuIpOCpC4n+vEkpfNc1I79sx1xPuIiMdB/Zg9PGvib8OVkLcYwx77Toaey7Be0t0/qvPJDj0UPE/HdvxuFMGll0A+ZefQJYe+erkyKNR9pczbml8WmBLJyn56KgyVRVVXGuPviVPFKYNr4gmC2ozUlCZXUvQsB78P8S9vJI9qcsSFpKcBIrVGNRgI5ept9VqUAbChyrEjQ5R48KxcCUromJ0jKamEN0n2RlXeehIlddvhZl1xzOMFfqGKdWU4m8WOOabnBqslmUlWDcujASyPGHxHQEbAleMH19BIZKtkuBSUzp7aYI9T6Wm0doOXmxjoQ9x75E3Iazz0I2wkWiRsX6cSu9SSQ+ypMSlKfvPr3wlapClBweyqieNBjZQh9SAcLNAtmdCoyAwNsx0814YYd4BB1ZgTBGS8FemoZp/tez1fK1xDIl4Uz6m5l8qUWz4KfivBNWhg3dFz0YTyI7akB6DznZIzX7havEy5HCMbSmJF7rj1a+mZP4wkrGlhQxRee+JBTnyG+RPdH8ic8sdhbPd4iJHmsUIwuXuc1Nfv4X2y0t8aIdzI/iIbYTMEK
 rz1hXWZ2
 QM4JkVsK49riq6yTai0av0REM/3Rs7c/FnM3LjK9Alu8ngOHIcYnZUzMOWREPRm6JMXNVCeRqbvXYuSqWu7xVAy2Vy/G4Rw6fFhGvcNtjHwjWZwQzDBR0ErIeKTUwAdqVi0zNbLAVW9Nkb4VpCwq3KMPlGV4JwLE5JnZKG45xhK3aUr2qqnLPQglrPE2LDt4kVFTgbU0fSJxKEiVoLAkgSXVg7jxbNW9z2/wy5hXYv3AuLMOZQNSwu2VaMgfsHz+t60j/TSpclBdo8WVx686y3o2wz48KluKNh1EKe8HqKjT5apY6wyU8X4ZWmve6qCFZzc/pcg1uVWHga0aorZCLL/mM/XM+0fOx6yOy7RJVwS0Ak4kXYiPovsJYN0kVLLDp+QS6wNsTHfxvUnBIwnhnAjSvKtFAtxL2ceAq80fD98VVyauz+aGEhbRRbubNipaPYbd9lfRlIe54NuroGXs4XEZIPYbdouBY5t8lTd+p/ff8A27TMzgKjh2zkadokIPlTFsNjEgRIuPXZ+DnEL+fRLul88uGDFYNEQe9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 7:41=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-ne=
w
> head:   cf558a250cf4475a8936902b8978fbb6c61016f8
> commit: dd35ca2f2cac9d6439a2ba2f523b98b5a9a9f8f5 [358/388] mm-sparse-vmem=
map-switch-device-dax-to-shared-tail-vmemmap-pages-fix
> config: s390-randconfig-r121-20260910 (https://download.01.org/0day-ci/ar=
chive/20260910/202609102250.lIycVv3n-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 13.4.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260910/202609102250.lIycVv3n-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202609102250.lIycVv3n-lkp=
@intel.com/
>
> All error/warnings (new ones prefixed by >>):
>
>    mm/sparse-vmemmap.c: In function 'vmemmap_populate_compound_pages':
> >> mm/sparse-vmemmap.c:507:48: error: implicit declaration of function 'd=
evice_zone'; did you mean 'device_move'? [-Werror=3Dimplicit-function-decla=
ration]
>      507 |         page =3D vmemmap_shared_tail_page(order, device_zone(n=
ode));
>          |                                                ^~~~~~~~~~~
>          |                                                device_move
> >> mm/sparse-vmemmap.c:507:48: warning: passing argument 2 of 'vmemmap_sh=
ared_tail_page' makes pointer from integer without a cast [-Wint-conversion=
]
>      507 |         page =3D vmemmap_shared_tail_page(order, device_zone(n=
ode));
>          |                                                ^~~~~~~~~~~~~~~=
~~
>          |                                                |
>          |                                                int
>    mm/sparse-vmemmap.c:172:78: note: expected 'struct zone *' but argumen=
t is of type 'int'
>      172 | struct page __ref *vmemmap_shared_tail_page(unsigned int order=
, struct zone *zone)
>          |                                                               =
  ~~~~~~~~~~~~~^~~~
>    cc1: some warnings being treated as errors

I think this breakage happens if CONFIG_ZONE_DEVICE=3Dn.
The mm-new branch build breakage can be easily reproduced with defconfig on=
 x86.

>
>
> vim +507 mm/sparse-vmemmap.c
>
> 4917f55b4ef963 Joao Martins    2022-04-28  494
> 4917f55b4ef963 Joao Martins    2022-04-28  495  static int __meminit vmem=
map_populate_compound_pages(unsigned long start_pfn,
> 4917f55b4ef963 Joao Martins    2022-04-28  496                           =
                            unsigned long start,
> 4917f55b4ef963 Joao Martins    2022-04-28  497                           =
                            unsigned long end, int node,
> 4917f55b4ef963 Joao Martins    2022-04-28  498                           =
                            struct dev_pagemap *pgmap)
> 4917f55b4ef963 Joao Martins    2022-04-28  499  {
> 4917f55b4ef963 Joao Martins    2022-04-28  500          unsigned long siz=
e, addr;
> 4917f55b4ef963 Joao Martins    2022-04-28  501          pte_t *pte;
> 4917f55b4ef963 Joao Martins    2022-04-28  502          int rc;
> d1d11861d8a018 Muchun Song     2026-09-08  503          unsigned long fla=
gs =3D VMEMMAP_POPULATE_DAX;
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  504          struct page *page=
;
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  505          unsigned int orde=
r =3D pfn_to_section_order(start_pfn);
> 4917f55b4ef963 Joao Martins    2022-04-28  506
> 8fbaacc4a64bd1 Muchun Song     2026-09-08 @507          page =3D vmemmap_=
shared_tail_page(order, device_zone(node));
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  508          if (!page)
> 4917f55b4ef963 Joao Martins    2022-04-28  509                  return -E=
NOMEM;
> 4917f55b4ef963 Joao Martins    2022-04-28  510
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  511          if (reuse_compoun=
d_section(start_pfn, pgmap))
> 4917f55b4ef963 Joao Martins    2022-04-28  512                  return vm=
emmap_populate_range(start, end, node, NULL,
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  513                           =
                     page_to_pfn(page), flags);
> 4917f55b4ef963 Joao Martins    2022-04-28  514
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  515          size =3D min(end =
- start, (1UL << order) * sizeof(struct page));
> 4917f55b4ef963 Joao Martins    2022-04-28  516          for (addr =3D sta=
rt; addr < end; addr +=3D size) {
> 55896f935a60b9 Gautam Menghani 2022-06-12  517                  unsigned =
long next, last =3D addr + size;
> 4917f55b4ef963 Joao Martins    2022-04-28  518
> 4917f55b4ef963 Joao Martins    2022-04-28  519                  /* Popula=
te the head page vmemmap page */
> d1d11861d8a018 Muchun Song     2026-09-08  520                  pte =3D v=
memmap_populate_address(addr, node, NULL, -1, flags);
> 4917f55b4ef963 Joao Martins    2022-04-28  521                  if (!pte)
> 4917f55b4ef963 Joao Martins    2022-04-28  522                          r=
eturn -ENOMEM;
> 4917f55b4ef963 Joao Martins    2022-04-28  523
> 4917f55b4ef963 Joao Martins    2022-04-28  524                  /* Popula=
te the tail pages vmemmap page */
> 4917f55b4ef963 Joao Martins    2022-04-28  525                  next =3D =
addr + PAGE_SIZE;
> d1d11861d8a018 Muchun Song     2026-09-08  526                  pte =3D v=
memmap_populate_address(next, node, NULL, -1, flags);
> 4917f55b4ef963 Joao Martins    2022-04-28  527                  if (!pte)
> 4917f55b4ef963 Joao Martins    2022-04-28  528                          r=
eturn -ENOMEM;
> 4917f55b4ef963 Joao Martins    2022-04-28  529
> 4917f55b4ef963 Joao Martins    2022-04-28  530                  /*
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  531                   * Reuse =
the shared page for the rest of tail pages
> ee65728e103bb7 Mike Rapoport   2022-06-27  532                   * See la=
yout diagram in Documentation/mm/vmemmap_dedup.rst
> 4917f55b4ef963 Joao Martins    2022-04-28  533                   */
> 4917f55b4ef963 Joao Martins    2022-04-28  534                  next +=3D=
 PAGE_SIZE;
> 4917f55b4ef963 Joao Martins    2022-04-28  535                  rc =3D vm=
emmap_populate_range(next, last, node, NULL,
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  536                           =
                   page_to_pfn(page), flags);
> 4917f55b4ef963 Joao Martins    2022-04-28  537                  if (rc)
> 4917f55b4ef963 Joao Martins    2022-04-28  538                          r=
eturn -ENOMEM;
> 4917f55b4ef963 Joao Martins    2022-04-28  539          }
> 4917f55b4ef963 Joao Martins    2022-04-28  540
> 4917f55b4ef963 Joao Martins    2022-04-28  541          return 0;
> 2beea70a3edc03 Joao Martins    2022-04-28  542  }
> 2beea70a3edc03 Joao Martins    2022-04-28  543
>
> :::::: The code at line 507 was first introduced by commit
> :::::: 8fbaacc4a64bd1bfbfb11bfb48b5db3f4943cbd7 mm/sparse-vmemmap: switch=
 device DAX to shared tail vmemmap pages
>
> :::::: TO: Muchun Song <songmuchun@bytedance.com>
> :::::: CC: Andrew Morton <akpm@linux-foundation.org>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>

