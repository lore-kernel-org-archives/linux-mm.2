Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC119CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 14:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54D8E8E0008; Thu, 25 Sep 2025 10:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FDBF8E0006; Thu, 25 Sep 2025 10:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC228E0008; Thu, 25 Sep 2025 10:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7478E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:30:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C409D85C06
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:30:32 +0000 (UTC)
X-FDA: 83928008304.07.8832800
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9AADD18001D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:30:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=SAvgO61g;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758810630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/ScXH9deltQU9YLRjtGdHjjN9goLEMoCpX6Ad5jX+g=;
	b=B1vbQqRZegEFKna0Jln+1mQEq9ZGepowzMmipPB7Nl2DpGKltRMcTnFdgDB4uIIm21qGS0
	yfaHVONGw9nuuIZnBIxqlOTtBLW7yaSIBlQJ8mbJnlgqu+g7qXT3qtGQ1YHhXGD7Pxg7Wx
	xexgUbyZmB+XcN+fZg4uvR1MgwFlmAA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=SAvgO61g;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758810630; a=rsa-sha256;
	cv=none;
	b=SCqiiMKNaTHNUwSFjLueVWkfTYdeOEkpBlXwauB01Fl1UTGmXaDmnjo88pCyVkWpWOnirR
	PZo4lNb2Pgxdsl/Hp39wQGCTmHrvmI4cYQevcd+yyEszNELue+arS2SPKHbJw+jjDwanrP
	qSa43432dmd2ZgrLtI2C+rRgBPWcV/o=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-27ee55fa1c0so3911355ad.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1758810629; x=1759415429; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=B/ScXH9deltQU9YLRjtGdHjjN9goLEMoCpX6Ad5jX+g=;
        b=SAvgO61gFHX5sloGUUqkNNeulXhc7NUYFzOeXo2uzU1UaYYPFYQh9mj+pwywWPPuzP
         GLCsY4piiBix+6belEFYe7poCWvnCx6m2ZXW77Z+IHEJbUfYLRGaBGjYcJT7bWJXA4m0
         LKBpcuTR+cMeF7cwFmBnNFwrAacoGy3JdiQJCjLnUmYDjqKALIkdiC4stYnyI5UINp0t
         eNhiUs4k55fjIcEuSUTylPUyQfwuTM+oXT40E5lAw8+z8AuTLxJ/osE74hamM1qW+fh/
         7L3Z//bO3jRGcbmvlczSWOLvSo4HwO8DfKgV54+2GCGuGmfT//32CSyIDxbxyR7ri2+s
         9Sjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758810629; x=1759415429;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B/ScXH9deltQU9YLRjtGdHjjN9goLEMoCpX6Ad5jX+g=;
        b=H3vpoWMuCKnBy080ml23pmY9/OM3XQwIj+iEtKyYLXtsy3pVhFrSrhPDAj36N74o58
         sgyEJdPVAnNNOHt/+NSh1IPNzMPRPCRZIJ6Wc9VjYvcrDOIaoV7mgG7tw6eNj/RJneMT
         iCIW5qVS/3xmNoDQkXyVUfKSowDJ8PwL8FguddFSkslM4gt2ikaXuRVQgi9Ee76dpZHZ
         dNCnSzo42St+Nh/ZX+wNRIEAA0ufQZCYE4hLbUF8hrD7LnjHZ9IhLuVnE4H1KpHDQauC
         Lma9I8XQY5GSCCYhQxfjsPDIPGYrEPMscujSNkdo5FLhDDyyPPIRMeXckW/WBuNTdyoK
         3lZw==
X-Forwarded-Encrypted: i=1; AJvYcCVr/Y3sMKmrBnzjC6Vah8GZfSVJASsxbPFT6IsGsprXZGs0Xlra/+SkwbjacqbgPNgjhmKBX6UFHg==@kvack.org
X-Gm-Message-State: AOJu0YzFZvF+uA+2DPO1rebKuQyxz/cEZj+76Dn13qxCKZlQ9adSp5YD
	cOHpEVTW2GSfNBTYnfLwBbg0zvvewvWQekNbMNLRiaj2vgl7jNjmMvqIRTtjNEx5sps=
X-Gm-Gg: ASbGncs538/uUtKnMqjjlqe4i+P1pLIxpGZeS4iiIhEbLDT+CNBjRyB5V6ldLMs/xho
	u4h3dz/ani+9UVBthokFz4QUG7LgJr3DvTnDQ1S1fnZI41CjZcL+wvT0mBr/1RBzpn6WC2UQMyC
	n4su80VBcBnXCjci0q0qkQ1nGDnCnc2asNcPyGBzlHS2fh/hVYejZ5qlD+LGNMCXVAd7o8g+5sL
	6VBWf+oIM+xZpdZskOzr1iMiySRPjpdm/ewzIj7JRG+ZTh3wYH3IYvDavkoyrB0KHLcgon30csv
	tqXvkFlvE9IeRomxMRZhdhrwPoFFoEdZzAIqpM6Mn1CbK/rlxsNwhwbKS/6QvQpo9et8E33y08d
	gXoQvPwQqoH9lDYzGAuxTnG9dFpE9R/KD
X-Google-Smtp-Source: AGHT+IGw4nlcyMj0x1ophUEj8Naebsm2dV8OM2R6VcoSoV/iVH85aly4v8pa48kMi8x3QmjHpu5KEw==
X-Received: by 2002:a17:903:3845:b0:26e:7ac9:9d3 with SMTP id d9443c01a7336-27ed722bb71mr33822815ad.18.1758810628859;
        Thu, 25 Sep 2025 07:30:28 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed670f748sm27032895ad.42.2025.09.25.07.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 07:30:28 -0700 (PDT)
Date: Thu, 25 Sep 2025 07:30:24 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Andy Chiu <andybnac@gmail.com>
Cc: Paul Walmsley <pjw@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com,
	richard.henderson@linaro.org, jim.shu@sifive.com,
	kito.cheng@sifive.com, charlie@rivosinc.com, atishp@rivosinc.com,
	evan@rivosinc.com, cleger@rivosinc.com, alexghiti@rivosinc.com,
	samitolvanen@google.com, broonie@kernel.org,
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
	Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
	Florian Weimer <fweimer@redhat.com>, bharrington@redhat.com,
	Aurelien Jarno <aurel32@debian.org>
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
Message-ID: <aNVSAD4Og23rNTms@debug.ba.rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
 <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
 <aNQ7D6_ZYMhCdkmL@debug.ba.rivosinc.com>
 <CAFTtA3Nxq0UmXcuN7jmQOiuTbrenKbR4ihH027ya1WWybgLq4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFTtA3Nxq0UmXcuN7jmQOiuTbrenKbR4ihH027ya1WWybgLq4Q@mail.gmail.com>
X-Rspamd-Queue-Id: 9AADD18001D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: imwnryqhuc98bbdowugpqazrtikobi6c
X-HE-Tag: 1758810630-689692
X-HE-Meta: U2FsdGVkX19FyIyYOHIYqJMlOSvm36Ti3HXVHcwnp1jlof/pHItstgm3EvzRv5nenxdI0izfRs/CkioS7KpXoeBZRpKfQrvqmrIEmHSd+pY5cV75ntMG7WzPeqGoFcD9pkzHD2KuCapxI0xZ4SkqWzUpAYyZEAjOqQhDNdkcdo8ONarZnsT1+GxdrP8R6stKhnagfFeFyYQoydgDjWbyE4rMxVT/2WeO+38DR5XlMMK8vqpMp/oboxiM1ja1dWr90DhJrgAJpZv3KgzEjz7RhoigD65GVlXCx2yqWUUfEaoqh56ZdOJxoQ0fdhlRV1kUt3epGR7Ru73PbmdGJzZ5SgMGJkRDOZBn40dSqa7QHCQxgigVCJpZXeietlcBpeHhutUZuOX08EQAn7h512BdJitrccQXHULZMiBW5mMAkXDQcjQbyadM4X+y6XGUOAaWaookzF/OFpmEzDtfacS+LDyFuQWlgKdGe7Gyi09AHToTuMyfXobtg2dmFlPmk6f/xeHcOPAn47CLS0DoGVpExPzTaZMNUMlKxYg0ueiHE+OF+oVjhauDxG1tQtNuc6/Zal/VqfasnWD48eeNsU5ohU6NJ8F8o8ZqcLxw3TdoqAoBHOSLuhY4HaHgT1ELa0m1zxcLUFBsIpTAB1LBTRb2e3WOy8sWxKIAxOZqiJmfiNa2SH7skDSHcGYqvCMpkfi9FsL2KLmA/PswJrRQRqEcp1cvFXR4ZNW31hgF5dSO7QYJ6SzA083t83Crnj0ZKMT+gpVNDLm32Z++UON9bL5PTyHXgV01rfy2BlnPtDR6E1MzNHMTCYYASwxboxcBX3V3xoPcF1sBdp/iopDrGI7NI5bEfQrUbR8ahKgc4SWt5wBGs8yAgINEPPeQzSe6DD7gD7iAQk8KLoEZ+UbfB6xB2/hA0cpUtHwxdmC21N8th5UkGsPD/z7BgJGS/nwgt9pIpr09U84SLs1j+sGIZQ7
 IDIhp4Zt
 y+HGsGsJrFvejAvi3ftBVOPeYHwR9MaZNBINd0bY0VuUASz/8LUX9pr8VvdOcnP2/3RJgXlR93NxBOtYP5bzY+c+59yIiM7WxL+I+t/jHLsKkSEhJrCRuuUUX+yhxm91LqnrO8ydw+YCkibapwJJMpUUUq9p+FXPOitprp+1olZTrue5O78YZhRiBzC2h6MuohSpx3HtrKFclo38Ywh+v6IGU/k1sVlo+7cXhv7BnjpXlQVM90y0AHI/VxRWC/YtrOAt0pNAaO2lJ8Tll1du0/fleTlmTaEWVXssV7YGCge0BBlInsXOrwKms2uKAbViyfqIDU5l95wTKTu/ckVsQOOXxqjzn+7vcg43TZbD8ds2G1oquvBoH2nkJ5end+CJR6EYovVWZGuwARIvTXyAXj+f7p0GxhoNgGUUqiwzku6nUYZ25ey/Vt+/ZfL1Vi9CsroiN8inathBpenbT9R0EHEIygrdlIxBjBLYSIOHiicPDTUk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 07:30:08AM -0500, Andy Chiu wrote:
>Hi Deepak,
>
>On Wed, Sep 24, 2025 at 1:40 PM Deepak Gupta <debug@rivosinc.com> wrote:
>>
>> On Wed, Sep 24, 2025 at 08:36:11AM -0600, Paul Walmsley wrote:
>> >Hi,
>> >
>> >On Thu, 31 Jul 2025, Deepak Gupta wrote:
>> >
>> >[ ... ]
>> >
>> >> vDSO related Opens (in the flux)
>> >> =================================
>> >>
>> >> I am listing these opens for laying out plan and what to expect in future
>> >> patch sets. And of course for the sake of discussion.
>> >>
>> >
>> >[ ... ]
>> >
>> >> How many vDSOs
>> >> ---------------
>> >> Shadow stack instructions are carved out of zimop (may be operations) and if CPU
>> >> doesn't implement zimop, they're illegal instructions. Kernel could be running on
>> >> a CPU which may or may not implement zimop. And thus kernel will have to carry 2
>> >> different vDSOs and expose the appropriate one depending on whether CPU implements
>> >> zimop or not.
>> >
>> >If we merge this series without this, then when CFI is enabled in the
>> >Kconfig, we'll wind up with a non-portable kernel that won't run on older
>> >hardware.  We go to great lengths to enable kernel binary portability
>> >across the presence or absence of other RISC-V extensions, and I think
>> >these CFI extensions should be no different.
>> >
>> >So before considering this for merging, I'd like to see at least an
>> >attempt to implement the dual-vDSO approach (or something equivalent)
>> >where the same kernel binary with CFI enabled can run on both pre-Zimop
>> >and post-Zimop hardware, with the existing userspaces that are common
>> >today.
>>
>> Added some distro folks in this email chain.
>>
>> After patchwork meeting today, I wanted to continue discussion here. So thanks
>> Paul for looking into it and initiating a discussion here.
>>
>> This patch series has been in the queue for quite a long time and we have had
>> deliberations on vDSO topic earlier as well and after those deliberations it
>> was decided to go ahead with merge and it indeed was sent for 6.17 merge
>> window. Unfortunatley due to other unforeseen reasons, entirety of riscv
>> changes were not picked. So it's a bit disappointing to see back-paddling on
>> this topic.
>>
>> Anyways, we are here. So I'll provide a bit of context for the list about
>> deliberations and discussions we have been having for so many merge windows.
>> This so that a holistic discussion can happen on this before we make a
>> decision.
>>
>> Issue
>> ======
>>
>> Instructions in RISC-V shadow stack extension (zicfiss - [1]) are carved out of
>> "may be ops" aka zimop extension [2]. "may be ops" are illegal on non-RVA23
>> hardware. This means any existing riscv CPU or future CPU which isn't RVA23
>> compliant and not implementing zimop will treat these encodings as illegal.
>>
>> Current kernel patches enable shadow stack and landing pad support for
>> userspace using config `CONFIG_RISCV_USER_CFI`. If this config is selected then
>> vDSO that will be exposed to user space will also have shadow stack
>> instructions in them. Kernel compiled with `CONFIG_RISCV_USER_CFI`, for sake of
>> this discussion lets call it RVA23 compiled kernel.
>>
>> Issue that we discussed earlier and even today is "This RVA23 compiled kernel
>> won't be able to support non-RVA23 userspace on non-RVA23 hardware because".
>> Please note that issue exists only on non-RVA23 hardware (which is existing
>> hardware and future hardware which is not implementing zimop). RVA23 compiled
>> kernel can support any sort of userspace on RVA23 hardware.
>>
>>
>> Discussion
>> ===========
>>
>> So the issue is not really shadow stack instructions but rather may be op
>> instructions in codegen (binaries and vDSO) which aren't hidden behind any
>> flag (to hide them if hardware doesn't support). And if I can narrow down
>> further, primary issue we are discussing is that if cfi is enabled during
>> kernel compile, it is bringing in a piece of code (vDSO) which won't work
>> on existing hardware. But the counter point is if someone were to deploy
>> RVA23 compiled kernel on non-RVA23 hardware, they must have compiled
>> rest of the userspace without shadow stack instructions in them for such
>> a hardware. And thus at this point they could simply choose *not* to turn on
>> `CONFIG_RISCV_USER_CFI` when compiling such kernel. It's not that difficult to
>> do so.
>>
>> Any distro who is shipping userspace (which all of them are) along with kernel
>> will not be shipping two different userspaces (one with shadow stack and one
>> without them). If distro are shipping two different userspaces, then they might
>> as well ship two different kernels. Tagging some distro folks here to get their
>> take on shipping different userspace depending on whether hardware is RVA23 or
>> not. @Heinrich, @Florian, @redbeard and @Aurelien.
>>
>> Major distro's have already drawn a distinction here that they will drop
>> support for hardware which isn't RVA23 for the sake of keeping binary
>> distribution simple.
>>
>> Only other use case that was discussed of a powerful linux user who just wants
>> to use a single kernel on all kinds of riscv hardware. I am imagining such a
>> user knows enough about kernel and if is really dear to them, they can develop
>> their own patches and send it upstream to support their own usecase and we can
>> discuss them out. Current patchset don't prevent such a developer to send such
>> patches upstream.
>>
>> I heard the argument in meeting today that "Zbb" enabling works similar for
>> kernel today. I looked at "Zbb" enabling. It's for kernel usage and it's
>> surgically placed in kernel using asm hidden behind alternatives. vDSO isn't
>> compiled with Zbb. Shadow stack instructions are part of codegen for C files
>> compiled into vDSO.
>>
>> Furthermore,
>>
>> Kernel control flow integrity will introduce shadow stack instructions all
>> over the kernel binary. Such kernel won't be deployable on non-RVA23 hardware.
>> How to deal with this problem for a savvy kernel developer who wants to run
>> same cfi enabled kernel binary on multiple hardware?
>>
>> Coming from engineering and hacker point of view, I understand the desire here
>> but I still see that it's complexity enforced on rest of the kernel from a user
>> base which anyways can achieve such goals. For majority of usecases, I don't
>> see a reason to increase complexity in the kernel for build, possibly runtime
>> patching and thus possibly introduce more issues and errors just for the sake
>> of a science project.
>>
>> Being said that, re-iterating that currently default for `CONFIG_RISCV_USER_CFI`
>> is "n" which means it won't be breaking anything unless a user opts "Y". So even
>> though I really don't see a reason and usability to have complexity in kernel to
>> carry multiple vDSOs, current patchsets are not a hinderance for such future
>> capability (because current default is No) and motivated developer is welcome
>> to build on top of it. Bottomline is I don't see a reason to block current
>> patchset from merging in v6.18.
>
>Sorry for reiterating, I have been gone for a while, so maybe I lost a
>bit of context.
>
>In that case, should we add a comment in the Kconfig that says "it
>breaks userspace on older-than RVA23 platforms"?

Its quite apparant for whoever is compiling userspace for non-RVA23 hardware.
First sspush/sspopchk instruction in ld/libc will do illegal instruction. It
won't even come to vDSO's sspush/sspopchk.

But sure if that's what get these patches merged in, I can add that comment.

>
>Perhaps a very ugly way to make RVA23-compiled kernel compatible with
>pre-RVA23 platforms is to decode maybe-ops in the illegal exception
>handler...

Yes that can be done but that shouldn't gate current patchset from merging in.

>
>Btw, I don't think kenrel-level shadow stack should be an argument

Argument to block current patches is below
"Kernel should be binary portable". That's why I gave that argument.
A kernel compiled with shadow stack (kcfi) is not portable on non-RVA23
hardware.

Yes we can try making kernel portable by carrying two different vDSO.
One that is for non-RVA23 (actually non-zimop) hardware and one for
RVA23 hardware. But I don't imagine a distro shipping two different
userspaces (ld/glibc, everything) once they start compiling their
userspace with RVA23. If for an instance they start compiling two
userspaces, its not that big of an effort to compile kernel differently
as well. If for an instance they choose to only support rv64gc for
userspace then they are not opting anyways for CFI then just not select
that option in kernel compile. I just don't see a scenario where kernel
is forced to carry two different libraries while rest of the userspace
will not distribute two different binaries for same release.

>here, as kernel-level APIs are more flexible by nature.

I didn't get it. How kernel level APIs help with binary portability
of a kernel compiled in with shadow stack instructions to run on hardware
where these instructions are illegal?

>
>Thanks,
>Andy

