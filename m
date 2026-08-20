Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C593FC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 14:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997696B008C; Thu, 20 Aug 2026 10:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96E516B0092; Thu, 20 Aug 2026 10:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ACCD6B0095; Thu, 20 Aug 2026 10:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 658D36B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:21:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B9CEA2137
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:21:35 +0000 (UTC)
X-FDA: 85121860950.03.A546C0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id EB33B2000B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:21:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odVNZzt8;
	spf=pass (imf03.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787235693;
	b=7z9w8u24RX9XUj4fU01Tldn7BkmXNjqDkGuMhE4pW2RTpF0mc4qmKXdXXOm2elt17o8YHe
	OxoRQ2VB4KeU5Ez2OGXUqDD4H5py46dHs/D0noxxJ5aZVi73NDjwTyOKQlOIgxV4CwHJPW
	j+3TNQm7eswaSL49gjiCzgtoRk6YqYg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odVNZzt8;
	spf=pass (imf03.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787235693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJiZkdqnbJzbaLpp/SAkSW9OMlkWsEAqjmxRN4K9z3U=;
	b=qDUv/6E0VLbJnE+FKAssxy4tAyYvk05l6WHNLt4dFhnzQm77LeP14VlMcpO5qpotlcdms9
	P70Xl7OEvARzzJnslQT3AZdtqF6m3n/aKE+V5VzTnzHbFwNCSSg7Wr+i0STE0Rmu5yDd4N
	qcvJaU8HGB6zZFj6GcSTadAWltc3Pso=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FE0360008;
	Thu, 20 Aug 2026 14:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FC91F000E9;
	Thu, 20 Aug 2026 14:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787235693;
	bh=LJiZkdqnbJzbaLpp/SAkSW9OMlkWsEAqjmxRN4K9z3U=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=odVNZzt8z0D62ioWfG6wavBpa5b4ieU2mNk2ZZSVepH7MZf6sCt9kfqR3X+sb4Fnp
	 fHAuQcFlTgIx7R6I7Il0ESi+qahNCVg9joyHyvfy3nosMG2AdVQ4V7/sfdfDfCRe+j
	 WtNrPdwObanccJHtxDOmdTuOs0JgaXLYTniuNCUSSeLELzpb99bJ/32Wfym3cDBPrI
	 zAZWQKcX33IPwraw6DUikNMgmqpSuNUbOtjKVbBwrZQ/cHdNhLoQa5HnAGAVbrNX+h
	 9q9+488GAN7zdPqbzgVI0Mh00MwvuPK4O3aHrFYRlVt731VZ+tKzpCYopgXHYq9mtH
	 l1gJVFSO16H0Q==
Content-Type: multipart/mixed; boundary="===============0216903816946372316=="
MIME-Version: 1.0
Message-Id: <d2d137d2202c87dd354c1f50f2b2e2db35c7e786b137970aa4512ad7737884a9@mail.kernel.org>
In-Reply-To: <20260820131801.68759-4-tasos.papagiannnis@gmail.com>
References: <20260820131801.68759-4-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next v2 3/3] selftests/bpf: Test linux_binprm user memory kfuncs
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,viro@zeniv.linux.org.uk,brauner@kernel.org,akpm@linux-foundation.org,david@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,song@kernel.org,utilityemal77@gmail.com,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 20 Aug 2026 14:21:32 +0000 (UTC)
X-Rspamd-Queue-Id: EB33B2000B
X-Rspam-User: 
X-Stat-Signature: k93x4951k1965etrmqjeugnpkiaenjks
X-Rspamd-Server: rspam06
X-HE-Tag: 1787235693-22949
X-HE-Meta: U2FsdGVkX18tSpFl0oQEMy0r+lX3/bxzKfbgyLZ7d4HMM3tAXzY0lTFBqByFkk5iWmiNNKxK+araXwGj+Gw0CeFEtOOYmXZSvmvg3JeLRQcqg+hsr/IdSh0VieUWNVY3RX9RhMk/pq4Dr1nEJJvrkd02hIfSex6PelcGNBoQaTgCaEmtTzHYph7Qw08+2L+w63+vvFXd/9ow5zK1DDz+YXvnTheu7EEkyO3o50BXqUe1PxqdcsCMVqSPffAPV2QlPHDcwnddyusdPQNjcsbEWhk16n/OxJuVPl6XHbSup7NoVUr5ISkkylNHVtRZiVh3RVBOEmP3e+BZRDIXeVPvnRRYGe8NwR9JvXuhIHL/PwqANYNKsOMeo8B+B8ikBGy9o7Qib6RX3+I1dXZnaA1qwb0Q/RlU5oO5iooOakYX4EOqnfNASXHe5H5ikGvOMgsGtpMW8ykyIuaIjwIoyvuV0M+VPj1NS7nz0uUAPokfCMQyZPMtX1Kp6++omIyQHgtmicZRs3Vwf7D4GxJ/eFxQ0P4zF8zM+Yc90oRCp/Sm67JiRxeUZFqqvhwtIMAU7nUyCXBWKevzkRQjs8vN1eP0vaWGT5/jg7GynoqdFOppQSZU3Sf3BDPg7tYDaaJqP3K3d+XPI8LuTU0/UDxnn+RKo1Iws7hssiGvwwTVXwaB/tPsc9VfdLHaEQyxerZHSU7KxiAdo9UIEZ4wu12ssUVfMzx0/0z0avn8zfd09F+mBHuGBxmB9CLVYZp6DVnk3yMG/auiWe3KONE5SHBBEaXwvES0Dq8NgWh5kksE6MlMm7334znQaZwjvdi7nd+AYeIBMOxBd01/1MKwniFRfASY5tjh3icPlKr+oL86gmdLq/P2ihugVAu1MVHIhj53oC2lcaqvUpcS01GACx3Y5yF2Av+reEqMMlr2Lm8KJSA0ZruCLWcM4qAFrWfSYQfukVeSfLVRjvUuK/e8RQkbr6p
 qjxUxrsu
 7qIx4LQpPHr+j0XQizH2kmSGUIZUX+KBdqnfj3QMmMVUgkvhpP5Is1yAiRZqFdQjKpmtUonCc0LFmIZi0aqZ5b9s7Q+cgNyxxEWtgzstAHq8BnbaWHtlQh+B948AREgtG06msROQtn/UfGoOTNRDSa1HJAHutfVzxRdt6e8pjXHbYIYFxG21KygR0hjKKGYFBwAUurLloBrvBYUTx4JDPo8GAHTT1B/5EDeodNUlOGla6MVGAT3O4Goe4YCkZEfLnSxXRXjCGJv/J0UoubzveiQfXab7oj9FgMBtdeGRM9B48BulCrdOyq2697EeYzGMJaS1jOdIgewqb5mhE4qNmbvSBCqCDWipuFVwWNB8mJCq4d5wjf1xS1kemgeZWfuz71yHDta7pFMPVSaitADjnxaiRqa1L+na4gS01DzVhLO7EBojMywrogn2dXo2wv4QB/ojhQZ98nB1yG3qA1Rx/yd6o1ZO9KxQTN9j0WaIAuP/6hMFyfrf8Hfo+UBe9uWwkxg5JicRn+anEwdKJK0SqzGl27w9E6MbiJc6q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0216903816946372316==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: Test linux_binprm user memory kfuncs
>
> This patch adds a sleepable BPF LSM program attached to
> bprm_check_security to test bpf_copy_from_user_bprm() and
> bpf_copy_from_user_bprm_str().

This isn't a bug, but could the changelogs in this series use the
imperative mood the kernel asks for, e.g. "Add a sleepable BPF LSM
program attached to bprm_check_security ..." instead of "This patch
adds ..."?

> diff --git a/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
> new file mode 100644
> index 000000000000..1007e3aec054
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
> @@ -0,0 +1,62 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <errno.h>
> +#include <sys/wait.h>
> +#include <unistd.h>
> +
> +#include <test_progs.h>
> +
> +#include "copy_from_user_bprm.skel.h"
> +
> +void test_copy_from_user_bprm(void)
> +{
> +	char arg0[] = "first";
> +	char arg1[] = "second-argument";
> +	char env0[] = "SOME_ENV=a";
> +	char env1[] = "OTHER_ENV=something";
> +	struct copy_from_user_bprm *skel;
> +	pid_t child;
> +	int status;
> +
> +	skel = copy_from_user_bprm__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "open_and_load"))
> +		return;
> +
> +	if (!ASSERT_OK(copy_from_user_bprm__attach(skel), "attach"))
> +		goto out;
> +
> +	child = fork();
> +	if (!ASSERT_GE(child, 0, "fork"))
> +		goto out;
> +
> +	if (!child) {
> +		char *const argv[] = { arg0, arg1, NULL };
> +		char *const envp[] = { env0, env1, NULL };
> +
> +		skel->bss->monitored_pid = getpid();
> +		execve("/bin/true", argv, envp);
> +		_exit(errno);
> +	}
> +
> +	if (!ASSERT_EQ(waitpid(child, &status, 0), child, "waitpid"))
> +		goto out;
> +
> +	if (ASSERT_TRUE(WIFEXITED(status), "child_exited"))
> +		ASSERT_EQ(WEXITSTATUS(status), EPERM, "exec_errno");
> +
> +	ASSERT_EQ(skel->bss->bprm_argc, 2, "bprm_argc");
> +	ASSERT_EQ(skel->bss->bprm_envc, 2, "bprm_envc");
> +	ASSERT_EQ(skel->bss->data_len_match, 1, "data_len_match");
> +	ASSERT_EQ(skel->bss->invalid_flags_ret, -EINVAL, "invalid_flags_ret");
> +	ASSERT_EQ(skel->bss->copy_ret, 0, "copy_ret");
> +	ASSERT_EQ(skel->bss->str_arg0_ret, sizeof(arg0), "str_arg0_ret");
> +	ASSERT_EQ(skel->bss->str_arg1_ret, sizeof(arg1), "str_arg1_ret");
> +	ASSERT_EQ(skel->bss->str_env0_ret, sizeof(env0), "str_env0_ret");
> +	ASSERT_EQ(skel->bss->str_env1_ret, sizeof(env1), "str_env1_ret");

A subsystem pattern flags this as potentially concerning: the test has
no skip path for the configuration in which the kfuncs it exercises are
deliberately unavailable.

The immediately preceding commit in this series (6073b8df0008, "bpf: Add
user memory access kfuncs for linux_binprm") registers both kfuncs on
NOMMU as well, where they are documented and implemented to return
-EOPNOTSUPP:

fs/bpf_fs_kfuncs.c, bpf_copy_from_user_bprm():
  #else
      memset(dst, 0, dst__sz);
      return -EOPNOTSUPP;
  #endif

fs/bpf_fs_kfuncs.c, bpf_copy_from_user_bprm_str():
  #else
      if (flags & BPF_F_PAD_ZEROS)
          memset(dst, 0, dst__sz);
      else
          *(char *)dst = '\0';
      return -EOPNOTSUPP;
  #endif

The changelog of that commit states this explicitly: "On NOMMU systems,
exec arguments are staged in bprm->page[] rather than mapped in bprm->mm,
so the kfuncs return -EOPNOTSUPP."

The BPF program records those return values verbatim into copy_ret,
str_arg0_ret, str_arg1_ret, str_env0_ret, and str_env1_ret
(progs/copy_from_user_bprm.c), and the userspace half then asserts the
success values unconditionally, plus data_len_match, data_match,
str_args_match, and str_envs_match. On a !CONFIG_MMU kernel every one of
those assertions fails and the test is reported as a regression rather
than skipped. Note that invalid_flags_ret (the assertion above) is the
one assertion that would still pass, because the flags check precedes the
#ifdef CONFIG_MMU block.

Would it make sense to use test__skip() here with a reason string when
the kfuncs return -EOPNOTSUPP? test_progs provides test__skip() for
exactly this (123 existing call sites under
tools/testing/selftests/bpf/prog_tests/).

> +	ASSERT_EQ(skel->bss->data_match, 1, "data_match");
> +	ASSERT_EQ(skel->bss->str_args_match, 1, "str_args_match");
> +	ASSERT_EQ(skel->bss->str_envs_match, 1, "str_envs_match");
> +
> +out:
> +	copy_from_user_bprm__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
> new file mode 100644
> index 000000000000..4d7e9002b45b
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
> @@ -0,0 +1,115 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "vmlinux.h"
> +
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <errno.h>
> +#include "bpf_misc.h"

This isn't a bug, but is "bpf_misc.h" needed here? I could not spot
anything in the program that comes from it, so the include may be
droppable.

> +
> +char _license[] SEC("license") = "GPL";
> +
> +static const char expected_data[] = "first\0second-argument\0"
> +				    "SOME_ENV=a\0OTHER_ENV=something";

[ ... ]

> +SEC("lsm.s/bprm_check_security")
> +int BPF_PROG(check_exec_args, struct linux_binprm *bprm)
> +{
> +	u32 pid = bpf_get_current_pid_tgid() >> 32;
> +	char data[sizeof(expected_data)];
> +	char arg0[32];
> +	char arg1[32];
> +	char env0[32];
> +	char env1[32];
> +	u64 offset = 0;
> +	u64 data_len;
> +
> +	if (pid != monitored_pid)
> +		return 0;
> +
> +	bprm_argc = bprm->argc;
> +	bprm_envc = bprm->envc;
> +
> +	/* this is the total size of args and envs starting from bprm->p */
> +	data_len = bprm->exec - bprm->p;
> +	data_len_match = data_len == sizeof(expected_data);
> +
> +	invalid_flags_ret = bpf_copy_from_user_bprm(data,
> +						    sizeof(data), (void *)bprm->p, bprm, ~0ULL);
> +
> +	copy_ret = bpf_copy_from_user_bprm(data, sizeof(data), (void *)bprm->p,
> +					   bprm, 0);
> +	if (copy_ret)
> +		return 0;
> +
> +	data_match =
> +		!__builtin_memcmp(data, expected_data, sizeof(expected_data));
> +
> +	/* arg0 is at bprm->p */
> +	str_arg0_ret = bpf_copy_from_user_bprm_str(arg0, sizeof(arg0),
> +						   (void *)(bprm->p + offset),
> +						   bprm, BPF_F_PAD_ZEROS);
> +	if (str_arg0_ret != sizeof(expected_arg0))
> +		return 0;
> +	offset += str_arg0_ret;
> +
> +	/* arg1 is at bprm->p + sizeof(arg0) */
> +	str_arg1_ret = bpf_copy_from_user_bprm_str(arg1, sizeof(arg1),
> +						   (void *)(bprm->p + offset),
> +						   bprm, BPF_F_PAD_ZEROS);

This isn't a bug, but would these comments read more precisely as
something like "arg1 follows arg0's NUL terminator", or by referring to
the expected_* strings? In this scope arg0, arg1, env0 are the 32-byte
destination buffers, so sizeof(arg0) here is the 32-byte destination
buffer rather than the string length. The code actually advances offset
by the value the kfunc returned (6, 22, 33).

> +	if (str_arg1_ret != sizeof(expected_arg1))
> +		return 0;
> +	offset += str_arg1_ret;
> +
> +	/* env0 is at bprm->p + sizeof(arg0) + sizeof(arg1) */
> +	str_env0_ret = bpf_copy_from_user_bprm_str(env0, sizeof(env0),
> +						   (void *)(bprm->p + offset),
> +						   bprm, BPF_F_PAD_ZEROS);
> +	if (str_env0_ret != sizeof(expected_env0))
> +		return 0;
> +	offset += str_env0_ret;
> +
> +	/* env1 is at bprm->p + sizeof(arg0) + sizeof(arg1) + sizeof(env0) */
> +	str_env1_ret = bpf_copy_from_user_bprm_str(env1, sizeof(env1),
> +						   (void *)(bprm->p + offset),
> +						   bprm, BPF_F_PAD_ZEROS);
> +	if (str_env1_ret != sizeof(expected_env1))
> +		return 0;
> +
> +	str_args_match =
> +		!__builtin_memcmp(arg0, expected_arg0, sizeof(expected_arg0)) &&
> +		!__builtin_memcmp(arg1, expected_arg1, sizeof(expected_arg1));
> +	str_envs_match =
> +		!__builtin_memcmp(env0, expected_env0, sizeof(expected_env0)) &&
> +		!__builtin_memcmp(env1, expected_env1, sizeof(expected_env1));
> +
> +	return data_match && str_args_match && str_envs_match ? -EPERM : 0;
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32375104040
--===============0216903816946372316==--

