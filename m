Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71FCDCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 21:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B3A8E0013; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67AD98E0023; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588578E0013; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 408518E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA77386F92
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:47:44 +0000 (UTC)
X-FDA: 84005314848.30.EF778FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3A7401C000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:47:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5TPF4h1;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760651263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6Qn94BgJN1I/pTalflI57p+vF+omrb7YFJ3RXAzX7ec=;
	b=ksZ3N1MkumDDztK/nwxds5f+4noOmNbcHSyraAkRWX6DoA3q8GzwHOEIKVvFEu5TLH2JQK
	AdUos3S8ur57fPyZZfIvbVjFLUx7EqtETCqGCIeW4EHViEsLu6Ks98EsM3oqO5U+/3D4i8
	+181IMPxHsSVOqfiXeLueM2bZHj6zxg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5TPF4h1;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760651263; a=rsa-sha256;
	cv=none;
	b=btZHhULd0kizeREgghCpE4ioAnhDy5p1dJMAFXWyaXhldd8zf0jJEbKC/vJL0pN7VccYNG
	XTkl1+IJ+BADoUXAwHSwLerY4/Haj/IwaKM4qzuSjerA3FTCUR5apQe1fKLqJ8EOo/fH+7
	RgcGX6XDH1g6BrduhGHc1AVDAXFeJAM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F6556412B;
	Thu, 16 Oct 2025 21:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E558FC4CEF1;
	Thu, 16 Oct 2025 21:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760651262;
	bh=RINJiyTikiCSrabu3YKbaCnLP0ZEjScHL1FfEOY67sE=;
	h=From:To:Cc:Subject:Date:From;
	b=i5TPF4h1h+JX0pSFrm5nYS4UT9bNVvnMIafjwjgt2VpykD6J/qjRAzpm3l6gA44e1
	 8W1uHL0mZP8kN29CaJ2hG/SrG/HvqLyna66MAzK1j8763yRE157exXKJBDaRvtb1xD
	 meHmwHBkwhJUrsCHUhskq62xXQkphkpRs/5/1b5l1z6YB+p1MUsiPcgjpYXzdQDtaK
	 gtqo9Sb02SfKwCR3tzjQO3L0qVYwD8+uHeBVgEVvtQETYTihZXqGeDY0V4nUUawTNe
	 oEe2HozesoxP5FEnzoszPdrb9U3mW5JFmvkIV8aBddHYKGVBbmTM3zBJuGRw5a6tOt
	 mCgLTA/cpazBQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	bijan311@gmail.com,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/5] mm/damon: support pin-point targets removal
Date: Thu, 16 Oct 2025 14:47:27 -0700
Message-ID: <20251016214736.84286-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3A7401C000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: br7xomqq537b6msso5kmj9urx93jzchj
X-HE-Tag: 1760651263-144694
X-HE-Meta: U2FsdGVkX1+m1k9lhgBBek/sooqVWV454iRulvwneY7GShLU2WYZwksz/19X+lVo88ABKBgxc0jVw8RN5R8NGddD7TCVbyHmaf3heJuoDuV/wC6UHF/3KatkPH0KepjKMm44x/TYY3SSvgxPVGPOAC1fqeQI9mj2T2sm8pk4KsUMOMlkOBBFerCMu67DRKayIymaXqcuPOsbH8qjkpsqegoFFvEFJ1fcuPo1TN02u4HoAxSjF2RuBTreUwQnYPsFF20KjXcKpQobwUskt9lkQSBnun78/uMQfni4ghumfPJ5T6mpLzvio6TyGCT6WBQrNu97PKzv4QgU7Od6t1E8mkIy34JkQz1VBxcy/NJXOTrBtcA2HppQGHqZUgGXX+pdR0IiPgWOW3Lsavt7pz09WENt/70TxSMZV0xTAxfMJrwhaJ81Y3XTkCU65NXkSAZvSV3Ur5RRXuSzYdVKoWUYCA5IPoY5Uu7FaCben4T8uadrnQWaOUihHEfJSH38tKCKlAcprNTjaHsELcsM1xRz1JahGMbqpZJPMUhDSyoSbtNaT3ROAwqSV2KeCyuqu0vnt/ooUb4GuEEc332pSG838807UWD0PCoqLlbpqOQB12FguwMrmYCQQh2lvyHYrQT9gFjIvZmV9b3G8gCHrFL/tF95ZQ46JjzrohIK08a1U5zwFYkLrOeUDwY3lcUZIO94wgAXxgABGQawjZwwwbai/vbNDrIUPH1wL+veP6gDae2ZOwldT8RfVoKTAUkO/6lwbOWmyodSfN1NVc3WRHSqcHmN6ANZ/VScfVCMa90KuMsT2jaTQ8sNXPyPfyRXW5GyvPH1Qc3X8fKWAJ/hCc7QNe5CpFCNAJp4j7UGE4kisnbQDCXfiivOFQSZbb2PabRP3TLKvuiZJLDlQxC2ofgPaLgRwNfIXxhLYcnplYCqTtfAisDsF0bSTrpnK3Co9bZsZ/Nim7+PoWmDZApQKt4
 xphg4cqc
 2MQ/T0quYKVNtNYfXfgNMQctLi47663lLQSaIKbAQIEqQeYEHufYnwKmnE3cA2z/knRvkDY4HfvIf+oOHntQWSaJpHX9MWp+YI63ZEPzgMEkgevOH9+X6J3nxXDT7HUNfD/pbC0MI376IDzLYUqWoBIiH8FEXvlBUpCYcYNZWzFyAaKo3Vx8C0LaJ221FgXC7IHsrHrr/k5drVztPMf21zECX+XeEv0+XbkUpXItGcNK86TY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON maintains the targets in a list, and allows committing only and
entire list of targets having new parameters.  Targets having same index
on the lists are treated as matching source and destination targets.  If
an existing target cannot find a matching one in the sources list, the
target is removed.  This means that there is no way to remove only a
specific monitoring target in the middle of the current targets list.

Such pin-point targets removal is really needed in some use cases,
though.  Monitoring accesses to virtual address spaces of processes that
spawned from a same ancestor is one example.  If a process of the group
is terminated, the user may want to remove the matching DAMON target as
soon as possible, to save in-kernel memory usage for the unnecessary
target data.  The user may also want to do that without turning DAMON
off or removing unnecessary targets, to keep the current monitoring
results for other active processes.

Extend DAMON kernel API and sysfs ABI to support the pin-point removal
in the following way.  For API, add a new damon_target field, namely
'obsolete'.  If the field on parameters commit source target is set, it
means the matching destination target is obsolete.  Than the parameters
commit logic removes the destination target from the existing targets
list.  For sysfs ABI, add a new file under target directory, namely
'obsolete_target'.  It is connected with the 'obsolete' field of the
commit source targets, so internally using the new API.

Bijan Tabatabai (bijan311@gmail.com) has originally reported this issue,
and participated in this solution design on a GitHub issue [1] for DAMON
user-space tool.

SeongJae Park (5):
  mm/damon/core: add damon_target->obsolete for pin-point removal
  mm/damon/sysfs: test commit input against realistic destination
  mm/damon/sysfs: implement obsolete_target file
  Docs/admin-guide/mm/damon/usage: document obsolete_target file
  Docs/ABI/damon: document obsolete_target sysfs file

 .../ABI/testing/sysfs-kernel-mm-damon         |  7 +++
 Documentation/admin-guide/mm/damon/usage.rst  | 13 +++--
 include/linux/damon.h                         |  6 +++
 mm/damon/core.c                               | 10 +++-
 mm/damon/sysfs.c                              | 51 ++++++++++++++++++-
 5 files changed, 82 insertions(+), 5 deletions(-)


base-commit: f82c3c7358c244b2ba14dadcae822c8d36cf2163
-- 
2.47.3

