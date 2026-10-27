Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4138F606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Jyj7jOfk
Received: by kanga.kvack.org (Postfix)
	id 49B3B6B0704; Tue, 27 Oct 2026 08:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472566B0705; Tue, 27 Oct 2026 08:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389016B0706; Tue, 27 Oct 2026 08:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A26A6B0704
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:47:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F5F9C097C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:47:24 +0000 (UTC)
X-FDA: 85368382008.27.1B8FAC1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id B62EC100004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:47:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Jyj7jOfk;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793105242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAIpqRoqpXgz0RZ4h56d9mqozECvPzO+I5VTSFmMVtE=;
	b=buVrwciL9hJ+Ef0k5wokOVvVxKV7fQvPN6Wtw9kczQwKJ7Vl5tCrM2nvsTVueam0RH/w1C
	BO+z1IkLshgP5BvXn+tsgFQjfEu5yooDRkp74Y6dTlIzcclZqcLSuZi+RN1PO3VxRxPhiA
	4o5LQ/eMu8B4AhowgbSPg7Q+T0avXkU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Jyj7jOfk;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793105242;
	b=20OXHeoYCl0pbmlKBpmzee8zwKyfx+NEwzQY8CgV9Gj9zNfZhWhFrCPldClwFUEeUZ2kaD
	7fR25um8EseL9/2plCOufaZQdpC4xd61ZQtmTfh+o6PilB634OHQU9PZCEMo26hiHz1nmm
	AzlSkBKeDe3Pf5GBsCZA2INVZQZx7C4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZAIpqRoqpXgz0RZ4h56d9mqozECvPzO+I5VTSFmMVtE=; b=Jyj7jOfkJ3zLI2c3I5M3M46Zcb
	WnQwrAXczn6dCAXUP2nPsq8E8i4il+VDWbyZfBRt8ElhZD9EVM6bXkMkelsrdJ6GzzFT4JrQ5k2fE
	HvVnSCOOT/hXlFM44HSRfoB2SmByDM8uZCyGDhQCZ+RrkIY7H6uL+6RPWVddoEEJjx5K1r3Iyl0nd
	vf+topQ1atCH+2NeREP/q708/GzItGv7B/7PC01xV58kaLhrw/a23RC3l/wqMvZJY6z4eOIVSBW1D
	Nyi69d6JupfANQy+NhPNHkUsyGxbDvh2Y367Cb8T+P55YFRuWNaiZfelZ5Y9LdXhYPpImn2EH/+UO
	I8j9sT5A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLgaD-0000000DbOb-1oue;
	Tue, 27 Oct 2026 12:47:17 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id F1B43300A9A; Tue, 27 Oct 2026 13:47:16 +0100 (CET)
Date: Tue, 27 Oct 2026 13:47:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
Message-ID: <20261027124716.GC2668804@noisy.programming.kicks-ass.net>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-14-kas@kernel.org>
 <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
 <at_f43oDv73y-t7O@thinkstation>
 <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
 <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
 <auCZFckDfBMrlfxV@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auCZFckDfBMrlfxV@thinkstation>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B62EC100004
X-Stat-Signature: iegkht8xekquuq8x31ieebzzkgbdxcr6
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793105242-33288
X-HE-Meta: U2FsdGVkX1+bxjnx0fp+7j38UhJVIznOPcdtNWrUNepkcEgkViN+0NH2QRi5lqeK3072inCSiFE2WWvG7lm9rbabSMibqpfIahFsXqPvhJ7q7QHOLjh+QDraO+GSnWhEqA9HMUqeSEGmSn0C5aRaf7DGK/DKTEwQIUdbYXX183RE4fpKJOXhUb6TT/n8+qNgp5uoJ8T6Cc4V3pC5u4Zrz+8+QYU3Yg1FV+Ip8ilX/XQ/JXPFC8+qlwFSQ68WWaToyI7yIpol4ohbHZ5FOolk62GxDoUDACTZeD1Hb/uLaCdWX9X8HkSyqhrprx6vqwQGj6QKj1PZNtVToQzaO1owqq7rS7tbbvrpY61K3T/Z+3XrUf6+AiZYzodoXOjWAh1wt6DSzxf8YZ1ucnAybtB6wTV5ROBvuCPaxIlfEih1PIbU3eZm9Wo00nqWBob7vFriPiWZ4WphzMUKTCjlb/7ghYBiqTPCDJwMvs/f89LxWlMYL+VGKbHi9qroQAvF6Pn9jPgl8CF2DzIpoo6SmopbGfxjJYoscqHQMQkF8d5sAUVW3DN/ZDn4HiYowjfTiYDhIhu+EjlwT+pkMKIz1Pmci9KyYOSjYUvBXTUZg15rsTgVxTefYZWVk7LAK+U8sK73IRA8w3s16fYfEzrQy2UP314pQtaNUY2beZd4SXMi55CF1JbOAHd7Cs3vnZzwF1RdNmw3dmlSNRoGrC3JoFLtyFJnThMdRel77Gat1wUn55Em4tZDfbld4pzwe9SS9J6fYRryGMAStq803S9l+ifpRYJDZdn7Y3MG1Fwt0RZCI0/8e+ncUk/eq+YZSrlZeZjT7YqqBG9zaKz0PGqWLr6tSn+SJNrq2RIf9n5uR8BLbVXAswFYc5l9Pzr7zOwdhf9QiZTQ3h2rn1l0AFQ0cuoO95qs0adD2ZkMzdlsw103A+IaQRnfYWA08Th+P9dn8xOu7TVccklGmPGyzFnV5t9
 odFHvXAt
 w8HLwVoZPfX5WOVvOpIe5fYiVNaznQVx5WwN0LRuIItGGz/oIrJSg7Fde1qEGcgeKIjKFr+XRteoNdip76hcs7eb/++r8k4uX4rxmwWRLoa7JxulNPj0gIrozmflE5oM6/dtoQkNfSdrfIxMS/OAqIFkCO2DxlvGtXb9lxzsLlI881Ac6C/RP6ivlU6i4YC3D7LNfo4a4I81gAaz9uonrmfij4A8KFuM/hKt/5RHvqmn4kFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:31:09PM +0000, Kiryl Shutsemau wrote:
> On Tue, Oct 27, 2026 at 01:05:58PM +0100, David Hildenbrand (Arm) wrote:
> > > Writing this, I just realized that we have another option -- map the
> > > shared tail page writable. A failing LOCK CMPXCHG writes back the value
> > > it read, and the get never changes a zero refcount, so the race becomes
> > > harmless. The cost is the protection: the page is shared by every
> > > hugetlb folio of that order in the zone, so a stray write to any tail
> > > silently corrupts all of them instead of oopsing.
> > 
> > Right. Without HVO we would just corrupt pages in the single folio (which is
> > also not nice).
> > 
> > I'm also questioning whether we need this RO protection all the time active.
> 
> What do you have in mind? RO only under a debug option, or switching the
> tail page to RO some time after the remap?
> 
> If it is the delay, a grace period alone does not close the race. We
> would need rcu_read_lock() back around the get, and then it is the old
> scheme with the wait taken off the allocation path.

So it used to be; back when Nick introduced try_get_page, that it was
only allowed with IRQs disabled.

And looking at gup.c now, I see gup_fast_pgd_range() still has
local_irq_save/restore around it.

So what do you need that rcu crud for?

