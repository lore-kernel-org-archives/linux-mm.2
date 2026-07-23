Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A971C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88BD66B0088; Thu, 23 Jul 2026 13:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D226B0095; Thu, 23 Jul 2026 13:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E056B0096; Thu, 23 Jul 2026 13:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46C276B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:11:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 35770A1243
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:11:45 +0000 (UTC)
X-FDA: 85020683370.17.C0B449D
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1FB101C0009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:11:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HVvGDiIm;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784826703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKoEFKHAauD9ChUUVwq+5WmbWXEzRCLgc2RAxWNhYLo=;
	b=wNE1d83UqFzFn8m8ikG6HH+PtAIuHgT+yLxsbZ71DeeLYlMX7acqYI2OJFTlAbuJ5UKrdp
	hzc9Icx7SI9bCmSJ0B+Rr+R0giNtF2J2WZNuVU5OklOdlaSIqSC1wQlaCKdR+J/T+jq7u3
	W5u8WXk/GN5/gyDQ6Lhttn5JLZkSeqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784826703;
	b=zXhRPQrtvmpFyuzddKPaHUG0/klV6ZSS5pGXmjzADtACvTgzMNUay7lZ+hgGleokNB+MXU
	BLupehgMZwMXhEUxdTBKvvaLZqt3UkDimsxAnPUi6fxaAH0rsGhRNY4C+C/iKVa1G/vFpk
	Z6RichKC1w8ItUBWdf6OMDZhMZEeIcs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HVvGDiIm;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92ea24a2dbfso84892985a.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784826702; x=1785431502; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oKoEFKHAauD9ChUUVwq+5WmbWXEzRCLgc2RAxWNhYLo=;
        b=HVvGDiImweT0dOoD2G00mWuK4EKAQtRqnLI9xXJH4s+NgIhN74l7KZdAOftYSv8asK
         RKah6TIRBWj3CTmitkN/CcNMJoq4hXK4niXs629LofNam8HzD0QCzd5GNVfYsIMv0HWy
         sQJ6MXtuITxymC04bbHFKBrmKwOsrDPPkiAcRdfIoGNwF3eVypzpZJkHBfeB78cW0Zyn
         JGDtOzgPPpPeaD99pJ0Hmux1HWi5Up+X2rYlQne65NY5hs3sNWj6cSufw5WLXABb9raT
         PNXfAmgn0apGeJcCffyfPQ9WeukYnbsVRqGOJiaClOBbY+MhuITDjV71D5a4GfNzbbT3
         umtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784826702; x=1785431502;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oKoEFKHAauD9ChUUVwq+5WmbWXEzRCLgc2RAxWNhYLo=;
        b=PW26c/dcQKSnBpveQi2cxCjxsVXppQIVfVbQ9k8D39Vwg1UzCIrRpsvyYrHljpZS5E
         6Jlw9WqJIwLtQlC/xIwik7yxZtPzBipuoM4b4epBz45u4FbV4OGGm2UUz62Dwhr1R/oD
         dbhTvOlVqpSfpWwEn01BJh8Y1ejqgkSkWIwEedxNq5AP6tUlVxRsD0pU+8bEjtTrlnPG
         SHN6QGLjXyDDkH8c5TnLQPSWSZsCI69IlGn9FE5R8tNwXcykDLA6vEQyYCapuhwtGKHu
         6SJosxpteXXzwr/8CeOpC7WC+oGnd4cIo5jDJ/1l8CaBzNzks2bQIo8DKfCGOhxN3C1g
         wafA==
X-Forwarded-Encrypted: i=1; AHgh+RrnjsOC6qcj7CzEqh3iGrdoDcuJDo7tBCQgblpfYkEaMJW9htCTihm4cghev0Qh8ae0c96zBU1nHw==@kvack.org
X-Gm-Message-State: AOJu0Yx1STIiiZotYbRXSlPg64tzXAkAj6wLgIkVFPc7hwyaV87nzEDd
	N5Tf5ilsD1ykhu2og6NidNpqnGhQVPRqfrouqSBznjSPN2yAoluPoJ+R3+azPuoNVZg=
X-Gm-Gg: AR+sD10p6z6zEirXKutP0ZruFcEYGnQaC5fz6jMRNuknbocdkyU1l1W1C96EH/kVxT4
	9ukh09xvuD3QaPEAOXOMW0BStCWUhSR8C/GqZO+Mk3pTpYKxkXJMtOC+rIwQoQf8yLeXdj3yLbj
	herVNSHSr42UaWoowZsBC6V7ZipTGQFeaUL6GOY9t1fQjBgH0W6+crP+SHfdtlTQ8aSc9lPflqV
	UDRYzbHG6spZKBPFanRnmX8Ofz/DO8J+ET7EOH/aL7LzhCfSrXWyRoVYwLh9WPPVtIBDhawskTj
	Zwc66X3x4netVBr7kEkwjF9pJzo91DNa0AH/43dA29YgjphfpNlodqInFXkyfggWpaE0CLsaUI/
	sZ/f0w5hIN+RpOSXavWjpIgxw5k0c2zHILRPlcjQp6b6rOZTgHA8wRegbHOhu6O3833J6RUtxj1
	sO
X-Received: by 2002:a05:620a:1728:b0:92e:f3ca:2eaf with SMTP id af79cd13be357-93103907cd9mr404452485a.11.1784826702204;
        Thu, 23 Jul 2026 10:11:42 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f68743c8sm466141585a.7.2026.07.23.10.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:11:41 -0700 (PDT)
Date: Thu, 23 Jul 2026 13:11:40 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org,
	tj@kernel.org, shakeel.butt@linux.dev, mhocko@kernel.org,
	mkoutny@suse.com, nphamcs@gmail.com, chengming.zhou@linux.dev,
	muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in
 shrink_memcg()
Message-ID: <amJLTLQ5A9EDWcxF@cmpxchg.org>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com>
 <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
 <amIdU1lFxqxTI3Gc@cmpxchg.org>
 <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
X-Stat-Signature: iceqknj59zfbxh8p36wbt1enefpqtbwg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1FB101C0009
X-HE-Tag: 1784826702-501745
X-HE-Meta: U2FsdGVkX19LD7qUogOPEY03pojrnCjoABoBwYh8TCEbby8NlbYBCPz6F7zVNmlRLivw6LOF0q3reXu2V2KdWmwHc63loKoFU43BsRW+2rAqa173BjAERJRIOjLF0ffKwGMuZAWe+eA9F6/I9u/UiqViJyHLBQS9o/5AFjGUtVCJNROzXw1ldy5JQyJBN0bQ9wKvsnvm2cedKyv2K9ZayVFT5pQgsVa8Nw4ncyA1iUu6Aje80cOr2M2Xb3xhmVm/Z+tPB/PCTDVsZjwuJCnEIGtcGlxrGfeITOZxT7cMzvMfRawoOH+IwM0ZTyTMa0djBC+rxnUjAQsXKRQ65VMOn8YaCHz/f1nSGgr3HWfdJsDQUE6sHujsziU4XmI0HQq+PyzPedQAOaKt9WRnDB3tcJzgRLupIZ94Xy6dDbg5HSzSAmgTpzoqg5qQEOoHb69PNBF/mqCNvOGWJKVmYadkyOxsp39N4oWFUKJl2kBWrVQGXFKtOqhgY253QKfrqOToMbyOdYsYlk9ffpUwfoRmcNP4KKJdeuiB7DxPbeVXXcruDPMRScojQvtsAy+nSSKF9DzIhoINkgIlkSSO7b7UVRSQE+DQ3uBeiQawwN3z/4XUCV/+faTnxFMobYYxuvEktp4C66f3xezl2mOiyH3049PTXI/BwNXREEOk7kEy46H3WXGICarkjvaAlLyjm0hL9jKzgl1LDeIs3AVojuloeb8EGAERpsDp6uzgMTCgH6iX/MDV9H8/eN4h4SwoswRBHf3U5bENe6IMG4O2rsCgkqv5XMh3OMxJopEqpPBhjfcBZTkiiyAXliY3wIG+nMbQIWWiI7IcsD05puCUWSgIu+vy13zR88/0KoEoG6MruA3WEBlk+dqpbXmIfdfMZeyysG/tfWA8WcXHGD1/XzuGanHV0XpJrXorkPFP9R0T2lLeiUay3M+Dt/tyCeysqxlh3d+KbXiylMwZosy+l9v
 2HgUhwvV
 5BazgLFX4tME8Q13QERcGmMNumAKWKKDsP/c/X1c8oa7+KUO9e946s4evLe+fsX1sYFZcOkgqxxODv+nXhYVd58NyfSnMeh9GTGYMMAbXaLQe6ENwSyrHSmLtHgBBYF+OJpbl07Kj+k600Vh1OoNRTKOYr71Zt+8joQTu6PKZhCroeH8gWxlsppcOcCsvkCK0nBw2VAFyHEixwv1qZu3WA9DXQQ60y/q9kEvNgDa/IeFoo/gJkZuCNMHbNa7BZ5EzvO8JjwEWT326fnLQlndXlUBjeJ5nEqi5al+RysKd6/UY9MjdGBFBxvkBU9T3BN7xpFxi2V9FR40XzEBzOGPT1a22AiGBXAnZv8Kc7TH1XFwznEQsnpVyPbpO1qf/A+X6SmqN0U/a440yCdeFmv3NXTFtAWU/uWYpMO4sAxhcnkJnYslfp4LLYZOpsxtLR5748x73m8Ic7vYKUt2P7fQwP3PJSB/9pb/3zlEot8pblSTA8yilupC+YFRWgsMtnDXasHWcvQPqnHnUiE2qgNoFcJf7qtBpCZKZtjL+zRT1PbA6Q2mFQyrVgmGGiy6oxf1PZWHIyV+wUL60ApE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 09:39:35AM -0700, Yosry Ahmed wrote:
> On Thu, Jul 23, 2026 at 6:55 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Wed, Jul 22, 2026 at 09:52:18PM -0700, Yosry Ahmed wrote:
> > > On Wed, Jul 22, 2026 at 7:27 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > >
> > > > On Fri, Jul 17, 2026 at 04:51:51PM +0800, Hao Jia wrote:
> > > > > @@ -1369,7 +1402,7 @@ static void shrink_worker(struct work_struct *w)
> > > > >                       goto resched;
> > > > >               }
> > > > >
> > > > > -             ret = shrink_memcg(memcg);
> > > > > +             ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
> > > > >               /* drop the extra reference */
> > > > >               mem_cgroup_put(memcg);
> > > > >
> > > > > @@ -1493,7 +1526,7 @@ bool zswap_store(struct folio *folio)
> > > > >       objcg = get_obj_cgroup_from_folio(folio);
> > > > >       if (objcg && !obj_cgroup_may_zswap(objcg)) {
> > > > >               memcg = get_mem_cgroup_from_objcg(objcg);
> > > > > -             if (shrink_memcg(memcg)) {
> > > > > +             if (shrink_memcg(memcg, 1)) {
> > > >
> > > > Why 64 for the global limit but only 1 for the cgroup limit? That
> > > > seems arbitrary in multiple ways.
> > >
> > > I suggested that we keep the writeback here without batching and do
> > > that change separately, mainly out of abundance of caution as
> > > writeback is done synchronously here so the extra latency could be
> > > problematic. I think we probably want to measure the performance
> > > impact of that separately.
> > >
> > > That being said, this path is potentially too expensive anyway due to
> > > the flush, but I would rather we do some basic measurements before
> > > batching here.
> > >
> > > What do you think?
> >
> > It's not an unknown, right? We know this works for direct reclaimers,
> > cgroup limit reclaim e.g., and what the latency implications are.
> >
> > Because of how reclaim works, we also know it'll call zswap_store() in
> > batches of SWAP_CLUSTER_MAX. If we don't batch here, they're likely to
> > each call shrink_memcg() once we're at the limit - while still risking
> > rejections due to compressibility differences.
> >
> > My worry is that if we start with an inconsistency, we'll be stuck
> > with it for a long time.
> >
> > I'd rather start with the clean, consistent version. Dial it back only
> > if we have data to justfiy the complication that we can put into a
> > comment and the changelog that outlines why exactly it's different.
> 
> I am fine with doing that and basically always using NR_ZSWAP_WB_BATCH
> as the batch size in shrink_memcg(), but I would be more comfortable
> if we did some sanity testing.
> 
> Hao, would you be able to do some smoke testing with NR_ZSWAP_WB_BATCH
> used for all paths, and memory.zswap.max set in a way that induces
> writeback? You can probably set memory.zswap.max to 1% of total memory
> instead of the global pool limit and rerun the same test.

Please just use SWAP_CLUSTER_MAX. That's what the reclaim side which
issues the stores is also using for batching.

