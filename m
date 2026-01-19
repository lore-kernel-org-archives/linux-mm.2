Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88463D29C59
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 18:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DD116B02AB; Mon, 19 Jan 2026 13:29:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4A86B02AD; Mon, 19 Jan 2026 13:29:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B34B6B02AF; Mon, 19 Jan 2026 13:29:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35BC96B02AB
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 13:29:14 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABB7C139D23
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:29:13 +0000 (UTC)
X-FDA: 84349550586.25.619941D
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id BB56CC000F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:29:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m17+Y9R1;
	spf=pass (imf28.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768847351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSQyY/sbw+WW+mdZ495+fmp7dM6Z9X4lGB7EkpPTED8=;
	b=zIs6q/tUubPCfvXmovflrY7zpniLFKmxwlYicvpJT/7nJvfld/OZciFTZndP6Z8kVwA3zn
	yJaeZ4qA7IgGQIaF/wIJPtYCV5N/6kj8CrtxW5hIFlYHrvkd8SktVa9WjYEKz1MKgZzb6x
	eHapkKYPieCjYfkfKhxU/Xwownruceg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m17+Y9R1;
	spf=pass (imf28.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768847351; a=rsa-sha256;
	cv=none;
	b=C8qkneWLztJSqw+aM9IJxCdIPT4qpx4fUgzfuLqZwG7/1UDyUfRf2xVujfJLIx6imXjngh
	mp5YhCwmCzIWBN2PRuOVvOO1u1IgzmKyVy/SiaJnq/jUKuxxjIlvrKLVX+9/MKT+KTKaNT
	J6Ur7KFrKNwi4XsBptYIrqbIa6GCHxA=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47ee47ff24aso2710355e9.1
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768847350; x=1769452150; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vSQyY/sbw+WW+mdZ495+fmp7dM6Z9X4lGB7EkpPTED8=;
        b=m17+Y9R1XQ7org0lwV19wHQLtmQzBXmRfr7sNbd2AJDVu8yGzB1cVSa5tfT5NmMIq7
         W6jeL8YLotV5Zux4NT2YQmNtljjpd3EJkRV/Hx3JfFOFX3XrHVIxDWnYNo7v2ZVUQrqu
         V2mkWEFP0SN9ADCJLD85Us2XEfPmnNvSGcGjud9JOro8gl+on3CfrfVDvWKvmvdhjmhG
         cTI+IeW84A3+iwg7s0zHqPiOnmOy77lPxuahonJa1TSrlU808P7K98nSpy5H/jjq7swr
         3+JecWPWMCRuaeGrnKQveZ7RdvajZpYpHUC59XLxzrXlsB6sFL3KdlEX1NXeNbZreElR
         M7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768847350; x=1769452150;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vSQyY/sbw+WW+mdZ495+fmp7dM6Z9X4lGB7EkpPTED8=;
        b=UmKxLDhBfhEPWy9Lna9pOxBInB92IigOuvGu7Py7f0VnwUVUYtdl/yB7zN73NIpRlw
         XdtpFhw2lsxm161GBAw4Kqu+TSnPTY4UzAXF4WwUVbstMGWwdQexKqdbjwHIDwaHwcaX
         KOugEb1rh1hr4EQFzUZu7lI4WcwuJ/D13pLRI7YL7aWSAh57AhvfSbgbh/110LdjaF1Y
         xGClGMRrlL/y7a1CDsc7+J9me/sJRhhPd21meEHd8srgtvLkKoDZhpunpn854oZRjiVm
         5KJ5AuBrb5Pmgj0gsV2y0/aty2IcIU9kwHUDTosKxzjN9cDIKGzAiOCo1ge+xP2rNytn
         nKiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvdZIZqgGeNUwndG4L2lGS9EWnjXKGSocJqjAo6utvnuQXYxOmCzsjwxjdhmp8GayFEpCh7UHWgw==@kvack.org
X-Gm-Message-State: AOJu0Yy+G4ZmNzP0VUsAcWG4PmZIKGX4dR2DH3gtAl1ufIDqIiiJVJwQ
	w3Ro6XNzOpL52gbU8ZNbuBLzLKBLxsgct8oCqnIRxPaQ2Yfiefb2q1Qu
X-Gm-Gg: AZuq6aIaXk1/TXxVKghCsQIjj4KSjgfcFU7djJzY6XjGNQKVQ+41Wqrpl24UrJwnc2X
	FG6jOQUi3c9sECIzFmoR/aEfQ3BQ6sljJBe+kTih/+frMSSpy3dCizqKL8n8FSxnntXBdVtEgpH
	ndKfHvbOKNcPhwGUfYy5KCkY+gFtep9aVswuZg/WESPi2kuluFgdu0siVekc1IXou1sCiCodlEy
	vNpRWbTNTwJaEUTBHygYBVugc2Ku2WYffFVYNceUkgadyRTmh4Ijbecnm2uBjzj0tAnfxVqV5ge
	1vA5nOsteS+5HuptA4LhwPkKDJFf9lXL+r8LOLgzxoVEgjbhR7l39b9dDmiLobIfVcwCnFo1Vxz
	klJ2THI3eLXkPAfB4OkaS0SIaMpUdoEeR3P+SACP64h0ohtJY64l5mINbnwDXakwbLVXCZgOsYn
	v8Wwm8236vVsNHcEMmvg==
X-Received: by 2002:a05:6512:340e:b0:59d:c490:3ab9 with SMTP id 2adb3069b0e04-59dc4903b42mr330960e87.0.1768840488602;
        Mon, 19 Jan 2026 08:34:48 -0800 (PST)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59baf3a6ff6sm3432421e87.102.2026.01.19.08.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 08:34:47 -0800 (PST)
Message-ID: <e273571e-ab8f-46d6-a44e-c1d0d06d3cbf@gmail.com>
Date: Mon, 19 Jan 2026 17:33:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/14] kasan: x86: arm64: KASAN tag-based mode for x86
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, corbet@lwn.net,
 morbo@google.com, rppt@kernel.org, lorenzo.stoakes@oracle.com,
 ubizjak@gmail.com, mingo@redhat.com, vincenzo.frascino@arm.com,
 maciej.wieczor-retman@intel.com, maz@kernel.org, catalin.marinas@arm.com,
 yeoreum.yun@arm.com, will@kernel.org, jackmanb@google.com,
 samuel.holland@sifive.com, glider@google.com, osandov@fb.com,
 nsc@kernel.org, luto@kernel.org, jpoimboe@kernel.org,
 akpm@linux-foundation.org, Liam.Howlett@oracle.com, kees@kernel.org,
 jan.kiszka@siemens.com, thomas.lendacky@amd.com, jeremy.linton@arm.com,
 dvyukov@google.com, axelrasmussen@google.com, leitao@debian.org,
 bigeasy@linutronix.de, peterz@infradead.org, mark.rutland@arm.com,
 urezki@gmail.com, brgerst@gmail.com, hpa@zytor.com, mhocko@suse.com,
 andreyknvl@gmail.com, weixugc@google.com, kbingham@kernel.org,
 vbabka@suse.cz, nathan@kernel.org, trintaeoitogc@gmail.com,
 samitolvanen@google.com, tglx@kernel.org, thuth@redhat.com,
 surenb@google.com, anshuman.khandual@arm.com, smostafa@google.com,
 yuanchu@google.com, ada.coupriediaz@arm.com, dave.hansen@linux.intel.com,
 kas@kernel.org, nick.desaulniers+lkml@gmail.com, david@kernel.org,
 bp@alien8.de, ardb@kernel.org, justinstitt@google.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com, llvm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kbuild@vger.kernel.org, x86@kernel.org
References: <cover.1768233085.git.m.wieczorretman@pm.me>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <cover.1768233085.git.m.wieczorretman@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BB56CC000F
X-Stat-Signature: gonnxj3rfjifugsoejn8uwu7ehr9a7mn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768847351-593114
X-HE-Meta: U2FsdGVkX182l677jmsNOwWCC6VBUq5KnU5VYdbU287CQGADMNg1wdnBz/0EgsKxSwHk7OLk4tUG4WAOF61srjelkPp8mfQo0SG5ZN+V1qyrgoDQOKwNOCkCZA7iN9GqkzZgeB+kZZ4d4wdEQG5wiKgzrmhb/Dn5NDEm/7vvENKGmCH9JC+BTB/cl2q6jH+4w1+tW8LqgFhBxS57MmvZYjl4hyTC3d3tkshm1bd2Oz5WK0+/dgr7QngaCB+jb5zP87YNn0tCl4XfAYlDrtJe1lev8SAus0WJ5AlreXbPfIFPXfjAZLkQY9nCvrIfK+dVM3pAhczjhPa8efgyAnFQ4hbWiZf65mjGQBdmMSZheu3Ca2O/CuAaiK5R74yLLggawmbiqvoYQoEchY1ROgbNrHOKvO2DSLPs42CdwZsPPdQiMWEi5fcSbddmOzujOAvlQND2G6PwFhhHeInyxFg+IJRqjG5F1k19Q/ikE4cA8oR/x3q4zcrpbntg0HMjbvUVcMIGied/piJZmEoxjKEFeOUOwikozVO4IidiAZHLxlAS0Jd24zm1Q0ose4RtACZN3us/Fn1ZFg5dAIovNwxC6KcjgehnkXuPoAAJAnaBeCGPm5/ksdNvIy1P/c0O3aNuuK8w/T4/kll54Fcutl3JcNo31f+xT8WHweI7g+aMQcW/kzenPexOMLVtsNEH4MeIP5GT4UEd8deW22UZ2zNmPo+Mxww8Z4iy0MFcvyu8yXUC38U1HJ0WxHx827oZQXPSwT9MUWQapf+1Qt70wr6u8HKnndS/7VuiJV/VbvQJIZGmRfzuLcRLlInGJJrDe1NPSXI3T3ufqhqpwZ+UrfYmixPZoSTSLd5YpMmJ6Vc6TjzzsOpSY/TYF98/jxJW/DqLC0/xZlxWamYn2ytELS4Fu7KVZZvClscRELv3wU5nMBmKO2qT/ieN7hNT0lpq14xL7AOGpv/c2hLO8QYpKlA
 AAytazPX
 lenp7y++FjyGZ6mj8YqCfld4PjLW/90Vmc5mwjzT4Fz35pXPWmFl25oE6N1HZz09osNWQqtg9nOGI9Ew8J1jmp5/oag456Zsdsa7oF+j2Z0RXBqvH7PD3gZBEp7e5IHw1YeRELB0o7RTpnUlfCExqtRsNj5Qm2Dfu+9RoigwTiD3CP9cxdkFW42yNMbXSphM5BltYxDZrGQXaFiRBcmI/mJP3DFWvxMRJU2kOFuC0dtBAW/L4l4FMz1fkq/bzCp+t9M3U+LYhAffDpGZJfKJw3SyuBGQkstgnO+fkEdVaYttWzqtJ53r5WkdXQj5AT0T46/Yp1w5qf/p9RNY7ZDv7Ja2tOJxX0KDNVjepozIwUk33LiT+N5XXlRrq/YmYqmtLdWIx3s8ySmB2fXqAFCtbNc4b/kypnnjA2n8AmTkY268CE7JR8rXWizdYu50xVHkUc03KjRoE6oO6PEUzMT7IEDik7HP4zd5jwpzFyZF5SM0wX94EZOoQUm5vNRmThG57QwjbCDeHd03PJc+SijQx3E7IYbi4EIjfClKgb7AjlmrQ/T7QMy/wGef2iOhu5wZfTkrOfs10A9s4L8UsxXyRxIFNDouysPm96E6mphk4L2TghmsF07n2LNDpbZo1b//x7d0owCXZsMbs2oR0Cn80BK0HsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/12/26 6:26 PM, Maciej Wieczor-Retman wrote:

> ======= Compilation
> Clang was used to compile the series (make LLVM=1) since gcc doesn't
> seem to have support for KASAN tag-based compiler instrumentation on
> x86.
> 


It appears that GCC nominally supports this, but in practice it does not work.
Here is a minimal reproducer: https://godbolt.org/z/s85e11T5r

As far as I understand, calling a function through a tagged pointer is not
supported by the hardware, so GCC attempts to clear the tag before the call.
This behavior seems to be inherited from the userspace implementation of HWASan (-fsanitize=hwaddress).

I have filed a GCC bug report: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=123696

For the kernel, we probably do not want this masking at all, as effectively 99.9–100%
of function pointer calls are expected to be untagged anyway.

Clang does not appear to do this, not even for userspace.

