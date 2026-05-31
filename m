Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD700CD4F54
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 00:14:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B2416B00CC; Sat, 30 May 2026 20:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262FA6B00CE; Sat, 30 May 2026 20:14:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1789D6B00CF; Sat, 30 May 2026 20:14:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 094406B00CC
	for <linux-mm@kvack.org>; Sat, 30 May 2026 20:14:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F66A403DF
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:14:52 +0000 (UTC)
X-FDA: 84825794424.07.BD1DC70
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id BFA6B1A0003
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:14:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YMSUURqr;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780186490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6WHUv35EmdQ4QWk4JR3Y1fgG/+v8aK/cHw1Gj0rc90=;
	b=N3LucMx8OA/94F1qkIKF0xwXUlxZzluTrphx/3OikzQf4b/6QGAF7cxOqBvwkmZUSYzmj0
	LhdYy/kAjh83UP05vqebenpE54D12HhhE9+1P+wS088P3E4Oypu4EkZcEjRaa4i1XGk++X
	n+A66vX4EoaTZGc+rWc//ULVsMGrgtA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YMSUURqr;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780186490; a=rsa-sha256;
	cv=none;
	b=pgB51cFwGnlBVwUF9cYmekQbdGVGoFMcNtkWgrx3xZlepqI8ZREcbwN9TCxEG0BERCRRGR
	BkBtH6XE6z1qa8DNLdGOEoHMgyVqyWgFeY1to2+1KDye7dC+KVP741VRg/L8IgcQXS8gqS
	TI9Zk/S6hibpYukTTTzgONNwIjDOzEE=
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7e5fd39cf11so7701187a34.0
        for <linux-mm@kvack.org>; Sat, 30 May 2026 17:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780186490; x=1780791290; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z6WHUv35EmdQ4QWk4JR3Y1fgG/+v8aK/cHw1Gj0rc90=;
        b=YMSUURqr2h1GW0CoKP/OsTa72sM5HQj8z2m0rgcpcG96YH+DeTRkLsWjvBfRh2+Hqr
         RhVy5j/nNhSOEGxWlgFqQSopF7bClKhCpNH+s2CL3SV5li5tO8B8AKCe7XcC9wttk4c5
         wy2X6pFwc3B15WryhDLqNdA1V/FlftL/j5gITqlqMK6aw0a58dLLxPFrUuI4+WMDqqnU
         eUSrVRmjOM8J9A7V3L91IS3L+FLR7PwOe4O2TZC1FkHslaO4WW2WF4K9+rwwrRME78Ph
         uF5nBF7pSeOSMmyY+zXbBX6ZDd+6qRbvEuc1OyGWHFFGjX0XRAfLoJHdcAV3iasJITsf
         rIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780186490; x=1780791290;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z6WHUv35EmdQ4QWk4JR3Y1fgG/+v8aK/cHw1Gj0rc90=;
        b=SO0fYca1FFBxynT/WiJqiRls00jCNCuGgA/Icvo26pz+S5PcveCHHkMmHIy9LcL4s2
         qFBVdgn2qTmAhsLovW3BzjzyR8uqWQLJzl1ATHH4mVrilaCtvBIG9RDfCktV3HHoyqNl
         +wHqk65+PS6gnAdI+r2rLYcBRHGrs0NjEUIvVzH0l3iCouE0PHCjZcj1KVqtqUIheInl
         wr33fv9ehC/hPPlPSO+jUjV3ojQP7vOGyPBUCvnSoW/IzGWIWS337U3fOOMuPXxmNx9Z
         nWiUZafT6+vdmJ2GNn0oVYTES1xnIVFOKvrzRNRymP+JgUt3aI4Qhk91hMlptbGNmGhT
         /Irw==
X-Forwarded-Encrypted: i=1; AFNElJ9uzOTGOOCFJQhWN0m36gq4w/0g1Hz798fNZXrwDTtBSN2BT4vop9fdU1qWS+KXXxESkgqTi4xrRw==@kvack.org
X-Gm-Message-State: AOJu0Yw80imo8DcREJQmeDCW0EAL1MPdPEI6gHbm99bLCKNgltLW38Pj
	LqGqSUEyN+LGZ2tZScHr3G/JazlQXYpizm0/e/1l97RD/JivL3bWoN/6
X-Gm-Gg: Acq92OGtuZXhlHW/bMmbQSpxFC9uA9OXU4OdA5bVTta/N33de6s+jTIE0PWhFVLkAmP
	Qq4VSJ5NpWgN0pjJplBo7BjybBhanlFlTibxpTA/dTR1m7haV+oq/PjaXGS6rpJITD2RvGFOo/5
	LjXT+NriPScxyDxGr8zFJ5t8ZkUCggEQ/7d5lmmnUUXTr4BJaseyoqRoyXuzxtC/o1vS6XYq6gI
	RqoRBzp3uVUNwn70IdI1iRFFJSkj39EYVGVt5Uz5MNWoYkTdyKGdTruvzmVaQjpOnaYWDqX2LPi
	6l+SrHeeYenTdwJviDtxEOQCJmoccxLtcHZrV5lxsCwSf5J+MBQcdfUZyABA5zB10olpVWqLKUJ
	d7J1/RLU+P7/JPOYohWjvY4h1Mlfld1MkeQV+3XTeQgQIMSNHFq2GiXshnLEGuq1gRcupsvI74G
	KecE/Tv1t88tfXrM3sPyyFV+/H+yqdmQCH7Nr+/783qP4UqSJHGQvG/sS2jTsMMzBJZ3dBBYfcE
	5QezLP+XJoAZ+xK726F3PV8Yl4o
X-Received: by 2002:a05:6820:1c8c:b0:69d:7a88:9cdf with SMTP id 006d021491bc7-69e10469737mr2718415eaf.15.1780186489512;
        Sat, 30 May 2026 17:14:49 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69e069b55ddsm3918373eaf.13.2026.05.30.17.14.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 17:14:47 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 30 May 2026 17:14:45 -0700
Message-Id: <DIWFFX9PVY0Q.2CKQ7GZGFW0TK@gmail.com>
Cc: <daniel@iogearbox.net>, <andrii@kernel.org>, <memxor@gmail.com>,
 <eddyz87@gmail.com>, <david@kernel.org>, <tj@kernel.org>,
 <roman.gushchin@linux.dev>, <peterz@infradead.org>, <linux-mm@kvack.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Hao Li" <hao.li@linux.dev>
Subject: Re: [PATCH v2 bpf-next 0/4] bpf,slab: Introduce bpf_arena_alloc()
 kfuncs
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Harry Yoo" <harry@kernel.org>, <bpf@vger.kernel.org>
X-Mailer: aerc
References: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
 <7f62762d-fd91-4c07-9917-7d977441e17e@kernel.org>
In-Reply-To: <7f62762d-fd91-4c07-9917-7d977441e17e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BFA6B1A0003
X-Stat-Signature: qtko531reftwzdj188t7zw1psqooha65
X-HE-Tag: 1780186490-90524
X-HE-Meta: U2FsdGVkX1/fPq1SGBbOBTExT0mEAhx2dTtgOoO9RW4UAS7RErwSUNitsb+5RGzOlYQbeH7P2kBY03Qhnzts/8A5O32cY0ehOL3EZYoT/NXwhhsZGLvESVI9M6kBG3vcEUwoM3nS7/1xT8erLPT/kpfMHaNHQbufS7y9IdBMIrhpFgBa19imDZl2jW9m1gleSAPJ3YjWUozfu1PNKEsHWTqM23EqsiMz9OqW+bZrkBkFd6x4yTExP5cCU0kjjWqC1N9biR8HmjTGQxGCkcng8DdbglK9hAFD+95o6yXXPP3OxdYvN+gVof20yjjPn9JTjU5xOXGxkfrF/sh4GjdiVzUpnHCHBkYXfYXFWdDZXrIpv4OGIzFqwH43HvlKVRHadUpiXCh4qwHnPVJ20hPhUgekRd0QbHZoubF8hL0E+y5CfeBszH8YED969aL/pcHx73r3KCZzeztLtfRed5tw9tVSrk0vqXNVw9IXLGy84wlu5HVx8uv4V0vwAS4XvOgkBtxO1slFHP5Jxf36FLYFiadLi6NqNDqH2knL95k5HV5uVFt1Wro0ySgI0e/B4lia5ecPL0TbL6eT01Kv9jMAosmMh1NcLxIX6hvNLSlEI+T3ptR8DZGiVnZnKh6KUu9dRijfP2UKsehPjebFwScYZZn7FS63qXooCa8PsR3v+SX6OBuFSfWUDlquX8Tz20T4ue/TyzYR5RHoU+h3P6ZXYLXV6i+tj/1EBtACqBZ586lvGF9v09peVAoICRwqn+JTwS92nQMyRFPf4miFjLEbU+AjmjwOjlhSS2wMD1yrOIB9xApLUw6XItDBxG0xnR1//uPfnDHbHatM4NMPM1HkN7cbk4Sexd2hwwZsDN0gB/WPJZRgZp+YDQB3i1TDGcZxSCfG9IhuEkfTf7p26Kk9p3iWPGqtkKnMAthFAo9hZBVBPpI/ejMgO756wjZwPeIktRVL4PUsrRmeP0diZJE
 e7NaX4dD
 m1UCm8KgPoKAb3Zuka4pWk/xQKFM7qcu3K0KZ0PH8JqDf7L1tZKq9tfK705mUawzRMtUKsbVbVgmya1hrqFqywxrBy27h2/HoVHTiPlPaJpQOBG+WRRGWGQC30D3G1zfMy3GQYv2ekb+UPTIwHN/spkIEdmRl9fc1lZ+A/c/Np7lsgQGMnGUNSnY+FAF4Q0fii/UAqC5mxliIICls9lWHaf1nSZyUge09PJtQDFHFOFS7KFuGPorGXOmCwsV7uTtEL6OUOXoxfMUjlAymMk9SFNjGT9YuzRMG5GlcQIalNAB8lPBaZVYixm1QKdE8oThhiEMLMZ9mKIRp4Qd4FYuLOK1PKxg5GI26+nJ8ObO1HPnFp7soloPtUazQ66hqfwsqP0F2/ZYWlj7kEneHP1Tx4RQ7ccdQwsXdchEfDsRCdP8IjPG8IdJk5BMib55woG30JWUTUKlxbgO0N+/MXdj95Csq+iA1Pa9JDoU/N2BYLwnCRNcakWxcV8F08o2OR5tgmcpQ36dIvtAcmqpB4ru90NvVKcigkbawheMK75bmP6JT7g7h4ZlfPVXmGvBWJapVSKoK02GmfccdA5X3OcGHuzFz0/BoVZBuFbKLrcsowdmk7DVlb4pNl0LZJ65Cqwd9/L+U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri May 29, 2026 at 9:12 PM PDT, Harry Yoo wrote:
> [Replacing Vlastimil's and my old emails with new ones, and Cc'ing
>    Hao Li, who's a new reviewer in the slab subsystem]
>
> A bit of background for MM folks who may not be familiar with BPF stuff=
=20
> (including myself!). Please correct me if I'm misunderstanding.

Thanks for great summary.

> BPF arena [1] is a 4GiB area shared between userspace and BPF programs.=
=20
> The BPF arena can be sparsely populated, and therefore the kernel cannot=
=20
> assume it can reliably access it. (There is a patchset from Tejun that=20
> addresses this [3]).

yep

> Since BPF programs interact with the kernel through kfuncs and=20
> struct_ops callbacks, ideally the kernel wants to share kernel objects=20
> with BPF programs; however, you can't put kernel pointers directly in=20
> the arena, as the verifier won't allow directly accessing them [2].

Right. Technically bpf prog can write kernel pointers into arena,
but they immediately become untrusted scalars.
So no access can be done through them.

> So=20
> the kernel instead wants to allocate objects from the BPF arena and lets=
=20
> BPF programs access them directly instead of current workarounds=20
> mentioned in [2] and [3].
>
> sched-ext is going to use a gen_pool based allocator [3] to achieve=20
> that. It works, but we need a more efficient allocator for BPF arenas=20
> without re-writing the slab allocator from scratch.

yep.

> This patchset achieves that by enabling SLUB to allocate objects from=20
> pages that are mapped to the BPF arena. Since the kernel cannot access=20
> the BPF arena directly (at least for now), SLUB always accesses objects=
=20
> via the direct map while BPF programs access them via the vmalloc=20
> address space (kern_vm_start).

Right. This design: slub via direct map, bpf prog via kern_vm_start
is done for performance reasons, so that bpf_arena_alloc/free
can do page_to_virt() and virt_to_slab().
In my earlier design I used kern_vm_start based addresses
for both (slub and bpf progs), but it meant that bpf_arena_alloc/free()
needed to do expensive vmalloc_to_page() translation.

> Given that BPF programs can access slab pages in the BPF arena=20
> (userspace programs can't, see arena_vm_fault()), one interesting aspect=
=20

yes. had to disallow mapping arena-slab pages to vma.

> would be to make sure the kernel avoids panicking and falls back=20
> gracefully in case of errors in the slab page (while maintaining=20
> reasonable performance, of course).

exactly. that's what patch 3 achieves.
slab needed very few changes to make the whole thing work.

Don't confuse this slab-arena with orthogonal work to
introduce call_rcu_nolock() and typesafe_by_rcu_tasks_trace
to remove bpf_mem_alloc. These are two different things.

