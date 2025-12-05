Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7AB2D3748A
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21F46B02B8; Fri,  5 Dec 2025 14:32:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9AE6B02B9; Fri,  5 Dec 2025 14:32:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F126B02BA; Fri,  5 Dec 2025 14:32:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9FFF56B02B8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:32:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 263131402DF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:32:54 +0000 (UTC)
X-FDA: 84186415068.24.B477FC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4FB7140016
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:32:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gk0SMWPx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963172; a=rsa-sha256;
	cv=none;
	b=xds1vGAobxne4e7TpFj7ely6btvZsYd/UKFRbvBxqY2ULVIY+4InLY4yM+Xjesf2oac101
	IuSKI9hJCpQ8rywvuxOtCkoXBcfY9eDGFnsMHxdehxvaOKtttVNFt6LDdf0B9KB8V8DNoc
	+jpGdd02Hj7+YLcClDv+tAE6QADw2Lg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gk0SMWPx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WuHACCrLw7Ij9mjNNDsCgnUG5pnSjF69HKLgKQcvB4=;
	b=4mWYZp5SJE4QEaz60Kh8QBEdBU1o+RbIkmV5b67CHS3m/Ykwx0EPoqCUVJGIKKWwm/4cQk
	pVezhlpO/80JG+pxq3gbzFynY4YwJcuXFuV3jCCeV6qKgKU08eODxNWzAA6Bs+jT3ATPG+
	pP4EMVwWTEjiaG3pbw/BdE932KWn+o4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0180560053;
	Fri,  5 Dec 2025 19:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45914C4CEF1;
	Fri,  5 Dec 2025 19:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963170;
	bh=7WuHACCrLw7Ij9mjNNDsCgnUG5pnSjF69HKLgKQcvB4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gk0SMWPxxBv2FrPBRU84wE7AZD0o4+fLvrhaoJgHozSBhDl3a7ZZAvU9uVo2ll6Zg
	 I+v/7ZSqOmAzBlyIpRiLTsjvztfKvUeaC4UWnvrKk9IWjfJc40MsZj9+LQHQebDWPF
	 sSpRgnXIC0/UBkff5oHzznigldGYOqThG1E7o1oa9jeIH+AtZHK7htHr9jwyY92VpR
	 tSaUoLTf7BLZiffzZHG4Cjxbinl7e4hk50lIpx+Amp3yCc4BA1mmqkZ+pNvt8sDyUl
	 WIgsEtRnWYHOk4PhkXXn70A0c48E67OX4QVUByXh9m3dI1GeQUfYISbM3ZlcjTT3Hb
	 z2JmYnkslxiZw==
Message-ID: <d45808b5-44c3-42c6-a54c-3a13606ee39d@kernel.org>
Date: Fri, 5 Dec 2025 20:32:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v25 00/28] riscv control-flow integrity for usermode
To: debug@rivosinc.com, Thomas Gleixner <tglx@linutronix.de>,
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
 Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>,
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>,
 Valentin Haudiquet <valentin.haudiquet@canonical.com>,
 Paul Walmsley <pjw@kernel.org>, Charles Mirabile <cmirabil@redhat.com>
References: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4FB7140016
X-Stat-Signature: 47ju1r9nqjj6eoetmt1pfxu89hj5jpa5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1764963172-643923
X-HE-Meta: U2FsdGVkX1+coW/3siuc4y0Txsx6DUmGEIaKP/ZIMKDAqc/Dq3cJ1rNetg+Xlrg5++T2aCDYyLhaki3SjiXGlZe42KlvrmtIQ+mfBNLotq8VvEtdPWg0VKaG+ba0mhU55bYw/bvZlzZMV//V5Npe7XHBPtiBgayO/CZ/CWFuo9KX0trVctOi4HAZsznonLmYwbYNpLExsbDKir6e1eVsxmu0/ZPlPQIbMBBQ2Uy3gwHOgEpKMBqI6h/meESb2/CErpADUDOUNCHB7CxPhG4KaD/230xtkm7IaUNdc1rhtsDsp/MBVmbGV1Nnyz/W4JLUigwJ8TcRoelOFmG20noTBufIFvd0JxFzGQFS8AZXI7r9DCxyhidIzcz8oJiioFrses9Fe7EksTU2tu+DEHFhdgcbISbNEff0PfqDg8jazg/vtvHzp+h4byA9K0ClKx/ILsVxn6K/8tNsK+/PIFTmh76Vk5ZsA6KcI6WZNbKQE2ddHZAK7pWbmn1OGzYupIK2xp1wpWEK7+UmVQdXf816oPdSPu3MwMRFvmdXMlLqJ/97mdRARePm1IbHfF+htM3/C5kxMQlri0X2XKwg1pOqDC+4oKOofWsbzXsgMjos6lJcsdVQAp2Iocxnbv2Sq3bPMKpeg5VPcATPgANhDD465tT5GLtr2pxt0KhQWs93onqoIYLql9cDp++VLYSoBenNAPvFanGEFWCaqQWT2gDpyKgH9tjEl5kOxk1hHoPkeQZ3px6ahguXCGnndSXi+WfucWauOU8SbLBdrTT2kU52xpkszoBZBWJpeRM0On8p6W/57CG4Gw6Kii6cEE4wsDqIvMqZCJwUOD1LKwUXcVhxYs+2g8eb6b5lVv4pFe9tAsHUd8/SG+7/67sTT0KhPYXgOFNRUnyo7acaA2AxvMk8bHIfhZjLWg3qFJjEeiIvGpRlXBfgJZcyyUMIRO8vEnk80IzdbmW3s8cIB+NuWX5
 paQfjEZA
 16vUQwKlJgh4K57JxLTOKp+YyhdCREaztGkIscgq1CLVf9nlxhyhUxO5cAl/PfN7cx8k16XDmqyNWhHnBrXMbzxN+3lWyvtSizNxg5PrRP7T+yC6l01oN9V1Difp4pIB4nPKfhA6hWPpty9awKNKwsielvFrzAQbTveMY2FJ2zj8GQyBXqYrej2SpeyRI6DJpwSbwyEdlIHYlS30q3ggU3JXme+PGVUuU8aB+GkH/SrVFl7FxoFygrFXfRvbBIv9HcA3Z7c8T26gX4aJw4bTFcXnzMtn6qEkN1B3wj+VG6ZWXjLH7VI/hpJSSw/0LEywwBuW6873NtEhz2hE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/12/2025 19:41, Deepak Gupta via B4 Relay wrote:
> v25: Removal of `riscv_nousercfi` from `cpufeature.c` and instead placing
> it as extern in `usercfi.h` was leading to build error whene cfi config
> is not selected. Placed `riscv_nousercfi` outside cfi config ifdef block
> in `usercfi.h`


Please stop. You sent this 28-patch-bomb TWICE to 50 or 60 addresses.
It's actually merge window so it should wait in the first place, but for
sure sending it multiple times does not help. Please observe the Linux
development process.

Best regards,
Krzysztof

