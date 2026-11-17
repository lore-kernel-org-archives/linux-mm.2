Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA1A606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 14:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ml8Ww8e1
Received: by kanga.kvack.org (Postfix)
	id D6C816B05B2; Tue, 17 Nov 2026 09:18:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E236B05B3; Tue, 17 Nov 2026 09:18:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0CEF6B05B4; Tue, 17 Nov 2026 09:18:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 926C76B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:18:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D57F160451
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:18:32 +0000 (UTC)
X-FDA: 85444816464.18.412CC6E
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id E807F140012
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:18:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ml8Ww8e1;
	spf=pass (imf23.hostedemail.com: domain of tfiga@chromium.org designates 209.85.167.47 as permitted sender) smtp.mailfrom=tfiga@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794925110;
	b=V2OmcvXVL10y9ocHpNZuqPJystI6A5p5Um6eGsgzmehm0ys0exPorRupO46KJOm8ubu1IH
	uO6oACTxfo461ETNBVlB75B9Zy+I18c44VkyNiiOEHfYZCftzrTl/6sqFCvXL71wn8JSMr
	Bqekfofl//2CBHhyMvk3Wb3kJm4+4sI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ml8Ww8e1;
	spf=pass (imf23.hostedemail.com: domain of tfiga@chromium.org designates 209.85.167.47 as permitted sender) smtp.mailfrom=tfiga@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794925110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FXZ9QjPMWSPXHYn/FS5PKL+JaPOXiDC39K9maTGAmk=;
	b=z/GgsWVlBbwhoRMup1PwRtcx104OcaVOgYPYfWJw/aJHXERRdPAo5Vy0Bere+pHb6a6qr4
	+LCZj7XMcgnr4Tubv9jO3fAtulRHcORGpndzfr8ccMaBM4GQeFZmFxNiiSkZNS8iFoGHxR
	6HFQX8mMueV5rn8AQi86fTfpmjYuIvE=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5be3cff0f6cso3196852e87.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794925108; x=1795529908; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4FXZ9QjPMWSPXHYn/FS5PKL+JaPOXiDC39K9maTGAmk=;
        b=ml8Ww8e1uXLKaBK6q25dlY5oPxxJPl4sYPa1OlWdqsu7GxCQIf04SE4OYwU7wYLsqQ
         zBZWMv0aNpR3M2epmb94PAxMeBWMYWzyE0F3xZQAjIYXsnNrZXbHKe62AdvkcL9qWyNj
         0KnFYn5pAA5yim/dJjykwj9TkvJsXjKCLMnbc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794925108; x=1795529908;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4FXZ9QjPMWSPXHYn/FS5PKL+JaPOXiDC39K9maTGAmk=;
        b=h2CkbPUeaW9yxSnA9xZP8ftkOC8mhY92uqCGUtjiLbIie+izJbJXjktobDWmJE0xpK
         ti1/jGo24QINq4OpolOuqUuanLpL9KYwvwqopP77PvHe4rFpcQZbfrewIOeRsO3A6D9l
         FvjlK5sUjW2GTTSdyDMYeBsXw3t5NHy+ZX7zp9RVm70xIQbhOLPKsBK77Rqcdthb4VqP
         yXhRW/F69GD0uoeakwvnyvoviPZKd/bwnZmyikly9nfTBVlNvja6mt9VJN1/ukHZlWJS
         4HPtVWGF5OG26622/zNtNIQoNF2csIjybP7ioBpttEpEIFbhipH8KHTl2TF6M/Zy7sjG
         Acyw==
X-Forwarded-Encrypted: i=1; AL+hErHA0xq1UuOcELVmoIqp1JDShTYJ5ULWlyD1ebTSzyqjOTeofcTtWmfrcqXFSUL831ZLsEfKDqmQpw==@kvack.org
X-Gm-Message-State: APuU4Z+VBMT28+hU1di8iuQjEDz6ZMUOc0QgpKU8Ob2iULAIEilWerpE
	DOfHudhZU4gZalfTQYfMeOH1MqCcs0UDf9St4ImWin/gcG+297h4U9zNq5XEkDwx0AvZ/b51g+i
	zkeEYjAFiLHo=
X-Gm-Gg: AYBFou2koaugP2LXq5EiM+VQBz2aF4HRtMjZhN83zDtPMswCjpYGDh4DdQ9ByDyKi6j
	I74QMBXNaNKvrKYyCiys8p78ofZDqqaytDk1E4u2vFpLkaMFZfzBFjAY99WZT4r+lcsjqXe9g9p
	QePfQNN3M260x03lEeBRESAWlW/iwnq3HGvOO8EvnRY/jd4yBnK24pDhH+dIqHTACbLFQOmSNe+
	mJ+JTMywr2qXj4sVTUo+7dL7jTDg91T6D7S8zAWnZASlheISF32nml6xnrVCn7kQbICwlngVutG
	MN2zgbui36tx1E+I1+hhFngnHENjV91UWGUFg5s4MCBMElNONtUeFbaV42YiEBgJY/D1iyVRLNF
	PcsR7h1Ro28mSzYy91WNRN19l3qC24bFR4B7+ypaN781A+SY5DMa+CkBw7Sx8b+rAfIblo0t4ti
	NBLX5NBSicnHPbTYzphEYpLiPB4vHAtlrywQmS3F4MTku9ZoHdccSPofr/4omnahbQMa4B42DDH
	Jj7Pja18/48zdryTpqmyROc9qM/X2Gxb0MWrFHvRDYHzyIjWxRj55+q+Whhl+HIq5rk1JerzFsM
	x1mW34ksHpPbcdj0qKW5IcsgF3rjEnxLar6D/+ocLYW4p3sIO7Aa1wv7GDiiaxG5
X-Received: by 2002:a05:6512:b1b:b0:5c1:57f6:2a55 with SMTP id 2adb3069b0e04-5c17099953fmr4767195e87.22.1794925107888;
        Tue, 17 Nov 2026 06:18:27 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c171357289sm3996751e87.71.2026.11.17.06.18.27
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 06:18:27 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so9546e87.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:18:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErH1IKls9LCiX70f8UPYRBKyZYVyNFoFKUTM7XHgG/iQAYL42Q9DL3dav13V7lihiEZ3NNTel36NTw==@kvack.org
X-Received: by 2002:a05:6402:a511:10b0:6b5:5d24:5d90 with SMTP id
 4fb4d7f45d1cf-6b85b4c22d8mr72630a12.3.1794924698252; Tue, 17 Nov 2026
 06:11:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116230627.3537051-1-jeffxu@chromium.org> <2066d131-f999-4747-beb8-520d5e0ce1db@kernel.org>
In-Reply-To: <2066d131-f999-4747-beb8-520d5e0ce1db@kernel.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 17 Nov 2026 23:11:19 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DzTmyeVQxNdhdy8pPi+ts1cCgbztVJiMoNBeJWBzjdQQ@mail.gmail.com>
X-Gm-Features: AclHuK8ZMC6yRFY7VxkKfsQMYV8BNfasB49bEPdk_bBjeXaAi9-9aO4mXcafXvg
Message-ID: <CAAFQd5DzTmyeVQxNdhdy8pPi+ts1cCgbztVJiMoNBeJWBzjdQQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/7] mm: kasan: skip KASAN for GFP_HIGHUSER
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jeff Xu <jeffxu@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Marco Elver <elver@google.com>, Boris Brezillon <boris.brezillon@collabora.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Chia-I Wu <olvaffe@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Evgenii Stepanov <eugenis@google.com>, Ian Rickards <ian.rickards@arm.com>, Jann Horn <jannh@google.com>, 
	Jeff Vander Stoep <jeffv@google.com>, Jeff Xu <jeffxu@google.com>, Kees Cook <kees@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Collingbourne <peter@pcc.me.uk>, 
	=?UTF-8?Q?Pierre=2DCl=C3=A9ment_Tosi?= <ptosi@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Allison Henderson <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-mm@kvack.org, kasan-dev@googlegroups.com, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	fuse-devel@lists.linux.dev, kexec@lists.infradead.org, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: oqh1xwa5t597uugcxcqbx8czumzohmt1
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E807F140012
X-HE-Tag: 1794925109-670792
X-HE-Meta: U2FsdGVkX1//n5jB+TbsW9/WS0+cmQua2l/Kpkk/S9D1EgJQe5QLf+OZ2ksbXGDwOybJHGMBCCOSQIU6XLt29qbshHXpI5pEnSwRxOc1iW419OZizUnlv6GNqXY1Q3WHSs2SDR1NCOwGGqU+lAYwk3UKwN08XwEAidLTMzF6OjWOcmNljoWxBA/Bzvr2ycdlm1dNFHsVa4sg80vaEUxF99jOzzwaDZ/AjssMteQgABSNXisKeFLoMK/ISRtZ/6O3y9Zvv+BGryJUM+/in1677lWRWOZA0e0kehG/oLgmgOzUOE5hE55I7DULUE/eYpcECmFLRdwvXkDUteBCDXVfKxPn1fvZ2z8a4BpPf9pT58erW7X2mPgDTyDrP7CuXvi2EjQNGnGdjcKUC/+51rwfY08Nx2IWs60Ya2vrUw9SIsBkzmffqdKovQG34jmxceUjooxE7ww5C6pcv8Rs/7Clhamtq7nT0NmIAap8dbw+0HQXP5jUld0nmWXcJI0YOWpXNHedRntqPWUcaBEGypMuDPnrMQP5IBEKQ0vSbf9w9ufv4dRFnf5f+2WKJ/VFyY6C3I9O+LpUgDfVyue1MfK60RMRMONBjaxFqG49yN//sMmKyc7FAeqbnH+xMUE1NCgKRlkJBM+z+jdAJtVwAorY93ISrxqtGI2MDSwS3ZQPSU8PT3l0mvTLYjU0QhrfzAuYweHvw3E3jrS7kiQsF8/m6dw9YfOvjtskAAUgraQ8Jc+IUppuMygbZj0WRfkGiwTmrdjNQe9kl6qUtQJAYk/IkyH/HKoknpV+hm8vl7z9MwFfweahkMdmJkoQeauwgE4FafbrQ4aVB0VxR3dvsZzimFmwArFv66tNo2CEv19A/HBq91qV3Av8HuNWnvk/8geHlwkc8QVGUhOBer94rfH9NovN6A3YgotT9gvVZE0El7IRivvY96c/Htrm0D9NBbTuYVHTVcwJMow2k6cfULf
 HaP/vsYZ
 ZI8zKg0AmnVGJ+toA7kmI5CRuPcSRDf9orWvjlddt88VYFfP5mbiOkygzXKRYdcaiXl+CVBqjigecAD2kIjlB6xH10Kc9oSnkeYZ4n2F9xJGxygpKb0roZFeCQum0SN3XyqWIpQbJ1xdR7VWfqXIW1QiCBtIlrISvuPY1R3mGZchyj3sLt6qQS4tYSRADktPl6oXa82YLCA7hh9dDgTgyBg4VM3Jmls4y3yDIB8moo0ToDMcmlrNBN0orDx7NuJ5saFQY4S/L+/opur9OHxzePPrLxE6I//Yy1gPM4zhi8SLWKoNxRVkttcwR93Hk7bIoY1dKkM920WiCFgETpWm6I9UcHemjUHt0XUsOthokKpa6gghCH4WCvI0b4dViU0HlO+ODL0ujJAjnMBO0GFqEvazTo7XhqJ9Aad9Pk+1SrDB3PH+ckipl/ReuWlLZk56ITCs3wKExMfgx1BQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 7:10=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/17/26 00:06, Jeff Xu wrote:
> > Hi all,
> >
> > Currently, GFP_HIGHUSER_MOVABLE includes __GFP_SKIP_KASAN (commits
> > c275c5c6d50a, 70c248aca9e7, and 0a54864f8dfb), allowing movable
> > userspace page allocations to skip KASAN page unpoisoning on allocation
> > and poisoning on free under CONFIG_KASAN_HW_TAGS (ARM64 MTE). However,
> > GFP_HIGHUSER does not include __GFP_SKIP_KASAN, even though it shares
> > the same kernel-accessibility contract in include/linux/gfp_types.h
> > ("for userspace allocations that may be mapped to userspace, do not nee=
d
> > to be directly accessible by the kernel but that cannot move once in
> > use") and differs only by !__GFP_MOVABLE.
> >
> > Moving __GFP_SKIP_KASAN to GFP_HIGHUSER addresses the performance issue
> > below (following up on the earlier drm/panthor discussion [1, 2]). The
> > swap issue from that discussion is not addressed by this series:
> >
> > 1. Performance: For every 4 KB page without __GFP_SKIP_KASAN,
> >    mte_set_mem_tag_range() tags all 256 16-byte MTE granules (via
> >    STG/STZG and DC GVA/GZVA) on allocation and again on free. In
> >    graphics and UI workloads, DMA-BUF (system_heap) and DRM/GPU
> >    (shmem/TTM) buffers use GFP_HIGHUSER; while steady-state rendering
> >    reuses buffers, window resizes, surface transitions, and app launche=
s
> >    synchronously allocate and free tens to hundreds of megabytes (~32 M=
B
> >    per 4K RGBA frame) on UI/compositor/render threads. That takes a
> >    significant share of the 8.3 ms (120 Hz) / 16.7 ms (60 Hz) frame
> >    budget and thrashes CPU data/MTE tag caches (especially on
> >    cold-cache free). On Armv9.2-A, skipping KASAN cuts ~32 MB DMA-BUF
> >    alloc+free latency by ~80% (~98% faster close()) and improves the
> >    OpenGL score of an app-loading benchmark by 15-23%.
> >
> > 2. False-positive KASAN report after shmem swap-in readahead [1] (not
> >    addressed here): when a shmem page is swapped in,
> >    swap_cluster_readahead() also reads the neighboring swap slots and
> >    allocates their swap-cache folios with the gfp mask of that shmem
> >    mapping. A neighboring slot can hold an unrelated page that
> >    userspace maps with PROT_MTE. If the mask lacks __GFP_SKIP_KASAN,
> >    that page's folio gets a KASAN tag in page->flags. When its owner
> >    faults it in, arch_swap_restore() writes the saved userspace tags to
> >    the memory, but page->flags keeps the KASAN tag. Later kernel
> >    accesses through page_address() then use a tag that does not match
> >    the memory and are reported by KASAN.
> >
> >    This series does not fix the readahead path. It only removes one
> >    way to hit it: shmem mappings that use GFP_HIGHUSER (e.g.
> >    drm_gem_shmem_helper / panthor) now pass __GFP_SKIP_KASAN to
> >    readahead, so the neighboring folios no longer get a KASAN tag.
> >    Shmem mappings with other gfp masks that lack __GFP_SKIP_KASAN
> >    (e.g. GFP_KERNEL) can still trigger the report. That issue should
> >    be followed up separately, for example in [1].
> >
> > What changes for users of GFP_HIGHUSER pages under CONFIG_KASAN_HW_TAGS
> > (other KASAN modes are not affected):
> >
> > - Access through vmap(): nothing changes. Those pointers already carry
> >   the match-all tag and are not checked today.
> > - Access through kmap_local_page() or page_address() (for example
> >   ramfs): accesses are no longer checked by KASAN, as is already the
> >   case for GFP_HIGHUSER_MOVABLE pages.
> > - Buffers that the kernel itself fills (pipe, FUSE, kexec, RDS) keep
> >   KASAN checking by using the new GFP_HIGHUSER_KASAN (patches 1-4).
> >
> > GFP_KERNEL, GFP_USER, slab and vmalloc() allocations are not affected.
> >
> > Patch 1 adds GFP_HIGHUSER_KASAN
>
> I really don't want us to spread KASAN-related GFP flags in the kernel.
>
> There must be a proper way to abstract this.
>
> Why is GFP_HIGHUSER not sufficient? We were already told that this is mem=
ory to
> be mapped into user space. Placing data structure on it and handing out p=
ointers
> to that would already be a bit questionable.
>
> So what are the ways to avoid GFP_HIGHUSER_KASAN?

I think the idea behind GFP_HIGHUSER_KASAN is to make it possible to
skip KASAN for GFP_HIGHUSER by default (for most of its users), but
keep it for some of the users which today use GFP_HIGHUSER for their
memory allocations, but could benefit from the added security. As per
the other patches in the series:

  pipe, fuse: use GFP_HIGHUSER_KASAN for pipe buffer pages
  kexec: use GFP_HIGHUSER_KASAN for segment pages
  net/rds: use GFP_HIGHUSER_KASAN for message pages

That said, I'm not familiar with any of the code mentioned by those
patches, so I can't really tell how much they would benefit from KASAN
or if their choice of GFP_HIGHUSER to begin with is correct.

Best,
Tomasz

