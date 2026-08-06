Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B95A6C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC9776B00AC; Thu,  6 Aug 2026 15:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1596B00AD; Thu,  6 Aug 2026 15:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7446B00AF; Thu,  6 Aug 2026 15:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77A646B00AC
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:34:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69AD516019E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:34:13 +0000 (UTC)
X-FDA: 85071845586.19.C2ACB46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id D113A20008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:34:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mL6pNyHr;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786044851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYG4uYlSwucrFSr89w+VCACONAMfUo5j46PTWngTyLk=;
	b=ogLLMIC++IK1SkPyYbBMniYj/cnbx2KyyRDf63yLnlmjHM5yqU4sP8xVbW/+kuqLeGqj4/
	LHN9ByKJX+EqggbO+4gtVpGtWPahUgaWDCETGB2ebyfYxnJxis+5e/ln1cje5nKyRb4cMg
	gDLZ92XFnnNnSk1ajTFvtnIvz9xeZfo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mL6pNyHr;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786044851;
	b=tFuSsd1EPsaSuZHv67uRUKeTLncktxVdxD+YLTDVbu834QRAJj5o/wHETDAwv6pilL0/08
	i4M76PTh+SSThoPT90CCSowyYchPZM4K/ZPL7O93KdbcOZOC87sULm+xPlvMNKtgmhBP7E
	oL2/TcjQpl+o/r2CQBfDGIBdfAc8VyI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 663776004E;
	Thu,  6 Aug 2026 19:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A1C1F000E9;
	Thu,  6 Aug 2026 19:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786044851;
	bh=qYG4uYlSwucrFSr89w+VCACONAMfUo5j46PTWngTyLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mL6pNyHrLww6c0XxczPgoBKZaZvJDU5y4ZZ79xVCURng3I1Hw/3xMzOQYSBP/0I+o
	 opuispy05cZ4llIgDSHIRn0ZDU0EsHjo93BbSpglhDP2j2AqL+E/ctpBCelO6ONFQz
	 1F/nPM9WuQ63FhIbjJ+rmAzXKA84VKwdwm3YQ6J/RvhQKFS3GNHgHmW7/oFhIZbwCt
	 88jMIhx8LkSFN+PakMBvvfOCWNXfHOKV6/R98F1zlANTdz6TCe5rJPYL+KRaKRLhG+
	 D8mx6JOjD7dgudXjoUO7SMg32uv0a87Pwxe83fjNhZDmqupZYmpQCLWcUWYJ67jljz
	 3QFsqeteEEdgA==
Date: Thu, 6 Aug 2026 20:33:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Zi Yan <ziy@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: AI slop (was Re: [PATCH] mm/huge_memory: let special huge VMAs
 bypass the THP) policy check
Message-ID: <anTgj7uK2TLc9a4i@lucifer>
References: <anSZpAjt84Pn7O_b@lucifer>
 <5b7e84f5-2007-458c-910f-7a6e1e3d3eab@redhat.com>
 <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
 <20260806164517.GA140051@nvidia.com>
 <anS6hcgMkEJocbDJ@lucifer>
 <10b07d00-57e5-499b-a136-f2148e870d9b@nvidia.com>
 <A403B054-108E-49E8-BFF6-BE5EF8E61C02@nvidia.com>
 <anTHABoAYVUn2XiH@fedora>
 <anTHSfP9Eq-2-Cng@lucifer>
 <anTgXv9loeo4U6YI@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anTgXv9loeo4U6YI@fedora>
X-Stat-Signature: igpf9ggppxec6ebumnru6t8hks8trywg
X-Rspamd-Queue-Id: D113A20008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786044851-713257
X-HE-Meta: U2FsdGVkX1/X1wkY+ccI2mp4wav2YKMtPHp78Qg8bgzARgW9sQnXCb1wtI4Zhuf3Nyj4YTs0N5XnnBf9cU9ZcIyYJ8YRljJ5oULdOXRGbrpjIoTGaQGVY+n/XIeCbFSN0CRbIONSHKkSfctEOpaRJJ4RqQIVnu6uKn/KllQlYGUk8VeU/kFRsLRp3b8P7iqRdRUeVqPPKagZf2p1dp0zyfwKJ4yKso4LiiqEQ9yFACypOYxy2pgvzJDggkBeQVCA2VzZ986CM3xYOhcUEJC1PZfDIh2bV1GjqdsHSUxZ42IhTkVkAIGzbbEIsyZCzoW/3kNBzFLn+mGkJ2faEmnN1Mkz3wMXSdC9dBgjLcYWK3JebFfnRdg7PTYdImKbhJn3iEI/sWZJuKc7dUqdx/faqc2/GfhA5ipRysnQxrJZ7vMIKFalUYDo8uJSprH+vZrBxrTB+disfpa/JWWYHeyCV7fZ6+dfVpp0EYzxDX8O8U47zYEzFWHocgfggryruGYqoTxUcek4ZrJU8Wd1j7MgQyhuSOE+2KYB5dQsWwajo+RLXUClqpqgGkh2s2GLG5PK4whYf8CP5wOuiEzmeXYt7CzvymHOizH3jdC/Y3KV2E5z04/vN9u88uGNQSLcqlDpl1HxJLksVESsa+kv+Uq7hhgdkjx64PXFyssn2EWH4+NP57AUQ++TNbU+MPQN8i3JV0eEzNSyisg2Thwqb58LpX2cK3mNag4UPz+QA7YGhHvwqK79F8/kRng3H8AEbmJIg11E/wsMQ0DWk4r8fhQKDVXztd93rEarodJKff4b6J9v04FgWUnEkYWRLArRnXFlEAvyBdGpxtwctMtMnzwThqMCz2ib3CXccyrgtA/5qLZCLricIC9V1TarSBxmkwHuA2oqAlhvZCrp6MrHYVL44+8K2Zj3wjQkq6+DcyLYujaSL291dNrzqz8y/XCyTLic28yjQegU+MHZcWvFeYA
 Qkzwmmnt
 r1lpX72SvrbWec2334xmu0Wc8OeF0PxOHkQ4ZG/HL9k9yd9o6bhXzBNfFqfuGuq+1+WFrJwyN0L3ehyBG5Z4W2ArdhTmHDyGOXiuMo5Rjo0MVuTEsT4BsZ0eIstnI7XA9Eyq4sd6U56eAChwpv4yYNYPHiJIPjq8IoiN9kLPWXlqBeSHIEa2XvFRmvRpyLWeqMOPpbOmEjXtiSqzy0MpKqmlnJWCN3R3qz3Vf6YlL+Fcx6IWVf7T5dxB2gOzmzaoP6s+nQM3f0AfsmOsd0aPfm8IqlLCBFOz+w0XdUzGJ0c+H1H4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 02:28:30PM -0500, Gregory Price wrote:
> On Thu, Aug 06, 2026 at 06:42:49PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Aug 06, 2026 at 12:40:16PM -0500, Gregory Price wrote:
> > >
> > > mm gets everything
> > > mm-review is curated from mm to reduce noise
> > >
> > > Maybe would have to leverage a model though to surface critical things.
> > >
> > > Just an idea.
> >
> > No I don't want slop going anywhere, at all. Nothing.
> >
> > If you slop the reward should be silence ideally. And certainly not anything you
> > slopped going to any kind of branch... :)
> >
> > The slopularity is upon is Gregory. Behold the desert of the real etc.
> >
>
> I understand the sentiment, but then we have to reduce this to practice.
>
> And unfortunately, I'm about 99% sure that identifying slop is rapidly
> going to approach undecidability.  We're lucky it still emits em-dashes.

Well this is exactly why I think the trust model is literally the only
feasible one.

If you're unknown/known but -> slop then >/dev/null.

It's the only thing that's going to work.

And you build trust by doing small patches and review. Yes that can be
slopped but until AI becomes indistinguishable from a human (which would
eliminate the problem anyway) there's a human and there's a not-human way
of doing that.

Important that the trust can go the other way if bad behaviour is observed.

>
> Unless we plan on converting the list to semi-public (which feels the
> anti-thesis of Linux), i'm not sure how you get there from here.
>
> So the risk is - do you over-bury and make it invisible, knowing we'll
> miss legitimate bugs and fixes - or do you do something (anything) that
> helps you ignore it while still being inspectable and curated.

Trust model should solve that too. If a good faith established individual
or company submits valid bug reports then fine.

And hopefully we'll have some sensible means of handling passive bug
reporting (which emphatically is NOT the hateful sashiko 'this isn't
related to the patch but' stuff) and motivated parties to make the AI stuff
work but under maintainer control.

Because burnout was a thing and now it's what's going to happen to EVERY
kernel maintainer unless pretty drastic steps are taken IMO.

>
> And burning tokens to fight tokens is just blatantly a losing battle.

Yep, not going to work long-term.

>
> ~Gregory

--
Cheers, Lorenzo

