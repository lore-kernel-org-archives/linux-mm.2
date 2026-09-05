Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7001EC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D746B0098; Sat,  5 Sep 2026 12:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80E726B0099; Sat,  5 Sep 2026 12:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD096B009B; Sat,  5 Sep 2026 12:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54ABA6B0098
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:29:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F04D4A029A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:28:59 +0000 (UTC)
X-FDA: 85180242798.03.13B25EA
Received: from mta1.migadu.com (out-253.mta1.migadu.com [95.215.58.253])
	by imf08.hostedemail.com (Postfix) with ESMTP id 51D7216000F
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:28:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ltwn0ZqS;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.253 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788625738;
	b=7cRUGyrJjvVtb41NuVE7vrSZFDkWr7xAQiHboWOAiLkh5ZjIGaRTmB4Buve9VrGrtABmXD
	ayQbogyWJKC9Twh4D6GSgkZEpd4Kskmv1SJ0CiU1FlTe0KLcS/5gm3iA78/CNovE7qMGHZ
	nUWFPKnzkDRgwqf1KtErUhqUvswCT10=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ltwn0ZqS;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.253 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788625738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKjj8AN3ujnatatIneDWDMSVIZDmaiFvzXEh3KnReHg=;
	b=L/wplQ3efQPWEwAzE6TetEx/x1tvlwFeZ/p2Rd77HcGtmjwBATQPERTggkQ5qezYOcGyYZ
	gAwubI8N39oZZf2SPrnerFiDHaT+54oJuwIz8SMlmN7obDWDgkLftjMw6OHujubAxJebrJ
	cY7qbxPUCmc/3/4gl19XUjWEe7OaimQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Sd+WtO5DRtPYTABH6V2gV0Ob5SWHGcjMM8zwwK0oVWY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788625732; v=1; x=1789230532;
 b=ltwn0ZqSyKoRR5xXKfHHetKn+HuOUpB7/GQ6bJ3jn+ULrBDg6H+3/YhSmIbHOrqLbjRFl+VP
 peAAGzb4T8nPgLVAB1+XQeppyQY7qad8dDQnYNrKdxkrczP9EGVY1W4zQvnsSC/8QnK6UyYIkQH
 szlq2TYnpR0647s+ar+46HXU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6a082eb6d975864f;
	Sat, 05 Sep 2026 16:28:52 +0000
X-Mizu-Trace-ID: 6a082eb6d975864f
X-Migadu-Flow: FLOW_OUT
Date: Sat, 5 Sep 2026 09:28:46 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hui Zhu <hui.zhu@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v7 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Message-ID: <apxB5tyglnSbqmEu@linux.dev>
References: <cover.1788516769.git.zhuhui@kylinos.cn>
 <7d8b77dc99ffe99a7bef874a257472fdaaf07e1c.1788516769.git.zhuhui@kylinos.cn>
 <20260904110308.4473cde499e91aab14dbd5fc@linux-foundation.org>
 <DL7CEX9EX781.23V26M3600JEI@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DL7CEX9EX781.23V26M3600JEI@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 3z93py9e45j6ndn5ewytahp5kzh6xbyi
X-Rspamd-Queue-Id: 51D7216000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1788625736-3338
X-HE-Meta: U2FsdGVkX19wLnc5vL1aRvEaR3PTlwv/Vkyrbq51TIaBMEU412E7e3ffj0oTRedDMHFuhwAfdXWsPFjpqqdTtGQpIzH1l6mXXFYlkda4CxkDmsSKZuzsyliRHQHLTsYUe3oQHtO8xCUx8/PbEunWPK2B3+yGHLDGD2x+P0mmk25jlwyjjDvRYvXD8APeHNLR+BiBHxez9jJ+hWWQJkTZSuRTcS6ONcrvNEK1IgNlXzD5wnOyfCenhPqfcD05/TLSZQ5SewYl8PyBqT00/1Y+58C9Y0Hhg+OspA7L5YGTEgrQmHP9KTNgTJx/Vx86FHjkA9YuVRdIoyKXMGMsaNA4d3xclVa3z5mvu60KRfnxgJS4qMdCMKL9TwqHswydudTrsxH/HmXQ8hPs+WvsAjNbCy8/0PjG2T6+73MBI5N+4+mrgtziDTIZAUbfipK8ipOgRgfsDbc06K9Fi+TDH27DV3gZ8Apvpw3hO7jjwqQJMupNryhkHb5iOnsXvJAiQHTSMaI4Di6IpuzfN2J7aVXk9ApTOT0CPNjFZAMkqeOxzho4dwZDV3jGY+6Fasn+2UMWyGFDy8W8gpPl8jAkjy1yKhxUNau5mqQ6mRJ7QuESZD1AS8Ne7qal5ZhjIbef6eU+0G/hxDYsQVgZ/3W9wm6RZ79YB37w6hTbrigARgoZMtR4r/DD6ts/3ZOSN65esOybZ+yxjYhy7VJopejHD9mwIZCH0DvDV/R9lcW7c8EiMarPwpUXJa8agVFBFWUogjYBJxRY5ixXvfatyNXaTPG0+ofc7aRF7oO64u75cqatgsiuV/HMQvJSeJqkUy6rv+PYuDiPeWWBhwmc+Mzcq+Cq19mw/YDnjkXyFyE6XViVrRLPKQ1Hszp72Z+gTnvxCfekT+ase7psySHjzymPHbdSlOlunoqt6rGroQh6L17lGaD8SzSYU6baQnZkHaHcVGD36dEMJ6wxntKSAaVIeic
 Caevtl4W
 cM65Valh6YO4xyK2F//fjIw7BEoy8JBqjgihQWhmoVHukUFZC6/8TlFPnLX636KWg4bgr1MRt/CyQm357NGlCZA3Hl5p+1+IgurADMMrs5af95mhd0x2tOO2jsfsebRQaJX5izptZiJdB/VEg4zI56AfWAyez/b2OyreGQeqt41FwEN7ADXSbjvseDL4fKPhiddqnltyVtrxxu/B+zYPFT9Ui/ZcfpXDwHbD/T2Y6VvB6mV99OGRXi3HosLnn4HlVuL0bpiujH/kowpm4rxTgLskd6GlImJ7WwkW6PV/J3MjrS6xuMYnJWCcwwenTj3ucpD7H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 01:23:39PM +0200, Kumar Kartikeya Dwivedi wrote:
> On Fri Sep 4, 2026 at 8:03 PM CEST, Andrew Morton wrote:
> > On Fri,  4 Sep 2026 18:20:19 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:
> >
> >> @@ -159,6 +160,74 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
> >>  	mem_cgroup_flush_stats(memcg);
> >>  }
> >>
> >> +/*
> >> + * Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
> >> + * current->reclaim_state, so a nested call would corrupt the outer
> >> + * reclaim state. Reclaim windows are marked with PF_MEMALLOC;
> >> + * reclaim_state is also checked because it is installed slightly
> >> + * before PF_MEMALLOC.
> >> + */
> >> +static bool bpf_in_reclaim_context(void)
> >> +{
> >> +	return (current->flags & PF_MEMALLOC) || current->reclaim_state;
> >> +}
> >> +
> >
> > Would life improve if try_to_free_mem_cgroup_pages() didn't do that?
> > If try_to_free_mem_cgroup_pages() (or some variant of it) were to
> > permit nesting?
> >
> > 	rs = new_thing(current, &sc.reclaim_state);
> > 	...
> > 	set_task_reclaim_state(current, rs);
> >
> 
> My understanding is that given the current restrictions on where this kfunc can
> be called, this is mostly a defensive and shouldn't be firing (?). Given that,
> we can probably revisit this when such reentrancy is necessary, even though I
> doubt it would be the case in the future. It will at most be invoked from a wq
> callback or a kthread, so should be fine.
> 

If with the current restrictions, this recursion can not happen then let's not
add this check here. We never want recursion/reentrancy here.

