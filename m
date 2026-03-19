Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33E931088E58
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 01:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84D476B03A6; Wed, 18 Mar 2026 21:46:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824216B03A8; Wed, 18 Mar 2026 21:46:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739AA6B03A9; Wed, 18 Mar 2026 21:46:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 620DB6B03A6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:46:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0669C8A9D6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:46:32 +0000 (UTC)
X-FDA: 84561123024.08.CF21136
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 483E1A0007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:46:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nL6GFfvE;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773884790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQOQEwcRKcYlS8mxOVrREm49wVjGhY5Oi03/BatLddQ=;
	b=OsHs9zcz9ChBUyEd3McPneSzBY7TmzCg5DQv0rs67j9fJJism9QBXO3jO4TqJ4/Ni9Vh5r
	DJFujWpPHFPsYYxZKB9Mj2yxiV8bL6s6CmVMnBBD+0JRwqnV0vx0EvRIktpfB/4WHcqByH
	c3UwCA7B/vsWFKp+iJ+JQt+vlSxOzKU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nL6GFfvE;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773884790; a=rsa-sha256;
	cv=none;
	b=Bc5yRzUn41gweNd31j8PSzvoDkYtZeXU8qtkh+Re6FRZn/dkR9UYVUrdTHErZ3QWlJbK/H
	GkYObvFt1aguyAk+zV16xLOX8dCjYh1ZHhQw+C2zFkY+/1wcrFvrNQj/8cMZh8DpEd3ZsO
	LyOXZfJDh7KrnC90x5/uxWRHA54isgY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 299054396F;
	Thu, 19 Mar 2026 01:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA608C19421;
	Thu, 19 Mar 2026 01:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773884789;
	bh=QcvGKX/ZN7Y5gU6WL3L+CNAVoppWyxPddVUrpwP7Fd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nL6GFfvE2dx1eoG5es87nrmfcUg+GS0fPD2jMZHzAz3ihodmB6EUcwfiRV1iQINmM
	 lCHBalkS9+BkUjL/XJ5n4g2pAydJsSpnKFFa7y0dsu5G78PEzLtEPX0E9cKjmJ7cDi
	 ER+29ingjLiq/qgH5mMmYLPQDuQ9lEH0HzOY0+OblctFvHI9PcKpQxtvPIcqHtbCch
	 lHYZvllCPngdsEtWuSljfSQTfZS3MKZnY4qx4hWMWlTi1IvlSlC4YCq/RFHDefvQWz
	 z0HOnZpo18srQw0R0Kmu2gNrZt5Anwj+a7ndhG3K5rTG8me0cFnflJwv1/t+grV4Dc
	 JVhapaBpvHp0Q==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [Question] mm/damon: min_nr_regions constraint and inconsistent error handling
Date: Wed, 18 Mar 2026 18:46:24 -0700
Message-ID: <20260319014624.97146-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319012337.96726-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 483E1A0007
X-Rspamd-Server: rspam08
X-Stat-Signature: p5ifaxgfdr6dcb8s3fxk15reebwh9rd3
X-HE-Tag: 1773884790-393218
X-HE-Meta: U2FsdGVkX1+3eWKcOz3+vTNVSxaPDMNN68q5tdMeMVIdRFXGI3YDRYrz7YPIVD+X5hoIuRtyUSijR0B/oaEw04BN6/jJYzc8ZihJyei7jmhXWmFlB4LXHZWOgu7OwZ8lzOUMYH0SNK05OEp9YcKp26yLdIwAunEzhsLx4jPvnMlhEEqMPIkJVuJ/JIbsnnLD1bJRfOaGO9MVkcwTZXDCqY4OM0vOdruCyd7ETndIRXU7VDpNKZxh8jO6MDwIOjONLgUYZXDyDniFCAGPtb8pwOAmVNVuSf1BNxDXEG/MZ4HkGG1peIL+8PXRjYAuCFbWAQKp5FIuaGIMG79mF64Aqt1Y1ye6GDSqwNpZ+jdtHxT3hiKvs6+ooQLIiQG3wfyMI3XxFNH5lUZ0l+HXPNoKmJIO0vXlHcRYI9P7qIfn4jIerrTh47lTVxoPavoX8XZaI4TAYF9r+O7zqOhfvFBO5tXdwFIa17FH8SkyRxJt9dfo3728OzgAZLVFGvwP1tu+rtVFMNsIRsPoJluNjDTXa90Zj0QI6o9MYWAlRvTXXj+bTlle5wKGVmTn4mswNXxbWLx3yV+xDGkhcEjn+aaBU06Yqv3VPIDwoTvuPK1guVpMTpVQ4PXL2lYv0lNXAQewGl52KnxnSUerDgKbMxwXwj/SRIfyYEVhOj43QolO8rQ6kasv8ubhKmzYXWXhuciaDmPoq9hfAbtYv3azq0zb1GqPrS6Aep4i6a2hg7YcS7+/67MUGK14vD2vyId/cdBO58F8mGwzBqZsXRHua97GgbN1xlB9Lz8j6IB0m6xmcweafsr2rT0BDqP55ZU7bapyR3UN7mQoxSzWrdePhiZ6PlsUoetIPLD6+Z2zxkkW0/HFEKFcr6uuWZxrHU18yX5QodbYSW9GrstdD+Dn+/YnLlZyIPk3cTVRXdMbUjykhQU3zHrpZMYBYWOkV/b1zkptXr/oep5hym+hAhVVPAs
 JdkW8eMm
 zlMJyhug0D3yJ2LhmitItLtvmfT6EF/oa8ALPjOBC9wtJS2+jKW90A9lutwq1Tkw89+MMXYrO9i6N9s2wOBCvQJpAE5dzU9guiwUJkmb8N7n/BZ3/I0mVMLZ6fjvcyPXwWO8ca4vCanogcAG5+AbNNtDwzzFqZ13BHm4a/pIt2mZ13QDNUEljHLXN/uWqmoSo8tRmrvZKeMM5RkVDL1Qh7iDtTAWp9d7/VeZK4tv3Hd7WZWN0tK7mTM1c7ISI69I+qXioxc1eEFY9MJ9ocVhfJN/DXxMlxeS1MVHy0jEbfDHQvT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Mar 2026 18:23:36 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hi Liew,
> 
> On Wed, 18 Mar 2026 23:37:31 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
[...]
> > 2. Potential inconsistency in DAMON_LRU_SORT error handling
> > -----------------------------------------------------------
> > 
> > The documentation [1] states:
> > > "If invalid parameters are found while the re-reading, DAMON_LRU_SORT
> >  will be disabled."
> > 
> > However, testing on v7.0-rc4 shows that when commit_inputs fails (e.g.,
> > due to min_nr_regions < 3):
> > - The 'enabled' parameter remains 'Y'
> > - The kdamond thread continues running
> > 
> > This behavior may confuse users who expect the module to safely disable
> > itself upon configuration errors. Should commit_inputs failures trigger
> > an explicit disable (enabled=N)?
> 
> Nice finding!  In short, it is an intended behavior, but the document is
> outdated.
> 
> In the past, the documentation was correct.  When a wrong input is committed,
> DAMON_LRU_SORT was stopped.  That's because it was using damon_callback, which
> is now removed [3].  The callback was executed inside DAMON main loop, and when
> the callback returns an error, the loop was broken.  As a result, DAMON
> execution was stopped.  DAMON_LRU_SORT was setting the parameter inside the
> callback, and was returning an error when the parameter is invalid.  Hence the
> behavior was documented as you noticed.
> 
> Commit a30969436428 ("mm/damon/lru_sort: use damon_commit_ctx()") changed
> the behavior.  It changed DAMON_LRU_SORT to use damon_call() instead of
> damon_callback.  Because damon_call()'s callback function failure doesn't stop
> DAMON, the current behavior is made.
> 
> Still, committing wrong DAMON_LRU_SORT parameters returns an error to the user.
> Hence user can notify it was failed.  The invalid parameters are not really be
> committed to DAMON, so DAMON continues running with valid parameters.  So this
> is technically speaking a visible user behavior change.  But we believed it is
> ok because we were unable to expect users who depend on the old behavior.  I
> think I discussed this somewhere, but I cannot find the link right now...

I found it.  Commit 4c9ea539ad59 ("mm/damon/sysfs: validate user inputs from
damon_sysfs_commit_input()") discuss this.  To quote:

    Online DAMON parameters commit via DAMON sysfs interface can make kdamond
    stop.  This behavior was made because it can make the implementation
    simpler.  The implementation tries committing the parameter without
    validation.  If it finds something wrong in the middle of the parameters
    update, it returns error without reverting the partially committed
    parameters back.  It is safe though, since it immediately breaks kdamond
    main loop in the case of the error return.

    Users can make the wrong parameters by mistake, though.  Stopping kdamond
    in the case is not very useful behavior.  Also this makes it difficult to
    utilize damon_call() instead of damon_callback hook for online parameters
    update, since damon_call() cannot immediately break kdamond main loop in
    the middle.

    Validate the input parameters and return error when it fails before
    starting parameters updates.  In case of mistakenly wrong parameters,
    kdamond can continue running with the old and valid parameters.


Thanks,
SJ

[...]

