Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E64B0FAD41B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 07:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6286B0005; Thu, 23 Apr 2026 03:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50416B008A; Thu, 23 Apr 2026 03:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF09B6B008C; Thu, 23 Apr 2026 03:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA3076B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:00:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34A008BD80
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:00:33 +0000 (UTC)
X-FDA: 84688922346.17.1927028
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0A4921C0016
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:00:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Vkh/tI7p";
	spf=pass (imf21.hostedemail.com: domain of ibhagatgnu@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ibhagatgnu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776927631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/FDcYdMEVgX0UUwJJspOEqoP3UMTSsUAQZWMt+ZF0X8=;
	b=FmQipU2vuFDIsxLjulitNj8OkQesoOq0hAdjeep2pR5rU+dJiS3ZQZNYj062Op/WjcLSzT
	F1GX+MdcEbWTWWdQGpJISbHmS2d6FcWgHrc1dNuVqM3rQhSFzpGjwQ6vHsYTRFv0tFm6xi
	h2BDzqBhu7rJXjdISDp1THeD0gO6I6I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Vkh/tI7p";
	spf=pass (imf21.hostedemail.com: domain of ibhagatgnu@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ibhagatgnu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776927631; a=rsa-sha256;
	cv=none;
	b=UJlk+SFevJHeWjkhDryxzYle9rm6rnILJgNpEhOHmpwZyrn3Mo7bF6mpD10QRi3KlM5zIZ
	wAgZchKob8F/BTwkukBatvB3eOmOGcBsvLNoIYLckakILRFNkLpMkaT6Jte87urfU1QZAk
	9I+EEYSIWF2cqMq4JMbtHvbVz2FkkuI=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b4583f0a1aso39808195ad.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776927630; x=1777532430; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/FDcYdMEVgX0UUwJJspOEqoP3UMTSsUAQZWMt+ZF0X8=;
        b=Vkh/tI7p7N6vZBR58LC7qfD5SBbmg7L+UalnkMkb1BXossSSseoeAomCa/vctJzrUa
         UrIqJYWUu8hUpL0/gLB2Hj/OcFmZwrafSOCXoeeLXIdzZAy3zjd6cgR06MyxDSYbFysS
         2xITD5H6ni3coBLLLGNNL42Zook4kKgdn7RhsBLwSGijkIGlB05SvSRCU65XRQFTAYeT
         YW5//ILsw1i/pAKaefSHAYivpkJMBcl6N+O2tudIYVdxPkomcbzhwlbDYCNpyvjBW2Wb
         H8lAVgN4W4A46A4nt63iQKC4PxL8an8vAlRIw9A+RMeRbWrr3FH4LF7H2ZHko00EHD6Z
         b4fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776927630; x=1777532430;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/FDcYdMEVgX0UUwJJspOEqoP3UMTSsUAQZWMt+ZF0X8=;
        b=WYE73YGktnk0huzbyNV168mooqUxqztdJ9gcw+6bEs0BtCYMF8kujjqC337lrPH87/
         x2pwe6ItvoZWWG6Lyftm6E1oqDOBxVSiqdpJpfRagHLf86kKcobMJbQrtQ2PgarGWVbz
         RbPHjqg9JL1N1U8ZcuGHnR0lHhojTLd0sMDCnJE+JepiwDb9x0YTJYfjVCi7YsrdsFGH
         VqQUzlJ7adPnPNvbaFQIul1MVrawTnfJZjRPpvL97j2laUXnEZRHr2hWQMOcnAtZZ2vf
         /dk+3mexxlBbBUb5xpXTWgCMTh8vvd6SokxEVk8XqfrAisKkG7vT+lyylKkhiWG6m7pU
         ZMaQ==
X-Forwarded-Encrypted: i=1; AFNElJ98oVa7xOzQ0yIWxHS3eX6A7QSrHrXVOedhoSIy0ahUyQmRAH1BHbob7+m0fO96PFUoQKe2fn1ArA==@kvack.org
X-Gm-Message-State: AOJu0YyMwtpVZMMMh71B4Jx5FW1Y9j9kEW2kvl0W3bPsTP+GzkmMI14i
	kfkAtH9WETTG3p0upx1mlLyA3Zo7ovwUGgWkKluI71QSxIeBNHYuMAoL
X-Gm-Gg: AeBDiesgsc9Sbt7Th0YYYWZ0IJ320l20QaDwEGFDG/aZTHi8M79/7a5i0DHHlBr3bfn
	UZVxvl0WCirSwO33cGirM6sOpGqvUzu8O2Tbsoy/qOOD4HRQQUHDzGHzKsJpwiDftw97NNjH9VA
	UPmX+JhAFuTdcUpxZGbRWQG9Za1Vl1DHA2Yh0vrWfBzOGoN5JKs7GCIHvOqJuRb0lsRrxFAg4fR
	eqtfU9JvMhscKrnTiv3p4ceraD+dEANNzbTb1mWsMMI7sYhw/rmuSiZyRlh+a2R6L9AtsrsTsWc
	5x2FYv7WfM52SKoQg7fNA3N5R5Wb2W7JysJOSajO/lAzi3WoVfpNPpCenW1RE67q4t8xXciMy0X
	6oycgcb2JRg9CHC0Qbd3woW9wj+1EQYG/UkJ+hHsb2BXTtGVCW/mt90bD40SSgCQnZ3TsBo5dBw
	hdUrPf7pupd/F7LzFOqyt2oguOJMWUS9jqE7fIb15GFe3qzqU=
X-Received: by 2002:a17:902:da89:b0:2b0:ba14:fc55 with SMTP id d9443c01a7336-2b5f9fa70camr289653425ad.29.1776927629301;
        Thu, 23 Apr 2026 00:00:29 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9582:1100::3781? ([2604:3d08:9582:1100::3781])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa2e5cesm220351645ad.25.2026.04.23.00.00.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 00:00:28 -0700 (PDT)
Message-ID: <71da148c-d02c-41f4-80da-b90815ffc313@gmail.com>
Date: Thu, 23 Apr 2026 00:00:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Indu Bhagat <ibhagatgnu@gmail.com>
Subject: Re: [PATCH v13 00/18] unwind_deferred: Implement sframe handling
To: Jens Remus <jremus@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
 Steven Rostedt <rostedt@kernel.org>, Jens Remus <jremus@linux.ibm.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Andrii Nakryiko <andrii@kernel.org>, "Jose E. Marchesi" <jemarch@gnu.org>,
 Beau Belgrave <beaub@linux.microsoft.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
 Carlos O'Donell <codonell@redhat.com>, Sam James <sam@gentoo.org>,
 Dylan Hatch <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 ibhagatgnu@gmail.com
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A4921C0016
X-Stat-Signature: 4cpu8tc1ec8chs6yhqr1qzb3o71sm394
X-Rspam-User: 
X-HE-Tag: 1776927630-779080
X-HE-Meta: U2FsdGVkX191hSyRSfXO8lDQOtgdCn3yqf/TIPmjP3Rh5hhwY01vO/hSrLv1YKgRu1GRLR1vtHns7xLZHAXRRksOZxLJFf1FUL+XfINUdk4Yf4lij6Lwk/1AEpUxbXg1btdBXGRT5ycu2w2wYKNGLfg1+Hy6x+zVB9gXu6qPunEz/7qdeX5MT3uj6z26nGcPJMF0ydAJJow3sf3gmWGMfWhNG4d6T0rT2TKyWnFYmawxHi8QoFSZo8jIAxBNEEOpUHrgYWYCP8evuV8oKUTi0MaviLAknnemvNdIP0jg9DihKOrFIYD66TbKlpTzL8/3yf/YErnLNlZ/o6kNWBAY/rLsEml0bURWd15QDb1VWglSKigJp6lHudKWRiauxcYdEL5Gd44gDIzN8+/P4No2jv3BeIXf0L9fg3khHFfl6+vVRYa+yQPO96G8HRRj3uXJzG2BHfTsfb0Q48oJ1y/onoDmr8XEZeAyfP2IWeycJrlp3CuMECYyAFwVcmJsg1cStgmljHjgMO9uY7Fro+hRSLaCyFgezMlwI8YZzLQ3Mjsi3kCR0BCSO8QFJ9thDLp7TKhrRAtRRQt9155BYMJCkGaRULuSJjzwpLYuUI0shwq0b5mZjBaXYQdeCBD2hAH05JSPoYvMOPMP4Cc89f1pIESxxbVqw27/pNzUpbCC5po4M3rY1tTunIPPEn9BuGhkoGzWId7ZQBrVooKOiK5bJvXkWJ6qnjIej3CaNYrOy9zVwE7scuaG9KPloOdCrszG6ezbfqRRZYLCwFn4PLScHcoL5zB2MolaY7L04UW+l8POIAS0feqc3qhYUzEMDU95ZmajUfbAeoiN98q9jjrZsX01EjrPVuHZc6up2evJdAafcmHhyO6dk7w4uqyE25d8umqUOu6aOP3eh6Wheuw0JqiQWZ02xto7UmZpRDCtOYjWrATdOzL/O8msXlDrAAb4wQspHBYAZTeMOsNdccd
 yxcuR2Lb
 FKA7bf3/Be5k3jqtU3L3Xcv3FDiUVSZvJYitK5HqCFo+w8wV49emiytHjtugreXZEhWJBJA6J+FSHUp/oUK5W9qa7tQGxMiVFXpzG+pT1XxX/rusnd+65QG4a17Fs1OAeXs6QGaeSrRbLt8CO63hSck+plYlqqa/o6k0qomsnEQKK37wIK93AEHb+XSlDS+i+J42WRwMi8owdAYaje3CJ0QGLaO1W8wf2JC+Ss40trraNFWVuzrlJBXkp0EA8TbHZuSUhIndGLJ2n9OsFa9rLoNdycdsiHC1PGGysCOFQXsxxM6lpEw9mF85ANPAp5koq4Os046W2oum9Vnzagn+C6QpfMqF7DAKdNH2/KoIIQr49rpM3dOU5aA6MAvjUKs/vgjxeYZOBvepQXimeB3waYmkNKjSuqju0uSVmGqU9oGetWbTbIj9o8X8l+SjZ+3UpqisrVStE8lLHd7REytbykXz52T9ANmvtUQyKiioL/LuwYW2z8Hl4p+mRLi2WISQaWn7YaPUsjzyeUJwuP2pq1Egc1VgoV4pDInmSuqgx1hGngndSRVk4/WYsE6a1LVoMTuf5ctb5SOTEaFhyi+z9kiUYOMopvLvKCM8QNz06kdatG7E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jan 27, 2026 at 7:32 AM Jens Remus <jremus@linux.ibm.com> wrote:
>
> This is the implementation of parsing the SFrame V3 stack trace information
> from an .sframe section in an ELF file.  It's a continuation of Josh's and
> Steve's work that can be found here:
>
>    https://lore.kernel.org/all/cover.1737511963.git.jpoimboe@kernel.org/
>    https://lore.kernel.org/all/20250827201548.448472904@kernel.org/
>
> Currently the only way to get a user space stack trace from a stack
> walk (and not just copying large amount of user stack into the kernel
> ring buffer) is to use frame pointers. This has a few issues. The biggest
> one is that compiling frame pointers into every application and library
> has been shown to cause performance overhead.
>
> Another issue is that the format of the frames may not always be consistent
> between different compilers and some architectures (s390) has no defined
> format to do a reliable stack walk. The only way to perform user space
> profiling on these architectures is to copy the user stack into the kernel
> buffer.
>
> SFrame [1] is now supported in binutils (x86-64, ARM64, and s390). There is
> discussions going on about supporting SFrame in LLVM. SFrame acts more like
> ORC, and lives in the ELF executable file as its own section. Like ORC it
> has two tables where the first table is sorted by instruction pointers (IP)
> and using the current IP and finding it's entry in the first table, it will
> take you to the second table which will tell you where the return address
> of the current function is located and then you can use that address to
> look it up in the first table to find the return address of that function,
> and so on. This performs a user space stack walk.
>
> Now because the .sframe section lives in the ELF file it needs to be faulted
> into memory when it is used. This means that walking the user space stack
> requires being in a faultable context. As profilers like perf request a stack
> trace in interrupt or NMI context, it cannot do the walking when it is
> requested. Instead it must be deferred until it is safe to fault in user
> space. One place this is known to be safe is when the task is about to return
> back to user space.
>
> This series makes the deferred unwind user code implement SFrame format V3
> and enables it on x86-64.
>
> [1]: https://sourceware.org/binutils/wiki/sframe
>
>
> This series applies on top of the tip perf/core branch:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git  perf/core
>
> The to be stack-traced user space programs (and libraries) need to be
> built with the recent SFrame stack trace information format V3, as
> generated by the upcoming binutils 2.46 with assembler option --gsframe.
> It can be built from source from the binutils-2_46-branch branch:
>
>   git://sourceware.org/git/binutils-gdb.git  binutils-2_46-branch
>
> Namhyung Kim's related perf tools deferred callchain support can be used
> for testing ("perf record --call-graph fp,defer" and "perf report/script").
>
>
> Changes since v12 (see patch notes for details):
> - Rebase on tip perf/core branch (d55c571e4333).
> - Add support for SFrame V3, including its new flexible FDEs.  SFrame V2
>   is not supported.
>
> Changes since v11 (see patch notes for details):
> - Rebase on tip master branch (f8fdee44bf2f) with Namhyung Kim's
>   perf/defer-callchain-v4 branch merged on top.
> - Adjust to Peter's latest undwind user enhancements.
> - Simplify logic by using an internal SFrame FDE representation, whose
>   FDE function start address field is an address instead of a PC-relative
>   offset (from FDE).
> - Rename struct sframe_fre to sframe_fre_internal to align with
>   struct sframe_fde_internal.
> - Remove unused pt_regs from unwind_user_next_common() and its
>   callers. (Peter)
> - Simplify unwind_user_next_sframe(). (Peter)
> - Fix a few checkpatch errors and warnings.
> - Minor cleanups (e.g. move includes, fix indentation).
>
> Changes since v10:
> - Support for SFrame V2 PC-relative FDE function start address.
> - Support for SFrame V2 representing RA undefined as indication for
>   outermost frames.
>
>
> Patches 1, 4, 11, and 17 have been updated to exclusively support the
> latest SFrame V3 stack trace information format, that is generated by
> the upcoming binutils 2.46 release.  Old SFrame V2 sections get rejected
> with dynamic debug message "bad/unsupported sframe header".
>
> Patches 7 and 8 add support to unwind user (sframe) for outermost frames.
>
> Patches 12-15 add support to unwind user (sframe) for the new SFrame V3
> flexible FDEs.
>
> Patch 16 improves the performance of searching the SFrame FRE for an IP.
>

Thanks Jens for your work on this. Apart from some of those minor 
renames you are already planning on doing (as you mentioned in the 
meeting today), the SFrame related bits look OK to me.

Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>

> Regards,
> Jens
>
>
> Jens Remus (7):
>   unwind_user: Stop when reaching an outermost frame
>   unwind_user/sframe: Add support for outermost frame indication
>   unwind_user: Enable archs that pass RA in a register
>   unwind_user: Flexible FP/RA recovery rules
>   unwind_user: Flexible CFA recovery rules
>   unwind_user/sframe: Add support for SFrame V3 flexible FDEs
>   unwind_user/sframe: Separate reading of FRE from reading of FRE data
>     words
>
> Josh Poimboeuf (11):
>   unwind_user/sframe: Add support for reading .sframe headers
>   unwind_user/sframe: Store .sframe section data in per-mm maple tree
>   x86/uaccess: Add unsafe_copy_from_user() implementation
>   unwind_user/sframe: Add support for reading .sframe contents
>   unwind_user/sframe: Detect .sframe sections in executables
>   unwind_user/sframe: Wire up unwind_user to sframe
>   unwind_user/sframe: Remove .sframe section on detected corruption
>   unwind_user/sframe: Show file name in debug output
>   unwind_user/sframe: Add .sframe validation option
>   unwind_user/sframe/x86: Enable sframe unwinding on x86
>   unwind_user/sframe: Add prctl() interface for registering .sframe
>     sections
>
>  MAINTAINERS                               |   1 +
>  arch/Kconfig                              |  23 +
>  arch/x86/Kconfig                          |   1 +
>  arch/x86/include/asm/mmu.h                |   2 +-
>  arch/x86/include/asm/uaccess.h            |  39 +-
>  arch/x86/include/asm/unwind_user.h        |  69 +-
>  arch/x86/include/asm/unwind_user_sframe.h |  12 +
>  fs/binfmt_elf.c                           |  48 +-
>  include/linux/mm_types.h                  |   3 +
>  include/linux/sframe.h                    |  60 ++
>  include/linux/unwind_user.h               |  18 +
>  include/linux/unwind_user_types.h         |  46 +-
>  include/uapi/linux/elf.h                  |   1 +
>  include/uapi/linux/prctl.h                |   6 +-
>  kernel/fork.c                             |  10 +
>  kernel/sys.c                              |   9 +
>  kernel/unwind/Makefile                    |   3 +-
>  kernel/unwind/sframe.c                    | 840 ++++++++++++++++++++++
>  kernel/unwind/sframe.h                    |  87 +++
>  kernel/unwind/sframe_debug.h              |  68 ++
>  kernel/unwind/user.c                      | 105 ++-
>  mm/init-mm.c                              |   2 +
>  22 files changed, 1414 insertions(+), 39 deletions(-)
>  create mode 100644 arch/x86/include/asm/unwind_user_sframe.h
>  create mode 100644 include/linux/sframe.h
>  create mode 100644 kernel/unwind/sframe.c
>  create mode 100644 kernel/unwind/sframe.h
>  create mode 100644 kernel/unwind/sframe_debug.h
>
> --
> 2.51.0
>
>

