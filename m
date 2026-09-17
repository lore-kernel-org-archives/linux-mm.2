Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83187C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 22:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D82E6B0096; Thu, 17 Sep 2026 18:14:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789836B0098; Thu, 17 Sep 2026 18:14:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6512B6B0099; Thu, 17 Sep 2026 18:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37EED6B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:14:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F5F91204DE
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:14:39 +0000 (UTC)
X-FDA: 85224659478.23.E75AD5F
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 52FEB40007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:14:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZPnFhFf3;
	spf=pass (imf27.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789683277;
	b=wH3gsW7uXPtU615OCQdNXdhfHrnwkjR1vHLNvHbNlwGrMneYD1EvoK7Tub1V6mN1bIehTZ
	AL+FZq86x6JttlXslWwP9U/VCLHG0mbeSWDEb0mT8hzEFPbP1hp0N4PlX4OMsGDZOUmf9R
	/TjvJf6YXiTaLzaY/9ioxSusaGLzSHU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZPnFhFf3;
	spf=pass (imf27.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789683277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVkLWZwDcftHWkygPUCtZEPadhVhHno/qCcQeOr4QFc=;
	b=IKmxrlsRPpsrWRIml/pX3ayl1WuNKYf+0TUtvtQVcsOyqrXV71+dGiQJBu/4+pwU3koTZX
	Q29EIQ0HGr5tlDsk9m6IeqXYJ3oZaF2UJr6Zk0BY8cvbVLxk5Ao4D5GN1KwvVEmRkXtgGG
	GGonCgLcgNQvoZ670zIIMkCMIOhzUVs=
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccd5cf02so87590a91.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:14:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789683276; cv=none;
        d=google.com; s=arc-20260327;
        b=fBDvHydkSUlbj8PawvKIK2Q+/A2aCSd4C+Eg4RaUk7P8CnLgW+IUi4MEO5tdJPlfNo
         U79ZtSlLId226T0/QwgLDCglKcAkdmKJf3SV14m+uUC7Zm9dHKLC1Ckq9f8ujaU+ZEv3
         NRiAMXDu1diqSgAsTQ7Gf2lMKcLsz8bInARlNN5K0MZswahekIWvmbyG1EZsQAhTwYbe
         cm310MLFpW7G48mZxkGEYC6YYs2RrwFdbkSdf55VnFzVq1sZlTPQElvu2Q4iwvEzJ+nf
         Y8soxqZglmXAmwop9pIcY4YAHtsCe2XtLwHWedEO8GzVAmZKc2c1PKzWBh/q0BjzPXfv
         SKkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wVkLWZwDcftHWkygPUCtZEPadhVhHno/qCcQeOr4QFc=;
        fh=fES9G0ek64rPVXBu+ef+JUkDk1yQxIiNqjx0E6gyvgI=;
        b=GdtsGKlLeZZxFMp/04oRCNrGJ8G5AxioYwzITEryTLjfBcyQ8Cg0mREHxT5IvW9NJC
         Msxff+4R8/9Fly5nZ1STDKn6hSRFjbEOkMbbC7ONyLLsbktFfUniI5EXoy2O711qtz+t
         wP1ENyRPHuuDyFnLRsbVndnkkQF6Xqs7Iitieqmf7UMSIS5+RXgIfAO6fodsyCFnTE9q
         D9BBN+cgDHVJDkiCyk/qk2c9PyuiK93v8N2ZPtO7sCJKfukWYfo6h9X+vZwmbfCjWljv
         2Q52iGjlwE1tW60PA9zdJujutn3kt3PR/G3F9DreKrBTgRwMB29MyzVpojta/W7w1/lN
         HNgQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789683276; x=1790288076; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wVkLWZwDcftHWkygPUCtZEPadhVhHno/qCcQeOr4QFc=;
        b=ZPnFhFf3gmEbjTind2q9Y3Z0CDcAr7Mbn1DtzXUVo2b3YbkRCAVCrfaoGJSAQ0b5sB
         cB8G04U+VZjxvVyxqwgn1zmUdxezapUd4/IO2oGAymmjcCi7IMedPhuvJWtzAmPHsbub
         1mDwY89VSd2jJq9UAJiXKNUI1B74down/NzTpZ7+WuXZtsQ+lH6uz3Tggylhhg/PalTn
         udsUn1FeQBBEmArdTgvpA9Y5y6CA27FipfxPlf7LAKe7pHimy/UUMpeeg5/2WdSCNf3P
         yPgEA8Sl0sfiRKz12BFoNCz661Y6ZqDQjCS/Ob5Gljt8HI3mHIPagsD1/+sBJ/+xWwyI
         NdGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789683276; x=1790288076;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wVkLWZwDcftHWkygPUCtZEPadhVhHno/qCcQeOr4QFc=;
        b=haTxeO1c1yPhyRX++cGeP0p97peopZDPo2tuXBABKX0bKNo9Wov5pJNdrQE3d/5JGh
         X+BVJym3WCzZsRZNITzrpEtwM2sOdjpTdiW4ewMdSDHimzEQZd8yq/I/s1kYkfNOnyYk
         k0JYvovNqvkRfEzhI5kKtNEdfytHUwyFjET6fEzHmn5c7zLrEtW0Ugvjc8lvk79z9SBs
         0gfi2tBDvYy2deDb53sd9wsAGz8doHcOP84Ht9FHzrLQjyWTrWcJIp6Zb1xUdhml0RsA
         a/5JJOGjN02COB7oztompvirJhHjl/m8NmUOTTPociHE1Sl1+f7Z5UNi1pEQrmvnvQVy
         EZGA==
X-Forwarded-Encrypted: i=1; AKwUvBz6sfA1CQL4KGz8kbCFjxa7tdCwSlOhxVJD3aTO0idrSLjT01vfk1sSEDbKW8oOjCPROyD9eT7rAA==@kvack.org
X-Gm-Message-State: AFuF++k9zBCq55uCUQY+HelbDsq/U35Jtvr4NkvoTmu7utbi73jC3SpC
	PC+e95ClNJxzXGoyedtVYAC0qyp8C4E0ra1kMWsXbJABOB6R6MZSq2e8/gaYL/sRgnPWPHQofCG
	/UUZmHOfY/ROerbzWDyeMEZl/MywRhMU=
X-Gm-Gg: AYBFou0I3j1lgjzLIc5UHwvVLD5nTHEgQZR4sBCo3jBHWA8vShrR7W8uGMcFwykjpVt
	TbXYN/W2D+ZZsj413KL6w+L7/RCmFmToBRxnnU/O7A+d0L7MuElM9RruVI9LNam4OcEHTEtJtz+
	CRhGCSBtq4Jm6RF2pUys+OvEjrzASHT5Td4KELqru077SsIPSb7RWmLhzLRUC8lnBtAMqEpUkYP
	pPPKbIHrmg29bEICCMEZLCunJWyLx/CY0gDz75RHGZ/Yrw/YBPkzSQKj7nv6NkbSMFvuB+vq8gX
	92ZAIXUiAGtU63I5gtztroloSnl1mVgYtOrTVeLozEl3J9AQFEOJPUxjCJSH7Db/7sV99mAG/lb
	E9NCCQmkNMWRs2se2dvIBydRJZJh7SIMEMgspPhwkGetjARgwDSo5
X-Received: by 2002:a17:90b:53c3:b0:39d:f130:8f13 with SMTP id
 98e67ed59e1d1-39e54e3c624mr985500a91.21.1789683276095; Thu, 17 Sep 2026
 15:14:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260915080255.48929-1-tasos.papagiannnis@gmail.com> <20260915080255.48929-6-tasos.papagiannnis@gmail.com>
In-Reply-To: <20260915080255.48929-6-tasos.papagiannnis@gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 17 Sep 2026 15:14:22 -0700
X-Gm-Features: AcwNN1V6otsO6IWksnCzkd743-EAl1OOZ6ho93SkT0O5q69xaMVQFn98PY1WbH0
Message-ID: <CAEf4BzZui5ywrdEz1Sz+XuSEOyFVBnGR_F0SU0vNuhBpaGpqGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 5/5] selftests/bpf: Test mm_struct user memory
 kfuncs with linux_binprm
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org, 
	akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org, 
	brauner@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com, 
	kpsingh@kernel.org, ljs@kernel.org, matt@bobrowski.net, memxor@gmail.com, 
	song@kernel.org, sun.jian.kdev@gmail.com, utilityemal77@gmail.com, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 52FEB40007
X-Stat-Signature: 5x53gghcr3yoja717guh54u3dj6j79ta
X-HE-Tag: 1789683277-217217
X-HE-Meta: U2FsdGVkX1+Ci8rGSkZpmnCT/EsLGilGn9J3b11sWv98gzjjNaPrL5/DLFNdySg3Zzk72m1Hk9YY3j/wRsgCNj57p0eBanCP7fxjviYY2N/Kuln40JVCUeAPsLRun6voSFuM0pJ3mRIdhakDTbB0PZ8Cu07cknxXpzdvGufHCKQnpKqyg7o0yRkMD0qOzR4YMnY3pOTDuXRLQ01y0Pu+uPAKfgbxNhfoz0DtzY+dPzgIfhNOYZer6HOJgVFYxzaGxM8pM7WaTnuJQAk2xuZJCn5PEqL+y0Kk96HeZ4zTF6iPLpvXLfblgPoMVlY07jcvlUFoq8zQMO15SnY5OWhUjJfDIYe82Z14Ruho3Hw2RRuD0Lo7idRe/6PljR9gPn5J/cxUs5SoAOlDsmuH8GADbNtsLp/diQShHDCKEc0gWYqaLNq0i/5GhTuvwgcZK7WUGj37gQezNAKtexqVfcgqCtiXtukeTUxAywldoccNLv4KXUd+cDspU4gFY/dVwrv1SmnA1Q+86WlVBA5nZjkCHOOp+e4oBm8d5qdS2YJHHf9GCOfh77/7TZy7dBq2jZ38hMl8q1CTbHMqMyt+s7P97jLqR8IlrwfFr2S1X2E9T6iZIWWk2HyaW1b/FiAOg++Lx6lrU70rt9ixX35N3f64eFsZXc7dWOG/DkVRO44gfd1KKpqFuHsYZmoHWCX3unRMnR37Gv+G94I8j1wDVtjJVmAThngn+OjsQAmu/5HDd7w5d7i9knNotNLFKpYGz4JIhKVBOs4OE/AbdIXQ/0yBL04stQ7bc795pZE2QUnH1VqURqffbDdnqOEVMLM/4BX1LcWwXp09SZKvlMoRqs+9lLCy8tnE22D24MGw1FEUdBI+vJtELOSbnGwuonpWGyfMqVW8RwELIZRHkkkjMax17D1lPVWZmYK05gFA79Wxm3FMumcH8UQog8WBdB+yo2yE/i7hfVb+sxWYzf/NZHW
 vj1Ps3OM
 gOOPqdUKmxHFCNXbcUMZt5/GobuyuGE5EZzlFo3KG/LmV0VgARloSA9Q4dduYdAWYXh1hsjHpi/dQiixE36Wtba/NKvZGggRMwb6/uN/M4AUQ5+wIiQvRebaave5FUKhZt8n6YhF5oncVPvRzz272p9di2kcS9zU0cxZlHTiP45LnqzihcJ0nvUh+eXVTzh6zRpLPk7NSXVXu80ZOJGfjijg4YkBKjBRpgXRpS/vRQbcTwuIzSRurdL9o+bqUqMNcH/WITveyGOAdLMHBIJJiD4mcjnqoq1Jkv2aQpbOPJ7IoFumrGhK4tKBHawZn+VX+4bmma2tkCFc0bmEA28p1tykvFM94M2vq3CBG7DInMvUF3TanyN9Rb4t9QrgHfyWuTD3uWKhOEmsmbe3Bce+NaWs1HF0Cuj4EJVRY2DXSec1QJwKzJ4uumBnc43+j3NvbdcoXRDugg3NomKHtDDtt/TGMCyaw8QArnZbkcfhFdO/d22u+B9rLwmhcx+kB1GLYRLD+nV8Qh4nlcqycSa62WLB9C5gy/aBlFXvo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 1:03=E2=80=AFAM Anastasios Papagiannis
<tasos.papagiannnis@gmail.com> wrote:
>
> Add a sleepable BPF LSM program attached to bprm_check_security to test
> bpf_copy_from_user_mm() and bpf_copy_from_user_mm_str() on CONFIG_MMU
> kernels.
>
> Starting at bprm->p, verify that bpf_copy_from_user_mm() can copy the
> contiguous NUL-separated argument and environment data. Then use
> bpf_copy_from_user_mm_str() to read each argument and environment string
> separately, advancing the offset by the length returned from each call.
>
> Skip the test on !CONFIG_MMU. In that configuration, exec argument and
> environment strings remain in bprm->page[] until the binary loader
> transfers them to the new process stack, so they are not accessible
> through bprm->mm at the bprm_check_security hook.
>
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> ---
>  .../bpf/prog_tests/copy_from_user_bprm.c      |  72 +++++++++++
>  .../selftests/bpf/progs/copy_from_user_bprm.c | 122 ++++++++++++++++++
>  2 files changed, 194 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user=
_bprm.c
>  create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm=
.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c=
 b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
> new file mode 100644
> index 000000000000..ef351cda9348
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
> @@ -0,0 +1,72 @@
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
> +       char arg0[] =3D "first";
> +       char arg1[] =3D "second-argument";
> +       char env0[] =3D "SOME_ENV=3Da";
> +       char env1[] =3D "OTHER_ENV=3Dsomething";
> +       struct copy_from_user_bprm *skel;
> +       pid_t child;
> +       int status;
> +
> +       skel =3D copy_from_user_bprm__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "open_and_load"))
> +               return;
> +
> +       /*
> +        * On !CONFIG_MMU, exec strings are held in bprm->page[] rather t=
han
> +        * being mapped in bprm->mm.
> +        */
> +       if (!skel->kconfig->CONFIG_MMU) {
> +               printf("%s:SKIP: test requires CONFIG_MMU\n", __func__);
> +               test__skip();
> +               goto out;
> +       }

I'm not sure I'd bother with this !CONFIG_MMU support, tbh

> +
> +       if (!ASSERT_OK(copy_from_user_bprm__attach(skel), "attach"))
> +               goto out;
> +
> +       child =3D fork();
> +       if (!ASSERT_GE(child, 0, "fork"))
> +               goto out;
> +
> +       if (!child) {
> +               char *const argv[] =3D { arg0, arg1, NULL };
> +               char *const envp[] =3D { env0, env1, NULL };
> +
> +               skel->bss->monitored_pid =3D getpid();
> +               execvpe("true", argv, envp);
> +               _exit(errno);
> +       }
> +
> +       if (!ASSERT_EQ(waitpid(child, &status, 0), child, "waitpid"))
> +               goto out;
> +
> +       if (ASSERT_TRUE(WIFEXITED(status), "child_exited"))
> +               ASSERT_EQ(WEXITSTATUS(status), EPERM, "exec_errno");
> +
> +       ASSERT_EQ(skel->bss->bprm_argc, 2, "bprm_argc");
> +       ASSERT_EQ(skel->bss->bprm_envc, 2, "bprm_envc");
> +       ASSERT_EQ(skel->bss->data_len_match, 1, "data_len_match");
> +       ASSERT_EQ(skel->bss->invalid_flags_ret, -EINVAL, "invalid_flags_r=
et");
> +       ASSERT_EQ(skel->bss->copy_ret, 0, "copy_ret");
> +       ASSERT_EQ(skel->bss->str_arg0_ret, sizeof(arg0), "str_arg0_ret");
> +       ASSERT_EQ(skel->bss->str_arg1_ret, sizeof(arg1), "str_arg1_ret");
> +       ASSERT_EQ(skel->bss->str_env0_ret, sizeof(env0), "str_env0_ret");
> +       ASSERT_EQ(skel->bss->str_env1_ret, sizeof(env1), "str_env1_ret");
> +       ASSERT_EQ(skel->bss->data_match, 1, "data_match");
> +       ASSERT_EQ(skel->bss->str_args_match, 1, "str_args_match");
> +       ASSERT_EQ(skel->bss->str_envs_match, 1, "str_envs_match");
> +
> +out:
> +       copy_from_user_bprm__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c b/to=
ols/testing/selftests/bpf/progs/copy_from_user_bprm.c
> new file mode 100644
> index 000000000000..07ca96d9db45
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
> @@ -0,0 +1,122 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "vmlinux.h"
> +
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <errno.h>
> +
> +char _license[] SEC("license") =3D "GPL";
> +
> +static const char expected_data[] =3D "first\0second-argument\0"
> +                                   "SOME_ENV=3Da\0OTHER_ENV=3Dsomething"=
;
> +static const char expected_arg0[] =3D "first";
> +static const char expected_arg1[] =3D "second-argument";
> +static const char expected_env0[] =3D "SOME_ENV=3Da";
> +static const char expected_env1[] =3D "OTHER_ENV=3Dsomething";
> +
> +int monitored_pid;
> +int bprm_argc;
> +int bprm_envc;
> +int data_len_match;
> +int invalid_flags_ret;
> +int copy_ret;
> +int str_arg0_ret;
> +int str_arg1_ret;
> +int str_env0_ret;
> +int str_env1_ret;
> +int data_match;
> +int str_args_match;
> +int str_envs_match;
> +
> +extern bool CONFIG_MMU __kconfig __weak;
> +
> +extern int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
> +                                const void *unsafe_ptr__ign,
> +                                struct mm_struct *mm, u64 flags) __ksym;
> +
> +extern int bpf_copy_from_user_mm_str(void *dst, u32 dst__sz,
> +                                    const void *unsafe_ptr__ign,
> +                                    struct mm_struct *mm, u64 flags) __k=
sym;
> +

these should be already coming from vmlinux.h, no need to explicitly
define them, please drop (and CONFIG_MMU parts as well)

> +SEC("lsm.s/bprm_check_security")
> +int BPF_PROG(check_exec_args, struct linux_binprm *bprm)
> +{
> +       u32 pid =3D bpf_get_current_pid_tgid() >> 32;
> +       char data[sizeof(expected_data)] =3D {};
> +       struct mm_struct *mm;
> +       char arg0[32] =3D {};
> +       char arg1[32] =3D {};
> +       char env0[32] =3D {};
> +       char env1[32] =3D {};
> +       u64 offset =3D 0;
> +       u64 data_len;
> +
> +       if (!CONFIG_MMU)
> +               return 0;
> +
> +       if (pid !=3D monitored_pid)
> +               return 0;
> +
> +       mm =3D bprm->mm;
> +       if (!mm)
> +               return 0;
> +
> +       bprm_argc =3D bprm->argc;
> +       bprm_envc =3D bprm->envc;
> +
> +       /* this is the total size of args and envs starting from bprm->p =
*/
> +       data_len =3D bprm->exec - bprm->p;
> +       data_len_match =3D data_len =3D=3D sizeof(expected_data);
> +
> +       invalid_flags_ret =3D bpf_copy_from_user_mm(data, sizeof(data),
> +                                                 (void *)bprm->p, mm, ~0=
ULL);
> +
> +       copy_ret =3D bpf_copy_from_user_mm(data, sizeof(data), (void *)bp=
rm->p,
> +                                        mm, 0);

single line (limit is 120, not 80), please reformat the rest if it
fits under 120

> +       if (copy_ret)
> +               return 0;
> +
> +       data_match =3D
> +               !__builtin_memcmp(data, expected_data, sizeof(expected_da=
ta));

nit: keep single line

> +
> +       /* arg0 is at bprm->p */
> +       str_arg0_ret =3D bpf_copy_from_user_mm_str(arg0, sizeof(arg0),
> +                                                (void *)(bprm->p + offse=
t),
> +                                                mm, BPF_F_PAD_ZEROS);
> +       if (str_arg0_ret !=3D sizeof(expected_arg0))
> +               return 0;
> +       offset +=3D str_arg0_ret;
> +
> +       /* arg1 is at bprm->p + sizeof(arg0) */
> +       str_arg1_ret =3D bpf_copy_from_user_mm_str(arg1, sizeof(arg1),
> +                                                (void *)(bprm->p + offse=
t),
> +                                                mm, BPF_F_PAD_ZEROS);
> +       if (str_arg1_ret !=3D sizeof(expected_arg1))
> +               return 0;
> +       offset +=3D str_arg1_ret;
> +
> +       /* env0 is at bprm->p + sizeof(arg0) + sizeof(arg1) */
> +       str_env0_ret =3D bpf_copy_from_user_mm_str(env0, sizeof(env0),
> +                                                (void *)(bprm->p + offse=
t),
> +                                                mm, BPF_F_PAD_ZEROS);
> +       if (str_env0_ret !=3D sizeof(expected_env0))
> +               return 0;
> +       offset +=3D str_env0_ret;
> +
> +       /* env1 is at bprm->p + sizeof(arg0) + sizeof(arg1) + sizeof(env0=
) */
> +       str_env1_ret =3D bpf_copy_from_user_mm_str(env1, sizeof(env1),
> +                                                (void *)(bprm->p + offse=
t),
> +                                                mm, BPF_F_PAD_ZEROS);
> +       if (str_env1_ret !=3D sizeof(expected_env1))
> +               return 0;
> +
> +       str_args_match =3D
> +               !__builtin_memcmp(arg0, expected_arg0, sizeof(expected_ar=
g0)) &&
> +               !__builtin_memcmp(arg1, expected_arg1, sizeof(expected_ar=
g1));
> +       str_envs_match =3D
> +               !__builtin_memcmp(env0, expected_env0, sizeof(expected_en=
v0)) &&
> +               !__builtin_memcmp(env1, expected_env1, sizeof(expected_en=
v1));

I'd put env1, env2, etc into global variables and do comparison in user spa=
ce

not that this is broken, but there is no point doing this in BPF code

> +
> +       return data_match && str_args_match && str_envs_match ? -EPERM : =
0;
> +}
> --
> 2.55.0
>

