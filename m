Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80BFF11258BB
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C3C46B009B; Wed, 11 Mar 2026 16:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983296B009D; Wed, 11 Mar 2026 16:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9D36B009E; Wed, 11 Mar 2026 16:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3616B009B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:39:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00F0C58A59
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:39:18 +0000 (UTC)
X-FDA: 84534947238.21.7A28755
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 102811C000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:39:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RElTbM1F;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773261557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EwfKeZ56gyoF6sCCv42pKYEgEb5eXyBSdLdTd3tijNU=;
	b=hqR3jQEXBdb1DhsnPNV6HBpr2njwrirO0sH4H1DGbsZQVs6MAiGTTLJg6ZG9P3LY8ruKIs
	UNc5viNPwCcFzFtU4JpeEViQJHZVJVkmPTb4a56Y/JFAZOD4asCFxXzq3ehOkUC4FS3xNt
	af1SZjaE/atV1uo9+GIXiQOfLIP6tgQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RElTbM1F;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773261557; a=rsa-sha256;
	cv=none;
	b=uoR0eAX4RwYb9GsMzSPny18kg7aMHt+64sJoRj4bmBTmW/2NdG8afqvJjSF1d+wfUFLJRp
	7lavVLfjT1ZpEajMze21aBVzfXTlz4NVIXpjY+ubhlLpUsmH1Rscym/EVJtFSlFLUPYaHG
	hhzQZJNNvfKDdRzbNGVtceLQjIX6DJ0=
Date: Wed, 11 Mar 2026 13:39:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773261554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EwfKeZ56gyoF6sCCv42pKYEgEb5eXyBSdLdTd3tijNU=;
	b=RElTbM1FwjqljucTmdeVwDIoKFhMo33LPh8IBRa+k7zUaN5agQSCK/giiJSuNYntvKf6IP
	+Em8Pl6YTKXHnwLvk5U/qqTIXI5LsN/XNmGxC7BzoGxlsz5md3nPd6WwVq2gYh1hNlLKL8
	J/ZHH1ikawcxl/HfrMWR2Iphd6nAd/Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hui Zhu <hui.zhu@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Geliang Tang <geliang@kernel.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, 
	Emil Tsalapatis <emil@etsalapatis.com>, David Rientjes <rientjes@google.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
Message-ID: <abHPsCypwo7ZhqIt@linux.dev>
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
 <3ECC9B38-6C1A-4F60-9C18-98B7A1A56355@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ECC9B38-6C1A-4F60-9C18-98B7A1A56355@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 102811C000F
X-Stat-Signature: jkeiwo41sjoahcr3twdhp1oi5ce4wzc8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773261556-213373
X-HE-Meta: U2FsdGVkX1/eOORDirl1ATYIMXoc1/OH1WPva+psM6Lp0rE/Vrh+oYE9EkfI91ZWcar2fH2hmtbd+jd5Zhw2bKEILyuR2dSaJDqpTOQD+Euf10QCGP29vw9DL++TAENUlCMr4r7FMvSo9k9CX0IqIdtHEC8LmhXfJwrEuqmYOEco1unYniW8XmWBqgGRgVOVh65z3ghrefv6hIhcs4QZkha8CHz95tq0pnc04bEaCiVmXIhZ2U40BrVdHHlXY4VQNq/GuRTaenYCvHjUczn1aBobUTK7r9LyNLbFU8U83cP17IzhghtDKlCwVUjxswtYFibcy1DZi0CIWbsSWfki/1hwPWTo2anG08GzdCVP2N9jTiXcy18lYFramFUt6N+cbeXtRGr2wnQ2nTESmGT7FpdC/vj0/TegujWKAbq+s/HoNUWcnBgokldEq4n+PBCFx+joOjLBiGdi36Z0zKvS8LwS48HTVcaWtmSlNfGIlM1hQslLNM8qH7cpUnFB+kMwVR/lKuGb+g5RS2l2p4UwaPptE0KBtnAtkuZXGkictAPvLw6Zd9YXc+CJhyhyV8qIha1D2GDb6nB9A75/9E+fCIf0LP34wjtXncDtvkn4sthLIE3hRklaiHf1zPCyUAKVdHIh+AU/RSpcioGEoZ0khvL8JPG9px3WT/a4qfuFJ9q2hw293iemqdpoFDAFSwb+bEWLynuH/1QNYzEPoX3Tqg2g4Gd9grzyDwdcJWTLy7Fo8WjL38X0U5Y6dq2laHAmsAYlIq5iEhZY7ge9YjvgGEmdv6GFqUC6N6+5oZI7vJkDZ3YlzyMxqFVG6T2IDrDfR2RLj6c+iX9TUQyvRPVP1I1ZS3guQJw5vlF8I83sQSteuRyX/QRqNLWS7hshT5+o4ZM9NFrpdvTiKOghEFXH2xay6YpCeC3L8d++Eor/lGeg+8s4xyKkCK4+XKZ9IL+TymjclRbw6CMdlClOBMc
 jtQpVrq5
 b5oQKK6whDzD9dzbjCxMLCCrzqf0jloMlG89gnKUluexz6d4VBz/f9lBBogZWM/4grNJHXZxBOy06KrLHIx32OtPWg4NR1HrL48LC5vfeU7ps6zqdZ66awQajDiHmR317QjF93x7GX01z1/xZge/fPW9pvZG/zkq1SdAPsl0o8pjvOme09svm9Fqjec38Hdog8PMPJ9KkvQZAQA2W9WAjjsnLZ3lraG87uRaxwlfKWpSyE05iYmOlehkGpm+uVQM+JJH4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 03:19:31PM +0800, Muchun Song wrote:
> 
> 
> > On Mar 8, 2026, at 02:24, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 

[...]

> > 
> > Per-Memcg Background Reclaim
> > 
> > In the new memcg world, with the goal of (mostly) eliminating direct synchronous
> > reclaim for limit enforcement, provide per-memcg background reclaimers which can
> > scale across CPUs with the allocation rate.
> 
> Hi Shakeel,
> 
> I'm quite interested in this. Internally, we privately maintain a set
> of code to implement asynchronous reclamation, but we're also trying to
> discard these private codes as much as possible. Therefore, we want to
> implement a similar asynchronous reclamation mechanism in user space
> through the memory.reclaim mechanism. However, currently there's a lack
> of suitable policy notification mechanisms to trigger user threads to
> proactively reclaim in advance.

Cool, can you please share what "suitable policy notification mechanisms" you
need for your use-case? This will give me more data on the comparison between
memory.reclaim and the proposed approach.


> 
> > 
> > Lock-Aware Throttling
> > 
> > The ability to avoid throttling an allocating task that is holding locks, to
> > prevent priority inversion. In Meta's fleet, we have observed lock holders stuck
> > in memcg reclaim, blocking all waiters regardless of their priority or
> > criticality.
> 
> This is a real problem we encountered, especially with the jbd handler
> resources of the ext4 file system. Our current attempt is to defer
> memory reclamation until returning to user space, in order to solve
> various priority inversion issues caused by the jbd handler. Therefore,
> I would be interested to discuss this topic.

Awesome, do you use memory.max and memory.high both and defer the reclaim for
both? Are you deferring all the reclaims or just the ones where the charging
process has the lock? (I need to look what jbd handler is).


