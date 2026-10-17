Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD2C4CCF2C9
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 19:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225D46B008C; Sat, 17 Oct 2026 15:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6C86B0092; Sat, 17 Oct 2026 15:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED4D6B0095; Sat, 17 Oct 2026 15:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA4156B008C
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:57:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B05AC0339
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:57:59 +0000 (UTC)
X-FDA: 85333179078.13.19DEB89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 96F3B40006
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:57:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OAT9mExM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792267077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nOAWu4jgToYD6PgI6zHtuU24uPZsxbnLY8EkUxNpZ08=;
	b=TxvuiMB+szVYggXMSF4dM43HCgtkoiUO1c9ucoesEMEJZmpKasUOrD3DfmaXWuhTg3/MOn
	DClLyB8+1vrfH/SGGsw+UmjlFVp1aHQwkaAhFzWwSL53kwD8VSxtIFGTDs6P9Y/MgdIbpX
	nDnnSQ6TFBEg/DSvgCkCVFemJLC/S6w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OAT9mExM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792267077;
	b=6b86DVsDMvuyGAWpdRFKL7mP/ZMH0qIYBSvtegHJPFQJvUnUBybj4ChGgQnRtbYZXtLfJM
	WuJQXNEttgZYg6MbQase67aEAp76t73uKZSWM95Wzr6WDJ3tWoisW73Aekyey3utRD76V+
	6u3DsDedqbliLH3Kul3BzmbDBfdr1cU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBC0F60AB6;
	Sat, 17 Oct 2026 19:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478AC1F000C4;
	Sat, 17 Oct 2026 19:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792267076;
	bh=nOAWu4jgToYD6PgI6zHtuU24uPZsxbnLY8EkUxNpZ08=;
	h=From:To:Cc:Subject:Date;
	b=OAT9mExMcAsH9A03H+uqHOHGRrErNT9JglY8WLHBEOMAsVM7+9hyfYOyFuCPP6rA3
	 XI94TuJWLQNDPYo3WPzZhD9y3jvHCRSI7yJGMa5tF8Qf+CAAD4WkdQISyuaI5dVvUF
	 cNH4pqDWMW98r8IUx0G9NLBp6UJ3OWeULU7qGqGWZJsIGLJfLUZWRvRHcoUnYQJTvC
	 bZ6nWok9uPD48Mo0LkqskZE0VFtDTSbbR4bOjePimVqZL9FyrKIR/Cq4O1GWRVxNyn
	 3mYsPzvO/tbP7NEytc/CDuWFgUIeAXMUf4/d8smoKL2+9+zjLOsyCq/RL+TenDWN9y
	 ytlYDWDs3w5Vw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v0] Docs/mm/damon/design: document data attributes report infra design (beyond page table accessed-bit milestone 2)
Date: Sat, 17 Oct 2026 12:57:45 -0700
Message-ID: <20261017195747.89961-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 96F3B40006
X-Stat-Signature: g1uxjb5kafgm8epee9qci6e8sb58de9w
X-Rspam-User: 
X-HE-Tag: 1792267077-520265
X-HE-Meta: U2FsdGVkX18y1JQnFyvXSl+h6XRkeA+ZCkdmjVZ5/ccP2ZfAdztXdcdUPUXFGLJP5is8gwyWr6HCVDG2PgCtWrV8uSlri+bw8SoHQQ7Zb7YxMXxr8qPemndU5hS7A16ZgEctFCujShCegyin/Olu0HEKMwGnssz1XX+KaEG2DAu+Me+a3tR6529KasIpRn840KFDDhrFuBsYWCFW++/mHLoqkMqwWYo/Zxtn35V+ljUG4tWtOEEiDFIzxXg6csjno3PuG7tOgHH7SQrqY3zKIRIYzBGTHEO0A/Ea0j4ZeGPf450rS6GOirf1QzG5+CTjtybjL5ZzYRU7m61eWz+5bWmPyIeo34QvgRbtrFljgHS/+Fjc35gqA3y6IrC7NrCWkCGkfdCVgTtZDqan2Pg5VMJh6g6GPc5YGU4LEsjDvyFug1tzozy37ZZydDCWdad+XlDxviP6wAKp9HrgmT0NelnDIKxCJMEYI7/D3t4Cdm7eVIID1UwIW5nkfc1OIsDr2NoMl2VmmGFRKevsW+d5pvyettkJwh/+sBxLC48/7OG2jdS5kVQaqO3atQR86xBFhACvha5kMGGVPQOm+jRukOIoKLOHB6Ltz50fBDRLSmMib1jncjjV/+cHcxmO4VWt+Mn+odALxUxq4RaR5TJ4EJm3rtGTDFPCWDB9S70b81yeUmtdCq9GBSOBq1COFUijfGC+N0Q/mFwX3/FXghv3Jw6ztWBxbM8mpEZt9Ou31SWMdgMnvWnBiJTPXBiiU9ehVj/SnTA82x+m4la2AjofcT3QgV5N3jwxDOBM9Z2sQSL6TMPo6kpoQ0lLI46zE6BKn/ECxjTGeNef1n2AyGXkZsHP4eugf6/wxTdZs/HKjc12uV+65NzPh18lJuHefY6UUmIo4KYVaLlIrn4GR5Q4WAE3IRGM+SjU1g5/LKE2j+ajn8nClJkHxbfuRZn5Bv/pciwUuwYTm0KOBY6xbCe
 Csnzggv9
 FZgj4qrSdc3LLCiu6By3BPPa0yCtjozmCeemKtybhwwGUmHb1cPI8gkAcG0aU2M9YHC/EVZlNacwkW+CvAg9uZ3iJK9uau9vRVNXhOML83moRB+VNMPJwDgIzylD4Jqn/Plt3GHSBSG/gyyOClPrcwUQdm5GV3MY+8ZffHECtkm/YIITR9nlqyKaFRWwAs8wH82pAEtj8YU4qJB/dIpkufPhiD+jienN+o8UO2Wtm9H5DTLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The "beyond page table accessed-bit DAMON extension" project [1]
milestone 2 is for building the basic infrastructure for continued
extension.  After starting it, I studied perf event little and found a
few demons in details.  I therefore spent time on high level design.  As
it started looks like making sense to me, I'd like to share the humble
design first and get feedback from more eyeballs.

Add a blueprint of the milestone 2 as a high level design document.
Describe the API and ABI of data attribute report infrastructure, and an
example use case of it for per-CPUs write-only monitoring.  The API and
ABI will later be extended for more data attributes reporters utilizing
AMD IBS, Intel PEBS, Arm SPEs like h/w features and any possible
DAMON-external reporter kernel components.

Request for comments
====================

This is an RFC for high level design discussion, so no implementation is
provided.  Comments I want to receive include but not limited to below.

Does the idea for perf CPU cycle sampling based access monitoring makes
sense?

Does the design provides clear idea about how it can be extended for the
future extensions that already scoped for milestone 3 (AMD IBS, Intel
PEBS, Arm SPE)?

For the foreseeable extensions (AMD IBS, Intel PEBS, Arm SPE), would the
required change minimum and maintainable?

Next steps
==========

I will start implementing the infrastructure and perf CPU cycle sampling
based access monitoring as described in this patch.  It will go through
the normal development process.  Delivery of it will be the completion
of the milestone 2.  As set on the initial roadmap [1], ETA of the
delivery is LSFMMBPF'27.  No delay is expected so far.

[1] https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 44 +++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index a465e34bb1d9c..1e699e3f8a496 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -433,6 +433,50 @@ monitoring.
 Refer to the :ref:`admin guide <damon_usage_sysfs_probes>` to know how users
 can use the mode.
 
+Data Attributes Reporting
+~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Infrastructure for receiving attribute information from DAMON-external kernel
+components.
+
+Because DAMON is not hooked in every place but runs in its own worker thread,
+it cannot retrieve some types of data attribute information by itself.  Many of
+those are available to DAMON-external kernel components such as perf event
+callbacks and page fault handler.  For such cases, DAMON provides attributes
+reporting infrastructure.  Using its API, any kernel components can report
+their finding to DAMON.
+
+The API for doing the report is a function, damon_report_attrs().  The function
+receives the attribute information and saves it in DAMON's internal buffer.
+The function is safe to be called in any context including NMI.  The internal
+buffer has a fixed size and keeps only latest reports of the size.  Because one
+buffer size doesn't fit all, multiple report buffers of different size and
+rules can be generated and shared by multiple reporters.  DAMON provides API
+for such management of report buffers.  damon_report_attrs() can specify into
+which buffer the report should be saved.  DAMON user interface (ABI) for doing
+the buffer setup, and enable/disable reports of supported types is also
+supported.
+
+The data attribute probe supports the reports.  The probes can be configured to
+hit for a given memory region depending on the existence of specific types of
+reports that associated with the memory region in given report buffers.
+
+For example, per-CPUs write-only monitoring can be configured using this
+infrastructure like below.
+
+The user sets a report buffer and enable CPU instruction sampling report for
+the buffer.  DAMON will enable perf event counter for CPU cycles sampling.  The
+sampling callback will save the sampling time CPU instruction and the id of the
+CPU that was executing it, into the DAMON report buffer, using
+damon_report_attrs().  DAMON can automatically adjust the perf event sampling
+frequency to minimize old report drops due to the buffer size limit.
+
+The user further sets a DAMON probe.  The probe hits for a given DAMON region
+if a store instruction for a memory in the region that was executed from a
+given CPUs group exists in the report buffer.  As a result, the probe hit
+counts represent relative frequency of writes from a given CPUs group to a
+given memory region.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 

base-commit: 366c6418699768dba5826d412700a29d562ca039
-- 
2.47.3

