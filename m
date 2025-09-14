Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E42E5CAC594
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 13:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81AE8E0005; Sun, 14 Sep 2025 09:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59818E0001; Sun, 14 Sep 2025 09:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96AC8E0005; Sun, 14 Sep 2025 09:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3C9F8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 09:03:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CFC11DDC2D
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 13:03:01 +0000 (UTC)
X-FDA: 83887870962.23.F35E05C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 47C6916000B
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 13:02:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfN1I3Sx;
	spf=pass (imf08.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757854979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQvwWwEuhKFk13QOyAig49OX2R4iNlJHBcgD+YReILk=;
	b=U7dPoKjizGCeBFLEqyYK47FJDUxWMfTK+3rhl1unY3MHOfVtA3Ya0UDsBI4FzzMNaGAMyG
	+ZODZI0JC+NP24HzBNbeDpXOnKjccVKFFyfb5JHHfeEC8LWpF+S352J5nEJml4I7WFkWIP
	4wYG4dy22QDwBVJ9FBxCo3G0/T7fnWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757854979; a=rsa-sha256;
	cv=none;
	b=PaufFH98pLvQCqzXNSGJ9leDu+pqswGhPi7G+r2dF5qyWA+EZdWpdipHi2a1dIcrqj2ED/
	wX2WuciG7yQLUQajQIaDs0qMwCkVwzCWXCbfwKnuMwzn6wfdjnWABBtd4nbWrXRECBbbiM
	LQR0xC2iynuQt7wqQ0cEEfpnKinaqBE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfN1I3Sx;
	spf=pass (imf08.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C899543B05;
	Sun, 14 Sep 2025 13:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC9EC4CEF0;
	Sun, 14 Sep 2025 13:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757854977;
	bh=YYDp1ijpwWt09S5HVfnu4kiNUYZD0PpGT+F41GYPadw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tfN1I3SxboPtqg8tVy6FWKrpiKrpPQ9z8Cv44K48WXiEcad4ZNNLZydJ65S/qI29k
	 EwBkEyHjGDbdx6IiIbX8u+Gc9sh1/7LhYv0KuDenuZg3dAkx920SCHCrx3ejXdB4CZ
	 kkZv+EZ8tXEH2aLHGTp7G3jfLmgvYXteZnydpp0UsPKMgf3HAzoIv8i/yxHQkoxOSP
	 75VFXHCUQMfSFW3LEOUGVqLmXvVBvEcw/SnA32l/9OUmQ7vCkJ2ODaCUXeNlxE0Rl4
	 8f6jp6BUeK9hULpSdxe6NnOO5CuoAwWTcVvlywnTL2AONaQjHYXi1lA376VzJCi5nx
	 sdvSbzTn6c09A==
Date: Sun, 14 Sep 2025 22:02:42 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jinchao Wang <wangjinchao600@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Mike
 Rapoport <rppt@kernel.org>, Alexander Potapenko <glider@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel
 Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin
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
Subject: Re: [PATCH v4 03/21] HWBP: Add modify_wide_hw_breakpoint_local()
 API
Message-Id: <20250914220242.1e8dc83e011b9568dd7a5ace@kernel.org>
In-Reply-To: <6b5e5d3e-5db8-44f2-8dca-42f317be8e0d@infradead.org>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
	<20250912101145.465708-4-wangjinchao600@gmail.com>
	<6b5e5d3e-5db8-44f2-8dca-42f317be8e0d@infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 47C6916000B
X-Stat-Signature: hq3t7zb9f6sq17eh15k8gz6gag9oaouo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757854979-669658
X-HE-Meta: U2FsdGVkX1/C3HffkVdShoQRr+WbNROrHf9a+/i8c6mb2/TMwOe3XWYYZg1qhCwGYZJmlx27H51wpmWfcpSBf88T+NwX3vn1nPO1o/qw/Opf32gca/Zxc8jsnIYyxKYwQccasS/FzcB6ENCr2rSYK8enZX+Yh3+5Cv9pN74C/TEipI5Hw2gz4fbLcWKJbsJPTvgoeDiWaKoyirhia0Z+PImMQZVZ2zX6bJzly8GUrLPhconsb5GfzD5rolNzz/BJOZbwShZ7KHMA3mIkhtIBXPuRfPBt4l5c6kC2WFt8pcqjwgYm/OmZ+JsN1u3xkVCRNV+E7YatJMGhLMI1p+a2bZHpS78/zgaYEUsRt19Xp7b69wljyscF22H9G1N9SHK4T94qFHnVqwylNY063lAyJb5ZmSGVcqUPLc5oP/YXFHFtztiJjdO/m/JvOi5/T5pHd8ttZUbUT3qFds8qSDRHbK1Va+f/snlwL7/EWYQaoOVZHCKs9+l96cQaEXwiUuBcmW9VdA9P9N23pQP8MgNLTywcWR63IcqW2ybNNVP20VkUml6vOxfhkL/nGb9sPZekT7sERASS6bTKOTJkYEjJFawupyx13DMk92C84ZanLgdxsxm2+axc4QTDhsopJnYbDcuaHKEmmjleJRW4CJlnqDOE1ak6QD4RqjnEfQEtgT9yLOLjGoW5HhqrOnhMeXXvYxKOWeQis4VVDXOwbEkMs339CBrfaSaH0FNVZChQyoee5gPvFiBROB5nFJA7Cbc6FMfBBeaxKeJ0OMAMDpcDmFbf9zDOA/mgggj63QhtZfToZr3pw/9ONjGup7Iz7qcSFsjcJ4KwRskaNhT2UGZ7j6V4pTir6ozUZE2WA6TlDzIApmSBEGeh2GVhJ13qij2whZrNkTfd3kqsiR/jV5wQBBjhm+fpqnMv2o2yXhZJwlrveiGtST8pKEIQoVZ69rM+u+Zpd9S1VzCv7XHRcgZ
 1iCIa6gN
 XPAgjsOJpFzeMKEJkc1yoTDIaB/5/4BmVvHm32cBfV5Zq2rDNlCgQQo2iWROeLJpPf5Zr50q3YKPJeobZEe9Wsv6IVJnLZJkoz7oZYTxL/D3S5QyA+NERHdbIKhxuYoSCwMtTFgq1fpzqQNqImtHHmEj1qwZYSELFnAWmxW6KaLwtgKpnMOCH6jatjkCYEcAuviMZQ2kS7seRjIMrwHFktlsGO9mNUPuKDg4BAMI2lvOoSJpKy1b2YCqIT1kFuxhFzb0d/KdKrB1XFGMXJpOjWZRWU6P8WcpzcNPuF5Iyco+lTdMPZDBJDW41BrRuj3qZrUzsZcJtCupg9JJC/u8wqQKWjZB61p2vswDUWr4jqqbEfFC46UGzUnbci1ZvS7ycDw6JEDw2BHtsQNnb7SdYyjMveAZjl79IIzl/okzYpjbCirDvicZXrcjGReBJ4YbYmS1tGYgWbqypyaw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Sep 2025 21:13:07 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> 
> 
> On 9/12/25 3:11 AM, Jinchao Wang wrote:
> > +/**
> > + * modify_wide_hw_breakpoint_local - update breakpoint config for local cpu
> > + * @bp: the hwbp perf event for this cpu
> > + * @attr: the new attribute for @bp
> > + *
> > + * This does not release and reserve the slot of HWBP, just reuse the current
> 
>                                                  of a HWBP; it just reuses

OK,

> 
> and preferable s/cpu/CPU/ in comments.

OK.

Thanks for review!

> 
> > + * slot on local CPU. So the users must update the other CPUs by themselves.
> > + * Also, since this does not release/reserve the slot, this can not change the
> > + * type to incompatible type of the HWBP.
> > + * Return err if attr is invalid or the cpu fails to update debug register
> > + * for new @attr.
> > + */
> > +#ifdef CONFIG_HAVE_REINSTALL_HW_BREAKPOINT
> > +int modify_wide_hw_breakpoint_local(struct perf_event *bp,
> > +				    struct perf_event_attr *attr)
> > +{
> 
> -- 
> ~Randy
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

