Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F6B0C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30EC36B009D; Tue, 25 Aug 2026 09:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6586B009F; Tue, 25 Aug 2026 09:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222EF6B00A0; Tue, 25 Aug 2026 09:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F04B96B009D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:13:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7DB64A03B6
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:13:03 +0000 (UTC)
X-FDA: 85139832246.19.98D94B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C8E21100009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:13:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=di+7PMDP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787663581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1ooUZqu3n0X6AHMc52e/9cK3btR11yvm1f2GPiErVs=;
	b=R1P872v1YLz2E9b+4qy+iTuuxRomhcG4+CuXpUVSIYbQt+Q8Q76G0pwdbE+Zx8xRmNgwLJ
	rXL1DnBJulShq801/8YGOkBL0Q8AFMWNtK7OaWOQFvks0HBSOcLhFl44H5SLty6DiTA1Q9
	7wJeDbTI6isHTSzYaXntbUnA/CdTUdU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=di+7PMDP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787663581;
	b=JthGzp+P+eoHNADZ2UIVp6px577qMjBXExDCB3EPWr6Ix0R/fkyanJh4lWe0ljS7J4gl/8
	5x/JZpG2SZbbIjk0d+NfunEpCszr0LCl6wmxll8yWtjkq6o3DNOOY14hdpjASep/p7HXYF
	txrlbnA9XVPpVTccOkwKpAq+TkjVe7E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36D0460A6C;
	Tue, 25 Aug 2026 13:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FF81F00A3A;
	Tue, 25 Aug 2026 13:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787663580;
	bh=y1ooUZqu3n0X6AHMc52e/9cK3btR11yvm1f2GPiErVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=di+7PMDPHKJfCpsQmjVBUEbvXlQaZKb3l1YLxpWKXFvWrDrILEJQmo2eEwwMqWiQ8
	 3VtqnaEz0JXZZncs8PraIMpk3NIunXnWyDCqt//xeQu4IopzhXaHUWU6Xoy3GWVI+7
	 s9HuO+Xht7BpCV8TZf5SuXjSRTmpfgUPkO0aW21lYqDwX3vWR92tkUT1ywm9s6MVBj
	 4r7stbb/zFTi59pT0dBR3+NTuMEQQsX0avCLwwHTxxxqneTZxvVqHZjg+iV38KlDXS
	 HaF+XUuViD3b9+EpFbB1weCL89MBtsC7Hr25gFh6A02REt3u/GO5SxShPGCtPdBaW5
	 WHKXpUuewxP+g==
Date: Tue, 25 Aug 2026 14:12:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org, 
	liam@infradead.org, rbm@suse.com, akpm@linux-foundation.org, luto@amacapital.net, 
	brendan.jackman@linux.dev, liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, 
	broonie@kernel.org, mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, 
	surenb@google.com, vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, geert@linux-m68k.org, 
	daniel@thingy.jp
Subject: Re: [PATCH v2 0/2] support kselftest on nommu platform
Message-ID: <ao2Tl9CLL7WjHYun@gremlin>
References: <20260825015945.141739-1-thehajime@gmail.com>
 <f2ac9432-4fea-4007-aab0-ad80597b284c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2ac9432-4fea-4007-aab0-ad80597b284c@kernel.org>
X-Rspam-User: 
X-Stat-Signature: wc1jedqbgbz8mgq7man9ts7ijciprnjy
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C8E21100009
X-HE-Tag: 1787663581-361417
X-HE-Meta: U2FsdGVkX19e+9Y892hTnnosrTwefXbE4P5gT4+FM5FKIDv8PT2HRAOPgRkyiRY/rqQdM9Tw8Pg7d1+rS6GUIByNw9e78exungdfyJNl1k2I8oo/3FLLtsvcm8Ljyk9goJBaVfZAf1Cz5ZUYJXvDc7wpuOO1bpC7TVPRxeThvv1D3sTmDOgUfIMhlWhID0mUqXPWb4hSrQemqmTKmCn6wyU90uHFL7YiL3B3PuDDu0fmb/QN3tI0XV+/1mM/Crs6jj8QIABnAqnj2dKQaOtHKXIMCatTI+pUzLhlO8st3BVkn1gtY8g/Ofqyi/OuaxAanHZlvRd2n2WyY8FhCaXFM+gf8Vn0tD7xMDMNo1Nw4XP+mek+S2YDrjzWiP7rhdTb/mrq+F4IzTE0aOxI4h9pKTcevw/Hwch23iLn+0Q+H9JE3PpYCVG4FEG7EtPsAuup2cPVpN+vdSuk2MVOnSJCOUVcFYn8Kvj1MTZSUKoZv7K0alupi9NTTNmnfwV5aC/UYiB5zZZl9puLn2+UPdybQQ2uiX+6dtSqz+mnmm7uGasxFsjBAtOog4MkIzphzR9/Az5+Lr/qPLSL/lu5zdELusDQu0BvnxlhMMoUw+5D6ouI/psblN3KOz4CW0LBK1s0u5R1JTUrqB6ZWR6ddDeuphQ+CSpr5ykGp32O+eQm5Iq7jYKlhjIF4l0QpXZADocBIQIE81V3j0gJehiyTLTmAOelY+UwUFqxZkU1ei338v/HJZIFYhSQpyDpoN8Ag9xDzmFBkCUPX/bh9O+jtUSzzGJph+1fbR79Hcjbc4Ch/6EVtq6D/Xzug1u22hKq3Od8cP2Gx8q1SnNDeCfFxGV6igB0+21by8hqGaAhVdul14/tlu8jJakjPguwc0TLaLA85mVccZjJV+mJy9rgCNxiIcYYbCcKh/qj04tJiT+D3BSgkzvq+2lnqp497NORzYn21SIuu0RF85gnppK5MMX
 cMOQsEac
 PC98tBjhGXHqoiN//J2ySakjdCK2KkcGDvSezUPl/rFv7aSDohij+ZTIwDt+06RbgmLGHgwkx/54qexuk+UFv25DWSdF0PA+uQQ1DObytrOVH11/XmvF6tZq4Fejuu9LzA1Ln72tNe0PYbMF9UBruD4PYdVrLSjMEjzhSu3yE3vO1wXGtBH9BcbvLg1wn9l27DpMiQjf2e5bRVtEh8o1X+2XJC7e7pZT2vDX2EOfJGB6SQnLT8URFrvKutAj95mra8ssJke6uRTXihJcbKjPl8m4phCG0Vk5YpsVq8whhHyE761I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 10:37:41AM +0200, David Hildenbrand (Arm) wrote:
> On 8/25/26 03:59, Hajime Tazaki wrote:
> > We add an ability to execute kselftest on nommu platforms.
> >
> > Currently there are several issues if we wish to run kselftests on nommu
> > targets:
> >
> > - it cannot compile/build test binaries because the current files mainly
> >   assume to build with glibc,
> > - some of the tests are not able to run on nommu targets as there are no
> >   fork(2) syscall.
> >
> > The first issue can be avoided if we can build static PIE binaries (if
> > targets support it), but in our case (build on ubuntu/glibc and run on
> > alpine/musl-libc), it fails to invoke due to lack of the GNU ifunc
> > mechanism.  Thus, we need to cross-compile with musl toolchain, which
> > needs to be solved the first issue.
> >
> > The second issue is the lack of fork(2) syscall on those platforms.
> > Especially the test harness helper (kselftest_harness.h) uses the
> > syscall, which cannot be simply with vfork(2).  `timeout` command used
> > in `runner.sh` never works for nommu platform as it uses fork(2).
> >
> > nommu component in the mm subsystem has several known issues and having
> > test cases should help this situation, thus this patchset is very first
> > step toward enriching test environment which has not been well tested
> > for a while.  The test cases is implemented based on the document
> > (Documentation/admin-guide/mm/nommu-mmap.rst).
> >
> > So, for the first step, nommu targets only support low-level API of
> > kselftests (kselftest.h), and implement tests in a new target,
> > TARGETS=mm/nommu.  Other targets are currently not even able to build
> > due to toolchain issues but will be addressed once the initial
> > introduction which mainly focuses on nommu test will be settled.
> >
> > The patch was initially combined with other patches but is decoupled to
> > only focus on test framework and testcases.
> >
> > - rfc:
> > https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/
> >
> > Hajime Tazaki (2):
> >   selftests: run tests on nommu architecture
> >   selftests/mm: add nommu mmap and mremap behavior tests
> >
> >  Documentation/dev-tools/kselftest.rst         |  14 +
> >  tools/testing/selftests/Makefile              |   1 +
> >  tools/testing/selftests/kselftest/runner.sh   |   9 +-
> >  tools/testing/selftests/kselftest_harness.h   |   4 +
> >  tools/testing/selftests/lib.mk                |   8 +
> >  tools/testing/selftests/mm/nommu/Makefile     |   7 +
> >  .../selftests/mm/nommu/nommu_mmap_test.c      | 265 +++++++++++++
> >  .../selftests/mm/nommu/nommu_mremap_test.c    | 353 ++++++++++++++++++
>
> That's odd.
>
> 	tools/testing/selftests/mm
>
> itself should know which tests can be built and ran on nommu. nommu-only tests
> can be placed in mm/nommu, but I would expect tools/testing/selftests/mm's
> Makefile and run script to compile and run only selftests that are supported on
> the given platform.

I mean I think at this point with mm/nommu/nommu_xxx.c it'd make more sense to
simply have selftests/nommu/ + update the mm makefile to not build stuff that's
broken on nommu there.

That way positively nommu-stuff is put in its own place and what's broken on mm
specific to nommu can be fixed there.

I'd rather isolate them clearly rather than having them live in a subdirectory
of mm.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

