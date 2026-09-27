Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 517B6C98338
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 21:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D83B16B0088; Sun, 27 Sep 2026 17:44:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34836B008A; Sun, 27 Sep 2026 17:44:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE476B008C; Sun, 27 Sep 2026 17:44:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C5F76B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 17:44:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6924AA6F40
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 21:44:33 +0000 (UTC)
X-FDA: 85260871626.19.75F0606
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7D317120007
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 21:44:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LP0ShdHX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790545471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y119z7sdl3qfjHiuF1t57ekDKg+i4BGISMvCcdxAaw0=;
	b=tPUC8Gi4qeJqrs3d3ty57rj6Gk2jd/9OGqf55Jb7ezs4xJh2jFkergHQbga7e/8y0u6yxa
	7qwd2SEGkuR8/S5LfJzvUNHVew6qCjhYwQN3ta+PEl+TVAT/FdUgHk0SX5VjbCNAYIVqub
	OjWa6GgcPkOYIYK4tn79Kb/pwf5fWqY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LP0ShdHX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790545471;
	b=SmRacYcJ4q2B+oczoZVPorhtWDzDDtJQMJvtsC2XEBxrochAe6RnFbdBXKJerlDCh1aiBv
	xpoY9Qwm+qusU7IWg52msuZ+PVkN576vCfBIkkGlxxldL1X3AgcwZvODVArArtCrXWYUvL
	cWFGRVpKa9IxdYntNRAIXc/VRBX4LFY=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-53113d72966so243021cf.1
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 14:44:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790545470; cv=none;
        d=google.com; s=arc-20260327;
        b=javsmZwVDiXepF6f96E2ExMhCAHW75lkD6+MSzvnEVGD/dxoDJP7ItkeQ4EFeQONIN
         M1E01RZ1nPT2H9jzdyyGimOSR08gAN5pV5yEfSXUNqGJdXO/eXjrdUI88dGJsnlVxAbV
         Pykk91pdWnlgEnL+R8RRLqX1vnl41Ik3nLb/OYd151grwU915mjwh/+YdWhuopucQMd7
         ExleGEzAwqfXsI5fig0c9M1EwkPUikFhdUp6iQvLVKyynGNMYrYBcY/B1oSaChF2cWMz
         JYmBR5zv8Za/u/p3IM2k0sd3q9QSsK4A9OiCOtcwySKmahZVoyy7/sxNF2+P7DWN7qIz
         5p9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y119z7sdl3qfjHiuF1t57ekDKg+i4BGISMvCcdxAaw0=;
        fh=/gkjx/9SFGMSlNbrc8kc/ig4dCM/KzQjdewObcoIfD8=;
        b=ru4LynVa/t1ZAelcbQATc3TfDI6aCDKtMhWAVkqengVFRmQZT1rek14XWQUKcXQWQp
         2ImGik88lSPsLxaKkIVJO736y/N6kxRBrEw3TO54xCwzKrXligpILLyVSjokgZCZ7b+u
         4BwXqGpPCutGGYVCLY0Y612ZlUWhgDT9MfTKNEKcXZl7Gw353K9YakLdZQE1dCb0hb1f
         Y4D7HGqZ9LNGgrymTjgJKA6QQ46/kONWiAU2r6wMKSw0oOaUGBorXyQ1gFThOts8gBew
         i7IDUrfgdRUDwoKJLT1/fnswXdf6IiW/DH05BgrRBq3EmsEMlv7DiZeK5L6SuX0XiZYV
         aOCQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790545470; x=1791150270; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y119z7sdl3qfjHiuF1t57ekDKg+i4BGISMvCcdxAaw0=;
        b=LP0ShdHXZT8tlmXpmCJPiPoIWfSv20hT93fscynDH+dYssm8xjqG5YDz8zB+9Nqkj4
         Qjj4+MAIwfgZfMOv2b83bZfzTTXFY9TL3HWf4my4OdzMol60DovQmyU8X/WbFC4gIwnD
         xeiO8t7hhVlFZ1DVLYlOdTYtf+rtIVh0mrPc58R/UP7kdvZ0HDpJ8ZXOlOHrrx4PvKqZ
         +6A+SCkffjpPvy3T5BwiwWBAlSeZubLXpT6E/z6Q9jYVMmR0X0w5aSov+d/qHmvAU2G5
         tEBoGCBa5C6FsrfhkQd3AheeSYLG6EI+tF8XEUYGGEBa/+xa482E45Fnz1ZfYyaFu+y0
         GPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790545470; x=1791150270;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y119z7sdl3qfjHiuF1t57ekDKg+i4BGISMvCcdxAaw0=;
        b=NdRpPmz8WzIjQxqOMajLE6H62OHKAnqLP53vwOQdLFY5S905uOs4MoreheVpe3cgcv
         2xd8ypN0R2MFHpAEDIjBH+IZwHWkwRlBf83e6B/JUYcamMz06/XHZ8QKH9aW+Bhi4hN/
         aZZjFlodMzZ7/71xZZ5+lmqXmcyjHpkJsbtR32rfoY/mB89Nv2JgPY0b3MkU3EFCoWnc
         aQrXd7IC8cF3VTTlLUrPLmk0UwOCa5b/qkPPcrm467oj06O6MKQLJelyryZTm+YfkzlX
         YKeK2NMuCjxtNyN8g/ZSECKKVV3Wa+yFx2Rfo3Y6GmyoJ7TYlSP+JtuPxbFiwv1zD5hZ
         +JJw==
X-Forwarded-Encrypted: i=1; AKwUvBxdH0GkyOf/RY02M66hi3dPewdPqwH6/VYeNx6tsgpAhsWhdB+rCj/t3fIQ5VJFJ2mkRgubXxa3Rw==@kvack.org
X-Gm-Message-State: AFuF++k0M98txPQRJCZ1YGkhVSeXBmKS7r6NiwB4YrzvkkgYcKzNsFtj
	BQB6tA9Zoum67sMDqdtB0q3SZh4DxiRgfNABTdSKl9jEPmBiwEQQLAVU863QtKqyDuYzTDFf9rQ
	kXVkZmhSvzYb6JmEpedNx/s0Ge3ZSw80w1c1avL2k
X-Gm-Gg: AYBFou12zW3VtyHyK5YBVgDxeQ4o65BCNrMYBa5B/5YH77poc6YwhxmSjgYbZJa/L2a
	2A9BxZdOS0Da2atkPUul6E8arFDOwMfsv4NwZ7tPEvWGG4gUOrHU03vrSfqis8HwOCTeiZ6btxF
	4qijoSpOLxtaZy3ObNQUrZVmUjmOjiDwpALH0hmHV9OC4b1Kegu7TXSeumFZk5z+sFGnEj8SVP0
	N7+wFe3NdLhfUi61DZiIGaeYBX4X9OVdPRWjPahZ5jzDO9dI15ZHlYx8/e4eePwrN5FCojB8LFc
	8Re9X/bOYQgFTojk1tT53K+vbyDtXUQmpC9iMi0TiwiPQUahEgiCNA==
X-Received: by 2002:ac8:6104:0:b0:530:e00f:7768 with SMTP id
 d75a77b69052e-5331fed98dfmr23915841cf.0.1790545469472; Sun, 27 Sep 2026
 14:44:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-8-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-8-4583d8a23bca@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 27 Sep 2026 14:44:18 -0700
X-Gm-Features: AclHuK-2F2ckU1C-yxhObu0QhsQKrsVKTug_h-Hi9fsC16ALl2HO1fuDhZLvMkI
Message-ID: <CAJuCfpEawD2NUO9EoqKnR6YR59XMdYrtUrj8KEwJVwO8AOk8Lw@mail.gmail.com>
Subject: Re: [PATCH v3 08/40] mm: add mmap action for discontiguous kernel
 page mapping
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
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, 
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
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
X-Stat-Signature: s8hoeysrenrs6jnkyxmewzwiih9fyyq3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7D317120007
X-HE-Tag: 1790545471-14504
X-HE-Meta: U2FsdGVkX19IdAVO4Lsl9ltWfuiDSYCnxefpDblEHrf60V3e3Ct7hOtyk92hdujn+fV0bSjdseNqRD8dkdgDp8DAGC20LP7Tyvsx51jAvNZrczBnnn0B9jiNFhk3aPWCttp6dlnv46jkwWcB/CWCVFbXx5/aS6IXTA51JQPvKPG16A90xaup85OJSIBX7eeEoDjfLy33yi+8IZRdjgA3/CL6lmG9Z8WLQp0hUIMc7mDgAILjPbSXRnp+Qz622eYpWE5TboskGUOYE2Vc4k1RTgQkWBGwkT+hgQK/QNcvnqC56o8Y/7FgyoRG8g9kwHi8Z3ygbyV7upKAMvdSfYlvpTLPPhaw7uUpsTk/Ey6TDX6OzQS9a5vGz8LxVUSP1KzfbsKUU8Lt6ZRONmhW0FS4+WvhfJOisXuf2XskL24jB75oxjTmOSL/ztenMArQ9ELLLj34APuVOobpRVs+dIvWqZ5BsAqh05GcahfZPpLqYwPVXtLkhmGdsfUhnzVgqUZxu0U0MIEXBlX8kCqAafQh5CXtGfEZ107HqdeT/Q+gsy1kodWJdiVA5mw3UVFDtq3C28VvdqoUvGwgFanW5WsUKTb1WFaF86p2S7d98Ew2qoAc3h+iSZ2SZgOUIrJOkTSKAiYKXajPV8L+zZeSha595qrsI7IkijCj1nP9ZJKL0q/9qRE7HKnOYWaKEYnn1vt1V3z3HILi9kqUXol9wuxnd4A3d2eMn5jrwhFPJCdtOVcMlUpE0wMMsfhuRwEcNMDlY5PyGZitFL7r7rhxcIr/GKveqpz6gRHwP2688EofZQSANwM7C3u4/Fy/KoE+qh0/2WRRnGIbq1AIOs8BeQCw7xdzMuuVIGsEQZzAq8sSG2zPa2nUs1kQCkfMSWYKNsVxVSB+TmC8oucxGv103Mb6Rrlo5CJPYEJ/4BGvmY+g1bzM8xjO1MZGZTGwtZXabUVmE9qCy9ts0M7ECKbcGUn
 vz4DUcKT
 s4CVYsjMP9nKXHDrtxvEjM62EASrcfiLw7S6eSouBWgncOsynZ9wcemlWLNsPYibWzaHswC7eFTEQTCh1FG/0awmGFuxr/6RyGIxoiP39OrO6hRKWyoF3OXHFkJWR/Vsi/lTGAZeYKM4aYRUrvQMyizxoXh1a0rZTgDIQZfT2IJWLs74ZPVNRwjBqx2Atjq98YFiO8ZZGC5Pr75hC4Y1L11YZMBqFgoe8TE6XNfC+pzPs/mF81o0WLfKb+luUUw8Q4Q+NM+kydgrVJJcZFGq/H2Vmvail7AiO27l8SsHdFPFROsiovNBwDnoEbnYmQXP1U9ZVziCHm3qrwdsbZimdgED5swZmxU/q5ZqaTapwSnzwcIDNUWIDScF4e1EfX0qcOLWgOrlQJ4SlZLXm1sOycpSvzxWngnIKmddCwdx8qNwKk0hw8mn4m96dPhrNNutqOYDl4Kbp62ovV9p0g3EA7uGDtIq65KB9g2fDNNy4wSF4RdyEO/TpiaXSCq04bdHppWn+uVg/wXRoG4JpHXsok+VDDvXIso5BmlUg9TND9VVoj9NvL3l/nxY+LQnCtDRiQjxenr5a7ndcn2XtRQaSboxiMXbphhjf919vX/GRgcah2weH58yzSva/oSDPZxSJYNHW0JD6xW3cE0OBuodiQy5FnIq2hbY++OShqt5iARDMXbfXmGej4tw8It+xpxz0i1MbM8o1REcD42mlmxssosAs1v5IMxdE2nfMo3NSLHbPJLkCROVCLNySaFYA9DTMVxVdlHgl06QVhfpgCTipbQeDbCS7F6ImPLow3zzB/0EHWlId1+PltM0fIE5B9vh/KchVBLAbn93D1JL+MqpnsBw0y1t7KcDrV2rkJg1TEfAEO8emRPdCxmSxoVGYtmp8LFSxs2nY7esQgwlQ0cMXGKp0fU3rh8vxvY0PQkcciGkAefPt6npbksaNsNLc3HJ+QbjeM/gZqCBpAWFzv7SC4LBhWEWj
 /HBdrZAV
 lqi79C3ZItDLTJqgfFbGwnsYENJPzwYq9BXSevtspyO0nKLLzWyNFE8rCYP9qYM+u9E0yT2nDdjvUhVEvRLnD2szZujf8k9FIscacJh5xgVWdLfK4RYclpJynSrR9d+A2g2x8iNu49kXTTfW84bX+oZoAC8qrnGGi+EnkDXtZgzS3KFnq2DEFgY88hd79ebrDQVOY5HtCKJXLQ+9H3uDg4QlXBv1mIhxdFMKk4y83DqCICMuG0WH3Y3CqG4XbksFoQrClAL7kTvdO7FRVPgGwhxfKPjeNKT99xluMJ4H1pWUig6yeT2qkRj83xp/N2Lst5v5lCFw3iBhuxaQ3vkKv5xAIT9/PFu9ahOimK2rqk7UOx9niARDUBkwurzyLV1zN8htfBb0gv4UsFhgVMBZguVmzbvAjZYFqLcgTvD2XIV/2qYf7g6+qIY5jA1YIAUTeW6khnRd6IRxcz5HVOyNiNZfATUHVnWCQT+k6q+jYYm/ziGT184GfH1Pnqy+EV3S09yDNKgAERYjWpEkguRg3mZ7CgxSNYjj8QMF0Wc//DnSFCdGubcwknsqNRM1/9RQdhNdbuzNRGYCV29X5HDd4INGap8KX9V5noTgDf2DjLLu5RJyLnreuve4MSAWN1OO6VHXorhW6PdrZ9EyLaUEi17eACuCd27Q6NePFiVwA95Xww2ooDYnv/3JdA8lDs5+E7jH3QxWwl5L9x+WuSQyCePAfk+B0ED0sFFWrBAgyH3VYmYhnbptM3/E47rGEZvnWR0rb6m2+PHAtfMlBNSAkriAgcvxr7MdqXTyZ+/ElV5N+UGVvo2Am6g39rmheGWPhlojxy97NJ8a84L+U5nS3nrIPUSqaEW7ysWofiR7zYp8dkDq2WYtqIlDO1QUobDIEEs6vhN6kOor4NV1j3NgvR1MGGy8CtFwpEIMMZ9zM1DQ+lYu+ppCiW1JJoQewZeGJxdaUNgUwRVXWzK/m/RE01W9G38lt
 HCTTFfVu
 RhoRwGxyhyGH7zrHa5x5S2+aUsw8HL40GAM47acUggV6VDU8G9oeA3ROqT+Czn6W7haY+isH9MlXSDzVv4mvdoJqyls649jM7OSnbuohs4Lh3DjouJyhCc8fcwmMmKTcCAEzMkgr/okrytcmJZ55lq74UoGAzX9A9fTnp02lMPvHSDHrwTNBrBlRma7SSF94Hxj3mRuOqCIJF8fkais0Ux3/3WXPXNKRpC6Koln4Fm2JX1u9cw3nRlvYGMAlh22ae+qx7EoPX4xpgVVgnhtsxqXWnSIgyp64nF/RyNIUMNbItIz5RGuIhHSYme1GA2JZIJCYrQa3KPd8kMPWcOuOfJQ59SWUO8apvjW2ggQpOB7a1h3YpJRWQeCiNQPA26unaWU04yqFsIbt42OFGIlUvNKlNYUY57us4OKR+gy+wdSc2W2NaIcEDDcA1HSrn59AWY81fX/h/P8AIeyRaRwQG99HzuNSNMwOPtDKB6qfIRPMAvsYpyMvRuh7mrd39e4DLJv9RLPjOt2jSPfhIyLklalgNJUJ1u7k6RUmlH3GhtlPBuVdsfQT7uAbLCEIv68QrXPeu7DNnnOykphVEPC0XLGCu2JnNI8kdGbEWN0kiCxwM1RysucOkgML8b9lBibjq4K2BD9YdHiWNEPsmLrJvPwJooSpVr0DnNGINyHe574dC1rlsdh+AbXHwu6ovaRKKuxWFDgy6H24e/B0ZvjmckcwQi6672jbcPgwYxCGQrbmm8IrDXglcp15pPaPaJ9MLtk4d12gWMOOuN23cfg96Y7nbYAzIrVtPfzf4qi03Dp8s48b/aZ8Holzi0OfTCfhjMCxBX4Ka2xBxXwcCrVNNuazy5yUvnsAHuvuIwz8HsYVAPu5jl1SMV6ZMW68DFjUk9cBgrS9LKAfcCmY9SVb/SYxy1ucJGqOFjrFob7Y5LQ7kD/W1tOG49YBdO9XWuMHNdl1nbhhVno7XDavz+/6wyeUHrTQx
 n3KUaNIR
 u8GzBkJ4Nm5Siee2mjUBNv9QrBC+gi+BtlHE7hOZ1c1vn1aYSAm1Gf2j475ZIAMlfxiBmgeecEK00cYKjD0WfX2Ad5sZkWdDwr4SspbX2QbuznXdkO7ibtV55HlkXLw9wzYS7QoIyff+NYC8wU/XM3imzwmu2gx4sEfxz3Qy7sYPcifOs/+1MUqf3Gpi8K4h6KmhbGpdV1Onl1n2dXK1v7t2X0XiXeV8M1vwxWu4zSgSTiLiUzmKiRYBftx8TT+Re0L831qqBmk4H+BHUOa33X0vbW4EQQXqvZ1/wH7swvzcAACTEtHTOM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 9:27=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> The existing kernel page mapping mmap actions allow for partial and full
> mapping of an array of struct page pointers.
>
> However some drivers require the mapping of discontiguous ranges. Permit
> this by providing discontig_kernel_page_ops which allows a driver to
> specify how the operation should begin and how batches of pages should be
> retrieved.
>
> It uses the minimum exposed interface to do so, providing address, page
> offset and both vm_private_data state and a local private state object.
>
> ops->init can establish state for the operation, and ops->get outputs the
> pages to map and their count. Should an error arise the core unmaps the
> VMA, invoking vm_ops->close, which is therefore where any state establish=
ed
> by ops->init is released.
>
> Batches may not exceed the VMA, but may map less than its full range in
> case the driver wishes to allow the user to map an area larger than the
> available data.
>
> To use it, users invoke mmap_action_map_discontig_kernel_pages() with
> initial local private state and a set of operations.
>
> Users can then use one of the provided helper functions to perform an
> action:
>
> * discontig_kernel_map_abort() - Abort and leave the mapping as it has
>   been accumulated so far.
> * discontig_kernel_map_page() - Map a single page, or a compound page giv=
en
>   its head page.
> * discontig_kernel_map_page_range() - Maps a struct page ** array of a
>   specified count.
>
> The userland VMA tests are updated accordingly.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              |  45 +++++++++++++++++
>  include/linux/mm_types.h        |  44 +++++++++++++++-
>  mm/internal.h                   |   3 ++
>  mm/memory.c                     | 108 ++++++++++++++++++++++++++++++++++=
++++--
>  mm/util.c                       |   7 +++
>  tools/testing/vma/include/dup.h |  11 +++-
>  6 files changed, 209 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a1f2d375cf7d..2a92193ac6a5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4647,10 +4647,55 @@ static inline void mmap_action_map_kernel_pages_f=
ull(struct vm_area_desc *desc,
>                                      vma_desc_pages(desc));
>  }
>
> +static inline
> +void mmap_action_map_discontig_kernel_pages(struct vm_area_desc *desc,
> +               void *init_private, const struct discontig_kernel_page_op=
s *ops)
> +{
> +       struct mmap_action *action =3D &desc->action;
> +
> +       action->type =3D MMAP_DISCONTIG_KERNEL_PAGES;
> +       action->map_kernel_discontig.init_private =3D init_private;
> +       action->map_kernel_discontig.ops =3D ops;
> +}
> +
>  int mmap_action_prepare(struct vm_area_desc *desc);
>  int mmap_action_complete(struct vm_area_struct *vma,
>                          struct mmap_action *action, bool is_compat);
>
> +static inline void
> +discontig_kernel_map_abort(struct discontig_kernel_page_state *state)
> +{
> +       state->action =3D DISCONTIG_KERNEL_PAGE_ABORT;
> +}
> +
> +static inline void
> +discontig_kernel_map_page(struct discontig_kernel_page_state *state,
> +                         struct page *page)
> +{
> +       struct folio *folio =3D page_folio(page);
> +
> +       if (folio_test_large(folio)) {
> +               VM_WARN_ON_ONCE(page !=3D folio_page(folio, 0));
> +               state->action =3D DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE=
;
> +               state->__folio =3D folio;
> +               state->__nr_pages =3D min(state->nr_pages_remain,
> +                                       folio_nr_pages(folio));
> +       } else {
> +               state->action =3D DISCONTIG_KERNEL_PAGE_MAP_PAGE;
> +               state->__page =3D page;
> +               state->__nr_pages =3D 1;
> +       }
> +}
> +
> +static inline void
> +discontig_kernel_map_page_range(struct discontig_kernel_page_state *stat=
e,
> +                               struct page **page_arr, unsigned long nr_=
pages)
> +{
> +       state->action =3D DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE;
> +       state->__page_arr =3D page_arr;
> +       state->__nr_pages =3D nr_pages;

Shouldn't we cap state->__nr_pages at state->nr_pages_remain like you
do in discontig_kernel_map_page()?

> +}
> +
>  /* Look up the first VMA which exactly match the interval vm_start ... v=
m_end */
>  static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm=
,
>                                 unsigned long vm_start, unsigned long vm_=
end)
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 9ca2ea3664bc..0cb4f9603956 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -818,8 +818,44 @@ enum mmap_action_type {
>         MMAP_NOTHING,
>         MMAP_REMAP_PFN,
>         MMAP_IO_REMAP_PFN,
> -       MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> -       MMAP_KERNEL_PAGES,      /* Map kernel page range from array. */
> +       MMAP_SIMPLE_IO_REMAP,           /* I/O remap with guardrails. */
> +       MMAP_KERNEL_PAGES,              /* Map kernel page range from arr=
ay. */
> +       MMAP_DISCONTIG_KERNEL_PAGES,    /* Map kernel discontig page rang=
e. */
> +};
> +
> +enum discontig_kernel_page_action {
> +       DISCONTIG_KERNEL_PAGE_ABORT,
> +       DISCONTIG_KERNEL_PAGE_MAP_PAGE,
> +       DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE,
> +       DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE,
> +};
> +
> +struct discontig_kernel_page_state {
> +       /* Map state. */
> +       const unsigned long start;      /* Start address of VMA. */
> +       const unsigned long end;        /* End address of VMA. */
> +       unsigned long addr;             /* The current address to be mapp=
ed. */
> +       pgoff_t pgoff;                  /* The current pgoff to be mapped=
. */
> +       unsigned long nr_pages_mapped;  /* The number of pages mapped. */
> +       unsigned long nr_pages_remain;  /* The number of pages remaining.=
 */
> +
> +       /* User-defined state. */
> +       void *vm_private_data;          /* VMA private data. */
> +       void *private;                  /* Mapping private data. */
> +
> +       /* Users should not touch these, use discontig_kernel_map_*() hel=
pers. */
> +       enum discontig_kernel_page_action action;
> +       union {
> +               struct page *__page;
> +               struct folio *__folio;
> +               struct page **__page_arr;
> +       };
> +       unsigned long __nr_pages;
> +};
> +
> +struct discontig_kernel_page_ops {
> +       int (*init)(void *vm_private_data, void **private);
> +       int (*get)(struct discontig_kernel_page_state *state);
>  };
>
>  /*
> @@ -844,6 +880,10 @@ struct mmap_action {
>                         unsigned long nr_pages;
>                         pgoff_t pgoff;
>                 } map_kernel;
> +               struct {
> +                       void *init_private;
> +                       const struct discontig_kernel_page_ops *ops;
> +               } map_kernel_discontig;
>         };
>         enum mmap_action_type type;
>
> diff --git a/mm/internal.h b/mm/internal.h
> index c767007c2187..b81fce5fe510 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1516,6 +1516,9 @@ int simple_ioremap_prepare(struct vm_area_desc *des=
c);
>  int map_kernel_pages_prepare(struct vm_area_desc *desc);
>  int map_kernel_pages_complete(struct vm_area_struct *vma,
>                               struct mmap_action *action);
> +int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc);
> +int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
> +                                       struct mmap_action *action);
>
>  static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
>  {
> diff --git a/mm/memory.c b/mm/memory.c
> index 448342883e9d..45b21bb04a18 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2609,17 +2609,23 @@ int vm_insert_pages(struct vm_area_struct *vma, u=
nsigned long addr,
>  }
>  EXPORT_SYMBOL(vm_insert_pages);
>
> +static void __map_kernel_pages_prepare(struct vm_area_desc *desc)
> +{
> +       if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
> +               return;
> +
> +       VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
> +       VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> +       vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> +}
> +
>  int map_kernel_pages_prepare(struct vm_area_desc *desc)
>  {
>         const struct mmap_action *action =3D &desc->action;
>         const unsigned long addr =3D action->map_kernel.start;
>         unsigned long nr_pages, end;
>
> -       if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
> -               VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
> -               VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> -               vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> -       }
> +       __map_kernel_pages_prepare(desc);
>
>         nr_pages =3D action->map_kernel.nr_pages;
>         end =3D addr + PAGE_SIZE * nr_pages;
> @@ -2640,6 +2646,98 @@ int map_kernel_pages_complete(struct vm_area_struc=
t *vma,
>                             &nr_pages, vma->vm_page_prot);
>  }
>
> +int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc)
> +{
> +       const struct mmap_action *action =3D &desc->action;
> +       const struct discontig_kernel_page_ops *ops =3D
> +               action->map_kernel_discontig.ops;
> +
> +       /* At minimum need to be able to get pages. */
> +       if (WARN_ON_ONCE(!ops || !ops->get))
> +               return -EINVAL;
> +
> +       __map_kernel_pages_prepare(desc);
> +       return 0;
> +}
> +
> +static int apply_discontig_action(struct vm_area_struct *vma,
> +                                 struct discontig_kernel_page_state *sta=
te)
> +{
> +       unsigned long nr_pages =3D state->__nr_pages;
> +       unsigned long addr =3D state->addr;
> +       unsigned long i;
> +
> +       if (state->action =3D=3D DISCONTIG_KERNEL_PAGE_MAP_PAGE)
> +               return insert_page(vma, addr, state->__page,
> +                                  vma->vm_page_prot, /*mkwrite=3D*/false=
);
> +       if (state->action =3D=3D DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE)
> +               return insert_pages(vma, addr, state->__page_arr,
> +                                   &nr_pages, vma->vm_page_prot);
> +
> +       /* Compound folio - have to iterate through each page. */
> +       for (i =3D 0; i < nr_pages; i++, addr +=3D PAGE_SIZE) {
> +               struct page *page =3D folio_page(state->__folio, i);
> +               int err;
> +
> +               err =3D insert_page(vma, addr, page, vma->vm_page_prot,
> +                                 /*mkwrite=3D*/false);
> +               if (err)
> +                       return err;
> +       }
> +       return 0;
> +}
> +
> +int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
> +                                       struct mmap_action *action)
> +{
> +       const struct discontig_kernel_page_ops *ops =3D
> +               action->map_kernel_discontig.ops;
> +       struct discontig_kernel_page_state state =3D {
> +               .start =3D vma->vm_start,
> +               .end =3D vma->vm_end,
> +               .addr =3D vma->vm_start,
> +               .pgoff =3D vma->vm_pgoff,
> +               .nr_pages_mapped =3D 0,
> +               .nr_pages_remain =3D vma_pages(vma),
> +               .vm_private_data =3D vma->vm_private_data,
> +               .private =3D action->map_kernel_discontig.init_private,
> +       };
> +       int err =3D 0;
> +
> +       if (ops->init)
> +               err =3D ops->init(vma->vm_private_data, &state.private);
> +       if (err)
> +               return err;
> +
> +       do {
> +               unsigned long end, pgoff_end;
> +               unsigned long nr_pages;
> +
> +               /* Default to abort. */
> +               state.action =3D DISCONTIG_KERNEL_PAGE_ABORT;
> +               err =3D ops->get(&state);
> +               if (err || state.action =3D=3D DISCONTIG_KERNEL_PAGE_ABOR=
T)
> +                       return err;
> +               nr_pages =3D state.__nr_pages;
> +
> +               if (!nr_pages || nr_pages > state.nr_pages_remain)
> +                       return -EINVAL;
> +               end =3D state.addr + PAGE_SIZE * nr_pages;
> +               pgoff_end =3D state.pgoff + nr_pages;
> +
> +               err =3D apply_discontig_action(vma, &state);
> +               if (err)
> +                       return err;
> +
> +               state.addr =3D end;
> +               state.pgoff =3D pgoff_end;
> +               state.nr_pages_mapped +=3D nr_pages;
> +               state.nr_pages_remain -=3D nr_pages;
> +       } while (state.addr < vma->vm_end);
> +
> +       return 0;
> +}
> +
>  /**
>   * vm_insert_page - insert single page into user vma
>   * @vma: user vma to map to
> diff --git a/mm/util.c b/mm/util.c
> index 438170490e7f..c5ee52aede1e 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1469,6 +1469,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>                 return simple_ioremap_prepare(desc);
>         case MMAP_KERNEL_PAGES:
>                 return map_kernel_pages_prepare(desc);
> +       case MMAP_DISCONTIG_KERNEL_PAGES:
> +               return map_discontig_kernel_pages_prepare(desc);
>         }
>
>         WARN_ON_ONCE(1);
> @@ -1501,6 +1503,9 @@ int mmap_action_complete(struct vm_area_struct *vma=
,
>         case MMAP_KERNEL_PAGES:
>                 err =3D map_kernel_pages_complete(vma, action);
>                 break;
> +       case MMAP_DISCONTIG_KERNEL_PAGES:
> +               err =3D map_discontig_kernel_pages_complete(vma, action);
> +               break;
>         case MMAP_IO_REMAP_PFN:
>         case MMAP_SIMPLE_IO_REMAP:
>                 /* Should have been delegated. */
> @@ -1522,6 +1527,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>         case MMAP_IO_REMAP_PFN:
>         case MMAP_SIMPLE_IO_REMAP:
>         case MMAP_KERNEL_PAGES:
> +       case MMAP_DISCONTIG_KERNEL_PAGES:
>                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
>                 break;
>         }
> @@ -1543,6 +1549,7 @@ int mmap_action_complete(struct vm_area_struct *vma=
,
>         case MMAP_IO_REMAP_PFN:
>         case MMAP_SIMPLE_IO_REMAP:
>         case MMAP_KERNEL_PAGES:
> +       case MMAP_DISCONTIG_KERNEL_PAGES:
>                 WARN_ON_ONCE(1); /* nommu cannot handle this. */
>
>                 err =3D -EINVAL;
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 1098655a5f4a..1d5f6b3cbd21 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -457,14 +457,17 @@ enum mmap_action_type {
>         MMAP_NOTHING,
>         MMAP_REMAP_PFN,
>         MMAP_IO_REMAP_PFN,
> -       MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> -       MMAP_KERNEL_PAGES,      /* Map kernel page range from array. */
> +       MMAP_SIMPLE_IO_REMAP,           /* I/O remap with guardrails. */
> +       MMAP_KERNEL_PAGES,              /* Map kernel page range from arr=
ay. */
> +       MMAP_DISCONTIG_KERNEL_PAGES,    /* Map kernel discontig page rang=
e. */
>  };
>
>  /*
>   * Describes an action an mmap_prepare hook can instruct to be taken to =
complete
>   * the mapping of a VMA. Specified in vm_area_desc.
>   */
> +struct discontig_kernel_page_ops;
> +
>  struct mmap_action {
>         union {
>                 struct {
> @@ -483,6 +486,10 @@ struct mmap_action {
>                         unsigned long nr_pages;
>                         pgoff_t pgoff;
>                 } map_kernel;
> +               struct {
> +                       void *init_private;
> +                       const struct discontig_kernel_page_ops *ops;
> +               } map_kernel_discontig;
>         };
>         enum mmap_action_type type;
>
>
> --
> 2.55.0
>

