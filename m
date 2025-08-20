Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50BB8CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 20:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0EC06B00FA; Wed, 20 Aug 2025 16:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6506B00FB; Wed, 20 Aug 2025 16:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC586B010D; Wed, 20 Aug 2025 16:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA726B00FA
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:01:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 444A4160125
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:01:18 +0000 (UTC)
X-FDA: 83798205036.13.254ADDD
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1D57C140009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:01:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U6BGw2EJ;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755720076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZHpBgtYPYHtucmIdxgGOSddtSTD56hTh0/7sxyZ3tg=;
	b=04BuUUP6qM65B4qnDrcA3TGD3EYzfHOwZI103kKZcdYEk3gzK87fZGYlnk2WMLjd70yE3/
	yxxNyxudSu4O+F8tF7F/NUXL1ty8CXek4jb5uUpD8x/ywsrsiK6oPxy8EkTtWVjT6rpEi5
	/PSRd9Yf+XKJVLYBquhwp7V9A5Y4c+Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755720076; a=rsa-sha256;
	cv=none;
	b=C/WD64b8XX1RjvviRpCquvDFgVQUm8xsiN4HTDwnWlm3TtIt7a5awrb6cuK7EvzWmrYB74
	jzKVcXz2FNdwsHgMYsXV9OZUakiBwwOI9aPOB0RQARKqMKV5Vt+BnIGmeWdFxooz/Grviu
	M+gf/dEPtfUWr39q6S0lwK66hB6fig4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U6BGw2EJ;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b0bd88ab8fso52811cf.0
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755720075; x=1756324875; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZHpBgtYPYHtucmIdxgGOSddtSTD56hTh0/7sxyZ3tg=;
        b=U6BGw2EJv/zd34oCKjdm9mJDJj/xqXzJe6gSMe5JXOinY9cffWRkea0zxNXPN6tdtu
         7uwWQdCmCDedS7hOcvFjY3o03xD9TQeTu6P7K/yMEVfU/1wgy4nILNbG7+qt5I6MD+SC
         BGIUkjFVEeIu2fd8erpoxIRxeKXO2shsUq2OznB1TAols1Jnjb0e1rX+zdlrRRlThy3d
         gWe67GdW9RrmKhS9k/HZArbTdF3m6dZ0OS+RzJGZ36ogt+zcgvi1J64MHKpOi8Gj9ypB
         pRAQAXKRyIuKODs/8ValKP3z8rMQcUvIWLkiADJhwBDX3f6fLtbVBgoto92cFuHlSArN
         T1CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755720075; x=1756324875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XZHpBgtYPYHtucmIdxgGOSddtSTD56hTh0/7sxyZ3tg=;
        b=VnT/f6R0V0y991GZximrMKxyq5HPYFBfasB1/7CThXoAWXYpS5aqn75WUW1qSZMCBB
         pjWvpG7OMKXImYqfC6eMA4nB5QVCgkRQl8g+RgDoj2M6p+wEMl1NV0CsH4mBDy2rFJUs
         Q03pQVLVYmZiLLaYKjX22KxNQl/LMDnNlwOlc3tICG7tp2/IfcjTrk6SkLHXG4DnQWzD
         CZYHPcbDhtBI+kjlIHTv73cWHMEq44p9Rap84uxM0NEO16DjSx8m5iOhbm7oYrG2uPp1
         cY4fnGZbH0CFeh/LM/rSPwWAA0WIbmY8V5PIPbT5ri75S06BBdAmtplaBTXPqFUh54Va
         GVsQ==
X-Gm-Message-State: AOJu0Yy2OWSWhV1WQDxbFk8n5I7QFhAD/UY2GF1MnYKdDPWymHuloioJ
	sMqx9t1YOUDggrgfU9s9qE3XoUr3n7SgFBRIUFN6rjIeRsmA1ap2gLx4jl9oZpMoYTrsgRIiFO5
	7/CgD6WDGtN5JE+9d6LDmfwgx0uXxAD33Zq6mdl1a
X-Gm-Gg: ASbGnctU8i0QGV28ctUFPypYsCwTA/YCSQCMttKe39il3TYdv2cU8TtWcvrOq2XVUd/
	TYtiUmkj/5Z47pvWWk+3IsRbLvuOp4xPnB+Lren4C+1Vw58HpPIB2KFsMyYSlMgfZa4FioXLKQh
	mY7PEQ8Xe/SwFsBosB6Vn30kGR1ZITOOV9HgO85/24ip5qc9G4HZ60PdYOSmyUgVQ3RFzXYCAwW
	GfTD3JyhZBPvcgYCjZZNzIiKhvPjsjRJ6rdwkJitZqj3jv6xpCEvWY=
X-Google-Smtp-Source: AGHT+IEL8Eyf3HoCCmeURtWSFh5KDPWTqFqYTV0HgtgVva2ifCQSC08IYFs1SwOdKrfHXAge3EuboiWhA+J0wGdMC/4=
X-Received: by 2002:a05:622a:1107:b0:4b2:9d13:e973 with SMTP id
 d75a77b69052e-4b29f242890mr167901cf.0.1755720074514; Wed, 20 Aug 2025
 13:01:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev> <CAJuCfpF2akVnbZgPoDAXea2joJ1DWvBTHC7wGzEJcYX9xF9dSA@mail.gmail.com>
 <878qjf13gx.fsf@linux.dev> <CAJuCfpFT1oo0+9f_XQa29UeZseLNNbwc19pLbG0MOthgxrtVuQ@mail.gmail.com>
 <87ikihpy7l.fsf@linux.dev>
In-Reply-To: <87ikihpy7l.fsf@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 20 Aug 2025 13:01:03 -0700
X-Gm-Features: Ac12FXwYLbtbb7Qc3TluV60imXAefjG98oaPwRdxmG6KromwViJScrDJ0KBHPfk
Message-ID: <CAJuCfpGyKK7rw_KMicLwGcJx3gYam4HLVRqkc7y163p2H5ykiA@mail.gmail.com>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1D57C140009
X-Stat-Signature: 6ohzqb13kuu17nssuenxfj6kyzasbi1t
X-HE-Tag: 1755720075-466454
X-HE-Meta: U2FsdGVkX1/GtI4H3GTaWyvtbwXEL0zzPvq7ts1DzIJMvPQx49kBJ/wxMJ+vVOA56+LYuKA8eCdpQHrw1HNGQrHZkNHCICd/swBM0pJD8Q86di/7IhrRJXErVAnL3xfQgpknXuBlrxpwoPiDmqA4JQ4ZMEfQxbEe99l9tISu7ZsDNtHDvFyIDvaUBmpnazqG/NxSkNHDFrctUKjtTLMv4tZ4iflj3d4irogkyJYrWhxQwrH8EUiE5GwDfQ9gJQA4qjQYS9mkZfykFXr+s/WqhiaYZqmrGJEZpUE1/nbTE793FxS5F9tuPrhMhrbBwvFa1/KjJccN0LZRXkYmfzZ3eWnlq4kJ9cSBLFr1l8EPUzRG15EkCjtge1hk/yrD6PeOiujYEv+z9Fw06dVTfJzUVsK+5NVnysOtZ729S3IrCJVDzQVD2gcH7oPmR17bQXNg4WiGAhJTMPx+2anifMwBdXjeZIOIkgyEFp1cKtY1kllTJzkbNAhrkZ/cny319RlMKTllGL7OlFPTPnSn01LZi7jdHKYpIQ104Bz4xDAkZxN80TyZhaoVbZDYJWyoUQepeg9m5GzMQKxwGqbCKOJzTUvRarQs0KJYyRvrjBUK52vwg8v8Xii7wREqungCtsmqQ/mVfMmQ3WB+YXp4GJxFZjDuSbYOPakHh3MdBJoronvUqnMmletnvj0X6VhL7S4sibVLX7cIQ3Ppxgq4M3KPBtJIxBd4+QsrG0c2s24dc0AGVlYDM/sCMlzY2FSuad8ho+kk3u3YqNyrBPn2uXKjs0uhD9/kp7hiG4j0luoHNdc8Dk1N/el9L7k3chU1+UWILcWvEVUfbMXB4Q/O6959Bpuo2NMoQ7Go2W8UCryqZjDQ3TV3yfyjO1Yf3thOCjNEJq3B+F22FzxGU3CgilMg7ddPMb8wt3JUOqFu4/chLFaWdKpB8aVv22H/F+8aDP3mSKGNyhvVx+AF5Wue/JQ
 nnBh2GUK
 Xcl8GO0n54TKGAk4eWWmkKyQZkdclRyhcjwqhsLVhbnrbuCeqxBgdAFMEu6b2J8FGkFMDJ6pfP1XShx6AYNI8ughyvZQFzYVC/9TQwyCGKDaBaKTJ1pESB6ChHRMweOPnE6s9wuuCfSgp0DvhiCj12OP9SsFmLb4Jq4lRKeAPlpytiu7CtlL7p040sQWBY7odfbvtpUShDoOeREJERn3n15nUj0POVbOXxJeb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 12:53=E2=80=AFPM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Suren Baghdasaryan <surenb@google.com> writes:
>
> > On Tue, Aug 19, 2025 at 1:06=E2=80=AFPM Roman Gushchin <roman.gushchin@=
linux.dev> wrote:
> >>
> >> Suren Baghdasaryan <surenb@google.com> writes:
> >>
> >> > On Mon, Aug 18, 2025 at 10:01=E2=80=AFAM Roman Gushchin
> >> > <roman.gushchin@linux.dev> wrote:
> >> >>
> >> >> Introduce a bpf struct ops for implementing custom OOM handling pol=
icies.
> >> >>
> >> >> The struct ops provides the bpf_handle_out_of_memory() callback,
> >> >> which expected to return 1 if it was able to free some memory and 0
> >> >> otherwise.
> >> >>
> >> >> In the latter case it's guaranteed that the in-kernel OOM killer wi=
ll
> >> >> be invoked. Otherwise the kernel also checks the bpf_memory_freed
> >> >> field of the oom_control structure, which is expected to be set by
> >> >> kfuncs suitable for releasing memory. It's a safety mechanism which
> >> >> prevents a bpf program to claim forward progress without actually
> >> >> releasing memory. The callback program is sleepable to enable using
> >> >> iterators, e.g. cgroup iterators.
> >> >>
> >> >> The callback receives struct oom_control as an argument, so it can
> >> >> easily filter out OOM's it doesn't want to handle, e.g. global vs
> >> >> memcg OOM's.
> >> >>
> >> >> The callback is executed just before the kernel victim task selecti=
on
> >> >> algorithm, so all heuristics and sysctls like panic on oom,
> >> >> sysctl_oom_kill_allocating_task and sysctl_oom_kill_allocating_task
> >> >> are respected.
> >> >>
> >> >> The struct ops also has the name field, which allows to define a
> >> >> custom name for the implemented policy. It's printed in the OOM rep=
ort
> >> >> in the oom_policy=3D<policy> format. "default" is printed if bpf is=
 not
> >> >> used or policy name is not specified.
> >> >>
> >> >> [  112.696676] test_progs invoked oom-killer: gfp_mask=3D0xcc0(GFP_=
KERNEL), order=3D0, oom_score_adj=3D0
> >> >>                oom_policy=3Dbpf_test_policy
> >> >> [  112.698160] CPU: 1 UID: 0 PID: 660 Comm: test_progs Not tainted =
6.16.0-00015-gf09eb0d6badc #102 PREEMPT(full)
> >> >> [  112.698165] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996=
), BIOS 1.17.0-5.fc42 04/01/2014
> >> >> [  112.698167] Call Trace:
> >> >> [  112.698177]  <TASK>
> >> >> [  112.698182]  dump_stack_lvl+0x4d/0x70
> >> >> [  112.698192]  dump_header+0x59/0x1c6
> >> >> [  112.698199]  oom_kill_process.cold+0x8/0xef
> >> >> [  112.698206]  bpf_oom_kill_process+0x59/0xb0
> >> >> [  112.698216]  bpf_prog_7ecad0f36a167fd7_test_out_of_memory+0x2be/=
0x313
> >> >> [  112.698229]  bpf__bpf_oom_ops_handle_out_of_memory+0x47/0xaf
> >> >> [  112.698236]  ? srso_alias_return_thunk+0x5/0xfbef5
> >> >> [  112.698240]  bpf_handle_oom+0x11a/0x1e0
> >> >> [  112.698250]  out_of_memory+0xab/0x5c0
> >> >> [  112.698258]  mem_cgroup_out_of_memory+0xbc/0x110
> >> >> [  112.698274]  try_charge_memcg+0x4b5/0x7e0
> >> >> [  112.698288]  charge_memcg+0x2f/0xc0
> >> >> [  112.698293]  __mem_cgroup_charge+0x30/0xc0
> >> >> [  112.698299]  do_anonymous_page+0x40f/0xa50
> >> >> [  112.698311]  __handle_mm_fault+0xbba/0x1140
> >> >> [  112.698317]  ? srso_alias_return_thunk+0x5/0xfbef5
> >> >> [  112.698335]  handle_mm_fault+0xe6/0x370
> >> >> [  112.698343]  do_user_addr_fault+0x211/0x6a0
> >> >> [  112.698354]  exc_page_fault+0x75/0x1d0
> >> >> [  112.698363]  asm_exc_page_fault+0x26/0x30
> >> >> [  112.698366] RIP: 0033:0x7fa97236db00
> >> >>
> >> >> It's possible to load multiple bpf struct programs. In the case of
> >> >> oom, they will be executed one by one in the same order they been
> >> >> loaded until one of them returns 1 and bpf_memory_freed is set to 1
> >> >> - an indication that the memory was freed. This allows to have
> >> >> multiple bpf programs to focus on different types of OOM's - e.g.
> >> >> one program can only handle memcg OOM's in one memory cgroup.
> >> >> But the filtering is done in bpf - so it's fully flexible.
> >> >>
> >> >> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> >> >> ---
> >> >>  include/linux/bpf_oom.h |  49 +++++++++++++
> >> >>  include/linux/oom.h     |   8 ++
> >> >>  mm/Makefile             |   3 +
> >> >>  mm/bpf_oom.c            | 157 ++++++++++++++++++++++++++++++++++++=
++++
> >> >>  mm/oom_kill.c           |  22 +++++-
> >> >>  5 files changed, 237 insertions(+), 2 deletions(-)
> >> >>  create mode 100644 include/linux/bpf_oom.h
> >> >>  create mode 100644 mm/bpf_oom.c
> >> >>
> >> >> diff --git a/include/linux/bpf_oom.h b/include/linux/bpf_oom.h
> >> >> new file mode 100644
> >> >> index 000000000000..29cb5ea41d97
> >> >> --- /dev/null
> >> >> +++ b/include/linux/bpf_oom.h
> >> >> @@ -0,0 +1,49 @@
> >> >> +/* SPDX-License-Identifier: GPL-2.0+ */
> >> >> +
> >> >> +#ifndef __BPF_OOM_H
> >> >> +#define __BPF_OOM_H
> >> >> +
> >> >> +struct bpf_oom;
> >> >> +struct oom_control;
> >> >> +
> >> >> +#define BPF_OOM_NAME_MAX_LEN 64
> >> >> +
> >> >> +struct bpf_oom_ops {
> >> >> +       /**
> >> >> +        * @handle_out_of_memory: Out of memory bpf handler, called=
 before
> >> >> +        * the in-kernel OOM killer.
> >> >> +        * @oc: OOM control structure
> >> >> +        *
> >> >> +        * Should return 1 if some memory was freed up, otherwise
> >> >> +        * the in-kernel OOM killer is invoked.
> >> >> +        */
> >> >> +       int (*handle_out_of_memory)(struct oom_control *oc);
> >> >> +
> >> >> +       /**
> >> >> +        * @name: BPF OOM policy name
> >> >> +        */
> >> >> +       char name[BPF_OOM_NAME_MAX_LEN];
> >> >
> >> > Why should the name be a part of ops structure? IMO it's not an
> >> > attribute of the operations but rather of the oom handler which is
> >> > represented by bpf_oom here.
> >>
> >> The ops structure describes a user-defined oom policy. Currently
> >> it's just one handler and the policy name. Later additional handlers
> >> can be added, e.g. a handler to control the dmesg output.
> >>
> >> bpf_oom is an implementation detail: it's basically an extension
> >> to struct bpf_oom_ops which contains "private" fields required
> >> for the internal machinery.
> >
> > Ok. I hope we can come up with some more descriptive naming but I
> > can't think of something good ATM.
> >
> >>
> >> >
> >> >> +
> >> >> +       /* Private */
> >> >> +       struct bpf_oom *bpf_oom;
> >> >> +};
> >> >> +
> >> >> +#ifdef CONFIG_BPF_SYSCALL
> >> >> +/**
> >> >> + * @bpf_handle_oom: handle out of memory using bpf programs
> >> >> + * @oc: OOM control structure
> >> >> + *
> >> >> + * Returns true if a bpf oom program was executed, returned 1
> >> >> + * and some memory was actually freed.
> >> >
> >> > The above comment is unclear, please clarify.
> >>
> >> Fixed, thanks.
> >>
> >> /**
> >>  * @bpf_handle_oom: handle out of memory condition using bpf
> >>  * @oc: OOM control structure
> >>  *
> >>  * Returns true if some memory was freed.
> >>  */
> >> bool bpf_handle_oom(struct oom_control *oc);
> >>
> >>
> >> >
> >> >> + */
> >> >> +bool bpf_handle_oom(struct oom_control *oc);
> >> >> +
> >> >> +#else /* CONFIG_BPF_SYSCALL */
> >> >> +static inline bool bpf_handle_oom(struct oom_control *oc)
> >> >> +{
> >> >> +       return false;
> >> >> +}
> >> >> +
> >> >> +#endif /* CONFIG_BPF_SYSCALL */
> >> >> +
> >> >> +#endif /* __BPF_OOM_H */
> >> >> diff --git a/include/linux/oom.h b/include/linux/oom.h
> >> >> index 1e0fc6931ce9..ef453309b7ea 100644
> >> >> --- a/include/linux/oom.h
> >> >> +++ b/include/linux/oom.h
> >> >> @@ -51,6 +51,14 @@ struct oom_control {
> >> >>
> >> >>         /* Used to print the constraint info. */
> >> >>         enum oom_constraint constraint;
> >> >> +
> >> >> +#ifdef CONFIG_BPF_SYSCALL
> >> >> +       /* Used by the bpf oom implementation to mark the forward p=
rogress */
> >> >> +       bool bpf_memory_freed;
> >> >> +
> >> >> +       /* Policy name */
> >> >> +       const char *bpf_policy_name;
> >> >> +#endif
> >> >>  };
> >> >>
> >> >>  extern struct mutex oom_lock;
> >> >> diff --git a/mm/Makefile b/mm/Makefile
> >> >> index 1a7a11d4933d..a714aba03759 100644
> >> >> --- a/mm/Makefile
> >> >> +++ b/mm/Makefile
> >> >> @@ -105,6 +105,9 @@ obj-$(CONFIG_MEMCG) +=3D memcontrol.o vmpressur=
e.o
> >> >>  ifdef CONFIG_SWAP
> >> >>  obj-$(CONFIG_MEMCG) +=3D swap_cgroup.o
> >> >>  endif
> >> >> +ifdef CONFIG_BPF_SYSCALL
> >> >> +obj-y +=3D bpf_oom.o
> >> >> +endif
> >> >>  obj-$(CONFIG_CGROUP_HUGETLB) +=3D hugetlb_cgroup.o
> >> >>  obj-$(CONFIG_GUP_TEST) +=3D gup_test.o
> >> >>  obj-$(CONFIG_DMAPOOL_TEST) +=3D dmapool_test.o
> >> >> diff --git a/mm/bpf_oom.c b/mm/bpf_oom.c
> >> >> new file mode 100644
> >> >> index 000000000000..47633046819c
> >> >> --- /dev/null
> >> >> +++ b/mm/bpf_oom.c
> >> >> @@ -0,0 +1,157 @@
> >> >> +// SPDX-License-Identifier: GPL-2.0-or-later
> >> >> +/*
> >> >> + * BPF-driven OOM killer customization
> >> >> + *
> >> >> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
> >> >> + */
> >> >> +
> >> >> +#include <linux/bpf.h>
> >> >> +#include <linux/oom.h>
> >> >> +#include <linux/bpf_oom.h>
> >> >> +#include <linux/srcu.h>
> >> >> +
> >> >> +DEFINE_STATIC_SRCU(bpf_oom_srcu);
> >> >> +static DEFINE_SPINLOCK(bpf_oom_lock);
> >> >> +static LIST_HEAD(bpf_oom_handlers);
> >> >> +
> >> >> +struct bpf_oom {
> >> >
> >> > Perhaps bpf_oom_handler ? Then bpf_oom_ops->bpf_oom could be called
> >> > bpf_oom_ops->handler.
> >>
> >> I don't think it's a handler, it's more like a private part
> >> of bpf_oom_ops. Maybe bpf_oom_impl? Idk
> >
> > Yeah, we need to come up with some nomenclature and name these structs
> > accordingly. In my mind ops means a structure that contains only
> > operations, so current naming does not sit well but maybe that's just
> > me...
> >
> >>
> >> >
> >> >
> >> >> +       struct bpf_oom_ops *ops;
> >> >> +       struct list_head node;
> >> >> +       struct srcu_struct srcu;
> >> >> +};
> >> >> +
> >> >> +bool bpf_handle_oom(struct oom_control *oc)
> >> >> +{
> >> >> +       struct bpf_oom_ops *ops;
> >> >> +       struct bpf_oom *bpf_oom;
> >> >> +       int list_idx, idx, ret =3D 0;
> >> >> +
> >> >> +       oc->bpf_memory_freed =3D false;
> >> >> +
> >> >> +       list_idx =3D srcu_read_lock(&bpf_oom_srcu);
> >> >> +       list_for_each_entry_srcu(bpf_oom, &bpf_oom_handlers, node, =
false) {
> >> >> +               ops =3D READ_ONCE(bpf_oom->ops);
> >> >> +               if (!ops || !ops->handle_out_of_memory)
> >> >> +                       continue;
> >> >> +               idx =3D srcu_read_lock(&bpf_oom->srcu);
> >> >> +               oc->bpf_policy_name =3D ops->name[0] ? &ops->name[0=
] :
> >> >> +                       "bpf_defined_policy";
> >> >> +               ret =3D ops->handle_out_of_memory(oc);
> >> >> +               oc->bpf_policy_name =3D NULL;
> >> >> +               srcu_read_unlock(&bpf_oom->srcu, idx);
> >> >> +
> >> >> +               if (ret && oc->bpf_memory_freed)
> >> >
> >> > IIUC ret and oc->bpf_memory_freed seem to reflect the same state:
> >> > handler successfully freed some memory. Could you please clarify whe=
n
> >> > they differ?
> >>
> >> The idea here is to provide an additional safety measure:
> >> if the bpf program simple returns 1 without doing anything,
> >> the system won't deadlock.
> >>
> >> oc->bpf_memory_freed is set by the bpf_oom_kill_process() helper
> >> (and potentially some other helpers in the future, e.g.
> >> bpf_oom_rm_tmpfs_file()) and can't be modified by the bpf
> >> program directly.
> >
> > I see. Then maybe we use only oc->bpf_memory_freed and
> > handle_out_of_memory() does not return anything?
>
> Idk, I think it's neat to have an ability to pass to the in-kernel
> OOM killer even after killing a task.
> Also, I believe, bpf programs have to return an int anyway,
> so we can ignore it, but I don't necessary see the point.

Ok, so you want this parameter for the bpf oom-handler to say "even if
something got killed, proceed with the next oom-handler anyway?". I
can't think of a case when someone would do that... In any case, the
use for this return value should be clearly documented.

>

