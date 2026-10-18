Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41C6ECCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 19:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1386B0098; Sun, 18 Oct 2026 15:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50926B0099; Sun, 18 Oct 2026 15:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67756B009B; Sun, 18 Oct 2026 15:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 778236B0098
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 15:58:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C764B40212
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:58:04 +0000 (UTC)
X-FDA: 85336808088.15.FB0E38D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1CB5DC0002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:58:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A9hcXXIO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792353483;
	b=xOahtPFXLGnXS8H7pfQnYAF3c+1Y//jdJNZBwpbFXGZC3BIktOYv9qp4wJuR4dmimz8oek
	kG7y2/LNNPtcy1vyHlZ0Db78xgvbh6s0PC8V4/oY04rAMDFl+G82pNiRes+p2gL1wSF5bx
	PNVPaXn2JvOjMmZhYeqhVuXBJQ0Keog=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A9hcXXIO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792353483;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIOucBP32EXAvdFmVl9jGmz89VxayFbvcT9hhk5+fL8=;
	b=KeOHUaTBakch1onzhjwmtIZF+j1XQ0Jo3hkBdZ849lC5iWcm7SJ/unRoQfSt5LYbtNms1C
	IF2ix+uiaY4ylOJfB1rUtTJ6TOJSSBIJCrpTQ6JJ+LS1ksJQgHwHj6POJ5FSaZV9ZTLjiK
	ERRdzCTJN61EGvBlbsQv5KznkgfP/+0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20E1840A2F;
	Sun, 18 Oct 2026 19:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7671F000C4;
	Sun, 18 Oct 2026 19:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792353482;
	bh=AIOucBP32EXAvdFmVl9jGmz89VxayFbvcT9hhk5+fL8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A9hcXXIOPAqR1GxiAtBM2jlUUcTs39/OiWT8IquTXexRzR3ymYoeH/+spx2HABzRv
	 LvpkDUfyZcdQ9DuVW1MOAKUMA05PyAXOzr1njtEIq4nSl4+g5jkhAF0U+Ya9/GkfiQ
	 SHGL5PaRYeWaa/7lEHQUBGnb0MabnIPjTQN2fy/JHacWtKCV4Y69f6F8ErDFc5yVm5
	 1DCQG7yXg3ys0rB3c6gaTHRKEk8YW5HZjF5GQzeszPASD1ECnZwSTCP2RXjMValyhp
	 10r37YsWRvn/TC0lniRIrZof/8ldtXNdmpviaEA2nsF2tLPLfilcDvEvFIkuzycUOh
	 v6GyxwyMH4Y7g==
Message-ID: <sashiko-outbox-176355@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes
 report infra design (beyond page table accessed-bit milestone 2)
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Jonathan Corbet" <corbet@lwn.net>, "Randy Dunlap" <rdunlap@infradead.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261017195747.89961-1-sj@kernel.org>
References: <20261017195747.89961-1-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 18 Oct 2026 19:58:01 +0000
X-Rspamd-Queue-Id: 1CB5DC0002
X-Stat-Signature: z5jfzsu86gp5cqoas68fsqfsco9uktei
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792353482-98437
X-HE-Meta: U2FsdGVkX18CRywHRthqtqHMCIO0nlpnaaXLmDz/MNa0RThqsgm0Pfl4Iey54xNhy006d1czSOqgk3wB3Rwy3IAXUJKOPdgd8P/eTcU6ToWgvUlbOlzH7/WltQQ4/XQ3berOF48QBAbdyRpR6zdYG3wn5zZmPrGhtZjI0B5tDtqDLyJmg4HiDVWinc4mbUhCCmAm8dP70o5kq9C2lDNOXdklkN/4xrvfYcYOoKs2RBloyisPBAJZRPkV9G3BKWZL15susnqJ7cVAtHTrs9cJTaJRAFlEeqQg9VQMgjQK/C0X/l9jJkAqpAHv7Wl0QVfHVZdlZgAT4Kj0hmNQeMspK5yB0ztFdyMqUajQZH9gYH/P1/cooba5Ubw2QuOuCrGNTU4XxvSaI0vLj8rq57NTsBym7GuTo8sdwA+jb0xrO9hsfVi2RjpnTzcJUnVyD1Zxf7GG15RbgKhGaIOwC1gKmX0otm0HoI4eJIJ/FOaC2Hs6QSFVchPtMxxKOqkF4MW/QBqaVTCHt7meEfI+zSBqakcdZ7ENWtdTZQ5VsZFe5QiQkw3YL39L0tkQZbT/f4aEhmcRuD7WaxmVyxRsaE45wOrG/eCOmUXLiD1YKNspPTqgfPY+YCi9qArGxiTXZyTcSh1U+3STCgOecSpjOc9XEYCRXL07zivDiUfqGvII0gl94K7vku3v5XU/GXQvbF/13z5FaX1WvpSv3PIe2uFUjJOIr9u/lFMbfP+63tIrfrJ4jZqIMS2js+9FqdHQNem4fIpc63hPkjIX6FAfUVx8sdesUEL2CumnqmWE44nKnoeYRFyfyuX3UwG0pxETbRg6RFMvlDgfq6WUzzRksOG/K2ZUq0XcRsPkDzP2Sr5pOvqAvGWmOKYGcdxsoyoIqTVljZ3DZ3qraMeFg7pZo3JxSkdXdMNlo9h1qVGDLHoM37Ee3Igv1dkAoBNOtDmSWmIIRMbAvDZCIv1Vp/sw47o
 tqVpsoOr
 PAxbi2FGbH+Bh/7a4EJClwPdMB96dtVt+esAAZr1fo1DpTNgJTw9tsF9oSiDFbb/j2T7t2VjYdf+f/+stp9rn8eXjOPUTL4+E8ucIPl9W8CoBctga4s3a4iZGZRG8WQA386vWf/2d1v5yczDl5rnAS00R8E6l1kaONehaM5KHv3QIVp3ML7aXL4Ud84G2qodnEfuLGQ67zm30H955RCkOZrJMvOMBWEruNAUrwgoFpoWaaEm6LSo9tASLFZc01++fTD+s8a7NZAtJtnbdNly+gy94TjfJCuQLnHQLiUUnu55A/1J541A7bqbjZv5YXP2InlptXo+AZgDvqreazuTdM+wLboyP7Y1OOWAHgef41maXWMSjTnzp4dWqpn8a4OdfVZzAt1sDp8w26NvTlMaJDebRtCfmnuJeFSqhv5AiOy7XnoP6FseyGb6EVuem4rSo3y0RM2CSSFeWPG5hIpl+FSVMEzHsaCPZBFIYXNpSSIbeR1SHuSeRqVakwfS5BEnthgfFJo3sd3FiW5b75IQw3s3ucFVp+O2HRIDrfFxww8H+PuTM8k4+Z4vLEviV9ZEfeR+3MdEUEgq9zzhd1m7Ve1XNUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Docs/mm/damon: CPU cycle instruction sampling lacks target memor=
y address
--

commit a164f9ff38c8cd1963db3e0c7ea062dbc93135a3
Author: SJ Park <sj@kernel.org>

Docs/mm/damon/design: document data attributes report infra design (beyond =
page table accessed-bit milestone 2)

This patch documents the high-level design for DAMON's data attributes
reporting infrastructure, including the damon_report_attrs() API and an
example use case for per-CPU write-only monitoring using perf CPU cycles
sampling.

> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/d=
esign.rst
> index a465e34bb1d9c..1e699e3f8a496 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -433,6 +433,50 @@ monitoring.
>  Refer to the :ref:`admin guide <damon_usage_sysfs_probes>` to know how u=
sers
>  can use the mode.
> =20
> +Data Attributes Reporting
> +~~~~~~~~~~~~~~~~~~~~~~~~~

[ ... ]

> +For example, per-CPUs write-only monitoring can be configured using this
> +infrastructure like below.
> +
> +The user sets a report buffer and enable CPU instruction sampling report=
 for
> +the buffer.  DAMON will enable perf event counter for CPU cycles samplin=
g.  The
> +sampling callback will save the sampling time CPU instruction and the id=
 of the
> +CPU that was executing it, into the DAMON report buffer, using
> +damon_report_attrs().  DAMON can automatically adjust the perf event sam=
pling
> +frequency to minimize old report drops due to the buffer size limit.
> +
> +The user further sets a DAMON probe.  The probe hits for a given DAMON r=
egion
> +if a store instruction for a memory in the region that was executed from=
 a
> +given CPUs group exists in the report buffer.  As a result, the probe hit
> +counts represent relative frequency of writes from a given CPUs group to=
 a
> +given memory region.

[Severity: Medium]
In the Data Attributes Reporting section of Documentation/mm/damon/design.r=
st,
how can the DAMON probe determine whether a sampled store instruction targe=
ted
a given DAMON memory region if the callback only saves the CPU instruction =
and
CPU ID from a generic CPU cycles counter?

A sampled instruction (or instruction pointer) only encodes the opcode and
register operands, not the effective virtual or physical data address being
written. Saving only the instruction and executing CPU ID via
damon_report_attrs() does not appear to provide the target memory address
needed to match against a DAMON region when the probe inspects the buffer.

Even if the perf overflow callback attempted to resolve the target data
address at NMI time, generic CPU cycle counter interrupts
(PERF_COUNT_HW_CPU_CYCLES) are non-precise on out-of-order CPUs and suffer
from skid. At NMI time, regs->ip typically points to a subsequent instructi=
on
rather than the instruction that caused the overflow, and the register valu=
es
in struct pt_regs may already have been modified.

Furthermore, without hardware data-address sampling features (such as Intel
PEBS, AMD IBS, or Arm SPE populating perf_sample_data->addr or phys_addr,
which are scoped for Milestone 3), resolving the effective address from a r=
aw
instruction would require fetching instruction bytes in NMI context, running
an architecture-specific instruction decoder and address-calculation emulat=
or,
and translating virtual addresses to physical addresses for paddr monitorin=
g.

How is the target memory address intended to be obtained and matched to DAM=
ON
regions in Milestone 2 with generic CPU cycle sampling?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017195747.8996=
1-1-sj@kernel.org?part=3D1

