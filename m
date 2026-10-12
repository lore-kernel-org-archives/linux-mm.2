Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7566CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AACBB6B0099; Mon, 12 Oct 2026 06:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DD36B009B; Mon, 12 Oct 2026 06:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973AF6B009D; Mon, 12 Oct 2026 06:13:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 758416B0099
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:13:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC9EF140A90
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:13:22 +0000 (UTC)
X-FDA: 85313561844.19.42F7C61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 52184180003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:13:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cn9Ff8MY;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791800001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/l6twGSi8Tv/lid+YWGIvfrNTjgFzfBWWIeKTSOErY=;
	b=VusN3BeBkJs/iogaHKljvouT8+Jn/txK9pGUjOkR3qQceqVTIFXyhvnJuJMyqr2Bj1Kz3E
	WnobwvnwbLYHKXEAJmSd/Qb/0r/6ITVrtGuol9ax7gg6EumGzWr0z5MNQQHTUzQe8DyH8L
	QHU4hU3QYpc2NBZG9/il0Vx7ETvu8f8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791800001;
	b=2Y98N5e8zeQ4OegcX5o+o1HPRwjW2kPepKvF0oC7LUvtoICvftCSNcmaCjZGYKo2swdNpH
	BBnuvt0UbYhC1Q0KwQyU33cI8gH5WCHS/c8OimAvNQfOgYZxnxYxiWrZUOKg+L4wvPznRy
	ERZ78QOv/0Jpzo9o2rD+gIISJ8GUx4Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cn9Ff8MY;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDFF460142;
	Mon, 12 Oct 2026 10:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D081F0089B;
	Mon, 12 Oct 2026 10:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800000;
	bh=D/l6twGSi8Tv/lid+YWGIvfrNTjgFzfBWWIeKTSOErY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cn9Ff8MYQe3UISF+r6gBfLnNaTTS3i4pISLKlqevgMMMdI/reW+MnkisEzP0Z+uKr
	 9GzUCM3j3Qlz7LXc8jVMVKjqitJ4dff3tMidZR92hhpCB4/JY+iBDFCRVwb5NFjqd0
	 KIPN4n1CzvRQ3hjufLnbYuVsHOyM9Vujen3zS+pLqTKuCpNw8WxFFvqBr3Lnb7gdFO
	 V/5VppGwhqd895q06Ud4OYjLVamaDNFCMLT3y9mGimR3Kb2op5iW2Q7QAr51lQR45J
	 X5TfRRPPYTkmA81t92iZjPnpC0WNZvy5mJZfaDfiVAQyhH7D1k27EQYGtjp2MKzgWe
	 pGJV9/deaxAmg==
Date: Mon, 12 Oct 2026 11:13:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@suse.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	shuah@kernel.org, jhubbard@nvidia.com, kaleshsingh@google.com, 
	anshuman.khandual@arm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] selftests/mm: improve mremap_test
Message-ID: <asyxQbp8EfVE9yQs@gremlin>
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
 <3a0673a6-744b-45a1-80fd-737a366fafc4@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a0673a6-744b-45a1-80fd-737a366fafc4@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 52184180003
X-Stat-Signature: 45c1moh189ix1689g67sha8yefph88tf
X-HE-Tag: 1791800001-901619
X-HE-Meta: U2FsdGVkX1/euOLJ7uG0t1Lx7+ll2pvBDK0ltE/Pm9Qwh69sFedb16mHs7vWI00Fzt4QcXyrDLOVEl5ckGpP86g+Je+vMIOdWr7tqvFpwShSjrJuGP7ENiED+PbrgU5f2TYdyPOkh3CWr2NlgzJ62SPBSQLE9Iu0lIWjzy2NlIju/ymwwLW/Bw19cLY1kYFC89t+cuaklsBD8XYdr1hostVyCjaX3mTnjTQw3ZomI7bc+Jil572dWpANea3MBRCFSILBIHqIUVez6nvYuj2apSco6lVhgaOEnk4iAsnFHWq+8JTqzt/qSBK0xZOs2wCo/+Er6p87AmKZJWSEU4Zjfy7vhOpJbsASWJnWBMG1Rsv7UYiy1ZCKKhYwwPuYlR4n67zX8imPFgUmH5u01EP7DQI8d3JdiaUsy7e1m/J57XfBm+eNTOdOwwytN6a8tfg3dZ7+/BLD20U3uT65oJxUux57N/TckurFObazW6drtMrX8t6j5rGJXcovRzg+K0KjvX6gIhhRzE9S0YwzoCS8aXGD1yx3N9VMJ9MPA2O/ao2DnhPi85oCjvUTe4z50EgHDkakqal4RcYiMmRImhMzx9GV/9myfqZKNmW96zZdJSUMRJz+NKaP9QH2NUGeympZCQtWFP9CXdaHYrMjzggWHFqRMst2jQUrLcjFRhWBF1UuHw/+6/+Vxcn8nUgGUZ4voVY/2rDQttURwiMoOeP6C1eqYrg+ZxkOaVRZiAfsW7athVxpedYAyVpB53lNV4wzol/SbVFaYhXfDy4v/c5UhNhvKwayMI5plye+2k/P8tmY312Yi57FDub5Ik4cgXxR2SEyC2xVxS9Rb2jQA9XVYAvX7+8dNiGok/BKDgNUJ71f0jcMvLWSuaj9TJ/vWu/lvK8o2luvIZ9ilRmxLzuO+FY7oHkF0V6nBgTraTSwwidOr6lRc90dEHrOInaks5wvDN0f17jCys7a+kkr8Zk
 t/YfAFix
 nW5kKKhjLlyNtmG6d/XxQAAgIsLq6LTNaVYyVcWLzrCJIAkGXALQR7ipy4dKx1/okSAax3sbT6PD6Fw4sX6euszeFNd+WXyFXryu6jhpYTf4Wf6oyT0pOM2qS8SLVV0TS6s/tqu5euR16ZHyCWQs2S9RNcWRzqWopq3ZxybW7BHqRWaIJ7vLkbTp5h3qBWUzREERwmzjmI4IjnlRna5dY1QnCIxYibauY1uxi/A3C0e3hQ4h8Y1qMxmKkik+/3f/Gim29XyKb2lAvgsAcjO8ukWZTkjAHUs3QzhWeGslE5YN7fGbAi/DV90oDyjzNiggfbMmvRUKBiuru8AM4XZiUznUoRqjrGv0h9QqZ1Pb6bHvpJp15QBsQLK/Yq6zB3hrQ6QJlJOfmF+PREmtQhlpljmcSld1aEglNXkPKJLU3oTr+Unp0cslzXNPTMTsVJf4vHtmf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 10:20:45AM +0530, Sarthak Sharma wrote:
> On 10/6/26 2:54 PM, Sarthak Sharma wrote:
> > This series fixes correctness issues in mremap_test, simplifies its
> > test infrastructure and strengthens validation of remapped mappings.
> >
> > Patches 1-3 remove unused command line handling, unnecessary cleanup
> > checks and redundant errno handling. Patch 4 converts the test to use
> > kselftest helpers and removes manual failure tracking.
> >
> > Patches 5-8 fix handling of unavailable userfaultfd support, unexpected
> > mremap() successes, data-corruption failures and cleanup after mmap()
> > failures. Patch 9 removes perf tests and timing infrastructure.
> >
> > Patches 10 and 11 replace threshold-based random-data validation with
> > sampled validation and a deterministic data pattern. Patch 12
> > strengthens multi VMA validation by also checking the mapping state
> > of holes after remapping.
>
> [...]
>
> > ---
> > Sarthak Sharma (12):
> >   selftests/mm: mremap_test: remove command line options
> >   selftests/mm: mremap_test: drop munmap() checks from cleanup paths
> >   selftests/mm: mremap_test: simplify errno handling
> >   selftests/mm: mremap_test: use kselftest helpers
> >   selftests/mm: mremap_test: skip test when userfaultfd is unavailable
> >   selftests/mm: mremap_test: fail unexpected mremap successes
> >   selftests/mm: mremap_test: fail on data corruption
> >   selftests/mm: mremap_test: handle cleanup after mmap failures
> >   selftests/mm: mremap_test: remove perf tests and timing
> >   selftests/mm: mremap_test: replace validation threshold with sampled
> >     checks
> >   selftests/mm: mremap_test: replace random data with deterministic
> >     pattern
> >   selftests/mm: mremap_test: strengthen multi VMA validation
> >
> >  tools/testing/selftests/mm/mremap_test.c | 701 ++++++++++-------------
> >  1 file changed, 291 insertions(+), 410 deletions(-)
> >
>
> I wanted to address the concern Sashiko has over this patch series [1].
> It says that mremap(..., MAP_FIXED) over a range containing multiple
> VMAs should unmap the whole range first and then map the VMAs.

I don't think you need to spend time worrying about sashiko stuff about
mremap() behaviour in a test series :)

>
> But this is not the case, as was discussed on the list earlier as well.
> We iterate over the VMAs in the range and only unmap and then map the
> region that the VMAs occupy. IOW, as quoted by Lorenzo [2], "the
> sematics are such that gaps are not propagated (i.e. it is as if you
> mremap()'d each individually)". So if we remap over an existing mapping,
> the mapping region on which a hole is remapped should not be affected at
> all. So this is a false positive.

I will be removing the gaps stuff in any case (as discussed elsewhere
too).

It's problematic, more so for the fact stuff can get mapped in gaps before
the mremap() operation.

>
> While here, requesting for some feedback on this series, if anyone has
> had a chance to look at it :).

Thanks for the series, this cycle has been very busy so I think this is one
for the next cycle (i.e. targeting 7.5).

So I'd recommend resending at 7.4-rc1?

>
> [1]
> https://sashiko.dev/#/patchset/20261006092511.145776-1-sarthak.sharma%40arm.com
>
> [2] https://lore.kernel.org/linux-mm/agH1ZSdX_7QF8P_I@lucifer/
>

--
Cheers, Lorenzo

