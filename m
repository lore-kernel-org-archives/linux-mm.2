Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 382C1F33817
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AB3B6B0088; Tue, 17 Mar 2026 04:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E186B0089; Tue, 17 Mar 2026 04:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5D46B008A; Tue, 17 Mar 2026 04:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47DD06B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:45:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DCDD18BF4C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:45:31 +0000 (UTC)
X-FDA: 84554921262.09.15FF872
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 47D73180007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:45:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MWxjrMp6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773737130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zo6yw1mAyD4MxWYXRaqbuKoO6iygTs63aqmw/CfuPrg=;
	b=zRf+zKGOve0soQU9sIqPVZBzRpwREf+EgK74XBQ4OfyIPlOCtpC4bSeBZychtRh5BFFbAk
	RhPzjWg7B9P7z9CBhKgLbhF4jStPI6/+WE6yUD3mKQdwjjgtWRW59ZWcR+YGJKiF9RLPFa
	y3VBQiyEXXEXBquuXXMlIA7298jlv+I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MWxjrMp6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773737130; a=rsa-sha256;
	cv=none;
	b=yQ7gcLy6wSLh1uMHhJ1K9mbePk2TXsuge9Qf8/GffoIUMRjzCqH7o8YRH6qZkaTjHicBf7
	AK4V3uNc3jcO18DLLUPEOyZaJ32DXR4vh7/rhH2WbinmuOJRahwOHjritGqry/X4ZPb9yx
	uUIEpfcJ4p4b9I0aN1aFmfZzX7hgrBU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AF4D60103;
	Tue, 17 Mar 2026 08:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030A7C4CEF7;
	Tue, 17 Mar 2026 08:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773737129;
	bh=Zo6yw1mAyD4MxWYXRaqbuKoO6iygTs63aqmw/CfuPrg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MWxjrMp6K6R0o7Q+bJjI/SPcVgg9uRqw/NVogBDNxIxU9g+kLl75KBSwQX5Csh6cb
	 kG/Fh4usrU4Bxg6jLTPYjtwjSwhygytDx8iHL9EzTZVGRzvysQIs3vVgow1v6zwzHn
	 DlVE35GFI1HhCiQF7kujveQbDItw8iBNN8eIHFbifDxvbSxL9uM4S7VX2574LL8cSA
	 NMTL78OKHQN0yxnvssG4DPRjQjSvJcoQKfaXWHVgtO4ci80ffsCjuRpLq9E7Whv/Bh
	 MGtvCBCmZl6yah5annGFpUIfg2eu4z8GMBXnFJQUFqzUMq4smisQw3egIkvO/Ri7h7
	 00RS8mnGk7/Kg==
Date: Tue, 17 Mar 2026 08:45:24 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] selftests/mm: add THP sysfs interface test
Message-ID: <51a4855d-89cf-49e7-bd4f-f0ba13f23102@lucifer.local>
References: <20260309-thp_selftest_v2-v1-1-a00cef41da44@debian.org>
 <9cb63c24-eaff-4954-97d5-2a422a0401fc@lucifer.local>
 <abgJtJYQsGMPsTHr@gmail.com>
 <be860d86-75be-4c75-95ea-03bf79524be2@kernel.org>
 <abggyaVTdNe6n_ew@gmail.com>
 <c4cb6dfe-59b2-44e6-adbc-9ee63bed79fd@lucifer.local>
 <abjqDUpkezMfvCHz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abjqDUpkezMfvCHz@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 47D73180007
X-Stat-Signature: pk7uzeet1fjpkpyezofrqpqhq796chq8
X-Rspam-User: 
X-HE-Tag: 1773737130-674727
X-HE-Meta: U2FsdGVkX1+e9hgU1wrYZnDodjfevI/5kuDfV3bXxnniJEncupNRsIo7NVy1fRjj3Y3G1QdLxIHVNaWZUxZdfojzgiOfrJ0P3RyMHD4Te8BeXcMFX1H6zo6O3HU1j67hqfjqvVKyS9BAqHLgvgNiCwckQRGr2aVp9ORNCWQeoUkY81O0dO/xjy74KGe5u4Q2Ihu6KL1hrvxIRKFScebA0wipYuO6E+SjmeB/5BIuhvtHdR2UI4Jx78BOFkVrv4Rx+AfRq0s54R7qj+3ZOEqgUzDnEY83R2QpeD8HdA6y7wuvMuMyI2mf+Gh5pywe1nShRgrzCHetfzrM8CWnsmNJLak47tK/tWjGa9hdUunlE/Uvf4zmh6evLOnAU0qyrOG52fX98ovnYMMlD2h0EdhIo0I6MD9NmA/3YL4vD12GvOUpWw4hpLlpzQYgfC85BwDc+B9C6XZ4MKLew8bhsVnKhRbwt6r5wJxK6bO6YuMMPh79dkTa37lVIABecAXprHHNb0rlJ8cGdOgzk2/MP7aNl9mAVu9ph8S2120VfBCKjYUwlweleqXGCda/p+pw5BF8cMqUfS3zsI995Wdfzn0VzgEQnwESeEuAaTSdmUv5Hg58iNrHDPox5htFeu1Hvhk8kCtGX1z7Sz3ujmCTzWYnkvAlFo6lE8Hiv0G1+eEKlJ25M8A1d0FH1hZyrN8d6vYy1OKXiJfpFbRBDKZGFJr5J53G4H0lpeiqi/sp2CrtMaHBB6+FoR7UMrgFhBlZ3+We61/+ngVUMscf7jhTjWwXuFPkrA0ogsBhyq9dRXnIISzXBNk92m2laaMQtEPG6/ADBKnclRuSnBtNZ3fSvh22/NXEQOjJ66oDhtOEg60tMLz6X2xOMBCBYg7FVPWFK18Z1f/OadP4xF0YgkbVDohrnG7eJr9TX+eHgwGEtXaNsuCxXK1KXufCnSEOG1D78SsQdqfPHx2nvrnSb5ERfCL
 9jk0gZKG
 vqacA5pN7a8OL2VtIXKw/00MizlVvFOxsVMutDrt09ZHxmS9M4bG1mog/khQ3EMlTAvklITDvTJXDtPyBAYsxPBUSh2uCziiQz/PzS3xqv0EwWW4Ia9p+e4Uh3D5mRRmjst6UKXr7ZTYyqt0G+HjSu5CFImx7RofmkpIo9ytZyZNvUjt7mJiVdlhiFX2G+dUSzXzvC2ZqppbrnpEz98/3ZdSvpK2pu7oDjt6iNXejAKAjrTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 07:43:41AM +0200, Mike Rapoport wrote:
> On Mon, Mar 16, 2026 at 07:53:46PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On Mon, Mar 16, 2026 at 09:02:33AM -0700, Breno Leitao wrote:
> > > On Mon, Mar 16, 2026 at 03:44:14PM +0100, David Hildenbrand (Arm) wrote:
> > > > On 3/16/26 14:47, Breno Leitao wrote:
> > > > > On Mon, Mar 16, 2026 at 12:55:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > > > >> On Mon, Mar 09, 2026 at 05:00:34AM -0700, Breno Leitao wrote:
> > > > >>> Add a shell-based selftest that exercises the full set of THP sysfs
> > > > >>> knobs: enabled (global and per-size anon), defrag, use_zero_page,
> > > > >>> hpage_pmd_size, shmem_enabled (global and per-size), shrink_underused,
> > > > >>> khugepaged/ tunables, and per-size stats files.
> > > > >>>
> > > > >>> Each writable knob is tested for valid writes, invalid-input rejection,
> > > > >>> idempotent writes, and mode transitions where applicable. All original
> > > > >>> values are saved before testing and restored afterwards.
> > > > >>>
> > > > >>> The test uses the kselftest KTAP framework (ktap_helpers.sh) for
> > > > >>> structured TAP 13 output, making results parseable by the kselftest
> > > > >>> harness. The test plan is printed at the end since the number of test
> > > > >>> points is dynamic (depends on available hugepage sizes and sysfs files).
> > > > >>>
> > > > >>> This is particularly useful for validating the refactoring of
> > > > >>> enabled_store() and anon_enabled_store() to use sysfs_match_string()
> > > > >>> and the new change_enabled()/change_anon_orders() helpers.
> > > > >>>
> > > > >>> Signed-off-by: Breno Leitao <leitao@debian.org>
> > > > >>
> > > > >> The test is broken locally for me, returning error code 127.
> > > > >>
> > > > >> I do appreciate the effort here, so I'm sorry to push back negatively, but I
> > > > >> feel a bash script here is pretty janky, and frankly if any of these interfaces
> > > > >> were as broken as this it'd be a major failure that would surely get picked up
> > > > >> far sooner elsewhere.
> > > > >>
> > > > >> So while I think this might be useful as a local test for your sysfs interface
> > > > >> changes, I don't think this is really suited to the mm selftests.
> > > > >
> > > > > That is totally fine. This test is what I have been using to test the
> > > > > changes, and I decide to share it in case someone find it useful.
> > > > >
> > > > > Let's drop it.
> > > >
> > > > Out of interest, to we know why the test is failing for Lorenzo?
> > >
> > > I really don't know, but, it sounds like ktap was not found?
> >
> > Yeah CONFIG_KUNIT is not set so could be :)
>
> Nah, CONFIG_KUNIT has nothing to do with ktap_helpers.sh, probably your
> environment does not bring in tools/testing/selftests/kselftest

Yeah I copy the mm tests to /mnt in vng before running to avoid ro
filesystem issues.

Not a fan of us relying on the entire tree structure being there either
then :)

Cheers, Lorenzo

