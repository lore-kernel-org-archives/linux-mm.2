Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604B2606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PcBdPivZ
Received: by kanga.kvack.org (Postfix)
	id 81D986B0258; Wed, 21 Oct 2026 16:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3EC6B025B; Wed, 21 Oct 2026 16:16:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731C06B025C; Wed, 21 Oct 2026 16:16:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9976B0258
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:16:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF8C9805BD
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:16:14 +0000 (UTC)
X-FDA: 85347740268.09.57E92F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 33F7840009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:16:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PcBdPivZ;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792613773;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avp9cqTtWpYaZT22vY285NGVGfC3NkBdRxMRGQ2R0g8=;
	b=YO4q+e/mUJ/Qk5b8Ok0T7lLjX7lC89rzaXjOjpEqEJ+0AenkRkTls6L2AXK8kPZtyz94T0
	5x+GTvYIAL34YjyiYZsdmuhBCEo0WFCtcZ9RMw6QBZx9BzXz0ZLa5q67A+bwvbbxDc2X5F
	yGP+VUeUA8Pm49PkqvGqxHhqYjuIog0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PcBdPivZ;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792613773;
	b=CqZHFZo5PwxZA4dLb0OSYtf87LuopAug2Hv8/2yb/qYFEer4x1CQ8imf+nY0SUw395wJVg
	gmnoX8L+LuCSThKM6FbkydnLdgLhQwU2Ar+kln2FL2uJntacQvoeu6H+JOS3nvFb4A1NX7
	De8m/rPYZn6x0nmRC7dNIIzFXiwN79o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A1D2860142;
	Wed, 21 Oct 2026 20:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5D81F000C1;
	Wed, 21 Oct 2026 20:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792613772;
	bh=avp9cqTtWpYaZT22vY285NGVGfC3NkBdRxMRGQ2R0g8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PcBdPivZTEymGLZSB54jbgg0KCMSP61BdKHXwK9IcsCh/9lGFIl2KnSGFE7LWSl3z
	 NqVzQC1779XJWXUwtXgU/SVX2wzxc/qZ5RJSpks5Wo2yrzsg54CIJm2r5GiNpSp/z5
	 GL845GygvpQu+Xfadh1ovEgaY/+WNThmmApbfobHVff2MskTuiOQufDM4+gqZ/eyNM
	 fip9xSL+lh6nwvRq1DBpBp7gyBe+gSim9yyEyh4iriHp7Xh6mhPRsPbAYGKUn8NWeA
	 ilpSZC2pSYIIe+gedZrr7f+/CYZ6dhaZznYuYQp3WjCNof8SkcYP7beyCTtvi543iD
	 ojzdoYpr+3wpQ==
Message-ID: <sashiko-outbox-180635@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC bpf-next 1/9] bpf: Add __srcptr kfunc argument suffix
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiri Olsa" <jolsa@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, linux-mm@kvack.org, "Andrew
 Morton" <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Shuah Khan" <shuah@kernel.org>, "John Fastabend" <john.fastabend@gmail.com>
In-Reply-To: <20261021195759.119421-2-jolsa@kernel.org>
References: <20261021195759.119421-1-jolsa@kernel.org>
 <20261021195759.119421-2-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 20:16:11 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 33F7840009
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: x4e7chucphhb9wniki7u1a4u476mmbou
X-HE-Tag: 1792613773-197350
X-HE-Meta: U2FsdGVkX19C+XRdlRCVJdC9nKJWwG7CzjWUnDnPPp7zyJFFuCd7WigXa70LYByCKSYU7WL0ef4s9DBd1/u+ccJw4xu3qN7h+q1zaljJT87KfMcqj/I8Tu/ofX51mTtZ53yNzB8pwd8HagfwcbQb+dW+7YsjzJU9RfbudTjxbsn3QWTBVXkZtrlE2fxVLo1jJZzjKNijsLH+MhWtonphGsTjUQm54U9PBC/8LfN3vOEhvHrSpVNjYE6DKxgoYUo5ErROP8J32N6xKPP79GkdI1XF+zRdkZcuCCF2GEHxp5omno6IsaoJ99Ssb/FqcK/HbQlNDe4DFbNW599yVtogejVQVypXnenamEFysDTX1cG10LM0B69KAFQE0Vjro+CpgTPjkOUgc320afr/WIpSVtDjpYRE+aYZiLEGwjcLP5Kg8HY4yaa5ZemXI/rIRxzVCZ45yiuz0N/mGQ0mODAAPzv7zs+C6jqb3QQCUnnd4bMVxQD/5U2oRHlW43pdmcjYeJZdvAzeC6FI5GbHGMG4eq3Nq8zNIdPT+ps2MLDzWT3HE82cLYernX92dRteCxzbpzulw62zaWzizpH9C2WhtW4k/bGaiy4UFfrLmBJRVFSWSHnUYAL0jBP5mp7j22wDe/n8svPFqHxVgVwHT3/jycoT3JX8ARQjeOonaBKmb5mpgRVNuGfnPYOKn24dlu2oYXHvDuxRApbn/CH0PrBMNAXyImf950kd7OBH3f1S5T6cCHnRsubcyg3EYSHNEsJsADD9ZG2Q1xVeioCstChr9SWrEyTbTi+FTHMGTqLhURCSRIhQGMr9FXdp1bGZPqA37JghzC+Z1cZ+b4XcEnaNMTYOzvl/NMkSKWjnaGLMbIvgyuw2/xtuHVP+d8O9jngkB/lSY5LzvdaulxBSwP8+PBtkHEncSUOrERCzrTW/vhooSRjbcBb85VjFJ0WYK1RYfzG0CYP4hn4tIcopztS
 C06viUIB
 9tVjkGzE9CIPzxneIJa8kZvja1KVhbsxQSTaw/f3E4qWi4wERIsh/m4qP7sjQHJmRvptS3Nzgvg+1T5r68sNdjMJpKLN265GhNClz02T+wmvkbT+DDvnQeG+yuTUSK/bOsoROqhp4eSHepkLvmYbw/Z/A9Y5dAhH12M9pkfbOlEbyYJeqVMC+BqfhY9EIyLMDFfoBZmg0AAWfjyhyOjOOhGDed8tSJaJ3eXViSu29lj+Mcr6zYpLT++t82uCPmyZ3jX49YSZhRnaHdCuAMRAVXp02yL6sRuOyMfEgiRvQIXYqAoAe/3u8v7EkSPQ5NS5956JKCtvjCy0ED9Y8IFTpwGUh3rKWu3LuKCrogDUA5mMzAMFWiXAEproC4bizbj0O0KRGd/OBLZAoUPz1vsNDWCEU24IQnXnqB9M4uZbjwsw/5edFEo+hjVC9rlbGfTWO0LPBQH9kpmclvyghZvTiuDrNqS9tckz3GOHUQxUstJGIbiDu37yw6Nm6JZoSHynTxfsW21R+A0Dm7+gd34O47AEkZpwr+WKwyGLoHjbyGl9QRARLv0DK9g9K+lkGyFPntYrCU9rvtLgqHEY10xN3/GJFQBT607c+7LTgmWqKojt+zRk4CAdNhCT1dYFPRHt1kn+d9eaT8As+m7CdNyaY7MzQMnzBEX+xKC1Jq9eXmR94k+k5wrpNOVcbRjpXDLt6JaL2xVkTMgXLNEGTbsUXTfr1Tg==
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
- [Medium] bpf: __srcptr ignored for scalar-struct pointers in resolve_func=
_arg_type()
- [Low] bpf: docs: short section underline for __srcptr in kfuncs.rst
--

commit 5dcfefa11540873e12bd9cbd04017e587c3a3f23
Author: Jiri Olsa <jolsa@kernel.org>

bpf: Add __srcptr kfunc argument suffix

This patch adds the __srcptr suffix annotation for BPF kfunc pointer
arguments so that the verifier checks them with MEM_RDONLY instead of
MEM_WRITE. It also documents the new annotation in
Documentation/bpf/kfuncs.rst.

> diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
> index 73578a4c3b1fb..6466b76fd721e 100644
> --- a/Documentation/bpf/kfuncs.rst
> +++ b/Documentation/bpf/kfuncs.rst
> @@ -351,6 +351,29 @@ In this case, a program attached to the ``inode_init=
_security`` LSM hook
>  can pass the hook's own ``xattr_count`` argument through to the kfunc,
>  which claims xattr slots by writing through it.
> =20
> +2.3.10 __srcptr Annotation
> +-------------------------

[Severity: Low]
The section underline in Documentation/bpf/kfuncs.rst is 25 dashes while the
heading is 26 characters long, which causes Sphinx to emit a "Title underli=
ne
too short" warning when building the documentation. Should one more dash be
added here?

[ ... ]

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 5601d20562186..7dd7b172a2971 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c

[ ... ]

> @@ -14137,7 +14151,7 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, =
struct bpf_call_arg_meta *meta,
>  				reg_arg_name(env, argno), btf_type_str(ref_t), ref_tname);
>  			return -EINVAL;
>  		}
> -		arg_type =3D ARG_PTR_TO_MEM | MEM_WRITE;
> +		arg_type =3D ARG_PTR_TO_MEM | mem_prot(meta->btf, &args[arg]);
>  	} else if (btf_type_is_struct(ref_t))
>  		/* A pointer to a struct without a size argument is classified as ARG_=
PTR_TO_BTF_ID */
>  		arg_type =3D ARG_PTR_TO_BTF_ID;
> @@ -14162,7 +14176,7 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, =
struct bpf_call_arg_meta *meta,
>  			return -EINVAL;
>  		}
>  		proto->arg_size[arg] =3D type_size;
> -		arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE;
> +		arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE | mem_prot(meta->btf, &ar=
gs[arg]);
>  	}

[Severity: Medium]
Should resolve_func_arg_type() in kernel/bpf/verifier.c also use
mem_prot(meta->btf, &args[arg]) instead of hardcoding MEM_WRITE?

In get_kfunc_arg_type(), a pointer to a struct or union without a following
__sz or __szk argument matches btf_type_is_struct(ref_t) and is classified =
as
ARG_PTR_TO_BTF_ID, bypassing the final else branch above.

Later, when a BPF program passes a non-BTF-ID memory pointer (such as
read-only map values from .rodata, PTR_TO_MEM | MEM_RDONLY, map keys, or
stack memory) to a kfunc parameter pointing to a fixed-size struct or union
composed of scalars, check_func_arg() -> resolve_func_arg_type() converts t=
he
argument type to fixed-size memory, but still unconditionally sets MEM_WRIT=
E:

kernel/bpf/verifier.c:resolve_func_arg_type() {
	...
	if (!btf_type_is_scalar_struct(env, btf, ref_t))
		return 0;

	resolve_ret =3D btf_resolve_size(btf, ref_t, arg_size);
	if (IS_ERR(resolve_ret)) {
		...
	}
	*arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE |
		    (*arg_type & (PTR_MAYBE_NULL | MEM_UNINIT));

	return 0;
}

Because MEM_WRITE remains set for scalar-struct pointers annotated with
__srcptr, won't the verifier still reject read-only memory arguments and
clobber spilled stack slots?

> =20
>  	if (is_kfunc_arg_uninit(meta->btf, &args[arg]))

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021195759.1194=
21-1-jolsa@kernel.org?part=3D1

