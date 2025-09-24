Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E97CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 18:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A0A58E000B; Wed, 24 Sep 2025 14:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477628E0001; Wed, 24 Sep 2025 14:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E178E000B; Wed, 24 Sep 2025 14:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 261258E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:40:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A7B7E13862E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:40:22 +0000 (UTC)
X-FDA: 83925009084.03.BBF1184
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id B320514000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:40:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=P+STIGlH;
	spf=pass (imf09.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758739220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmJ3vOxzWTYE+jCZQu9PTb3XdXqCFWVRNB5Wst4HaN8=;
	b=Mmja7MxSMLyrN8qfjLfC0eDlHpYRnqkFhwpGM8S05M9zv5zuXS3Fi3wmBGCjKraS4SuRZy
	WrgDrbGGIbrzY/cHaOvvkT4j1gUP93vAWNUw6Sh5AMoC4XEffjmBraJG6BVFGjwak3qNDn
	U/PY1wI4yL43ViVKot+p2reoC06E6+Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=P+STIGlH;
	spf=pass (imf09.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758739220; a=rsa-sha256;
	cv=none;
	b=QdS++38zgjgP8H7B5sz0XTAlaCqYhzHRwGY2tslWhpoZZ2KIcNO+W6t+vGuH/nnyFB1vxI
	0R3fwh8NLckCN+vaPALK+tCxpIsyWRmPYgOGtX3+Wza/m3iYXzCZWxiw8MKQmBv5/52obB
	hO/PBiGzIQ8WBUfb/UHqX/miT12HG4s=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24456ce0b96so1375245ad.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1758739219; x=1759344019; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CmJ3vOxzWTYE+jCZQu9PTb3XdXqCFWVRNB5Wst4HaN8=;
        b=P+STIGlHX2cq87I4uf0xJh0b0lUihFdmPaGvY7Wl2tPfWgAUXaIaAF5Wko2P16V22G
         wr2I5B/SaQkFyjxznHCDFDjNrPCO4YsQ2tWNaUv9ZI8Ys3/oMTSfXpawJiOICY+ovKp9
         OF4bTIoD3lcHiWGQtAnUBkJU08lCLLOpXxx11IoowQkRPaHgloPIMOeAHzaakfKuVjI7
         DgHfviz4Z70CzocPjcOPpo8Jy7hl/kgla/Bcv9TaCQdrM99YhJPBJxkbl/76umxf0YmY
         NZgLuEleE24qgdzG6YEnGBCLuzojSVo9ILQajQbW9RYDwM76RjgwtTns5aZ9AJfRv/VV
         vQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758739219; x=1759344019;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CmJ3vOxzWTYE+jCZQu9PTb3XdXqCFWVRNB5Wst4HaN8=;
        b=MCGilUdy9O6FkCh9n7T7e9QYSkyPart0A9gP4Q9qhv5kLXD6kUf97VUBer/AtKGzaQ
         ZG2xA4wC+1/pWEgG733vJ3l4DSP9o8T/MIh3paQvJvafS+2MRsQlACBlb4S3rNOIFCcF
         Mpe3ZXQZF9CjJzIS6T+LNJRVDttqApcYdTWRpuqkY23tR2LgIdvEddW3mrQdV7M0RgXo
         fteelrvEp46qACKRvrzDH39YYVAVEH9kKIYnsOnRrQIkMyKn+yCr2YL13fWsrbpI4rWU
         VCMzhwOmkHjv7Z5w/B51X3bnLkJFDeG6LvjxrBI0R/AWd8g04WP1ZB8y7k+4Chfeofa7
         Ncaw==
X-Forwarded-Encrypted: i=1; AJvYcCXyVJp6SZcZxIH+McnSl7q+0xXq9F6uKZFI7loxZ3LRK+qcA5hnCKUFqQN4osUaDXmZiB1RnXml5A==@kvack.org
X-Gm-Message-State: AOJu0YzH8zL2IktezDrMk3GrtKiPb3BoOrOHksVtZNqNTyotcFkZLSvJ
	uiMK4RQ77s5bWAdzi7xV0M1oBnW47sTUhP1aYCbr0p0LoRnN0ujwW3Wv7POyx2AKW6s=
X-Gm-Gg: ASbGnctGo8Jyz1yts2a4G6uudXM9V+y67iLOfWusdC6IvPncGWDw5kw8Wez8lta2Uz8
	iopAC7AuQWgvE2W9bRmMhsFIUFTbTHOzWv1wNFi2g8gAu/gJ8mISgFWS2A5RV33L76gKtJnWHsr
	LZI9th8aKRWkzATnb6PLj9svTel+50+W8MzZKL3lbIkqGKLdphWwGyo9+ODsii4N7SqBMT7wfW4
	vHbIrr8lYtGUOT93Z2nU/9a5yxXJ4DkLy4l14aTSum/PpimEyXK7AqFS6a0u4JHp7uw6Hkg4UVW
	vrj2l1iaUHDA1IYE2knb06o10PGREZCurxZpLKC880bnSzRnUDsyb/NkglknHaPfJhIj+otXMLU
	Po2o9MJrtVy2vyslbRTDZg+tYuSYdHtWO
X-Google-Smtp-Source: AGHT+IGXuHXHBWPf+oE+Ln4Jp/4CaKr0teMjK8nrYhSg666HYgvhIXatAPi5gWQsQGiN1OujHcfx1A==
X-Received: by 2002:a17:902:e790:b0:24b:270e:56d4 with SMTP id d9443c01a7336-27ed4c67b42mr6992845ad.4.1758739219414;
        Wed, 24 Sep 2025 11:40:19 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2698035ddcasm198787335ad.142.2025.09.24.11.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 11:40:18 -0700 (PDT)
Date: Wed, 24 Sep 2025 11:40:15 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Paul Walmsley <pjw@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
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
	Andy Chiu <andybnac@gmail.com>, kito.cheng@sifive.com,
	charlie@rivosinc.com, atishp@rivosinc.com, evan@rivosinc.com,
	cleger@rivosinc.com, alexghiti@rivosinc.com,
	samitolvanen@google.com, broonie@kernel.org,
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
	Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
	Florian Weimer <fweimer@redhat.com>, bharrington@redhat.com,
	Aurelien Jarno <aurel32@debian.org>
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
Message-ID: <aNQ7D6_ZYMhCdkmL@debug.ba.rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
 <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
X-Rspamd-Queue-Id: B320514000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: mkme6i6f471ig3thafi8oiof6hcm4ms7
X-HE-Tag: 1758739220-343146
X-HE-Meta: U2FsdGVkX1+cF19qQdtl7XLnouK1HExVrmZh1mG4CImOx+u6TB1FhZb5UgwhYRWNwoFVLsnIXP6zcWU2CvL0m+F99rw7pFXuKUlwo4k2mkBX/YLlIMMh9xjcYUQOQqDJeimGV9EzdvCUSIWkv00dsYVN7aK8d/P499N/3xaO8ioUD1WTcpzqeV4aMmOkuoGgXIS1gPezAQcTD25DXJa5sX+E7EwX6rnMOhJ4rCqoY0P9AGl7Z42g5fWDxvv8EpaMbB1iqt/l+La2VPaIzfXa1NBbxB5Tx09vEWgDbk1eRVGmG7Yn/pe+q9gsajgbIShtTGFltJ3MSy32hL5yxJf/coe7c2+oCbySPqw/Qc7+RDmHpTW/2PtwJtHN+ByPK1DdFXrwYgi3FXmhqF8hZZpx+01SKViTaK5k7TfosE1U1f5zpnEqKUFdLu2o3+R3WRaZe2buUGiXVTnRDRHdT8B392CAcZWTj1A1+SeJMdNx6f+9iCY07iHzd3AR/a4zNDILLwFJinV1LU4ZWzUbKRX8z8QzsCOA3r8HVqhSZlmxtY15yXh4FtTt37yYU6wTO63L1UQ6zELsZ92Qw4b+HAW4WsmUBwBn4hkoYLQJbT9XPutd6uYqONlLj77npB5AHuJpi8hxWDCS/+vvjYT/lY9Q3lFFgOa5SdFJs0g3zYUa46XgNNggSZSfq6tas9HmwCgmzfn4x+Wj+frxWhXEikt9bP1LobppOxy+v8MPyOJNj6uTDG/HkrHdVP0HSa/lyOJiR1YXGmBpCzOPKqBHydMsKMAW+9EyVLZqf6ZKGmFTzWVfNP1q45YCZTZzbX6Ci8vm7eZqMcYojrQKaKH5Jf0dkXszHtvoQpv6WvyVTMUeYzjv5GonawgpXdPox+KySO3k56AXtR5KdfwQ1uQQtEllfRFw3iwd66QtB3XbadbmX3jvpO05lD/PpwEBMjkCaikB5lxvcIbRpdOnMmozMNa
 qcMSFxMb
 n+xUPFZ9uTQ0M55y1juAXLREyRgMfbWmVRXxe5Ho0PBYyO4j8P+YtyhXCDokrergZP+kegliQTdSyb/Q91lG7NJYi1e3ta3k18zMtUOLAIdDIiMEkVUPx+nzeqm3mJoVuZ8vVlOq9W9XdhnXtP8ShParS6yAuFVqfDMELZlW/G9lW94PmML8OcTejvqqaXazMRkytiylMb7+H3N7c37ar9BWzjva0dBW6W8U99TUvQTibvjoWVbY2MtR02bS2rgsFAI6ECw3EZXBlA+opGKR5xk2ghqIIiLXIRipbPVyyjIzxWS9ENZzLHJkZHo/gu+I1Ig5FChZIqWPXsI5Qv6oYDyJgvlbBJpyeSUK0xpoP0Rm91uGliJHiAH0HpB1oeivm/Gl4p0rlDYdozD/IeTgiXGBmrsqPUpKwoLwa0aGY5VDJd98=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 08:36:11AM -0600, Paul Walmsley wrote:
>Hi,
>
>On Thu, 31 Jul 2025, Deepak Gupta wrote:
>
>[ ... ]
>
>> vDSO related Opens (in the flux)
>> =================================
>>
>> I am listing these opens for laying out plan and what to expect in future
>> patch sets. And of course for the sake of discussion.
>>
>
>[ ... ]
>
>> How many vDSOs
>> ---------------
>> Shadow stack instructions are carved out of zimop (may be operations) and if CPU
>> doesn't implement zimop, they're illegal instructions. Kernel could be running on
>> a CPU which may or may not implement zimop. And thus kernel will have to carry 2
>> different vDSOs and expose the appropriate one depending on whether CPU implements
>> zimop or not.
>
>If we merge this series without this, then when CFI is enabled in the
>Kconfig, we'll wind up with a non-portable kernel that won't run on older
>hardware.  We go to great lengths to enable kernel binary portability
>across the presence or absence of other RISC-V extensions, and I think
>these CFI extensions should be no different.
>
>So before considering this for merging, I'd like to see at least an
>attempt to implement the dual-vDSO approach (or something equivalent)
>where the same kernel binary with CFI enabled can run on both pre-Zimop
>and post-Zimop hardware, with the existing userspaces that are common
>today.

Added some distro folks in this email chain.

After patchwork meeting today, I wanted to continue discussion here. So thanks
Paul for looking into it and initiating a discussion here.

This patch series has been in the queue for quite a long time and we have had
deliberations on vDSO topic earlier as well and after those deliberations it
was decided to go ahead with merge and it indeed was sent for 6.17 merge
window. Unfortunatley due to other unforeseen reasons, entirety of riscv
changes were not picked. So it's a bit disappointing to see back-paddling on
this topic.

Anyways, we are here. So I'll provide a bit of context for the list about
deliberations and discussions we have been having for so many merge windows.
This so that a holistic discussion can happen on this before we make a
decision.

Issue
======

Instructions in RISC-V shadow stack extension (zicfiss - [1]) are carved out of
"may be ops" aka zimop extension [2]. "may be ops" are illegal on non-RVA23
hardware. This means any existing riscv CPU or future CPU which isn't RVA23
compliant and not implementing zimop will treat these encodings as illegal.

Current kernel patches enable shadow stack and landing pad support for
userspace using config `CONFIG_RISCV_USER_CFI`. If this config is selected then
vDSO that will be exposed to user space will also have shadow stack
instructions in them. Kernel compiled with `CONFIG_RISCV_USER_CFI`, for sake of
this discussion lets call it RVA23 compiled kernel.

Issue that we discussed earlier and even today is "This RVA23 compiled kernel
won't be able to support non-RVA23 userspace on non-RVA23 hardware because".
Please note that issue exists only on non-RVA23 hardware (which is existing
hardware and future hardware which is not implementing zimop). RVA23 compiled
kernel can support any sort of userspace on RVA23 hardware.


Discussion
===========

So the issue is not really shadow stack instructions but rather may be op
instructions in codegen (binaries and vDSO) which aren't hidden behind any
flag (to hide them if hardware doesn't support). And if I can narrow down
further, primary issue we are discussing is that if cfi is enabled during
kernel compile, it is bringing in a piece of code (vDSO) which won't work
on existing hardware. But the counter point is if someone were to deploy
RVA23 compiled kernel on non-RVA23 hardware, they must have compiled
rest of the userspace without shadow stack instructions in them for such
a hardware. And thus at this point they could simply choose *not* to turn on
`CONFIG_RISCV_USER_CFI` when compiling such kernel. It's not that difficult to
do so.

Any distro who is shipping userspace (which all of them are) along with kernel
will not be shipping two different userspaces (one with shadow stack and one
without them). If distro are shipping two different userspaces, then they might
as well ship two different kernels. Tagging some distro folks here to get their
take on shipping different userspace depending on whether hardware is RVA23 or
not. @Heinrich, @Florian, @redbeard and @Aurelien.

Major distro's have already drawn a distinction here that they will drop
support for hardware which isn't RVA23 for the sake of keeping binary
distribution simple.

Only other use case that was discussed of a powerful linux user who just wants
to use a single kernel on all kinds of riscv hardware. I am imagining such a
user knows enough about kernel and if is really dear to them, they can develop
their own patches and send it upstream to support their own usecase and we can
discuss them out. Current patchset don't prevent such a developer to send such
patches upstream.

I heard the argument in meeting today that "Zbb" enabling works similar for
kernel today. I looked at "Zbb" enabling. It's for kernel usage and it's
surgically placed in kernel using asm hidden behind alternatives. vDSO isn't
compiled with Zbb. Shadow stack instructions are part of codegen for C files
compiled into vDSO.

Furthermore,

Kernel control flow integrity will introduce shadow stack instructions all
over the kernel binary. Such kernel won't be deployable on non-RVA23 hardware.
How to deal with this problem for a savvy kernel developer who wants to run
same cfi enabled kernel binary on multiple hardware?

Coming from engineering and hacker point of view, I understand the desire here
but I still see that it's complexity enforced on rest of the kernel from a user
base which anyways can achieve such goals. For majority of usecases, I don't
see a reason to increase complexity in the kernel for build, possibly runtime
patching and thus possibly introduce more issues and errors just for the sake
of a science project.

Being said that, re-iterating that currently default for `CONFIG_RISCV_USER_CFI`
is "n" which means it won't be breaking anything unless a user opts "Y". So even
though I really don't see a reason and usability to have complexity in kernel to
carry multiple vDSOs, current patchsets are not a hinderance for such future
capability (because current default is No) and motivated developer is welcome
to build on top of it. Bottomline is I don't see a reason to block current
patchset from merging in v6.18.


[1] - https://github.com/riscv/riscv-isa-manual/blob/main/src/unpriv-cfi.adoc#shadow-stack-zicfiss
[2] - https://github.com/riscv/riscv-isa-manual/blob/main/src/zimop.adoc

>
>thanks Deepak,
>
>- Paul

