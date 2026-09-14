Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEC30C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0FDE6B009F; Mon, 14 Sep 2026 11:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1166B00A0; Mon, 14 Sep 2026 11:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0076B00A1; Mon, 14 Sep 2026 11:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1FF6B009F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:00:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D4B2C0199
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:00:46 +0000 (UTC)
X-FDA: 85212679692.22.D38FC2C
Received: from mta0.migadu.com (out-78.mta0.migadu.com [91.218.175.78])
	by imf09.hostedemail.com (Postfix) with ESMTP id E4855140008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:00:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lMeKd2OP;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.78 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h22P0SBKT6gVWYzDwyJpjZUoC9CyJilYNOdrmbbRphg=;
	b=FAmkZyH5sWsEtdIsPYeYEF9wy7HkaM8ncrIP1dGr7+UiTnEtXRjhlbJyB0moN1HwmAwUOx
	DR0poZhU78dUFk0L/P1a/xjajAJ8PFs6ys0ikGeBD3x7hzkLzht1shuaTjqpHs9y0f7hjC
	ultXsyAw9z584mSCiL6eT07mzcmhvhU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398044;
	b=1JeeOLJ4BBBoxvsxhVGY5UUaDjrBVlGaHfmEVaNz1Pw503rVv+3NV5c042PYGog5bwtL4H
	AAPFgSI2vfZ7opPtV+lBlv2p41g0/StFFjmZ4qwAesDXoTm+gua7wsevLSgHq4jagpxDUD
	qRHvryatxZGKlJrYUcpOZ86R0quyFRA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lMeKd2OP;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.78 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hwtaTLMA1sYqRp29cSIfiy68ZXQatt6fyt/Ot6ycecQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789398042; v=1; x=1790002842;
 b=lMeKd2OPeWI5xdKjNJhCkAzknfMSH3RcFG8v98Xjq6Jbnhz7ZldVTq96SOQRXtR08hV7RCoH
 cPRdDhiiI27IBrsHJWsgKDzE9eTSoIy4NkKO9nxRG8GALCPQjSg3Fj9QUJow8DlmfbXfncTvmeq
 7Rqo7LO/JVX98DBt9SGf8Adc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 24f60d578e23c651;
	Mon, 14 Sep 2026 15:00:27 +0000
X-Mizu-Trace-ID: 24f60d578e23c651
X-Migadu-Flow: FLOW_OUT
Date: Mon, 14 Sep 2026 23:00:24 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Kairui Song <ryncsn@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <aqgMCIOFi0dKx_6L@fedora>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
X-Stat-Signature: aj1y1rjrh5h6eeqwhsoypui18n58htdj
X-Rspam-User: 
X-Rspamd-Queue-Id: E4855140008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789398043-778019
X-HE-Meta: U2FsdGVkX196lxggT9S1cLa8OgfqiYgv/v9rQbmeA7F6QYc0QU1ZsXThsabBl6eb2AXdI0/whgo70yIYa17VIyXRHeft8/++ZebuOU1YKOsxqtuRzQeXMBu7BihiSK6eNFOTcAt2rGBOzy/7LQcHnZg/w1u3/XIwJRvG8JWK4RHZ91VQRjZ0b1L7zE7Xv2QPRjwJNzuMyoCP3N+UdR5WTECXQXlu9e7TDboXh9RAVXl9+XxmYBKmuSIU9zbvse+v0Ius7BB3z9neOEPCf0tVjyUbSshqczv+AYZdZlEMEK2Au4BrioumBVL9eDS9cvessMsYfW25W71Gb0GOMQcfGBxgqrTwH5TUHQ09pKx2mJ+xx6iRNY6l2dV5eJoibxQhcHzUQomJ5Zp4WfikI/bHLw024JNGtjOnSTCXmEfXd9jOcuEY2cbd2CgYv0WbOCWsKKBFS5PCagCtgOlPFrekuXbYijUu5v38ZgRqoWgyenRP6emx+IViBlU76PYHorCK5w4/RxkyGR3yN5bi23oRohCVtdnF3/s6ypsSZAYUfwi6x6Tjjej6hE2VoGFG/QfK/5FBn7LDW15o/YuSkDS37MivGoY+cHdonTvLVdzD30ybzT8B9uEm3R0lLXY1dcTgyaoVYidVUpsIgwrgFmczuijSbYIjSn5s6vCIy8Q5oiQBfxYgqC6zLkgtH6Ju4+0dqJXsJofiZ6YkX689FBIoN1Oj52T3Bb1ICe+bU0aaJwCqbbclWQAueYdBhDq3Ix+DEHFpQu7sxyYkOPi38kp8VQ34eF2FlrQEBkOdFFjRt4Xqp3NAu6QTNuQo7Jhf7LW+c7Lsycx+btskyX4OU5L0XjHkKjtML8g/jZVWvWnJdWNxKJ+SRdZE6CpSmExff6xp/Ql1lgmlFIzwR4LD41CpsVa2KKo2Xy8V/Nj7bQh4rTaGTyM4t1d85ChaNKvx/9bB9KKdxVN08twNsgV9Ww4
 SZvWKIWv
 lhntoZ8Gs3AO3IqwT9/Hi+A4c3ckSUb8pIfYUuhijlsvidATXy/g+0FlOdcyDATl+327uHLevrb34aGmHKIoGPMCCC8SNRSWv6M81NT/PfnLeLkYofk6tJJruZnhFHs6MS6SJE2A8NNSzMngKsIXlWxcSEiV1Ui4w50LBVmx2WKAx0+uyhjJkIEQJ72o/wn8Jl29YCNbBjfwKwlEqeVypYFxrS9gCHihqOCgRxrGMpJraYYhN33K5UWGvBSC8XGcN9Dof91qEgVneZ5GIB1D0FsGTYPKdVlgXJyxjSs5XCafF953sKNnugNjTJvx07zKn3m3/Q7udsNdbc2Dqm4xKlynB75OstbZIJS/kgeCZYfKaRqfWDbqyOevTxuU6n3R8Vho9HqmF5T0tkgOIpeMmFkWK8SKlq3zrwepEjtiCqiMQLuUYCBCacioQXZhXOpZhWvUSppx+SWtrxwGKhyli3eW0kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/12/26 at 12:20am, Kairui Song wrote:
> On Fri, Sep 11, 2026 at 12:23 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Thu, Sep 10, 2026 at 3:57 AM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 9/8/26 18:45, Nhat Pham wrote:
> > > > On Mon, Sep 7, 2026 at 4:30 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
> > > >>
> > > >> On 9/4/26 23:14, Nhat Pham wrote:
> > > >>
> > > >> Hi,
> > > >>
> > > >>> To Kairui, Johannes, Yosry, Chris, David, Andrew, and other (z)swap folks -
> > > >>> I need some help here.
> > > >>
> > > >> I'll mostly ignore swap-related stuff because (a) -EBUSY and (b) we have quite
> > > >> some swap experts around :)
> > > >>
> > > >> Reading below, I do wonder if the swap subsystem needs some more coordination
> > > >> and collaboration?
> > > >>
> > > >> For example, maybe having bi-weekly/monthly meetings to get everybody aligned
> > > >> and uptodate could be something reasonable?
> > > >>
> > > >> This approach has proven fairly helpful in areas where (1) multiple companies
> > > >> are involved (2) many concurrent development is happening, and (3) people have
> > > >> different priorities and requirements.
> > > >>
> > > >> Is there already something like that to organize development? Should we get
> > > >> started with that?
> > > >
> > > > Hi David!
> > >
> > > Hi!
> > >
> > > >
> > > > Thank you for your suggestions :) More collaboration and communication
> > > > is definitely needed here. Conference is a good place for this, but
> > > > it's not something we can do very frequently, and many folks could not
> > > > attend (visa issues, etc.).
> > >
> > > Right, and conferences usually don't have the capacity to squeeze too many
> > > swap-related topics in, so it would have to be side discussions or BOFs.
> > >
> > > >
> > > > A bi-weekly/monthly series of meetings sound very appealing. Swap
> > > > contributors are very spread out (China, NorAm, Europe, etc.), so
> > > > coordination will be tricky, but let us figure out something.
> > >
> > > Yes, that's an issue. I'd suggest swap maintainers take care of that if they
> > > agree. I could try as well, but it's rather tricky right now on my end ...
> > >
> > > As an alternative, we could also use on/two/ ... slots in the bi-weekly MM
> > > alignment session to talk about swap. (I'd be happy to learn more about all this
> > > as well)
> >
> > That's awesome! Thanks for the offer David - I think MM alignment is at 9AM
> > PDT Wednesday, usually right? That works for me of course, but Baoquan
> > and Kairui (and other swap folks) - would this time be convenient for
> > you?
> >
> 
> Thanks for setting this up!
> 
> Is 9AM PDT fixed, or can it be adjusted? 9AM PDT is midnight for the
> UTC+8 folks.
> 
> The time is still fine for me, though, I tend to stay up quite late
> anyway ;) so that time works fine on my end if the slot is fixed.
> 
> Is there a calendar invite or something, please send me one, I'm happy
> to do a swap sync discussion there.

Thanks for opening this up for discussion. While the time slot is a
little late for me, I am not very sure if I can attend, will see.


