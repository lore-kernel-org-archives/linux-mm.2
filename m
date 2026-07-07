Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E5D5C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19F4D6B009D; Tue,  7 Jul 2026 10:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176D56B00AD; Tue,  7 Jul 2026 10:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 065336B00B4; Tue,  7 Jul 2026 10:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6FF46B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:02:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 324E64047F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:02:06 +0000 (UTC)
X-FDA: 84962144652.09.3545B9E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id AB1E040010
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:02:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h6pTFk4I;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDvld2BXpFSwdt9ItbR9zFXv+7W3dhSsVabE1vNaiZo=;
	b=plXiMjaKImcmJugBOT85jPrXqUI7bTd7cS5FnNQ+9m/VTRqxZ2h3q1Rm2PGW58rjFZ0jRa
	GGGPC+u/xYwZoJ/s2iv69ZEFXH27N5JED8qNfwv52PWADxQgMvK6GYFK1o189tZ01xWi7j
	Rkhe071XoZtthhpR0Kw7hj9GAcsjdBA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h6pTFk4I;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432924;
	b=NDSn9nCsLi6lxDpLR1hc7cRDbQIEfRjXEuNG2sSooCTecsF2w55ud/ytkwIkR1rUI1Yq5z
	VgyZO1dte8l92sqNv9uHK/DEX+C9815a9KF01uNkroiVf0f175M2isDKIWYgwCt/1Mz5e+
	5XlZVz9vzl/zhiSbQXp4gIbZ0TbbGak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783432923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WDvld2BXpFSwdt9ItbR9zFXv+7W3dhSsVabE1vNaiZo=;
	b=h6pTFk4IYH123/K/KTC7KimTVl1BYb/sJW1NtNarASBYiJeCudKCx4J13GF4445H0YAy5S
	n1KJyrGOLdbhqvTPLvGsIYD1mp+Xu/gQiv+PvnPZmzpSP6TCqcTLjdjUPq+pOy6S5T6iJP
	OdRfa9DwsuoCls/clrfJ7VrTgrpeXoc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-218-d5K7DotrOISQhre2QWXFjw-1; Tue, 07 Jul 2026 10:02:01 -0400
X-MC-Unique: d5K7DotrOISQhre2QWXFjw-1
X-Mimecast-MFC-AGG-ID: d5K7DotrOISQhre2QWXFjw_1783432921
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-493c55d5ce5so20109475e9.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 07:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783432920; x=1784037720;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WDvld2BXpFSwdt9ItbR9zFXv+7W3dhSsVabE1vNaiZo=;
        b=ABxy+ipOSNgCVEb/VfSw4xGuNigVQzgeEw8HpnDeDidq0fulLk/QwWq1n5abCSmzm0
         pQKOojDyZfsQH+/bPMRcu4WK10n9hPKrpXHTZQNHJclIDPpl69/cOoh9zubWgDfckgZU
         j1WX5RJiJOgU/UYbBQkOTssgB+TgitdZp3eEk4VM3PDV1//o9A0U0iUGu9Olle5dswUh
         5eYkZMgS/Pi8XmUggx9Rb0H3L7aYpUbix81SWLSDFu+Q84PCgqxhhw5dEaxyL7SciI2M
         bYItbKYHqQNseQW96hLamNLY5QQoJpdu0ixHbwLmh+FvyyOYkU22uR5Tf2bPRV9ayIWJ
         4uSQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp+yTmpUSxj3R0X69m+Sv65p90Lkl4ta8Yqb/Wzr2aypGz8g9Nq2x1Za3jlJKRdNj9MNSKcE87X2A==@kvack.org
X-Gm-Message-State: AOJu0YyZ1hcL3YEKAmpduMIkujsMIg9PUAOZqrS9NqbdgBfivJmpTPix
	C0Pl+JqoDZ0IVBQaSJQOwrfj1nmDW8QX73GdDuTSKHOyVqEV8UQCQ9Ukiw9Club2TnaeaH+ZLwf
	EA1YfO0G06CFwlNUovLXfFKnQ34/I1lb3r6mq05XJAj9pWtgpsXRR
X-Gm-Gg: AfdE7ckCM/uq+N18WQ5rc7L9oXQmkCtG2cCG37gAbozLwCoq9vbkB+srvmzXfi91K3N
	DthoqL0073EtlNeiBW8zU8pJ571ekmDv/Ym/MKZfoPXqIDsH8d5VsXU0tVCSYvhgtWcBi1m9UfA
	3R/f3iYQy9DyvHlKjjOVmoaBG7QtBXSlNaueotfPdLI3yXsgxf166Bbq6HcYyIelZ+KnWflpAAV
	Y3eBZO69mxVHwZ32UevDnbsLDwjzjwRJWNv0OOmH39keeEaDhhLJ5Hbl9dwPOolnm8C+RG/vt3N
	uu58mMlCtxdaKffRgS2CLPGcIneOcJcz/b9M9bdfpq1ILFObNbE4+OHzrStb6zr9PTifiAlqFfj
	L4zDUZz9CAwKTv6rJpxO/00MV20P8zX8Q
X-Received: by 2002:a05:600c:198e:b0:493:bed6:85e6 with SMTP id 5b1f17b1804b1-493df0711f9mr63762635e9.15.1783432920461;
        Tue, 07 Jul 2026 07:02:00 -0700 (PDT)
X-Received: by 2002:a05:600c:198e:b0:493:bed6:85e6 with SMTP id 5b1f17b1804b1-493df0711f9mr63761815e9.15.1783432919826;
        Tue, 07 Jul 2026 07:01:59 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0f214d2sm33176455f8f.33.2026.07.07.07.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 07:01:59 -0700 (PDT)
Date: Tue, 7 Jul 2026 10:01:55 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Sourav Panda <souravpanda@google.com>, muchun.song@linux.dev,
	osalvador@suse.de, akpm@linux-foundation.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, mhklinux@outlook.com, fvdl@google.com,
	gthelen@google.com, mike.kravetz@oracle.com,
	pasha.tatashin@soleen.com, rientjes@google.com, riel@surriel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
Message-ID: <20260707095843-mutt-send-email-mst@kernel.org>
References: <20260707064235.1386552-1-souravpanda@google.com>
 <9624988a-366e-4884-9408-3f3b88c27290@kernel.org>
 <20260707062428-mutt-send-email-mst@kernel.org>
 <b9a48d89-74f1-43d4-b7bb-be988b6855c9@kernel.org>
 <akzZr2jfJ0J8zox4@lucifer>
MIME-Version: 1.0
In-Reply-To: <akzZr2jfJ0J8zox4@lucifer>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ra6UxLREpkxB7DLgS5RfavjMq9fMJE-wGtaT04sc-ak_1783432921
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AB1E040010
X-Stat-Signature: 6trmhs7uoyshwpxg88ar6mokus6zgfpz
X-Rspam-User: 
X-HE-Tag: 1783432923-589362
X-HE-Meta: U2FsdGVkX1+UuIm7E4x/Koj3STBWClao21BqcNzWolGV/ieEjEr8U2b2BT9aLD2LuluGjvqp8DpMkFLqPY7J1wvHhw1CK+aqy+/RGoTPB7/5BAQEvDcKEtzNG8OG83pH1o9drcSEwap9PSXoyGjrTpjy3+56W9aeDVTZ55Nx73qgvUlmoV6eAgGwIyXWK6KnWE0XgmrpjGac8p3OsCtbhOtUqFxGAZO/ZscBFUM70+bH0/QsZV2iZM4LrXodcP0jV/SP41D55F9prHoCSRgEybx/GZAHHDZVg9iN7iozDJn2H85RHF6wgNtz1jOZyli9YoVqA9e96vQJ3YKlu9POkoMQzJt2O2qzUrLB4nKIxWZYNVKeGVCuvBtDVK/Q6wZUvBjuFOt8/q6ZePGzPetQ+j/s6btmxL3qpqME4cd4Wu6jtg3EwHY6fnbzAZPPBMPGgyWbJ+sXQPsK/VSZNZjTZ2SqBSd4WhQiqkrtIUFEy9jn1TEkvsolv80shlMen1WSrfxsoaSlwwlkr6Bc74LFU58u71QwUbs5gBCEWU4rGqGkb2+zqMTqKtH2eeomdyls8veVCHqhwMKv2ERZ+uCPDegbtWI3a9Kfw+tpYu933ou9xczLpM/GpDqQj+ZuAmiBnp2eJClQ29eqd1qlHCqKsBBHNXbEtMATNG2XLF9JzaBbwRhFZgtvvyEN4kEs8A/GvcYwlb0ezJAuarkweFFgTq8T4kDUO5yLJvfF3O1Uf9b3VUy//JoWQ16j0lNS9EBeB9ikAgw2d36sGuqPiE9py6UPQnFqq+4/W7aQI/JMsZPRp+kVC3yTrvHcjaucQJWZOXaCks0kHxXuVLCxn4EMAJLLrjoCBQA6lcl9Aoe6woVZog6eJUxjSFvoDSxdKt1OVXaknzcUkj1fUc18fHrdM8TJHGnwC6UKH+jNRpgYFLvttrAQV7jBcggEqIQKxR/eUUnhPCnfiHRYbUaEdRR
 GSBq+ci5
 k237gscQv0HYFhZAoXTcIfzI+0YCuWkQA9LC1JTmc573jjqCXGGNrGO9H8kgjq7nrqI8gQJVNyIo4XFvhkVGNNUSwD5yphdFRaE4vEEwZiV+XEwVtqeAOMM6r+gBvtsqnLyco2dBA3O4nwkSWQbuoc/ZxJCVcSh51KcuoBfqWIJpYR0TeSlukEqADaEFpwISKZ4cSQgo7sCXVtRXdNp+Mthu77fWgY3TxxMuzte17MzlK+npE+D6QkNwxYBeqzuG8mLB1DT2HIL6KVyHHz0dsyJOfu8jFT45MSTf3mrN5l4lY/LNVvY+4lsgGusJ/k26nUAsPVdln9LVw+lLtEX56NdweJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 12:06:34PM +0100, Lorenzo Stoakes wrote:
> On Tue, Jul 07, 2026 at 12:28:44PM +0200, David Hildenbrand (Arm) wrote:
> > On 7/7/26 12:25, Michael S. Tsirkin wrote:
> > > On Tue, Jul 07, 2026 at 09:29:07AM +0200, David Hildenbrand (Arm) wrote:
> > >> On 7/7/26 08:42, Sourav Panda wrote:
> > >>> Overview
> > >>> This patch series introduces a dynamic, NUMA-aware HugePage Cache,
> > >>> backed by a kernel shrinker to safely return memory under pressure, and
> > >>> integrates it with Free Page Reporting (virtio-balloon) for HugeTLB,
> > >>> specifically targeting gigantic (1GB) hugepages. The goal is to solve
> > >>> the tradeoff between allocation latency and memory
> > >>> fungibility in virtualized and heterogeneous cloud environments.
> > >>
> > >> Hi,
> > >>
> > >> in general, we consider hugetlb nowadays to be mostly in feature freeze, as we
> > >> realized a while ago that adding more special casing on top of something too
> > >> special for all of MM is only going to hurt us more in the long run.
> > >>
> > >> We want to have less special casing and less special sauce, not more.
> > >>
> > >> Now, there is nothing wrong in making hugetlb be less special, by making it use
> > >> more of core infrastructure etc.
> > >>
> > >> But optimizing for surplus hugetlb pages by teaching hugetlb about new caches
> > >> and its custom free-page-reporting support rather looks like the wrong direction
> > >> for me?
> > >>
> > >> --
> > >> Cheers,
> > >>
> > >> David
> > >
> > >
> > > It is currently bypassing free-page-reporting completely.
> > > Making existing free lists not ignore free-page-reporting would
> > > maybe considered "making it be less special"?
> > >
> 
> You have this completely backwards.
> 
> You're advocating making hugetlb _more special_ by duplicating functionality that
> core mm already supports.
> 
> I mean:
> 
> mm/hugetlb.c                                 | 590 ++++++++++++++++++-
> 
> Tells the whole story right?
> 
> The whole issue with hugetlb is the very fact that it's a parallel
> implementation of a bunch of mm stuff in its own little world.
> 
> We make it less special by mm/hugetlb.c smaller and smaller and implementing
> what it does sanely elsewhere in _core mm_.
> 
> >
> > Depends. We don't really want an orthogonal implementation of something we have
> > in core-mm.
> 
> Yes, exactly.
> 
> Feature freeze means feature freeze, not 'feature that core mm doesn't support
> feature freeze'.
> 
> Hugetlb is a poster child for poor decision making in mm that has left us
> saddled with maintenance nightmares because we allowed 'just one more feature
> in' (TM) with little to no thought to the future.
> 
> And we've all learned from that and don't want to repeat these kinds of
> mistakes, nor make existing mistakes worse.
> 
> And work to improve hugetlbfs and make changes like the above are VERY welcome
> :)

Fair enough.

> Laying a foundation for hugetlbfs to be more of a sane mm citizen through rework
> series is really the asking price for stuff like this in my opinion.

Lorenzo, do you know *how* you want it reworked? Could you write it up
at a high level?
Because if not, it's not really practical to make it the asking price.


> >
> > --
> > Cheers,
> >
> > David
> 
> Thanks, Lorenzo


