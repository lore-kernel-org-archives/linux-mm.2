Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE8F606A332
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L+w76bhR
Received: by kanga.kvack.org (Postfix)
	id C098B6B05C3; Thu,  5 Nov 2026 05:32:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE1A46B05C4; Thu,  5 Nov 2026 05:32:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27FD6B05C5; Thu,  5 Nov 2026 05:32:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2126B05C3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:32:04 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 218C01208E9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:32:04 +0000 (UTC)
X-FDA: 85400700168.02.192E233
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 74FB240003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:32:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+w76bhR;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874722;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKhjKjL6NUJD8Nx7MIL7fAZeI2PVjUsp8Wn9XjenML0=;
	b=1jj1xVtArfd9zwtaqsPXYqipCcG+PGmDHM7pFuh9U/hkcz1BfAE8ngBRZSvwSxzfiixOc0
	2bbBwkbXKViV8SSUNPeThuOnFE/2fa/9jquSM5bZ7Jc+/ED28bcreLq+J9iPo9s06nADI3
	LlJX2f9mcJ72dxutn+3/QWz6M2qiHZA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+w76bhR;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874722;
	b=sJtREKJxASU3NC/BqLl/LF1YNUmjPh1FLEzNaUMfscrYji3hp9o9oNmYc1KUQu+QYgaH9h
	1lkNP7eyLsd1LElxq6wYiHJm05QXiALJtJ83W3aG+1r5G7sX4XnGniZa+g9lJk7nIyBSRv
	Nu006YVDww0XifCiKkWHO09baaeg8PA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8B8541642;
	Thu,  5 Nov 2026 10:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376B71F00919;
	Thu,  5 Nov 2026 10:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874721;
	bh=xKhjKjL6NUJD8Nx7MIL7fAZeI2PVjUsp8Wn9XjenML0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L+w76bhRzvh3DlQftxYcZVSjXpIK0PKvDJXlhm+XtBg+CcdCP1pMKjOZ8HY56g585
	 q1p8JHZKs7HZ5rabs5rrpLYXFJBqC4Op9YaJnNCkiNWk+UTYDV55moBm6pOfA4vwvA
	 B1XJU8yX6GcZvaSr5yjw1rZ3wmBUjVMujPPlZOAlvCVFTi64vL4zyMllAxI3BY6uUt
	 FxSfgKdIqNBbBz4yPHNCNEUpljza8e9jqHhpC44B8U3qbSDLuLQBPgY2za/5obEhre
	 UWIuEqJ6v6HAPvl6TsxKkrKSmklNgbRVsPkPyI6ahAa4mYZSlrQuFnHva4N3NwarWE
	 0Qg+ocdKu9AhA==
Message-ID: <sashiko-outbox-198859@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCHv3 bpf-next 4/8] selftests/bpf: Test const kfunc memory
 arguments
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiri Olsa" <jolsa@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "John Fastabend" <john.fastabend@gmail.com>, "Federico
 Di Pierro" <nierro92@gmail.com>
In-Reply-To: <20261105102343.311331-5-jolsa@kernel.org>
References: <20261105102343.311331-1-jolsa@kernel.org>
 <20261105102343.311331-5-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:32:00 +0000
X-Stat-Signature: gjf5ego4r7pzanh3jw4gbpfqh6debtn8
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 74FB240003
X-HE-Tag: 1793874722-716539
X-HE-Meta: U2FsdGVkX19nI0FE6QYMEBUazkolg9QwkK3d+2rtGeuT9C3sHSdtS0Yf4T9yabs0uNemJISXPQfVLBMWw3+WAmCdXffb73ZS8uXJTfNdJeNjXNvW7UxIl0cQyTOZEQZglgT/y9lY209ETYh+4Fu6GWKhVrt3SlcaX/uIcK/RfvcAdXblylM25Az7GwhAfYuQp0Y/qLjYQ6FTvLP1at6SozPxhkoGrI2jE8Cx+bHE08koDiTKyrJJ3zz74Cfp7IHkJ68BP/Y10YQ3wIZ3m2q57/6feA3XBC9JzzXDTlFT6kUCHLv/l4qQjVtEXClX2uDQhUt98NmAV9GU+fy4MSweB8osCksONWGijgeW/MM//hwxSCTBecFBLVvbMWs+OeXlLdzUqfsmfozJy8zzyvjFgQAFrHucqmBhMucBuQZgsIBjPacobeu6eFICBU274kIQ7jh6rUvVP+adaY4J//WfzjCauuY4ejocZV8v/cQ2sngQUK875ca/W2W6uJDakwjRkpuSq54Szi63ab0wG0XIUEXUKTnWrfaTve8vJMjRifZnhRdQ9Q5Wemo4ffbdJzpzgO9NEgGNMsXqtUT2RV6gl9srWOsqNEygTAacTMBxnKzYMBamfhXK5Ix0JbyOiYOvpOlFY2RPLdFrbE7pjh5hMSPOAvFpzRCtzzCtXFqVQH9zdXnlqxCp+P8KfkZVz9fbY3rbUCBRw4FeFfQn6dID0Ig8rz7qQAZ6X7CvuYB8vLmaH4rvQW0RsFLkHZPiTXZP07IJXSDXSdVWORZ8r1Qx8EI2C69o6N8Efj4CG9ZyEjKESJ2CIIoDNsTQjJ3hqAFjJO/O5Ln8WTNBkJnvhini5odMMS887ysrqh8kgGumAef07ffEvlXKuNnsFYra774dp/dfK3VjpWQhggCIP8ajM7TPGE8ISa9/udfM3ZEn94p8yucWTSgO2t5/KmXVUmAruzUQSzn6dACWWG9At/P
 spBc+Rl0
 usTf98nPNVZMdUiCqb6nzMzxdaSXueTbMbVCwGsDsPQb5o2zyN0A3dD8z1jaSG319U7UX8Esyea/ePSYtDTIdRyEbPnJCkup3cOVzlNMyEDgFlkAMgbkYPaD2+pEPI/6jsVmLKTy14gn6LWfN7LldgX4cKVL/CusnEI3oBBK9Y6Ok9z3k1pUe2eiZBRXBIuuDZEaafSOuyoej2Hi7cgM1tEVPJuLbGNtczFJQp74wwIRNRRZtzUCBMgANdm5g0CexCNm7TZW6iOM7j+ZINjN2VfUwWPy76/er53px4+QVq2k2IZqC25pvYmMODb06Ioar3GxwO0UEmSKguqMt6bpU0rNyeF5Po/lqB9BiMbuz3WKxnHWXaoBpIwVNzG+cJwNiqGFYfkJ6ZRS91MlcADQ4ZScVj+AmmdVAmS1WYlKCdcqOLXQI+7zLCXRqEmRYRtuLs+yqdahffGTsFg+zEX34Xp6/IPMP/EEv9yGcH10tjtHsp4kVk3WXpotWSZKWcJnHgNcwD5LEpQAax0e0CHAL210m6mxI8DkYDy2tx2ZwUuuuzqiH7+tgtNdQLupsa9eHhLHw6U4aeLa1QbPXn4qtiVNDiZCQ0S4y4utrAv/r0twe8r+G5Lc4ZjnmJxCd385kZDQKauup4RMi5tydPMRkB5gsbnQa6Qz+3sXO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests/bpf: kfunc_call_test_const_mem() fails due to MEM_WRIT=
E in verifier
--

commit 0e976b113cb623dc07d1d416bf2badf98c0f26f7
Author: Jiri Olsa <jolsa@kernel.org>

selftests/bpf: Test const kfunc memory arguments

This commit adds BPF selftests and bpf_testmod kfuncs to verify passing
read-only global data, writable stack data, and const scalar structs to
const-qualified kfunc memory arguments, while rejecting read-only data
passed to writable memory arguments.

> diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/=
testing/selftests/bpf/progs/kfunc_call_test.c
> index 8e6560c31e781..4f4a6713aa6e5 100644
> --- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> +++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> @@ -5,6 +5,9 @@
>  #include "bpf_misc.h"
>  #include "../test_kmods/bpf_testmod_kfunc.h"
> =20
> +static const char kfunc_const_data[] =3D "read-only source";
> +static const struct prog_test_pass1 kfunc_const_struct =3D { .x0 =3D 1 };
> +
>  static struct bpf_spin_lock kfunc_call_lock SEC(".data.A");
> =20
>  SEC("tc")
> @@ -208,6 +211,17 @@ int kfunc_call_test_pass(struct __sk_buff *skb)
>  	return 0;
>  }
> =20
> +SEC("tc")
> +int kfunc_call_test_const_mem(struct __sk_buff *skb)
> +{
> +	char stack_data[] =3D "read-write";
> +
> +	bpf_kfunc_call_test_const_mem(kfunc_const_data, sizeof(kfunc_const_data=
));
> +	bpf_kfunc_call_test_const_mem(stack_data, sizeof(stack_data));
> +	bpf_kfunc_call_test_const_struct(&kfunc_const_struct);
> +	return 0;
> +}

[Severity: Medium]
Does kfunc_call_test_const_mem() pass verification without a corresponding
verifier change to preserve const qualification on kfunc memory arguments?

In kernel/bpf/verifier.c, get_kfunc_arg_type() strips modifiers from the
pointed-to type via btf_type_skip_modifiers() and unconditionally marks
pointer+size and fixed-size memory arguments as writable:

kernel/bpf/verifier.c:get_kfunc_arg_type() {
	ref_id_ptr =3D &t->type;
	ref_t =3D btf_type_skip_modifiers(meta->btf, *ref_id_ptr, &ref_id);
	while (*ref_id_ptr !=3D ref_id)
		ref_id_ptr =3D &btf_type_by_id(meta->btf, *ref_id_ptr)->type;
	...
	} else if (arg + 1 < nargs &&
		 (is_kfunc_arg_mem_size(meta->btf, &args[arg + 1]) ||
		  is_kfunc_arg_const_mem_size(meta->btf, &args[arg + 1]))) {
		...
		arg_type =3D ARG_PTR_TO_MEM | MEM_WRITE;
	} else if (btf_type_is_struct(ref_t))
		arg_type =3D ARG_PTR_TO_BTF_ID;
	else {
		...
		arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE;
	}
}

Similarly, for bpf_kfunc_call_test_const_struct(), get_kfunc_arg_type()
records the argument as a BTF struct pointer with proto->arg_btf_id[arg]
pointing past the const modifier, and resolve_func_arg_type() then rewrites
the scalar struct argument to writable memory:

kernel/bpf/verifier.c:resolve_func_arg_type() {
	...
	*arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE |
		    (*arg_type & (PTR_MAYBE_NULL | MEM_UNINIT));
}

When kfunc_call_test_const_mem() passes the .rodata globals kfunc_const_data
and &kfunc_const_struct to bpf_kfunc_call_test_const_mem() and
bpf_kfunc_call_test_const_struct(), check_func_arg() requests write access
via func_arg_access_type() -> check_helper_mem_access() ->
check_map_access_type(), which rejects the program with "write into map
forbidden".

Because kfunc_call_test_const_mem() is an autoloaded program in
kfunc_call_test.c, won't this also cause kfunc_call_test__open_and_load()
and kfunc_call_test_lskel__open_and_load() in verify_success() to fail for
all subtests using the kfunc_call_test skeleton?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105102343.3113=
31-5-jolsa@kernel.org?part=3D1

