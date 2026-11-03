Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AB0B606A332
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VDPxkxfI
Received: by kanga.kvack.org (Postfix)
	id 3A1116B05E4; Tue,  3 Nov 2026 03:10:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378C16B05E5; Tue,  3 Nov 2026 03:10:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5F36B05E6; Tue,  3 Nov 2026 03:10:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 05E4B6B05E4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:10:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82DB1120328
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:10:27 +0000 (UTC)
X-FDA: 85393085694.02.91AC179
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D4AD01A000D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:10:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VDPxkxfI;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693425;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gf7UzY2gyj9UdBb7dmvQSKLfA12i+FWmWNeRPHVftXE=;
	b=fReb/UdPM2Px/GcMYg2LNO+VLwIhj/7pAGOADC/IWA7A3QvnzVQEK2ez4HLN1KoYhSrDcK
	7gh/05aIYlyRJbz8I031fraf0xTUCY4jZjBKxwCweRYUfT+/tweTKRDz9sjD+PboGShWij
	mwjA6/3UMEZiiS8Ufg3OhDUzd2syy1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693425;
	b=NbeqmwdozQasGn4ZBYIBADhOzx3PrlUNcKftMKus9ifkEvekpu76gprqOpOK2vk6sby+8C
	8hOhgnt+9zgMwA9PV6EAhWnj0m7sA+civIO83yDevhQEbOKuQ1EL/MzeDseLdxYBENJOQQ
	oqw4Fbn60dhk1J8YrzmSZtc5nxQKeew=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VDPxkxfI;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 297DF42EAB;
	Tue,  3 Nov 2026 08:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835051F0093A;
	Tue,  3 Nov 2026 08:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793693425;
	bh=gf7UzY2gyj9UdBb7dmvQSKLfA12i+FWmWNeRPHVftXE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VDPxkxfIN1/tz7qRiZjIqYYJ58JXQz8ILAaIeA6Kwj6xYm+OF+KzlBeY+eM+WiFuC
	 JR+sL68AHeA33POxDTHaE3MQTDDqKY6/smIfyhv4oFTEv31m7rUY5R7TQuX/xwUqLN
	 jHTjGzNT29BUDXhzj5wsH0wEEPW5rvOxJPcLut9D1/GuRXVjY8kyCdQEOIdg+zX9E7
	 z5wneTARPobNGGiSbtDKhvGthxhcpIDQGbgOBHUAnEW1bkv1gAJF72/YGtQ08sMTV4
	 LwET6PqPGSB4hZhO8nH0tCMdYNnQRSDTjHCV3VWckpDWks0JccNYI+NCWIBpkkzgmP
	 nz07vmwRcZKBg==
Message-ID: <sashiko-outbox-194803@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCHv2 bpf-next 4/8] selftests/bpf: Test const kfunc memory
 arguments
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiri Olsa" <jolsa@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "John Fastabend" <john.fastabend@gmail.com>, "Federico
 Di Pierro" <nierro92@gmail.com>
In-Reply-To: <20261103075916.100050-5-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org>
 <20261103075916.100050-5-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:10:24 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: upb94oy78r7d8rww1u5snq8tk4sqheja
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D4AD01A000D
X-Rspam-User: 
X-HE-Tag: 1793693425-86929
X-HE-Meta: U2FsdGVkX1+PSXPZvVBPF5DfREzXR2fOnN1J1qL6edJtFXRxMyX0QfPfsvuXdRupPCSPtda7Wd4uQoYeC30FRj/WQtSEPEdGCD4b5ajRvlD9yQMzB6hz7rTew+FrcpSx4wcrFWAbONnpig6suWRcRybasW0nI1YoL7whqy3K8h68+87zHSMjlQfRQjWJc5TpmG1uiNkOGN62CFT9sQFRdZBOrJVANtd1mAa52AIUXm7ZymosD7sQ0R3sgRqVDB5rZzD7jV1tijtzj71KSJhaFW12KbezwqeA9qmE1mDAhLDf9l9+2ODzgTA93obIsfBksLiu+KFCxeMa/qW0RH8aoP8xkgygNNCm4HeM/4Hku0g7/HDqHRkOFSpO16cosH7tDav4G8loOdyxgtd09/9x/rKwtNhlzIojodLLdp6ZUgqU5pskNEakFub2RKuF8OPX/BMW6uO61Wf8nyFjYPN4wjD+fgNKvpR4/O0nBgSQjv04loLPvywbC1Oz7e2fSSOGhb/3umEeN/SMgyb8i+MPtcgDye479TJ2tq0b7Rn+Nq5V/rYH2mIXE2reV7AmI0OJ/erqwJ/xuREAgv69vDNGEKRLHRkf6FbPrwFDumm/UpE48nyueQXvU4ntr4FLmKDStL/Z5l9r+p7+02msWS+jDUj+J5u0PJmgulAW2BzNB77thBVqZQj2KgUdzmRCe/IrphroSKl9Fogr6jD5tlxdxBLKHNcQugoaIVBfDQBS2Ya2qE3iX4pF7HZKjY9WmneyGLynPLII9+d70oBqPAV74HUGAUnBmyQgBm4qKtQMSas/K0Tb6QTknI0+k1Z40zsY7xc1Mh226r5gvF18vhUJXbzY1rxkKZYoAp/tojIO8fhl6RELlol2v673ICIXP2B5P5FFgBfo0Diiog08blr8Vi1GfQBcTE3fk3l5SKZLM152FoIDiIpN41CZ6Q0dtG9GBS0S+xxkh0K5bVY70ZZ
 2MCRBMgP
 5rOeC8Lv0sJozTDfXvOpzmxF5tiHPwA1NsEHs619Nc4x4Rp0pu6ZxmTwB1diQldN8ACH9FmvG83T7Y3ewGhS908kAo7PhyGUoAVG0FimXOWflIZfqi677Nyodxb9A+DIg07rX4t2kHYR0ThwitBOkr/G1+K3G6tHnKwTsb85JTzXlvmHBG+a27eEGj6Sji0xG1Q2iB8QDR0Bt6z0RM2cYo+meljPe1++D8GlMgP4SCiz9THuy76bZ5zMUSMfyZL/gWRqk3mVXAq/RxzE6k2Tb87aYMZ19yK22cdr4RqQHQIJgXLqZPV9m+N8O6O/+Fv3OiOq0fMvuIqfQ0U9m1AMkjh3bdwNEVYSVzEPeIBK2tKhh1rwzejzaSf+SG4Hazj1UVf0h0o/SZoNH0WNZ4B87oAPEaXYjCf3lyZh9zbaDD98jceuhDrJC9TO7VpHeWZ88BwHqOg2WNZHr0DeEvY8aQsshprib8N1YTrKMpqkeRwqARBHlVn8WNtBVGolgcOOXjNZzT+I1PO+1XsjSSMnimBh7bH9fU0Knbm+fnj2bZLGYTvs8dRukDkUuclnnUZc9LLKZh1xLGLlPebOm/erEGDpyQlbLmnHmXN1wfZxWwzwCJn8CP7HRYQRmQLbTyhbs6C1uCbPVGvqVh3wEN4YQyvDX0CTJVSvNYwwM
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
- [Medium] selftests/bpf: kfunc_call_test_const_mem() fails verifier load w=
ith MEM_WRITE
--

commit d0fe747011b126dd39ad19108026e34fdd9f18ce
Author: Jiri Olsa <jolsa@kernel.org>

selftests/bpf: Test const kfunc memory arguments

This commit adds BPF selftests and bpf_testmod kfuncs to test passing
read-only global data, stack data, and const scalar structs to const-qualif=
ied
kfunc memory arguments, as well as rejecting read-only data for writable
memory arguments.

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
Does kfunc_call_test_const_mem() pass the verifier without a corresponding
verifier change to preserve const qualifiers on kfunc memory arguments?

In kernel/bpf/verifier.c, get_kfunc_arg_type() strips all type modifiers
including BTF_KIND_CONST from the pointed-to type via
btf_type_skip_modifiers(), advances ref_id_ptr past them, and unconditional=
ly
sets MEM_WRITE on sized memory arguments:

kernel/bpf/verifier.c:get_kfunc_arg_type() {
	...
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
	}
	...
	if (base_type(arg_type) =3D=3D ARG_PTR_TO_BTF_ID) {
		if (is_kfunc_arg_map(meta->btf, &args[arg]))
			proto->arg_btf_id[arg] =3D reg2btf_ids[CONST_PTR_TO_MAP];
		else
			proto->arg_btf_id[arg] =3D ref_id_ptr;
}

Similarly, for bpf_kfunc_call_test_const_struct(), when &kfunc_const_struct
(a PTR_TO_MAP_VALUE in .rodata) is passed, resolve_func_arg_type() converts
the scalar-struct pointer argument to fixed-size memory with MEM_WRITE set:

kernel/bpf/verifier.c:resolve_func_arg_type() {
	...
	if (!btf_type_is_scalar_struct(env, btf, ref_t))
		return 0;
	...
	*arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE |
		    (*arg_type & (PTR_MAYBE_NULL | MEM_UNINIT));
}

When check_func_arg() validates kfunc_const_data and &kfunc_const_struct,
func_arg_access_type() returns BPF_READ | BPF_WRITE because MEM_WRITE is se=
t,
causing check_helper_mem_access() -> check_map_access_type() to reject the
read-only .rodata map with -EACCES ("write into map forbidden").

Because kfunc_call_test_const_mem is an autoloaded SEC("tc") program in
kfunc_call_test.c, wouldn't this cause kfunc_call_test__open_and_load() and
kfunc_call_test_lskel__open_and_load() in verify_success() to fail and break
the kfunc_call test suite?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103075916.1000=
50-5-jolsa@kernel.org?part=3D1

