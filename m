Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C3C2CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA546B0005; Tue,  9 Jun 2026 03:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B5D6B008C; Tue,  9 Jun 2026 03:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989866B0092; Tue,  9 Jun 2026 03:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 838316B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:44:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E3DDA03E8
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:44:26 +0000 (UTC)
X-FDA: 84859586532.06.17BA6A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 35D8440002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:44:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W6TCR6is;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780991064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBycYasDaIV1c55FVXytnKgd6uGrMzPwBTTo4/YfmGc=;
	b=3Ek+DXZFpN2lHnMBlx4oTyblCt60Znhv8GKMWRs+DFNNviTEFFECUHl5l59IK3ITJWUnqJ
	B0+Y+cewFDjWuxz/PbBEWf1LK3iDJqKZizBQhtHGF1YV+yPicS6kUnBf3MvjuUfFSY7baa
	txJR9UoaKSo9qN94Aq4HtzCyZndptbo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W6TCR6is;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780991064;
	b=R3wKReSqdSKHZ2dACXL7MKAKMJspDUMbunNQ2GyIu3Rx5hVTd9K2UxjILXVk7sEWEN17dQ
	eS0l6euCUu9mhvTbFzBTeUbHs70dq/UXvfc377TVU6oxC4nPNae9Il9YCW9XEOMvU6Eexp
	yhc4v2uSH/stNabsra9IO3F1VdpksRo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 49A3F445BB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BC81F008A2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780991063;
	bh=YBycYasDaIV1c55FVXytnKgd6uGrMzPwBTTo4/YfmGc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=W6TCR6isYeRRhaBuLbcGdSB06481pxkt/XDrRlvKMCbmbCXQFdz65l6jiCBbcmMgk
	 VyS5Uztuk0v0nHwlIggl6pqV3DE3N2Z7krlX8E8vGr/FHHhtmUMYmis2NSE43lJY37
	 cUUnCnYAzekKI9/L71IUsXpcs0PcmafWyKBRk3Niu1KIeT7JODq8Vu5ggaCnNOqVZQ
	 9n7JsCUs6weT9ATOVMbOJ5MFdPKSyJdBCDeKp7q36FMzZGQFmHy60RrqqW2lHleCuY
	 /wcBFHtQsB3zE/N5z8jlQC16Q7jN/f02nPfbxwArPUN/V6gYczjLF8FrwEralkSVC3
	 7fdOeJbDFWE6A==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-915aa0a9293so450073985a.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 00:44:23 -0700 (PDT)
X-Gm-Message-State: AOJu0YwOfXEvzHvxwFPU3DASgOvllnqkVlSPaVUICTkwnZNNKxZIUXYB
	UpHU+YmpJ66V42YIVipi3zl+vvYgqcwvvqTjp/0bqsK9PCWUEMx3+EP/fD+dC68X5e7klsFuHYS
	/WoVRnXVq2QduPbOCkimLlMXMyhepwtk=
X-Received: by 2002:a05:620a:4608:b0:8cd:9281:6be9 with SMTP id
 af79cd13be357-915ad30dda2mr2118273885a.31.1780991062278; Tue, 09 Jun 2026
 00:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260609041156.31127-1-jp.kobryn@linux.dev>
In-Reply-To: <20260609041156.31127-1-jp.kobryn@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 9 Jun 2026 15:44:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xk2Q3xTkQYMPb7rnvnvVsjp24uXRcOja5RxqSbQpdoEg@mail.gmail.com>
X-Gm-Features: AVVi8Ce7w8O4ofIUO0KMJPnSxBUad7ad-fPBfMDmsM69pgWrp7a1y6xJ_69oSVY
Message-ID: <CAGsJ_4xk2Q3xTkQYMPb7rnvnvVsjp24uXRcOja5RxqSbQpdoEg@mail.gmail.com>
Subject: Re: [PATCH] mm/lruvec: trace LRU add drains and drain-all queuing
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, willy@infradead.org, shakeel.butt@linux.dev, 
	usama.arif@linux.dev, akpm@linux-foundation.org, vbabka@kernel.org, 
	mhocko@suse.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kasong@tencent.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 35D8440002
X-Rspam-User: 
X-Stat-Signature: 7zwtgepa4pnyj9uxqb9fuk3wrwk16381
X-Rspamd-Server: rspam09
X-HE-Tag: 1780991064-35785
X-HE-Meta: U2FsdGVkX19kKvGmf33VxlZ/gTewfq4uXEa3JMEuV7t/rs3crZMGV6VveV3WsBdOHn5kI2hSnDOwebvDHmrGVm87a70rvcrfVNqgt9mdatlc1pHhlqXV+izj4jMoOF+rplwumIE0cTSxOh/6L2Al2LJSOpJn2JD+obiSnu08q+m6leVbH/cFe5oEEzE0ja+EdiVz+SS5+18xU+Ue1CiVsXXCUuOqxTnpzR+5jClCL7iv4IghqT5eLweGWvWxfrcO3aF/OZUUMU0Cto+WQD1TituQZW4xgr1qKrXkNjXG2s90QHUySB9J6KmVkVHSVJNqNkSiDtu52fhdSzAcPdD5XTBeuBpLvWRbdreXbGANs54qjdEXSH0VCx3IyUy5H3HnFVZpEsfKRXrl9VbLIHnDVgaUGvmzM3idLwHNVNKSdHJ3Bk9Gunxs4DN1q3JbCBuyIraMOuywvhMquLP1SQPA5ND0wkbixWqgnWU/uHom8Sgz9ti0bxZtTYpvLZKE6r2g+pJLiyvov5Ze2g8wCemcWV/vMXwyzFpj4emcR9rUAxOgIpQgmCDa5GwDI3rZue7W5Kmv1s++9yfP+ipsWai3JhfDKFbUydE1jSSs0byExJao5qW6o52XNrPKj/92xgKW4u472uf5fnZIi58OvxUcLRAGvsiJ/dmQ6lXvYpf6Avr4coJA7TuNtsdZMZ6fOqA4khwXtA7L5S1aXlVgfjJUadWauje8XJvzAAd+ANqPlgk+bKY6IyRyN4hhre6JBZOM/vomk/1rzrTYi5AHqtbWKFNlyqATEgKkXfiw3famazJmHVSt8LRXO17StgduueOXDayYoMi2oj4MVwocgatOlIfG1fU+hoPFJA1CAqNr6EQIMNCakHHVsJu//RpW3x1OQWv2N47EVZILDtREwJ8huZRbnVaVogl8kdh0h0LJGs1uL3kT0X/jNwAm0FSRe9Orq9n4Aq4BiTAKlFcoCNj
 WcfS45g1
 KXShw+aaUGrgcrVv30qd2GW2mH2+lE6UGyDvwt1gL5EWFmyJFobmdtct5eugWGVwBgPh8JKbWss38rlQe0aVjfnMtOaBqRCD8ftUUH+GuvkzsDvNQ7beaue+TwWPfLmA6mbLlHfgVUGoeECtDLSvf8ge4Qh4SvYoGKRwE3mNqvDBJf0XoykwfFUle1ndh+Xf2oh04lzJRStoUU0N+/E5i8E63ucEvCIBnU5jKPu49gExXUO1N+khotr8RMqITGj3C3gyhyAzSotL7xbIurMOFmJgiBozItLdmVGRf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 12:12=E2=80=AFPM JP Kobryn <jp.kobryn@linux.dev> wro=
te:
>
> LRU add batches can be drained before they reach capacity. This can be a
> source of LRU lock contention, but it is not currently possible to
> attribute these drains to callers with existing tracepoints.
>
> Add mm_lru_add_drain to report the CPU and lru_add batch count when an
> lru_add batch is drained. This allows tracing to distinguish full drains
> from partial drains and attribute them to the calling stack.
>
> Add mm_lru_drain_all_queue to report when lru_add_drain_all() queues
> per-CPU drain work. This captures the requester stack and target CPU for
> remote drain work. The event is named as a drain-all queue event because
> the queued work can be needed for batches other than lru_add.
>
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> ---
>  include/trace/events/pagemap.h | 40 ++++++++++++++++++++++++++++++++++
>  mm/swap.c                      |  6 ++++-
>  2 files changed, 45 insertions(+), 1 deletion(-)
>
> diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagema=
p.h
> index 171524d3526d..ea8fc46bedb0 100644
> --- a/include/trace/events/pagemap.h
> +++ b/include/trace/events/pagemap.h
> @@ -77,6 +77,46 @@ TRACE_EVENT(mm_lru_activate,
>         TP_printk("folio=3D%p pfn=3D0x%lx", __entry->folio, __entry->pfn)
>  );
>
> +TRACE_EVENT(mm_lru_add_drain,
> +
> +       TP_PROTO(int cpu, unsigned int nr),
> +
> +       TP_ARGS(cpu, nr),
> +
> +       TP_STRUCT__entry(
> +               __field(int,            cpu     )
> +               __field(unsigned int,   nr      )
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->cpu    =3D cpu;
> +               __entry->nr     =3D nr;
> +       ),
> +
> +       TP_printk("cpu=3D%d nr=3D%u", __entry->cpu, __entry->nr)
> +);
> +
> +TRACE_EVENT(mm_lru_drain_all_queue,
> +
> +       TP_PROTO(int target_cpu, bool force_all_cpus),
> +
> +       TP_ARGS(target_cpu, force_all_cpus),
> +
> +       TP_STRUCT__entry(
> +               __field(int,    target_cpu      )
> +               __field(bool,   force_all_cpus  )
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->target_cpu     =3D target_cpu;
> +               __entry->force_all_cpus =3D force_all_cpus;
> +       ),
> +
> +       TP_printk("target_cpu=3D%d force_all_cpus=3D%s",
> +               __entry->target_cpu,
> +               __entry->force_all_cpus ? "true" : "false")
> +);
> +
>  #endif /* _TRACE_PAGEMAP_H */
>
>  /* This part must be outside protection */
> diff --git a/mm/swap.c b/mm/swap.c
> index 588f50d8f1a8..c385b93582eb 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -694,9 +694,12 @@ void lru_add_drain_cpu(int cpu)
>  {
>         struct cpu_fbatches *fbatches =3D &per_cpu(cpu_fbatches, cpu);
>         struct folio_batch *fbatch =3D &fbatches->lru_add;
> +       unsigned int nr_folios_add =3D folio_batch_count(fbatch);
>
> -       if (folio_batch_count(fbatch))
> +       if (nr_folios_add) {
>                 folio_batch_move_lru(fbatch, lru_add);
> +               trace_mm_lru_add_drain(cpu, nr_folios_add);
> +       }
>
>         fbatch =3D &fbatches->lru_move_tail;
>         /* Disabling interrupts below acts as a compiler barrier. */
> @@ -928,6 +931,7 @@ static inline void __lru_add_drain_all(bool force_all=
_cpus)
>                 if (cpu_needs_drain(cpu)) {
>                         INIT_WORK(work, lru_add_drain_per_cpu);
>                         queue_work_on(cpu, mm_percpu_wq, work);
> +                       trace_mm_lru_drain_all_queue(cpu, force_all_cpus)=
;

Do you need tracing on each CPU individually, or is tracing the
entire __lru_add_drain_all() invocation sufficient?

Do you also need this_gen and lru_drain_gen to be traced?

By the way, I'm not sure drain_all_queue is the best name here.
Why not simply use add_drain_all()? It would match the existing
function name better.

Best Regards
Barry

