Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 468D5CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 16:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84BBC6B0005; Tue,  2 Jun 2026 12:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D53D6B0088; Tue,  2 Jun 2026 12:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6763E6B008C; Tue,  2 Jun 2026 12:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 533F56B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:20:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 188E01C0EEB
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:20:05 +0000 (UTC)
X-FDA: 84835484370.13.96761F1
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id 154402000B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:20:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="OXbQX1/g";
	spf=pass (imf31.hostedemail.com: domain of debug@rivosinc.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780417203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYFMKnZkfNnmRXGo0xQ4eN2VdP8xCoBWS52ZR4ARnJo=;
	b=XbpaGbmoKoc5tqq3lKS68Ohvnx4DIvhMSbfzW2fhfp4v8+ahlWKQcz7tL5/DNgmn0Df7cV
	MVyBtCzE6kBQ1VDcnw+AdTu8MhRGJrOiIMY1g09Pqiu1PXwKelotuuVv+z7aDiAPp4htGT
	lwnzAg3vFiQOyNdEqujx1JXH2jVf5m4=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="OXbQX1/g";
	spf=pass (imf31.hostedemail.com: domain of debug@rivosinc.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780417203;
	b=jZZfb9SZ7XH32BkFCViw5ybtLOZluBKYgLrGRIQm287lwBwdrgdlJX6SuuPoi+PukPSGcz
	c+YG2JEm40wyGdPzO2AQTTiwF9t4IQWBkAqOQMMZW+Hn4wAw4pw8g39laUBjHaaqNOpV/X
	Q1VVFNIVJ1j8bT5yJQzoDn6iyqpBCQg=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-660390a8999so6360147d50.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 09:20:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780417202; cv=none;
        d=google.com; s=arc-20240605;
        b=UXBQ2kl77zUCfMDWPM27+7+shOPEPpioUivcEgSY66lYD9FvE0UhKv8LVjuNglR0/z
         0rcPw1EThN9DYeJ3igMNvf9//qBY5/2Ax0CraPHYLz7kq/dcgQaVUa1v9vKbhMDY6PMS
         btS/uxbG1f74FX6OaHVDr9uaw1TQqscOFGJAQO6vHb29+GnIMlb6yTtnYPl0OmVtx9gc
         OranyLkVbBQfStWbb+JEY7ln/c+kWw0HkistPAmmcR4Kxu2K7YT354WIdZexU4VxITVE
         mGKcpIHOcsRr71+pfrvvDvGmphI+J1lIJQXqcXp49QqImDl7tBuZQk4faXimSE951wkT
         saKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qYFMKnZkfNnmRXGo0xQ4eN2VdP8xCoBWS52ZR4ARnJo=;
        fh=RZcHeeZqKS2PWptBDbt2qlzlBmgzNzOn2Niu2RQstpA=;
        b=jQAvGA6gghaAYZ7app45bAb7RlcbvBSWBlMMDruq4xWbp/GvihL2e02xOts5hoP+Uu
         5xePt+FH+7uqnFuO/7gz0GktAVmrEBnr+0IhJ2ZocNDF/jcp8y5QCm3cpfxFHT7vnUqa
         TSUSfpt87Y4UxI5l0jUVI8gQp63u/2KHtL+sONL4dj5VrWcqiAXrB8Z5plfk3Yarm0Ge
         2CZwP82ghCCoafNhpWLV68S4TrB8PR/jEoTsfmj9TM0JZKX1RTfxohN39O1r6hL4ED+W
         KCJ1qY47MG46mF27M2PucGah8C8XnV3lp3GcWPg8WJtk70Ekkrd1kCTQsCfX4490W5MY
         QV+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1780417202; x=1781022002; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYFMKnZkfNnmRXGo0xQ4eN2VdP8xCoBWS52ZR4ARnJo=;
        b=OXbQX1/gONQ4eJFNm39KI6/7++MQZRtrjkOx1polobPaeWvVWCLr85fU/UfiLD4HMX
         UIEQRTPI1oXtBmzCxR2kNeDG0vXfM0Pt68fnTawCMyv44+XDiznfz/XvwWdsMMqQct2k
         lNsBvstpPrFciLNZtuuJ8dfS9y1Evnf7VXw3iS37i6I6VvV6NRqFD45H+GLNaGmPqwTD
         XniUs7M8BYZrwd0/MQlmq6NGd+4eU8Fkgt9Tw1hh1/AmaOhhQHpfCkAxz4Zt5rJIuYek
         gRX+B7Dv6kkkYYBcZVxFJMud85IsR/9bJxPMZIxPOAcTuUKBCDbyl+iEjoXtg2kTGU/K
         4+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780417202; x=1781022002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qYFMKnZkfNnmRXGo0xQ4eN2VdP8xCoBWS52ZR4ARnJo=;
        b=PZw8JjgieGZF1LaCTGPHCQRLvKD0WNilxZXhrsaOKEgydtFuMnYebORFWe/UGJmOMK
         6mHDlBpJZ7cd3s4RGKMs4qnuTxFCVWzomSX5msOrtHEUAhrabdN5YMjEM7M+pWk5PFbY
         KxKRMAffXXEBbVwd6W7aXpZ/lwJEjtiiFuZIS27THHqFgt+4OaP/T4NuAsrw+HPsVVTx
         j7qK/4QwuX4biPwxhT+XXvFFnZnhQupehpj74dh77AolJ2pQO22k2g1PmIHs+oQCu4ZM
         nwrQKgeRKsju4esrKM6t5LOqGNALboL6oGcoauNBBr7o9coZaC+ZQCIAwLxXswmT1yym
         mbqA==
X-Forwarded-Encrypted: i=1; AFNElJ+XCWHelrsbM6NL9J0IVou0nZESRhUdNNrFwXpImD92pS19ALcIX6lTts5FkEF57hxhdvDnXlXvGA==@kvack.org
X-Gm-Message-State: AOJu0Yzocd9ZSsEoPb+3XO0pnbCK9NHSy+GDToWcltKu1AeGwLIshuX+
	R71t9Q27AiOsvFUq1S/ySIxqraPYqt+3LRTFXohSDtnJBSbasZ+l8cOppDO+xNV+olxwpzdm9Ao
	C6EEQKBkoL5qmhp/hbWwcMy0/Udpuirr38zVabhw5yw==
X-Gm-Gg: Acq92OGuo7k9V11YBfMiM+AdT/NET8FfhiNPMewvl+zBy8sQzY4cgFSY5fQB7KswSJ+
	ecplZivDYvtW9pDhBY6nmp6uqVQaB9dfirOdnIG5zQosnCpt3fsoCEOUt80f0EfBB9M9xnq42U+
	DW//0krDjD6LjoqreMF30fGbwgkJ974ewwEo9G3bbcGAcJ2HNVnZMYkWsqwvHWFryRrhPXVes7b
	/BRp6V+Xlka/e6GSTwDztb6Gu2m0L6s6J8dg3nFLOwCvn8JWBVmScFG8jRowhKp1AmV5HoM8XGC
	aK6Et9wzqHUqAs9QSsoREP889CfYDzMYmQ==
X-Received: by 2002:a05:690e:23c7:b0:660:367d:539c with SMTP id
 956f58d0204a3-660d61a5f90mr366583d50.65.1780417201973; Tue, 02 Jun 2026
 09:20:01 -0700 (PDT)
MIME-Version: 1.0
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
 <20251112-v5_user_cfi_series-v23-6-b55691eacf4f@rivosinc.com>
 <87jyslndo4.fsf@igel.home> <CAKC1njS=AHu6uHrH4ae8VxcdEbhgiPXYCAoN3F_mnppBd3SwOA@mail.gmail.com>
 <875x44o9hj.fsf@igel.home> <CAKC1njSn_rtCj8ii876PNQTk0nsCTfWsb4DzdymufHVthh1Rkg@mail.gmail.com>
 <871peqgp9v.fsf@igel.home> <CAKC1njR+dTdvp+BmLGPtgd8dufiUwBtkQ9a-qinELT_Fmi13sQ@mail.gmail.com>
 <87wlwif04z.fsf@igel.home> <87tsrli6lt.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87tsrli6lt.fsf@email.froward.int.ebiederm.org>
From: Deepak Gupta <debug@rivosinc.com>
Date: Tue, 2 Jun 2026 09:19:50 -0700
X-Gm-Features: AVHnY4LGzvAggFLA4mHNoi-t9ivcZhZK65HitG7Axu1HWjT50Q9msXqH7dSmtzU
Message-ID: <CAKC1njRapOxS6ibQdCuES1E3aAjsA+yGz4yZ1xJAZHU2vkAm_A@mail.gmail.com>
Subject: Re: [PATCH v23 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ | VM_WRITE
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>, 
	Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 154402000B
X-Stat-Signature: xys7hzg759ic5f7xjnwm1b3eamr9yufg
X-Rspam-User: 
X-HE-Tag: 1780417202-326714
X-HE-Meta: U2FsdGVkX1/pC0ShpUiJHTNn6a1tDFNJbDKTmXFutr7mjEo0T9vCekKwaMRV6K/Ut4OwxMMLTFdogCRbxE7XCPLURcBog/K6/G+HF8UMaTFr0lNfnksTjvzrV3amxoi5XFfGVeqk2/aOtZtzhVn0I14fQoZqsNirRWM07UHaa9H77Zd67lZROcuyG+XaU/JV3NglsHB4YBnSs+m0hwKRiVUaU1VIDE2+N/x1Q5mUNFpmILMkXDffKUM42G7oj+SR3NYpqWcmwNswxrBheQxBOkaMkSagxZhlvaD2JeRisUN2MY+wWKC2ZmA1topspBBmu5hY3aXQ30p0vcIRsfjGWYPxGEmZdKRKNKgucmne+5zuw4zzhS7fhQQMsQzdUOh1v4SwLtH2GtMwOlBsQ83KnZI6NvR5CwDU8OaqgYGstirOb1lT8pSi7N2G6oT15H2jODqjKJsfA8YwR78wiPVSzCB4azm82o3iVhqhh/Qf+8u1ary782yedvm2OSt4Fp8A5egtqEcIfwLaKwU/WW3seHCG6Ni3elCvACMySsWZLhLMRDooWjkXDoLTkWX5UamYW6BN6csmkt8JFPwyMZJEG96DIJAf0dAuxsVauRMR8aOnWaGsNxurFJTWK0LVvIo8+VZJPYMCqhtkoJU+8QiH02+rBidu/3x/+dl11GqSYHOjdDrAsYsDDlZlHM8UKDZ4Pit/uLoRVgooULl+uSIDYHv0wHfx8eRpTB9e6ztpW2hKk/v4kHX03AgjgiPSo0nge0oPfh2Uo9Ibm4W6HbnVyHeHKzg4vkWcNsNefcdzNMF7LXVr/pJbI4eBoULOqjRYhAQ5X63/uwK+z98UiNAEPHik8GlaF+zQknfFpo/OO/31fzsDMzwMovkYniTjuBYMYxR65k6pMcT12nwjR0IXoJlYD0v5jf16YWJ54ag4MxkpsS6HjSJYaQz5KAYIeDduiuf/DdBPkWM2beHmlzu
 /cAUVkiE
 2nCdrpKOE4DBm2deoFXejdbhmeHsmExtQ6wGoroNSUuEX6hXTBHQSM1xk2P4pVyJorW+cbhNRMa3rn2iVAD13sCiQ4vmT2x4fCCRlxRUTKJO2d8huupJIOp/kdVPf8vtd66fJ0E7MDu8FJ2zzH67NkIDp7NoEtZRaySmM4VU60UFcphr1X+NrP31SCBz8xWi/noP6qvWAShwvxFTRjd5XvOHBiRGpg1UVaTMvFxy1/15VYY+pYxzguK7ar6hDoRSgtk8X4jhXrKfjmNmykkGJd/B8fqhM/rOqTUc9P8Yn62bZJL0ebi0taWnJnI590JEkVCW4fi9g4UAxwnL2v9Ulh86+r3TQaCLd1tAWs80P9ZKFJ7Iiqg3ic6Kvuw/4riuBenmoKst+xPYvkd5Ly+0VePT9tlsbF53rEpU4F6F+qpG182Bxaf2WZF0YxpjyXGPvA8CP4pnimg2CPXcEI8Bu0PmH5Via6KFiVsher/3QTPp6mCXS80a/Qlt0R8hNFfa2Ma57x4eokv6Zv4XHgPRQdpO5ZpSoRbtKRsLk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 3:23=E2=80=AFAM Eric W. Biederman <ebiederm@xmission=
.com> wrote:
>
> Andreas Schwab <schwab@linux-m68k.org> writes:
>
> > On Jun 01 2026, Deepak Gupta wrote:
> >
> >> riscv uses `VM_SHADOW_STACK`. It's just very simple to use `protection=
_map`
> >> with just `VM_WRITE`. On RISC-V, `-W-` is a shadow stack mapping. It's=
 not same
> >> on x86 or arm64. So `protection_map[VM_WRITE]` simply picks shadow sta=
ck
> >> encoding. We just ensure that PROT_WRITE is converted to
> >> "VM_READ | VM_WRITE" at vma level.
> >
> > That does not explain _why_ you need to make that user visible change,
> > when others can get away without it.
>
> Especially since as I recall the decision was made was that the user
> visible protection bits would match the mmap call.  If there is some
> combination an architecture does not support that would simply not be
> reflected in hardware until some future version of the hardware gets
> around to supporting it.
>
> This is what happened with executable page permissions on x86 for
> example.  It used to be that it was not possible to deny execute
> permission on a readable page.  Later that proved sufficiently valuable
> that support for denying execute permission was added to the hardware.
>
> That all happened quite transparently to userspace, that wasn't trying
> to assuming PROT_READ implied PROT_EXEC.
>
> So I am at a complete loss why someone would choose to break userspace
> by confusing hardware limitations with what userspace asks for in mmap.

Initially my plan was to re-use (only) VM_WRITE as (alias to) VM_SHADOW_STA=
CK
on risc-v to match hardware Write-only PTE encoding and I didn't see
any opposition
to that initially. Until later when it was suggested to  use distinct
VM_SHADOW_STACK
encoding.
Although there wasn't any oppostion to this patch, seems like it made it in=
.

Now that I take a look at it, I think it can be made to work. Sorry about t=
hat.

Now that I have switched my affiliation to meta, I'll have to spend
some time to set
up risc-v dev environment.

I'll send a patch. Thanks.

>
> Eric
>

