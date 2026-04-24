Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B78EFED3EF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FD346B008A; Fri, 24 Apr 2026 13:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D44B6B008C; Fri, 24 Apr 2026 13:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3CD6B0092; Fri, 24 Apr 2026 13:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF666B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:04:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BEDF1B71D8
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:04:14 +0000 (UTC)
X-FDA: 84694072428.30.06620F1
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D9A320011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:04:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G8+La3U5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777050252; a=rsa-sha256;
	cv=none;
	b=wepESWI69yTdBBpWjYFjnguP3IQBay6+xG2cQPzakpTutnhDiJFaQTKpOOPx9hqKY0KVHb
	CXwqxdw78LmuswUpEKOSaRShsQw2mtWCUhsa0vzT6BbhThKugSRUWEGU0GyWVRYuSRcV1a
	WLcUxCDrVj5TQ8Xlhyh9jQ1Gw1u0od4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G8+La3U5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777050252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n86XSIik8J8+AzRhkUPuxV5HTouY06SUAZurklmcJn8=;
	b=OHnyWQ/MIDwhiAwi0kkzKw2BScT/u7JoTvKcLlkGbSQXA4LiNDzD27bwkUihxNusIpiJhC
	0tJHwZROAUO3MEr9eOhHE5Rs/4WbSnDY0mTkxIYel4km3+9lQy9dVoZRp1J3mRHWdX+gfa
	4W+EfYZbpVunzXPHebQwNK+3O15ts+Y=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82cf636dac8so3497730b3a.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777050250; x=1777655050; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n86XSIik8J8+AzRhkUPuxV5HTouY06SUAZurklmcJn8=;
        b=G8+La3U5Bxp5SIcpc1GcgmgFQBNdiz+xf+tG72mVauWCc6QaTLcesnUUWq/Pi6Kqeb
         5id5YAZj0h8Zy8b5gpDXbKI8YyHnvwHClIwLpWZpbxfjYtXeBbe88c8/3GQMRXcxKrSX
         ehHesdOEDJ/Uo6jT2KhZCFiWfHWjJMclb7eD/B2zRWFoQcUeYHTwE+rMZ+6VBp4suDCc
         LFO9ZwAJdSWt8Vh/HZhG+IaPmb6Gehrw8yFz1q06NeneIodA1cjl65Z6fN2h/6tx9HG1
         w1LEFLn4O/JTcDbb28AYnC8CkzbcyDrSSx6BsbeHCBmplexhRBS5BpqknJKtoywmpg4s
         g1BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777050250; x=1777655050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n86XSIik8J8+AzRhkUPuxV5HTouY06SUAZurklmcJn8=;
        b=PbAfmb8JC1yZXpP6VYbLc2eVSzCgx5VATHz5nKPohgwOucNL7EPXsPFTuaxl7jM26M
         b+FiXUNObKQ+8wHjLBqdju0lR9/taO539/YWefv6b8qkWKOVPX7wmLhYcm5RggKskd7r
         dMRlW9pG/w5Uuv1g8YTWMWINSqqAYA4brav/jX6TBMn9yjDolj8XI8cvTLpduxYDN3x8
         ugIVal/2S2PmkmPwiKFoEEdVN4RXTdQQHUHPZKj8oiRoD++SvWwwdlHg/u57bzP+3Dc9
         kwb2LNU61vacKRUEi0VtkVW3dbPV/dTtO2WuWBwj4aTPO8DXtXWR3RjO6IAm2HsEwxXk
         Xu8Q==
X-Gm-Message-State: AOJu0Yy9d+iWja5qYexgWur6+zDLTBq7t92c6gKGsC8LuUA7xq0rH5WH
	vL9ml8zJVbtCvMH3ZVlSg8SiNkS1tlZwH6Obee8EphVaOEqfzKWBacTBrCBW9a25A9g=
X-Gm-Gg: AeBDieunXkyBp2m6SngxiPHSrrTDKmMejwwH52KqcdHvhQPJbH6nghbN5HZNRTNhM56
	DPH9994QpHBPTolbDlH2TT7j9MWcl9cX6asaA0roj6eoJJAxiJX4lDJ66oqlQtNs1APmVNfG1kU
	xaoRdpS++6q4KDQkaAJSNL5Nj7p4QnsA3WW5PGZX7rCw8Dy23WROm5ciGbe6ADTUjBj5PXHPDgH
	h6JLc//DzLMmyF65GO3d7sDN/TobndJro52+2hPHmH+rZq6Q+Urf/+pF4f0xCRnLx71GOzdag+h
	MP7ykdBJzcs5ePabstuPX56UDYnYb3DeWekpWwasPZ5te0jHmpJxQADqQ+F5ByaZgY7QHHQzU8u
	0DBUQfw3GS0DjfDfk3Qy7CeXPinFCkgSnnJdgNsL7lvBmPXG+4esNL2N12EgPBmrI+ut552RliZ
	uAI7GSS3Tc6OPE1apUH7ig7gs/kihQaCVQb3geSS4tVE67TVHF/vmXVeCcv+ULHml0TMUpwA==
X-Received: by 2002:a05:6a00:3498:b0:829:8cfb:df45 with SMTP id d2e1a72fcca58-82f8c861f7emr32089006b3a.15.1777050250230;
        Fri, 24 Apr 2026 10:04:10 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebcc9easm31088369b3a.39.2026.04.24.10.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 10:04:09 -0700 (PDT)
Date: Sat, 25 Apr 2026 01:04:01 +0800
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <kasong@tencent.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v6 04/14] mm/mglru: restructure the reclaim loop
Message-ID: <aet1hd9DfRH4aSOO@KASONG-MC4>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
 <20260424-mglru-reclaim-v6-4-a57622d770c3@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424-mglru-reclaim-v6-4-a57622d770c3@tencent.com>
X-Rspamd-Queue-Id: 3D9A320011
X-Rspamd-Server: rspam12
X-Stat-Signature: f7fwq6bit9eu5q33zk4offywgog67qsr
X-Rspam-User: 
X-HE-Tag: 1777050252-664368
X-HE-Meta: U2FsdGVkX1/bQ7igFhfqIwxTcf0G0TEkw5s0wOlL+aNSbVtZrdxfy76VGg/le0tAiHPnXa+5aqz2IC8EgM3qgoG7vZU6OW4dmLT8qaOAbcheEsIZJkfWIWgOr4Mz/Zx1/rNjpH5RVV3fN+WAT645ryQhLOIpflVdjCiUz8WyfaSqmqnqkRfsCuwMktn04LeR3ILG6F6etN5X6fmXAjZx4Kg7f6hwBY2rpZeaF0o5FTzORoO0wx3LJ+3NSguoBqcSlZ06kK2GVO7pM8w6LwHN/191HRaHS84vuvtb2H5NzZFLzQkmk7Htpi5FGHvYdEe2exRtS4FBMv/urlvJJ89OJiZnZJR+uLnlAZeoFA41wAWE56S1/3nyuxyxn127u0i8B4Eiiho1bAIMrJBNr06TJlJqRhx2OHjr/uEVep5mShvmzXoRNLn2jUh5sqqI1XMkeCdFuquyEpo5X1jA/NufBaiY0D+hZxv4DqJNh+RAwu594T7/B6QDLfAhYTJhhg0sBeMxJ5iTTe9OBP+Q4C6Jdgbg4ljk8elvxawYnM0f3QUBY42uslF+2kIQnNHlnl7pyODRM5zsj+UGjthJn4WiV1XEwX2zPou0BIJN7S0DhBBqpkUQceGZQnzvel2GGAsQ55j0BfC39CBndJK4/ZEOuK8kXxexgdYOLo1oAn2AiDQ686XqK5zbbE7KCKmTKEdcUVLllppCTH9eWnc7eLvEQUSD43zifAQSUQIDAcd8DUFujx9JzIeQqBrQeCLvuqQ/MHZTOHZ8rCjlWs0WJ6+5B+cwW8gc8ikVG+5UtSYFiqXCYvpzdv/QcWJIi8ii9Hy/ZUBoZ90niwNLzKrHjsFYt/64evBejzMHu3U11D0WYC8q95OOl9NaPpWLgjf4mDx9mLhOF9yyezJxcSfE5Xb4QZCDPdiJeZgq4ykbrRzTpnPIZbwtnu6j1f2+uOSxCsp6aXqDCg/uv2c8NY9QBSD
 84x4N0v3
 byEsOj6aNcEPJN2+G3E5Gzgvh+8uk8/g0LixQEEdoqisle3j4rSqqg9bx6eaTJAQtb268yKgurrCMey/b0Ih17ts3nOapIxvae7SsUMW245D6g9d9ZjuRv57bgA4wVsZomzSNBCI4WqfnRmgg/taJoPu2acaljq87zeGSEn3BZ6KgDPPntD8cWqh4PNWQPxW2pKNqWzC4+wv63acWvb7p3LGcoDjsHKb17zJlMyDN+nJwJooksQ8flXq3kBOhzAJp/3obcjdUbsDHY5QVCUdiZFm70qoerqu5hxOOyeNsPq+gkqqzuurIzR/MBBrAzwMp7ag4sDWpIN2iQ///qd53yN/VlC1piR2LvgbV7/O8eXjT2bAusESL/80OqPAYT4zYUFLuMd66IJbOtbQObyKMqKHTha1S2Vg4s/O2hLTgbL+P0GV9SzRue0cITjzPe4iIElYOiRhbtnsJV4ugzb27lVkM3pSp81406fica2eZGqTn/PcRvNbY6pYr6yr+9lAAh/O+Cyy9ARNVbpWAP1BIIMfgaNE57noXjngdjGMB9sVfnXg5ZCOp8Ng79A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko review:

> commit b0a64f8c3f76ce5cebb30c1caa6305fc617888cf
> Author: Kairui Song <kasong@tencent.com>
> mm/mglru: restructure the reclaim loop
> The current loop calculates the scan number on each iteration, which couples
> it with aging and rotation. This patch decouples aging and rotation by
> calculating the scan number once at the beginning of reclaim, respecting
> reclaim priority, and making aging explicit.
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 3c5a6ae9244099..757beb605980d4 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> [ ... ]
> > @@ -4940,11 +4932,10 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
> >  		return nr_to_scan;
> >  
> >  	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
> > +	nr_to_scan >>= sc->priority;
> >  
> > -	/* try to get away with not aging at the default priority */
> > -	if (!need_aging || sc->priority == DEF_PRIORITY)
> > -		return nr_to_scan >> sc->priority;
> > +	if (!nr_to_scan && sc->priority < DEF_PRIORITY)
> > +		nr_to_scan = min(evictable, SWAP_CLUSTER_MAX);
> Does this code introduce a priority inversion where higher reclaim priorities
> result in fewer pages being scanned than lower priorities?
> If a small memcg has an evictable size of 100 and SWAP_CLUSTER_MAX is 32,
> at sc->priority == 7, 100 >> 7 is 0, so the fallback sets nr_to_scan to 32.
> At sc->priority == 6 (higher urgency), 100 >> 6 is 1. The fallback is
> bypassed and nr_to_scan remains 1.
> Would it be better for this fallback to apply a floor regardless of whether
> the shifted result is exactly zero?

Right, sashiko has been very concerned about this part for many times,
it wasn't happy about either design (unconditional floor, no handling
at all, or this version). But this is not a functional regression.

For tiny cgroups the old code before this patch could be over reclaiming.
Now the over reclaiming is no more but could be a trivial priority
inversion, which I don't think that's a practically observable problem.

But to be academically ideal, following change should better:

nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
nr_to_scan >>= sc->priority;

/* make escalated reclaim progress and balance with slab shrinking */
if (sc->priority < DEF_PRIORITY)
	nr_to_scan = max(nr_to_scan, min(evictable, SWAP_CLUSTER_MAX));

No inversion, and no under reclaim or over reclaim.

> [ ... ]
> > @@ -4985,31 +4977,44 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
> >  	return true;
> >  }
> >  
> > +/*
> > + * For future optimizations:
> > + * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
> > + *    reclaim.
> > + */
> >  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> >  {
> > +	bool need_rotate = false;
> >  	long nr_batch, nr_to_scan;
> > -	unsigned long scanned = 0;
> >  	int swappiness = get_swappiness(lruvec, sc);
> > +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> >  
> > -	while (true) {
> > +	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
> > +	while (nr_to_scan > 0) {
> >  		int delta;
> > +		DEFINE_MAX_SEQ(lruvec);
> >  
> > -		nr_to_scan = get_nr_to_scan(lruvec, sc, swappiness);
> > -		if (nr_to_scan <= 0)
> > +		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
> > +			need_rotate = true;
> >  			break;
> > +		}
> > +
> > +		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> > +			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
> > +				need_rotate = true;
> > +			/* stop scanning as it's low on cold folios */
> > +			break;
> > +		}
> Can this bypass critical memcg protection checks and aging when nr_to_scan
> is 0?
> If get_nr_to_scan() returns 0 (which happens if evictable == 0 or when
> nr_to_scan is shifted to 0 at DEF_PRIORITY), the loop body is bypassed
> entirely.
> This means mem_cgroup_below_min() is never evaluated in those cases,
> preventing need_rotate from being set to true for protected memcgs.
> The reclaimer relies on this flag to rotate away from protected memcgs.
> Additionally, does this skip aging for empty offline memcgs
> (where evictable == 0), since they never enter the loop where
> should_run_aging() is called?
> The commit message states that offline memcgs should now be aged
> to enable further reclaim, but this bypass seems to prevent that.

Pretty much a false positive. Bypassing the loop body is not a problem
at DEF_PRIORITY, as there wasn't aging before either, and the rotation
for below-min memcgs is already handled by shrink_one before entering
the loop in the global reclaim path, and is inconsequential in the
memcg reclaim path.

And for offline memcg, nr_to_scan is never zero unless that memcg is
completely empty. If we got a lot of empty memcg slowing down the
memcg iterator due to missing rotation, that's a different issue
and not related or introduce by this patch.

