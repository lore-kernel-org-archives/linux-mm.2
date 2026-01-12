Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52337CF45A8
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67D66B0005; Mon, 12 Jan 2026 12:20:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15856B0088; Mon, 12 Jan 2026 12:20:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A214F6B0089; Mon, 12 Jan 2026 12:20:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9239D6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:20:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FAB41607E5
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:20:31 +0000 (UTC)
X-FDA: 84323975862.03.7F69F3C
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 641BD40005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:20:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BJTfQrEh;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768238427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKO5SxjQcWY3bTQexM6OeVasUC8f3l9ufW1wNbb+WHs=;
	b=nweyYG6mLiz6jPEnYAqWYX2DJu0+2a6De3pqmYbnuHE5ojJTtpenFPRR62gNc+QeUwupFA
	bjp0m8ewNcG8RyEeHtN00Awuzqim1momjhrN6k92A/M3QVb6MdfigG3GtT1jpaF6hiKFpY
	DtTAwuhfrA53h6BjHYR+L42GpaL3H/Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BJTfQrEh;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768238427; a=rsa-sha256;
	cv=none;
	b=k6ezL/yuviQWWn3EE8LLjqqMUxFiMRHDfXsGB5N0QHuDP9q1SzRkITaAIWEQfJmJOVMBUr
	PZoc1Mz9sQpdKvT1VXPcaIW9bVQ55fBvX2cfBz+eirHL/7Rlskces9hCOfYzk4auES2P2S
	Dkgsq1s8lRto7bxV/wFn4eWECkMDxKQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768238423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xKO5SxjQcWY3bTQexM6OeVasUC8f3l9ufW1wNbb+WHs=;
	b=BJTfQrEhGjvsVklGhhozrhVJ9BkY1WKH2fzBMWKZ+bIikMAJi63QcFx8rvYjSViFuYu5Nh
	IJhlCiSiKL3yCk0EvkuaOdaUX95AH+O32tIAowqrS4s1G9tuXzps54MNdnbqUngpvNlbIK
	4/aRPyEofh/08VUzsjXhOAXZl/LU/gQ=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Matt Bobrowski <mattbobrowski@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko <andrii@kernel.org>,  JP
 Kobryn <inwardvessel@gmail.com>,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  bpf@vger.kernel.org,  Martin KaFai Lau
 <martin.lau@kernel.org>,  Song Liu <song@kernel.org>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>,  Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 06/23] mm: introduce BPF struct ops for OOM handling
In-Reply-To: <aWULOvXrN0acG97Y@google.com> (Matt Bobrowski's message of "Mon,
	12 Jan 2026 14:54:50 +0000")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-7-roman.gushchin@linux.dev>
	<aWULOvXrN0acG97Y@google.com>
Date: Mon, 12 Jan 2026 09:20:13 -0800
Message-ID: <87ecnusq7m.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: jq1z71a9jtztsoucpwgpnxzy6kn7wusi
X-Rspamd-Queue-Id: 641BD40005
X-Rspamd-Server: rspam04
X-HE-Tag: 1768238427-620004
X-HE-Meta: U2FsdGVkX19ttrLm0D9ku86XCt+BLM67CNA7YXKl23YTpjzqV4PKf84Bf8b0tpJD44r8aPcokfd+kGSovsK9roFUXfop0WPZIWhH3DYLX0N7k6faknUBl57sbDZ36UgT/u1a0Nn8NScElP5niHOT0IFF+ZveUQQLEZ2EbE37TAVr/f1Aev6roOCQSoXxfp/ox3NmiZle0S1AP7hOdiIra1FikFLfODxSo0ld+CpN6VYd0p4N4+2fUJy0YX48vTCjisA5b0zwb3SAnvG0eoWThi3kz/sfEWx8D6heb1GEnFYmqeL366rdrxqSSciN3OClzA4QitN2MXbkoTgRkTLth8U94qm6+pOSXRmqPE6kcWaUb2FXL6CZOaTv9hJir5jRZB9DtGdLzU1VHkwtC4JOdv+aROLOnB5mGrCjAR1uU2BSbNq+g7qONznUfENYEKiw1chK77QZg0WaPb0t652nG9APJvwat8SmC5fIG1dGrSEGQDemNlocO5FQNYGAxOSEomTXR5NDxLWACCQdOR3TljSGVaGI0ZHtkVSY62+Kv4vy8godZUbp1cXso2glGd6kOkR0twaCJBLWITqOA/+vWffJRqnmcBKBM86XbsmEYtZZn8r6F/lPeQopYU8cDuiApJSMUccJH+VWV2wYyE/yDe0z3ouH3Qxm19vbk9xIrPxF9ycknCR9LGsjglqvr8tTcN5J9CtOf3FI4h/MYE0Qm2s+SNlXpIQxQo/iWyAD244+gglg2s5N38V7TLaYp0pCz/L5jg/ZEJIMyUaMg+vsmQdY7k1huF5gKgpB997ocuAoQMDY1B+GO46uwcJ0k7569sYOBM3sXIq2l8Ek5MPSVFtha3kv41w5A6cZmQsN8ba8JrP6dxUyQm9/Gv6VTV4HRsLZ1dSl2LQ7Bv31MhdNfpspEZKW9KsPrkwD7PfGIPDVLl+CE+Y130UFRbRB2f7yexxSaO+2FTJ597FKIBb
 HV6RU5qX
 cIP3nR0LBV1WuwKggHWRNvANjiLdCjuoylYnXM7JNWGdoj3Qgp2gAjrQGLqYaTaTLxYXzeaIm3PfLnUJzg8yxOnivoMFlC8aan1uUsdNniWO5tD+4jHRmqinGXx1ciPAUfB/bHFHCXjbhKnFa9uhWXSw9hWh9sof9WYAecfRexTLhuXHWCX7Nlqgz5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matt Bobrowski <mattbobrowski@google.com> writes:

> On Mon, Oct 27, 2025 at 04:17:09PM -0700, Roman Gushchin wrote:
>> Introduce a bpf struct ops for implementing custom OOM handling
>> policies.
>>
>> ...
>>
>> +#ifdef CONFIG_MEMCG
>> +	/* Find the nearest bpf_oom_ops traversing the cgroup tree upwards */
>> +	for (memcg = oc->memcg; memcg; memcg = parent_mem_cgroup(memcg)) {
>> +		bpf_oom_ops = READ_ONCE(memcg->bpf_oom);
>> +		if (!bpf_oom_ops)
>> +			continue;
>> +
>> +		/* Call BPF OOM handler */
>> +		ret = bpf_ops_handle_oom(bpf_oom_ops, memcg, oc);
>> +		if (ret && oc->bpf_memory_freed)
>> +			goto exit;
>
> I have a question about the semantics of oc->bpf_memory_freed.
>
> Currently, it seems this flag is used to indicate that a BPF OOM
> program has made forward progress by freeing some memory (i.e.,
> bpf_oom_kill_process()), but if it's not set, it falls back to the
> default in-kernel OOM killer.
>
> However, what if forward progress in some contexts means not freeing
> memory? For example, in some bespoke container environments, the
> policy might be to catch the OOM event and handle it gracefully by
> raising the memory.limit_in_bytes on the affected memcg. In this kind
> of resizing scenario, no memory would be freed, but the OOM event
> would effectively be resolved.

I'd say we need to introduce a special kfunc which increases the limit
and sets bpf_memory_freed. I think it's important to maintain safety
guarantee, so that a faulty bpf program is not leading to the system
being deadlocked on memory.

Thanks!

