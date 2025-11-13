Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0240ACD98DA
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 20:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53D548E0008; Thu, 13 Nov 2025 15:33:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515AF8E0003; Thu, 13 Nov 2025 15:33:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452628E0008; Thu, 13 Nov 2025 15:33:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 33F2B8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:33:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4B3313862C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:33:58 +0000 (UTC)
X-FDA: 84106735356.01.2EDE49F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 66DE7180009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:33:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Cmim2kzQ;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763066037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F8BIpsc6+IG97yFUh0oeZRhXpi55aHBEN/P7F13sLV4=;
	b=aObaMzcRL4kTQ/a+6JdJWKtbslqSWQNPXpQ6kCZMaY/1jkYchF0KCWtclToPOMrFo5y9Dl
	tt0qS/fYL7kPY2gR6cvKPmSu6A1fuNx7ZfSAV3wvVlNjD0P0EpMQV1I1vxGCjUKkNcHak4
	AiYqQp5hi4vGA/Sfd0AtVE1ZXkOY094=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763066037; a=rsa-sha256;
	cv=none;
	b=8NsiAGYOFRA/cNegiVOV9aM1QoYWkYq4Y0Slaf+9ms6DxHuHImc/riB4aPYYECfFw4bWh0
	ba2A6Gb8eN++GxmfkjO8nhfh6ChuOMVC+6/55JEv+Reto4uVPY7YkXyAWuI04vrJigHrE8
	YiWjesSf+QTN7sy7qhs44ePGMGB+oKs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Cmim2kzQ;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F8BIpsc6+IG97yFUh0oeZRhXpi55aHBEN/P7F13sLV4=; b=Cmim2kzQ/sW4COWLNLD/lKBLQv
	2MktANiZv8HebBFP0xpU2qKed8TiPtexeMWOZ2MU/K/eJZrML5yDAn2gWrpTaVRK3KQ2caJFgtPB2
	Ezeu3WF06JgYLUNQzucFZluyRU4eXRCwWKB4/rhlUBljeM15gfjkR6tHm3eES6UMShexgB6hSLDta
	/UPKXtKmgTqB+vRjnhrxsgqUaWd5qmUIx01RbfDijpRQoYH7mTf5VFE6PGqvZ1r9qtp3inSXM3tSU
	KwLHCFGzL0jFUYwRTUTf8HPsrTJYq8+GIYNJI0uG/AaPm/OiZ4Bqh5tijH0wMZHkLBsMq7llZAub7
	+JfxJtvg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJe0s-000000086x7-3brw;
	Thu, 13 Nov 2025 20:33:50 +0000
Date: Thu, 13 Nov 2025 20:33:50 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org
Subject: Re: [PATCH v4 14/16] memcg: Convert mem_cgroup_from_obj_folio() to
 mem_cgroup_from_obj_slab()
Message-ID: <aRZArvnUeXZulhuX@casper.infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-15-willy@infradead.org>
 <20251113161424.GB3465062@cmpxchg.org>
 <45ea66a3-bf8b-4c12-89cd-d15ba26763fa@suse.cz>
 <offnmou66hzgrlbb7owyya6n4onn2g5iuv7matbqfvsigg6wv3@3hlu55yai42z>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <offnmou66hzgrlbb7owyya6n4onn2g5iuv7matbqfvsigg6wv3@3hlu55yai42z>
X-Stat-Signature: meqr8qog8hs8aqczinf9tzue1qdzdn17
X-Rspam-User: 
X-Rspamd-Queue-Id: 66DE7180009
X-Rspamd-Server: rspam01
X-HE-Tag: 1763066036-626678
X-HE-Meta: U2FsdGVkX18PEQBl2ce7F8++xL4o5KG0Ke6WJckCII6w0MM5e45YIPa2/JkwNtmWP6LEI/+lnMOTg/23TfVCN6QUZdFVkZvXbHApSU7QBkIVxDOe2Cw5YlxTJUQ6i9MbDYsqqBAKTpf8rHpzYfUrfsvzjwAh3jYxKVROKNN7QIggJloDe+u1JyVzrniF5uCGcxYf5lRHAS7GhOt+ModYTdcl+r6tuM2n57sLVUSbI8nPKD5YvsMJdVpowrOgT5xfE7t17+fWyQPko4iAgo7qb5v57AB2L+Qyc1gTh+7J1AAzAbO574pL7PRIchtnSuzUDHp2ApWpPUh3xFwstaNlNv7BkkNp5hYyIoRcRd1okABsuCLMGpC1WMiQl+7vujw3gq7SeyOi9U3oNmJdA4Ri6e/3qNedVBSCKMxUduSlc2Pij/O0y5zocBzJl5r+Sxz5chZnSYfHskj9KDcYerE1OlAOgT59xQySc9JbvwGPILF5yq3vkC/g40szT3H666vZy3u1FDuv27LLGrrVUZ9TskUbaU8Hvk1VL+YBoxq6hahizgPWjW+YZYRDzVO+XPRvlbcmchYASLJwyjQsG4LYA5u044/cRbGXCaIjQiynR3LvbHs6qicp1ndbAWcEWLATOwgH3IiwwBE1pef8OmmfH54K63QgQeDVYVQ/YOg+MyvJ8EYQ6WeoMWXyQTjGYE9AkveFINeetA6JZ7EOIo2xkVLrWbF7fjvESEAF/+GRGj3KA8VR2HpZga5kwLcuBa0XlV85SjgVzBCtzCpi0ZxpwZYCFupng/UU6/xyYP265COoVUe544WwtS7qmn5Xw+JFCFpwPmEgXXjnZWXh3zHpb7Eylz96Havts1+T1o+Ie2jVUJ9Ho4zCPhQuNt0deZ4Kd7GPvhPr7GazvS8cuAUOKyxhfH9x3m70HmJ4FP9tYkFlZfBwAiBXaO8dHh03pBxWtQfDKCJdcBfdON04nAT
 DGI8FWPa
 CyQKw9eDCUehO8OWw39mHFrRUFqVEPa+BfF0zfXDSIsbiQ2XJQMpoO/ktreYfpdY5ecMC79tx7j+SdBkoxPm18JFlTIqjs84yJQvojPecsApeqLPPLXu89H/zmFeqY0vtWNt50oHt5eCVf156Hn6SMKyCYV+d87fVdakCw+5O2UEtYlHZEH14D3sI0YspyFquMwUJTYFkE+mmnpDLm/S4WH4E5ldGV+OCBWulVveKr8rCvp5ccRA9jDcL//T3IDiokbMTAtng47PLLg+wwvN6/bChOxCA90lnK4ohbB+GR/xVqIA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 11:42:01AM -0800, Shakeel Butt wrote:
> On Thu, Nov 13, 2025 at 05:28:59PM +0100, Vlastimil Babka wrote:
> > > E.g. !vmap kernel stack pages -> mod_lruvec_kmem_state -> mem_cgroup_from_obj_slab
> > > 
> > > How about:
> > > 
> > > 	if ((slab = virt_to_slap(p)))
> > > 		return mem_cgroup_from_obj_slab(slab, p);
> > > 	return folio_memcg_check(virt_to_folio(p), p);
> > 
> > page_memcg_check() maybe instead? we shouldn't get a tail page here, no?
> 
> Do you mean page_memcg_check(virt_to_page(p), p)? But virt_to_page(p)
> can return tail page, right?

Only if it's legitimate to call mod_lruvec_kmem_state() with "a pointer
to somewhere inside the object" rather than "a pointer to the object".

For example, it's legitimate to call copy_to_user() with a pointer
somewhere inside the object, so the usercopy code has to handle that
case.  But it's only legitimate to call kfree() with a pointer that's
at the start of an object, so kfree() can cheerfully BUG_ON()
PageTail(virt_to_page(p)).

