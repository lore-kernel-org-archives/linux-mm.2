Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F234AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDA3F6B0088; Thu,  9 Jul 2026 10:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB14D6B00A7; Thu,  9 Jul 2026 10:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2566B00A9; Thu,  9 Jul 2026 10:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B43D06B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:54:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B99A1401D6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:54:07 +0000 (UTC)
X-FDA: 84969533334.04.EAE8682
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9C9E91C0009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:54:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4N+VKkF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783608845;
	b=vE1F8HgYv4LKhXtVLm5unh0S0kEFENlB7QQO0e0HQi2cQdLR46d5h4HDEcIw6goBH26cG3
	GCgl6IkH20qv9DzHemH1yp9J8tKiFz+/f0Tk/xDFyIT27e26XHo3XtW5iUAjQ8FCbR3trp
	ot3ZHXbuNvOR9Gc5P+VGdoxNraYKAXw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4N+VKkF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783608845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u454d5mIhB0nOu1CqQBC0ybTPHcXpjed1DznN7MFSXs=;
	b=Ft5ihkFAZWefopufXjd+HxIUU2SrPi+zGlpra7nbSSIjYXuKrQIzgf/rmtpur/+kcpxA8y
	dW0KUIeiFfVdFVYArU9bcrW5kPfbwfVUaLMM1CIZwMymwOmbVvwqGxVAHxqw27468W9JoK
	C4yw2jcd4gJaRxbx8DOTx90ujwTEbac=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC2A66001A;
	Thu,  9 Jul 2026 14:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C441F000E9;
	Thu,  9 Jul 2026 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783608844;
	bh=u454d5mIhB0nOu1CqQBC0ybTPHcXpjed1DznN7MFSXs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E4N+VKkFWWOS8bapsV8QXmtj6E1a5IrfEPvBLUpZDbV3x2oCUCv2sI3ZXTqzmOOoq
	 p5Gnaz1AqvXrVp+DnTRXeqVHQuLv9w6hfPeLILoVV0TYOV+9fOTbkKRZF8papECTFy
	 QxKzh4b1DYXzWcqj/9goODU1sXsYaHiHGox43v/ujz8IE2UB+sLm56ryHziFZKNSos
	 JAq6u1/25pk6PvAxDpXFxLwnIJ3mOWHZSfFueyHLoWBjJhOZc539HlZfE4Ox2vrH2T
	 lVVXs1dIygIi/6lnNTUq9jjv/12423Mv4WCXoAVQoZc2b50WK+jhDLrR6DY85v8yQs
	 o15o3Gni1rTZg==
Date: Thu, 9 Jul 2026 15:53:44 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Eugen Hristev <ehristev@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Kees Cook <kees@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Petr Mladek <pmladek@suse.com>, John Ogness <john.ogness@linutronix.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-arm-msm@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 11/26] mm/swapfile: Annotate static information into
 meminspect
Message-ID: <ak-1HujOABoQ9wR_@lucifer>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
 <20260708-meminspect-v3-v3-11-7aa5a0a74d5c@oss.qualcomm.com>
 <ak4AgXqMnkn8rVGE@lucifer>
 <20260708190535.fhqaddicljho44eq@hu-mojha-hyd.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708190535.fhqaddicljho44eq@hu-mojha-hyd.qualcomm.com>
X-Rspamd-Queue-Id: 9C9E91C0009
X-Rspam-User: 
X-Stat-Signature: t7x4dn3y9xqz5gc66rbaewxpn4k5bftq
X-Rspamd-Server: rspam03
X-HE-Tag: 1783608845-35077
X-HE-Meta: U2FsdGVkX1/GXYT41cu2xxf1cJuni6879i1PdDkQUjnhtqzt0LGH0rb1O0SYHMdqOf6qhD1YMYQzwkf12tXZdeNqFckKZJKTq/J9dDJH500XuS4KAo7/NSaT/cGYPX6gZEi/MUFXHCY2bS5uV/Bop5eHWwOBDrzWekZUqioepDbQTmjSkJJg7utssnYYkcuvMMXJD0FrZ2J7S6blS57Ou1SW5b+kmQlr2Aazntxf2ip/TiXCzydzCwaf421U7UnNbU0s55Y1MLT00gBoGj0hQHvXiJFuIAtWVeI8R3vxuLjnRNMKBOXGoRWHuntPMe3klwdOmJB1EVfp9ggQ2D7FwttC1VtLKKBAx4LOC0CzUPQUwUXM0nwwJfc4Mkx5muHJOvBANyOA3YfpVmmtCedqlibAhqWro6aLer2oN3ibMbOESwYV2GRwptkvD1MjDTXyaA+vzT5RJiWKNYD2R5dG7emrHI4K+vZ3o3nMp2Zq6BHki1D2PWh9tnoHTEEk/PmbWPWH2NXbDuf2orE01aQEc03iMiXsJY9S2ngnFcsDgN4Fbj0JL0q1c8Bfro6hIMrRUkXSs+Rt3/ESP39j1AHl18wHnVNyoErhrNHMyXdFYyWI79IKUvCsRDXgXPh81BxTjdOpDtaMbpCQ8ct85ZUReLHjIdnr13zfvsaQ5sife8Wizfbt8k/PmkdGygX3v0gDKllRBPsPCmFkTihACjVEu9CCbTu8Y1XYYwFQUMwsCjnE66D2nLDtwM3rDGzU/3xh5C6m4lVrSMoN30cZiEl75mqLJxkffcNTw0C7eknXv7OBGs5CYb1aIs6se1lZaFFt3tVzUSa+QLCgA0HNZSmCeOBDwiGquoEinRV2dxMAiYxUMfcbdFveRYhbkyIc5hBNuLzzzGJUEiLp+0EKzSCosh1F3R9qNK8Ltv0doCCJUsiCYk31xgGehRG08HWYBO8H3D1mRLpxbpQ8qCnF9Mf
 JwZuyRk7
 JqFq/9IsHOGgU3KQ4SwXRMDy5ZIFsG8HMHiAJ8O48E2GyEZs169J3QmntH6QRzKiIIsni7UAU/PFBURGeNrlqesbmAG5wI8ztjYwEW0MsWg+8CJ1AYC7P06CZDNIFtBf0eo6cM9K8+5wyF8xpubWWemMMcTKfpyX0seOUCkDSIzodIyq1AQs12lciEW0/wR5NIUkTtYwa4JOhh/bdtqcy6lMOjX1fEJL61YnknWkETG7D3xaWcA/RmgxZ1MPlou2tdtQse8ygCMr7r1itu05/pIJfF/03elsd8Nqf2JViFZ3VbUBNFxvtjCFl3VCCtPLFRcHRHSwoOBmqVn52DunzFBuB+ZcNjiX6tOl4SpWRakotY4BhaqClVzM9Jo17oqpwWjFT/pl6bSaOvV6TgPZ+gILRvU1sheSUhzaNUeznv8/Zvr70Eyn8/Go3ZWjTHyIqNqlDPxbLLP3hVA0KSWqmu4qEaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 12:35:35AM +0530, Mukesh Ojha wrote:
> On Wed, Jul 08, 2026 at 08:47:51AM +0100, Lorenzo Stoakes wrote:
> > On Wed, Jul 08, 2026 at 11:01:50AM +0530, Mukesh Ojha wrote:
> > > From: Eugen Hristev <ehristev@kernel.org>
> > >
> > > Annotate vital static information into inspection table:
> > >  - nr_swapfiles
> > >
> > > Information on these variables is stored in a dedicated meminspect
> > > section.
> > >
> > > Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> > > Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> > > ---
> > >  mm/swapfile.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index a602e5820513..d480727e4987 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -42,6 +42,7 @@
> > >  #include <linux/suspend.h>
> > >  #include <linux/zswap.h>
> > >  #include <linux/plist.h>
> > > +#include <linux/meminspect.h>
> > >
> > >  #include <asm/tlbflush.h>
> > >  #include <linux/leafops.h>
> > > @@ -65,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
> > >   */
> > >  static DEFINE_SPINLOCK(swap_lock);
> > >  static unsigned int nr_swapfiles;
> > > +MEMINSPECT_SIMPLE_ENTRY(nr_swapfiles);
> >
> > Now the EXPORT_SYMBOL_GPL() is an EXPORT_SYMBOL() in effect no?
>
> The whole reason we had to tag most of the MM symbols is that
> the crash tool looks for this information while launching itself.

You're missing the point.

EXPORT_SYMBOL_GPL() != EXPORT_SYMBOL().

We cannot and will not allow symbols that are GPL-only to be exported by the
back door to non-GPL modules.

Meminspect seems to ignore all of this and just exports symbols another way
overriding kernel mechanisms which is just not acceptable...

I also don't really understand what you're saying here either, what has what
crash looks up on startup got to do with anything?

>
> e.g.,
>
> ./crash --no_modules --no_panic --no_kmem_cache --zero_excluded ./vmlinux  ./minidump.elf
>
>
> >
> > >  atomic_long_t nr_swap_pages;
> > >  /*
> > >   * Some modules use swappable objects and may try to swap them out under
> > >
> > > --
> > > 2.53.0
> > >
>
> --
> -Mukesh Ojha

