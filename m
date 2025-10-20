Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC8AFCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2958E002D; Mon, 20 Oct 2025 10:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C108E0002; Mon, 20 Oct 2025 10:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB8A8E002D; Mon, 20 Oct 2025 10:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA33A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:23:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97F061401C0
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:23:57 +0000 (UTC)
X-FDA: 84018711714.17.481813F
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0924020006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:23:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760970235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8YyJYDIZVh/nGjIqYIHs8JDKP4RfNnNfn6LQt5w8fxA=;
	b=TRUdWr54bAsRjiNpiCaVoF59vW09PgVpbRSzk+PF/10wGMs/uSCwMrHlV0CM7qOY/LkO44
	WtdsIqLW7Pqg+8RWUwZ/BYOv2q8+7IMPxNuZZgP6XxmNie0bXb81obspI4/XM6dGlT+uLm
	J1l/kE3gUU19HprWWlMjBIwo2ttxk4M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760970235; a=rsa-sha256;
	cv=none;
	b=yN04HZ9Zu0zthRWK6uaiq997n4hYqUD5CC6sLPB3brHJPhJYFKr5jN2JR9RKlIxXOuh9qo
	iGyq9vwy9R7CJx/1vOx+BOKA8VEpbIqAgq2gFdIztgjBLq7t9mUO1zfYJDzs7IIIlRoQMz
	LeCQWOvQbYojIUFqb/lvfm8dHA1aWsg=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cqyJW4hhLz6L5XF;
	Mon, 20 Oct 2025 22:20:43 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id C3AD5140417;
	Mon, 20 Oct 2025 22:23:50 +0800 (CST)
Received: from localhost (10.48.157.75) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 20 Oct
 2025 15:23:49 +0100
Date: Mon, 20 Oct 2025 15:23:45 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
CC: Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>, Gregory
 Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>, Bharata B
 Rao <bharata@amd.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <hannes@cmpxchg.org>, <mgorman@techsingularity.net>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <sj@kernel.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<yiannis@zptcorp.com>, Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <20251020152345.00003d61@huawei.com>
In-Reply-To: <CAOi6=wS6s2FAAbMbxX5zCZzPQE7Mm73pbhxpiM_5e44o6yyPMw@mail.gmail.com>
References: <20250910144653.212066-1-bharata@amd.com>
	<aMGbpDJhOx7wHqpo@casper.infradead.org>
	<aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
	<7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
	<CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
	<20250917174941.000061d3@huawei.com>
	<5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
	<20250925160058.00002645@huawei.com>
	<CAOi6=wS6s2FAAbMbxX5zCZzPQE7Mm73pbhxpiM_5e44o6yyPMw@mail.gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.48.157.75]
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0924020006
X-Stat-Signature: b7s3g6ahhgmpmjerf4chm3b8wd864qju
X-Rspam-User: 
X-HE-Tag: 1760970234-790956
X-HE-Meta: U2FsdGVkX1+JcGauJICwK5htkS7y/YWMGlV0YLn5fvlcn4pO6D47n0c3yEe0uaQ/ZHEguK6JVFQUcyQMLr+lqx6Wv0ht1QzudZJ6Nb9gILYJrsGLogkbIaQwrNIXa9LwXHnuk+7pU+/rgxuvShFZTybvfbA4Jgz+XP0oS+YxK3FrjrdIpk0vIwL2tdGWoHjznpaeP6J0/w1JwnT8RGdOVbDDtwG6nhJIl2wKRXE1SjtRmzTwTyvwrPtRZU2PBAvDCiyDps0gTh1wzbi2ODsYyZXNoXASaWc+/PdA+Z8Vfkqvlon8RiQWAGZJtuq3K5oUZhu+OakPhrxp889cVKONXugtOwyyzbDf3waRhiB8+HQWiL/NEa5uizFzmcomHu55B7fAX5jtb2dH2B3DwCHDN7KPfjw0KJ6KNQE0pZkUFO0CZTBJ7GpKb0J8JcDZ51j68RwteNlI4N0pcngX7x7JJtnKO8wkPXgerwoLVim/peA4rpSwUJ4z2SCkqjoiQ1Bb/GMsbtvbNzWJDVlnjWwJBEiKj3vxMxObS7Lr08snWO7xPlVN4JhaGhDvyKSiTl7T2ZhMYQRTclEaclm/BbH+QXqzux6fNNj0SHsHNowyeckMVXUDMvJnK0AsYZPHD+smg2JOUSvNWUw+hYDE5PleEC7ayUuRvzKf0etDb9c6R2vLlgHrPg2eoNk6omZrHV38Kd5Y35up5CElk7ER9ZKnVpUiJpWOiUPKnj0ElR7AZrhwOsD2FEzBUVShb8xRCVxJhdY/Zjt0B1BHY0Z5bZzdzwc8YdRkrqkuGRgUa8aK56d5++w+xY0MRBidY+XkEqxzZIiHbjIXPX6nkm4Zo9p+xCb/H9Bah3W093fMEwAgcYhySKhcnbyC0reHBGXA/Y+KCNTJn4i9NVT/S4WdRep+L5BneGh3wK52snkUMKm72kPpoRaySihfktNX36rRu+l9JV0CKwpSvYqeRTxP8r+
 6qHgqNPw
 4E32kiaAWpsB3gvt6YE4yrluAOXk9/bUXERy8QXaLvaSVB6DN9hN41OsmUynriX4omtsS++YJCPHYh5+eiCiTw8e8YbtU3Rp7J6+iRfTmbgCD8j1rQwTItkweFSq1J8gQQ1uZ3H8XNwgK4fOMBCl7NtLPjkUZLCybmiAafAk+ZOcDfe7q9auRDQAddRAjzGa57hwpYwT7kLgRgLyWs6Q8cL/j4EXKSQd65kJrx4FiK2cnPuSHWHThqOeucb9suVp/MZsyltFsGMqPT6bMUGd5aPYoJtpfi67DIkqdo1v8hEtyNJA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Oct 2025 18:16:31 +0200
Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com> wrote:

> On Thu, Sep 25, 2025 at 5:01=E2=80=AFPM Jonathan Cameron
> <jonathan.cameron@huawei.com> wrote:
> >
> > On Thu, 25 Sep 2025 16:03:46 +0200
> > Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com> wrote:
> >
> > Hi Yiannis, =20
> Hi Jonathan! Thanks for your response!
>=20
Hi Yiannis,

This is way more fun than doing real work ;)

> [snip]
> > > There are several things that may be done on the device side. For now=
, I
> > > think the kernel should be unaware of these. But with what I described
> > > above, the goal is to have the capacity thresholds configured in a way
> > > that we can absorb the occasional dirty cache lines that are written =
back. =20
> >
> > In worst case they are far from occasional. It's not hard to imagine a =
malicious =20
> This is correct. Any simplification on my end is mainly based on the
> empirical evidence of the use cases we are testing for (tiering). But
> I fully respect that we need to be proactive and assume the worst case
> scenario.
> > program that ensures that all L3 in a system (say 256MiB+) is full of c=
ache lines
> > from the far compressed memory all of which are changed in a fashion th=
at makes
> > the allocation much less compressible.  If you are doing compression at=
 cache line
> > granularity that's not so bad because it would only be 256MiB margin ne=
eded.
> > If the system in question is doing large block side compression, say 4K=
iB.
> > Then we have a 64x write amplification multiplier. If the virus is stre=
aming over =20
> This is insightful indeed :). However, even in the case of the 64x
> amplification, you implicitly assume that each of the cachelines in
> the L3 belongs to a different page. But then one cache-line would not
> deteriorate the compressed size of the entire page that much (the
> bandwidth amplification on the device is a different -performance-
> story).

This is putting limits on what compression algorithm is used. We could do
that but then we'd have to never support anything different. Maybe if the
device itself provided the worse case amplification numbers that would do
Any device that gets this wrong is buggy - but it might be hard to detect
that if people don't publish their compression algs and the proofs of worst
case blow up of compression blocks.

I guess we could do the maths on what the device manufacturer says and
if we don't believe them or they haven't provided enough info to check,
double it :)

> So even in the 4K case the two ends of the spectrum are to
> either have big amplification with low compression ratio impact, or
> small amplification with higher compression ratio impact.
> Another practical assumption here, is that the different HMU
> mechanisms would help promote the contended pages before this becomes
> a big issue. Which of course might still not be enough on the
> malicious streaming writes workload.

Using promotion to get you out of this is a non starter unless you have
a backstop because we'll have annoying things like pinning going on or
bandwidth bottlenecks at the promotion target.
Promotion might massively reduce the performance impact of course under
normal conditions.

> Overall, I understand these are heuristics and I do see your point
> that this needs to be robust even for the maliciously behaving
> programs.
> > memory the evictions we are seeing at the result of new lines being fet=
ched
> > to be made much less compressible.
> >
> > Add a accelerator (say DPDK or other zero copy into userspace buffers) =
into the
> > mix and you have a mess. You'll need to be extremely careful with what =
goes =20
> Good point about the zero copy stuff.
> > in this compressed memory or hold enormous buffer capacity against fast
> > changes in compressability. =20
> To my experience the factor of buffer capacity would be closer to the
> benefit that you get from the compression (e.g. 2x the cache size in
> your example).
> But I understand the burden of proof is on our end. As we move further
> with this I will try to provide data as well.

If we are aiming for generality the nasty problem is that either we have to
write rules on what Linux will cope with, or design it to cope with the
worse possible implementation :(

I can think of lots of plausible sounding cases that have horrendous
multiplication factors if done in a naive fashion.=20
* De-duplication
* Metadata flag for all 0s
* Some general purpose compression algs are very vulnerable to the tails
  of the probability distributions.  Some will flip between multiple modes
  with very different characteristics, perhaps to meet latency guarantees.

Would be fun to ask an information theorist / compression expert to lay
out an algorithm with the worst possible tail performance but with good
average.



> >
> > Key is that all software is potentially malicious (sometimes accidental=
ly so ;)
> >
> > Now, if we can put this into a special pool where it is acceptable to d=
rop the writes
> > and return poison (so the application crashes) then that may be fine.
> >
> > Or block writes.   Running compressed memory as read only CoW is one wa=
y to
> > avoid this problem. =20
> These could be good starting points, as I see in the rest of the thread.
>=20
Fun problems.  Maybe we start with very conservative handling and then
argue for relaxations later.

Jonathan

> Thanks,
> Yiannis


