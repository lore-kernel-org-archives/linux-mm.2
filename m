Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CCDBF532CC
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED616B00AC; Thu, 26 Mar 2026 23:53:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5AE6B00AF; Thu, 26 Mar 2026 23:53:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02C26B00B0; Thu, 26 Mar 2026 23:53:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFA236B00AC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:53:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B359BE2CE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:53:59 +0000 (UTC)
X-FDA: 84590474598.12.F92C205
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C1B96140008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:53:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MpnKQCIt;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774583637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RaMdx5BJQMY+QBQztA23tNPBXhOhpfed5A6cZo7WGJQ=;
	b=DlX4SlBElg0yXqcg9T0MNTnmoltDzNMr3JNDqQtiARnTBV83ICyNwpT7WvHUgXfzyb8o/P
	EJbp2Movq5FzSf62mlvEzR198gaYLaLC9pdrdu1If05c/RStSxsLdxZZ5BS1Se8qA+9KBI
	ZbkZrSoi/2U9jNfPNHPObtOCcUBqmF4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MpnKQCIt;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774583637; a=rsa-sha256;
	cv=none;
	b=z0lbf63jevW4oWdVXgZtcSewlwvLZ8SdIujcSv/QVKGsY8kbCyCvheqxhGdoUXBhh+BxQ4
	+NPQxxqrZz7LWSP7bBCwappRnimjGb74o5yB2V+dCtEEwQB47KgLJT4dgRzFiV+sUVE9u8
	ypJmqO/4cs6qX68iiX22NFoYlplCODk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C1CD7444BE;
	Fri, 27 Mar 2026 03:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E29C19423;
	Fri, 27 Mar 2026 03:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774583636;
	bh=3MHg1RUQO4rudmiuUy+mHrqVWAXUBdNAiLi8JqcLf8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpnKQCIthhpYQViR4eiqkUx/JtLQkvYNH98ArsRlc2fFcawW/XWjcUs1J9HRlmv9T
	 zuHJ6cgbL6jGdPob9bmcLVbHKHqfd/H07BJ9NLqZ26xQAxomx40F2N8CVx/Vm8sJCG
	 Roq4PNNdlU6JSoRdWOB4+WsQ5cVrghM78yCKnseBH6TMvnhhjCuAMg/ZPyDSNwsfbX
	 E85fF1Z500VMuaUWGvoBJCyBay2Fr5EicQwwqjHw/QFfH0pgRxMirVz/uhpiCDRskX
	 ICbYVgCnqKmGly8UdFU5kD/iwFHOfy4XL+mtgrT0RO63lNgCl9E69Fa38QadwzpX3v
	 nb35zI3oOR5hg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
Date: Thu, 26 Mar 2026 20:53:54 -0700
Message-ID: <20260327035355.68068-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327022014.66567-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1suu13cj7gribrrkhdc1jg4g6wsy7dj3
X-Rspamd-Queue-Id: C1B96140008
X-Rspamd-Server: rspam09
X-HE-Tag: 1774583637-218282
X-HE-Meta: U2FsdGVkX19ZpZpDPFDwoFZgw0Fp+JygH6vTRSMm1EPWA2nwa+TSOUPSzuqRwgcsF88F2GIynzoa/CesD0Nz+wnVLmEwYEzQCafrlXXNJKpetD6mp9wv+eB3cwtP6R7trTYr7CPN3SZMYhhdM2PbZsq8drQ0bwP7fExXtMbpBoMo2yP1akTroKiP1TznDrETg2lv0zL2mwyXLR3Ap8Y+cm8C7kQQ+nWE/ZGCAiXkHk8A/W6GZaI8IDIZ9jMOKEF3jmyO8ppwjbF6IfbpwB40hG0ZWj0ZgUuHW4ymqxvhRXdZRmWoh4kt5a2vSY00Vu0dlFLlFcjY52ihoNPmvyljVAR1SaQHsmsi0qpIChZSpDrt7WubRowl3GuPP/WA3uNL16P5wMhz0mhgFcxlNoCIJwRAqCMnORgYii6o9YtpAHBdOoWURZGoXdYujrXpkpGAUgImKbmzPOLSzLCLkW+M17AevZfn4PzE2BwWSOSbKOwz5gbGRaSkmU8ljDWC+3b8w0LEoP1Jd0/TrDM2uOYgzrk/nvky4KWIrT4XE2xWIbHPoZ8LxmxNx4A1i+JrU+xCMgGvcTZRT7Ijc2TjZK6tJ2J0yDh/0Ssbgdjxjiyy5LpZCpiNjDo7/qzqPZ2r15FVwA++A7XBNEx25d0e3IO95/z05jsIEwYd2p4ytGfXH/lBBLEx04LZfS8y5IPSjcbrEtMsRLeONXLvOxzfTa3TeFGktp2P96wr5lszJqAqsM6IXN+LP552wSLxA7kA09gHcQa4gj61V+iKTL/j/DJUkEP4JsvpsBRJfQTAmI5GcL5HVktsoW9jTso+exZLGoQ8v5GrGeH5CeF3cdrVlc/8RaPhmekVFVTn4fEfi6U/TRdGyisp+Jn1AQKJvTqrtvsh6SMnsRGBL/exs1zXX6VU7LpopwQaKLSdOqcOxsArYSPMkgHsbcx+kNp3YcBYPVsa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 19:20:13 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 26 Mar 2026 19:15:45 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > Forwarding Sashiko review for doing discussions via mails.
> > 
> > # review url: https://sashiko.dev/#/patchset/20260327004952.58266-1-sj@kernel.org
> > # start of sashiko.dev inline review
> > commit 36b78ee39968830aca3d375219a2cfce73d0d1d0
> > Author: SeongJae Park <sj@kernel.org>
> > 
> > mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
> > 
> > This commit fixes a race condition between damon_call and the
> > kdamond_fn exit path that could result in a deadlock. It introduces a
> > call_controls_obsolete flag to prevent damon_call from waiting
> > indefinitely for a terminating thread.
> > 
> > Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org
> > 
> > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > --- a/mm/damon/core.c
> > > +++ b/mm/damon/core.c
> > 
> > [ ... ]
> > 
> > > @@ -3062,6 +3042,9 @@ static int kdamond_fn(void *data)
> > >  	damon_destroy_targets(ctx);
> > >  
> > >  	kfree(ctx->regions_score_histogram);
> > > +	mutex_lock(&ctx->call_controls_lock);
> > > +	ctx->call_controls_obsolete = true;
> > > +	mutex_unlock(&ctx->call_controls_lock);
> > >  	kdamond_call(ctx, true);
> > >  	damos_walk_cancel(ctx);
> > 
> > Does damos_walk suffer from the same exit race regression that this patch
> > fixes for damon_call?
> > 
> > In kdamond_fn, the thread termination sequence executes damos_walk_cancel
> > and only later sets ctx->kdamond = NULL under the kdamond_lock.
> > 
> > damos_walk appears to use the same pattern as the old damon_call where it
> > registers ctx->walk_control, checks damon_is_running (which verifies
> > ctx->kdamond != NULL), and then unconditionally blocks on wait_for_completion.
> > 
> > If a user triggers a DAMOS walk in the exact window after damos_walk_cancel
> > has finished but before ctx->kdamond = NULL is executed, wouldn't damos_walk
> > successfully register its control and pass the damon_is_running check?
> > 
> > If so, it would then block indefinitely on wait_for_completion because the
> > cancellation phase has already passed and the thread is exiting.
> > 
> > Because damos_walk is invoked via state_store with the global
> > damon_sysfs_lock held, could this infinite wait block the entire DAMON sysfs
> > interface for all users on the system?
> 
> Yes, and I'm working on it separately, as I also replied [1] to the previous
> version.

Maybe I will make the next version of this patch as a series of two patches,
one for this one and the other one for the damos_walk() race fix.

> 
> [1] https://lore.kernel.org/20260326135146.90670-1-sj@kernel.org


Thanks,
SJ

[...]

