Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A07C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641136B009B; Fri, 21 Aug 2026 15:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F22A6B009D; Fri, 21 Aug 2026 15:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA496B009F; Fri, 21 Aug 2026 15:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16CBB6B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:13:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93B961C09CE
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:13:04 +0000 (UTC)
X-FDA: 85126224288.27.A3AAC02
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9901A4000D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:13:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kSTxy95C;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787339582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EP9kNnTd5rrVNF1QxPdX72MOJnRRML3UJBMc9GYEgA=;
	b=bt3E1RQCFcGRGGKO8UfwWViGW27JOUCNq+lL1CX4RPf9Tv6xZphd5T1+iu4ioSiw6ZKXut
	L7AX+uSIIa3FxsXd2lwmPhFKX1tfTx4QK4dk8pLtGCGL54ENACFkn56+n5Uuw5fTB4g2Pl
	YRhCVNga4Ff6MjPf6dOf8JEJI7hJIlg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kSTxy95C;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787339582;
	b=bXEf50i/6y0rPn49RnIXsUHFoqkyU86mKGAZzIGlL8TRqr6QZznTbnosBo7J3PRO8BdZdt
	MnPs+Yn7ZpukARjpxwNbIbYafQE7TmeQ4QWxCO44iGJ2h67YdOwxz+lBG0voHVcSGvpdIw
	rtqhD8njiX6yJBXcw2c0k1ZQh8sHfHw=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c9eefcf9175so1410778a12.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:13:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787339581; cv=none;
        d=google.com; s=arc-20260327;
        b=IFZLjyBOg5RXh/sS54DasNwbARVNPESm0lKDGuGLuJ0mplQtMZgMpzN9Jzr06VcP/5
         g3ysr9pBvxauCDyDcaBk2gEcjTCvGX0aCSqhJG5ot15eL4Vs1489siZIe/Aa6m9ANY8o
         US7lGAGu3xBhiF082qw6L7mlibInHQkiCjM0YAulKGZAaTAEf8eNhVo5jAC9SrRdSU6B
         e2SgoOXFvaodUka2Xls5XRk8u/X6MmgXyKZ+klA9giexykvZTv8FmGKlhr+WD4lOwDhy
         pPyIVlKfNcEaK12X5DHfYH7lAWAE9OVCwJzPzTMAHKxGTY5qgQOQTY1WTjxlJtL1U9nL
         eZqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4EP9kNnTd5rrVNF1QxPdX72MOJnRRML3UJBMc9GYEgA=;
        fh=dlfQs8gmRCyrNKJAQ7ECKv49VaT9kbF7uUCy6xjaNGw=;
        b=sLZsk3VzeXEmNupRUohT0RSM2g8yeYZ+7VJIqxQjeOiAm9oULvNE9mr/XQAGJeS0Fr
         wrTDovusJ11rgeXu7k1Pee36X3XoMRT2FEluxs+PmfirLHWQPJ/rE0aPVCoTqZFV2qww
         YdUppS99FOwljaE9MurKXAn49Aa2XZf7kIm2j/nIR2r03C506XEPI/phReaxAAVViNnF
         yUfzV91Qr2bUxEVqZOJE4eL5ZZSWMY6Yq/jZygIEAbyuTmXSlN05RegpiGndGFvaS5N1
         I0VPOlwXebNYVL5/ueG5ueOD/pVbMrtdXXBWhqI4pFZ9rb9kVSUnm6+DW+PMQdkJTTKj
         mzBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787339581; x=1787944381; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4EP9kNnTd5rrVNF1QxPdX72MOJnRRML3UJBMc9GYEgA=;
        b=kSTxy95C+8Hs7jb0nIau/ajpOGYfq/NyCo6+jiRpva3llrF4TErm232xtzm48yJ3Tz
         B+8X3DdhV+DRScMeFWSaGgveA8wkpd/vDzAeayyoPgPQtLA2v4ovcKNgeujhvTEfXBZ/
         KxCoA5JZt2z6e8XozIQwCxV/W1I/wMPjy1v5cber2fSRr57VsnytOqJ94lM/0fVOb4kB
         VpAVma8LkVXiDndpvay2+P7pWF9UH5sUMdUnq1hbY0jmcwvMZpSSgXc99nI4rM2HYVBR
         dgK73DynpPpAtA+tqS9VF1RAnVfZtbRYSi+tGQa8mDSQXlw4QM2Lp7WmG8LFTXwTOruN
         YLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787339581; x=1787944381;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4EP9kNnTd5rrVNF1QxPdX72MOJnRRML3UJBMc9GYEgA=;
        b=CN0ieJ45vwUlXjrgw/FcDUvzxROWpWsyKBhOOY0wgNSwJ8vRBDO4D6wygEYb95TKyt
         Ve6VPYbH20CL4/2ePKc/phbnZAk0DXf+V2SMdlSaJowqm9hhUThjYKdD/XcdIdQiwRFT
         /zzYgSraofBpqYaMK4+GFnw3pfFzbyflpQ6OcnjFrXI7ugE+aEAVIYabn08GpPt+B5t2
         joOpnsIhSRPqOT69rYlnbOql5fHiZPA25je2UVkCa++6MK04qlHF5ThJuev52bzoFDPt
         M5rpebML6CC1ytY7fcTWPll1RhjWQUA31D/9WUKAfPTdq2CuicnK2awYaaGSbRaPKGmS
         5hiw==
X-Forwarded-Encrypted: i=1; AHgh+RoQXSOfaoyOKbpgsvXY8YGUlybJxf8JKC7F/QaAuf0T+SfE2HlgGL63yocDuO2kAIMsWieWmxVQwg==@kvack.org
X-Gm-Message-State: AFuF++kU0PlQtUp0pdjMJY/YBaTtXvL0FI0w8TuZdhHeUic1Z/jx6KPz
	ONTJUPRX62XHWw+N0hs4HsaMQItU+PspfMwE4SYImE6NzjCE4gavydkA6/+brF6E/8xfM7Ha2Mi
	M2CBBXz7w5xX+JExtg4iszgQuwYB1xLY=
X-Gm-Gg: AR+sD125OdXfh5L1bO75RJ7puftcusqjQs2mxdyBbXUE/QQx7+W+qNGz2QfdvlXVsMu
	rSjA14fdN1P1DONIUUZ6oZybnDmPQ9duFLYQacNIRuOQAN6WFT8MzHcb70bNpg2e2cHZMMVeKBa
	ATU7ux4PYYK9IXHSoKxMa6L556sbXOdmDIn9tod8qnnHvBWFws5rby5E0wHUtDuXzBMlu/r7rLK
	gavg7f0uk/yqDhffAlD+8fcsAPYNiHmu7wNrxB/D+dlHkGYsxOjwNM4m4WhDx33b2h4yG/UbM8q
	RTgrjikgc90Xk10IpDhrNo800fpd7JTqxb4gdzcei7uh6UoOlZIElTTL2VOV6HBoq7wxMrfwQnQ
	VElpBFosiH5J8axVIWjBOOQBCXg==
X-Received: by 2002:a05:6a20:1605:b0:3c3:b57b:6285 with SMTP id
 adf61e73a8af0-3cd3003dc4fmr18286503637.13.1787339581363; Fri, 21 Aug 2026
 12:13:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1787205002.git.zhuhui@kylinos.cn> <e9b2a34418919f5c3ee2b80bcb4f9d80ce6ec422.1787205002.git.zhuhui@kylinos.cn>
In-Reply-To: <e9b2a34418919f5c3ee2b80bcb4f9d80ce6ec422.1787205002.git.zhuhui@kylinos.cn>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 21 Aug 2026 12:12:47 -0700
X-Gm-Features: AcwNN1VFlvzW-iYWjQEbCYx4cIALBao9hdQF0KejKmduy-QOpYTRcp_60ucoZjQ
Message-ID: <CAEf4Bza0KYB+OHpa89K16+ptUQuQDJKyxxNCyDPcgQaO1mtxjg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/2] mm/bpf: Add bpf_proactive_reclaim kfuncs
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: mwy3wc6of1qforj5dw5roqwx8xpsonr7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9901A4000D
X-HE-Tag: 1787339582-245643
X-HE-Meta: U2FsdGVkX19Z3ixVtxiDdfOpN7ejt7JtPYPbkjitLZQefWzETGXpR7eBf05e3cLzFVdkhPcxZjV1noXJiHqEiNsDFEvf7qL8G3BeHwsymbDpRzzSBDnkJm53Cl7jpFWQ7TRsWNv3fiJOqhh1YoaUIWF+YatktSkMn2Y2XiDqPHPPphFZlZYDmTXOnrE2XZvldG0wLGiefOOyy111zjo2Um/8SLeKXEpCaUw4SQ8lxhF/fewL/J6DuZ4uueEMEubr8OM5xpAXUkZYx9X71nkFcAP7B0thMtE2RVBRJ/vN4I5klfHZHGQBxNvmXnTf5ms0NtBJtdX3IbdlptOgUZ4+2DFawwPqQWjAA579kvS+DGKaIxwEwJYJD8MxsBZe3Ygsrv13QGyALfai7TvpVnhSaunRw8KJ4M7InaM0HJ5B+Jcmm6RtD4kbJtjvKQNQj6yF+jtDWtFlHf+pV8TH4RyCS1X1r4Tp75TOxKvA/JH2ZmpudaRVJmpHNFGDdUMQu5pLt0R2EQy4QuRxctM40I2N+icSb3eeRdmG/7Trz+o/i8g83mhazKv5H7NJJB3NybVX1dRObkR6PWBsybsE+ge7IW9IY5NRgUr1ggmPJu4bOOnKB+KVTtSG/xBDsQpf1Fql/IOWeRe4jg6U2dcP3GMys2ZvJrBFZfSb6qrvgTrsyrgm1E00ud6k2RACBcGkgLym7pncdLioz1T6tFXP7TJaRtViLsrq9PW5iXcn0DPYScrIhcWO8NK4RdXjdzbrJUUky7alhv4DMgg2OOlIba+cREDGT0aob2b7o0PPRuByh/wljwEly0NdRx1UYoz2/nG9J6uvsSx/QBN50tq6k4rSqZIWx3d5upmLSGv6SozJpifWjkDWRUK/Iv73BQ6i8LJVMs7E+vINZYzNX+Rnrdm5iBC/CQCMwqDYhtYUcbkY8N5xEfq5uKpLkc2CNcN13mw9PibfDH0PEuqKY/lHpDJ
 4XysJ9S5
 ZFeKxRnV+yyvjhhwhSjiedFSdkhB/2AI2m0Ibxq77EPI8TBvQWVnKBzrSrsHbtB5iYn+KRtjvMwC8/OxQ6g7F72GvTzOxetIgpmavERmg2H7Ki2KKh0s+XfyJRETtI6Acxe2UlK9ntdxdbow2x+OVqJvaNz6ZW+uVA4whSlzc3SoOu1l9XiqhSKcrnlm0uOzv3Ln17f+x/K9CgZp78mCS/fdsR6cYM5ayBFu0DWZ7FrvO1HbQxO4cqbMFyUwrmT/Jzqd9CXF6TwbTXAN0pFvQF9aBQ1EHJXPHIdUVrcCQkgu3sVylIIDsmlfQJMc3rm8E7xxDwzrJppi3tz3/S45/bV75CbCnIpyLH+fT4GI69ewJYaenfmbb3A4eL3Sp3nt9nhBOIsJUlxj47hm0kEScfSYvqkn0CLOIEEm6F6T5x7Ii1DAS9j6knE1fIOc9E/Cq1Vm/cSlalsmiTMoqVoAf8Ai9jw8fKzEof+MztjdM1taqvstK7U7ydjcR5FPI/TknvQxI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 11:12=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> Expose memcg proactive reclaim to sleepable BPF programs:
> unsigned long bpf_proactive_reclaim(memcg, size);
> unsigned long bpf_proactive_reclaim_swappiness(memcg, size, swappiness);
>
> They perform one reclaim pass on @memcg, like a write to memory.reclaim:
> swap is allowed, and the anon/file balance follows the cgroup's
> swappiness or an explicit override in [MIN_SWAPPINESS, MAX_SWAPPINESS]
> plus SWAPPINESS_ANON_ONLY. Both go through a shared helper,
> bpf_proactive_reclaim_pages(), which guards against reclaim recursion
> and calls try_to_free_mem_cgroup_pages() with GFP_KERNEL and
> MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE, the same parameters
> user_proactive_reclaim() uses, and unlike memory.reclaim they do not
> retry until @size is reached.
>
> Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
> current->reclaim_state on entry and NULLs it on exit, so a nested call
> from an in-flight reclaim would corrupt the outer reclaim state (e.g.
> MGLRU dereferences current->reclaim_state->mm_walk). Both kfuncs
> therefore refuse to reclaim when PF_MEMALLOC is set or
> current->reclaim_state is non-NULL. The latter check also closes the
> window in try_to_free_mem_cgroup_pages() where reclaim_state is already
> installed but PF_MEMALLOC is not: only a tracepoint call sits in
> between, and while a sleepable BPF program cannot attach to the
> tracepoint itself, it can attach to the generated trace iterator
> function (__traceiter_mm_vmscan_memcg_reclaim_begin) via fentry.
>
> The kfuncs take @size in bytes; the return value is normalized to bytes
> as well, matching the byte-based unit of bpf_mem_cgroup_usage() and
> bpf_mem_cgroup_page_state(), so callers can mix them without manual
> page/byte conversions.
>
> An out-of-range @swappiness is reported with (unsigned long)-1 instead
> of 0, following the convention of bpf_mem_cgroup_vm_events() and
> bpf_mem_cgroup_page_state(), as 0 cannot be told apart from a
> successful pass that reclaimed nothing.
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/bpf_memcontrol.c | 118 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 118 insertions(+)
>
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..dc51868b3acf 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -6,6 +6,7 @@
>   */
>
>  #include <linux/memcontrol.h>
> +#include <linux/swap.h>
>  #include <linux/bpf.h>
>
>  __bpf_kfunc_start_defs();
> @@ -159,6 +160,120 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct =
mem_cgroup *memcg)
>         mem_cgroup_flush_stats(memcg);
>  }
>
> +/*
> + * Reclaim must not recurse. try_to_free_mem_cgroup_pages() unconditiona=
lly
> + * overwrites current->reclaim_state on entry and resets it to NULL on e=
xit.
> + * So invoking it from an in-flight reclaim would clobber the outer recl=
aim
> + * state and corrupt its accounting.
> + *
> + * The guards are PF_MEMALLOC and current->reclaim_state. Every reclaim
> + * entry point marks the current task with PF_MEMALLOC for the whole
> + * reclaim window: try_to_free_mem_cgroup_pages() and __perform_reclaim(=
)
> + * do so via memalloc_noreclaim_save(), and kswapd keeps it set for its
> + * entire lifetime. A hook inside the reclaim path (shrink_node,
> + * shrink_slab, ...) executes in the context of the reclaiming task, whe=
re
> + * current->flags already carries the flag. The page allocator, the memc=
g
> + * charging path and node_reclaim() rely on the same flag to avoid recla=
im
> + * recursion.
> + *
> + * reclaim_state is checked in addition because it is set slightly befor=
e
> + * PF_MEMALLOC in try_to_free_mem_cgroup_pages(), with only a tracepoint
> + * call in between. A sleepable BPF program cannot attach to the tracepo=
int
> + * itself, but it can attach to the generated trace iterator function
> + * (__traceiter_mm_vmscan_memcg_reclaim_begin) via fentry, so PF_MEMALLO=
C
> + * alone would leave that window open.
> + *
> + * Also, PF_MEMALLOC is set in some non-reclaim contexts (e.g. direct co=
mpaction
> + * and vmalloc), where the kfunc conservatively refuses to reclaim as we=
ll.
> + */
> +static bool bpf_in_reclaim_context(void)
> +{
> +       return (current->flags & PF_MEMALLOC) || current->reclaim_state;
> +}
> +
> +/*
> + * Shared implementation of the proactive reclaim kfuncs: performs one
> + * reclaim pass on @memcg with @nr_pages as the goal, allowing swap, and
> + * @swappiness as the anon/file balance override (NULL to follow the
> + * cgroup's own swappiness setting). Returns the reclaimed amount in
> + * bytes, keeping the byte-based unit of the kfuncs' @size argument.
> + */
> +static unsigned long
> +bpf_proactive_reclaim_pages(struct mem_cgroup *memcg, unsigned long nr_p=
ages,
> +                           int *swappiness)
> +{
> +       unsigned long nr_reclaimed;
> +
> +       if (!nr_pages || unlikely(bpf_in_reclaim_context()))
> +               return 0;
> +
> +       nr_reclaimed =3D try_to_free_mem_cgroup_pages(memcg, nr_pages, GF=
P_KERNEL,
> +                                                   MEMCG_RECLAIM_MAY_SWA=
P |
> +                                                   MEMCG_RECLAIM_PROACTI=
VE,
> +                                                   swappiness);
> +
> +       return nr_reclaimed * PAGE_SIZE;
> +}
> +
> +/**
> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
> + *                         cgroup
> + * @memcg: the target memory cgroup to reclaim from
> + * @size:  the amount of memory to reclaim, in bytes
> + *
> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
> + * the memory.reclaim cgroup file: pages are reclaimed according to the
> + * cgroup's own swappiness setting and swap is allowed. Note that,
> + * unlike memory.reclaim, this does not retry until @size is reached;
> + * callers can invoke it again if needed.
> + *
> + * The reclaim runs with GFP_KERNEL, so this function must not be called
> + * from a context that holds a filesystem lock (e.g. an LSM hook invoked
> + * with inode_lock held): the reclaim path may enter filesystem shrinker=
s
> + * and deadlock trying to reacquire the lock. Contexts that set
> + * PF_MEMALLOC_NOFS/NOIO are handled by the gfp context inheritance.
> + *
> + * Return:
> + *   The amount of memory actually reclaimed, in bytes (rounded to full
> + *   pages), or 0 if @size is smaller than a page or the calling task is
> + *   already in a reclaim/freeing context (PF_MEMALLOC).
> + */
> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg=
,
> +                                               unsigned long size)
> +{
> +       return bpf_proactive_reclaim_pages(memcg, size / PAGE_SIZE, NULL)=
;
> +}
> +
> +/**
> + * bpf_proactive_reclaim_swappiness - proactively reclaim memory from a
> + *                                    memory cgroup with an explicit
> + *                                    swappiness
> + * @memcg:      the target memory cgroup to reclaim from
> + * @size:       the amount of memory to reclaim, in bytes
> + * @swappiness: swappiness override for this reclaim pass
> + *
> + * Same as bpf_proactive_reclaim(), except that the anon/file reclaim
> + * balance is controlled by @swappiness instead of the cgroup's
> + * swappiness setting. Valid values are [MIN_SWAPPINESS, MAX_SWAPPINESS]
> + * and SWAPPINESS_ANON_ONLY, which restricts reclaim to anon folios.
> + *
> + * Return:
> + *   The amount of memory actually reclaimed, in bytes (rounded to full
> + *   pages), (unsigned long)-1 if @swappiness is out of range, or 0 if
> + *   @size is smaller than a page or the calling task is already in a
> + *   reclaim/freeing context (PF_MEMALLOC).
> + */
> +__bpf_kfunc unsigned long
> +bpf_proactive_reclaim_swappiness(struct mem_cgroup *memcg, unsigned long=
 size,
> +                                int swappiness)
> +{
> +       if (swappiness < MIN_SWAPPINESS || swappiness > SWAPPINESS_ANON_O=
NLY)
> +               return (unsigned long)-1;
> +
> +       return bpf_proactive_reclaim_pages(memcg, size / PAGE_SIZE,
> +                                          &swappiness);
> +}

I haven't followed previous discussion, so I apologize if this was
discussed, but if not, isn't it a bit an overkill to have second
variant just to provide optional swappiness? Valid range of swappinees
seems to be non-negative [0, 200], that special ANON is 201, so why
can't we defined that <0 swappiness just means no swappiness was
provided and get away with just one kfunc?

> +
>  __bpf_kfunc_end_defs();
>
>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> @@ -172,6 +287,9 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
>  BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
>  BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
>
> +BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
> +BTF_ID_FLAGS(func, bpf_proactive_reclaim_swappiness, KF_SLEEPABLE)
> +
>  BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
>
>  static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set =3D {
> --
> 2.53.0
>

