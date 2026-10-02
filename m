Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D299CCA5FE6
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 22:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75296B0088; Fri,  2 Oct 2026 18:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25D46B008A; Fri,  2 Oct 2026 18:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C666B008C; Fri,  2 Oct 2026 18:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71B826B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:19:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7DD3E160844
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 22:19:49 +0000 (UTC)
X-FDA: 85279104498.17.86AE4E4
Received: from mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 63724140006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 22:19:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BhepoCzX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790979587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3waD5f3UCzgiqLjhyqBocfHo8Y3bHeLo3DYaNWFM64=;
	b=GwRXi8F9XW2tuzN5qN5knk30uVJ3QiQNcc39ufBZtxmcWF76CzT+lM++yiDGmkhTuXabuG
	IpfcMkHgM7HJ2XhC+DL7eGUCOclJBAFo6dhSWsufwJhW/21727fbO/Mww8dHcCZ4wMdyii
	d9qF85El2Vg2Wk1DIayv1G4N97Vy9SU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BhepoCzX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790979587;
	b=eFX4F5UWduPjxeQ/4HhjIzjgKB90qm6R1YNgL7qZlKNtUsAOtI9vkWQsvQhKGtVuDKiFgD
	oaC1jIltU2XQk6PUaUWjZ2qMO1IZB+TKR1L0GAi9PlwZXeJJUJp8pS7WMdDfneu/uD0Wfb
	9GIzqiwgSKgGx3tzxwVp3I+6HuW8yqI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LIeypzTLxZFUaXt5ugGV2tt9HvkLhl45i2GZQQOzRtA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790979584; v=1; x=1791584384;
 b=BhepoCzXqCV6+2aFXT/5CmOqdAoSYoHbqDxEnkF4m0Xvdqb6AWvH8+ChwpvQPvS343Ccuu3o
 J42qH3XqO24w3NmnS8ix4Pe+F7ROpe3BO3JCMsVAwMHUneXcpT9E/0xfeCr/FHmKGgh1yIX2Baa
 kARXwtyunWysy7L0cbgpXQKM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2a1b46a32a9d1e0a;
	Fri, 02 Oct 2026 22:19:43 +0000
X-Mizu-Trace-ID: 2a1b46a32a9d1e0a
X-Migadu-Flow: FLOW_OUT
Date: Fri, 2 Oct 2026 15:19:38 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
Message-ID: <ar_fuYs_-qS46dVk@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <bda525506b3fb3e61da28a112f28abba@kernel.org>
 <arw4rjVkm2ob9ioL@linux.dev>
 <bc6815954b8d08e75deadd43e1a2192c@kernel.org>
 <ar2kvmCPR9q31V8M@linux.dev>
 <31a871a07fccc99e953a2d633fc51edc@kernel.org>
 <ar7H__jzvWVtqSn5@linux.dev>
 <c1fdbe4f99352a102b38c7d131215d5a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1fdbe4f99352a102b38c7d131215d5a@kernel.org>
X-Rspam-User: 
X-Stat-Signature: pfynzwq7aw4x1qwaxwawiagbf1jozkrg
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63724140006
X-HE-Tag: 1790979587-467691
X-HE-Meta: U2FsdGVkX19fQ0xpeF5E4k5z2usHyhqI99nsTKN+owQ/VBfNaomeEBeKSqUQpbdQ/B4tiZB4kAKU8kiSXDrXCRucpCoEZT3JE/fyGBd47H5FgiZbMojNN/R68H4SqWmMRcNX2E5H/8vbr8cbLcvYdS38KFQ+RVQHo4P0OlGT8t/RJXSnInXFZZyxWxfv+t4xoDieohCOn9E1CQxJ5yFi5pQlp8BGecx+eLpk2BD45fdYIDmTKp8L5kI6VTWSQWb3PGEPQhosg/3E9/hxl9TeUGkKyX0ECizto5fA0q2qlZ3g9yEqfDtRzVBJMly49HA6d8iPEcTCnkSLJG0QcycPjDpGFoNekFMPHpBZQv/JoUPwBas6f2r11zFdwKRcDgenTTyE0WOm2HE+eQGs4/IawJJJfzRQej7v9K+inJ5AhspBa3hyAEttT8IRcOj4FA799gsrwLt2RoRQMG34fj3w1INQEl1H1eo2/BW4PiHULUnkjJ9rmtmTCvY05W/ZLHYtLF3WtmvFxolPNNC8IE16SlZdgFGWBp4E0wmPUnbtxkczQkQqaDEU1HWcJFF8Dz2IKXshdpEs6qT12vMeLXVA+3oVBZ6aep1lCq9UesixpYdZE7LXZVd/34398YQ1Awr3YO2N8Xc1gh6H/vhQkoQ2Ng5G2Jvy++ySh2Ohr2HhEY+IFPlak8VaC9D6iiWm8usAxOnqPlKc473jZSUO52xqXrZ+oDIN11xpxYF+XukMnV+bHJ8Gzk12HzFZjYmzZrlOWYAqBT0oI1kTlcUT5goDG+VyXYn63Hx9jFAmEAHTvAodufux4PCAftltQU32OP82h/GvSw5MrsgKK2BbxRz00kNJExL6hYMU4KinKVppKmx6tlz3lj53ZWJTMWrJAJpT5aCT2NCZiPin4tvkKMYZV0sxTI49eQnpeOtYPkxJ/C48D45oVpAdnSqyLMGUGV6xx4cS6vn1jk+U9AXuu4U
 kxuNnLVL
 MYJXUI5c2pjusAu9uldsTcL6Mp/mmtYugPdYURNR+EitT62snK5KTGoDiXsozayemB6XmNR2fmxSkP8Yn2LoFajrumcd4ulAACEAgmUHucm+/bl8DZdA6vnNTy2blz3xk+oQrAl28h76my3VNauXnSlDgEza+r5EDsU8oQgiR4ryRhIzunJvERNar/50WRPPPxgP0TUHYEOWF5w9I7h9VEA/rhKIdX8KOlwnXit4QvQoYdG5Y9rhymfFxysd2jm3yBpk2I/SESSu7h5KrUm7G9Rys59vmqufGIrx3HgtLcr3Ndc52+8hy1N4o34x5/VefPiRKCxE0YIrmCGICPnw8yIpVGoCPzXtoQ1x6app3wBbJwhe6EHLpQ6SIhT+KXC6wbappEfLPRwh8Fpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 06:25:08AM -1000, Tejun Heo wrote:
> Hello, Shakeel.
> 
> On Thu, Oct 01, 2026 at 03:56:47PM -0700, Shakeel Butt wrote:
> > We are in agreement on (1) and (2) completely. For (3), I am fine with removing
> > the sync enforcement, but for throttling points for bulk operation sites,
> > I think we should only add them when there is an actual use case for that
> > or someone complains about overrun from those sites.
> 
> On (3), if removing synchronous enforcement wouldn't regress anything,
> that's fine, but why was it added in the first place?
> 

I added the sync enforcement to replace a Google internal feature which, on
memcg OOM, allows node controller couple of seconds to either increase the max
limit or let the memcg die. With sync enforcement, memory.high helped in simple
benchmarks. However later testing on some realistic Google workloads, I found
out that several thousand threads are very normal of typical Google workload and
memory.high sync enforcement is not effective on applications with large amount
of threads. In addition, there were workloads which on noticing blocked threads,
keep forking more threads. At the end implementing that feature using
memory.high didn't pan out.

> > Now, setting aside the default behavior of memory.high, I want to provide
> > additional flexibility to users for (3) specifically. One specific case is
> > letting users opt in to async reclaim instead of the other forms of memory.high
> > enforcement. Basically, users can specify that instead of having their
> > application threads throttled, they would prefer async reclaim to bring their
> > usage back below memory.high.
> 
> As for flexibility, we already have a gradient of enforcement around
> memory.high. Is the need here to make the shape of that gradient
> configurable? Can you give specific examples where this is needed?
> 

The concrete example I have is the kswapd like async reclaimers (plural) per
memcg. Kswapd is woken up on free pages falling below low watermark and then
when free pages fall below min watermark, allocators get throttled (enter direct
reclaim). I want to apply similar concept to memcg (but with right cpu
accounting and more concurrency). 


