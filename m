Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C8AE937FC
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 19:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF37B6B0088; Sun, 12 Apr 2026 15:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9DB26B0089; Sun, 12 Apr 2026 15:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65746B0092; Sun, 12 Apr 2026 15:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF7376B0088
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:00:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D73B6C317E
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:59:59 +0000 (UTC)
X-FDA: 84650818518.29.6C5F4B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3742F180003
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:59:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lxfu5tG4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776020398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IcnPyotG+8CfvO+mVMuRVajJ+k/64wr9vnsl9Lcsecs=;
	b=W7XDzudB39cqXO+xZyRf+ziMn5eCdPL/mzJ0onzK9NMYF+glAiDHUFIKhpjtafM+3A5810
	lbO1p6MPTNtrtHTH0dlABz3huKurBodTlGC+2VmqW0/KhTcMjndohDEcIAceot+I54Rt6X
	61FFptz+3OkI3h0ug2Ao50758y/v9zc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776020398; a=rsa-sha256;
	cv=none;
	b=Nz6PMVkNHgRXj+JfnEUSGYqXr/nL8FfcsqGYe5BSxHXLgmQOFiuLnQAHLnj/an6SWH/8Yo
	oo0orlQQL+94GpJYAPf6B+9/BnRBsd16sHLtvcCmfrdBDVoAP4M1kU+Zrax38HNS3DhoMa
	HsEdR/DxiaVtLhwRQkIbNkTYsTVHzvA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lxfu5tG4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AB8B60142;
	Sun, 12 Apr 2026 18:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BE5C19424;
	Sun, 12 Apr 2026 18:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776020397;
	bh=c5nX17VEd6pfb8YBjWIDLaDupaE+dxyisObEf1BO9qU=;
	h=From:Subject:Date:To:Cc:From;
	b=lxfu5tG4r1oBXYBsWqkORgXMFdEEWDR1s2ofUH+NE9ImdK8k4lw9lqbaSRhOUoQ2Q
	 99CzxakPFcjKWNYyVZcbfwyAiIQe+KcTS5G0jWUfyz7f1XqXd/RoE+LOVV7N1wzZYb
	 bXna0M/w7a7Xc3ZmXjwGtk5UiMyabygE/pFLUWjhkm4Qy+//1yGoLPjNS8TAox4t8a
	 +a2TU2+kx+Mp+kiv+EEPK6Fb8rXXk2Dd+S/w+0YM/gh4WcrXt8NLxIjCxiaoVt6/Qt
	 cc341LiNqvQpTQyqp1QU8uT1SkuxMXtGBb7JTL8bGZTvcn17/Vo6k8FGz32GNT42K6
	 rAoDjru9ItEOg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH RFC 00/13] mm/rmap: support arbitrary folio mappings
Date: Sun, 12 Apr 2026 20:59:31 +0200
Message-Id: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJPr22kC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDY2MD3dzEguT80rwSXWMjAzOzZDMLcwNDAyWg8oKi1LTMCrBR0UpBbs5
 KsbW1AN0GLIlfAAAA
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Brendan Jackman <jackmanb@google.com>, 
 Zi Yan <ziy@nvidia.com>, Pedro Falcato <pfalcato@suse.de>, 
 Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 3742F180003
X-Stat-Signature: krzzhfyfyio8rf1bzyq58xk4q3cbxiak
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776020398-41310
X-HE-Meta: U2FsdGVkX1+idK2zJDk/AxzNC2dwxoKsLCm1LpEZpoAW+NZA5AcI202nSOQc9FkDsmbt72L8EEcxWqFxs4ccpZdJmVBreJ6mllJBUSXIgBHZb52VaD4k0nvWKh4eZgPmDij+N/LbAUKz/0NyrBYQW203NCmvZD1spNxy4H9Ik9SyvfsevPhowyXy/L1FeXBKyFmX2DXknK/1n+F0cV1huURhSHWd2N6p+dO5JyUv6lt0ADCaU7i/qAAoMwJCOPhggL/PdPLtZn1Dk03g8Jce6MOXgjRTCD4DydUtSM8Higia2sTADvWUDGhfzl3lPN4S2qhWtkhsX1h9xn/shERBu8yyRVRX777FVcEPpNH68XjquNO9I8nKpdJelmzzgh2AjGDBczcon/E/vpGhbugILDsN0k7ASobebZo9RPVX1soCLE7YwLwbLFeryTsmOxi1PXYLJ5YM1wbwqytnPR8CW9faSQWmerXG8E2SaJY7snkBuLc1/6qOs5AN/nq9J7mJiJp+Au0uZWfUFJRh98DxbhrXdxlgxIu+tit4pshQM0KdUgJxEVhhQ2viygCVKHmP7gOMlcfHiNRrThHGXJAQod5jOwDQdvEZ1JWABXfSj9PxG/q9yweMCBR8jfIRNoCzhRcFlXF2BKL8M9M7+/J/oq0gokJZ/+ADgQfok3zOjQtapRR+1OwvuPLwqxeWcDAulXHew4agSTL5CIJQbWlqxTJpnp6aI59zu32exnkMFtrdEn8Tb3tfcPLeRDGf2hHD/Un0+8lXn8gQZc7neciUxTNl2kzoG0T7+mNg6ldXR2yEWdBQ/mcv7Hl6bwokfVmQ4GjJ3dc1L5P+UZ2OSt17ffWhIu/qrjPgGo7PD03unu7GCj2526apuqSKA33hLPUD/Rp/ZtY2nSXm4nsuvWvUvLPeI6LdZUAYnWCKa1H8FNAQ/VUwewo1V0goDbJ42SgZLHGY90NwDmTgU+exSVj
 5Ki1ftkW
 fRAG9cnQk8V6hcOR+CvvB1nsTJlAdA9ZlhIh5d+bNITw0Ob7z0qwwal8Izq0hkpgWbaAsaNbtgqZfaGnjGpGjlbTLryRgwgMvWWlx1DqmQ1VjOe7hDZF5c1ZVlhraIlQq+5YN8kYR9fOutf/mqnzzoXv42shTtg3avNLan4G5LGxQ/2QAMrb9ZWNgxKvBu3HhRhPTZIEnWRrPYyUeEG9rVSxGuUx9IO9iLkj1YhkzrWzU4srKv8OAhR62bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is related to my LSF/MM/BPF topic:

	[LSF/MM/BPF TOPIC] Towards removing CONFIG_PAGE_MAPCOUNT [1]

And does the following things:

(a) Gets rid of CONFIG_PAGE_MAPCOUNT, stopping rmap-related code to no
    longer use page->_mapcount.

(b) Converts the entire mapcount to a "total mapped pages" counter, that
    can trivially be used to calculate the per-page average mapcount in
    a folio.

(c) Cleans up the code heavily,

(d) Teaches RMAP code to support arbitrary folio mappings: For example,
    supporting PMD-mapping of folios that span multiple PMDs.

Initially, I wanted to use a PMD + PUD mapcount, but once I realized that
we can do the same thing much easier with a "total mapped pages" counters,
I tried that. And was surprised how clean it looks.

More details in the last patch.

Functional Changes
------------------

The kernel now always behaves like CONFIG_PAGE_NO_MAPCOUNT currently
does, in particular:

(1) System/node/memcg stats account large folios as fully mapped as soon
    as a single page is mapped, instead of the precise number of pages
    a partially-mapped folio has mapped. For example, this affects
    "AnonPages:", "Mapped:" and "Shmem" in /proc/meminfo.

(2) "mapmax" part of /proc/$PID/numa_maps uses the average page mapcount
    in a folio instead of the effective page mapcount.

(3) Determining the PM_MMAP_EXCLUSIVE flag for /proc/$PID/pagemap is based on
    folio_maybe_mapped_shared() instead of the effective page mapcount.

(4) /proc/kpagecount exposes the average page mapcount in a folio
    instead of the effective page mapcount.

(5) Calculating the Pss for /proc/$PID/smaps and /proc/$PID/smaps_rollup
    uses the average page mapcount in a folio instead of the effective
    page mapcount.

(6) Calculating the Uss for /proc/$PID/smaps and /proc/$PID/smaps_rollup
    uses folio_maybe_mapped_shared() instead of the effective page
    mapcount.

(7) Detecting partially-mapped anonymous folios uses the average
    page-page mapcount. This implies that we cannot detect partial
    mappings of shared anonymous folios in all cases.

TODOs
-----

Partially-mapped folios:

If deemed relevant, we could detect more partially-mapped shared
anonymous folios on the memory reclaim path (e.g., during access-bit
harvesting) and flag them accordingly, so they can get deferred-split.
We might also just let the deferred splitting logic perform more such
scanning of possible candidates.

Mapcount overflows:

It may already be possible to overflow a large folio's mapcount
(+refcount). With this series, it may be possible to overflow
"total mapped pages" on 32bit; and I'd like to avoid making it an
unsigned long long on 32bit.

In a distant future, we may want a 64bit mapcountv value, but for
the time being (no relevant use cases), we should likely reject new
folio mappings if there is the possibility for mapcount +
"total mapped pages" overflows early. I assume doing some basic checks
during fork() + file folio mapping should be good enough (e.g., stop
once it would turn negative).

This series saw only very basic testing on 64bit and no performance
fine-tuning yet.

[1] https://lore.kernel.org/all/fe6afcc3-7539-4650-863b-04d971e89cfb@kernel.org/

---
David Hildenbrand (Arm) (13):
      mm/rmap: remove folio->_nr_pages_mapped
      fs/proc/task_mmu: remove CONFIG_PAGE_MAPCOUNT handling for "mapmax"
      fs/proc/page: remove CONFIG_PAGE_MAPCOUNT handling for kpagecount
      fs/proc/task_mmu: remove CONFIG_PAGE_MAPCOUNT handling for PM_MMAP_EXCLUSIVE
      fs/proc/task_mmu: remove mapcount comment in smaps_account()
      fs/proc/task_mmu: remove CONFIG_PAGE_MAPCOUNT handling in smaps_account()
      mm/rmap: remove CONFIG_PAGE_MAPCOUNT
      mm: re-consolidate folio->_entire_mapcount
      mm: move _large_mapcount to _mapcount in page[1] of a large folio
      mm: re-consolidate folio->_pincount
      mm/rmap: stop using the entire mapcount for hugetlb folios
      mm/rmap: large mapcount interface cleanups
      mm/rmap: support arbitrary folio mappings

 Documentation/admin-guide/cgroup-v1/memory.rst |   6 +-
 Documentation/admin-guide/cgroup-v2.rst        |  13 +-
 Documentation/admin-guide/mm/pagemap.rst       |  30 ++-
 Documentation/filesystems/proc.rst             |  41 ++--
 Documentation/mm/transhuge.rst                 |  29 +--
 fs/proc/internal.h                             |  58 +----
 fs/proc/page.c                                 |  10 +-
 fs/proc/task_mmu.c                             |  69 ++----
 include/linux/mm.h                             |  37 +--
 include/linux/mm_types.h                       |  22 +-
 include/linux/pgtable.h                        |  22 ++
 include/linux/rmap.h                           | 221 ++++++++----------
 mm/Kconfig                                     |  17 --
 mm/debug.c                                     |  10 +-
 mm/internal.h                                  |  30 +--
 mm/memory.c                                    |   3 +-
 mm/page_alloc.c                                |  31 +--
 mm/rmap.c                                      | 302 ++++++++-----------------
 18 files changed, 325 insertions(+), 626 deletions(-)
---
base-commit: 196ab4af58d724f24335fed3da62920c3cea945f
change-id: 20260330-mapcount-32066c687010

Best regards,
-- 
David Hildenbrand (Arm) <david@kernel.org>


