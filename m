Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7312CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 07:17:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8516B008A; Sat,  3 Oct 2026 03:17:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659EF6B008C; Sat,  3 Oct 2026 03:17:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570116B0092; Sat,  3 Oct 2026 03:17:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 356DA6B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 03:17:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B36FC0927
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 07:17:46 +0000 (UTC)
X-FDA: 85280460132.11.0477CCC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 16EF91C0003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 07:17:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LtEu4rI0;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791011865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8k358hsoqUyrsPcls8xTBIMgHNITWIlqEj23dCu7cFc=;
	b=5pL9RnK9h9tz4hH2rrdYTMFEU4/M4f2jMTpIvhj542uzhp2tF+DaQ/snX+i8MDCJHtJJjO
	K59/Os3DVGezMPiKqPjMFDA5PkE2dJIKOTDw3eyJ1pO/UY9s19xOcGX2ahYEroAJccWqzA
	zkM7za6142LQByJa2gLmp4fRmPiRVUs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791011865;
	b=t0ooNuELuAeMzhie1M9oKp82LDPHIotFTgf2d+ayVVkaRktSjeYwDo0T9AazX09RvQ3nKj
	nAEat2LLuSyI8HTncZh55uKdjtjoDpyVTxTM0ZRPksd/DUqFcJlDI7ew7Fng3qhOFy/Isa
	ANL8L804BNPKunhVaDtwq9zSjonuXDU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LtEu4rI0;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A4B1602C2;
	Sat,  3 Oct 2026 07:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC831F0089B;
	Sat,  3 Oct 2026 07:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791011864;
	bh=8k358hsoqUyrsPcls8xTBIMgHNITWIlqEj23dCu7cFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LtEu4rI0c+XEIKBMRx0jCl5i0gmrucNi3fExE3MyFznY+EvjMautRUqrp0lPxavkS
	 9K+9gF+wD5qgkViIi2rLRLs8kWBnWcdqrVmph5m6HnnMW5lmsyPB5WN7PAVoQdYq57
	 2w3yvspvkW432MV8LCtBiTfKXO3kneXRxXOzQ1IHz5AP5dcjNz1Gn3FIZvqnHXXZ/r
	 Po6gYOi0zoPPBk4XD/b96TXiACv/YBUmhiwPrm4z9HG2NRU1z1K9xoLKMetCMnq8qM
	 JCRyGNI/sMiPan+bOPRIMBmIrDnFWpgNP+jyFUTTJVoJTy1dm96RZ4lTnMrRM66/n9
	 Q0cETzqLBBgpQ==
Date: Fri, 2 Oct 2026 21:17:43 -1000
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	bpf@vger.kernel.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
Message-ID: <asCsF6hXwOcJ3jXt@slm.duckdns.org>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <bda525506b3fb3e61da28a112f28abba@kernel.org>
 <arw4rjVkm2ob9ioL@linux.dev>
 <bc6815954b8d08e75deadd43e1a2192c@kernel.org>
 <ar2kvmCPR9q31V8M@linux.dev>
 <31a871a07fccc99e953a2d633fc51edc@kernel.org>
 <ar7H__jzvWVtqSn5@linux.dev>
 <c1fdbe4f99352a102b38c7d131215d5a@kernel.org>
 <ar_fuYs_-qS46dVk@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar_fuYs_-qS46dVk@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16EF91C0003
X-Stat-Signature: e3e76xkf5zee6re7yprqe5kgegeb3jg7
X-HE-Tag: 1791011864-141088
X-HE-Meta: U2FsdGVkX1/UP5gw0DKjIrdinJB/Zr76O7nypFiaEiLnGNfNZbyTvrouW6uU/iEW9OMZN9RZ9zTId6sjuFOBA6TVEVsXF04DpcaV4eAgpPwOQDZiC9ItYRiH/J8LEP8aqG5qncfNKa4zZ77+E+JBlb9n1h7SzP3JgcaNalXlqbqhDq14MrwzevDi4QaqXHz+yqjtZPSpkhUSLnHiUgmNis1PZNd0L5HeAZ/88O2OuALyxbuvO5ZqTQ8UodbmMB+Bf525jS9Crz808bQYZ42UF+ZesmV+84gIV0pxsaAaaTvJigmhYsRKFiFp7eT46qdNGrdPGu7hEFlzxJ/E7nzbdsRG1LIQkzCCKM8+pq/eIbTmIqV9jjL8u5upR3MD1EOY85S6MU8d8VF+6gRlU1nmwNFFyE86Foj5wD6ekJt8i57aCTDEjsTYogZkHtC3kGu5ugPeeeIdgiEzAH8lPcs5R7iLluQ35x53u06TewfkYvTnHBUpc5c2VukSjs5uTwCkgh68ZbCAxvcMFdhol+CTvsIIrM9Zf+DzvWfwo2GoQvoDSQkiKJDQssT7lvFEaDUy6E2mGt3ukKPkPWGgtuIv/2bBDj9Z58hnEeHBYga5K431VNDXzr3dAaP2O+s0DvNdh3aC09T2vqq4Y9gVR1ae8pfR0P+cDlR9Ji4t5VlJaeuVL25LJzzk6JbqAxZT0YhB3dta8n/UBt60c2sL3sWJVZSOrgSgKbRIzEdeNYDyxcXlsSJJ5H04J3bkLIWHPlLmVxFq5UWqct9WndyqkGBfr6fl5k19V8MGRY25CNOPz5A8vyfFGYB+HKf5nQT2pvJuAJYRepwtwYUqDjDuqg08QHjcIhyu4vZ1O9Xp5AMxrDVUJmmoP9/hlKWGm8Q1R8mEe3QmjzojamSsSsPAp97QFnkNV+3xv2L00u91TIN1bNtj6KQf4cr4tZ5DuKMKcSEv3UxSG1EZn/Gu8f7wHac
 uXb2dQKZ
 maVriSWlDs49e0DVaq4h2DIGnGS0TeQPT3tpri3V0PV9lBSnMX/KgO4r/P6OxtoXbcOF4Zsbqul6JnlEf3Lrx2sfVX0mOWaFHnR9Oqv9L3jVSw5jzBU2uZheTJfpYwI/5KHIAKhlO2CsjwKPRdqR+LoaJrMbThTDWSMwiHzbV7aKO3R4APQ5zsxzLIAHbrpRTER5OLCPa8vpFauOfJYxDX6R7YREw5uOF6i/XqheiT+9mmrTSx3ZuqiZTi9HX7QppZXqpW1oiqKYnbJ3GOcaCyur/ZCKeWXuK9QPhKK4meBqIprAOqfyCox1rnbRko+Gu7aS5Dg/Gw+azzaSSSS1eK+eZGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Fri, Oct 02, 2026 at 03:19:38PM -0700, Shakeel Butt wrote:
> > On (3), if removing synchronous enforcement wouldn't regress anything,
> > that's fine, but why was it added in the first place?
> > 
> 
> I added the sync enforcement to replace a Google internal feature which, on
> memcg OOM, allows node controller couple of seconds to either increase the max
> limit or let the memcg die. With sync enforcement, memory.high helped in simple
> benchmarks. However later testing on some realistic Google workloads, I found
> out that several thousand threads are very normal of typical Google workload and
> memory.high sync enforcement is not effective on applications with large amount
> of threads. In addition, there were workloads which on noticing blocked threads,
> keep forking more threads. At the end implementing that feature using
> memory.high didn't pan out.

Yeah, if there's no known active usecases, might as well start by dropping
it and see whether anyone complains.

> > As for flexibility, we already have a gradient of enforcement around
> > memory.high. Is the need here to make the shape of that gradient
> > configurable? Can you give specific examples where this is needed?
> 
> The concrete example I have is the kswapd like async reclaimers (plural) per
> memcg. Kswapd is woken up on free pages falling below low watermark and then
> when free pages fall below min watermark, allocators get throttled (enter direct
> reclaim). I want to apply similar concept to memcg (but with right cpu
> accounting and more concurrency). 

I see. Yeah, ISTR talking about async reclaim for memory.high. I don't know
much about mm but that makes sense to me and I'm not against allowing
customization of memory.high behavior via BPF; however, most use cases can
likely be served with a reasonably designed dumb interface and that likely
is a better place to start.

Thanks.

-- 
tejun

