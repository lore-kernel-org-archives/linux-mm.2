Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43EA0CCF9FE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 22:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234C38E009E; Fri, 31 Oct 2025 18:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C7D8E0068; Fri, 31 Oct 2025 18:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1483C8E009E; Fri, 31 Oct 2025 18:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03ABC8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 18:10:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8067A88CC7
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 22:10:36 +0000 (UTC)
X-FDA: 84059804472.20.2CA273D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id A40F5160008
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 22:10:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4LMjaStg;
	spf=none (imf08.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761948634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCA5EFSksST1h7GGV5nB7JZEARYhgQmdDRPr1+5iH94=;
	b=U/D+v5nfFWQmpePfd7ZG/0/nLFFp8DoXCB78R5CpBcIjqOR2Ioi0U1CgRFoOyceSvtAPzu
	SuRW9k1SAa19cRSwv0yxFgZKKF/bGZZwjO1F+lr/PFcvg6McUec4/3uKLTYubwDTem0ORU
	XarUNJrgPDlGuvLgHOtTq1UvgRW3tFo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4LMjaStg;
	spf=none (imf08.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761948634; a=rsa-sha256;
	cv=none;
	b=YWA+moOqkhBUAfXf1QpRNDHiN+D+2kOBbx7WZ+yUi44aH5Zwm1hx+cFuPMcB9dDL1mXTiP
	Mz3V09MsIqJqFnMZt/7zPvlyquRNG5SNslEAW33S04P4ifcVYUxjajX9r5qaN2oAJq6Dfl
	wAb1S7WskR9+/PnqMSLeiCPRy1yPDls=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=RCA5EFSksST1h7GGV5nB7JZEARYhgQmdDRPr1+5iH94=; b=4LMjaStgwdzYsA1UwJNJJ6/6UM
	hijNFvmA8DAWr0ggzHedHqV69LL+MWvx8ioToi7GH7JH2epZqmQATsQuVh6AyuqIVs0g2V1TY2xTA
	0ef36pafwaYg4cWlw/y7og3ET9ZAenKPOTW9k88+zAkGN840SGV/OoexbROT3/y8kMSXrvvx67+67
	Y0HcE9fwUx4PpigC/zFSJyYkpcHJcwcKNWtUtqaEQ46OTJ7n274hbQa/7VNfii/rQRTpMVSbEKBSX
	vqBnk59X8AUujSJTxSfiETwwWcneFferjCEOHnFenDbpHRm3v2MEk8+fZHKKyyw/Lql05DVLWpTze
	EtUDailQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vExJr-00000006qiy-0FlZ;
	Fri, 31 Oct 2025 22:10:03 +0000
Message-ID: <d442965b-8716-4f89-be88-bc62459af712@infradead.org>
Date: Fri, 31 Oct 2025 15:10:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 17/28] riscv/signal: save and restore of shadow stack
 for signal
To: Paul Walmsley <pjw@kernel.org>, Deepak Gupta <debug@rivosinc.com>,
 Andy Chiu <andybnac@gmail.com>
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
 kito.cheng@sifive.com, charlie@rivosinc.com, atishp@rivosinc.com,
 evan@rivosinc.com, cleger@rivosinc.com, alexghiti@rivosinc.com,
 samitolvanen@google.com, broonie@kernel.org, rick.p.edgecombe@intel.com,
 rust-for-linux@vger.kernel.org
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
 <20251023-v5_user_cfi_series-v22-17-1935270f7636@rivosinc.com>
 <a8f469b8-5750-dfec-2390-09bad4515f99@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <a8f469b8-5750-dfec-2390-09bad4515f99@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kqwhn9j4k7xxc96opdt99u4x47px8a78
X-Rspamd-Queue-Id: A40F5160008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761948633-987965
X-HE-Meta: U2FsdGVkX19bblH0/Kol5fxgFMAFCi1HiaPRxeAqPgppcLYFnRcS01JD03jWIYllKTdi6oHKrDzvzwQG9zgfESn3YGkuvF66tNt9H3qJ1hpFzgQ1zLI0FUbPLmC/aohnBIdy9ZAEseKUhfDIta7wzNuSsmGIQ5Tt0rY7t3WoEYYyCjdt6IGdwZe2GM7WRheQfD/XV6pGR9N1CFot30BFyRmpgfd1IL3q8TZlFTxTZ51O3LeILC8h7h6djcTCzYiWPeVoYwuD6v07jJkaVOniPobu0WEBWivp24RBwnGkYyU6xH/sXZdgDCPftDtpEOsF9PBioKGCD8Kp/35OH+kprHr83sjR7ZZJWy2ajCNscjMm+PZ5DKBCRGjER2tmTltWnmGAM0tAc12H6cLm3TeOhjHZZFiqNtY0yPYUKRZvB9blABYiMW8sOWt9KWQu9wkyUoOjsc+scL0Eq4owLgq9NP3L/zAjmrFQTuIbgzPrzgyUzCX+ttO1kZ7O5+eQnGtlXtJhtQCAwTrETIoL5fHfUHgQiiKah6bqEv65N7Rw34tZz+vd0L5n99VOXRMERjQHns94ijrjMFegLxkv36L7/lJaTgvJ8CKPQro67qBbAtoCE7xWBRkCsCIW0NaWXnag6PIJiT7DP423QeF6/0+Xapb7ImSSoYjRgkBMDAKlDTg7PRy5YNqtGsuvz5WHx17mPwWGHwPhE+Zyk0O8OUGi2ZzF9GrtZ8LFRZETyu7y74vq0pa/yZH4gNsxtF07PeMIgIMVaZFDSKB7YbCCiUbJYknXrkApUEp0SNGoXGp6iYHvP7BlwLmLMyYQ7tWeJxGvTU6qHeJEsScZoNN1Aix6XpjVKvnm4gJymcNjQIL3DBqgX80a78IgnsMLNPYVPYzvKcFGK6+97XwW8/lNmlphTePo4ht44QPRHQkSpctkr1voFFpE8A14gv7H6kE+S5D/Tw3l8cUa6S4E0ikt4Z3
 zR6/V2x3
 ssm8ycD2pr5YsZ77Nf8Q5I7naeAmr0ir2/5xrq9LF0A/iddXPuLrEUmnKloVZsYVpHHhZ0QuzG17PNZ4nFstqVjORgXv3X22si8HKyas3XTW6ooFzS3FOII4sg+VqN84OsoCZ4L7RAPMkcC8gMwymKxZz7l1eyxy98Hl6dvPwA4K7OwuJlFZm154/zDv6R0CZmmP5PS6eGO4kjoZrfaTyjZ+sMbX8QPDx9RQvZt95VAmEDk+HnhxIb28qVpk3qCFsdKamifs70+xThdOJEHdSSvTGuq7rK18HoAlgGrHkc2q/5k2P1O7s/9dJ25URY38P7t/IEo/1n1ByYL32NAzn8plYG2Wahy5VJaFwoqnetLzS0c4HqGBLqV3iId2QGfzNgnfyAB/WjF96zonjwg2W+04v2efreffhB9xhyf79ghR9k98=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/31/25 1:07 PM, Paul Walmsley wrote:
> On Thu, 23 Oct 2025, Deepak Gupta via B4 Relay wrote:
> 
>> From: Deepak Gupta <debug@rivosinc.com>
>>
>> Save shadow stack pointer in sigcontext structure while delivering signal.
>> Restore shadow stack pointer from sigcontext on sigreturn.
>>

> 
> This patch causes some 'checkpatch.pl --strict' messages:
> 
> CHECK: Comparison to NULL could be written "!saved_shstk_ptr"
> #271: FILE: arch/riscv/kernel/usercfi.c:186:
> +	if (saved_shstk_ptr == NULL)
> 
> CHECK: Lines should not end with a '('
> #300: FILE: arch/riscv/kernel/usercfi.c:215:
> +		pr_info_ratelimited(
> 
> I've fixed them up here in the event that v22 goes in, but please do the 
> same on your side in case a new version is needed.

Hi Paul,

Is checkpatch.pl --strict the norm for arch/riscv/ ?

If there are enough arch/riscv/-specific patch expectations,
maybe they could be documented in Documentation/process/maintainer-riscv.rst
(a new file).

Thanks.
-- 
~Randy


