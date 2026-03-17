Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ECD3F506CF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 05:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6453A6B0005; Tue, 17 Mar 2026 01:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FBAD6B0088; Tue, 17 Mar 2026 01:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50C1C6B0089; Tue, 17 Mar 2026 01:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA846B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:43:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAF1BB99F8
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:43:52 +0000 (UTC)
X-FDA: 84554463504.04.2FA413C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id F1ED5140004
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:43:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P9P16qWF;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773726231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfbdwUUfJ+rW7yjiCmvqfgASGa6thYPU3pE1N8HY7Pk=;
	b=TU7yN262/8dpvE2NkNZnVKBt9x0KLguFUlvYzY+HUDOVELyo9K4YJ6EZm4Nn9paIiynBxA
	h8Q3vfebShrZVlMc70zQvgTVfMGTSXhZUZvaTYJ5bHASIT8q2hsNWzphGMzNmTssjynGSb
	2wp6LXPRsTih02Lt/Vx8nZmgFrkbyOM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P9P16qWF;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773726231; a=rsa-sha256;
	cv=none;
	b=Txj+Xvo557UYX8bt4SSfdMBb8Tw3XjhWHHXDVUMzGxrrhJwXtXINuOXwzL8nRtXMZGHY2w
	GlRrOPKxOip7yM4Vb8aBTCDg2PYy7i6dIIcsiWtv8BfNetL8zkaUcQmi7A4rdgZDHnSpvE
	fadfZBB3oAj9NVJB6vwAKpYATN7RSnM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E045243444;
	Tue, 17 Mar 2026 05:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F8FC4CEF7;
	Tue, 17 Mar 2026 05:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773726229;
	bh=aPJSwxGH6jNMzmpJsV3VWFn7DBqjxw2t4PJgg3D/cuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P9P16qWF5ooL+iMl2PrfJJDFMJjHxAx856NDb9rJnaSJVoH6HeaE40ymfvWrF6dgt
	 IDNO+1BU/L7bQpZB16aPEttGPgQNyCUp4LydF7OAOEmA8DXIvpY022XOrostvXPJfK
	 hS246hpL/l+jgIOTok0YltjBZL0PggpEib3zodIQS4mXI3d7VwITGLJB6970J7qtlL
	 N4w+eNtWvGvkmRREB4Oz6K+ZFFzwMXrGqlVOMpbNztTrIcWnOAdTbgdagsBC8kpYme
	 QpQy5kurZ3x6/Kv5ncJlLstfAe7Q8y84BIOTxQDrHT3f5LGy5HVG7sBijUrA8DfB1w
	 1R5hkhGudmOxA==
Date: Tue, 17 Mar 2026 07:43:41 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Breno Leitao <leitao@debian.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] selftests/mm: add THP sysfs interface test
Message-ID: <abjqDUpkezMfvCHz@kernel.org>
References: <20260309-thp_selftest_v2-v1-1-a00cef41da44@debian.org>
 <9cb63c24-eaff-4954-97d5-2a422a0401fc@lucifer.local>
 <abgJtJYQsGMPsTHr@gmail.com>
 <be860d86-75be-4c75-95ea-03bf79524be2@kernel.org>
 <abggyaVTdNe6n_ew@gmail.com>
 <c4cb6dfe-59b2-44e6-adbc-9ee63bed79fd@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4cb6dfe-59b2-44e6-adbc-9ee63bed79fd@lucifer.local>
X-Rspamd-Queue-Id: F1ED5140004
X-Rspamd-Server: rspam07
X-Stat-Signature: djy77rdasc7jsu9efmim3s4xbo5h3rzo
X-Rspam-User: 
X-HE-Tag: 1773726230-344675
X-HE-Meta: U2FsdGVkX1+bdfsOx42g4Pcbjo9U5D3uFTknJ3eUzfvUGWWnjQw+cXAVo5LNEGimifZI63KiDUStxRubKy6L9SiKEza4xs+jm321u1rzH+Lkx94iUoHp0I3QdsoMDT9Wmw7bXLu+CZUcQvU0/MOJY3M/LLMrYEUdYdZaMPf05SuoIJPIi8ZVbNVkTA3EDv5cttb+DoYczbim8zWRhsWo1yGasjEQIyTJcdcjGGN1bms9jnadpTyAeInYYlpXwI6/VpmFGioUwEmSKT23MywcGutcWLSL6JruF+8bri2tlSJjaRfSHPvRc9tGe9c7LF1EbJCDLjbiuKh0E3v1S0BjeXX/og3U1OAHEIXGYnYIs3fUD5MPeNdMiES4bnooZEQBB+LlQ7hIjfLM5OZm0VGvskJmiEZpd07K5dTPlF68b3c2GLy8Tee2PPYDMqT9d0J+ciBHBMCrII3/g5NdXqHOQIo8txchMY5VFkV9YjcbA6OGvQjxtvNzZDnQ7UvUlQe93vh0xvSuP7ulJifnOSVB9DjC/llXx7/57I9LeiS9TXrV4nZ3otAVYJXvcRDypqeyp7ep2JvsixMLKU1HGfgVUDBe4oRMirdrJ79c8/5juXv4++xaj0ZsOAotA9CN7ZMNAyyoe+pueKZwPfhtUVoD2PUQnk0l/2tF9/o9HTRcc8RCuWS7Isx7MjmJQWJ+xCkfpfuuQ8nXUHWLtGuyhOmeQTiUrfRp6iTMtsIi0P9GwduJ0MkVYfeoi3t2b5B+Y3dLXZYhQIEIx726MBQMCHlPjbAnP1ENTdMJGNHWeg0jFCd3hf7bX27kS5pL3CnrDtFgmZNhiuEi5VC1J2YL3HXAHS80c9YVL3d6vS8tcsgsOj6/KivuF7netf/kFnbtRhAtbrjSrcElahotULMz0m6dGg6f75Idshov0W2ATNjcyF7gpNsN79Qe4n3L6w2BA/KI26KyhQmLg8Qqa7+uiQu
 UhY1GWQ1
 xjtr/yWaVbYoWz7+iPE0Eyq1oQZWmeSN9REdAeERNraO6FGd4TFkfqA8pli0AuSoPwIcqXxHClpSclDnbiPVC+4Odt5IKv2OhKPMzKcwxDglIsAmuohimYx0cJK9iC7MW4aU0CpKhSKa+w9viCJ0ofkVWdzg4wxa0mXb14kbTpvxkmjZ4kFim7/duuP2IE01+cMFAjEt9BT9KOfeK+qSEBhZHJreBU7us4Te+fl8TtRGrvw3ZR9cxe5Z+BXA7zI4i0iJeXpCThKJd0mb0i5UTg1xxrdW749KBxddU3X2hgKXisAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 07:53:46PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Mon, Mar 16, 2026 at 09:02:33AM -0700, Breno Leitao wrote:
> > On Mon, Mar 16, 2026 at 03:44:14PM +0100, David Hildenbrand (Arm) wrote:
> > > On 3/16/26 14:47, Breno Leitao wrote:
> > > > On Mon, Mar 16, 2026 at 12:55:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > > >> On Mon, Mar 09, 2026 at 05:00:34AM -0700, Breno Leitao wrote:
> > > >>> Add a shell-based selftest that exercises the full set of THP sysfs
> > > >>> knobs: enabled (global and per-size anon), defrag, use_zero_page,
> > > >>> hpage_pmd_size, shmem_enabled (global and per-size), shrink_underused,
> > > >>> khugepaged/ tunables, and per-size stats files.
> > > >>>
> > > >>> Each writable knob is tested for valid writes, invalid-input rejection,
> > > >>> idempotent writes, and mode transitions where applicable. All original
> > > >>> values are saved before testing and restored afterwards.
> > > >>>
> > > >>> The test uses the kselftest KTAP framework (ktap_helpers.sh) for
> > > >>> structured TAP 13 output, making results parseable by the kselftest
> > > >>> harness. The test plan is printed at the end since the number of test
> > > >>> points is dynamic (depends on available hugepage sizes and sysfs files).
> > > >>>
> > > >>> This is particularly useful for validating the refactoring of
> > > >>> enabled_store() and anon_enabled_store() to use sysfs_match_string()
> > > >>> and the new change_enabled()/change_anon_orders() helpers.
> > > >>>
> > > >>> Signed-off-by: Breno Leitao <leitao@debian.org>
> > > >>
> > > >> The test is broken locally for me, returning error code 127.
> > > >>
> > > >> I do appreciate the effort here, so I'm sorry to push back negatively, but I
> > > >> feel a bash script here is pretty janky, and frankly if any of these interfaces
> > > >> were as broken as this it'd be a major failure that would surely get picked up
> > > >> far sooner elsewhere.
> > > >>
> > > >> So while I think this might be useful as a local test for your sysfs interface
> > > >> changes, I don't think this is really suited to the mm selftests.
> > > >
> > > > That is totally fine. This test is what I have been using to test the
> > > > changes, and I decide to share it in case someone find it useful.
> > > >
> > > > Let's drop it.
> > >
> > > Out of interest, to we know why the test is failing for Lorenzo?
> >
> > I really don't know, but, it sounds like ktap was not found?
> 
> Yeah CONFIG_KUNIT is not set so could be :)

Nah, CONFIG_KUNIT has nothing to do with ktap_helpers.sh, probably your
environment does not bring in tools/testing/selftests/kselftest
 
> >
> > Then the first early-exit path hit:
> > ktap_skip_all "..."   # undefined → returns 127 exit "$KSFT_SKIP"
> > # expands to: exit "" → exits with last $? = 127
> >
> > > I agree that the test is a bit excessive, in particular when it comes to
> > > invalid/idempotent values etc. I could see some value for testing
> > > whether setting the modes keeps working, but also then I wonder if that
> > > is really something we'll be changing frequently (and that breaks easily).
> >
> > yea, I make it very excessive, because there were some intrinsics in
> > those sysfs that I was gettingit wrong when doing the intial conversion.
> >
> > So, the test is something that I trust now, and I found it useful when
> > finding regressiosn.
> >
> > Is is something that will chagne frequently? probably not!
> >
> > That said, would you like to have a simplified/different version of this
> > test?
> 
> In an ideal world we'd use kunit or something to assert it internal to the
> kernel I guess, but if we do have something scaled down it'd at least be nice to
> have in C? :)
> 
> I am not sure how useful it'd be though overall, I don't see us changing this
> too often and really we're more interested in asserting behaviour.
> 
> Sadly THP is inherently tricky to test generally because of its very nature, I
> wish we could have better test isolation etc.
> 
> See tools/testing/vma for a forlorn dream of kernel code being run in userland
> (but oh how the stubs/duplicate declarations/etc. are a pain).
> 
> I suspect THP could never be given the same treatment though! :)
> 
> Cheers, Lorenzo

-- 
Sincerely yours,
Mike.

