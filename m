Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB171CA1002
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 17:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B6F8E000A; Sat,  6 Sep 2025 13:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB768E0002; Sat,  6 Sep 2025 13:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383808E000A; Sat,  6 Sep 2025 13:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1028E0002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:19:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB3E6C053C
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:19:47 +0000 (UTC)
X-FDA: 83859487614.16.DE3FED4
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id E607940004
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:19:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FII4pr95;
	spf=pass (imf27.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757179186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJMKKvsr9aBhw2LBExeW27+96C2S4i1wtwzuhhQgIDI=;
	b=uR2J0j6qKb7OX/jCSSJZRV+552oIfxUV/JbCX/ChuvUqdtSJGXj0GRAczQBQTnhpNR0e/3
	CN0EfRQHjXpo3BAPscCxoLAvAUSh7lPecyX1EBbn/X3hen7g7X4odi1ODlA+/jnI9ZJfrd
	+eEXMT+UtnbktEIMCueJa6Hf83GkPok=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FII4pr95;
	spf=pass (imf27.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757179186; a=rsa-sha256;
	cv=none;
	b=zSO8lC3wPoOrznAIecKx1W7lJShW2NogETlN40oFwYOcjEN1AmuHk8UnPLEMpblUM6tR2E
	bVL8uOWPQWfQooxz/PpDiqiurDPq2m7I/siVcN/qajxIKtcgfSxtfPSY4LYDLyfWzdNIEO
	pjiDuu8neHp/XX1k4RM1C2UyjlCNY0I=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3df3be0e098so1642853f8f.1
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 10:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757179184; x=1757783984; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eJMKKvsr9aBhw2LBExeW27+96C2S4i1wtwzuhhQgIDI=;
        b=FII4pr95en9d4bfRj8UUIDfhKMp/xw5l0xnzdus6ZX/KeDvhT/yni4JAZW2nb0S0Gm
         7gIYB1pSSLDbh7Dr7MMGz9gBdiDlNHN/mnsluPz6eJTdEcwHYzF6rhQM8bnqsW+8rXUn
         92yXVdnuU4NVs4BNz/VwqFNM6eog5MANRp2rnjYAKXgLDt/xJLzW8Sq3FQ2ijOCuvlDk
         c8xJAzr3U7/WhJglD+j4QCNgwEvLmxXFpOE1mrqdx2FTmGJKyIB0gyjXmG/0g6zTvvNN
         /RX4OKDG65E6WDSLdATlR5vjt0nUgHwdbs97AcPmwFC1oLw1zfP6tP/DrYtngCatusx7
         WAcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757179184; x=1757783984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eJMKKvsr9aBhw2LBExeW27+96C2S4i1wtwzuhhQgIDI=;
        b=dW36uhWxO3229OlUjPd7EmtlMY2Qst3rmQ9mk3q/KVxdDPHQCyH/5KZCBgofjFVNz2
         +5dr6g8lsD9bLD3N8tp7GS2DaoLx5pP+4qGDJDydg87awv87tx4OgKTl6AGfYY2Gm1r1
         dCI/vmqMC+SztdCnovpaQ2R1iO2vCwOqT1L674HDDYeXUpv9CAJnhjQ5K0etTQXpG7kS
         T3g3JfphURZsa1lpcNBtaamTba1pQghoJpKRdyd1vgOp0xwCsXPyepvdR7TwC7MB3KxI
         0FtNT7k/sDW1bxUn/DWL3DQRi46DPwK76QjyDASnDgppbyVx2Bmw/B1I828OnAtydRna
         cN/g==
X-Forwarded-Encrypted: i=1; AJvYcCW5wAzJBSpOA8TVluvYgK6mqKZQsNSxE8rhVYqa+UJD/EstV9GZtTRzsr5P9uRtjjz4d+TqrOkLRw==@kvack.org
X-Gm-Message-State: AOJu0Yw7gp4SB6fRowW+LMFV85wuK49e8fSSquYlfn6qKmxT4hDpCSOq
	fFs3COW5YJpRZGsp9Wg5vjapbD/dFoFTHmfIOH8ArpmpSBp8QPu0rNwA9UHAmHCIvfnSb41MEEa
	I6lqkK+KDCKwFsmj1cE/29MdGhD5GY6s=
X-Gm-Gg: ASbGncuxIkwHwfsouDQ2qD3IklPY6czCS7Cu7h90LveUW/dCzervfM0DvXPF1nqDGSZ
	K2ln6e1Aa3NtzEiAUjz7NoQqZw8k4JvrdWGsK4VcqbW1xbjJadqijjDlSsKNbFo1IC/F1B7cS+C
	9sQf/cnQkTXVpwX0o4DgeR38aBTuKY/kZGOrNd9hdrJ+xGd9eVWNldDZWvPGomEqKICACU91ZKf
	7ddcuQF
X-Google-Smtp-Source: AGHT+IEt1QBffRC3qCjFQkegXvZucxYLutWCtmj14Ka9sbWhzeDhlKSUm/6Exox7rMe+GxRha+OpSlfJGP8xa6Nz8LU=
X-Received: by 2002:a05:6000:2c0b:b0:3e0:37f3:7778 with SMTP id
 ffacd0b85a97d-3e64317d070mr1984874f8f.26.1757179184312; Sat, 06 Sep 2025
 10:19:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com> <3db48135aec987c99e8e6601249d4a4c023703c4.1756151769.git.maciej.wieczor-retman@intel.com>
In-Reply-To: <3db48135aec987c99e8e6601249d4a4c023703c4.1756151769.git.maciej.wieczor-retman@intel.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 6 Sep 2025 19:19:33 +0200
X-Gm-Features: AS18NWARCvbmNO2W6P1AIa0UmJPeNw-mXWqtKJ3IgauS5o9YHYHKl3h4kKJN_64
Message-ID: <CA+fCnZd2824w610t86xQk+ykfv3EyAOvhb_OuXjru5e+jE4HTw@mail.gmail.com>
Subject: Re: [PATCH v5 19/19] x86: Make software tag-based kasan available
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com, 
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com, 
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com, 
	trintaeoitogc@gmail.com, axelrasmussen@google.com, yuanchu@google.com, 
	joey.gouly@arm.com, samitolvanen@google.com, joel.granados@kernel.org, 
	graf@amazon.com, vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org, 
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com, 
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com, 
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz, kaleshsingh@google.com, 
	justinstitt@google.com, catalin.marinas@arm.com, 
	alexander.shishkin@linux.intel.com, samuel.holland@sifive.com, 
	dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com, 
	dvyukov@google.com, tglx@linutronix.de, scott@os.amperecomputing.com, 
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org, 
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com, 
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org, 
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com, 
	ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org, 
	peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com, 
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com, 
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org, 
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com, rppt@kernel.org, 
	pcc@google.com, jan.kiszka@siemens.com, nicolas.schier@linux.dev, 
	will@kernel.org, jhubbard@nvidia.com, bp@alien8.de, x86@kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dotiqdcnzaru3u1e6ozzwfr4g6qyxpfu
X-Rspam-User: 
X-Rspamd-Queue-Id: E607940004
X-Rspamd-Server: rspam01
X-HE-Tag: 1757179185-864343
X-HE-Meta: U2FsdGVkX1/HWvpl67HIJqSXchwL1U9mmjRBbXQJ/u0sImQVlD2GsN16GY3UPKeJi1Dl5/2X+Wfq2lQ+YQkmjnU19VtYvXOT15fYGGP25/smbyeO/9h0+rKTXOCa1nbGTe92nxK0QPkdIh5gSlN9r1BcJz64aUHQUCPkfdw1jQvALyN7XW6z8vLtuxKraoik8OAvqXUgNx3OiCHgVlsFqoaiEmD4LW+kLWI9Zs1xZrMrI+HZ2I2EDCxq/2O8QRpZDA7vQeS0TJHEYr0EbW/BfxWua8auJhjGEM05ZRRqW7Glz2ey2VBzjRSlQZXgYSfm90coVgxVH1HVXt/rEaALgGoqvliVk0adoDS9xsnPXL6YcDTTibljxyKdRIvlpteSbSKUOqf1H3aMJt6N+H4XQosg4dsykP7rRuLeG8vnp9ifFJtQXASjF/+0RwXkqACJvU8T4zRGiWLmFOlnlGUqbG2v71oCXJNSCikphQ200HZzlkezxqkYxIn9tXpAnpZDLiGAh1OrjSTWanIjUYcH76/MxU7WUVHjrFZ7kl3HPNHDcGqnwwHG9+ChmN5AVDrUUPnJH/inscaXlea4cn3YPi9wVbYsx8TwQZ1d/bsZ+TOtlFeyq5H6jhMmFPBhvG+PDxWUG2VrJ/2DLGQzrmJ1gLBKZ0BpukbTxDQOyEacbmj1joFmdKUIVe0rM9gkoPtcLnHAepS2IXKRlNqn8L28vrOKFmtU3Ul/Gzdwn9myEKDlaa3rrd4qwOMMWUfBCPhzw6HO/kuvJe7zYCklD3VLfyarisVg2jqIP5hU5oXZDPmiDmrukGYe7/16vxn6J7/IBXZ5S/N2lrl+Idg68pvPOUpx9VrOHxt5VY9OoJNk80s4FK7mNip21YXgqGusDG874Ucht7OkOz3vcY1QUGTgtuDXXBUW4g/S27etaY6qwIZXs4Q7cF2L9x7MwW4S+zUwkrpVYWjqDIbjUc+FEgI
 boTKZ/qJ
 xC5sqL/F/h9C+bw0rjQpwEJtmaCGn5u/FQkN9S6Jgovun+2JGVWnwG109LX7h18Ab2/K7fysUyjhMTIlvGcfsBSR7XHT0wv+BxBnk1CL08zNTXC7kozWZUpw85eFzVZsrv3su2JGeggK6HJhKIZeps9bA/huw3uWoeBOXQDCNQR9azfKOCGINvLft83NpJmrr8kbARjlfht09TmC1LYvDTonXhtx2mnx4ygqP44ftBAoLr7Gbc2X0el2T5KpNTsMNrpY0e1xWQ1xBx7KYdQ3FG9dt/BQZKl++0txO+qtEfB7zvsoTJDkQAg3g183CVbblQZu6O7hRmCyv05pJ30wOei8SrGfLT7t9gZUEM8eLlkR9lkc8ds0682NvseoRPjHp2tQpHR7MfHA4oeikWtc6wR7yDjVMKeI5H/zncJcxM0K7MBVDoNtSY9Gxw1DBgfRmWBU5U1Q4TnpK940=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 10:32=E2=80=AFPM Maciej Wieczor-Retman
<maciej.wieczor-retman@intel.com> wrote:
>
> Make CONFIG_KASAN_SW_TAGS available for x86 machines if they have
> ADDRESS_MASKING enabled (LAM) as that works similarly to Top-Byte Ignore
> (TBI) that allows the software tag-based mode on arm64 platform.
>
> Set scale macro based on KASAN mode: in software tag-based mode 16 bytes
> of memory map to one shadow byte and 8 in generic mode.
>
> Disable CONFIG_KASAN_INLINE and CONFIG_KASAN_STACK when
> CONFIG_KASAN_SW_TAGS is enabled on x86 until the appropriate compiler
> support is available.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v4:
> - Add x86 specific kasan_mem_to_shadow().
> - Revert x86 to the older unsigned KASAN_SHADOW_OFFSET. Do the same to
>   KASAN_SHADOW_START/END.
> - Modify scripts/gdb/linux/kasan.py to keep x86 using unsigned offset.
> - Disable inline and stack support when software tags are enabled on
>   x86.
>
> Changelog v3:
> - Remove runtime_const from previous patch and merge the rest here.
> - Move scale shift definition back to header file.
> - Add new kasan offset for software tag based mode.
> - Fix patch message typo 32 -> 16, and 16 -> 8.
> - Update lib/Kconfig.kasan with x86 now having software tag-based
>   support.
>
> Changelog v2:
> - Remove KASAN dense code.
>
>  Documentation/arch/x86/x86_64/mm.rst | 6 ++++--
>  arch/x86/Kconfig                     | 4 +++-
>  arch/x86/boot/compressed/misc.h      | 1 +
>  arch/x86/include/asm/kasan.h         | 1 +
>  arch/x86/kernel/setup.c              | 2 ++
>  lib/Kconfig.kasan                    | 3 ++-
>  scripts/gdb/linux/kasan.py           | 4 ++--
>  7 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/arch/x86/x86_64/mm.rst b/Documentation/arch/x8=
6/x86_64/mm.rst
> index a6cf05d51bd8..ccbdbb4cda36 100644
> --- a/Documentation/arch/x86/x86_64/mm.rst
> +++ b/Documentation/arch/x86/x86_64/mm.rst
> @@ -60,7 +60,8 @@ Complete virtual memory map with 4-level page tables
>     ffffe90000000000 |  -23    TB | ffffe9ffffffffff |    1 TB | ... unus=
ed hole
>     ffffea0000000000 |  -22    TB | ffffeaffffffffff |    1 TB | virtual =
memory map (vmemmap_base)
>     ffffeb0000000000 |  -21    TB | ffffebffffffffff |    1 TB | ... unus=
ed hole
> -   ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN sh=
adow memory
> +   ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN sh=
adow memory (generic mode)
> +   fffff40000000000 |   -8    TB | fffffbffffffffff |    8 TB | KASAN sh=
adow memory (software tag-based mode)
>    __________________|____________|__________________|_________|_________=
___________________________________________________
>                                                                |
>                                                                | Identica=
l layout to the 56-bit one from here on:
> @@ -130,7 +131,8 @@ Complete virtual memory map with 5-level page tables
>     ffd2000000000000 |  -11.5  PB | ffd3ffffffffffff |  0.5 PB | ... unus=
ed hole
>     ffd4000000000000 |  -11    PB | ffd5ffffffffffff |  0.5 PB | virtual =
memory map (vmemmap_base)
>     ffd6000000000000 |  -10.5  PB | ffdeffffffffffff | 2.25 PB | ... unus=
ed hole
> -   ffdf000000000000 |   -8.25 PB | fffffbffffffffff |   ~8 PB | KASAN sh=
adow memory
> +   ffdf000000000000 |   -8.25 PB | fffffbffffffffff |   ~8 PB | KASAN sh=
adow memory (generic mode)
> +   ffeffc0000000000 |   -6    PB | fffffbffffffffff |    4 PB | KASAN sh=
adow memory (software tag-based mode)
>    __________________|____________|__________________|_________|_________=
___________________________________________________
>                                                                |
>                                                                | Identica=
l layout to the 47-bit one from here on:
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index b8df57ac0f28..f44fec1190b6 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -69,6 +69,7 @@ config X86
>         select ARCH_CLOCKSOURCE_INIT
>         select ARCH_CONFIGURES_CPU_MITIGATIONS
>         select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
> +       select ARCH_DISABLE_KASAN_INLINE        if X86_64 && KASAN_SW_TAG=
S

Do you think it would make sense to drop the parts of the series that
add int3 handling, since the inline instrumentation does not work yet
anyway?

>         select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE &=
& MIGRATION
>         select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
>         select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
> @@ -199,6 +200,7 @@ config X86
>         select HAVE_ARCH_JUMP_LABEL_RELATIVE
>         select HAVE_ARCH_KASAN                  if X86_64
>         select HAVE_ARCH_KASAN_VMALLOC          if X86_64
> +       select HAVE_ARCH_KASAN_SW_TAGS          if ADDRESS_MASKING
>         select HAVE_ARCH_KFENCE
>         select HAVE_ARCH_KMSAN                  if X86_64
>         select HAVE_ARCH_KGDB
> @@ -403,7 +405,7 @@ config AUDIT_ARCH
>
>  config KASAN_SHADOW_OFFSET
>         hex
> -       depends on KASAN

Line accidentally removed?

> +       default 0xeffffc0000000000 if KASAN_SW_TAGS
>         default 0xdffffc0000000000
>
>  config HAVE_INTEL_TXT
> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/m=
isc.h
> index db1048621ea2..ded92b439ada 100644
> --- a/arch/x86/boot/compressed/misc.h
> +++ b/arch/x86/boot/compressed/misc.h
> @@ -13,6 +13,7 @@
>  #undef CONFIG_PARAVIRT_SPINLOCKS
>  #undef CONFIG_KASAN
>  #undef CONFIG_KASAN_GENERIC
> +#undef CONFIG_KASAN_SW_TAGS
>
>  #define __NO_FORTIFY
>
> diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
> index f3e34a9754d2..385f4e9daab3 100644
> --- a/arch/x86/include/asm/kasan.h
> +++ b/arch/x86/include/asm/kasan.h
> @@ -7,6 +7,7 @@
>  #include <linux/types.h>
>  #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
>  #ifdef CONFIG_KASAN_SW_TAGS
> +#define KASAN_SHADOW_SCALE_SHIFT 4
>
>  /*
>   * LLVM ABI for reporting tag mismatches in inline KASAN mode.
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 1b2edd07a3e1..5b819f84f6db 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1207,6 +1207,8 @@ void __init setup_arch(char **cmdline_p)
>
>         kasan_init();
>
> +       kasan_init_sw_tags();
> +
>         /*
>          * Sync back kernel address range.
>          *
> diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
> index f82889a830fa..9ddbc6aeb5d5 100644
> --- a/lib/Kconfig.kasan
> +++ b/lib/Kconfig.kasan
> @@ -100,7 +100,8 @@ config KASAN_SW_TAGS
>
>           Requires GCC 11+ or Clang.
>
> -         Supported only on arm64 CPUs and relies on Top Byte Ignore.
> +         Supported on arm64 CPUs that support Top Byte Ignore and on x86=
 CPUs
> +         that support Linear Address Masking.
>
>           Consumes about 1/16th of available memory at kernel start and
>           add an overhead of ~20% for dynamic allocations.
> diff --git a/scripts/gdb/linux/kasan.py b/scripts/gdb/linux/kasan.py
> index fca39968d308..4b86202b155f 100644
> --- a/scripts/gdb/linux/kasan.py
> +++ b/scripts/gdb/linux/kasan.py
> @@ -7,7 +7,7 @@
>  #
>
>  import gdb
> -from linux import constants, mm
> +from linux import constants, utils, mm
>  from ctypes import c_int64 as s64
>
>  def help():
> @@ -40,7 +40,7 @@ class KasanMemToShadow(gdb.Command):
>          else:
>              help()
>      def kasan_mem_to_shadow(self, addr):
> -        if constants.CONFIG_KASAN_SW_TAGS:
> +        if constants.CONFIG_KASAN_SW_TAGS and not utils.is_target_arch('=
x86'):

This change seems to belong to the patch that changes how the shadow
memory address is calculated.


>              addr =3D s64(addr)
>          return (addr >> self.p_ops.KASAN_SHADOW_SCALE_SHIFT) + self.p_op=
s.KASAN_SHADOW_OFFSET
>
> --
> 2.50.1
>

