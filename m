Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29F10CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 00:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662968E00A2; Thu,  9 Oct 2025 20:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639A38E0002; Thu,  9 Oct 2025 20:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52BE88E00A2; Thu,  9 Oct 2025 20:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4058F8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 20:51:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B118B137A2D
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 00:51:13 +0000 (UTC)
X-FDA: 83980375626.10.C4E3A19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id E66FF180008
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 00:51:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2JktYbzm;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760057472; a=rsa-sha256;
	cv=none;
	b=2ah9+p48+w9gyf03JKwcGaeGCT96xAl15pc1mSYnvmLEBzongr0s1i9T9y6DiqLFgZ51KX
	4KEMZlb58hQ7ZiPmDV5MREjgMt1tuWyMjxh1RKG06yenEX92rGADXN4pHHLJfJn+0FVrcw
	8BL2PTllc6X4slyh4+dCBFXXmwcyDOM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2JktYbzm;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760057472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ixaQLTg3CkcDLvWdQYxVSRQH9QTFlcattUSgzftfR1c=;
	b=U6O54++exMAkq32ddTBU04Ire9um7u3jhfqSXtHQHqrh4vlhG2y4OIyFCHVBran71vqCEf
	B9iSz/4TJWhoWcCoaTALH5XFQz8qo/iT8Cy3dFS9g6BprJDjJg+azQbN/vdLESitBVczuQ
	KXc0fPEJYEYH/5dUFVOlO5veIZTOf0s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3176543F7C;
	Fri, 10 Oct 2025 00:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24497C4CEE7;
	Fri, 10 Oct 2025 00:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760057470;
	bh=A3UrofGwAstq0M2Uw/J4CU3Y1letTXoVhhSuZWoGGb8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2JktYbzmhzcnUjZxn4TJsLrCa4CdQmyNAz48GhTm60ifXFoRmbMF9Tc/M9RRLbvJV
	 OTvz7R6JSbLUT9mEhQjhUsNNq5Xpz4vLivUTBLXDvZAdv81wS0YgNddSVET7bP2mj+
	 E2cRLHzPEXFAzCsftZVpoY141RGvPOXXQkXJVlZA=
Date: Thu, 9 Oct 2025 17:51:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Mike Rapoport <rppt@kernel.org>, Alexander
 Potapenko <glider@google.com>, Randy Dunlap <rdunlap@infradead.org>, Marco
 Elver <elver@google.com>, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
 "Liang, Kan" <kan.liang@linux.intel.com>, David Hildenbrand
 <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, Justin
 Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Sami Tolvanen <samitolvanen@google.com>, Miguel
 Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, Rong Xu
 <xur@google.com>, Naveen N Rao <naveen@kernel.org>, David Kaplan
 <david.kaplan@amd.com>, Andrii Nakryiko <andrii@kernel.org>, Jinjie Ruan
 <ruanjinjie@huawei.com>, Nam Cao <namcao@linutronix.de>,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-mm@kvack.org, llvm@lists.linux.dev, Andrey Ryabinin
 <ryabinin.a.a@gmail.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry
 Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>,
 kasan-dev@googlegroups.com, "David S. Miller" <davem@davemloft.net>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/23] mm/ksw: Introduce real-time KStackWatch
 debugging tool
Message-Id: <20251009175107.ee07228e3253afca5b487316@linux-foundation.org>
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E66FF180008
X-Stat-Signature: n6xdf97gbn8arex9smsso8a5s84uf8xz
X-HE-Tag: 1760057471-737134
X-HE-Meta: U2FsdGVkX19K6yNvkMEFEc834i6lD54o7owiNxppOQL+TODemGdJ070LZSGWZGsR4KGw0wwQ3t5j9s4ru75pPRByuwVVoweaOBUlrfzk/LaOF1AsBKSLdyBXQA4AjGqycHwOV5GmWtmXRfCH/eKcAkWfubaNTK0tdf/m0U1P/BfKOicpvQXq/hOBLVb7GUunad3C1iCN9uDx6ORFvIaQpSpwCdSSdIOZ+hBmMGN3shAPXJ5/O7gi7V2ec5v37sZ5Vc8edqU65I5h2auRR5qHI9q1sI/0VQIVSjY6Iog/NLVSIw8RugbwnMvkBlcySh959VSYP+6XDBkxti0bhb20G/sTd2SU49w3vAeBcKxblUp4DhYypnxZtisRqMTlYFRjt9W74xmCL3cf5DytcQBD/U4RQfN8pUlcXadQdpvK84eXLyB3amSP9HV2hh3DbLPiXyU1pp82M/ucu9OrNd4TPHkErO0NgARyK/AJJJYCsScitrQiNx/LPJXO/aS1F/fHQCRUnwAjqhLUJUVDmkDEWpzCo8RFy6mYrnga+LXwmvLZLcmPFp9ZuYF6hE/W0QISCZtkBKq1Iw8DltLZenZAd5lqpxeOiGcKl0RZo1CTfUiy4In9quRoZc0xMXu4K6xfvSlwHotOsQJWRAtb1t8v8I64Yl1h1uG1Ehh68Le288ugOV6SHkdaJU3MNrQ0DJomiBorCDdI3ylBjln78TdUlEHVL5UZB6d6FUfvxJ+2HIvo7OfKR/6IRELSjV9RvDScyHHW6Tb+hMpnj+mDNT59QctQLIgEAidL6JFOO238sTuJ2nmWpLnJxCNwzSet6viRciu79quHEUdblW04yBnF7cRwcPzsdPvq6jtDc8d8PdXD58gjxtXdNFYVepuq84R+3pvMaUCAG6KNht4vdSpo7RAPCQ2ZZ5dmDdJ+0Hb2hiBhISNMF/fHBQT9YNdRSsVzstjsl0XPVw+vQ/pyljv
 8xKgeQyL
 hAI5P2fNmB+szPho+417DgTljaASUosw2fh6g1qbLmuf1DqBLzToZVjzR5lsTQENyrBEAVbJKuzJI644wXTgZwXl/reQeQpm6Sw7aUmpU3EdIta5mnXkOTeqFgTSVDsbFVfTkW2HU6vdxME2N4nvq+QIdIuw0bP0JcsaDKvkJCr3mSDiJPP5P4iv0LbtPUOtRgRSqHOj3wfkd0ryf8hJy/smcxUT0MlHgrRyEzk12FEsG/7BI93bIKAwazsTZ1Z4dRAtMk9GqMdg3JamD9RMry86r0AIVnCUWIR8ysgPVPBLdELiA6gN+nEGy+3JzBOb2tqB26r9ZoCeEJWoJm+9HKCYWan+zH7bBKocLo3zVJ5DS0oyb0l91kTZFzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Oct 2025 18:55:36 +0800 Jinchao Wang <wangjinchao600@gmail.com> wrote:

> This patch series introduces KStackWatch, a lightweight debugging tool to detect
> kernel stack corruption in real time. It installs a hardware breakpoint
> (watchpoint) at a function's specified offset using `kprobe.post_handler` and
> removes it in `fprobe.exit_handler`. This covers the full execution window and
> reports corruption immediately with time, location, and a call stack.
> 
> The motivation comes from scenarios where corruption occurs silently in one
> function but manifests later in another, without a direct call trace linking
> the two. Such bugs are often extremely hard to debug with existing tools.
> These scenarios are demonstrated in test 3–5 (silent corruption test, patch 20).
> 
> ...
>
>  20 files changed, 1809 insertions(+), 62 deletions(-)

It's obviously a substantial project.  We need to decide whether to add
this to Linux.

There are some really important [0/N] changelog details which I'm not
immediately seeing:

Am I correct in thinking that it's x86-only?  If so, what's involved in
enabling other architectures?  Is there any such work in progress?

What motivated the work?  Was there some particular class of failures
which you were persistently seeing and wished to fix more efficiently?

Has this code (or something like it) been used in production systems? 
If so, by whom and with what results?

Has it actually found some kernel bugs yet?  If so, details please.

Can this be enabled on production systems?  If so, what is the
measured runtime overhead?

