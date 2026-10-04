Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87254CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 18:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F316B0095; Sun,  4 Oct 2026 14:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817796B0096; Sun,  4 Oct 2026 14:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705526B0098; Sun,  4 Oct 2026 14:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43D346B0095
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 14:24:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B852D120C27
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:24:27 +0000 (UTC)
X-FDA: 85285768974.16.87BE020
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE3F5A0002
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:24:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hcOMM8Zr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791138265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COuPsBcUBk1eT8Q71dO8QdpqB3ZPgP0C77xCCCNJQiA=;
	b=a79B06zMd5W6nDkeO8Hkokueu4lEN0n8JkM+BNbGOak3XaofE52zvuxXntrLztJj3iKTDA
	chbnJpKFLAL+9YkH8Y52t/t5FrTujyYWdBRF2rOGofWFUKMAdklX/nHO25JYv0I8buzzPH
	VdMT7Mkrlhd9Mwkt+D4aEXjSJSNZoOo=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hcOMM8Zr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791138265;
	b=pkZD3X5KuZiCn+8IPtYBwd1/n/n4I3aqkmGXyn85RVuvKbHqtz28FD1VcppcuxxBJnkVpX
	1HOULWM6RIDU8N7nCdwei6JQLe24Z05k8gN8KBl/67YIDoc2a5hDMz4WM0h8iEzksrmDKB
	wBRVZIn9veTpBfAaH//zPpmLd2vqVG4=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6ae14cdc63aso5467a12.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 11:24:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791138259; cv=none;
        d=google.com; s=arc-20260327;
        b=gNGbSnrAED3AawAx3dkcTvDZ2arVXhkdh5SBwgzAJ9hhPxIYZBvAA/OCmUKUnYemLg
         HcwbK5WltFMLIueV0n/Obh921AAfRuaRZ9ezeSHNbdSTZCZYCTY2aVowSkdAhDBTZHOG
         gjJ0c4F2+uS+B53iRt7pHXnTJmwT1BaXW4tOV7hcOGtplVJf9Zq1r/MipE4xupyFKb27
         GBFI4BqMcS84FDQ3fxgFcTWQ9dwJ/AHWicdJOYpyTqRQWvogdJgkqJ4N3zFwtov+1u5F
         uNBe1XSiGRxJ3elTlpWPyGDesV3lP4Yk3W0c95e3NKTxscobQ14vArunLor979Z/p7CC
         oHhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=COuPsBcUBk1eT8Q71dO8QdpqB3ZPgP0C77xCCCNJQiA=;
        fh=ephLcXmWRcmwiZfFEdbYC9wHnYPvx4sPMoWSPI7Mpyo=;
        b=rn7r8yI/546hXS4iOI3UNxto2bWVc90sI/T5g4tNLvkEOhFSdSv+jWfOlfpQgNBrxl
         kQO782sca5T4sogTRY8Ya5XqIjMalSNW/+9HTElL9Gti21+gFweJ/s2zHIk30UYv3KYZ
         O3/Pdo9zHb4w1RCnfmxk6eCONITO10LwZkEn+gwZ7s9nFkl6AJZ4t3XbAaVrIJ3EKodX
         Zca2tlkcPHyHVtV8IM4eSnbBMWwbxboLCRN68RLVV0IttTKxfljoJIALN0CGTN/LnhpZ
         o4BhJcwRGqR+F0YrlbR958Khsun9Sd/Q9jkQSheY6QKZQUqwcuLBhgykK6HHB3BcbgQV
         8FzA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791138259; x=1791743059; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=COuPsBcUBk1eT8Q71dO8QdpqB3ZPgP0C77xCCCNJQiA=;
        b=hcOMM8ZrHmf8RrF9JDLIrJNRV6Cv/4Lauw2STDWPEKXq2N+ISOTmwTh3TPxKk6nbVs
         TDu2X15V70l/iR3ff9gjbCasRvCRtrpgwqGFyRuzRUMP7V+hTWGRog7ab+f7rVI/0QPX
         3PWIOdKKwVL4NgzhdJk0Xdv8B4Mire1rWdubH1/fZfjAzsPOdlytnLq+im/TMTEXtmKX
         XPxkSccmt61BAgQZoD1XI8TzEQR3wVzMyNx/GIBvgsZkezFID+t3g67RXjKPZGkzoh6/
         DgvbSMMscoD7xrQavfr0EiDv2HLJUqcdJ+lLLCQXRyDxnldBOBzFbwApkAFe8GhWqhGP
         UZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791138259; x=1791743059;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=COuPsBcUBk1eT8Q71dO8QdpqB3ZPgP0C77xCCCNJQiA=;
        b=QpFvV9XdIxXJbJAnM5HU7rYQ0kcW2OSyfrvLu3wmteKD74LtXEwpdC9s1S1QdatH32
         J5CxCkQuvGiWd1sDyx9jYhjotSQnnA0l6jYMNUKk+ZG/m4kDyvfPQSygjm4eI0e8CVnf
         UiuoWgAZw+SwqSwjP8a62Zp1VueQoCThRsjnBANU1R2evjKQGO8gEVc5CJ+ShuuFkOQ2
         o38RGFj3lzSiulbYBqBA2fSD7AL4dWpdkfLaAEUrMIMXwRQfHsh1I7AlLCr8kjoTMu5L
         t+CSScWv9Wp/9V/sRb5PsSdywpjzht5BByLAg3I9jO32vVnyzr8p55oloiYHnW1YyIgS
         kyNQ==
X-Forwarded-Encrypted: i=1; AKwUvBzZ1nF8d6r7Ob8RaXVVGpCsXp/sCWgxN3vqxujA7sBgFO4mkuBp+z4CZXZZgnlfsuyH/+/2Oq0wwA==@kvack.org
X-Gm-Message-State: AFq9FYKb4JOg2F53oFNA5+fvWA3YOqzq3ukLrCXwYHji2lvlvAfgwmBn
	CgRCW9HsTQFOaLkoFRgB3vc3xC0q6B2vgcDaVfkuk8y5zGeCL+dVFGMRziCUHSC/Abnv0Jd7Ijo
	Si/MW7r1sWMNTdGIF7E/mVi8xZLlfFRA7ugTRwGUh
X-Gm-Gg: AYBFou09TYEUkSPsQQyL/MGyt4Fb1eHx9Mp9MCk3jfh+PFgLdIeuHKD6/4w1WF6z07Z
	KxAZ0FJKILelQkZEoq/6y3vRBJTDHyo6MsUxY26Gm2chzcV3jfcj8/CdFAxSBwPnEbF+sOAojhI
	gAPwePLuYvDOUhBhpYQuChzAh1oV3btokqG3fIRVbb3/GY0R78hT9RvUj1WZTOh53A4gjz7D7lM
	wMiC7zcNBowWP7aMVxzlqWO8r+9KtUlQTtle06KL0tPWYwwQteFKFDDHH5TawXuq4mXofgMN1ar
	vfaDaLQsJaHwgIEJ/QPrPKmiZiYKWpjwGZeaEcpSHbCrcbHmYmlMAwCPiCi9RPu92TU=
X-Received: by 2002:a05:6402:a2cb:10b0:6af:7a5a:97e4 with SMTP id
 4fb4d7f45d1cf-6afaf6bf03amr34523a12.12.1791138257648; Sun, 04 Oct 2026
 11:24:17 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-20-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-20-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 11:24:03 -0700
X-Gm-Features: AclHuK9H1gPgFkK4n-5s4Gd8NQjwfuvbGlNRYoPrM6gC5ICSAC1H3Sf5qTdT1bA
Message-ID: <CAJuCfpHOo8UhAZMvO5A3dKbqxQGAWtKGMHXJ+Fc=qwH=Nm0b6w@mail.gmail.com>
Subject: Re: [PATCH v4 20/38] mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, 
	selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE3F5A0002
X-Stat-Signature: brrhaodoaoezrmh6wwzhg868zuyntsk5
X-HE-Tag: 1791138265-234704
X-HE-Meta: U2FsdGVkX1/kZynK7IKhuPYxF4qAC7bhqRyFPE6h/kNWzajWEjYCOU8tQEj4cMbbkv6Q4baoSALKXoHc0MPIzjnWsAvrhQ6FK5iEBRlLwCur5Cn8Friz+ygNdoT/Z3FDtaB5Auj1sb3/TXvmKPa5hPiJOcklF1NctAH2jSYxl0axcZT2MCMF3bneBcaXhstktzvUcXmXYWzKFouPk/lc0LXQqQ//rWQDbynKd5Ms8IRRs6stD5VkMJPeX6y/Np2F+kXMs+dwIsSNueYnkwhZjy8WOd2FwnW2m8ODAzM+8yj3kTfA9ptK3wS5/A2fPYX817Ws82qzQL2DBUmVTmJg3QSii5de1qJf4PqjLz7Jv++Qu7461kuxbGe+Hvjz0dN6NeBPlj/nhhk5HI8cf3jCMy7QDYOdOgK1zcjCHz9XIkuBp+K5yGr3y9BDsnMe/LN5RV4T5i2kC1oPZXrqugSvw0T3AsaeZKOflt1jYtAW536k+0zJALS7zx+92X4XwIFyiXgd4RW32JOq49eb9wtdF9q6COh8EGLNlrAv1P291icbIhknqTFPckn2brOkZ89pUcYc5QeXQIxSB98TQyZ1bjTuTIDHSGoq2TBxQzhNYtTrK1fyMkfR5GpLeQGxHN1kVzFCg3YY0tygzFrahjOHjllU3h8K34Hr7FGvkMbbop0kiu6ba/jeVjCKVMoQfWkCeVobi9GNXzTFzRiPk5+O3uGrjvvYJnxQkFrZLDtVaspZX585dcJytfP9voMrtoTjA95ZaAnb/X4oGXob4NS+xj7NtcNFkBSFi5f8G6ajpxX/5xsN2Hjri3Vul9bn9NIH5k5wzueS0WJr833AA3UhOksLFVGG/sm9kCVnkN3rfd0A5SV4PuCHd8T2+zQF76iIsrrMeZKkbT7uP4FDbNlq6gAT/t4vwAFxbLxnGfyPuWNXyeUwORl7/0SZ6/Tl5y89X+28lfke6VSFl+DtjRU
 5hijkIl4
 u3XH9XKwMMMvGiFSlewv1T24M6HDhXTAdqwcPx4E9TklshPsgBjZvPQH6nz1jI1/8KjaOCHWIEDZPdnt59B1JmpGyZabq9qjtI3DiwlA1paWn7mr15sMaINGRu89+m153RQr/T8Wq4vOdk5/Lzl9Hj5seX9fLTJGRkKYeQmdZvR7SVz14j16iIfMrVVwQHkouHenR+SAUUbnqM2fKVGfJYLlB8b9U49f+3sIMHKfE2cFyCxSdv2IkQIqstrvGmWVWrYCGYah6A8M9UV0DaP4zd4TvyTKaTWOw9CuTBWbVVDdfx6JVsfjePeOQItsTUGbl5adc4Pt1ax7uVFcNbl0Yipa5kdmj43wDrdkAEyKfiLCM1/Djjq9lb5Bv9SFdCPuoEBXsk0RORx8VimkJtnTFtx7jltXqaCEFkKV5x/l+sEJjXOeReUyb3kxd5uWwX861cozid11VSuiLZuzZIpZwEeXQklkh7jx1RkIPhkeOxRM0Wpkw6ZPHIHcqctY4VFyX0vWsJ/eZaaFUESos65ziudb89yl+bL6SMRY+4XPJMvi0S+uRbRfUJfMoa+GOkqafnlFGllopggTPOGD4zUx4ywag5O15dmP/tBXHvF/Liqo1z1roSdpHjIP9gSivW9ekgVZ3ZcT3saR8S93XOjJRPGX7O7SQBbdsZlZuC83qU+mMDNXAhvN7ugwan2YdKaX6Clj122AfN3hHP+TnWPr+FpcG/P1wolEPB+JVzb+vFx8FZpAEdQvuW3A9p4gdIiwjzZIZFEXjRI2Cxec0g3IIqg2EFoltrIaC94xUq5L53D9xTEExrxMPB5nCNWyr1blfrzDreYoeSP+nsWheYaVwlU9nKm2T+tN/dMohFDATGReaYN+QyCQyF/3W02bRyR83hyElFiEiUvQm/U2jSx8+C0/NyWSqhkFo2QyzftQtb3PccYDULHAU1MBzhnK+5tule1/MggbGegNEw4p8PT7rY41HLv3V
 hogN0HyI
 SW0Sbpuv9dcLz2akWf1//24/mfg0QAGVD2qMbxDnEiA0KIxwPAyJAtgPTOhUVuQfX3MG9MN/cai3Ave50DuxPOGklpzAhIk3hKr+4W8BmkE9wwNeHGq8efI0BBTvMgTpQHGYz16iBJ3oUjHHc8jWcvZmEumkB6lNmhUPnCXzmUUrDcQ8MOSU8Drl3cgm1L3T2quSihbHz1Gw7ffIdeXKY258SMOQ3YJV3g3xlMt6uSIfy6Kao0TVpt7Osp3rdQlxqTkN2zY1U7fxHwClgVVv+kYBnjH4EsyUj66H3lN6XXfNCkhFSOyG5BYFd8NSdbPxJGSIlFwsE8D0ZaRbR2WSEM+CgFngL4H/B0Bjyj78aY3MlTPwdjqFxTPCq8JQBqthZgtOK1Dx7WG98xTKThgJTrG/4bRqoB67B50A8A+d/dfEWiw04wIbp4Pbn4UCmnJWJj9h9t2C6VtWF1a/OPf063kFAvruqCVSDufdBPZ/xJb4WF8FMk+woKlPeS0XOynMh/IYC/pMVy33NF1cZ9meHNddy7PgsQKCuFaw6XPnWsQcVds2LyXygXXWEFmQFj+el8pu/VsYAHgv0YnVumFAJDhh/BtN3eUIx1GbQ491p1E6vvxW5ZFw1EI0O1MWnnHB4qP6Ov3TKbz2LsLgMOjDc1SIgJnZWlGUc6XGlS10LS48kd+HPtHfVxE/bTbGyk9dpPHSeDIjJhULimln/Uq5pgu6zE8pOj0rTEIL6flYUjgItZfx/jZs92io+0V/H02mnInOtWpfjtrD2dlgLYSuc7WobJVJeZRwk9/zE9OYzJ/H4ZZlfhVRvqpb8kYCHoXg8tEO78sxC/4Kq0YZWlI8DOkgabaxF0q4eiyZ8zgZ/A0i/HfDJo0xOzLwWsiHICnaGl7Zt33SY2RGhJF0R0oA6x3JKdqiyfpWn1LKuBwFzirq07nnoZ3cjpff5tG3hGXXmCuuIEpY/3zsB35RmEGb7hreERidt
 hpm7vNvw
 C4gKhftJo97WENsb/g0syMUqztRL0s/lSd6yXjeEfNZVw9f+cnfqovBCFQ2+7fv/seLi1haS0R7JMr+hwcTETG2Ot88BZF/Q9fOA9gKKWV/0tIGX62SWReAUKYdpM/S0q2dr7XhSYZJgzwJ7ti/ToNhY5sE/KOdRl0X3U8wWtojnVVRsK2FXkd+ENyDLCFmxrNDmzVEBUkB8OXKQHbZyIjlUQUL+PrQVMd3CI4cZnJcf2auuk0wSUxcZBwySxAbDV+p9VNrTRXPWaYJthTANzZkTOfYHrGcMzm/rtmkCmx9ZZ8BQGZ2y++lRUF9s+Kj3+6l5oHskLAp/TCpf0/qYS9IeCsSIyISZQWu5WA+lsT09VCVDTobTXIaMUCP+Kzrb3m/0rHaUkg4QwYjtMeKjTb0KUL2ZAn7oDILpfmIYU5Q9vidToaht2eEvguh7whHGeJ22PC3XPkXQb2HpmIeUK6N1fvuxmlA9Ww6BIjHyEyDbsgZO6rDJtJPyHoFT9XcYT5dBpTaOSEWGoJoDpqBNuQWM5B1aXtKM6U4YpavuWDAfRlDCtCk0RjKPzbn6e38m81MpqDCesS4XrG5nB1XI2asYcMH/hQL5cdkgwU3zEjTqd5XlXUXAAWZG2Nhigt+cnd4Lq6DB0/A0j6sXQovsqQ1ZakNw8OlAPpQAJkMokf2r/avVwvSiVnetVQg1n3Jltt9O/EI+L/xlaoSRXGCNhSvseQr6jk5ZxLG6sdznYxTuhkijwsgGgorJB81eDPXmZP6zyL6U41bkCGJVnHS+EdCD+EoNRF1dZziaENPWb62q/VgriGtrBNvEsDIOkA5x0jS6W8my77lHiDgjiZaOM+35V98H5N4jbGWWJ003M/jDoSwEZyD9nL65KBjqPf25SykkS/krwyWmcytYegOTPT0UYCurhmVGFbkk2mdRQlTe4hTMpB7mwdrpyJFW95bAZJXiXKUXcEioN6DBq8tm+jT64VMUA
 jJ1f/k7f
 ItMbhs7IBXFDxTz7Knt7eYfLwNAlfKlwNr8f9LCzdDU90oR10XQKgysgMs0Hb61CAsEFN8Q9yiPZYDzcxOtljrff+LH7DN7Kq9yqeLzj2cy+53rbqlIUhNLu1NJ9K9um+VsylK7f33zXknyhstxlALCq3BmBRkACme1FJk8Q/RiQYDOYCkHTzNngvojQmu3LZq5KhBeh3xTv8INzUBQUeioqw5tyvIbxflGz3S7B46lzr6WOojcNQMjAndKlulcLCx039qIiF5S24XrzlWNbPswQ6to+lWOj+8Kb3nodYaMvoTh5Brzn25grqXTb893ul7teQlLxot2zacLdMTG+RTe+CLsMxe3r6C3dD+TNbbr2zOfHAWcEKoSux0ICilfvgeeUqUU1khlqRxQSpgSh+FLDQ490hX60T0osPbs0NJiZuc6TCbglv1aPhuL5whF+A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:40=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> When populating a VMA range via the aptly named populate_vma_page_range()
> an unreadable VMA will always eventually fail with -EFAULT.
>
> That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is no=
t.
>
> All user mappings always have VMA_MAYREAD_BIT set, so this check only
> impacts kernel mappings.
>
> It is implemented specifically to disallow population of uprobes XOL
> mappings which are exec-only.
>
> A nasty interaction with these mappings may occur if they are mlocked, so
> actively disallow this early.
>
> This allows a subsequent commit to remove the VM_IO check in
> __mm_populate() which otherwise requires non-MMIO mappings to be wrongly
> flagged simply as a workaround.
>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  mm/gup.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index c2dfcb4744bc..e6310a7cc05b 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1836,6 +1836,10 @@ long populate_vma_page_range(struct vm_area_struct=
 *vma,
>         if (!vma_is_accessible(vma))
>                 return -EFAULT;
>
> +       /* Unreadable VMAs also cannot be faulted in. */
> +       if (!vma_test(vma, VMA_MAYREAD_BIT))
> +               return -EFAULT;
> +
>         gup_flags =3D FOLL_TOUCH;
>         /*
>          * We want to touch writable mappings with a write fault in order
>
> --
> 2.55.0
>

