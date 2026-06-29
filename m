Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57513C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 20:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 097F26B0110; Mon, 29 Jun 2026 16:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070CB6B0116; Mon, 29 Jun 2026 16:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7E56B0119; Mon, 29 Jun 2026 16:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA0F66B0110
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:09:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A6DF120277
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:09:00 +0000 (UTC)
X-FDA: 84934038840.12.925FC3F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC442C0003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:08:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G96EfPkN;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782763738;
	b=5qskS/nWYuBSH+qtD7olWx5c07KzSUg1xhVwUwhJqWmVMy/prrjAfww2RqZg0VnnoyuQUN
	OvXrEuhlosBaBn+coT1GCOQJ7d0cpL+tehxLgD7jdoDteej8hztiVDNVgUMpS9w6W/rZ5q
	LSs9M+5YhKk9kan/KWgj/EVt4N61AnY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782763738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzQ5aOE5DdkQK7ZMLbfvTWuWtjZSzxV7VRGk7s0Jl/Q=;
	b=Yj6KDa047L4v6phBnEs5T4R54NksvOYvCwjPJpZMEjmjO+pXbS//SgXrU9799+htXTBKJt
	Ygz4iRUnHoghxQfmxf0fNLCsjexBLDtAo00pjq2IXaPGE5Mk8m21p0E4Z2db8WdaVrvktJ
	ejTHE8vVdCyNQ0cO9WLPTvbL75ieot4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G96EfPkN;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782763737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mzQ5aOE5DdkQK7ZMLbfvTWuWtjZSzxV7VRGk7s0Jl/Q=;
	b=G96EfPkNValI8j8jCOY+X8VXfcGo8YFEppVFsmSRV3jELHPnrrlSm94r1V+f/vQs3S2Wnx
	8xNwgcybC6plHtwSAgY7DLkzZBqQlDP0JvTVuGu1qwsIv/bm6qOPJTPE2SBGvvqK6F878Z
	40JNr8Wo6eeAauU0j83jwmOzQK56qa8=
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com
 [74.125.82.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-F382-k45MRaMjFNlTl-VuA-1; Mon, 29 Jun 2026 16:08:55 -0400
X-MC-Unique: F382-k45MRaMjFNlTl-VuA-1
X-Mimecast-MFC-AGG-ID: F382-k45MRaMjFNlTl-VuA_1782763735
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30ba395b047so13195572eec.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:08:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782763735; x=1783368535;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mzQ5aOE5DdkQK7ZMLbfvTWuWtjZSzxV7VRGk7s0Jl/Q=;
        b=lMuXUsi0i9omXDwpw1FbAqmwzsL7vMNQ4IbZpE7fINM92Ze7SDjLuQNR5dLD39Oiry
         UlF7qfiaqV0zXT5YxwgZs3VtnN3ScqwEaeqex951u5AEt29rn7N7fwReKHBVd5LKGZqq
         PTE7tcCvhF0T0dYf2MEVnp2rETGbvw4YshgQNEM0HmPGG38g5Bxm1BTqtYw6sXB6T6kK
         XFAJZ1hFODUweg1cjJtzOFpk7W0ZohbXHyBlS+qf7bDH/hliiYRyhR2VpSMO/89on3uk
         cmhK8wvUnaXWylPCGZ1/qP5uftjjqOFkKjShcaT8GPd297J+1TgXrwMpTODh5etxrCdW
         todg==
X-Forwarded-Encrypted: i=1; AHgh+RqJ/BUV7FlNC908luDeX12Kg/GLPon8/7wT2Xpd8eGpYw9ZmcPR8nvn8RIwu/WhFtf5haZGgE1TAQ==@kvack.org
X-Gm-Message-State: AOJu0YxuqhbGLzMZi9O4mp2ca8LCmSlrePZVCoKcgBuAOcO2aKccPslS
	LnFF6deEwAdEu6rxTTUsE9fMPSLGhasFRpftnsE7apJVp3nzXeogikBuhMof5vCqUBCHMnYFKzL
	eYxLbZfOrHXAm+ZXav/eGBFKo6lUGoqthmLJkWA4cZ0xjeCMPNXwz
X-Gm-Gg: AfdE7cl7gBDFT5Vd7qoKmxbjRYIYLvaWk9+Awqh8Tq+cIX+lCKq+wsrrYYVvSkKJ/ZO
	/J0AwLLPRlwBF9VHnTOxwvjgZPt7Q/SC1tUwkswjcCEiudG1NT+uExh7npIjGiuVg3RinVNPiwc
	QVplHDvGxA9jPM3Lp2zRvU0mtJHVIWTBLc9KVQk+T9AiX5vOvdG2GAsNybBesb+0eQHPwZpToYp
	gwHNGSfnMRG/yLkhmy+mXQKun36gxOKWFBfln2/yBclay2wgjIfKq57ZNuYE4Diio7UW8LSDIkg
	r7ktUP3m3AHeVgwX/LM5EHqFt2IjIQOym8RgsFrHXnOyTs0tDYHBRD1hoPR3bSOhUd9+nH1Fhyw
	duShO7YzCyJrmS40Sdzx3dAhk7UaCH9EO
X-Received: by 2002:a05:7300:1898:b0:30c:ab4f:46be with SMTP id 5a478bee46e88-30ee13a266emr558231eec.36.1782763734206;
        Mon, 29 Jun 2026 13:08:54 -0700 (PDT)
X-Received: by 2002:a05:7300:1898:b0:30c:ab4f:46be with SMTP id 5a478bee46e88-30ee13a266emr558162eec.36.1782763733406;
        Mon, 29 Jun 2026 13:08:53 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee2f5ed29sm733991eec.1.2026.06.29.13.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 13:08:52 -0700 (PDT)
Date: Mon, 29 Jun 2026 16:08:28 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andi Kleen <andi@firstfloor.org>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <20260629092856-mutt-send-email-mst@kernel.org>
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
MIME-Version: 1.0
In-Reply-To: <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5HP7CrWRTAyRxmGcHnLZHg6diJI7yFMPM4zPJQ1utX8_1782763735
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BC442C0003
X-Rspam-User: 
X-Stat-Signature: f114ec3gfpozwo5cf3msxgjm5ygpddne
X-HE-Tag: 1782763737-397641
X-HE-Meta: U2FsdGVkX18Xi5pC/Rief/1h8aRtVtv/0vBBY+h/jwMl7v/9YZji0GsFpSUQgXTJRa2qo2I3TQWc4IjlZn4KwPJ3pDdsFVAK1XprSGiqR7MNHjfv3cRkNB7XjSjj+NSXy/oS7Y7l/uKppfnbTTg0Ro3ZYHSNiofcLe/pLljWrDH72iT8T14kBvIF58c7KG/xZivV2T3U3Kcmi992vqKHL4IPc3ErlCYNIcIe+eVQyUdQoBSmqYxV9OPv+dJ9s1vOP24p1lc5q88GeqwAc+ptBFIzVyUjJpKgFFPZ+SYuBIXAL7n0T77FnmaBKdkB2MDqg1lH+R0B0R93y9sN3V4gwX/xb+DN2vL1MFXHCkoIl7/e9n1jxzETJC5IEigQYdL+uui+jiu6YdRssedvUV1yy//O92EWYuctVE3mbVb50tsS2baQBE9/SSlCaGZaOOO/8/TInGHbPIz4uBtD+3kkDvjdpHhHr8DOy3i0xHFNPXR2eF3QVKZM/sOOfu67ImeZmRWIfzkh4F5de3lB4jS0N9lPPLTl/wXqLVZHrpFvQJvbf8wrIBRph3ptIzOlwi0LBuiJNChPKCkEWqh/CUu/ugt6xi8bu+9rWgyHG7TY0c34CStPVhuK6rVXkRXkaFrzkwhZDL4xyg9My+LKSBi7YQQr1ewJnCL99FdrmWVAEbh7uZL54pJW+OofifSthucpyn9w3IPcMputJHgUAMYRwUassZWmoY/PvxdgwjKdPQdTmwNlAENGsTRIuSKiew8O4pphLrlToSI0IFDBHXvq8k2N0utgc1bfylOu1Y4MzhlvwtfnYl7xs1WtO7lFHTOVphM1d3G3GmpbuCcQWrKdbtru0/AB+Bvr8yHQF4KayAXJrUcGxUYpeGNDCggDNqSB7ZCjkvm2wnTeEENzRXn6P793X2x5g41PniU2dV0SThadjVt1ca7yu75dBS4EwNHttuFJRc6bNlnGHHjVlvw
 pRsZ3gNy
 ZM0HImWxemohehvuHe6u+lvEj7Wz1HcllzT6q5sm1OllSAfHogMgzxLT17Qv81K1OuGZEfSbGyI4vbejZvgL2UBhUUWwUK8FyLUUUpH7NZd1eO+k31DmUud9/h6DjRnGI5DYG2wEedPoXiqtocmW2XliynA1Q2htHoSe6NrYpF1YnbELriSd65tzJA5zDvS71oWbD68cInD2fyOLfagw9ITWWQ7Gx0PWE1j3eIEIXuIssJYV94oKuEcOwNRQCCII+3gEi8CFzsDqZP6SY80tJNX9qhu0fWEQrVQkSZXPi7COQjGryCahR+0+fZzla0eay8kKloBq5wFg7BYGyPmnsRSkKmUsNn34d+CAddkBFxeK0ce0hxAbiwrCg8RE9ZM/u72ECoU7J0LZ+bkihVrrnoYRNwmmQ6PXjPt86
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 03:05:18PM +0200, David Hildenbrand (Arm) wrote:
> On 6/29/26 09:34, Michael S. Tsirkin wrote:
> > On Mon, Jun 29, 2026 at 08:49:37AM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/28/26 23:45, Michael S. Tsirkin wrote:
> >>> I don't like it that we are adding overhead to the good path for
> >>> the benefit of memory failure, which never triggers on many systems,
> >>> but I don't have a better idea. Pls take a look.
> >>
> >> As I said on Friday.
> >>
> >> "It's also doesn't address the mf_mutex implications and the x86 thingies I
> >> mentioned.
> > 
> > Well I did attempt addressing this.  These would be these two:
> > 
> > 	(a) We don't hold the mf_mutex on all call paths, but we really need it so a
> > 	page_test_set_hwpoison() cannot race in weird ways with the other primitives I think.
> > 
> > page_test_set_hwpoison was this code you wrote:
> > 
> > +static void page_set_hwpoison(struct page *page)
> > +{
> > +       lockdep_assert_held(&mf_mutex);
> > +
> > +       while (!PageHWPoison(page)) {
> > +               SetPageHWPoison(page);
> > +
> > +               /* Make sure concurrent non-atomic writers completed. */
> > +               synchronize_rcu();
> > +       }
> > +}
> > 
> > and indeed the test+set combination seems racy.  But consider the version I posted, for example:
> > 
> > +/*
> > + * Drain any in-flight non-atomic page flag operations that could
> > + * clobber a concurrently set HWPoison bit.  Retries until the bit sticks.
> > + */
> > +static void set_hwpoison_drain_rcu(struct page *p)
> > +{
> > +       do {
> > +               synchronize_rcu();
> > +       } while (!TestSetPageHWPoison(p));
> > +}
> > +
> > 
> > ...
> > 
> > +static bool test_and_set_hwpoison_drain_rcu(struct page *p)
> > +{
> > +       bool was_set = TestSetPageHWPoison(p);
> > +
> > +       set_hwpoison_drain_rcu(p);
> > +       return was_set;
> > +}
> > 
> > 
> > 
> > does not seem racy without a lock. But maybe I don't get it.
> 
> 
> Staring at your implementation, just think about two concurrent invocations of
> test_and_set_hwpoison_drain() in your code:
> 
> Assume HWPoison flag is not set.
> 
> Thread 1: test_and_set_hwpoison_drain_rcu() -> TestSetPageHWPoison()
> 	-> was_set = false
> 
> Thread 2: update that overwrites page->flags. HWPoison accidentally cleared.
> 
> Thread 3: test_and_set_hwpoison_drain_rcu() -> TestSetPageHWPoison()
> 	-> was_set = false
> 
> Thread 1: does RCU sync and returns "!was_set"
> thread 2: does RCU sync and returns "!was_set"
> 
> So you could end up with two thread believing that they atomically cleared the
> flag, and you really need to lock.
> 
> We really have to document and enforce that the mutex is involved.

Sure, that will be somewhat easy to add, for anyone who works on this next. But
just to make sure, I think they (test_and variants, and clear) *are* all under
mutex in the patch I posted.  It just isn't enforced. Only set
is not and that's safe I think.


> 
> And I fear there are more nasty details to be uncovered while we rework some of
> this properly, mandating a detailed look.
> 
> For example, TestClearPageHWPoison() in put_page_back_buddy() likely needs a
> proper treatment as well.

Hmm I don't see why. It owns the page. The issue is only if one pokes at
page flags without owning it.


> Likely that code should be reworked entirely to not
> have arbitrary hwpoison page flag modifications throughout the codebase.
> 
> > 
> > 
> > 
> > 	(b) There are some leftover SetPageHWPoison etc. instances. The ones in
> > 	arch/x86/kernel/cpu/mce/core.c likely cannot grab the mutex, but maybe they are
> > 	corner cases either way and we can document the situation.
> > 
> > Well, I did try to document the situation - it's in the commit log for
> > patch 1:
> > 
> >     Note: the MCE handler in arch/x86/kernel/cpu/mce/core.c also calls
> >     SetPageHWPoison() and is subject to the same race.  It cannot use
> >     the drain helpers (MCE context cannot call synchronize_rcu()).
> >     For recoverable MCE errors, memory_failure() is queued via work
> >     items (kill_me_maybe/kill_me_never) and will re-set the bit via
> >     test_and_set_hwpoison_drain_rcu() if it was clobbered.  The
> >     mce_panic() path sets HWPoison for kdump right before panic() so
> >     the race is irrelevant there.  The MCG_STATUS_SEAM_NR path does
> >     not queue memory_failure(), but the affected page belongs to a
> >     TDX guest whose CPU core has already been marked dead - the page
> >     is not subject to concurrent non-atomic flag operations in the
> >     buddy allocator, so the race does not apply.
> > 
> 
> We should have a central mechanism in place to document this and avoid future
> mistakes.

Like maybe a wrapper with lots of __, "raw" and "unsafe" so people know
they need to be careful.

> I am not even sure if we should clearly document for SetPageHWPoison() when and
> how they can be used, or if we need a completely new set of helpers.
> 
> And that's something to figure out (e.g., interaction with the mutex) by looking
> into all of the details, so I expect this to take a lot more time.
> 
> [...]

And again, I'm really not sure fixing a theoretical race when memory
is failing is worth slowing the world by 0.1-1% for.



> >> This is nothing to vibe-code. This needs a real expert.
> > 
> > Well I had this sitting on the disk anyway, so I thought I'd post.
> 
> It would be good to coordinate here.
> 
> Like a reply to my mail, asking whether you should post a new version that you
> have already in place.

Sure, I'll keep this in mind, thanks!

> > 
> > I wouldn't call this vibe-code - a bunch of manual work went into this,
> > llms mostly as a grep/sed replacement.  
> 
> The version you posted earlier had real AI vibes to it, so I can only speculate.
> I know that you did some manual work on this, but the details are really ugly in
> this code.
> 
> > But hey.  I don't object to
> > someone taking over, for sure. Was fun, and maybe these patches will be
> > helpful as a starting point.
> > 
> > In particular, maybe I should have been more explicit about how your
> > points from Friday are addressed.
> 
> Yes.
> 
> > 
> > If you want to add a bit more to explain the exact concerns here, for
> > whoever works on this next, feel free to do so.
> 
> I raised some above. I'll try to find someone to take a closer look and see to
> which degree we could optimize this.


From what I saw in my testing, if we allocate 4k pages
it's hidden by the overhead. With hp and thp it's measureably
worse than rcu on !preempt config.


I also tried keeping atomics in most places but optimizing the compound
case by test and set of pg lock, just to see what happens.  Was even
worse:

  4K (base: 5105 ns):
    rcu:     +63 +/- 144 ns  (+1.2 +/- 2.8%)
    atomic:   +8 +/- 144 ns  (+0.2 +/- 2.8%)
    pg_lock: +133 +/- 144 ns  (+2.6 +/- 2.8%)

  2M-thp (base: 52965 ns):
    rcu:      +74 +/- 780 ns  (+0.1 +/- 1.5%)
    atomic:  +657 +/- 780 ns  (+1.2 +/- 1.5%)                                                                          
    pg_lock: +1691 +/- 780 ns  (+3.2 +/- 1.5%)
  
  2M-hp (base: 53788 ns):                                                                                            
    rcu:     +150 +/- 821 ns  (+0.3 +/- 1.5%)
    atomic:  +427 +/- 821 ns  (+0.8 +/- 1.5%)
    pg_lock: +2413 +/- 821 ns  (+4.5 +/- 1.5%)

this is without preempt rcu. with preempt rcu it seems
much noisier so I can't really measure it:

4K (base: 5605 ns):
    rcu:     +126 +/- 136 ns  (+2.3 +/- 2.4%)
    atomic:   +44 +/- 114 ns  (+0.8 +/- 2.0%)

  2M-regular (base: 58179 ns):
    rcu:     -834 +/- 1573 ns  (-1.4 +/- 2.7%)
    atomic:  +440 +/- 1645 ns  (+0.8 +/- 2.8%)

  2M-huge (base: 59937 ns):
    rcu:     +800 +/- 2653 ns  (+1.3 +/- 4.4%)
    atomic: -1402 +/- 2546 ns  (-2.3 +/- 4.2%)



> 
> Or if there are actually more performant alternatives that we could use. (I
> still doubt that using atomics is ok in general)

Right now I'm thinking of looking at something like stop_machine maybe.

Do you want me to try?




-- 
MST


