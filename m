Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A407CA5FC4
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 18:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DB846B008C; Wed, 30 Sep 2026 14:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18CEA6B0092; Wed, 30 Sep 2026 14:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2BA6B0093; Wed, 30 Sep 2026 14:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8F526B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:47:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E8171A01B6
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 18:47:32 +0000 (UTC)
X-FDA: 85271311944.08.EB40473
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A36D01C0006
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 18:47:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ADxd7IJg;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790794050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yD+kiY0HoTfxu66erBXAF33xLs4HT8xVVKYchh0t2N0=;
	b=o4lrfUYQ90x60ymqRGsQdjrfflMpCHAgsWdmLoWPiRoC7OreC4PCLtKP4xYNsyGZfZQlpt
	sfqnNeIle6GQWoPhQoqWgrj86G1QI/oup4kLnfA09ryte2i5yksIugx8w5esL+ZullGhSS
	83qawtqvRF79vJtG/NeJjhoRnySOpdw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ADxd7IJg;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790794050;
	b=M36w9wQtnd0qcVpn7+Os36i46M577yRcUbQqphDrC6uH+Q7te59YATsvj/KyxI/LNrHT9G
	RIsPCo6cOl9uWlDN0OPZeYbvY3HFF0TzDv4Hkb2AAcGZxvReR4bX46z3ThNpjz6fAOe38g
	TQWiLd6cX0Xp78MRlCdoGqCFT81TQK0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73CEB601EF;
	Wed, 30 Sep 2026 18:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451E61F00898;
	Wed, 30 Sep 2026 18:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790794049;
	bh=yD+kiY0HoTfxu66erBXAF33xLs4HT8xVVKYchh0t2N0=;
	h=From:Subject:Date:To:Cc;
	b=ADxd7IJgoc5YI2gZqwnPdRQnBd2GhhLLKqu6VNKYetbeqpEDWnafR09CiVwl391ok
	 2LeVaPvqivS45qptH6cB0DzCJJ1a7T1RBohe3a+1cWt3ibs9edPEFRi9N/ENoJiGUY
	 0937Bi5vVgx6udRaN2VRTvP5SjL2CG/9SRQIM+fiikTi9xDNVKiEA9ip4rnc9u3Dob
	 Ut8eZ+texE13OAr/+PpznWs2ms1IBz7M7DcYcjOL75fknGaybDkDx90nnaCvDi/EdI
	 TOuY377A23mWLOeE/tvXlRyVLvS2cyUaOIY0ewOMo5wLg9iaRsHOhDVXxETFpnm4Jv
	 bA0s5K0ofMMbw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v2 0/2] mm/mremap: fix two issues with MREMAP_DONTUNMAP
Date: Wed, 30 Sep 2026 19:47:08 +0100
Message-Id: <20260930-fix-dontunmap-partial-self-merge-v2-0-f388985a0f0a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/5WNQQ6CMBBFr0Jm7ZjS2AquvIdhUWQKE7ElUyQaw
 t2t3MDl+/n//RUSCVOCS7GC0MKJY8igDwXcBxd6Qu4yg1baqlor9PzGLob5FZ5uwsnJzG7ERKP
 HJ0nun0+urtqyM84ayJpJKG/2i1uTeeA0R/nsj0v5S/+QLyUqtN63xlhf+aq9PkgCjccoPTTbt
 n0BbkGHcdEAAAA=
X-Change-ID: 20260920-fix-dontunmap-partial-self-merge-74a98b1d5a65
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
 Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2742; i=ljs@kernel.org;
 h=from:subject:message-id; bh=5wUqWsURO4rs1oMkv+4uI03AHJwb7y6msO+KHQvbPDo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLL2RtqK7lFwSchj92X9fXVG8fZ7pv8ltG7Mmi5RsUwih
 dGmt42ro5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABNhf87wV/z9xNtfvWfpcBy4
 viP38oq84i3y9x2iPWK9tUwfuJbrTmH4p2Vtfq3eeUL1iW8s/EXfSx7Je4vqZX71Srp0/dL7x5x
 V/AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A36D01C0006
X-Rspam-User: 
X-Stat-Signature: pgs8wpszdmdxzuwioqsnb6ha55x815fz
X-HE-Tag: 1790794050-533755
X-HE-Meta: U2FsdGVkX19fo5t0Nc2qmCHDygYqcglu45WyGtH6b1CEM4AxNoZWrJhEWH68oVXEDvfB1qgAxdCddHmCSdFFgPcVefDJ6MJNXeVM+rz4aNN0UUj7pJ8di4X7hxjSLFfBAFnsBWQ1aObUCS+G4sbRO1YSqwhje/Xk6541o1lJbeGs+yDRYvm0DMT+BZFS+Z+hwD8JvaVx7J1nEfqAc4lWba2TTPuW8VPFCBNp+n2wXyv77YU4j6aYUHIWd0KQVpYAx41g6qa9qmnM2av2lRJ/NMFltfGCnAyosDzcgt2Ffs9PRzZanm1CmQwv60zmjZFXCglMi6Oo1FzzB/hAkg4BnkXgRxfXH2dIBTUBLYByMSPUSK4WW7JN+BmM0mhm4uQ3qXKIU0nMTfm08QygFUMz42+Jo8pGrbIZEfaTPPXukl0B8i5lzqcBRlDAXNzAzjCroGbhorf9NwwFprGthSkiJgfMTnNbq/h3fXbodxjVu2k9gFOej85/ZbgNg9f9JSLes4ILbW7vpGWGPsJ/zEJVWrYlIRVWPJWrSWTPyF8fILw1Ge+WpC4Ut2aggO1e1gCcfzGE26InSsF0My8oQvaQHkat0pOmOyYHf1tNP4Ls0R6GANwJH2yiaT1xGFxUM5t8NCy9i6v07ynL3/xIwt3nVsUrUPtsj1bd4ke5vRGZ8T9IPwIkGMgDCdV0iU8oh4zKWY+ugWjewowaEgbXIzvSsXjrJij5eHqdwjCcbJRNglLfCBVnwgkwnnJNQNvE7HyfCNCEQrGc6I4Whq0hCjCAb21K/sVElb2xaoEl1YOd9SlrG80jVLwLwE2WGuolZNpHn3gWQEkczcnTEVSeOY9HVWb7GiiqILOrmu4RBHVC0ncvm5Uja4ytxoOtGsBSgchhrPACbkXFVaoQi5B9tFq40wF6TohbISU/SV7FaZMqkmekwNzcvx9PC3t9VwRyoXu1gKpuv2uF0sKuLWdiWa+
 Zlt34ikR
 mSsrCjnXvdzu6LMSsWshgZPuhIB5m/aBwQVKxoqUsR9j66ppnuaBRg2YEHC4fRflXzWMRUWytCZeDhvU+lcTQGIML6nGa3E/+GI3hliB1THDnQp+LGsORuqqUGkGGW7VR2+Xn4MQ35ypHvChpmWqbm1nIj8S363w0LulEz7VlWPL0o2ZYQaHHeWg+klYrBv0e2IFiGsXs9GyJsFUhfkDwbx2muz9Rtz7mI4SFtLgk4F1f87Hg1/26RJHv4k4BP8pGvv2Xx4duTTlcfiMmnREUqBS8PGkcaGmRKlbY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
operations that keep the original VMA in place.

Historically this has led to a lot of bugs where non-obvious interactions
occur between existing mremap() operations and the original VMA.

Commit 397432cab17b ("mm/mremap: account mm->locked_vm correctly for
MREMAP_DONTUNMAP") fixed an accidentally introduced bug around
mm->locked_vm accounting, but this wasn't the only issue.

And thus history repeats itself, as it turns out that mm->locked_vm
accounting is broken by MREMAP_DONTUNMAP yet again by two further cases,
and has been broken ever since the feature was introduced.

Both relate to the fact that VMA_LOCKED_BIT is cleared on the source
VMA (it has to be as all page tables are moved):

1. If an unfaulted VMA_LOCKONFAULT_BIT anonymous VMA self-merges it
   clears the VMA_LOCKED_BIT flag and permanently leaks mm->locked_vm
   pages.

2. If a partial mremap() is performed on a locked VMA there is a leak equal
   to the number of pages not copied.

(Both for MREMAP_DONTUNMAP operations only)

Both issues can be fixed by treating the source range as distinct from the
destination range, which is the definition of what MREMAP_DONTUNMAP does so
is appropriate.

In case 1, simply disallow the self-merge, keeping adjacent source and
destination VMAs distinct.

In case 2, split the source range ahead of time if the VMA is mlock()'d, so
accounting is always correct.

Both changes were tested locally and confirmed to fix the issues.

For the purposes of a backport, the fixes are kept distinct, a follow-up
series can add self-tests.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
* Added tags (thanks everybody!)
* Updated 2/2 to avoid splitting the VMA if the VMA was not mlock()'d. It
  is only meaningful and necessary to perform the split in this case. This
  also fixes the proc_maps_race selftests that broke, as reported by
  Anirudh.

v1:
https://lore.kernel.org/r/20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org

---
Lorenzo Stoakes (ARM) (2):
      mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge
      mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP

 mm/mremap.c                   | 70 ++++++++++++++++++++++++++++++++-----------
 mm/vma.c                      | 21 +++++++++++--
 mm/vma.h                      |  7 ++++-
 tools/testing/vma/tests/vma.c | 10 +++----
 4 files changed, 81 insertions(+), 27 deletions(-)
---
base-commit: a3d0117e02bfa1c3bb6c50e7afe42bbecdbb3459
change-id: 20260920-fix-dontunmap-partial-self-merge-74a98b1d5a65

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


