Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF88A606A329
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 15:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jVZ9h8Gk
Received: by kanga.kvack.org (Postfix)
	id BB4766B05B2; Thu, 26 Nov 2026 10:25:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C666B05B3; Thu, 26 Nov 2026 10:25:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8EF6B05B4; Thu, 26 Nov 2026 10:25:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6136B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:25:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0A5980524
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:25:04 +0000 (UTC)
X-FDA: 85477643328.18.8E5E618
Received: from mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
	by imf12.hostedemail.com (Postfix) with ESMTP id DDD634000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:25:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jVZ9h8Gk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795706702;
	b=ugfSmODNZQke5oie8jqqcAvVmrh3aVC64MsvaDAWNzvGkWRNyOHmNLfBVN75t4lNM/ZsA3
	9tJP9ziggbCmYCXHY5ONOFKHAJ0m+3zVs0n3K7+qDgyVLHJmfft9ANAK+0rRyViw4NFKL+
	p06V5OjRxYuK9u61cxDkrgdDzJCs0BE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795706702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WaGhGP18N1e5WQjSL7Kf13XBuOe/Lyl+VKElqyiI+RE=;
	b=su1GrMXtDjM9l/O3oNbcHTZ9TBfGrLiGRrkG24XIg+OeTOqoNnnTinvmscfv7yNQOTtWf9
	cl6h1hbKKVf2ob9PqmirrYlwwySTQu6nvOLkvGQ6yMMUTscfqo0f1DwEb0CV2uM1Dg2gwq
	qc2xZjo1oWwkXhDV6lfjYX586zi91Xs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jVZ9h8Gk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=e8n4p5I4AJEqksbOANyj0Uvx8iI2baqGaT4jyvFlF3s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795706698; v=1; x=1796311498;
 b=jVZ9h8GkT/80oZsox7YdODWAE02GuplGKSbcgwsB8WJxPqBNfi/VkjeXgScosK136kuJCEEV
 fEKpAj82reCXYFpOFszgIwzveujI6pz2MajchchMeBoDbd0lSxVz8Ki/liZ5ujV+TuR4us4g6cG
 D6QHk0fgIIze+WCiB2cnf79U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e28c61dcd929e842;
	Thu, 26 Nov 2026 15:24:58 +0000
X-Mizu-Trace-ID: e28c61dcd929e842
X-Migadu-Flow: FLOW_OUT
Date: Thu, 26 Nov 2026 07:24:42 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Harry Yoo (Meta)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, Hao Ge <hao.ge@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Robin Murphy <robin.murphy@arm.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Amir Goldstein <amir73il@gmail.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Eric Dumazet <edumazet@kernel.org>, maple-tree@lists.infradead.org, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>, 
	Willem de Bruijn <willemb@google.com>, Mina Almasry <almasrymina@google.com>, 
	=?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, linux-arm-kernel@lists.infradead.org, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	Niklas Schnelle <schnelle@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Chen-Yu Tsai <wens@kernel.org>, 
	Jernej Skrabec <jernej.skrabec@gmail.com>, Samuel Holland <samuel@sholland.org>, iommu@lists.linux.dev, 
	linux-s390@vger.kernel.org, linux-sunxi@lists.linux.dev, linux-um@lists.infradead.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH slab/for-next v2 00/14] mm/slab: mandate SLAB_MAY_ACCOUNT
 for __GFP_ACCOUNT allocations to avoid wasting memory for slab metadata
Message-ID: <20261126152250.GB738059@shakeel.butt@linux.dev>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
X-Rspamd-Queue-Id: DDD634000A
X-Stat-Signature: upes6ar9udsjqmckjmokknewofktcixp
X-Rspam-User:
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MSGID_MULTIPLE_AT,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795706701-562103
X-HE-Meta: U2FsdGVkX19adyXoxSOwGCFi8g/LgyZvpsLqYbM+H0sWXLHKPKM0XBQxRfAowV2ed9n573MDjhLyQhk55SYc9fRMue1WeL9ypiIMf2DNlvhS5Qxk4QgGzWfgIth/wG2IjEAFsHnevJJMISfalTn2VGL7vN6ufUll3epHCY3B3OJYreV/O/5n5PBFSBOoaMeUGzIbhV+dSbI34p2pnfaDAj5RdfeqmD+782I1LVFNYpz9sREzMGNrnVz0GL26mwS349Vbe8zw0LtSiDVMLABbj6GrNlKGpuvlrQBF9BnKfBcDRDoD9jnzHFLPnXKQh1M0bxHEVABIpzuZSWOuZ/rrZnwOzJ6x2dsfjwVr4WDjaOkShxfSV+GgDz+Xmo7bdJ+1WipK3Ah6kBaKLBsvCr8q7cOo8H8QKFK6eUYSrwv3nkUizl0esaSstdXZ3YL66psmnlazZO59oWm7GQug59pficrf+QsUPZOA3XtMwtmWiKCr+cMhPESTm4UaYcl/m5Bcjl2TGX5zlkARDZHuD3VgemPCmLeCWILch9hAopzRtZsMspF6ceXXpJPk8piaLNgkJEXru3af1D7MVtRIQpZY6F+BsJmldQQNkQG4OBKo7xQN2g+eCo94X3Xnpk65Nfc5ZUgC9WPApHWJJLRsMzygkbsncQzEu2+XbpRevmqbckaJSP8eTXJ4HezJrGpEM/FT6Ww8eVHDCycqcCc7asdfrIMz7gofeC1O/8stZy0nAyA5SwpUT8/SEGDSb11PFGBiRt9DgGi5ln5Fz4LbKHI8c6djhFyIhgiDPapFSxEnqhNO0pdtp88TB6P3PYlSwIthlc04p1gANM02fydq+tvY6zvN0Vhi/pUj3bjR2i/gPK9oreoyIq+0MYFO9pC/Se6Dj9I4lVoHo2CnEGJbyyydvxl533UlQL4R+OQYxN3VCnmbY+rfLfkpSQFYGKD3P9glK/TYdyWEzxZ5a/f30WC
 jbDGXvbh
 85jVcVo6qmVVnnutAIyOKeZZc/DAjAVsLv9leEndVipCfO0/MJwiS1O/2mQTKUPq//Enjpb9C/DYo9mYDSbI68VJr31XSIKltUmc6/uAsX4kMp84s1AWiG9myclq31J5NOGrNc+d6IOTF2UYGMOWXoVnTokOdgmr/l0AnJyyfJanHsIcfm/dT7QQ4X1clZLFKFjEHmPaxI6Xt2lGycRIZAUUnRdgYNi6hn5O+LnKsWcoasvqyUDkG8POANZygQOdDhnsWNy2BCvTgvLDJr7UJSj9Jdy7INCK1FuyA7O2u6Ba3CehzoBnr7j0etihP3F92Ez47/Y+UBnsdrgs5P6o3PdW4vZzrHTTZTdPb8bkoXZrc65BftIsTvyC+7eQve91dYfzabb0Ih6lpRhboG/RlI4yUQ0v3khVO2oI54sDqLKr6WUYHl8mJn1b2xSKqdra3xMHxgVt2Y1QfI2M8oY9I+/9ujV17fWesfCb3DjXXGfmSJm7jfduA9+R6Xuk72x2l88crkIn2W7CNd5xXWMWnB5ySPWe6dZGmJ138Z29cGanIMwZctrrkVGtS2ZQCzhnot5IcgnBVrepfcx3LGCrqYr8oa/6ntZ59QWPbOzPZu+T/9hyuI3XRaMYAkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 09:37:01PM +0000, Harry Yoo (Meta) wrote:
> TL;DR
> -----
> 
> The purpose of this series is to convert existing slab users that
> specify __GFP_ACCOUNT on allocations to specify SLAB_MAY_ACCOUNT on
> cache creation, to reduce memory waste for slab metadata with
> CONFIG_MEMCG=y && CONFIG_MEM_ALLOC_PROFILING=y.
> 
[...]
> 
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

For the series:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


