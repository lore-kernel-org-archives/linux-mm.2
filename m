Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 452AAC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 08:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66586B0089; Fri,  8 Aug 2025 04:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E116B008A; Fri,  8 Aug 2025 04:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54206B008C; Fri,  8 Aug 2025 04:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93A7F6B0089
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 04:23:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 508D1138580
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:23:22 +0000 (UTC)
X-FDA: 83752900644.20.5FC57E5
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5569840004
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:23:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dfI10oFa;
	spf=pass (imf01.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754641400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqclBjlpReb8Zh2xzaAy1Tthw4Ak4Apujt4wspR+yjo=;
	b=XRXWe39BB3f3hi61+zRK5H2v5i9khDSUbv50sczS2kIrk8pHTGHDF9DcBZOH8hgrViGXms
	EbU7B7mfyHGZqpHlQ/6yyC80PKkuomJ0keAAww2Ks7txrsRSl6Rmd7A1v6yNmpgeEW0NWf
	H/YeyUIzUw2+NIaHumh5Upl4H697T8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754641400; a=rsa-sha256;
	cv=none;
	b=gyM77mJ5S8TDMIw01i36h2QrCgTVAxjp86DOD8E4C+tmqMHu5hW3ab3y0bMYzUbtO+tYqD
	l07kpSjzalSE9Ks90XEL9f21Q7Z712RaF/AeoyqubgJJ1uzv8fzBBmTCGbUKjeliPTAGSM
	XC3FqhuRz8GzTtmGFxZ8MESt/RU/pAc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dfI10oFa;
	spf=pass (imf01.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24049d1643aso14217205ad.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 01:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1754641399; x=1755246199; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rqclBjlpReb8Zh2xzaAy1Tthw4Ak4Apujt4wspR+yjo=;
        b=dfI10oFaOXFPkZMynGvnByPSq1bRL3K6ozSyIpEztuQ8c4kGRkdyQaRvw93vshp90s
         gbE0iLhR3Xua2FRTCsUEI/kqoaRSnouwWF15NyhAPjPHoiMBtEcUhNd2qC0PoCNtFN0s
         yKFlKWaxHWeyZRNNvpdu0k7cSzQgeFgD5rGil3vdJjfyKTSEBWseIAXn0d9lB3GXqwc+
         9Bt07/KKx7g4aw+vlyd9t6yCUy1kvHjTxXqt+AI+CNh7VN7K0oWgU68oif2octhdq43N
         S6Pr885ePX2rtyDK0GZmwOuoNs80AJoTyDiCBSA8i/qDnnBCoA0WxJG2stDhgvlr/I2j
         SyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754641399; x=1755246199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqclBjlpReb8Zh2xzaAy1Tthw4Ak4Apujt4wspR+yjo=;
        b=T1fqb2kvGX2ensr+AKeW0m8pjVwaE7ip3at/JZ6UaJlf6nvjNTEOM27LMFRz7YgTL5
         mQL6jAD4P8Hv9nMsVfL6F4dy4+kDL73VgkiNIOqfCNRjR/W8dpfS7S8M0FZmozx8VvTg
         jj190CuHi0nRs72rC6zOWkthg8zVC1GnwzQCwN+yZk43r24f6Jg+1iPRvhHA3RuEJtsy
         T004yHnfIemmaCPmzAdcUxMFRWfxbefL1CsmM/L6zZl7IcpAHXi75E/hmztbFpCpu1SO
         20hRW1rR5FJrPUTZuptUXSD7nPFjjlnyp7n8/IjyeCe/pk4T0mb8ZX37X5RbolZK2l4v
         Gx2A==
X-Forwarded-Encrypted: i=1; AJvYcCW6bIuCdrO26Qt4re4CBC81cjVUS32j0yrWUwg1yz4i7eiPTTeC7wxdmr5X2fgy5B6Drop2onK9+g==@kvack.org
X-Gm-Message-State: AOJu0YxLDHGP0etkwiepQgAE6yv3EAvpP+aufn13/5BuWCV7Gnv4uFMc
	0n1pwDtPyyuqBzO0WqIDiyyagTDvMIDUPRw/AQY92aycY6fjpYGTrXRdcAf2IRLwwkA=
X-Gm-Gg: ASbGncsTtr5aPkR8q8w1U+qZSYzc2+rrpcpHTVUJhp6vEy/Lw1bpXZSy+DCYuREGEEE
	rr7cCU3EGF7LTFsgNxGlvKqugocvIaEwZ7J2F8ldu4jvCdkulOp1uO05QGsydFQFlGFjhrqrMoA
	3PsfTnxJttPJLjYSLxlC55IKDAd9y1gRnNNKkteJYqOL5Wta7Zl0HsxI6CZgKI+N6iibtSAKhpD
	UsYZhtpkXRBj3spM45AaZqeFl6nggoRQMzNnT8l0GHdi2I5cJiugEoIkHsoQXb3kgEPhiwC905q
	1oFIooJtl7EbaaDmpcbXa8ma5farIPQ3O61jwA3lydcW1ItWLAFiBDPkpq2PHX/U7RiW746wmJ1
	U0l6EmVok3BkrNI4WKiaaTgjzQY59o+XWpHIxTsh/Gls=
X-Google-Smtp-Source: AGHT+IFzkjQpJ+CBSP5FDKaUMlIyJFyzXkrgnGdlTX6xXb/Zh2Ht/mDaf4SC0H4gKEAF5ZgXVLVJMA==
X-Received: by 2002:a17:903:1207:b0:23f:f6ca:6a3 with SMTP id d9443c01a7336-242c2245139mr30852795ad.43.1754641399054;
        Fri, 08 Aug 2025 01:23:19 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef5934sm202807465ad.21.2025.08.08.01.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 01:23:18 -0700 (PDT)
Date: Fri, 8 Aug 2025 01:23:15 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Mark Brown <broonie@kernel.org>
Cc: patchwork-bot+linux-riscv@kernel.org, linux-riscv@lists.infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
	lorenzo.stoakes@oracle.com, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, conor@kernel.org,
	robh@kernel.org, krzk+dt@kernel.org, arnd@arndb.de,
	brauner@kernel.org, peterz@infradead.org, oleg@redhat.com,
	ebiederm@xmission.com, kees@kernel.org, corbet@lwn.net,
	shuah@kernel.org, jannh@google.com, conor+dt@kernel.org,
	ojeda@kernel.org, alex.gaynor@gmail.com, boqun.feng@gmail.com,
	gary@garyguo.net, bjorn3_gh@protonmail.com, a.hindborg@kernel.org,
	aliceryhl@google.com, tmgross@umich.edu, lossin@kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com,
	richard.henderson@linaro.org, jim.shu@sifive.com,
	andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com,
	atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com,
	alexghiti@rivosinc.com, samitolvanen@google.com,
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
	zong.li@sifive.com, david@redhat.com
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
Message-ID: <aJWz82F21pVTSVJi@debug.ba.rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
 <175450053775.2863135.11568399057706626223.git-patchwork-notify@kernel.org>
 <db4eb976-693c-426c-a867-66cadd3dd7d8@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <db4eb976-693c-426c-a867-66cadd3dd7d8@sirena.org.uk>
X-Rspamd-Queue-Id: 5569840004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: f64zwih8dwj1ddwurpnrqb1zqw4ozjeo
X-HE-Tag: 1754641400-315939
X-HE-Meta: U2FsdGVkX18tLgNDZ7vQnfDT3jPdo5FSDglN+lqtLWHi/z+LdAat03jF3GX6/X7IFp5JCf6wK/qu6gMWWHOn85SmDUgMY4Yti9wLxysnCMecLYa3J6s+DZOxy+ly+oKrqx8tkifjak0z/TQgdO/D2vzhunI83P2FiDWqqhplSRE8jhGOrRTGhw07AMopIh1CWfg6cE9iYxYq5AnCPfQ+nfcGvD4zhrQFZ08FuK1hTMBhJbSLAdNhW88E0kjcr/cvKw38vyIHwzhrES85bFEhFKrU5Eh6n5ubiNKmVOmDCXqNJI4YL8E7R5gXrJwQeBJ8DLhicUr6LsxMVnDpt8DUPCIl0rDYEY+APNkH/zYWbJ0ZevkAQxMxUo0BijVFiNSQ0YUp4DkJBnejTY532TevXMpTY0Qmtqto2/675P/V6MQf43E67QfpaqC7HcyESG9DwMZsdlOaPRYA0qq4VHLh0/iASddyXxFpuDmAfQhiVmwAXcuHvfojduMJUjFQkXlY0BSulgInZH5s+QtmQEl6kg9lRAnUE5MErl6Aks5GzWeyA8NDpp6yyYvTg5neE7E/UgTcT9L6expyHidnvE3jngVKtzfkTpsCkZumCdhVtw01Ub7IyXRgzOPzJHPR+lUvqBgBlRb35x8QKmKyvqgIpRkDQWVbSgKMLuE4YAaBI8acMXZud/u98C41wnRI/ZwNwzlqquhClxN4ONrCDt2kERDl5h6b4ZEHp4Bw6f65exn3mdCIpna1bQyw0jHSUdIJxji2Hlo+quNWiGIx0S6/Iu44UVKk5rkq+P5jeQyCXHQV6/VhqNXpX6+dMzlzr6cTaeqVLssigtOssN10iIIfAIUgZnHWosoO/8uRUXkeaYC6vRH3MptTynuyxewAhkdB/wHRuoaYMG/7gQWql8T2X56bLlBruqrvJtxLmz/EQIMZnhVoZTGMlbg+GSuXDXRHTf6dwa5w5Cd78PXXDK0
 ggrjvK7p
 DFOI0nXdvk1U2fM/d6TyWmD9cs83mCUbebVYh/EAczq0fOuHFeQx0XKGoWcbOYvQo+/gLqMJbYggd/nfAWTiJN+cyGgAGxF4iH1tsEgdhLOjQF5sF383sp1Tyi0gmz6OVDSeBhNANH2Cue50G826BYNHEu2EE5g/2bW1KhGUtsz6D0jwgidCJQbuCnDBU07K6zZvjQ/X4BigCOlYJ3eVA7wXL7wddnHdEluYsYFzdbk3Vy4Wt09R2/GMaokmaIiS7zKeLx5vm7iuCdh0HGtTve4iebPXqVm26oOQhRANeAi03YmCUto+tp1jXhS7Q70yq8Aty/XHf3m3aRhcOYTKPZ8+nP5IVPS2BpTO/Ywm8KyZSWqz58zwTMsQyjp861yIducKh5Ya/ETTkV3xdjjHOMZ5FHFEXGe3t+ssZQHUxBChcbyyZ5D8EeTKCDvxcn3pXywT7eEOpRJUDrIi3LHLZOlXT9dmWYjMfTw/i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 01:28:36PM +0100, Mark Brown wrote:
>On Wed, Aug 06, 2025 at 05:15:37PM +0000, patchwork-bot+linux-riscv@kernel.org wrote:
>
>> This series was applied to riscv/linux.git (for-next)
>> by Alexandre Ghiti <alexghiti@rivosinc.com>:
>
>>   - [v19,11/27] riscv/shstk: If needed allocate a new shadow stack on clone
>>     https://git.kernel.org/riscv/c/9c72a71321a6
>>   - [v19,12/27] riscv: Implements arch agnostic shadow stack prctls
>>     https://git.kernel.org/riscv/c/52eff0ab5f8e
>
>Congratulations Deepak!  

Thank you. Happy that its going in.

> Do you have an update for my clone3() shadow
No I don't.

>stack series that I could roll in for when I repost that after the merge
>window, and/or instructions for how to run this stuff for RISC-V on some
>emulated platform?
I would want to write-up instructions. But I don't want you to go through
a lot of hassle of building toolchain and bunch of other stuff.
Let me see how I can make it easy for you. Will report back.

-Deepak



