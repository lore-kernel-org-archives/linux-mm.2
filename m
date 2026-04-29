Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D8A1FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37D9E6B0005; Wed, 29 Apr 2026 14:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E5B6B0088; Wed, 29 Apr 2026 14:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B166B008A; Wed, 29 Apr 2026 14:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 122A56B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:20:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3523C1911
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:19:59 +0000 (UTC)
X-FDA: 84712407318.09.E086314
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf14.hostedemail.com (Postfix) with ESMTP id DE2B1100012
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:19:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eUBfhAG4;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777486797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=gDkj9o5vGrmRCHZFNtYM8o7taWmOLEoUgLj6u7Pr6NA=;
	b=jqYqZMPPPSYGftQ/w6iJDYRTTZHUOolU10pssmU6KsD7dF5V5VPzgj2QgFJOhHdRFMiwRq
	fpmRFKhHL82FSD6e9qw7KK/pz/tZ5Bl4KhcfWh7JefWATTlBVebbUR+SCycUutwLN1eUgu
	dhvwhPeF+GUBOIivBOm3XSCIaCy2xS8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eUBfhAG4;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777486797; a=rsa-sha256;
	cv=none;
	b=YQaKYXB/2MPKGNRXNQ37DTkf+xFpm5jASxBTp/4ysi21f1X0rAtBL0rNOrucOKotm2t5n0
	fQvMxZT0ZFG3sdQ287yZ1Yfu/OXJiUKO7yyG3fIYghtyasTUnxC9xPLA018m5t5VaKQUym
	IOvUaVxicKMj4jR914fjiQ/TUJpofYQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777486797; x=1809022797;
  h=subject:to:cc:from:date:message-id;
  bh=FRX2vTZUe64OsKYGu7BHSC2xvcn/OhBeOoXDiuqiV40=;
  b=eUBfhAG4tpEFRiydssDk7UKPNH/94m1iLOmf9bUj05JmZ1s40oTzZLGl
   UuQ1uFIS4QMpL3AqLwIDvP9ZqfiQqfdAQYkPYAQ5x9YQnqT7SqUfBmSm/
   loI+VtUAdVj5oz6LV91aL48dmbTdEshbygurRoFnwLXq1kQT2DpMGtFgE
   iKkWLEW4/mJDEOvRh9v+aO5iUn0mUmMT3ktyyYKy04SrknQV3Z/jlKGDq
   +R6UWfcHjiz6Deb0yV3PTbKGIyx368gN1H/GVMBdlHelCVaVGQiIXcTax
   KzNZZ+19rZkgt0SRXX9EmaFCktF4mTmrfrVEwLzYHcAhXINqT2CAlvvMn
   w==;
X-CSE-ConnectionGUID: EYeE7j14TCatlGtksPaHQQ==
X-CSE-MsgGUID: RpjOi1ihQJaEFPmHYLzFmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="95990086"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="95990086"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:19:55 -0700
X-CSE-ConnectionGUID: 4E88rhIvQyqOMtF10HSDlA==
X-CSE-MsgGUID: WI2E2GjrTc6nlh8D7ggCYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="239336379"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa005.fm.intel.com with ESMTP; 29 Apr 2026 11:19:54 -0700
Subject: [PATCH 0/6] mm: Make per-VMA locks available in all builds
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 29 Apr 2026 11:19:54 -0700
Message-Id: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
X-Stat-Signature: j6iryt1rg99y11144uqty7r6zijupkd3
X-Rspamd-Queue-Id: DE2B1100012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777486796-177512
X-HE-Meta: U2FsdGVkX1/RXYclSw8UgJKtyDzdILWDAD9k5wl8uJ4ofOe+4bmRdit3tyZRKnsrleZLPAIJGPEwxRL2K2WcpfRpNMb9FrZSCvbdwdDWp797BIqrFOfQjCic7YfMAr6DjiqjHmpRbvODfj7VDlSmZUQuaCgaKRUk3LnXaR7xL/rudBxzgVgiiGZORKIPIyRMMN1znBQ5TVrOeLnbDvB8eLCn4Y+0i5H339hvdnYo1kokQBlzSet9YISVBY4l7NErU8exuxQt5dNG07mt4Az9Wg7gHG+GkFOFf36dNwxIQIP3nUVVRLxhlrFYA9r1ChvodI5EtLU0oLMXXpxDwSIIMnO4LUYrNXjcRXVoOHqBjc6XeEOIYUlR43r9OOklRA8lpvCGGiv2ZznbMKYyE1Xivb6PrYNzSiU8AYybeilFUhg7kFEcF6zefUGqAqdFvPe9zfkQau+odOUab3+GVX+EK+5EHqGbxG91l7J9EG61NAK36GtBRU79dPLGjfOmS2GTDN8dmPkDjg44wAA8h/KF68ZdWrSsTMus1OJEgTsxp3+6ukOKkGPWNJECmk9vjSwED7YQ/HdFazTAwiRqmANM3eNdDLvgVQqElUjU7roXKUgzEaCpINdidK6S0nXxcBgoDQNX2PjC3CSHrlUcIECS9u5iF4s+SpaE1YM8zytI0s4lwMqs952fUDzED4UVVgWSrW4Etc5NThnM4e/v2OvPqTMyUrqmEixv9WPPsJnFBWZIiK7wQ6W2YXZsU0/jm4qyTS2YTEBknHrIGYGdxPvC0VOndylSHsmOvb+88O8vj1K7EYieeHBZNJfIdaKp697KSygjRB12Y32W45Vkqj+DWcVXpfE9aVuB34iYRviDHRD9n0rsVrXA3WpQ4PmJL+zN7ur9T39NNr5hfay/KsVk9dBkZGThsA+34lcNOdCYUf9DwNACm6ZNcgZuqKJhuXSQpDVFlUr+wFEDN/gJMcM
 oS6NUTk/
 cU5rW4/qL6dFkY4J6iawkxICHf2V5KPiogqTiEluscUGRld6fNo8KpPw0oVi/5deHxK4wHPSK7/QjRh/8HRtSdJTz+VGfIdnaUV6QoGHKls3ctSYG5NKtszNLjFf6wWQt6KbfhFjXmfiXbpHiW03LTmxagl0eKhxzvj72GxO0BS7IaVruVYK2ZACVlIXj9dMPQJbeTPWfXdv8orT6pl3dkaJZwqIAw2zyH5R39YNm9erez5hGCx1zBkKPjJOJBnB8dIGJRupJBDr767LrdBdinu10WzLlmVdwCgSb+BFcKh4b0102zgRMBOMxkG918AaFG1ndYkr351eIVajVxet3mREjnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tl;dr: I hope I'm not missing something big here. The basic
observastion here is that forcing code to account for per-VMA lock
failure adds a lot of complexity. This series theorizes that with a
some Kconfig changes and a new helper, many callers can avoid writing
code that falls back to mmap_lock.

--

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

Their only real downside is that they make VMAs a wee bit bigger
on !MMU and !SMP builds.

The upside is much cleaner code, lower complexity and less #ifdeffery.

Building on top of universally-available per-VMA locks, introduce a
new helper. Since the new API does not require callers to have a
fallback to mmap_lock, it's much easier to use. Callers could
potentially replace this very common kernel idiom:

	mmap_read_lock(mm);
	vma = vma_lookup()
	// fiddle with vma
	mmap_read_unlock(mm);

with:

	vma = lock_vma_under_rcu_wait(mm, address);
	// fiddle with vma
	vma_end_read(vma);

Which avoids mmap_lock entirely in the fast path.

Things I think needs more discussion:
 * The new helper has a horrible name. Suggestions are very welcome.
 * I'm not very confident that this approach completely avoids the
   deadlock issues that arise from touching userspace while holding
   mm-related locks.
 * Can the helper avoid the goto, maybe by taking the VMA refcount
   while holding mmap_lock?
 * mm_struct and vm_area_struct "bloat"

I've included a couple patches where I think the new helper really
makes the code nicer.

I'm keeping the cc list on the short side for now because I'm not
actually proposing that we go ahead and do the ipv4 changes, for
example.

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org

 arch/arm/Kconfig                       |    1 
 arch/arm64/Kconfig                     |    1 
 arch/loongarch/Kconfig                 |    1 
 arch/powerpc/platforms/powernv/Kconfig |    1 
 arch/powerpc/platforms/pseries/Kconfig |    1 
 arch/riscv/Kconfig                     |    1 
 arch/s390/Kconfig                      |    1 
 arch/x86/Kconfig                       |    2 -
 arch/x86/kernel/shstk.c                |   47 +++++++++++-------------------
 drivers/android/binder_alloc.c         |   39 ++++++-------------------
 fs/proc/internal.h                     |    2 -
 fs/proc/task_mmu.c                     |   51 ---------------------------------
 include/linux/mm.h                     |   12 -------
 include/linux/mm_types.h               |    7 ----
 include/linux/mmap_lock.h              |   50 +-------------------------------
 kernel/fork.c                          |    2 -
 mm/Kconfig                             |   13 --------
 mm/mmap_lock.c                         |   45 +++++++++++++++++++++++++++--
 net/ipv4/tcp.c                         |   31 +++++---------------
 19 files changed, 82 insertions(+), 226 deletions(-)

