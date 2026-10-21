Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74140606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LGcJTwNS
Received: by kanga.kvack.org (Postfix)
	id 8FB9E6B079A; Wed, 21 Oct 2026 16:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4476B079D; Wed, 21 Oct 2026 16:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A286B079A; Wed, 21 Oct 2026 16:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4606B6B079A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:30:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1358A0693
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:30:26 +0000 (UTC)
X-FDA: 85347776052.04.13EA225
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 29F484000D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:30:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LGcJTwNS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792614625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBK4LZ76/LMHs38+RcqRgWOhkYyz4na1Z6dIKP/tOqk=;
	b=iOOHN0+1JqknHyscx8blV6UgbSOhZ8FvZY8E5WgYxvxG/y+bcuq8RFN0I450J/4em9J3sR
	OApGrHVqiVFBKtXQYJaqdF7+XZlKB2VeHYEl2ph2buLreseIieMr2ZHjOuaZ0m3zPlkV9o
	hfHipxMnT6ytob1CDaiVUTBqXn9LpBQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LGcJTwNS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792614625;
	b=t4l+BRbLozSSTymXO7p6l+Dx/njXNLAReCo+9Q+aBc9yn5usDpkkVKklWUkIgAHavbY6X6
	+pwePTczkhkmc1nqL5h7y0u9LdIgAYYwlhyc+I3wH/x8DVr92hd7ZnCjf3HO/2WdVIovmN
	1TrUVccCqihDXTUXBa5Zgxq3WH9OkuU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9E3D601F6;
	Wed, 21 Oct 2026 20:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BE01F000C2;
	Wed, 21 Oct 2026 20:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792614624;
	bh=KBK4LZ76/LMHs38+RcqRgWOhkYyz4na1Z6dIKP/tOqk=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=LGcJTwNS+wrlBBLVvQ9ovngE23Noc9VOmWvk2FRS75Y/m/cgQwVkUTonRoFDY/Frv
	 WLGOMZ04f4qVLz7PtsOIxRPvCKIlgUMIi/7JVI9zP9SDlYdI2+ZlT5rje/up+3NVHe
	 q+Q8DK4stx0Zuum4v4z2Jdf76/uRakBFa3nwABCIzPQoGRfndK1P1ObqSfPI26ryJt
	 KXBcJe91FoGxwtKVgEN3R6jj7JkhTMa29qbJv/83ZBzdgKhDvYfpzUJFGBQan4wmES
	 MAQpQVk/1Rd17mCrUwpUqfXmUgsYdU0nlaFIaXpIifjnPcAtJJf7s9OmsW2QsJPYrr
	 SizUAhXRnvmiQ==
Content-Type: multipart/mixed; boundary="===============0931245153222694076=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <409d58c6952c879c08413c5f5b00b325789263b4704147098dc43d9a4fd93b33@mail.kernel.org>
In-Reply-To: <20261021195759.119421-3-jolsa@kernel.org>
References: <20261021195759.119421-3-jolsa@kernel.org>
Subject: Re: [RFC bpf-next 2/9] bpf: Add uprobe faultable user copy kfunc
From: bot+bpf-ci@kernel.org
To: jolsa@kernel.org,ast@kernel.org,daniel@iogearbox.net
Cc: bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,linux-mm@kvack.org,akpm@linux-foundation.org,liam@infradead.org,ljs@kernel.org,linux-kselftest@vger.kernel.org,shuah@kernel.org,john.fastabend@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 21 Oct 2026 20:30:23 +0000 (UTC)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 29F484000D
X-Stat-Signature: rrzk6poaiqqtjrxirucgqhqosigarxnn
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792614625-713129
X-HE-Meta: U2FsdGVkX1+n+l8d5fKLS+Q7FuxOva7+2L9+Vfs52ir5ArROyvmEXU0E3iThcNqAcoBFKV6xwGKdm9ed6lFzjgfvfXeRkfjmk2hTJBggHhiW0x8IGamzls1U/hJj6S1/Rs8L+sYegDXO5Q4ZxhVw0aYYDSoUFcNc7cUy5cTHRQHQ17Xr0Euzh/FvZ6eLlLPCtAxdx/ehu/J/2kcYzZ6OZcFBpHSQPT1nFPSW6sSrv7P1HmCoJG3GBiPnAtp9vyJgCJ/4q9BfCuo6WWdHVfY9v3q4QWJvxPBmPKoNjbJfv/CnfP9wcIoDEM0HaxETiIWCQ2BpaBDlTc/SRJ6TcMGly8Zjw6BWCSNLphinpwItwpLteOH1lIehUJC8ugh4BTskpSEcXwDUAgXoiFJEYftQTLwDtjiEiyuG+xYRDthbc6weVCuHUEcCowXtJeK+5knhFAJPJMM6ez03z/5ptLMu88Pdkq4TrLErEzyBgoSn222d1mPrtDgtUvJr1YCXLyTJV2BTiGse9FAI7f3Kkp7oCW5GJ/fAmpe3ohj84d6YdLx4/BukGJ55OMtxbJ3zTpG+3BrMc6xFDJbtvWLse+TGJkzNRrpEy/+ONVBmyXfku8cNYBwb+q8FDA58bfM7ffeLE3KTrm9RPG5PetiM9A1ZMFpvx6boBh0mJ23TdLOQqF5CIvYhW3FIx1afYzqXFsedMsE+oZnrRUoEymJS5vho3r+rcvfQWbECgqftVbBhc/JPZTG/YoHw6dLhVCkCP8w61HqcBUqGXGD5irJ1oLbOlhBTKc84cskRfg8GmedaLVbqgTXE6tdX+VP1BB2o2tipiDkR5lIciTYEW3qby7rpyuMolP5GC5jJR5GfV6BcXPA2bmt5k/ABSz7cqnw/ey616sirMkdolpECVC9/JKigY57uue8Gzt1yoVi1nKSXnOB6pPtLzwSG3Be5qou9Bz1t90AvSku+s8uWnY3GT1l
 rYLS4tPQ
 zZcxNN4s4XJrSqjoy7K3lJHXI+iBadlwTUXXTc9XFdpVEHCeLLtCYoGrA5sfhW3C9edyHjVcttiiS9E7rbikWvGDHsg53u5zB9JR0/6DL1VgcgHaSpU08jqcJk5JCvtMoaA2yXtWp04t4PP/h7LBdfxt2gbtX6qI0kNRZN4JWE/y6D2F6edfgYDPE2te9K8ccJuN2ElQRSGiIXE+lTMRPyHaYP1x6NJZdSDovda3U8tvXQkDGkH0IcBnIMNZpr6zd/si7gd8XlF2RIbjuQbGnEUUfJI/3W6jNxZSGdOWHq9BlVfHUN6z4upwuLtSG1wBTA3uZmwYmkrOPmmcZLMzH+mbbAflIP3Gg497emBmLbzhX5He8hYW51p1wrORV9Usf0xpXS4dJgqacuN9b2zmvTaFm6/SXqkEekWnl4/Jywno7yL9AsQZXfJxAT2Vu3Br+2rZV/JLMR0ez3QC2oq8x2Gbu5zm3y2X7a5iVQ97a4QmjoVlTbl3U+Wek8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============0931245153222694076==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf: Add uprobe faultable user copy kfunc

TL;DR:
- New write-to-user kfunc may let CAP_BPF+CAP_PERFMON loaders write user
  memory, bypassing the helper's CAP_SYS_ADMIN requirement
- Unused enum (nit)

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c

[ ... ]

> @@ -5139,6 +5170,31 @@ static const struct btf_kfunc_id_set generic_kfunc_set = {
>  	.set   = &generic_btf_ids,
>  };
>
> +BTF_KFUNCS_START(user_mem_btf_ids)
> +BTF_ID_FLAGS(func, bpf_probe_write_user_faultable, KF_SLEEPABLE | KF_PERFMON)
> +BTF_KFUNCS_END(user_mem_btf_ids)

The new kfunc does the same job as bpf_probe_write_user(), but it is gated
only by KF_PERFMON.  The verifier checks that flag as env->allow_ptr_leaks,
which is bpf_token_capable(token, CAP_PERFMON), and loading a
BPF_PROG_TYPE_KPROBE program already requires CAP_PERFMON (see
is_perfmon_prog_type() in syscall.c).  For this program type KF_PERFMON
doesn't seem to add any restriction.

The existing helper is gated on CAP_SYS_ADMIN in bpf_tracing_func_proto():

    if (!bpf_token_capable(prog->aux->token, CAP_SYS_ADMIN))
        return NULL;
    switch (func_id) {
    case BPF_FUNC_probe_write_user:
        return security_locked_down(LOCKDOWN_BPF_WRITE_USER) < 0 ?
               NULL : &bpf_probe_write_user_proto;

and include/uapi/linux/capability.h documents "CAP_SYS_ADMIN is required to
use bpf_probe_write_user."

With this patch, can a loader holding only CAP_BPF and CAP_PERFMON write to
user memory through the kfunc even though the helper refuses it?

The commit message carries over the LOCKDOWN_BPF_WRITE_USER restriction from
the helper but says nothing about the capability requirement.  Should
user_mem_kfunc_filter() also require
bpf_token_capable(prog->aux->token, CAP_SYS_ADMIN) for this kfunc?  If
CAP_PERFMON is meant to be enough, could the changelog and capability.h
explain why?

> +
> +enum user_mem_kfunc_id {
> +	KF_bpf_probe_write_user_faultable,
> +};
> +

This isn't a bug, but enum user_mem_kfunc_id and its enumerator
KF_bpf_probe_write_user_faultable don't seem to be referenced anywhere, in
this commit or later in the series.  user_mem_kfunc_filter() compares against
bpf_probe_write_user_faultable_btf_id[0] from the BTF_ID_LIST_SINGLE below
instead.

The similar pattern in verifier.c (enum special_kfunc_type) works because it
indexes a BTF_ID_LIST, and there is no such list here.  Can the enum be
dropped?

> +BTF_ID_LIST_SINGLE(bpf_probe_write_user_faultable_btf_id, func,
> +		   bpf_probe_write_user_faultable)
> +
> +static int user_mem_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
> +{
> +	if (kfunc_id == bpf_probe_write_user_faultable_btf_id[0])
> +		return security_locked_down(LOCKDOWN_BPF_WRITE_USER);
> +
> +	return 0;
> +}

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/39668036298
--===============0931245153222694076==--

