Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD852C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E36E6B0088; Thu, 30 Jul 2026 06:43:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493FF6B008A; Thu, 30 Jul 2026 06:43:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA656B008C; Thu, 30 Jul 2026 06:43:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F042C6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:43:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 400AEA0111
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:43:47 +0000 (UTC)
X-FDA: 85045107294.19.C420D65
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf23.hostedemail.com (Postfix) with ESMTP id C108F14000F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:43:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=NuWQBwxC;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785408225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RksSVJP5jpMGYGZkzaOXY22WiKXmSFnpB2S8nUJGyiA=;
	b=i2mxdTGp4t3hX4eiabIy89Kebg6Fz/Ge4Or1IRni9epRbhcxJOLrWurEyY4vHnO3ysAtsd
	Yf+JSNLKPqZ9Jl78uyAmZMGMmkF9Dfs2b82N7aaWDAG4eWQmndyebko4NNpxSE7R8p2qpi
	b6gQz0APkSgOw2UGuDKEthrMGxBLDRA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785408225;
	b=nICNAEuoL+lj13yJJkSAwfZ2xNwQ9zgED9MMDYr37oROGp16Rg8eStyjcrwf+EDKS+KqVc
	OiwTHCsdSZbHV538C1I7e8y1MVq2O4DeQUI2UIZE30oyV23oZXuv3YbSt2nNEZRbJNM57r
	FyaSqPTtYeyFIxOv6v5d9yjtZE+1G20=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=NuWQBwxC;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RksSVJP5jpMGYGZkzaOXY22WiKXmSFnpB2S8nUJGyiA=; b=NuWQBwxCS29i0hlQyqjXwOe0Pu
	gNy7UmGWU1XId3HCqlSJ5sFR4kdI2VFCMacjLjNAitE7kS9ezihtgf7cfnXXnzwAueKsx3Oz/FUr3
	TVcPPoRbsThHggoFcexzsZNgTU2ufq+fQUzsZfBwZ7TfS6m+3uWvSsEJNUYO1/0++6ZPWALf80Yag
	79wMvCTPJf85jN380KuooBXWSvkzYiaYMraPqlr06E+luy/UP7DEoT+cD8aYgSVu98ZmpeSTptJNM
	FSYd93D1sHju9KLXQ+k6F51eD1kOult88Lzh3N2djL/hKFUK5ObRqjbbFZl7XIZ7kC6JmHiX80mx+
	O+piuZjA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wpOEh-00000006arK-0WA4;
	Thu, 30 Jul 2026 10:43:35 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id EFA4830095A; Thu, 30 Jul 2026 12:43:33 +0200 (CEST)
Date: Thu, 30 Jul 2026 12:43:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH 3/3] x86/mm: Fix and document DEBUG_PAGEALLOC
Message-ID: <20260730104333.GE751831@noisy.programming.kicks-ass.net>
References: <20260729110807.797920433@infradead.org>
 <20260729111119.604452135@infradead.org>
 <amoKo2LoJvfndqHn@kernel.org>
 <20260729144838.GM651302@noisy.programming.kicks-ass.net>
 <ampPb0o0T_JdxrMx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ampPb0o0T_JdxrMx@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C108F14000F
X-Stat-Signature: 43u4tq3wyznqhexod9gcnzpe4yjkcx5w
X-Rspam-User: 
X-HE-Tag: 1785408224-314500
X-HE-Meta: U2FsdGVkX1/IsraFmS6EarYc31suRnazksm3L/l2wSCssYKiX6v8OmWWA7f4meVclGdP9eCviLc0PshGL5yMP4+3BZzAyhGfNK1C941Hf3pbMPY3BnZhXKzDTWyiFM7g+zz3T7j98Y1+ocl+6q4NlKuYMCrsQg/+iWwzCQ03aOVnQUTbrSQORpiE7fl8mG6TpPa4VgCiDFJ9pjx3kLhcdnYH+gcUfdUai9H+sesLUjHW915xKKG2dMAdDG51OFehyQueRdY2E/CBT5ca0GIBISCUNg6bTJG6jwNVfcI7CkEiZqkh0r/tDXDm1T9R3IDg+nYlVzdwqVFuENBeDJ/Y4Pd1yNx+Xm/cxsBmjIY/uQzhg46MD6QZzLjNi2LyM9zK+GvhZAQl5rzi+Y2MHvlGwvnktLJh0l7Q88Qddbf8nlImACJfFDxAolyT94TeI8mBkfRXNWzsO037hp8hMgK7v8ENaZNv3Os+dPbMWTSLBnI3WW/lIChf4uEQDBJGwKp5ruvH9MgxgerBIgfcssE7wfHR2aLuGnOcd8SjBucR0rgNswYHTXSZnhDDqFoxf8DiigKALMn0t1948sicJ2oF069lFA+z3RNT5SpA73j85hlF6xsPFHu8PRJyBpC4mdchFfR1TVFmKNnYiHAtwRYI8/pwe45tF9Y9LZWf0GwwVz3O8n32MbwehKD2YC14tPYWU5bdpGl1j1XgG66mYClV5zwq0u4E42+ZFPRcBj4KNFr+oXI5OiwEfz1Hvk/XJq/lrW1Ia8iSvnFxZNbW5+/9C4rKALtQ5BzvxlmxG8FdjBm3ubgVh/wk1gvVdEFaHyveTyFOhehtZKM6U8qzTXliSvkXn0wXqirb9XMvLouZaepbbpTpsIcIMysB1GVpRHgwrwMBgmZ1gWaTdmzcaz4YM4PMNCHoR+TOjqleuvfdCCnmFj6Ru5TQCwtD1TcGZFsX+Nw6gfKoSFxUrFy7aQq
 EmpGbgNB
 aTs+4C45SvnexIJLmVGhuxTnvigv3OtMOBiuv8XU53wpu7V3lz9kGqc+L9WfZ7c3lcq/kT+hAQXf9AwEGdcdf0qhN15XuJlpKTwWKP5N+oJX/VfDAlQl6GU51AQFfHe5GpNVD0L5da14N4ffIBAPFBDZZhEO7Baa1sHyt8kC4NiCMiT276Xg/XKIg1nunR9i4SRnr50xmHQw9rrDi/aQBfo+adX3zb/wW7XBNs+gyKLrJgIqYD3cKYH5L+rLpAa38+DF1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 10:07:27PM +0300, Mike Rapoport wrote:

> > > I like my version with your comments added there more as it localizes the
> > > DEBUG_PAGEALLOC exception in the lock wrappers.
> > 
> > So I don't like removing cpa_lock entirely; it is still serializing cpa
> 
> I meant static inline cpa_lock(), not removing it entirely.
> With your comment why DEBUG_PAGEALLOC is special.

That is, I despise the whole:

	if (!debug_pagealloc_enabled())
		spin_lock(&cpa_lock);

with a passion. It blanked kills cpa_lock as whole and changes the rules
for everyone when debug_pagealloc is on.

cpa_lock ensures that concurrent cpa() calls on an overlapping region
have a well defined outcome. By removing it entirely you can get random
state.

In practise this isn't likely to matter, but relaxing this for a debug
option is insane. Debug stuff should tighten rules, not relax them.

