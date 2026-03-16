Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6894F53D90
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102066B0347; Mon, 16 Mar 2026 15:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9156B0376; Mon, 16 Mar 2026 15:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EED346B0377; Mon, 16 Mar 2026 15:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CAFAB6B0347
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:53:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84CC41A04CF
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:53:53 +0000 (UTC)
X-FDA: 84552976746.12.B0B3FB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E7D3B16000C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:53:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t18WZDn9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773690832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SjaVXi23hMAWVn6VVXHM3+UbQAm0iK1tDevXssTCbOU=;
	b=wt5XE2/R6aTQgjcVoXUt7lNGFx5qpy0Z5kJnP0R9DwdRtcY8YrLwClZCPVO2stmZVZQg/r
	aH1sDtqiAHC3HSl8Es8sAYDB/yJeTsqdsoOThHLnF7suigs4r3SOeF+qlg9OkysemmBDkw
	Rf4+VdMStqQhZcDw4yrzP6E9b23YtEk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t18WZDn9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773690832; a=rsa-sha256;
	cv=none;
	b=25MB6VSHKEWTWJxRREfafxFK3OrYzQpq1xuh4NHIsU6/LcaT9HnKo5BPWnBQ4e8wtdD761
	n7rnDfkyYPmn1BRK7RVOJI8xABoma+ZkpdDN+w9BTEXh/U9BuSbvC3tl1a3DT0i0AGOtan
	0vKB65WbcOsGf2FXHzmjV7oowMUsP08=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA111441BD;
	Mon, 16 Mar 2026 19:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2C4C19421;
	Mon, 16 Mar 2026 19:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773690830;
	bh=4gAWIaQHRU4NRXeDrvanjMXhFCTsNn7ar/qA+AJSFaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t18WZDn9tATEb4JJzJCP9h4y8am1c2DaDUz3D/4c3LR1CanJ8UkdHvKzHoDrkzqwo
	 cnZqDSmkqMxoaOazN6kyMRySPjKL5FflxSUqcK1EHqAmR2/5ZPN/yWm6x8ymrAIIFs
	 76t6R/a7DYawFl64pYb1e0E58DrnNlZ6BIUZ2q0+NiAg2ois1UX6KCQjfJUgfoKW7r
	 96YqIgjC03vZMIEz6U7rVSTMNEd13dqxfQ8IpR6bwDwrNQJ3W9SJLAFJCCnd37UYNl
	 3/0fB29fX9RoRMAkTQMLtatWLzapsdev43Tee2b0HtWmPSjLY0SEr6XhrqWzmZYj0B
	 OoMZNIGvNHjUg==
Date: Mon, 16 Mar 2026 19:53:46 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] selftests/mm: add THP sysfs interface test
Message-ID: <c4cb6dfe-59b2-44e6-adbc-9ee63bed79fd@lucifer.local>
References: <20260309-thp_selftest_v2-v1-1-a00cef41da44@debian.org>
 <9cb63c24-eaff-4954-97d5-2a422a0401fc@lucifer.local>
 <abgJtJYQsGMPsTHr@gmail.com>
 <be860d86-75be-4c75-95ea-03bf79524be2@kernel.org>
 <abggyaVTdNe6n_ew@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abggyaVTdNe6n_ew@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E7D3B16000C
X-Stat-Signature: 9m3kdcxhic93sb7p4hiha1airks1yguk
X-Rspam-User: 
X-HE-Tag: 1773690831-263143
X-HE-Meta: U2FsdGVkX18lWqRmkiHjJdxmTRBw7A1NmZfYTqS9Ld1WD7jwcwo278Qtt4QW6vAE5fiGyeqVJ1QbBjEPTtcZeGRyeQ9jWRVR7cqCvex8MSiuV5D0B+uyke2E0rFkPZo5HCDaBHyjJkHgcoSh7IeUmbAr0oo/XRaRWpMCvqDRETowS3S4zoNiiFUZn2JS7mkKmIyS1MxaFryL0ftt97fSTIreQ+hOyq2MbbOZRZwKp9hb4w3V+ksSa+b6n6fDIHY6m+SgL/biF8hLQl5piqPHCV3gmk8LbCt2vJCUe+/v6gyPhe6ULiIB0qM09NYp0XPFn/mJd42iOa2N9/HaXjjO+boB5Ukh+ss5TxgQvM9uVxWjgW3BmWfvffp2BU+WTuIScYPOp7B08GbuD80KVbNy2+Bvmr1ZA4cn8keC5jwsaLJeubL8tvxHY0jCs4/AGiS+Dt+wZmI9zIVKxl9o430o7q+9RGFlCAaFTtoUSj0Urr4glvrb+qfhTRhD/Rp1yN9lLNdREbXDbQKtrM+EkCEoPU1krLabhI+70Oe0Y4k8J6oUmIdirOEB62rj8ecvTg4sAUUWA1OcS1LhFV6SO4L8v788llIymH18x2jB7iy1xu8bTBhviXY6rgX8xsQru/df/PM5F+vM4GoLOEnFmP6lJcBM3lQy4Y8/QKw8ESFQuXqvIoURZh2US4WIFTeRu8zQNoeF4zjcq57WdOE4L+L5sCyVFI84fwcQ1iC6Ti2ryvsSyBAPC1NWFyyN+sjFghtt3abJMFVpYMU+YwYis8UvkIIMRZLZ4b16u0qS1oRjSWy4x57LM80CEgtau0Mt2laqHWg7iE1VpHBEx4fLZc+b18wSXACJvOZbnvtbvd8OsMeIAWeyoL6mntTVHCnDY/b+rlgSpgN1+wc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 09:02:33AM -0700, Breno Leitao wrote:
> On Mon, Mar 16, 2026 at 03:44:14PM +0100, David Hildenbrand (Arm) wrote:
> > On 3/16/26 14:47, Breno Leitao wrote:
> > > On Mon, Mar 16, 2026 at 12:55:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > >> On Mon, Mar 09, 2026 at 05:00:34AM -0700, Breno Leitao wrote:
> > >>> Add a shell-based selftest that exercises the full set of THP sysfs
> > >>> knobs: enabled (global and per-size anon), defrag, use_zero_page,
> > >>> hpage_pmd_size, shmem_enabled (global and per-size), shrink_underused,
> > >>> khugepaged/ tunables, and per-size stats files.
> > >>>
> > >>> Each writable knob is tested for valid writes, invalid-input rejection,
> > >>> idempotent writes, and mode transitions where applicable. All original
> > >>> values are saved before testing and restored afterwards.
> > >>>
> > >>> The test uses the kselftest KTAP framework (ktap_helpers.sh) for
> > >>> structured TAP 13 output, making results parseable by the kselftest
> > >>> harness. The test plan is printed at the end since the number of test
> > >>> points is dynamic (depends on available hugepage sizes and sysfs files).
> > >>>
> > >>> This is particularly useful for validating the refactoring of
> > >>> enabled_store() and anon_enabled_store() to use sysfs_match_string()
> > >>> and the new change_enabled()/change_anon_orders() helpers.
> > >>>
> > >>> Signed-off-by: Breno Leitao <leitao@debian.org>
> > >>
> > >> The test is broken locally for me, returning error code 127.
> > >>
> > >> I do appreciate the effort here, so I'm sorry to push back negatively, but I
> > >> feel a bash script here is pretty janky, and frankly if any of these interfaces
> > >> were as broken as this it'd be a major failure that would surely get picked up
> > >> far sooner elsewhere.
> > >>
> > >> So while I think this might be useful as a local test for your sysfs interface
> > >> changes, I don't think this is really suited to the mm selftests.
> > >
> > > That is totally fine. This test is what I have been using to test the
> > > changes, and I decide to share it in case someone find it useful.
> > >
> > > Let's drop it.
> >
> > Out of interest, to we know why the test is failing for Lorenzo?
>
> I really don't know, but, it sounds like ktap was not found?

Yeah CONFIG_KUNIT is not set so could be :)

>
> Then the first early-exit path hit:
> ktap_skip_all "..."   # undefined → returns 127 exit "$KSFT_SKIP"
> # expands to: exit "" → exits with last $? = 127
>
> > I agree that the test is a bit excessive, in particular when it comes to
> > invalid/idempotent values etc. I could see some value for testing
> > whether setting the modes keeps working, but also then I wonder if that
> > is really something we'll be changing frequently (and that breaks easily).
>
> yea, I make it very excessive, because there were some intrinsics in
> those sysfs that I was gettingit wrong when doing the intial conversion.
>
> So, the test is something that I trust now, and I found it useful when
> finding regressiosn.
>
> Is is something that will chagne frequently? probably not!
>
> That said, would you like to have a simplified/different version of this
> test?

In an ideal world we'd use kunit or something to assert it internal to the
kernel I guess, but if we do have something scaled down it'd at least be nice to
have in C? :)

I am not sure how useful it'd be though overall, I don't see us changing this
too often and really we're more interested in asserting behaviour.

Sadly THP is inherently tricky to test generally because of its very nature, I
wish we could have better test isolation etc.

See tools/testing/vma for a forlorn dream of kernel code being run in userland
(but oh how the stubs/duplicate declarations/etc. are a pain).

I suspect THP could never be given the same treatment though! :)

Cheers, Lorenzo

