Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6535BC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 11:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E2A6B008C; Sat,  5 Sep 2026 07:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676056B0092; Sat,  5 Sep 2026 07:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C336B0095; Sat,  5 Sep 2026 07:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31D226B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 07:24:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C061D40320
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:24:58 +0000 (UTC)
X-FDA: 85179476676.17.5A7C43B
Received: from mail-wm2-f6.google.com (mail-wm2-f6.google.com [74.125.225.134])
	by imf15.hostedemail.com (Postfix) with ESMTP id F351FA0009
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:24:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jVxwuFW5;
	spf=pass (imf15.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.134 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788607497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B91bvzotjFUcMw1qyxQVrgtsCG6I0XEyZUoF6bsDVB0=;
	b=XDuyXyqKgecD7ZHvuQAcoAnvCdhV1dQner3UVjRemCOFw3DUztzOnAvg0FG8BsirLrur1b
	2/Ql2sqY0hXe+gQtZSQss0uRTzN3rsIOwfDQKFRtxhv91li/FkMUuIp8UxLryqr45ouux1
	qe7YBmi1s667Z0pPo2E40OAYaygPbIw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788607497;
	b=2ubdmUFME/X+nI/0sa7UlswHF/k9/oEXqsT/ApbZM5q5tkgPFeHG30uG0ng0qGlTqrQA7R
	Z1aJs3ozLV9pmbN76Y+ZOj3NRcSVwjRlcRAyul4gbNddk/CYi/A/hnL7Qd635QzLk50N0p
	NUOBsREYF5l5YtPJaVe0b1iG4y/E2uk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jVxwuFW5;
	spf=pass (imf15.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.134 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f6.google.com with SMTP id 5b1f17b1804b1-499aaf0a723so6788485e9.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 04:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788607495; x=1789212295; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=B91bvzotjFUcMw1qyxQVrgtsCG6I0XEyZUoF6bsDVB0=;
        b=jVxwuFW5tLy4Pidt5KZHL2v84PPq+72EO3tcFIU28ye724O6bCPeT7cQ71JulyVXm7
         m7iCvR5N0yWgUK+HD7HBWSdUJ0VKxY1588d0G6S9tpdDq+NRML4XoRLwA9dVV//D2cmm
         kuyt1KoyCm+cLPyQobnQ3/XQ6Nfvtpc9K01P+u9d37ZZCAJfncS43TSeiRuf09ZkK+OD
         J6lgPPFg/bdqW43ujFC25CsJKUq407AIpGfODtQDJCBTZvHSIMTYeL8nGVqDwZcSYSLi
         Bqob3TWs8FHD2gmsOaYC+b+tgTjD/TAvct7l2EYUWjstJc3ti9b6CMpi91IY2FLypHyo
         fPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788607495; x=1789212295;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B91bvzotjFUcMw1qyxQVrgtsCG6I0XEyZUoF6bsDVB0=;
        b=j9XydCumpcHeBUBBwJpoPt4ts0AvLymPDZ1LTafVzbod3dGcwhGcg0i5+AxyK+gYQX
         nGtdmrckp8cLPu3lutAR7FAUTipjPkr7Qcao5JXF3wQ2alB5ehd7lkN5ARqAD07W9wKt
         InXu7yMJ6rBUVIzxcqMA6o1DiwonSccZL/6VqXAfXwJo9Ddrj/5GKJSTWw0XQFiErV7h
         dtw9HaoScYw6qXRto5DYlz4sUcBRuQcnKv6kX7fmXaH0gn110BNaEy4wWqkM69iyKEh1
         OvqE+DtcAAp13j1a7v3/FIZn30Rg/MSFjm7Wu5o6ZSPnp7Uahbl7pBdoHyqoTG0bB66/
         Ea1Q==
X-Forwarded-Encrypted: i=1; AKwUvByzfUNEQyIkBoPxkdfMXJWV9xngLYVATD6dOUkfvfJeEFbtAShqf72HIH9F9OEoA9NyLw2/ZwKF2Q==@kvack.org
X-Gm-Message-State: AFuF++no/GfnMBmtjc5L7kik0CHf6OH+d53RbjHRNDgzh372QR45Ih2c
	zd2IjcYIjBxCA7LQilDOdjcyE/09TXd83ToaL7vcmKXNTvrKaKSGxua+
X-Gm-Gg: AYBFou0pcTRDr2d6wlNiq6OBdtFPFCU4kjlfRqSxUEcx50kQLaXYgfKavDiO0VjwEJJ
	Dk+cDitOcBAVI4XYrIIeNb+SvWbPedf62PTj/YWlhDxDRR/00ILzgbUkzET3qFdP2Dkx8vU7/6v
	UIFRerQHIBnOZweZEqDVa92p2fuhng4+JJGZujAxTPnkobnyEbksUJHYexpi2PpBHp3mbEA6xfY
	dwjB9s3GP8WsDazn/KkGi4o0Clznj8sfMOBNGfjEdpCnLtIOQSumzPTsY8/f08dtfWJI4JFL6qH
	uwosZsTtVLYm6IXX3mRbAtPOp8V7XQkgk59J04JjqBoaCEVVvPBhVxCTn8WmRpOrP2ru05TD5rS
	icrE/mcnWl9cM/OttoWi9XioSip09fjH8X9sVFUhjCl5gvpF9oTIThcxu0ccxktFWUF92flpEVr
	7QFGEByDw6HR/tdPZO7K37mOxzqaFx7sGy+7Oap69IH7Fxf9MVpmuU4WjDWavGMcIlo+OkGsAsK
	SMmkNWYVPEI1xt8T1r5Drxoj+wXYIZnmsEVUpJL+ZjgVnH/arBfAS6D0k5Wr7KttcIoFPw+zIm5
	vGSnWLVky+mGHFbDyC8nbjcdOcA=
X-Received: by 2002:a05:600c:6306:b0:49c:f5c0:aa76 with SMTP id 5b1f17b1804b1-49cf81e366amr268925475e9.5.1788607495209;
        Sat, 05 Sep 2026 04:24:55 -0700 (PDT)
Received: from localhost (nat-icclus-192-26-29-3.epfl.ch. [192.26.29.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee6023d6sm225255635e9.8.2026.09.05.04.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 04:24:54 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 05 Sep 2026 13:24:53 +0200
Message-Id: <DL7CFVDSDV92.1VPGNHDCKVVIV@gmail.com>
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
Cc: "Hui Zhu" <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v7 0/2] bpf: BPF-driven proactive memcg reclaim
X-Mailer: aerc 0.21.0
References: <cover.1788516769.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1788516769.git.zhuhui@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F351FA0009
X-Stat-Signature: 8zb3zcxfjf1qtddgg1kjrthec79wi47t
X-HE-Tag: 1788607496-61876
X-HE-Meta: U2FsdGVkX19DX3bXi4ya8ufHzXiHvE9tL+fI0EGt11H7v5dzAOhlhyrHJwde2KC8dHgdnaB3HzOWNDpFCfS12NmKV1xpIeJNIayzYxhrjCDFJEz2noZ7XBZrK0+MPO3FV2Dsc0RhPCwxGpAhdKbrlUGhy9ZqmPF2HypohVrBaYR9dobTRVa6CwFBruW8rgM1eanfa4xvzyLRKDSmY9Yo3iNfeJLqavETaPEVyPZEilUjjLHQrq1OnYBKtY7jobVjI/Cz71yTZ6n5tOUTpljfiWzTbY4FjT87JqVaugEHnCp6th5IMdryI5YdHfpaWftZYlVGKfI2spE3rSnS1w4DD/V8eqnqCrGADgOgF2NvK12tBihAMAPBbU3bXV/15JLDADkXse0R04FLfNgW9ndsV6CvauFnIm+x8umpWjGLeie3ByqD0q2oYBmS90feU2O9NzoPjqrngGVkmbHhOu6zQRKaSDO+Pvc+FVJgRuGx4bDCg+uOmB0eHODBOgi3X+3qWVyCOiLlmZmgwldA610i+sEQviDeIcjslJCHI8MEOBe5wR4JDnrR+eGQW3Z+GNEeTeP/QNtuMCKoZ9jmMEqJm2Mn6vWRTXl2Y4X5Wb9WmouEhxtSeUqiGH3ozsRZPTWA4GjrI67vJ6jKxM2/y7wT6SwunFsTQFlYlHtsAl9MavSuSqOZpdVmIbJ1qwOei1BSWb6Nn7mU2ZxhoH7kAaVPtXQW1zHR28aTCP1ZTimdspTC4qW07JGZqXzF5ktNfLDcYy60TCvEDMAhHDh/0xWwXky1fcNKKcc00mFt2QlBXSXkYXPpaxSYTUJUNSRpMCZQjgAbnTLEk1Y7YRd2+6kIIQGCzK8wjZr1511G3CMCsRvHwbF3d2B3HIHJv50Hh+AOy5Th+hr7+S8VJQuIOmbr6DVCoAwLhnMrp9naT3mQqvTE4V22Vq6IQ5FCNO942CcawbsJLoBnchBYacrPzIc
 05k7AKXM
 nXN1UZPMv3RNRR1RyJk+FonJ9MPeYR81f9VhpNmquK/poOlmN/M6H6z8/fwr6qC4+L66X9oPXSh3pAzWqjAanI/N+l2aioAXmaHQm2Zf6NiGoJD/aQYp+nJQkHHHRey4NbW7t7jJ4rTVSXRfj16y7xj1itGgirERXEKbGQrv+eDfKr/zOasEfiYGGW0xyaDO9mgQ4amRqFeDSvPsvMRT2v0xx9oaY6vcJ7x+ylHoGq6VfqURfzLhZt8WBd3Ifx+46mrW67dQPRkRTFjGVh4jEV+o0aRIKl1JUY/Bwo786i/9exZNbI+/gmc3G8DkGkwpvDEUvaVyXSo/HERItYvK4Uz9G5orrf6iMooYUZ/pfOQcnlh69WihjQMLZbI8yPbbfvQeJ3Txwq/9kEHLp/a0JOF02zdTwRmgrOofYfGjYL6f5IJBG9vM9MhQusMogC+Ym0LrZSLzIKbb0sNjvU9nVA2uBwn8dKipKoul8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 4, 2026 at 12:20 PM CEST, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> BPF programs can observe memory pressure on a cgroup (e.g. refault
> stats via bpf_mem_cgroup_page_state()), but cannot act on it:
> triggering reclaim on a chosen cgroup requires writing to
> memory.reclaim, which BPF cannot do. This series adds
> bpf_proactive_reclaim(), a sleepable kfunc performing one proactive
> reclaim pass on a target memcg, so when and how hard to reclaim is
> BPF policy rather than hard-coded thresholds.
>
> The kfunc is restricted to BPF_PROG_TYPE_SYSCALL so that reclaim
> always runs in a clean process context: generic sleepable programs
> may execute with filesystem locks held or in NOFS/NOIO contexts,
> where the reclaim path could deadlock in filesystem shrinkers. The
> bpf_wq and task_work callbacks of a SYSCALL program keep its program
> type and run in process context, so reclaim work can still be queued
> asynchronously through them, as the selftest does with bpf_wq.
>
> The use case we are looking at is protecting high-priority workloads:
> a BPF program monitors the state of a high-priority cgroup and, when
> it degrades (e.g. PSI rises or refaults increase, as in the
> selftest), asynchronously reclaims memory from low-priority cgroups
> via bpf_wq and bpf_proactive_reclaim(), giving the pressured cgroup
> more free pages.
>
> Another use case: several vendor-maintained kernels carry private
> implementations that trigger asynchronous reclaim when a memcg enters
> a certain state. These exist for historical and partly psychological
> reasons, but the underlying demand is real. We expect BPF-driven
> proactive reclaim, combined with the BPF hooks for the memory
> controller currently under discussion and development, to serve these
> needs in mainline, reducing kernel fragmentation and improving kernel
> maintainability.

From BPF perspective this looks ok to me. I saw you dropped the swappiness
argument, what happened there? I thought we agreed to just include it in th=
e
kfunc now. Did something change?

