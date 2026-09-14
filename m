Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ADF6C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 18:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6E86B008C; Mon, 14 Sep 2026 14:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D626B0093; Mon, 14 Sep 2026 14:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66C9B6B0098; Mon, 14 Sep 2026 14:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 454886B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:17:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B50591C1A2C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:17:14 +0000 (UTC)
X-FDA: 85213174788.19.A038885
Received: from mail-ed2-f11.google.com (mail-ed2-f11.google.com [74.125.228.75])
	by imf18.hostedemail.com (Postfix) with ESMTP id CF6B71C0009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:17:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ICL1ZzYL;
	spf=pass (imf18.hostedemail.com: domain of memxor@gmail.com designates 74.125.228.75 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789409832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhwZKQH3naP48pBWrsTvWrJs+Fp5fgGMTIobqvnavu8=;
	b=QPTNkF3m3UYHORROQv13ZikYSe5XFGbmV5MdtHMbkD5/WGbZ38/UWIoxjWjt3kyZFvO0yJ
	hoQr8gxQ/iYBCiZ9YfKXYmtglftr8tHyMsQL3IfRm3GbMiQXQoI7/UKjcVUxzgPFhaYlbA
	1KphC8Rx2WElusdQ2rI6Cr6iMgV+Wdo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789409832;
	b=wHMZYAh02aVnOhsCY3rAbTt31KVcPmj7J5frZAIPNYc/r0PqooyZsuxVXqm/8GuzZqQp1f
	KuSHpUp1kiAq51+rY9d3etJ/TsIFLiqKHf4zxO/6zC4+ApFcScxd5nokMXtq+t4lcmfAQ3
	4tvWQrgdl7NCMcAyXq2H7PyoaacpZAg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ICL1ZzYL;
	spf=pass (imf18.hostedemail.com: domain of memxor@gmail.com designates 74.125.228.75 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed2-f11.google.com with SMTP id 4fb4d7f45d1cf-6a144c8f038so2237575a12.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789409831; x=1790014631; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MhwZKQH3naP48pBWrsTvWrJs+Fp5fgGMTIobqvnavu8=;
        b=ICL1ZzYL6sehuSeSDa8W68ixTU72p51lSMrhvFWIu7zbUd+viMdqXc7ir6pvLLjDf/
         HBeZuttCJn+cbc6Vd+Q1vh30ONXwDlHDts9XkKqKdY3E6PQhDu5Hf/hWeEZzqtPwuPv5
         Ku5eSTu1bnr7KPW74gSOVFpjzvq2axAPAEzIZzhLjAX/vXRZSJPU4GCPPK0XATiS91BM
         2XrXQ+Oh/ko0DURKiwaUDVwV6ALU/XfgjEgybvfDB3/cgPGS4g/MMx8Hp9UVGQLSSu7W
         JXlqWJy3EZyesPD1lEjuPESNklg6j2Ij9MTk/VzztXGVTbB0kuqC7CzxXNgIhEO9xV+b
         39Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789409831; x=1790014631;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MhwZKQH3naP48pBWrsTvWrJs+Fp5fgGMTIobqvnavu8=;
        b=Dt0vj/lwnYRHceCWv/nB5BKGswFTBrxzulbRz9ue+uEjH9SWOqJV/hV+eJsCbN0j/e
         mOK2by6i/HJO3j1A0JjD1L7V6iM41upN9nLNPGFkqaOCUr4OHWmXq+YKIayRTwY5u1XI
         7eLCRQXsDjjbqZ9x4GnchA7iJNNOvOU5GPKuRd2tVCw0Ab9SSrv2QdRB0wqqzFXTVMes
         j2E8pr2zwlxLo5vVRwZUnlGq8hUhMfAfTzUJnb2ds+CMh5I2qzN7/las02YB1iEt1PaS
         cORq+Cqq220ibagb7jfMZHWGoBDPBeSz4a0ZOFjarVXnhiLLAcStXpTWsMDchdAEZJQl
         50Pg==
X-Forwarded-Encrypted: i=1; AKwUvBwFpcZ9Uw7xOzGOmigbD7coldo5jkJeNpB6CSC+Z+C0ReGo4nduZmk7JfztnVFdR+pnOMM4D2ydIQ==@kvack.org
X-Gm-Message-State: AFuF++lQ0z3N10qwjsr628TYkCkskWiFS9od0NrBTV5xzWAUJS9PBxyf
	wFF8H+xuRz0peUYjGFWglhGtrzpxesy2r38Oau8E92x3KtI+Y/tjOExG
X-Gm-Gg: AYBFou1bfpvwms/5B0/e1y6fy55EEX+2DTP8qM3R1fO4HJ53CW1MKpUE1szj2fKNd6u
	Bi7/i1Y00bKTlEuAnr2IaWNiNRA5WVOod+I8gdK+pF3atNFGQIO5rEGQf2Gu+5EoeMlzwjkxLN7
	KCFzAlNGbL+zq+BBK6yFj2WdsE9Kxzy/vJitTxUdbXP4blEQyP+HJ3APDrikYET7jZNQqRMMB3I
	r4XlR7ylevUvV4lBbjgMX610DC5AaJtTFaCuAH21ohuDY8Fu057vZs52w4qEklS4avN0K6XR3m7
	1f185C3Vh4GZzJLWZNgOTr43IBfswQv4lg59HwWzzNyd4Q+lGJIkzJNTet6+dGzKio+qe1PNRy3
	qi5NTdu/uPwrqW17+XQqKK7KisfME+0xlpZGbupMZT/nFq2xgW/5Hb7Ia+w9pLjNwiUzQP7o6t2
	aj5myiX5Oz6YNOx/h4hTBQwkgUQdCY4wIo4A8+bXYIuSv60SXMiOPCgZVhPmUZ+bJLXcUfqUePX
	8+77dQuH70wwt1IIzmgH8mCPfmvGuR1BHoltwxiV4uTLFsj3y4Izcwkwmeb+0FfUiuFZ6Lwsud8
	wWKnF+TwQghdennt61ktbxj37YkpPwt/s+lPtw==
X-Received: by 2002:a05:6402:4149:b0:6a6:c4b:c92f with SMTP id 4fb4d7f45d1cf-6a9f6227feamr2295917a12.9.1789409830894;
        Mon, 14 Sep 2026 11:17:10 -0700 (PDT)
Received: from localhost (nat-icclus-192-26-29-3.epfl.ch. [192.26.29.3])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9ba8f3ab9sm4370429a12.15.2026.09.14.11.17.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 11:17:10 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 14 Sep 2026 20:17:09 +0200
Message-Id: <DLF8UFBL6NEL.MAD9F5418DIG@gmail.com>
Cc: "Hui Zhu" <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v10 1/2] mm/bpf: Add bpf_proactive_reclaim
 kfunc
From: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: "Hui Zhu" <hui.zhu@linux.dev>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "JP Kobryn" <inwardvessel@gmail.com>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Ihor Solodrai" <ihor.solodrai@linux.dev>,
 "Alexei Starovoitov" <ast@kernel.org>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Song
 Liu" <song@kernel.org>, "Yonghong Song" <yonghong.song@linux.dev>, "Jiri
 Olsa" <jolsa@kernel.org>, "Emil Tsalapatis" <emil@etsalapatis.com>, "Shuah
 Khan" <shuah@kernel.org>, "Barry Song" <baohua@kernel.org>, "Geliang Tang"
 <geliang@kernel.org>, <linux-kernel@vger.kernel.org>,
 <bpf@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <cover.1789091855.git.zhuhui@kylinos.cn>
 <e00910f328c129fea716e9fd031dada328e60313.1789091855.git.zhuhui@kylinos.cn>
In-Reply-To: <e00910f328c129fea716e9fd031dada328e60313.1789091855.git.zhuhui@kylinos.cn>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ob5uwsuukfp9rz75enfpc9p8buyff6mw
X-Rspamd-Queue-Id: CF6B71C0009
X-HE-Tag: 1789409832-627171
X-HE-Meta: U2FsdGVkX18BNtIkSbzuHt8NTHBvHgBB+J33UJ0jP6enup1j2nJj4xunOBwlvDbBN4BXIWfOfIR77P3Zv5yCbmJTxWpKpXaDMhFGH5Bo07Fc8waoboncphiPA7gwJ4JSJD9PaBWhWcavMJgsg/ya4HgVdQl5l9vFa3/dvW63CYE3i20cEH938tKydk5d66ZgOmKUetGOiHi//hurSdJixqUOsRSX0GW6mqQVdXmPgpAIDGi3e0TfA2tptBj9g9NUrouXlvhSqBF/vWKL1EUxLI3bh8mBWFDQIObEJh+C6A3Fe4SvpVgg640jYpVM21G/EhSA1QdIQ5Ui8hdmcHDAwZUSRx8oAqcAX5a31Hx/AIe9jbdo0Fuy4HlfCtyIS003ntLJixEFVirO8NgrPpRpQGu4PsVaK1A7jwOxLvA1+CgZPwIgF6KzLSi1p9ITKUt0eUPwyEQ0CX/REXlV/r3WuLkVlOjT6fMBaSXv8tBeThs91K+KQMgB/444HrwrVFM9eVmiql6pQz57HAsGO/ouD8VdHlGMDtU0VDPiqNpNgxlwekbFrv2Y2hjijQ0n8ZxENNn183TDf0pL0mF+gqTGx86gzhC23c66ya2UqYEiFJcuzLCPrA/0poyJOIGkh2DRIkNHrqa8hUn2dzKeu5wiMyGD44WRPjf/KumMoqrRlPdS3MiVBqXFqHrHjFLaAd6uX2FOYwdFUxpXHhU4h/ZI9k18b3EF/65klTym5H77p3nPiWQXTRpZNVsfkZFhE1MIB7YPVFEDLaGSewHflick/4w7eAHLxdR4ekpbCf0bZMIrCGjHu4/qoKCywiWDbtVhGpgtBAMlgeRUaVUVVjOASaHxo+Uvcq1kbLByMsCnWn56M0jwF0q+EMg976LGwfg5CYvFIbyVEcM9pxNbpiKQhR7oEFn9ChBjuWfs8XWwiGbFEGmhezmg2v7PviADEtCFaajME8NUaQzkXV2Cr3A
 G9tzqlCo
 1oOip3xjCsLkep/om72++A6xhKnJxPU/XCHP9DbspThp4gCME+XObho/wml/F39Zf3lPHX7GBbfbdgCNS2qAh7VedVIMqhY4RHyU129QnRLho6228nlDffJIZARSuKfCb6emOkXxgq8BJwYQ2FessgVf0TY26a+k6YeGdzSCZhDTmSTsbL0XFUEvk+JklCfJgNF+q4OFbvZPflHxptFZG+iYUAo0jiRfrOSXWWxuDrdG2igEGueA3GTLC7tzQagpD4UndMHIGLimnaPiINIrtbCb45nSVoo7i5uQOcTjn6C7tDYWZdDVZxgSzvCNINtz2vrFZo/WqeCUysOKo49IIKKfaJ+AMPuY9N4BVFWAgxt0RCM+IQQk0pZRnTf/0ZNOICUu6qPF0fvA7RREYGHHfjtCDOgnZFnLSyTtbOdEYqwBD5JcT5fCi3zBcCCv0UZGqUxlsdwVHW5RZToP/xbsAfUtTZfh7B60B/yCHldYo1bLtEN/DZxEO3b9zgu1nypLKpOKL7oMaVOt8/Rg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 11, 2026 at 4:20 AM CEST, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> BPF programs can observe memory pressure on a cgroup (e.g. refault
> stats via bpf_mem_cgroup_page_state()), but cannot act on it:
> triggering reclaim on a chosen cgroup requires writing to
> memory.reclaim, which BPF cannot do. Add bpf_proactive_reclaim(),
> a sleepable kfunc which performs one proactive reclaim pass on a
> given memory cgroup, similar to a write to memory.reclaim but
> without retrying until the target is reached, so that when and how
> hard to reclaim is BPF policy rather than hard-coded thresholds.
>
> Since some bpf program types may be invoked while holding fs locks,
> limit the kfunc to BPF_PROG_TYPE_SYSCALL only, to avoid deadlocking
> in filesystem shrinkers on the reclaim path. A SYSCALL program can
> invoke the kfunc directly, or asynchronously from its bpf_wq or
> task_work callbacks, which run in process context and keep the
> SYSCALL program type.
>
> The reclaim target of a single call is capped at MEMCG_CHARGE_BATCH,
> following the precedent of high_work_func(), the memory.high
> workqueue fallback. Note that only the reclaim target is capped: the
> actual scanning work and its duration are not bounded. Reclaiming more
> than one batch is left to the BPF program rather than enforced by the
> kfunc: with one call per bpf_wq callback and the same work item
> requeued for the next batch, the program can also stop submitting
> batches in between, e.g. once the target cgroup is dying.
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/bpf_memcontrol.c | 88 ++++++++++++++++++++++++++++++++++++++++++++-
>  mm/internal.h       | 10 +++---
>  2 files changed, 93 insertions(+), 5 deletions(-)
>
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..d8827bc388ef 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -8,6 +8,8 @@
>  #include <linux/memcontrol.h>
>  #include <linux/bpf.h>
>
> +#include "internal.h"
> +
>  __bpf_kfunc_start_defs();
>
>  /**
> @@ -159,6 +161,74 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct m=
em_cgroup *memcg)
>  	mem_cgroup_flush_stats(memcg);
>  }
>
> +/**
> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
> + *                         cgroup
> + * @memcg: the target memory cgroup to reclaim from
> + * @size:  the amount of memory to reclaim, in bytes, clamped to
> + *         MEMCG_CHARGE_BATCH (64 pages)
> + * @swappiness: the reclaim swappiness, in the range
> + *         [MIN_SWAPPINESS, SWAPPINESS_ANON_ONLY], where
> + *         SWAPPINESS_ANON_ONLY means anon-only reclaim, or -1 to use
> + *         the memcg's own swappiness
> + *
> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
> + * memory.reclaim, but without retrying until @size is reached.
> + *
> + * Only the reclaim target is capped: @size is clamped to
> + * MEMCG_CHARGE_BATCH, following the precedent of high_work_func(),
> + * the memory.high workqueue fallback, which bounds each reclaim
> + * request the same way. The actual scanning work and its duration
> + * are not bounded. To reclaim more, call this kfunc repeatedly
> + * instead of passing a larger @size.
> + *
> + * The kfunc can be called directly from a BPF_PROG_TYPE_SYSCALL
> + * program, synchronously in the context of the thread running the
> + * program, or from the bpf_wq and task_work callbacks of a SYSCALL
> + * program, which run in process context and keep the SYSCALL program
> + * type. It is registered for BPF_PROG_TYPE_SYSCALL only, because
> + * generic sleepable programs may run with filesystem locks held or
> + * in NOFS/NOIO contexts, where the reclaim path could deadlock on
> + * those locks via filesystem shrinkers.
> + *
> + * For asynchronous reclaim of more than one batch, driving the
> + * reclaim from a bpf_wq callback is recommended: call this kfunc
> + * once per callback and requeue the same work item for the next
> + * batch, instead of looping inside the callback and monopolizing a
> + * workqueue worker, and give each target memcg its own work item,
> + * as high_work_func() does with one work item per memcg. Whether
> + * to submit the next batch is up to the BPF program, which can stop
> + * at any point, e.g. once the target cgroup is dying.
> + *
> + * Return: The amount of memory reclaimed, in bytes, or 0 if @size is
> + * smaller than a page, or (unsigned long)-1 if @swappiness is out of
> + * range.
> + */
> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg=
,
> +						unsigned long size,
> +						int swappiness)

I'm going to have to request one final change, sorry.

I think long is more meaningful as return value than unsigned long. It's al=
ready
restricted to MEMCG_CHARGE_BATCH. We return error for various arguments, we
should probably change to -EINVAL.

Apart from that it looks ok to me, but please, also wait for Shakeel to rev=
iew
the set before you respin v11.

> [...]

