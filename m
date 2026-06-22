Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BC3DCD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60F786B008C; Mon, 22 Jun 2026 09:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E66F6B0095; Mon, 22 Jun 2026 09:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5886B0096; Mon, 22 Jun 2026 09:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7406B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:15:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9EEB8A0184
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:15:49 +0000 (UTC)
X-FDA: 84907596018.27.65D5C4D
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9DF5220009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:15:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Cd51jHno;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of jackmanb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=jackmanb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782134147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1jdgcb1GTzI/MFxGAxn8bD+AX0AkPgc9MYjNjyFClw=;
	b=sSkr4oXMDtMZuQPUhakOPKVQ1ZgTqdzGUi5H3FHmIoc8g2TVEMeUDS0rVTnTlZz489upA+
	cCMLEus+XAfcP+3g3R3EtdD8StO/l35JQIzFItLTAFam2tC6S29r46VW1Om7Db3xPwxu9o
	/dCI2NXhl47NAPemMQiIi0H/Fdt7YJg=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Cd51jHno;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of jackmanb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=jackmanb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782134147;
	b=c10YoFOBJ58vRgCn2vvk6ZKr2qkSdf8NAEyJxDavu0nIbEp0BaEgC7jFXRk0WIP3iVD0zq
	5aVOXKpefnRicRPAfXYDOwlE/Eg14Ng9hgBhDmgbxEhzSJaZNlSkRS1Ui9Eg2Mp1InaCL4
	RZqPxz9cd8jr/Ys6CCEflw2DLoNhaX8=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-695469b574eso21340a12.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:15:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782134146; cv=none;
        d=google.com; s=arc-20260327;
        b=MOSTwdqpyPF7zO++nUic7/ggk/dM4QtdYa2gQQAdyslA5+JkePZ3gtta5C9RUreCfV
         0n3M3KeU7Uo7lA1lmG1x3/TfmgDxhToSq1V0E/Yawyb4tbZATRGYWyfMiAhZ9cokhOfF
         8sIgnzS7bgJasQmw58ExbDQ0BwTy5rKSvhvQ9lkIEvUBzs0Ke43R6dbU89Mwt6O4Nn2U
         MAycwtgb2U8AH644wAqWvSo4B3hsnWbJea0G2kBYE89FOPu8tgZ76UcMqV+waQV2q8SS
         tDLmm1kBnosDeZEIQlhINT3zA+Y/4Z/DKeImWD5TL9FpSQt4M4hh09F/ovgbQk/x/uSi
         omYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=w1jdgcb1GTzI/MFxGAxn8bD+AX0AkPgc9MYjNjyFClw=;
        fh=8XwMv3Zzyp+2ZZERd58K/x0sRmAcJQVA6v5vlFqBWCk=;
        b=FFET/cYc5yP5KG9jbe51HC8ka8OqhRZL0u9FPXpwzcVIROGLhWzmw4MtsOdtXQotpq
         Hr3ns2zBnsM8pKgtHs1HntUN+zlgsRa8P+V0ASmWZ0yVwUHWmyUMVm9quGXvekCR39Us
         PGglVF/VzDN6AkXUSbydnFQJIcIY1FZ+9y1EsM0ULVGaQ8o9O2ExQhpa5gbnzEtICqO/
         jkoab7/Z/L/RKeLIm5olWQkyKgr9bwBqTrFVtd+gM3DlXi+hrWStvf20kl/pVNzuHgk5
         CyHiw5XrnMLOO1e1dVU4VYGgTUooq4HBmNNt86oYfE+Fhx9yQDfHwVmR5wPLlZ7gK/Ez
         0w7g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782134146; x=1782738946; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w1jdgcb1GTzI/MFxGAxn8bD+AX0AkPgc9MYjNjyFClw=;
        b=Cd51jHnoPuqDREIQAA3HyuFBQN2aJCqfy6/6xqJktBBs574zSh/q3s4ugD8pOkqctR
         twS0rgZ8iwR16mNttjxjIqxIg5BBipA6/M7xJU09dAlpJ3TsBuZkp43OsAeWzR1GpyOa
         CHcrT9c39xLMWWnmaJky6dkxYx1ZFDTFT4yunBI6ANx3puWkVbPlORM2gOz0TwqE4RRp
         eYnfXCWWTsitRBquDrtxZ1Akq/am08ParVN3pG9/LS17ea27UD8J1mFHfeTA5wNNjg/9
         DnRoJB+e6untcDNSaxNxUOuXXXvyVjzpnFa+ZSx8/+M5prQudnuDWkp1FkC5cq3B+5rB
         6kXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782134146; x=1782738946;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=w1jdgcb1GTzI/MFxGAxn8bD+AX0AkPgc9MYjNjyFClw=;
        b=bGUtQLcliwcaCGjwY0DXvql9l0PxSFNDFFGjcY6AfzYEYR0+yhNujmaQrNtcZuEMci
         vuevs7RVaC7/uakEycU58n6VvS+SixPCsXQhPmofmwAdughafSywVgR1/qzHJwluP/6o
         AHWtGCLS7wjUjX65Me0TBuFN/JspuH33NzOK09YMWS+kglrCMigFjzk3iIjlOJMCQ4b1
         jYs4Cp3is7/0ZhS1KyJSspYDaqpShdXb9qTvZAZV53aNL52XUMEXAwTy6N907xvt70e3
         7viUIPbjA1+PwFMYiSukABMlWYKCBtPVWvtGruQ99BXsFxOb2HW0Q5bOrp2Rhptg8OnN
         3w9A==
X-Forwarded-Encrypted: i=1; AFNElJ+deO72clonhxlAMlt0oryo5wgftN/j4qDCBtUEeIFiJ018k+GSFrBdCgYr24Qxc9CRI772Lon/uQ==@kvack.org
X-Gm-Message-State: AOJu0YyVOasiDolWDO3YmI+ssYC/p9CC7DhTGNZJr8dxq9BHWRFuILMv
	ZaWDJMgjx0/giJs/DCG5LIgmiXD9bCl3dImt0IhIkLSJJKW+I+7oFjHeg0JSwEhaKFCRaaSqSKA
	yqNKPUuHKIgKEKRzH7qsPwqDsnOa67CCcw66mXApH
X-Gm-Gg: AfdE7cmlbir+QISW9ZgV4t+ZSZPCY7fh0tRfgm5CvW6rkANIZdhRT8j42lHpzbH9eT1
	DQEfgAiHnJePdF1fAETboyVDhZq4U178pJHVrxw66cUPQEDx3iPjCq5OAomWGXWH6DUHsL6WXUE
	/e92v2k3NLX8ApiI9PoDOR9DT5gOtiqHBh0MZVYsu+pSk8EIlsWy1JjojXjNOPUkT3d+LqISH8S
	MZbL86nAvKYJBTfTXj3QkfjZACoS2beTXPtGN041RRe9B7dwh9XEHn7RWyh+Un7RCqczTzh7yh8
	WDGPU1zo9348KUeAL9GtKryeq1Em0MMilwjm
X-Received: by 2002:a05:6402:5154:b0:691:6fb6:dab2 with SMTP id
 4fb4d7f45d1cf-697498d9fb0mr119450a12.5.1782134145476; Mon, 22 Jun 2026
 06:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com> <ajkzGElCGxJt-s84@lucifer>
In-Reply-To: <ajkzGElCGxJt-s84@lucifer>
From: Brendan Jackman <jackmanb@google.com>
Date: Mon, 22 Jun 2026 15:15:33 +0200
X-Gm-Features: AVVi8CfrL4Oxj7BVaLIKs0bu_A57lof4blIfUKooVGhj0U4uQfgaPE2LZeA5esM
Message-ID: <CA+i-1C00oZP9U4CBPkq5txH=cP54mypr0sYJU1t7pgis0envQg@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] mm: Some cleanups for page allocator APIs
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>, 
	Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Robin Holt <robinmholt@gmail.com>, Steve Wahl <steve.wahl@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dimitris Michailidis <dmichail@fungible.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: n8y5t8u3798cpxedn89mgkcmh3bzoq4x
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9DF5220009
X-Rspam-User: 
X-HE-Tag: 1782134147-531556
X-HE-Meta: U2FsdGVkX185vwsW16bAJK+vQIQdCyM2OXKS1LT3auLA2kEEoAmAO2xKlhGnoB1lR18fCSO/fTAmpcDmkXiKqBKVegMeE/6njq1BzRfEejnicsE3QfkLElg043JLCpGSP2OZih1qe5QYy9NvxJGp1q/UF/8f5RNQkkitBaugdcwD6lxp32X8LWqEN6YUX9YJpMPhS++Dl+p6cu2IQVH+uiiehzUbO/QDx5v+ig5YAfxaUlUF0MFdA9s3xthlMxADT4HBdsW+E95tC7QM6p4DMRQkPm8OqVccrp/jAEJK2awpXTkc9Ty+MinKcEGt2q1tQ6r33OcPCJs0IqAT0Z22je/DQrbp8YqrHX13ShBFwBgaQILsE/IdbrZaI8reFTnlHWsUrn8RlcbEpiM636iaxTF8ZozAud3QE3jDGb7gTtkbQcWWWk2LLxx+bzHqssD0bidUU7iUn5+YtTKKW94eCot1ycIldxCzEdrfrVuPDqz4wFMtX8m7dMRlJ6xW+TsuSgdr7dKIMJ1w8mqGErW2W70QAPQzSl3CLaxWKytFfRk5hnKbHbdyjE25N4TvZZRB+KJ+4Guc8rB9MgBy8n6ja37NBU5rsDx62qz0zyRRvbo+ylr6G4EDcfzSH5EBZBNIAIbFdQaLzB9LpNe4MUV+Vp2vX/PqN+Y7Ow47oBKMB3tq2XccNWeSR87Zkf2Ga3TPVGO64bIqxl56dhu5Qvw7nnqBHCUcp58kQL27xCzBeCc2PW/NnvR3GvB7PU6FOq5uQOYdk+n85JCpb0fmIRfMd1NxAdJJJbqZ0k0lyMJZboI9rzrHlR7worZhzlfihPyOi7kjxvpUZ+FKyl53aNp5tmIobqbdGU/gDU1OuS5ZdHZTLV4H8e6BwwgKl6pUlP2EQvI6Zqy2xULdpvNMJRFQKJKXc2THrC5HTdyVl+Fw/O3GrTTLo/QSDF0kOrphaCVY2lDJ7HiUYv30u2WMEkC
 CAijNTO0
 egns8/2IBCO7FYHkV7V0QVjd+gVhrfFU+YyWipjm+/J8T4/GTfkzJDDvva7vyg7gG/ChZuZTay5YJmJXNmHkThWyga61jlfomGm0uJ0G0AqqP8XQA6j6mC4zEV3jCiPNIr4maxKL7ZAErhSRBDUAb+mcTd0XhAGXjXyoiYGFCHNXXwxZhKW2W6YQs4dBkmzUnLXtcJKSSa2Dw1gW1ISkUBqa1/pPvHoFAXjrPy6YdBfGuKu/OwrXgZ4KgPuS5IfkE8ngFLWZQkMf6W6KD6kBhy/PVtW8L9x2Kc3F1f5c+bezuXw5oA/dlkt3lXEjDS2BkAsSncONLKmFXut2AlVGUfLCMjQIG9dtuD5HhjuVcs8ZlmgQFWu/MJ3Emn9Slfi0a0bNbn9G6KMM+Mk+jJLpnWo//g6GaYKu1HJuhQaZX6mJt57fJSK8NFfpuD1DokqQ849IvWu2zaRHnSc/LwbP0lhEVyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 at 15:09, Lorenzo Stoakes <ljs@kernel.org> wrote:
>
> Thanks for the series (cleanups are always welcome :) but just a gentle,
> annoying, note to say it's week 2 of the merge window soooo we're not taking
> anything at the moment as it's a quiet period (mm-unstable taking only fixes
> AFAICT).
>
> Though, it's potentially good to get stuff in front of people early, just an FYI
> that we're trying to move towards keeping the merge window preview/RFC-only
> going forwards.
>
> I'm not sure if that'll fix the impossible review load problem (TM), but it at
> least helps keep us sane re: what's actually landing/not.
>
> So Andrew will expect you to resend this after 7.2-rc1 appears!

Sorry as I discovered on [0] I am completely ignorant about merge
windows, etc. Even after that thread it never really occurred to me
that people might not want to receive patches at all when busy trying
to get the rc into shape!

Anyway in this case I'm assuming there will be at least a v3 so I'll
just wait before sending that.

[0]: https://lore.kernel.org/all/DJD12YR8S99G.1I43PSHB77TA2@linux.dev/

