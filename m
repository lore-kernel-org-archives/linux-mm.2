Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD5ACCD187
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 22:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8010B8E002C; Fri, 10 Oct 2025 18:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1758E0002; Fri, 10 Oct 2025 18:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C7068E002C; Fri, 10 Oct 2025 18:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD468E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:03:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDC521404D6
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 22:03:27 +0000 (UTC)
X-FDA: 83983581654.14.0DC4D76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4EFD24000F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 22:03:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="VbcUIB/A";
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760133806; a=rsa-sha256;
	cv=none;
	b=WuaXGkHtvb24HPqqrcmkGk9YKiGngImUynBAs0m0aWk5HkHjWuuY527VOTL7AQvUY266i5
	Rx4ElLWUdq2nbzWJLNrhuOtGeHcbyWldPw6JZbk8PJVH/TN7VuHu8ImkniQijWJg3An/ee
	Czqasp22/Tz4RKBABWUjcvHH/U3SfLE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="VbcUIB/A";
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760133806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5loAoUzYY9wDAcYlvIK7yyGfz7BsaQ/PkqUdzdkPENs=;
	b=1+LFv3iUKHICxUi5Q+RVtRMCFYCDZG4MqvyYjtgWG5uuVAoj7qn6adoF4q8Czp6p/LlBGH
	Zur4DTCmVnW1Gfpoz3KuRydgHNWFCzu8qhzpbUjVJEn3ezeM8Tuu2GvYMrCcis18oxfD9C
	q/yHmJFwrrn67LY6FpyNraz/lW4Rrb8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B505D60316;
	Fri, 10 Oct 2025 22:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA65C4CEF1;
	Fri, 10 Oct 2025 22:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760133805;
	bh=evq7KJC3SkQwvHwE0wNIuv0UzWRVw71S/m1wT8vCslA=;
	h=Date:From:To:Cc:Subject:From;
	b=VbcUIB/Ac0WEQXNEFE8FPrdF0VjzbYDFX6speK0X2FO8k/4gyPhFiqr0Fgi8k66c8
	 ACmLYVaPonWC3CFNTM+UR6eaYEW64seNRay9ue65Nnt7ewLqTTseBgQwiX+dZ07Wnw
	 Z7tC9JREF/mpeeuuGqfid8UrGt5X3ixovjk1vzkA=
Date: Fri, 10 Oct 2025 15:03:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.18-rc1
Message-Id: <20251010150323.2d73ad0f6fa1c49fbb7d9870@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: kf3kyg4a5owza7j3thb4zsfkq8gs9x8r
X-Rspamd-Queue-Id: 4EFD24000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1760133806-470240
X-HE-Meta: U2FsdGVkX1/1B8faMfcmZeDXX3f0+Dl51JOx4IRNBcozWIH/QZCMCCumiMfAvyE4A3KMeCl6R5+Gm8J5exBnRCNxHPLfeTPKRxHoeTSNdBUXo/Sa8gFiD0krAlER4u6ecKUUnC6akj6QM+/S8XIfXIzn6Tjxh1jJVWZmblEeFem6R5wLlF/Rw81ccDIOxbV/btc4nvku5AgxB43bfkISGD9t817ioO3r9/PQPbJft8VZEvJneei4kPA1aPeAVMNSpdcbfnCts457SkhreUgEgBBHy+f3whfQes7j9rbkn9Yr0tKFT93aPGLAl2EoSxgo2sTu1JDUwhetf1T6zKw4S2YNs+q1xelQRCMMhfuwLmyXE2bi74F3r3fiQWEO1KJWOSKm+n8nh6l4/n0UhebCC51HKCTqt+zUseTiBpOtJK3OQkexgVYXWS4appP+wGjGIx7yvQwHoEU8cSoXxb9+Ogcg0/dfSxmwjq+iJ6pCarxSUs6Ndv5B1MB/SSddY6OUdEvadiAefepo1vk9iUxqZznuzDPKHJJUqgC18magG6WOLpc9DyIBxMQP4oWgGpS0Gxktzos3Zze2J3VhO7GDkPVhZWpEXgkTy+n9WTn4AlVr81NaLB14fKvSsleAs1yv52HJEb0L5dPS1yxNmory80ZIAb25ZaiJhBgJALs65QpcJmona5J+e26BgVyshUrKjOi2AABs8/175O4lofC1A9WhsJr44zC2jppCZEvj5JDB2FAmoZEbW/XwHzbTJH3ZpOyTGi43zR7k3SATd22CMuFpFBBRwMaQoS5EW4RFi54H5SdWUvFttfC/ewjn2F7ieHZ6uXUOD1iz7DOAiPlN0UJjchhc7QyC7Dv2AdRYmSF6IiKMTZOJj+qxSDIdwOuSxYttoqmmAseAhXuE5UufapAibZvOpGaJKP8VrOCJcJUUlyTBxwTEDPlmHxwGtpZNV4XYxRB6nOoGW9tjpTP
 8zQ21lrZ
 Rpb8/C03ANNsMKIZJi9dWvK8iiYHDv58zzCiKrGz96B6vh4GPC6QWm5fJyqs3/Kg0DCYHjqn5a6WbB3T8d/QRk5pkp9atr5uxPkHlaHoL3DSPnp7azicijEmaklbTTg9q0zvq+VNPffgiSzN8gCnZpAeuQNflBp5WXC4MrBt6BH/NUW5ONODcI99m91Qrgc7Fo4kZhatDiA9M0CdV+uSu56ZccnVr+HIm1QoWC19aKvF3eqassKlRsTHoWATZjzcm+mBnXdBFlsDTl72E5nuF0twpqP+Qo3mZzJ/eDhCn5KYyjUheIfy23hWMMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.



The following changes since commit 7a405dbb0f036f8d1713ab9e7df0cd3137987b07:

  Merge tag 'mm-stable-2025-10-03-16-49' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2025-10-05 12:11:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-10-10-15-00

for you to fetch changes up to f52ce0ea90c83a28904c7cc203a70e6434adfecb:

  mm: hugetlb: avoid soft lockup when mprotect to large memory area (2025-10-07 14:01:12 -0700)

----------------------------------------------------------------
7 hotfixes.  All 7 are cc:stable and all 7 are for MM.

All singletons, please see the changelogs for details.

----------------------------------------------------------------
Jakub Acs (1):
      mm/ksm: fix flag-dropping behavior in ksm_madvise

Lance Yang (2):
      mm/thp: fix MTE tag mismatch when replacing zero-filled subpages
      mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage

Ryan Roberts (1):
      fsnotify: pass correct offset to fsnotify_mmap_perm()

SeongJae Park (1):
      mm/damon/vaddr: do not repeat pte_offset_map_lock() until success

Shakeel Butt (1):
      memcg: skip cgroup_file_notify if spinning is not allowed

Yang Shi (1):
      mm: hugetlb: avoid soft lockup when mprotect to large memory area

 include/linux/memcontrol.h      | 26 +++++++++++++++++++-------
 include/linux/mm.h              |  2 +-
 mm/damon/vaddr.c                |  8 ++------
 mm/huge_memory.c                | 15 +++------------
 mm/hugetlb.c                    |  2 ++
 mm/memcontrol.c                 |  7 ++++---
 mm/migrate.c                    | 23 +++++++++++------------
 mm/util.c                       |  3 ++-
 rust/bindings/bindings_helper.h |  1 +
 9 files changed, 45 insertions(+), 42 deletions(-)


