Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 051E7CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F2D6B0096; Mon, 12 Oct 2026 14:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20546B0098; Mon, 12 Oct 2026 14:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5CC66B0099; Mon, 12 Oct 2026 14:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B25656B0096
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:06:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F5A312116E
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:06:19 +0000 (UTC)
X-FDA: 85314753678.25.421512B
Received: from out203-205-221-155.mail.qq.com (out203-205-221-155.mail.qq.com [203.205.221.155])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3BF73180006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:06:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=EvVq0Fsl;
	spf=pass (imf16.hostedemail.com: domain of yangguikun19@qq.com designates 203.205.221.155 as permitted sender) smtp.mailfrom=yangguikun19@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791828377;
	b=xM4vvG8KTSDrvjSdvIybnnofZEbugYza5YR2Ts4+hdBfXXyBYqU4p1CVKnZsR5K27rrTUW
	4TtfvP5dP3iGyYzSmYIA9oe/GYrkslsZK7JoB8R2qXfMuswCKDMAY4FUxORp/CsOkC9CXH
	LynPShW4bkfvo5afoPHPHL+PVCT7BOk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=EvVq0Fsl;
	spf=pass (imf16.hostedemail.com: domain of yangguikun19@qq.com designates 203.205.221.155 as permitted sender) smtp.mailfrom=yangguikun19@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791828377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3o+jyBzU8mUCpYQMWos+tP8nlAQxD+SpC0ny4cPJcho=;
	b=bMMnvAxXJgF1wkDNZHscjUEzg7OuTFv6hmCiMmHEcg9fqV0XhA1MD076LLrnGQ/myTh0H9
	Dxmaunq9joSbzZaY2267K0s1Dg6bgzE1mq5L2M59mdRGA1Ftqar6EMdee2NTzk+1706G7f
	jiMl4sVLJ3n1aAxZFA3H0ygwcGFhVpg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1791828372; bh=3o+jyBzU8mUCpYQMWos+tP8nlAQxD+SpC0ny4cPJcho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvVq0FsloWi7LjgQqrHfazfsaDf4yXdZtMXZn3XcjKBpqvJrU0lDEcC/pFGTZy8zO
	 Bgx8/AbFckAmld1pHdBQqG/33bcjRmOeAMdvPuVCmfGN3DoAxA7gPjQgb1Zx1EXiD9
	 LVnINAJRZEsORoCqWylWx5EDLynV9Vyiy+D9C+RA=
Received: from [172.18.4.77] ([61.136.26.103])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 189216DA; Tue, 13 Oct 2026 02:06:09 +0800
X-QQ-mid: xmsmtpt1791828369t8rr3nzkm
Message-ID: <tencent_8BA9ABDFF623474ECBA6E251A03E19512808@qq.com>
X-QQ-XMAILINFO: MllZffuBkEb5qsDaqL1yrE9sioqSRvvmsmxEYgeqPtOtTuQIV77Ol2/tMKnTGb
	 zMLhzMvOq5NQJgwurpi8mNOMXQnZin58JABsqGjrOO7J8vwySJMUErOH4rIkOJwrUy02Ro98cG0r
	 hbrXZt8J7fPWB4PjfokCnjuzSMg0SAfbZs/pRwroJoTj1VR4BmuPcZXrk9dfth7AYpwvPCCal9Fu
	 akkIEw898yZ6Q1cpYmBTL13gVCdRxpfaaaQ/xY7QmQiUshhWFv+Um5AfqRtBo39JSKQpCmB92Ru2
	 S3XeDEbgvNv33cTzOrNso17pCXFNBKpZMJO0qtK/7hprK74sfcaHhfv8wJftJ7UB99wFz2aw5AeM
	 kdEgSPe/4EpL9tZlG4Oz8XWyPCSP4K8lGOy3lxYtPEanrNND+fjwFU9IxHP/ZsMS4aKqVFyhaxXD
	 oMcIVrSjs6RxqoHgSl/F4groL6qMITtT2z9eDhy18rukGmwsqV/50/+pLVCIhQJveWpAIX7DqdKj
	 h9UoiEeH/S2UtdcqbjhNLbSnQBCZ34gYhuy8AnGXEVcAZyf/iXMaPLq/Ug0TtmAs62Imi8X5a3dv
	 YdysLybs6VfOgF0VbPJqLaGrteNUM1FgOMF7tY72YFEzBSeAiTvtokPk/E3RCFj6tOjWxCgRXtOQ
	 8LKIAWE7JcpMB9lnt4VvhhgvkBZZkMCHZgTz6lAFB3s6zG0O9DNQpyNlHikF23jhBcVYsDqGsNY/
	 8pAlW5p/y67P9DBYAAJG7FhyQ6JgyoYm9/TRHQDPKOzGyJ7KP3rtrRejNVUCNXItjI+81nd8VaCG
	 IsVQGvLaFZElMdSh/i5iOxHDpUGsVVoOlAI0HO7+Xd0gG0jiUGIYm3kMEWUXZskoKjg7ApvkohXX
	 8J9shg5F3LRX8GnHi43JVEFoNO5U+mhmJEfxCTZrS2KNKpnTmCRVbx9YtNKcApHpuNqc/qssC/HT
	 eiqxaMD3GTKtIi1VTzYC/TzDrZ43HidT5aNFMlrrWnb/gy+tTpCCtUYxOTVDuw2P6bhd/xLiiUa7
	 bWPFjuUz/aNvG/JUi/4Ak0etlQ6gyK6+apTj9cOw==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: 1sh1ro <yangguikun19@qq.com>
To: Ihor Solodrai <ihor.solodrai@linux.dev>,
 Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@kernel.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86 under 5-level paging
Date: Tue, 13 Oct 2026 02:06:08 +0800
X-OQ-MSGID: <20261013020608.44976-kasan-fp-5level@yangguikun19.qq.com>
In-Reply-To: <20260624234510.GHajxsBgG62PHgEZa4@fat_crate.local>
References: <20260624234510.GHajxsBgG62PHgEZa4@fat_crate.local> <20261013015904.44144-kasan-early-boot@yangguikun19.qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3BF73180006
X-Rspam-User: 
X-Stat-Signature: w1j8qep5mdnst4ycougt85mp5mq5zjzw
X-HE-Tag: 1791828375-570113
X-HE-Meta: U2FsdGVkX19gUcBaa1IgiO7LnSwSpZlcAtb265bQZvC8+lixSffuXtkwA2Gl0YkwNUPUgVaokv5UDD2WcEfYoc8EgHQmjnOoEoVB/V86cjm0HjFshATLX/SHiyKb748HiA7IO8wkBkdinGJ2qBaDl0tkbCkV3CAtxRlyHaZD5Fm7+hFkDdBhgAestyGXtNfPOx0WN1jYGgXGWdYDyqPVHxXhT3trpxnh7pLpjQA5bqZdkieEwm/ZgWFy/3duGqv7YeHC33wRuFpg5c+L1PPm7+XOmag6PbYrPr4VsAAok2eubO0Ed2bxcS4iiXOI+3+xtnHdKSN4lk1MXhNzEcy0He5g0rf6SrXlMo3YPSYvQ8POyc848vmgdfK4OwL/HfcRPOjfF91M/oi9Lv8lOUAvk3SHXxll3Gd1shPpf8dA8t+6V/bXUIR0P1WrhWQzr+6x/mj+3q5RLawOnURP/oxwYT9YS6J9WHw9Mh1BxIQXGGgp4E1D9zQYuuzvbuu37NUsmDiYqsIyAegYQNkl1E0accxS/qxD1RrzwLPAt8GmoWTU2tWIo2suP2YsA1ZAFjwnSxO+JHX8Iy7FPTTDW7cgVTEIY1ncNGyCFggacB4MEEF+3ClhYb/U+sgsw6qKnbVRRRrOtaIN52SYU8jyiQKx4OCL12JURXqBZ+IHABCLVDkusKrw41y0umsvVfHQODuaD4Gx78NQ4W+6MfXILhHI7F/HiGaVHA1ee9nacfi8Z/v4uwbacefLbRxO99a7AHXcu8zGAJVVOhfHoUmWkRPddgqSNR0/98DtLqCtrboHcfMpLVcJGeYaNYDxk+hBnBNAYFH2IqLJMA1+OMsAuMsCApFDCkLafgD0t9IWgqthg+/leAiREg5TrL0CQGnP2PfV3SLu5dVX7TEsbE4rsvaJdGmzpBLLMhsx/+L4yCWZZu/Czg9MR0BdD9fw7RPEp+mXuGQGafdKNV/3izPSW6S
 epQLaeps
 cNJVez15y7BzgmDyStuVE6mvTkK6MOcZ07mvzQdr61sQh88wlDCsvmzlAmpFNOQKbNIvx0Yv68Q1gtkAEa16pjPale/Uqjc0BrggukgywQjD0K2++xw6etlKjWiiiiosZ+n1GIT1cH66odb/o0RviPTLQydkkqOl9znd72wDpei1MA/4t2A+gvLZx4L0ADDDDWaCq7+uqhumkjoeszbaY5TPXMONxg2lA1rWEw++eGMXFbKKPCx+gBrEkse5BzJimQh5FO4MF3M0Q58lzFHIwLo4Qz23n4ftkwRXpypVJb8UveWOHKmKDoSitvbOXrfKky9I+KY5k8EJKZ+74sar/J+r15sAaKabv1hf9d20dJA31sLNJ/l+KmQu85Iaj6x8apCf4bOYzFl0X/eg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I hit the same false positive and can add a data point that seems relevant for
the fix: it still reproduces on 7.3-rc5, i.e. after the CPUID rewrite that was
expected to take care of it.  The rewrite is in 7.3 -- get_cpu_cap() became
cpu_detect() -- and that is exactly the function my crashes interrupt.

Two occurrences, two kernels:

7.2.0-rc5:
  BUG: KASAN: wild-memory-access in do_raw_spin_lock+0x11c/0x270
  Write of size 4 at addr ff110000158860a8 by task swapper/0/0
   <IRQ> kasan_check_range; do_raw_spin_lock; handle_edge_irq+0x2e;
         __common_interrupt; common_interrupt
   RIP: get_cpu_cap+0x12f/0xc10
        identify_cpu+0x2f9  <- arch_cpu_finalize_init+0x58 <- start_kernel+0x373

7.3.0-rc5:
  BUG: KASAN: wild-memory-access in _raw_spin_lock+0x71/0xe0
  Write of size 4 at addr ff110000010ca8a8 by task swapper/0/0
   <IRQ> kasan_check_range; _raw_spin_lock; handle_edge_irq+0x2e;
         __common_interrupt; common_interrupt
   RIP: cpu_detect+0x20a/0x470
        identify_cpu+0x2df  <- arch_cpu_finalize_init+0x25 <- start_kernel+0x39c

The 5-level hypothesis matches what I measured on the 7.2-rc5 kernel:
page_offset_base is ff11000000000000, so the faulting address is physical
0x158860a8; /proc/iomem puts that immediately past the kernel image (Kernel bss
ends at 0x15577fff) and /proc/kpageflags reports SLAB for that PFN -- an
ordinary early-boot slab page (most likely the irq_desc itself), and KASAN
prints no "belongs to the object/cache" section for it.  So I agree this is a
false positive rather than a genuinely wild access.

Impact, in case it helps argue for the stable one-liner Borislav mentioned:
with panic_on_warn=1 (the syzkaller/syzbot default) this panics the booting
kernel, so fuzzing VMs fail to start; I currently work around it by booting
with panic_on_warn=0, which also loses real warnings.

Rate: rare and load-dependent -- 0 hits in 60 clean boots, but the fuzzer
(under load) saw it about 3 times in two weeks, so it is reproducible with
patience.

I filed it as <20261013015904.44144-kasan-early-boot@yangguikun19.qq.com> (both splats included) before finding this
thread.

Thanks,
1sh1ro


