Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E171C4451B
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 22:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBEF46B008A; Sun, 19 Jul 2026 18:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70316B008C; Sun, 19 Jul 2026 18:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A864E6B0092; Sun, 19 Jul 2026 18:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7979B6B008A
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:29:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2C9340687
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:29:03 +0000 (UTC)
X-FDA: 85006967766.19.8D8968A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 19B431C000A
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:29:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=T+KZpNyy;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784500142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s14CEhiEMvrJ+CO4bAEdF7C+l4zLaNcCXOHRTCm4syg=;
	b=5/LacQVijEmIjT6Yt+J08Wsr3za9FBn/NhIA6zDux/R2qdQtEPk8MK3VnoGsCReeOtMunS
	8Z4L84mnAx1V8MNxii0jbvEqNDxdjBde/7TXaruTXre5eKjuh1KZ3T1SGZLilQzWjh9Ku0
	uD6uFCcGVJMh9SqVqoTqPrxor6PSpUY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=T+KZpNyy;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784500142;
	b=XGTjBn6dUsyUYjsYVgPj9TGLF1KXOd+BVwt/kySBUT81IBGJ7nLievbhjg+cyLUK/R2Sin
	tugdcI+GE7b2eYE3rN20iCvdkN99kbzClNuM+IJT4u3uTfsYWy23pmzCtjjqBT/fjKadrL
	1Sf49Zn8lrsYyxn0Fx6MODKBMUpnIRI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=s14CEhiEMvrJ+CO4bAEdF7C+l4zLaNcCXOHRTCm4syg=; b=T+KZpNyyRL4Q1eb+oGSpiTb4jp
	rH+h1D7JowafhWq4UOavSyi5cIj7dAan32/dV2iRMPJX+6JBik2MZZLHtTHYsEChsZje4qUCXymtB
	AxPcwv+aly50ZBIusRTNz/w6td1s7IkujvS64EUrIt9gy5xnMreSR5l4YkKG2aZYp7fm49WWYE1nY
	B2jYztCFHvGhU3D7Ayd02UKO/s4iHMlV4OAsAV7GlX3tlDY31em7rWZfb9XTiKmPi0UkGhjHygRpF
	3zPdhz8GZvmQJDUIKou4K6dprbprNnuqgjg7rF5hlvqar9hX4EDls11KyCvd81akFrkwsYTWni0/u
	FvJAf5YQ==;
Received: from [12.151.47.154] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wla09-00000005RFR-15QJ;
	Sun, 19 Jul 2026 22:28:49 +0000
Date: Sun, 19 Jul 2026 18:28:47 -0400
From: "Liam R . Howlett" <liam@infradead.org>
To: Aditya Sharma <adi.sharma@zohomail.in>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	imbrenda@linux.ibm.com
Subject: Re: [RFC PATCH 0/7] mm: defer address-space teardown of large
 exiting processes to a kthread
Message-ID: <ljr2jkxomq4ccgzq2ip3c66mjdryomhl2gxkswv4wzry5ye2ax@xaehxzjkkk3m>
References: <20260719185409.409685-1-adi.sharma@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260719185409.409685-1-adi.sharma@zohomail.in>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 19B431C000A
X-Stat-Signature: sag86heew7qxrtmng8963mnuwpw7gu18
X-HE-Tag: 1784500140-794996
X-HE-Meta: U2FsdGVkX19/AbtRctoHslX+nRzul8xQA6xa0o5oTtMGuFqQDMMm+pA24FbkTOLlZWY3P4NNQZnpJADwU5p/Jp0CkTm3ULxBcVusPY5KKS3USy3LvivMUDMewGz5HiYvI9hJlc+1amUcJz8rfcgcwdsB/ViSfxbVlU6+gOCeTIKWqREucojIzDPwobZIPFN7bAe7xOhfAdDfGO+xVur+za9EX46CmEw3KW9TKOXfv2iO6IKTUIP0VkbTo5DM3X4uSESLvY3fnumNTbs1N4sWT57wso1YfFrRKutz1DbR4VlwcDNYuPlxp1OSnoqFlN9ni3CDEAWsaz5ehWEdC79yBJmvCmZOQa9sx1b8RTi2mcRPp3r1ZJAXXKQaRdagBqlZkMlr1oOkM4WspPa/wqs/4z2CwFDqepJSVhk4QgXrrQ+nejlIMy7XODziZJApvwN3UesiY2HvxE1UOzuoodGnGpG/rt3k3tybgPzTLZXMwyPo1Vs8qA3S936yaVYkB58XhBfBSQ8rLav4a0h6niE29wQsVIqfMrtiNeIb06TQdmLdIlbUoFWY1+TVd3WxI2g+96tTHinMo0qR6wrDY856onsrrPx4bM8e4TysafNIXxZk12WitvcVsMl3xb3TYcVSusdxmzmfr2b0houenkkuX2mYem0KLiM0T22xfQaRFHml7kSR7xut0wO4LQljkvHg/uTUdp/4qBpnA/jiXDEWkS3o3vjSTftos9r/jyYenrK405tlLNMqc0KK7Fq8O9EEIhHLnHYbxXbLnWlnICjfbNx9buANjwh3nRmHSGNCqSZ2CXDMghl50ZPXs6uEmyHrLPmlJ0KkHz8DJUjkAm2+6h70j8J5noO6IQ+K0jvLSsLDEUybDDgaPhT2EP542ea8l7He7Ht+NsebfvwugfwmbEn0gGHIkARGq9K0v3nsazqawz9PeOFS6Sps3qGxneVira8j+NjrxUFUYBhB+DG
 X3LDHyGo
 HpwTiB5D6ddn/3uWoHUStRvv1SCy6SAK3N9JdGZHjeUjPPRgO3TQdVphugdt2ttgqzBta5J9m6Z220cSg+JsAnhaWpURZTI9ajax92ahkWGWUgJiuEAgGQAPXbWgOX2Vds6Xh9lP91PkYViMEcrZwiGOefs7QERYvck8AqGdg1A9AdMypkEQLV2HLrtKr3hQOQpmZP/BWm16Zw4zNUxMotKz6K+CN3C0j5TLybj+V8P79n/RFnelqmQF7TXf3bCCYNMtsWjb2uWP6GEfFnRLjbq5o9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/07/20 12:24AM, Aditya Sharma wrote:
> Address-space teardown on process exit runs synchronously in the dying
> task's context: exit_mm() -> mmput() -> __mmput() -> exit_mmap() walks
> page tables, updates rmap, frees the RSS and drops file references, all
> on the exiting CPU. For a multi-GB process that is hundreds of
> milliseconds of exit-path latency, paid by whoever is waiting on the
> death: a supervisor's kill-and-respawn cycle, a shell's waitpid(), an
> orchestrator reaping a fleet of workers. On the test box below, killing
> a 16GB process costs ~280ms before the parent's waitpid() returns.
> 
> This series adds CONFIG_ASYNC_MM_TEARDOWN: an opt-in, default-off path
> that defers __mmput() of large exiting processes to a dedicated kernel
> thread (mm_reaper), so the exiting CPU is released as soon as the task
> is reaped and the teardown runs off to the side.

This reads like it was written by an AI, but there is no assisted-by
tags.  Which AI did you use to generate these patches and/or cover
letter?

I do not see a benefit to running the task cleanup 'off the side'.  In
modern computers, that may mean switching core types that run at
different speeds.

Regardless of speed, the CPU that will be doing the work is remote to
the workload by design, (or may be, depending on the scheduling?).  That
is, you are tasking another CPU to do cleanup of local CPU-aware
information.. The ideal CPU to do a task exit is the one that's doing it
already.

There are hidden costs to your approach and I don't really understand
how this could possibly speed things up - even parallelized tasks will
take more CPU time in total, even if locking issues are avoided.

Sure, the task waiting for cleanup to complete may think it's done and
continue to do the Next Thing - but if it really needs the cleanup to be
completed then you've just made it impossible to know when it has
happened.

Also, you've just made this extremely hard to debug if something is
missed.

The work that is done in teardown is necessary.  Your time (and tokens?)
would be better spent trying to improve what we have to do instead of
shifting the work around.

Thanks,
Liam

