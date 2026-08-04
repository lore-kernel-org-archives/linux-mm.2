Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91018C55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6506B00F6; Tue,  4 Aug 2026 12:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696866B00F7; Tue,  4 Aug 2026 12:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE4A6B0101; Tue,  4 Aug 2026 12:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 386A46B00F6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:58:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C50A180271
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:58:31 +0000 (UTC)
X-FDA: 85064195622.18.11AC2A8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9C3A2A0006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:58:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dGe+td3k;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785862710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0GJoGVxbTlIBAP42YKS4cXI+GskDdJ5ICUAbo2EeCI=;
	b=fy8tXgvur0KBqbzl/XO+6nrFbeJu8mqvyJ+f1CgGrFs5OxX96H4TtzsdPagktqvq0ARe/X
	Ukg4PUb16jBsJZN597gZVpk53pqTL8nWm7hBe+BsEsZaBkrMfEtiLyK9pij5Puogbne5kb
	yris+NklWKiaZ6vKnAdSGJCs2AtFns4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785862710;
	b=xdsPha9gBTnZr/HY/TqjmYgI+jOMXbc+SlWXseZA+cCbEvZ7ObgjaPj+ZTwTRY/D0gHSlX
	wFoGtIAPEx5JTVjuLopeIMiDQXKcKvpTeUYI+sLvDjitKnXIJzFD3cTaq5krUaqLdCQJT6
	8+IwmCSGpJWuZol4QrrPP6APxdw72YE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dGe+td3k;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w0GJoGVxbTlIBAP42YKS4cXI+GskDdJ5ICUAbo2EeCI=; b=dGe+td3k7UwjmVOjPgl3jDZCCu
	CdnD4eYaC6V2CTUkATigem2GiHGmlHomRhH3jIrx5LMmC65izTa6jou+FuAXT8EFvB58hMFtUyPeV
	b292cWiywxz13a4y2kjTMG3QqaipkOoy0gX0mfodrQ8aWTJtlwG/MgC2U7uwmc6MfKPqADKqkSYUu
	xrV+x1MxnkdZIucGQC4RAE0vzePNhUdX9GcqCBlU/lEQPQDpCmv2PjIIBvk/EhS5Jl/iaia2vYBI3
	e7kg6ofl610y5oJNQN0sGj/A9dbMicchAvoeov+Bp8c8DIo92e22n8j3czErH7B0BVhVA87bKDP29
	76NVB/aw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrITC-00000004K3v-2AK3;
	Tue, 04 Aug 2026 16:58:26 +0000
Date: Tue, 4 Aug 2026 17:58:26 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 09/15] mm: Remove locking mf_mutex in
 is_raw_hwpoison_page_in_hugepage()
Message-ID: <anIaMs7XtXp631QU@casper.infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-10-willy@infradead.org>
 <anIUe_Zq8bFX0-Dk@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anIUe_Zq8bFX0-Dk@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 9erwxmnwf3zj7jxcobkfk6q7fi3actf1
X-Rspamd-Queue-Id: 9C3A2A0006
X-HE-Tag: 1785862709-13918
X-HE-Meta: U2FsdGVkX1+nzO7PTQJ0i12OWjHdmquApPdw39qSnZEr1Zdy8LtXNMG4r1RAh542yz5vs62oQJcp/OHiagRABguHPqHDtukobsrhccQj1AppPaQynFbRiqZuoBw35CFx0Ac47dOf1OmMDR/kuPpFGq4EpcfDCCilV1b2lLxqP65XbDw+xpEGfpGkg5ykLt/wfKC+FiKbmgaVdz6Eo8uPfG0Z5kGK5b1CDV78K3aVyZZ8tp1O/EgQRhNYJAdt61/WCKkHw9PtEz9AXNpn210MxaRNUtenh6W5/Y16gAODWNezopfjeDtQJwobwRNMVHshLJu1EmL4cqG8iP3a1kgUvptkrV20N2s29oEswN84qp4G2PwarRfZdBP5bp1BRnyajk6yccewXDF70J+9pwR0sWrnxvF/lFEgvFHkdKxbRKcJ8wePmCXnwNYJHfUyLDgkg6JGBQlZBjDME+4cWmqLUDjTfDjNhTn3Ma0tJDD/GW16PxBK+phhl+nLbbLOLyYhXlNZFHhyJn+2oNjIAYjT0Pm4Nw/MXSdlmO28UR2+aJhbHvcw3O0EIunvd8LntrjZXCTAf6rlQKmKR/WtOhr6WWmeo+Fzkhs53SIKuEsw076PKB400ADYxX37cUQizXr17erCIVVdzX30qxmr67BhT+iyne0sRdf9tQbry6ERaSR7bCZJ2Gfbf8n4FOunGLEbdPZL2BEcVO0EpeDLp1i7O22aTtEGHaV3IkXGdRHT3TBlIZV6ufLf/XWP22URbBhQS0iFU0slBsy+R9RRcuUwCxnkJYReYv8MwZHSCPgM3G1XSSLw9u53FxXhCePgBq7GXod1RaG9K6902001AZFBaFXH30AhuvEM2+xGJzQCcU6IgSjoIygIFKXdojS3ByDSnvdEZezBGX+LHcwwXgs7z2UInw45Na/PdhXsllKjc0EIt3dXxQ0BMJ+++6C7LKcJjEi1W2WaQFAUVF3QZAL
 Fse8i4M/
 c/er5axFAAVm36zwV/DFSS+wRpVVln5r2zMWGKR7sBegVulGB368w3rIOZK1Fakz1pSW3tqEIt6Z6R3MCxf5sX9xuIGfH3x8lTW62s/4TOtm0kwBMSEDGe+HoWmKV7SPguaJ8EEmRuVtpB65Dswju8JitQ4JlgAhASDUGfPuErWWohmHGZaMancmLLCdCZJUV+ve5DC1uIgoTivrvG5HSPj5vOw2VCd9eFBJLI0YUgI9ha8H9KnLhOx75EAZGzp+0hFBbw9MhTBspBWwnj5Hvy61ZB7EeEHvDMa7BB2NLOGaSBmUShrspgT7/b5YMIsyF0qWezk2/z8b0rT8gWYS1bdXQfpnbA+nBb0P180lzThkJ4C7C384RtNoJjVHY24VL0O22bzJmGi9FpVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 12:36:00PM -0400, Gregory Price wrote:
> On Fri, Jul 31, 2026 at 09:07:54PM +0100, Matthew Wilcox (Oracle) wrote:
> > Sleeping in this kind of predicate is unexpected.  Add a new spinlock
> > to protect access to the list, and turn it into a normal singly linked
> > list now that it doesn't need to be a lockless list.
> 
> Out of curiosity, wouldn't sleeping in this context not just be
> unexpected but theoretically cause issues? (mid-poison, sleep, scheduled
> process generates more poison on the same page...) - at a minimum this
> takes a thread out of the future potential poison-generating pool?

A reasonable question.  We don't try to handle races terribly well --
hwpoison can be generated asynchronously by patrol scrub, so it's always
going to be possible for a thread to hit poison on something that the
kernel didn't know about.

What we're trying to do is avoid touching memory which we already knew
to be poisoned, while also permitting touching memory which we haven't
been told is poison.

I see the locking in here as preventing list corruption and UAF rather
than preventing races.  I'm also considering that we're now exposing this
mutex fairly directly to userspace -- before it was only being touched
through some fairly weird mechanisms like reading kcore.  With this
patch series, every call to read() potentially touches this mutex.
And that could hold off recording any hwpoison for some time, not to
mention serialising all other calls to read() on a given folio.

So we have all manner of protections that prevent us from taking this mutex
-- the folio must have a hwpoison page in it and must be hugetlb, but at
the end of the day, one can still be preempted while holding a mutex and
we never know when we might want to call this from a non-sleepable context.

I'd be open to arguments that this should be an rwlock rather than
a spinlock.  Or figure out a way to shard the lock per folio (lockdep
etc make it very hard to embed a spinlock in struct folio).  I think
it'd also be profitable to change how we record poison for hugetlb to
not need locking or memory allocation.

But this is all a very long way from where I want to be working -- cleaning
up the page fault path.  I think I've made a reasonable set of improvements
here, and somebody else can come along later to make the code even better.

