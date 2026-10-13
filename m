Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4322ACC6B10
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:52:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1255A6B0092; Tue, 13 Oct 2026 09:52:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6216B0096; Tue, 13 Oct 2026 09:52:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06E96B0098; Tue, 13 Oct 2026 09:52:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C70ED6B0092
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:52:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46D9BC0BFC
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:52:04 +0000 (UTC)
X-FDA: 85317741768.16.DF05987
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BC44A180005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:52:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kEjbIHBZ;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791899522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G32wiI4qOUiolozAkV820CbG6zt5mOOYhyIhH56goN0=;
	b=KJihNU7e5GsnrpRVmekOujK6/1gldvjNxL8q+rg3iDzUoAC6+ccFmOpN0f5D7okQhgBDmZ
	ftWsFX8lqu/V8c2wuUc94RaysossOb4Jg+2BeZXqJza2dwHX0kchHHhmFJjI2KXXyALR4J
	xi2wBWmejSlgTL1Oa0cvMmdz6wabyZM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791899522;
	b=d2RCAEuBp17yhTpI6o+np/nUXSIg/TVxMmTfcSEj3l3ahvzRGtZXpRO/JStDVZFMfC0mLp
	r7DcZp5gV8/S5VIuoCx1B12OfcQYLYj9Srkza4qzehvbgUnCTL+lAsneKhxwE00TGY8ekj
	7J2d/qmd4CFnOz9Fz7sf66FVwbN/W5Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kEjbIHBZ;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EFA360A5A;
	Tue, 13 Oct 2026 13:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFBE1F000FF;
	Tue, 13 Oct 2026 13:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791899521;
	bh=G32wiI4qOUiolozAkV820CbG6zt5mOOYhyIhH56goN0=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=kEjbIHBZOuM8JQPe1pPTkyuH+dRImma5IcVxAX79E59k7wAKGa3bykbVdNydDq66w
	 v3lemYPF73xS7VqP37lMSSFIY8GNCQ7867Soh17dRV6JMblpaxVhmh11JHa4cruWoS
	 edkJN4mwHhcH9UWvkk8dJLHYpx105Wowu9FE5uh3CB0PhpFvmNrh4+fW5osqsvi9b8
	 jeReT4rujS13xD/umn6BLdS7LtEC0s7E9IhnPF6rzg1JLMXoM4WbuEUSQxEuL08EIo
	 f7GHH+S2aYNcIjCqrvCJ5HPGjNhpTyfjssEgyehENCNfocpar+Y69xxU0aE2bLPgjQ
	 bKXw5/CzogTdg==
Content-Type: multipart/mixed; boundary="===============8104651796735048521=="
MIME-Version: 1.0
Message-Id: <69c3c1d057b9a47a37b8ddd6eda79c5ca0dade966fa2962f256c50255853e1d4@mail.kernel.org>
In-Reply-To: <20261013122125.843451-4-zhen.ni@easystack.cn>
References: <20261013122125.843451-4-zhen.ni@easystack.cn>
Subject: Re: [PATCH v2 3/6] mm/page_owner: add open-coded page_owner iterator
From: bot+bpf-ci@kernel.org
To: zhen.ni@easystack.cn,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,akpm@linux-foundation.org,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,brendan.jackman@linux.dev,hannes@cmpxchg.org,ziy@nvidia.com,shuah@kernel.org
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,zhen.ni@easystack.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue, 13 Oct 2026 13:51:58 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC44A180005
X-Stat-Signature: 354sdzqczw8em5gxp95hb7uuetn8mi58
X-HE-Tag: 1791899522-435694
X-HE-Meta: U2FsdGVkX1/pGAYF3APH8x+G/v3sS1Og1YjyDWb2UBdtmNgtDyqZCgFsneqy7MA/v5A+SyNNhKCQf3c9VRA0ERl1SzOO+PFXlmbPdOAYC995ujozEgAPnup58sPfcBIvrMAkX+90PHpie8UsCDkIz1bQHCJEfH0Tp0rLPt6iDT+1w9o0lqosPIGegC2TFsaD41tk87+GT143nn/FEKhKL2RNWwk4gpLgjl6X0j9a5iIzDlUkG7SJlU/im5ETtNVF9FSNRKgJwO9TSx23kINZ8sNNJ/Nr6UCzPy6NypWIO60lUDZ2qZIc9HUX7SbVlCBcp0T/47v78fHTCknM979ehnBzHzU48xt+4Pol3AkS+xMmpV99BittnZliZZOmMhpNgvS+PBxUm01nvyNVGwv8V9Gn9pw06xIkXJXwbEm/XcyhHqLp1T0KSYhN1zEImTAxeyVyGa+/9ExH1GrebDFlVzacVQVYDkpkB3rovJgp8MFOpw1TPhaGpeMdYfbb4QH2365SJYyv7Cd2+CKe5BFutMbmv0tk4cNJBED5Wb9z8UlTtB7fc1jzwYPnm26k2uw5g0DTx7XskQrAmX9oOCfFMPH1ZRiMz39xzys7ZDv09Wfn8/3RLb3wdRkL6DryGUMhNUU+mTUZY4tvgudPMPhid8i3MmNfVnH5/1vRLLmvAsngBmR3Z2vQRI5cMa3sSV3anKumgwzMKs2d7PE0250oXLkzmWtEI8ej6Nt7HULDhAOfeTmnwv7VL5vrAwSvxH7h4Pq1dNG6mrh4j70TDExGz/XnG/PZnRleQ8mCN3f2odbsP3uzL6EdtMvIdX+FvtuKeIXmq1SBkhmD+bHzmbtFyEcdxTV9lG1qDEEjSQXET+JpwD/CwGLpQFthrWlkoIFH6ZtblTdmWLEUk0JR9lXThreUd+HNe5ebkfrKH7uGrzIXMOTqpsQ4qy5kNuwJ+BkbtAsyYP9zXDGsRU630uI
 nelY1h+G
 AkxAtC42btxpLqNCp3GCWKLdxO2S0Mpfm5VeSvF1FpHK8JIxZ7nBG5UKAZyC5u6bUZjayRzWQNIaML04u8W3bOs06vIK0wpYjmJkJGsq5LVUQlkOK8MKoLLLNJFKGSsQProtFqdgN//CsFdcYBst9m1DDYsKF1hNUbTnuNQ0dx5bQtGCaotkEgQyLufM3o14kaGv5ZgyHjPIdqwYMP4Cq5pX6rOiQxS2RxvikzQRerst8BTNV6TF3YXJDp2VV55h2Y2veDCNU9oFUA49zRlUp925uPikPLxKKvUsU5dlLlSnFq3YNyMepyLp5yelC60JrFP72JzZYi8FKE0G1bj6GhXutzSZnPDX1rdTnASCaLCAtxgt0HRjYtJtzsR7PCrU05vSn0tR6hfCDsKq9N6M8o2kcZ5+vWwYuwQVdh1+ccCXYleU1Ub60PDbZMVCcnNYIRdggqSuG7GQtMnJA5DWSt8JrbDzyzJCAVpJC4sMOjSU+PKHVFraKs38gsj7s4HnqEkpiL3xiompU1s9UJWYlJBaiC3zNoBvqaPBe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8104651796735048521==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> mm/page_owner: add open-coded page_owner iterator

TL;DR: The new page_owner kfuncs may lack KF_PERFMON, so a CAP_BPF-only
syscall program could read page_owner records and symbolized allocation stacks
that are root-only in debugfs.

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index a284f20c97d5..85ce368315f9 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c

[ ... ]

> @@ -5177,6 +5177,12 @@ BTF_ID_FLAGS(func, bpf_iter_dmabuf_new, KF_ITER_NEW | KF_SLEEPABLE)
>  BTF_ID_FLAGS(func, bpf_iter_dmabuf_next, KF_ITER_NEXT | KF_RET_NULL | KF_SLEEPABLE)
>  BTF_ID_FLAGS(func, bpf_iter_dmabuf_destroy, KF_ITER_DESTROY | KF_SLEEPABLE)
>  #endif
> +#ifdef CONFIG_PAGE_OWNER
> +BTF_ID_FLAGS(func, bpf_iter_page_owner_new, KF_ITER_NEW | KF_SLEEPABLE)
> +BTF_ID_FLAGS(func, bpf_iter_page_owner_next, KF_ITER_NEXT | KF_RET_NULL | KF_SLEEPABLE)
> +BTF_ID_FLAGS(func, bpf_iter_page_owner_destroy, KF_ITER_DESTROY | KF_SLEEPABLE)
> +BTF_ID_FLAGS(func, bpf_page_owner_stack_snprint, KF_SLEEPABLE)
> +#endif
>  BTF_ID_FLAGS(func, __bpf_trap)
>  BTF_ID_FLAGS(func, bpf_strcmp, KF_PERFMON);
>  BTF_ID_FLAGS(func, bpf_strcasecmp, KF_PERFMON);

Should bpf_page_owner_stack_snprint(), and probably bpf_iter_page_owner_new(),
carry KF_PERFMON here?

These kfuncs are added to common_btf_ids, which is registered for
BPF_PROG_TYPE_UNSPEC, and none of them has KF_PERFMON.

BPF_PROG_TYPE_SYSCALL programs are always sleepable (check_attach_btf_id()
requires it), and they only need CAP_BPF (or a delegated BPF token) since
SYSCALL is not covered by is_perfmon_prog_type().

That means a CAP_BPF-only loader can walk all page_owner records and use
bpf_page_owner_stack_snprint() to copy symbolized allocation stack traces
into program memory.  This skips the allow_ptr_leaks gate that
check_ptr_to_btf_access() applies when the same data is read field by field.

The debugfs interface that exposes this information is root-only: page_owner
is 0600 and the page_owner_stacks/* files are 0400.

This tree already has KF_PERFMON (commit 88ce88e933e4 "bpf: Add KF_PERFMON
kfunc flag"), and comparable kfuncs use it, for example bpf_get_kmem_cache()
and bpf_probe_read_kernel_dynptr() in this same table.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/38403671988
--===============8104651796735048521==--

