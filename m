Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B894CD3439
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B5E6B00BD; Tue,  5 May 2026 12:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C236B00BF; Tue,  5 May 2026 12:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B696B00C0; Tue,  5 May 2026 12:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5706A6B00BD
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:32:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B06F4041D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:32:16 +0000 (UTC)
X-FDA: 84733908672.06.EC55C9A
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id 94CC3C0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:32:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=C0edgU1b;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777998734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6yeaFiPlZGZf41NsmyX0In93MXNmdncNWDHYjC/idU=;
	b=lW0fKaO7VwgMJNB552bzNNSm1CguU051kDd6pOoYPB1Tm2nZcn398lQAqKDeIe0XS0otPS
	T5jWi5UhZUe9WE43r8h96q69NgjSHT/vcTxi4C5ISiD4iLWcJGWVrAN7iJIC5OcZplxB5x
	8+Kyrlrtia8O6cWXtSDHMWP37c2ofGY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777998734; a=rsa-sha256;
	cv=none;
	b=kg+ej6YIJ9PBqP91Mm0n5vdnkztoxGCTDvkiD1HwgEMhCkgr0ja8oadPOxXrvK5eR5gq0V
	DPkr1tgcUrVsZ8UFExzrGb2LVWtfe0tRJKvZYSsp3IzLAnfMSQkX8Fck7wMPsXm004zJZF
	xNNoaPRAVJQ74kqZ2lYo70NQWWFhzHM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=C0edgU1b;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50fb4a7d704so43903011cf.1
        for <linux-mm@kvack.org>; Tue, 05 May 2026 09:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777998733; x=1778603533; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q6yeaFiPlZGZf41NsmyX0In93MXNmdncNWDHYjC/idU=;
        b=C0edgU1bBd+cydtIDVc6JS9l6W2S0+gzC9yadtHI6M/Cj8j9Qguiljw74m/gAJs3US
         FfVr+aHL4RpV4Brk/7npEPFgiCmXRSEtrYfMXyjNYErdb9vsCg9LkdFHydbenN4iOLlb
         gs0/VN4RRjHzbfBz+oTkwAdpsoEnV99IzAqWuu4hXMs31e+b4hcL/EsRH8MA4jXJV1Sk
         +645FozQkUour/W44zPTbQ+sa/RNBp8RYSoaeKd6OcZxjakpL9Iu4Ttapwtx85SPrMrZ
         GIJRc3KWZfcp9DyesliRsaHHb9XqDMIj2goBygOU0mmSpDkC2NI3wx3b0COLKoWPDU1P
         +VLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777998733; x=1778603533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q6yeaFiPlZGZf41NsmyX0In93MXNmdncNWDHYjC/idU=;
        b=Fy9FecIba7Hpjkupo+ELXKFRupLs1Rb196XqHjR5T556FhFIzntcr+HjBy2kzWIJ/d
         Y+XTiTTOqYvRN7VAJ2Tz0F0iC7khSTAeNDb78lwRaQpe2D8LnUqux4Zs2uvGCQsd/DJO
         C02Fl3FHk27/AeoYBeUWtbPOOI8w/Sb8K/vRKxaUEgjvTCqTnJds9Spkz4MeV55k/0jB
         uKOUkEev3U7Qp8NBngt/qtfsra+Aw1jVzK9x/ygEBLU0STdkarKlVt2fd6Qx0MDhlIgB
         ehA+w5H8/kTdqeiVyCW0mIi2TbopwGLeXmB5dCiCA8qId6wE73+zLErQLitocsxKfMMp
         p/nQ==
X-Forwarded-Encrypted: i=1; AFNElJ9DMboYN5ENrdsI4V+9j4pAy4Aijud0PBljjluTpLIrb+7cc8Q+un1mFVMdB8RTy5I1HImKKcElnw==@kvack.org
X-Gm-Message-State: AOJu0YySpEA2h6AIGao5QcUnomr/NTYbhoiYITcaPHs9vt0XeW/qeRvY
	3uAJZ/qgdUGBLDxYq/YPJRV4v4ufuXYXiWGrvefxOVC3Vz9g0U0liKk0NjRNumzK9YjFwL2tHVf
	M7Lnm6Lk=
X-Gm-Gg: AeBDieud4hI22BuLEZfMbXu3ZmljMO0T6GwrI2MB7ZDRCGovsCYezRY8tTiiqpm9sBj
	ur7DeTTsWD83a1TXnR/KBcnsO6vrDz3/P2E/krqlvAuAtRdemoKpsTyYqm7QQc9yCAehc2gm7Y7
	GDaIEiEEtJv8lCHT9uJbgb2IHLUJ6Hef34cy/OKnImyLiw1pIKD27s+H4Zp0sQ8LQcEXwGdyDcD
	d2+F+4jEFD1nXsL2ApwbrP5mpoz9lGwST6E+g4jt0ilt9qAHjXWV+1izcT67htvVuWoEpu4T+Tl
	6Tzf6WEUCO5VgeEgiMm4ZGJ74kzIelsXa+UGAG6LEyZKQpwNwc7RJHXkLAs3EkgkcXMSLvmSxMy
	BKUP/OVkg+f49OoZLIjLgsSp33Yy0WpUwktM2PsPP1r50CQie2YUhmONQfWwoW/NShfLlk3cCif
	z0ojV6fJfLeVgHnwKso/yzSxWUgqcP1Jp9ZiD1GcomFRmX3Yk/6mUPA9FPnzcy7A==
X-Received: by 2002:a05:622a:424a:b0:50f:b137:3099 with SMTP id d75a77b69052e-5104bf42473mr215787061cf.33.1777998733271;
        Tue, 05 May 2026 09:32:13 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51040b8174csm145009111cf.25.2026.05.05.09.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 09:32:12 -0700 (PDT)
Date: Tue, 5 May 2026 16:32:11 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/6] selftests/liveupdate: add memfd tests
Message-ID: <afoatCn99vvnr-cH@plex>
References: <20260404102452.4091740-1-pratyush@kernel.org>
 <afEKfQ0GUNVJ76a1@plex>
 <2vxzecjx52eu.fsf@kernel.org>
 <afT5FDAXmcIfz-wI@plex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afT5FDAXmcIfz-wI@plex>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 94CC3C0005
X-Stat-Signature: 5aqkhbxzed1x6ihr5qtoo994rjqm36w4
X-Rspam-User: 
X-HE-Tag: 1777998734-864392
X-HE-Meta: U2FsdGVkX1/yy6cNLGrAhIuWoocyT/ruRO35IjwPWw+ioNLCHJnXb0QdavXIClE3SZYM+GLniEijNoJi/rLTYIWYmQOwNz0nJ2Vw459l4HuarjJs/uhbFxh8YcVZIihZkg5GKsBvOduxnSrV7sItHiDWR1gRU7khsL8LsS3Vx5dx8Xp7wBNQozSgjp9wZJ5CIDqGc4B8duGq05Yz0NRWhOKCA3umD+t5sTWnYY5UWExQeZngH+8deGerGJ4DMl9qz3QBvf5dZts7nmQPgo3g7m+WlMdYM3zU9J1Hti5flYyVqUtp4l0HsVhFup0C0NhHtFH4wjadaz6TqrYInVH5LFpjuY0f1GN3cUGHfztOzRs+vavKxJ6E50nrylhmsDe0HXmf8vRRzSMT7pp6MG+UdfFIG+0zcDsAa0hpE4XcM/pOCYe9H3XU3OwCBRthRsXuUddyzV4zq/tCXHvxmdBw69LfwTDfs15RLo/mPwNd16AIViH7BaFqmQ8M0fOUyMcLEjuEW7hOYpEizbmJsF9c3q8NFOczaMN6+aASODUbYnDbSzd6uX+SclOpqlVAXfWsClRc1LH2pCttTVI1G2QHiREYLKD0E/XbC0sOqvlgIcVfd0vNNa4+49Xky/jeVOTEN+bJz1B13dT7o6KcOFrFzqTj5tYDGeQ20buvAtsuXKfL9JahYF/+EmPHu7rwvBOf24xnBVCAyj6P9MBRG/GTw6xGE6/hx3NeACsNHeaGC1pbkBHDfTbZPn3Gu419eOm/S7id9CYx6PRf/2MISZpHed1bqcClMAu9gonoAdZujdpiOLrPjwO9EUHjJY+X23uTerX2mVD0moPqo9mj9tznWYSDXD99jg8rtJ1zNSVPJkygGkeul0X++7ljFVSmuc2Gc2E9yBcXj96PPaXUx+0M8EPSgus7nDpQZ+QJPmWUOh97DKTvLRFqkWXKoa+9i7Um40g6hwkOcmi2p7rLEp+
 GRu8U4MR
 UCgSG2IXQkXfrGGGU21VPNvaexGcBA5ntGw/XLjNRjpkX9CW1MlAjbbAzQrVRDt2/XXKJRpoUcGXly1VqD7ybXyIMYsHO6H0vZfmjys/eucTx/fortMPvCGrFNaOk47dSr06u50+lUXORQWHnoYV0K1Xr24XKhHqQ3ih4Syfif+si3SyXunDqJ4W+GP7MhNNssSEDxghN58ZX+DFGHOTLpMb+KxrI/oUqAHnhqmGfolM2lPTHxo5GXG/5aaVrCCpavz97JtWbii0ESF/hkiBV6ho4RsbB3gDjX+9p5wWqekkIsQpCdiIvkoHZJQMWBHOAG7q/ZRB/IleH0l9SGlM+4pKn+FdGrNd6KxGvbXfFzSE/Fnq/JRVEoWPjSK1FJ2fcjcsYEq/d1V4Jlr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-01 19:08, Pasha Tatashin wrote:
> On 04-29 15:20, Pratyush Yadav wrote:
> > On Tue, Apr 28 2026, Pasha Tatashin wrote:
> > 
> > > On 04-04 10:24, Pratyush Yadav wrote:
> > >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> > >> 
> > >> Hi,
> > >> 
> > >> This series adds some tests for memfd preservation across a live update.
> > >> Currently memfd is only tested indirectly via luo_kexec_simple or
> > >> luo_multi_session. Add a dedicated test suite for it.
> > >> 
> > >> Patches 1 and 2 are preparatory, adding base framework and helpers, and
> > >> the other patches each add a test. Some of the code is taken from the
> > >> libluo patches [0] I sent a while ago.
> > >> 
> > >> [0] https://lore.kernel.org/linux-mm/20250723144649.1696299-33-pasha.tatashin@soleen.com/
> > >
> > > Here are few observations that I noticed when I tried to run your tests:
> > >
> > > 1. The '-h' tells you nothing about --stage argument:
> > >
> > > root@liveupdate-vm:~/liveupdate# ./luo_memfd -h
> > > Usage: ./luo_memfd [-h|-l|-d] [-t|-T|-v|-V|-f|-F|-r name]
> > > 	-h       print help
> > > 	-l       list all tests
> > > 	-d       enable debug prints
> > >
> > > 	-t name  include test
> > > 	-T name  exclude test
> > > 	-v name  include variant
> > > 	-V name  exclude variant
> > > 	-f name  include fixture
> > > 	-F name  exclude fixture
> > > 	-r name  run specified test
> > > 	...
> > 
> > Yeah, unfortunately that is a side effect of using test_harness_run(),
> > which does not know anything about the options specific to our test.
> > 
> > >
> > > 2. '-l' does not work after you run stage1, do you keep /dev/liveupdate 
> > > open? That is not needed, we only need to keep session open.
> > 
> > Oh yeah, I keep forgetting that is no longer needed. The main process
> > closes the FD but the forked daemons hold a reference. I can clean that
> > up via a fixture.
> > 
> > >
> > > root@liveupdate-vm:~/liveupdate# ./luo_memfd -l
> > > 1..0 # SKIP Failed to open /dev/liveupdate (Device or resource busy) device. Is LUO enabled?
> > >
> > > 3. Stage 1 has proper [STAGE 1] prefix, but no [STAGE 2] prefix for 
> > 
> > Because stage 2 has no prints, all the prints are coming from the
> > selftest harness. Those same lines are also not prefixed in stage 1. If
> > you'd like, I can add a print beforehand that shows which stage is
> 
> Yes, please, add a least one [STAGE 2] print.
> 
> > running. Other than that, I don't see what else we can do. I don't want
> > to modify the selftest harness.
> > 
> > > stage 2:
> > > # Starting 4 tests from 1 test cases.
> > > #  RUN           global.memfd_data ...
> > > # [STAGE 1] Forking persistent child to hold sessions...
> > > # [STAGE 1] Child PID: 245. Resources are pinned.
> > > # [STAGE 1] You may now perform kexec reboot.
> > > #            OK  global.memfd_data
> > > ok 1 global.memfd_data
> > > #  RUN           global.zero_memfd ...
> > > # [STAGE 1] Forking persistent child to hold sessions...
> > > # [STAGE 1] Child PID: 247. Resources are pinned.
> > > # [STAGE 1] You may now perform kexec reboot.
> > > #            OK  global.zero_memfd
> > > ok 2 global.zero_memfd
> > > #  RUN           global.preserved_ops ...
> > > #            OK  global.preserved_ops
> > > ok 3 global.preserved_ops
> > > #  RUN           global.fallocate_memfd ...
> > > # [STAGE 1] Forking persistent child to hold sessions...
> > > # [STAGE 1] Child PID: 250. Resources are pinned.
> > > # [STAGE 1] You may now perform kexec reboot.
> > > #            OK  global.fallocate_memfd
> > > ok 4 global.fallocate_memfd
> > > # PASSED: 4 / 4 tests passed.
> > > # Totals: pass:4 fail:0 xfail:0 xpass:0 skip:0 error:0
> > >
> > > ./do_kexec
> > >
> > > root@liveupdate-vm:~/liveupdate# ./luo_memfd
> > > TAP version 13
> > > 1..4
> > > # Starting 4 tests from 1 test cases.
> > > #  RUN           global.memfd_data ...
> > > #            OK  global.memfd_data
> > > ok 1 global.memfd_data
> > > #  RUN           global.zero_memfd ...
> > > #            OK  global.zero_memfd
> > > ok 2 global.zero_memfd
> > > #  RUN           global.preserved_ops ...
> > > #      SKIP      test only expected to run on stage 1
> > > #            OK  global.preserved_ops
> > > ok 3 global.preserved_ops # SKIP test only expected to run on stage 1
> > > #  RUN           global.fallocate_memfd ...
> > > #            OK  global.fallocate_memfd
> > > ok 4 global.fallocate_memfd
> > > # PASSED: 4 / 4 tests passed.
> > > # 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
> > > # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:1 error:0
> > >
> > > 4. I also do not like that we now have duplicated stage parsing code in  
> > > luo_test(), perhaps we should add our own  test_harness_run() variant 
> > > that depends on stage, and use it in both current tests, and the new 
> > > memfd tests.

One more comment:

root@liveupdate-vm:~/liveupdate# ./luo_memfd --stage 2
Bail out! Stage mismatch: expected 2, got 1
# Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0

Should be: excpected 1, got 2..


> > 
> > Sounds good in principle, but unfortunately ends up duplicating a lot of
> > logic in test_harness_run() that is not a good idea IMO. We should work
> > with the harness not fork off into our own.
> > 
> > I suppose we can refactor some of the logic there to split into
> > functions that we can then use in our luo_test_harness_run(), but
> > keeping the option parsing logic in sync is going to be difficult.
> > 
> > And for the duplicated logic, I agree. I thought about cleaning it up
> > but was feeling lazy... Well now that you have called it out let me see
> > what I can do.
> 
> The main point is that the luo_sessions and luo_memfds tests should use 
> a common framework, whether that's luo_test_harness_run() or the generic 
> test_harness_run(). I don't have a definitive answer for this, so I 
> recommend tinkering with it to see what works best.
> 
> Pasha
> 
> > 
> > [...]
> > 
> > -- 
> > Regards,
> > Pratyush Yadav

