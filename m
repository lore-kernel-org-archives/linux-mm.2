Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9283ECA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15B66B0088; Mon,  5 Oct 2026 04:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EEBA6B008C; Mon,  5 Oct 2026 04:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903446B0095; Mon,  5 Oct 2026 04:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6831B6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:46:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C1DD8019D
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:46:52 +0000 (UTC)
X-FDA: 85287942264.12.2B02FC9
Received: from mail-yx2-f5.google.com (mail-yx2-f5.google.com [74.125.224.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7F1A4100005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:46:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qGd6s8XY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.133 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791190010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oxM3ciOFEW/xWgixB28fYW+lgjFR0+isydLOkZoLaaQ=;
	b=FJaz3NEn8KxAXlvd0xWWjbsDsuevWSPWyjsrJfeWE36Ia8Sq/CuU2QT9eryfzWi9OBA6kL
	0BvcCg5Rp7jnjKe42H3gMuomXV7HUToRLbz0unx69sptz23ouNbPdxrxYATNzGG1hAxw0p
	wYLy5i5CgtifrBDvEsG4wzCJqKIFxQ0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qGd6s8XY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.133 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791190010;
	b=KcHBCsnup/qe6RZn4Ua5nv2HlMm+Gc2P71M5+//4AjAFyQejpNAIzKTtFSeDVel/6TmMhe
	/VP6wQj83BVv7CQZ/rbfX6/i1Ew49dmSYvN90GiVR1Rkpub/oBwYHxyqpuJ16NoTODeWAb
	35o5OF6WIMs+reVeV1hJkTVHXbiD2aA=
Received: by mail-yx2-f5.google.com with SMTP id 956f58d0204a3-672d92bbfd3so610337d50.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 01:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791190009; x=1791794809; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oxM3ciOFEW/xWgixB28fYW+lgjFR0+isydLOkZoLaaQ=;
        b=qGd6s8XYtwa3UoWmOjtqIJfkYDZFPQfkSKE1SHIxuW7wTsdZ6NydZJl5ajszSQg47/
         xQrzl6LYbwERF4/YZpx1kYo1dzbCenQNg6kY6an04z/HMAj0er4nWW9731JXcSHt7aJn
         sDdWRWWbCUM1NAAqEoGwM1C9CKzyiQ+iosYIYPUHbuB+K4dLwz+F29uTyTLG36iFwfIg
         TztgM6FLFRecAPLnVWkSEuOmLwHsETyIuPgDD4oW52YEy2oJpvB71vyh0aF4gZVkulxZ
         f34YabcQplPQ2ryftnGXscHaLeceaRkLmz6dZuk9NE28uizsSk2hBog7eB9TwBFO23Bv
         z/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791190009; x=1791794809;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oxM3ciOFEW/xWgixB28fYW+lgjFR0+isydLOkZoLaaQ=;
        b=ypWl/uk2tKHG/yNp8J1ANGQn4MDsq2nIO+mkLKcSM5u5JqlPhAEJ9wxuVsmry75dp4
         rJuIy1Xm9MJt3SfCaC/Vqu4pW8G61e1T0bPUDzidfhQlFzRB+yBFBkj2A707g9+6Khww
         7e+SrIknRyHXGCQztbm/a6CCwQ2KBnq/52DI9ADLALKH+ZcblzrH6gaH+Rte/MFOVWeE
         uU+wOUXSqlYs1sbvwjBn/Ol6F/z9b1IoatUI+R03rPkwWqQ+iepfIjF9zPtphbSAyiUb
         BvT7+pGstPqQXMmJST7B6t05+IooaPikiBV0Q34yjncr/pqrNxgmTCq0+RBH8ibG4f5D
         dYVg==
X-Forwarded-Encrypted: i=1; AKwUvBwzVbkzpSQn0pvLQEOcgEqeL7YBNuIQVsEB9jhA/edBIbJX+gsEHB05JQWNVnS2IGSMtfxijlt2Kg==@kvack.org
X-Gm-Message-State: AFq9FYLAncqBe7WE6u6OvANOvTVA5D2oNjcyRAGbDlH/YzR6C2GurKGE
	8lZ5xAD/+g8qA+te4d424KQm2pwNH3XVKzBq1W/2A9jLco4nuk/vO0o=
X-Gm-Gg: AYBFou1UqOrKWwI34Zl7jUdXguwmGe2t8EZx7xFYcTF81e1SBR538TbrzmISPXtpO9f
	oT1LdnUSITYI5PmI+z1rpss7VAJk+sWGMxlP/D9BiQdmQs/fWPNke1ze7WatLxsXsmX1M/WMtGF
	Aqh00LvqzKmtl576kg0Q67LeHVk5WuKkpjEzse61NbGAVlY30Isbyj111e2fdQDZ12FZ/Q7VVpx
	jB8bEXKtG2UpeetncIQK/m67ET+F4IaEB/PAeddpgipQEpCtB+ZCIJ9p4q1C3yDopZUDPUBrAXx
	hjqBd/AdE2fTUa+Kev9ktmfd+ggfMZiOq1rXW9QIa9P5xAgZfZRYbSH7+dfJ5MnQ3Vb0Ptu9WNI
	Do9TRcGDUC5c1yD+Tvj9D7JYfNW7urOkxAapDW1VbGDrEE3J59Y6nDAakG5TRufTQpl5BYAachm
	6/8HRAGeMYeZW6IIIBGvnkD69pqLwTUYlKMr4zwxuWElmRdJzSSkJaLHb1U8jR8WCrGkjA+PSM+
	B/4D/MUPu4mAU3D1j7PnYmydqlYoSY9pG6VTeBzMSJDbevj5YdI+0MfeTrj7Niq+x7glKnV+ZXI
	JSZxQSIlvEqatpJQZeHG0w7uJpCX/henMw==
X-Received: by 2002:a53:d211:0:b0:676:97e6:d7ad with SMTP id 956f58d0204a3-677ac02f5d7mr2185858d50.25.1791190009083;
        Mon, 05 Oct 2026 01:46:49 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:1149:2fcd:c86b:8747])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-677c1b9c895sm2346306d50.13.2026.10.05.01.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 01:46:48 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [RFC PATCH v4 0/9] mm/damon: hardware-sampled access reports
Date: Mon, 05 Oct 2026 01:46:44 -0700
Message-Id: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/5WOwQ6CMBBEf4Xs2TUFGg2eNCTGozHeDAdatlIjL
 WmRaAj/botf4GkzM7v7ZgJPTpOHXTKBo1F7bU0QfJWAbGtzJ9RN0JCxbJMylmNTd9ZgT06hUxL
 HHD2ZBmOOKcOwIQpeN4oXJAoG4U/vSOn3wrjB5VhG73y4lieofql/iQfJIWJi1mo/WPdZKo35c
 vUHPVhhKsZ4uhU8FXJ/72r9XEvbQTXP8xcuQ9Mu8gAAAA==
X-Change-ID: 20261003-damon-perf-rfc-v3-send-2026-10-03-b94adf49eb90
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, 
 Wei Xu <weixugc@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
 Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
 Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
 Kunwu Chan <kunwu.chan@linux.dev>, 
 Ravi Jonnalagadda <ravis.opensrc@gmail.com>, 
 Jonathan Cameron <jic23@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: hebknqnpiskk9upusgj138xhdktd3inb
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7F1A4100005
X-HE-Tag: 1791190010-671605
X-HE-Meta: U2FsdGVkX1/S2KZ3jE9i0wXkS10dgoECSfg/+r5CDrEpckt94TAyQkng7l8gzleaYBSdDElsWT4u7xTZPbzucVZnu2OwzX1dLfPDT4NrcHB0/otUZwanc+IQuJ+h4bdcIO/t8eNn3WPA1GetnRDD+I+TZMKoliOJAeArIoGV5qiSkXE6Q4v/L/+YYsjunCnxBvm3bnJ08qHxU4m0gziiOaNeEnE3/4jWVsiJyF35/PBv2oT0f+H8troicBe/xEak22sPrUx99U3rxmoQFgIksDTetd+Q6gFxgxRco1ImvZJTBwQd5i+AoPGSo01Y6NyEPO/LW44ZDsA3twrHHOoWlMpvCNPzjI7HX/2Y/D7LPJ2h/E8rYaLOSl8zkGG9k4fUaK3P9O5Hi9+u2qBDNvPxvYnDjgTuH5vpW64Cf9byfZv7uNEvLftFUxJxWOETH9u8PA4vxGhwhYXLGQNRUtZIPgCGNAxvk3qRtZ29JZUe+sU303MBRJTCXm48lFeh3x9KK8HRb1P7E8SGwF+pcf7GITsZDRXpbn5b9CoVdMTF1Q2h3p063Z+H+EtFeFWMYE9X2sKWVN2FP7eZf6RwvcJ5l/lAi5hYQym0W43wLvzSZYwDfPtbGDbW83PdMCuKhqGyIZODtlpJH/QJHyBUZN5EPvq1Kjj0fgxXpAhpS53RxCOo4f5eBnmz4qgaqf0jzTU5bNkbHKwPH25mirh3M0gLiyAZh5Ef6QOxatVJTzK0mAa4LV8hLFteQv0i7VP4uTQ7Z0aYb0341yDD7FEFYKI7KCv7YyEyqHPyGaJ/VWxabU13iH/3A+E0QbrX23eFXfTsJ211dpdfCAgBq0oeLQE7cga+o7BmwB8ztW7KpjrpS5I5IbSY5s1WdYdsMBmy8RrqoYbjrAS4684neOlIZIg1nDgNLvRa9W6gAAMCzACdsntpUMHAhczBBo/q27UguQ5s0WrhapdwxK8ZA4Cr2dX
 j6ANEphV
 jEbTwzCYx6Me6kSWC9FyM5aJBXCYv/FeodKij7lo1G4IwwZFrLt27rZEcmhlBT7h2nGOKrrHYnCizyKbPqOLwQpoVzhetEB0n9N29A/B01W0yGgVHhUI321p9dhJfukVQGvyrGRtXAsdjFznikC/IMRSqljFw8kk7y7bCcqIe+NnoaTzO3IbeIdeQHhyOLO4omSQz10u63tXjNMmd8drI/5zP4lhlNs4sMBeZRC1PI3gomzqwnV/l96RqWiuqTaSs1sj7pH1ZVPDNWCDcMO8Q7M9DFWo15hc0pZVwT8NRD+xEisrot2Ee6dx9MTjwE29wlE8lpK7H8q99fWDA2R3dlDAEUi9IC0OIJE8gs8BqXzd7wpn4NP3pfVlTfm9bJZoRcnjaoG7AyvYDa6VKXSMzDAy8tSoRk19iGhPerca5UV5z+6wQFpFGy/PTnN9K1j+mODp292URn6uaVVGyVsTt89wcExF1QCZ8JDOeFiSOIWeDK5B4YxZO4DNplEiHP6Ny7ykZvbGdDpZnPnoIakKJzYU5ECPsUd6bY85k1QceEhkUnvkKs/rPwK+8Xr4R5AQsRC5rl+rRQw35ZtiURmzxfWKx/NrvOUsJ3dR4Q4p5kBZkhcjq77S3fMt4mBERjKC+Pxw8fuJKoOOhdikJ4Z5owgwb5W/FYSSX8xrsctlF5iP9zmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series lets DAMON monitor a hardware-sampled data attribute -- the
addresses a PMU saw accessed -- through the data attributes monitoring
(probe) interface, and run DAMOS schemes on it in data attributes-only
mode.  Patches 3, 5, and 6 are co-developed with Akinobu Mita, building
on his earlier perf-event proposal [3].

This v4 follows v3 by only a few days, which breaks the usual practice
of waiting for review before respinning.  I am sending it now so that
it addresses the sashiko review of v3 and the questions Kunwu Chan
raised on it before the DAMON nano-conference at LPC; it supersedes v3.

The scope has been narrowed from v2 [1] based on SJ's feedback; the
changes are described in the "Changes from v2" section below.  What
remains is the perf-event probe substrate and its consumers.

The sysfs surface has been reshaped against the milestone-1 probes/preps
interface [2], as the v2 cover letter said it would be.  A perf-event probe
is configured through the probe's preps/N/ directory using the
perf_event prep action.  This is the first concrete implementation of a
hardware-sampled data attribute on the milestone-2 path SJ described in
[2].

The series is based on damon/next at the base-commit below, which moves,
so the tree it was built and tested from is also on

  https://github.com/ravis-opensrc/linux/tree/damon/perf-rfc-v4-send-2026-10-04

It is posted as an RFC for design feedback on the substrate and on where
it belongs in the roadmap for extending DAMON beyond the pte-accessed
bit [2].  That roadmap's second milestone, now open, is a first data
attribute monitored through damon_report_access(), and that is what a
sampling PMU is here.  So this series keeps that function as the
reporting entry point and replaces its body: the reporting path a
hardware sampler needs cannot take a mutex, and the drain has to reach a
virtual-address context as well as a physical one.  The shape of the
ring, the drain and the sysfs surface are what is most useful to
review.

The series builds cleanly at every commit and passes all KUnit tests;
checkpatch reports only false positives.  It runs end to end on the
hardware described below.  I expect it to be rebased onto the milestone
2 work once that lands; patch 8 does not depend on the rest and could be
taken on its own.

Why a unified perf-event substrate
==================================

DAMON derives its access information from the PTE Accessed bit.  A
sampling PMU carries what that bit cannot: which addresses the hardware
went to, and how often it went there.  Many machines already have such a
unit, and more than one kind of it, so what this series is after is
letting DAMON's regions be tuned from whichever perf-based hardware
source a machine offers rather than from the Accessed bit alone.  A
sampler does not arrive on a kdamond's terms, though: it delivers an
address when the hardware decides to, in NMI context, with no relation
to the sampling interval and no mm to walk.

The alternative is a backend per PMU vendor, each owning its own
configuration, sysfs knobs and lifecycle.  The perf-event direction [3]
avoids that: let DAMON register kernel-counter perf events and consume
samples from any sampling PMU the perf core already knows about.  This
series follows it, adding one substrate below the ops sets rather than
an ops set per PMU -- a per-context report ring that the perf-event
overflow handler pushes into through damon_report_access(), and a drain
that folds those reports into region probe hits on the kdamond's own
sampling interval.  What running it across vendors needed on top of that
direction is:

  - per-CPU lockless rings between the NMI sample handler and the
    kdamond drain, one set per context, so each context drains only the
    reports of the events it armed,
  - per-CPU events that follow CPU hotplug, armed when the context is
    set up and released when the kdamond stops,
  - a per-PMU owner, so two contexts cannot claim the same PMU type,
  - whichever address a PMU does report carried on the report and
    matched against the context's own address space, so one source
    serves a paddr or a vaddr context without a backend per address
    space.

This is tested with PEBS on Intel and IBS on AMD, both configured as
perf_event attributes on a probe and using the perf core's event
plumbing rather than per-vendor MSR code.  A third source has already
been written against damon_report_access(): Kunwu Chan's ARM SPE
backend [5], which reaches it through an AUX buffer drained in process
context instead of an overflow callback, and which the roadmap [2]
places in its third milestone.

What the series adds
====================

  1. mm/damon/paddr: remove page_fault access check primitive --
     removes damon_pa_prepare_access_checks_faults() and its helpers,
     and damon_report_page_fault() and its caller do_damon_page() in
     mm/memory.c.  Both predate this series; removed here because they
     are the only producer into the report buffer that patch 2 replaces.

  2. mm/damon/core: replace the access report buffer with per-context
     rings -- the substrate.  Per-CPU SPSC rings, one set per context,
     that an NMI-context source can publish into, replacing the global
     mutex-protected buffer, plus the kdamond-side drain that matches
     each report to a region by binary search over a per-target snapshot
     and adds it to that region's probe hits, at most once per sampling
     interval.  The reports are data attribute samples and do not change
     nr_accesses.  The address space of the target selects which address
     of a report is matched, and pid targets are filtered by thread group
     id.

  3. mm/damon: add perf-event overflow handler feeding the report ring
     -- an ops-agnostic perf-event source whose overflow handler turns a
     PMU sample into a page-aligned report routed to the ring of the
     context that armed the event.  It sets each address field the PMU
     reported as valid, so a PMU that reports a virtual address only can
     drive a virtual-address context, one that reports a physical
     address a physical-address context, and the same source serves
     either without a backend per address space.  Per-CPU events are
     armed and released through cpuhp callbacks, a CPU whose counter
     cannot be created is left unsampled with a warning, and a per-PMU
     owner keeps two contexts from claiming the same PMU type.

  4. mm/damon/ops-common: use probe-weighted score when probe weights
     are set -- lets a scheme's frequency subscore come from the probe
     hits, weighted per probe, so in data attributes-only mode what the
     sampler reported reaches the DAMOS priority score.  With no weights
     set the subscore comes from the access rate as before.

  5. mm/damon: add perf_event prep type, core lifecycle, and PMU
     arm/disarm -- the event lifecycle: a perf_event prep action
     carrying the PMU type, the event config and the sample attributes
     per probe, with per-CPU arming or, through a single_instance flag,
     one counter for a system-wide PMU.  A single-instance counter is
     pinned to one online CPU and is not migrated if that CPU goes
     offline.  A commit keeps a probe's running event when its perf
     attributes and list position are unchanged, so a weight-only commit
     leaves it untouched.

  6. mm/damon/sysfs: expose perf_event prep attributes -- wires the
     perf_event prep attributes through the DAMON sysfs interface,
     exposing type, config, config1, config2, freq, sample_period,
     sample_freq, wakeup_events, precise_ip, sample_phys_addr,
     sample_weight_struct, exclude_kernel, exclude_hv and single_instance
     under the probe's preps/N/ directory.  sample_weight_struct only
     requests the weight in each sample; DAMON does not use it yet.  A
     perf_event probe cannot have probe filters.

  7. mm/damon/tests/drain-kunit: kunit for report rings and ring drain
     -- unit tests for the rings and the drain: inject and drain,
     overflow on wrap, a report without an owning context dropped,
     per-context isolation, probe-index crediting, thread-group
     filtering, the address-space match, ring-full accounting, and
     reports counted as at most one probe hit per sampling interval with
     nr_accesses left unchanged, with and without probe weights.  The
     sysfs checks of patch 6 are not covered by kunit.

  8. mm/damon/core: cap the region merge threshold per target -- on the
     regular merge pass, also caps each target's threshold at a tenth of
     that target's own maximum merge score, so a high-traffic target
     cannot merge away the hot/cold boundary of a low-traffic target in
     the same context.  The passes that bring the region count under
     max_nr_regions keep the escalated threshold.

  9. mm/damon/core: apply probe_hits_wsum filters to
     node_eligible_mem_bp -- counts a region as eligible memory only if
     it also passes the scheme's probe_hits_wsum filters (SJ's DAMOS
     core filter), decided as core filters are but among those filters
     only, so the quota goal follows the regions a scheme selects in
     data attributes-only mode, where the access pattern cannot select
     them.

Patches 2-5 are the substrate; 6 is its sysfs surface; 7 covers them;
9 lets the node_eligible_mem_bp quota goal use what they monitor.
Patch 8 applies on damon/next independently and could be taken on its
own.  Patch 1 applies on its own too, but is only needed with patch 2.
Documentation is left out of this RFC, to follow once the design is
settled: the perf_event preparation action and its sysfs files, how its
samples are counted, the node_eligible_mem_bp change, and marking the
page fault based access check unsupported in the design document.

How the samples are counted
===========================

A perf_event probe follows the data attributes monitoring design.  A
region's probe hit count rises by one for each sampling interval in
which the PMU sampled an access in it, the same per-interval bound a
probe hit has for the samples DAMON takes itself, so the count stays
within the samples per aggregation.  Where DAMON's own probe tests one
address per region, a perf hit means that at least one PMU sample landed
somewhere in the region.  No sample changes nr_accesses, which stays with
the access check primitives.  To act on the samples, a context sets a
probe weight, which turns on data attributes-only monitoring:
DAMON merges regions and ages them by the weighted probe hits, and DAMOS
schemes select regions with SJ's probe_hits_wsum filters.  Patch 9 makes
the node_eligible_mem_bp quota goal count the regions those filters
select.  The runs below use that mode.

Changes from v3
===============

In v3 [11] I made the drain raise a region's nr_accesses for each
sample, so that a region the PMU sampled more often read as hotter.
Kunwu Chan pointed out that this gives nr_accesses a scale that depends
on the PMU and its sampling settings [10].  The data attributes
monitoring design already has the place for such samples: a PMU sample
is a data attribute sample, so v4 counts it as a probe hit, at most once
per region per sampling interval, and leaves nr_accesses to the access
check primitives.

The sashiko review of v3 is addressed as well, including bounds in the
drain and in probe arming, the probe-weighted subscore computed in 64
bits, PERF_SAMPLE_DATA_SRC gating, sysfs locking and the
CONFIG_DAMON_PERF_SOURCE=n case.  Pid targets are now matched by the
thread group id of the target task, probe_hits[] keeps its base width,
and v3 patch 9 is dropped, since data attributes-only mode already turns
the access checks off.

Changes from v2
===============

Following SJ's feedback on v2 [1]:

  - The page-fault primitive is out of scope.  The vaddr page-fault
    primitive, the global page-fault report ring and the partitioning of
    reports into probe classes are dropped; there is a single class of
    report ring, per context, fed only by perf-event probes.
  - The CPU-number and folio-lock fixes (v2 patches 2 and 3) are dropped
    with the page-fault path they belonged to.
  - The damos_node_eligible_mem_bp tracepoint (v2 patch 4) has been
    decoupled from this series and sent separately against mm-new:
      Message-ID: <20261003202727.3673-1-ravis.opensrc@gmail.com>
      Link: https://lore.kernel.org/all/20261003202727.3673-1-ravis.opensrc@gmail.com/
  - Per-CPU rings are kept; SJ wrote "feel free to keep the per-CPU
    rings.  As long as it is an RFC, please feel free to implement it
    in an easy-to-implement way."

As in v3, one point differs from what the v2 thread discussed.  It scoped
milestone 2 to physical addresses only, with the virtual-address parts
deferred to phase 3.  This version keeps virtual-address support, for
the following reason: the concern that made the page-fault path a poor
fit for milestone 2 is that it reaches into other mm code (the fault
handler and mprotect).  The virtual-address support here does not.  It
is confined to the DAMON report path: the overflow handler records the
virtual address the PMU reports, and the drain matches it against the
regions of the target whose thread group reported it.  Nothing outside
mm/damon/ changes for it, and in vaddr.c it only makes the software prep
and apply paths skip event-driven probes.  It is also what makes a PMU
that reports only virtual addresses to the overflow handler, such as
Intel PEBS, usable, and what lets a context scope tiering to a set of
processes.  If milestone 2 should stay physical-address only
regardless, the vaddr handling can be taken out without affecting the
physical-address path, and I am happy to do that in the next revision.

Patch 8 is new since v2 and was in v3.  It keeps region merging from
erasing the hot/cold boundary of a low-traffic target when the same
context also monitors a high-traffic one, as configuration B below does.
Patch 9 is new in this version; it is what configuration A below steers
by in data attributes-only mode.

Changes from v1
===============

v2 [1] moved the series onto the data attributes monitoring (probe)
infrastructure that had landed in mm-new after v1 [12]: a PMU became one
more probe on a context, with its own weight and probe hits, instead of
a mechanism of its own beside the ops set.

Build qualification
===================

Tested with CONFIG_DAMON_PERF_SOURCE and CONFIG_DAMON_KUNIT_TEST
enabled; the series also builds with CONFIG_DAMON_PERF_SOURCE disabled.

Patch 1 removes the only code that sets MM_CP_DAMON (defined in
include/linux/mm.h).
The check for it in mm/mprotect.c is left for a separate cleanup.

Userspace setup model
=====================

The runs were driven by an auto_tier subcommand added to damo on the
branch below, which reads achieved bandwidth from resctrl MBM [6].  That
tooling is not part of this posting; it is on

  https://github.com/ravis-opensrc/damo/tree/damo/auto-tier-bw-2026-10-04

Configuration A: AMD IBS Op, paddr ops, system-wide
---------------------------------------------------

```
$ sudo mount -t resctrl resctrl /sys/fs/resctrl
$ sudo python3 tools/damon_tier_gen.py --hotness ibs \
        --near_node 0 --far_node 4 \
        --cold_demote --cold_demote_mode proactive \
        -o tier.yaml
$ sudo damo auto_tier tier.yaml --bw_source resctrl --verbose
```

  - Scope is the machine, not a process set.  The distribution is
    steered through node_eligible_mem_bp [8] quota goals over each node's
    own physical ranges, which the generator reads from /proc/iomem.
  - AMD Turin, DRAM on node 0 and a CXL node.  IBS Op at a sample_period
    of 262144 with sample_phys_addr set.
  - damo detects convergence of each step in this mode from the
    damos_node_eligible_mem_bp tracepoint, which has been sent
    separately against mm-new
    (<20261003202727.3673-1-ravis.opensrc@gmail.com>) and is not part of
    this series.  The runs below were taken with it applied.
    Without it damo falls back to a coarser convergence check.
  - Workload: multiload drives the hot set; a second process allocates
    32 GiB on the near node, touches all of it once and then only a
    64 MiB part, leaving the rest idle to age out for the demotion
    scheme to find.

Configuration B: Intel PEBS L3-miss, vaddr ops, per-PID
-------------------------------------------------------

```
$ sudo mount -t resctrl resctrl /sys/fs/resctrl
$ sudo python3 tools/damon_tier_gen.py --hotness pebs \
        --pid $HOT_PID --pid $COLD_PID \
        --near_node 0 --far_node 1 \
        --cold_demote --cold_demote_mode proactive \
        -o tier.yaml
$ sudo damo auto_tier tier.yaml --bw_source resctrl --verbose
```

  - Scope is the named processes.  Distribution steered through the
    hot scheme's DamosDest weights [9].
  - Intel Granite Rapids, DRAM on node 0 and CXL on node 1.  PEBS
    L3-miss at sample_freq 5003 with precise_ip 2.
  - Same workload shape.

Both configurations run in data attributes-only mode, with probe
weight 1, so DAMON adjusts and ages regions by the probe hits.  The hot
scheme selects regions with at least one weighted probe hit through a
probe_hits_wsum filter.  The cold scheme selects regions with none, and
demotes those that have stayed so for its minimum age: a region that
receives no perf-event samples keeps a zero weighted hit sum, so its
age keeps growing.

  - `--bw_source resctrl` reads achieved bandwidth from an MBM
    monitoring group; `--verbose` logs each step.
  - Everything else -- intervals, schemes, filters, the probe's
    perf_event attributes -- is written by the generator from the
    command line shown: 5 ms sampling, 100 ms aggregation, 1 s ops
    update.
  - Both configurations select proactive demotion.
  - The hot-spread-only runs below use the same commands without the
    --cold_demote options and, in configuration B, without the idle
    process's --pid.
  - The search is the algorithm described in [4].

What the runs show
==================

Per-node reference, each figure measured by binding the same workload
to one node:

```
  Granite Rapids, 64 threads x 8 GiB
    node 0   1.0 TB DRAM      DRAM only   269,574 MB/s
    node 1   2.0 TB CXL       CXL only    249,045 MB/s

  Turin, 32 threads x 4 GiB
    node 0   386 GB DRAM      DRAM only   113,288 MB/s
    node 4   1.0 TB CXL       CXL only     39,280 MB/s
```

Configuration B, virtual-address mode (PEBS, hot spread only):
--------------------------------------------------------------

```
   MB/s                                               climb
   460k |                                   *  *  *  *  *  *
   440k |                                *
   420k |                             *
   400k |                          *
   380k |                       *
   360k |                    *
   340k |                 *
   320k |              *
   300k |        *  *
   280k |
   260k |  *  *
        +--+-----+-----+-----+-----+-----+-----+-----+-----+--
           1     3     5     7     9     11    13    15    17
           100   88    80    72    64    56    48    52    52
           decision index, near-node share (%)

   settled        52% near, 463,151 MB/s, after 16 decisions
```

  - Converges unattended from no given target to a distribution that
    beats either node on its own.

Configuration B, virtual-address mode (PEBS, cold demotion):
------------------------------------------------------------

  - Cold demotion from PEBS aging alone (no page-fault primitive):
    32,655 MB of the idle process's 32 GiB moved to the far node in
    600 s.  Regions that receive no samples keep a zero weighted hit
    sum, so they age, and the age-gated demotion scheme moves them.

Configuration A, physical-address mode (IBS, hot spread):
---------------------------------------------------------

```
   MB/s                                climb
   136k |                  *
   134k |                          *   *   *
   132k |              *       *
   130k |
   128k |          *
   126k |
   124k |
   122k |      *
   120k |  *
   118k |
        +--+---+---+---+---+---+---+---+---+---
           1   2   3   4   5   6   7   8   9
           100 92  88  84  80  76  78  80  78
           decision index, near-node share (%)

   settled        78% near, 134,738 MB/s, after 8 decisions
```

  - 8 decisions to settle at 78%, from a start with almost everything
    on the near node.

Configuration A, physical-address mode (IBS, cold demotion):
------------------------------------------------------------

  - Cold demotion from IBS aging alone: with the idle process as the
    only workload and only the demotion scheme configured, it moved all
    of its 32 GiB to the CXL node, 98% of it within the first minute.

What the runs establish
=======================

  - A controller reading achieved bandwidth converges unattended, from
    a configuration naming no target, to a distribution that beats
    either node on its own, and holds it once found.
  - Sampling-based aging (regions that receive no samples keep a zero
    weighted hit sum and age) identifies cold pages and a demotion
    scheme moves them, with PEBS and with IBS, without the page-fault
    primitive.
  - One code path does both, steering node_eligible_mem_bp over physical
    ranges system-wide on one machine and DamosDest weights over a named
    process group on the other.

Beyond a CPU PMU
================

Nothing above is specific to PEBS or IBS.  A source qualifies if it can
report an accessed address to the ring.  A CXL device's Hotness
Monitoring Unit [7] or a custom monitoring unit on an accelerator
reports exactly that, and a backend delivering those reports through a
perf event reaches the same drain, the same probe hits and the same
schemes already in the tree.

References
==========

[1] v2 of this series
    https://lore.kernel.org/linux-mm/20260910171623.6638-1-ravis.opensrc@gmail.com/
[2] Roadmap for extending DAMON beyond pte-accessed bit
    https://lore.kernel.org/damon/20260525225208.1179-1-sj@kernel.org/
[3] mm/damon: introduce perf event based access check
    https://lore.kernel.org/damon/20260423004211.7037-1-akinobu.mita@gmail.com/
[4] B. Tabatabai, R. Jonnalagadda et al., "Bandwidth Speaks, We Listen:
    Dynamic Memory Interleaving for Tiering", ISMM 2026.
    https://dl.acm.org/doi/10.1145/3814942.3816137
[5] mm/damon/perf: add ARM SPE AUX backend
    https://lore.kernel.org/damon/20260816142222.689624-1-kunwu.chan@linux.dev/
[6] A platform-independent subsystem for bandwidth information, and
    resctrl as that source
    https://lore.kernel.org/linux-mm/d952a84f-332e-8f7a-4816-2c1cbd8f5b00@google.com/
[7] CXL Hotness Monitoring Unit perf driver
    https://lore.kernel.org/linux-mm/20241121101845.1815660-1-Jonathan.Cameron@huawei.com/
[8] mm/damon: add node_eligible_mem_bp goal metric, merged for v7.2
    https://lore.kernel.org/linux-mm/20260428030520.701-1-ravis.opensrc@gmail.com/
[9] mm/damon/vaddr: allow interleaving in migrate_{hot,cold} actions,
    merged for v6.17
    https://lore.kernel.org/linux-mm/20250709005952.17776-1-bijan311@gmail.com/
[10] Kunwu Chan on the nr_accesses scale of hardware-sampled reports (v3)
    https://lore.kernel.org/all/20261004083036.613169-1-kunwu.chan@gmail.com/
[11] v3 of this series
    https://lore.kernel.org/all/20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com/
[12] v1 of this series
    https://lore.kernel.org/damon/20260529165640.820-1-ravis.opensrc@gmail.com/

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
- Link to v3: https://patch.msgid.link/20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com

---
Ravi Jonnalagadda (9):
      mm/damon/paddr: remove page_fault access check primitive
      mm/damon/core: replace the access report buffer with per-context rings
      mm/damon: add perf-event overflow handler feeding the report ring
      mm/damon/ops-common: use probe-weighted score when probe weights are set
      mm/damon: add perf_event prep type, core lifecycle, and PMU arm/disarm
      mm/damon/sysfs: expose perf_event prep attributes
      mm/damon/tests/drain-kunit: kunit for report rings and ring drain
      mm/damon/core: cap the region merge threshold per target
      mm/damon/core: apply probe_hits_wsum filters to node_eligible_mem_bp

 include/linux/damon.h        | 145 +++++++-
 mm/damon/Kconfig             |  19 +
 mm/damon/Makefile            |   1 +
 mm/damon/core.c              | 851 +++++++++++++++++++++++++++++++++++++------
 mm/damon/ops-common.c        |  19 +-
 mm/damon/paddr.c             |  72 +---
 mm/damon/perf_source.c       | 429 ++++++++++++++++++++++
 mm/damon/perf_source.h       |  55 +++
 mm/damon/sysfs-sample.c      |   7 +-
 mm/damon/sysfs.c             | 304 +++++++++++++++-
 mm/damon/tests/core-kunit.h  |   2 +-
 mm/damon/tests/drain-kunit.h | 786 +++++++++++++++++++++++++++++++++++++++
 mm/damon/tests/perf-kunit.h  | 133 +++++++
 mm/damon/vaddr.c             |  15 +-
 mm/memory.c                  |  53 ---
 15 files changed, 2625 insertions(+), 266 deletions(-)
---
base-commit: 9f1c290342ea4f24dc1be639ff3055716f829376
change-id: 20261003-damon-perf-rfc-v3-send-2026-10-03-b94adf49eb90

Best regards,
--  
Ravi Jonnalagadda <ravis.opensrc@gmail.com>


