Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC78CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 03:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4671F8E0003; Sat, 27 Sep 2025 23:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EAE78E0001; Sat, 27 Sep 2025 23:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D98A8E0003; Sat, 27 Sep 2025 23:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 109DA8E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 23:26:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A467E140978
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 03:26:54 +0000 (UTC)
X-FDA: 83937222348.11.E2A1EE6
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id E3EC840002
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 03:26:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FB233T0W;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759030013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JYjWj6SPzTopScrc3ijtyz3DSAa0PG7foi8MaTlt/o8=;
	b=tlOYE08y1+ZkGGwm8eOCkNjZ0wVNWfdosYRpLaQew+vc2xBHCrkDZ5joypzf5/ueNqGiER
	uC78I2zy0dCwiPs3dgJSJ+MgqLn6q071DjBws7N5bEoFjoPHEVieY3as7fcmkOX9g3xvwB
	ItiScHoaJ5Wi5q8bnxtvaP+v8ZUQS4s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759030013; a=rsa-sha256;
	cv=none;
	b=y5SggtQBi3EQvwsX8GHSNGvdmNZNUe2PkPGPWi98NJGiIMVuDocDIAs+5aajTNM3U63zkB
	en+kiHRvVRPZFEcKeB3qxVsMnJc9Gb3iI1pE+B7U865PvRYSEUbBB1pn3V4UKgsMOFmlNp
	j7Alj9Tsdyvw1M+L9L2Li6Xc3Vujpc0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FB233T0W;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-27eeafd4882so217915ad.0
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 20:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759030012; x=1759634812; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JYjWj6SPzTopScrc3ijtyz3DSAa0PG7foi8MaTlt/o8=;
        b=FB233T0WC1THLyY4uZ5r8bZEhCC/I51BeQ/xD4c6utCoky/dcyQ80ZoYTyYiswDr9J
         9qZWVGPntF7PH9SrI3iaSvJ3CeSsu7KrtYeDcg6/w6/NrwSwvOljMn0TT1+kOeYxSuYh
         itrWlSo0K+Fo9A8wtC02pb+ua0LIunF+tTuml5tSY30yTA1yl0BHkInhtKpuxU2U+Iyo
         OUWaz3P0RJo0pWFoL20xXSgxB/NQpZye5euJZ0fYzifFPqKYcKOIX1UwEpyZIwjUp72h
         v8z/U6E/ORN0KMkdh8NeVJ3g/01GmWtRha4+LBl+Xz3mks4UvwcW9ZcGuUcT3T25nMZ1
         bZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759030012; x=1759634812;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JYjWj6SPzTopScrc3ijtyz3DSAa0PG7foi8MaTlt/o8=;
        b=WEJEHfMsYWebQoA+DzREehc2HMkZHx+C1UqhJDGCNEz+C2yGPGL9NaCkgXIb9+bOyR
         vtT+zefynl/5FG69BURIbyXrOOSu+Y6ltpQtdSJJ71xCm6EPU2fcOGMbhPQRtSv2vjqD
         qsaBBmc5/NuCh8ce7E9B2f5CGqV8M7KcXCZUZ+CJraReTCQT/6yrBkCiV9GHAbYHUhxJ
         DvxUMJTqisiR2W38+TMoXC0Tk77/eZ6IPWNQce2x+Nwa8he7H68GjXwGhuDYQ6OEZRcG
         mHgTvTu4ZN3CDrW0DkFvAIT9Cxqdf+hmwfYkiLgsl5aSBQwXxCa7KJfAeRM3EJc0ZJ8b
         3OMQ==
X-Gm-Message-State: AOJu0YyT+JfWFkRjOJZrz4CAj/99kzDo9owvXm4z0WISZPiNl7klSlL2
	EkPT6lsQt0FnkPcm46tRXOVLiSTxdQqtvpeNUynAqQXFt5T5nO4vK9r//yTq/7PRGw==
X-Gm-Gg: ASbGncuYj5glK7Km4Qkvj9QrdPEi/G6gIaNgjyr58f1mYV+LvQqMkAPJ2oH8nTxb56O
	Zs0ulES6AVrDmlmMXLwco2qvxmxeRlkxNwWkAbCmbxrzA2kHXxvbswGT7hHNM2I9PqPEIJduHDO
	ZviepsZSoKYDV82rMEdrl0xRbTpjos/kaC9LZJJF5K3TDkZvpuIZi9zA8IXV5DtqQ6f400IirXW
	bt4E/JFVprNkmU+0NSDO88+ddAzKHeee/RUcDh2WMv+qFJv3GJwWcYwPm3VsTySTOomD2+KdKbm
	xdfbzITMt7d1pioq4VTw4SrcyrfG5R0DfZLGHzAgQ/Il3qb52pb3CnXjdgO1OntUDHKMzTQ6H3a
	EWIIHTs0w8oXW+3FPGcM3uftuWqmmZR4+3m8JoqDBebYqYSbVcmW3UmL1sfWPwom/OE3WVlcDNj
	xfK99LogWrWlG/HuXcpLa0cKYhRWjcoAb0GZfZ9pbtQpP3L0dL0PBAm2lh
X-Google-Smtp-Source: AGHT+IE+igN23QNeTFw1VxAhSisgl5kIbbdi92vIFMpYDAIWVZASwgWytLAQmKA2OZqLFSNTMWrKjw==
X-Received: by 2002:a17:903:1cd:b0:26d:a02f:b046 with SMTP id d9443c01a7336-281616a4295mr4346215ad.11.1759030010799;
        Sat, 27 Sep 2025 20:26:50 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:3b46:f010:f7b:b56e] ([2a00:79e0:2eb0:8:3b46:f010:f7b:b56e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed671d8bbsm93312425ad.59.2025.09.27.20.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Sep 2025 20:26:50 -0700 (PDT)
Date: Sat, 27 Sep 2025 20:26:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from September 25, 2025
Message-ID: <98d72dc3-c2cc-b636-8a26-495870ae0f95@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E3EC840002
X-Stat-Signature: hahrexfy8jskcsdozg7fjazpicgjyjta
X-Rspam-User: 
X-HE-Tag: 1759030012-315198
X-HE-Meta: U2FsdGVkX1/ccEUqwAxYOqdlvj7UyGkkUvuTbDvWV9HEbxI3LHskGvObQ8uyUui2KTZ+9WAtopWpwaqtqvpXpSjR0Mx4ixKxFKFV6h5N6hIzRTj0k4njqmg3gRCktxsG+jfI7c818h8RobujLPScK7CDbchijuuffgmteGKhZPQ/F4Toq+thgw16NjowkVdZ+xG7LcPjcy4AJrYmkDyUe+TeGNn3xO0YpIqGXpmVaSQgGQXc3ShsJAacc2NPWOdDsHGAYbfTaezBfOEpW2VOXG34dFz2osV2dG6oeqtYIsWGCz+zZt4b6I+MNXKSfi4W/sbYy0bqiOjrw8bfB6fT2rdyNJBQhp+JKvtpdq/sj7gIDnCh6q1F/MXfjrYU3/TPQofxUjHtTtCNFRyUAf6QAy9py10WLABvpCCcL4X0xzxsBB6Weria/IHhpkb/kg+laVe5FNw2J7zatYxgKpyw80PydNjK+ShVo7KcgTvGQ5s5SdvVdMClRyePyK9Uyc5eARR3Ov7o76im13wmciyzGizuqB02v6ZhUYusC7x4BaxyuPAZJjNymvJfmpvWpBZ+hlobww8iTdnZDv13jQvR97+ZNrqvb31lkCGSD6igLUyWIOKemBRhrOc+DHO4ESxidI72HWMQE5XzEAtpIZoi4EjIMFuLlZNP3ggsp81NeX5EXucy0yQfBAzm3flnf4o08jNbOjWvRVeDE4wLqFBj3ibP0qo89KnJPw1TDndXNYdqCrIGSg5aOenQxYgW9PUDt/oJu3gA7byGwxufdSLC3/Ptsp3Aj3uEDeHrOar709dKz7TSjJbWyUPeNlzty2Q89iXXzPPYlKAI0HNh06ApBNEdn/ZYWEDT+rjlzDt1Il0GsEaJe+2GCSvkYXzMLfsBJQ/ZzhIu4zKxqkesRsdsTag4+jtYepDbq5/eBdw0nl+iPr4RGKnjvHZ0GTCVf/KgsvS1F+9wC3eFsyO4/vK
 AYhbSvy+
 s00MaleXD3ie2j9g56R+QfaZ1qo2uvMQllj23GKNPXJX6f4M+5eN34NgqJPAVtwd7GGheRkUH/I5kW4Nbnh3m2hrX+uhatirccY/LSRJMQyjr3M26KthwP25Z+3rR14R90LjSKlfKtgtG7n3+tviHmmXcSzK1ob05CKIF2cjqDmwmD0ZmkWtMovnJsKFVxQSmUK4wPJ0tVA5mipUWiwAkEhwqDSRI0RQiXlPkPhnKARSi8SHYXvhitX5di9vUzRKj+f6kljVfHEIOpIBr/NdabCAEOaIF8ptqa7UWbYCVi1p8eaHQJc29eV4GdSmsJC2yzCSJJZxUv6fX8y/5vz5GfqzSRQ2T83xq2RNHtu6QiNiiKra70S5xBzfS1WPrRyxGW6UTEvXsuktghdW09V2tiRh7n/nav+cX1ZR9PHa0CjyDOZDXQRmQVai/PL4SPca51KhnmO8Nx4kSKWFqZ1ECaJRozUmJIcNB+LAk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, September 25.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Bharata updated that he is awaiting further reviews on his patch series 
upstream.  In the next revision, he plans on doing pruning of the hot page 
records that get accumulated in the hash lists that end up being cold.  
Today, they end up getting cold over time and aren't pruned.  This is not 
expected to be an invasive change.

We talked about the hotness abstraction and its current level of 
complexity.  Bharata noted that the current hot page record takes up 40 
bytes and this was definitely something to shrink.  Bharata suggested to 
have this discussion on the upstream mailing list so others can chime in.  
Jonathan Cameron also volunteered to review.

Raghu was investigating how klruscand and his patch series could mesh 
together.  Kinsey further updated that he is working on the resume issue 
for klruscand that we chatted about in the last meeting.  The API is 
included in the most recent version of Kinsey's series so that should not 
be blocking.  Raghu is looking at that API for integration.

----->o-----
We chatted about overall CXL performance and the kernel's role in memory 
tiering, including current support with NUMA Balancing.  My suggestion was 
that the kernel would always need to be the source of truth for memory 
hotness based on any mechanisms that it can derive that information from 
including Accessed bit harvesting, hardware assists, CHMU, etc.  
Additionally, we discussed the shared AMD and Google vision for kthread 
based migration of memory for optimal placement.

Yiannis asked that we separate the topic into two parts, memory tiering 
and its use cases and then kernel driven migration of memory.  He said 
that memory tiering is shown to clearly make sense.

----->o-----
Jonathan suggested that this may not be discussion to be focused only on 
tiering, but raher this is just NUMA.  If we address it as just NUMA, this 
is a different approach than specialized support needed for memory tiering 
and grouping nodes together.  Wei Xu noted that NUMA Balancing assumes all 
NUMA nodes have cpus today.  He also discussed the implications of both 
latency and bandwidth for CXL devices; for lower cost memory attach, 
devices often intentionally have lower bandwidth.

Jonathan noted that with traditional NUMA, bandwidth for the remote socket 
is normally already an order of magnitude lower than local bandwidth.  It 
may not be the case that this will always be slower for CXL.  I pivoted 
the discussion toward how we would achieve optimal page placement for this 
memory.

Wei noted that for memory tiering, demotion is a type of reclaim and this 
is based on memory tiering, not NUMA.  In other words, we wouldn't want to 
migrate cold memory simply to another NUMA node in top tier memory because 
that could be detrimental to other workloads on that socket.  My read of 
Jonathan's comment was that we should optimize for page placement based on 
hot memory for both NUMA and tiering.

Jonathan noted that for memory bandwidth we have to consider weighted 
interleave and distributing hot pages, i.e. if we have 10% of the 
bandwidth, we want 10% of the hot pages in that memory.  If we migrate 
everything to the fastest memory, we don't get optimal bandwidth.

Ravi Shankar noted a recent patch series[1] was recently pushed for 
interleaving of hot pages and not for the entire memory allocation.  It 
identifies hot pages and applies the interleave only for that set of 
memory.  For other pages, we do demotion.  This is trying to optimize for 
bandwidth expansion while doing cold page demotion.  If we can do hot page 
tracking and apply interleaved weights only for those pages, this would 
optimize for bandwidth.

Joshua Hahn asked if this results in too much concentration in lower 
memory tiers.  Ravi said demotion in this case was only triggered when you 
hit a low bound of memory free on the top tier.  Before that, hot pages 
are interleaved based on the weights.

Jonathan noted the optimal strategy would be that if you have too much in 
the slow memory then you have to promote and if you have too much in the 
fast memory then you need to demote -- the goal is to move the smallest 
number of pages to optimize for this.  Goal is to move the hottest page 
and NUMA Balancing has never addressed this.

----->o-----
Next meeting will be on Thursday, October 9 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - update on cold page pruning from Bharata's patch series and any
   opportunities to shrink the hotness tracking
 - update on the resume fix for klruscand and timelines for sharing
   upstream
 - update on integrating klruscand into Raghu's series of patches and
   whether the API is stable or needs to be changed
 - discussion on how to optimize page placement for bandwidth and not
   simply latency based on access based on weighted interleave
 - update on non-temporal stores enlightenment for memory tiering
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace
 - discuss proactive demotion interface as an extension to memory.reclaim
 - discuss overall testing and benchmarking methodology for various
   approaches as we go along

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] 
https://lore.kernel.org/linux-mm/20250923174752.35701-1-shivankg@amd.com 

