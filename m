Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A09C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 08:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ACCF6B0088; Fri, 10 Jul 2026 04:36:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45DC36B008A; Fri, 10 Jul 2026 04:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F636B008C; Fri, 10 Jul 2026 04:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A67E6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:36:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D57D1694A0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:36:49 +0000 (UTC)
X-FDA: 84972211338.01.3FB7D74
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id A22B240005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:36:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hV+Kfjnj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of jackmanb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783672607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vusuleFjZncfXS2nyCDuITFoJSaIiJ699qFr3aBd5M=;
	b=t2qxqOiQew3No/s40nv+gEmIFkLTR32xzKSlsNNICknYFze5TT8eDqxUmg+dbxEJklFort
	6c0ytoTEgjbRieXN++DKJOi6pV/ci3LcMMPTHfNNTJHfp5+M7gXi963rZrN+YK4gFmmOv5
	jUdX6OUS+i1OfAYfjBTPPrOgxVlPlbY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hV+Kfjnj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of jackmanb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783672607;
	b=dd2pWgvp83AuyvzCzZx2x6xwY9e4FQaQhfcbHB4WMLDAv3/kZ+VxWnotYz7w62GouresKo
	i+ux2geMfIHiJioMWgngopHFBvNt39bhRwBRWE7LB15BOF5flnX7t3xOQtFtfFJY2AkPI8
	hHnrrLiF0+swln8PKwYDmRINh19hJUY=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-69a45011a92so8935a12.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:36:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783672606; cv=none;
        d=google.com; s=arc-20260327;
        b=d4JOopPeQdWPW+PIdXlJsNqmdDXQuTGwtlbAwvhrcYsAMMJWtG1B1Pvc/Q4hjXiovy
         urWeAmvylPdxAp50NkRObYIZD1P4yTgsxBsoYHNQTX7iJXiMyo+paIkOSJq8rbbqGbt0
         BVnsFtb82kTapeYHqKBjztCGmDcCF9h9Ygpc08e6J+IfvQwiPQ4QLOZ61CuX8n37n3wK
         Epc3YXejUr+DJrHkgZH/Cm4cCny6IY+FLi/LQZE23x8f6NclNFhrbCi+K67zfmiJhWLL
         4GZx5PPTV08AKa7YM42bjXUF7jnFCgkuI5w7BjDmPJrkc+nkgdwQznGUbm30wm7WQd5E
         YpEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5vusuleFjZncfXS2nyCDuITFoJSaIiJ699qFr3aBd5M=;
        fh=T4HspraeeysX7r8HxjtcgO8661SQJ09tnDLbQZUOoHg=;
        b=RIBiPtvu4RrP09jlR0Bd+xfGNDABGxD98RkPjk4+eCxbsDCkbGLcpnzMGmR+0AvcoT
         e0Eajz4OKpin1oi6eGXKgEzEw06DYA3uwubC8MKH1qEIwlW4UKvAryKtS7QQRSqrOT2G
         y86DarCHpIGqT4q+BaIlHkv2IMFkfNZlKIX3YnLdl0/685GGvyn6FGIkXINAuTJ8nh41
         MlKscQlYWlOJVghLE1eT9hwO0/XClorECLTTqONVVHBpps49LyW5SEo6OXAj7vHVozmk
         04DKwBVJzVMaEVwqtdYkhpabOB4cmcAT4qiCrgN+Ub+EkrqzUiSNKAbVKCZcVOzsUA/A
         gAPw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783672606; x=1784277406; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5vusuleFjZncfXS2nyCDuITFoJSaIiJ699qFr3aBd5M=;
        b=hV+KfjnjcPGtQ01ZIlREruWXUwzYbVcYUO84ny9No8e2+cRMeCgg5f1KyDJ+yhTdpQ
         FCDXkR32srnwt3q19c5ejiK7JOjjmCVN09ti1kLLmK/RutRRIe2ZUfjUCNWj/9I56ujK
         +ngulNQANsvrX4FyqJc/f5jNZP+1lhcWxrK+PqAnNzfrHzdCLHdxJ1xTT8JFyV7sxkT9
         Hbd/tVdxqkXtyFYpymvrmO2svOCQimElKNccHuNyzOu/MKDIQGTIM6TFLgBD2FTZOTkF
         Hx4I3YTGxz5RUzWr3jJgdFRHQBq0LXoekTCX8lXNMKRbthcmDm1r40gPwV207gch/tFv
         WV2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783672606; x=1784277406;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5vusuleFjZncfXS2nyCDuITFoJSaIiJ699qFr3aBd5M=;
        b=WhC/HAxqxmpsrGPnmiRxmyH5ymZarNuhXzhHAGDe1c2VHnf1fbhayLnyDH7wvyqHd4
         nWvAUslRHB1moMoy+Q/dXb4BF+ijxQ2O2jERmu/GxgOIzjt6St4X28HCa7OCorlAUUP6
         sUeQi0m6eZ7QqcfZ8Gts/Yjz6EDQcobzTJ9U9q3/c7wjAju0bcwCrIZ4qwsr6FEPeFOU
         2Vacwx6fdt8cpoPd9xug2oRR5ICs60WUiB7ho6HxaiRxbTNAzVhY+ZSKJrzQivJ1pqYt
         6McupnzM0y+cZ73JGlgcwxE58DkZJkbJxdmz9vEmwTuuCg68lUVlij39zVqW9wxd8WfA
         jqLg==
X-Forwarded-Encrypted: i=1; AHgh+RpHhtQoU04OHDBjM++vqZPZyysKerA76gwwMUmL1hTlgisrq84dLW4tg2hGoxoUg7KgC/yThiPEwA==@kvack.org
X-Gm-Message-State: AOJu0Yx/4eqOENfESICpWUn7anNPDF3bZtymFBn5xMuQk8O2GIaXSuvT
	NKGXcz1RpY5uJI+FE3KFFbvyGLqa5bvDChSsxwkJad88fLDuoKo/PV67fLCgfEm2nA+5Gs7pEb5
	xDxQwfIH30X4Oc20g2v+Muumt/qzWbxN3EIPMnJvM
X-Gm-Gg: AfdE7clhy8uPamSER+CUuj1Sgd5fidZsahEU3yJtNaLxVvLxKwxC2KTSoGBz21t4Bys
	YN5zPgklmZrHxYDVPb+xCh4qwfqOW4uv14l7gzWhgsc4CphPxSoycb87eTE7IFZxgAJcBW9E6LV
	peCsLz0aS06tizzZML0hZcF72g3fgS/xVJOk25XIb4BvDl4mvn2zLIGg2+UHQquqJyqH9kFLKKC
	ZBb4e9IIbb1MpXApia9W+Vydlsok+0Nb8oliMzgBxL6YilSRSxaZCFIjig1X+P99K9RtCLFlGnI
	z2IdBsBECaAw3Ri14LgGgkm++A==
X-Received: by 2002:a05:6402:a541:20b0:697:6b08:459a with SMTP id
 4fb4d7f45d1cf-69c29ed9df5mr35748a12.7.1783672605521; Fri, 10 Jul 2026
 01:36:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
 <997c1a4d-ee99-4214-be58-7ceb3b9b9a36@kernel.org> <20260705003039.c9b4bd681c059f62b375051a@linux-foundation.org>
In-Reply-To: <20260705003039.c9b4bd681c059f62b375051a@linux-foundation.org>
From: Brendan Jackman <jackmanb@google.com>
Date: Fri, 10 Jul 2026 10:36:33 +0200
X-Gm-Features: AVVi8Ce87UhCHbfmvKkRHtYsfZSbDlT7JQG_kxBAkz9MTI2Uf45nPVr5mC018JQ
Message-ID: <CA+i-1C0exwnJnp-WXQa3r==d_TeRj2Ocrn9COMCdC93UiWvQoQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/18] mm: Some cleanups for page allocator APIs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>, 
	Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, derkling@google.com, reijiw@google.com, 
	Yosry Ahmed <yosry@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
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
X-Stat-Signature: 93tgbd833c4k4bai47zezcj5jmfxbwby
X-Rspamd-Queue-Id: A22B240005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783672607-497492
X-HE-Meta: U2FsdGVkX18TASaDyBg4XEJ8uq+METPOj1Ii1gt1bbIzAUdfKhhol1XvoekFWr7QIqjhZ9AgS60XCTdPEE8hj/uEURFIinEHoiRkF+M9Srrb3zLUWtV7S31WY3Bb6QMa8bDHE8h1j1LR17ASM/bkuqSW4RLofi4KY+W1znyho42QbRsyr5AoyxYbyL2oeggtyGaAMNttvzWpZcdbjr1Fn+jAKSDHl9k+eT++cweKyVTI+7bBsg7CSU4Yr9cXxAS67+cEZxfrByXjL0OD8DzldXzn2hNS4TSgidXkkt93z+bl61OUGLKDKCw6JctP+z2+UoHOQb+En1nmk3pUmLwfhqQoOB8SAWtrCXznugHFEI0jD8C25Qjbn9SlyCGRdrq9TXJrTMsEwgvDbdLu+IaAHJKzyjBKJmtPtbgt+KGo4UsPwrwCxQYTclSH36lWrxtKOqf4yAHAmtoQGCm/r76+C23Z6Toypl5iZuxn5ndJ3gyCi7ZCS/YexB1kpwr6G416PhHD83cwUQiUO5PfdQ1chzYQ/WBFS5D7wMClnfmQtD0WuR1zPfoxX5fcFXz5BmqCsjKrK1GckcMMdLFFxZUKBroLUfXMRrtupJs6SwYryh2zo/aV742DwfOkE/y5Dvwuatdk5cOHcxYRl7CHotJJ20KOV1NkrH3OC1o08xlSs+Hg0DQoHkzKbdzYWbCbY6A2OPw3MlI9TfNgCIGvEv4mOAVq5kSuQ+e5G1TkJ1JzBkDGSraJDfAm+7XdVea9pXE+vET7QFS+DN70XhYUeYZ8jWk9yB//NXcyGoP1a8/+JjKHJ1HZf9RrWTD8ZMm4HbRtXpz/TDD5tHyaOypITVk1FbOkGaxDRFfUA0qNKddX7T8IudrgitfIIfoIvo76vOILLoZi/oniLWLOLHdznlAEvrv82QhigYnZCKuL2nFlwMCRsP1VGgRiJ1L7Ok3dZsq+FRXgzcliQ+X1hzNBLiK
 ifbVWhH3
 RvqbipglQ4tbfp/lHdHlQis9fKjjlhj/v9GGr49VFuqjxRtirRU7AX11/dFb192n1xRsBOrlXjWt6JsBNozmDgbajDR/5iWn0KSSUwmROzKLVaH7zHkL5cxLndz4RWsBKWq73TQ2QyLZMxsQkkZaZFQwT7xTpH2Qqk1hPiq0NnoihEb0sTS1D0G9Si8EonTzcPwMrP1svRBlZzZEgg/ddysI5nWpbfy5Y/EVYMpLMPqohwv2Lq+9UuNO8o1ERuB/aJm7DADMI4s/sVGNRJf5A0BiOqQHAS6RX+ne/uh26WBPO9tcYLlmzQBXCfLw10Oe/+TdV+go7znP2gRCV0RvEYBS50n+QNdA6DO8FJ6Lwk0QkJ7HrENFZ22sJT53sgwxt0kU1z1sneJSS3vncsuR3P5MvIvSAEBUqaxOq+3ypvWIMDYpj3LetMZXY1/WCUHZ9lNdTbUK+o7uvGJ17559VwZllx2Vi860x3VyBkI17T8N3N5xrZ3GeFrJ06RHjKmNDRBGjPxHUwOTxcQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 5 Jul 2026 at 09:30, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Fri, 3 Jul 2026 14:47:32 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
>
> > On 7/3/26 14:31, Brendan Jackman wrote:
> > > Based on mm-new.
> >
> > Seems ready for mm-new to me. I suspect most further non-trivial page
> > allocator work will conflict, so better have it in mm to be based upon.
>
> OK, thanks, added.
>
> I also added some little notes to track Zi Yan's comments.

Thank Andrew. In this instance, what's the best way to send updates, I
guess now they're in mm-new it's best to just send them as fixups for
you to squash? In reply to the thread?

> Sashiko had things to say, mainly pre-existing things.
>
>         https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714e19d3@google.com
>
> the xpc_create_gru_mq_uv() issues look like facepalms.

Oh actually I didn't see the point about the alloc_pages_nolock()
comment before. Other than that, yeah all of those comments have been
discussed during the reviews, or are brokenness in totally unrelated
code.

There is this where we should probably make a decision (also a
pre-existing issue but this time in mm/page_alloc.c):

https://lore.kernel.org/all/DJOTMGFAPDBF.261U5OD4NPU74@linux.dev/

