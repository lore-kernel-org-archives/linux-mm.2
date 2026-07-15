Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F00AFC4450E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA366B00B1; Wed, 15 Jul 2026 10:42:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B29D6B00B2; Wed, 15 Jul 2026 10:42:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753426B00B3; Wed, 15 Jul 2026 10:42:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48CFB6B00B1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:42:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C584AA00D5
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:42:54 +0000 (UTC)
X-FDA: 84991277868.04.49A156A
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id EC36E14000E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:42:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eknkcREH;
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784126572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YFdvFy4JZmcJMIT1d11E7kO8Wgq6KQpSjvMclrKV/Fk=;
	b=4HbcYP6rBhBTwQ0dodKa4J5+Gs855kN/pFFkgoLtB0/4IrFGcPnk0UzQczOFceflgDpoLu
	AdeIkDFfxl1+0aHtyBWNJqjwkLpxhq2Z13DodFyi+AMKkOcH9fbwMMFBtqaEu8rd4FLNbt
	qptgsIQPjtX/jvbBu8JOh7dO7Il8IFs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eknkcREH;
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784126572;
	b=8VBFQn2KsnYdDF/4/7BTOVQzk7jQI8GHXlRDjgQfCCNzfRwjkvZIfUDirTeIxRF5Q5GgTo
	IzZ1XbL/VHlyUVdrQIjOM2UdEG4c4VHeH4iTXS+Eznh2pfq+voIZHDn3pyBPgw5SCVnD0V
	ocKE11CWvgSpkgH4SeFsoPaBBggcqxM=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38759bcd877so4834951a91.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 07:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784126572; x=1784731372; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YFdvFy4JZmcJMIT1d11E7kO8Wgq6KQpSjvMclrKV/Fk=;
        b=eknkcREHaAbjd5s8cVzFX25TL4a5GUq2SLKtiSMhLjAeVdAEaGAlaXudBg+jLlBZxI
         6+LWTk+DvDpqNERkg4SXheJOlpbYe1SaC4SGu//GZpDpBcbDacHM0gHEP/oCvFn/oRyK
         uMMjghx1emUnxu8IOLXlhhtlgSfX6s3JBO1xjLxctqcYjN6XKr+Wk7yvnjz7HbqwJRVC
         gTyjhtwOGTJx8rtOLczsJFX8BtE22rg5oHWc5tR4TL8EHm2zZmpypxKeV00aVT3b8HNo
         TSoLZfdZN2GjbsszsN0fwBhUZR8JcEASxIoGJqnhI/usikiJmZwYB535OPMTYivLO3uE
         in/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784126572; x=1784731372;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YFdvFy4JZmcJMIT1d11E7kO8Wgq6KQpSjvMclrKV/Fk=;
        b=fpmVX/DtQhV/w8o1b6cgWLqamm/fFw3wORsaXlNEBGZ6Trt/KgA6e9JwtbiIQSpW43
         d3SqX8PT341EhhgePLls4fpNoOoTKc1d7FYJhp5nKkdJQOzZIxkJaquHDCjb5EBUs5lR
         kX4hCarqGz4/6pUmGEy7ZhIYo4mrhYiFZxxVTKBK3OsZVD+PROT8ryDB0uyDRiTD/Et3
         3cV5tLUzHkIcVrJ3o7MLmLSUBjaLJ/UpPuMlHK9PFfrX//YRfbmySDwryqoxMkr6lVlG
         oPG3Q3xjHo7RAFfv84R3bk2vrb5+bkLbKCdUlKdtN9Y9CCW1omM+qZ96+N5HLQ5vEiWB
         tBiQ==
X-Forwarded-Encrypted: i=1; AHgh+RoLj9p1cMj9ecpJxmFSI83xR/IV+120sPHSkKuugOgMlEuzILF/mjqCPEt0bot32xz9sTdegIii+w==@kvack.org
X-Gm-Message-State: AOJu0YzmbXLVDv6WgdTuI8gPIHUP4qZIcta95qxO7/3KWb62cffz9RYh
	PNegRzmZmruQGuLStscTdA4amxELmTld8XOrfJoSVFFOo8G/TQRk8U0G
X-Gm-Gg: AfdE7ckeBia9EDRMjmoaRGe9q+Aw36DT3ivNZnDL3w1FpaiNgX+ePWOTUTgMEEvteZ0
	JT/5JnUNEdibXXmvxOsO5yyh9pptC6HAryn/qhDVVUIAszpqHnAszOwP9fgsyX6fo50vw+VHq7Y
	3UdLlslT7uLJo8lOQ+wqVZD4bONdcYdhAzOdrs+LVAe4/ZgOfCdMgq8OZFaRuitag+8D+k+4Xvj
	clAmxsBjTlJDbkn8NpLG01E7Wt0jPQIUDIwKDHPz9pa03IDUjfThdPeacSr8D68vK4TqTL5Gi2u
	OP7tNMfcyBj0jEp6iXISbQvugWH3TVwOmrV9eCztQVH9F9kK0KZfhmfmzpLUraKNQjPZ9u1JqGx
	RLHcvEcwZwqm9wi24DR29B/rUe8ZUtMZM5IL+CdluCQs2VpnS1ieNH4P/KjvlelyUC4JN7yjegC
	iqrO6Ik0jSFOpLajY6mfVOK9jT6R9/PDDpe2G7lppHuXRaRBPxSg3szN8=
X-Received: by 2002:a17:90b:2890:b0:37d:f983:7b5 with SMTP id 98e67ed59e1d1-38e29ff97b1mr2563808a91.9.1784126571549;
        Wed, 15 Jul 2026 07:42:51 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e172b6da2sm3320825a91.4.2026.07.15.07.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 07:42:51 -0700 (PDT)
Date: Wed, 15 Jul 2026 07:42:48 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, jgg@ziepe.ca, kees@kernel.org,
	leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com,
	ljs@kernel.org, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm/hmm: Clarify notifier retry state and scope
 HMM timeouts
Message-ID: <alecaJ1FUso39D9k@skinsburskii>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
 <4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
X-Stat-Signature: mhwpei7igwgtfbsgq34mkketk3ox5o5i
X-Rspamd-Queue-Id: EC36E14000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784126572-898805
X-HE-Meta: U2FsdGVkX19CcUilHK2hHh9syfZDVC37wi078q4sgstZQCjTAmXrD2PD61DlJzbTmKFdez22MCDp89LcXvAc+nZ6TFoB+C6DX4gwKUaixjV8np6tWBCcIhNSmBS7rXJr7LwlbIou2qf/gSonStTY1otKia4YUYvi4n8WYdH7ZyU4kIJ19rgj7tc0StU/QuPMCxGOa0rxE4bZnLiwVDHZx/nabM5/4VigEMaPl+RpG26BET4wZddWuhGcBT0Fp8bj0fONx2qvXVT7qIbpUxSX3IcLIOFb8SJJZj/KG0evJh9MkfGJ4hFwvc1xkhqGYzqUTPnOmV21ttiSOz4fuFY0pxIz2G3dT9WF7rrZHSn+TzYQGgTcTG3fJoNoLKubMMkqKp1OPSeEyRhk/mAtYeBtp5geKO/Beihb0zBGvGvYUvmInZYqbdMn1McOG176UVlXaKDdRvLvNmC36lYf83sZ5E+rB/gKFcG9EiAymC6SvpvC+0NZK/8TeReufcW5rqDQ3T0G5E58VgyK0QkerhV2+yqhJYeArB2v2gkR5Wfj/K2DOgMvXZIriJk2I/89uc4itNP+VViV5suKqLH5xF1zgkDqlgzTRMXJCMgA1JUTk2NtuzOAtVclVGZXOn3IwDAdBAGmwQJGKRMD0iM23aqyIUJrp1M4BIprTGUee5UWlgBJ3/gaK52WuL6zaaHAjTScJ2lhnbeGmNGoA6LzdsAfZPXbUBjbbCF1y2ACblRHIqVa2oZfhyCXM+6zuBzWV/AjIpY1llPnTBRWkKm1xiAWzXOa2Bl9Cro9yV8StGuYFUb7R+UloLhvVqjelAjCdyzLJcNB0lM9AtojDObRk4+8frbskw70RxLG5QZbT2GC/lcWgCkGmoBX0zPucwdTu4fDMymqRxIQ6hXKof9d7zRiR6SLFG9Ba8u91kwWUeCkexwUESJbfSRJv58x05g9Ub1I76HjC2mUnEvWhjql6+n
 vIEf9Ji6
 AUpdMEAIV37+ju40HzT9XF7hAL9j0xxaja7oORoE9R50bzLx/fPVNWUHaRlsEDvkK7qMTmV6sMhmEFt8jJBp5rRr7L/feT7+sQqJUen5TfRXJvM1nWU7MPc570W+IDBmwy++uQiyeAWSjg/tHGfTeRPWlEkOdEtWQjVnhNw5IxQ6tX8dEnrv5lZRD2tpxvwSGICj1DA/qZhgoPUMxDEFPt8Ls4svse0xxS3s0SgvzO8BPkRzx/q34ioI+8al6ZIQVfm/FUP2b8bWfoL2Z0k3IusAl0xqsEiySVAEojGOsRBBQKvbDXIO5RJaZGe0wlfyWq2CS/7rAC55FLrIHKqPBWUwTYcUzIJpNKfONZVdcEANbBC6gllRuxdN1Xf6bNg3nwP0RgtgiZjcLPl3mHCm22ZWJ8S9IuwMf8oOGwHnxoYeNeWQEGp+XfzEUL+MTews2wKD+K7/HC/MRqLFf/f2SZqmArLUX8dGjpC0j1jFs5jrztZUHg7Ft4ezCa6GvVcVsdG1c6cix+IRGMx/D9fPvBjOI4+gYaqtaLTdPwDwZiOiYj08H21XXFz9hwgAtaN8JNfJa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 02:41:43PM +0200, David Hildenbrand (Arm) wrote:
> On 7/15/26 00:21, Stanislav Kinsburskii wrote:
> > This small fixup series applies on top of:
> > 
> >   [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for userfaultfd-backed mappings
> > 
> > The first patch updates the HMM documentation example to make the
> > mmu_interval_read_retry() state explicit: callers should use the notifier and
> > notifier_seq stored in the same hmm_range that was passed to
> > hmm_range_fault_unlocked_timeout().
> > 
> > The remaining patches adjust nouveau, amdxdna, and drm_gpusvm users so the
> > timeout passed to hmm_range_fault_unlocked_timeout() is treated as a relative
> > HMM retry budget. These callers no longer keep an absolute deadline around
> > their outer driver retry loops or pass a computed remaining time into HMM.
> > 
> > This keeps the timeout scoped to HMM's internal mmu-notifier retry handling. If
> > HMM succeeds and the driver later observes an invalidation through
> > mmu_interval_read_retry(), the driver retries the operation with a fresh HMM
> > retry budget.
> > 
> > Changes in v2:
> >   - Kept the nouveau outer absolute timeout around the
> >     mmu_interval_read_retry() loop. hmm_range_fault_unlocked_timeout() only
> >     bounds HMM’s internal retries, while nouveau faults are handled from a GPU
> >     fault worker, so userspace fatal signals cannot break an endless stream of
> >     invalidations there.
> >   - Updated nouveau to use time_after_eq() before calling HMM, so the remaining
> >     timeout passed to hmm_range_fault_unlocked_timeout() is always positive and
> >     never 0, which would mean retry indefinitely.
> >   - Updated the nouveau fixup commit message to explain the worker-thread
> >     timeout issue and the time_after_eq() boundary behavior.
> >   - Fixed the amdxdna fixup commit message. It now describes
> >     aie2_populate_range() correctly instead of carrying stale nouveau prose,
> >     and notes that command submission still keeps its broader timeout while HMM
> >     gets a fresh relative retry budget.
> > 
> > 
> > ---
> > 
> > Stanislav Kinsburskii (4):
> >       fixup! mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
> >       fixup! drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
> >       fixup! accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
> >       fixup! drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults
> 
> Why a fixup series instead of properly resending the full thing?
> 

The goal was to get a Sashiko review, and v8 has already been applied to
both `mm-new` and `linux-next`.

You can find more details here:

  https://sashiko.dev/#/message/alaWmUEeIBeSkmO0%40skinsburskii

Thanks, Stanislav

> -- 
> Cheers,
> 
> David

