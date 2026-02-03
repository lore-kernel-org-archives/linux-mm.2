Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403DFE8306E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 09:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6892F6B0089; Tue,  3 Feb 2026 04:51:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65AEC6B008A; Tue,  3 Feb 2026 04:51:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5871A6B0092; Tue,  3 Feb 2026 04:51:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 483AA6B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 04:51:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E119C8B9A5
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:51:21 +0000 (UTC)
X-FDA: 84402677562.28.D5CAE68
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id BA4D34000C
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:51:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ESMSiqS5;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770112280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LMV/UqSLQLqZskyhJdWEgGaTiL2QvED1GhTKVUM7dY=;
	b=v4tPBwMA+JamOrFAqo+3bH3jMFoBZXBxqHjbY3AZxUaG9iwaR/rx0m7QEF0A/qgXLAdTuK
	dsYH2Xecfy/rpx5CybTOETppI1JZ61k3/YrjQvTEVSvofHCt0Qc5VYTN9lBKPT8qjnSMJ3
	idnOvUz/Bi6GJlN4yXJZsbCluYryhWU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ESMSiqS5;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770112280; a=rsa-sha256;
	cv=none;
	b=Gb38/k2j74nGcvNHF4hFi32+AGY28KxBLVJsjUKFF4sPVUNEf4vgB8lF53kVtA6kAvMXLj
	Y92kXG0JzDrrEcyLNJwcdkFom8K4zhaJEHYXjHdURZmwxl1ww5Ov5+2DcBOfM6l/89fzD5
	EI6AgMb9Eqh/g58KpyTNq97+HCdHCqw=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770112277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9LMV/UqSLQLqZskyhJdWEgGaTiL2QvED1GhTKVUM7dY=;
	b=ESMSiqS5ORHZuZjWRltobDFH6KzSxY4kRV2ycmTIHL0HadXikXjnfkOnrlbsP1Fbvat2zN
	JZTwdZTssymJkx5X6YALhYhxOhEzwJWov3PuvlVQpLQ6w9EYcqwmDE8Gi3nwvqdiTDy9DL
	vJ9KphjIGx1nE1AgsHx+O2A8hJQWtX0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv6 11/17] mm/hugetlb: Remove fake head pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260202155634.650837-12-kas@kernel.org>
Date: Tue, 3 Feb 2026 17:50:34 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <1FFEED62-343D-433C-BB81-EB646D066AC9@linux.dev>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-12-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BA4D34000C
X-Stat-Signature: fmeppn9dwrccc7ppasjt88xegamz8wo6
X-Rspam-User: 
X-HE-Tag: 1770112279-64729
X-HE-Meta: U2FsdGVkX19iNf24xpoXZWTjkfpNLrfiG5CBAGkOFhUeM6H3p9CuCWLOZu2n3QDbP1NHD8+vq5g1fiIuysWGUc1w7u9UplchOOi986hhGi52SQw7TR46Kgp7IsIYv1A9qvkcVyMwlcncyAHeWTd1qw3oveoMir74FfZWzHgygSpeQFF694TqIJ8dxvrfX2zVQv05FWXBW4NRC6fhtW7ajBxIrSIROviGllxRIzZ3ClHNA/eIVVIGmnhJ080++Fgxq5eP1JrXmugUQdmGip2jP9JINcbg/b0Ck7ArcYcIUnidKivWXITeHSmeSGDXLUOHAj0FmLsZUvZbMXXxJoV9pDqWgPBI2Go/EGULsSsl/XFJEVIoKRdUzFEPb4nN2HGIoZZHv/tVbfrJWS+A7zMxL4APgGoG9ocfnRjzhSsAWbk6ICM7/oVKmolpR5z9Ma7KlX+lOoIK4vwy8eZLp/sUWfCqpzfQDPk61UXdpGz+9qxrAwuL6gZzeF/0QKzJwDDhEWlJ6LqUz32MQOVOZLoPTGE5ve5+jns1A66jeXCAYRzi3NfGKKogs4Lxex6neqfLSLS3Lu40Z4+v4sd4KLQVhXRTOb4uAf2WOqwFYpAADtPnyfPMryPI+7k9h/4Z5hmCY3W9xEsY+PrWQkTFvu/7amhyuFZsNOt2SAI8O0oIMU4JXf8CXZh8Pt6CQGUynA/1da8pQHJGCGk6YkiZnpPPaNRyMVcaISNgoG7jEHN4jircAJqx2M0RcqloO3yuWS1YR1igakF7VyAj3RMDN5cTlQ9z55sPKsunWdrA8EblxWxLxqI+cgeuQMPzyOK9lapVg3Z6viBaFeBPRar2hJgPmoak45NXVJQLXblvNkzGkpaXC5Gj4rpkUfE7273r2RJafjPIEiU1rnBFu40K9C9x6dXs45oo4DKvNXvhMP39LfwbX36oOEAMUyiysaLPANBhxv57PwMtcZTQah5L4NQ
 nMQikDLe
 uT5wKOAe8IUf96/6JJi67IZxzSp9EUsqOjWl+Rk2XgJ3vVKNYwc69WFCfut2PtZ10lrg3R8OPTAvHLItSAfqRfLOKrnfBk0HM4WFHvRr3ZtJnomyAfVj63GJTiQwnY2vIjC/eWxHSbYb8/mZk+ZYqx9Fekq7bdiJry3uFwtZm5ghCWENDYo9TArcm+NxoCfkkgKBwLTHZvzEnfa1VWSWSH8LGj+BJhL8fysfKgK3h+zMiljIOlpldHBFOH6QLn71yP3ys
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 2, 2026, at 23:56, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
> vmemmap pages for huge pages and remapping the freed range to a single
> page containing the struct page metadata.
> 
> With the new mask-based compound_info encoding (for power-of-2 struct
> page sizes), all tail pages of the same order are now identical
> regardless of which compound page they belong to. This means the tail
> pages can be truly shared without fake heads.
> 
> Allocate a single page of initialized tail struct pages per NUMA node
> per order in the vmemmap_tails[] array in pglist_data. All huge pages of
> that order on the node share this tail page, mapped read-only into their
> vmemmap. The head page remains unique per huge page.
> 
> Redefine MAX_FOLIO_ORDER using ilog2(). The define has to produce a
> compile-constant as it is used to specify vmemmap_tail array size.
> For some reason, compiler is not able to solve get_order() at
> compile-time, but ilog2() works.
> 
> Avoid PUD_ORDER to define MAX_FOLIO_ORDER as it adds dependency to
> <linux/pgtable.h> which generates hard-to-break include loop.
> 
> This eliminates fake heads while maintaining the same memory savings,
> and simplifies compound_head() by removing fake head detection.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



