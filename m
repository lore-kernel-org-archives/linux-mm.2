Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1AFCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 15:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2117090024E; Fri, 15 Aug 2025 11:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E95C90024B; Fri, 15 Aug 2025 11:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1013990024E; Fri, 15 Aug 2025 11:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F316690024B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:05:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BA431401C6
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:05:53 +0000 (UTC)
X-FDA: 83779316586.29.81307DD
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7712C40014
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:05:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=dabbelt-com.20230601.gappssmtp.com header.s=20230601 header.b=rFmjd8NX;
	spf=pass (imf12.hostedemail.com: domain of palmer@dabbelt.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=palmer@dabbelt.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755270351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=38zqqxNHqbGz3C68JOy9Ugb8wAb711DWGVbxjNinx0U=;
	b=M8JO2RL1XwcvnnptHS2fztuzs5eiISbAK8DsRWVXwoA1qrjkg4YQM3AHXQE8Bf9hPNMkmd
	+mUUh+DCcreqTAphrJTE/RUdOFScyVZvxvs1eoZIBLdmNijws9bXP3S6OSt3KtjChD3aRp
	+1HOlmRME2y1RF6yWYG6sT25HxMnXQk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=dabbelt-com.20230601.gappssmtp.com header.s=20230601 header.b=rFmjd8NX;
	spf=pass (imf12.hostedemail.com: domain of palmer@dabbelt.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=palmer@dabbelt.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755270351; a=rsa-sha256;
	cv=none;
	b=BFzcGO0kEaXpVhaKJArYnFh+5ZtV7zAqgbKfp2HcvIB1nIfojG2S0yGH60NEv23erU8cMk
	MuQv39ekyx5muszZ5JgBGKD/f+t8b7JEjJepScW7hJBzohuvbYpybey05y8or2aqRZtjcf
	OemY96ZDBx0vCpOBT7jVzSIjKH3b1Kg=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76e2e618a98so1632949b3a.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1755270350; x=1755875150; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=38zqqxNHqbGz3C68JOy9Ugb8wAb711DWGVbxjNinx0U=;
        b=rFmjd8NXsQh7545PKGdf0dLvM39UN3hXa/6D1UTs4UUkZim7tVBWPLXJu9aviWAKBt
         KN/JGoh2z4lPqEh9X6WFYHu2XpVWNww7kcc/+rBwPrpbdeODP6MJ10vtTaU+zrJxmUVO
         aU9X79PZDyW/BCR0DeZXWrBBfWWcOULFWrH2cQ56mwG1rFt1zb+gw8UMqWcek24pBfFM
         9fj4/z0StWtb9Bf65dDKKUzoeOAe9hdC8oKTVL3VolmpTvf4fXrY84BJep5WaRxN+B3F
         xeav1dMvRQdlKeJTE41J7mC+4BTqpF9bttrcFAGmirqmzHYB8un3YjrFCxCelx+pFs2T
         qoAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755270350; x=1755875150;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=38zqqxNHqbGz3C68JOy9Ugb8wAb711DWGVbxjNinx0U=;
        b=tya68VXfv4zkswLO2x1JoXbuEimTOyDSjUeMwr8WmU0siNzndHGlaP4a4GoGPhZlOn
         LK3FgR2Meq+Yck1hHEZjg0Ul7um05Qvwln4QT/+EIpbAmQEk4TCAFfaBMtR9VvasEGZD
         2iJk0xE00rBipWpNVbqg0dSSc2eErJmNjH8pxTUaOFbViGhNzRA7hUPsxQl+QqPPCoY1
         2TD8kYe8/e/sALX4C8xdgF06LYCdS41aQqYQhAi9s/IYuZP9Cfe/qN6FvstP/lp9JYGt
         2VzOPkiiD+MZ2jL6axOqz1yI7w3xIVALJ24InNmnd8Q5r9xL9v3/otDQSmzmrQZP7K+B
         qEuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaS3Hh6ThWCOoFQXi0KYis0b67oG242ycKl2uQviMcuh0VrlPoNKDvb5gc1Fssnhfrxa7/1HhNag==@kvack.org
X-Gm-Message-State: AOJu0Yz3F8WcMjCBKoBS0jWTSpe+4yX7IoRhOmUmVAskHArVGN3YLi1X
	+y3+04oQJl8GlsoWSFofwbSwrNvMr34RMKdOLU7tFRK3njR8hcd6KYEtrx4ssA7/LvU=
X-Gm-Gg: ASbGncuKB5XLRW90taEIwHucVjwKr0JlssARN5O4V2kuM8lW3ApG05z3tC/ffWT0cUp
	LR9cf4m2+r8kGo2/uvkLJHcwM3SZ69bk09QCmjjqgYJzq5d6ImJfsdoBZdQALrHYARFaIOE7Oml
	tKqtPbCeJZFNJV6KbjtlI+KMnalibH9a2ArYBGs9misn3XCRQv69a71sQv8kdgfdL2kGU6upE1B
	SwYrLBCA/zbNnL2tfNCnQOkboPvwc09WcENUXCYUp+wkYmas8BpJYXSJwIGHbmBypzGmk+YAOfx
	ODz2TMavdcSak7UlcBmiD6nVSeKA4xiDMXrqKALZ7SiYj93Lm+rojn4xfrWrEqUi+rexxBlk19I
	N+azr05qA9Q+49svbhE9i2ZBYVgvQeNjvJUA=
X-Google-Smtp-Source: AGHT+IG3gBMogdOr+spUGY65daTLUVfmz5lhgO/opdXo6UimhkccgL0C2Gx+F8DUbrOBq4AI/2z6Vg==
X-Received: by 2002:a17:903:198c:b0:240:a222:230c with SMTP id d9443c01a7336-2446d5af743mr41307075ad.12.1755270349908;
        Fri, 15 Aug 2025 08:05:49 -0700 (PDT)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2446cadf96fsm16286885ad.41.2025.08.15.08.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 08:05:49 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:05:49 -0700 (PDT)
X-Google-Original-Date: Fri, 15 Aug 2025 08:05:47 PDT (-0700)
Subject:     Re: [PATCH v4 06/24] riscv: elf: Move relocation constants to UAPI
In-Reply-To: <20250812-vdso-absolute-reloc-v4-6-61a8b615e5ec@linutronix.de>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  Alexandre Ghiti <alex@ghiti.fr>, nathan@kernel.org, nick.desaulniers+lkml@gmail.com, morbo@google.com,
  justinstitt@google.com, luto@kernel.org, tglx@linutronix.de, vincenzo.frascino@arm.com,
  kees@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
  hpa@zytor.com, richard@nod.at, anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
  linux@armlinux.org.uk, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
  maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
  chenhuacai@kernel.org, kernel@xen0n.name, hca@linux.ibm.com, gor@linux.ibm.com,
  agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, tsbogend@alpha.franken.de,
  ojeda@kernel.org, alex.gaynor@gmail.com, boqun.feng@gmail.com, gary@garyguo.net,
  bjorn3_gh@protonmail.com, lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
  tmgross@umich.edu, dakr@kernel.org, nicolas.schier@linux.dev, linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org,
  linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
  linux-s390@vger.kernel.org, linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org,
  linux-kbuild@vger.kernel.org, jstancek@redhat.com, acme@redhat.com, alexghiti@rivosinc.com,
  thomas.weissschuh@linutronix.de
From: Palmer Dabbelt <palmer@dabbelt.com>
To: thomas.weissschuh@linutronix.de
Message-ID: <mhng-5B6E084E-60EE-440E-BFF9-5E81AAC9A473@Palmers-Mini.rwc.dabbelt.com>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7712C40014
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: a8yanuiiothygyadgt6ykwuxzepbcu4p
X-HE-Tag: 1755270351-79571
X-HE-Meta: U2FsdGVkX19sEoRhC+ZBlffoEttsJYL4wcxh/1Ie0qs+hNoNbkYLJ5xGQbqo4eokjKIaynGMhfBQW+wfQgw1Te/iRyRiqatri0ybpDdSr8TnSA7ZFAgZq4L8PMy9XaqGq2FOFs3mY1OwRqT+Hr31f/bMaDHoDBF2QRXf7qAdyXtNXpanyn7lfHcEIMxo/sjkPaMt+P4/6GplABCLbjaLRbxm8noA1M45YMegz/Btb7GCWNmhCGUuAc0mGJpy5YJ3DBKfJ0hFuAPLPVKEHqgkzRXSQ1WarYLZxVrPV0FNKCG+wuco+JbCsJgr9adb1jEWHJJE6KFfXw1ooOY/8JnQevgqn2XPKmPizW73EuYDTAUTL0yBfKgv9ZphgKchAUN0p5SeMS49XibOvgMptl5xQHVw/S/I6ldotRmTFzZdCNc4IfQEGqmRufKjdXDy4aW1+5kLGubkGT2JhaqAWyZhN3tThTHj5mywtrd3/nM0JosSa3bKpPyWMLTvMeIv60+8k2mOKMdhvEzUogpVlc/6JhkjjVpWLEn/bZk0FgF9uys9bSUh/2HeM3KJmYqAX2gsGMQuFyN2zTk7DfTyYQ6ryJ70EAmC8+xTcAP0U+R7ldqKEw6/eTQ9+3v6DXgGyYR6gzaVQGObpeZvPmsMZ9BHlOi01PICDvXTjIWQz3VzPvqYNy+DuYzqgX0LL6prTcqD0uyLtrSqwmKNpW+zRQqNxMwjQy0Ebmw5Ko0StiozpuaDtlvUMueEpNyqm/w8c5NnlSRsgPlCVc1DkYH8Wsw9a6UtG9JDV78KqDTnyUvK5V63FH+xrf8sKkctDbojSme5v/zhsUxl+peksU3mDaeaEqQMBawW9ek3/szb98BmfQwLCK18DKgMmGTBr3O9ZKNCHuO9BFOVBtrCPkb32+B9ABlHTRZO7I63YjXZvkAeAfynGMqd011Ac0opZWWAW4b+U5QZMXsKTHS2RWPo7rK
 hqyjYv37
 g4S8ZysxI2clKiAXcNiOESsEg5iO3GA1dlujwcLpnTwdcdeyrhg1oobZNZ0EY20UpzajdtenMVG/04BDPpPynNBMChhod8qGpnbVn6gKpPVBU5zK/2QBP/XCF/bdrcY1+6oBlkOnFthkExnQAG/a8JWYCWxudqE2PJfJLsktg4a8lHs93mXNu1PEH9ZidAmBxWbt8dDLKdMx0sy1XuCHRG8JA5BnfC5DdpxvSnbCoN3eo/XStEpPDVe0DT1+FfoPHL1iCGl4aZFzbonaxvkRqk5Ieo6nq9SmOuHggqoGujQrFr1twqaFl19k0FHsHddwpchbyX+bq4W0Ce0Urp5hFvF9cCBDsnZds6/H+n69E3sGTNLcawSNVx4XJm1kBXBxa8CRuU3wYztw3b3iBLKXsNU384CLg54bfsQBzcMoERSqIhKkoetfE2I8LV+AYUf7lX8baXN9u+Xs7jp8wGxYIeb/Enhk9Mv4LYyMVcPvG9kA0+5wBl7I4RvM+s5LAWQCfbRVe1S0DGbpCY+Tjp6dMXi+dVmUf6pHOtOdNe5Waaq93t6Cw1k7uSk1fz3IVaAruPzn6ndtn141J8SsYt2hu/qGHNFTmfvhm2zfpjFmZN0e09oGOTMl7R77XKdvg7oaykSXH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 Aug 2025 22:44:19 PDT (-0700), thomas.weissschuh@linutronix.de wrote:
> These constants are useful for cross-platform userspace, for example to
> process ELF files during kernel cross-compilation.
>
> Move them from the kernel-private architecture-specific header to the UAPI.
>
> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
> ---
>  arch/riscv/include/uapi/asm/elf.h | 66 ---------------------------------------
>  include/uapi/linux/elf-r.h        | 66 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+), 66 deletions(-)

Acked-by: Palmer Dabbelt <palmer@dabbelt.com>

I'm going to assume you want to take these all together though some 
other tree, thanks!

