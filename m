Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6006A606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UFA23sne
Received: by kanga.kvack.org (Postfix)
	id 615B56B05B2; Thu,  5 Nov 2026 19:34:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5906B05B3; Thu,  5 Nov 2026 19:34:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5816B05B4; Thu,  5 Nov 2026 19:34:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 207F06B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:34:56 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 159E9C0AA5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:34:55 +0000 (UTC)
X-FDA: 85402824150.29.709FA20
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1BF3A4000E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:34:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UFA23sne;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02QAP4BRChAM3iykURm2Ztmkd6pLWewsJZlk3WHtQgM=;
	b=aFU38OVONnhS5F8CN1u8iV/TtGoOLYRJPg+LRS7wHv71+OqbQpRNIyV/V+0LpIdiFmizaa
	I6ZLuyYjk2TrEonxnhB1cVhgv1MGCs2z1LKVpd2YQ4cwSBrEL8Vw+3ad2lm4ems/0HTfCW
	SYSlyiBLDj3pwUkoJj4Yt1dqFY0Opuo=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UFA23sne;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793925293;
	b=fxQZ/oUJJHoOU9qAP70VhWVF16sIzBk9uEtVwe2JhlrVvd/tIxXixeKUu+Vsr0ryMJ5Wk6
	9Igykvi521xo/orOtC2p56SIl/NcNwf6GrItUqAZtDurcMq6cRDN+oTw6OjrLsivWMA+Ij
	BhVoPYix/0ijFz3Gy7rp1pee8uk8uIk=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ed3d8877e6so410815ad.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:34:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793925292; cv=none;
        d=google.com; s=arc-20260327;
        b=kpN9RsLUCFo7CEdnh6RAeuh69dnFMXbPW7QuEYABk9wblASoEGltV9RASE08d4qaEn
         +gTYrXeG15F0Fj1YNrOW/s/wXgUWYnqcAr6s11hn6ZDTt+gTDQiVt5GsGd2+QQ/5ZZ+I
         3TTYBpEsV5fALybT3nNlxQ1ix3WTYXmT8U7jH2A7LOZJhd7c5BC4Fy/EBwnTyfFfBsRO
         1i0WtGB9ZsOVTFR0xsOBOMK/u+f/A7tnliT1aJdxky0NsvceVHJOWMky4dRq6hOkaKG3
         8YJ7XwU+S7Tig5WesnrnjK2o5eCgl1JNxA9ZSg+ajHSj89fzorSP+/4HEVPmwb2bGirH
         VxhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=02QAP4BRChAM3iykURm2Ztmkd6pLWewsJZlk3WHtQgM=;
        fh=e2p4+HzfzEFgRimQmjzZlIHPN+WYopyKq48Te2JSlNE=;
        b=nPVG0QQS5rhOj/HPYkT+3mlkO5pRaUyICCIfoatujwAyGyjpf+5Ok7I6h/nnBOaqkD
         drPDYL5YjIbuhFi9/Nv5ZBeiNiXanHmjv2c21oT87/oVfQA/sFp3dzQaGWPUCwgimjDO
         FABiO3cEtf3qkVbiWoIWoX595ClOI175A+/yYO2c4HBaBFOG5R3cbwD3wG/hgD1azLPE
         rrB8l4gSY+kCsQl8tawvsfMQwZybNY2KqohQoLlsVpX9msXpJiKqxuRd8bArxqp8hgYb
         BPk1RleY7ecXAxou1wuleBRAdc7trzNENbVKt0Aha/QbY7gi7/lhdqaniT7ECFI85jdO
         ZSqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793925292; x=1794530092; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=02QAP4BRChAM3iykURm2Ztmkd6pLWewsJZlk3WHtQgM=;
        b=UFA23sneEvrDb5o+QZeAaL0OOYNwqZbi9VvcEiQfBYLKK8eqFhWb+ALEJZP8W4Y+DQ
         wD+li4Lqpw7xQ07zNYf+GGmUCd2fQDYlJI5LZ0Z0VVvZpfasZjJMoQyjtyxBd5c/kC5Y
         Oy/mv0MO51KjpdcKqNzXoaBtMSU6QCyxQfy//6CzWcHlewmbrPzf6MmC4MiFPiS0wNiv
         OSEA8V4dg6vwVX0zNJ+DeN+/MOXOP5xx4lY/MVWduqRGrPZoJ/XCltl0KgmKA7PTHe5M
         8IWrXn7F8GxTAWfaWEUKlPar9cvhbPZnf70WAnJVkVNg82W1qcP+l5MMdxYQ4j037a/2
         c6ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925292; x=1794530092;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=02QAP4BRChAM3iykURm2Ztmkd6pLWewsJZlk3WHtQgM=;
        b=aS1r7prFr5RcTR2jxkUtnpFHx/RRzz0L4Rls3uEKW9Ga93O8wt2ZTOkY5x5TJMnFjz
         Vn41XMt4TWWRGzX6hM0tXBnKP/BfP6uzmyaDwUjMLNIfiy0KpN+40VSy7RR+dmyenRou
         K3x8YbBpMBv94SBXBjedTsvdNErD56Q3WVL1xynr7eSE8MQ/cw0eBlKtxZw7g3Pbromy
         Zk+hs6iFL4jySlFBBn4tD6XtRltjdP2Iasuy5PFVlon6oelpEVPvvnryC5B9XOC6pg5J
         QfvEmmir170kAN6gyLiAKzHPIIxjgYv9A9Ncq8tfJD1UqJK1PESEQH4r5yWHg5G5IgNm
         p3Sg==
X-Forwarded-Encrypted: i=1; AKwUvByGZXignOORSMOCyQriCCR44qQ93AKNYgU8q9a6F/QUQnuioeeq7ZmSgklJccTWulxekMpZom628g==@kvack.org
X-Gm-Message-State: APuU4Z/jSYWUGb/BofBRp6CI18f+W8BEHGOc+KgJ0NewLLpJo7qdkgEd
	bD5CoOvaRb8dj34/ZydXBcTSKZmQkcc/j72gv8iM/XGjejwWwZl/6AacS+X0+BcbY8+yickrd0c
	+7qpS+PnAPVweVxNs8zrbM1wrvPUn3HM=
X-Gm-Gg: AYBFou0uXj3zviQE31o6mI49NsceySPy6YSy6skezg5DqxDRWpXv8IQB9tmECL5Kh7g
	gTmUmr4voGwCaeugv0XaypSpQA7++LbyU5mYt+mbcadsGNwl5ooF+pw8LD8UtCDGDNMsI6tDbCm
	gXTxHUuqNl7ZPm05XUD3uHDRptU3V58vfioCE50EUks+clmX5JoLtgctkCOahdZOhNXEc1to9+2
	46jL24M8uTx62edRSzpXAVUvwsTYFI2rVP3XMgXQO/0YePp/hZF2O3po/S0XEyuUvtHvMm/Sthh
	kQPebimWn42A/WiqKYWH+ukrU4bTVMGzt5q1igkAV2VX+6OkNd+YBmBUU4ubVibUNFz028PByaU
	A5vqHVWCuvcQMiSEPoRSVmK3kp0kX0vilwLSKcAH5C0ANau1+wfE+Z7BQGShDwoj/+cuEh9tjc5
	O67Wj5Tkz6De5jOhA9uUOefAN0TwUx4p3wLA==
X-Received: by 2002:a17:903:2b05:b0:2ed:3f47:9696 with SMTP id
 d9443c01a7336-2ed40c7b5bcmr13899535ad.35.1793925291850; Thu, 05 Nov 2026
 16:34:51 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105102343.311331-1-jolsa@kernel.org> <20261105102343.311331-3-jolsa@kernel.org>
In-Reply-To: <20261105102343.311331-3-jolsa@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 5 Nov 2026 16:34:40 -0800
X-Gm-Features: AclHuK8eP4aP7e5aZ3VTvmtBXE3vHsFqbDq4B6KK4YEagZrzajw2VXUziTJJzRM
Message-ID: <CAEf4BzY+1a8v8AHcr1AfUBR24uMitU7gEe2_1Npwp-8_kagU3w@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 2/8] bpf: Add user memory kfuncs
To: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Federico Di Pierro <nierro92@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1BF3A4000E
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: mjxr5xkh1n53po8su8t75cwxdzskphx6
X-HE-Tag: 1793925292-942461
X-HE-Meta: U2FsdGVkX1+AFVklOplpAg6rKRYJDVH6CDC+8L6JRqyhU2ELMj7iY2BIxqotMBWSeiHZ71Uf2m91XYvonLQVptk7vzw5Tnc/WH1pdWjQO93vnPGzsdyD27s2QocTqtxpAwIuDFgX9xT6Nn9p4sM4jJc5vQzAY9lvqnq+qjydZ3CuJiTu9y1vxJzKhzfSlSQbpOm2aKPFfR2qYuqjOSvmESpBX8FUG3gGOGFRFB81etHzpFZNXpSH50XKMaV+xxZ3iSBYWzsTEB9zBXzIXL5zpmFZLE2I7Hb6nE5V1UJJvycyN34J1zoQYcD5WU5dnZ2vnSOSqrUVswpI6qSH+dtnwb5Y11+vXydvizpWD7193Sul5nAEc5K+xNa4YuMMrc8XdM+nH1gASfA97H6HUc4ZULqq1SGQW41MckL+Lrxe5D8r52WX9G+giRWIZGcwZ/IZwzcMPOBzoGJhZQ8uHrRxl9VcYu0Ep3wWew4/5REnycX6mHMTLFTfJV2H2vmsSjPuNK4BFu4t5WUcOpldjEYnTLyTjXe7XNXrLofCNzJGkZVFmAfaVpXaXURoicgNbUi06NskwLlaXPg6PEnNh5m5VNVWUg9uOQwqqDyQXYlIHs8roxw3A4UZdHqiVs2qdR7ToEo570Gl9Xn3K64m4byiRaOvcuLKY3VwgxrGKpHpol+jtY0p6ukiqt6bv52izzR8tFiosZoml/qMtmwNgbDmuNJGw9qN3inUGGczv1WZA9sP14qW5vQ/mIrNxJ0w5c7uuwos+m2W4Todr2UIlq8DnDmyucXAumdu+QSqfC3j9YTN8X1l6uwI42dM12DH0Ot9swJqcFNeOIA3oPqPds7nlhVp7soxD3Ui9d8X1fNqzk3l9ZfPoxcnLG0w00vPXdwbWAO/Czffls2HNeTv90iSnXH2M0gRqcEkDJ63DcY7iLvAytjVwpkFaeLayEXL2mHfs3Zqpj3juh563vDnXrB
 GKuapCj+
 nzhRmr8oQARxRH08UrTvZXn863xgWgqZaKlEJy2W5C0cuVTBPoXpLT/6KhjbdmLzw3gSY5RpHd7S+OTIe+dwtseoABCgplp8+ycu+8zXe/SpWkGAHCLW9EfRx7rOM9kDdwwNSSe/9kCq+VAl9Gkftb9RXzfnAuukdqB3Ci5GMGAL1/ctFlpksE34yM5K7eIfTLRy6njAlHeNzNOJ45jF1gXbGBXQW7LTrsqlkCyXgZm0gThvMVsp4HYFCq4pL9t38APPgzdhlTXr+52CdixBSZlW36o/CvhJxDQgoKI/+VeZ2EpDjuYrLcXiCTYo6SwszhfO9QHmO9VytwwhRWhS4S+eK7l8sIm8ek6pqryDsCnDSYJnXpao2etbpjwszUewhnvkVzw/Ftupg0p8vWvJbCjgsSgxhxVktt1cvMKP/LRMvhs/xPlPxoFbwNMcghLd1K3b/qoFWpaDW9ahcKpN142tqZw1iTXcdUw0dz9BueNs3ed1ccwsEAMPHJ5Invhhn++8YrjG6wf6H0v7g093G9xUtQo3//dwatCl+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 2:24=E2=80=AFAM Jiri Olsa <jolsa@kernel.org> wrote:
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
>  Documentation/bpf/kfuncs.rst |  17 ++++++
>  kernel/bpf/helpers.c         | 107 +++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c         |  10 ++--
>  3 files changed, 129 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
> index 4f8dd7c1d785..81686d556f58 100644
> --- a/Documentation/bpf/kfuncs.rst
> +++ b/Documentation/bpf/kfuncs.rst
> @@ -976,3 +976,20 @@ the verifier. bpf_cgroup_ancestor() can be used as f=
ollows:
>  BPF provides a set of kfuncs that can be used to query, allocate, mutate=
, and
>  destroy struct cpumask * objects. Please refer to :ref:`cpumasks-header-=
label`
>  for more details.
> +
> +4.4 User memory kfuncs
> +----------------------
> +
> +The user memory kfuncs operate on the current process's address space.
> +``bpf_copy_to_user()`` writes to this address space, including private m=
appings
> +that are not writable. A partial copy is not rolled back if it faults.
> +
> +``bpf_user_anon_mmap()`` and ``bpf_user_munmap()`` create and remove map=
pings
> +by calling the kernel's mapping functions directly rather than issuing
> +``mmap(2)`` or ``munmap(2)`` syscalls. As a result, seccomp filters do n=
ot
> +mediate these mapping operations. A seccomp filter can still allow or de=
ny the
> +syscall that triggers a BPF program, but it cannot separately filter the
> +mapping performed by these kfuncs.
> +
> +.. kernel-doc:: kernel/bpf/helpers.c
> +   :identifiers: bpf_copy_to_user bpf_user_anon_mmap bpf_user_munmap
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 6788489a2608..937a0d7d6839 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -29,6 +29,9 @@
>  #include <linux/task_work.h>
>  #include <linux/irq_work.h>
>  #include <linux/buildid.h>
> +#include <linux/mm.h>
> +#include <linux/mman.h>
> +#include <linux/limits.h>
>
>  #include "../../lib/kstrtox.h"
>
> @@ -3768,6 +3771,88 @@ __bpf_kfunc int bpf_copy_from_user_mm(void *dst, u=
32 dst__sz,
>         return ret;
>  }
>
> +/**
> + * bpf_copy_to_user() - Copy data to the current task's address space
> + * @unsafe_ptr__ign: Destination address in the current task's address s=
pace
> + * @src:     Source address, in kernel space
> + * @src__sz: Number of bytes to copy
> + * @flags:   Reserved for future use; must be zero
> + *
> + * Faults in the destination and writes the way ptrace(PTRACE_POKETEXT) =
does:
> + * a private mapping doesn't have to be writable. A partial copy is not =
undone,
> + * the bytes before the fault stay written.
> + *
> + * The caller must coordinate with other threads so they do not execute =
the
> + * destination range while it is being modified, and ensure execution be=
gins
> + * only after the copy completes.
> + *
> + * Return: 0 on success, -EINVAL if @flags is non-zero, or -EFAULT if th=
e copy
> + * fails or is partial.
> + */
> +__bpf_kfunc int bpf_copy_to_user(void __user *unsafe_ptr__ign, const voi=
d *src,
> +                                u32 src__sz, u64 flags)

you'll eventually want bpf_copy_to_user_dynptr (we already have
bpf_copy_from_user_dynptr), so might as well add it from the get go?

> +{
> +       int ret;
> +
> +       if (unlikely(flags))
> +               return -EINVAL;
> +       if (unlikely(src__sz > S32_MAX))
> +               return -EINVAL;
> +       if (unlikely(!src__sz))
> +               return 0;
> +       ret =3D access_process_vm(current, (unsigned long)unsafe_ptr__ign=
, (void *)src,
> +                               src__sz, FOLL_FORCE | FOLL_WRITE);
> +       return ret =3D=3D src__sz ? 0 : -EFAULT;
> +}
> +

[...]

