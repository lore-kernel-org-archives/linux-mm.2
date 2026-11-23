Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C5E0606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0QPGWew+
Received: by kanga.kvack.org (Postfix)
	id 934756B05B2; Mon, 23 Nov 2026 09:16:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4CA6B05B7; Mon, 23 Nov 2026 09:16:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D37B6B05B8; Mon, 23 Nov 2026 09:16:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 478566B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:16:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B41E9A80C5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:16:04 +0000 (UTC)
X-FDA: 85466583048.13.2E604E2
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id D545980008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:16:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0QPGWew+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443362;
	b=oE/ALiHlfGCcqVC2Zvx3qIogZy/UWuYK2hN7hjR8uhgW1oT2+ZOcm2JtDxkIPhLKdQc4Ut
	DOPXGohE+vQ6/m1k25hR0LG4Yty0fNTLecCAZU5eDewg1FpBkTL5G8Qrul9oL2QcQFg+Do
	mZ6jiy8/U4O2nNMHyDqJ3OZ2Qc6TLeA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PjRuNUOgfB3Fg1Fm9BbnbhhqY+ZgAzXM9O/HQJjsyY0=;
	b=M2/R+ou8g9XMCVHvPNd9pICRk1vMZyfEp4CG3CZ6stvZf9YuTqw95rfKbGNxhmMQN15ouS
	67aQLYXPaO0Mq2M7r9ps+65QkcP946tCfrBJ9rxjGWBDPHnCOmiJOva56LuLgo0Ak64pB8
	P1GpFGQNo9CyDLp5GRxxFVBPwkrMv9g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0QPGWew+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-14394530ec6so4848606c88.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443360; x=1796048160; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PjRuNUOgfB3Fg1Fm9BbnbhhqY+ZgAzXM9O/HQJjsyY0=;
        b=0QPGWew+hygUV7ZtGeimFXWRMQmqEhlL2VskAStZFS66smQYaMdlEat6x5ausukNEh
         1QFen+LrRnw5Ahzy1Qd9rvZANf+uF3YaebvAQ9p8NP2cqqS4FZYjOX1LpsvDHjf9yYhA
         kR3G5k+4Nmkd/eniYo4AC9GB3deRHByutP120+GFLha3qNOPUz2LMoALKadY08gnpbHN
         IX/lELR5ULRf4lHM66khI1Aeqi48DG8zdp6G2B1X6S8aaxEzh5WZNYsUGWubJvXN8P33
         VoAB/1gB+N/S/V86ZgeDL62SwOZ/zahigSAFASVdnatmQW3q4D7d8Pb93EwJ5GT0AMzQ
         f0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443360; x=1796048160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PjRuNUOgfB3Fg1Fm9BbnbhhqY+ZgAzXM9O/HQJjsyY0=;
        b=lKeeTErDVvRC6JdKEIWg5RVj+BocDPXCexcJp1fSGHoeHsJpyFmzb3zolSLIJKq6uY
         3VyDT6O6L9Cu+nQS8NLxyP5ywArsoV7DZHzce+4t++grPihkrVHghkRzPCY9zOriJzIM
         PksfzlHAt48VPJodfTVvSOte6w+bXBBPHIlt2R5B8g/UCJBgvua/FO6Fe05CntV65sW6
         r+M2ZyUleNhfx29upQOHhIxSWZFk57SaLw0/FyY5pmNbu3Bd7J0V4xMFAlqK0xJXmd4z
         aFM/GfJKWZ8mAO/j8lDapyNjMJNOehcDGvNWXDRUBsaCO63E7txZ/Bm/BU6xvP2fEOeS
         pWFQ==
X-Gm-Message-State: APuU4Z8ievkmo/ITJujwpfWO+ZCkdnRMbtH/eO8GeBSyE5iofefym/Or
	LuUp6+q8Z5094jJ4N8t5mNb6IGascilJz2pn+7uQSTE/CxfoOze740RDHEfHWlkC
X-Gm-Gg: AZFdTZePt1OjiCpPL7QEVi4L8Ur0QLR6X/UTe9Ho+/sQyb69xLfLbS2hw9B2mp7NHJi
	HVlogjTFMaEH1cunPZVilp2LUgVJLOZwhmnIrnVCQZ9u9lIqnqIgsBIo6qBedPyvgts+p/GzOHf
	5IOezqVgk8b6F2I7kRoa4lpvuD8JSnjmi+foc5EgtA+wJ9PL4A+MeFX5V594UWyjoybbzfwVqUa
	mwtI7ho2X8SPpc8pxYL5pLGgTu+ZP1ZsBibQTWOpzr0a3/pwwz2dbT2ZAxGjr0IX6+deWqthuoA
	ut+SCXxqwR8nC6RX6hQ548uvwLVAE1HjoitIN8c+f4Y4ibP9BEhNgskcbMA3AH77ds+jbsDyDsD
	sYtIkgnoyvZNmlCsYoZEROry9XN2ea0Qc9Yhpq++9R2eR6EvYpkh0/q65x6snHFim6MS/vhNePy
	p7lj9bBoeVAQWoSDP2WWaxhjxv/AEVY89H5pRio7dc3eAnZkSoqvlfpAw1V3I6R0KFPtx6/y6Pj
	gMYaTlOOSWy1oDZAKHMoREUd2JAdRDd9WhA0hbJtFACv28kL3lhOnbFPjvsB+27ZRcIGLadVNNW
	pp2KNXWBAC2xbncri19qETdwTKY0RdyryDZ0Cleyplk49S0r+DQYej35l0IYtkI21+GJ
X-Received: by 2002:a05:7022:f509:b0:1a4:4194:fc04 with SMTP id a92af1059eb24-1b5568e4322mr11657910c88.28.1795443360380;
        Mon, 23 Nov 2026 06:16:00 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ff27bsm31101950c88.6.2026.11.23.06.15.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:16:00 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 00/19] mm/swap: introduce priority queues for swap device allocation
Date: Mon, 23 Nov 2026 22:15:50 +0800
Message-ID: <cover.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p9958o6q5t8xr63p445kidtnjtyirp1q
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D545980008
X-HE-Tag: 1795443361-576084
X-HE-Meta: U2FsdGVkX18aNLFyCMGyBWeWgqN6N7liL9bMSnKa6GRGocPf0Z0dOYUaa66ogMvqf+/tNErXlc7F57S6wNwfVZjRaliIKhu0EpAJC1xoUr5qLmuCSKqk6DpIHhEAZXsLkF80rEfKPnAO0kpDvxXZc/06iFxPbBMHcEuf9d4+CRLWh9CPmJxW9nKDj3e6ThiEPaZGwMcbv6409DioyYD6EWme3aRXQuoNWq6eLkt7f7+XcMLYQF7O0gtS8vX/9pH7FZfd3GjKzxox3v4JsyvgQhDU/OuOFdjiR3z5bEhD+1akZpL6vdk1DudoDvU478mmBYOo5F4qTgqeC3QfIe22x5TAptg+Y4KFgbiPSZKFWqXnUeWQajhPeEQV9CZ9WQdWuzcxtSQOchjRn38E8dTO1btr/B+55c8uNUwFQHjYcFbHos7e1OC3crfYPGvykoL2AnnlY9gC93ucEOCV7vV3tQHqI5Eg1pRSYnXvqroQpmH/tyE8yLkOLvAJ4ytikE+kOH7Hw4+5rUGW/VsC6BbIvT2x/ajBKWAeJzum5+iOZ4hhr4RZDCKZqHgumZ96+MhSvcz/It9sgXtz5ujsHrqwa8rA/hfA238gF5AQ7j+Z1YsaDrrB6iogpXz1xTN5zHcQuK+BronCb9iZNN5KB9heujkVBWPfwZfRSzSvqudBHa6pjVNtGsJXN5dOrhL0wMfWNarfIRXI9O62X/4N3I/WZcYEQTqMeakCXozghfVwQx50ErkR6nAqQ/pwzby4EskEgP23TgalgEyCAeGrVP2srMkPNuZcVCB/9Lh9Xasy6lSLldajJPzTN23jU+7Fzos3tZ7Pkw2/CsYu/opMqEbLdNAl3xfyBkYoV+IsUQKMkNQpHE6r7MYkpNm75/VSp9O3p9VUN3XVzwQNWElVF78IRkgy3jo/8kC3eFeDEGZuk+PeS+UmxLX33VPflDiiK/E/SeVmm5wcAzbDIeCEM8s
 6/xxM5xx
 GQTHgJfiIsIGrESukj2l0M/j89P2z6GvrjIihlvsv0bZoMZk91j5bjVYf70tGoeDw7Rb+aHbYwm4iskYC1DMlPhfOhhowm3eqhndcxCV2BZarf7smJoXZYW/StaGaQILLncpCaXcB+Y0x6r83EeFermu6XlGG80RBFdenlR3FGdMXXz16Bulk1KR0uXlR/SQL5BuvkVWsjwUOCnrvl9erxlBAyoHd1bbMoJmEtAoFuYKdOGBI6/dUWlgB/BPkK5bVI1/uTNmPlGgKqZ8DcWs2FQ5RpN2BMIJ2iN8zsEfo+34d4RM44EVyv+vawy3cz20M8nQccR3H4hwvtphfIhy5fcuB8qHWUuDhaFJDryPiipXNXhxR7JF3+wTshSskN7xeF+cl5RWHy9dodvKJIRjIdQUG6RQZFcYDSJU4dMKV1c4tBmooXNBYWSccHwU2XB+n3uphq2Fcp3LxRVHK63WD0hI40/ox5oR97jXkPlfjyRsQhtgvNGwk62tL6Nv30ZEZqe+EPJVb5LgGROJLOz9Rhm9wIJkFs1+kuvtUGdCsYcjEWnQAw5qZjnu4aKj+uciHCcz7QjPqkYYja8lJRS49z+R+jcdqThxTraLNKf6TVg5uFyoRUbamOODxDf84za3DRSVN5BCzEq5vZkKpb2YXiGNBOBHp8BtpNlmwYOCy1FTMc6RZ+NpSqBTQQdnJGrNzfZmNd0r9umxQmX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

This is v5 of Kairui Song's swap priority queue series. Today, choosing
among swap devices of equal priority means rotating a shared plist.
With this series, each CPU advances its own position in a ring of
equal-priority devices. The allocator selects a device before looking for
slots on it. This keeps the existing global swap priorities and does not
add a tier ABI or a per-memcg device-selection policy. Memcg swap
accounting and limits are unchanged.

Thanks to Kairui and Kunwu Chan for reviewing v4. I'm dropping the RFC
tag and submitting the series for review.

Changes since v4:

- Rebased onto mm-unstable at 7d1a16abe4cc (7.4-rc3), retaining the
  upstream swap size reporting fix in swap_show() and swapon().
- Following Kairui's review, renamed swap_ring_iterator to
  swap_queue_reader_head and ring_only to no_fallback. A large folio
  can still try other devices of the same priority after an allocation
  failure, but not a lower priority.
- Following Kunwu's review, retained READ_ONCE() in the availability
  check, removed a misleading comment about slot reuse, and made both
  /proc/swaps iterators check the published swap_file under the read
  lock.
- Split the off-list bit fix into patch 10, before the queue conversion.
  The plist allocator also needs to mask that bit when checking whether
  a swap device is full.
- Revised patch 04 to distinguish all allocated descriptors from
  writable devices. drain_mmlist() needs only the usage count and no
  longer reads the flags. si_swapinfo() takes one flags snapshot when
  accounting for devices being taken offline. I have not carried the
  previous Reviewed-by on that patch.

Testing:

I ran Kairui's benchmarks on the 7.4-rc3 base (7d1a16abe4cc) before and
after applying the then-current v5 patches.

On one x86-64 host, both kernels built the same source (4dbe24720eb3)
with make -j96 and eight 8-GiB ZRAM devices. Each build used a fresh
output directory. The BRD test used twelve 8-GiB RAM disks, a 24-GiB
memcg limit and one invocation per kernel:

  usemem --init-time -O -y -x -n 32 1536M

Times are in seconds (means for kbuild).

  Workload        Runs/kernel   SYS: Before -> After      Wall: Before -> After
  kbuild, 2 GiB        12       4193.23 -> 4271.06        167.80 -> 168.80
  kbuild, 3 GiB        12       2257.60 -> 2299.63        136.29 -> 136.77
  12-BRD                1        141.16 ->  131.44          6.61 ->   6.32

Both kbuild cases used 1.86% more system CPU time; elapsed time rose by
0.60% and 0.35%, respectively. In the single BRD run, throughput
(48 GiB mapped divided by elapsed time) rose from 7436 to 7777 MiB/s
(+4.59%). There was one boot per kernel and the baseline ran first.
The BRD result alone does not establish a repeatable speedup.

v4:
https://lore.kernel.org/all/cover.1794666741.git.lianux.mm@gmail.com/
v1 and original test method:
https://lore.kernel.org/all/20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com/
Related swap tier work:
https://lore.kernel.org/all/20260916183437.2946306-1-youngjun.park@lge.com/

Best regards,
Lian Wang

---

Kairui Song (12):
  mm/swap: remove unused parameter for reading swap header
  mm/swap: clean up hibernation error handling
  mm/swap: cleanup and document swap device availability flag usage
  mm/swap: introduce swap device iteration helper
  mm/swap: change the swapon lock into a percpu rwsem
  mm/swap: serialize swap publication before removing swapon mutex
  mm/swap: consolidate swap inuse accounting helpers
  mm/swap: add priority queue for swap device allocation
  mm/swap: remove available list
  mm/swap: bound synchronous discard outside the allocation reader
  mm/swap: drop swap active plist
  lib/plist.c: remove requeue function

Lian Wang (6):
  mm/swap: avoid direct reclaim when populating swap cluster metadata
  mm/swap: mask the off-list bit when checking whether swap is full
  mm/swap: reuse per-CPU queue readers across priority changes
  mm/swap: advance the global queue cursor directly between priority
    rings
  mm/swap: skip reader rotation for single-device priority rings
  mm/swap: redistribute queue readers after membership changes

Youngjun Park (1):
  mm/swap: change back to use each swap device's percpu cluster

 include/linux/plist.h |    2 -
 include/linux/swap.h  |   45 +-
 lib/plist.c           |   71 --
 mm/swap.h             |   12 +-
 mm/swapfile.c         | 1446 ++++++++++++++++++++++++++---------------
 5 files changed, 963 insertions(+), 613 deletions(-)


base-commit: 7d1a16abe4cc5dccd21e3d6262e44433a5885d27

