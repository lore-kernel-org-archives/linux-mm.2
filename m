Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8A1C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 07:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD6A6B009B; Thu, 20 Aug 2026 03:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385376B0095; Thu, 20 Aug 2026 03:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272386B0098; Thu, 20 Aug 2026 03:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBDCE6B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:05:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04A9F40694
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:05:23 +0000 (UTC)
X-FDA: 85120761768.02.2753773
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 65C491C0003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:05:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oxz7uuCd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787209522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4C4ZMUR5H8zP5phSMEeaZLLChga4fEuuYPg/hQGsKQ4=;
	b=XaV3i9Wizu/zc995HhyTUlyR9Z1U64RWA+1iu+nUvTsRQAScxSI4usHyXBmtL9RLhnJ4te
	Rtci25sLloBe5KLtOzPQjAohw6y1AGqoPD1q+Zek7SgiZL30gebDs6d3PctDsfgiPUlkIL
	x16dV52yxdc3SYTFPRlNTQuGoD20KpQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oxz7uuCd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787209522;
	b=6oi4jyswqU48GBNToet4TeRf0IsTBo4yJ//yooAhOgWaoMkDqzXlZr6N9RGv6fsbfKSeHg
	j6SlOaPjbA9ypoJb6gZQ+GJ0JWQYqztovg9HGyeEJSEDmf7tR95lqx+V5Z0lxlM30iiUv/
	MbkBUXMBWM5dF39s4xxCGuMPUuAtw10=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A8F84343D;
	Thu, 20 Aug 2026 07:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE65B1F000E9;
	Thu, 20 Aug 2026 07:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787209521;
	bh=4C4ZMUR5H8zP5phSMEeaZLLChga4fEuuYPg/hQGsKQ4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Oxz7uuCdKuBg4JDl2r5Ud4goEYYL6kYA0c7Ifg1NBixxeYNYii8XMmWfpKFJreNws
	 2Y1yY3zGntWMDU/74/JEJa+Svg0edsrPFPciEi22PZBUy7EXjUK0R3h+poqHi3nhbV
	 HrZF0zih5fmHFEkt5x5JovFaVz3EbVq86imPCnwcXGdGqXpbgns9pTxY9zKNV+SviL
	 YJtonnHluBnZfKNFF71RXnqLfO9XpYtI9jOVL37symJmdlazvbLE5dUIkfJMM9GPC1
	 GVPIJW/XcBXj7IE4bbtNqwlFb6ML0NauTauWckwS1hlR0jq0UigNZGE3BlRTp4fFFa
	 k0OI3mqLe0PRA==
Content-Type: multipart/mixed; boundary="===============3588420820797333624=="
MIME-Version: 1.0
Message-Id: <046d6c5701bd2b2cd5c5e7c2bc631a114adc20842f9a0c27a273b56fc1014a55@mail.kernel.org>
In-Reply-To: <53762e3403fe8e8c263cf685cea5d55377ec5204.1787205002.git.zhuhui@kylinos.cn>
References: <53762e3403fe8e8c263cf685cea5d55377ec5204.1787205002.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v4 2/2] selftests/bpf: add memcg async reclaim test
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,andrii@kernel.org,eddyz87@gmail.com,ihor.solodrai@linux.dev,ast@kernel.org,daniel@iogearbox.net,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,baohua@kernel.org,geliang@kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 20 Aug 2026 07:05:20 +0000 (UTC)
X-Stat-Signature: wxeg3tbhcedoxmpi1m8wg3h6p3zteeam
X-Rspamd-Queue-Id: 65C491C0003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787209522-613436
X-HE-Meta: U2FsdGVkX19jXkuvAm5FvMby+uHl95N69WRICJ58sL/cj1/XqUk9BP3z0O7MdWp6Vhx4mGMVzxj1+1xg5Iv4iuyVeaEldTR4irVtd6LK/TZrxS2ggYP7V//lBiAMfJXNu/1Q1Rj2kI+XKg82vMY8YMyV+PYvtfRJGcYnkdYAYR3lt6T151XTk5AJ6z7lPmaBzB2lAEucsBmXXraEJIoYGLZBx9Lm02tAc6HfviWo2/Y4jyh6xZzThG6KOymYjrgOn6isAPt2iVLSK7FoQQ1DEXxg0lTCxYm+fzUwHOxmOJTgl8LokcLQ3rdKDjDRCcYHn+akwIq8lHCzJmXrfzxsInIr5wluTT+0ELU3PWgv4UPfOMdGw81ZxSe6JSMpjYaDX+oLofhmloyyon+WKNdFF5xBC7ZeExy2MM3Cbsw201Ol8RsVeSOUflTQ/uWK8znwiTMrbr719L4Oq1FFtodCcnPn9HBrt6Ne8kajNJ/7QOljEWAomuPpnGk0Y231riSCzqF0vC6rMlKJfh0shyXmSBO09DUaXSTWMGMt4yIDUnD2aohfEfrvSarbWYKoAel//K/QH+X3x0IEkaSXKRnVcS4ZiCssk0LPXO+jAfo1qHa8LHTWVIfSmi7d0b+e/9OPbxQeOHa/IaHSHxT1yQ84loNjparWtts0emFLPsV+KmySL1uE/M6q1PfK+V9va667MHuQuViK7Jj24fo1Hr+CgNnkMnohOiWXV/lV1xkZVvo4zoiNpSjfYFHDEwbTQacz8Ifq75k2Z8DvNNQ52vZZkKyKQLBzKDoOkWF4cETSyeV/CMovXJjEplbKguyV7uaJVFh76KqKTvPTKHkFfEOciN706xzZZgIA7RjM9Xi6epJbQHtC05y+Apqk8rJ9hzPe3RmEFIy47Oh1qKvvfWwhfumZv4+5rEJLdNEg0aQOaiQsh6/caN/fYG8kNWVujwwOObKnlZAbb+BgEJnXnbN
 ZXG7hwlh
 b+i0TggL7pkHYtjVa89xWbjgJYtW5UN2O++eJn+wfu39mKUE7gtWs2zONFfrW+uYOAJ9lu2riZB/TLdeb2F1KUB4TMOX3i7wWhL7AyLrXpSrddo5uKEoo5tYdwywXSAOR6CxQRB45KjJRsoyw/HtO8tKevLSmC9jS41St/0RMB7O4ZeQ3tvWYTg9WLQiy1pSnqQqRM4aWyNcXQtKd6DulWeDyH5/YB+2+BLrxcxEa3plGLi5uqGmExmNMViz1LCGAGUkg9YXWJN8ZqTN6qs+1hM5EtLdkwO9X2GF+P1JTZwdHcNYhKVK6D7YMHD8PHyhZ4sL2PL18lPkSYSgFOsPZPhnuUkEFQNjyTVfnpwl+qo2OD4Jxiqe7mca8MwTEDK31wuIBOivQwFOClxqxwmfwoHgSgjkVCBUXDpV5/UXhrCSTtvtchbcpccumFAbuBZcktxCaXFNX4rE0PGNYNMo0Dh3yCwgoT+1TGezU9E790TAWA6W9uwUcO97sBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============3588420820797333624==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
> new file mode 100644
> index 000000000000..ece7bceaab3c
> --- /dev/null
> +++ tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
> @@ -0,0 +1,480 @@

[ ... ]

> +/*
> + * The workload files must sit on a regular filesystem: with swap
> + * disabled for the cgroup, tmpfs/ramfs pages are unevictable and would
> + * OOM the cgroup instead of exercising reclaim; they are also charged
> + * as anonymous memory, so they never raise the WORKINGSET_REFAULT_FILE
> + * events the BPF program monitors. Fall back to the current directory
> + * when /tmp is backed by such a filesystem.
> + */

The comment states that tmpfs/ramfs pages "are also charged as anonymous
memory." Is this accurate?

Looking at the page cache charge path (mm/filemap.c __filemap_add_folio()),
tmpfs/shmem folios go through folio_memcg_charge() and land in
NR_FILE_PAGES/NR_SHMEM, which shows up in memory.stat's file/shmem
counters, not as anonymous memory.

The reason they don't trigger WORKINGSET_REFAULT_FILE is different:
shmem folios are swap-backed, so folio_is_file_lru() returns false
(include/linux/mm_inline.h), and workingset_refault() accounts them at
WORKINGSET_REFAULT_ANON instead (mm/workingset.c).

The conclusion the comment draws is correct, but the stated reason is
not. For a patch aimed at the mm/memcg audience, could the wording be
adjusted to reflect that they sit on the anon LRU because they are
swap-backed?

> +static const char *workload_files_dir(void)
> +{
> +	struct statfs st;
> +
> +	if (!statfs("/tmp", &st) &&
> +	    (st.f_type == TMPFS_MAGIC || st.f_type == RAMFS_MAGIC))
> +		return ".";
> +	return "/tmp";
> +}

[ ... ]

> +static int setup_high_low_cgroups(u64 *high_cgroup_id, u64 *low_cgroup_id)
> +{
> +	int ret;
> +	char limit_buf[20];
> +
> +	ret = setup_cgroup_environment();
> +	if (!ASSERT_OK(ret, "setup_cgroup_environment"))
> +		goto cleanup;
> +
> +	ret = create_and_get_cgroup(CG_DIR);
> +	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_DIR))
> +		goto cleanup;
> +	close(ret);
> +
> +	ret = enable_controllers(CG_DIR, "memory");
> +	if (!ASSERT_OK(ret, "enable_controllers"))
> +		goto cleanup;

A subsystem pattern flags this as potentially concerning: the test
treats an absent memory controller as a test failure rather than a skip.

enable_controllers() ends up in __enable_controllers() which writes to
cgroup.subtree_control and returns 1 when that write fails. On a kernel
built with CONFIG_MEMCG=n or booted with cgroup_disable=memory, the
memory controller does not exist, the write is rejected, and the test
reports FAIL.

The feature being tested is CONFIG_MEMCG-gated: mm/Makefile builds
bpf_memcontrol.o as obj-$(CONFIG_MEMCG), so on such a kernel there is
nothing to test. Note that 123 other prog_tests use test__skip() with
a reason string for missing capabilities.

However, CONFIG_MEMCG=y is present in every per-arch BPF selftest config
(config.x86_64, config.aarch64, config.s390x, etc.), so BPF CI will
never hit this path. It is only reachable with a hand-rolled kernel
config that omits it. Given this context, is the ASSERT_OK() treatment
acceptable?

[ ... ]

> +void test_memcg_wq_async_reclaim(void)
> +{
> +	u64 high_cgroup_id, low_cgroup_id;
> +	int err;
> +	double high_time = 0.0, low_time = 0.0;
> +	struct memcg_async_reclaim *skel = NULL;
> +
> +	err = setup_high_low_cgroups(&high_cgroup_id, &low_cgroup_id);
> +	if (!ASSERT_OK(err, "setup_high_low_cgroups reclaim"))
> +		return;
> +
> +	err = setup_bpf(high_cgroup_id, low_cgroup_id, &skel);
> +	if (!ASSERT_OK(err, "setup_bpf"))
> +		goto out;
> +
> +	err = run_high_low_workload(&high_time, &low_time, READ_TIMES);
> +	if (!ASSERT_OK(err, "run_high_low_workload reclaim"))
> +		goto out;
> +
> +	/*
> +	 * The timing comparison below alone cannot distinguish a working
> +	 * reclaim from a no-op one, so require that the BPF program
> +	 * actually reclaimed memory from the low cgroup.
> +	 */
> +	if (!ASSERT_GT(skel->bss->reclaim_calls, 0, "reclaim_calls"))
> +		goto out;
> +	if (!ASSERT_GT(skel->bss->reclaimed_bytes, 0, "reclaimed_bytes"))
> +		goto out;
> +
> +	if (high_time >= low_time)
> +		PRINT_FAIL("high cgroup not improved with async reclaim: high_time=%f low_time=%f",
> +			   high_time, low_time);

Does the zero-margin wall-clock comparison make the test brittle?

The test's final pass/fail criterion is a single-run timing comparison
between two symmetric workloads with no baseline. PRINT_FAIL() expands to
test__fail(), so this marks the whole test FAILED whenever high_time >=
low_time, including on a tie or a 1-microsecond inversion.

The two children are symmetric by construction: run_high_low_workload()
forks them within microseconds of each other and both run the identical
real_test_child_work() body (write a 32 MB file, then read-fault it 50
times) inside sibling cgroups under one shared memory.max of 32 MB.

Which one finishes first is decided by page-reclaim ordering, disk service
order, CPU scheduling, and host load. The test pins only memory.max and
memory.swap.max but does not pin the reclaim implementation (classic LRU
vs MGLRU, selected at runtime), the dirty-ratio sysctls, the CPU count, or
the backing device.

On a machine where the BPF-driven reclaim of the low cgroup does not
translate into a measurable ordering advantage, a fully correct kernel
reports FAIL.

The comment just above acknowledges that the timing signal is weak. The two
ASSERT_GT checks on reclaim_calls and reclaimed_bytes are deterministic and
verify that bpf_proactive_reclaim() actually ran. The timing comparison
adds no deterministic coverage on top of them, only a nondeterministic
failure mode.

For comparison, prog_tests/test_overhead.c is the only other prog_test that
uses clock_gettime(CLOCK_MONOTONIC, ...), and it only prints its
measurements. Could the comparison either require a substantial margin, be
bounded with retry logic, or report the ratio informationally with
fprintf(stdout, ...) instead of PRINT_FAIL()?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32339450346
--===============3588420820797333624==--

