Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBD3ACCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 15:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20E008E0005; Thu, 16 Oct 2025 11:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BE7B8E0002; Thu, 16 Oct 2025 11:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0864B8E0005; Thu, 16 Oct 2025 11:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E78888E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:31:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98840B8965
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:31:15 +0000 (UTC)
X-FDA: 84004366110.25.9B9FB72
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 889A44000D
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:31:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="Un5f/ynx";
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760628672; a=rsa-sha256;
	cv=none;
	b=MQ4WtgsSc7Uhl3MngzIcWNxyQaXcSFeooiR+cB72KIVrhXw8tykwINlaMqAXyxfkhG2Rzz
	xJouWAxTSunDiwFX17PRlmPLlgcwZxIcFyFAyRujqXCFkiP/UVjzSzTsfpAV68cgbXqrtz
	bIkNlumfGCCDmnpf2afat/mXUCMP+VA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="Un5f/ynx";
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760628672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPplYqAzpwU4gxjQp2Rw6jkCzCOQWdHbasm8KJuRgKg=;
	b=EF/oQSuvJzRMJx70lLSLHiRQTo34Eg91GukJpqv/C8w3viA7BCY1ORQNo2dRO7CTMmmqSm
	FChgnMsLfJfjX3HaW9fj08NkT2kJ/c0Bgc8m17jY+2QU6PPHxOCgcUMQztHX401d6dnPL5
	sIOqudQKWZRaIpCsVYsFiGlRBAboIcc=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b5a631b9c82so585206a12.1
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760628671; x=1761233471; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oPplYqAzpwU4gxjQp2Rw6jkCzCOQWdHbasm8KJuRgKg=;
        b=Un5f/ynxSvksQXKqNduAjkhyri7iGnt3JuZdVnnov9PPXzhsDTNaMBTmfuNTOXxJPG
         ieeYFI08lu+VZ8bS8+ozsMtvYg3lHOc73xzrvOehuHh1W8XtY3aaRHcwCvYmSyN7ArT+
         bxm3k29ySBgB/GpsXuhBWAsCqnggUvGH3kxXl+bP+nQ22eQLGpuxo88Wk7BWFf96F7XO
         NE1P/yhLuwOW8+CYVlQr4CgHOuRceN7litzTwfLJKhhhol7HzlV5JKSWudaY1uvMeXkj
         CDTf9ouzBmEpODsqKS1R1yUAxtho3lZ97gWXzcR3BHI3ND177A736x/E6JsOxHPLPBL8
         PDEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760628671; x=1761233471;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oPplYqAzpwU4gxjQp2Rw6jkCzCOQWdHbasm8KJuRgKg=;
        b=XuYBm5prDe4s/h1k0nWXQTXe/B2qUxHQa4UQ6bhhf2wMW8qD+dwg/1SUuMcqQPzXUr
         0nsAIv0/Hc2LPY0BvY3XmAKwbyRqA02KMh+hAOmQCPwleY5JLEi6kH0p97mYC8jskzI2
         Qp9Xy4P3mtKIIrCH5L5euKVe2UJqDSINqlj01UjnkS9ZCDHfMHFktstUzEtu6rsh3JWX
         nuw+KkAgkK1LI2o3DDzJG8/LSIcGN7V64mPZwBejiY3py+9L/OjigdKrQdyBh4kcrfrA
         hIWubdz/9VU8poDY+lpQhWGO+8k+2YKU13IKvNKAa07oLVjaEaLCJjaipoL/bwBQKCce
         +F6A==
X-Forwarded-Encrypted: i=1; AJvYcCWnhffZWvDMKCcTNYbOkF3c4oNTwrSIid8YfKYQaceu0WJSCID/0WcXsNSP+azei4rJjvivYDtU8w==@kvack.org
X-Gm-Message-State: AOJu0Yw8klBwHBoFEU0Nq4VDQLIqt5z9bBgJ3vdL3K0PFZeyglRBTY4r
	c6FFlTJBe4QRwEbtevtcPKEYkkSh6B/OILo5636Ax7mUTDqXp5bslhZCXXvWSL1wygs=
X-Gm-Gg: ASbGncvueR/ldStzjtYAptTnhf0KBcQR19bAqGXpxdtduwfxgQW4/om2CqLTqXtPiHL
	k8uKp2dJX88V82WSsOLvP1a4FgGQL5/RKSXgMhE/a/NnGKZhWy04YLngz+EImNA4XZU0+ndYOSA
	C2OqE1v69hyEAOCWdkj7jCInrw6eQjHoc/lYN1n420NKOTVjFEnzcHU1KtnjvM805NnuFGRuH6W
	0sm6ChzB3ycRP11c8AccMw0k7eZYO6Ks1x9ZY+5sSnMtLHf/x18Hsov1h/C9hS5DypnQnE+57ZZ
	WndbpcvEVY1kuV5SivP59P9TGvCQ1boDxvtfLdBLM0+aNCc1kiX6CczU8lJ/qXfojj3u+d+1W86
	aoBtFBMceCSa3ce60ZhyxQmJ4ciOPZNrsbSGbe/FsK9YWEkMxbNwumTYcgs37QsqPS7e3Q/pp5a
	fttn+m9tS/kg==
X-Google-Smtp-Source: AGHT+IHwQKe9LAMk6ozD/GRZ/4wHAc2uQ93fezPeXjgomM0kYDp4EL0uCq03NAVcolelP7TLwPE5CA==
X-Received: by 2002:a17:902:db0b:b0:24c:d6c6:c656 with SMTP id d9443c01a7336-290c9c8a84bmr4369005ad.4.1760628671090;
        Thu, 16 Oct 2025 08:31:11 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099343065sm34122695ad.26.2025.10.16.08.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 08:31:10 -0700 (PDT)
Date: Thu, 16 Oct 2025 08:31:07 -0700
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
Subject: Re: [PATCH v21 25/28] riscv: create a config for shadow stack and
 landing pad instr support
Message-ID: <aPEPuyYo_e4DFSMJ@debug.ba.rivosinc.com>
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
 <20251015-v5_user_cfi_series-v21-25-6a07856e90e7@rivosinc.com>
 <CANXhq0qHT=nnwG3SX3s_D3G2QqKGmQBbdzFwiQ5MMkimxCHJHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANXhq0qHT=nnwG3SX3s_D3G2QqKGmQBbdzFwiQ5MMkimxCHJHQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 4oee4syowntpjwfb8iatzrgw6xjpgyz7
X-Rspamd-Queue-Id: 889A44000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1760628672-404015
X-HE-Meta: U2FsdGVkX1/xRcMPNWPqIy4gPYD5Z781LpA+61zCBxVoHmcxfi0zPrYzeqUwcrqnNEbUb1lOa6pcp1KDaxKZ3jDKhDLJGQUuIqhUAwKHq/pN9oASM/3uWJYbjIlx4JTV55jYQdg8gzdTGdddPaOUulEvDQYjZutmmIy0eCjzUrw4kdQQzxWBvgI9Qx9DpaXOL9f5vyubTkDk9LFbwmwaqPA/Am1H68hq9/yeYdF4mU4Am7yByVlsPaEGcfcGuIUr01v5RaAsYINRlRpqXbt5WfKdpPrr99gqC9jrazjv8UAkaYVopHlr6nDsWm7Wyq04nJALEMdzpuszxiOxRDtr8wo2YND30xh0K4TDNPQ/TLrMdHT/IjvED6EXLzEAnpe+9X22Rew/STTTVcmbFMpJVjYlLv2bFKQiKLoWJoF9GzDDxQHq8egCln7CKU3DbgIzYtQdCck0qE6PRVZ9SnEDpM4pK6SDZA72BitUE0jQXlHitTIxYHOH+06Fm0rj0zqM0dJtQ9Q/AGt3sex3lXjhy7TcebVads3yE04B/aaGF24pC4pA8tBLbwld1+EU91hBgIBTI50rxue1Gts2kblWrPhzdjyluuVg3Hc/F1C3R8lKl81m9j7YDcxCwSY3zG3CJC2iGd9pv6q4CHAjYcvT2sMnBt0r1aZmomHzYxmr8U66Hx0iqptydpSZA/KAoUkex8ZxVX1PcD41uAmTo0ZeaEriceayV1UrLG4Ugq2wxNuGt+hGCIr3039IZ5H3NNwdrn7ku8MwLJNZp95sjtwEXNNV+MoTYl+lp+tEv1i5McyntbH/gwSHiXyLjwRZP1EY6lu8ANzasDuBBdc7zyN9zLY2p7tiVDluPjTUjny93u0EbkDvM4c5PsVstCUoD9dffI0V5Ux6xAZobd2m+CQBkrNYDNNm+G8v+YYtpZGCc36slrtnPef7zZ7/Qkp8nXvG+Pfg4CC3FfKaT3xljmy
 g2H31k+Z
 6frHc1sV2/HUV9wKfrEvnVG5Nrvwwaa6OqI0ubT15GTDWtOD2tEkXzjWtfrnTKlT0vE7FcFmkYiL8z0eMeJZ/PZUV4wcfwctwdS6ECYLUJoLJRYz62vZLBPRHigGen4OQmUOeIfCs4Q2Y+qjsYqobghMkDp1hQT+sicW7SyuByNW1T6djPQHQiGlZjRE/9+SKmWQHGLdmJyCmqianRpMaXm4ZUbfNoold6sFgJL2lxq66fYztLib0K5Jdddo7tY/ep9sUVJ9JUQ069UsiNzv+UKXcLUU26i8kLPMdK4OwBPoSd92pZhYSrlXJsFerxqqskHdmHmMHskx7uw3lfnWn5i+saK5lt3ynnWFik6I1LTgRli8sdjerEQh05uUXdl+hvasQocH7ixw1lnI1KVMiwV5Mh8fM0CTlLYhNMPWSr7Ora2zN5/2gNX9E95Vo5XZahDK+if+E5M4A20pXRm+jeP6rVjXrfEm9EhtkPC32lIiv8G5o5Idg9n3SdmC0oa39aLaxFKltTBXTKArLtUTM5TpPsq5e9JWPfZDK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 04:29:48PM +0800, Zong Li wrote:
>On Thu, Oct 16, 2025 at 2:14 AM Deepak Gupta <debug@rivosinc.com> wrote:
>>
>> This patch creates a config for shadow stack support and landing pad instr
>> support. Shadow stack support and landing instr support can be enabled by
>> selecting `CONFIG_RISCV_USER_CFI`. Selecting `CONFIG_RISCV_USER_CFI` wires
>> up path to enumerate CPU support and if cpu support exists, kernel will
>> support cpu assisted user mode cfi.
>>
>> If CONFIG_RISCV_USER_CFI is selected, select `ARCH_USES_HIGH_VMA_FLAGS`,
>> `ARCH_HAS_USER_SHADOW_STACK` and DYNAMIC_SIGFRAME for riscv.
>>
>> Reviewed-by: Zong Li <zong.li@sifive.com>
>> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>> ---
>>  arch/riscv/Kconfig                  | 21 +++++++++++++++++++++
>>  arch/riscv/configs/hardening.config |  4 ++++
>>  2 files changed, 25 insertions(+)
>>
>> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
>> index 0c6038dc5dfd..aed033e2b526 100644
>> --- a/arch/riscv/Kconfig
>> +++ b/arch/riscv/Kconfig
>> @@ -1146,6 +1146,27 @@ config RANDOMIZE_BASE
>>
>>            If unsure, say N.
>>
>> +config RISCV_USER_CFI
>> +       def_bool y
>> +       bool "riscv userspace control flow integrity"
>> +       depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfiss)
>> +       depends on RISCV_ALTERNATIVE
>> +       select RISCV_SBI
>> +       select ARCH_HAS_USER_SHADOW_STACK
>> +       select ARCH_USES_HIGH_VMA_FLAGS
>> +       select DYNAMIC_SIGFRAME
>> +       help
>> +         Provides CPU assisted control flow integrity to userspace tasks.
>> +         Control flow integrity is provided by implementing shadow stack for
>> +         backward edge and indirect branch tracking for forward edge in program.
>> +         Shadow stack protection is a hardware feature that detects function
>> +         return address corruption. This helps mitigate ROP attacks.
>> +         Indirect branch tracking enforces that all indirect branches must land
>> +         on a landing pad instruction else CPU will fault. This mitigates against
>> +         JOP / COP attacks. Applications must be enabled to use it, and old user-
>> +         space does not get protection "for free".
>> +         default n.
>
>Maybe it is default 'y' instead of 'n'

aah yes, this needs to change. thanks.
I'll see if there are other significant issues, if yes then I'll fix it in that
version. Else I request Paul to fix it.

>
>> +
>>  endmenu # "Kernel features"
>>
>>  menu "Boot options"
>> diff --git a/arch/riscv/configs/hardening.config b/arch/riscv/configs/hardening.config
>> new file mode 100644
>> index 000000000000..089f4cee82f4
>> --- /dev/null
>> +++ b/arch/riscv/configs/hardening.config
>> @@ -0,0 +1,4 @@
>> +# RISCV specific kernel hardening options
>> +
>> +# Enable control flow integrity support for usermode.
>> +CONFIG_RISCV_USER_CFI=y
>>
>> --
>> 2.43.0
>>

