Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD00C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 03:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720766B0088; Tue, 15 Sep 2026 23:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0886B008C; Tue, 15 Sep 2026 23:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C12D6B0092; Tue, 15 Sep 2026 23:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC1E6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:45:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7F261405FF
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:44:58 +0000 (UTC)
X-FDA: 85218234276.17.9E2BCAD
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf24.hostedemail.com (Postfix) with ESMTP id 02D96180004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:44:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bOSPZYSo;
	spf=pass (imf24.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789530297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MnDdBBFYGdDerxU4AbUc/Vqzv/CMmRt4z5XHr/nlcM0=;
	b=MWMJDvp4JP2WQ+B6H9qktmWCSeVXErLw1GFnm8sqA09v8K/pW0y9J+6WN1DtzpqYgWIhno
	ByS9seYwg68AHH7RJfACJTiWcFb7rE8ee2i6lha0432PrSgA7yU1g57bk1jyYRen6hHjqB
	0e7AMkD2YX4YMFzXJEVTEzyE/y4d27g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bOSPZYSo;
	spf=pass (imf24.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789530297;
	b=PtAWClTTg5Rb0oqtZ9KTuFxNLPxTQdN2qr3+xpB6gduRRGTRSZcbadXFGdzgEO1Zsj+61t
	fxayRtdRwOupLvc18A7qRhmY6ypG9CoF2EP1Y3i/J9e36/cBV4297OfgduediPph95HZSv
	hzXkzye2UO7uCM2Nhv7U4agbMYEKGSU=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-398c066106cso341213a91.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 20:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789530296; x=1790135096; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MnDdBBFYGdDerxU4AbUc/Vqzv/CMmRt4z5XHr/nlcM0=;
        b=bOSPZYSoY2qkBBipWxvWo0UBWpqX6ax8ePp3ble8YCk1piSd7c1whQNJqBzPA29KZJ
         DADAy0VOgpWogDKlwgZ/ImQZzl66klcqsYaD+8VtkrJ+ESRj1hvnMduxdsxk0vOSmo7p
         wsQLXGqP/dokOvPGH/g1aCOUTMVNrE+CZDjJQM1qor5ZyRM66VoZCbLssmMOjsTHLLac
         cH0c3O0jPbglvkFU1Wp8oZHhvkwFa0dsqP4rlVuYOMwXcRD/PJJU9m9+P5trRRX8KMUP
         jaCDvqNoLwpckbcHieY+E9dLApWBXH0CQVoFOiIAbWHndOmo7zq9SjQHMbRqvpbrcpUs
         /97w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789530296; x=1790135096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MnDdBBFYGdDerxU4AbUc/Vqzv/CMmRt4z5XHr/nlcM0=;
        b=xcu4zG587Qhoa8TjwFr+MiuQwYuL8iIEy8qAPIoMtOzGStHTFat2HPPReCxwhENgBw
         HwOLO1dMzFnVcMQ/3E+lAzEEf7lv7KvZySG3kxqK4alV50q1rFiNeGS72GT6gu8LJL+v
         M8weUhYxuimr5x7k8NT4cn5e3sgCVoeNGHzP1aYfX8VOvgNJtXD0XpkYiSrwOW1t5uC4
         Kpg9N0vk1BlcXTBLZKp//Q3yCXGlpkpXGZgFgdNt90q+QSAY/0rfBhUH/ZGMGD+cxbzR
         fT3rVuzaLztTHjnrLMI+gGdWgcSG3YMC5Ig2nRStetunoEGgPol51mlW4haofoU1qFwZ
         060w==
X-Forwarded-Encrypted: i=1; AKwUvBxX7ebhhscbWKy74SSmny1qyEDjRvFxCLOTvP2CHH1x8GWWIAaTZUnkR4QmXVe0sSeDFXa5NYzLNg==@kvack.org
X-Gm-Message-State: AFuF++nac2BRcLvggnz95nz2mPgpnzWC03wE1uwMR+HpDq0nYCITxjUi
	5VGBfovNiG65IJ3P1JZLZMZqgOijaXRU1GKgECXy1WR/E2yCyV1V0EhX
X-Gm-Gg: AYBFou2o/U4/UUq+1Gnj0f2kvJblFNWb2cjMUq9tmTWvJ/TmUILKZAwwT2jmbRe/1KM
	XbhXteMWqihlk20S85lEQp/j+67HUFx/t/jAFuTIO2XwRYnV40HRMZOLAFsX/jzfw1It2T4ASRB
	s1tFvSGBljKXyo4kibn32LGTlxlz103bQy8hoH/HV2EZLpe/Hi1U4Dn7vDNdmW5/59wt7XU1gjH
	t5MDBLRnjwy5vpk+dwcUGJS9SHZfNWN2zW8Ira8MGauZc1vw2BArsLcbOlYLRR4gyLA/18Pn8bF
	ZjPinauecWS5RJim3Sss1/KSXGaOvJGH5QVuOhs9LOpOlv2tmgaOiT+79MgWjXBVdJ9QX1hhfb1
	1QWj1G4ZTRGIcALoZAbjIuYdYZW4tntx55QarGcTkWO+78aQvgJP8RHn7//4PP4Nj6p2B/SMwBl
	5gLC1WODCt8eAUgKcoDKExl70hHlTDhCyj2jmXVmv+YfH6Y/swoghTZcUv9f/KZKS8Nmug3T/oT
	SUw7y5lYS227Cj4EazAWB/a1wS/tFkCEWn4PS9L
X-Received: by 2002:a17:90b:3b91:b0:398:a486:81ec with SMTP id 98e67ed59e1d1-39e1e380e12mr2394470a91.11.1789530295541;
        Tue, 15 Sep 2026 20:44:55 -0700 (PDT)
Received: from localhost.localdomain (vmi2317699.contaboserver.net. [85.239.239.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1bbfdd49sm1915990a91.11.2026.09.15.20.44.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 15 Sep 2026 20:44:54 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Lian Wang <lianux.mm@gmail.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net,
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: Re: [RFC PATCH v2 0/9] mm/damon: hardware-sampled access reports
Date: Wed, 16 Sep 2026 11:44:30 +0800
Message-ID: <20260916034439.28517-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916005810.101606-1-sj@kernel.org>
References: <20260915025514.2434-1-lianux.mm@gmail.com> <20260916005810.101606-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xsc1jzw7thi5zjfx3iaxrwgd48s83wix
X-Rspamd-Queue-Id: 02D96180004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789530296-404503
X-HE-Meta: U2FsdGVkX19Lc4A2sRrcehWoeY3WMqk3vpV3NItwpiKMu9xSHInSIxF/ql+C7T8xqRbomAzoklcT82bYN4BOG7+GTqQICYdEDSrJB2O/2lIPqH0+ZwF8DRaDqyjwsM7q47togOc3+re4XqmC7JFCTVl6YeRUKeV/e8pgjv05aAhAJsJMXMJws8EpD4ah5bSsLC00UseHtwRaFF2KSeNfZwpTb3GtjljzUCtGRS2B1P4Ow7tksBkut6Q1HCcuxvcYAPuYTWNZ5qED7pwGKnPwyDqssAQY2HdHci1pmbORSD5PQPelKOHJcgkvlfOEeLc4OKuqq+hKvDTx1Jm1DWmy96yZ658QKzv7hOu1tOOz57qzFgyx5VPJnh+VT7wq0BEmpqGankIj2vTVbFz9qg9hyWAckWQW2afpqtRecPBGyx81Ej8g8slglDK3ii1RnDuaEVTGftPkUfM6LtjN+yehYeD0O4+zqpHvOpd8n3PnAybD4W86wVbJCiG9zd83/kXPekeUTLyYtJ2VtayTnL6rVCl8Oz5m78AVri9vKQ8Z6KmAfxP2NbNwvJ2h++JdwoizB7z+nO6XsNHd7hI5mQ+8YmfsABusinm9M3dCCAZWfZJCf9n9delGcCo8Inm/B6Ji4azA1DLDjD6dmR6Ly5wHefZCo/Ja/oQ1ciejFm3pNqRoEYmatIE7ixY3k1q5OqT6ycvI1TNb64JQuW7auPux5pWLJSbSVAL/ieV/AHv+o9iFEq/62RxZJ3FsRnCe9xv+pKpCPpjbzI8lk6EVX48fHb5Qp9KEhqqowSx+FbE/C15VN43hwrH5GUGBCQ8gzFjV4uuArYpbJKSfeM6dG4VQjJefPEcxf+DuGC70wGYz0lrQbVnJ07OKWjW1KZQQ2QiJZ5v52pwK7eNDxJ3MYdq1f3u4PK5DQTvv7BaBRmQLLn+qbgmgkGcABm84fU/bJDS82YLF7w5mGG/ZBxoHmGY
 /jRGaji4
 61QU5EndKzQv+sthEkYtnV3ZAtgQRXceJVT2ICbJ3VuaiQ7k5PtRoDknWbZHneS2SPL8lQbf5/OggTHMvpV/Goy9fxgQIla4QJmMdi0flW6gZZ7qJlxJj4ku38Qop5oxJEk/CWiUSjck5N1toWmzdMGxWIPmu1rcIS6K7UipCC3mEk8rBwrjZ/KO7/iCaldCz65nNbXQSLiCUsC6Ds3tUYVjxyjbCONHbahT65dwe41zMulaErjB/QwwiFrZEX1A+FlvmhDT/XNC62wVFHB6APvuDlb43IoS7c8vmKHuAddPlvzD0McLEszUk6uT4bA8EtV6zTDVHNc03C1MWkgWt1LwX78BpDURVvNVfHJdJb+EQmajkYn73ok9zrOrH7swQVtwJjBT8RfvuhCezykDaIdQoJ9Tm1UfVpcsjUOIE3hIMmRF9RqG4T6r3Fhhb/IrgmVWQGbHLRtgSnGOVTJ8qtAtNig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Thank you for the questions.  I mixed the original field scenario and our
controlled reproducer in my previous mail.  I also jumped from the observation
problem to PMD mapping demotion before explaining why the deployment needs both
huge pages and finer-grained observation.  That made it sound as if our goal
was simply to stop using huge pages.

> The observation makes sense.  However, does the sparse access pattern
> realistic?  If so, what is the purpose or expected benefit of using huge page
> for workloads having such access pattern?

The original case is not a lab-created request to use huge pages for a sparse
microbenchmark.  It was reported by SXF from a KVM/QEMU deployment where the
VM has a large memory allocation backed by a shared tmpfs file, host THP is
enabled, and Oracle runs inside the guest.  They use host-side DAMON to measure
the VM's hot-memory proportion.  With the same business memory use, they
observed a much larger hot proportion when THP was enabled.

The guest tmpfs 4 KiB/2 MiB writer is their controlled diagnostic case for
isolating that observation; it is not a claim that the Oracle workload is
exactly a one-page-per-2-MiB loop.  We then reproduced and quantified the same
effect on a PC and on the x86 server.

For this deployment, keeping large pages is a real requirement at the host
virtualization layer.  QEMU owns a large resident guest-RAM mapping.  Host THP
allows that mapping to use PMDs and allows KVM to use large secondary mappings,
reducing host page-table memory, TLB and nested-page-walk pressure, and KVM
mapping/fault overhead.  These benefits are independent of whether every 4 KiB
page inside a particular 2 MiB range is hot at one observation time.

This host configuration should also not be confused with the guest database
page policy.  Oracle may separately use explicit HugePages for its SGA inside
the guest; the guest policy and the host THP backing of QEMU RAM are different
translation layers.  The requirement reported to us is to retain the host
large-page benefit while measuring the guest working-set proportion from the
host.  Disabling host THP merely to make DAMON's number smaller would change
the deployed VM configuration and remove the benefit the user is trying to
keep.

The monitoring requirement is different: DAMON is expected to estimate how
much of the guest memory is actually hot.  A host PMD is a translation unit for
guest RAM, not a semantic hotness unit for Oracle.  Guest allocation can place
small accessed pages across many guest-physical 2 MiB ranges, and one access
then makes each corresponding coarse mapping look accessed.

Our latest capture makes this mechanism concrete.  The sparse diagnostic
touched 24,576 guest 4 KiB pages spread over 24,575 guest-physical 2 MiB
buckets, while the dense control touched 12,582,912 pages.  They are 0.146%
and 75% of the monitored 64 GiB backend, respectively, but host DAMON reported
about 75% for both.  This is why the user needs huge-page mapping for VM
performance and, independently, finer-grained observation for a meaningful
hot-memory ratio.

The performance requirement and monitoring use case come from the deployment,
not from our lab model.  We will also report the measured Oracle/VM benefit and
the production access distribution when those data are ready.  The diagnostic
result establishes the observation mechanism, but it should not substitute for
those workload-level measurements.

> I'm not very sure if this is the right direction.  PMD mapping demotion sounds
> like you just don't want to use huge pages.  If so, you could disable huge
> pages.

I agree.  My reasoning in the previous mail was too jumpy: I went from a coarse
observation directly to a possible MM response, and that obscured the actual
goal.  PMD mapping demotion is not part of our current proposed solution.  The
current direction is to keep both the huge folio and PMD mapping unchanged and
use a genuinely fine-grained access primitive to improve the observation and
the stat-only decision.  We should first find out whether that is sufficient
before discussing any mapping change at all.

> technically speaking, it is not the report semantics.  Reporting allows any
> information to be reported.  Page faults like information could be coarse
> grained, same to the current page table accessed-bit based one.  Only finer
> grained access primitive reports, like those from perf events, would increase
> the accuracy for the sparse access pattern monitoring.

Agreed.  The report interface is the transport, not the source of accuracy.
Our recorded-address replay is intended only to test whether the DAMON
consumer and decision can use complete fine-grained address evidence.  The
eventual accuracy has to come from a fine-grained primitive such as an
appropriate perf event source, with its coverage and loss accounted for.  We
will use that terminology in the follow-up results.

With this context clarified, we will return to the immediate work: use the
existing IBS/perf-event proposal as the concrete strategy under test, and see
whether its fine-grained evidence can improve the observation and DAMOS
decision for this case.  We will use the results to test and review this series,
report both improvements and remaining gaps, and not assume in advance that it
is the final solution.

I hope this clarifies why keeping huge pages and requesting finer-grained
observation are not contradictory requirements in this case.

If I am still misunderstanding any part of your questions, or if any part of
this explanation remains unclear, please continue to correct me.  We will keep
sharing our findings and would like to make sure we are aligned before going
further.

Thanks,
Lian

