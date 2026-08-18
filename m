Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9F39C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:15:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944F76B0137; Mon, 17 Aug 2026 23:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91CD86B013A; Mon, 17 Aug 2026 23:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833486B013B; Mon, 17 Aug 2026 23:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6104D6B0137
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:15:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B41FE80A42
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:15:26 +0000 (UTC)
X-FDA: 85112924652.23.4679C76
Received: from mta1.migadu.com (out-35.mta1.migadu.com [95.215.58.35])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9ECB4140002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:15:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fWoEI2Ao;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.35 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787022925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gdwn4Mp6UhNovGC1bZn3V9R5tEd9VnDd5H+H3PR8T8k=;
	b=1fxoSrtNXj605AgfXKZCD6LxRe5miaDpb7DfMxA4Rf6Y+DEBPtp1R6z0Le7XAwHMNbfhgc
	JnHwP1TN7qOskvTm/ZzsN1pugEb0XRsYKt/X96iLw2x/n8bP0r7kJ03mz932vsneoGAvNp
	Lvs8i25IwcQ7W5vFUSATuR6BM3eMzh0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fWoEI2Ao;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.35 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787022925;
	b=pTAMMvcRIvQIQckLLmdLKmur1uocc2rTx1zgwFLeyhA6OLSWe1BFn5O2pp2HyTBtJkhvoR
	YXu+FCc594g96hxbcHqEvq51QcgFrMQmndsY702NXHOEOb5m+Ye3+hy9YOuVPVgfbanh2s
	q7UHk3bXAgcJR0+JuuEHMzP8BDLfA1E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QPjkqeMQzOAZpb/zyY52x+vxw+KmNvb6bRJRhWPK3mw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787022923; v=1; x=1787627723;
 b=fWoEI2AoSNK4ISQ1bMiEYIXBx5uvD5XXW9ySANPlXaBYKAxH7qk0XdW0mBooYSkDLJ+fIIfs
 TlPY2+0FvliuUTHqVRldHeucnVQdr9HWvl3Dc5yU0VnrKGXJ2GhFYRh8XLK6hkn7lHiia6ZjdHA
 JD0asjkYetuble1r1tROkbJc=
X-Envelope-To: linux-mm@kvack.org
Received: from fedora (117.129.78.49)
	by smtp.migadu.com with ESMTPS id 68147398b43ced4c;
	Tue, 18 Aug 2026 03:15:22 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 11:15:12 +0800
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	kasan-dev@googlegroups.com, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH RFC 1/5] mm/slab: cleanup deferred free handling
Message-ID: <aoPN2evd_u09IxfR@fedora>
References: <20260807-kfree_nolock_kmalloc-v1-0-ba993cbf7a60@kernel.org>
 <20260807-kfree_nolock_kmalloc-v1-1-ba993cbf7a60@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807-kfree_nolock_kmalloc-v1-1-ba993cbf7a60@kernel.org>
X-Rspam-User: 
X-Stat-Signature: jnyeu7bjizw8kzh3ddrreds6mkrqexg3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9ECB4140002
X-HE-Tag: 1787022924-413036
X-HE-Meta: U2FsdGVkX1/z53g+5w8BrSRvbh7/VjQ6A3kv3Jk87QvkZf0v1pn2J0cKe/oZaNzJ0mWjuOyw0OyJlUrym/Nn1LPJMbwwMbQgtzzPncEDmzGPYbn7O4WXoOFnoTH7KcfQQ6EYKCtzCvLjZhCYsOupZ8Vby3RcJJlJj2d/Y+iDPCvxmWTsI9xT1HAQPfNyGc7VC7p+bdsu1PQjtzpeDxr7PJos3PB9Q8mwQLpMOqbFyZTsNEltNjoQnZIzuBenqBMNq9Tsi/j/CQb6Je8Pgt2LTYAwC4r/b0Q0/+a2Qj+mThdnGz5rmVXA4qzzE2mjG78sMFgh5+rI3GQPpzF3HcgSoIlEm1s2h0GeIlTBdaqOuZDpof3rgE0EySybBJP1eLLdwGcmRHODCQF+MeQfvUvAwIdmOy8BpoWVoyr6fl6n+7Uch7hDnoFK3uf2oVqZrwaGzGW9uLC4ZKGfwTyS74GqFVY8iumIZ+SQvqEE9qYzJaiJ+slK/60Xl4sW+GISrblHTaW9UyH5BPELVU6ds7g1CM7jFRPqGsf6T5avYT7Cm93cf6MJK28n7HL2n51LLA5qqOw6AEhcHXxtAQZyzn+J47tM8pLinGH2tJbHZJGnlzEjgs9wsRqIinktTdqO9KIHmFBXSVDsVS/hzPiG0zBeypuI61SL8o7KlUiDGaXv8SEL3F/HYU6ZX7jy+n+GdgtW+bBORlAjyDQvGzUEw2xyJtjee1/gkPcDgPdVDVnhedKUTOm9eZyq6ECp5epSSNU0cWT/VGqpu8NKZbgkZWreBWfmPnROAcJg4OPLy3PixIzyqPM2QkhRerljIKrWYQ/6+QSAHvapvxpTQixwx2DCkqcH7+30w+E84gZ3OEzNCFP+a4wuEkgaNNt4YoM5XX9eg4PVR+c7pSjEGtEOcsAC15vV4+/g/8JlFTOFQ8O4app7CcYhSxRla3w5pQeQZWcGu56B+pKDBQgODG609yH
 e0C4jf3Q
 DP1TFmwV2iLLpqqlsGwSduelTvXeJyh7kGj0O5ac4MxU/GSbD9jB9510sbL8kqZHRvXLtt1TgHrprenfID2NGSZ51+bmfOpnvKwKrmdP+1dFeGpwX2tbOltt0qgqVp2nY92CEPgh/ZGRPsFfppnBsxUuhZr5bs+vs5uAy+dvCR+XEl2kNaVTfWENJmnnxCvLYyzKbYHpk3OfWO72RWXdobaoL3IeoOoABq0qCiGDs/x9x3WDJOXF0zHTKM2pm3app1niU0HLQDxtYhAtk60ElsGM2gGGFGm2tCYJ6OjzphQILOYlUhNgSJVFT7bW7Y62mVrf/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 03:50:27PM +0200, Vlastimil Babka (SUSE) wrote:
> In deferred_percpu_work_fn() we have a bunch of single-use local
> variables for the various llists. Remove them and access the lists
> directly.
> 
> In defer_free() make it more obvious and documented what we are doing.
> Also restrict guard(preempt) to only the necessary part.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)

Looks much cleaner now.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

