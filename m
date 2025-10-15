Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A71D9CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 02:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AC9D8E0157; Tue, 14 Oct 2025 22:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084EE8E0005; Tue, 14 Oct 2025 22:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03A48E0157; Tue, 14 Oct 2025 22:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E014F8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:13:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CA9611A504
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:13:03 +0000 (UTC)
X-FDA: 83998725846.24.82E670D
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id A2046A0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:13:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BS1PPiC0;
	spf=pass (imf25.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760494381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZJ0RxzbQsaIBiUFXIinzpwPD8WCaTc3WmPgE0k6JkY=;
	b=dl1g0PFJIIEITAaJnXLFKe+1BVkyb8sYsnEHsfcpcnVPCorqSR8pJkOjCSFBb2Uv5qMi/7
	q3lpNPtqmttz0egtoNwR7XBO4cS3LmrNshjV62bjWbuLU2KWE4OYutF7U9WnjP7tkC8CZb
	MeACHBn+oR66DZOTAyyLUBlIqi4fzyw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BS1PPiC0;
	spf=pass (imf25.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760494381; a=rsa-sha256;
	cv=none;
	b=OM0A6pSDUKzpJu6RGSqdg5+A0Qjl+jEuybC0STKjybslQedp5e+mP13Om+7uDmysiM2gQ9
	zC5KQ4rH2udHVKobdxEh6+ZwCL1QyrIeH8mC2Ci1wrxvfPz2KMN/Y+YW/2ooJReN08d628
	cocVgpM09eNHKNupL96QfThg5kM4kXw=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3ee64bc6b90so3408017f8f.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760494380; x=1761099180; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VZJ0RxzbQsaIBiUFXIinzpwPD8WCaTc3WmPgE0k6JkY=;
        b=BS1PPiC0BTmuR8LYi1xL5eS2cgzPJMo5WUffjkhYupxqMzC5A2LCAeHyNqbr5kws3s
         m/yLfX+OCcRmOq+ewKjBZgNlPm7Ls94LhRpuWLoc+KaJWzrdHY2Z61FIIUiOHCTIw6Qp
         4qZmMkm6X90IkZrnmaXq1Nbv/F5xhz2VB5VL/ggMJfyplA9v4igOonsTosJmqa3F3TSz
         e9pwqjPlyTViXROdfa09YJIrEgxs9qsF9NqcJBuM2/eAdOm2ZPdyORcOSPWiwftJSmlo
         uh78z4xcTuxNKeCWCnV5Jl6qPU907/Tq0R+eCADXb6aA3gVxbQ7BkKnEG6x6O/mw6N2E
         L23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760494380; x=1761099180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VZJ0RxzbQsaIBiUFXIinzpwPD8WCaTc3WmPgE0k6JkY=;
        b=giF/kxp8zZYshLaGqwjot/z+jlIbUDkKYXVhp42NH+Io47E6Qo7fuo5uGym/zWZXBs
         HO3UN/O0mWkxJP94Ba9pHqAmauQGcb3v3TAhvUJ0C8wnvx1Hyo9WPropSsyZyJi/rW/J
         K8idx0baEqbG0/zPEv9ax7HiilXbRnXGRZEpC1d1DBjxSvJZCU5yPTQfZZVZYJH+aUcj
         DQNqMLwrZlNw30vdVEEg80zBjAo900JhBCShV7xE/xKI5YJce5lSZO8W8K84LzFCm0OS
         jq+m1eZGsndQy1lK4MbAkRCMbT5CpEIHqAekr5JOR0re2FK2zSUCIWAiuUQI+xPLCoiL
         JZmA==
X-Forwarded-Encrypted: i=1; AJvYcCV9SswlmQdosqbj33EPWakSnOCmCMslmJGO5MlWlqFBQA5+nITg5iTeczlEIBLPAnHwNoDVCCK1ZA==@kvack.org
X-Gm-Message-State: AOJu0YxQqQjknAb+5vdYRDEf1TH3ilj+ljITzFf9+cDL6WXPsrxvYG+1
	f0PfZWHy+04mmiOAvj3K4FB47qk9YDjYZ/p53xdyFk2FLR09Z6kj5ZZa4DdCO5PSHkbbXUft9EI
	tW2vButsjzDCE7Oru8BWQWGojfJa0Ino=
X-Gm-Gg: ASbGncurAHfcOC1zO81WZkH7V7Qhsf++C6EGYxfynOw0iNydXKeBhpnH48VP5V1r0h6
	kPhN1eMDKfZzADqgAgPOPt09UhJX+EP8wxrMCzJl07lBYqXOlwG4ICd9DwaXsOojPVZluxuS9oZ
	+yp4SgcxvvRojcsQ8RhKMm6IKNPNd7jqK4jZhXSP49wKmQXsxaxkkJFXI9YUFtC/Qihipw9HOef
	PIv6ks+PQDU9EYuFLYIORCQww5U6XgyJQZ0GGmVLNF2fRgu72oWn+oDbDc=
X-Google-Smtp-Source: AGHT+IEwYA517M0XM7y/RBDJ75Pdx2FaIZOm3jjoxpf1t30CFtaHlbZHgoUlOk6ZEcZbTczeZOv8CSaRDtbDstfleZU=
X-Received: by 2002:a05:6000:438a:b0:425:86ae:b0b with SMTP id
 ffacd0b85a97d-4266e7d9330mr19858110f8f.38.1760494379757; Tue, 14 Oct 2025
 19:12:59 -0700 (PDT)
MIME-Version: 1.0
References: <20251015000700.28988-1-alexei.starovoitov@gmail.com> <aO8AAD4sJA9ORlO5@hyeyoo>
In-Reply-To: <aO8AAD4sJA9ORlO5@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 14 Oct 2025 19:12:48 -0700
X-Gm-Features: AS18NWBswixMrlr5nowYRcKQlHuls29t8Ef-LXpIkHMfVAzD3LEtX_caH29NLS4
Message-ID: <CAADnVQLJ33_az3qK49PDwjh5aeSirUOuiJax+-7p2S3MKziaoA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf] bpf: Replace bpf_map_kmalloc_node() with
 kmalloc_nolock() to allocate bpf_async_cb structures.
To: Harry Yoo <harry.yoo@oracle.com>
Cc: bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, Peilin Ye <yepeilin@google.com>, 
	linux-mm <linux-mm@kvack.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qsyn368enqrcaetu5qd436egd87ztxpn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A2046A0005
X-HE-Tag: 1760494381-35852
X-HE-Meta: U2FsdGVkX1+2xsjYciAFJVoploQ2MAE7ejkbFXOh9OL20ujdb+FrgxFUmSz9HR6r1j4xLhxsH4Rob27gcF5rzCoEua0fXerEVmmM1kzecSKfdIcNZrZrvl/jkELfUv2tESTBvSVe+qVNlx7astzNS4nIq4HKb9UcJsAqe62mSuwWAHRkh7RrpvpZG1i8UqtXNx1/iFMOGPoCW0j1EW6A/jBvdVKfDqt/TjHdwV9YfaZxzwJs6XJaeJZ8GBZTxfoSuXIv7Q5KyxD9ex/AhKWLbsNoWkJ7jXDgZq87GnjmmvPDcWwy4JDYQaMgkrOtXRusYhQJS4jwtkX7jCBDYAzo8WluMCZUbYVm/WMpCLQHRmZpXz7ppHnlwhVWo1YO+PF+D1ApFduWeLhnyjN0nad+YrgXWB3yRpN1hTuLKmrowJ3FrOAs6SaDBinwgeFHFymRpXAeWo479vxCjGbD409FpoZRCUKVIqW0uxVl7RPKOB4xwgNhV9+dJOhehFGeITT6KqlvgjuuwOY8UZE02GU7C4HKIpnpKIDBtLRjOhmzUEBRGbzzSK/xUovbMuNhVgtYIGmaX4mShIVVmbFfKnUsynHU0d2Goup8w9+AUTUSBXuNjUodAXhl9YK0oWsyGk3vRlUWxUYb6Bjp4HNMDOMQJTU2LXQJctmUlZ30UeOAvfyOtyESc7fIPxC2aBeJyq3UH8cUF1nwxpdUjTYHaJRN5W7K17Al9mwo3lAC5Uy/YU1t3kFRw8zEHMGlMcAs7gnKxhXkNTkGsDjSezvOSli0/L74x+0Ql28utJwrUoW1fb+ZODEHsyW4FmTb2OhoQUEP2mnsYAN/JsIek58As+fSq3YkBcw9teP37JICRcCYMpZFuYbfN4u8FNkNIVIDSwzGGkeIPMCsatJfblB+LnYuHPInL9D+gL3VtC5RcvALvJBrRROD+tx6uIUDq/7zgqisST/rNt49oLsy3qQfjsa
 uYk6DdVq
 UEl+2nhQSLn9JvMi1hJOWOMEcjOPR/O6YcfXjj86gZJDasFqYcCGspVQo+uV7Puf67RGcxCudvuOb6qYP/gYCN0YZtm2i2vKwUeqktFk7J3Ix7gwOMtT0KgLP9quNQDGa/266D7v57Do6UUYgv+sKaTARfBQs8O3Qd/WiK/I3x+Pgv6w+QohBTCNhDpL0RsOGcKJvI6/2J0JYtPD2pNGQ5WHEOfn2v2cTFhhAxvNulkyn/WzCmfOwfFg0FVCKzPS7cJ4wZjMciCxzbWhSwYe2LjMCHi/HLF0M3L1Ysc95GGwQoZ40LYkjcjLVgHjYAWQM4aXF/Pss2bbewELMUGc0oNAwsQYlfAnTItzM0/4NZ6e8qzE/fdnyAsojFQYQbbYFG8Q6ICbxwWjQB1aQlztFFSkBLT5N8movU0tZxhG7d/CUUBWewBUW+tFWNvvmfB+qlgIcjdD98cxRUCUrDeABkrGtDCi9xOgyvujO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 6:59=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Tue, Oct 14, 2025 at 05:07:00PM -0700, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > The following kmemleak splat:
> > [    8.105530] kmemleak: Trying to color unknown object at 0xff11000100=
e918c0 as Black
> > [    8.106521] Call Trace:
> > [    8.106521]  <TASK>
> > [    8.106521]  dump_stack_lvl+0x4b/0x70
> > [    8.106521]  kvfree_call_rcu+0xcb/0x3b0
> > [    8.106521]  ? hrtimer_cancel+0x21/0x40
> > [    8.106521]  bpf_obj_free_fields+0x193/0x200
> > [    8.106521]  htab_map_update_elem+0x29c/0x410
> > [    8.106521]  bpf_prog_cfc8cd0f42c04044_overwrite_cb+0x47/0x4b
> > [    8.106521]  bpf_prog_8c30cd7c4db2e963_overwrite_timer+0x65/0x86
> > [    8.106521]  bpf_prog_test_run_syscall+0xe1/0x2a0
> >
> > happens due to the combination of features and fixes, but mainly due to
> > commit 6d78b4473cdb ("bpf: Tell memcg to use allow_spinning=3Dfalse pat=
h in bpf_timer_init()")
> > It's using __GFP_HIGH, which instructs slub/kmemleak internals to skip
> > kmemleak_alloc_recursive() on allocation, so subsequent kfree_rcu()->
> > kvfree_call_rcu()->kmemleak_ignore() complains with the above splat.
> >
> > To fix this imbalance, replace bpf_map_kmalloc_node() with
> > kmalloc_nolock() and kfree_rcu() with call_rcu() + kfree_nolock() to
> > make sure that the objects allocated with kmalloc_nolock() are freed
> > with kfree_nolock() rather than the implicit kfree() that kfree_rcu()
> > uses internally.
> >
> > Note, the kmalloc_nolock() happens under bpf_spin_lock_irqsave(), so
> > it will always fail in PREEMPT_RT. This is not an issue at the moment,
> > since bpf_timers are disabled in PREEMPT_RT. In the future
> > bpf_spin_lock will be replaced with state machine similar to
> > bpf_task_work.
> >
> > Fixes: 6d78b4473cdb ("bpf: Tell memcg to use allow_spinning=3Dfalse pat=
h in bpf_timer_init()")
> > Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
>
> LGTM,
> Acked-by: Harry Yoo <harry.yoo@oracle.com>
>
> So we're losing benefit of batch-processing via kfree_rcu() and
> instead using call_rcu(), and I guess it's fine since it's not very
> performance critical

yes. Here freeing is not in critical path.

> so we don't have to make kfree_rcu() work with
> objects that are allocated via kmalloc_nolock()?

Not quite :) It's on the todo list.
Something like kfree_nolock_rcu() is needed, and
also SLAB_TYPESAFE_BY_RCU-like and new SLAB_TYPESAFE_BY_SRCU_FAST flag.
The plan for the upcoming merge window is to delete rcu tasks trace
and replace with srcu_fast. It will clarify next steps.

