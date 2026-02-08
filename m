Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A7E0EF06EE
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 00:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06236B0089; Sun,  8 Feb 2026 19:13:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5046B0092; Sun,  8 Feb 2026 19:13:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C5F6B0093; Sun,  8 Feb 2026 19:13:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 827226B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 19:13:27 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 188E38C195
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 00:13:27 +0000 (UTC)
X-FDA: 84422994054.06.CCF86A2
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3A34080005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 00:13:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mi6VgRto;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770596005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtTYHyEge4pUKaUw8hrDfhamg3jMtsci/lInRX1QlCc=;
	b=iHeGrlRjX4u+DbZFjJubZDktpe5p6HyhJOWpHoKKEqqDl4UXM7G1d4P5HNJ6ntHVp78g+K
	DiSaCJLIcyWeOfHuvQ89kV8TW3lGUnm7OuHFMPzCR+Olu5yvD/P6Gk8qCwsjuxnVNbZCBU
	MEXllkhN6HWag7nmFhSxeq0jfatUB8c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770596005; a=rsa-sha256;
	cv=none;
	b=r23r1HVvw1YuVRFNPdPiyQ1ZI2EYXyIHWhA79iurDZEMOihp3ko4vWuCB89rydp793OPdU
	nS+tqhNDUywBeRrLF1nowtO7J81Do1dNYo9yEASRJfmEo6B8PxPr4Oik91S411DEi84GEL
	o41GtnVSyB6rXbcbri+tcX8ZoMRT3wM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mi6VgRto;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8c6d76b9145so421405285a.2
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 16:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770596004; x=1771200804; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BtTYHyEge4pUKaUw8hrDfhamg3jMtsci/lInRX1QlCc=;
        b=mi6VgRtoLGURiHpnv7yJYqtNhZvwdwfbMTyotQqdPq+rb9+0NTrpgJm8MGfKlMlGey
         GKSdYwNE6JlFc96dTzVJwd0yra5ci/uMQ/6BBHc1PkuSUPyM5ieSVBHO1BS1/oENtHuF
         Y9wYuPFddrEliq1vhdTvH7XQ/rTsJ9VM1wtNxS6we/tv5wwSe2OEy/jX3TuLy1xTpJjr
         Uh6Q65YDpVb3vJjFkD1R5/nneF6UXP4h2zP8qrQdNdA7P7GKXss/b6Ovg6stABR2K/AO
         +ckSe50QwRlQGkgXi1eyiTOtcm75HmuAj9Fk4Xeb2rNWItzNP8hVswl2kUKX8FkqwEdy
         Rcfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770596004; x=1771200804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BtTYHyEge4pUKaUw8hrDfhamg3jMtsci/lInRX1QlCc=;
        b=eT7EGi/vpGs5YDQrWJqQfw1wHletjhm20cfeO+wjOFDxONeRxu4P9Pta7p1Hg4JtQi
         cmYdI0PJUxhE1qniFoC88jJuOLTAsWQVECIwoDQdDX+HLFR/EqjOdkBWNnO3GOGo804Z
         i2+0+cCDajCLcHQ15vmI5rln5yScL3kucLHHpKopCf6KclYXzQZ+7/SENb4YNJ1Tm4WU
         7kcIdF38gJhWfzd18SycRBhBJrWzFOh/deb82R90FGflzv1gAWzywbtJpgTkJ264eM3V
         pAomc3qeaUknRL7LFdZb7P4pGSjM07dqfSKw/26uTnoeZv7pPosB/+WSDE8jlxD38tsk
         ANjw==
X-Gm-Message-State: AOJu0YxvtTwug0M66ccT23Tc/lLmbhxbx2YlH6F4AbJ/m+OlQSP6fuYV
	IoJ0K7ynmMQkeO9JS52U1PZp6l+czyPsZcgn8G4ClF76YiZWIpSUext0MEXB8HHEep291w==
X-Gm-Gg: AZuq6aLm3toFjVI1zKs8wB8c4qJnjJ7uYhs/O+sfBzTZtO7XuN3S+u05PbKM72GRVEu
	QeAHSedTphWHx3HzqhS5E3EyJ4IgpI55ownH4OT/E7edgnWdY9GbW6NYzbgXSwISbmGl3LKY5kp
	wQziZLcn+jONTF0ZX6JmqLY0zY9iy/Q1TFxSJBz/D30xF8Q4Lu4PFmz6Elrvh50MoIzhiB2irjh
	aZbTHEdDI/K4qd3uHlRs0zflSTHyAaUxUI4UMrgrezSqoRxBDAXAyLvECad5/i6BZE61Yk6JD82
	AKCgnVmsv0D+2f2Y8+Mt/OLFtAJ5Pnhb7P3O2/p+Xlf8zM5bHabZCWJpP7Zxe95AgvLvd3GvOn6
	8pcJpmzJHAHZMi1fwjA1rMMz+3TBTGGwjJVi4PD9nn0cHebwv/50ElnQluyj3MjiI7n4OCBNIkK
	IVRe6qqy4eVvWoQxOMoB9O384Nko2tx8VE7w==
X-Received: by 2002:a05:6830:668e:b0:7cf:d8c1:8e19 with SMTP id 46e09a7af769-7d46467dbaamr3651113a34.25.1770589614446;
        Sun, 08 Feb 2026 14:26:54 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:40::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d46470df08sm6831992a34.8.2026.02.08.14.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 14:26:53 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	yosry.ahmed@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	len.brown@intel.com,
	chengming.zhou@linux.dev,
	kasong@tencent.com,
	chrisl@kernel.org,
	huang.ying.caritas@gmail.com,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	baohua@kernel.org,
	bhe@redhat.com,
	osalvador@suse.de,
	christophe.leroy@csgroup.eu,
	pavel@kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org,
	peterx@redhat.com,
	riel@surriel.com,
	joshua.hahnjy@gmail.com,
	npache@redhat.com,
	gourry@gourry.net,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rafael@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: [PATCH v3 00/20] Virtual Swap Space
Date: Sun,  8 Feb 2026 14:26:50 -0800
Message-ID: <20260208222652.328284-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-2-nphamcs@gmail.com>
References: <20260208215839.87595-2-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3A34080005
X-Stat-Signature: 4qhfmu841hbze6nd8xm6htjuoh96zaxp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770596005-553255
X-HE-Meta: U2FsdGVkX1/QmmtE9ycpw8p6aDucyR8leMK10rywK08WXHxtGHSsw2Y1Ow8Vu5DpMj2jUlOHdLoHhCwvYxKaA2bfQxT5kefQNyxL+k+h+p4kr12BLcpwPhrT7kDYXIQmRxzl2ViYGV23znrbMpqN1jFNEeyEeLhIwJdg1XG9hVBl6OV7a/BA1qtGOy/+E0VmbL8Wost34SKK/ZtY0+ao+jkZPjfnN0qabTropQpQE5w3zbnw3o5g5nHn05Uv8HcQiNZhGP+k+QkpINdHbGWdWsKd4+TNI+EFIvK/AGfqdNk1MSWjkPgGPv0YNY9uG8Gd0lTVtSEreUpo6p+jHOejI46EBWyQpJPcGJnxPpvBmGeCeZdcufS4kd3KRuHvMVn/fV9cYz+8Vn4LU4r4O5VUlgveMlxM2U03cdcOOev43/bQnKMn2bX4WS7M3JtKKMaNtronAuXwMS1h1Ongp5KpKmNRAuxZrpuczcOgTqq7OsJToZY/dhuhCu+p1ganajaO8g7nPHYrSoZVS1lS4DRe/xIcI9YwCVMFar50JdPKPg8kqi9eXu4oFcCWC6d7UAmB6O2gNMO/wtOUxd8frXoK1AAlFgEwJrI/VOkO/3U5jOmvAwqJAR7z2ahZ8WVBrrERN+U9oM8xVVDhelPwR8zw+cCpjZvcAfR84BmXMEJAvWCKyN8+89pZHs7RsuCcCfzh8gE0DWooNl5QeOogPIAlJohykGZb3J6aBbswkiZcMdcDeFVIqNka8+RpkBIBaAJDgksKhFMbTktIeL4igdEWyEGAgnaS8KCanRzCWayFDdQxMiSGe2Cz/Pmxm56j6ur13OEC1iwZUg7+0/TtgPcoJ0g8VciFzzMYQ2pECddngQUUILPlOWgxZYuZJElB+wg+ICLg+uJWxps9LuQHCv2hL3G6O5G+VDPo+58W2iz/5W18QTpjzVN6pF16JO4RCRxhzkfeUpXhVW2iGy6IFCx
 xZAplSBG
 6tqXpX9UIVsAjRXsOTSMqmT3EpWv1XXXwiAWD35YG+0eoU8yZSsoat//rQKlDn9wXyiLZFcgoTofWzatIZZeaaE0ZoO0NTygO1kmQ0J87aDwx/9sCT0Jpr+794Sgj9wAL1Yr1IrvOQirpm6FjrH3BiFakZm86Wa1uRocDNiS+BoI00JAZ6w91Y2kVuZu5qh2qsWg/5YWeqprUpZJcwOF4Y4mByEQ99Sp5b+N/Zb6fWOCP8PSblJ79kuZ7+EBySciwII1tLPCtpRA+crZzll875YXKMhMV4P7R9EYeHvG0SHQdOIJohoR7Ic12Dgp1xOk80XhQuBj66k13KHZqxER6OUX4k9Nq73zVaolD3Pp/tU0ADO7+bscdoFdvbGNlui9JDV1mYWPJ19v+AWVTMwqgBddYtqM0NeNB+pxNROPw8Fd6gZtdbXXx7Id+uDMR4MrEFwpKd3K7K1zD8uXpD9Oo4tzPE6i3yCci8v9W07Aov0bl3X5OmAERXOeyyQEnBzedCZl/plUi025yuxqyFgrJg1+Q9fFSybrCBcvqx1sIvk7vxT9EpgwKhHEqgpEft/BQ9bnpb0C9lG1LetEGZXiwGAUxutOK787MhptIrCUnJ1w+/7l17nECIf2T3mTKh9JZ2bdenwg72266FVClRLT2v/yDMnxV/DMNS04+JDDK8oTj5J5Lqjsd1mQt1JTBjr3iMcwF7DSiRGZzd+PUTwmakSX92hTcF/MNqB191r4D6TxkHHx/ihWXTFFUlmj3tOVSFsud/Bi1tsPAUtMTpjTSzdFNtmKb0BAocGc0z3ScDteKzqp5kFGkDT/vWmAx6lBCgKa9a51wscPzK7lNeBflF1fRQCwR2q/T4m4yrn9QAvJcbXKPgreZ6BKw1qufWdeh4GunjnVF++/1XPE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

My sincerest apologies - it seems like the cover letter (and just the
cover letter) fails to be sent out, for some reason. I'm trying to figure
out what happened - it works when I send the entire patch series to
myself...

Anyway, resending this (in-reply-to patch 1 of the series):

Changelog:
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
      This saves one bit per phyiscal swapfile slot.
    * Rearrange the patches and the code change to make things more
      reviewable. Suggested by Johannes Weiner.
    * Update the cover letter a bit.

This patch series implements the virtual swap space idea, based on Yosry's
proposals at LSFMMBPF 2023 (see [1], [2], [3]), as well as valuable
inputs from Johannes Weiner. The same idea (with different
implementation details) has been floated by Rik van Riel since at least
2011 (see [8]).

This patch series is based on 6.19. There are a couple more
swap-related changes in the mm-stable branch that I would need to
coordinate with, but I would like to send this out as an update, to show
that the lock contention issues that plagued earlier versions have been
resolved and performance on the kernel build benchmark is now on-par with
baseline. Furthermore, memory overhead has been substantially reduced
compared to the last RFC version.


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
  the size of he zswap pool, but rather we are capping the resource
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
  swap space size requirement). The problem is further exarcebated for
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
only tackles that same problem, but also achieve the dyamicization of
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
practically neglible. And in deployments where swapfiles for zswap
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
real: mean: 185.2s, stdev: 0.93s
sys: mean: 683.7s, stdev: 33.77s

Vswap:
real: mean: 184.88s, stdev: 0.57s
sys: mean: 675.14s, stdev: 32.8s

We actually see a slight improvement in systime (by 1.5%) :) This is
likely because we no longer have to perform swap charging for zswap
entries, and virtual swap allocator is simpler than that of physical
swap.

Using SSD swap as the backend:

Baseline:
real: mean: 200.3s, stdev: 2.33s
sys: mean: 489.88s, stdev: 9.62s

Vswap:
real: mean: 201.47s, stdev: 2.98s
sys: mean: 487.36s, stdev: 5.53s

The performance is neck-to-neck.


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

Nhat Pham (20):
  mm/swap: decouple swap cache from physical swap infrastructure
  swap: rearrange the swap header file
  mm: swap: add an abstract API for locking out swapoff
  zswap: add new helpers for zswap entry operations
  mm/swap: add a new function to check if a swap entry is in swap
    cached.
  mm: swap: add a separate type for physical swap slots
  mm: create scaffolds for the new virtual swap implementation
  zswap: prepare zswap for swap virtualization
  mm: swap: allocate a virtual swap slot for each swapped out page
  swap: move swap cache to virtual swap descriptor
  zswap: move zswap entry management to the virtual swap descriptor
  swap: implement the swap_cgroup API using virtual swap
  swap: manage swap entry lifecycle at the virtual swap layer
  mm: swap: decouple virtual swap slot from backing store
  zswap: do not start zswap shrinker if there is no physical swap slots
  swap: do not unnecesarily pin readahead swap entries
  swapfile: remove zeromap bitmap
  memcg: swap: only charge physical swap slots
  swap: simplify swapoff using virtual swap
  swapfile: replace the swap map with bitmaps

 Documentation/mm/swap-table.rst |   69 --
 MAINTAINERS                     |    2 +
 include/linux/cpuhotplug.h      |    1 +
 include/linux/mm_types.h        |   16 +
 include/linux/shmem_fs.h        |    7 +-
 include/linux/swap.h            |  135 ++-
 include/linux/swap_cgroup.h     |   13 -
 include/linux/swapops.h         |   25 +
 include/linux/zswap.h           |   17 +-
 kernel/power/swap.c             |    6 +-
 mm/Makefile                     |    5 +-
 mm/huge_memory.c                |   11 +-
 mm/internal.h                   |   12 +-
 mm/memcontrol-v1.c              |    6 +
 mm/memcontrol.c                 |  142 ++-
 mm/memory.c                     |  101 +-
 mm/migrate.c                    |   13 +-
 mm/mincore.c                    |   15 +-
 mm/page_io.c                    |   83 +-
 mm/shmem.c                      |  215 +---
 mm/swap.h                       |  157 +--
 mm/swap_cgroup.c                |  172 ---
 mm/swap_state.c                 |  306 +----
 mm/swap_table.h                 |   78 +-
 mm/swapfile.c                   | 1518 ++++-------------------
 mm/userfaultfd.c                |   18 +-
 mm/vmscan.c                     |   28 +-
 mm/vswap.c                      | 2025 +++++++++++++++++++++++++++++++
 mm/zswap.c                      |  142 +--
 29 files changed, 2853 insertions(+), 2485 deletions(-)
 delete mode 100644 Documentation/mm/swap-table.rst
 delete mode 100644 mm/swap_cgroup.c
 create mode 100644 mm/vswap.c


base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
-- 
2.47.3

