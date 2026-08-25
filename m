Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 360A3C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 07:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136786B008A; Tue, 25 Aug 2026 03:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E77A6B008C; Tue, 25 Aug 2026 03:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3FBA6B0092; Tue, 25 Aug 2026 03:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D70366B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:32:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 542EBA36E5
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:32:07 +0000 (UTC)
X-FDA: 85138973094.30.723CEEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id AFE07C000C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:32:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z4g/5Wuu";
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787643125;
	b=HHjJJeLj1hxFmOuKFhIWIpU54OP2VCpaj0yAX44l7t1YO3FYOdqsfs/+Vccv5jCre/Ru1Q
	HU8lMj5F+k99RpEpl/iLrgq9MMAW1YQXqSKbUN3IR42aRVl8aQSVMzeUVUpM1WduIPr8Ku
	a3oIUg6WTj1nmhiPizi/0FyYPz5aAyk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z4g/5Wuu";
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787643125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pOEToaHFZ1KezTVQLT895r8MTCYw9JPZrUoSp64NpPo=;
	b=gugoDH4j7pIOTUDgOq/2i8ZvziXjV1jfDZqe9x8HiYy/52M3jlfVQlbT662kiQoH3D1DNF
	OzTLbb48cyPzXw9EEz8aYAzeVOzYpEefBEvzpmGEykIR+b4Nluxs+dqBlGZDkblsG8MIMN
	Ew/VRkvWe+aZK6Tp1XqFW5fhQCqyfGI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F097410B4;
	Tue, 25 Aug 2026 07:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6908D1F000E9;
	Tue, 25 Aug 2026 07:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787643124;
	bh=pOEToaHFZ1KezTVQLT895r8MTCYw9JPZrUoSp64NpPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z4g/5WuuSrT94p10shBVAIXPmRKgbAf3s/fvhs/4tFk+uVYx28S171DpFdj0a9Xtu
	 yTgAB0qfoK70a2ye7WIOmkKuqCjxINjcN0eExJDTuRNBqiinabd9CGUcwpYxZmIH3s
	 A0kNWY2SdjirMgff3v1e0bjg5Zda8IR7ORCKEQrBFZoKCrT/hCqjtKapvjkQ2xpfVN
	 aAnIT1hGn9XvE3sPxICXKO90JPq+Dics4zTCwjz0acMygp6SMe5XJ/h3sRF6PIVSHA
	 ijnfHH3HK2dEqvm36yUHge9E/WgJxljCqXRw85kpAtXpDM/79/D+YtvABmbSMjvNJU
	 LC6rJGO/S2iuw==
Date: Tue, 25 Aug 2026 08:31:53 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Atish Patra <atish.patra@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jiri Slaby <jirislaby@kernel.org>, Juergen Gross <jgross@suse.com>, 
	Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Pedro Falcato <pfalcato@suse.de>, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Steffen Dirkwinkel <lists@steffen.cc>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com, x86@kernel.org
Subject: Re: [PATCH v2 0/5] x86/mm/pat: CPA fixes
Message-ID: <ao1EtJG_Gj8f90WQ@gremlin>
References: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
 <556337a8-5e2b-45fe-a1ba-90a90c1f3c4d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <556337a8-5e2b-45fe-a1ba-90a90c1f3c4d@linux.dev>
X-Rspamd-Queue-Id: AFE07C000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wuo3knaj19j141jnswemmy41r6qhu1jb
X-HE-Tag: 1787643125-133325
X-HE-Meta: U2FsdGVkX19oXOly5G6dIlUlvBugVOgP3nN0IPLrHvyrXpBKBl70YrlkSwer7O1v/u9Pz5atEBJSXid2ZUp0KxDYUsWbNaVnZpzXStz/pS1zGTsf+hTxWXEYPIGE+9THotgQcR3RfO8mEWraaVJokQ9rRrMxPc1vv+y4RuQHf5dMvEzAlTDzYdsr+GJNk+cs7hKs2bw8mAIO2u3jtFn3tf/Q++nPzIiPTobPQZfQyBpTmF3ftkp2hZw1obESlr64hPypSsCslgINiY4yYoMIQEnw5n+7g03fuaIsgjfu/I45lLmWPcaXFONwVLQ6/LvBHcxLFSIzcGK4M5EqqH5lhs03aNJ6vf8LEQvaDa+l39ccuPoTBNxP1FpBePp1COUWo0M3JB4DpyYeYpAEeZNLNgNoBnDo5QP+w0HnOG9A+5pK0HK7mxQuNm1zvbhNxBcERTG4/mUc5gIHzXFCuQQLfepqfW03tZtsJkQZvnM+miO+vMqMXK8QLfIXoAofeiIPS00L2ojgeRPr9PBZBhfn81U8wRcLJI6wbjah5oVldr33xji+rYpEZqrgGyT6rUJDTOV+rI8NFzZE2BeqtESObD8IjqX35g3PFP+fSDo/j3d9J4soM3TsGFmgpoZNo8Sf3K+jxUDEqNLjjNwOhvL4UEBKAaVKT5hoDFxBZreUEL8V9tsi+tpNOY2XXzE3qYvtnX1dR2okOb20KTsGRWWwwzZu15VqFxDr3NshXbXETpUwpfRvddGPzhXg4sNdJ5nJNrN0g8Jckq3vDGmJXwIP6fPJYl34XO53WTx7ME8aY86sCL752aKpvWy2wgC6bA02YbD+cyPMT0jA+ZE0Jrk0IaGVn61tJ0X0MqNMHNBI+yG1eXy2OLtJtmK10lePkLmxQVueGwyZdGBj/2L125EMjxApfqrodCZlsKEGipQZFAiZ2KaNgUjgNtwvyqPqlptBXoW5cSek8Dw+E19tZur
 QzqNgVBx
 fO7wYWMTUstUAdm8nClk45yRgyiCTClA/K5zTRMQEtpsVj8onpLcZcrtHHSpzt5KVlvwDAzaFHPXZG0WMdFS60vKxWB5MWU1jCxskmRiV89pfuuMFxUFd/K/I52rgZ85M7+cXsdO/zvL6PU9RoPxwAgD8opiJ1Aq4wPc365LFOxQ+Gje6771P2Gi2ngNdnDaFUySo3TyXER606xCqe0j1ruLftT1xLtAyDEucQjCl9nYtMAIAkB0SjxhSHttOtotSPyRt3n/Z2E8g++EfGIQ63g4O44tQR54ZvHHLf/nvQSqgBIEoTpmr1NU6rMWJ0np0Liw6F3Fz0RA5xauspGfyrTheTFk/2T8zXhR//tLVBpRpyOGzyc5K7qAMqJlFH0BRsXQa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 12:12:32AM -0700, Atish Patra wrote:
> Reproduced and verified this series (patches 1-3) on 4vcpu guest running two different kernels
> 1. mainline (commit: 77ae27fd98f3)
> 2. Ubuntu Resolute 7.0.0-26 (production kernel hitting the issue in a VM)
>
> The Reproducer consisted of
> 1. A debug patch a cmdline-gated stall between the two *pmd reads in vmalloc_to_page()
> 2. One taskset-pinned insmod/rmmod worker per module over stock cfg80211/dummy/veth modules
>
> With the above reproducer, both BUG within seconds in unpatched kernel.
> 1. Resolute in 0.71s at alternative.c:2564 (BUG_ON(!pages[0] ...), RAX=0)
> 2. mainline at alternative.c:2473 (BUG_ON(memcmp(addr, src, len))).
>
> With patches 1-3: zero splats across 10 runs each (600s/11,378 module load/unload cycles on mainline and 1200s/55,980 module load/unload cycles on Resolute).

Amazing, thanks!

>
>
> Tested-by: Atish Patra<atishp@meta.com>

I guess should be applied to patches 1-3 only strictly? Or perhaps 3/5?

>
> > --
> > Sincerely yours,
> > Mike.
> >

--
Cheers, Lorenzo

