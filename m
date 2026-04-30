Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B757FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F05E56B0088; Thu, 30 Apr 2026 11:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6956B008A; Thu, 30 Apr 2026 11:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC976B008C; Thu, 30 Apr 2026 11:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C96DF6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:25:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 425A51A7AF4
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:40:33 +0000 (UTC)
X-FDA: 84715483146.08.34D622F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 37C29C000E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:40:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u+3KYR8S;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777560030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObSzW56ql8CHY7dbSX2UevjLIn3ixYKzVJGNhiHaNWY=;
	b=dLKRvMDiGnqGXgnz8XqYcZ1rX08sJ+8m/NvkotJDGRAIiHYOaIZQ2hhr0ruSLWSq98id0G
	mMpktwnyYRTXJcFA+gtb0+/uHpl5eDMgZQBdznBzHgo1k8i+kJg687cF9XJMdF1h+O1za+
	JaI6+tZ4TO8LmHngyKopcue+pl8LYOQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u+3KYR8S;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777560030; a=rsa-sha256;
	cv=none;
	b=otcwxhNoryAAgqrpl1Vs5khCiktw0qUtN0RlB0Y7+7fcjIKbTRmJcnQZ4+fNbk9aLYUYTo
	kRmRDczFs7/GF+ul4olNfWS5/TD4Q9rIcp3yc7t0UosS5aK640JkafQxbIrbBRgYYxi22W
	R16oJyZqw3i89Ab834FX5h3UUKFR8qc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 50E3B60180;
	Thu, 30 Apr 2026 14:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655A6C2BCB3;
	Thu, 30 Apr 2026 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777560029;
	bh=XKr3lZG1iyqrvPGZ2xciOEGAQlna/FCIh6yCzGzS88o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u+3KYR8SnHIO5zELtpnVCFVcwED2pW5qrrV06lytWGscluwY8GK3+RtNlmufP6Aph
	 uyhWOULLNvo/SL+/dW9OMWIUvUpof9RYb6Am3+fiy6hQo4RJpxJFyaNcC86V+3C/0l
	 AnfeC+cAGh41Ls/4O1eWSbMqo9miPr9LvZbuJoxWB2BKkdtMjhXUc17+JpMHhEtLzJ
	 izR7IO97QqX5JqoINHXUmi/WHWbsTAGIzk7AOUM1/H92d98yd9XL4lBy2b+SpyxdPP
	 /1M4tcj8yl407t5zGER6BgWU1BRrpxlYG5dngUPwPdWrV3f8eAXDCMThJT7XlsJ7J2
	 jLn4LckghSiZA==
Date: Thu, 30 Apr 2026 16:40:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 04/54] selftests/mm: migration: properly cleanup
 fork()ed processes
Message-ID: <afNpxNsylkUUC0-Z@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-5-rppt@kernel.org>
 <6b12453b-2683-41cc-bb4c-602eda6bf9d8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b12453b-2683-41cc-bb4c-602eda6bf9d8@redhat.com>
X-Stat-Signature: cjuoiik36bbhor5ircy6u3biza9dyta6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 37C29C000E
X-Rspam-User: 
X-HE-Tag: 1777560030-31549
X-HE-Meta: U2FsdGVkX18aqQatApqVo4i31Y3R4+NAvpMTXG7+IusNgUCgWtdQcci5LB9FO5V9hg5eM46WMknpSOwbLYDAW4jHzbGhxmJH8Iop6jL958hcCDO+hUMwBjtkGlMzwEMyxzcTkZLYPLtIyvhOHg28mFkyK0bueK3cDeJa/MQoq5sZrnd6p+jaLi71bueYVSYJoMtAJ+U2KmZ5YnpyTC+QBTQmMSaOFit8RgznUsFnOYWpUga7DmwQ2YMa0MHXDtJACV6zonWZ2V8S1yZeC3bagOTHTzJDzf4PQ49Ly0xLQKhgCZPAHjSflsOQSEHz6Np7Sfsw1qHxr4t0B5RBR50//oN+Jaje4BtEAnqPqQN7PxhJsvFBXKxPVPlgkQjj5WWAt1xwpQZAA4sIXTc8LCXii9ZWTiX2JrsC2gLxap3lT5ooMguxguHhevHgXcJD589gTprw0QbBqusZyZgjBrvHsYOWKTl6jTm2YRWWj6iwgkfDRFHU3LD+GSYyYa8IkR7GEzIPq5yz+se1aXUBPIKH7sZ5Mk0skkii+0FhzZiXYpQrjm6HUajjF4kMKJqHb97nsR2GRVe4+QZOHa96AC1gmINey68lfNsac7uuGyo5W+5c6PVcEJ41ZpKDCXoRsCYSSdfPZUDyRPLGdjJg+waSvWCnnIv/2Q6rCTiUJ1WtLaAEGeyWOXf3jeevNey1xeHIGzLLHFkq2pGfKmmakQe+QGvdTsQRP0y1sUZTLaYRzv+MftAAvdOsl7k5AXnE0HmWR99ZRbx1kD78P+sofxKYAoRi+BSJ/iZzApyzsUcuqN6OxQ82w5tu/NL7WAEUhQZJJYrgRJmbOHCUCVH/Q+y5CjL7wIwynKSdBdVn/GCRRm8eTxm6UdVfzUPDoHbYKzPA8A+bjzKI8nYWVGvigL3QH7rO03dKLhJgqP3Fe/NUeLA5N2rzrpU+MuvgNfBjQ1Y1HA7AYhTZW/E/oO6b3y8
 Z//XAB03
 5I3BTfSL0Uo5gTl4zasMfDpaAt6r6Dn6ctZSp4dQsOGfZGp8TDpjjOTsPBseBidB2/REs9m9CfJ4NTKKBaKsNX4AarP8UOv1iEEJLAWrBSisn3aae7HXbO9puCp/gGdzFVQAPxP4Gz6rfysLwDJFTtD8l4trS/2oFFftcyd5Yu6a4LBJU4VBwnazRKMB3yEnmywSLr7EHEvptCpCJtNg7clYvB0PWzeGIhMKfC0WdsSxbbFGDgH/8zJa/34EtLZGeAQFUzOEroY/AnJePfloWywZUhLTi0NJDwhMndzuQVHZu7IE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 09:37:43AM -0400, Luiz Capitulino wrote:
> On 2026-04-28 16:41, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Several migration test use fork() to create worker processes. These
> > processes are later killed, but nothing collects their exit status and they
> > remain as zombies in the system.
> > 
> > Add a helper function that kills the worker processes, waitpid()s for
> > them and verifies the exit status.
> > 
> > Replace the loops that call kill() for each process with a call to that
> > helper.
> > 
> > The addition of waitpid() calls also makes sure the migrating process never
> > exits before the processes accessing the memory, so it's possible to drop
> > the call to prctl(PR_SET_PDEATHSIG, SIGHUP).
> > 
> > Reported-by: Luiz Capitulino <luizcap@redhat.com>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   tools/testing/selftests/mm/migration.c | 54 +++++++++++++-------------
> >   1 file changed, 27 insertions(+), 27 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> > index 3630f2fb0800..76e380b74658 100644
> > --- a/tools/testing/selftests/mm/migration.c
> > +++ b/tools/testing/selftests/mm/migration.c
> > @@ -67,6 +67,24 @@ FIXTURE_TEARDOWN(migration)
> >   	free(self->pids);
> >   }
> > +static bool kill_children(FIXTURE_DATA(migration) * self)
> > +{
> > +	int i, status;
> > +	pid_t pid;
> > +
> > +	for (i = 0; i < self->nthreads; i++) {
> > +		pid = self->pids[i];
> > +		if (kill(pid, SIGTERM))
> > +			return false;
> > +		if (pid != waitpid(pid, &status, 0))
> > +			return false;
> > +		if (!WIFSIGNALED(status) || WTERMSIG(status) != SIGTERM)
> > +			return false;
> > +	}
> 
> Why do we stop at the first error? Wouldn't it be better to kill &
> collect all of them and then return false if at least one fails?

Yep, makes sense.
 
> > +
> > +	return true;
> > +}
> > +
> >   int migrate(uint64_t *ptr, int n1, int n2)
> >   {
> >   	int ret, tmp;
> > @@ -160,20 +178,14 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
> >   	memset(ptr, 0xde, TWOMEG);
> >   	for (i = 0; i < self->nthreads; i++) {
> >   		pid = fork();
> > -		if (!pid) {
> > -			prctl(PR_SET_PDEATHSIG, SIGHUP);
> > -			/* Parent may have died before prctl so check now. */
> > -			if (getppid() == 1)
> > -				kill(getpid(), SIGHUP);
> 
> This goes beyond this series, but I wonder if we should have this check
> in access_mem() in case the parent dies in migrate().

With added kill() + waitpid() this should not happen.

-- 
Sincerely yours,
Mike.

