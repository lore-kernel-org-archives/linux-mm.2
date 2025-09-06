Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7EB0CA1002
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 17:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00AF38E0007; Sat,  6 Sep 2025 13:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24F28E0002; Sat,  6 Sep 2025 13:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13328E0007; Sat,  6 Sep 2025 13:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C45CB8E0002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:23:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62963868AD
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:23:50 +0000 (UTC)
X-FDA: 83859497820.12.0ECD57A
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7562EA0005
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:23:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Asqbf3gj;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757179428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4c2O+YGbvDnPu9AoMwBBiCr1o4ZEGNWgiuTpwDevAek=;
	b=ln5moRDWK+OBK0qq9iFiZ2me2avdqiQ4FEkvbPblqWU65UGJsSI0R9paK2hXHWKbGkB8y2
	H3kZvQ5/d5siM04+ANdez4dsNxVXAQGdxRDzZsSFoJyesft9U41ML29zVCCn+mkpEjrokx
	fMoKSkj6xvZH8rLImiwiy7kmzPiFVgA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757179428; a=rsa-sha256;
	cv=none;
	b=00vvHf6317peKg58d9LqHakIcNSdfsGJ8WgVFbdPTTX5lR6/73FTU7LJM9LDJgSb05zhz0
	ReYxSxV3SHIQkaIutfORVVslCI4fA5zW1CEp0uqUSJ+UpbW6jOA6nI7KSzx1ni6WPkzzvo
	008trSUUbJriCUymncQNzmaiMvDNKM8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Asqbf3gj;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45cb5e5e71eso16029405e9.2
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 10:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757179427; x=1757784227; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4c2O+YGbvDnPu9AoMwBBiCr1o4ZEGNWgiuTpwDevAek=;
        b=Asqbf3gj+yblIcNRWwbyBXOuRRc9t8ZTy9PY861MEM3LdWOHDjymZn5jyf+wT3Jcka
         CGAYBKkocwNOGrpa5/yXqnxWjwxHL1aqNpS7X1dDo9jebK96A1MpKwYHYi36AFbUSEkv
         DbJJLvli3efPRM/IuLs360UUKRY99t4zI7rf2Wz/1a0z5+9SdF8KHfGNczYGCYPGvTju
         sKfNcrGWjQSfWYh4s2r1MxNT6i/VIQcgrOwe+DRz06DPgsua6Ap2w8MY3EFeiaXH+OKb
         vsU/eZhAjeBJK4G9S04wZTAtZs4/JVJLe4YMoYoJMOm3mcgugA+WrENFEy3FH4AAvpdG
         aq3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757179427; x=1757784227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4c2O+YGbvDnPu9AoMwBBiCr1o4ZEGNWgiuTpwDevAek=;
        b=QYC7uM7IPgwlU82nC07G8NPtzLVi3DXEk4KSeE2TDqlmDsEC7Mef+v0sjcaKxVouQg
         Bg3qKXQer1TMX597k3tul2JN9SNyjzhg7S35x9iiz4hH021qYEJ441kd5ZiPHw9FAApi
         ueSshBfIsrnGVBPwr3J7PlOs2o6fEOk5byzhv+xX1wu1NS+vjNfKg1EItXR3tDSHHiXg
         DDQYhTmG0elT1q5Mn0So+Zoo6XfOnQg91Y91hUwIFq/hfsNNFjNTbgoOf7xhBqGdDf3e
         j9YQ2wGhDrA/DyuhXd+u+cOTqAFFVdrXTNxdKuk1A7+b4yqLqap3QcjyJJWre2n++NvO
         3Axg==
X-Forwarded-Encrypted: i=1; AJvYcCXkJt3c6TFR4PFGwwVlkGIZZ9HmOHue+3T+33VG4GnMcwOLzLGajJYuLf4VdcAXkmRsxRDSVs3NRA==@kvack.org
X-Gm-Message-State: AOJu0Yx449hYrrTd0GrkvRPh0w12ShgGdufOu6ZZS5hf5NZMXlUICTgX
	Ey1lkt5oFfvFeVPMJZQzc4ELwg7Co325RGTW4iUh+bqp4jBfkA8YgNtnDo8b08KjLtSpm3KHi/M
	o52c4kWgh/osiqM/IRLSUlNz8GOoANzVPPfJ5
X-Gm-Gg: ASbGnct82kseDrcZHMAPgdkCrvXkowmLmLSGWlv+upN4U7PDAr6nVBOEdRbDaRvDYmJ
	1sSpjbhsFOFNl4n4aJw/qUVaAR99XJvKfLlh2mecKI0ZvgRdLF4rvB3B8O4WPIpk5fw2n+D3rxq
	u/gzDpkWWxDMcovocBmKhJYKxkiIFNCHg6TE1XJYSxlaDhB/w+xJubk+H0U8ZdPl5maelGQzpAA
	Dobjuwu
X-Google-Smtp-Source: AGHT+IHN4dwIxDeSVaFZO3TiCH5vHCq3owsPniKFSD4gALCN2Q7ZBeOPautdIBQS9PG35ScdaEnNoWeQbMmPA/6i9XQ=
X-Received: by 2002:a05:600c:19ce:b0:45b:b05a:aeeb with SMTP id
 5b1f17b1804b1-45dddec8ff1mr22462305e9.28.1757179426824; Sat, 06 Sep 2025
 10:23:46 -0700 (PDT)
MIME-Version: 1.0
References: <aKMLgHdTOEf9B92E@MiWiFi-R3L-srv>
In-Reply-To: <aKMLgHdTOEf9B92E@MiWiFi-R3L-srv>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 6 Sep 2025 19:23:36 +0200
X-Gm-Features: AS18NWBaEWkn9-xRc9TLHpIVSI5D7m1H84UghxFJ-i2_WVGQHVzaNNUWikgWzvg
Message-ID: <CA+fCnZebyMgWWEOW_ZxiGwnkiXqXX6XK5NJv-uWXAxdN+JxsSw@mail.gmail.com>
Subject: Re: System is broken in KASAN sw_tags mode during bootup
To: Baoquan He <bhe@redhat.com>
Cc: kasan-dev@googlegroups.com, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, linux-mm@kvack.org, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7562EA0005
X-Stat-Signature: ncsftaxxpdfkstd8df4qwxf8jrpcxzgn
X-Rspam-User: 
X-HE-Tag: 1757179428-768382
X-HE-Meta: U2FsdGVkX1+Vn6lcwPGJ/g7+kC5SQr/GeIeUaR2qMQSN6WYYtssq6NiA7GhlBEeAz+hWXRVwzto4YszGBpzBEXx3DFJEmMjM8ZTs4cll2g6tYvDSF91Ji/L6eKIrc0/y1OywuZZHRoxXJCiKVr8YTRQEnFWlP7W59JWDIBKihrjcvJNyd0hGbGbmyP4pdob2/coFHDWwy5CNBeRWVxtKf4El9Hcs9lcz1zcygxkOreKn8j8yCBRrh2iUKtSPDGHo0B/KCzF8VFEWysRaLvjm15WKlo9msQfSyxaXlCnh7ePk7toZyl9nHSxWJkaxX8hSUSd30/GVA+q8Pm+xb+tbzBRYYaFiWCdD945ziB0D5HDGP1dkaxkb5xgjjIj3arvBi97HBP7fQRls4ppjsXkGr/f/hBIGz19Udc62vVf45+A/JPVXw4f6T0xJf+hIc8ZUkJ+E/GTsvsjkFuzRrW7qshJAoM/pD008L2H7N2sNKIMyi5H4R6W7yL1Iu5qrQBSuKZ374T4WLa0QlCQFqTwSlTyyzoezf4FbxJtMHKtZLSqtmQ2yFZgTChptYBxU3XmG7ThQ6+CzwWXRO+LKrs/y9/WMSXDKpkVQDTGOAuFW46Y1/846u1UQtP3biIcHEorejzrKjR6AuUg5tJM/P8O8umHe6nSf7Zty0C7I2aFsTMNLcRBjHRonWF/TE71MLvrW/+6B/bgJzuzc2Gf20Ra/YfUe5s49f8+VQw0ArRh1jaBPYgVSDTmGVQYpGfeByWx7crjGcp/KxCveW6qNb3jW6GrycovpjjJwLKjNt4BS+6ZlUkKGWjBv5tcSRke1g5zHAXEqlaTlUa79XK6GRrCtYNw8CdPyA8cH/CjZ39FxPvNCtsM9g86x8wAAPCEXqL4zSZ4WfXY/xQalvd6aNww3Q+GHbecWocf8JVcAIda7GbhICMKzPs2XRE/qTE046EIK/oGvuNfgjjfhgWwQ83m
 B86uRhwf
 +XV6ImuX0O4NWIbHgU1YZHc1KEUHqq1Uq8VdOyjqjQa+rw5kvbnuumPqkVFhL2cq5SsBKaa4Bcv+wkgAIlP/GJusN7dRlbx5tvKaeWmmeuf7Eb2CO2gUrUwsndqUZ+vbPfFQf+IFZDonLVeZjuIinJXpYglGr9Ls4mZNmmCAO1M/79tRwQ1yMEe4mfy6Ydeo8kt99jg/ziXgevTtIqR/EqfQ43YjdbjEcR2CrK2foAdE2CM5mqOl3LC1Q4oEkA1Wf3JU+OC+eEKlRLnVjMID8IoP9YucDq/tBLwLEjXfZ8nvVUiFCliKiD/KO2mj705TFRooNF8vcSP5jduZGLd5pgZ+EukPy3HmBeCchU+B7gzjhQXmiGRRB0OkJ/jbHXeMF4TsuS+vV0AFzrUmHmKwP7F9UyhHyGoYjppovDtfp1Bozp4Ctds5ZRCExCgUwBVdL/xCqT/F/njnLCS+wiYjsBFdSjCjy81Pjnif3PmuauR8hBt3tFiV8WtOPfe5SFzSoLEWD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 1:16=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> Hi,
>
> This can be reproduced stably on hpe-apollo arm64 system with the latest
> upstream kernel. I have this system at hand now, the boot log and kernel
> config are attached for reference.
>
> [   89.257633] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   89.257646] BUG: KASAN: invalid-access in pcpu_alloc_noprof+0x42c/0x9a=
8
> [   89.257672] Write of size 528 at addr ddfffd7fbdc00000 by task systemd=
/1
> [   89.257685] Pointer tag: [dd], memory tag: [ca]
> [   89.257692]
> [   89.257703] CPU: 108 UID: 0 PID: 1 Comm: systemd Not tainted 6.17.0-rc=
2 #1 PREEMPT(voluntary)
> [   89.257719] Hardware name: HPE Apollo 70             /C01_APACHE_MB   =
      , BIOS L50_5.13_1.16 07/29/2020
> [   89.257726] Call trace:
> [   89.257731]  show_stack+0x30/0x90 (C)
> [   89.257753]  dump_stack_lvl+0x7c/0xa0
> [   89.257769]  print_address_description.isra.0+0x90/0x2b8
> [   89.257789]  print_report+0x120/0x208
> [   89.257804]  kasan_report+0xc8/0x110
> [   89.257823]  kasan_check_range+0x7c/0xa0
> [   89.257835]  __asan_memset+0x30/0x68
> [   89.257847]  pcpu_alloc_noprof+0x42c/0x9a8
> [   89.257859]  mem_cgroup_alloc+0x2bc/0x560
> [   89.257873]  mem_cgroup_css_alloc+0x78/0x780
> [   89.257893]  cgroup_apply_control_enable+0x230/0x578
> [   89.257914]  cgroup_mkdir+0xf0/0x330
> [   89.257928]  kernfs_iop_mkdir+0xb0/0x120
> [   89.257947]  vfs_mkdir+0x250/0x380
> [   89.257965]  do_mkdirat+0x254/0x298
> [   89.257979]  __arm64_sys_mkdirat+0x80/0xc0
> [   89.257994]  invoke_syscall.constprop.0+0x88/0x148
> [   89.258011]  el0_svc_common.constprop.0+0x78/0x148
> [   89.258025]  do_el0_svc+0x38/0x50
> [   89.258037]  el0_svc+0x3c/0x168
> [   89.258050]  el0t_64_sync_handler+0xa0/0xf0
> [   89.258063]  el0t_64_sync+0x1b0/0x1b8
> [   89.258076]
> [   89.258080] The buggy address belongs to a 0-page vmalloc region start=
ing at 0xcafffd7fbdc00000 allocated at pcpu_get_vm_areas+0x0/0x1da0
> [   89.258111] The buggy address belongs to the physical page:
> [   89.258117] page: refcount:1 mapcount:0 mapping:0000000000000000 index=
:0x0 pfn:0x881ddac
> [   89.258129] flags: 0xa5c00000000000(node=3D1|zone=3D2|kasantag=3D0x5c)
> [   89.258148] raw: 00a5c00000000000 0000000000000000 dead000000000122 00=
00000000000000
> [   89.258160] raw: 0000000000000000 f3ff000813efa600 00000001ffffffff 00=
00000000000000
> [   89.258168] raw: 00000000000fffff 0000000000000000
> [   89.258173] page dumped because: kasan: bad access detected
> [   89.258178]
> [   89.258181] Memory state around the buggy address:
> [   89.258192] Unable to handle kernel paging request at virtual address =
ffff7fd7fbdbffe0
> [   89.258199] KASAN: probably wild-memory-access in range [0xfffffd7fbdb=
ffe00-0xfffffd7fbdbffe0f]
> [   89.258207] Mem abort info:
> [   89.258211]   ESR =3D 0x0000000096000007
> [   89.258216]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> [   89.258223]   SET =3D 0, FnV =3D 0
> [   89.258228]   EA =3D 0, S1PTW =3D 0
> [   89.258232]   FSC =3D 0x07: level 3 translation fault
> [   89.258238] Data abort info:
> [   89.258241]   ISV =3D 0, ISS =3D 0x00000007, ISS2 =3D 0x00000000
> [   89.258246]   CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
> [   89.258252]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
> [   89.258260] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D0000008ff8b8=
f000
> [   89.258267] [ffff7fd7fbdbffe0] pgd=3D1000008ff0275403, p4d=3D1000008ff=
0275403, pud=3D1000008ff0274403, pmd=3D1000000899079403, pte=3D000000000000=
0000
> [   89.258296] Internal error: Oops: 0000000096000007 [#1]  SMP
> [   89.540859] Modules linked in: i2c_dev
> [   89.544619] CPU: 108 UID: 0 PID: 1 Comm: systemd Not tainted 6.17.0-rc=
2 #1 PREEMPT(voluntary)
> [   89.553234] Hardware name: HPE Apollo 70             /C01_APACHE_MB   =
      , BIOS L50_5.13_1.16 07/29/2020
> [   89.562970] pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYP=
E=3D--)
> [   89.569933] pc : __pi_memcpy_generic+0x24/0x230
> [   89.574472] lr : kasan_metadata_fetch_row+0x20/0x30
> [   89.579350] sp : ffff8000859d76c0
> [   89.582660] x29: ffff8000859d76c0 x28: 0000000000000100 x27: ffff008ec=
626d800
> [   89.589807] x26: 0000000000000210 x25: 0000000000000000 x24: fffffd7fb=
dbfff00
> [   89.596952] x23: ffff8000826cbeb8 x22: fffffd7fbdc00000 x21: 00000000f=
ffffffe
> [   89.604097] x20: ffff800082682ee0 x19: fffffd7fbdbffe00 x18: 000000000=
49016ff
> [   89.611242] x17: 3030303030303030 x16: 2066666666666666 x15: 663130303=
0303030
> [   89.618386] x14: 0000000000000001 x13: 0000000000000001 x12: 000000000=
0000001
> [   89.625530] x11: 687420646e756f72 x10: 0000000000000020 x9 : 000000000=
0000000
> [   89.632674] x8 : ffff78000859d766 x7 : 0000000000000000 x6 : 000000000=
000003a
> [   89.639818] x5 : ffff8000859d7728 x4 : ffff7fd7fbdbfff0 x3 : efff80000=
0000000
> [   89.646963] x2 : 0000000000000010 x1 : ffff7fd7fbdbffe0 x0 : ffff80008=
59d7718
> [   89.654107] Call trace:
> [   89.656549]  __pi_memcpy_generic+0x24/0x230 (P)
> [   89.661086]  print_report+0x180/0x208
> [   89.664753]  kasan_report+0xc8/0x110
> [   89.668333]  kasan_check_range+0x7c/0xa0
> [   89.672258]  __asan_memset+0x30/0x68
> [   89.675836]  pcpu_alloc_noprof+0x42c/0x9a8
> [   89.679935]  mem_cgroup_alloc+0x2bc/0x560
> [   89.683947]  mem_cgroup_css_alloc+0x78/0x780
> [   89.688222]  cgroup_apply_control_enable+0x230/0x578
> [   89.693191]  cgroup_mkdir+0xf0/0x330
> [   89.696771]  kernfs_iop_mkdir+0xb0/0x120
> [   89.700697]  vfs_mkdir+0x250/0x380
> [   89.704103]  do_mkdirat+0x254/0x298
> [   89.707596]  __arm64_sys_mkdirat+0x80/0xc0
> [   89.711697]  invoke_syscall.constprop.0+0x88/0x148
> [   89.716491]  el0_svc_common.constprop.0+0x78/0x148
> [   89.721286]  do_el0_svc+0x38/0x50
> [   89.724602]  el0_svc+0x3c/0x168
> [   89.727746]  el0t_64_sync_handler+0xa0/0xf0
> [   89.731933]  el0t_64_sync+0x1b0/0x1b8
> [   89.735603] Code: f100805f 540003c8 f100405f 540000c3 (a9401c26)
> [   89.741695] ---[ end trace 0000000000000000 ]---
> [   89.746308] note: systemd[1] exi
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

Might be the same issue as the one being fixed by Maciej here:

https://lore.kernel.org/all/bcf18f220ef3b40e02f489fdb90fc7a5a153a383.175615=
1769.git.maciej.wieczor-retman@intel.com/
https://lore.kernel.org/all/3339d11e69c9127108fe8ef80a069b7b3bb07175.175615=
1769.git.maciej.wieczor-retman@intel.com/

Perhaps it makes sense to split that fix out of the series and submit
separately.

