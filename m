Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E43FC61DB9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 03:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 999886B0088; Fri, 28 Aug 2026 23:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 970A66B008A; Fri, 28 Aug 2026 23:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ADE16B008C; Fri, 28 Aug 2026 23:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 694E96B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:13:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AED49A0633
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:13:46 +0000 (UTC)
X-FDA: 85152837252.09.9C52742
Received: from mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
	by imf26.hostedemail.com (Postfix) with ESMTP id 91E6114000A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:13:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aZLBTCbX;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787973225;
	b=JboB9K88RXVCQ1H1XGJ5YaC9gcXLKOeAceEUTiGM4B890utSr+Qe00465nq583VTPz9W2r
	41Hs7eFIc74zFzA+r0SkeaeEgs2LeQ3XyJmKn0XXipU9tMk3w9OVL7OeFOB9K5KlvQNhsd
	0sGHC1h3jB4/TBcK0ptY31PoHmleK/0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aZLBTCbX;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787973225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DoQD6oguAa6ymBsE5ImO0ic7DjSp+D/jdoD8TRAfxNc=;
	b=r6nm5w9hudOJ/Fc4N9zpKfO0kLKBLnegwi/G3qcWcJeSrIgEm8ntq4537TikSSPa59/78r
	FJ9FNdNYtF4xml6IFXhRoW3pZCFiNmg7oNKMQ9iVR/e2B2bHh1swMYwAtBlXApgHampqz+
	uxsmrA4QQ1IIyvDOE3rd5r3IgmA5iaQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cDW6ej3nsOtAs9UhYM6om1L/1lvDe6jcM4V1q9Oa8bw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787973223; v=1; x=1788578023;
 b=aZLBTCbXkU7d/zoBiSkVOZ78BoDyWbRzDyQh1tkWdy4wjUXmdrdbiy2oZ/wr3B6PZg2VgGon
 W9cXn+PfriyEh2EkV4myEHx0XS9mc7u+7hz2s/AYLpqomFxJU218OHYdfpItrPR3ztXMht0Vgom
 d6AlUFpCOevcXhCKxZEhiuRY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6e5a30d5d232ca82;
	Sat, 29 Aug 2026 03:13:32 +0000
X-Mizu-Trace-ID: 6e5a30d5d232ca82
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 20:13:31 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.4 0/9] memcg: remove the v1 soft limit
Message-ID: <apJOJ2PWwmo7KMYW@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <apJCb-8RK0azF8_h@linux.dev>
 <20260828194322.0556dcbd1c261c23a1f6efec@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828194322.0556dcbd1c261c23a1f6efec@linux-foundation.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 91E6114000A
X-Stat-Signature: nz77yi7u6kc3kma7u9gj9kchwbwqwx84
X-Rspam-User: 
X-HE-Tag: 1787973224-771017
X-HE-Meta: U2FsdGVkX1/wLrpQdpH87lVBRubRDg4b8p3IENi6RqfTalQzYnqlvH6DZGfSg7kvdl/n1fpabWTfi/8VDIqQr1Evg8saviJQCeUXTKm5RKZjUa5EYXt+YyyNG2Lv3/I7/vEllIqTcz8cxL+cSWdLwpq5TWO4JxyIaNFa2GLpW7gAntzdn39ReOYchHzRncQumlwXryKp92MKn7YRa0hIFLeAbu2L+LGD66M6nUStULE++6yeSPNGiSBDiFUQrJnfnTpKcN8hDYxDUBTXVz3tg7MvAtIqjvGyEr/XbD8JmSUSgo807LNGtRT13QLRTUNz3TWEDtkHORwCk3qI9N04ldWiwmfi/p6D0EXDoIAdOAlYh6bmPaeO27++WLbcFfI8V3ReyFaq2dMep1JTF8X5SzldMYd+a2P9eWYgMU66DYmPBHILASszg4S5dNkOvSefGBEwTp43/g2XV1Z/ijLMFxn2wfp8KOb7jyUxGAS7PTZVgVu035u+P3oHIdm/YuEmsToOtInsAGrKbE+1P9OC1aL9ctVbn4kFybCGUwEzPWEt5V90UCveC+7yVKdMykZB0nwgLalKBy9bdyKM1xfhP4y/ZGVF0Yj6mUJl/1O9kE1xvp3hJrdzevPJh5LV+oqYdYoFEVeotdrlmoKcJGP91Nul5rvAa01c9E8ftDMkPp7Lt9fuISrb95clKB6cyi2fv3jpBVxDGO4LJJnaww9SORlB/XsV37xpYBAW6NBSoO5bX3dGutjKIjMwN6ywPLf4Y3IwmAEQWGeFlPEssYEyZhq4ewsD7BhDx8xBL7K180LkNbG8z35RHl+qu1e/akBqE2qpvGovrZ575C3EkhhXH5KAK1/kzOX1eSiKpbPACJks6HRSqA0p+gg4y0DnrW/aeeaNHES+B8Q/0vIDNGrmifFsX6jhbzDMMfuHtIKsyUkmZnTNLVwgTvnrvxgeUxZ2nRbzywr/rjkLmZ8TDz1
 d65XdO5f
 EFXzB8Yze6XIy/DCh/KKohIrLQcMvb2HSQjoM2u399YJgtA53yI0W7aGF/kTXlZjGBsJpXXEMZTmS5soEVYB4piaUiU50TSD2ZkPWMEe89+82EKZarKdbFVdrCRiOvNQIZGWIpL4rC1DhroWDOcbbEz1ZZ/PzXmtPS2xmiU08zh8ZH/w+JvscoRuPz0dKuFjFb8ycFxLXTkt4A5RmRs0tvMXeRCxLMxSyJc9APJFY1d00BZ5kbEbcrnCWpmD3ZP2Y64KF9OiRAc4eAJfqfbniGpqAVxsixOe2qj/hkhDRmq/6TAfpeq72C0fIdZE4gv/KdLge2XH4CiAwqD1sIzAmYfFAIK8ZCyVVp8YmKP2yD8BqBiu7JqcysrtbKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 07:43:22PM -0700, Andrew Morton wrote:
> On Fri, 28 Aug 2026 19:23:19 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > On Tue, Aug 11, 2026 at 01:31:54PM -0700, Shakeel Butt wrote:
> > > Syzbot reported [1] a set_mm_walk() warning from kswapd. Soft limit
> > > reclaim is the only thing that runs shrink_lruvec() from kswapd with a
> > > target memcg set, and thus the only way kswapd can reach
> > > lru_gen_shrink_lruvec() and in turn set_mm_walk(). The offender,
> > > mem_cgroup_shrink_node(), has long carried a "Only used by soft limit
> > > reclaim. Do not reuse for anything else." comment and a priority hack,
> > > and it simply never got taught about MGLRU.
> > > 
> > > Rather than teach it, let's delete it. The v1 soft limit was deprecated
> > > in v6.12 by commit 569c4f62d84a ("memcg: initiate deprecation of v1
> > > soft limit"). Nobody has reported depending on it in the ~21 months
> > > since, and v2 has covered the same ground for a long time with
> > > memory.low and memory.min.
> > > 
> > > Link: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/ [1]
> > 
> > Andrew, should I resend this series (without the first patch) or will you pick
> > it up?
> 
> I added the series, thanks.
> 
> The [1/9] has already been queued in mm-hotfixes as a backportable
> hotfix.  So I added it as an 8-patch series.  Because of this the cover
> letter of that series is now irrelevant, so could you please prepare a
> brief replacement for me to paste in?
> 
> Sashiko suggests that there's more that can be removed:
> 	https://sashiko.dev/#/patchset/20260811203203.3456029-1-shakeel.butt@linux.dev
> 
> So maybe an 8-patch v2 series is appropriate, your call.

I will send 8-patch v2 series with Sashiko's comments resolved by next week.

