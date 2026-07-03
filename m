Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E158C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 19:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66266B00B5; Fri,  3 Jul 2026 15:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17776B00B6; Fri,  3 Jul 2026 15:45:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905246B00B7; Fri,  3 Jul 2026 15:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68E476B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:45:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9981C159B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 19:45:14 +0000 (UTC)
X-FDA: 84948494148.02.6416C2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1537AA0003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 19:45:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HfipuKoq;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783107913;
	b=b1gQXNUgNJZ3S8NHpoX1KD05Az7IOnq8flyrtMO1JNvqTD1xzj/kkyFdGb25wUDFhvZAjk
	bsLyPAnTd7DSIH2o8wYbezxD0/nji4aJa9udBGjskdcUFF6EPa1KlDG9Nki2Uq0ERhtZ17
	H0i+/WnB30ODcjgA5vhJIGg6VK0ErZo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783107913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKTF6vDNUBQAI9jFuD7VQkJvNOUNn1t8G/tpgnpCDhQ=;
	b=pPcyMuCHal7RJ8rGHK9BFD3LkvM1Z+0EC6/QCVafaNN2Jd8C9CFL+ZOOth64kSonxHsMTF
	p3F7c2No5a0Ke1i1BAtD0zW0H5oNm3ebPkNqU6BbbcaEPyppdR3FbVTqdHvaX9rtiwU92u
	2G1AQhnXLomwqOlfAjsl9qgiEw2oilo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HfipuKoq;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4281A415B7;
	Fri,  3 Jul 2026 19:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EA61F000E9;
	Fri,  3 Jul 2026 19:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783107912;
	bh=xKTF6vDNUBQAI9jFuD7VQkJvNOUNn1t8G/tpgnpCDhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfipuKoqA9YbTNTFO5CPy2Y4hov7rjwC1UoEu3ip3PLY4OVaz8/MocBxkxf6Ex5MB
	 ulQf0ZXbHchbTPLaLuhb4kc0W4BsTDHWs5DJ2r27N3saK0sQemoeoHJ1fsdhCSs30L
	 sfEFUWvv6QDLnh9AOnVTlmVTVxiFda76c8Fss4vPfaRrV68xiAWAJ6dL5i/czdkdoZ
	 jKQ0CFVp0O6cl9KRIMYv6WDxVwMI7z1qRzkQ9hv3XzrJ7YC86C+sTMCRPIJi/1yU4v
	 cnecisgkzaIt1MPB8p3PbvrVbsylFXGhjeZKAgPq+eBxpEP21RjPdrIjUabD6tucx/
	 A703xqyo6MPeA==
From: SJ Park <sj@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	"Liam R. Howlett" <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
Date: Fri,  3 Jul 2026 12:45:01 -0700
Message-ID: <20260703194502.102044-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <akZis7j6xSjl8K_D@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1537AA0003
X-Stat-Signature: by3gdzihoji6ah63ryosfqj31ducpt7n
X-HE-Tag: 1783107912-671831
X-HE-Meta: U2FsdGVkX18qsLoNPlzFgjOljUKCyHGH7q0xrp7VqoXsmlBb01J9YKpB1qiBJEL8kUWxmWg+WpkzedOR0XAgnT6hmgDtlJpUCnSUNzH4PctmCUSpN6RqHE5v+kKhDwEX46wGpwPqSDfD5Btu6574GglamfYh8Jw8zqWtiNrdse/CxTZsNQ94Yr4/bVcehC0VbJ38v/vnIxyHhKQ85YVz8ROdCxPqZPem8Q7iKhbvfNwVMNuFzV+9Q1hy5jNXPRxRoIH0jMTrOzp1o4r92oFb6CCIUt++9u+hdAeyiNpcKSr5nfQTD+yXpFH066+jtUxjKQJCQ3rNMng9mosFZJm9i4NeOjyoCy41FVu7DxvbXmq3+H8rwGV5rRZhBBv4IrA6W/SiHGqLw9tmGjs3La+Gq3ox1It6AvOeOF2fxKePtpKua51N2asP4medj484cYRllc5C0J2f4Gndeub02nDGHgoqyVMV3Kyb6GYM87t7QtR5CJJ0G9X1OwQZuQdvO1pn4WBvAw3neuh5ATRH/VqkLb+XnZxF1ghMM85mKUWuxGLnFg2xX/GT/0IjZMuvbpHdJZqSDZ39M9AExBEUnkgxkdAvxGi9BLAsWNWaVauMtgVAMHF4JWc6ppCIPhc916l5pjhO3B7jgVC7lN187SsjKFmMuKkUb9wLvG46mwwdDCC9GVjgF+bDvr6tY+NqsM4BJyBl0bRts9/JY0ET7506mjY8kJL14kVAd5Sf9TgaPIB/Rmn72U7zUmtw8+9vXAbV5vtclVGLoGh+RYTpKQjsH5HO/6AzecQzcj7P2USz1h6Z717bibF590LcgY3y/EIwkZqoT1AXPPmZ97KXZqW1FWBSiXnTzys0RwkEvTiYwOoJK2i/DXmZrjX25hXyrs+BD7NOGkaUysevqX2avm5XrNT/RY2kUm5CLnCBfPej+3ErxRoQssRoXQNknS70IWcBYhGdaJX3/RP+HHTf20X
 0C9TKwYb
 sMR+s7ZJo+2ZZAOIkAdEMTllCPBIxqhO1zkRcNJ5Y9eUUedAeImW5ioiqMeon6srR3P2lXI5NEU+B57fMvy7UvBK7JL/HCO1JlxrkUKFUdu0gDzt8kGsgbQyEmLIJXXXjJ+cW+qARSwx9YEihUpU+d0P5yyAz5ntVMMZs+NEyO9QhMc9TE1X0wws1dx4Ct7rrYCIgpegBrd4HwLNcpEzTHgLajj3gVEc3oyZKnzwlKCrN3YFlDco4TQa6fTdIngdfIPZFJcLDlNhsg8IsH3z8bxGv9MJn5nBpEbrRGGp0gg2AbMMGcfayR/ZN6feyaDY3/GK6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Jul 2026 16:08:03 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> On Thu, Jul 02, 2026 at 11:48:24AM +0100, Lorenzo Stoakes wrote:
> > +cc Mike re: CI.
> > 
> > On Wed, Jul 01, 2026 at 04:46:13PM -0700, Andrew Morton wrote:
> > > On Wed, 1 Jul 2026 09:04:33 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
> > >
> > > > On Tue, Jun 30, 2026 at 12:50:24PM -0700, Andrew Morton wrote:
> > > > > On Tue, 30 Jun 2026 09:34:37 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> > > > >
> > > > > > This is the preparatory part of the PMD page table swapin work.
> > > > >
> > > > > Thanks.
> > > > >
> > > > > This comes reasonably reviewed, so I'll queue it in mm-new.
> > > > >
> > > > > Why?
> > > > >
> > > > > - Human review coverage and AI review make me believe this isn't the
> > > > >   final version at all, but I do believe this is something we want in
> > > > >   7.2, and getting it under test early will help to push it along.
> > > > >
> > > > > - Getting it in there early means that others will base their work on
> > > > >   material which will probably be upstreamed this cycle, so this gives
> > > > >   them a more accurate base against which to work.
> > > > >
> > > > > Sashiko did find a lot to talk about, some of it pre-existing so can
> > > > > people who work on this code please take a look at
> > > > >
> > > > > 	https://sashiko.dev/#/patchset/20260630164143.1595669-1-usama.arif@linux.dev
> > > > >
> > > > >
> > > >
> > > > Hm, my understanding was that mm-new is where we take everything submitted for
> > > > early testing?
> > > >
> > > > Did something change?
> > >
> > > mm-new has always been a few day front-end to mm-unstable.  To protect
> > > linux-next from brand new material.  It serves no other purpose.
> > 
> > Well it only serves a purpose if it gives us better testing.
> > 
> > We have a CI running tests now though, Mike - is that predicated on material
> > being in mm-new or does it just grab the email?
> 
> CI grabs patches from patchwork and tries to apply them to one of the three
> bases: mm-unstable, mm-new or the latest Linus' commit merged into mm.git.
> 
> If patches apply, the other bases are not checked. 
> 
> This patches applied cleanly to mm-unstable and successfully passed (at
> least once :) )
> https://github.com/linux-mm/linux-mm/actions/runs/28544575927/

Awesome!

I found the CI script (mm-ci) on the GitHub organization.  Is the repo open to
contributions?  If so, between GitHub PR and patches to linux-mm@ what is more
preferred?  Seems it is not running DAMON specific tests, and I want to add
DAMON kunit test to the test set as a first step (DAMO selftest is bit flaky on
some systems), if people don't mind.

I or someone else may also want to add more tests like Cc list checking [1] in
future.

[1] https://lore.kernel.org/20260703190421.100480-1-sj@kernel.org


Thanks,
SJ

[...]

