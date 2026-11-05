Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE426606A33E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lL+rueNl
Received: by kanga.kvack.org (Postfix)
	id E55BA6B05C7; Thu,  5 Nov 2026 05:33:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07666B05C8; Thu,  5 Nov 2026 05:33:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44CA6B05C9; Thu,  5 Nov 2026 05:33:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA1AE6B05C7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:33:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44FCA14094F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:33:25 +0000 (UTC)
X-FDA: 85400703570.15.1050CAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 99626180002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:33:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lL+rueNl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874803;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3VKtMFUcvKjJEe9s8szWWukUuDsVUDxIJTJiZTdgl9o=;
	b=3HkvMc4WB8KQ/2IIz9OpUgo2xPC0V3w+AaQfgeykWwpfbQDho13X13CVk2OYlAdfpXsV37
	FsM+FO1g7vgPeYe3g2KWtWuQ4bq8awOyaFLzwcrnj3zfWc2TuGXbxUNbWeB30uwm730oW7
	4iBtehDI7k5H0w//rN0Zv4chGjNryAU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lL+rueNl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874803;
	b=aDIcUqb6+FlGXfkWFJBYVRRLgtMcHW9N6f/fdL3F15MEX82BZM+GVsrwvmFbrUCnVZzaqC
	oeb9t0XwJHqrYP7HNtfmGbfvQbxYWoECaezMF+Gnnm4a4bDjtipjUcoeS25q5C3/X8gSza
	cY0CKBWGD5IEhFs/fdcaZrd+EtixU+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6C0F40877;
	Thu,  5 Nov 2026 10:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6F01F000C1;
	Thu,  5 Nov 2026 10:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874802;
	bh=3VKtMFUcvKjJEe9s8szWWukUuDsVUDxIJTJiZTdgl9o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lL+rueNlOuxwK6jMOoLgjD/3XR9iJOsgyqXAYHVNDlMY36sku3+yybFGvu68+2lKp
	 m9bVwHfTDNPJgUSUvfgKgJPX92CsxzcztSDkf5i5yOdo2g89q/Rp2j0bLId8MLWGI/
	 m4LmLhmR7KRj58uoaKOJP4ib8Hn6INUOxuYJE+64dw2EdysFARAiwa6XxuVunCG5sx
	 CGPx0b1DK82ARoqHebswt9PL1+/CU5EIc8xrt08YHYCoNxiNw2z0fVNx+fem/6ghgF
	 qkOUBRpESfJPEztHylmqVmmwfASlWjxd3r923XlyjcYhrC7YvmsQCkb3TvmkkVrvgb
	 W+ZhWUnpSXymA==
Message-ID: <sashiko-outbox-198860@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCHv3 bpf-next 5/8] selftests/bpf: Test user memory mmap
 kfuncs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiri Olsa" <jolsa@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "John Fastabend" <john.fastabend@gmail.com>, "Federico
 Di Pierro" <nierro92@gmail.com>
In-Reply-To: <20261105102343.311331-6-jolsa@kernel.org>
References: <20261105102343.311331-1-jolsa@kernel.org>
 <20261105102343.311331-6-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:33:21 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 99626180002
X-Stat-Signature: dfqqfqdsrjn6nhtky5oyfzmhd6w8eit4
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793874803-388830
X-HE-Meta: U2FsdGVkX19FcjA3sHeWU2fhWHXQbqp51TAoe324wjiMRXIHHL8GCreVosdUwVMudzfn0jBFnOqFG0YTIS5ZZgdLFXaz6hUSrYjB3vDQsIB9+zRH+wjM16V0m2CTD6zDNd/NcvnibiYBRXknVJNMCG/AgKEcGEvTblPljSONZVeUpsGZVvRrxn2k+jPPwx0iRPckXp1O387JdqKM0fwecc+tzxEfJ0PJYsI4Wcezf7BMjVwTFWprbRjztdOcHv94aPvPgRz7W2n0OsTlxbsm7QNRUPaZ4NQy6jfEOE9zeaS3wk9lDwFmW7jLJJVGHOL7d7O0Hzq3eMz9P3bnsv4gBZE0yuN3O2hUcjNlGn1QbMamft4Z4MYxoILVs8vsqzDBMYWqRMnDiAj+1Q2gEbS4V3EG/QhXB747jYq+Ac+ma+4jxeRHdiuUDgo2fmoFe1+x3YzrsF73gm/VwFrIgEPeL0EdwvxVSluf/CAa8Ce/+TSP/7UPPSQBuufBYHSrm5mwZmtOLFkCBpSEe9j/o6Ge8aWRgMtvVXgMXOrhxvso6ADlkb88lK64Q9nyOFpe7rhpFtPisk7u0TruE/bajE1IrbUTxRQ7M5TUunk/T/NCSBcffVsLLzRzcfgrnW9lJ+UtHVLO4jBLsQLwd8+lfM1+/MpQSoYzjYy5vY3g81eyLZ2Lz1Bq/z3KP7O8tJ1D3OfOSxkFNGwoJFCfMUZBfeR2y0t6EvDJ1tqaMpbUG/1V3hHyZaKO4uzirnG92T8gGv0sIEvTPfLdy78gIZAiwI5qPmw5F1tCPq2DwTTrbKGwwEL60JcZQ/sHM4u1EYddtt7e/pA86a1w/cb0aFcWv2NLQpFqlTWx2UCN7N9/nMWN8r3ujQSEYrNA3WDCbZcpQ5dq3z3sadYCph2YI61ucxInScaJQMokAdVkFFQ0s4ultbq+P2IuXIzPzG8Okv2I/0vja0a3jcSogxnL+9rCEGl
 g1y6mw29
 mIyd8SUnWa5RGw1t4kIK45bIAz7H2T63zyei3Ecb6yYIFGw4aJkRCE5/+MsKWlkJsOBWgDnhPD77wwzvVkQZ0/FlxgwTNe3hbPs3bWovXH6L9CMWPwTbVG9ZM2BWKREp4DHpMcw1ouIQWlpPxKcjtXf50OcQkrvpGmdc8Yub2QgOc1bvLQtQODTkc+r0BonoyrsqMbyPn0k7nq9CQSmL/iD8x0yaH8hiMoj/jJD8mLMJtD3gzpABQAnBwG+FPoeHcLumbeYoWOYzz1p/q12qMJ7tviImYG0It2GI8KtTJwjp/AMRY614+M2/dMX97xvxL0WEqbh8PQYSA6AxkVj6UKcv25Gu2uCZtXRQ/OucPL80QZgaVsaVJV1PFerE+LqMrK+wMTDw7c8zqgTa8ELuqZ0CkxB/OUJ/m505hezt3mPh7UP/KEjSE6DBgN960IlQVeL9TU7j758oNHK0ronGP0oYmMgpqa4A0p2XoReKCetGp1aIGYzQqcJFS1QO4UVnFrmOG2fmWwCIR0Ct/tyNYOS2feLgVziZgPX2eKCoHkkBwyke6VMW2jpjmhfPIoHfWRibd6QNwoTVF6eVVHNw8NtebSkXRchjAhajf49Ar0Qkoqamvjni32xNNhzwihB9v+xmUuOajYW2NzEuuYgs3Tvs+n+0SYqTkTTuZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] selftests/bpf: call to undefined get_procmap_info() breaks build
- [Medium] selftests/bpf: user_mem_test() calls non-existent user mmap kfun=
cs
--

commit 602c938f4e2233efed73c162a7e2295814283b95
Author: Jiri Olsa <jolsa@kernel.org>

selftests/bpf: Test user memory mmap kfuncs

This commit adds BPF selftests for bpf_user_anon_mmap() and bpf_user_munmap=
()
invoked from a sleepable uprobe, checking that created mappings have the
expected permissions and that unmapped addresses are removed.

> diff --git a/tools/testing/selftests/bpf/prog_tests/user_mem.c b/tools/te=
sting/selftests/bpf/prog_tests/user_mem.c
> new file mode 100644
> index 0000000000000..eadf668f7056b
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
> @@ -0,0 +1,111 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <test_progs.h>
> +#include <sys/mman.h>
> +#include <unistd.h>
> +
> +#include "user_mem.skel.h"
> +#include "trace_helpers.h"

[ ... ]

> +static bool check_user_mem_vma(void *addr, unsigned long size, const cha=
r *perms)
> +{
> +	size_t start, end;
> +	char vma_perms[5];
> +	int err;
> +
> +	err =3D get_procmap_info(addr, &start, &end, vma_perms);
> +	if (!ASSERT_OK(err, "user_mem_vma"))
> +		return false;
> +
> +	/* VMA can be merged, so ensure it covers at least the requested range.=
 */
> +	if (!ASSERT_GE(end - (size_t)addr, size, "vma_size"))
> +		return false;
> +
> +	return ASSERT_STREQ(vma_perms, perms, "vma_perms");
> +}
> +
> +static bool check_user_mem_unmapped(void *addr)
> +{
> +	size_t start, end;
> +	int err;
> +
> +	err =3D get_procmap_info(addr, &start, &end, NULL);
> +	return ASSERT_EQ(err, -ESRCH, "user_mem_unmapped");
> +}

[Severity: Medium]
Was a prerequisite patch adding get_procmap_info() omitted from this series?

Both check_user_mem_vma() and check_user_mem_unmapped() call
get_procmap_info(), and tools/testing/selftests/bpf/prog_tests/user_mem.c
includes trace_helpers.h, but neither tools/testing/selftests/bpf/trace_hel=
pers.h
nor tools/testing/selftests/bpf/trace_helpers.c declares or defines
get_procmap_info().

Because the BPF selftests are compiled with -Werror, does this cause buildi=
ng
test_progs to fail with an implicit function declaration error and an
undefined reference at link time?

[ ... ]

> diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing=
/selftests/bpf/progs/user_mem.c
> new file mode 100644
> index 0000000000000..e3b0689f5f2a5
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/user_mem.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <vmlinux.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +#include "bpf_misc.h"
> +
> +char _license[] SEC("license") =3D "GPL";
> +
> +extern unsigned long bpf_user_anon_mmap(unsigned long len, unsigned long=
 prot) __ksym;
> +extern int bpf_user_munmap(unsigned long addr, unsigned long len) __ksym;

[ ... ]

> +SEC("uprobe.s//proc/self/exe:user_mem_trigger")
> +int user_mem_test(struct pt_regs *ctx)
> +{
> +	if ((bpf_get_current_pid_tgid() >> 32) !=3D monitored_pid)
> +		return 0;
> +
> +	switch (action) {
> +	case USER_MEM_MMAP:
> +		user_addr =3D bpf_user_anon_mmap(map_len, map_prot);
> +		break;
> +	case USER_MEM_UNMAP:
> +		ret =3D bpf_user_munmap(user_addr, map_len);
> +		break;
> +	}

[Severity: Medium]
Are the kernel definitions for bpf_user_anon_mmap() and bpf_user_munmap()
missing from the tree?

In tools/testing/selftests/bpf/progs/user_mem.c, user_mem_test() invokes
bpf_user_anon_mmap() and bpf_user_munmap() declared as strong __ksym extern=
s,
and test_user_mem() in tools/testing/selftests/bpf/prog_tests/user_mem.c
loads the program via user_mem__open_and_load():

    skel =3D user_mem__open_and_load();
    if (!ASSERT_OK_PTR(skel, "open_and_load"))
        return;

Since neither bpf_user_anon_mmap nor bpf_user_munmap is defined or register=
ed
in any BTF kfunc set in the kernel or selftest kernel modules, won't
user_mem__open_and_load() fail unconditionally when libbpf tries to resolve
their BTF IDs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105102343.3113=
31-6-jolsa@kernel.org?part=3D1

