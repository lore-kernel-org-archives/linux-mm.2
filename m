Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C602CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 12:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B46FA8E0006; Thu, 25 Sep 2025 08:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7AA8E0001; Thu, 25 Sep 2025 08:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D738E0006; Thu, 25 Sep 2025 08:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CDE88E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:30:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40919160188
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:30:24 +0000 (UTC)
X-FDA: 83927705568.16.9DDFB5F
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 37E14180018
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:30:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kB1WaJZi;
	spf=pass (imf24.hostedemail.com: domain of andybnac@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=andybnac@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758803422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpogRHSrLfl51nWywJppLMZXYXi2KQs1G3uCf0+H8cQ=;
	b=HVAvpWqPlbZsbLmDCoE48FvNAITdjHwoD4xutQNqCu5xxdwKAgX65qcNZOsfvgULb0QTnR
	zNlZf2XBUUcKhLjIrHJSrVcdLlAx94QMtpy9hqvcJjcywhH8p1CDXEpyqbHGo/oCG/Z6nJ
	W9Gfwh3yQ4pKutm6XHrRxcHeRDZj4c4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758803422; a=rsa-sha256;
	cv=none;
	b=IKZyOTMSrD4r1y2aN16Nn1cUlqzWa0Q/l0Hhc5H6PHPb1pu86mvo1lXOQFToh7z/L0lKRx
	eQ0o5GYte/y985G/cc7O3WWk/ILKN5vjMeuALkVofWqt0zkZoBrxJM9K7Yxfelg95QjirQ
	C0bBgKm2TCWzBQijGyhrX2hp5VXozDQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kB1WaJZi;
	spf=pass (imf24.hostedemail.com: domain of andybnac@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=andybnac@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61feb87fe26so1165421a12.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758803420; x=1759408220; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cpogRHSrLfl51nWywJppLMZXYXi2KQs1G3uCf0+H8cQ=;
        b=kB1WaJZixjHCJzCz6pJhbflIf2g99uRKfnFu0QiHGmmlGwKYEBTeDBWbCyioaA1gju
         4JI7AtXQ/9bQjjJ+yWbO0oOa4+R1ZHX1wbm72+KTh3SLQAlBIT0ikYByPpa2NsSS3qir
         7r0J+6ykUjj9zGNlnQWXH/VE3rYtoQ3j0/suRbtSxfVsbPbpLzNZ1x9IeBU0nbboc3j/
         /eYjKq4qoahgACs8HRWm0KGGrX+3vdwNqP+amlxJhV9iJn2yNgMv0bnKXkg3Yku6hziS
         9lxWXlZ01szEHBfK23dnUoeMKWBtqW3daPq995uEOQHVBREDyTKOWdeot6qF72pZ6bzx
         gR2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758803420; x=1759408220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cpogRHSrLfl51nWywJppLMZXYXi2KQs1G3uCf0+H8cQ=;
        b=QrgUmU4tXk83kKz/KnXmNigPbIL1ZT3XHdU73VVG97nqVVtBSGU4jUWoDxMK/e3nnG
         Gz/ok5X7gxAts+UgUo+3A2CDWQq956rR2r4xRrcd7dHds/j15LxtX9wRoJaHXsG4YVe4
         QHHyrBihAC0vPaDM3apynh+q0x4yJVRWBxTr2RGWMyZuJAA3r+UXBof+2Qb/SuL1VdMi
         nQp0z7OHTrL8SAZvtkwX/FlWOskiWlDt7ZfJMyGE0eadmlEl83tl8sw6XXc0I0LrOX8L
         md2ft8hVfMkyvSaIp8EaO1wR33RaYI4KPNwUoQrlMaMjU8f9CwKxVRahPG5GuKt3NdBN
         eyIA==
X-Forwarded-Encrypted: i=1; AJvYcCX1lFiKCiJMw20zpjwTchoERkJVCTmRCPnFTvuVopq5KjHNkLr7HQRMeTxnHxIdBIEZjKGABW1X6A==@kvack.org
X-Gm-Message-State: AOJu0YxEbO9I94xdWxEuXoxCExxk7ChHvjOCqJRK1MDiYQyA9DDWFdSg
	KmT7OB8Da6xQUrLsO4pEz72rb6I+N6T8yo1VO+W2o8LDruu7lzlfUj+aVm8AOzNsRjJd+WrSTSN
	wy0g05GUaVBIANnI09BXDQEgT4C2aoNg=
X-Gm-Gg: ASbGncv1rWhamHJF1zgka/Dl0QM+U1I666W84Xb0gSnk/hGt8NoxFS0dBpLdErOmoiK
	Zidvdu0cygMdY3LgG8wFVMcKI5RQvPGuio+brl1stcRFXu3nKktoS3Hoh31pYks5dbI5rgXefeC
	Krq1CiJ7VDUX1TR3VY3zapLh6DLij4/fUrB6e72KvwMJ/dn5VTOxR+KJsEeDxKJArnfErMr2FX9
	kV9
X-Google-Smtp-Source: AGHT+IGrMTtF3rO6PyqglimJ6kWsoCOnyf9RbZPnOG2/Nl32fMXOunJIE5E6zYa1d9+08xohVhzghLhulRn9g+pvf4U=
X-Received: by 2002:a17:907:3f87:b0:b09:2331:f150 with SMTP id
 a640c23a62f3a-b34b84aba85mr396036566b.16.1758803420120; Thu, 25 Sep 2025
 05:30:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
 <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org> <aNQ7D6_ZYMhCdkmL@debug.ba.rivosinc.com>
In-Reply-To: <aNQ7D6_ZYMhCdkmL@debug.ba.rivosinc.com>
From: Andy Chiu <andybnac@gmail.com>
Date: Thu, 25 Sep 2025 07:30:08 -0500
X-Gm-Features: AS18NWByhWo0dHTSYL4t2oFRcok3gmrZ-pBxSOOqriMBIQLUznFC4iXNOpyJQRE
Message-ID: <CAFTtA3Nxq0UmXcuN7jmQOiuTbrenKbR4ihH027ya1WWybgLq4Q@mail.gmail.com>
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
	Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com, 
	richard.henderson@linaro.org, jim.shu@sifive.com, kito.cheng@sifive.com, 
	charlie@rivosinc.com, atishp@rivosinc.com, evan@rivosinc.com, 
	cleger@rivosinc.com, alexghiti@rivosinc.com, samitolvanen@google.com, 
	broonie@kernel.org, rick.p.edgecombe@intel.com, 
	rust-for-linux@vger.kernel.org, Zong Li <zong.li@sifive.com>, 
	David Hildenbrand <david@redhat.com>, Heinrich Schuchardt <heinrich.schuchardt@canonical.com>, 
	Florian Weimer <fweimer@redhat.com>, bharrington@redhat.com, 
	Aurelien Jarno <aurel32@debian.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8pq5tu5p4hzask9gaqsnmhk8pw73hbwe
X-Rspamd-Queue-Id: 37E14180018
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758803421-941000
X-HE-Meta: U2FsdGVkX1+OC7XX48p/ydNGK6dLBCsSeZo5RLXr63IK1O1CJesTh7LwqFzcATcf05seUqVh5pgUz8ZUAMflgjGG4MYOjIe1qzhwzlKIiXuYG3e9hTMmpVy9iYfUEkZP1SxUirzIkAcWTfMmk8aFiUckhvIL7uH2jLDHHfPDyfuyea2uKkzRiRqw7YupA1iVaIlEsZJobtU72+tDKYZd2UlKCf6HRRWtYT5CDAFwVJNwR8JxVU0LWE2unHSOM+H+dJlzwIzKkyGze6Dh2F3OiPm1R+vcVyTnGJAj6NQiBxAUkFhAqjQCQ1sqVILLQ0saOrBDb0KyCLQiZl3hAsla6cNNikVrffiTMX7MhBbgHUbFxF3kDBxo/MYNz+RwTDjO1N7RKY87qEAvN6D/17EkTfF5Oc0O8KHHoc8I6uSLkyIYKV87TPE6CGUVAnV8L5piD7vhCPHIbDFrMcr+CE3Afy1acm1M2tyvHFgQ1r07mocfz+KNFWvoQLd/CcnRj+kjS/fP/4zujK0PI6WfSWNKS61+BzNj17G9Gmd3VRn87m9uYYkLh4870J5K3x/GBPsGOfXfVLukOiesfQ6yVnysAd5sHM/oro+SLIjDrs4ER5wQQRMxvlf2wWYcfh/2dfhaWypuhsnnAM6kSMwRDAZX1hiD30xSfxHdojnEyJ6+M4s2Cuns+cHwVQtj2h/AJuy+F9gLpTDvk47WCkV3uNC46J+8I/hDFBAEmvtWfupaEnMRPoE9PLv/9vVGQBU9seNVxPPhd0Pi39QLy+ahWBKZS3fYMUnhcQpsnHvoAwv7VmJfBrS0Ew+bwYJRvK0xq3h2tEmbO8pGDWyN931wsQ4V5bmzqWIFyft2ICsd/swqKPVh+HYBuQNBnjHRyI83BEStI0OyTXZnTJWEFwCTVVBvIsSUErLuXxEiYPye69TQgYnw5qyeM/Wp+RWPjbDoN4Bjnh4PdQ0P0kghopG/dhF
 2OtQBCtE
 pfmYi3F2tQ/8ItfkO3nqxx3dZ1Y8hO0sFqa0+9zK3k5STZVMzVo+FLOfP6zdGodl+vrB1OszAvEn8I4e04wR8NNmSGFZcoX1QLi3U/DjvZVP7BL13hkXEx15yshGFmtgxWwVNSOHLmQf2GAlcGNrv+Sqs6kwS7JOwkDsDs7otE1EnoW+BmVqDra6UOzvN8sU4w67WagqHugP/gjfNKsG1IXXcIKayqs5g10bgr/dAtPluibftuZucfkciwud9LM/3dYeuEmPhft1+/BJ6WyPwkcCz3OqIcVQCaAJigYXU2fjXJ++ClqKIGg+0p+slJcMLGjJMCqswr4RmkOzbqhCB1mEAN0gjH0Ain2IMXH0wTfHKo5CpxiryoL2ACA5qXmlEmd6RmOS5YRRTJCj12e5ZD+Vohx/Ff+3sMkAnqVs0EybYVP9pyImcGBHLRaanGCle9iBQZPFvmWG7IhpY60hQYGWzUn27hZ8StKtM1TFfcROcmk4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Deepak,

On Wed, Sep 24, 2025 at 1:40=E2=80=AFPM Deepak Gupta <debug@rivosinc.com> w=
rote:
>
> On Wed, Sep 24, 2025 at 08:36:11AM -0600, Paul Walmsley wrote:
> >Hi,
> >
> >On Thu, 31 Jul 2025, Deepak Gupta wrote:
> >
> >[ ... ]
> >
> >> vDSO related Opens (in the flux)
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> I am listing these opens for laying out plan and what to expect in fut=
ure
> >> patch sets. And of course for the sake of discussion.
> >>
> >
> >[ ... ]
> >
> >> How many vDSOs
> >> ---------------
> >> Shadow stack instructions are carved out of zimop (may be operations) =
and if CPU
> >> doesn't implement zimop, they're illegal instructions. Kernel could be=
 running on
> >> a CPU which may or may not implement zimop. And thus kernel will have =
to carry 2
> >> different vDSOs and expose the appropriate one depending on whether CP=
U implements
> >> zimop or not.
> >
> >If we merge this series without this, then when CFI is enabled in the
> >Kconfig, we'll wind up with a non-portable kernel that won't run on olde=
r
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
> After patchwork meeting today, I wanted to continue discussion here. So t=
hanks
> Paul for looking into it and initiating a discussion here.
>
> This patch series has been in the queue for quite a long time and we have=
 had
> deliberations on vDSO topic earlier as well and after those deliberations=
 it
> was decided to go ahead with merge and it indeed was sent for 6.17 merge
> window. Unfortunatley due to other unforeseen reasons, entirety of riscv
> changes were not picked. So it's a bit disappointing to see back-paddling=
 on
> this topic.
>
> Anyways, we are here. So I'll provide a bit of context for the list about
> deliberations and discussions we have been having for so many merge windo=
ws.
> This so that a holistic discussion can happen on this before we make a
> decision.
>
> Issue
> =3D=3D=3D=3D=3D=3D
>
> Instructions in RISC-V shadow stack extension (zicfiss - [1]) are carved =
out of
> "may be ops" aka zimop extension [2]. "may be ops" are illegal on non-RVA=
23
> hardware. This means any existing riscv CPU or future CPU which isn't RVA=
23
> compliant and not implementing zimop will treat these encodings as illega=
l.
>
> Current kernel patches enable shadow stack and landing pad support for
> userspace using config `CONFIG_RISCV_USER_CFI`. If this config is selecte=
d then
> vDSO that will be exposed to user space will also have shadow stack
> instructions in them. Kernel compiled with `CONFIG_RISCV_USER_CFI`, for s=
ake of
> this discussion lets call it RVA23 compiled kernel.
>
> Issue that we discussed earlier and even today is "This RVA23 compiled ke=
rnel
> won't be able to support non-RVA23 userspace on non-RVA23 hardware becaus=
e".
> Please note that issue exists only on non-RVA23 hardware (which is existi=
ng
> hardware and future hardware which is not implementing zimop). RVA23 comp=
iled
> kernel can support any sort of userspace on RVA23 hardware.
>
>
> Discussion
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> So the issue is not really shadow stack instructions but rather may be op
> instructions in codegen (binaries and vDSO) which aren't hidden behind an=
y
> flag (to hide them if hardware doesn't support). And if I can narrow down
> further, primary issue we are discussing is that if cfi is enabled during
> kernel compile, it is bringing in a piece of code (vDSO) which won't work
> on existing hardware. But the counter point is if someone were to deploy
> RVA23 compiled kernel on non-RVA23 hardware, they must have compiled
> rest of the userspace without shadow stack instructions in them for such
> a hardware. And thus at this point they could simply choose *not* to turn=
 on
> `CONFIG_RISCV_USER_CFI` when compiling such kernel. It's not that difficu=
lt to
> do so.
>
> Any distro who is shipping userspace (which all of them are) along with k=
ernel
> will not be shipping two different userspaces (one with shadow stack and =
one
> without them). If distro are shipping two different userspaces, then they=
 might
> as well ship two different kernels. Tagging some distro folks here to get=
 their
> take on shipping different userspace depending on whether hardware is RVA=
23 or
> not. @Heinrich, @Florian, @redbeard and @Aurelien.
>
> Major distro's have already drawn a distinction here that they will drop
> support for hardware which isn't RVA23 for the sake of keeping binary
> distribution simple.
>
> Only other use case that was discussed of a powerful linux user who just =
wants
> to use a single kernel on all kinds of riscv hardware. I am imagining suc=
h a
> user knows enough about kernel and if is really dear to them, they can de=
velop
> their own patches and send it upstream to support their own usecase and w=
e can
> discuss them out. Current patchset don't prevent such a developer to send=
 such
> patches upstream.
>
> I heard the argument in meeting today that "Zbb" enabling works similar f=
or
> kernel today. I looked at "Zbb" enabling. It's for kernel usage and it's
> surgically placed in kernel using asm hidden behind alternatives. vDSO is=
n't
> compiled with Zbb. Shadow stack instructions are part of codegen for C fi=
les
> compiled into vDSO.
>
> Furthermore,
>
> Kernel control flow integrity will introduce shadow stack instructions al=
l
> over the kernel binary. Such kernel won't be deployable on non-RVA23 hard=
ware.
> How to deal with this problem for a savvy kernel developer who wants to r=
un
> same cfi enabled kernel binary on multiple hardware?
>
> Coming from engineering and hacker point of view, I understand the desire=
 here
> but I still see that it's complexity enforced on rest of the kernel from =
a user
> base which anyways can achieve such goals. For majority of usecases, I do=
n't
> see a reason to increase complexity in the kernel for build, possibly run=
time
> patching and thus possibly introduce more issues and errors just for the =
sake
> of a science project.
>
> Being said that, re-iterating that currently default for `CONFIG_RISCV_US=
ER_CFI`
> is "n" which means it won't be breaking anything unless a user opts "Y". =
So even
> though I really don't see a reason and usability to have complexity in ke=
rnel to
> carry multiple vDSOs, current patchsets are not a hinderance for such fut=
ure
> capability (because current default is No) and motivated developer is wel=
come
> to build on top of it. Bottomline is I don't see a reason to block curren=
t
> patchset from merging in v6.18.

Sorry for reiterating, I have been gone for a while, so maybe I lost a
bit of context.

In that case, should we add a comment in the Kconfig that says "it
breaks userspace on older-than RVA23 platforms"?

Perhaps a very ugly way to make RVA23-compiled kernel compatible with
pre-RVA23 platforms is to decode maybe-ops in the illegal exception
handler...

Btw, I don't think kenrel-level shadow stack should be an argument
here, as kernel-level APIs are more flexible by nature.

Thanks,
Andy

