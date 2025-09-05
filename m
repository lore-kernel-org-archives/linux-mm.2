Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D04CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37858E0007; Fri,  5 Sep 2025 05:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0F268E0006; Fri,  5 Sep 2025 05:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B02A8E0007; Fri,  5 Sep 2025 05:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A30C8E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:42:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FFE613BD0D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:42:14 +0000 (UTC)
X-FDA: 83854705788.01.C6402D1
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4F35918000F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:42:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UTKVHBh2;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757065332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cF3nbEEsUR8WnbK9SQ1WTh/tehrYBkeXJ+lrjf3eIw=;
	b=c9EwOF+Oj1aZEfE9s5FvmSEGIw1C+BaXvc+2OzOSWTr3woBq/JX8KOmNhwymJVVg4B8ywB
	0JzEVPVrcu5LyOiLutPGoWRogxI3pxuFC7TSEVqziFtS/QeyngOtM8s4NybMaDuujpIAwO
	XI0SKCyqc+9gJ24OOBc/TpsZ1B68quc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UTKVHBh2;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757065332; a=rsa-sha256;
	cv=none;
	b=4GCPz0lWh6dfha0EKRmB8pmCA/7KRqTzDMcx/yG+vWBGHIBI/GUEhtBRavjj5jy9hS1xGN
	n3p7euXd/Ma0HhmgWVkJkT41ih6Z2MCiqbn6c1ckAssXUFAfKImmhAraPf8PALul9JZGl3
	7UwYJ4EKsb9saUbMFbGJGjbGMBkctVE=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45b8b8d45b3so18327695e9.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757065331; x=1757670131; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5cF3nbEEsUR8WnbK9SQ1WTh/tehrYBkeXJ+lrjf3eIw=;
        b=UTKVHBh2n28gZv1bG5hZK5StyhqPzfzADpohb4uET3oH3rMyGWjCjYEAlZtcBWeP+g
         OXK/lUbmQ4zZ78FVK+vBRyPt24fPbXslE9QDM2lNtTFjfTBMkvsgLEUcZwV5phTMf9LK
         R/FVbaRcNsXM1zSF57Epw59QyI5DRqt4+9ci+uMh9ZhTpmJQsFdY+rzhTYGDLCHvMhKl
         WWvROSRMrfLNeDPPS367OHqDpaQ2RI4atHfObAHzDVunr8NPIa+37OuJzy2S1o9l9Cp0
         ElfUAEhYOfluyRiUPqI7+ZXiby5zx98s7jNLw8mLS4LRQyXfd2/7Y/AM0qwWvJ97W7zD
         Wo9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757065331; x=1757670131;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5cF3nbEEsUR8WnbK9SQ1WTh/tehrYBkeXJ+lrjf3eIw=;
        b=JxYtbQgKxomBDPaXQoIxyUjl+L2IpcbQksUBtlcEKfef3CAsLbqOffEB6N3BH37X0S
         Sg48zegolh1ZVY5pVqwjWa7cL1kzwkIEPSidUQ8Dnd3cxH1QGihwXpvDpUy4NNR2kg5j
         QFXR2VV7JPCqpnkMVuejyT9sx9CZrtBi6fh24kXhHjNlsTByGU29YvMafptrIj8CgWgE
         LuOU8x8BkO6PT7qdK6pazQ2McIs3hc+x40RA8qkI+Hu6bu9er5/6DhDW8QR4tDqEoUPg
         QXyvlqfGI09Ix6nUbasWzQD+1Oiut7QdvsQSpluOMWbOvr3t113bojAESVlyd/9Ugw/E
         9K+w==
X-Forwarded-Encrypted: i=1; AJvYcCXKCJO8s33jKzHFXGhUYNotzX2Ndt6HmeAMxmms1/jyHZfhxRI3oU11d91NqsqGjUgVcuI7sCQy9Q==@kvack.org
X-Gm-Message-State: AOJu0YzJmfmfB/ccniBZix6AYANyAR9LwSzzwp6Bki73qAHKj9rJT4ZB
	NPlId6AivXXyPWuhIHrGkvtn3iqYXP8oo62+MliM8w11VXR6ZnNWm7zBSz5wYjM7EWYi4+3hB+O
	PUXuo
X-Gm-Gg: ASbGncvdeemCQ2/fCY0vWWNmMcR1s6/jTlWiZKJ77ey9h6ZNO2Pp+AO2HFGuxm35ngN
	4zbyK+L5qNi+b4r4MiGLQRW/V4CZ5PWq4PAbTmBpH5H1/KI8iOr1IK0deuG0rRk56MKu6PwJDA6
	0SmbIigDnuNIaXbZzqYUX+Z7JB34JMnSKLef9zGVQC+CkNQD7UFdo9A1lJMfVp25QZP9jU4/HbZ
	Tn5NIK2Fzd9OALx03DgAV2UAl9Cg/wiup1586VuE2wDYuXfZa88IeL21WS29ZeadKmKzquJ8GPY
	B0Fkn9+XoI26k7vmYCNmaG/vChjzdM/dYh9Fg+JoRtLXz/8gg68kHgHtn7Fs9A4h8o+XWLbJHAY
	AJTDuukiN+nqBZJacI5hmE4L5OJKIYJMad9b16wkiN00=
X-Google-Smtp-Source: AGHT+IEBLrXRp2KCZS6+xHdnkZeuu3XXC1zndCZW60HghXtSplaPkTzQ80wMNW+TFzKZNFfyFQ5ZDQ==
X-Received: by 2002:a05:600c:6304:b0:45b:7782:b4a3 with SMTP id 5b1f17b1804b1-45b8555d31emr157150355e9.14.1757065330803;
        Fri, 05 Sep 2025 02:42:10 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45cb61377a7sm113904485e9.13.2025.09.05.02.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:42:10 -0700 (PDT)
Date: Fri, 5 Sep 2025 11:42:09 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	david@redhat.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to
 cpu-less nodes
Message-ID: <aLqwcXHzsaTxN3dM@tiehlicka>
References: <20250904134431.1637701-1-tujinjiang@huawei.com>
 <aLmhbjtF0Sp75XXE@tiehlicka>
 <f088cdda-9799-43ef-a4f0-fba563be4076@huawei.com>
 <aLqadzgmyGGjSck6@tiehlicka>
 <87e085b9-3c7d-4687-8513-eadd7f37d68a@huawei.com>
 <aLqo9NKQ-xDfJ-14@tiehlicka>
 <69180098-9fcf-44c1-ac6b-dc049b56459e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69180098-9fcf-44c1-ac6b-dc049b56459e@huawei.com>
X-Stat-Signature: upgi4epjhww9cqs8tdex8psc5hxts7rr
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F35918000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1757065332-612387
X-HE-Meta: U2FsdGVkX1+4l2wYa6IenK3UzqGgorb1weQjCq+ofW1Fk1yWPtxEc3TuNzFfpllPYs9aOVqlwo59xsNbTXTYUVY0KasaJrrVysPjZ5R4C31wrR6bELDonwE6KTUUmQDFlDyTWJMLEnvP/jQ5NZeTLgEyFYa3p8lfMMYIei7zvLiNlf1ctmmhW8BkAPIqoaTJHak+dqr3uJX8UAA/GopZq0mtc6WJpjE0B7d8z/0kT/NMYH0/ICPu6qmlfXV+6GFjU+L86kDnU5362QTD3P69DBi3oflQFFTW02L8zXT1RTELhl5Jypb6AOoIaAd22H33goHTGctohyC+A3WwA3ImNh1jF39cGcKE96OpzGOWcmQNxpIZRJs0dvLx9KK/wdZQZeHwJ3uFI23cMISJX2sTFFUzqzCOvvAq31FW6BoiPwO8XKP/qT793L3eTUWMcpivog9vqTHKbXK90F9JUIr4VTq+QAlFSYi+88X+DktYcKmGInrrYGB1qNLKkub5giIDiFtMoaazbdmM+rOCTkzUwBFxmUbhfAAC8F7B1DmJtC0+uqBdgRSnbrEOETkvsagzLEHJ0CW+Ys/aiWm2xmwSNFOBBBurE4awWjpecoS+98GjcEkfhWrqfI7glYBEgVJbnYgcWtNCMyBjiVsZKAMs+3GudI/pX2Y8JZVgtzicMHt/MzDCcha5rAEaP084vNDjzy4yZT/p055Tls9gL5Uth8TNtIkP+qXdxWiQl8D92rVJswR4q2wHU8qcwH2ChaVOFZoZ9UEhN7vSG7sk6L4TMhi82XQPjJqc3LTBQbVHH+xokMz7PybhqeiG37kcx3xlL56bf9eXV+KgOe0n9wV5T01UPUlRi4psaUALHxIluKHxTgXMl0uaYe2wt/CrpIdfsgoTtXpP1okYoLoM61C6WJ0swxonkFH+XFtj3ygM91Bo9bkYDmXmge/GtC7LzPQ5HDeldR5PkbJ7mFM/JBN
 1euO3fct
 6IB5NEjGHPRrKD0t4I53Gr1pDLqXvppvJMhEtB+snhAP/uo++eb2hJkW1+hjSOuZeY41xoK4SCndou6dWGq2M/puipH+b54blpCMoK6Z0sRU+MhwWew0SNjLEm38CjMEbA/lZ0UtO9NXOGguQsl7C6AYLUdFUpzR7nIw+GQpiF9bIXh7JuIIdhoSf7Pl8TrnH2lLaTcvp9vIGy2VjAJZKbyP9/r4+mH0aik57HaIpAAJsY7R62NHGZ01J/M4gQbHJV+/Z0yupzsgGGK5Xq8GcB4mc8LT2ecpfJ01p3t2SrBbNAY1W4wvwn5BseUL/aXlYHf0Y6v0r5hdfgyGt+Mrn8PD1oBFKwqQQJjpBTacBUsdP35ndzG6vjEWnHmjo95mNOYu8FmUlXoDsLbeRckYvC8eARmUjDYwMB5IlqnEnc5stCXxrEmrJ2Zdff11p/GQYOK3v6unwFWh96iQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 05-09-25 17:25:44, Jinjiang Tu wrote:
> 
> 在 2025/9/5 17:10, Michal Hocko 写道:
> > On Fri 05-09-25 16:18:43, Jinjiang Tu wrote:
> > > 在 2025/9/5 16:08, Michal Hocko 写道:
> > > > On Fri 05-09-25 09:56:03, Jinjiang Tu wrote:
> > > > > 在 2025/9/4 22:25, Michal Hocko 写道:
> > > > > > On Thu 04-09-25 21:44:31, Jinjiang Tu wrote:
> > > > > > > out_of_memory() selects tasks without considering mempolicy. Assuming a
> > > > > > > cpu-less NUMA Node, ordinary process that don't set mempolicy don't
> > > > > > > allocate memory from this cpu-less Node, unless other NUMA Nodes are below
> > > > > > > low watermark. If a task binds to this cpu-less Node and triggers OOM, many
> > > > > > > tasks may be killed wrongly that don't occupy memory from this Node.
> > > > > > I can see how a miconfigured task that binds _only_ to memoryless nodes
> > > > > > should be killed but this is not what the patch does, right?  Could you
> > > > > > tell us more about the specific situation?
> > > > > We have some cpu-less NUMA Nodes, the memory are hotpluged in, and the zone
> > > > > is configured as ZONE_MOVABLE to guarantee these used memory can be migrated when
> > > > > we want to offline the NUMA Node.
> > > > > 
> > > > > Generally tasks doesn't configure any mempolicy and use the default mempolicy, i.e.
> > > > > allocate from NUMA Node where the task is running on, and fallback to other NUMA Nodes
> > > > > when the local NUMA Node is below low watermark.As a result, these cpu-less NUMA Nodes
> > > > > won't be allocated until the NUMA Nodes with cpus are with low memory. However, These
> > > > > cpu-less NUMA Nodes are configured as ZONE_MOVABLE, can't be used by kernel allocation,
> > > > > leading to OOM with large amount of MOVABLE memory.
> > > > Right, this is a fundamental constrain of movable zones. They cannot
> > > > satisfy non-movable allocations and you can get OOM for those requests
> > > > even if there is plenty of movable memory available. This is no
> > > > different from highmem systems and kernel allocations.
> > > > 
> > > > > To avoid it, we make some tasks binds to these cpu-less NUMA Nodes to use these memory.
> > > > > When these tasks trigger OOM, tasks that don't use these cpu-less NUMA Nodes may be killed
> > > > > according to rss.Even worse, after one task is killed, the allocating task find there is
> > > > > still no memory, triggers OOM again and kills another wrong task.
> > > > Let's see whether I follow you here. So you are binding some tasks to movable
> > > > nodes only and if their allocation fails you want to kill that task
> > > > rather than invoking mempolicy OOM killer as that could kill tasks
> > > > which are not constrained to movable nodes, right?
> > > Yes. It't difficult to kill tasks that use movable nodes memory, because we have
> > > no information of per-numa rss of each task. So, kill current task is the simplest way
> > > to avoid killing wrongly.
> > There were attempts to make the oom killer cpuset aware. This would
> > allow to constrain the oom killer to a cpuset for which we cannot
> > satisfy the allocation for. I do not remember details why this reach
> > meargable state. Have you considered something like that as an option?
> 
> Only select tasks that bind to one of these movable nodes, it seems better.
> 
> Although oom killer could only select according to task mempolicy, not vma policy, it't better
> than blindly killing current.

Yes, I do not think we can ever support full mempolicy capabilities but
recognizing this is a cpuset allocation failure and selecting from the
cpuset tasks makes a lot of sense.

-- 
Michal Hocko
SUSE Labs

