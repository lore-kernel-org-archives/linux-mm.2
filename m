Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EDAC87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 17:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7F416B009D; Fri,  8 Aug 2025 13:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D570B6B009E; Fri,  8 Aug 2025 13:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6CF16B009F; Fri,  8 Aug 2025 13:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B666C6B009D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:20:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D620115C9F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:20:25 +0000 (UTC)
X-FDA: 83754254010.21.F78FB41
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9A87F4000A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:20:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Pt7orO2+;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754673623; a=rsa-sha256;
	cv=none;
	b=1X/Q9pxqHmv4XtzTBnkk/s1U1PtA7dD1T01p/AYV6/28Vs9NEiOd10+wMuselrnY2MGHEt
	Du5gK2PPmkpjkusBL5de2CjrTaaEBud/oqfIAqbmKmtM7J7U8NCDRPtspSMk9nTC+JTke3
	N/0nEtVe2q07iZNENfV9iCRfpX1PU4o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Pt7orO2+;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754673623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5KtmNZscqY46KvhQCHs24ev6RrXWd+1XTPfyk6qu6o=;
	b=igoLMbsMrZqGrf3f5xCLPMiRQaawc85ADxbXQo2eRvR7kuA5MUZViuCd9xDuI0LtV/JR/H
	cfXn/JTl4JM58lemjtUyRXkP937fSlF7jKfTGUD32gMLxZElM4s7jYjCxQil5Zv06sceGM
	SEX+SmljvUuhebGzIe8cezILSxiyWrw=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-76bdce2ee10so2156998b3a.2
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 10:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1754673622; x=1755278422; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e5KtmNZscqY46KvhQCHs24ev6RrXWd+1XTPfyk6qu6o=;
        b=Pt7orO2+DTz8LkdiHLIrruqQ2kZuvgSnK0Z8T35dlrUYm5jq1AJ8vBhxT++FMI3dEz
         u+TY0FRO8+3pfrAkEoVu592gl6fhctdGUc3vUBn71J4kGDnHDNJ1WcBeLMOOg+QovRGz
         SFs8bsYakON7mzjnTJ5GOYXtTy49OqgPlOvbEgpzxD9x/DgX9853s5hfDLk5tyLrffcX
         kdhRItJJn3jE+euVuchBtzolAt/ud6zHxbW5M6csdHCzv2gSr5nyK3IU6rJ4HASGVEmP
         P89Z31qnb/ya+cZX6i3X2PLCzl/JbJoHoHX74dMkCcXRpCjThsDCKG8Bk+QU9NxnNC//
         Gklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754673622; x=1755278422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5KtmNZscqY46KvhQCHs24ev6RrXWd+1XTPfyk6qu6o=;
        b=xU9HBiCFHQzZFWVJrwXPfQM/t5wQLaQ+jAToZ8MR9LPrwMhMwSl3x3utMKyRmYCMZl
         DDuOm5mHQYHN04y0PF6Q2fBwR+FWKG1PZoYoIx1S7YtqBIslGwTk2QzhiVM93wBF7qOl
         hqD4iw7GhZXjXBw4gIeb88aXpEhpV5XMbx1qKt0KJcR3ABYDUvtULLqsArZznBZIoJ8w
         eCNHpKJSD4MPr4+HWBTmEVmg3UzkbdzUV+WgVkoMmPiG4O8JFCmJyl6OGtET0scc5Mq3
         YLbKlDJ06bWzJwFKJGWxHT9A18Smk59y2/5OWAycMRnzRz8dZqfIZR05pg9PBYvfFf84
         dlCg==
X-Forwarded-Encrypted: i=1; AJvYcCXmS4Yu2ImqZ+T86saVWmUCtgixd8uC2gspiy3DKM/TpF5i+Xla+tzpFSjN802Q9P0jxlCWKClR3Q==@kvack.org
X-Gm-Message-State: AOJu0YxqXeUlN2CSZB/c+pwVrPEWCCJsu4LusRrP8ga0zvMhmv6Y7PRa
	z4iT7okbCp6mMNeFhkj9GnUdwki9rFw4T5+SIJTXfm599GXjvph45hCPjO/qsdSum3s=
X-Gm-Gg: ASbGncvu8AcEGndl0PSBwPTUJvZMBLm5UOI+MfY42mNZWrotFHJEE2BRYRQBWSszQmR
	gakUKP6TEP6O9uh+GSevFboCSu047JCYg/B0aDe363R6D0hDVL/aBY3eDF+Nvj0ZGx5nOMCj9YA
	bg93aCkIW/qCz3hP8bI749bLXTwNV5IVz5srpZxwOv8voquCw27MYtRf2oOoXGKj2tfWIig5X3b
	KfN0El8njFIez5mribyHHwZaXCAUuBTXMlTd5BXC1ksO2FTPs+1SFtdfa5CV8h06XTXPBKNLfB1
	BzDbKBpgW+9+DqubnklOEY6hXJ32D0LQEpFy5i6iZRBUg/rwyx2xc4DtHmkEZ0/CoQZOwelO3Gp
	5P7i/9GvsLHt+yhdleD+saJLrbSS93M/ZjDAb+xib6HA=
X-Google-Smtp-Source: AGHT+IEbXOfCcMMF+EKLeMi8xU3SNI8Lg4qkWBu83GI5zB4sNqf//XXj2WJssysLa22zlDPxSEkl6g==
X-Received: by 2002:a17:902:da82:b0:240:c678:c1ee with SMTP id d9443c01a7336-242c1ffb211mr57743355ad.11.1754673622272;
        Fri, 08 Aug 2025 10:20:22 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8aafa77sm213263625ad.174.2025.08.08.10.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 10:20:21 -0700 (PDT)
Date: Fri, 8 Aug 2025 10:20:17 -0700
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
Message-ID: <aJYx0Yi3rQcdY6se@debug.ba.rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
 <175450053775.2863135.11568399057706626223.git-patchwork-notify@kernel.org>
 <db4eb976-693c-426c-a867-66cadd3dd7d8@sirena.org.uk>
 <aJWz82F21pVTSVJi@debug.ba.rivosinc.com>
 <09081487-89ac-4f8d-b9fc-e563f09726d2@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <09081487-89ac-4f8d-b9fc-e563f09726d2@sirena.org.uk>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9A87F4000A
X-Stat-Signature: tza1k9u9wd313a7mfxjczxjaf3fko9h9
X-Rspam-User: 
X-HE-Tag: 1754673623-355228
X-HE-Meta: U2FsdGVkX18ZSdk8uv+gaPXnYb7CiRA5LNNk82cbbgmBz+nGvVP6i1/+5C+BbQVce3V09IjjT9YMHACbNvIyuJitZNVWvFaEOFD9jO+/I0UvZNPzthRxlht6NJAuy7/r1tV2RBlw25E5AXqPhLUfqimlDVOh+40hMaDpz2QtE92o3a9WXbjzyFjCMBcgn8g6N+9oUAn6c6QM7sZjLN6/2oDhAmx9zELPWy6K33NGaHnl8+fbDmt8B22bykW0cIMsuemBD+avLy1yrx3UGPx9XTxpzl/7QKIIrRWHRYJWTLchcBDAiQ2M2paJamnPlfuh1xVSkYpY3Z6LBS023Wh1Y2tL08dGjfa9507OgYPr7tKz65RhBCRBLbByUctV0Gn3ImqV77UPsgM6HEw4JHv4C1NSe48eK6yZ+V8v2uaphRHnOFc3ovr05+EpH5BitJRsawJkwsyULtkEz1fRqC60A0sJbHbx90W8aFk1ymAfaTj8dNGE3qg9LBhPwi3Ch3bwOGNEYXoEXzQot1u5r4CQMJS3HoMx9zGoowfGgQuktgoHOr+IqlwyNZc5zaz2evq1B4tnwJ3GiSgp3A3BJwiRGYr5Tu6MMqhU0aoIfelpoqeGwc3GS8lb1HzPWhi39yqm87to4eVW/6j0mn5pxXHFvhDN0pbpi7+cqc3qNj5cL+yCX8frctYVH1QVPCsWwSVg0nJwUM/GLIXedBMB0CLKZupHoYBRYi+9g9LlujGtb4c2Io+rkW2nU4vZni2VqL5afh9TSkhciP/1MmsnVRgaUSU0GgGOEl16xYj+Cvy75X2IJaFzM731iOQdwKpKCEj3VqAXwv1mgSL7ZH4VCscG5sG5Dt+MFn6lYlWUCLnP5NTSLgQoLNo5MyHYj7bMCMmsdST1x4txzQQRmSDZQDwdgHrVM4UrmJlNAhqaH5N2fbRlrq/aR3EcgzUVcFPwbCnYxHYaPRN8lfxqDnCkVo4
 R2KL6Ph4
 GlXI92WldCdM594kgGoHmi6YOjBM/mVn2g6MyJUL7IQ3D0sMrA4qbPJAyF5hkW9ve8DFvzQkLXPebAjdZpBptfrrnCK9uSEjoK3LL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 12:48:31PM +0100, Mark Brown wrote:
>On Fri, Aug 08, 2025 at 01:23:15AM -0700, Deepak Gupta wrote:
>> On Thu, Aug 07, 2025 at 01:28:36PM +0100, Mark Brown wrote:
>
>> > Do you have an update for my clone3() shadow
>
>> No I don't.
>
>> > stack series that I could roll in for when I repost that after the merge
>> > window, and/or instructions for how to run this stuff for RISC-V on some
>> > emulated platform?
>
>> I would want to write-up instructions. But I don't want you to go through
>> a lot of hassle of building toolchain and bunch of other stuff.
>> Let me see how I can make it easy for you. Will report back.
>
>Thanks.  FWIW I should already be sorted for the kernel build, unless
>there's a super new or specialist toolchain required for this feature

Unlike x86 shadow stack and arm's GCS, push on RISC-V shadow stack is done
using dedicated `sspush` instruction and pop is done using instruction
`sspopchk`. RISC-V vDSO has certain `C` files and they would need shadow stack
push and pop (along with landing pad on them). So that's why kernel compile
would require the toolchain. I'll point you to it.

>(I'd guess I should be fine for the shadow stacks bit?) - it's userspace
>and emulation for the extension I'm missing.

Qemu changes are upstream. I'll provide the command line option.
On userspace, I'll point you to something pre-compiled rootfs.



