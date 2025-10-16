Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72676CCD19A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 15:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4EF28E0006; Thu, 16 Oct 2025 11:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF4D8E0002; Thu, 16 Oct 2025 11:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7798E0006; Thu, 16 Oct 2025 11:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72D548E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:33:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E46CF13AAD8
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:32:59 +0000 (UTC)
X-FDA: 84004370478.02.6885D7C
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF4C5140007
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:32:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=NCe8wI5p;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760628778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jxedNOWKQXyjZn7DBAQ8SlEmIZ51OVh5Hh6uRAtw9w=;
	b=oNjdqCZvWaRLOsWMI/ThHhuwHtHQFtk+DtC303gPDGFMppBAlPRiITGd3dlUMvAM0WftN2
	5rdcDk/kOIr7lp73wgQPKjbbuFBeQ1ZihSAwAgMvAod8PQUE72KgGG5rnN1vdZ75OTHpAs
	n3mauwr+NsJo3FQZLeU/3StzIZIDn5o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=NCe8wI5p;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760628778; a=rsa-sha256;
	cv=none;
	b=Htsf1SZv9DA9BLSAnpQIpf+eTYS7pqy2v7r/eayhWOmxPmD0QBLNLVJitXK94QyuJVYw7N
	Mu0bC1cuZxzCqA1yIfAKYukC+mRK1vP1t/cmOgLg/xp+yKHrCJKqy4HMH/kzN2SMUz/IXF
	RaJBZf+Z9bCKu6mzofbU+F2sseH6qIU=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b5526b7c54eso598292a12.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760628777; x=1761233577; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3jxedNOWKQXyjZn7DBAQ8SlEmIZ51OVh5Hh6uRAtw9w=;
        b=NCe8wI5pp029+1T4rsiCF7DSpVfCR9CCtQraqlBa3iiEO08bgEKd9asb9Ryyhr2K7l
         iODhbeCmlBQla6r8f9umBmy2iR/Jp/6gVAbmQN3SiBoiRlvnsPG2fGhXnVc7Z81XA4xN
         KBGak4JhOpjpiUVaNJGFsokTcoXIyvU8HqUquQHGMf/NCiFPuVFgAHBBrpAYdRGv7B3S
         5tQYAFzcIjanDmCRFQRSoQCKCKCOneBP97ORHSO3dLEjHOI+6r40izbOrHTE0EPQChxn
         hordgjoq6GAZhQPYyCJNRdD3vtVr706OF5szpYhDZ0oSG/gSVOzWF91ae1HJrFJ6TTSS
         ab9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760628777; x=1761233577;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3jxedNOWKQXyjZn7DBAQ8SlEmIZ51OVh5Hh6uRAtw9w=;
        b=JRkVAqhcUxS8Dfk8AJDvvoPeLAk+kuyZph3MTuEbN1xisJ9kE5KL3bUcrt+RUAU/ft
         pBG6fPAmOTjaOgSFTdDHeTEAhd0CfpKVHnA4F0nhASnFz6byekjwbTSIVnAnoWeoXa2Y
         6fHl8uZFx5q9KAym0xhmEzOpMiJP4+TKe5voP5kHb0Pl50muWlu/lqzUF+1rg5jsruyK
         9jp8BpvIVL5bkgEOjkc2z+dWAVKMDai6xV5YbyGDPLXtwhx62FpT2jy9nibUsvLEXzoM
         6JzV6Lm7HLJBSoGkIIXGJogsOyt4d5Xar52LDrUoN/7uM8cu6YucfW6vT5gkZO8cQmYQ
         ym+w==
X-Forwarded-Encrypted: i=1; AJvYcCVsqTQr9s8VKqZypaSCkRn4b+eO2oMzs4QqfTkISp4X4h9APHpGqaXUjamfRbYvs4Anlr3EPuCQWw==@kvack.org
X-Gm-Message-State: AOJu0YwYVbNeVkjTStqKuWfXVIGaQC/lvSzdWAlGEiMbAxNut+EYoQ+4
	JD3jjaJLQ+qAZje/JxnzosrzB5Q7vMnhNVHIUE2Yq/hKg+DSTJBDNKWC3T4H4zypfqg=
X-Gm-Gg: ASbGncsHwS3xnRgTSXOGeDQwCLzpzVLILYXUIXLRYFdoGiZCP9E86BFxLvk0VbSVWmr
	+sfp3OL79DxB+2FS2TRpRW0Istc1/VFlt9KeqYM74h3KWTJh+3j3WHYUiMxBfGa3B1faQ2iJqPZ
	6kpQXrd1i+gsQwohmjH9Xp3rwggobRq5xOwdukowaYGrzBIlrKKsdTmwzHccQkdzhpwx8FDXEgL
	Yy3xSNMPy3ellgog957dSeW1MUx9S49Vf2SgrzU5Jt/DhQidTNefxUZ7Ii5ZEiuZTOrrOcuCac0
	0C8DVfBCdA2dQxdmUBTSh2wyUEZcMy07C1uns5RpfW/zrEHe5N2FkcUa81qic/JzTccEM0WtNQK
	PaZUTUKz7XpJiUs8ZP/irFJzlm1bDp+gZQdztHtNmcXqxcUvV5zobyxMJqV8L93SR2KUl6KhVv3
	OApsGDPqK6bQ==
X-Google-Smtp-Source: AGHT+IH84DeIB8c+VjuQrVSzDzT3x6nsRergbVWw29DX9ZseotGG3dDJsziVEnyxGDiXthj0SuB12g==
X-Received: by 2002:a17:902:d483:b0:265:47:a7b0 with SMTP id d9443c01a7336-290c9c896a5mr3550315ad.10.1760628776645;
        Thu, 16 Oct 2025 08:32:56 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099348afcsm34256915ad.37.2025.10.16.08.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 08:32:56 -0700 (PDT)
Date: Thu, 16 Oct 2025 08:32:53 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Zong Li <zong.li@sifive.com>
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
	andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com,
	atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com,
	alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org,
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v20 24/28] arch/riscv: dual vdso creation logic and
 select vdso based on hw
Message-ID: <aPEQJTbADjH9AKUf@debug.ba.rivosinc.com>
References: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
 <20251013-v5_user_cfi_series-v20-24-b9de4be9912e@rivosinc.com>
 <CANXhq0rVGisy33n6gB-P8B0ALiB2LqqYbKsSqgJLCNNRecP9TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANXhq0rVGisy33n6gB-P8B0ALiB2LqqYbKsSqgJLCNNRecP9TA@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF4C5140007
X-Stat-Signature: yhonoyt48kqz78iity48midrkmxtce5p
X-Rspam-User: 
X-HE-Tag: 1760628777-296512
X-HE-Meta: U2FsdGVkX1+sPuG44UlXWGb4h0IEoWST6xH8wTztiutgGroT2HXvfzS+Ljix1FxBB0D3+yloaAcyQ4dIBxteyNHOwXKuOWfmzbcKg2KfepelBdditH8P5Cvuun32tMWQgpLrb1YCwMgjQuDilu0hvYC6rLf7PHp2NnS/ztzHwCCou+meOe0+r/qEIkwdSfjVH8Wmn4jSxuq+DdPFMYfBJfiq/4ZIg5MBoyMMYLtzwKBsE74BlqHOkuY2c/3UyITA4U6CefLipRfUynyaowrRIBzcZ/CUCGLq8gr/mOXCNdA5c9rQdHJQWYMVVwfz0or6ZuND6kJflXsIEb7IsEOyQulCOyuToOWWByUP1zQaTiueAA7siUtGZ2z9f4/spyZsJZLQDnBXsiSHzHhOsawIIpRupeZ73eLqSZH6wnaJd3OCnUGARUyJudIvc6lDLc80jhHXmFkJhm8Xr5yG96l0ZS0RHTBSQAx4LTnG8HQaY7dX5DrF2tg7hz6uhpPZrVKE/u8nbRKnoJScmVi8GS69/+xyxuL3vJWzk0vQmR082F5f3TWKfoYuSVIOn/c20P8F4TPObTh5poli7TV1dWH2VvYbnanimdXET/pujM5+vpBgiICUah5EixfS3uPwWj1Z5kElRU1uyjRujo6dAph7QqrozlksYy9wCT+crsmrP/dl1KpMKQix0PFDTtgce2CHjOmtqNAypUjybfSbyyVMqN2SRW5nAFZCcoZZsH0TAX2lVkXMNNVZ+EN3BnSlF/n/xjNKclkSo2gA8F0Nl0O1f+R1eXx/ltEfEPN1WZPEMuY8X6uKq2aWa8J/f4BVBGz5LIYSzNsNbbj97Nt6Cfj7GoXpjzO2+7+BK9T3O0kSc3ELiN2lLe7T+Q2yEKgf3WwnVtl23hDPBg+vMbf9mAg+bFPJAaI7SXuQRJv2TFh4wNV9oEzN39W0pIDkxS6ZTjYyweSNRade4kgSqqGP/AD
 0EQ1SkDA
 DOvFtP0sk85dLDP3RWt4r5Fz3tcOQWau70C13hNAQPGklrkHw0o9LAs4Ac3hu/ajKzd18uGRzkPuVEAh9ejIJRPvsSlooG/1FAUSRK+uWc/BrbbVFr/bopkUazTmH/qTaKYmyzxvCtIQwqzQGSiUh/eRMTXQ7zZw0NVNFq4GLZBwNFenW4YPyLyjDALk6kicTQ247JV4jcsTOoYegBSfMNHwng8I6A9elOLo37e9jDfODhTZ04S5gJjOoQOXJBsI++4dNlOPs9mSZ+Kw48hdU6AGPyv2P4B8dyX2xSMVnPnvJ4fToHc89ZfkUVNenDOy7QcY1nTUiRk2BzZnC5uVWuFUp7f4iA/EnDMe7TqCUaTULzpc8FksEJwQvEzfBIbmD5dMVRZ9fBi3W2teT0TPiM7Zr6RT7aEl0gTFC/WbXdpVa3Ts2gI2qBfkSWCdXs3zgPVTwTDoN6/EHBblXipWMvx27vYOQbzRQrhCS8mBGemRcN7FXzkxhr3MtFR2sXReO3O4ZmSyemTwjBaz5CYCvJkK1D3WuKHkRi5RB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 04:32:08PM +0800, Zong Li wrote:
>On Tue, Oct 14, 2025 at 5:57 AM Deepak Gupta <debug@rivosinc.com> wrote:
>>
>> Shadow stack instructions are taken from zimop (mandated on RVA23).
>> Any hardware prior to RVA23 profile will fault on shado stack instruction.
>
>I notice that there is a typo for shado"w" stack instruction.

Aah yes. Sorry about it and thanks.
Again upto Paul, if he wants me to send another. I'll do that.

-Deepak

>
>> Any userspace with shadow stack instruction in it will fault on such
>> hardware. Thus such userspace can't be brought onto such a hardware.
>>
>> It's not known how userspace will respond to such binary fragmentation.
>> However in order to keep kernel portable across such different hardware,
>> `arch/riscv/kernel/vdso_cfi` is created which has logic (Makefile) to
>> compile `arch/riscv/kernel/vdso` sources with cfi flags and then changes
>> in `arch/riscv/kernel/vdso.c` for selecting appropriate vdso depending
>> on whether underlying hardware(cpu) implements zimop extension. Offset
>> of vdso symbols will change due to having two different vdso binaries,
>> there is added logic to include new generated vdso offset header and
>> dynamically select offset (like for rt_sigreturn).
>>
>> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>> ---
>>  arch/riscv/Makefile                        |  3 +++
>>  arch/riscv/include/asm/vdso.h              |  7 ++++++-
>>  arch/riscv/kernel/Makefile                 |  1 +
>>  arch/riscv/kernel/vdso.c                   |  7 +++++++
>>  arch/riscv/kernel/vdso/Makefile            | 29 ++++++++++++++++++++---------
>>  arch/riscv/kernel/vdso/gen_vdso_offsets.sh |  4 +++-
>>  arch/riscv/kernel/vdso_cfi/Makefile        | 25 +++++++++++++++++++++++++
>>  arch/riscv/kernel/vdso_cfi/vdso-cfi.S      | 11 +++++++++++
>>  8 files changed, 76 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
>> index f60c2de0ca08..b74b63da16a7 100644
>> --- a/arch/riscv/Makefile
>> +++ b/arch/riscv/Makefile
>> @@ -176,6 +176,8 @@ ifeq ($(CONFIG_MMU),y)
>>  prepare: vdso_prepare
>>  vdso_prepare: prepare0
>>         $(Q)$(MAKE) $(build)=arch/riscv/kernel/vdso include/generated/vdso-offsets.h
>> +       $(if $(CONFIG_RISCV_USER_CFI),$(Q)$(MAKE) \
>> +               $(build)=arch/riscv/kernel/vdso_cfi include/generated/vdso-cfi-offsets.h)
>>         $(if $(CONFIG_COMPAT),$(Q)$(MAKE) \
>>                 $(build)=arch/riscv/kernel/compat_vdso include/generated/compat_vdso-offsets.h)
>>
>> @@ -183,6 +185,7 @@ endif
>>  endif
>>
>>  vdso-install-y                 += arch/riscv/kernel/vdso/vdso.so.dbg
>> +vdso-install-$(CONFIG_RISCV_USER_CFI)  += arch/riscv/kernel/vdso_cfi/vdso-cfi.so.dbg
>>  vdso-install-$(CONFIG_COMPAT)  += arch/riscv/kernel/compat_vdso/compat_vdso.so.dbg
>>
>>  BOOT_TARGETS := Image Image.gz Image.bz2 Image.lz4 Image.lzma Image.lzo Image.zst Image.xz loader loader.bin xipImage vmlinuz.efi
>> diff --git a/arch/riscv/include/asm/vdso.h b/arch/riscv/include/asm/vdso.h
>> index f80357fe24d1..3fc8f72b8bfb 100644
>> --- a/arch/riscv/include/asm/vdso.h
>> +++ b/arch/riscv/include/asm/vdso.h
>> @@ -18,9 +18,13 @@
>>
>>  #ifndef __ASSEMBLER__
>>  #include <generated/vdso-offsets.h>
>> +#include <generated/vdso-cfi-offsets.h>
>>
>>  #define VDSO_SYMBOL(base, name)                                                        \
>> -       (void __user *)((unsigned long)(base) + __vdso_##name##_offset)
>> +       ((IS_ENABLED(CONFIG_RISCV_USER_CFI) &&                                  \
>> +         riscv_has_extension_unlikely(RISCV_ISA_EXT_ZIMOP)) ?                  \
>> +         (void __user *)((unsigned long)(base) + __vdso_##name##_cfi_offset) : \
>> +         (void __user *)((unsigned long)(base) + __vdso_##name##_offset))
>>
>>  #ifdef CONFIG_COMPAT
>>  #include <generated/compat_vdso-offsets.h>
>> @@ -33,6 +37,7 @@ extern char compat_vdso_start[], compat_vdso_end[];
>>  #endif /* CONFIG_COMPAT */
>>
>>  extern char vdso_start[], vdso_end[];
>> +extern char vdso_cfi_start[], vdso_cfi_end[];
>>
>>  #endif /* !__ASSEMBLER__ */
>>
>> diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
>> index 2d0e0dcedbd3..9026400cba10 100644
>> --- a/arch/riscv/kernel/Makefile
>> +++ b/arch/riscv/kernel/Makefile
>> @@ -72,6 +72,7 @@ obj-y += vendor_extensions/
>>  obj-y  += probes/
>>  obj-y  += tests/
>>  obj-$(CONFIG_MMU) += vdso.o vdso/
>> +obj-$(CONFIG_RISCV_USER_CFI) += vdso_cfi/
>>
>>  obj-$(CONFIG_RISCV_MISALIGNED) += traps_misaligned.o
>>  obj-$(CONFIG_RISCV_MISALIGNED) += unaligned_access_speed.o
>> diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
>> index 3a8e038b10a2..bf080e519101 100644
>> --- a/arch/riscv/kernel/vdso.c
>> +++ b/arch/riscv/kernel/vdso.c
>> @@ -98,6 +98,13 @@ static struct __vdso_info compat_vdso_info __ro_after_init = {
>>
>>  static int __init vdso_init(void)
>>  {
>> +       /* Hart implements zimop, expose cfi compiled vdso */
>> +       if (IS_ENABLED(CONFIG_RISCV_USER_CFI) &&
>> +               riscv_has_extension_unlikely(RISCV_ISA_EXT_ZIMOP)) {
>> +               vdso_info.vdso_code_start = vdso_cfi_start;
>> +               vdso_info.vdso_code_end = vdso_cfi_end;
>> +       }
>> +
>>         __vdso_init(&vdso_info);
>>  #ifdef CONFIG_COMPAT
>>         __vdso_init(&compat_vdso_info);
>> diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
>> index 272f1d837a80..a842dc034571 100644
>> --- a/arch/riscv/kernel/vdso/Makefile
>> +++ b/arch/riscv/kernel/vdso/Makefile
>> @@ -20,6 +20,10 @@ endif
>>  ifdef VDSO_CFI_BUILD
>>  CFI_MARCH = _zicfilp_zicfiss
>>  CFI_FULL = -fcf-protection=full
>> +CFI_SUFFIX = -cfi
>> +OFFSET_SUFFIX = _cfi
>> +ccflags-y += -DVDSO_CFI=1
>> +asflags-y += -DVDSO_CFI=1
>>  endif
>>
>>  # Files to link into the vdso
>> @@ -48,13 +52,20 @@ endif
>>  CFLAGS_hwprobe.o += -fPIC
>>
>>  # Build rules
>> -targets := $(obj-vdso) vdso.so vdso.so.dbg vdso.lds
>> +vdso_offsets := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),)-offsets.h
>> +vdso_o := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).o
>> +vdso_so := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).so
>> +vdso_so_dbg := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).so.dbg
>> +vdso_lds := vdso.lds
>> +
>> +targets := $(obj-vdso) $(vdso_so) $(vdso_so_dbg) $(vdso_lds)
>> +
>>  obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
>>
>> -obj-y += vdso.o
>> -CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
>> +obj-y += vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).o
>> +CPPFLAGS_$(vdso_lds) += -P -C -U$(ARCH)
>>  ifneq ($(filter vgettimeofday, $(vdso-syms)),)
>> -CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
>> +CPPFLAGS_$(vdso_lds) += -DHAS_VGETTIMEOFDAY
>>  endif
>>
>>  # Disable -pg to prevent insert call site
>> @@ -63,12 +74,12 @@ CFLAGS_REMOVE_getrandom.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
>>  CFLAGS_REMOVE_hwprobe.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
>>
>>  # Force dependency
>> -$(obj)/vdso.o: $(obj)/vdso.so
>> +$(obj)/$(vdso_o): $(obj)/$(vdso_so)
>>
>>  # link rule for the .so file, .lds has to be first
>> -$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
>> +$(obj)/$(vdso_so_dbg): $(obj)/$(vdso_lds) $(obj-vdso) FORCE
>>         $(call if_changed,vdsold_and_check)
>> -LDFLAGS_vdso.so.dbg = -shared -soname=linux-vdso.so.1 \
>> +LDFLAGS_$(vdso_so_dbg) = -shared -soname=linux-vdso.so.1 \
>>         --build-id=sha1 --eh-frame-hdr
>>
>>  # strip rule for the .so file
>> @@ -79,9 +90,9 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
>>  # Generate VDSO offsets using helper script
>>  gen-vdsosym := $(src)/gen_vdso_offsets.sh
>>  quiet_cmd_vdsosym = VDSOSYM $@
>> -       cmd_vdsosym = $(NM) $< | $(gen-vdsosym) | LC_ALL=C sort > $@
>> +       cmd_vdsosym = $(NM) $< | $(gen-vdsosym) $(OFFSET_SUFFIX) | LC_ALL=C sort > $@
>>
>> -include/generated/vdso-offsets.h: $(obj)/vdso.so.dbg FORCE
>> +include/generated/$(vdso_offsets): $(obj)/$(vdso_so_dbg) FORCE
>>         $(call if_changed,vdsosym)
>>
>>  # actual build commands
>> diff --git a/arch/riscv/kernel/vdso/gen_vdso_offsets.sh b/arch/riscv/kernel/vdso/gen_vdso_offsets.sh
>> index c2e5613f3495..bd5d5afaaa14 100755
>> --- a/arch/riscv/kernel/vdso/gen_vdso_offsets.sh
>> +++ b/arch/riscv/kernel/vdso/gen_vdso_offsets.sh
>> @@ -2,4 +2,6 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>
>>  LC_ALL=C
>> -sed -n -e 's/^[0]\+\(0[0-9a-fA-F]*\) . \(__vdso_[a-zA-Z0-9_]*\)$/\#define \2_offset\t0x\1/p'
>> +SUFFIX=${1:-""}
>> +sed -n -e \
>> +'s/^[0]\+\(0[0-9a-fA-F]*\) . \(__vdso_[a-zA-Z0-9_]*\)$/\#define \2'$SUFFIX'_offset\t0x\1/p'
>> diff --git a/arch/riscv/kernel/vdso_cfi/Makefile b/arch/riscv/kernel/vdso_cfi/Makefile
>> new file mode 100644
>> index 000000000000..8ebd190782b0
>> --- /dev/null
>> +++ b/arch/riscv/kernel/vdso_cfi/Makefile
>> @@ -0,0 +1,25 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +# RISC-V VDSO CFI Makefile
>> +# This Makefile builds the VDSO with CFI support when CONFIG_RISCV_USER_CFI is enabled
>> +
>> +# setting VDSO_CFI_BUILD triggers build for vdso differently
>> +VDSO_CFI_BUILD := 1
>> +
>> +# Set the source directory to the main vdso directory
>> +src := $(srctree)/arch/riscv/kernel/vdso
>> +
>> +# Copy all .S and .c files from vdso directory to vdso_cfi object build directory
>> +vdso_c_sources := $(wildcard $(src)/*.c)
>> +vdso_S_sources := $(wildcard $(src)/*.S)
>> +vdso_c_objects := $(addprefix $(obj)/, $(notdir $(vdso_c_sources)))
>> +vdso_S_objects := $(addprefix $(obj)/, $(notdir $(vdso_S_sources)))
>> +
>> +$(vdso_S_objects): $(obj)/%.S: $(src)/%.S
>> +       $(Q)cp $< $@
>> +
>> +$(vdso_c_objects): $(obj)/%.c: $(src)/%.c
>> +       $(Q)cp $< $@
>> +
>> +# Include the main VDSO Makefile which contains all the build rules and sources
>> +# The VDSO_CFI_BUILD variable will be passed to it to enable CFI compilation
>> +include $(src)/Makefile
>> diff --git a/arch/riscv/kernel/vdso_cfi/vdso-cfi.S b/arch/riscv/kernel/vdso_cfi/vdso-cfi.S
>> new file mode 100644
>> index 000000000000..d426f6accb35
>> --- /dev/null
>> +++ b/arch/riscv/kernel/vdso_cfi/vdso-cfi.S
>> @@ -0,0 +1,11 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright 2025 Rivos, Inc
>> + */
>> +
>> +#define        vdso_start      vdso_cfi_start
>> +#define        vdso_end        vdso_cfi_end
>> +
>> +#define __VDSO_PATH "arch/riscv/kernel/vdso_cfi/vdso-cfi.so"
>> +
>> +#include "../vdso/vdso.S"
>>
>> --
>> 2.43.0
>>
>>
>> _______________________________________________
>> linux-riscv mailing list
>> linux-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-riscv

