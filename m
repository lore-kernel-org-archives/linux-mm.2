Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 054F4C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093A06B0109; Wed, 12 Aug 2026 14:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B126B0113; Wed, 12 Aug 2026 14:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3346B0114; Wed, 12 Aug 2026 14:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B92DF6B0109
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:42:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B17E1404A8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:42:48 +0000 (UTC)
X-FDA: 85093488816.19.7001B06
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id DF4DA40003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:42:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q1eU2BKI;
	spf=pass (imf01.hostedemail.com: domain of utilityemal77@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=utilityemal77@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJq4BeRPMu0DvX0JybLuJRAOSyVWG0mjimxTrgQADmI=;
	b=t9Vp/3KF0QjM/94wafpV/nAqjsAMjosWInLtW89ZwZYdrWmwy/Hf0AJDi93NzWR2W9UOex
	V4zsO0USTpaPndD6WkqZqci+NGL5RQM9cGT96fgeElGekOPzyhg5ru+ocbR4ImNGRFGqOH
	0jFemDO0qsXqdNGj4SW3uBR2cgz6Uew=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q1eU2BKI;
	spf=pass (imf01.hostedemail.com: domain of utilityemal77@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=utilityemal77@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560166;
	b=djMee0lVLBa2oMCtbA+WafXFz8O50uU+zDVwqgmjMWaWISVfECjUOs3XC4hDXfhkpJ5aWC
	oyeFnWSTAlURaaZSlC4v7gff3ti1QFsxN9+RUgNWR8JYnGJ3nW8glCesCYYBlfd/acoCe9
	KQd5J4rR/1sOhjxTzWrxvbn731HnaQQ=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-82011c59e66so21601677b3.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786560166; x=1787164966; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NJq4BeRPMu0DvX0JybLuJRAOSyVWG0mjimxTrgQADmI=;
        b=q1eU2BKIaZDKrQ60ybeVO2QgfI1scPJ0+hAQERX85kxYmMFShJX67MDcEmJ+1JxfkX
         oA63rGX3sRBpSj6VfBSjdv/UIfeX6P9lh23TEwJTh/Hmf9h0iYIWOi0T/sGFGdXkvERC
         cyvag8ihKoigNx0pIjY9lApbz8naE6/B/sFz0BYdAbDHnulncgPjnp8JAOMdcpDnC9AP
         W3U/Rc6pyX7BYvf9q9gUEadryk2T5/+SjpRLsH0NIVqZEvUNg4ThD0Mq0zhm9EECLehH
         OvmRVskAAYnVy5DlgSDGdYLrx3DFO5lvcgRKTAE1XnWy85FTDq1WmzDwNsD77AYq3zoy
         XLIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786560166; x=1787164966;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NJq4BeRPMu0DvX0JybLuJRAOSyVWG0mjimxTrgQADmI=;
        b=Ej7oaWZ+2PhCiB1siLZt9Y6YByY+kcViEsS4bALpEraOQnR0iyY6ZeEJWnAIzT6cDo
         PuE7BN4S6ErttVuxKGkFxYNpYUznxXfZDPJcdPeTqCpKvf9SLebTgY/bZu/J099AH9OQ
         OrfU3L/7H/TUbQJERJDYeM5xXXUsnbKPVXAmJEqDGQY/JrIGgWaqqyt0NcQov5/C2qr2
         gDD5pDcF/QOdFIqiNpFZBSKN0nTftXQ5c3ozVTRyy+JtNABzqfRgp6KYJcJ8w+Hgbnrp
         gZMRaNCVJfYmr1GdlZW7yVkyztEhA8yYcYQodcBknUbQGzEqw236fGqB769cFaE45rT8
         UAKA==
X-Forwarded-Encrypted: i=1; AHgh+RpUlKtw/7Ly5E/z7hq0/oyq1SYwYPvH/srVPOv8sht0Bcwsk4W78YY2Y+B/uLnQx62NoEjLzGO43A==@kvack.org
X-Gm-Message-State: AOJu0Yyb0P8f+oqqck2icDLKSyE0KekiWt0HkMDBy7wAQ51iu+HdVK9j
	UwZ+OiwzwRZt+N+grkUtXfvXTRPOCB/V5Ev6fwzIKLW+y8yaRMvMdh5A
X-Gm-Gg: AR+sD11ZALPVY5R/nFuEboChsuuhHJFlFrsDRBpex3dIc7WPax6lkcpDtd21Dvy3Nnk
	tCMasSe12icUDxI4Ce26KT1ZwvYwebHViu6V99md3MKL29BfQqvYhM0gfscxmHbhWH5YeRO+X+4
	kinsuUlPJBKHYKYVcx4ZTUWsFW3ym+PzTkXxNhjYqWx1obp18xAGxU6VrwNK1+J8qQKj9bz2NSg
	qkC6VsMgM2nJj8rluu86wrf96YvarirFpLsS+z4/anBrO5alDqP4ddP2lNHsa/HWouxXi2JJ7J5
	qJqo/lkSMxPWitEpDeG8sYYiEZbmVU56jin5QWF49/IxSKeNtoRW2sX4+pk0dvqU+mow4CBKmMo
	7EEfII/WS4lqIj4ZpcaE4QcSHsR19po65w+M0a4aR1yY1rTRhvrJlVgUSOjWMpd9pTpkNdwhyob
	flo+2HUtJScIksFz5VWFZyaNtdHO7JZzsat4LeL6d+81YgArQPZyWTxbqm6x3ltS4h5q6JdOqWc
	ex143oTsP3wj0KAOOlazg==
X-Received: by 2002:a05:690c:6610:b0:81c:8005:9104 with SMTP id 00721157ae682-83109926bc4mr35751497b3.30.1786560165845;
        Wed, 12 Aug 2026 11:42:45 -0700 (PDT)
Received: from zenbox ([2600:1700:18fb:6011:3077:a5d:da73:f5b4])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8346e1a954dsm167657b3.41.2026.08.12.11.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 11:42:45 -0700 (PDT)
Date: Wed, 12 Aug 2026 14:42:44 -0400
From: Justin Suess <utilityemal77@gmail.com>
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, kpsingh@kernel.org, 
	matt@bobrowski.net, song@kernel.org
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Test linux_binprm user
 memory kfuncs
Message-ID: <any-GrHSwE5suq33@zenbox>
References: <20260812111140.7762-1-tasos.papagiannnis@gmail.com>
 <20260812111140.7762-4-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812111140.7762-4-tasos.papagiannnis@gmail.com>
X-Stat-Signature: 1gyxgdpf1zqrf8thb55447mqw1odyg4n
X-Rspamd-Queue-Id: DF4DA40003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786560166-978977
X-HE-Meta: U2FsdGVkX1/TGZ+fbB5Qr/nIy6P7RFUTAGK43VJTfOXSrPSrX+0p6r51niEaIhnBKBnVG60JJe7e2YYcNCVrGMWtcDa/31dBXmN3Hg72H1bhUEQTzpUaEEH/UiFncfOxJcXz+PyBWmwBdn5yojmHMmLjRDuHD6y9bu2OMYLLsore8JPg7BthmmWMUJOjrc8DLpawNAxc5uRMZUchtreJdO2rxmgsYgE8bozIdy9TpKz5/D1sXPHXFoLjHX/x1r4GjJpTNreBSCNL/nKZo/UdbqT35sWovO/x+wCK4r8p9Uw1r21KRYMPqiPnA0/dufjdTUFNu4QkRQV883hToL6OpXWjm4Ekc+jcvDQEoYkvATw/Y/8Eleq0HbxVgina/Bjim1AkudbFNVxqOADJQODNLZQYtU2MxryQiQJoJf2oS4Bceq+yQdjEz5NyCsA0bqp2iUzZXwEKzcjN+EP7cbULYWgNFG6xQTfL5QJ4rPK0cr/22GpKC47DG93BKJdaCKlUh0e1SsG9vOp8BoMX9lTxm5kgUa8TpJhr+iXCjNOfec0/Nudvtcvz2ZnOFX+MvxnqzwCoIakLafrJM1KeZk+bCvjLJ8+CPwS47lXPH4ib1AFKxQn/0CsCrIeDk9J2vZoXhHQVlX/c4nl1Fe/hyXbpHn6QIvcYgfOMR0VtCmDV26tQqbmH560T6GCRadK1DIiojl9WmPcI6vZArSeCbWp6LaCN8cy8lcUzl1FiQ6B+OF2RlaJCfGLMbZAw20D3nDjbIiEOk8RdfCtEXZr/EIcIUMXv+47vRO4WPSW3mbo8BwZk17oeGhpVAwXSj8+WhtjDIalf5LnsXXSdSstX6OGb/MQ92vn+lH955/5BAig8PzLAH+jS3cQtn8VKZvScHWwN94gZJRSIUE2BlBoIv9YB+UOPx9fyjIOPaCupCMyZOcml3pLCG8mBEnAFIDXr9aCTG/gSaG8g/vPgqoGHTD5
 rP8QiRbM
 QIpeTryqs4LUGIrb9mgNjLJxCEDtAdldomh850g498FDAmfXX9YFcRbbvhDIlcoe+hN1gH3x7KKvJSjwbxN4SDZE4Xl5ATlu0tZy9E23VeplTzB1EyQelLtMsjdU28nVVlPx/ybExwiJFijSDU9aVno66Cij0GwyFm78L0B4ctZ8HsMpVPq3NfSm9lptgEOEbro/yHU0z96ZJTHAvZ16cpKovtlPkg/e5ttbstuAHxAKIfUtiRa8EfXc3Ysirc4gBxVu1ac9UtsEOVymctCqJFxBJYjaqumt6HIG4UkSrxPyh/5cRKwiiCQ8IIDDt9Lkz1QjpbXnTC//parfaMVl+V3iKc6plovoSNtDrK3GXzLo03LftTZCylw4jy/tnxCl1BTm+6UW2Y3RP6L7gOXzGg2q3u7SlKMMx9JH7tCCt23rig+21EztmWQahBdLIGDbNfkoxidXu3qnr6sTbdlX3CIjeYRco8tWzrjNyeLNr1lctmnjNjXW1ldb+Cf+RW3MkpeB2OeOAG1BATYXJzfAqrJUcHvntY01QYCujKR3Xc6Pv0txYzd21yBFp0wsSd49V+UMz1MzjL2zmAiOsrht1XNzDFLLpHFyMthLApOaqmBrwYhi3ZEXC37dy1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 02:11:40PM +0300, Anastasios Papagiannis wrote:
> This patch adds a sleepable BPF LSM program attached to
> bprm_check_security to test bpf_copy_from_user_bprm() and
> bpf_copy_from_user_bprm_str().
> 
> Starting at bprm->p, verify that bpf_copy_from_user_bprm() can copy the
> contiguous NUL-separated argument data. Then use
> bpf_copy_from_user_bprm_str() to read each argument separately,
> by advancing the offset based on the returned length.
> 
Can you test reading environment strings as well?

It would be nice to have an example on how to do that.

Justin
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> ---
>  .../bpf/prog_tests/copy_from_user_bprm.c      | 52 +++++++++++++
>  .../selftests/bpf/progs/copy_from_user_bprm.c | 74 +++++++++++++++++++
>  2 files changed, 126 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
>  create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
> new file mode 100644
> index 000000000000..3d5080a3975e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
> @@ -0,0 +1,52 @@
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
> +		char *const argv[] = { "first", "second-argument", NULL };
> +
> +		skel->bss->monitored_pid = getpid();
> +		execv("/bin/true", argv);
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
> +	ASSERT_EQ(skel->bss->invalid_flags_ret, -EINVAL, "invalid_flags_ret");
> +	ASSERT_EQ(skel->bss->copy_ret, 0, "copy_ret");
> +	ASSERT_EQ(skel->bss->str_arg0_ret, 6, "str_arg0_ret");
> +	ASSERT_EQ(skel->bss->str_arg1_ret, 16, "str_arg1_ret");
> +	ASSERT_EQ(skel->bss->args_match, 1, "args_match");
> +	ASSERT_EQ(skel->bss->str_args_match, 1, "str_args_match");
> +
> +out:
> +	copy_from_user_bprm__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
> new file mode 100644
> index 000000000000..679363811edc
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
> @@ -0,0 +1,74 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "vmlinux.h"
> +
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <errno.h>
> +#include "bpf_misc.h"
> +
> +char _license[] SEC("license") = "GPL";
> +
> +static const char expected_args[] = "first\0second-argument";
> +static const char expected_arg0[] = "first";
> +static const char expected_arg1[] = "second-argument";
> +
> +int monitored_pid;
> +int bprm_argc;
> +int invalid_flags_ret;
> +int copy_ret;
> +int str_arg0_ret;
> +int str_arg1_ret;
> +int args_match;
> +int str_args_match;
> +
> +extern int bpf_copy_from_user_bprm(void *dst, u32 dst__sz,
> +				   const void *unsafe_ptr__ign,
> +					   const struct linux_binprm *bprm,
> +					   u64 flags) __ksym;
> +
> +extern int bpf_copy_from_user_bprm_str(void *dst, u32 dst__sz,
> +				       const void *unsafe_ptr__ign,
> +					       const struct linux_binprm *bprm,
> +					       u64 flags) __ksym;
> +
> +SEC("lsm.s/bprm_check_security")
> +int BPF_PROG(check_exec_args, struct linux_binprm *bprm, int ret)
> +{
> +	u32 pid = bpf_get_current_pid_tgid() >> 32;
> +	char args[sizeof(expected_args)];
> +	char arg0[32];
> +	char arg1[32];
> +
> +	if (ret || pid != monitored_pid)
> +		return ret;
> +
> +	bprm_argc = bprm->argc;
> +
> +	invalid_flags_ret = bpf_copy_from_user_bprm(args, sizeof(args),
> +						    (void *)bprm->p, bprm, 1);
> +
> +	copy_ret = bpf_copy_from_user_bprm(args, sizeof(args),
> +					   (void *)bprm->p, bprm, 0);
> +	if (copy_ret)
> +		return 0;
> +
> +	args_match = !__builtin_memcmp(args, expected_args, sizeof(expected_args));
> +
> +	str_arg0_ret = bpf_copy_from_user_bprm_str(arg0, sizeof(arg0),
> +						   (void *)bprm->p, bprm,
> +						BPF_F_PAD_ZEROS);
> +	if (str_arg0_ret != sizeof(expected_arg0))
> +		return 0;
> +
> +	str_arg1_ret = bpf_copy_from_user_bprm_str(arg1, sizeof(arg1),
> +						   (void *)(bprm->p + str_arg0_ret),
> +						bprm, BPF_F_PAD_ZEROS);
> +	if (str_arg1_ret != sizeof(expected_arg1))
> +		return 0;
> +
> +	str_args_match = !__builtin_memcmp(arg0, expected_arg0, sizeof(expected_arg0)) &&
> +			!__builtin_memcmp(arg1, expected_arg1, sizeof(expected_arg1));
> +
> +	return args_match && str_args_match ? -EPERM : 0;
> +}
> -- 
> 2.55.0
> 

