Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25EEFC9832F
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 15:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C3F6B0088; Sat, 26 Sep 2026 11:41:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88F1E6B008A; Sat, 26 Sep 2026 11:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7567B6B008C; Sat, 26 Sep 2026 11:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3CD6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 11:41:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD5AA160931
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 15:41:11 +0000 (UTC)
X-FDA: 85256327142.20.08014A6
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf11.hostedemail.com (Postfix) with ESMTP id 16F454000A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 15:41:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dy0skOWi;
	spf=pass (imf11.hostedemail.com: domain of her0gyugyu@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790437270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7iYAmkmIlPG9rrJ0GDs88tEbSInUH1AqiZDcZFT6as8=;
	b=vxRiddkxhsGxvQq834ch6Dg75RgXiWpyRnOFIl9Dr+g+raUsyjzKEzOOKejp7Xr3EoVMge
	n5R5Bwh5h3GfTxmkn6vhVLvrqTIy7o0c0cV5S6p4T5uoq6MdYBX26MVuB2fYzzg+QhOZnW
	hKkc7oY0IPRxYFTj/I2Gz51828DNXoU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dy0skOWi;
	spf=pass (imf11.hostedemail.com: domain of her0gyugyu@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790437270;
	b=SBiKecmQ3qXtmzijxBEtiBXMLFW8elbu/hqXnJ7J/7JGjnYOq9kgiQqXWPDYwlq8Nk0wYK
	7iNm/6QKyaltkdfOy93SJLjb57sA7A4emuJvm+eSkN0vFvluNn/siW/o2naUfUzQjhVyTc
	IYF8Fk+e8LUu+sg3z2/0rjQK7+cJ9Fc=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843796e373so1019089f8f.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 08:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790437268; x=1791042068; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7iYAmkmIlPG9rrJ0GDs88tEbSInUH1AqiZDcZFT6as8=;
        b=Dy0skOWiAZyzoYJ5LPRFsMwwm3Zj75IuLaUpZBqoPUwtxcS4BrrpNOzc4qvUEopRAB
         bLRZoligPwQlpT+rjokF5QM9M7cDhYNN7vtlY35o6jrjwKSS3O7b76Bd2ZCXP/kaWwjI
         WzYVOGUYiMxBZsxctmNfyc7B4FzoZam8b6/h1DXJllPyUn5DPkJ9ctNLyyguofoczlB0
         +GHeOw6HgG4VkmcPF7Nsg8aeNtmrMu72ihkaZ/x7DOtovZ6x6vqRFSpt1SFHX9+l7I8k
         o7Bn5Vcf/QQhELARBZsIGFgpKIoUxDjMmVO6K2XEXu7kZSGYg1i7PHMXx+0SU4w5aTiQ
         ObUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790437268; x=1791042068;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7iYAmkmIlPG9rrJ0GDs88tEbSInUH1AqiZDcZFT6as8=;
        b=Z+sdRG2EgbZcZIMydyoUfG/YCivBoL0w0d+1Zk4Ikvd8s5p3u4CCkqC1bLbxpJj0ub
         uhD7hH6caEuxdEB9e/9vzHiEDmUPnzloLwXgAvcyzggQbQypDRdV/D8Wc0tXNTp13zZg
         YADceCfT/AjfTQnD0YbMRIwd41HihAomOdHIon/sjju5+EbIsiKM1vFAvM7yIen4WxdG
         ZRNb8xd0FdAk4URluc9YgSs+nSB6EsPCn4X0pQ0eKscuTNoLeZ6RRM+d72xGK/y6n/rO
         V1nrhmg97ybyp3kph6QPF46D8thwGIoCe2qTDPz6YuJ3yla+av136OJ27LpeemzF/bJM
         X/ow==
X-Forwarded-Encrypted: i=1; AKwUvBzSaCAO1jLQnqRCQfDVKotMOdjGCCnibXULwvin+zR+0mei3FDiP8OY55o4B/TDSZKII7jFBhdyNw==@kvack.org
X-Gm-Message-State: AFq9FYJqePifnz7ZMzjdGuooOnJ9MnhFIEVDRF70rVXQD9A0f6jIiyxT
	CfuyJWZzOgjlzQv/NtkJ0kTPiK76Z15kvIrp0GUFmwROCQOrj6JJs2XI
X-Gm-Gg: AYBFou1ASCX/FCKcZMVgEBxzGjEPWmajHSXWk/ZS26ZEdvgrMsHKkl4FEvkV4Xajb/E
	Z8xi27+iHWNQjxZFuq8miNq7e6Ug60ag1gYmMl7U+szUwOHQqHJAQqRig3H/nGWUcEN7I4SA0iX
	mTeZL09fwac1brm79j8Q+6tRIzIvUAGQ8GHGkDv05LyNsxadb7wIxSFzxjbJUyj5oXIB7m9tm1v
	WoqmdB38FrWFGI+QScawG+6i5XesWHfTnn6gdvzbUGOVqD0oQStGyN4w6kQUIf1HKCtH3dWtwj6
	zKWywr7tZDNLwv2N1iKZuZV1BwnJAaWmJTMmongTJm2cYGgSZ5HNIUdcS9EoO0PvXdWPnIMlVJf
	PUH3Az6gLeT0g1eN3SZZzdWPpRRpz8sty0AWK4+70Eddz/nEINffwRlZYlwW7YATovCBSC3H3Kf
	ZBPhTGZ9vTBctS3g+1avtlNqguS1uAn9UcOs8c3zbP6QsnSum4iRoS0LR55mJHQd2kXl3ssa9/6
	+fpDu4XyPGGSoTwO8s9Fm99qlTQI4wmvFuVorx3mmJ3
X-Received: by 2002:a05:6000:288e:b0:488:820b:7e24 with SMTP id ffacd0b85a97d-488820b7fedmr8759522f8f.28.1790437268482;
        Sat, 26 Sep 2026 08:41:08 -0700 (PDT)
Received: from gmail.com ([188.250.243.225])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a34a638sm14236008f8f.9.2026.09.26.08.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 08:41:07 -0700 (PDT)
Date: Sun, 27 Sep 2026 00:41:04 +0900
From: Youngjun Park <her0gyugyu@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	yosry@kernel.org, joshua.hahnjy@gmail.com, taejoon.song@lge.com,
	lianux.mm@gmail.com
Subject: Re: [RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with
 per-cgroup selection
Message-ID: <arfnkNBANl0fwrKb@gmail.com>
References: <20260916183437.2946306-1-youngjun.park@lge.com>
 <20260916200434.GA5784@cmpxchg.org>
 <arAHu_BD5oqpZJER@gmail.com>
 <arQJIjzE0BlUg0CV@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arQJIjzE0BlUg0CV@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 16F454000A
X-Stat-Signature: 5ydtb3xyc4594dq7u95p7jq8qn5oa8z9
X-HE-Tag: 1790437269-153697
X-HE-Meta: U2FsdGVkX18ssbA/F7R47AoPLDlioL2WBKn6ZeJJzmepgA1Gtk8fWguBTuJTlzPa7m6uywvHg1A0OdUgBrqN3+pFb4niRCuVBTVTxhEdqnSK/8AD2E4SraOrVti83eAANIaM2Oh/SKMt2/nA+oWktYeQ5n94dC0ca8lpZBEUGvJ/oawb7dFUta5ZJ6bLQJg08D1SMtkEjaFUYKKZ97TlU3xomvUkuAd/fklDiKvW3VZqAUK2UoM5C3Q+yPAQyp1UEHgyRE021D1MdCBUIMitcN1u8IbvWt5R9Sxzg7eHREEMKXICEGr5ef2C4V4LvXA93nhPq/h9xgmTT7eNDcYWPwhjEhiyK95h+/SDrKV/lmBlz/YJ09povQWjHCqTpHUFG4kYYZNt2yoqHF8wsrqONo9tKfZne1Rl6CJXYEbYNEPqRq66wm+e2Csq/J+iEuOjeyYMPukZ7EP/IG8Nt+/ptLBB/jThcZGU9cIL1910zF2Bkx/WJ1vMYBxQQTTJHJtVzen8CuyY7bEjEkGoEVtQBHghC3alg1TCmCb4aTF5TOFK8DawuTD/6AX1ADLKsc5L6ifuRrlo7Qz07Tv6jaF/U9d9UrSp2xDkA8GsPcrxv2BUY1D2hKjNdJJoQHo5pLgbA4SwCuVkIqrJq3JIp8fSwYPQLhC9XfTP2ilP2Ih+VrnjpZkdlGjmMZqIhhTQfVGy9xnCJAIHsM7EiN0uSllWzUcRF7B5oo9FlEIXfT+ytZzKZY856QX+oT4sBmzW5vjjTsoOIePPjRqVlaeGHfdd5x0vFqAdAskhFmkYt1JbFSPK3JAH2+p9EdhAkAvuhKC8ui7Dbbq3wIgexzLnjQgZMd2wvmqYDmhSt1CqiB7zv8kyyOcpNk4mxWfXwJQN6NMH6+lp6R+3z54U2C9mnuYdYnsq9m3O+LhRQLfWqNy4IbgwdLmMya2oM6rhZbQarnsSAtN4Y7y2U89ZRAQzaiS
 mbQYy+sO
 zHMmu9h8FDoge+p0XVVsjnESS76ivM55gAU81eO3PYP+zEhLyVqw6qoUr3eMWkoFrzrJHzkugLI8QiOznK/it4HeziWX6erQGXXlqVNn2nhh5q27HXlqkoVWMU5vuRCqZRQZ6bbC7CuGvRn9beVhmUqQjXFEwwMtvsuOfGPwJEGzwQ2Vj9310nNX0JjQmO+5Jt2kJ3oTtwLbwFaMaJDNtJ1SdKKN6eSGTZVLbMDpmyxF8Toh0G4Yy04/kBxJcDMefNMIslc1HylBl5M2GAQ1OyQi1zZXnivC7ommwGFpHF9eklXg3Xoado8aOQM2fu8nDemg6JFyBLTmo/UP+dl5k+e5D4bk/6UIJoMvITc2cro8/vsEGmWSpuuYckJoG+fP9w07+KOc/q01LBs5OfiYVCdZcwInm6D+H4Yq4hKfEZoWF8UaUA5GGNs7ARXu3FOZVELcTD6oMnfO751iul76zaucazQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-23 13:15, Johannes Weiner wrote:
> On Mon, Sep 21, 2026 at 01:20:11AM +0900, Youngjun Park wrote:
> > On 2026-09-16 16:04, Johannes Weiner wrote:
> > > On Thu, Sep 17, 2026 at 03:34:33AM +0900, Youngjun Park wrote:
> > > > Per-cgroup swap in debugfs
> > > > ==========================
> > > > 
> > > > Patches 3 and 4 let a memory cgroup choose its tiers through debugfs.
> > > > 
> > > >   # swapon -p 100 /dev/nvme0n1p2
> > > >   # swapon -p 50 /dev/sdb2
> > > >   # cat /sys/kernel/debug/swap/tiers
> > > >   Idx   Prio
> > > >   0     100
> > > >   1     50
> > > >   # echo "/batch 0x2" > /sys/kernel/debug/swap/memcg_tiers
> > > > 
> > > > Bit i of the mask is tier i, so /batch swaps only to sdb2. A tier keeps
> > > > its index for its lifetime, so the mask keeps selecting the same tier
> > > > across swapon and swapoff.
> > >
> > 
> > Hello Johannes,
> > 
> > Sorry for the late reply on a good suggestion :)
> 
> No worries, and same ^_^
> 
> > > Can the cgroup be given a priority limit? That would have pretty
> > > obvious inheritance semantics:
> > > root
> > > `- batch (memory.swap.prio.max = 20)
> > >    `- task (memory.swap.prio.max = max)
> > >    `- logs (memory.swap.prio.max = 10)
> > > `- interactive (memory.swap.prio.max = max)
> > >    `- task (memory.swap.prio.max)
> > 
> > Right, the inheritance is clear and easy to understand, and with this I
> > can pre-define the limit without knowing the mask value.
> >
> > But first, let me check the intent. Is the point that capping batch keeps
> > it from taking the faster tiers, so they are left for interactive?
> 
> Yes, basically, that's what I tried to express. Interactive has access
> to all available capacity. Batch only has access to lower tiers.
> 
> > If so, that matches our use case. Latency sensitive workloads get the
> > fast tiers, non-latency sensitive ones get the slow tiers. But...
> > 
> > Even then, the reverse cannot be expressed. A cap only cuts from the top,
> > so a latency sensitive workload given max can still fall back to the slow
> > tiers once the fast ones fill up. For example,
> > 
> >   tier0  tier1  tier2  tier3
> >     0     10     20     30
> > 
> > there is no way to say "use tier0 and tier1, but never fall back to tier2
> > or tier3". To cover that, the interface would also need a min value, or
> > some way to express a range.
> 
> Correct, this isn't covered by the above.
> > And even a range is not enough. Excluding only tier2 leaves a hole in the
> > middle, which no min/max pair can express. That needs per-tier selection,
> > which is what the mask,  and what I'd carry over to the memcg
> > interface later (Currently memcg.swap.tiers.max).
> > 
> > How do you think?
> 
> I think it could help to aggregate the usecases in the cover
> letter. Your cover letter describes how it works, which is great, but
> it would be good to understand better what the constraints are, how it
> fits in with other existing control surface and broader usage models.
> 
> With the above, yes, you can restrict who gets access to the
> privileged tiers top down, but not bottom up. Is that an issue? Keep
> in mind the alternative is cutting privileged groups OFF from certain
> available capacity. This seems somewhat counter-intuitive to me, and
> doesn't reflect a clean privilege hierarchy anymore.

Thanks for the explanation.

I thought about it many times and concluded you are right.
The reason is simple. the two cases the mask can express but prio.max
cannot (holes and bottom-up restriction) are possible with the mask,
but there is no real use case that needs them.

Therefore I see no reason to keep the
mask interface I proposed. prio.max can be extended naturally when needed.

For the record, the interface semantics have evolved as below, and
this discussion changes them once more.

  1. Per-cgroup swap priority for our usecase (initial proposal)
  2. Fixed ordering across cgroups (swap tier concept introduced)
  3. Child tiers as a subset of the parent's (after LPC)
  4. Switch to the memory.swap.tier.max interface
  5. Agreement to add the memcg interface after virtual swap lands
  6. Express tiers by swap priority, proposed as a debugfs interface
     until the memcg interface is added
  7. memory.swap.prio.max: cap the fastest tier a cgroup may use,
     i.e. top-down restriction (this discussion)

I agree with this direction. I'll describe the discussion history and
the resulting constraints more clearly in the cover letter.

Here are the next steps.

  - Change the debugfs interface to take a maximum priority instead
    of a tier mask.
  - Introduce memory.swap.prio.max after virtual swap lands.

Please let me know if you have further comments.

Thanks,
Youngjun

