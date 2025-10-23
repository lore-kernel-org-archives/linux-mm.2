Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 114B6CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 00:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11D428E000B; Wed, 22 Oct 2025 20:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6FB8E0002; Wed, 22 Oct 2025 20:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0C58E000B; Wed, 22 Oct 2025 20:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1FCC8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:33:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36998BC5F4
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 00:33:09 +0000 (UTC)
X-FDA: 84027504498.08.F748656
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1233E180002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 00:33:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=S50Shk2i;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761179587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XeVe0qeP3aykBo/7dGgSohrcuVMEfUeQJzWcyYhDEdo=;
	b=ngFzyonWW4/QqFbtmZm2lcgUqzkBXiHrJXyw73vTaoXGePB8/Oh9r5710qHzpg8niPKuPd
	Gs7pHXd8g4EINWQ8n2DzymfNqNERxeQv+J7M85EQ68HEw7KeX2rt/ASrue2vATDwdSKerT
	cuOulGqu9lgcWRLG5yYPqTS+DnFxe9A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=S50Shk2i;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761179587; a=rsa-sha256;
	cv=none;
	b=tJ/ZriQmlFrqnh3u00/pQ+cApo2QzCew24MDu0P2SzSgArVAfgbxoQHwKYxUOV1tPDA+Qr
	ffmhnW0pYN5/WtQnWI4bMRA9WEnOvRW0e1qXkoBW05h1yiI00tmwuLO2s4s0OXITKHFplX
	LKN/ok5fxeu/drOJqIs5nRqZ6m8ShQw=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-33082c95fd0so227450a91.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761179586; x=1761784386; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XeVe0qeP3aykBo/7dGgSohrcuVMEfUeQJzWcyYhDEdo=;
        b=S50Shk2iNHpk4v8IZ2qhNZjcKXqjekYxMHPKF61/63YT8NYFoqxDVdO6CvVHpZgdrD
         lBSdLGlIn0twkW4oi7GOC8PDlDguCJylsPJHnXfi7RZqehJkldmNqpLe9xQ47Wj/iLbY
         z02TBppZ12zJoOzUIuWggJ2UDujugW19FQPO4HnUedeYkdrPGaE7FY1dXSM7iQO8eiYF
         wPxd6bie6Jxw1TizHFMHmPrrYJ9q+UAISViigCIuQ3f422V+j6f7IAeeqUnjFSmM7p+t
         pijarabRNUJi8ycYopOo3UMICanHSv1WLxAU7d4exu1ECrRKdCVOs+rF6AzbETMmNCyp
         /D9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761179586; x=1761784386;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XeVe0qeP3aykBo/7dGgSohrcuVMEfUeQJzWcyYhDEdo=;
        b=FKW96TVMFaEdlrKx2jsiPHxpkrR0J8As+7SuzdJCzPyG0um2aJKPvINWqkyOo7GFLo
         i8XB7mhFCIPffbZGn+i6UY4iviQA75uamBt8igCgGlgZz2MDvwhFN2ry7zbQL5QXy6jq
         hxT+oXuzckP5MV8PzxM9bgNTuPoE9zUt5ijQFdnfdD3WNrHJZbbZj8RTUkEZiyS25e28
         FK1KwEp+OGtk4b/VIr9u6ZvpDmNPlJqiIh8oGXr9Uu+WKZFgPGdz33cJVoZjyeClRR2U
         UllhnIX/yE2tDoifpWpNiu3hz4j0WoAjOt8JfvWq7R+r9NAtV6DhYxMmHngDrm+Vt3tf
         Gc+g==
X-Forwarded-Encrypted: i=1; AJvYcCXPBvRqh1A6Po/06JEYaF7gPNrgMgs/6PQgEIQafc8IbrqhmqeV7RM5tVpmg5K2TSi8GI4YLdurUQ==@kvack.org
X-Gm-Message-State: AOJu0YyOFIengqUKwJk2pIbMslHez6jAntF/U0UwxKZrDbvE7fbzA+Ph
	+ZyV27CXXA53IFmXnLyTgOedqXufXAWTC43KGlt3lLtnipo1573LMj9plNPGNzp70tE=
X-Gm-Gg: ASbGncs4klyFvvWoPtLJ8qrlT43bYxX7s86CctWlqW82tODoh2SVPcXCg3UfriJlc6A
	0Bb+pcX7qVw5FUD8qhU1c1XRbV/G8IqAAH/joVlSKolmntiTVNdQAd8fZcMhm4U38x+0149EBJE
	VpgE7XYWOWa7BNnEMPLkYH06+Gv80hwz4MGuhaejdaIMr1HBzCScxqA7BTkwJWamaG1bERE5NJs
	SAFojMzLD7JnVOQc4t9i4fyqDDlvluX6hyd45n8sQdXAE0JQpJcFbU7FofQaIlYvu99QUjzNkNW
	3h4zaAhEzgz+Taqjz2bgQcuqmbAP34Ht0Wg8dNwBXBhzKqU76bQAH8R/3Ri+ALbrC3CFPimPTRd
	q2kM8uK4NhLKAoGv3Scrp7otFg65NfkhVEo4fex/j6Rhd3wCtDb4MzuOWacymkCy73kbfEuA2RK
	ftK/l3upMfZCBhD00BIuFSuICluYpsHhc=
X-Google-Smtp-Source: AGHT+IFCLFFINMwPU+x3Cp6dg7strhrZhSrNvz0Tb3A5ltL8zufMIOvoTnP7HZ2gG4lxkFtL/Wd6Ew==
X-Received: by 2002:a17:903:11ce:b0:273:3f62:6eca with SMTP id d9443c01a7336-290c9ca804emr292414055ad.18.1761179585461;
        Wed, 22 Oct 2025 17:33:05 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e1232f1sm3770305ad.95.2025.10.22.17.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 17:33:05 -0700 (PDT)
Date: Wed, 22 Oct 2025 17:33:02 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
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
	Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	alistair.francis@wdc.com, richard.henderson@linaro.org,
	jim.shu@sifive.com, andybnac@gmail.com, kito.cheng@sifive.com,
	charlie@rivosinc.com, atishp@rivosinc.com, evan@rivosinc.com,
	cleger@rivosinc.com, alexghiti@rivosinc.com,
	samitolvanen@google.com, broonie@kernel.org,
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
	Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>,
	Charles Mirabile <cmirabil@redhat.com>
Subject: Re: [PATCH v22 00/28] riscv control-flow integrity for usermode
Message-ID: <aPl3vr-mYljA7Dse@debug.ba.rivosinc.com>
References: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1233E180002
X-Stat-Signature: bwyce3pjcxcjoopgbhx1qr5gusqoeqan
X-Rspam-User: 
X-HE-Tag: 1761179586-106608
X-HE-Meta: U2FsdGVkX19UCzli6p/RMxKwHLGfYdsUrIPG0hxGPpCL3Jl1lm9S0kCYWDWo8p5PKaFDKJIFuI4BqMzznr05O/xiA9i2mUkrfJRtQgjL2PgaFH/YqP9PwT5VOlbauXT6D61nraJ5zOke/walmrppFtBl/J7JVZXmTkKq/2wxSI7punKCEQB6O7JjosTft0qTFL9daVBjfkChRUh5ATTNiDu708ZBpitFUyUuINRu8SP7pPYW7twVBcL4ZiMy0Vw8YjOp/WGjgHd/1ka/bitWN2AFkQSd2gpQfiHQPe9GqmXTsII1J6WFjWOtdX9F166tx8QnHo7uRedqjslgd7L5zQ1TZ6kMI7rGiwv0EXxXTBbScaO024FpL77QZdw/j0cHaPyaLL9+RilfypKlrHnoXfmR9Vde9ZtSnuEVfkFZuIjk1tJrugGpsscNua8XhbhDEozlX3AoW0g3XvI8DxLOjLS5N+Jk9JLj/BUhPn1ZGksW/+KTLTvlUIF+0OLTWXSxagkwr6P+Srsmag57Yw//hLDE1577wIcGNbjf9ybKqVbZxwuaLe/XsiS4KDvyqIkswHV3SVpxMrF/FuP42Hpg7vDpt9lxwp2wGZznVEOnpAvKAfU7CvtOdQgrBVVHbncjt7ge4FZw8WwAISdqj0N1tq8jgKey+hdqcIjmnZYI1wn0wncpvwuET28KBs3L6Hwz/fzE5s2oCUS0QxaFAdLsWhElcFfi3b7qSCvNUevcLmv21umIKEWrfQlfQUPjv2Ugb9w3JRkmPtGJtqDkgVNaTroashkeEaQm7M4o9zBlGnsXG+rGUnqvZ11A0WmTtlH6tRHt2g44FwAiaCTZnwWXP30FIDkLecKrkAtNxs9Y3pJKYuI6Rh/mZ7u4dapWa+DSIcdGSQ9ILW8cEZPMc29Sl8XLG1F1cIVYjFOLB7vyyLof5HDPoGm/jwlwpx2FwVN69LHnVadDRXGLF3SkMeR
 33pHw2WP
 qgufyqQH0fAQ+0qixqegEgItOPNowbl10SHYDoHKlN3zgjZAFtFrAtJpj3Rh/WL6AU8BDX9IEwGPEJAbbZjxRFUSLBezwTzLJPObmvASHWtGZfDfuXOJOrK41q81I1lmZyVLm9o3lPCIUmrA+ww0sDAXsTjnxziZ87XI4FBOtL1K+TzUCXOpLKlO4z7VOlfCXTOIIvDMnyjMyw8j+4ZcXK6tTHL9IqdUqVJxPmB8dxa9HS0FrITJHkk6pBfq+gmaYkqIfz0YySwTviN8lzjTrHS5fw11QR69uifoJRlyoMGQriE4jiWWcg0ElYgWyir4VVTqqMyIXiWicky8XaZ1soiEbYJ9SBvJpkEf/2wBatrCyfREYbg3M0u4CW4fRzdQXJX0t9KiPz1JZJ4dq6Mz+a2PYN4MuqNU+bdUIt/dfSwqMcKguXj13lgh+oX5spjRvLq1nq8e45u6copSVLiXFvhsfSVk78r3xqEPJYWNzLRuFkTl9VHvhGZYJUo8CC87wNzE0F0fbGd7JWjdb4BVW6i1POleTZ1tJq3plXilSRLJ/13EH3Q3vxzRWN6ubaqge3wfQ7JqGZ/JmoBPpyk/HRCNK+ew8skFwb8zPrPvj/K/hzbZky0p6njx4d6mM05DPLEUSeVifLLQZTtTXQs4BPL8zHXRI+6Ft0oAMI1ApUGnrCoDCl6c5toAXnUtnh4hG9mfizGUONWInB5u3zRqo3UnZDesC5wBvvlOxKicqQE8ND62EsdzTylJ4igKUI70B3pdkdHy0Nh6lqZ48ntQJ/ElfxjzWl/q70/e+ps4x4dp1OGXGjSn6RGIIAXejR6hjV6Ro6FRDHp51UStWM6Qu907xNUHQFQqH2P9vIdf8R/Z24G728LIUKRSxxWDe48McArb/GGxncMEXcNQrvh9IitCowqTvu/s+LsmajxVuwi7YQ/HdkVc1Zb/OyLZpY39HBJ09VSdR+5iyYUhcZTlf4yguG88y
 RwGuEVTa
 7To1OmlzoNYnNwF6ZGpfo2btQ09i4IVhEc4sE+0qbyVe9f2iLmhelFbl8m3YEPJZnBtLkyeqSMjfnQLWmyWB/JM3O2XJ4xz6vKwB+AjBlitwy3SQ+0kl8gd2LuKMF0SpMjqzxz4Vx/fwjyE79xFDCeUeBJit3PUw6ftMldlTqDzFuodTGim8jzjeqtjZm4jzWOZcQ/Q+U8fQQeUIb/sfsZ4F6PBmU89zEY63fzMefurT9YIxsmfWc6B6VKTLTTF7Fp+9ZP5Dm6lmbVMkaDpg3b1s2OfO8Nwwja/MdPsoZKLyMtNppiDKsVAliB+gLoFnf7Ygpa0lOjojPImt6qAQcX64jHlJ0/p5v9ZvZ6Lpm8eog1wpsFj4v1qIB/AaEPnEWI884RKYQ13mkl3g7NL/wzvus+ep/9vthQGrn7zDnJInAqMSaDBxd/x2pJ9BGwKuAFjvTsDLAEbpKyRsuOXpWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I don't think I am sending that many patches. It's 28 patches.
I did send v21 using same smtp settings on my end.

Although since this week whenever I am sending patch series, after 14th/15th
patch, I start getting below error for all recipients.

"""
The user you are trying to contact is receiving mail at a rate that\n
4.2.1 prevents additional messages from being delivered. Please resend your\n
4.2.1 message at a later time. If the user is able to receive mail at that\n
4.2.1 time, your message will be delivered. For more information, go to\n
4.2.1  https://support.google.com/mail/?p=ReceivingRate 98e67ed59e1d1-33dfb7f8310sm153460a91.5 - gsmtp')
"""

I did try "git config --local sendmail.smtpReloginDelay 60", it doesn't seem to
help. If anyone has faced this and knows how to get around that'll be helpful.
In the meanwhile, I'll keep figuring it out on what really changed this week.

-Deepak

On Wed, Oct 22, 2025 at 04:29:26PM -0700, Deepak Gupta wrote:
>v22: fixing build error due to -march=zicfiss being picked in gcc-13 and above
>but not actually doing any codegen or recognizing instruction for zicfiss.
>Change in v22 makes dependence on `-fcf-protection=full` compiler flag to
>ensure that toolchain has support and then only CONFIG_RISCV_USER_CFI will be
>visible in menuconfig.
>
>v21: fixed build errors.
>
>Basics and overview
>===================
>
>Software with larger attack surfaces (e.g. network facing apps like databases,
>browsers or apps relying on browser runtimes) suffer from memory corruption
>issues which can be utilized by attackers to bend control flow of the program
>to eventually gain control (by making their payload executable). Attackers are
>able to perform such attacks by leveraging call-sites which rely on indirect
>calls or return sites which rely on obtaining return address from stack memory.
>
>To mitigate such attacks, risc-v extension zicfilp enforces that all indirect
>calls must land on a landing pad instruction `lpad` else cpu will raise software
>check exception (a new cpu exception cause code on riscv).
>Similarly for return flow, risc-v extension zicfiss extends architecture with
>
>- `sspush` instruction to push return address on a shadow stack
>- `sspopchk` instruction to pop return address from shadow stack
>  and compare with input operand (i.e. return address on stack)
>- `sspopchk` to raise software check exception if comparision above
>  was a mismatch
>- Protection mechanism using which shadow stack is not writeable via
>  regular store instructions
>
>More information an details can be found at extensions github repo [1].
>
>Equivalent to landing pad (zicfilp) on x86 is `ENDBRANCH` instruction in Intel
>CET [3] and branch target identification (BTI) [4] on arm.
>Similarly x86's Intel CET has shadow stack [5] and arm64 has guarded control
>stack (GCS) [6] which are very similar to risc-v's zicfiss shadow stack.
>
>x86 and arm64 support for user mode shadow stack is already in mainline.
>
>Kernel awareness for user control flow integrity
>================================================
>
>This series picks up Samuel Holland's envcfg changes [2] as well. So if those are
>being applied independently, they should be removed from this series.
>
>Enabling:
>
>In order to maintain compatibility and not break anything in user mode, kernel
>doesn't enable control flow integrity cpu extensions on binary by default.
>Instead exposes a prctl interface to enable, disable and lock the shadow stack
>or landing pad feature for a task. This allows userspace (loader) to enumerate
>if all objects in its address space are compiled with shadow stack and landing
>pad support and accordingly enable the feature. Additionally if a subsequent
>`dlopen` happens on a library, user mode can take a decision again to disable
>the feature (if incoming library is not compiled with support) OR terminate the
>task (if user mode policy is strict to have all objects in address space to be
>compiled with control flow integirty cpu feature). prctl to enable shadow stack
>results in allocating shadow stack from virtual memory and activating for user
>address space. x86 and arm64 are also following same direction due to similar
>reason(s).
>
>clone/fork:
>
>On clone and fork, cfi state for task is inherited by child. Shadow stack is
>part of virtual memory and is a writeable memory from kernel perspective
>(writeable via a restricted set of instructions aka shadow stack instructions)
>Thus kernel changes ensure that this memory is converted into read-only when
>fork/clone happens and COWed when fault is taken due to sspush, sspopchk or
>ssamoswap. In case `CLONE_VM` is specified and shadow stack is to be enabled,
>kernel will automatically allocate a shadow stack for that clone call.
>
>map_shadow_stack:
>
>x86 introduced `map_shadow_stack` system call to allow user space to explicitly
>map shadow stack memory in its address space. It is useful to allocate shadow
>for different contexts managed by a single thread (green threads or contexts)
>risc-v implements this system call as well.
>
>signal management:
>
>If shadow stack is enabled for a task, kernel performs an asynchronous control
>flow diversion to deliver the signal and eventually expects userspace to issue
>sigreturn so that original execution can be resumed. Even though resume context
>is prepared by kernel, it is in user space memory and is subject to memory
>corruption and corruption bugs can be utilized by attacker in this race window
>to perform arbitrary sigreturn and eventually bypass cfi mechanism.
>Another issue is how to ensure that cfi related state on sigcontext area is not
>trampled by legacy apps or apps compiled with old kernel headers.
>
>In order to mitigate control-flow hijacting, kernel prepares a token and place
>it on shadow stack before signal delivery and places address of token in
>sigcontext structure. During sigreturn, kernel obtains address of token from
>sigcontext struture, reads token from shadow stack and validates it and only
>then allow sigreturn to succeed. Compatiblity issue is solved by adopting
>dynamic sigcontext management introduced for vector extension. This series
>re-factor the code little bit to allow future sigcontext management easy (as
>proposed by Andy Chiu from SiFive)
>
>config and compilation:
>
>Introduce a new risc-v config option `CONFIG_RISCV_USER_CFI`. Selecting this
>config option picks the kernel support for user control flow integrity. This
>optin is presented only if toolchain has shadow stack and landing pad support.
>And is on purpose guarded by toolchain support. Reason being that eventually
>vDSO also needs to be compiled in with shadow stack and landing pad support.
>vDSO compile patches are not included as of now because landing pad labeling
>scheme is yet to settle for usermode runtime.
>
>To get more information on kernel interactions with respect to
>zicfilp and zicfiss, patch series adds documentation for
>`zicfilp` and `zicfiss` in following:
>Documentation/arch/riscv/zicfiss.rst
>Documentation/arch/riscv/zicfilp.rst
>
>How to test this series
>=======================
>
>Toolchain
>---------
>$ git clone git@github.com:sifive/riscv-gnu-toolchain.git -b cfi-dev
>$ riscv-gnu-toolchain/configure --prefix=<path-to-where-to-build> --with-arch=rv64gc_zicfilp_zicfiss --enable-linux --disable-gdb  --with-extra-multilib-test="rv64gc_zicfilp_zicfiss-lp64d:-static"
>$ make -j$(nproc)
>
>Qemu
>----
>Get the lastest qemu
>$ cd qemu
>$ mkdir build
>$ cd build
>$ ../configure --target-list=riscv64-softmmu
>$ make -j$(nproc)
>
>Opensbi
>-------
>$ git clone git@github.com:deepak0414/opensbi.git -b v6_cfi_spec_split_opensbi
>$ make CROSS_COMPILE=<your riscv toolchain> -j$(nproc) PLATFORM=generic
>
>Linux
>-----
>Running defconfig is fine. CFI is enabled by default if the toolchain
>supports it.
>
>$ make ARCH=riscv CROSS_COMPILE=<path-to-cfi-riscv-gnu-toolchain>/build/bin/riscv64-unknown-linux-gnu- -j$(nproc) defconfig
>$ make ARCH=riscv CROSS_COMPILE=<path-to-cfi-riscv-gnu-toolchain>/build/bin/riscv64-unknown-linux-gnu- -j$(nproc)
>
>Running
>-------
>
>Modify your qemu command to have:
>-bios <path-to-cfi-opensbi>/build/platform/generic/firmware/fw_dynamic.bin
>-cpu rv64,zicfilp=true,zicfiss=true,zimop=true,zcmop=true
>
>References
>==========
>[1] - https://github.com/riscv/riscv-cfi
>[2] - https://lore.kernel.org/all/20240814081126.956287-1-samuel.holland@sifive.com/
>[3] - https://lwn.net/Articles/889475/
>[4] - https://developer.arm.com/documentation/109576/0100/Branch-Target-Identification
>[5] - https://www.intel.com/content/dam/develop/external/us/en/documents/catc17-introduction-intel-cet-844137.pdf
>[6] - https://lwn.net/Articles/940403/
>
>To: Thomas Gleixner <tglx@linutronix.de>
>To: Ingo Molnar <mingo@redhat.com>
>To: Borislav Petkov <bp@alien8.de>
>To: Dave Hansen <dave.hansen@linux.intel.com>
>To: x86@kernel.org
>To: H. Peter Anvin <hpa@zytor.com>
>To: Andrew Morton <akpm@linux-foundation.org>
>To: Liam R. Howlett <Liam.Howlett@oracle.com>
>To: Vlastimil Babka <vbabka@suse.cz>
>To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>To: Paul Walmsley <paul.walmsley@sifive.com>
>To: Palmer Dabbelt <palmer@dabbelt.com>
>To: Albert Ou <aou@eecs.berkeley.edu>
>To: Conor Dooley <conor@kernel.org>
>To: Rob Herring <robh@kernel.org>
>To: Krzysztof Kozlowski <krzk+dt@kernel.org>
>To: Arnd Bergmann <arnd@arndb.de>
>To: Christian Brauner <brauner@kernel.org>
>To: Peter Zijlstra <peterz@infradead.org>
>To: Oleg Nesterov <oleg@redhat.com>
>To: Eric Biederman <ebiederm@xmission.com>
>To: Kees Cook <kees@kernel.org>
>To: Jonathan Corbet <corbet@lwn.net>
>To: Shuah Khan <shuah@kernel.org>
>To: Jann Horn <jannh@google.com>
>To: Conor Dooley <conor+dt@kernel.org>
>To: Miguel Ojeda <ojeda@kernel.org>
>To: Alex Gaynor <alex.gaynor@gmail.com>
>To: Boqun Feng <boqun.feng@gmail.com>
>To: Gary Guo <gary@garyguo.net>
>To: Björn Roy Baron <bjorn3_gh@protonmail.com>
>To: Benno Lossin <benno.lossin@proton.me>
>To: Andreas Hindborg <a.hindborg@kernel.org>
>To: Alice Ryhl <aliceryhl@google.com>
>To: Trevor Gross <tmgross@umich.edu>
>Cc: linux-kernel@vger.kernel.org
>Cc: linux-fsdevel@vger.kernel.org
>Cc: linux-mm@kvack.org
>Cc: linux-riscv@lists.infradead.org
>Cc: devicetree@vger.kernel.org
>Cc: linux-arch@vger.kernel.org
>Cc: linux-doc@vger.kernel.org
>Cc: linux-kselftest@vger.kernel.org
>Cc: alistair.francis@wdc.com
>Cc: richard.henderson@linaro.org
>Cc: jim.shu@sifive.com
>Cc: andybnac@gmail.com
>Cc: kito.cheng@sifive.com
>Cc: charlie@rivosinc.com
>Cc: atishp@rivosinc.com
>Cc: evan@rivosinc.com
>Cc: cleger@rivosinc.com
>Cc: alexghiti@rivosinc.com
>Cc: samitolvanen@google.com
>Cc: broonie@kernel.org
>Cc: rick.p.edgecombe@intel.com
>Cc: rust-for-linux@vger.kernel.org
>
>changelog
>---------
>v22:
>- CONFIG_RISCV_USER_CFI was by default "n". With dual vdso support it is
>  default "y" (if toolchain supports it). Fixing build error due to
>  "-march=zicfiss" being picked in gcc-13 partially. gcc-13 only recognizes the
>  flag but not actually doing any codegen or recognizing instruction for zicfiss.
>  Change in v22 makes dependence on `-fcf-protection=full` compiler flag to
>  ensure that toolchain has support and then only CONFIG_RISCV_USER_CFI will be
>  visible in menuconfig.
>- picked up tags and some cosmetic changes in commit message for dual vdso
>  patch.
>
>
>v21:
>- Fixing build errors due to changes in arch/riscv/include/asm/vdso.h
>  Using #ifdef instead of IS_ENABLED in arch/riscv/include/asm/vdso.h
>  vdso-cfi-offsets.h should be included only when CONFIG_RISCV_USER_CFI
>  is selected.
>
>v20:
>- rebased on v6.18-rc1.
>- Added two vDSO support. If `CONFIG_RISCV_USER_CFI` is selected
>  two vDSOs are compiled (one for hardware prior to RVA23 and one
>  for RVA23 onwards). Kernel exposes RVA23 vDSO if hardware/cpu
>  implements zimop else exposes existing vDSO to userspace.
>- default selection for `CONFIG_RISCV_USER_CFI` is "Yes".
>- replaced "__ASSEMBLY__" with "__ASSEMBLER__"
>
>v19:
>- riscv_nousercfi was `int`. changed it to unsigned long.
>  Thanks to Alex Ghiti for reporting it. It was a bug.
>- ELP is cleared on trap entry only when CONFIG_64BIT.
>- restore ssp back on return to usermode was being done
>  before `riscv_v_context_nesting_end` on trap exit path.
>  If kernel shadow stack were enabled this would result in
>  kernel operating on user shadow stack and panic (as I found
>  in my testing of kcfi patch series). So fixed that.
>
>v18:
>- rebased on 6.16-rc1
>- uprobe handling clears ELP in sstatus image in pt_regs
>- vdso was missing shadow stack elf note for object files.
>  added that. Additional asm file for vdso needed the elf marker
>  flag. toolchain should complain if `-fcf-protection=full` and
>  marker is missing for object generated from asm file. Asked
>  toolchain folks to fix this. Although no reason to gate the merge
>  on that.
>- Split up compile options for march and fcf-protection in vdso
>  Makefile
>- CONFIG_RISCV_USER_CFI option is moved under "Kernel features" menu
>  Added `arch/riscv/configs/hardening.config` fragment which selects
>  CONFIG_RISCV_USER_CFI
>
>v17:
>- fixed warnings due to empty macros in usercfi.h (reported by alexg)
>- fixed prefixes in commit titles reported by alexg
>- took below uprobe with fcfi v2 patch from Zong Li and squashed it with
>  "riscv/traps: Introduce software check exception and uprobe handling"
>  https://lore.kernel.org/all/20250604093403.10916-1-zong.li@sifive.com/
>
>v16:
>- If FWFT is not implemented or returns error for shadow stack activation, then
>  no_usercfi is set to disable shadow stack. Although this should be picked up
>  by extension validation and activation. Fixed this bug for zicfilp and zicfiss
>  both. Thanks to Charlie Jenkins for reporting this.
>- If toolchain doesn't support cfi, cfi kselftest shouldn't build. Suggested by
>  Charlie Jenkins.
>- Default for CONFIG_RISCV_USER_CFI is set to no. Charlie/Atish suggested to
>  keep it off till we have more hardware availibility with RVA23 profile and
>  zimop/zcmop implemented. Else this will start breaking people's workflow
>- Includes the fix if "!RV64 and !SBI" then definitions for FWFT in
>  asm-offsets.c error.
>
>v15:
>- Toolchain has been updated to include `-fcf-protection` flag. This
>  exists for x86 as well. Updated kernel patches to compile vDSO and
>  selftest to compile with `fcf-protection=full` flag.
>- selecting CONFIG_RISCV_USERCFI selects CONFIG_RISCV_SBI.
>- Patch to enable shadow stack for kernel wasn't hidden behind
>  CONFIG_RISCV_USERCFI and CONFIG_RISCV_SBI. fixed that.
>
>v14:
>- rebased on top of palmer/sbi-v3. Thus dropped clement's FWFT patches
>  Updated RISCV_ISA_EXT_XXXX in hwcap and hwprobe constants.
>- Took Radim's suggestions on bitfields.
>- Placed cfi_state at the end of thread_info block so that current situation
>  is not disturbed with respect to member fields of thread_info in single
>  cacheline.
>
>v13:
>- cpu_supports_shadow_stack/cpu_supports_indirect_br_lp_instr uses
>  riscv_has_extension_unlikely()
>- uses nops(count) to create nop slide
>- RISCV_ACQUIRE_BARRIER is not needed in `amo_user_shstk`. Removed it
>- changed ternaries to simply use implicit casting to convert to bool.
>- kernel command line allows to disable zicfilp and zicfiss independently.
>  updated kernel-parameters.txt.
>- ptrace user abi for cfi uses bitmasks instead of bitfields. Added ptrace
>  kselftest.
>- cosmetic and grammatical changes to documentation.
>
>v12:
>- It seems like I had accidently squashed arch agnostic indirect branch
>  tracking prctl and riscv implementation of those prctls. Split them again.
>- set_shstk_status/set_indir_lp_status perform CSR writes only when CPU
>  support is available. As suggested by Zong Li.
>- Some minor clean up in kselftests as suggested by Zong Li.
>
>v11:
>- patch "arch/riscv: compile vdso with landing pad" was unconditionally
>  selecting `_zicfilp` for vDSO compile. fixed that. Changed `lpad 1` to
>  to `lpad 0`.
>v10:
>- dropped "mm: helper `is_shadow_stack_vma` to check shadow stack vma". This patch
>  is not that interesting to this patch series for risc-v. There are instances in
>  arch directories where VM_SHADOW_STACK flag is anyways used. Dropping this patch
>  to expedite merging in riscv tree.
>- Took suggestions from `Clement` on "riscv: zicfiss / zicfilp enumeration" to
>  validate presence of cfi based on config.
>- Added a patch for vDSO to have `lpad 0`. I had omitted this earlier to make sure
>  we add single vdso object with cfi enabled. But a vdso object with scheme of
>  zero labeled landing pad is least common denominator and should work with all
>  objects of zero labeled as well as function-signature labeled objects.
>
>v9:
>- rebased on master (39a803b754d5 fix braino in "9p: fix ->rename_sem exclusion")
>- dropped "mm: Introduce ARCH_HAS_USER_SHADOW_STACK" (master has it from arm64/gcs)
>- dropped "prctl: arch-agnostic prctl for shadow stack" (master has it from arm64/gcs)
>
>v8:
>- rebased on palmer/for-next
>- dropped samuel holland's `envcfg` context switch patches.
>  they are in parlmer/for-next
>
>v7:
>- Removed "riscv/Kconfig: enable HAVE_EXIT_THREAD for riscv"
>  Instead using `deactivate_mm` flow to clean up.
>  see here for more context
>  https://lore.kernel.org/all/20230908203655.543765-1-rick.p.edgecombe@intel.com/#t
>- Changed the header include in `kselftest`. Hopefully this fixes compile
>  issue faced by Zong Li at SiFive.
>- Cleaned up an orphaned change to `mm/mmap.c` in below patch
>  "riscv/mm : ensure PROT_WRITE leads to VM_READ | VM_WRITE"
>- Lock interfaces for shadow stack and indirect branch tracking expect arg == 0
>  Any future evolution of this interface should accordingly define how arg should
>  be setup.
>- `mm/map.c` has an instance of using `VM_SHADOW_STACK`. Fixed it to use helper
>  `is_shadow_stack_vma`.
>- Link to v6: https://lore.kernel.org/r/20241008-v5_user_cfi_series-v6-0-60d9fe073f37@rivosinc.com
>
>v6:
>- Picked up Samuel Holland's changes as is with `envcfg` placed in
>  `thread` instead of `thread_info`
>- fixed unaligned newline escapes in kselftest
>- cleaned up messages in kselftest and included test output in commit message
>- fixed a bug in clone path reported by Zong Li
>- fixed a build issue if CONFIG_RISCV_ISA_V is not selected
>  (this was introduced due to re-factoring signal context
>  management code)
>
>v5:
>- rebased on v6.12-rc1
>- Fixed schema related issues in device tree file
>- Fixed some of the documentation related issues in zicfilp/ss.rst
>  (style issues and added index)
>- added `SHADOW_STACK_SET_MARKER` so that implementation can define base
>  of shadow stack.
>- Fixed warnings on definitions added in usercfi.h when
>  CONFIG_RISCV_USER_CFI is not selected.
>- Adopted context header based signal handling as proposed by Andy Chiu
>- Added support for enabling kernel mode access to shadow stack using
>  FWFT
>  (https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/ext-firmware-features.adoc)
>- Link to v5: https://lore.kernel.org/r/20241001-v5_user_cfi_series-v1-0-3ba65b6e550f@rivosinc.com
>  (Note: I had an issue in my workflow due to which version number wasn't
>  picked up correctly while sending out patches)
>
>v4:
>- rebased on 6.11-rc6
>- envcfg: Converged with Samuel Holland's patches for envcfg management on per-
>thread basis.
>- vma_is_shadow_stack is renamed to is_vma_shadow_stack
>- picked up Mark Brown's `ARCH_HAS_USER_SHADOW_STACK` patch
>- signal context: using extended context management to maintain compatibility.
>- fixed `-Wmissing-prototypes` compiler warnings for prctl functions
>- Documentation fixes and amending typos.
>- Link to v4: https://lore.kernel.org/all/20240912231650.3740732-1-debug@rivosinc.com/
>
>v3:
>- envcfg
>  logic to pick up base envcfg had a bug where `ENVCFG_CBZE` could have been
>  picked on per task basis, even though CPU didn't implement it. Fixed in
>   this series.
>
>- dt-bindings
>  As suggested, split into separate commit. fixed the messaging that spec is
>  in public review
>
>- arch_is_shadow_stack change
>  arch_is_shadow_stack changed to vma_is_shadow_stack
>
>- hwprobe
>  zicfiss / zicfilp if present will get enumerated in hwprobe
>
>- selftests
>  As suggested, added object and binary filenames to .gitignore
>  Selftest binary anyways need to be compiled with cfi enabled compiler which
>  will make sure that landing pad and shadow stack are enabled. Thus removed
>  separate enable/disable tests. Cleaned up tests a bit.
>
>- Link to v3: https://lore.kernel.org/lkml/20240403234054.2020347-1-debug@rivosinc.com/
>
>v2:
>- Using config `CONFIG_RISCV_USER_CFI`, kernel support for riscv control flow
>  integrity for user mode programs can be compiled in the kernel.
>
>- Enabling of control flow integrity for user programs is left to user runtime
>
>- This patch series introduces arch agnostic `prctls` to enable shadow stack
>  and indirect branch tracking. And implements them on riscv.
>
>---
>Changes in v22:
>- Link to v21: https://lore.kernel.org/r/20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com
>
>Changes in v21:
>- Link to v20: https://lore.kernel.org/r/20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com
>
>Changes in v20:
>- Link to v19: https://lore.kernel.org/r/20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com
>
>Changes in v19:
>- Link to v18: https://lore.kernel.org/r/20250711-v5_user_cfi_series-v18-0-a8ee62f9f38e@rivosinc.com
>
>Changes in v18:
>- Link to v17: https://lore.kernel.org/r/20250604-v5_user_cfi_series-v17-0-4565c2cf869f@rivosinc.com
>
>Changes in v17:
>- Link to v16: https://lore.kernel.org/r/20250522-v5_user_cfi_series-v16-0-64f61a35eee7@rivosinc.com
>
>Changes in v16:
>- Link to v15: https://lore.kernel.org/r/20250502-v5_user_cfi_series-v15-0-914966471885@rivosinc.com
>
>Changes in v15:
>- changelog posted just below cover letter
>- Link to v14: https://lore.kernel.org/r/20250429-v5_user_cfi_series-v14-0-5239410d012a@rivosinc.com
>
>Changes in v14:
>
>- changelog posted just below cover letter
>- Link to v13: https://lore.kernel.org/r/20250424-v5_user_cfi_series-v13-0-971437de586a@rivosinc.com
>
>Changes in v13:
>- changelog posted just below cover letter
>- Link to v12: https://lore.kernel.org/r/20250314-v5_user_cfi_series-v12-0-e51202b53138@rivosinc.com
>
>Changes in v12:
>- changelog posted just below cover letter
>- Link to v11: https://lore.kernel.org/r/20250310-v5_user_cfi_series-v11-0-86b36cbfb910@rivosinc.com
>
>Changes in v11:
>- changelog posted just below cover letter
>- Link to v10: https://lore.kernel.org/r/20250210-v5_user_cfi_series-v10-0-163dcfa31c60@rivosinc.com
>
>---
>Andy Chiu (1):
>      riscv: signal: abstract header saving for setup_sigcontext
>
>Deepak Gupta (26):
>      mm: VM_SHADOW_STACK definition for riscv
>      dt-bindings: riscv: zicfilp and zicfiss in dt-bindings (extensions.yaml)
>      riscv: zicfiss / zicfilp enumeration
>      riscv: zicfiss / zicfilp extension csr and bit definitions
>      riscv: usercfi state for task and save/restore of CSR_SSP on trap entry/exit
>      riscv/mm : ensure PROT_WRITE leads to VM_READ | VM_WRITE
>      riscv/mm: manufacture shadow stack pte
>      riscv/mm: teach pte_mkwrite to manufacture shadow stack PTEs
>      riscv/mm: write protect and shadow stack
>      riscv/mm: Implement map_shadow_stack() syscall
>      riscv/shstk: If needed allocate a new shadow stack on clone
>      riscv: Implements arch agnostic shadow stack prctls
>      prctl: arch-agnostic prctl for indirect branch tracking
>      riscv: Implements arch agnostic indirect branch tracking prctls
>      riscv/traps: Introduce software check exception and uprobe handling
>      riscv/signal: save and restore of shadow stack for signal
>      riscv/kernel: update __show_regs to print shadow stack register
>      riscv/ptrace: riscv cfi status and state via ptrace and in core files
>      riscv/hwprobe: zicfilp / zicfiss enumeration in hwprobe
>      riscv: kernel command line option to opt out of user cfi
>      riscv: enable kernel access to shadow stack memory via FWFT sbi call
>      arch/riscv: dual vdso creation logic and select vdso based on hw
>      riscv: create a config for shadow stack and landing pad instr support
>      riscv: Documentation for landing pad / indirect branch tracking
>      riscv: Documentation for shadow stack on riscv
>      kselftest/riscv: kselftest for user mode cfi
>
>Jim Shu (1):
>      arch/riscv: compile vdso with landing pad and shadow stack note
>
> Documentation/admin-guide/kernel-parameters.txt    |   8 +
> Documentation/arch/riscv/index.rst                 |   2 +
> Documentation/arch/riscv/zicfilp.rst               | 115 +++++
> Documentation/arch/riscv/zicfiss.rst               | 179 +++++++
> .../devicetree/bindings/riscv/extensions.yaml      |  14 +
> arch/riscv/Kconfig                                 |  22 +
> arch/riscv/Makefile                                |   8 +-
> arch/riscv/configs/hardening.config                |   4 +
> arch/riscv/include/asm/asm-prototypes.h            |   1 +
> arch/riscv/include/asm/assembler.h                 |  44 ++
> arch/riscv/include/asm/cpufeature.h                |  12 +
> arch/riscv/include/asm/csr.h                       |  16 +
> arch/riscv/include/asm/entry-common.h              |   2 +
> arch/riscv/include/asm/hwcap.h                     |   2 +
> arch/riscv/include/asm/mman.h                      |  26 +
> arch/riscv/include/asm/mmu_context.h               |   7 +
> arch/riscv/include/asm/pgtable.h                   |  30 +-
> arch/riscv/include/asm/processor.h                 |   1 +
> arch/riscv/include/asm/thread_info.h               |   3 +
> arch/riscv/include/asm/usercfi.h                   |  95 ++++
> arch/riscv/include/asm/vdso.h                      |  13 +-
> arch/riscv/include/asm/vector.h                    |   3 +
> arch/riscv/include/uapi/asm/hwprobe.h              |   2 +
> arch/riscv/include/uapi/asm/ptrace.h               |  34 ++
> arch/riscv/include/uapi/asm/sigcontext.h           |   1 +
> arch/riscv/kernel/Makefile                         |   2 +
> arch/riscv/kernel/asm-offsets.c                    |  10 +
> arch/riscv/kernel/cpufeature.c                     |  27 +
> arch/riscv/kernel/entry.S                          |  38 ++
> arch/riscv/kernel/head.S                           |  27 +
> arch/riscv/kernel/process.c                        |  27 +-
> arch/riscv/kernel/ptrace.c                         |  95 ++++
> arch/riscv/kernel/signal.c                         | 148 +++++-
> arch/riscv/kernel/sys_hwprobe.c                    |   2 +
> arch/riscv/kernel/sys_riscv.c                      |  10 +
> arch/riscv/kernel/traps.c                          |  54 ++
> arch/riscv/kernel/usercfi.c                        | 545 +++++++++++++++++++++
> arch/riscv/kernel/vdso.c                           |   7 +
> arch/riscv/kernel/vdso/Makefile                    |  40 +-
> arch/riscv/kernel/vdso/flush_icache.S              |   4 +
> arch/riscv/kernel/vdso/gen_vdso_offsets.sh         |   4 +-
> arch/riscv/kernel/vdso/getcpu.S                    |   4 +
> arch/riscv/kernel/vdso/note.S                      |   3 +
> arch/riscv/kernel/vdso/rt_sigreturn.S              |   4 +
> arch/riscv/kernel/vdso/sys_hwprobe.S               |   4 +
> arch/riscv/kernel/vdso/vgetrandom-chacha.S         |   5 +-
> arch/riscv/kernel/vdso_cfi/Makefile                |  25 +
> arch/riscv/kernel/vdso_cfi/vdso-cfi.S              |  11 +
> arch/riscv/mm/init.c                               |   2 +-
> arch/riscv/mm/pgtable.c                            |  16 +
> include/linux/cpu.h                                |   4 +
> include/linux/mm.h                                 |   7 +
> include/uapi/linux/elf.h                           |   2 +
> include/uapi/linux/prctl.h                         |  27 +
> kernel/sys.c                                       |  30 ++
> tools/testing/selftests/riscv/Makefile             |   2 +-
> tools/testing/selftests/riscv/cfi/.gitignore       |   3 +
> tools/testing/selftests/riscv/cfi/Makefile         |  16 +
> tools/testing/selftests/riscv/cfi/cfi_rv_test.h    |  82 ++++
> tools/testing/selftests/riscv/cfi/riscv_cfi_test.c | 173 +++++++
> tools/testing/selftests/riscv/cfi/shadowstack.c    | 385 +++++++++++++++
> tools/testing/selftests/riscv/cfi/shadowstack.h    |  27 +
> 62 files changed, 2475 insertions(+), 41 deletions(-)
>---
>base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
>change-id: 20240930-v5_user_cfi_series-3dc332f8f5b2
>--
>- debug
>

