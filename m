Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D70BCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AAE26B0495; Mon,  1 Jun 2026 13:57:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BB06B0497; Mon,  1 Jun 2026 13:57:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A8F6B0498; Mon,  1 Jun 2026 13:57:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 627F86B0495
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:57:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 208F8C24B0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:57:55 +0000 (UTC)
X-FDA: 84832102110.09.8061B7C
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id 24C7B80002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:57:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=LYdnqIP1;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780336673;
	b=NDaQQeWEwAIXTMIaEDL/T+ZJAJqgVBvjmFsHhHp3N2H/R4t2NQusZeTre0kl972Fh7VQPS
	JQQNcOVXm91OuOoWKeYQrLXO2EupY8jBK+CyfR5Y/o3EAyaPq/VQ62YSNMLx9T711EgsaN
	gOT/XgJ24b1tlGYvO8R1ZEPDzALgIKE=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=LYdnqIP1;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780336673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfE0OEt10KoqyrBxkVX83evIZS2y+17Dt49yMyisaOQ=;
	b=8JbfDOEMfc2fwtFONQORaIUa2NibzLsFuiXJy27wXTbp1l5sS1HiaQjAOjxRvTSF79Yzw8
	ipxHngvqJwApTL8VF88YTH0S0NVnEQ65OOzIrCcmsUe3aQgFLPEzhDBAFrp6E+HlsT54sz
	Iz29q3NB0oq7DBbhc6hu+2ubiZHVris=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7dc93d02916so43637487b3.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 10:57:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780336672; cv=none;
        d=google.com; s=arc-20240605;
        b=EVa37EOWCMfYGkTBh5G13LZzNtWr2Dmn+nZ+LjeuIPOjO0h+qFgqwBPZuGkTjv8yrN
         9+yOxm73Qdhujw6bWI/YmmNKPot3uNwIMdlHK0WJfE2KGp8+IsOxemT4PauJIiY2XWgj
         9BPj5nHUO8NZjuor3z4X1EyiLHIYNI9NcUBZ7Zz/hdq6fnNBN3Z3tazXBv1+HtrAkCJp
         xT77E5NddFw8DD8sYtuSoaPAEmMf9sknV5VK2iUQRVGHH/YA2jez3vwx1NXdLSeBpIw4
         luSzk95gwFF8DAch720tHLGOXosY4OSNeQPVV/Y/z4eKz75n+cvuQz3BWfZ0vQU/NyIb
         B9BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FfE0OEt10KoqyrBxkVX83evIZS2y+17Dt49yMyisaOQ=;
        fh=6KEstU5OogO0MtCpLF71z5FAr5lMMKvm9QizlinFrII=;
        b=ln+23z68IjGhuIX6OHo3b9UXYs1zHwwFkZnmjTbMmR2Kbjr/uYQj9KRfrPd6guVChI
         ATBLHOk3DOGyYXrez2Y7rs2MwWse5Xvir6DKr5UKwOckFSRVBTYWFp2vySLQ0gcLkr/E
         vy4oLqd9NQjTjfdjZqcFor967LseqPLzimeJG9uZ2Yk67C/wxNf/IeC8F9J4lMTEOFv5
         7mDfO65NSjdrtrP0jlCLWvOcDjz5n/bF8b4qzNLoktQBkj7lxv+OqVV+TBANPbTKwU1Z
         ToIahtH+vHXUuSk/gwwlfTb/XoyVSCzqEv1C8T8WTD+2dtcVtpfpixwxwHv4RFld7Kwy
         D12A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1780336672; x=1780941472; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfE0OEt10KoqyrBxkVX83evIZS2y+17Dt49yMyisaOQ=;
        b=LYdnqIP1aiBHVSb+YXlPUQhRwOMol7EHVHHZSEsnaz9kE5B7gxuJV1UZ6EfGZ7XQQp
         1tthjpITs6sklmIdk5k3c8h6JBwbXuAGwvlPfcW538IZs7IZTb+WWGzEfB92piuiSbqS
         CEP/nvadV2VBNFvZUodACLBOEN3oTHioevD0bPHmC+TdUmUwdztX99c84L1wqw91KCBa
         L6CsgVTpKEdcQhGAkcVOJpqQF/uiPyvfa883HegixdhNcO8vTzCplvSTiEMMcrA0zHGN
         0+Tfcd7J4oJUDkwCJyzljyw5eLsaf6upWbfo4YzOSxdGbHfYwXQt+WsX7uO9IDEvhCfN
         UMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780336672; x=1780941472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FfE0OEt10KoqyrBxkVX83evIZS2y+17Dt49yMyisaOQ=;
        b=NzPbpyBfU0Oa1i5fhm0k7OyiC5s3LWiE1o7QsR6gKXtO9WYYT+nqzwjvcas/TfmW50
         3Olztg0aqXq3IyywOZ61iaBmNlypyr/m+8YQBn9gCaX2mqHXX0hM8y3A8AINCwpOi8Sr
         qEGDtiUIzCpzuoIg653oChnr3MyuTIPKLjmxdEk12Jc6KvK/R/VHw4QCF2OVl1ROEH4o
         8RamP+yv+FYpJEZ/wJPCsAPp4Q8w1TIJZpaO7c105xtorDTFYAPGQ9Yo0Rz6zDRa2tzL
         kB90G+meVhe+aO9NTnibHLNenKfJv6e3LXm7F3M/16qgq7qepo9WjOIfGNFqhv44y8gs
         02/w==
X-Forwarded-Encrypted: i=1; AFNElJ/Dh31M6QDA2KAnnNRj0X1l/st9UJPBwVd7pl6ZzcWU+s3qoipnNMjCF4kF0aucWJNqQfkTQIYGHg==@kvack.org
X-Gm-Message-State: AOJu0YwhV/ytoqqXNSWFA3G/HFBrqONcLD/SlAGLk0rY0o3weNM6LkND
	Kr2+ixw90bXBNjCSkMAfZNItnyQpJDnyTvTHCSCq+vOvT3f9TZXh27w8bXJQjmprCkMoo9qy6wp
	ECdb3JOwJhamVZfWNtgoRm3+EabTfYPGPM0PakhLGpg==
X-Gm-Gg: Acq92OEICj90sVGPVI891no0ESJXb5m5bAszofKDB7pKxwMqJ9QwXz4ibjPpFBV94UV
	S48iEoKkVPmWdJan5dtluTHWpsl91mIgiPaPKtx+3pL9buG9Kh36nHsx1pwDIQdMR9mWf87V+xU
	I9hA9tq6b/oCRKefL1qKFVhBXFzcDOT+xPJTgWsOYYeEJJRIz/2ny4aDiUhPg4DBGrfTQeuluMO
	3zy5ZUaLo4QcBjD9s86TMkZn/NIH+XXvydi30evz+5RbGFDY7tAc1UQywWCoJhh6dOuWBxr1XE4
	rluGJs5HArnhT1/U5I8roePN430xx6OQ+Qx6lnV/8uQCN8xEdoU=
X-Received: by 2002:a05:690c:30a:b0:7be:5f3e:5309 with SMTP id
 00721157ae682-7e05e853e5amr107636127b3.38.1780336672104; Mon, 01 Jun 2026
 10:57:52 -0700 (PDT)
MIME-Version: 1.0
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
 <20251112-v5_user_cfi_series-v23-6-b55691eacf4f@rivosinc.com>
 <87jyslndo4.fsf@igel.home> <CAKC1njS=AHu6uHrH4ae8VxcdEbhgiPXYCAoN3F_mnppBd3SwOA@mail.gmail.com>
 <875x44o9hj.fsf@igel.home> <CAKC1njSn_rtCj8ii876PNQTk0nsCTfWsb4DzdymufHVthh1Rkg@mail.gmail.com>
 <871peqgp9v.fsf@igel.home>
In-Reply-To: <871peqgp9v.fsf@igel.home>
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 1 Jun 2026 10:57:41 -0700
X-Gm-Features: AVHnY4J9AUNhuz056EYoPs-ULzO8_fe_9tgwbVh_N3bHNsdR65FJv6ifxqCKuXk
Message-ID: <CAKC1njR+dTdvp+BmLGPtgd8dufiUwBtkQ9a-qinELT_Fmi13sQ@mail.gmail.com>
Subject: Re: [PATCH v23 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ | VM_WRITE
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Jann Horn <jannh@google.com>, 
	Conor Dooley <conor+dt@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com, 
	richard.henderson@linaro.org, jim.shu@sifive.com, andybnac@gmail.com, 
	kito.cheng@sifive.com, charlie@rivosinc.com, atishp@rivosinc.com, 
	evan@rivosinc.com, cleger@rivosinc.com, alexghiti@rivosinc.com, 
	samitolvanen@google.com, broonie@kernel.org, rick.p.edgecombe@intel.com, 
	rust-for-linux@vger.kernel.org, Zong Li <zong.li@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 24C7B80002
X-Rspam-User: 
X-Stat-Signature: bgiyn33ebrmiwa1osotz6onqi3pzgyzw
X-HE-Tag: 1780336672-375577
X-HE-Meta: U2FsdGVkX1+1rIKYKU+D5saHlYQAnqB0YXVc7SlePAghQ2aKXYgYHXDim0VZHNvL+KSV2MCycKK2HUbW5U0oMzBIOMLozgPVfoW9xdkkgYnu6/UbevverI54MJfkvXjm/ylTIwH1PqWDy1MvQzqB1gIfEeFuOGLo0yFQIfCmJG1zIyXEgF11JNP1URb+iYvAgeYFrfLBVthXeObWNRBMqiJQDyVzTLk0Dc5KxIMfFmskrPrH+sjaT/11AOq/wuoLz0BAqIKO33evq6lbDQvcP6o/UMPwtTpabFTKeAE/PvrV7fppT2D52HpeXlrcXYOLysFsgm8A1fHWnqyzM1n1+FpCWHD35Ke7yIYFMXX3ojKO/xHmAcwfL8B1z0EBEdqycSr0n11h7f4UcuLMj0Y72F9fwxbyaILlfEnfbaB8ww8+hLc/oXHHx5lhPEr5P3EozHWuq2t6wyV0LUJWLDag/rtW3qOQ8Wb0TmN8VH1xtJF2ftk1scqaWeP9gV/P+AnsW6TKLuJ9eC57+yltD9ofZDfPHhZDnVsKP/VaDtKANWvglVQMeiqRBYOfonha3gGTxbFAOMHIW6QAu74ZzSw74nMXIWp7TENX9L+e8n4QVq4hJPOgYMqCz0EUdjBL+aBjnurZ7/b8MNKKQq2qnMA8JD6FF9UqlEQs2DHF1EtMTrCGb3t6pcObEVHkNrUb46ReK2NxVfkXdcQviiuNV1xxs7j1uvSwopWgJB6t8rashw87QYq0Yha3u+3CVrMDgVt/+v7QDr1/OtZCBkSeifu6N+PM6bNFtliyjWoN2iWGLWFnVarlvr1UQharDruVg4JJS9nCjdk6EPUPZvmmjULvevjKSYBSuwyS2ESc8YZmAC/lDmp2fk6BO2IKWHvW8g7dTYUW6dF2zTG+3TvLQatOtGPts5PbywAu9jSLYN6Ngd8pMh/h9ErHRtSyDC5cF3p0Gu1Km68mLa9JeoqSLsR
 NPG7UwxL
 baiLpmV40uiO1BWKDi7VmbtTA+cOVdF8kVWhCzn+tbAotuIPtoHl88hWRS12mawM3CVZGDKkygJvD+f9WDZjYC/WfQkIS+zr2iTliYqw5eT/InME7lSGBsQJ+SYw36PalraEO5goDaRfp8VOifTmS2BkEutqcsNRnVSsEamcK2ese1SCC57ypDi63/kSoGs4pbeXdf/2sLgOCoYMKJ2a3ybEhuQ+3Syzb5lfhtpSW+shzRhyArcI+42XcO1Z4nkLVxJ3HcE3Kw26leFK2z/n/e94ympL+g31R1UftFEc8lehnjwwUX3pEwRt8r4piXa4tzAq6kAxc39bnRB8HUQeBBuiP88QYDyj7MmymI+Py8N3vUvDB1fw/vL0UNOhnidkkSZ6QUK1MZivmvDJpqAaHH/IQsSB8/0t1giuM3cMxy5MtJuAOIJfWJVIpgRK/Qr+7mnzBE2TGExX7EGhLTwCNWBxTTbxvmfdKX6AY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 10:10=E2=80=AFAM Andreas Schwab <schwab@linux-m68k.o=
rg> wrote:
>
> On Jun 01 2026, Deepak Gupta wrote:
>
> > This was settled when x86 introduced shadow stack. Instead of having
> > new `PROT_`, it was agreed to create a new syscall for mapping shadow
> > stack memory (syscall: `map_shadow_stack`). Scenarios like `clone3` or
> > co-routines required manufacturing a shadow stack, thus necessitating a
> > new mechanism to create shadow stack style memory in demand. Instead
> > of having a new PROT_ flag,  a new syscall was created.
>
> So what prevents riscv from making use of VM_SHADOW_STACK similar as
> x86, without the user visible effects?

riscv uses `VM_SHADOW_STACK`. It's just very simple to use `protection_map`
with just `VM_WRITE`. On RISC-V, `-W-` is a shadow stack mapping. It's not =
same
on x86 or arm64. So `protection_map[VM_WRITE]` simply picks shadow stack
encoding. We just ensure that PROT_WRITE is converted to
"VM_READ | VM_WRITE" at vma level.

see commit message

"""
Earlier `protection_map[VM_WRITE]` used to pick read-write PTE encodings.
Now `protection_map[VM_WRITE]` will always pick PAGE_SHADOWSTACK PTE
encodings for shadow stack. Above changes ensure that existing apps
continue to work because underneath kernel will be picking
`protection_map[VM_WRITE|VM_READ]` PTE encodings.
"""

As I said other arches have a VMA flag for shadow stack range but PTE encod=
ings
and overlays are complicated.

>
> --
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint =3D 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC=
1
> "And now for something completely different."

