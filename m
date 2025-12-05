Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CFAED3749B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 20:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F44A6B00A8; Fri,  5 Dec 2025 15:19:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A45C6B00A9; Fri,  5 Dec 2025 15:19:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693EF6B00AA; Fri,  5 Dec 2025 15:19:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55A336B00A8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:19:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 219DE1A02E5
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:19:11 +0000 (UTC)
X-FDA: 84186531702.20.3D3D403
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id 83E4514000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:19:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=bxqGkefi;
	spf=pass (imf23.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764965949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+k+j5zpiOXPUaOMclkmVjKztohgymIQPYnO7V/a+C/w=;
	b=iuAlYM8tkBF7IlWDmnuRMmjT6qFvEd50DeoF6OpSG2vA2JOH75KwGJSY5ArhAxbeTBxBTL
	ex3QNYWfwF+Swp6O0sTX8uWDXI2j7C+LXICRur366Co3wfaXffyCnsr9sPcxBYLSZSDBQ2
	G5sxVpq4MfUqYd3kZ/4sd5zEAgTcobE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=bxqGkefi;
	spf=pass (imf23.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764965949; a=rsa-sha256;
	cv=none;
	b=mQb9On6y9lI8CK18u6cFayqOp9C87nZm2PG70sIhuxyWTfaNaGtNnjzOKsbjIOsjSEezMv
	Bz7QfyKKQbx8+GVqHnfglPSOAvhV3zNrmihKsICdNjUTmXsAW2mngDMaSkvQXuMViLYYFM
	YZcFHPuVeGV3HCa9YozqH9mvZevTFBU=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E159140E0218;
	Fri,  5 Dec 2025 20:19:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id YMkoYSsiYCqw; Fri,  5 Dec 2025 20:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1764965939; bh=+k+j5zpiOXPUaOMclkmVjKztohgymIQPYnO7V/a+C/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bxqGkefiEe2JFBIhARr9tXH5BeezbVW/58uxKq/Tfdv1Y3tcJ64dJ1cdY5nzgOcDx
	 Me/EwWk+UXXs5J5ilfhEsv4wRvMy6BoVgrjCQn7zbTZT2qYHO7fKRxALp2n6Qt5htI
	 gTAQ7c8xibH7fPZ24PWS1/mprjgWrwEhVK5CwZ82QcZ5336mD6SqPK/onz+yTMAXLP
	 Uo4I7c8WqByXwRacksIdRkqnh8YO6p8CMsqM/PCHezHIYa9d4lP93ibGWI3ZNiVxAM
	 mPb8gsmuEss401Wbz/xAbQNSUOuwu1r41oOvGUaV5kZBIn4MHLDAY7CJYqZBL9W3ap
	 laFZ7I+Zcr/T9Q/3ukCSfpG9cZXEK5vOti5wbd4vPFVuUFGTZ5MyID5VShadi3zIRl
	 xGQjT6zxjvwEqh0co2EFJhK3Wd2fCAbzZ0qQWgj1uBN8lkhIN9EAp7ruVUbMpryNy7
	 Jki+8RlqBEddLzRCQhp0Rdzku+HsxukwOUwD/gyU69z3FlEw5ppsXfaJyz+G7RLJzh
	 93hDC8gTmjSc4rYF7NhWhumcNWaQKLgqxtOxNJQCwIdPBsVUgVBY9zZpFZ/dqOCZNB
	 Er3+sydfYNzFkSoqjM9orlD665WhWzJ3uGh+eWKn7Ik+dRECEpFAfI3O1YBJgdo385
	 7MzW5WnEhsH8ZS8oz2Pgz8H4=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id D6DE840E0173;
	Fri,  5 Dec 2025 20:17:54 +0000 (UTC)
Date: Fri, 5 Dec 2025 21:17:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: debug@rivosinc.com, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
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
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
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
	Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>,
	Andreas Korb <andreas.korb@aisec.fraunhofer.de>,
	Valentin Haudiquet <valentin.haudiquet@canonical.com>,
	Paul Walmsley <pjw@kernel.org>,
	Charles Mirabile <cmirabil@redhat.com>
Subject: Re: [PATCH v25 00/28] riscv control-flow integrity for usermode
Message-ID: <20251205201747.GAaTM963Zy4gr820KV@fat_crate.local>
References: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
 <d45808b5-44c3-42c6-a54c-3a13606ee39d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d45808b5-44c3-42c6-a54c-3a13606ee39d@kernel.org>
X-Stat-Signature: cp9sdizfx4mjnwjmf5teyga64y5q6s9n
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 83E4514000D
X-HE-Tag: 1764965948-676313
X-HE-Meta: U2FsdGVkX1+j+S9Mnx+DMbcM4QlYiUfbUTFN1fAcHMuo8Che2ZCvGClgsA6tiebtrqY9SpybMjfojc7xG3XWBpihLPgGF7VXEIa/UFBPkeVHjQWqJ+VvF+uYq/E7ZtnsMfF1Xvy6UYiBp8UNB9/juGFggidnwqgyV/cIMRxncabIMeu/4Jggzck4Vk2AHdtrt8sCPfqZkBHZqhes4MAt93UxS2cJitcGqZN+XkYxQbCEw5NBaM+v3Ua7fAUj/ybXlNaMI5CqTlTKy7sbu0BZtGr6m1SmflMNmEcP8AYFVYJQ5aWt8GUAcrtO1c60K/++z/c5G7Jq8AYyr6GTlYZOE4qcb36QlPVUPoC9MENuJRLUAUbP7z4gNdwSufLkO5QNPgd9Ux/p+42d52g8BOIHe2dQapznWIwnbG2MeR0/W3wEHAl1JH67poKNNDMS4+TQjy1btflcfZetAduDz7PpipcRHM2Uz0A9AAnhyhVC254i/82RAulgCs48NQSC9aYHxsx5VlxPKxTPYhI1EWhivMhur9Yl8tSPGpLVMlmNxf++wM36/wKVDIH/KZ5zvJVwDtCS43BQYJ28Bcklasu0k1l0YsTnYahx+bCT30dKbK2+wGSyXpp3mDbHRtBLZ4RKqUIY3xQCjq389DGiIU20++O9NL2pF2vdaGJ+VwZ8p/6+kkoktu7ZqCZNVN5ewGCzzjUyVTre4244QGoI2PFlBn0Okv/M4vYU4hf9PZAC38RZoUh3zW7sEf4FmcfsNNB/U93OJvMzk4RJDtYW1vlQ5ixKmsjQfLitssfQHZZ0ufNIRQcRnZbb8yyevjvrQcx8pLOoBA+FPXDTRaVHu1TeO65nw5S2OEL4zbb1hk/igDWH62J6iH5rnN+oYRY0i6LSs9yikO/Svlgv6xFyHDbnJQBsgFDcvQXRf7TZH4MLJcY/7+B6plS5wCXxdSvyDdxzUNI/JnToH2RlGotLeTq
 kDZ7D55c
 TLSbJ2YdNZzHxPP+jCPums9JNLX0GJ5YzOGkUsoNtcuW+SvvjtwVHfzJdBtkRnmvhpDVLC5T5MM4/f9t30UR+flV8HpIXyLEcFdKvW9NpzeWUHQEQhwYwzywQwEqyvavtomoeMYp2bRHQuP83/G417PStlRyoHnhqA1gBXwVRsugAGG3f1iQAjITCPm67CIvSsVk2L1JUlxHZMnanm+0zk/x109YWdx2IffSbO2E6R0v1xwdFrx9Kd4l7mz+nz41pf5VXgHAhgblU3fcy8EbqMfR5/6eUBzdwA5rr6tbT9II0Ewc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 08:32:32PM +0100, Krzysztof Kozlowski wrote:
> On 05/12/2025 19:41, Deepak Gupta via B4 Relay wrote:
> > v25: Removal of `riscv_nousercfi` from `cpufeature.c` and instead placing
> > it as extern in `usercfi.h` was leading to build error whene cfi config
> > is not selected. Placed `riscv_nousercfi` outside cfi config ifdef block
> > in `usercfi.h`
> 
> 
> Please stop. You sent this 28-patch-bomb TWICE to 50 or 60 addresses.
> It's actually merge window so it should wait in the first place, but for
> sure sending it multiple times does not help. Please observe the Linux
> development process.

You can just delete them. I don't know about you but riscv shadow stack is not
something I even pretend to know so it all goes to /dev/null

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

