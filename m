Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F24FC1061B09
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC6F6B008A; Mon, 30 Mar 2026 10:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84286B0095; Mon, 30 Mar 2026 10:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A216B0096; Mon, 30 Mar 2026 10:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A81536B008A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:56:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53DDFC210E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:56:14 +0000 (UTC)
X-FDA: 84603029868.12.1E82D51
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6143020004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:56:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DipxXDNX;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774882572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWKiqYjc9QcqJoKDuyruIGFZFhuWm0LaKPO8vIwd1A4=;
	b=fwp1G/SMLzG5eDXNqdmXtLzmPtpFccAyKh72UY/ep3HEZXkz29/sIZo0BSHL/dFceEpq4v
	6x26sIrpamgl8c/NlzAXNKnW32gzyBo0hg34YvnGK/t37wROlvUgrRdlQTKYca30kW77Bi
	UAWqxYCYd/qtnOIIgVPGV+GqrDpoMIE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774882572; a=rsa-sha256;
	cv=none;
	b=iVeL5NOA/YtazpVeQXSo70e5xuAoZT3DB2rLmqfXihQN4Ri/sizi+rkztsJ8eQCJz2B7Ia
	93FjiEtmt4vt4cl16xyTo6YRBYSGQVMW2Q77WX1rEry7Nv2FfLcsYTisiShDAb5wdROQe+
	+YeWrDyEsfLJ3+tTF0JDSwRRne06EGQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DipxXDNX;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d4c383f2fcso4427813a34.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774882571; x=1775487371; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWKiqYjc9QcqJoKDuyruIGFZFhuWm0LaKPO8vIwd1A4=;
        b=DipxXDNXNy03jgUHK2W6Z9VmzYe16yzUXrRrdJsk1mBk7++vRkLoTMyg1GwWa+zpxI
         vs+umZek+XYGa1QjEAJ2V0MbfwUCau1WrwphP+uQbdCQazwqxkEluMce9ntBZjqx3V0p
         a97ZGl0yLyY/izKJCI4bGbdbPe1MYr51ymKf3qhtipCRziM/89wisgO93tuA46Pw0Eo+
         EzH8MoDGc3hYNQ4dCb2pPgLsukka78kL9q84GHwG1pKjrE0CbZZSsbgiBMOR1RJWMhPF
         U11Qf+4MQgVHSIVOewRwXJhCiIVidCU4wapfWGI0eOUn/bGID6Pn71BmGX3z5oQU0djL
         kzSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774882571; x=1775487371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XWKiqYjc9QcqJoKDuyruIGFZFhuWm0LaKPO8vIwd1A4=;
        b=Ht+G8BmDHhW5aLnX6HKzYwWn00MOSCmHzgkDB6HDOW61U6hhwgNCGUXTTVIWqhti8T
         lH7G0DrQ3NlC34X1o/DOs6CztWKMeQioQ6MaK3PEDCSOyfGPvrwwGgBssucwf+Z4wCqB
         5feQgP2F//sndS09gBVHhsE4+WDxzJgHsMq5urDIxqwg4uKPsgIJUFZrkAZFI9CvtDMO
         661lJwN+oslooGMZIobkLCz89NIuuxP7ii8H93FDWR14OWjG6rtaHzo2Nv2Rl7qLd2hR
         CPZ/okUBr9mDVO2tPQi4tqlgCVIdStgPJHsAT4PYWTgq5gAM4bV1Ed0MVyfCj7gxZNmH
         OZ4A==
X-Forwarded-Encrypted: i=1; AJvYcCWQJ4r93a0dljYtt92GWTTFBrJGXDl+tRwBkrOj7kJ4IheG4w+eGTi59RMHewbso3yCD50hQ1zfWw==@kvack.org
X-Gm-Message-State: AOJu0Yw5PMvoKJNWq0HhCfK8M8LR3KlYjR6ztLKweI0LqZbHRl1Gf83r
	/cHhxogNAQ3vIqlNXNd2YS/d6gWlQyGThbZzb5e5F1tfeJtFqfvExQ2o
X-Gm-Gg: ATEYQzzkq1U9kZtgLcGZygDcoBTNYTpcnWbEDORufQ/ckMwQUTb5Vf4GIfaDYYRiNO3
	3Fy7BG2xWk48h/jhwEvnHuX8/BLcIO0n0HWzJxz7ypO+lKJheqJg00gjsJLbaND/6rvvLP5f1fX
	RFMQnH9NFRSBQ4J5DSh52kQ5gwYpeJRPHONwtmBfOW3XCJnCLjbiH42KG2Wc836Y1YeaQ2msWCS
	rWNrguAWbOEBwerdAp5sLcAPQIpZbPKr3xFbeQYGFK3yqxqG1SruoznqSlEC1p+zcVamaTdiZo6
	wpUb6IN9NrGTGH3Hx/uALn1LOqg6BDSUTlaAJ+4y5qD2e0gN4RZI8eqpNdlplLzPGJjd08u6yxI
	YbeqFt582hJeqzsoR/JHzVYvFzmGOLm8bcQ/n9pLXIejuoqVKHo1Kp9cosSvBu9oK68KUIcEJ42
	6Adet+XycuLY7shUfO8kH5
X-Received: by 2002:a05:6830:6a89:b0:7d7:d15a:ce8e with SMTP id 46e09a7af769-7d9fafafb09mr7526126a34.32.1774882571282;
        Mon, 30 Mar 2026 07:56:11 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:7::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7da0a864514sm6135587a34.26.2026.03.30.07.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 07:56:10 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
Date: Mon, 30 Mar 2026 07:56:07 -0700
Message-ID: <20260330145608.3574897-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <acqG2Mr5ekCn2HD0@tiehlicka>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: obqqf3rmnt99tpads1ncdat8b4umbyb9
X-Rspamd-Queue-Id: 6143020004
X-Rspam-User: 
X-HE-Tag: 1774882572-440270
X-HE-Meta: U2FsdGVkX1+GPtUNby4lj5y+UMMjbZT9ziHc+ggRSwuCLqFQF3WwLtkMGn9IciDw8DHz2epZF+W9UIyKn/bZQgwt43h9DsUsr0I0waSOy29BMQQ5zk8NE02x//J5XbjRliWkaDhPk51ov8lkWHqWGLShMxUcHUoo+Mbo8UISOHse8f8qBBvud58bymoACHtV0uVG6McVgb0uFyy3u4PyLTLEHAaUIvRIHrMPNLmQgrYeCT8f5xC7thB419o+HbGZ4kjk4eeAqxdNHiOIQptnOH2pnCglSeVHnrJiKMqQ1SCZXlabEZohNXuCvDPgsRcwTZKoK3Smzhg1Kf9ZxS7tALC1/9bl6Zh55fwo+lDXcIMh6Un+WTS1yx/N9IL6SvGO5wOA+/9vMtl5tldRySXlWDNwQGn3oov1vlZe6gBAgk/BQMkA52tCqlE2andHkVaVniuPPJyJCZEmvMkPuv8ZUp6RbdFYhA/TRkiZr9vVIH0eZQlMKYpJiQRWLOL57c1Lh0a8owdRLskOreDLPkzsyAVxA00MQKa4QRJhyMW9PdkiFWVic3yZsoW+8ldiKMOkcXbWa+7BfXhfzXu6rHuYI2PytSDzz6J5JbjDHb6op1eQJEvYVpaDLshIBFa3YK2arrhGHcQO2GGs0QBK/LGF2phx6zQ6gl9ou7UcmpiioyeKq7E0qDugIrdnr1uvo+fEvWaLnepXmdRkVDuHhYAj3mVcE6LpR9zIZjDWqKUY2/0O3ivD8TW/Dy7BqGPHfeYQ4rKIQp0evh8cgrUEyP6KMjk2OPCqqdUNZYdNWk177npa/SEm5Xxq6+8MFH3Ze6fnjjdzMCQOPJaTRwwWEVhaWy3ftPPNmeXVmPqSvxZNf3tHAsl/Qceok21rfQX+k3Trx/8RxXuosKB4Qg0j/pqkawFfOtF8UFvvashSMQSnHIc6IoHVIGlOAZ8LnLXIbE/d8RljQ/OcJ6PWJejkPk7
 dY5l508B
 sz1bW1P3Qw3YKezvOL1eT4FVou+TzrLTFHzPwF2gLqLWKeihUot+YFi+ti9Kj4IaVjUuCYlsuZFwxgr4LIGxcRKVTeXeiEvtO02YRyfSWFmmb+216XQtS2XZO/kR9sxe7ia71Nn3H5dKmoOYZgXg7kjQheOn2ot4l7lTZPRqpEgiezLaCInomerEa7l+BvgEZskIpx8/FSZ7mO8AIgBVw2BqvNYIkNVNdgqUxqAyzjwNHXBWvXMikR2ghYotVOdP0IyV0q9A5wTOmmIx+FPElWuHN9tQOOl6WwhYTO8Lj2LUCjOoGykqyILBB3D+wmpv6oRa83L+kxHgjnhwB5L+cpl6zCKSnLY30PXamjPAN0sqdZLvL1/99kTLsyV277ENZSKUaBWbmNxTA1aSC0HREOBHtZEtNbXejyP6xpElsOiFt8p2GQxe+1A+CINgZPFqJsFc5+JN0zfKUz33on+5sbv20wXb2AMuNuc4mlEcWxGXqhtGzXk3V0LT2mxQZhzYzkdxbwtgpmfJXQ9vQkS/sszdb/fmVK7VUpDLGlTf3hpRc4Zw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 16:21:12 +0200 Michal Hocko <mhocko@suse.com> wrote:

> On Mon 30-03-26 07:10:10, Joshua Hahn wrote:
> > On Mon, 30 Mar 2026 14:03:29 +0200 Michal Hocko <mhocko@suse.com> wrote:
> > 
> > > On Fri 27-03-26 12:19:35, Joshua Hahn wrote:
> > > > Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
> > > > to give visibility into per-node breakdowns for percpu allocations and
> > > > turn it into NR_PERCPU_B.
> > > 
> > > Why do we need/want this?
> > 
> > Hello Michal,
> > 
> > Thank you for reviewing my patch! I hope you are doing well.
> > 
> > You're right, I could have done a better job of motivating the patch.
> > My intent with this patch is to give some more visibility into where
> > memory is physically, once you know which memcg it is in.
> 
> Please keep in mind that WHY is very often much more important than HOW
> in the patch so you should always start with the intention and
> justification.

Ack, I'll keep in mind for the future!

> > Percpu memory could probably be seen as "trivial" when it comes to figuring
> > out what node it is on, but I'm hoping to make similar transitions to the
> > rest of enum memcg_stat_item as well (you can see my work for the zswap
> > stats in [1]).
> > 
> > When all of the memory is moved from being tracked per-memcg to per-lruvec,
> > then the final vision would be able to attribute node placement within
> > each memcg, which can help with diagnosing things like asymmetric node
> > pressure within a memcg, which is currently only partially accurate.
> > 
> > Getting per-node breakdowns of percpu memory orthogonal to memcgs also
> > seems like a win to me. While unlikely, I think that we can benefit from
> > some amount of visibility into whether percpu allocations are happening
> > equally across all CPUs.
> > 
> > What do you think? Thank you again, I hope you have a great day!

Thank you for the feedback, Michal. Let me break down your questions so I
can address them one-by-one:

> I think that you should have started with this intended outcome first
> rather than slicing it in pieces. Why do we want to shift to per-node
> stats for other/all counters? What is the cost associated comparing to the

Yup, ack here as well. Here is a bit more context on why I stumbled on this
in the first place. As you are aware, I'm also working on another series
whose goal is to make memory limits tier-aware [2]. While working on this,
I realized that memory in the enum memcg_stat_item had no physical
association, which meant that identifying (1) which node / tier they were on,
and (2) which node / tier the memory should be migrated to was completely
invisible.

That was the original motivation. Looking deeper I found that this is not
even a tier problem but rather just a lack of visibility into node-level
statistics for the user.

As another example, recently I have seen an example of socket memory
landing in CXL, which is really quite strange. (Was it demoted? Was it
through a fallback allocation?) It was only visible after there was an OOM
and I could use the vmcore to inspect the data manually and figure out
the page placement.

I was thinking that it would be very nice to have this level of node-level
perspective along with the memcg association because IMO something like
this has more value in being analyzed at runtime, rather than during a
post-mortem with the vmcore, and there is more we can do by understanding
what was happening at the system when this strange placement happened.

> What is the cost associated comparing to the
> existing accounting (if any)? Please go into details on how do you plan
> to use the data before we commit into a lot of code churn.

For percpu specifically, I think the cost is minimal. Thankfully these
changes also have minimal effects on single-NUMA machines as well.
But let me get some concrete numbers and get back to you so that I can
back these hypotheses up.

> TBH I do not see any fundamental reasons why this would be impossible
> but I am not really sure this is worth the work and I also do not see
> potential subtle issues that we might stumble over when getting there.
> So I would appreciate if you could have a look into that deeper and
> provide us with evaluation on how do you want to achieve your end goal
> and what can we expect on the way. It is, of course, impossible to see
> all potential problems without starting implementing the thing but a
> high level evaluation would be really helpful.

Great to hear that you think this is not impossible ; -)

Yes, I also definitely see that there can be some subtle issues. One thing
I'm trying to be very mindful of is locking semantics, whether we are
introducing any new bottlenecks for updates. I'll do some testing and
come back with numbers, hopefully that can instill some more confidence
with the side effects of these patches.

As a note of concern I do believe that socket memory will be tough
to track accurately since it uses a different model of memory accounting.
I hope that there can be some steps to make it more accurate without
introducing overhead in the socket hotpaths, since those are highly
performance-sensitive.

Another concern is what to do with MEMCG_SWAP, which is not really able
to be associated with a node. But swap is unique in that it genuinely
does not take up the memory in memory. So maybe at the end of all of this
when there is only MEMCG_SWAP in memcg_stat_item, we can treat it as a
single special case. 

Thank you for your thoughts Michal, I greatly appreciate them.
I hope you have a great day!
Joshua

> > [1] https://lore.kernel.org/all/20260311195153.4013476-1-joshua.hahnjy@gmail.com/
[2] https://lore.kernel.org/all/20260223223830.586018-1-joshua.hahnjy@gmail.com/

