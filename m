Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F9B16082BF1
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 16:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=GqtzFb0P
Received: by kanga.kvack.org (Postfix)
	id 3F0856B05B9; Mon,  2 Nov 2026 11:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2916B05BE; Mon,  2 Nov 2026 11:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B316B05BF; Mon,  2 Nov 2026 11:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFBAB6B05B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:16:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B2264017E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:16:17 +0000 (UTC)
X-FDA: 85390681194.28.C2C8EEE
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id F2C421C000F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:16:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GqtzFb0P;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793636175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypRec8Xh5wIqvkQ4ITkAuTU3Yz1Vsg+897P5Sxky53s=;
	b=mRPLfQO/ulnWXJDM/zhduLvKruXZKvXKjAZvBtzZB1rjMeEqgGj25Mk08gzb0VpFpFpy61
	Pi5hYN/+IXBS3FZK54q/CWifdZEG7qI0ZciXkrsvVUI7zLm/WfWLDjl3rJIxlMnVNEGCN3
	Twv9dfMRJ1lhWXNQGW+5PtiJa9ripDI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GqtzFb0P;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793636175;
	b=T0g7OsK7H35oyHybJIdQVaWDRUYhkxniCmuA6xLn8oVYDau3jZWNPv3puAh0tE88EdluPH
	4u9y7EYqti4JglPbrQZplgRGPiBCgKS3CcLhoBU4qMJfMqIXDJJQ8I/O1gdoFNDKEuvOUt
	zApL+tYk6SkX96Qj9iH99ie1hiV3ueo=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a214af2076so24593565e9.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 08:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793636173; x=1794240973; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ypRec8Xh5wIqvkQ4ITkAuTU3Yz1Vsg+897P5Sxky53s=;
        b=GqtzFb0PThNIwGC8pI5DDzBN3xk5LDEm0lpqiGbFEHpSIhxmWvre8ab37hlEaZifGG
         WTNPkYpv/PHNwoCBL7izbPb0cgHlmlBujUs6eMwWCB7ZhmNa5jbO3p6L4foi4SZOm3gB
         Kfw/VHA1sHhjhuHHv4wxZ27WDGWxSuahWBNTjdG0zAXOxlxirysHM7Iq1FJD9tlvOcsF
         pnJB8MP2SfAOM+zRH7rozJGK4++hnXL3nfzdWfxsfXqaDBx3Y5fv1lawkesoWamD4uYI
         a+7PSDhTjLKAcLH1nEQHyUdBVpxnRqyxeOBZuh9ZT8BpmyGDPELIGyoozBbTasSYxhDE
         THig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793636173; x=1794240973;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ypRec8Xh5wIqvkQ4ITkAuTU3Yz1Vsg+897P5Sxky53s=;
        b=0jO4RIhBn7hKsLSrcJy4Jk2RDqJkLFpi7Tf8ntV81GQ1wd/QBP5a1sZoM+QjGZE6DU
         9QNzNswhMpIR0z8Wz1RMNPD8To3rVy0e4MSTMWwjVTpdAxtk0wQ/Wtc/1pxa3z/yZBGa
         tMoY1bASIGtUSwGR3msmIP+1xgyBxH8lpKnzJwErxCQ8FQkxMLRPxNNb7haQqp7fU3PN
         j1ziqGWqRvQ8gmz/eDUqq93SYnmHBHPNo6kb9eyfZZIx/THLsE4D1ThGEMkfHRvn3QRW
         PBHG3WYTBSWc5IKzhBH6GXwukV+AJREHHGVzVQnRV/bXgksHBeYGg99pEMtJ+9LbFC5D
         tw9A==
X-Forwarded-Encrypted: i=1; AKwUvBxyxV9crwuRY8xB8VI+zOh+duvyxR9N/b60hgw5gQAAuwup49czQV1/i6RYAs1Qnoc6MUwScF1tPg==@kvack.org
X-Gm-Message-State: AFq9FYI2GpAYScFNjnGu/GQvSaPZQ8L1BK8NRo8M4wTUYWggOsvyVzIt
	ynM3TgHwrpVs6M7AHOERz6ChRxe/4Tw1fArXF79PJNZYH4YVuoVu49l3hBjZ3TDLaVI=
X-Gm-Gg: AYBFou2HJuM9F+yJP2EHN/oV2dm7nhE4W80sGCPUm0+VsXcx/8zu/hv2n2tsshv2eZ2
	oPCPctBM5wD7hsGWPO/AajS2dbr10XYqKHIWMziXLeb1uZm5ZNg6EQEZxzMWuPnv4y0bUSjcQdl
	+iCLOw9Y+1qWBygliBpT7/ka+jdD8P2iYvO0st1oyHjzCo7ngL03VQKmq4PuriEAneSgDdke+gq
	mLZV2XrVJ+13m5emFq/2cWXW2ovx9/URtqDBW1eUcAj3QeWstDyKilLWR1JOIQb3Rsaesli88Fd
	r3f84o3eTaxCTnvhpDSrzCr7NFNOEdHuDxKbgWrq0pUXEzwBW9lZyuq9rxOBLyakAWz2Mr50anV
	R6oWIqAHUj0ohza4VWnOIIxRynRxoA2cr3vdS7/XEIZHMxhAGYYCmx/SPsbMqs5jBBlDwyTbuA5
	K5DB3yuZYHT+/jxIygQ02XMrZILDLeBVneLSCwXPqdyPRkih+Xi1fIk1R6rMTafhv7Pw9BqvCFH
	bWuJkLaMW4SaBDN6IgKloQaul04fpqR8EExugZJPU1pZRgficXEj+xDKOVfU69NDfX2QMIADMgL
	fAeqVJOnwXE8lsOVjR1DfYQnKHjBhvuCEA8QWQ4=
X-Received: by 2002:a05:600c:b8a:b0:4ab:c447:49df with SMTP id 5b1f17b1804b1-4ac182dca8emr234675195e9.23.1793636173515;
        Mon, 02 Nov 2026 08:16:13 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9a3b1sm22666963f8f.44.2026.11.02.08.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 08:16:13 -0800 (PST)
Date: Mon, 2 Nov 2026 17:16:12 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to
 page_counter
Message-ID: <aui3TJqadHUv-4RW@tiehlicka>
References: <auiBOBfRIiup8Aob@tiehlicka>
 <20261102152018.2773572-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102152018.2773572-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F2C421C000F
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6tpqwr35wssjojddcq4kpip3d6ckxcd3
X-HE-Tag: 1793636174-179872
X-HE-Meta: U2FsdGVkX18MOXNfqV9fiTzgn2wTAocRtVPrhFUksQeDGbn6QoYFbwucgOhKKdAfu3hxfqlI5hNyjjCfU++JUznLwGDxPzb7CesixTq3AsYyxDBFXAJB47a3Ca2yNqsP+7OgttJcOEYdzjXjqHZI9mOp5HIm43Opp9cgGVT3bdMG54aTbvfA2CgPy+ElwygV3Yb9kRari9c5fQhmhDJTAZkaSq+uq6h86JF0773hOIrI9P4FbM+T79dD+nhrXvuX5BIzeO2o8nStrSeJX/2sz06jN4EsWfwqLnMVfLQDI9F9sz0qm4j7iWJGTKHClDzRZwWOpdAOWFOtrmWQ6oGwktZRwLF+BOpqQxLWs++pZmvhMxIVXZIDwDAyhiVqFckEltHHoFMVyrcw6K82gOGwAOzmq/4wgox3k97xLDzDiYo/f79pZmvN7oLHOMlkWXYYGPbSX4lBf+C4CiwSC4iH9uzIEGUrbn5zsJPTzWN1O79nMCJ+0BplfARY4LHpUx6n8RO7+rC/+4mZCFCIU20PHXxSe46Wa3v1J5FMBFLbnC53uoNg78eDQd1WyzBPmDMdSKl6MoaUePrBeo5qtBbAKW5LdmTN5sxWz3LUbotzhYX/g2kj3zD8JO3qknRyX2eEpEQqhHm2RSEiYmCJkoh1Cxb2h1h57X6QJP/+UHpAisLOwwNNGI3PGyVErhkEk6a5JA2kR5+ryqqM/C1urgKFtnfI4eFEZ6I8+OhJFQqOeHQI567LvqLFVxhUaJBjQVrYERASpokvD3wyhNjImwF0KuRzqST1kDOAVC0R0hQBt4mOgBqMB8Tr2metFaq2GkHXMg310kh0lfveKJ4if4KanjujtBX4lNBLlyMFuOgacpxv8Rpl7gM74dlmiHjNLO6V7anSvkm50itkXaV+6VoBCkwt39pyvjqGf8fEwVhnPyI4pMggcfDfQbCaK/xo9uQD1IWQp3zitTSSM8Fny2O
 uxOrhQoJ
 qIahzpPFUWs7bCezeYVkHTEX9IFoGpyErIPe1DBKW8HaYxIjS2sUG+u4vgXUqZfnbkVmA9SOoE9ffsXjy1qP0/IaE4OE+lC4rb4/s/IcyIbt+8la8fUqXuWmU+D9p6xJmAlhm3sJaY6bMSDORteenovgpUkBegs05FagRjhsojbqUTrfPwaK5nxJdFaCmYljJmjbmj/AZHKnFkkWt4atusHbf9hJLzZlUqXIoGN7tUP0Na7fDGAKBau1WzaIVQx8nBUVha07tRP+4747f/TbSb6MUAijgvkM6yTlsAiwUaLBeKDtDK/K8GdM6Uok4uYfWbzuI01nbbAU7UILXeKLtrAMRgUjYwxENeF9l5iovPspAgYmnew0FK/R+FqCmqk6uFm3yhwWDDEWKfSR6O1PVfkUKSxNzA/tIIAMcSDfzwrpmLiPI3QuBwc9WbOKP5W3MqVYOm0dtC6PlojKxRJAbWFJg5fAFppRMZ6A+uSQd5aEeGNDuxV8qhrkiGpWZhHcySwmfIoZ90bueBlac7pApwogR5/l/cRDxhEyt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 07:20:17, Joshua Hahn wrote:
> On Mon, 2 Nov 2026 13:25:28 +0100 Michal Hocko <mhocko@suse.com> wrote:
> 
> > On Mon 26-10-26 08:59:37, Joshua Hahn wrote:
> > I guess I still do not understand what you mean by opting-in to the
> > caching.
> 
> Reading my original cover letter again, yeah. It does feel a bit strange
> to call it "opt-in"... I guess I just meant that not all page_coutners
> will be getting it, it would only really be the memory page_counter
> (and memsw page_counter for cgroup v2). I'll change the wording in the
> next version.

OK, that makes it clear to me now.

[...]
> > > > > We get an added benefit of simplifying try_charge_memcg(), which now
> > > > > has all the stock management handled transparently within the
> > > > > page_counter layer.
> > > > 
> > > > This is quite a large change and I believe it will be really benefitial
> > > > to have some high level design overview in the cover rather than trying to
> > > > chase it in respective patches.
> > > 
> > > Sounds good with me. I can add the call traces above which should
> > > explain my thought process a bit more. Hopefully the problem I am
> > > trying to solve is evident there.
> > 
> > I believe I follow where you are heading. I am not sure this is the
> > right path but that is a separate discussion. I would focus on whether
> > moving cache to the counter makes sense on its own (without that future
> > work) at this stage.
> 
> If I'm being honest, most of the generic benefits that exist beyond that
> work were in the other part of this series that I got rid of to scale
> down the scope of this version. But to explicitly name the generic
> benefits, it would be unbounded memcg stock caching per-cpu, eliminating
> random evictions, (like you mentioned above as well) limiting stocks
> to leaf memcgs only, etc.

limiting cache to leaf memcgs makes a lot of sense and addresses a big
concern I had. How exactly does this work?
 
> I think there was a proposal to make the number of memcg stocks per cpu
> even lower than it already is, because the author wanted to include
> additional fields into the stock that would make 7 no longer fit into
> a single cacheline. I feel like we are reaching some limits with that
> side as well, so the "unbounded" portion seems to be quite opportune.
> 
> But I believe those benefits that we would like to see are made better
> by this series, which makes the stocking transparent such that the new
> optimizations don't make the existing memcg charging code any more
> complex than it is. By abstracting away this mechanism, we can make sure
> that memcg just handles the logical charging semantics, and page_counter
> handles the implementation-level details of stock management.

Yes, these are all good arguments. Especially when clarified that this
leaf only feature. I have to say I was struggling to see how caching on
all levels of the hierarchy would work in practice.

> Personally I am a big fan of how try_charge_memcg looks after this
> series, what do you think? 
> 
> > Quite honestly I am still not convinced this move
> > is the right thing but I would like to fully understand the mechanics
> > first. Having discrepancies among different counters just sounds like a
> > potential source of future problems.
> 
> I hope that I can present a good argument for why this is not as
> concern as it may seem initially.
> 
> My first point is that the memory usage counters were always fuzzy, as
> specified in the memcg v1 documentation too: 
> 
> usage_in_bytes ... doesn't show 'exact' value of memory (and swap)
> usage, it's a fuzz value for efficient access.
> 
> Secondly, the raw value of the usage is actually always accurate. It is
> just the stock portion that overcharge the memory at times, making it
> seem like there is a discrepancy. Flushing the memcg stock immediately
> bring the counters to their real values (like what happens right now).
> 
> Finally, this is a change that is only limited to cgroup v1 users.

Right but is there any actual point in adding caching for memsw charges
now? If you have a way to opt-in to caching then you can simply disabled
that for memsw counter altogether. Fewer problems to deal with, explain
etc...

> This entire series actually has no effect at all on cgroup v2 users,
> which I think is a nice perk. Obviously I'm not out here trying to
> make cgroup v1 unusable, but I wonder if anyone is still using the
> legacy feature.
> 
> I hope this wasn't too much of a brain dump on you. Thanks for your
> feedback Michal. Please let me know if there is anything I can do to
> clarify my intent.
> 
> Would you prefer if we continud the discussion here, or if I sent out
> a new series with just the cover letter changed? (I don't anticipate
> any code changes, based on sashiko review or anything else that I see).

Let's just iron out things first.
-- 
Michal Hocko
SUSE Labs

