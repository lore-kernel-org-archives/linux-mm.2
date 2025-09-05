Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 302C1CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 07:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42A5D8E0009; Fri,  5 Sep 2025 03:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401AC8E0001; Fri,  5 Sep 2025 03:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317608E0009; Fri,  5 Sep 2025 03:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 246E68E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 03:40:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA17D1A05A5
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:40:36 +0000 (UTC)
X-FDA: 83854399272.02.F532782
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id DC821100005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:40:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mT53coIe;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757058035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCYWjv4/uvpoaNIlf52NrK0zMeYtiQApWHnF4pvRUPw=;
	b=MaUqPtD6Y9XnVKhhRLP3Q1Kwyqvabe3Uetu3CBNh1OZvShngATpV6geiWECyy5moth46+J
	D0nSTwIu0dxMjSOP2Uofl0Jp8yV2gYarW92P6sH0h/yZBU8bzE7BDQlTugOa3cRQWQCeKf
	8gb0DJRdOCsr9rxeJv+IfPxT46xJZeM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757058035; a=rsa-sha256;
	cv=none;
	b=jV1hj7lMlTefiOGRQ6AMJqf5riqxtu/IQQwQ1HzAwzTtmPmITAws0YFQchqtgJW3zFNo8v
	1Rtb/1MCXWoWV+vsMcIc3+BYpIbdbi509937rDWWZVTW7wN6d61JFNFcbmvullf6FoQfqi
	hhJiUunaOto4PPGFNTPkIcKgO/unWDY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mT53coIe;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62800446AF;
	Fri,  5 Sep 2025 07:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FECC4CEF1;
	Fri,  5 Sep 2025 07:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757058033;
	bh=8UKw6qV+Fp9Btn+/AfFbnwNu4EeEIhUSHPGO2BLKRVk=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=mT53coIe6u+FbsfjBU1Qu0I0ndzTHQnBZTnkprg1+cQO85N9TkB+L73GC+CnbNCs9
	 fFg7ptRLcnM77drww+TIHh8PMsbMKi6o4kmXdKfF0ImRIfY6ufE9lUnxEsCCyhc2ld
	 sKf9R9GlYPQikEjAzKR+xV/pq6Hsp3vVa7lKI/sxWjocRmTVuaXgfouj9ejOp2JP0V
	 PzSu2DOZkbiioOmV17nqpR1kLXcga4C1jCVKTlYOEYXzX5Pw5sl9FQjqjRr0KKEDeC
	 nXo/lXiC70ZYJU6TEcQ5Tlorm2QkkaGUoj+AElEEiVgPkCFBQvDvXvUPzhq/303++1
	 zD9YcYMstQjkA==
Date: Fri, 5 Sep 2025 10:40:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	akpm@linux-foundation.org, minchan@kernel.org,
	kernel-team@android.com, android-mm@google.com,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
Message-ID: <aLqT6M6xgvEREQu6@kernel.org>
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local>
 <43ryds7hzhs5bpaxznco7fppmakdb4f46agwtsc5erudqfoz2x@7y4jgbtft7jj>
 <413ee338-1795-433c-b3d4-72c870488d95@lucifer.local>
 <84aad392-3bff-4f98-b612-5e9a046edb36@redhat.com>
 <CAC_TJvc=5=iS8gCumJWqH5eF4XufFSogqtWHJmiH5WBN1A6gng@mail.gmail.com>
 <4chxl7uxr4exy2z2dcshxla3c5nzzo2tbnelsbbky7pdzrih6a@hzfnpbenfmub>
 <8e1881b8-3867-4cea-b03e-50c05ed8148d@redhat.com>
 <e3lsreaj3gpqgt6l32edvyjbiscekyezhosaew3lgu4xvbwmsv@2bfpvwtl4bpe>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e3lsreaj3gpqgt6l32edvyjbiscekyezhosaew3lgu4xvbwmsv@2bfpvwtl4bpe>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DC821100005
X-Stat-Signature: tbtspfo94zfyosqrynxgegdmqdjpofep
X-Rspam-User: 
X-HE-Tag: 1757058034-41324
X-HE-Meta: U2FsdGVkX19XXZn+Ytd6zqqTJ8Q9BNRrNY89R/rbMqhG7S3nF3/0klWsaNrIQv60yQprAVtl9rZymwYIKpfncP2Sc9IUpnB+gwhUrfYAw/66YKjB/5Acp8lYPaKKLZj456otIgDRdZCsNoY/1Du9q8C8cca30+hpIS/fA69ci+c8ZMcrwhg84vDJLB1vTXzRof4TbMwW8Kgti4u9KE6j1QLWWzZjHVV/IhWgveXGlYC8EEJhRsJ6U0LoviMJfinFF7Kzfkj4I45igfLLuqaZvoOyhNd1AyTgrBeEv/NTetQpJ6k80PzVwLx5wcm/DQ1IKHMD5yS1k6VqS8Lug6TtHYO62Ghq/crWY2yXJ80Bky/X0CNIEpGKVF1HJOqxKVy2/mRK6WQ1haWZPQQpnTHtKG4s9Dw5tH1rkKwyyjwLiKw/KeUFeTY8Wluo3E6rL5W/Ny3XTMU0yOO0xPQ2hLs4Z0Sz/zkV1sfYnbsAQLGddxnFlqiuc5a8rL7iaTcWQCi4t24Qcn5jyz+5TSf2nhhUaUP3eDD0V4ugTHJQJu4MqFvg78SCZD+bbh1oKNflqXrqCq5dqzf3MvjrE/74VMPoLpOhh0LqJWyVMrWtsES8BzrmfzdUOGuEmygimaFeY/6ctJyWudknZ24wddBwcepjnPRDwrar1ZcGGi6k8kbN0ZxMAtirp3cgeTRvABJWVAwwRU045UCGeqDK1vh28HBXu1N0HovHzQqcPErM9GKkE+3W/w9iPtTXwg6vVEMwjvlXf9fx97u17ErVSM8Zxm9tyel2kW1KwgH9mASE/Uahiz4gmFOBrA2k+kQrUyrsTvChcNLcDcfmZNHd/VwMkf0QW4gZ4/eH7IVk7fMkLzgimhmz2GypgbpvbPeLXpNadppe+li+bSWRof9NoV56E1U52UWEz2zXoMKlhhdT1IxudNkusiMEjJtib3zN5/mLaxZEnOtZTyLgK8aIkgUPT4s
 EUGnH5B5
 9Mb2tsDLbLm4x5GWwly3DzpgtPqVSU7KVVGuo8oNbnvPqShQV0rDEPmmbxfgcrHxMuvBZj2Kv6z3LZ5kCraf4k8URHqXL0zm9WMUBb1rZV/ePx6p/GA0oHvurD8rApW3032/n8fthFIlypHUvC1JsvBxnWkkajoi7oDx98DNj0Mm75EjfRBGhzAlP7BaqdM5pPcprRpOOixLDMNR86ZQH2HVChva/R2pV1ypfjGn+0KsVKXNonnD2X/AHWP/PavAP2km3XU3ozwH1mrRqVahGlu9wfkJ1R703Vx0UepVkP8H8u+T1qfS54qZUeNSXms0KRW65k80OejA5uH8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 03:11:46PM -0400, Liam R. Howlett wrote:
> * David Hildenbrand <david@redhat.com> [250904 15:02]:
> > On 04.09.25 20:49, Liam R. Howlett wrote:
> > > * Kalesh Singh <kaleshsingh@google.com> [250904 13:51]:
> > > > On Thu, Sep 4, 2025 at 10:42 AM David Hildenbrand <david@redhat.com> wrote:
> > > > > 
> > > > > On 04.09.25 19:33, Lorenzo Stoakes wrote:
> > > > > > On Thu, Sep 04, 2025 at 01:22:51PM -0400, Liam R. Howlett wrote:
> > > > > > > > > diff --git a/mm/mremap.c b/mm/mremap.c
> > > > > > > > > index e618a706aff5..793fad58302c 100644
> > > > > > > > > --- a/mm/mremap.c
> > > > > > > > > +++ b/mm/mremap.c
> > > > > > > > > @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
> > > > > > > > >      * We'd prefer to avoid failure later on in do_munmap:
> > > > > > > > >      * which may split one vma into three before unmapping.
> > > > > > > > >      */
> > > > > > > > > -  if (current->mm->map_count >= sysctl_max_map_count - 3)
> > > > > > > > > +  if (exceeds_max_map_count(current->mm, 4))
> > > > > > > > >             return -ENOMEM;
> > > > > > > > 
> > > > > > > > In my version this would be:
> > > > > > > > 
> > > > > > > >      if (map_count_capacity(current->mm) < 4)
> > > > > > > >              return -ENOMEM;
> > > > > > > > 
> > > > > > > 
> > > > > > > Someone could write map_count_capacity(current->mm) <= 4 and reintroduce
> > > > > > > what this is trying to solve.  And with the way it is written in this
> > > > > > > patch, someone could pass in the wrong number.
> > > > > > 
> > > > > > Right, but I think 'capacity' is pretty clear here, if the caller does something
> > > > > > silly then that's on them...
> > > > > > 
> > > > > > > 
> > > > > > > I'm not sure this is worth doing.  There are places we allow the count
> > > > > > > to go higher.
> > > > > > 
> > > > > > ...But yeah, it's kinda borderline as to how useful this is.
> > > > > > 
> > > > > > I _do_ however like the 'put map count in one place statically' rather than
> > > > > > having a global, so a minimal version of this could be to just have a helper
> > > > > > function that gets the sysctl_max_map_count, e.g.:
> > > > > > 
> > > > > > if (current->mm->mmap_count >= max_map_count() - 3)
> > > > > 
> > > > > I enjoy seeing sysctl_max_map_count hidden. But map_count_capacity() is
> > > > > even more readable, so I like it.
> > > > > 
> > > > > I don't complete like the "capacity" term, but I cannot think of
> > > > > something better right now. Maybe something around "free" or
> > > > > "remaining", not sure.
> > > > > 
> > > > > I also don't completely like "map_count" (I know, I know, we call it
> > > > > like that in structures), because it reminds me of the mapcount ...
> > > > > talking somehow about "vmas" would be quite clear.
> > > > 
> > > > Thanks David, my original implementation started with vma_limit() :).
> > > > Maybe something like vma_count_remaining() ?
> > > 
> > > Yes, reducing this confusion would very much be helpful.  In fact, if
> > > you put it in its own function we could change the actual name with
> > > lower impact.  map_count vs mapcount is annoying.
> > > 
> > > vma_headroom() ?
> > > additional_vma_space() ?
> > 
> > VMA space might be interpreted as VA space.
> 
> Fair enough.
> 
> > 
> > I think basing it on "vma_count" would be good.
> > 
> > vma_count_capacity()
> > 
> > vma_count_headroom()
> > 
> > vma_count_remaining()
> 
> headroom or remaining have my vote as the clearest.

I like 'remaining' more
 
> > vma_count_avail()
> > 
> > vma_count_left()
> > 

-- 
Sincerely yours,
Mike.

