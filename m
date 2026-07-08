Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 856F6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727446B0088; Wed,  8 Jul 2026 09:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FF6D6B008A; Wed,  8 Jul 2026 09:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EDFA6B008C; Wed,  8 Jul 2026 09:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF5466B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:00:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55C57C026F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:00:20 +0000 (UTC)
X-FDA: 84965617800.13.214E17C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id AEE641C0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:00:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DSZyg+Py;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783515618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1nxHUHuYBD2sRGWeQWBd/Pf2pEVUcm+cL6w6ahUDa0=;
	b=fJlpWyv9UCeJ+G6CP7X8f3OznAwkS4NTt0qFMke48+fNPxFKyF5Owir6tu1tr8WpchkAX+
	a4djgijGTiDZ/YutnJ+DSMIDlXF7Tpb/bNReubQZ5+uGP3IL9eSODA5eMySl0bfJxw4u2m
	YsN3/nvgfpt00OQEeycMeHZJSMaxJtA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DSZyg+Py;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783515618;
	b=nALn6MwcJcSaVs3WzuhUwZcGBfq1O9nOMcyxzo3oBVROh6XhKXTIfgubB+RiG8PifNmm0P
	ZPYqJobb/dG7r0AEmURfWwHlx+dy7kX36W6DEW3/KS0NedBxO7+08/c98wjDr4hKYaweOk
	X+oe4Wyjh+cuvJuLT2M4ZHn8jDFLWFA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783515617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l1nxHUHuYBD2sRGWeQWBd/Pf2pEVUcm+cL6w6ahUDa0=;
	b=DSZyg+Py6Xno846+1QVp68JnpT30SBr+C2eWDAK5gSZOeUjU2WIhSwvgvB6BV/p69nVm+D
	hrG5Whu5grnjBXRzRNFCSAWxYuPfsW4fRtfUpRn09Yv20fjLl4D1ZuvwVEqhf3/6ZJhF6y
	eGCn2k6vKwORbT1r5iAOs8SqVUhf9Mw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-lloTCU2UO3SW3ePm4GRIyw-1; Wed, 08 Jul 2026 09:00:15 -0400
X-MC-Unique: lloTCU2UO3SW3ePm4GRIyw-1
X-Mimecast-MFC-AGG-ID: lloTCU2UO3SW3ePm4GRIyw_1783515614
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c15d4107068so53507866b.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 06:00:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783515613; x=1784120413;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l1nxHUHuYBD2sRGWeQWBd/Pf2pEVUcm+cL6w6ahUDa0=;
        b=PE4i/T2YfPDWI5uJV/8ahvpO+YI30pvBVs/TYdQrx14WPBrLRkcj55kdz5VKkrApE8
         uUz8N31vsK+3p822tYX+04q5YTMFfMoXisYZOyXXxbt1dbdFnYQIOTOR2/J3tjeXs1OR
         o98TuJ7t30kpGqNlIrN1N2gMTS1aC97riGk2fOuHH3eFEqQL0SF/wvTlhavTqctLRspu
         5EeJFx6dsBFVz8j2goGFyVXrNsnyivwufjoDSlDJ2HMa6uXMuCjUTFYOddLD7diPdur7
         t62wdiCn4zlB9ruPSqoTkl5dYjBaIE3/kHNcMQYgaYr1u5f1nZpOrkE1CNHWnHwCCry7
         H17w==
X-Forwarded-Encrypted: i=1; AHgh+Rrjqm1Wm9nif2StQM7mZU1X0/PZqFS8w20YjpTPJM+svd40mRtXwPzFUdr0DThti242Y5k1kmb+jw==@kvack.org
X-Gm-Message-State: AOJu0YztHPvFSTox9lWXYidentVv8jFu4y+XGOp3+6ZEGIYYjVc3Tx/0
	TG5cynvFnldibWSlqPavVmcksf61hRTjQXSaNtPsR3fy8LcVpbPrekJlIAzil3jlB2QmCYgQFkj
	xiUcd1rikfbQQqkx4vTym2tgUDFMZSVtL3qkQUTyeIG3kvTKDcCE4
X-Gm-Gg: AfdE7cn7XypEaaM+jxxfdO0Z1o8QX2R6WQjwZYOdnzHnyCpy6/TxP4uGb5vo7KLSFN0
	xDa2EkchnRvPmMf7/eYkzH0dQ6jlV7vGLNhbdQXT24OkxQCfqDLlJJHLESbU93r5qRjb5eHrlwR
	o95qlkA+jpNXorE2sXbHct7IP8GfByr1yufhwhHc2s8ZKTSOe6M8iCey6OPSEAd5j/fzMeaGS8z
	oHyJzkjU7mx/ah5sKlXURhPnnDKxI0iyYz/RkHR2L8BG7u+u73Lt+EkNI22GF7YA70qj9wWt3aP
	CndMi2pfHcInHEseYKBcMzKGNdzsTIP9PsPdCgdHUerjJqRxUZKeRwS5ojD28asT+unpIu2eF/T
	3+NhN/Np4Lw8T03f9wiX8BmvSmpHL+ut7
X-Received: by 2002:a17:907:26c1:b0:c12:7e24:a76f with SMTP id a640c23a62f3a-c15ce025ae4mr111218766b.20.1783515612921;
        Wed, 08 Jul 2026 06:00:12 -0700 (PDT)
X-Received: by 2002:a17:907:26c1:b0:c12:7e24:a76f with SMTP id a640c23a62f3a-c15ce025ae4mr111210366b.20.1783515611401;
        Wed, 08 Jul 2026 06:00:11 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15ddb9e1d2sm6630866b.52.2026.07.08.06.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 06:00:10 -0700 (PDT)
Date: Wed, 8 Jul 2026 09:00:05 -0400
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
Message-ID: <20260708085745-mutt-send-email-mst@kernel.org>
References: <20260630174852-mutt-send-email-mst@kernel.org>
 <2f884bfa-3cd5-4fba-8aa4-c2e68890ab64@kernel.org>
 <20260701041112-mutt-send-email-mst@kernel.org>
 <d2ce93d9-c3d8-4915-a511-d08eb2c1b374@kernel.org>
 <20260701043024-mutt-send-email-mst@kernel.org>
 <c03ec696-d635-4c7f-8c77-89a439d9135b@kernel.org>
 <20260701112946-mutt-send-email-mst@kernel.org>
 <a353c28c-a864-456d-9b00-7f6a932cda73@kernel.org>
 <20260701180511-mutt-send-email-mst@kernel.org>
 <6b0f028c-574b-4b80-b803-2bff15a5a148@kernel.org>
MIME-Version: 1.0
In-Reply-To: <6b0f028c-574b-4b80-b803-2bff15a5a148@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y5fV151zwUOb8eXO5291HtoN2ps7Ob1qhTipPnygtmA_1783515614
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AEE641C0003
X-Stat-Signature: uf9kqw5h8rt8gctiafqsyx1ubzk36k8z
X-HE-Tag: 1783515617-612913
X-HE-Meta: U2FsdGVkX1+lzumZqSOVBkO2cv/ZFXqEhFy4lZLMkfkeOzWkQzkYwyl6xVhOIkdV7eN9p3vM0z2B60UxL21sAkVABoOHUzbYeiWCrGj7aR1086Z/YlYl0wn/4SdDyJHImEThVaYWMdqCBX9ScnH2rA9jwljegROdJgXGJCPMDy8EK2pZfwOD6RNkPDYU0mHygnYWslnmQAH/HaFgEYq6JYIi8f0EHFF516bPrciQOFMrCkoTej5PqIt46M7KonWXE9AOsfRk0PIEla/mkgJ6S6R7a4Zt6XCyHZWz4lPYxFsQESwQIzkoO4y9peggihCaLss48v0YPhwoZgv9whRQSwcjKr4s4XoJ3LZ/4+p7Z0Ikz/ZFJ+lxkJ1wGMTdyEjK7cJYh4V9eCXaGfoMccrNfoekvcra4DrMC687hXs+a/oiPGp52lNjf31zNPT8QGzmBcHuhFN+x8lx2vGg+waZ4dOl6uUuLMvzovq9eGPsIBxHqsGaSNXrtT7JjV9woRZNYRlNeVJK1Y3KwtRvceX/BohFpvfXUy756EcPw1pE49Y9QL7I6ZRyKDLrsl5F0gws4PI+SoUqF+YQGtL6QFq/PmXIK4krV3aF+6q1VQTpU1PguQLlMC4NlqsQ36Z+f3cJhypdel38PQG82xmk1UWS7c4M3LJyBQWAMZ3biny1d5PWAaxyCkpncL0u9OLFxCjB7r+GgnodDc2ENg0T054CjwD0QGF6KaRRAWo5mDeHovBpYw0yaDWcX9kQBem7lq2HCE1cu7gRnSh3buP2YRuU7r1jqh8fn+2xmVGtZzNcHnDWABAlgCpuu2ah1UYneO3ro3NlT6Eic+85wOipbpvyFgTY/uaKffDU+BbDddLE6/3Hx1n0/vI56zm11FwP2qorUEIOXOmGGQzQdNnUHq+YuDdbwyudO52MFumas7aoE0MbsagwUx1rTSL0kM+r5NvMv3BTBhjkR+cBz6yXnRj
 00lzVfUy
 qCk537YVYk15dWpTIAu9HXlLu0Yo/IXQo1peUqLqqvWZiZlKESE5uUgbxFOZV8uW/G7M/nBFquVznGdJox7z/n/DBKUUHcUI3+oh+Eyfhx9/R9yPN1zwVHPhaa76y4Mrv37SPI8t8XWm+f3+4kDOwOdCMIFPc8m09Wt4GbtSve/okONZ1lPwitPHgA8jNeY1bySml/f/UplqvVZBkq/QubaSTj74hsRQ+YxttAaJJWDTxddWd76GIwg4Ezx8relAkAD3ZRuKdKivonXPUDU63/Zf2pIY1LFNGDe7A7qKEVnKMpdACjXODRH6SMXlteh+6B8BGVkQKNMRpFE3aURmWAHvaOrfaTjPtFp8Kh+333vQzpdrhaFr9uyrJKTarVbGNMET5wLYg25YCEkzyZrO6ctDWdbDnCP/Xd3pL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 02:13:27PM +0200, David Hildenbrand (Arm) wrote:
> On 7/2/26 00:18, Michael S. Tsirkin wrote:
> > On Wed, Jul 01, 2026 at 06:17:23PM +0200, David Hildenbrand (Arm) wrote:
> >> On 7/1/26 17:54, Michael S. Tsirkin wrote:
> >>>
> >>> Not "generated" surely. But assisted, yes.
> >>
> >> What I thought.
> >>
> >>> Still hacking on it, but the difficulty
> >>> with memory-failure is that fundamentally, it's not 100% robust.
> >>
> >> It's all a bit slapped on top of everything, yes.
> >>
> >> What I was wondering is, assuming the call_task_rcu() and it takes forever,
> >> there might be quite a while where a hwpoisoned page that lost its bit is not
> >> marked as hwpoisoned.
> >>
> >> So you'd actually want the one doing the test_and_set_bit() caller to wait until
> >> the bit is stable.
> > 
> > not sure I get it.
> 
> Essentially, I think that after you set the bit you'd want everybody else in the
> system to see that state before you continue.
> 
> Such that other code that tests for poisoned pages would just immediately act on
> it. Like the buddy not handing out such a page anymore, immediately.
> 
> At least that way it's easier to reason about. Losing these bits is really just
> nasty :(
> 
> > 
> >> But that should be rather hairy as well. :(
> >>
> >>>
> >>> For example, we have a fifo fed by hardware and consumed by a workqueue:
> >>>
> >>>         struct memory_failure_cpu *mf_cpu;
> >>>         unsigned long proc_flags;
> >>>         bool buffer_overflow;
> >>>         struct memory_failure_entry entry = {
> >>>                 .pfn =          pfn,
> >>>                 .flags =        flags,
> >>>         };
> >>>
> >>>         mf_cpu = &get_cpu_var(memory_failure_cpu);
> >>>         raw_spin_lock_irqsave(&mf_cpu->lock, proc_flags);
> >>>         buffer_overflow = !kfifo_put(&mf_cpu->fifo, entry);
> >>>         if (!buffer_overflow)
> >>>                 schedule_work_on(smp_processor_id(), &mf_cpu->work);
> >>>         raw_spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
> >>>         put_cpu_var(memory_failure_cpu);
> >>>         if (buffer_overflow)
> >>>                 pr_err("buffer overflow when queuing memory failure at %#lx\n",
> >>>                        pfn);
> >>>
> >>>
> >>> if there are lots of these and the scheduler is slow and it overflows,
> >>> it's sayonara you have lost the flag, right?
> >>
> >> I guess so. I assume on relevant hw you wouldn't expect a storm. But who knows :)
> >>
> >>>
> >>>
> >>> Oh and by the way, I just noticed that when buddy merges pages it does
> >>> not check the poison bit. So it looks like there's a simple way to lose
> >>> the poison bit - have it merge with a non poisoned page.
> >>
> >> When we poison, we try to take the free page off the buddy. At least that's what
> >> I remember.
> > 
> > 
> > Yes but not immediately - we set hwpoison then we try to take it off.
> > 
> > 
> >> So I think we would just then go ahead and split the free higher-order buddy
> >> page to remove the single page.
> > 
> > Later we split, yes. But I don't see where it sets HWPoison after
> > split - it calls
> > SetPageHWPoisonTakenOff but it seems to assume HWPoison is already set.
> > 
> > Am I missing something? It's late here...
> So, we set hwpoison on a page and that is sticky, even when the buddy merges
> them, right?

right. bar races but that is separate.

> When handing out pages, the buddy will check all pages through
> check_new_pages(). If the poisoned page is part of a higher-order page, that
> would still find it.
> 
> So I would assume that the hwpoison page->flags stays there, and
> PageHWPoisonTakenOff() only tells us if we succeeded in removing the page from
> the buddy ourselves.

Right, I see.  Btw in a bunch of paths even if
we unpoison we lose the page, right?
And it seems we can also lose a hugepage just because 4k in
it got poisoned?
Is that expected?

> 
> -- 
> Cheers,
> 
> David


