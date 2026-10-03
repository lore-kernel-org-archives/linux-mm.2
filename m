Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87171CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B48A6B0088; Fri,  2 Oct 2026 20:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33DD96B008A; Fri,  2 Oct 2026 20:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206026B008C; Fri,  2 Oct 2026 20:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E91B16B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:19:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B137806C8
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:19:00 +0000 (UTC)
X-FDA: 85279404840.01.188F781
Received: from mail-oo2-f37.google.com (mail-oo2-f37.google.com [74.125.231.165])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9B8AA80002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:18:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jtWd3Qfi;
	spf=pass (imf30.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.231.165 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dOJAo01xD+ma9V3F3JPbMavctw9FJP4/KhHqsKCIBZc=;
	b=WNZX3CKC4f5IcldWptBtBbjkCHBlSAKwEr4xZiQ4FPJMsMPpBYiVlBa/sdKMNijX+poXi/
	rgVYxwOJCVWmeLZP89oS3VqFtHwfuTIEBs57szrST0zPXBx8yj2cvcwKQffSXkqKNl5SZZ
	qRZNJIOFBDZCbTld+Dlfgk2Rz/4oApk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986738;
	b=ftVOhledraQei863g92QZ6sD88WmAkL27uPVB82WLKYdkXd8IULKlhkbexuWxdGL+sKdZA
	Zbv+pfFE19xtByLlOChGU9y4iZ8h2dO+abcINJzgkLHfjHH5fyyLNpDQuiu368GLyi20K7
	AhyWzJtOjj0DWwWud7TWazYLQ8V49RE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jtWd3Qfi;
	spf=pass (imf30.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.231.165 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo2-f37.google.com with SMTP id 46e09a7af769-8137b129131so360200a34.2
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790986737; x=1791591537; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dOJAo01xD+ma9V3F3JPbMavctw9FJP4/KhHqsKCIBZc=;
        b=jtWd3QfiPSDRzbmRWXvxFVU8pvAmTMUmAq/ocuwnjXmgSBGw8ciLdNhc0buncBB/UR
         SRBVVEC2lHEUpxQlGJjsJmrlAiHYcaJzejYckTnsFGLq2f+EZhmK8Keast5dfZxdOUuU
         K3GlrkxTOznvxPVo/H9K5ihcKolcHtcR7lDZeKREtm37Ou4SheujUu5Xk/Xtb99bmgQm
         syJwyDkNTTNw8Ntzmfjzuk/nkgHsMnr/4jszd57AuvxliyHORGY0x0U0E+ytFBoE9OWT
         9qTF+NwbSF5OnjzKvKUJU22FhoL8wdTgrmO0bFRlsTUY8YwIDscux5oXP4UmVip+VLyq
         Vs+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986737; x=1791591537;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dOJAo01xD+ma9V3F3JPbMavctw9FJP4/KhHqsKCIBZc=;
        b=QuNq4L70bN9X4LeG0R+87n5xHrBlsoQhgkqjrmwqAlLDs93oeRaS/3tmAT2wXT95+I
         Wx5qXY3kCxIXFOh0eBmyokhiGrIXxM8t/ajItLFJPcT99x514yRBb5Zhxf5zKW4Y3t6a
         fEO1erkWlDT3gKiM4ejnvfDX7p/db6bUEN2JmX07rTBJHFGp+ZmD+1arElVcXQ4uT3hW
         cIqkAjGsbjLb4JcentkEsI4WfOUw/S1yOhRwD8qmsomCjKw3FmM7os8ttt/hsJc0qbC7
         waviyLWbPLVHYSJE95bITJzXQ7fyIvwXNF5bDcVqIgvIgz3qgNsM4QrTZ2Zi0lFtoCB6
         0zGw==
X-Forwarded-Encrypted: i=1; AKwUvBxAYA18qF8Idl4Y/UD7IC3Xc4jQwMIO4+X/fu9R0MWRx2PyXhZYMpkg9H+xHWvi6RSkM9jweTTpHw==@kvack.org
X-Gm-Message-State: AFuF++mM2kShBu7+B8hJLvxW890yEJsbNQb94UFrp1VswyU+X8E5e19E
	cYqxwlYkp+V345NvGRoXJiY/aAAtbc/xq+OyGbImjFBDHyNJ3sUbf4Nd
X-Gm-Gg: AYBFou2Cc0tw1YRwARjf2DsDHp7G++vwCAIkFMh3aRJg3jM3SLuIK6PCKkPoozQW9xN
	BAgrP5GZkQEu2BoWvIahKpOX2gH3bCxSE4BWCEcbQXCC6MGxGaQ0zOsyKHVkdC6wfSqzBjQ156e
	ALGo6rXJfywLmCZj5PPp2i/t+1owTfn08gpqtAXOQ67HN3PtASDN6o08fWahd3OnlWcYPnLBZe4
	PrHIKx/gV36v8av73M5UJaPyEBNVp63l3nX7d/XfWQPjtMiDtdtNEZqQ+plV8hKwsy7/VZ+fOrN
	w1XLG+r5WsTkkgBQD70yJQRDZZOPmi1U7JEe89JOCBV5y3bLXCLHu6WvtSV3YxSA3JSQ5CnaHR2
	AteKZr1SETgigkpjm2ebju3x8VbWwu7oNsEl9G+Hfn4HT/T9j22XdgKMecoidkTQYNfMNsK4NKT
	DT8AC6iOVYiyDdxR+0xnOhw0Jsp0apIFQ8JK/VIEGqNVjZhxLapNtk0M/dyuLxefA/B1VlV1RqD
	I0mXkdtCAGsOfZ+TKk3FCHkHkuo0DNcbHQwm/343MyoLurgDo4=
X-Received: by 2002:a05:6820:4cc7:b0:6b3:506e:b484 with SMTP id 006d021491bc7-6df32da21e3mr3485781eaf.16.1790986737447;
        Fri, 02 Oct 2026 17:18:57 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-49e1b2e3664sm2883059fac.7.2026.10.02.17.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 17:18:56 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	willy@infradead.org,
	jack@suse.cz
Cc: mhocko@suse.com,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	riel@surriel.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 0/3] mm/readahead: avoid per-folio memcg reclaim
Date: Fri,  2 Oct 2026 17:15:52 -0700
Message-ID: <20261003001555.3498357-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B8AA80002
X-Stat-Signature: n4n7beiikfrd53sxf6iwws8pwc6133oo
X-HE-Tag: 1790986738-119400
X-HE-Meta: U2FsdGVkX1+4P9okKbwMj4bHLhYqBMEuH+Vg8ySjfSgnCwaqx+cq0JMsaguCR2Huft0cNyVGeqSYe5f8P+WFpSubWo7684To0mbjgkZzJfLkctjUtmtQNyFzAfmLK4vv8FC+mkHFyEb5rxDQ0qoGkElh42H65iMnzn44DNeeqP3tI+tlzYca5sXDSQtkG6auTXenl+5B5qnv8r2D8VeeyY/2CmpSyap309jOT42lkAcb+ja+uDp3Kinl8JPyy3IDn1ye2sanAkm0tj54q+GBinTAjoa7dZ1dqkxa6hNPrgd7/fKKTR1weQkJBsxlLaHErIRqFE95fxIW+fX0gVG1h7Cbmf+ADltWASqsMyPbyGiPLgUdD3RJRXj5cEW50KEYNu9p/oWK8xYEn+LeNhXWHd3YKUvQ6tMmtZf5zL6zjUUQCXOQhlGIVEB4r/YmwoNvhC8rJZ9cwAuWabSRks529w5AxxIHHt2Lg4wSm1hXCwTAvbNzsEsL8S2/7jEdfOHvwvSK68vSPbMCjDzj98lWejbTPD8YG7Pd1mUOivUt+8CbEL9hsEAykop29LOW+RlqKLeZaDQ/WGSNO3ye+aPaSJPBJf6VaN1MX1a57WZHGdYOfBVkWgPcZjBxJN76IIyrRVyd9kKX1o3sqhLtA83SeB2isYemanT9isV3zoJNJ/SLfcfnD0qCFpdSrzp0xpu0yYnrp4f+MdMTOzdO3btw3K8eNkjw72zuQYP55CUUlhh2jUYgrZG0Awt4G+H5xOs1CpHpzXHrAazYDxj3opuWXBDtjdNEsGkQFcLB3Qnphzm8OBBPrDLBUMEJMoSJlVw6kuU32ovO5RnVZoUcpcRtNJCTYsgtHnIU17o8wQoy7caa0xOaxDgavQ4Jk0L85Q40o+nRcB0K6t8dqIhJ3BNy8pbVWIcQY1mgDTl/IeitT6hm7vEUFU6URUsguC14yZU6LaZ+5DJPXC73qTGPWG/
 Q/NQFYUx
 IRkpb+VVo6p6taa2JygXHky9URnSDpKmmVthpxvl9XmTNRPvRsYdEx5YnCSBDUWZ33vekDZyrtu2vQsykxfJsyay69G840WTQ3u0azilOoednjDD0p0a6kdleNndvpKHV2JpkPyeMhWMfsJIRA/E+fe8C/3OZKwpd9ONF4lEjZH6Udgr4dM88fNIilp8Ab7x4etoCl7A22KoTi5q/i6K0WV5eMhM5yQ1m/XJS4VzWnx9YRu2pRApzcJo/ancUGiwhuW5DwtIdCTd2JbglAN853kg0FA+zNKNNlXstVBUNRQ8ODbeQgmv6aWxRJguUE8mPVqgOCIJQRhsq/CFBwzZSG2EIw0m+k4z2HY53C7d4FgAOd0FHsvLOJ6IwY590Lh6KeO70bItChJ2Ai1tq8a9peaJOuRie3hToav4nt6n/Uj/Y4PhulspJ2HLdFHqfGfqBRAM0Yk1jKJMPyaeJy8VGUDkLF0pJV1vxKWHf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Readahead adds the folios in its window to the page cache one at a time. Each
folio is charged separately. When the memcg is at its limit, each one of those
charges triggers reclaim. With many tasks faulting in the same cgroup, the
margin one reclaim pass frees gets consumed by the others, so the faulting
tasks keep reclaiming, all to make room for speculative folios, and in the
worst case, reclaim livelocks.

On Meta's fleet, this per-folio reclaim is a large cost. From fleet-wide CPU
profiles at Meta:

 - Page cache insertion (filemap_add_folio()) triggers about half of all
   memcg limit reclaim CPU, more than anonymous faults, swap-in and
   memory.high combined.

 - 93% of that comes from mmap fault readahead: filemap_fault() ->
   do_sync_mmap_readahead() -> page_cache_ra_unbounded() ->
   filemap_add_folio() -> mem_cgroup_charge() -> try_charge_memcg() ->
   try_to_free_mem_cgroup_pages().

 - In filemap_add_folio(), 83% of the CPU is memcg reclaim while the page
   cache insertion itself is 6%.

Most of it comes from services whose worker cgroups run at their limit while
many threads fault in mmapped files, mostly on btrfs, which our hosts mount
with compress-force=zstd:3.

This series adds readahead folios to the page cache without direct
reclaim. When the memcg is at its limit, readahead reclaims for the rest of
its window all at once instead of once per folio, and tries a second time if
the window runs out of room again. Please note that this only applies to
speculative readahead folios. For the folio a fault or read actually needs to
read in, it is still charged with the mapping's normal gfp mask (with the
reclaim flag set), like before.

On a 26-core/52-thread machine with btrfs, running 26, 52 or 104 processes
(one per core, one per thread, and 2x oversubscribed) that each mmap their own
file in one memcg with a 1G memory.max (before and after measured in the same
boot), reclaim passes per major fault drop by 94-96% for both random and
sequential reads. With data compressing ~3:1 under compress-force=zstd:3, the
runs that livelocked in reclaim without this series (4 of 18) no longer do.
Throughput with incompressible data, where the disk is the bottleneck, is
within 5% of before in either direction and the drops are within run-to-run
variation. With the compressed data, it is 9% higher at 104 processes, where
reclaim contention is.

More details on the results seen (medians of 3 runs of 10 secs, 5 for seq, rand)
are as follows:

Reclaim passes per major fault:
                       26 procs      52 procs         104 procs
cold, rand          23.2 -> 0.88    23.2 -> 0.88    23.1 -> 0.89
cold, z3            21.7 -> 0.95    20.0 -> 0.91    17.9 -> 0.85
seq,  rand          78.3 -> 3.66    45.8 -> 2.37    26.8 -> 1.24
seq,  z3            42.0 -> 2.59    37.2 -> 2.01    22.9 -> 1.24

Throughput (pages/s), after vs before:
                       26 procs      52 procs         104 procs
cold, rand            -5%             +5%             -5%  (disk-bound)
cold, z3              -3%             -1%             +9%
seq,  rand            -1%              0%             +4%

(read_ahead_kb=128, "cold" = read 64 pages from random offsets, "seq" = read
4096 sequential pages, "rand" data doesn't compress , "z3" data compresses
~3:1, which moves the bottleneck from the disk to the CPU).

Cold readers get the same readahead as before (pages per major fault within
2%). Sequential readers get up to 18% fewer pages per major fault, but their 
throughput and read bandwidth are unchanged or slightly higher, so readahead
pretty much does the same IO but in more and smaller pieces.

There were a few alternative approaches considered and tested in experiments:
 - don't reclaim in readahead at all:
   This cut reclaim to 0.02 passes per fault, but effectively disabled readahead
   in cgroups that live at their limit, and led to ~100x as many major faults.
   Each read request sent to storage was around 5KB instead of ~120KB.

 - charging the whole window up front:
   This leads to overcharging, as it charges for folios that may turn out to
   already be cached. With every other 16 page jjchunk of the file cached it
   triggered ~15x more reclaim passes per fault than this series.

 - One reclaim attempt per request:
   This led to the fewest reclaim passes (0.75 per cold fault), but at 52 procs
   10x as many requests end early and sequential readers lose 29-35% of their
   pages per fault. This is because with many tasks in one memcg, the room one
   reclaim attempt makes is often used up by other tasks before the window has
   completed, and with no second attempt, readahead stops early.

 - Two attempts per request without the immediate drain-and-retry:
   3x as many requests end early as this series and sequential pages per fault
   drop 16-22%.

 - Up to four attempts per request:
   At 52 procs on z3 data it gave 14% more pages per fault for 8% more reclaim
   than two attempts, but this is within the noise of the two attempts'
   run-to-run variation (13%)

Swap readahead charges the folios in its window one at a time in the same way,
so it can hit the same per-folio reclaim at the memcg limit. This will be
further investigated and followed-up on in a separate independent series.

This series was run through an LLM for sanity-checking / reviewing,
structuring the cover letter and improving the wording of commit messages,
helping generate some test scripts, and for bouncing ideas for different
alternative designs that could work better.

Joanne Koong (3):
  mm: memcontrol: factor reclaim logic out of try_charge_memcg()
  mm: memcontrol: add mem_cgroup_reclaim_for_batch()
  mm/readahead: avoid per-folio memcg reclaim

 include/linux/pagemap.h |   1 +
 mm/internal.h           |  10 +++
 mm/memcontrol.c         | 131 ++++++++++++++++++++++++++++++++--------
 mm/readahead.c          |  51 ++++++++++++++--
 4 files changed, 163 insertions(+), 30 deletions(-)

-- 
2.52.0


