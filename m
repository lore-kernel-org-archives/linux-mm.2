Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40964C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 11:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E536B068F; Fri, 14 Aug 2026 07:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE6D6B0691; Fri, 14 Aug 2026 07:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD346B0692; Fri, 14 Aug 2026 07:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E42286B068F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:25:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A689A2B82
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:25:16 +0000 (UTC)
X-FDA: 85099643832.29.60968FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id E44EE20002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:25:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/GPuypn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786706714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iGbvfHlgSP6i/p5YackhX7x7lw84vSGfYX53QPffeiY=;
	b=jR+zLCFFpxpn8mEPeRGZt1CS/Flfo00sUg3HauDpOEidwcWu5n/XxmdNcE+MgrSl38TJ4c
	3fTY6N4+s9ioDs1auMQGBpWh/FdDL/h/KNjBNz+h1f3YlW/SmsBr+u6gByh947AHnwx3Pg
	DirfBKZNbR7oGK5O97VGqPDwRrD28cQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/GPuypn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786706714;
	b=mrK3fsEE3KvB3kTtS/rZqO8JxvjofYcPeX3lSOaPMBFtI9iey+2o/r4R5k1SwOhGxVfgFy
	K2RhPFziaXmVwAKSMa/Z9xq5loUSl6zeEdv9eseunfn2+N4/2IfQgGzWLm3qAls37fplb/
	0IEu0f1vZNY62A5v4psPa+2Kq4zCHI8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CC9A600C3;
	Fri, 14 Aug 2026 11:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFAF1F000E9;
	Fri, 14 Aug 2026 11:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786706714;
	bh=iGbvfHlgSP6i/p5YackhX7x7lw84vSGfYX53QPffeiY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l/GPuypngYE0cuBLyBIwF8eSrHmi8zxbkU5tTmJevGE/wyxqibICWbo5qoC7Shqmk
	 If8eqbO/qU6nhPZIEOuEPrOcoXvC7mvMx4VFRh4K3A+rp/QaHftQ49PWP7h/MOwu6B
	 WNegTo9BRro8GETKQX0425t4yySarTFxn9uGer/oSq62DpRXaUFMoKnn1PJ+v2YvFE
	 hz2wPBu3LoTvbl2ni9QK+DD65O5Q0Qjat6Cp03ULPCH1q6QmYjXJRo6nMxkUyL02qc
	 MTj67Ze8WrGZPo2/OBnqePYOz/V8lDhZInxy0itoZeq/pjYSIqrA1SQV7uxBGZHG3A
	 LEG0Z/7o1Zf8g==
Date: Fri, 14 Aug 2026 12:24:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, geert@linux-m68k.org, daniel@thingy.jp
Subject: Re: [RFC PATCH 0/6] fix nommu mmap and add nommu kselftests
Message-ID: <an74JAGcEuHXxr5G@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813063401.1786548-1-thehajime@gmail.com>
X-Stat-Signature: x7dtos85owwc37fq69ehi4z1bm5zomi7
X-Rspamd-Queue-Id: E44EE20002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786706714-213941
X-HE-Meta: U2FsdGVkX19Ph9hu3HeUutF9Z6cp+Yt3aKRgjPBp42RRzHuDsTs+KxDvR/8A/1xThLAeNrlZl4VvofAAvZp+9/Hj/XfkLOktXcMzurhpTkDqmPnoLvOZF3gSKI4wb5DG/Y/yAiQ12/DxPEkIJmx9g6+DdWXkhZQUSVEMivWhR3DSv9nhczI8cLmfaPIuc/5hS0qDVJcQdq1Jf3+Z7/uieZVO5hNUL+SyCb1fwl8/+YhgLn5dVvBf71PTn1yZyk7PkcX3/RXSOsP5+7nqxwVu4EsHUM8bbDZRIniq18ga4UxkFfxkfPhJCAugr8x1hisdhQHzacXRN7j48xNAmUgsrWNH7N/y28IezsdcNHskm5GJvVbjHb7t2ovtYAUS4vNV+z3RS03q1cAFKpDtWsXtGXtYGkcf+9xlAP+Bj/RlYWA3zlbzOpCQjwIJLSqwG1DEYQyqmzDF8MooidNMedlpHRrLq+/XhyXEKksL4zDb3J0DM/8abK0G9NxD6UVr553Yc/I0y5WmpIGlw5zBbuJTRERAeQo3wUu2rpsw/xs+gn8MuD867M3r3dRXhGCID3428noxeUroks0Hmx6uBWtgc0pPcfuAmFM9q9uLo+1QLqihgAHfulVmKintHnPXfjlaTDpeBR2gmq1AasGpEru6zQNBn1zyWve4r2tZR7QlBgT07C/8dA/qYoQs05SzSGg7PNnOXlJ1+BzMi8dXTgm8kjRrEys+Zs6fjGvJRg38qpTgZfgCryDKzmp2s/fRGyGapMpgv3iXER5cmWtTK6xNHV22T7D5YEaRhj5Gi6dnoh8/tudMmjIfVkKrlFTNwPa4RKCutua9oPwXMRSSsrLWhu4rQuRR6WcIoGKc/6kDILqczTWATOXE9+DkuFtx3bAf8YTBRzuY3XLzYWqgVLhkzhL1kXSTkFlzdTG/2k/Gx9FT/XlkUsHyqCU+gd4fxnmgDdhdcHLwXMT3IdHpTt/
 /aCyLRvG
 AVvg1MzAt2cE06lFqImyNaby9sPkCirndPgkGDsfdE9hdL1OUjzy8GUyu0V2kb+hh4E+J2oV1ciTEEKUt6MPJA/ZH19/BI5DNvnT1vW9WH0V1l2CanG6tvOx4yABUKSdwFJzDSWkvPjwmiPeNrbU6IuvaLgFlY3JVTVae6Eqgb1outNXIq+WXWdLBU79nrDkh85rjFzXQdSeDPmopRe9qFfK5n2RXDi3xeePWF8ofYxl5+ZZMFKtf5yPfKcOM8srO2h8d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Note on procedure - please do just cc- everybody on everything. It's a
total pain to pull down series

On Thu, Aug 13, 2026 at 03:33:55PM +0900, Hajime Tazaki wrote:
> This patchset fixes several issues on nommu mmap, munmap, and mremap
> syscalls and add test cases on kselftests framework, which currently not
> runnable on nommu platform.
>
> Fixes for nommu is to correctly handle error cases when vma shrink
> happens, and add calling .mmap_prepare callback on private mapping
> requests to fix the issue which we cannot MAP_PRIVATE /dev/zero file.
>
> One thing that I'd like to broadly ask you (thus this marks as RFC) is:
> this fix contains a dirty check of /dev/zero using device type number.
> Since mmap_zero_prepare() should be called before actual mapping, but
> some of the .mmap_prepare handler should be called _after_
> determine_vm_flags() as the .mmap_prepare handler checks the shared
> flags, we cannot use vma_is_anonymous() in determine_vm_flags() to
> check the file is /dev/zero or not.  So we introduced
> is_file_anonymous() for that purpose, which I'd like to ask your inputs.

Yeah I have plans for /dev/zero which will make it truly anon soon enough
:)

And I definitely do not want a predicate that tests for just this edge
case.

>
> And we add test cases to introduce kselftest for nommu platforms.
>
> Currently there are several issues if we wish to run kselftests on nommu
> targets:
>
> - it cannot compile/build test binaries because the current files mainly
>   assume to build with glibc,
> - some of the tests are not able to run on nommu targets as there are no
>   fork(2) syscall.

Let's fix things only where it's not too invasive.

>
> The first issue can be avoided if we can build static PIE binaries (if
> targets support it), but in our case (build on ubuntu/glibc and run on
> alpine/musl-libc), it fails to invoke due to lack of the GNU ifunc
> mechanism.  Thus, we need to cross-compile with musl toolchain, which
> needs to be solved the first issue.
>
> The second issue can be simply avoided, at a glance, by globally
> replacing the symbol `fork` with `vfork`, which is available on nommu
> targets.  Especially the test harness helper (kselftest_harness.h) uses
> fork(2).  But the issue is not simple: for instance, in vfork(2) case

No please don't do this, nommu is the odd one out and the tests should be
targeted at the normal case.

vfork() has entirely different semantics than fork() and we need to assert
fork() behaviour, not vfork() behaviour.

(Honestly it's completely bizarre that we support a version of linux that
can't fork() in 2026)

> parent process has to wait until children has done jobs, parent and
> children share the memory and children may corrupt parent memory which
> is never happened with fork(2) syscall.  `timeout` command used in
> `runner.sh` never works for nommu platform as it uses fork(2).

Yup again this speaks to the surreal craziness of linux supporting nommu at
all :)

>
> Additionally, the lack of test cases for nommu environment will (or
> already) become serious issues to maintain the codebase in the future.

But this has to be weighed against the maintenance headache of supporting
nommu stuff.

It's not right for it to force everybody writing tests to have to think
about it.

And already in the thread there's been discussion about a serious bug in
5.10 that nobody reported for _years_.

So testing stuff sure - but right now people (apart from you of course!)
aren't even doing boot testing against mainline AFAICT, let alone running
self-tests.

So I want the minimal changes that are not invasive and limited to nommu
only as much as possible, please.

> The test cases is implemented based on the document
> (Documentation/admin-guide/mm/nommu-mmap.rst).  The test programs is
> implemented with the assist of LLM.
>
> So, for the first step, nommu targets only support low-level API of
> kselftests (kselftest.h), and not supporting the harness tests since it
> uses fork(2) syscall.  This partially address the second issue; in the
> future we can refactor the harness test framework to be able to run with
> vfork(2) syscall but this is not the part of this patchset.
>
> Hajime Tazaki (6):
>   mm: nommu: fix do_mremap() to correctly update internal states
>   mm: nommu: use vma_is_anonymous() to check if vmas are anonymous
>   mm: nommu: fix an issue on map request to /dev/zero
>   selftests: fix build errors on alpine linux
>   selftests: run tests on nommu architecture
>   selftests/mm: add nommu mmap and mremap behavior tests
>
>  Documentation/dev-tools/kselftest.rst         |  12 +
>  drivers/char/mem.c                            |   5 +-
>  mm/filemap.c                                  |   6 +-
>  mm/nommu.c                                    | 235 ++++++-
>  tools/testing/selftests/kselftest.h           |  43 ++
>  tools/testing/selftests/kselftest/runner.sh   |   9 +-
>  tools/testing/selftests/kselftest_harness.h   |   4 +
>  tools/testing/selftests/lib.mk                |  10 +-
>  tools/testing/selftests/mm/Makefile           |   3 +
>  tools/testing/selftests/mm/hugetlb_dio.c      |   8 +-
>  tools/testing/selftests/mm/mdwe_test.c        |   4 +-
>  tools/testing/selftests/mm/nommu_mmap_test.c  | 294 +++++++++
>  .../testing/selftests/mm/nommu_mremap_test.c  | 583 ++++++++++++++++++
>  13 files changed, 1174 insertions(+), 42 deletions(-)
>  create mode 100644 tools/testing/selftests/mm/nommu_mmap_test.c
>  create mode 100644 tools/testing/selftests/mm/nommu_mremap_test.c
>
> --
> 2.43.0
>
>

--
Cheers, Lorenzo

