Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F82F531D0
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 03:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42FAC6B0088; Mon, 13 Apr 2026 23:09:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9736B008A; Mon, 13 Apr 2026 23:09:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281506B0092; Mon, 13 Apr 2026 23:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13BCB6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 23:09:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70D5BB855C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:09:11 +0000 (UTC)
X-FDA: 84655680102.07.BEFE4AA
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4A15D180007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:09:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776136149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BC9qbKtaioDsO7OV/4SegFzJ2eRqN4C85BdI/eOkyyA=;
	b=KIDFytR1aBXpBo856ihWunGdn64oKBPl+nXWrn0MRIEgxpXYZ5QcQcBCaquQTP+q/ilHBh
	dwSpUoK2AJJd8XQnHFFwWeXiBzMBqfdyXHSs07dXEcu5fRYWbA0S92IJtcmcDdyIFymyrw
	RSEj19iPSiKop5xjQSD41i48601VB2k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776136149; a=rsa-sha256;
	cv=none;
	b=ZniRbhXnyqE2UPCfOnQQ5BzvuCemA2Ldx3sttMM5MqDXS12mEFfDms5wH9/9OeL+weMFJS
	J5+cJPSuizuWkHRMllzYlo7v0703YOgLSDYFCwdZ4i7xRs5PXIFhKJMvTUPxxirUk8kReR
	1VNjxsQFHnyRZZZPUaseqHvQmQQgoeg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 14 Apr 2026 12:09:06 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 14 Apr 2026 12:09:04 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, apopple@nvidia.com,
	axelrasmussen@google.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com,
	cgroups@vger.kernel.org, chengming.zhou@linux.dev,
	chrisl@kernel.org, corbet@lwn.net, david@kernel.org,
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org,
	hughd@google.com, jannh@google.com, joshua.hahnjy@gmail.com,
	lance.yang@linux.dev, lenb@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev,
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com,
	peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org,
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org,
	ryan.roberts@arm.com, shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org,
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev, yuanchu@google.com,
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com,
	riel@surriel.com
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
Message-ID: <ad2v0LgMhgZwBmFS@yjaykim-PowerEdge-T330>
References: <20260320192735.748051-1-nphamcs@gmail.com>
 <CAMgjq7AiUr_Ntj51qoqvV+=XbEATjr7S4MH+rgD32T5pHfF7mg@mail.gmail.com>
 <CAKEwX=PBjMVfMvKkNfqbgiw7o10NFyZBSB62ODzsqogv-WDYKQ@mail.gmail.com>
 <acQvNRLpHwnHt7i+@yjaykim-PowerEdge-T330>
 <CAKEwX=Pt04pYfhYOwmtXJKU5OqcxBC14SAf1wpBxBo1D7rPpGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=Pt04pYfhYOwmtXJKU5OqcxBC14SAf1wpBxBo1D7rPpGw@mail.gmail.com>
X-Rspamd-Queue-Id: 4A15D180007
X-Stat-Signature: 391efnwpqhg47mfd7xg3b6gogteqjyki
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776136148-118874
X-HE-Meta: U2FsdGVkX191OZORai9LfjhTYMkSXrdD1tcXxz70sp5OUKG/zTaRPcmOe73qm7KCVGA26DT8FJj8dtDNyk0iJAIErriN52gC2OGlCZa2FusS4tZO7E6Ta4nhJ7QEugxzWBgzpCuFv72zGE6YCNBhaUL5xwlb7PDpM/kmZL9pDHMIthV51BDNcseT/sBFNkg6RYIc3GNyRq4QjujGZLeV1J7/meXv7vjKZaMxfrgojKZVFG2zQ96v/k934aSk8ZtANK2stUyhywsxBYHnrixseXQfSIm3WLeLrVPubiNQWxVQwqkpUGhhVNVP6YfLYvTeMHyfI7OMZXA5JNE+i4G8wc5rh2WgZJaY+50ec6fO0BBXOQt4yW3kKMQip5IxcgQIQWOXlZeAm7pUehmY/bq5+UiAEUk0lvncBlikNGo1kjPRU8fZK9Ql+3VY1LQdY6kkeB0lONnTc9mk1Hhl7aDN2s+6S9lq0qB6DYTLoxrbH/jae5kX+WCl5wrBay5K+IcOz2aoPFP1HPw96CaFrDkRhqlIbSQV39RPw396Xef9AhSWIoUGKA9BOZotzmwso+NG1/3fUv8P29gixxaoUyfSCl+LJqzclYPJAa+E2r4oxL7jrhtaJSjFdpxCXudLAz6/sERcZpG5fob+VEMdAVPZqbCyfltJzdbmrMxdE6uL5yl7U5ceg7Kz76yqRa2ddns79TIMF70ZaNX9rBBR0w3gWFIjZ4q6LvXt4DQ2zPLfrkeuTHLUprtS2MY6a6hzDKFEcNdghJ0CnEh9KEABu/0IzMlPMkbgDg2VcgdB5cHKq82iz3K97Vkvl1c8VFbHsT7nnihm5XL9K8wPEeBtMhsgKWzjEInkkiinCeDWVcWep7Eim0VltKGv4W3PCchEnHQwk/mvOHaPV4VPnikusdP6TEJwpl4P0fKnh6yV8vAwLBj4prddTL8Bw3Eq4uyY3Rm3wNboKdJEur2oxl6Lt0m
 J/tLjUr1
 jalGDnLLpdo5SbbTU6/+wK1O59Ynw9U/BmG4KLe6PmMcdoCWVC+zlbfQHXsCc9GPrewRghv3ESTrJFJyPJPEw65lBWKMidUgM8BC1452hTrOyu/9o5Ho5NDc+3wd52p6EneoxEJkfefhbsEOTSgzXL1bRhMMsZsiBBFDIja6O8A7yHJtMzubomuAPiaSele8ixyd9DOnGObrl8lkOnG2DJshgb7y1XELMudTF3IAwls55Wx6TL1Xa/cZc5zjwJOsR7KyTzJGPsW3xb4Z+8gqtGGsyK9qMbwf3C+gwGLJyS0R+j1+NEeRDwHAey0VN5J+JmB1FfUONGI2xtz2r8AdzkfJjQVHOeOJz7m+KepqJxeeEKdBgMAK8WyEOK+gidaEJN5rnFOJCE2gL9FBibmYFzO3zaNP+6mn73BVp8mrQtOJ+zdOYO3+db/FU4r2ShAbHA6/R52UlPjOBWbM5Uvipy9rDwy/QWLnlZLsVhAyP9iKwBjzzrRxBcwsVQxaldBG56hvfk8jtvQPO3zOVvQ8FoU94vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 11, 2026 at 06:03:04PM -0700, Nhat Pham wrote:
> On Wed, Mar 25, 2026 at 11:53 AM YoungJun Park <youngjun.park@lge.com> wrote:
> >
> > On Mon, Mar 23, 2026 at 11:32:57AM -0400, Nhat Pham wrote:
> >
> > > Interesting. Normally "lots of zero-filled page" is a very beneficial
> > > case for vswap. You don't need a swapfile, or any zram/zswap metadata
> > > overhead - it's a native swap backend. If production workload has this
> > > many zero-filled pages, I think the numbers of vswap would be much
> > > less alarming - perhaps even matching memory overhead because you
> > > don't need to maintain a zram entry metadata (it's at least 2 words
> > > per zram entry right?), while there's no reverse map overhead induced
> > > (so it's 24 bytes on both side), and no need to do zram-side locking
> > > :)
> > >
> > > So I was surprised to see that it's not working out very well here. I
> > > checked the implementation of memhog - let me know if this is wrong
> > > place to look:
> > >
> > > https://man7.org/linux/man-pages/man8/memhog.8.html
> > > https://github.com/numactl/numactl/blob/master/memhog.c#L52
> > >
> > > I think this is what happened here: memhog was populating the memory
> > > 0xff, which triggers the full overhead of a swapfile-backed swap entry
> > > because even though it's "same-filled" it's not zero-filled! I was
> > > following Usama's observation - "less than 1% of the same-filled pages
> > > were non-zero" - and so I only handled the zero-filled case here:
> > >
> > > https://lore.kernel.org/all/20240530102126.357438-1-usamaarif642@gmail.com/
> > >
> > > This sounds a bit artificial IMHO - as Usama pointed out above, I
> > > think most samefilled pages are zero pages, in real production
> > > workloads. However, if you think there are real use cases with a lot
> > > of non-zero samefilled pages, please let me know I can fix this real
> > > quick. We can support this in vswap with zero extra metadata overhead
> > > - change the VSWAP_ZERO swap entry type to VSWAP_SAME_FILLED, then use
> > > the backend field to store that value. I can send you a patch if
> > > you're interested.
> >
> > This brings back memories -- I'm pretty sure we talked about
> > exactly this at LPC. Our custom swap device already handles both
> > zero-filled and same-filled pages on its own, so what we really
> > wanted was a way to tell the swap layer "just skip the detection
> > and let it through."
> >
> > I looked at two approaches back then but never submitted either:
> >
> >   - A per-swap_info flag to opt out of zero/same-filled handling.
> >     But this felt wrong from vswap's perspective -- if even one
> >     device opts out of the zeromap, the model gets messy.
> >
> >   - Revisiting Usama's patch 2 approach.
> >     Sounded good in theory, but as you said,
> >     it's not as simple to verify in practice. And it is more clean design
> >     swapout time zero check as I see. So,  I gave up on it.
> >
> > Seeing this come up again is actually kind of nice :)
> >
> > One thought -- maybe a compile-time CONFIG or a boot param to
> > control the scope? e.g. zero-only, same-filled, or disabled.
> > That way vendors like us just turn it off, and setups like
> > Kairui's can opt into broader detection. Just an idea though --
> > open to other approaches if you have something in mind.
> 
> Yeah for vswap it's probably going to be a CONFIG or boot param.
> 
> But in the status quo, we can always add a swapfile flag. That one
> should work already, right?

I'm a bit hesitant about the swapfile flag approach. If vswap gets merged,
handling devices with this flag set might complicate the vswap design.

Moreover, exposing a new swap flag to the user interface (e.g., at swapon)
raises concerns about backward compatibility. Do you think that would be safe?

Since our use case isn't very common, we just need a simple knob to tune it.
That's why I still prefer a boot param or CONFIG approach.

Thanks :D
Youngjun Park

