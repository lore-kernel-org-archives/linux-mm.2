Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41430CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 15:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660CF6B0005; Fri,  1 May 2026 11:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6383C6B008A; Fri,  1 May 2026 11:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 575126B008C; Fri,  1 May 2026 11:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 467726B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 11:25:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E4941C004E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:25:55 +0000 (UTC)
X-FDA: 84719226270.21.38E0368
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 66F66100006
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:25:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BlrSp4wv;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777649153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYQO2aFcGknmUIwTfs7icnKaPj2odP9t9pK+EqGG1XY=;
	b=QnUe4PZYpWFC3lahHc7DHs2OUzP+eB0DsVOKq8mZcvTbJ14q5ViJm7Uwubs5gidOaxVW6Y
	ssaTQkFBj+rB/1XlfiTsbVgA6KAjhPRpljfbDkIE4HdoYxcQpI1nE7WHzp7WINT1PQ/zVg
	inbT9YUkkRhtCLoHYjFF+g7hB1jWPHw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777649153; a=rsa-sha256;
	cv=none;
	b=WNJxi73Db4TuOGOQy3949UNpvyzb+aSXN4l1nIFODth4n3ifbRhm6Jt/Y5/MuSWBJsdSzs
	9Zxx2/BK2YpncjdVSNVBsClWxv2GA8JdvtFYAYiUqIswbLbP7AiUT1njgqQXwSGwM5vdst
	B9iaMaVmpLiYv+QPJ8iNknQZjA3pCEs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BlrSp4wv;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6E25600AE;
	Fri,  1 May 2026 15:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F216C2BCB9;
	Fri,  1 May 2026 15:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777649152;
	bh=ELgfGsxPvaqHD+H6X2GusUqMNBV/G7DowThnoh9IrVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BlrSp4wvE554fWFq+y+lP/HaALbT1NM9dBC4frlM3O+ech+F61RvM+MoV0HtNMJzM
	 VUthzBW6dF2Fts9BrX5BleQunpinUP14ZsmYHB0O+w5RXLjZRC3h9uq8mkAEWKH9jy
	 zkBD1Z2AHKNh1lNHuedOhqWRWiTqZtIZ1T02E75GMsNa4zip1WujKuFUfuBNZ6Ggd1
	 E87KmYhHNLB9581PU+Ih8mGMV/I3xNV8Tre2uxp1Lkx+IYqV9C/kgqyH/PFxAkO33Y
	 XmsBh8AIuM4+kSczqEpYEe8/KFiua8kkSJZQr+jfcMZzu7SGnQHRPmF8vga0K59e3j
	 ruap77HSz5yCg==
Date: Fri, 1 May 2026 17:25:41 +0200
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
Subject: Re: [PATCH v3 27/54] selftests/mm: hugepage_settings: add APIs for
 HugeTLB setup and teardown
Message-ID: <afTF9RCy8eBoWYaj@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-28-rppt@kernel.org>
 <2f443474-4448-462e-bc1e-55bc657d70ba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f443474-4448-462e-bc1e-55bc657d70ba@redhat.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 66F66100006
X-Rspam-User: 
X-Stat-Signature: 6bf44isdybykoh45cwc3mima6nm7o9nb
X-HE-Tag: 1777649153-597924
X-HE-Meta: U2FsdGVkX18PFxn5AD0ZsI5mXiW/TXlrooOYtkN27DecylV7mgTCUl7PkSQVJ3/Rfo3Nr4UoXY7IhKPmt3XcVip51ejoONd9/2bdOtPNDviILweab4is1zTv6Vr/ZP0/fnytQr2EzNbDkVJ3zRpQxq8tfVs3Mx8jAJ2mE02odVeaa4FyThVKtiDshRqyeYSr7fMwFvOAsO6DWPzhXzvDL7iydcUilMoz1O/2DA7aL+LwcAzx/2J+Z+7LiLNHoLUVr78eKNsebd992MBBS3TEno4E+7croWJRZba6GxVAAQtQQJSR7P5WtcLHUEeEUQA1s/WHCR7guphBBk4/D5h0AOvf3gaDL7LJbT0CDXsZe5fwATWCjkIoge807W9t3On7j8lmxHc1QVAwBO5Fgof95jCpcitdhTj4SFIvTLvmXTcdH5+dpF/QsoZZE83KMBmKvlpNP5d6mmacL/lwdL9zaN5UyYa6woggas/lB8qyzYnxaoG0XQB7JcmDfUQfHYjEYgJgskYDvKXB2HzbapPMryIGugI5mt2ndS+U9PPB1hHrnUv0+IeWNgxGXnnK6L9P/MA9Ii2CuDUT3GwrBleaHaEdE6qK0ncEIrNTWt7PYTKpjQdgbKe69WdDjZBQs43hy1vJWWw6LgQgiXP3ZyjBGKUG7Un2NVH3t5AVayna/7zG8AZyrEkjg6sVh8nnPiQsp8JLh5EywDtMBPV27Sxsd9G/kyZOUNv1j5v2Y5RYwqYck+sLsZvHrsmQyh7gsADcjMsyO9GniDrqnOGR4WD+WNrXdiGb8N+PPR/0GP6pSrPOctOH7ub4Vc5vCizkL8t947ygFWisIOsV7Gt200NcW3HOFlhJMSOfa/aOFz6tH35KwldGwzgwaQrN283vGNInrQr9rf+21OjRCT9fyKLpWZbB5/nTBdknnwCdVlTGdd2zL2akZMsHQBNRwWKmaH7FmjcDqxqdLyLrL2uUaoN
 yh02gP2c
 pyE7R5sqfMUrmiT0DxfKUu13AVyXfY48NGHcdLLJxFUuVZQe9Byh1qfXnRUlPRZ967mVh0vw7RjCEnPmQu4WLy7AVTAbYn3xI9cp54VdUUZU2l9O1TYxZKjQbcXbVW85pPwommTv1RoWFM6X2YvRBhqFKtLo4lzkDvc5o4shtvwCHcAZsgWsqk77cVwkJFEYeYcQgKJH957joBVvuIdyFAhAYvbgQnQOkjNVYISzHXmef0HjurqCEyQK7E/PBr7L9FpS7/yDZpH6xrF7VGJsLNwzhDuN/N0f7JqKgh/HnzfFFg5PcFaWQnGYqkVLM0mB29OgTf/v3x6/J3j0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 02:31:48PM -0400, Luiz Capitulino wrote:
> On 2026-04-28 16:42, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > A lot of tests require free HugeTLB pages. Some need just a few default
> > huge pages, some need a certain amount of memory available as HugeTLB, and
> > some just skip lots of tests if huge pages of all supported sizes are not
> > available.
> > 
> > This all resulted in a huge mess in run_vmtests.sh that sets up some huge
> > pages, adjusts them later and restores some of the settings if the stars
> > align.
> > 
> > Add APIs that allow saving the state of HugeTLB and setting up the desired
> > amount of HugeTLB pages.
> > 
> > Saving the state also registers atexit() callback and signal handler that
> > will ensure restoration of HugeTLB state.
> > 
> > Since many tests use both HugeTLB and THP, the atexit() callbacks and
> > signal handler are restoring both.
> > 
> > For kselftest_harness tests that run fixture setups and test in child
> > processes add a constructor that will save and restore settings in the main
> > process.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   .../testing/selftests/mm/hugepage_settings.c  | 178 +++++++++++++++---
> >   .../testing/selftests/mm/hugepage_settings.h  |  30 ++-
> >   2 files changed, 183 insertions(+), 25 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> > index 4ae7332b5e1b..9d31b53dbc67 100644
> > --- a/tools/testing/selftests/mm/hugepage_settings.c
> > +++ b/tools/testing/selftests/mm/hugepage_settings.c
> > @@ -306,31 +306,12 @@ void thp_restore_settings(void)
> >   		thp_write_settings(&saved_settings);
> >   }
> > -static void thp_restore_settings_atexit(void)
> > +static void __thp_save_settings(void)
> >   {
> > -	thp_restore_settings();
> > -}
> > -
> > -static void thp_restore_settings_sighandler(int sig)
> > -{
> > -	/* exit() will invoke the thp_restore_settings_atexit handler. */
> > -	exit(KSFT_FAIL);
> > -}
> > +	if (!thp_available())
> > +		return;
> > -void thp_save_settings(void)
> > -{
> >   	thp_read_settings(&saved_settings);
> > -
> > -	/*
> > -	 * setup exit hooks to make sure THP settings are restored on graceful
> > -	 * and error exits and signals
> > -	 */
> > -	atexit(thp_restore_settings_atexit);
> > -	signal(SIGTERM, thp_restore_settings_sighandler);
> > -	signal(SIGINT, thp_restore_settings_sighandler);
> > -	signal(SIGHUP, thp_restore_settings_sighandler);
> > -	signal(SIGQUIT, thp_restore_settings_sighandler);
> > -
> >   	thp_settings_saved = true;
> >   }
> > @@ -399,11 +380,31 @@ bool thp_is_enabled(void)
> >   	return mode == 1 || mode == 3;
> >   }
> > +#define HUGETLB_MAX_NR_PAGESIZES 10
> > +struct hugetlb_settings {
> > +	unsigned long free_hugepages[HUGETLB_MAX_NR_PAGESIZES];
> 
> It looks like we don't actually use this in the API or maybe I'm missing
> something?

Yes, it's used only in later patches.
I felt it would be too churny to add users in this patch.
 
> Otherwise, the API looks great to me. But if you allow me to bikeshed :)
> 
> I think I'd do:
> 
> struct hugetlb_state {
> 	unsigned long nr_hugepages;
> 	unsigned long size;
> };
> 
> struct hugetlb_settings {
> 	struct hugetlb_state hstate[HUGETLB_MAX_PAGESIZES];
> 	unsigned long default_size;
> 	int nr_sizes;
> };

It might be slightly nicer abstraction but ...
 
> > +static void __hugetlb_save_settings(void)
> > +{
> > +	struct hugetlb_settings *settings = &hugetlb_saved_settings;
> > +	int nr_sizes;
> > +
> > +	settings->default_size = default_huge_page_size();
> > +	if (!settings->default_size)
> > +		return;
> > +
> > +	nr_sizes = detect_hugetlb_page_sizes(settings->sizes,
> > +					     HUGETLB_MAX_NR_PAGESIZES);

... this immediately becomes more complex.

> > +	if (!nr_sizes) {
> > +		settings->default_size = 0;
> > +		return;
> > +	}
> > +
> > +	for (int i = 0; i < nr_sizes; i++) {
> > +		unsigned long sz = settings->sizes[i];
> > +
> > +		if (!sz)
> > +			continue;
> > +
> > +		settings->free_hugepages[i] = hugetlb_free_pages(sz);
> > +		settings->nr_hugepages[i] = hugetlb_nr_pages(sz);

And this as well.

-- 
Sincerely yours,
Mike.

