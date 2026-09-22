Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692D1C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B96A6B0096; Tue, 22 Sep 2026 11:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A666B0098; Tue, 22 Sep 2026 11:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458366B009D; Tue, 22 Sep 2026 11:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 157266B0096
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:20:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9CA30140536
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:20:53 +0000 (UTC)
X-FDA: 85241760786.19.ED352BB
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf10.hostedemail.com (Postfix) with ESMTP id B244EC000F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:20:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RJQmClJj;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790090451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GRx/g24FB4lP9hKxncW6XGKAeFROn+FyWjD+Llh4VI=;
	b=PcHghcW2OrGEf1QWOTTLBDZiR2d+hCSb0eA8lCqsuYoJ3ZXV9uYHwbQhkg65hSfo1psGSU
	8NzP0Ol+KvvGWwL/hLPrB3dS1UXhUoTKRVD8iZixZZ3DMTRUcNj4zCRZ/l21/PQ2Hi/L5A
	AefbjS62ZdCApVLPLY3Xu2/3VSEwQzs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790090451;
	b=ANfvr+d4NuW9oJZwm2+nBZwFd/FUjmHjgceDwUCZwmYOkXPyJCLCrGDahGzy/U/ssYRKBP
	Hebn+NQx8fwOsQj4GIAoFMcN1xyA/ZKR9l7lIdLcTvyDc74H06reThgvA2BpSmU2eWc13N
	0vmsis6v6B4TftN8Wlabr3Sxrgmg8Ic=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RJQmClJj;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939109fafd6so3191585a.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790090451; x=1790695251; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1GRx/g24FB4lP9hKxncW6XGKAeFROn+FyWjD+Llh4VI=;
        b=RJQmClJjqXBzrTi5LoAxmQAMjV6C2pRTblMznK2q9G4nbyQwR+e9CwezW5OTT/XUL6
         4eWafaY+dv12fkkPR2UEqcLupSdTdbOvkxPqnMQEZ+czdY/3c87kspfCpkwgxuHoUaLp
         0Qrh1bTXXhVxWvmp5wyR8QljiwTfvPavo1Hc8x6O/xDFC1GnFPdeaU92kI6f7q8eux4X
         r/csXLmRIeQXY71F0eyzTq2CscZ+kjX6Rky41F54YwKorjjYdZbfPnUUh97m5xuykuyu
         fdoSu8PKZ9brphRt4qmNeKsK+Zq8gxR84H5TlTTEVBZIvXWaDA2OATKFhsvkKMT7vzgD
         OlWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790090451; x=1790695251;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1GRx/g24FB4lP9hKxncW6XGKAeFROn+FyWjD+Llh4VI=;
        b=Woo9YV3XEJbpo6Sdv2vbs+qbJ4USQl6MuYu4cZ+o+f5RkP4V6avOypyvgTSwOQ0dce
         rKuqB7ME1VxNNcXr7WpgJj4gq6EvZf8qwdsEDgeoo0imCq5yiPrSp45cLIUZi475oj+i
         FsPCxRsrlPlANGBT2PNA1ZCBbs+vJq/vFqSq8w/5BzOC+2H1k3UKu5bWtDjJyJwgfmJR
         1tVPu1x3XW86HupNbDI9le81oA+h1LRBnWyNl43TCeJrFDdjUYgx5atJjpM/pXycP0uX
         Z2UHAXrUjkt/wtr9bxbX+JhiPG22uW7Y8v/9acVUKMioxNrNYMlchxcD+8VPnbNlARLa
         0NKA==
X-Forwarded-Encrypted: i=1; AKwUvByFd9etbHGf/Fb6sida2QUbw21aQ59kUksvZBfqyfrBmOtnvoLL4gyzr6vc24dc5VIbaMUEY1hjdQ==@kvack.org
X-Gm-Message-State: AFuF++lk05DsZLqKTEArfG9vTZdFD2vyUQgM/6PNeqmIks5Xit9S1qny
	S8jS5S34Vdw06ShOO7I916hfb5LFCKZPad0ZXPZbww0ylCf/BfNaoE3fgkwq7nB5JP4=
X-Gm-Gg: AYBFou3brnQdUEIt1DQDVKdiPAH54WfjptSmYmg6N8Z2Z184Ys158q6Pupta4Hj0K9O
	HDsK8dq6/DDRznxqpIO9b3qQOpuKqV6yi06VQlP6rJA4/VR9sNf/7BGOUlttTJi3qhxYVU+ui6K
	rrFJiTqlvsAFeHKlICBnbaNdENfzyQXq9YdXvFLGqXXfzyHeOA2qBZOEVb5HXHcP9pZV7qCvFjw
	4V9cE+kPMfvCM9kaTjeOM+QamVJ4ZONp+TJQgRpdDXk6krHA+G3Z0WQ7CUyzmKFDe0JqVdEQ51p
	euKqeeREdvgZpHrHPC89PHRgpk9nZ+/nzXMUuzA2YdI4vpt3Wjt6pAXooZ2GUzcSQPWhxG4g74M
	ppdEBOouaiiHDoGmQS6GVkGDCXbCQ9wIhva719dQ4l8sG96pD5S6hsjd5sJKbbjxbiAbsAOYIKi
	bKdi6ZzXLSJrmje5/K/QjIO3A3HZfnwvF55eK0xvfvebkxg7J90UCTtAjhx01M5Q7oFnoy5wN96
	rlrI+IpFUTcsqh5N0ooUIYXR2u5QvLBX9R0cG8YjwYrEQTdbTBSUe0=
X-Received: by 2002:a05:620a:280f:b0:93b:e9d2:5ece with SMTP id af79cd13be357-93c15e412a9mr594708785a.39.1790090450524;
        Tue, 22 Sep 2026 08:20:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c1cf0dcd9sm181244085a.4.2026.09.22.08.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:20:49 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:20:47 -0400
From: Gregory Price <gourry@gourry.net>
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
References: <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: ncr93udothbuwqxkpo8wkonwmuuyqmsb
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B244EC000F
X-HE-Tag: 1790090451-39247
X-HE-Meta: U2FsdGVkX19LlWzSROhCTLxaJQSpktAHlq7Lxa/QvNP4D1kyn77dU0Y21zeomAp1+F/WTJKGKRGjt3AV8JUpsc+7N6OTrgyUodbtFBJ59G0CshRORMgD6+xI/bmdHtUW/VvjVUNV4XcMZeqQ+3G1pdpdhyd6QBv0JngOwtdFSxGmdkUO5qjZLmsR7lWn9pqZG9LkTaQrhTzSpQcsTaJhRof5aa400l2tInONWZgsKNWBbzy+ANDjLW2o8DBI/24HvUj1daFRU9aMj4rbiDX05U9HMSFChRDKY7wv49MtdQVSjOskTKhXx3Zz+yBZTq2qJDPKA8S1Xi76tKx6qFjXuWq+VRbZSKfygf6/YhV7ws0x8FgsKYhbSdLFG6eygkVYzHFj6J7bofrzRCaMGmTQn8Ed5L1ue3TGvBH5ZuxcWHLX2NudDE0hKhzALu+LAFa+C9EUBtiGkP5z7vZoqMPLZzGl9OStmmm7VdiUuqk/C5hmE/RHvdYaO3S4ba/NgnAVNb5BpmC/hxQbfFrlaBvUX8MT3kvSiu+J/ES4exU1nWnWgEah0YpPsfTfNtM3Pn73XBvcPTa8405pauR2Gq2B/yI9G6L6qOnPdu+hgHElChJLlo3oZNnZAxI890YkyBDAzNxNJCero7dTz3g5/WCMjPaOKawpAgdz3b1koTUOf2xSy8c4KnCxt4Hzl+YNJLX1PMDWN0tQZT5q6L9/zTksEW587PmZ+JuWDsAfVUL+Z7YWzoPraKHwGM/VI7PXx0Hv4WP1Fh3DLxbyXcm5smm14QouA+8OM2xdNAjALXA6C4rGdUQ9dJau6JR5KcNz2puMsI5eZSBJsX3rAI29eTYQsLQpX30FDVeIkR5RdRWDJQqPKJ7u/WMftmUfXgree7TddgwghOMM5AwOgoJDsu/+Oh63ZToJWC/0hRjjC4876SF3TJxfTjb7hpdI1iOnQtKFfWI6hfEBDG8yJxAPPER
 PMlefy3s
 b4xbzIkrjT0IuVbYzXgseSfKxOXfFp3xWNVptnC4aQj7ostEm0iJYX7wcHRSvh3MbvO3QB7RbGOJlj5R65Ik1MgJS3P2FW0P3bdNkq6B8c2ZXZiOF0terdtYEp6GPz36Ln1P/1ATeJy69YcJRGcWsAN0P2BobI9O6NukogJuztUXj8mAzwEiHoyy0OxrLNupXxUikV8kYscSevdtGe66c1US3A0HA2eDbphvd7+atUuWrfLGHo9bvEoEFu+Z6SncnOAuder2hC9z690+L/0GSByeeowbpVB1fgq+cs/e+hGJlbv+XyddHcypLjpDEvP49gFKuoq1jo48jT088Fwl6FuTqF7G31zzwdFHJjuMBGFYs/DO8yoXkZQ+vi1OGvTLoq+WvXS6l7Xrmy9xEjE05fFPyMZlDVMA61MYOdzmX90q5PoRkrRI/0G6GVyLmv7BL0yI7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > Right now it has 64GB of memory.
> 
> That is exactly my point. You are running 1/8 = 12.5% system ram.
> 

Chris you are missing the point

Zswap:           8812236 kB
Zswapped:       24927876 kB

To support this, you'd need to know you were going to get a 3:1
compression ratio and allocate 24GB of storage (24GB of swap slots).

An hour from now he might run a workload that's 4:1 compressible and
there would be 32GB zswapped - but if he'd only allocated 24GB of swap
he'd be limited to 24GB arbitrarily.

On a 1.5 TB server, that number is oppressive.  It's 192GB of
potentially dead storage space.  At 1 million servers that up to 183
Petabytes of pointless provisioned flash if you know that most of the
memory is zswappable.

You're focused on the wrong problem.

~Gregory

