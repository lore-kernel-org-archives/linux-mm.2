Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E3FC606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RPTXPSFP
Received: by kanga.kvack.org (Postfix)
	id 906CB6B05B1; Thu,  5 Nov 2026 05:59:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7916B05B2; Thu,  5 Nov 2026 05:59:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CD346B05B3; Thu,  5 Nov 2026 05:59:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62ED36B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:59:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6ABC40920
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:59:56 +0000 (UTC)
X-FDA: 85400770392.10.305D19D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C529100004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:59:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RPTXPSFP;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793876395;
	b=dtNDQ51PojNqiB5AoPZHGlTqNnDgmTjRw3gyT7XMc3yO/H8aROu8mpobhOCf+FdZEXGHF+
	aTx5IubbBFRxfQEDxa3uMTe/6Uwyi6sqoKwxCcg0CHzCT9EbnftRfhUlTBWBmyqomp98UE
	ea3KrlBQFyk/l8Oed2O4eaf9yzsfZZk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RPTXPSFP;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793876395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5+p9iJMZToojqhmNYvXQKxqNfYJdePkWIrp9noGGxI=;
	b=hcDPn6vJKOgDxgx8qcvfLk1zt17H0xYnJtzbf/2PfhNFAafW+M6ZfVAMlaTD1dC/8nMpWT
	ayalEcpahDBnvpzyGrcL8Ap/WhrpaYlR0Bz/P9flyr0D4fCImt3pxWC78HsYKmkIX7reYw
	uhxJT7SHss8WBErUUQo5FlZrKP5yuzc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E26F360DA0;
	Thu,  5 Nov 2026 10:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548441F00A21;
	Thu,  5 Nov 2026 10:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793876394;
	bh=t5+p9iJMZToojqhmNYvXQKxqNfYJdePkWIrp9noGGxI=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=RPTXPSFP3n3eMASPTaI4hLhz92MWMEtMXudCs/gnnjTAmDaB8e3BMo1b2HL2knJrf
	 Dq8X9TPDzKdfMkmwt1UZ71wMAJbL5Vqz9gvGNyJma9a+GFeGFh0klsknVpjhYVjgxf
	 STDn0fINtxWjjDKacW7I7d6+MvHMfzo5DQRvJJFSgQYp80+pPBcBFtceoDtxRG8AO6
	 dfpfbKGs7/CO+a1Eqib1SIiUQhUFlmrhYX/gG1PDAzG3TvBqtvtUoC7gbgMOxA62sB
	 vivOkxBnWiJdeN4nhvk0T9qrIsRYgVuToH3MIF30qYPuZTGPtMnGN+5HRLm524hbp6
	 /hFuaC0v8zhig==
Content-Type: multipart/mixed; boundary="===============5606202118295207002=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <feb942065da5a4dce372fc631d390e52b381ef87f223f83d51cd350d92822066@mail.kernel.org>
In-Reply-To: <20261105102343.311331-2-jolsa@kernel.org>
References: <20261105102343.311331-2-jolsa@kernel.org>
Subject: Re: [PATCHv3 bpf-next 1/8] bpf: Honor const on generic kfunc memory arguments
From: bot+bpf-ci@kernel.org
To: jolsa@kernel.org,ast@kernel.org,daniel@iogearbox.net
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,ljs@kernel.org,john.fastabend@gmail.com,nierro92@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu,  5 Nov 2026 10:59:54 +0000 (UTC)
X-Stat-Signature: z3ukzkbr6xza7er4et13x4hiesiky7cd
X-Rspamd-Queue-Id: 5C529100004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793876395-51196
X-HE-Meta: U2FsdGVkX180DzCGNA0stq5+qLE4h/6JV9kv3agPlAcfGH8fK40bFw7wEksUE6ExUqg4XUhO3o0/JjkbFRcQuOA2lplcJS5R8UiU+YHdac9bwYxKea16kxzGmhCRjvZEZYP9EqqusT0ArP0jnLcycN2dBycAEhUgHh4vZBmPxzmWDHESDSvsdL3iMInJlcxLuVppDRLO0eRJ7eqbam2Vub6BkGVwgus1jHD1KVMMnjSVwhNgUxBJab/7XgExDrd/M+dDO+d8r8E/uDdsYEwEKl2lZ8lTSDK19hmLLGxrsWiGYgdE6QwPLKnLhsdnDVR8w2FPM9nbg8d8xwf9ie8IKxap4/sEQ2JJGTG8DbNImTJ3bTutQW2JdKfb5YyzFaHPZb3Jv2CYVDx1XDvVRHD5MBCf+SQ42vLOwR5OXM30ZCjJhrH29y3g6HfHfgV6EAfiYEVO/BgDcdn2B7Q9bc0QN5w/IimxrzPmLHmPgoVB0BCBMQDwL3e15uTNHZJLc9y0K44JBklQDuH7DeHDF/LvHEwDe11J5PdGHaPSNll9iXrdu/HqD0PO9dnQuwGbJ4jIwUzDT4souoOvw5u68RIRXhEPoZpmgzVqqYUIRrjBevpv4H83Z+DikTCVUvinB/CU//saF2bI050VxOsRm+5Q1Hkp0cwKxivxzgN3nT48wlR6V46sf/WsQt0gF/faDrHDcvb88o1KOmtRW4DV2MS+bbv2O4gQfZ/nqwlIuzVlvREAy23w1yl6A2T4ydjYvrT/gL6QtVBZs8rYyyGn19gaVfj2fxSxbzgRBsyB6TdVd0L7DW8mlfuNZALFDvf2Bxa/SO1UGfLZGZTrBoYjn380OVemtfyBpkPsX+58xOJclH/gjmEmaPqKoWUOA9jdgphWSsCLzQiB4yAlHf1HRYE984PERidQ8LrG4F5VQ5JH+brN8jT3BimHNW1FAb3RETNySlR8+uoy8w3L7kvP4on
 oVSA6td8
 w2LDeqAu+dMJBmuzBQLpgxAwmLmJVIZuUR7rCxh85Nze7Fr3eXgtHa0k8LD7A5YD3fLbRiJsXuSM0yrSL+0kOVMR0apr6bg7lNQ1yvONJOW9i/W/PcyuTzaLx55YYv84lUe1MgkP9lr0oZmJWfzV3CpRuL/HLzIC6JoI+tscQzNInyzJoK3m8Dh6prfB4pbrZFehSy0kuh1OCm7nPxtub6BpHfpBB0zt3fWf++ByuEDW3r5p67oMGHvkHb3gI1o8rjvmym1Ba1sprKD0791l3I1c5wICBs69X62iIkXOcpcXZi5x+P44H6aZ7hE2hs5xSL7GDdEGap1vNB5x4XltIAI3h2ATPDR+QG7x13GcZ5SeE9r/5CUOhYZJ8ekkVkNmjD9tCMe5aQMwkrrclpbUj09jubyU+otP+jWMr3uMpeKK4xVzLRBELSdzGHcHkN/p6VR7XpTYY8y6X0oiyJeZURpTLPUgyp2XEwR9LxrG79XlqaIOyT0WvSY71mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============5606202118295207002==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf: Honor const on generic kfunc memory arguments

TL;DR: Comment and kfuncs.rst claim the compiler enforces const, but casts
drop it; a kfunc writing through a const memory arg could corrupt verifier
state. No in-tree case found; docs should state the contract.

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c

[ ... ]

> @@ -13448,6 +13448,22 @@ static bool is_kfunc_arg_const_mem_size(const struct btf *btf,
>  	return btf_param_match_suffix(btf, arg, "__szk");
>  }
>  
> +/* A kfunc only reads through 'const T *arg'. The compiler enforces it. */
> +static enum bpf_type_flag kfunc_arg_mem_flag(const struct btf *btf,
> +					     const struct btf_param *arg)
> +{
> +	const struct btf_type *t = btf_type_skip_modifiers(btf, arg->type, NULL);
> +	u32 id, ref_id;
> +
> +	btf_type_skip_modifiers(btf, t->type, &ref_id);
> +	for (id = t->type; id != ref_id; id = t->type) {
> +		t = btf_type_by_id(btf, id);
> +		if (btf_kind(t) == BTF_KIND_CONST)
> +			return MEM_RDONLY;
> +	}
> +	return MEM_WRITE;
> +}

This isn't a bug, but is the comment "The compiler enforces it" accurate?
In C a cast silently drops const, and one registered kfunc already does
this:

    __bpf_kfunc int bpf_ct_set_status(const struct nf_conn___init *nfct,
                                      u32 status)
    {
            return nf_ct_change_status_common((struct nf_conn *)nfct, status);
    }

That argument is ARG_PTR_TO_BTF_ID today, so this patch does not reach it.

With MEM_RDONLY returned from kfunc_arg_mem_flag(), func_arg_access_type()
yields BPF_READ only, so the BPF_WRITE handling is skipped:

- check_stack_range_initialized() does not clobber the stack, so spilled
  pointers and known constants survive the call.
- check_map_access_type() accepts BPF_F_RDONLY_PROG map values, whose
  contents the verifier constant-folds.
- check_reg_type() accepts PTR_TO_MEM|MEM_RDONLY and PTR_TO_BUF|MEM_RDONLY.
- may_access_direct_pkt_data() no longer sets seen_direct_write for packet
  pointers.

A kfunc taking a pointer to const scalar, void or scalar-only struct memory
that writes through it after a cast would corrupt state the verifier
believes is intact.  I did not find an in-tree kfunc that does this, so it
is not a live problem.

Could the comment, and the new kfuncs.rst paragraph that only says the
verifier checks such memory for read access, state the actual contract,
for example that a kfunc must not write through a const memory argument
because the verifier relies on it?

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/42012074982
--===============5606202118295207002==--

