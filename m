Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6362C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87CBB6B00A8; Wed,  1 Jul 2026 04:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E086B00A9; Wed,  1 Jul 2026 04:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D2E6B00AB; Wed,  1 Jul 2026 04:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7E76B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:18:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B610EA02A2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:18:22 +0000 (UTC)
X-FDA: 84939505644.30.F796CB9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 371841C0005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:18:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SE4RgWDh;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782893900;
	b=8j8pWBrB6OfWf6w+8pzouH47CDQmlL1KafYwqLFNE2zAbOSbsO3gDri4M8/ybDwWDUITxL
	UMMKgNtQKUBSer6T4jgBqhZ10iEFefHFMDkMnB6ihv0IqxaAm0tGeK6RpgMvnr9UzB9bfs
	up8UnHqtrc5WhZbu3+ZTyjHdjzGX1pU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782893900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LmfLTmWYgd/3XHF3IWN+KkX93s3f/MCewHSC/ez+FP8=;
	b=HKdCqV1tMOG9gB62cDmIeF59wDi4/0XtrN7agZ626aBE5vMMWx8ql3PqwebCTjYb1Tm6WX
	qWbSMA9hZQZxsVArZ23D1CcJqjluC46ti+056HuAw/4Unl82dyJM4gR9ps5vi8kVbE45tu
	YNPKF4Eb79xjEXGkdC/vtNq0fbC4UkI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SE4RgWDh;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782893899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LmfLTmWYgd/3XHF3IWN+KkX93s3f/MCewHSC/ez+FP8=;
	b=SE4RgWDhI3vGtwUz7mx3hZd8U3SDMbMKlFlGOTILByqymK/wfJn8wonQ47iGInuTrvjGvv
	vtwnik6oGRyHPbw3YEEI7IV/nI+1jR/Qnu7ObqqD1scFegWCzNgVa4C4kx5pRUTdyuHW+4
	6sXzuPOqEmzcSnJdi/35wlon1yR/scQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-GSNjSpgYONe1LWTKob4MwA-1; Wed, 01 Jul 2026 04:18:16 -0400
X-MC-Unique: GSNjSpgYONe1LWTKob4MwA-1
X-Mimecast-MFC-AGG-ID: GSNjSpgYONe1LWTKob4MwA_1782893895
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso3325545e9.2
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 01:18:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782893895; x=1783498695;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LmfLTmWYgd/3XHF3IWN+KkX93s3f/MCewHSC/ez+FP8=;
        b=rzz+KvyohOwfUHrUPTEZ0c5TdRE+KYY8aNTIz4M44tVvyimU3FTZOo1v2Z5NeQ2sqC
         bCRgjq7kYTYIp7hqk7wct+ZegqWuaOLTg2fjkkY1VGKsz4Y5JCyXaAHqVQ5x+4OvQoY1
         XN0GSs1KS/lCp5IJP48xUvzFkq3cHHBE9e0qQ/j7mQZhDOVGm0JHBzjk6wc1pCsPtmvN
         Ckxz1Xd0JcLkYTIwBRp+o40ZXZ17XJ6yFoo6xo0fF4zEJWGPQ2gv8p9YNTqIw+K1i+RX
         9gDPGSprfgWCCs2RyQzfWk9r87PpW2oLKqOJNcKHPQ0EwTkVHYoFl1K861wTYbuNBlfm
         9gVw==
X-Forwarded-Encrypted: i=1; AHgh+RpDnz00YTM/WJGkKKagPCPGrmjVO4LUZl+zb5IisEPWpHaOevl7nk4haCInazMEp3SzkjV04AeEsw==@kvack.org
X-Gm-Message-State: AOJu0Yzam8iXNCpu2K/1NUNqr0msoi9+CbdtKkX2iGLjDVkeRvUaFVOc
	hjvkZ2fhub35IF686GK4PPfLPsSgnVSsg/vsl7kEHEQuTYa7vb+kyCtgTWni/80OUC29uKhu7MX
	EnecrqsfDQS0oXC+L8rVhEFeRnVYuJKYilF6PLCKpr4idxpmbHi8D
X-Gm-Gg: AfdE7cnFhCZA4fIRamzztwThvxBtqLb2MYLawED5lKMR6+41HvbmxxJTEwytr6f+0dj
	/OlgRGtvRpCG3Dil16MtCGkdq44QDe3YgWRAI59ppCM6RTJO11dBWTSSJ5WFZBQwoyBvEFsCWE2
	xRJVxGPIO5V1tzNrPqaKdWlIR1sKQPh+CVWjh5jv7NqPhC3S8GmLG4s4miyHbyob6Kw8qeZ1PEb
	Xh96AtoNcjAyn7ZGX2AmkxibqEXSWa7KQ8d9EjMrl0VobkR3BDSY/h3hl2m9YfwL0SBdEQZezjP
	cYaTrW3Hc1btos0AaQL0DTshggXQFVvejFj+deScGpJlmbQ/Yqg88TwIJSLz9k9Lv9Z12cCdOw5
	NLmNQUkD/dD1JGhrjo2GkO9d3FwL+Am/+
X-Received: by 2002:a5d:6e46:0:b0:472:6602:3347 with SMTP id ffacd0b85a97d-47759754d45mr731608f8f.43.1782893895122;
        Wed, 01 Jul 2026 01:18:15 -0700 (PDT)
X-Received: by 2002:a5d:6e46:0:b0:472:6602:3347 with SMTP id ffacd0b85a97d-47759754d45mr731560f8f.43.1782893894571;
        Wed, 01 Jul 2026 01:18:14 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47567a6f351sm14961756f8f.36.2026.07.01.01.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 01:18:13 -0700 (PDT)
Date: Wed, 1 Jul 2026 04:18:08 -0400
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
Message-ID: <20260701041112-mutt-send-email-mst@kernel.org>
References: <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <20260629174225-mutt-send-email-mst@kernel.org>
 <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
 <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
 <20260630174852-mutt-send-email-mst@kernel.org>
 <2f884bfa-3cd5-4fba-8aa4-c2e68890ab64@kernel.org>
MIME-Version: 1.0
In-Reply-To: <2f884bfa-3cd5-4fba-8aa4-c2e68890ab64@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Tt2gzWZq1muMszF7LJNFLgb8ABM0_8_OiQWMhK15-34_1782893895
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 371841C0005
X-Stat-Signature: ih3akf5qfz5k8kqotos4kzmi6qgxee7q
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782893900-166911
X-HE-Meta: U2FsdGVkX1+uK21t5VY1MoFVtBqjOpiJEj1+XKVm3Z3P8Q7OqK/qgAKZEfFbw/cPVxIv700akveHadvPpKUDonOcIvdsN4J7QWbETigcEKVec99Xa12m12joTpPGz5RWXbpS8AbJI3Xa12uZqQxFmRC7nqmbo7sudVD8ZXi6DubT1hyi1VPfI/1a8hxgtZbf14ALGX0gyzUSNRgABxMCKJ5wwzjrjYmXv80+k3IcB8QuG5hHKoPDns4DUI8Gaa3qEgdokXuQW+Q+o0FoR2e4jwpIojgeiz9W5XfhIfzVijotKeUsnifotyo7vUWj5uExL4mo1knYoUf4tKqj33xmGDRhhiZVtXrn8ewTuyHQ1Tj+HvjRSyj2pvDrVvt3s6bOoJJSOO5Ri+d+lJSAzeMYjd6s/cGMrvl9TnNqI+onjirIWcfEycwNCFDmqiHGWvEk4sx07c/Y2Pf/MsSZLfqR/iG6bbBKu+q/5Wa7yFBurcJKA+TnP64HQ3k5qJDlsXLAR23wUwyfuSFYkBZCj7DSdFlzVIIIQbG8ZbHQCcE0lGNp9FRoFChZ9XsSonl4g8aiO2Z7H4n7xtBBgQKafL87wHiDvZqMrfDWbp+/pSp4CPwNhOOklxLkQ3Mw4S3eYWfQ7JP09bx2p2PBnPBtNm8fkZXtzMwglEdHV2gzedMCNsEOwr9s7n+6rtywd4iowmikI3PzG7bJx9inoFF8FRvErIUKLS7ZuaHvK9pI730X3VQxlT1EIIpQ04nu4oIUw6VHebb0qARbL1ZC0PmGjBUHJ/ppzI2nfp7TTYLKTnV4/CVN78yKEiI96JNjVZoEVMMZHQ2+onnRQRzbu+wyU1+x1n5jZx5e+HXiPpHDN8W1BVYVMMWNFoQhM2e2fre2LH6LFdG3mvlJmPuHKj55nU+euUBgjLDFkPhmoJQKXfl+NB56nhKSqa7Lz1ZvApl+rYfbteUsZLQuXehcKA6rZNv
 l9eNkQn4
 H3tk8NpwGLtiSEYAJCTw5LwLQo3jc0lx89v2m0cZ05YK3U7lKW/yMwBgzkYAArD/gKUSvGgz0CNMj/vvh+/9yYs4vZuUW2x/0iAw1V0isnYHya6wh9aQG9l9Oh+VHAHwTaZhxuARTH7pNasD2iMOP7xpaQHr0fFrCZofDqUbImKtNBZkdb+OSFPMqV6TIdTfulZ5eV8FcdnM6r4bzfPg2lZ9Lr9Q1mYVuy/R9ijD+xq65fxWiFwJvVmsOZEXVQELjXyVwF1fyXCGAAUaOEObV+dfQH1E5qa8kMqovGRC902BnnZuD4UyNotSJKZODvvuXc5aobl2KZl7NAPtP/yHaGhCXJsWtf6v77P1fQ40Zsi7k5qSvpHVhC3lTKHXhmKOpQ5c/KjcZxT2kEnpHAk1HvlojOEZHt/uQTPHI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 10:08:45AM +0200, David Hildenbrand (Arm) wrote:
> >> Cheers,
> >> 
> >> David
> > 
> > Yay. I did that + dropped the extra lock/unlock and now it's in the noise in
> > my testing. needs much more testing of course.
> 
> Cool. I'd expect that latency-sensitive workloads (PREEMPT_RT) would not want to
> have hwpoison handling either way, so using the no_resched variants at these
> places might be doable.
> 
> > 
> > If you want me to post (including addressing your other feedback) let me
> > know.
> > 
> 
> Let's first discuss the options. We essentially have the following one so far:
> 
> 1) Ignore the problem
> 
> It's been there forever ... but I am not quite happy about that.
> 
> 2) Use atomics everywhere
> 
> The easiest+cleanest, but as measured, the performance hit is real.
> 
> 3) Keep retrying for a couple of times
> 
> The big problem is "how long". A CPU in a hypervisor might be stalled for quite
> a while (20s? can be longer).

So on this idea. It might not matter. What I had in mind is:
1. run the current logic
2. add page to a list of pages to check, then invoke e.g. call_rcu_tasks
   (or call_rcu_tasks_rude) maybe
3. in the callback, recheck and if poison cleared, go back to 1
4. otherwise everyone will see the bit set, remove from list we are done

it seems to not regress anything, and for the rare race, we set
the bit eventually.


> 4) Disable preemption around non-atomic updates + synchronize_rcu() loop
> 
> I think it should work, but I don't like the possibly endless retry loop. (well,
> it would never be an endless loop in practice)
> 
> Is there a problem with synchronize_rcu() latency, given that it can take in bad
> scenarios a couple of seconds? (grace periods can be large ... but also very short)
> 
> 4) disable local interrupts around non-atomic updates + let all CPUs perform
>    atomic setting/clearing of the bit through smp_call_function_many().
> 
> Disabling local interrupts is way too expensive. :(
> 
> 5) disable preemption around non-atomic updates + let all CPUs perform
>    atomic setting/clearing of the bit through schedule_on_each_cpu()
> 
> Mixture of 3) + 4), but schedule_on_each_cpu() can also possibly take a long
> time (as long as we cannot schedule on a CPU ...).
> 
> We could likely build something that remembers all pages with bits-to-set /
> bits-to-clear, to then kick off a per-cpu work ... and once all CPUs processed a
> page it was fully processed ... needs much more thought.
> 
> 6) stop_machine()
> 
> Big hammer. I think we'd still need to disable preemption around non-atomic updates.
> 
> 7) Move hwpoison bit out of page->flags
> 
> Use a sparse bitmap. Quite invasive, and any hwpoison bit checking code would
> get more expensive.
> 
> 
> 
> Did I mess something up / forget something?
> 
> > Or look into call_rcu_tasks/call_rcu_tasks_rude which might work without 
> > changes in mm.
> 
> Looking into call_rcu_tasks() (the first time) the semantics are interesting
> ("involuntary preemption is not a Tasks RCU quiescent state").
> 
> I'm curious how this interacts with random page allocations (on the IRQ path?),
> and which design you envision given that we only get a single callback (who
> prevents code to re-enter).
> 
> > 
> > Or if someone else is gonnu work on this, absolutely fine too.
> 
> I can likely let someone work on that, but I think we should first figure out
> what can really be done. (and likely when we send it out, it should be an RFC)
> 
> -- 
> Cheers,
> 
> David


