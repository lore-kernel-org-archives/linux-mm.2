Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3567CD2A54F
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 22:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880316B008C; Thu,  4 Dec 2025 17:14:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8570C6B0098; Thu,  4 Dec 2025 17:14:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794836B00B3; Thu,  4 Dec 2025 17:14:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 694416B008C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:14:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 027C651B4C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:14:20 +0000 (UTC)
X-FDA: 84183193122.24.35CC96B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id E1BEA40011
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:14:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CMRJdK+Z;
	spf=none (imf07.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764886459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2/i6tqDCIVXBXVD8CTjzLJznCHaAsCezf47hvRHxGY=;
	b=eIFMkpsNG9LpBqcGKEH82s9F7A29subeeTsxIJ8B7t9JNH3M52WOtLfjJtchG/hj4dVrA6
	OicunRmNk76YxELyluQU9up5sKuGOoAfldThfLYNsUKO2+iwRzP4LtjdVqcONkWLBy4KfX
	o3rhYKSUNwKUxGRnjHsNP7NvBtJ6dnY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764886459; a=rsa-sha256;
	cv=none;
	b=dy1h72euEp6zW29DekButqu0I2O8bAs+ZqFdYEkTMcHDinE67929cQa9LN9F83WQpRk2b7
	s7ys34ytEulvxbr1vuu5bAt1jbmAT2V6VnoU+a/Wfl5OIHnp3qyjPcwVjkOKO3K2ZjfDs4
	jGc+cTym4mgkqYte3y6rqjwAel10EPI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CMRJdK+Z;
	spf=none (imf07.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=n2/i6tqDCIVXBXVD8CTjzLJznCHaAsCezf47hvRHxGY=; b=CMRJdK+ZbcmgHBQ2EDY6oHHSbY
	Vcxx1NBq/NHUPSj3amS4gy/mnNqsVjAVAiP2Xo+/+PRhk5oesoF+8pe1dAxtPtmyHO0kn1L8zIX0Q
	zCZGdTwC0ahwCBkezecb2Q4vJFW1PT1teeDqzoRFRwAd3I9XasOn7nQNnRRBJlQuC4kGO2Ei0bd6O
	0sWlChNbHYSiVtAXkCcN5LMsw9sWnhBNXRaEcsQVGXi3+o1Qb+oPZ+AZHeiTSqI7UQ3oh/T9J96VY
	HxWneyPkoyeYCPWDWNUkV+5IatmZV6+3reL8rjpoIIcV5isbAd8MxmHPCYN6exczwum+SsfqSzavk
	ukhmiAjg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vRHaB-00000008iId-3UjH;
	Thu, 04 Dec 2025 22:13:51 +0000
Message-ID: <20273cd5-afbc-4208-aa2a-11ac04256c38@infradead.org>
Date: Thu, 4 Dec 2025 14:13:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v24 21/28] riscv: kernel command line option to opt out of
 user cfi
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
 Paul Walmsley <pjw@kernel.org>,
 Valentin Haudiquet <valentin.haudiquet@canonical.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
 <20251204-v5_user_cfi_series-v24-21-ada7a3ba14dc@rivosinc.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251204-v5_user_cfi_series-v24-21-ada7a3ba14dc@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E1BEA40011
X-Stat-Signature: q8yigkwh77z9uepzwq8q14143o4uy5uj
X-Rspam-User: 
X-HE-Tag: 1764886457-207439
X-HE-Meta: U2FsdGVkX1/iNao03ogKGZyb/1Qkhfzj4Gwf5+yWFrTC38xn/oMHWrtuMbBaIyXZUnP7XmTmlWrMcgq0ycRqVsjtM8VShgvT3FS9wjiVMgwALXvKwnfiJW/OQBhg5alj0mMjIvtMe9C541Fea6aLS8/h1r0nVs8x4Bz3kQAqglvoa4VUbcpAdJyF64c8ZGzv6nn9xQ+UrXoetICWR/j+HEyS8viV6Ow7aFXwiVdxVwfHFlPNzhM6FmePD/I0ddWqgaW1enmBXKZJDen9WPe6NCA2Rm2k1gYqnWeHWFX3ua9dRHjDxRBZKrn6A0NcT6ErEKGpUJbBZG6lTaFttdyUn063Ttwdx8LWwdKYSN4h4+9mE7bs6mNF+BrGFtD7XQoa1JFfw6FPkXE11bgmfvoRvdizEZTh4QpTq44uMUHe2tWkw1jVfIbizFGm6cpNy3TgjDGS8PT9CuJcnwjScO7ncjS8KHuCSXz3O46goWyZHuqwwyCyK1ybwlmku0cabDbNey3qgr2aorJerK/rBYz9xByBsMHTOA6oQ+pM4HzJZ/+E/xcveaSvlSPuEkAAzBA5dvJ7HrCTRl2HJ4B7ckjyZSG1fxaEAjuGeqV6FAMI+HpKuU7xDmvZPL87t9a4zTrJm9r5cnHvnog7bwxTpglXkXAoSNTVqbsHKYPgp7gXZJ6HXcUOTssCNPv8QN0BDFofECnxWSeT2BEO3MJmOJ9i9WTAOT5BHaVryXGw4kmH778pbcwAFls5C1TKZUS8vzigWRd79aY5ys5aUpZpzO8hqBZNUNov9zrjP/rpE5Vp4rjfFnt1Yjt3zuE1r9ytdzZD9uJEHG8SHtNdueIkSQlyYs8VaBdAP+FVcSi/8O6/RWm5Tv0QsVOio4123SdVzKjADUOc9UcVFDinN1PQ7feaZXv14EFvqmSRjkELAEPJ28ebiYJiiAn9teF7IqzomBzxczCZTH045Flp6y7kjon
 bsyrpgIr
 wMtB7/ouLs2sn5/y7hE8kWYKxQ9asWjE8YNxvjSbotVSpSjWlpVioi3F+7rxtSxsLugPeURXdjavTEqz2McmmasXHnomDhudMB6FH/dqJ7hAS9GWG6xAgqryWXEDmzmaLS/W1c1C3BTHaG89TX5iMePPIe+K4qenkDFyNX/7iO63f9t1H+iDRwj+OTfLsJJ5UHRw3sKcYaQluEX1Pon/3V6ZOx3NxX7DGUC5o+qu1LrT7qhzcQVasZDrwnwl8Rne8+b1k2+5KNQoBI/48mQC5/jJVvOQLhHwceGyfBvxFH+NCrmwXB5xjI0qxAnSwnVrAuMAKrybz3opeKh8uGlaThHf7PUrox9fex58MIKQ/Eemj/vfLvy81RWUaPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/4/25 12:04 PM, Deepak Gupta wrote:
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 6c42061ca20e..453127ef8746 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -6453,6 +6453,14 @@
>  			replacement properties are not found. See the Kconfig
>  			entry for RISCV_ISA_FALLBACK.
>  
> +	riscv_nousercfi=
> +		all	Disable user cfi ABI to userspace even if cpu extension

			                                              extensions

> +			are available.
> +		bcfi	Disable user backward cfi ABI to userspace even if
> +			shadow stack extension is available.
> +		fcfi	Disable user forward cfi ABI to userspace even if landing
> +			pad extension is available.
> +
>  	ro		[KNL] Mount root device read-only on boot
>  
>  	rodata=		[KNL,EARLY]

-- 
~Randy


