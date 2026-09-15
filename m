Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00488C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015006B0093; Tue, 15 Sep 2026 10:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F026B0095; Tue, 15 Sep 2026 10:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C6C6B0096; Tue, 15 Sep 2026 10:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C90F86B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:10:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3411D140417
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:10:59 +0000 (UTC)
X-FDA: 85216183038.10.5591B8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9773B18000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:10:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EtH4RCPA;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789481457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHSbmDD3j9xRZ2iJWMGKJ3aguz1fvqB4sLYlzipxP8I=;
	b=ekfZc9yMY/rJ62YE/XBs/OobuaA5FqTRUeY/+dcbXMlKHq3OQUWakCFh/fKil9vCu4Un5U
	HUH64O/L8v2PxEuO4sVSX8F+GCW+q4zvFU/aPbOXh+etU1jH/0KiZ+fKLQjmAuhHEhBqzb
	X4UJQq9CgksM2GLUtvd0BQjTNTN7zEY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EtH4RCPA;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789481457;
	b=Oa9hA1m7T1813998Mbrfd9hLb9+ZmKpHuYkyTzN8vfG8WJ0W4vWEaUWEHiZ84CN3sm9CFq
	eRqc5xwy3X4pkodhVfOw5+nu+QHmvDihLV3U3ysM1DUohbxH0gdLlLA+KTlKaXI55++NoN
	8ukqy4cncV9wMxtQUlb2Q0lPFg4tJME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 102C3600C8;
	Tue, 15 Sep 2026 14:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D071F000FF;
	Tue, 15 Sep 2026 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789481456;
	bh=aHSbmDD3j9xRZ2iJWMGKJ3aguz1fvqB4sLYlzipxP8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtH4RCPAGt8eG3YAeogfbeH4uqJlSWBkDjNf+0ldGQu2sW+ZDSssoW4DVtN8vXsci
	 0TuCYsbHtG0qtsbUZ5LwHtsJ18k/2dBxrJ9MdBXSZHMMZkYpQ5GJJdxc02a+OPMnse
	 e/X2awvw8y6cF12of+7uXMUcE5LsKFhd93XayEtx7fbHboYqBBffGlhkiHf046JwaR
	 n4hz1yqShHSRqdhqsYMKRjR3m2e2SNsNwdsoZumtQu5sXdEWz1ctbIzkqMbfI5iGRf
	 N/FPnYieXVGG58iZ66mMQ3krFQbnFHevuJZ3ZNdGXQ+2eG4X4PU472jaMx8leAFmjl
	 I9mblwyJgh4SA==
From: SJ Park <sj@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap writeback test
Date: Tue, 15 Sep 2026 07:10:48 -0700
Message-ID: <20260915141049.70696-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aqkavo7OfQdMOpLf@thinkstation>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 83b1udyck79hsen6efjmr479axx35jnm
X-Rspamd-Queue-Id: 9773B18000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1789481457-186188
X-HE-Meta: U2FsdGVkX18AufkU19Dsz5C+ZqWvUP267sKa/Ce5G1mqnpLKDTBPGcbMMuPWYF2Jkb/XNjDLZtoHqanWHzJrOq308nJcX5nkTfUC1LCGkiDviF2RASkNbcyG/X7UNkm8qvQn8+Y4aUmB/dcqRPiI5JMMPEVRoNYXNhM20L/N6+WHnmKDX0SmK7PPwyJ4FcMDg3aPsmfE5pOX7Qp5D0OpA+9agG9I3FM08kx3GkltDlc12E/TxBul6nPHsyyf0EMBQdjjEXtIcHfzCglsVB9PFLf+/MKxnbl34bMknA7CtvQJ/lkhPCX+jwBxGrgQf0bcvcMNMqgWvKoL46MeKGoOD2nAlgVRBkKZDrsvpYga2UOgURXoQxYEUZXuG5ElvjBxIBvKnieGRYjdeWq6c/s25Qndc1cPm6dILNuPX+AZceK26ZF4+9G6liPhbeZeqPoKUKWLmwV3gOwuSON0aXZQkl0h6wBoC+ABx/nBlyxDaGCVnZvYWUYyRUEekD4LX71T3wZIOqJEdlgZNGrwLU08xzr6VcJ0EXtlI8OsxYWSykpw0HMmwezsJrmmU7LCzJooizXlxR+CqFWpmWjN+tPbxZNVDfO+24zDM5jhE/Z+GiKKZiKEs2+pRO4bc743Ykc0h9Ib7aFWFN+CnufH6/c56sgJJNM8/jNeJiiznZIvonvU0eH6+aIP73Boixami/CAtFuILla5jNBCC2Twd/aC0dnBExJHY4xrxugFNrni2prZHQFD5QBz15f9i626JtLxfpYtozTlI8MfKNwexAgrfWZGLpcnuLviPToPG5Q3n3ytWl5/qASYcQlz78+Eyx8ge2DYHZtsqFU196Vfx6omarpdsilidikCYrRmEM9XPtr3ll/nLnK8ZtYxzXoBurZAPECv7YOtvMJB4lDuM+kHAeOslRzvIg4yS0Nn17tPnSeH6gUAVD9Tv0/5zpN01jVF0KzJKWLz4ldL8DAdXqP
 Hrd/oB/n
 zX64pRPqmPmd4mJQn0nyMfKtGAZTVncq/cN4e34emFl399RXIwW0ucwMPURUjiN1BIMbYxHt3wTRMMPoH/tupueTySOd1f/dKbZtDPgh6R61n7o8iv8WVFlN5L0QN1pTnn/NDMJW+AtrbZ58v1MapHd0egqNHg2uj8SnXMfsw/S6uAP0yI6C/0mQCP1OFt1YhlrPhNXhF0TJeFOD4zgAsMFfugBZLuu2O+R9vvDsitOw/o1ZuKET/Piw92Oj0JRmwMNRa0+7+9tH1lAX1pCSrupw8b5q2c0xKjIhYbdwWG1lq+nJgjEO3I6Wl5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 11:21:53 +0100 Harry Yoo <harry@kernel.org> wrote:

> On Mon, Sep 14, 2026 at 05:18:17PM -0700, SJ Park wrote:
> > Hi Harry,
> 
> Hi SJ, thanks for looking into it!
> 
> > On Mon, 14 Sep 2026 21:36:39 +0100 "Harry Yoo (Meta)" <harry@kernel.org> wrote:
> > Makes sense to me.
> 
> Thanks!
> 
> > [...]
> > > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > > @@ -346,7 +346,16 @@ static int attempt_writeback(const char *cgroup, void *arg)
> > >  	 * it can't writeback to swap.
> > >  	 */
> > >  	ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> > > -	if (!wb_enabled)
> > > +
> > > +	/*
> > > +	 * When writeback is enabled, memory.reclaim may still fail to reclaim
> > > +	 * the requested amount of memory due to a slow swap device.
> > > +	 * Ignore -EAGAIN here. The caller determines pass/fail based on the
> > > +	 * zswap writeback counter.
> > > +	 */
> > > +	if (wb_enabled && ret == -EAGAIN)
> > > +		ret = 0;
> > > +	else if (!wb_enabled)
> > >  		ret = (ret == -EAGAIN) ? 0 : -1;
> > 
> > My humble eyes were unable to easily understand the change.  Is the change
> > effectively same to below, and if so, would this be easier to read?
> > 
> > '''
> > @@ -344,10 +344,11 @@ static int attempt_writeback(const char *cgroup, void *arg)
> >          * writeback as zswap.max is 1/4 of what was needed when reclaim ran the first time.
> >          * If writeback is disabled, memory reclaim will fail as zswap is limited and
> >          * it can't writeback to swap.
> > +        * Even if writeback is enabled, it could return -EAGAIN due to a slow
> > +        * swap device.
> >          */
> >         ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> > -       if (!wb_enabled)
> > -               ret = (ret == -EAGAIN) ? 0 : -1;
> > +       ret = (ret == -EAGAIN) ? 0 : -1;
> 
> Hmm, no. This will mark the test as failed when a write to
> memory.reclaim returns zero even when wb_enabled is true.
> 
> It's not the same because when wb_enabled == true we consider
> ret == 0 or ret == -EAGAIN as success, while with wb_enabled == false
> we consider ret == -EAGAIN as success.

Ah, got it.  You are right.  Sorry for making noise and thank you for kindly
correcting me.

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

