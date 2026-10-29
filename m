Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52508606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 22:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b1vULQpE
Received: by kanga.kvack.org (Postfix)
	id 3A4FC6B05B2; Thu, 29 Oct 2026 18:01:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355256B05B3; Thu, 29 Oct 2026 18:01:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C596B05B4; Thu, 29 Oct 2026 18:01:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F00906B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:01:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 883D41A057F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:01:34 +0000 (UTC)
X-FDA: 85377036108.18.4F718B3
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9EBFDA000E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:01:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=b1vULQpE;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793311292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rWki7vE/miPR/Xe87Tbb6uEule/+hs/cjmC52gkJ2k4=;
	b=WwnKcvMbg3RD29/aYG8l8kVFKB5zl+CsJx2/KXNUcDF4eHa/bEl+VOH0dZ2DXPIPY8uUsl
	rt5HF/vsDwJaC2QqnTxTGgHB7XgIq/844SZM1Xm0CiC2Pa8PyJhBf6z7qok/apmR7E4GQs
	+Nhc8XPTVwbjdAFDgJgfxazxbVX3q2Q=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=b1vULQpE;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793311292;
	b=A6jpKjAYAuyJ9mazlKcbevotZUTdFL2Ew+/yDxlaWxjHU0gWKGJQAt2zVZfPFzt4bvMbtC
	PyQkRpwh/i9wQKfIJ4IpTOaYaghWO1B213BHYB4wlD2x1oQdxTUDaCY85JnrBEe13xgkoK
	V0t4BB7Ets9x39mNFRdPjTlHPCiNV4I=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6af8620a7d2so60946a12.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:01:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793311291; cv=none;
        d=google.com; s=arc-20260327;
        b=Kwub1UqOjYY7yNqqLfxu+fzZ0W1DE20pcooGDQdCYthbA5YlB9KGjgkiD1xikdRl6z
         mQEC/DwFS+CfCGsAsusg7OqvF9J+3P7zMkoZg2f2cF10c0bSbVE9oHl+ovC6nLlWCyTu
         Q3XwhVMvrOGDyLOztGVmnAamXw9ANzRPuJbdBnDW9n0PPsUJ9hBA9bY2QTvIkRfnS2uA
         ESu9pTFebBkyhe0ScdZimiDK0c32OMix5UMZFBmKIgdfQlGGQ7pq5aQf3G2HK8HZAAqO
         R4lY4Bw8Cb4febSA28TvqVuLF6QNRL1KbC5YXsLq06GLEwQ70H3bhRfqHbJIedwW4QIK
         f4YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rWki7vE/miPR/Xe87Tbb6uEule/+hs/cjmC52gkJ2k4=;
        fh=WrlUaqad4jxXKwX9u5lIheEjo4aiG1ojfPxQ2jrwWBA=;
        b=kWWaNV93UmjgJYcsAaMHwaFl/hs7KtZ6uf/pxyFpfbWRYawXwfaWKJr6OklzyKKYc3
         2R/LB4RM7ER4cyj9oC4tHZSbzVo8t6m0Z41avpQ+J8JGvtlBLaLdRgDZjA0vXkGq2obq
         eDv1O+fPOhVj6KtHUmv3S9NPjGZeY7WT6dOdk+A29qaJ2HQpVZ5Rxfc9QAoiRBgSpsFI
         xx1cSLYzbKBe7+sPWUcl8aCR1dxfB6Tc3ElDAWqsfFrfSNmnkDSlBBuBCKBf9YFXnyPR
         aBYq4H9A/SvhioWQxo/p9S0lNGHDmSt6ALf4LTPv3WtjNgeIgIqGLrr56uaFGMmo5MIg
         nwQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793311291; x=1793916091; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rWki7vE/miPR/Xe87Tbb6uEule/+hs/cjmC52gkJ2k4=;
        b=b1vULQpEideWXdEv57tnfrJOFc/mLUOvxXwByaFXDWdWkTK5GFoTYGiSLj0NgYtl2R
         5EF1q0XQ7KJ3y/L4Rtyd0S5aVsmZLOlcVIb2tdZ2yr9dOVLetBoJT2BUg2isRMnCHcOm
         OvXQBAc5RI5rdo/uHu6Th2hC4DCE11qSpQ21ZHa5LiolwNgYVohEqMJmFWCbHh6drUJH
         ummAdZmp5CNpSXcY1448z5DZUw+16H12AWCmjbXF0zJKJa0lxTv0bqRYL9kiAyV9fa2J
         UBrIfuQt0MLuA3RnGVwPhHlvOXW5JGnFASNeZPuxYaWg+L10TBXlYlcvh70eMjZkDBZP
         6frw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793311291; x=1793916091;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rWki7vE/miPR/Xe87Tbb6uEule/+hs/cjmC52gkJ2k4=;
        b=wftxPCop5yFKio9DmrjJjg/lTSFLkYUmX21q7fEJhgA456R8FprEaCF5rK02PmSk/H
         nfUnWPv166tX9hoCifJoQE5yDwAma8z8ltIY9DsxEAAmUpGoZOzjqng1e+3HzuFeoxoP
         aqDO7nVVc47mbhXTNeHikjmf/ntwPIJBlDLrkNfjMrKfTA2IlL5RBC0ybwk5jlDx5Jpj
         pzWkV0MoRV0edB1LQG6A6rDKgzAJsfQh0HeUykcspBLAStjW01xMsMp9l5WL0TmoM8dE
         ShnRWpF/15lCKSRDNfHZjTv5DDuShKruWyYU/aBFRe98Goc8YASK7vqX9XnayVIZa8Bl
         nEAg==
X-Forwarded-Encrypted: i=1; AKwUvBxEgikC3M8amdHKnAamCfCGV4vxS8IVXyUrsaKiX5pMPaH1sE7GLLPjKYJLAlejHWC+LcW9TZpsxA==@kvack.org
X-Gm-Message-State: AFq9FYJnqUAjSJrA2W5m7xY01s7GjfEKf/eaI0DHQIXmZxXbwlxK0jKl
	RrPid0ZG8JqSU0myHp+qgvDFBs2LFUMEHGThnMrvUY+AW1njvIDaRXvfKX2J85ud8gSH5coVdS5
	PvpIGlwcmczZKJ1gt/Yab3p46iFtiglA=
X-Gm-Gg: AYBFou0MQav/R+vNn6zyNeG/xJw1+3dgp7YJqq3tKiNcDYl9gWnN/HR4MvsGq/N9QBF
	JiTjiJDNjeUUjEgKxTXFMciTYNDmVyXMZDeSrk1MWNSaxPQwToBLt13U8bgTsw+kL/5A4rQl/Zr
	9npGgFzMdbW+uVEbS/NfERxPI3RxI3tl4+oQLj7UUb58v+P79wRNo6qBVW+KuvQBT3XhhRPaKiT
	H7yzxmSmlcfdT8TzJo2RlAaVqAriXG1mLhHgSyWTO5NESeOgNOg1BJp3qURsTkzf4FYXt8mvCmU
	bOw0N2MR9efbLyRPMbNQC/CFU6tONIgfmTBHz3db4Linffd1b3WHteVHATfb5CE0S9RxBwOL4lx
	pDzu93+8Ebitk7ZqLXP0obA8ZVgUFQWAZghOD/q0FSbQ1ShkavPS658Q51hq+u28Dr7QNRFITW7
	J0oCZUQ/+SFoAiPpssg4SHsHoEdqErLwnLsQ==
X-Received: by 2002:a17:906:ef0b:b0:c46:b9b0:8e8f with SMTP id
 a640c23a62f3a-c4ca7a9d96emr36300066b.41.1793311290809; Thu, 29 Oct 2026
 15:01:30 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261029212551.56964-1-jolsa@kernel.org> <20261029212551.56964-3-jolsa@kernel.org>
In-Reply-To: <20261029212551.56964-3-jolsa@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 29 Oct 2026 15:00:50 -0700
X-Gm-Features: AclHuK-kOUOtQ-G-FVVktnJEDJ8Q5GaaNL0lIdZEWjSEGoZpsRYH87xNkw7hKcw
Message-ID: <CAEf4BzaAbWxWfjn4u8vieaWzhjE+Af+KV8sLFH9kfgGT5PtAGw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/8] bpf: Add user memory kfuncs
To: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Federico Di Pierro <nierro92@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9EBFDA000E
X-Stat-Signature: uy4abshcatbwmq4ipp3jkbskrpzxbipf
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793311292-444391
X-HE-Meta: U2FsdGVkX1+p1ZaZ0FeFQn9j6rguSyB2qWj4L2mJLmN+13OS1VKhEYb/aYLisqKVwebcDPR0z/9hGHxH3fr3tIwt+yJ+7xbMY7zqC7JC3BcNWH0TZGNcpqYfvMIkouYbSRU1l03fNhivtOquLQvhGIGs4o/J92zPMATfx8qJGhoAHLOCCehtPAGoO5gpvg5rf6CJj9w7jdDsjWnRpk/oHcnySg/OssB9Tt5ZG55yfKIUl66leHcDf3g9oVliKKHL5z79Dsi0zQPF4D9LIcon3kGuT8aJbyOEKNmPRV4bvaGpUSPji30Xq915BamTb4KLSwW87e1nrf9BGPcQjnAYruLsyMGfPNgLF/vQ6KbHe1zQkv55ujstGV/X+BBOfuzvwkz0c5i6ha/+Q/T621fLJ4BKD33LLByaoqWK2rHZK7X2NoxbkZ98yUqPwWIrkLfqqdBOv3PWw0f5x62ttJfPmw2cEYqjTlZekx6Y3LCgJiKetbmaWlhVAhHMSQHWAUNdYl5FYS/3077rVmlHrebKHTJjbZ+m4ONVM+xLE39NvVUIEkicZjGJHLlDcGYeeLnsk1vd43erQS1zH9H9AxvwjYIS6LNBONWGYNZIqunPEaO2Ykp03jeiyqDitJiGj4yP6w2r33XOfkyWRcGiwQK47q6HbliDN4/AXwhGBNjVBF8+3ijHHvWucaqQBMZHPkk2IlCCUOPg294YF9A0KzAkZXdttfLJ9TS+frMnxRLq32xcBeC37V+Mn9QmH44LptpYM2PeCVwBBb9GzE6I1z47T35Ho+XLb2JnrZZyZg61J6URtiuLt3E0tUIEaC3/tQhf/Bc5T+yjn0Pb7i/PvJEzKPjzBncO+STbb60tQF8bdPZAMjHu81jkLejVn9johCriVcgiccF/hS3Ak1FAksbCl/5R1WZLPJXHzDTH6gezKmZww4jcsqWhC4EpT9H3hFASKL9KzmOG6UUR1M2hug3
 Mk3dLqFu
 gXzVotM0XjLfoPRdKExD/nNN0KWuza3u662C1ilLql/kfHOD+tvMUHjjArW3MfATuQR/CgXi0Pd4xxoeJfn3l565n610yVJdSQpz2psNg4C3iPIaNPRGvUgiMyQ7BbsoBGpMvfulx8lA487IZ5Ax5smJG8p/DLJSqSZSx/Ht2OHuGStB9E1VyhnvA7tWgcgJkobUUgHapVpAAGmQPySzV7033iB62hnfLlJjKPOxmwR0O0/2Pg0iKxD7yJI0qCF5Mb1wszlpc78mBFrfA3Z+ndGOkZBnsh+tfbx0uPUO9GKYtDjSnP20Y8SNaa2GApE60CfZD3eI2jqBhfOxkm5VG5r9fxT+lsoD/c0pQiJboCTmgEv/UW55AkukDZfDydMSboNzWeGSUTqjLn0CocxS2ShzX4NWEkqSpsJiwiywdAtFxZvTyOfAZ3aILb7RgkQGTQelZZ3MH8DPoSF3XTLGQcNNPgpmesafjOWy+1Hv/cj6qYuPUHdgilFaktw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 2:26=E2=80=AFPM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Add sleepable kfuncs to copy data into a task's address space and to map
> or unmap private anonymous memory in the current process.
>
> Require a usable user mm for mmap and munmap. Register the kfuncs for
> KPROBE programs and gate them on CAP_SYS_ADMIN BPF token capability and
> the BPF_WRITE_USER lockdown check.
>
> Use FOLL_FORCE | FOLL_WRITE for task memory copies and return -EFAULT
> when a copy is incomplete.
>
> Rename the syscall info-copy helper to bpf_copy_to_user_buf to avoid
> the name collision.
>
> Assisted-by: Codex:GPT-6
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/helpers.c | 102 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c |  10 ++---
>  2 files changed, 107 insertions(+), 5 deletions(-)
>

[...]

> +/**
> + * bpf_user_mmap() - Map private anonymous memory into the current proce=
ss
> + * @len:  Length of the mapping
> + * @prot: PROT_* flags of mmap(2), including PROT_EXEC
> + *
> + * This maps memory by calling vm_mmap() directly. It does not invoke th=
e
> + * mmap(2) syscall, so seccomp filters do not mediate this mapping.
> + *
> + * Return: The address of the mapping on success, -EPERM if the caller h=
as no
> + * user mm, or an unsigned-long encoded negative error code, as returned=
 by
> + * vm_mmap().
> + */
> +__bpf_kfunc unsigned long bpf_user_mmap(unsigned long len, unsigned long=
 prot)

bpf_user_anon_mmap(), so we can conceivably have a more generic
bpf_user_mmap(struct file*, ...) in the future?

> +{
> +       if (!bpf_user_mm_ok())
> +               return -EPERM;
> +       return vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0=
);
> +}
> +

[...]

