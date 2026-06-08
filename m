Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58859CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851A76B0005; Mon,  8 Jun 2026 10:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DAF56B0088; Mon,  8 Jun 2026 10:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3EE6B008A; Mon,  8 Jun 2026 10:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 570516B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:44:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EB171C05A7
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:44:59 +0000 (UTC)
X-FDA: 84857017518.16.BAC3A3A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 776AC1A0006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:44:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qEZ2rfLs;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780929897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxrPivMbcmKajNADeOIQJSutYQmqflAH9yFR+Tkhzog=;
	b=izHmXI4AyECWMNPU+xRUnQtmME1PKHlgeN+e2mt8QveDSu4+rEOoKSknnGKJAc26Zi6Av0
	wW0iVpmhz52+zaUnE6faJbVmPsFEzWlvrpH7ssE8DPR7llVAkm1FlQCfOD8EAAFgpZMKoI
	zuUH+CNwDoDCrabfXobTeHIMkODjsWI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qEZ2rfLs;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780929897;
	b=GicH6PUkS7CCj/Y6cVsCVrdEp6hhOCY2eiHMsGK472S+Or/V/mefaPzJLnhff2Xj7ZB9jA
	vnbEHKrUUwyl5XDUt3zS9IipPfP9yIwT1w7HWKdhDGSQ6qfXd1AHmTUfxfARQrO3/mrM4k
	YCPXPlg0Y3HUztyl93jtwiE2+WSOqVk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FxrPivMbcmKajNADeOIQJSutYQmqflAH9yFR+Tkhzog=; b=qEZ2rfLsXeQPXstEumnD0TPoke
	G3uVOFYfYZm9ffHHSXqTJJFo3GaYIIFTgRdhkRuOwIeiYC1T6U/AqkBUHC2jIGEDZ4cJD/LgSbRhx
	GyTXxhueVwjCkYX4pqcgJKlIHfL/fJsoGNG0rQ9u/jwReAjU4zSbIlnj6HrMfHOHQCmorcJxp8U/i
	SEq0fsV+6QhKJq6Xh6i1p9lLQMqQ2JpHJSbl+F37JsvEIxNAqpH5o9X5SiQGfs8fgCHU0i7fRQY5M
	dQpF6noruDu/qYzNBCXL7UUhB3ZFhFvkScQZzTjp7OK+NXHG8cEVCHNdUawfFX3wxDgMR6BeRmpac
	Y0WOUMZg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWbDJ-0000000Dstq-2Gul;
	Mon, 08 Jun 2026 14:44:29 +0000
Date: Mon, 8 Jun 2026 15:44:29 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
	linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <aibVTe5HTk-fF_kj@casper.infradead.org>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
 <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
 <aia-q026facbptoT@lucifer>
 <d0ff6269-8b8a-4983-8569-d9a8495829f3@kernel.org>
 <aibSPsc33YQiYSMI@casper.infradead.org>
 <ef14cfdf-5f1f-4e3b-846d-fe1462042883@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef14cfdf-5f1f-4e3b-846d-fe1462042883@kernel.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 6oew8syoeq3yhjkq5anun1frwq8zhcub
X-Rspamd-Queue-Id: 776AC1A0006
X-HE-Tag: 1780929897-544729
X-HE-Meta: U2FsdGVkX18Zr5yRIaGOvHjiYnr+WV1maR4DMeQPDAjgdiOmyQDM5eeQgHlWCDsfIhPnmFsnx6uZRA2yt8Vh7LzbFbhEgmuKKc5zgbjXv4YyBbJ0mhUigBLkMBSK1tqkyjLBAOOEk7e60S65VLeeY5ap7jqV24qPMyBKP1UMTvonbHWd/z+PJL3WgmzQySargu8rG23U24on7sw3RZxwof/m0lWxQhKSjXGWClFnOUh25+ewVjip3RL661N0MqrYqmWqSK8Bz3Z90TzII2cJbNlgG2oUN4Emx1JhzEPNRpxOiLR5hS/ezyQu8Ct7iDzWCJ9nbkGa0uAXeElsfEPXWcuaK5uC2X7vr6niONF9NPHQRzkM735kdU9pRSxD38gYXTqKC2U50affX9/ab2E9gQfk155S9+eoxlZ87Mnddv+CK7gI5ER4b1BUH6yPRvwIIUcHV+EKnH+U4z8VXv8+YYs/lBHrscNrCOBnLo04jMUpJFGJpZMpcYr0L7J/eLElqwcn+yZEfS1aV91sgN6+zw0jWrKyXn2W6ayhQavIqizJ1JlS6P63z1IS3EqVagNQV2RfyR17lPKirdbstFaraoczmuUUX8nTZyetKx0rd2vsZkFAkMcd34lIBDVFaGpjEU0atBf0FM2ntIUDf+uUy2IjlKJQjVMzY6sooX4o/UovsidLz/UWGxLIuf9XCup3Rk7rGZ1Aul+6mvhFFJjKM/eaXJCQwN2lLRyJPxLAgRpieyRbtoS/dp4hktOhD1EHJ0rBcSgGl0/3fzlof81kG5TfDAQvO4z1Xk+kInYj03FGGJe5f/z+6cChEpjaTlun+9sIEdKl1PNZaeJ8Y3gyU66ugP7kDfEzeJNNpHS/86NxQC8SwT1iByvBv6YluZP8sM1yMHJyOdQzsORG0ZB4q+DlWZL7QAkWQKErNvFTlEtPi85axirIo+sELENmdqg9uKGT9SLDn0hoKg2ykak
 /uxsMEiU
 pQ1HJ7TA+9CKD6CVl2Q2+OPQyNom22F8FChI71ndKn1oCldlY10lzqRH7+oG70HBIoinioZsO7YvZwso3NVp8GpUIyZkVFax9BFmL3M1k9Q+DZp5IgvRCFow+htjcoJ5H4sqAr4ynZo6UyBHcAhFFnUjjZpvsTK4ZTE2IIjudKfPg4Vgfvvxo6n/aYAgAkeMXT/XPbOVmqnsJmIDbx5FJtOSm962ftFWrYjKsfL0C91JRs4Su3Mnz4xAKy+k2rZX/bvg8Ya7fRJ7NtqH8F0O0yYny7x2SakUHGe9h9wwMbRfLcmLLI7D4rCBsWrnBhdQ10GYnau+WcD3UUIZDzdjN55rrcBFnoQITJJOTidkmK619SHI1uD57zlapUnpVsAS+eBPeZb6CXqlNSbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:37:03PM +0200, David Hildenbrand (Arm) wrote:
> On 6/8/26 16:31, Matthew Wilcox wrote:
> > On Mon, Jun 08, 2026 at 04:26:18PM +0200, David Hildenbrand (Arm) wrote:
> >> If that means that we would handle __GFP_ZERO consistently in the callers of
> >> alloc_frozen_pages(), that would also do I guess. We'd still have to pass the
> >> user address down to some degree, through folio interfaces only at least.
> > 
> > What I don't understand is how the kernel page allocator needs to know
> > the user address in order to effectively zero it, but the hypervisor is
> > able to zero the page without knowing the user address.  It feels like
> > somebody has x86-centric thinking where cache colouring doesn't matter.
> 
> (not commenting on the icache dache mess we have to drag along)

Well, that was kind of the point of this email ... I did ask the
question you're answering in a different email so let me respond
to that too.

> The thing is that with free-page-reporting the memory is already zeroed by the
> hypervisor as part of discarding that memory previously (e.g., MADV_DONTNEED)
> and allocating fresh pages on re-access.
> 
> So it's not a question of "why is the hypervisor zeroing less efficiently", as
> zeroing is just a side-product of reclaiming that memory in the first place.

We definitely have users who don't want the guest to trust the
hypervisor.  So how do they disable this optimisation?

