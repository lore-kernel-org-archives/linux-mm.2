Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8189FCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 13:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722786B008A; Mon,  8 Jun 2026 09:09:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2E36B008C; Mon,  8 Jun 2026 09:09:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8B06B0092; Mon,  8 Jun 2026 09:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1156B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:09:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9E35C35FF
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:09:17 +0000 (UTC)
X-FDA: 84856776354.11.AC859BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 632DDC0008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:09:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bU7YEBCQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780924156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1iEpMFcGnAl+xKpt0NCSfDOMAqvdEhxAtn0P3aNA7k=;
	b=cXMo6320EBRTNiXT3oet8e5EtLS2a52T8o+s+uPAPYm/K0oKdjtqBVFW7AR/+6q/+lMthe
	tI5e6pDg+yq+kL2mFUAXskCbK5iTR+CwFzbZcIQZ0kK4J8lUfSBeVjj4JuI0tVwk4tmHkb
	CvMePYxWGhtl5uKoDR3RYvXQzQ4E7SU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bU7YEBCQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780924156;
	b=MN/IUhAydvm5dXM6YoCcaoFW71gN6oGEuE99D3Mca/p7f6I4l5tNL3pLJ0r5gyskMRYz0H
	9bA1mmvsOAY3oUvvxf5XtATJ4fI450cnLHVQr4rfYYMVaMSL1DX98Jonv+uGvqmmo8rFg7
	UX/ysmSAbpqUYn4HaCiYqooA4zHDlJ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E950E601D8;
	Mon,  8 Jun 2026 13:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651D51F00898;
	Mon,  8 Jun 2026 13:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780924155;
	bh=X1iEpMFcGnAl+xKpt0NCSfDOMAqvdEhxAtn0P3aNA7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bU7YEBCQHlplquRshq6kKbwUGvzFVb7VR8mZ2dvgpkxbTNXhS0vZUvTtL24/ml3Zo
	 RoE2DymVzNMfcbkMQ+QqEHHLRgmMmohbeqjwk+U5kaA3etmTxN+6+juwemX1tbEKLm
	 DnJWCarLmiR2FMn0kjQoo4j5twD4IKPU0TeSG4kbT8GXjIcYpE+4fWzn2sJCXWCcTt
	 Nwz6FK/tlPdOO3f1SbdG9GrPlWxypSqGMMkj30lq+rriV8B6YuNVl84HrXCZbwlM9A
	 fRdLvPKw2z2T2K6jd4Bap7uquleu7spiRJjKN/ja1+d7AdzscS9YIgyBpKCQxChJEg
	 3j7sFvtkN0cWg==
Date: Mon, 8 Jun 2026 14:09:02 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <aia-q026facbptoT@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
 <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aia93IzhTgi1vGi6@casper.infradead.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: bsyj4ctpgsm54stocdmnfeggi61a3ehg
X-Rspamd-Queue-Id: 632DDC0008
X-HE-Tag: 1780924156-136257
X-HE-Meta: U2FsdGVkX1/RBZD77DzAPmh8UASdROhtKl2LoceAxEZARejG3YxlKivXFLx2a2Cvz6bYUAtJ9ZavbalQneYaMUpj4YZLpUsplPDgb5930C8EAQ+bWvLn5xGtXJAzA9iEEYO/sVKG6vveReZeqpaqNtIltICA4fryzCFNy3SCDstSSKz2b5859526l0/lMR+x6zHqdpZ44UDH1ASUA3XlfPbfUftgENyJqWoybz7zmRvkUCIyy7o/8alXhniE7RQ8UmfCrNnXCRmAk9RRXCaqSsptdevXD1oO/eDTqm6ybPgWXyhCdsa43UtTgYage4j6RC4MyOSPX7C+aSmxsUwNu39X33RxbV6AukW2lTwH/9D6ANVnA3dckkmxqXthsLCU1ZfyBN2t2JifvXjbL4b7LbxKCDGR/Ib//dxZDO9LRjqpW2XP6XWVX5nTerHuTvH2U2kLkW/3ZYbLVBCAlIQqnsc3FQzfgKho6LbyJPi3o4exCdEt6+eDcfdDunTQr+wcEr9z2XukXJmgAd21xYGq3EVuLUlZgqHLTlpCwa/n3L1XU5anxk6x5yEr+poofU8YndBP3izNXWGu1Q8uW/9WYeuW6+cpJi2j692bWkW2mKQOh1h5RzLW2iQzLcMZrRQUzmlpIcNYzFeU0w9SFc6kPMbtYehpQ5PisZElggs6x807NFmV9dNsUjY8OEEIC+yDe2QUnqi7GLSdJ8jXH5m35YD8yFzZWpz75hujH4O0SYZ7Tyb/f9mQSofr21L8Bs0moM2P1pKRbSuZhOX3D0g3SYFp+DJ2FQoKFPwbOJ0t2e4Jk1nuGqlGd0glkHlSV5kligijF93k45UrwwfXKTEMZDAZmNOHPIN6BvVEJYbSOVJ6BLTONJWWcABFQsbb+p1rH2XwpL38VpAcKmfg0de8Vw9qAMyT83D032du2xsUZDKVvxwYdFSiGoOwf6wF7r/pyYUmuooJbVguUpZVJMz
 Lqpty96m
 YekluKjMj9l5z02TTfFzlf8bhWhXaMHWCGi8twg/iDOIEOj2k1Yp0/skDWqn3estl3L7QX+xhO27rbxq4YLh7r8aCHbWhO2IxUVgSqg5ZkX1f/msnZee8T8d0Lzd+343rKA+bAI24rFxKggM5TY30SHiUO+O3mnAYZDQSlTjSmjoVPQUy7rl2yP+SEeIuvUcUoSnESQ5lWQSJuZyMQIP5dPOwW5eSFY+u0nChoqcIdx2LmzudZtRdA5Bm7NPXJsfaDEc/q2+5VFi0GVvhWmR5OSLt8RjRlGpZozlGozRSdiyBeKSZamtPV399avgegN18mAadZMc5sKf8HxqEaBuMvVNEirHaVXT/TM2cdw3ozBbFlDMMk3C4K6eb0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 02:04:28PM +0100, Matthew Wilcox wrote:
> On Mon, Jun 08, 2026 at 12:06:35PM +0100, Lorenzo Stoakes wrote:
> > But instead of overloading user_addr to indicate all kinds of things, instead
> > make life easier by actually breaking things out.
> >
> > Like:
> >
> > enum alloc_context_type {
> > 	KERNEL_ALLOCATION,
> > 	USER_MAPPED_ALLOCATION,
> > 	USER_UNMAPPED_ALLOCATION, // Maybe? Do we ever?
> > 	/* Perhaps some other states we want to encode? */
> > };
> >
> > struct alloc_context {
> > 	...
> >
> > 	enum alloc_context_type type;
> > 	unsigned long user_addr; // Only set if type == USER_ALLOCATION
> >
> > 	// Maybe something suggesting context or whether we init before in some
> > 	// cases?
> > };
>
> Ugh, please, no.  As I suggested last time I commented on this
> trainwreck of a series, lift the zeroing functionality from
> alloc_frozen_pages() into its callers.

I've not looked at the callers closely enough to see the delta on that, but if
it avoids this mess then also worth looking at yes...

Cheers, Lorenzo

