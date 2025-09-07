Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34E4FCA1013
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 06:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 267318E0003; Sun,  7 Sep 2025 02:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23E698E0001; Sun,  7 Sep 2025 02:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B468E0003; Sun,  7 Sep 2025 02:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 086A38E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 02:04:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8982311ABAA
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 06:04:36 +0000 (UTC)
X-FDA: 83861414952.28.5FB0282
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2A95718000A
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 06:04:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=haXlZ207;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757225075; a=rsa-sha256;
	cv=none;
	b=fildpSqcI6bW5QMoyOwUa3BdepAM3Q7DtChyXqbzi0v9pW2eqgrp1LMQfwlfDqPUqTD05n
	BmTPp5Qppe0Nxjh864QsGWGh5upe+EhV263nw0pHW5yesIZpmrPgNeweMBmaerkm9FE63X
	eFLbJPe4iZ5rzhBoawzsOR+ZEWWbVXU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=haXlZ207;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757225075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aIyksWTmF+WPRQfDWNQ3wfYCg86aJi793lKO/e/geg0=;
	b=3ia+kRphx+ZkcLfpvN7mvNTkAisu1iXNdZpMjjF051tT9R5JQAzErsj0Zut1Olhxoa27XL
	3pz2LyfKfjr+y/IOgIYTp8fQvtgV7OCe87M0TpA71GzN2yfyv5i8slYRjq+ldSY3cKmJcy
	C0dF3qIrrkuESbe0OdW9OPJ1JWITTPM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF97E43DA0;
	Sun,  7 Sep 2025 06:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF20C4CEF0;
	Sun,  7 Sep 2025 06:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757225073;
	bh=Y+6NT7qGhfiYpIQPVV4I0mtOFqnghk5yu59oPQEuT2I=;
	h=From:To:Cc:Subject:Date:From;
	b=haXlZ207G0qpRnmByYvNsmw0JNfqiAaOWam3kbsqOPErDLMXsEshkfvubab9jT1Iv
	 1EsfHRPcCfBb/kX57nh1sb/nXMBWWizrNPR7BXJzeyM0I8e34ZFgkDk6enH9CUzUH/
	 +8wV7owr1jTRIULdJU43VRMFrD41BIvVyBy6ERgjo+Kq4S1SFixIAFNd/1jIqhIzHX
	 KbzPnzGz59GmbarsOi70dgjNMdY7iNUJFudyE/xeA+O3VzuUiys0LA7mLpL0fdPCsc
	 zm3wlMU+hpMhSzkpHMt17fH0Jg2VoOQ/vbEkTjX/AdjbkATpaQ5QChPFzvFzvZG+qN
	 RS7tHHD2QgbTg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] kho: add support for preserving vmalloc allocations
Date: Sun,  7 Sep 2025 09:04:26 +0300
Message-ID: <20250907060426.2177717-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2A95718000A
X-Stat-Signature: ii7m171o58rskn4pqtkdxywknz5afrky
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757225074-581812
X-HE-Meta: U2FsdGVkX1/owdQmUgVpZZYlFxuJXqhlN+KdCrrzjecP3H7ihhntBffbr088uQthJye1TY53eyMPjL3o38Q8mEoi4RprXDH0Se8XXfzOCjYSrR9TFlB6+3bKiHxNZ96Hq7D9KAj7TftPVFO8RBkPMHNh93k0ekRM+PC0kAvXYaqPPrWvJgH4php8QDPTEsnOFToyrU3gY2bN0Ndn8ApcqNeLe+v7zyx2Iu3gT4BFYxFuBoB8LGe+W1obidCtEhtVlKICr6RCPRII9jm1e/rmXSdgwDzzGnABcu+XQQ8czi7WCIrqR3li8R2Bj6cr9uramktDtqendrQSISTn1e2KmRbxcTuqK5v3asFCj74HCWhx+fcvkRFx5TUbY9yJhM/960fBGTpYErpPe3HgFxugJNgDl84PG10pcgNiHhA4yZn8Wps7zai34ofnN1rKQsUSb6GHadG5GLt/tq796llhYZmFG+n62Q6+tIkH15fxmLTj5ZeOvsKjxI7mEacdEUBqatXQJHPWTYF+8C37ZFjQfINXC5DMT+vNdDuPgPQ5790J0O06328EJm1S2ZgzlZTqhw2zRce0qRC2KJLPVD/UHRg4ELZr+WvVLhp/yQMSJ0uia6Pfomq0+YKTHCjIPvT/VoZellX497oU0M0ciOZPHKTAyBlu6856jdUhCL1dMIia2J6Hi1g07UhsqGvMku738Oc9I3kgU05wswR6VBDNkTOz+2P51RRfzWNBm6wBT62Zrlc5lrvYpKtos+urMYYnFR2X4Y2EcAfItLlAvLhZw+ZN2TqB0Uay53FmxLFccQf8b3PmZ0SslPY8pn0CCSydFKP5wfQo0G/X+smSmf8ZFcPrp+bQ+KN12fNRZJEo9ZuL2UpEq+W3yS524gphgChj/tYLtE7LLBw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

Following the discussion about preservation of memfd with LUO [1] these
patches add support for preserving vmalloc allocations.

Any KHO uses case presumes that there's a data structure that lists
physical addresses of preserved folios (and potentially some additional
metadata). Allowing vmalloc preservations with KHO allows scalable
preservation of such data structures.

For instance, instead of allocating array describing preserved folios in
the fdt, memfd preservation can use vmalloc:

        preserved_folios = vmalloc_array(nr_folios, sizeof(*preserved_folios));
        memfd_luo_preserve_folios(preserved_folios, folios, nr_folios);
        kho_preserve_vmalloc(preserved_folios, &folios_info);

[1] https://lore.kernel.org/all/20250807014442.3829950-30-pasha.tatashin@soleen.com

v3 changes:
* rebase on mm-unstable

v2: https://lore.kernel.org/all/20250905131302.3595582-1-rppt@kernel.org
* support preservation of vmalloc backed by large pages
* add check for supported vmalloc flags and preserve the flags to be
  able to identify incompatible preservations
* don't use kho_preserve_phys()
* add kernel-doc

v1: https://lore.kernel.org/all/20250903063018.3346652-1-rppt@kernel.org

Mike Rapoport (Microsoft) (2):
  kho: add support for preserving vmalloc allocations
  lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt

 include/linux/kexec_handover.h |  12 ++
 kernel/kexec_handover.c        | 200 +++++++++++++++++++++++++++++++++
 lib/test_kho.c                 |  41 +++++--
 3 files changed, 241 insertions(+), 12 deletions(-)


base-commit: b024763926d2726978dff6588b81877d000159c1
-- 
2.50.1


