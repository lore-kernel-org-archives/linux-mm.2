Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 291D9C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281FD6B008C; Wed, 19 Aug 2026 03:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259CD6B0092; Wed, 19 Aug 2026 03:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197AF6B0093; Wed, 19 Aug 2026 03:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAAB46B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:16:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A75FA2FB4
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:16:47 +0000 (UTC)
X-FDA: 85117161654.02.E0E06AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D3F0D180004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:16:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OUajSmkx;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787123805;
	b=d09rnNda4Eu5i1lmzmZEyWCjlueXJKFNYVrzhiRh3zwFb5xlNdof4LySPEis1LqgMKuJag
	l7PnZ0m6C6ce/mxaF56g4TCFpTUxcuy6RXiKfb4CFvgMuQnHwgaOQdvDguWTz3adnbCKdS
	yDV9lhibd3I/1d5JxbI2TSJR+K7UINg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OUajSmkx;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787123805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RR+5oC+JwEK6fu7HwCFjTcfa8i7lkxeot1UpnC7rJoo=;
	b=W1GWfJog18XSIkXr8KRn6NKl4ajdUQ8sk5ecqsygvMz0cZfnB/aO18KDrC/Wqc01V0Hqwn
	VWCPRD191yMxYXYiYL4zM+jsWGN473iTcsGkH2llrM+QePEqhsBdzuuc6baHKgUtO0uVU5
	S0R0LUrs7XOqBANPJlVqj5IMHT9Ae4g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D8946020E;
	Wed, 19 Aug 2026 07:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA801F000E9;
	Wed, 19 Aug 2026 07:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787123805;
	bh=RR+5oC+JwEK6fu7HwCFjTcfa8i7lkxeot1UpnC7rJoo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=OUajSmkxxgSJUvX0P3OusAk2BNV325fQGca5SN3s6/V96Ce7eVvnOpfFSlVJvY7gP
	 OLcbdjuecaEpIX33FG0TYzfccpcbsV0SvqQc5MWsmJp0uPnerx0TagmFMK9ymEnYiA
	 P09sk8Yo8t/5tpF28Wlzg7TG4P/q6i/GAweT6P4vZ6CsPHMmtO/cNaaSinWR6j8ssD
	 HTsJ/JlwyRikT9jGp7qo871NF8cVqf7euQ+s4rzjU1XLmlV4G/guYGXoemlvLEcPAm
	 VeyDGQ1E3bMml5Vs6ILfRTTw7ikvwENUI5AvsezA1RfyjNQxaJ2MpGt5DZGwpSXP0s
	 IKr9uYWiZdpfA==
Content-Type: multipart/mixed; boundary="===============9008457374577010211=="
MIME-Version: 1.0
Message-Id: <1a9245ed6391fb99efab25910fda1e140d54305c58a2ffbaebb785010c0a9f26@mail.kernel.org>
In-Reply-To: <052d445fe9d7741729447f1b90277dcdc6541b4f.1787120833.git.zhuhui@kylinos.cn>
References: <052d445fe9d7741729447f1b90277dcdc6541b4f.1787120833.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v3 2/2] selftests/bpf: add memcg async reclaim test
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,andrii@kernel.org,eddyz87@gmail.com,ihor.solodrai@linux.dev,ast@kernel.org,daniel@iogearbox.net,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,baohua@kernel.org,geliang@kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 19 Aug 2026 07:16:44 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D3F0D180004
X-Stat-Signature: mhbnxdhpaqdcc983k9jkms7eft8gmmqh
X-HE-Tag: 1787123805-130643
X-HE-Meta: U2FsdGVkX19wtiRAPenfkRcwTLuGmGcvB2uRlOFB4Ko3cDMG4hFgQwBrlrP4eL4uJUbAT+wN1QWcU41ALSzZxVfstcF3l1e1BYM5zVZ/A5k+8TWEpBndY6krXTTvlTcio7FoDSMYDtiaEl4kdayM2z0GdHQRRjKU0Bt3nzpwd7C9ZaPuHtKzOLs+QOf8JkU/l8EOnEj3uaLWBfk7+2/eJ4B2UFwgWG3bFBfsTG3BTK921h3OrW72sVG83nNCvQ3XpBTFlcTz5Lh7ff/oVPyy7eJ+xrbi0TrhrOH7NQ4SMIjLKrqDcaRLKgBgjU3Obtx9jx0OoVOoGqW8QV5C7mXKbcFY3/ETI1jvEMFNZssCzHc35AzMR8v1PWpPvlKMFs1U/2IqspEdnvena6jm9tbb4+2g7m8iTNQA5yFbsRsxvGhRKc3V3pFy0PCsnGZzMohdx7Q2DlKE8wLxgizZP/N/9zuqlv0LHHKo6w4TFexhAy4+OLUkcgmPvX8Bh5fP55dXUsFY7b2DdFGSwRIMb1Ns5XlhVoa3Alx0kT8OJjvmxHPfXloO5tcybft/Dq27ZqW+mSzU52zFEigJVMfGWzyEjDRP2G4Yiol6ndsX39a3xKXtdqTk0zoW02yZ8f8M22smzqHC2SC9L3KCH6fwRaHgf8cF88dWDkI+WV6b/KOmdUcAAykTGp3VstM12yOfNVEAKzj7vF/OEGCd4CznJH9ZbAqUuvvGGs+AD5XI4FxjFU7TLnieqcL5L+B6n9U0Rh+1uEkwNWhl4DQYoLzVWJbGOGSh2flv6rx4W73M73En/+4ba343ufbiRUKyEKt/rfOPjc2HnGE9zJTX1DMlbCVFEcecEOjaJFG/+5bcM1FBYY1XYQ7We8QxJCh1Dis9MYcSLS6lYmw42L3JwQGI65sD+fWOxE8NbzoPfbMXzaSV1SeIhggdEFWI7EwG8A6Rzz3rKsyJoy/zcnBFzsbuObJ
 +q/ePOG+
 YLk7gbumb6ESmuIBLfB6mEZ5jFWtx8b12it6gOnYnhH0etAJNuI2XSacGWjDfpX1jr0E6Wc+dPAV2G3tVTcb3g2r4aHDdFZ4kLfwU0zzLIV9vFLjm2iKUxm9J2ys1w8j1cGXYCdggan2iFH6VQZCPYp83/4RWhUU9h8K8PlfpcTtbcHX7l5Hiu4A1DZAE92SFmI8oiGXQha2AOxa+5nfGbUFceeuTVrzVsEueRwtyrJGHUJkuuaLXZ1sP8aP2OwPtyfYQiLi2CvOopuOVENVW3uJCBMOi50CnMavRSoTudE5A4EYHCPv361Bpw9KbLQoUhUmNIQwsjwwh8vK3K4xc/1g0qQNQ3eZlBc4HvOEz3/z+G8/EKvnsNPwoKiruNt6Mz4DL3UbwnvmHbdTNpoiCbr3Mye7LYsrt7orL0e0psYGa5uNenPuG2IavleifSfe928CWQ5vXIU1potSjnR1kCcxzF/1aen8Tb/b+MdIv2yJm1h3bvLzCGk+c/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============9008457374577010211==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
> new file mode 100644
> index 000000000000..e990d1fdc79f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c

[ ... ]

> +static int
> +run_high_low_workload(double *high_elapsed, double *low_elapsed, int read_times)
> +{
> +	char high_data_file[PATH_MAX];
> +	char low_data_file[PATH_MAX];
> +	char high_time_file[PATH_MAX];
> +	char low_time_file[PATH_MAX];
> +	const char *dir = workload_files_dir();
> +	pid_t high_pid = -1, low_pid = -1;
> +	int fd, status;
> +	int ret = -1;

[ ... ]

> +	low_pid = fork();
> +	if (!ASSERT_GE(low_pid, 0, "fork low"))
> +		goto cleanup;
> +	if (low_pid == 0)
> +		exit(real_test_child_work(CG_LOW_DIR, low_data_file,
> +					  low_time_file, read_times));
> +
> +	high_pid = fork();
> +	if (!ASSERT_GE(high_pid, 0, "fork high"))
> +		goto cleanup;
> +	if (high_pid == 0)
> +		exit(real_test_child_work(CG_HIGH_DIR, high_data_file,
> +					  high_time_file, read_times));

Should these forked children use _exit() rather than exit()?

exit() runs atexit handlers and flushes every stdio stream the child
inherited from test_progs, including whatever the parent had buffered but
not yet written at the moment of the fork. Where the buffer is a real file
descriptor this duplicates the parent's pending output once per child.

The hijack body in test_progs.c is inside #ifdef __GLIBC__, so on a
non-glibc build stdout is never hijacked at all. Also, stdio_hijack_init()
is skipped when running with verbose output:

  if (verbose() && env.worker_id == -1)
          return;   /* output to stdout by default */

So `./test_progs -v > log` (fully buffered pipe/file, no -j) and any
musl-based build get duplicated log fragments plus the child's own printf.

Other forking tests in this directory already use _exit():
prog_tests/bpf_iter.c, prog_tests/exhandler.c, prog_tests/cpumask.c,
prog_tests/task_kfunc.c, prog_tests/deny_namespace.c, and
prog_tests/uprobe_syscall.c.

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32224943030
--===============9008457374577010211==--

