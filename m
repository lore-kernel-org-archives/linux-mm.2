Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D0BE606D81F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DifijZGL
Received: by kanga.kvack.org (Postfix)
	id 5B1046B05B3; Wed,  4 Nov 2026 16:12:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588BC6B05B4; Wed,  4 Nov 2026 16:12:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49D0D6B05B5; Wed,  4 Nov 2026 16:12:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 115BB6B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:12:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DD55A0879
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:12:06 +0000 (UTC)
X-FDA: 85398684252.13.25235E9
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9DB0EA0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:12:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DifijZGL;
	spf=pass (imf25.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793826724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d290Y88I8EA7fRNVJZziFi6nFU4gyKqFXCYOMey3i64=;
	b=4hYGlthIt4M9+v7uPSz9FqnicfNPlf6DgUE+7auWyiVHs31xj3/9yfDXZlQbOTwRGwW5tw
	kU/eTXpONCaG+uKM5npYM+n6qXcFTDl1gWGdhNCMDG9G5sWMtqhn54fR8gpOu5cog0da5u
	7kSkequoskS0VE2+EqXQZqMV2gBGcpc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793826724;
	b=fx6laSVFUNSR2XgRNaXAYIDhRnlI82wuhIswho1SY+JaoZTGW+ytj5ASlhp/QS/KUHtfLc
	zmWofiL1oC+2qG2npUGf3XWKSms6ebOqzyWAWd7L0PQvmywIcSgkeMTtwteYVLsAIMeoz9
	OEAn5ThctpNDzygx6bjpvNnl0eSyItw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DifijZGL;
	spf=pass (imf25.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48c45111bebso577596f8f.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 13:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793826723; x=1794431523; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d290Y88I8EA7fRNVJZziFi6nFU4gyKqFXCYOMey3i64=;
        b=DifijZGLYEy/8/t6vWpQdujXL4mSbW3v97EJHtVLRRkr70sMdC/rW+9kg2CuZZ2fNF
         nayhXNIYeyEX5hBxQKZmW0pYU7bpL15TZS/b2dTgfzg4utQXcBBrP7+ygt4CZfhSdis4
         pHzB2Y7jz2Um+FMlnWxYVAwhPgEQHTcfQBYMdiSG2Krk9NRm+2yAO99vs9YoksxJneR5
         O7FFfUYEPK+Q12ap/G5ILF1iiUvNufNvv89nrboyhZ5dj9m2Q6+NKe8l2C4lPPHjIdQF
         FvHTIn9UOK10d+Xwc1194kxw46EaUyrMCNZXgr4cZj/ouzYOugl5YbOqxHUK+buzuAmX
         40/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793826723; x=1794431523;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=d290Y88I8EA7fRNVJZziFi6nFU4gyKqFXCYOMey3i64=;
        b=gGQaVJG+6bl4iQ9JS8mjNrRTE29XwPYuKsZ4sItINYoB2uOjZusVWgFwouqgeB57WY
         orJT+Naqt0aPNexb2KLepGkDMDi1MeHW49JHGZfwENhPK4bQpTP5KshnVdwEOY3PI+B0
         KSX02BLg2IKXE3KzEJzgZk6H5MeP02fEcUsO0iifA3zZm2W+kEBqOcbPYwzPmppBCbXV
         OOuzkiFpZtE+TJg/hIP1kg0OEZxUHU+5bxUDOFQVyZ3FtceEx/4kx7GZ/ruIFEgZjaE3
         7Dnfm4v0XOgCGO0oCON9f+MSKwrOryjWPEWSXQl5vhNlrjBhXGcA82nP22cTy/g/2e6l
         LAWQ==
X-Forwarded-Encrypted: i=1; AKwUvBzF+qpCpqJ2iFAEsp3dq0p0hwjq16NpFV0ueZOsdB9ekCcv6j9mRCSLG0MWyJx+zpe7y6Ewqq04SQ==@kvack.org
X-Gm-Message-State: APuU4Z8krT9seG+fNG/m/7smDqHzKTKGVzUF98QLn+OaTDWqv+KRenuh
	ath/pL2e33CYFz35DlWYpYnW7QALxTHDm6Mreo0m++fGWGkT80cBvw+g
X-Gm-Gg: AYBFou1iRZ+YyUfN7OhDf74+2v6ISQqLoBlkfeMXeEEN3MCmrQTx6zJxLCZN9GQQKfI
	FAfjsrpnEayIW5x0rIp1e20Xn+nbvJf5ASGCiA8HbFLk6sk6SDQP8AePHpk8uqAWngnHh4nHQAj
	00JzrRCb707UuDZRPfeePo/MZ+rGwB7naCIWPcGVhdY1rQBn3aEKpchKKiOCMdxZeHBKf9Tmp+4
	REVCcfYqDhNmYaIDbYPtX8bu/6KOvm2nUUWUVtFjKMJBFOr36WUyzQyf3LjNMD6phshx00yLMJE
	y2v4yLTLN3qsJkPbpEMYfAbdNIb+arP8kkqqxMBLEMrO4Jga+uG1LDxW5kK+/AMP2WtYFY1w4eV
	JBmQDDn2BJpGQiGJK5BPoo00Pkmeyh36JfaVDr61RlHYcliHSMDDLCmx8WxjPCt8qftG3N+THcu
	QJ49lUKp8OPBDeVn7Cy39jhyTVh70m4TRan5Q6u9hzK/gN4FLKiXh/sTBDQVgdxueIiVQ4tgbfd
	hbrvBzGhcjWLPoeH4Sba+6KWfwlSbIuAICBe/0CZsbr9VMfTaOpXrgLUcWS0nVgzj3MClvMZgPq
	OmjKYMFpqVFOnZk=
X-Received: by 2002:a5d:5f07:0:b0:48c:7caa:12cd with SMTP id ffacd0b85a97d-48e6e4faddbmr37238970f8f.22.1793826723128;
        Wed, 04 Nov 2026 13:12:03 -0800 (PST)
Received: from krava ([176.74.159.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fea180e7csm5907191f8f.5.2026.11.04.13.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 13:12:02 -0800 (PST)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Wed, 4 Nov 2026 22:12:00 +0100
To: sashiko-reviews@lists.linux.dev
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: Re: [PATCHv2 bpf-next 4/8] selftests/bpf: Test const kfunc memory
 arguments
Message-ID: <auufoF_H3gau-sYx@krava>
References: <20261103075916.100050-1-jolsa@kernel.org>
 <20261103075916.100050-5-jolsa@kernel.org>
 <sashiko-outbox-194803@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-194803@kernel.org>
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 63a6hekkncjkdnc9aiuymchfmz8skog9
X-Rspamd-Queue-Id: 9DB0EA0006
X-Rspam-User: 
X-HE-Tag: 1793826724-835838
X-HE-Meta: U2FsdGVkX18UIj79w+d4v0knpqTOcQICY0fs5a0CqAq0pB49+0Quy0AFndCKjQyMCclYIpfG+1VtPZajgeZEdWb7p/RRkoyOAQR+eWKdw+lxdb6tOO1+4OkQOHYUrNSFrwmwx7zfyg5DHJo1CnUOz+08PSyqT4NUHlA40RwDG0RdR5y80tM3BUpbe9RQ1MUzmpUgfc7q8iAcifWlw3h/PGWoWpJuVZmpq8ET+mXbeUgFItR38b6yE9vCJLU2s5scSDwk4HBpJmVU1KBzuF7PB01pP3XYTeEhmJCqqcrGzclZK38RQMNDyzBj81+CSJ9cwPK5sd3InSpSdxDCXGKXcyNZhzQnbAWAdpPWzaQgy0uOSyPGDPw4dnQhsyO/nhak+FsBMA63kfNq3l5qM+bCeYrafKKlktt99JkvK9h5pd8I1MXlNeEsAskiSOBD2ENsTq/yvHKYuGSIdcIEiBl8q/dkBOwjReuWF2m376IcNylAZBVgPCec2YV8+0Yc6k664qbZaJGjSOvx9Q4fmLimW0QiiGNasebt62VOsZbrAmOFCJYR4Q4p1I1uVEchKkNhMqeZ6fM3BW5s9mj2QCG2Sj22ykSvVvrJED1fOMO8bYeYhuUl7o16IITBtKQP9JX44m5k50+gQHgMaoHQZ4Ua5uwWlSZu08N2jBf3Zsbf67M5YlELI7+WaZVpQIhpWJplt7nftuZ59IS0fkNABzybkanMawm1YEGenpQgDDbJqONpgzEkoXy2tathGVvwFEeA9qBCxudLaj+91/a3u61Cnyno08i/pICxBs+exhewGjuRrWd6wZa6qCVbR856fo2kAPGjMzF9JpKZPbjaOoFrQeW9EFNwp6mX9A8kZw3MoNMt3ewRSI7pr3tyMxeKakEa/RjMFbQX5vSgEoVEpFBn5oEyZ1Ji3JfD7Ofo5GLbhImRwrZngot35xYQeO9Y5zhyKNhBIbXzdlIpJnSI/wM
 m0JZIU8U
 p3WrKKzaCoJn9zDyR6XoRAWJgFYEb4l7OSlBQn1Se401dA2muyEewr/fpnqw4zKqR+66/uLcUnQABHZFkajxHhwAvFDSqivYgvQo3RduTwOmXW7B9mutUkjFi8U4CTcXl3fPqBynqwQG2d8VHow4icS8/M7h/HbhPVeQLneLxCNcBK2laP/ID2AUmQlTOE8aocUWA/SB5sx2tctoVurZZHFSQuwIlJuh6h8ht58xdsaA9EL+0DD313NGc/Klw7cK1mlw76jc6NucoqhXXvXkBYkTVLYtMeH+bE+9pGaNtRYai5zl7FLSbfRtNqPqLLyrNuvjM2kcEOK0j67tKNzf6oDmdhygHXvh4DUpIdUtMInI/u6+anIIw8TG6vhq8ZNARHYWHOO4Wx+GyN1cx5/ylGnMXroMlUFQXprNGTZdKQ3qAUx2uSnMDsnawJ6fZ+snrxIccZ/xUe36q03VPAnlO9HNXGB/QBJl5+jE+8AxM717Y0BMjAbLYeIS0K/CWejzH1PCwjq/PfaWV+df4QPn88WhO6E41pBKxEDpCZTCJ9wttxA4JsQX5eenF9SaIxQI/VFALMqjbhyJOKgGpKyPAnoGOUzPw9Wl2fLWbE3HfQ4Taq+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 08:10:24AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] selftests/bpf: kfunc_call_test_const_mem() fails verifier load with MEM_WRITE
> --
> 
> commit d0fe747011b126dd39ad19108026e34fdd9f18ce
> Author: Jiri Olsa <jolsa@kernel.org>
> 
> selftests/bpf: Test const kfunc memory arguments
> 
> This commit adds BPF selftests and bpf_testmod kfuncs to test passing
> read-only global data, stack data, and const scalar structs to const-qualified
> kfunc memory arguments, as well as rejecting read-only data for writable
> memory arguments.
> 
> > diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> > index 8e6560c31e781..4f4a6713aa6e5 100644
> > --- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> > +++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> > @@ -5,6 +5,9 @@
> >  #include "bpf_misc.h"
> >  #include "../test_kmods/bpf_testmod_kfunc.h"
> >  
> > +static const char kfunc_const_data[] = "read-only source";
> > +static const struct prog_test_pass1 kfunc_const_struct = { .x0 = 1 };
> > +
> >  static struct bpf_spin_lock kfunc_call_lock SEC(".data.A");
> >  
> >  SEC("tc")
> > @@ -208,6 +211,17 @@ int kfunc_call_test_pass(struct __sk_buff *skb)
> >  	return 0;
> >  }
> >  
> > +SEC("tc")
> > +int kfunc_call_test_const_mem(struct __sk_buff *skb)
> > +{
> > +	char stack_data[] = "read-write";
> > +
> > +	bpf_kfunc_call_test_const_mem(kfunc_const_data, sizeof(kfunc_const_data));
> > +	bpf_kfunc_call_test_const_mem(stack_data, sizeof(stack_data));
> > +	bpf_kfunc_call_test_const_struct(&kfunc_const_struct);
> > +	return 0;
> > +}
> 
> [Severity: Medium]
> Does kfunc_call_test_const_mem() pass the verifier without a corresponding
> verifier change to preserve const qualifiers on kfunc memory arguments?
> 
> In kernel/bpf/verifier.c, get_kfunc_arg_type() strips all type modifiers
> including BTF_KIND_CONST from the pointed-to type via
> btf_type_skip_modifiers(), advances ref_id_ptr past them, and unconditionally
> sets MEM_WRITE on sized memory arguments:
> 

the verifier change gets the access flag separately from the original 
BTF parameter in args[arg]

> kernel/bpf/verifier.c:get_kfunc_arg_type() {
> 	...
> 	ref_id_ptr = &t->type;
> 	ref_t = btf_type_skip_modifiers(meta->btf, *ref_id_ptr, &ref_id);
> 	while (*ref_id_ptr != ref_id)
> 		ref_id_ptr = &btf_type_by_id(meta->btf, *ref_id_ptr)->type;
> 	...
> 	} else if (arg + 1 < nargs &&
> 		 (is_kfunc_arg_mem_size(meta->btf, &args[arg + 1]) ||
> 		  is_kfunc_arg_const_mem_size(meta->btf, &args[arg + 1]))) {
> 		...
> 		arg_type = ARG_PTR_TO_MEM | MEM_WRITE;
> 	}
> 	...
> 	if (base_type(arg_type) == ARG_PTR_TO_BTF_ID) {
> 		if (is_kfunc_arg_map(meta->btf, &args[arg]))
> 			proto->arg_btf_id[arg] = reg2btf_ids[CONST_PTR_TO_MAP];
> 		else
> 			proto->arg_btf_id[arg] = ref_id_ptr;
> }
> 
> Similarly, for bpf_kfunc_call_test_const_struct(), when &kfunc_const_struct
> (a PTR_TO_MAP_VALUE in .rodata) is passed, resolve_func_arg_type() converts
> the scalar-struct pointer argument to fixed-size memory with MEM_WRITE set:
> 
> kernel/bpf/verifier.c:resolve_func_arg_type() {
> 	...
> 	if (!btf_type_is_scalar_struct(env, btf, ref_t))
> 		return 0;
> 	...
> 	*arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE |
> 		    (*arg_type & (PTR_MAYBE_NULL | MEM_UNINIT));
> }
> 
> When check_func_arg() validates kfunc_const_data and &kfunc_const_struct,
> func_arg_access_type() returns BPF_READ | BPF_WRITE because MEM_WRITE is set,
> causing check_helper_mem_access() -> check_map_access_type() to reject the
> read-only .rodata map with -EACCES ("write into map forbidden").
> 
> Because kfunc_call_test_const_mem is an autoloaded SEC("tc") program in
> kfunc_call_test.c, wouldn't this cause kfunc_call_test__open_and_load() and
> kfunc_call_test_lskel__open_and_load() in verify_success() to fail and break
> the kfunc_call test suite?

the verifier support is added in previous:
  bpf: Honor const on generic kfunc memory arguments

jirka

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261103075916.100050-5-jolsa@kernel.org?part=1

