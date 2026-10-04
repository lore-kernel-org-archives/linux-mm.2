Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F421CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 18:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C08D6B0098; Sun,  4 Oct 2026 14:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7711B6B0099; Sun,  4 Oct 2026 14:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638EB6B009B; Sun,  4 Oct 2026 14:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4A06B0098
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 14:39:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE51214070A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:39:23 +0000 (UTC)
X-FDA: 85285806606.15.6B08712
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id D3AC98000A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:39:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RQm6geG0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791139161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSC0w1neootLkbih9TUxoXkKPCkBI7t1n5ZaTzyKsnU=;
	b=OT4q7ivHYkC3fxoLo6WlzNbVkW+ZWDbHXLViTVFNPTeI3BBCkFmzP2ihDQscxWccL7xPbj
	9DBLgK2CqNzjTYurRbtllMpAhfGgzygz/jjdTgX30uZKr53WFatCZUymGZxhQhQqSkl9QN
	wc8Tp0Mfm0snzQcctszstiMWrWNe5so=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RQm6geG0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791139161;
	b=QAoG81sOQpvg6oI+7BaIPBT1sM4yS5OWmuynt+99J1xhI7Wnr2yZXIrvZcNANaF7WH7bw2
	I/jF4LhrxxKKcsmjv+7NyhXDRqmytVHHUN0nY9skNHpPdmBn/uT1CBGTJrDjWCzIWwHIow
	LKeL5ybCApqyTBW/NE9p8MEGCfJ36SU=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5337c7b9937so265871cf.0
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 11:39:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791139161; cv=none;
        d=google.com; s=arc-20260327;
        b=eMkS666I5X0gCfmLO5lCU6grSt3WFx21dxnqGKKPbrAcE36nv5tuo16MAUKtKqfg3o
         rRj1tJMatCti644Fu+U6V+9+nSL7LXRZtFGWSt/i7NF9vKHOF9R8+aFXcQzn1mHEe4Et
         VaBKjg6aIVFFpu4NEnaCCtKN0HuoAK03KfxMrKhOPxXyQD6SDp2yzxknXtim3V8E6eZl
         yb8RUAACnDZPk3Di0dmffKns6P38GhXJ2AN8S36zx5Je1nsR4TodJmML6YNi3J8XugCk
         AVDFCyfXQIkpem+2wYhycKAMdJzlsq3zczZMXNhGBwFENc1pa8LZnas9+P05yCq8+JNT
         09nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZSC0w1neootLkbih9TUxoXkKPCkBI7t1n5ZaTzyKsnU=;
        fh=BBDZ5Z1lO5ljlsDvDSE4cMjeQ34FIbRXd0D2Njp3GKw=;
        b=HNd/p+d9iQk8aEsXlv7s5aLPOKu1BWeKQFgYpweSuW8+7JLgC8EyYW0PoD25VSbMqm
         WN4WcNnNOPzHn57Zmm0dP0eJ1sa8bEW2RwZKoLx5DoPA09y6kmwVOiS/Q+CGtgE11Qs2
         +H2N19qVYUK6I5dtk+pUos/Z0zllI47DY0dcx5YAOESWAU6K+p/QM25IrIGQ6847/s1b
         NWMCCL2QSQpaqjktfsTSUGyLerE26W5agE61l98n+DIj7PX6dOmsOv2y5bWsl/vSTZU2
         diHldwLih+H95vLgrqI5NusN2+QI6UrrZw4okSTz9b/3heJ9mNrPWfMwXyoIVbg1jYSh
         3VUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791139161; x=1791743961; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZSC0w1neootLkbih9TUxoXkKPCkBI7t1n5ZaTzyKsnU=;
        b=RQm6geG0ihtfSKGLzBc2ghb2FpUlwIZFh4gv8Iyn4kp5IdFyS2xKq/rcnOEGbsh3ox
         swy1KuQCnyrt3Hot07Io3gk/yBCUftMYPQyIIwRS057S8OGFHWwcI1HPMchDuGEczZNh
         2gWytkOwJ91FRe05YsTh2L7UL4LGbDtSi3tTWE41w5e0j0DMyT4cBcbh81PCRXDIhxf8
         8QmvkhnHWlIShr/gnhsLC/zS+Y5WyOxyhOtG1tQFXGvNyjhXHdMdvFDkwXObS5G0Bg2g
         p+DXFTaahICdpOtAeXkiqBNX20ADv/RTwW7g4xBTdGS2PiolkAfdcAuQGlsQUHTUBuo5
         vIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791139161; x=1791743961;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZSC0w1neootLkbih9TUxoXkKPCkBI7t1n5ZaTzyKsnU=;
        b=ijngW0mvdd5+qCtEgdkIFLVG/2C+pTMhD3Xl8y9HITtSSeXNDbZGw2k1YOgF+DOJg2
         texGu7NVv8hvjPGGH7xhmuptwj0fae/IJTVYnWE+KS5oC4C0VelSEqF4QhSS7xl5taRX
         lJXj8+vpUhaJwy1aaTYrQdl6ozzdOu85dIBCCTHkAIaJ+tDbdCD2GTCYuzSgTxtqDQVB
         aA2zaZJGk8s23YpgIuW5yNjCvENSYJ7seh5VoidrzOk7pSbOFwxelLai3E0OYUTOhjD4
         31+GjQbLin14Yi1EcVwj/OZrrwSay5mExAyvUmMgjkqyWWaEU/ZQ/0LAZ/3VOMi6LTbU
         rqlA==
X-Forwarded-Encrypted: i=1; AKwUvBxm+CHN3G4tx5KGcnvLpAjcSduDzGB4QpDf7KPiQ1e5d3qLofIw8BDMmcLmFAshWr71X9+UksyGVA==@kvack.org
X-Gm-Message-State: AFuF++lEVgIpMsxJMh799yeu8E6sgqvWsAA/pzrR5eKpRhBiLwZ1MUOa
	u0f7TC+ajDF0ieaOtMLmFKMFjNDsVrY/W4Nx1HrdnpA5UY9JRLMuRmOblO8RnpYqK1+zxYILEjO
	Q+TXe2EYQ790MtJSEar6uwrJjPMfzYZNt51r51GiA
X-Gm-Gg: AYBFou1uookXKJAoQSQcBsx7HEk8WU7yel9kehFAXrwIoXLJYnhdTIPVkTVKEnAXH8f
	f/nha8bpFTZhIpFnp69/Q/G0ITBfCP4VBDYXCnm3o5vlYEmcPNE1yRFGZUl4QckGPy54nOf+9R7
	YuMx5hY3+1qtH+x9foNuEVWLWKXopeGeAliotLMOMCJFYR0tBM3YekLoZttHrc9DiEM3wVx8IJK
	4TTM4wJWGg/SdmZ3VGjwNp5U1XVB2oFlLhHnHVRBmXoJGkMNkVpmfT0h+vMw/kjvgiiZy9woYvy
	eqb6GJ1ERZmP1sOayTq4CNA9XHep0OhcQFec0JYxyh95UL76WwTzhaId
X-Received: by 2002:a05:622a:a16:b0:531:282:6560 with SMTP id
 d75a77b69052e-5351322e1b3mr19806961cf.15.1791139160071; Sun, 04 Oct 2026
 11:39:20 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-21-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-21-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 20:39:04 +0200
X-Gm-Features: AclHuK-BFFMO7RL_23L1uoIyefqTPzoxo4liaojYggefG4PLZrnFo0OrrSwhSqQ
Message-ID: <CAJuCfpGtyaqwi__OXcB=iy2+LUVzFnLo-Q=Rdxz728_EHdTaWA@mail.gmail.com>
Subject: Re: [PATCH v4 21/38] uprobes: remove VM_IO, set VM_MIXEDMAP for
 mapped kernel pages
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
X-Stat-Signature: 99e55hadyurkyih9ixf7sxofu4sp93ew
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D3AC98000A
X-HE-Tag: 1791139161-870286
X-HE-Meta: U2FsdGVkX19ifN3Qa9YoHp5PRYP5l05zSnDRq/Kc6pbMY/h5H5rAtkH4uFxeiXcU2FhhVNzSSdxG8kGhMI9OGfMRUjMFFglHW0UEi5ZAplT7h8MNE55wh11ijxRkjtrARRFEZMnyI+VuKFHKyJhaJsMfn2ebSO6pXbH+roZZk8BP3l+b7+lpsbuiF+zmPYvGDcqIRFAduLGgGD4x7r8zEPqKsocQj7Re6SsdGQt8fXq3f/Jzu7CMV52Z/mWdA2dT4gh85v9+OojijRB2g8V/ZBZvcxQiyEw5z+hWmQPa306FWaLva4Ph/E/siLWAxupZIvz3nWK4jhbDsToGW1c7PR1KJsPtIP/jKvQTDoPni6B/ciWoKVph1ZnNW64Npbts/TRZePHFddkwwKUqrC50q0/+XQeEYgswfcM/NSQeYmhcLTAQROBd3z427foPijw0QoUgC5gUNOd0ttuyq/MEXOc0g0zVqoAIjcrkzva/UhOrwoHxx1yrnyHF6dLIR/M6sLvNK5fAXSzewopFSWHjD7xY0yLntygeAvK6j1Gl7k5BhYxxz0NHSVHBJUsSYvs7YNO7NzTLVk+KJ/rHZbP3VQhidTC1Z4TzTt36t5q6xRvRHrIhIoR/MJ8jiqzMN9KzNQ9/OaCtPKpd65NqMQpuQm9cxNYKzTjBPx53Mgj2aMvEgx5eAYKsLKeWeXjxGqoBt53khpT5wXOzUY+/sRw8zeeMRFdIDTO8AWP5V0NphmM8OoGdHeaKG4qEiJ98rAAt5ZV0PoRXr3B+MWTeLXIZjavVo8t+Kry24w4o2JGedAjIzt1LUUzlLOKklrlMb5sr09NUOG5dA4dH1XU3XHQoiu9e9WaRydc6spJAlTcWdfOh17ZzE39UYLKZ2BN9kxAqRHlPmhefA5SuFBcDzJ+FdGGEE7e/+ny2VwOLJd1VSQHkWMzCNfiF4499e9MCGOr8sOz6NxG8C0YSmhxlcDp
 UJM6Sbwn
 mzTqwlXAWICQSxgOPEUH0g6KI36O+WwUIpxLg4X5Ddybwq3Ig7BMN/2JD34MsK+avciqnvnrRWXPWxGNzcqosRDAHsc4iYa8ekotWaJgQk5ow8T/e4R85CrBX2eL7wffpZd1ap4uHXlCnzBwpEgHSuOx23exxN1Oi9cIZFuZ0pw1HxII+4U9xeEFc9czXTaUBIdjU5iT2HMfOv5G9H0JxJhf55xQqxvmc3Z00J9aUahKWOsGHMlsp01UM6/5gV+TthFC+tyuSrgByuqRlqPAqMHUpawfp+sc7A19kGfP7fYeeFLyJrIcKx/KcZRUwtLvMBDLUY1qw78z0LSJUuG9BcFMnNhddPle/PvZShHMHFqKg4aTNN9/MEWgx1LRtzQoL4EfFCLL+RWsQcsy16N9k+z1lze5Rcw6aGuCyFAmRhWnjsLsobcDOfWCH2QR9x1kbjxFW6YIM4BgK13/ulXlQE7TNspFD+cjkvrahm+wo5kzSbNPkJzLIz0L5DZjpUZ8YgGIipyexox4KyGDu8+bKU/1QsBUam1lIIK2Qwxl95IoptR3v5YIVhoKX6EbLbL6ur6+fO7waJzi1X6rESkw5bEG9o1iOiCpGJab5fXIaSyLD9GJ51t+L+a1DRiorOu58D2obvD4exOkIPXyD7MdtYpVFGgYdqoSxkEx/t964C3cEXmgKcW9EQSJK3gKbQfc83JUIWaPJ87eY3rLZSq4RSzYj2b28ux2NXe07t5ZNbEgXcTvRYDoEcgjnY+kkEj6QQu+MN3AvZpCwG1SsyMEw662/8SLeHyCJcnJK2xT7gsbJGuVVBsmcneknY1p4wf+f3W8z6FbsoOJONgTwX5o/ladGgSPrR7JgyIw81SmqYcIWt9r3WBdI15dTlNKp9NK8cwbsftES8a5c4ovYrsq9dO5PhpDT0rWInlDAH16qP9QS9rr2Oan6hdFDOLNB0ho71y/2H8PTzntKSXCzcwFvtonUdOXf
 x/MFOGjL
 Ysi+4SgO9U7XjYlKADji9ZNZ1CTA99uc/02gpQC6ziwITRrLEP9qTRn++I3in14pQnWo4DLoQdiunU4nsn15gARq2kBtEXigxCrKJ6/OYhTvAwkejrDSZOQEALlxp2KNVHY2uxdrugTVgtzYHfAL+wAo9Sis5j3QrT2e9KwF0Y+6QvZawm3byo3t185dTqYAEhXQd2e0TVOA4GDqjMiST+1MVg0Ccm0M8l0Zz7gXpUt5OB3lVLQJgFrOL1BKC2vCtzOfqidun9KUhSYSLiJmfE0l+fFKzoMVKx1ORWmS4du/xm1Udszew/4IevUJj0dZ9eC+qnEDq9djQPLmgOmCf3QdM+eNcRpsnAAcmhpVTf48UExfRKnlAuCNN2ZMePrF4T02Ug6ul+EYByVEghM3Mty1sTHRzrKisO/2UFKNp+VslnQhhXe2vpkh5TWQf0c3Wia1KVuV2P+7axdWnNeJ+TD8WqwF7CsRF9UfyPBHOd3isubGCmzo0YKy4M898o9tHLjNo5TVvWBNx6I7ynYUw2uf069J+KGqxx1/LOTu/kR5YU3hc3g8ZN20dbZRGfmxfEqhNhmL88SxpXsr1Qk9/Xwh55vdmufj6OgDrnS368I+iiWdNlvZnMin9iJItykYLRnNl6dPpOZZZTZUGVY+tsrOjh05/9CGm6/RNFZ8jtwTwIc8P9dqn02ElmT+hDVbL7zzKDuiYoJLLwGFhwk42F2iT9NCIDBsG7MxNXjn12Ns+jpPcPIQC8o29ydo2cYI45UslpRDMZ2IpeNO04+DvkUFUyQv8fIo09Lx3GsgjdUOS5NvwBp21P8LrZE804so9frDCfZGOz9alkSl4o178sycSMVJ6vFh5MVLwVN3OiZ4zwu/lAPyIPq412JsxoxYVrQQxwAqxDWqWjp2MoevTXpFGXKFkJ4/8EsE7EG/znvFlIFM56BolMjfpeB18skoHgXP7LVYUtGcI5qiUnOU0W9QoBD1Y
 GpnbKCu7
 EVX/SZOBYSGTo3RtxChCPrBFJ9F+h3OORoBv1h8fjfhZAsqHtxLzQKrhjSJ4cIR0PNMRZy3VW/aUdFtylwDSWlt0VFpECGii6gmFz6ajI9Opvm5jlomMlscFEC/1xnktX3ogYkMD8PXjbIeMcgJj8s5l6+5RCWFaGZImKggGjAKsimFwjELxQHXcLsjN3n7O7FdOrQ3Fuzpde3+VXqlzfQgc7RcBA1/nS1+8iXO7I8qU8G2zJEasoRGNUrb5SfI+apzk76XhABUKOPxgiworpYtgQTE1HQb7EabGQo5IMu3eADYc/3Kq23B367/mK4PLFVmIQ94s7PpUQFQZh4L4agUhguxDOkA6iHGPC8rgjQg7QzBXcc+/+Xk6LX+4E7X8iXbQwfBz/JFP5VUJWaSmM9KZLQHyTm3AtlVddlbiWoPZkBF3fM3k7xk7aOEjUy0Y4Ilw9zaZgOGksAbwinJG6fFA7ENCjOAcftIMFr1TAiE9hjqrxLuUtpmSJvlGJje4FdzI+FUmaiq1e7oB16kaIYlAupr7z63tIBxFw5Tui4yMXixs8cSj4ctLFQyDBgj85L8nvyZdCJGAQe24IAMxUK0FK2crMzXZUnaLQr+XkRBuXOkylIaXvbVgwW9u+Ytbqtf8/DIpEH5SKfPyso8xoBbu7dIXdoqt7j3hnlx15urIhBy80T/7AvI+gX2omjO7VI/1vhqc6THknwOfu8mVY4mljteZgyB8TZ0eH82bmbUWebvtg+U4prIanZONKVxnMzD5a2MkgzuNc1qKNgZ0L9zp5M/BugaPHRKHa66gZkPvfnT612Rb4/0Y6SUr42UsYn1WquAPCSjwbNzz038oPN8f8ET3U1CWwZD72BCxiphuai3w4qyktYcKFBIYQB0SFTH1agsygYwf+567h5qnRBYL0/yeTPZz46DJW4gW76OAZlRSTaTyOf/LoKr8k2l1U0Xpfl/od8bfSBhIZrPfdezyA9sGv
 RsjjNler
 8pJuP/JwUMvHEc+R9qVlGgZvcVGDw8w6z07epkECHIyTiaXqT8vuKoXc6CMvASUdg6YUkGU1MntR9W6VCXUJj1vF2lnVEENoKaVeqI/ssXabYbgzqsoupZ7bOxSyAie9+XBSTR3kSnAfRB2cf3t7XUvTG0G7TBorkzMB1w4Xi2lILa70Yc5qmks/RepVvoNt1UUcq7j+epGDFmppknRCZTlHJJKZNRtzobfIZ/xBCW2/0u6cZhaXpiG2453RovQq9i05CLmX2KomuV7AqyPEP2upx2IWMm2i88Xdj1GSURPnlI8pBrbvME6k4ITYRyvObSkgFL/nG0p9ZSd/F3M8CGHzX26wkpymT5gE94dEevIZyZ2KETC/w2cgjdy6q2wi0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:40=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.
>
> Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this i=
s
> the appropriate flag to set for those.
>
> This provides the semantics required - no VMA merging is permitted, but
> does not prevent GUP.
>
> However this has no meaningful impact as these are refcounted and thus ca=
n
> be GUPed.
>
> A previous commit already prevented __mm_populate() from being invoked on
> XOL areas, which VMA_IO_BIT was previously relied upon to do, so that is =
no
> longer required.
>
> Both VMAs set a VMA name, so always_dump_vma() returns true before
> vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
> in core dump behaviour.
>
> Change this for both the core xol_add_vma() function and the x86-specific
> get_uprobe_trampoline() function.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  arch/x86/kernel/uprobes.c | 2 +-
>  kernel/events/uprobes.c   | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 65a2de82ecd2..0f60c0d076b6 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -715,7 +715,7 @@ static struct vm_area_struct *get_uprobe_trampoline(s=
truct mm_struct *mm, unsign
>
>         *new_mapping =3D true;
>         return _install_special_mapping(mm, vaddr, PAGE_SIZE,
> -                               VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_=
IO,
> +                               VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_=
MIXEDMAP,
>                                 &tramp_mapping);
>  }
>
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 7709ea882477..b89cc5cee002 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1726,8 +1726,8 @@ static int xol_add_vma(struct mm_struct *mm, struct=
 xol_area *area)
>         }
>
>         vma =3D _install_special_mapping(mm, area->vaddr, PAGE_SIZE,
> -                               VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|VM_IO|
> -                               VM_SEALED_SYSMAP,
> +                               VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|
> +                               VM_MIXEDMAP|VM_SEALED_SYSMAP,
>                                 &xol_mapping);
>         if (IS_ERR(vma)) {
>                 ret =3D PTR_ERR(vma);
>
> --
> 2.55.0
>

