Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75BC9C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847C76B0323; Fri, 14 Aug 2026 19:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0E96B0327; Fri, 14 Aug 2026 19:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699A46B0329; Fri, 14 Aug 2026 19:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F32BF6B0323
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:04:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F233160259
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:28:00 +0000 (UTC)
X-FDA: 85101313920.23.D103C7B
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6E0011C000B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:27:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TAZKS1sR;
	spf=pass (imf18.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786746478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5F8hx8BNNcjIfpdTa1eWCMaUXOLCo/Fmk4XctWVfcM=;
	b=q7YumaFBb2RNEolj9eBkL2HFIo6NixxLDIvaQFqpJyhYBOfD+/55bubk4xQGrqDslci+8B
	NQ/1JRmJIcnJtYw7sR8N87u5/bHTRJLAoDGy2ecoSRjoUEKaFNrI8t5GTjJPAm+vBR6Blq
	dm1V1HDtwGoePe6oZCi2BcV3TyUIKns=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TAZKS1sR;
	spf=pass (imf18.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786746478;
	b=q4tWUCYuqIDmtcyrRhfhEUGTj3xSQROGlNGKvqCucHl8nhup4CfpbUesor1uMI3cJHFd68
	vrxxWkbLb3hf35xx4ylvjWzd4FpVXnEeKJmCBuuR96Hrq41FRsKPbHxknq7rei98kaUaLq
	P/huUEvNEyRweauvnYkDqoETuZfuSfA=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso2306342a91.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786746477; x=1787351277; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=m5F8hx8BNNcjIfpdTa1eWCMaUXOLCo/Fmk4XctWVfcM=;
        b=TAZKS1sR8GtflDkBfEuRy1WOvtsGbp8M6hW8WCuwSyzT3bfGtkjMskL5vI8rG28stp
         N4Q4wPju5qwK8FDw4luGUgS3apQxAfxr58b+DHkqSuZKR1hIc9t3PDCn63VjVMpdEdZl
         sRkiaIzkKfJX3OM8VaocBxKexdS6ysF5yS8+yd4qor9AeSnRo5zJ8iixvMHWmNdPeSGn
         uSAAStANB3Yt8hhdLDDX2Z/Iwr9G092P8epUwfvcj8WLs8DzlfiUKpnPiKmVbO5rZKwe
         6wLcz1I87WXutkjdTREv3uj3aP9kg0eATI9CpR9TrHc1a6w5MuE5L8iFgTc+76AoIiCW
         ts1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786746477; x=1787351277;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m5F8hx8BNNcjIfpdTa1eWCMaUXOLCo/Fmk4XctWVfcM=;
        b=Wbt8ZRo1vtpgOauN2bcR92Jo4KGk1+Lxs9Tg/qUO9cSHoWP20vsiMEvkDZ6QW9DAhH
         gc60HHp6OFONM2A8lck6BD0KI0vzFuEfHwIA/V0817PxeOZxo5o/sy1epGfO3Np4Gvv7
         rzQwynx1M9STXNpis/lOI7m57QRg5bRnXfxyaaSkARbimFKmgG9TPGaTM361RUDGgvbl
         eRfJCBBsDhyJRtyTYbUMNXXtUZ486je2PWcNxATX8yO/NvfNKqfQAUC5cF8H+080CfKW
         aQIFnTC328xvc5hAou2oA7vm9MttukWhSiocJEzK1Nyk52Ybx2JqTeVfCe1KU6onB9fG
         TCrQ==
X-Gm-Message-State: AOJu0YwP2DxyaKX6gbCCjGIao/RrhtV2+RV4q+vZ7Tf5jZmd0C42e+/2
	6lKqlTaOczpjrGLTUMQMTmNEEkmaP1UGXs48QlpA6Bvbu//obHwLXd/q
X-Gm-Gg: AR+sD10Pq4k5wRxDBk3omfTMUiDrMBgPCeWQYqLRbsXP224j0MWAvUqgDvY/ARAZH6r
	BdvpHc0Hzk4hJQ1TEn5S1Z5Q9iX4w5IX3r8+rw54JvH2KScyXI0CzV47qg5rUvng0xVvrM8ksgF
	11I89b+JeZqIWkQo2syp2j5bx3r6a9p3+elkgVeysHYTni8/WOZXIkMHBW0mk1FisXLC6ZpKkiH
	fGqpjzKcEODm8+1tHDRiWBPh9bWL5tDl/yNnFCNo9HPRPO1X53ydb0TWCQzGX+LbjfNSfLZoRx4
	HbR6bzwaDL1XItMRVsY79kr12dnaeLaRrg7vPOhKdgc/CX0frTTXjN0p0R696b2u4OxKb+V2bf8
	lKSNZWdIHDVZZUR8T6/RuQaqor4calcvD2WNspGaOOcRaNV3u/vZL/cahGdi0g0ZTCqfa5AXVqP
	fpdo2IVx093QCRA7/3PJWsZv9wfhtJh2MIDBMtiuSEkqjVP9ToDrbYxqWVSLXV3fEezTXcjrMmA
	qaEOrOPnQs/A+cIRhE00CnDagsR5juat0wTeB1S2IiVfETdLTopSKKrW3Czi3O0Utx18Ercz+s/
	yDhPrA==
X-Received: by 2002:a17:90b:3910:b0:38d:f096:a1dc with SMTP id 98e67ed59e1d1-3933b872257mr10264699a91.11.1786746477141;
        Fri, 14 Aug 2026 15:27:57 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ea996575sm4209040a91.8.2026.08.14.15.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 15:27:55 -0700 (PDT)
Date: Sat, 15 Aug 2026 07:27:52 +0900
Message-ID: <m233wgqqvr.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: linux-mm@kvack.org,
	geert@linux-m68k.org,
	daniel@thingy.jp
Subject: Re: [RFC PATCH 0/6] fix nommu mmap and add nommu kselftests
In-Reply-To: <an74JAGcEuHXxr5G@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
	<an74JAGcEuHXxr5G@lucifer>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6E0011C000B
X-Stat-Signature: a3hi1np7wpf7zwtze86ejmi4bpdu769x
X-Rspam-User: 
X-HE-Tag: 1786746478-544199
X-HE-Meta: U2FsdGVkX1/WK7H1qskRfVBbr+HYSCy+4aIrxleJFMjl+AY0KBH9+MNZ/BkTIAhC+z2GdC/S3YsYApUnDJaTGh9lXzPqY0EpoValehifEjarmz0Nb7FFMr3q49HOKfZ1WKQbGRa5TC2C+KPHj52gJS4nwcX63PKTotbSlmbaBCZbJSpFYcF07Z4s3oU+pWqZ75311/BgiHwUfPb/oNKVDxscWNuZ6EXGvpPRsb9vAmfWL6a6XdEPLvx55sv3LqfVHmPXGZGSC2DriGp+RNxSHfmt0qQPcpYWe9xGNROHE8UIB4DBrrCewPusfzemJ3wzZExl70NuwXZ8MAG9AdxVrZgSSlq2GrWtdKET+d3selrq3VS5OBNtFen//qQw6VY1rv73SBqA+E3wbxOusdsQAtqt/qYVCEg2IpyxiTHh+cFonD7r6bzYqiI/R0fJuryRlqj+i3hQEjgTJpkPTwWjZm37lF8rRxm6Q2+BEwzxCWTm6OevlcRGgaFJU4YLm4akhnzsD3gT27NBmom0fi+RFT10Ho9b5aAshPJmHVTSAJb759iTRyqKrxoTRK+8QshKyOWs+HWHzyChzpGChdhh0VpUYYTFFq+5EdJOGeAKRB7hlyxnPowqGK/F16unr3bKkQuJxF9a6LLT8yS23IR1586VeFMsVF/cIgvXWtsCIVv3YTAlaYOPlSsaAn3ZkEsTQmmt03mjWLJ4iwYo9POGGZtfX6RKVhF+QSNuqYA+lmIxV+rtRkps0xuNXu+cJSP+h7F6SQa7re2NJGd2s6YITAxSeFkG6bIow5B85wkyJ6ilAGJdJ/WYicKc39dzxnELxhegw7MiDBNQabL0IC722xU6v/yCfW1iVUNfj4VbUuNBnzeiFtNmGpXyrzI1T0OWKZGgIHpLTp5B+s/FvFMpwGEw/e4MfO7HxgbTflO9RqhO44/4JzPHYcCqeCZ3lGWU1dSrLBKMrSfY869TjEG
 oThWWPtN
 RPgKIIxGhVQhIFcNfqD98tXP5LcIPvcxS8nvncH4iqpxRjjO5l0PhCNBNW61t6N3cPm51mfIL/+8Fqz2xgn5o76apdasmopB229gL4Oy+H73kWqxBPLXK1E0FeAYKveE4pzdcvdAjqq7lBCanrBVvd2LrK6V3RCSSEQwOTKoleqPs6uiZi4g2U/fLgl2JCUdI3z1bZFpEh5uIGQzfcD8zHgCMTFZK/6UR7IVpW0nEooB6mQIv0TlJKkth6ZBt897NtXKJpC7b3zVrEMUShNBuDdeOrGmtl62gpftpDc262TuTl4+EupdcCerdB5QrWaMeHy1nl3roXtM1PMwWdP0F3g0rQyY76i79kop8TmXgtl82U8ofMArxeYt1naWr8ovEjT8CgbGjya63ef+fvv0zx0+cmC6l8qqkW37PfDm6GPneVqjw1Lk8HSRisqYZx7dFapm4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello,

thank you for your time looking at this series.

On Fri, 14 Aug 2026 20:24:57 +0900,
Lorenzo Stoakes (ARM) wrote:
> 
> Note on procedure - please do just cc- everybody on everything. It's a
> total pain to pull down series

I understand, I'll do this way for future patches.

> On Thu, Aug 13, 2026 at 03:33:55PM +0900, Hajime Tazaki wrote:
> > This patchset fixes several issues on nommu mmap, munmap, and mremap
> > syscalls and add test cases on kselftests framework, which currently not
> > runnable on nommu platform.
> >
> > Fixes for nommu is to correctly handle error cases when vma shrink
> > happens, and add calling .mmap_prepare callback on private mapping
> > requests to fix the issue which we cannot MAP_PRIVATE /dev/zero file.
> >
> > One thing that I'd like to broadly ask you (thus this marks as RFC) is:
> > this fix contains a dirty check of /dev/zero using device type number.
> > Since mmap_zero_prepare() should be called before actual mapping, but
> > some of the .mmap_prepare handler should be called _after_
> > determine_vm_flags() as the .mmap_prepare handler checks the shared
> > flags, we cannot use vma_is_anonymous() in determine_vm_flags() to
> > check the file is /dev/zero or not.  So we introduced
> > is_file_anonymous() for that purpose, which I'd like to ask your inputs.
> 
> Yeah I have plans for /dev/zero which will make it truly anon soon enough
> :)
> 
> And I definitely do not want a predicate that tests for just this edge
> case.

It's good to know your /dev/zero plan, and yes, I would wait for it
before moving forward with this dirty approach.

> > And we add test cases to introduce kselftest for nommu platforms.
> >
> > Currently there are several issues if we wish to run kselftests on nommu
> > targets:
> >
> > - it cannot compile/build test binaries because the current files mainly
> >   assume to build with glibc,
> > - some of the tests are not able to run on nommu targets as there are no
> >   fork(2) syscall.
> 
> Let's fix things only where it's not too invasive.
> 
> >
> > The first issue can be avoided if we can build static PIE binaries (if
> > targets support it), but in our case (build on ubuntu/glibc and run on
> > alpine/musl-libc), it fails to invoke due to lack of the GNU ifunc
> > mechanism.  Thus, we need to cross-compile with musl toolchain, which
> > needs to be solved the first issue.
> >
> > The second issue can be simply avoided, at a glance, by globally
> > replacing the symbol `fork` with `vfork`, which is available on nommu
> > targets.  Especially the test harness helper (kselftest_harness.h) uses
> > fork(2).  But the issue is not simple: for instance, in vfork(2) case
> 
> No please don't do this, nommu is the odd one out and the tests should be
> targeted at the normal case.
> 
> vfork() has entirely different semantics than fork() and we need to assert
> fork() behaviour, not vfork() behaviour.
> 
> (Honestly it's completely bizarre that we support a version of linux that
> can't fork() in 2026)

I understand your concern on fork-less kernel.

I am aware of some of experimental work which try to introduce fork(2)
(or alike) features into nommu (or alike) kernels (links below).  some
of them require a CPU features, some of them gave up CoW, etc.  I
haven't really look into details but if these effort contain a
meaningful insight to implement in Linux mainline, I would spend more
time to study these in order to fill the current gaps between current
MMU and !MMU.

# of course this might be a surgery and should be in a long-term
  milestone, not coming very soon.

https://github.com/flexcap-project/ufork
https://sigops.org/s/conferences/hotos/2025/slides/slides414.pdf

> > parent process has to wait until children has done jobs, parent and
> > children share the memory and children may corrupt parent memory which
> > is never happened with fork(2) syscall.  `timeout` command used in
> > `runner.sh` never works for nommu platform as it uses fork(2).
> 
> Yup again this speaks to the surreal craziness of linux supporting nommu at
> all :)

ditto.

> >
> > Additionally, the lack of test cases for nommu environment will (or
> > already) become serious issues to maintain the codebase in the future.
> 
> But this has to be weighed against the maintenance headache of supporting
> nommu stuff.
> 
> It's not right for it to force everybody writing tests to have to think
> about it.

My design goal, for this nommu support on kselftest, is not like this;
preserve the way the current users (of kselftest) do, and everybody
doesn't have to care about the particular nommu case.

So if this series breaks this intention, it's a fail and I should fix
it to not affecting existing models.

> And already in the thread there's been discussion about a serious bug in
> 5.10 that nobody reported for _years_.
> 
> So testing stuff sure - but right now people (apart from you of course!)
> aren't even doing boot testing against mainline AFAICT, let alone running
> self-tests.
> 
> So I want the minimal changes that are not invasive and limited to nommu
> only as much as possible, please.

I understand.

For the next step, I would break up this series into at least 3
different series:

- split_vma fixes (may break into several patches)
- kselftest extension for nommu (also several patches)
- /dev/zero fix (will wait for your updates)

thanks again,

-- Hajime

