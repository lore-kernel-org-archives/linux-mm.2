Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC81C5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 21:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A94196B07EA; Sat, 15 Aug 2026 17:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45546B07EB; Sat, 15 Aug 2026 17:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933146B07EC; Sat, 15 Aug 2026 17:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0B36B07EA
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 17:58:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C0EC120463
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 21:58:08 +0000 (UTC)
X-FDA: 85104867456.06.E1EC470
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9EBB5A0003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 21:58:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rWwkXbew;
	spf=pass (imf15.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786831086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zl3zbyHOUnx+7x+7DiqXwgLH8VDCbrevPogqZgNIfiA=;
	b=GNmCA3hNFjTdkWQPOdO8zVIomp1ym/PwyxcpIdsc9krcRghn0q5wqRdGQFvVPD3hKZpLmt
	rFAnrBaHeJHMsIGMykSbRbQ1gg6z8nBwUxvYcMWUUh4JUJZ9vbnM+XpRbrM4w3UUkZzv8T
	Rk2nqGk6mxOySS081d3BGEkCubSClcs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786831086;
	b=Q3VywG4VQLylIJbCXqcdBlDYcBpJjCC7UC0WIN4qObzfAzNAIvhaUWfKPHF64wfB1apgPV
	odNALYalZE06OjIKU2yZ3AbToomCF0k9Xa8K7RwnyMyWU1EUPlcKNY5qjw9JJbHSe8xHGy
	YJCB6G5t15CMzqKofkJn4W34lUyckeA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rWwkXbew;
	spf=pass (imf15.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38dcbade417so2257063a91.1
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786831085; x=1787435885; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Zl3zbyHOUnx+7x+7DiqXwgLH8VDCbrevPogqZgNIfiA=;
        b=rWwkXbew22ZnHDxAHiyrTFDJldlPYZyJkGEM6BB4GjlBbkFwFD+nlCep4Dlcig0dyV
         tXfxmeNmUGwZ1IdlIvvcQ5pKgzpdJB878hAi6AZgUOg9ugPK+d8dOP0iIdAoOFp7V4C3
         jpsfuOHoX9/kFOk6l4jtTzhsW2c4EuVP6+W1C1IjCSBRT39USOYpBQFb9GQmW9cCvK8a
         3ccflb6b1Pr/3FvR6PQsBe+0RjvUh9ecHPyZqjV3W8NZuhpUgchgVxGRpV/ou/2qn5Te
         WueqNFfLMwdASx+72DtjDOImNXdrtjusW/xgYlgVmunhRaWtOuwB8dqgZ3SuzMoXnmlI
         c4xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786831085; x=1787435885;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Zl3zbyHOUnx+7x+7DiqXwgLH8VDCbrevPogqZgNIfiA=;
        b=N2DVvUekoQj/IdXiO+KahsxvJ4cXbaEivIu49DXPwju2XiVk7p/ootSpMzLUOIEQM8
         cywSdnTc3U1NsUqACGRTH9MObpl1xEtuOKcst4nElsmiOm9lQPQnAeH8qrSUgNahE3gL
         j+7WIM0zX1moqFx/D8ukTNPAauMTuVc8UTaiXGhBdp7PoXL/k0rYuP6bWw85UwMGyhs9
         CG7hMQORZSpjMJMdWaqg/rsH4kdsiHeIgoCIIo8t1MeWcJaoRlar4c7DgK5WWqOXLznc
         AQXvBqSvN2nsijVtkvZk8evxlAcpgL2WUHDQEja3t39av6tD0vTxxkIJ2mzWixWVML9k
         qSDA==
X-Gm-Message-State: AOJu0YxakDXAbeX5mSVfwUCrCrXBU/6rOW3VGb+Ojm1gDHWRT/0I/6nF
	cnxcLolF3rOY+ebSDs/mLHXtNANe8aNfLfPh+Fl5hSZJJ2HZcfbcLPgk
X-Gm-Gg: AR+sD11TyOkhUicszNRKlYbGusDOz3EwfUdmqAeur6SxsRRv8Ar97S0wu1FnZRqIYRZ
	VdlmQDqlb0ILyq32p2tzjow4ARCybjRdTGbWPPUhPdK50M9x/mCUXS7hefQIt8FrWf1TInx+p3J
	ph9oRV/X4a6Hc6fyq80hWrZGEqYy/yAXjaGxu+JChgq8InTVHoNvSroKejUHyu6LAgXFTyIwdPJ
	IZRj2xtCNuKJCrt7FDMzbkTZMGDeVlAWMW+ZRb8470VYLibr0NAqZLHW5UCvVOEjmt0nSN3EcHD
	uoJq20L3towUl/IFHLkvjb1Wuz4pR3EB/jNeGT+f3bB3NeFDH9gPTs2H3qgu+VyW6yBr6fHnVlt
	tSqyYUHGW6YsqFetv6hAutqF1S+ClmAXwb4NxnW9pYxgkEuzFvungho9ssy+YvzaOMzHWggswPH
	ABEY5L9t4BwV/t9GOylASSnZxn9SOdwPU/LiYMcgp82abZqayarMDWpgbUIcp/p+lv8GapFetPx
	F4iVhisIPrH4JoZEnIhLRJsdC+kJoFm8ENzaVRsCKeL6iWSXkS1NixKkD3KVR3+tpydRgZ29stK
	n9+alA==
X-Received: by 2002:a17:90b:57cf:b0:390:8361:a532 with SMTP id 98e67ed59e1d1-3933b8072a0mr17420143a91.7.1786831085297;
        Sat, 15 Aug 2026 14:58:05 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394eb78f1a4sm7281618a91.17.2026.08.15.14.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 14:58:04 -0700 (PDT)
Date: Sun, 16 Aug 2026 06:58:01 +0900
Message-ID: <m2v79boxli.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: linux-mm@kvack.org,
	geert@linux-m68k.org,
	daniel@thingy.jp,
	shuah@kernel.org,
	kees@kernel.org,
	luto@amacapital.net,
	wad@chromium.org,
	broonie@kernel.org,
	jackmanb@google.com,
	liuhangbin@gmail.com,
	rbm@suse.com,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org
Subject: Re: [RFC PATCH 5/6] selftests: run tests on nommu architecture
In-Reply-To: <an8MlE22U3586R42@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
	<20260813063401.1786548-6-thehajime@gmail.com>
	<an8MlE22U3586R42@lucifer>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: yrmm11q3uug5158jj8778aa8t5i434fy
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9EBB5A0003
X-HE-Tag: 1786831086-711662
X-HE-Meta: U2FsdGVkX1/FLgxCGOYKFhT/ao9ikPEYubYOSq2XGgd9vLjjbNS0iJzeZDGDcFXiRaMLR/9jdbL0AkCRTM45i64sCaW4Cm4KogRvO52bT9RbOw5R2ct13YBDxoAd9gIymSnvW4jVvpJgxqmioOXJwiPdLkEl2xVyId8KCz9oRL+M/zDrhk6Bygp7ReYMika4Cotkzkux/Jq3UZK366gBgmroVYL4EdjGZ5XQi6QVb6BC2Mh3UOD2Qf+e2NJqs7gYfxv7InM26D8xc9mPSQAPdpr7GtsU23Vkhl9g/ocfuql07TsUUBH8ah3XqFK57pLWvxPSNrFyUf1KSx67ZRYWxFa17SpO8TWGdJ/atDiYNtMzF1GoXsdGI4EO+rT+AA7NRaLa8N15+Rjkd7ONNOGB81FHtkgyoRRMd7pXNfeWTXbG/PoqcI2UivnYfotHfGGxtBS4jm00wsfhF51kHUaHo3r7xbrHg8cGD3J7M4pC6Ur0ecDJ2sODNU2xT0IHQqv0iR7wGlgxPQP5YK8qmbxigWkXfst7u/6kRjA50mzHs4vfGOpvrzIgH3wwdnZCeNx5jUvnkQFk/HcUqIuHqdiKXHYy0rFalqDgkcr1F4MAzFigxw1lvtd0lK86aIme6EHVKFzVaIEsLmgno1YxpZoEF/pjcvxyeIxvnzt6AX7CvRzXradB53MPOdgzhCden+rKGEqdrZVA7yNFU8uFYcwz3oIfiRv0B8MvQxPzxyfc1RT0RZl7jBedRvOi0N80Ns/PqFDPsmE5aZ5XfMacBvztsGxG/8KaggdTkrTO+J+HVahahe3zCtAIz4oj59LOcT6ugwf5lt8ry+6HEq5ReifiVTDqIYFQSeFYs5o6h5VPUdR6qj8HwQpB4PjJrOCQSTZcXbxpqAqH1dk0RWPlrwIbx4pDs6aCVtAhx7cj+UjTMYtXDS1uJ2HJhIWRkTkCmc+yDbtPVBMtt+xmGcux+up
 6MCVgz1m
 BSGQhr7W0fEPqfq/k+zDx9T4NYeD8HreNFhFivFsXuAAUzw6uqm8uqJjKzCBHBiBDzR1zey0RW7XAQWawtYv2l7XECwULDOgfOiqJo4pErffbLBtGokfls8E16NGMHLObIBg1m/+ZZqZHisNvj9FL230p8fnmg6FsxFVr0Z6PEwGNh4h4XIaKfA7ySyNU2EdPyT/WsIQLLIHNaYvy9F0Om2Z/g0kaEynKzy4WOHeo16OBTXVUCNyt1LoYXJpJks29K/Atc1Pjpf6K+gxUhx+CO9kC1NgM2EoOUz9a6L3PInWk8Cuu23lGD66O8mVjncZNRrVKRcNBP0zwa/IUGXmJ4OwqcvLUhZxpkabIR2VM9+rPgOXyXalKV7nd6+jAiBoTAJKSW47l38FR16gdWEQslPMwAkj8UrJSCxb01K8WKBI2bry6kr7cRyQo5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 14 Aug 2026 21:50:50 +0900,
Lorenzo Stoakes (ARM) wrote:
> 
> Not really loving this as mentioned on the cover letter.
> 
> I'm sympathetic to making things work if it's not invasive, but now you've
> essentially asking new test authors be aware of this to some degree.

It is not intentional that new test authors should have to think about
NOMMU=1.  If there are no option specified it should be as what
the current kselftest is and it it's not, it's a design failure of mine.

> And making the harness - which is the defacto way of writing tests - now
> simply not work there is a bit crazy.
> 
> I'd ideally like to see _all_ tests use the harness.

I also think so but if NOMMU tests is implemented using the harness
test, this patchset would be invasive.  This one is very small patch
which tries to:

- add ability to run tests on nommu
- with minimum modifications and not breaking any existing usage of
  kselftest

which are, I guess, what you're suggesting.

> Also a bunch of the tests already do forking as part of the testing:
> 
> $ cd tools/testing/selftests/mm
> $ rg -l "fork\(" | wc -l
> 17
> 
> So at this point you're not really running much of the selftests at all,
> and are only happening to run those that don't do the very basic stuff
> nommu can't deal with.

the current situation is exactly what you described. `TARGETS=mm` is
able to only build with NOMMU=1, but onlyis runnable with nommu_*_test
(I need to specify `-t nommu_mmap_test -t nommu_mremap_test` to pass
tests from a run.

Now I'm thinking to create a different target (e.g., `TARGETS=mm/nommu`)
to make it more clear for this situation.

Existing tests even in selftests/mm should not involve these new tests
which has such limitation.

> I think an audit of existing tests to figure out what works with nommu vs
> what doesn't is really unreasonable again, given nobody tests or seemingly
> uses these arches.
> 
> So this patch might beget more nommu carve outs and exceptions and
> therefore nommu workload and maintenance, which isn't really sustainable.

I can understand but without tests we cannot easily detect regressions
in future.  Like when you applied broad changes into mm and try to
apply also to nommu.c, I believe these tests are also useful to verify
the extension, especially if the changes are not trivial.

# sorry, this might be too obvious for you..

> I know I complain about lack of testing on nommu, but at the same time I
> don't think running arbitrary tests that happen to work on it and who knows
> if they are valid asserts anyway really fixes things.

agree.
I think (current) nommu isn't ready to run arbitrary tests of mm.

> And given nobody really is doing testing, it's not really a great RoI
> here...

At least myself, for the moment, has an interest.

> ...OTOH I suppose it's a minimal change we can largely ignore as long as
> this doesn't lead to additional work/auditing from anybody but nommu
> enthusiasts.
> 
> But I'm just not sure that will be the case :(

again, this (not breaking existing model) is my intention so, this
should be the case, and if it's not it should be addressed in this
series.

> (I'm amazed we support a mode in linux that can't fork() in 2026 :)

I concur.

> > ---
> >  Documentation/dev-tools/kselftest.rst       | 12 ++++++++++++
> >  tools/testing/selftests/kselftest/runner.sh |  9 +++++++--
> >  tools/testing/selftests/kselftest_harness.h |  4 ++++
> >  tools/testing/selftests/lib.mk              |  8 ++++++++
> >  4 files changed, 31 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
> > index 64c0ec7428a2..800b2b688aff 100644
> > --- a/Documentation/dev-tools/kselftest.rst
> > +++ b/Documentation/dev-tools/kselftest.rst
> > @@ -230,6 +230,18 @@ section::
> >
> >  .. _tar's auto-compress: https://www.gnu.org/software/tar/manual/html_node/gzip.html#auto_002dcompress
> >
> > +Build and test on nommu target
> > +==============================
> > +
> > +If you (cross-)build kselftests for nommu targets, or run tests on nommu targets, use

-- Hajime

