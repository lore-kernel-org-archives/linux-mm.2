Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59634EB594B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 01:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145836B0005; Tue, 10 Feb 2026 20:48:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F40E6B0089; Tue, 10 Feb 2026 20:48:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EECE66B008A; Tue, 10 Feb 2026 20:48:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DCE316B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:48:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64AD988CB4
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:48:10 +0000 (UTC)
X-FDA: 84430490340.12.1EE6B47
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6B346160007
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:48:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=USn2fp5U;
	spf=pass (imf08.hostedemail.com: domain of dylanbhatch@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=dylanbhatch@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770774488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIhDAJJR+YXegWy/wL3i8yaBjUwW4vdjx7/rh4TvX9Y=;
	b=wiLyXfFwuTnFmTG53Ycrozhs53j7XNXRRwrhUHqMBk1CHxHpfVX0DeDpCm6MdFZptIP6H1
	ANxdL6BztCxWAKF1EdZAW0sd82WdnpRw9TKI4eTlUcUOdIQnh24AmviGtAoL2QtSoZYSQv
	fdBBshvgrMcOdHei0qAXEFlqyZ22/Ms=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=USn2fp5U;
	spf=pass (imf08.hostedemail.com: domain of dylanbhatch@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=dylanbhatch@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770774488; a=rsa-sha256;
	cv=pass;
	b=PPtbz2H2cKvHbow0e9vlxKTQO5unxj/GakJ2gv2EimcJa/aN8PNFM/9oGpROOaKWiAO8uG
	+t1aBHcQ5m8g7TjL3JTRb+uaYjIdSMjT1gHwagsRhlssWvJ8m9V1AFodfgCDD6kMlSYrqq
	I7fJ/X2uFWp3HAsTLT35s3DiqQhv02A=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7950881727cso10541547b3.3
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 17:48:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770774487; cv=none;
        d=google.com; s=arc-20240605;
        b=FlpK0lwugAptMnThkRBcAo3fB6IMHiiG/LbOS0y5bcbr2NuJIyojmO/tyhAW8l8RFG
         BQrCEmePf+9d+iH1gPl97sLKuXQ3FmEdtimIlxDTZIwnh2R+Y2xtS6XSzN8EUGbML+/D
         Pfas3ItHhBdswNR/Tfwyjpm1qhHNUmgFk7x4hAdL9X+v0YB43EohW5imALxuw2KEen7k
         hx9/6+g7CSJpqnCp1F7EquidWydXPO5LNPQAQtZwqDpHp86ID6pdUWIoZXu6tgT1+pXm
         3oKJc1I4pxlBQTA4U/04ae9kYOy9Nx4Lw65IdMxOkCSYqh7X/sjyahMhH69AWEwxYXXm
         g86Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nIhDAJJR+YXegWy/wL3i8yaBjUwW4vdjx7/rh4TvX9Y=;
        fh=C7/7vWcK6twxQpU0GSwpyvMZGnjC0KIpcrdNk8BpLYw=;
        b=h4mvaqnvScnbpXCygAvn3bZOSXdlpSy0RtBCKx3X73s9lDzxq/rtbj20LvMtMmgY2L
         /JMdedCrbpLRPvPymfAfISlKR7XJQCGu/NMqVqHcf5nIXjxAojr9nj3A6219DsWO/rKC
         Q8hcLMDJHrlcNaozOLSO+lA6ZKI6I06rjGhvtorzuoxiiFsuGxlqwExH6xWgOpeD4g+x
         Ky6jXKeoqCqXyUMyPAR5ixQ/KeqrMM4FjL2jV4sbgiNoWtStyzYR8+5go7qlNYACuahg
         4satUCEA8gWtNL+PHIJggXOoSdrixoqx8fc5ZkwZxb229pYep4MpV8vtMvPD88Jog5xh
         AYNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770774487; x=1771379287; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nIhDAJJR+YXegWy/wL3i8yaBjUwW4vdjx7/rh4TvX9Y=;
        b=USn2fp5Uk5U5KupGNLFg9U3l5SIg7VFN7JPXO0z6g5WVJpBgwhEttSiIyufnr5i8l3
         UjUTfG7grVZwqr1uPm2KpTRDeFCbnFmxnndAs0W4jhXlXXLsYoMF+Bg+pkCj30l0CaQr
         C53iXvWJgslcHkrRUaVET9win5ZymQC36CzoqC3y/CxVL/sySPcuMn6TN+mMCTLWHskt
         A6NsFE8QbxB3n8VK8l3mydLpnthedW3f9kN2v7GKVeAMVvidBYqgeLQL1vlv/xxIQE5Q
         pXUldrQDtS1V/QraMW9M8k+49RxjKD5iY4/j8QTbdc8SDGKb0U1NLzUQNdAK/GYXIlqa
         +ZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770774487; x=1771379287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nIhDAJJR+YXegWy/wL3i8yaBjUwW4vdjx7/rh4TvX9Y=;
        b=vC54FS/OkzP6EY0NcVO2d90oNWSLDX8vJgDEtSESzUeYQUtPPDZBBYKwD4dLMA6Wu3
         pP226nRPB0PT9a37N6Yk4QmlRAZEjVLpKB1YLfLyrbXaxWNGr3j5uZCZKKpXd5UBqxJG
         hQ2OkzTo9kVsa0yo8iSV0CvW7PbPYC0DszK4PN/piXM7vDtHRSOHABJHxHAEN8IpDvgZ
         7t2ClmDd4v3P0UXBSgnjPwIQyfntoBwzvZdY/fRFCnUqcbiPTTBw1BsF6ec7a0OghyCo
         GYbAGTQWHGnKHqJUNCnZyjX86mM7LOVxGoH/EygQARU62hjyede3rwslK35Q+OJmJpWe
         VTFg==
X-Forwarded-Encrypted: i=1; AJvYcCWzcK/+IQwBmwwwc4uM/IVLcegKPQfofKTcWZV6JF85w5iTT1VPxHJj7K8aoyngTGWc8CUU3EYC7A==@kvack.org
X-Gm-Message-State: AOJu0Yx6xWPO12nrV+batoOyxMn3H9fsNMaCxAVgvf8VjBdB/+pImEko
	cp5S+DyMA8kVFmuKqi2rb3Tdh+r1Ri/O+n470/7NVNWYhiwgeZkfSfx2GBdGLJo0ChBcjnS9MgI
	9hUQNSQQY/dWSXGm8jBfxxv/VOQTsQ0RlYeCxPpjN
X-Gm-Gg: AZuq6aKryjrcS4FZRS1/fxPvdH+pEsochmuzyRgVG01HIe03DKgs4ZWXApbUcry+HLW
	y+ogBw9sSnNv41m2d144IvVuK7NS8g/PdbQCzOgDk/VQrt+0nrf0kvgY9YgelMg35Ztb9RdvqRz
	KpvNl1kOtoWbPu5nS91me8se+TODbHobPxyYGdmv6bCpo7miAjs6bS4joC+orpECUzCFksSeMlk
	j+2Is+bbhbtV4jvtEOBTzrHGuf6gNOMTLcpvDYrJmn8mVk6vHzIcOC5//wESZZiH0U5zkpPkQIb
	0Z9M25oiTBC4o7Q8jTPsBz/LzPoX1/ULvXozvxxuT22D05U=
X-Received: by 2002:a05:690c:60c6:b0:794:d4c3:3152 with SMTP id
 00721157ae682-7952aaa7866mr322145887b3.31.1770774486955; Tue, 10 Feb 2026
 17:48:06 -0800 (PST)
MIME-Version: 1.0
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Tue, 10 Feb 2026 17:47:55 -0800
X-Gm-Features: AZwV_QhqlaaRHUZ_sLIEmaOa0r2FI4v1zw3ijD25N_cAxghl966m-JoOQmBSKPk
Message-ID: <CADBMgpyHw_kgb+Fc+h+Z3ytwMBwDG9B=yai=7g4UWP6AErE77w@mail.gmail.com>
Subject: Re: [PATCH v13 00/18] unwind_deferred: Implement sframe handling
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
	Andrew Morton <akpm@linux-foundation.org>, Florian Weimer <fweimer@redhat.com>, 
	Kees Cook <kees@kernel.org>, "Carlos O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6B346160007
X-Stat-Signature: 4k18fhbyyw9sx6n9otedd5kkp1wps7s5
X-Rspam-User: 
X-HE-Tag: 1770774488-513165
X-HE-Meta: U2FsdGVkX1+W1DqeAhsPxnOKLXek2tE4ubpBpZEf400iEBABqRvWCzkX+dJ7uclOMCvBLewXD6yM2ktc9y7+5LQMSMtgBJCIFwiZu1tlXzcJ0cLm3ZQlRR9YoNLNkpzePSx3LeTcnSTqCDJw9YAjnZk9quF8f0Rynwd10POBzn2y03+//Ce8Y0B2/4KSA63sKF59JLS93eSVZNdN7WyvpdoaNYoP4QSXpLTUoUPT+zWkx+lkcYUw3Q9UUz1zSc3odED/CB5UC9xwG2yOLTXh8ZLJt8DrAACk8xcGFh8XH+MQ69kgesovxCMkC3q28KgUCZYfCG/cCtG1Q4/IVrO7Jr2fFxg5P3xt1AEHA5fJHneV4C41sMtExDJdMkyL/5bZbh5d2e1Bu7xdyJd6YJshyXybylGpFJ37kW9QDXGVcDN63ds7iUBl3Y7+7nNncf28Bq8EXIAmy61vPJh591pBXblBFXWij+jedzZ1xzGYfMpwEGIBXb3cQ+/hYLTZjL+0aPIOXymqaU3T8cah6ztAN87BzbnXd6eIE/97nmYm5nzbJ+6LFmSTFAawGIghhkyPP9NplHxMUN5MfSi9E6O4xhLLQBRuoXJn97ymvljtDtdO/t6bHW7JpnPhHKUzlKnhfcQ4zbiwctscLXXOR3Mr66T8CoXUQwQ6iQqCTTxgRshBKh2oNA+BxGQajIan6Ez5cC//DR57BIGg9slzwlvtYDlY6Agbu6/Olc9t2/jkV+rT2FQzSm/ImkdT5Ytj2P0VMlQ7WEec9HBeta84KdBXHvqRbUCAjDiG5spjCp2KrPeYvkFiUp4+3mLLMoaEKWo6ISqBdFqMPgPBOythZ6iOYykx5LHDK0eTNAwtWbTm/rFNucbaQI35mN314fG2TWcf56YQjOurF+2oY54PBBSO5GGPhIpy122LStSIbU8KQMso2u0kDDVmZ7/iyPBFUgtSu13mt5quesPYyWp91u1
 E9d+XmIC
 rM/8+16WHlQvOf4IjqQU4TfZY1zoKkUdlFpBtWL4HZCfaryPAbTzbki+qohV35ngNlGmcRcNaqnL3rpO40ToH/61MBE6ntNKRJSnPQgMrREP8hMVo0HHMCVVuDh0UrXaadeImZMzQS7fqMW0zajEfMY/ELnX5Zsu6rnfw4UXaiRgylEjyGjPnPl6qMazfBfGFN+52Jszt0ms33LpBoMz5itW76PH5LKfZgONWvVfmmMlhRNfIO9DmmGezMltsbtvBHheFDL7HGxZ1BAZ9PlZMxculvUM3RnOqH35mEDmxBxS6l5hfssyuTbgIb2w5ud02A3NUFd9imyGPZxk2T7GivSUCjsXu4B8pNMMQudg06i/hl0DJQc5AfmgwulJHParA6MkweqIshjgiqeeJwR/QlxrC0jsOCqsc7RGR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 7:06=E2=80=AFAM Jens Remus <jremus@linux.ibm.com> w=
rote:
>
> This is the implementation of parsing the SFrame V3 stack trace informati=
on
> from an .sframe section in an ELF file.  It's a continuation of Josh's an=
d
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
> Another issue is that the format of the frames may not always be consiste=
nt
> between different compilers and some architectures (s390) has no defined
> format to do a reliable stack walk. The only way to perform user space
> profiling on these architectures is to copy the user stack into the kerne=
l
> buffer.
>
> SFrame [1] is now supported in binutils (x86-64, ARM64, and s390). There =
is
> discussions going on about supporting SFrame in LLVM. SFrame acts more li=
ke
> ORC, and lives in the ELF executable file as its own section. Like ORC it
> has two tables where the first table is sorted by instruction pointers (I=
P)
> and using the current IP and finding it's entry in the first table, it wi=
ll
> take you to the second table which will tell you where the return address
> of the current function is located and then you can use that address to
> look it up in the first table to find the return address of that function=
,
> and so on. This performs a user space stack walk.
>
> Now because the .sframe section lives in the ELF file it needs to be faul=
ted
> into memory when it is used. This means that walking the user space stack
> requires being in a faultable context. As profilers like perf request a s=
tack
> trace in interrupt or NMI context, it cannot do the walking when it is
> requested. Instead it must be deferred until it is safe to fault in user
> space. One place this is known to be safe is when the task is about to re=
turn
> back to user space.
>
> This series makes the deferred unwind user code implement SFrame format V=
3
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
> for testing ("perf record --call-graph fp,defer" and "perf report/script"=
).
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

Hi Jens,

Do you by chance have this work uploaded in a public branch somewhere?
I'd like to get a new version of the SFrame for reliable stacktrace on
arm64 patch series [1] working for SFrame V3, ideally with the SFrame
library in your patch series here.

https://lore.kernel.org/lkml/20250904223850.884188-1-dylanbhatch@google.com=
/

Thanks,
Dylan

