Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85345CAC5B8
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 18:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73DC78E0003; Sun,  5 Oct 2025 14:15:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EEE48E0002; Sun,  5 Oct 2025 14:15:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6046B8E0003; Sun,  5 Oct 2025 14:15:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E10C8E0002
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 14:15:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE749C03A2
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 18:15:41 +0000 (UTC)
X-FDA: 83964863682.16.3760891
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2A80710000A
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 18:15:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IWpo0jZc;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759688140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xOoKtLCmhJG/enemNk3CN3iR4Uqa2yTLGAgx3wBZOlA=;
	b=788bzlt9TpI0oy+8debOUkZXR2Ts9DDldycSBx3KPVJSV71iHLOpGlYZc5wvpGwR/vJXO2
	/dlWUTibDcIbFnA2/UgRiu+DQ4hzyZLrUdyI+GHilQ0C2q7kMKFGk9jRTNW/rMoQ1BuF/+
	i4eSMqnNaTNj0duMs2GrrFTO9Ve4Xpw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IWpo0jZc;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759688140; a=rsa-sha256;
	cv=none;
	b=KiGlbyjMCZimdJLllvmCgnwfParX6mY1Qg9oijEL+sWJW2ZVNXvZKp5/wtAchNsxg1Sats
	CKdnMsWpSZnf8uAKfaFmdvATwvlgss4Kg3uHpWE0jgBUjps9hpM5Mt7+S6nU0VxQ3RAyPG
	VLDX6gkZ7fY2zDTz1LRleqkaj4QWfB4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 31709602D3;
	Sun,  5 Oct 2025 18:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6622C4CEF4;
	Sun,  5 Oct 2025 18:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759688138;
	bh=WrGBOIZjlmquZN7ZYu+iwJ9XEfXTRM1X6w/j88Z/5W8=;
	h=Date:From:To:Cc:Subject:From;
	b=IWpo0jZc/QIF8KOLnFDnHf2LxTHDktEADz4tGQc5ySBtwLUgB/xproCBlAO/TWM3V
	 kDxZw0PPe5+JOuH1uDmsq32y/4jKvFv/gpW5S8sgWJEyAw64StzmXjA5/RX10BVBBF
	 YDA8+K8aWh/Tv1Ems/TXnv4f7qX7jMGH7ZWmiCXE=
Date: Sun, 5 Oct 2025 11:15:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional MM updates for 6.18-rc1
Message-Id: <20251005111538.3996dae46662e46054d46528@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2A80710000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qncqnnaq18418tgwz3um4515ofykubqa
X-HE-Tag: 1759688140-966369
X-HE-Meta: U2FsdGVkX19KliiBzbbIps7Ak+lNg/XSRxaOEj9ARYg30j1oQ9UAilFewVezNsWoS8huM8HKqHWvByliy4fWmw6/VIEg92t0FoZhHQ1MNV7Nigz7Pac5b/57vsjWWabfq96G4Mm/L5ls0YBVi6hBeiM1VLzejLE4hqwBhotCHm0Zxjs0LGAZrNLDGgxNEQApFqAk5M8r/jYd0cSAbY3qD+SFax70Si7Fgv7Rd/gXvHdRXLB5ZGnPJLs5Ap+eVb4UfuOYOPSTV1ONj/LvLoiUskMKW6VBaUr9qEBJmmqk5Cwbu9xmObn0FJCdCaYSc2yu0oHIX0ciNM4JeiX+2lI5h25h+mKEol/f0+qOGF0QY2T9Lsfm+gHH0+bajmVL39MP5/bWf65WivvIYuBLCPdO0JWB6RYXzS3++MvigLrIYe80g4C+6O6JHXgKas2wYA+5iI3DVlwiGAGHCK6P5650Q9KG5cKOOWzx3srqj56/MD/r6AgnB80dMVbOYrDoqAhcFfklIoEL3e/gsGcamiIkWZnzOyWT9HjYWqS8P3nV0yMOog9cqT+vEbOBMBZr7JIqzhzub+BN6xoCMBh2x90mD3ID/Km/cfx9VHinUhwJo+4M3ZwR/EnsUzWgkIlCzvAK11FsrTdsA2oS0uWmYQx4hi0Iw2VGTlPepbKShWNnbno1zQMHWyC6LdvHY3s1nZinePhR2GznbIiiTA8ZhpSeRAhrnezg84MUdsUJSr9yzkJV7NCL5gk/6mN6w102goevKYL3Oc99MZjw4xaTKLmqsJ85NZbhSfNHy1ioySrNniN9QJ+az4r0i4rDRxfcnKGGpF5hnp6nnLIM7sbKkrhfwIiWyWZDCt4Bhppbo+TPTQsE+kZwHj5tBdpUT7qvbIAuMZcQV01zK/dnx1TqXqZEFrmSKdEETpHmZbu8g5IZbmAH+5nnsM/lCpV5SnGFLzDMGH3wzm66QMRL4HDFKjf
 YsIerexV
 cIXZsL/J2OCHD9dOh27H39/Jss78NTb+2E8lWhXlq87qj5qWE4jYeeyvcEbjFWkMp2TT/XIqepDzZJV3V5BucjFW/V1Lbl+jPceKWaXfspWz3j/c0va0w24DLbSaVgW54yR3T9iy+9NjQL4B/5hnAb8CSI7Feao0sL98ooJPMwr1Y48jSDIqIHC+p1XPTcvrE3WBPb6FpJqhyaAJ6KuiXiEXiKHoQuQOMR9CwEzP8PK4i6RWbKEn/73AAOp40aY67DvqnAOToy4Segwo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this small and final batch of MM updates for the
6.18-rc development cycle.

No conflicts are seen or anticipated.

Thanks.


The following changes since commit 1367da7eb875d01102d2ed18654b24d261ff5393:

  mm: swap: check for stable address space before operating on the VMA (2025-09-28 11:51:34 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-10-03-16-49

for you to fetch changes up to c14bdcc9f274620492aba7d920cc2641440cf1ba:

  mm/khugepaged: use KMEM_CACHE() (2025-10-03 16:42:44 -0700)

----------------------------------------------------------------
Only two patch series in this pull request:

- The 3 patch series "mm/memory_hotplug: fixup crash during uevent
  handling" from Hannes Reinecke which fixes a race which was causing udev
  to trigger a crash in the memory hotplug code.

- The 2 patch series "mm_slot: following fixup for usage of
  mm_slot_entry()" from Wei Yang adds some touchups to the just-merged
  mm_slot changes.

----------------------------------------------------------------
Anshuman Khandual (1):
      Documentation/mm: drop pxx_mkdevmap() descriptions from page table helpers

Hannes Reinecke (3):
      drivers/base/memory: add node id parameter to add_memory_block()
      mm/memory_hotplug: activate node before adding new memory blocks
      drivers/base: move memory_block_add_nid() into the caller

Lance Yang (1):
      mm: clean up is_guard_pte_marker()

Wei Yang (2):
      mm/ksm: cleanup mm_slot_entry() invocation
      mm/khugepaged: use KMEM_CACHE()

 Documentation/mm/arch_pgtable_helpers.rst |  6 ----
 drivers/base/memory.c                     | 53 ++++++++++++++-----------------
 drivers/base/node.c                       | 10 +++---
 include/linux/memory.h                    |  5 ++-
 mm/khugepaged.c                           |  5 +--
 mm/ksm.c                                  | 27 ++++++++--------
 mm/madvise.c                              |  4 +--
 mm/memory_hotplug.c                       | 32 ++++++++++---------
 8 files changed, 63 insertions(+), 79 deletions(-)



