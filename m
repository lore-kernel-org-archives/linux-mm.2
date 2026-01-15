Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FDD1D46627
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 22:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD2A06B00C4; Thu, 15 Jan 2026 17:09:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA586B00C5; Thu, 15 Jan 2026 17:09:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AACCE6B00C6; Thu, 15 Jan 2026 17:09:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9867F6B00C4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:09:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FFF41A04BE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:09:52 +0000 (UTC)
X-FDA: 84335591424.14.9ED239E
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id E9F661C000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:09:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OIusGAXN;
	spf=pass (imf20.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768514990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntiyNJN8HUkrpuQ5dePzjgUJxHCqX6FK7kqJzCegw+E=;
	b=wCz+ML7+kbHjWvUtktgSHMGYQ/5IOADw1C+u8sj3MiR47Qp2b4JSfQeqVAloUSJ/RTt3a7
	4qPCAgNQZ8aUakG7qHBTwMz+5aBxiBysP6p+AUo0DCrfUwbzhYT25hROCxs2IV21d6VOjn
	C3r9OaBHDgsjTQpG1ZonEDqSZPzVkf4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OIusGAXN;
	spf=pass (imf20.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768514990; a=rsa-sha256;
	cv=none;
	b=hM+aBSfyKVrXsJAzbe2zijZA3LQu9cEu3R6OX2laEBvI8q8xVgtNqen4U7N2hv1aW/Tv4h
	I8+UVIHkOicmJ2dX+R6atUHr5t2JjKhR1V74QSz9sbT7AJcZHFMR7fICAjLxYhttepWnuJ
	4GcBY9hVstL+PNFWbg42ug3vDK7lQ0c=
Date: Thu, 15 Jan 2026 22:09:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768514986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ntiyNJN8HUkrpuQ5dePzjgUJxHCqX6FK7kqJzCegw+E=;
	b=OIusGAXNYjd6pQKnQb4pYZB362R/Uq6SZMD7NGXJxBHnNS69t8wrcQtIbBJNqaTuC80Pna
	1B1aJhYUHEnszVjYApCXTd+Gt9K1YVjlQad72LjRCUqhY/vzPj45CjoTETaH4jFO+s4zRB
	NM4IMy0XAzy0qYMp5GRNYklKDReZHSQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@meta.com, longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, corbet@lwn.net, gregkh@linuxfoundation.org, rafael@kernel.org, 
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com, 
	ira.weiny@intel.com, dan.j.williams@intel.com, akpm@linux-foundation.org, 
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	ziy@nvidia.com, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk, 
	rientjes@google.com, shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, 
	chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	osalvador@suse.de, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 7/8] mm/zswap: compressed ram direct integration
Message-ID: <a3zwoccozpnpum3dkvdytjl4aookymmuuhzcnswznxft5jy6mi@wfcyp4euizrx>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <20260108203755.1163107-8-gourry@gourry.net>
 <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
 <aWF1uDdP75gOCGLm@gourry-fedora-PF4VCD3F>
 <4ftthovin57fi4blr2mardw4elwfsiv6vrkhrjqjsfvvuuugjj@uivjc5uzj5ys>
 <aWWEvAaUmpA_0ERP@gourry-fedora-PF4VCD3F>
 <fkxcxh4eilncsbtwt7jmuiaxrfvuidlnbovesa6m7eoif5tmxc@r34c5zy4nr4y>
 <aWkjUXpyLEJyc-C0@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWkjUXpyLEJyc-C0@gourry-fedora-PF4VCD3F>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: uy5sqr4jzwrxiztkefgqygccuxk8ei9n
X-Rspam-User: 
X-Rspamd-Queue-Id: E9F661C000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1768514989-207056
X-HE-Meta: U2FsdGVkX1/O5RztbqtcxjSwi2M0U8JhT7w5XkrIE/aSog7CUEX2icmQhxOJ1pq8VNuIMvKoa8qOJhNQWwcIeSHi8vg56qvev/+DS6hDhir5PBdEHPHkw+sbVQvdiYytW7vhKNh8bl4PbTqs6YtLzh3aJnOiM6gvdB7zHbKvrDWGb6z0BAuUOTMoOpcOiBcCpqCIhgnA3Oew8tbf/rTh2GRj2XlcU3D94vVUGuu6x3zVXmxLtsnCtzZLYfz3jNW/8pswKYVFVStch8Hrj77XKYbNoyzpEYYaCOW7B9CKB+uMmT74lN8+DjCk49/fFoKPpcKpknhbigM3ITj+dNsSqAkrgmcilLk3uEkuysRGHxu8DpvVchpgbI3D4+PfLx14pqZUVPPcS2IKY6ijG+JJSyUhwSenWnhf9HBHa5ZMH+Phh+b2/MiT2ge1oiEILJ9pDX504NP3/wlIl9EDQgR3daYVMvbk8tkZAtPOBcdH3oY8cJlaRC9ZGwvCwtBJqKv6xd1oOIth52928GfWDkIwhqh7eGfWVMDM5ZWGTSpbp/MBGRtBY3bw6i3RoiPdxuUbkFvtwvHX/tDkMs36qV5tcwTihkiArqQzGxbwu5vmyGhHsicPdawXhaIn4EcQ5gvN6atqdIUTMmk+5FnhXJvn2lOcRWBsygsOarMO++vY8ize+5nyQiNNiWE/jv2gtKYwQY3Xmk01MZ8BYR0EJXHjN102npTty3lH7dJByRR5l461N36Vslt4qroniuSx2ed110joWZTL0wLVu5Pmu9Fjsjax5b02EcDhHqNX4zVYd1Jfzb/N65aYot/589CZc4iCCIxwgY2+bDo6hn22A2Lc95Fj/3S79YXbGyRuCVVhBGrNTdBRLbAHvB6/ohTWxKZuiIq2LjbEOcIhwzBAgoK4dUsNeaUdIwp6PUMSSkiGgNAZqmGljK1d4pVlXaJGg90ZPMbcvd7qJ7Z4CDMlxmM
 OpjSdpcp
 f7TPi/k4cJ3Dg5NWyI6FxW6JG5IVcTiVGT645P/xVcAHBgAcxvQeQc7W4Qk1IS8ucS09AyWjuNDJWoiCPDJPILT/qYq5xc8JyPpXqKaH0DH3MLGhiEn4hIBeFym4/bIJDhTkofizpGpx/V6tKxjp9O+P+kSYEpzhiAi+XcA3U3WXw9Q6esTt7rRfHH6of1fmVtHz9L+3ktTGo2yapwMcHS8wmpd6CvRZbo4JX7c/l1XzUvZ6WAYfWBrpvwMkSL+u5lTp2ncLOPsXMyALMU9vG26RGTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 12:26:41PM -0500, Gregory Price wrote:
> > > For the first go, yeah.  A cram.c would need special page table handling
> > > bits that will take a while to get right.  We can make use of the
> > > hardware differently in the meantime.
> > 
> > Makes sense.
> > 
> > I just want to point out that using compressed memory with zswap doesn't
> > buy us much in terms of reclaim latency, so the main goal here is just
> > saving memory on the top tier, not improving performance, right?
> >
> 
> Yeah first goal is to just demonstrate such an accelerator can even work
> as a top-tier memory saving mechanism.  But hard to say whether reclaim
> latency will be affected appreciably - won't know until we get there :]
> 
> I'm totally prepared for this to be a science experiment that gets
> thrown away.

If that's the case I would put the zswap stuff under an experimental
config option that's not enabled by default, so that we can rip it out
later if needed. 

> 
> > > 
> > > I will probably need some help to get the accounting right if I'm being
> > > honest.  I can't say I fully understanding the implications here, but
> > > what you describe makes sense.
> > > 
> > 
> > Yeah it's counter-intuitive. Zswap needs to charge less than PAGE_SIZE
> > so that memcg tracking continues to make sense with reclaim (i.e. usage
> > goes down), but if zswap consumed a full page from the system
> > perspective, the math won't math.
> > 
> > Separate limits *could* be the answer, but it's harder to configure and
> > existing configuration won't "just work" with compressed memory.
> >
> 
> I think you are right. I am also inquiring whether individual page
> compression data is retrievable.  If so, then this actually should be a
> trivial integration.
> 
> If not then this is probably ending up on the cutting room floor and
> going straight to a full cram.c implementation.
> 
> ~Gregory

