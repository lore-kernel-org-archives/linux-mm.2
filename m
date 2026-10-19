Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB7DCCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB7116B01F9; Mon, 19 Oct 2026 08:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F426B01FA; Mon, 19 Oct 2026 08:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4F06B01FB; Mon, 19 Oct 2026 08:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9632F6B01F9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:19:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D135404DF
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:19:07 +0000 (UTC)
X-FDA: 85339280334.26.54558E2
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id 573C016000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:19:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ajgeeNT/";
	spf=pass (imf08.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792412345;
	b=xYsMQ4QrIGyiEPZw0tp8eofrvFAk4/j6gnfcQ1kB6bCAccrp5t75ib0vUGoM7ft4HA6w5o
	nQub9712KFw7OT8vFZWx5yOmyzNxdhxvAWnbUKM2Ao7pqoArj+wW4QQ7uY6OMzRredYITJ
	ghLfDgUrn6dLTQE33PLdWnsVCvxCpOc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ajgeeNT/";
	spf=pass (imf08.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792412345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0WXKs7qtnftjeq+tMy7fCLdvDaq+qqKx2OnymJOb3no=;
	b=MWUOj4k2PqldwNgvhkcpFtkvZwnZnX5lITGPdkTCyNCoHkgtEcsjRgptNquz47I5HgI+nI
	pYhBLqWjCWE+glr0kvw2zaAgCMvZHGCUiIpX1T5jRAGFWWczofQ2zinP0evAiU7C77eEsR
	AjAFiAyBq/9xpjSzoXgPhi8Gp469hs8=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48b060ec084so1352640f8f.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792412344; x=1793017144; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0WXKs7qtnftjeq+tMy7fCLdvDaq+qqKx2OnymJOb3no=;
        b=ajgeeNT/wTJRqKYyandEA0JFdPs1UCABdTKK7XYu2TAp8kJYYSkD1lO2XFjpBgZjw1
         gHU+F6ZvbdGITAvfwT7tRJi+J/+Rwq76hW0ERH35vA6EcXumCDAaEEsGMlbmtj3Wf70i
         q7kU9Ff66K5qF9fT0KW/MzbA/nQg/hm6FN13OJTcfr1kWu89M2B/E/F2ZStrUmJoFRwC
         gxK95jAH5jxyHkPAibltY84ZmS6vimTVhiHbt0Dt8xcBwV4XUDpt22rrW9mOmPfFq6UV
         Wz7EGeh7I9B/caleHJ0cjDbMugrfYf7/jueapeiZMiNHR4waOxsCsbPQcGHf0FTmZJvu
         LBsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792412344; x=1793017144;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0WXKs7qtnftjeq+tMy7fCLdvDaq+qqKx2OnymJOb3no=;
        b=s5T+SBYsr6TGO8IRU3VkhPWZUvw6S6Tvig9alY4bDdYY3KgZ+1WxEVCma1eciEETTa
         D6b9VtC+z+tpWOmRAb8s62i3RKEdoaTv9w9E7OYWJ95Sv0Vl64ne0fAIOLYU8uFP7o9T
         vcfVm2munnS+TGqJWka7jwH0VM6ej4lJA6mEVaUmGE0Pcuv6K8mEBYQTiS/nUeP0KjHb
         igEWRO6S9EHY+hktkrjNoQuYJqKNBvGZAzXHaIowsx8IajV4BnuKlbqiLlqNArrrrbO8
         BbihJh/zoXgzEPPQ4UByr17lC7GZ5fsQmKS53FpaQskhAT0UPvray/WhGVSzhEIUB1I/
         nzvA==
X-Forwarded-Encrypted: i=1; AKwUvBzPswrmkRwzPN77cWUuVhg6l6gdRAzuFMlPXC22AMjxXNYtfEmfXh8m20Vh9QPBqJyGbIGEJ05lCw==@kvack.org
X-Gm-Message-State: AFq9FYKgMpJRuPapof2XkbP+XGJLLJOuGn7KkIfLhflbTAuI5My/8f/I
	fbMvzzSn75A4mwGOXo2r+YO44PrQNWNtocAFO7qofUwIp2jXawSkiUU/
X-Gm-Gg: AYBFou2rbnLHD15PxGFwaTd1SiF46hjEi5VPx3CRTis7TTL3jZeBsV8tEMrKpbe3wHD
	5x0OfOyV9rCp+69N8F350hL7s0gNrHNnw4TBJ07ObbIEBKWS37gaov/Twg6v9AToncgUT32f5Tw
	h4ONoL7fUizRNQIg+wspeeD0tv3tU2sWgC+JSZec2/T9gvD4wowBsEKPhBTMgLEXGr9csJaOqM5
	CysflW47x6aD5EP0whmuX8uXfaun/slRyLRMLalzaB07+W2CB0vIyX2hYii4R5FmPaMRzNd0der
	HHJ2AM4x4AHCfWz+VzOXsTw8mRhZbMkb/rEzyemlqQZeomTILDIQqhYx5b6qeEZYVL4lrk6eNkq
	3Aq3hrFHPoMPlwY0JoTr2g3uP76CwNEShWu+aIliDptYwIGVqTFa6H6DKUngJBJNwgYgMF8AUUO
	oxsdX/r6EOpXei0VjZlGfsTuZSABJBhR959hRgbkRg7I7InaxCHT4VA+R5iNrnZMU5rr27dfUDl
	qmtpyNw6CgSS1qZSWhWN4VEI0f8RWjtyPguTciptl2WVw==
X-Received: by 2002:a05:6000:2689:b0:48e:e98:8b64 with SMTP id ffacd0b85a97d-48e0e988d87mr9220909f8f.19.1792412343478;
        Mon, 19 Oct 2026 05:19:03 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4d4dddsm22621858f8f.22.2026.10.19.05.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 05:19:03 -0700 (PDT)
Date: Mon, 19 Oct 2026 13:19:01 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Borislav Petkov <bp@alien8.de>, Ankur Arora
 <ankur.a.arora@oracle.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "Thomas Gleixner" <tglx@kernel.org>, Bharata B Rao <bharata@amd.com>,
 "Hrushikesh Salunke" <hsalunke@amd.com>, Ingo Molnar <mingo@redhat.com>, "H
 . Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>, Linus
 Torvalds <torvalds@linuxfoundation.org>, "Teja Vojjala"
 <tejavojjala@google.com>, Huan Nguyen <nhuhuan@google.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH RFC v2] mm: introduce copy_mc_highpages() and batch copy
 in folio_mc_copy()
Message-ID: <20261019131901.7a8fae90@pumpkin>
In-Reply-To: <20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com>
References: <20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 573C016000A
X-Stat-Signature: d1srouzwjcw4y7hiq8rm1yoggmkocry6
X-Rspam-User: 
X-HE-Tag: 1792412345-498968
X-HE-Meta: U2FsdGVkX18tV6hS3nwVwCDfR4QCK9SW+LAzE2xOsSdeXpfsKMF2KUfTZayw8mxgOmmYnU8Zmj0jM334jZ+5WnF1N9EBdliKwIMqhRYL2nJXLslpfuWBzHrwZIPQ1oTGd4/7sPJUbbf512Z/5jBQt+lGjKl8ZJKpaWorrNgqyPPrUso6u2yclghWK3CcHMJzMG2BIlvhHDbNszIVuOzSYlJwJGxvRD0AALlfesyz0ms46HAOjMxbxoyNgZ0OmCgg3Y8cyw7hGPMdpUQ1dQ2jwr1Fyb0QztKlHwu0VsheI6A786WNITzk1tHbJyttIqrnKDuL0ypw8cUab//4KN06jZCT7KAOWKvtffQ7EcpHoVqgsEvq8AL+RP3ZKlXrNxrQhrpjd+ozJi0KP0LU6VoBvN75U7Yg6pttpXAz1fGZALRRhjo/cF1vSJNApGt5/az8rAmwlZ7MSaZQ4AueLJLmTaId9AYoPBkIsWn+VnDJAN7Hu79qJx4N09ubdJMxIoxFkWMPbJtbmUqx+U42vPBivlpWy0PnNoeYxKeg/oEa2fJssIq4Vd9HxOsUuH2A4bT4Q2tD3QEW2+7tCxzQaEs46N5h7YWgOkdTi5rIs0/LaxFjVAQXvBqFtWpwlxUQzOGNhG1OddPgnUXm9Z+1y38OsAAqd0yj4voiu1ntkjVygcRcL0/7rg4BRL02pFWI6X0rFFW0xVaHA5z8CYzGydLPhGIg1O6TyT9KyEbuR9Yn0yxVyM3TMBSRijdqHgyuymSL65TZJWSvvNO294l2BfL1kw6tSp2cQ4UdZWUGqwjWTh7PepF7pRzQv7kgEZeuDq45fRx68L6fv7WsaivkFq17+RnabTd8kuLil5SBTgNrwcABvB7VvSWhD8NWgDsDSMHOyki28wRK7GbaGMxvdWIeuif10jzZK4CXfqLYgJ8avuLPyVylkxDYoX5ZKAAI1AWL1XmrcI/5pmE+pNmQSHg
 Uk5M0OGx
 D4xjyoE8Kf5kpZ0QSB/uZennfOZDhQNsjNPlhOrBMmOA/RYlgJCsvBa8eYoLS/0p4D2jXnsIlnYmJq8D6J6+o6WMY1G5ipRYeSQXiwhbljQOFPU+lT0NTBMvcOWdGO5TGtrVj3DqF2DoZUf1EQHltEezlU6sXfVREaVNFgrZfAepgX/yhW6gsUppe2YbZdZeWkw8Ud/V92ayNVk+6INWbiae8TyAcG4d7IcBXOWHVEWSZH0CIKt/Q7hxE5DOsmRwWPM1E/JJvNozcFgDFoz2UqnolhNEbToj7IHXRdf+68IN3TCfyuzwQxxp1fUf59ebs89Ov3521UdHfhm2PUz5oJ4DRi9MDIvg4tk/IeeSZUJOhurq72JkZq8b8OXA7mErji59zHbrmFo5Yp3cRSypFb+lChlNaUnqZ1UMPZFBS5PA0sFc/S0Ia/2XwiPyiLK9xeJ0GuuHpkXSvvUhE39+FQLkz+rCYToCN3zW1a9KAugxyRmndEldRj/+VdetThfv74cEWVhOFMBrAu8FGfQFqpj5cMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 19 Oct 2026 10:06:49 +0000
Shivank Garg <shivankg@amd.com> wrote:

> folio_mc_copy() copies a folio one page at a time with copy_mc_highpage(),
> so a 2MB folio makes 512 separate copy_mc_to_kernel() calls. Each page
> pays the startup cost of the string instruction ("REP; MOVSB" on x86
> CPUs with ERMS) plus a cond_resched().

Don't you always want to use 'rep movsq' for these aligned copies (on any
cpu anyone cares about).
I'm pretty even on some that don't advertise ERMS.=20

The fastest a copy loop is ever going to run (on anything but the latest cp=
u)
is one write every clock - so 8 bytes/clock.
A 4k page will then take at least 512 clocks.
Even an old sandy bridge cpu will (IIRC) copy 32 bytes/clock if the destina=
tion
is 32 byte aligned (not much later cpu double that for 64byte aligned desti=
nations).
So the copy part takes at most 128 clocks.
That makes 'rep movsq' faster unless the fixed overhead is in the P4 netbur=
st
range.
(I was using lfence when I did my performance measurements, it hides
the fixed latency of rep.)

I've never measured zen 1-4.

I also suspect the slow part of a 2M copy is all the D-cache misses
(especially on the read side).

OTOH the longer copy is likely to be better...

David

>=20
> Introduce copy_mc_highpages(), the page range variant of
> copy_mc_highpage(). When copy_mc_to_kernel() is available and the pages
> are in the linear map, copy the whole range with a single
> copy_mc_to_kernel() call, so the CPU can optimize for the larger extent.
> Otherwise, fall back to copy_mc_highpage() one page at a time.
>=20
> On a machine check, queue the poisoned source page for memory_failure()
> and return -EHWPOISON, as copy_mc_highpage() does.
>=20
> copy_mc_to_kernel() cannot reschedule, so copying a large folio with one
> call can run for a long time under cooperative preemption models. Add
> COPY_MC_PAGES_NON_PREEMPT_BATCH to bound how much is copied in one go:
> 32MB, the same bound clear_pages() gets from
> PROCESS_PAGES_NON_PREEMPT_BATCH, or one page on the fallback path.
>=20
> Switch folio_mc_copy() to copy_mc_highpages(): the whole folio at once
> under preemptible models, COPY_MC_PAGES_NON_PREEMPT_BATCH pages at a time
> otherwise.
>=20
> Assisted-by: LLM
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
> On a Zen 6 system with CXL memory, move_pages() gets ~1.4x faster for
> 2MB THPs and up to ~2.8x faster for 1GB hugetlb pages (numbers below).
> When demoting to CXL, kswapd uses ~31% less CPU per GB demoted.
>=20
> Changes in v2:
> - Drop the folio_copy() changes as there is little to gain here.
>   On architectures without copy_mc_to_kernel(), copy_mc_highpages()
>   falls back to the per-page copy_mc_highpage(), which ends up in
>   copy_highpage(). A batched copy_highpages() could help there too,
>   but I haven't tested it on those architectures, so that is left for
>   a follow-up.
> - Add COPY_MC_PAGES_NON_PREEMPT_BATCH to limit how much is copied
>   between cond_resched() calls on non-preemptible kernels.
> - Rebase onto mm-new (2887e63d2e8e).
> - v1: https://lore.kernel.org/all/20260427142036.111940-2-shivankg@amd.com
>=20
> Test setup: AMD EPYC Zen 6, single socket, NPS2 (nodes 0 and 1 are
> DRAM, node 2 is CXL), with and without this patch.
>=20
> move_pages() throughput
> -----------------------
> A single move_pages() call migrates 1GB of anonymous memory, as 512
> 2MB THPs or as four 1GB hugetlb pages. Mean =C2=B1 stddev (10 runs each),
> in GiB/s:
>=20
> 2MB THP:
>   direction         base            patched         speedup
>   DRAM0 -> DRAM1    19.57 =C2=B1 0.17    27.51 =C2=B1 0.78    1.41x
>   DRAM1 -> DRAM0    19.44 =C2=B1 0.12    27.33 =C2=B1 0.27    1.41x
>   DRAM0 -> CXL      18.66 =C2=B1 0.18    26.90 =C2=B1 0.51    1.44x
>   CXL   -> DRAM0    15.38 =C2=B1 0.59    16.60 =C2=B1 0.24    1.08x
>=20
> 1GB hugetlb:
>   direction         base            patched         speedup
>   DRAM0 -> DRAM1    20.34 =C2=B1 0.13    53.88 =C2=B1 1.48    2.65x
>   DRAM1 -> DRAM0    19.10 =C2=B1 2.65    53.78 =C2=B1 0.55    2.82x
>   DRAM0 -> CXL      19.53 =C2=B1 0.08    44.10 =C2=B1 0.19    2.26x
>   CXL   -> DRAM0    16.41 =C2=B1 0.07    20.89 =C2=B1 0.06    1.27x
>=20
> kswapd demotion
> ---------------
> Node 0 is limited to 16GB of free memory and demotion is enabled. A
> single thread bound to node 0 writes 96GB of anonymous THP memory, so
> ~80GB has to be demoted to CXL. Median of 10 runs:
>=20
>                                base        patched
>   kswapd CPU time              4.25 s      3.44 s     (-19%)
>   kswapd CPU per GB demoted    63.6 ms     44.1 ms    (-31%)
>   demoted by direct reclaim    14.1 GB     0.46 GB
>   allocstall                   7427        370
>=20
> With the patch, kswapd keeps up with the writer, so the writer rarely
> falls back to direct reclaim.
>=20
> Other workloads
> ---------------
> - Memory tiering (numa_balancing=3D2) with Redis, GAPBS PR/BC, a B-tree
>   benchmark and Graph500: copying 2MB folios during demotion is
>   1.18-1.49x faster.
> - A userspace daemon moving 1GB hugetlb pages between DRAM and CXL
>   with move_pages() while GUPS runs on them: demotion is 1.43x faster
>   and promotion 1.28x faster.
> ---
>  include/linux/highmem.h | 59 +++++++++++++++++++++++++++++++++++++++++++=
++++++
>  mm/util.c               | 18 +++++++++++----
>  2 files changed, 73 insertions(+), 4 deletions(-)
>=20
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index d7aac9de1c8a..e43459dc58b0 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -484,6 +484,65 @@ static inline int copy_mc_highpage(struct page *to, =
struct page *from)
>  }
>  #endif
> =20
> +#if defined(copy_mc_to_kernel) && !defined(CONFIG_HIGHMEM) && \
> +	!defined(__HAVE_ARCH_COPY_HIGHPAGE)
> +/*
> + * copy_mc_highpages() copies the whole range with a single
> + * copy_mc_to_kernel() call, which cannot reschedule. That is fine under
> + * preemptible models, but under cooperatively scheduled models callers
> + * should copy at most COPY_MC_PAGES_NON_PREEMPT_BATCH pages at a time.
> + *
> + * With a value of 32MB and assuming a memory bandwidth of ~10GBps, this
> + * should result in a worst case preemption latency of around 3ms when
> + * copying pages.
> + */
> +#define COPY_MC_PAGES_NON_PREEMPT_BATCH		(SZ_32M >> PAGE_SHIFT)
> +
> +/**
> + * copy_mc_highpages() - copy a page range with machine check handling
> + * @to: first destination page
> + * @from: first source page
> + * @nr_pages: number of pages
> + *
> + * Range variant of copy_mc_highpage(). On a machine check, the poisoned
> + * source page is queued for memory_failure().
> + *
> + * Does not call cond_resched(). Under cooperatively scheduled models the
> + * caller is expected to limit @nr_pages to COPY_MC_PAGES_NON_PREEMPT_BA=
TCH.
> + *
> + * Return: 0 on success, -EHWPOISON if a machine check was handled.
> + */
> +static inline int copy_mc_highpages(struct page *to, struct page *from,
> +		unsigned long nr_pages)
> +{
> +	unsigned long len =3D nr_pages << PAGE_SHIFT;
> +	unsigned long ret, i;
> +
> +	ret =3D copy_mc_to_kernel(page_address(to), page_address(from), len);
> +	if (!ret) {
> +		for (i =3D 0; i < nr_pages; i++)
> +			kmsan_copy_page_meta(to + i, from + i);
> +		return 0;
> +	}
> +	memory_failure_queue(page_to_pfn(from) + ((len - ret) >> PAGE_SHIFT), 0=
);
> +	return -EHWPOISON;
> +}
> +#else
> +
> +#define COPY_MC_PAGES_NON_PREEMPT_BATCH		1
> +
> +static inline int copy_mc_highpages(struct page *to, struct page *from,
> +		unsigned long nr_pages)
> +{
> +	unsigned long i;
> +
> +	for (i =3D 0; i < nr_pages; i++)
> +		if (copy_mc_highpage(to + i, from + i))
> +			return -EHWPOISON;
> +	return 0;
> +}
> +#endif
> +
>  static inline void memcpy_page(struct page *dst_page, size_t dst_off,
>  			       struct page *src_page, size_t src_off,
>  			       size_t len)
> diff --git a/mm/util.c b/mm/util.c
> index 7f374bb8bf36..5015cfdfeaa5 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -763,13 +763,23 @@ EXPORT_SYMBOL(folio_copy);
> =20
>  int folio_mc_copy(struct folio *dst, struct folio *src)
>  {
> -	long nr =3D folio_nr_pages(src);
> -	long i =3D 0;
> +	const unsigned long nr_pages =3D folio_nr_pages(src);
> +	/*
> +	 * Copy the largest extent possible to allow for architecture specific
> +	 * extent based optimizations. copy_mc_highpages() does not call
> +	 * cond_resched(), so limit the unit size when running under
> +	 * non-preemptible scheduling models.
> +	 */
> +	const unsigned long unit =3D preempt_model_preemptible() ?
> +				   nr_pages : COPY_MC_PAGES_NON_PREEMPT_BATCH;
> +	unsigned long i =3D 0, count;
> =20
>  	for (;;) {
> -		if (copy_mc_highpage(folio_page(dst, i), folio_page(src, i)))
> +		count =3D min(unit, nr_pages - i);
> +		if (copy_mc_highpages(folio_page(dst, i), folio_page(src, i), count))
>  			return -EHWPOISON;
> -		if (++i =3D=3D nr)
> +		i +=3D count;
> +		if (i =3D=3D nr_pages)
>  			break;
>  		cond_resched();
>  	}
>=20
> ---
> base-commit: 2887e63d2e8e0cf55402612d8996ce955a2c3e55
> change-id: 20260714-batpagecopy-5a2b45910e5d
>=20
> Best regards,


