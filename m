Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B4DACD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9664A6B00A0; Tue,  9 Jun 2026 05:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D756B00A4; Tue,  9 Jun 2026 05:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B416B00A5; Tue,  9 Jun 2026 05:55:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74EA96B00A0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:55:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F4291C1BCB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:55:45 +0000 (UTC)
X-FDA: 84859917450.30.57D7725
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6A07440002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:55:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCpzHnM+;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780998943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1IiR55/RulSC2eWpOF+KGlXaH6ldC7P9xSrMn9WJLk=;
	b=5lXUsw7c97KNWf/7PW0K/J6q8Y9D/V/9oNFzwuo4ES0fxo7CYWEDFmrnWQk3GGwXn9Wo1E
	OvQYzai0snCxDMJCobrC7P91MtlBBeKMTJCmyxR19O+0VZYgofTm9XtfojkCzZe3bkqH9B
	+L3BmJV86OtT+3jMH95WqgyA9PW8dRE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCpzHnM+;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780998943;
	b=65i5gvcT+M98cfQ8liGRkST6fAnrJ9sCBpdoayMti9gzzlv3lN/21Ljtte+tVewgi3J1kO
	8VBrHqbRDzkQQ33fd9veLDwtBACicDQ6vNDJcT6agp2Sc/g1hDPjPeJ2UbygLa9FXNmcmM
	tgkRVeM3px4TxXE9dBhN1lIxG2z7rWo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00E5960200
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF8F1F0089F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780998942;
	bh=P1IiR55/RulSC2eWpOF+KGlXaH6ldC7P9xSrMn9WJLk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lCpzHnM+ociPyCwLK8ZSKrJXX/jk8DuMyT71AJusrn60JMYrO7FoOABcGr2oaKaGt
	 UzehcJLhf+OFk7reU2zVzLbEuBldtxHRNASdUZWcFFL3JCSNrNm3XXkm/1HnPybIeR
	 8716z1DqvmkEddNvUnqSg8AhrJ3+kpnl7FcqUSdEb4OchDPteOEgQsO23C5BTbHQBl
	 ZtiM5cvF6M/SiG4Q9HM0GbykCS/0eYHjn7c5LuQRAKWoelzsLBWa82SRySyC/vAt/5
	 Rv3a3nEElJLNC21M+yBAZmpoha2vUjIO+fjHN/nvamnht4qLOPqzmmTL8Tc0/9/OP1
	 l1DP4fPoXG5Jw==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-9156ceb55ffso463095085a.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 02:55:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+DWHhAGotR3OVUaFsFb6efHE2lLNSqM85paSPflz64hu+GAXFOVbi/mtR/c3IBCbIw2lCPoR6kUA==@kvack.org
X-Gm-Message-State: AOJu0YzQ91l7q/jCU9fkQpd5Q5YWJiUtf9nhHNZI8sczw8mafmn4bRTI
	dhudyPDjvQBxsxPruAjcTndgjsfQKhOrk8T5f+RekCSUYW60DUM2ebVCiwQeR2r/TfLtNPKHtTc
	HqkvLGAWjDsfz5F+9WhvvwNqtPTnux3Y=
X-Received: by 2002:a05:620a:1a0a:b0:915:40ff:4e10 with SMTP id
 af79cd13be357-915e822bf5amr267763585a.4.1780998941890; Tue, 09 Jun 2026
 02:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <5fb8bead.17483.19eab4626f5.Coremail.chengfenglin@stu.xmu.edu.cn> <74cdec57-67aa-4ae3-a416-e39846049ab1@kernel.org>
In-Reply-To: <74cdec57-67aa-4ae3-a416-e39846049ab1@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 9 Jun 2026 17:55:30 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yC6Cgj-gmnd+=kxyyzQGs=9_re429-wCaTmsHr=Oh-VQ@mail.gmail.com>
X-Gm-Features: AVVi8Ce0tYnSjjzSLbh2mXfQqFfQ0i_dsWLVka8kn9Bp2MZmOm_4M4zJPGNEPog
Message-ID: <CAGsJ_4yC6Cgj-gmnd+=kxyyzQGs=9_re429-wCaTmsHr=Oh-VQ@mail.gmail.com>
Subject: Re: [RFC] mm/mincore: present-PTE scan cost after pte_batch_hint() batching
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chengfeng Lin <chengfenglin@stu.xmu.edu.cn>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6A07440002
X-Stat-Signature: tqwr93bbq7cgn59ducgdymqrrayttw8f
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780998943-825191
X-HE-Meta: U2FsdGVkX1+N8jzHOWzZmu/sace+hIMvM0whNhXQuzfSAwmJVEAiYkiPjxBAE4xdVeMdB9aAAClLFm++kiP/oBNBC67kv8xFpnGoAlvL6es5H169P6czHebhk6jBeJEtw0KyZkY7msf8PBpdBSfNWvYF1fNtnPQgNG+sCUMkGaFiBLcKjq6L+r3Wlknr/A0o50poOKsCPaCeEFyxZdu3lTrFLkAodqA0WFOaz6bet5/4cKlc77iFfqO7eaQUYlHIFnjGez5+BVmGLIr/Kb+zx/HvromN/K1PjfcJqa3X5ocFv6IpurOEphnvFw1v2W7aLgfFNNFJozzbkoxlZBYAcVkLytoHJUk2LxTP1W1IRdCOdt47JGuY3nJ5m2MQd40Mp2/Qh+iog+fPL6pn8j9hcRZ8dPHPoAyEbPXgyNUaEARjnImxTocgMWra85ZyGyWwhSqpiLzaIhgF2DQ4cqIZ3eKTkV4SKOsslPweTzklD28MIjfpSd6pNSHhDXNITauNBB/TJApqniKl//d0NITrMGYSHU8UYvgPf/8qae0byaQ7t663UD24KXp3UCvhCv+HVhkIiTufW5ODrmjGNODhxGgC0BFqMRUwuF+ywkSGM43ZCXR+dcq9IQ+tFyh9avt/Fel/+uX/fV8i7lorf3UkbkANoL/6qYIcdO2brfQSO2bcpeYra79/QbZeDcdIRHyk2Cc9ufoszcA9ASCyzA7bf0nHEqxaBb3QUhDUCvQ5SE3hXbVkR13dHBJ9RhvKboCaSDWCYYpT3c4cjpBPh3fF06Ch/vT1mle1BOmpn9SX2qC8Jt1nRhUGXxZTXkdMymZTgicUrsxhMjTDCVh9O2pnSWtNzBlJrJDCkuJLBe2m4bwz2N/1aVcYntFZaCxPYjv5MKznZjxYJD0GzPbIQgC8v29gQurGZhAh/xIEKnepdIq+sug6o3lxLG4pEO6CetalhB5fOsV6gve1MMX8BJ0
 f9kolfyO
 pJezo98+Ev9EMgELIYaXLvrIdPJ6mKyersSaciL4WP4GQLlGPsguKeRwVIUfWh0P23VZPrBoyh2g/4waCfVUTV839Rpajrg+YGorKhDV7tZhDYcZAqn3QPuvN8F9qkHMrX9IOOBhvui/aCZEhXGB8/D89q7nUpmGcfW85X3acPBk1CJ6MG/sKyizPwN9SGgCwyBsyxc9OI9nSqYgw5WcW7lPqr0fvV5x0yfxQc9SwtVWJyuCZay6o2Wrmr/M26HrbWRYjXB4m7DooCLhcS8XcgsJLWyG229X9HxhuAjb3LAS0mFpWFcbGHI0r8AhRPDIwXoL7xtDvyZfGKIH8lII6tXjJELX3haCgSdnKvaakr1D8JZWeUPtIR4sqCWckIcZoAK8ukeobvaVMRZH7UJPOLAKQg+Xfl9CGfy64PRkQQkaIcIkhaWOQVi/nfwnHaAFjR47STaH9f8yX7Ic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 5:01=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 6/9/26 09:26, Chengfeng Lin wrote:
> > Hi,
>
> Hi,
>
> >
> > I found a source-calibrated synthetic mincore() signal in the resident
> > base-page PTE path.
>
> sorry, I'm confused. Did you mean to say "I found a performance regressio=
n" ?

I guess so.

>
> > I do not currently have an easy arm64/mTHP validation
> > setup, so before trying to arrange that more expensive validation I wou=
ld like
> > to ask whether the candidate fix shape below looks reasonable.
> >
> > To keep the scope clear, I am not presenting this as a production appli=
cation
> > regression report or as a generic mincore() regression.  It is a contro=
lled
> > reproducer for a real userspace-visible syscall path, with the page-tab=
le shape
> > kept intentionally simple:
> >
> >   mmap() private anonymous memory
> >   madvise(MADV_NOHUGEPAGE)
> >   fault in all pages
> >   repeatedly call mincore() over a resident 64 MiB range
>
> Okay, so I assume a mincore() regression. On arm64?
>
> >
> > The practical hook is that mincore() is the userspace-visible residency=
 query
> > for an address range.  The resident anonymous no-THP range is intended =
to
> > isolate the base-page present-PTE scan and avoid file cache, swap, THP,=
 marker,
> > and unmapped-range effects.  I would read the result as source-path evi=
dence for
> > the hot path below, not as evidence that every mincore() caller or a sp=
ecific
> > application workload regressed.
>
> This reads very obscure and cryptic. Was that written by, or translated b=
y an LLM?
>
> The way it's phrased makes it a bit hard to digest.

I really suggest we first write in plain, imperfect English and then
use an LLM to refine it.

A direct translation can sometimes make it very hard for readers to
understand.

I think I share the same native language as Chengfeng, but I still
find this email difficult to read.

>
> >
> > The intended hot path is:
> >
> >   mincore()
> >     -> walk_page_range()
> >        -> mincore_pte_range()
> >
> > The main metric is mincore_ns_per_1k_pages, lower is better.  It is the
> > wall-clock time spent in the mincore() scan, normalized by the number o=
f pages
> > covered by the range and reported as nanoseconds per 1000 pages scanned=
.
> >
> > As a release-level starting point, the matched-PREEMPT 1/2/4 CPU bridge=
 below
> > uses original release kernels, QEMU direct boot, 9 repetitions, coverag=
e
> > disabled, and the same CONFIG_ADVISE_SYSCALLS setup:

Sometimes QEMU produces highly distorted performance numbers.
better to re-test on physical CPUs.

> >
> >   scenario: no_thp_pte_scan_64m
> >   metric:   mincore_ns_per_1k_pages, lower is better
> >
> >   CPU   v6.12.77   v6.18.19   v6.19.9    v7.0.9
> >   1     12827.667  15677.444  16482.667  16726.333
> >   2     13628.444  16102.333  18256.889  17270.333
> >   4     13798.222  16739.333  18892.111  17068.222
>
> Okay, so we see two steps of "degradation". I assume this code is so perf=
ormance
> sensitive that even compiler changes might easily affect it. Because all =
we do
> is scan page tables for present entries.
>
> The mincore optimization went into v6.16.
>
> >
> > This shows cumulative cost relative to v6.12 in the primary 1/2/4 CPU m=
atrix.
> > I also reran the 8CPU/16CPU release-level bridge on the same scenario. =
 These
> > rows show the same general direction, but the shared lab was busy durin=
g this
> > rerun and the high-CPU rows have higher CV, so I include them as extend=
ed
> > context only:
> >
> >   CPU/mem     v6.12.77   v6.18.19   v6.19.9    v7.0.9
> >   8/16 GiB    17251.889  23335.556  21863.556  21664.778
> >   16/32 GiB   16697.333  21428.333  21629.778  21628.333
>
> I don't think measuring concurrency here really makes a lot of sense.
>
> Especially, as it's becoming a rather weird, unrealistic micro-benchmark =
that way.

I'm not sure multithreading is involved here, since the reproducer
is single-threaded:

https://github.com/lcf0399/linux-mm-regression-evidence-2026-05/blob/main/m=
incore-present-pte-scan/reproducer/mincore_present_pte_scan.c

>
> >
> > The 16CPU rerun had two QEMU returncode-139 failures in the original 36=
-run
> > matrix; I filled the missing v6.12/v6.18 samples with a clean two-run
> > supplement.  I therefore use the high-CPU rows as context for the relea=
se
> > bridge, not as part of the primary matrix.
> >
> > Follow-up release-ladder and A/B testing narrowed the main step to the
> > v6.15 -> v6.16 window.  The strongest suspect is:
> >
> >   4df65651f7075 ("mm: mincore: use pte_batch_hint() to batch process la=
rge folios")
> >
> > That patch improved the mTHP/large-folio case, but in this base-page re=
sident
> > PTE scan I see a sizeable cost.  The original commit message mentioned =
that
> > base pages did not show an obvious regression, so this may simply be a
> > different x86/base-page corner than the original arm64/mTHP test.
>
> Okay, so it is on x86 then?
>
> On x86, pte_batch_hint() is hard-coded at 1, so the expectation is that t=
he loop
> and everything should get completely optimized out.
>
> >
> > For the v6.16 introduction-window A/B, all rows below are lab QEMU dire=
ct boot,
> > 9 repetitions, coverage disabled, same PREEMPT and CONFIG_ADVISE_SYSCAL=
LS
> > setup.  The 1/2/4 CPU rows are the primary matrix; the 8CPU/16GiB and
> > 16CPU/32GiB rows are the high-CPU follow-up:

I don=E2=80=99t really understand what the =E2=80=9Cprimary matrix=E2=80=9D=
 is, or what
=E2=80=9Chigh-CPU=E2=80=9D means.

> >
> >   scenario: no_thp_pte_scan_64m
> >   metric:   mincore_ns_per_1k_pages, lower is better
> >
> >   CPU/mem     v6.15      v6.16      v6.16 batch<=3D1 fastpath   v6.16 n=
obatch
> >   1           12946.889  17117.667        14560.556              13843.=
222
> >   2           15053.111  18214.667        15714.778              14270.=
556
> >   4           14942.000  18338.222        14397.889              14719.=
667
> >   8/16 GiB    15046.444  17540.222        13696.333              13200.=
000
> >   16/32 GiB   14674.111  18928.889        13949.000              15351.=
111
> >
> > The high-CPU matrix completed 72/72 with all_cpu_match=3Dtrue,
> > any_noapic=3Dfalse, all_autorun_exit0=3Dtrue, and all_semantic_ok=3Dtru=
e.  One v6.15
> > 16CPU timing sample in the main matrix was an obvious outlier, so the 1=
6/32 GiB
> > v6.15 value above uses a clean v6.15-only 9-repeat supplement.
> >
> > I also ran ftrace attribution on the same path as mechanism evidence, n=
ot as
> > clean timing.  In that run, v6.16 original had a higher mincore_pte_ran=
ge
> > average than v6.15, v6.16-nobatch, and the batch<=3D1 fastpath:
> >
> >   kernel                       mincore_pte_range avg_us
> >   v6.15-mainline-preempt       6.040
> >   v6.16-mainline-preempt       7.899
> >   v6.16-mainline-nobatch       6.031
> >   v6.16-mainline-fastpath      6.103
> >
> > The smaller batch<=3D1 fastpath helped, but later v6.18 testing suggest=
ed the
> > remaining cost was more about the hot present-PTE branch layout.  The c=
andidate
> > shape I tested is to check pte_present() first, while keeping pte_batch=
_hint()
> > for batch > 1:
> >
> >   if (pte_present(pte)) {
> >           batch =3D pte_batch_hint(ptep, pte);
> >           if (batch > 1)
> >                   fill vec[0..step-1];
> >           else
> >                   *vec =3D 1;
> >   } else if (pte_none(pte) || pte_is_marker(pte)) {
> >           __mincore_unmapped_range(...);
> >   } else {
> >           mincore_swap(...);
> >   }
> >
> > On x86, pte_batch_hint() defaults to 1, so this mainly measures the
> > resident-PTE hot path layout.  On arm64 the batch > 1 path should still=
 be
> > preserved, but I have not validated mTHP/contiguous-PTE performance yet=
.

Is the performance improvement mainly because the tested PTEs are always
present, so some conditional branches are avoided by the patch:
https://github.com/lcf0399/linux-mm-regression-evidence-2026-05/blob/main/m=
incore-present-pte-scan/patches/mincore-present-first-fastpath-rfc.patch

It looks like the gain does not come from fixing an actual issue in
the existing logic in any case.

> >
> > The v6.18 confirmation A/B.  The 1/2/4 CPU rows are the primary matrix;=
 the
> > 8CPU/16GiB and 16CPU/32GiB rows are the high-CPU follow-up.  All rows u=
se the
> > same no-THP scenario, 9 repetitions, and coverage disabled:
>
>
> Which compiler are you using?
>
> The expectation is that the whole code would get optimized on x86 such th=
at the
> behavior is just like before.

yes.
Likely due to QEMU behavior and some compiler-related effects.

Best Regards
Barry

