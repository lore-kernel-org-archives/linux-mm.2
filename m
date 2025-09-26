Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDA7ECAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 21:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA5A8E0005; Fri, 26 Sep 2025 17:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA438E0001; Fri, 26 Sep 2025 17:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72598E0005; Fri, 26 Sep 2025 17:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 878EB8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:07:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20EED43F25
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:07:13 +0000 (UTC)
X-FDA: 83932636746.21.4E41EDE
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 260754000B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:07:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=baOUYwMk;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758920831; a=rsa-sha256;
	cv=none;
	b=o5khxOPOnVSE92pW1wc4n4Ani5JTO77ONpIdOLU5yZVQcQw1bMLM8qu6gfuQB/moU/8S9R
	7AVdFSyN8sh8W0US5T1wGz6UiY/hHksQkF5STFzFeLmXwWL6YYaV9YIRqS5v2yO6SCdrqS
	YiCvc0hJilFRtsICEUXTIkkX2Yr0aEU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=baOUYwMk;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758920831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KnypQUg3EKrzG9RmKnVPYdoI8/tvp78hXYQJseWkeXU=;
	b=3juQ+pqNv4429OyD3N24h2AXlpRLjeCrmVxVi8p8F4JkAVyyO8Lz3sVLh3qOBcDx3Mlp1K
	NMvolX3WbiEhzevGz0kyetf46Anep0hafLbU24W7/zgic4pXHTzHVmVd0bkkrIjyHrDDjj
	YrQE80BV+zId7jlf9IPBVvaeWX+obXU=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7811a5ec5b6so810773b3a.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1758920830; x=1759525630; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KnypQUg3EKrzG9RmKnVPYdoI8/tvp78hXYQJseWkeXU=;
        b=baOUYwMkgcozTnEhp9B9xTgSG6/B1NvI5ROfDpZINWf+BGJRycSuXqkWVz/4u919hA
         YHGesymYp2fUy1Qd2SmmDjRimAhl9/6JeWA2K9zDB3jy6GAWT6Wk+463JI9fZviduUp/
         eb4sg7qCELEBiisVQhVK9wfGGsHx3976JGcZoW85bsmM+/LCap9EZRh5agNw9BqvLQfK
         amazld0fgysUyGTno33GqSowou1fXaIBtY8nUrQzKoTi2oW2r18zXbnttlKhYV5mSj5y
         13EYsuZSi5r6FQRBxmMXV1eVxCrqKLZ5ISiit8HHcc7Ok3b1E1rM5XfVC0O6t5zkELN9
         xmXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758920830; x=1759525630;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KnypQUg3EKrzG9RmKnVPYdoI8/tvp78hXYQJseWkeXU=;
        b=Oo4uIWAxGgThzy87zSIGX7J+lA/JScmfDBArKAc7PTlf39BbxcVGzpBz6UMTRT//gt
         P9M+Hm8yr8pLdXWRxJWlKbetqPb1fRcqcCXI+CB5HnKewv/JDwa8HcgBamA4Cj4nki8M
         eA6kRp5rFLrKu7qpBGYZ5REW5fmmJEhXZOAoLv+Zng5FjB9HKvflRvOZLHPYV22NnMg0
         1V36YCjGv8PhMRRswwuWDFWQruE2GYN33glP9kUiMtZUXW14MjfB6rp3stPMFkFXk7H8
         ZZUR/W097CqQoy7rkNNSptNHygJu/ZCTKcLBnjjKdQPZyKSzhnGHc02Id/DH2RMi9avo
         QumQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMTQA2u+li/eGaNqUSXmL+h0ydNI5TC5xQ0iuM1RGM24LqCuG5UrHqftERknJ4hTJvSM0gzA6RlQ==@kvack.org
X-Gm-Message-State: AOJu0YwhHKL20IwrnLyKFNCQ4gu787GQkAwExOjgd4CXY95I5F0ulIl/
	8D28VQcsPKtGFlSnaqQGNosOfM8V5O8Rsz0gCwBaHWGfvQPF4PDk7T/zp3Nv1wUw4c8=
X-Gm-Gg: ASbGnctbxDJ658orY2Sq8esUSyq6/8TjlwoKvFeZBTxXPcOW++e2sP7MN4Xt3XSq5at
	D4ZX1VuiCdmRU7I4asD/sCoaRDnPxkM67uczIGAco5l1V7VCqhxFc3vi+1L58RhLHc5M64LGkRC
	vsUABrSuCSs3IQBHKnCnZq8Z8HlnifvsFy/syZ3SGWz2cKbCHyZ66yp2HtqFd5WZ1EJlJbdUNpf
	DQU5ZaY/73PHLcPRy2C5H+Z0Riw2gok0p5JBlKsNp/FainV80jnIxr9G1KH1mYWzl+LDGNigdYw
	/ycmH1AcCSS/cMYWBD/h43DQ2O3HHUQQ/kXC8SYFE+2sZfZ6f42+rR8UtQ+ZLDhNDMRTNKyNuP+
	09zGWLvAyXXlhIR1U84ekz6usbghDngLX4HXXKzsSVCI=
X-Google-Smtp-Source: AGHT+IHn6NeY5dtoWojDFn95+d6BgY2U1yoTg8Yib4J+bRdePmMEhyGi2ikTPsB6k/JjLKsrf4UQUQ==
X-Received: by 2002:a17:90b:17ce:b0:32e:7340:a7fe with SMTP id 98e67ed59e1d1-336b3ca1d27mr750014a91.12.1758920829689;
        Fri, 26 Sep 2025 14:07:09 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c55a2c45sm5436382a12.45.2025.09.26.14.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 14:07:09 -0700 (PDT)
Date: Fri, 26 Sep 2025 14:07:06 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Charles Mirabile <cmirabil@redhat.com>
Cc: pjw@kernel.org, Liam.Howlett@oracle.com, a.hindborg@kernel.org,
	akpm@linux-foundation.org, alex.gaynor@gmail.com,
	alexghiti@rivosinc.com, aliceryhl@google.com,
	alistair.francis@wdc.com, andybnac@gmail.com, aou@eecs.berkeley.edu,
	arnd@arndb.de, atishp@rivosinc.com, bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com, bp@alien8.de, brauner@kernel.org,
	broonie@kernel.org, charlie@rivosinc.com, cleger@rivosinc.com,
	conor+dt@kernel.org, conor@kernel.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, david@redhat.com,
	devicetree@vger.kernel.org, ebiederm@xmission.com,
	evan@rivosinc.com, gary@garyguo.net, hpa@zytor.com,
	jannh@google.com, jim.shu@sifive.com, kees@kernel.org,
	kito.cheng@sifive.com, krzk+dt@kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, lorenzo.stoakes@oracle.com,
	lossin@kernel.org, mingo@redhat.com, ojeda@kernel.org,
	oleg@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com,
	peterz@infradead.org, richard.henderson@linaro.org,
	rick.p.edgecombe@intel.com, robh@kernel.org,
	rust-for-linux@vger.kernel.org, samitolvanen@google.com,
	shuah@kernel.org, tglx@linutronix.de, tmgross@umich.edu,
	vbabka@suse.cz, x86@kernel.org, zong.li@sifive.com
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
Message-ID: <aNcAela5tln5KTUI@debug.ba.rivosinc.com>
References: <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
 <20250926192919.349578-1-cmirabil@redhat.com>
 <aNbwNN_st4bxwdwx@debug.ba.rivosinc.com>
 <CABe3_aE4+06Um2x3e1D=M6Z1uX4wX8OjdcT48FueXRp+=KD=-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABe3_aE4+06Um2x3e1D=M6Z1uX4wX8OjdcT48FueXRp+=KD=-w@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 260754000B
X-Stat-Signature: ak5d81ofasgmxipjaxifigcrh1bn1184
X-Rspam-User: 
X-HE-Tag: 1758920830-303121
X-HE-Meta: U2FsdGVkX1+r5KSu6CKwxl5W6mGZ8PBtS4hiPkCpAXYS0zfepdcx/jALoqxCqn1Kw2tnwKcqb3z90UKNfz8nqeaBI9QBIDLMW7rTldd4nmaktwSFpGqG8si5Tx9MYqmeiD+Nqts0GlkQjDukgDuIQ1WTu30seoXM/CnzYqwAgJi4tNYXLK2cwIzGwQROAjk0nsox1VMzuG2Ipv2EIP5gdWbEj1uHlNs3bsII7Z2qYplPotUlj3A+RuDqKuRS9gvPIEfb4VdRntvxY2vK74VKqVUCjr9fEqoAMACQCtASEzFPLQI6nuCx/s95jdDkG+x26tth9bCbEs9e/5QkCBP1aPL5EcCtXf6GnYuvaB3jM51VrxDrcJD6DxI/d9epB0azOHwFnUXnEtDnhdlEytJwSwTu7b1IUZGFXyNuWJ9td+vt7ArdBnVU9peg3I/Bh4hbKQynNVdK5pKqjqRdq49EFUwSBYU5elwl9YlaKhfzn2kpVK6tU/W0sT++cnCrKRZnxCnKIVAbAQmT7OwV70ZjPWvCLWUFWxBQgPa5j3djC1a3iE4H1ig/XwKWlnTaW6TUmaF3ZPBu4wD+FkR1OahkBn0Rhgu4inoDxdnPUsQoahhnC6QCndhxvUNMUzq373xNf9aDlHr1mTEBAHJf5j2HeKFYOFAPhFGk97FpGYldkWhSuvVhcJdXKbmCNAzCjhKQLlHUIc9t9rjv6i+fwm4Fj1epGRk9Za2vQP7wOr8N5Eyqhk9/5i0Updp8LGCl00VTYXrnuN+LtIm5vvcQDC48352D3FA110gIFbLryD0w0T7nsPIAntWXdUmwa2Hot8/Z/LwenynEqlPJy55LPPeKy1qjKMc643dr+A/FafCKusc5gxkWyapNXMKJzUWHcaoNEO0D7901EZ8mzjyCyP5XjB2GA8Gzllp3yRBPJRY9SoFmMWsoOnCNwfT1FO4pWcz/MVvLVWcBh0mpiQMOWhU
 HERR8i9R
 VgQ4OFS6PasCICrBobLplwOp7gk85GZoX4vtGC4ljNmu8LX9e01xFZk587tHMfnlhG19N6KAXuCXDGYBAruo5uegI9238QbNzcLTiVNs7wEzW8W76l592lsp4/SGyTJjL4OVOH/1uCguu3Qh9I4YidciP2ft+rEwErAEQGramXgonNqj8Cz4HohxOD+/J2yvu7B89hCJhRqTmTKJZXd2J3TGqWew33T194PZjPmeBOK0odjx2pfTwzJdsXqWAtp1a5IdpGvUeR18qE3x7Sr3kmT0+2QkxRlriqPGm2gLYmZCEXbunS4DkCoZxqlh4ZdAcjt9mXYcGGLUFgXV8PrTZvGh6RrkxKxWk8gDftueE/Srb7mYxYAcCBr2kAVr2agpxasdCRPIT9C/0H2KlwUqvpe6iPKjp1VyGGr8OtCngJepgTbndHI13dEk7cSRuZ3soYiVA+jBCJmN39bhcALSdkL53OeUBSw5Pm9wy9kp0Z554wSg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 04:28:58PM -0400, Charles Mirabile wrote:
>Hi Deepak -
>
>On Fri, Sep 26, 2025 at 3:57 PM Deepak Gupta <debug@rivosinc.com> wrote:
>>
>> Hi Charles,
>>
>> Thanks for response. Rest inline
>>
>> On Fri, Sep 26, 2025 at 03:29:19PM -0400, Charles Mirabile wrote:
>> >Hi -
>> >
>> >Hoping that I got everything right with git-send-email so that this is
>> >delivered alright...
>> >
>> >Wanted to jump in to head off a potential talking past one another /
>> >miscommunication situation I see here.
>> >
>> >On Wed, Sep 24, 2025 at 08:36:11AM -0600, Paul Walmsley wrote:
>> >> Hi,
>> >>
>> >> On Thu, 31 Jul 2025, Deepak Gupta wrote:
>> >>
>> >> [ ... ]
>> >>
>> >> > vDSO related Opens (in the flux)
>> >> > =================================
>> >> >
>> >> > I am listing these opens for laying out plan and what to expect in future
>> >> > patch sets. And of course for the sake of discussion.
>> >> >
>> >>
>> >> [ ... ]
>> >>
>> >> > How many vDSOs
>> >> > ---------------
>> >> > Shadow stack instructions are carved out of zimop (may be operations) and if CPU
>> >> > doesn't implement zimop, they're illegal instructions. Kernel could be running on
>> >> > a CPU which may or may not implement zimop. And thus kernel will have to carry 2
>> >> > different vDSOs and expose the appropriate one depending on whether CPU implements
>> >> > zimop or not.
>> >>
>> >> If we merge this series without this, then when CFI is enabled in the
>> >> Kconfig, we'll wind up with a non-portable kernel that won't run on older
>> >> hardware.  We go to great lengths to enable kernel binary portability
>> >> across the presence or absence of other RISC-V extensions, and I think
>> >> these CFI extensions should be no different.
>> >
>> >That is not true, this series does not contain the VDSO changes so it can
>> >be merged as is.
>>
>> Look at patch 23/27. It does have vDSO change. Although shadow stack
>> instruction are inserted as compiled flag for vDSO only when cfi config is
>> selected by user. Right now default is "No". So it won't impact anyone unles
>> user explicitly says "Yes".
>
>Yes sorry I caught that after hitting send and replied to my own email
>(but then I said 19/27 instead of 23/27 *facepalm*)
>
>>
>> >
>> >>
>> >> So before considering this for merging, I'd like to see at least an
>> >> attempt to implement the dual-vDSO approach (or something equivalent)
>> >> where the same kernel binary with CFI enabled can run on both pre-Zimop
>> >> and post-Zimop hardware, with the existing userspaces that are common
>> >> today.
>> >
>> >I agree that when the VDSO patches are submitted for inclusion they should
>> >be written in a way that avoids limiting the entire kernel to either
>> >pre-Zimop or post-Zimop hardware based on the config, but I think it
>> >should be quite possible to perform e.g. runtime patching of the VDSO
>> >to replace the Zimop instructions with nops if the config is enabled but
>> >the hardware does not support Zimop.
>>
>> Why kernel need to do this extra work of carry two binaries and patching it
>> runtime?
>>
>> If for instance we do this, and then this allow this kernel to be taken to
>> pre-Zimop hardware, it is assumed that entire userspace for such hardware
>> was compiled without shadow stack (thus no zimop). In that case, kernel
>> should have been compiled without CFI option.
>
>You raise a good point, it just breaks the tradition of runtime
>detection and backwards compat that has been the standard for riscv
>extensions in the kernel so far.

riscv (and others arches) have been able to do that because of "alternatives".
It's just that due to composable nature of riscv, alternatives are just spread
everywhere in the code and feels like riscv is doing something unique here.
Whenever there is a surgical placement of certain instructions in kernel, it
could be hidden behind alternatives and be patched in runtime.

However situations where instructions are emitted as part of codegen, there is
no hiding. Either it works or it doesn't. If we have auto vectorization enabled
in usermode, such a binary won't run on hardware which doesn't implement vector.

In case of shadow stack, it similar situation. If enabled compiler decides to
insert sspush and sspopchk. They necessarily won't be prologue or epilogue but
somewhere in function body as deemed fit by compiler, thus increasing the
complexity of runtime patching.

More so, here are wishing for kernel to do this patching for usermode vDSO when
there is no guarantee of such of rest of usermode (which if was compiled with
shadow stack would have faulted before vDSO's sspush/sspopchk if ran on
pre-zimop hardware)

>
>It would be nice if a kernel could be built that would run on both
>pre-Zimop and post-Zimop hardware and be able to offer CFI to
>userspace when running on hardware with Zimop (and Zicfiss / Zicfilp)
>but agree that it is a burden.
>
>>
>> Just for sake of thought exercise, let's say Fedora 43 is first release with
>> RVA23 compatiblity (zimop and shadow stack), there is no way this and future
>> release will be able to run on pre-zimop hardware. Unless redhat is going to
>> start two different binary distribution. One for pre-zimop and one for
>> post-zimop. If that would be the case, then compiling two different kernel for
>> such two different hardware would be least of the worry.
>
>It would be one thing if there were hardware supporting
>Zimop/Zicfiss/Zicfilp readily available, but I am not aware of any

And that's the reason currently default is "No" for cfi config in kernel.
Hope is whenever we have hardware, we can start lighting up and take decision
how to proceed. I keep reiterting, door isn't closed yet but we gotta approach
the door.

>platform other than qemu to test this code. 

I have tested this with qemu in following configurations

qemu implements cfi extensions:
Kernel with cfi enable is able to host userspace with and without cfi compiled.
Kernel with cfi enable is able to host userspace with cfi but disabled (default
to zimop)
Kernel without cfi enable is able to host userspace with cfi (default to zimop)
and without cfi.

qemu doesn't implement cfi extension:
- Kernel without cfi enable is able to host userspace without cfi compiled in.
- Kernel without cfi enable hosting userspace with cfi compiled in faults in
   libc/ld on first sspush.
- Kernel with cfi enable trying to host userspace with cfi faults in libc/ld on
   first sspush.
- Kernel with cfi enable trying to host userspace without cfi faults in vDSO on
   first sspush.

Last case is the only breaking case, rest all compatibilities stories work.
In order to solve this last compatiblity story, I am fearful that we might be
adding un-necessary complexity in kernel which isn't desired because rest of
the userspace won't be signing up for that complexity of patching and making
it work with single binary.

> Since it breaks
>compatibility with hardware I am not sure anyone will be able to do
>anything with this config option and it moves the burden on to each
>distro to go in and specifically enabling it vs just making things
>work to get important security improvements if the hardware has
>support and not if it doesn't in a backwards compatible way.

I wished that shadow stack instructions came out of HINT space. But it is
what it is. Perhaps distro should give this feedback to RVI. But here we
are.

zimop is backward compatible only RVA23 onwards. That's why it's important
for distro to make a decision on this. Once they compile for RVA23 profile,
it assumed a clean break from previous hardware. Future extensions will also
take encodings out of zimop and thus I believe its better to take that decision
now with first user of zimop.

>
>>
>> Only other usecase is of a seasoned kernel developer or build your own stuff
>> in embedded environment, those users can anyways are advanced users. But it
>> forces complexity on rest of kernel. There will be more extensions taking zimop
>> encodings in future, we will end up patching vDSO and keep this complexity
>> while rest of the userspace will not be patched and will be separate binary
>> distribution (if OS distros endup distributing multiple binaries per release)
>>
>> >
>> >However, that concern should not hold up this patch series. Raise it again
>> >when the VDSO patches are posted.
>>
>> As I said earlier, these changes default cfi config to No. So whenever this
>> is selected "Yes" by a distro, they can drive such patches (if there is a real
>> need)
>
>If we did the patching we could make this config default to yes to
>that you are building a kernel that is set up to be able to offer CFI
>when running on hardware which supports it as long as you have a
>toolchain that recognizes the extensions which I think would be good
>for moving this important security feature forward.

Again, Why kernel should be doing this when rest of the userspace isn't
patchable on pre-zimop hardware (thats the only scenario patching is needed)?

Are distro's distributing different binary for with autovec and without autovec
for different kind of riscv hardware?

Giving example of Fedora 43, once it is compiled in with cfi enabling, kernel is
also compiled in with the feature. Its not like there is going to "Fedora
43_rv64gc" release. If there is going to be a "Fedora 43_rv64gc" release, it'll
be much easier to no select CFI for that release's kernel compile rather than
kernel doing patching in runtime (rest of userspace is not doing any patching)

>
>>
>> >
>> >>
>> >> thanks Deepak,
>> >>
>> >> - Paul
>> >
>> >Best - Charlie
>> >
>>
>
>Sorry for stirring the pot on this. I really appreciate your work on
>this patch series.
>
>I agree that this is a difficult call, and I could see it going either
>way but I lean towards trying to maintain the backwards compatibility
>because the hardware doesn't exist yet.
>
>Best - Charlie
>

