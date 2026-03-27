Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7100D10BA421
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D54986B00AF; Thu, 26 Mar 2026 23:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05316B00B0; Thu, 26 Mar 2026 23:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1AB76B00B1; Thu, 26 Mar 2026 23:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B41AC6B00AF
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:44:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DAB71A0F90
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:44:29 +0000 (UTC)
X-FDA: 84590450658.24.F5EFF4D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id A1E7A40002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:44:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hlczufxN;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hlczufxN;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774583067; a=rsa-sha256;
	cv=none;
	b=pzoujOSoqw/U/7Bbn6NozaEiPEpyV5cltQOMcBn5yauKn7JBIDMsFEaCKlBQkS6MNlDdAw
	iOtfH0tmhCHLE35V7N4vLTzTjU61mKs6R5shFp/FIiehTbJtPpcOu5Amjsq2/AUVN2mnxl
	TJ3vYBElOB/NOxCtlzFmBJa4TLc2jBk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774583067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uC5wa+w/5eoxaApxqhDaCeYHRfJbuuXOURYYn2lEhQQ=;
	b=pj0Nl7BLFyFesNGRyMasC15nzDnzPBR02K25/guWMKScxOhqJW9vqHGVz0mWtxHPjcf1qu
	MtMrLqZ71ZiN8aktWnZi6k63onvEXBPCqy1gX+koM2mQJoGCbJ+db162LPAE1f6DZIbEai
	z8rCrQoB029QmbRir+whFLnOf2YA8FI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=uC5wa+w/5eoxaApxqhDaCeYHRfJbuuXOURYYn2lEhQQ=; b=hlczufxNIvXLMlmIiFl9i47mdX
	7SEQtVhjDtRkwWvMKNMqYZ5K9u4DBL/ORazKXpkPRrtZZ63GMhyCMZB8xwaei3Od9oNzoOs1FDQZq
	jH1zUR7jfQ7ilooMsm6Hm7G8IXhbFxk3KjCWIUtc4FsnORAbFtjCvZe9btqvNTBVvnkZcJ3naVf9p
	5WUmFukgHZFHn8y1WSAvoucQ6nZi0wlW1DI3D4r2TXIYEjs8XjZ8WanaEek7ZqwEULAtqzHd6wwKA
	KWcE1hw+507N/PNzDAigbVJJ3tOZFshvcvFZC+ezncbUlUI2YActuDD+Jzn/Y7wwX4eOQrzTi9q0G
	srnCPHXQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5y73-00000001Ce2-3bZB;
	Fri, 27 Mar 2026 03:43:58 +0000
Date: Fri, 27 Mar 2026 03:43:57 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Gregory Price <gourry@gourry.net>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	lsf-pc@lists.linux-foundation.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	wangzicheng <wangzicheng@honor.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Tal Zussman <tz2294@columbia.edu>
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <acX8_XMQYA0-NGUW@casper.infradead.org>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
 <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAJHvVchSfGDubPhir0SgZfr_BcpN5oq_7AY4AZ587_ucgY4Apw@mail.gmail.com>
 <acWXdvHx9mYqvT2w@gourry-fedora-PF4VCD3F>
 <CAJHvVciAmX9OFLBSahwvXL=E+3xnDsL2aE4WKfDBFqaT1Gu+Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHvVciAmX9OFLBSahwvXL=E+3xnDsL2aE4WKfDBFqaT1Gu+Qg@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A1E7A40002
X-Stat-Signature: tmeyxao3fgrbtymte1yeq8ysjshim67o
X-Rspam-User: 
X-HE-Tag: 1774583067-190143
X-HE-Meta: U2FsdGVkX187+PTcat4ZDfRtQD3V6DhNpZPM9K6mCVRlaUAWoRjS7i8bSjhKXXPehdEF1CHeWm56PH1xy4MvxLxGb2abfjVxsftJrp9ievqznFUOylZWMMYX/UbXzAQO1P2DDytW6y9otw9QOHqyN5bZxBgGr0b3ov1vZnph5Be5+cZFj9+H889Iff+OR3mOVZV/GdR+PDYGUKE8vucZRhB8EbtoGaJWMDqHRLwa2GHsiC1Rcsy+wWaakCoOkbdhaY2ykGi/1vMx0F5r0yelkoe1Z4e4iCIQ7l65pzVk+IEaiICGPUUfcLW9RtrfOYVzjPbeILXYiCxaqog1NoSkNlLAj1K+xmXTBXN5N2piBIVTm4jAAFVD4tdRumW0/ao28aLp+GHBi8PJN0DIygx0knbJM1NOaAgGTPZc96ikyZ5lOZxgrIg9HlStXy4P3iuq9hGsPSY80TBja47XbDMM0jnTcLY5Gn9aZvuEgV1+JAjstz5wwAELvNxHdl2tP1TTq/2iyhWiBDbS7ECirgi6AQh8+N03xs0rCnivamohx971pqNBlT2POvzDhZqVvSPRrSzm6DHhZ2k9vH14jGDkm7f/EAM9JhPdje9zWVoDsYIk2+gkNq/9ZDplJUeYnG5FywxTiGx/f85h6qbRdusIDKsGpyFjugTSu1kvxIhjOyaliTVzotNVP4IrY670AP9bAt8tkSvaMLbWzJd/aX2rqIRFdbhXJ2hJ7ktd3JKE/leJlrPtpdUpc6wodKOh3SFFZOXsTjqJI9P2seILCO9oX9fiyyK3CiCvY4a4vh1lyQdTfv6E8kC03Zr7d2czNUp0jx82AuCKeoCX5dacmf4dpFcK0VUwelVRgWXhaEUbNijA8BojP0C/QANSotXwpaP0asVWCVp6i4Qy6oKdex8E64DFs59TCNCMPki+/hApyHKP3Xc0PEDDZjwEctHOZdbJy3gwf68Rm1ldMp8VIlv
 tEEBpPPg
 eqnHdUBE5hL7YwPFvv+SyVhTBAsZzSE+3nHMrPWQitskyAeyA916dUAcqeA1yM+m+oYzs+rfW7x7SbkCr+7CeGvQOhvc/Z8/38amCJaI/PUJ60E6vowdk+YxPUZ0KrGxULZLz6YjvwhGwod/zC4x0iyrCjHEDsVGLXG0fTQNdmAMZ1aeeyAgTUPZ7JYxr6lEUJvMcHZ3EokdRFYsW+lRpx4c0jfe3BMkmdkrre4AwduUNxvOFp38d/b8hzvLWVqGR962BcJEf76KlWr4ref2dP/3F9QbwXCxgVJxL8DORB11DZ96CAOax/AY0cUNdJBkvKGTEn4SyrXfzlfSSVkuWAw7v4QVwRx2tYkn7YKoyA+D65ztqPOXhEmhgJZpEMAnC5tqF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 01:47:43PM -0700, Axel Rasmussen wrote:
> On Thu, Mar 26, 2026 at 1:30 PM Gregory Price <gourry@gourry.net> wrote:
> >
> > On Thu, Mar 26, 2026 at 01:02:02PM -0700, Axel Rasmussen wrote:
> > >
> > > I think one thing we all agree on at least is, long term, there isn't
> > > really a good argument for having > 1 LRU implementation. E.g., we
> > > don't believe there are just irreconcilable differences, where one
> > > impl is better for some workloads, and another is better for others,
> > > and there is no way the two can be converged.
> > >
> >
> > I absolutely believe there are irreconcilable differences - but not in
> > the sense that one is better or worse, but in the sense that features
> > from one cannot work in the other.
> 
> Right, agreed. I mean a case where we have workloads A and B, such
> that there does not exist an implementation that can serve both well.
> If such workloads were "common" to me that would justify a reclaim_ops
> / pluggable abstraction layer. My thesis is that they are "not
> common", so I'm a bit skeptical the abstraction is worth it.

That isn't what Tal was telling me at Plumbers.  Adding him to cc so
he can dispute you in his own words, rather than my clumsy paraphrasing
of what he said.


