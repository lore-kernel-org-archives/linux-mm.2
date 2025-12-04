Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 086E1D2A55F
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 22:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6634B6B00B4; Thu,  4 Dec 2025 17:17:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 641F06B00B5; Thu,  4 Dec 2025 17:17:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5523B6B00CA; Thu,  4 Dec 2025 17:17:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44A5F6B00B4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:17:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EBBA513A115
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:17:58 +0000 (UTC)
X-FDA: 84183202236.28.A0CECE8
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4EF3040014
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:17:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pOEb2Ri0;
	spf=none (imf27.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764886677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6QVH/SWdP5H8bXIHeIZZPkQwVxQdNZJmtX24mN9i90=;
	b=Jc83Js1zU9qY5utaKqgvhEFFIo6cgi4dS0s/H9xTAgOmbtIpdYuk55Fm4yAoyVf/lyzYeT
	Ann1FP9HEdpMWTzE7EkxAgiFtmMDVcP+AI5CReBrPfbVLBkRFaqwTUQBfciNmZQ4IGkqFm
	e0nuB/Z186K1TJCLiQW4CSLsD5p//sY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764886677; a=rsa-sha256;
	cv=none;
	b=Yu9Tw5NB71/xxHSFncFCtgh6ZtdjfHh8l0Nyg+XbPI4ZUgWRw4zFpa+EC4t/w36kyrag2+
	zPFVdsvkMSCLFpIU9wU/N7W2Jnch9OUvckUbcJBCN+X5mqf9MfQGuIpQtxSFd5kw1C2wLN
	EuuhfBAYhYOOhmVi+4/v8zA/ZOpz69I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pOEb2Ri0;
	spf=none (imf27.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=k6QVH/SWdP5H8bXIHeIZZPkQwVxQdNZJmtX24mN9i90=; b=pOEb2Ri0+biaDj8R76FKt8db8+
	gNL4On3s42n2VRZLuJ70zlejVBo2mDgEk/EYYRx/Yt6E52rWb2buoeFpKyiPguCD0G5syhjXcXBeU
	ze8d4CiTnMu2hAUWOfHD86DLXyVg/QKtpmBx4m0/vbRsPbjLQpe1akjW3F7V2zP6njlBxdpOguU4j
	0FcrSKxHcCoKKFK4udrdX7Rn0v/C5CI+Z+ck3F3guEDNZ8VW0MRBqjbP2vKfZa5ixuhKpyMsGsRBk
	Ut7N2ENViN/YTYVaQce/7brCDDoNtk5mhj0U25jHEnkusKsVLvJxUrtBZEPmPok1jgN5WvqEg5/PM
	hiEYREbA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vRHdh-00000008ihQ-23Ud;
	Thu, 04 Dec 2025 22:17:31 +0000
Message-ID: <b5feba48-7e7c-4ab9-a193-072f3980f525@infradead.org>
Date: Thu, 4 Dec 2025 14:17:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v24 25/28] riscv: create a config for shadow stack and
 landing pad instr support
To: Deepak Gupta <debug@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Christian Brauner <brauner@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org,
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com,
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com,
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com,
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org,
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
 Zong Li <zong.li@sifive.com>, Andreas Korb
 <andreas.korb@aisec.fraunhofer.de>,
 Valentin Haudiquet <valentin.haudiquet@canonical.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
 <20251204-v5_user_cfi_series-v24-25-ada7a3ba14dc@rivosinc.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251204-v5_user_cfi_series-v24-25-ada7a3ba14dc@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4EF3040014
X-Stat-Signature: cw3s1wpnbgta18midiie3pc6fm4ywn1d
X-Rspam-User: 
X-HE-Tag: 1764886677-121579
X-HE-Meta: U2FsdGVkX1/FsCecOtWVGaDJJaDLG06CAlM3x0jCIIkc9XMx3kTZL9hVQsyVv602xMFl115zy8r46WEHLmfT/ua2RZzB0JC7wnG/H1GvyPgV1P8nl4GrF8cnRnc2OYnAp8usmsgVjH0MH58eTa6ACRdXmUVL2xV8JmVRarMJipAKZwv07WN5rWbqp9dkQk6U5OBU008swGk6KC+KVXxBJyZlf+iWOb4Gz7lHS5tTRKGU4zmcR4dS3DsH0GAtWUCrIhZ9O9zNANTCKKmrO7QVM+MSJt9Xc49CfVgMG6e9nNscH7KMXx1PQa7faFXvZ22thyaElwONqEqRHPELxsHiZRinAEa9sXQ0atYWWAWtAZuCxrzVIUVA7JA2d5CrbwL1Q8c3+5mnesPygsgAWj+vJTeLj9+ba3IcLEwPYz+lgnMq/IXQxQc3YlDHi2dKqOXwHJ66Az+GVlTMbxoxa3A3RM6hcEERA41sIlu4WLivzVkkJTl6x94t7tINae7WL8/HxHe/WFLmUPNwhSsUI1AZ3sQxmxqBRZyxpY9tAytGKwa/HYkiTy9vTpzdCaQ/3P/469yn7D/9CIc3W/+6lli5nS150vyfl0uTCeR57QBndW88ZPUhTU0J6GG0Dk+FITsiIie6HTvRVikZGyC7XEoR5q+HyXSUs8cW4nZUjzkJxxhD6huw+6FPctH5oUvfPwdxeQJZ2/FGlwOfog1sQazohCl60mkJOC5FZb3LOJHOnAEBO20gUS3R+8nl/FJs4fWkclpKR+Rpy27efYmE/+H/rC6l7+PmzVP8WTehUEO7p8+HnqsdsSuB874hLzAEUHHe/QUF673jjSQTc2vGKVGwOighzRY0sRpcNn8BQxLJf3IEfnBrCkEkhMA4DrqITK31qs+1PhIMxx2NnXkmT5SNKcdm9fOX6FdukB+fr4DlU/kzjtgAZxQe+sVL71AY/kEEugjRbyBAJSfoGJ7PIQw
 n8q3CzjM
 FlqIYtc3e7V43AsTuP6iMU7k0aDWu8M9mLEuHwIqyRlBC385bGPyrMCLAZMNlmI3xvpGimvYatjyEB982ye4OaJ8K8+xFhF/BpICZsYDxqpdy5tjgWTqWLDa+AUv90+p5KF7wdpWC0HKUJ07OEZyJ4/aEfam74CI52IzSVltRs3Fb88dPj40+0hUcw7h5ASRGXNrP3/1dMMcnnmcP7apO++6Swfg8DlATo5IlkiC7WFBo39WFDyOCnh10h7bm/WDbQR2OnjyHCQAAejpNnSJmGUWFHYHvue8S6nHSTcXbfo0KBc/AK5KzufuHagLD4sjxzhagQ+qzM5SyegQKj7FpmM5IehhTp/UFpjhSMoCvCqr6NBL9WqoIheV2PcnDvmiaKsUSwFdK/AGwVbmoESIWEPawpjEdA76AshIHSFOiA4bZ2lKJCsS+7FH9nCVkUMA/SykSuubIBZ6asKlORQlQaE9FeN7wQU0/xClFt/K8ndEfr0NbAtOQWCVhyWZS4n/pQjgsBAJBj5SZYdjjwk3ort/nYH81rXCmQBs9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/4/25 12:04 PM, Deepak Gupta wrote:
> This patch creates a config for shadow stack support and landing pad instr
> support. Shadow stack support and landing instr support can be enabled by
> selecting `CONFIG_RISCV_USER_CFI`. Selecting `CONFIG_RISCV_USER_CFI` wires
> up path to enumerate CPU support and if cpu support exists, kernel will
> support cpu assisted user mode cfi.
> 
> If CONFIG_RISCV_USER_CFI is selected, select `ARCH_USES_HIGH_VMA_FLAGS`,
> `ARCH_HAS_USER_SHADOW_STACK` and DYNAMIC_SIGFRAME for riscv.
> 
> Reviewed-by: Zong Li <zong.li@sifive.com>
> Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
> Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> ---
>  arch/riscv/Kconfig                  | 22 ++++++++++++++++++++++
>  arch/riscv/configs/hardening.config |  4 ++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 0c6038dc5dfd..f5574c6f66d8 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -1146,6 +1146,28 @@ config RANDOMIZE_BASE
>  
>            If unsure, say N.
>  
> +config RISCV_USER_CFI
> +	def_bool y
> +	bool "riscv userspace control flow integrity"
> +	depends on 64BIT && \
> +		$(cc-option,-mabi=lp64 -march=rv64ima_zicfiss_zicfilp -fcf-protection=full)
> +	depends on RISCV_ALTERNATIVE
> +	select RISCV_SBI
> +	select ARCH_HAS_USER_SHADOW_STACK
> +	select ARCH_USES_HIGH_VMA_FLAGS
> +	select DYNAMIC_SIGFRAME
> +	help
> +	  Provides CPU assisted control flow integrity to userspace tasks.

	           CPU-assisted

> +	  Control flow integrity is provided by implementing shadow stack for
> +	  backward edge and indirect branch tracking for forward edge in program.
> +	  Shadow stack protection is a hardware feature that detects function
> +	  return address corruption. This helps mitigate ROP attacks.
> +	  Indirect branch tracking enforces that all indirect branches must land
> +	  on a landing pad instruction else CPU will fault. This mitigates against
> +	  JOP / COP attacks. Applications must be enabled to use it, and old user-
> +	  space does not get protection "for free".
> +	  default y.

	  Default is y if hardware supports it.
?

> +
>  endmenu # "Kernel features"


-- 
~Randy


