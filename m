Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E091C5B569
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 07:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088396B008C; Tue, 11 Aug 2026 03:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0389F6B0092; Tue, 11 Aug 2026 03:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F6C6B0093; Tue, 11 Aug 2026 03:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA65C6B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:16:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B6B5120396
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:16:07 +0000 (UTC)
X-FDA: 85088129574.13.42A3EFE
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf17.hostedemail.com (Postfix) with ESMTP id BCC3A40006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:16:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oTAG4OGI;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of linyongting@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786432565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9hscS7M/ID8oh0sD5E2jRXOM1GeBK+zRGBbHPwOAXw=;
	b=xwpAR9ojjDg0WtOJqEbMxRvLxojBGNsDZ6bLNQqTUUUaT8dm72cnn8D6grzgD3KszpWCF8
	9OTZKZxu61p9AgiAz/pRM1uAv0avxlji9OYHHByycefypFq+ws1VDWqw2W5FXAl6Hbih/n
	hrbsc8mpl5Y9T4/EH/w7C81Ql5TS3Pg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oTAG4OGI;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of linyongting@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786432565;
	b=3XP3cr/GpAcWMD5EmF1wzategOJCbm3zz/ClYlRLNyehRIHWZJMLdONWc2z9LFXoKEJMYv
	Q4Gv/mQtCNBc46E42pmDUWrSISvNuC3kG1maTGwP9pAMfPYmPh0qfg9I2U+1ZMMwTJZSPz
	KGQggxgLo4OaGMzt0PuTkRDCw5ZlINc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786432559; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=x9hscS7M/ID8oh0sD5E2jRXOM1GeBK+zRGBbHPwOAXw=;
 b=oTAG4OGIokTLS+821SkkYoos39RJQWAGjdk4QY47HdXEXe6QtWOYUHlFSYqFvzOVzJFNuX
 HlIYmGDTXdFUG9BlfvSjbJ5QtJzPsZNMrR15uGjX00xOIX9ior0o5CIHBaQHnoITif0UWe
 Ra8NmOwyZClZPJQ6iCeQJlUybT865avm89Z+Jer3mx3qYghUhyu2HWrqnHU0gW7aUrulQn
 5c2yUQDDyv4kMufFSM2jkOAre4H3LYn8bk2ETfXtOItWWcCkXri0yuYkjGp27Vp08aeS/z
 JAP9RuIguo9EDY/j/VdUbC8Ej7a9ktXtjIW+vjFsRppE78xIJhjcTEBdQKfFiw==
References: <anlQp9LQw471t3YU@casper.infradead.org>
In-Reply-To: <anlQp9LQw471t3YU@casper.infradead.org>
To: <willy@infradead.org>
From: "Yongting Lin" <linyongting@bytedance.com>
Date: Tue, 11 Aug 2026 15:15:25 +0800
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1
Cc: <Jonathan.Cameron@huawei.com>, <akpm@linux-foundation.org>, 
	<alok.rathore@samsung.com>, <balbirs@nvidia.com>, <bharata@amd.com>, 
	<byungchul@sk.com>, <dave.hansen@intel.com>, <dave@stgolabs.net>, 
	<david@kernel.org>, <donettom@linux.ibm.com>, <gourry@gourry.net>, 
	<joshua.hahnjy@gmail.com>, <kinseyho@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<linyongting@bytedance.com>, <mgorman@techsingularity.net>, 
	<mingo@redhat.com>, <nifan.cxl@gmail.com>, <peterz@infradead.org>, 
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>, 
	<shivankg@amd.com>, <sj@kernel.org>, <weixugc@google.com>, 
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, 
	<ying.huang@linux.alibaba.com>, <yuanchu@google.com>, <ziy@nvidia.com>
X-Lms-Return-Path: <lba+26a7acc2d+0df207+kvack.org+linyongting@bytedance.com>
X-Original-From: Yongting Lin <linyongting@bytedance.com>
Message-Id: <20260811071525.68690-1-linyongting@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BCC3A40006
X-Stat-Signature: futjdy5c3qe48odssefh4ttty5sxnq1b
X-Rspam-User: 
X-HE-Tag: 1786432564-648621
X-HE-Meta: U2FsdGVkX19jWqJes8x4x9ne/HNrlIlIn7GY2qoVVcMHNHNP4k5Ige+nzCUWO1km45oerwYDFBk7FhoBl1dXSaeAkSGJlZqx15dhP2Mastccm/Lk6PqJAhBsTxliIX+FX+QXBQ50qBs3kOGr8zgBn5tqbBCPM3XOXPzbGXf+UL5Ygarn9l0bPKBxFa2IwXvM35KuYLIzAVcFPnRm4fiis1nd0o6BTX0bzUfQ414zRn1goOmKJtSviAYpDnesagvvJImKaq+oIgtc0PMet28J62U6nt5Yv8noeXidJmozj9/z1F8ecCio7n7PXRampe4E0WjUwQRosG71af/9PKl41ToIL8OPae5Nth829xjiwcx0ovOyYmOmMRg/jerXE38PschB1eyoALAPFXz/M8aAsta/XnBWMscLfa7mKqYhRVSMbbKLY2bu6C/b9SuzE1DZAf8zp4D9JO9HR3lcdyIZL84KHLcvLMxHdOo307VcBW/z2wcnYJorzsXosynn9PpaMhyF8Z8TWCjFlVk3lslDTngFeLDs3ahGhFAm94HRSMDtvDGP7uetbUJcZDpdQrMyCJQcoz2cD+YHNXzyxolo91BUF/2tW6V/fbTLRjZ/shNGq4dFpOIYl04N1h0I4a6X0CJxc8bDkkGBTOXVrtv2+cUuzKLnClfSRSJ5RoewkgKPJEhJT9VuD6+XhzQCJFiUfvC7k59M/ppznO2t0wySXNIFGhyar9Y3K4sE9FrATIh9kU2Xhg5sULMcVXGUTPoaW7JaljSymT2csgq74rgy0aF6dWXeyyC7SMYcy1QhCCV8jRc44fmXfGEzd4htTbwhkW9osvLYD1746V+ga5dyVtOwJ4H4+SwKjXl38D7rTqBBwgZk3byg/6OLdsibOJMC63edqMpSEMz2QyhZ8ERq+CVr6WSBYv8o58lpQlI76k7w5PWV/NOGKe3aTqNF6LiaYhoda0bcju2dDHkoeh1
 CEMMr1bA
 gzBxFxCmujqCoomXOlM1AKm5dbr90b86I/J8EtL7/DaKW0A1LyCJsojGlRTS7zKpEHmSEB/GHUaKK4eY82H7QoH7z5Jc2p5gO3F7RCAyMgd2maG/tssGaDdg7gog9FwTWPc05qIEtTteqS+r+QAUYDtEYcr1frKptdWYmTiOu6IPT96FZlMU0gaOn60nRty1XYVPXYi4EPHMago36/XAD+gO4bdkuQISUQqvc/UevTBfjBelmyI4+ZqTqO9Sa/hCklkNNV8Q0Df9aOWNljjVs31YhO0ZG6Os7qSIzCcOqbtCUqzwY11zQNIhIsXm368YVwKxSH8AeMCYyHea8hg7PRRn4Ed1n+0SjFo3s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 05:16:39AM +0100, Matthew Wilcox wrote:
> On Mon, Aug 10, 2026 at 11:38:14AM +0800, Yongting Lin wrote:
> > On Tue, Jul 28, 2026 at 07:24:46PM +0100, Matthew Wilcox wrote:
> > > I don't think we should do this. I don't think it's a use-case that
> > > customers actually want; I think it's something CPU vendors think their
> > > customers want. I've said this repeatedly over the months this patchset
> > > has been in development. I say no.
> >
> > From our perspective, this is not merely a hypothetical use case. We
> > are actively developing and evaluating CXL tiered-memory systems, and
> > expect promoting CXL-resident pages that become hot back to DRAM to be
> > a practical requirement.
>
> But what *is* your use case?  Truly hot data ends up in L1/L2/L3 no
> matter whether it came across the ridiculously high latency CXL link or
> from regular DRAM.  So we're talking about "warm" data that's presumably
> measured in gigabytes (since current server CPUs have about half a
> gigabyte of LLC)

I think some context may have been lost in my wording. Ignoring CPU
caches for the moment, my original point was that the hot portion of a
workload should reside in DRAM, while its cold portion can be placed on
CXL. If some CXL-resident memory later becomes frequently accessed, it
becomes hot from this placement perspective and should be considered
for promotion back to DRAM.

In the terminology of your cache-related distinction, what I called
"hot" memory here would more accurately be called "warm" memory.

Although LLCs have become fairly large, for the working set that does
not fit in the LLC, placing it in DRAM rather than CXL still makes a
clear performance difference, at least for the workloads we have
evaluated.

> I see the basis for saying "this task is low priority, it gets its memory
> allocated on CXL" and "this task is high priority, it gets its memory
> allocated on DRAM".  I don't see the use case where we're trying to figure
> out that region A of this task is sufficiently warmer than region B, and so
> we want to demote region B back to CXL and promote region A back to DRAM.

Our motivation for using CXL is not related to task priority. Many of
our services have clearly distinguishable warm and cold memory within
the same workload, and we would like to demote the cold portion to CXL.

Although these workloads usually exhibit access locality, their access
patterns can also change abruptly: memory that was cold and demoted to
CXL can become actively accessed again. In that case, we may need to
promote it back to DRAM. A mechanism that can identify such changes
accurately and promptly would allow those pages to be moved back to
DRAM sooner and reduce the resulting performance loss.

Thanks,
Yongting

