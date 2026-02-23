Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD2FEC1101
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61DCB6B0089; Mon, 23 Feb 2026 11:08:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CBD66B008A; Mon, 23 Feb 2026 11:08:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479206B0092; Mon, 23 Feb 2026 11:08:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3090A6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:08:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA77414024D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:08:44 +0000 (UTC)
X-FDA: 84476204568.12.27444C2
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id D15AB40003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:08:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Gl8DA67o;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771862922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hp6xyKYDxr6lXYQA9JHTZDh6ckgrNYb0tSD8kTJSDxQ=;
	b=my8teLvzTqfclI5dfwiBmeDQb621bFrvRal+v28HVYfpCDCjPeKCMBeIqUmiGHbSGzH+fR
	lru271aBRQqYaTPBwAlJ7nK6HIQwtp9hpwYcVT37dAnqf0ZImGoixF9gU/mPlcgJFnHeiX
	Wqsu+UmjtSk7Cvysz96BOK3R23ECOpE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771862922; a=rsa-sha256;
	cv=none;
	b=Hu3v6WO85MKTws/rL8+Ex8qfq4nQglibbByWNtW4QSU7xFKVlSBgRrp2PHg0pcW3eMK2Zw
	E+u8mDnigaPJxANPM81XYOPVzTRMzmblVzlkp0TtAglDNzNrCrRlaI1kwGCqZ1w2hen3dL
	JrNvzgYEoAnD7uz78LYcAphs7ccvtPE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Gl8DA67o;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-895071c5527so54028946d6.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771862922; x=1772467722; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hp6xyKYDxr6lXYQA9JHTZDh6ckgrNYb0tSD8kTJSDxQ=;
        b=Gl8DA67oaRZryeClk69ib+qgrNhZXvMsNLvJLJzEbAKHi71Evx078aGvtBI53K3uIZ
         TeGLlBL3kT7w5tsPMTlIr8SfiHzn284WFjELyek7TVWQvRoJTBhOISqN1N3+i7dgorid
         guCDBXZ1lKt25KDbZAF1I1MIL+WytWPqq6S98vh1euxzuDeosyUAtgrrCqdDtxavW5ug
         L0uk/gjpU2vbNih/iYFpFK+SRh5drXsw9kuGnHMCUoJDJY+d97xcIuUv4nJBgrRCjY3t
         KI9fFsd/s23IYcxut7jgJiQcfQYB0EV2xVZEXgwhNz7VJRWI3DW9Gs7DeTxBaZoamF2x
         cWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771862922; x=1772467722;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hp6xyKYDxr6lXYQA9JHTZDh6ckgrNYb0tSD8kTJSDxQ=;
        b=P3E133Wplpl+ZKonnwZV5qnau5ADJugEb6m3P+VPCAFxxjp7CBxngcIASKGM5rY2sE
         dTKXv+p3cqMX9G5qWDtbo8+azRlefGRliJ3ISU17f4pps9o7acja209ptOCMjsdo509m
         I+1JwFPfPzV7HHKy1oUq5+YeL3grOZrwX9pePecwhugFzh9Odnl6Vh7pXKtUa0yI8R/Z
         skQOQ3uen0QDK1sEv7YB8SZeYcWXPgRFqd2wlEzGjZam7O+yymVSCKzIO4o4IICifzp2
         qUxauTzT8shzcsVL4R0K6xec/E4lHdgEz3y1+Jo5u9OskKH4rtOPBeKGVck6CSvl8kfP
         4GGg==
X-Forwarded-Encrypted: i=1; AJvYcCUZEfUcfOgrBd7qXCD741ylRt57/jZ/UHTjZ2i0Piqom32KbLCW7+97r6XPXi5j6tbP0buqi7zFUg==@kvack.org
X-Gm-Message-State: AOJu0YzdKI0tlgtHKoc154oid23Yre4rGBScKDXH9uMdMcQB9bz1hFOr
	CXSTmKFw/fvZ1vwd3/Wyzjf4UH9jDAwElDouJHJlesJ3f1ybfg1UfI3w/aB0tBbJ3BI=
X-Gm-Gg: AZuq6aLlRRCfZOBe94is2bLSgdcYDavSo9yIHGlfrhS5A89hzidQp0X459pnoKqhqAA
	FL2nV9GsLYCfb1wYQOE4CUDHu4/mrXJRA+x0wDPQCZVPa1ws8THn8m73c8hQp1kHEtc7kf1k3ur
	yk/Zy/pgR88tgEuIjvod86SfpdyoVlgqzf5urjK7/HlQPZZXA1eHHFKZ6bvw6360e3p/h3No1as
	SUhUPKScI3CdpK465r1pYscTp7RDiMvbk3OAQOZGiouLZJQmpvKajPAkMEyuSFIoKShb51+cAGR
	Yqq7Hu5lS5u2viIuIqtNWd2x7xkIHAU3myhM+OgslYQdn7Q29UrVsJ8DFsRxwkThfO5kHNdcdjj
	tz2pWG0jWddRfHr7hNh/4VuGTuE15tPh65MD7akQ0dmvvngnSVMwul25c2PuXy1kOOnrap69cWu
	2ETNUrozhyjJWZGZvxI+Z0RhKfeHeZCVdatSO53j71Q/w3e/MncWJ4fqh83uWL5OHozemy6Fltc
	Vn35LEp0I74cb8NsXKK
X-Received: by 2002:a05:622a:1922:b0:4f3:5835:e946 with SMTP id d75a77b69052e-5070bca9868mr136790871cf.55.1771862921369;
        Mon, 23 Feb 2026 08:08:41 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d54000fsm71259831cf.10.2026.02.23.08.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 08:08:40 -0800 (PST)
Date: Mon, 23 Feb 2026 11:08:38 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <aZx7hsVNU0XOCCiG@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <c10400db-2259-4465-a07e-19d0691101a4@kernel.org>
 <aZxqP7J1kOClQUPQ@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZxqP7J1kOClQUPQ@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam09
X-Stat-Signature: iz1b63886kuk39u65xmp5ty1fj6aud3j
X-Rspamd-Queue-Id: D15AB40003
X-Rspam-User: 
X-HE-Tag: 1771862922-193910
X-HE-Meta: U2FsdGVkX1/1VIdZQmuzX/NUIaKeHWhp9qs++TPIFc+ykAMXZ1tqqYlJzDHJXcPm/3QJqlNdCPyPUwxpNcQUB4exInaqFgpASGrufg2pkuiQDy3e0wxjraa6gRvj13sIGDyWdyrFd//yC9dkicfvFjj2LBRC+owagfBzxojWILSmmzRE5+mcYCfrEf0+CBc6GeN6LCURc4/Wi0FXucQlKwdOj41pjeOM+evuvUsIf+CtWC7lFTS+0rH0AYdk4hBNDcjgJ49quv7gdfK+suvKwWcmM8nqz+mvFFAeD5HaXB/FN3NR5djstn/d9sxEm84Z27FspCHJrwSqfwxvuQ+9aAWU0MUJo4iD9tG4LNWqUZEOvquoqp+cHd1hOb4UYGBQWzb1ZcMQuXZZEfcw5i8IXU2Xte1kPfc1qhWFit2w3+OU057IDp+2Bd0AoMD8LnbczTj2aUjOb9gx2jDKjEtjIqgcYRsG+REZ+dfk0EmfF5i8MkfjS5efxwNfAJM4ljsabNQW8uy2hW8YfkZLQg5XkqbPeH5GEyRZVm71XQXqj7LblO9yWDHFC5tTFDIcq6r2N3iIOIKxIIuNuwIWyMrPw9Q6dhi80fjOvic7VXhZeaZGVO34MyCtT85wNvBsD4+onow0/D2sgzJTLSnvSOGaKEklJT0hWYml8RtTVoHexplN6tPiYcGYJYVt9i6uD/IlCc2SvINERLWflIyha9X15NuzgSSY8rG1UPCS0O/bIWw/zdKk7eYleHKiwsscxukzaJZQl0YjE2xZZMOaPG4tt9dEoS65N6SfxRLMn3XJTKmb1Joe+xCPzcSIO9VLGOrxxmwOBjhzzQ3gJfG4acd0A5VP6stdz6Tj1Wnza+tH1kJhV3Aozznxdbs9LVXcUXi+Flo1YsizvDPVD+EI+RnVNA08pwZU03QMhZ/L4H4Q4o9p/UPJI0U0gnNWMFaIZ/BJiCMR5sWGUGs0mzu6/cd
 AuY7t9Df
 RxyMVRBT92Lp9EUMFcgxYUGRIx1dMMNP5tEAB1kIDUDjwgHZLmJs05WRlxcyquVIRz1rPL04C6IkmLWH501ZPQvsWHN40csN1A3tKxY5e+oSvWmBN6+d0btoP8CzcWIKkKZfWHfr9Ilr0a/XRt+lGI8jv5/IWwkO1JRgCgZ6je87NYU6uusU4Mcb2tkMROC0nzHJhfqFRrDDfp9pjjwUhzhIp/NABwablFRC9uplAXs1ZAfHW0M0QANvEroRYvjRDyYKL4hfsPf+cmVukMMuQgDz6Gl+istbXxrWRh+E9xNiVFKU7JikxXPQnEgEzs6o8ahpaz4z9oEpYGOWe+KriIKpaaW8GlA3IdTx3Lh2lKYZWHlwL+4jQHFW3LUMvxluE5D/AefkSY0zIhS4rPzk4ThzKpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 09:54:55AM -0500, Gregory Price wrote:
> On Mon, Feb 23, 2026 at 02:07:15PM +0100, David Hildenbrand (Arm) wrote:
> > 
> > I'm concerned about adding more special-casing (similar to what we already
> > added for ZONE_DEVICE) all over the place.
> > 
> > Like the whole folio_managed_() stuff in mprotect.c
> > 
> > Having that said, sounds like a reasonable topic to discuss.
> > 
> 
> Another option would be to add the hook to vma_wants_writenotify()
> instead of the page table code - and mask MM_CP_TRY_CHANGE_WRITABLE.
> 

scratch all this - existing hooks exist for exactly this purpose:

	can_change_[pte|pmd]_writable()

Surprised I missed this.

I can clean this up to remove it from the page table walks.

Still valid to question whether we want this, but at least the hook
lives with other write-protect hooks now.

~Gregory

