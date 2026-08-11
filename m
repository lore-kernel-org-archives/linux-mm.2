Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75BA2C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 783826B007B; Tue, 11 Aug 2026 16:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75B5D6B0092; Tue, 11 Aug 2026 16:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64A546B0093; Tue, 11 Aug 2026 16:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EFAA6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:31:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28C411C05EC
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:31:18 +0000 (UTC)
X-FDA: 85090133436.16.3503CC5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 23B54100005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:31:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oSMWAXud;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786480276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMnGCLWhe15ZxMrHk/gFLLP8e7MuOyBy5Hyx6UW6LII=;
	b=1n1h6XOkOCalbCAAnPmCA8ZZQXOkK62x3rrTOt/cFS4JTVsxwK9J3/tDZKe8M4RHFda6eu
	Rpm9jSvvo3+QOOt03hVLVBgmEVlluxpBqjt8LVieaYgSkJe9gycrOkEWNxgnsHcsr2V0FP
	1WdZX39wvxI6c9/LQeC7PTLjQByiCkg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oSMWAXud;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786480276;
	b=2gamXnZdFC7/d3dWGJnvk1LnBY4rPKk7hkLBJCZvZhisY2L6b5GNjBKfQDhI4K+/W4CREI
	nWC7569xFcNJo6aDscSlhsNDdR7hrbuPUkhFuIv+c6esXfc6eDcQShxQ2jbA89Z8ued312
	p8/rxpYx3wMa5oMXErv02onaR5AuzMw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PMnGCLWhe15ZxMrHk/gFLLP8e7MuOyBy5Hyx6UW6LII=; b=oSMWAXudvzm/CUEbGg26vfaXAT
	8scbrwj0Ih+wvZNs6x47kHqDnjAC69dPHEpj8n3+gqisIxGsDyEYOh9g0bqDYd2MW/gnKZ5cCgMzZ
	zM2ewSjGoV5PVLorqk3cEgkPF2AEvbUhXOOfmMF4O1kS6Cta8embqZm3n/GywkrrOmmj1EDmSiy6o
	ooOg0NzBqxHIgkPM/M7KtMU3T+Ff94Mr7ltk9fi5xLzbq8qeBqMr2h+C4/kSZzUk0mOdc97jjTgyx
	7pzvKxTjCSw3O5IQUCcjd2+lM7z4PxJ+ue0JuoxYQOMdzHTsr0GUWBmfmew7bejv5uOHpLUB6keWh
	Gb3HYFHA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtt7h-00000000yJl-3DjL;
	Tue, 11 Aug 2026 20:30:58 +0000
Date: Tue, 11 Aug 2026 21:30:57 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Christoph Hellwig <hch@lst.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] mm/page_io: rename bio_associate_blkg_from_page()
Message-ID: <anuGgTKrq90Nw541@casper.infradead.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-4-0899bac3b826@columbia.edu>
 <anYqSDnC2BbJXv1h@casper.infradead.org>
 <612ed1ce-e7a7-410e-9ad7-256e77bc867c@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <612ed1ce-e7a7-410e-9ad7-256e77bc867c@columbia.edu>
X-Stat-Signature: dwtb4trtk99bya1zgqc533ejgd75kz8s
X-Rspamd-Queue-Id: 23B54100005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786480276-306367
X-HE-Meta: U2FsdGVkX1+VrTnAgrdvK0M/9yBbtr5B4NeIMMI4sSKb0WHyzQNpNk++/+RwE7j+ldLhllfeo3+fB5l2NNo4LcknGF9vmH3YZWPkFqttUXne2aEt5R4AU4Z1xV5cgxU00FRcSTvz8NmXUX+vOde79t2Ebe0nRCy46U1N0rts9fBuxVFXkn29Vygo41W63ywOyuiuJ1yMiwBE/Sm7zFcAOaex6QmhbGRcMMZsGmBIZ/S73Jlvfs1kngeou1OV4DuuIDR3lPZE+DPn7vI98Qo4DBKlDisi1kSoe4ooE8vtBGUobWegEZoHaTQ0o2YqjETLC4ICTGXvwNQIMXfTKvOAbsJdi2tt2QEtcAvbzMvWCqmibGawvJ9fnSSKfP2MveY1y9aX1BgdSuWsB1lKC0i7h7jPMXDESERkk3l5m0qW4tVKGjBRtYGI1t7m8y/ceHNMrOlUJM5Yxy0zhVyT9GsbqQulUda64mfDYVhvCVwJ4e6VT90s36lwnZZT1q4WHDYoG/2k2nGxtifT6nX4Zvy8s5epEdznRnZ+4dcKuNTEzftVtaYSp6ysxVz6QKaOwRv8mXCTThKK1FcfyaiOMw1OMICyczYtz/sAzlNu1dDxGRZ6lXoSHI5tGA9ZbDk+WdtfxsuhOJ7siZwaiBAI5dSgRVwvugV8QxadyFoQ1o3Vsa6whHNqumBNDHISmwsGJV4crLxNINybJHFK1PPIQNg5uKStqwQZlaHbLKffBsvRMnJ7up2UW3SgypUr7RPyNIAyVsAIxx8xqt/3tv+In0yLb7UWypjYqcjaXsPinFJMccHHoNY7VfrDH2Q9Wnnc0NM8i5BxsxzGUU6KRBsjgKNQTnjwoOgwOaW1CW5hAxLF7V0ePSYgorRgFSNYWme4wLnhB4fSa8NgSBfxGtqFIwoamSPKiI81CvnhedZBYIYYoa0ozD6QyxzfhA3K/5T3ADmEVLAsDK7vJvgBtd1fimN
 NEl4fVye
 prWLq6lXVcWAsdLXoXewhLTZLKIuCtTqInRHbx4AkcAuOr72inyOPE8USyKuCljsjbsfsb6ynHsEVSQLvmM7h0d8MgPix731fpdMMXLSr0fSADZpG73/Bf40vqnhxsld2a1RtYxJWH1ByPk5zOssk96/RjXvTi8TcMVPCr5suHkEVBAXTuNvKdkehOQjgcCOhgGsNd1Lq424Wy0sqMmin3YT8mKc/WF8WcHSDo5L93NLPyfuutqGD3fHW2ph6NRAn6jjlttoBHOZ55dHkrFFO7CWyXGv7Fz/Czcklvfhd97ai+Gh7Ns6LPUAITzKqaNFvntKg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 10:30:22PM +0300, Tal Zussman wrote:
> On 8/7/26 2:56 PM, Matthew Wilcox wrote:
> > It's s shame this isn't const-qualified (after all, we don't modify the folio).
> > That needs folio_memcg_charged() to take a const folio pointer, which it
> > could.  And folio_memcg_blkg_css() and folio_memcg().  That's a followup
> > patch though.
> > 
> 
> I had the same thought when looking at this and went all the way down the
> callchain to dump_page(). I didn't want to flood the list with patches, but
> happy to send a couple follow-up patches once this is in mm-new.

As the person who did the dump_page() const-qualification ... you're
welcome ;-) (preliminary work in 2021 with 5f7dadf3958f and some
preceding patches, then the actual constification in 2024 with
29cfe7556bfd and some precedig patches)

