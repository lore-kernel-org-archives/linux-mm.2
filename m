Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B501CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBDAE8E000B; Tue, 11 Nov 2025 13:22:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95508E0002; Tue, 11 Nov 2025 13:22:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAAC58E000B; Tue, 11 Nov 2025 13:22:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99A578E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:22:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 565651DF5EA
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:22:16 +0000 (UTC)
X-FDA: 84099145872.01.1033F60
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 44DFA4000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:22:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=fkW0SGUd;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762885334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIB2H6PdyJ1SkmEweEXB/zVmO+ijAnVaHWzNPmEF0uQ=;
	b=fWjFKcpnLSdaRi8fmZT9D05GMwstk//Wi2XQInrW0vlpHALNr16QnLmLx6W7ozf6fliBJP
	6u938ncGnWTb2oBsNrGfIcNuLIVTYOMOjSvyzyzAel0iinAEH6t17FPNf0Kyi1e/qgCPd4
	D5AzP/bRKKhW999qw52UkJgtPO/fh60=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=fkW0SGUd;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762885334; a=rsa-sha256;
	cv=none;
	b=ZL8t2WvcdtQ9dYlJDoL6tbaYJhr5sIsIHuzKJBYQK+G0yGhZZBIJ00jAaVR2g/HNuaCudi
	lRDbC2tjVMToOCoSXltfM6JZV1UNmH/Ee3zVuVc28ZXAFsHps6xWNCu+bu5Sj4DiF6Q29c
	tcOfiqTES8KOJjSxEPRqA4msdAL+JI8=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-ba599137cf8so40360a12.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1762885333; x=1763490133; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WIB2H6PdyJ1SkmEweEXB/zVmO+ijAnVaHWzNPmEF0uQ=;
        b=fkW0SGUdMHBMJhhwr4TF4zRVVwXCRWmIXLLDp4hBa5NHn/BsR2mTR4Ov3QFGBV8Lxj
         3hcR8KvV5693gksHQ6hiOJDfgu+VHTqQOUnYzOOLs3qFAG0T9ORvVACTdjGqYxG2C/4H
         4JFerEMONrXiAuKB8qcL7jaE7djk8ZN1wWOOP2Q5UBJNu/uGkiJQg/2KHKe8sq9oy3td
         r4ki83l5uaOb44rPpwg+9H/yVGTdGP5Qg/UwMKqpw4rkfIzovYVKt6mI5pqXergzQGqi
         f9afkgt6VOiQs5ElUryDAnVscsDQgaHtoqopIXfh7awAnP1lqnuKjAekele6q6RIhiqz
         b70Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762885333; x=1763490133;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WIB2H6PdyJ1SkmEweEXB/zVmO+ijAnVaHWzNPmEF0uQ=;
        b=F99iuhYqcyodEa45OZSXvZ3dH6xe4voHyQsYcdSVkJ1w+qMD2W5b6NvG2CCq0YF3Oi
         AQ90sPRaYqevnmMayO/Bzi73nN3iagbZqbicDVjuvU/QrkzNBCdUXNS9ZBUBz7LxfF8m
         ndDhwHQwHcw66gFHxI4f3x24dD8dOTnNnOOHtE8kp2R5yXpJ52MSkANknSbLMA6nwyCZ
         B0NozrIjxBAqoEF12flCdZ8U9t+eJ6vYyNQ5YsFHByvGlVlGXHSC57WYBXsrczfUZN3L
         P/rAuQzwj26Y0IhZzOBOyc5gpbo0UCoELANWBw05qsvGDJS3b2SDaXeC3Qaov2y7+kKf
         Q77Q==
X-Forwarded-Encrypted: i=1; AJvYcCV9qNaAs+CpnjEQPJGhL2WjWbdPokbfcqiU3JtV8aw0Tq5oILn8juIxfYe4HDbzR/iyBLDzyLVCjg==@kvack.org
X-Gm-Message-State: AOJu0YxQgAOykzw3HlTgQrePRHERglRcf5T0JgJfTzDA+fyzAfDshX5Z
	QUkqYpSXmw5uD9cqyLic4E0ToP0saKt1O6LH6yZP7ekndxfK3kyYO3tuxzoJ9SWsu6s=
X-Gm-Gg: ASbGnctPrwNFA5i1yV7PDBb3ybzeiJqCr5Qh434DrYm4ApG59ZqfwREFdPMijd10S/+
	4mhSdIsKihSkaqi8X1NKx07wK74vh7wrMiHX5f4cVADFZcIebupk5hdz4ZA4jbow4uhNImLdGHQ
	JDe7ls2eoBJaN6PguvnTVstOwOLOday+hKrX+Zn5aXbxQEbEXB0/jF41v3T1gUgZ0KLrGx+tTM1
	tAorfyqcRu2fjfJ3AI9Tu5X1BwCjnIxX5mDJqpBVlrkVyOeweykpn/5lJswbP7Sq1m1RuIkl9uS
	Yjea61WswUNcSqkcNyWBqBXO0vzjWDe9kaOmGrw5E54YOpBxPby/FeTGU3BOLPzG6Veia6z+9e9
	h7FmAwYnFgOkZN78Ycamcr8zgylJjSuNx8zQeyCxTfTCzfOj5wvBCbE2E54AjWtDGH1jj/9yscV
	ihCdCQFhehNw==
X-Google-Smtp-Source: AGHT+IHgsZ6GDRjZreNqZqXrg+8gWBFkhsOds9i8Gem5eMBAg33B4vZazV1IYc7GtJj2mgzKsVOwwA==
X-Received: by 2002:a17:902:d551:b0:282:2c52:508e with SMTP id d9443c01a7336-2984ed41a29mr3269885ad.8.1762885333020;
        Tue, 11 Nov 2025 10:22:13 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2984dc9fc2csm3813175ad.53.2025.11.11.10.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 10:22:12 -0800 (PST)
Date: Tue, 11 Nov 2025 10:22:09 -0800
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
Subject: Re: [PATCH v22 25/28] riscv: create a config for shadow stack and
 landing pad instr support
Message-ID: <aRN-0Z9MNeJ9IZf2@debug.ba.rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
 <20251023-v5_user_cfi_series-v22-25-1935270f7636@rivosinc.com>
 <CANXhq0oEpCow0G+KsJ6ZPuwsxmAFVqoKGEzygiwSmxFsmntiWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANXhq0oEpCow0G+KsJ6ZPuwsxmAFVqoKGEzygiwSmxFsmntiWg@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 44DFA4000F
X-Stat-Signature: zneyqz6t3j9xbmfzmowuitdrfbyuyr14
X-Rspam-User: 
X-HE-Tag: 1762885334-65995
X-HE-Meta: U2FsdGVkX1+oIghn6MUp/Qsv8uSeuhbUHgJjfblOIch9z/oneFYABFOAS9lxELGWEKKDa/ndPf8GfByZyx15qW4A0tk3ilfi3AfRRybtcZD1tPyPZ/nmZYSbhUTbns/MV2hQSUUF0diPbPYSG/jIEfPmDF9YvJDCWErY3CHRFbHmQRXdrB1HE9TAG8UGKSCrodtP/Kt8jeNqK9QKkFC/bQdUNGclFPQACrcaXwzy9K6DYyVJkpSO4FddTGK5vjWu0MHdUTCd59TFrU7te4KLI+zMlbje27hB+7943elYP93/yuDT86eHlWYf79xygcxjK1/MAOq5EpzmlY/X2Jr5cWbJ3uA2oHCXSIqb7eZwgxG/hYY76uDqvJjFAb/bqnlRjrvYRvaYTvDEmZIZOO9KcOoaFcElHBbjyFUn4wfS9DgwO4UXOTJIZxmTPqOgte397SIM1jq0Jzfo5BX0jmwrY5rZ1GiB9TcZLEb2CbhsZ6cj+7kcPuJP1In+R7O1nSDNtnOeZEPL2Jkn8AZ7K6BmMz7l96CXHDkX7CCJtrnLQszOJJVDzkW0Ko10Ym9F/itrVqCKEG0QITzqJWoX1P5ooZNiROO1zqUL6nezid1LWTsVC9kFhB75/qYrUpoG4STgr2vfwpAKGx7BImCqh5w91F2cfXQPEhrUiP6hrq3x+a7+hKO0Uv+2R7zyz0wEQomEjUrIsTMaWRcMGxAeDLaxX111r7Jv4CKj1MaAEhddXgmHhtKy/fKfa15D5IjoELMH9wUqvNzGdyvm4s7x9Y+5waSo3forcFz/RUrINTouNIz/JSj7J5FNu9r71JRvYIIbdM3ofPewWbA4LfCq7bjGzx6w3eGhNViaLHpipPj4WiVRVrT+DHjoWzBqQZ9WfzTadk/tbxZaqpJ3/T+us4Sw8sbRwHeG/wr1r968N2w+GJGqMpw6pT2gOWyyK5IrI4q2JyUEG8J9FoSaIFjgbrw
 c1fnwKNy
 x10N5uMuID8ODwEGAmx08ioro8hsXD/AXbEYfrEIjEDnhLuY7dBgCKEmTaZ8Bx0VGCQKSIcc8QKb1dJ7B1DC3GtOEmjCiUU6ULa3x6jlQYbU/qusw6xo3GBWBshbrV8sXFzxkDerF1ujfj2RnW3w+bnAB/yF7eKKGtkxI6dbn7WpOdFMMIqWyJFNjE8y3Zr4Ly6S2hKgA7/Y9p7DdJwKtev6v6azyAgmK952q8nv/ua4EA50ADOh9ySVLKK8rW6ZYPD1+NPTgib9e32LOarF9b607A//CxCLG4WKZSmlQS/ltDb6jcJAOxaYXMLu2hZy22tCmyW9GLK99bCpjZE7bGG/+kxfQ0SYI65sN7lhBMeXE862DvCfY61p8M8ALCDbycBdv63lW7LlZEgYhTQ9MsRe0tmksxOiPI5NuKVrPL9fRMory43lrO6pyO/NM8pBTdT2/qg9yGGaPL62rJx2HDZ9I6TaeKQKcbESxz7HuGxmJAau3tLxUHIkEfnXU8p4PxeyU3pQJCReXcEK9SaTJdEBFzIRX41WcOXmyNTYfO+x86ilgDIiRsmn8iQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 01:58:37PM +0800, Zong Li wrote:
>On Fri, Oct 24, 2025 at 12:51 AM Deepak Gupta via B4 Relay
><devnull+debug.rivosinc.com@kernel.org> wrote:
>>
>> From: Deepak Gupta <debug@rivosinc.com>
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
>>  arch/riscv/Kconfig                  | 22 ++++++++++++++++++++++
>>  arch/riscv/configs/hardening.config |  4 ++++
>>  2 files changed, 26 insertions(+)
>>
>> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
>> index 0c6038dc5dfd..4f9f9358e6e3 100644
>> --- a/arch/riscv/Kconfig
>> +++ b/arch/riscv/Kconfig
>> @@ -1146,6 +1146,28 @@ config RANDOMIZE_BASE
>>
>>            If unsure, say N.
>>
>> +config RISCV_USER_CFI
>> +       def_bool y
>> +       bool "riscv userspace control flow integrity"
>> +       depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfiss) && \
>> +                           $(cc-option,-fcf-protection=full)
>
>Hi Deepak,
>I noticed that you added a $(cc-option,-fcf-protection=full) check in
>this version. I think this check will fail by a cc1 warning when using
>a newer toolchain, because -fcf-protection cannot be used alone, it
>must be specified together with the appropriate -march option.
>For example:
>  1. -fcf-protection=branch requires -march=..._zicfilp
>  2. -fcf-protection=return requires -march=..._zicfiss
>  3. -fcf-protection=full requires -march=..._zicfilp_zicfiss

toolchain that I have from June doesn't require -march=..._zicfilp_zicfiss
for -fcf-protection=full. If that has changed, I think this will need a
revision.

>
>
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
>> +         default y.
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
>>

