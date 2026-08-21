Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70E63C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70CB76B009F; Fri, 21 Aug 2026 13:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BC5F6B00A0; Fri, 21 Aug 2026 13:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AB456B00A1; Fri, 21 Aug 2026 13:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 286516B009F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:52:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A165A160210
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:52:06 +0000 (UTC)
X-FDA: 85126020252.02.7FAEA71
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7A48514000C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:52:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=t4t21egP;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787334724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4r9Jbt/bO7UeLYNwfXFrbJjchGvrclBSzHl6eH4LNA=;
	b=FWCqK5MoxJcSjM39eIMHw2ZDfmYY0QVT7y/yCXnDga7J0K5y2i063lW4d82sZD6hheBx4F
	bSzgbj+Ehtds59Qoq6EHIhvbEW/AkBRA6SxPg9A7/1xbCUUpz3jC9uS5gNhXh/mxiM40Qd
	U6cgX8LpLCyLCb5LKcDLEfBG/cDc5W8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=t4t21egP;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787334724;
	b=n2Ze4pc9jp7EZnkjIdM/s8y9trQgm4seOPTj0zAZ44iqRTcPrUMH4SZ3AP1WFXAuSZdN5A
	q49X9b1aJehF2HwrhfW7q3WL5+KEc/AcLHkAdRaDnsjQUapx/wjRv0o7ENS/Tm8W//kILS
	jfFKZ42NRXDx1qO1rqfRhlbBB82TX4E=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c0cea8883so10605591cf.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787334723; x=1787939523; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=z4r9Jbt/bO7UeLYNwfXFrbJjchGvrclBSzHl6eH4LNA=;
        b=t4t21egPrlE5aEwXSP/0xPCrDTGXOI//R18sOEO6qB1IRJEklyLQtTnH5afNmbamnv
         INnCvOGsYstU2CjEScn00sGy2Y9L6J6HY74lHzq3W9MEB3zcpsfgWQDarXd0mhjHRCds
         yo6gH5AWeDLnrNoZ+1F6ixVKcgTefK8isNsLag6Mk87P9mq6+2JQNjvvbvmdQPEAf9kS
         w0xrMv+aNdmz/ZYdGlFS3KjPnaQ3vNYyW5aOZSPSOWyQFq5z5YUL/HICDySoeRq/l7BQ
         lmdUQLAZnj5B1//BAhqSB0vRDC5nmLRypyY4JAjXOc7FiQu0Rz42ffSIojF/GcBumugj
         ql7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787334723; x=1787939523;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=z4r9Jbt/bO7UeLYNwfXFrbJjchGvrclBSzHl6eH4LNA=;
        b=YlLXRKi5VAJGOlXFUJ2cuFHeTN8KFpO8kxC7PnQFY0wql/dHZulkpkFvTNYWMh4kNG
         1F3rEAwR7bBraWW4s0K5J2tCqPK8fQAbIyNT+TGXXsDfv0gr4M5pnhwQGTcJ/hUW3cV8
         mIzBX5RdhYLrWIAAyWRGWA6Yjay3lZFgTnnY3JYV3NUs5urmCMz6kU7PJSXu7ZHfzN4X
         dBnoScti3wDWkd8mkkInnnrQHtq3b0emfvwgF//RKNoyRS9QYp/yFdFdi8twDyrdyibW
         bUCS6ZZ+j6kqtCm4BU11pcN7vMPCsA6dKxJdhhw7rNHUgerbElZFsVZTs9BhEVrfvMES
         c96Q==
X-Forwarded-Encrypted: i=1; AHgh+RpGxTENg68iidPJ+aIs034y4CvnAjkcHahs8KYS1FSyHpfwwFTRzXYezlB+OEhAYdWpiuQSqDgZ5g==@kvack.org
X-Gm-Message-State: AOJu0YxvTkuh93Hyj/kdHvBCXGS/o7Cl5wWBFcvax9ZDSDlEvnaXkaDj
	SwyO7vTyo0b5zw7tcx7dsmk7X7oIfEl77icwqlzoQx6PPNtZMcpQ2bQ4BnngvbjqHaE=
X-Gm-Gg: AR+sD11aRPKMX+9bQ4SJoKppnS65Q4ruEBcSV40Zz9bn8/iWWeBd7bzDR7Sz/pZuMgy
	fVsQTsVrP4RY8kDvTmCED3biFH3vbqWmyxya8MFbRUrpQvEtFNXeZ5xnK+nTpJJS2ycG0sMlQuu
	ngtWm/owOKp4XaB8MUpDk3sz7VmZZumhIHG4HveeRig6YEtaVvp4wQPOOAIcZ8bqbpiAyKSzlfe
	Vqa1nLsp8mr9e9WwF1ryCzaVrY8ZY56j7dZ0ObEcykAHpK4ayXWy/aT2aNSS3n11G/2wg0CKCeu
	v5fTh0KolDOwCrPqpOTwTt0NLiVbhnLYNnGrvpaRZGuKfDKS7dpiGmXe259DuldlAu7zfw8nn36
	hJTSRmsh1DYTcaEs8bPSihcsoW/TYVEv+4EmHGnEgU90oQyz1Trr7zU60FBixZPY/herQEqNbVQ
	om1lD74MsyaTWvgesMIQ0/GRB3hcb/QIIKZOGOjV3NSPXEZwWEtemskpDk+oEb+qQpnrP3Og==
X-Received: by 2002:a05:622a:8603:b0:52e:1e5:45d6 with SMTP id d75a77b69052e-52e01e57d27mr28511781cf.6.1787334723252;
        Fri, 21 Aug 2026 10:52:03 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2906afsm67569666d6.25.2026.08.21.10.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 10:52:02 -0700 (PDT)
Date: Fri, 21 Aug 2026 13:51:58 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Song Hu <husong@kylinos.cn>,
	Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in
 obj_cgroup_may_zswap()
Message-ID: <aoiQPrudvYZ76ZSD@cmpxchg.org>
References: <20260817131843.45121-1-husong@kylinos.cn>
 <1787017182353556.21.seg@mailgw.kylinos.cn>
 <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn>
 <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
 <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: uubdc1dayy9cmg54po1u4d9obbft1h6f
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A48514000C
X-HE-Tag: 1787334724-145478
X-HE-Meta: U2FsdGVkX19i7qww6grPg0SBvIopN4cLjyy6LS9OQd5qPOU7PJvLyd8HbIiybAX8v2k7uKiF/hUihhGS7KI61fIXr2p9e5ti3IYe67l3Rjpwu4XG5YN+iyWfYsSua3jhZS9SORLG1BJHcvXBcnjmGnoINDsL2vRqrFBT7JxHIe03Se//1yK+DhWS5AQkX4iwQO0W941YQbPO3ySQOrzKEDApE2KVFDdwE0x5Xeg+sKI+cdKYCkwLTxlR29xjxTnJtK9R9DhAfR+l1q53UrUUB5GqbylhU9pCefrR2mtHf13FCMa397VLXOx9m4xQkx6n6G1OlYChojHNHrg2qot3Idxyjq5Fm3f6YogSWZdEfVIc4lc3FFhgwi7VGE9w13utkuh2UInLGL6pZtMkxFfrMMB3vzz1ByHXolzzt5kXtlBRG8d6EWpba96NP/xZHqFw+tcYidLKHcQKovQzEmpXFSUPJEDq/ELpdlDmc2bzBvXrw1ZyLvXo7PD4/USv0iyg7S+74q7Aqa+ROWb1WgoL0jbUpf4rWKC7V1kCBt5/jUSIpaEYTTEUROwPR7f63HTBXarq3gzWL58ffbJssGAE4TJSRx+90rfZkH3qLUiIh3TJkyRkwTznZEDvgHZiyMFISj5ZcfJmaWdPN6cWx6UVTN4m8MdR5NbcqZPlpwpTzBZx93GVwHnJ7xQJsefz41xuWooKY3L4lTF+RNXUfKtJNE6cFeXwQEfF8+doTVZdhsPcPF4HAfQae1Srk0uCaWch0T31w79IpSZHySXa5V3yRPCJcJIXrOFKW2YXrr1WOvshzDfqOZi1vEhdvTaDHu5S0+lVCNqaPil0wR9EAn1azRyxfj9QnRyFrEeSpzuPt1rf4CzlpMgmAjeMASNgzIb0kkrmLjG8Ehw48X4VUHdkGeGlBoW7LGK45oKCQYFoNPsnfboEzT06Nps8LQkW++ZhwyKVfLEMwy6e/XJWYy4
 23+wxxYm
 LJ0K7TZ4eZ8NiuKv712fYzdfNwFKY32uRa7ng6AlP/8Yo1n8b4xJ0Gm0JRxB1zORZ2kMLIdYylBQ1yMfJLSLdv69ktzXpFJjaqIb45UjcPpflMat2YrM+RvywJh5gNSQ1NSW6b9HqwM5tZHX9w7mbMwwGNTKODbKfxYkdfX09O7PPv8clv0NazyLOXI4SbK9dBjT+11KjOVGEFU/1mT7rtIFFvqLJO+fIDAnaPpbAsjT7LoOR2wCxt+lFJak+mjLGEbMVUccQqqPGW4iWhos8P2mbQl3KBVD/Hh2AF0VbPHJD4pByPBHwgCK5CXX2YhPdLLFdWWr88bwjC17Jfr8tMOvqRSt6n2+FS/9SDzXDGC3ZDWlIxLMyAwkbIrciPkHolH4iWnCvF8+V7Pj4sMgX3rrZ3tpan/96wD4odXSCUnU8HsDz7pbmzI3Jf3r+GSug/lJx5athUAIWnQTh74OuKm2wXDuLLiiJKugYTsmXNbqPugUpH6yy4yeFANFj9gpm+bXv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 03:18:39PM -0700, Joanne Koong wrote:
> On Tue, Aug 18, 2026 at 11:35 AM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Mon, Aug 17, 2026 at 6:53 PM Song Hu <husong@kylinos.cn> wrote:
> > >
> > >
> > >
> > > 在 2026/8/18 00:04, Shakeel Butt 写道:
> > > > On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> > > >> obj_cgroup_may_zswap() runs on every folio swapped out through
> > > >> zswap.  For each ancestor with a non-max zswap.max, it flushes the
> > > >> cgroup rstat hierarchy synchronously with force=true, which skips
> > > >> the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
> > > >> with zswap.max configured, a container takes the global rstat lock
> > > >> on every swapped-out folio.
> > > >
> > > > Any reason you are limiting zswap through zswap.max?
> > > >
> > >
> > > Mostly fairness on a shared pool: zswap.max_pool_percent is global
> > > only, so on a multi-tenant host one cgroup's cold anonymous memory
> > > can soak the pool and crowd out the others.  zswap.max is the only
> > > per-cgroup control over that share; memory.max bounds the total
> > > footprint, not the share of the pool.
> > >
> > > >>
> > > >> zswap_shrinker_count() had the same pattern and switched to
> > > >> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> > > >> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
> > > >> where the same flush on the shrinker side showed up at 2.88% of
> > > >> kernel cycles under osq_lock on a 96-core machine.
> > > >>
> > > >> Measured on a KVM guest with a swap storm under a cgroup with
> > > >> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
> > > >> before the patch and 198,968 times after, while
> > > >> __mem_cgroup_flush_stats() was entered 281,017 times before and
> > > >> 80,445 times after.  The removed 200,572 flushes match the store
> > > >> attempt count almost exactly; the remainder comes from other stats
> > > >> readers in the swap path.
> > > >
> > > > This is a known issue. Using ratelimited interface also comes with a drawback
> > > > that the kernel may react on stale information and the consequences might be
> > > > unneeded oom-kills.
> > > >
> > > > There was orthogonal discussion on moving zswap limit enforcement away from
> > > > rstat. Yosry, any updates on that?
> >
> > I am not actively looking into that, but Joanne was looking into
> > AFAICT. I will respond to the thread there and CC Song as well.
> >
> 
> For this zswap stat, I ran some benchmarks comparing 4 approaches
> (switchable behind a runtime knob [1]):
> a) rstat + forced flush       (baseline aka what the tree does today)
> b) rstat + ratelimited         (Song's proposal)
> c) hierarchical per-CPU   (Yosry's idea from [2])
> d) page counters              (following what all the other memcg limits do)
> 
> For the setup, the benchmark creates a cgroup chain at depth X with
> memory.max set to 1G on the leaf and memory.zswap.max set to 512M on
> every level, and spins up 20 processes there that each allocate 100
> MiB, fault it in, and touch every page four more times. With that 2000
> MiB against the 1 GiB memory.max, it triggers reclaim continuously and
> makes the swap traffic go through zswap. The machine I ran this on had
> 80 CPUs.
> 
> I also ran it with no memory.zswap.max set (ie no reads triggered,
> only update path runs) - as I understand it, this is the configuration
> that is more often used in practice.
> 
> These are the results I saw:
> 
> kernel cpu time (in ns) per zswap store, zswap.max set
>                       a)                     b)            c)                d)
> depth 1        567,116          35,604     35,841     34,995
> depth 2      1,082,007          35,507     37,803     36,209
> depth 4      2,153,329          37,591     40,117     39,893
> depth 8      4,211,692          34,963     41,070     44,211
> depth 32    15,728,220       53,575     94,685     65,946
> 
> kernel cpu time (in ns) per zswap store, no zswap.max (update path only):
>                         a)                  b)              c)            d)
> depth 1         34,787          34,062     34,930     35,630
> depth 2         34,913          35,061     36,404     36,360
> depth 4         36,422          36,809     36,922     37,483
> depth 8         42,177          34,440     36,679     40,793
> depth 32        55,309          55,321     57,671     59,190
> 
> c) and d) are for the most part pretty comparable to b) without
> introducing the staleness problem of b). Between c) and d), I think d)
> ends up outperforming c) as the # of cpus and depth gets larger.
> 
> I'm seeing that all the other memory limits (eg memory.swap.max,
> memory.max, etc) are already using page counters. Is there a reason
> the zswap stat can't? If not, does it make sense for the zswap stat to
> switch over to using page counters?

Thanks for running these.

I used the vmstat counter on the assumption that setting zswap.max is
rare and the counter is maintained anyway for memory.stat.

But I never actually tested it. The assumption was that surely walking
ancestors on a quick if (max == PAGE_COUNTER_MAX) continue would be
much cheaper than page counter atomics at every level. And so I'm
surprised by your results.

But that was the sole reason. If it doesn't stand up to benchmarking,
no objection to streamlining the control to a standard implementation.

