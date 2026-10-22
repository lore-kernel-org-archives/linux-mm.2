Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A5B606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 04:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jOCJOiOM
Received: by kanga.kvack.org (Postfix)
	id F27F76B029B; Thu, 22 Oct 2026 00:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00626B029F; Thu, 22 Oct 2026 00:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14DF6B02A5; Thu, 22 Oct 2026 00:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA6F46B029B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:17:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38E8A1C3DCA
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:17:31 +0000 (UTC)
X-FDA: 85348953102.20.771A4A8
Received: from mail-yx2-f5.google.com (mail-yx2-f5.google.com [74.125.224.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6FAD2120005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:17:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jOCJOiOM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.133 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792642649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4fgTxnwo+3lhaoW5IJ3HlnUCymtn0k12F/Qm8PcmcU=;
	b=6jGIBk33cWi5gdL/ydGDfh6liAMA9iaA6EAJNdFdhIx3SgkeHjI5XXRy++VJPAAT/sZn8y
	ZjpSDs9HVcS5nmTPHNDK48pnp/oHxpAcoxwPqFs5bZgEknc/riJ6bCY3yCcWY5Dt55ikc0
	J5GRgpJxEDRab5ixe4jQ7re9afu2TTY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jOCJOiOM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.133 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792642649;
	b=HjRoB2nR0m7c2H/fVJH1PoWWDjrqKXKOThj/H3+EonMur2I3dUEA/HpZdXy33Dfzd27hbW
	SmNtZe8BKpbIgDcLZdHHbwLywSvWfYS7n/cCug3R3eXLCLjUe7FKkEtN7UHyRFB4G3O5kW
	fIbLcgcSYvZUOkKj03WA30znkQ5w8PM=
Received: by mail-yx2-f5.google.com with SMTP id 956f58d0204a3-672d92bbfd3so618482d50.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792642648; x=1793247448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D4fgTxnwo+3lhaoW5IJ3HlnUCymtn0k12F/Qm8PcmcU=;
        b=jOCJOiOMef7tWbUz8HGRghvq4ntoEFNUZyxyRUUMFclEnZSRJDW7t+jrNPEC5/9wbx
         1vUwQRYeyxWmSvXJyxNR6YxC6wmgEvu5X5j6cBxdrC3LI4ac+sydPx0+jKkdV311QFXx
         01KVHA3t3gE315t57eGLlg2uKy6YehNlQFkZpeGsDe+88SyM9JmDaInwf4SUf+QKGZrN
         1IpXwUwRIUjXSfT2qUmZVLOUUrXuXf8ACGB+pdokt9aB92Eh91i4C0kwN5U5BUurD8yV
         VQ+spri0a3Hwbabfbv6dumnTVjLqshPksPDs4tXRh8bEGFHeotjRX0qxBtwcnTNQE562
         LZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792642648; x=1793247448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D4fgTxnwo+3lhaoW5IJ3HlnUCymtn0k12F/Qm8PcmcU=;
        b=WU/9faDEf+JDY7+G7Muv5lNa/U3JRFLipDxT0/m4y3miiPA429wpSwm+BlgEJLm9D7
         9uTnYzAAFOPlIY+seCZERH+pyBs0ckuP3rixfE9SXMV0/1to6rHBl07hT6v+L75PiX2O
         ObNyUxwXAupKNKRjGb/eEY1wMiR6BJtFufCZmauu6z9EmxZJH7AsArVt2tK4iGjnCNYz
         K9Iak9y73ooYwcyzpGAZlrwU1zpGJZEniNodJ8HbL8Ql0rEem88b40IrtHBlzoZMqE78
         KCM6H/7oyeWH96JD7g6ii7/6gU7XVa3qHyk8nJd7NK/eC2jat+JO2QSVQfcqO+PxnL8n
         LPCw==
X-Forwarded-Encrypted: i=1; AKwUvBx8am+fOlT0c+nngT24gu/3kYTizJfc2zVRJJVkOnBzS4AxcVvPH6acEGUvKKZwDCrKXt5kXYTm0Q==@kvack.org
X-Gm-Message-State: AFq9FYJ4GIHL6rdR15yyQqTRN+n0HWvrjbhe8pyEO8FpZOw2l2dJ3PcI
	afEAdL4pHNEZfHOVHx05Mm4ffAVTN5qalpFzUtIy+WwtL0xbMRbbA4g=
X-Gm-Gg: AYBFou01iypBAFJk8xiCYVjBvh0P5AitPv+S43IsHMa0X6qEtxgxgIIbXd7xKVuNb/Q
	wNujMZpWRmJiyTVefIbS7/eDEiwcXfxhr3zCdk2LAqziuWGgD+YNHMVNo1NGel2kdWYTSis+tTj
	Q+F4Z1jXL4Q1+L7zaHzt2KhgG+c8vwbSKP/iNrKy7Tz0wa+//b9goYw6EOzDRzSgqROeKpV3FId
	ETIze0LkXX2wFB/gN6tRLjD1UVUONLmpUIDeho0r8mdZEw5TnMjbNmJ2i2AMVnZjIjhnpJOvI6A
	4/Onnq+aF3rG48OGfqT+DUbiKFCDz65Ca4tThkFmBFgXZTE2RBAawkncw55r97ZCqsCBaucIqnK
	ateBTDVrZn8Q39QpR2OeGSSWNNB96gPiqp/FBBvyubt1b+dxvpJfz8nKrnVRgCYi5vSUfTe+lap
	v8jMAaZbwA6iWzacyPV9P3HbUKuwWEqyr0PqDUALEZkUez5WkG2PIwIrnpUaKhb8ydMri4BYK3M
	+KbIITOHKd7Y7lXDIqho+7ZK4b/TXD1MOwLcD/TlWfGGJpILoEm2elsdODg171q0eV8wf27/0Of
	+6L+zfr+4V5SB18Z7EJHeYQ=
X-Received: by 2002:a05:690e:c4f:b0:679:5d6b:a3d0 with SMTP id 956f58d0204a3-67a0e5cd260mr1515313d50.162.1792642648484;
        Wed, 21 Oct 2026 21:17:28 -0700 (PDT)
Received: from localhost.localdomain ([2600:1700:4577:1050:cde2:63f1:eb1b:b344])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b142cf9708sm10230967b3.4.2026.10.21.21.17.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 21:17:27 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org
Cc: corbet@lwn.net,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes report infra design (beyond page table accessed-bit milestone 2)
Date: Wed, 21 Oct 2026 21:17:24 -0700
Message-ID: <20261022041724.2712-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261017195747.89961-1-sj@kernel.org>
References: <20261017195747.89961-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6FAD2120005
X-Stat-Signature: 8sru5q7ys38renxujo7jti6dkxh7mpqo
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792642649-737616
X-HE-Meta: U2FsdGVkX1+sB5C+gqCo5G8o/vsX7sqih6YTFvCPs3tv0/bDDm7fyld25cv4nETtcxjWLzGj7burshX3ByuV2/5KrjCCBadEUa/Erh1F76zZHKZonG9Sg7oMK7pdLqK/9WWL3tdJrBco3R4RNMvb3PC6YQpbJe/npziv6LX+AHhh8a0NPhaML4O/owzX3nqG5lITsjRJmf5ez4U+vz5+Yqmi1ZTSdvXWQBN7SXaM89YxmfydYXJOdZE/bLUO/gaRkUpgYmg9N0Y4XZcf+goStPAnDeftQoYQHcML3h/aqO3DRNq3HGnV8H2h7xSjNxsV4RoOHWiOt9dzSIUhE4qLlozX5xZDvdubfzih5lDffCjwtG8wF61G5JPFOZpMvX6sw20Z4BjjrQ1ZtwJBnPDnVMlcQrps5/6evRG8axKXNGRZ+LsLkJhLrBChi8dI+Lleg1pBICZg6/5OgNXil6G6TWZb1Qj9OoWFLY2c9heGQLzBU45N+fa8b22idM5GkXT+85xzdDNLzXtRvEwrFONSbNEPy512yOdVQCxQRiZm3WsoXqLDJfPLHdZRN/Y9dJ3PpFDN4JkVJz4+lbZZRhsPQ3ilQC59DgHWJ+qFKdN5xpBxYqS4IOCvPbZ5wJBfdBGdX8jqyCfDdYCilRWfDRolNOOwTAuGcklMH3jKqd85bVRDpvlFz8F3HJoN9UJnoaNOvuPLF4oNDkyb7T2yKMxHtrNIT7lPoDLrRgqWwd+3k9HPZLe+rQdH/o2iFQBAoizoGLQvRKdruvkgHzrkG4m0H5txegknsnqm7+ZE56ybDGDMfvTqV3JCI1d6QkavvEjlQYr3cvtQQlWlBfdKetrVzhx1ZHRZ4mf2LlxO1T5X01WOcrmXjaVSmodTPqht4Sdt9ktJKWXvvneH94a+DUXFZhAZr1g3qSp3O+E19ZbCOFi+8bc8FHR8gNGiRqKfuZmYsT7TTGZcFI2BKd59F/L
 D5HnwDma
 qmtOj7URNHygaxwFQ2ziZT8DITmKP4y7bDAozakY+GC5y5b2ajZ6Ik63mmHlbVSlrQF2qxmNN3cwOV4qXrzilkTKQ3s18QehCCkLAHe0+GwXvwFdw6VQA76gLzlh4rhsbJ/dJoLjKeMparPM9/GtgrW6TjEaPO4tOLuD56qfD8X+ViRncJWRoynMzPjP8u+7RslBqzPUuBAFL3+UjO4Obma/hsMbKy3Arg4Lv3HDbGewZpfKDIVpr1Kr3kIoX7mzpYbTckPAo9EPvroijo10dlA2hUGS81H7nNIYg8N4KmuUZuDE7LXKDTZPmHFLB11OvPCiQePNerf5aVqb5pUldukylN9/WXh9rBRwQPtG6365/iw8i+o5idMeZvE9WWirsJbnG25Aoy4LKKvU/nnvB4mzjPmrd13rrzhLNlSAtnLYiifTa6pSGWv+hVT1RCUn3xRC/RFhZFFs60O5i/gCFIj29FJWvn5ozMTHb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

Thank you for sharing the design early.  Short version: the design makes
sense to me, with one main suggestion.  The first report type should use
the data address the PMU captures at sample time, rather than decode the
instruction later in kdamond.  The measurements behind it are in my
reply to your answer to sashiko.

On Sat, 17 Oct 2026 12:57:45 -0700 SJ Park <sj@kernel.org> wrote:

> Does the idea for perf CPU cycle sampling based access monitoring makes
> sense?

On AMD, yes, with precise_ip (cpu-cycles:p routes to IBS Op): its
memory-op samples carry a data address and load/store type.  On Intel,
even precise cycles samples (cycles:pp) carry no data address; PEBS
memory events do.  Decode from saved registers worked for one of two
test loops on Intel and for neither on AMD (details in the other reply),
hence the suggestion above.

> Does the design provides clear idea about how it can be extended for the
> future extensions that already scoped for milestone 3 (AMD IBS, Intel
> PEBS, Arm SPE)?

Yes, if the report has an address field with a validity bit and carries
the producing report-type (attr) id.  Then IBS, PEBS, Arm SPE (through
an adapter, since SPE uses the perf AUX buffer) and device-side
monitors all produce the same report, into the same queues and probes.

> For the foreseeable extensions (AMD IBS, Intel PEBS, Arm SPE), would the
> required change minimum and maintainable?

Yes, if staged.  The sample-filter matcher and its sysfs already exist
per context; attaching them per probe is the main change.  For example:

  M2.1  in-kernel only: damon_report_attrs(), the queue, region
        lookup, the perf producer; kunit, no new sysfs
  M2.2  your per-CPU write-only example, set up from user space:
        attr_reports files, per-filter report_queue,
        write/cpumask/threads probe filters
  M2.3  counters, a silence check (tracepoint/debugfs first), tuning
  M3    more producers: Arm SPE, device monitors

Implementation notes:

1. One sampler per CPU per attr, owned by attr_reports (as in your
   damon/next usage doc) and shared by all contexts.  IBS has one unit
   per CPU, so perf time-slices multiple events: on EPYC 9555P one
   ibs_op event got 67,140 samples; two on the same CPU got
   33,547 + 33,535.  On Intel the event also needs wakeup_events = 1,
   or an in-kernel handler sees only the last record of each
   large-PEBS batch.

2. A lockless queue, as your NOTE in damon_report_access() anticipates.
   Today's buffer is documented "May sleep" and uses mutex_trylock(),
   which interrupt context cannot use; its inclusive jiffy staleness
   check can also count one report in up to three intervals (HZ=250,
   5 ms interval).  A simple design: a per-CPU circular array with a
   write counter and a per-slot seqcount_t (using
   raw_write_seqcount_begin/end() for NMI safety), overwriting the
   oldest slot.  Readers never consume; each context keeps its
   last-seen write counter per CPU.  A nested writer (e.g. an NMI over
   a task-context write) drops its report and counts it.

3. Report fields: paddr, vaddr, size, time, cpu, tid, tgid, the
   producer's attr id, and flags (is_write, plus a validity bit per
   address, since 0 is a valid paddr).  Store global ids; translate
   namespaces at the filter.

4. Binary search over a sorted region snapshot (your todo in
   kdamond_apply_access_report()) beats a linear walk from about 2
   reports per interval for 1,000 regions (a model, to be measured).

5. Samplers can stop silently: in a report on the v4 thread [1], IBS
   Op samples stopped after about 10 minutes on a Ryzen 5 5600H, but
   not with the NMI watchdog enabled.  So count dropped reports and
   check for silence against an independent reference.  For tuning,
   step sample_period rather than use frequency mode, and do not raise
   perf_event_max_sample_rate: on an early DAMON PEBS prototype (Xeon
   6960P), perf cut it from 100000 to 10000 in about 20 seconds.

Three decisions would unblock M2.1:

  - The first report type: the PMU-captured address (suggested), or
    decode from saved registers in kdamond (your current plan).
  - Whether the report carries the producer's attr id (suggested: yes).
  - The queue: the per-CPU seqcount design in note 2 (suggested), or
    ftrace's ring buffer with one iterator per reader.

One question on the ABI: the usage document in your damon/next tree adds
a report_queue file under each probe filter.  Is it meant as "this
filter tests reports in queue N"?

Happy to write, review or test any piece: the queue with kunit, the
AMD/Intel perf producer, a decode-accuracy study on real workloads, or
runs on Xeon 6960P and EPYC 9555P.  Several exist in RFC v4 [2].

Thanks,
Ravi

[1] https://lore.kernel.org/r/20261017211613.16456-2-aethernet65535@gmail.com
[2] https://lore.kernel.org/r/20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com

