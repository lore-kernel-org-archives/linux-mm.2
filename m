Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31D2ACCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 08:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51DEE8E0009; Thu, 23 Oct 2025 04:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4A88E0002; Thu, 23 Oct 2025 04:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2FE8E0009; Thu, 23 Oct 2025 04:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1077C8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:08:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C57945C336
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:08:41 +0000 (UTC)
X-FDA: 84028652442.16.1E0651C
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id E78AD180009
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:08:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=sourceware.org (policy=none);
	spf=pass (imf24.hostedemail.com: domain of emacsray@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=emacsray@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761206920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IPdMqAaNN+qlhhgT28sC1RuE1Sie27pVKed+Lc0fHIU=;
	b=ZNwHslb/EUPOSVdOtOxaE4llxYDtXasHZpo1K7yJSF+rnGlOOylYxXTib3mxsbwVE4/+qA
	TpkbsgMsiqjFV7U61Os/1QofILoFGtDPrWC2xiDYTRMHGJLw/lZU8h5UoUu1jOLoFtykT4
	A0i4MJlWh58PfEVy30fz3b4WS9eJbXE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761206920; a=rsa-sha256;
	cv=none;
	b=B/7+p94Uanlt4pEiOZTTUfg0/fFbBNOHFi/OWwzo18ElNRBiKYAUMRWys8uizKGdsTr6ng
	5NPlj6qY9jJ9MDTA6nAjRKCnyGCbMAkz8+2G9YNT9rLZuWnbXhdUciVY7m5T+bs9VO/eKe
	msBbkVh85cnR91bj7OgL3924RSIPayY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=sourceware.org (policy=none);
	spf=pass (imf24.hostedemail.com: domain of emacsray@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=emacsray@gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-781206cce18so549459b3a.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761206919; x=1761811719;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IPdMqAaNN+qlhhgT28sC1RuE1Sie27pVKed+Lc0fHIU=;
        b=tkCydU5L2sTnPA8JpNsqKgk4b0dBzedO9o30CO7tsAtp/SnMLFFOVFDVyM6leNDk6I
         hurgxhP2or2RLoAGD8Hm+4AhwOiDdV0Uh6ImP8EbeEnzzopU+syJPj5LYDe7RrV9mKrl
         NpGuXdKoVbb6IcqCzNNqjySTiJuHGq7m4kdTavIaHXPbyuxkvmS/fXH1mx9ldsL0ActH
         n+PWksVtF0dnz0x3zBM4lkwslHHSltf9a9iR1KnLeRPsTwno+/ZYBc2SVAmtIZguj9+X
         j9lGxgjHT/cdSmPrpOa7yks2/Fi70eM2/qOhsKZDNMV6IM1CCV4RmirHbnzEf4uFr/Dp
         OUoA==
X-Forwarded-Encrypted: i=1; AJvYcCVpCBrVy7yyZkvrleBkYF+Dsx6Jif4ZmabbTsH2iIssyeA9GPKvMeJPLXHmrhNl6AdaXVJqWrP6LA==@kvack.org
X-Gm-Message-State: AOJu0YxVkW8SqGAkvL84nddkGlnm+2De5YYi7XMSYu9XGU1/SQCaCTUQ
	Vp3IdxzXfc+uA/GnVQHH4MfSENNQZggrDoFJWQQa24mrP89nvKJXsy8k
X-Gm-Gg: ASbGnctD906VDCAeXgB/a37JHdA5C6LGAQxt+NSlW0sNjfRz/SS3alpvAXY2qJqwoh4
	Jq5lYEaiMUv6mcY5i2tPOQSQq+pSluh6Z+w20jGDhsVfKJcoi380LACGdOnjIpETAinJ/dMccyN
	jcJv8Svdd3wEj2jHBvTZ5GEwCINb4fxMdyN8Vv1FDab6KxsH5p0naGB9NYJaIgnxhhc4GNr+vFJ
	0gZr126sJzGvboPF6kH4Pc+fccAhqxPWCavDPFteE30W4+ubdMlfZxGsQxcHhRfs73pX1OrO8t9
	GMgd+5aZMJtfhCOkz7YKA4Mhu7JrFtpG3u4/mba2fmCG5if3W+ECQkHXcXWT/gzFmgs1srm6/mL
	Nqk8EmtASDKu6ZfpF1px4iwegMsvS6ji/YX//JeA/crLSE2nHaStlYFaHi0sdZCkr/Moqya76YP
	AcnKbLgsFyprq971I57vrnb5Dq7tQHt2dJfvI8SpuTvg==
X-Google-Smtp-Source: AGHT+IGj9p7zkDVwEQi+TGhOgJntyVRui9Psn9Cj7kR8uoyW7/JfR0cnfzFv3w5Mv7bWcCLhDa5vDw==
X-Received: by 2002:a05:6a21:7e88:b0:334:b280:b12 with SMTP id adf61e73a8af0-33aa5c9b714mr6311776637.1.1761206918624;
        Thu, 23 Oct 2025 01:08:38 -0700 (PDT)
Received: from localhost (c-73-170-232-218.hsd1.ca.comcast.net. [73.170.232.218])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274ac3158sm1648393b3a.32.2025.10.23.01.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 01:08:38 -0700 (PDT)
Date: Thu, 23 Oct 2025 01:09:02 -0700
From: Fangrui Song <maskray@sourceware.org>
To: Jens Remus <jremus@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Steven Rostedt <rostedt@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, "Jose E. Marchesi" <jemarch@gnu.org>, 
	Beau Belgrave <beaub@linux.microsoft.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>, 
	Carlos O'Donell <codonell@redhat.com>, Sam James <sam@gentoo.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, David Hildenbrand <david@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v11 00/15] unwind_deferred: Implement sframe handling
Message-ID: <mzqhpduikzpeczmmxh5uyfzjpvdeae3ityqyp2rno4myujzb6y@ey346eksvoyf>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: z9ckfkcy4fssed1nu1c5gnah7p4zt5aq
X-Rspam-User: 
X-Rspamd-Queue-Id: E78AD180009
X-HE-Tag: 1761206919-647680
X-HE-Meta: U2FsdGVkX1/OMxC2mccAzg9uKYsiQdo/EftBJsMH/XiV54kw/OulL08qMlDUHM8O08dJxWyNuiC83kjwK594l3KVgngwu1KwTBFtDgTlA8KjF4Jn1WH9u3EdGzbOI+Xm1FS2ljFxJjSTvaa+QvDFiaUG2BIyv5Dvr13If4qTvF2VPZ4UMrp4lZtv7axDxuECXYWdd/7FIcVYckaNEP4oY24vWPmACseSb//H4xJzj+A9uSoF09z6t+U7L6PGDSXAYuzQ4vJTkDlWNx3zMAB6JIb9KtbqBpo3fzCKdH04hfGC2NmhDqPCaIo7u3rv8hCAFv+nzgq6Xt86YioopXdph2frNd2AzBAcDiPtpGV3viE6yZCKodPw65PKF9TC5atDZEK5kgPdvJ0wHlSTKGbsowhAONkFbeUc3qbxq0oYSFAsCQpu4r1BAbs6tZU0IWPTCA3P3x9D4z5mJnf5DOhCWwqv2bhEoe5+gST1RPIEFuQwTBdIVvWmLfMga7qHFU4TKzcvs+9DxTaxxz/ddFP2ufuaFs6McJhhaiknT8API786wB3y/H/oZU2hb3NRfhnhVebIhcHlH6VlImMLHV14ffq6yq2c5P6bxHXE2j22g+IFNwj9bPAXs2D4xrAmjfU2kVACyW2J/djw0ic3ggsdtFb7b0oVjZeLkqb0i2WONR6u++fpuqeUms0QQEOZXINYj2dehOEbGeT5v2x4YynrZWnRxLIDXcIN+stB8ViptJuSOuMACTptHXHo7u5st7YIZYNSh2W9kLBtXasHbrRlt786pVSCAA8GW7C54ptvs61qSU6nlzhUFzHOLgio6reZ8C1a5fkIV3tZQXdigWVHeldkxvD51EVDZjWc+62svLaSOBJ+deKlpRZVprz3OnyM6mBZVJkd31M4koneJlfoYu1K/npeiE0EoSXAHFBQND9U79yiwy8w5E/YaB5y79pdMQhbd8GZGmcdX3XmxRo
 xagSRvnN
 Nku7rf3O8dwoGKZk6+E03GAnMvMtw/EDWNV7GBT4qN9QuGbJHTzygduo+bEt4BPk212m8Az/cP9tNTWnbfp7l3utrVR4AIS89T8592Is41WvLdG+vfqrMQq+69+DD5cKzSSjZ9VewwcXoJ5+zaNAEFZhCgN3xib2t+Ssq81z1OE6snNynA/F8uwUr+XlNT8Jf7zQQI25pobKt5dMIqbV0kn3Dmwny//ML3XH4dpzf2HqSSUkI4l3IMXgNQVtbs0wDn5+XlJsLYtfaKJ+eGPQvw6JJPzeup3cPb4DpvxqDY7vMjE+q6N/I5DAvv9TKEdRRQo9dFUYTRoDOO7oUA+4xnU2+xR5HGUEBgATg/8Bzv1reD5QfG+AFNUuPshBVsDS3PSzkF60agj6hmp7OI/knHemX7U+YcHSUe7A2UNrQi0LG65girnm/ZgEfhoCz/WYp0/IF0BV8BV3vNt3BPi/J7oA4GDx+W4qHuJaTxtjAsWnAylSvXAiN7jP0MA1dyefwCNvFfCDg/zHfuxhQHTSPQmQaCm8QCdRVuRFbyKitsntQUVBX7hSLX9xWcvlgvaH7U9fxsyXambOuCIXNOuMdfPEVb5eKlNv8CI0J7qlnYlpgVltEzSOVanE1fnqTeTPMhg2rynTWrO5L3qt1pN579N7eGPN+LgNIBa4AVo81fMVG98ohMae7ox+YyDAwmOjUDqlWX5hml5+Ze3DQNsk8JeM8OxDeYOrQMB/QxYBAnyZkNMrwxBKV/DanOK+c5EEis0/h/jOPK5d/hCOlioblgiLNN9eSBTnoNyHq2lzxmSH/R7Ola3sAkUmURxAhCfBxK7N5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-22, Jens Remus wrote:
>This is the implementation of parsing the SFrame section in an ELF file.
>It's a continuation of Josh's and Steve's last work that can be found
>here:
>
>   https://lore.kernel.org/all/cover.1737511963.git.jpoimboe@kernel.org/
>   https://lore.kernel.org/all/20250827201548.448472904@kernel.org/
>
>Currently the only way to get a user space stack trace from a stack
>walk (and not just copying large amount of user stack into the kernel
>ring buffer) is to use frame pointers. This has a few issues. The biggest
>one is that compiling frame pointers into every application and library
>has been shown to cause performance overhead.
>
>Another issue is that the format of the frames may not always be consistent
>between different compilers and some architectures (s390) has no defined
>format to do a reliable stack walk. The only way to perform user space
>profiling on these architectures is to copy the user stack into the kernel
>buffer.
>
>SFrames[1] is now supported in gcc binutils and soon will also be supported
>by LLVM. 

Please consider dropping the statement, "soon will also be supported by LLVM."
Speaking as LLVM's MC, lld/ELF, and binary utilities maintainer, I have significant concerns about the v2 format, specifically its apparent disregard for standard ELF and linker conventions
(https://maskray.me/blog/2025-09-28-remarks-on-sframe#linking-and-execution-views)

To arm64 maintainers, it is critical time to revisit a unwind
information format, as I have outlined in my blog post:

A sorted address table like .eh_frame_hdr might still be needed, but the
design could be very different for arm64.

I am curious whether anyone has thought about a library that parses .eh_frame and generates SFrame.
If objtool integrates  this library, it can generate SFrame for vmlinux and modules without relying on assembler/linker.
Linker and assembler requires a level of stability that is currently concerning on the toolchain side.

(https://sourceware.org/pipermail/binutils/2025-October/144974.html
"This "linker will DTRT" assertion glosses over significant
implementation complexity. Each version needs not just a reader but
version-specific *merging* logic in every linker—fundamentally different
from simply reading a format.")

>SFrames acts more like ORC, and lives in the ELF executable
>file as its own section. Like ORC it has two tables where the first table
>is sorted by instruction pointers (IP) and using the current IP and finding
>it's entry in the first table, it will take you to the second table which
>will tell you where the return address of the current function is located
>and then you can use that address to look it up in the first table to find
>the return address of that function, and so on. This performs a user
>space stack walk.
>
>Now because the SFrame section lives in the ELF file it needs to be faulted
>into memory when it is used. This means that walking the user space stack
>requires being in a faultable context. As profilers like perf request a stack
>trace in interrupt or NMI context, it cannot do the walking when it is
>requested. Instead it must be deferred until it is safe to fault in user
>space. One place this is known to be safe is when the task is about to return
>back to user space.
>
>This series makes the deferred unwind code implement SFrames.
>
>[1] https://sourceware.org/binutils/wiki/sframe
>
>Changes since v10:
>- Rebase on v6.17-rc1 with Peter's unwind user fixes and x86 support
>  series [2] and Steve's support for the deferred unwinding infrastructure
>  series in perf [3] and perf tool [4] on top.
>- Support for SFrame V2 PC-relative FDE function start address. (Jens)
>- Support for SFrame V2 representing RA undefined as indication for
>  outermost frames. (Jens)
>
>[2]: [PATCH 00/12] Various fixes and x86 support,
>     https://lore.kernel.org/all/20250924075948.579302904@infradead.org/
>[3]: [PATCH v16 0/4] perf: Support the deferred unwinding infrastructure,
>     https://lore.kernel.org/all/20251007214008.080852573@kernel.org/
>[4]: [PATCH v16 0/4] perf tool: Support the deferred unwinding infrastructure,
>     https://lore.kernel.org/all/20250908175319.841517121@kernel.org/
>
>Patches 1 and 2 are suggested fixups to patches from Peter's unwind user
>fixes and x86 support series.  They keep the factoring out of the word
>size from the frame's CFA, FP, and RA offsets local to unwind user fp, as
>unwind user sframe does use absolute offsets.
>
>Patches 3, 6, and 14 have been updated to exclusively support the recent
>PC-relative SFrame FDE function start address encoding.  With Binutils 2.45
>the SFrame V2 FDE function start address field value is an offset from the
>field (i.e. PC-relative) instead of from the .sframe section start.  This
>is indicated by the new SFrame header flag SFRAME_F_FDE_FUNC_START_PCREL.
>Old SFrame V2 sections get rejected with dynamic debug message
>"bad/unsupported sframe header".
>
>Patches 9 and 10 add support to unwind user and unwind user sframe for
>a recent change of the SFrame V2 format to represent an undefined
>return address as an SFrame FRE without any offsets, which is used as
>indication for outermost frames.  Note that currently only a development
>build of Binutils mainline generates SFrame information including this
>new indication for outermost frames.  SFrame information without the new
>indication is still supported.  Without these patches unwind user sframe
>would identify such new SFrame FREs without any offsets as corrupted and
>remove the .sframe section, causing any any further stack tracing using
>sframe to fail.
>
>Regards,
>Jens
>
>
>Jens Remus (4):
>  fixup! unwind: Implement compat fp unwind
>  fixup! unwind_user/x86: Enable frame pointer unwinding on x86
>  unwind_user: Stop when reaching an outermost frame
>  unwind_user/sframe: Add support for outermost frame indication
>
>Josh Poimboeuf (11):
>  unwind_user/sframe: Add support for reading .sframe headers
>  unwind_user/sframe: Store sframe section data in per-mm maple tree
>  x86/uaccess: Add unsafe_copy_from_user() implementation
>  unwind_user/sframe: Add support for reading .sframe contents
>  unwind_user/sframe: Detect .sframe sections in executables
>  unwind_user/sframe: Wire up unwind_user to sframe
>  unwind_user/sframe/x86: Enable sframe unwinding on x86
>  unwind_user/sframe: Remove .sframe section on detected corruption
>  unwind_user/sframe: Show file name in debug output
>  unwind_user/sframe: Add .sframe validation option
>  unwind_user/sframe: Add prctl() interface for registering .sframe
>    sections
>
> MAINTAINERS                        |   1 +
> arch/Kconfig                       |  23 ++
> arch/x86/Kconfig                   |   1 +
> arch/x86/include/asm/mmu.h         |   2 +-
> arch/x86/include/asm/uaccess.h     |  39 +-
> arch/x86/include/asm/unwind_user.h |  11 +-
> fs/binfmt_elf.c                    |  49 ++-
> include/linux/mm_types.h           |   3 +
> include/linux/sframe.h             |  60 +++
> include/linux/unwind_user_types.h  |   5 +-
> include/uapi/linux/elf.h           |   1 +
> include/uapi/linux/prctl.h         |   6 +-
> kernel/fork.c                      |  10 +
> kernel/sys.c                       |   9 +
> kernel/unwind/Makefile             |   3 +-
> kernel/unwind/sframe.c             | 615 +++++++++++++++++++++++++++++
> kernel/unwind/sframe.h             |  72 ++++
> kernel/unwind/sframe_debug.h       |  68 ++++
> kernel/unwind/user.c               |  56 ++-
> mm/init-mm.c                       |   2 +
> 20 files changed, 1004 insertions(+), 32 deletions(-)
> create mode 100644 include/linux/sframe.h
> create mode 100644 kernel/unwind/sframe.c
> create mode 100644 kernel/unwind/sframe.h
> create mode 100644 kernel/unwind/sframe_debug.h
>
>-- 
>2.48.1
>

