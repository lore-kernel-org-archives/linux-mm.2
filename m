Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F3BD3748A
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53B76B02BB; Fri,  5 Dec 2025 14:42:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C3C6B02BD; Fri,  5 Dec 2025 14:42:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1C366B02BE; Fri,  5 Dec 2025 14:42:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BCA356B02BB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:42:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73195B7CB6
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:42:31 +0000 (UTC)
X-FDA: 84186439302.08.F012B35
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 852DA140006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:42:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="a/bdHesi";
	spf=none (imf26.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963749; a=rsa-sha256;
	cv=none;
	b=NLCF2JXz5ZuK3GT3tN7kqolVCmX3nb0aTQi/zSEdQAgmtudisqlNbIYOgq2UPPIauW4Ilz
	rIVrNf6lpgergs+QaccKtMaWvt6NFAzvSVWjbWRc36tjJ9ZIdC6K2/vzkC708ZDU8Vcbcn
	Lj28218ObX5O/bTbrn67SkrWp2UBQGI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mgm/FMtyke96+ZxY7cquZNmO3PwSewNHSLs9FqvP1Zw=;
	b=yidDf1547aLxC5tqVJxrItHsMj9XsB4nfm3V94cVSbDKA4x6g9XaWpcdZsEHSbx/VGj37P
	IT/ox5BENEUcoBdbNcHXxtfi9oyoZ+KSy9q2Hu6prhESAetX5ZZKDojQQ2oEgamIIRXJxX
	L0J4m25KyGDYlSFvBp5W/mYs1i3wMG4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="a/bdHesi";
	spf=none (imf26.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=Mgm/FMtyke96+ZxY7cquZNmO3PwSewNHSLs9FqvP1Zw=; b=a/bdHesi5AkSwr4bQh57WNPXRe
	W2wtAQOpBBAlcZei2JB8AuobRhAdof+Qt5iT4owdX6N6cKp4zyn9WbDfOpYDzT6a4wbMcbjERRy12
	McbStsV5v73E52GB9/rc7S90e6eUxLj64tT9+irQrOTaQqWZC/e24LUKJPnvZBFZ6HvkTS9kfLgk4
	Pft2YbM1xe5fEaecIe9i1HJXvh21A4BCViEf/hLCVvRBGqzj+HUfRCyR4xP1fBOPLQV+0o6tbuEqE
	xZi5nZP2QCYLNLhZyw+9MD/Hgr3yKlIa1Am5XQ4AxoIaqDMNKJHO+dzWI+21eiR+BiXKZooCBdUzn
	3TV/HJlQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vRbgm-00000009yBh-3a3v;
	Fri, 05 Dec 2025 19:42:00 +0000
Message-ID: <14afa916-565e-4c25-8e19-ddb87644ae8b@infradead.org>
Date: Fri, 5 Dec 2025 11:41:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v24 25/28] riscv: create a config for shadow stack and
 landing pad instr support
To: Deepak Gupta <debug@rivosinc.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
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
 <b5feba48-7e7c-4ab9-a193-072f3980f525@infradead.org>
 <aTMjS-Ok-DrJJjQY@debug.ba.rivosinc.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <aTMjS-Ok-DrJJjQY@debug.ba.rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 852DA140006
X-Stat-Signature: 853ifda6kq6ded317i3zf838n7p86ssm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764963748-224388
X-HE-Meta: U2FsdGVkX1/Hox8XrWD/HESwMJNFR22FULion5GQbcZoJmKtqhpYKykLV+LZziPftwjc0rs/HckeEXTJ0q2tldEnMS9M86YG4dBZF8AWB3OarveY0TjIQs1C/lDb3HPkCeddovul1sTrjO+K+RAHPG3Lo7TdK500euHHQBMxN4fD+K1pCyr/kEfjJ7BO6ZZENDJeocxU5RIbBeRGoZuyi9OTK52KC+dGexDuwVUajgY0wLjVACKobpD8lh8M84ckZiL4z5yd1Wz05qTTT2nhhFbG+RpT14CWdnpnN8+/5F+EM4lZA2uIMQdW0KVpXW12o3yBpVULVQnNmY9jkql3sasU5092JC5TTaORzvMmqhcl0fuEX8UuhA+TyxKxFHlOmVP5u0E8ygp8Z67ua30LfGBBwkVzevC+gISBbgcFC/ZQOpVF/4JzxCU2BFARdaa/qyXhh6JBEoyYw06xiQeUf8f5ezY0+k2KbbuYnFAOzDfR7/LJYSyGTKsHCID9i3dyr0RVRNsm3e1LwNhlpz8l7hn46uPEzGYgGBDgCmJe+1L44hCtixX3hVNTOj92YNtB4+3O+Sqc4Y25MkhxaKyi+sZPY9UvuKF3jSfvo6e2kut0Qqe/TA7ZTwUeLqTpjEqBFhjZeQd3Ktfve/iAQgVN/tnrW7e2KQNIp1Ydi/ylebpw5RVn81b0bY9u01Rw98YXJI6iRj4MfNBcfNmtGu01yQp3Yb4EQPGwbWaGXkBNsjPZYuCMBly2GWIxzVCfNtRS+BIWpWJYDnUT1KYf3QDp7ZdhgFDea7Pa6EDIrV8W/JbdMMhvh0nTNpMNhhFyegU3f/jFNhYr4XKq6BY/TiZv0hd8dJOP0WI2CGN4ohOEcJc+X/srLWe/CgcDQzgAZmg5NjGl2mO1oq1tlu0sMFwi6eydpeuby7b13aqX64sZkhetW+1S9TEg+C2vV4/KS9dVOKjsJLGvuLcC95v+0fU
 FdemtoqC
 rqfFCyYz4KZhsagvCCx0Qfts8SWM9QRH6cFivpt9ILKxxmWJCkW1uAVXlH2WSacFOgUkYU4766HQRXK9YOtFLPMjhbCNSOJ9ovr/8u5dKf7w7AraeAXJyrPkDFChlKvNrQ3xtXm0qDR+Y3atrPqDEDwH90eapoZDeV+JRZ0Ry1453d1aETkd6Q6aFdAZCqAIfokXbVkV7O7mncIK47VYCfV12i+yiXlJPAtUfG1XhJ+N8kpiY5uq4vQnuIRXUL9qDeJH+tjcTqkNYUAYH32oGn20PaLhNi6sM+S9r/peL374T52I311r2EmnTmv2CvpXQkVlniwk8V98TvE04WhG4MxHE7+OVnvAHKj9bNIpyz/RB5y+RyZXO2NfvU6svXAYG6mLtj441DytZ/WqkuML2AEDQZVdlKLEgXe2fv3d4vStaCyqg5utnY6EIn9GDoxHkKaBiD9zDqX4TQYj/zpat5bPXJ9obxTXgDX6+O+i9JCeNiE1dWML+G91RJI2XYT7ev3hsk0bmjM6BucLQORvypMBlStp7yB5RGCBJ7xfEqi6KORisNCvntGZ+Yrc9hF/zW7A4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/5/25 10:24 AM, Deepak Gupta wrote:
> On Thu, Dec 04, 2025 at 02:17:27PM -0800, Randy Dunlap wrote:
>>
>>
>> On 12/4/25 12:04 PM, Deepak Gupta wrote:
>>> This patch creates a config for shadow stack support and landing pad instr
>>> support. Shadow stack support and landing instr support can be enabled by
>>> selecting `CONFIG_RISCV_USER_CFI`. Selecting `CONFIG_RISCV_USER_CFI` wires
>>> up path to enumerate CPU support and if cpu support exists, kernel will
>>> support cpu assisted user mode cfi.
>>>
>>> If CONFIG_RISCV_USER_CFI is selected, select `ARCH_USES_HIGH_VMA_FLAGS`,
>>> `ARCH_HAS_USER_SHADOW_STACK` and DYNAMIC_SIGFRAME for riscv.
>>>
>>> Reviewed-by: Zong Li <zong.li@sifive.com>
>>> Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
>>> Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
>>> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>>> ---
>>>  arch/riscv/Kconfig                  | 22 ++++++++++++++++++++++
>>>  arch/riscv/configs/hardening.config |  4 ++++
>>>  2 files changed, 26 insertions(+)
>>>
>>> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
>>> index 0c6038dc5dfd..f5574c6f66d8 100644
>>> --- a/arch/riscv/Kconfig
>>> +++ b/arch/riscv/Kconfig
>>> @@ -1146,6 +1146,28 @@ config RANDOMIZE_BASE
>>>
>>>            If unsure, say N.
>>>
>>> +config RISCV_USER_CFI
>>> +    def_bool y
>>> +    bool "riscv userspace control flow integrity"
>>> +    depends on 64BIT && \
>>> +        $(cc-option,-mabi=lp64 -march=rv64ima_zicfiss_zicfilp -fcf-protection=full)
>>> +    depends on RISCV_ALTERNATIVE
>>> +    select RISCV_SBI
>>> +    select ARCH_HAS_USER_SHADOW_STACK
>>> +    select ARCH_USES_HIGH_VMA_FLAGS
>>> +    select DYNAMIC_SIGFRAME
>>> +    help
>>> +      Provides CPU assisted control flow integrity to userspace tasks.
>>
>>                CPU-assisted
>>
>>> +      Control flow integrity is provided by implementing shadow stack for
>>> +      backward edge and indirect branch tracking for forward edge in program.
>>> +      Shadow stack protection is a hardware feature that detects function
>>> +      return address corruption. This helps mitigate ROP attacks.
>>> +      Indirect branch tracking enforces that all indirect branches must land
>>> +      on a landing pad instruction else CPU will fault. This mitigates against
>>> +      JOP / COP attacks. Applications must be enabled to use it, and old user-
>>> +      space does not get protection "for free".
>>> +      default y.
>>
>>       Default is y if hardware supports it.
>> ?
> 
> No default Y means support is built in the kernel for cfi.

  (if the compiler supports it?)

> If hardware doesn't support CFI instructions, then kernel will do following
> 
> - prctls to manage shadow stack/landing pad enable/disable will fail.
> - vDSO will not have shadow stack instructions in it.

Thanks for the info.

-- 
~Randy


