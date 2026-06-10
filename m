Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D85CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 23:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8202D6B0005; Wed, 10 Jun 2026 19:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0D86B0088; Wed, 10 Jun 2026 19:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6C66B008C; Wed, 10 Jun 2026 19:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8186B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:04:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE4621647EE
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:04:13 +0000 (UTC)
X-FDA: 84865533186.01.43533ED
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf26.hostedemail.com (Postfix) with ESMTP id 730D2140007
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:04:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yqpu3h3f;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781132652;
	b=WNBMDIVvXzBt22+hCV+5a1P9JtJ7tkJD2Kav6KboJ7HedHQ+E1U/qP887dPfSPXJlq/9Ci
	+3FgxUVOSrUl5rLGqeD02vXEvoQR+r2u2KsO8ekZTj15W/5DnKFHDnBWyI18T8oaKRjsYO
	4skfLlnW8OcQvkSO1DGN7vPOk7cY/sA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yqpu3h3f;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781132652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=TjVafRrztl61GTgtjfrSlsw8Ad8ni/rrqPZ3bM0ENp8=;
	b=1FfZohnL3uLzCDKrrzyaVd8K/T0/uK9XX7/WpzSsbv63MN7dZX9Um0PFNqBwabf5BjF91a
	mgyBrekzKhwvp2a7ekafokQegCsqunSJaZu6GhGDzEubyvebVmQHjkfeNQ2Eofg1Homenb
	IpL27npXBjQqttZh0PdV6pcN5wzZR5w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781132652; x=1812668652;
  h=subject:to:cc:from:date:message-id;
  bh=2WEt2ZvPmO8EdZFzEBlx7T5A1KmdG5Y87ekuzMLuv9U=;
  b=Yqpu3h3ferNyCf3KjcaayrK9MG1eFAKFAvR3zWrZoaFUPT4UL+9Ma6ZN
   VI10mP3Reo2V87NPb6pBctzA1KkCBgsIgDwY+Ve4MiTHTjkp2GDzEWLuZ
   5zYZkwaJ4e83H7i6I5Y8Tfxd/tslIj5dkNKmZdJeITZiqxhmDCi5bOd5E
   1cU3EQtQ4vNDOCnbHuyV39gikR84mEh1q3f0bG5LyGeytmpPUJJOgpxlB
   G3UnqkTCox1vp5pWDRVczIYxjL2FCO6tbNbSzVEtdX9V+Vud3b8CC3+Uw
   Bxe9MEx+WVrgwbU2pCLSQRcPajZfY8sA4LwOnWaGArO0YVl81DWmoVcOd
   g==;
X-CSE-ConnectionGUID: T7mk+5lQR+2EXIxKAg3wkg==
X-CSE-MsgGUID: 5lME8UT6Q9i+0RP/7iGZMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="104603419"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="104603419"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 16:04:11 -0700
X-CSE-ConnectionGUID: 7TgrP9meTPiiDW9rjfO8ZQ==
X-CSE-MsgGUID: UQIYMZYcQPegPMuXE9rW3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="251409765"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa005.fm.intel.com with ESMTP; 10 Jun 2026 16:04:09 -0700
Subject: [PATCH v2 0/5] mm: Unconditional per-VMA locks and cleanups
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, Arve Hjønnevåg <arve@android.com>, Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Todd Kjos <tkjos@android.com>, Vlastimil Babka <vbabka@kernel.org>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 10 Jun 2026 16:04:09 -0700
Message-Id: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
X-Rspamd-Queue-Id: 730D2140007
X-Stat-Signature: dow4d5k6gt75p3faqt4en7jmbk6u65ja
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781132651-141715
X-HE-Meta: U2FsdGVkX1/7GXwh52TrP4v73b226bgETmITJck9ofxjkGtvfkDtQmoL86LCIuaeVYIzkf9VqDLzm/5J6KzGwVzQEE21ABCi+8BH2xPZ8f49+gataZeeDVP3FAPm+cb3LuosQnxYkLcdoeWdC2lTxMVLgP2nbcOU93ELWcrn3l9AWM7kM+Y+7DX7lBbyzqStlZi/Dhh9jBMx01xGCUXUniItlMoUSIeB6aMjMlZhyCNU2IA2h2TH/EmOQHdNTjwoYp6i4a2OsPBuPAn4dzx2CzY3wTGrr1/0HkjivJxK7pLnbfb+VoEGzehjUTU7JSpEy/EktYAN18xyanPSlhTEXXma+ttlveB1bmD0m8PI+g5TQ8kh1vUaRdd2fcXQ/8Bbdunt9MTXaaF01kNvoqgAqxALRMIsDOUzi9uvxw0jgBqDECoViF8MH2PRdvk1nLxY/ozOGcLWoRlxLj0/9g7ORQ8mc1bzAogEDNzd1avD3r2RigZlDzRQLPHRApj7vpwLly44xXpsPzcxdJGWUlwRTPnltPq3TFqAX14tIK1WidE/GugnoDVe2DouHsdM6oouqsbQXX7yNLLtm1XkHzJfCEBdmPgTiopDfGzRud2ROzw+D89cN+zv5Qv0tDkVtWokV7H5o6WWJWNwBfV9YhY65L+BnJhn6PLPYGSC1/2nAm8SXLnRF2SwDD1k3kU4u6IvOEHtR1E3mMW6g3uB9RSqNr5SUXa2NSeL6o7Y8tS7xLv4qwylEFZKdvHtM20+3vKfs1TYxSzO5o3+ZEToAWnAagVqmYOjeHL2uNRFwtMy5PvUj0hp0TZ9YVQj1rzyHq9Q6d+1xdHrz2zGXPRKFR7Jzw0Gd376PA0maLrW/nG0XfQ0Z39qKzHg7xkXYHVVNt/oAC3SRz3Ou60OZHDzkJqXmZscFTpDdY/SUYRCJppXl94XjQUI4L4TFD1d9qjOBIvUQ3IJWzDwLmzsHXkAMXM
 TeW2wd5C
 F7jrPvgksfYCeD4OwIpLEha2V0/VzcF/K5FFYcmqFX1RGvmUPjtBYDvExhk9SiQ8c1J7je2+6fX4Q5CA1Htlt0V9zkWfNZrMxXDAxwDQoOlDFz3RZX4CoNKh0iQHesHBdzF3eE15tTb8jPjUVMFJe2AhVKsp7SwOFfdWwKEwd8TpdZC3A9nqtArS7jn7f5YzjViH4jwG1eg/02ikmbpCnsHhotMinGtkmV2373E1sN3NL7T1eu4aBSnmpLb2vU0m5+XUARC89GuDNqDnxs57ZhUIhOixdl/jDjgoExIEeCQy0xI0mRy7dOBmnXnlFQ5g8I1oBi90aNwbKtw11aKyc44lopGsLNBB/BPMPTZOevct4Hpawsgz+UhR7Au5+EcpQpwHCmcnOxhQ3o5sI8KJ16WxIum245M5HpGYY2rkBpProfAOOawkgenMcL3nVk9Y8z4XLooXONrUW3ZVs3JZh65tPzVrS19ImqgqPB+kir3b8Q3kf+atK3vdgA0/JfoQIWVG1o8M0O0lx1/GgtPguWI5PzrhJw13aTtfdRMTksVmtU7z7CUXkpGqvma+PJ/iJ1sA/yhqm628k0g5QOFg0QIuASaO2sP1fYHrY1KYUlB/8x1bKv3RMxhPvASzr8yn7a3rk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tl;dr: Make per-VMA locks available in all configs. Simplify some
of the per-VMA lock users now that they can rely on them being
always available.

Binder and networking folks: Your code is the target of the cleanups.
I'm cc'ing you now on v2 because there's emerging consensus on the mm
side that the approach here is sane. I'm not quite sure how this pile
would get merged, but ack/review tags would be appreciated if this
looks good to you.

Longer version:

When working on some x86 shadow stack code, it was a real pain to
avoid causing recursive locking problems with mmap_lock. One way
to avoid those was to avoid mmap_lock and use per-VMA locks instead.
They are great, but they are not available in all configs which
makes them unusable in generic code, or if you want to completely
avoid mmap_lock.

Make per-VMA locks available in all configs. Right now, they are
only available on select architectures when SMP and MMU are enabled.
But all of the primitives that per-VMA locks are built on (RCU, maple
trees, refcounts) work just fine without SMP or MMU.

The only real downside is that making VMAs a wee bit bigger on !MMU
and !SMP builds.

The upside is much cleaner code, lower complexity and less #ifdeffery.

Clean up a binder VMA locking site now that it can rely on per-VMA
locks.

Building on top of universally-available per-VMA locks, introduce a
new helper. Since the new API does not require callers to have a
fallback to mmap_lock, it's much easier to use. Callers can
potentially replace this very common kernel idiom:

	mmap_read_lock(mm);
	vma = vma_lookup()
	// fiddle with vma
	mmap_read_unlock(mm);

with:

	vma = vma_start_read_unlocked(mm, address);
	// fiddle with vma
	vma_end_read(vma);

Which avoids mmap_lock entirely in the fast path.

Use that new API for another binder site and one in the TCP code.

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org

Changes from v1:
 * Better naming and non-loopy, simpler implementation.
   Thanks Suren and Lorenzo!
 * Cc networking and binder folks
 * Add tags. Thanks reviewers!
 * Drop x86 shadow stack changes

 arch/arm/Kconfig                       |    1 
 arch/arm64/Kconfig                     |    1 
 arch/loongarch/Kconfig                 |    1 
 arch/powerpc/platforms/powernv/Kconfig |    1 
 arch/powerpc/platforms/pseries/Kconfig |    1 
 arch/riscv/Kconfig                     |    1 
 arch/s390/Kconfig                      |    1 
 arch/x86/Kconfig                       |    2 -
 drivers/android/binder_alloc.c         |   43 ++++++++-----------------
 fs/proc/internal.h                     |    2 -
 fs/proc/task_mmu.c                     |   51 ------------------------------
 include/linux/mm.h                     |   12 -------
 include/linux/mm_types.h               |    7 ----
 include/linux/mmap_lock.h              |   51 +-----------------------------
 kernel/bpf/task_iter.c                 |    5 ---
 kernel/fork.c                          |    2 -
 mm/Kconfig                             |   13 -------
 mm/Kconfig.debug                       |    1 
 mm/debug.c                             |    4 --
 mm/init-mm.c                           |    2 -
 mm/memory.c                            |    2 -
 mm/mmap_lock.c                         |   51 ++++++++++++++++--------------
 mm/pagewalk.c                          |    2 -
 mm/rmap.c                              |    2 -
 mm/userfaultfd.c                       |   55 ---------------------------------
 net/ipv4/tcp.c                         |   31 +++++-------------
 rust/kernel/mm.rs                      |    7 ----
 tools/testing/vma/include/dup.h        |    4 --
 tools/testing/vma/vma_internal.h       |    1 
 29 files changed, 54 insertions(+), 303 deletions(-)

