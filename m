Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A61AEC01CB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D3AC6B0088; Mon, 23 Mar 2026 07:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 684C96B0089; Mon, 23 Mar 2026 07:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A7E6B008A; Mon, 23 Mar 2026 07:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48C546B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:19:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE9F2BCC01
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:19:10 +0000 (UTC)
X-FDA: 84577081260.27.77D06F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7CF4E40013
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:19:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QVvJUll0;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774264749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=be8Omfxyhootct8q6opIBjC5lnqNUVnQ0ahLDS5e7I8=;
	b=w78DInmmM+uG6SVkgTndbRJFfhMYI9wdid1gEUXY6lDFdgC1kKvN7DBbXbKmCkfLhrIx73
	YAHKJATenDHEGPniJ4Lh93crjgikSwGtcKontSxUO+hy0pEeWXHrEtA9b+WMp5LJRHHrQ1
	2ejSTj4h4yuJnsHDE13fasi+KgG6l2I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QVvJUll0;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774264749; a=rsa-sha256;
	cv=none;
	b=OxEBhl04+tm2bKBkud5hx1sf2GSRDsLCyHR66XoJCgmrYQeGx6eAsD1f35gqUbmuggSTga
	dtvqUpDXZmihlU4BErOdgv6TahPuCkhaGi9h3qBbFmQuLj7PlvsFa5AUNLX8yR+ieFFbZx
	LFvwVJpqrf46ip4FXBFqitEsvRtJKe8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9354600AC;
	Mon, 23 Mar 2026 11:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CFAC4CEF7;
	Mon, 23 Mar 2026 11:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774264748;
	bh=BUqjb6fmX3WdXilimCcafolqV7S3bcE2u0WTIz11DcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QVvJUll0uWdgpoCICr7sQ+hes8Dj7dvNlp+oSyAkvurpEuMYy7tni48HEidifWyrx
	 2tS1bibdfoVjJXvA4gWHkvlL2WqmMtaIu9EPmjPZgEr3P6Tgw+3EN0gOpX5kcny/KE
	 fBHBu3py2JWpmfh25uZFh7giDQSFBTv/33nEs9y51EyE6jP01nmiSBtzEv7+hcYwh5
	 xbY0wYrCEoYvKHHIOnZM+a/d9Fn+/r6U8h2WCtSTADaZ880m6H0DQRRHz2mPsG9r9u
	 ptYHxjE6jfPVCQLJ2Pbh08IN8OO4zFIlbpoS6JlM7YUQ5kBngQInEwju9EDzVBlgfg
	 IW0YpKltmjcUg==
Date: Mon, 23 Mar 2026 11:19:06 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-ID: <3d6cca25-75ff-434a-b210-114451f8dbaf@lucifer.local>
References: <cover.1773924928.git.ljs@kernel.org>
 <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
 <87tsu9kgv3.fsf@linux.dev>
 <20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
 <20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
 <877br4k3ya.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877br4k3ya.fsf@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CF4E40013
X-Rspamd-Server: rspam08
X-Stat-Signature: eo6m5tzsjupds74ar583se1kz1iy86f8
X-HE-Tag: 1774264749-523496
X-HE-Meta: U2FsdGVkX1+5X7QGItWSA+I2QlGblfxYKPgjASp9dJaDFlcKRB2dv+mZCZimK4nwM/wgENFlipbBRAJhCKfI/ZpAZDewRZZzCrjmhxUeaiNdGQHO63/eyQFSlntpA1hm6ooJzv9p5fw26dSDFk/d1MN7fQySaeH5Y6tVDb6pKZGsSO2dNpHTJMn3quQJ4S4mdHEAuZ20lJGua1iMqU+4Q/lDwrwonWvACAzCqNMXeAJrqYXIWOkxHLTGk2UyY5aKeIT8tgSDi9MImFPpVmvGWObx1ps45fB+HzgLLooD3Myby5SVehCDM2zM+Z5rT8VyCMW/hJeP9ttEYCYU/IrJgokAIyfAzxIkhYSutdPrmQ/mGqtlfH5eLRKvCQ1tJaxV7nZizo8LUw35A5UR3JiX1lzF+CLc2NlyI4CI6cDB5CmFGxGLk2sFasXA6/oOSOybartPrFjcTrUnTgl1/idVmQstpru49Add8gBjwiDiXIae+mhiWSpOoHfIVHzw1bV5RUTcrW4x5Lmi9WIeoVdRXuYPet+K6di4kuYmwZzzP8E+ElwztUnjWuXwlKhvORIbEGg3848yUZJUdtyacWmAU0nZx3UG9whpsWMGKDxEkmcwC5D21Thjw7g95aAkFpVWUur//g5mJdgmybe1oFyot2LOXK2OrujqLpy4YSTwWdssGj/u/I8gc0UlCA2RhIvtW2pH0cpUdpYyRuBdAQlETStFW0iBgSU4DHsDuiC85v1bNMIveC57Lwm1fF977Ywhh7EwJDg8Gu6Ac8GpmVwVo0h03cG7hgdzuBSYeHHDbJNu4/R1PfmUC+xCbVkaD0LRAAkCFTSlAjTytqEn21Z/47RE+EO/TMXjVGlIw05VeZG4rnVmv4cKFOumlkPLb2OA0uxy4Sg0wbYxTjxR6jetPJQJontr5teGIMaiO8o8/ASfp21HLX1glA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 07:12:13PM -0700, Roman Gushchin wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
>
> > On Fri, 20 Mar 2026 20:33:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >> A lot of patchsets are "failed to apply".  What is Sashiko trying to
> >> apply MM patches to?  It would take some smarts to apply the v2
> >> patchset when v1 is presently in mm.git?
> >
> > ?
>
> It's displayed in the Baseline section for every patchset.
>
> For mm patchsets if the base commit is not specified it's mm-new then
> mm-unstable then mm-stable then linux-next/HEAD and then linus/HEAD
> (and now I think that it should not only show HEAD, but the actual sha).
>
> I don't have yet support for "previous version is applied, let's revert
> it and try the new one" case. Something to add later.
>
> > The way things are going at present, I'm just not going to apply a
> > series which Sashiko "failed to apply".  And that's cool, I'll just
> > wait for a version which Sashiko was able to apply.  And then not
> > apply unless all Sashiko questions are resolved or convincingly refuted.
> >
> > Question please: if Sashiko finds an "issue" in v3 and then v4 comes
> > out with changelog words which justifies the questionable alteration, can
> > Sashiko parse that changelog justification and think "OK, never mind"?
>
> Yes, I'm planning to add it. Sashiko will have an access to previous
> versions of the patchset and the whole discussion thread and take it
> into the account.

Hmm this question presupposes that we should have to respond somehow to
Sashiko feedback, but with ~50% signal vs. noise (my experience so far)
that's just not sensible, and a painful addition to already overstrained
workload.

For instance
https://sashiko.dev/#/patchset/cover.1774029655.git.ljs%40kernel.org is
full of pretty useless stuff, including a silly hallucination
(VM_WARN_ON_ONCE() cannot be used as a conditional, it's defined as
(void)WARN_ON_ONCE() when CONFIG_DEBUG_VM is enabled).

I don't want to have to explain why exactly I'm ignoring certain things
each time.

Until the noise vs. signal is better, I really don't want Sashiko to block
anything or necessitate responses, which is why I'm very reticent to see it
send emails other than privately directly to the author perhaps.

>
> Thanks!

Thanks, Lorenzo

