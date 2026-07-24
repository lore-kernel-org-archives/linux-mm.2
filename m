Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE3AC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 19:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 882E86B008A; Fri, 24 Jul 2026 15:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D2D6B008C; Fri, 24 Jul 2026 15:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7316B0092; Fri, 24 Jul 2026 15:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 430896B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:48:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2010A03F5
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:48:15 +0000 (UTC)
X-FDA: 85024706550.09.1565F53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2E2A740009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:48:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R2cQLEyj;
	spf=pass (imf17.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784922494;
	b=ebJryZdIojsZI/RWWN2c7iFydvPuVaHrBu+aoRqz+VMNOziq5tg0B3ObO8ya4/2bh/gUbo
	67FlLmjIp7dvQ70dHtN47zLP7n22/E0ThUk1s5N1MBM2taKsYU/jPlz32rhlV0vj9sXOey
	muMDLbJjL1uH5aHh9XZ/aUCxgkVInm0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R2cQLEyj;
	spf=pass (imf17.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784922494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xgjdyft+OKEQ3BRd9E0FjAMVZAURtSGF812mlpI1u9c=;
	b=fKqBWsn99EItYl7U8eMomvBczXfrdgsMs9vJhDBh3r0NOlUQCPB8pgEKwBUXGl6Y06I6Px
	AlJGRji0el3yil4PBA5eGr4PDaY7VNLQhrjLqY5BhgRLqr0JLv18WYJEatfXR9UXgSaK7v
	0tCb/g3YU01nlAwFbJBFf4mkvGG2AxM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9AAE41FB4;
	Fri, 24 Jul 2026 19:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D674C1F000E9;
	Fri, 24 Jul 2026 19:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784922492;
	bh=Xgjdyft+OKEQ3BRd9E0FjAMVZAURtSGF812mlpI1u9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R2cQLEyjYgkITQsGt3xdflVXjKM9Iw/P93FdIIIxmAFUqAHguKarCA5nNrGmuXoCh
	 4DiRfri1DhiNxQRD4DPyFdliKOh7txhvdhS5E+qtqNoptkOS0j576wp3on/rZzqmcI
	 tQ5NK6HLEWIq1i4hFWptquEL5naCcFmidLluFwNqY6+T/eUcaDTPqm0eig1vR1Tl2c
	 w2E6gT8RxUCd3jM73dkoxQDzOsYzVK7VhsBNqFcseOqEuZX9c0R72k0E62vXHwe4NE
	 i5qhweEGNqohCGQ38C9E5t56kgtI3dr4MmEnjEtdmjL5W7ami4DdlPTwuXHWnZklNY
	 Y2ft3xnrmDDOw==
Date: Fri, 24 Jul 2026 12:48:08 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org, linux-next@vger.kernel.org
Subject: Re: Semantic conflict between 04b177544a04 in drm-misc-fixes and
 0b6b1bb28482 in -mm
Message-ID: <20260724194808.GA1461047@ax162>
References: <20260722225605.GA1910198@ax162>
 <amFPJc1NQbuYWlSp@gsse-cloud1.jf.intel.com>
 <20260723212724.GA999236@ax162>
 <20260723160942.b58b065d771401aba117bc77@linux-foundation.org>
 <amKftG6NRZy0Ii2/@gsse-cloud1.jf.intel.com>
 <93289e91-ef9f-4786-bf49-e93d91afc1ad@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93289e91-ef9f-4786-bf49-e93d91afc1ad@sirena.org.uk>
X-Stat-Signature: py1smxaaizzuhk855pbxcjt5ktxde311
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2E2A740009
X-Rspam-User: 
X-HE-Tag: 1784922494-607812
X-HE-Meta: U2FsdGVkX1/6qX29QvaDR1DtyNtx8wNyECZP4cFZ/ES6BM04h4FTgAER9+Jc8cWw4imzV+BLOZWNE4R9RESYkN94hFCtcvx6KFiCGUjob477mhWITO6K696hWt5jRJvL09mJne5KXm8KCHxplnip7TQmJpXc5LC1JzfQVAnBr4UjZRO5AWCuzK4YFjk/he4gunApFrlj9H6kDbKoZKgAbzGJKLjfZN6rW0bVWbv4RH6BEkQEz+ZVbqoiGYJ2wTODmnqTWUzVi4CdWWA67DK1ViOrxpWZKrjonGNevfohSa2lgOtqSLVVeqRiSCa39HxHe+a7GojncIb8sfXFOqoRK1siyKOuG4Pv9Zrbmmy2AJfvigKDIvmoUvT9Qrt5cVNyyGa7ZXZeR/dxXFcVbr5+gUzWJUdL7mSz2KNe/ExCX7GWh0Pn1tvkPp+JP5OVtSCe//0H3YF5CiBuLEM8j3S/vFeydo6y/5Y5UYT5IinHvveZE4ouYLeCxegEvAujJ54LGGGmG0GchhsJ1P9tKKwPs6gb1Dn31zvRBMEgCWKPuIezE4zVNx7qnagK1xWpB3+moo8aJrk+NqbWQS+mRLjBa51MUCo9bfD1NO0NPbsyYatK1IZVlsA/s/WUoSPjnoyKAQS2LwQnBl5czJTd80lItHWA+b/xYlFE0zQDo4hP2wbkJw1qduXlPyvp/jidLtCU1Qt1Xf5B9nFw8rV81/kfxmxbZpXdhP6Ep6CmTJTF8SPb0/llZ9IckOKTbJPoAm91xHvpoQ9WuqEly5nfY7w2m5bCH5LhY1vpBFce8M9jkAAQyUE2pzmBcnGNcbNN44nOs/pc8/IaUC4vWR+x8R+9+DAXp5JBg3mvW7AXLBaq6JSH5Aa0Z3nwmsVgC7aVSsbmq/ungrqUUdrYL4+/vmoKJTXBgRj8hi0sjr0Or7AXoER36DIwisnhfbD5SzSQ6QPLr6hJ+ew9d38AZlu2k53
 5T7gDl9S
 B96L4LuFz/ORgAXJhXsDtJE1CNBkGtZjXNHEH/ugWDJmEGqya/n1GKhEJBkf+lWXeIu9n3mt4wN8piWp7SqYZEH9PhYh3msn6iF5OfQuLIBUt9LL7QH3ufTZUhp8DHyZSuJoaLKwrP0+OWvfhGo8+sjTB7xK8rtkgVhTmyyN05T2nib0VP1LRSNjQX8/gWKggPSjdWEQcjQDNWnqHkpsxHUQ3gstZxqCqSkVh/GNuKm9s2X7J8iC9YkEq/7CiilMlB2n9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 01:13:42AM +0100, Mark Brown wrote:
> On Thu, Jul 23, 2026 at 04:11:48PM -0700, Matthew Brost wrote:
> > On Thu, Jul 23, 2026 at 04:09:42PM -0700, Andrew Morton wrote:
> 
> > > I'm fine the drm people changing things ;)
> 
> > I'll jump make a DRM change so this is all worked out when it gets to
> > Linus.
> 
> So should I drop Nathan's fixup then?

As you may or may not have seen yet, the drm commit has been reverted in
the drm-misc-fixes branch, so my change should no longer apply.

-- 
Cheers,
Nathan

