Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 411A6C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 16:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142D76B0095; Wed,  8 Jul 2026 12:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A356B0098; Wed,  8 Jul 2026 12:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA596B0095; Wed,  8 Jul 2026 12:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC67F6B0095
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:51:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18CCDC1493
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:51:25 +0000 (UTC)
X-FDA: 84966200130.22.B49C789
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8C883180003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:51:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hYG4YQKG;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783529483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucWwaSFjCVK5PpHi7O84rrG1/RwptI0feQpEp5dgE6k=;
	b=plKrEsZQl0v1FduWyyX7BLSm6vXFKvnE1eF4qVdWpITMv/w1ClRQzZsZdUSBVyHWJ4hPwa
	4X+8NyYutn2rmKqZeYQlggJqtVYPPpuxXpj/LQeIn3zn/smu17AWS+6Na6c4BrG4HCBU5V
	b907D4Ja3etesOTXdHHesuRsVVN303I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hYG4YQKG;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783529483;
	b=6s6SuD8BxKLorBVR7Yw0ORiPik8y/Y4uaAX1FMvwZqQloR07BQBNjBAME6rFJugSEzGVN6
	8IgtZTrY1hoYwnG49N/9YP27L+Uw5ZLT9SrH4KgaAaegMrn/oUGnD4npBMwNNoys1aWzu0
	+1qdgYra23gwliBEon+1Q5HgaVpkyRs=
Date: Wed, 8 Jul 2026 09:51:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783529476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucWwaSFjCVK5PpHi7O84rrG1/RwptI0feQpEp5dgE6k=;
	b=hYG4YQKGDkKYH3KblcwWJAOclqY5v0R+9bl8qfSPdt/Wi1r2BfI+v032SK+xtmgm9Q0etI
	1Xc0nwe57wqCsCChmvrPmdiUYGuQRGnt4ncH/nl0h+0/pE7WQVaMhAta9f4LsIWtSr1UqY
	IQjUSLs6MHcHlFUFkhxZjHeOKDEjXl8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Richard Chang <richardycc@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Martin Liu <liumartin@google.com>, 
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
Message-ID: <ak5-qwmpXrYi5md6@linux.dev>
References: <20260706081218.3438762-1-richardycc@google.com>
 <ak1XzPxbwBF72d1m@linux.dev>
 <CALC_0q9=KNnkQBE_7gC60jZ2Akj9jgL+VaDMFd7yGvqyfTJbYw@mail.gmail.com>
 <ak3Xtrtm5iVayEx7@linux.dev>
 <CALC_0q-juSkv=iqG7mAGCuGqbdCtjEHEy6oD1pcxQkFdBMJHWg@mail.gmail.com>
 <ak5wxwj8cID-QQCF@linux.dev>
 <CABdmKX2C-XPN7Z3G7joSHUxhzEmp5dgNf_oA_ojQ_coM_CmvPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABdmKX2C-XPN7Z3G7joSHUxhzEmp5dgNf_oA_ojQ_coM_CmvPQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8C883180003
X-Stat-Signature: upnn8qryh14u6rgpyks3hm5hnwqyy1yo
X-HE-Tag: 1783529481-973025
X-HE-Meta: U2FsdGVkX18eRZ53XfqlpSAKc0J9Z16MOgRAmIkkWrcC3Gw3prxbmX9PuHcL1IvOt1fupXrRYlY7z2UVfRYRHHHhViGywpKtmsO83kG1/G/U9XlU6WliaKHg2IvXBw8tL2unb+iiWqGHXPfJ7qZFDeaMb4wqe1k/pNQNKqI8FE29VHUASZJE7Bp8e6xHkC7FCztAjQ04G1+KhTKfcnEC2XjixxKpVElg5oA5nQ4MLHoXKwtY3G2nDfNdapIPTTwbkEI8tCKgbqQfFTTlFuxNKdimMy8S9vyOcl2Fw15prrViVKpizYcoIdI2JhhFA3NEeaoQjIRQBvuFsCl2teGPWWxD8kxdGB7LwQmGSd3K9rZXd9G6B0O04Dzj4e+Nt5rlm+TB3xCa1hzE/o8dzOyWWQt01yxF4we7Jlh+kb029M/mE1fX2oHoGzOn5XCHVA1kYGQkRA1+wyPYy9qcZ9wb/Cg3nWhbgJ6+SIVS4R9Lg7ic5bDm8kSzIMKZc0vuSxvT25OPEAL/FKRH5ZR7UmJDHTSEvRkCeKdc8X/gfAXvd1EshYNDAo/65d/AiOrSegkQ4AcnJNdPUSaOarNGLpeZG43p//ipt2N5t78afjKYyHBEtplxM+QMN2SJouHUNPRQ8fjFwdmC0Cj5gTd1jf1ZeLy6w5r+ajnykzFhzeMsSxdLgZfKZL8KX1w7Kb8v0a764JJ84kKcocWpoT9zeDpClYs/CgB7ua1GnNk1EtMVlrFTcESIFsDz5UpDNmDi+MA8457Niq1OPTIIg+H2F47kuzBOh7rx8x1bwWdPot2qKNphtlXTt65+6P3ndu1VJUptd516VZj0P+XHT4P2Pwj0T1DGHwP1aTIFnvsLlVM//04ZcMbTK7ohPo2wRs5MxkgTzIH3e92PxzNEpzHHlmI2Xcf48R4bwG071Vwh1nTk1g9SedGLKYRhgYnZoLVfHWQr3crtId/LDvNe/0BtQDl
 zEVr+qE2
 IJogo5KqgXbZKf4spRVD12+x67DmsJkan73tvE3YbQeV+4U/rn6X+pTVtKcPxxudsoaX6Bg/ltW9R7pjygWuaE2EtPFloEASOBM5TdEUXbarvAb2dmWiDZ/qMTj2EmPfocPVg7XXOw7qH7mH6+73jf9cLmSh8RvWyN3LcXM6e2XgRukQpJ5iDMqr77UjKwpPAw2AF8B0MkGzr/0gJSqW0n5a7zV+dNmjqtgF0emsnUMtAFBJOIVJDGWhbk7r6Jl8Ip0L1fqRRkKLrBz1Js5sGmW6DQhzszJolOEqU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 09:03:17AM -0700, T.J. Mercier wrote:
> On Wed, Jul 8, 2026 at 8:48 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Wed, Jul 08, 2026 at 03:24:15PM +0800, Richard Chang wrote:
> > > On Wed, Jul 8, 2026 at 12:54 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > >
> > > > What's so special about proactive reclaim? Why the same situation can not happen
> > > > for global or memcg reclaim?
> > > >
> > >
> > > The target batch size of the global/memcg reclaim is typically very
> > > small -- usually SWAP_CLUSTER_MAX (32 pages), allowing the task to
> > > yield or check signals between attempts.
> > > Furthermore, kswapd is a kernel thread designed to be freezable, it
> > > explicitly checks kthread_freezable_should_stop() in the main loop.
> > > In contrast, the target batch size in proactive reclaim is
> > > user-defined and can be extremely large. Without signal checks in the
> > > inner loops, the task may continue scanning and evicting pages for
> > > seconds at a time.
> >
> > Why can't the proactive reclaim use the same batch size as memcg and global
> > reclaim?
> 
> Because it is very slow:
> https://lore.kernel.org/all/20240202233855.1236422-1-tjmercier@google.com/

Yes, we should fix reclaim and preferrably have single solution for all types of
reclaim. Though that is orthogonal and out of scope for this patch.

The reason behind my questioning is that the commit message should have all of
this information from the start instead of requiring readers to extract all of
this.

