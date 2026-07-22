Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C33C0C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 20:38:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9679C6B00AD; Wed, 22 Jul 2026 16:38:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93F866B00AE; Wed, 22 Jul 2026 16:38:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856C86B00AF; Wed, 22 Jul 2026 16:38:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 428716B00AD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:38:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 940AE1A02AA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:38:26 +0000 (UTC)
X-FDA: 85017575412.27.F7B71A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C2FD5140008
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:38:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1BPvpNW;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784752704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sv1yin451FNf9IBjRzFJe2OiUZg4U4oZrwcgx94tkak=;
	b=LokZ0HFDuwAIeLf61yG3/bw4BxGkS8oNT0xfzhzF8dbdP70uoMBh/i6jO34qk9VOOlY9UI
	uGkTxKvPSFoa3bpNROXZt96OA0ii0vuA4Ewrqo162a5T1qmLKkeU49L4tDZ4Wc1VcgKMYg
	9/sUTZVHCzEyrOzVMtVNBf3VPgRTIYo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784752704;
	b=kBWNd1S/F2tJEWaxJLhdko7emErSriJClJpafyAtsRfI9WoyMU2fhz/Wc9eyGVdHxVVXTx
	2VsLV9m2u4MlOg04x5tMbOW3ZqHC9PDUbAJMgNknMds7o+u/cGoNFMC9/LbzfqhF1TNJ1C
	XWpahdhztHY0AF8FLaOPsrYegN1joSQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1BPvpNW;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 19596600AB
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F041F00ACF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784752703;
	bh=Sv1yin451FNf9IBjRzFJe2OiUZg4U4oZrwcgx94tkak=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X1BPvpNWr7GEwW43TDS8VWCrIpskjHDIP2lT+X8LXuU6TwRlX9GTXQRXAjV//ySlM
	 P5Lu7sD/gF+JeXFlOae/XeqcfP+gjOt8pq0x//nOHWZjnDJenxl7tLLEnugrPbNfBl
	 B6V5IIzeTbFrjtrRf0vJYbNAoSa2ncA08zERRcd9IuaQsFSLa/QKr2O4wFMydSIco4
	 8IC/KliAwPwYhCm88pXIc2occfPnzq0GmnPd+jPxa9QoxhM0T3oOcMXzxu6VqwKpdG
	 jTyliNPWujiZNFaIo4q41fXhukRwIYSkKHfY3YKuqbbBlcWlqHnxzS2P9uHSa1UxnS
	 plSglyu7GoDoQ==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c169ae1cb26so1150759466b.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:38:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqhar/e1bHb2Tj3ofyuLz02UohW16olTGQH1tSv0WpG8yIirLUGA82ky2uMJTnDNJxIh6r/hd4NNw==@kvack.org
X-Gm-Message-State: AOJu0Yw5O6CzDPSDmYwseGzr9RkRqcVDswE8jO22Gu6OfWkES3+oDgd8
	rx+/ySTRvvHipx2XAnFurTCf73w1U8ClL1x4WEMMDQTA3Vwlh9Op6RIq2NGPHpHBPRQOMa1hfS0
	GOrin4nhXX/i1HW+I1RXVrRkjVZwNVOQ=
X-Received: by 2002:a17:907:1c26:b0:c16:242a:4744 with SMTP id
 a640c23a62f3a-c1c30e5a414mr272454266b.17.1784752702639; Wed, 22 Jul 2026
 13:38:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bG6ddP6-dgXpGBRGnCH49oTMPwkJmF--+gefmy+zBo-w@mail.gmail.com>
 <oocwnxqgd4klrem6hkya3sddqoxkosml4ysz23if4j7wj2qdwi@5skgc4ftu7io>
 <CAJnrk1ZU40tRDq0z3yM0+yv=KhiZ-fNjUTO=ccv1tuc0xDx2Vg@mail.gmail.com>
 <4fsrafuhoqgoirlt2sy6vk2ljvb3tdps4hqbcrm5qc2pr6tlaf@tboejm2wdq2s>
 <CAJnrk1b65ypz4bdtd1rTQBYOpOEP+DcoZJUSL87jVDssW1A+pw@mail.gmail.com>
 <nv2h2dd2xoj4zjfvnhsxud2p5e2uw3og22ovqureik4pey72qb@i75tn5ttavfo>
 <ue5xd6f4nfggwodfhbqaispmr5aq2dyszezvy26bl4rtsk6xii@uceqazdioj3o>
 <CAJnrk1bwabyWY+rzzSKfKWp3rivcQm=zae3xzNSZc2hnLj6-Aw@mail.gmail.com>
 <aljxUvui60dm3yvj@linux.dev> <CAJnrk1aTx44=jy0ODHY2sHh16bKsYkwBKj_O-MsnZYjXGW2cCA@mail.gmail.com>
 <alpfQxaYs5hQ0BaU@google.com>
In-Reply-To: <alpfQxaYs5hQ0BaU@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 22 Jul 2026 13:38:10 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMwp-wxJz6AjBSEuW+vn-7ff2VwAdHpVHFAqy0skgD2OA@mail.gmail.com>
X-Gm-Features: AUfX_mzbIxhaji4ACa_s6MziyJYJfdhM5If0Ugu2QBVMrEAPT0o4Q-nTgVPbFwM
Message-ID: <CAO9r8zMwp-wxJz6AjBSEuW+vn-7ff2VwAdHpVHFAqy0skgD2OA@mail.gmail.com>
Subject: Re: [PATCH] fuse: disable default bdi strictlimiting
To: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C2FD5140008
X-Stat-Signature: wkgz8q4smtsytro1wwbh8wj1jgyphqzj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784752704-979477
X-HE-Meta: U2FsdGVkX1/FcEKs3Yk2RJQ8GZnwbBYl9C0kzDNtiGWQSVaV9ZGN0zhFjQaWwm3QsiLEhdu25O7tm3ea8dk849+oRQCsovpwc1a9sFCBEvuqrmm+rG7EQGMzf1KFgQeiLO3g3UxNXrK/XoOQ3tEmPT49AeV7FRtjtQzRxaOgHjKRt5o51pQduz3ZOQDSAAmYtsXkXJROB74QYtknJeZKylcNFncaZAH1KYAdrpBjME4Nj1EF7AhVZ4bcAojdWTSz2qO4IVKEU2R97ggnZaj+Bam86G3KBvKmXfYMAfSCz0f+FSrWFp8thNsrpjT6JrfEuZkqifZVkpXfB2Poa+POt4CKDSNTOiDQG+pEG/c62d209BQsaauH0HeVDethyPD4qSnetX7f+NJM5saj4wwExE7NtjipBZEpLmF5lckoJwXKiOuaT16nAp058jFwPXqf+Ksbj1GujmJYV06niw0VcpbAl1VZBF7gPvXACV/HIoRffcrwY5rINwQmfx/KvVHyN1hWioeISeerx8VeIZHchPIlTUtNyo2MvRLR28nCzvwluWjodU2FKiFImZ3t8UL6qXCurzSDRx9HIYzEwoMgXCaBR28vPSV06tELVnMtnjTmJ+x7e8SmS4eUaBbyiAYQTCvaI5pcSeWes2l8d1FuilJvwtEMgfC9XiwA85Y1ilouTKbfR4QvMDLIasgSzJXDIQGgC7a1zAntNfjIktO1mVdPYmVATyNXvYcHIwyQfXzPt0gnZ5QloN1n32Pp9QXqj0nRQ0l3L+YkAEC8fTFkQimtcTKbVud4REtoQAlgq6WADgAc4OQw5deUCEpg4ZgriKte2OXKPcowBkcldeUoKOpedfCvEyAC2u4ZrvPLpz1dXVu9wtgU9iCOve57GsGOkxbrUcvWmPNUmv7yUsZuXjGJTAqZQFz0TM4/1OVMa1izVVR4Yy3dkN5DPvfgxRX3ysTtvklufArSH3+siOF
 TVDr8SJU
 seapEYlSReSN+bxVOeaW2YnGuQ5t1O8UI3kqo/Bfw9zEuhRUWPPD0+QQKZT87GG6vMSTNHUrqsOKhAxt1lQiA555OxRV/7VqkIcKsPpl80g1sTeHz9HluDD+MqmrHe9//+OmqDhr9vNjQutSMiB+w00g1s3A85T6IyraVqll2fxeiwDxT1wejVwgvMqAj4dMCqm1RYUNvYE1UR4cbG1CA7wdcOI3BO6p9fYJlZSDpwNQ7mNyIhR3YDpEcZsuSPL8QEVxJT2tK/2k0vegPUYuRdc3PU3onVQxrzu9+1J5trCGsmhvwJMUbbXnli2/aFJZT7H/zXO1cWxRocwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > First let's see if the general solution is doable and simple otherwise we can
> > > explore use-case specific solutions. In extreme case revert is an options as
> > > well but I would prefer a more sophisticated ratelimiting (that Jan suggested)
> > > than a revert.
> > >
> >
> > Sounds good. I'll keep an eye out for the work Yosry's doing on this
> > and look into hooking it up to writeback if/when his general solution
> > becomes available.
>
> I am not sure if I had in mind would generalize well. For zswap, I was
> just going to replace rstat with per-memcg atomic counters, and simply
> walk the cgroup parents in the update path, as the zswap load/store path
> shouldn't be too hot.
>
> However, looking at other in-kernel flushers (including
> mem_cgroup_wb_stats()), I see they consume other stats like
> NR_INACTIVE_FILE/NR_ACTIVE_FILE, which are updated in the page
> allocation path. I am not sure if a cgroup parent walk with atomic
> updates would fly there.
>
> A more problematic one is count_shadow_nodes(), which consumes slab
> object stats. I think we definitely cannot do atomic updates in the slab
> allocation path. Although it seems like count_shadow_nodes() is a rough
> estimate and perhaps we can forgoe using the stats there.
>
> If we want a generic solution for in-kernel flushers to improve stats
> accuracy without killing performance, I think we need a heavier lift to
> rework rstat or move away from it completely.

(Adding a few more people and mailing lists)

So I experimented with a per-memcg atomics in zswap (see [1] for
context), and it appears to be too expensive even for updating the
zswap stats during reclaim / swap faults. So I think zswap will need a
similar approach to writeback and other in-kernel users.

One idea is to keep per-CPU per-cgroup counters, but on the update
side we update all the parents' counters, instead of just updating the
current cgroup's counters. Flushing the stats then only needs to
iterate the per-CPU counters and doesn't need to walk the cgroup tree
at all. There is added work on the update side, but hopefully it's
cheap enough to update per-CPU counters, and cgroup hierarchies aren't
usually too deep.

A more radical approach is to completely drop the per-CPU rstat trees.
So instead of walking the parents to add them to the per-CPU tree, we
just walk the parents and directly update the stat. The flush side
will then always iterate the per-CPU counters to accumulate them. With
this approach, the update cost roughly remains the same, but the flush
cost changes. Instead of walking the trees and flushing all cgroups,
but only doing it on CPUs/cgroups that actually have updates, we
always iterate and sum the per-CPU counters. The average flush cost
may become more expensive, but it should be more consistent and won't
scale with the cgroup tree size. I am not sure if this would be a net
win or not.

We can also choose to do the above for all the stats or only the ones
used by in-kernel flushers, the latter would probably perform better
but at the cost of more complexity.

I honestly don't have any time to pursue any of these approaches, so
this is mostly just a brain dump. But I do think we should try to more
systematically solve the stats flushing problem as it has given us a
lot of pain over the years.

[1]https://lore.kernel.org/linux-mm/CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com/

