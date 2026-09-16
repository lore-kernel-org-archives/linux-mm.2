Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A56DC982C3
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6416B0096; Wed, 16 Sep 2026 10:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59CB46B0098; Wed, 16 Sep 2026 10:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4906B0099; Wed, 16 Sep 2026 10:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 220346B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:42:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A79DD1C2DD9
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:42:43 +0000 (UTC)
X-FDA: 85219891806.27.2C24A9D
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf30.hostedemail.com (Postfix) with ESMTP id BD00480006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:42:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HjwEkvbq;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789569761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APS81j5DoNNcu6pzB1xIdVlOym6nIXIYbB0pf6pRDP4=;
	b=40jZ/h8ks+PUpWmX30WB6fUa/Nsa22k+9E1fs41uyIG3nQ2aLxItF54zWBMw9bwgiV1sYx
	MVfJU17lr0Raf9rZC9vZYVqQNba0D9YESuFS+ltKvm3U0T3MEfXojycgJW+fq09RdJMom5
	yonHCZINVUMa4ZfzCzd1TXkcXIRoygc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HjwEkvbq;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789569761;
	b=gaQlqwaw5B5GcsOTAEK/f1xEuUg0kzRHYfXers70t9IyLOlm5lTAum0/9O1ugvlY1kVV3u
	pnFft8CMoD25CJBzofz5/Q1ayD8BTIoOMjaBhcMu67O/6kCOXpS31yRxS9icV/Y2RkyX2a
	KfdDcTG5eKTSW3t5jDsfMBmrO2oThhg=
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-530e28a62abso12751211cf.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789569761; x=1790174561; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=APS81j5DoNNcu6pzB1xIdVlOym6nIXIYbB0pf6pRDP4=;
        b=HjwEkvbqGIqBnYXpHSZ8KKGrC7xUyPFO6qHoy5IsfCoAScYhmiGtzyd3iJMNilGhCm
         vLdXFw2IKGH1+e3ZhqE/+ReMOS6Frd6skIAsvjekdeNLbNZZ5phwAQqkODyJZyV7M8Ki
         Bes9TwnQrTxT4TbEfKlIZCn6QFm/PXiFFpxHcLhBJ1H/z3o3dD4p5xYTZk5NC9leMqkk
         uPbvuXo9Ug625Wc4av0ajcjj1G6Z96Lo3VmmCF3xOHfKb2LYuz54h/+6fiItNErUTbTK
         qjvapuQgswC/hHtRuc0nSx0vE7srqyzKxx32L+Xs7zR+a7L50QZUsYwQFAlmADeM1xeF
         VOQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789569761; x=1790174561;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=APS81j5DoNNcu6pzB1xIdVlOym6nIXIYbB0pf6pRDP4=;
        b=UFUPWxis3I6dJZI19O+/dKlq1NQe+dYnuC8BVJYQ/v8JJtMGogyyIEsgEVjOF8dHPY
         KkmaOSUJUVMr5B31hAhku8PDB40qBN9VV4zA53oIYmTOuXJgHB5kPJQ8Mm2hQmXDMyG/
         chD/v/vnKv3mUPtZJyWLOUTzAx5wO3jeGn49LyYJThhmD9jvkozz3xpx1BW47GcfQpnW
         FnNPKVsKuZUEEWmv8zZ/NlnqXHrC5/xcdwBCcmy+Lks3XHNaOk0f6Np+LgvluBb/FpuZ
         97lDXfQOGeg8h6XIsG1a5mDdOIf2cEnrybR0nxIt74cJlH+Lrc5LmxGYZebzknHFYclC
         ODtQ==
X-Gm-Message-State: AFuF++kwE/XjXzPtnG2RuoZS5nZ9s0SQMqlF3k7jssfv0Ws6G2j+EIht
	m8cRa6KPGhdYQoFV1Q7vMq6gb87Z9hnJ8Ok3jOYUZ+WjKvJ5hlzDOYL77Wcm4tUvxD0=
X-Gm-Gg: AYBFou1Cs1zXvZ+sjNZUgvfQmxf7BRY/7SE07wgggSW7Af/aumaw/CkrgeVmt+11KGn
	jOLazlvGWUya+9H8zTDBl84+KeF3Zks/F8Gbb+eCyRdtJ+fkstOPpWnmvafvMq7BZCY36mXrRm6
	duvj7Q7Z5+9HLIbkIGBxXwhRQNE4yF6nQ5vB0+aoAdSVx0HLSicySSqGNjdSKoqv8c/MWkFLSKM
	NW7Od5vqNwUesuxB5TfzoSNlrTKVkVLkqE1C4V7Yny5cFVaF4+tmIhwT463sjH9IV8nF7ap7Er+
	ckBRkPL0gAFKYQlFo2Ti765Z0O/Nacwz7QtNiBMkZQ72YXqVL9vEIszJTqsWT7JwfuYue55k5br
	Y87AYwW9I0m6vcIldbpBksN697LyWXcxqWulxsKav55Lor3ech0OVxk8HG6iXO8HozSTiNi4jBA
	nm7xQ1g/tOS5lm9OLhof9zQilCf2TKLVxPYXXGmlSP1w/koZJ2kLdTHTUUUbrTrehRLhQoStfaO
	iQ+3TxLTAK+eS/LfbuvSTOT5RZ3az3ckC8ewdMCBRREel0LkPzkt/Y=
X-Received: by 2002:a05:622a:1312:b0:530:b2e2:d7e2 with SMTP id d75a77b69052e-5327f24d070mr45834991cf.61.1789569760741;
        Wed, 16 Sep 2026 07:42:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5326208ea78sm25268101cf.24.2026.09.16.07.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 07:42:40 -0700 (PDT)
Date: Wed, 16 Sep 2026 10:42:38 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, wangjiexun@tinylab.org, sashiko-bot <sashiko-bot@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqqk89oTigJ9LS2N@gourry-fedora-PF4VCD3F>
References: <20260912110832.3203902-1-gourry@gourry.net>
 <aqloB0zm3RjJ47m1@gremlin>
 <aql65IhMobL5Al9B@gourry-fedora-PF4VCD3F>
 <aqqTbGMJL86TzDrf@gremlin>
 <aqqbB_nFAOGenDhy@gourry-fedora-PF4VCD3F>
 <aqqjW5dpyznijYLh@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqqjW5dpyznijYLh@gremlin>
X-Rspam-User: 
X-Stat-Signature: e9fxi4krianz6rcy18yxubr438rogscj
X-Rspamd-Queue-Id: BD00480006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789569761-675404
X-HE-Meta: U2FsdGVkX1+fb1dMmRGRyEqRfuWzuNlu/GpmQ06NI8CAXIzBB5PqeD90IPgprWMmQQTtCHL02Djeh2i8Mxwima3iH49E2r7wKfe/vsb0nC3d6ljJVn1a1d5wu+a+PyaxSeTh6fQ9ebVk23db7KUm97DlS9gWQrlJ+82UYEvEnmmduxuCMZOa70XCyfPshQDsNhrwvkvcFqKjqH4NSsezYimq9pVvYUEYm9wAOp+Yho3NYu3dNi7SgQlx8WURQLtGzr0TpnDiuVqUYKSgXCaxQM505fNEknmWf63dxJ9jY6taGUotBKfpIA9bEaWUqkK1GTCiRB8xhbr/xfkCUZsvs1xtDzyE9IEe1DwDIiMoVkDVgmSQ04SVaXUM4113Q9t0YIJrTM1Eev6CXscYOLDRv0zZbfXStMvJysfKpi4PA+KGlFzlWjaTY6/TVkivGNnVM+Ck+/1bLs83UHeX9tHtcJQuERE2nCsEDXrLP8Z7YV9gCC1GA+oEKOrO9ls/JhqJgMzwJGY5aa7PeuOLaax+XpF3PfuILzO5Dk3GuCKGcfWCz9/H4J1cSqZ1WPqJdBOP70XYjcJIuYoT5AqFDmNpSASqLBee8LVk1WWhiLyfYyb86HsUwBpU8m0jrDJUap7soD4ALYpSFW2xG3EufVNXNspjutHNWuHVqhnKihUptz+lmL5d/yLujKoDgcIpfCD+3npbv/+OOvNLirana2v++fwW0/IpKhbFx65CQeSmRVAfR/kM0iOhXgseinRW0jGF+ZfL49nqjJNesitIZ68nNEvLPxKL0V6ONadNnrzIv7PmJnIwfQKmhsiK4RNM1HJPc/Mv7ppCXH8i6+8CfQSPx6LHuQrxFHgD9uxjYaBG1NZ6EFgchZyegQJH+/RY2orfAkY7B3laNmivmyovoh7bfzahDrftO1ULE1TD1v3HIi5LQmXckJZKwswYgLYY3o+VEtfbSf4cGjnB5QftDST
 iY2medYS
 iKYl5FMnsT/dfoW7K6DVaBbWQvjyh+mCvWXnvdKyCPlhYWC0/xgNBvI2dBpXB4LXPUD5BDXlDHxORWOUVtUhVNit9etImOAUskAEDqQxiUhhYmy9zioF2wczzAaY8IXg/pcpsB4n9uwq+XTBkyJVL691BoWXGfw1/Y8VGLVj+06ymPQczbF9y4XLlbcQuWbPGrXiLVtVhk5V/xh5DcDk/WvSbsBcsjmGsgo7h7bh4me3QSQeApkJjJxqO3gfTR0TSl+Pk6pkoL6wjsV3UfFO1l/dQKw6xhq+Ko+ArmVj4tAXmQzBguhmongrwDSYkqsZWn/CQSuVaZq4SHp3L5j7UciqovROnTcd2IK8R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 03:12:53PM +0100, Lorenzo Stoakes (ARM) wrote:
> >
> > Going to spend a little more time testing and tweaking before I post it.
> >
> > I've been working on a making more extensive unit tests for certain
> > parts of mm/ and this might be a good time to look at whether I can
> > introduce a piece of it.
> 
> Nice, curious as to how?
> 
> Have you tried the userland VMA tests btw? Not tooting my own horn so to
> speak :P but it's nice, though it comes at a bit of a cost in how the files
> have to be set up...
> 

Yes, in fact I used that as a start for exploring how I might make other
components testable the same way.

"Stubs... stubs everywhere"

There's basically 4 testing mechanisms i explored:

1) selftest
2) Usermode Linux (UML)
3) Userland stuff like VMA
4) Linux Test Project (for syscall and ABI testing)

selftests are really limited and actually create a maintenance burden,
they're not real unit tests and are highly dependent on the actual
machine configuration which is super annoying.

But, lets take the page allocator as an example.

The only piece of the page allocator that "should" (cough, simplifying
here a bit) be machine specific is zone and node configurations... but
I'm not convinced that this should require a full VM to unit-test.

(other caveat: obviously some things like RCU and interrupt contexts are
hard in userland, putting that aside for now).

We should be able to stub out the reclaim calls and at least demonstrate
basic correctness for a combinatrix of commands into the page allocator.

Anyway...

I've been looking at how to use the VMA and UML test infrastructure to
stub out even more of mm/ and generate these kinds of basic contract
tests.  So far I've found bugs in a few random corners, but nothing
critical or reachable as far as i can tell - so that's nice.

Have made it compilable with ASAN and Coverage

The harness itself turns into a decent fuzzer as well for basic stupid
logic conditions, which in turn allows coverage and LLM guided fuzzing
into an easier task for any random kernel dev to start engaging in.

> I always feel like I should do more with it but don't have the time
> atm. May set the LLM on it though...
> 

I will keep quoting myself.

"The thing LLMs do is make the pipe dream of test-driven-development
 actually feasible."

:]

~Gregory

---


some stats from my infrastructure:

  How much of mm/ is testable

  24 of 130 files (excluding DAMON) — 30,108 of 187,486 lines, 16.1%.

  ┌─────────────────────────────────────────────┬───────┬
  │                  Compiled                   │ lines │
  ├─────────────────────────────────────────────┼───────┼
  │ page_alloc.c                                │ 8,050 │
  ├─────────────────────────────────────────────┼───────┼
  │ mempolicy.c                                 │ 3,923 │
  ├─────────────────────────────────────────────┼───────┼
  │ vma.c                                       │ 3,429 │
  ├─────────────────────────────────────────────┼───────┼
  │ memblock.c                                  │ 2,911 │
  ├─────────────────────────────────────────────┼───────┼
  │ util.c                                      │ 1,317 │
  ├─────────────────────────────────────────────┼───────┼
  │ memory-tiers.c                              │ 1,215 │
  ├─────────────────────────────────────────────┼───────┼
  │ cma.c, pagewalk.c, pgtable_move.c, +15 more │ 9,263 │
  └─────────────────────────────────────────────┴───────┴

  ┬─────────────────────────────────────────────────────┬───────┐
  │               Not compiled (largest)                │ lines │
  ┼─────────────────────────────────────────────────────┼───────┤
  │ slub.c                                              │ 9,933 │
  ┼─────────────────────────────────────────────────────┼───────┤
  │ vmscan.c                                            │ 8,163 │
  ┼─────────────────────────────────────────────────────┼───────┤
  │ memory.c                                            │ 7,603 │
  ┼─────────────────────────────────────────────────────┼───────┤
  │ hugetlb.c                                           │ 7,320 │
  ┼─────────────────────────────────────────────────────┼───────┤
  │ memcontrol.c                                        │ 6,756 │
  ┼─────────────────────────────────────────────────────┼───────┤
  │ shmem.c                                             │ 6,019 │
  ┼─────────────────────────────────────────────────────┼───────┤
  │ vmalloc.c, huge_memory.c, filemap.c, ksm.c, gup.c … │       │
  ┴─────────────────────────────────────────────────────┴───────┘
  The uncompiled chunk all need real folios, which is a problem that
  I haven't tackled yet.

  Coverage of what is compiled

  ┌──────────────────┬───────────────────┐
  │       File       │   Line coverage   │
  ├──────────────────┼───────────────────┤
  │ page_counter.c   │ 100.0% (119/119)  │
  ├──────────────────┼───────────────────┤
  │ numa_memblks.c   │ 99.5% (221/222)   │
  ├──────────────────┼───────────────────┤
  │ execmem.c        │ 94.4% (271/287)   │
  ├──────────────────┼───────────────────┤
  │ page_poison.c    │ 86.5% (32/37)     │
  ├──────────────────┼───────────────────┤
  │ numa_emulation.c │ 82.2% (199/242)   │
  ├──────────────────┼───────────────────┤
  │ page_alloc.c     │ 79.6% (1873/2353) │
  ├──────────────────┼───────────────────┤
  │ mempool.c        │ 67.0% (179/267)   │
  ├──────────────────┼───────────────────┤
  │ page_isolation.c │ 60.8% (118/194)   │
  ├──────────────────┼───────────────────┤
  │ memremap.c       │ 58.5% (137/234)   │
  ├──────────────────┼───────────────────┤
  │ mempolicy.c      │ 54.1% (735/1359)  │
  ├──────────────────┼───────────────────┤
  │ mmzone.c         │ 52.8% (19/36)     │
  ├──────────────────┼───────────────────┤
  │ shrinker.c       │ 51.6% (174/337)   │
  ├──────────────────┼───────────────────┤
  │ cma.c            │ 44.6% (206/462)   │
  └──────────────────┴───────────────────┘

  Aggregate: 4,283 / 6,149 executable lines = 69.7%.

