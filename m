Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79EBCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 21:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1F8D8E000D; Wed, 24 Sep 2025 17:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6E48E000A; Wed, 24 Sep 2025 17:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0CFA8E000D; Wed, 24 Sep 2025 17:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF1308E000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:41:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 36D6B1DCDDB
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:41:36 +0000 (UTC)
X-FDA: 83925465792.03.B1D30DB
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf13.hostedemail.com (Postfix) with ESMTP id CC21A20005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:41:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=NLKyQYaY;
	spf=pass (imf13.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com;
	dmarc=pass (policy=none) header.from=canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758750094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9pYJ1znLF25Yiw63WaSOuxWWlaoWjL/RNXrdeptb4BM=;
	b=gUgctPii07rcL0FnA47mw6IYjqFW+/7X4sJRwtP+ktvUi2hGgEAGbgS6Cx8CW25NDWA4DK
	NhX8rf8HFfq+hXII6zIq4L6sbtuGBA69vtMml8AWxEsxnw4ByQt6iVKq8ytBtAUGRyuNpg
	n8kbniP50g9Kukk9Y8jzFuu8r8ZedV8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758750094; a=rsa-sha256;
	cv=none;
	b=yPA3lt3vMco3OtEB3zmPVbOGlGzvNtSLM4YmRGjibymj3hyfQ11pOaOXLAamz+H4cgzVV9
	ku8zghTB0GR/BLP8gCAjlzYocd2hp3/A7WQh4/tWJw4pAbHDu+q2no1SJU/5KHNVjoebvj
	LuDfeWOoVHfGUUNoQQRcGR9DvuB+B18=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=NLKyQYaY;
	spf=pass (imf13.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com;
	dmarc=pass (policy=none) header.from=canonical.com
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A7F583F949
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1758750090;
	bh=9pYJ1znLF25Yiw63WaSOuxWWlaoWjL/RNXrdeptb4BM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=NLKyQYaYNfCYJT91OfSF1Y229rMe/uZm/XM10jfRUhf0UVmJ7boKT3A3YQZ+R8U+i
	 XLVWeDcP8M2nxwnyOUwiguP7bEW7p6JRiaWZRmyDg7+ORvxirzapHaNqGc0DVjE5Nh
	 yHOTcGLYyB0l6B7NOX7+jl7/PkjDAYucmJydq/by+SlvosRhnTZ4xfBcpUOVfkWkUt
	 W3sCKGpor7Chqq4gVc5C6zHoR+WPkoJZ3zTAiDjLSVFmTCUuk+4kccMX09dhBVBUgo
	 HHElNFq3RftiuqPMl4ED48CCEKuUOESy5j10stMuGl0ElRN2S1BYfejAHitAzkQVVt
	 d7vBhbqWAN7Xw==
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-244581ce13aso4315435ad.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:41:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758750089; x=1759354889;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9pYJ1znLF25Yiw63WaSOuxWWlaoWjL/RNXrdeptb4BM=;
        b=vsavRfdGtJ8sLTL3KuKGnUnfmaFcTFHIsVKQEmlw04Hzbv0RJwgw7lP94bZpiQo/na
         4pQn4wxOLGSbgEATQvcVlPBjie1AdgMil9c/cT9ttUKQh17wgoXytoaBU/ae8GsRdZUq
         4qjJAcmAVXk9wcJXBjW11Vj4Qumcs7yflY4Ud/AAT8sFMAXN8ibbNrXZZ1xiRNak64zN
         4vCve4PpPQ8t1cxvjudMxosdyo6NgUcbJWKo44WxQ1MSicFbzMUjqQH4+2qZgoG7kg+q
         l8tBta3EScBQaWlZDoWjpWC8Su3zFVVsjb6YKwoeT4Mu9t52uhdIfJLoABXPiICiPG57
         8xoA==
X-Forwarded-Encrypted: i=1; AJvYcCVMcDD4FIrI7g/dmS9St+B/pt5FAziKRlsZHBOThC0/q3jhkq4JuTj0tBtBAz9RibNyMauzMWVK2A==@kvack.org
X-Gm-Message-State: AOJu0YxeZLS+MQPOsKSh2wIfmzaZfCTw65zg/8c0wovYhycm+hyRQvZL
	SGOhaSzzYRaRGgmou2J1rozqtjAyLjZ5BfrQV4dQcm4Gn/NbuLCcpB2g2rr2mKZw6ivK3AtaMUs
	xofqvc4VP2wqWblRhY2vbbvs0+aL3Ap8Mg6GgxnpVXO+CYETATIk226n2iuxgKrKbrYZOS3tJLo
	6iIbXL4ZEf/TUDqqR24wMn72tor9SxEU/hpLnuJduej3s=
X-Gm-Gg: ASbGnctDGBaKC6jAFumW/gmnEKjfxhLvwI1rbRkoHc19MRWMU53iBX8yewzOi9/no+U
	bD11bOItY9eO2byuR4m1zA67G5W/ObHf33Bvma/ucoY+h3Tv0/5uA6/pFn8x1WDCskq2GmC/gX2
	ABV61k9As2cHalhL9yLQ==
X-Received: by 2002:a17:903:37c3:b0:272:8c5f:1325 with SMTP id d9443c01a7336-27ed4a30cfemr12877565ad.36.1758750089068;
        Wed, 24 Sep 2025 14:41:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGit+7xVZf41CcHGBbQtvgPbP5bLRU4Ex5Im8B0jVLwSOhCxir7WNv2DuuLLTQCPZQ4MogXzP/zY+E2B6qUP0g=
X-Received: by 2002:a17:903:37c3:b0:272:8c5f:1325 with SMTP id
 d9443c01a7336-27ed4a30cfemr12876725ad.36.1758750088373; Wed, 24 Sep 2025
 14:41:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
 <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org> <aNQ7D6_ZYMhCdkmL@debug.ba.rivosinc.com>
In-Reply-To: <aNQ7D6_ZYMhCdkmL@debug.ba.rivosinc.com>
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Date: Wed, 24 Sep 2025 23:41:17 +0200
X-Gm-Features: AS18NWBe4nV5wxYipXcIJasE75xDEqfNOUdLCNPKE3zqJAjrvNelbkpgKW9XgCM
Message-ID: <CAM=mAOmQy7DSeXU4jkgNDFFX5KUpveMf1UPREUD2HjNUf7R7rA@mail.gmail.com>
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
To: Deepak Gupta <debug@rivosinc.com>
Cc: Paul Walmsley <pjw@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Jann Horn <jannh@google.com>, 
	Conor Dooley <conor+dt@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-riscv <linux-riscv@lists.infradead.org>, 
	devicetree <devicetree@vger.kernel.org>, linux-arch@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Alistair Francis <alistair.francis@wdc.com>, Richard Henderson <richard.henderson@linaro.org>, 
	jim.shu@sifive.com, Andy Chiu <andybnac@gmail.com>, Kito Cheng <kito.cheng@sifive.com>, 
	Charlie Jenkins <charlie@rivosinc.com>, Atish Patra <atishp@rivosinc.com>, 
	Evan Green <evan@rivosinc.com>, =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, samitolvanen@google.com, 
	Mark Brown <broonie@kernel.org>, rick.p.edgecombe@intel.com, 
	rust-for-linux@vger.kernel.org, Zong Li <zong.li@sifive.com>, 
	David Hildenbrand <david@redhat.com>, Florian Weimer <fweimer@redhat.com>, bharrington@redhat.com, 
	Aurelien Jarno <aurel32@debian.org>
Content-Type: multipart/alternative; boundary="000000000000443e44063f92ea00"
X-Stat-Signature: gaepeiznogn39usjef53j44iyx643nfp
X-Rspam-User: 
X-Rspamd-Queue-Id: CC21A20005
X-Rspamd-Server: rspam10
X-HE-Tag: 1758750093-771875
X-HE-Meta: U2FsdGVkX181u0NdQ43h0djbLAWJ6MAar4U33RX0SlfLUM09kmAeobyX39ZmiAmET6iPFxvuVBMTlkxXN2AQcCf3h429Zb3DybzjFjEJBrNMRZ1WKG6J58mTjGjNP5qNCk6o3EyYmRQ0ojgq3qYyFe1Z1iwgiuHuB6QYVPASCTk95FOAu4w82qvtxD5JmVAWPZKTUGF7DpcMvr9vtG25PI2AU1iNfGJx7DCXa8PyH4qX3XB4g8QLvNvP8Z9hIgXoC+z8jAkuS90qaQ/HNDEey4cK7ZHumc2Btd7+Ki+Eg29n60bVyDy939nVc/7LVbPVWMByolKYUuAWemeyw/0Pq47JLRorGej3O8UGKUk72xxUStI61K1MxpAvJbJpKldWe5pEvyTwpUkddkonNprKoJS4/uofUuKhynvrAlvWWqYIJXju6ktMYXzUJC63LbizQ7mkk+2qm1ZbCp+U8EP+uVacxJvSaotjOFa7Z8CCUnHehr81RUpVQnp8ByFjMZOP4yUV2B/6O5GrwP2ijR5sCryI5OYydUA6Z/AA6lOB3Ek7vBkNYpHiFSwQMrsyfQzr5hVL++JOE0sS+n5EGZCaLF/laVHmxDLSsF93ahhZfv01D+c7Z13Eql6pe52R6EMuOIjZ18DPqolUV804cZzSwp7X69JQalKpTj8/Pgc5aUUE1H881EUG/73JNTNu8Cz2sQd1MHjry4TiGLeaK+RMvQtKl6dhVTkTIIzHePn/qWclMjFXRh9zKeMvqdHSZhGo+1B0kiN8imk3AgLIInuKiB7cEEygXLnMQz2JiSN1zIo00BvxsNMy1oVjG/zXSmJuagX2RkjuKT160uKtjcwTkx2iaXXFFFJ/gJ21qZoVZFu9B8wSrm01eAxIn/pvTAfIIrkiKwAj3c/WjzEa0jk2n2XVVjXCo/FDoa/Eq24ajaoF/Ei9smzCbo8DigYKp1KBGjqMDJs0OhZMSzdWRtv
 3bv7nJPb
 tgQFgmC9Y95AZtz5dm6vqUmBDpQSLod10UnTYMQSKdNbzrV3hbU340Dk/NQsMcPCIEvzgkWzO+OCtLF8euMXJIfVd+FBjVHFUKgUrdDdRducXflNKnCCC7zjkJnN78d81OoKeKVI5MYYJXVeabY3GqKetcIoA2iaknZZX4c4WlGe9ZRE4/2mPjIkx6m3WrjEYYdoYKlAqvzFB/bOcbuog++mHLPySKUoR+795c4jR7Zgt9yw60ELyMn5SsPCQXX6O2SNm22CSZfvIBb0cqZSd9RpWsITh2RRpOLkb45DBw6K3AvLIL+qHDwVSdZvwANfUjSBCGyhFLrjH4M9WSUMI+UM9eb0luvbBfGW6XpRQVIG0NuPdrmrLKmEH8gns4CPRKTZCCu1Cf1F4/Lx8jpddA4h8fTewhWfsL8QNFr/wVC4rI8yTxJnc901J+2tn3nHAOdyUGEVakftXdDPC4L7Fiew9mkX42jbzW1RH7bSQYNXVYnSONrgYZXbuEv/pxRLwaaHE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000443e44063f92ea00
Content-Type: text/plain; charset="UTF-8"

Deepak Gupta <debug@rivosinc.com> schrieb am Mi., 24. Sept. 2025, 20:40:

> On Wed, Sep 24, 2025 at 08:36:11AM -0600, Paul Walmsley wrote:
> >Hi,
> >
> >On Thu, 31 Jul 2025, Deepak Gupta wrote:
> >
> >[ ... ]
> >
> >> vDSO related Opens (in the flux)
> >> =================================
> >>
> >> I am listing these opens for laying out plan and what to expect in
> future
> >> patch sets. And of course for the sake of discussion.
> >>
> >
> >[ ... ]
> >
> >> How many vDSOs
> >> ---------------
> >> Shadow stack instructions are carved out of zimop (may be operations)
> and if CPU
> >> doesn't implement zimop, they're illegal instructions. Kernel could be
> running on
> >> a CPU which may or may not implement zimop. And thus kernel will have
> to carry 2
> >> different vDSOs and expose the appropriate one depending on whether CPU
> implements
> >> zimop or not.
> >
> >If we merge this series without this, then when CFI is enabled in the
> >Kconfig, we'll wind up with a non-portable kernel that won't run on older
> >hardware.  We go to great lengths to enable kernel binary portability
> >across the presence or absence of other RISC-V extensions, and I think
> >these CFI extensions should be no different.
> >
> >So before considering this for merging, I'd like to see at least an
> >attempt to implement the dual-vDSO approach (or something equivalent)
> >where the same kernel binary with CFI enabled can run on both pre-Zimop
> >and post-Zimop hardware, with the existing userspaces that are common
> >today.
>
> Added some distro folks in this email chain.
>
> After patchwork meeting today, I wanted to continue discussion here. So
> thanks
> Paul for looking into it and initiating a discussion here.
>
> This patch series has been in the queue for quite a long time and we have
> had
> deliberations on vDSO topic earlier as well and after those deliberations
> it
> was decided to go ahead with merge and it indeed was sent for 6.17 merge
> window. Unfortunatley due to other unforeseen reasons, entirety of riscv
> changes were not picked. So it's a bit disappointing to see back-paddling
> on
> this topic.
>
> Anyways, we are here. So I'll provide a bit of context for the list about
> deliberations and discussions we have been having for so many merge
> windows.
> This so that a holistic discussion can happen on this before we make a
> decision.
>
> Issue
> ======
>
> Instructions in RISC-V shadow stack extension (zicfiss - [1]) are carved
> out of
> "may be ops" aka zimop extension [2]. "may be ops" are illegal on non-RVA23
> hardware. This means any existing riscv CPU or future CPU which isn't RVA23
> compliant and not implementing zimop will treat these encodings as illegal.
>
> Current kernel patches enable shadow stack and landing pad support for
> userspace using config `CONFIG_RISCV_USER_CFI`. If this config is selected
> then
> vDSO that will be exposed to user space will also have shadow stack
> instructions in them. Kernel compiled with `CONFIG_RISCV_USER_CFI`, for
> sake of
> this discussion lets call it RVA23 compiled kernel.
>
> Issue that we discussed earlier and even today is "This RVA23 compiled
> kernel
> won't be able to support non-RVA23 userspace on non-RVA23 hardware
> because".
> Please note that issue exists only on non-RVA23 hardware (which is existing
> hardware and future hardware which is not implementing zimop). RVA23
> compiled
> kernel can support any sort of userspace on RVA23 hardware.
>
>
> Discussion
> ===========
>
> So the issue is not really shadow stack instructions but rather may be op
> instructions in codegen (binaries and vDSO) which aren't hidden behind any
> flag (to hide them if hardware doesn't support). And if I can narrow down
> further, primary issue we are discussing is that if cfi is enabled during
> kernel compile, it is bringing in a piece of code (vDSO) which won't work
> on existing hardware. But the counter point is if someone were to deploy
> RVA23 compiled kernel on non-RVA23 hardware, they must have compiled
> rest of the userspace without shadow stack instructions in them for such
> a hardware. And thus at this point they could simply choose *not* to turn
> on
> `CONFIG_RISCV_USER_CFI` when compiling such kernel. It's not that
> difficult to
> do so.
>
> Any distro who is shipping userspace (which all of them are) along with
> kernel
> will not be shipping two different userspaces (one with shadow stack and
> one
> without them). If distro are shipping two different userspaces, then they
> might
> as well ship two different kernels. Tagging some distro folks here to get
> their
> take on shipping different userspace depending on whether hardware is
> RVA23 or
> not. @Heinrich, @Florian, @redbeard and @Aurelien.
>

Ubuntu like other non-rolling distros maintains separate kernels per
release. Even if a kernel is backported there will be differences in
applied patches and configuration between the distro releases.

Looking at the userspace I don't see how we could have a CFI enabled distro
that would run on hardware without support for maybe operations. Without
CFI userland I cannot see a use case for a CFI enabled kernel for such
hardware either.

We cannot expect the whole software ecosystem including containers to
switch to CFI synchronously. Hence software that is compiled without CFI
must be able call into a CFI enabled kernel and its vDSO library.

Best regards

Heinrich


> Major distro's have already drawn a distinction here that they will drop
> support for hardware which isn't RVA23 for the sake of keeping binary
> distribution simple.
>
> Only other use case that was discussed of a powerful linux user who just
> wants
> to use a single kernel on all kinds of riscv hardware. I am imagining such
> a
> user knows enough about kernel and if is really dear to them, they can
> develop
> their own patches and send it upstream to support their own usecase and we
> can
> discuss them out. Current patchset don't prevent such a developer to send
> such
> patches upstream.
>
> I heard the argument in meeting today that "Zbb" enabling works similar for
> kernel today. I looked at "Zbb" enabling. It's for kernel usage and it's
> surgically placed in kernel using asm hidden behind alternatives. vDSO
> isn't
> compiled with Zbb. Shadow stack instructions are part of codegen for C
> files
> compiled into vDSO.
>
> Furthermore,
>
> Kernel control flow integrity will introduce shadow stack instructions all
> over the kernel binary. Such kernel won't be deployable on non-RVA23
> hardware.
> How to deal with this problem for a savvy kernel developer who wants to run
> same cfi enabled kernel binary on multiple hardware?
>
> Coming from engineering and hacker point of view, I understand the desire
> here
> but I still see that it's complexity enforced on rest of the kernel from a
> user
> base which anyways can achieve such goals. For majority of usecases, I
> don't
> see a reason to increase complexity in the kernel for build, possibly
> runtime
> patching and thus possibly introduce more issues and errors just for the
> sake
> of a science project.
>
> Being said that, re-iterating that currently default for
> `CONFIG_RISCV_USER_CFI`
> is "n" which means it won't be breaking anything unless a user opts "Y".
> So even
> though I really don't see a reason and usability to have complexity in
> kernel to
> carry multiple vDSOs, current patchsets are not a hinderance for such
> future
> capability (because current default is No) and motivated developer is
> welcome
> to build on top of it. Bottomline is I don't see a reason to block current
> patchset from merging in v6.18.
>
>
> [1] -
> https://github.com/riscv/riscv-isa-manual/blob/main/src/unpriv-cfi.adoc#shadow-stack-zicfiss
> [2] - https://github.com/riscv/riscv-isa-manual/blob/main/src/zimop.adoc
>
> >
> >thanks Deepak,
> >
> >- Paul
>

--000000000000443e44063f92ea00
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><br><div class=3D"gmail_quote gmail_quote_contai=
ner"><div dir=3D"ltr" class=3D"gmail_attr">Deepak Gupta &lt;<a href=3D"mail=
to:debug@rivosinc.com">debug@rivosinc.com</a>&gt; schrieb am Mi., 24. Sept.=
 2025, 20:40:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 =
0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Wed, Sep 24, 2025 =
at 08:36:11AM -0600, Paul Walmsley wrote:<br>
&gt;Hi,<br>
&gt;<br>
&gt;On Thu, 31 Jul 2025, Deepak Gupta wrote:<br>
&gt;<br>
&gt;[ ... ]<br>
&gt;<br>
&gt;&gt; vDSO related Opens (in the flux)<br>
&gt;&gt; =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt;&gt;<br>
&gt;&gt; I am listing these opens for laying out plan and what to expect in=
 future<br>
&gt;&gt; patch sets. And of course for the sake of discussion.<br>
&gt;&gt;<br>
&gt;<br>
&gt;[ ... ]<br>
&gt;<br>
&gt;&gt; How many vDSOs<br>
&gt;&gt; ---------------<br>
&gt;&gt; Shadow stack instructions are carved out of zimop (may be operatio=
ns) and if CPU<br>
&gt;&gt; doesn&#39;t implement zimop, they&#39;re illegal instructions. Ker=
nel could be running on<br>
&gt;&gt; a CPU which may or may not implement zimop. And thus kernel will h=
ave to carry 2<br>
&gt;&gt; different vDSOs and expose the appropriate one depending on whethe=
r CPU implements<br>
&gt;&gt; zimop or not.<br>
&gt;<br>
&gt;If we merge this series without this, then when CFI is enabled in the<b=
r>
&gt;Kconfig, we&#39;ll wind up with a non-portable kernel that won&#39;t ru=
n on older<br>
&gt;hardware.=C2=A0 We go to great lengths to enable kernel binary portabil=
ity<br>
&gt;across the presence or absence of other RISC-V extensions, and I think<=
br>
&gt;these CFI extensions should be no different.<br>
&gt;<br>
&gt;So before considering this for merging, I&#39;d like to see at least an=
<br>
&gt;attempt to implement the dual-vDSO approach (or something equivalent)<b=
r>
&gt;where the same kernel binary with CFI enabled can run on both pre-Zimop=
<br>
&gt;and post-Zimop hardware, with the existing userspaces that are common<b=
r>
&gt;today.<br>
<br>
Added some distro folks in this email chain.<br>
<br>
After patchwork meeting today, I wanted to continue discussion here. So tha=
nks<br>
Paul for looking into it and initiating a discussion here.<br>
<br>
This patch series has been in the queue for quite a long time and we have h=
ad<br>
deliberations on vDSO topic earlier as well and after those deliberations i=
t<br>
was decided to go ahead with merge and it indeed was sent for 6.17 merge<br=
>
window. Unfortunatley due to other unforeseen reasons, entirety of riscv<br=
>
changes were not picked. So it&#39;s a bit disappointing to see back-paddli=
ng on<br>
this topic.<br>
<br>
Anyways, we are here. So I&#39;ll provide a bit of context for the list abo=
ut<br>
deliberations and discussions we have been having for so many merge windows=
.<br>
This so that a holistic discussion can happen on this before we make a<br>
decision.<br>
<br>
Issue<br>
=3D=3D=3D=3D=3D=3D<br>
<br>
Instructions in RISC-V shadow stack extension (zicfiss - [1]) are carved ou=
t of<br>
&quot;may be ops&quot; aka zimop extension [2]. &quot;may be ops&quot; are =
illegal on non-RVA23<br>
hardware. This means any existing riscv CPU or future CPU which isn&#39;t R=
VA23<br>
compliant and not implementing zimop will treat these encodings as illegal.=
<br>
<br>
Current kernel patches enable shadow stack and landing pad support for<br>
userspace using config `CONFIG_RISCV_USER_CFI`. If this config is selected =
then<br>
vDSO that will be exposed to user space will also have shadow stack<br>
instructions in them. Kernel compiled with `CONFIG_RISCV_USER_CFI`, for sak=
e of<br>
this discussion lets call it RVA23 compiled kernel.<br>
<br>
Issue that we discussed earlier and even today is &quot;This RVA23 compiled=
 kernel<br>
won&#39;t be able to support non-RVA23 userspace on non-RVA23 hardware beca=
use&quot;.<br>
Please note that issue exists only on non-RVA23 hardware (which is existing=
<br>
hardware and future hardware which is not implementing zimop). RVA23 compil=
ed<br>
kernel can support any sort of userspace on RVA23 hardware.<br>
<br>
<br>
Discussion<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
So the issue is not really shadow stack instructions but rather may be op<b=
r>
instructions in codegen (binaries and vDSO) which aren&#39;t hidden behind =
any<br>
flag (to hide them if hardware doesn&#39;t support). And if I can narrow do=
wn<br>
further, primary issue we are discussing is that if cfi is enabled during<b=
r>
kernel compile, it is bringing in a piece of code (vDSO) which won&#39;t wo=
rk<br>
on existing hardware. But the counter point is if someone were to deploy<br=
>
RVA23 compiled kernel on non-RVA23 hardware, they must have compiled<br>
rest of the userspace without shadow stack instructions in them for such<br=
>
a hardware. And thus at this point they could simply choose *not* to turn o=
n<br>
`CONFIG_RISCV_USER_CFI` when compiling such kernel. It&#39;s not that diffi=
cult to<br>
do so.<br>
<br>
Any distro who is shipping userspace (which all of them are) along with ker=
nel<br>
will not be shipping two different userspaces (one with shadow stack and on=
e<br>
without them). If distro are shipping two different userspaces, then they m=
ight<br>
as well ship two different kernels. Tagging some distro folks here to get t=
heir<br>
take on shipping different userspace depending on whether hardware is RVA23=
 or<br>
not. @Heinrich, @Florian, @redbeard and @Aurelien.<br></blockquote></div></=
div><div dir=3D"auto"><br></div><div dir=3D"auto">Ubuntu like other non-rol=
ling distros maintains separate kernels per release. Even if a kernel is ba=
ckported there will be differences in applied patches and configuration bet=
ween the distro releases.</div><div dir=3D"auto"><br></div><div dir=3D"auto=
">Looking at the userspace I don&#39;t see how we could have a CFI enabled =
distro that would run on hardware without support for maybe operations. Wit=
hout CFI userland I cannot see a use case for a CFI enabled kernel for such=
 hardware either.</div><div dir=3D"auto"><br></div><div dir=3D"auto">We can=
not expect the whole software ecosystem including containers to switch to C=
FI synchronously. Hence software that is compiled without CFI must be able =
call into a CFI enabled kernel and its vDSO library.</div><div dir=3D"auto"=
><br></div><div dir=3D"auto">Best regards</div><div dir=3D"auto"><br></div>=
<div dir=3D"auto">Heinrich</div><div dir=3D"auto"><br></div><div dir=3D"aut=
o"><div class=3D"gmail_quote gmail_quote_container"><blockquote class=3D"gm=
ail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-le=
ft:1ex">
<br>
Major distro&#39;s have already drawn a distinction here that they will dro=
p<br>
support for hardware which isn&#39;t RVA23 for the sake of keeping binary<b=
r>
distribution simple.<br>
<br>
Only other use case that was discussed of a powerful linux user who just wa=
nts<br>
to use a single kernel on all kinds of riscv hardware. I am imagining such =
a<br>
user knows enough about kernel and if is really dear to them, they can deve=
lop<br>
their own patches and send it upstream to support their own usecase and we =
can<br>
discuss them out. Current patchset don&#39;t prevent such a developer to se=
nd such<br>
patches upstream.<br>
<br>
I heard the argument in meeting today that &quot;Zbb&quot; enabling works s=
imilar for<br>
kernel today. I looked at &quot;Zbb&quot; enabling. It&#39;s for kernel usa=
ge and it&#39;s<br>
surgically placed in kernel using asm hidden behind alternatives. vDSO isn&=
#39;t<br>
compiled with Zbb. Shadow stack instructions are part of codegen for C file=
s<br>
compiled into vDSO.<br>
<br>
Furthermore,<br>
<br>
Kernel control flow integrity will introduce shadow stack instructions all<=
br>
over the kernel binary. Such kernel won&#39;t be deployable on non-RVA23 ha=
rdware.<br>
How to deal with this problem for a savvy kernel developer who wants to run=
<br>
same cfi enabled kernel binary on multiple hardware?<br>
<br>
Coming from engineering and hacker point of view, I understand the desire h=
ere<br>
but I still see that it&#39;s complexity enforced on rest of the kernel fro=
m a user<br>
base which anyways can achieve such goals. For majority of usecases, I don&=
#39;t<br>
see a reason to increase complexity in the kernel for build, possibly runti=
me<br>
patching and thus possibly introduce more issues and errors just for the sa=
ke<br>
of a science project.<br>
<br>
Being said that, re-iterating that currently default for `CONFIG_RISCV_USER=
_CFI`<br>
is &quot;n&quot; which means it won&#39;t be breaking anything unless a use=
r opts &quot;Y&quot;. So even<br>
though I really don&#39;t see a reason and usability to have complexity in =
kernel to<br>
carry multiple vDSOs, current patchsets are not a hinderance for such futur=
e<br>
capability (because current default is No) and motivated developer is welco=
me<br>
to build on top of it. Bottomline is I don&#39;t see a reason to block curr=
ent<br>
patchset from merging in v6.18.<br>
<br>
<br>
[1] - <a href=3D"https://github.com/riscv/riscv-isa-manual/blob/main/src/un=
priv-cfi.adoc#shadow-stack-zicfiss" rel=3D"noreferrer noreferrer" target=3D=
"_blank">https://github.com/riscv/riscv-isa-manual/blob/main/src/unpriv-cfi=
.adoc#shadow-stack-zicfiss</a><br>
[2] - <a href=3D"https://github.com/riscv/riscv-isa-manual/blob/main/src/zi=
mop.adoc" rel=3D"noreferrer noreferrer" target=3D"_blank">https://github.co=
m/riscv/riscv-isa-manual/blob/main/src/zimop.adoc</a><br>
<br>
&gt;<br>
&gt;thanks Deepak,<br>
&gt;<br>
&gt;- Paul<br>
</blockquote></div></div></div>

--000000000000443e44063f92ea00--

