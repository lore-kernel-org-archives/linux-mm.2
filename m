Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF69606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 23:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=U+0csrj6
Received: by kanga.kvack.org (Postfix)
	id B75516B06BC; Thu, 19 Nov 2026 18:40:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B263D6B06D4; Thu, 19 Nov 2026 18:40:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14C56B0713; Thu, 19 Nov 2026 18:40:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66C6D6B06BC
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:40:07 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE77A40C86
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:40:06 +0000 (UTC)
X-FDA: 85453489212.09.0AC0F02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 23BD2180005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:40:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=U+0csrj6;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795131605;
	b=dGVpxcE84zA/VGxMNcMnD4gPtgKILx+gKQtMUbEbcF0uaV+xbpUfnCBn9MQqlTh4dEaNl0
	l7MBFiJMUe0j7LALwc0a2eWmMMfOxfST7P4XuO6Ll25VXpbRYTE6bgBY/ltz3q7qTF51Fn
	ZFmuaujilgsrOjGoe4KTxosfAbVZSDY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795131605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1DASm4ABHvydbCgPqdPTvCuRMoED8Hk0QLqB2S7niGg=;
	b=dlhTn+YjrJ8fr4HH8h28Hdeth/TXDzCp1JJ0VraOO5yDzyIb6gzu3s9YHlHk8AfYBwYo+8
	+CwZgk0cjOOmsQn0OMyuJ1jmyEq69yXnJ6J6hODVl1VHDVGShAFbho5kNbdRJp4U9J/bSt
	Rj1wJnoT3LHWcl7aMnK0wJg9EoDa9Bk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=U+0csrj6;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4CCF609D3;
	Thu, 19 Nov 2026 23:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD221F000C4;
	Thu, 19 Nov 2026 23:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795131603;
	bh=1DASm4ABHvydbCgPqdPTvCuRMoED8Hk0QLqB2S7niGg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=U+0csrj65wERCccDzC12LroJ2Kmi9pNSiZ1GLXYN+X4ITS8T6WSI63cqKE+cX4Hmm
	 L0hxYNeHlbh+eBUYUAc2PsDKL1D14zOI/mu4STeDpxOXDKv6VSo0+AzDC55vy6g569
	 KmmPM5xLsXz2U+B/JyPbFblGAVZAUVviXOydljfE=
Date: Thu, 19 Nov 2026 15:40:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Muchun Song
 <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Ying Huang
 <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He
 <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Nhat Pham
 <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan
 <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins
 <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes
 <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, Vernon Yang
 <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, Chen Ridong
 <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, Kairui Song
 <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh
 <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian
 Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, Kunwu
 Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 damon@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 00/17] mm/mglru: frequency guided promotion
 (MGLRU-FG) and flag cleanup
Message-Id: <20261119154001.9b9f953136935a09e8a50af6@linux-foundation.org>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 23BD2180005
X-Stat-Signature: ge4gnj6yo7nejp1okbz1t7m5sdqjswak
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795131604-954735
X-HE-Meta: U2FsdGVkX1/6BX3QnKYBQsVdhv9ExUkVH+8zoAIy5Uj30k/WMYIP1d/NqsY96MxZZnXtDpMyKuF4TrbxS1m3tcdqoYHtmuULF0jrvqa5MHUaB0bCbU8mJcy6NtjU6Um+I1Jv9ymTVkIOSLEfHF4JAIzm+C+RYfN+xQgP4XLAl1tlql3VoMcY4nKeyC6XEE2O1bej+BffWkhb4E75R6WLp6L88bgLJxLEP1+rjDvpyn6Fbz4sWHq7zpWWGiUV6gD6jHTDNVIlU/lQxPu8jye0hrxniD75+hXyMB7vyGXNG0nta2MZ1zcQ3xW4O+Fu7INK2S9GOjdK2AvqfwTZi9lyQbz/9Ctmw/dWYcofrR5wFD4d0SpdNyxaHajyqe9NVJji9o/doQwElKZh7OTSpe5tXKM+k3H4XhHiO9PiNElQxGYzEpvew3fuwUNjPCN2aixbulXePgtJDQ8nyVJTGk+uZ9CVq2QUaRah/ip+J0tkzQ9OzCJ8RuKHVXXxnSTHiNMozmi6ZzYzylTeEj0zb9OB7CqLaSORCy1cbCglnikCJMLwTJHbj22fv0ym1fb+hFPrm4LfR152G/67oPrl5FimDvCAZxLAoEEgft6ZS3G/3TJZaipA1guxTjNYGmEWl9ESbe0/cFlCz5luwBzx31iQmesu5LRAkbsOvU3gdGezsRpLqUVwXpoj8dCNN5ePZEFOK1glJ119s27TTlhZ/YuYjcTPjzp3qO/aif7peI4YeocSDDiwWJwoAtBijI2cJGhwhK8sLiuQ9OEnXUhJYTKOiFtxGiftRv8r8wPzCYPAdEbJ8z1XQqvEhzTIxezQURye16xmly5NabR5gan+hRdF0IMtiK2dv1eaIGjzAtyCiAU0AS9f/AEBLS387Tcmhjf7vGE8oo4ar0zLDnngmejEisE04Jte50bFxWo5xL4AgIZc5QSmWJwrAfv4DSpq4CnViJL+l4ZZZ5Q+sFL9L+a
 8hVQAqw9
 7zJuLZ72b4Ez+9TW+9wo/7Ag1A+hdFgidoRLLlayGDz3ZkTnRr69nMz0cOZ5LbNSIlFV9zPJ1w1aL419K78rQACOwAzlhwcMqnPdKzD5WcptxZj96p+dE5VK6sRAoE+BW6/cye5o9M8teGEODSvSYsPWgXoj9ql7nBm0H0P9xq/ccONvg9Kr+HF2RVxUynNbNVBHc5MVjzJJeVN/aJMwi3aYQ90V3doRfUw7WT/+I1Qi5dfcXh9KCDdkAHiLUPktpeoLsJf+26Q2CRoSsZDwYERRREPxlXxLpmPuQYvT0Ft71XtdoM5HwxVd4bx63SJ5o+4cQqdgH5wdKnSkh3UMEGjrNNvl3x6sFV4ub3AuUWayKChfRJPVGN3Tov9LOw/noUIaOppYmhXZIC53PYOw5/CEH6gqXj0xgKtRSzNUVgNak/zM8m7NbAz9VHxacvzjCKRppdscpqHh1hleXz9+zJsfr23ZKRahOxZEYlIsXxL99qinBIzXso4XZho7rAJriKm9t6iKxt14usO9Vp1NUXNKu0TIOutEcmtqD6uWQbv9mTiKTeeVhimkAZ5rNjF/itpwT10WM75bVQQr+3vPoogrt34lgbEsKF8iAvofygcaYEB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 05:03:32 +0800 Kairui Song <kasong@tencent.com> wrote:

> This series implements MGLRU-FG following the idea proposed at LSF/MM/BPF
> this year [1], based on current mm-new. Depending on the workload, it
> improves the performance or reduces IO by roughly 10% to over 50%,
> fixes multiple long-standing issues with MGLRU metrics, and drops one
> page flag.

This is looking really good - great stuff.

Review is thin, so I'll remain in wait-and-see mode for now.  What do
people think?

I told LLM to put this series through its paces.  The performance gains
were confirmed (actually muchly exceeded) and it couldn't find a way to
break anything.  It found a smallish slowdown in writes to clear_refs,
which doesn't seem very important?

Feel free to add
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: <whatever the URL of this email is>



wall-of-words for the brave:


: I tested v5 of "mm/mglru: frequency guided promotion (MGLRU-FG) and flag
: cleanup", a 17-patch series, in x86-64 QEMU guests with four CPUs, two
: NUMA nodes, 8 GiB RAM and matched kernel configurations. The main A/B
: comparison removed or applied the whole series. KASAN builds checked
: correctness and injected allocation failures. A 512 MiB ext4 file,
: four readers and a 192 MiB memory cgroup exercised cold-cache file
: reclaim. With QEMU host caching disabled for both kernels, the skewed
: mmap median was 137.5 seconds on A and 5.21 seconds on B; a fresh A
: repeat took 139.1 seconds. The full series also made repeated
: clear_refs/smaps scans about 7% slower. Separate builds tested selected
: patches immediately before and after application.
: 
: Series:
: https://lore.kernel.org/20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com
: 
: [1/17] mm/mglru: rename the generation offset in lru_gen_folio_seq() (pass)
: 
: The kernel with patch 1 built and booted. It passed 12 charged-cgroup
: removals and an 8192-page get_user_pages test without a warning. This
: preparatory rename makes no separate behavior claim.
: 
: [2/17] mm/memcontrol: allow update of LRU statistic without holding LRU lock (pass)
: 
: Kernels through patches 1 and 2 each passed 12 cycles of charging
: file pages to a cgroup and removing it while another task read the
: file. The charge and data were correct, with no warning. This
: preparatory change permits atomic LRU statistics updates without the
: LRU lock.
: 
: [3/17] mm/mglru: make generation page counters atomic (pass)
: 
: Kernels through patches 2 and 3 passed the cgroup-removal and
: 8192-page get_user_pages tests without a warning. After eight MGLRU
: aging passes on both NUMA nodes, each still accounted for about
: 512 MiB of anonymous memory. This is an atomic-counter conversion
: with no claimed behavior change; the run checked accounting after aging.
: 
: [4/17] mm/memcg: add folio-based lruvec live helper (full-series check passed)
: 
: A full-series KASAN kernel used a one-shot, task-scoped mdelay(800)
: in folio_inc_lru_refs(), just after folio_lruvec_live_get(), inside
: the RCU read-side section. Another task removed the file's charged
: memory cgroup. rmdir finished before the held reader was released;
: the read completed without a KASAN report or warning. This B-only
: test proves the observed removal/read overlap, not execution of an
: RCU callback or freeing of the memory cgroup during the hold.
: 
: [5/17] mm/mglru: skip the flags cmpxchg when nothing changes (speedup unconfirmed)
: 
: I compared kernels through patches 4 and 5 with a 2 GiB tmpfs file
: mapped by 1, 8, 32 and 64 readers. The file pages were verified on
: the NUMA node being aged. Across alternating A/B/B/A boots and five
: measured passes per reader count per boot, the 64-reader medians were
: 841.8 ms on A and 852.0 ms on B. The 32-reader medians were 425.8 and
: 429.1 ms. This VM did not reproduce the author's speedup; these small
: differences do not establish a material slowdown.
: 
: [6/17] mm/mglru: frequency guided workingset promotion (MGLRU-FG) (series gain)
: 
: In a repeat with QEMU cache=none for both root drives, the skewed
: mmap median was 137.5 seconds on A, 5.21 seconds on B and 139.1
: seconds on a fresh A repeat. Each round began with zero resident test
: pages. A had about 53 million file refaults and 820 million guest
: block-read sectors per round; B had about 0.22 million refaults and
: 5.6 million sectors. The much larger disk activity on A explains the
: slowdown in this constrained workload. This compares the full series,
: not patch 6 alone.
: 
: [7/17] mm/mglru: make folio lru referenced times count a generic API (pass)
: 
: Kernels through patches 6 and 7 each migrated 128 anonymous pages
: between guest NUMA nodes with MGLRU enabled, then repeated with MGLRU
: disabled at runtime. Data remained intact. At the real migration call,
: a temporary test module set the isolated source folio's encoded
: reference count to 4; the destination retained 4 on both kernels.
: The module also copied counts 0 through 7 between off-LRU folios.
: This patch moves the helper without claiming a behavior change.
: Disabling MGLRU at runtime did not test a !CONFIG_LRU_GEN build.
: 
: [8/17] mm/mglru: move add/del LRU size accounting out of lru_gen_update_size() (pass)
: 
: Kernels through patches 7 and 8 passed the cgroup-removal and
: get_user_pages checks. After aging both NUMA nodes, each still
: accounted for about 512 MiB of anonymous memory. The patch moves
: accounting between functions without intending a behavior change;
: these checks found none.
: 
: [9/17] mm/mglru, gup: mark folios referenced via a fast helper (pass)
: 
: vmsplice() reached get_user_pages_fast(), returned the expected 4096
: bytes on both kernels, and showed no material timing difference in
: the repeated 8192-page check.
: 
: [10/17] mm/mglru, smaps: convert to LRU refs based operations for MGLRU (smaps pass; series loss)
: 
: After clear_refs and reaccess, smaps reported 0 KiB referenced on A
: but 2048 KiB on B, as intended. For 400 clear_refs/smaps/reaccess
: cycles on a 128 MiB base-page mapping, A took 1.87 seconds and B
: 2.00 seconds across alternating guests. Most of the difference was
: in clear_refs itself: 0.187 versus 0.300 seconds per 400 calls.
: This slowdown belongs to the full-series comparison; it has not
: been assigned to patch 10 alone.
: 
: [11/17] mm/damon: convert to LRU refs based operations for MGLRU (pass)
: 
: DAMON pageout reclaimed a selected clean 4 KiB file page on both
: kernels; rereading it returned the expected data. A trace on B reached
: folio_reset_lru_refs() in kdamond.0. Comparing kernels through patches
: 10 and 11, an identical temporary source change set the page's MGLRU
: reference count to 2 just before the changed call. A left it at 2; B
: cleared it to 0. The ordinary workload reached that call with count 1,
: so this demonstrates the fix for a forced state, not a user-visible
: failure produced without the temporary change.
: 
: [12/17] mm/khugepaged: convert to LRU refs based operations for MGLRU (pass)
: 
: I compared kernels through patches 11 and 12. Identical temporary
: source changes set isolated folios' MGLRU reference count to 2 at
: khugepaged's referenced-page decision and cleared other positive
: indications. A did not collapse the 2 MiB range; B collapsed it and
: reported 512 referenced pages. The ordinary full-series workload also
: collapsed a huge mapping, but did not reach this even-reference state
: unaided.
: 
: [13/17] mm/madvise: adapt for LRU refs based operations for MGLRU (pass)
: 
: MADV_COLD and MADV_PAGEOUT succeeded and preserved page contents on
: both kernels. Ten-round MADV_RANDOM mmap medians were 5.35 seconds on
: A and 5.26 seconds on B, with no slowdown found.
: 
: [14/17] mm/huge_memory: mark folio as accessed more accurately on split (pass)
: 
: An automatically collapsed 2 MiB anonymous mapping split when the
: protection of one 4 KiB range changed. A shared-memory huge mapping
: also split at its PMD. The split count rose and contents stayed intact
: on both kernels. During the shared-memory split, a trace recorded
: folio_mark_accessed() on B and no such call on A.
: 
: [15/17] mm/mglru: folio LRU refs based active/inactive number accounting (pass)
: 
: With swap disabled, I compared kernels through patches 14 and 15.
: After allocating 512 MiB of untouched anonymous memory, I aged both
: NUMA nodes eight times. On A, the cgroup's active_anon fell from about
: 512 MiB to zero at the first pass; on B the memory was inactive from
: the start. A separate cold mapping gave the same classification
: change without corrupting data. This reproduces one wrong accounting
: result on A and its correction on B; the later oscillation described
: in the changelog was not separately produced.
: 
: [16/17] mm/mglru: make folio_inc_lru_refs lruvec lockless (full-series check passed)
: 
: The full-series KASAN kernel passed the cgroup-removal overlap above.
: A second one-shot, task-scoped mdelay(800) in folio_inc_lru_refs()
: held an old-generation folio's update after sampling max_seq=4 and
: calculating max_gen. Another task aged the file's charge cgroup on
: both NUMA nodes, advancing the sampled sequence to 5. The temporary
: source change set LRU_REF_FORCE after the hold to force promotion;
: the kernel logged its changed-sequence retry from 4 to 5.
: Both readers returned the expected data without a KASAN report or
: warning. These are B-only checks of forced concurrent paths; they
: do not reproduce a failure on A or measure the lockless operation's
: cost in isolation.
: 
: [17/17] mm/mglru: make folio_test_workingset() work based on folio LRU refs (pass)
: 
: A matching test module on kernels through patches 16 and 17 set an
: off-LRU folio's encoded reference counts to 0 through 7. At counts
: 4 and 5, PG_workingset was clear on both. The old helper returned
: false; patch 17 returned true. This reproduces the wrong answer and
: checks the correction for the encoded counts named in the changelog.
: 
: For allocation failures, per-task fail-nth tried positions 1 through
: 32 during huge-page collapse on each KASAN kernel. Only positions 1
: through 3 encountered eligible allocations in one attempt. The first
: two made MADV_COLLAPSE return ENOMEM; the third still allowed collapse.
: Page contents remained correct. The original full-series guests had
: no KASAN report, oops or warning. Uniform-random mmap and GUP-fast
: checks found no repeatable loss in the original runs. Those runs did
: not set cache=none. The later disk-backed A/B/A repeat did so on every
: private QEMU root drive; its mmap results replace the earlier mmap
: timings above. Guest cache residency and block reads were checked.
: Physical media throughput was not measured.

