Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8502FD339A2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB8496B0203; Fri,  5 Dec 2025 13:24:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68BC6B0205; Fri,  5 Dec 2025 13:24:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57C76B0206; Fri,  5 Dec 2025 13:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC636B0203
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:24:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5460B133436
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:24:18 +0000 (UTC)
X-FDA: 84186242196.07.DD3D0CE
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 31A31C000B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:24:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=MvovOzlN;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959056; a=rsa-sha256;
	cv=none;
	b=BvPbkynT1L8W4WlIw3eDBZbuGfIjuSDwCQ0PAn/1YVnIwc/UcX+iBQ0NA9+W6X8FtXXQvr
	eP3AkXvQ1azUQAFo/bAS7ldJdY4opETAdUrG0xfJHgh4ZduPX/x6uaJxvIWcj1EmXBFBj/
	g/kJPgkIcTIP4qncM4s97xDZyaMhi/A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=MvovOzlN;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8W7GJchcQ4zk/poJ1GR6L1BtfcBrmnZJJRAQLqexSM=;
	b=1kAabRPDdA22LMV6uCqN94fcww23FmrJzY2UiWWgP+asbajUDkaR8yd1iEpc9s1IV6UWhz
	TgKvLiu1YmgJVZ5YhdYTEf0RkGVjPheEn+5S5649/w8aTJ5+W3sGsI3CCsvjE7UqKtKz4A
	1DS1hsdzGBcWdZWzzyWdWI4Y1oel9OI=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29ba9249e9dso34066155ad.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959055; x=1765563855; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R8W7GJchcQ4zk/poJ1GR6L1BtfcBrmnZJJRAQLqexSM=;
        b=MvovOzlNRKni5XwCdP/xLtzaDZsEboAriGWbX/uL5ZjcMAsjxQsqGPG6vRLX36kxtf
         mjNGCHXaGbepqHOjYInir6qBHiozlOIAUd+fYHQvX6gNgWXHMjA2DyrYOlfclPBL76WT
         6U3dIPUpPLzW2/Gy+m2cy1jF1HvEhZBJX69i7bas8leeZ5sl7yd5ZIOieFG9ntqsEZNr
         IlYa4scB7pB9NK4iZms7mx5M9AMfrc53UnFxbCKfg/6h8+pDuWHMwwDeNhknk6bN1BZy
         seqvDfpNkoE0QPSthjnUO6JI+nC9OEiv+q5cqNY9CGpeZMFbOYuiF3VCTbY8cIP6viRC
         1T+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959055; x=1765563855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R8W7GJchcQ4zk/poJ1GR6L1BtfcBrmnZJJRAQLqexSM=;
        b=J7Bdjv0RS1/xYttsggVXqG81alQubQohYi84S3gq6tB2dkmv4RDx94TFehz8fkRllH
         aj7rlI5e/OTJzfcpR/dxy2Db0h+g62vCg6W996cio32zuHAsa3o5gxWFTsAnIvXa4aGP
         4xaq+umwzFV9BjBW6X045WN7w/r6JQtLZU1PRcPcMU81nufy9vtLqMFV+PXQRI4Fh0+Q
         ZHRxRNVhm5OjakgZLxX1G49nl8YrqJXNcxh6gN+eXwrmEQGrzTB8isiuyMYlKE5o0YlV
         s/JTZZpIffmMgeiZcIDwX3WqXJKu/rIp1yK1L19pXKfVjZkqe9b/fmb6ZeprOM85g4IC
         KqJg==
X-Forwarded-Encrypted: i=1; AJvYcCXm8YPSyrPqg0gYA7Sz/f7K7sYIUvCCj0Qb/lyt2nKXn67rlR6TvofNeuMw9kC2lBmgY5PX1d8H1A==@kvack.org
X-Gm-Message-State: AOJu0Yz2iyYYCODatRuwS6i+dAvvrvKJbPL+X35qS5Ha8/SyI+cTPj04
	SqIFlE554SJ3Jf85E0CeACmLEKx68ib6OZ694LMrjAMIV/A+cP//O58FK/L6X1yI3gM=
X-Gm-Gg: ASbGncvG9vNngVWivatQoXpC7nlpLQKDMUqR1lXDoVd2mMFx95FM8RnN7bWkEoTW24Y
	x78a+y8Y2AgJY5KtTlaA3bkHP+NUxZMCbPvV6yU4aBzm+d3fAW0PwcS8QWN5RdJuOViej+SSsZa
	MytvwVr1PedAvc3zaP09I/QLIpy/IwdFvA9YPV9D5nOX7ZpgpZNUQrTORPlapMir8ZBhwDvpvYj
	1pSNFEqZ2pqA30jkSw9q/sJHslTsnbKAEKiOehI2zuUcAGe69MQgt8b3z2XopEzjKM7O50VRfaq
	BwgApMmEPC+LSQ7jBw7ZfdtB6odza/Bo5SUnV6aei3yGsbOhkMrroaR/60jzxEYOAn2s/Op5aaC
	uiGSBuydYMmemeZQBWsNomLDiRRpMYZMiNqmtZWEc1FkBiwHfiWV8nZWEhNcxYnGDV3iQkgm0nd
	0s2oqsf40/ExQHZDer6hTL
X-Google-Smtp-Source: AGHT+IHZMCsXUTCjOVQ3AFVu8onlvt7po3LO4OEVVdk3jTNgtLDl44M+FmDz1C3tnLg32Vfv9eEpZQ==
X-Received: by 2002:a17:903:11c8:b0:269:4759:904b with SMTP id d9443c01a7336-29d6848df81mr135161565ad.58.1764959054851;
        Fri, 05 Dec 2025 10:24:14 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae4a13d2sm54863235ad.9.2025.12.05.10.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:24:14 -0800 (PST)
Date: Fri, 5 Dec 2025 10:24:11 -0800
From: Deepak Gupta <debug@rivosinc.com>
To: Randy Dunlap <rdunlap@infradead.org>
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
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
	Zong Li <zong.li@sifive.com>,
	Andreas Korb <andreas.korb@aisec.fraunhofer.de>,
	Valentin Haudiquet <valentin.haudiquet@canonical.com>
Subject: Re: [PATCH v24 25/28] riscv: create a config for shadow stack and
 landing pad instr support
Message-ID: <aTMjS-Ok-DrJJjQY@debug.ba.rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
 <20251204-v5_user_cfi_series-v24-25-ada7a3ba14dc@rivosinc.com>
 <b5feba48-7e7c-4ab9-a193-072f3980f525@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b5feba48-7e7c-4ab9-a193-072f3980f525@infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 31A31C000B
X-Stat-Signature: 57txutrii5dadwuoo6dz61iaw115yd44
X-Rspam-User: 
X-HE-Tag: 1764959055-786283
X-HE-Meta: U2FsdGVkX18fO2NODVtU6MWyX9H4O8OO7/8buctoQeRVirAxsA62UZ2yf3/YTr+V5KEdbbR0hCBtolY8stBvmGbUrmP+yKbxBnXAAWhFGReDfDTxs4YOyE6tJt65aIeUcS6jCm4KmTeHlpau6dZBzBzaH9amlF20yrPM3uSq0z7qh3QeRnKZm+GI482k5ZwsErEH19nzEdvK/8bSUo9JE0ZjxXeg1OgtQAR5C6EWjisxx/BvFX/RLVDc3nMZLozIfo2e6YnM/KCwQb+JwP/PcFyh2ZzynLb1+3fejTAehcnxneZku9SRzJdSYQIwmSZt4u48y7qVMkQ9Wo5Ik0/WUsXJzdzXxv58Mt5axQUggP1cr0Mh6bpAdBT5uERmOJZYK3+NrmqH5msQkLsKbpUu75e/mqSd/W8cBTgSfj2GkSdfo7pkX3Iv7WHx0aXdg5PxoWsG3bsTJDZ+9Kp3cN8TPIbDqUKuM1zjP3icmIszdDtLuEuTqydc1KGSnmCdp/rP17QlYbzrm4Ktz8NjYQa/TvUIEO2ezM6DaBZFmSoCWAOTUI9+UU0SC8Lt5whOo+OzsfEtYFe9aTJLbEzvD+6bgEwibgtIxH+U5mnKDYUUHw7UfFsmkS8ttCTH/pUSMBBvgiOjVCQhj5RIVrqssi+e41CwpbM+XZUFd68RZa3WkV0/QhASZJyIJ5RDhW7dEAJ6vwwnjsOdH+7uFz040ACUZjWWgxrFqqs4j1+8vhSf7ngw7XhDocRTXXTXNrcMzJ3bCi40StgGTW6JHAFjYr7AhXvlIImGYRAZ7KhFKP9cRkNJzWxCJYayH8EaDYlP7Gbh5DA32U8nRIY+Spw65iGA8l6oGm4kfAJsGxjIQvO0JHDBhcU536aLaUgPDKuo2CPrZ8a4dmiYiyzWZ1euOUdSozNjq6Tz1wwJIFxEFFm61TJSPxB+utdo8CGBwEOWlM290vntEsrwIvkeiX5lqVR
 Iacac5aq
 h+kxQ+ntGpPb51b1oV3C9ZZlbI1I72NfAxkIgqy33vYm0lIDEYw+33Y88uT5+bvkjeY+LYYv8a/KKpBduEoNqLYMwi/4Xloh0Yd46lG5aO8Wuho7/dQnA462LQwkmCl1wVmQR++oRSd6x/TIJyQ0NoTW+g6jNgXscbt3ONf4errF67zjM/h7bd/SV8xiGZ6B2Bi4Xdgqc1pOxZ47B27pd7Wh0H0XmG1dlB2S+3L3cV+J489uC86kGwH9WTUBuWSu+6fgCBPwKI+wiG2BqW1XltDVaubesVb3syE/Q4sfyWLU92Ln8jUDvb1e8b4Tj+Py0RlrBay7Dte46DUQTPMzdqYLlk31mKNXLENFCKGxd0GGGhJu9G8nEso+fk4LIEn62F7JdyFVE9+lJBu1P9iAwcgJZDQx24xryUpsB1wgLrvIYnQmgcTNHh6IHvXDsXduVySkg7UAI+tWflfyi66qj7uPlSVwbSQKIx04iHhWiutYu3beNNmOdv5aAoSWRmFGiy6rIwbWX/ITpNMqikWknkXQAf+DBrHqCoJq5JXUwN1X78zrMyPx+VyTLpRAYmpYka6pQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 02:17:27PM -0800, Randy Dunlap wrote:
>
>
>On 12/4/25 12:04 PM, Deepak Gupta wrote:
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
>> Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
>> Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
>> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>> ---
>>  arch/riscv/Kconfig                  | 22 ++++++++++++++++++++++
>>  arch/riscv/configs/hardening.config |  4 ++++
>>  2 files changed, 26 insertions(+)
>>
>> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
>> index 0c6038dc5dfd..f5574c6f66d8 100644
>> --- a/arch/riscv/Kconfig
>> +++ b/arch/riscv/Kconfig
>> @@ -1146,6 +1146,28 @@ config RANDOMIZE_BASE
>>
>>            If unsure, say N.
>>
>> +config RISCV_USER_CFI
>> +	def_bool y
>> +	bool "riscv userspace control flow integrity"
>> +	depends on 64BIT && \
>> +		$(cc-option,-mabi=lp64 -march=rv64ima_zicfiss_zicfilp -fcf-protection=full)
>> +	depends on RISCV_ALTERNATIVE
>> +	select RISCV_SBI
>> +	select ARCH_HAS_USER_SHADOW_STACK
>> +	select ARCH_USES_HIGH_VMA_FLAGS
>> +	select DYNAMIC_SIGFRAME
>> +	help
>> +	  Provides CPU assisted control flow integrity to userspace tasks.
>
>	           CPU-assisted
>
>> +	  Control flow integrity is provided by implementing shadow stack for
>> +	  backward edge and indirect branch tracking for forward edge in program.
>> +	  Shadow stack protection is a hardware feature that detects function
>> +	  return address corruption. This helps mitigate ROP attacks.
>> +	  Indirect branch tracking enforces that all indirect branches must land
>> +	  on a landing pad instruction else CPU will fault. This mitigates against
>> +	  JOP / COP attacks. Applications must be enabled to use it, and old user-
>> +	  space does not get protection "for free".
>> +	  default y.
>
>	  Default is y if hardware supports it.
>?

No default Y means support is built in the kernel for cfi.
If hardware doesn't support CFI instructions, then kernel will do following

- prctls to manage shadow stack/landing pad enable/disable will fail.
- vDSO will not have shadow stack instructions in it.


>
>> +
>>  endmenu # "Kernel features"
>
>
>-- 
>~Randy
>

