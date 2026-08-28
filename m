Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C8EC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 16:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0476B0088; Fri, 28 Aug 2026 12:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1756B008A; Fri, 28 Aug 2026 12:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7166B008C; Fri, 28 Aug 2026 12:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 475D56B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:09:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C710E1C179E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:09:36 +0000 (UTC)
X-FDA: 85151163552.04.9CB6F64
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 04D65140016
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:09:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787933375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EloB0katp8AvIPCuQbU503lG6mYrXa7AvQm9QMftF/Q=;
	b=Y1z4yQ6clof2yJgq9cyJMI/Pc3nIt6DoM4Te7S1QwLeOFqrfp9p8KpN/Gjws13wa9CgQto
	mSFS6rkvlNR++NknBrVVY+rjXmpVXSP9whwT4KfMWdRUG1ug9HSjTDSJhmqJipFnPDj+iZ
	maNG79qRVh+rM8PbS3YmV1Ywivr3UFE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787933375;
	b=6fhotXzLbk9C2GsyTum7gw2V0+VLuZoT//6uQg/rzbbBym5HWtcHJZuhay07LD1nNuAvV1
	zRB9B04HmE+PIryS+lhrBRKlQ85iXxeFzQ/fib9jTXhX53V6bvt3h9mVaroyNls2/4CuPP
	v6dXPKtrBULORE7+JJneIwwTauhFfFs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	none
Received: from omf07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D97DFC03F8;
	Fri, 28 Aug 2026 16:09:29 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id 988AA2002E;
	Fri, 28 Aug 2026 16:09:20 +0000 (UTC)
Date: Fri, 28 Aug 2026 12:10:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Stevens <stevensd@google.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Qi Zheng
 <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun
 Song <muchun.song@linux.dev>, Juri Lelli <juri.lelli@redhat.com>, Vincent
 Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek
 Nayak <kprateek.nayak@amd.com>, Uladzislau Rezki <urezki@gmail.com>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R .
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, Sebastian Andrzej
 Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>,
 suleiman@google.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev, jstultz@google.com
Subject: Re: [RFC 00/10] Reclaimable kernel stacks
Message-ID: <20260828121010.47fa7713@gandalf.local.home>
In-Reply-To: <20260828144500.GW776954@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
	<20260828124758.GP687043@noisy.programming.kicks-ass.net>
	<20260828103328.633bbfbc@gandalf.local.home>
	<20260828143540.GV776954@noisy.programming.kicks-ass.net>
	<20260828144500.GW776954@noisy.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX198HxFyXYgEZJwnf72i30sWt/lWTSWMtx0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=EloB0katp8AvIPCuQbU503lG6mYrXa7AvQm9QMftF/Q=; b=SUQWHdUrQzbFKVWGZ5xuskpOuRiSRULlG6ryJnBZGwRdZ5u67PBT5epIe0H7xg5SXNEX5TvwjgYAiKgBFn8ZVFZTo/UhBe7uCVkXSTXgl3qel4FHrisSpTHR0cXMEvTruijIo6t+0UY6KTNW3HgB/IH3lcx96mDtLDIYxSkl2wU=
X-HE-Meta: U2FsdGVkX1/U5Q0ostoyRiukFyNqFJhukFmTfCLv7rXt7diB6hyl/rZhUovQsUbfRuY/ruuw+CzkC8ZVCbdE5m17xKy+P2Hv3jyfNk0S4gBULlux/YQTMMl9V3ucR2xXxNGvpPJmpCP7P0aDUB8ibU6MmqlECvOPKid5V1OOzQt6NM3cjLlOo9ZuIQpgB8dSi6tyspx69xpNnpLwgNIG3TDSRJvGO7iERa9ou6pry9qFlRoyhFt1aUgs2Vz/JVAzyifFmbQZTDKS6nRAwD3NlsUyrhMO5du3Oou8k5oL+5IF7ADACZKUrPjYxLA7y874Dbta0aVQfHT5D1YLKlytYenuQaXYN9bClOSio+1VJY0xX4vNPnTY50qYg771Vo4/
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 04D65140016
X-HE-Tag-Orig: 1787933360-956987
X-Stat-Signature: fm1e7m8na6kbazt5msh8fyhoegh44q53
X-Rspam-User: 
X-HE-Tag: 1787933374-742751
X-HE-Meta: U2FsdGVkX1+/Y8oCXoAlqilvZF62bvMnPD/a61C2NBPBJ6RVT5CEDaIQWZ+IgawYd97uxRfMFE15cU4WqvXasvKrpBhZ6diVUKyD6eleRwom7/wyKxvvkizqtqoNVplSjmrvXjdyT8tsvI4l3iPnGXmWDPY42fHesaP/2hS8VHEWm6F9PcuCsDUj8n+K3CTpLHYAIUvrDdFYbFbvQhAE1DutTI8cX+HdK4c1ngXe+YSwhBmgmODHDEEZNqfPXi+R9rvBgTpM76aldeH/T1DO197NH6R8mpiln9Ikn4iSMMgNs31NvqxqWZfr8yF6iQCnIzaZCeXm4yF/DeOV1kAeSLU4MQNnAL41bMCb28xNEW+Gzy9c9q6t1gHr8b231PFbwChVQnyKfvjCLzzUraIiZ71dFAEK/GQHNGwuzyBKDPZuxl/LUpog72WjZ+T1e+1JfQybyVgABRtqp9wds+S6gVyxCYcZJ0zcWgsvsM3bxkOqD1edFUu/s1c6Aw4uwrivXNrqSk+RmXGGTDUWxs9EuG+YMOxCFjpgyfk8RGzVLVth9Plr8G9kovOt2mjX8mQNQyDeHcSl+RTxdcebgeJOVq3SbpnYIKD0NwviF5t0eL6GYxMBmNDB1HPUy+/Gjfo4vB2kuEqJdfVa9ZdLHojlrm8ue6NIj09GUZKzMHRsmD3OW8Tucgfk64PKDG3yyTyCRVc4i2GG+lZkZe1kMTACi5DH13jytGYySPvgZGKl9ad3xHO+AVx+AO/uWQVobFmVsetzHoo+5egwiy4AwK0IyCl136k/+uub+Hq8XO6HuwmDzm5Yp4+Y9oXKjVTnIIWFFPz55914DXoh9O3q6sT7B6qFtCMpDcdci+C8zwuhlse5yRcxQxQn5G7V+0UQecImKaO3PfajgIRsxztOI1MeF+x10akFzlnYRCGMIcDEKEpaX7G2wVaVPD/FUFAS+9omUCI5JQoYawzqyktYAVR
 3kF1HiDZ
 5buR2AhKY0xaRbvQqGX73zwOHM4bGGZtgNa6lYbe8AuLNOQelUsADJ7DI6tEq3gMtGVNUAfDi7IYCZjK2XU8/GKttG1rUv3p9LINyDSZBCBY3S74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 16:45:00 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> I realized I actually have a Java thing, the kids have Minecraft, so I
> booted that up and I found all of 108 threads. Which is still kinda
> insane, but nowhere near the 1000s per app as claimed.

Have you looked at how many threads Chome uses?

 $ ps -eLf|grep chrome | wc -l
 930

Of course I probably have 900 tabs open :-p

-- Steve

