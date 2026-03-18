Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B48F1088E49
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60F9E6B0349; Wed, 18 Mar 2026 18:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5997E6B034A; Wed, 18 Mar 2026 18:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A006B034B; Wed, 18 Mar 2026 18:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 26DEF6B0349
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:29:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C09B1B6380
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:29:57 +0000 (UTC)
X-FDA: 84560627634.09.8F4D210
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id F27C24000F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:29:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BcEf80k8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773872996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RRYnHpo8uKuUlS1v8ui4dqVxSU8CGxN8PZ2oQLxXs9Q=;
	b=mXdkN1ioyQHAqK1I24VqsOaKzqqTxPYYsxpqfU+hC9V7qPCpgeZIA1nIhoLEFE7hYF7/xW
	dZH5NO+z3cFPJ3xpSBSvSsEXAs3lk0b6QlpYZWrOaZ2f98IEzArcTC5Ao2WUhZDhLuoG6q
	5oc7HLEEGaYZ6dxCEGgPKUyKIQS5Ujg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BcEf80k8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773872996; a=rsa-sha256;
	cv=none;
	b=6+S0dY0du0rR7ST49xfyZ83h0XbibzsC8O5o0iyY+1YJ+51BNRglCmMIlvjzVHwNKPngBe
	eFMoxCxr4ZmcvWya9s4CTqCq/ZAg0wLqx2baxMAETvpV4ifQVPL90W3czJ5nuXt+sRUBT+
	c23a7U8h5l4junoGs63oS30q/mlJZtI=
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-67bb5f989c4so248570eaf.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773872995; x=1774477795; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RRYnHpo8uKuUlS1v8ui4dqVxSU8CGxN8PZ2oQLxXs9Q=;
        b=BcEf80k8519rg5syvmIUI7i9RM0jAS1x/lA3jpDTPDiHD1LyWEiuPCvdW4rwbnGaAK
         hd1T9wFZqWRWOLk+zGLE52icA7IDFyw16JpoCEexTaR9ftzD1dgZljUrg2tUinxAV3oJ
         WB8N7ejfPVXkRIh3ue/YfODuLuRQ/Fmaq+PlK/TLCfXBUXjc1p9xzcPITF9TyhjfY5jQ
         06UzNBhk1uMJ/7qi/9d5qbOxlsrA+dLnYm0v3BAIKYx/vBcUiJ8lkF9P7P2296/65rzV
         JfCgjyBj8HhI+v4CJUmCGPB/INmG2GYGbdD+4tHQeBqEKeenqgt9ccrCxRuf89rf8mxI
         Thgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773872995; x=1774477795;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RRYnHpo8uKuUlS1v8ui4dqVxSU8CGxN8PZ2oQLxXs9Q=;
        b=PtbirDPI9cvfHl7j67ts5LSGjkVzkmTFGPt/+cavpPsK++b4yCcfGgvE3wiTsmjxYt
         EHLWpgOJBT5eGWqTz7jCXMD0KRYaaKCfQaozV9Syhpv8gR2IZuSE7e74kdMNpvECqFnA
         6c28+wEFYDralUHTk3EBdBuZvWHGhO1jlww9VwnB6bAfYFIdir0IYbU2d4jVGiITUuhy
         bq0LxEDIEJT3EKZ4R9juTz6Uso6JTxg+KA9Zhx9r5pWKMwEGoTaW+UcOqhmrBduqbfjN
         cnPZhWMiIzXQdwHBkqKUkuVqKUPCSOoc3fznBSz0fIDHN2fEx/Qc9/thgAEzDGYlOCC+
         rwlA==
X-Forwarded-Encrypted: i=1; AJvYcCUqRoXueN511cYsj2F7QteBSY8T9u//QSOIqbNiH/AoZ7SdoqcBUFOCXzwaMPvMozUponacDUnceQ==@kvack.org
X-Gm-Message-State: AOJu0YxWR2P0/Ho1NMCKrmx+yAQvbGQF9PWKeBkXoptfdrHzb0leTKrj
	iRe6YWxVb1whEEDtWX8htRh7IaQBH61I4WcMhfjG6NYNg88wLSpJxVNm
X-Gm-Gg: ATEYQzzEItd6LnSnXs4pefE9Hm2rQ5R1Lvi01a+Hei8kD6SN/zrLk1u2p9IJb6VVHoX
	vz0eEZvqhOFm6OgdvkIFHPpVEoH3k8fAg6s3k04t/QAwief9vKPcPSgYHYwk+UgJxeViyxL41eD
	ZZ/NJwK++4hG3jP+KapXKnox9oy4tdx6vqbEuKjrdDgEv+vN68e99FEAntfLadBBjiiQqjDdG+m
	FgKelfWvMNA/iiIlOF31Uj2a/vGu1jPl5hOt/neh1BwpmAnbFSZorUfx5r5YzIkUOXCyTgXrTJQ
	UB1U/h9CtdvZnvTFOTPIJ0gliCqUIln8vpkAZ63ecE0dUtPLtzainML5XuPo12qrZp0lWoKWunT
	1M2bm04ayx/rjriG6nEdJ+xkiOi7+Dubgo2T06yHv1Tl3/E63uOyX+XX9q5Vap7aPU/E9QeOE84
	Lp0lgEDs2gsHvBy3TqBPZ6nR326ZDY8Eo8g0OZzViL723b
X-Received: by 2002:a05:6820:3094:b0:67b:ab68:b5e2 with SMTP id 006d021491bc7-67c0daa2707mr3707316eaf.18.1773872994524;
        Wed, 18 Mar 2026 15:29:54 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67c0d89ca52sm2470471eaf.12.2026.03.18.15.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:29:53 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v4 00/21] Virtual Swap Space
Date: Wed, 18 Mar 2026 15:29:31 -0700
Message-ID: <20260318222953.441758-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F27C24000F
X-Stat-Signature: osok4xrb6qzfkjbjngped4efrdk4o316
X-Rspam-User: 
X-HE-Tag: 1773872995-309834
X-HE-Meta: U2FsdGVkX199ZE/1w2yrO5eyn1vfs3uCBtjo0nHnfF9EA+67yxz6UGCFbRPsdKVw1dHtLlVOF9VJm6C+7BRWIlHLNWhLfAbpUsQwP8Hs/IJIaIUq29b5Ee/wptJH4jeEdV2ehmKlFKRc7PlwLKN2KVyad6DDpOyRCU1HA3FveHYfvufmMblNEMqs6tN/V99m5d2YsR04cdaDTEboGB1eXh35ilv9wQ20Bj7qiWJjXmCabsZmoNxLqKpRj2UkfIwNXJ0DxC0zYtiqHwc71Fs3JdlE8HZuYWcQyghIr3w+iF9jtVmIP5aMudZQ/IFbFucWbC9Jf136j1n/Yim5CrJDzWWniTqV+XTg+f6SqGg3BYF0dM9neXwhucTzJGBtDSfsmg04ldLDqKFPm0jtidR63ClxjcHZxENUyIqHI3gGToTBPqAPtaoVZNsK3ziaIXvoTBTDdm6R/ce/dobSY5qMCf9+vqAP9DXAbc80YGobhakfVw+jAca8vI4ycK3Zd7heUjL0+iNuPawYYvgWp+MMIr9M3tJORD/YPOKqVmJxK51pFj2yLjX7G83KRRVs/HwZaowthXoIjSRkHSXpsjDg18l+aWaeV6c9mA5SqJL1O4YMI3EjS/UdQ3zxEBKTUEBUNn/LtEygTl60J1fLCT8gkNzS/rRQNV9ImYDnwQZ6kat+3LfONlKGMQ/+wckF7jOTqGhfggR6H1fgmndW+YHb8dQAw6onaXSYXBRe9SASIjq3lpyDgi5642BomMk1rryK50Xb3I9Ou4uVaS5oFVqFl85T9FaxY5XOoYxfmanPvmj4zUmkz9BugLngLH3KS+AFMwW+/m0eg4W0rk4F1DsHn2aMiuTNHshNbOsKO9x1QuRBuKW0ouQLmK1jT9cjMdcwqr2aeXDNJY7F9FURk1XDsw8bSFPrbL24W590oXoUU7Toceg1eWEYIW/iVXIkhpQYSM5fVFVwOGul+E8rUQU
 CqwhKf6t
 qckChxAgap+2Y6XJCX9yIBU4jhk9S2My2RVDvqZOxlKOS5Qq7LFgaciYMizh5XkCNuCiqLsYFdjGKhpged1hh3b4X8+Dug44XnEHcKqY4QL603VlUy2FJ65UmDEqvKT3HNO8G/ez7B6BJsjKYj1DLJQHw8wOYwb0vkX6uQo+B3XROwUeHAcrDMeEZ/tNkfKe6gnqfVbB96M8gOmwLgiUN0FwXhTvaiGTR+sJ/W3Rwpld8cEclVmw/vjFuFT3YlANXeZndYUuHyvOuTOfz9YpG+UWRS7CHzWldIbtpzBbu8hoOnHwvC0mHkL3/wCzxHtSt3Gb8aTgi4BQOvqxgtzRgZv4ZaS/yU7cFXe61FPLXRwSmOo5DyplQamEVwkqGQoWC8xBMnIvcxKQiyplV1qlSxdT4VybS3oxJOt+k/g/uDdMAvpq/eV2K5lYkULD46esd/evG5hoQUpGoqp96EanK6mzTQ6pDyoDv1mSSh+6L4PaYCbod8I3VHj9aQ38sHUETeGwFkb6vN6lxwpEk+FSWhYRRaUJKe0PaAZ6doXwfc/JC9G+Ev/BhObu16UwwsFHgLudmSDsHDjCcDsKf/Ay76j+0qS94a76/AZYbzAv3f80h9fcYfmS6OTZl6esJsAeXLlOzzvI72NDGEjfaPK50rAKRVnTBnjBs1UvbV0YFsaiyuEEgTqZ9uFbGYrztBO/nnwq7b7qlpmwQ85qC21rGXd3AtxbU0T6UrPmvECxtw4mZnPTc5gHB9EqtWiPm7/DTswjjy2wHOt/vecrLIPyV8pTJD5141hPff26JGrXqFltkdUV2fYSiS+869Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This patch series is based on 6.19. There are a couple more
swap-related changes in mainline that I would need to coordinate
with, but I still want to send this out as an update for the
regressions reported by Kairui Song in [15]. It's probably easier
to just build this thing rather than dig through that series of
emails to get the fix patch :)

Changelog:
* v3 -> v4:
    * Fix poor swap free batching behavior to alleviate a regression
      (reported by Kairui Song).
    * Fix assorted kernel build errors reported by kernel test robots
      in the case of CONFIG_SWAP=n.
* RFC v2 -> v3:
    * Implement a cluster-based allocation algorithm for virtual swap
      slots, inspired by Kairui Song and Chris Li's implementation, as
      well as Johannes Weiner's suggestions. This eliminates the lock
	  contention issues on the virtual swap layer.
    * Re-use swap table for the reverse mapping.
    * Remove CONFIG_VIRTUAL_SWAP.
    * Reducing the size of the swap descriptor from 48 bytes to 24
      bytes, i.e another 50% reduction in memory overhead from v2.
    * Remove swap cache and zswap tree and use the swap descriptor
      for this.
    * Remove zeromap, and replace the swap_map bytemap with 2 bitmaps
      (one for allocated slots, and one for bad slots).
    * Rebase on top of 6.19 (7d0a66e4bb9081d75c82ec4957c50034cb0ea449)
	* Update cover letter to include new benchmark results and discussion
	  on overhead in various cases.
* RFC v1 -> RFC v2:
    * Use a single atomic type (swap_refs) for reference counting
      purpose. This brings the size of the swap descriptor from 64 B
      down to 48 B (25% reduction). Suggested by Yosry Ahmed.
    * Zeromap bitmap is removed in the virtual swap implementation.
      This saves one bit per physical swapfile slot.
    * Rearrange the patches and the code change to make things more
      reviewable. Suggested by Johannes Weiner.
    * Update the cover letter a bit.

This patch series implements the virtual swap space idea, based on Yosry's
proposals at LSFMMBPF 2023 (see [1], [2], [3]), as well as valuable
inputs from Johannes Weiner. The same idea (with different
implementation details) has been floated by Rik van Riel since at least
2011 (see [8]).


I. Motivation

Currently, when an anon page is swapped out, a slot in a backing swap
device is allocated and stored in the page table entries that refer to
the original page. This slot is also used as the "key" to find the
swapped out content, as well as the index to swap data structures, such
as the swap cache, or the swap cgroup mapping. Tying a swap entry to its
backing slot in this way is performant and efficient when swap is purely
just disk space, and swapoff is rare.

However, the advent of many swap optimizations has exposed major
drawbacks of this design. The first problem is that we occupy a physical
slot in the swap space, even for pages that are NEVER expected to hit
the disk: pages compressed and stored in the zswap pool, zero-filled
pages, or pages rejected by both of these optimizations when zswap
writeback is disabled. This is the arguably central shortcoming of
zswap:
* In deployments when no disk space can be afforded for swap (such as
  mobile and embedded devices), users cannot adopt zswap, and are forced
  to use zram. This is confusing for users, and creates extra burdens
  for developers, having to develop and maintain similar features for
  two separate swap backends (writeback, cgroup charging, THP support,
  etc.). For instance, see the discussion in [4].
* Resource-wise, it is hugely wasteful in terms of disk usage. At Meta,
  we have swapfile in the order of tens to hundreds of GBs, which are
  mostly unused and only exist to enable zswap usage and zero-filled
  pages swap optimizations.
* Tying zswap (and more generally, other in-memory swap backends) to
  the current physical swapfile infrastructure makes zswap implicitly
  statically sized. This does not make sense, as unlike disk swap, in
  which we consume a limited resource (disk space or swapfile space) to
  save another resource (memory), zswap consume the same resource it is
  saving (memory). The more we zswap, the more memory we have available,
  not less. We are not rationing a limited resource when we limit
  the size of the zswap pool, but rather we are capping the resource
  (memory) saving potential of zswap. Under memory pressure, using
  more zswap is almost always better than the alternative (disk IOs, or
  even worse, OOMs), and dynamically sizing the zswap pool on demand
  allows the system to flexibly respond to these precarious scenarios.
* Operationally, static provisioning the swapfile for zswap pose
  significant challenges, because the sysadmin has to prescribe how
  much swap is needed a priori, for each combination of
  (memory size x disk space x workload usage). It is even more
  complicated when we take into account the variance of memory
  compression, which changes the reclaim dynamics (and as a result,
  swap space size requirement). The problem is further exacerbated for
  users who rely on swap utilization (and exhaustion) as an OOM signal.

  All of these factors make it very difficult to configure the swapfile
  for zswap: too small of a swapfile and we risk preventable OOMs and
  limit the memory saving potentials of zswap; too big of a swapfile
  and we waste disk space and memory due to swap metadata overhead.
  This dilemma becomes more drastic in high memory systems, which can
  have up to TBs worth of memory.

Past attempts to decouple disk and compressed swap backends, namely the
ghost swapfile approach (see [13]), as well as the alternative
compressed swap backend zram, have mainly focused on eliminating the
disk space usage of compressed backends. We want a solution that not
only tackles that same problem, but also achieve the dynamicization of
swap space to maximize the memory saving potentials while reducing
operational and static memory overhead.

Finally, any swap redesign should support efficient backend transfer,
i.e without having to perform the expensive page table walk to
update all the PTEs that refer to the swap entry:
* The main motivation for this requirement is zswap writeback. To quote
  Johannes (from [14]): "Combining compression with disk swap is
  extremely powerful, because it dramatically reduces the worst aspects
  of both: it reduces the memory footprint of compression by shedding
  the coldest data to disk; it reduces the IO latencies and flash wear
  of disk swap through the writeback cache. In practice, this reduces
  *average event rates of the entire reclaim/paging/IO stack*."
* Another motivation is to simplify swapoff, which is both complicated
  and expensive in the current design, precisely because we are storing
  an encoding of the backend positional information in the page table,
  and thus requires a full page table walk to remove these references.


II. High Level Design Overview

To fix the aforementioned issues, we need an abstraction that separates
a swap entry from its physical backing storage. IOW, we need to
“virtualize” the swap space: swap clients will work with a dynamically
allocated virtual swap slot, storing it in page table entries, and
using it to index into various swap-related data structures. The
backing storage is decoupled from the virtual swap slot, and the newly
introduced layer will “resolve” the virtual swap slot to the actual
storage. This layer also manages other metadata of the swap entry, such
as its lifetime information (swap count), via a dynamically allocated,
per-swap-entry descriptor:

struct swp_desc {
        union {
                swp_slot_t         slot;                 /*     0     8 */
                struct zswap_entry * zswap_entry;        /*     0     8 */
        };                                               /*     0     8 */
        union {
                struct folio *     swap_cache;           /*     8     8 */
                void *             shadow;               /*     8     8 */
        };                                               /*     8     8 */
        unsigned int               swap_count;           /*    16     4 */
        unsigned short             memcgid:16;           /*    20: 0  2 */
        bool                       in_swapcache:1;       /*    22: 0  1 */

        /* Bitfield combined with previous fields */

        enum swap_type             type:2;               /*    20:17  4 */

        /* size: 24, cachelines: 1, members: 6 */
        /* bit_padding: 13 bits */
        /* last cacheline: 24 bytes */
};

(output from pahole).

This design allows us to:
* Decouple zswap (and zeromapped swap entry) from backing swapfile:
  simply associate the virtual swap slot with one of the supported
  backends: a zswap entry, a zero-filled swap page, a slot on the
  swapfile, or an in-memory page.
* Simplify and optimize swapoff: we only have to fault the page in and
  have the virtual swap slot points to the page instead of the on-disk
  physical swap slot. No need to perform any page table walking.

The size of the virtual swap descriptor is 24 bytes. Note that this is
not all "new" overhead, as the swap descriptor will replace:
* the swap_cgroup arrays (one per swap type) in the old design, which
  is a massive source of static memory overhead. With the new design,
  it is only allocated for used clusters.
* the swap tables, which holds the swap cache and workingset shadows.
* the zeromap bitmap, which is a bitmap of physical swap slots to
  indicate whether the swapped out page is zero-filled or not.
* huge chunk of the swap_map. The swap_map is now replaced by 2 bitmaps,
  one for allocated slots, and one for bad slots, representing 3 possible
  states of a slot on the swapfile: allocated, free, and bad.
* the zswap tree.

So, in terms of additional memory overhead:
* For zswap entries, the added memory overhead is rather minimal. The
  new indirection pointer neatly replaces the existing zswap tree.
  We really only incur less than one word of overhead for swap count
  blow up (since we no longer use swap continuation) and the swap type.
* For physical swap entries, the new design will impose fewer than 3 words
  memory overhead. However, as noted above this overhead is only for
  actively used swap entries, whereas in the current design the overhead is
  static (including the swap cgroup array for example).

  The primary victim of this overhead will be zram users. However, as
  zswap now no longer takes up disk space, zram users can consider
  switching to zswap (which, as a bonus, has a lot of useful features
  out of the box, such as cgroup tracking, dynamic zswap pool sizing,
  LRU-ordering writeback, etc.).

For a more concrete example, suppose we have a 32 GB swapfile (i.e.
8,388,608 swap entries), and we use zswap.

0% usage, or 0 entries: 0.00 MB
* Old design total overhead: 25.00 MB
* Vswap total overhead: 0.00 MB

25% usage, or 2,097,152 entries:
* Old design total overhead: 57.00 MB
* Vswap total overhead: 48.25 MB

50% usage, or 4,194,304 entries:
* Old design total overhead: 89.00 MB
* Vswap total overhead: 96.50 MB

75% usage, or 6,291,456 entries:
* Old design total overhead: 121.00 MB
* Vswap total overhead: 144.75 MB

100% usage, or 8,388,608 entries:
* Old design total overhead: 153.00 MB
* Vswap total overhead: 193.00 MB

So even in the worst case scenario for virtual swap, i.e when we
somehow have an oracle to correctly size the swapfile for zswap
pool to 32 GB, the added overhead is only 40 MB, which is a mere
0.12% of the total swapfile :)

In practice, the overhead will be closer to the 50-75% usage case, as
systems tend to leave swap headroom for pathological events or sudden
spikes in memory requirements. The added overhead in these cases are
practically negligible. And in deployments where swapfiles for zswap
are previously sparsely used, switching over to virtual swap will
actually reduce memory overhead.

Doing the same math for the disk swap, which is the worst case for
virtual swap in terms of swap backends:

0% usage, or 0 entries: 0.00 MB
* Old design total overhead: 25.00 MB
* Vswap total overhead: 2.00 MB

25% usage, or 2,097,152 entries:
* Old design total overhead: 41.00 MB
* Vswap total overhead: 66.25 MB

50% usage, or 4,194,304 entries:
* Old design total overhead: 57.00 MB
* Vswap total overhead: 130.50 MB

75% usage, or 6,291,456 entries:
* Old design total overhead: 73.00 MB
* Vswap total overhead: 194.75 MB

100% usage, or 8,388,608 entries:
* Old design total overhead: 89.00 MB
* Vswap total overhead: 259.00 MB

The added overhead is 170MB, which is 0.5% of the total swapfile size,
again in the worst case when we have a sizing oracle.

Please see the attached patches for more implementation details.


III. Usage and Benchmarking

This patch series introduce no new syscalls or userspace API. Existing
userspace setups will work as-is, except we no longer have to create a
swapfile or set memory.swap.max if we want to use zswap, as zswap is no
longer tied to physical swap. The zswap pool will be automatically and
dynamically sized based on memory usage and reclaim dynamics.

To measure the performance of the new implementation, I have run the
following benchmarks:

1. Kernel building: 52 workers (one per processor), memory.max = 3G.

Using zswap as the backend:

Baseline:
real: mean: 164.29s, stdev: 0.53s
user: mean: 5109.06s, stdev: 2.04s
sys: mean: 672.62s, stdev: 30.46s

Vswap:
real: mean: 164.12s, stdev: 0.4s
user: mean: 5105.24s, stdev: 2.01s
sys: mean: 668.66s, stdev: 34.45s

Using SSD swap as the backend:

Baseline:
real: mean: 189.74s, stdev: 2.03s
user: mean: 5035.93s, stdev: 3.1s
sys: mean: 500.01s, stdev: 4.16s

Vswap:
real: mean: 190.18s, stdev: 4.35s
user: mean: 5038.26s, stdev: 7.39s
sys: mean: 497.09s, stdev: 12.3s

The performance is neck-to-neck for both swap backends, with vswap
slightly edging out in systime. However, the variance is high, so it is
hard to draw a definitive conclusion.

2. Usemem: Per a report from Kairui Song ([15]), I have run the
   following benchmark:

Memory state of the system:

free -m
               total        used        free      shared  buff/cache   available
Mem:           31596        5094       11667          19       15302       26502
Swap:          65535          33       65502

Running the usemem benchmark with n = 1, 56G for 5 times, and average
out the result:

Baseline (6.19):
real: mean: 190.93s, stdev: 5.09s
user: mean: 46.62s, stdev: 0.27s
sys: mean: 128.51s, stdev: 5.17s
throughput: mean: 382093 KB/s, stdev: 11173.6 KB/s
free time: mean: 7916690.2 usecs, stdev: 88923.0 usecs

VSS:
real: mean: 187.66s, stdev: 5.67s
user: mean: 46.5s, stdev: 0.16s
sys: mean: 125.3s, stdev: 5.58s
throughput: mean: 387506.4 KB/s, stdev: 12556.56 KB/s
free time: mean: 7029733.8 usecs, stdev: 124661.34 usecs


IV. Future Use Cases

While the patch series focus on two applications (decoupling swap
backends and swapoff optimization/simplification), this new,
future-proof design also allows us to implement new swap features more
easily and efficiently:

* Multi-tier swapping (as mentioned in [5]), with transparent
  transferring (promotion/demotion) of pages across tiers (see [8] and
  [9]). Similar to swapoff, with the old design we would need to
  perform the expensive page table walk.
* Swapfile compaction to alleviate fragmentation (as proposed by Ying
  Huang in [6]).
* Mixed backing THP swapin (see [7]): Once you have pinned down the
  backing store of THPs, then you can dispatch each range of subpages
  to appropriate backend swapin handler.
* Swapping a folio out with discontiguous physical swap slots
  (see [10]).
* Zswap writeback optimization: The current architecture pre-reserves
  physical swap space for pages when they enter the zswap pool, giving
  the kernel no flexibility at writeback time. With the virtual swap
  implementation, the backends are decoupled, and physical swap space
  is allocated on-demand at writeback time, at which point we can make
  much smarter decisions: we can batch multiple zswap writeback
  operations into a single IO request, allocating contiguous physical
  swap slots for that request. We can even perform compressed writeback
  (i.e writing these pages without decompressing them) (see [12]).


V. References

[1]: https://lore.kernel.org/all/CAJD7tkbCnXJ95Qow_aOjNX6NOMU5ovMSHRC+95U4wtW6cM+puw@mail.gmail.com/
[2]: https://lwn.net/Articles/932077/
[3]: https://www.youtube.com/watch?v=Hwqw_TBGEhg
[4]: https://lore.kernel.org/all/Zqe_Nab-Df1CN7iW@infradead.org/
[5]: https://lore.kernel.org/lkml/CAF8kJuN-4UE0skVHvjUzpGefavkLULMonjgkXUZSBVJrcGFXCA@mail.gmail.com/
[6]: https://lore.kernel.org/linux-mm/87o78mzp24.fsf@yhuang6-desk2.ccr.corp.intel.com/
[7]: https://lore.kernel.org/all/CAGsJ_4ysCN6f7qt=6gvee1x3ttbOnifGneqcRm9Hoeun=uFQ2w@mail.gmail.com/
[8]: https://lore.kernel.org/linux-mm/4DA25039.3020700@redhat.com/
[9]: https://lore.kernel.org/all/CA+ZsKJ7DCE8PMOSaVmsmYZL9poxK6rn0gvVXbjpqxMwxS2C9TQ@mail.gmail.com/
[10]: https://lore.kernel.org/all/CACePvbUkMYMencuKfpDqtG1Ej7LiUS87VRAXb8sBn1yANikEmQ@mail.gmail.com/
[11]: https://lore.kernel.org/all/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmjXHGBnfisCAb8VA@mail.gmail.com/
[12]: https://lore.kernel.org/linux-mm/ZeZSDLWwDed0CgT3@casper.infradead.org/
[13]: https://lore.kernel.org/all/20251121-ghost-v1-1-cfc0efcf3855@kernel.org/
[14]: https://lore.kernel.org/linux-mm/20251202170222.GD430226@cmpxchg.org/
[15]: https://lore.kernel.org/linux-mm/CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com/

