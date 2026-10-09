Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C03CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 13:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499E36B008A; Fri,  9 Oct 2026 09:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B2A6B008C; Fri,  9 Oct 2026 09:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361266B0092; Fri,  9 Oct 2026 09:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 108DD6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 09:48:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A4D2120394
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:48:23 +0000 (UTC)
X-FDA: 85303217286.12.F44510C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 196F720005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:48:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NB+Z9d1L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791553702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypDeMeZJLPxwre6yz/nCLAL+PwcGfFDDWHXhzCOWxEo=;
	b=cW5AYn9MbgsmzNgxJRH3comGkHAWGL/EkosqH1vIRn6TxJnkLuyZjku21Uq/Zp9CvMaCRf
	HdBAAC5mxq/+EfS75hpTRS5b2SNOLGP/Or+NSavotNlypruRtBYYfdV8cm2H+XlzLo0dvV
	i8sfcHz5dOG9f2YpqfIdDw9yRnGLkag=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NB+Z9d1L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791553702;
	b=ePotqpk/sxkGIo3AykxO2ys5EOfwOuDIaisLZYtrE+BqK6FhOXtGS7WmTUDTLqwXIad5AT
	bl9jUrIDnB2D8/ydRzqT86XGwgpKF0DF+HZZ+Bh1qnyIeEkt9PtyfovRlNi1xoXCptZfin
	0h/hOgsZ3U7mQhHndP0QoUz2unzIYns=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EC9660A55;
	Fri,  9 Oct 2026 13:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A1E1F000FF;
	Fri,  9 Oct 2026 13:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791553701;
	bh=ypDeMeZJLPxwre6yz/nCLAL+PwcGfFDDWHXhzCOWxEo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=NB+Z9d1LZuVZWRBPyQGsHHAAScPkvF/MiEXoj7IGJHVlow15ypjOTorNMeqgogBGp
	 fZCBw1s+pyvGzqSjdTORcWrmWP2nCsTSkbeXMAHlC2uOeSdjYVpAq5hDhUwTG0uzlC
	 ZIxhiIJiXWf3qGBpiIxPy7mkY2m1592Vd8NAbbkRN7HTL1JXN4CQzRCR05Gi1W4RzU
	 l6hpwW13gxnAZM3iWiqDnZJOsVfjIeaJK3dm2BUgg4zDXc8T/mQlE/ZM2Tsy2b/RXU
	 nJAZFCf6oLMOfyKVVOcLDxgVyUe/m64q9HzBg6+dvhVzYRuiyk67XNwSYr1dU9++va
	 CQgImH3htHvNg==
Content-Type: multipart/mixed; boundary="===============7130068563077650387=="
MIME-Version: 1.0
Message-Id: <d095fa11023a62ea9585d55d6bc25e390944508d5b00bae0a1913176e830d086@mail.kernel.org>
In-Reply-To: <20261009112308.240769-7-zhen.ni@easystack.cn>
References: <20261009112308.240769-7-zhen.ni@easystack.cn>
Subject: Re: [PATCH 6/6] selftests/bpf: add tests for the page_owner bpf_iter target
From: bot+bpf-ci@kernel.org
To: zhen.ni@easystack.cn,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,akpm@linux-foundation.org,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,brendan.jackman@linux.dev,hannes@cmpxchg.org,ziy@nvidia.com,shuah@kernel.org
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,zhen.ni@easystack.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri,  9 Oct 2026 13:48:18 +0000 (UTC)
X-Stat-Signature: e47ci5ny94wdhgb7otogtrc3o6q4ns7x
X-Rspam-User: 
X-Rspamd-Queue-Id: 196F720005
X-Rspamd-Server: rspam08
X-HE-Tag: 1791553701-445375
X-HE-Meta: U2FsdGVkX1+07fRd4wOduotYmO0fefIrGZF8jZTDo3v+5op6e5gf7BRGNqd/PjgDvBg6jPLq4JNhfAH0ujDTwM5yRaA2oy0ble60FjVImD6d0x7Z+OVGkdDAV7mMnMrVbAow8sJxOGGOm1ReaL7B2LhNfWyrSpRWvSCOgG6pW+tFFiXFgwFpiGnJe3KgT2+64mFR2hy525Y7Six+duGvfhiQQ6ZKt07rwwSnZb076WelF7McyqBI4qGrzwEQIT4zchQ+45XaaK0EUZM1QYwrfdTBUSF7lPFjsLHR45jAfj/Ul0yiNBGOZ48CXNmSn91fHlLZcYI4/WVYbKM9ZDtAtXBfoiuMjJSXNPGlw3OFbRbS8sOkrkBR1eHRa5iCAvQ8eicyaRspIgDJ6+lRW/SkWrGRnfk5IvwFu983SzI4WZTzb23yAUezisZYLyxLw1WCTRGS/kzkZvy8rMnmNlCRIvM29cpejipsH14sM3X05Qb8YlJm8+0nEuPsjq4jkY5v/E/A5lpYmEyLaMBd2H/DG/KJzkaBYnLShSAPp5GK8okxGz/zosK81WfLlAV34wjU+Be+KXqDKw/SvIUg3iIhQC5DMYBOVlw8Po88EgkRAvqcenVhN6eKdewbklMVTvmoJ+KmQpUCq05Jxt0VoKONEuP7c41Xz5WVBfWS3CCpF53SP+eUrLYrw7LWpTDhYrCgeNqWPcPWOX8mCPvbmPcOMjFLf0f3BL5bhkaOHc86f2Q4b6rLJlkWUHUmCtbL2vGjCsQuLmMneeXDd4PErUXGKHnnJHCVKd8XnV1kIoybkYQhaaj/O/BHCYpO5VcZUtMW5iwNEq2rsqduQG1cWon8gGeviMHNmcjstKe+DFaa+kgNSB9MmvSFY2nDD5pD3H03a10qoRD/Or2ySyDnx5moOCSnt69dreYOjQ+qWyj8gCbuUxfeohjd//u8Et4fMumD4xIST0583KKhKc6zMks
 AbbDTn8e
 xlbfy5dPPk0+3OaEjmAZj/gt2knw8BygSh4s496ZMeQGBLW+j+wwOn8z3+CfmpZhWDw0NBgRNs9YK+PSFKFhuXJCCNKF4wcR4o5qqjTm5I6dJ18ubQv4qQPkPfpqtdZjyyG0MomEvGpebIrxfvWa9sverWfhzs0KB9IGFBMkKzZ6lNfLM5lLAW/kVhwj6ttpJaPwpabE5NONgNS0rCjNVoiM8KKZjVDb04m1OHk+U3IdJBJ5DnRdel00li8b3/bmZMSZpvfC0x5tlR8lur2E7h61wAX+EvgwHjY9RRhZNewqKwvYjPdsfyXzp77CpuXs4u8MGSSQ87r+xQoSTsteRpBtgVHPK4berML62h4V9gfQAFGknGnGy3CuIvukYFq7z5Yzp+A1N36OItXlpYEM+gX26vDv812lwX8TeyJa9WtRbLg+fFHBS4PAPfHffOTqEfXzwEPhX7Q5jBqqsGVwWJv1CJEQXK1UmICFWVGCAjncMc1ko+4QZhVa1ix1qxDo5WPqCQScne7VfnYaYkYmWu8LlGXW17yKRBGXB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============7130068563077650387==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: add tests for the page_owner bpf_iter target

TL;DR:
- Selftest BPF program may fail to build, breaking test_progs, if
  CONFIG_PAGE_OWNER types are missing from vmlinux.h
- Iterator read errors (e.g. -EAGAIN) silently end the test as a pass
- Skip gives no reason

> diff --git a/tools/testing/selftests/bpf/prog_tests/page_owner_iter.c b/tools/testing/selftests/bpf/prog_tests/page_owner_iter.c
> new file mode 100644
> index 000000000000..a621712272bc
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/page_owner_iter.c
> @@ -0,0 +1,173 @@

[ ... ]

> +/* Count link_fd output lines; -1 on error. */
> +static long iter_record_count(int link_fd)
> +{

[ ... ]

> +	f = fdopen(iter_fd, "r");
> +	if (!f) {
> +		close(iter_fd);
> +		return -1;
> +	}
> +	while (getline(&line, &len, f) > 0)
> +		count++;
> +	err = ferror(f);
> +	free(line);
> +	fclose(f);
> +	return err ? -1 : count;
> +}

[ ... ]

> +void serial_test_page_owner_iter(void)
> +{

[ ... ]

> +	if (!page_owner_available()) {
> +		test__skip();
> +		return;
> +	}

A subsystem pattern flags this as potentially concerning: a test that skips
silently, with no message.

test__skip() takes no message and nothing is printed before it, so the
result is a bare skip.  The page_owner file only exists with
CONFIG_PAGE_OWNER=y, page_owner=on on the kernel command line, and debugfs
mounted, so someone reading the output cannot tell which of these was
missing.

Other prog_tests print the reason before skipping, for example in
bpf_iter.c:

    printf("%s:SKIP:no __builtin_btf_type_id\n", __func__);
    test__skip();

Could this print why it skipped, for example that page_owner debugfs is
unavailable and needs CONFIG_PAGE_OWNER plus page_owner=on?

That said, test_progs still reports the test as skipped in its summary, and
many existing prog_tests call test__skip() without a message, so only the
reason is missing here.

> +
> +	skel = bpf_iter_page_owner__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "bpf_iter_page_owner__open_and_load"))
> +		return;
> +
> +	/* --- seq file iterator: unfiltered run --- */
> +	skel->bss->filter_en = 0;
> +
> +	if (!ASSERT_OK(bpf_iter_page_owner__attach(skel), "skel_attach"))
> +		goto destroy;
> +
> +	link_fd = bpf_link__fd(skel->links.dump_page_owner);
> +	iter_count = iter_record_count(link_fd);
> +	if (iter_count < 0)
> +		goto destroy;

If reading the iterator fails, can this test still report success without
running any of its checks?

iter_record_count() only records an assertion failure when bpf_iter_create()
fails.  When fdopen() fails, or when getline() stops on a read error so that
ferror(f) is set, it quietly returns -1.

The two callers in serial_test_page_owner_iter(), the unfiltered pass here
and the pid-filtered pass below, then do:

    if (iter_count < 0)
        goto destroy;

Neither calls ASSERT_*() or test__fail(), so test_progs marks the test as
OK and skips the unfiltered, filtered, open-coded and memcg checks.

read() on a BPF iterator fd can fail with real errors from bpf_seq_read():
an ERR_PTR returned by the target's start()/next(), -E2BIG, -ENOMEM, or
-EAGAIN.

The -EAGAIN case looks like a likely trigger in the pid-filtered pass.
There dump_page_owner() returns 0 without printing for every page that does
not belong to the test's pid, and bpf_seq_read() returns -EAGAIN once
num_objs reaches MAX_ITER_OBJECTS (1000000) while offs == 0:

    if (num_objs >= MAX_ITER_OBJECTS) {
        if (offs == 0) {
            err = -EAGAIN;
            ...

So on a machine where more than about 1M consecutive iterated pages do not
belong to the test process, the filtered pass would end in a silent pass.

Should these error paths fail the test, for example with ASSERT_OK_PTR() on
the FILE * and an assertion on ferror()?  Should -EAGAIN be retried rather
than treated as an error?

[ ... ]

> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_page_owner.c b/tools/testing/selftests/bpf/progs/bpf_iter_page_owner.c
> new file mode 100644
> index 000000000000..fada6a314a15
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_page_owner.c
> @@ -0,0 +1,161 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2026 */
> +
> +#include <vmlinux.h>
> +#include <bpf/bpf_helpers.h>

[ ... ]

> +SEC("syscall")
> +int scan_open_coded(const void *ctx)
> +{
> +	struct bpf_iter_page_owner it;
> +	struct page_owner_scan *scan;

Does this program build against the kernels the BPF selftests are normally
built and run on?

The program needs several types from vmlinux.h: struct bpf_iter_page_owner
(declared as a stack variable here), struct page_owner_scan, struct
memcg_info, struct bpf_iter__page_owner, and struct page_owner (dereferenced
as po->pid and po->comm in dump_page_owner()).

struct page_owner is defined only in mm/page_owner.c, which is built only
when CONFIG_PAGE_OWNER=y (obj-$(CONFIG_PAGE_OWNER) += page_owner.o in
mm/Makefile).  The new iterator and kfunc types live in the page_owner code
added by the earlier patches in this series, so they are in BTF only when
CONFIG_PAGE_OWNER is enabled too.

CONFIG_PAGE_OWNER is default n (mm/Kconfig.debug), and none of
tools/testing/selftests/bpf/config, config.vm or config.<arch> enables it.
This patch does not touch those files either.

The selftests build compiles every progs/*.c unconditionally:

    Makefile.skel:
    BPF_SRCS := $(notdir $(wildcard progs/*.c))
    BPF_OBJS := $(patsubst %.c,$(RDIR)/%.bpf.o,$(BPF_SRCS))

    Makefile:
    $(OUTPUT)/test_progs: $(RUNNER_PREREQS) $(BPF_OBJS) $(ALL_SKELS) FORCE

vmlinux.h is generated from the VMLINUX_BTF of the kernel under test.  On a
kernel built from the selftests config, this declaration fails with an
incomplete-type error:

    struct bpf_iter_page_owner it;

and ctx->po / po->pid fail the same way.  That would fail the whole
test_progs build, not just this test.

In the tree this patch was checked against, the earlier page_owner patches
are not present either, so the file cannot compile there at all.

The runtime check in page_owner_available() cannot help, because the
failure happens at build time.

Should CONFIG_PAGE_OWNER=y (plus its DEBUG_KERNEL dependency) be added to
tools/testing/selftests/bpf/config?  Or should the program use local type
definitions with core relocations (___local flavors plus
bpf_core_type_exists()) so it still compiles when the types are missing?

Also, pageowner_init() creates /sys/kernel/debug/page_owner only when booted
with page_owner=on.  Without that parameter the test will always skip on
test machines, even after the config is fixed.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/37933988642
--===============7130068563077650387==--

